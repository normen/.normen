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

```
