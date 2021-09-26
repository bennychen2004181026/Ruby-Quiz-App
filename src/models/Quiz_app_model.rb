require_relative 'History'
class QuizGame
    attr_reader :history
    def initialize()
        @history
    end
    def history_setter
        history= History.new.history
        @history=history
        return @history
    end
end
