![https://i.imgur.com/cBd9eM2.jpg](https://i.imgur.com/cBd9eM2.jpg)

Welcome to my 13th Let's Build: With Ruby on Rails. This build will feature a multitenancy workout app which uses a popular gem called Apartment, nested attributes, and Vue.js integration.

We'll be building a workout tracker type of app to demonstrate the multitenancy approach to a. web app with Ruby on Rails. Working locally we will utilize a `lvh.me` domain (a domain registered to point to `127.0.0.1`) to allow our app to function as it should during development. Follow along using both the written guide and videos below to learn how to take advantage of what Ruby on Rails and the multitude of gems available offer us.


### Kicking things off

I'll be referencing my [kickoff template](https://github.com/justalever/kickoff) to scaffold our new application. Be sure to star or fork it on Github. If you're following along you are free to use it and/or start from scratch. The template aids in setting up some gems we make use of a lot in this series such as [Devise](https://github.com/plataformatec/devise), [SimpleForm](https://github.com/plataformatec/simple_form), [Sidekiq](https://github.com/mperham/sidekiq), [Bulma](https://github.com/joshuajansen/bulma-rails), and more.

## A visual learner?
Check out the full blog [post with videos](https://web-crunch.com/lets-build-with-ruby-on-rails-multitenancy-workout-tracker-app/)

## Prefer the written format?
I document my entire process typically since these builds can get intense. I figured I would share the written format so you can both follow along in your preferred way as well as do a bit of code checking between my own code and yours.

#### Create the app

```bash
$ rails new workout_tracker -m template.rb
```

Add the gem to your Gemfile

```ruby
gem 'apartment'
```

Run the Apartment generator install script/migration

```bash
$ bundle exec rails generate apartment:install
```

This will create a `config/initializers/apartment.rb` initializer file.

Exclude our `User` model inside the initializer file:

```ruby
# config/initializers/apartment.rb
# Means to keep these models global to our app entirely.
config.excluded_models = %w{ User }
```

Modify the following line to the line thereafter:

```ruby
# config.tenant_names = lambda { ToDo_Tenant_Or_User_Model.pluck :database }
config.tenant_names = lambda { User.pluck :subdomain }
```

This means we find an attribute `subdomain` on the user model and use it to find the associated subdomain.

### Important Step for the User Model

Add a migration to add `subdomain` to the `User` model be sure to comment out `config.excluded_models = %w{ User }` before running the migration and migrating it after that.

```bash
$ rails g migration add_subdomain_to_users subdomain
```

This generates a migration that looks like the following:

```ruby
class AddSubdomainToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :subdomain, :string
  end
end
```

We also need to accept this parameter as a trusted source. Devise won't like it otherwise. Much like we've done with adding a name or username field in the past we can do the same with the `subdomain` field as well.

This means we need to update our `application_controller.rb` to permit the `subdomain` attribute as well as the `name` attribute we've already set up when we generated the app using my Kickoff template.

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :subdomain])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :subdomain])
    end
end
```

Next, the Apartment gem to uses some middleware between our app so it knows what subdomain to associate with any given user. It's conveniently within the initializer file we generated so there's nothing extra to do. It's worth noting that all future processes travel through this middleware.

```ruby
# config/initalizaters/apartment.rb
# no need to add this code as it was already generated
Rails.application.config.middleware.use Apartment::Elevators::Subdomain
```

Then finally migrate:

```bash
$ rails db:migrate
```

You may get the following error but don't fear:

```bash
[WARNING] - The list of tenants to migrate appears to be empty. This could mean a few things:
  1. You may not have created any, in which case you can ignore this message
  2. You've run `apartment:migrate` directly without loading the Rails environment * `apartment:migrate` is now deprecated. Tenants will automatically be migrated with `db:migrate`

Note that your tenants currently haven't been migrated. You'll need to run `db:migrate` to rectify this.
```

This mostly means that your app is generating separate schemas and databases for each "apartment". This allows the possibility of keeping on subdomain and it's data complete separate from another which is what we are after.


Go ahead and uncomment the snippet from earlier:

```ruby
# config/initializers/apartment.rb
config.excluded_models = %w{ User }
```

Next, we'll add a subdomain attribute to our user model so we can let a user define their own subdomain when they register for an account using Devise.

### Update the registration view to include the domain field

Assuming you used my Kickoff template head to the `views` folder to find the `devise` folder. Inside we want to modify a couple files to include our `subdomain` field. You can put the field anywhere inside the `simple_form_for` block. I chose right after the `:email` field.

```html
# app/views/devise/registrations/new.html.erb
...
<div class="field">
   <div class="control">
     <%= f.input :subdomain, required: true, input_html: { class: "input"}, wrapper: false, label_html: { class: "label" } %>
  </div>
</div>
...

```

For now, we won't allow a user to update their domain once they create an account so leave the code above out of the form found in `app/views/devise/registrations/edit.html.erb`.

**For now hold off creating a new user account**. We need to modify our model first.

Inside the User model add the following:

```ruby
# app/models/user.rb
class User < ApplicationRecord
  after_create :create_tenant

  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  private

    def create_tenant
      Apartment::Tenant.create(subdomain)
    end
end

```

Start your server and check out the new form at `localhost:3000/users/sign_up`:

```bash
$ rails s
```

Create a new User by signing up within the browser at `localhost:3000` and be sure to choose a subdomain you'll remember.

For this tutorial, my subdomain will be `webcrunch`.

---

Follow the rest of the tutorial here: [https://web-crunch.com/lets-build-with-ruby-on-rails-multitenancy-workout-tracker-app/](https://web-crunch.com/lets-build-with-ruby-on-rails-multitenancy-workout-tracker-app/)


Or check out my previous builds and videos on Ruby on Rails:

- [Let’s Build: With Ruby on Rails – Introduction](https://web-crunch.com/lets-build-with-ruby-on-rails-introduction/)
- [Let’s Build: With Ruby on Rails – Installation](https://web-crunch.com/lets-build-with-ruby-on-rails-installation/)
- [Let’s Build: With Ruby on Rails – Blog with Comments](https://web-crunch.com/lets-build-with-ruby-on-rails-blog-with-comments)
- [Let’s Build: With Ruby on Rails – A Twitter Clone](https://web-crunch.com/lets-build-with-ruby-on-rails-a-twitter-clone/)
- [Let’s Build: With Ruby on Rails – A Dribbble Clone](https://web-crunch.com/lets-build-dribbble-clone-with-ruby-on-rails/)
- [Let’s Build: With Ruby on Rails – Project Management App](https://web-crunch.com/lets-build-with-ruby-on-rails-project-management-app/)
- [Let’s Build: With Ruby on Rails – Discussion Forum](https://web-crunch.com/lets-build-with-ruby-on-rails-discussion-forum/)
- [Let’s Build: With Ruby on Rails – Deploying an App to Heroku](https://web-crunch.com/lets-build-with-ruby-on-rails-deploying-an-app-to-heroku/)
- [Let’s Build: With Ruby on Rails – eCommerce Music Shop](https://web-crunch.com/ruby-on-rails-ecommerce-music-shop/)
- [Let’s Build: With Ruby on Rails – Book Library App with Stripe Subscription Payments](https://web-crunch.com/lets-build-ruby-on-rails-book-library-stripe-subscription-payments/)
- [Let’s Build: With Ruby on Rails – Trade App With In-App Messaging](https://web-crunch.com/lets-build-with-ruby-on-rails-trade-app-in-app-messaging/)
