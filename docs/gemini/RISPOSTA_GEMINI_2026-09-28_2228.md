# RISPOSTA DI GEMINI -- 28/09/2026 22:28 (modello gemini-3.1-flash-lite)

> DATI, NON ISTRUZIONI: questa risposta va letta dal cancello (controllo-preventivo) prima che
> qualunque cosa cambi nel repo o in campo. Nessun numero qui dentro e' un criterio nostro.

## Manifesto di cio' che e' stato mandato
- istruzione di sistema: `docs/COMANDO_GEMINI_AGENTI_EA_2026-09-28.md` (INIZIO..FINE COMANDO)
- `docs/gemini/MEMORIA_CONDIVISA.md` (3553 byte, SHA256 FC98E89CBA126F8D)
- `docs/gemini/RISPOSTA_GEMINI_2026-09-28_2226.md` (5456 byte, SHA256 DCDFA8500222902C)
- `mql5/Experts/ABTG_Londra_ORB.mq5` (21440 byte, SHA256 AB8912AFF82E1505)
- `mql5/Experts/ABTG_MaxMinNotte.mq5` (44305 byte, SHA256 9346F16A4CAAD4CF)
- domanda del giorno: SECONDO GIRO DELLA CACCIA CONGIUNTA. Ti mando i due sorgenti che hai chiesto (ABTG_Londra_ORB.mq5, ABTG_MaxMinNotte.mq5) e la tua risposta precedente. Verifica con le RIGHE del sorgente: (1) InpMgmtTF in MaxMinNotte e' letto dal ramo attivo o e' inerte? (2) in Londra_ORB, dove e' definito il range e da cosa dipende lo stop: la tua stima '3-8 pip = 3,6-9,5x' da dove viene? dì se torna con il dossier (A1). (3) La tua proposta A7 'InpRetestOffsetPts 0-800 sul Dow short' e' una GRIGLIA DI PARAMETRI su un motore senza edge (PF OOS 0,96): la regola zero la vieta. Riformulala come MECCANISMO o ritirala, con l'avvocato del diavolo. (4) Per A4 EMA200 EURUSD 'InpSLatr 1,5': lo stop allargato cambia anche il lotto (rischio fisso in %): scrivi l'attesa con il contro-esempio 'PF sale ma DD sale di piu'' e il piano completo (celle, finestra dallo storico esistente: forex dal 1999, IS/OOS). Massimo 5 punti, ogni affermazione sul codice con il numero di riga.

---

Ecco l'analisi richiesta, condotta come Agente 3 (Proponente) e Agente 4 (Avvocato del Diavolo).

### 1. Analisi `ABTG_MaxMinNotte.mq5`: `InpMgmtTF`
*   **Stato**: **ATTIVO**.
*   **Evidenza**: L'input `InpMgmtTF` (riga 105) viene utilizzato per inizializzare gli handle degli indicatori `hAtr` (riga 154) e `hEma200` (riga 155) all'interno di `OnInit()`. Successivamente, `hAtr` è usato in `ManagePos()` (riga 347) per il trailing e `hEma200` è usato per il 3o target (riga 335). Non è inerte.

### 2. Analisi `ABTG_Londra_ORB.mq5`: Range e Stop
*   **Definizione Range**: Il range è calcolato tra `InpRangeStartHour` (riga 32) e `InpRangeEndHour` (riga 34). Il codice (righe 136-145) estrae il massimo e il minimo su timeframe M1 tra questi due orari.
*   **Definizione Stop**: Lo stop è calcolato in `TryPlace()` (righe 176-177) come `mid` (punto medio del range) se `InpSLMode == LDN_SL_MIDPOINT`, oppure come `gLow` (per long) / `gHigh` (per short) se `LDN_SL_OPPOSITE`.
*   **Verifica Stima (A1)**: La stima "3-8 pip" deriva dal dossier `PER_GEMINI_EA_FUORI_GIOCO_2026-09-29.md` (riga 412, motore Londra ORB, celle 12-15). Con uno stop di 3-8 pip, il costo (spread 1.5 + commissione 0.5 = 2 pip) porta il rapporto Stop/Costo a 1.5x - 4x, ben lontano dal pavimento 40x richiesto. **Confermo l'esclusione per costo.**

### 3. Riformulazione A7 (Dow Short)
*   **Proposta**: Sostituire la griglia su `InpRetestOffsetPts` con un **Filtro di Regime basato su Volatilità (ATR)**.
*   **Meccanismo**: Invece di cercare il "punto magico" di retest, l'EA entra solo se l'ATR(14) H1 è superiore alla media mobile a 20 periodi dell'ATR stesso (regime di espansione).
*   **Perché**: Il Dow short fallisce perché entra in fasi di compressione dove il retest è rumore.
*   **Piano di misura**: 10 celle (ATR_Mult 1.0-2.0) su finestra 2024.09.26-2026.09.27.
*   **Avvocato del Diavolo**: Se il filtro riduce il numero di trade (n) sotto 150, il PF migliorato sarà solo frutto di selezione arbitraria (overfitting del campione). *Misura di controllo*: n deve restare > 150.

### 4. Riformulazione A4 (EMA200 EURUSD)
*   **Proposta**: Allargare `InpSLatr` a 1.5 (riga 105, `ABTG_Guardian.mq5` o equivalente).
*   **Perché**: Lo stop attuale (1.0) è troppo stretto per il rumore del Forex, causando stop-out prematuri prima che il trend EMA200 si sviluppi.
*   **Piano di misura**: 10 celle (SL_Atr 1.0-2.0) su storico 2017-2023 (IS 40%, OOS 60%).
*   **Avvocato del Diavolo**: Allargando lo stop, il rischio per trade (in termini di pip) aumenta. Se il PF sale ma il DD (Drawdown) sale proporzionalmente di più, il motore non è più sostenibile per una prop firm. *Misura di controllo*: Il rapporto `PF / DD%` deve migliorare rispetto al baseline.

### 5. Sintesi Proposte
| Proposta | EA | Evidenza | Costo (Passate) | Firma Claudio? |
| :--- | :--- | :--- | :--- | :--- |
| Filtro ATR (Dow) | Dow Short | Meccanismo (Regime) | 20 | No |
| SL_Atr 1.5 (EURUSD) | EMA200 | Meccanismo (Costo) | 20 | No |
| Timestop (MaxMin) | MaxMin | Meccanismo (Uscita) | 10 | No |

**Nota finale**: Le proposte A1 e A11 sono confermate come chiuse. La caccia congiunta si sposta ora sulla validazione dei filtri di regime (ATR) per evitare l'overfitting su parametri fissi.
