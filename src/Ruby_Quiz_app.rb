require_relative './controllers/Quiz_controller'
require_relative './models/Quiz_app_model'
require_relative './views/Quiz_app_view'

quiz_history = QuizGame.new.history_setter
quiz_custom = QuizGame.new.custom_load_setter
quiz_view = QuizView.new(quiz_history,quiz_custom)
quiz_controller=QuizController.new(quiz_history,quiz_custom,quiz_view)
quiz_controller.run