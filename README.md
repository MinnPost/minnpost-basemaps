A collection of instructions and relevant files for
creating the MinnPost base map.

## Development

### Install PostGIS

These instructions assume you are using a locally install PostGIS database with an unsecured postgres user.

### OSM data from Cloudmade

http://downloads.cloudmade.com/americas/northern_america/united_states/minnesota#downloads_breadcrumbs
http://downloads.cloudmade.com/americas/northern_america/united_states/minnesota/minnesota.osm.bz2

### osm2pgsql

Use osm2pgsql to import
https://wiki.openstreetmap.org/wiki/Osm2pgsql#Mac_OS_X

```
brew install automake
brew install libtool
brew install geos
brew install proj
brew install gdal
brew install --HEAD osm2pgsql
```

