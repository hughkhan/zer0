--
-- PostgreSQL database dump
--

-- Dumped from database version 13.1
-- Dumped by pg_dump version 13.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: project_status_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.project_status_type AS ENUM (
    'LAUNCHING',
    'IN_PROGRESS',
    'FINISHED'
);


ALTER TYPE public.project_status_type OWNER TO postgres;

--
-- Name: project_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.project_type AS ENUM (
    'SHORT_TERM_CONTRACT',
    'LONG_TERM_CONTRACT',
    'OPEN_SOURCE'
);


ALTER TYPE public.project_type OWNER TO postgres;

--
-- Name: project_visibility_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.project_visibility_type AS ENUM (
    'PUBLIC',
    'PRIVATE'
);


ALTER TYPE public.project_visibility_type OWNER TO postgres;

--
-- Name: common_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.common_seq
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 5;


ALTER TABLE public.common_seq OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: project; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project (
    id integer DEFAULT nextval('public.common_seq'::regclass) NOT NULL,
    name character varying(64) NOT NULL,
    visibility public.project_visibility_type DEFAULT 'PRIVATE'::public.project_visibility_type NOT NULL,
    status public.project_status_type DEFAULT 'IN_PROGRESS'::public.project_status_type NOT NULL,
    type public.project_type DEFAULT 'OPEN_SOURCE'::public.project_type NOT NULL
);


ALTER TABLE public.project OWNER TO postgres;

--
-- Name: project_x_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_x_users (
    project_id integer NOT NULL,
    users_id integer NOT NULL
);


ALTER TABLE public.project_x_users OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer DEFAULT nextval('public.common_seq'::regclass) NOT NULL,
    name_first character varying(64) NOT NULL,
    name_last character varying(64) NOT NULL,
    email character varying(100) NOT NULL,
    password_hash character varying NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Data for Name: project; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project (id, name, visibility, status, type) FROM stdin;
1000	AI-Chicken Gender Sorting	PUBLIC	FINISHED	SHORT_TERM_CONTRACT
1004	Py-evm/Trinity	PUBLIC	IN_PROGRESS	LONG_TERM_CONTRACT
1015	Geth security	PUBLIC	LAUNCHING	LONG_TERM_CONTRACT
1016	LES Server: DoS vulnerabilities	PUBLIC	IN_PROGRESS	SHORT_TERM_CONTRACT
1003	Solidity language security	PRIVATE	LAUNCHING	LONG_TERM_CONTRACT
1002	Bounty: Monero Hack	PRIVATE	LAUNCHING	LONG_TERM_CONTRACT
\.


--
-- Data for Name: project_x_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project_x_users (project_id, users_id) FROM stdin;
1000	1010
1000	1020
1000	1025
1000	1030
1003	1020
1004	1025
1015	1030
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name_first, name_last, email, password_hash) FROM stdin;
1010	Oscar	Wilde	OW@poetrysociety.org	$2a$10$TtryEOBGFIcp0zfDMwWRW.X.minTTJrntP.8j3oA1erTHxR6ZvU/C
1020	Thomas	Hardy	TH@poetrysociety.org	$2a$10$.yCjYqxFzSpjPSQsRa0p/O9K5azlJQAkSAMifGFl45aYIEKQTrjfq
1025	George	Shaw	GS@poetrysociety.org	$2a$10$KnB54YZbPLsGf8J8ClfCu.2dxUJaYG/VzY0lpbX3WWzDd04eNWLcG
1030	Tom	Stoppard	TS@poetrysociety.org	$2a$10$.irj7rXyTE0/nwT18TOAy.61lO4TSr8iFN8kHxqKI3R3ANqkvCzQm
\.


--
-- Name: common_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.common_seq', 1034, true);


--
-- Name: project project_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT project_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: project_x_users fk_projecct; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_x_users
    ADD CONSTRAINT fk_projecct FOREIGN KEY (project_id) REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: project_x_users fk_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_x_users
    ADD CONSTRAINT fk_users FOREIGN KEY (users_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

