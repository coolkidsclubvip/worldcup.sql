#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# 清空 teams 和 games 表中的数据
$($PSQL "TRUNCATE TABLE games, teams RESTART IDENTITY CASCADE;")


cat games.csv | while IFS=',' read -r year round winner opponent winner_goals opponent_goals; do
  if [[ "$year" == "year" ]]; then
    continue
  fi



  echo $($PSQL "INSERT INTO teams (name) VALUES ('$winner');")
  echo $($PSQL "INSERT INTO teams (name) VALUES ('$opponent');")

# get winner and opponent's id from teams table
  winner_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$winner';")
  opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent';")
# insert data into games table
echo $($PSQL "INSERT INTO games (year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ($year, '$round', $winner_id, $opponent_id,  $winner_goals, $opponent_goals);")

done



