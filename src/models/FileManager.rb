
module FileManager
    def self.load_history
        history_record = File.read(File.join(File.dirname(__FILE__), "../history/history.json"))
        history_json = JSON.parse(history_record)
        return history_json
    end
    def self.load_custom
        custom_collection = File.read(File.join(File.dirname(__FILE__), "../quiz_collections/Custom_collection.json"))
        custom_record = JSON.parse(custom_collection)
        return custom_record
    end
    def self.load_default
        default_collection = File.read(File.join(File.dirname(__FILE__), "../quiz_collections/Default_collection.json"))
        default_record = JSON.parse(default_collection)
        return default_record
    end
end

