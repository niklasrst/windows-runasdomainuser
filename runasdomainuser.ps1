try {
    $appFile = Join-Path $PSScriptRoot 'app.txt'
    if (-not (Test-Path $appFile)) {
        throw "App not found: $appFile"
    }
    $appName = Get-Content -Path $appFile -Raw

    $domainFile = Join-Path $PSScriptRoot 'domain.txt'
    if (-not (Test-Path $domainFile)) {
        throw "Domain file not found: $domainFile"
    }
    $domainName = Get-Content -Path $domainFile -Raw

    $exePath = Join-Path $PSScriptRoot 'ShellRunas.exe'
    if (-not (Test-Path $exePath)) {
        throw "ShellRunas.exe not found: $exePath"
    }
    $arguments = "/netonly $appName /domain=$domainName /acceptEULA"

    $process = Start-Process -FilePath $exePath -ArgumentList $arguments -PassThru -ErrorAction Stop
    Write-Host "Process started successfully. PID: $($process.Id)"
}
catch {
    Write-Error "An error occurred: $_"
}