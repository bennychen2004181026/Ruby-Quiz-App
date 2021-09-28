require_relative 'History'
require_relative 'Custom'
class QuizGame
    attr_reader :history,:custom
    def initialize()
        @history
        @custom
    end
    def history_setter
        @history= History.new
        return @history
    end
    def custom_load_setter
        @custom= Custom.new
        return @custom
    end
end
