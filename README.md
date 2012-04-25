A collection of instructions and relevant files for editing/creating the MinnPost base
maps which are designed for use in Tilemill.

## Dealing with Maps

Map names are assumed to be the name of the relevant directory.

 - Link map into MapBox projects: ```fab map:"<MAP-NAME>" link;```
 - Unlink map into MapBox projects: ```fab map:"<MAP-NAME>" unlink;```
 - Clone (and link) map: ```fab map:"<MAP-NAME>" clone:"<NEW-MAP-NAME>";```
 
## Deployment

To depoly a map, use the following.  It will export the map as an mbtiles file,
extract out tiles and json tiles, then deploy them to the various
S3 buckets.

```
fab map:"<MAP-NAME>" export_deploy:32
```

And optionally with min and max zoom levels:

```
fab map:"<MAP-NAME>" export_deploy:32,7,8
```


## Setup

The following instructions are known to work on Mac OSX Lion and Snow Leopard.

### Dependencies

Install dependencies.

```
sudo pip install -r requirements.txt;
brew install mapnik;
```

Note the path prefix suggestion at the end of the mapnik install.

### OpenStreetMap data

This will take some time, so download the [OSM file from Cloudmade](http://downloads.cloudmade.com/americas/northern_america/united_states/minnesota/minnesota.osm.bz2) to your Downloads folder.

### Install PostGIS

1.  Download and run the [Postgres](http://www.kyngchaos.com/files/software/postgresql/PostgreSQL-9.1.2-1.dmg) and [PostGIS](http://www.kyngchaos.com/files/software/postgresql/PostGIS-1.5.3-2.dmg) images from [Kyng Chaos](http://www.kyngchaos.com/software/postgres).
2.  Run the following to include the Postgres bin to your path: ```echo 'PATH="$PATH:/usr/local/pgsql/bin"' >> ~/.bash_profile; source ~/.bash_profile;```
3.  Setup a PostGIS template for making new databases.  Assuming you are in this project's folder, run the following.  ```source ./.postgis-setup.sh; postgis_setup;```
4.  Create new PostGIS DB called 'minnpost_base_map':  ```createdb -U postgres -h localhost -T template_postgis minnpost_base_map```

### Import OSM data into Postgres (osm2pgsql

Use [osm2pgsql](https://wiki.openstreetmap.org/wiki/Osm2pgsql#Mac_OS_X) to import the data.

1.  [Install homebrew](https://github.com/mxcl/homebrew/wiki/installation)
2.  Install dependencies (this will take some time, especially osm2pgsql; be patient): ```brew install automake; brew install libtool; brew install geos; brew install proj; brew install gdal;```
3.  Install osm2pgsql: ```brew install --HEAD osm2pgsql;```
4.  To import, run the following (this will take a while): ```osm2pgsql -K -c -G -U postgres -H localhost -d minnpost_base_map ~/Downloads/minnesota.osm.bz2```

### Open in TileMill

You should be able to open basemaps that use this date.  Do note that it will take a fair amount of time
to download the external shapefiles, and then render them.  So, maybe work on something else for a bit.

## Data Used

 - OpenStreetMap
 - [Census](http://www.census.gov/geo/www/cob/st2000.html) for Minnesota outline.
 
## Technologies Used

 - Initial creation of this project spawned from [OSM bright](https://github.com/mapbox/osm-bright).  For additional help, see [this tutorial](http://mapbox.com/tilemill/docs/guides/osm-bright-mac-quickstart/).
