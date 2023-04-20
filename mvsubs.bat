@echo off
setlocal EnableDelayedExpansion
if exist "Subs\" (pushd Subs)
for /f "delims=" %%a in ('dir /b /ad') do (
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
    popd
    rmdir "%%~a"
)
popd
rmdir Subs
goto end

:end
if %ErrorLevel% NEQ 0 (pause)
exit /b
