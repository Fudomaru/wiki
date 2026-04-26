# YSAP Bash course

## Introduction

1. Bash is a REPL (Read Evaluate Print Loop)
2. The bash process exists at a folder/directory level (pwd)
3. to list what is in the directory you are you use "ls"

### Basic file manipulations

1. touch - creates a new file
2. mv - moves files, used to rename files !! can override files no questions asked. 
3. rm - !! delets no questions ask. 
3. * - is called a glob, or wildcard. more on that later
4. rm -i - this makes it interactive, making it ask and show you what you are about to do. 
5. alias rm=rm -i - this makes a alias to always ask about it. 
6. ctrl + l - clears the terminal in most terminals
7. history - shows you the history of the machine
8. tab can be used to autocomplete. 

### Hidden files

1. Files starting with a "." will be Hidden.
2. ls -a - This will show hidden files. 
3. the ./ and ../ files are in every directory.
   ./ is the current directory
   ../ is the directory above. 
4. cd - - this will go to the last directory you have been. 

### Searching in Files

1. cat - prints the contents of the files. 
2. grep searchterm /file/path - searches for lines in the file with the searchterm. 
3. grep 'searchterm' /file/path - match the start of the line 
4. grep 'searchterm$' /file/path - match the end of the line
5. echo test > file.txt - will override the file.txt with test.
6. echo test >> file.txt - will append test to the file.txt to a new line.
7. grep -A1 searchterm file.txt - prints line with searchterm plus one line after. 
8. grep -B1 searchterm file.txt - prints line with searchterm plus one line before. 
9. grep -A1 searchterm file.txt - prints line with searchterm plus one line before and after. 
10. grep -i searchterm file.txt - searches case insesitive. 
11. grep -o '^d.' file.txt - seaches lines that start with a d, doesnt matter what is behind, and only print that character plus the character where the . is. 
12. Pipelineing works via | . whatever is on the right is the input for the one on the left.

### Paging files 

1. less file.txt - this lets you page though the output. Via down or up arrow, via page up/down. Exit via q, and there is no input in your file. 
2. more file.txt - alsmost the same then less. 

## Man pages 

man command - This will give you the the manual pages of the command. This will use less as a pager. 
There are section numbers. man 2 man will give you the second section. 

For bash builtin commands you need to use help. 
which - will give you the place where your programm list. 
type - will give you the type of a command or anything else. 
type -a - will give you all the commands in order. 

compgen -b - will list all builtin
builtins can also be internal commands, so i you have to be careful. 

### Programs and commands

file - this will do its best to tell you what a file is. 
file file.txt - ASCII text 
file /bin/rm - Mach-0 universial binary. 
With the variable $PATH are all the paths it checks when you run a command. 
echo "$PATH" | tr : '\n' - will translate every ":" to "\n" (which means new line). 
tr a b - This switches a for an b for your output. 

### Basic Variables

pwd - prints your direktory
$PWD - is a enviable variable that does the same. 
There are also the following:
whoami - $WHOAMI 
user - $USER 
$SHELL - give you the path of your shell.
$HOSTNAME - give you the hostname. 
$MACHTYPE - giye you the machinetype. 
name=marcel creates a new variable named "$macel"
foo='hello       world' makes the foo variable, but if you echo $foo you get "hello world" and the spaces disappear. That is why you should use echo "$foo" which keeps the spaces. 
foo= - this just creates a empty viariable. 
unset foo - gets rid of that variable. 
uname -a - gives you way more then just uname. 

Important! = i am using backticks to make it a command. Normally today you use $(). that way you can do something like this:
thing=$(uname -a) 

### VIM Crash Course 

I will keep this a bit shorter since I am using neoVim since almost a year now. 

There are different modes. 
"Esc" gets you into normal mode. Here you can move via hjkl. 
Hitting "i" in nomral mode brings you into "input" mode to type. 
In normal mode you can type ":" to do a command. 
:w is to save. 
:q is to exit the file. 
:qw saves and quits. 
:q! quits with no saveing. 

### File Permissions

Running "ls -l" give you the listing of fils with its permissions. 
chmod +x file.sh - This will make your script executable. 

It should also be noted that you should always but a shebang at the beginning of your bash script, to make sure it is run the right way. This would normally be "#! /bin/bash". 
But it can also be "#! /usr/bin/env bash". Just in generall it is the better way. 
This is also you dont need a .sh extention. So i will now call our tests only script. 

## Finally Scripting

This are the first Scripts we do in this course, and they are still pretty self explainatory i think:

´´´ bash
#! /usr/bin/env bash

echo "Hello world"
´´´

This will just show Hello World. 

´´´ bash
#! /usr/bin/env bash


for thing in foo bar baz bat; do
  echo "thing is $thing"
done
´´´

This will loop though the list of things and echo whatever the thing is at the moment, making it list everything on the list. 

bash -n - This is a syntex checker. It will only check if the if there is a syntex error, it will not run the script. 
Whit "$?" you can check the error code of the last command. Everything exept a 0 is an error. 

### User Input

read : this will take user Input. Using -p 'prompt here' will use the prompt before asking for the name. After you give it the name of the variable to save it to. 

If you now pip something into the script it will use that as the answer to the read command, without even showing the prompt. 

excurse: This is why the 'yes' command exists, that only gives out 'y' over and over to help with this in certain situations. 

'$1' will give you the first argument someone puts behind the script when executing. 

if ...; then ... else : This is how a if syntex looks like in bash. 

if [[ -n $1 ]] will check if the there is a first argument give. 

Remember that you can use "help "["" for example to get information about almost all the things used in a bash script. 

Instead of using $1, $2, etc. you can use $@ and it will expand into an array with all the arguments that have been give, even if there is non, then it will be an empty array. 

### Funktions

´´´bash
for name in "$@"; do
  ./hello "$name"
done
´´´

With this we take all the arguments and do a for loop for each one running the script hello that lives in the same directory. 

funktion() {} This is what a funktion looks like in bash. You should think about them like there own scripts you can call inside the script you are working on. Make sure to rememeber to use the "local" prefix for variables, since they are global even in funktions for bash. 


### Conditionals










