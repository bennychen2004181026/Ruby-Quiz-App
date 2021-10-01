require_relative 'History'
require_relative 'Custom'
require_relative 'Test'
class QuizGame
    attr_reader :history,:custom,:test
    def initialize()
        @history= History.new
        @custom= Custom.new
        @test=Test.new
    end
   
end
