require_relative 'FileManager'
require 'json'
class Custom
    include FileManager
    attr_reader :custom
    def initialize()
        @custom
    end
   def custom_load
    @custom=FileManager.load_custom
    return @custom
   end
   def custom_add(custom_name,question_content,a,b,c,d,right_answer)
   custom_json=FileManager.load_custom
   if custom_json==nil
    puts "Oh, it seeems you get nothing from the custom collection file"
    
   end

   end
end
