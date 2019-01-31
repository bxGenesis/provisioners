CREATE KEYSPACE bx1
	WITH REPLICATION = {
		'class': 'SimpleStrategy',
		'replication_factor': 1
	}
	AND DURABLE_WRITES = true;

USE bx1;

-- Types --
-- global user location, global group location are examples of the principal
CREATE TYPE bx1.Principal (
	domainmgrId text,
	alias text
);

CREATE TYPE bx1.Credential (
	pwd text
);

-- Tables --
CREATE TABLE bx1.domainmgrs (
	domainmgrId text,
	description text,
	PRIMARY KEY(domainmgrId)
);

CREATE TABLE bx1.users (
	principal frozen<Principal>, -- user principal
	cred frozen<Credential>,
	firstname text,
	lastname text,
    groups set<text>, -- text here is the alias of the group, which together with the implied domainmgrId from user.principal makes unique group id
	PRIMARY KEY(principal)
);
CREATE INDEX IX_users_lastname ON users (lastname);

CREATE TABLE bx1.groups (
	principal frozen<Principal>, -- group principal
	-- other group properties go here
	members set<text>, -- text here is the alias of the user (in a given domainmgr). Note that we *imply* domainmgr, meaning that it's not possible to cross-reference user from other domain. 
	PRIMARY KEY(principal)
);


-- INIT --
	INSERT INTO bx1.domainmgrs (
		domainmgrid,
		description
	)
	VALUES (
		'system',
		'SYSTEM DOMAIN'
	);

	INSERT INTO bx1.domainmgrs (
		domainmgrid,
		description
	)
	VALUES (
		'domainmgr1',
		'-- test domainmgr 1 --'
	);

	INSERT INTO bx1.users (
		principal,
		cred,
		firstname,
		lastname,
		groups
	)
	VALUES (
		('system', 'sa1'), 
		NULL, 
		'Ali',
		'Azad',
		{'administrator', 'otheradmin'}
	);