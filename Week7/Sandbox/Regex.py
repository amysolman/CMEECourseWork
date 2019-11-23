import re 
import csv

my_string = "a given string"

match = re.search(r'\s', my_string) #are there whitespaces?
print(match)

match.group()

match = re.search(r'\d', my_string) #are there numbers?
print(match)

MyStr = 'an example'

match = re.search(r'\w*\s', MyStr) #match a single character (zero or more times) with a whitespace 
if match:
    print('found a match:', match.group())
else:
    print('did not find a match')

match = re.search(r'2' , "it takes 2 to tango") #search for the number 2!
match.group()

match = re.search(r'\d' , "it takes 2 to tango") #find a numeric character
match.group()

match = re.search(r'\d.*' , "it takes 2 to tango") #find a numeric and everything after up until new line
match.group()

match = re.search(r'\s\w{1,3}\s', 'once upon a time') #find a space followed by a single character (matches 1-3 times) and then another space
match.group()
#basically, find a space, followed by 1 to 3 letters and then another space

match = re.search(r'\s\w*$', 'once upon a time')
match.group()
#predicted output = ' time' CORRECT

#LEt's switch to a more compact syntax by directly returning the matched group
#(by directly appening .group() to the result)

re.search(r'\w*\s\d.*\d', 'take 2 grams of H2O').group()
#predicted output = 'take 2 grams of H2' CORRECT!

re.search(r'^\w*.*\s', 'once upon a time').group()
#predicted output = 'once ' WRONG! 'once upon a '
#find the start of the string a character (0+) match any character except linebreak (0+) with whitespace
#from the beginning of the string match any word with proceeding linebreak

# *, + and {} repeat previous regex token as many times as possible
#They may match more text than you want. To terminate at the first found
#instance of a pattern use ?

re.search(r'^\w*.*?\s', 'once upon a time').group()
#predicted output = from the beginning of the string match the FIRST word with proceeding whitespace
# = 'once '

#Let's try matching a HTML tag

re.search(r'<.+>', 'This is a <EM>first</EM> test').group()
#predicted output = '<EM>' WRONG
# = '<EM>first</EM>

#Because + is greedy - instead, we can make + 'lazy'
re.search(r'<.+?>', 'This is a <EM>first</EM> test').group()

re.search(r'\d*\.?\d*', '1432.75+60.22i').group()
#predicted output = '1432.75' CORRECT!

re.search(r'[AGTC]+', 'the sequence ATTCGT').group()
#Search for these characters 

re.search(r'\s+[A-Z]\w+\s*\w+', "The bird-shit frog's name is Theloderma asper.").group()
#Search for a space one or more times followed by capital characters A-Z then all characters then a space then all characters

#How about looking for email addresses in a string? For example, let's try matching
#a string consisting of an academic's name, email address and research area
#or interest

MyStr = 'Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory'
match = re.search(r"[\w\s]+,\s[\w\.@]+,\s[\w\s]+", MyStr)
match.group()
#Search for any word then space multiple times comma space then characters dot @ multiple times
#comma space characters space multiple times
#[] ensures any combination of characters and spaces is found

MyStr = 'Samraat Pawar, s-pawar@imperial.ac.uk, Systems biology and ecological theory'
match = re.search(r"[\w\s]+,\s[\w\.@]+,\s[\w\s&]+", MyStr)
match.group()
#Error here because we don't have a '.' in the email address
#Let's make the email address part of the regex more robust

match = re.search(r"[\w\s]+,\s[\w.-]+@[\w\.-]+,\s[\w\s&]+", MyStr)
match.group()
#Includes any combination of characters '.' and '-'

#Practicals: Some RegExercises

#The following exercises are not fro submission as part of your coursework, 
#but we will discuss them in class on a subsequent day

#1. Try the regex we used above for finding names for cases where the person's name has 
#something unexpected like a ? or a +. Does it work? How can you make it more robust?

name = 'Andy? Pu++er'
match = re.search(r"[\w\s\?\+]+", name)
match.group()

#2. Translate the following regular expressions into regular English

#r'^abc[ab]+\s\t\d' Search at the start of the string for abc exactly 
# then any combination of ab repeatedly, then a space, then a tab, then a number

#r'^\d{1,2}\/\d{1,2}\/\d{4}$' Search at the start of the string for 1 to 2 numbers,
#then a /, then 1 to 2 numbers, then a /, then 4 numbers at the end of the string - A DATE!

#r'\s*[a-zA-z,\s]+\s*' #Search for a space zero or more times, followed by lowercase/
#uppercase letters, commas and spaces in any order, multiple times, followed by a space zero or more times

#3. Write a regex to match dates in format YYYYMMDD, making sure that:
#Only seemingly valid dates match (i.e. year greater than 1900)
#First digit in month is either 0 or 1
#First digit in dat <= 3

right_date = '19901112'
wrong_date = '39901172'
otherdate = '294746583930300'
match = re.search(r'^[1|2][0-9][0-9][0-9][0-1][0-9][0-3][0-9]$', right_date)
if match:
    print('Correct format date:', match.group())
#elif: 
#    print("fail")


#Grouping regex patterns

#You can group regex patterns into meaningful blocks using parentheses.
#Let's look again at the example of finding email addresses.

MyStr = 'Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory'
match = re.search(r"[\w\s]+,\s[\w\.-]+@[\w\.-]+,\s[\w\s&]+",MyStr)
match.group()
match.group(0)

#Now create groups using ( ):
match = re.search(r"([\w\s]+),\s([\w\.-]+@[\w\.-]+),\s([\w\s&]+)", MyStr)
if match:
    print(match.group(0)) #print the whole thing
    print(match.group(1)) #print first group
    print(match.group(2)) #print second group
    print(match.group(3)) #print third group

#Finding all matches

#Above we used re.search() to find the first match for a pattern. In many scenarios,
#you will need to find all the matches of a pattern.
#The function re.findall() does precisely this and returns all matches as a list
#of strings, with each string representing one match.

#Let's try this on an extension of the email example above for some data with multiple addresses:

MyStr = MyStr = "Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory; Another academic, a-academic@imperial.ac.uk, Some other stuff thats equally boring; Yet another academic, y.a_academic@imperial.ac.uk, Some other stuff thats even more boring"

#Now re.findall() returns a list of all emails found:

emails = re.findall(r'[\w\.-]+@[\w\.-]+', MyStr)
for email in emails:
    print(email)

#Finding in files

#You will generslly be wanted to apply regex searches to while files.
#You might be tempted to write a loop to iterate over the lines of the file, calling
#re.findall() on each line. However, re.findall() can return a lst of
#all the matches in a single step.

#Let's try finding all species names that correspong to Oaks in a datafile.
f = open('../Data/TestOaksData.csv')
found_oaks = re.findall(r"Q[\w\s].*\s", f.read())

found_oaks #This words because recall that f.read() returns the whole text of a file
#in a single string. Also, the file is closed after reading.

#GROUPS WITH MULTIPLE MATCHES

#Grouping pattern matches using ( ) as you learned above, can be combined with re.findall()
#IF the pattern includes TWO OR MORE groups, then instead of returning a list of strings,
#re.findall() returns a a list of tuples.
#Each tuplerepresents one match of the pattern, and inside the tuple is group(1), group(2) etc.
#Let's try it:

MyStr = "Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory; Another academic, a-academic@imperial.ac.uk, Some other stuff thats equally boring; Yet another academic, y.a_academic@imperial.ac.uk, Some other stuff thats even more boring"

found_matches = re.findall(r"([\w\s]+),\s([\w\.-]+@[\w\.-]+)", MyStr)
found_matches

for item in found_matches:
    print(item)

#EXTRACTING TEXT FROM WEBPAGES

#Ok, let's step up the ante here. How about extracting text from a web page to create your own data?
#You will need a new package urllib3. Install it and import it.

import urllib3

conn = urllib3.PoolManager() #open a connection
r = conn.request('GET', 'http://www.imperial.ac.uk/silwood-park/academic-staff/')
webpage_html = r.data #read in the webpage's contents
#Wouldn't work at first, changed https to http

#This is returned as bytes (not strings)
type(webpage_html)

#So decode it (remember, the default decoding that this method applies is utf-8):
My_Data = webpage_html.decode()
#print(My_Data)

#That's a lot of potentially useful information! Let's extract all the names of academics:
pattern = r"Dr\s+\w+\s+\w+"
regex = re.compile(pattern) #example use of re.compile(); you can also ignore case with re.IGNORECASE
for match in regex.finditer(My_Data): #example of use of re-finditer()
    print(match.group())

#Again, nice! However, it's not perfect. You can improve this by:
#Extracting Prof names as well
#Eliminating the repeated matches

pattern2= r"(Prof\s+\w+\s+\w+|Dr\s+\w+\s+\w+)(?!.*\1)"
regex2 = re.compile(pattern2)
for match in regex2.finditer(My_Data):
    print(match.group())

####ASK ABOUT THIS IN THE MORNING
#Grouping to seperate title from first and second names
#Extracting names that have unexpected characters (e.g. "O'Gorman", which are currently not being matched properly)
pattern3= r"(Prof\s+[\w+'*\s+\w+\-]|Dr\s+[\w+'*\s+\w+\-])(?!.*\1)"
regex3 = re.compile(pattern2)
for match in regex3.finditer(My_Data):
    print(match.group())

#REPLACING TEXT
#Using the same web page data, let's try using the re-sub command on the same web page data (My_Data)
#to replace text

New_Data = re.sub(r'\t'," ", My_Data) #replace all tabs with a space
    