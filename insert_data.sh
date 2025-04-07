#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat "games.csv" | while IFS=, read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS 
do
  if  [ "$YEAR" != "year" ]
  then 

    WINNER_ID=$($PSQL "SELECT TEAM_ID from TEAMS where name = '$WINNER'")
    
    if [[ -z $WINNER_ID ]] 
    then
      WINNER_ID=$($PSQL "insert into teams (name) values ('$WINNER'); SELECT team_id from teams where name = '$WINNER'")
    fi

    OPPONENT_ID=$($PSQL "SELECT TEAM_ID from TEAMS where name = '$OPPONENT'")
    
    if [[ -z $OPPONENT_ID ]] 

    then
      OPPONENT_ID=$($PSQL "insert into teams (name) values ('$OPPONENT'); SELECT team_id from teams where name = '$OPPONENT'")
    fi


    GAME_ID=$($PSQL "SELECT GAME_ID from GAMES where year = $YEAR and round = '$ROUND' and winner_id = $WINNER_ID and opponent_id = '$OPPONENT_ID'")
    GAME_ID=$($PSQL "INSERT INTO GAMES (year,round,winner_id,opponent_id,winner_goals,opponent_goals) values ($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS); SELECT GAME_ID from GAMES where year = $YEAR and round = '$ROUND' and winner_id = $WINNER_ID and opponent_id = '$OPPONENT_ID'")

    echo $GAME_ID
  fi  
done




# year,round,winner,opponent,winner_goals,opponent_goals
