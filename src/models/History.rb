# frozen_string_literal: true

require_relative 'FileManager'
require 'json'
require 'date'
# History model is responsible for history record feature. It initialize reading history file method.

class History
  include FileManager
  attr_reader :history

  def initialize
    @history = FileManager.load_history
  end

  # A adding history record and save method. It accepts a parameter array which is collected any produced after the test completion.
  def add_history_and_save(array = [total_score, correct_count, incorrect_count, type, quiz_name, user_name, mode])
    if @history.nil?
      creat_empty_history
      new_history_Id = 1
    elsif @history["Records"].empty?
      new_history_Id = 1
    else
      new_history_Id = @history["Records"].map { |h| h['Id'] }.max + 1
    end
    history_array = @history["Records"]
    date = DateTime.now
    accuracy_rate = "#{((array[1] / (array[1] + array[2])) * 100).round(2)}%"
    new_history = {}
    new_history['Id'] = new_history_Id
    new_history['User_name'] = array[5]
    new_history['Type'] = array[3]
    new_history['Mode'] = array[6]
    new_history['Accuracy_rate'] = accuracy_rate
    new_history['Quiz_collection_name'] = array[4]
    new_history['Total_score'] = array[0]
    new_history['Correct'] = array[1]
    new_history['Incorrect'] = array[2]
    new_history['Date'] = date.strftime('%d/%m/%Y %H:%M')
    history_array.push(new_history)
    FileManager.save_history(@history)
    puts 'You have successfully save the history file!'
    @history
  end

  # A method to restore enmpty history hash in case user mistakenly delete the history file. Being used in the relevant rescue block.
  def creat_empty_history
    new_history = {
      "Records": []
    }
    @history = new_history
    @history
  end
end
