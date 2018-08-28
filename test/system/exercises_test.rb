require "application_system_test_case"

class ExercisesTest < ApplicationSystemTestCase
  setup do
    @exercise = exercises(:one)
  end

  test "visiting the index" do
    visit exercises_url
    assert_selector "h1", text: "Exercises"
  end

  test "creating a Exercise" do
    visit exercises_url
    click_on "New Exercise"

    fill_in "Name", with: @exercise.name
    fill_in "Sets", with: @exercise.sets
    fill_in "Weight", with: @exercise.weight
    fill_in "Workout", with: @exercise.workout_id
    click_on "Create Exercise"

    assert_text "Exercise was successfully created"
    click_on "Back"
  end

  test "updating a Exercise" do
    visit exercises_url
    click_on "Edit", match: :first

    fill_in "Name", with: @exercise.name
    fill_in "Sets", with: @exercise.sets
    fill_in "Weight", with: @exercise.weight
    fill_in "Workout", with: @exercise.workout_id
    click_on "Update Exercise"

    assert_text "Exercise was successfully updated"
    click_on "Back"
  end

  test "destroying a Exercise" do
    visit exercises_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Exercise was successfully destroyed"
  end
end
