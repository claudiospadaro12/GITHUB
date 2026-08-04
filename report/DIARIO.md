# 📔 DIARIO — una riga al giorno, la memoria che si accumula

_Scritto dalla pagella automatica delle 23:00. Prima di aggiungere una riga si rileggono le precedenti: serve a riconoscere i problemi che **si ripetono**, che sono gli unici su cui vale la pena intervenire._

Regola: **il forward osserva, il backtest decide.** Un parametro si tocca solo se (1) lo stesso schema compare ≥3 volte qui sotto **e** (2) un backtest a tick reali lo conferma. I difetti *meccanici* (EA in direzioni opposte, trailing fuori scala) si correggono subito, anche con un caso solo.

| Data | Netto | Osservazione principale | Report |
|---|---|---|---|
| 2026-08-04 | _(dagli screenshot, non ancora dal CSV)_ | 🔑 **A/B pulito sul trailing**: stesso simbolo, stesso giorno, stessa direzione. `DAX Live 5m` (trailing base candela) tiene **2m18s** e prende **25,6 punti**; `DAX Apertura EU` (trailing fisso 410 = 0,07R) tiene **45 s** e prende **1,9**. Tredici volte i punti. Frazione catturata scesa al **3,3%** (ieri 14%). I due `Live5m` hanno venduto sullo sweep d'apertura e sono stati stoppati in 61 s, e il `Nasdaq Live 5m` in **20 s** dopo aver venduto **133 punti sopra il massimo notturno**. Sul Nasdaq l'**`ORB` ha colpito il TP a 2R** (+93,16, 40% del movimento) mentre il Live5m perdeva −93,03: netto **+0,13**, si sono annullati. (**2ª volta in 2 giorni**, ieri long, oggi short: il loro range è la candela di **pre**-mercato, dentro il rumore per costruzione). | [FORWARD_04-08_AB_TRAILING](../FORWARD_04-08_AB_TRAILING.md) |
| 2026-08-03 | **−97,61** | Prima pagella con dati veri. Le 3 aperture DAX entrano al livello giusto e chiudono in **34–39 s**; lo storico mostra che è **cronico** (`Apertura Marco` 80% dei trade sotto il minuto, `DAX Apertura EU` 35% e −382 € sul periodo). Il `Nasdaq OTT` che avevo criticato la mattina ha chiuso **+41,04, il migliore della giornata** — ed è l'unico durato più di 5 minuti. Trovate **661 operazioni senza etichetta a −18 707 €** (485 su XAUUSD, lotti 0,5–1,0, fino al 27/07): **da identificare**. | [giornata_2026-08-03](giornata_2026-08-03.md) |

## 🔁 Schemi in osservazione (contatore verso la soglia delle 3)

| Schema | Volte | Stato |
|---|---|---|
| Aperture DAX chiuse sotto i 60 s in profitto dal **trailing fisso 410** | **2** consecutive (+ cronico nello storico: 35–80% dei trade per EA) | ✅ **soglia superata**. Il 04/08 dà anche l'alternativa già osservata: `InpTrailMode=1`. Conferma a backtest = fase distanze |
| Due o più EA sullo stesso simbolo in **direzioni opposte** | **2** (NASUSD 03/08 e 04/08) | ⚠️ il 04/08 se ne capisce la CAUSA: `Nasdaq Live 5m` e `ABTG_ORB` usano **la stessa candela 14:25-14:30** e si mettono ai lati opposti → perdita garantita per costruzione. Decisione di flotta, subito |
| Più EA sullo stesso simbolo, **stessa direzione** (rischio moltiplicato) | **2** (03/08 e 04/08) | ⏳ stesso capitolo |
| `Live5m` presi dallo **sweep d'apertura** (range = candela di pre-mercato) | **3** (DAX 03/08 long, DAX 04/08 short, NASDAQ 04/08 short a 133 pt sopra il max notturno) | ⚠️ difetto strutturale: il trigger sta dentro il rumore. Correggibile con un parametro, ma li renderebbe doppioni di `Apertura EU` |
