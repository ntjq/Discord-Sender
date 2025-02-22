@echo off
setlocal enabledelayedexpansion
set "webhook_file=webhooks.txt"

:menu
cls
echo ============================================
echo Select an option:
echo 1. Send a message
echo 2. Save a new webhook
echo 3. My Instagram Account
echo 4. Exit
echo ============================================
set /p choice="Enter your choice (1, 2, 3, or 4): "

if "%choice%"=="1" goto choose_webhook
if "%choice%"=="2" goto save_webhook
if "%choice%"=="3" goto open_url
if "%choice%"=="4" exit

echo Invalid choice. Please try again.
pause
goto menu

:choose_webhook
cls
echo ============================================
echo Available Webhooks:
echo ============================================
if not exist "%webhook_file%" (
    echo No webhooks saved. Please save a webhook first.
    pause
    goto menu
)

set "count=0"
for /f "tokens=1,2 delims=," %%a in (%webhook_file%) do (
    set /a count+=1
    echo !count!. %%a - %%b
)

if %count%==0 (
    echo No webhooks saved. Please save a webhook first.
    pause
    goto menu
)

echo ============================================
set /p webhook_choice="Enter the number of the webhook to use: "
if "%webhook_choice%"=="" (
    echo Invalid choice. Please try again.
    pause
    goto choose_webhook
)

set "count=0"
for /f "tokens=1,2 delims=," %%a in (%webhook_file%) do (
    set /a count+=1
    if !count! equ %webhook_choice% (
        set "webhook_name=%%a"
        set "webhook_url=%%b"
        goto message_input
    )
)

echo Invalid choice. Please try again.
pause
goto choose_webhook

:message_input
cls
echo ============================================
echo Discord Webhook Message Sender
echo Webhook: %webhook_name%
echo ============================================
set /p message="Type your message (or type 'exit' to quit): "
if "%message%"=="exit" goto menu
if "%message%"=="" (
    echo Message cannot be empty.
    pause
    goto message_input
)

powershell -Command "Invoke-RestMethod -Uri '%webhook_url%' -Method Post -Body (@{content='%message%'} | ConvertTo-Json) -ContentType 'application/json'"
echo Message sent! Press any key to continue...
pause >nul
goto message_input

:save_webhook
cls
echo ============================================
echo Save a New Webhook
echo ============================================
set /p webhook_name="Enter a name for the webhook: "
if "%webhook_name%"=="" (
    echo Webhook name cannot be empty.
    pause
    goto save_webhook
)

set /p webhook_url="Enter the Discord webhook URL: "
if "%webhook_url%"=="" (
    echo Webhook URL cannot be empty.
    pause
    goto save_webhook
)

echo %webhook_url% | findstr /r /c:"^https://discord\.com/api/webhooks/" >nul
if errorlevel 1 (
    echo Invalid webhook URL format. Please ensure it starts with 'https://discord.com/api/webhooks/'.
    pause
    goto save_webhook
)

echo %webhook_name%,%webhook_url% >> %webhook_file%
echo Webhook saved successfully!
pause
goto menu

:open_url
start "" "https://www.instagram.com/ptjq/"
goto menu