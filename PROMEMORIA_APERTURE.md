# STATO PROGETTO — memoria scritta (branch claude/ea-market-openings-d79m8l)

> **Da incollare in una chat nuova:** *"Leggi `PROMEMORIA_APERTURE.md` nel branch `claude/ea-market-openings-d79m8l` e riprendi da lì."*
> Ultimo aggiornamento: **2026-07-28**.

## 🎯 OBIETTIVO DI CLAUDIO
Avere **uno o più EA da portare in una prop firm**. Capire: (1) si possono portare EA in prop? (2) **quanti** contemporaneamente?
Metodo: con calma, **sui numeri**, fatto bene. C'è tempo a disposizione.
> ⚠️ Claudio lavora tutto il giorno e **non può stare davanti ai grafici** → i **sistemi automatici** e questa **memoria scritta** sono fondamentali. Segnare SEMPRE tutto.

## ⏰ REGOLA FISSA — fuso BCM
**Server BCM = ora italiana − 1.** Negli EA/preset gli orari vanno in ORA SERVER.
- DAX apre 09:00 IT = **08:00 server** · Nasdaq 15:30 IT = **14:30 server** · FOMC 20:00 IT = 19:00 server.

---

## 🖥️ I SISTEMI AUTOMATICI (importanti: girano da soli)
1. **Report mercato giornaliero** (email, GitHub Actions) — con sezioni Banche Centrali + COT.
2. **Report settimanale** (sabato) — analisi trade per EA/simbolo.
3. **Pipeline backtest** (`backtest_pipeline/`, PC fisso):
   - `scan_market.ps1` — scan di un EA su tutti i simboli (OHLC). Supporta `-Tf` per il timeframe.
   - `valida_realtick.ps1` — **NEW**: valida i vincitori a **tick reali** (Model 4).
   - `studio_apertura.ps1` — **NEW**: studio aperture su indici (misura MAE/MFE/ampiezza).
4. **Guardiano** (`ABTG_Guardian.mq5`) — **NEW**: fa rispettare le regole prop sul demo 109k (vedi sotto).

---

## 🧭 IMBUTO / DOVE SIAMO
```
1. SCOPERTA  scan OHLC 48 simboli ............... ✅ FATTO (SupertrendReversal)
2. VALIDAZIONE  tick reali sui vincitori ........ ◄── SIAMO QUI (launcher pronto)
3. FORWARD  girano i validati, pagella reale .... da fare
4. TOP 3 diversificati (2 indici + 1 metallo) ... da scegliere sui numeri veri
5. DRY-RUN PROP  demo 109k + guardiano .......... da fare (guardiano pronto)
6. VERDETTO  avrebbe passato? quanti EA reggono?  da fare
```

## 📊 RISULTATO SCAN SupertrendReversal (H4, OHLC) — 28/07
Regola: conta il **PF MEDIANO** (robustezza), non il PF migliore (fluke/overfit).
**Vincitori con edge robusto (PFmed ≥ 1,0):**
| Simbolo | Cat | PFmed | PFbest | DD% | Dir |
|---|---|---|---|---|---|
| XAUUSD (Oro) | METALLO | 1,59 | 4,15 | 1,07 | LONG |
| XAGUSD (Argento) | METALLO | 1,39 | 2,76 | 2,69 | LONG |
| AUDJPY | forex | 1,35 | 4,38 | 1,98 | SHORT |
| GBPJPY | forex | 1,26 | 4,47 | 1,38 | LONG |
| U30USD (Dow) | INDICE | 1,26 | 4,12 | 1,92 | LONG |
| 225JPY (Nikkei) | INDICE | 1,17 | 2,44 | 0,17 | LONG |
| D30EUR (DAX) | INDICE | 1,06 | 2,48 | 2,26 | LONG |
| 200AUD (ASX) | INDICE | 1,01 | 3,91 | 0,84 | SHORT |
- **Terna proposta per il Multi:** Oro (metallo) + Dow (indice USA) + Nikkei (indice Giappone) = poco correlati.
- ⚠️ È H4. Il **Nasdaq** qui è debole (PFmed 0,68) ma a **H1** rendeva (PF 1,57) → **il TF cambia tutto**: fare anche scan H1.

## 📌 PROMEMORIA APERTI (in coda — partono quando il PC fisso è libero)
1. **VALIDAZIONE tick reali** dei vincitori → `valida_realtick.ps1` (default: Oro, Argento, Dow, Nikkei, DAX, ASX).
   Poi Claudio manda i CSV → confronto tick-reali vs OHLC → chi regge davvero.
2. **SCAN H1** per confronto col H4 → `.\scan_market.ps1 -Robot ABTG_SupertrendReversal -Tf H1`. Claudio preferisce H1 (chiude in giornata).
3. **STUDIO APERTURE** (FASE A) → `studio_apertura.ps1` (5 indici, EU 08:00 / USA 14:30 server). Misura MAE/MFE/ampiezza → SL/BE/trailing/dimezza-lotto → poi **motore unico** `ABTG_Aperture_Universal`.
4. **FORWARD** → statement periodico → pagella PF/DD reale per EA.
5. **DRY-RUN PROP** sul demo 109k + guardiano (dopo il forward).
6. Poi: EMA200 / GoldenCross scan; scan HARSI.

## ✅ FATTO IN QUESTA SESSIONE (28/07)
- **FOMC** (29/07): EA PostNews a posto, preset FOMC caricato (EUR/USD M5, magic 771202, azione 20:40 IT), data FOMC aggiunta a `abtg_news.csv`.
- **BCE** (10/09): preset ECB (EUR/JPY M5, magic 771201) + data nel CSV. Pronto in panchina.
- **EA studio aperture** esteso con MAE/MFE/ampiezza/durata + **launcher** `studio_apertura.ps1`.
- **Launcher validazione tick reali** `valida_realtick.ps1`.
- **Guardiano** `ABTG_Guardian.mq5` creato (era "da creare").
- **Scan SupertrendReversal** analizzato (tabella sopra).
- **Nasdaq apertura nativa:** riattivato lo SHORT (InpAllowShort=true) per testare entrambe le direzioni in forward.

## 🛡️ GUARDIANO (ABTG_Guardian.mq5) — come si usa
- **Solo sul demo 109k**, per il dry-run. **MAI sul conto forward** (lì serve il comportamento grezzo).
- Modo A (autonomo): al limite giornaliero → chiude tutto + blocca fino a domani; al limite DD totale → chiude tutto + ferma.
- Parametri: `InpStartBalance=109000`, `InpDailyLossPct`, `InpTotalDDPct`, `InpDDMode` (statico/trailing), `InpDailyResetHour`, `InpAction` (0=enforce, 1=solo allarme).
- Da attaccare a **UN solo grafico** (governa tutto il conto). Pannello di stato a video.

## 📈 CONTI
- **Forward:** demo BCM **50503392** (EUR, Hedge, ~6k). Qui girano gli EA, NIENTE guardiano.
- **Prop sim:** secondo demo portato a **~109.000** per il dry-run futuro (col guardiano).

## 🚨 URGENTE — RICOMPILARE GLI EA (causa perdite evitabili)
- **29/07:** account da **+804** a negativo. Causa: gli EA apertura hanno BE + dimezza-a-target + trailing
  NEL CODICE e ACCESI nel preset, MA l'`.ex5` sul VPS è **vecchio** → la gestione profitto **non gira**.
  Il TP1 (1R) è stato raggiunto ma niente parziale/BE → profitto restituito.
- **FIX (una volta sola):** lanciare `scarica_ottimizzati.ps1` (ricompila tutti gli EA) → attiva BE/trailing/
  dimezza + guardia anti-duplicato. Poi rimuovere/riattaccare gli EA. **Da fare PRIMA del dry-run prop.**
- **Spegnere i Live5m** (DAX Live5m + v2): morti (PF<1), il 29/07 hanno perso −353 nel whipsaw. Come DAX_M3/Londra_ORB.
- Duplicato apertura confermato di nuovo (2× DAX Apertura EU SELL, stesso secondo) → risolto dalla ricompilazione.

## ⚖️ VALIDITÀ DEL FORWARD (regola importante)
- I trade sul VPS **prima della ricompilazione** girano su un `.ex5` VECCHIO senza dimezza/BE/trailing →
  **NON sono un giudizio valido** sugli EA (misurano un EA rotto, non la strategia). Es. 29/07: avrebbero
  profittato bene, invece hanno restituito +800.
- **La pagella forward RIPARTE dalla data di ricompilazione.** Tutto ciò che è prima si SCARTA dal verdetto.
- I backtest/validazioni a tick reali NON sono contaminati (girano sul codice fresco dal repo).
- Quindi ricompilare serve a: (1) smettere di perdere profitti, (2) rendere VALIDO il forward test.

## 🔭 OSSERVAZIONI FORWARD (decisioni di Claudio)
- **28/07:** DAX Apertura EU nativo — gamba SHORT lasciata ATTIVA per osservare (oggi lo short ha perso −86,70; il long-only l'avrebbe evitato). Da rivedere tra qualche giorno.
- **Nasdaq apertura:** short riattivato (vedi sopra) — testa entrambe le direzioni.
- **Da verificare sul VPS:** DAX_M3 e Londra_ORB (decisi "morti") il 28/07 hanno ancora tradato e perso −116 € insieme. Confermare che siano tolti.
- **Statement 28/07:** giornata piatta (−2,05 €), DD 2,15%. 81% trade vinti ma R/R invertito (vincita media +16 vs perdita media −71). Le 3 perdite grosse: DAX Apertura SHORT, Londra ORB, DAX M3.

## 🧾 REGOLE PROP (sintesi)
- Non tutte le prop ammettono EA. Vietati spesso: HFT, martingala/grid, copy-trading, a volte **news trading** (⚠️ la PostNews FOMC/BCE è news trading → a rischio regole).
- "Quanti EA" = non un numero fisso: dipende dalla **perdita giornaliera COMBINATA** (< ~5%). EA **scorrelati** → puoi tenerne di più. Il dry-run sul 109k dà la risposta esatta.

## ⌨️ COMANDI POWERSHELL (PC fisso, MT5 chiuso)
```powershell
# Validazione tick reali dei vincitori
powershell -ExecutionPolicy Bypass -Command "iwr 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB/claude/ea-market-openings-d79m8l/backtest_pipeline/valida_realtick.ps1' -OutFile valida_realtick.ps1; .\valida_realtick.ps1"
# Scan H1 (confronto col H4)
.\scan_market.ps1 -Robot ABTG_SupertrendReversal -Tf H1
# Studio aperture (5 indici)
powershell -ExecutionPolicy Bypass -Command "iwr 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB/claude/ea-market-openings-d79m8l/backtest_pipeline/studio_apertura.ps1' -OutFile studio_apertura.ps1; .\studio_apertura.ps1"
```
> PC fisso = backtest/scan. VPS = solo EA in forward (non toccarlo per i backtest).

## 🗂️ ARCHIVIO REGIME (già esistente — NON duplicare)
- Il report giornaliero **salva già** ogni giorno `data/snapshots/AAAA-MM-GG.json` con bias/RSI/var/livelli/
  correlazioni di TUTTI gli strumenti (branch default `creating-agents-SgGpD`). Accumula dal 22/07.
- Il **report settimanale del sabato** (`run_weekly_report.py`) rilegge gli snapshot e confronta bias vs realtà.
- ⚠️ NON serve postare il report a mano ogni giorno: è automatico. `agent/regime_log.py` (su questo branch) era
  un doppione → **superato dallo snapshot**, lasciato inattivo.
- **DA FARE (valore vero):** analizzatore che incrocia gli **snapshot** con lo **statement** → **mappa regime × EA**
  (quale EA vince/perde in quale regime). Si costruisce quando Claudio manda gli statement.

## 🎥 FLUSSO TRASCRIZIONI LIVE (Paolo / Emiliano)
Claudio carica le trascrizioni dei live di **Paolo** o **Emiliano** appena le ha.
Per ognuna Claude: (1) estrae le regole meccaniche; (2) dice se e' automatizzabile o discrezionale;
(3) se fattibile → scheletro EA tutto-in-uno → poi nell'imbuto (scan → tick reali → forward).
Distinguere: STRATEGIA operativa → diventa EA; ANALISI macro → alimenta il report giornaliero (come il PDF di Emiliano).
