# Simulatore Python (Binario C): criteri e previsioni scritti PRIMA dei numeri (18/11/2026)

**Natura:** strumento di lavoro, non un EA. Nessun ordine, nessun giudizio su lotti, taglie, conti o acquisti. Decisione di Claudio (18/11): "Sì, parti col simulatore Python". **MT5 resta il giudice finale:** il simulatore serve a scartare presto le idee, non ad approvarle. Un candidato approvato dal solo simulatore non esiste. Continua `PIANO_DUE_BINARI_2026-11-16.md` (Binario C); qui si fissa quello che manca e si emenda **una** scelta.

## 1. Emendamento al piano del 16/11: il banco di prova
Il piano scriveva "banco di prova: `ABTG_EMA200` su EURUSD H4". **Lo cambio, prima di qualsiasi numero:** primo banco = **`Template_EA_Wim` v1.04 sull'oro D1, dati FTMO** (disegno 3). Motivi, tutti verificabili:
1. La logica la conosco esattamente (l'ho scritta io): ogni differenza e un difetto del simulatore, non un'incognita dell'EA.
2. I riferimenti MT5 esistono gia, con numeri esatti: **9 set sul 2015-2020** (`CLAU12_ORO_DISEGNO3_dati/RISULTATI_BATCH9_DISEGNO3_FTMO.csv`: operazioni, netto, PF, DD) e la **lista completa degli ordini e dei trade di 2 set su gen-mar 2019** (`RIEPILOGO_CONTROLLO_DISEGNO3_MT5_riferimento.txt`: 14 trade, 64 ordini, con prezzi e orari). Non servono nuove passate MT5.
3. La strategia e chiusa ("nessun candidato"): usarla come banco non porta a nessuna scelta di investimento ne a nuovi "looks".
**EMA200 su EURUSD H4 resta il secondo banco**, solo se il primo supera la calibrazione. Se il primo non e calibrabile, non si estende (stessa regola del piano).

## 2. Dati
- **Calibrazione:** barre M1 **del terminale FTMO stesso** (stesso feed del tester MT5): XAUUSD e EURUSD (EURUSD serve a convertire in EUR il P&L in dollari). Formato `time;open;high;low;close;tickvol;spread`, ora del server FTMO. Il simulatore NON usa dati di un altro feed per la calibrazione: i dati esterni (HistData/Dukascopy, gia sul PC: vedi `BUSCA_STORICO_INDICI_ORO_2026-11-18.txt`) hanno prezzi e orari diversi e confonderebbero l'errore del simulatore con l'errore del dato.
- **Fase 1 (piccola):** 2018-11-01 -> 2019-04-02 (prima della finestra servono ~40 giorni D1 per ATR e livelli). **Fase 2 (grande, solo se la 1 passa):** 2015-01-01 -> 2020-12-31 per anno (circa 22 MB per anno; stima, non misurata).
- Dopo la calibrazione, per **nuove idee** si possono usare i dati esterni gia presenti (oro M1 HistData 2018-2025, DAX D30EUR M1 2019-2026, Nasdaq M1 2010-2026) **solo come filtro**, con la conferma in MT5 su dati del broker.

## 3. Cosa modella il simulatore (e cosa no)
Modella: barre M1 con la regola OHLC di MT5 (ipotesi da verificare: barra rialzista O-L-H-C, ribassista O-H-L-C), prezzi bid/ask con lo spread della barra, ordini stop con scadenza (arrotondata alla mezzanotte come nel tester), rifiuto 10018 a mercato chiuso e riarmo alle 01:05 (ora server), un solo trade alla volta con cancellazione dell'ordine opposto, SL/TP in % del prezzo, filtro fake breakout su H1/H4, commissione per deal, swap per notte con tripla al mercoledi (**2 parametri, long e short, stimati dai deal del riferimento di fase 1 e poi congelati**), conversione USD->EUR con EURUSD, lotto fisso 0,1. **Non modella:** tick reali, slippage, margine e stop out, regole del broker sulla distanza minima degli ordini (non servono con questo EA).

## 4. Porte di calibrazione (scritte ora, nessuna allargabile)
- **Fase 1 (trade per trade, 2 set x gen-mar 2019):** (a) stessi trade: **14 su 14** con stesso verso e stesso tipo di uscita (SL, TP, FBF, fine test); (b) ordine di ingresso e prezzi di SL/TP **identici al centesimo** in almeno **95%** degli ordini piazzati; (c) orari di ingresso e uscita entro **1 minuto** in almeno **13 su 14** trade; (d) P&L per trade entro **2%** o 0,30 EUR (il maggiore).
- **Fase 2 (insieme, 9 set x 2015-2020):** per **ciascuno dei 9 set** operazioni entro **±2%**, profitto del tester entro **±3%**, PF del tester entro **±0,05**, correlazione dei profitti giornalieri **>= 0,98** (serie MT5 in `DISEGNO3_BATCH9_FTMO\\serie` sul Desktop di Claudio: da allegare; se non arrivano, la correlazione resta "non misurata" e **non si dichiara la calibrazione completa**).
- **Regola d'arresto:** al massimo **2 giri di correzione** dopo il primo confronto; se al terzo non si e dentro le soglie: **"simulatore non calibrabile per questo EA"**, si scrive e si ferma. Nessuna soglia allargata per farlo passare; nessun parametro "libero" oltre i 2 dello swap.

## 5. Previsioni (scritte ora)
- Il primo tentativo passa la fase 1: **25%** (il piano diceva 70% di sbagliare: lo confermo; i candidati difetti sono arrotondamenti, spread, regola OHLC e scadenze).
- Passa la fase 1 entro 2 correzioni: **65%**.
- Se passa la fase 1, passa la fase 2 entro 2 correzioni: **55%**.
- La regola OHLC "rialzista O-L-H-C / ribassista O-H-L-C" e quella giusta al primo tentativo: **60%**.
- Il simulatore a calibrazione completa e almeno **50 volte piu veloce** di MT5 per una passata D1 6 anni: **90%** (MT5 impiega circa 2-4 minuti per set).

## 6. Uso dopo la calibrazione (regole scritte ora)
Solo come **pre-filtro**: griglia ampia in Python, i migliori N (al massimo 10) vanno in MT5 (Modello 1) con le porte gia scritte (G1-G6 o P1-P5 a seconda della famiglia), poi a tick. Il contatore dei "looks" conta **anche i set provati in Python**: il simulatore non rende i test gratis dal punto di vista statistico. Ogni nuova famiglia di idee ha criteri scritti prima.

## 7. Cosa serve da Claudio
1. Lanciare l'esportazione FTMO della fase 1 (riga in `report/RIGA_EXPORT_M1_FTMO.txt`) e allegare lo zip `EXPORT_M1_FTMO_<data>.zip`.
2. Solo per la fase 2: allegare le serie giornaliere MT5 e, se il limite di allegato lo consente, i CSV 2015-2020. Prima si prova che lo zip piccolo passa.

## 8. Risultato
*(da compilare; nessun numero ancora)*
