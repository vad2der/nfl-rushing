# theScore "the Rush" Interview Challenge
At theScore, we are always looking for intelligent, resourceful, full-stack developers to join our growing team. To help us evaluate new talent, we have created this take-home interview question. This question should take you no more than a few hours.

**All candidates must complete this before the possibility of an in-person interview. During the in-person interview, your submitted project will be used as the base for further extensions.**

### Why a take-home challenge?
In-person coding interviews can be stressful and can hide some people's full potential. A take-home gives you a chance work in a less stressful environment and showcase your talent.

We want you to be at your best and most comfortable.

### A bit about our tech stack
As outlined in our job description, you will come across technologies which include a server-side web framework (like Elixir/Phoenix, Ruby on Rails or a modern Javascript framework) and a front-end Javascript framework (like ReactJS)

### Challenge Background
We have sets of records representing football players' rushing statistics. All records have the following attributes:
* `Player` (Player's name)
* `Team` (Player's team abbreviation)
* `Pos` (Player's postion)
* `Att/G` (Rushing Attempts Per Game Average)
* `Att` (Rushing Attempts)
* `Yds` (Total Rushing Yards)
* `Avg` (Rushing Average Yards Per Attempt)
* `Yds/G` (Rushing Yards Per Game)
* `TD` (Total Rushing Touchdowns)
* `Lng` (Longest Rush -- a `T` represents a touchdown occurred)
* `1st` (Rushing First Downs)
* `1st%` (Rushing First Down Percentage)
* `20+` (Rushing 20+ Yards Each)
* `40+` (Rushing 40+ Yards Each)
* `FUM` (Rushing Fumbles)

In this repo is a sample data file [`rushing.json`](/rushing.json).

##### Challenge Requirements
1. Create a web app. This must be able to do the following steps
    1. Create a webpage which displays a table with the contents of [`rushing.json`](/rushing.json)
    2. The user should be able to sort the players by _Total Rushing Yards_, _Longest Rush_ and _Total Rushing Touchdowns_
    3. The user should be able to filter by the player's name
    4. The user should be able to download the sorted data as a CSV, as well as a filtered subset
    
2. The system should be able to potentially support larger sets of data on the order of 10k records.

3. Update the section `Installation and running this solution` in the README file explaining how to run your code

### Submitting a solution
1. Download this repo
2. Complete the problem outlined in the `Requirements` section
3. In your personal public GitHub repo, create a new public repo with this implementation
4. Provide this link to your contact at theScore

We will evaluate you on your ability to solve the problem defined in the requirements section as well as your choice of frameworks, and general coding style.

### Help
If you have any questions regarding requirements, do not hesitate to email your contact at theScore for clarification.

### Installation and running this solution

#### Prerequisites:
1. Elasticsearch (the solution was build with version 7.10)
   [installation guide](https://www.elastic.co/guide/en/elasticsearch/reference/current/install-elasticsearch.html)
2. PostgreSQL
   installation guide(https://www.postgresql.org/download/linux/ubuntu/)
3. Ruby
   installation guide(https://www.ruby-lang.org/en/documentation/installation/)
4. Angular CLI + node
   [installation guide](https://cli.angular.io/)

#### Environmental variables
    One need to set `DATABASE_USERNAME`, `USERNAME_PASSWORD` and `ELASTICSEARCH_HOST`.
    Recomendation to use `direnv` tool (put your values to [./players_backend/.envrc](./players_backend/.envrc)).
    Additional info on direnv is [here](https://github.com/direnv/direnv/blob/master/docs/installation.md).

#### Running
1. Start Elasticsearch. Served on *localhost:9200* by default.
2. Have Postgres running. Served on port 5432 by default.
3. In the **players_backend** folder
   1. Run `bundle` to install gems
   2. Create the DB: `rails db:create`
   3. Migrate the DB: `rails db:migrate`
   4. Seed the DB: `rails db:seed`
   5. Index the elasticsearch records:
      - go into rails console `rails c`
      - `RushStat.index_all`

   6. Run backend server `rails s`. Served on *localhost:3000* by default

4. In the **players-frontend** folder
   1. Run `npm i` to install npm packages
   2. Run `ng s` to start development server. Served on *localhost:4200* by default.


5. Open browser and goto [http://localhost:4200/players](http://localhost:4200/players)

#### Sugestions for improvement
1. Back-end: logic to query DB directly if Elasticserch::Transport erorr encountered
2. Front-end: style, error message (as a separate service)
3. Login/security
4. Tests
5. ...

#### Disclaimer
The test app lacks of a number of features to be production-ready mature app.
Have been built by evenings during the 4 weekdays.
If something does not work, don't panic, just contact Vadim (vadim.deryabin@protonmail.com)
