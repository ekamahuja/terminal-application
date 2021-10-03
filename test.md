Ok so what are we looking for in the testing rubrics? If we start looking at the R17 requirement it says... 

```
Design TWO tests which check that the application is running as expected.

Each test should:
- cover a different feature of the application
- state what is being tested
- provide at least TWO test cases and the expected results for each test case

> An outline of the testing procedure and cases should be included with the source code of the application
```

Full HD is `TWO tests both test MAIN FEATURES of the application and are HIGHLY RELEVANT to checking that the application is running as expected.` and CR is `TWO tests both test IMPORTANT of the application and are SOMEWHAT RELEVANT to checking that the application is running as expected.` So each "Test" contains two "Test Cases" and must cover a different feature of the application.

That sounds simple enough but what does it mean? Ok so in an ideal world our functions should be small and re-usable, what I often see is functions that are 50 lines long and do 8 different things eg (getting input, doing some logic, outputting some information, saving to a file) and if you're lucky that function is returning something. Functions like this are impossible to test (at least in the context of what we're expecting)

If your "MAIN FEATURES" are one big function like the above then bad news you can't test that, if your "MAIN FEATURES" are broken up into little functions then those are ones you CAN and SHOULD test.

Lets assume one of our features is playing some arbitrary game with points, there's a lot of things that we need to accomplish to complete this feature, for example our program needs to determine who the winner is, or how to check that the user typed in valid input. We write functions that take in arguments and return a value. This return value is what we are testing, and the different arguments are the test cases for our Test.

Consider the below code, which determines a winner. Notice how the function doesn't do EVERYTHING, it just figures out who won and returns (not outputs) the correct string value.

```ruby
def determine_winner(player1_score, player2_score)
    if player1_score == player2_score
        return "Its a TIE!"
    else
        return "Player #{player1_score > player2_score ? "One" : "Two"} Wins!"
    end
end
```

If I was writing a test, I could have 3 different test cases, one for when p1_score is greater than p2_score, one for when p1_score is lower than p2_score and one for when both are equal.

That would like this in our testing spec file.

```ruby
assert_equal("It's a TIE", determine_winner(10, 10))
assert_equal("Player Two Wins", determine_winner(5, 15))
assert_equal("Player One Wins", determine_winner(10, 0))
```

The "Test" is whether our function to determine the winner is working as expected, and the test cases are the potential outcomes that would be expected. What about edge cases? What if I passed the string "foo" into this function instead of an Integer? hmmm something to consider in your own applications.

Another feature of my application could be logging in a user, again there's many steps to logging in a user but if we break it down into smaller functions those are possible to test. Here are two different functions that could be written to log a user in, one is easy to test one is...not.

```ruby 
# users = array of hashes
# input_username = string
# input_password = string
def login_user(users, input_username, input_password)
    # returns the index of a matching username/password
    # or nil if no match
    return users.index do |user| 
        user[:username] == input_username && user[:password] == input_password 
    end
end

def login_user_two
    require 'csv'
    users = CSV.parse(File.open("../data/users.csv"))
    logged_in = false
    until logged_in
        system "clear"
        puts "Please enter your username"
        input_username = gets.chomp
        puts "Please enter your password"
        input_password = gets.chomp
        user[:username] == input_username && user[:password] == input_password 
        index = users.index do |user| 
            user[:username] == input_username && user[:password] == input_password 
        end
        if index == nil
            puts "Incorrect username or password!"
        end
    end
end
``` 

In the first example, my "Test" is logging in the user and and there's at least 2 "test cases" that I can test for but I can provide more to ensure my tests are accurate.

```ruby
users = [
    {username: "john", password: "password"},
    {username: "quincy", password: "noobslayer69"},
    {username: "adam", password: "abc123"}
]
# the expected value should be nil because function would return nil because there is
# no username/password combination that matches 
assert_equal(nil, login_user(users, "foo", "bar") )
# the expected value is 2 because adam and abc123 are in the array
assert_equal(2, login_user(users, "adam", "abc123")
# the expected value is nil, even though "john" is in the array the password doesn't match
assert_equal(2, login_user(users, "john", "bbbbb")
```

The second example is almost impossible to correctly test for a number of reasons, there must be a file in that space when the function is called, the function is asking the user for input and the automated test runner cannot "type their username and password" and best of all our function doesn't return anything so how can we test it?

So in closing, a lot of your code might be "untestable" - try and find smaller functions that take arguments and return results that can be tested for.