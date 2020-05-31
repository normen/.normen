#!/bin/bash
set -e
TEMP_FILE=$(mktemp)
cat>$TEMP_FILE
pdftotext -layout $TEMP_FILE -
rm $TEMP_FILE
