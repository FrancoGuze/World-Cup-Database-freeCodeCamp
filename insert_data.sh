! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE TABLE games,teams RESTART IDENTITY")"
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $WINNER != winner ]]
then
#echo $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS
# Agregamos equipo ganador a teams
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
if [[ -z $WINNER_ID ]]
then
INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

if [[ $INSERT_TEAM == "INSERT 0 1" ]]
then
echo "- Se agrego $WINNER a teams -"
fi
fi
# Agregamos equipo oponente a teams
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
if [[ -z $OPPONENT_ID ]]
then
INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

if [[ $INSERT_TEAM == "INSERT 0 1" ]]
then
echo "- Se agrego $OPPONENT a teams -"
fi
fi
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
GAME_ID=$($PSQL "SELECT game_id FROM games WHERE round='$ROUND' AND year ='$YEAR' AND winner_id = '$WINNER_ID' AND opponent_id = '$OPPONENT_ID' AND winner_goals = '$WINNER_GOALS' AND opponent_goals='$OPPONENT_GOALS'")
if [[ -z $GAME_ID ]]
then
INSERT_GAME=$($PSQL "INSERT INTO games(round,year,winner_id,opponent_id,winner_goals,opponent_goals) VALUES('$ROUND','$YEAR','$WINNER_ID','$OPPONENT_ID','$WINNER_GOALS','$OPPONENT_GOALS')")
echo -e "~~~ Se ingreso el juego $WINNER vs $OPPONENT | $YEAR | $ROUND ~~~"
fi
#echo "$GAME_ID | $WINNER | $OPPONENT"
# select * from 5tatata FULL JOIN

fi
done
