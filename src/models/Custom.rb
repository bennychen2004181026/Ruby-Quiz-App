# frozen_string_literal: true

require_relative 'FileManager'
require 'json'
# Custom model is responsible for custom feature in my app.
class Custom
  include FileManager
  attr_reader :custom

  def initialize
    @custom
  end

  # By including the FileManager module, custom model can easily invoke the loading custom content method from save file.
  def custom_load
    @custom = FileManager.load_custom
    @custom
  end

  # This method is responsible for prepareing a container for a new quiz collecction.
  def add_empty_collection(custom_name)
    custom_json = FileManager.load_custom
    # Two situations dealing depends on is empty or not
    new_custom_Id = if custom_json['Custom'].empty?
                      1
                    else
                      custom_json['Custom'].map { |h| h['Custom_Id'] }.max + 1
                    end
    # Insert key values pairs one by one
    new_custom = {}
    new_custom['Custom_Id'] = new_custom_Id
    new_custom['Custom_Name'] = custom_name
    new_custom['Content'] = []
    custom_json['Custom'].push(new_custom)
    [custom_json, new_custom_Id]
  end

  # This method is responible for creating single question content in a custom collection container
  def fill_empty_collection(question_content, a, b, c, d, right_answer, quiz_id, empty_collection, new_custom_Id)
    custom_json = empty_collection

    content_hash = {}
    content_hash['Id'] = quiz_id
    content_hash['Question'] = question_content
    content_hash['A'] = a
    content_hash['B'] = b
    content_hash['C'] = c
    content_hash['D'] = d
    content_hash['Right_answer'] = right_answer
    custom_json['Custom'][new_custom_Id - 1]['Content'].push(content_hash)
    @custom = custom_json
    @custom
  end

  # This method is for invoking the save method from filemanager module.
  def save_custom(custom)
    FileManager.save_custom(custom)
  end
end
