<#
.SYNOPSIS
    Build, run and test the frontend container locally.

.DESCRIPTION
    Convenience wrapper around the Docker commands needed to verify the
    Escape Room frontend on a local machine before pushing to ACR.

.PARAMETER Action
    up      Build the image and start the container (default).
    build   Only build the image.
    run     Only (re)start the container from the existing image.
    test    Hit /healthz, /, /tutorial against the running container.
    logs    Tail container logs (Ctrl+C to exit).
    down    Stop and remove the container.
    clean   Stop/remove container AND remove the image.

.PARAMETER Port
    Host port to expose. Default: 8000.

.PARAMETER Tag
    Image tag to use. Default: local.

.EXAMPLE
    .\scripts\frontend-local.ps1
    .\scripts\frontend-local.ps1 -Action test
    .\scripts\frontend-local.ps1 -Action down
#>
[CmdletBinding()]
param(
    [ValidateSet('up', 'build', 'run', 'test', 'logs', 'down', 'clean')]
    [string]$Action = 'up',

    [int]$Port = 8000,

    [string]$Tag = 'local'
)

$ErrorActionPreference = 'Stop'

$ImageName     = "escape-frontend:$Tag"
$ContainerName = 'escape-frontend-local'
$RepoRoot      = Split-Path -Parent $PSScriptRoot
$FrontendDir   = Join-Path $RepoRoot 'frontend'
$BaseUrl       = "http://localhost:$Port"

function Write-Step($msg) {
    Write-Host "==> $msg" -ForegroundColor Cyan
}

function Assert-Docker {
    try {
        docker info --format '{{.ServerVersion}}' | Out-Null
    } catch {
        Write-Host "Docker daemon is not reachable. Is Docker Desktop running?" -ForegroundColor Red
        exit 1
    }
}

function Invoke-Build {
    Assert-Docker
    Write-Step "Building $ImageName from $FrontendDir"
    docker build -t $ImageName $FrontendDir
    if ($LASTEXITCODE -ne 0) { throw "docker build failed" }
}

function Invoke-Run {
    Assert-Docker
    if (docker ps -aq -f "name=^$ContainerName$") {
        Write-Step "Removing existing container $ContainerName"
        docker rm -f $ContainerName | Out-Null
    }
    Write-Step "Starting container $ContainerName on port $Port"
    docker run -d --name $ContainerName -p "${Port}:8000" $ImageName | Out-Null
    Start-Sleep -Seconds 2
    docker ps --filter "name=$ContainerName"
}

function Invoke-Test {
    Write-Step "Testing endpoints at $BaseUrl"
    $endpoints = @('/healthz', '/', '/tutorial')
    $failed = 0
    $prevProgress = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'
    foreach ($ep in $endpoints) {
        try {
            $resp = Invoke-WebRequest -Uri "$BaseUrl$ep" -UseBasicParsing -TimeoutSec 5
            $status = $resp.StatusCode
            $color = if ($status -eq 200) { 'Green' } else { 'Yellow' }
            Write-Host ("  {0,-12} HTTP {1}" -f $ep, $status) -ForegroundColor $color
            if ($ep -eq '/healthz') {
                Write-Host "               body: $($resp.Content)" -ForegroundColor DarkGray
            }
            if ($status -ne 200) { $failed++ }
        } catch {
            Write-Host ("  {0,-12} ERROR  {1}" -f $ep, $_.Exception.Message) -ForegroundColor Red
            $failed++
        }
    }
    $ProgressPreference = $prevProgress
    if ($failed -gt 0) {
        Write-Host "$failed endpoint(s) failed." -ForegroundColor Red
        exit 1
    }
    Write-Host "All endpoints OK." -ForegroundColor Green
}

function Invoke-Logs {
    docker logs -f $ContainerName
}

function Invoke-Down {
    Assert-Docker
    if (docker ps -aq -f "name=^$ContainerName$") {
        Write-Step "Stopping and removing $ContainerName"
        docker rm -f $ContainerName | Out-Null
        Write-Host "Container removed." -ForegroundColor Green
    } else {
        Write-Host "No container named $ContainerName running." -ForegroundColor DarkGray
    }
}

function Invoke-Clean {
    Invoke-Down
    if (docker images -q $ImageName) {
        Write-Step "Removing image $ImageName"
        docker rmi $ImageName | Out-Null
        Write-Host "Image removed." -ForegroundColor Green
    }
}

switch ($Action) {
    'build' { Invoke-Build }
    'run'   { Invoke-Run }
    'test'  { Invoke-Test }
    'logs'  { Invoke-Logs }
    'down'  { Invoke-Down }
    'clean' { Invoke-Clean }
    'up' {
        Invoke-Build
        Invoke-Run
        Invoke-Test
        Write-Host ""
        Write-Host "Frontend is running at $BaseUrl" -ForegroundColor Green
        Write-Host "Stop with:  .\scripts\frontend-local.ps1 -Action down" -ForegroundColor DarkGray
    }
}
