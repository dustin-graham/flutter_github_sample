mkdir snapshots
FILE_PATH=$1
FILENAME=$(basename $FILE_PATH)
SNAPSHOT_DIRECTORY=$(basename $FILE_PATH .dart)
mkdir -p snapshots/$SNAPSHOT_DIRECTORY
commits=($(git log --oneline $FILE_PATH | cut -f 1 -d " "))
LENGTH=${#commits[@]}
TOP_COMMIT=${commits[0]}
for ((i=0; i<${#commits[@]}; i++)); do 
  
  INDEX=`expr $LENGTH - $i`
  echo $INDEX
  COMMIT=${commits[$i]}
  git checkout $COMMIT $FILE_PATH 
  cp $FILE_PATH snapshots/$SNAPSHOT_DIRECTORY/$INDEX-$FILENAME;
done
git checkout $TOP_COMMIT $FILE_PATH 