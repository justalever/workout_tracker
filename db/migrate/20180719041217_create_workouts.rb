class CreateWorkouts < ActiveRecord::Migration[5.2]
  def change
    create_table :workouts do |t|
      t.string :title
      t.datetime :date

      t.timestamps
    end
  end
end
