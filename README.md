A collection of instructions and relevant files for editing/creating the MinnPost base map.

This repository is basically a TileMill project, so you should put this project in your
TileMill projects directory, usually ~/Documents/MapBox/project/

## Development and Setup

### Install PostGIS

TODO.

These instructions assume you are using a locally install PostGIS database with an unsecured postgres user.

Create new PostGIS DB called 'minnpost_base_map':

```createdb -U postgres -h localhost -T template_postgis minnpost_base_map```

### OpenStreetMap data

Download the [OSM file from Cloudmade](http://downloads.cloudmade.com/americas/northern_america/united_states/minnesota/minnesota.osm.bz2) to your Downloads folder.

### Import OSM data into Postgres (osm2pgsql

Use [osm2pgsql](https://wiki.openstreetmap.org/wiki/Osm2pgsql#Mac_OS_X) to import the data.  Install first:

```
brew install automake
brew install libtool
brew install geos
brew install proj
brew install gdal
brew install --HEAD osm2pgsql
```

To import, run the following (this will take a while):

```osm2pgsql -K -c -G -U postgres -H localhost -d minnpost_base_map ~/Downloads/minnesota.osm.bz2```

### Open in TileMill

You should be able to open this project in TileMill now.  Do note that it will take a fair amount of time
to download the external shapefiles, and then render them.  So, maybe work on something else for a bit.

## Data Used

 - OpenStreetMap
 - Census (http://www.census.gov/geo/www/cob/st2000.html)