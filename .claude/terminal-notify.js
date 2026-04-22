// Claude Code notification hook — Windows Terminal background color per session state.
//
// States: working (blue), needs-input (pink), finished (green), idle (reset).
// Reads $WT_PROFILE_ID to identify the current tab's Windows Terminal profile,
// writes to WT's settings.json, which hot-reloads automatically.
//
// By default, this applies to ANY Windows Terminal profile. To restrict it to
// specific profiles (so your default terminal doesn't change colors), set
// $CLAUDE_KIT_WT_PROFILES to a comma-separated list of profile GUIDs (with
// braces), e.g.
//   CLAUDE_KIT_WT_PROFILES="{c1a0de01-...-000001},{c1a0de01-...-000002}"

const fs = require("fs");
const path = require("path");

const state = process.argv[2];
if (!state) process.exit(0);

const profileId = process.env.WT_PROFILE_ID;
if (!profileId) process.exit(0);

const allowlist = (process.env.CLAUDE_KIT_WT_PROFILES || "")
  .split(",")
  .map((s) => s.trim())
  .filter(Boolean);
if (allowlist.length && !allowlist.includes(profileId)) process.exit(0);

const colors = {
  working: "#0a1a3d",
  "needs-input": "#3d0a2e",
  finished: "#0a3d1a",
};

const stateFile = path.join(
  process.env.HOME || process.env.USERPROFILE,
  ".claude",
  `notify-state-${profileId.replace(/[{}]/g, "")}.txt`
);

let skipColorUpdate = false;
try {
  const lastState = fs.existsSync(stateFile)
    ? fs.readFileSync(stateFile, "utf8").trim()
    : "";
  if (lastState === state) {
    skipColorUpdate = true;
  } else {
    fs.writeFileSync(stateFile, state);
  }
} catch {}

if (skipColorUpdate) process.exit(0);

const wtSettings = path.join(
  process.env.LOCALAPPDATA || "",
  "Packages",
  "Microsoft.WindowsTerminal_8wekyb3d8bbwe",
  "LocalState",
  "settings.json"
);

if (!fs.existsSync(wtSettings)) process.exit(0);

try {
  let raw = fs.readFileSync(wtSettings, "utf8");
  if (raw.charCodeAt(0) === 0xfeff) raw = raw.slice(1);
  const json = JSON.parse(raw);
  const profile = json.profiles.list.find((p) => p.guid === profileId);
  if (!profile) process.exit(0);

  const newColor = colors[state] || null;
  let changed = false;
  if (state === "idle") {
    if (profile.background) {
      delete profile.background;
      changed = true;
    }
  } else if (newColor && profile.background !== newColor) {
    profile.background = newColor;
    changed = true;
  }

  if (changed) {
    fs.writeFileSync(wtSettings, JSON.stringify(json, null, 4), {
      encoding: "utf8",
      flush: true,
    });
  }
} catch {}
