##################
### Question 3 ###
##################
cut -d ',' -f 10 output_2.csv | grep "Fox News" -c

##################
### Question 4 ###
##################

cut -d ',' -f 10 output_2.csv | grep "SurveyUSA\|Rasmussen" -c

##################
### Question 5 ###
##################

cut -d ',' -f 10 output_2.csv | grep -vc "Fox News"

##################
### Question 6 ###
##################

# the following regex uses groups in order to delimit the csv input and to compare
# the two date fields.
# The unescaped version looks like this:
# ^([^,]*[,]){7}([A-Z]{1}[a-z]{2} [0-9]{2}),\2
#
# select first 7 fields stored in group 1
#  ^([^,]*[,]){7}
# select a date field as 'Mmm dd' stored in group 2
# ([A-Z]{1}[a-z]{2} [0-9]{2})
# match presence of group 2 in adjacent field
# ,\2

grep "^\([^,]*[,]\)\{7\}\([A-Z]\{1\}[a-z]\{2\} [0-9]\{2\}\),\\2" output_2.csv

##################
### Question 7 ###
##################

# unescaped regex
# ^([^,]*[,]){4}([5-9]{1}[0-9]{1})

grep "^\([^,]*[,]\)\{4\}\([5-9]\{1\}[0-9]\{1\}\)" output_2.csv | cut -d ',' -f 4 | sort | uniq

##################
### Question 8 ###
##################

# unescaped regex
# ^([^,]*[,]){4}([6-9]{1}[0-9]{1}|[5]{1}[1-9]{1})

grep "^\([^,]*[,]\)\{4\}\([6-9]\{1\}[0-9]\{1\}\|[5]\{1\}[1-9]\{1\}\)"  output_2.csv | cut -d ',' -f 2 | sort | uniq
