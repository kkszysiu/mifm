#!/bin/bash
echo "Hello world..."

./apps/apktool d ./original_apk/mifm-1.37-1-6-3.apk --output ./mifm-1.37-1-6-3/ -f

cp ./translation/strings.xml ./mifm-1.37-1-6-3/res/values/strings.xml

./apps/apktool b mifm-1.37-1-6-3 --output ./dist/mifm-1.37-1-6-3.apk

java -jar ./apps/sign.jar ./dist/mifm-1.37-1-6-3.apk --override
