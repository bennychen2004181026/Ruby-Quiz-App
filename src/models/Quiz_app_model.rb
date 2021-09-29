require_relative 'History'
require_relative 'Custom'
class QuizGame
    attr_reader :history,:custom
    def initialize()
        @history= History.new
        @custom= Custom.new
    end
   
end
