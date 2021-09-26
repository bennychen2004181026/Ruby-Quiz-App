
module FileManager
    def self.load_history()
        history_record = JSON.parse(File.read(File.join(File.dirname(__FILE__), "../history/history.json")))
        return history_record
    end
end

