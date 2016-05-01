#!/bin/bash

getLocalString() {
    echo $1 | cut -d '.' -f1-1 | cut -d '_' -f2-
}

echo "Starting build..."

original_name="mifm-4-22"

rm -rf ./dist/
mkdir -p ./dist/
touch ./dist/.gitkeep

mkdir -p ./$original_name/

echo "./apps/apktool d ./original_apk/$original_name.apk --output ./$original_name/ -f"
./apps/apktool d ./original_apk/$original_name.apk --output ./$original_name/ -f

LOCALISATIONS=`ls -l ./translation/ | awk '{print $9}' | grep strings`
for LOCALISATION in $LOCALISATIONS
do
echo  ${LOCALISATION}
logString=$(getLocalString ${LOCALISATION})
echo "logString: ${logString}"

# ls -lath ./$original_name/

echo "cp ./translation/${LOCALISATION} ./$original_name/res/values/strings.xml"
echo "cp ./translation/arrays_${logString}.xml ./$original_name/res/values/arrays.xml"
cp ./translation/${LOCALISATION} ./$original_name/res/values/strings.xml
cp ./translation/arrays_${logString}.xml ./$original_name/res/values/arrays.xml

echo "./apps/apktool b $original_name --output ./dist/${original_name}_${logString}.apk"
./apps/apktool b $original_name --output ./dist/${original_name}_${logString}.apk

echo "java -jar ./apps/sign.jar ./dist/${original_name}_${logString}.apk --override"
java -jar ./apps/sign.jar ./dist/${original_name}_${logString}.apk --override

done

echo "Finishing build..."
