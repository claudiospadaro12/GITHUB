# 🔎 AUDIT PER SINGOLO EA — il perimetro, prima di ogni scheda (28/09/2026)

Briefing ricevuto il 28/09 da Claudio (con Gemini): audit tecnico/parametrico/statistico di ogni EA del portafoglio
FTMO, schede A-E per EA, priorita' 3.1 (DAX apertura) e 3.2 (Dow apertura). Prima di scrivere la prima scheda, **la
lista del briefing e' stata confrontata con il campo vero**. Non coincidono, e la differenza va detta per prima.

## 1. La lista del briefing e' la SQUADRA 100k (dry-run), non la challenge FTMO

| briefing | dove gira DAVVERO (CODA_01 del 28/09) | conto | rischio vero |
|---|---|---|---|
| EA 3.1 Apertura Europea in Retest (DAX) | `ABTG_DAX_Apertura_EU` magic `770101` | FTMO `541452707` (`C:\FTMO`) **e** 100k `50504263` | **2,00%** su FTMO (preset r. `InpRiskPercent=2.00`); 0,65% sul 100k |
| EA 3.2 Apertura USA in Retest (Dow) | `ABTG_Dow_Apertura_US` magic `770202` | FTMO **e** 100k | **2,00%** su FTMO; 0,65% sul 100k |
| EA 3.3 Box Notturno Short (DAX) | `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` magic `770411` | FTMO **e** 100k | **2,00%** su FTMO; 0,65% sul 100k |
| EA 3.4 Supertrend Nikkei | `ABTG_SupertrendReversal` magic `770901` 225JPY H2 | **SOLO 100k** `50504263` | 0,65% — **NON e' su FTMO** |
| EA 3.5 ORB Dow | `ABTG_ORB_Ottimizzato` magic `770611` U30USD M5 | **SOLO 100k** | 0,30% — **NON e' su FTMO** |
| EA 0.0 Guardiano "5% / 10%" | `CLAU12_Guardian` magic `779001` su `C:\FTMO` | FTMO | soglie VERE: pausa **3,5** / taglio giornaliero **4,5** / totale **9,3** / cap **4,00%** (non 5/10: quelli sono i muri FTMO) |

**Sedie FTMO che il briefing NON elenca** (tutte al 2,00%): `770105` DAX short (viva dal 25/09, assente dalla sonda
per la classe 822), `770260` Nasdaq L+S M5, `771531` EMA200 Dow H1 L+S, `770511` SuperWave Dow H1 L+S.
Quindi su FTMO girano **sette** sedie, di cui **quattro sugli indici USA** (tre sul Dow).

## 2. I criteri: quelli di casa, e quelli del briefing accanto

| tema | briefing | regola di casa (congelata, `CLAUDE.md` / `FIRME_2026-08-18`) |
|---|---|---|
| n per il MERITO | n >= 30 forward, n >= 60 per il DD | **n >= 150** posizioni (backtest); in campo: rischio per sedia a qualunque n, merito per famiglia a 20 op |
| soglia PF | < 1,10 = degrado | PF >= 1,10 IS **e** OOS, altopiano al centro mai il picco |
| stress costi | +30/50% | `STRESS_ORO_LONG_2026-09-27.md`: S1/S2/S3 (+25/+50/+100%), frontiera `stop >= 40 x (spread+comm.)` |
| Guardian | 5% / 10% | 4,5 / 9,3 con margine 400 / 560 EUR ai muri FTMO (`MC_STRESS_CONGIUNTO_2026-09-28.md`) |

Le schede usano i criteri di casa e riportano accanto la lettura coi numeri del briefing: due unita' di misura
diverse per lo stesso numero, mai una sola.

## 3. Ordine delle schede
1. `770101` DAX apertura long (EA 3.1) · 2. `770202` Dow apertura long (EA 3.2) · poi `770411`, `770105`, `770260`,
`771531`, `770511`, e infine il Guardian (per il quale esiste gia' `FAILURE_INJECTION_GUARDIAN_BOZZA_2026-09-28.md`).
Le due sedie solo-100k (`770901`, `770611`) vengono dopo le sette in campo.

Nessuna taglia e' proposta in questo audit: i numeri di rischio restano firme di Claudio. Nessun EA, preset o
sedia viene toccato.
