#!/usr/bin/env python
"""
Fab file to help with managing project.  For docs on Fab file, please see: http://docs.fabfile.org/
"""
import sys
import os
import warnings
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
  env.s3_bucket = env.project_name


def staging():
  """
  Work on staging environment
  """
  env.settings = 'staging'
  env.s3_bucket = 'staging-%(project_name)s' % env
  

def map(name):
  """
  Select map to work on.
  """
  env.map = name


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