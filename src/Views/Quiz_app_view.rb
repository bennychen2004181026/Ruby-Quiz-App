# All the required gems about format and styling.
# The timeout is required when implement the time out workaround behavior in quiz test feature. This avoids the single thread problem.
require 'tty-prompt'
require 'tty-font'
require 'json'
require 'colorize'
require 'timeout'
require 'ruby_figlet'

# The view class that in charge of all displaying content and logic.
# Depend on content being delivered from models and the gems being required, logics are implemented to design the displaying content.

class QuizView
  # For invoking the RubyFiglet gem library
  using RubyFiglet
  # Initialize history, custom, test instance and the frequently used prompt instace from tty-prompt gem.
  def initialize(history, custom, test_object)
    @history = history
    @custom = custom
    @test = test_object
    @prompt = TTY::Prompt.new(symbols: { marker: '♦' }, active_color: :cyan)
  end

  def menu_banner
    app_banner = 'Tiny Quiz App'
    puts app_banner.art!('roman').colorize(:light_cyan)
  end

  def custom_banner
    app_banner = 'Custom'
    puts app_banner.art!('roman').colorize(:light_cyan)
  end

  def history_banner
    app_banner = 'History Record'
    puts app_banner.art!('block').colorize(:light_cyan)
  end

  def test_banner
    app_banner = 'Quiz Test'
    puts app_banner.art!('roman').colorize(:light_cyan)
  end

  def result_banner
    app_banner = 'Hooray!!!'
    puts app_banner.art!('rowancap').colorize(:light_cyan)
  end

  def timeout_banner
    app_banner = 'Oops...'
    puts app_banner.art!('jazmine').colorize(:light_cyan)
  end

  def exit_banner
    app_banner = 'Thank you for using this app!'
    puts app_banner.art!('bubble').colorize(:light_cyan)
  end

  # The landing and main menu, providing accesses to three features and a exit access.
  def interface
    clear
    menu_banner
    puts
    options = [
      { name: 'New Game', value: -> { get_user_selection } },
      { name: 'Custom quiz collections', value: -> { custom_collection } },
      { name: 'History', value: -> { history_select } },
      { name: 'Exit', value: lambda {
                               clear
                               exit_banner
                               exit
                             } }
    ]
    option = @prompt.select("Please select from the following options.\n\n", options,
                            help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)\n\n", show_help: :always)
  end

  # History feature(display all the existing history record to allow user to select one of them to browse further.)

  def history_select
    clear
    history_banner
    puts
    options = []
    begin history_array = (@history.history)['Records']
          if @history.history.size > 0 && history_array.size > 0
            history_array.each do |e|
              options.push({ name: "Record：#{e['Id']}  Date: #{e['Date']}\n\n", value: lambda {
                                                                                         read_history(e['Id'])
                                                                                       } })
            end
          end
    # Handle exception in case the history file is empty or corrupted. Prompting user to run a new test and finish and a new record will be produced and saved.
    rescue JSON::ParserError, NoMethodError, NoMemoryError, StandardError
      puts "Sorry, it seems the history content is empty. Please run one test from main menu with 'New Game'. Finish the game once and a new hisorty record will be created.\n\n\n"
    end
    # Always provide access for going back to upper menu.
    options.push({ name: 'Back', value: lambda {
                                          interface
                                        } })
    option = @prompt.select("Please select from the following options.\n\n", options,
                            help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)\n\n", show_help: :always, per_page: 12)
  end

  # Single History-display function. Reading content from history file and display the values corrsponding to specific keys.

  def read_history(id)
    clear
    history_banner
    puts
    puts "----------Record-------------\n\n"
    puts "Play\'s name" + ' ' * (30 - "Play\'s name".length) + (@history.history['Records'][id - 1]['User_name']).to_s.colorize(:light_blue)
    puts 'Collection Name' + ' ' * (30 - 'Collection Name'.length) + (@history.history['Records'][id - 1]['Quiz_collection_name']).to_s.colorize(:light_cyan)
    puts 'Collection Type' + ' ' * (30 - 'Collection Type'.length) + (@history.history['Records'][id - 1]['Type']).to_s.colorize(:light_magenta)
    puts 'Accuracy Rate' + ' ' * (30 - 'Accuracy Rate'.length) + (@history.history['Records'][id - 1]['Accuracy_rate']).to_s.colorize(:light_yellow)
    puts 'Correct Count' + ' ' * (30 - 'Correct Count'.length) + (@history.history['Records'][id - 1]['Correct']).to_s.colorize(:light_blue)
    puts 'Incorrect Count' + ' ' * (30 - 'Incorrect Count'.length) + (@history.history['Records'][id - 1]['Incorrect']).to_s.colorize(:light_cyan)
    puts 'Accomplished Date' + ' ' * (30 - 'Accomplished Date'.length) + "#{@history.history['Records'][id - 1]['Date']}\n\n".colorize(:light_magenta)

    # Access to upper menu
    options = [
      { name: 'Back', value: lambda {
                               clear
                               history_select
                             } }
    ]
    option = @prompt.select("Please select Back after checking.\n\n", options,
                            help: "(Pressing Enter to go back)\n\n", show_help: :always)
  end

  # Custom feature menu view

  def custom_collection
    clear
    custom_banner
    puts
    options = [
      { name: 'Add custom quiz collection', value: lambda {
                                                     add_collection
                                                   } },
      { name: 'Check out custom quiz collection', value: lambda {
                                                           select_collection
                                                         } },
      { name: 'Edit a quiz collection', value: lambda {
        edit_collection
      } },
      { name: 'Delete a quiz collection', value: lambda {
        display_delete_collections
      } },
      { name: 'Back', value: lambda {
                               clear
                               interface
                             } }
    ]
    option = @prompt.select("Please select from the following options:\n\n", options,
                            help: "(Choose using ↑/↓ arrow keys, press Enter to select)\n\n", show_help: :always)
  end

  # Custom\Display all Collections view

  def select_collection
    clear
    custom_banner
    puts
    options = []
    begin collection_array = @custom.custom_load['Custom']
          if @custom.custom_load.size > 0 and collection_array.size > 0
            collection_array.each do |e|
              options.push({ name: "Custom：#{e['Custom_Name']}", value: lambda {
                                                                          read_collecton(e['Custom_Id'])
                                                                        } })
            end
          else
            puts 'Sorry,the content is empty.'
          end
      # Handle exception and prompt user to the add custom option to create new collection and save
    rescue JSON::ParserError, NoMethodError, NoMemoryError, StandardError
      puts "It seems the custom content is empty. Please move to custom menu to add a new custom collection.\n\n\n"
    end

    options.push({ name: 'Back', value: lambda {
                                          clear
                                          custom_collection
                                        } })
    option = @prompt.select("Please select from the following options.\n\n", options,
                            help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)\n\n", show_help: :always, per_page: 16)
  end

  # Custom\Collections_view\Display the selected collection content

  def read_collecton(id)
    clear
    begin puts "Quiz_collection_name: #{@custom.custom_load['Custom'][id - 1]['Custom_Name']}\n\n\n"
          quiz_array = @custom.custom_load['Custom'][id - 1]['Content']
          quiz_array.each do |e|
            puts "#{e['Id']}. #{e['Question']}\n\n".colorize(:light_magenta)
            puts "A: #{e['A']}"
            puts "B: #{e['B']}"
            puts "C: #{e['C']}"
            puts "D: #{e['D']}"
            puts "-------------------------\n\n".colorize(:light_cyan)
          end
    rescue JSON::ParserError, NoMethodError, NoMemoryError, StandardError
      puts "It seems the custom content is empty. Please move to custom menu to add a new custom collection.\n\n\n"
    end
    options = [
      { name: 'Back', value: lambda {
                               clear
                               select_collection
                             } }
    ]
    option = @prompt.select("Please select Back after checking.\n\n", options,
                            help: "(Pressing Enter to go back)\n\n", show_help: :always)
  end

  # Custom\Add_collection_view
  def add_collection
    clear
    custom_banner
    puts
    puts "---------- Add a custom collection----------\n\n"
    # Get the collection name inout from user for future use
    collection_name = @prompt.ask("Please provide the name of the collection:\n\n") do |input|
      input.required true
      input.validate(/\A\w+\Z/)
      input.modify   :capitalize
      input.messages[:valid?] =
        'My dear friend, only letters, numbers and underscore are allowed. Please try again.'
    end
    # In case the file reading is failed, rescue block invoke the restore method to create a empty container.
    begin custom_container, id = @custom.add_empty_collection(collection_name)
    rescue JSON::ParserError, NoMethodError, NoMemoryError, StandardError
      puts "It seems the custom file is corrupted.\n\n\n"
      backup_custom(collection_name)
      retry
    end
    # Get the limited range number of questions in a collection from user to identify the size of collection.
    quiz_number = @prompt.ask("Please provide the number of quizs in the collection in range: 6-15\n\n",
                              required: true) do |input|
      input.convert(:int, 'I need a integer, my friend.')
      input.in('6-15')
      input.messages[:range?] = 'An Integer between 6 to 15 both inclusively please'
    end
    # According the number, perform obtaining required informations loop to fill all the question content
    (1..quiz_number).each do |i|
      # Prepare a arguments array for future use
      args_array = []
      # Get question content, option a, b, c and d content from user
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

      # Get the correcct answer input from user
      options = { A: 'A', B: 'B', C: 'C', D: 'D' }
      right_answer = @prompt.select("Please provide the correct option of question #{i} within A, B, C, D.\n\n",
                                    options, help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)\n\n", show_help: :always)
      # Fill the arguments array
      args_array.push(right_answer)
      args_array.push(i)
      args_array.push(custom_container)
      all_args = args_array.push(id)
      # Using splat operator to turn the array into arguments
      custom_container = @custom.fill_empty_collection(*all_args)
      enter_to_continue
      clear
    end
    # helper
    save_custom_file(custom)
    # Go back to upper menu automatically
    select_collection
  end

  # Custom feature\allow user edit specific collection content
  def edit_collection
    clear
    custom_banner
    puts
    options = []
    # In case the file is corrupted or empty, useing rescue to handle exception and prompt user to go back to create a new custom object and save.
    begin collection_array = @custom.custom_load['Custom']
          if @custom.custom_load.size > 0 and collection_array.size > 0
            # According to the custom id, pass the custom id argument to edit_quiz method
            collection_array.each do |e|
              options.push({ name: "Custom：#{e['Custom_Name']}", value: lambda {
                                                                          edit_quiz(e['Custom_Id'])
                                                                        } })
            end
          else
            puts 'Sorry,the content is empty.'
          end
    rescue JSON::ParserError, NoMethodError, NoMemoryError, StandardError
      puts "It seems the custom content is empty. Please move to custom menu to add a new custom collection.\n\n"
    end
    # Provide go back access
    options.push({ name: 'Back', value: lambda {
                                          clear
                                          custom_collection
                                        } })
    option = @prompt.select("Please select from the following options.\n\n", options,
                            help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)\n\n\n", show_help: :always)
  end

  # Receive the custom id and read each question item and prompt user to select specific question to edit
  def edit_quiz(id)
    clear
    custom_banner
    puts
    # In case the file is corrupted or empty, useing rescue to handle exception and prompt user to go back to create a new custom object and save.
    begin quiz_array = @custom.custom_load['Custom'][id - 1]['Content']
          options = []
          if quiz_array.size > 0
            # Passing the custom id and selecting question item to edit_single_question method
            quiz_array.each do |e|
              options.push({ name: "Question：#{e['Id']}", value: lambda {
                                                                   edit_single_question(id, e)
                                                                 } })
            end
          else
            puts 'Sorry,the content is empty.'
          end
    rescue JSON::ParserError, NoMethodError, NoMemoryError, StandardError
      puts "It seems the custom content is empty. Please move to custom menu to add a new custom collection.\n\n\n"
    end
    # Provide go back access
    options.push({ name: 'Back', value: lambda {
                                          clear
                                          edit_collection
                                        } })
    option = @prompt.select("Please select one question to edit or turn back to upper menu.\n\n", options,
                            help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)\n\n\n", show_help: :always)
  end

  # Reading the selected question
  def edit_single_question(collection_id, question)
    clear
    begin
      puts "#{question['Id']}. #{question['Question']}\n"
      puts "A: #{question['A']}\n"
      puts "B: #{question['B']}\n"
      puts "C: #{question['C']}\n"
      puts "D: #{question['D']}\n"
      puts "Correct option: #{question['Right_answer']}\n"
      puts "-------------------------\n".colorize(:light_cyan)
    rescue JSON::ParserError, NoMethodError, NoMemoryError, StandardError
      puts "It seems the custom content is empty. Please move to custom menu to add a new custom collection.\n\n\n"
    end
    # Passing the inheritance arguments plus corresponding keys to edit the content
    options = [
      { name: 'Question Content', value: -> { edit_content(collection_id, question, 'Question') } },
      { name: 'Option A', value: -> { edit_content(collection_id, question, 'A') } },
      { name: 'Option B', value: -> { edit_content(collection_id, question, 'B') } },
      { name: 'Option C', value: -> { edit_content(collection_id, question, 'C') } },
      { name: 'Option D', value: -> { edit_content(collection_id, question, 'D') } },
      { name: 'Correct option', value: -> { edit_correct_option(collection_id, question, 'Right_answer') } },
      { name: 'Comfirm the change', value: lambda {
                                             @prompt.yes?("\nDo you want to comfirm the change or continue editing?") ? comfirm_edit(collection_id, question['Id'], question) : return
                                           } },
      { name: 'Ignore the changes and go back to upper menu', value: lambda {
                                                                       @prompt.yes?("\nDo you really want to go back to upper menu without saving?") ? edit_quiz(collection_id) : return
                                                                     } }
    ]
    option = @prompt.select('Please select from the following options.', options,
                            help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)\n\n\n", show_help: :always, per_page: 8)
  end

  # This method receive and validate the input and assign it to new content then pass back the edit_single_question method
  def edit_content(collection_id, question, question_key)
    new_value = @prompt.ask("What is your new value for #{question_key}?") do |q|
      q.required true
      q.modify :capitalize
    end
    question[question_key] = new_value
    edit_single_question(collection_id, question)
  end

  # Because the validation of correct option is differ with rest key. It requires one of the four options, so indiviual validateion and assign method apply to it.
  def edit_correct_option(collection_id, question, key_for_correct_option)
    options = %w[A B C D]
    new_right_option = @prompt.select('Choose your new correct option:', options, per_page: 4)
    question[key_for_correct_option] = new_right_option
    edit_single_question(collection_id, question)
  end

  # This sub method of edit_single_question menu will inherit the required arguments and comfirm and save the changes
  def comfirm_edit(collection_id, question_id, question)
    new_custom = @custom.custom_load
    new_custom['Custom'][collection_id - 1]['Content'][question_id - 1] = question
    save_custom_file(new_custom)
    enter_to_continue
    edit_single_question(collection_id, question)
  end

  # This sub feature of custom feature will allow user to delete specific collection
  def display_delete_collections
    clear
    custom_banner
    puts
    options = []
    # Try to read the collection object and if error arise prompt user to add collecction feature
    begin custom = @custom.custom_load
          if custom['Custom'].size > 0
            custom['Custom'].each do |e|
              options.push({ name: "Custom：#{e['Custom_Name']}", value: lambda {
                                                                          delete_decision(custom, e)
                                                                        } })
            end
          else
            puts 'Sorry,the content is empty.'
          end
    rescue JSON::ParserError, NoMethodError, NoMemoryError, StandardError
      puts "It seems the custom content is empty. Please move to custom menu to add a new custom collection.\n\n\n"
    end
    options.push({ name: 'Back', value: lambda {
                                          custom_collection
                                        } })
    option = @prompt.select(
      "Please select one custom collection you want to delete. If you don't want to delete any thing, just select 'Back'.", options, help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)\n\n\n", show_help: :always, per_page: 15
    )
  end

  # Receive the custom object and collection object to perform deletion process
  def delete_decision(custom, collection)
    clear
    custom_banner
    puts
    options = []
    options.push(
      # Comfirm the decision again!
      { name: 'Yes!!! I want to delete it so bad!!!!', value: lambda {
                                                                conduct_deletion(custom, collection)
                                                              } },
      # This option provide access to go back if user pull back
      { name: 'All right. I want to keep it there now', value: lambda {
        display_delete_collections
      } }
    )
    option = @prompt.select(
      'The collection will be delete permanently!!! Think carefully before you act.'.colorize(:blue).colorize(background: :red), options, help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)\n\n\n", show_help: :always
    )
  end

  # Perform deletion process according the arguments received
  def conduct_deletion(custom, collection)
    clear
    custom_banner
    puts
    # Perform reject method on the custom array and save the new array
    new_array = custom['Custom'].reject { |e| e == collection }
    custom['Custom'] = new_array

    # Apply helper method
    if new_array.empty?
      save_custom_file(custom)
      puts 'Successfully detele the collection!'
    elsif (1..new_array.size).each do |i|
            custom['Custom'][i - 1]['Custom_Id'] = i
          end
      save_custom_file(custom)
      puts 'Successfully detele the collection!'
    end

    # Provide access to go back
    options = []
    options.push({ name: 'Back', value: lambda {
                                          display_delete_collections
                                        } })
    option = @prompt.select('Go back to upper menu', options,
                            help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)\n\n\n", show_help: :always, per_page: 15)
  end

  # helper to recreate a empty custom container and save
  def backup_custom(_add_name)
    puts 'It seems the content is empty'.colorize(:red) + "\nTry to establish a empty custom container".colorize(:light_black)
    hash = { "Custom": [] }
    # helper
    save_custom_file(hash)
  end

  # Important feature --test feature which every quiz app should have. This entry method is for getting the necessary inputs from users
  def get_user_selection
    clear
    test_banner
    puts
    puts "---------- User selection----------\n\n"
    # First get the name to represent the user
    user_name = @prompt.ask("Hello, visitor! Can I have you name please?\n\n") do |input|
      input.required true
      input.validate(/\A\w+\Z/)
      input.modify   :capitalize
      input.messages[:valid?] =
        'My dear friend, only letters, numbers and underscore are allowed. Please try again.'
    end
    clear
    test_banner
    puts
    # Get the time attribute from the test model
    level_selections = [
      { name: 'Easy: 16s', value: lambda {
                                    @test.time_level[:Easy]
                                  } },
      { name: 'Normal: 12s', value: lambda {
                                      @test.time_level[:Normal]
                                    } },
      { name: 'Hard: 8s', value: lambda {
                                   @test.time_level[:Hard]
                                 } },
      { name: 'I want to change my name. Please let me go back', value: lambda {
                                                                          interface
                                                                        } }
    ]
    selection = @prompt.select(
      "Please select one time mode for answering each question in a quiz.\nIf you can not selection a option in the limited time\nIt will be considered as false amswer".colorize(:light_magenta), level_selections, help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)\n\n", show_help: :always, per_page: 5
    )

    clear
    test_banner
    puts
    # Choose default or custom collections
    test_collections = [
      { name: 'Default collections', value: lambda {
                                              pick_collection('Default', user_name, selection)
                                            } },
      { name: 'Custom collections', value: lambda {
                                             pick_collection('Custom', user_name, selection)
                                           } },
      { name: 'I want to change the time setting. Please let me go back to main menu', value: lambda {
                                                                                                interface
                                                                                              } }
    ]
    test_collection = @prompt.select('Please select one group of collecctions', test_collections,
                                     help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)\n\n", show_help: :always, per_page: 3)
  end

  # Display all the collections according to different type and select one
  def pick_collection(string, user_name, selection)
    clear
    options = []
    # Pasting all required attributes to next method
    if string == 'Default'
      begin  default_collections_array = @test.default[string]
             default_collections_array.each do |e|
               options.push({ name: "Default collection #{e['Default_Id']} :#{e['Default_Name']}\n\n", value: lambda {
                                                                                                                test_comfirm(string, e['Default_Name'], e, user_name, selection)
                                                                                                              } })
             end
      # In case the default file is corrupted, receive default content from test model
      rescue JSON::ParserError, NoMethodError, NoMemoryError, StandardError
        puts "Sorry, couldn't read the content of Default_collection file.\n"
        puts "Recreating the Default contetnt.\n\n"
        new_default = @test.default_content_setter
        @test.reset_default(new_default)
        retry
      end
    elsif string == 'Custom'
      begin  custom_collections_array = @custom.custom_load[string]
             custom_collections_array.each do |e|
               options.push({ name: "Custom collection #{e['Custom_Id']} :#{e['Custom_Name']}\n\n", value: lambda {
                                                                                                             test_comfirm(string, e['Custom_Name'], e, user_name, selection)
                                                                                                           } })
             end
      # In case counldn't read custom file prompt user to go back to add new custom content.
      rescue JSON::ParserError, NoMethodError, NoMemoryError, StandardError
        puts "Sorry, couldn't read the content of Custom_collection file.\n"
        puts "Please go back to custom menu and add new custom content.\n\n"
      end

    end
    # Provide access to go back even if the reading file failed
    options.push([
                   { name: 'Back', value: lambda {
                                            interface
                                          } }
                 ])
    option = @prompt.select("Please select the quiz that you want to test or go back to main menu.\n\n", options,
                            help: "(Pressing Enter to go back)\n\n", show_help: :always, per_page: 10)
  end

  # Comfirm all the required attributes and get consent to start playing
  def test_comfirm(type, quiz_name, quiz, user_name, time)
    clear
    test_banner
    puts
    puts "Hello, #{user_name}. The #{quiz_name} test of #{type} collections is going to apply.\n\nThe test time of answering each question is limited to #{time}s\n\n"
    # Provide regret access
    options = [
      { name: "Let's get started!!!!", value: lambda {
                                                test_loop(type, quiz_name, quiz, user_name, time)
                                              } },
      { name: 'I want to reset the test', value: lambda {
                                                   interface
                                                 } }
    ]

    option = @prompt.select("Please comfirm that you are ready or go back to main menu to run a new test.\n\n",
                            options, help: "(Pressing Enter to go back)\n\n", show_help: :always)
  end

  # The test loop for each question in timeout manner with all the necessary attributes.
  def test_loop(type, quiz_name, quiz, user_name, time)
    clear
    # Initialize the array container for all necessary arguments
    status = []
    total_score = 0
    correct_count = 0
    incorrect_count = 0
    status.push(total_score).push(correct_count).push(incorrect_count)
    # Loop the length of the quiz collection times to finish the test
    (1..quiz['Content'].size).each do |i|
      # Workaround timeout method by using the timeout libray in Ruby which automatically terminate the previous thread in a setting time
      Timeout.timeout(time) do
        clear
        # Get the start time stamp for future score calculation
        start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        # Displaying the question content and prompt for selection
        puts '-------------------Time is ticking:D---------------------------'.colorize(:light_magenta)
        puts 'You have get ' + (status[1]).to_s.colorize(:light_yellow) + ' correct answer(s) so far.    And the total score is' + " #{status[0]}.\n\n".colorize(:light_blue)
        puts "Question #{i}.".colorize(:blue) + " #{quiz['Content'][i - 1]['Question']}\n\n"
        right_answer = quiz['Content'][i - 1]['Right_answer']
        # According to the selection, invoke the vailidat_answer method and pass necessary attributes
        current = Thread.current
        options = [
          { name: "A. #{quiz['Content'][i - 1]['A']}", value: lambda {
                                                                Thread.new {validate_answer('A', right_answer, status, start_time, time)}.join
                                                                current.kill
                                                              } },
          { name: "B. #{quiz['Content'][i - 1]['B']}", value: lambda {
                                                                Thread.new {validate_answer('B', right_answer, status, start_time, time)}.join
                                                                current.kill
                                                              } },
          { name: "C. #{quiz['Content'][i - 1]['C']}", value: lambda {
            Thread.new { validate_answer('C', right_answer, status, start_time, time)}.join
            current.kill
                                                              } },
          { name: "D. #{quiz['Content'][i - 1]['D']}", value: lambda {
            Thread.new { validate_answer('D', right_answer, status, start_time, time)}.join
            current.kill
                                                              } }
        ]
        option = option = @prompt.select(
          "Please select the answer as fast as you can to gain more score.\nIf you select wrong answer or time expired, you will not get the score for Question #{i}", options, help: "(Pressing Enter to go back)\n\n\n", show_help: :always, per_page: 4
        )
      end
      # If time expired, then apply the following logic to assian attribute to validate method
    rescue Timeout::Error
      clear
      timeout_banner
      puts
      puts "\n\nOh, no!!! The #{time}s haven been passed."
      start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      right_answer = quiz['Content'][i - 1]['Right_answer']
      validate_answer('expired', right_answer, status, start_time, time)
    end
    clear
    test_banner
    puts
    puts "Well done, My friend. You did a great job! Let's see waht the results is."
    enter_to_continue
    mode = @test.time_level.key(time)
    # Gather all the necessary attributes and form a array
    status.push(type).push(quiz_name).push(user_name).push(mode)
    # After finsih the test loop, pass attribute array to display result and save method
    dispaly_result_and_save(status)
  end

  # Display the results
  def dispaly_result_and_save(array)
    clear
    result_banner
    puts
    puts "#{array[5]}, your totaly score is #{array[0]}.\n\n"

    # Save the result to history file by invoking the method in history model
    @history.add_history_and_save(array)

    # Provide exit to main menu
    options = [
      { name: 'Finish and go back to main menu', value: lambda {
                                                          interface
                                                        } }
    ]
    option = @prompt.select('Thanks for playing, you can go back to main menu', options,
                            help: "(Pressing Enter to go back)\n\n\n", show_help: :always)
  end

  # This helper is for validate the answer, udate the status attributes and display encouraging words for user
  def validate_answer(answer, right_answer, status, start_time, time)
    case answer
    when right_answer
      # Get the stop time stamp to calculate the score, the faster to get the answer, the more bounds score is earned.
      answer_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      time_used = (answer_time - start_time).round(1)
      # Basic socre for each corrent answer is 500
      total_score = 500 + (time - time_used) * 10
      # Update the score and pass back to the loop
      status[0] += total_score
      status[1] += 1
      puts 'Hooray!!! You got it!!'

    else
      puts "It's fine. Let's keep going"
      status[2] += 1
    end
    enter_to_continue
  end

  # helper for save the custom file
  def save_custom_file(custom)
    # Save the result to custom file
    @custom.save_custom(custom)
  # In case the wrting file process failed, inform user
  rescue StandardError, IOError
    puts 'Oops, some thing wrong with the saving process.'
  end

  # Helper to add some gap between key pressing
  def enter_to_continue
    @prompt.keypress('Press space or enter to continue', keys: %i[space return])
  end

  # Helper to clear the screen
  def clear
    system('clear')
  end
end
