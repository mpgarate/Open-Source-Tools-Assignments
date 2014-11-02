# remove all lines before the table
1,/<table/d

# remove all lines after the table
/<\/table>/,$d

# remove lines with <tr>, </tr> or "small-state-header"
/<tr>\|<\/tr>\|small-state-header/d

# remove blank lines
/^$/d

# replace &nbsp; with a spaces
s/&nbsp;/ /g

# remove all html tags
s/<[^>]*>//g

# remove whitespace at beginning and end of lines
s/^[ \t]*//g
s/[ \t]*$//g

# remove % from lines containing only a number followed by %
s/^\([0-9]*\)%/\1/g

# remove the * from lines that end with a *
s/\*$//g