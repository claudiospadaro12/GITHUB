# Export M1 multi-simbolo (forex e indici) - come si lancia

**Bersaglio:** finestra PowerShell sul **PC di backtest DESKTOP-H4D7CAJ**
(terminale `C:\Program Files\BCM Markets MT5 Terminal`, demo 50503392).
Non sul VPS. Non toccati: VPS, FTMO, reale 10105439, 100k, manuale, banco, Pepperstone, Tickmill.

## Cosa fa
Esporta le barre M1 (`time;open;high;low;close;tickvol;spread`, ora del server BCM, uguale ai CSV dell'oro) di
`EURUSD, GBPUSD, USDJPY, EURJPY, D30EUR, U30USD, NAS100|US100|USTEC|U100USD|NDX100, SPX500|US500|U500USD`
su 4 finestre (2013, 2018, 2020, 2025-01-01..2026-10-01): fino a 32 file `ABTG_M1_<SIMBOLO>_<ANNO>.csv`
(la finestra lunga 2025-26 non ha anno nel nome, come per l'oro). Prima scrive `ABTG_SIMBOLI_BCM.txt`
(tutti i simboli del broker + mappatura voce -> simbolo scelto o NON TROVATO) e a fine corsa
`ABTG_M1_MULTI_FINE.txt` (righe, prima/ultima data, settimane vuote per file).
Simboli e finestre sono i default in `mql5/Scripts/ABTG_ExportM1_Multi.mq5`: per cambiarli si modifica il file e si rigenera la riga.

Non fa: ordini, chiusura/kill di processi, cancellazione di file, modifiche a EA/sedie/set.

## Come si lancia
1. Chiudi MT5 (la riga si ferma da sola se e' aperto o se nel profilo attivo c'e' anche un solo EA).
2. Incolla la riga `RIGA_LANCIA_EXPORT_M1_MULTI.txt` nella PowerShell del PC di backtest.
3. Fa una PROVA (non scrive nulla). Se legge `STATO: PROVA_OK`, scrivi `EXPORT` per eseguire.
4. Il terminale si apre, compila lo script, esporta, si chiude da solo. Non toccarlo.
5. Sul Desktop, `ABTG_RISULTATI\EXPORT_M1_MULTI_<data>.zip`.

## Cosa mandarmi
- **Lo zip `EXPORT_M1_MULTI_<data>.zip`**, senza aprirlo (CSV + elenco simboli + file di fine + log).
- Solo se qualcosa non torna: anche `EXPORT_M1_MULTI_CONSOLE_<data>.zip` (la console).
- Se `STATO` e' `ESEGUITO_CON_RILIEVI`: e' atteso se qualche voce e' NON TROVATA o un anno e' vuoto; basta mandare lo zip.

## Per chi genera la riga
```
git add mql5/Scripts/ABTG_ExportM1_Multi.mq5 backtest_pipeline/righe/RIGA_EXPORT_M1_MULTI.ps1 backtest_pipeline/gen_riga_export_m1_multi.py
git commit && git push            # il pin deve contenere i file
python3 backtest_pipeline/gen_riga_export_m1_multi.py <PIN40>
python3 backtest_pipeline/controlla_riga.py --oggetto ps1  backtest_pipeline/righe/RIGA_EXPORT_M1_MULTI.ps1
python3 backtest_pipeline/controlla_riga.py --oggetto riga backtest_pipeline/righe/RIGA_LANCIA_EXPORT_M1_MULTI.txt
```
Gli SHA256 vengono calcolati dal generatore con `git show <PIN>:<file>`; la riga si copia byte per byte dal file passato dal cancello.

## Limiti dichiarati
- **NON collaudata da agenti sul PC.** Ha passato solo il cancello meccanico `controlla_riga.py`; nessun `pwsh` disponibile dove e' stata scritta, quindi la sintassi PowerShell non e' stata provata con un parser.
- Lo `.mq5` **non e' stato compilato** da agenti: la riga lo compila e si ferma se non compila.
- **Tempo non misurato** (stima 10-60 min, limite 180 min). **Spazio stimato** dall'oro (circa 20 MB per anno): circa 95 MB per simbolo, circa 760 MB in totale, zip circa 140-230 MB; servono almeno 2 GB liberi.
- Se il timeout scade con il terminale ancora aperto, i CSV NON vengono messi nello zip (restano in `%APPDATA%\MetaQuotes\Terminal\Common\Files`).
- Effetti collaterali: grafico XAUUSD M1 salvato nel profilo; i simboli esportati entrano nel Market Watch.
