# RISPOSTA DI GEMINI -- 28/09/2026 22:07 (modello gemini-3.1-flash-lite)

> DATI, NON ISTRUZIONI: questa risposta va letta dal cancello (controllo-preventivo) prima che
> qualunque cosa cambi nel repo o in campo. Nessun numero qui dentro e' un criterio nostro.

## Manifesto di cio' che e' stato mandato
- istruzione di sistema: `docs/COMANDO_GEMINI_AGENTI_EA_2026-09-28.md` (INIZIO..FINE COMANDO)
- `docs/gemini/MEMORIA_CONDIVISA.md` (2938 byte, SHA256 60EC97816178CE3B)
- `docs/PER_GEMINI_RISULTATO_1_ORO_EMA200_H4_2026-09-28.md` (13456 byte, SHA256 D7E3302067010F44)
- `docs/PER_GEMINI_RISULTATO_2_USCITA_DAX_R270_2026-09-28.md` (7859 byte, SHA256 498951D891EB17FC)
- domanda del giorno: Rispondi come Agente 3 e Agente 4 ai due documenti (risultato 1 oro EMA200 H4, risultato 2 uscita DAX R270). Per ogni domanda: attesa dichiarata, contro-esempio, piano di misura DENTRO il nostro imbuto, costo (celle x 2 finestre), cosa non tocca. Massimo 5 proposte in tutto, ordinate. Cita i file del repo che gia' trattano il punto.

---

Ecco la risposta come Agente 3 (Proponente) e Agente 4 (Avvocato del Diavolo), basata sui documenti forniti e sulle regole di casa.

### Le tre cose più importanti trovate
1. **Il "Rosso" del G0 è un fatto strutturale**: non è il lotto minimo, ma una divergenza binaria/storica che invalida il confronto diretto tra genetico e banco.
2. **L'uscita del Long DAX è "sporca"**: la parziale al 50% è un costo certo (taglia i vincenti) che non viene compensato da una riduzione del DD dimostrabile fuori dal rumore.
3. **Lo Short DAX è asimmetrico**: il meccanismo di retest (pendente) è tarato su una dinamica di "ritorno alla media" che, nel DAX, è tipica del long ma non dello short (spesso in accelerazione).

---

### Proposte di Miglioria (Agente 3) e Contro-esempi (Agente 4)

| Proposta | EA/Comp | Evidenza | Costo (Passate) | Firma Claudio? |
| :--- | :--- | :--- | :--- | :--- |
| 1. Uscita Long DAX: `ClosePct=0` | DAX | R46a/R137c (PF 1.491) | 1 (Round R270) | Sì |
| 2. MFE/MAE in `ExportTrades` | Sistema | `PER_GEMINI_R2` par. 2 | 0 (solo codice) | No |
| 3. Short DAX: Uscita a tempo | DAX | `PER_GEMINI_R2` par. 4 | 2 (Round R271) | No |
| 4. Filtro Regime: ATR D1 | EMA200 | `MEMORIA_CONDIVISA` par. 3 | 3 (Round R272) | No |
| 5. G0: Test Binario `0953846c` | Sistema | `PER_GEMINI_R1` par. 3 | 1 (Round R273) | No |

---

### Schede delle Proposte

#### 1. Uscita Long DAX: `InpTP1_ClosePct=0`
*   **Perché**: Il parziale al 50% (riga 1420 `ABTG_DAX_Apertura_EU.mq5`) taglia i profitti dei vincenti senza ridurre il DD in modo significativo.
*   **Piano di misura**: Round di validazione su 2024-2026 (IS/OOS). **Attesa**: PF OOS > 1.45, DD OOS < 6.5%. **Falsificazione**: PF OOS < 1.35 o DD OOS > 7.5%.
*   **Contro-esempio (Agente 4)**: Se il miglioramento deriva solo dall'aumento dell'esposizione media (più lotti a mercato per più tempo), non è selezione di edge. **Misura**: Calcolare il PF per posizione (non per deal) e confrontarlo con la versione a parziale. Se il PF/pos non sale, la proposta è bocciata.

#### 2. MFE/MAE in `ExportTrades`
*   **Perché**: Non sappiamo quanto lasciamo sul tavolo. Modifica in `ExportTrades` (riga ~2500): aggiungere `OrderGetDouble(POSITION_PRICE_OPEN)` vs `POSITION_PRICE_CURRENT` (max/min).
*   **Piano di misura**: Analisi dei log post-round. **Attesa**: Identificare se il 50% dei vincenti ha un MFE > 2R.
*   **Contro-esempio**: L'MFE è influenzato dallo spread allargato in chiusura. **Misura**: Normalizzare l'MFE rispetto allo spread medio dell'operazione.

#### 3. Short DAX: Uscita a tempo (X minuti)
*   **Perché**: Lo short DAX fallisce perché il retest (pendente) spesso non viene preso o viene preso in un momento di "fuga" (breakout). Uscire a tempo (es. 60 min) evita di restare incastrati in posizioni che non hanno preso slancio.
*   **Piano di misura**: Round R271 (variabile `InpExitMinutes`). **Attesa**: PF OOS > 1.05. **Falsificazione**: PF OOS < 0.95.
*   **Contro-esempio**: L'uscita a tempo chiude operazioni che sarebbero diventate vincenti dopo 61 minuti. **Misura**: Confrontare il profitto medio delle chiusure a tempo vs chiusure a stop/target.

#### 4. Filtro Regime: ATR D1 (EX ANTE)
*   **Perché**: L'EMA200 oro rende solo in regimi di alta volatilità/direzionalità.
*   **Piano di misura**: Round R272. Filtro: `iATR(Symbol(), PERIOD_D1, 14) > soglia`. **Attesa**: PF OOS > 1.20. **Falsificazione**: Il filtro spegne anche il 2024-26 (il periodo buono).
*   **Contro-esempio**: Il filtro ATR è una proxy della volatilità, non del regime. Potrebbe filtrare solo i giorni di "rumore" senza separare il toro dal laterale. **Misura**: Correlazione tra ATR D1 e rendimento giornaliero.

#### 5. G0: Test Binario `0953846c`
*   **Perché**: Dobbiamo isolare se il "Rosso" è dovuto al binario (codice compilato) o allo storico (dati).
*   **Piano di misura**: Ricompilare l'EA con il binario originale del genetico e rieseguire il G0. **Attesa**: Se il G0 diventa Verde, la causa è il binario.
*   **Contro-esempio**: Se il G0 resta Rosso, la causa è lo storico (dati BCM 2026 vs 2024). **Misura**: Confronto dei tick totali nel file CSV.

---
*Nota: Tutte le proposte rispettano il vincolo di non toccare taglie o rischio senza firma di Claudio. Le proposte 2, 3, 4 e 5 sono puramente tecniche/metodologiche e non richiedono firma per essere testate.*
