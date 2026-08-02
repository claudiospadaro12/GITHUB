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

## 🚨 SCOPERTA 02/08 — ABBIAMO TESTATO IL MOTORE **NUDO**, non il metodo di Emiliano
Controllo colonna per colonna dei CSV dei 3 test (400+ pass, breakout/retest/fade su DAX): **ogni filtro era SPENTO in tutti i pass**.

| Parametro | Nei nostri test | Emiliano (live 20/07 + trascrizioni apr–mag) |
|---|---|---|
| `InpUseVwapFilter` | **0** | acceso — VWAP M15 come spartiacque |
| `InpUseVolumeFilter` | **0** | **volume +50% sulla rottura** ("se mi apre sotto l'orb **e c'è un incremento dei volumi**, io lì lo shorto") |
| `InpUseEmaFilter` | **0** | medie **9/21 orientate** ("è una caratteristica importante avere le medie rivolte verso l'alto") |
| `InpUseSupertrend` | **0** | Supertrend 3.5 su D1 |
| `InpRangeMode` | **0** = range di apertura | anche **max/min della NOTTE** ("prendo i minimi da notte e prendo 10 punti") |
| `InpBufferPoints` | 100–400 = **1–4 punti indice** | **10 punti indice** (= 1000) |
| `InpRangeMinutes` | griglia 5–60 | **15 fisso** (prima candela M15), operativo **dalle 09:15 IT** |

**Conseguenza:** i verdetti (a) e (b) qui sotto restano validi — ma valgono per lo **scheletro** dei motori, non per il metodo di Emiliano. Il livello dei filtri (passo 5 della logica di caccia) **non è mai stato acceso in un backtest**.

I 5 pilastri di Emiliano sull'apertura DAX: (1) ORB prima candela 15 min · (2) max/min della notte + del giorno prima · (3) volume in aumento sulla rottura · (4) VWAP M15 + medie 9/21 · (5) ingresso sul **retest**, mai in corsa, con conferma multi-TF.

### 📑 SLIDE ARRIVATE (02/08) → analisi completa in `docs/live_emiliano/ANALISI_SLIDE_APERTURE.md`
Il PDF del corso («La Magia delle Aperture», ABTG, 41 pp.) dice **testuale**:
> *"**Entra subito dopo la chiusura della candela di breakout, non durante.**"* — e in checklist: *"Candela di rottura **chiusa** oltre il livello tecnico? Breakout confermato da **volumi** e price action? **ATR** conferma volatilità adeguata?"*

**Abbiamo testato l'esatto opposto**: ordini STOP riempiti *durante* la rottura, senza conferma di chiusura, senza volumi, senza ATR. Il metodo del corso **è** l'ingresso confermato = il motore `DELAYED` implementato ieri.

Due correzioni di rotta che ne derivano:
- **Nasdaq/Dow:** lo scheletro del nostro EA è **fedele** alle slide (ordini su max/min della **candela H1 precedente**, SL sui massimi precedenti, OCO, parziale+BE, trailing sulla base della candela M1). Manca solo il **livello dei filtri** (volumi/ATR/VWAP/correlazione SPX) e l'ingresso a size divisa.
- **DAX:** le slide europee **non prescrivono affatto un ORB**. Prescrivono livelli D1/W1/MN (Larry Williams), correlazione **225JPY → SPXUSD → D30EUR**, **Supertrend ×3 (2.5/3.0/3.5) tutti e tre concordi**, medie 89/100/200/14, Bollinger M15. Emiliano nelle live: *"l'ORB è **un'altra strategia** che noi abbiamo"*. → **stiamo testando bene la strategia sbagliata sul DAX.**

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

> ⚠️ **Punto di onestà — CORRETTO il 02/08 dopo le slide.** Avevo scritto che se la ritardata fallisce si chiude la questione DAX. **Era prematuro.** I 3 motori bocciati sono stati testati **a filtri spenti** e, sul DAX, con una strategia (ORB) che il piano europeo non prescrive nemmeno. Quello che è morto è lo **scheletro nudo**, non il metodo del corso. Prima di chiudere vanno girati i test della lista sopra — a partire dalla ritardata **con volumi+ATR accesi**, che è ciò che il PDF prescrive testualmente. Se falliscono *quelli*, allora sì: si chiude sui numeri, ed è un risultato.
> Se nessun motore supera la barra su Nasdaq/DAX, il verdetto onesto è: **l'apertura M5 su quei due non ha edge** e resta solo il Dow STOP 1,30 per il conto personale. Chiudere la questione sui numeri è un risultato, non una sconfitta.

## ✅ Nota
- Il motore trovato girerà **in demo accanto al nativo** (magic diverso), come da regola.
- Vale anche per DAX (whipsaw → probabile range-fade) e Dow (già a 1,30).
- Priorità dichiarata: **Nasdaq**.
