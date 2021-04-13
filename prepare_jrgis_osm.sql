CREATE SCHEMA IF NOT EXISTS jrgis; 
 
DROP FUNCTION IF EXISTS jrgis.droptables;
CREATE FUNCTION jrgis.droptables() RETURNS void AS $$
DECLARE 
	t timestamptz := clock_timestamp();
	t1 timestamptz ;
	
 BEGIN
	RAISE NOTICE 'pl_forest_poly';
	t1 := clock_timestamp();
	DROP TABLE IF EXISTS jrgis.pl_forest_poly CASCADE;
	RAISE NOTICE 'DROP TIME %',clock_timestamp() - t1;
	
	RAISE NOTICE 'pl_railway_poly';
	t1 := clock_timestamp();
	DROP TABLE IF EXISTS jrgis.pl_railway_poly CASCADE;
	RAISE NOTICE 'DROP TIME %',clock_timestamp() - t1;
	
	RAISE NOTICE 'pl_admin_poly';
	t1 := clock_timestamp();
	DROP TABLE IF EXISTS jrgis.pl_admin_poly CASCADE;
	RAISE NOTICE 'DROP TIME %',clock_timestamp() - t1;
	
	RAISE NOTICE 'pl_railway';
	t1 := clock_timestamp();
	DROP TABLE IF EXISTS jrgis.pl_railway CASCADE;
	RAISE NOTICE 'DROP TIME %',clock_timestamp() - t1;
	
	RAISE NOTICE 'pl_highways';
	t1 := clock_timestamp();
	DROP TABLE IF EXISTS jrgis.pl_highways CASCADE;
	RAISE NOTICE 'DROP TIME %',clock_timestamp() - t1;
	
	RAISE NOTICE 'pl_water_poly';
	t1 := clock_timestamp();
	DROP TABLE IF EXISTS jrgis.pl_water_poly CASCADE;
	RAISE NOTICE 'DROP TIME %',clock_timestamp() - t1;
	
	RAISE NOTICE 'drop table finishes (%)',clock_timestamp() - t;
	RAISE NOTICE 'jrgis.createtables(); - use for tables creation';

END;	
$$ LANGUAGE plpgsql;


 -- select jrgis.createtables() 
DROP FUNCTION IF EXISTS jrgis.createtables;
CREATE FUNCTION jrgis.createtables() RETURNS void AS $$
DECLARE 
	t timestamptz := clock_timestamp();
	t1 timestamptz ;
	
 BEGIN
	RAISE NOTICE 'jrgis.createtables() START';
	RAISE NOTICE 'pl_forest_poly';
	t1 := clock_timestamp();
create table jrgis.pl_forest_poly as 
	select osm_id,name,leisure,ref,way_area,tags,way from planet_osm_polygon where
	(landuse='forest' or "natural"='wood');
create index pl_forest_poly_pl_idx on jrgis.pl_forest_poly(osm_id);
create index pl_forest_poly_pl_gdx on jrgis.pl_forest_poly USING gist (way);
	RAISE NOTICE 'DROP TIME %',clock_timestamp() - t1;
	
	RAISE NOTICE 'pl_railway_poly';
	t1 := clock_timestamp();
create table jrgis.pl_railway_poly as 
	select osm_id,name,railway,access,ref,way_area,tags,way from planet_osm_polygon where railway is not null;
create index pl_railway_poly_idx on jrgis.pl_railway_poly(osm_id);	
RAISE NOTICE 'TIME %',clock_timestamp() - t1;
	
	RAISE NOTICE 'pl_admin_poly';
	t1 := clock_timestamp();
create table jrgis.pl_admin_poly as 
	select osm_id,admin_level,name,ref,way_area,tags,way from planet_osm_polygon where
	boundary='administrative' ;
create index pl_admin_poly_idx on jrgis.pl_admin_poly(osm_id);
create index pl_admin_poly_gdx on jrgis.pl_admin_poly USING gist (way);
create index pl_admin_poly_ldx on jrgis.pl_admin_poly(osm_id,admin_level);
RAISE NOTICE 'TIME %',clock_timestamp() - t1;
	
	RAISE NOTICE 'pl_railway';
	t1 := clock_timestamp();
	create table jrgis.pl_railway as
	select osm_id,ref,railway,bridge,layer,name,service,tunnel,tracktype,tags,way from planet_osm_line where railway is not null;
create index pl_railway_idx on jrgis.pl_railway(osm_id);
create index pl_railway_gdx on jrgis.pl_railway USING gist (way);
create index pl_railway_adx on jrgis.pl_railway(osm_id,railway);
create index pl_railway_rdx on jrgis.pl_railway(osm_id,ref);
RAISE NOTICE 'TIME %',clock_timestamp() - t1;
	
	RAISE NOTICE 'pl_highways';
	t1 := clock_timestamp();
create table jrgis.pl_highways as
	select 1::smallint as level,osm_id,ref,name,bridge,oneway,tunnel,surface,layer,tags,way from planet_osm_line where highway='motorway' or highway='motorway_link'
	union
	select 2,osm_id,ref,name,bridge,oneway,tunnel,surface,layer,tags,way from planet_osm_line where highway='trunk' or highway='trunk_link'
	union
	select 3,osm_id,ref,name,bridge,oneway,tunnel,surface,layer,tags,way from planet_osm_line where highway='primary' or highway='primary_link'
	union
	select 4,osm_id,ref,name,bridge,oneway,tunnel,surface,layer,tags,way from planet_osm_line where highway='secondary' or highway='secondary_link'
	union
	select 5,osm_id,ref,name,bridge,oneway,tunnel,surface,layer,tags,way from planet_osm_line where highway='tertiary' or highway='tertiary_link'
	union
	select 6,osm_id,ref,name,bridge,oneway,tunnel,surface,layer,tags,way from planet_osm_line where highway='unclassified' or highway='residential' or highway='tracks';

create index pl_highways_idx on jrgis.pl_highways(osm_id);
create index pl_highways_gdx on jrgis.pl_highways USING gist (way);
create index pl_highways_ldx on jrgis.pl_highways(osm_id,level);
create index pl_highways_rdx on jrgis.pl_highways(osm_id,ref);
RAISE NOTICE 'TIME %',clock_timestamp() - t1;
	
	RAISE NOTICE 'pl_water_poly';
	t1 := clock_timestamp();
create table jrgis.pl_water_poly as 
select osm_id,water,waterway,name,ref,way_area,tags,way from planet_osm_polygon where
"natural"='water' ;
create index pl_water_poly_idx on jrgis.pl_water_poly(osm_id);
create index pl_water_poly_gdx on jrgis.pl_water_poly USING gist (way);
create index pl_water_poly_wdx on jrgis.pl_water_poly(osm_id,water);	
RAISE NOTICE 'TIME %',clock_timestamp() - t1;
	
	RAISE NOTICE 'create table finishes (%)',clock_timestamp() - t;
	RAISE NOTICE 'jrgis.createtables() END';

END;	
$$ LANGUAGE plpgsql;


select jrgis.droptables();
select jrgis.createtables();
