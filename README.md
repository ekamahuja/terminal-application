# Ekam Ahuja - T1A3 (Terminal Applicaiton)

---
## Basic Information
### Source Code - [Click here](https://terminal-application.ekam.dev/sourcecode)

### Trello Board - [Click here](https://terminal-application.ekam.dev/trelloboard)
---
## About Application

### Purpose of the Application
    - To be a terminal interface to topnotchgrowth.com (SMM website)
### Problem It will Solve
    - To save time while placing orders, checking status, viewing order history
### Target Audience
    - The advnace users of topnotchgrowth.com
### The usage of target audience
    - The target audience (the customer of topnotchgrowth.com) can use this terminal application to quickly and reliably place orders, view order history, check order status
---
## Three Main Features of The Application
    1. Authentication System (Login/Register Users)
    2. New Order System (Place new orders on topnotchgrowth.com)
    3. View Order History/Check Status (To view the history of orders with there status)
---
## User Interaction and Experience For The Application

### How The User Will Find Out How To Interact With / Use Each Feature
    - Soonest the application starts, a prompt prints all the options the user has (Login/Register/Exit) which are handled by tty-prompt (which all explains to the user how to use arrow keys and return button to choose and make there selection via the terminal). The entire interface is terminal based and the user can interact and control with the application via the teriminal by using up and down arrow keys to hover of the desired option then pressing enter/return to make there selection (which tty-prompt explains to the user when the application launches/everytime a tty-prompt is used)
    - The target audience of the terminal application are the current customers of topnotchgrowth.com, they will have fluent understanding of how the system works.
    - For new users there is a Help selection option when the user logs into the application to explain the system
    - Error handling is done by various ways and for various situations. Begin/rescue/end blocks, custom classes as well as if/else statments blocks.
        - Error handling has been done for the following but not limited to: user input, api errors, missing/empty files, connection issues        
---
## Flow Chart Diagram of The Application And

### Direct Link to The Flow Chart - [Click here](https://terminal-application.ekam.dev/flowchart)

---
## An Implementation Plan
### Trello Board - [Click here](https://terminal-application.ekam.dev/trelloboard)
---
## Help Documentation

### Steps To Install
    - Ruby is required
    - Longest Ruby is installed and the device has a valid internet connection, the user can run the start.sh (by running 'bash start.sh') to take of everything; Install gems, making sure all database files exisit and are valid, .env exisits with a valid api key
    - Make sure there is a valid API key from topnotchgrowth.com in an .env file in the root directory (If you do not have one, a sample one will be crated when running 'bash start.sh')
    - Please install all gems before launching the application, all gems can either be installed via running 'bundle install' or 'bash start.sh'
    - Make sure in the system config file (./storage/config/system_config.json) their are services within "MAIN_SERVICE_ID" (be default one is included - which is an API test one) - If you would like to add more, go to topnotchgrowth.com/services and add the ID of the service you would want to import in the application. (The API does not charge anything to your API key)
    - If you would like to have your own API key and try paid services. You may head to topnotchgrowth.com and make an account, by going into your account settings you can generate API key which can be configed in .env file (by creating an account on topnotchgrowth.com, you get $1 worth of credit (which is enought to test paid services with low quantity))
    - Gems required by the application are "tty-prompt", "base64", "json", "terminal-table", "httparty", "dotenv" (which can be automatically installed via running 'bash start.sh' or running 'bundle install')
    - An valid Internet connection is required
---
