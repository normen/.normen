## bash
```bash
# numbers
NUMBER="12"
OTHER=$(($NUMBER+4))
if [[ $(($NUMBER)) -gt 15 ]]; then
  echo "Number above 15"
elif [[ $(($NUMBER)) -lt 5 ]]; then
  echo "Number above below 5"
fi

# error handling
set -e
trap 'err=$?; echo >&2 "Exiting on error $err"; exit $err' ERR

# regex matching
pattern='^hello([0-9]*)$'
if [[ "$x" =~ $pattern ]]; then
  echo "${BATCH_REMATCH[1]}"
  echo "Match found"
fi

# one-key input
read -rsn 1 k
echo "pressed $k"
# zsh
read -rsk 1 k

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

# check if string contains char
if [[ $IP =~ [:] ]];then
  echo "IP contains :"
fi

# get multiline variable
read -d '' CONTENT <<CONTENT
your
content
CONTENT
echo $CONTENT

# loop through list
for i in \
    string1 \
    string2 \
    stringN
do
   printf '%s\n' "$i"
done

# read file line by line
while IFS= read -r line; do
  printf '%s\n' "$line"
done < input_file

# quit when return != 0
set -e
# let != 0 pass:
failing_process || true

# file lock
(
  # Wait for lock on /var/lock/.myscript.exclusivelock (fd 200) for 10 seconds
  flock -x -w 10 200 || exit 1
  # Do stuff
) 200>/var/lock/.myscript.exclusivelock
```
