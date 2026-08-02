# 🎯 CACCIA AL MOTORE GIUSTO — APERTURE M5 (Nasdaq **e** DAX = priorità appaiate; Dow bonus)

> **Impegno (Claudio, 02/08):** trovare il motore d'ingresso giusto per le aperture **Nasdaq M5 E DAX M5** (girerà ognuno in demo accanto al nativo, magic diverso). _"Dobbiamo farcela. È troppo importante. Lavoriamoci finché non troviamo la nostra strada."_
> ⚠️ NB carattere diverso: **Nasdaq = direzionale** (breakout/RETEST) · **DAX = whipsaw** (probabile RANGE-FADE o entrata ritardata). Stesso menu di motori, ma il vincitore può essere diverso per i due.
> Metodo: **sistematico, sui numeri (tick reali)**. Si prova un motore alla volta, si misura, si tiene traccia qui. Non si molla finché non clear-a la barra o i numeri non chiudono onestamente la questione.

## 🎚️ LA BARRA DA SUPERARE (tick reali M5)
- **PF ≥ ~1,3** su campione decente (non pochi trade) · **DD accettabile** · **% pass positivi alta** (robustezza) · gestione parziale+BE+trailing.
- Baseline da battere: **Nasdaq STOP = 0,82** (morto) · Dow STOP = 1,30 (col fix gestione).

## 🧰 MENU DEI MOTORI D'INGRESSO (da testare uno alla volta)
| # | Motore | Idea | Stato |
|---|---|---|---|
| 1 | **STOP breakout** | rompe il range → entra oltre (stop) | ❌ Nasdaq 0,88 · DAX 0,77 · Dow 1,30 (solo Dow vivo) |
| 2 | **RETEST** (limit) | rompe → rientra sul livello → limit | ❌ **BOCCIATO 02/08**: peggiora Dow (1,30→0,94), Nasdaq 0,73 (DD 27%), DAX 0,79. Selezione avversa (falsi break) |
| 3 | **RANGE-FADE** | fada gli estremi del range (vendi max, compra min) | ❌ **BOCCIATO 02/08 sul DAX**: PFmed 0,73, 0/136 pass sopra PF 1 (max 0,94), DD mediano 23,5% (quasi doppio degli altri). Il peggiore dei tre. Su Nasdaq/Dow non ancora girato |
| 4 | **ENTRATA RITARDATA/CONFERMATA** | entra dopo 15-30 min, quando la direzione è scelta | 🔄 **IMPLEMENTATO 02/08** (`InpEntryMode=DELAYED`, `InpDelayMinutes`, `InpDelayDirMode`). Entra **a MERCATO** → niente stop da inseguire = niente slippage di rottura. Test: `confronto_ritardata.ps1` |
| 5 | **GAP-FILL** | se apre in gap, opera verso la chiusura prec. | ⬜ già nel codice (InpEntryMode=GAPFILL), da testare |
| 6 | **FIRST-CANDLE follow** | segui la direzione della 1ª candela M5/M15 | 🔄 **IMPLEMENTATO 02/08** come sotto-modo del #4: `InpDelayDirMode=2` (direzione del corpo della candela di apertura). Nella griglia del test #4 |
| 7 | **ORB 15 min** (idea Claudio) | range primi 15 min (DAX 09:00-09:15 IT = 08:00-08:15 server), poi rottura. Salta il whipsaw iniziale | ⬜ **già testabile:** `InpRangeMinutes=15` + STOP o RETEST. Sweep InpRangeMinutes = 5/15/30 |

## 🔧 FILTRI DA SOVRAPPORRE (su ogni motore, uno alla volta)
- **VWAP di sessione** (Emiliano) — `InpUseVwapFilter` già opt-in.
- **Volume rottura** (Emiliano) — `InpUseVolumeFilter` già opt-in.
- **Ampiezza range** (min/max punti) — già presente (InpMinRangePts/MaxRangePts).
- **Ora specifica** (sotto-finestra dell'apertura più profittevole).
- **Direzione/bias** (solo long? solo short? filtro trend H1/H4?).
- **Volatilità/ADR** (opera solo se il range è nella banda giusta).

## 📋 REGISTRO PROVE (si aggiorna a ogni test)
| Data | Simbolo | Motore | Filtri | PF med | DD% | Trade | Esito |
|---|---|---|---|---|---|---|---|
| 02/08 | U30USD (Dow) | STOP | H4+fix gest. | 1,30 | 7,9 | 348 | 🟢 unico vivo (conto pers.) |
| 02/08 | U30USD (Dow) | RETEST | — | 0,94 | 11,0 | 452 | ❌ peggiora lo STOP |
| 02/08 | D30EUR (DAX) | STOP | — | 0,77 | 7,2 | 440 | ❌ morto (whipsaw) |
| 02/08 | D30EUR (DAX) | RETEST | — | 0,79 | 7,5 | 436 | ❌ morto |
| 02/08 | NASUSD | STOP | — | 0,88 | 14,5 | 328 | ❌ morto |
| 02/08 | NASUSD | RETEST | — | 0,73 | 26,9 | 455 | ❌ morto (DD 27%) |
| 02/08 | D30EUR (DAX) | **RANGE-FADE** | — | **0,73** | **23,5** | 440 | ❌ **il peggiore dei tre** (0 pass su 136 sopra PF 1, max 0,94; DD quasi doppio) |

### 🔑 VERDETTO 02/08 (a): famiglia BREAKOUT (stop+limit) ELIMINATA per DAX/Nasdaq apertura.
Solo **Dow STOP 1,30** sopravvive (conto personale). Il RETEST è selezione avversa (falsi break).

### 🔑 VERDETTO 02/08 (b): RANGE-FADE BOCCIATO sul DAX — l'ipotesi "whipsaw" è smentita.
Il fade doveva essere la risposta al DAX ballerino: è invece il **peggiore dei tre motori**. PFmed 0,73, **nessuna combo su 136 raggiunge PF 1** (massimo 0,94, −5.532 €) e il **DD mediano raddoppia** (23,5% contro 12,6–13,0%). Fadare l'estremo nei giorni in cui il DAX parte davvero = mettersi davanti al treno.
Trade ~440 in tutti e tre i motori → non è campione sottile né problema di fill: è **assenza di edge, misurata tre volte in tre modi opposti**.
Dettaglio: `backtest_pipeline/risultati_archivio/DAX_Apertura/ANALISI_MOTORI_DAX_M5.md` (+ i 3 CSV).
**Prossimo e quasi ultimo: entrata ritardata (#4).** Poi restano solo ORB-15 (#7) e gap-fill (#5).

## ▶️ IL TEST PRONTO ADESSO (PC di backtest, MT5 CHIUSO)
**ENTRATA RITARDATA / FIRST-CANDLE (motori #4 e #6)** — DAX + Dow + Nasdaq a tick reali:

```powershell
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/claude/chat-ea-market-openings-zoba2j/backtest_pipeline/confronto_ritardata.ps1" | iex
```
Gira da solo la griglia **attesa 15/30/45 min × direzione break/mid/candela** (9 combo per simbolo).
Cartelle prodotte sul Desktop: `risultati_APERT_DAX_M5_delay_realtick` e `risultati_APERT_US_M5_delay_realtick` → zippa e caricamele.

_(Il fade su Nasdaq/Dow — `confronto_fade.ps1` — resta lanciabile, ma dopo il risultato DAX è a bassa priorità: servirebbe a chiudere formalmente il motore #3, non perché ci si aspetti un edge.)_

## 🧭 LOGICA DI CACCIA (come decidiamo il prossimo passo)
1. ~~Il RETEST batte lo STOP?~~ → **no, bocciato 02/08**.
2. ~~**RANGE-FADE** per il whipsaw~~ → **no, bocciato 02/08 sul DAX: il peggiore dei tre.**
3. Prova **ENTRATA RITARDATA / FIRST-CANDLE** (salta il rumore dei primi minuti) — implementato, ⬅️ **è il prossimo**.
4. Se anche questa fallisce → **ORB-15** (#7, `-RangeMin 15`) e **GAP-FILL** (#5) sono gli ultimi della famiglia.
5. Su ognuno, aggiungi **1 filtro alla volta** (VWAP → volume → ora → ADR) e rimisura.
6. Ogni risultato → riga nel registro sopra. **Si tiene solo ciò che regge i tick reali.**

> ⚠️ **Punto di onestà (02/08).** Sul DAX sono ora **3 motori su 3 falliti**, ~440 trade ciascuno su 2,5 anni: non è sfortuna né campione sottile. La ritardata è l'ultima idea con una tesi vera dietro; ORB-15 e gap-fill sono varianti degli stessi motori già bocciati. Se la ritardata non passa la barra, il verdetto corretto è **il DAX all'apertura M5 non ha edge** → si chiude la questione e il tempo di backtest torna sulla PROP (GoldenCross H1 a tick reali). Chiudere sui numeri è un risultato, non una sconfitta.
> Se nessun motore supera la barra su Nasdaq/DAX, il verdetto onesto è: **l'apertura M5 su quei due non ha edge** e resta solo il Dow STOP 1,30 per il conto personale. Chiudere la questione sui numeri è un risultato, non una sconfitta.

## ✅ Nota
- Il motore trovato girerà **in demo accanto al nativo** (magic diverso), come da regola.
- Vale anche per DAX (whipsaw → probabile range-fade) e Dow (già a 1,30).
- Priorità dichiarata: **Nasdaq**.
