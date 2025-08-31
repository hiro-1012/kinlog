// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

import WorkoutFormController from "controllers/workout_form_controller"
application.register("workout-form", WorkoutFormController)
