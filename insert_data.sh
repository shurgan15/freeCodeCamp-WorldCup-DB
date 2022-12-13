#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE team, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
# loop through data
do
  if [[ $YEAR != "year" ]]
  then
      WINNER_TEAM="$($PSQL "SELECT * FROM teams WHERE name='$WINNER'")"
      #if it doues not exist
      if [[ -z $WINNER_TEAM ]]
      then
        INSERT_WINNER="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
        if [[ $INSERT_WINNER == "INSERT 0 1" ]]
        then
          echo Inserted $WINNER
        else
          echo failed to insert $WINNER
        fi
      else
        echo $WINNER alredy exists
      fi

        OPPONENT_TEAM="$($PSQL "SELECT * FROM teams WHERE name='$OPPONENT'")"
      if [[ -z $OPPONENT_TEAM ]]
      then
        INSERT_OPPONENT="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
        if  [[ $INSERT_OPPONENT == "INSERT 0 1" ]]
        then
          echo Inserted $OPPONENT
        else
          echo Failed to Insert $OPPONENT
        fi
      else
        echo $OPPONENT already exists
      fi

      # get ids
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # insert into the table
      INSERT_GAME="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")"
      if [[ $INSERT_GAME == "INSERT 0 1" ]]
      then
        echo succesfully inserted game data
      else
        echo failed to insert game data
      fi
    fi
    done
