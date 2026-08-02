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
| 1 | **STOP breakout** | rompe il range → entra oltre (stop) | ❌ Nasdaq 0,82 (slippage) |
| 2 | **RETEST** (limit) | rompe → rientra sul livello → limit | 🔄 in test tick reali |
| 3 | **RANGE-FADE** | fada gli estremi del range (vendi max, compra min) | ⬜ da implementare se 1-2 falliscono |
| 4 | **ENTRATA RITARDATA/CONFERMATA** | entra dopo 15-30 min, quando la direzione è scelta | ⬜ da implementare |
| 5 | **GAP-FILL** | se apre in gap, opera verso la chiusura prec. | ⬜ già nel codice (InpEntryMode=GAPFILL), da testare |
| 6 | **FIRST-CANDLE follow** | segui la direzione della 1ª candela M5/M15 | ⬜ idea |
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
| 01/08 | NASUSD | STOP | H4 | 0,82 | 17 | — | ❌ morto |
| 02/08 | U30USD | STOP | H4 (+fix gest.) | 1,30 | 7,9 | 348 | 🟡 debole ma vivo |
| 02/08 | NAS/DAX/Dow | STOP vs RETEST | — | _in corso_ | | | 🔄 |

## 🧭 LOGICA DI CACCIA (come decidiamo il prossimo passo)
1. Il RETEST batte lo STOP? → se sì su Nasdaq, si rifinisce (offset, filtri). Se no →
2. Prova **RANGE-FADE** (il Nasdaq apre spesso con spike + ritorno).
3. Prova **ENTRATA RITARDATA** (salta il rumore dei primi minuti).
4. Su ognuno, aggiungi **1 filtro alla volta** (VWAP → volume → ora → ADR) e rimisura.
5. Ogni risultato → riga nel registro sopra. **Si tiene solo ciò che regge i tick reali.**

## ✅ Nota
- Il motore trovato girerà **in demo accanto al nativo** (magic diverso), come da regola.
- Vale anche per DAX (whipsaw → probabile range-fade) e Dow (già a 1,30).
- Priorità dichiarata: **Nasdaq**.
