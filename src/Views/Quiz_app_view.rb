require "tty-prompt"
require "tty-font"
require_relative "../models/FileManager"

class QuizView
include FileManager
    def initialize(history,custom)
        @history=history
        @custom=custom
        @prompt = TTY::Prompt.new(symbols: { marker: "→" })
    end
    def welcome_menu
        clear
    options = [
      { name: "New Game", value: -> {  } },
      { name: "Custom quiz collections", value: -> { custom_collection } },
      { name: "History", value: -> { history_select } },
      { name: "Exit", value: -> {
        clear
        puts "Thanks for playing!"
        sleep(2)
        clear
        exit
      } },
    ]
    puts options[1].class
    option = @prompt.select("Please select from the following options.\n\n\n", options, help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)", show_help: :always)
    end

    def history_select
    clear
    options = []
    if  @history.size>0 && @history["Records"].size>0
        @history["Records"].each {|e|options.push({name:"Record：#{e["Id"]}  Date: #{e["Date"]}", value: -> {read_history(e["Id"])}})}
    else
        puts "\nSorry, counldn't read any valid date.\n\n"
    end
    options.push({ name: "Back", value: -> {
        clear
        welcome_menu
      } })
      option = @prompt.select("Please select from the following options.\n\n\n", options, help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)", show_help: :always)
    end
    
    def read_history(id)
        clear
        puts "Quiz_collection_name: #{@history["Records"][id-1]["Quiz_collection_name"]}
        Accuracy_rate: #{@history["Records"][id-1]["Accuracy_rate"]}
        Accomplished date: #{@history["Records"][id-1]["Accuracy_rate"]}"
        options = [
            { name: "Back", value: -> {
                clear
                history_select
              } }
          ]
          option = @prompt.select("Please select Back if you finish checking.\n\n\n", options, help: "(Pressing Enter to go back)", show_help: :always)
    end

    def custom_collection
        clear
        choices = [
            { name: "Add custom quiz collection", value: -> {
            
            } },
            { name: "Check out custom quiz collection", value: -> {
                select_collection
            
              } },
            { name: "Edit a quiz collection", value: -> {
              
            } },
            { name: "Delete a quiz collection", value: -> {
             
            } },
            { name: "Back", value: -> {
             
                clear
                welcome_menu
              end
            } },
          ]
          choice = @prompt.select("Please select from the following options:\n\n\n", choices, help: "(Choose using ↑/↓ arrow keys, press Enter to select)", show_help: :always)
    end
    def select_collection
        clear
        options = []
        collection_array=@custom["Custom"]
        if  @custom.size>0 && collection_array.size>0 && collection_array["Content"]>0
            collection_array.each {|e|options.push({name:"Custom：#{e["Custom_Name"]}", value: -> {read_collecton(e["Custom_Id"])}})}
        else
            puts "\nSorry, counldn't read any valid date.\n\n"
        end
        options.push({ name: "Back", value: -> {
            clear
            welcome_menu
          } })
          option = @prompt.select("Please select from the following options.\n\n\n", options, help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)", show_help: :always)
    end
    def read_collecton(Custom_Id)
        clear
        puts "Quiz_collection_name: #{@custom["Custom"][Custom_Id-1]["Custom_Name"]}"
        quiz_array = @custom["Custom"][Custom_Id-1]["Content"]
        quiz_array.each {|e| 
            puts "#{e["Id"]}. #{e["Question"]}\n"
            puts "#{e["A"]}"+
        }
        options = [
            { name: "Back", value: -> {
                clear
                select_collection
              } }
          ]
          option = @prompt.select("Please select Back if you finish checking.\n\n\n", options, help: "(Pressing Enter to go back)", show_help: :always)
    end

    def clear
        system("clear") || system("cls")
    end

end