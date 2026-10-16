# The Gold Reaper MT5 -- attese scritte PRIMA di avere un solo numero nostro (16/10/2026)

Cosa si prova: la versione DEMO del Market nel nostro Strategy Tester (XAUUSD, feed BCM, ticks reali, deposito 5.000 EUR, set di Claudio completato dai default dell'EA: gli input effettivi li scrive il REPORT). Mesi: luglio, agosto, settembre 2026 (gli stessi dell'Arena) + un mese fuori campione da scegliere prima di guardare.
Riferimenti DICHIARATI DA TERZI (recensione MQL5 del 14/10/2026, v4.6, 0,01 lotti per strategia, conto di riferimento 4.000 USD): profitto 9.578,50 USD in 6,6 anni (circa 121 USD al mese), DD storico peggiore 8,46% (339 USD), P95 stress 14,34% (574 USD), win rate 78,3% a barre e 71,4% a tick reali.

## Ipotesi con smentita, scritte ora
- **H1 (non perde nei mesi normali)**: netto positivo in almeno 2 mesi su 3. *Smentita*: positivo in 0 o 1 mese su 3.
- **H2 (il DD dichiarato regge)**: in ogni mese DD massimo di equita' <= 600 USD (circa il P95 dichiarato, a lotti fissi 0,01). *Smentita*: anche un solo mese sopra 600 USD.
- **H3 (niente griglia/martingala, a differenza dell'Arena)**: picco di lotti vivi <= 0,08 (8 strategie x 0,01) e profondita' di scala assente (nessun aumento di lotto dopo una perdita). *Smentita*: picco di lotti vivi > 0,08 o lotti crescenti dopo perdite, in qualunque mese.
- **H4 (la protezione giornaliera funziona)**: in nessun giorno la perdita di equita' supera il 4% del deposito (200 EUR su 5.000) come dichiara `PropFirmMaxDailyDD=4`. *Smentita*: un giorno oltre 200 EUR di perdita di equita' (calcolo con replay M1 come per l'Arena).
- **H5 (win rate dichiarato)**: win rate a tick reali fra 65% e 80%. *Smentita*: fuori da quella banda.
**Quando non si decide**: ogni ipotesi si legge solo sui mesi con giro CONFORME (input, deposito, finestra, ticks reali 100%, `.ex5` uguale fra i mesi). Un solo mese = descrittivo. Con meno di 150 operazioni totali il merito non si giudica, il rischio si'.
**Un esito favorevole restera' "candidato da misurare ancora", mai "pronto per una prop"**: tre mesi di un anno solo e un feed solo.

## Prerequisiti da chiudere con Claudio
Nome esatto del file `.ex5` nel terminale; scheda Parametri completa col set caricato (significato di `Risk=1234` e `TradeFrequency=2`, parametri ST1-ST8); versione dell'EA (4.6/4.7); eventuali limiti della demo del Market nel tester [NON VERIFICATI].
