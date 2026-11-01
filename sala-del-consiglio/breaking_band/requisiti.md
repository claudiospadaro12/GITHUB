# Requisiti (R) — Breaking Band
| ID | Priorita | Responsabile | Criterio di accettazione | Stato |
|---|---|---|---|---|
| R001 | Essenziale | A2 | Specifica numerica di Continuazione e Inversione: ogni criterio della Checklist ha soglia dichiarata, oppure e marcato NON_MISURABILE con motivo; ambiguita e contraddizioni delle fonti elencate | Aperto |
| R002 | Essenziale | A3 | Audit dati (copertura, buchi, spread, timestamp) con numeri e limiti; analisi a priori della geometria rischio/rendimento (distanza mediana-banda in ATR contro stop 3 ATR; win rate di pareggio) | Aperto |
| R003 | Essenziale | A4 | Motore di simulazione generico: barre da M1, ingresso alla barra dopo con spread, stop prima del target nello stesso minuto, nessun look-ahead, target mediana ricalcolato ogni 3 barre, stop 3 ATR, chiusura forzata dichiarata | Aperto |
| R004 | Essenziale | A7 | Piano di verifica + test di correttezza su dati sintetici (invarianza al troncamento del futuro, simmetria rialzo/ribasso, contabilita spread, stop-first) con esito SUPERATO/FALLITO eseguito; ricalcolo indipendente delle statistiche finali | Aperto |
| R005 | Essenziale | C0/A1 | Criteri di accettazione e previsioni (probabilita) scritti e congelati (hash) PRIMA di guardare qualunque risultato del test sulle regole | Aperto |
| R006 | Essenziale | A4 | Risultati per variante (CONT/INV x H1/M15), per periodo (2013, 2018, 2020, 2025-26) e imbuto delle condizioni; tutte le varianti riportate | Aperto |
| R007 | Essenziale | A6 | Critica indipendente: look-ahead, confronti multipli, interpretazioni arbitrarie, regime, sovrapposizione dei segnali; scenario di fallimento | Aperto |
| R008 | Utile | A5 | Applicabilita: costi/spread, frequenza attesa, confronto con eventuale EA Bulge gia presente nel repo, cosa servirebbe per un EA, prossimi passi proporzionati | Aperto |
| R009 | Essenziale | A1/C0 | Relazione finale breve in italiano: verdetto onesto, evidenza, limiti, cosa manca (Guida Operativa 11), prossimi passi | Aperto |
| R010 | Opzionale | A2 | Lettura qualitativa dei 10 esempi del PDF contro la specifica (valido/non valido coerente?) | Aperto |
Derivati dal brief: R003-R004 (qualita del test) dal vincolo "nessun look-ahead, spread pagato"; R005 dal vincolo "criteri scritti prima".
## Griglia di qualita (D001, fissata prima del ciclo 0)
Pesi adattati al dominio (trading/algoritmi), somma 100: Aderenza 15, Correttezza ed evidenze 25, Completezza 15, Fattibilita e robustezza 10, Utilizzabilita 10, Verificabilita 15, Qualita espositiva 10. Soglia 90, nessuna dimensione sotto 80. Modalita AUTO: agenti reali.
