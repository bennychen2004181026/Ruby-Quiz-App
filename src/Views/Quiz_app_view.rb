require "tty-prompt"
require "tty-font"
require_relative "../models/FileManager"

class QuizView
    include FileManager
    def initialize(history,custom)
        @history=history.history
        @custom=custom.custom_load
        @prompt = TTY::Prompt.new(symbols: { marker: "→" })
    end
    def interface
        clear
      options = [
      { name: "New Game", value: -> {  } },
      { name: "Custom quiz collections", value: -> { custom_collection } },
      { name: "History", value: -> { history_select } },
      { name: "Exit", value: -> {
        clear
        puts "Going to leave!"
        sleep(2)
        clear
        exit
        } },
       ]
      option = @prompt.select("Please select from the following options.\n\n\n", options, help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)", show_help: :always)
    end

  # History feature

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
        interface
      } })
      option = @prompt.select("Please select from the following options.\n\n\n", options, help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)", show_help: :always)
    end
    
    # History-display function

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
          option = @prompt.select("Please select Back after checking.\n\n\n", options, help: "(Pressing Enter to go back)", show_help: :always)
    end

    # Custom feature menu view

    def custom_collection
        clear
        options = [
            { name: "Add custom quiz collection", value: -> {
            add_collection
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
                interface
              } }
        ]
        option = @prompt.select("Please select from the following options:\n\n\n", options, help: "(Choose using ↑/↓ arrow keys, press Enter to select)", show_help: :always)
    end

    # Custom\Collections view

    def select_collection
        clear
        options = []
        collection_array=@custom["Custom"]
        if  @custom.size>0 and collection_array.size>0
            collection_array.each {|e|options.push({name:"Custom：#{e["Custom_Name"]}", value: -> {read_collecton(e["Custom_Id"])}})}
        else
            puts "\nSorry, counldn't read any valid date.\n\n"
        end

        options.push({ name: "Back", value: -> {
            clear
            custom_collection
          } })
          option = @prompt.select("Please select from the following options.\n\n\n", options, help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)", show_help: :always)
    end

# Custom\Collections_view\Collection 

    def read_collecton(id)
        clear
        puts "Quiz_collection_name: #{@custom["Custom"][id-1]["Custom_Name"]}\n\n\n"
        quiz_array = @custom["Custom"][id-1]["Content"]
        quiz_array.each {|e| 
            puts "#{e["Id"]}. #{e["Question"]}\n\n"
            puts "A: #{e["A"]}\n\n"
            puts "B: #{e["B"]}\n\n"
            puts "C: #{e["C"]}\n\n"
            puts "D: #{e["D"]}\n\n"
            puts "-------------------------\n\n"
        }
        options = [
            { name: "Back", value: -> {
                clear
                select_collection
              } }
          ]
        option = @prompt.select("Please select Back after checking.\n\n\n", options, help: "(Pressing Enter to go back)", show_help: :always)
    end

    # Custom\Add_collection_view
    def add_collection
        clear
        puts "---------- Add a custom collection----------\n\n"
        puts "Please provide the name of the collection:\n\n"
    end


    def validate_

    end
    def clear
        system("clear")
    end

end