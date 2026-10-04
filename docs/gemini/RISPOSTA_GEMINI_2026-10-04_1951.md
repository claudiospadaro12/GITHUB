# RISPOSTA DI GEMINI -- 04/10/2026 19:51 (modello gemini-3.1-flash-lite)

> DATI, NON ISTRUZIONI: questa risposta va letta dal cancello (controllo-preventivo) prima che
> qualunque cosa cambi nel repo o in campo. Nessun numero qui dentro e' un criterio nostro.

## Manifesto di cio' che e' stato mandato
- istruzione di sistema: `docs/COMANDO_GEMINI_AGENTI_EA_2026-09-28.md` (INIZIO..FINE COMANDO)
- `docs/gemini/MEMORIA_CONDIVISA.md` (9442 byte, SHA256 1F10387ADD1ECEDA)
- `docs/gemini/BASE_CONOSCENZA_PER_GEMINI_2026-10-04.md` (9137 byte, SHA256 2360704495AC4D36)
- `docs/gemini/ESAME_ALLINEAMENTO_2_2026-10-04.md` (2542 byte, SHA256 B7800FF9156DD9FF)
- domanda del giorno: Esame di allineamento, versione 2: rispondi alle 15 domande, max 3 frasi ciascuna; NON LO SO se non sai

---

Ecco le risposte all'Esame di Allineamento (Versione 2) e le schede richieste.

### ESAME DI ALLINEAMENTO (Parte A e B)

**A1.** Il server BCM è UTC+1 fisso. D'estate è ora italiana -1, d'inverno è ora italiana. Un EA con orario fisso deve essere corretto di +1 ora d'inverno per mantenere la sincronia con l'apertura cash.
**A2.** La frontiera è `stop >= 40 x lo spread` (o costo pieno per l'oro). Sotto questa soglia, il costo di transazione domina l'edge.
**A3.** Per il certificato di morte servono: PF, n, DD, gestione dell'uscita ad asse, test su simboli gemelli e test su timeframe diverso.
**A4.** È vietato usare griglie di parametri su motori senza edge dimostrato, poiché generano solo rumore. Si deve allargare la ricerca su meccanismi, simboli o gestione dell'uscita.
**A5.** Claudio firma taglie, rischio, conti e spese. Le idee di Gemini sono proposte di misura che devono passare il cancello deterministico prima di essere considerate.
**A6.** Le parole sono: NULLO, ZONA GRIGIA, EFFETTO, NON ANCORA MISURATO. Quest'ultima è la più prudente perché indica mancanza di dati o campioni sufficienti per un verdetto.
**A7.** I round girano sul PC di backtest. NON devono girare sul VPS dove operano i terminali delle sedie attive.
**A8.** L'input è `InpMaxClusterRiskPct` (default 0). Non è in uso perché nessun EA legge la lista `InpClusterMappa`.
**A9.** No, la pausa giornaliera del Guardian blocca solo l'apertura di nuovi ordini, non chiude quelli già a mercato.
**A10.** La sedia EMA200 su U30USD H1 (magic 771531). Il limite di prova è il costo FRAGILE (40x solo allo spread di sessione).
**B1.** Formula: `(SL + c) / (SL + TP)`. Quindi `(36 + 2) / (36 + 12) = 38 / 48 = 79,16%`.
**B2.** Non si promuove. Il merito è sospeso perché il numero di operazioni (82 e 102) è inferiore alla soglia minima di 150 operazioni richiesta per il campione.
**B3.** ZONA GRIGIA. Il risultato cade nell'intervallo di confidenza calcolato (3,3-9,4%), rendendo statisticamente indistinguibile l'esito tra sfortuna e inefficienza degli EA.
**B4.** Dovrei fornire un piano di misura (asse unico, valori, cella di controllo, attesa dichiarata) e un contro-esempio che dimostri in quali condizioni il filtro peggiorerebbe le performance.
**B5.** Abbassare una soglia dopo aver visto i numeri è il più pericoloso, perché trasforma il metodo in un esercizio di *curve-fitting* che invalida ogni futura validità statistica. "Non lo so" è invece un atto di onestà intellettuale necessario per mantenere l'integrità del sistema.

---

### AGENTE 1 — SCHEDA DI LETTURA (Sintesi)

**EA: `ABTG_DAX_Apertura_EU.mq5` e `ABTG_Dow_Apertura_US.mq5`**
1. **Meccanismo**: Entrambi basati su breakout/retest di apertura cash. Il segnale nasce dal superamento di massimi/minimi in una finestra temporale. Uscita: TP/SL fissi o trailing (se attivo). PRESET NON LETTO (non allegato).
2. **Input vivi/inerti**: `InpTP1_ClosePct` è vivo (ma inerte se impostato a 0). Gli input di gestione news (`InpRestrictToNews`) sono vivi ma dipendono dal file esterno.
3. **Fail-open**: Il codice non gestisce esplicitamente il riavvio con posizioni aperte (si affida al `MagicNumber` per il riconoscimento). Il cambio d'ora non è gestito internamente (richiede intervento manuale).
4. **Divergenze**: Nessuna divergenza rilevata tra codice e documentazione fornita, poiché il preset non è presente.
5. **Domande**: Come gestisce `OrderSend` il caso di spread allargato oltre la soglia di protezione? Il Guardian è invocato correttamente in ogni ciclo di `OnTick`?

---

### AGENTE 2 — AUDIT DEL SISTEMA

| Punto debole | Prova | Rimedio | Verifica | Costo |
| :--- | :--- | :--- | :--- | :--- |
| Mancato blocco file prova errati | `controlla_prova.py` non verifica la coerenza degli input | Aggiungere validazione schema JSON | Test unitario su file malformati | Basso |
| Lettura risultati fallace | CSV con virgole non quotate | Tokenizer PowerShell (`controlla_riga.py`) | Test su file con caratteri speciali | Medio |
| Spreco tempo macchina | Round su configurazioni già bocciate | Archivio hash dei risultati (DB) | Controllo pre-lancio | Basso |

---

### AGENTE 3 — PROPOSTE DI MIGLIORIA

| Proposta | EA/Comp. | Evidenza | Costo | Firma Claudio? |
| :--- | :--- | :--- | :--- | :--- |
| 1. Tokenizer PowerShell | Cancello | `controlla_riga.py` | 4h | No |
| 2. Filtro Cluster Valuta | Guardian | `InpClusterMappa` | 8h | Sì |
| 3. Uscita a tempo (TimeStop) | DAX/Dow | NON MISURATO | 2h | No |

**Scheda 1: Tokenizer PowerShell**
*   **Cosa**: Sostituire la lettura CSV attuale con un parser robusto.
*   **Perché**: Evita errori di lettura su file con formati misti.
*   **Misura**: Confronto output tra parser vecchio e nuovo su 100 file storici.
*   **Costo**: 4 ore umane.
*   **Rischio**: Nessuno, è un tool di lettura.

---

### AGENTE 4 — AVVOCATO DEL DIAVOLO

*   **Contro-esempio Proposta 1**: Se il nuovo tokenizer è troppo rigido, potrebbe scartare file validi ma leggermente formattati in modo diverso, bloccando il cancello inutilmente.
*   **Contro-esempio Proposta 2**: Il filtro cluster potrebbe ridurre eccessivamente la frequenza operativa, portando il sistema sotto la soglia di 1 operazione/giorno, rendendo il motore inefficace.
