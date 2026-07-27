# Gustavo Oliveira

Sr Staff Data Analyst at [Achieve](https://www.achieve.com).

Principal level analyst and analytics engineer in consumer lending. I architected the BI platform my organization runs on, a single containerized application that mounts dashboards on discovery, promotes itself across environments, and holds up under Kubernetes. Underneath it I define the metric contracts that keep team level and individual level numbers agreeing, lead the migration of legacy data lake views onto standardized warehouse tables, and set the statistical bar for what leadership is allowed to conclude from a segment comparison. I stay hands on in SQL, Python, and product design, and I write the specs that turn my blockers into cross-functional work other teams can act on.

Most day-to-day work lives in private company repos. The public lead project below is an architecture demo of that platform pattern (auto-mount Dash monolith, metric-style mock dashboards, adoption telemetry, experiment modernization). Mock data only; not Achieve production code.

[LinkedIn](https://www.linkedin.com/in/oliveiralgm/) · oliveiralgm@gmail.com

## Open source project

**[Symantica](https://github.com/symantica/symantica)** - Open source project I started. A semantic compiler for analytics and BI: it compiles metric definitions and analytical behaviors into a deterministic query plan and view model, which can be rendered into multiple dashboard runtimes. I have not been able to work on it for a while.

## Lead project

| Repo | What it shows |
|------|----------------|
| **[bi-monolith-demo](https://github.com/oliveiralgm/bi-monolith-demo)** | Staff analytics platform demo: Flask/Dash auto-discovery mounting, consumer funnel (application to funding), experiment / A/B readout (Tableau to Dash spirit), platform adoption (DAU, peak users, per-dashboard). Public playground mode for hosted samples; contact for the full suite / access key. |

**Live playground:** [https://bi-monolith-demo.onrender.com/](https://bi-monolith-demo.onrender.com/)

## What I care about

- **Metrics and definitions** that stay consistent across product, finance, and ops
- **Foundations** people can query without tribal knowledge (warehouse models, clear grain, documented assumptions)
- **Internal tools** that turn analysis into something teams actually use
- **AI-assisted analytics** when it speeds up exploration without hiding the logic

## Earlier public samples

Older portfolio pieces (not the current Staff story):

| Repo | What it shows |
|------|----------------|
| [Intercom_Funnel_analysis](https://github.com/oliveiralgm/Intercom_Funnel_analysis) | Earlier funnel conversion notebook (pandas / matplotlib) |
| [HOVER_jobs_forecast](https://github.com/oliveiralgm/HOVER_jobs_forecast) | Earlier demand forecasting sample |
| [pair_trader](https://github.com/oliveiralgm/pair_trader) | Multi-process trading system over Bloomberg EMSX |

## About private vs public work

For Staff / Senior Analytics Engineer reviews, the strongest signal is recent platform and metrics work at Achieve, plus the [bi-monolith-demo](https://github.com/oliveiralgm/bi-monolith-demo) architecture sample. Happy to walk through design tradeoffs in conversation.
