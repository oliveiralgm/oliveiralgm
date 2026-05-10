# HOVER jobs forecast

Operational demand forecasting project: estimate **annual job (# of jobs)** mix for HOVER (**roof-only vs complete models**) with an eye toward **weather-driven uplift**.

## Problem

Finance and ops needed directional **2019 expectations** framed as:

- Total expected **job volume**.
- Split between **job types**.
- Contribution linked to **weather events** (`weather.csv` joins to `jobs.csv` timing in scripts).

## Data & tooling

Historic **jobs** uploads and complementary **weather** series (referenced in notebooks/scripts as `jobs.csv`, `weather.csv`). Stack in this artifact is **pandas**, **numpy**, **scikit-learn**, **keras** / deep learning notebooks, **`statsmodels`**, **`matplotlib`**, **`ssl`** for data pulls where applicable.

> **Portfolio note:** source CSVs stay private or local to the original workspace; reproducibility wrappers will ship later—this README documents intent and analytical structure only.

## What’s in this folder

- **`LSTM_Stacked.py`**, **`GLMLagModel.py`**, **`ForecastModels.py`**, **`Plots.py`** — model exploration, evaluation, plotting for slide decks (**San Francisco**, **April 2019** cohort presentation).

See file headers for the exact business questions each pass answers.
