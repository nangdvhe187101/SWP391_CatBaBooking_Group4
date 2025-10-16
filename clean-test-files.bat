@echo off
echo Cleaning test files and references...

echo 1. Removing test JSP files...
if exist "web\test-editprofile.jsp" del "web\test-editprofile.jsp"
if exist "web\test-servlet.jsp" del "web\test-servlet.jsp"

echo 2. Removing test servlet...
if exist "src\java\Controller\auth\TestEditController.java" del "src\java\Controller\auth\TestEditController.java"

echo 3. Removing from build directory...
if exist "build\web\test-editprofile.jsp" del "build\web\test-editprofile.jsp"
if exist "build\web\test-servlet.jsp" del "build\web\test-servlet.jsp"

echo 4. Cleaning compiled test classes...
if exist "build\web\WEB-INF\classes\controller\auth\TestEditController.class" del "build\web\WEB-INF\classes\controller\auth\TestEditController.class"

echo 5. Updating documentation...
echo Test files have been removed. Only EditProfile functionality remains.

echo Done! Test files cleaned successfully.
echo You can now safely use only the EditProfile feature.
pause
