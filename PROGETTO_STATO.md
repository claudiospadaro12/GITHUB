# Stato del progetto — dove siamo e cosa manca

Riepilogo per riprendere in fretta. Aggiornato: 22 luglio 2026.

## 1. 📊 Report analisi trading — SETTIMANALE (sabato 09:00) — ✅ ATTIVO E TESTATO
   (trade + categorie Indici/Valute/Cross/Metalli + più profittevoli + per EA +
    verifica bias; testato end-to-end su GitHub, statement letto, email ok)
**Obiettivo:** report del sabato che unisce analisi trade + verifica di
bias/livelli/correlazioni della settimana (cosa avevo previsto vs realta').
**Deciso:** settimanale, sabato 09:00; dati catturati ogni giorno in automatico.

- [x] Relazione di prova fatta a mano sui dati reali (20-22 lug): +453,60 EUR,
      edge su DAX/Nasdaq apertura, oro discrezionale in perdita, GBPUSD 07:00 da rivedere
- [x] **Cattura giornaliera** (prerequisito): il report salva ogni giorno
      data/snapshots/AAAA-MM-GG.json con bias/livelli/correlazioni e lo committa nel repo.
      → parte da domani; la verifica avra' dati dopo ~1 settimana.
- [x] Parser statement (agent/statement.py): trade + strategia da EA + statistiche
- [x] Verifica bias (agent/verify.py): bias previsto vs movimento reale (yfinance)
- [x] Orchestratore (run_weekly_report.py): analisi trade + verifica bias -> HTML/email
- [x] Workflow GitHub (weekly-report.yml) + sveglia VPS sabato 09:00 (trigger_weekly.ps1)
- [x] Task del sabato registrato sul VPS ("ReportSettimanaleTrading", sab 09:00)
- [ ] Statement: per ora si mette in data/statements/ (il piu' recente).
      Auto-export da MT5 = prossimo miglioramento.
- [ ] Prossima versione: verifica anche LIVELLI (S/R, golden zone) e CORRELAZIONI
- Nota: la verifica bias avra' dati veri dopo qualche giorno di snapshot (da 23/07).

## 2. 🤖 Backtest + ottimizzazione EA in automatico — ⏳ PRONTO DA LANCIARE
**Obiettivo:** ottimizzare tutti i ~19 EA in serie, con selezione parametri ROBUSTI
(anti-overfitting), con UN SOLO script sul VPS.

- [x] `OptFrame.mqh` → scrive il CSV dei risultati da solo (testato, compila)
- [x] `optimizer/batch_analyze.py` → sceglie i set robusti (testato su dati reali)
- [x] Catena provata end-to-end su ABTG_Nightly + ABTG_DAX_Apertura_EU
- [x] **Tutti i 18 EA resi self-contained** (blocco OptFrame inlinato dentro ogni
      .mq5 → NIENTE piu' include esterno, niente errori "file non trovato").
      Rimossa la dipendenza da OptFrame.mqh; a ABTG_Nightly tolto il vecchio include.
- [x] `backtest_pipeline/ea_config.json` → per ogni EA: simbolo, TF, 2-3 parametri
      da ottimizzare con range sensati (il rischio % NON si ottimizza).
- [x] `backtest_pipeline/gen_ini.py` → genera i .ini del Tester (19 file, testato).
- [x] `backtest_pipeline/run_all.ps1` → LAUNCHER UNICO: copia+compila+ottimizza tutto
      e raccoglie i CSV. Il VPS fa tutto da solo.
- [ ] **TU:** controlla i 3 percorsi e i simboli, poi lancia run_all.ps1 sul VPS di TEST.
- [ ] Mi mandi `risultati_ottimizzazione/` → io analizzo e creo gli `_Ottimizzato`.
- Nota storico dati corto su alcuni indici → il forward su demo resta la vera validazione.

**REGOLA FISSA per gli EA ottimizzati (richiesta di Claudio):**
- Suffisso **`_Ottimizzato`** nel nome (es. ABTG_DAX_Apertura_EU_Ottimizzato).
- Girano **IN PARALLELO** agli originali, **NON li sostituiscono**.
- **Magic number DIVERSO** dall'originale (es. 770101 -> 770102) per non interferire.
- Claudio tiene entrambi in demo -> dopo vari giorni di FORWARD si confronta
  originale vs ottimizzato e si tiene solo il migliore.
- Backtest a TICK REALI (Model=4). Simboli: D30EUR(DAX), NASUSD, XAUUSD, EURUSD, GBPUSD.

## 3. 📧 Report di mercato giornaliero (email 07:00) — ✅ ATTIVO
- [x] Sistema funzionante su GitHub Actions
- [x] Capito il problema: GitHub ritarda i cron di ore
- [x] Task Scheduler del VPS ("ReportMercatoGiornaliero") chiama GitHub alle 07:00 feriali
- [x] Token GitHub creato e salvato sul VPS (C:\Users\Administrator\.gh_report_token.txt)
- [x] Testato: run #67 (workflow_dispatch dal VPS) OK, email ricevuta
- [x] Rimosso il cron di GitHub per evitare email doppie
- Nota: se il VPS e' spento non parte -> riattivare il cron fallback nel workflow

## 4. 🔁 Pagella giornaliera — chiusura del loop
**Obiettivo:** ogni giorno l'agente verifica DUE cose e manda una "pagella".

- **A) Coerenza del bias:** confronta il bias del mattino (report) con il
  movimento reale del giorno → costruisce lo storico di quanto il bias ci prende.
  - [ ] Salvare il bias del mattino (una riga per strumento) nel report esistente
  - [ ] A EOD: scaricare il movimento reale + confronto direzione/magnitudine
- **B) Compliance dei trade:** confronta i trade eseguiti (statement) con le
  regole del Piano di Trading.
  - Automatici: rischio ≤2%, stop giornaliero, size coerenti, simbolo/sessione, no oro discrezionale/post-news
  - Soggettivi (solo se i trade sono taggati): grado setup, revenge → altrimenti segnalati
  - [ ] Codificare le regole del piano (già scritte in piano_trading/)
  - [ ] Generare la "pagella": X/Y bias coerenti + X/Y trade a regola
- **Limiti:** controlli oggettivi automatici; soggettivi richiedono tag; sui CFD i
  decimali del broker differiscono (direzione ok).

## 5. 📋 Piano di Trading (FATTO — base)
- [x] Documento Word creato (piano_trading/Piano_di_Trading_Claudio.docx)
      seguendo la guida del coach: Obiettivi/Disciplina, Money Management
      (size + rischio), Strategie (auto + discrezionale), Controllo
- [ ] Personalizzare con il coach: capitale reale, obiettivo annuo, importi € dei limiti

## 6. 🛡️ Protezioni "live" (dopo i backtest) — DA FARE
Emerse dalla giornata -535 EUR (23/07: tutti gli EA long sul DAX in un DAX
ribassista) e dal confronto con l'amico che crea EA.

- [ ] **Guardiano di portafoglio**: stop giornaliero (es. -3/4% conto -> blocca
      nuovi trade fino a domani) + limite di esposizione stesso strumento/direzione
      (no 4 EA long DAX insieme). Priorità alta.
- [ ] **Rivedere DAX M3**: il 23/07 ha aperto 5 long a scendere (-220). Manca un
      filtro di trend robusto.
- [ ] **Spia slippage + floor minimo SL** (idea amico, rifinita):
      1) registrare prezzo richiesto vs eseguito su ogni ordine -> CSV (distribuzione, non solo media);
      2) floor SL = spread + 95° percentile slippage + cuscinetto ATR; se SL calcolato < floor -> allarga+riduci size (reversal) o salta (breakout).
      NB: il backtest NON misura lo slippage reale -> questi dati si prendono in demo/live.

## (?) Punto rimasto in sospeso
Un messaggio si era interrotto su "...ottimizzazione con agente e ___".
Se c'era un altro filone, da completare.

---

## Regola d'oro di trading emersa in questi giorni
> Il metodo batte la previsione. Guadagni con le aperture automatiche DAX/Nasdaq;
> restituisci con l'oro discrezionale mal dimensionato. Entra sul RITEST, non sul
> candelone. Non tutti gli incroci Ichimoku sono buoni (occhio a quelli in
> compressione / dentro la nuvola).
