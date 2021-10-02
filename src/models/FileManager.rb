# frozen_string_literal: true

# Utilize json gem to manager my saving file.
require 'json'
# FileManager is the model which is responsible for saving and loading three different files.
module FileManager
  # Method for reading history file and past the content through history model to view class.
  def self.load_history
    history_record = File.read(File.join(File.dirname(__FILE__), '../history/history.json'))
    JSON.parse(history_record)
  rescue JSON::ParserError, NoMethodError, NoMemoryError, StandardError
  end

  # Method for reading custom collection file and past the content through custom model to view class.
  def self.load_custom
    custom_collection = File.read(File.join(File.dirname(__FILE__),
                                            '../quiz_collections/Custom_collection.json'))
    JSON.parse(custom_collection)

  # Rescue function activated when exception arises.
  rescue JSON::ParserError, NoMethodError, NoMemoryError, StandardError
  end

  # Method for reading default collection file and past the content through test model to view class.
  def self.load_default
    default_collection = File.read(File.join(File.dirname(__FILE__),
                                             '../quiz_collections/Default_collection.json'))
    JSON.parse(default_collection)

  # Rescue function activated when exception arises.
  rescue JSON::ParserError, NoMethodError, NoMemoryError, StandardError
  end

  # Method for receive the custom json content and utilize json gem to write in save file.
  def self.save_custom(hash)
    File.write(File.join(File.dirname(__FILE__), '../quiz_collections/Custom_collection.json'), JSON.dump(hash))
  rescue StandardError, IOError
  end

  # Method for receive the default json content and utilize json gem to write in save file.
  def self.save_default(hash)
    File.write(File.join(File.dirname(__FILE__), '../quiz_collections/Default_collection.json'), JSON.dump(hash))
  rescue StandardError, IOError
  end

  # Method for receive the history json content and utilize json gem to write in save file.
  def self.save_history(hash)
    File.write(File.join(File.dirname(__FILE__), '../history/history.json'), JSON.dump(hash))
  rescue StandardError, IOError
  end
end
