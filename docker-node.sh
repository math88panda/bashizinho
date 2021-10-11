#!/usr/bin/bash

## author: Mephius 
## date: 2021/09/27
## description:  setup dockerfile for nodejs

# 1 - pull image locally or remotelly
# 2 - change dir inside container
# 3 - copy package.json to container dir so as to not rebuild unecessarilly
# 4 - run npm install inside container dir 
# 5 - copy local files to container dir 
# 6 - expose port (formal documentation)
# 7 - run node server when container is created

NC='\033[0m'
GREEN='\033[0;32m'
commandIndex=9

function goodbye() { printf "\nBye bye master!.\n"; exit 1; }

trap goodbye SIGINT

clear

#timeout --foreground 5s cmatrix
#timeout --foreground 5s asciiquarium

printf "\n"

read -p "(defaults to FROM node:[version|latest]): Enter version -> " version
read -p "(defaults to COPY [.|localDir] [/app|containerDir].): Enter localDir and containerDir -> " localDir containerDir

[[ "${containerDir:=/app}" =~ ^[/][[:alnum:]]+$ ]] || {
	printf "Invalid container directory to copy your files!.\n" >&2
	exit 1
}


cat <<- _EOF_ > Dockerfile
  FROM ${image:="node"}:${version:="latest"}
  
  WORKDIR ${containerDir}
  
  COPY package.json ${containerDir} 
  
  RUN npm install
  
  COPY ${localDir:="."} ${containerDir}
  
  EXPOSE 5000
  
  CMD ["node","server.js"]	
_EOF_

printf "${GREEN}Dockerfile created successfully!${NC}\n" && cat < Dockerfile

exit 0
