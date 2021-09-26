class QuizController
    def initialize(quiz_model, quiz_view)
        @quiz_model=quiz_model
        @quiz_view=quiz_view
    end
    def run

          @quiz_view.welcome_menu

    end
    

end