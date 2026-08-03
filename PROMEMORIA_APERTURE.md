# STATO PROGETTO — memoria scritta (branch claude/ea-market-openings-d79m8l)

> **Da incollare in una chat nuova:** *"Leggi `PROMEMORIA_APERTURE.md` nel branch `claude/ea-market-openings-d79m8l` e riprendi da lì."*
> Ultimo aggiornamento: **2026-07-30**.

## 🧭 ROTTA (brief 02/08): vedi **`PIANO_PROP.md`**
**PROP = priorità n°1.** EA prop ideali: **H1**, trade chiusi in **1-2 gg** (max 4), gestione **parziale+BE+trailing** per profitti COSTANTI, **DD basso**. Candidato top: Nasdaq SupRev H1 (DD 1,2%, chiude ~1gg). Prossimo: validare **GoldenCross H1 tick reali**. Conto personale: **aperture M5** (RETEST vs STOP + gestione per-ticket).

## 🎯 OBIETTIVO DI CLAUDIO — DUE LIVELLI
1. **EA PROP-GRADE** (pochi, anche 1): DD basso + robusti → per la challenge FTMO. Selezione severa.
2. **EA "conto personale"**: basta che siano **profittevoli** (anche se non da prop) → qui rientrano aperture e TF bassi. Selezione più permissiva.
Metodo: con calma, **sui numeri**, fatto bene. C'è tempo. **Backtestare TUTTI gli EA, dal TF alto verso il basso**, e perfezionare anche le aperture (DAX/Nasdaq) e i TF bassi per il conto personale.
> ⚠️ Claudio lavora tutto il giorno e **non può stare davanti ai grafici** → i **sistemi automatici** e questa **memoria scritta** sono fondamentali. Segnare SEMPRE tutto.

---

## ⏳ DA FARE (lista viva — priorità) — dettagli nelle sezioni sotto

### 🖥️ VPS (quando FLAT: stasera dopo 22:00 IT o weekend)
1. 🔴 **Ricompilare sul VPS** → `scarica_ottimizzati.ps1` (comando irm|iex del branch default). Attiva: fix gestione Hedge (tutti gli EA) + OCO + anti-duplicato + aggiorna `abtg_news.csv`. *(È il fix delle perdite del 29/07 e dei doppioni DAX.)* Verifica: F7 su un'apertura → deve comparire `InpUseVwapFilter`; su PostNews `InpUseOCO`.
2. 🔴 **Ri-attaccare il DAX Apertura** (rimosso il 30/07 per fermare i doppioni) su **UN SOLO** grafico D30EUR M5, dopo la ricompilazione.
3. 🔴 **Spegnere i morti** sul VPS: DAX_M3, Londra_ORB, DAX Live5m (+v2), ORB, ORB_Fibo.

### 💻 PC FISSO — coda backtest (uno alla volta)
0. ✅ **GoldenCross H4 scan analizzato (31/07):** è una **strategia da FOREX** (USDCHF, USDCAD, EURAUD, NZDUSD, CHFJPY, GBPCHF, EURUSD, EURJPY) → **diversifica dai SupRev** (metalli/indici). Vincitori PFmed≥1: 10. Più robusti (per #pass): USDCHF 1,66 SHORT (30p), CHFJPY 1,13 LONG (40p), EURJPY 1,02 (40p). ⚠️ Pochi trade (30-48) → campione sottile, tick reali essenziali. XAGUSD forte ma overlappa col SupRev.
   ✅ **TICK REALI GoldenCross (31/07): REGGE! 2a strategia trovata.** USDCHF PFmed 1,71 (peggiore 1,37, DD 2,6%) ⭐ · USDCAD 1,58 · NZDUSD 1,45 SHORT · XAGUSD 2,06 (overlap SupRev) · CHFJPY 1,07 marginale · EURUSD/EURJPY scartati. DD tutti bassi (2,6-4,9%).
   ✅ **FATTO preset forward GoldenCross** (EA `ABTG_GoldenCross`, H4): `..._FW_USDCHF_H4.set` (770331, BOTH TP2.5 ADX25) · `..._FW_USDCAD_H4.set` (770332, BOTH TP2.5 ADX20) · `..._FW_NZDUSD_H4.set` (770333, SHORT TP1.5 ADX20).
   📌 **SQUADRA FORWARD ora: 5 SupRev + 3 GoldenCross = 8 EA, 2 strategie (reversal metalli/indici + trend forex), poco correlate.**
   ✅ **31/07: i 3 GoldenCross ATTACCATI in forward** (USDCHF/USDCAD/NZDUSD H4). Squadra forward AL COMPLETO e in osservazione.
4. ⏭️ **Conferma apertura US a TICK REALI**: `conferma_apertura_us.ps1 -Model 4` (Dow/Nasdaq M5). OHLC già fatto (Dow PF 1,84 / Nasdaq 1,11). Questo è l'ultimo filtro prima del forward apertura.
5. 🟢 **Validare a tick reali IBEX (E35EUR) H1** (SupRev) — unico vincitore H1 senza RT in archivio: `valida_realtick.ps1 -Symbols E35EUR -Tf H1`.
6. ✅ **Dow SupRev H4 — RISOLTO: SCARTATO.** La revalidation pulita (PFmed su 6 indici) dà Dow 0,79 → crolla (illusione OHLC), come ASX 0,78. Il vecchio "1,77" era un run sporco. Dow fuori dai candidati.
7. 🟢 **CAMPAGNA MATRICE motore×simbolo×TF — dal TF ALTO al BASSO** (uno scan alla volta; OHLC → io classifico → tick reali sui vincitori). `scan_market.ps1 -Robot <EA> -Tf <TF>` supporta: MaxMinNotte, Nightly, HARSI, SupertrendReversal, EMA200, GoldenCross, SuperWave, SupertrendInvert, PTE, WOL, FiboH4_Multi.
   - **FASE 1 — TF ALTI (H4 / D1):** SupRev H4✅ · GoldenCross H4✅ · **EMA200 H4** ⬅️ prossimo · SuperWave H4 · FiboH4 H4 · PTE H4 · SupertrendInvert H4 · WOL D1.
   - **FASE 2 — TF MEDI (H1 / M30):** GoldenCross H1 🔄 (in corso) · SupRev H1✅ · EMA200 H1 · SuperWave H1 · SupertrendInvert H1 · SupRev/GC/EMA200 M30 (check).
   - **FASE 3 — TF BASSI (M15 / M5) + perfezionare aperture:** HARSI M5/M15 · **aperture DAX/Nasdaq** (perfezionare, es. variante RETEST) · MaxMinNotte / Live5m sui loro TF. *(Qui i tick reali sono decisivi: sotto H1 lo spread mangia l'edge — apertura M5 crollata da 1,84 a 1,16.)* → più per il **conto personale** che per la prop.
     - ✅ **FIX GESTIONE PER-TICKET (01/08, da statement Claudio):** lo statement 24-31/07 ha mostrato il DAX +800→−700 perché **parziale e BE non scattavano** su posizioni multiple. Causa nel codice: `ManagePosition()` gestiva **solo la prima** posizione (via `SelectMyPosition`) e usava **flag globali** `gPartialDone`/`gBEdone`. Riscritto: ciclo su **TUTTE** le mie posizioni (simbolo+magic) con stato **per-ticket** (`gPartialTk[]`/`gBETk[]` + helper `TkDone`/`TkMark`), `InitialSL` ora prende `partialDone` per-ticket. Fatto su TUTTI e 3 gli EA apertura: **Nasdaq_Apertura_US + DAX_Apertura_EU + Apertura_Marco**. Verificato: graffe 148/148, paren 727/727, 0 residui vecchi flag. **Da ricompilare sul VPS per attivarlo.**
     - ✅ **RETEST implementato (01/08):** aggiunto `InpEntryMode=RETEST` (opt-in, default resta BREAKOUT → forward invariato) su `ABTG_Nasdaq_Apertura_US` (motore US symbol-agnostico = copre Dow **e** Nasdaq). Logica: aspetta la rottura del range, poi piazza un **LIMIT sul livello rotto** (ritorno) → fill senza slippage + SL più stretto (bordo opposto) → R migliore. Se il prezzo scappa senza tornare, il limit scade (trade mancato = costo del metodo). Nuovo input `InpRetestOffsetPts` (0=sul livello). Filtri (ampiezza/volumi Emiliano/spread) e gestione (parziale/BE/trailing) invariati.
       - 🎯 **PROSSIMO STEP (PC backtest): confronto STOP vs RETEST a tick reali.** Script aggiornato `conferma_apertura_us.ps1` (ora scarica dal branch lavoro + sceglie il motore):
         - STOP:  `.\conferma_apertura_us.ps1 -Model 4 -EntryMode 0`
         - RETEST: `.\conferma_apertura_us.ps1 -Model 4 -EntryMode 2`
         - → due set di CSV (`..._brk_...` vs `..._retest_...`). Se RETEST batte Dow 1,16 / Nasdaq 0,82 = motore apertura salvato. Poi ci si mette sopra la gestione.
     - 🧠 **IPOTESI MOTORE-PER-MERCATO (Claudio 02/08):** Nasdaq = **direzionale** (rompe e va) → momentum/breakout, ma a STOP muore per slippage → RETEST. DAX = **whipsaw** (su e giù all'apertura, falsi break) → il breakout STOP si fa frullare (visto il 29/07: long stoppati poi short stoppati). Sul DAX il **RETEST è ancora più adatto** (fadare il ritorno invece di inseguire la rottura). **Se STOP+RETEST falliscono sul DAX → 3° motore per il chop:** (a) RANGE-FADE (fada gli estremi del range invece di romperli), (b) ENTRATA RITARDATA/CONFERMATA (entra dopo 15-30 min, quando il DAX ha scelto la direzione). Il confronto STOP vs RETEST (Dow/DAX/Nasdaq) decide empiricamente.
     - 🎯 **DAX M3 (idea Claudio 01/08):** DOPO aver trovato il motore M5 sulle aperture, **riprovare/ridisegnare il DAX su M3** portandoci sopra il motore M5 validato + la gestione migliore (BE/trailing dallo studio gestione). NB: il DAX_M3 *originale* è scartato (whipsaw sui falsi break, rumore M3, R/R invertito) → questo è un **redesign sperimentale**, non la riaccensione del vecchio.
       - 📛 **NOME NUOVO deciso (01/08): `ABTG_DAX_M3_v2`** (magic nuovo dedicato), separato dal vecchio `ABTG_DAX_M3` scartato — così restano distinti e il vecchio non si riaccende per sbaglio.
       - ⛔ **NON riaccendere** i vecchi `DAX_M3` e `Londra_ORB`: erano spenti per MOTORE rotto (PF<1), non per la gestione. L'aggiornamento BE/trailing NON li salva.
8. 🔵 (Opz) validare a tick reali i forex SupRev H4 promettenti: AUDJPY (short), GBPJPY (long).

### 🛠️ DA COSTRUIRE (Claude, quando arrivano i dati)
9. ✅ **FATTO — Preset forward Nasdaq H1 SupRev**: `ABTG_SupertrendReversal_FW_Nasdaq_H1.set` (StMult 3.0, StAtr 10, TP 2.5R, BOTH, magic 770925, risk 1%). Da caricare su NASUSD H1 (EA `ABTG_SupertrendReversal`) → 5° cavallo del forward.
10. 🟢 **Preset forward Dow apertura** (dopo conferma tick reali) + decisione su Nasdaq apertura (positivo ma DD 7-8%).
11. 🟡 **DAX apertura**: NON usa il filtro H4 (lo peggiora: +0,026→−0,017). Al più bias Short (+0,045). È marginale → confermare col motore reale prima di tenerlo sul serio.

### 📈 FORWARD → PROP
12. 🟢 **FORWARD in corso — SQUADRA AL COMPLETO (8 EA):** 5 SupRev (Oro/Argento/DAX/Nikkei H4 + Nasdaq H1) + 3 GoldenCross (USDCHF/USDCAD/NZDUSD H4). Ora serve TEMPO: pagella PF/DD reale tra ~2-3 mesi. Claudio manda lo statement periodicamente → Claude archivia e traccia.
12b. 🟢 **WALK-FORWARD (IS vs OOS) sui finalisti** — ultimo cancello anti-overfit PRIMA del dry-run. Script `walkforward.ps1` (Oro SupRev H4 + USDCHF GoldenCross H4): stessa griglia su IS 2024.01-2025.06 e OOS 2025.07-2026.06; se i parametri robusti reggono anche in OOS = edge stabile. Non è "ottimizzare di più" ma verificare fuori campione. Default OHLC, `-Model 4` per tick reali.
13. ✅ **FATTO (01/08): demo 100k APERTO** su MT5 da Claudio per simulare la prop. Prossimo: caricarci sopra i finalisti + il Guardian (preset FTMO 2-Step, InpStartBalance=100000) per il dry-run — DOPO che il forward dà la pagella.
14. 🔵 **DRY-RUN PROP** su demo 100k + guardiano (dopo il forward). Prop: **FTMO 2-Step** (5%/10% statico, target +10%, no limite tempo, EA ok, split 80-90%). Preset pronto: `ABTG_Guardian_FTMO_2Step.set` (InpStartBalance=100000).

### 🔵 MINORI / FUTURO
15. **Chiusura a tempo PostNews** (news+75min): decidere "sempre" o "solo se non a TP", poi al codice.
16. **Testare i refinement opt-in** già in codice (default OFF): EMA200 filtro ADR (`InpUseAdrFilter`), apertura filtro VWAP (`InpUseVwapFilter`).
17. **Altri refinement live** (menu, Claudio sceglie): SupRev filtri MA50/ADX, PTE canali TMA, FiboH4 laddering, WOL, Bollinger squeeze, filtro FVG.
18. **Analizzatore regime × EA** (incrocia snapshot giornalieri + statement).

## ✅ FATTO (archivio sintetico)
- **28/07:** scan SupRev H4 (48 simboli) analizzato · guardiano creato · studio-apertura EA esteso (MAE/MFE) · launcher validazione tick-reali.
- **29/07:** FOMC configurato+attivato (buy scattato) · BCE preparata (10/09) · **trovato bug sistemico gestione Hedge** (SelectMyPosition) · fix su 5 EA apertura + OCO su PostNews (pushati sul default) · short Nasdaq riattivato.
- **30/07:** validazione **tick reali** SupRev (Oro/Argento reggono, DAX/Nikkei marginali, **Dow/ASX scartati**) · 4 preset robusti creati e messi **in forward** · scan **H1** partito · dashboard promemoria riordinata.
- **01/08:** VPS confermato da Claudio. **Squadra forward core 8/8 ATTACCATA** (5 SupRev: XAUUSD/XAGUSD/D30EUR/225JPY H4 + NASUSD H1; 3 GoldenCross: USDCHF/USDCAD/NZDUSD H4).
  - 📌 **DECISIONE Claudio (01/08):** sul demo gira **TUTTA la flotta** (quasi tutti i nativi + gli ottimizzati, in parallelo, magic diversi) — vuole **osservare in forward come si comportano tutti**, non solo gli 8. Chiusi finora **solo DAX_M3 e Londra_ORB**. I "morti" restanti (Live5m/ORB/ORB_Fibo/Nasdaq apertura) **lasciati accesi per osservazione** (su demo, costo = un po' di DD demo; verdetto backtest già noto = deboli).
  - ✅ **RISOLTO 01/08 ~08:15: RICOMPILAZIONE FATTA sul VPS** (`scarica_ottimizzati.ps1`). Confermato da screenshot: il DAX apertura Ottimizzato ora mostra il gruppo "=== Filtro VWAP ===" (`InpUseVwapFilter`=false opt-in, TF M15). → fix Hedge-safe + anti-duplicato + gestione nuova ORA ATTIVI. **Il forward test è VALIDO da 01/08.** La pagella per-EA parte da questa data (tutto ciò che è prima si scarta).
  - 🟡 Nota config: sul DAX apertura Ott. "OTT: SOLO LONG" = false → attualmente opera in ENTRAMBE le direzioni (il validato era LONG-only). Ok per l'osservazione forward; se si vuole la versione validata, mettere l'opt-in LONG-only.
  - ✅ **VERIFICA FINALE 01/08: anche gli SWING confermati ricompilati.** SupRev Oro (XAUUSD H4) controllato: marker "Chiudi tutto venerdì" presente, InpComment "STREV FW Oro", magic 770921, StMult 2.5/ATR 10/TP 2.5R, LONG-only. **Tutta la flotta aggiornata → check VPS CHIUSO al 100%. Forward valido dal 01/08.**
  - ✅ Attribuzione forward OK: ogni EA ha **magic univoco + InpComment** riconoscibile → dallo statement Claude fa la pagella PER EA.
- **30/07 (sera) — STUDIO APERTURE M5 (8 indici) analizzato:**
  - Metrica: aspettativa R/trade. **Solo indici USA hanno edge; EU (tranne DAX marginale) NO.**
  - **Dow (U30USD): ⭐ +0,126 R/trade col filtro H4** (+0,074 cieco). **Nasdaq: +0,055 SOLO col filtro H4** (cieco ≈ 0). DAX: marginale (+0,026 cieco, filtro H4 lo PEGGIORA). S&P/IBEX/EuroStoxx/CAC/FTSE: **negativi → scartati** (evitati 5 EA perdenti).
  - **Filtro H4 = prezzo vs EMA50 su H4** (conferma live Emiliano: opera a favore del trend maggiore). Aiuta gli USA, danneggia EU/DAX.
  - MAE/MFE: vincitori ritracciano ~0,4R (max ~1R), corrono ~2R → gestione attuale (SL=range, parziale 1R+BE, TP 2R) **gia' allineata**. Leva = direzione/filtro/simbolo, non SL/BE.
  - **FATTO preset** (M5, EA `ABTG_Nasdaq_Apertura_US` symbol-agnostico): `ABTG_Apertura_Dow_U30_H4.set` (magic 770221) e `ABTG_Apertura_Nasdaq_US_H4.set` (770201). Filtro H4 ON, risk 1%.
  - ✅ **CONFERMATO col motore REALE (OHLC M5, filtro H4, 132 combo):** **Dow PFmed 1,84 (peggiore 1,76!), DD ~5%, 100% pass positivi** → edge solidissimo, la gestione reale MIGLIORA sullo studio. **Nasdaq PFmed 1,11, DD 7-8%** → positivo ma più debole. Script: `conferma_apertura_us.ps1`.
  - ✅ **TICK REALI (31/07):** **Nasdaq apertura SCARTATO** (PF 0,82, 0% pass positivi, DD 17% — l'edge OHLC era finto, mangiato dai fill). **Dow apertura sopravvive ma modesto** (PF 1,16, 100% pass positivi ma DD ~8%). Il breakout con ordini STOP paga troppo slippage.
  - 📌 **VERDETTO apertura:** i SupRev (Oro/Nasdaq H1, PF ~1,4 DD 1,2%) sono MOLTO meglio del Dow apertura (PF 1,16 DD 8%). Apertura = priorità bassa per la prop. Dow apertura: o variante "entra sul RETEST" (limit, non stop — leva di Emiliano contro lo slippage), o forward solo come osservazione. Nasdaq apertura preset da NON usare.
- **30/07 (sera) — SCAN H1 SupRev analizzato + matrice a tick reali:**
  - Scan **H1** (InpTF=16385, 45 simboli) classificato. Vincitori OHLC H1 (PFmed≥1): D30EUR 1,13 · U30USD 1,13(S) · E35EUR 1,01 · NASUSD 1,00.
  - Incrociato con **validazioni a tick reali in archivio** (`risultati_archivio/`): **Nasdaq H1 = ⭐ PFmed 1,40 / DD 1,17% / 100% combo positive** → candidato prop top, diversifica con Oro. **Dow SCARTATO** (revalidation pulita: PFmed reale 0,79, illusione OHLC). DAX→H4 marginale (1,05 reale). CAC H4 scarta (overfit).
  - **MATRICE:** Oro/Argento/DAX/Dow → **H4** · **Nasdaq → H1**. Il TF sblocca simboli diversi.
  - ✅ **Dow RISOLTO: SCARTATO** — revalidation pulita PFmed 0,79 (illusione OHLC). Il "1,77" era un run sporco.
  - Da validare a tick reali: **IBEX (E35EUR) H1** (unico vincitore H1 senza RT in archivio).
  - TODO: preset forward **Nasdaq H1** (5° cavallo).
- **30/07 (pom.) — A+B+C+D "a tavolino":**
  - **A** scan_market.ps1: aggiunti 5 motori (SuperWave, SupertrendInvert, PTE, WOL, FiboH4_Multi) con griglia direzione+parametro chiave, TF nativo.
  - **B** fix gestione **Hedge** completato su **SupertrendInvert, GoldenCross, GoldenCross_Ott, IchiTrend, MaxMinNotte_DAX_Short_Ott** (SelPos/SelMyPos per ticket + PositionModify/Close per ticket). 0 op `_Symbol` residue, parentesi ok. *(Da validare in tester + deploy con ricompilazione #1.)*
  - **C** `abtg_news.csv`: aggiunte date **FOMC Set/Ott/Dic 2026 + Gen 2027** (+ ECB Ott/Dic) → PostNews continua a tradare dopo il 29/07. *(Il match è per GIORNO; l'ora d'azione resta nel preset. NB: verificare le date Fed prima di ogni meeting.)*
  - **D** refinement da live, **opt-in default OFF** (nessun cambio di comportamento finché non testati):
    - `ABTG_EMA200` (+Ott): filtro **ADR-distanza** (Paolo) — `InpUseAdrFilter`, opera solo se dist. prezzo-EMA200 ≤ ~0,8× ADR giornaliero.
    - Motore **apertura** (DAX/Nasdaq/Marco, ×5): filtro **VWAP di sessione** (Emiliano) — `InpUseVwapFilter`, opera solo dal lato giusto della VWAP M15.
  - ⚠️ **Il CSV `abtg_news.csv` va copiato sul VPS** in `MQL5/Files/` (non passa dalla ricompilazione EA).

---

## 🗓️ POLITICA WEEKEND (decisa 31/07)
- **Swing (SupRev, GoldenCross, EMA200, SuperWave, SupertrendInvert, FiboH4, WOL): APERTI nel weekend** (default). Il backtest 2,5 anni include già gap+swap → DD basso *con* i weekend tenuti. Chiuderli = sistema diverso, peggiore.
- **Intraday (aperture, HARSI, MaxMinNotte, Live5m): già flat ogni sera** (`InpCloseAtEnd`) → non vedono il weekend.
- ✅ Aggiunto **opt-in `InpFridayClose` (default OFF)** + `InpFridayCloseHour` (server) su **SupRev, GoldenCross(+Ott), EMA200(+Ott)**: chiude posizioni+pendenti MIEI per ticket (Hedge-safe) il venerdì oltre l'ora. Default OFF = restano aperti come validato. Da estendere a SuperWave/SupertrendInvert/FiboH4/WOL quando entrano in forward.

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
4. **Guardiano** (`ABTG_Guardian.mq5`) — **NEW**: fa rispettare le regole prop sul demo 100k (vedi sotto).

---

## 🧭 IMBUTO / DOVE SIAMO
```
1. SCOPERTA  scan OHLC 48 simboli ............... ✅ FATTO (SupertrendReversal)
2. VALIDAZIONE  tick reali sui vincitori ........ ◄── SIAMO QUI (launcher pronto)
3. FORWARD  girano i validati, pagella reale .... da fare
4. TOP 3 diversificati (2 indici + 1 metallo) ... da scegliere sui numeri veri
5. DRY-RUN PROP  demo 100k + guardiano .......... da fare (guardiano pronto)
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
- **Terna proposta per il Multi:** Oro (metallo) + Nikkei (indice Giappone, DD 0,14%) + un 2° indice — **NON Dow** (scartato a tick reali). Obiettivo: strumenti poco correlati.
- ⚠️ È H4. Il **Nasdaq** qui è debole (PFmed 0,68) ma a **H1** rendeva (PF 1,57) → **il TF cambia tutto**: fare anche scan H1.

## 📌 PROMEMORIA APERTI (in coda — partono quando il PC fisso è libero)
1. **VALIDAZIONE tick reali** dei vincitori → `valida_realtick.ps1` (default: Oro, Argento, Dow, Nikkei, DAX, ASX).
   Poi Claudio manda i CSV → confronto tick-reali vs OHLC → chi regge davvero.
2. **SCAN H1** per confronto col H4 → `.\scan_market.ps1 -Robot ABTG_SupertrendReversal -Tf H1`. Claudio preferisce H1 (chiude in giornata).
3. ⭐ **MOTORE APERTURA M5 SU TUTTI GLI INDICI** (progetto chiave di Claudio):
   - 🟡 **IN CODA dopo lo scan H1** (PC fisso occupato, un backtest alla volta). Ordine: (1) finisce scan H1 → Claudio manda CSV → Claude classifica; (2) POI lancia lo studio apertura.
   - **Comando pronto (PC FISSO, MT5 chiuso):**
     `cd $HOME\Desktop; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/claude/ea-market-openings-d79m8l/backtest_pipeline/studio_apertura.ps1" -OutFile studio_apertura.ps1; powershell -ExecutionPolicy Bypass -File .\studio_apertura.ps1`
   - Decisione aperta (Claudio ha rimandato): **motore unico universale** (consigliato, 1 file) vs **1 nativo per indice**. Il motore apertura è GIÀ symbol-agnostico → non serve codice nuovo per farlo girare su un indice, serve solo ora+preset.
   - **FASE A — misurare:** `studio_apertura.ps1` (già esteso a **8 indici**: DAX, CAC, EuroStoxx, FTSE100, IBEX @08:00 server; Nasdaq, Dow, S&P @14:30 server). Misura ampiezza/MAE/MFE/durata per indice.
   - **FASE B — analizzare:** Claude dai CSV → SL / BE / trailing / dimezza-lotto ottimali per indice.
   - **FASE C — costruire:** UN motore unico `ABTG_Aperture_Universal` (stesso motore delle aperture DAX/Nasdaq) applicato agli altri indici, con la gestione tarata.
   - Idea di Claudio: "creare il TF 5 min col motore delle aperture, con gli altri indici." Verificare gli orari di apertura sul grafico BCM.
4. **FORWARD** → statement periodico → pagella PF/DD reale per EA.
5. **DRY-RUN PROP** sul demo 100k + guardiano (dopo il forward).
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
- **Solo sul demo 100k**, per il dry-run. **MAI sul conto forward** (lì serve il comportamento grezzo).
- Modo A (autonomo): al limite giornaliero → chiude tutto + blocca fino a domani; al limite DD totale → chiude tutto + ferma.
- Parametri: `InpStartBalance=100000`, `InpDailyLossPct`, `InpTotalDDPct`, `InpDDMode` (statico/trailing), `InpDailyResetHour`, `InpAction` (0=enforce, 1=solo allarme).
- Da attaccare a **UN solo grafico** (governa tutto il conto). Pannello di stato a video.

## 📈 CONTI
- **Forward:** demo BCM **50503392** (EUR, Hedge, ~6k). Qui girano gli EA, NIENTE guardiano.
- **Prop sim:** secondo demo portato a **~100.000** per il dry-run futuro (col guardiano).

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
- "Quanti EA" = non un numero fisso: **nessun tetto al numero** in genere; il limite vero è la **perdita giornaliera COMBINATA** (< ~5%) + max lotti/consistenza. EA **scorrelati** → puoi tenerne di più. Raccomandazione: **2-4 diversificati**. Il dry-run sul 100k dà la risposta esatta.
- **PROP DI RIFERIMENTO scelta (30/07): FTMO** (affidabile, EA ammessi, no time limit, DD statico ~5%/10%, consistenza non stringente). Alternativa per stile lento/swing: **The5ers**.
  - Criteri EA-friendly: DD **statico** (non trailing), no/lieve consistenza, no time limit, hold overnight/weekend ok.
  - ⚠️ Le regole cambiano: **verificare i termini attuali sul sito** prima di pagare. Claudio caricherà il PDF del regolamento quando sceglie.
  - **DOPO il forward:** tarare il guardiano sui numeri tipo-FTMO → dry-run 100k. (Deciso 30/07: si aspetta il forward, niente pagamenti ora.)

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
- **30/07:** ricompilato e sostituito il **PostNews aggiornato** (OCO + chiusura 21:45 + sell offset 3) SOLO su **EUR/USD (FOMC)** + caricato preset FOMC. ✅ (ECB su EUR/JPY NON ancora ricaricato — ma deprioritizzato, prossima BCE 10/09.)

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
