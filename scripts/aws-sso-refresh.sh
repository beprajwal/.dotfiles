#!/bin/zsh
# Keep AWS SSO credentials warm all day.
#
# Each AWS SSO session has a short-lived access token (hours) AND a long-lived
# refresh token (tied to registrationExpiresAt, ~months). The AWS CLI silently
# mints a fresh access token from the refresh token whenever credentials are
# resolved -- NO browser needed. A plain `sts get-caller-identity` triggers
# that refresh. A browser login (`aws sso login`) is only needed when the
# refresh token / client registration has expired or been revoked.
#
# Modes:
#   (default)      silent refresh only; on failure, send a macOS notification.
#                  Used by the launchd agent so it never opens a browser tab
#                  while you're away.
#   --interactive  silent refresh; on failure, open the browser to log in.
#                  Used from .zshrc, since you're present at the terminal.

emulate -L zsh
setopt pipe_fail

command -v aws >/dev/null 2>&1 || exit 0

INTERACTIVE=0
[[ "$1" == "--interactive" ]] && INTERACTIVE=1

# profile : sso-session  (one profile per session; profile is what sts checks)
typeset -A SESSIONS
SESSIONS=(
  krane-dev   krane-dev
  krane-prod  krane
  krane-exps  krane-exps
)

notify() {
  local msg="$1"
  if command -v osascript >/dev/null 2>&1; then
    osascript -e "display notification \"$msg\" with title \"AWS SSO\"" >/dev/null 2>&1
  fi
  print -r -- "aws-sso: $msg"
}

for profile session in ${(kv)SESSIONS}; do
  lock="${TMPDIR:-/tmp}/aws-sso-refresh-${session}.lock"
  # mkdir is atomic: if another run (shell start + launchd) is already handling
  # this session, skip it.
  mkdir "$lock" 2>/dev/null || continue
  trap "rmdir '$lock' 2>/dev/null" EXIT INT TERM

  # Silent: resolves creds, refreshing the access token via the refresh token
  # if needed. Succeeds with no browser as long as the refresh token is valid.
  if aws sts get-caller-identity --profile "$profile" >/dev/null 2>&1; then
    : # warm, nothing to do
  elif (( INTERACTIVE )); then
    print -r -- "aws-sso: '$session' needs browser login, opening…"
    aws sso login --sso-session "$session" >/dev/null 2>&1
  else
    notify "session '$session' needs browser login — run: aws sso login --sso-session $session"
  fi

  rmdir "$lock" 2>/dev/null
done
