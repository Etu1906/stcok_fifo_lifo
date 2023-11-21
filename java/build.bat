@echo off
cls
xcopy "bin" "app/WEB-INF/classes" /s /e /y
cd app 
jar cvf ../stock.war .
cd ..
copy "stock.war" "D:\apache-tomcat-10.1.15\webapps"



