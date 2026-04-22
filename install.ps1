# Installs claude-code-kit into $env:USERPROFILE\.claude\.
# - Copies agents, skills, statusline, and terminal-notify scripts.
# - Installs settings.template.json as settings.json only if you don't already
#   have one (never overwrites).

$ErrorActionPreference = "Stop"

$root   = Split-Path -Parent $MyInvocation.MyCommand.Path
$target = if ($env:CLAUDE_HOME) { $env:CLAUDE_HOME } else { Join-Path $env:USERPROFILE ".claude" }

Write-Host "Installing into $target"

New-Item -ItemType Directory -Force -Path (Join-Path $target "agents") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $target "skills") | Out-Null

function Copy-Dir($src, $dst) {
    Get-ChildItem -Path $src | ForEach-Object {
        $destPath = Join-Path $dst $_.Name
        if (Test-Path $destPath) {
            Write-Host "  = $destPath (already exists -- overwriting)"
            Remove-Item -Recurse -Force $destPath
        } else {
            Write-Host "  + $destPath"
        }
        Copy-Item -Recurse -Force $_.FullName $destPath
    }
}

Copy-Dir (Join-Path $root ".claude\agents") (Join-Path $target "agents")
Copy-Dir (Join-Path $root ".claude\skills") (Join-Path $target "skills")

foreach ($f in @("statusline-command.sh", "terminal-notify.js", "terminal-notify.ps1")) {
    $dest = Join-Path $target $f
    Write-Host "  + $dest"
    Copy-Item -Force (Join-Path $root ".claude\$f") $dest
}

$settings = Join-Path $target "settings.json"
if (Test-Path $settings) {
    Write-Host ""
    Write-Host "NOTE: $settings already exists -- skipping template install."
    Write-Host "      Compare against $root\.claude\settings.template.json manually."
} else {
    Copy-Item -Force (Join-Path $root ".claude\settings.template.json") $settings
    Write-Host "  + $settings (from template)"
}

Write-Host ""
Write-Host "Done. Next steps:"
Write-Host "  1. Install plugins listed in docs/plugins.md (superpowers, frontend-design, code-simplifier)."
Write-Host "  2. Restart Claude Code."
