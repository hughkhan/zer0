SET TIME ZONE 'UTC';


--
-- Common Sequence
--
CREATE SEQUENCE common_seq
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 5;

--
-- Project Visibility
--
CREATE TYPE project_visibility_type AS ENUM (
	'PUBLIC',
	'PRIVATE'
);

--
-- Project Status
--
CREATE TYPE project_status_type AS ENUM (
	'LAUNCHING',
	'IN_PROGRESS',
	'FINISHED'
);

--
-- Project Type
--
CREATE TYPE project_type AS ENUM (
	'SHORT_TERM_CONTRACT',
	'LONG_TERM_CONTRACT',
	'OPEN_SOURCE'
);


--
-- Project Table
--
CREATE TABLE project (
	id 				INT 					DEFAULT NEXTVAL('common_seq') PRIMARY KEY NOT NULL, 
	name 		    CHARACTER VARYING(64) 	NOT NULL,
	visibility		project_visibility_type DEFAULT 'PRIVATE'::project_visibility_type NOT NULL,
	status 			project_status_type		DEFAULT 'IN_PROGRESS'::project_status_type NOT NULL,
	type 			project_type			DEFAULT 'OPEN_SOURCE'::project_type NOT NULL
);


--
-- Users Table
--
CREATE TABLE users (
	id 				INT 					DEFAULT NEXTVAL('common_seq') PRIMARY KEY NOT NULL, 
	name_first 		CHARACTER VARYING(64) 	NOT NULL,
	name_last 		CHARACTER VARYING(64) 	NOT NULL,
	email 			CHARACTER VARYING(100)	NOT NULL,
	password_hash 	CHARACTER VARYING 		NOT NULL
);


--
-- Project Users Cross Table
--
CREATE TABLE project_x_users (
project_id 		INT 	NOT NULL,
users_id	INT 	NOT NULL,
	CONSTRAINT fk_projecct
		FOREIGN KEY(project_id) 
			REFERENCES project(id)
			ON DELETE CASCADE,
	CONSTRAINT fk_users
		FOREIGN KEY(users_id) 
			REFERENCES users(id)
			ON DELETE CASCADE			
);
