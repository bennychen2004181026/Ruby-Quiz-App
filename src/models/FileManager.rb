require 'json'
module FileManager
    def self.load_history
        begin history_record = File.read(File.join(File.dirname(__FILE__), "../history/history.json"))
        history_json = JSON.parse(history_record)
        return history_json
        rescue JSON::ParserError,NoMethodError,NoMemoryError,StandardError
        end
    end

    def self.load_custom
        begin custom_collection = File.read(File.join(File.dirname(__FILE__), "../quiz_collections/Custom_collection.json"))
        custom_record = JSON.parse(custom_collection)
        return custom_record
        rescue JSON::ParserError,NoMethodError,NoMemoryError,StandardError
        end
    end

    def self.load_default
        begin default_collection = File.read(File.join(File.dirname(__FILE__), "../quiz_collections/Default_collection.json"))
        default_record = JSON.parse(default_collection)
        return default_record
        rescue JSON::ParserError,NoMethodError,NoMemoryError,StandardError
        end
    end

    def self.save_custom(hash)
     begin 
     File.write(File.join(File.dirname(__FILE__), "../quiz_collections/Custom_collection.json"), JSON.dump(hash))
     rescue StandardError,IOError
     end
    end
    def self.save_default(hash)
     begin 
     File.write(File.join(File.dirname(__FILE__), "../quiz_collections/Default_collection.json"), JSON.dump(hash))
     rescue StandardError,IOError
     end
    end
    def self.save_history(hash)
     begin 
     File.write(File.join(File.dirname(__FILE__), "../history/history.json"), JSON.dump(hash))
     rescue StandardError,IOError
     end
    end
end

