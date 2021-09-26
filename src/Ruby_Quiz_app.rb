require_relative './controllers/Quiz_controller'
require_relative './models/Quiz_app_model'
require_relative './views/Quiz_app_view'

quiz_model = QuizGame.new.history_setter
quiz_view = QuizView.new(quiz_model)
quiz_controller=QuizController.new(quiz_model, quiz_view)
quiz_controller.run