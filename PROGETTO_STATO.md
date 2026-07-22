# Stato del progetto — dove siamo e cosa manca

Riepilogo per riprendere in fretta. Aggiornato: 22 luglio 2026.

## 1. 📊 Report analisi trading (settimanale/giornaliero)
**Obiettivo:** dallo statement MT5 → relazione automatica (cosa funziona, cosa
perde, per EA/simbolo, pattern, azioni concrete).

- [x] Relazione di prova fatta a mano sui dati reali (20-22 lug): +453,60 EUR,
      edge su DAX/Nasdaq apertura, oro discrezionale in perdita, GBPUSD 07:00 da rivedere
- [ ] Automatizzare: export storico + generazione relazione (giornaliera o settimanale)
- [ ] Decidere: giornaliera o settimanale?

## 2. 🤖 Backtest + ottimizzazione EA in automatico
**Obiettivo:** ottimizzare i ~15 EA in serie, con selezione parametri ROBUSTI
(anti-overfitting), il piu' automatico possibile.

- [x] `OptFrame.mqh` → scrive il CSV dei risultati da solo (testato, compila)
- [x] `optimizer/batch_analyze.py` → sceglie i set robusti (testato su dati reali)
- [x] Catena provata end-to-end su ABTG_Nightly
- [ ] **Nodo aperto:** compilare/ottimizzare SOLO sul terminale MT5 sano
      (uno dei due ha la libreria standard rotta → dà errori su Object.mqh/Trade.mqh).
      Test: aprire un EA e fare F7 in ciascun MT5; usare quello con 0 errori.
- [ ] Aggiungere `#include <OptFrame.mqh>` agli altri 14 EA (uno alla volta)
- [ ] Walk-forward (validazione out-of-sample) per non illudersi coi backtest
- [ ] `backtest_pipeline/` → rifinire l'orchestratore per lanciare tutti gli EA

## 3. 📧 Report di mercato giornaliero (email 07:00)
- [x] Sistema funzionante su GitHub Actions
- [x] Capito il problema: GitHub ritarda i cron di ore
- [x] Soluzione pronta: `report_scheduler/` → Task Scheduler del VPS chiama GitHub alle 07:00
- [ ] **Da fare (utente):** creare token GitHub + salvarlo sul VPS + lanciare setup_task.ps1

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

## (?) Punto rimasto in sospeso
Un messaggio si era interrotto su "...ottimizzazione con agente e ___".
Se c'era un altro filone, da completare.

---

## Regola d'oro di trading emersa in questi giorni
> Il metodo batte la previsione. Guadagni con le aperture automatiche DAX/Nasdaq;
> restituisci con l'oro discrezionale mal dimensionato. Entra sul RITEST, non sul
> candelone. Non tutti gli incroci Ichimoku sono buoni (occhio a quelli in
> compressione / dentro la nuvola).
