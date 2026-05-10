# Pair Trader (Bloomberg EMSX automation)

Trading infrastructure project: **paired cross-border quoting** bridged Python OOP orchestration talking to Bloomberg **EMSX**.

## Problem

Operate an electronic pair-spread/strategy relying on streaming **ticks**, deterministic **risk controls**, and fast **OMS** callbacks under Windows production constraints.

## Outcome narrative

Purpose-built prototype delivered in ~**5 months** while learning Python: combined **algo layer**, concurrent **workers**, **`wx` GUI**, and logging suitable for deskside rollout (compiled **`exe`** pattern so modules could inhabit shared or segmented servers).

## Architecture (conceptual modules)

| Module | Responsibility |
|--------|----------------|
| **`market_date_server`** | Subscribe to realtime market payloads; hydrate strategy layer. |
| **`order_management`** | Route orders ↔ **EMSX**, manage callbacks/session flow. |
| **`pair_trader`** | Pricing / FX overlays, thresholds, sequencing both legs per strategy enums. |
| **`GUI_trader`** | Operator UI wiring into **`pair_trader`**. |

## Tech & constraints snapshot

Bloomberg **`win32com`**, **`wx`/pubsub threading**, audible alerts, granular logging for desk audit.

**Platform truth:** archival code targets **Bloomberg-hosted Windows workstations** (`win32com`, `wx`, etc.). Porting is **non-trivial** and not expected on macOS/Linux.

> Code refresh (requirements, pinning, modernization) intentionally deferred—the repo documents **architecture + domain depth** rather than plug-and-play open-source runtime.
