#!/bin/bash

while [ 5 -gt 4 ]
do
echo "Menu : "
echo -e "0) push"
echo -n "Inputan : "
read userinput
if [ $userinput -eq 0 ]
then
flutter clean
flutter pub get
echo -n "Judul commit : "
read judul
git add *
git commit -m $judul
git push origin main
clear
fi
done