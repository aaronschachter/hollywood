
#!/bin/bash

# ==============================================================================
# GLOBALS
# ==============================================================================

# The base project directory
BASE_PATH=`pwd -P`

# The webroot directory name for the dev environment
WEB_DIR='html'

# Full webroot path
WEB_PATH=$BASE_PATH/$WEB_DIR

# The lib directory name
LIB_DIR='lib'

# Full lib path
LIB_PATH=$BASE_PATH/$LIB_DIR

# The config directory name
CONFIG_DIR='config'

# Full config path
CONFIG_PATH=$BASE_PATH/$CONFIG_DIR

# Project build make file
BUILD_MAKEFILE=$BASE_PATH/hollywood.make

# Dist directory name to write releases to
DIST_DIR='dist'

# Full dist path
DIST_PATH=$BASE_PATH/$DIST_DIR


#=== FUNCTION ==================================================================
# NAME: build
# DESCRIPTION: Builds project from make files.
#===============================================================================
function build {
  # Display sweet ASCII art.
  art

  set -e
  cd $BASE_PATH

  if [ $WEB_PATH ]; then
    echo 'Wiping html directory...'
    rm -rf "$WEB_PATH"
  fi

  # Do the build
  echo 'Running drush make...'
  drush make --prepare-install --no-gitinfofile --no-cache "$BUILD_MAKEFILE" "$WEB_DIR"
  set +e

  echo 'Replacing settings.php file...'
  sudo rm -f $WEB_PATH/sites/default/settings.php && chmod u+w $WEB_PATH/sites/default
  ln -s $CONFIG_PATH/settings.php $WEB_PATH/sites/default/settings.php

  # Create symlinks
  echo 'Linking theme...'
  rm -rf "$WEB_PATH/sites/all/themes/hollywood/bootstrap_hollywood"
  ln -s "$LIB_PATH/themes/hollywood/bootstrap_hollywood" "$WEB_PATH/sites/all/themes/hollywood/bootstrap_hollywood"

  # Run any updates
  cd $WEB_PATH
  echo 'Running updates...'
  drush -y updb
  echo 'Clearing all cache...'
  drush cc all
  echo 'Build complete.'
}

#=== FUNCTION ==================================================================
# NAME: art
# DESCRIPTION: Displays sweet ascii art.
#===============================================================================
function art {

cat <<"EOT"
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::-'    `-::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::-'          `::::::::::::::::
:::::::::::::::::::::::::::::::::::::::-  '   /(_M_)\  `:::::::::::::::
:::::::::::::::::::::::::::::::::::-'        |       |  :::::::::::::::
::::::::::::::::::::::::::::::::-         .   \/~V~\/  ,:::::::::::::::
::::::::::::::::::::::::::::-'             .          ,::::::::::::::::
:::::::::::::::::::::::::-'                 `-.    .-::::::::::::::::::
:::::::::::::::::::::-'                  _,,-::::::::::::::::::::::::::
::::::::::::::::::-'                _,--:::::::::::::::::::::::::::::::
::::::::::::::-'               _.--::::::::::::::::::::::#####:::::::::
:::::::::::-'             _.--:::::::::::::::::::::::::::#####:::::####
::::::::'    ##     ###.-::::::###:::::::::::::::::::::::#####:::::####
::::-'       ###_.::######:::::###::::::::::::::#####:##########:::####
:'         .:###::########:::::###::::::::::::::#####:##########:::####
     ...--:::###::########:::::###:::::######:::#####:##########:::####
 _.--:::##:::###:#########:::::###:::::######:::#####:#################
'#########:::###:#########::#########::######:::#####:#################
:#########:::#############::#########::######:::#######################
##########:::########################::################################
##########:::##########################################################
##########:::##########################################################
#######################################################################
#######################################################################
#######################################################################
EOT
}

#=== FUNCTION ==================================================================
# NAME: release
# DESCRIPTION: Creates a new tag release and pushes compliled site to dist repo.
#===============================================================================
function release {
  if [ -z "$1" ]
    then
      echo "No release tag supplied."
      exit
    else
      echo "Building release $1..."
  fi
  # Build the HTML directory.
  build
  # If distro directory exists:
  if [[ -d $DIST_PATH ]]
  then
    cd $DIST_PATH
    # Pull down the latest
    echo 'Updating dist repo...'
    git pull
  else
    # Else clone the dist repo to dist dir
    cd $BASE_PATH
    echo 'Cloning dist repo...'
    git clone https://github.com/aaronschachter/hollywood-dist.git $DIST_DIR
  fi
  cd $BASE_PATH
  echo "Creating tag $1..."
  git tag $1
  git tag
  git push origin $1
  # Copy web dir contents which have changed into to dist
  echo 'Copying over changed files into local dist...'
  rsync -r $WEB_PATH/* $DIST_PATH
  # Remove symlink copied from web_path
  rm -rf $DIST_PATH/sites/all/themes/hollywood/bootstrap_hollywood
  # Copy theme (since its symlinked in the $WEB_PATH)
  cp -r $LIB_PATH/themes/hollywood/bootstrap_hollywood $DIST_PATH/sites/all/themes/hollywood/bootstrap_hollywood
  cd $DIST_PATH
  echo 'Pushing to dist repo...';
  git add .
  git commit -m "Release $1"
  git push origin master
  echo 'Creating release tag...';
  git tag $1
  git tag
  git push origin $1
}

# ==============================================================================
# Commands
# ==============================================================================

#----------------------------------------------------------------------
# build
#----------------------------------------------------------------------
if [[ $1 == "build" ]]
then
  build
fi

#----------------------------------------------------------------------
# art
#----------------------------------------------------------------------
if [[ $1 == "art" ]]
then
  art
fi

# Release
if [[ $1 == "release" ]]
then
  release $2
fi
