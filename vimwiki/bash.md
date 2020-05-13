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
