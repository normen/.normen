## bash
```bash
# selection
select yn in "No" "Yes";
do
  case $yn in
    "Yes" )
      echo "Yeah!";
      break;;
    "No" ) 
      break;;
  esac
done

# check for file (f) or directory
if [ ! -d ".normen" ]; then
  git clone https://github.com/normen/.normen
fi

# check for arguments
if [ $# -eq 0 ]; then
  echo "No arguments supplied"
fi
      
if [ ! -z $MYVAR ]; then
  echo "$MYVAR is not empty"
fi

# check for string in file
if grep -q "searchstring" "/path/to/file"; then
fi

# check for command
if ! [ -x "$(command -v git)" ]; then
  echo 'Error: git is not installed.' >&2
  exit 1
fi

# loop through list
for i in \
    string1 \
    string2 \
    stringN
do
   printf '%s\n' "$i"
done

# quit when return != 0
set -e
# let != 0 pass:
failing_process || true
```
