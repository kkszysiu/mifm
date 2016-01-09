#!/bin/bash
echo "Hello world..."

mkdir -p ./mifm-1.37-1-6-3/

echo "./apps/apktool d ./original_apk/mifm-1.37-1-6-3.apk --output ./mifm-1.37-1-6-3/ -f"
./apps/apktool d ./original_apk/mifm-1.37-1-6-3.apk --output ./mifm-1.37-1-6-3/ -f

echo "cp ./translation/strings.xml ./mifm-1.37-1-6-3/res/values/strings.xml"

ls -lath
ls -lath ./mifm-1.37-1-6-3/

cp ./translation/strings.xml ./mifm-1.37-1-6-3/res/values/strings.xml

echo "./apps/apktool b ./mifm-1.37-1-6-3 --output ./dist/mifm-1.37-1-6-3.apk"
./apps/apktool b mifm-1.37-1-6-3 --output ./dist/mifm-1.37-1-6-3.apk

echo "java -jar ./apps/sign.jar ./dist/mifm-1.37-1-6-3.apk --override"
java -jar ./apps/sign.jar ./dist/mifm-1.37-1-6-3.apk --override
