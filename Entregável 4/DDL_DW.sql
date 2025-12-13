-- public.dim_circuits definição
 
-- Drop table
 
-- DROP TABLE public.dim_circuits;
 
CREATE TABLE public.dim_circuits (
	id_circuit serial4 NOT NULL,
	circuit_etl int4 NOT NULL,
	name_circuit varchar(100) NOT NULL,
	CONSTRAINT dim_circuits_pkey PRIMARY KEY (id_circuit)
);
 
 
-- public.dim_constructor definição
 
-- Drop table
 
-- DROP TABLE public.dim_constructor;
 
CREATE TABLE public.dim_constructor (
	id_constructor serial4 NOT NULL,
	constructor_etl int4 NOT NULL,
	name_constructor varchar(100) NOT NULL,
	CONSTRAINT dim_constructor_pkey PRIMARY KEY (id_constructor)
);
 
 
-- public.dim_drivers definição
 
-- Drop table
 
-- DROP TABLE public.dim_drivers;
 
CREATE TABLE public.dim_drivers (
	id_driver serial4 NOT NULL,
	drivers_etl int4 NOT NULL,
	name_driver varchar(100) NOT NULL,
	CONSTRAINT dim_drivers_pkey PRIMARY KEY (id_driver)
);
 
 
-- public.dim_season definição
 
-- Drop table
 
-- DROP TABLE public.dim_season;
 
CREATE TABLE public.dim_season (
	id_season serial4 NOT NULL,
	season_etl int4 NOT NULL,
	year_season int4 NOT NULL,
	CONSTRAINT dim_season_pkey PRIMARY KEY (id_season)
);
 
 
-- public.dim_status definição
 
-- Drop table
 
-- DROP TABLE public.dim_status;
 
CREATE TABLE public.dim_status (
	id_status serial4 NOT NULL,
	status_etl int4 NOT NULL,
	tipo_status varchar(100) NOT NULL,
	CONSTRAINT dim_status_pkey PRIMARY KEY (id_status)
);
 
 
-- public.fato_result definição
 
-- Drop table
 
-- DROP TABLE public.fato_result;
 
CREATE TABLE public.fato_result (
	id_circuit int4 NOT NULL,
	id_status int4 NOT NULL,
	id_constructor int4 NOT NULL,
	id_driver int4 NOT NULL,
	id_season int4 NOT NULL,
	qtd_points float8 NOT NULL,
	fastestlap_result interval NULL,
	position_grid int4 NULL,
	CONSTRAINT fato_result_pkey PRIMARY KEY (id_circuit, id_status, id_constructor, id_driver, id_season),
	CONSTRAINT fato_result_id_circuit_fkey FOREIGN KEY (id_circuit) REFERENCES public.dim_circuits(id_circuit),
	CONSTRAINT fato_result_id_constructor_fkey FOREIGN KEY (id_constructor) REFERENCES public.dim_constructor(id_constructor),
	CONSTRAINT fato_result_id_driver_fkey FOREIGN KEY (id_driver) REFERENCES public.dim_drivers(id_driver),
	CONSTRAINT fato_result_id_season_fkey FOREIGN KEY (id_season) REFERENCES public.dim_season(id_season),
	CONSTRAINT fato_result_id_status_fkey FOREIGN KEY (id_status) REFERENCES public.dim_status(id_status)
);