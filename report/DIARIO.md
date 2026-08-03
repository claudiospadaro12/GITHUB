# 📔 DIARIO — una riga al giorno, la memoria che si accumula

_Scritto dalla pagella automatica delle 23:00. Prima di aggiungere una riga si rileggono le precedenti: serve a riconoscere i problemi che **si ripetono**, che sono gli unici su cui vale la pena intervenire._

Regola: **il forward osserva, il backtest decide.** Un parametro si tocca solo se (1) lo stesso schema compare ≥3 volte qui sotto **e** (2) un backtest a tick reali lo conferma. I difetti *meccanici* (EA in direzioni opposte, trailing fuori scala) si correggono subito, anche con un caso solo.

| Data | Netto | Osservazione principale | Report |
|---|---|---|---|
| 2026-08-03 | **−97,61** | Prima pagella con dati veri. Le 3 aperture DAX entrano al livello giusto e chiudono in **34–39 s**; lo storico mostra che è **cronico** (`Apertura Marco` 80% dei trade sotto il minuto, `DAX Apertura EU` 35% e −382 € sul periodo). Il `Nasdaq OTT` che avevo criticato la mattina ha chiuso **+41,04, il migliore della giornata** — ed è l'unico durato più di 5 minuti. Trovate **661 operazioni senza etichetta a −18 707 €** (485 su XAUUSD, lotti 0,5–1,0, fino al 27/07): **da identificare**. | [giornata_2026-08-03](giornata_2026-08-03.md) |

## 🔁 Schemi in osservazione (contatore verso la soglia delle 3)

| Schema | Volte | Stato |
|---|---|---|
| Aperture DAX chiuse sotto i 60 s in profitto | **1** (ma **cronico nello storico**: 35–80% dei trade per EA) | ⏳ soglia raggiunta sui dati storici → **serve la FASE B** per la conferma a backtest |
| Due o più EA sullo stesso simbolo in **direzioni opposte** | **1** (NASUSD, 03/08) | ⏳ difetto meccanico: decisione di flotta, non di parametri |
| Più EA sullo stesso simbolo, **stessa direzione** (rischio moltiplicato) | **1** (D30EUR ×3 e NASUSD ×2, 03/08) | ⏳ stesso capitolo |
