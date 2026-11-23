#!/usr/bin/env bash
# One-shot: commit, push to GitHub (Codex-Lever/sni-site), deploy to Vercel, attach sni.codexlever.com.
# Safe to re-run: every step is idempotent.
set -euo pipefail
cd "$(dirname "$0")"
REPO="Codex-Lever/sni-site"
PROJECT="sni-site"
DOMAIN="sni.codexlever.com"

say(){ printf '\n\033[1;32m▸ %s\033[0m\n' "$*"; }

say "git: commit"
[ -d .git ] || git init -b main
git add -A
git diff --cached --quiet || git commit -q -m "SNI live demos site (Live Lab + Reader), light theme, self-hosted Pyodide

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01BuNGvRDu3gPqd8NkGD2kzy"
git log --oneline -1

say "GitHub: $REPO"
if ! git remote get-url origin >/dev/null 2>&1; then
  if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    gh repo view "$REPO" >/dev/null 2>&1 || gh repo create "$REPO" --public \
      --description "Live, in-browser demos of Synthetic Neurodynamic Intelligence (SNI) — sni.codexlever.com" \
      --homepage "https://$DOMAIN"
  else
    echo "gh CLI not available: create an EMPTY repo named 'sni-site' at"
    echo "  https://github.com/organizations/Codex-Lever/repositories/new"
    read -r -p "…then press Enter to continue " _
  fi
  git remote add origin "git@github.com:$REPO.git"
fi
git push -u origin main

say "Vercel: link + production deploy"
vercel link --yes --project "$PROJECT"
vercel git connect --yes >/dev/null 2>&1 && echo "connected GitHub repo for auto-deploys" || echo "(git connect skipped — can be done in the dashboard)"
URL=$(vercel deploy --prod --yes)
echo "deployed: $URL"

say "Domain: $DOMAIN"
vercel domains add "$DOMAIN" "$PROJECT" || echo "(domain may already be attached)"
vercel domains inspect codexlever.com 2>&1 | sed -n '1,25p' || true

say "Check"
sleep 5
for p in / /lab/ /reader/ /py/pyodide.asm.wasm; do
  printf '%-24s ' "$p"; curl -s -o /dev/null -w '%{http_code}  %{content_type}\n' "https://$DOMAIN$p" || echo "not yet"
done
echo; echo "Done → https://$DOMAIN"
