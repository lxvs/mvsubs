@echo off
setlocal EnableDelayedExpansion
for /f "delims=" %%a in ('dir /b /ad') do (
    pushd "%%~a"
    set lastlang=
    set subtype=
    for /f "delims=" %%b in ('dir ?_*.srt ??_*.srt /b /a-d') do (
        set "fn=%%~nb"
        set "num=!fn:~0,1!"
        set "language=!fn:~2!"
        if "!language:~0,1!" == "_" (
            set "num=!fn:~0,2!"
            set "language=!fn:~3!"
        )
        call:ConvertLang "!language!" || goto end
        if "!lastlang!" == "!lang!" (
            if "!subtype!" == "" (
                set subtype=.sdh
            ) else (
                >&2 echo warning: more than two subtitles of !language!, skipped
                set skip=1
            )
        )
        if "!skip!" NEQ "1" (
            set lastlang=!lang!
            ren "%%~b" "../%%~a.!lang!!subtype!.srt"
        )
    )
    popd
    rmdir "%%~a"
)
goto end

:ConvertLang
if "%~1" == "" (
    >&2 echo error: failed to get language label
    exit /b 1
)
if /i "%~1" == "English" (
    set lang=eng
    exit /b 0
)
if /i "%~1" == "Arabic" (
    set lang=aao
    exit /b 0
)
if /i "%~1" == "Chinese" (
    set lang=chs
    exit /b 0
)
if /i "%~1" == "Czech" (
    set lang=ces
    exit /b 0
)
if /i "%~1" == "Danish" (
    set lang=dan
    exit /b 0
)
if /i "%~1" == "German" (
    set lang=deu
    exit /b 0
)
if /i "%~1" == "Greek" (
    set lang=ell
    exit /b 0
)
if /i "%~1" == "Spanish" (
    set lang=spa
    exit /b 0
)
if /i "%~1" == "Finnish" (
    set lang=fin
    exit /b 0
)
if /i "%~1" == "French" (
    set lang=fra
    exit /b 0
)
if /i "%~1" == "Hebrew" (
    set lang=heb
    exit /b 0
)
if /i "%~1" == "Hindi" (
    set lang=hin
    exit /b 0
)
if /i "%~1" == "hin" (
    set lang=hin
    exit /b 0
)
if /i "%~1" == "Hungarian" (
    set lang=hun
    exit /b 0
)
if /i "%~1" == "Indonesian" (
    set lang=ind
    exit /b 0
)
if /i "%~1" == "Italian" (
    set lang=ita
    exit /b 0
)
if /i "%~1" == "Japanese" (
    set lang=jpn
    exit /b 0
)
if /i "%~1" == "Bokmal" (
    set lang=nob
    exit /b 0
)
if /i "%~1" == "Dutch" (
    set lang=nld
    exit /b 0
)
if /i "%~1" == "Polish" (
    set lang=pol
    exit /b 0
)
if /i "%~1" == "Portuguese" (
    set lang=por
    exit /b 0
)
if /i "%~1" == "Romanian" (
    set lang=ron
    exit /b 0
)
if /i "%~1" == "Russian" (
    set lang=rus
    exit /b 0
)
if /i "%~1" == "Swedish" (
    set lang=swe
    exit /b 0
)
if /i "%~1" == "Thai" (
    set lang=tha
    exit /b 0
)
if /i "%~1" == "Turkish" (
    set lang=tur
    exit /b 0
)
if /i "%~1" == "Vietnamese" (
    set lang=vie
    exit /b 0
)
>&2 echo error: unknown language: %~1
exit /b 1

:end
if %ErrorLevel% NEQ 0 pause
exit /b
