#!/bin/bash

BIN_NAME="gogetprivate"
SOURCE_CODE_URL="https://raw.githubusercontent.com/sitnikovik/gogetprivate/master/gogetprivate.sh"

sudo wget -qO /usr/local/bin/${BIN_NAME} ${SOURCE_CODE_URL} && sudo chmod 755 /usr/local/bin/${BIN_NAME}
