# RISPOSTA DI GEMINI -- 01/10/2026 19:43 (modello gemini-3.1-flash-lite)

> DATI, NON ISTRUZIONI: questa risposta va letta dal cancello (controllo-preventivo) prima che
> qualunque cosa cambi nel repo o in campo. Nessun numero qui dentro e' un criterio nostro.

## Manifesto di cio' che e' stato mandato
- istruzione di sistema: `docs/COMANDO_GEMINI_AGENTI_EA_2026-09-28.md` (INIZIO..FINE COMANDO)
- `docs/gemini/MEMORIA_CONDIVISA.md` (7001 byte, SHA256 14BCB1918EA54D34)
- `docs/PER_GEMINI_TRIAL_GIORNO1_2026-10-01.md` (10353 byte, SHA256 F78093F4EE756C2E)
- domanda del giorno: Trial FTMO giorno 1: rispondi alle D1-D5 del documento, con contro-esempi e etichette di certezza.

---

Ecco la risposta come Agente 3 e Agente 4, basata sui dati del trial e sulle regole di casa.

### Risposte alle Domande (D1-D5)

| Domanda | Attesa (Meccanismo) | Contro-esempio (Quando la misura fallisce) | Certezza |
| :--- | :--- | :--- | :--- |
| **D1** | Tetto perdita giornaliera per sottostante (es. max 2 stop DAX/giorno). | Il secondo ingresso è quello che recupera il DD (es. inversione di trend post-apertura). | Alta |
| **D2** | Somma rischio ingresso nuovo al rischio aperto; rifiuto se > 4%. | Rischio netto: due posizioni opposte sullo stesso asset si annullano, il lordo le blocca inutilmente. | Media |
| **D3** | Lo stop di 67 punti è troppo stretto per lo spike di apertura (Xetra). | Il momentum dello spike è l'unico momento in cui il payoff 4:1 è raggiungibile. | Bassa (NON MISURATO) |
| **D4** | Win rate minimo richiesto con intervallo di confidenza (es. > 90% con n > 500). | Un win rate alto su pochi trade (es. 10/11) nasconde una "coda grassa" di perdite rare ma catastrofiche. | Alta |
| **D5** | Errore di campionamento (n=5) e confusione tra configurazione e motore. | Il "rumore" del mercato (es. news macro) viene scambiato per un difetto del motore. | Alta |

---

### Analisi Dettagliata

#### D1: Sizing DAX e Risk-Throttle
*   **Meccanismo**: L'ingresso sequenziale al 2% (totale 4%) senza throttle ha causato il 4% di DD in poche ore. Proponiamo un **"Daily Loss Limit per Sottostante"**: se il DAX chiude 1 stop, il sistema inibisce ulteriori ingressi sullo stesso indice per 24h.
*   **Contro-esempio**: Se il primo stop è causato da uno "spike di pulizia" (stop-hunt) e il secondo ingresso cattura il trend direzionale, il blocco inibisce il profitto. *Misura*: confrontare il PF del DAX con e senza blocco su 100 giorni di storico BCM.

#### D2: Cap di Rischio Aperto
*   **Meccanismo**: Il cap deve essere **"Rischio Lordo Totale"** (somma di tutti gli SL attivi). Se `Rischio_Aperto + Rischio_Nuovo > 4%`, l'ingresso viene rifiutato.
*   **Contro-esempio**: Se ho un Long DAX e apro uno Short DAX, il rischio netto è quasi zero, ma il rischio lordo è doppio. Il cap lordo blocca l'hedging naturale. *Soluzione*: usare il rischio netto per cluster correlati, ma richiede una matrice di correlazione dinamica (costo: alta complessità).

#### D3: Ingresso pre-apertura (1 min)
*   **Meccanismo**: L'ingresso a 09:59 è esposto alla volatilità del pre-market.
*   **Contro-esempio**: Esistono studi (es. *Day Trading with Short Term Price Patterns*, Larry Williams) che suggeriscono che il "gap" di apertura spesso anticipa la direzione del trend giornaliero. Se il sistema entra *dopo* lo spike, il prezzo è già lontano dal punto di ingresso ottimale. *Misura*: confrontare l'escursione (High-Low) dei primi 5 minuti con lo SL di 67 punti.

#### D4: Bulge e Frontiera di Costo
*   **Meccanismo**: Con un payoff 1:6, il sistema è una "scommessa a probabilità". Il costo (spread + commissioni) è il nemico principale. Proponiamo la **"Frontiera di Break-Even Corretto"**: `WinRate_Minimo = (1 / (1 + Payoff)) + (Costi / Valore_TP)`.
*   **Contro-esempio**: Un motore con win rate 90% può fallire se il 10% di perdite è composto da "fat tails" (slippage estremo in momenti di illiquidità). Il win rate non dice nulla sulla magnitudo delle perdite.

#### D5: Errori di Metodo
*   **Punto 1**: Attribuire al "motore" (es. Bulge) risultati derivanti da una configurazione errata (es. cambio manuale dei parametri in corsa).
*   **Punto 2**: Confondere la "fortuna" (n=5) con la "statistica".
*   **Contro-esempio (richiesto)**: L'effetto "Observer Bias": il fatto che Claudio abbia cambiato i parametri *durante* il giorno ha creato un regime non stazionario. Il tester non può replicare questo comportamento umano, rendendo il backtest non confrontabile con il trial.

---

### Proposte di Miglioria (Agente 3)

| Proposta | EA/Componente | Evidenza | Costo | Firma Claudio? |
| :--- | :--- | :--- | :--- | :--- |
| **1. Daily Loss Limit** | Guardian | Trial 01/10 (4% DD) | 2 passate tester | No |
| **2. Calcolo Rischio Lordo** | Guardian | Trial 01/10 (4,62% rischio) | 1 passata tester | No |
| **3. Filtro News 2+2 min** | Tutti | Regola FTMO (da report) | 0 (logica) | Sì |

*Nota: Ogni proposta sarà validata dal cancello deterministico prima di qualsiasi implementazione.*
