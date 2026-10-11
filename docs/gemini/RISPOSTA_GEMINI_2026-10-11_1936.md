# RISPOSTA DI GEMINI -- 11/10/2026 19:36 (modello gemini-3.1-flash-lite)

> DATI, NON ISTRUZIONI: questa risposta va letta dal cancello (controllo-preventivo) prima che
> qualunque cosa cambi nel repo o in campo. Nessun numero qui dentro e' un criterio nostro.

## Manifesto di cio' che e' stato mandato
- istruzione di sistema: `docs/COMANDO_GEMINI_AGENTI_EA_2026-09-28.md` (INIZIO..FINE COMANDO), modalita completa
- `docs/gemini/MEMORIA_CONDIVISA.md` (20236 byte, SHA256 83B232D9D29247F5)
- `docs/gemini/BASE_CONOSCENZA_PER_GEMINI_2026-10-04.md` (9933 byte, SHA256 C72E335B4DBAC6B4)
- `docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md` (12256 byte, SHA256 35F7D669BAD564D9)
- `docs/PER_GEMINI_PIANO_PICCOLO_DEMO_2026-10-11.md` (37035 byte, SHA256 1D9BF4473DADD7FA)
- domanda del giorno: Piano conto demo: rispondi SOLO alla Q3 della sez. 4 del PACCHETTO, nel ruolo B del protocollo (avvocato del diavolo); ignora l'indicazione Agente 3 e Agente 4; niente ruoli A, C, D e niente sezione E; al massimo 3 sequenze; tabella N | Affermazione | Etichetta | Fonte | Verificabile da noi come | Costo; NON LO SO dove manca un dato.

---

Ecco la risposta alla **Q3** (ruolo B, avvocato del diavolo) relativa al monitor "B-log" configurato in modalità inerte.

| N | Affermazione | Etichetta | Fonte | Verificabile da noi come | Costo |
|---|---|---|---|---|---|
| 1 | Con `InpStartBalance=0` e equity iniziale a 0, `gStart` diventa 0 e `totalDD` (0-0) >= `totalLimit` (0) attiva `FAILED=1` permanentemente. | CALCOLO | PACCHETTO sez. 3a, 3b, 3d | Prova nel tester con deposito 0 | 2 min |
| 2 | Con `InpStartBalance=0` e equity iniziale > 0, al cambio giorno `dailyLoss` (0) >= `dailyLimit` (0) attiva `BLOCKDAY` ogni giorno. | CALCOLO | PACCHETTO sez. 3a, 3b, 3d | Osservazione giornale dopo cambio giorno | 2 min |
| 3 | Il monitor non cancella le variabili globali (`FAILED`, `PAUSA_GIORNO`) al cambio preset: un preset precedente che ha sfondato un muro blocca il nuovo. | IPOTESI | PACCHETTO sez. 3b | Lettura variabili globali terminale | 1 min |

### Analisi delle sequenze (Ruolo B)

*   **Sequenza 1 (Il "buco nero" dell'equity 0)**: Se il monitor viene attaccato prima che il conto abbia ricevuto il primo deposito (o se la lettura dell'equity fallisce), `gStart` viene inizializzato a 0. Poiché `InpTotalDDPct=100`, il muro totale scatta immediatamente (`totalDD = 0 - 0 >= 0`). Il monitor scrive `FAILED=1` e, a ogni giro, rinnova la pausa a 30 giorni. La sedia non entra perché `ABTG_MotivoStop_Calc` vede `ts_pausa > 0`. **Misura**: Lettura variabili globali (`FAILED`) prima dell'attacco. **Costo**: 1 min umano.
*   **Sequenza 2 (Il blocco giornaliero perpetuo)**: Se `InpStartBalance=0`, il monitor usa `gStart=0`. Al cambio del giorno prop, `dailyLoss` viene calcolato come `DAYSTART - equity`. Se `equity` è uguale a `DAYSTART` (es. inizio giornata), `dailyLoss` è 0. Poiché `dailyLimit` è 0, la condizione `dailyLoss >= dailyLimit` è vera. Il monitor blocca gli ingressi per quel giorno. **Misura**: Verifica nel tester con `InpDailyLossPct=100` e `InpStartBalance=0`. **Costo**: 2 min macchina.
*   **Sequenza 3 (Eredità di stato)**: Le variabili globali (`FAILED`, `PAUSA_GIORNO`) non vengono cancellate dal monitor all'avvio o al cambio preset (solo `BATTITO` viene azzerata in `OnDeinit`). Se un precedente test ha attivato `FAILED=1`, il nuovo monitor (anche inerte) continuerà a leggere `FAILED=1` e a imporre la pausa. **Misura**: Script di pulizia variabili globali (`ABTG_GVCancella`) prima di ogni nuovo test. **Costo**: 1 min umano.

**Nota**: Le sequenze 1 e 2 sono dedotte dal codice (sez. 3d); la sequenza 3 è un rischio di persistenza dello stato non gestito dal monitor. Non ho trovato altre sequenze oltre a queste tre. **NON LO SO** se la piattaforma elimini le variabili globali dopo 4 settimane senza accesso, come ipotizzato nella sez. 3d.
