@echo off



:::::::::: ARGS ::::::::::
set "TARGET_VER="
set "DELETE_FLAG="
:ARGS_PARSE
if "%~1"=="" goto :ARGS_END
if /I "%~1"=="-v" (
    set "TARGET_VER=%~2"
    shift
    shift
    goto :ARGS_PARSE
)
shift
goto :ARGS_PARSE
:ARGS_END



:::::::::: SETUP ::::::::::
if not exist ".venv" (
    :::::::::: venv ::::::::::
    if defined TARGET_VER ( 
        py -%TARGET_VER% -m venv .venv 
    ) else ( 
        py -m venv .venv 
    )
    :::::::::: create initial files ::::::::::
    if not exist "requirements.txt" (type nul > requirements.txt)
    if not exist ".env" (type nul > .env)
    if not exist ".gitignore" (
        (
            echo __pycache__/
            echo .git/
            echo .venv/
            echo .env
        ) > .gitignore
    )
    :::::::::: git ::::::::::
    git init -q
    git add *
    git commit -m "git init" -q
)



:::::::::: ACTIVATE/DEACTIVATE ::::::::::
if not defined VIRTUAL_ENV (
    goto :ACTIVATE
) else (
    goto :DEACTIVATE
)



:::::::::: ACTIVATE ::::::::::
:ACTIVATE
:::::::::: set VIRTUAL_ENV ::::::::::
for %%I in (.venv) do set VIRTUAL_ENV=%%~fI
@REM set PROMPT
if not defined PROMPT set PROMPT=$P$G
if defined _OLD_PROMPT set PROMPT=%_OLD_PROMPT%
set "_OLD_PROMPT=%PROMPT%"
set "PROMPT=(.venv) %PROMPT%"
:::::::::: set PYTHONHOME ::::::::::
if defined _OLD_PYTHONHOME set PYTHONHOME=%_OLD_PYTHONHOME%
if defined PYTHONHOME set _OLD_PYTHONHOME=%PYTHONHOME%
set PYTHONHOME=
:::::::::: set PATH ::::::::::
if defined _OLD_PATH set PATH=%_OLD_PATH%
if not defined _OLD_PATH set _OLD_PATH=%PATH%
set "PATH=%VIRTUAL_ENV%\Scripts;%PATH%"
:::::::::: set .env ::::::::::
if exist ".env" (
    for /f "usebackq tokens=1,* delims==" %%A in (".env") do (
        set "VAR_NAME=%%A"
        set "VAR_VALUE=%%B"
        if defined %%A (
            set "_OLD_%%A=!%%A!"
        )
        set "%%A=%%B"
    )
)
:::::::::: pip requirements.txt ::::::::::
if exist "requirements.txt" (
    pip install -r requirements.txt | findstr /V "Requirement already satisfied"
)
goto :END



:::::::::: DEACTIVATE ::::::::::
:DEACTIVATE
:::::::::: reset VIRTUAL_ENV ::::::::::
set VIRTUAL_ENV=
:::::::::: reset PROMPT ::::::::::
if defined _OLD_PROMPT (
    set "PROMPT=%_OLD_PROMPT%"
    set _OLD_PROMPT=
)
:::::::::: reset PYTHONHOME ::::::::::
if defined _OLD_PYTHONHOME (
    set "PYTHONHOME=%_OLD_PYTHONHOME%"
    set _OLD_PYTHONHOME=
)
:::::::::: reset PATH ::::::::::
if defined _OLD_PATH (
    set "PATH=%_OLD_PATH%"
    set _OLD_PATH=
)
:::::::::: reset .env ::::::::::
if exist ".env" (
    for /f "usebackq tokens=1,* delims==" %%A in (".env") do (
        if defined _OLD_%%A (
            set "%%A=%_OLD_%%A%"
            set "_OLD_%%A="
        ) else (
            set "%%A="
        )
    )
)
goto :END



:::::::::: END ::::::::::
:END
set "TARGET_VER="
