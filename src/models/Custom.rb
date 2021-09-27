require_relative 'FileManager'
require 'json'
class Custom
    include FileManager
    attr_reader :custom
    def initialize()
        @custom=FileManager.load_custom
    end

end
