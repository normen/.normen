#!/bin/bash
set -e
TEMP_FILE=$(mktemp)
cat>$TEMP_FILE
pdftotext $TEMP_FILE -
