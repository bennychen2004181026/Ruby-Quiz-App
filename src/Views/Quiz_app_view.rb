require 'tty-prompt'
require 'tty-font'
require 'json'
require "colorize"
require 'timeout'
require_relative '../models/FileManager'

class QuizView
    include FileManager
    def initialize(history,custom,test_time)
        @history = history
        @custom = custom
        @test = test_time
        @prompt = TTY::Prompt.new(symbols: { marker: "♦" })
    end
    def interface
        clear
      options = [
      { name: "New Game", value: -> { select_mode } },
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
      option = @prompt.select("Please select from the following options.\n\n", options, help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)\n\n\n", show_help: :always)
    end

  # History feature

    def history_select
    clear
    options = []
    begin history_array =(@history.history)["Records"]
    if  @history.history.size>0 && history_array.size>0
        history_array.each {|e|options.push({name:"Record：#{e["Id"]}  Date: #{e["Date"]}", value: -> {read_history(e["Id"])}})}
    end
    rescue JSON::ParserError,NoMethodError,NoMemoryError,StandardError
    puts "Sorry, it seems the history content is empty. Please run one test from main menu with 'New Game'. Finish the game once and a new hisorty record will be created.\n\n\n"
    end
    options.push({ name: "Back", value: -> {
        interface
      } })
      option = @prompt.select("Please select from the following options.\n\n", options, help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)\n\n\n", show_help: :always,per_page:12)
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
          option = @prompt.select("Please select Back after checking.\n\n", options, help: "(Pressing Enter to go back)\n\n\n", show_help: :always)

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
                display_delete_collections
            } },
            { name: "Back", value: -> {
                clear
                interface
              } }
        ]
        option = @prompt.select("Please select from the following options:\n\n", options, help: "(Choose using ↑/↓ arrow keys, press Enter to select)\n\n\n", show_help: :always)
    end

    # Custom\Collections view

    def select_collection
        clear
        options = []
        begin collection_array=@custom.custom_load["Custom"]
        if  @custom.custom_load.size>0 and collection_array.size>0
            collection_array.each {|e|options.push({name:"Custom：#{e["Custom_Name"]}", value: -> {read_collecton(e["Custom_Id"])}})}
        else puts "Sorry,the content is empty."
        end
    rescue JSON::ParserError,NoMethodError,NoMemoryError,StandardError
       puts "It seems the custom content is empty. Please move to custom menu to add a new custom collection.\n\n\n"
    end
         

        options.push({ name: "Back", value: -> {
            clear
            custom_collection
          } })
          option = @prompt.select("Please select from the following options.\n\n", options, help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)\n\n\n", show_help: :always,per_page: 16)
    end


# Custom\Collections_view\Collection 

    def read_collecton(id)
        clear
        begin puts "Quiz_collection_name: #{@custom.custom_load["Custom"][id-1]["Custom_Name"]}\n\n\n"
        quiz_array = @custom.custom_load["Custom"][id-1]["Content"]
        quiz_array.each {|e| 
            puts "#{e["Id"]}. #{e["Question"]}\n\n"
            puts "A: #{e["A"]}\n\n"
            puts "B: #{e["B"]}\n\n"
            puts "C: #{e["C"]}\n\n"
            puts "D: #{e["D"]}\n\n"
            puts "-------------------------\n\n"
        }
    rescue JSON::ParserError,NoMethodError,NoMemoryError,StandardError
        puts "It seems the custom content is empty. Please move to custom menu to add a new custom collection.\n\n\n"
    end
        options = [
            { name: "Back", value: -> {
                clear
                select_collection
              } }
          ]
        option = @prompt.select("Please select Back after checking.\n\n", options, help: "(Pressing Enter to go back)\n\n\n", show_help: :always)
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

        begin custom_container, id = @custom.add_empty_collection(collection_name)
        rescue JSON::ParserError,NoMethodError,NoMemoryError,StandardError
           puts "It seems the custom file is corrupted.\n\n\n"
           backup_custom(collection_name)
        retry
        end
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
            right_answer = @prompt.select("Please provide the correct option of question #{i} within A, B, C, D.\n\n", options,help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)\n\n\n", show_help: :always)
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
        begin collection_array=@custom.custom_load["Custom"]
        if  @custom.custom_load.size>0 and collection_array.size>0
            collection_array.each {|e|options.push({name:"Custom：#{e["Custom_Name"]}", value: -> {edit_quiz(e["Custom_Id"])}})}
        else puts "Sorry,the content is empty."
        end
        rescue JSON::ParserError,NoMethodError,NoMemoryError,StandardError
        puts "It seems the custom content is empty. Please move to custom menu to add a new custom collection.\n\n\n"
        end
        options.push({ name: "Back", value: -> {
            clear
            custom_collection
          } })
          option = @prompt.select("Please select from the following options.\n\n", options, help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)\n\n\n", show_help: :always)
    end

    def edit_quiz(id)
        clear
        begin quiz_array = @custom.custom_load["Custom"][id-1]["Content"]
        options=[]
        if  quiz_array.size>0
            quiz_array.each {|e|options.push({name:"Question：#{e["Id"]}", value: -> {edit_single_question(id,e)}})}
        else puts "Sorry,the content is empty."
        end
    rescue JSON::ParserError,NoMethodError,NoMemoryError,StandardError
        puts "It seems the custom content is empty. Please move to custom menu to add a new custom collection.\n\n\n"
    end
        options.push({ name: "Back", value: -> {
            clear
            edit_collection
          } })
          option = @prompt.select("Please select one question to edit or turn back to upper menu.\n\n", options, help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)\n\n\n", show_help: :always)
    end

    def edit_single_question(collection_id, question)
        clear
            begin 
            puts "#{question["Id"]}. #{question["Question"]}\n"
            puts "A: #{question["A"]}\n"
            puts "B: #{question["B"]}\n"
            puts "C: #{question["C"]}\n"
            puts "D: #{question["D"]}\n"
            puts "Correct option: #{question["Right_answer"]}\n"
            puts "-------------------------\n"

        rescue JSON::ParserError,NoMethodError,NoMemoryError,StandardError
            puts "It seems the custom content is empty. Please move to custom menu to add a new custom collection.\n\n\n"
        end
            options = [
                { name: "Question Content", value: -> { edit_content(collection_id,question,"Question") } },
                { name: "Option A", value: -> { edit_content(collection_id,question,"A") } },
                { name: "Option B", value: -> {edit_content(collection_id,question,"B") } },
                { name: "Option C", value: -> { edit_content(collection_id,question,"C") } },
                { name: "Option D", value: -> { edit_content(collection_id,question,"D") } },
                { name: "Correct option", value: -> { edit_correct_option(collection_id,question,"Right_answer") } },
                { name: "Comfirm the change", value: -> {
                    @prompt.yes?("\nDo you want to comfirm the change or continue editing?") ? comfirm_edit(collection_id,question["Id"],question) : return
                  } },
                  { name: "Ignore the changes and go back to upper menu", value: -> {
                    @prompt.yes?("\nDo you really want to go back to upper menu without saving?") ? edit_quiz(collection_id) : return
                  } }
                 ]
                option = @prompt.select("Please select from the following options.", options, help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)\n\n\n", show_help: :always,per_page:8)
 

    end
     
    def edit_content(collection_id,question,question_key)
        new_value=@prompt.ask("What is your new value for #{question_key}?") do |q|
            q.required true
            q.modify   :capitalize
          end
          question[question_key]=new_value
          return edit_single_question(collection_id, question)
    end

    def edit_correct_option(collection_id,question,key_for_correct_option)
        options = ["A","B","C","D"]
     new_right_option = @prompt.select("Choose your new correct option:", options, per_page: 4)
     question[key_for_correct_option]=new_right_option
     return edit_single_question(collection_id, question)
    end

    def comfirm_edit(collection_id,question_id,question)
        new_custom=@custom.custom_load
        new_custom["Custom"][collection_id-1]["Content"][question_id-1] = question
        @custom.save_custom(new_custom)
        puts "The changes have been saved"
        @prompt.keypress("Press space or enter to continue", keys: [:space, :return])
        return edit_single_question(collection_id, question)
    end

    def display_delete_collections
        clear
        options = []
        begin custom=@custom.custom_load
        if  custom["Custom"].size>0
            custom["Custom"].each {|e|options.push({name:"Custom：#{e["Custom_Name"]}", value: -> {delete_decision(custom,e)}})}
        else puts "Sorry,the content is empty."
        end
        rescue JSON::ParserError,NoMethodError,NoMemoryError,StandardError
        puts "It seems the custom content is empty. Please move to custom menu to add a new custom collection.\n\n\n"
        end
        options.push({ name: "Back", value: -> {
            custom_collection
          } })
          option = @prompt.select("Please select one custom collection you want to delete. If you don't want to delete any thing, just select 'Back'.", options, help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)\n\n\n", show_help: :always,per_page:15)
    end

    def delete_decision(custom,collection)
        clear
        options = []
        options.push(
            { name: "Yes!!! I want to delete it so bad!!!!", value: -> {
                conduct_deletion(custom,collection)
          } },
          { name: "All right. I want to keep it there now", value: -> {
            display_delete_collections
          } })
          option = @prompt.select("The collection will be delete permanently!!! Think carefully before you act.", options, help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)\n\n\n", show_help: :always) 
    end
    def conduct_deletion(custom,collection)
        clear
        puts custom["Custom"].size
        begin new_array = custom["Custom"].reject{|e|e==collection}
            custom["Custom"]=new_array
            puts custom["Custom"].size
            if new_array.empty?
             @custom.save_custom(custom)
            elsif
                for i in 1..new_array.size
                    custom["Custom"][i-1]["Custom_Id"]=i
                   puts custom["Custom"][i-1]["Custom_Id"]
                end
                @custom.save_custom(custom)
            end
            puts "Successfully delete the collection.\n\n\n"
 
        end
        options = []
        options.push({ name: "Back", value: -> {
            display_delete_collections
          } })
          option = @prompt.select("Go back to upper menu", options, help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)\n\n\n", show_help: :always,per_page:15)
    end

    def backup_custom(add_name)
        puts "It seems the content is empty".colorize(:red) + "\nTry to establish a empty custom container".colorize(:light_black)
        hash ={"Custom":[
        ]
        }
        @custom.save_custom(hash)
    end

    def get_user_selection
        redirect_to controller: "items", action: "show", id: @item
        puts "---------- User selection----------\n\n"
        user_name = @prompt.ask("Hello, visitor! Can I have you name please?\n\n") do |input|
            input.required true
            input.validate /\A\w+\Z/
            input.modify   :capitalize
        end
        
        level_selections = [
            { name: "Easy", value: -> {
                @test.time_level["Easy"]
              } },
            { name: "Normal", value: -> {
                @test.time_level["Normal"]
              } },
            { name: "Hard", value: -> {
                @test.time_level["Hard"]
              } },
            { name: "I want to change my name. Please let me go back", value: -> {
                interface
              } },
        ]
       selection = @prompt.select("Please select one time mode for answering each question in a quiz.\nIf you can not selection a option in the limited time\nIt will be considered as false amswer", level_selections, help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)\n\n", show_help: :always,per_page:5)
       
       clear
       test_collections = [
        { name: "Default collections", value: -> {
            pick_collection("Default",user_name,selection)
          } },
        { name: "Custom collections", value: -> {
            pick_collection("Custom",user_name,selection)
          } },
        { name: "I want to change the time setting. Please let me go back to main menu", value: -> {
            interface
          } }
    ]
    test_collections= @prompt.select("Please select one group of collecctions",  test_collections, help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)\n\n", show_help: :always,per_page:3)
    end

    def get_test_collection(string,user_name,selection)
        clear
        options=[]
      if string == "Default"
        begin  default_collections_array = @test.default[string]
            default_collections_array.each {|e|options.push({name:"Default collection #{e["Default_Id"]} :#{e["Default_Name"]}\n\n", value: -> {string,e["Default_Name"],e,user_name,selection}})}
        rescue JSON::ParserError,NoMethodError,NoMemoryError,StandardError
            puts "Sorry, couldn't read the content of Default_collection file.\n"
            puts "Recreating the Default contetnt.\n\n"
            new_default = @test.default_content_setter
            @test.reset_default(new_default)
        retry
        end
      elsif string == "Custom"
        begin  custom_collections_array = @custom.custom_load[string]
            custom_collections_array.each {|e|options.push({name:"Custom collection #{e["Custom_Id"]} :#{e["Custom_Name"]}\n\n", value: -> {string,e["Custom_Name"],e,user_name,selection}})}
        rescue JSON::ParserError,NoMethodError,NoMemoryError,StandardError
            puts "Sorry, couldn't read the content of Custom_collection file.\n"
            puts "Please go back to custom menu and add new custom content.\n\n"
        end
       
      end
      options = [
        { name: "Back", value: -> {
            interface
          } }
      ]
    option = @prompt.select("Please select the quiz that you want to test or go back to main menu.\n\n", options, help: "(Pressing Enter to go back)\n\n\n", show_help: :always,per_page:10)
    end

    def test_comfirm(type,quiz_name,quiz,user_name,time)
        clear
        puts "Hello, #{user_name}. The #{quiz_name} test of #{type} collections is going to apply.\n\nThe test time of answering each question is limited to #{time}s\n\n\n"

        options =[
            { name: "Let's get started!!!!", value: -> {
                test_loop(type,quiz_name,quiz,user_name,time)
              } },
              { name: "I want to reset the test", value: -> {
                interface
              } }
        ]

        option = @prompt.select("Please comfirm that you are ready or go back to main menu to run a new test.\n\n", options, help: "(Pressing Enter to go back)\n\n\n", show_help: :always)
    end
    
    def test_loop(type,quiz_name,quiz,user_name,time)
        clear
        flag = false
        while flag = false
            total_score=0
            correct_count=0
            incorrect_count=0
            for i in 1..quiz["Content"].size do
               begin Timeout.timeout(time) do
                clear
                puts "You have get #{correct_count} correct answer(s) so far.    And the total score is #{total_score}.\n\n"

                puts "#{i}. #{quiz["Content"][i-1]["Question"]}\n\n"
                
               end
            end
        end


    end

    def clear
        system("clear")
    end

end