# HANDOFF — punto d'ingresso per una chat nuova

> **Da incollare in una chat nuova:**
> *"Leggi `HANDOFF.md`, `PIANO_PROP.md`, `CACCIA_MOTORE_APERTURE.md`, `FLOTTA_ATTIVA.md`, `PROMEMORIA_APERTURE.md` e `backtest_pipeline/risultati_archivio/CLASSIFICHE.md` nel branch `lavoro` del repo `claudiospadaro12/GITHUB` e riprendi da lì."*
>
> Ultimo aggiornamento: **2026-08-02**. **Branch unico di lavoro: `lavoro`** (qui è consolidato TUTTO).

---

## 🔴 STATO OGGI (02/08) — riparti da qui
- **ROTTA (vedi `PIANO_PROP.md`):** PROP = priorità n°1. EA prop ideali: **H1**, trade chiusi in **1-2 gg** (max 4), gestione **parziale+BE+trailing**, **DD basso**. Conto personale: **aperture M5**.
- **🔬 ROTTA NUOVA (Claudio, 03/08): studiare il MOVIMENTO, non solo l'ingresso.** → `STUDIO_MOVIMENTO_APERTURE.md`
  Il forward del 03/08 ha mostrato che l'ingresso giusto con la gestione sbagliata vale **+33 € invece di +241 €** (trailing a 4,1 punti indice, chiusi in 39 secondi). Due fasi: **A** misurare MAE/MFE/durata (`studio_apertura.ps1`, branch corretto), **B** spazzolare le distanze di BE/trailing/TP (`scan_gestione.ps1 -Fase distanze`, nuovo).
- **⏭️ TOCCA A TE (PC di backtest, MT5 CHIUSO — vedi `CACCIA_MOTORE_APERTURE.md`):**
  ```powershell
  # ENTRATA RITARDATA + FIRST-CANDLE (motori #4 e #6) — l'ultima idea vera sulle aperture
  irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/confronto_ritardata.ps1" | iex
  ```
  Poi zippa dal Desktop `risultati_APERT_DAX_M5_delay_realtick` e `risultati_APERT_US_M5_delay_realtick` e caricamele.
- **FATTO oggi (tutto pushato):**
  1. **Motore RETEST** (opt-in `InpEntryMode=RETEST`) → testato a tick reali e **BOCCIATO**: peggiora il Dow (1,30→0,94), Nasdaq 0,73 (DD 27%), DAX 0,79. Selezione avversa sui falsi break. → **famiglia breakout (stop+limit) ELIMINATA** per DAX/Nasdaq apertura; sopravvive solo **Dow STOP 1,30**.
  2. **Motore RANGE-FADE** (`InpEntryMode=RANGE_FADE`) → testato a tick reali sul DAX e **BOCCIATO, il peggiore dei tre**: PFmed 0,73, **0 combo su 136 sopra PF 1** (max 0,94), DD mediano **23,5%** (quasi doppio di stop/retest). L'ipotesi "il DAX è whipsaw, quindi fada" è smentita dai numeri. Dettaglio: `risultati_archivio/DAX_Apertura/ANALISI_MOTORI_DAX_M5.md`.
  3. **Motore ENTRATA RITARDATA/CONFERMATA** (`InpEntryMode=DELAYED`, `InpDelayMinutes`, `InpDelayDirMode`) su Nasdaq/DAX apertura: aspetta N minuti e poi entra **a mercato** dalla parte scelta → niente stop da inseguire, niente slippage di rottura. Il modo `InpDelayDirMode=2` copre anche il **first-candle follow**. **Da testare** (griglia 15/30/45 min × break/mid/candela).
  4. **FIX gestione PER-TICKET** su TUTTE le aperture (Nasdaq/DAX/Marco): parziale+BE su OGNI posizione (risolve il +800→−700 del 29/07). **Da ricompilare sul VPS per attivarlo in forward.**
  5. **`REPORT_SETTIMANALE_2026-08-01.md`** + **`PAGELLA_EA_2026-08-01.md`**: statement 24-31/07 net −187€ (buco = DAX intraday, causa bug gestione ora corretto). Pagella per-EA dai COMMENTI ordini.
  6. **`FLOTTA_ATTIVA.md`**: mappa 52 grafici VPS. Scoperte: **TradeExporter attivo** su NZDCADH1 (scrive `ABTG_Trades.csv` con magic → caricarlo per pagelle perfette); **D30EURM54 vuoto** (verificare).
- **IPOTESI motore-per-mercato:** Nasdaq direzionale vs DAX whipsaw. Il RETEST doveva servire a entrambi e ha fallito su entrambi → ora si prova a **non inseguire affatto la rottura** (fade / entrata ritardata). Registro completo in `CACCIA_MOTORE_APERTURE.md`.
- **Dato nuovo:** Dow STOP tick reali col fix gestione = **PF 1,30** (era 1,16).
- **Prossimo passo PROP:** validare **GoldenCross H1 tick reali** (TF preferito di Claudio).

---

## ⚠️ NOTA BRANCH (importante)
Il lavoro delle chat vecchie viveva su branch diversi (`ea-market-openings-d79m8l`, `creating-agents-SgGpD`). **Il 31/07 è stato consolidato tutto in `lavoro`**: preset forward, Guardian, walkforward, studio aperture, promemoria + tutti gli scan archiviati. Questo è ora **l'unico branch da usare**. Salvare SEMPRE qui (commit + push).

## Chi sono / contesto
- Trader retail, conto **DEMO BCM 50503392** (EUR, Hedge, ~6k). Backtest sul PC fisso; EA in **forward su demo** (VPS/PC).
- **Doppio obiettivo**: (1) EA **PROP-GRADE** (DD basso, robusti → challenge FTMO); (2) EA **conto personale** (basta siano profittevoli).
- ⏰ **Fuso BCM = ora italiana − 1**. Orari EA/.ini in ORA SERVER (DAX 08:00, Nasdaq 14:30).

## Metodo (imbuto, una strategia alla volta)
**scan OHLC su più TF → classifico i migliori → tick reali sui vincitori → forward → walk-forward → dry-run prop.**
Regola d'oro: conta il **PF a TICK REALI** (l'OHLC sovrastima, vedi CAC 7.37→0.96) e il **DD basso**.

---

## 📊 DOVE SONO LE CLASSIFICHE
- **`backtest_pipeline/risultati_archivio/CLASSIFICHE.md`** ← vista unica (EA + simboli + strategie). **Parti da qui.**
- `backtest_pipeline/risultati_archivio/CLASSIFICA_STRATEGIE.md` — matrice motori × TF.
- `backtest_pipeline/CLASSIFICA_PF.md` — i 14 EA `_Ottimizzato` per PF.
- Per strategia: `risultati_archivio/<Strategia>/ANALISI_*.md` (GoldenCross, SupertrendReversal + TICK_REALI_INDICI).

## 🟢 SQUADRA FORWARD (13 EA validati, in demo; EMA200 dal 01/08)
5 SupRev: **Oro** (770921) · **Argento** (770922) · **DAX** (770923) · **Nikkei** (770924) H4 + **Nasdaq H1** (770925).
3 GoldenCross H4: **USDCHF** (770331) · **USDCAD** (770332) · **NZDUSD** (770333).
5 EMA200 H4: **200AUD** (771511) · **AUDJPY** (771512) · **GBPJPY** (771513) · **SPXUSD** (771514) · **GBPUSD**/SHORT (771515).
_NB: sul demo gira TUTTA la flotta (~50 EA, anche i "morti") per osservazione fino alla quadra del mese — decisione Claudio._
→ Serve TEMPO: pagella PF/DD reale tra ~2-3 mesi. Claudio manda statement → Claude archivia/traccia.
**Scartati** (crollo tick reali): SupRev Dow, ASX, CAC.

## 🎯 PROP — piano
- Prop scelta: **FTMO 2-Step** (−5% giorno / −10% totale statico, target +10%, no time limit, EA ok). Alt: The5ers.
- **Guardiano pronto**: `ABTG_Guardian.mq5` + `ABTG_Guardian_FTMO_2Step.set` (InpStartBalance=100000). Solo sul demo dry-run, MAI sul forward.
- Sequenza: forward → walk-forward IS/OOS (`walkforward.ps1`) → aprire demo 100k → dry-run col guardiano → valutare. **Deciso 30/07: aspettare il forward, niente pagamenti ora.**
- ⚠️ PostNews FOMC/BCE = news trading → a rischio regole prop.

## ⏳ DA FARE (priorità)
1. 🔄 **EMA200**: scan OHLC H4 (in corso) + H1 → poi tick reali sui vincitori.
2. ⏳ **Tick reali mancanti**: SupRev IBEX (E35EUR) H1; GoldenCross H1 sui top OHLC (Oro/USDJPY/GBPUSD); SupRev non-indici H4 (XAU/CHFJPY/GBPJPY/AUDUSD).
3. 🟢 **Campagna matrice** motore×simbolo×TF (FASE 1 TF alti → FASE 3 TF bassi): mancano SuperWave, SupertrendInvert, PTE, WOL, FiboH4 allo scan.
4. ❓ **SupertrendInvert tick reali** — da ritrovare sul PC (non in archivio).
5. 🔴 **VPS** (quando flat): ricompilare (`scarica_ottimizzati.ps1`), riattaccare DAX Apertura su 1 solo grafico, spegnere i morti (DAX_M3, Londra_ORB, Live5m, ORB, ORB_Fibo).

## Stile richiesto
Precisione sopra tutto. Etichettare [VERIFICATO]/[INFERITO]/[INCERTO]. Segnalare premesse sbagliate PRIMA di rispondere. Mai inventare. **Salvare SEMPRE tutto nel repo** (commit+push): ciò che non è pushato è perso.

## Comandi utili (PowerShell) — branch `lavoro`
```powershell
# Scan di un EA su tutto il market (OHLC). -Tf opzionale per forzare il timeframe.
powershell -ExecutionPolicy Bypass -Command "iwr 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/scan_market.ps1' -OutFile scan_market.ps1; .\scan_market.ps1 -Robot ABTG_EMA200 -Tf H1"
# Validazione tick reali dei vincitori
#   .\valida_realtick.ps1 -Symbols E35EUR -Tf H1
```
