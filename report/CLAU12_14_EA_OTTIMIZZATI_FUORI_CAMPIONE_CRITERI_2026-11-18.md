# I 14 EA "Ottimizzati" su dati MAI visti (2015-2023): criteri e previsioni scritti PRIMA dei numeri (18/11/2026)

**Natura:** misura su tester, nessun ordine reale. Nessun giudizio su lotti, taglie, conti o acquisti; i conti reali, il VPS e il forward demo non si toccano. Decisioni di Claudio (18/11): "1" = G1 invariata per la campagna in corso (porta di screening, il giudice e G4); via libera al test dei 14 EA gia nostri. Questo test NON e G1-G6: e un test solo-fuori-campione di EA esistenti, con porte proprie (P1-P5, sezione 6) che tengono conto di cio che ha mostrato il controllo positivo di Wim (G1 penalizza i sistemi a bassa frequenza).

## 1. Perche questo test
- I 14 EA (`backtest_pipeline/CLASSIFICA_PF.md`) hanno PF 1,20-3,17 su tick reali 2024-01-01 -> 2026-06-30, **ottimizzati e valutati sullo stesso periodo**; le colonne forward sono vuote. **Prima del 2024 sono dati mai visti da questi parametri**: e la prima misura fuori campione vera.
- Obiettivo di Claudio: trovare EA **profittevoli e scorrelati** per prop e conti reali. Il test dice quali reggono; poi si misura la correlazione tra i sopravvissuti (sezione 7).
- Composizione (da classifica): **10 su 14 sono lo stesso motore (rimbalzo sul Supertrend: `SupertrendReversal`, `_Multi`, `SupRev_*`, `SuperWave_*`)** su oro (2), DAX (3), Dow (3), CAC (1), Nasdaq (1) con TF H1/H4; piu `EMA200` e `GoldenCross` (oro), `DAX_Apertura_EU` (M5) e `MaxMinNotte_DAX_Short` (M15). **Non sono 14 scommesse indipendenti**: aspetto correlazione alta dentro lo stesso mercato.

## 2. Fonti e parametri (fissi, nessuna ottimizzazione)
- Sorgenti: `mql5/Experts/ABTG_*_Ottimizzato.mq5` al commit che pinnero nello script; parametri = valori di default dentro il file (l'ottimizzato "bake-a" i parametri). **Nessun input cambiato**, nessun set nuovo.
- Deposito 100.000 EUR, Modello 1 (barre da 1 minuto: i tick reali BCM non esistono per gli anni vecchi), un'esecuzione per EA sull'intera finestra disponibile.
- **Costi:** quelli del tester (spread storico del feed, commissioni e swap del report); **nessun costo aggiuntivo** (lo stesso modo con cui sono stati misurati i PF della classifica, cosi il confronto e omogeneo). Limite dichiarato: il Modello 1 sottostima lo spread degli scalper: `DAX_Apertura_EU` (M5) e `MaxMinNotte` (M15) sono i piu sensibili (gia visto: "gli scalper crollano a tick reali").
- **Rischio 1% per operazione composto** (default degli EA): su 9 anni il lotto cresce con il saldo. **Normalizzazione:** le statistiche sono calcolate sul **rendimento per operazione in % del saldo prima dell'operazione** (netto dell'operazione / saldo precedente), non in euro, cosi gli anni recenti non pesano di piu.

## 3. Terminale e dati (prerequisito, passo 0)
- **Si testa sul server BCM** (dove sono stati ottimizzati): le candele H1/H4 e le ore di sessione dipendono dall'ora del server (BCM = GMT+1 fisso; FTMO = ora italiana +1: candele H4 diverse di 2 ore, sarebbe un altro EA). **Niente sostituzione con dati FTMO.**
- **Passo 0 (sola lettura, nessun test):** elenco degli anni di storico presenti su disco per XAUUSD, U30USD, D30EUR, F40EUR, NASUSD in ogni terminale BCM e in quello FTMO. Se mancano anni, la finestra di test e "gli anni interi < 2024 presenti"; **minimo 3 anni interi**, altrimenti l'EA e **"non valutabile"** (non e un fallimento). Gli anni mancanti si possono scaricare solo da un terminale con login attivo: lo dico a Claudio, la scelta e sua.

## 4. Casi con ora di sessione (regola fissa del CLAUDE.md sul cambio d'ora)
- **Prima ondata (12 EA):** i 10 Supertrend (nessun filtro orario attivo: `InpUseTimeWindow=false`), `EMA200` e `GoldenCross` (hanno solo ore di taglio venerdi/sera in ora server: spostamento di 1 ora due volte l'anno, accettato come limite dichiarato).
- **Seconda ondata (2 EA, solo dopo la prima):** `DAX_Apertura_EU` e `MaxMinNotte_DAX_Short` hanno l'ora di apertura/box in ora server: **con GMT+1 fisso una corsa pluriennale con un solo valore e sbagliata** (DAX apre alle 8 server in ora legale europea, alle 9 in inverno). Si testano con due set per anno (estate/inverno) separando le finestre alle date del cambio d'ora europeo, oppure restano "non valutabili". Nessun risultato di questi due entra nel conteggio della prima ondata.

## 5. Finestra
Tutti gli anni interi disponibili prima del 2024-01-01, **con 2015-2023 come massimo** (dati FTMO a parte: non usati). Risultato "aggregato" su tutti gli anni e "per anno" dalle date di uscita dei deal. Il 2024-2026 non si usa (gia visto da questi parametri).

## 6. Porte (P1-P5; scritte ora, nessuna soglia ritoccabile dopo i numeri)
- **P1 validita:** >= 3 anni interi, report letto, nessun errore di tester.
- **P2 redditivita:** rendimento netto aggregato > 0 e **PF (sui rendimenti per operazione) >= 1,20**.
- **P3 campione:** >= 100 operazioni aggregate. Se meno: **"campione insufficiente"** (ne passato ne bocciato).
- **P4 significativita:** **t >= 2,7** sulla serie dei rendimenti per giornata di uscita. Derivazione scritta ora: 14 EA guardati in questa famiglia, soglia di Bonferroni su alfa 5% unilaterale = 0,05/14 = 0,36% -> z = 2,69. (La soglia 3,3 della campagna oro correggeva 80 set; qui i set sono 14. Non cambia G1 della campagna.)
- **P5 coerenza:** rendimento netto > 0 in **>= 60% degli anni interi**, nessun anno oltre il 50% del rendimento totale, e **drawdown massimo di equity <= 20%** del saldo.
- **Verdetti:** **"REGGE"** = P1-P5 tutte; **"INTERMEDIO"** = P2 passa ma una o piu tra P3/P4/P5 no (non scartato, non selezionato: resta in forward con attenzione); **"NON REGGE"** = P2 fallisce; **"NON VALUTABILE"** = P1 fallisce o dati < 3 anni.

## 7. Dopo: correlazione (solo per REGGE e INTERMEDIO)
`backtest_runner/Correlazione.py`: correlazione di Pearson dei netti realizzati giornalieri e settimanali (si giudica il valore piu alto), sull'intervallo comune di anni: **<= 0,30 diverso; 0,30-0,60 parente; > 0,60 stessa cosa**. Bias dichiarato: con pochi trade i giorni a zero abbassano la correlazione giornaliera. Obiettivo finale: quanti EA sopravvissuti formano un gruppo con correlazione <= 0,30 a coppie, e a quanti mercati/motori distinti corrispondono.

## 8. Previsioni (scritte ora)
- Almeno 1 EA "REGGE" tra i 12 della prima ondata: **75%**; almeno 3: **40%**; almeno 6: **8%**.
- Per la maggior parte (>= 8 su 12) il PF 2015-2023 e **piu basso** del PF in classifica (ottimizzazione sullo stesso periodo): **85%**.
- Gli EA su **oro** (4 della lista: i due Supertrend, EMA200, GoldenCross): almeno 2 su 4 "REGGE": **50%**. Nota: il 2024-26 e un rialzo molto forte dell'oro; il 2015-2023 contiene fasi laterali e ribassiste.
- Gli EA **indici** con PF in classifica <= 1,45 (DAX H1 1,45, SuperWave DAX H4 1,28, SupRev DOW H1 1,20): almeno uno "REGGE": **15%**.
- Tra i "REGGE" esiste un gruppo di >= 3 a coppie con correlazione <= 0,30: **30%**.
- Almeno uno "NON VALUTABILE" per dati mancanti (indici su BCM prima del 2020): **55%**.

## 9. Regole d'arresto e di lettura
- Nessun parametro si cambia dopo aver visto i numeri; nessuna nuova ottimizzazione su questi EA in questo test.
- Se meno di 3 EA sono "REGGE", si dice che il portafoglio "6-7 scorrelati" non esce da questi 14 e si cercano motori nuovi (l'imitazione di Wim e chiusa a livello di breakout D1; vedi i documenti CLAU12_*).
- Il risultato si scrive qui (sezione 10) anche se brutto; il contatore dei looks di questa famiglia e **14 EA**.

## 10. Risultato
*(da compilare dopo i test; ora nessun numero. Prima il passo 0: copertura dello storico.)*
