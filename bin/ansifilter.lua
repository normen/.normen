local stringify = (require 'pandoc.utils').stringify

local header_ansi = {
  [0] = '\x1b[1;4;33m',
  [1] = '\x1b[1;33m',
  [2] = '\x1b[1;4;32m',
  [3] = '\x1b[1;32m',
  [4] = '\x1b[3;34m',
  [5] = '\x1b[2;3;34m',
}

function Code (elem)
  elem.text = '\x1b[34m' .. elem.text .. '\x1b[0m' 
  return elem
end

function Link (elem)
  local cont = stringify(elem.content)
  if cont == "edit" then
    elem.content=""
  else
    elem.content="\x1b[36m" .. cont .. "\x1b[0m"
  end
  return elem
end

function Header (elem)
  if header_ansi[elem.level] then
    local cont = stringify(elem.content):gsub("[[]]","")
    elem.content = header_ansi[elem.level] .. cont .. "\x1b[0m"
  end
  return elem
end

function BlockQuote (m)
  local cont = stringify(elem.content)
  elem.content="\x1b[3m" .. cont .. "\x1b[0m"
  return elem
end
