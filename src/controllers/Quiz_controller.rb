class QuizController
    def initialize(quiz_history,quiz_custom,quiz_test,quiz_view)
        @quiz_history=quiz_history
        @quiz_custom=quiz_custom
        @quiz_test=quiz_test
        @quiz_view=quiz_view
    end
    def run

          @quiz_view.interface

    end
    

end