@echo off
echo Fixing EditProfile.jsp issues...

echo 1. Cleaning build directory...
if exist build rmdir /s /q build

echo 2. Cleaning compiled classes...
if exist dist rmdir /s /q dist

echo 3. Recreating build directory...
mkdir build
mkdir build\web
mkdir build\web\WEB-INF
mkdir build\web\WEB-INF\classes

echo 4. Copying web files...
xcopy /E /I web build\web

echo 5. Copying compiled classes...
if exist "src\java\**\*.class" (
    xcopy /E /I "src\java\**\*.class" "build\web\WEB-INF\classes\"
)

echo 6. Copying libraries...
if exist "library\*.jar" (
    xcopy /E /I "library\*.jar" "build\web\WEB-INF\lib\"
)

echo 7. Creating web.xml...
echo ^<?xml version="1.0" encoding="UTF-8"?^> > build\web\WEB-INF\web.xml
echo ^<web-app version="6.0" xmlns="https://jakarta.ee/xml/ns/jakartaee" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee https://jakarta.ee/xml/ns/jakartaee/web-app_6_0.xsd"^> >> build\web\WEB-INF\web.xml
echo     ^<servlet^> >> build\web\WEB-INF\web.xml
echo         ^<servlet-name^>EditProfileController^</servlet-name^> >> build\web\WEB-INF\web.xml
echo         ^<servlet-class^>controller.auth.EditProfileController^</servlet-class^> >> build\web\WEB-INF\web.xml
echo     ^</servlet^> >> build\web\WEB-INF\web.xml
echo     ^<servlet-mapping^> >> build\web\WEB-INF\web.xml
echo         ^<servlet-name^>EditProfileController^</servlet-name^> >> build\web\WEB-INF\web.xml
echo         ^<url-pattern^>/edit-profile^</url-pattern^> >> build\web\WEB-INF\web.xml
echo     ^</servlet-mapping^> >> build\web\WEB-INF\web.xml
echo ^</web-app^> >> build\web\WEB-INF\web.xml

echo 8. Creating WAR file...
cd build\web
jar -cf ..\..\dist\CatBaBooking.war *
cd ..\..

echo Done! Please restart your Tomcat server.
echo Test URL: http://localhost:8080/CatBaBooking/edit-profile
echo Note: Test files have been removed. Only EditProfile functionality remains.
pause
