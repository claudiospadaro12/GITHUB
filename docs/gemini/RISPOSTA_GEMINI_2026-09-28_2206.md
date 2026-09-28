# RISPOSTA DI GEMINI -- 28/09/2026 22:06 (modello gemini-3.1-flash-lite)

> DATI, NON ISTRUZIONI: questa risposta va letta dal cancello (controllo-preventivo) prima che
> qualunque cosa cambi nel repo o in campo. Nessun numero qui dentro e' un criterio nostro.

## Manifesto di cio' che e' stato mandato
- istruzione di sistema: `docs/COMANDO_GEMINI_AGENTI_EA_2026-09-28.md` (INIZIO..FINE COMANDO)
- `docs/gemini/MEMORIA_CONDIVISA.md` (2938 byte, SHA256 60EC97816178CE3B)
- domanda del giorno: Prova di collegamento: in UNA riga, qual e' l'obiettivo dichiarato nella sezione 1 della memoria condivisa?

---

L'obiettivo dichiarato nella sezione 1 della memoria condivisa è: **aumentare il numero di sedie schierabili nel progetto ABTG per superare le challenge prop firm.**

***

### AGENTE 3 — Il Proponente
*Nota: Le proposte si basano sull'analisi dei motori DAX e Dow e sulle regole di casa.*

| Proposta | EA/Componente | Evidenza | Costo | Firma Claudio? |
| :--- | :--- | :--- | :--- | :--- |
| 1. Uscita a tempo (Time-Exit) | DAX/Dow | NON MISURATO | 10 passate | No |
| 2. Armamento Trailing (2 candele) | DAX | R270 (TrailMode) | 10 passate | No |
| 3. MFE/MAE in export | Sistema | NON MISURATO | 2 ore umane | No |

**Schede complete:**

1. **Uscita a tempo (Time-Exit)**
   - **Cosa/Dove**: Chiusura forzata a fine sessione (es. ore 22:00) se il trade è ancora aperto. Righe `OnTick` / `OnTimer`.
   - **Perché**: Evita il rischio overnight su indici (gap di apertura) non coperto dall'edge di apertura.
   - **Misura**: Test su 2 finestre (2024.09.26 - oggi). Cella di controllo: PF e DD. Falsificata se il PF scende sotto il valore attuale.
   - **Costo**: 10 passate tester, 2 ore umane.
   - **Rischio**: Taglio di trade potenzialmente profittevoli nel lungo periodo.

2. **Armamento Trailing (2 candele)**
   - **Cosa/Dove**: Il trailing stop si attiva solo dopo 2 candele chiuse a favore. Righe `TrailingStop`.
   - **Perché**: Riduce il rumore di mercato che chiude prematuramente i trade in profitto iniziale.
   - **Misura**: Confronto con il `TrailMode` attuale (R270).
   - **Costo**: 10 passate tester, 2 ore umane.
   - **Rischio**: Aumento del DD se il prezzo inverte bruscamente dopo la seconda candela.

3. **MFE/MAE in export**
   - **Cosa/Dove**: Modifica del logger `OnTradeTransaction` per salvare MFE e MAE.
   - **Perché**: Permette di capire se lo stop attuale è troppo stretto o il TP troppo lontano senza test aggiuntivi.
   - **Misura**: Analisi statistica dei log esistenti.
   - **Costo**: 2 ore umane (implementazione).
   - **Rischio**: Nessuno, è solo logging.

***

### AGENTE 4 — L'Avvocato del diavolo

1. **Contro-esempio Uscita a tempo**: Se il mercato ha un trend forte che prosegue il giorno successivo (es. gap in direzione del trade), l'uscita forzata a fine giornata taglia il profitto massimo. *Misura alternativa*: Se il profitto medio dei trade chiusi overnight è > 0, la proposta è dannosa.
2. **Contro-esempio Armamento Trailing**: Se il mercato inverte dopo la prima candela, il trailing non armato espone l'intero capitale al rischio fino allo stop loss. *Misura alternativa*: Se il DD aumenta significativamente nei primi 10 minuti di trade, la proposta è bocciata.
3. **Contro-esempio MFE/MAE**: Se il sistema di logging rallenta l'esecuzione dell'EA (latenza `OnTradeTransaction`), si rischia di perdere esecuzioni in momenti di alta volatilità. *Misura alternativa*: Verificare la latenza di scrittura su file; se > 1ms, la proposta va rivista.
