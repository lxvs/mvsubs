@echo off
setlocal EnableDelayedExpansion
set needpause=
set trace=1

if exist "Season ??" (
    for /f "delims=" %%A in ('dir "Season ??" /b /ad') do (
        if defined trace (echo  + entering `%%~A')
        pushd "%%~A"
        call:move_single_season || goto end
        if defined trace (echo  + leaving `%%~A')
        popd
    )
) else (
    call:move_single_season
)
goto end

:move_single_season
if defined trace (echo  ++ starting moving single season)
if exist "Subs\" (
    if defined trace (echo  ++ entering `Subs')
    pushd Subs
)
for /f "delims=" %%a in ('dir /b /ad') do (
    if defined trace (echo  +++ entering `%%~a')
    pushd "%%~a"
    set lastlang=
    set subtype=
    set skip=
    for /f "delims=" %%b in ('dir ?_*.srt ??_*.srt /b /a-d') do (
        set "fn=%%~nb"
        set "num=!fn:~0,1!"
        set "language=!fn:~2!"
        if "!language:~0,1!" == "_" (
            set "num=!fn:~0,2!"
            set "language=!fn:~3!"
        )
        if "!lastlang!" == "!language!" (
            if not defined skip (
                if not defined subtype (
                    set subtype=.SDH
                ) else if "!subtype!" == ".SDH" (
                    set subtype=.Alt
                ) else (
                    >&2 echo warning: more than 3 subtitles of !language!, skipped
                    set needpause=1
                    set skip=1
                )
            )
        ) else (
            set subtype=
            set skip=
        )
        if not defined skip (
            set lastlang=!language!
            ren "%%~b" "%%~a.!language!!subtype!.srt"
            move "%%~a.!language!!subtype!.srt" "..\..\" 1>nul
        )
    )
    if defined trace (echo  +++ leaving `%%~a')
    popd
    rmdir "%%~a" || set needpause=1
)
if defined trace (echo  ++ leaving `Subs')
popd
rmdir Subs || set needpause=1
exit /b

:end
if %ErrorLevel% NEQ 0 (set needpause=1)
if defined trace (
    if defined needpause (
        echo finished with pause
    ) else (
        echo finished cleanly
    )
)
if defined needpause (pause)
exit /b
