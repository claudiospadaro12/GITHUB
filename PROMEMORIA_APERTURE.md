# STATO PROGETTO — memoria scritta (branch claude/ea-market-openings-d79m8l)

> **Da incollare in una chat nuova:** *"Leggi `PROMEMORIA_APERTURE.md` nel branch `claude/ea-market-openings-d79m8l` e riprendi da lì."*
> Ultimo aggiornamento: **2026-07-30**.

## 🎯 OBIETTIVO DI CLAUDIO
Avere **uno o più EA da portare in una prop firm**. Capire: (1) si possono portare EA in prop? (2) **quanti** contemporaneamente?
Metodo: con calma, **sui numeri**, fatto bene. C'è tempo a disposizione.
> ⚠️ Claudio lavora tutto il giorno e **non può stare davanti ai grafici** → i **sistemi automatici** e questa **memoria scritta** sono fondamentali. Segnare SEMPRE tutto.

---

## ⏳ DA FARE (lista viva — priorità) — dettagli nelle sezioni sotto
1. 🔴 **VERIFICARE la ricompilazione sul VPS** → F7 sul PostNews: c'è `InpUseOCO`? Se **manca** → lanciare `scarica_ottimizzati.ps1`. Attiva: fix gestione Hedge + OCO + anti-duplicato. *(È il fix delle perdite del 29/07.)*
2. 🔴 **Spegnere i morti** sul VPS: DAX_M3, Londra_ORB, DAX Live5m (+v2), ORB, ORB_Fibo.
3. 🟠 **Completare fix gestione Hedge** sugli EA restanti (MaxMinNotte, SupertrendInvert, GoldenCross/IchiTrend) + **validare in Strategy Tester**.
4. 🟢 **CAMPAGNA VINCENTI multi-TF** (tutte le strategie → matrice motore×simbolo×TF):
   - In corso: SupRev **H1**. Poi SupRev **M30**. Poi EMA200, GoldenCross, HARSI, SuperWave, SupertrendInvert, PTE, WOL, FiboH4.
   - Claude: **aggiungere a `scan_market.ps1`** i motori mancanti (SuperWave, SupertrendInvert, PTE, WOL, FiboH4).
5. 🟢 **MOTORE APERTURA M5 su tutti gli indici** → `studio_apertura.ps1` (8 indici) → analisi → `ABTG_Aperture_Universal`.
6. 🟢 **FORWARD 4 SupRev** (Oro/Argento/DAX/Nikkei) → pagella tra ~2-3 mesi.
7. 🔵 **Chiusura a tempo PostNews** (news+75min): decidere "sempre" o "solo se non a TP", poi aggiungere al codice.
8. 🔵 **DRY-RUN PROP** su demo 109k + guardiano (dopo il forward). Scegliere la prop firm.
9. 🔵 **Analizzatore regime × EA** (incrocia snapshot giornalieri + statement).

## ✅ FATTO (archivio sintetico)
- **28/07:** scan SupRev H4 (48 simboli) analizzato · guardiano creato · studio-apertura EA esteso (MAE/MFE) · launcher validazione tick-reali.
- **29/07:** FOMC configurato+attivato (buy scattato) · BCE preparata (10/09) · **trovato bug sistemico gestione Hedge** (SelectMyPosition) · fix su 5 EA apertura + OCO su PostNews (pushati sul default) · short Nasdaq riattivato.
- **30/07:** validazione **tick reali** SupRev (Oro/Argento reggono, DAX/Nikkei marginali, **Dow/ASX scartati**) · 4 preset robusti creati e messi **in forward** · scan **H1** partito · dashboard promemoria riordinata.

---

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
3. ⭐ **MOTORE APERTURA M5 SU TUTTI GLI INDICI** (progetto chiave di Claudio):
   - **FASE A — misurare:** `studio_apertura.ps1` (già esteso a **8 indici**: DAX, CAC, EuroStoxx, FTSE100, IBEX @08:00 server; Nasdaq, Dow, S&P @14:30 server). Misura ampiezza/MAE/MFE/durata per indice.
   - **FASE B — analizzare:** Claude dai CSV → SL / BE / trailing / dimezza-lotto ottimali per indice.
   - **FASE C — costruire:** UN motore unico `ABTG_Aperture_Universal` (stesso motore delle aperture DAX/Nasdaq) applicato agli altri indici, con la gestione tarata.
   - Idea di Claudio: "creare il TF 5 min col motore delle aperture, con gli altri indici." Verificare gli orari di apertura sul grafico BCM.
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

## 🐛 BUG SISTEMICO GESTIONE (Hedge) — trovato e in correzione (29/07)
- **Causa (provata dal log):** `SelectMyPosition()` faceva `PositionSelect(_Symbol)` → prendeva la PRIMA
  posizione qualsiasi sul simbolo. Con piu' EA sullo stesso strumento (DAX affollato), l'EA prendeva la
  posizione di un ALTRO → "non e' mia" → **saltava dimezza/BE/trailing**. Intermittente. Ha causato il +800→neg del 29/07.
  Prova: Live5m buy #2932708 gestito alle 09:00 (parziale+BE), short apertura #2596229/30 delle 09:53 IGNORATE.
- **Affligge ~17 EA** (tutta la famiglia che usa quel pattern).
- **FIX (fatto sul branch, DA COMPILARE/TESTARE):** SelectMyPosition ora scorre TUTTE le posizioni e prende la
  PROPRIA (simbolo+magic); `PositionModify` per **ticket** (non per simbolo). Applicato a 5 EA core:
  DAX_Apertura_EU (+Ott), Apertura_Marco, Nasdaq_Apertura_US (+Ott).
- **DA FARE:** replicare a MaxMinNotte (struttura diversa), SupertrendInvert, GoldenCross/IchiTrend; i morti
  (Live5m, DAX_M3, Londra_ORB, ORB, ORB_Fibo) si spengono. **VALIDARE in Strategy Tester** prima del live.
- Anche: OCO aggiunto a PostNews. Guardia anti-duplicato gia' presente. Tutto attivo alla prossima ricompilazione.

## 🟢 FORWARD IN CORSO (dal 30/07) — SupRev tick-reali validati
- 4 EA `ABTG_SupertrendReversal` in forward sul demo, parametri robusti (LONG-only, H4):
  - **Oro** XAUUSD (magic 770921, StMult 2.5/TP 2.5) — candidato PROP nº1 (DD reale 1,2%, PFmed 1,46)
  - **Argento** XAGUSD (770922, 3.0/2.5) · **DAX** D30EUR (770923, 3.5/2.5) · **Nikkei** 225JPY (770924, 3.0/2.5)
- Dow e ASX SCARTATI: crollati a tick reali (PF <1, erano illusione OHLC).
- Pagella forward vera da leggere tra ~2-3 mesi (H4 = poche operazioni/mese).

## 🔭 OSSERVAZIONI FORWARD (decisioni di Claudio)
- **28/07:** DAX Apertura EU nativo — gamba SHORT lasciata ATTIVA per osservare (oggi lo short ha perso −86,70; il long-only l'avrebbe evitato). Da rivedere tra qualche giorno.
- **Nasdaq apertura:** short riattivato (vedi sopra) — testa entrambe le direzioni.
- **Da verificare sul VPS:** DAX_M3 e Londra_ORB (decisi "morti") il 28/07 hanno ancora tradato e perso −116 € insieme. Confermare che siano tolti.
- **Statement 28/07:** giornata piatta (−2,05 €), DD 2,15%. 81% trade vinti ma R/R invertito (vincita media +16 vs perdita media −71). Le 3 perdite grosse: DAX Apertura SHORT, Londra ORB, DAX M3.

## 🧾 REGOLE PROP (sintesi)
- Non tutte le prop ammettono EA. Vietati spesso: HFT, martingala/grid, copy-trading, a volte **news trading** (⚠️ la PostNews FOMC/BCE è news trading → a rischio regole).
- "Quanti EA" = non un numero fisso: **nessun tetto al numero** in genere; il limite vero è la **perdita giornaliera COMBINATA** (< ~5%) + max lotti/consistenza. EA **scorrelati** → puoi tenerne di più. Raccomandazione: **2-4 diversificati**. Il dry-run sul 109k dà la risposta esatta.
- **PROP DI RIFERIMENTO scelta (30/07): FTMO** (affidabile, EA ammessi, no time limit, DD statico ~5%/10%, consistenza non stringente). Alternativa per stile lento/swing: **The5ers**.
  - Criteri EA-friendly: DD **statico** (non trailing), no/lieve consistenza, no time limit, hold overnight/weekend ok.
  - ⚠️ Le regole cambiano: **verificare i termini attuali sul sito** prima di pagare. Claudio caricherà il PDF del regolamento quando sceglie.
  - **DOPO il forward:** tarare il guardiano sui numeri tipo-FTMO → dry-run 109k. (Deciso 30/07: si aspetta il forward, niente pagamenti ora.)

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

## 🏁 CAMPAGNA "TROVA I VINCENTI SU TUTTE LE STRATEGIE" (obiettivo Claudio 30/07)
Passare OGNI strategia nell'imbuto (scan OHLC → tick reali → forward) e costruire la MATRICE MOTORE×SIMBOLO×TF.
- **Categoria A (motori universali → scan market-wide 48 simboli):**
  - Fatti: MaxMinNotte (EURUSD), Nightly (EURUSD), SupertrendReversal (H4 fatto → tick reali fatto; H1 in corso).
  - Coda: EMA200 (H4), GoldenCross (H1), HARSI (M5), poi SuperWave, SupertrendInvert, PTE, WOL, FiboH4.
  - `scan_market.ps1` supporta gia': MaxMinNotte, Nightly, HARSI, SupertrendReversal, EMA200, GoldenCross.
    **DA AGGIUNGERE** al comando: SuperWave, SupertrendInvert, PTE, WOL, FiboH4.
- **Categoria B (motori di contesto → studio mirato, NON scan cieco):**
  - Aperture DAX/Nasdaq/Marco → progetto motore apertura M5 (`studio_apertura.ps1`).
  - PostNews → eventi (FOMC/BCE). ORB/GapFill → studio apertura.
- **MULTI-TF (richiesta Claudio 30/07):** per ogni motore scan OHLC su piu' TF (con `-Tf`), scegliendo i TF SENSATI per quel motore:
  - Trend/reversal (SupRev, SupertrendInvert, EMA200, GoldenCross, SuperWave, PTE, WOL, FiboH4): **H4, H1, M30**.
  - Scalp/intraday (HARSI, MaxMinNotte, Nightly, ORB): **M30, M15, M5**.
  - Claude sceglie il miglior TF×simbolo dalla matrice; i vincitori vanno a tick reali al LORO TF migliore.
- **Claude mantiene la MATRICE** (PF mediano OHLC + PF tick-reali, per TF) man mano che arrivano i CSV.

## 🗒️ ARCHIVIO — COSA HA FATTO CLAUDIO (con date)
> Registro di ciò che Claudio conferma di aver eseguito lui. (Claudio dimentica → segnare SEMPRE.)
- **29/07:** aggiornato `abtg_news.csv` sul VPS con la data FOMC. FOMC EA attivato (EUR/USD M5) → il buy è scattato, chiuso in profitto/in corso.
- **29/07:** riattivato lo SHORT sull'apertura Nasdaq (test entrambe le direzioni).
- **29/07 sera:** chiuso MT5 sul VPS e (da confermare) lanciato il comando di ricompilazione; riaperto MT5.
  ⚠️ **DA VERIFICARE**: che la ricompilazione sia andata (test: F7 sul PostNews → deve esserci `InpUseOCO`).
  Se manca → rilanciare `scarica_ottimizzati.ps1`.
- **30/07:** caricati in forward i 4 preset SupRev robusti (Oro/Argento/DAX/Nikkei) sui rispettivi grafici H4.
- **30/07:** (in corso) lancio scan OHLC **H1** del SupertrendReversal sul PC fisso.

## 🧩 RAFFINAMENTI DALLE LIVE (da valutare/implementare) — dettaglio in docs/live_emiliano/ANALISI_LIVE_storico.md
Estratti dalle 24 live storiche (apr-mag) + luglio. Priorità:
1. **SupertrendReversal**: MA50-taglia-ST + ordine MA200 + medie-non-intrecciate + DX(20/25/50) + StdDev + MA200-barriera; togliere stocastico.
2. **Apertura**: filtro volume +50% su ORB + modulo Larry cost-to-cost + VWAP M15 + gap-fill.
3. **PTE**: canali TMA fast/slow + candela HA fuori da ENTRAMBI + pattern inversione + livello S/R.
4. **FiboH4**: laddering 50%/MA200/61.8 + TP MA14 + SL struttura + filtro ADR-giornata + re-entry su swing.
5. **WOL**: 2 pattern (inversione se apre sopra / continuazione se sotto) + filtro mediana doji + no doji notturne + TP MA14.
6. **NUOVA Bollinger squeeze/band-riding**; 7. **filtro FVG** trasversale; 8. cost-to-cost post-17:00 (priorità media).
- ✅ **PostNews** già rifinito (OCO + chiusura 21:45 + sell offset 3). ⚠️ ECB: la fonte NON la trada → deprioritizzare.

## 🎥 FLUSSO TRASCRIZIONI LIVE (Paolo / Emiliano)
Claudio carica le trascrizioni dei live di **Paolo** o **Emiliano** appena le ha.
Per ognuna Claude: (1) estrae le regole meccaniche; (2) dice se e' automatizzabile o discrezionale;
(3) se fattibile → scheletro EA tutto-in-uno → poi nell'imbuto (scan → tick reali → forward).
Distinguere: STRATEGIA operativa → diventa EA; ANALISI macro → alimenta il report giornaliero (come il PDF di Emiliano).
