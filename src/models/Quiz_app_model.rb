require_relative 'History'
require_relative 'Custom'
class QuizGame
    attr_reader :history,:custom
    def initialize()
        @history
        @custom
    end
    def history_setter
        @history= History.new.history
        return @history
    end
    def custom_setter
        @custom= Custom.new.custom
        return @custom
    end
end
