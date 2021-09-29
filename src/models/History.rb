require_relative 'FileManager'
require 'json'
class History
    include FileManager
    attr_reader :history
    def initialize()
        @history=FileManager.load_history
    end

end

a= History.new.history
puts a["Records"]