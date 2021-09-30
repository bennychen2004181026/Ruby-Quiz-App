require "tty-prompt"
require "tty-font"
require_relative "../models/FileManager"

class QuizView
    include FileManager
    def initialize(history,custom)
        @history=history
        @custom=custom
        @prompt = TTY::Prompt.new(symbols: { marker: "♦" })
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
    history_array =(@history.history)["Records"]
    if  @history.history.size>0 && history_array.size>0
        history_array.each {|e|options.push({name:"Record：#{e["Id"]}  Date: #{e["Date"]}", value: -> {read_history(e["Id"])}})}
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
        puts "Quiz_collection_name: #{@history.history["Records"][id-1]["Quiz_collection_name"]}
        Accuracy_rate: #{@history.history["Records"][id-1]["Accuracy_rate"]}
        Accomplished date: #{@history.history["Records"][id-1]["Accuracy_rate"]}"
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
              edit_collection
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
        collection_array=@custom.custom_load["Custom"]
        if  @custom.custom_load.size>0 and collection_array.size>0
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
        puts "Quiz_collection_name: #{@custom.custom_load["Custom"][id-1]["Custom_Name"]}\n\n\n"
        quiz_array = @custom.custom_load["Custom"][id-1]["Content"]
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
        collection_name = @prompt.ask("Please provide the name of the collection:\n\n") do |input|
            input.required true
            input.validate /\A\w+\Z/
            input.modify   :capitalize
          end

        custom_container, id = @custom.add_empty_collection(collection_name)

        quiz_number=@prompt.ask("Please provide the number of quizs in the collection in range: 6-15\n\n",required: true) do |input|
        input.convert(:int, "I need a integer, my friend.")
        input.in("2-15")
        input.messages[:range?] = "An Integer between 2 to 15 both inclusively please"
        end

        for i in 1..quiz_number do
            args_array=[]
            question_content = @prompt.ask("Please fill the question #{i} with content:\n", required: :true)

            args_array.push(question_content)

            answer_A = @prompt.ask("Please provide the option A of question #{i} with content:\n", required: :true)

            args_array.push(answer_A)

            answer_B = @prompt.ask("Please provide the option B of question #{i} with content:\n", required: :true)

            args_array.push(answer_B)

            answer_C = @prompt.ask("Please provide the option C of question #{i} with content:\n", required: :true)

            args_array.push(answer_C)

            answer_D = @prompt.ask("Please provide the option D of question #{i} with content:\n", required: :true)

            args_array.push(answer_D)

            
            options = {A: "A",B:"B", C:"C",D:"D"}
            right_answer = @prompt.select("Please provide the correct option of question #{i} within A, B, C, D.\n", options,help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)", show_help: :always)
            args_array.push(right_answer)
            args_array.push(i)
            args_array.push(custom_container)
            all_args =args_array.push(id)
            # Using splat operator to turn the array into arguments
            custom_container=@custom.fill_empty_collection(*all_args)
            @prompt.keypress("Press space or enter to continue", keys: [:space, :return])
            clear
        end
        @custom.save_custom(custom_container)
        select_collection
    end
    
    def edit_collection
        clear
        options = []
        collection_array=@custom.custom_load["Custom"]
        if  @custom.custom_load.size>0 and collection_array.size>0
            collection_array.each {|e|options.push({name:"Custom：#{e["Custom_Name"]}", value: -> {edit_quiz(e["Custom_Id"])}})}
        else
            puts "\nSorry, counldn't read any valid date.\n\n"
        end

        options.push({ name: "Back", value: -> {
            clear
            custom_collection
          } })
          option = @prompt.select("Please select from the following options.\n\n\n", options, help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)", show_help: :always)
    end

    def edit_quiz(id)
        clear
        quiz_array = @custom.custom_load["Custom"][id-1]["Content"]
        options=[]
        if  quiz_array.size>0
            quiz_array.each {|e|options.push({name:"Question：#{e["Id"]}", value: -> {edit_single_question(id,e)}})}
        else
            puts "\nSorry, counldn't read any valid date.\n\n"
        end
        options.push({ name: "Back", value: -> {
            clear
            edit_collection
          } })
          option = @prompt.select("Please select one question to edit or turn back to upper menu.\n\n\n", options, help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)", show_help: :always)
    end
    def edit_single_question(collection_id, question)
        clear
        flag= false
        while flag = false do
            puts "#{question["Id"]}. #{e["Question"]}\n\n"
            puts "A: #{e["A"]}\n\n"
            puts "B: #{e["B"]}\n\n"
            puts "C: #{e["C"]}\n\n"
            puts "D: #{e["D"]}\n\n"
            puts "-------------------------\n\n\n"
            options = [
                { name: "Question Content", value: -> { edit_content(question["Question"]) } },
                { name: "Option A", value: -> { edit_content(question["A"]) } },
                { name: "Option B", value: -> {edit_content(question["B"]) } },
                { name: "Option C", value: -> { edit_content(question["C"]) } },
                { name: "Option D", value: -> { edit_content(question["D"]) } },
                { name: "Correct option", value: -> { edit_content(question["A"]) } },
                { name: "Exit", value: -> {
                    @prompt.yes?("\nDo you want to exit the editing and discard changes?") ? flag = true : return
                  } },
                 ]
                option = @prompt.select("Please select from the following options.\n\n\n", options, help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)", show_help: :always)
        end
        clear
        edit_quiz(collection_id)
    end
    def clear
        system("clear")
    end

end