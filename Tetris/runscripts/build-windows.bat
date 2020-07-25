::DRAG AND DROP ARCHIVE WITH THE WHOLE RESOURCE TREE ON THIS FILE TO BUILD .exe

:: Change the paths to match the installation present on the compiled system
copy /b D:\Frameworks\LOVE\love.exe+%1 "%~n1.exe"

if not exist "winbuild" mkdir winbuild
move "%~n1.exe" winbuild/"%~n1.exe"