--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

-- Started on 2025-09-13 15:31:05

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 229 (class 1259 OID 32827)
-- Name: games; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.games (
    game_id integer NOT NULL,
    regular_season boolean,
    away_team_id integer NOT NULL,
    home_team_id integer NOT NULL,
    week integer NOT NULL,
    game_date date,
    start_time time without time zone,
    stadium text,
    roof boolean,
    surface text,
    weather text,
    wind integer,
    season integer,
    spread_line numeric(4,1),
    total_line numeric(4,1),
    division_game boolean,
    neutral_location boolean,
    home_coach text,
    away_coach text,
    game_id_import text
);


ALTER TABLE public.games OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 32825)
-- Name: Games_away_team_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Games_away_team_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Games_away_team_id_seq" OWNER TO postgres;

--
-- TOC entry 5003 (class 0 OID 0)
-- Dependencies: 227
-- Name: Games_away_team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Games_away_team_id_seq" OWNED BY public.games.away_team_id;


--
-- TOC entry 226 (class 1259 OID 32824)
-- Name: Games_game_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Games_game_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Games_game_id_seq" OWNER TO postgres;

--
-- TOC entry 5004 (class 0 OID 0)
-- Dependencies: 226
-- Name: Games_game_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Games_game_id_seq" OWNED BY public.games.game_id;


--
-- TOC entry 228 (class 1259 OID 32826)
-- Name: Games_home_team_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Games_home_team_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Games_home_team_id_seq" OWNER TO postgres;

--
-- TOC entry 5005 (class 0 OID 0)
-- Dependencies: 228
-- Name: Games_home_team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Games_home_team_id_seq" OWNED BY public.games.home_team_id;


--
-- TOC entry 233 (class 1259 OID 32840)
-- Name: injuries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.injuries (
    player_id integer NOT NULL,
    team_id integer NOT NULL,
    game_id integer NOT NULL,
    report_primary_injury text,
    report_secondary_injury text,
    report_status text,
    practice_primary_injury text,
    practice_secondary_injury text,
    practice_status text
);


ALTER TABLE public.injuries OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 32839)
-- Name: Injuries_game_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Injuries_game_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Injuries_game_id_seq" OWNER TO postgres;

--
-- TOC entry 5006 (class 0 OID 0)
-- Dependencies: 232
-- Name: Injuries_game_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Injuries_game_id_seq" OWNED BY public.injuries.game_id;


--
-- TOC entry 230 (class 1259 OID 32837)
-- Name: Injuries_player_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Injuries_player_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Injuries_player_id_seq" OWNER TO postgres;

--
-- TOC entry 5007 (class 0 OID 0)
-- Dependencies: 230
-- Name: Injuries_player_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Injuries_player_id_seq" OWNED BY public.injuries.player_id;


--
-- TOC entry 231 (class 1259 OID 32838)
-- Name: Injuries_team_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Injuries_team_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Injuries_team_id_seq" OWNER TO postgres;

--
-- TOC entry 5008 (class 0 OID 0)
-- Dependencies: 231
-- Name: Injuries_team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Injuries_team_id_seq" OWNED BY public.injuries.team_id;


--
-- TOC entry 243 (class 1259 OID 32869)
-- Name: play_participants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.play_participants (
    play_id bigint NOT NULL,
    player_id integer NOT NULL,
    role text
);


ALTER TABLE public.play_participants OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 32867)
-- Name: PlayParticipants_play_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."PlayParticipants_play_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."PlayParticipants_play_id_seq" OWNER TO postgres;

--
-- TOC entry 5009 (class 0 OID 0)
-- Dependencies: 241
-- Name: PlayParticipants_play_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."PlayParticipants_play_id_seq" OWNED BY public.play_participants.play_id;


--
-- TOC entry 242 (class 1259 OID 32868)
-- Name: PlayParticipants_player_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."PlayParticipants_player_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."PlayParticipants_player_id_seq" OWNER TO postgres;

--
-- TOC entry 5010 (class 0 OID 0)
-- Dependencies: 242
-- Name: PlayParticipants_player_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."PlayParticipants_player_id_seq" OWNED BY public.play_participants.player_id;


--
-- TOC entry 219 (class 1259 OID 32795)
-- Name: players; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.players (
    player_id integer NOT NULL,
    player_id_import character varying(10),
    first_name text NOT NULL,
    last_name text NOT NULL,
    college text,
    date_of_birth date,
    draft_number integer,
    draft_team_id integer,
    rookie_year integer
);


ALTER TABLE public.players OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 32794)
-- Name: Players_draft_team_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Players_draft_team_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Players_draft_team_id_seq" OWNER TO postgres;

--
-- TOC entry 5011 (class 0 OID 0)
-- Dependencies: 218
-- Name: Players_draft_team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Players_draft_team_id_seq" OWNED BY public.players.draft_team_id;


--
-- TOC entry 217 (class 1259 OID 32793)
-- Name: Players_player_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Players_player_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Players_player_id_seq" OWNER TO postgres;

--
-- TOC entry 5012 (class 0 OID 0)
-- Dependencies: 217
-- Name: Players_player_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Players_player_id_seq" OWNED BY public.players.player_id;


--
-- TOC entry 240 (class 1259 OID 32854)
-- Name: plays; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.plays (
    play_id bigint NOT NULL,
    play_id_import integer,
    game_id integer NOT NULL,
    possession_team_id integer,
    side_of_field_team_id integer,
    yardline_100 integer,
    game_seconds_remaining integer,
    quarter_end boolean,
    drive integer,
    scoring_play boolean,
    down integer,
    goal_to_go boolean,
    yards_to_go integer,
    description text,
    play_type text,
    yards_gained integer,
    shotgun boolean,
    no_huddle boolean,
    qb_dropback boolean,
    qb_scramble boolean,
    pass_location text,
    air_yards integer,
    yards_after_catch integer,
    run_location text,
    run_gap text,
    field_goal_result text,
    kick_distance integer,
    extra_point_result text,
    two_point_conv_result text,
    home_timeouts_remaining integer,
    away_timeouts_remaining integer,
    timeout boolean,
    timeout_team_id integer,
    total_home_score integer,
    total_away_score integer,
    incomplete_pass boolean,
    complete_pass boolean,
    touchback boolean,
    interception boolean,
    fumble_forced boolean,
    fumble_out_of_bounds boolean,
    penalty boolean,
    fumble_lost boolean,
    qb_hit boolean,
    sack boolean,
    touchdown boolean,
    pass_touchdown boolean,
    rush_touchdown boolean,
    two_point_attempt boolean,
    fumble boolean,
    lateral_reception boolean,
    lateral_rush boolean,
    lateral_return boolean,
    lateral_recovery boolean,
    passing_yards integer,
    receiving_yards integer,
    rushing_yards integer,
    lateral_receiving_yards integer,
    lateral_rushing_yards integer,
    fumble_recovery_1_yards integer,
    fumble_recovery_2_yards integer,
    return_team_id integer,
    return_yards integer,
    penalty_yards integer,
    replay_or_challenge_result text,
    penalty_type text,
    defensive_two_point_conv boolean,
    defensive_extra_point_conv boolean,
    series_result text,
    time_of_day time without time zone,
    fixed_drive_result text,
    aborted_play boolean,
    out_of_bounds boolean,
    punt_inside_twenty boolean,
    punt_in_endzone boolean,
    punt_out_of_bounds boolean,
    punt_downed boolean,
    punt_fair_catch boolean,
    punt_blocked boolean,
    kickoff_inside_twenty boolean,
    kickoff_in_endzone boolean,
    kickoff_out_of_bounds boolean,
    kickoff_downed boolean,
    kickoff_fair_catch boolean,
    own_kickoff_recovery boolean,
    own_kickoff_recovery_td boolean
);


ALTER TABLE public.plays OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 32849)
-- Name: Plays_game_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Plays_game_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Plays_game_id_seq" OWNER TO postgres;

--
-- TOC entry 5013 (class 0 OID 0)
-- Dependencies: 235
-- Name: Plays_game_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Plays_game_id_seq" OWNED BY public.plays.game_id;


--
-- TOC entry 234 (class 1259 OID 32848)
-- Name: Plays_play_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Plays_play_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Plays_play_id_seq" OWNER TO postgres;

--
-- TOC entry 5014 (class 0 OID 0)
-- Dependencies: 234
-- Name: Plays_play_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Plays_play_id_seq" OWNED BY public.plays.play_id;


--
-- TOC entry 236 (class 1259 OID 32850)
-- Name: Plays_possession_team_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Plays_possession_team_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Plays_possession_team_id_seq" OWNER TO postgres;

--
-- TOC entry 5015 (class 0 OID 0)
-- Dependencies: 236
-- Name: Plays_possession_team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Plays_possession_team_id_seq" OWNED BY public.plays.possession_team_id;


--
-- TOC entry 239 (class 1259 OID 32853)
-- Name: Plays_return_team_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Plays_return_team_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Plays_return_team_id_seq" OWNER TO postgres;

--
-- TOC entry 5016 (class 0 OID 0)
-- Dependencies: 239
-- Name: Plays_return_team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Plays_return_team_id_seq" OWNED BY public.plays.return_team_id;


--
-- TOC entry 237 (class 1259 OID 32851)
-- Name: Plays_side_of_field_team_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Plays_side_of_field_team_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Plays_side_of_field_team_id_seq" OWNER TO postgres;

--
-- TOC entry 5017 (class 0 OID 0)
-- Dependencies: 237
-- Name: Plays_side_of_field_team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Plays_side_of_field_team_id_seq" OWNED BY public.plays.side_of_field_team_id;


--
-- TOC entry 238 (class 1259 OID 32852)
-- Name: Plays_timeout_team_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Plays_timeout_team_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Plays_timeout_team_id_seq" OWNER TO postgres;

--
-- TOC entry 5018 (class 0 OID 0)
-- Dependencies: 238
-- Name: Plays_timeout_team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Plays_timeout_team_id_seq" OWNED BY public.plays.timeout_team_id;


--
-- TOC entry 225 (class 1259 OID 32816)
-- Name: rosters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rosters (
    player_id integer NOT NULL,
    team_id integer NOT NULL,
    height integer,
    weight integer,
    game_id integer NOT NULL,
    jersey_number integer,
    "position" text
);


ALTER TABLE public.rosters OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 32815)
-- Name: Rosters_game_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Rosters_game_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Rosters_game_id_seq" OWNER TO postgres;

--
-- TOC entry 5019 (class 0 OID 0)
-- Dependencies: 224
-- Name: Rosters_game_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Rosters_game_id_seq" OWNED BY public.rosters.game_id;


--
-- TOC entry 222 (class 1259 OID 32813)
-- Name: Rosters_player_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Rosters_player_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Rosters_player_id_seq" OWNER TO postgres;

--
-- TOC entry 5020 (class 0 OID 0)
-- Dependencies: 222
-- Name: Rosters_player_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Rosters_player_id_seq" OWNED BY public.rosters.player_id;


--
-- TOC entry 223 (class 1259 OID 32814)
-- Name: Rosters_team_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Rosters_team_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Rosters_team_id_seq" OWNER TO postgres;

--
-- TOC entry 5021 (class 0 OID 0)
-- Dependencies: 223
-- Name: Rosters_team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Rosters_team_id_seq" OWNED BY public.rosters.team_id;


--
-- TOC entry 221 (class 1259 OID 32805)
-- Name: teams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teams (
    team_id integer NOT NULL,
    abbreviation character varying(3),
    season integer NOT NULL
);


ALTER TABLE public.teams OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 32804)
-- Name: Teams_team_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Teams_team_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Teams_team_id_seq" OWNER TO postgres;

--
-- TOC entry 5022 (class 0 OID 0)
-- Dependencies: 220
-- Name: Teams_team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Teams_team_id_seq" OWNED BY public.teams.team_id;


--
-- TOC entry 4784 (class 2604 OID 32830)
-- Name: games game_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games ALTER COLUMN game_id SET DEFAULT nextval('public."Games_game_id_seq"'::regclass);


--
-- TOC entry 4785 (class 2604 OID 32831)
-- Name: games away_team_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games ALTER COLUMN away_team_id SET DEFAULT nextval('public."Games_away_team_id_seq"'::regclass);


--
-- TOC entry 4786 (class 2604 OID 32832)
-- Name: games home_team_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games ALTER COLUMN home_team_id SET DEFAULT nextval('public."Games_home_team_id_seq"'::regclass);


--
-- TOC entry 4787 (class 2604 OID 32843)
-- Name: injuries player_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.injuries ALTER COLUMN player_id SET DEFAULT nextval('public."Injuries_player_id_seq"'::regclass);


--
-- TOC entry 4788 (class 2604 OID 32844)
-- Name: injuries team_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.injuries ALTER COLUMN team_id SET DEFAULT nextval('public."Injuries_team_id_seq"'::regclass);


--
-- TOC entry 4789 (class 2604 OID 32845)
-- Name: injuries game_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.injuries ALTER COLUMN game_id SET DEFAULT nextval('public."Injuries_game_id_seq"'::regclass);


--
-- TOC entry 4796 (class 2604 OID 32872)
-- Name: play_participants play_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.play_participants ALTER COLUMN play_id SET DEFAULT nextval('public."PlayParticipants_play_id_seq"'::regclass);


--
-- TOC entry 4797 (class 2604 OID 32873)
-- Name: play_participants player_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.play_participants ALTER COLUMN player_id SET DEFAULT nextval('public."PlayParticipants_player_id_seq"'::regclass);


--
-- TOC entry 4778 (class 2604 OID 32798)
-- Name: players player_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.players ALTER COLUMN player_id SET DEFAULT nextval('public."Players_player_id_seq"'::regclass);


--
-- TOC entry 4779 (class 2604 OID 32799)
-- Name: players draft_team_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.players ALTER COLUMN draft_team_id SET DEFAULT nextval('public."Players_draft_team_id_seq"'::regclass);


--
-- TOC entry 4790 (class 2604 OID 32857)
-- Name: plays play_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plays ALTER COLUMN play_id SET DEFAULT nextval('public."Plays_play_id_seq"'::regclass);


--
-- TOC entry 4791 (class 2604 OID 32858)
-- Name: plays game_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plays ALTER COLUMN game_id SET DEFAULT nextval('public."Plays_game_id_seq"'::regclass);


--
-- TOC entry 4792 (class 2604 OID 32859)
-- Name: plays possession_team_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plays ALTER COLUMN possession_team_id SET DEFAULT nextval('public."Plays_possession_team_id_seq"'::regclass);


--
-- TOC entry 4793 (class 2604 OID 32860)
-- Name: plays side_of_field_team_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plays ALTER COLUMN side_of_field_team_id SET DEFAULT nextval('public."Plays_side_of_field_team_id_seq"'::regclass);


--
-- TOC entry 4794 (class 2604 OID 32861)
-- Name: plays timeout_team_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plays ALTER COLUMN timeout_team_id SET DEFAULT nextval('public."Plays_timeout_team_id_seq"'::regclass);


--
-- TOC entry 4795 (class 2604 OID 32862)
-- Name: plays return_team_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plays ALTER COLUMN return_team_id SET DEFAULT nextval('public."Plays_return_team_id_seq"'::regclass);


--
-- TOC entry 4781 (class 2604 OID 32819)
-- Name: rosters player_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rosters ALTER COLUMN player_id SET DEFAULT nextval('public."Rosters_player_id_seq"'::regclass);


--
-- TOC entry 4782 (class 2604 OID 32820)
-- Name: rosters team_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rosters ALTER COLUMN team_id SET DEFAULT nextval('public."Rosters_team_id_seq"'::regclass);


--
-- TOC entry 4783 (class 2604 OID 32821)
-- Name: rosters game_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rosters ALTER COLUMN game_id SET DEFAULT nextval('public."Rosters_game_id_seq"'::regclass);


--
-- TOC entry 4780 (class 2604 OID 32808)
-- Name: teams team_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams ALTER COLUMN team_id SET DEFAULT nextval('public."Teams_team_id_seq"'::regclass);


--
-- TOC entry 4818 (class 2606 OID 32836)
-- Name: games Games_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games
    ADD CONSTRAINT "Games_pkey" PRIMARY KEY (game_id);


--
-- TOC entry 4799 (class 2606 OID 33037)
-- Name: games Games_surface_check; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.games
    ADD CONSTRAINT "Games_surface_check" CHECK ((surface = ANY (ARRAY['a_turf'::text, 'grass'::text, 'sportturf'::text, 'fieldturf'::text, 'matrixturf'::text, 'astroturf'::text]))) NOT VALID;


--
-- TOC entry 4812 (class 2606 OID 33040)
-- Name: play_participants PlayParticipants_role_check; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.play_participants
    ADD CONSTRAINT "PlayParticipants_role_check" CHECK ((role = ANY (ARRAY['passer'::text, 'rusher'::text, 'receiver'::text, 'touchdown_scorer'::text, 'lateral_receiver'::text, 'lateral_rusher'::text, 'lateral_sack'::text, 'interception'::text, 'lateral_interception'::text, 'punt_returner'::text, 'lateral_punt_returner'::text, 'kickoff_returner'::text, 'lateral_kickoff_returner'::text, 'punter'::text, 'kicker'::text, 'own_kickoff'::text, 'blocked_kick'::text, 'tackle_for_loss_1'::text, 'tackle_for_loss_2'::text, 'qb_hit_1'::text, 'qb_hit_2'::text, 'forced_fumble_player_1'::text, 'forced_fumble_player_2'::text, 'solo_tackle_1'::text, 'solo_tackle_2'::text, 'assist_tackle_1'::text, 'assist_tackle_2'::text, 'assist_tackle_3'::text, 'assist_tackle_4'::text, 'tackle_with_assist_1'::text, 'tackle_with_assist_2'::text, 'pass_defense_1'::text, 'pass_defense_2'::text, 'fumbled_1'::text, 'fumbled_2'::text, 'fumble_recovery_1'::text, 'fumble_recovery_2'::text, 'sack'::text, 'half_sack_1'::text, 'half_sack_2'::text, 'penalty'::text, 'safety'::text]))) NOT VALID;


--
-- TOC entry 4814 (class 2606 OID 32803)
-- Name: players Players_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT "Players_pkey" PRIMARY KEY (player_id);


--
-- TOC entry 4802 (class 2606 OID 33045)
-- Name: plays Plays_field_goal_result_check; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.plays
    ADD CONSTRAINT "Plays_field_goal_result_check" CHECK ((field_goal_result = ANY (ARRAY['made'::text, 'missed'::text, 'blocked'::text]))) NOT VALID;


--
-- TOC entry 4803 (class 2606 OID 33052)
-- Name: plays Plays_fixed_drive_result_check; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.plays
    ADD CONSTRAINT "Plays_fixed_drive_result_check" CHECK ((fixed_drive_result = ANY (ARRAY['Touchdown'::text, 'Turnover'::text, 'Field goal'::text, 'End of half'::text, 'Punt'::text, 'Turnover on downs'::text, 'Missed field goal'::text, 'Opp touchdown'::text, 'Safety'::text]))) NOT VALID;


--
-- TOC entry 4804 (class 2606 OID 33042)
-- Name: plays Plays_pass_location_check; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.plays
    ADD CONSTRAINT "Plays_pass_location_check" CHECK ((pass_location = ANY (ARRAY['left'::text, 'middle'::text, 'right'::text]))) NOT VALID;


--
-- TOC entry 4820 (class 2606 OID 32866)
-- Name: plays Plays_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plays
    ADD CONSTRAINT "Plays_pkey" PRIMARY KEY (play_id);


--
-- TOC entry 4805 (class 2606 OID 33041)
-- Name: plays Plays_play_type_check; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.plays
    ADD CONSTRAINT "Plays_play_type_check" CHECK ((play_type = ANY (ARRAY['kickoff'::text, 'run'::text, 'pass'::text, 'extra_point'::text, 'field_goal'::text, 'no_play'::text, 'qb_kneel'::text, 'punt'::text, 'qb_spike'::text]))) NOT VALID;


--
-- TOC entry 4806 (class 2606 OID 33044)
-- Name: plays Plays_run_gap_check; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.plays
    ADD CONSTRAINT "Plays_run_gap_check" CHECK ((run_gap = ANY (ARRAY['guard'::text, 'end'::text, 'tackle'::text]))) NOT VALID;


--
-- TOC entry 4807 (class 2606 OID 33043)
-- Name: plays Plays_run_location_check; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.plays
    ADD CONSTRAINT "Plays_run_location_check" CHECK ((run_location = ANY (ARRAY['middle'::text, 'left'::text, 'right'::text]))) NOT VALID;


--
-- TOC entry 4808 (class 2606 OID 33051)
-- Name: plays Plays_series_result_check; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.plays
    ADD CONSTRAINT "Plays_series_result_check" CHECK ((series_result = ANY (ARRAY['First down'::text, 'Touchdown'::text, 'Turnover'::text, 'Field goal'::text, 'QB kneel'::text, 'Punt'::text, 'Turnover on downs'::text, 'Missed field goal'::text, 'End of half'::text, 'Opp touchdown'::text, 'Safety'::text]))) NOT VALID;


--
-- TOC entry 4809 (class 2606 OID 33048)
-- Name: plays Plays_two_point_conv_result_check; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.plays
    ADD CONSTRAINT "Plays_two_point_conv_result_check" CHECK ((two_point_conv_result = ANY (ARRAY['success'::text, 'failure'::text]))) NOT VALID;


--
-- TOC entry 4816 (class 2606 OID 32812)
-- Name: teams Teams_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT "Teams_pkey" PRIMARY KEY (team_id);


--
-- TOC entry 4800 (class 2606 OID 33094)
-- Name: injuries injuries_practice_status_check; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.injuries
    ADD CONSTRAINT injuries_practice_status_check CHECK ((practice_status = ANY (ARRAY['Did Not Participate In Practice'::text, 'Limited Participation in Practice'::text, 'Full Participation in Practice'::text, 'Out (Definitely Will Not Play)'::text, 'Note'::text]))) NOT VALID;


--
-- TOC entry 4801 (class 2606 OID 33095)
-- Name: injuries injuries_report_status_check; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.injuries
    ADD CONSTRAINT injuries_report_status_check CHECK ((report_status = ANY (ARRAY['Out'::text, 'Questionable'::text, 'Doubtful'::text, 'Probable'::text, 'Note'::text]))) NOT VALID;


--
-- TOC entry 4810 (class 2606 OID 33060)
-- Name: plays plays_extra_point_result_check; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.plays
    ADD CONSTRAINT plays_extra_point_result_check CHECK ((extra_point_result = ANY (ARRAY['good'::text, 'failed'::text, 'aborted'::text, 'blocked'::text]))) NOT VALID;


--
-- TOC entry 4811 (class 2606 OID 33061)
-- Name: plays plays_replay_or_challenge_result_check; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.plays
    ADD CONSTRAINT plays_replay_or_challenge_result_check CHECK ((replay_or_challenge_result = ANY (ARRAY['reversed'::text, 'upheld'::text, 'denied'::text]))) NOT VALID;


--
-- TOC entry 4798 (class 2606 OID 33089)
-- Name: rosters rosters_position_check; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.rosters
    ADD CONSTRAINT rosters_position_check CHECK (("position" = ANY (ARRAY['RB'::text, 'CB'::text, 'G'::text, 'T'::text, 'DT'::text, 'DE'::text, 'K'::text, 'SS'::text, 'C'::text, 'FS'::text, 'WR'::text, 'TE'::text, 'FB'::text, 'OLB'::text, 'QB'::text, 'P'::text, 'MLB'::text, 'NT'::text, 'ILB'::text, 'LB'::text, 'DB'::text, 'S'::text, 'LS'::text, 'KR'::text, 'PR'::text, 'OL'::text, 'DL'::text]))) NOT VALID;


--
-- TOC entry 4829 (class 2606 OID 32896)
-- Name: games Games_away_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games
    ADD CONSTRAINT "Games_away_team_id_fkey" FOREIGN KEY (away_team_id) REFERENCES public.teams(team_id) NOT VALID;


--
-- TOC entry 4830 (class 2606 OID 32977)
-- Name: games Games_away_team_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games
    ADD CONSTRAINT "Games_away_team_id_fkey1" FOREIGN KEY (away_team_id) REFERENCES public.teams(team_id) NOT VALID;


--
-- TOC entry 4831 (class 2606 OID 32901)
-- Name: games Games_home_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games
    ADD CONSTRAINT "Games_home_team_id_fkey" FOREIGN KEY (home_team_id) REFERENCES public.teams(team_id) NOT VALID;


--
-- TOC entry 4832 (class 2606 OID 32982)
-- Name: games Games_home_team_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games
    ADD CONSTRAINT "Games_home_team_id_fkey1" FOREIGN KEY (home_team_id) REFERENCES public.teams(team_id) NOT VALID;


--
-- TOC entry 4833 (class 2606 OID 32916)
-- Name: injuries Injuries_game_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.injuries
    ADD CONSTRAINT "Injuries_game_id_fkey" FOREIGN KEY (game_id) REFERENCES public.games(game_id) NOT VALID;


--
-- TOC entry 4834 (class 2606 OID 32997)
-- Name: injuries Injuries_game_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.injuries
    ADD CONSTRAINT "Injuries_game_id_fkey1" FOREIGN KEY (game_id) REFERENCES public.games(game_id) NOT VALID;


--
-- TOC entry 4835 (class 2606 OID 32906)
-- Name: injuries Injuries_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.injuries
    ADD CONSTRAINT "Injuries_player_id_fkey" FOREIGN KEY (player_id) REFERENCES public.players(player_id) NOT VALID;


--
-- TOC entry 4836 (class 2606 OID 32987)
-- Name: injuries Injuries_player_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.injuries
    ADD CONSTRAINT "Injuries_player_id_fkey1" FOREIGN KEY (player_id) REFERENCES public.players(player_id) NOT VALID;


--
-- TOC entry 4837 (class 2606 OID 32911)
-- Name: injuries Injuries_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.injuries
    ADD CONSTRAINT "Injuries_team_id_fkey" FOREIGN KEY (team_id) REFERENCES public.teams(team_id) NOT VALID;


--
-- TOC entry 4838 (class 2606 OID 32992)
-- Name: injuries Injuries_team_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.injuries
    ADD CONSTRAINT "Injuries_team_id_fkey1" FOREIGN KEY (team_id) REFERENCES public.teams(team_id) NOT VALID;


--
-- TOC entry 4849 (class 2606 OID 32946)
-- Name: play_participants PlayParticipants_play_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.play_participants
    ADD CONSTRAINT "PlayParticipants_play_id_fkey" FOREIGN KEY (play_id) REFERENCES public.plays(play_id) NOT VALID;


--
-- TOC entry 4850 (class 2606 OID 33027)
-- Name: play_participants PlayParticipants_play_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.play_participants
    ADD CONSTRAINT "PlayParticipants_play_id_fkey1" FOREIGN KEY (play_id) REFERENCES public.plays(play_id) NOT VALID;


--
-- TOC entry 4851 (class 2606 OID 32951)
-- Name: play_participants PlayParticipants_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.play_participants
    ADD CONSTRAINT "PlayParticipants_player_id_fkey" FOREIGN KEY (player_id) REFERENCES public.players(player_id) NOT VALID;


--
-- TOC entry 4852 (class 2606 OID 33032)
-- Name: play_participants PlayParticipants_player_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.play_participants
    ADD CONSTRAINT "PlayParticipants_player_id_fkey1" FOREIGN KEY (player_id) REFERENCES public.players(player_id) NOT VALID;


--
-- TOC entry 4821 (class 2606 OID 32876)
-- Name: players Players_draft_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT "Players_draft_team_id_fkey" FOREIGN KEY (draft_team_id) REFERENCES public.teams(team_id) NOT VALID;


--
-- TOC entry 4822 (class 2606 OID 32957)
-- Name: players Players_draft_team_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT "Players_draft_team_id_fkey1" FOREIGN KEY (draft_team_id) REFERENCES public.teams(team_id) NOT VALID;


--
-- TOC entry 4839 (class 2606 OID 32921)
-- Name: plays Plays_game_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plays
    ADD CONSTRAINT "Plays_game_id_fkey" FOREIGN KEY (game_id) REFERENCES public.games(game_id) NOT VALID;


--
-- TOC entry 4840 (class 2606 OID 33002)
-- Name: plays Plays_game_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plays
    ADD CONSTRAINT "Plays_game_id_fkey1" FOREIGN KEY (game_id) REFERENCES public.games(game_id) NOT VALID;


--
-- TOC entry 4841 (class 2606 OID 32926)
-- Name: plays Plays_possession_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plays
    ADD CONSTRAINT "Plays_possession_team_id_fkey" FOREIGN KEY (possession_team_id) REFERENCES public.teams(team_id) NOT VALID;


--
-- TOC entry 4842 (class 2606 OID 33007)
-- Name: plays Plays_possession_team_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plays
    ADD CONSTRAINT "Plays_possession_team_id_fkey1" FOREIGN KEY (possession_team_id) REFERENCES public.teams(team_id) NOT VALID;


--
-- TOC entry 4843 (class 2606 OID 32941)
-- Name: plays Plays_return_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plays
    ADD CONSTRAINT "Plays_return_team_id_fkey" FOREIGN KEY (return_team_id) REFERENCES public.teams(team_id) NOT VALID;


--
-- TOC entry 4844 (class 2606 OID 33022)
-- Name: plays Plays_return_team_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plays
    ADD CONSTRAINT "Plays_return_team_id_fkey1" FOREIGN KEY (return_team_id) REFERENCES public.teams(team_id) NOT VALID;


--
-- TOC entry 4845 (class 2606 OID 32931)
-- Name: plays Plays_side_of_field_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plays
    ADD CONSTRAINT "Plays_side_of_field_team_id_fkey" FOREIGN KEY (side_of_field_team_id) REFERENCES public.teams(team_id) NOT VALID;


--
-- TOC entry 4846 (class 2606 OID 33012)
-- Name: plays Plays_side_of_field_team_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plays
    ADD CONSTRAINT "Plays_side_of_field_team_id_fkey1" FOREIGN KEY (side_of_field_team_id) REFERENCES public.teams(team_id) NOT VALID;


--
-- TOC entry 4847 (class 2606 OID 32936)
-- Name: plays Plays_timeout_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plays
    ADD CONSTRAINT "Plays_timeout_team_id_fkey" FOREIGN KEY (timeout_team_id) REFERENCES public.teams(team_id) NOT VALID;


--
-- TOC entry 4848 (class 2606 OID 33017)
-- Name: plays Plays_timeout_team_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plays
    ADD CONSTRAINT "Plays_timeout_team_id_fkey1" FOREIGN KEY (timeout_team_id) REFERENCES public.teams(team_id) NOT VALID;


--
-- TOC entry 4823 (class 2606 OID 32891)
-- Name: rosters Rosters_game_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rosters
    ADD CONSTRAINT "Rosters_game_id_fkey" FOREIGN KEY (game_id) REFERENCES public.games(game_id) NOT VALID;


--
-- TOC entry 4824 (class 2606 OID 32972)
-- Name: rosters Rosters_game_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rosters
    ADD CONSTRAINT "Rosters_game_id_fkey1" FOREIGN KEY (game_id) REFERENCES public.games(game_id) NOT VALID;


--
-- TOC entry 4825 (class 2606 OID 32881)
-- Name: rosters Rosters_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rosters
    ADD CONSTRAINT "Rosters_player_id_fkey" FOREIGN KEY (player_id) REFERENCES public.players(player_id) NOT VALID;


--
-- TOC entry 4826 (class 2606 OID 32962)
-- Name: rosters Rosters_player_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rosters
    ADD CONSTRAINT "Rosters_player_id_fkey1" FOREIGN KEY (player_id) REFERENCES public.players(player_id) NOT VALID;


--
-- TOC entry 4827 (class 2606 OID 32886)
-- Name: rosters Rosters_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rosters
    ADD CONSTRAINT "Rosters_team_id_fkey" FOREIGN KEY (team_id) REFERENCES public.teams(team_id) NOT VALID;


--
-- TOC entry 4828 (class 2606 OID 32967)
-- Name: rosters Rosters_team_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rosters
    ADD CONSTRAINT "Rosters_team_id_fkey1" FOREIGN KEY (team_id) REFERENCES public.teams(team_id) NOT VALID;


-- Completed on 2025-09-13 15:31:05

--
-- PostgreSQL database dump complete
--

