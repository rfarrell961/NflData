import pandas as pd
from datetime import datetime
from sqlalchemy import create_engine
import numpy as np
from dotenv import load_dotenv
import os

load_dotenv()

START_YEAR_ROSTER=int(os.getenv('START_YEAR_ROSTER'))
START_YEAR_INJURY=int(os.getenv('START_YEAR_INJURY'))
START_YEAR_PLAY=int(os.getenv('START_YEAR_PLAY'))
END_YEAR=int(os.getenv('END_YEAR'))

PLAYERS_FILE=os.getenv('PLAYERS_FILE')
ROSTERS_DIR_START=os.getenv('ROSTERS_DIR_START')
ROSTERS_DIR_END=os.getenv('ROSTERS_DIR_END')
PLAYS_DIR_START=os.getenv('PLAYS_DIR_START')
PLAYS_DIR_END=os.getenv('PLAYS_DIR_END')

INJURIES_DIR_START=os.getenv('INJURIES_DIR_START')
INJURIES_DIR_END=os.getenv('INJURIES_DIR_END')

user=os.getenv('USER')
password=os.getenv('PASSWORD')
host=os.getenv('HOST')
port=os.getenv('PORT')
db=os.getenv('DB')

engine = create_engine(f'postgresql+psycopg2://{user}:{password}@{host}:{port}/{db}', echo=False)

"""# Read Teams"""

def do_teams():

  df_teams = pd.DataFrame({
      "abbreviation": pd.Series(dtype="object"),
      "season": pd.Series(dtype="int16"),
  })

  df_teams_db = pd.read_sql_table("teams", engine)

  for year in range(START_YEAR_ROSTER, END_YEAR + 1):
    print(f"Processing Teams in {year}...")
    df_teams_current = pd.DataFrame({
      "abbreviation": pd.Series(dtype="object"),
      "season": pd.Series(dtype="int16"),
      })

    file = ROSTERS_DIR_START + str(year) + ROSTERS_DIR_END
    df_roster = pd.read_parquet(file)
    df_teams_current["abbreviation"] = df_roster["team"].unique()
    df_teams_current["season"] = year

    df_teams = pd.concat([df_teams, df_teams_current])

  df_teams["abbreviation"] = df_teams["abbreviation"].replace("SL", "STL")

  # Remove entries that already exist in database
  df_teams = pd.merge(df_teams, df_teams_db, on=["abbreviation", "season"], how="left", indicator=True)
  df_teams = df_teams[df_teams["_merge"] == "left_only"].drop(columns=["_merge", "team_id"])

  n = df_teams.to_sql("teams", engine, if_exists="append", index=False, method='multi')
  print(f"Inserted {n} Rows into Teams")
  print("")

  return

"""# Read Players"""

def do_players():

  print(f"Processing Players...")
  df_original = pd.read_parquet(PLAYERS_FILE)

  df_players_db = pd.read_sql_table("players", engine)

  # Take only desired columns
  df_players = df_original[["gsis_id", "first_name", "last_name", "college_name",\
                          "birth_date", "draft_club", "draft_number", "entry_year"]]

  # Rename columns
  df_players = df_players.rename(columns = {
      "gsis_id" : "player_id_import",
      "college_name" : "college",
      "birth_date" : "date_of_birth",
      "entry_year" : "rookie_year"
  })

  df_players = df_players.dropna(subset=["player_id_import"])

  df_teams = pd.read_sql_table("teams", engine)

  # Merge to add draft_team_id based on draft_club & rookie_year matching abbreviation & season
  df_players = df_players.merge(
      df_teams[['team_id', 'abbreviation', 'season']],
      left_on=['draft_club', 'rookie_year'],
      right_on=['abbreviation', 'season'],
      how='left'
  )

  df_players.rename(columns={'team_id': 'draft_team_id'}, inplace=True)
  df_players.drop(columns=['abbreviation', 'season', 'draft_club'], inplace=True)

  # Remove entries that already exist in database
  df_players = pd.merge(df_players, df_players_db[["player_id_import"]], on=["player_id_import"], how="left", indicator=True)
  df_players = df_players[df_players["_merge"] == "left_only"].drop(columns=["_merge"])


  n = df_players.to_sql( "players", engine, if_exists="append", index=False, method='multi')
  print(f"Inserted {n} Rows into Players")
  print("")
  return

"""# Read Games"""

def fix_time(s):
    try:
        date_part, time_part = s.split(", ")
        h, m, sec = map(int, time_part.split(":"))
        if h == 24:
            h = 0
            dt = pd.to_datetime(date_part, format="%m/%d/%y") + pd.Timedelta(days=1)
        else:
            dt = pd.to_datetime(date_part, format="%m/%d/%y")
        return pd.Timestamp(year=dt.year, month=dt.month, day=dt.day, hour=h, minute=m, second=sec)
    except Exception:
        return pd.NaT  # or handle differently

def do_games():
  df_games_db = pd.read_sql_table("games", engine)
  df_teams_db = pd.read_sql_table("teams", engine)

  # Fix team abbreviation mismatches with our db from rosters data
  df_teams_db["abbreviation_plays_data"] = df_teams_db["abbreviation"].replace("ARZ", "ARI")
  df_teams_db["abbreviation_plays_data"] = df_teams_db["abbreviation_plays_data"].replace("BLT", "BAL")
  df_teams_db["abbreviation_plays_data"] = df_teams_db["abbreviation_plays_data"].replace("HST", "HOU")
  df_teams_db["abbreviation_plays_data"] = df_teams_db["abbreviation_plays_data"].replace("CLV", "CLE")
  df_teams_db["abbreviation_plays_data"] = df_teams_db["abbreviation_plays_data"].replace("SD", "LAC")
  df_teams_db["abbreviation_plays_data"] = df_teams_db["abbreviation_plays_data"].replace("OAK", "LV")
  df_teams_db["abbreviation_plays_data"] = df_teams_db["abbreviation_plays_data"].replace("STL", "LA")

  df_games = pd.DataFrame()
  for year in range(START_YEAR_PLAY, END_YEAR + 1):

    print(f"Processing Games in {year}...")
    df_games_current = pd.DataFrame()

    file = PLAYS_DIR_START + str(year) + PLAYS_DIR_END
    df_plays = pd.read_parquet(file)

    df_games_current = df_plays[["game_id", "home_team", "away_team", "week", "game_date", "start_time", "stadium", "weather", "wind", \
                                 "season", "spread_line", "total_line", "div_game", "home_coach", "away_coach"]].copy().drop_duplicates(subset=["game_id"])

    df_games_current = df_games_current.rename(columns={"div_game" : "division_game", "game_id" : "game_id_import"} )
    df_games_current["division_game"] = df_games_current["division_game"] > 0
    df_games_current["regular_season"] = df_plays["season_type"] == "REG"
    df_games_current["neutral_location"] = df_plays["location"] == "Neutral"

    # Convert home_team and away_team to home_team_id and away_team_id
    df_teams_db = df_teams_db.rename(columns={'season': 'team_season'})
    df_games_current = df_games_current.merge(
      df_teams_db[['team_id', 'abbreviation_plays_data', 'team_season']],
      left_on=['home_team', 'season'],
      right_on=['abbreviation_plays_data', 'team_season'],
      how='left'
    ).drop(columns=['team_season', 'abbreviation_plays_data', 'home_team']).rename(columns={'team_id': 'home_team_id'})

    df_games_current = df_games_current.merge(
      df_teams_db[['team_id', 'abbreviation_plays_data', 'team_season']],
      left_on=['away_team', 'season'],
      right_on=['abbreviation_plays_data', 'team_season'],
      how='left'
    ).drop(columns=['team_season', 'abbreviation_plays_data', 'away_team']).rename(columns={'team_id': 'away_team_id'})

    df_games = pd.concat([df_games, df_games_current])

  # Modify original abbreviations for game id construction
  df_teams_db["abbreviation"] = df_teams_db["abbreviation"].replace("ARZ", "ARI")
  df_teams_db["abbreviation"] = df_teams_db["abbreviation"].replace("BLT", "BAL")
  df_teams_db["abbreviation"] = df_teams_db["abbreviation"].replace("HST", "HOU")
  df_teams_db["abbreviation"] = df_teams_db["abbreviation"].replace("CLV", "CLE")

  # Remove entries that exist in db already
  df_games_db = df_games_db.merge(
      df_teams_db[['team_id', 'abbreviation']],
      left_on=['home_team_id'],
      right_on=['team_id'],
      how='left'
  ).drop(columns=['team_id', 'home_team_id']).rename(columns={'abbreviation': 'home_team_abbreviation'})\
  .merge(
      df_teams_db[['team_id', 'abbreviation']],
      left_on=['away_team_id'],
      right_on=['team_id'],
      how='left'
  ).drop(columns=['team_id', 'away_team_id']).rename(columns={'abbreviation': 'away_team_abbreviation'})
  df_games_db["game_id_generated"] = df_games_db["season"].astype(str) + "_" + df_games_db["week"].astype(str).str.zfill(2) + "_" + df_games_db["away_team_abbreviation"] + "_" + df_games_db["home_team_abbreviation"]

  df_games = pd.merge(df_games, df_games_db["game_id_generated"], left_on=["game_id_import"], right_on=["game_id_generated"], how="left", indicator=True)
  df_games = df_games[df_games["_merge"] == "left_only"].drop(columns=["_merge", "game_id_generated"])

  # Some dates and times are messed up (Shows hour 24:**). May be issue with how data was collected.
  df_games["start_time"] = df_games["start_time"].apply(fix_time)

  n = df_games.to_sql( "games", engine, if_exists="append", index=False, method='multi')
  print(f"Inserted {n} Rows into Games")
  print("")

"""# Read Players"""

import re

# Function to normalize time_of_day
def normalize_time_of_day(row):
    t = str(row["time_of_day"])
    if pd.isna(row["time_of_day"]) or t == "NaT" or t.lower() == "nan":
        return pd.NaT
    if re.match(r"^\d{4}-\d{2}-\d{2}", t):  # already has a date
        return pd.to_datetime(t, errors="coerce")
    # If only HH:MM:SS, attach game_date
    return pd.to_datetime(f"{row['game_date']} {t}", errors="coerce")

def do_plays():
  df_games_db = pd.read_sql_table("games", engine)
  df_games_db = df_games_db.rename(columns={"game_id" : "game_id_db"})

  df_plays_db = pd.read_sql_table("plays", engine)

  for year in range(START_YEAR_PLAY, END_YEAR + 1):
    print(f"Processing Plays in {year}...")
    file = PLAYS_DIR_START + str(year) + PLAYS_DIR_END
    df_plays_current_full = pd.read_parquet(file)
    df_plays_current = df_plays_current_full[["play_id", "game_id", "posteam_type", "side_of_field", "home_team", "away_team", "yardline_100", \
                                         "game_seconds_remaining", "quarter_end", "drive", "sp", "down", "goal_to_go", "ydstogo", "desc", "play_type",\
                                         "yards_gained", "shotgun", "no_huddle", "qb_dropback", "qb_scramble", "pass_location", "air_yards", \
                                         "yards_after_catch", "run_location", "run_gap", "field_goal_result", "kick_distance", "extra_point_result",\
                                         "two_point_conv_result", "home_timeouts_remaining", "away_timeouts_remaining", "timeout", "timeout_team", \
                                         "total_home_score", "total_away_score", "incomplete_pass", "complete_pass", "touchback", "interception", \
                                          "punt_inside_twenty", "punt_in_endzone", "punt_out_of_bounds", "punt_downed", "punt_fair_catch", "punt_blocked", \
                                         "kickoff_inside_twenty", "kickoff_in_endzone", "kickoff_out_of_bounds", "kickoff_downed", "kickoff_fair_catch", \
                                         "own_kickoff_recovery", "own_kickoff_recovery_td", "fumble_forced", "fumble_out_of_bounds", "penalty", "fumble_lost", \
                                         "lateral_reception", "lateral_rush", "lateral_return", "lateral_recovery", "passing_yards", "receiving_yards", \
                                         "rushing_yards", "lateral_receiving_yards", "lateral_rushing_yards", "fumble_recovery_1_yards", "fumble_recovery_2_yards",\
                                         "return_team", "return_yards", "penalty_yards", "replay_or_challenge_result", "penalty_type", "defensive_two_point_conv", \
                                         "defensive_extra_point_conv", "series_result", "time_of_day", "fixed_drive_result", "aborted_play", \
                                         "out_of_bounds"]]

    df_plays_current = df_plays_current.rename(columns={"play_id" : "play_id_import", "sp" : "scoring_play", "ydstogo" : "yards_to_go", "desc" : "description"})

    df_plays_current["quarter_end"] = df_plays_current["quarter_end"] == 1
    df_plays_current["scoring_play"] = df_plays_current["scoring_play"] == 1
    df_plays_current["goal_to_go"] = df_plays_current["goal_to_go"] == 1
    df_plays_current["shotgun"] = df_plays_current["shotgun"] == 1
    df_plays_current["no_huddle"] = df_plays_current["no_huddle"] == 1
    df_plays_current["qb_dropback"] = df_plays_current["qb_dropback"] == 1
    df_plays_current["qb_scramble"] = df_plays_current["qb_scramble"] == 1
    df_plays_current["timeout"] = df_plays_current["timeout"] == 1
    df_plays_current["incomplete_pass"] = df_plays_current["incomplete_pass"] == 1
    df_plays_current["complete_pass"] = df_plays_current["complete_pass"] == 1
    df_plays_current["touchback"] = df_plays_current["touchback"] == 1
    df_plays_current["interception"] = df_plays_current["interception"] == 1
    df_plays_current["punt_inside_twenty"] = df_plays_current["punt_inside_twenty"] == 1
    df_plays_current["punt_in_endzone"] = df_plays_current["punt_in_endzone"] == 1
    df_plays_current["punt_out_of_bounds"] = df_plays_current["punt_out_of_bounds"] == 1
    df_plays_current["punt_downed"] = df_plays_current["punt_downed"] == 1
    df_plays_current["punt_fair_catch"] = df_plays_current["punt_fair_catch"] == 1
    df_plays_current["punt_blocked"] = df_plays_current["punt_blocked"] == 1
    df_plays_current["kickoff_inside_twenty"] = df_plays_current["kickoff_inside_twenty"] == 1
    df_plays_current["kickoff_in_endzone"] = df_plays_current["kickoff_in_endzone"] == 1
    df_plays_current["kickoff_out_of_bounds"] = df_plays_current["kickoff_out_of_bounds"] == 1
    df_plays_current["kickoff_downed"] = df_plays_current["kickoff_downed"] == 1
    df_plays_current["kickoff_fair_catch"] = df_plays_current["kickoff_fair_catch"] == 1
    df_plays_current["own_kickoff_recovery"] = df_plays_current["own_kickoff_recovery"] == 1
    df_plays_current["own_kickoff_recovery_td"] = df_plays_current["own_kickoff_recovery_td"] == 1
    df_plays_current["fumble_forced"] = df_plays_current["fumble_forced"] == 1
    df_plays_current["fumble_out_of_bounds"] = df_plays_current["fumble_out_of_bounds"] == 1
    df_plays_current["penalty"] = df_plays_current["penalty"] == 1
    df_plays_current["fumble_lost"] = df_plays_current["fumble_lost"] == 1
    df_plays_current["lateral_reception"] = df_plays_current["lateral_reception"] == 1
    df_plays_current["lateral_rush"] = df_plays_current["lateral_rush"] == 1
    df_plays_current["lateral_return"] = df_plays_current["lateral_return"] == 1
    df_plays_current["lateral_recovery"] = df_plays_current["lateral_recovery"] == 1
    df_plays_current["defensive_two_point_conv"] = df_plays_current["defensive_two_point_conv"] == 1
    df_plays_current["defensive_extra_point_conv"] = df_plays_current["defensive_extra_point_conv"] == 1
    df_plays_current["aborted_play"] = df_plays_current["aborted_play"] == 1
    df_plays_current["out_of_bounds"] = df_plays_current["out_of_bounds"] == 1

    # Get game id from db
    df_plays_current = df_plays_current.merge(df_games_db[["game_id_db", "game_id_import", "home_team_id", "away_team_id"]], left_on=["game_id"], right_on=["game_id_import"], how="left")\
    .drop(columns=["game_id_import", "game_id"]).rename(columns={"game_id_db" : "game_id"})

    # Replace posteam_type (home, away, null) with appropriate id
    df_plays_current["possession_team_id"] = np.where(
        df_plays_current["posteam_type"] == "home", df_plays_current["home_team_id"],
        np.where(df_plays_current["posteam_type"] == "away", df_plays_current["away_team_id"], np.nan)
    )

    # Convert side of field team to team ID
    df_plays_current["side_of_field_team_id"] = np.where(
        df_plays_current["side_of_field"] == df_plays_current["home_team"], df_plays_current["home_team_id"],
        np.where(df_plays_current["side_of_field"] == df_plays_current["away_team"], df_plays_current["away_team_id"], np.nan)
    )

    # Convert timeout_team to team ID
    df_plays_current["timeout_team_id"] = np.where(
        df_plays_current["timeout_team"] == df_plays_current["home_team"], df_plays_current["home_team_id"],
        np.where(df_plays_current["timeout_team"] == df_plays_current["away_team"], df_plays_current["away_team_id"], np.nan)
    )

    # Convert return_team to team ID
    df_plays_current["return_team_id"] = np.where(
        df_plays_current["return_team"] == df_plays_current["home_team"], df_plays_current["home_team_id"],
        np.where(df_plays_current["return_team"] == df_plays_current["away_team"], df_plays_current["away_team_id"], np.nan)
    )

    df_plays_current = df_plays_current.drop(columns=["home_team_id", "away_team_id", "posteam_type", "home_team", "away_team", "side_of_field", "timeout_team", "return_team"])

    # Modify add date to time if  necessary
    df_plays_current["game_id"] = df_plays_current["game_id"].astype(int)
    df_games_db["game_id_db"] = df_games_db["game_id_db"].astype(int)
    df_plays_current = df_plays_current.merge(
        df_games_db[["game_id_db", "game_date"]],
        left_on="game_id",
        right_on="game_id_db",
        how="left"
    ).drop(columns=["game_id_db"])
    df_plays_current["time_of_day"] = df_plays_current.apply(normalize_time_of_day, axis=1) 
    df_plays_current = df_plays_current.drop(columns=["game_date"])

    # Remove entries that already exist in database
    df_plays_current = pd.merge(df_plays_current, df_plays_db[["play_id_import", "game_id"]], on=["play_id_import", "game_id"], how="left", indicator=True)
    df_plays_current = df_plays_current[df_plays_current["_merge"] == "left_only"].drop(columns=["_merge"])

    n = df_plays_current.to_sql( "plays", engine, if_exists="append", index=False, method='multi')

    print(f"Inserted {n} Rows into Plays")
    print("")  

def get_play_participant_df(df_plays_current, df_players_db, df_plays_db, original_column_name, role_name):

    # Get Passers    
    df_current = df_plays_current[["play_id", "game_id", original_column_name]]    

    ###     Get real player id from db
    df_current = df_current.merge(df_players_db[["player_id", "player_id_import"]], left_on=[original_column_name], right_on=["player_id_import"], how="left")\
    .drop(columns=["player_id_import", original_column_name]).dropna(subset=["player_id"])   

    ###     Get play id from db
    df_current = df_current.merge(df_plays_db[["play_id_db", "play_id_import", "game_id_db"]], left_on=["play_id", "game_id"], right_on=["play_id_import", "game_id_db"], how="left") \
    .drop(columns=["play_id", "play_id_import", "game_id_db", "game_id"]).rename(columns={"play_id_db" : "play_id"})

    df_current["role"] = role_name
    
    return df_current

def do_play_participants():
  df_plays_db = pd.read_sql_table("plays", engine)
  df_plays_db = df_plays_db.rename(columns={"play_id" : "play_id_db", "game_id" : "game_id_db"})
  df_play_participants_db = pd.read_sql_table("play_participants", engine)
  df_players_db = pd.read_sql_table("players", engine)
  df_games_db = pd.read_sql_table("games", engine)
  df_games_db = df_games_db.rename(columns={"game_id" : "game_id_db"})

  for year in range(START_YEAR_PLAY, END_YEAR + 1):
    print(f"Processing Play Participants  in {year}...")
    file = PLAYS_DIR_START + str(year) + PLAYS_DIR_END
    df_plays_current = pd.read_parquet(file)        

    # Get game id from db
    df_plays_current = df_plays_current.merge(df_games_db[["game_id_db", "game_id_import"]], left_on=["game_id"], right_on=["game_id_import"], how="left")\
    .drop(columns=["game_id_import", "game_id"]).rename(columns={"game_id_db" : "game_id"})

    df_passers = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "passer_player_id", "passer")
    df_rushers = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "rusher_player_id", "rusher")
    df_receivers = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "receiver_player_id", "receiver")
    df_touchdown_scorers = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "td_player_id", "touchdown_scorer")
    df_lateral_receivers = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "lateral_receiver_player_id", "lateral_receiver")
    df_lateral_rushers = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "lateral_rusher_player_id", "lateral_rusher")
    df_interceptions = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "interception_player_id", "interception")
    df_lateral_interceptions = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "lateral_interception_player_id", "lateral_interception")
    df_punt_returners = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "punt_returner_player_id", "punt_returner")
    df_lateral_punt_returners = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "lateral_punt_returner_player_id", "lateral_punt_returner")
    df_kickoff_returners = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "kickoff_returner_player_id", "kickoff_returner")
    df_lateral_kickoff_returners = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "lateral_kickoff_returner_player_id", "lateral_kickoff_returner")
    df_punters = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "punter_player_id", "punter")  
    df_kickers = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "kicker_player_id", "kicker")  
    df_own_kickoffs = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "own_kickoff_recovery_player_id", "own_kickoff")  
    df_blocked_kicks = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "blocked_player_id", "blocked_kick")  
    df_tackle_for_loss_1s = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "tackle_for_loss_1_player_id", "tackle_for_loss_1")  
    df_tackle_for_loss_2s = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "tackle_for_loss_2_player_id", "tackle_for_loss_2")  
    df_qb_hit_1s = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "qb_hit_1_player_id", "qb_hit_1")  
    df_qb_hit_2s = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "qb_hit_2_player_id", "qb_hit_2")  
    df_forced_fumble_player_1s = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "forced_fumble_player_1_player_id", "forced_fumble_player_1")  
    df_forced_fumble_player_2s = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "forced_fumble_player_2_player_id", "forced_fumble_player_2")  
    df_solo_tackle_1s = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "solo_tackle_1_player_id", "solo_tackle_1")  
    df_solo_tackle_2s = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "solo_tackle_2_player_id", "solo_tackle_2")  
    df_assist_tackle_1s = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "assist_tackle_1_player_id", "assist_tackle_1")  
    df_assist_tackle_2s = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "assist_tackle_2_player_id", "assist_tackle_2")  
    df_assist_tackle_3s = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "assist_tackle_3_player_id", "assist_tackle_3")  
    df_assist_tackle_4s = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "assist_tackle_4_player_id", "assist_tackle_4")  
    df_tackle_with_assist_1s = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "tackle_with_assist_1_player_id", "tackle_with_assist_1")  
    df_tackle_with_assist_2s = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "tackle_with_assist_2_player_id", "tackle_with_assist_2")  
    df_pass_defense_1s = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "pass_defense_1_player_id", "pass_defense_1")  
    df_pass_defense_2s = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "pass_defense_2_player_id", "pass_defense_2")  
    df_fumbled_1s = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "fumbled_1_player_id", "fumbled_1")  
    df_fumbled_2s = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "fumbled_2_player_id", "fumbled_2")  
    df_fumble_recovery_1s = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "fumble_recovery_1_player_id", "fumble_recovery_1")  
    df_fumble_recovery_2s = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "fumble_recovery_2_player_id", "fumble_recovery_2")  
    df_sacks = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "sack_player_id", "sack")  
    df_half_sack_1s = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "half_sack_1_player_id", "half_sack_1")  
    df_half_sack_2s = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "half_sack_2_player_id", "half_sack_2")  
    df_penaltys = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "penalty_player_id", "penalty")  
    df_safetys = get_play_participant_df(df_plays_current, df_players_db, df_plays_db, "safety_player_id", "safety")

    df_play_participants_current = pd.concat([df_passers, df_rushers, df_receivers, df_touchdown_scorers, df_lateral_receivers, df_lateral_rushers, df_interceptions, \
                                              df_lateral_interceptions, df_punt_returners, df_lateral_punt_returners, df_kickoff_returners, df_lateral_kickoff_returners, df_punters, df_kickers, \
                                              df_own_kickoffs, df_blocked_kicks, df_tackle_for_loss_1s, df_tackle_for_loss_2s, df_qb_hit_1s, df_qb_hit_2s, df_forced_fumble_player_1s, \
                                              df_forced_fumble_player_2s, df_solo_tackle_1s, df_solo_tackle_2s, df_assist_tackle_1s, df_assist_tackle_2s, df_assist_tackle_3s, df_assist_tackle_4s, \
                                              df_tackle_with_assist_1s, df_tackle_with_assist_2s, df_pass_defense_1s, df_pass_defense_2s, df_fumbled_1s, df_fumbled_2s, df_fumble_recovery_1s, \
                                              df_fumble_recovery_2s, df_sacks, df_half_sack_1s, df_half_sack_2s, df_penaltys, df_safetys])

    # Remove entries that already exist in database
    df_play_participants_current = pd.merge(df_play_participants_current, df_play_participants_db, on=["player_id", "play_id", "role"], how="left", indicator=True)
    df_play_participants_current = df_play_participants_current[df_play_participants_current["_merge"] == "left_only"].drop(columns=["_merge"])
 
    n = df_play_participants_current.to_sql("play_participants", engine, if_exists="append", index=False, method='multi')

    print(f"Inserted {n} Rows into Play_Particpants")
    print("")

def do_rosters():
  df_rosters_db = pd.read_sql_table("rosters", engine)
  df_players_db = pd.read_sql_table("players", engine)
  df_games_db = pd.read_sql_table("games", engine)
  df_teams_db = pd.read_sql_table("teams", engine)

  for year in range(START_YEAR_ROSTER, END_YEAR + 1):
    print(f"Processing Rosters in {year}...")    
    file = ROSTERS_DIR_START + str(year) + ROSTERS_DIR_END
    df_roster = pd.read_parquet(file)
    df_roster = df_roster[["gsis_id", "height", "weight", "jersey_number", "position", "team", "season", "week"]]
    
    # Get Player IDs
    df_roster = df_roster.merge(df_players_db[["player_id_import", "player_id"]], left_on=["gsis_id"], right_on=["player_id_import"], how="left")\
    .drop(columns=["player_id_import", "gsis_id"]).dropna(subset=["player_id"])

    # Get Team IDs
    df_roster["team"] = df_roster["team"].replace("SL", "STL")
    df_roster = df_roster.merge(df_teams_db[["abbreviation", "team_id", "season"]], left_on=["team", "season"], right_on=["abbreviation", "season"], how="left").drop(columns=["abbreviation", "team", "season"])

    # Get Game ID's
    df_roster = df_roster.merge(df_games_db[["game_id", "away_team_id", "week"]], left_on=["team_id", "week"], right_on=["away_team_id", "week"], how="left").drop(columns=["away_team_id"])
    df_roster = df_roster.merge(df_games_db[["game_id", "home_team_id", "week"]], left_on=["team_id", "week"], right_on=["home_team_id", "week"], how="left").drop(columns=["home_team_id", "week"])
    df_roster["game_id"] = df_roster["game_id_x"].fillna(df_roster["game_id_y"])
    df_roster = df_roster.drop(columns=["game_id_x", "game_id_y"])
    df_roster = df_roster.dropna(subset=["game_id"])

    # Remove entries that already exist in database
    df_roster = pd.merge(df_roster, df_rosters_db[["player_id", "team_id", "game_id"]], on=["player_id", "team_id", "game_id"], how="left", indicator=True)
    df_roster = df_roster[df_roster["_merge"] == "left_only"].drop(columns=["_merge"])

    n = df_roster.to_sql("rosters", engine, if_exists="append", index=False, method='multi', )
    print(f"Inserted {n} Rows into Rosters")
    print("")  

def do_injuries():
  df_injuries_db = pd.read_sql_table("injuries", engine)
  df_players_db = pd.read_sql_table("players", engine)
  df_games_db = pd.read_sql_table("games", engine)
  df_teams_db = pd.read_sql_table("teams", engine)

  for year in range(START_YEAR_INJURY, END_YEAR + 1):
    print(f"Processing Injuries in {year}...")    
    file = INJURIES_DIR_START + str(year) + INJURIES_DIR_END
    df_injuries = pd.read_parquet(file)
    df_injuries = df_injuries[["gsis_id", "team", "season", "week", "report_primary_injury", "report_secondary_injury", "report_status", "practice_primary_injury", "practice_secondary_injury", "practice_status"]]
    
    df_injuries["practice_status"] = df_injuries["practice_status"].str.strip().replace("", np.nan)
    df_injuries["report_status"] = df_injuries["report_status"].str.strip().replace("", np.nan)

    # Get Player IDs
    df_injuries = df_injuries.merge(df_players_db[["player_id_import", "player_id"]], left_on=["gsis_id"], right_on=["player_id_import"], how="left")\
    .drop(columns=["player_id_import", "gsis_id"]).dropna(subset=["player_id"])

    # Get Team IDs
    df_injuries["team"] = df_injuries["team"].replace("SL", "STL")
    df_injuries = df_injuries.merge(df_teams_db[["abbreviation", "team_id", "season"]], left_on=["team", "season"], right_on=["abbreviation", "season"], how="left").drop(columns=["abbreviation", "team", "season"])

    # Get Game ID's
    df_injuries = df_injuries.merge(df_games_db[["game_id", "away_team_id", "week"]], left_on=["team_id", "week"], right_on=["away_team_id", "week"], how="left").drop(columns=["away_team_id"])
    df_injuries = df_injuries.merge(df_games_db[["game_id", "home_team_id", "week"]], left_on=["team_id", "week"], right_on=["home_team_id", "week"], how="left").drop(columns=["home_team_id", "week"])
    df_injuries["game_id"] = df_injuries["game_id_x"].fillna(df_injuries["game_id_y"])
    df_injuries = df_injuries.drop(columns=["game_id_x", "game_id_y"])
    df_injuries = df_injuries.dropna(subset=["game_id"])

    # Remove entries that already exist in database
    df_injuries = pd.merge(df_injuries, df_injuries_db[["player_id", "team_id", "game_id"]], on=["player_id", "team_id", "game_id"], how="left", indicator=True)
    df_injuries = df_injuries[df_injuries["_merge"] == "left_only"].drop(columns=["_merge"])

    n = df_injuries.to_sql("injuries", engine, if_exists="append", index=False, method='multi', )
    print(f"Inserted {n} Rows into Injuries")
    print("")  

"""# Execute All"""

try:
  do_teams()
  do_players()
  do_games()
  do_plays()
  do_play_participants()
  do_rosters()
  do_injuries()
except Exception as e:
  print(type(e).__name__)
  print(str(e)[:1000])   # print first 1000 chars