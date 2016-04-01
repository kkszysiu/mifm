#!/bin/bash

getLocalString() {
    echo $1 | cut -d '_' -f 2 | cut -c1-2
}

echo "Starting build..."

original_name="mifm-1.41"

rm -rf ./dist/
mkdir -p ./dist/

mkdir -p ./$original_name/

echo "./apps/apktool d ./original_apk/$original_name.apk --output ./$original_name/ -f"
./apps/apktool d ./original_apk/$original_name.apk --output ./$original_name/ -f


LOCALISATIONS=`ls -l ./translation/ | awk '{print $9}'`
for LOCALISATION in $LOCALISATIONS
do
echo  ${LOCALISATION}
logString=$(getLocalString ${LOCALISATION})

ls -lath
ls -lath ./$original_name/

cp ./translation/${LOCALISATION} ./$original_name/res/values/strings.xml

echo "./apps/apktool b $original_name --output ./dist/${original_name}_${logString}.apk"
./apps/apktool b $original_name --output ./dist/${original_name}_${logString}.apk

echo "java -jar ./apps/sign.jar ./dist/${original_name}_${logString}.apk --override"
java -jar ./apps/sign.jar ./dist/${original_name}_${logString}.apk --override

echo $logString

done

echo "Finishing build..."
