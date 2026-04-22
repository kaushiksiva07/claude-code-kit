param([string]$State)

# Changes the Windows Terminal background color for the CURRENT tab's profile only.
# Uses WT_PROFILE_ID to identify which profile to modify, then writes to WT's
# settings.json which it hot-reloads automatically.

$wtSettings = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$profileId = $env:WT_PROFILE_ID

if (-not $profileId -or -not (Test-Path $wtSettings)) { exit 0 }

try {
    $raw = [System.IO.File]::ReadAllText($wtSettings)
    $json = $raw | ConvertFrom-Json
    $profile = $json.profiles.list | Where-Object { $_.guid -eq $profileId }
    if (-not $profile) { exit 0 }

    switch ($State) {
        "working" {
            # Royal blue — Claude is actively generating/executing
            $profile | Add-Member -NotePropertyName "background" -NotePropertyValue "#0a1a3d" -Force
        }
        "needs-input" {
            # Violet-pink — permission prompt, question, or elicitation
            $profile | Add-Member -NotePropertyName "background" -NotePropertyValue "#3d0a2e" -Force
            [Console]::Beep(800, 150)
            Start-Sleep -Milliseconds 80
            [Console]::Beep(800, 150)
        }
        "finished" {
            # Emerald — task complete, waiting for new prompt
            $profile | Add-Member -NotePropertyName "background" -NotePropertyValue "#0a3d1a" -Force
            [Console]::Beep(600, 100)
        }
        "idle" {
            # Default — session open, no active task
            $profile.PSObject.Properties.Remove("background")
        }
    }

    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($wtSettings, ($json | ConvertTo-Json -Depth 20), $utf8NoBom)
} catch {
    exit 0
}
