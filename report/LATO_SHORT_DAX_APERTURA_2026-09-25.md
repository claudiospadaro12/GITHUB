# 🐻 IL LATO SHORT DELL'APERTURA DAX: cosa e' misurato, cosa cambia, cosa manca (25/09/2026)

**Domanda di Claudio (25/09 sera):** _"Perche' non riusciamo a fare la stessa identica cosa con lo
short? Voglio fare esattamente come col long anche con lo short. Cosa cambia?"_
**Sola lettura, zero tempo macchina.** Nessun EA, preset o conto toccato.

## 1. 🔧 Nel codice non cambia niente
`ABTG_DAX_Apertura_EU.mq5` ha il ramo SELL speculare del BUY (`MonitorRetest()` r.1966) e la formula
dello stop e' la stessa (`dist = range + buffer - offset`, r.1930-1933 contro r.1973-1976). Lo short
e' **una manopola**: `InpAllowShort`. Nel preset FTMO `770101` e' `false`.

## 2. 📊 E' GIA' MISURATO, con la stessa identica macchina — FASE M, 07/08/2026
Fonte: `backtest_pipeline/risultati_archivio/Walkforward_Aperture/DAX_M_direzione_IS.csv` e `_OOS.csv`,
referto `REFERTO_FASE_M.md`, commit `0a4e17c7`. Stessa geometria della sedia: `InpEntryMode=2` (RETEST),
`InpSessionHour=8`, `InpRangeMode=0`, trailing acceso; D30EUR M5, tick, **rischio 1%**.
IS 2024.09.26-2025.06.30, OOS 2025.07.01-2026.06.30.

| range | lato | IS: PF · n · DD | OOS: PF · n · DD |
|---:|---|---|---|
| **35** (= la sedia) | **SOLO LONG** | **1,131** · 189 · 5,36% | **1,423** · 256 · 6,72% |
| **35** | **SOLO SHORT** | **0,846** · 152 · 10,54% | **1,065** · 243 · 12,05% |
| 35 | long + short | 0,998 · 224 · 8,41% | 1,237 · 316 · 10,49% |
| 25 | SOLO SHORT | 0,824 · 153 · 10,83% | 0,934 · 245 · 14,09% |
| 45 | SOLO SHORT | 0,771 · 153 · 11,89% | 1,212 · 237 · 9,02% |

- 🔴 **Lo short perde nell'IS su tutti e tre i range** (PF 0,77-0,85) e fa **DD quasi doppi** del long.
- 🔴 **A rischio 2% (FTMO)** il DD OOS dello short a range 35 diventa **~24%** [DERIVATO, scala lineare
  approssimata]: oltre il muro del 10%.
- 🔴 **Accenderlo sulla sedia non somma, sostituisce**: 256 + 243 = 499, ma insieme fanno **316**.
  Con `InpOneTradePerDay` il primo lato che scatta si prende il posto della giornata: su range 35 l'OOS
  passa da PF 1,423 / DD 6,72% a **1,237 / 10,49%**.
- Per la regola B di casa (il vecchio giudica il RISCHIO): un DD di 10,5% a 1% in una finestra gia'
  vissuta e' un fatto, non una stima.

## 3. 🧭 Perche' il DAX e' diverso sui due lati [INFERITO — nessun numero di questo referto lo dimostra]
Un retest vuole che il prezzo **rompa il livello e ci torni**. Sugli indici la salita e' spesso lenta e
ordinata (il ritorno sul livello arriva e regge), la discesa spesso veloce: o non torna sul livello, o ci
torna con un rimbalzo a V che passa lo stop. E' una spiegazione plausibile, **non una misura**.

## 4. 🟢 Dove lo short sul DAX c'e' gia' e funziona
- **`770411` MaxMinNotte DAX Short**: la rottura AL RIBASSO del range notturno, PF 1,19 (REGISTRO_TEST
  r.638-673), **in campo su FTMO**. Lo short sul DAX c'e': e' un altro meccanismo.
- Sonda esterna sul future DAX 2015-2018 (REGISTRO_TEST r.2266-2280): su un altro pattern (sequenza H1)
  lo SHORT e' positivo 6/6 e il LONG negativo 6/6. Sul DAX lo short non e' vietato: dipende dal meccanismo.

## 5. 📜 Cosa e' gia' stato provato oltre al semplice interruttore
| strada | stato |
|---|---|
| interruttore `InpAllowShort` sulla geometria della sedia | ✅ misurato (§2): peggiora |
| secondo ciclo sul lato opposto (`InpAllowReverse`, R51 14/08) | ✅ misurato su long+short: OOS +74,6% di profitto ma IS peggiore, peggior giornata x1,9 -> **riserva** |
| gemelli: short d'apertura su Dow e Nasdaq | ✅ misurati: no su tutti e tre (REGISTRO_TEST r.4035-4040) |
| FADE e RIMBALZO sul range (R42/R43) | ✅ misurati: bocciati |
| **short SOLO nei giorni ribassisti** (filtro di trend D1/H4 sul solo lato short) | 🔴 **MAI MISURATO** |
| **gestione dell'uscita propria dello short** (TP1, parziale, trailing) | 🔴 **MAI messa ad asse sul lato short** |
| orologio d'inverno (08:00 BCM = pre-mercato da ottobre a marzo) sul lato short | 🔴 **NON SEPARATO** |

👉 **Verdetto: "short = stessa identica cosa del long" e' MISURATO e PERDE. "Short sul DAX all'apertura"
in generale e' NON ANCORA MISURATO**: mancano la gestione dell'uscita e il filtro di regime.

## 6. ✏️ Errata trovata strada facendo
Il file prova `R205a_lato_corto_DAX_D30EUR.txt` (22/09) dice che il retest-short sul DAX *"non e' mai stato
girato"*: aveva controllato R42/R43 ma **non la FASE M**, che ha `InpEntryMode=2`. Nota d'errata aggiunta
in testa al file. Con i numeri di §2 il suo cancello c1 (PF OOS della cella accesa >= spenta) cade gia'
**1,237 contro 1,423**. La stessa frase *"mai misurato"* compare in `report/I_FILE_FERMI_2026-09-22.md` r.39.
