# Podcast transcription + search prototype

Demonstration stack for **speech-to-text**, **filesystem indexing**, and **keyword/BM25-style search** atop podcast artifacts.

## Problem

Operationalize exploratory search over long-form conversational audio by combining **automatic transcription persistence** (`pydub` segmentation, **`speech_recognition`** ASR backends) plus **Whoosh** index for lexical lookup.

## What lives here

- **`TranscribeFile.py`** — offline transcription ingest path.
- **`TextSearchEngine.py`** — textual index + querying (`whoosh`).
- Media artifacts (**`.wav`**, **`.docx`**) illustrating real desk samples (**large blobs** cloned into archive for fidelity).

## Portfolio note on assets

Heavy media inflate clone size intentionally for portfolio completeness; swapping to **sample clips** trimmed + ignored by git is a later hygiene improvement.
