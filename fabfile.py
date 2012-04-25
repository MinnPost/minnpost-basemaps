#!/usr/bin/env python
"""
Fab file to help with managing project.  For docs on Fab file, please see: http://docs.fabfile.org/
"""
import sys
import os
import warnings
import json
import re
from fabric.api import *

"""
Base configuration
"""
env.project_name = 'minnpost-basemaps'
env.pg_host = 'localhost'
env.pg_dbname = 'minnpost_fec'
env.pg_user = 'postgres'
env.pg_pass = ''

# Tilemill paths.  For Ubuntu
if os.path.exists('/usr/share/tilemill'):
  env.tilemill_path = '/usr/share/tilemill'
  env.tilemill_projects = '/usr/share/mapbox/project'
  env.node_path = '/usr/bin/node'
# OSX
else:
  env.tilemill_path = '/Applications/TileMill.app/Contents/Resources'
  env.tilemill_projects = '~/Documents/MapBox/project'
  env.node_path = '%(tilemill_path)s/node' % env
  
"""
Environments
"""
def production():
  """
  Work on production environment
  """
  env.settings = 'production'
  env.s3_buckets = ['a.tiles.minnpost', 'b.tiles.minnpost', 'c.tiles.minnpost', 'd.tiles.minnpost']
  env.acl = 'acl-public'


def staging():
  """
  Work on staging environment
  """
  env.settings = 'staging'
  env.s3_buckets = ['testing.tiles.minnpost']
  env.acl = 'acl-public'
  

def map(name):
  """
  Select map to work on.
  """
  env.map = name
  

def _deploy_to_s3(concurrency):
  """
  Deploy tiles to S3.
  """
  env.concurrency = concurrency

  # Deploy to many buckets (multi-dns-head mode)
  for bucket in env.s3_buckets:
    env.s3_bucket = bucket    
    local('ivs3 %(map)s/tiles %(s3_bucket)s/%(project_name)s/%(map)s --%(acl)s -c %(concurrency)s' % env)


def deploy(concurrency=32, minzoom=None, maxzoom=None):
  """
  Deploy a map. Optionally takes a concurrency parameter indicating how many files to upload simultaneously.
  """
  require('settings', provided_by=[production, staging])
  require('map', provided_by=[map])
  
  cleanup_exports()
  no_labels()
  generate_mbtile(minzoom, maxzoom)
  reset_labels()
  
  #_deploy_to_s3(concurrency)
  

def link_caches():
  """
  Link local map cache to Mapbox cache to speed up mapnik conversion.
  """
  require('map', provided_by=[map])
  
  env.base_path = os.getcwd()
  exists = os.path.exists('%(base_path)s/%(map)s/cache' % env)
  if exists:
    print "There already a linked cache directory."
  else:
    env.tilemill_cache = os.path.expanduser('%(tilemill_projects)s/../cache/' % env)
    local(('ln -s %(tilemill_cache)s %(base_path)s/%(map)s/cache') % env)
  

def carto_to_mapnik():
  """
  Convert carto styles to mapnik configuration.
  """
  require('map', provided_by=[map])
  link_caches()
  local('%(tilemill_path)s/node_modules/carto/bin/carto %(map)s/project.mml > %(map)s/%(map)s.xml' % env)
  

def generate_mbtile(minzoom=None, maxzoom=None):
  """
  Generate MBtile.
  """
  require('map', provided_by=[map])
  
  # Read data from project mml
  with open('%(map)s/project.mml' % env, 'r') as f:
    config = json.load(f)
  
    # Define config values
    env.minzoom = config['minzoom'] if minzoom == None else minzoom
    env.maxzoom = config['maxzoom'] if maxzoom == None else maxzoom
    env.bbox = '%f,%f,%f,%f' % (config['bounds'][0], config['bounds'][1], config['bounds'][2], config['bounds'][3])
    
    # Export
    local('%(tilemill_path)s/node %(tilemill_path)s/index.js export --format=mbtiles --minzoom=%(minzoom)s --maxzoom=%(maxzoom)s --bbox=%(bbox)s %(map)s %(map)s/exports/%(map)s.mbtiles' % env)


def generate_tiles_from_mbtile():
  """
  Generate MBtile.
  """
  require('map', provided_by=[map])
    
  exists = os.path.exists('%(map)s/exports/%(map)s.mbtiles' % env)
  if exists:
    with settings(warn_only=True):
      local('rm -rf %(map)s/tiles-tmp' % env)
      local('mb-util --scheme=osm %(map)s/exports/%(map)s.mbtiles %(map)s/tiles-tmp' % env)
      local('mv %(map)s/tiles-tmp/0.0.1 %(map)s/tiles' % env)
      local('mv %(map)s/tiles-tmp/metadata.json %(map)s/tiles/metadata.json' % env)
      local('rm -rf %(map)s/tiles-tmp' % env)
  else:
    print 'No MBTile file found in exports.'


def render_tiles_mapnik(process_count, minzoom=None, maxzoom=None):
  """
  Render tile from mapnik configuration
  """
  env.process_count = process_count

  # Read data from project mml
  with open('%(map)s/project.mml' % env, 'r') as f:
    config = json.load(f)
  
    # Define config values
    env.minzoom = config['minzoom'] if minzoom == None else minzoom
    env.maxzoom = config['maxzoom'] if maxzoom == None else maxzoom
    env.minlon = config['bounds'][0]
    env.minlat = config['bounds'][1]
    env.maxlon = config['bounds'][2]
    env.maxlat = config['bounds'][3]

    # Cleanup tiles
    local('rm -rf %(map)s/tiles/*' % env)
    
    # Render tiles
    command = 'ivtile %(map)s/%(map)s.xml %(map)s/tiles %(maxlat)s %(minlon)s %(minlat)s %(maxlon)s %(minzoom)s %(maxzoom)s -p %(process_count)s'
    if 'buffer' in env:
      command += ' -b %(buffer)s'
    local(command % env)
  

def no_labels():
  """
  Updates tilemill project to no use labels
  """
  require('map', provided_by=[map])
  
  # Create a backup
  exists = os.path.exists('%(map)s/project.mml.orig' % env)
  if exists != True:
    local('cp %(map)s/project.mml %(map)s/project.mml.orig' % env);
  
  # From the original, load the json, find any label style
  # and remove.
  overwrite = open('%(map)s/project.mml' % env, 'w')
  with open('%(map)s/project.mml.orig' % env, 'r') as f:
    mml = json.load(f)
    
    # Process styles
    styles = []
    for index, item in enumerate(mml['Stylesheet']):
      if item != 'labels.mss':
        styles.append(item)
    mml['Stylesheet'] = styles
    
    overwrite.write(json.dumps(mml, sort_keys = True, indent = 2))
    overwrite.close()
  

def only_labels():
  """
  Updates tilemill project to use only labels
  """
  require('map', provided_by=[map])
  
  # Create a backup
  exists = os.path.exists('%(map)s/project.mml.orig' % env)
  if exists != True:
    local('cp %(map)s/project.mml %(map)s/project.mml.orig' % env);
  
  # From the original, load the json, keep palette and labels
  overwrite = open('%(map)s/project.mml' % env, 'w')
  with open('%(map)s/project.mml.orig' % env, 'r') as f:
    mml = json.load(f)
    
    # Process styles
    styles = []
    for index, item in enumerate(mml['Stylesheet']):
      if item == 'labels.mss' or item == 'palette.mss':
        styles.append(item)
    mml['Stylesheet'] = styles
    
    overwrite.write(json.dumps(mml, sort_keys = True, indent = 2))
    overwrite.close()
  

def reset_labels():
  """
  Resets any label changes process
  """
  require('map', provided_by=[map])
  
  # Create a backup
  
  exists = os.path.exists('%(map)s/project.mml.orig' % env)
  if exists:
    local('rm -f %(map)s/project.mml' % env);
    local('mv %(map)s/project.mml.orig %(map)s/project.mml' % env);
  else:
    print 'No label processing to reset.'
  

def create_exports():
  """
  Create export directories
  """
  require('map', provided_by=[map])
  local('mkdir -p %(map)s/tiles' % env)
  local('mkdir -p %(map)s/exports' % env)
  

def cleanup_exports():
  """
  Cleanup export directories
  """
  require('map', provided_by=[map])
  local('rm -rf %(map)s/tiles/*' % env)
  local('rm -rf %(map)s/exports/*' % env)


def link():
  """
  Link a map into the MapBox directory
  """
  require('map', provided_by=[map])
  
  exists = os.path.exists(os.path.expanduser('%(tilemill_projects)s/%(map)s' % env))
  if exists:
    print "A directory with that name already exists in your MapBox projects."
  else:
    env.base_path = os.getcwd()
    local(('ln -s %(base_path)s/%(map)s/ %(tilemill_projects)s/%(map)s') % env)


def unlink():
  """
  unLink a map into the MapBox directory
  """
  require('map', provided_by=[map])
  
  exists = os.path.exists(os.path.expanduser('%(tilemill_projects)s/%(map)s' % env))
  if exists:
    local(('unlink %(tilemill_projects)s/%(map)s') % env)
  else:
    print "There is no directpry with that name in your MapBox projects."
  

def clone(name):
  """
  Clone a map to work on.
  """
  env.clone = name
  
  exists = os.path.exists('%(clone)s' % env)
  if exists:
    print "A directory with that name already exists in this project."
  else:
    local('cp -r %(map)s %(clone)s' % env)
    
    # Now link it
    env.map = env.clone
    link()