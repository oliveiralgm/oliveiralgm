# Intercom funnel analysis

**Marketing funnel diagnostics** on Intercom SaaS signup → trial → customer flows (AI/support messaging software space).

## Problem

Understand **conversion timing** and segmentation between **signup**, **trial start**, **first invoice** (paid customer markers in export), noisy dates between CRM + product systems.

## Data

Tab-delimited export consumed as **`data.csv`** locally (pandas `read_csv(..., delimiter="\t")`). Feature engineering derives **trial vs customer cycle times**, cohorting by **lead type / year-month**, exploratory frequency tables routed to **`MktFunnel.txt`** when using shell redirection noted in-script.

> **Portfolio note:** the raw export is omitted for privacy—this snapshot keeps the methodological trace.

## Approach (high level)

- Datetime coercion + anomaly handling (**invoice-before-signup cleaned** toward initial lead attribution).
- Cohort slicing for **trial vs paid** narratives.
- Plots surfaced with **pandas + matplotlib**.

Entry point historically: `python Funnel Analysis.py >> MktFunnel.txt` (**note the script filename spacing** mirrors the archival asset).
