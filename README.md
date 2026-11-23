# SNI — live research demos

Static site for **Synthetic Neurodynamic Intelligence** (SNI), the flagship program of [CodexLever](https://github.com/Codex-Lever).
Deployed at **https://sni.codexlever.com**.

| Path | Demo |
|---|---|
| `/` | Landing page |
| `/lab/` | **SNI Live Lab** — teach a brain words with ±1; it asks when unsure, answers in hops with a readable trace, and lets you cut one memory. Frozen GloVe perception; all learning in SNI. |
| `/reader/` | **SNI Reader** — letters-up: no pretrained vectors; grows its own word meanings by reading, five typed "I don't understand" signals, fast mapping, relation proposals. |

Both demos run the **unmodified Python research engine** in the browser with [Pyodide](https://pyodide.org) 0.27.7, self-hosted under `/py/` (no CDN at runtime).

## How it is built
The pages and their bundles are generated from the research repository [`Codex-Lever/sni-pocs`](https://github.com/Codex-Lever/sni-pocs) (`v1/lab/web/build.py`, `v1/lex/web/build.py`); this repo holds the built static output plus the light-theme site shell. Nothing here learns on a server: everything runs client-side.

- `lab/bundle.json`, `reader/bundle.json` — engine sources (`sni/`, `lex/`, …) and data the page writes into Pyodide's file system.
- `lab/vectors.json` — frozen GloVe-100 table (20,207 words, int8) and its 2-D display map.
- `*/bench.json`, `reader/reader_bench.json` — exploratory benchmark results shown on the pages (not pre-registered; see the notes in `sni-pocs`).
- `py/` — Pyodide runtime, NumPy and PyYAML wheels.

## Deploy
```bash
vercel --prod          # project: sni-site; domain: sni.codexlever.com
```

## Licences
Pyodide MPL-2.0 · NumPy BSD-3 · GloVe vectors PDDL 1.0 · books public domain (Project Gutenberg via NLTK) · SNI code © CodexLever.
