[CmdletBinding()]
param(
    [string]$Version,
    [switch]$Publish
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location -LiteralPath $repoRoot
if ($Version -and -not $Publish) {
    throw 'Per canviar la versió i publicar, combina -Version amb -Publish.'
}

function Invoke-Checked {
    param([string]$Program, [string[]]$Arguments)
    & $Program @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "$Program ha fallat amb codi $LASTEXITCODE"
    }
}

$git = (Get-Command git -ErrorAction Stop).Source
$kpsewhich = (Get-Command kpsewhich -ErrorAction Stop).Source
$mktexlsr = (Get-Command mktexlsr -ErrorAction Stop).Source
$styles = @(Get-ChildItem -LiteralPath $repoRoot -Filter 'martimath*.sty' -File)
if ($styles.Count -ne 5) {
    throw "S'esperaven cinc fitxers .sty a l'arrel del repo; trobats: $($styles.Count)"
}

if ($Publish) {
    if (-not $Version -or $Version -notmatch '^\d+\.\d+\.\d+$') {
        throw 'Per publicar, indica una versió SemVer com ara -Version 1.0.1.'
    }
    $branch = (& $git branch --show-current).Trim()
    if ($branch -ne 'main') { throw "La publicació s'ha de fer des de main; branca actual: $branch" }
    $localTag = @(& $git tag --list "v$Version")
    if ($localTag.Count -gt 0) { throw "El tag v$Version ja existeix localment." }
    $remoteTag = @(& $git ls-remote --tags origin "refs/tags/v$Version")
    if ($remoteTag.Count -gt 0) { throw "El tag v$Version ja existeix a origin." }
    Invoke-Checked $git @('fetch', 'origin', 'main')
    $counts = (& $git rev-list --left-right --count 'origin/main...HEAD').Trim() -split '\s+'
    if ($counts.Count -ne 2 -or $counts[0] -ne '0') {
        throw 'La branca local no inclou origin/main. Integra els canvis remots abans de publicar.'
    }
    Invoke-Checked (Get-Command gh -ErrorAction Stop).Source @('auth', 'status')

    $date = Get-Date -Format 'yyyy/MM/dd'
    foreach ($style in $styles) {
        $text = [IO.File]::ReadAllText($style.FullName)
        $pattern = '(?m)^(\\ProvidesPackage\{[^}]+\}\[)\d{4}/\d{2}/\d{2}\s+v[^\s\]]+(.*\])(?=\r?$)'
        $updated = [regex]::Replace($text, $pattern, { param($m) $m.Groups[1].Value + $date + ' v' + $Version + $m.Groups[2].Value })
        if ($updated -eq $text) { throw "No he pogut actualitzar la versió a $($style.Name)." }
        [IO.File]::WriteAllText($style.FullName, $updated, [Text.UTF8Encoding]::new($false))
    }
    $mainStyle = Join-Path $repoRoot 'martimath.sty'
    $mainText = [IO.File]::ReadAllText($mainStyle)
    $mainText = [regex]::Replace($mainText, '(?m)^%% martimath v[^\s]+', "%% martimath v$Version")
    [IO.File]::WriteAllText($mainStyle, $mainText, [Text.UTF8Encoding]::new($false))
    $readme = Join-Path $repoRoot 'README.md'
    $readmeText = [IO.File]::ReadAllText($readme)
    $readmeText = [regex]::Replace($readmeText, '(?m)^# martimath(?: v)?[^\r\n]*', "# martimath $Version", 1)
    [IO.File]::WriteAllText($readme, $readmeText, [Text.UTF8Encoding]::new($false))

    Write-Output 'Canvis que s''inclouran al commit de release:'
    & $git status --short
    $confirmation = Read-Host "Per confirmar commit, push i release, escriu v$Version"
    if ($confirmation -cne "v$Version") { throw 'Publicació cancel·lada.' }
    Invoke-Checked $git @('add', '-A')
    Invoke-Checked $git @('commit', '-m', "Release v$Version")
    $releaseVersion = $Version
}
else {
    $mainText = [IO.File]::ReadAllText((Join-Path $repoRoot 'martimath.sty'))
    $match = [regex]::Match($mainText, '\\ProvidesPackage\{martimath\}\[\d{4}/\d{2}/\d{2}\s+v([^\s\]]+)')
    if (-not $match.Success) { throw 'No he pogut detectar la versió a martimath.sty.' }
    $releaseVersion = $match.Groups[1].Value
}

$distDir = Join-Path $repoRoot 'dist'
New-Item -ItemType Directory -Force -Path $distDir | Out-Null
$stageRoot = Join-Path $env:TEMP ('martimath-release-' + [guid]::NewGuid().ToString('N'))
$stageDir = Join-Path $stageRoot "martimath-$releaseVersion"
New-Item -ItemType Directory -Force -Path $stageDir | Out-Null
try {
    foreach ($style in $styles) { Copy-Item -LiteralPath $style.FullName -Destination $stageDir -Force }
    $zipPath = Join-Path $distDir "martimath-v$releaseVersion.zip"
    if (Test-Path -LiteralPath $zipPath) { [IO.File]::Delete($zipPath) }
    Compress-Archive -LiteralPath $stageDir -DestinationPath $zipPath -CompressionLevel Optimal
}
finally {
    $tempRoot = [IO.Path]::GetFullPath($env:TEMP).TrimEnd([IO.Path]::DirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
    $fullStageRoot = [IO.Path]::GetFullPath($stageRoot)
    if ($fullStageRoot.StartsWith($tempRoot, [StringComparison]::OrdinalIgnoreCase) -and (Test-Path -LiteralPath $fullStageRoot -PathType Container)) {
        [IO.Directory]::Delete($fullStageRoot, $true)
    }
}

$texmf = (& $kpsewhich '-var-value=TEXMFHOME').Trim()
if (-not $texmf) { throw 'kpsewhich no ha retornat TEXMFHOME.' }
$installDir = Join-Path $texmf 'tex\latex\martimath'
New-Item -ItemType Directory -Force -Path $installDir | Out-Null
foreach ($style in $styles) { Copy-Item -LiteralPath $style.FullName -Destination $installDir -Force }
Invoke-Checked $mktexlsr @($texmf)
$found = (& $kpsewhich 'martimath.sty').Trim()
if (-not $found) { throw 'kpsewhich no troba martimath.sty després de la instal·lació.' }

Write-Output "martimath v$releaseVersion instal·lat a $installDir"
Write-Output "ZIP creat: $zipPath"
Write-Output "kpsewhich: $found"

if ($Publish) {
    $tag = "v$Version"
    Invoke-Checked $git @('tag', '-a', $tag, '-m', "martimath $tag")
    Invoke-Checked $git @('push', 'origin', 'main')
    Invoke-Checked $git @('push', 'origin', $tag)
    Invoke-Checked (Get-Command gh -ErrorAction Stop).Source @('release', 'create', $tag, $zipPath, '--title', "martimath $tag", '--generate-notes', '--target', 'main')
    Write-Output "Release publicat: https://github.com/marticarrasco/martimath/releases/tag/$tag"
}
