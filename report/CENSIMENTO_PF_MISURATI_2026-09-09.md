# 🔬 CENSIMENTO DEI PROFIT FACTOR MISURATI — 09/09/2026

**Costruito SOLO sui CSV del tester.** Nessun numero viene dai referti `.md`, nessun
numero e' stimato o arrotondato "a occhio". Dove il dato non esiste nei CSV c'e' scritto
`[NON MISURATO]` e basta.

- Sorgente: `backtest_pipeline/risultati_archivio/`, `backtest_pipeline/risultati_prove/`, `backtest_pipeline/prove/`
- Script rifacibile: `backtest_pipeline/censimento_pf.py` (rimacina i CSV) + `backtest_pipeline/censimento_pf_referto.py` (riscrive questo referto)
- CSV grezzo aggregato: `backtest_pipeline/risultati_archivio/CENSIMENTO_PF_TUTTI_2026-09-09.csv`

## 📐 COME SONO STATI CALCOLATI I NUMERI (regole dichiarate)

1. **Cella MEDIANA** = si ordinano TUTTE le passate della corsa per Profit Factor e si
   prende quella centrale (per numero pari di passate: quella immediatamente SOTTO la
   meta'). `Trades`, `Equity DD %` e `Profit` riportati sono **quelli di QUELLA passata**,
   non medie di comodo. E' la regola di casa: *centro dell'altopiano, MAI il picco*.
2. **Cella MIGLIORE (picco)** = passata con PF massimo. E' riportata **accanto** alla
   mediana proprio perche' da sola mente: se picco e mediana divergono di molto, quella
   corsa e' rumore, non altopiano.
2bis. **Le passate con ESITO IDENTICO contano UNA volta.** 874 CSV su 1960 contengono passate
   che ripetono lo stesso `Profit`/`PF`/`Trades`/`DD`: sono **parametri inerti** — la griglia
   ha mosso una manopola che non cambia niente. Esempio misurato:
   `Aperture_Ingresso/DAX_ingresso.csv` ha **160 passate ma solo 20 esiti distinti**.
   Contarle tutte sposterebbe la mediana **senza che nessuna misura sia cambiata**, quindi
   mediana e picco si calcolano sugli **esiti distinti**; la colonna `pass` mostra entrambi
   i numeri quando divergono (`160 (20 uniche)`), cosi' il collasso si vede.
3. **Le passate con `Trades = 0` sono ESCLUSE dalle statistiche.** Regola di casa:
   `Trades = 0` NON e' "nessun edge", e' **"non e' girata"**. Sono contate a parte.
4. **Parser numerico**: accetta punto E virgola decimale (anche `1.234,56`); le righe non
   numeriche vengono scartate e contate.
5. **TF**: dedotto in quest'ordine — (a) token nel nome file, (b) colonna `InpTF` se ha un
   valore unico (enum MQL5 -> M1/M5/M15/M30/H1/H4/D1), (c) nome cartella. Se `InpTF` era
   **ottimizzato** su piu' valori la cella dice `TF-OTT` (il TF non e' UNO). Altrimenti `[NON MISURATO]`.
6. **`VICINO ALLA SOGLIA?` = SI** quando **PF OOS della cella mediana >= 0,90** (entro il
   20% dalla soglia di casa 1,10) **E** `n >= 100`, dove **n = Trades della cella mediana OOS**
   (l'unita' di misura del progetto e' l'OPERAZIONE, non la passata). Se manca l'OOS: `[NON MISURATO]`.

## 🔢 I CONTEGGI

| Cosa | Quanti |
|---|---|
| CSV totali visti nelle cartelle sorgente | 2271 |
| CSV **di risultati** (intestazione con `Profit Factor` + `Trades`) | **2069** |
| CSV NON di risultati (tick, deal, sonde, calendari...) — ignorati | 202 |
| CSV di risultati effettivamente **usati** | **1960** |
| CSV **scartati perche' TUTTE le passate hanno `Trades = 0`** ("non e' girata") | **109** |
| CSV illeggibili / con la sola intestazione | 0 |
| Passate singole con `Trades = 0` escluse dentro CSV altrimenti validi | 15143 |
| CSV con almeno una passata a `Trades = 0` | 603 |
| CSV con **passate a esito identico** (parametri inerti nella griglia) | **874** |
| **Cartelle di corsa distinte ("round")** | **148** |
| Righe del censimento = coppie (motore, simbolo, TF, etichetta, cartella) | **1558** |
| ...di cui **con una finestra OOS misurata** | **430** |
| ...di cui **senza OOS** (solo IS, o finestra unica/regime) | 1128 |
| 🟢 Righe **VICINO ALLA SOGLIA = SI** | **127** |

> ⚠️ **"Round" qui = cartella di risultati, non numero di round del registro.** Le cartelle
> sono 148 e non coincidono uno-a-uno con gli R-numeri (alcuni round hanno piu' cartelle,
> alcune cartelle raccolgono piu' round). Il numero degli R-numeri sta nei referti, che qui
> **non sono stati letti apposta**: questo censimento e' costruito solo sui numeri.

---

## 🟢 TABELLA A — I 127 CANDIDATI "VICINO ALLA SOGLIA" (PF OOS mediano >= 0,90 e n >= 100)

Questi sono quelli che **vale la pena riaprire**: hanno un OOS vero, un campione che regge
(>= 100 operazioni nella cella mediana) e stanno entro il 20% dalla soglia 1,10.
Ordinati per **PF OOS della cella mediana, decrescente**.

| Motore | Simbolo | TF | Etichetta/Round | Cartella | pass IS | PF med IS | PF picco IS | Trades IS | DD% IS | Profit IS | pass OOS | PF med OOS | PF picco OOS | Trades OOS | DD% OOS | Profit OOS | VICINO ALLA SOGLIA? |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Live5m | NASDAQ | [NON MISURATO] | NASUSD_ohlc | backtest_pipeline/risultati_prove/ABTG_Nasdaq_Live5m | 2 (1 uniche) | 1.37 | 1.37 | 125 | 8.01 | 2404 | 2 (1 uniche) | 2.16 | 2.16 | 198 | 7.31 | 8944 | SI |
| EMA200 | U30USD | H1 | 02_short | backtest_pipeline/prove/R110_CSV_EMADOW | 2 (1 uniche) | 1.23 | 1.23 | 125 | 4.51 | 2607 | 2 (1 uniche) | 1.89 | 1.89 | 302 | 2.66 | 16948 | SI |
| EMA200 | U30USD | H1 | 01_short_r1 | backtest_pipeline/risultati_archivio/R112_CORSA_20260826 | 2 (1 uniche) | 1.23 | 1.23 | 125 | 4.51 | 2607 | 2 (1 uniche) | 1.89 | 1.89 | 302 | 2.66 | 16948 | SI |
| EMA200 | U30USD | H1 | 01_short_r1 | backtest_pipeline/risultati_archivio/R112_PARZIALE_20260826 | 2 (1 uniche) | 1.23 | 1.23 | 125 | 4.51 | 2607 | 2 (1 uniche) | 1.89 | 1.89 | 302 | 2.66 | 16948 | SI |
| EMA200 | U30USD | H1 | 02_short_r2 | backtest_pipeline/risultati_archivio/R112_CORSA_20260826 | 2 (1 uniche) | 1.22 | 1.22 | 127 | 8.90 | 5075 | 2 (1 uniche) | 1.89 | 1.89 | 315 | 5.30 | 36527 | SI |
| EMA200 | U30USD | H1 | 02_short_r2 | backtest_pipeline/risultati_archivio/R112_PARZIALE_20260826 | 2 (1 uniche) | 1.22 | 1.22 | 127 | 8.90 | 5075 | 2 (1 uniche) | 1.89 | 1.89 | 315 | 5.30 | 36527 | SI |
| EMA200 | U30USD | H1 | 03_short_r3 | backtest_pipeline/risultati_archivio/R112_CORSA_20260826 | 2 (1 uniche) | 1.21 | 1.21 | 128 | 13.17 | 7434 | 2 (1 uniche) | 1.87 | 1.87 | 324 | 7.92 | 58567 | SI |
| EMA200 | U30USD | H1 | 03_short_r3 | backtest_pipeline/risultati_archivio/R112_PARZIALE_20260826 | 2 (1 uniche) | 1.21 | 1.21 | 128 | 13.17 | 7434 | 2 (1 uniche) | 1.87 | 1.87 | 324 | 7.92 | 58567 | SI |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | r44a | backtest_pipeline/risultati_prove/ABTG_ORB_Ottimizzato/r44 | 4 | 1.29 | 1.36 | 71 | 9.13 | 1158 | 4 | 1.74 | 1.95 | 119 | 11.04 | 4677 | SI |
| SupertrendReversal_Multi_Ottimizzato | XAUUSD | H4 | r3 | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal_Multi_Ottimizzato | 5 | 1.25 | 4.51 | 11 | 2.14 | 54 | 5 | 1.71 | 2.98 | 105 | 5.79 | 1664 | SI |
| Live5m | DAX | [NON MISURATO] | v2_D30EUR_ohlc | backtest_pipeline/risultati_prove/ABTG_DAX_Live5m_v2 | 2 (1 uniche) | 1.32 | 1.32 | 84 | 4.85 | 595 | 2 (1 uniche) | 1.71 | 1.71 | 211 | 6.17 | 2958 | SI |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | ANCORA | backtest_pipeline/risultati_archivio/ancora_passo7 | 2 (1 uniche) | 1.23 | 1.23 | 71 | 5.65 | 569 | 2 (1 uniche) | 1.67 | 1.67 | 119 | 6.54 | 2484 | SI |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | R119_D0000 | backtest_pipeline/risultati_archivio/ritardo_r119_csv | 2 (1 uniche) | 1.23 | 1.23 | 71 | 5.65 | 569 | 2 (1 uniche) | 1.67 | 1.67 | 119 | 6.54 | 2484 | SI |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | R119_D0500 | backtest_pipeline/risultati_archivio/ritardo_r119_csv | 2 (1 uniche) | 1.23 | 1.23 | 71 | 5.65 | 569 | 2 (1 uniche) | 1.67 | 1.67 | 119 | 6.54 | 2484 | SI |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | R119_D0000 | backtest_pipeline/risultati_archivio/ritardo_r119b_csv | 2 (1 uniche) | 1.23 | 1.23 | 71 | 5.65 | 569 | 2 (1 uniche) | 1.67 | 1.67 | 119 | 6.54 | 2484 | SI |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | R119_D0050 | backtest_pipeline/risultati_archivio/ritardo_r119b_csv | 2 (1 uniche) | 1.23 | 1.23 | 71 | 5.65 | 569 | 2 (1 uniche) | 1.67 | 1.67 | 119 | 6.54 | 2484 | SI |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | R119_D0100 | backtest_pipeline/risultati_archivio/ritardo_r119b_csv | 2 (1 uniche) | 1.23 | 1.23 | 71 | 5.65 | 569 | 2 (1 uniche) | 1.67 | 1.67 | 119 | 6.54 | 2484 | SI |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | R119_D0500 | backtest_pipeline/risultati_archivio/ritardo_r119b_csv | 2 (1 uniche) | 1.23 | 1.23 | 71 | 5.66 | 567 | 2 (1 uniche) | 1.67 | 1.67 | 119 | 6.54 | 2484 | SI |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | r88c | backtest_pipeline/risultati_archivio/r88_csv | 4 (2 uniche) | 1.15 | 1.25 | 74 | 7.93 | 6215 | 4 (2 uniche) | 1.67 | 1.69 | 119 | 9.76 | 41057 | SI |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | r55b | backtest_pipeline/risultati_archivio/csv_r55 | 10 (5 uniche) | 1.19 | 1.25 | 71 | 8.29 | 7452 | 10 (5 uniche) | 1.62 | 1.67 | 119 | 9.95 | 38271 | SI |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | r118a | backtest_pipeline/risultati_archivio/r118_csv | 25 | 1.01 | 1.25 | 71 | 7.53 | 255 | 25 | 1.57 | 1.67 | 119 | 7.57 | 26637 | SI |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | r88a | backtest_pipeline/risultati_archivio/r88_csv | 48 (24 uniche) | 1.04 | 1.48 | 71 | 6.98 | 1173 | 48 (24 uniche) | 1.55 | 1.84 | 119 | 8.05 | 28466 | SI |
| EMA200 | U30USD | H1 | 00_metro | backtest_pipeline/prove/R110_CSV_EMADOW | 2 (1 uniche) | 1.20 | 1.20 | 237 | 5.73 | 4585 | 2 (1 uniche) | 1.52 | 1.52 | 517 | 7.83 | 23321 | SI |
| EMA200 | U30USD | H1 | 00_metro | backtest_pipeline/risultati_archivio/R112_CORSA_20260826 | 2 (1 uniche) | 1.20 | 1.20 | 237 | 5.73 | 4585 | 2 (1 uniche) | 1.52 | 1.52 | 517 | 7.83 | 23321 | SI |
| EMA200 | U30USD | H1 | 00_metro | backtest_pipeline/risultati_archivio/R112_PARZIALE_20260826 | 2 (1 uniche) | 1.20 | 1.20 | 237 | 5.73 | 4585 | 2 (1 uniche) | 1.52 | 1.52 | 517 | 7.83 | 23321 | SI |
| EMA200 | U30USD | H1 | r31 | backtest_pipeline/risultati_prove/ABTG_EMA200 | 2 (1 uniche) | 1.20 | 1.20 | 237 | 5.73 | 4585 | 2 (1 uniche) | 1.52 | 1.52 | 517 | 7.83 | 23321 | SI |
| EMA200 | U30USD | H1 | r29b | backtest_pipeline/risultati_prove/ABTG_EMA200 | 30 | 1.21 | 1.33 | 211 | 5.30 | 434 | 30 | 1.52 | 1.61 | 438 | 7.22 | 2136 | SI |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_r47b | backtest_pipeline/risultati_prove/aperture_r47 | 2 (1 uniche) | 1.18 | 1.18 | 132 | 4.96 | 5569 | 2 (1 uniche) | 1.49 | 1.49 | 193 | 6.27 | 23607 | SI |
| Live5m | DAX | [NON MISURATO] | D30EUR_ohlc | backtest_pipeline/risultati_prove/ABTG_DAX_Live5m | 2 (1 uniche) | 1.27 | 1.27 | 228 | 18.77 | 2633 | 2 (1 uniche) | 1.47 | 1.47 | 352 | 11.83 | 8970 | SI |
| PTE | GBPUSD | H1 | ohlc_pte70gbp | backtest_pipeline/risultati_archivio/csv_R70 | 28 | 0.90 | 1.04 | 111 | 4.25 | -1018 | 28 (21 uniche) | 1.43 | 1.55 | 235 | 3.61 | 5523 | SI |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_R119_D0500 | backtest_pipeline/risultati_archivio/ritardo_r119b_csv | 2 (1 uniche) | 1.16 | 1.16 | 176 | 3.27 | 285 | 2 (1 uniche) | 1.42 | 1.42 | 270 | 4.31 | 1120 | SI |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_R119_D0100 | backtest_pipeline/risultati_archivio/ritardo_r119b_csv | 2 (1 uniche) | 1.15 | 1.15 | 175 | 3.19 | 281 | 2 (1 uniche) | 1.41 | 1.41 | 270 | 4.35 | 1109 | SI |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_R119_D0050 | backtest_pipeline/risultati_archivio/ritardo_r119b_csv | 2 (1 uniche) | 1.15 | 1.15 | 175 | 3.17 | 280 | 2 (1 uniche) | 1.41 | 1.41 | 270 | 4.35 | 1106 | SI |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_ANCORA | backtest_pipeline/risultati_archivio/ancora_passo7 | 2 (1 uniche) | 1.15 | 1.15 | 175 | 3.17 | 280 | 2 (1 uniche) | 1.41 | 1.41 | 270 | 4.35 | 1103 | SI |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_R119_D0000 | backtest_pipeline/risultati_archivio/ritardo_r119b_csv | 2 (1 uniche) | 1.15 | 1.15 | 175 | 3.17 | 280 | 2 (1 uniche) | 1.41 | 1.41 | 270 | 4.35 | 1103 | SI |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_r47a | backtest_pipeline/risultati_prove/aperture_r47 | 2 (1 uniche) | 1.13 | 1.13 | 175 | 5.44 | 3789 | 2 (1 uniche) | 1.40 | 1.40 | 270 | 7.23 | 18030 | SI |
| walkforward | DOW | [NON MISURATO] | Dow_Apertura | backtest_pipeline/risultati_archivio/Dow_Apertura | 40 | 1.28 | 1.55 | 140 | 6.33 | 1229 | 40 | 1.37 | 1.56 | 188 | 4.41 | 2008 | SI |
| Apertura | DOW | [NON MISURATO] | US_U30USD_r35 | backtest_pipeline/risultati_prove/aperture_r35 | 10 | 0.85 | 1.21 | 62 | 4.95 | -200 | 10 | 1.36 | 1.68 | 130 | 3.55 | 879 | SI |
| PTE | GBPUSD | H1 | ohlc_pte71gbp | backtest_pipeline/risultati_archivio/csv_R71 | 28 | 0.83 | 0.91 | 231 | 8.92 | -4767 | 28 (22 uniche) | 1.35 | 1.43 | 272 | 4.07 | 5066 | SI |
| SuperWave | DOW | H1 | Ottimizzato_U30USD_r3 | backtest_pipeline/risultati_prove/ABTG_SuperWave_DOW_H1_Ottimizzato | 5 | 1.44 | 1.85 | 75 | 4.77 | 675 | 5 | 1.33 | 1.61 | 143 | 3.91 | 463 | SI |
| SupertrendReversal_Multi_Ottimizzato | XAUUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal_Multi_Ottimizzato | 11 | 0.97 | 6825.88 | 22 | 3.60 | -14 | 11 | 1.30 | 11.43 | 819 | 13.74 | 7968 | SI |
| PTE | USDJPY | H1 | ohlc_pte70jpy | backtest_pipeline/risultati_archivio/csv_R70 | 28 | 0.89 | 0.97 | 121 | 4.86 | -1701 | 28 | 1.29 | 1.43 | 168 | 4.96 | 9341 | SI |
| Apertura | DOW | [NON MISURATO] | US_U30USD_r47c | backtest_pipeline/risultati_prove/aperture_r47 | 2 (1 uniche) | 1.22 | 1.22 | 74 | 5.67 | 2812 | 2 (1 uniche) | 1.27 | 1.27 | 130 | 4.39 | 6722 | SI |
| EMA200_Ottimizzato | XAUUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_EMA200_Ottimizzato | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 1.25 | 76.59 | 268 | 6.01 | 651 | SI |
| ORB | NASUSD | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_ORB | 2 (1 uniche) | 0.95 | 0.95 | 220 | 22.85 | -407 | 2 (1 uniche) | 1.25 | 1.25 | 357 | 11.77 | 2867 | SI |
| EMA200 | U30USD | H1 | 01_long | backtest_pipeline/prove/R110_CSV_EMADOW | 2 (1 uniche) | 1.16 | 1.16 | 112 | 2.64 | 1844 | 2 (1 uniche) | 1.24 | 1.24 | 241 | 8.90 | 5671 | SI |
| Apertura | DOW | [NON MISURATO] | US_U30USD_ptc | backtest_pipeline/risultati_prove/ABTG_Dow_Apertura_US | 12 (10 uniche) | 1.13 | 1.37 | 150 | 9.07 | 4084 | 12 (6 uniche) | 1.21 | 1.64 | 218 | 9.92 | 8439 | SI |
| Apertura | DOW | [NON MISURATO] | US_U30USD_r6 | backtest_pipeline/risultati_prove/ABTG_Dow_Apertura_US | 6 | 1.14 | 1.38 | 150 | 8.82 | 420 | 6 | 1.20 | 1.68 | 218 | 9.74 | 788 | SI |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_r118c | backtest_pipeline/risultati_archivio/r118_csv | 10 (9 uniche) | 1.07 | 1.11 | 70 | 4.61 | 70 | 10 (7 uniche) | 1.20 | 1.44 | 311 | 7.93 | 964 | SI |
| Apertura_3Ingressi | D30EUR | [NON MISURATO] | r83d1 | backtest_pipeline/risultati_archivio/r83_csv | 2 (1 uniche) | 1.08 | 1.08 | 197 | 7.03 | 282 | 2 (1 uniche) | 1.19 | 1.19 | 311 | 10.60 | 999 | SI |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_r83v | backtest_pipeline/risultati_archivio/r83_csv | 2 (1 uniche) | 1.08 | 1.08 | 197 | 7.03 | 282 | 2 (1 uniche) | 1.19 | 1.19 | 311 | 10.60 | 999 | SI |
| CrossEma | XAUUSD | [NON MISURATO] | r86coro | backtest_pipeline/risultati_archivio/r86_r87_r89_csv | 2 (1 uniche) | 1.11 | 1.11 | 84 | 10.92 | 620 | 2 (1 uniche) | 1.18 | 1.18 | 119 | 12.30 | 1344 | SI |
| PTE | USDJPY | H1 | ohlc_pte71jpy | backtest_pipeline/risultati_archivio/csv_R71 | 28 | 0.67 | 0.72 | 253 | 9.55 | -7293 | 28 | 1.18 | 1.31 | 189 | 8.50 | 6380 | SI |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | r14 | backtest_pipeline/risultati_prove/ABTG_ORB_Ottimizzato | 24 | 1.12 | 1.64 | 134 | 13.06 | 1045 | 24 | 1.17 | 1.40 | 119 | 17.04 | 1510 | SI |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | r15 | backtest_pipeline/risultati_prove/ABTG_ORB_Ottimizzato | 64 (62 uniche) | 0.99 | 1.64 | 107 | 5.07 | -19 | 64 (62 uniche) | 1.17 | 1.68 | 172 | 12.35 | 945 | SI |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_r51 | backtest_pipeline/risultati_archivio/csv_r51 | 4 (2 uniche) | 1.05 | 1.08 | 313 | 8.79 | 2763 | 4 (2 uniche) | 1.17 | 1.17 | 332 | 10.75 | 9062 | SI |
| F_gestione | DAX | [NON MISURATO] | Walkforward_Aperture | backtest_pipeline/risultati_archivio/Walkforward_Aperture | 8 (6 uniche) | 0.99 | 1.11 | 255 | 8.52 | -23 | 8 (6 uniche) | 1.16 | 1.29 | 230 | 11.65 | 834 | SI |
| PTE | GBPUSD | H1 | ohlc_tetto | backtest_pipeline/risultati_archivio/csv_R76 | 28 | 0.88 | 0.93 | 461 | 21.07 | -9372 | 28 | 1.16 | 1.25 | 655 | 8.96 | 7824 | SI |
| CrossEma | XAUUSD | [NON MISURATO] | r86doro | backtest_pipeline/risultati_archivio/r86_r87_r89_csv | 2 (1 uniche) | 0.92 | 0.92 | 171 | 13.97 | -768 | 2 (1 uniche) | 1.16 | 1.16 | 270 | 15.80 | 2431 | SI |
| SupertrendReversal_Multi_Ottimizzato | XAUUSD | TF-OTT | ABTG_SupertrendReversal_Multi_Ottimizzato | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal_Multi_Ottimizzato | 11 | 0.89 | 6831.75 | 22 | 3.66 | -56 | 11 | 1.14 | 8.43 | 882 | 18.48 | 3645 | SI |
| M_direzione | DAX | [NON MISURATO] | Walkforward_Aperture | backtest_pipeline/risultati_archivio/Walkforward_Aperture | 9 | 0.97 | 1.16 | 215 | 5.46 | -102 | 9 | 1.14 | 1.42 | 266 | 8.54 | 698 | SI |
| EMA200 | EURUSD | H1 | r29a | backtest_pipeline/risultati_prove/ABTG_EMA200 | 30 | 1.11 | 1.22 | 431 | 8.36 | 422 | 30 | 1.13 | 1.22 | 754 | 10.15 | 844 | SI |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | r88b | backtest_pipeline/risultati_archivio/r88_csv | 8 (5 uniche) | 0.73 | 1.25 | 116 | 20.29 | -15005 | 8 (5 uniche) | 1.12 | 1.67 | 136 | 11.96 | 9626 | SI |
| EMA200_Ottimizzato | XAUUSD | TF-OTT | ABTG_EMA200_Ottimizzato | backtest_pipeline/risultati_prove/ABTG_EMA200_Ottimizzato | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 1.12 | 2.53 | 292 | 8.23 | 343 | SI |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR | backtest_pipeline/risultati_prove/ABTG_DAX_Apertura_EU | 25 | 1.04 | 1.23 | 197 | 8.36 | 201 | 25 | 1.12 | 1.69 | 296 | 11.84 | 771 | SI |
| ORB_Ottimizzato | NASUSD | [NON MISURATO] | r44b | backtest_pipeline/risultati_prove/ABTG_ORB_Ottimizzato/r44 | 4 | 1.06 | 1.10 | 74 | 23.86 | 360 | 4 | 1.11 | 1.16 | 135 | 19.05 | 1306 | SI |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_r35 | backtest_pipeline/risultati_prove/aperture_r35 | 10 | 1.13 | 1.31 | 175 | 5.36 | 381 | 10 | 1.10 | 1.42 | 272 | 9.33 | 494 | SI |
| PTE | GBPUSD | H1 | ohlc_pte2 | backtest_pipeline/risultati_archivio/PTE_accoppiamento | 28 | 1.05 | 1.17 | 312 | 6.66 | 2179 | 28 | 1.10 | 1.21 | 477 | 8.53 | 3117 | SI |
| Apertura | DOW | [NON MISURATO] | US_U30USD_r54a | backtest_pipeline/risultati_archivio/csv_r54 | 6 (3 uniche) | 1.37 | 1.51 | 147 | 5.53 | 9461 | 6 (3 uniche) | 1.10 | 1.27 | 203 | 8.68 | 3927 | SI |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_ptd | backtest_pipeline/risultati_prove/ABTG_DAX_Apertura_EU | 360 (180 uniche) | 0.92 | 1.44 | 151 | 8.51 | -2530 | 360 (180 uniche) | 1.08 | 1.41 | 240 | 7.46 | 3745 | SI |
| PTE | GBPUSD | H1 | ohlc_pte1 | backtest_pipeline/risultati_archivio/PTE_accoppiamento | 32 | 0.97 | 1.17 | 282 | 9.52 | -1401 | 32 | 1.08 | 1.20 | 468 | 10.05 | 2734 | SI |
| PTE | USDJPY | H1 | ohlc_pte2jpy | backtest_pipeline/risultati_archivio/csv_R69 | 28 | 0.65 | 0.69 | 268 | 18.29 | -17529 | 28 | 1.06 | 1.17 | 307 | 15.27 | 4965 | SI |
| LVNArbitro | U30USD | [NON MISURATO] | P0_100K | backtest_pipeline/risultati_prove/ABTG_LVNArbitro | 2 (1 uniche) | 0.97 | 0.97 | 392 | 19.35 | -3375 | 2 (1 uniche) | 1.05 | 1.05 | 618 | 11.76 | 11311 | SI |
| LVNArbitro | U30USD | [NON MISURATO] | P0CONTA | backtest_pipeline/risultati_prove/ABTG_LVNArbitro | 2 (1 uniche) | 0.98 | 0.98 | 392 | 18.01 | -265 | 2 (1 uniche) | 1.05 | 1.05 | 618 | 11.33 | 1022 | SI |
| EMA200 | AUDJPY | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_EMA200 | 11 | 1.02 | 2.54 | 373 | 10.55 | 79 | 11 | 1.05 | 336.02 | 134 | 8.43 | 75 | SI |
| EMA200 | XAUUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_EMA200 | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 1.05 | 2.17 | 1189 | 14.80 | 554 | SI |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | r54b | backtest_pipeline/risultati_archivio/csv_r54 | 6 (3 uniche) | 0.96 | 1.25 | 135 | 11.48 | -2822 | 6 (3 uniche) | 1.05 | 1.67 | 219 | 17.16 | 5526 | SI |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | r88c3 | backtest_pipeline/risultati_archivio/r88_csv | 4 (2 uniche) | 0.83 | 0.91 | 66 | 8.76 | -5595 | 4 (2 uniche) | 1.05 | 1.06 | 123 | 12.61 | 2636 | SI |
| Apertura_3Ingressi | D30EUR | [NON MISURATO] | r83d0 | backtest_pipeline/risultati_archivio/r83_csv | 2 (1 uniche) | 1.05 | 1.05 | 220 | 7.93 | 204 | 2 (1 uniche) | 1.04 | 1.04 | 325 | 13.26 | 251 | SI |
| Nightly | GBPUSD | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_Nightly | 2 (1 uniche) | 0.59 | 0.59 | 96 | 22.62 | -2115 | 2 (1 uniche) | 1.04 | 1.04 | 163 | 11.28 | 320 | SI |
| EMA200 | SPXUSD | H4 | r3 | backtest_pipeline/risultati_prove/ABTG_EMA200 | 5 | 1.80 | 2.46 | 20 | 1.38 | 144 | 5 | 1.04 | 1.60 | 103 | 3.37 | 37 | SI |
| CrossEma | XAUUSD | [NON MISURATO] | r86aoro | backtest_pipeline/risultati_archivio/r86_r87_r89_csv | 2 (1 uniche) | 0.82 | 0.82 | 138 | 21.77 | -1608 | 2 (1 uniche) | 1.03 | 1.03 | 197 | 15.56 | 372 | SI |
| PTE | GBPUSD | H1 | ohlc_pte78gbp | backtest_pipeline/risultati_archivio/csv_R78 | 14 | 0.81 | 0.91 | 431 | 15.18 | -10975 | 14 | 1.03 | 1.10 | 459 | 13.82 | 1871 | SI |
| ORB_Ottimizzato | NASUSD | [NON MISURATO] | r13 | backtest_pipeline/risultati_prove/ABTG_ORB_Ottimizzato | 48 | 0.92 | 1.22 | 127 | 32.74 | -682 | 48 | 1.03 | 1.16 | 217 | 32.57 | 542 | SI |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_r46a | backtest_pipeline/risultati_prove/aperture_r46 | 8 (6 uniche) | 1.19 | 1.54 | 214 | 8.18 | 9456 | 8 (6 uniche) | 1.03 | 1.49 | 278 | 8.74 | 2281 | SI |
| CrossEma | D30EUR | [NON MISURATO] | r86cdax | backtest_pipeline/risultati_archivio/r86_r87_r89_csv | 2 (1 uniche) | 0.81 | 0.81 | 78 | 18.42 | -1012 | 2 (1 uniche) | 1.02 | 1.02 | 123 | 12.90 | 165 | SI |
| EMA200 | GBPUSD | TF-OTT | ABTG_EMA200 | backtest_pipeline/risultati_prove/ABTG_EMA200 | 11 | 0.84 | 3.64 | 289 | 14.06 | -681 | 11 | 1.02 | 1.89 | 262 | 9.77 | 48 | SI |
| SupRev | NAS | H1 | Ottimizzato_NASUSD_r3 | backtest_pipeline/risultati_prove/ABTG_SupRev_NAS_H1_Ottimizzato | 5 | 0.91 | 1.37 | 78 | 1.75 | -46 | 5 | 1.01 | 1.69 | 154 | 3.12 | 13 | SI |
| SuperWave | U30USD | TF-OTT | ABTG_SuperWave | backtest_pipeline/risultati_prove/ABTG_SuperWave | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 1.01 | 12642.00 | 551 | 8.49 | 75 | SI |
| F_gestione | NASDAQ | [NON MISURATO] | Walkforward_Aperture | backtest_pipeline/risultati_archivio/Walkforward_Aperture | 8 (6 uniche) | 0.91 | 0.95 | 262 | 12.72 | -337 | 8 (6 uniche) | 1.00 | 1.02 | 362 | 7.49 | 20 | SI |
| H_drawdown | DAX | [NON MISURATO] | Walkforward_Aperture | backtest_pipeline/risultati_archivio/Walkforward_Aperture | 16 | 0.96 | 1.18 | 206 | 7.58 | -248 | 16 | 1.00 | 1.12 | 292 | 19.80 | 32 | SI |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_r118b | backtest_pipeline/risultati_archivio/r118_csv | 50 (35 uniche) | 0.98 | 1.10 | 188 | 7.54 | -75 | 50 (35 uniche) | 0.99 | 1.15 | 307 | 14.97 | -30 | SI |
| ORB_Ottimizzato | D30EUR | [NON MISURATO] | r11 | backtest_pipeline/risultati_prove/ABTG_ORB_Ottimizzato | 4 | 1.23 | 1.44 | 115 | 6.54 | 1474 | 4 | 0.99 | 1.02 | 233 | 19.59 | -74 | SI |
| SupertrendReversal_Ottimizzato | XAUUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal_Ottimizzato | 11 | 1.00 | 6163.50 | 320 | 10.13 | -6 | 11 | 0.99 | 2.42 | 268 | 6.78 | -45 | SI |
| D_retest | DAX | [NON MISURATO] | Walkforward_Aperture | backtest_pipeline/risultati_archivio/Walkforward_Aperture | 20 | 1.00 | 1.27 | 178 | 9.79 | 1 | 20 | 0.99 | 1.20 | 235 | 14.69 | -77 | SI |
| PTE | GBPUSD | H1 | ohlc_pte79gbp | backtest_pipeline/risultati_archivio/csv_R79 | 6 | 0.79 | 1.06 | 414 | 20.39 | -14808 | 6 | 0.98 | 1.14 | 240 | 9.71 | -620 | SI |
| ORB | NASUSD | [NON MISURATO] | r8 | backtest_pipeline/risultati_prove/ABTG_ORB | 4 | 1.07 | 1.49 | 248 | 4.52 | 211 | 4 | 0.98 | 1.03 | 381 | 6.65 | -64 | SI |
| Apertura_3Ingressi | D30EUR | [NON MISURATO] | r83d2 | backtest_pipeline/risultati_archivio/r83_csv | 2 (1 uniche) | 0.80 | 0.80 | 212 | 8.97 | -767 | 2 (1 uniche) | 0.98 | 0.98 | 322 | 8.69 | -83 | SI |
| BreakoutCorso | GBPJPY | M15 | ohlc_r82c | backtest_pipeline/risultati_archivio/r82_csv | 2 (1 uniche) | 0.94 | 0.94 | 264 | 17.98 | -704 | 2 (1 uniche) | 0.98 | 0.98 | 1467 | 46.63 | -1684 | SI |
| Apertura_3Ingressi | NASUSD | [NON MISURATO] | r83n2 | backtest_pipeline/risultati_archivio/r83_csv | 2 (1 uniche) | 0.70 | 0.70 | 198 | 9.48 | -942 | 2 (1 uniche) | 0.98 | 0.98 | 313 | 6.18 | -92 | SI |
| SuperWave | DOW | H1 | Ottimizzato_U30USD_ohlc | backtest_pipeline/risultati_prove/ABTG_SuperWave_DOW_H1_Ottimizzato | 10 | 1.20 | 6.46 | 9 | 2.59 | 29 | 11 | 0.98 | 1.38 | 640 | 9.85 | -138 | SI |
| SuperWave | U30USD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_SuperWave | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 0.98 | 2.47 | 290 | 8.43 | -76 | SI |
| CrossEma | D30EUR | [NON MISURATO] | r86ddax | backtest_pipeline/risultati_archivio/r86_r87_r89_csv | 2 (1 uniche) | 0.84 | 0.84 | 150 | 26.12 | -1500 | 2 (1 uniche) | 0.97 | 0.97 | 267 | 14.39 | -420 | SI |
| Apertura | NASDAQ | [NON MISURATO] | US_NASUSD_r84c | backtest_pipeline/risultati_archivio/r84_csv | 2 (1 uniche) | 1.28 | 1.28 | 89 | 3.45 | 349 | 2 (1 uniche) | 0.97 | 0.97 | 180 | 6.73 | -92 | SI |
| Nightly | USDCHF | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_Nightly | 2 (1 uniche) | 0.86 | 0.86 | 81 | 11.42 | -620 | 2 (1 uniche) | 0.97 | 0.97 | 131 | 14.16 | -206 | SI |
| IBRetest | D30EUR | [NON MISURATO] | P0IBRTDAX | backtest_pipeline/risultati_prove/ibretest_p0 | 2 (1 uniche) | 1.21 | 1.21 | 58 | 2.80 | 261 | 2 (1 uniche) | 0.96 | 0.96 | 107 | 5.25 | -84 | SI |
| Live5m | NASDAQ | [NON MISURATO] | NASUSD | backtest_pipeline/risultati_prove/ABTG_Nasdaq_Live5m | 2 (1 uniche) | 1.02 | 1.02 | 116 | 11.52 | 99 | 2 (1 uniche) | 0.96 | 0.96 | 175 | 19.40 | -327 | SI |
| B_motore | NASDAQ | [NON MISURATO] | faseB_v1 | backtest_pipeline/risultati_archivio/Walkforward_Aperture/faseB_v1 | 11 (8 uniche) | 0.89 | 1.82 | 182 | 15.70 | -467 | 10 (7 uniche) | 0.96 | 1.11 | 104 | 6.72 | -145 | SI |
| PTE | USDJPY | H1 | ohlc_pte78jpy | backtest_pipeline/risultati_archivio/csv_R78 | 14 | 1.02 | 1.15 | 415 | 11.40 | 975 | 14 | 0.95 | 1.01 | 482 | 16.06 | -2317 | SI |
| EMA200 | XAUUSD | TF-OTT | ABTG_EMA200 | backtest_pipeline/risultati_prove/ABTG_EMA200 | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 0.95 | 2.29 | 1691 | 18.61 | -770 | SI |
| B_motore | NASDAQ | [NON MISURATO] | Walkforward_Aperture | backtest_pipeline/risultati_archivio/Walkforward_Aperture | 12 (11 uniche) | 1.07 | 2.08 | 114 | 5.84 | 148 | 12 (11 uniche) | 0.95 | 1.94 | 244 | 9.60 | -282 | SI |
| EMA200 | XAUUSD | H1 | r32a | backtest_pipeline/risultati_prove/ABTG_EMA200 | 30 | 0.68 | 0.85 | 292 | 13.01 | -984 | 30 | 0.94 | 1.11 | 387 | 10.18 | -203 | SI |
| SupRev | NAS | H1 | Ottimizzato_NASUSD_ohlc | backtest_pipeline/risultati_prove/ABTG_SupRev_NAS_H1_Ottimizzato | 10 | 0.65 | 4.24 | 144 | 6.04 | -431 | 11 | 0.94 | 3.95 | 316 | 6.16 | -141 | SI |
| SupRev | DAX | H4 | Ottimizzato_D30EUR_ohlc | backtest_pipeline/risultati_prove/ABTG_SupRev_DAX_H4_Ottimizzato | 11 | 0.80 | 4.46 | 303 | 8.64 | -673 | 11 | 0.93 | 15.79 | 665 | 13.71 | -559 | SI |
| EMA200 | SPXUSD | TF-OTT | ABTG_EMA200 | backtest_pipeline/risultati_prove/ABTG_EMA200 | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 0.93 | 2.38 | 920 | 15.29 | -531 | SI |
| PTE | USDJPY | H1 | ohlc_pte79jpy | backtest_pipeline/risultati_archivio/csv_R79 | 6 | 1.07 | 1.15 | 230 | 4.58 | 2678 | 6 | 0.93 | 0.98 | 482 | 15.66 | -3671 | SI |
| Live5m | DAX | [NON MISURATO] | v2_D30EUR | backtest_pipeline/risultati_prove/ABTG_DAX_Live5m_v2 | 2 (1 uniche) | 1.01 | 1.01 | 80 | 4.70 | 11 | 2 (1 uniche) | 0.92 | 0.92 | 202 | 14.16 | -394 | SI |
| Apertura | NASDAQ | [NON MISURATO] | US_NASUSD_r84d | backtest_pipeline/risultati_archivio/r84_csv | 2 (1 uniche) | 1.51 | 1.51 | 110 | 3.02 | 858 | 2 (1 uniche) | 0.92 | 0.92 | 201 | 6.92 | -287 | SI |
| CrossEma | D30EUR | [NON MISURATO] | r86adax | backtest_pipeline/risultati_archivio/r86_r87_r89_csv | 2 (1 uniche) | 0.95 | 0.95 | 113 | 17.69 | -394 | 2 (1 uniche) | 0.92 | 0.92 | 204 | 20.43 | -1009 | SI |
| SuperWave | USDJPY | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_SuperWave | 11 | 1.04 | 11.66 | 208 | 7.40 | 62 | 11 | 0.92 | 1.70 | 287 | 3.91 | -182 | SI |
| SupertrendReversal_Ottimizzato | XAUUSD | TF-OTT | ABTG_SupertrendReversal_Ottimizzato | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal_Ottimizzato | 11 | 0.90 | 6163.50 | 270 | 11.43 | -458 | 11 | 0.92 | 2.25 | 268 | 7.42 | -311 | SI |
| EMA200 | AUDJPY | TF-OTT | ABTG_EMA200 | backtest_pipeline/risultati_prove/ABTG_EMA200 | 11 | 0.97 | 2.52 | 415 | 11.55 | -166 | 11 | 0.91 | 335.62 | 138 | 10.44 | -143 | SI |
| A_geometria | DAX | [NON MISURATO] | Walkforward_Aperture | backtest_pipeline/risultati_archivio/Walkforward_Aperture | 20 | 1.15 | 1.45 | 179 | 8.58 | 761 | 20 | 0.91 | 1.17 | 250 | 17.14 | -609 | SI |
| PTE | USDJPY | H1 | ohlc_pte77jpy | backtest_pipeline/risultati_archivio/csv_R77 | 28 | 0.92 | 1.05 | 461 | 14.20 | -6161 | 28 | 0.91 | 0.98 | 556 | 18.73 | -6754 | SI |
| B_motore | DAX | [NON MISURATO] | faseB_v1 | backtest_pipeline/risultati_archivio/Walkforward_Aperture/faseB_v1 | 10 (7 uniche) | 1.17 | 1.37 | 180 | 10.44 | 807 | 10 (7 uniche) | 0.90 | 1.07 | 233 | 14.28 | -508 | SI |
| B_motore | DAX | [NON MISURATO] | Walkforward_Aperture | backtest_pipeline/risultati_archivio/Walkforward_Aperture | 12 (11 uniche) | 1.11 | 1.37 | 58 | 3.00 | 180 | 12 (11 uniche) | 0.90 | 1.11 | 233 | 14.28 | -508 | SI |
| BreakoutCorso | EURJPY | M15 | ohlc_r82b | backtest_pipeline/risultati_archivio/r82_csv | 2 (1 uniche) | 1.11 | 1.11 | 895 | 24.75 | 5476 | 2 (1 uniche) | 0.90 | 0.90 | 2068 | 70.11 | -6108 | SI |

---

## 📋 TABELLA B — TUTTE LE CORSE CON OOS MISURATO (430 righe)

Ordinata per **PF OOS della cella mediana, decrescente**.

> 🔴 **Come si legge la cima di questa tabella.** In alto NON ci sono i vincitori: ci sono i
> **campioni sottili**. Un PF OOS mediano di 189 o di 5,03 su 2-13 operazioni e' rumore, non
> un motore. Per questo esiste la colonna `Trades OOS`: **se e' un numero piccolo, il PF
> accanto non vuol dire niente**. La colonna `VICINO ALLA SOGLIA?` e' il filtro serio.
> Stessa cosa per `passate`: con 1-2 passate non esiste nessun "altopiano", mediana e picco
> coincidono per costruzione.

| Motore | Simbolo | TF | Etichetta/Round | Cartella | pass IS | PF med IS | PF picco IS | Trades IS | DD% IS | Profit IS | pass OOS | PF med OOS | PF picco OOS | Trades OOS | DD% OOS | Profit OOS | VICINO ALLA SOGLIA? |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| SupertrendInvert | XAGUSD | M15 | ohlc | backtest_pipeline/risultati_prove/ABTG_SupertrendInvert | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 1 | 1357.00 | 1357.00 | 2 | 0.39 | 41 | no |
| SupertrendInvert | USDJPY | M15 | ohlc | backtest_pipeline/risultati_prove/ABTG_SupertrendInvert | 1 | 108.59 | 108.59 | 2 | 0.70 | 75 | 1 | 189.24 | 189.24 | 2 | 1.08 | 215 | no |
| SupertrendInvert | USDJPY | M15 | ABTG_SupertrendInvert | backtest_pipeline/risultati_prove/ABTG_SupertrendInvert | 1 | 98.14 | 98.14 | 2 | 0.60 | 68 | 1 | 183.75 | 183.75 | 2 | 1.03 | 208 | no |
| GapFill | GBPUSD | H1 | r36 | backtest_pipeline/risultati_prove/ABTG_GapFill/r36 | 3 | 1.20 | 1.64 | 3 | 1.40 | 19 | 3 | 5.03 | 62.77 | 8 | 2.42 | 411 | no |
| GapFill | GBPUSD | H1 | r37 | backtest_pipeline/risultati_prove/ABTG_GapFill/r37 | 2 (1 uniche) | 1.62 | 1.62 | 3 | 1.44 | 632 | 2 (1 uniche) | 4.94 | 4.94 | 8 | 2.49 | 4132 | no |
| BreakingBand | EURUSD | H1 | r34 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/r34 | 2 (1 uniche) | 53.79 | 53.79 | 4 | 0.78 | 1457 | 2 (1 uniche) | 3.86 | 3.86 | 13 | 1.27 | 2070 | no |
| GoldenCross | USDCAD | [NON MISURATO] | r87acad | backtest_pipeline/risultati_archivio/r86_r87_r89_csv | 2 (1 uniche) | 1.51 | 1.51 | 12 | 2.80 | 143 | 2 (1 uniche) | 3.68 | 3.68 | 14 | 1.40 | 281 | no |
| larry | GBPAUD | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | 3 | 0.53 | 0.77 | 21 | 5.59 | -359 | 3 | 3.04 | 9.71 | 31 | 4.54 | 984 | no |
| GapFill | AUDUSD | H1 | r37 | backtest_pipeline/risultati_prove/ABTG_GapFill/r37 | 2 (1 uniche) | 1.34 | 1.34 | 5 | 1.30 | 689 | 2 (1 uniche) | 2.93 | 2.93 | 12 | 1.87 | 4153 | no |
| GoldenCross_V1 | USDCAD | [NON MISURATO] | r87acadv1 | backtest_pipeline/risultati_archivio/r86_r87_r89_csv | 2 (1 uniche) | 3.52 | 3.52 | 10 | 1.28 | 287 | 2 (1 uniche) | 2.89 | 2.89 | 12 | 1.27 | 198 | no |
| GapFill | AUDUSD | H1 | r36 | backtest_pipeline/risultati_prove/ABTG_GapFill/r36 | 3 | 0.99 | 1.34 | 5 | 1.29 | -2 | 3 | 2.89 | 3.72 | 12 | 1.86 | 403 | no |
| GapFill | EURUSD | H1 | r37 | backtest_pipeline/risultati_prove/ABTG_GapFill/r37 | 2 (1 uniche) | 1.61 | 1.61 | 5 | 1.84 | 625 | 2 (1 uniche) | 2.78 | 2.78 | 9 | 1.55 | 1935 | no |
| BreakingBand | AUDUSD | H1 | r91c | backtest_pipeline/risultati_archivio/r91_csv | 3 | 134.24 | 176.37 | 2 | 0.52 | 1046 | 2 | 2.75 | 56.88 | 11 | 1.27 | 1841 | no |
| BreakingBand | AUDUSD | H1 | r34 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/r34 | 2 (1 uniche) | 47.99 | 47.99 | 5 | 0.68 | 1291 | 2 (1 uniche) | 2.75 | 2.75 | 11 | 1.27 | 1841 | no |
| MaxMinNotte | DAX | [NON MISURATO] | Short_Ottimizzato_D30EUR_r81c | backtest_pipeline/risultati_archivio/r81_csv | 2 (1 uniche) | 2.92 | 2.92 | 20 | 4.09 | 10680 | 2 (1 uniche) | 2.70 | 2.70 | 22 | 3.73 | 11218 | no |
| PunteLarry | XAUUSD | H1 | r39 | backtest_pipeline/risultati_prove/ABTG_PunteLarry/r39 | 2 (1 uniche) | 1.25 | 1.25 | 5 | 1.30 | 369 | 2 (1 uniche) | 2.66 | 2.66 | 11 | 2.37 | 5265 | no |
| GapFill | EURUSD | H1 | r36 | backtest_pipeline/risultati_prove/ABTG_GapFill/r36 | 3 | 0.88 | 1.63 | 5 | 1.79 | -23 | 3 | 2.66 | 2.74 | 10 | 2.71 | 347 | no |
| MaxMinNotte | XAUUSD | [NON MISURATO] | r19 | backtest_pipeline/risultati_prove/ABTG_MaxMinNotte | 2 (1 uniche) | 1.42 | 1.42 | 59 | 2.68 | 3788 | 2 (1 uniche) | 2.45 | 2.45 | 92 | 4.24 | 15849 | no |
| MaxMinNotte | XAUUSD | [NON MISURATO] | r19b | backtest_pipeline/risultati_prove/MaxMin_Oro_r19 | 2 (1 uniche) | 1.42 | 1.42 | 59 | 2.68 | 3788 | 2 (1 uniche) | 2.45 | 2.45 | 92 | 4.24 | 15849 | no |
| MaxMinNotte | DAX | [NON MISURATO] | Short_Ottimizzato_D30EUR_ohlc | backtest_pipeline/risultati_prove/ABTG_MaxMinNotte_DAX_Short_Ottimizzato | 2 (1 uniche) | 2.06 | 2.06 | 20 | 3.01 | 537 | 2 (1 uniche) | 2.44 | 2.44 | 21 | 2.25 | 728 | no |
| MaxMinNotte | DAX | [NON MISURATO] | Short_Ottimizzato_D30EUR_r81b | backtest_pipeline/risultati_archivio/r81_csv | 2 (1 uniche) | 2.38 | 2.38 | 13 | 7.02 | 11683 | 2 (1 uniche) | 2.20 | 2.20 | 14 | 6.14 | 10889 | no |
| MaxMinNotte | DAX | [NON MISURATO] | Short_Ottimizzato_D30EUR | backtest_pipeline/risultati_prove/ABTG_MaxMinNotte_DAX_Short_Ottimizzato | 2 (1 uniche) | 1.92 | 1.92 | 20 | 3.07 | 478 | 2 (1 uniche) | 2.19 | 2.19 | 21 | 1.88 | 618 | no |
| GoldenCross_V1 | USDCHF | [NON MISURATO] | r87achfv1 | backtest_pipeline/risultati_archivio/r86_r87_r89_csv | 2 (1 uniche) | 3.63 | 3.63 | 20 | 1.56 | 466 | 2 (1 uniche) | 2.19 | 2.19 | 17 | 2.34 | 230 | no |
| Live5m | NASDAQ | [NON MISURATO] | NASUSD_ohlc | backtest_pipeline/risultati_prove/ABTG_Nasdaq_Live5m | 2 (1 uniche) | 1.37 | 1.37 | 125 | 8.01 | 2404 | 2 (1 uniche) | 2.16 | 2.16 | 198 | 7.31 | 8944 | SI |
| MaxMinNotte | DAX | [NON MISURATO] | Short_Ottimizzato_D30EUR_r81a | backtest_pipeline/risultati_archivio/r81_csv | 2 (1 uniche) | 1.88 | 1.88 | 20 | 3.10 | 4767 | 2 (1 uniche) | 2.16 | 2.16 | 21 | 1.92 | 6143 | no |
| MaxMinNotte | DAX | [NON MISURATO] | Short_Ottimizzato_D30EUR_ptb | backtest_pipeline/risultati_prove/ABTG_MaxMinNotte_DAX_Short_Ottimizzato | 2 (1 uniche) | 1.88 | 1.88 | 20 | 3.10 | 4767 | 2 (1 uniche) | 2.16 | 2.16 | 21 | 1.92 | 6143 | no |
| PunteLarry | GBPJPY | H1 | r39 | backtest_pipeline/risultati_prove/ABTG_PunteLarry/r39 | 2 (1 uniche) | 1.27 | 1.27 | 18 | 3.32 | 1940 | 2 (1 uniche) | 2.05 | 2.05 | 20 | 2.84 | 6637 | no |
| MaxMinNotte | DAX | [NON MISURATO] | Short_Ottimizzato_D30EUR_r2 | backtest_pipeline/risultati_prove/ABTG_MaxMinNotte_DAX_Short_Ottimizzato | 5 | 1.92 | 1.96 | 20 | 3.07 | 478 | 5 | 2.01 | 2.68 | 20 | 2.23 | 516 | no |
| GapFill | F40EUR | H1 | r36 | backtest_pipeline/risultati_prove/ABTG_GapFill/r36 | 3 | 0.31 | 0.46 | 13 | 7.17 | -509 | 3 | 1.96 | 2.38 | 21 | 2.83 | 564 | no |
| Apertura | NASDAQ | [NON MISURATO] | US_NASUSD_gapnas | backtest_pipeline/risultati_archivio/GapFill_Nasdaq | 24 (6 uniche) | 2.00 | 2.30 | 39 | 4.41 | 11034 | 24 (8 uniche) | 1.95 | 2.87 | 19 | 3.90 | 5915 | no |
| EMA200 | U30USD | H1 | 02_short | backtest_pipeline/prove/R110_CSV_EMADOW | 2 (1 uniche) | 1.23 | 1.23 | 125 | 4.51 | 2607 | 2 (1 uniche) | 1.89 | 1.89 | 302 | 2.66 | 16948 | SI |
| EMA200 | U30USD | H1 | 01_short_r1 | backtest_pipeline/risultati_archivio/R112_CORSA_20260826 | 2 (1 uniche) | 1.23 | 1.23 | 125 | 4.51 | 2607 | 2 (1 uniche) | 1.89 | 1.89 | 302 | 2.66 | 16948 | SI |
| EMA200 | U30USD | H1 | 01_short_r1 | backtest_pipeline/risultati_archivio/R112_PARZIALE_20260826 | 2 (1 uniche) | 1.23 | 1.23 | 125 | 4.51 | 2607 | 2 (1 uniche) | 1.89 | 1.89 | 302 | 2.66 | 16948 | SI |
| EMA200 | U30USD | H1 | 02_short_r2 | backtest_pipeline/risultati_archivio/R112_CORSA_20260826 | 2 (1 uniche) | 1.22 | 1.22 | 127 | 8.90 | 5075 | 2 (1 uniche) | 1.89 | 1.89 | 315 | 5.30 | 36527 | SI |
| EMA200 | U30USD | H1 | 02_short_r2 | backtest_pipeline/risultati_archivio/R112_PARZIALE_20260826 | 2 (1 uniche) | 1.22 | 1.22 | 127 | 8.90 | 5075 | 2 (1 uniche) | 1.89 | 1.89 | 315 | 5.30 | 36527 | SI |
| MaxMinNotte | DAX | [NON MISURATO] | Short_Ottimizzato_D30EUR_r81f | backtest_pipeline/risultati_archivio/r81_csv | 2 (1 uniche) | 1.17 | 1.17 | 13 | 7.02 | 1406 | 2 (1 uniche) | 1.88 | 1.88 | 14 | 4.08 | 6618 | no |
| EMA200 | U30USD | H1 | 03_short_r3 | backtest_pipeline/risultati_archivio/R112_CORSA_20260826 | 2 (1 uniche) | 1.21 | 1.21 | 128 | 13.17 | 7434 | 2 (1 uniche) | 1.87 | 1.87 | 324 | 7.92 | 58567 | SI |
| EMA200 | U30USD | H1 | 03_short_r3 | backtest_pipeline/risultati_archivio/R112_PARZIALE_20260826 | 2 (1 uniche) | 1.21 | 1.21 | 128 | 13.17 | 7434 | 2 (1 uniche) | 1.87 | 1.87 | 324 | 7.92 | 58567 | SI |
| PunteLarry | GBPUSD | H1 | r39 | backtest_pipeline/risultati_prove/ABTG_PunteLarry/r39 | 2 (1 uniche) | 1.97 | 1.97 | 11 | 1.63 | 2018 | 2 (1 uniche) | 1.85 | 1.85 | 25 | 5.24 | 4596 | no |
| SuperWave | GBPUSD | H2 | r23e | backtest_pipeline/risultati_prove/ABTG_SuperWave | 2 (1 uniche) | 1.83 | 1.83 | 30 | 1.81 | 1839 | 2 (1 uniche) | 1.84 | 1.84 | 63 | 2.29 | 3560 | no |
| PunteLarry | U30USD | H1 | r39 | backtest_pipeline/risultati_prove/ABTG_PunteLarry/r39 | 2 (1 uniche) | 1.72 | 1.72 | 16 | 1.78 | 3587 | 2 (1 uniche) | 1.81 | 1.81 | 38 | 3.87 | 11097 | no |
| GapFill | UKOIL | H1 | r36 | backtest_pipeline/risultati_prove/ABTG_GapFill/r36 | 3 | 0.79 | 0.94 | 8 | 1.89 | -72 | 3 | 1.79 | 1.98 | 18 | 3.61 | 367 | no |
| MaxMinNotte | XAUUSD | [NON MISURATO] | r17 | backtest_pipeline/risultati_prove/MaxMin_Oro_r17 | 20 | 1.12 | 2.43 | 51 | 3.05 | 107 | 20 | 1.79 | 2.27 | 79 | 4.63 | 899 | no |
| MaxMinNotte | DAX | [NON MISURATO] | Short_Ottimizzato_D30EUR_r81d | backtest_pipeline/risultati_archivio/r81_csv | 2 (1 uniche) | 2.17 | 2.17 | 20 | 3.25 | 6408 | 2 (1 uniche) | 1.79 | 1.79 | 21 | 2.46 | 4942 | no |
| larry | U30USD | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | 3 | 1.18 | 1.26 | 8 | 2.87 | 38 | 3 | 1.78 | 2.10 | 38 | 3.87 | 884 | no |
| WOL | U30USD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_WOL | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 1.77 | 146.87 | 32 | 1.89 | 79 | no |
| Apertura | NASDAQ | [NON MISURATO] | US_NASUSD_gapnas2 | backtest_pipeline/risultati_archivio/GapFill_Nasdaq | 18 (10 uniche) | 2.18 | 2.54 | 34 | 4.36 | 10947 | 18 (10 uniche) | 1.77 | 2.01 | 37 | 5.08 | 7993 | no |
| BreakingBand | EURUSD | H1 | r91b | backtest_pipeline/risultati_archivio/r91_csv | 2 | 53.79 | 56.06 | 4 | 0.78 | 1457 | 3 | 1.77 | 3.86 | 4 | 1.18 | 412 | no |
| SuperWave | U30USD | H2 | r23d | backtest_pipeline/risultati_prove/ABTG_SuperWave | 2 (1 uniche) | 5.57 | 5.57 | 32 | 1.55 | 5311 | 2 (1 uniche) | 1.76 | 1.76 | 88 | 4.27 | 4371 | no |
| BreakingBand | GBPUSD | H1 | r33 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/r33 | 3 | 2.74 | 2.98 | 13 | 1.68 | 262 | 3 | 1.75 | 3.72 | 26 | 3.40 | 316 | no |
| PunteLarry | EURAUD | H1 | r39 | backtest_pipeline/risultati_prove/ABTG_PunteLarry/r39 | 2 (1 uniche) | 2.13 | 2.13 | 20 | 3.10 | 6634 | 2 (1 uniche) | 1.74 | 1.74 | 33 | 3.87 | 8584 | no |
| CostToCost | EURJPY | H4 | r41 | backtest_pipeline/risultati_prove/ABTG_CostToCost/r41 | 2 (1 uniche) | 1.02 | 1.02 | 48 | 9.93 | 363 | 2 (1 uniche) | 1.74 | 1.74 | 64 | 9.45 | 22252 | no |
| larry | EURAUD | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | 3 | 1.53 | 2.08 | 13 | 2.67 | 226 | 3 | 1.74 | 2.05 | 33 | 3.72 | 831 | no |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | r44a | backtest_pipeline/risultati_prove/ABTG_ORB_Ottimizzato/r44 | 4 | 1.29 | 1.36 | 71 | 9.13 | 1158 | 4 | 1.74 | 1.95 | 119 | 11.04 | 4677 | SI |
| BreakingBand | GBPUSD | H1 | r34 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/r34 | 2 (1 uniche) | 2.73 | 2.73 | 13 | 1.70 | 2667 | 2 (1 uniche) | 1.73 | 1.73 | 26 | 3.48 | 3160 | no |
| SupertrendReversal_Multi_Ottimizzato | XAUUSD | H4 | r3 | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal_Multi_Ottimizzato | 5 | 1.25 | 4.51 | 11 | 2.14 | 54 | 5 | 1.71 | 2.98 | 105 | 5.79 | 1664 | SI |
| Live5m | DAX | [NON MISURATO] | v2_D30EUR_ohlc | backtest_pipeline/risultati_prove/ABTG_DAX_Live5m_v2 | 2 (1 uniche) | 1.32 | 1.32 | 84 | 4.85 | 595 | 2 (1 uniche) | 1.71 | 1.71 | 211 | 6.17 | 2958 | SI |
| SupertrendReversal | GBPJPY | H4 | r22 | backtest_pipeline/risultati_prove/SupRev_GBPJPY_r22 | 9 (7 uniche) | 0.34 | 1.54 | 22 | 4.61 | -279 | 9 (7 uniche) | 1.71 | 2.16 | 30 | 1.65 | 212 | no |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | ANCORA | backtest_pipeline/risultati_archivio/ancora_passo7 | 2 (1 uniche) | 1.23 | 1.23 | 71 | 5.65 | 569 | 2 (1 uniche) | 1.67 | 1.67 | 119 | 6.54 | 2484 | SI |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | R119_D0000 | backtest_pipeline/risultati_archivio/ritardo_r119_csv | 2 (1 uniche) | 1.23 | 1.23 | 71 | 5.65 | 569 | 2 (1 uniche) | 1.67 | 1.67 | 119 | 6.54 | 2484 | SI |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | R119_D0500 | backtest_pipeline/risultati_archivio/ritardo_r119_csv | 2 (1 uniche) | 1.23 | 1.23 | 71 | 5.65 | 569 | 2 (1 uniche) | 1.67 | 1.67 | 119 | 6.54 | 2484 | SI |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | R119_D0000 | backtest_pipeline/risultati_archivio/ritardo_r119b_csv | 2 (1 uniche) | 1.23 | 1.23 | 71 | 5.65 | 569 | 2 (1 uniche) | 1.67 | 1.67 | 119 | 6.54 | 2484 | SI |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | R119_D0050 | backtest_pipeline/risultati_archivio/ritardo_r119b_csv | 2 (1 uniche) | 1.23 | 1.23 | 71 | 5.65 | 569 | 2 (1 uniche) | 1.67 | 1.67 | 119 | 6.54 | 2484 | SI |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | R119_D0100 | backtest_pipeline/risultati_archivio/ritardo_r119b_csv | 2 (1 uniche) | 1.23 | 1.23 | 71 | 5.65 | 569 | 2 (1 uniche) | 1.67 | 1.67 | 119 | 6.54 | 2484 | SI |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | R119_D0500 | backtest_pipeline/risultati_archivio/ritardo_r119b_csv | 2 (1 uniche) | 1.23 | 1.23 | 71 | 5.66 | 567 | 2 (1 uniche) | 1.67 | 1.67 | 119 | 6.54 | 2484 | SI |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | r88c | backtest_pipeline/risultati_archivio/r88_csv | 4 (2 uniche) | 1.15 | 1.25 | 74 | 7.93 | 6215 | 4 (2 uniche) | 1.67 | 1.69 | 119 | 9.76 | 41057 | SI |
| GoldenCross_V1 | NZDUSD | [NON MISURATO] | r87anzdv1 | backtest_pipeline/risultati_archivio/r86_r87_r89_csv | 2 (1 uniche) | 2.78 | 2.78 | 8 | 0.94 | 150 | 2 (1 uniche) | 1.67 | 1.67 | 14 | 2.81 | 189 | no |
| SupertrendReversal | 225JPY | TF-OTT | r2 | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal | 7 | 1.43 | 75.33 | 10 | 0.00 | 2 | 7 | 1.67 | 2.92 | 47 | 0.01 | 17 | no |
| SupertrendReversal | 225JPY | H2 | pta | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal | 2 (1 uniche) | 1.54 | 1.54 | 29 | 0.65 | 591 | 2 (1 uniche) | 1.65 | 1.65 | 50 | 0.88 | 1863 | no |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | r55b | backtest_pipeline/risultati_archivio/csv_r55 | 10 (5 uniche) | 1.19 | 1.25 | 71 | 8.29 | 7452 | 10 (5 uniche) | 1.62 | 1.67 | 119 | 9.95 | 38271 | SI |
| GapFill | USOIL | H1 | r36 | backtest_pipeline/risultati_prove/ABTG_GapFill/r36 | 3 | 0.64 | 0.87 | 8 | 2.42 | -118 | 3 | 1.61 | 1.98 | 15 | 3.08 | 292 | no |
| SupertrendReversal | XAUUSD | H4 | r21 | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal | 12 | 1.26 | 8.62 | 5 | 0.52 | 11 | 12 | 1.60 | 3.42 | 12 | 2.09 | 143 | no |
| SupertrendReversal | XAUUSD | H4 | r21 | backtest_pipeline/risultati_prove/SupRev_H4_r21 | 12 | 1.26 | 8.62 | 5 | 0.52 | 11 | 12 | 1.60 | 3.42 | 12 | 2.09 | 143 | no |
| GoldenCross | USDCHF | [NON MISURATO] | r87achf | backtest_pipeline/risultati_archivio/r86_r87_r89_csv | 2 (1 uniche) | 2.87 | 2.87 | 21 | 2.03 | 422 | 2 (1 uniche) | 1.59 | 1.59 | 18 | 2.35 | 157 | no |
| PTE | USDJPY | TF-OTT | ABTG_PTE | backtest_pipeline/risultati_prove/ABTG_PTE | 16 | 1.66 | 226.30 | 15 | 2.74 | 204 | 16 | 1.57 | 9.87 | 29 | 5.39 | 486 | no |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | r118a | backtest_pipeline/risultati_archivio/r118_csv | 25 | 1.01 | 1.25 | 71 | 7.53 | 255 | 25 | 1.57 | 1.67 | 119 | 7.57 | 26637 | SI |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | r88a | backtest_pipeline/risultati_archivio/r88_csv | 48 (24 uniche) | 1.04 | 1.48 | 71 | 6.98 | 1173 | 48 (24 uniche) | 1.55 | 1.84 | 119 | 8.05 | 28466 | SI |
| PTE | D30EUR | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_PTE | 16 (15 uniche) | 0.80 | 5.74 | 23 | 3.49 | -97 | 16 | 1.55 | 6.94 | 35 | 3.64 | 273 | no |
| SupertrendReversal | 225JPY | TF-OTT | r5 | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal | 7 | 1.54 | 621.42 | 29 | 0.65 | 591 | 7 | 1.54 | 3.79 | 37 | 1.01 | 1264 | no |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_r26 | backtest_pipeline/risultati_prove/ABTG_DAX_Apertura_EU | 6 (4 uniche) | 1.19 | 1.73 | 104 | 3.99 | 355 | 6 (4 uniche) | 1.54 | 2.37 | 96 | 4.57 | 893 | no |
| PTE | USDJPY | H1 | pte72jpy | backtest_pipeline/risultati_archivio/csv_R72 | 14 | 0.83 | 1.09 | 35 | 3.42 | -919 | 14 (7 uniche) | 1.52 | 2.09 | 63 | 3.94 | 2525 | no |
| EMA200 | U30USD | H1 | 00_metro | backtest_pipeline/prove/R110_CSV_EMADOW | 2 (1 uniche) | 1.20 | 1.20 | 237 | 5.73 | 4585 | 2 (1 uniche) | 1.52 | 1.52 | 517 | 7.83 | 23321 | SI |
| EMA200 | U30USD | H1 | 00_metro | backtest_pipeline/risultati_archivio/R112_CORSA_20260826 | 2 (1 uniche) | 1.20 | 1.20 | 237 | 5.73 | 4585 | 2 (1 uniche) | 1.52 | 1.52 | 517 | 7.83 | 23321 | SI |
| EMA200 | U30USD | H1 | 00_metro | backtest_pipeline/risultati_archivio/R112_PARZIALE_20260826 | 2 (1 uniche) | 1.20 | 1.20 | 237 | 5.73 | 4585 | 2 (1 uniche) | 1.52 | 1.52 | 517 | 7.83 | 23321 | SI |
| EMA200 | U30USD | H1 | r31 | backtest_pipeline/risultati_prove/ABTG_EMA200 | 2 (1 uniche) | 1.20 | 1.20 | 237 | 5.73 | 4585 | 2 (1 uniche) | 1.52 | 1.52 | 517 | 7.83 | 23321 | SI |
| PTE | D30EUR | TF-OTT | ABTG_PTE | backtest_pipeline/risultati_prove/ABTG_PTE | 16 (15 uniche) | 0.55 | 5.56 | 23 | 5.22 | -299 | 16 | 1.52 | 7.26 | 35 | 3.51 | 258 | no |
| GoldenCross_Ottimizzato | USDJPY | [NON MISURATO] | r20 | backtest_pipeline/risultati_prove/GoldenCross_forex_r20 | 6 (2 uniche) | 0.91 | 0.94 | 44 | 5.76 | -91 | 6 (3 uniche) | 1.52 | 1.82 | 52 | 3.66 | 529 | no |
| EMA200 | U30USD | H1 | r29b | backtest_pipeline/risultati_prove/ABTG_EMA200 | 30 | 1.21 | 1.33 | 211 | 5.30 | 434 | 30 | 1.52 | 1.61 | 438 | 7.22 | 2136 | SI |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_r47b | backtest_pipeline/risultati_prove/aperture_r47 | 2 (1 uniche) | 1.18 | 1.18 | 132 | 4.96 | 5569 | 2 (1 uniche) | 1.49 | 1.49 | 193 | 6.27 | 23607 | SI |
| PTE_Ottimizzato | GBPUSD | H1 | ott74gbp | backtest_pipeline/risultati_archivio/csv_R74 | 14 | 33.94 | 37.73 | 26 | 1.27 | 3367 | 14 | 1.49 | 1.98 | 50 | 3.24 | 2165 | no |
| MaxMinNotte | DAX | [NON MISURATO] | Short_Ottimizzato_D30EUR_r81e | backtest_pipeline/risultati_archivio/r81_csv | 2 (1 uniche) | 1.03 | 1.03 | 16 | 3.41 | 130 | 2 (1 uniche) | 1.49 | 1.49 | 15 | 3.10 | 1506 | no |
| EasyTrend | GBPUSD | H1 | r49b | backtest_pipeline/risultati_prove/ABTG_EasyTrend | 2 (1 uniche) | 1.24 | 1.24 | 26 | 4.36 | 3500 | 2 (1 uniche) | 1.48 | 1.48 | 41 | 4.66 | 10174 | no |
| EasyTrend | GBPUSD | H1 | r53 | backtest_pipeline/risultati_archivio/csv_r53 | 16 (13 uniche) | 1.34 | 1.56 | 29 | 4.36 | 5392 | 16 | 1.48 | 1.58 | 43 | 3.57 | 10667 | no |
| PTE | GBPUSD | H1 | pte72gbp | backtest_pipeline/risultati_archivio/csv_R72 | 14 | 17.23 | 18.67 | 42 | 1.28 | 4319 | 14 | 1.47 | 1.56 | 56 | 2.90 | 2740 | no |
| Live5m | DAX | [NON MISURATO] | D30EUR_ohlc | backtest_pipeline/risultati_prove/ABTG_DAX_Live5m | 2 (1 uniche) | 1.27 | 1.27 | 228 | 18.77 | 2633 | 2 (1 uniche) | 1.47 | 1.47 | 352 | 11.83 | 8970 | SI |
| PTE | U30USD | H1 | ohlc_pte2dow | backtest_pipeline/risultati_archivio/csv_R69 | 28 (14 uniche) | 1.57 | 1.62 | 27 | 4.29 | 3545 | 28 (14 uniche) | 1.46 | 1.47 | 46 | 2.63 | 2921 | no |
| PTE | U30USD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_PTE | 16 | 1.28 | 1.80 | 8 | 1.95 | 74 | 16 | 1.44 | 5.16 | 43 | 2.54 | 266 | no |
| CostToCost | GBPCAD | H4 | r41 | backtest_pipeline/risultati_prove/ABTG_CostToCost/r41 | 2 (1 uniche) | 1.30 | 1.30 | 44 | 5.11 | 7343 | 2 (1 uniche) | 1.44 | 1.44 | 62 | 6.19 | 15446 | no |
| SupertrendReversal | 225JPY | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal | 11 | 1.12 | 4.47 | 52 | 0.09 | 2 | 11 | 1.44 | 2.94 | 82 | 0.08 | 14 | no |
| PTE | GBPUSD | H1 | ohlc_pte70gbp | backtest_pipeline/risultati_archivio/csv_R70 | 28 | 0.90 | 1.04 | 111 | 4.25 | -1018 | 28 (21 uniche) | 1.43 | 1.55 | 235 | 3.61 | 5523 | SI |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_R119_D0500 | backtest_pipeline/risultati_archivio/ritardo_r119b_csv | 2 (1 uniche) | 1.16 | 1.16 | 176 | 3.27 | 285 | 2 (1 uniche) | 1.42 | 1.42 | 270 | 4.31 | 1120 | SI |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_R119_D0100 | backtest_pipeline/risultati_archivio/ritardo_r119b_csv | 2 (1 uniche) | 1.15 | 1.15 | 175 | 3.19 | 281 | 2 (1 uniche) | 1.41 | 1.41 | 270 | 4.35 | 1109 | SI |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_R119_D0050 | backtest_pipeline/risultati_archivio/ritardo_r119b_csv | 2 (1 uniche) | 1.15 | 1.15 | 175 | 3.17 | 280 | 2 (1 uniche) | 1.41 | 1.41 | 270 | 4.35 | 1106 | SI |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_ANCORA | backtest_pipeline/risultati_archivio/ancora_passo7 | 2 (1 uniche) | 1.15 | 1.15 | 175 | 3.17 | 280 | 2 (1 uniche) | 1.41 | 1.41 | 270 | 4.35 | 1103 | SI |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_R119_D0000 | backtest_pipeline/risultati_archivio/ritardo_r119b_csv | 2 (1 uniche) | 1.15 | 1.15 | 175 | 3.17 | 280 | 2 (1 uniche) | 1.41 | 1.41 | 270 | 4.35 | 1103 | SI |
| larry | GBPUSD | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | 3 | 1.32 | 1.94 | 20 | 1.65 | 136 | 3 | 1.41 | 1.84 | 38 | 5.08 | 428 | no |
| CrossEma | XAUUSD | [NON MISURATO] | r86boro | backtest_pipeline/risultati_archivio/r86_r87_r89_csv | 2 (1 uniche) | 0.56 | 0.56 | 45 | 18.89 | -1447 | 2 (1 uniche) | 1.41 | 1.41 | 65 | 13.12 | 1614 | no |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_r47a | backtest_pipeline/risultati_prove/aperture_r47 | 2 (1 uniche) | 1.13 | 1.13 | 175 | 5.44 | 3789 | 2 (1 uniche) | 1.40 | 1.40 | 270 | 7.23 | 18030 | SI |
| PTE | USDJPY | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_PTE | 16 | 1.70 | 230.27 | 15 | 2.77 | 215 | 16 | 1.38 | 9.95 | 29 | 6.05 | 321 | no |
| PTE | GBPUSD | H1 | r23b | backtest_pipeline/risultati_prove/ABTG_PTE | 2 (1 uniche) | 40.98 | 40.98 | 20 | 0.90 | 4840 | 2 (1 uniche) | 1.38 | 1.38 | 49 | 3.27 | 2091 | no |
| EasyTrend | AUDJPY | H1 | r49c | backtest_pipeline/risultati_prove/ABTG_EasyTrend | 2 (1 uniche) | 1.15 | 1.15 | 29 | 6.78 | 2090 | 2 (1 uniche) | 1.37 | 1.37 | 54 | 4.35 | 9142 | no |
| walkforward | DOW | [NON MISURATO] | Dow_Apertura | backtest_pipeline/risultati_archivio/Dow_Apertura | 40 | 1.28 | 1.55 | 140 | 6.33 | 1229 | 40 | 1.37 | 1.56 | 188 | 4.41 | 2008 | SI |
| EasyTrend | AUDJPY | H1 | r48d | backtest_pipeline/risultati_prove/ABTG_EasyTrend/r48 | 6 | 0.65 | 3.24 | 22 | 10.86 | -534 | 6 | 1.37 | 1.81 | 54 | 4.29 | 894 | no |
| larry | XAUUSD | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | 3 | 0.74 | 1.42 | 19 | 5.98 | -201 | 3 | 1.36 | 4.23 | 29 | 4.31 | 455 | no |
| GapContinuation | 225JPY | [NON MISURATO] | ohlc_gc1 | backtest_pipeline/risultati_archivio/GapContinuation | 54 | 0.84 | 1.47 | 77 | 8.96 | -3444 | 54 | 1.36 | 1.73 | 75 | 8.90 | 7727 | no |
| Apertura | DOW | [NON MISURATO] | US_U30USD_r35 | backtest_pipeline/risultati_prove/aperture_r35 | 10 | 0.85 | 1.21 | 62 | 4.95 | -200 | 10 | 1.36 | 1.68 | 130 | 3.55 | 879 | SI |
| PTE | GBPUSD | H1 | ohlc_pte71gbp | backtest_pipeline/risultati_archivio/csv_R71 | 28 | 0.83 | 0.91 | 231 | 8.92 | -4767 | 28 (22 uniche) | 1.35 | 1.43 | 272 | 4.07 | 5066 | SI |
| PTE | GBPUSD | H1 | pte73gbp | backtest_pipeline/risultati_archivio/csv_R73 | 14 | 33.56 | 37.21 | 26 | 1.28 | 3341 | 14 | 1.35 | 1.51 | 51 | 3.12 | 1141 | no |
| PTE_Ottimizzato | GBPUSD | H1 | ott74a | backtest_pipeline/risultati_archivio/csv_R74 | 14 | 33.56 | 37.21 | 26 | 1.28 | 3341 | 14 | 1.35 | 1.51 | 51 | 3.12 | 1141 | no |
| larry | NZDCAD | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | 3 | 1.71 | 3.25 | 21 | 2.95 | 262 | 3 | 1.33 | 7.76 | 35 | 4.64 | 388 | no |
| SuperWave | DOW | H1 | Ottimizzato_U30USD_r3 | backtest_pipeline/risultati_prove/ABTG_SuperWave_DOW_H1_Ottimizzato | 5 | 1.44 | 1.85 | 75 | 4.77 | 675 | 5 | 1.33 | 1.61 | 143 | 3.91 | 463 | SI |
| larry | EURCAD | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | 3 | 0.84 | 1.08 | 28 | 6.70 | -158 | 3 | 1.33 | 1.50 | 23 | 3.75 | 282 | no |
| EasyTrend | EURUSD | H1 | ohlc_cal | backtest_pipeline/risultati_prove/ABTG_EasyTrend/cal | 9 | 1.27 | 3.81 | 28 | 3.66 | 324 | 9 | 1.32 | 1.74 | 48 | 4.38 | 678 | no |
| GapFill | U30USD | H1 | r37 | backtest_pipeline/risultati_prove/ABTG_GapFill/r37 | 2 (1 uniche) | 1.52 | 1.52 | 10 | 3.12 | 2072 | 2 (1 uniche) | 1.30 | 1.30 | 20 | 2.87 | 2462 | no |
| SupertrendReversal_Multi_Ottimizzato | XAUUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal_Multi_Ottimizzato | 11 | 0.97 | 6825.88 | 22 | 3.60 | -14 | 11 | 1.30 | 11.43 | 819 | 13.74 | 7968 | SI |
| GoldenCross_Ottimizzato | GBPUSD | [NON MISURATO] | r20 | backtest_pipeline/risultati_prove/GoldenCross_forex_r20 | 6 (2 uniche) | 0.83 | 1.46 | 37 | 5.31 | -154 | 6 (3 uniche) | 1.29 | 1.37 | 55 | 5.01 | 332 | no |
| PTE | USDJPY | H1 | ohlc_pte70jpy | backtest_pipeline/risultati_archivio/csv_R70 | 28 | 0.89 | 0.97 | 121 | 4.86 | -1701 | 28 | 1.29 | 1.43 | 168 | 4.96 | 9341 | SI |
| GapFill | SPXUSD | H1 | r36 | backtest_pipeline/risultati_prove/ABTG_GapFill/r36 | 3 | 0.67 | 0.79 | 10 | 2.66 | -133 | 3 | 1.29 | 1.35 | 20 | 3.95 | 194 | no |
| PTE | USDJPY | H1 | r23c | backtest_pipeline/risultati_prove/ABTG_PTE | 2 (1 uniche) | 1.00 | 1.00 | 33 | 2.50 | 23 | 2 (1 uniche) | 1.29 | 1.29 | 35 | 4.90 | 1564 | no |
| GoldenCross | NZDUSD | [NON MISURATO] | r87bnzd | backtest_pipeline/risultati_archivio/r86_r87_r89_csv | 96 (13 uniche) | 342.47 | 636.56 | 6 | 0.64 | 167 | 132 (59 uniche) | 1.28 | 623.12 | 11 | 2.96 | 82 | no |
| GoldenCross_Ottimizzato | XAUUSD | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_GoldenCross_Ottimizzato | 2 (1 uniche) | 1.51 | 1.51 | 32 | 2.32 | 308 | 2 (1 uniche) | 1.28 | 1.28 | 57 | 6.03 | 336 | no |
| Apertura | DOW | [NON MISURATO] | US_U30USD_r47c | backtest_pipeline/risultati_prove/aperture_r47 | 2 (1 uniche) | 1.22 | 1.22 | 74 | 5.67 | 2812 | 2 (1 uniche) | 1.27 | 1.27 | 130 | 4.39 | 6722 | SI |
| PunteLarry | EURCAD | H1 | r39 | backtest_pipeline/risultati_prove/ABTG_PunteLarry/r39 | 2 (1 uniche) | 1.06 | 1.06 | 15 | 4.53 | 235 | 2 (1 uniche) | 1.26 | 1.26 | 19 | 4.85 | 1401 | no |
| Nightly | XAGUSD | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_Nightly | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 2 (1 uniche) | 1.26 | 1.26 | 4 | 1.66 | 51 | no |
| Apertura | DOW | [NON MISURATO] | US_U30USD_r47d | backtest_pipeline/risultati_prove/aperture_r47 | 2 (1 uniche) | 1.33 | 1.33 | 56 | 5.67 | 4174 | 2 (1 uniche) | 1.26 | 1.26 | 96 | 5.43 | 7343 | no |
| CostToCost | XAGUSD | H4 | r40 | backtest_pipeline/risultati_prove/ABTG_CostToCost/r40 | 3 | 0.48 | 1.45 | 13 | 6.19 | -339 | 3 | 1.25 | 1.39 | 41 | 4.48 | 418 | no |
| EMA200_Ottimizzato | XAUUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_EMA200_Ottimizzato | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 1.25 | 76.59 | 268 | 6.01 | 651 | SI |
| GoldenCross_V1 | XAUUSD | [NON MISURATO] | r87aorov1 | backtest_pipeline/risultati_archivio/r86_r87_r89_csv | 2 (1 uniche) | 1.49 | 1.49 | 32 | 2.28 | 299 | 2 (1 uniche) | 1.25 | 1.25 | 57 | 6.08 | 308 | no |
| GoldenCross_Ottimizzato | XAUUSD | [NON MISURATO] | ABTG_GoldenCross_Ottimizzato | backtest_pipeline/risultati_prove/ABTG_GoldenCross_Ottimizzato | 2 (1 uniche) | 1.49 | 1.49 | 32 | 2.28 | 299 | 2 (1 uniche) | 1.25 | 1.25 | 57 | 6.08 | 308 | no |
| EasyTrend | CHFJPY | H1 | r49a | backtest_pipeline/risultati_prove/ABTG_EasyTrend | 2 (1 uniche) | 1.15 | 1.15 | 31 | 5.66 | 2792 | 2 (1 uniche) | 1.25 | 1.25 | 53 | 6.31 | 7860 | no |
| EasyTrend | CHFJPY | H1 | r48b | backtest_pipeline/risultati_prove/ABTG_EasyTrend/r48 | 6 | 1.09 | 1.72 | 16 | 5.37 | 87 | 6 | 1.25 | 1.71 | 53 | 6.27 | 765 | no |
| ORB | NASUSD | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_ORB | 2 (1 uniche) | 0.95 | 0.95 | 220 | 22.85 | -407 | 2 (1 uniche) | 1.25 | 1.25 | 357 | 11.77 | 2867 | SI |
| PTE | U30USD | TF-OTT | ABTG_PTE | backtest_pipeline/risultati_prove/ABTG_PTE | 16 | 1.25 | 1.78 | 27 | 2.82 | 87 | 16 | 1.25 | 4.10 | 29 | 4.38 | 258 | no |
| SupertrendReversal | 225JPY | TF-OTT | ABTG_SupertrendReversal | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal | 11 | 1.34 | 75.33 | 9 | 0.04 | 2 | 11 | 1.24 | 2.92 | 17 | 0.12 | 6 | no |
| EMA200 | U30USD | H1 | 01_long | backtest_pipeline/prove/R110_CSV_EMADOW | 2 (1 uniche) | 1.16 | 1.16 | 112 | 2.64 | 1844 | 2 (1 uniche) | 1.24 | 1.24 | 241 | 8.90 | 5671 | SI |
| EasyTrend | AUDJPY | H1 | r53 | backtest_pipeline/risultati_archivio/csv_r53 | 16 | 0.81 | 1.17 | 19 | 8.17 | -2336 | 16 | 1.24 | 1.54 | 53 | 6.58 | 7898 | no |
| EasyTrend | GBPUSD | H1 | r48c | backtest_pipeline/risultati_prove/ABTG_EasyTrend/r48 | 6 | 1.00 | 1.32 | 16 | 3.23 | 4 | 6 | 1.23 | 2.04 | 24 | 4.71 | 293 | no |
| PTE | USDJPY | H1 | pte73jpy | backtest_pipeline/risultati_archivio/csv_R73 | 14 | 0.94 | 1.20 | 30 | 2.82 | -237 | 14 (7 uniche) | 1.22 | 1.38 | 43 | 4.21 | 1217 | no |
| BreakingBand | AUDUSD | H1 | r33 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/r33 | 3 | 66.74 | 87.85 | 11 | 0.74 | 333 | 3 | 1.21 | 2.76 | 18 | 1.64 | 65 | no |
| Apertura | DOW | [NON MISURATO] | US_U30USD_ptc | backtest_pipeline/risultati_prove/ABTG_Dow_Apertura_US | 12 (10 uniche) | 1.13 | 1.37 | 150 | 9.07 | 4084 | 12 (6 uniche) | 1.21 | 1.64 | 218 | 9.92 | 8439 | SI |
| Apertura | DOW | [NON MISURATO] | US_U30USD_r6 | backtest_pipeline/risultati_prove/ABTG_Dow_Apertura_US | 6 | 1.14 | 1.38 | 150 | 8.82 | 420 | 6 | 1.20 | 1.68 | 218 | 9.74 | 788 | SI |
| EasyTrend | CHFJPY | H1 | r53 | backtest_pipeline/risultati_archivio/csv_r53 | 16 | 1.22 | 1.48 | 30 | 4.92 | 3800 | 16 | 1.20 | 1.26 | 56 | 7.26 | 6743 | no |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_r118c | backtest_pipeline/risultati_archivio/r118_csv | 10 (9 uniche) | 1.07 | 1.11 | 70 | 4.61 | 70 | 10 (7 uniche) | 1.20 | 1.44 | 311 | 7.93 | 964 | SI |
| GoldenCross_Ottimizzato | XAUUSD | [NON MISURATO] | r87aoro | backtest_pipeline/risultati_archivio/r86_r87_r89_csv | 2 (1 uniche) | 1.72 | 1.72 | 47 | 2.41 | 623 | 2 (1 uniche) | 1.19 | 1.19 | 66 | 6.31 | 304 | no |
| GoldenCross | USDCHF | [NON MISURATO] | r87bchf | backtest_pipeline/risultati_archivio/r86_r87_r89_csv | 80 (36 uniche) | 2.12 | 173.45 | 12 | 2.34 | 192 | 108 (43 uniche) | 1.19 | 3.12 | 13 | 2.48 | 47 | no |
| Apertura_3Ingressi | D30EUR | [NON MISURATO] | r83d1 | backtest_pipeline/risultati_archivio/r83_csv | 2 (1 uniche) | 1.08 | 1.08 | 197 | 7.03 | 282 | 2 (1 uniche) | 1.19 | 1.19 | 311 | 10.60 | 999 | SI |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_r83v | backtest_pipeline/risultati_archivio/r83_csv | 2 (1 uniche) | 1.08 | 1.08 | 197 | 7.03 | 282 | 2 (1 uniche) | 1.19 | 1.19 | 311 | 10.60 | 999 | SI |
| CrossEma | XAUUSD | [NON MISURATO] | r86coro | backtest_pipeline/risultati_archivio/r86_r87_r89_csv | 2 (1 uniche) | 1.11 | 1.11 | 84 | 10.92 | 620 | 2 (1 uniche) | 1.18 | 1.18 | 119 | 12.30 | 1344 | SI |
| PTE | USDJPY | H1 | ohlc_pte71jpy | backtest_pipeline/risultati_archivio/csv_R71 | 28 | 0.67 | 0.72 | 253 | 9.55 | -7293 | 28 | 1.18 | 1.31 | 189 | 8.50 | 6380 | SI |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | r14 | backtest_pipeline/risultati_prove/ABTG_ORB_Ottimizzato | 24 | 1.12 | 1.64 | 134 | 13.06 | 1045 | 24 | 1.17 | 1.40 | 119 | 17.04 | 1510 | SI |
| PTE | U30USD | H1 | r23a | backtest_pipeline/risultati_prove/ABTG_PTE | 2 (1 uniche) | 1.18 | 1.18 | 28 | 3.24 | 716 | 2 (1 uniche) | 1.17 | 1.17 | 40 | 3.22 | 1093 | no |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | r15 | backtest_pipeline/risultati_prove/ABTG_ORB_Ottimizzato | 64 (62 uniche) | 0.99 | 1.64 | 107 | 5.07 | -19 | 64 (62 uniche) | 1.17 | 1.68 | 172 | 12.35 | 945 | SI |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_r51 | backtest_pipeline/risultati_archivio/csv_r51 | 4 (2 uniche) | 1.05 | 1.08 | 313 | 8.79 | 2763 | 4 (2 uniche) | 1.17 | 1.17 | 332 | 10.75 | 9062 | SI |
| GoldenCross | NZDUSD | [NON MISURATO] | r87anzd | backtest_pipeline/risultati_archivio/r86_r87_r89_csv | 2 (1 uniche) | 3.56 | 3.56 | 10 | 1.10 | 200 | 2 (1 uniche) | 1.16 | 1.16 | 22 | 4.68 | 86 | no |
| F_gestione | DAX | [NON MISURATO] | Walkforward_Aperture | backtest_pipeline/risultati_archivio/Walkforward_Aperture | 8 (6 uniche) | 0.99 | 1.11 | 255 | 8.52 | -23 | 8 (6 uniche) | 1.16 | 1.29 | 230 | 11.65 | 834 | SI |
| PTE | GBPUSD | H1 | ohlc_tetto | backtest_pipeline/risultati_archivio/csv_R76 | 28 | 0.88 | 0.93 | 461 | 21.07 | -9372 | 28 | 1.16 | 1.25 | 655 | 8.96 | 7824 | SI |
| CrossEma | XAUUSD | [NON MISURATO] | r86doro | backtest_pipeline/risultati_archivio/r86_r87_r89_csv | 2 (1 uniche) | 0.92 | 0.92 | 171 | 13.97 | -768 | 2 (1 uniche) | 1.16 | 1.16 | 270 | 15.80 | 2431 | SI |
| PTE | U30USD | H1 | r55a | backtest_pipeline/risultati_archivio/csv_r55 | 10 (5 uniche) | 1.17 | 1.18 | 28 | 3.24 | 701 | 10 (5 uniche) | 1.15 | 1.17 | 40 | 3.27 | 998 | no |
| GoldenCross | XAUUSD | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_GoldenCross | 2 (1 uniche) | 1.49 | 1.49 | 31 | 2.31 | 277 | 2 (1 uniche) | 1.15 | 1.15 | 52 | 5.70 | 180 | no |
| SuperWave | GBPUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_SuperWave | 11 | 1.25 | 909.74 | 141 | 2.32 | 262 | 11 | 1.15 | 2.20 | 30 | 1.66 | 31 | no |
| GapFill | 225JPY | H1 | r37 | backtest_pipeline/risultati_prove/ABTG_GapFill/r37 | 2 (1 uniche) | 3.20 | 3.20 | 11 | 1.33 | 4573 | 2 (1 uniche) | 1.14 | 1.14 | 15 | 4.36 | 812 | no |
| SupertrendReversal_Multi_Ottimizzato | XAUUSD | TF-OTT | ABTG_SupertrendReversal_Multi_Ottimizzato | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal_Multi_Ottimizzato | 11 | 0.89 | 6831.75 | 22 | 3.66 | -56 | 11 | 1.14 | 8.43 | 882 | 18.48 | 3645 | SI |
| CostToCost | XAGUSD | H4 | r41 | backtest_pipeline/risultati_prove/ABTG_CostToCost/r41 | 2 (1 uniche) | 1.41 | 1.41 | 10 | 3.69 | 1251 | 2 (1 uniche) | 1.14 | 1.14 | 41 | 4.43 | 2253 | no |
| M_direzione | DAX | [NON MISURATO] | Walkforward_Aperture | backtest_pipeline/risultati_archivio/Walkforward_Aperture | 9 | 0.97 | 1.16 | 215 | 5.46 | -102 | 9 | 1.14 | 1.42 | 266 | 8.54 | 698 | SI |
| EMA200 | EURUSD | H1 | r29a | backtest_pipeline/risultati_prove/ABTG_EMA200 | 30 | 1.11 | 1.22 | 431 | 8.36 | 422 | 30 | 1.13 | 1.22 | 754 | 10.15 | 844 | SI |
| GoldenCross_Ottimizzato | D30EUR | [NON MISURATO] | r4 | backtest_pipeline/risultati_prove/ABTG_GoldenCross_Ottimizzato | 2 (1 uniche) | 0.51 | 0.51 | 32 | 4.28 | -386 | 2 (1 uniche) | 1.13 | 1.13 | 60 | 3.92 | 133 | no |
| Apertura | DOW | [NON MISURATO] | US_U30USD_r46b | backtest_pipeline/risultati_prove/aperture_r46 | 8 (6 uniche) | 1.04 | 1.33 | 56 | 6.79 | 807 | 8 (6 uniche) | 1.13 | 1.27 | 96 | 9.39 | 5386 | no |
| PTE | NASUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_PTE | 16 | 1.01 | 1.61 | 12 | 2.81 | 3 | 16 | 1.13 | 196.88 | 38 | 3.74 | 94 | no |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | r88b | backtest_pipeline/risultati_archivio/r88_csv | 8 (5 uniche) | 0.73 | 1.25 | 116 | 20.29 | -15005 | 8 (5 uniche) | 1.12 | 1.67 | 136 | 11.96 | 9626 | SI |
| EMA200_Ottimizzato | XAUUSD | TF-OTT | ABTG_EMA200_Ottimizzato | backtest_pipeline/risultati_prove/ABTG_EMA200_Ottimizzato | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 1.12 | 2.53 | 292 | 8.23 | 343 | SI |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR | backtest_pipeline/risultati_prove/ABTG_DAX_Apertura_EU | 25 | 1.04 | 1.23 | 197 | 8.36 | 201 | 25 | 1.12 | 1.69 | 296 | 11.84 | 771 | SI |
| ORB_Ottimizzato | NASUSD | [NON MISURATO] | r44b | backtest_pipeline/risultati_prove/ABTG_ORB_Ottimizzato/r44 | 4 | 1.06 | 1.10 | 74 | 23.86 | 360 | 4 | 1.11 | 1.16 | 135 | 19.05 | 1306 | SI |
| SuperWave | GBPUSD | TF-OTT | ABTG_SuperWave | backtest_pipeline/risultati_prove/ABTG_SuperWave | 11 | 1.15 | 909.26 | 141 | 2.39 | 162 | 11 | 1.10 | 2.09 | 30 | 1.70 | 22 | no |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_r35 | backtest_pipeline/risultati_prove/aperture_r35 | 10 | 1.13 | 1.31 | 175 | 5.36 | 381 | 10 | 1.10 | 1.42 | 272 | 9.33 | 494 | SI |
| WOL | U30USD | TF-OTT | ABTG_WOL | backtest_pipeline/risultati_prove/ABTG_WOL | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 1.10 | 64.29 | 68 | 0.25 | 4 | no |
| CanaleLento | XAUUSD | D1 | ohlc_cl1 | backtest_pipeline/risultati_archivio/Notte_16-08 | 20 | 0.87 | 1.12 | 57 | 9.29 | -3318 | 20 | 1.10 | 2.02 | 60 | 6.93 | 1659 | no |
| PTE | NASUSD | TF-OTT | ABTG_PTE | backtest_pipeline/risultati_prove/ABTG_PTE | 16 | 0.91 | 1.55 | 9 | 2.58 | -34 | 16 | 1.10 | 170.65 | 38 | 3.81 | 74 | no |
| PTE | GBPUSD | H1 | ohlc_pte2 | backtest_pipeline/risultati_archivio/PTE_accoppiamento | 28 | 1.05 | 1.17 | 312 | 6.66 | 2179 | 28 | 1.10 | 1.21 | 477 | 8.53 | 3117 | SI |
| Apertura | DOW | [NON MISURATO] | US_U30USD_r54a | backtest_pipeline/risultati_archivio/csv_r54 | 6 (3 uniche) | 1.37 | 1.51 | 147 | 5.53 | 9461 | 6 (3 uniche) | 1.10 | 1.27 | 203 | 8.68 | 3927 | SI |
| PTE_Ottimizzato | USDJPY | H1 | ott74jpy | backtest_pipeline/risultati_archivio/csv_R74 | 14 | 1.05 | 1.43 | 30 | 2.53 | 212 | 14 (7 uniche) | 1.09 | 1.43 | 42 | 4.83 | 600 | no |
| BreakingBand | NZDJPY | H1 | r33 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/r33 | 3 | 148.69 | 152.12 | 6 | 0.75 | 294 | 3 | 1.08 | 1.15 | 14 | 2.32 | 18 | no |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_ptd | backtest_pipeline/risultati_prove/ABTG_DAX_Apertura_EU | 360 (180 uniche) | 0.92 | 1.44 | 151 | 8.51 | -2530 | 360 (180 uniche) | 1.08 | 1.41 | 240 | 7.46 | 3745 | SI |
| PTE | GBPUSD | H1 | ohlc_pte1 | backtest_pipeline/risultati_archivio/PTE_accoppiamento | 32 | 0.97 | 1.17 | 282 | 9.52 | -1401 | 32 | 1.08 | 1.20 | 468 | 10.05 | 2734 | SI |
| Apertura | NASDAQ | [NON MISURATO] | US_NASUSD_r30 | backtest_pipeline/risultati_prove/ABTG_Nasdaq_Apertura_US | 4 | 1.04 | 1.27 | 50 | 3.01 | 33 | 4 | 1.07 | 1.36 | 86 | 4.40 | 84 | no |
| SupertrendReversal | AUDUSD | H4 | r21 | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal | 12 (11 uniche) | 0.60 | 0.88 | 37 | 4.42 | -251 | 12 | 1.07 | 2.11 | 27 | 2.65 | 22 | no |
| SupertrendReversal | AUDUSD | H4 | r21 | backtest_pipeline/risultati_prove/SupRev_H4_r21 | 12 (11 uniche) | 0.60 | 0.88 | 37 | 4.42 | -251 | 12 | 1.07 | 2.11 | 27 | 2.65 | 22 | no |
| GoldenCross | XAUUSD | [NON MISURATO] | ABTG_GoldenCross | backtest_pipeline/risultati_prove/ABTG_GoldenCross | 2 (1 uniche) | 1.47 | 1.47 | 31 | 2.27 | 267 | 2 (1 uniche) | 1.07 | 1.07 | 52 | 5.75 | 80 | no |
| GoldenCross | USDCAD | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_GoldenCross | 2 (1 uniche) | 0.87 | 0.87 | 40 | 4.45 | -135 | 2 (1 uniche) | 1.06 | 1.06 | 49 | 4.70 | 53 | no |
| PTE | USDJPY | H1 | ohlc_pte2jpy | backtest_pipeline/risultati_archivio/csv_R69 | 28 | 0.65 | 0.69 | 268 | 18.29 | -17529 | 28 | 1.06 | 1.17 | 307 | 15.27 | 4965 | SI |
| LiquiditySweep | GBPUSD | [NON MISURATO] | r89agbp | backtest_pipeline/risultati_archivio/r86_r87_r89_csv | 2 (1 uniche) | 0.23 | 0.23 | 14 | 7.74 | -637 | 2 (1 uniche) | 1.06 | 1.06 | 24 | 5.87 | 74 | no |
| LVNArbitro | U30USD | [NON MISURATO] | P0_100K | backtest_pipeline/risultati_prove/ABTG_LVNArbitro | 2 (1 uniche) | 0.97 | 0.97 | 392 | 19.35 | -3375 | 2 (1 uniche) | 1.05 | 1.05 | 618 | 11.76 | 11311 | SI |
| LVNArbitro | U30USD | [NON MISURATO] | P0CONTA | backtest_pipeline/risultati_prove/ABTG_LVNArbitro | 2 (1 uniche) | 0.98 | 0.98 | 392 | 18.01 | -265 | 2 (1 uniche) | 1.05 | 1.05 | 618 | 11.33 | 1022 | SI |
| GapContinuation | 225JPY | [NON MISURATO] | ohlc_gc2 | backtest_pipeline/risultati_archivio/GapContinuation | 25 (15 uniche) | 1.02 | 1.74 | 30 | 4.05 | 160 | 25 (20 uniche) | 1.05 | 1.69 | 36 | 8.46 | 664 | no |
| EMA200 | AUDJPY | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_EMA200 | 11 | 1.02 | 2.54 | 373 | 10.55 | 79 | 11 | 1.05 | 336.02 | 134 | 8.43 | 75 | SI |
| EMA200 | XAUUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_EMA200 | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 1.05 | 2.17 | 1189 | 14.80 | 554 | SI |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | r54b | backtest_pipeline/risultati_archivio/csv_r54 | 6 (3 uniche) | 0.96 | 1.25 | 135 | 11.48 | -2822 | 6 (3 uniche) | 1.05 | 1.67 | 219 | 17.16 | 5526 | SI |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | r88c3 | backtest_pipeline/risultati_archivio/r88_csv | 4 (2 uniche) | 0.83 | 0.91 | 66 | 8.76 | -5595 | 4 (2 uniche) | 1.05 | 1.06 | 123 | 12.61 | 2636 | SI |
| EMA200 | GBPUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_EMA200 | 11 | 1.17 | 3.08 | 123 | 4.42 | 212 | 11 | 1.04 | 2.09 | 55 | 2.98 | 24 | no |
| Apertura_3Ingressi | D30EUR | [NON MISURATO] | r83d0 | backtest_pipeline/risultati_archivio/r83_csv | 2 (1 uniche) | 1.05 | 1.05 | 220 | 7.93 | 204 | 2 (1 uniche) | 1.04 | 1.04 | 325 | 13.26 | 251 | SI |
| Nightly | GBPUSD | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_Nightly | 2 (1 uniche) | 0.59 | 0.59 | 96 | 22.62 | -2115 | 2 (1 uniche) | 1.04 | 1.04 | 163 | 11.28 | 320 | SI |
| EMA200 | SPXUSD | H4 | r3 | backtest_pipeline/risultati_prove/ABTG_EMA200 | 5 | 1.80 | 2.46 | 20 | 1.38 | 144 | 5 | 1.04 | 1.60 | 103 | 3.37 | 37 | SI |
| CrossEma | XAUUSD | [NON MISURATO] | r86aoro | backtest_pipeline/risultati_archivio/r86_r87_r89_csv | 2 (1 uniche) | 0.82 | 0.82 | 138 | 21.77 | -1608 | 2 (1 uniche) | 1.03 | 1.03 | 197 | 15.56 | 372 | SI |
| PTE | GBPUSD | H1 | ohlc_pte78gbp | backtest_pipeline/risultati_archivio/csv_R78 | 14 | 0.81 | 0.91 | 431 | 15.18 | -10975 | 14 | 1.03 | 1.10 | 459 | 13.82 | 1871 | SI |
| ORB_Ottimizzato | NASUSD | [NON MISURATO] | r13 | backtest_pipeline/risultati_prove/ABTG_ORB_Ottimizzato | 48 | 0.92 | 1.22 | 127 | 32.74 | -682 | 48 | 1.03 | 1.16 | 217 | 32.57 | 542 | SI |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_r46a | backtest_pipeline/risultati_prove/aperture_r46 | 8 (6 uniche) | 1.19 | 1.54 | 214 | 8.18 | 9456 | 8 (6 uniche) | 1.03 | 1.49 | 278 | 8.74 | 2281 | SI |
| BreakingBand | GBPUSD | H1 | r91a | backtest_pipeline/risultati_archivio/r91_csv | 2 | 2.34 | 2.73 | 5 | 1.20 | 1417 | 2 | 1.02 | 1.73 | 10 | 2.04 | 71 | no |
| CrossEma | D30EUR | [NON MISURATO] | r86cdax | backtest_pipeline/risultati_archivio/r86_r87_r89_csv | 2 (1 uniche) | 0.81 | 0.81 | 78 | 18.42 | -1012 | 2 (1 uniche) | 1.02 | 1.02 | 123 | 12.90 | 165 | SI |
| EMA200 | GBPUSD | TF-OTT | ABTG_EMA200 | backtest_pipeline/risultati_prove/ABTG_EMA200 | 11 | 0.84 | 3.64 | 289 | 14.06 | -681 | 11 | 1.02 | 1.89 | 262 | 9.77 | 48 | SI |
| SupRev | NAS | H1 | Ottimizzato_NASUSD_r3 | backtest_pipeline/risultati_prove/ABTG_SupRev_NAS_H1_Ottimizzato | 5 | 0.91 | 1.37 | 78 | 1.75 | -46 | 5 | 1.01 | 1.69 | 154 | 3.12 | 13 | SI |
| Apertura | NASDAQ | [NON MISURATO] | US_NASUSD_r24 | backtest_pipeline/risultati_prove/ABTG_Nasdaq_Apertura_US | 25 | 1.04 | 1.23 | 55 | 5.74 | 53 | 25 (24 uniche) | 1.01 | 1.27 | 98 | 4.82 | 31 | no |
| SuperWave | U30USD | TF-OTT | ABTG_SuperWave | backtest_pipeline/risultati_prove/ABTG_SuperWave | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 1.01 | 12642.00 | 551 | 8.49 | 75 | SI |
| F_gestione | NASDAQ | [NON MISURATO] | Walkforward_Aperture | backtest_pipeline/risultati_archivio/Walkforward_Aperture | 8 (6 uniche) | 0.91 | 0.95 | 262 | 12.72 | -337 | 8 (6 uniche) | 1.00 | 1.02 | 362 | 7.49 | 20 | SI |
| H_drawdown | DAX | [NON MISURATO] | Walkforward_Aperture | backtest_pipeline/risultati_archivio/Walkforward_Aperture | 16 | 0.96 | 1.18 | 206 | 7.58 | -248 | 16 | 1.00 | 1.12 | 292 | 19.80 | 32 | SI |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_r118b | backtest_pipeline/risultati_archivio/r118_csv | 50 (35 uniche) | 0.98 | 1.10 | 188 | 7.54 | -75 | 50 (35 uniche) | 0.99 | 1.15 | 307 | 14.97 | -30 | SI |
| ORB_Ottimizzato | D30EUR | [NON MISURATO] | r11 | backtest_pipeline/risultati_prove/ABTG_ORB_Ottimizzato | 4 | 1.23 | 1.44 | 115 | 6.54 | 1474 | 4 | 0.99 | 1.02 | 233 | 19.59 | -74 | SI |
| GoldenCross_Ottimizzato | XAUUSD | [NON MISURATO] | r2 | backtest_pipeline/risultati_prove/ABTG_GoldenCross_Ottimizzato | 4 (3 uniche) | 1.49 | 1.58 | 32 | 2.28 | 299 | 4 (3 uniche) | 0.99 | 1.25 | 45 | 6.04 | -7 | no |
| PTE_Ottimizzato | U30USD | H1 | ohlc_ott74dow | backtest_pipeline/risultati_archivio/csv_R74 | 14 (13 uniche) | 1.51 | 2.57 | 30 | 1.82 | 1001 | 14 | 0.99 | 1.47 | 41 | 2.93 | -56 | no |
| SupertrendReversal_Ottimizzato | XAUUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal_Ottimizzato | 11 | 1.00 | 6163.50 | 320 | 10.13 | -6 | 11 | 0.99 | 2.42 | 268 | 6.78 | -45 | SI |
| D_retest | DAX | [NON MISURATO] | Walkforward_Aperture | backtest_pipeline/risultati_archivio/Walkforward_Aperture | 20 | 1.00 | 1.27 | 178 | 9.79 | 1 | 20 | 0.99 | 1.20 | 235 | 14.69 | -77 | SI |
| PTE | GBPUSD | H1 | ohlc_pte79gbp | backtest_pipeline/risultati_archivio/csv_R79 | 6 | 0.79 | 1.06 | 414 | 20.39 | -14808 | 6 | 0.98 | 1.14 | 240 | 9.71 | -620 | SI |
| ORB | NASUSD | [NON MISURATO] | r8 | backtest_pipeline/risultati_prove/ABTG_ORB | 4 | 1.07 | 1.49 | 248 | 4.52 | 211 | 4 | 0.98 | 1.03 | 381 | 6.65 | -64 | SI |
| Apertura_3Ingressi | D30EUR | [NON MISURATO] | r83d2 | backtest_pipeline/risultati_archivio/r83_csv | 2 (1 uniche) | 0.80 | 0.80 | 212 | 8.97 | -767 | 2 (1 uniche) | 0.98 | 0.98 | 322 | 8.69 | -83 | SI |
| BreakoutCorso | GBPJPY | M15 | ohlc_r82c | backtest_pipeline/risultati_archivio/r82_csv | 2 (1 uniche) | 0.94 | 0.94 | 264 | 17.98 | -704 | 2 (1 uniche) | 0.98 | 0.98 | 1467 | 46.63 | -1684 | SI |
| GoldenCross_Ottimizzato | NASUSD | [NON MISURATO] | r4 | backtest_pipeline/risultati_prove/ABTG_GoldenCross_Ottimizzato | 2 (1 uniche) | 0.55 | 0.55 | 28 | 4.07 | -255 | 2 (1 uniche) | 0.98 | 0.98 | 64 | 5.04 | -23 | no |
| Apertura_3Ingressi | NASUSD | [NON MISURATO] | r83n2 | backtest_pipeline/risultati_archivio/r83_csv | 2 (1 uniche) | 0.70 | 0.70 | 198 | 9.48 | -942 | 2 (1 uniche) | 0.98 | 0.98 | 313 | 6.18 | -92 | SI |
| SuperWave | DOW | H1 | Ottimizzato_U30USD_ohlc | backtest_pipeline/risultati_prove/ABTG_SuperWave_DOW_H1_Ottimizzato | 10 | 1.20 | 6.46 | 9 | 2.59 | 29 | 11 | 0.98 | 1.38 | 640 | 9.85 | -138 | SI |
| SuperWave | U30USD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_SuperWave | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 0.98 | 2.47 | 290 | 8.43 | -76 | SI |
| CrossEma | D30EUR | [NON MISURATO] | r86ddax | backtest_pipeline/risultati_archivio/r86_r87_r89_csv | 2 (1 uniche) | 0.84 | 0.84 | 150 | 26.12 | -1500 | 2 (1 uniche) | 0.97 | 0.97 | 267 | 14.39 | -420 | SI |
| Apertura | NASDAQ | [NON MISURATO] | US_NASUSD_r84c | backtest_pipeline/risultati_archivio/r84_csv | 2 (1 uniche) | 1.28 | 1.28 | 89 | 3.45 | 349 | 2 (1 uniche) | 0.97 | 0.97 | 180 | 6.73 | -92 | SI |
| SuperWave | XAUUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_SuperWave | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 0.97 | 1540.50 | 11 | 2.30 | -10 | no |
| Nightly | USDCHF | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_Nightly | 2 (1 uniche) | 0.86 | 0.86 | 81 | 11.42 | -620 | 2 (1 uniche) | 0.97 | 0.97 | 131 | 14.16 | -206 | SI |
| ORB_Fibo | NASUSD | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_ORB_Fibo | 2 (1 uniche) | 0.84 | 0.84 | 91 | 3.02 | -157 | 2 (1 uniche) | 0.97 | 0.97 | 75 | 3.10 | -28 | no |
| SuperWave | XAUUSD | TF-OTT | ABTG_SuperWave | backtest_pipeline/risultati_prove/ABTG_SuperWave | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 0.97 | 1541.00 | 11 | 2.27 | -11 | no |
| SupRev | DOW | H4 | Ottimizzato_U30USD_ohlc | backtest_pipeline/risultati_prove/ABTG_SupRev_DOW_H4_Ottimizzato | 10 | 0.86 | 4.84 | 21 | 3.82 | -50 | 10 | 0.97 | 2.37 | 57 | 3.97 | -24 | no |
| IBRetest | D30EUR | [NON MISURATO] | P0IBRTDAX | backtest_pipeline/risultati_prove/ibretest_p0 | 2 (1 uniche) | 1.21 | 1.21 | 58 | 2.80 | 261 | 2 (1 uniche) | 0.96 | 0.96 | 107 | 5.25 | -84 | SI |
| Live5m | NASDAQ | [NON MISURATO] | NASUSD | backtest_pipeline/risultati_prove/ABTG_Nasdaq_Live5m | 2 (1 uniche) | 1.02 | 1.02 | 116 | 11.52 | 99 | 2 (1 uniche) | 0.96 | 0.96 | 175 | 19.40 | -327 | SI |
| GapFill | U30USD | H1 | r36 | backtest_pipeline/risultati_prove/ABTG_GapFill/r36 | 3 | 1.23 | 1.63 | 10 | 2.92 | 86 | 3 | 0.96 | 1.30 | 20 | 2.86 | -28 | no |
| SondaOrologio | D30EUR | [NON MISURATO] | 12_short | backtest_pipeline/risultati_archivio/orologio_indici_csv | 66 | 0.56 | 1.65 | 29 | 0.86 | -636 | 69 (67 uniche) | 0.96 | 2.49 | 14 | 0.13 | -7 | no |
| B_motore | NASDAQ | [NON MISURATO] | faseB_v1 | backtest_pipeline/risultati_archivio/Walkforward_Aperture/faseB_v1 | 11 (8 uniche) | 0.89 | 1.82 | 182 | 15.70 | -467 | 10 (7 uniche) | 0.96 | 1.11 | 104 | 6.72 | -145 | SI |
| PTE | USDJPY | H1 | ohlc_pte78jpy | backtest_pipeline/risultati_archivio/csv_R78 | 14 | 1.02 | 1.15 | 415 | 11.40 | 975 | 14 | 0.95 | 1.01 | 482 | 16.06 | -2317 | SI |
| EMA200 | XAUUSD | TF-OTT | ABTG_EMA200 | backtest_pipeline/risultati_prove/ABTG_EMA200 | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 0.95 | 2.29 | 1691 | 18.61 | -770 | SI |
| Apertura | NASDAQ | [NON MISURATO] | US_NASUSD_r84b | backtest_pipeline/risultati_archivio/r84_csv | 2 (1 uniche) | 0.88 | 0.88 | 62 | 5.86 | -175 | 2 (1 uniche) | 0.95 | 0.95 | 92 | 4.59 | -85 | no |
| B_motore | NASDAQ | [NON MISURATO] | Walkforward_Aperture | backtest_pipeline/risultati_archivio/Walkforward_Aperture | 12 (11 uniche) | 1.07 | 2.08 | 114 | 5.84 | 148 | 12 (11 uniche) | 0.95 | 1.94 | 244 | 9.60 | -282 | SI |
| EMA200 | XAUUSD | H1 | r32a | backtest_pipeline/risultati_prove/ABTG_EMA200 | 30 | 0.68 | 0.85 | 292 | 13.01 | -984 | 30 | 0.94 | 1.11 | 387 | 10.18 | -203 | SI |
| LiquiditySweep | GBPUSD | [NON MISURATO] | r89bgbp | backtest_pipeline/risultati_archivio/r86_r87_r89_csv | 9 (4 uniche) | 0.00 | 0.00 | 4 | 3.75 | -215 | 9 (4 uniche) | 0.94 | 1.39 | 4 | 3.53 | -13 | no |
| GoldenCross | USDCAD | [NON MISURATO] | r87bcad | backtest_pipeline/risultati_archivio/r86_r87_r89_csv | 124 (20 uniche) | 0.31 | 80.93 | 8 | 2.71 | -152 | 96 (18 uniche) | 0.94 | 4.83 | 9 | 1.81 | -15 | no |
| SupRev | NAS | H1 | Ottimizzato_NASUSD_ohlc | backtest_pipeline/risultati_prove/ABTG_SupRev_NAS_H1_Ottimizzato | 10 | 0.65 | 4.24 | 144 | 6.04 | -431 | 11 | 0.94 | 3.95 | 316 | 6.16 | -141 | SI |
| SupRev | DAX | H4 | Ottimizzato_D30EUR_ohlc | backtest_pipeline/risultati_prove/ABTG_SupRev_DAX_H4_Ottimizzato | 11 | 0.80 | 4.46 | 303 | 8.64 | -673 | 11 | 0.93 | 15.79 | 665 | 13.71 | -559 | SI |
| EMA200 | SPXUSD | TF-OTT | ABTG_EMA200 | backtest_pipeline/risultati_prove/ABTG_EMA200 | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 0.93 | 2.38 | 920 | 15.29 | -531 | SI |
| WOL | XAUUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_WOL | 11 | 0.09 | 0.62 | 99 | 3.22 | -305 | 11 | 0.93 | 135.36 | 31 | 0.17 | -1 | no |
| PTE | USDJPY | H1 | ohlc_pte79jpy | backtest_pipeline/risultati_archivio/csv_R79 | 6 | 1.07 | 1.15 | 230 | 4.58 | 2678 | 6 | 0.93 | 0.98 | 482 | 15.66 | -3671 | SI |
| EMA200 | SPXUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_EMA200 | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 0.93 | 2.20 | 38 | 2.44 | -28 | no |
| Live5m | DAX | [NON MISURATO] | v2_D30EUR | backtest_pipeline/risultati_prove/ABTG_DAX_Live5m_v2 | 2 (1 uniche) | 1.01 | 1.01 | 80 | 4.70 | 11 | 2 (1 uniche) | 0.92 | 0.92 | 202 | 14.16 | -394 | SI |
| Apertura | NASDAQ | [NON MISURATO] | US_NASUSD_r84d | backtest_pipeline/risultati_archivio/r84_csv | 2 (1 uniche) | 1.51 | 1.51 | 110 | 3.02 | 858 | 2 (1 uniche) | 0.92 | 0.92 | 201 | 6.92 | -287 | SI |
| CrossEma | D30EUR | [NON MISURATO] | r86adax | backtest_pipeline/risultati_archivio/r86_r87_r89_csv | 2 (1 uniche) | 0.95 | 0.95 | 113 | 17.69 | -394 | 2 (1 uniche) | 0.92 | 0.92 | 204 | 20.43 | -1009 | SI |
| SupRev | DOW | H4 | Ottimizzato_U30USD | backtest_pipeline/risultati_prove/ABTG_SupRev_DOW_H4_Ottimizzato | 10 | 0.74 | 4.93 | 324 | 14.05 | -1124 | 10 | 0.92 | 2.32 | 27 | 2.96 | -27 | no |
| SuperWave | USDJPY | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_SuperWave | 11 | 1.04 | 11.66 | 208 | 7.40 | 62 | 11 | 0.92 | 1.70 | 287 | 3.91 | -182 | SI |
| SupertrendReversal_Ottimizzato | XAUUSD | TF-OTT | ABTG_SupertrendReversal_Ottimizzato | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal_Ottimizzato | 11 | 0.90 | 6163.50 | 270 | 11.43 | -458 | 11 | 0.92 | 2.25 | 268 | 7.42 | -311 | SI |
| EMA200 | AUDJPY | TF-OTT | ABTG_EMA200 | backtest_pipeline/risultati_prove/ABTG_EMA200 | 11 | 0.97 | 2.52 | 415 | 11.55 | -166 | 11 | 0.91 | 335.62 | 138 | 10.44 | -143 | SI |
| A_geometria | DAX | [NON MISURATO] | Walkforward_Aperture | backtest_pipeline/risultati_archivio/Walkforward_Aperture | 20 | 1.15 | 1.45 | 179 | 8.58 | 761 | 20 | 0.91 | 1.17 | 250 | 17.14 | -609 | SI |
| FiboH4_Multi | XAUUSD | H4 | ohlc | backtest_pipeline/risultati_prove/ABTG_FiboH4_Multi | 6 (3 uniche) | 0.59 | 0.62 | 67 | 6.15 | -537 | 6 (3 uniche) | 0.91 | 1.28 | 65 | 3.98 | -108 | no |
| SupertrendReversal | XAUUSD | H3 | r3 | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal | 5 | 0.71 | 2.12 | 4 | 0.56 | -19 | 5 | 0.91 | 4.42 | 33 | 1.94 | -44 | no |
| PTE | USDJPY | H1 | ohlc_pte77jpy | backtest_pipeline/risultati_archivio/csv_R77 | 28 | 0.92 | 1.05 | 461 | 14.20 | -6161 | 28 | 0.91 | 0.98 | 556 | 18.73 | -6754 | SI |
| B_motore | DAX | [NON MISURATO] | faseB_v1 | backtest_pipeline/risultati_archivio/Walkforward_Aperture/faseB_v1 | 10 (7 uniche) | 1.17 | 1.37 | 180 | 10.44 | 807 | 10 (7 uniche) | 0.90 | 1.07 | 233 | 14.28 | -508 | SI |
| B_motore | DAX | [NON MISURATO] | Walkforward_Aperture | backtest_pipeline/risultati_archivio/Walkforward_Aperture | 12 (11 uniche) | 1.11 | 1.37 | 58 | 3.00 | 180 | 12 (11 uniche) | 0.90 | 1.11 | 233 | 14.28 | -508 | SI |
| BreakoutCorso | EURJPY | M15 | ohlc_r82b | backtest_pipeline/risultati_archivio/r82_csv | 2 (1 uniche) | 1.11 | 1.11 | 895 | 24.75 | 5476 | 2 (1 uniche) | 0.90 | 0.90 | 2068 | 70.11 | -6108 | SI |
| BreakingBand | EURUSD | H1 | ohlc_cal1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/cal1 | 12 | 0.97 | 1.90 | 13 | 1.55 | -9 | 12 (6 uniche) | 0.90 | 1.32 | 28 | 3.05 | -64 | no |
| SupRev | NAS | H1 | Ottimizzato_NASUSD | backtest_pipeline/risultati_prove/ABTG_SupRev_NAS_H1_Ottimizzato | 10 | 0.58 | 4.23 | 18 | 0.90 | -46 | 11 | 0.89 | 3.57 | 320 | 7.34 | -237 | no |
| ORB | NASUSD | [NON MISURATO] | r7a | backtest_pipeline/risultati_prove/ABTG_ORB | 4 | 0.81 | 0.82 | 194 | 5.40 | -382 | 4 | 0.89 | 1.05 | 286 | 7.23 | -320 | no |
| M_direzione | NASDAQ | [NON MISURATO] | Walkforward_Aperture | backtest_pipeline/risultati_archivio/Walkforward_Aperture | 9 | 0.93 | 1.17 | 220 | 11.55 | -262 | 9 | 0.89 | 1.13 | 213 | 6.28 | -399 | no |
| EMA200 | 200AUD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_EMA200 | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 0.89 | 1.70 | 201 | 8.01 | -175 | no |
| BreakoutCorso | USDJPY | M15 | ohlc_r82a | backtest_pipeline/risultati_archivio/r82_csv | 2 (1 uniche) | 0.78 | 0.78 | 927 | 70.13 | -6643 | 2 (1 uniche) | 0.88 | 0.88 | 2138 | 80.99 | -7765 | no |
| L_rangemode | DAX | [NON MISURATO] | Walkforward_Aperture | backtest_pipeline/risultati_archivio/Walkforward_Aperture | 6 (4 uniche) | 1.00 | 1.11 | 224 | 8.41 | -9 | 6 (4 uniche) | 0.88 | 1.24 | 326 | 14.94 | -748 | no |
| ORB_Ottimizzato | XAUUSD | [NON MISURATO] | r10 | backtest_pipeline/risultati_prove/ABTG_ORB_Ottimizzato | 4 | 0.64 | 1.00 | 95 | 6.00 | -469 | 4 | 0.88 | 1.00 | 371 | 8.57 | -452 | no |
| PTE | XAUUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_PTE | 16 | 1.48 | 644.68 | 25 | 3.76 | 238 | 16 | 0.88 | 3.98 | 7 | 2.79 | -43 | no |
| CrossEma | D30EUR | [NON MISURATO] | r86bdax | backtest_pipeline/risultati_archivio/r86_r87_r89_csv | 2 (1 uniche) | 1.09 | 1.09 | 44 | 9.34 | 275 | 2 (1 uniche) | 0.87 | 0.87 | 93 | 16.43 | -771 | no |
| Apertura_3Ingressi | NASUSD | [NON MISURATO] | r83n0 | backtest_pipeline/risultati_archivio/r83_csv | 2 (1 uniche) | 1.25 | 1.25 | 156 | 6.14 | 686 | 2 (1 uniche) | 0.87 | 0.87 | 291 | 17.07 | -795 | no |
| Apertura | NASDAQ | [NON MISURATO] | US_NASUSD_r84a | backtest_pipeline/risultati_archivio/r84_csv | 2 (1 uniche) | 1.25 | 1.25 | 156 | 6.14 | 686 | 2 (1 uniche) | 0.87 | 0.87 | 291 | 17.07 | -795 | no |
| D_retest | NASDAQ | [NON MISURATO] | Walkforward_Aperture | backtest_pipeline/risultati_archivio/Walkforward_Aperture | 20 | 0.76 | 1.00 | 184 | 22.32 | -1408 | 20 | 0.87 | 1.05 | 219 | 10.57 | -585 | no |
| SuperWave | DOW | H1 | Ottimizzato_U30USD | backtest_pipeline/risultati_prove/ABTG_SuperWave_DOW_H1_Ottimizzato | 10 | 1.24 | 857.00 | 262 | 4.64 | 683 | 11 | 0.87 | 1.33 | 320 | 11.44 | -441 | no |
| A_geometria | NASDAQ | [NON MISURATO] | Walkforward_Aperture | backtest_pipeline/risultati_archivio/Walkforward_Aperture | 20 | 0.94 | 1.13 | 189 | 14.36 | -312 | 20 | 0.86 | 1.01 | 243 | 12.90 | -710 | no |
| BreakingBand | EURCAD | H1 | ohlc_cal1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/cal1 | 12 (8 uniche) | 0.93 | 1.97 | 16 | 1.48 | -27 | 12 (6 uniche) | 0.86 | 1.30 | 19 | 3.10 | -62 | no |
| Nightly | EURUSD | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_Nightly | 2 (1 uniche) | 1.05 | 1.05 | 106 | 10.80 | 227 | 2 (1 uniche) | 0.86 | 0.86 | 164 | 15.49 | -1126 | no |
| Apertura | NASDAQ | [NON MISURATO] | US_NASUSD_r25 | backtest_pipeline/risultati_prove/ABTG_Nasdaq_Apertura_US | 3 | 1.11 | 1.24 | 206 | 6.30 | 330 | 3 | 0.86 | 0.88 | 346 | 16.21 | -935 | no |
| ORB_Ottimizzato | NASUSD | [NON MISURATO] | r9 | backtest_pipeline/risultati_prove/ABTG_ORB_Ottimizzato | 8 | 0.78 | 1.36 | 141 | 17.86 | -1125 | 8 | 0.86 | 0.99 | 156 | 16.64 | -762 | no |
| Live5m | DAX | [NON MISURATO] | D30EUR | backtest_pipeline/risultati_prove/ABTG_DAX_Live5m | 2 (1 uniche) | 0.93 | 0.93 | 225 | 26.07 | -626 | 2 (1 uniche) | 0.86 | 0.86 | 342 | 39.74 | -2219 | no |
| Apertura | NASDAQ | [NON MISURATO] | US_NASUSD_r84h | backtest_pipeline/risultati_archivio/r84_csv | 2 (1 uniche) | 1.31 | 1.31 | 98 | 7.71 | 445 | 2 (1 uniche) | 0.86 | 0.86 | 211 | 10.13 | -624 | no |
| MeanRevert | GBPUSD | H1 | ohlc_mr1 | backtest_pipeline/risultati_prove/meanrevert_r60 | 6 | 0.88 | 0.95 | 120 | 13.16 | -7053 | 6 | 0.85 | 0.99 | 344 | 25.77 | -22993 | no |
| CostToCost | GBPCAD | H4 | r40 | backtest_pipeline/risultati_prove/ABTG_CostToCost/r40 | 3 | 1.16 | 1.30 | 64 | 9.28 | 625 | 3 | 0.85 | 1.44 | 95 | 20.51 | -893 | no |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_r27 | backtest_pipeline/risultati_prove/ABTG_DAX_Apertura_EU | 9 (6 uniche) | 1.04 | 1.50 | 142 | 5.73 | 124 | 9 (6 uniche) | 0.85 | 1.10 | 189 | 12.08 | -638 | no |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_r43c | backtest_pipeline/risultati_prove/aperture_r43 | 8 | 0.66 | 0.83 | 143 | 20.74 | -1420 | 8 | 0.85 | 0.95 | 223 | 14.53 | -950 | no |
| H_drawdown | NASDAQ | [NON MISURATO] | Walkforward_Aperture | backtest_pipeline/risultati_archivio/Walkforward_Aperture | 16 | 0.98 | 1.07 | 218 | 13.60 | -112 | 16 | 0.84 | 0.94 | 307 | 13.66 | -1237 | no |
| BreakoutCorso | AUDJPY | M15 | ohlc_r82d | backtest_pipeline/risultati_archivio/r82_csv | 2 (1 uniche) | 0.89 | 0.89 | 687 | 48.18 | -3634 | 2 (1 uniche) | 0.84 | 0.84 | 2059 | 85.24 | -8394 | no |
| SupertrendReversal | XAUUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal | 11 | 0.78 | 1.89 | 168 | 4.95 | -322 | 11 | 0.84 | 2175.00 | 221 | 3.67 | -258 | no |
| SupertrendReversal | NASUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 0.84 | 1.47 | 229 | 5.04 | -253 | no |
| GoldenCross_Ottimizzato | XAUUSD | [NON MISURATO] | r87boro | backtest_pipeline/risultati_archivio/r86_r87_r89_csv | 120 (39 uniche) | 1.08 | 420.69 | 33 | 4.34 | 61 | 144 (60 uniche) | 0.83 | 3524.80 | 45 | 6.64 | -215 | no |
| BreakoutCorso | CADJPY | M15 | ohlc_r82f | backtest_pipeline/risultati_archivio/r82_csv | 2 (1 uniche) | 0.80 | 0.80 | 566 | 45.49 | -4219 | 2 (1 uniche) | 0.83 | 0.83 | 2063 | 81.62 | -7878 | no |
| Apertura | NASDAQ | [NON MISURATO] | US_NASUSD_r43a | backtest_pipeline/risultati_prove/aperture_r43 | 8 | 0.73 | 0.79 | 162 | 17.24 | -1239 | 8 | 0.83 | 0.98 | 262 | 19.24 | -1374 | no |
| FiboH4_Multi | USDJPY | H4 | ohlc | backtest_pipeline/risultati_prove/ABTG_FiboH4_Multi | 6 (3 uniche) | 0.69 | 0.70 | 79 | 4.99 | -420 | 6 (3 uniche) | 0.82 | 1.09 | 77 | 5.67 | -241 | no |
| FiboH4_Multi | GBPUSD | H4 | ohlc | backtest_pipeline/risultati_prove/ABTG_FiboH4_Multi | 6 (3 uniche) | 0.69 | 0.70 | 79 | 4.99 | -420 | 6 (3 uniche) | 0.82 | 1.09 | 77 | 5.67 | -241 | no |
| FiboH4_Multi | USDCHF | H4 | ohlc | backtest_pipeline/risultati_prove/ABTG_FiboH4_Multi | 6 (3 uniche) | 0.69 | 0.70 | 79 | 4.99 | -420 | 6 (3 uniche) | 0.82 | 1.09 | 77 | 5.67 | -241 | no |
| FiboH4_Multi | AUDUSD | H4 | ohlc | backtest_pipeline/risultati_prove/ABTG_FiboH4_Multi | 6 (3 uniche) | 0.69 | 0.70 | 79 | 5.00 | -421 | 6 (3 uniche) | 0.82 | 1.09 | 77 | 5.67 | -241 | no |
| FiboH4_Multi | CADJPY | H4 | ohlc | backtest_pipeline/risultati_prove/ABTG_FiboH4_Multi | 6 (3 uniche) | 0.69 | 0.70 | 79 | 5.00 | -421 | 6 (3 uniche) | 0.82 | 1.09 | 77 | 5.67 | -241 | no |
| FiboH4_Multi | EURUSD | H4 | ohlc | backtest_pipeline/risultati_prove/ABTG_FiboH4_Multi | 6 (3 uniche) | 0.69 | 0.70 | 79 | 4.99 | -419 | 6 (3 uniche) | 0.82 | 1.09 | 77 | 5.67 | -241 | no |
| FiboH4_Multi | GBPJPY | H4 | ohlc | backtest_pipeline/risultati_prove/ABTG_FiboH4_Multi | 6 (3 uniche) | 0.69 | 0.69 | 79 | 5.08 | -428 | 6 (3 uniche) | 0.82 | 1.09 | 77 | 5.67 | -241 | no |
| SupRev | DOW | H1 | Ottimizzato_U30USD_ohlc | backtest_pipeline/risultati_prove/ABTG_SupRev_DOW_H1_Ottimizzato | 11 | 0.90 | 5.19 | 293 | 8.14 | -351 | 10 | 0.82 | 1.97 | 654 | 14.30 | -1308 | no |
| ORB_Ottimizzato | NASUSD | [NON MISURATO] | r9largo | backtest_pipeline/risultati_prove/ABTG_ORB_Ottimizzato | 40 | 0.89 | 1.71 | 153 | 17.79 | -649 | 40 | 0.82 | 1.06 | 166 | 19.33 | -1136 | no |
| BreakoutCorso | NZDJPY | M15 | ohlc_r82g | backtest_pipeline/risultati_archivio/r82_csv | 2 (1 uniche) | 0.72 | 0.72 | 502 | 55.61 | -5062 | 2 (1 uniche) | 0.82 | 0.82 | 1966 | 83.72 | -8228 | no |
| Apertura | NASDAQ | [NON MISURATO] | US_NASUSD_r84f | backtest_pipeline/risultati_archivio/r84_csv | 2 (1 uniche) | 0.82 | 0.82 | 90 | 10.97 | -316 | 2 (1 uniche) | 0.82 | 0.82 | 217 | 10.84 | -899 | no |
| GoldenCross | NZDUSD | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_GoldenCross | 2 (1 uniche) | 0.45 | 0.45 | 39 | 8.52 | -594 | 2 (1 uniche) | 0.81 | 0.81 | 65 | 7.79 | -316 | no |
| Nightly | EURCHF | [NON MISURATO] | P0 | backtest_pipeline/risultati_prove/ABTG_Nightly | 2 (1 uniche) | 0.89 | 0.89 | 63 | 11.10 | -408 | 2 (1 uniche) | 0.81 | 0.81 | 85 | 15.39 | -956 | no |
| AltaVelocita | U30USD | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_AltaVelocita/alta_v_tick | 4 | 0.67 | 0.92 | 90 | 13.08 | -710 | 4 | 0.81 | 0.94 | 150 | 10.74 | -700 | no |
| AltaVelocita | U30USD | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_AltaVelocita/alta_v_v11 | 4 | 0.67 | 0.92 | 90 | 13.08 | -710 | 4 | 0.81 | 0.94 | 150 | 10.74 | -700 | no |
| SuperWave | USDJPY | TF-OTT | ABTG_SuperWave | backtest_pipeline/risultati_prove/ABTG_SuperWave | 11 | 0.99 | 11.67 | 209 | 8.07 | -25 | 11 | 0.81 | 1.70 | 41 | 2.74 | -87 | no |
| I_trailing | DAX | [NON MISURATO] | Walkforward_Aperture | backtest_pipeline/risultati_archivio/Walkforward_Aperture | 5 | 1.03 | 1.06 | 256 | 10.61 | 139 | 5 | 0.81 | 0.83 | 327 | 18.96 | -1299 | no |
| SupertrendReversal_Multi | XAUUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal_Multi | 11 | 0.82 | 3.60 | 245 | 9.79 | -660 | 11 | 0.81 | 2973.43 | 312 | 13.14 | -855 | no |
| SuperWave | 225JPY | TF-OTT | ABTG_SuperWave | backtest_pipeline/risultati_prove/ABTG_SuperWave | 10 | 1.47 | 4.01 | 21 | 0.90 | 46 | 10 | 0.80 | 778.00 | 188 | 3.52 | -227 | no |
| ORB_Ottimizzato | NASUSD | [NON MISURATO] | r12 | backtest_pipeline/risultati_prove/ABTG_ORB_Ottimizzato | 48 (24 uniche) | 0.98 | 1.17 | 171 | 20.91 | -300 | 48 (24 uniche) | 0.80 | 0.92 | 267 | 41.95 | -3466 | no |
| Apertura | NASDAQ | [NON MISURATO] | US_NASUSD_r42 | backtest_pipeline/risultati_prove/aperture_r42 | 12 | 0.74 | 0.91 | 208 | 18.73 | -1653 | 12 | 0.80 | 0.86 | 314 | 22.69 | -1677 | no |
| EasyTrend | EURGBP | H1 | ohlc_cal | backtest_pipeline/risultati_prove/ABTG_EasyTrend/cal | 9 | 0.79 | 0.91 | 9 | 3.21 | -96 | 9 | 0.80 | 2.31 | 45 | 9.84 | -483 | no |
| L_rangemode | NASDAQ | [NON MISURATO] | Walkforward_Aperture | backtest_pipeline/risultati_archivio/Walkforward_Aperture | 6 (4 uniche) | 0.93 | 1.10 | 220 | 11.55 | -262 | 6 (4 uniche) | 0.80 | 1.02 | 329 | 17.35 | -1601 | no |
| ORB | NASUSD | [NON MISURATO] | r7b | backtest_pipeline/risultati_prove/ABTG_ORB | 4 | 0.98 | 1.69 | 134 | 2.71 | -17 | 4 | 0.79 | 0.93 | 190 | 4.47 | -325 | no |
| SupertrendReversal | NASUSD | TF-OTT | ABTG_SupertrendReversal | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 0.79 | 1.44 | 230 | 5.43 | -325 | no |
| CostToCost | CHFJPY | H4 | r40 | backtest_pipeline/risultati_prove/ABTG_CostToCost/r40 | 3 | 1.36 | 1.58 | 54 | 6.76 | 762 | 3 | 0.79 | 0.86 | 124 | 13.70 | -1172 | no |
| Apertura | NASDAQ | [NON MISURATO] | US_NASUSD_r84i | backtest_pipeline/risultati_archivio/r84_csv | 2 (1 uniche) | 1.54 | 1.54 | 33 | 3.14 | 214 | 2 (1 uniche) | 0.79 | 0.79 | 69 | 8.88 | -289 | no |
| I_trailing | NASDAQ | [NON MISURATO] | Walkforward_Aperture | backtest_pipeline/risultati_archivio/Walkforward_Aperture | 5 | 1.04 | 1.17 | 258 | 11.32 | 172 | 5 | 0.79 | 0.93 | 338 | 19.57 | -1514 | no |
| EMA200 | GBPJPY | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_EMA200 | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 10 | 0.78 | 349.76 | 1463 | 41.15 | -3671 | no |
| TurnaroundTuesday | GBPUSD | H1 | ohlc_tt1 | backtest_pipeline/risultati_archivio/Notte_16-08 | 24 | 0.92 | 1.00 | 333 | 21.35 | -10969 | 24 | 0.78 | 0.91 | 497 | 34.06 | -28996 | no |
| ORB_Ottimizzato | U30USD | [NON MISURATO] | r88c2 | backtest_pipeline/risultati_archivio/r88_csv | 4 (2 uniche) | 0.74 | 0.76 | 85 | 30.35 | -18446 | 4 (1 uniche) | 0.78 | 0.78 | 147 | 36.79 | -23452 | no |
| CostToCost | EURJPY | H4 | r40 | backtest_pipeline/risultati_prove/ABTG_CostToCost/r40 | 3 | 0.85 | 1.03 | 94 | 14.64 | -697 | 3 | 0.77 | 1.74 | 127 | 24.23 | -1475 | no |
| BreakoutCorso | CHFJPY | M15 | ohlc_r82e | backtest_pipeline/risultati_archivio/r82_csv | 2 (1 uniche) | 0.86 | 0.86 | 493 | 31.99 | -2732 | 2 (1 uniche) | 0.77 | 0.77 | 1782 | 88.90 | -8730 | no |
| SupertrendReversal_Multi | XAUUSD | TF-OTT | ABTG_SupertrendReversal_Multi | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal_Multi | 11 | 0.75 | 3.54 | 257 | 12.35 | -966 | 11 | 0.77 | 2973.71 | 318 | 14.44 | -1121 | no |
| SupertrendReversal | XAUUSD | TF-OTT | ABTG_SupertrendReversal | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal | 11 | 0.72 | 1.84 | 168 | 5.51 | -408 | 11 | 0.77 | 2178.00 | 9 | 2.59 | -64 | no |
| SupRev_CAC | F40EUR | H4 | Ottimizzato_ohlc | backtest_pipeline/risultati_prove/ABTG_SupRev_CAC_H4_Ottimizzato | 11 | 0.63 | 0.98 | 71 | 5.23 | -392 | 11 | 0.76 | 2.40 | 442 | 22.47 | -1425 | no |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_r42 | backtest_pipeline/risultati_prove/aperture_r42 | 12 | 0.68 | 0.84 | 205 | 26.28 | -2184 | 12 | 0.76 | 0.93 | 302 | 19.36 | -1794 | no |
| GapFill | 225JPY | H1 | r36 | backtest_pipeline/risultati_prove/ABTG_GapFill/r36 | 3 | 2.07 | 3.18 | 11 | 1.33 | 218 | 3 | 0.76 | 1.14 | 15 | 4.65 | -178 | no |
| SuperWave | SPXUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_SuperWave | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 0.76 | 17.22 | 6 | 0.86 | -15 | no |
| SupertrendReversal | D30EUR | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal | 11 | 0.65 | 4.61 | 173 | 10.55 | -874 | 11 | 0.76 | 1.78 | 37 | 3.32 | -140 | no |
| SuperWave | SPXUSD | TF-OTT | ABTG_SuperWave | backtest_pipeline/risultati_prove/ABTG_SuperWave | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 0.76 | 17.22 | 217 | 4.43 | -393 | no |
| ORB_Ottimizzato | XAUUSD | [NON MISURATO] | r45a | backtest_pipeline/risultati_prove/ABTG_ORB_Ottimizzato/r45 | 8 | 0.67 | 0.76 | 243 | 10.95 | -1008 | 8 | 0.76 | 0.86 | 189 | 7.26 | -486 | no |
| BreakingBand | GBPJPY | H1 | ohlc_cal1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/cal1 | 12 (6 uniche) | 1.33 | 1.67 | 9 | 1.22 | 49 | 12 (7 uniche) | 0.76 | 1.27 | 14 | 2.59 | -80 | no |
| AltaVelocita | XAUUSD | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_AltaVelocita/alta_v_tick | 4 | 0.77 | 1.28 | 140 | 14.94 | -934 | 4 | 0.76 | 0.81 | 153 | 13.21 | -962 | no |
| AltaVelocita | XAUUSD | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_AltaVelocita/alta_v_v11 | 4 | 0.77 | 1.28 | 140 | 14.94 | -934 | 4 | 0.76 | 0.81 | 153 | 13.21 | -962 | no |
| EMA200 | 225JPY | H1 | r32b | backtest_pipeline/risultati_prove/ABTG_EMA200 | 30 | 1.36 | 1.49 | 315 | 7.31 | 631 | 30 | 0.75 | 0.85 | 506 | 12.49 | -977 | no |
| Apertura | DAX | [NON MISURATO] | EU_D30EUR_r43d | backtest_pipeline/risultati_prove/aperture_r43 | 8 | 0.63 | 0.85 | 154 | 21.92 | -1958 | 8 | 0.75 | 0.97 | 228 | 17.86 | -1733 | no |
| EasyTrend | EURGBP | H1 | r53 | backtest_pipeline/risultati_archivio/csv_r53 | 16 (12 uniche) | 0.82 | 1.24 | 23 | 9.73 | -2768 | 16 (11 uniche) | 0.75 | 0.97 | 39 | 9.58 | -6490 | no |
| SupRev | DAX | H1 | Ottimizzato_D30EUR_ohlc | backtest_pipeline/risultati_prove/ABTG_SupRev_DAX_H1_Ottimizzato | 11 | 0.67 | 5.71 | 181 | 10.25 | -879 | 11 | 0.74 | 2.29 | 34 | 3.19 | -149 | no |
| EasyTrend | EURGBP | H1 | r48a | backtest_pipeline/risultati_prove/ABTG_EasyTrend/r48 | 6 | 0.90 | 1.88 | 20 | 7.22 | -108 | 6 | 0.74 | 1.87 | 44 | 9.86 | -635 | no |
| Apertura | NASDAQ | [NON MISURATO] | US_NASUSD_r84g | backtest_pipeline/risultati_archivio/r84_csv | 2 (1 uniche) | 0.85 | 0.85 | 72 | 9.61 | -214 | 2 (1 uniche) | 0.74 | 0.74 | 169 | 13.02 | -994 | no |
| SondaOrologio | D30EUR | [NON MISURATO] | 11_long | backtest_pipeline/risultati_archivio/orologio_indici_csv | 66 | 0.99 | 1067.95 | 22 | 2.21 | -41 | 69 (67 uniche) | 0.74 | 2.54 | 42 | 1.41 | -604 | no |
| SupRev | DOW | H1 | Ottimizzato_U30USD | backtest_pipeline/risultati_prove/ABTG_SupRev_DOW_H1_Ottimizzato | 11 | 0.77 | 4.76 | 292 | 10.73 | -872 | 10 | 0.73 | 1.94 | 656 | 22.33 | -2065 | no |
| SuperWave | DAX | H4 | Ottimizzato_D30EUR_ohlc | backtest_pipeline/risultati_prove/ABTG_SuperWave_DAX_H4_Ottimizzato | 10 | 0.60 | 89.36 | 20 | 6.42 | -235 | 11 | 0.72 | 1.08 | 160 | 11.02 | -633 | no |
| SupRev | DAX | H1 | Ottimizzato_D30EUR | backtest_pipeline/risultati_prove/ABTG_SupRev_DAX_H1_Ottimizzato | 11 | 0.61 | 4.83 | 181 | 12.00 | -1097 | 11 | 0.70 | 2.18 | 34 | 3.23 | -179 | no |
| GoldenCross | USDCHF | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_GoldenCross | 2 (1 uniche) | 1.49 | 1.49 | 44 | 3.25 | 352 | 2 (1 uniche) | 0.70 | 0.70 | 63 | 9.33 | -501 | no |
| IBRetest | U30USD | [NON MISURATO] | P0 | backtest_pipeline/risultati_prove/ABTG_IBRetest | 2 (1 uniche) | 0.38 | 0.38 | 42 | 7.38 | -723 | 2 (1 uniche) | 0.70 | 0.70 | 53 | 7.61 | -365 | no |
| GoldenCross_Ottimizzato | U30USD | [NON MISURATO] | r4 | backtest_pipeline/risultati_prove/ABTG_GoldenCross_Ottimizzato | 2 (1 uniche) | 1.03 | 1.03 | 31 | 2.71 | 15 | 2 (1 uniche) | 0.70 | 0.70 | 63 | 6.74 | -519 | no |
| SuperWave | NASUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_SuperWave | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 0.70 | 1.93 | 108 | 3.19 | -270 | no |
| SuperWave | DAX | H4 | Ottimizzato_D30EUR | backtest_pipeline/risultati_prove/ABTG_SuperWave_DAX_H4_Ottimizzato | 10 | 0.61 | 3201.11 | 250 | 11.73 | -1107 | 11 | 0.69 | 1.06 | 160 | 11.16 | -704 | no |
| SupRev | DAX | H4 | Ottimizzato_D30EUR | backtest_pipeline/risultati_prove/ABTG_SupRev_DAX_H4_Ottimizzato | 11 | 0.66 | 4.30 | 191 | 14.24 | -985 | 11 | 0.69 | 15.15 | 648 | 29.99 | -2802 | no |
| SuperWave | NASUSD | TF-OTT | ABTG_SuperWave | backtest_pipeline/risultati_prove/ABTG_SuperWave | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 0.69 | 1.93 | 108 | 3.23 | -279 | no |
| BreakingBand | EURUSD | H1 | r33 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/r33 | 3 | 1.21 | 53.78 | 14 | 1.76 | 56 | 3 | 0.68 | 3.87 | 28 | 2.99 | -212 | no |
| Apertura | NASDAQ | [NON MISURATO] | US_NASUSD_r84e | backtest_pipeline/risultati_archivio/r84_csv | 2 (1 uniche) | 1.39 | 1.39 | 104 | 6.92 | 607 | 2 (1 uniche) | 0.68 | 0.68 | 202 | 15.66 | -1456 | no |
| SupertrendReversal | GBPJPY | H4 | r21 | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal | 12 | 1.58 | 3.75 | 19 | 2.29 | 182 | 12 | 0.67 | 1.78 | 33 | 5.94 | -285 | no |
| SupertrendReversal | GBPJPY | H4 | r21 | backtest_pipeline/risultati_prove/SupRev_H4_r21 | 12 | 1.58 | 3.75 | 19 | 2.29 | 182 | 12 | 0.67 | 1.78 | 33 | 5.94 | -285 | no |
| AltaVelocita | GBPUSD | [NON MISURATO] | ohlc_v2h4 | backtest_pipeline/risultati_prove/ABTG_AltaVelocita | 4 (3 uniche) | 0.64 | 0.70 | 22 | 6.24 | -303 | 4 (3 uniche) | 0.65 | 0.70 | 12 | 3.62 | -149 | no |
| EMA200 | GBPJPY | TF-OTT | ABTG_EMA200 | backtest_pipeline/risultati_prove/ABTG_EMA200 | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 10 | 0.65 | 349.76 | 624 | 28.49 | -2317 | no |
| PTE | 225JPY | TF-OTT | ABTG_PTE | backtest_pipeline/risultati_prove/ABTG_PTE | 16 | 0.96 | 5.18 | 13 | 3.42 | -18 | 16 | 0.65 | 761.94 | 20 | 5.58 | -276 | no |
| PTE | 225JPY | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_PTE | 16 | 1.00 | 5.21 | 30 | 4.04 | 1 | 16 | 0.65 | 8.63 | 19 | 6.90 | -308 | no |
| PTE | SPXUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_PTE | 16 (15 uniche) | 0.37 | 0.86 | 4 | 2.44 | -124 | 16 (14 uniche) | 0.64 | 2.35 | 32 | 7.63 | -468 | no |
| AltaVelocita | GBPUSD | [NON MISURATO] | ohlc_v11 | backtest_pipeline/risultati_prove/ABTG_AltaVelocita | 4 | 0.72 | 1.00 | 62 | 8.53 | -646 | 4 | 0.63 | 0.76 | 94 | 12.61 | -1258 | no |
| AltaVelocita | GBPUSD | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_AltaVelocita/alta_v_v11 | 4 | 0.72 | 1.00 | 62 | 8.53 | -646 | 4 | 0.63 | 0.76 | 94 | 12.61 | -1258 | no |
| ORB_Ottimizzato | EURUSD | [NON MISURATO] | r45b | backtest_pipeline/risultati_prove/ABTG_ORB_Ottimizzato/r45 | 8 | 0.76 | 0.87 | 227 | 14.04 | -890 | 8 | 0.63 | 0.82 | 323 | 17.57 | -1561 | no |
| SupertrendReversal | E35EUR | H1 | r18 | backtest_pipeline/risultati_prove/SupRev_IBEX_r18 | 12 (8 uniche) | 1.13 | 1.85 | 24 | 0.88 | 17 | 12 | 0.63 | 0.92 | 32 | 1.47 | -86 | no |
| Apertura_3Ingressi | NASUSD | [NON MISURATO] | r83n1 | backtest_pipeline/risultati_archivio/r83_csv | 2 (1 uniche) | 0.95 | 0.95 | 187 | 9.71 | -178 | 2 (1 uniche) | 0.62 | 0.62 | 303 | 29.14 | -2411 | no |
| SuperWave | D30EUR | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_SuperWave | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 0.62 | 1.13 | 53 | 7.42 | -428 | no |
| Apertura | NASDAQ | [NON MISURATO] | US_NASUSD_r43b | backtest_pipeline/risultati_prove/aperture_r43 | 8 | 0.89 | 1.05 | 165 | 12.51 | -505 | 8 | 0.61 | 0.67 | 235 | 28.81 | -2690 | no |
| SuperWave | D30EUR | TF-OTT | ABTG_SuperWave | backtest_pipeline/risultati_prove/ABTG_SuperWave | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 0.61 | 1.05 | 53 | 7.38 | -438 | no |
| PTE | GBPUSD | TF-OTT | r58 | backtest_pipeline/risultati_prove/tick_reali_r58 | 16 (14 uniche) | 1.26 | 7.25 | 6 | 2.58 | 541 | 16 | 0.61 | 1.46 | 12 | 4.13 | -2401 | no |
| AltaVelocita | GBPUSD | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_AltaVelocita | 4 | 0.72 | 0.85 | 142 | 15.18 | -1294 | 4 | 0.61 | 0.70 | 135 | 16.83 | -1680 | no |
| AltaVelocita | GBPUSD | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_AltaVelocita/alta_v_tick | 4 | 0.72 | 0.85 | 142 | 15.18 | -1294 | 4 | 0.61 | 0.70 | 135 | 16.83 | -1680 | no |
| ORB_Ottimizzato | GBPUSD | [NON MISURATO] | r45c | backtest_pipeline/risultati_prove/ABTG_ORB_Ottimizzato/r45 | 8 | 0.70 | 0.71 | 208 | 9.91 | -849 | 8 | 0.61 | 0.67 | 286 | 20.20 | -1894 | no |
| larry | GBPJPY | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | 3 | 0.71 | 1.30 | 28 | 6.33 | -365 | 3 | 0.60 | 2.00 | 29 | 7.05 | -673 | no |
| IBRetest | NASUSD | [NON MISURATO] | P0IBRTNAS | backtest_pipeline/risultati_prove/ibretest_p0 | 2 (1 uniche) | 0.56 | 0.56 | 35 | 5.80 | -442 | 2 (1 uniche) | 0.59 | 0.59 | 49 | 5.31 | -419 | no |
| EasyTrend | EURCAD | H1 | ohlc_cal | backtest_pipeline/risultati_prove/ABTG_EasyTrend/cal | 9 | 0.73 | 4.03 | 23 | 8.10 | -334 | 9 | 0.59 | 0.74 | 33 | 8.88 | -804 | no |
| SupertrendReversal | CHFJPY | H4 | r21 | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal | 12 | 0.75 | 1.99 | 52 | 5.03 | -211 | 12 | 0.58 | 0.84 | 14 | 3.41 | -122 | no |
| SupertrendReversal | CHFJPY | H4 | r21 | backtest_pipeline/risultati_prove/SupRev_H4_r21 | 12 | 0.75 | 1.99 | 52 | 5.03 | -211 | 12 | 0.58 | 0.84 | 14 | 3.41 | -122 | no |
| AltaVelocita | GBPUSD | [NON MISURATO] | ABTG_AltaVelocita | backtest_pipeline/risultati_prove/ABTG_AltaVelocita | 4 | 0.67 | 0.82 | 141 | 16.80 | -1552 | 4 | 0.58 | 0.64 | 132 | 18.77 | -1877 | no |
| AltaVelocita | GBPUSD | [NON MISURATO] | alta_v_tick | backtest_pipeline/risultati_prove/ABTG_AltaVelocita/alta_v_tick | 4 | 0.67 | 0.82 | 141 | 16.80 | -1552 | 4 | 0.58 | 0.64 | 132 | 18.77 | -1877 | no |
| AltaVelocita | AUDUSD | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_AltaVelocita/alta_v_tick | 4 | 0.44 | 0.61 | 171 | 33.50 | -3124 | 4 | 0.54 | 0.66 | 167 | 26.45 | -2237 | no |
| AltaVelocita | AUDUSD | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_AltaVelocita/alta_v_v11 | 4 | 0.44 | 0.61 | 171 | 33.50 | -3124 | 4 | 0.54 | 0.66 | 167 | 26.45 | -2237 | no |
| SuperWave | GBPJPY | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_SuperWave | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 9 | 0.53 | 2.04 | 393 | 17.60 | -1624 | no |
| WOL | USDJPY | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_WOL | 11 | 0.37 | 1.07 | 41 | 0.23 | -12 | 11 | 0.52 | 131.98 | 11 | 0.01 | -1 | no |
| SupertrendReversal | XAGUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal | 11 | 0.61 | 2457.75 | 8 | 0.69 | -23 | 11 | 0.52 | 2.16 | 31 | 4.89 | -315 | no |
| SupertrendReversal | XAGUSD | TF-OTT | ABTG_SupertrendReversal | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal | 11 | 0.61 | 2473.50 | 8 | 0.68 | -23 | 11 | 0.51 | 2.19 | 31 | 4.99 | -324 | no |
| PTE | GBPUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_PTE | 16 (13 uniche) | 29.44 | 138.27 | 25 | 1.31 | 668 | 16 | 0.49 | 1.54 | 10 | 3.99 | -309 | no |
| PTE | GBPUSD | TF-OTT | ABTG_PTE | backtest_pipeline/risultati_prove/ABTG_PTE | 16 (13 uniche) | 40.83 | 106.70 | 20 | 0.89 | 479 | 16 | 0.47 | 1.45 | 10 | 4.04 | -317 | no |
| SuperWave | 225JPY | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_SuperWave | 10 | 1.47 | 4.02 | 21 | 0.91 | 46 | 10 | 0.47 | 1.31 | 11 | 0.92 | -45 | no |
| AltaVelocita | GBPJPY | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_AltaVelocita/alta_v_tick | 4 | 0.51 | 0.70 | 125 | 22.12 | -2057 | 4 | 0.47 | 0.55 | 169 | 31.31 | -2967 | no |
| AltaVelocita | GBPJPY | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_AltaVelocita/alta_v_v11 | 4 | 0.51 | 0.70 | 125 | 22.12 | -2057 | 4 | 0.47 | 0.55 | 169 | 31.31 | -2967 | no |
| WOL | NASUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_WOL | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 0.46 | 8.42 | 26 | 0.13 | -6 | no |
| WOL | D30EUR | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_WOL | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 0.46 | 14.62 | 114 | 1.21 | -87 | no |
| AltaVelocita | USDCHF | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_AltaVelocita/alta_v_tick | 4 | 0.42 | 0.48 | 137 | 30.54 | -2439 | 4 | 0.44 | 0.50 | 219 | 37.15 | -3455 | no |
| AltaVelocita | USDCHF | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_AltaVelocita/alta_v_v11 | 4 | 0.42 | 0.48 | 137 | 30.54 | -2439 | 4 | 0.44 | 0.50 | 219 | 37.15 | -3455 | no |
| WOL | XAGUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_WOL | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 0.44 | 2.18 | 7 | 1.24 | -56 | no |
| AltaVelocita | USDJPY | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_AltaVelocita/alta_v_tick | 4 | 0.67 | 0.83 | 130 | 24.00 | -1465 | 4 | 0.41 | 0.61 | 250 | 50.51 | -4489 | no |
| AltaVelocita | USDJPY | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_AltaVelocita/alta_v_v11 | 4 | 0.67 | 0.83 | 130 | 24.00 | -1465 | 4 | 0.41 | 0.61 | 250 | 50.51 | -4489 | no |
| AltaVelocita | GBPUSD | [NON MISURATO] | ohlc_v2d1 | backtest_pipeline/risultati_prove/ABTG_AltaVelocita | 4 (3 uniche) | 0.00 | 0.69 | 3 | 2.62 | -254 | 4 (3 uniche) | 0.41 | 0.57 | 13 | 3.22 | -161 | no |
| WOL | GBPUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_WOL | 11 | 0.30 | 14.28 | 24 | 0.17 | -10 | 11 | 0.35 | 3.57 | 55 | 0.72 | -39 | no |
| PTE | XAGUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_PTE | 16 (14 uniche) | 0.52 | 340.82 | 5 | 0.99 | -30 | 16 | 0.30 | 1.50 | 5 | 1.83 | -183 | no |
| SupertrendInvert | 225JPY | M30 | ohlc | backtest_pipeline/risultati_prove/ABTG_SupertrendInvert | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 1 | 0.27 | 0.27 | 3 | 0.91 | -52 | no |
| WOL | D30EUR | TF-OTT | ABTG_WOL | backtest_pipeline/risultati_prove/ABTG_WOL | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 0.20 | 26.88 | 169 | 4.84 | -467 | no |
| AltaVelocita | EURUSD | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_AltaVelocita/alta_v_tick | 4 | 0.74 | 0.90 | 108 | 8.44 | -729 | 4 | 0.20 | 0.37 | 152 | 39.87 | -3836 | no |
| AltaVelocita | EURUSD | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_AltaVelocita/alta_v_v11 | 4 | 0.74 | 0.90 | 108 | 8.44 | -729 | 4 | 0.20 | 0.37 | 152 | 39.87 | -3836 | no |
| WOL | EURUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_WOL | 11 | 1.01 | 46.77 | 32 | 2.17 | 2 | 11 | 0.20 | 0.98 | 20 | 1.54 | -89 | no |
| WOL | SPXUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_WOL | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 0.19 | 8.09 | 104 | 2.18 | -153 | no |
| WOL | SPXUSD | TF-OTT | ABTG_WOL | backtest_pipeline/risultati_prove/ABTG_WOL | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 0.10 | 8.28 | 155 | 4.00 | -359 | no |
| WOL | NASUSD | TF-OTT | ABTG_WOL | backtest_pipeline/risultati_prove/ABTG_WOL | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 11 | 0.03 | 5.73 | 29 | 0.11 | -7 | no |
| WOL | GBPUSD | TF-OTT | ABTG_WOL | backtest_pipeline/risultati_prove/ABTG_WOL | 11 | 0.06 | 16.87 | 27 | 0.11 | -10 | 11 | 0.02 | 0.82 | 142 | 3.22 | -292 | no |
| SupertrendInvert | NASUSD | M30 | ohlc | backtest_pipeline/risultati_prove/ABTG_SupertrendInvert | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 1 | 0.00 | 0.00 | 2 | 0.50 | 37 | no |
| SupertrendInvert | XAUUSD | H1 | ohlc | backtest_pipeline/risultati_prove/ABTG_SupertrendInvert | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | [NON MISURATO] | 1 | 0.00 | 0.00 | 1 | 1.32 | -104 | no |

---

## 📋 TABELLA C — CORSE SENZA OOS (1128 righe): solo IS, oppure finestra unica / prova di regime

Qui rientrano gli **scan a tappeto** (`scan_ABTG_*`), le **prove di regime** R50/R57/R59/R80
(TORO / ORSO / LATERALE / CROLLO — che per costruzione NON hanno un OOS: sono finestre
dichiarate) e le validazioni realtick a finestra unica. **Non hanno un PF OOS: non possono
essere ordinate col criterio della Tabella B**, e la colonna `VICINO ALLA SOGLIA?` per loro
vale `[NON MISURATO]`. Ordinate per PF mediano della loro unica finestra, decrescente.

| Motore | Simbolo | TF | Etichetta/Round | Cartella | Finestra | passate | PF mediano | PF picco | Trades (cella mediana) | DD% | Profit |
|---|---|---|---|---|---|---|---|---|---|---|---|
| GoldenCross | XPTUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 65 (2 uniche) | 6020.71 | 6110.71 | 2 | 40.81 | 1445 |
| BreakingBand | XAGUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 2400.25 | 2400.25 | 2 | 0.28 | 96 |
| BreakingBand | XAGUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 1515.86 | 3127.83 | 5 | 0.74 | 212 |
| BreakingBand | XPTUSD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 1197.11 | 1197.11 | 2 | 2.21 | 108 |
| BreakingBand | XAUUSD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 1028.50 | 1028.50 | 1 | 0.22 | 62 |
| BreakingBand | XAGUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 718.50 | 718.50 | 1 | 0.23 | 14 |
| BreakingBand | NZDUSD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 286.35 | 286.35 | 1 | 0.15 | 57 |
| BreakingBand | XPDUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 254.96 | 254.96 | 3 | 0.58 | 63 |
| BreakingBand | AUDUSD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 246.89 | 246.89 | 1 | 0.19 | 44 |
| BreakingBand | NZDJPY | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 228.68 | 228.68 | 1 | 0.10 | 43 |
| BreakingBand | XPDUSD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 3 | 210.17 | 489.50 | 2 | 0.28 | 13 |
| BreakingBand | USDPLN | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 195.30 | 195.30 | 1 | 0.15 | 19 |
| BreakingBand | USDPLN | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 195.30 | 195.30 | 1 | 0.15 | 19 |
| BreakingBand | USDNOK | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 194.85 | 194.85 | 1 | 0.41 | 25 |
| BreakingBand | NZDCHF | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 3 | 184.20 | 259.50 | 2 | 0.36 | 90 |
| BreakingBand | USDSEK | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 180.42 | 180.42 | 1 | 0.36 | 34 |
| BreakingBand | USDJPY | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 131.33 | 131.33 | 1 | 0.08 | 31 |
| GapFill | CADCHF | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 131.11 | 135.00 | 2 | 0.61 | 70 |
| BreakingBand | CADJPY | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 118.86 | 118.86 | 2 | 0.50 | 51 |
| BreakingBand | USDCHF | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 115.74 | 115.74 | 1 | 0.31 | 45 |
| BreakingBand | CHFJPY | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 106.92 | 106.92 | 2 | 0.24 | 51 |
| BreakingBand | NZDCHF | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 3 | 106.15 | 136.45 | 5 | 0.77 | 137 |
| GapFill | EURAUD | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 97.17 | 132.41 | 3 | 0.83 | 144 |
| BreakingBand | USDSEK | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 3 | 94.55 | 99.14 | 3 | 0.53 | 56 |
| BreakingBand | CHFJPY | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 3 | 90.45 | 107.16 | 4 | 0.65 | 87 |
| GapFill | GBPCHF | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 88.03 | 131.99 | 2 | 0.24 | 54 |
| BreakingBand | USDSEK | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 82.94 | 82.94 | 1 | 0.11 | 14 |
| BreakingBand | GBPCAD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 3 | 81.80 | 138.71 | 2 | 0.71 | 44 |
| BreakingBand | USDJPY | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 3 | 81.79 | 121.55 | 2 | 0.71 | 39 |
| BreakingBand | USDJPY | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 3 | 81.79 | 121.55 | 2 | 0.71 | 39 |
| BreakingBand | EURUSD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 3 | 80.33 | 89.59 | 2 | 0.15 | 36 |
| BreakingBand | EURUSD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 3 | 80.33 | 89.59 | 2 | 0.15 | 36 |
| BreakingBand | AUDJPY | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 76.58 | 76.58 | 1 | 0.11 | 38 |
| BreakingBand | GBPUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 73.41 | 73.41 | 3 | 0.33 | 110 |
| BreakingBand | GBPAUD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 73.40 | 73.40 | 1 | 0.22 | 18 |
| BreakingBand | EURGBP | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 71.70 | 71.70 | 1 | 0.56 | 40 |
| GapFill | EURNZD | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 65.60 | 99.01 | 2 | 0.88 | 96 |
| BreakingBand | GBPNZD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 65.37 | 65.37 | 2 | 0.70 | 38 |
| BreakingBand | CADCHF | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 64.22 | 64.22 | 1 | 0.47 | 25 |
| BreakingBand | GBPUSD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 63.72 | 63.72 | 1 | 0.29 | 20 |
| BreakingBand | CHFJPY | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 3 | 62.90 | 79.48 | 2 | 0.20 | 32 |
| BreakingBand | GBPCAD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 62.37 | 62.37 | 1 | 0.71 | 25 |
| BreakingBand | EURNZD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 62.07 | 62.07 | 2 | 0.66 | 28 |
| BreakingBand | EURJPY | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 61.05 | 61.05 | 2 | 0.47 | 24 |
| BreakingBand | GBPCAD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 3 | 60.98 | 62.37 | 3 | 0.71 | 59 |
| BreakingBand | NZDCAD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 60.85 | 60.85 | 1 | 0.40 | 20 |
| BreakingBand | GBPCHF | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 56.73 | 56.73 | 1 | 0.19 | 14 |
| BreakingBand | USDCHF | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 56.69 | 56.69 | 3 | 0.37 | 69 |
| GapFill | GBPNZD | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 55.72 | 81.51 | 3 | 0.47 | 144 |
| BreakingBand | CADJPY | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 54.58 | 54.58 | 1 | 0.50 | 14 |
| BreakingBand | GBPNZD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 3 | 50.67 | 65.37 | 3 | 0.70 | 47 |
| BreakingBand | EURCAD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 49.60 | 49.60 | 4 | 0.79 | 147 |
| BreakingBand | EURNOK | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 47.08 | 47.08 | 2 | 0.28 | 22 |
| BreakingBand | GBPJPY | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 42.09 | 42.09 | 2 | 0.32 | 37 |
| PTE | PTEGBP | H1 | B25_CROLLO_r80nat | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 38.90 | 38.90 | 8 | 0.46 | 955 |
| PTE | PTEGBP | H1 | VIVA_CROLLO_r80nat | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 38.31 | 38.31 | 8 | 0.74 | 1590 |
| BreakingBand | EURPLN | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 34.26 | 34.26 | 4 | 0.50 | 93 |
| BreakingBand | GBPNZD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 32.61 | 32.61 | 3 | 1.09 | 47 |
| BreakingBand | EURGBP | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 30.36 | 30.36 | 2 | 0.31 | 30 |
| BreakingBand | EURPLN | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 26.47 | 26.47 | 1 | 0.37 | 15 |
| BreakingBand | EURPLN | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 26.47 | 26.47 | 1 | 0.37 | 15 |
| BreakingBand | EURUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 25.44 | 25.44 | 1 | 0.29 | 15 |
| PTE | PTEJPY | H1 | S25_LATERALE_r80ext | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 24.56 | 24.56 | 20 | 0.45 | 2022 |
| BreakingBand | GBPCHF | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 24.23 | 24.23 | 1 | 0.09 | 7 |
| BreakingBand | GBPCHF | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 24.23 | 24.23 | 1 | 0.09 | 7 |
| BreakingBand | EURGBP | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 3 | 22.90 | 30.36 | 3 | 0.31 | 34 |
| BreakingBand | GBPAUD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 18.97 | 18.97 | 1 | 0.75 | 5 |
| BreakingBand | EURPLN | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 17.19 | 17.19 | 1 | 0.32 | 16 |
| BreakingBand | EURNOK | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 11.64 | 11.64 | 1 | 0.04 | 2 |
| BreakingBand | NZDUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 10.04 | 24.06 | 8 | 1.26 | 146 |
| PTE | PTEJPY | H1 | S25_LATERALE_r80nat | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 8.60 | 8.60 | 16 | 0.53 | 1111 |
| LARRY | ORO | H1 | LATERALE_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 4.96 | 4.96 | 7 | 2.25 | 5202 |
| LARRY | ORO | H1 | LATERALE_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 4.96 | 4.96 | 7 | 2.25 | 5202 |
| BreakingBand | EURCAD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 4.42 | 38.74 | 17 | 1.30 | 396 |
| BreakingBand | CADCHF | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 4.28 | 4.28 | 6 | 0.77 | 136 |
| BreakingBand | USDCAD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 4.24 | 4.24 | 1 | 0.97 | 1 |
| LARRY | ORO | H1 | CROLLO_ANNO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 3.47 | 3.47 | 8 | 1.78 | 5202 |
| GapFill | AUDJPY | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 3.42 | 4.52 | 12 | 1.90 | 488 |
| BreakingBand | GBPAUD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 3.20 | 3.20 | 3 | 0.82 | 31 |
| BreakingBand | USDJPY | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 3.17 | 3.17 | 4 | 1.04 | 66 |
| GapFill | GBPUSD | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 3.11 | 3.66 | 10 | 1.32 | 217 |
| BreakingBand | AUDJPY | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 3 | 3.10 | 167.00 | 2 | 0.73 | 25 |
| LARRY | ORO | H1 | TORO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 3.03 | 3.03 | 11 | 2.68 | 5052 |
| LARRY | ORO | H1 | TORO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 3.03 | 3.03 | 11 | 2.68 | 5052 |
| GapFill | GBPUSD | H1 | tick | backtest_pipeline/risultati_prove/ABTG_GapFill/tick | UNICA | 3 | 3.01 | 3.36 | 10 | 1.30 | 207 |
| GoldenCross | E35EUR | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 94 (66 uniche) | 2.93 | 231.46 | 12 | 1.73 | 216 |
| PTE | GBPUSD | H1 | CROLLO_r57 | backtest_pipeline/risultati_prove/regime_r57 | UNICA | 2 (1 uniche) | 2.85 | 2.85 | 7 | 1.76 | 1850 |
| BreakingBand | GBPUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 2.83 | 5.77 | 19 | 1.59 | 306 |
| GapFill | USDNOK | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 2.72 | 148.98 | 4 | 1.38 | 164 |
| BreakingBand | AUDUSD | H1 | tick | backtest_pipeline/risultati_prove/ABTG_BreakingBand/tick | UNICA | 3 | 2.68 | 70.25 | 18 | 1.79 | 351 |
| COST | EURJPY | H4 | ORSO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 2.65 | 2.65 | 43 | 14.31 | 47260 |
| COST | EURJPY | H4 | ORSO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 2.65 | 2.65 | 43 | 14.31 | 47260 |
| BreakingBand | EURPLN | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 2.63 | 2.63 | 2 | 0.62 | 14 |
| BreakingBand | AUDUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 2.62 | 69.48 | 18 | 1.79 | 339 |
| R113_F3 | [NON MISURATO] | H1 | 00_metro | backtest_pipeline/risultati_archivio/R113_CORSA_20260827 | UNICA | 2 (1 uniche) | 2.60 | 2.60 | 5 | 0.37 | 256 |
| BreakingBand | NZDJPY | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 2.57 | 50.95 | 12 | 1.35 | 246 |
| BreakingBand | NASUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 2.55 | 5.11 | 5 | 1.10 | 97 |
| GapFill | NZDCAD | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 2.51 | 80.86 | 5 | 1.60 | 157 |
| WOL | NASUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_WOL | IS | 9 | 2.43 | 14.47 | 39 | 0.36 | 40 |
| PTE | PTEGBP | H1 | B25_ORSO_r80ext | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 2.39 | 2.39 | 19 | 1.61 | 1406 |
| BreakingBand | GBPUSD | H1 | tick | backtest_pipeline/risultati_prove/ABTG_BreakingBand/tick | UNICA | 3 | 2.31 | 2.57 | 30 | 1.84 | 500 |
| BreakingBand | NZDCAD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 2.30 | 2.30 | 5 | 1.19 | 55 |
| GapFill | EURCHF | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 2.27 | 2.32 | 7 | 1.32 | 134 |
| BreakingBand | EURUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 2.24 | 35.19 | 25 | 1.53 | 347 |
| BreakingBand | EURAUD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 2.24 | 43.31 | 4 | 0.89 | 38 |
| BreakingBand | GBPUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 2.20 | 2.58 | 30 | 1.87 | 462 |
| BreakingBand | AUDUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 2.19 | 2.19 | 6 | 1.68 | 125 |
| GapFill | AUDUSD | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 2.19 | 2.25 | 15 | 1.38 | 371 |
| R113_F0 | [NON MISURATO] | H1 | 00_metro | backtest_pipeline/risultati_archivio/R113_CORSA_20260827 | UNICA | 2 (1 uniche) | 2.19 | 2.19 | 8 | 0.35 | 317 |
| GoldenCross | XAGUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 88 (49 uniche) | 2.13 | 4.66 | 10 | 2.32 | 220 |
| GoldenCross | XAUUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 89 (74 uniche) | 2.11 | 3356.83 | 17 | 1.83 | 216 |
| PTE | PTEJPY | H1 | VIVA_CROLLO_r80ext | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 2.08 | 2.08 | 7 | 1.64 | 1079 |
| PTE | USDJPY | H1 | CROLLO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 2.08 | 2.08 | 7 | 1.64 | 1079 |
| PTE | USDJPY | H1 | CROLLO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 2.08 | 2.08 | 7 | 1.64 | 1079 |
| BreakingBand | USDPLN | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 2.08 | 2.08 | 4 | 1.77 | 56 |
| GapFill | EURPLN | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 2.04 | 38.74 | 4 | 2.06 | 112 |
| GapFill | GBPAUD | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 2.04 | 2.06 | 5 | 1.43 | 106 |
| BreakingBand | NZDCHF | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 2.03 | 2.03 | 1 | 1.04 | 0 |
| LARRY | GBPUSD | H1 | TORO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 2.02 | 2.02 | 19 | 2.50 | 4095 |
| LARRY | GBPUSD | H1 | TORO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 2.02 | 2.02 | 19 | 2.50 | 4095 |
| GapFill | AUDUSD | H1 | tick | backtest_pipeline/risultati_prove/ABTG_GapFill/tick | UNICA | 3 | 1.94 | 2.16 | 13 | 1.35 | 288 |
| PTE | PTEJPY | H1 | VIVA_LATERALE_r80ext | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 1.90 | 1.90 | 40 | 2.29 | 3744 |
| PTE | USDJPY | H1 | LATERALE_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 1.90 | 1.90 | 40 | 2.29 | 3744 |
| PTE | USDJPY | H1 | LATERALE_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 1.90 | 1.90 | 40 | 2.29 | 3744 |
| GoldenCross | XAGUSD | H4 | realtick_H4 | backtest_pipeline/risultati_archivio/GoldenCross/realtick_H4 | UNICA | 72 (35 uniche) | 1.87 | 4.62 | 30 | 4.89 | 643 |
| BreakingBand | XAUUSD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 3 | 1.85 | 1625.62 | 4 | 1.15 | 70 |
| PTE | PTEGBP | H1 | VIVA_LATERALE_r80ext | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 1.84 | 1.84 | 51 | 4.67 | 5284 |
| PTE | GBPUSD | H1 | LATERALE_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 1.84 | 1.84 | 51 | 4.67 | 5284 |
| PTE | GBPUSD | H1 | LATERALE_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 1.84 | 1.84 | 51 | 4.67 | 5284 |
| GapFill | EURUSD | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 1.84 | 2.46 | 15 | 3.23 | 345 |
| OpeningReversalB | U30USD | [NON MISURATO] | P0A_FAIL | backtest_pipeline/risultati_prove/ABTG_OpeningReversalB | IS | 3 (1 uniche) | 1.83 | 1.83 | 2 | 0.96 | 57 |
| OpeningReversalB | U30USD | [NON MISURATO] | P0CONTA | backtest_pipeline/risultati_prove/ABTG_OpeningReversalB | IS | 2 (1 uniche) | 1.83 | 1.83 | 2 | 0.96 | 57 |
| OpeningReversalB | U30USD | [NON MISURATO] | P0C_FT | backtest_pipeline/risultati_prove/ABTG_OpeningReversalB | IS | 3 | 1.83 | 3.56 | 2 | 0.96 | 57 |
| GapFill | NZDJPY | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 1.82 | 3.71 | 12 | 2.39 | 248 |
| LARRY | GBPUSD | H1 | ORSO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 1.78 | 1.78 | 12 | 2.18 | 1587 |
| LARRY | GBPUSD | H1 | ORSO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 1.78 | 1.78 | 12 | 2.18 | 1587 |
| GoldenCross | USDCHF | H4 | realtick_H4 | backtest_pipeline/risultati_archivio/GoldenCross/realtick_H4 | UNICA | 72 (60 uniche) | 1.76 | 2.63 | 28 | 2.75 | 330 |
| COST | EURJPY | H4 | CROLLO_ANNO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 1.69 | 1.69 | 67 | 16.60 | 20882 |
| GapFill | EURGBP | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 1.69 | 44.19 | 9 | 1.49 | 161 |
| GoldenCross | USDCHF | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 79 (78 uniche) | 1.68 | 3.46 | 18 | 1.85 | 156 |
| GapFill | EURUSD | H1 | tick | backtest_pipeline/risultati_prove/ABTG_GapFill/tick | UNICA | 3 | 1.68 | 2.21 | 15 | 3.31 | 283 |
| PTE | PTEJPY | H1 | S25_CROLLO_ANNO_r80nat | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 1.68 | 1.68 | 23 | 1.45 | 757 |
| PTE | PTEJPY | H1 | VIVA_LATERALE_r80nat | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 1.67 | 1.67 | 35 | 1.94 | 2131 |
| GoldenCross | USDCAD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 83 (73 uniche) | 1.67 | 4.76 | 27 | 3.04 | 303 |
| GapFill | USDCAD | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 1.66 | 1.73 | 9 | 1.87 | 208 |
| GapFill | USDSEK | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 1.66 | 1.78 | 5 | 1.19 | 67 |
| BB | EURUSD | H1 | ORSO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 1.63 | 1.63 | 7 | 1.40 | 932 |
| BB | EURUSD | H1 | ORSO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 1.63 | 1.63 | 7 | 1.40 | 932 |
| BB | EURUSD | H1 | CROLLO_ANNO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 1.63 | 1.63 | 4 | 1.04 | 629 |
| PTE | PTEGBP | H1 | VIVA_ORSO_r80ext | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 1.62 | 1.62 | 18 | 1.99 | 1245 |
| PTE | GBPUSD | H1 | ORSO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 1.62 | 1.62 | 18 | 1.99 | 1245 |
| PTE | GBPUSD | H1 | ORSO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 1.62 | 1.62 | 18 | 1.99 | 1245 |
| GoldenCross | USDCAD | H4 | realtick_H4 | backtest_pipeline/risultati_archivio/GoldenCross/realtick_H4 | UNICA | 72 (60 uniche) | 1.56 | 4.17 | 29 | 2.96 | 252 |
| EZ | GBPUSD | H1 | LATERALE_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 1.54 | 1.54 | 35 | 5.62 | 9443 |
| EZ | GBPUSD | H1 | LATERALE_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 1.54 | 1.54 | 35 | 5.62 | 9443 |
| EMA200 | U30USD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 85 | 1.53 | 3.02 | 41 | 2.96 | 365 |
| PTE | PTEGBP | H1 | VIVA_CROLLO_ANNO_r80nat | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 1.49 | 1.49 | 25 | 1.71 | 1588 |
| GoldenCross | XAUUSD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 83 | 1.49 | 2.01 | 63 | 4.19 | 619 |
| EMA200 | EURJPY | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 84 | 1.48 | 1.72 | 145 | 1.97 | 355 |
| GoldenCross | U30USD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 90 (33 uniche) | 1.48 | 6.82 | 21 | 3.87 | 278 |
| SupRevRT | U30USD | H4 | SupRev_nuovi_indici | backtest_pipeline/risultati_archivio/SupRev_nuovi_indici | UNICA | 8 | 1.46 | 2.77 | 117 | 4.13 | 556 |
| R114_canarino | [NON MISURATO] | [NON MISURATO] | A | backtest_pipeline/risultati_archivio/R114_CORSA_20260827 | UNICA | 2 (1 uniche) | 1.46 | 1.46 | 190 | 2.73 | 255 |
| PTE | USDJPY | H1 | LATERALE_r57 | backtest_pipeline/risultati_prove/regime_r57 | UNICA | 2 (1 uniche) | 1.45 | 1.45 | 29 | 2.47 | 2250 |
| PTE | PTEGBP | H1 | VIVA_TORO_r80ext | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 1.45 | 1.45 | 37 | 2.48 | 1362 |
| PTE | GBPUSD | H1 | TORO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 1.45 | 1.45 | 37 | 2.48 | 1362 |
| PTE | GBPUSD | H1 | TORO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 1.45 | 1.45 | 37 | 2.48 | 1362 |
| BreakingBand | NZDJPY | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 1.44 | 1.47 | 18 | 1.88 | 158 |
| EMA200 | U30USD | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 98 | 1.43 | 1.80 | 661 | 5.58 | 2557 |
| EMA200 | SPXUSD | H4 | realtick_H4 | backtest_pipeline/risultati_archivio/EMA200/realtick_H4 | UNICA | 84 (83 uniche) | 1.42 | 1.78 | 70 | 2.26 | 344 |
| EMA200 | U30USD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 81 | 1.42 | 1.84 | 286 | 4.62 | 1005 |
| GoldenCross | 225JPY | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 89 (47 uniche) | 1.41 | 2.98 | 71 | 0.33 | 34 |
| GapFill | NZDUSD | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 1.41 | 1.42 | 12 | 2.69 | 163 |
| EMA200 | AUDJPY | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 87 (85 uniche) | 1.40 | 2.68 | 197 | 4.02 | 697 |
| GapFill | UKOIL | H1 | tick | backtest_pipeline/risultati_prove/ABTG_GapFill/tick | UNICA | 3 | 1.39 | 1.57 | 26 | 3.63 | 308 |
| EMA200 | U30USD | H1 | risultati_valid_ABTG_EMA200_H1_realtick | backtest_pipeline/risultati_prove/risultati_valid_ABTG_EMA200_H1_realtick | UNICA | 84 | 1.39 | 1.70 | 291 | 3.07 | 817 |
| EMA200 | SPXUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 86 (85 uniche) | 1.38 | 1.87 | 136 | 2.60 | 485 |
| COST | EURJPY | H4 | LATERALE_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 1.38 | 1.38 | 54 | 10.89 | 8918 |
| COST | EURJPY | H4 | LATERALE_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 1.38 | 1.38 | 54 | 10.89 | 8918 |
| GapFill | UKOIL | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 1.38 | 1.57 | 26 | 3.65 | 299 |
| SupRevRT | NASUSD | H1 | supertrend_indici_validazione | backtest_pipeline/risultati_archivio/supertrend_indici_validazione | UNICA | 8 | 1.37 | 1.57 | 132 | 1.93 | 310 |
| GapFill | E35EUR | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 1.36 | 1.52 | 40 | 4.72 | 346 |
| EMA200 | GBPUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 83 (82 uniche) | 1.36 | 2.61 | 276 | 6.08 | 887 |
| EMA200 | AUDJPY | H4 | realtick_H4 | backtest_pipeline/risultati_archivio/EMA200/realtick_H4 | UNICA | 84 | 1.36 | 2.31 | 190 | 3.53 | 584 |
| BreakingBand | EURSEK | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 1.34 | 1.34 | 2 | 1.03 | 13 |
| BreakingBand | D30EUR | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 1.34 | 1.60 | 8 | 1.05 | 60 |
| BreakingBand | EURSEK | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 1.34 | 1.34 | 2 | 1.03 | 13 |
| PTE | PTEGBP | H1 | B25_TORO_r80ext | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 1.33 | 1.33 | 38 | 2.03 | 674 |
| EMA200 | XAUUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 90 | 1.33 | 2.22 | 90 | 3.62 | 291 |
| BreakingBand | NZDJPY | H1 | tick | backtest_pipeline/risultati_prove/ABTG_BreakingBand/tick | UNICA | 3 | 1.33 | 1.41 | 18 | 1.88 | 118 |
| GoldenCross | EURCAD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 86 (79 uniche) | 1.33 | 2.23 | 136 | 7.63 | 848 |
| PTE | PTEGBP | H1 | VIVA_LATERALE_r80nat | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 1.32 | 1.32 | 40 | 4.21 | 1738 |
| SupertrendReversal | AUDJPY | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 90 | 1.32 | 4.38 | 90 | 4.20 | 350 |
| BreakingBand | AUDUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 1.32 | 71.96 | 14 | 2.97 | 97 |
| GoldenCross | XPDUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 53 (5 uniche) | 1.32 | 1.90 | 3 | 46.96 | 247 |
| maxmin | ORO | H1 | fase1 | backtest_pipeline/risultati_archivio/MaxMin_Oro | UNICA | 12 | 1.31 | 1.74 | 365 | 9.28 | 3356 |
| BreakingBand | NASUSD | H1 | tick | backtest_pipeline/risultati_prove/ABTG_BreakingBand/tick | UNICA | 3 | 1.30 | 3.09 | 16 | 1.75 | 84 |
| EMA200 | XAUUSD | H4 | realtick_H4 | backtest_pipeline/risultati_archivio/EMA200/realtick_H4 | UNICA | 95 | 1.30 | 2.20 | 214 | 6.05 | 843 |
| BreakingBand | AUDJPY | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 1.30 | 61.44 | 8 | 1.48 | 40 |
| trailing2 | DOW | [NON MISURATO] | Dow_Apertura | backtest_pipeline/risultati_archivio/Dow_Apertura | UNICA | 6 | 1.28 | 1.37 | 329 | 5.81 | 3910 |
| SupRevRT | D30EUR | H4 | supertrend_indici_validazione | backtest_pipeline/risultati_archivio/supertrend_indici_validazione | UNICA | 8 | 1.28 | 1.96 | 111 | 8.35 | 375 |
| BreakingBand | EURUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 1.28 | 6.10 | 40 | 3.35 | 188 |
| GoldenCross | 225JPY | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 83 (21 uniche) | 1.28 | 1.80 | 14 | 0.24 | 8 |
| SupertrendReversal | XAGUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 96 (92 uniche) | 1.28 | 5.51 | 10 | 0.65 | 32 |
| EZ | AUDJPY | H1 | TORO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 1.28 | 1.28 | 44 | 5.27 | 5278 |
| EZ | AUDJPY | H1 | TORO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 1.28 | 1.28 | 44 | 5.27 | 5278 |
| SuperWave | U30USD | H4 | SuperWave | backtest_pipeline/risultati_archivio/SuperWave | UNICA | 9 | 1.28 | 2.51 | 28 | 5.95 | 152 |
| EMA200 | 200AUD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 92 (82 uniche) | 1.27 | 2.78 | 169 | 2.09 | 205 |
| maxmin | ORO | H1 | fase2 | backtest_pipeline/risultati_prove/MaxMin_Oro_fase2_vecchioscript | UNICA | 4 | 1.27 | 1.54 | 22 | 3.32 | 116 |
| EMA200 | USDNOK | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 86 | 1.27 | 2.30 | 216 | 3.79 | 507 |
| BreakingBand | NASUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 1.27 | 2.99 | 16 | 1.78 | 74 |
| PTE | GBPUSD | H1 | LATERALE_r57 | backtest_pipeline/risultati_prove/regime_r57 | UNICA | 2 (1 uniche) | 1.27 | 1.27 | 33 | 4.04 | 2124 |
| EasyTrend | GBPUSD | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 1.26 | 1.74 | 107 | 6.58 | 1304 |
| SuperWaveRT | U30USD | H1 | SuperWave | backtest_pipeline/risultati_archivio/SuperWave | UNICA | 9 | 1.26 | 1.52 | 226 | 5.04 | 826 |
| BB | GBPUSD | H1 | LATERALE_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 1.26 | 1.26 | 12 | 2.95 | 735 |
| BB | GBPUSD | H1 | LATERALE_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 1.26 | 1.26 | 12 | 2.95 | 735 |
| SupertrendReversal | U30USD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 96 | 1.26 | 7.80 | 56 | 4.73 | 173 |
| GoldenCross | NZDUSD | H4 | realtick_H4 | backtest_pipeline/risultati_archivio/GoldenCross/realtick_H4 | UNICA | 72 (59 uniche) | 1.25 | 1.70 | 48 | 3.48 | 214 |
| trailing | DOW | [NON MISURATO] | Dow_Apertura | backtest_pipeline/risultati_archivio/Dow_Apertura | UNICA | 30 (8 uniche) | 1.25 | 1.37 | 329 | 8.22 | 3990 |
| EasyTrend | GBPUSD | H1 | tick | backtest_pipeline/risultati_prove/ABTG_EasyTrend/tick | UNICA | 6 | 1.24 | 1.75 | 106 | 7.21 | 1196 |
| robustezza | DOW | [NON MISURATO] | Dow_Apertura | backtest_pipeline/risultati_archivio/Dow_Apertura | UNICA | 10 | 1.24 | 1.30 | 351 | 11.48 | 4011 |
| EMA200 | GBPJPY | H4 | realtick_H4 | backtest_pipeline/risultati_archivio/EMA200/realtick_H4 | UNICA | 91 (82 uniche) | 1.24 | 2.06 | 221 | 4.42 | 610 |
| COST | GBPCAD | H4 | TORO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 1.24 | 1.24 | 61 | 8.71 | 8417 |
| COST | GBPCAD | H4 | TORO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 1.24 | 1.24 | 61 | 8.71 | 8417 |
| SupertrendReversal | GBPJPY | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 89 (88 uniche) | 1.24 | 4.47 | 163 | 3.91 | 520 |
| EMA200 | GBPUSD | H4 | realtick_H4 | backtest_pipeline/risultati_archivio/EMA200/realtick_H4 | UNICA | 87 | 1.23 | 2.25 | 340 | 6.83 | 714 |
| R113_F5 | [NON MISURATO] | H1 | 01_long | backtest_pipeline/risultati_archivio/R113_CORSA_20260827 | UNICA | 2 (1 uniche) | 1.23 | 1.23 | 55 | 1.27 | 555 |
| BreakingBand | EURJPY | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 1.22 | 71.10 | 18 | 3.11 | 82 |
| EMA200 | 225JPY | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 83 | 1.22 | 2.45 | 29 | 0.35 | 13 |
| SupRevScr | 225JPY | H4 | SupRev_nuovi_indici | backtest_pipeline/risultati_archivio/SupRev_nuovi_indici | UNICA | 27 | 1.22 | 2.16 | 39 | 0.20 | 13 |
| apert_US | NASUSD | M5 | doc_brk | backtest_pipeline/risultati_archivio/Nasdaq_Apertura | UNICA | 136 (4 uniche) | 1.21 | 1.52 | 72 | 8.35 | 4379 |
| EMA200 | CADJPY | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 92 | 1.21 | 1.75 | 383 | 6.54 | 659 |
| GoldenCross | EURAUD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 90 (69 uniche) | 1.21 | 3.63 | 46 | 4.23 | 174 |
| EMA200 | 225JPY | H4 | realtick_H4 | backtest_pipeline/risultati_archivio/EMA200/realtick_H4 | UNICA | 91 | 1.21 | 2.89 | 23 | 0.45 | 14 |
| SuperWave | U30USD | TF-OTT | ABTG_SuperWave | backtest_pipeline/risultati_prove/ABTG_SuperWave | IS | 10 | 1.20 | 10269.00 | 122 | 4.79 | 339 |
| SuperWave | U30USD | H1 | SuperWave | backtest_pipeline/risultati_archivio/SuperWave | UNICA | 9 | 1.20 | 1.42 | 210 | 5.42 | 621 |
| EMA200 | 200AUD | H4 | realtick_H4 | backtest_pipeline/risultati_archivio/EMA200/realtick_H4 | UNICA | 87 (78 uniche) | 1.20 | 3.03 | 132 | 2.09 | 110 |
| EMA200 | EURUSD | H1 | risultati_valid_ABTG_EMA200_H1_realtick | backtest_pipeline/risultati_prove/risultati_valid_ABTG_EMA200_H1_realtick | UNICA | 94 | 1.19 | 1.37 | 641 | 10.76 | 1405 |
| EMA200 | EURUSD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 93 | 1.19 | 1.44 | 1338 | 12.79 | 2932 |
| BreakingBand | USDJPY | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 1.19 | 59.12 | 14 | 3.01 | 57 |
| GoldenCross | EURAUD | H4 | realtick_H4 | backtest_pipeline/risultati_archivio/GoldenCross/realtick_H4 | UNICA | 72 (57 uniche) | 1.19 | 3.34 | 43 | 3.74 | 145 |
| MaxMin | DAX | [NON MISURATO] | short_refine | backtest_pipeline/risultati_archivio/MaxMinNotte | UNICA | 36 (18 uniche) | 1.19 | 2.25 | 107 | 7.29 | 630 |
| EMA200 | GBPJPY | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 96 (94 uniche) | 1.19 | 2.11 | 252 | 4.49 | 480 |
| EMA200 | XAUUSD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 85 | 1.18 | 1.54 | 687 | 12.01 | 1498 |
| GoldenCross | USDJPY | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 86 | 1.18 | 1.97 | 128 | 6.15 | 524 |
| PTE | PTEGBP | H1 | B25_LATERALE_r80ext | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 1.18 | 1.18 | 51 | 3.54 | 1110 |
| GoldenCross | GBPUSD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 84 | 1.18 | 2.14 | 79 | 4.32 | 285 |
| GoldenCross | USDNOK | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 86 (80 uniche) | 1.18 | 6.19 | 22 | 2.05 | 86 |
| EMA200 | EURUSD | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 92 | 1.18 | 1.45 | 689 | 11.83 | 1270 |
| EasyTrend | CHFJPY | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 1.18 | 1.50 | 130 | 8.84 | 1046 |
| GapFill | EURJPY | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 1.18 | 1.32 | 16 | 2.62 | 87 |
| SupRevScr | U30USD | H4 | SupRev_nuovi_indici | backtest_pipeline/risultati_archivio/SupRev_nuovi_indici | UNICA | 27 | 1.17 | 2.58 | 107 | 5.17 | 234 |
| GapFill | USOIL | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 1.17 | 1.30 | 23 | 3.13 | 124 |
| EMA200 | XAUUSD | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 86 | 1.17 | 1.54 | 891 | 13.46 | 1531 |
| EZ | CHFJPY | H1 | TORO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 1.17 | 1.17 | 49 | 4.86 | 4587 |
| EZ | CHFJPY | H1 | TORO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 1.17 | 1.17 | 49 | 4.86 | 4587 |
| distanze | DOW | [NON MISURATO] | Dow_Apertura | backtest_pipeline/risultati_archivio/Dow_Apertura | UNICA | 48 (24 uniche) | 1.17 | 1.21 | 513 | 6.44 | 1601 |
| GapFill | USOIL | H1 | tick | backtest_pipeline/risultati_prove/ABTG_GapFill/tick | UNICA | 3 | 1.16 | 1.31 | 23 | 3.13 | 119 |
| PTE | PTEJPY | H1 | S25_CROLLO_ANNO_r80ext | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 1.16 | 1.16 | 30 | 2.45 | 370 |
| GapFill | U30USD | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 1.16 | 1.53 | 30 | 3.01 | 160 |
| maxmin | ORO | M30 | fase1 | backtest_pipeline/risultati_archivio/MaxMin_Oro | UNICA | 12 | 1.15 | 1.51 | 106 | 8.72 | 463 |
| R113_F5 | [NON MISURATO] | H1 | 00_metro | backtest_pipeline/risultati_archivio/R113_CORSA_20260827 | UNICA | 2 (1 uniche) | 1.15 | 1.15 | 94 | 1.66 | 649 |
| SuperWave | D30EUR | H4 | SuperWave | backtest_pipeline/risultati_archivio/SuperWave | UNICA | 9 | 1.15 | 1.30 | 56 | 4.65 | 141 |
| GoldenCross | NZDUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 81 (64 uniche) | 1.15 | 1.74 | 48 | 3.51 | 134 |
| PTE | PTEGBP | H1 | B25_CROLLO_ANNO_r80ext | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 1.14 | 1.14 | 37 | 2.13 | 432 |
| EMA200 | EURAUD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 82 | 1.14 | 1.53 | 345 | 7.39 | 452 |
| maxmin | ORO | M15 | fase1 | backtest_pipeline/risultati_archivio/MaxMin_Oro | UNICA | 12 | 1.14 | 1.42 | 61 | 2.85 | 127 |
| ablaz_2_vol | NASUSD | [NON MISURATO] | Nasdaq_Apertura | backtest_pipeline/risultati_archivio/Nasdaq_Apertura | UNICA | 24 (15 uniche) | 1.14 | 1.52 | 152 | 9.57 | 10494 |
| apert_APERT_US | NASUSD | M5 | doc_brk_vol | backtest_pipeline/risultati_archivio/Nasdaq_Apertura/csv_ablazione | UNICA | 24 (15 uniche) | 1.14 | 1.52 | 152 | 9.57 | 10494 |
| BreakingBand | USDJPY | H1 | tick | backtest_pipeline/risultati_prove/ABTG_BreakingBand/tick | UNICA | 3 | 1.13 | 54.23 | 20 | 3.97 | 55 |
| SupertrendReversal | U30USD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 103 | 1.13 | 2.62 | 142 | 5.35 | 208 |
| SupertrendReversal | D30EUR | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 87 | 1.13 | 2.25 | 355 | 11.33 | 526 |
| BreakingBand | EURUSD | H1 | tick | backtest_pipeline/risultati_prove/ABTG_BreakingBand/tick | UNICA | 3 | 1.13 | 6.21 | 40 | 3.75 | 94 |
| GoldenCross | GBPCHF | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 85 (75 uniche) | 1.13 | 2.15 | 31 | 3.72 | 80 |
| G_rischio | DAX | [NON MISURATO] | Walkforward_Aperture | backtest_pipeline/risultati_archivio/Walkforward_Aperture | UNICA | 2 | 1.13 | 1.13 | 541 | 20.40 | 2436 |
| SuperWaveRT | D30EUR | H4 | SuperWave | backtest_pipeline/risultati_archivio/SuperWave | UNICA | 9 | 1.13 | 1.28 | 56 | 4.71 | 122 |
| BreakingBand | USDJPY | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 1.12 | 54.10 | 20 | 3.98 | 50 |
| EMA200 | D30EUR | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 92 | 1.12 | 1.81 | 174 | 5.09 | 221 |
| BreakingBand | USDCAD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 1.12 | 1.12 | 9 | 2.09 | 25 |
| GoldenCross | CHFJPY | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 80 (69 uniche) | 1.12 | 1.57 | 55 | 3.70 | 108 |
| apert_US | U30USD | M5 | doc_brk | backtest_pipeline/risultati_archivio/Nasdaq_Apertura | UNICA | 143 (4 uniche) | 1.12 | 1.21 | 111 | 13.03 | 5301 |
| GapFill | F40EUR | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 1.12 | 1.45 | 37 | 4.87 | 154 |
| maxmin | ORO | M5 | fase1 | backtest_pipeline/risultati_archivio/MaxMin_Oro | UNICA | 12 | 1.12 | 1.49 | 102 | 5.80 | 83 |
| GapFill | 225JPY | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 1.11 | 1.69 | 26 | 4.84 | 86 |
| larry | USDJPY | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 1.11 | 1.93 | 76 | 9.15 | 282 |
| maxmin | ORO | M30 | fase2 | backtest_pipeline/risultati_prove/MaxMin_Oro_fase2_vecchioscript | UNICA | 4 | 1.11 | 1.46 | 22 | 3.29 | 40 |
| GapFill | 225JPY | H1 | tick | backtest_pipeline/risultati_prove/ABTG_GapFill/tick | UNICA | 3 | 1.10 | 1.69 | 26 | 4.79 | 79 |
| GapFill | 200AUD | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 1.10 | 1.20 | 18 | 2.87 | 72 |
| BreakingBand | USDCAD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 1.10 | 1.10 | 5 | 1.17 | 10 |
| BreakingBand | EURCHF | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 1.10 | 32.26 | 11 | 1.63 | 21 |
| EMA200 | EURNZD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 86 | 1.10 | 1.41 | 175 | 6.15 | 137 |
| CostToCost | E35EUR | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 1.10 | 2.00 | 72 | 5.81 | 365 |
| PTE | PTEJPY | H1 | VIVA_CROLLO_ANNO_r80nat | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 1.09 | 1.09 | 48 | 2.53 | 601 |
| SupertrendReversal | XAUUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 102 (101 uniche) | 1.09 | 5.16 | 9 | 0.91 | 11 |
| EMA200 | XPDUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 89 (79 uniche) | 1.09 | 213.12 | 13 | 49.57 | 627 |
| SuperWave | SPXUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_SuperWave | IS | 10 | 1.09 | 23.83 | 12 | 0.41 | 5 |
| GoldenCross | CHFJPY | H4 | realtick_H4 | backtest_pipeline/risultati_archivio/GoldenCross/realtick_H4 | UNICA | 72 (54 uniche) | 1.08 | 1.22 | 47 | 3.48 | 67 |
| SupRevScr | U30USD | H1 | SupRev_nuovi_indici | backtest_pipeline/risultati_archivio/SupRev_nuovi_indici | UNICA | 27 | 1.08 | 1.33 | 444 | 8.18 | 353 |
| EasyTrend | CHFJPY | H1 | tick | backtest_pipeline/risultati_prove/ABTG_EasyTrend/tick | UNICA | 6 | 1.08 | 1.52 | 112 | 9.03 | 449 |
| GapFill | 100GBP | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 1.08 | 1.14 | 18 | 3.50 | 41 |
| SuperWave | SPXUSD | TF-OTT | ABTG_SuperWave | backtest_pipeline/risultati_prove/ABTG_SuperWave | IS | 10 | 1.08 | 23.84 | 12 | 0.41 | 4 |
| BreakingBand | EURJPY | H1 | tick | backtest_pipeline/risultati_prove/ABTG_BreakingBand/tick | UNICA | 3 | 1.07 | 71.07 | 18 | 3.09 | 31 |
| SuperWave | NASUSD | H1 | SuperWave | backtest_pipeline/risultati_archivio/SuperWave | UNICA | 9 | 1.07 | 1.26 | 97 | 3.04 | 55 |
| EasyTrend | CADJPY | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 1.07 | 1.27 | 80 | 12.93 | 337 |
| GoldenCross | USDPLN | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 74 (55 uniche) | 1.07 | 3.00 | 26 | 3.11 | 36 |
| GoldenCross | EURUSD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 88 | 1.07 | 1.45 | 54 | 5.06 | 84 |
| GoldenCross | NZDJPY | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 80 | 1.07 | 1.34 | 80 | 5.06 | 126 |
| GapFill | U30USD | H1 | tick | backtest_pipeline/risultati_prove/ABTG_GapFill/tick | UNICA | 3 | 1.07 | 1.39 | 30 | 2.98 | 73 |
| PTE | PTEGBP | H1 | VIVA_CROLLO_r80ext | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 1.07 | 1.07 | 11 | 1.41 | 70 |
| PTE | GBPUSD | H1 | CROLLO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 1.07 | 1.07 | 11 | 1.41 | 70 |
| PTE | GBPUSD | H1 | CROLLO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 1.07 | 1.07 | 11 | 1.41 | 70 |
| SW | GBPUSD | H2 | CROLLO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 1.07 | 1.07 | 17 | 1.60 | 115 |
| SW | GBPUSD | H2 | CROLLO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 1.07 | 1.07 | 17 | 1.60 | 115 |
| GoldenCross | AUDJPY | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 85 (82 uniche) | 1.06 | 1.30 | 52 | 3.71 | 77 |
| SupRevRT | U30USD | H1 | SupRev_nuovi_indici | backtest_pipeline/risultati_archivio/SupRev_nuovi_indici | UNICA | 8 | 1.06 | 1.20 | 346 | 10.95 | 240 |
| GoldenCross | 200AUD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 85 (66 uniche) | 1.06 | 2.25 | 26 | 2.15 | 16 |
| EMA200 | CADCHF | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 88 (83 uniche) | 1.06 | 1.78 | 487 | 6.59 | 261 |
| EMA200 | F40EUR | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 92 (88 uniche) | 1.06 | 1.57 | 180 | 5.15 | 110 |
| COST | EURJPY | H4 | TORO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 1.05 | 1.05 | 46 | 10.63 | 1255 |
| COST | EURJPY | H4 | TORO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 1.05 | 1.05 | 46 | 10.63 | 1255 |
| GapFill | E50EUR | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 1.05 | 1.09 | 40 | 7.40 | 90 |
| PTE | PTEJPY | H1 | S25_TORO_r80ext | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 1.05 | 1.05 | 21 | 1.38 | 66 |
| larry | 225JPY | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 1.05 | 11.78 | 22 | 4.91 | 40 |
| R113_F5 | [NON MISURATO] | H1 | 02_short | backtest_pipeline/risultati_archivio/R113_CORSA_20260827 | UNICA | 2 (1 uniche) | 1.05 | 1.05 | 39 | 0.96 | 89 |
| EasyTrend | AUDJPY | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 1.04 | 1.94 | 113 | 21.40 | 296 |
| PTE | PTEJPY | H1 | VIVA_TORO_r80ext | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 1.04 | 1.04 | 36 | 2.99 | 203 |
| PTE | USDJPY | H1 | TORO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 1.04 | 1.04 | 36 | 2.99 | 203 |
| PTE | USDJPY | H1 | TORO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 1.04 | 1.04 | 36 | 2.99 | 203 |
| GoldenCross | EURUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 85 (57 uniche) | 1.04 | 2.46 | 40 | 3.62 | 30 |
| SuperWave | NASUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_SuperWave | IS | 10 | 1.04 | 3.17 | 3 | 1.04 | 2 |
| larry | EURJPY | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 1.04 | 1.91 | 92 | 7.42 | 84 |
| EMA200 | EURUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 85 | 1.04 | 1.57 | 328 | 6.54 | 136 |
| SuperWave | NASUSD | TF-OTT | ABTG_SuperWave | backtest_pipeline/risultati_prove/ABTG_SuperWave | IS | 10 | 1.04 | 3.17 | 3 | 1.02 | 2 |
| C_slippage | DAX | [NON MISURATO] | Walkforward_Aperture | backtest_pipeline/risultati_archivio/Walkforward_Aperture | UNICA | 20 | 1.03 | 1.11 | 413 | 23.27 | 360 |
| EMA200 | 100GBP | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 91 (90 uniche) | 1.03 | 2.00 | 149 | 5.61 | 58 |
| EMA200 | NZDCHF | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 93 | 1.03 | 1.40 | 463 | 6.23 | 110 |
| ingresso | DAX | [NON MISURATO] | Aperture_Ingresso | backtest_pipeline/risultati_archivio/Aperture_Ingresso | UNICA | 160 (20 uniche) | 1.03 | 1.19 | 408 | 17.28 | 316 |
| BreakingBand | SPXUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 1.03 | 2.19 | 8 | 2.25 | 5 |
| BB | GBPUSD | H1 | CROLLO_ANNO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 1.03 | 1.03 | 19 | 3.56 | 166 |
| GapFill | NASUSD | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 1.03 | 1.07 | 29 | 3.95 | 29 |
| larry | GBPCAD | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 1.03 | 1.63 | 66 | 5.75 | 50 |
| GapFill | GBPCAD | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 1.02 | 1.42 | 7 | 2.03 | 5 |
| EMA200 | CHFJPY | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 83 | 1.02 | 1.33 | 127 | 4.47 | 19 |
| EasyTrend | XAUUSD | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 1.02 | 1.72 | 100 | 7.92 | 101 |
| EMA200 | GBPCHF | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 92 (87 uniche) | 1.02 | 1.28 | 392 | 10.08 | 49 |
| SupertrendReversal | 225JPY | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 92 | 1.01 | 2.35 | 43 | 0.14 | 0 |
| EZ | GBPUSD | H1 | TORO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 1.01 | 1.01 | 34 | 6.95 | 279 |
| EZ | GBPUSD | H1 | TORO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 1.01 | 1.01 | 34 | 6.95 | 279 |
| PTE | PTEGBP | H1 | VIVA_CROLLO_ANNO_r80ext | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 1.01 | 1.01 | 35 | 2.84 | 66 |
| PTE | GBPUSD | H1 | CROLLO_ANNO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 1.01 | 1.01 | 35 | 2.84 | 66 |
| GapFill | SPXUSD | H1 | tick | backtest_pipeline/risultati_prove/ABTG_GapFill/tick | UNICA | 3 | 1.01 | 1.12 | 30 | 4.42 | 13 |
| EMA200 | EURNZD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 94 | 1.01 | 1.33 | 659 | 10.42 | 88 |
| motore | DOW | [NON MISURATO] | Dow_Apertura | backtest_pipeline/risultati_archivio/Dow_Apertura | UNICA | 12 (8 uniche) | 1.01 | 1.24 | 358 | 13.04 | 158 |
| SupertrendReversal | 200AUD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 91 (90 uniche) | 1.01 | 3.91 | 74 | 2.09 | 4 |
| E_retest | DAX | [NON MISURATO] | fill | backtest_pipeline/risultati_archivio/Walkforward_Aperture | UNICA | 20 | 1.01 | 1.18 | 411 | 17.09 | 72 |
| GapFill | F40EUR | H1 | tick | backtest_pipeline/risultati_prove/ABTG_GapFill/tick | UNICA | 3 | 1.01 | 1.30 | 34 | 7.42 | 9 |
| SupertrendReversal | D30EUR | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 89 (87 uniche) | 1.01 | 2.99 | 49 | 2.86 | 4 |
| SupertrendReversal | CADJPY | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 94 | 1.00 | 2.61 | 51 | 4.11 | 3 |
| GoldenCross | SPXUSD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 83 (78 uniche) | 1.00 | 2.63 | 91 | 7.62 | 0 |
| larry | EURUSD | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 1.00 | 1.51 | 44 | 6.47 | -0 |
| EMA200 | NZDJPY | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 88 | 1.00 | 1.60 | 438 | 12.79 | -2 |
| BB | GBPUSD | H1 | CROLLO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 1.00 | 1.00 | 6 | 1.46 | -4 |
| BB | GBPUSD | H1 | CROLLO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 1.00 | 1.00 | 6 | 1.46 | -4 |
| EMA200 | 225JPY | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 85 | 1.00 | 1.46 | 202 | 0.70 | -1 |
| BreakingBand | EURJPY | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 1.00 | 1.06 | 10 | 2.46 | -1 |
| EMA200 | EURNZD | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 81 | 1.00 | 1.23 | 600 | 16.35 | -23 |
| BreakingBand | AUDJPY | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 1.00 | 1.53 | 17 | 2.80 | -1 |
| PTE | GBPUSD | H1 | TORO_r57 | backtest_pipeline/risultati_prove/regime_r57 | UNICA | 2 (1 uniche) | 1.00 | 1.00 | 19 | 2.40 | -16 |
| openconfirm | DAX | M15 | Openconfirm | backtest_pipeline/risultati_archivio/Openconfirm | UNICA | 96 (9 uniche) | 0.99 | 1.20 | 440 | 19.74 | -79 |
| openconfirm | DAX | [NON MISURATO] | graficoM5 | backtest_pipeline/risultati_archivio/Openconfirm | UNICA | 12 (9 uniche) | 0.99 | 1.20 | 440 | 19.74 | -79 |
| EZ | GBPUSD | H1 | ORSO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 0.99 | 0.99 | 32 | 9.96 | -124 |
| EZ | GBPUSD | H1 | ORSO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.99 | 0.99 | 32 | 9.96 | -124 |
| GapFill | SPXUSD | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 0.99 | 1.12 | 30 | 4.45 | -8 |
| GoldenCross | D30EUR | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 73 (72 uniche) | 0.99 | 1.37 | 77 | 5.07 | -12 |
| CostToCost | EURJPY | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.99 | 1.55 | 308 | 26.39 | -162 |
| GoldenCross | F40EUR | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 91 (85 uniche) | 0.99 | 1.78 | 77 | 6.32 | -18 |
| EZ | AUDJPY | H1 | CROLLO_ANNO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.99 | 0.99 | 41 | 6.84 | -250 |
| EMA200 | USDCAD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 89 (87 uniche) | 0.98 | 1.43 | 418 | 8.60 | -71 |
| EMA200 | USOIL | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 82 | 0.98 | 1.25 | 170 | 7.18 | -27 |
| PTE | PTEGBP | H1 | B25_CROLLO_ANNO_r80nat | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 0.98 | 0.98 | 25 | 1.84 | -65 |
| apert_APERT_US | NASUSD | M5 | doc_brk_volatr | backtest_pipeline/risultati_archivio/Nasdaq_Apertura/csv_ablazione | UNICA | 72 (45 uniche) | 0.98 | 1.03 | 166 | 14.92 | -2026 |
| EZ | CHFJPY | H1 | ORSO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 0.98 | 0.98 | 30 | 4.34 | -389 |
| EZ | CHFJPY | H1 | ORSO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.98 | 0.98 | 30 | 4.34 | -389 |
| G_rischio | NASDAQ | [NON MISURATO] | Walkforward_Aperture | backtest_pipeline/risultati_archivio/Walkforward_Aperture | UNICA | 2 | 0.98 | 0.98 | 521 | 24.50 | -385 |
| GapFill | D30EUR | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 0.98 | 0.98 | 22 | 2.86 | -16 |
| EMA200 | GBPJPY | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_EMA200 | IS | 11 | 0.98 | 1.64 | 891 | 12.35 | -270 |
| SupertrendReversal | NASUSD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 82 | 0.97 | 2.71 | 209 | 2.14 | -34 |
| EasyTrend | AUDJPY | H1 | tick | backtest_pipeline/risultati_prove/ABTG_EasyTrend/tick | UNICA | 6 | 0.97 | 1.79 | 110 | 21.52 | -180 |
| SuperWave | U30USD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_SuperWave | IS | 10 | 0.97 | 6.11 | 215 | 6.51 | -81 |
| EMA200 | AUDJPY | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 93 | 0.97 | 1.11 | 603 | 8.48 | -190 |
| BB | GBPUSD | H1 | TORO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 0.97 | 0.97 | 18 | 3.23 | -155 |
| BB | GBPUSD | H1 | TORO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.97 | 0.97 | 18 | 3.23 | -155 |
| PTE | PTEGBP | H1 | B25_LATERALE_r80nat | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 0.97 | 0.97 | 40 | 3.93 | -164 |
| COST | GBPCAD | H4 | CROLLO_ANNO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.97 | 0.97 | 63 | 12.82 | -1285 |
| GoldenCross | USDSEK | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 86 (79 uniche) | 0.97 | 1.83 | 43 | 2.94 | -28 |
| EMA200 | 225JPY | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 78 | 0.96 | 1.54 | 762 | 14.38 | -210 |
| EMA200 | AUDJPY | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 88 | 0.96 | 1.07 | 1157 | 20.96 | -521 |
| SupertrendReversal | USOIL | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 85 | 0.96 | 1.56 | 89 | 4.60 | -40 |
| EMA200 | EURCAD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 84 (83 uniche) | 0.96 | 1.22 | 219 | 5.23 | -52 |
| EZ | AUDJPY | H1 | CROLLO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 0.96 | 0.96 | 10 | 5.22 | -185 |
| EZ | AUDJPY | H1 | CROLLO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.96 | 0.96 | 10 | 5.22 | -185 |
| larry | AUDJPY | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.96 | 2.10 | 43 | 9.08 | -76 |
| GoldenCross | NZDCHF | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 76 (52 uniche) | 0.96 | 5.33 | 46 | 5.25 | -39 |
| CostToCost | XAGUSD | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.96 | 1.15 | 174 | 21.71 | -334 |
| CostToCost | USDCAD | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.96 | 1.39 | 211 | 17.90 | -485 |
| GoldenCross | CADJPY | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 95 | 0.96 | 1.55 | 79 | 4.82 | -73 |
| BreakingBand | GBPJPY | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.96 | 2.01 | 19 | 2.34 | -20 |
| CostToCost | GBPCAD | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.96 | 1.27 | 221 | 18.51 | -537 |
| BreakingBand | 100GBP | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 0.96 | 0.96 | 5 | 1.04 | -6 |
| maxmin | ORO | M15 | fase2 | backtest_pipeline/risultati_prove/MaxMin_Oro_fase2_vecchioscript | UNICA | 4 | 0.96 | 1.28 | 22 | 3.48 | -15 |
| R113_F1 | [NON MISURATO] | H1 | 00_metro | backtest_pipeline/risultati_archivio/R113_CORSA_20260827 | UNICA | 2 (1 uniche) | 0.96 | 0.96 | 7 | 0.35 | -10 |
| R113_F1 | [NON MISURATO] | H1 | 01_long | backtest_pipeline/risultati_archivio/R113_CORSA_20260827 | UNICA | 2 (1 uniche) | 0.96 | 0.96 | 7 | 0.35 | -10 |
| SupRevScr | 225JPY | H1 | SupRev_nuovi_indici | backtest_pipeline/risultati_archivio/SupRev_nuovi_indici | UNICA | 27 | 0.96 | 2.16 | 81 | 0.18 | -3 |
| SW | GBPUSD | H2 | ORSO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 0.96 | 0.96 | 51 | 4.04 | -205 |
| SW | GBPUSD | H2 | ORSO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.96 | 0.96 | 51 | 4.04 | -205 |
| EMA200 | AUDUSD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 85 | 0.95 | 1.11 | 596 | 10.57 | -233 |
| SupertrendReversal | SPXUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 95 (92 uniche) | 0.95 | 344.78 | 62 | 3.20 | -24 |
| BreakingBand | CHFJPY | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.95 | 30.92 | 10 | 1.45 | -10 |
| SupertrendReversal | USDJPY | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 86 (84 uniche) | 0.95 | 2.15 | 42 | 5.26 | -35 |
| BreakingBand | NZDCAD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.95 | 1.10 | 17 | 2.17 | -18 |
| SuperWave | XAUUSD | H1 | SuperWave | backtest_pipeline/risultati_archivio/SuperWave | UNICA | 9 | 0.95 | 1.06 | 111 | 7.05 | -60 |
| SupertrendReversal | EURAUD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 103 (101 uniche) | 0.95 | 2.37 | 109 | 7.92 | -74 |
| GoldenCross | UKOIL | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 96 (95 uniche) | 0.95 | 1.87 | 114 | 7.03 | -100 |
| trailing | DAX | [NON MISURATO] | Aperture_Trailing | backtest_pipeline/risultati_archivio/Aperture_Trailing | UNICA | 96 (7 uniche) | 0.95 | 0.99 | 440 | 18.85 | -589 |
| GoldenCross | EURNZD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 86 (77 uniche) | 0.95 | 1.39 | 42 | 4.45 | -49 |
| GoldenCross | EURJPY | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 82 (66 uniche) | 0.94 | 1.36 | 31 | 2.19 | -34 |
| EMA200 | AUDUSD | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 90 | 0.94 | 1.03 | 1423 | 12.57 | -776 |
| GoldenCross | USDJPY | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 84 (76 uniche) | 0.94 | 1.93 | 24 | 3.93 | -33 |
| GapFill | EURSEK | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 0.94 | 1.42 | 3 | 1.05 | -6 |
| EasyTrend | EURSEK | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.93 | 1.00 | 40 | 11.26 | -158 |
| SupRevRT | D30EUR | H1 | supertrend_indici_validazione | backtest_pipeline/risultati_archivio/supertrend_indici_validazione | UNICA | 8 | 0.93 | 1.45 | 284 | 8.53 | -230 |
| EMA200 | XAGUSD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 86 | 0.93 | 2.05 | 54 | 8.24 | -128 |
| BreakingBand | USDCAD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.93 | 1.04 | 24 | 1.86 | -44 |
| EZ | AUDJPY | H1 | ORSO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 0.93 | 0.93 | 35 | 4.32 | -1246 |
| EZ | AUDJPY | H1 | ORSO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.93 | 0.93 | 35 | 4.32 | -1246 |
| ablaz_3_atr | NASUSD | [NON MISURATO] | Nasdaq_Apertura | backtest_pipeline/risultati_archivio/Nasdaq_Apertura | UNICA | 24 (15 uniche) | 0.93 | 0.97 | 332 | 27.49 | -11980 |
| apert_APERT_US | NASUSD | M5 | doc_brk_atr | backtest_pipeline/risultati_archivio/Nasdaq_Apertura/csv_ablazione | UNICA | 24 (15 uniche) | 0.93 | 0.97 | 332 | 27.49 | -11980 |
| BreakingBand | EURPLN | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 0.93 | 0.93 | 5 | 1.38 | -7 |
| BB | GBPUSD | H1 | ORSO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 0.93 | 0.93 | 8 | 1.88 | -144 |
| BB | GBPUSD | H1 | ORSO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.93 | 0.93 | 8 | 1.88 | -144 |
| larry | NZDUSD | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.93 | 1.54 | 91 | 9.28 | -292 |
| SupertrendReversal | 225JPY | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 85 (83 uniche) | 0.92 | 23.91 | 19 | 0.23 | -3 |
| EMA200 | E35EUR | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 81 | 0.92 | 1.18 | 245 | 8.71 | -186 |
| CostToCost | USDCHF | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.92 | 1.26 | 152 | 21.50 | -676 |
| EMA200 | EURCHF | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 89 | 0.92 | 1.15 | 696 | 10.41 | -443 |
| Live5m | DAX | [NON MISURATO] | v2_D30EUR | backtest_pipeline/risultati_archivio/Live5m | UNICA | 32 (8 uniche) | 0.92 | 1.04 | 445 | 16.82 | -658 |
| EMA200 | EURSEK | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 88 | 0.92 | 1.22 | 448 | 11.45 | -296 |
| EasyTrend | USDSEK | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.92 | 1.11 | 45 | 10.53 | -176 |
| SupertrendReversal | CADJPY | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 98 | 0.92 | 2.03 | 118 | 5.38 | -123 |
| EMA200 | EURAUD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 80 | 0.92 | 1.03 | 660 | 13.48 | -456 |
| ingresso | NASDAQ | [NON MISURATO] | Aperture_Ingresso | backtest_pipeline/risultati_archivio/Aperture_Ingresso | UNICA | 160 (20 uniche) | 0.92 | 1.12 | 264 | 15.64 | -537 |
| EMA200 | EURAUD | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 87 | 0.92 | 1.00 | 792 | 19.40 | -597 |
| ablaz_1_nofilt | NASUSD | [NON MISURATO] | Nasdaq_Apertura | backtest_pipeline/risultati_archivio/Nasdaq_Apertura | UNICA | 8 (5 uniche) | 0.92 | 0.92 | 482 | 35.26 | -21961 |
| apert_APERT_US | NASUSD | M5 | doc_brk_nofilt | backtest_pipeline/risultati_archivio/Nasdaq_Apertura/csv_ablazione | UNICA | 8 (5 uniche) | 0.92 | 0.92 | 482 | 35.26 | -21961 |
| GoldenCross | E35EUR | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 84 (61 uniche) | 0.92 | 2.11 | 52 | 4.33 | -108 |
| CostToCost | U30USD | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.92 | 1.10 | 398 | 23.25 | -1315 |
| BreakingBand | NZDCAD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.91 | 1.01 | 16 | 2.17 | -32 |
| SupertrendReversal | XAUUSD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 100 | 0.91 | 2.00 | 166 | 3.19 | -111 |
| MaxMin | D30EUR | [NON MISURATO] | MaxMinNotte | backtest_pipeline/risultati_archivio/MaxMinNotte | UNICA | 54 (45 uniche) | 0.91 | 1.19 | 250 | 14.20 | -734 |
| SupertrendReversal | USDJPY | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 92 | 0.91 | 1.78 | 207 | 8.76 | -225 |
| GoldenCross | GBPCAD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 87 | 0.91 | 1.35 | 25 | 2.53 | -57 |
| larry | NZDJPY | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.91 | 2.19 | 74 | 14.22 | -339 |
| openconfirm | NASDAQ | M15 | Openconfirm | backtest_pipeline/risultati_archivio/Openconfirm | UNICA | 96 (9 uniche) | 0.91 | 1.20 | 204 | 8.74 | -445 |
| CostToCost | 225JPY | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.91 | 1.07 | 148 | 15.77 | -831 |
| BreakingBand | EURNZD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.91 | 1.09 | 15 | 1.82 | -25 |
| SupRevScr | E50EUR | H4 | SupRev_nuovi_indici | backtest_pipeline/risultati_archivio/SupRev_nuovi_indici | UNICA | 27 | 0.90 | 2.80 | 54 | 1.83 | -40 |
| BreakingBand | EURCAD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.90 | 1.47 | 32 | 2.40 | -70 |
| SupertrendReversal | EURUSD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 90 | 0.90 | 1.72 | 213 | 7.38 | -208 |
| EMA200 | 200AUD | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 83 | 0.90 | 1.08 | 770 | 16.04 | -707 |
| SupertrendReversal | GBPAUD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 102 | 0.90 | 10.82 | 28 | 4.37 | -46 |
| GoldenCross | NZDUSD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 89 | 0.90 | 1.36 | 156 | 9.68 | -359 |
| EMA200 | GBPJPY | TF-OTT | ABTG_EMA200 | backtest_pipeline/risultati_prove/ABTG_EMA200 | IS | 11 | 0.90 | 1.42 | 37 | 2.29 | -40 |
| EMA200 | GBPUSD | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 86 | 0.90 | 0.99 | 1620 | 17.18 | -1434 |
| SupertrendReversal | E35EUR | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 100 | 0.90 | 4.42 | 39 | 2.55 | -36 |
| EMA200 | USDNOK | H4 | realtick_H4 | backtest_pipeline/risultati_archivio/EMA200/realtick_H4 | UNICA | 88 | 0.90 | 1.71 | 207 | 5.85 | -224 |
| SupertrendReversal | EURGBP | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 95 | 0.90 | 3.05 | 73 | 3.83 | -74 |
| larry | D30EUR | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.90 | 1.60 | 44 | 7.65 | -172 |
| EasyTrend | USDPLN | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.89 | 0.96 | 48 | 11.64 | -241 |
| SupertrendReversal | USDCHF | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 103 (99 uniche) | 0.89 | 2.68 | 49 | 5.38 | -73 |
| trailing | NASDAQ | [NON MISURATO] | Aperture_Trailing | backtest_pipeline/risultati_archivio/Aperture_Trailing | UNICA | 96 (7 uniche) | 0.89 | 0.97 | 260 | 15.97 | -769 |
| openconfirm | NASDAQ | [NON MISURATO] | graficoM5 | backtest_pipeline/risultati_archivio/Openconfirm | UNICA | 12 (9 uniche) | 0.89 | 1.20 | 260 | 15.97 | -769 |
| CostToCost | 200AUD | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.89 | 1.00 | 99 | 20.48 | -549 |
| larry | USDCHF | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.89 | 4.07 | 57 | 9.01 | -289 |
| EasyTrend | USDCAD | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.89 | 1.25 | 106 | 21.97 | -691 |
| SupertrendReversal | NZDJPY | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 96 | 0.89 | 3.29 | 109 | 6.78 | -185 |
| EasyTrend | USDJPY | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.89 | 1.40 | 123 | 17.35 | -809 |
| EasyTrend | USOIL | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.89 | 0.96 | 47 | 8.75 | -259 |
| EMA200 | GBPUSD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 90 | 0.89 | 1.02 | 642 | 15.83 | -779 |
| EasyTrend | USDCHF | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.89 | 1.42 | 118 | 20.44 | -620 |
| EMA200 | XAGUSD | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 86 | 0.89 | 1.28 | 57 | 7.43 | -151 |
| EasyTrend | EURGBP | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.89 | 1.98 | 97 | 13.46 | -568 |
| larry | NASUSD | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.89 | 2.91 | 58 | 6.35 | -187 |
| GoldenCross | GBPUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 87 (78 uniche) | 0.88 | 1.09 | 23 | 3.36 | -60 |
| EMA200 | GBPAUD | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 85 | 0.88 | 1.16 | 1125 | 21.02 | -1545 |
| SupertrendReversal | USOIL | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 92 (91 uniche) | 0.88 | 6.09 | 65 | 4.74 | -113 |
| GoldenCross | EURUSD | H4 | realtick_H4 | backtest_pipeline/risultati_archivio/GoldenCross/realtick_H4 | UNICA | 72 (24 uniche) | 0.88 | 1.89 | 30 | 2.72 | -63 |
| EMA200 | USDJPY | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 92 | 0.88 | 1.17 | 1207 | 23.51 | -1348 |
| CostToCost | XAGUSD | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.88 | 1.13 | 128 | 21.93 | -927 |
| EMA200 | NZDCAD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 85 (83 uniche) | 0.88 | 1.05 | 411 | 8.27 | -408 |
| CostToCost | XAUUSD | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.88 | 1.19 | 888 | 48.28 | -3402 |
| SupertrendReversal | F40EUR | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 94 (87 uniche) | 0.88 | 7.37 | 60 | 5.47 | -94 |
| EMA200 | 200AUD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 87 | 0.88 | 1.08 | 598 | 9.63 | -423 |
| EMA200 | EURJPY | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 89 | 0.88 | 1.05 | 1441 | 21.41 | -1503 |
| CostToCost | XNGUSD | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.88 | 1.68 | 62 | 15.58 | -445 |
| CostToCost | USDJPY | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.88 | 1.10 | 698 | 39.24 | -3070 |
| EasyTrend | EURJPY | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.88 | 1.08 | 107 | 12.09 | -799 |
| EMA200 | CADCHF | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 76 | 0.88 | 1.11 | 1749 | 29.80 | -2293 |
| EMA200 | USDJPY | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 84 | 0.88 | 1.17 | 858 | 22.80 | -1382 |
| larry | XPTUSD | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.87 | 1.84 | 23 | 9.19 | -143 |
| GapFill | GBPJPY | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 0.87 | 0.93 | 12 | 4.16 | -62 |
| SupertrendReversal | UKOIL | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 92 | 0.87 | 1.62 | 159 | 6.04 | -230 |
| EMA200 | E35EUR | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 88 | 0.87 | 1.14 | 279 | 10.95 | -345 |
| EasyTrend | EURGBP | H1 | tick | backtest_pipeline/risultati_prove/ABTG_EasyTrend/tick | UNICA | 6 | 0.87 | 1.98 | 96 | 13.55 | -658 |
| SupertrendReversal | F40EUR | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 96 | 0.87 | 3.96 | 214 | 12.09 | -381 |
| EMA200 | EURJPY | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 78 | 0.87 | 1.00 | 1086 | 20.97 | -1614 |
| EMA200 | CADCHF | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 80 | 0.87 | 1.14 | 1272 | 31.73 | -2224 |
| SupertrendReversal | UKOIL | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 98 (97 uniche) | 0.87 | 23.90 | 41 | 2.96 | -83 |
| SupRevScr | F40EUR | H1 | SupRev_nuovi_indici | backtest_pipeline/risultati_archivio/SupRev_nuovi_indici | UNICA | 27 | 0.86 | 1.29 | 207 | 8.29 | -419 |
| EMA200 | NZDJPY | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 86 | 0.86 | 0.98 | 1187 | 20.24 | -1662 |
| GoldenCross | USDCHF | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 79 | 0.86 | 1.05 | 60 | 5.05 | -225 |
| EMA200 | NZDJPY | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 85 | 0.86 | 1.03 | 1076 | 18.38 | -1340 |
| SW | GBPUSD | H2 | CROLLO_ANNO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.86 | 0.86 | 69 | 3.98 | -1055 |
| larry | E35EUR | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.86 | 1.71 | 23 | 4.19 | -85 |
| Marco | DAX | [NON MISURATO] | base | backtest_pipeline/risultati_archivio/Marco_Emiliano | UNICA | 6 | 0.86 | 1.24 | 443 | 7.11 | -423 |
| Marco | DAX | [NON MISURATO] | emiliano | backtest_pipeline/risultati_archivio/Marco_Emiliano | UNICA | 16 | 0.86 | 1.24 | 443 | 7.11 | -423 |
| C_slippage | NASDAQ | [NON MISURATO] | Walkforward_Aperture | backtest_pipeline/risultati_archivio/Walkforward_Aperture | UNICA | 20 | 0.86 | 0.98 | 440 | 23.48 | -1600 |
| SupertrendReversal | EURJPY | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 95 | 0.86 | 2.63 | 212 | 6.35 | -419 |
| BreakingBand | USDCHF | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.86 | 0.90 | 20 | 3.49 | -73 |
| EasyTrend | E35EUR | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.86 | 1.85 | 55 | 13.80 | -400 |
| BreakingBand | EURAUD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.86 | 18.83 | 12 | 2.17 | -33 |
| COST | GBPCAD | H4 | LATERALE_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 0.85 | 0.85 | 58 | 8.78 | -5228 |
| COST | GBPCAD | H4 | LATERALE_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.85 | 0.85 | 58 | 8.78 | -5228 |
| EMA200 | GBPCAD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 84 | 0.85 | 1.03 | 387 | 8.68 | -563 |
| CostToCost | USDJPY | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.85 | 1.02 | 275 | 32.94 | -1841 |
| CostToCost | AUDJPY | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.85 | 1.17 | 165 | 22.28 | -1044 |
| CostToCost | D30EUR | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.85 | 1.16 | 113 | 22.26 | -754 |
| EMA200 | EURCHF | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 82 | 0.85 | 1.16 | 1120 | 20.94 | -1770 |
| BreakingBand | 100GBP | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.85 | 1.94 | 4 | 1.60 | -15 |
| GoldenCross | AUDJPY | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 90 (53 uniche) | 0.85 | 1.43 | 16 | 2.02 | -44 |
| SupertrendReversal | NASUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal | IS | 10 | 0.85 | 2.38 | 20 | 0.99 | -22 |
| EasyTrend | UKOIL | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.85 | 1.30 | 68 | 8.30 | -510 |
| SupertrendReversal | USDCAD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 90 | 0.84 | 2.19 | 39 | 3.32 | -66 |
| BreakingBand | GBPCHF | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.84 | 1.54 | 17 | 1.88 | -63 |
| SupertrendReversal | GBPUSD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 98 | 0.84 | 1.56 | 136 | 8.60 | -290 |
| EMA200 | D30EUR | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 80 | 0.84 | 0.92 | 349 | 9.34 | -573 |
| CostToCost | 225JPY | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.84 | 1.01 | 295 | 42.19 | -2884 |
| EMA200 | GBPAUD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 89 (88 uniche) | 0.84 | 1.15 | 1295 | 23.64 | -1863 |
| BreakingBand | EURCHF | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.84 | 2.45 | 22 | 2.72 | -79 |
| CostToCost | CADJPY | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.84 | 1.06 | 152 | 20.42 | -1136 |
| EMA200 | GBPCAD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 88 | 0.84 | 0.98 | 670 | 16.91 | -1081 |
| BreakingBand | NZDUSD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 3 | 0.84 | 286.35 | 3 | 1.06 | -16 |
| BreakingBand | NZDUSD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 3 | 0.84 | 286.35 | 3 | 1.06 | -16 |
| SupertrendReversal | GBPCAD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 97 (96 uniche) | 0.83 | 1.80 | 114 | 6.90 | -278 |
| CostToCost | EURNZD | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.83 | 0.90 | 208 | 22.89 | -1469 |
| CostToCost | EURCAD | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.83 | 1.11 | 259 | 30.79 | -1642 |
| EasyTrend | D30EUR | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.83 | 1.27 | 87 | 12.10 | -699 |
| CostToCost | NZDUSD | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.83 | 1.08 | 171 | 26.98 | -1610 |
| SupertrendReversal | AUDJPY | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 98 | 0.83 | 1.52 | 163 | 7.81 | -406 |
| GoldenCross | EURJPY | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 82 (81 uniche) | 0.83 | 1.81 | 133 | 11.39 | -537 |
| CostToCost | E35EUR | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.83 | 1.05 | 385 | 41.73 | -3248 |
| SuperWave | XAUUSD | H4 | SuperWave | backtest_pipeline/risultati_archivio/SuperWave | UNICA | 9 | 0.83 | 0.91 | 35 | 3.73 | -97 |
| CostToCost | U30USD | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.83 | 1.13 | 141 | 21.30 | -1302 |
| BreakingBand | NZDCAD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 3 | 0.83 | 98.80 | 4 | 1.05 | -17 |
| BreakingBand | GBPCHF | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.83 | 1.01 | 20 | 2.65 | -87 |
| GoldenCross | XAGUSD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 74 (69 uniche) | 0.83 | 1.28 | 134 | 12.92 | -512 |
| GoldenCross | EURCHF | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 81 | 0.83 | 1.42 | 48 | 6.26 | -191 |
| EMA200 | XAUUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_EMA200 | IS | 10 | 0.83 | 1695.90 | 707 | 23.04 | -1587 |
| EMA200 | D30EUR | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 85 | 0.83 | 0.93 | 589 | 13.65 | -1153 |
| GoldenCross | GBPJPY | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 80 | 0.83 | 1.55 | 114 | 10.91 | -472 |
| EMA200 | USDCAD | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 79 | 0.83 | 0.99 | 433 | 15.41 | -978 |
| CostToCost | NZDJPY | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.83 | 0.89 | 162 | 23.29 | -1609 |
| GoldenCross | NASUSD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 80 | 0.82 | 1.79 | 85 | 6.30 | -246 |
| EMA200 | USDCAD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 94 | 0.82 | 1.01 | 527 | 10.73 | -814 |
| BreakingBand | XPTUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.82 | 29.97 | 12 | 1.89 | -43 |
| BreakingBand | USDSEK | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.82 | 0.86 | 32 | 2.62 | -124 |
| EMA200 | USDJPY | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 79 | 0.82 | 1.25 | 224 | 8.30 | -409 |
| EasyTrend | 225JPY | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.82 | 1.21 | 43 | 7.57 | -399 |
| SupertrendReversal | GBPJPY | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 106 | 0.82 | 2.12 | 450 | 15.62 | -1152 |
| EMA200 | GBPCAD | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 83 | 0.82 | 0.95 | 1205 | 26.20 | -2088 |
| EMA200 | CADJPY | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 88 | 0.82 | 0.99 | 893 | 22.50 | -1804 |
| GoldenCross | EURJPY | H4 | realtick_H4 | backtest_pipeline/risultati_archivio/GoldenCross/realtick_H4 | UNICA | 72 (48 uniche) | 0.82 | 0.97 | 37 | 2.71 | -136 |
| larry | AUDUSD | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.82 | 1.37 | 47 | 8.32 | -439 |
| SupertrendReversal | NASUSD | TF-OTT | ABTG_SupertrendReversal | backtest_pipeline/risultati_prove/ABTG_SupertrendReversal | IS | 10 | 0.81 | 2.33 | 157 | 3.24 | -228 |
| SupertrendReversal | EURAUD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 98 | 0.81 | 1.80 | 177 | 10.32 | -503 |
| GoldenCross | USDCAD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 78 (75 uniche) | 0.81 | 1.05 | 58 | 6.08 | -248 |
| EasyTrend | EURUSD | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.81 | 1.34 | 74 | 16.45 | -856 |
| EMA200 | GBPJPY | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 82 | 0.81 | 1.01 | 1358 | 32.59 | -2739 |
| EasyTrend | AUDUSD | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.81 | 1.04 | 111 | 11.92 | -1055 |
| EMA200 | GBPJPY | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 76 | 0.81 | 1.00 | 1589 | 32.35 | -2648 |
| PTE | PTEJPY | H1 | VIVA_ORSO_r80ext | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 0.81 | 0.81 | 46 | 5.36 | -1888 |
| PTE | USDJPY | H1 | ORSO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 0.81 | 0.81 | 46 | 5.36 | -1888 |
| PTE | USDJPY | H1 | ORSO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.81 | 0.81 | 46 | 5.36 | -1888 |
| E_retest | NASDAQ | [NON MISURATO] | fill | backtest_pipeline/risultati_archivio/Walkforward_Aperture | UNICA | 20 | 0.81 | 1.00 | 410 | 25.10 | -1828 |
| larry | USDCAD | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.81 | 1.38 | 64 | 14.42 | -542 |
| CostToCost | AUDUSD | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.81 | 0.91 | 159 | 27.68 | -1662 |
| SupertrendReversal | CHFJPY | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 97 | 0.81 | 3.40 | 36 | 3.39 | -114 |
| SupertrendReversal | EURCAD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 96 (95 uniche) | 0.81 | 3.82 | 31 | 3.81 | -103 |
| SupertrendReversal | USDCAD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 88 | 0.81 | 1.53 | 127 | 3.98 | -226 |
| EMA200 | EURNOK | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 80 (62 uniche) | 0.81 | 1.01 | 139 | 7.20 | -221 |
| EMA200 | CADJPY | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 83 | 0.81 | 0.95 | 965 | 27.29 | -2270 |
| EMA200 | 100GBP | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 93 | 0.81 | 1.07 | 572 | 19.02 | -1500 |
| EMA200 | EURGBP | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 81 | 0.81 | 0.90 | 717 | 17.08 | -1572 |
| apert_APERT_US | U30USD | M5 | fade | backtest_pipeline/risultati_prove/apert_fade_realtick | UNICA | 137 (1 uniche) | 0.81 | 0.81 | 324 | 19.72 | -15904 |
| EMA200 | EURGBP | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 80 | 0.81 | 0.88 | 1138 | 27.39 | -2467 |
| CostToCost | GBPAUD | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.81 | 0.87 | 1045 | 67.01 | -6327 |
| SupertrendReversal | E50EUR | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 98 (88 uniche) | 0.81 | 4.95 | 22 | 1.01 | -39 |
| CostToCost | NASUSD | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.80 | 0.87 | 582 | 45.44 | -4277 |
| EMA200 | 100GBP | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 81 | 0.80 | 1.06 | 650 | 19.14 | -1574 |
| SupertrendReversal | NASUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 99 | 0.80 | 5.21 | 15 | 2.57 | -51 |
| SupertrendReversal | E50EUR | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 95 (94 uniche) | 0.80 | 2.56 | 18 | 0.78 | -32 |
| CostToCost | UKOIL | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.80 | 0.96 | 517 | 54.42 | -4462 |
| EMA200 | NASUSD | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 83 | 0.80 | 1.03 | 637 | 17.73 | -1376 |
| GoldenCross | GBPCHF | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 91 | 0.80 | 1.04 | 84 | 9.17 | -351 |
| SW | GBPUSD | H2 | LATERALE_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 0.80 | 0.80 | 61 | 3.23 | -938 |
| SW | GBPUSD | H2 | LATERALE_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.80 | 0.80 | 61 | 3.23 | -938 |
| EasyTrend | GBPCAD | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.80 | 1.09 | 114 | 15.40 | -1156 |
| EMA200 | USDCHF | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 84 | 0.80 | 1.07 | 1279 | 23.27 | -2065 |
| SupRevScr | F40EUR | H4 | SupRev_nuovi_indici | backtest_pipeline/risultati_archivio/SupRev_nuovi_indici | UNICA | 27 (25 uniche) | 0.80 | 1.71 | 33 | 3.67 | -94 |
| CostToCost | NZDUSD | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.80 | 0.91 | 1229 | 87.95 | -8323 |
| GoldenCross | U30USD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 86 (83 uniche) | 0.80 | 1.18 | 41 | 4.86 | -172 |
| GoldenCross | EURAUD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 80 | 0.80 | 0.96 | 139 | 13.81 | -683 |
| apert_APERT_US | NASUSD | M5 | doc_brk_volatrh4 | backtest_pipeline/risultati_archivio/Nasdaq_Apertura/csv_ablazione | UNICA | 72 (45 uniche) | 0.79 | 0.94 | 277 | 36.44 | -30232 |
| BreakingBand | EURAUD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.79 | 0.86 | 18 | 3.30 | -89 |
| EasyTrend | EURAUD | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.79 | 0.97 | 84 | 11.23 | -924 |
| SupertrendReversal | NZDJPY | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 97 | 0.79 | 1.24 | 346 | 10.82 | -843 |
| EMA200 | NASUSD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 85 | 0.79 | 1.02 | 302 | 9.68 | -611 |
| CostToCost | USOIL | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.79 | 0.99 | 93 | 19.99 | -895 |
| SupertrendReversal | GBPNZD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 84 | 0.79 | 1.47 | 60 | 7.22 | -197 |
| CostToCost | UKOIL | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.79 | 0.93 | 92 | 15.18 | -1126 |
| BreakingBand | XAUUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.79 | 1.53 | 18 | 1.57 | -81 |
| CostToCost | CHFJPY | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.79 | 1.15 | 199 | 20.66 | -1852 |
| GapFill | XPDUSD | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 0.79 | 1.14 | 12 | 2.61 | -93 |
| apert | DAX | M5 | retest_D30EUR | backtest_pipeline/risultati_archivio/DAX_Apertura | UNICA | 130 | 0.79 | 1.11 | 468 | 16.57 | -13318 |
| GoldenCross | NZDCAD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 85 (75 uniche) | 0.79 | 1.87 | 51 | 7.23 | -291 |
| larry | CADJPY | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.79 | 1.35 | 78 | 8.08 | -589 |
| SupertrendReversal | EURNZD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 100 | 0.79 | 1.70 | 235 | 10.39 | -725 |
| apert_APERT_US | NASUSD | M5 | doc_brk_volatrh4corrnews | backtest_pipeline/risultati_archivio/Nasdaq_Apertura/csv_ablazione | UNICA | 72 (45 uniche) | 0.79 | 0.93 | 223 | 30.42 | -25070 |
| CostToCost | XAUUSD | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.79 | 1.25 | 206 | 27.49 | -2186 |
| EMA200 | GBPNZD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 78 | 0.78 | 1.12 | 238 | 8.77 | -535 |
| BreakingBand | USDCHF | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.78 | 0.83 | 32 | 3.76 | -186 |
| EMA200 | CHFJPY | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 87 | 0.78 | 1.01 | 988 | 24.63 | -2304 |
| CostToCost | EURUSD | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.78 | 0.82 | 821 | 67.33 | -6508 |
| CostToCost | GBPUSD | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.78 | 0.88 | 181 | 28.46 | -1676 |
| GapFill | XAUUSD | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 0.78 | 0.91 | 12 | 4.48 | -114 |
| EasyTrend | GBPAUD | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.78 | 0.96 | 76 | 15.47 | -1101 |
| apert_APERT_US | NASUSD | M5 | doc_brk_volatrh4corr | backtest_pipeline/risultati_archivio/Nasdaq_Apertura/csv_ablazione | UNICA | 72 (46 uniche) | 0.78 | 0.93 | 253 | 34.79 | -29531 |
| GoldenCross | GBPCAD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 83 (52 uniche) | 0.78 | 1.88 | 14 | 3.35 | -87 |
| R113_F0 | [NON MISURATO] | H1 | 02_short | backtest_pipeline/risultati_archivio/R113_CORSA_20260827 | UNICA | 2 (1 uniche) | 0.78 | 0.78 | 6 | 0.40 | -59 |
| SuperWave | GBPJPY | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_SuperWave | IS | 11 | 0.78 | 51.80 | 93 | 5.57 | -251 |
| larry | GBPCHF | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.77 | 2.11 | 49 | 7.06 | -473 |
| larry | CADCHF | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.77 | 2.23 | 46 | 7.17 | -362 |
| EMA200 | EURCAD | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 80 | 0.77 | 0.87 | 1495 | 30.42 | -2784 |
| EMA200 | USDCHF | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 82 | 0.77 | 1.04 | 606 | 18.93 | -1497 |
| GoldenCross | AUDUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 83 (74 uniche) | 0.77 | 1.84 | 15 | 3.01 | -86 |
| PTE | USDJPY | H1 | TORO_r57 | backtest_pipeline/risultati_prove/regime_r57 | UNICA | 2 (1 uniche) | 0.77 | 0.77 | 22 | 3.29 | -1329 |
| EMA200 | USDSEK | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 86 | 0.77 | 1.01 | 229 | 9.10 | -526 |
| CostToCost | EURGBP | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.77 | 0.87 | 272 | 32.98 | -2862 |
| apert | DAX | M5 | brk_D30EUR | backtest_pipeline/risultati_archivio/DAX_Apertura | UNICA | 138 | 0.77 | 1.04 | 413 | 11.12 | -6208 |
| EMA200 | EURCAD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 80 | 0.77 | 0.86 | 625 | 19.79 | -1202 |
| CostToCost | CADJPY | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.77 | 0.88 | 631 | 54.28 | -4813 |
| EasyTrend | U30USD | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.77 | 1.25 | 83 | 10.15 | -904 |
| EasyTrend | NASUSD | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.77 | 0.92 | 75 | 13.10 | -1020 |
| PTE | PTEJPY | H1 | S25_ORSO_r80ext | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 0.77 | 0.77 | 32 | 2.80 | -896 |
| EasyTrend | 100GBP | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.76 | 1.27 | 68 | 13.88 | -947 |
| EZ | GBPUSD | H1 | CROLLO_ANNO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.76 | 0.76 | 35 | 8.37 | -5328 |
| EasyTrend | GBPJPY | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.76 | 0.95 | 78 | 14.57 | -966 |
| EMA200 | EURCHF | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 78 (77 uniche) | 0.76 | 1.17 | 332 | 10.14 | -889 |
| EasyTrend | NZDJPY | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.76 | 0.95 | 79 | 13.79 | -993 |
| CostToCost | EURAUD | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.76 | 0.85 | 204 | 23.28 | -1972 |
| EMA200 | AUDUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 75 | 0.76 | 1.16 | 350 | 13.20 | -984 |
| SupRevScr | E50EUR | H1 | SupRev_nuovi_indici | backtest_pipeline/risultati_archivio/SupRev_nuovi_indici | UNICA | 27 | 0.76 | 1.47 | 120 | 2.94 | -254 |
| EMA200 | NZDUSD | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 82 | 0.76 | 0.96 | 983 | 29.98 | -2468 |
| SupertrendReversal | SPXUSD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 102 | 0.76 | 2.14 | 174 | 4.39 | -301 |
| CostToCost | D30EUR | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.75 | 1.06 | 402 | 37.10 | -3650 |
| SupertrendReversal | AUDUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 96 | 0.75 | 9.11 | 19 | 2.30 | -81 |
| CostToCost | USDCAD | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.75 | 0.99 | 1305 | 86.63 | -8626 |
| CostToCost | EURUSD | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.75 | 0.90 | 222 | 30.91 | -2919 |
| GoldenCross | EURCAD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 84 (48 uniche) | 0.75 | 2.59 | 14 | 1.95 | -55 |
| PTE | GBPUSD | H1 | ORSO_r57 | backtest_pipeline/risultati_prove/regime_r57 | UNICA | 2 (1 uniche) | 0.75 | 0.75 | 17 | 3.14 | -1249 |
| apert | DAX | M5 | doc_brk_D30EUR | backtest_pipeline/risultati_archivio/DAX_Apertura | UNICA | 119 (32 uniche) | 0.75 | 2.12 | 61 | 2.30 | -577 |
| CostToCost | E50EUR | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.75 | 0.82 | 532 | 57.42 | -5262 |
| EMA200 | UKOIL | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 94 (93 uniche) | 0.75 | 1.09 | 121 | 5.91 | -298 |
| CostToCost | AUDUSD | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.75 | 0.83 | 635 | 61.63 | -5949 |
| GoldenCross | D30EUR | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 84 (46 uniche) | 0.75 | 2.27 | 18 | 3.05 | -100 |
| SupertrendReversal | XPTUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 85 (64 uniche) | 0.75 | 22159.12 | 7 | 42.93 | -1643 |
| EMA200 | NZDUSD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 81 | 0.74 | 1.00 | 1084 | 29.88 | -2468 |
| GoldenCross | SPXUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 82 (45 uniche) | 0.74 | 1.70 | 38 | 4.13 | -158 |
| EMA200 | CHFJPY | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 83 | 0.74 | 1.01 | 1339 | 27.66 | -2651 |
| EMA200 | XAUUSD | TF-OTT | ABTG_EMA200 | backtest_pipeline/risultati_prove/ABTG_EMA200 | IS | 10 | 0.74 | 1696.00 | 70 | 4.83 | -239 |
| BreakingBand | AUDJPY | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 3 | 0.74 | 3.66 | 3 | 1.00 | -15 |
| CostToCost | EURAUD | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.74 | 0.81 | 909 | 77.41 | -7541 |
| SupertrendReversal | USDCHF | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 96 | 0.74 | 1.57 | 114 | 5.86 | -306 |
| maxmin | ORO | M5 | fase2 | backtest_pipeline/risultati_prove/MaxMin_Oro_fase2_vecchioscript | UNICA | 4 | 0.74 | 1.24 | 22 | 3.49 | -91 |
| GoldenCross | NZDCHF | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 78 | 0.74 | 1.76 | 166 | 10.30 | -870 |
| SupRevRT | F40EUR | H4 | SupRev_nuovi_indici | backtest_pipeline/risultati_archivio/SupRev_nuovi_indici | UNICA | 8 | 0.74 | 1.79 | 60 | 6.43 | -209 |
| GoldenCross | NZDCAD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 82 (80 uniche) | 0.74 | 1.10 | 157 | 11.08 | -1013 |
| EasyTrend | SPXUSD | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.74 | 0.80 | 36 | 7.18 | -522 |
| EasyTrend | GBPNZD | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.74 | 0.88 | 139 | 21.56 | -1926 |
| larry | CHFJPY | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.74 | 1.99 | 58 | 7.12 | -469 |
| EMA200 | UKOIL | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 87 | 0.74 | 0.94 | 352 | 17.17 | -1180 |
| apert | DAX | M5 | doc_delay_D30EUR | backtest_pipeline/risultati_archivio/DAX_Apertura | UNICA | 148 (77 uniche) | 0.73 | 142.63 | 87 | 2.83 | -754 |
| CostToCost | SPXUSD | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.73 | 0.87 | 359 | 50.16 | -4910 |
| EZ | CHFJPY | H1 | CROLLO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 0.73 | 0.73 | 9 | 5.97 | -1625 |
| EZ | CHFJPY | H1 | CROLLO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.73 | 0.73 | 9 | 5.97 | -1625 |
| GapFill | CADJPY | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 0.73 | 0.86 | 5 | 1.87 | -53 |
| EMA200 | SPXUSD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 79 | 0.73 | 1.01 | 334 | 10.34 | -838 |
| larry | USDSEK | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.73 | 0.98 | 46 | 8.35 | -515 |
| R113_F4 | [NON MISURATO] | H1 | 02_short | backtest_pipeline/risultati_archivio/R113_CORSA_20260827 | UNICA | 2 (1 uniche) | 0.73 | 0.73 | 21 | 1.23 | -370 |
| GapFill | EURCAD | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 0.73 | 1.28 | 9 | 4.44 | -107 |
| EMA200 | XNGUSD | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 89 | 0.73 | 1.32 | 205 | 13.69 | -982 |
| EMA200 | NZDUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 89 | 0.73 | 1.22 | 139 | 7.66 | -409 |
| larry | EURNZD | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.73 | 1.01 | 43 | 10.98 | -591 |
| CostToCost | SPXUSD | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.73 | 0.96 | 91 | 17.25 | -1537 |
| EMA200 | USDCHF | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 83 (82 uniche) | 0.72 | 0.91 | 126 | 9.03 | -467 |
| EMA200 | F40EUR | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 81 | 0.72 | 0.87 | 357 | 16.00 | -1405 |
| BreakingBand | XPDUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.72 | 1.18 | 9 | 2.43 | -52 |
| larry | USDPLN | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.72 | 1.25 | 32 | 9.42 | -393 |
| EMA200 | GBPCHF | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 88 | 0.72 | 0.80 | 1363 | 42.22 | -3708 |
| CostToCost | F40EUR | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.72 | 1.15 | 124 | 27.06 | -1633 |
| BreakingBand | XAUUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.72 | 2.29 | 13 | 1.64 | -95 |
| EMA200 | NZDCAD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 82 | 0.72 | 0.83 | 1111 | 31.67 | -2930 |
| CostToCost | GBPJPY | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.72 | 0.91 | 698 | 56.33 | -5487 |
| EZ | CHFJPY | H1 | CROLLO_ANNO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.72 | 0.72 | 40 | 12.42 | -7371 |
| apert_APERT | DAX | M5 | fade_D30EUR | backtest_pipeline/risultati_prove/apert_fade_realtick | UNICA | 134 (80 uniche) | 0.72 | 0.94 | 430 | 21.63 | -19576 |
| EMA200 | UKOIL | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 86 | 0.72 | 0.92 | 622 | 25.43 | -1946 |
| EMA200 | GBPCHF | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 90 | 0.72 | 0.80 | 1124 | 31.94 | -2728 |
| CostToCost | EURJPY | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.72 | 0.81 | 827 | 77.97 | -7622 |
| LARRY | ORO | H1 | ORSO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 0.72 | 0.72 | 2 | 1.45 | -246 |
| LARRY | ORO | H1 | ORSO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.72 | 0.72 | 2 | 1.45 | -246 |
| PTE | PTEJPY | H1 | VIVA_CROLLO_ANNO_r80ext | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 0.72 | 0.72 | 52 | 3.74 | -2863 |
| PTE | USDJPY | H1 | CROLLO_ANNO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.72 | 0.72 | 52 | 3.74 | -2863 |
| BreakingBand | GBPJPY | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.72 | 0.72 | 4 | 1.24 | -30 |
| PTE | PTEGBP | H1 | B25_TORO_r80nat | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 0.72 | 0.72 | 18 | 1.60 | -601 |
| EMA200 | SPXUSD | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 86 | 0.72 | 1.05 | 377 | 13.62 | -1049 |
| apert | DAX | M5 | fade_D30EUR | backtest_pipeline/risultati_archivio/DAX_Apertura | UNICA | 136 (78 uniche) | 0.71 | 0.94 | 419 | 17.86 | -16447 |
| EasyTrend | EURPLN | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.71 | 0.81 | 81 | 20.58 | -1505 |
| SupertrendReversal | XAGUSD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 103 (101 uniche) | 0.71 | 3.33 | 31 | 3.06 | -151 |
| EasyTrend | XNGUSD | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.71 | 1.08 | 50 | 15.80 | -820 |
| EMA200 | F40EUR | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 88 | 0.71 | 0.93 | 165 | 9.01 | -616 |
| PTE | USDJPY | H1 | ORSO_r57 | backtest_pipeline/risultati_prove/regime_r57 | UNICA | 2 (1 uniche) | 0.71 | 0.71 | 27 | 6.29 | -2848 |
| EMA200 | NZDCHF | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 74 | 0.71 | 0.82 | 1276 | 34.24 | -3336 |
| BreakingBand | EURGBP | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.71 | 0.77 | 19 | 4.43 | -153 |
| GoldenCross | 100GBP | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 85 (71 uniche) | 0.71 | 0.93 | 101 | 12.21 | -799 |
| PTE | PTEGBP | H1 | VIVA_TORO_r80nat | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 0.71 | 0.71 | 17 | 2.74 | -914 |
| GapFill | XAGUSD | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 0.71 | 0.77 | 8 | 3.65 | -97 |
| CostToCost | AUDJPY | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.71 | 0.92 | 1038 | 81.73 | -8140 |
| EMA200 | NZDCHF | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 93 | 0.71 | 0.83 | 1204 | 34.81 | -3429 |
| CostToCost | NASUSD | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.71 | 1.03 | 100 | 19.38 | -1653 |
| EMA200 | EURGBP | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 88 (84 uniche) | 0.71 | 1.15 | 469 | 17.10 | -1436 |
| GoldenCross | EURNZD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 95 (90 uniche) | 0.71 | 0.90 | 42 | 5.70 | -299 |
| EasyTrend | EURCHF | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.71 | 1.13 | 108 | 19.56 | -1616 |
| CostToCost | 200AUD | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.71 | 0.85 | 407 | 58.09 | -5050 |
| BreakingBand | EURAUD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 3 | 0.71 | 27.77 | 2 | 0.59 | -3 |
| Marco | NAS | [NON MISURATO] | base | backtest_pipeline/risultati_archivio/Marco_Emiliano | UNICA | 6 | 0.71 | 0.84 | 451 | 14.77 | -971 |
| apert_US | U30USD | M5 | doc_delay | backtest_pipeline/risultati_archivio/Nasdaq_Apertura | UNICA | 157 (29 uniche) | 0.71 | 0.98 | 139 | 24.27 | -15755 |
| CostToCost | GBPUSD | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.71 | 0.80 | 690 | 59.81 | -5836 |
| SupertrendReversal | GBPAUD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 97 | 0.71 | 1.22 | 252 | 20.05 | -1180 |
| SupertrendReversal | EURJPY | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 99 (96 uniche) | 0.71 | 7.48 | 100 | 6.29 | -446 |
| CostToCost | GBPCHF | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.71 | 0.79 | 165 | 27.81 | -2709 |
| CostToCost | NZDCHF | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.70 | 0.83 | 171 | 32.96 | -2308 |
| EMA200 | NZDCAD | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 90 | 0.70 | 0.80 | 1247 | 36.66 | -3364 |
| GoldenCross | CHFJPY | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 84 (83 uniche) | 0.70 | 0.97 | 90 | 7.66 | -626 |
| CostToCost | NZDJPY | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.70 | 0.79 | 995 | 74.79 | -7453 |
| PTE | PTEGBP | H1 | B25_CROLLO_r80ext | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 0.70 | 0.70 | 11 | 1.33 | -302 |
| GoldenCross | CADJPY | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 89 (73 uniche) | 0.70 | 1.57 | 25 | 4.37 | -170 |
| SupRevScr | 100GBP | H4 | SupRev_nuovi_indici | backtest_pipeline/risultati_archivio/SupRev_nuovi_indici | UNICA | 27 | 0.70 | 1.29 | 34 | 1.97 | -96 |
| CostToCost | E50EUR | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.70 | 0.82 | 113 | 24.82 | -2081 |
| SupertrendReversal | GBPCAD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 105 | 0.70 | 1.27 | 246 | 11.42 | -1028 |
| larry | NZDCHF | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.70 | 1.00 | 74 | 17.36 | -1095 |
| SuperWave | XAUUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_SuperWave | IS | 9 | 0.70 | 3.34 | 153 | 5.26 | -326 |
| Apertura | U30USD | [NON MISURATO] | Dow | backtest_pipeline/risultati_archivio/Apertura_nuovi_indici | UNICA | 72 | 0.70 | 1.00 | 321 | 5.61 | -510 |
| CostToCost | USDCHF | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.70 | 0.85 | 998 | 76.97 | -7654 |
| larry | EURCHF | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.70 | 1.10 | 49 | 13.31 | -761 |
| EasyTrend | EURNOK | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.70 | 0.90 | 89 | 21.22 | -1649 |
| GoldenCross | CADCHF | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 86 | 0.70 | 1.59 | 161 | 18.28 | -1118 |
| larry | EURGBP | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.70 | 1.06 | 45 | 8.88 | -722 |
| larry | EURSEK | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.69 | 1.14 | 54 | 5.99 | -471 |
| EMA200 | USDPLN | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 75 | 0.69 | 1.21 | 187 | 12.11 | -895 |
| EMA200 | EURNOK | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 94 | 0.69 | 0.80 | 1267 | 36.93 | -3452 |
| EMA200 | USOIL | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 84 | 0.69 | 0.80 | 634 | 31.63 | -2295 |
| larry | XAGUSD | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.69 | 2.64 | 53 | 14.44 | -746 |
| EMA200 | GBPAUD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 81 (80 uniche) | 0.69 | 1.09 | 327 | 13.36 | -1106 |
| CostToCost | USOIL | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.69 | 0.82 | 378 | 45.14 | -4048 |
| GoldenCross | AUDUSD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 88 (87 uniche) | 0.69 | 1.02 | 136 | 12.89 | -993 |
| SupertrendReversal | GBPUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 85 (84 uniche) | 0.69 | 2.83 | 68 | 4.72 | -324 |
| SupertrendReversal | EURUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 99 (94 uniche) | 0.69 | 2.09 | 134 | 7.85 | -620 |
| Apertura | 100GBP | [NON MISURATO] | FTSE | backtest_pipeline/risultati_archivio/Apertura_nuovi_indici | UNICA | 72 | 0.69 | 0.90 | 311 | 19.21 | -1661 |
| larry | SPXUSD | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.69 | 3.19 | 56 | 12.63 | -990 |
| larry | USOIL | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.69 | 1.56 | 24 | 6.31 | -353 |
| EMA200 | EURNOK | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 88 | 0.69 | 0.80 | 1155 | 35.53 | -3195 |
| CostToCost | GBPNZD | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.69 | 1.01 | 347 | 53.90 | -4403 |
| MaxMin | F40EUR | [NON MISURATO] | MaxMinNotte | backtest_pipeline/risultati_archivio/MaxMinNotte | UNICA | 54 (47 uniche) | 0.68 | 1.00 | 96 | 14.43 | -1157 |
| GapFill | EURNOK | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 0.68 | 0.97 | 5 | 2.28 | -63 |
| SupertrendReversal | NZDCAD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 102 | 0.68 | 1.20 | 166 | 7.11 | -630 |
| EMA200 | EURSEK | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 85 | 0.68 | 0.87 | 1187 | 38.97 | -3551 |
| EMA200 | XNGUSD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 92 | 0.68 | 1.12 | 191 | 14.07 | -1034 |
| PTE | PTEJPY | H1 | VIVA_ORSO_r80nat | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 0.68 | 0.68 | 32 | 6.13 | -2667 |
| BreakingBand | NZDCAD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 3 | 0.68 | 173.68 | 3 | 1.05 | -33 |
| EMA200_Ottimizzato | XAUUSD | TF-OTT | ABTG_EMA200_Ottimizzato | backtest_pipeline/risultati_prove/ABTG_EMA200_Ottimizzato | IS | 10 | 0.68 | 1785.25 | 830 | 32.82 | -3028 |
| CostToCost | F40EUR | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.67 | 0.88 | 232 | 42.26 | -3702 |
| GoldenCross | USDPLN | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 91 (85 uniche) | 0.67 | 0.86 | 41 | 6.49 | -312 |
| EMA200 | EURSEK | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 86 | 0.67 | 0.87 | 1105 | 51.25 | -4788 |
| EMA200 | GBPNZD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 86 | 0.67 | 0.75 | 1104 | 41.39 | -4046 |
| SupertrendReversal | 200AUD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 102 (101 uniche) | 0.67 | 1.60 | 64 | 3.89 | -237 |
| CostToCost | CHFJPY | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.67 | 0.71 | 573 | 72.86 | -7132 |
| GoldenCross | GBPJPY | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 80 (69 uniche) | 0.67 | 1.41 | 31 | 3.26 | -255 |
| EasyTrend | E50EUR | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.67 | 0.94 | 70 | 15.94 | -1267 |
| R113_F4 | [NON MISURATO] | H1 | 00_metro | backtest_pipeline/risultati_archivio/R113_CORSA_20260827 | UNICA | 2 (1 uniche) | 0.66 | 0.66 | 55 | 1.81 | -1235 |
| EMA200 | GBPNZD | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 80 | 0.66 | 0.73 | 1065 | 42.98 | -4165 |
| SupertrendReversal | EURCAD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 94 | 0.66 | 1.14 | 178 | 10.90 | -760 |
| SupertrendReversal | GBPNZD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 103 | 0.66 | 1.07 | 228 | 16.53 | -1293 |
| EasyTrend | EURNZD | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.66 | 0.88 | 116 | 22.64 | -2086 |
| EMA200 | USOIL | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 90 | 0.66 | 0.78 | 587 | 35.23 | -2730 |
| SupertrendReversal | GBPCHF | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 94 | 0.66 | 2.49 | 63 | 6.39 | -336 |
| EMA200 | USDNOK | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 93 | 0.66 | 0.80 | 664 | 27.03 | -2442 |
| EMA200_Ottimizzato | XAUUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_EMA200_Ottimizzato | IS | 10 | 0.66 | 1785.25 | 39 | 2.28 | -172 |
| larry | 200AUD | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.66 | 1.70 | 33 | 7.00 | -432 |
| CostToCost | GBPAUD | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.66 | 0.91 | 318 | 45.18 | -4116 |
| EMA200 | USDNOK | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 85 | 0.65 | 0.79 | 570 | 22.55 | -2004 |
| SuperWave | D30EUR | H1 | SuperWave | backtest_pipeline/risultati_archivio/SuperWave | UNICA | 9 | 0.65 | 0.84 | 243 | 18.00 | -1260 |
| GoldenCross | EURGBP | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 90 (41 uniche) | 0.65 | 2.16 | 25 | 3.86 | -255 |
| Marco | NAS | [NON MISURATO] | emiliano | backtest_pipeline/risultati_archivio/Marco_Emiliano | UNICA | 16 | 0.65 | 0.76 | 129 | 5.09 | -329 |
| CostToCost | NZDCAD | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.65 | 0.81 | 146 | 31.60 | -3116 |
| BreakingBand | CADJPY | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.65 | 0.65 | 18 | 4.03 | -212 |
| SupertrendReversal | NZDCAD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 106 | 0.64 | 5.84 | 61 | 5.78 | -335 |
| CostToCost | EURCHF | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.64 | 0.79 | 192 | 30.05 | -2829 |
| BreakingBand | NZDUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.64 | 0.85 | 17 | 2.66 | -197 |
| SuperWave | XAUUSD | TF-OTT | ABTG_SuperWave | backtest_pipeline/risultati_prove/ABTG_SuperWave | IS | 9 | 0.64 | 3.33 | 153 | 5.64 | -409 |
| CostToCost | NZDCAD | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.64 | 0.74 | 644 | 76.63 | -7425 |
| CostToCost | 100GBP | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.64 | 0.95 | 201 | 37.28 | -3493 |
| EMA200 | E50EUR | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 81 | 0.64 | 0.95 | 127 | 7.10 | -506 |
| CostToCost | EURCAD | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.64 | 0.88 | 586 | 80.26 | -7989 |
| CostToCost | USDSEK | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.64 | 0.83 | 150 | 29.38 | -2501 |
| GoldenCross | USOIL | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 91 (70 uniche) | 0.64 | 13.43 | 6 | 1.57 | -34 |
| BreakingBand | EURSEK | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.64 | 30.16 | 7 | 2.44 | -73 |
| SuperWave | D30EUR | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_SuperWave | IS | 10 | 0.64 | 100.92 | 139 | 9.87 | -702 |
| CostToCost | EURNZD | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.64 | 0.69 | 699 | 71.66 | -6976 |
| GoldenCross | E50EUR | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 79 (62 uniche) | 0.63 | 1.96 | 79 | 7.86 | -759 |
| CostToCost | GBPJPY | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.63 | 0.92 | 247 | 48.51 | -4819 |
| EasyTrend | NZDUSD | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.63 | 0.81 | 111 | 24.85 | -2228 |
| R113_F4 | [NON MISURATO] | H1 | 01_long | backtest_pipeline/risultati_archivio/R113_CORSA_20260827 | UNICA | 2 (1 uniche) | 0.63 | 0.63 | 34 | 1.07 | -867 |
| larry | UKOIL | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.63 | 1.26 | 29 | 7.09 | -353 |
| BreakingBand | F40EUR | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.62 | 0.83 | 4 | 1.19 | -36 |
| SuperWave | D30EUR | TF-OTT | ABTG_SuperWave | backtest_pipeline/risultati_prove/ABTG_SuperWave | IS | 10 | 0.62 | 2810.00 | 139 | 10.13 | -744 |
| CostToCost | USDNOK | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.61 | 0.87 | 152 | 31.70 | -2510 |
| EMA200 | EURPLN | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 79 | 0.61 | 0.90 | 182 | 6.97 | -426 |
| COST | GBPCAD | H4 | ORSO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 0.61 | 0.61 | 48 | 18.90 | -12754 |
| COST | GBPCAD | H4 | ORSO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.61 | 0.61 | 48 | 18.90 | -12754 |
| larry | 100GBP | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.61 | 0.91 | 19 | 6.08 | -375 |
| EZ | AUDJPY | H1 | LATERALE_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 0.61 | 0.61 | 44 | 12.87 | -9993 |
| EZ | AUDJPY | H1 | LATERALE_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.61 | 0.61 | 44 | 12.87 | -9993 |
| CostToCost | GBPNZD | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.61 | 0.68 | 615 | 81.63 | -8150 |
| EasyTrend | USDNOK | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.60 | 0.68 | 45 | 18.42 | -1209 |
| EMA200 | 200AUD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_EMA200 | IS | 10 | 0.60 | 1.29 | 565 | 19.60 | -1935 |
| BB | EURUSD | H1 | TORO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 0.60 | 0.60 | 9 | 3.29 | -1561 |
| BB | EURUSD | H1 | TORO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.60 | 0.60 | 9 | 3.29 | -1561 |
| larry | USDNOK | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.60 | 1.42 | 30 | 7.57 | -542 |
| SupertrendReversal | XPDUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 89 (76 uniche) | 0.60 | 3509.54 | 16 | 68.86 | -5780 |
| SupRevScr | 100GBP | H1 | SupRev_nuovi_indici | backtest_pipeline/risultati_archivio/SupRev_nuovi_indici | UNICA | 27 | 0.60 | 0.88 | 129 | 6.18 | -553 |
| EasyTrend | XAGUSD | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.60 | 0.87 | 46 | 15.80 | -1164 |
| CostToCost | EURCHF | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.60 | 0.68 | 610 | 75.04 | -7367 |
| CostToCost | 100GBP | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.60 | 0.78 | 525 | 76.40 | -7600 |
| BreakingBand | GBPJPY | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.60 | 0.64 | 10 | 2.25 | -129 |
| SupertrendReversal | 100GBP | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 97 (95 uniche) | 0.60 | 2.12 | 122 | 5.22 | -518 |
| GoldenCross | GBPAUD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 92 (63 uniche) | 0.59 | 1.31 | 31 | 6.50 | -345 |
| CostToCost | EURGBP | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.59 | 0.70 | 647 | 82.57 | -8214 |
| EasyTrend | EURCAD | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.58 | 0.82 | 79 | 23.34 | -1951 |
| BreakingBand | GBPAUD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.58 | 1.18 | 8 | 1.77 | -127 |
| CostToCost | CADCHF | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.58 | 0.77 | 183 | 44.21 | -4274 |
| EasyTrend | 200AUD | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.58 | 0.78 | 50 | 15.94 | -1365 |
| EasyTrend | F40EUR | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.58 | 0.77 | 76 | 18.37 | -1700 |
| GoldenCross | 200AUD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 85 (69 uniche) | 0.58 | 1.00 | 83 | 7.72 | -547 |
| GoldenCross | GBPAUD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 81 (79 uniche) | 0.58 | 0.83 | 43 | 7.13 | -562 |
| CostToCost | XNGUSD | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.58 | 1.83 | 194 | 54.40 | -4481 |
| GoldenCross | USOIL | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 79 (78 uniche) | 0.58 | 0.90 | 21 | 4.21 | -179 |
| EasyTrend | CADCHF | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.57 | 0.77 | 33 | 11.44 | -963 |
| CostToCost | CADCHF | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.57 | 0.65 | 613 | 72.81 | -7248 |
| SupertrendReversal | EURNZD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 93 | 0.57 | 1.38 | 67 | 5.93 | -499 |
| EMA200 | USDPLN | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 91 | 0.57 | 0.63 | 937 | 53.07 | -5144 |
| EMA200 | USDPLN | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 80 | 0.57 | 0.64 | 972 | 53.50 | -5154 |
| SupertrendReversal | CHFJPY | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 104 | 0.57 | 1.76 | 467 | 29.01 | -2746 |
| GoldenCross | NZDJPY | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 83 (80 uniche) | 0.57 | 1.02 | 31 | 5.40 | -355 |
| BreakingBand | GBPCAD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.57 | 61.89 | 4 | 1.40 | -66 |
| GoldenCross | GBPNZD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 83 | 0.57 | 0.78 | 74 | 10.96 | -887 |
| BreakingBand | USDNOK | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 0.57 | 0.57 | 4 | 1.52 | -50 |
| BreakingBand | CHFJPY | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.56 | 41.02 | 4 | 1.24 | -46 |
| SW | GBPUSD | H2 | TORO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 0.56 | 0.56 | 65 | 5.48 | -3187 |
| SW | GBPUSD | H2 | TORO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.56 | 0.56 | 65 | 5.48 | -3187 |
| BreakingBand | GBPCAD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.56 | 0.78 | 27 | 5.04 | -418 |
| larry | F40EUR | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.56 | 1.28 | 46 | 11.78 | -1055 |
| CostToCost | GBPCAD | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.56 | 0.90 | 914 | 88.13 | -8792 |
| SupertrendReversal | NZDUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 102 (101 uniche) | 0.56 | 3.54 | 105 | 9.66 | -689 |
| larry | E50EUR | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.56 | 0.87 | 33 | 10.44 | -505 |
| BreakingBand | CADJPY | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 0.56 | 0.56 | 5 | 1.94 | -66 |
| BreakingBand | UKOIL | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.56 | 2.27 | 3 | 1.52 | -44 |
| CostToCost | GBPCHF | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.55 | 0.61 | 604 | 84.47 | -8419 |
| EMA200 | SPXUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_EMA200 | IS | 10 | 0.55 | 1.85 | 577 | 33.88 | -3322 |
| EasyTrend | NZDCHF | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.55 | 0.74 | 129 | 32.76 | -3101 |
| CostToCost | NZDCHF | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.55 | 0.64 | 636 | 84.37 | -8424 |
| BreakingBand | U30USD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.55 | 0.90 | 12 | 3.21 | -213 |
| PTE | PTEJPY | H1 | S25_ORSO_r80nat | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 0.55 | 0.55 | 24 | 3.96 | -1862 |
| BreakingBand | EURGBP | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.54 | 0.72 | 31 | 6.22 | -448 |
| CostToCost | USDPLN | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.54 | 0.57 | 546 | 86.07 | -8605 |
| BreakingBand | NZDCHF | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.54 | 1.86 | 8 | 2.22 | -120 |
| CostToCost | USDPLN | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.54 | 0.78 | 225 | 51.77 | -5103 |
| BreakingBand | USDNOK | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.54 | 0.70 | 12 | 3.25 | -191 |
| EasyTrend | NZDCAD | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.53 | 0.75 | 70 | 21.67 | -2138 |
| SupertrendReversal | USDPLN | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 102 | 0.53 | 4.70 | 74 | 9.19 | -538 |
| BreakingBand | USDSEK | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.53 | 0.54 | 16 | 3.45 | -213 |
| GoldenCross | NASUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 86 (39 uniche) | 0.53 | 1.40 | 20 | 2.57 | -148 |
| BreakingBand | U30USD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.53 | 0.74 | 6 | 2.88 | -125 |
| SupertrendReversal | XNGUSD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 99 | 0.52 | 2.65 | 26 | 1.31 | -84 |
| GoldenCross | EURGBP | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 83 (73 uniche) | 0.52 | 0.81 | 77 | 11.03 | -856 |
| SupertrendReversal | 100GBP | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 99 (94 uniche) | 0.52 | 15.08 | 55 | 3.98 | -291 |
| BreakingBand | GBPAUD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.52 | 0.57 | 5 | 1.85 | -96 |
| SupertrendReversal | GBPCHF | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 94 | 0.51 | 1.05 | 378 | 22.68 | -2238 |
| CostToCost | USDSEK | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.51 | 0.64 | 497 | 85.15 | -8508 |
| EMA200 | XNGUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 98 | 0.51 | 2.14 | 40 | 6.53 | -423 |
| EasyTrend | GBPCHF | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.51 | 0.98 | 100 | 32.13 | -3019 |
| EMA200 | E50EUR | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 83 (82 uniche) | 0.51 | 0.82 | 441 | 28.18 | -2631 |
| GoldenCross | F40EUR | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 80 (40 uniche) | 0.51 | 1.22 | 20 | 4.20 | -257 |
| GapFill | CHFJPY | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 0.51 | 0.51 | 5 | 2.07 | -99 |
| GoldenCross | EURSEK | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 82 (47 uniche) | 0.51 | 1.13 | 22 | 3.73 | -216 |
| GoldenCross | GBPNZD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 88 (77 uniche) | 0.51 | 1.12 | 21 | 5.34 | -346 |
| SupertrendReversal | NZDCHF | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 98 | 0.50 | 0.98 | 210 | 8.90 | -867 |
| CostToCost | EURSEK | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.50 | 0.53 | 144 | 46.93 | -4218 |
| EMA200 | USDSEK | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 82 | 0.50 | 0.57 | 535 | 31.81 | -3055 |
| COST | GBPCAD | H4 | CROLLO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 0.50 | 0.50 | 16 | 9.46 | -5979 |
| COST | GBPCAD | H4 | CROLLO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.50 | 0.50 | 16 | 9.46 | -5979 |
| MaxMin | 100GBP | [NON MISURATO] | MaxMinNotte | backtest_pipeline/risultati_archivio/MaxMinNotte | UNICA | 54 (43 uniche) | 0.50 | 0.67 | 195 | 46.37 | -4244 |
| EMA200 | SPXUSD | TF-OTT | ABTG_EMA200 | backtest_pipeline/risultati_prove/ABTG_EMA200 | IS | 10 | 0.50 | 1.85 | 774 | 44.29 | -4368 |
| MaxMin | E50EUR | [NON MISURATO] | MaxMinNotte | backtest_pipeline/risultati_archivio/MaxMinNotte | UNICA | 54 (50 uniche) | 0.50 | 0.84 | 160 | 33.28 | -3087 |
| larry | GBPNZD | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.49 | 1.17 | 70 | 18.59 | -1358 |
| BreakingBand | XAUUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 0.49 | 0.49 | 2 | 1.24 | -44 |
| GoldenCross | USDSEK | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 81 (74 uniche) | 0.49 | 0.94 | 28 | 3.82 | -352 |
| SupertrendReversal | EURCHF | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 99 | 0.49 | 1.09 | 362 | 18.91 | -1783 |
| SupertrendReversal | USDNOK | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 85 (83 uniche) | 0.48 | 2.45 | 138 | 13.52 | -994 |
| EasyTrend | XPTUSD | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.48 | 1.03 | 97 | 33.54 | -3142 |
| SupertrendReversal | CADCHF | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 91 (85 uniche) | 0.48 | 3.97 | 35 | 4.87 | -304 |
| EMA200 | E50EUR | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 88 | 0.48 | 0.74 | 401 | 25.49 | -2420 |
| EMA200 | USDSEK | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 87 | 0.48 | 0.54 | 1134 | 63.05 | -6227 |
| CostToCost | USDNOK | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.48 | 0.62 | 440 | 71.90 | -7183 |
| BreakingBand | CADJPY | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.47 | 0.75 | 12 | 4.04 | -236 |
| BreakingBand | EURSEK | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.47 | 0.61 | 15 | 3.46 | -303 |
| GoldenCross | EURCHF | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 86 (44 uniche) | 0.47 | 1.70 | 40 | 8.85 | -596 |
| BreakingBand | GBPNZD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.47 | 0.57 | 12 | 3.29 | -185 |
| EMA200 | XPTUSD | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 86 | 0.46 | 0.58 | 754 | 47.15 | -4713 |
| CostToCost | XPTUSD | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.46 | 0.75 | 184 | 44.62 | -4237 |
| SupertrendReversal | USDSEK | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 90 (88 uniche) | 0.46 | 1.06 | 28 | 4.08 | -270 |
| SupertrendReversal | USDNOK | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 93 | 0.46 | 1.01 | 614 | 47.61 | -4702 |
| BreakingBand | UKOIL | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.46 | 1.75 | 2 | 1.52 | -54 |
| BreakingBand | USDCHF | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 3 | 0.46 | 115.74 | 2 | 1.04 | -54 |
| BreakingBand | D30EUR | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.46 | 0.91 | 5 | 1.66 | -97 |
| BreakingBand | EURSEK | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.45 | 0.61 | 9 | 3.65 | -212 |
| SupertrendReversal | CADCHF | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 99 | 0.45 | 1.42 | 208 | 13.39 | -1206 |
| SupertrendReversal | EURCHF | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 97 (96 uniche) | 0.45 | 3.86 | 141 | 16.85 | -1237 |
| CostToCost | XPDUSD | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.45 | 0.57 | 204 | 59.18 | -5770 |
| GapFill | USDPLN | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 0.44 | 0.48 | 6 | 3.24 | -163 |
| PTE | PTEJPY | H1 | S25_CROLLO_r80nat | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 0.44 | 0.44 | 3 | 1.39 | -565 |
| CostToCost | EURSEK | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.44 | 0.52 | 335 | 72.85 | -7098 |
| SupertrendReversal | USDPLN | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 89 | 0.44 | 0.68 | 520 | 47.30 | -4673 |
| BreakingBand | NZDCHF | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.44 | 0.92 | 6 | 1.97 | -99 |
| SupertrendReversal | NZDCHF | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 94 (93 uniche) | 0.44 | 3.08 | 48 | 6.05 | -487 |
| BreakingBand | USDNOK | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 0.43 | 0.43 | 8 | 3.01 | -178 |
| EMA200 | EURPLN | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 87 | 0.43 | 0.60 | 621 | 44.16 | -4128 |
| BreakingBand | XAGUSD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.43 | 0.43 | 3 | 6.11 | -187 |
| BreakingBand | XAGUSD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.43 | 0.43 | 3 | 6.11 | -187 |
| BreakingBand | XPTUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.43 | 0.43 | 6 | 1.95 | -83 |
| SupertrendReversal | E35EUR | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 94 (84 uniche) | 0.43 | 4.48 | 10 | 0.59 | -32 |
| SupertrendReversal | XPDUSD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 90 (62 uniche) | 0.43 | 4306.33 | 9 | 57.70 | -2873 |
| CostToCost | XPTUSD | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.42 | 0.55 | 243 | 59.77 | -5940 |
| EMA200 | EURPLN | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 83 | 0.42 | 0.57 | 1134 | 79.18 | -7825 |
| BreakingBand | CADCHF | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.42 | 1.68 | 19 | 4.49 | -384 |
| EasyTrend | XPDUSD | H1 | scan | backtest_pipeline/risultati_prove/ABTG_EasyTrend/scan | UNICA | 6 | 0.41 | 0.56 | 96 | 32.92 | -3276 |
| BreakingBand | CADCHF | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.41 | 0.94 | 28 | 6.38 | -531 |
| EMA200 | XPDUSD | H1 | risultati_scan_ABTG_EMA200_H1 | backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1 | UNICA | 88 | 0.41 | 0.54 | 668 | 41.62 | -4096 |
| PTE | PTEGBP | H1 | B25_ORSO_r80nat | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 0.41 | 0.41 | 18 | 3.66 | -2389 |
| GoldenCross | EURNOK | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 80 (66 uniche) | 0.41 | 0.50 | 64 | 10.48 | -994 |
| BreakingBand | USDPLN | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.41 | 0.82 | 15 | 3.80 | -380 |
| PTE | PTEJPY | H1 | VIVA_CROLLO_r80nat | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 0.41 | 0.41 | 6 | 2.31 | -1219 |
| CostToCost | EURNOK | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.41 | 0.59 | 347 | 71.48 | -7070 |
| SupertrendReversal | EURNOK | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 99 | 0.40 | 0.83 | 676 | 55.30 | -5313 |
| GoldenCross | USDNOK | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 78 (72 uniche) | 0.40 | 0.59 | 114 | 21.62 | -2069 |
| R113_F2 | [NON MISURATO] | H1 | 00_metro | backtest_pipeline/risultati_archivio/R113_CORSA_20260827 | UNICA | 2 (1 uniche) | 0.40 | 0.40 | 3 | 0.37 | -96 |
| BreakingBand | GBPNZD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.39 | 0.43 | 13 | 3.72 | -271 |
| EZ | GBPUSD | H1 | CROLLO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 0.39 | 0.39 | 10 | 4.77 | -4507 |
| EZ | GBPUSD | H1 | CROLLO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.39 | 0.39 | 10 | 4.77 | -4507 |
| SuperWave | NASUSD | H4 | SuperWave | backtest_pipeline/risultati_archivio/SuperWave | UNICA | 9 (8 uniche) | 0.39 | 0.78 | 16 | 3.74 | -270 |
| BreakingBand | 200AUD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.39 | 0.73 | 4 | 1.16 | -66 |
| BreakingBand | GBPCAD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.38 | 0.38 | 10 | 3.02 | -221 |
| GoldenCross | 100GBP | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 89 (36 uniche) | 0.38 | 0.70 | 8 | 2.02 | -138 |
| SupertrendReversal | XNGUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 93 | 0.37 | 8.77 | 30 | 4.38 | -270 |
| EMA200 | XAGUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 87 | 0.37 | 1.37 | 53 | 21.45 | -1764 |
| CostToCost | EURNOK | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.37 | 0.47 | 688 | 94.58 | -9449 |
| CostToCost | XPDUSD | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.37 | 0.46 | 437 | 79.62 | -7925 |
| BB | EURUSD | H1 | LATERALE_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 0.37 | 0.37 | 9 | 2.95 | -2381 |
| BB | EURUSD | H1 | LATERALE_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.37 | 0.37 | 9 | 2.95 | -2381 |
| BreakingBand | NZDUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.36 | 0.40 | 12 | 3.87 | -347 |
| WOL | NASUSD | TF-OTT | ABTG_WOL | backtest_pipeline/risultati_prove/ABTG_WOL | IS | 9 | 0.36 | 8.41 | 44 | 0.36 | -21 |
| SupertrendReversal | USDSEK | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 95 | 0.36 | 1.04 | 295 | 36.51 | -3651 |
| BreakingBand | EURNZD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.35 | 0.46 | 9 | 2.25 | -168 |
| LARRY | GBPUSD | H1 | CROLLO_ANNO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.35 | 0.35 | 20 | 7.82 | -5723 |
| BreakingBand | USDPLN | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.34 | 0.86 | 19 | 5.12 | -510 |
| GoldenCross | XNGUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 89 (28 uniche) | 0.34 | 0.70 | 7 | 1.63 | -156 |
| GoldenCross | CADCHF | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 88 (37 uniche) | 0.34 | 3.23 | 30 | 7.18 | -618 |
| BreakingBand | USDSEK | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 0.34 | 0.34 | 7 | 2.88 | -178 |
| LARRY | GBPUSD | H1 | LATERALE_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 0.34 | 0.34 | 16 | 6.62 | -6445 |
| LARRY | GBPUSD | H1 | LATERALE_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.34 | 0.34 | 16 | 6.62 | -6445 |
| PTE | PTEJPY | H1 | VIVA_TORO_r80nat | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 0.33 | 0.33 | 22 | 4.97 | -4660 |
| BreakingBand | 225JPY | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.32 | 0.65 | 5 | 2.07 | -135 |
| GoldenCross | EURSEK | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 84 (69 uniche) | 0.32 | 0.48 | 103 | 24.83 | -2264 |
| GoldenCross | UKOIL | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 79 (33 uniche) | 0.32 | 0.86 | 13 | 4.31 | -313 |
| GapFill | XPTUSD | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 0.32 | 0.44 | 13 | 5.98 | -486 |
| GapFill | USDCHF | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 0.31 | 0.51 | 7 | 5.12 | -337 |
| BreakingBand | USDNOK | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 3 | 0.31 | 0.42 | 6 | 2.41 | -163 |
| GoldenCross | EURPLN | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 76 | 0.31 | 0.44 | 106 | 24.89 | -2426 |
| GapFill | XNGUSD | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 0.31 | 0.31 | 16 | 7.85 | -720 |
| GapFill | NZDCHF | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 0.31 | 0.76 | 2 | 1.56 | -70 |
| larry | XNGUSD | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 (11 uniche) | 0.30 | 0.73 | 7 | 3.72 | -240 |
| SupertrendReversal | EURSEK | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 103 (91 uniche) | 0.30 | 30.96 | 146 | 20.13 | -2011 |
| GoldenCross | E50EUR | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 92 (68 uniche) | 0.29 | 3.56 | 20 | 5.82 | -460 |
| LARRY | GBPUSD | H1 | CROLLO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 0.29 | 0.29 | 3 | 2.20 | -708 |
| LARRY | GBPUSD | H1 | CROLLO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.29 | 0.29 | 3 | 2.20 | -708 |
| EMA200 | E35EUR | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 85 | 0.29 | 0.93 | 33 | 6.39 | -456 |
| BreakingBand | EURNZD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.29 | 0.29 | 3 | 1.56 | -71 |
| SupertrendReversal | EURSEK | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 111 | 0.28 | 0.56 | 306 | 41.31 | -3986 |
| CostToCost | EURPLN | H4 | scan_h4 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h4 | UNICA | 9 | 0.28 | 0.30 | 352 | 84.49 | -8406 |
| BreakingBand | GBPCHF | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 0.28 | 0.28 | 2 | 1.15 | -71 |
| SupertrendReversal | EURNOK | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 104 (93 uniche) | 0.28 | 0.86 | 108 | 17.31 | -1469 |
| larry | EURNOK | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.28 | 0.54 | 35 | 14.20 | -1318 |
| BreakingBand | GBPJPY | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.27 | 0.27 | 2 | 1.24 | -78 |
| BreakingBand | GBPJPY | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.27 | 0.27 | 2 | 1.24 | -78 |
| PTE | USDJPY | H1 | CROLLO_r57 | backtest_pipeline/risultati_prove/regime_r57 | UNICA | 2 (1 uniche) | 0.26 | 0.26 | 5 | 3.46 | -2193 |
| larry | XPDUSD | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.26 | 0.86 | 42 | 18.27 | -1579 |
| GoldenCross | EURNOK | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 79 (34 uniche) | 0.25 | 1.67 | 17 | 5.44 | -462 |
| CostToCost | EURPLN | H1 | scan_h1 | backtest_pipeline/risultati_prove/ABTG_CostToCost/scan_h1 | UNICA | 9 | 0.25 | 0.29 | 437 | 92.74 | -9271 |
| BreakingBand | EURNOK | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.25 | 0.58 | 16 | 6.26 | -579 |
| GoldenCross | XNGUSD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC | UNICA | 90 (86 uniche) | 0.24 | 0.49 | 28 | 9.98 | -781 |
| SupertrendReversal | EURPLN | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H4_OHLC | UNICA | 98 (89 uniche) | 0.24 | 0.83 | 93 | 16.07 | -1517 |
| GoldenCross | EURPLN | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/GoldenCross/H4_OHLC | UNICA | 89 (54 uniche) | 0.23 | 0.37 | 37 | 13.68 | -1259 |
| PTE | PTEJPY | H1 | S25_TORO_r80nat | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 0.23 | 0.23 | 17 | 2.90 | -2702 |
| PTE | PTEGBP | H1 | VIVA_ORSO_r80nat | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 0.23 | 0.23 | 16 | 5.58 | -4646 |
| SupertrendReversal | EURPLN | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 101 | 0.22 | 0.43 | 284 | 47.99 | -4580 |
| larry | EURPLN | H1 | notte | backtest_pipeline/risultati_prove/ABTG_PunteLarry/notte | UNICA | 12 | 0.22 | 43.28 | 43 | 18.30 | -1548 |
| EMA200 | XPTUSD | H4 | H4_OHLC | backtest_pipeline/risultati_archivio/EMA200/H4_OHLC | UNICA | 79 (64 uniche) | 0.22 | 1061.84 | 13 | 60.13 | -5613 |
| SupertrendReversal | XPTUSD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/SupertrendReversal/H1_OHLC | UNICA | 95 (52 uniche) | 0.21 | 6083.90 | 6 | 49.05 | -3134 |
| WOL | SPXUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_WOL | IS | 10 | 0.21 | 4.59 | 11 | 0.05 | -3 |
| WOL | XAGUSD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_WOL | IS | 10 | 0.19 | 1.42 | 12 | 0.57 | -16 |
| BreakingBand | EURGBP | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.18 | 38.06 | 2 | 1.21 | -83 |
| BreakingBand | 225JPY | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.18 | 0.36 | 4 | 2.07 | -163 |
| WOL | U30USD | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_WOL | IS | 10 | 0.16 | 9.07 | 13 | 2.64 | -171 |
| WOL | D30EUR | TF-OTT | ohlc | backtest_pipeline/risultati_prove/ABTG_WOL | IS | 9 | 0.15 | 1.02 | 28 | 0.88 | -36 |
| GapFill | USDJPY | H1 | scan1 | backtest_pipeline/risultati_prove/ABTG_GapFill/scan1 | UNICA | 3 | 0.15 | 0.22 | 7 | 5.45 | -419 |
| BreakingBand | CHFJPY | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 0.14 | 0.14 | 2 | 1.63 | -86 |
| BreakingBand | EURNOK | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.13 | 0.71 | 10 | 5.51 | -504 |
| BreakingBand | USDNOK | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 3 | 0.11 | 0.18 | 4 | 2.57 | -212 |
| WOL | U30USD | TF-OTT | ABTG_WOL | backtest_pipeline/risultati_prove/ABTG_WOL | IS | 10 | 0.08 | 44.06 | 15 | 2.74 | -204 |
| BreakingBand | EURNOK | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 0.06 | 0.06 | 3 | 1.90 | -128 |
| BreakingBand | CADCHF | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.06 | 0.06 | 3 | 1.39 | -104 |
| BreakingBand | GBPAUD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 3 | 0.06 | 18.97 | 2 | 1.88 | -96 |
| COST | EURJPY | H4 | CROLLO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 0.02 | 0.02 | 23 | 14.83 | -12711 |
| COST | EURJPY | H4 | CROLLO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.02 | 0.02 | 23 | 14.83 | -12711 |
| MaxMinNotte | EURUSD | [NON MISURATO] | ohlc | backtest_pipeline/risultati_prove/ABTG_MaxMinNotte | IS | 2 (1 uniche) | 0.00 | 0.00 | 1 | 2.09 | -209 |
| OpeningReversalB | U30USD | [NON MISURATO] | P0B_SIGNAL | backtest_pipeline/risultati_prove/ABTG_OpeningReversalB | IS | 3 (2 uniche) | 0.00 | 1.83 | 1 | 0.04 | 127 |
| SupertrendInvert | U30USD | M20 | ohlc | backtest_pipeline/risultati_prove/ABTG_SupertrendInvert | IS | 1 | 0.00 | 0.00 | 2 | 0.87 | 16 |
| WOL | D30EUR | TF-OTT | ABTG_WOL | backtest_pipeline/risultati_prove/ABTG_WOL | IS | 9 | 0.00 | 11.83 | 3 | 0.01 | -0 |
| WOL | SPXUSD | TF-OTT | ABTG_WOL | backtest_pipeline/risultati_prove/ABTG_WOL | IS | 10 | 0.00 | 3.63 | 4 | 0.01 | -1 |
| EMA200 | XPDUSD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 29 (11 uniche) | 0.00 | 0.00 | 1 | 43.60 | -4195 |
| EMA200 | XPTUSD | H1 | H1_OHLC | backtest_pipeline/risultati_archivio/EMA200/H1_OHLC | UNICA | 47 (26 uniche) | 0.00 | 0.09 | 7 | 5.49 | -549 |
| R113_F0 | [NON MISURATO] | H1 | 01_long | backtest_pipeline/risultati_archivio/R113_CORSA_20260827 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 2 | 0.28 | 378 |
| R113_F2 | [NON MISURATO] | H1 | 01_long | backtest_pipeline/risultati_archivio/R113_CORSA_20260827 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 2 | 0.21 | 63 |
| R113_F2 | [NON MISURATO] | H1 | 02_short | backtest_pipeline/risultati_archivio/R113_CORSA_20260827 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 0.22 | -159 |
| R113_F3 | [NON MISURATO] | H1 | 01_long | backtest_pipeline/risultati_archivio/R113_CORSA_20260827 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 4 | 0.21 | 415 |
| R113_F3 | [NON MISURATO] | H1 | 02_short | backtest_pipeline/risultati_archivio/R113_CORSA_20260827 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 0.22 | -159 |
| PTE | PTEJPY | H1 | S25_CROLLO_r80ext | backtest_pipeline/risultati_archivio/csv_R80 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 6 | 0.70 | 1331 |
| BreakingBand | 225JPY | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.00 | 0.51 | 1 | 0.79 | 13 |
| BreakingBand | E50EUR | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 2 | 0.38 | 68 |
| BreakingBand | EURJPY | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 1.03 | -100 |
| BreakingBand | F40EUR | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 2 | 0.81 | 50 |
| BreakingBand | NASUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 0.74 | 59 |
| BreakingBand | SPXUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 0.50 | 65 |
| BreakingBand | UKOIL | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 0.64 | -19 |
| BreakingBand | XNGUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 0.50 | 81 |
| BreakingBand | XPDUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 0.39 | -9 |
| BreakingBand | XPTUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 2 | 1.33 | -96 |
| BreakingBand | 225JPY | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 2 | 0.86 | -77 |
| BreakingBand | CADJPY | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 1.03 | -99 |
| BreakingBand | E35EUR | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 0.36 | 18 |
| BreakingBand | SPXUSD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 1.06 | -100 |
| BreakingBand | USOIL | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 0.48 | -18 |
| BreakingBand | XAUUSD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 0.95 | -34 |
| BreakingBand | 100GBP | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.00 | 0.00 | 4 | 0.49 | 184 |
| BreakingBand | 200AUD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 3 | 0.35 | 42 |
| BreakingBand | E35EUR | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 1.30 | -104 |
| BreakingBand | E50EUR | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.00 | 2.43 | 1 | 0.19 | 30 |
| BreakingBand | F40EUR | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.00 | 0.00 | 2 | 0.81 | 60 |
| BreakingBand | SPXUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.00 | 0.00 | 8 | 0.50 | 273 |
| BreakingBand | USOIL | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.00 | 0.00 | 5 | 0.56 | 169 |
| BreakingBand | XNGUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 0.50 | 81 |
| BreakingBand | 100GBP | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 0.06 | 5 |
| BreakingBand | 225JPY | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 2 | 0.46 | 112 |
| BreakingBand | CADCHF | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 1.17 | -101 |
| BreakingBand | EURAUD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 0.59 | -10 |
| BreakingBand | EURCAD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 0.49 | -6 |
| BreakingBand | SPXUSD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 0.78 | 2 |
| BreakingBand | U30USD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 0.25 | 45 |
| BreakingBand | XNGUSD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 0.19 | 21 |
| BreakingBand | E35EUR | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 1.30 | -104 |
| BreakingBand | E50EUR | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.00 | 2.43 | 1 | 0.49 | -12 |
| BreakingBand | USOIL | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 3 | 0.00 | 0.00 | 3 | 0.43 | 45 |
| BreakingBand | XNGUSD | H1 | risultati_scan_ABTG_BreakingBand_H1 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H1 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 2 | 0.71 | 121 |
| BreakingBand | 100GBP | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 0.06 | 5 |
| BreakingBand | 200AUD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 2 | 0.55 | 53 |
| BreakingBand | 225JPY | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 2 | 0.46 | 112 |
| BreakingBand | E35EUR | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 0.47 | 40 |
| BreakingBand | EURCAD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 0.49 | -6 |
| BreakingBand | F40EUR | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 0.29 | 44 |
| BreakingBand | NASUSD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 0.66 | -0 |
| BreakingBand | SPXUSD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 2 | 0.77 | 36 |
| BreakingBand | U30USD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 0.25 | 45 |
| BreakingBand | XNGUSD | H4 | risultati_scan_ABTG_BreakingBand_H4 | backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 0.19 | 21 |
| BB | EURUSD | H1 | CROLLO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 0.24 | 502 |
| EZ | CHFJPY | H1 | LATERALE_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 2.44 | 3 |
| GAP | GBPUSD | H1 | LATERALE_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 0.18 | 1000 |
| LARRY | ORO | H1 | CROLLO_r50 | backtest_pipeline/risultati_prove/regime_r50 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 1.03 | 1496 |
| BB | EURUSD | H1 | CROLLO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 0.24 | 502 |
| EZ | CHFJPY | H1 | LATERALE_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 2.44 | 3 |
| GAP | GBPUSD | H1 | LATERALE_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 0.18 | 1000 |
| LARRY | ORO | H1 | CROLLO_r59 | backtest_pipeline/risultati_prove/regime_r59 | UNICA | 2 (1 uniche) | 0.00 | 0.00 | 1 | 1.03 | 1496 |

---

## 🚫 I 109 CSV CON `Trades = 0` SU TUTTE LE PASSATE — "NON E' GIRATA", non "nessun edge"

Regola di casa esplicita: un file con zero operazioni **non ha misurato niente**. Non e' una
bocciatura del motore, e' una corsa che non e' partita (simbolo/periodo/filtri che non hanno
mai fatto scattare un ingresso). Vanno rifatte, non archiviate come "senza edge".

| CSV | passate tutte a Trades=0 |
|---|---|
| `backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC/scan_ABTG_GoldenCross_H1_XPDUSD.csv` | 123 |
| `backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC/scan_ABTG_GoldenCross_H1_XPTUSD.csv` | 127 |
| `backtest_pipeline/risultati_archivio/R113_CORSA_20260827/R113_F1_02_short.csv` | 2 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1/scan_ABTG_BreakingBand_H1_200AUD.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1/scan_ABTG_BreakingBand_H1_D30EUR.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1/scan_ABTG_BreakingBand_H1_E35EUR.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1/scan_ABTG_BreakingBand_H1_EURCHF.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1/scan_ABTG_BreakingBand_H1_EURNZD.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1/scan_ABTG_BreakingBand_H1_NZDJPY.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1/scan_ABTG_BreakingBand_H1_U30USD.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1/scan_ABTG_BreakingBand_H1_USOIL.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_100GBP.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_200AUD.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_AUDJPY.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_D30EUR.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_E50EUR.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_EURAUD.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_EURCAD.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_EURCHF.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_EURNOK.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_EURNZD.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_EURSEK.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_EURUSD.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_F40EUR.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_GBPNZD.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_GBPUSD.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_NASUSD.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_NZDCHF.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_U30USD.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_UKOIL.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_USDCHF.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_USDPLN.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_XAGUSD.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_XNGUSD.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_XPTUSD.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_200AUD.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_AUDUSD.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_D30EUR.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_E35EUR.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_E50EUR.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_EURCHF.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_EURJPY.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_F40EUR.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_GBPUSD.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_NASUSD.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_NZDJPY.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_UKOIL.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_USDCAD.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_USOIL.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_XPDUSD.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_XPTUSD.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_AUDUSD.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_D30EUR.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_E50EUR.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_EURCHF.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_EURJPY.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_NZDJPY.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_UKOIL.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_USDCAD.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_USOIL.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4/scan_ABTG_BreakingBand_H4_XPDUSD.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_GapFill/tick/valid_ABTG_GapFill_H1_realtick_E35EUR.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_MaxMinNotte/ABTG_MaxMinNotte_EURUSD_OOS_ohlc.csv` | 2 |
| `backtest_pipeline/risultati_prove/ABTG_Nightly/ABTG_Nightly_AUDUSD_IS_ohlc.csv` | 2 |
| `backtest_pipeline/risultati_prove/ABTG_Nightly/ABTG_Nightly_AUDUSD_OOS_ohlc.csv` | 2 |
| `backtest_pipeline/risultati_prove/ABTG_Nightly/ABTG_Nightly_D30EUR_IS_ohlc.csv` | 2 |
| `backtest_pipeline/risultati_prove/ABTG_Nightly/ABTG_Nightly_D30EUR_OOS_ohlc.csv` | 2 |
| `backtest_pipeline/risultati_prove/ABTG_Nightly/ABTG_Nightly_U30USD_IS_ohlc.csv` | 2 |
| `backtest_pipeline/risultati_prove/ABTG_Nightly/ABTG_Nightly_U30USD_OOS_ohlc.csv` | 2 |
| `backtest_pipeline/risultati_prove/ABTG_Nightly/ABTG_Nightly_USDJPY_IS_ohlc.csv` | 2 |
| `backtest_pipeline/risultati_prove/ABTG_Nightly/ABTG_Nightly_USDJPY_OOS_ohlc.csv` | 2 |
| `backtest_pipeline/risultati_prove/ABTG_Nightly/ABTG_Nightly_XAGUSD_IS_ohlc.csv` | 2 |
| `backtest_pipeline/risultati_prove/ABTG_Nightly/ABTG_Nightly_XAUUSD_IS_ohlc.csv` | 2 |
| `backtest_pipeline/risultati_prove/ABTG_Nightly/ABTG_Nightly_XAUUSD_OOS_ohlc.csv` | 2 |
| `backtest_pipeline/risultati_prove/ABTG_OpeningReversalB/ABTG_OpeningReversalB_U30USD_OOS_P0A_FAIL.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_OpeningReversalB/ABTG_OpeningReversalB_U30USD_OOS_P0B_SIGNAL.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_OpeningReversalB/ABTG_OpeningReversalB_U30USD_OOS_P0CONTA.csv` | 2 |
| `backtest_pipeline/risultati_prove/ABTG_OpeningReversalB/ABTG_OpeningReversalB_U30USD_OOS_P0C_FT.csv` | 3 |
| `backtest_pipeline/risultati_prove/ABTG_PostNews/ABTG_PostNews_EURJPY_IS_ohlc.csv` | 2 |
| `backtest_pipeline/risultati_prove/ABTG_PostNews/ABTG_PostNews_EURJPY_OOS_ohlc.csv` | 2 |
| `backtest_pipeline/risultati_prove/ABTG_PostNews/ABTG_PostNews_EURUSD_IS_ohlc.csv` | 2 |
| `backtest_pipeline/risultati_prove/ABTG_PostNews/ABTG_PostNews_EURUSD_OOS_ohlc.csv` | 2 |
| `backtest_pipeline/risultati_prove/ABTG_SupertrendInvert/ABTG_SupertrendInvert_225JPY_IS_ohlc.csv` | 11 |
| `backtest_pipeline/risultati_prove/ABTG_SupertrendInvert/ABTG_SupertrendInvert_D30EUR_IS_ohlc.csv` | 11 |
| `backtest_pipeline/risultati_prove/ABTG_SupertrendInvert/ABTG_SupertrendInvert_D30EUR_OOS_ohlc.csv` | 11 |
| `backtest_pipeline/risultati_prove/ABTG_SupertrendInvert/ABTG_SupertrendInvert_EURUSD_IS_ohlc.csv` | 11 |
| `backtest_pipeline/risultati_prove/ABTG_SupertrendInvert/ABTG_SupertrendInvert_EURUSD_OOS_ohlc.csv` | 11 |
| `backtest_pipeline/risultati_prove/ABTG_SupertrendInvert/ABTG_SupertrendInvert_GBPJPY_IS_ohlc.csv` | 11 |
| `backtest_pipeline/risultati_prove/ABTG_SupertrendInvert/ABTG_SupertrendInvert_GBPJPY_OOS_ohlc.csv` | 11 |
| `backtest_pipeline/risultati_prove/ABTG_SupertrendInvert/ABTG_SupertrendInvert_NASUSD_IS_ohlc.csv` | 11 |
| `backtest_pipeline/risultati_prove/ABTG_SupertrendInvert/ABTG_SupertrendInvert_U30USD_OOS_ohlc.csv` | 11 |
| `backtest_pipeline/risultati_prove/ABTG_SupertrendInvert/ABTG_SupertrendInvert_XAGUSD_IS_ohlc.csv` | 11 |
| `backtest_pipeline/risultati_prove/ABTG_SupertrendInvert/ABTG_SupertrendInvert_XAUUSD_IS_ohlc.csv` | 11 |
| `backtest_pipeline/risultati_prove/regime_r50/GAP_EURUSD_CROLLO_r50.csv` | 2 |
| `backtest_pipeline/risultati_prove/regime_r50/GAP_EURUSD_LATERALE_r50.csv` | 2 |
| `backtest_pipeline/risultati_prove/regime_r50/GAP_EURUSD_ORSO_r50.csv` | 2 |
| `backtest_pipeline/risultati_prove/regime_r50/GAP_EURUSD_TORO_r50.csv` | 2 |
| `backtest_pipeline/risultati_prove/regime_r50/GAP_GBPUSD_CROLLO_r50.csv` | 2 |
| `backtest_pipeline/risultati_prove/regime_r50/GAP_GBPUSD_ORSO_r50.csv` | 2 |
| `backtest_pipeline/risultati_prove/regime_r50/GAP_GBPUSD_TORO_r50.csv` | 2 |
| `backtest_pipeline/risultati_prove/regime_r59/GAP_EURUSD_CROLLO_ANNO_r59.csv` | 2 |
| `backtest_pipeline/risultati_prove/regime_r59/GAP_EURUSD_CROLLO_r59.csv` | 2 |
| `backtest_pipeline/risultati_prove/regime_r59/GAP_EURUSD_LATERALE_r59.csv` | 2 |
| `backtest_pipeline/risultati_prove/regime_r59/GAP_EURUSD_ORSO_r59.csv` | 2 |
| `backtest_pipeline/risultati_prove/regime_r59/GAP_EURUSD_TORO_r59.csv` | 2 |
| `backtest_pipeline/risultati_prove/regime_r59/GAP_GBPUSD_CROLLO_ANNO_r59.csv` | 2 |
| `backtest_pipeline/risultati_prove/regime_r59/GAP_GBPUSD_CROLLO_r59.csv` | 2 |
| `backtest_pipeline/risultati_prove/regime_r59/GAP_GBPUSD_ORSO_r59.csv` | 2 |
| `backtest_pipeline/risultati_prove/regime_r59/GAP_GBPUSD_TORO_r59.csv` | 2 |

**Concentrazione per cartella:**

| Cartella | CSV a zero |
|---|---|
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H4` | 24 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan2/risultati_scan_ABTG_BreakingBand_H4` | 16 |
| `backtest_pipeline/risultati_prove/ABTG_Nightly` | 11 |
| `backtest_pipeline/risultati_prove/ABTG_SupertrendInvert` | 11 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/scan3bis/risultati_scan_ABTG_BreakingBand_H4` | 10 |
| `backtest_pipeline/risultati_prove/regime_r59` | 9 |
| `backtest_pipeline/risultati_prove/ABTG_BreakingBand/risultati_scan_ABTG_BreakingBand_H1` | 8 |
| `backtest_pipeline/risultati_prove/regime_r50` | 7 |
| `backtest_pipeline/risultati_prove/ABTG_OpeningReversalB` | 4 |
| `backtest_pipeline/risultati_prove/ABTG_PostNews` | 4 |
| `backtest_pipeline/risultati_archivio/GoldenCross/H1_OHLC` | 2 |
| `backtest_pipeline/risultati_archivio/R113_CORSA_20260827` | 1 |
| `backtest_pipeline/risultati_prove/ABTG_GapFill/tick` | 1 |
| `backtest_pipeline/risultati_prove/ABTG_MaxMinNotte` | 1 |

---

## 🕳️ BUCHI DICHIARATI

Quello che questo censimento **non** ha potuto misurare, detto per nome.

### 1. Cartelle / file non letti

**Nessuna.** Tutte e 148 le cartelle sotto `risultati_archivio/`, `risultati_prove/` e
`prove/` sono state aperte e lette; tutti e 2069 i CSV con intestazione da tester
sono stati parsati senza errori di lettura o di codifica. Zero file illeggibili, zero file
con la sola intestazione.

### 2. Buchi di INFORMAZIONE (il dato non c'e' nel CSV, quindi non e' stato inventato)

| Buco | Righe colpite | Perche' |
|---|---|---|
| **TF `[NON MISURATO]`** | 230 | Il nome file non porta il TF, la colonna `InpTF` non c'e' nell'intestazione e la cartella non lo dice. Il TF esiste, ma **non e' scritto da nessuna parte nei dati**: dedurlo sarebbe stimare. |
| **TF = `TF-OTT`** | 108 | `InpTF` era un parametro OTTIMIZZATO: la corsa non ha UN timeframe, ne ha molti. Il PF mediano di quella corsa e' quindi mediano **anche sui TF**, e va letto sapendolo. |
| **Simbolo `[NON MISURATO]`** | 18 | Corse `R113_*` e `R114_*`: il nome file (`R113_F0_00_metro`) non contiene il simbolo e i CSV non hanno colonna `Simbolo`. **Non l'ho dedotto dai criteri**: sarebbe un'inferenza, non una misura. |
| **`PTEGBP_*` / `PTEJPY_*` (round R80)** | 40 | Il motore e' PTE (dichiarato dal nome), ma **il simbolo esatto non e' nel file**: resta scritto `PTEGBP`/`PTEJPY` cosi' com'e'. Che siano GBPUSD e USDJPY e' probabile ma **non misurato**, e non l'ho scritto come se lo fosse. |

### 3. Buchi di METODO (limiti veri di questa tabella, da sapere prima di usarla)

- 🔴 **Un PF non e' un verdetto.** Questa tabella non sa se una corsa fosse in tick reali o
  OHLC, con che spread, su che finestra di date, con che regola di uscita. Due righe con lo
  stesso PF possono essere una misura seria e una carta straccia. **Il PF qui serve a
  RIAPRIRE un caso, non a promuoverlo.**
- 🔴 **Le date della finestra non sono nei CSV.** Nessuna colonna porta il periodo testato,
  quindi la tabella **non puo' dire** se un IS rispetta l'emendamento della finestra
  (>= 150 operazioni, regime dichiarato). Il campo `Trades` e' l'unico proxy — ed e' per
  quello che sta in tabella accanto a ogni PF.
- 🔴 **"Scartato" non e' una colonna misurabile qui.** I CSV non registrano il verdetto: la
  tabella e' il censimento di TUTTO cio' che e' stato misurato, promosso e scartato insieme.
  Chi e' stato scartato e perche' sta nei referti — ed e' il pezzo che qui, per mandato,
  **non ho letto**.
- 🔴 **`DD%` e `Profit` sono quelli della cella MEDIANA**, non il DD peggiore della corsa.
  Per il criterio di RISCHIO (DD forward > DD promesso) serve il DD della cella
  effettivamente promossa: **quello va ripreso dal CSV grezzo**, riga per riga.
- 🔴 **Nessuna deduplicazione fra cartelle.** La stessa corsa ricopiata in due cartelle
  compare due volte. E' voluto: la cartella e' in tabella, cosi' si vede.

---

*Generato il 09/09/2026 su 1960 CSV di risultati, 45865 passate valide considerate.*
