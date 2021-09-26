
module FileManager
    def self.load_history()
        history_record = File.read(File.join(File.dirname(__FILE__), "../history/history.json"))
        history_json = JSON.parse(history_record)
        return history_json
    end
end

