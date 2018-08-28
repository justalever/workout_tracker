// app/javascript/application.js
import Vue from 'vue/dist/vue.esm'
import VueResource from 'vue-resource'

Vue.use(VueResource)

document.addEventListener('turbolinks:load', () => {
  Vue.http.headers.common['X-CSRF-Token'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

  var element = document.getElementById("workout-form")

  if (element != null) {

    var id = element.dataset.id
    var workout = JSON.parse(element.dataset.workout)
    var exercises_attributes = JSON.parse(element.dataset.exercisesAttributes)
    exercises_attributes.forEach(function(exercise) { exercise._destroy = null })
    workout.exercises_attributes = exercises_attributes

    var app = new Vue({
      el: element,
      data: function() {
        return { id: id, workout: workout }
      },
      methods: {
        addExercise: function() {
          this.workout.exercises_attributes.push({
            id: null,
            name: "",
            sets: "",
            weight: "",
            _destroy: null
          })
        },

        removeExercise: function(index) {
          var exercise = this.workout.exercises_attributes[index]

          if (exercise.id == null) {
            this.workout.exercises_attributes.splice(index, 1)
          } else {
            this.workout.exercises_attributes[index]._destroy = "1"
          }
        },

        undoRemove: function(index) {
          this.workout.exercises_attributes[index]._destroy = null
        },

        saveWorkout: function() {
          // Create a new workout
          if (this.id == null) {
            this.$http.post('/workouts', { workout: this.workout }).then(response => {
              Turbolinks.visit(`/workouts/${response.body.id}`)
            }, response => {
              console.log(response)
            })

          // Edit an existing workout
          } else {
            this.$http.put(`/workouts/${this.id}`, { workout: this.workout }).then(response => {
              Turbolinks.visit(`/workouts/${response.body.id}`)
            }, response => {
              console.log(response)
            })
          }
        },

        existingWorkout: function() {
          return this.workout.id != null
        }

      }
    })

  }
})