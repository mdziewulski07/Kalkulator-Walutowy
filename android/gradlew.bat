@ECHO OFF
SET DIR=%~dp0
SET WRAPPER_JAR=%DIR%gradle\wrapper\gradle-wrapper.jar
SET JAVA_EXE=java
IF NOT "%JAVA_HOME%"=="" SET JAVA_EXE=%JAVA_HOME%\bin\java

IF EXIST "%WRAPPER_JAR%" (
  "%JAVA_EXE%" -classpath "%WRAPPER_JAR%" org.gradle.wrapper.GradleWrapperMain %*
  GOTO END
)

IF NOT "%FLUTTER_ROOT%"=="" (
  SET ALT_JAR=%FLUTTER_ROOT%\packages\flutter_tools\gradle\gradle-wrapper.jar
  IF EXIST "%ALT_JAR%" (
    "%JAVA_EXE%" -classpath "%ALT_JAR%" org.gradle.wrapper.GradleWrapperMain %*
    GOTO END
  )
)

ECHO Gradle wrapper JAR not found, falling back to system gradle.
gradle %*

:END
