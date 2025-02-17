; ------------------- KKT.iss -------------------
; Скрипт Inno Setup для установки KKT + создание задачи в Планировщике

[Setup]
AppName=KKT
AppVersion=1.0
DefaultDirName={pf32}\TimeKKT
DisableDirPage=yes
DisableProgramGroupPage=yes
Uninstallable=yes
OutputBaseFilename=KKTSetup
PrivilegesRequired=admin
ArchitecturesInstallIn64BitMode=x86
WizardStyle=modern
LanguageDetectionMethod=forceUseSelected
DefaultLanguage=russian
Compression=lzma
SolidCompression=yes

[Languages]
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

[Files]
Source: "C:\Users\greed0861\Documents\Эдем\KKT\bin\Release\net8.0-windows10.0.17763.0\KKT.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\greed0861\Documents\Эдем\KKT\bin\Release\net8.0-windows10.0.17763.0\KKT.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\greed0861\Documents\Эдем\KKT\bin\Release\net8.0-windows10.0.17763.0\Atol.Drivers10.Fptr.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\greed0861\Documents\Эдем\KKT\bin\Release\net8.0-windows10.0.17763.0\dotnet-runtime-8.0.13-win-x86.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall

[Run]
Filename: "{tmp}\dotnet-runtime-8.0.13-win-x86.exe"; Parameters: "/quiet /norestart"; Flags: waituntilterminated
Filename: "{sys}\WindowsPowerShell\v1.0\powershell.exe"; Parameters: "-ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -Command ""$Action = New-ScheduledTaskAction -Execute """"{app}\KKT.exe""""; $Trigger1 = New-ScheduledTaskTrigger -Daily -At 09:30AM; $Trigger2 = New-ScheduledTaskTrigger -Daily -At 08:15PM; $Trigger3 = New-ScheduledTaskTrigger -AtStartup; $Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries; Register-ScheduledTask -TaskName 'TimeKKT' -Action $Action -Trigger $Trigger1, $Trigger2, $Trigger3 -Settings $Settings -User SYSTEM -RunLevel Highest -Force"""; Flags: runhidden

[UninstallRun]
Filename: "{sys}\WindowsPowerShell\v1.0\powershell.exe"; Parameters: "-ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -Command ""Unregister-ScheduledTask -TaskName 'TimeKKT' -Confirm:$false"""; Flags: runhidden
