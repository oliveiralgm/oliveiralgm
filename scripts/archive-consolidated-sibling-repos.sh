#!/usr/bin/env bash
set -euo pipefail

# Archive the standalone repos that now live under projects/ (not the umbrella README repo).
#
# Prerequisites:
# - export GITHUB_TOKEN="..."   classic PAT with "repo" scope (or sufficient fine-grained perms),
#   or: export GH_TOKEN="..."
#
# https://docs.github.com/en/rest/repos/repos#update-a-repository

OWNER="${GITHUB_OWNER:-oliveiralgm}"
TOKEN="${GITHUB_TOKEN:-${GH_TOKEN:-}}"

if [[ -z "${TOKEN}" ]]; then
  echo "Missing GITHUB_TOKEN (or GH_TOKEN)." >&2
  echo "Create a token at https://github.com/settings/tokens with repo scope, then export it." >&2
  exit 1
fi

REPOS=(
  cluster_and_deep_learning_R
  data_challenge
  heartfailure_readmissions
  HOVER_jobs_forecast
  Intercom_Funnel_analysis
  pair_trader
  podcast-project
  resume
  sql-projects
)

errs=0
for r in "${REPOS[@]}"; do
  echo "Archiving ${OWNER}/${r} ..."
  code="$(
    curl -sS -o "${TMPDIR:-/tmp}/gh_archive_${r}.json" -w "%{http_code}" \
      -X PATCH \
      -H "Authorization: Bearer ${TOKEN}" \
      -H "Accept: application/vnd.github+json" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      "https://api.github.com/repos/${OWNER}/${r}" \
      -d '{"archived":true}'
  )"

  if [[ "${code}" == "200" ]]; then
    echo "  OK"
  else
    echo "  FAILED (HTTP ${code})" >&2
    sed 's/^/    /' "${TMPDIR:-/tmp}/gh_archive_${r}.json" >&2 || true
    errs=$((errs + 1))
  fi
done

if [[ "${errs}" -gt 0 ]]; then
  echo "Completed with ${errs} error(s)." >&2
  exit 1
fi

echo "All listed repositories archived (or confirmed via API)."
exit 0
