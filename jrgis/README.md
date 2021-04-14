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
