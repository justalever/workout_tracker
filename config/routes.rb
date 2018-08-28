require 'sidekiq/web'

Rails.application.routes.draw do

  resources :exercises
  class Subdomain
    def self.matches?(request)
      subdomains = %w{ www admin }
      request.subdomain.present? && !subdomains.include?(request.subdomain)
    end
  end

  constraints Subdomain do
    resources :workouts
  end

  devise_for :users
  root to: 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
