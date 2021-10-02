require_relative './controllers/Quiz_controller'
require_relative './models/Quiz_app_model'
require_relative './views/Quiz_app_view'
require 'optparse'
require 'colorize'
quiz_history = QuizGame.new.history
quiz_custom = QuizGame.new.custom
quiz_test = QuizGame.new.test
quiz_view = QuizView.new(quiz_history,quiz_custom,quiz_test)
quiz_controller=OpeningOptions.new(quiz_history,quiz_custom,quiz_test,quiz_view)


VERSION = "0.1.0"

if ARGV.empty?
    ARGV[0] = "-m"
  end
  
  options = {}
  parser = OptionParser.new do |opts|
    opts.banner = 'Welcome to the Bookit app help menu'.colorize(:bue)
  
    opts.on('-v', '--version', 'Display the version') do
      puts "The Version of my Ruby Quiz app is #{VERSION}".colorize(:blue) 
    end
  
    opts.on('-h', '--help', 'Display the help information') do
      puts opts
      exit
    end
  
    opts.on('-t', '--test', 'Run the quiz test.') do
        caller = quiz_controller.run_test
      exit
    end
  
      opts.on('-a', '--addcustom', 'Add a custom quiz collection.') do
        caller = quiz_controller.add_custom
      exit
    end
  
      opts.on('-d', '--displaycustom', "Display existing custom collections") do
        caller = quiz_controller.display_custom
      exit
    end
    opts.on('-r', '--records', "Display history of test records") do
        caller = quiz_controller.records
        exit
      end
  
    opts.on('-m', '--main', 'Run the Quiz app') do
      caller = quiz_controller.run
    end
  end
  
  parser.parse!