# brt - Batch Rename Tool

## Disclaimer
---
This is a project I do for fun, **SO USE IT AT YOUR OWN RISK**. There are no support, no warranty ;) and I can not be held responsible for system failure, loss of files or other system damages. 

All rights reserved to those who have created the tools my script uses. 

## What is it?
---
**brt** is a small bash script to rename multiple files in one or more folders which have sequential numbers in their names. The goal is, that the files can be sorted in the right way easily. 

You can for sure solve the same problem by using complex Linux tools like awk, but this script has two purposes:

1. To solve the problem in an easier way
2. For the author to practice Bash scripting and other skills :) 

## How it works
---
We have 4 files: 
+ file1.txt
+ file2.txt
+ file10.txt
+ file20.txt

In the perfect world (or at least in most cases) we want to sort the files like this: ...1.text, ...2.txt, ...10.txt, ...20.txt 

OS'es does not sort it this way. It sorts like this: ...1.txt, ...10.txt, ...2.txt, ...20.txt

**brt** fix this by prepend zeros to the numbers in the filename, so there are total of 3 digits (default):
+ file001.txt
+ file002.txt
+ file010.txt
+ file020.txt 


## Usage
---
For use the script you have to download the bash file (.sh file) and run it - you can not install it with your package manager. 

To run it, you must give it executable rights. Type `chmod +x brt.sh` in the terminal, when you are in the same directory as the script.
Now you can run it by typing `./brt.sh`

The script takes 1 mandatory argument, which is the path for the folder in which it should rename files. It can be the full path or relative path. 
The script also take some flags:

- -r: Takes subdirectories into account
- -d [integer]: Define how many digits there should be, after renaming. Default: 3

### Examples
`./brt directory/`
Here will the files in directory be renamed so they have 3 digits per integer in the filenames (1 --> 001 and 20 --> 020)

`./brt directory/ -d 5`
Here will the files in directory be renamed so they have 5 digits per integer in the filenames (1 --> 00001 and 20 --> 00020)

`./brt directory/ -r -d 5`
Here will the files in directory AND files in all subdirectories be renamed so they have 5 digits per integer in the filenames (1 --> 00001 and 20 --> 00020)

## Man page
---
I have created a man page (the .008 file) you can use if you install it (Google for how to do this). 
After this you can use `man brt` for reading the man page

## Contact
---
You may contact me at the following adress if you have bugs report, suggestions or just a friendly greeting. I can not promise to reply, but I will try. 

brt_script[at]andersrahbek.dk