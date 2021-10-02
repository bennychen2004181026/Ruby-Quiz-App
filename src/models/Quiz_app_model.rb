# frozen_string_literal: true

# A upper model container for all other three models. It is responsible for deliver class instance to view class.
require_relative 'History'
require_relative 'Custom'
require_relative 'Test'
class QuizGame
  attr_reader :history, :custom, :test

  def initialize
    @history = History.new
    @custom = Custom.new
    @test = Test.new
  end
end
