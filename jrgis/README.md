#  osm preparation for PLK GSM-R map

##
use scripts shp_prepare.sh to prepare shp file You may use for offline tiles creation in tilemill

### Missing plpythonu in Postgres 12

```sql
UPDATE pg_catalog.pg_pltemplate
	SET tmplvalidator='plpython3_validator',tmpllibrary='$libdir/plpython3',tmplhandler='plpython3_call_handler',tmplinline='plpython3_inline_handler'
	WHERE tmplname='plpythonu';
```

Other commands
```
SELECT name, default_version, installed_version FROM pg_available_extensions WHERE name LIKE('py*')

select * from pg_language;
CREATE EXTENSION plpythonu;

CREATE LANG plpythonu;

select * from pg_pltemplate;
```

# osm to poly

https://gis.stackexchange.com/questions/348580/making-lines-from-nodes-using-openstreetmap-and-postgis-tilemill
```sql
SELECT way_id, st_makeline(coord) AS way 
    INTO __test
    FROM (SELECT b.id AS way_id, ST_SetSRID(st_makepoint(lon, lat), 3857) AS coord
        FROM (SELECT id, unnest(nodes) AS node_id FROM planet_osm_ways WHERE 'cobblestone'=any(tags)) a 
        INNER JOIN planet_osm_nodes b 
            ON a.node_id=b.id
        ORDER BY way_id
    ) c
    GROUP BY way_id
```
# st_buffer in meters
https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a

```sql
st_transform(
    st_buffer(
      st_transform(st_geomFromText('POINT(145.228914 -37.92674)', 4326), 900913),
      50 --radius in meters
    ),
    4326
  )
  
create table ipm.ise_geom as
 select ise,st_union(st_transform(
    st_buffer(
      st_transform(geom, 900913),
      220 --radius in meters
      ,'endcap=flat join=round quad_segs=4'
    ),
    4326
  )
) from ipm.ise i group by ise;  
```
## osm (3857) to wgs (4326)

```sql
SELECT UpdateGeometrySRID('silk','ise_adresy','geom',4326);
UPDATE silk.ise_adresy set geom=ST_Transform(ST_GeomFromText('POLYGON ((2080651.9081237381 6563518.367034862, 2080664.4093025539 6563508.073926179, 2080675.274084855 6563520.43971018, 2080662.5057392614 6563531.347611747, 2080651.9081237381 6563518.367034862))',3857),4326) where osm_id=254516262;
```

## nice buffer
```sql
select ise,st_union(st_buffer(ST_SetSRID(geom,4326),0.01,'endcap=flat join=round quad_segs=4')) from ipm.ise i group by ise
```


## just circle/round without inside    SIMPLE postgis circle without interior
```
select  ST_ExteriorRing(st_buffer(st_astext('SRID=4326; POINT (19.680567919951486 51.38468811400849)') ::geography,3000)::geometry)
```

## find point on line in radius from point 51.3846 19.69418 radius 3000 meters from line
```
with a as (
select  (st_intersection(GeomFromEWKT('SRID=4326;LINESTRING(19.694182652765836 51.42789888344511, 19.666035624597775 51.28897648156998)'), 
ST_ExteriorRing(st_buffer(st_astext('SRID=4326; POINT (19.680567919951486 51.38468811400849)') ::geography,3000)::geometry))) as g
) select (st_dump(a.g)).geom from a;
```


```
with a as (
with l as (select * from silk.linie l where l.d29 =1)
select  (st_intersection(l.geom, ST_ExteriorRing(
st_buffer(st_astext('SRID=4326; POINT (19.680567919951486 51.38468811400849)') ::geography,3000)::geometry))) as g from l
) select (st_dump(a.g)).geom from a;
```



## shp2pgsql shp to postgres
https://www.bostongis.com/pgsql2shp_shp2pgsql_quickguide.bqg

```
shp2pgsql -s2180:4326 "C3_Best server at each pixel_cała sieć.shp" jr.best105s >best105_4326.sql
```

## pgsql connect db as schema in other db

https://stackoverflow.com/questions/3195125/copy-a-table-from-one-database-to-another-in-postgres
'''
pg_dump -t table_to_copy source_db | psql target_db    
'''

https://www.postgresql.org/docs/13/postgres-fdw.html
https://www.postgresql.org/docs/13/sql-importforeignschema.html
'''
CREATE SERVER bestserver FOREIGN DATA WRAPPER postgres_fdw OPTIONS (
    dbname 'bestserver',
    host '127.0.0.1',
    port '5432'
);

CREATE USER MAPPING FOR postgres SERVER bestserver OPTIONS (
    password 'pass',
    "user" 'user'
);

IMPORT FOREIGN SCHEMA jr
    FROM SERVER bestserver INTO bestserver;
'''

