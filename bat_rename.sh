#!/bin/bash
 OPTIND=1
 folder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"  #the folder the script are no matter when
 if [ $# -ne 0 ]; then
    #folder="${@}"
    first_arg="$1"
    if [ ${first_arg:0:1} = "-" ]; then
        echo "No folder argument specified"
        return
    else 
        folder="$1"
    fi
 else
    echo "No arguments specified"
    return
 fi
#echo "Bash version ${BASH_VERSION}..."

strindex() { 
    local index=-1
    x="${1%%$2*}"
    [[ $x = $1 ]] && index=-1 || index=${#x}
    echo "$index"
}

##Finder alle substrings i en string og returnere positionen af substringen,
#der matcher på target og hvis position er større end offset
strindex2(){ 
   string="$1"
   target="$2"
   offset="$3"
   (( $# < 3 )) && offset=0
   
   #echo "string in here = $string"
   #echo "target = $target"
   #echo "offset = $offset"
    regex='[[:digit:]]+'
    targets=($(grep -oEb "$regex" <<< "$string"))
    #echo "${#targets[@]}"
    local result=-1
    for i in "${targets[@]}"
    do
        #De næste 4 linjer er pga. arrayet er [pos:val, pos:val,...]
        #af en eller anden årsag :/ 
        col_pos=$(strindex "$i" ":")
        length="${#i}"
        pos="${i:0:col_pos}"
        val="${i:$((1+col_pos))}"
        
        if [ $val = $target ]; then
            if [ "$offset" -eq 0 ]; then
                result=$pos
                break
            else
                if [ "$offset" -lt "$pos" ]; then
                    result=$pos
                    break
                fi
            fi
        fi
    done
    echo "$result"
}

rename_files_in_folder(){
    folder2="$1"  
    number_of_digits="$2" 
    #echo "$#"
    (( $# < 2 )) && number_of_digits=3
    count=0
    regex='[[:digit:]]+'
    find "$folder" -maxdepth 1 -type f |  #for i in "${directories[@]}"
    while read fil
    do
    
    #for file in "$folder2"/*; do
        filename=${fil##*/}
        targets=($(grep -oE "$regex" <<< "$filename"))
        if [ "${#targets[@]}" -gt "0" ]; then #længden arrayet er større end 0
            #echo "--------- NEW FILE ---------"
            #echo "$filename"
            #echo "--------- NEW FILE ---------"
            newString=""
            subStrIndex=0
            strindex_index=0
            offset_number=0 #the number occurence in string for target. To avoid take the same number in string multiple times
            old_str_index=0
            old_number="-100000"
            for number in ${targets[@]}; do
                size=${#number} #antal cifre
                if [ $size -lt "$number_of_digits" ]; then #længden af tallet (antal cifre) er under 3
                    numberOfZeros=$((number_of_digits-size))
                    if [ "$number" = "$old_number" ]; then
                        offset_number=$((1+strindex_index))
                    else
                        offset_number=0
                    fi
                    strindex_index=$(strindex2 "$filename" "$number" $offset_number)
                    substring=${filename:subStrIndex:$((strindex_index-subStrIndex))} #Result skal minus med subStrIndex da vi ikke nødvendigvvis starter på position 0
                    newString=$newString$substring
                    subStrIndex=$strindex_index
                    for i in $(seq 1 $numberOfZeros); do
                        newString+="0"
                    done
                    old_number=$number
                fi
            done
            substring=${filename:subStrIndex}
            newString=$newString$substring
            if [ "$filename" != "$newString" ]; then
                mv  "$folder2/$filename" "$(echo $folder2/$newString)"
                count=$((1+count))
            fi
        fi
    done

    echo "$count"
}

rflag=0
dflag=0
dflag_value=3
OPTIND=2  #Gør at vi springer argument 1 over (som er folder). Ellers fanger den ikke flags efter det
while getopts "rd:" opt 
do
  case $opt in
    r)
      #echo "-r was triggered!" >&2
      rflag=1
      ;;
    d)
      #echo "-d was triggered!" >&2
      dflag_value="$OPTARG"
      #echo "-d value = $dflag_value"
      dflag=1
      ;;
    ?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

strindex_index=$(strindex "$folder" " -")
#if [ "$strindex_index" != -1 ]; then
#    folder=${folder:0:strindex_index}
#fi
echo "$folder"
if [ "$rflag" = 1 ]; then
    echo "folder = $folder"
    find "$folder" -type d |  #for i in "${directories[@]}"
    while read i
    do
        #echo "subfolderr = $i"
        number_renamed_files=$(rename_files_in_folder "$i" "$dflag_value")
        clean_folder_name=$(readlink -m "$i")
        #echo "clean_folder_name = $clean_folder_name"
        index=$(strindex "$clean_folder_name" "$folder")
        if [ "$index" -eq "-1" ]; then
            echo "if!"
           echo "$number_renamed_files files was renamed in folder '$folder'" 
        else
            clean_folder_name=${clean_folder_name:index}
            echo "$number_renamed_files files was renamed in folder '$clean_folder_name'"
        fi

    done
else #no flag
    number_renamed_files=$(rename_files_in_folder "$folder" "$dflag_value")
    echo "$folder"
    echo "$number_renamed_files files was renamed"
fi

OPTIND=1

