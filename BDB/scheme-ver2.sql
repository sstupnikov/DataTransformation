--
-- PostgreSQL database dump
--

-- Dumped from database version 13.9 (Debian 13.9-0+deb11u1)
-- Dumped by pg_dump version 13.9 (Debian 13.9-0+deb11u1)

SET client_encoding = 'UTF8';


--
-- Name: bdb3_models_bdbcomp; Type: TABLE; Schema: public; Owner: bdb3dev
--

CREATE TABLE public.bdb3_models_bdbcomp (
    catline_id integer NOT NULL,
    mag double precision,
    band character varying(40),
    "spType" character varying(40),
    "K" double precision,
    "V0" double precision,
    plx double precision,
    "pmRA" double precision,
    "pmDE" double precision,
    "crdRA" double precision,
    "crdDE" double precision,
    sys_catline_id integer,
    "FWHM" double precision,
    "FEW" double precision,
    "Mass" double precision,
    "L" double precision,
    "Teff" double precision,
    g double precision,
    "Radius" double precision,
    "M" double precision
);

ALTER TABLE ONLY public.bdb3_models_bdbcomp
    ADD CONSTRAINT bdb3_models_bdbcomp_pkey PRIMARY KEY (catline_id);

ALTER TABLE ONLY public.bdb3_models_bdbcomp
    ADD CONSTRAINT bdb3_models_bdbcomp_catline_id_fkey FOREIGN KEY (catline_id) REFERENCES public.bdb3_models_catline(id) ON DELETE CASCADE;
	
ALTER TABLE ONLY public.bdb3_models_bdbcomp
    ADD CONSTRAINT bdb3_models_bdbcomp_sys_catline_id_fk FOREIGN KEY (sys_catline_id) REFERENCES public.bdb3_models_bdbsystem(catline_id) ON DELETE CASCADE DEFERRABLE;

	
	
--
-- Name: bdb3_models_bdbpair; Type: TABLE; Schema: public; Owner: bdb3dev
--

CREATE TABLE public.bdb3_models_bdbpair (
    catline_id integer NOT NULL,
    "Epoch" integer,
    "Theta" double precision,
    "Rho" double precision,
    "P" double precision,
    a double precision,
    i double precision,
    e double precision,
    "V0" double precision,
    plx double precision,
    "pmRA" double precision,
    "pmDE" double precision,
    "crdRA" double precision,
    "crdDE" double precision,
    mmax double precision,
    mmin double precision,
    band character varying(40),
    "OType" character varying(40),
    "EType" character varying(40),
    sys_catline_id integer,
    "compA_catline_id" integer,
    "compB_catline_id" integer,
    jmag double precision,
    mdif double precision,
    q double precision,
    "Mf" double precision,
    "sumM" double precision,
    "jL" double precision,
    "jTeff" double precision
);

ALTER TABLE ONLY public.bdb3_models_bdbpair
    ADD CONSTRAINT bdb3_models_bdbpair_pkey PRIMARY KEY (catline_id);

ALTER TABLE ONLY public.bdb3_models_bdbpair
    ADD CONSTRAINT bdb3_models_bdbpair_catline_id_fkey FOREIGN KEY (catline_id) REFERENCES public.bdb3_models_catline(id) ON DELETE CASCADE;

ALTER TABLE ONLY public.bdb3_models_bdbpair
    ADD CONSTRAINT "bdb3_models_bdbpair_compA_catline_id_fk" FOREIGN KEY ("compA_catline_id") REFERENCES public.bdb3_models_bdbcomp(catline_id) ON DELETE CASCADE DEFERRABLE;

ALTER TABLE ONLY public.bdb3_models_bdbpair
    ADD CONSTRAINT "bdb3_models_bdbpair_compB_catline_id_fk" FOREIGN KEY ("compB_catline_id") REFERENCES public.bdb3_models_bdbcomp(catline_id) ON DELETE CASCADE DEFERRABLE;

ALTER TABLE ONLY public.bdb3_models_bdbpair
    ADD CONSTRAINT bdb3_models_bdbpair_sys_catline_id_fk FOREIGN KEY (sys_catline_id) REFERENCES public.bdb3_models_bdbsystem(catline_id) ON DELETE CASCADE DEFERRABLE;

	
--
-- Name: bdb3_models_bdbsystem; Type: TABLE; Schema: public; Owner: bdb3dev
--

CREATE TABLE public.bdb3_models_bdbsystem (
    catline_id integer NOT NULL
);

ALTER TABLE ONLY public.bdb3_models_bdbsystem
    ADD CONSTRAINT bdb3_models_bdbsystem_pkey PRIMARY KEY (catline_id);

ALTER TABLE ONLY public.bdb3_models_bdbsystem
    ADD CONSTRAINT bdb3_models_bdbsystem_catline_id_fkey FOREIGN KEY (catline_id) REFERENCES public.bdb3_models_catline(id) ON DELETE CASCADE;

	
--
-- Name: bdb3_models_catline; Type: TABLE; Schema: public; Owner: bdb3dev
--

CREATE TABLE public.bdb3_models_catline (
    id integer NOT NULL,
    lin character varying(10240),
    valid boolean,
    num integer,
    obj_id character varying(40),
    err character varying(10240),
    refs bytea,
    row_type character varying(40)
);

ALTER TABLE ONLY public.bdb3_models_catline
    ADD CONSTRAINT bdb3_models_catline_pkey PRIMARY KEY (id);