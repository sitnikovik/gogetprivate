#!/bin/bash

###> Colors ###
RED_COLOR='\033[0;31m'
GREEN_COLOR='\033[0;32m'
YELLOW_COLOR='\033[0;33m'
CYAN_COLOR='\033[0;36m'
COLOR_OFF='\033[0m'
YELLOW_COLOR_BG='\033[43m'

ITALIC_TEXT='\033[3m'
BOLD_TEXT='\033[1m'
DIM_TEXT='\033[2m'
###< Colors ###

CMD_NAME="gogetprivate"
PACKAGE=""
VERSION=""
ACCESS_TOKEN=""
GIT_VENDOR=""

###> Help ###
case "$1" in
-h | --help | help)
  echo -e "${CYAN_COLOR}${BOLD_TEXT}${ITALIC_TEXT}${CMD_NAME}${COLOR_OFF} is a simple tool to get golang packages stored in git private repositories.\r\n\r\n${BOLD_TEXT}Options${COLOR_OFF}\r\n \t-t | --token ${DIM_TEXT}your git access token${COLOR_OFF}\r\n"
  exit 0
  ;;
  esac
###< Help ###

###> Parsing git vendor ###
IFS='/'  # space is set as delimiter
read -ra GIT_VENDOR <<< "$1"   # str is read into an array as tokens separated by IFS
if [ $GIT_VENDOR != "github.com" ]; then
  echo -e "${RED_COLOR}ERROR${COLOR_OFF}: Only ${CYAN_COLOR}${BOLD_TEXT}github.com${COLOR_OFF} is supported now"
  exit 1;
fi
##< Parsing git vendor ###

###> Parsing package and version ###
IFS='@'
read -ra PACKAGE_SOURCE <<< "$1"
INDEX=0
for i in "${PACKAGE_SOURCE[@]}"; do
  if [ $INDEX == 0 ]; then
    PACKAGE="$i"
  fi
  if [ $INDEX == 1 ]; then
    VERSION="$i"
  fi
  (( INDEX++ ))
done
###< Parsing package and version ###

###> Parsing options ###
while [ -n "$1" ]
do

  case "$1" in
  -t | --token)
    if [ ! "$2" ]; then
      echo -e "${RED_COLOR}ERROR${COLOR_OFF}: specify access token"
      exit 128
    fi
    ACCESS_TOKEN=$2
    ;;
    esac

shift
done
###< Parsing options ###

###> Parsing access token ###
if [ -z $ACCESS_TOKEN ]; then
  # Read git access token on empty
  read -p "Type git access token: " ACCESS_TOKEN
fi
###< Parsing access token ###

###> Run go get command ###
# Setting up environment
export GOPRIVATE=$PACKAGE
export GONOPROXY=localhost
git config --local url."https://$ACCESS_TOKEN:x-oauth-basic@$GIT_VENDOR/".insteadOf "https://$GIT_VENDOR/"

# Getting the package
go get $PACKAGE@$VERSION
###< Run go get command ###