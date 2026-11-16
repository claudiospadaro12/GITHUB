# Piano: uno strumento ottimizzatore per i nostri EA (16/11/2026; criteri scritti PRIMA dei numeri)

**Natura: PIANO.** Nessuna passata lanciata. Solo demo e tester; reale, FTMO e VPS non si toccano; nessun giudizio su lotti, taglie o acquisti. Richiesta di Claudio (16/11): "abbiamo tantissimi EA con buoni motori ma scarsi risultati; se il metodo di Wim funziona, creare set ispirati a Wim e fare le combinazioni per l'ottimizzazione; oppure creare uno strumento ottimizzatore".

## 1. Inventario automatico (dal repo, 44 file `.mq5` in `mql5/Experts`; script di conteggio sulle righe `input`)
- **44 file, ma circa 16 famiglie di logica**: ORB, Apertura EU/US (DAX, Nasdaq), Live5m, MaxMinNotte, Nightly, SupertrendReversal/SuperWave/SupertrendInvert/SupRev (una famiglia con molti file `_Ottimizzato` per simbolo), EMA200, GoldenCross, HARSI, PTE, PostNews, FiboH4, WOL, Londra ORB, DAX M3, Scalper Claudio, IchiTrend. Molti file sono copie `_Ottimizzato` con i valori fissati per un simbolo.
- **41 su 44 hanno input di ORARIO** (in ora server): vanno gestiti estate/inverno (regola CLAUDE.md); **37 su 44 hanno distanze in PUNTI/PIP fissi**; 38 su 44 hanno gia anche un parametro ATR. Input per EA: da 4 a 86 (mediana circa 41).
- **Risultati nel repo:** cercando il nome del file `.mq5` nei referti `.md`, quasi nessun EA e citato (ORB 7 referti, Scalper Claudio 2, IchiTrend 2, gli altri 0). **NON significa che non siano stati testati**: i risultati possono stare altrove o con altri nomi; **non l'ho verificato**.

## 2. Ipotesi sul perche "buoni motori, scarsi risultati" (NON verificata)
1. **Distanze in punti fissi.** Il DAX e passato da circa 5.000 a 24.000 punti, l'oro da 1.000 a 3.800 dollari: un buffer o uno stop in punti fissi vale cose diverse in anni diversi. Il motore di Wim scala i valori con l'ATR ("Variable values", `ATRDefault`): per questo i suoi set tengono su 10 anni. **Convertire le distanze dei nostri EA in multipli di ATR potrebbe valere piu dell'ottimizzazione.**
2. **Orari in ora server** che spostano la sessione di un'ora due volte l'anno.
3. **Costi/tick:** i test a candele sovrastimano le strategie a stop corti (visto sugli scalper: PF dimezzato).
4. **Sovra-ottimizzazione gia fatta** nei file `_Ottimizzato` (da leggere come).
Come verificarle: una passata di base per famiglia su anni diversi (vedi stadio 0), guardando se il PF dipende dal regime di volatilita.

## 3. Cosa del metodo di Wim e trasferibile (dal nostro studio dei suoi file e del video)
- Template di ottimizzazione con intervalli e passi per ogni parametro; pochi parametri liberi per volta; criterio "Custom max" con minimi su operazioni, expected payoff, recovery; algoritmo genetico veloce o griglia; dentro campione 10 anni; fuori campione; test a tick reali per gli scalper; test di perturbazione; costruzione di un portafoglio fra candidati poco correlati con "max risk per strategy".
- **Cosa NON e trasferibile da solo:** la scala per ATR (e dentro il suo motore), la quantita (300+ set), la storia live. Ottimizzare aumenta SEMPRE il PF in campione; **solo il fuori campione dice se e reale**: con 625 tentativi sull'oro il miglior passaggio (nella griglia sbagliata) era +10% sul centro, **cioe quanto il caso da solo.**

## 4. Lo strumento (stadi; ognuno con regola di arresto scritta prima)
| Stadio | Cosa fa | Output | Costo stimato |
|---|---|---|---|
| 0 Screening | per ogni famiglia: una passata di base (valori attuali) su 2-3 finestre (anni diversi) + costi; ranking | tabella PF/DD/operazioni per EA e periodo | ore, 1 passata ciascuno |
| 1 Robustezza | `ABTG_Common.mqh`: distanze in multipli di ATR, orari calcolati dall'ora italiana con regole di cambio ora (UE/USA) | EA "v2" con stessi ingressi ma input normalizzati | codice + 1 passata per confronto |
| 2 Ottimizzazione | descrittore per EA (parametri liberi, range, passi, finestre IS/OOS/hold-out), generatore del set, avvio da `.ini` con TUTTI gli input, controllo bloccante del passaggio centrale, analisi XML, convalide V0-V5 | candidati con numeri | 5-8 ore per griglia |
| 3 Portafoglio | correlazione tra candidati e col portafoglio di Wim, simulazione di challenge (fail-rate) | portafoglio candidato | ore |
- **Contatore di tentativi di CAMPAGNA:** si registra il numero totale di combinazioni guardate su tutti gli EA; piu se ne provano, piu alta la soglia (t >= 3,5, OOS e hold-out obbligatori). Con 16 famiglie x centinaia di combinazioni, qualcosa sembrera buono per caso.
- **Hold-out per mercato:** 2025 e 2026 (fino a ottobre) restano intatti per ogni mercato finche non c'e un finalista.
- **Dati:** oro dal 2004; indici (DAX D30EUR, Nasdaq `_EXT`) con meno anni e convenzioni orarie diverse da anno ad anno (CLAUDE.md): **la finestra di test va decisa per mercato dopo aver letto la copertura** (riga di sola lettura come per l'oro).

## 5. Previsioni (scritte ora)
- **O-1** Lo stadio 0 mostra almeno 3 famiglie con PF >= 1,20 in tutte le finestre con almeno 100 operazioni: 35%.
- **O-2** Convertire le distanze in ATR migliora il PF fuori campione di piu del 10% in almeno 2 famiglie: 30%.
- **O-3** Almeno 1 EA ottimizzato supera V1 (rendimento/DD >= 1,10x la versione base in OOS): 30%; supera anche i tick e l'hold-out: 8%.
- **O-4** Almeno 1 candidato con correlazione <= 0,30 col portafoglio oro di Wim e PF >= 1,20 dopo i costi: 25%.
- **O-5** Il verdetto per la campagna e "pochi candidati reali, ma diversi da Wim": 55%; "nessuno": 30%; "molti": 15%.

## 6. Cosa NON sappiamo
Quali EA hanno gia risultati affidabili e dove sono; la copertura dei dati per indice e forex; se i `_Ottimizzato` sono stati validati fuori campione; se l'ATR-normalizzazione aiuta; i costi reali sugli indici (spread FTMO non misurati).
