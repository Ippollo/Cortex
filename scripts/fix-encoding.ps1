<#
.SYNOPSIS
    Fix UTF-8 mojibake in Obsidian vault markdown files.

.DESCRIPTION
    Corrects encoding corruption introduced by harvest_brains.ps1 reading UTF-8 files
    through a Windows-1252 lens. Reads files as UTF-8, replaces known mojibake sequences
    with their correct Unicode equivalents, writes back as UTF-8 without BOM.

.PARAMETER Path
    One or more directories to scan recursively.

.PARAMETER Apply
    If specified, writes changes to disk. Without this flag, runs as a dry-run only.

.PARAMETER Report
    Path to write a CSV change report.

.EXAMPLE
    .\fix-encoding.ps1
    .\fix-encoding.ps1 -Apply
    .\fix-encoding.ps1 -Path "c:\HQ\KB\00_Inbox" -Apply
#>
param(
    [string[]]$Path = @(
        'c:\HQ\KB\00_Inbox',
        'c:\HQ\KB\20_Journal',
        'c:\HQ\KB\40_Knowledge\jobs\_archive'
    ),
    [switch]$Apply,
    [string]$Report = (Join-Path $PSScriptRoot 'fix-encoding-report.csv')
)

# Build replacement map using [char] casts — compatible with PS 5.1
# Keys are the garbled strings after CP-1252 misreading of UTF-8 bytes.
# CP-1252 code points verified by inspecting actual file bytes after corruption.
#
# Byte-to-CP1252 mapping reference (selected):
#   0x80 -> U+20AC (Euro €)   0x93 -> U+201C (" left dquote)  0x94 -> U+201D (" right dquote)
#   0x99 -> U+2122 (™ tm)     0x9C -> U+0153 (œ oe)           0x9D -> U+009D (control, kept as-is)
#   0x9F -> U+0178 (Ÿ)        0x85 -> U+2026 (… ellipsis)     0x91 -> U+2018 (' left squote)
#   0x92 -> U+2019 (' right squote)  0x96 -> U+2013 (– en dash)  0x97 -> U+2014 (— em dash)
#   0x8E -> U+017D (Ž)        0x8F -> U+008F (control)

function Make-Str([int[]]$codes) { -join ($codes | ForEach-Object { [char]$_ }) }

$replacements = [ordered]@{}

# --- PUNCTUATION (3-byte UTF-8 sequences) ---

# em dash U+2014: UTF-8 E2 80 94 -> CP1252: E2=â 80=€ 94=U+201D(")
$replacements[(Make-Str @(0xE2, 0x20AC, 0x201D))] = [char]0x2014

# en dash U+2013: UTF-8 E2 80 93 -> CP1252: E2=â 80=€ 93=U+201C(")
$replacements[(Make-Str @(0xE2, 0x20AC, 0x201C))] = [char]0x2013

# right single quote U+2019: UTF-8 E2 80 99 -> CP1252: E2=â 80=€ 99=U+2122(™)
$replacements[(Make-Str @(0xE2, 0x20AC, 0x2122))] = [char]0x2019

# left double quote U+201C: UTF-8 E2 80 9C -> CP1252: E2=â 80=€ 9C=U+0153(œ)
$replacements[(Make-Str @(0xE2, 0x20AC, 0x0153))] = [char]0x201C

# right double quote U+201D: UTF-8 E2 80 9D -> CP1252: E2=â 80=€ 9D=U+009D(ctrl)
$replacements[(Make-Str @(0xE2, 0x20AC, 0x009D))] = [char]0x201D

# right arrow U+2192: UTF-8 E2 86 92 -> CP1252: E2=â 86=† 92=U+2019(')
$replacements[(Make-Str @(0xE2, 0x2020, 0x2019))] = [char]0x2192

# degree sign U+00B0: UTF-8 C2 B0 -> CP1252: C2=Â B0=°
$replacements[(Make-Str @(0xC2, 0xB0))] = [char]0x00B0

# middle dot U+00B7: UTF-8 C2 B7 -> CP1252: C2=Â B7=·
$replacements[(Make-Str @(0xC2, 0xB7))] = [char]0x00B7

# --- EMOJI (3-byte UTF-8, U+2000-U+2FFF range) ---

# checkmark U+2705: UTF-8 E2 9C 85 -> CP1252: E2=â 9C=U+0153(œ) 85=U+2026(…)
$replacements[(Make-Str @(0xE2, 0x0153, 0x2026))] = [char]0x2705

# cross mark U+274C: UTF-8 E2 9D 8C -> CP1252: E2=â 9D=U+009D(ctrl) 8C=U+0152(Œ)
$replacements[(Make-Str @(0xE2, 0x009D, 0x0152))] = [char]0x274C

# warning U+26A0 + variation U+FE0F: UTF-8 E2 9A A0 EF B8 8F -> CP1252: E2=â 9A=U+0161(š) A0=NBSP EF=ï B8=¸ 8F=U+008F(ctrl)
$replacements[(Make-Str @(0xE2, 0x0161, 0x00A0, 0xEF, 0x00B8, 0x008F))] = ([char]0x26A0 + [char]0xFE0F)

# --- EMOJI (4-byte UTF-8, supplementary plane via surrogate pairs) ---
# 4-byte UTF-8: F0 9F XX YY -> CP1252: F0=ð 9F=U+0178(Ÿ) XX=cp1252(XX) YY=cp1252(YY)

# green circle U+1F7E2: F0 9F 9F A2 -> ð Ÿ Ÿ ¢  (9F->U+0178, 9F->U+0178, A2->¢)
$replacements[(Make-Str @(0xF0, 0x0178, 0x0178, 0x00A2))] = [char]::ConvertFromUtf32(0x1F7E2)

# yellow circle U+1F7E1: F0 9F 9F A1 -> ð Ÿ Ÿ ¡
$replacements[(Make-Str @(0xF0, 0x0178, 0x0178, 0x00A1))] = [char]::ConvertFromUtf32(0x1F7E1)

# red circle U+1F534: F0 9F 94 B4 -> ð Ÿ U+201D ´  (94->U+201D, B4->´)
$replacements[(Make-Str @(0xF0, 0x0178, 0x201D, 0x00B4))] = [char]::ConvertFromUtf32(0x1F534)

# bullseye U+1F3AF: F0 9F 8E AF -> ð Ÿ U+017D ¯  (8E->U+017D(Ž), AF->¯)
$replacements[(Make-Str @(0xF0, 0x0178, 0x017D, 0x00AF))] = [char]::ConvertFromUtf32(0x1F3AF)

# briefcase U+1F4BC: F0 9F 92 BC -> ð Ÿ U+2019 ¼  (92->U+2019('), BC->¼)
$replacements[(Make-Str @(0xF0, 0x0178, 0x2019, 0x00BC))] = [char]::ConvertFromUtf32(0x1F4BC)

# compass U+1F9ED: F0 9F A7 AD -> ð Ÿ § ­  (A7->§, AD->soft hyphen U+00AD)
$replacements[(Make-Str @(0xF0, 0x0178, 0x00A7, 0x00AD))] = [char]::ConvertFromUtf32(0x1F9ED)

# gold medal U+1F947: F0 9F A5 87 -> ð Ÿ ¥ ‡  (A5->¥, 87->U+2021(‡))
$replacements[(Make-Str @(0xF0, 0x0178, 0x00A5, 0x2021))] = [char]::ConvertFromUtf32(0x1F947)

# silver medal U+1F948: F0 9F A5 88 -> ð Ÿ ¥ ˆ  (A5->¥, 88->U+02C6(ˆ))
$replacements[(Make-Str @(0xF0, 0x0178, 0x00A5, 0x02C6))] = [char]::ConvertFromUtf32(0x1F948)

$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$results = [System.Collections.Generic.List[PSObject]]::new()

$allFiles = foreach ($dir in $Path) {
    if (Test-Path $dir) {
        Get-ChildItem -Path $dir -Filter '*.md' -Recurse -File -ErrorAction SilentlyContinue
    } else {
        Write-Warning "Path not found: $dir"
    }
}

$totalScanned = 0
$totalFixed = 0

foreach ($file in $allFiles) {
    $totalScanned++

    try {
        $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    } catch {
        Write-Warning "Could not read $($file.FullName): $_"
        continue
    }

    $original = $content
    $changeLog = [System.Collections.Generic.List[string]]::new()

    foreach ($pair in $replacements.GetEnumerator()) {
        if ($content.Contains($pair.Key)) {
            $occurrences = 0
            $idx = 0
            while (($idx = $content.IndexOf($pair.Key, $idx)) -ge 0) {
                $occurrences++
                $idx += $pair.Key.Length
            }
            $content = $content.Replace($pair.Key, $pair.Value)
            $changeLog.Add("$occurrences replacements")
        }
    }

    if ($content -ne $original) {
        $totalFixed++
        $entry = [PSCustomObject]@{
            File    = $file.FullName
            Changes = ($changeLog -join '; ')
            Applied = $Apply.IsPresent
        }
        $results.Add($entry)

        if ($Apply) {
            try {
                [System.IO.File]::WriteAllText($file.FullName, $content, $utf8NoBom)
            } catch {
                Write-Warning "Could not write $($file.FullName): $_"
            }
        }
    }
}

# Write CSV report
if ($results.Count -gt 0) {
    $results | Export-Csv -Path $Report -NoTypeInformation -Encoding UTF8
}

# Summary
$mode = if ($Apply) { 'APPLIED' } else { 'DRY-RUN' }
Write-Host ""
Write-Host "=== fix-encoding.ps1 | $mode ===" -ForegroundColor Cyan
Write-Host "Scanned:  $totalScanned files" -ForegroundColor White
Write-Host "Affected: $totalFixed files" -ForegroundColor $(if ($totalFixed -gt 0) { 'Yellow' } else { 'Green' })
if ($Apply) {
    Write-Host "Fixed:    $totalFixed files written as UTF-8 without BOM" -ForegroundColor Green
}
Write-Host "Report:   $Report" -ForegroundColor White
Write-Host ""

if ($results.Count -gt 0 -and -not $Apply) {
    Write-Host "Run with -Apply to write fixes." -ForegroundColor Yellow
}

$results | Select-Object -Property @{N='File';E={$_.File | Split-Path -Leaf}}, Changes | Format-Table -AutoSize
