# AUDIT DEL RISCHIO DI FLOTTA (01/10/2026)

Stato: **CRITERI CONGELATI, nessun numero nuovo calcolato.** Questo blocco e' committato PRIMA dei risultati
(regola del collaudo e regola del contro-esempio del 10/09). Gia' noti a chi scrive, perche' scritti in repo da
altri: i totali della challenge (`FTMO_CHALLENGE_CHIUSURA_2026-09-30.md`), del trial giorno 1
(`TRIAL_GIORNO1_ANALISI_2026-10-01.md`), la lettura RFWD e i contratti del 20/09. Nessuna misura nuova e' stata
fatta prima di questo commit. Solo misure: nessun backtest lanciato, nessun parametro cambiato, nessuna taglia scelta.

## 0. Criteri, definizioni e soglie (scritti prima dei numeri)

### 0.1 Fonti (solo file del repo)
- Challenge FTMO 541452707: `data/statements/FTMO_541452707_cronistorico_2026-09-30.xlsx` (posizioni, ordini, affari; ultimo evento 30/09 10:03 FTMO; i 3 trade manuali oro del 30/09 pomeriggio NON sono nel file).
- Trial FTMO 1514806751: `data/statements/ReportHistory_trial_1514806751_2026-10-01.xlsx` (01/10 fino alle 16:45 server).
- Piccolo BCM 50503392: `data/statements/ReportHistory_50503392_2026-10-01.xlsx` (30/04-30/09).
- 100k BCM 50504263: `data/statements/trades_100k.csv` (40 righe, nessuno SL iniziale: R **non calcolabile**, si usa solo `close_reason`).
- Contratti: per-trade OOS dei banchi citati in `CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` par. 2 (770101 `772501`, 770202 `772505`, 770411 `770413`, 771531 `pertrade_00_metro_763400`); frequenze promesse dallo stesso documento par. 6.
- Monte Carlo di casa: `backtest_pipeline/mc_challenge_ftmo.py` (importato, NON modificato).
- Guardian in campo: `ABTG_Guardian.mq5` al pin `d884f7e1` (v1.12) e include `ABTG_PausaGuardian.mqh` al pin `26a18566` (v1.20), preset `mql5/Presets/ABTG_Guardian_FTMO_2Step.set`.

### 0.2 Unita'
- **Posizione** = ID posizione MT5. **Netto** = profitto + commissioni + swap di tutti i deal della posizione.
- **Rischio all'ingresso (EUR)** = |prezzo d'ingresso - SL dell'ordine d'apertura| x volume x valore EUR per punto per lotto. Il valore per punto si ricava dalla posizione stessa (profitto lordo / (chiusura - apertura) / volume); se la distanza e' troppo piccola per ricavarlo, mediana dello stesso simbolo nello stesso conto. Se l'ordine d'apertura non ha SL, si usa lo SL della riga posizione e la riga si marca `SL_DA_POSIZIONE` (puo' essere uno SL gia' spostato: sottostima il rischio).
- **R** = netto / rischio all'ingresso. **STOP PIENO**: R <= -0,70 (stessa soglia `SOGLIA_STOP_R` di `RFWD_CRITERI.md`). **Uscita parziale**: posizione con 2+ deal di uscita.
- **Sottostante**: GER40.cash/D30EUR = DAX; US30.cash/U30USD = DOW; US100.cash/NASUSD = NASDAQ; XAUUSD = ORO; forex = la coppia (e la valuta, per la correlazione).
- **Giorno** = data server della chiusura (FTMO e BCM ciascuno col suo server).
- **Sedia** = dal commento dell'ordine d'apertura (`MAXMIN DAX SHORT` = 770411; `DAX Apertura EU RETEST BUY` = 770101; `... SELL` = 770105 sul conto FTMO; `EMA200 DOW S1/S2` = 771531; `BULGE_V520_FT_*` = Bulge A; `BULGE_VIOLA_*` = Bulge B). Senza commento = manuale.

### 0.3 Domanda 1 (dove nasce la perdita, correlazione, sequenza contro simultaneita')
- Si tabella per sedia / sottostante / giorno: n, netto, somma R, stop pieni, uscite parziali.
- **Sequenziale** = due STOP PIENI sullo stesso sottostante, stesso giorno, il secondo APERTO DOPO la chiusura del primo. **Simultaneo** = intervalli [apertura, chiusura] sovrapposti. Variante stretta: stessa direzione.
- **"Caso analogo al 01/10"** = almeno 2 stop pieni sequenziali sullo stesso sottostante nello stesso giorno. Si contano su FTMO challenge, trial, piccolo 50503392 (xlsx). Sul 100k si conta solo l'evento grezzo (`close_reason=sl` con perdita) e si dichiara che R non e' misurabile.
- **Correlazione**: quota della perdita netta della flotta che cade in giorni con 2+ posizioni perdenti sullo stesso sottostante; quota nella stessa direzione.

### 0.4 Domanda 2 (rischio simultaneo)
- **Rischio aperto** a un istante = somma dei rischi all'ingresso delle posizioni aperte (SL INIZIALE). Denominatore: saldo all'istante dell'ingresso. Differenze dichiarate col Guardian: il Guardian usa l'equity e lo SL CORRENTE (dopo un pareggio va a zero), quindi la mia misura e' un TETTO di cio' che il Guardian vede.
- Si misura a ogni ingresso: rischio aperto PRIMA e DOPO. Soglie di lettura: **4,00%** (C1 del preset FTMO) e **3,25%** (C1 firmato il 18/08).
- **Perdita potenziale del giorno** = perdita realizzata del giorno + rischio aperto; soglia di lettura **5,00%** del saldo d'inizio giornata (muro giornaliero 2-Step; per la trial [NON MISURATO]).
- **Massimo ammesso dalla regola**: si ricava dal CODICE (che cosa somma il Guardian, quando l'EA chiama la guardia, cosa succede ai pendenti), non dai dati.

### 0.5 Domanda 3 (Monte Carlo) -- due varianti dichiarate PRIMA
- Motore: `mc_challenge_ftmo.simula` cosi' com'e' (rimescola le giornate attive; frazionale fisso; muro giornaliero 5% e statico 10% del capitale iniziale; target +10%; minimo 4 giorni; Guardian = la perdita del giorno tagliata a 4,5%; 20.000 simulazioni, seme 11). **Prima di usarlo lo si deve riprodurre** sulla configurazione di `SECONDO_STOP_FTMO_2026-09-24.md` (74,6%): se non torna, la variante non si stampa.
- **(a) CONTRATTO**: le 4 sedie con per-trade OOS (770101, 770202, 770411, 771531), fattore 2,0 (taglia in campo 2,00%). Mancano 770105, 770260, 770511, Bulge A/B, ORB: il numero e' un PAVIMENTO del rischio, non un tetto.
- **(b) FORWARD**: le giornate della flotta misurate in campo, in R, rimesse alla taglia in campo (indici 2,00%, EMA200 1,00% per gamba, Bulge A 0,80%, Bulge B 1,00%). **(b1)** challenge 541452707 (solo flotta, oro manuale escluso) + trial 01/10; **(b2)** stesse famiglie di EA sul piccolo 50503392 (feed BCM, stessa logica, campione piu' largo).
- Si stampano: P(PASS), P(muro giornaliero), P(muro statico), da capitale pieno (1,000) e dallo stato del trial (saldo 153.754,32 / 160.000).
- **Opzioni** (nessuna scelta, solo costo): O0 stato attuale; O1 indici a 1,50%; O2 indici a 1,00%; O3 "dopo uno stop pieno sul sottostante niente altro su quel sottostante quel giorno". Costo = variazione del rendimento medio per giornata attiva e della durata mediana per passare. In (a) O3 e' **APPROSSIMATO** (il per-trade ha solo le uscite: si tolgono le posizioni dello stesso sottostante che CHIUDONO dopo lo stop, quindi anche quelle aperte prima: stima per eccesso dell'effetto).
- Valvola di casa: con (b) il campione e' sottile: **sospende il giudizio sul MERITO, mai sul RISCHIO**.

### 0.6 Domanda 4 (contratto contro campo, per sedia)
- Finestra della challenge: **22-30/09 = 7 giorni di borsa** (come `RFWD_CRITERI.md`), 770105 dal 28/09 (3 giorni).
- **Frequenza**: atteso = promessa x giorni. Intervallo: Poisson esatto. **FUORI** se P(X <= k) < 0,025 o P(X >= k) < 0,025.
- **Stop-rate**: quota di STOP PIENI (R <= -0,70) nel per-trade OOS del contratto, ricalcolata da me (R = netto / (1% x saldo prima della posizione); 771531: 0,5% per gamba). Osservato: k stop su n posizioni. Binomiale esatta, stesso criterio a due code (0,025 per lato). Dove il per-trade del contratto non esiste: `[NON MISURATO]`.
- Con n piccolo "dentro" vuol dire "non distinguibile", **non** "uguale al contratto".

### 0.7 Contro-esempi obbligatori
Ogni conclusione del par. 1 porta il caso che la romperebbe e l'esito; se il caso non e' costruibile: `[INCERTO]`.
