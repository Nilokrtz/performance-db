-- public.circuits_db definição
 
-- Drop table
 
-- DROP TABLE public.circuits_db;
 
CREATE TABLE public.circuits_db (
	circuitid serial4 NOT NULL,
	circuitref text NULL,
	"name" text NULL,
	"location" text NULL,
	country text NULL,
	lat numeric NULL,
	lng numeric NULL,
	alt int8 NULL,
	url text NULL
);
CREATE UNIQUE INDEX idx_17112_sqlite_autoindex_circuits_db_1 ON public.circuits_db USING btree (circuitid);
CREATE INDEX index_circuits_name ON public.circuits_db USING btree (name);
 
 
-- public.constructor_db definição
 
-- Drop table
 
-- DROP TABLE public.constructor_db;
 
CREATE TABLE public.constructor_db (
	constructorid serial4 NOT NULL,
	constructorref text NULL,
	"name" text NULL,
	nationality text NULL,
	url text NULL
);
CREATE UNIQUE INDEX idx_17126_sqlite_autoindex_constructor_db_1 ON public.constructor_db USING btree (constructorid);
CREATE INDEX index_constructor_name ON public.constructor_db USING btree (name);
 
 
-- public.seasons_db definição
 
-- Drop table
 
-- DROP TABLE public.seasons_db;
 
CREATE TABLE public.seasons_db (
	seasonid serial4 NOT NULL,
	"year" int8 NULL,
	url text NULL
);
CREATE UNIQUE INDEX idx_17170_sqlite_autoindex_seasons_db_1 ON public.seasons_db USING btree (seasonid);
 
 
-- public.status_db definição
 
-- Drop table
 
-- DROP TABLE public.status_db;
 
CREATE TABLE public.status_db (
	statusid serial4 NOT NULL,
	status text NULL
);
CREATE UNIQUE INDEX idx_17119_sqlite_autoindex_status_db_1 ON public.status_db USING btree (statusid);
 
 
-- public.drivers_db definição
 
-- Drop table
 
-- DROP TABLE public.drivers_db;
 
CREATE TABLE public.drivers_db (
	driverid serial4 NOT NULL,
	driverref text NULL,
	"number" int8 NULL,
	code text NULL,
	"name" text NULL,
	nationality text NULL,
	url text NULL,
	date_of_birth date NULL,
	constructorid int8 NULL,
	CONSTRAINT drivers_db_constructorid_fkey FOREIGN KEY (constructorid) REFERENCES public.constructor_db(constructorid)
);
CREATE UNIQUE INDEX idx_17133_sqlite_autoindex_drivers_db_1 ON public.drivers_db USING btree (driverid);
CREATE INDEX index_drivers_name ON public.drivers_db USING btree (name);
CREATE INDEX index_drivers_nationality ON public.drivers_db USING btree (nationality);
 
 
-- public.races_db definição
 
-- Drop table
 
-- DROP TABLE public.races_db;
 
CREATE TABLE public.races_db (
	raceid serial4 NOT NULL,
	seasonid int8 NULL,
	round int8 NULL,
	circuitid int8 NULL,
	"name" text NULL,
	"date" date NULL,
	"time" interval NULL,
	url text NULL,
	CONSTRAINT races_db_circuitid_fkey FOREIGN KEY (circuitid) REFERENCES public.circuits_db(circuitid),
	CONSTRAINT races_db_seasonid_fkey FOREIGN KEY (seasonid) REFERENCES public.seasons_db(seasonid)
);
CREATE UNIQUE INDEX idx_17140_sqlite_autoindex_races_db_1 ON public.races_db USING btree (raceid);
 
 
-- public.results_db definição
 
-- Drop table
 
-- DROP TABLE public.results_db;
 
CREATE TABLE public.results_db (
	resultid serial4 NOT NULL,
	raceid int8 NULL,
	driverid int8 NULL,
	"number" int8 NULL,
	grid int8 NULL,
	"position" int8 NULL,
	points float8 NULL,
	laps int8 NULL,
	"time" text NULL,
	milliseconds interval NULL,
	fastestlap interval NULL,
	"rank" int8 NULL,
	fastestlaptime interval NULL,
	fastestlapspeed interval NULL,
	statusid int8 NULL,
	CONSTRAINT results_db_driverid_fkey FOREIGN KEY (driverid) REFERENCES public.drivers_db(driverid),
	CONSTRAINT results_db_raceid_fkey FOREIGN KEY (raceid) REFERENCES public.races_db(raceid),
	CONSTRAINT results_db_statusid_fkey FOREIGN KEY (statusid) REFERENCES public.status_db(statusid)
);
CREATE UNIQUE INDEX idx_17147_sqlite_autoindex_results_db_1 ON public.results_db USING btree (resultid);
 
 
-- public.laptimes_db definição
 
-- Drop table
 
-- DROP TABLE public.laptimes_db;
 
CREATE TABLE public.laptimes_db (
	raceid int8 NOT NULL,
	driverid int8 NOT NULL,
	lap int8 NOT NULL,
	"position" int8 NULL,
	"time" interval NULL,
	milliseconds interval NULL,
	CONSTRAINT idx_17166_laptimes_db_pkey PRIMARY KEY (raceid, driverid, lap),
	CONSTRAINT laptimes_db_driverid_fkey FOREIGN KEY (driverid) REFERENCES public.drivers_db(driverid),
	CONSTRAINT laptimes_db_raceid_fkey FOREIGN KEY (raceid) REFERENCES public.races_db(raceid)
);
CREATE UNIQUE INDEX idx_17166_sqlite_autoindex_laptimes_db_1 ON public.laptimes_db USING btree (raceid, driverid, lap);
 
 
-- public.pitstops_db definição
 
-- Drop table
 
-- DROP TABLE public.pitstops_db;
 
CREATE TABLE public.pitstops_db (
	raceid int8 NOT NULL,
	driverid int8 NOT NULL,
	stop int8 NOT NULL,
	lap int8 NULL,
	"time" interval NULL,
	milliseconds interval NULL,
	duration interval NULL,
	CONSTRAINT idx_17163_pitstops_db_pkey PRIMARY KEY (raceid, driverid, stop),
	CONSTRAINT pitstops_db_driverid_fkey FOREIGN KEY (driverid) REFERENCES public.drivers_db(driverid),
	CONSTRAINT pitstops_db_raceid_fkey FOREIGN KEY (raceid) REFERENCES public.races_db(raceid)
);
CREATE UNIQUE INDEX idx_17163_sqlite_autoindex_pitstops_db_1 ON public.pitstops_db USING btree (raceid, driverid, stop);
 
 
-- public.qualifying_db definição
 
-- Drop table
 
-- DROP TABLE public.qualifying_db;
 
CREATE TABLE public.qualifying_db (
	qualifyid serial4 NOT NULL,
	raceid int8 NULL,
	driverid int8 NULL,
	"number" int8 NULL,
	"position" int8 NULL,
	CONSTRAINT qualifying_db_driverid_fkey FOREIGN KEY (driverid) REFERENCES public.drivers_db(driverid),
	CONSTRAINT qualifying_db_raceid_fkey FOREIGN KEY (raceid) REFERENCES public.races_db(raceid)
);
CREATE UNIQUE INDEX idx_17154_sqlite_autoindex_qualifying_db_1 ON public.qualifying_db USING btree (qualifyid);
 
 
-- public.qualifying_qs_db definição
 
-- Drop table
 
-- DROP TABLE public.qualifying_qs_db;
 
CREATE TABLE public.qualifying_qs_db (
	qualifyid int8 NOT NULL,
	q int8 NOT NULL,
	time_q text NULL,
	CONSTRAINT idx_17158_qualifying_qs_db_pkey PRIMARY KEY (qualifyid, q),
	CONSTRAINT qualifying_qs_db_qualifyid_fkey FOREIGN KEY (qualifyid) REFERENCES public.qualifying_db(qualifyid)
);
CREATE UNIQUE INDEX idx_17158_sqlite_autoindex_qualifying_qs_db_1 ON public.qualifying_qs_db USING btree (qualifyid, q);