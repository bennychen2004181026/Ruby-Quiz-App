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

   def add_empty_collection(custom_name)
    custom_json=FileManager.load_custom
   new_custom_Id = custom_json["Custom"].map{|h|h["Custom_Id"]}.max + 1
   
   new_custom= Hash.new
   new_custom["Custom_Id"]=new_custom_Id
   new_custom["Custom_Name"]=custom_name
   new_custom["Content"]=[]
   custom_json["Custom"].push(new_custom)
    return custom_json,new_custom_Id
   end

   def fill_empty_collection(question_content,a,b,c,d,right_answer,empty_collection,new_custom_Id)
    custom_json=empty_collection

   content_hash= Hash.new
   content_hash["Id"]=1
   content_hash["Question"]=question_content
   content_hash["A"]=a
   content_hash["B"]=b
   content_hash["C"]=c
   content_hash["D"]=d
   content_hash["Right_answer"]=right_answer
   custom_json["Custom"][new_custom_Id-1]["Content"].push(content_hash)
   return custom_json
   end 




end
a = Custom.new.add_empty_collection("ben")
puts a.class


