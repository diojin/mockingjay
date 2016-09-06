
filename=${1:-input}

find $filename -type f -exec sed -i -r -e 's/^(\s*log.error[^"]*")([^["]+".*)$/\1[Subscribe-Order]\2/g' {} \
										-e 's/^(\s*log.error[^"[]+)(e.getMessage\(\).*)$/\1"[Subscribe-Order] " \+ \2/g' \;
										
										
diff source $filename
cp source $filename 
