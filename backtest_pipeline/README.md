# Ottimizzazione automatica degli EA sul VPS

Pipeline per ottimizzare **tutti gli Expert Advisor** in automatico dentro MT5,
sul VPS, e trovare i parametri migliori. Tu lanci **un solo script**; io analizzo
i risultati e creo gli EA `_Ottimizzato` con i parametri già dentro.

## Come funziona (5 fasi)

| Fase | Chi | Cosa |
|------|-----|------|
| 1. Preparazione | **io (fatto)** | Ho reso ogni EA *self-contained* (blocco OptFrame incluso dentro: NON serve più `OptFrame.mqh` nella cartella Include) e ho scelto i 2–3 parametri da ottimizzare per ciascuno, con i range sensati. |
| 2. Config | **io (fatto)** | `ea_config.json` + generatore `.ini` + launcher `run_all.ps1`. |
| 3. Esecuzione | **tu** | Lanci `run_all.ps1` sul VPS. Compila tutto, ottimizza ogni EA uno alla volta, salva i CSV. |
| 4. Analisi | **io** | Mi mandi la cartella `risultati_ottimizzazione`; con `optimizer/batch_analyze.py` scelgo il set robusto (no picco/overfit). |
| 5. Consegna | **io** | Creo `ABTG_*_Ottimizzato.mq5` con i parametri migliori già nelle impostazioni di default. |

## Cosa devi fare tu (una volta)

1. Apri `run_all.ps1` e controlla i **3 percorsi** in cima:
   - `$DataFolder` = cartella dati del terminale MT5 del VPS (quella con hash `215D85D7...`).
   - `$Terminal` / `$MetaEditor` = dove è installato MT5 (`terminal64.exe`, `metaeditor64.exe`).
2. Controlla in `ea_config.json` che i **simboli** (`DAXEUR`, `NASUSD`, `XAUUSD`, `EURUSD`, `GBPUSD`) combacino con i nomi nella tua **Market Watch BCM**. Se un nome è diverso, correggilo lì.
3. Lancia:
   ```powershell
   powershell -ExecutionPolicy Bypass -File run_all.ps1
   ```
4. A fine corsa, comprimi la cartella `risultati_ottimizzazione` (i file `OptResults_*.csv`) e mandamela.

> ⚠️ Fallo sul terminale di **test**, non su quello che opera in live. L'ottimizzazione
> apre e chiude il terminale più volte: non deve disturbare gli EA che girano H24.

## Dettagli tecnici

- **Criterio di ottimizzazione**: Recovery Factor (robusto), calcolato in `OnTester`.
- **Modello prezzi**: *1 minute OHLC* (`Model=1`) — buon compromesso velocità/fedeltà.
- **Export**: ogni EA scrive `MQL5\Files\OptResults_<EA>_<Symbol>.csv` (colonne uguali
  all'export XML del tester) grazie al blocco OptFrame inlinato — leggibile da
  `optimizer/batch_analyze.py`.
- **Anti-overfit**: non prendo il singolo "picco". Scelgo il set su un *plateau* stabile
  e lo confermo in avanti (il tuo demo in forward è la vera validazione, visto che lo
  storico dati su alcuni indici è corto).
- **Il rischio % NON si ottimizza**: resta al valore del piano (money management).
  Ottimizzo solo i parametri che generano l'edge (range, buffer, stop/target, filtri).

## File

- `ea_config.json` — quali parametri e range per ogni EA (modificabile).
- `gen_ini.py` — genera gli `.ini` del tester in `ini/`.
- `run_all.ps1` — il launcher unico da eseguire sul VPS.
- `ini/` — configurazioni tester generate (una per EA).
- `risultati_ottimizzazione/` — dove finiscono i CSV dopo la corsa (da mandarmi).

## Il concetto anti-overfitting in una frase

> Non cerchiamo i parametri che hanno guadagnato di più **ieri** (li trova sempre,
> ed è un'illusione). Cerchiamo quelli che hanno funzionato in modo **stabile** e
> reggono anche **in avanti**, sul demo. Se reggono lì, hanno una possibilità in reale.
