--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

ALTER TABLE ONLY public.user_parameter DROP CONSTRAINT user_parameter_user;
ALTER TABLE ONLY public.session_parameter DROP CONSTRAINT session_parameter_session;
ALTER TABLE ONLY public.project DROP CONSTRAINT project_status_id_fkey;
ALTER TABLE ONLY public.project DROP CONSTRAINT project_ruleset_id_fkey;
DROP INDEX public.fki_session_parameter_session;
ALTER TABLE ONLY public.users DROP CONSTRAINT user_pkey;
ALTER TABLE ONLY public.user_parameter DROP CONSTRAINT user_parameter_user_id_name_key;
ALTER TABLE ONLY public.user_parameter DROP CONSTRAINT user_parameter_pkey;
ALTER TABLE ONLY public.users DROP CONSTRAINT user_login_key;
ALTER TABLE ONLY public.session DROP CONSTRAINT session_uuid_key;
ALTER TABLE ONLY public.session DROP CONSTRAINT session_pkey;
ALTER TABLE ONLY public.session_parameter DROP CONSTRAINT session_parameter_session_id_name_key;
ALTER TABLE ONLY public.session_parameter DROP CONSTRAINT session_parameter_pkey;
ALTER TABLE ONLY public.project_ruleset DROP CONSTRAINT ruleset_pkey;
ALTER TABLE ONLY public.project_status DROP CONSTRAINT project_status_pkey;
ALTER TABLE ONLY public.project_status DROP CONSTRAINT project_status_name_key;
ALTER TABLE ONLY public.project_ruleset DROP CONSTRAINT project_ruleset_name_key;
ALTER TABLE ONLY public.project DROP CONSTRAINT project_pkey;
ALTER TABLE ONLY public.participant DROP CONSTRAINT participant_project_id_user_id_key;
ALTER TABLE ONLY public.participant DROP CONSTRAINT participant_project_id_nm_key;
ALTER TABLE ONLY public.participant DROP CONSTRAINT participant_pkey;
ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.user_parameter ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.session_parameter ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.session ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.project_status ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.project_ruleset ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.project ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.participant ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE public.user_parameter_id_seq;
DROP TABLE public.user_parameter;
DROP SEQUENCE public.user_id_seq;
DROP TABLE public.users;
DROP SEQUENCE public.session_parameter_id_seq;
DROP TABLE public.session_parameter;
DROP SEQUENCE public.session_id_seq;
DROP TABLE public.session;
DROP SEQUENCE public.ruleset_id_seq;
DROP SEQUENCE public.project_status_id_seq;
DROP TABLE public.project_status;
DROP TABLE public.project_ruleset;
DROP SEQUENCE public.project_id_seq;
DROP TABLE public.project;
DROP SEQUENCE public.participant_id_seq;
DROP TABLE public.participant;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: participant; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE participant (
    id integer NOT NULL,
    project_id integer NOT NULL,
    is_initiator boolean DEFAULT false NOT NULL,
    user_id integer,
    nm character varying(50) NOT NULL,
    descr text,
    accept boolean DEFAULT false NOT NULL,
    creation timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: COLUMN participant.is_initiator; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN participant.is_initiator IS 'the sign that this participant is initiator of the project';


--
-- Name: COLUMN participant.user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN participant.user_id IS 'registered user if exists';


--
-- Name: COLUMN participant.nm; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN participant.nm IS 'nick of participant in current project';


--
-- Name: COLUMN participant.descr; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN participant.descr IS 'detailed description ';


--
-- Name: COLUMN participant.accept; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN participant.accept IS 'paticipant is accepted for project';


--
-- Name: participant_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE participant_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: participant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE participant_id_seq OWNED BY participant.id;


--
-- Name: project; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE project (
    id integer NOT NULL,
    nm text NOT NULL,
    descr text,
    sharing boolean DEFAULT true NOT NULL,
    begin timestamp with time zone,
    "end" timestamp with time zone,
    creation timestamp with time zone DEFAULT now() NOT NULL,
    ruleset_id integer NOT NULL,
    status_id integer NOT NULL
);


--
-- Name: COLUMN project.nm; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN project.nm IS 'name of the project';


--
-- Name: COLUMN project.descr; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN project.descr IS 'description of the project';


--
-- Name: COLUMN project.sharing; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN project.sharing IS 'true if project is open';


--
-- Name: COLUMN project."end"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN project."end" IS 'timestamp of the project''s final';


--
-- Name: COLUMN project.creation; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN project.creation IS 'timestamp of project creation';


--
-- Name: project_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE project_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE project_id_seq OWNED BY project.id;


--
-- Name: project_ruleset; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE project_ruleset (
    id integer NOT NULL,
    name character varying,
    descr text
);


--
-- Name: TABLE project_ruleset; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE project_ruleset IS 'ways to control the management of project';


--
-- Name: COLUMN project_ruleset.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN project_ruleset.name IS 'name of the way to control the project';


--
-- Name: COLUMN project_ruleset.descr; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN project_ruleset.descr IS 'description of the way to control';


--
-- Name: project_status; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE project_status (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    descr text
);


--
-- Name: TABLE project_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE project_status IS 'status of the current project';


--
-- Name: COLUMN project_status.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN project_status.name IS 'name of status';


--
-- Name: COLUMN project_status.descr; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN project_status.descr IS 'detailed description of status';


--
-- Name: project_status_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE project_status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_status_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE project_status_id_seq OWNED BY project_status.id;


--
-- Name: ruleset_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ruleset_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ruleset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ruleset_id_seq OWNED BY project_ruleset.id;


--
-- Name: session; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE session (
    id integer NOT NULL,
    uuid character varying(45) NOT NULL,
    expiration_date timestamp with time zone,
    creation_date timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: session_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE session_id_seq OWNED BY session.id;


--
-- Name: session_parameter; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE session_parameter (
    id integer NOT NULL,
    session_id integer NOT NULL,
    name character varying(100) NOT NULL,
    table_reference integer,
    value text
);


--
-- Name: session_parameter_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE session_parameter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: session_parameter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE session_parameter_id_seq OWNED BY session_parameter.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    name character varying(50),
    login character varying(50) NOT NULL,
    password character varying,
    email character varying(120),
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    deleted boolean DEFAULT false NOT NULL
);


--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_id_seq OWNED BY users.id;


--
-- Name: user_parameter; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_parameter (
    id integer NOT NULL,
    user_id integer NOT NULL,
    name character varying(50) NOT NULL,
    value text
);


--
-- Name: user_parameter_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_parameter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_parameter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_parameter_id_seq OWNED BY user_parameter.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE participant ALTER COLUMN id SET DEFAULT nextval('participant_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE project ALTER COLUMN id SET DEFAULT nextval('project_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE project_ruleset ALTER COLUMN id SET DEFAULT nextval('ruleset_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE project_status ALTER COLUMN id SET DEFAULT nextval('project_status_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE session ALTER COLUMN id SET DEFAULT nextval('session_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE session_parameter ALTER COLUMN id SET DEFAULT nextval('session_parameter_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE user_parameter ALTER COLUMN id SET DEFAULT nextval('user_parameter_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users ALTER COLUMN id SET DEFAULT nextval('user_id_seq'::regclass);


--
-- Name: participant_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY participant
    ADD CONSTRAINT participant_pkey PRIMARY KEY (id);


--
-- Name: participant_project_id_nm_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY participant
    ADD CONSTRAINT participant_project_id_nm_key UNIQUE (project_id, nm);


--
-- Name: participant_project_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY participant
    ADD CONSTRAINT participant_project_id_user_id_key UNIQUE (project_id, user_id);


--
-- Name: project_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY project
    ADD CONSTRAINT project_pkey PRIMARY KEY (id);


--
-- Name: project_ruleset_name_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY project_ruleset
    ADD CONSTRAINT project_ruleset_name_key UNIQUE (name);


--
-- Name: project_status_name_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY project_status
    ADD CONSTRAINT project_status_name_key UNIQUE (name);


--
-- Name: project_status_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY project_status
    ADD CONSTRAINT project_status_pkey PRIMARY KEY (id);


--
-- Name: ruleset_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY project_ruleset
    ADD CONSTRAINT ruleset_pkey PRIMARY KEY (id);


--
-- Name: session_parameter_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY session_parameter
    ADD CONSTRAINT session_parameter_pkey PRIMARY KEY (id);


--
-- Name: session_parameter_session_id_name_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY session_parameter
    ADD CONSTRAINT session_parameter_session_id_name_key UNIQUE (session_id, name);


--
-- Name: session_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY session
    ADD CONSTRAINT session_pkey PRIMARY KEY (id);


--
-- Name: session_uuid_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY session
    ADD CONSTRAINT session_uuid_key UNIQUE (uuid);


--
-- Name: user_login_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT user_login_key UNIQUE (login);


--
-- Name: user_parameter_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_parameter
    ADD CONSTRAINT user_parameter_pkey PRIMARY KEY (id);


--
-- Name: user_parameter_user_id_name_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_parameter
    ADD CONSTRAINT user_parameter_user_id_name_key UNIQUE (user_id, name);


--
-- Name: user_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: fki_session_parameter_session; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_session_parameter_session ON session_parameter USING btree (session_id);


--
-- Name: project_ruleset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY project
    ADD CONSTRAINT project_ruleset_id_fkey FOREIGN KEY (ruleset_id) REFERENCES project_ruleset(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: project_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY project
    ADD CONSTRAINT project_status_id_fkey FOREIGN KEY (status_id) REFERENCES project_status(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: session_parameter_session; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY session_parameter
    ADD CONSTRAINT session_parameter_session FOREIGN KEY (session_id) REFERENCES session(id) ON DELETE CASCADE;


--
-- Name: user_parameter_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_parameter
    ADD CONSTRAINT user_parameter_user FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

