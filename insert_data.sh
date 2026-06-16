#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPP_GOALS
do
  if [[ $YEAR = 'year' ]]
  then
    continue
  fi

  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  if [[ -z $WINNER_ID ]]
  then
    $PSQL "INSERT INTO teams(name) VALUES('$WINNER')"
  fi

  if [[ -z $OPP_ID ]]
  then
    $PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')"
  fi

  WINNER_ID_TO_ADD=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPP_ID_TO_ADD=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
         VALUES($YEAR, '$ROUND', $WINNER_ID_TO_ADD, $OPP_ID_TO_ADD, $WINNER_GOALS, $OPP_GOALS)"
done
