# Ruby Quiz Terminal App T1A3
###By Ben Chen

##### R4 [My App Repository Link](https://github.com/bennychen2004181026/Ruby-Quiz-App)

### Software Development Plan

#### R5 Purpose and Scope

1. My ruby quiz app is going to be design for running a quiz test which can help people to memorize relevant knowledge on certain subject. Because I am a rookie developer and computer science knowledge is required if I want to develop my skills, so I set the three default question banks and all questions in side are about computer science. And as well as I understand the knowledge of computer science is boundless and I can not just rely on just dozens of questions to support a quiz app. So a custom feature is required as well. The custom feature will allow user to create a new quiz collection which contains around ten question. And allow to edit the content including question content and answer content if you are not satisfy the content of your own or fix some wrong answer. It also allow user to delete the question bank you created or display. For the run quiz test feature, I will add a limited time answering feature in it. I will provide three time settings of 16s, 12s and 8s. The time elapsed pressure will push user to use their brain more frequently. By selecting the correct option faster, user gains more score in the test game. At the end of the test, the result of the test including total score, accuracy rate, the correct count of the question and all other relevant information will be save in history file. And you can review the record in the history record feature. 

&nbsp;

2. Learning computer science knowledge is obliviously an overwhelming task for most of the people. And quiz game is actually a form of game which increase some enjoyment when brainstorming. It can easily engage people and encourage interests for computer science. That why I decide to develop a quiz app to help reduce the reluctance when people try to learn massive computer science knowledge with fun.

&nbsp;

3. My quiz app target the people who want to memorize more computer science knowledge. They need a more effective way to gain some knowledge.

&nbsp;

4. When user enter the menu of this app, they will probably see the new game option and just enter it. The app then ask for name of user, and which quiz bank to run. And then is the limited time frame for each question. User will run the test with limited time and see the score grows as they get right answer. After finish the test, they can view the result in history record section and see how much improvement they might achieve. After running a couple of test they feel unsatisfied about the content because as I can’t provide more question to them and then they will notice there is a custom feature which allow them to create their own question bank. User can look up many resources to find reference and in this process they find out they effective learn stuff because it’s a voluntary studying which is way too better than force the stuff into brain. They create the quiz collections and come back to run a test on them. And they will surprise of what they had got.


#### R6 Features

**1. Run a quiz test**

The first important feature is running a quiz test game. It first collect necessary information like user name, which quiz collection of either custom quiz bank or default quiz bank and the difficulty mode which easy for longer answering time and hard for shorter answering time. All the typing input requires some validation, such as empty space as whole name is not allow. And then the logic will require the collection object being read from the corresponding save file. Here requires some exception handling rescue method in case the save file is corrupted or relevant content is empty otherwise it encounter a nil class and exception arise. Then the logic can perform a game loop base on the collection content. Each question is been displayed and prompt for selection in the loop til the end of the question content array. Each question is originally with its index in an array, so the index can be used as iterator in a loop. At the mean while the test game requires a time out feature to perform the time ticking pressure. But as we know Ruby is not a single thread language virtually. I have no clue how to perform display time counting down feature and displaying question and prompt for selection at exactly the same time. Then I find a workaround for this time limit feature. That is using timeout module which is introduced in Ruby 2.5.1. This module potentially aim to auto-terminate a long running task that if they don’t end up in a time you provided. Although I couldn’t display the counting down time but the current question answer process will be end and turn to the rescue block and I can validate the result there and iterate to next step. No matter the user select the option on time or not, all the corresponding attribute will be accumulated and be pasted to the result validation method and a new history record will be produced and being save in history file for viewing. Base on the view controller model principle, the view class will handle all the logic on displaying and get all the necessary from the history and custom model through the controller with the attribute reading syntax in the model.

&nbsp;
**2. Custom feature**

Custom feature allow user to add, edit ,delete a quiz collection. Consider if I only set one kind of quiz bank and user may mistakenly delete all the quiz collection, that will be very cringe with my test running feature because there is no content I can test. So I design a default quiz collection and a custom one. User can manipulate with the custom content as they want, but I don’t provide any access to change the default content. The data structure of the quiz is using a key value pair in a hash. Base on the type of collection, the key will be custom or default, and the value will be an array. In the array, each element represent a collection of quiz, it has id, name and content key value pairs. And the the value of content key is an array as well. It encapsulates each question as an element. And each question has id, question content, option a, b, c, d and correct option key value pairs. And I will write a module about manager the file reading and saving which being included in the custom, history and test model. The models have their own initializes and manipulate content method. The view class can receive the instances of all model class and invoke the methods inside to change , save, load and display the content. By this manner, the logic can use many hash class and array class built in method , such as hash[key], array.push() to complete the manipulation. In the file manager module, I will use json gem to parse and translate the content from or into save file. In case of custom file is corrupted or the collections array is empty because user delete all the custom banks and exception will arise, several back up methods on recreating a collection container is provided in the model.

&nbsp;
**3. Display history record feature**

Display history record is easy compared to test running and custom feature. I just need to collect all the arguments needed at the end of the test and invoke the setting method with the argument array inside the history model to form a standard record content and use the included file manager module to save the history file.

#### R7 User interaction and experience

1. Test feature

First of all, my app using tty-prompt gem to select most of the selection. It reduces lots of workload on validating the inputs in my app. But some inputs such as name and number range input are still needed to be validated by own regex expression or number in array range method to validate them.

When user new game option from main menu, screen will prompt for user name with a display message and validate their input if their input is not valid, an error message will show up and remind them the input must only have letters, numbers and underscore inside. After that, user will be prompt to select difficulty. After the time selecting, the screen will turn to the default or custom collections selecting, and if user is not satisfy the previous setting, app provide a back option as well. After selecting the certain collection, a confirmation message shows up and prompt user to hit enter to start the game. In the test game if user select right answer their score will grow and according the speed of the selecting they can gain more score. If user get wrong answer or time expired, corresponding message shows up and the score won’t grow. And then it turn to next question. After all questions being answered, it display the results and record is being save behind the screen.

1. Custom feature
   
In the custom feature, user can easily select the prompt options by applying the tty-prompt gem. But in the add custom collection part, I still need to validate a name input just I did on test feature part. And a number input of how many question in a collection and if user provide any thing but a number within 6 to 15 and error message will show up and inform user to type a integer within 6 to 15. And then the app will loop the previous number input times to prompt user to fill all the necessary content. At last, a message appears to inform user the new custom collection is added and being saved.

All the select option has basic validating to exclude the Individual empty content. After adding feature in custom, user can use tty-promt to easily view the existing custom collections and delete or editing any existing custom content. The validation of edit custom content is the same with add feature.

1. History feature

User select the history prompt option to view all the history record and a go back option is provided as well as in other feature to let user easily go back to upper menu.

#### R8 Flow chart

![Control flow diagram](../GuangJianChen_T1A3/docs/Untitled%20Diagram.drawio.png)

#### R9 Implementation plan

[Link of Development Plan](https://trello.com/b/8b2xVYOp/quiz-app-development)

The screen shots of the plan locate in docs folder in this repo.

#### R10 Help documentation 

My ruby quiz app is for the people who want to effectively memorize the computer science knowledge by play the quiz game in the app. My app also provide custom feature to allow user to make their own custom quiz collection. Throughout the custom making process, user can get advantage that when collecting their own quiz, they can practice with brain and eventually help their initial purpose. When play the quiz game, the time limited feature can provide more pressure to push user on studying.

## Installation

### Ruby

Requires Ruby 2.7.2 installed.

https://www.ruby-lang.org/en/documentation/installation/

### Dependencies
1. Once navigate to the repository src folder by
    ```
    cd src
    ```
1. By running the  ```dependencies.sh``` shell script, or
1. In the ```/src``` directory typing ```install bundler```
1. In the ```/src``` directory typing ```gem update --system```
1. In the ```/src``` directory typing ```bundle install```

- tty-prompt (Provide menu prompting)
- colorize (provide color output text)
- json (using json format to record and parse data)
- ruby_figlet (provide graphical like banner)
- rspec (to test models)
- optparse (to provide arguments setting)

Running

### Running

1.  In the src directory, run the bash script by using the command below:
    ```
    ./Quiz.sh
    ```
2. Or in the src directory, run the command:
   ```
    ruby Ruby_Quiz_app.rb 
    ```

My quiz app supports several command line arguments so that it can be used to navigate to corresponding menu.

```
-v, --version        - display version of my app
-h, --help           - display help information
-t, --test           - perform quiz test game 
-a, --addCustom      - navigate to custom menu
-d, --displayCustom  - navigate to display custom menu
-r, --records        - navigate to history record menu
-m, --main           - navigate to main menu
```

### System requirement

MacOS, Linux and Windows
