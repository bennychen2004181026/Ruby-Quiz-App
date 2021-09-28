
module FileManager
    def self.load_history
        begin history_record = File.read(File.join(File.dirname(__FILE__), "../history/history.json"))
        history_json = JSON.parse(history_record)
        rescue ArgumentError, TypeError
        puts "Unable to read data."
        return history_json
        end
    end

    def self.load_custom
        begin custom_collection = File.read(File.join(File.dirname(__FILE__), "../quiz_collections/Custom_collection.json"))
        custom_record = JSON.parse(custom_collection)
        rescue ArgumentError, TypeError
        puts "Unable to read data."
        return custom_record
        end
    end

    def self.load_default
        begin default_collection = File.read(File.join(File.dirname(__FILE__), "../quiz_collections/Default_collection.json"))
        default_record = JSON.parse(default_collection)
        rescue ArgumentError, TypeError
        puts "Unable to read data."
        return default_record
        end
    end
end

