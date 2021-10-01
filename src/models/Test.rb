require_relative 'FileManager'
require 'json'

class Test
    include FileManager
    attr_reader :time_level,:default,:reset
    def initialize()
        @time_level = {
            "Easy": 20,
            "Normal": 15,
            "Hard": 10,
        }
        @default = FileManager.load_default
        @reset
    end
    def reset_default(new_default)
        FileManager.save_default(new_default)
    end

    def default_content_setter
        @reset = {
            "Default": [{
                    "Default_Id": 1,
                    "Default_Name": "AAA",
                    "Content": [{
                            "Id": 1,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        },
                        {
                            "Id": 2,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        },
                        {
                            "Id": 3,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        },
                        {
                            "Id": 4,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        },
                        {
                            "Id": 5,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        },
                        {
                            "Id": 6,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        },
                        {
                            "Id": 7,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        },
                        {
                            "Id": 8,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        },
                        {
                            "Id": 9,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        },
                        {
                            "Id": 10,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        }
                    ]
                },
                {
                    "Default_Id": 2,
                    "Default_Name": "BBB",
        
                    "Content": [{
                            "Id": 1,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        },
                        {
                            "Id": 2,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        },
                        {
                            "Id": 3,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        },
                        {
                            "Id": 4,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        },
                        {
                            "Id": 5,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        },
                        {
                            "Id": 6,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        },
                        {
                            "Id": 7,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        },
                        {
                            "Id": 8,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        },
                        {
                            "Id": 9,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        },
                        {
                            "Id": 10,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        }
                    ]
                },
                {
                    "Default_Id": 3,
                    "Default_Name": "CCC",
                    "Content": [{
                            "Id": 1,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        },
                        {
                            "Id": 2,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        },
                        {
                            "Id": 3,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        },
                        {
                            "Id": 4,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        },
                        {
                            "Id": 5,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        },
                        {
                            "Id": 6,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        },
                        {
                            "Id": 7,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        },
                        {
                            "Id": 8,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        },
                        {
                            "Id": 9,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        },
                        {
                            "Id": 10,
                            "Question": "1231",
                            "A": "1233",
                            "B": "1233",
                            "C": "1233",
                            "D": "1233",
                            "Right_answer": "A"
                        }
                    ]
                }
            ]
        }
        return {
    "Default": [{
            "Default_Id": 1,
            "Default_Name": "AAA",
            "Content": [{
                    "Id": 1,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                },
                {
                    "Id": 2,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                },
                {
                    "Id": 3,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                },
                {
                    "Id": 4,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                },
                {
                    "Id": 5,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                },
                {
                    "Id": 6,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                },
                {
                    "Id": 7,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                },
                {
                    "Id": 8,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                },
                {
                    "Id": 9,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                },
                {
                    "Id": 10,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                }
            ]
        },
        {
            "Default_Id": 2,
            "Default_Name": "BBB",

            "Content": [{
                    "Id": 1,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                },
                {
                    "Id": 2,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                },
                {
                    "Id": 3,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                },
                {
                    "Id": 4,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                },
                {
                    "Id": 5,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                },
                {
                    "Id": 6,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                },
                {
                    "Id": 7,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                },
                {
                    "Id": 8,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                },
                {
                    "Id": 9,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                },
                {
                    "Id": 10,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                }
            ]
        },
        {
            "Default_Id": 3,
            "Default_Name": "CCC",
            "Content": [{
                    "Id": 1,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                },
                {
                    "Id": 2,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                },
                {
                    "Id": 3,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                },
                {
                    "Id": 4,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                },
                {
                    "Id": 5,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                },
                {
                    "Id": 6,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                },
                {
                    "Id": 7,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                },
                {
                    "Id": 8,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                },
                {
                    "Id": 9,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                },
                {
                    "Id": 10,
                    "Question": "1231",
                    "A": "1233",
                    "B": "1233",
                    "C": "1233",
                    "D": "1233",
                    "Right_answer": "A"
                }
            ]
        }
    ]
}
return @reset
    end
end