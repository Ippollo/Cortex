# harvest_brains.ps1
# Sweeps Antigravity client brain folders for AI artifacts and copies them to Obsidian KB

$obsidianInbox = "c:\HQ\KB\00_Inbox"
$geminiDir = Join-Path $env:USERPROFILE ".gemini"
$clients = @("antigravity", "antigravity-ide", "antigravity-cli")

# Ensure inbox exists
if (-not (Test-Path $obsidianInbox)) {
    New-Item -ItemType Directory -Path $obsidianInbox -Force | Out-Null
}

$today = Get-Date -Format "yyyy-MM-dd"

foreach ($client in $clients) {
    $brainDir = Join-Path $geminiDir "$client\brain"
    if (-not (Test-Path $brainDir)) { continue }

    # Get all markdown files in the brain folder, excluding system files
    $mdFiles = Get-ChildItem -Path $brainDir -Filter "*.md" -Recurse -File -ErrorAction SilentlyContinue | 
        Where-Object { 
            $_.Name -ne "task.md" -and 
            $_.Name -ne "implementation_plan.md" -and 
            $_.Name -ne "walkthrough.md" -and
            $_.FullName -notmatch "system_generated" -and
            $_.FullName -notmatch "\\scratch\\"
        }

    foreach ($file in $mdFiles) {
        $destFile = Join-Path $obsidianInbox $file.Name
        
        # Avoid overwriting existing notes in Obsidian. If collision, append client name.
        if (Test-Path $destFile) {
            $baseName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
            $ext = $file.Extension
            $destFile = Join-Path $obsidianInbox "$baseName-$client$ext"
            if (Test-Path $destFile) {
                # If the renamed file also exists, skip to avoid duplicates
                continue
            }
        }

        Write-Host "Harvesting $($file.FullName) from $client -> $destFile"

        # Read as UTF-8 (explicit) — prevents Windows-1252 mojibake in PS 5.1
        $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)

        # Parse frontmatter
        $hasFrontmatter = $content -match "^\s*---\r?\n([\s\S]*?)\r?\n---\r?\n"
        
        if ($hasFrontmatter) {
            $fm = $Matches[1]
            if ($fm -notmatch "ai_client:") {
                # Inject tags and client info into existing frontmatter
                $newFm = $fm.Trim() + "`nai_client: $client"
                if ($fm -notmatch "tags:") {
                    $newFm += "`ntags:`n  - ai-harvest"
                } elseif ($fm -notmatch "ai-harvest") {
                    # Add tag to existing tags list (assuming list or array format)
                    $newFm = $newFm -replace "tags: \[(.*?)\]", "tags: [$1, ai-harvest]"
                    $newFm = $newFm -replace "tags:", "tags:`n  - ai-harvest"
                }
                $content = $content -replace "^\s*---\r?\n[\s\S]*?\r?\n---\r?\n", "---\r\n$newFm\r\n---\r\n"
            }
        } else {
            # Prepend new frontmatter
            $content = @"
---
date: $today
type: permanent
tags:
  - ai-harvest
ai_client: $client
---

$content
"@
        }

        # Write as UTF-8 without BOM — Set-Content -Encoding utf8 adds BOM in PS 5.1
        $utf8NoBom = New-Object System.Text.UTF8Encoding $false
        [System.IO.File]::WriteAllText($destFile, $content, $utf8NoBom)
    }
}
