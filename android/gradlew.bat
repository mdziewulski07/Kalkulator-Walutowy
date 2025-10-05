@ECHO OFF
SET DIR=%~dp0
WHERE gradle >NUL 2>&1
IF %ERRORLEVEL% EQU 0 (
  gradle -p "%DIR%" %*
) ELSE (
  ECHO Gradle is not installed. Please install Gradle to build Android artifacts.
  EXIT /B 1
)
