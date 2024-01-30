# App container contains Model View Controller design
require_relative './controllers/Quiz_controller'
require_relative './models/Quiz_app_model'
require_relative './views/Quiz_app_view'
# Optparse gem for editting command arguments including help information and introduction.
# Colorize gem for styling .
require 'optparse'
require 'colorize'
# Instantiate the Model View Controller
quiz_history = QuizGame.new.history
quiz_custom = QuizGame.new.custom
quiz_test = QuizGame.new.test
quiz_view = QuizView.new(quiz_history,quiz_custom,quiz_test)
quiz_controller=OpeningOptions.new(quiz_history,quiz_custom,quiz_test,quiz_view)


VERSION = "0.1.0"
# Setting argument parameters for app command
if ARGV.empty?
    ARGV[0] = "-m"
  end
  
  options = {}
  parser = OptionParser.new do |opts|
    opts.banner = 'Welcome to my Ruby Quiz App help menu.
    This is my first project in my life, I hope it works fine:D.
    This app is designed for helping people memorizing and comprehend 
    more computer science knowledge.'.colorize(:blue)
  
    opts.on('-v', '--version', 'Display the version') do
      puts "The Version of my Ruby Quiz app is #{VERSION}".colorize(:blue) 
    end
  
    opts.on('-h', '--help', 'Display the help information') do
      puts opts
      puts "   This app contains 2 important features and one display history records feature.\n\n
   The first important features is it can play quiz test as you can image which is the fundamental function\n\n
   of every quiz app, and I add a timeout feature to limit the answer time of each question. There is three\n\n
   different level of time mode in the test. Harder the mode is, less the time is. If you couldn't answer it in\n\n
   time or select wrong answer, you won't get any score for that question. But if you get the correct answer as\n\n
   fast as you can, you can get more score according to the time you spend.\n\n
   The second important features is it allows user to manipulate their custom collections of quiz. They can add,\n\n
   delete and most importantly edit the custom collection.\n\n\n"
      exit
    end
  
    opts.on('-t', '--test', 'Run the quiz test.') do
        caller = quiz_controller.run_test
      exit
    end
  
      opts.on('-a', '--addCustom', 'Add a custom quiz collection.') do
        caller = quiz_controller.add_custom
      exit
    end
  
      opts.on('-d', '--displayCustom', "Display existing custom collections") do
        caller = quiz_controller.display_custom
      exit
    end
    opts.on('-r', '--records', "Display history of test records") do
        caller = quiz_controller.records
        exit
      end
  
    opts.on('-m', '--main', 'Run the Quiz app
        
        ') do
      caller = quiz_controller.run
    end
  end
  
  parser.parse!