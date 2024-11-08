@echo off
set /p "folder=Enter the full path of the folder to process: "
if not exist "%folder%" (
    echo Folder not found: %folder%
    pause
    exit /b
)
echo Processing all MKV files in %folder%
for %%f in ("%folder%\*.mkv") do (
    echo Processing %%f
    "C:\Program Files\MKVToolNix\mkvpropedit.exe" "%%f" ^
    --edit info --set "title=" ^
    --tags all: ^
    --delete-attachment name:cover.png
)
echo Finished processing all files.
pause
