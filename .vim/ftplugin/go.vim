"fix for go run not highlighting error lines
if stridx(&errorformat, ",%f:%l\ %m") == -1
  let &errorformat.=",%f:%l\ %m"
endif

