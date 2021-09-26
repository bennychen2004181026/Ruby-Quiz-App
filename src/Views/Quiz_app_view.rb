

class QuizView

    def initialize(object)
        @history=object
    end
    def welcome
        puts "Welcome message"
        puts
        puts "qestion  #{@history["Id"]}: #{@history["Content"]}
        #{@history["A"]}
        #{@history["B"]}
        #{@history["C"]}
        #{@history["D"]}"
    end

end