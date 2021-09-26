require "tty-prompt"
require "tty-font"

class QuizView

    def initialize(history)
        @history=history
        @prompt = TTY::Prompt.new(symbols: { marker: "→" })
    end
    def welcome_menu
        clear
    options = [
      { name: "New Game", value: -> {  } },
      { name: "Custom quiz bank", value: -> {  } },
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
    end
    options.push({ name: "Back", value: -> {
        clear
        welcome_menu
      } })
      option = @prompt.select("Please select from the following options.\n\n\n", options, help: "(Select with pressing ↑/↓ arrow keys, and then pressing Enter)", show_help: :always)
    end
    
    def read_history(id)
        clear
        puts "Quiz bank name: #{@history["Records"][id-1]["Quiz_bank_name"]}
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

    def clear
        system("clear") || system("cls")
    end

end