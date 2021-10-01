require_relative './controllers/Quiz_controller'
require_relative './models/Quiz_app_model'
require_relative './views/Quiz_app_view'

quiz_history = QuizGame.new.history
quiz_custom = QuizGame.new.custom
quiz_test = QuizGame.new.test
quiz_view = QuizView.new(quiz_history,quiz_custom,quiz_test)
quiz_controller=QuizController.new(quiz_history,quiz_custom,quiz_test,quiz_view)
quiz_controller.run