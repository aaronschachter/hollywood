
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
  echo 'Linking theme'
  rm -rf "$WEB_PATH/sites/all/themes/hollywood/bootstrap_hollywood"
  ln -s "$LIB_PATH/themes/hollywood/bootstrap_hollywood" "$WEB_PATH/sites/all/themes/hollywood/bootstrap_hollywood"

  # Run any updates
  cd $WEB_PATH
  drush -y updb
  drush cc all
  echo 'Build complete.'
}

#=== FUNCTION ==================================================================
# NAME: art
# DESCRIPTION: Displays sweet ascii art.
#===============================================================================
function art() {
#!/bin/bash

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
################################################################# dp ##
EOT
}

# Run this shit
build
