# Compila l'app iPhone su GitHub Actions e scarica il nuovo .ipa in Download\MauiApp1-ipa.
# Uso: powershell -ExecutionPolicy Bypass -File .\aggiorna-iphone.ps1
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

# GitHub compila solo cio' che e' stato inviato con push
git fetch -q origin
$nonInviati = git rev-list --count origin/main..main
if ($nonInviati -ne "0") {
    Write-Host "Attenzione: $nonInviati commit non ancora inviati. Fai push da Visual Studio (GIT > Push) e rilancia." -ForegroundColor Yellow
    exit 1
}
if (git status --porcelain) {
    Write-Host "Nota: ci sono modifiche non salvate in un commit, NON saranno nell'app." -ForegroundColor Yellow
}

Write-Host "Avvio la compilazione su GitHub..."
$url = gh workflow run ios.yml --ref main
if ($LASTEXITCODE -ne 0) { exit 1 }
$runId = ($url -split "/")[-1]
Write-Host "Compilazione: $url"
Write-Host "Aspetto che finisca (10-20 minuti)..."

gh run watch $runId --exit-status --interval 30 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Compilazione FALLITA. Apri il link sopra e incolla il log a Claude." -ForegroundColor Red
    exit 1
}

$dest = Join-Path $env:USERPROFILE "Downloads\MauiApp1-ipa"
if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
gh run download $runId -n app-ios -D $dest
if ($LASTEXITCODE -ne 0) { exit 1 }

$ipa = Get-ChildItem $dest -Recurse -Filter *.ipa | Select-Object -First 1
Write-Host "Fatto! Trascina in Sideloadly questo file:" -ForegroundColor Green
Write-Host $ipa.FullName
explorer.exe /select,"$($ipa.FullName)"
