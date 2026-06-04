<#
.SYNOPSIS
    Validate that markdown files in a vault directory are free of known UTF-8 mojibake.

.DESCRIPTION
    Scans .md files for known mojibake sequences introduced by the PS 5.1 CP-1252 encoding bug.
    Returns exit code 0 if clean, exit code 1 if issues are found.
    Suitable for use as a workflow gate (e.g., post-harvest validation).

.PARAMETER Path
    Directory to scan (recursively). Defaults to KB inbox.

.PARAMETER Quiet
    Suppress detailed output. Still sets exit code.

.EXAMPLE
    # Check inbox after a harvest
    .\validate-encoding.ps1 -Path "c:\HQ\KB\00_Inbox"

.EXAMPLE
    # Check the full vault
    .\validate-encoding.ps1 -Path "c:\HQ\KB"

.EXAMPLE
    # Use as a gate in a script (check exit code)
    .\validate-encoding.ps1 -Path "c:\HQ\KB\00_Inbox" -Quiet
    if ($LASTEXITCODE -ne 0) { Write-Error "Encoding issues found — run fix-encoding.ps1" }
#>
param(
    [string]$Path = 'c:\HQ\KB\00_Inbox',
    [switch]$Quiet
)

# Known mojibake patterns — leading bytes of common corrupted sequences
# Using just the first 2 bytes of each pattern for fast detection
$knownPatterns = @(
    "`u{00E2}`u{20AC}",   # start of em-dash, en-dash, smart quotes (U+2014, 2013, 2019, 201C, 201D)
    "`u{00C2}`u{00B0}",   # degree sign Ao
    "`u{00C2}`u{00B7}",   # middle dot A*
    "`u{00F0}`u{009F}",   # 4-byte emoji prefix
    "`u{00E2}`u{009C}",   # checkmark prefix
    "`u{00E2}`u{008C}",   # cross mark prefix
    "`u{00E2}`u{009A}",   # warning sign prefix
    "`u{00E2}`u{0086}"    # arrow prefix
)

if (-not (Test-Path $Path)) {
    Write-Error "Path not found: $Path"
    exit 2
}

$allFiles = Get-ChildItem -Path $Path -Filter '*.md' -Recurse -File -ErrorAction SilentlyContinue
$issues = [System.Collections.Generic.List[PSObject]]::new()
$totalScanned = 0

foreach ($file in $allFiles) {
    $totalScanned++
    try {
        $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    } catch {
        Write-Warning "Could not read $($file.FullName): $_"
        continue
    }

    $foundIn = [System.Collections.Generic.List[string]]::new()
    foreach ($pattern in $knownPatterns) {
        if ($content.Contains($pattern)) {
            $foundIn.Add($pattern)
        }
    }

    if ($foundIn.Count -gt 0) {
        $issues.Add([PSCustomObject]@{
            File     = $file.FullName
            Patterns = $foundIn.Count
        })
    }
}

if (-not $Quiet) {
    Write-Host ""
    Write-Host "=== validate-encoding.ps1 ===" -ForegroundColor Cyan
    Write-Host "Path:    $Path" -ForegroundColor White
    Write-Host "Scanned: $totalScanned files" -ForegroundColor White

    if ($issues.Count -eq 0) {
        Write-Host "Result:  CLEAN - no mojibake detected" -ForegroundColor Green
    } else {
        Write-Host "Result:  ISSUES FOUND - $($issues.Count) file(s) with mojibake" -ForegroundColor Red
        Write-Host ""
        Write-Host "Run fix-encoding.ps1 -Apply to correct these files." -ForegroundColor Yellow
        $issues | Format-Table -AutoSize
    }
    Write-Host ""
}

if ($issues.Count -gt 0) {
    exit 1
} else {
    exit 0
}
