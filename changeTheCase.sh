#!/bin/bash

Path="${2}"

# Function initialization.
function U {		
# Renames the specified file/file list/folder/folder list in uppercase.
	CurrentPath="${1}"
    if [ -d "${CurrentPath}" ]; then						# If the file path (Example path: "~/task/bsuir/testfolder").
    	NameDir="$(dirname "${CurrentPath}")"					# Stored value without folder name(Example: "~/task/bsuir").
    	NamePath="$(basename "${CurrentPath}")" 				# Stored folder name (Example: "testfolder").
		NewNamePath=$(echo "${NamePath}" | awk '{print toupper($0)}')	# Сonvert the folder name in upper case.
    	mv "${CurrentPath}" "${NameDir}/${NewNamePath}"				# Replacing the old path with the new path.
	elif [ -f "${CurrentPath}" ]; then					# If the directory path (Example path: "~/task/bsuir/testfolder/index.html").
		NameDir="$(dirname "${CurrentPath}")"				# Stored value without folder name(Example: "~/task/bsuir/testfolder").
		NamePath="$(basename "${CurrentPath}")"				# Stored folder name (Example: "index.html").
		Extension="${NamePath##*.}"					# Stored file extension (Example: "html").
		FileName="${NamePath%.*}"					# Stored file name without extension (Example: "index").
		NewNameFile=$(echo "${FileName}" | awk '{print toupper($0)}')	# Сonvert the file name in upper case.
		mv "${CurrentPath}" "${NameDir}/${NewNameFile}.${Extension}" 2>/dev/null	# Replacing the old path with the new path.
	else
		echo -e "\e[91mIt's test failed"
	fi
}

function L {		
#renames the specified file/file list/folder/folder list in lowercase
	CurrentPath="${1}"
    if [ -d "${CurrentPath}" ]; then
    	NameDir="$(dirname "${CurrentPath}")"
    	NamePath=$(basename "${CurrentPath}")
		NewNamePath=$(echo "${NamePath}" | awk '{print tolower($0)}')
    	mv "${CurrentPath}" "${NameDir}/${NewNamePath}"
	elif [ -f "${CurrentPath}" ]; then	
		NamePath=$(basename "${CurrentPath}")
		NameDir="$(dirname "${CurrentPath}")"
		Extension="${NamePath##*.}"
		FileName="${NamePath%.*}"
		NewNameFile=$(echo "${FileName}" | awk '{print tolower($0)}')
		mv "${CurrentPath}" "${NameDir}/${NewNameFile}.${Extension}" 2>/dev/null
	fi
}

function M {		
#renames the first letter of the specified name file/file list/folder/folder list in uppercase.
	CurrentPath="${1}"
	if [ -d "${CurrentPath}" ]; then
		NamePath=$(basename "${CurrentPath}")
		NameDir="$(dirname "${CurrentPath}")"
		NewNamePath=$(echo "${NamePath}" | awk '{print tolower($0)}' | sed "s/\(.\)/\u\1/")
    	mv "${CurrentPath}" "${NameDir}/${NewNamePath}"
	elif [ -f "${CurrentPath}" ]; then
	  	NamePath=$(basename "${CurrentPath}")
	  	NameDir="$(dirname "${CurrentPath}")"
		Extension="${NamePath##*.}"
		FileName="${NamePath%.*}"
		NewNameFile=$(echo "${FileName}" | awk '{print tolower($0)}' | sed "s/\(.\)/\u\1/")
		mv "${CurrentPath}" "${NameDir}/${NewNameFile}.${Extension}" 2>/dev/null
	fi
}

function R {		# Recursive call of u | L | M functions
	Path="${1}"
	FileList=$(find  "${Path}" -type f -printf "%d %p\n"| sort -n | perl -pe 's/^\d+\s//;')		# Searches all files and generates a list.
	DirList=$(find "${Path}" -type d -printf "%d %p\n"| sort -nr | perl -pe 's/^\d+\s//;')		# Searches all folders and generates a list (from a deeper).
	echo "${FileList}" | while read CurrentPath		# Gets a list of all files
	do
		"${2}" "${CurrentPath}"				# Passes every line to the desired function.
	done
	echo "${DirList}" | while read CurrentPath		#Gets a list of all folders.
	do
		"${2}" "${CurrentPath}"						
	done
}

case "$1" in 							# Parses the input of the first argument when the script is run
	-R) R "${Path}" ;;	
	-U) U "${Path}" ;;
	-UV|-VU) echo "Use function UV" ;;
	-UR|-RU) R "${Path}" "U" ;;
	-URV|-UVR|-RUV|-RVU|-VUR|-VRU) echo "Use function URV" ;;
	-L) L "$Path" ;;
	-LV|-VL) echo "Use function LV" ;;
	-LR|-RL) R "${Path}" "L" ;;
	-LRV|-LVR|-RLV|-RVL|-VLR|-VRL) echo "Use function LRV" ;;
	-M) M "${Path}" ;;
	-MV|-VM) echo "Use function MV" ;;
	-MR|-RM) R "${Path}" "M" ;;
	-MRV|-MVR|-RMV|-RVM|-VMR|-VRM) echo "Use function MRV" ;;
	*) echo -e "\e[91mInvalid parameter or combination." ;;
esac
