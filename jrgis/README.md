#  osm preparation for PLK GSM-R map

### Missing plpythonu in Postgres 12

```sql
UPDATE pg_catalog.pg_pltemplate
	SET tmplvalidator='plpython3_validator',tmpllibrary='$libdir/plpython3',tmplhandler='plpython3_call_handler',tmplinline='plpython3_inline_handler'
	WHERE tmplname='plpythonu';
```

Other commands
'''
SELECT name, default_version, installed_version FROM pg_available_extensions WHERE name LIKE('py*')

select * from pg_language;
CREATE EXTENSION plpythonu;

CREATE LANG plpythonu;

select * from pg_pltemplate;

'''
