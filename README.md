# WebBoggle - an AWS Portfolio Project

WebBoggle is an online version of the classic Boggle board game that I threw together after a layoff to demonstrate that I have marketable skills. (If you're impressed by it you should hire me!)

## About the Game
In Boggle, sixteen dice, each with a single letter on each side (except for the 'Q' face, which has 'Qu' written on it) are shaken and allowed to land in a four-by-four tray so that each die has a letter facing up. The board is then put in the playfield where it can be seen by all players. A timer is started, and each player writes down a list of as many words as they can find in the Boggle board. Words on the board must start at any die and append letters by moving to neighboring dice horizontally, vertically, or diagonally. Words must be at least four letters long, cannot be proper nouns, and cannot use the same die more than once.

When the timer expires, players compare their word lists and any word that appears on more than one player's list is removed from all lists. Once duplicates are removed, players score their list based on the number of letters in each word. The highest score wins the game.

Boggle was originally marketed by Parker Brothers and has been copied, imitated, and re-invented countless times. (This project just adds one to that list.) I have been unable to ascertain the copyright status of Boggle but I believe that this project would qualify as a Fair Use exception to copyright laws in the United States.

Feel free to download the code, poke at it, modify it, and host your own version. All files are MIT licensed.

## About the Repo

I wrote this code in a very short time just to demonstrate a few practical skills. I know firsthand that it can be hard for an interviewer to accurately assess a candidate's skills and competencies. While this is by no means the most complex code I've ever written, it at least serves as a baseline.

The root folders in the repo are:

* backend: holds the Go code for the Lambda functions. I am a beginner at Go so it is likely that not all of my code is idiomatic
* frontend: the HTML, Javascript, and CSS for the front end. I am not a front end engineer. Tread here with great care.
* infrastructure: the Terraform files to deploy the AWS infrastructure

## Architecture Overview
I am aware that there are formal architecture development frameworks, such as TOGAF, that are used in industry today. I haven't had the opportunity to educate myself on them but I do believe I have enough industry experience to do a decent job of architecting a solution without a formal framework (which, I suspect, is done in many many organizations in the real world).

### Front End

The front end consists of three HTML files:

* index.html - the logon page
* home.html - hosts a list of games the player can play, the past games the player has played, and allows the player to create a new game
* game.html - the UI for the game itself

Note that I am not a front-end developer. If you are looking for a front-end developer, you should be extraordinarily desperate before considering me for the role. I included front-end work in this project because it is a necessary compontent to demonstrate the back-end work.

### Back End

The back end is hosted entirely on AWS. Major features are:

* The HTML files are stored in an S3 bucket
* The details for each game are stored in a DynamoDB table
* Cognito is used as the identity management system
* AWS Lambda functions run the backend logic
* Route 53 does the DNS stuff
* API Gateway handles the connections from clients
* EventBridge is used to communicate between components, because why not
* A managed Grafana instance is used for monitoring (for my nonexistent SRE team)
* PagerDuty integration sends text message alerts to my phone if things go wrong

Sadly, I was unable to concoct use cases for Kubernetes, Artificial Intelligence, or Kafka into the design. Maybe I can do that when I convince Quinnypig that we should work together to invent Enterprise WebBoggle. (The current design does, however support multi-region deployment so that you can continue to play WebBoggle when us-east-1 goes down.)

### Infrastructure as Code

All of the AWS services listed above are created with a Terraform configuration. I much prefer HCL to CloudFormation's yaml format.

### Deploying to Your Environment

To deploy this code to your environment:
* Clone the repo
* Create an AWS account (or use one you already have)
* In the AWS account, create a role with the name 'cicd' that has administrator permissions. This role will be assumed by Terraform when deploying resources to AWS.
* Verify that you can assume the 'cicd' role from your AWS account
* Replace the bucket, key, and region settings in infrastructure/terraform.tf with the S3 location in which your state file should be stored
* Edit settings.tfvars to set variables for your use case
* Run terraform init
* Run terraform apply -var-file=settings.tfvars
* After your first apply, take the Route53 name servers from the output and enter those in the NS records at your domain registrar


## Requirements

Before starting development work, we need to define requirements. This is one of the major gaps I have observed in my professional career. Too often development work begins before the developers really know what they're building, or why, or what the final product should do (both functionally and nonfunctionally). I've witnessed numerous occasions where the dev team and the product team were at odds with understanding each other because the process did not support getting to a shared understanding of the problem and its solution. BDD is one method that attempts to tackle that problem. This leads to wasted development effort, delays in shipping code, and frustration all around. 

I have not personally invested the time to actually learn, and put hands-to-keyboard, on any of the requirements methodologies out there. A recent coworker had shared his thoughts about Behavior Driven Development (BDD) with me so I sat down to learn more about this methodology.

I found an excellent summary of BDD at [the Practical Developer](https://thepracticaldeveloper.com/cucumber-guide-1-intro-bdd-gherkin/)

> Filling the gap between business requirements and software implementation

> When you start as a software developer, you assume that some obvious parts of the work have been done correctly, like capturing requirements in a User Story, for example.

> It’s somehow obvious, isn’t it? The Product Owner (PO) and/or the Business Analyst (BA) talk to the customer or analyze data and the market needs, to decide what are the next features to implement. Then, the PO and/or BA have a meeting with developers (and testers, if they’re not the same) to refine the requirements, and have an approximate estimation of the required work. They can use this to calculate the Return of Investment (ROI), which doesn’t need to be measured in real currency. For example, let’s say we want to add a new badge to our gamification logic, “Hero of the day”. The initial requirement says we should give this badge to the first three users within 24 hours that solve 3 multiplication challenges. It’s a simple statement, but it has some technical challenges behind, like deciding the timezone to base this logic on, or aggregate existing badges for all the user base. It’s not easy to implement. What’s the value of this for our users? It’s nice, but probably not as nice as creating other 3 badges that don’t require cross-user aggregation and dealing with timezones. If we enable this discussion in real life, probably the PO/BA would lean towards adding simpler extra badges.

> Even though that process sounds pretty straightforward and it’s a core concept in Agile, many organizations fail to implement it. Most of the time, it’s just a __communication__ issue: people don’t talk to each other. Some other times, there is a pressure problem: people think they don’t have time to properly analyze the problem at hand, so it’s better to jump into the implementation directly. Discovery sessions, refinements, and similar gatherings simply don’t happen, or they’re not conducted properly. The results are catastrophic: investing too much time in topics that barely have any business value; coming up with solutions that are not what the users wanted; having poor software quality due to cowboy-mode workarounds and hacks that don’t fit into the target architecture, etc.

> Only if you have experienced those issues, or if you trust the argumentation above, you’ll understand why people take time to document and structure the process to make people talk to each other. There is a clear gap in many IT organizations between business people and developers.

These paragraphs sum up my experience quite well. It's a compelling argument for me to look further into BDD.

So, I'm unemployed and have some time, and I've identified a gap in my professional experience. This is a job for Google! (And O'Reilly.)

After doing some initial self-study, I've chosen to define my requirements in the Gherkin syntax and use Behave (a Pthon based testing engine) as my automated testing tool. I acknowledge one of the tenets of BDD is that it requires various stakeholders (the "three amigos" of product owner, developer, and tester) to talk to each other to arrive at a shared understanding of the problem and its solution, which can't be done as part of a solo project, but I'm forced to work with what I have here.

The requirements for this project are in the /requirements folder in the repo. I found that the Discover/Formulate/Automate iterative cycle can be emulated by a single developer. The act of writing one requirement often reveals another requirement that is missing or needs additional detail. 

### Testing Implementation

I wrote the requirements in the Gherkin language while using Cucumber tutorials to guide me. Since I don't have Ruby experience, I chose to use a Python too, 'Behave' as my test engine instead of Cucumber. Learning Ruby is more than I'm willing to take on at the moment.

# Key Learnings

I started this project just to whip out a sample of my AWS architecture, but it expanded to include some self-learning of BDD. I found that, suprisingly, writing the requirements in Gherkin was remarkably effective at clarifying what I actually wanted to build, and guided me in design decisions when I went to do the implementation. This was of course a trivial example but it was still powerful.

I found that defining requirements wasn't really all that hard. I epxect that the "three amigos" meeting probably works very well in real life.

Implementing the tests, however, was a chore. The implementation requires a new codebase to connect the requirements, which are written at a behavior-level, and translate them to the low-level actions that a client can perform against a server. I suspect that this is likely to be an issue in many workplaces, where testing is often seen as less important than product development.

I also think that there's a missing layer between the BDD requirements and the architectural design. I don't know what tools or practices are out there to help bridge this gap.
