#!/bin/bash
RANDOM_NUMBER=$(( $RANDOM % 1000 + 1 )) 

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME

USER_ID=$($PSQL "SELECT USER_ID FROM USERS WHERE USERNAME = '$USERNAME' ";)

echo $USER_ID
# if new user 
if [[ -z $USER_ID ]]
then 
  echo Welcome, $USERNAME! It looks like this is your first time here.
  NEW_USER_ID=$($PSQL "SELECT MAX(USER_ID) FROM USERS")
  if [[ -z $NEW_USER_ID ]]; then 
    NEW_USER_ID=1
  else
    NEW_USER_ID=$NEW_USER_ID+1
  fi
  $PSQL "insert into users (user_id, username) values ($NEW_USER_ID, '$USERNAME');" 
else  
  USER_RESULTS=$($PSQL "SELECT USERNAME, MAX(SCORE) as BEST_SCORE, count(*) GAMES_PLAYED FROM GAMES INNER JOIN USERS USING(USER_ID) WHERE USERNAME = '$USERNAME' group by USERNAME;" -t  -A) 
  echo $USER_RESULTS | while IFS='|' read USERNAME BEST_SCORE GAMES_PLAYED
  do
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_SCORE guesses."  
  done
fi

echo "Guess the secret number between 1 and 1000:"


echo "Guess the secret number between 1 and 1000:"
read USER_GUESS 
USER_GUESS_COUNT=0

while (( $USER_GUESS != $RANDOM_NUMBER )) 
do
USER_GUESS_COUNT += 1
if [[ $SERVICE_ID_SELECTED =~ ^[0-9] ]]
then
  echo "That is not an integer, guess again:"
  USER_GUESS_COUNT += 1

else
  if (( USER_GUESS > $RANDOM_NUMBER ));
    then
    echo "It's lower than that, guess again:"
    USER_GUESS_COUNT += 1
    read $USER_GUESS
  fi
  if (( USER_GUESS < $RANDOM_NUMBER ));
    then 
    echo "It's higher than that, guess again:"
    USER_GUESS_COUNT += 1
    read $USER_GUESS
  fi
fi
done

echo You guessed it in $USER_GUESS_COUNT tries. The secret number was $RANDOM_NUMBER. Nice job!

