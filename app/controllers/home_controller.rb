class HomeController < ApplicationController
  def index
    @workouts = Workout.limit(5)
  end
end
