#!/bin/bash

# Commands around PostGIS
#
# This SHOULD be around the assumption that you are installing
# PostGIS and its dependencies from http://www.kyngchaos.com/
#
# http://www.kyngchaos.com/software/postgres

postgis_setup() {
  #POSTGIS_SQL_PATH=`pg_config --sharedir`/contrib/postgis-1.5
  POSTGIS_SQL_PATH="/usr/local/pgsql-9.1/share/contrib/postgis-1.5"
  POSTGIS_AUTH="-U postgres -h localhost"
  
  createdb $POSTGIS_AUTH -E UTF8 template_postgis
  createlang $POSTGIS_AUTH -d template_postgis plpgsql # Adding PLPGSQL language support.
  
  # Allows non-superusers the ability to create from this template
  psql $POSTGIS_AUTH -d postgres -c "UPDATE pg_database SET datistemplate='true' WHERE datname='template_postgis';"
  
  # Loading the PostGIS SQL routines
  psql $POSTGIS_AUTH -d template_postgis -f $POSTGIS_SQL_PATH/postgis.sql
  psql $POSTGIS_AUTH -d template_postgis -f $POSTGIS_SQL_PATH/spatial_ref_sys.sql
  
  # Enabling users to alter spatial tables.
  psql $POSTGIS_AUTH -d template_postgis -c "GRANT ALL ON geometry_columns TO PUBLIC;"
  psql $POSTGIS_AUTH -d template_postgis -c "GRANT ALL ON geography_columns TO PUBLIC;"
  psql $POSTGIS_AUTH -d template_postgis -c "GRANT ALL ON spatial_ref_sys TO PUBLIC;"
}

# Helpful commands
#
# Create DB from template: createdb -T template_postgis my_spatial_db
# Drop DB: dropdb my_spatial_db
#
# Import shapefile with shp2psql
# http://postgis.refractions.net/documentation/manual-1.3/ch04.html
# For example: shp2pgsql -d data/L2012-with-spvi-rounded/L2012.dbf redistriciting_map | psql -U postgres -h localhost -d minnpost
#
# PostGIS version
# SELECT PostGIS_full_version();