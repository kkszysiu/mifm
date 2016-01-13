#!/bin/bash
echo "Starting build..."

original_name="mifm-1.38"

mkdir -p ./$original_name/

echo "./apps/apktool d ./original_apk/$original_name.apk --output ./$original_name/ -f"
./apps/apktool d ./original_apk/$original_name.apk --output ./$original_name/ -f

echo "cp ./translation/strings.xml ./$original_name/res/values/strings.xml"

exit 1

ls -lath
ls -lath ./$original_name/

cp ./translation/strings.xml ./$original_name/res/values/strings.xml

echo "./apps/apktool b ./$original_name --output ./dist/$original_name.apk"
./apps/apktool b $original_name --output ./dist/$original_name.apk

echo "java -jar ./apps/sign.jar ./dist/$original_name.apk --override"
java -jar ./apps/sign.jar ./dist/$original_name.apk --override

echo "Finishing build..."
