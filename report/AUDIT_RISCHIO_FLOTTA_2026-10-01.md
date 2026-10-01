# AUDIT DEL RISCHIO DI FLOTTA (01/10/2026)

Stato: **criteri congelati nel par. 0 al commit `e1e5171a` PRIMA dei numeri** (il par. 0 non e' stato toccato dopo);
risultati aggiunti dopo, nei par. A-F. Solo misure: nessun backtest lanciato, nessun parametro cambiato, nessuna taglia
scelta. Ogni numero si rifa' con `python3 backtest_pipeline/audit_rischio_flotta.py tutto` (sezioni `q1`..`q4`).
Etichette: [MISURATO] dai file del repo · [CODICE] letto nel sorgente al pin in campo · [APPROSSIMATO] · [NON MISURATO] · [INCERTO].

## LE CINQUE CONCLUSIONI

1. **La perdita e' fatta di STOP PIENI, quasi tutti sul DAX, e arrivano IN SEQUENZA, non insieme.** Challenge (sola
   flotta): 5 stop pieni su 11 posizioni = **100% della perdita lorda** (-6.514,85; **-5,25 R**) contro +1,86 R di vincite,
   e 4 delle 6 vinte valgono +0,03..+0,06 R. I 5 stop cadono in **5 giorni diversi**. Trial 01/10: 3 stop su 5 = 100% della
   perdita lorda; **i due DAX short in sequenza fanno l'82,2%** (-6.403,00). In tutta la storia forward delle sedie della
   flotta (challenge, trial, piccolo: 43 giorni attivi) il doppio stop sequenziale sullo stesso sottostante e' successo
   **una volta sola: il 01/10**. [MISURATO]
2. **Il C1 a 4,00% non e' un tetto, ed e' stato superato DUE volte il 01/10**: 4,66% alle 10:00 e **4,85% dalle 12:00 alle
   13:25** (non solo il 4,62% gia' scritto), entrambe le volte da un ingresso del Bulge B entrato con 3,66% e 3,86% gia'
   aperti. La **perdita potenziale del giorno** (realizzato + aperto) era **6,68% alle 11:13 e 7,66% alle 12:00**, sopra il
   5% (8.000): la sola rete era l'emergenza del Guardian a 4,5%. Per costruzione il C1 tiene sotto **6,00%** solo con
   ingressi uno alla volta e nessun pendente in attesa; con pendenti o raffiche nello stesso secondo **non ha tetto**
   (somma teorica delle taglie in campo: 20,5%). [MISURATO + CODICE]
3. **Il Monte Carlo di casa da' il segno del campione che gli si da'.** Contratto (4 sedie su 9, pavimento), Guardian ideale:
   **PASS 92,3%** da capitale pieno e **80,0% dallo stato del trial**; senza Guardian il **muro giornaliero 15,6%**.
   Forward FTMO (7 giornate, media **-1,355%/giornata**): **muro statico nel 100%**, mediana 8 giornate attive (5 dallo
   stato del trial), muro giornaliero mai (peggiore -3,89%). Forward del piccolo (30 giornate, +0,751%/giornata): PASS 100%.
   L'ipotesi che regge il numero buono e' il **Guardian che taglia a 4,5% senza sbavature**. [MISURATO, valvola R59: il
   campione forward sospende il MERITO, non il RISCHIO]
4. **Opzioni, col costo (nessuna scelta: sono di Claudio).** Indici a 1,50%: rendimento atteso **-25%** (+0,423 ->
   +0,317%/giornata), giornate mediane per passare **17 -> 24**, muro statico **7,7% -> 4,1%**. A 1,00%: +0,211%/giornata,
   **40** giornate, 0,7%. "Niente secondo ingresso dopo uno stop sul sottostante": **segno instabile** fra i campioni
   (contratto +0,04 punti/giornata, forward FTMO +1,91 punti, forward piccolo -1,36 punti) -> [INCERTO]. Un C1 che sommi
   l'ingresso nuovo il 01/10 avrebbe bloccato proprio le **due vinte** del Bulge B (+1.552,66): un giorno solo, aneddoto.
5. **Contratto contro campo**: **fuori** solo la frequenza della 770411 (3 contro 0,36 attese, P=0,006) e la frequenza
   aggregata in BASSO (10 contro 18,8 attese, P=0,021, [INCERTO] perche' assume sedie indipendenti). Gli **stop-rate sono
   tutti dentro** per sedia; il pool fa 5 stop su 10 contro 2,81 attesi, **P(>=5)=0,117: non distinguibile dal contratto**.
   Con questo campione **nessuna sedia si puo' dire "rotta"**, e nessuna si puo' dire "come il contratto". [MISURATO]

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

---

# RISULTATI (dopo il commit dei criteri)

Deviazioni dai criteri, dichiarate: (1) nella storia dei doppi stop le gambe della stessa sedia aperte entro 120 s
(EMA200 S1/S2, SuperWave 1/3-2/3, parziali del piccolo) contano come **un setup solo**: il conteggio per coppie di gambe
gonfiava gli episodi (21 coppie = 10 episodi sul piccolo); (2) in (b2) la 770260 e' **esclusa**: sul piccolo i suoi
commenti non sono `RETEST` (modo diverso dalla sedia FTMO); l'ORB (0,30%) e' incluso come sedia della flotta trial;
(3) la posizione GBPNZD del Bulge A ancora aperta alle 16:45 entra nel rischio aperto (par. B) ma non nei conti realizzati;
(4) il netto chiuso del trial qui e' -6.239,43: manca la commissione d'ingresso (-6,25) della GBPNZD A ancora aperta
(-6.245,68 del report MT5 = -6.239,43 - 6,25).

## A. Domanda 1 -- dove nasce la perdita [MISURATO]

**Challenge 541452707** (xlsx fino al 30/09 10:03; netto -7.002,99 = flotta -4.500,93 + oro manuale -2.502,06):

| sedia | n | netto EUR | somma R | stop pieni | uscite parziali | vinte |
|---|---:|---:|---:|---:|---:|---:|
| 770411 MaxMin DAX short | 3 | -2.236,00 | -1,40 | 2 | 1 | 1 |
| 770101 DAX Apertura RETEST long | 4 | -1.341,63 | -0,87 | 1 | 0 | 3 |
| 771531 EMA200 Dow (gambe) | 3 | -1.006,86 | -1,18 | 2 (stesso setup 22/09) | 1 | 1 |
| 770105 DAX Apertura RETEST short | 1 | +83,56 | +0,05 | 0 | 0 | 1 |
| **flotta** | **11** | **-4.500,93** | **-3,39** | **5** | 2 | 6 |
| manuale oro (28/09) | 2 | -2.502,06 | n/s (SL dalla posizione) | - | - | 1 |

- R della flotta ordinati: -1,115 · -1,080 · -1,029 · -1,014 · -1,008 · +0,031 · +0,046 · +0,055 · +0,064 · +0,648 · +1,018.
  **Stop pieni -5,25 R; vincite +1,86 R**, di cui +1,67 R dalle due uscite parziali (770411 il 29/09, EMA200 il 25-28/09) e
  +0,20 R dalle quattro uscite a pareggio-piu' del RETEST. (La chiusura del 30/09 scrive -3,25 R con l'R nominale
  `netto/(2% x saldo)`; qui l'R e' sul rischio vero ingresso->SL: -3,39.)
- Per sottostante: **DAX -3.494,07 (-2,21 R, 3 stop)** = 77,6% del netto della flotta; Dow -1.006,86 (-1,18 R).
- Per giorno (solo flotta, % del conto a taglia 2%): 22/09 -2,19 · 24/09 -1,97 · 25/09 -2,02 · 28/09 +1,19 · 29/09 +1,42 ·
  30/09 -2,03. **Quattro giornate perse, ognuna = UN setup in stop**: nessun giorno della challenge ha due setup in stop.
- Correlazione: la sola perdita "stesso giorno + stesso sottostante" e' il 22/09 (le due gambe EMA200 dello stesso setup):
  27,0% della perdita lorda, tutta nella stessa direzione.

**Trial 1514806751** (01/10 fino alle 16:45):

| sedia | n | netto EUR | somma R | stop pieni |
|---|---:|---:|---:|---:|
| 770411 MaxMin DAX short (09:59 -> 10:06) | 1 | -3.292,52 | -1,02 | 1 |
| 770105 DAX Apertura RETEST short (11:13 -> 13:36) | 1 | -3.110,48 | -1,00 | 1 |
| Bulge A NZDCHF | 1 | -1.389,09 | -1,05 | 1 |
| Bulge B GBPNZD + AUDUSD | 2 | +1.552,66 | +0,98 | 0 |
| **totale chiuso** | **5** | **-6.239,43** | **-2,08** | **3** |

- **Il DAX fa -6.403,00 = 82,2% della perdita lorda**, due short, **in sequenza** (il secondo aperto 67 minuti dopo lo
  stop del primo). Somma R x taglia del giorno = **-3,89%** del conto (ricostruita dagli R, coincide col realizzato -3,90%).

**Doppi stop pieni sullo stesso sottostante nello stesso giorno, in tutta la storia forward del repo** (setup, SL d'ordine):

| conto | insieme | posizioni | stop pieni | giorni attivi | episodi SEQUENZIALI | coppie SIMULTANEE |
|---|---|---:|---:|---:|---:|---:|
| challenge 541452707 | flotta | 11 | 5 | 6 | **0** | 0 (il 22/09 e' un setup solo) |
| trial 1514806751 | flotta | 5 | 3 | 1 | **1** (01/10 DAX, 770411 -> 770105, stessa direzione) | 0 |
| piccolo 50503392 | sedie della flotta | 85 | 16 | 36 | **0** | 2 (EMA200 Dow 24/08 e 27/08, gambe riempite a 8-14 min) |
| piccolo 50503392 | tutti gli EA | 553 | 168 | 85 | **10** (4 DAX: 23, 28, 29, 30/07; 2 NASDAQ; 2 DOW; 1 ORO; 1 AUDCAD). In tutti c'e' almeno un EA fuori flotta; sedie della flotta coinvolte come una delle due: 770260 in modo non RETEST (10/08), ORB Dow (19/08), 771531 (31/08) | 40 |
| 100k 50504263 | tutti | 40 | 13 `sl` in perdita (R non misurabile) | - | 0 | 0 |
| contratto (OOS, 770101+770411) | DAX | - | - | 198 giornate DAX | 1 giorno con stop di entrambe (23/03/2026; ordine non ricostruibile) | - |

Lettura: sulle sedie della flotta il doppio stop sequenziale sul DAX e' **un evento raro nei dati** (1 in 43 giorni attivi
forward, 1 in 198 giornate DAX del contratto) **ma il contratto non contiene la 770105** (lato short, nessun per-trade): la
coppia del 01/10 (770411 short + 770105 short) e' **fuori dal campo di misura del contratto** [NON MISURATO].

## B. Domanda 2 -- rischio simultaneo [MISURATO + CODICE]

**Che cosa fa la regola, letta nel codice in campo** (Guardian v1.12 pin `d884f7e1`, include v1.20 pin `26a18566`):
- `OpenRiskPct()` (r.171-201) somma **solo le posizioni** (`PositionsTotal`), con lo **SL corrente**, in % dell'**equity**;
  i pendenti NON entrano. Il timer gira ogni **1 s** (r.317); la bandiera `ABTG_CAP_RISCHIO` si alza se il totale e' **>= 4,00**
  (r.441-457, preset `InpMaxOpenRiskPct=4.00`).
- `ABTG_GuardiaIngresso()` (include r.282-319) legge **solo la bandiera**: nessun argomento per il rischio dell'ingresso nuovo.
- Gli EA chiamano la guardia **prima di inviare l'ordine** (MaxMin r.245 prima di `SellStop`; DAX Apertura r.1503/1536 prima di
  `BuyLimit`/`SellLimit`; EMA200 r.243; SuperWave r.267; Bulge r.1268/1286 prima di `trade.Buy/Sell`): **un pendente gia'
  piazzato si riempie senza nessun controllo**.

**Il massimo che la regola ammette** (taglie del trial: 7 sedie indice 2,00%; Bulge A 0,80% x 4; Bulge B 1,00% x 3; ORB 0,30%):

| situazione | rischio aperto massimo | che cosa lo ferma |
|---|---:|---|
| ingressi uno alla volta, a mercato, nessun pendente in attesa | **< 4,00 + 2,00 = 6,00%** (< 5,00% se l'ultimo e' Bulge) | il C1, dal successivo |
| pendenti piazzati quando il rischio era < 4,00 | 4,00 + somma dei pendenti vivi (indici: fino a ~14%) | nessuno: il C1 non li vede ne' al piazzamento ne' al riempimento |
| ingressi nello stesso secondo (raffica Bulge sulla stessa barra H1) | + fino a 3,2% (A) + 3,0% (B) | `Max_Trades` per magic, non il C1 |
| tutte le sedie piene insieme (teorico) | **20,5%** | margine e orari (a 80k sei sedie a 2% chiedevano il 105% del conto, `QUANTE_SEDIE_CI_STANNO_2026-09-23.md`; leva del trial [NON MISURATO]) |

Sono gia' classi di casa (645, 1003): qui c'e' la **misura in campo**.

**Trial 01/10, ogni ingresso** (rischio = SL d'ordine; denominatore saldo; "potenziale" = perdita realizzata del giorno + rischio aperto, sul saldo d'inizio giornata):

| ora server | sedia | simbolo | rischio EUR | aperto prima | aperto dopo | sopra 4,00? | realizzato giorno | **potenziale giorno** |
|---|---|---|---:|---:|---:|---|---:|---:|
| 06:00:00 | Bulge A | GBPNZD | 1.288 | 0,00% | 0,81% | - | 0,00% | 0,81% |
| 06:00:00 | Bulge A | NZDCHF | 1.326 | 0,81% | 1,63% | - (stesso secondo) | 0,01% | 1,65% |
| 09:59:01 | 770411 | GER40.cash | 3.237 | 1,63% | 3,66% | - | 0,01% | 3,67% |
| 10:00:00 | Bulge B | GBPNZD | 1.596 | **3,66%** | **4,66%** | **SI** | 0,02% | 4,67% |
| 11:13:13 | 770105 | GER40.cash | 3.106 | 1,86% | 3,86% | - | 2,94% | **6,68%** |
| 12:00:00 | Bulge B | AUDUSD | 1.546 | **3,86%** | **4,85%** | **SI** | 2,95% | **7,66%** |

- Il picco e' **4,85% dalle 12:00:00 alle 13:25:11** (GBPNZD A + GBPNZD B + DAX 770105 + AUDUSD B), non il 4,62% delle
  10:00 scritto nell'analisi del giorno 1 (differenza di metodo: lettura su un istante, non scansione degli ingressi:
  classe 1015). Su questi sei ingressi lo SL d'ordine e' **uguale** allo SL della posizione: il Guardian ha visto gli
  stessi numeri (a meno del flottante). Che la bandiera sia davvero salita alle 10:00:01 e alle 12:00:01: **[NON VERIFICATO]**
  (righe `[GUARDIAN]` del trial non lette).
- La **perdita potenziale ha superato il 5% (8.000) dalle 11:13 alle 13:42** (fino al TP dell'AUDUSD): alle 12:00, con
  tutti gli stop presi insieme, il giorno arrivava a ~-7,7%. La rete vera era l'**emergenza 4,5%** (7.200), che agisce sull'equity
  dopo il fatto e non attraverso un gap.
- **Challenge**: rischio aperto massimo della flotta **2,07%** (un setup per volta, mai due insieme); l'unico 4,03% del conto
  e' dei due trade manuali sull'oro del 28/09.
- **Storico delle sole sedie indice, rimesse alla taglia FTMO, sui loro orari veri del piccolo** (70 ingressi, 29/07-22/09):
  massimo **4,00%** (6 ingressi: due sedie da 2% insieme, o una sedia + le due gambe EMA200), **mai sopra**. I superamenti
  compaiono quando al parco indici si aggiunge il Bulge (trial). [MISURATO, approssimazione dichiarata: sul piccolo non
  giravano 770105 ne' il Bulge v5.20 FT]
- Il piccolo con tutti i suoi EA (sue taglie, nessun Guardian): rischio aperto dopo l'ingresso mediana 3,39%, p90 13,4%,
  massimo 29,7% (560 ingressi): **non trasferibile** alla flotta FTMO, lo scrivo solo come quadro di un conto senza cap.

## C. Domanda 3 -- Monte Carlo [MISURATO col motore di casa]

Motore `mc_challenge_ftmo.simula` **non modificato**, riprodotto prima dell'uso: configurazione di
`SECONDO_STOP_FTMO_2026-09-24.md` -> **PASS 74,6%, 20 giornate mediane** (atteso 74,6). Contro-esempi del motore: campione
tutto a -6% -> 100% muro giornaliero; con Guardian -> 100% muro statico; campione nullo con un +1,1% -> 100% PASS. Le durate
alla "morte" vengono da una copia riga per riga di `simula` (stesso generatore): esiti identici al motore (92,3/7,7 e
79,8/15,6/4,5 verificati).
Ipotesi del motore (dichiarate): giornate attive rimescolate, P/L realizzato (non equity), muri 5%/10% sul capitale
iniziale, Guardian = **perdita del giorno tagliata esattamente a 4,5%** (niente gap, niente flottante), regole del trial =
regole 2-Step [NON MISURATO]. Stato del trial = saldo 153.754,32 / 160.000 = 0,961.

| campione / opzione | Guardian | PASS | muro gg | muro stat. | PASS da trial | muro gg da trial | muro stat. da trial | rend. medio / giornata | giornate mediane (pieno / trial) |
|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| **(a) contratto 4 sedie** O0 2,00% | 4,5% | **92,3%** | 0,0 | 7,7 | **80,0%** | 0,0 | 20,0 | +0,423% | 17 / 23 |
| (a) O0 | **no** | 79,8 | **15,6** | 4,5 | 67,2 | **18,6** | 14,3 | +0,423% | 15 / 21 |
| (a) O1 indici 1,50% | 4,5% | 95,9 | 0,0 | 4,1 | 86,4 | 0,0 | 13,6 | +0,317% | 24 / 34 |
| (a) O2 indici 1,00% | 4,5% | 99,3 | 0,0 | 0,7 | 94,9 | 0,0 | 5,1 | +0,211% | 40 / 57 |
| (a) O3 niente 2o dopo stop [APPROSSIMATO, per eccesso] | 4,5% | 93,8 | 0,0 | 6,2 | 83,0 | 0,0 | 17,0 | +0,462% | 16 / 22 |
| **(b1) forward FTMO, 7 giornate** O0 | 4,5% / no | **0,0** | 0,0 | **100** | 0,0 | 0,0 | 100 | **-1,355%** | morte: mediana **8** (p10 6, p90 10) / **5** (3-6) |
| (b1) O1 / O2 / O3 | 4,5% | 0,0 | 0,0 | 100 | 0,0 | 0,0 | 100 | -1,016 / -0,677 / -1,082% | - |
| **(b2) forward piccolo, 30 giornate** O0 | 4,5% / no | **100** | 0,0 | 0,0 | 100 | 0,0 | 0,0 | +0,751% | 13 / 18 |
| (b2) O1 / O2 / O3 | 4,5% | 100 / 100 / 100 | 0 | 0 | 100 / 100 / 99,9 | 0 | 0 / 0 / 0,1 | +0,564 / +0,376 / +0,706% | 17 / 25 / 13 |

- (a) giornate peggiori a 2,00%: 26/02/2026 **-6,02%**, 15/10/2025 **-5,99%**, 19/02 -4,10, 02/04 -3,99, 02/12 -3,99; **11 giornate su
  242 <= -3,5%, 2 <= -5%**. Giorni con stop pieni di due sedie Dow diverse (770202 + 771531): 6.
- (b1) giornata peggiore -3,89% (01/10), nessuna <= -5%: **il forward non ha mai toccato il muro giornaliero; perde per
  deriva, uno stop pieno alla volta**.
- **Le tre letture si contraddicono, e la contraddizione e' la misura**: il contratto dice "passa 8-9 volte su 10", il
  forward FTMO dice "muore in 8 giornate attive", il forward del piccolo (stesse sedie, feed BCM, 770101 senza stop) dice
  "passa sempre". 7 giornate non bastano per il MERITO; per il RISCHIO dicono che **la flotta, quando perde, perde
  ~2% per giornata e non ha giornate rosse grandi: il muro statico arriva per somma, non per un colpo**.
- Opzione O3 (che cosa toglie): (a) 43 posizioni, somma -9,58 punti in 242 giornate (20 vinte e 19 stop tolti: e' per
  eccesso, toglie anche posizioni aperte PRIMA dello stop perche' il per-trade ha solo le uscite); (b1) 2 posizioni, +1,91 punti
  (toglie il 770105 del 01/10 e un +0,09 del 24/09); (b2) 4 posizioni, **-1,36 punti** (toglie 3 vinte). **Segno instabile**.
- **C1 che somma l'ingresso nuovo** ("entra solo se aperto + nuovo <= 4,00"): non modellabile sulle somme giornaliere.
  Sull'unico giorno in cui avrebbe agito (01/10) avrebbe bloccato GBPNZD B e AUDUSD B, **le due vinte** (+1.552,66): la
  giornata sarebbe finita a **-4,87%** del conto, oltre l'emergenza 4,5%. Un giorno: aneddoto, non misura.
- Margine oggi in stop pieni (equity 153.977,04): verso la linea 144.000 = 9.977 = **3,2 stop DAX** da 2% (~3.075); verso il
  pavimento Guardian 145.120 = **2,9 stop**; il giorno vale 8.000 = **2,6 stop** [regole del trial NON MISURATE].

## D. Domanda 4 -- contratto contro campo, per sedia [MISURATO]

Stop-rate del contratto ricalcolato da me sul per-trade OOS (R = netto / (1% x quota x saldo prima); STOP = R <= -0,70):
770101 **40/193 = 20,7%** (R medio +0,088) · 770202 **21/96 = 21,9%** (+0,071) · 770411 **5/14 = 35,7%** (+0,435) · 771531
**78/257 = 30,4%** (+0,165; identico sui due file `771521` e R112 `763400`: e' la stessa cella). 770105, 770260, 770511:
per-trade del contratto non in repo -> [NON MISURATO].
Finestra 22-30/09 = 7 giorni (770105: 3). Intervallo: Poisson esatto (frequenza), binomiale esatta (stop), FUORI se una coda < 0,025.

| sedia | posizioni oss. | attese | P(X<=k) | P(X>=k) | frequenza | stop oss. | p contratto | P(<=k) | P(>=k) | stop-rate |
|---|---:|---:|---:|---:|---|---|---:|---:|---:|---|
| 770101 | 4 | 4,89 | 0,459 | 0,720 | dentro | 1 su 4 | 0,207 | 0,808 | 0,605 | dentro |
| 770105 | 1 | - | - | - | [NON MISURATO] | 0 su 1 | - | - | - | [NON MISURATO] |
| 770202 | 0 | 2,44 | 0,088 | 1,000 | dentro | 0 su 0 | 0,219 | - | - | n=0 |
| 770260 | 0 | 2,52 | 0,080 | 1,000 | dentro | 0 su 0 | - | - | - | [NON MISURATO] |
| **770411** | **3** | **0,36** | 0,999 | **0,006** | **FUORI (alto)** | 2 su 3 | 0,357 | 0,954 | 0,292 | dentro |
| 770511 | 0 | 2,06 | 0,128 | 1,000 | dentro | 0 su 0 | - | - | - | [NON MISURATO] |
| 771531 | 3 | 6,52 | 0,111 | 0,958 | dentro | 2 su 3 (1 setup) | 0,304 | 0,972 | 0,220 | dentro |
| **aggregato 6 sedie** | **10** | **18,78** | **0,021** | 0,990 | **FUORI (basso)** [INCERTO: sedie correlate] | - | - | - | - | - |
| **pool stop (770101, 770411, 771531)** | - | - | - | - | - | **5 su 10** | atteso 2,81 | - | **0,117** | **dentro** |

Riferimento, stesso codice sul feed BCM (piccolo 50503392): 770101 RETEST **0 stop su 16** (contratto 20,7%: P(<=0)=0,024,
**FUORI in basso**, cioe' meglio del contratto); 770411 0 su 5 (dentro); 771531 10 su 23 (dentro); 770202 0 su 4 (dentro).
**Le stesse sedie hanno fatto 0 stop DAX in 21 posizioni sul piccolo e 5 stop DAX in 10 posizioni su FTMO+trial**: con
questi n il divario non distingue ancora "feed/regime diverso" da "caso" [INCERTO]; la riproduzione RFWD dice che sui giorni
FTMO il tester BCM fa le stesse operazioni (non e' l'esecuzione).

## E. Contro-esempi, uno per conclusione

| conclusione | il caso che la romperebbe | esito |
|---|---|---|
| 1. stop in sequenza, non insieme | una giornata con due setup DIVERSI aperti insieme e chiusi a stop insieme | cercata su challenge, trial, piccolo (sedie flotta): **0**; le sole simultanee sono gambe della stessa EMA200. **Regge.** E la coppia del 01/10 e' sequenziale anche al PIAZZAMENTO (sell limit 770105 piazzato alle 11:11:50, 65 min dopo lo stop delle 10:06:32), non solo al riempimento |
| 2. C1 superato | il Guardian vede SL correnti ed equity: forse sotto 4,00? | SL d'ordine = SL di posizione su **6 su 6** posizioni del trial; flottante alle 12:00 piccolo rispetto a 155.000: il Guardian ha visto ~4,8%. **Regge**; che abbia SCRITTO la bandiera: [NON VERIFICATO] |
| 2. tetto 6,00% "uno alla volta" | un pendente piazzato sotto il cap che si riempie dopo | e' proprio il caso del 01/10 alle 09:59 (pendente piazzato con 1,63%): il 6,00% vale **solo** senza pendenti in attesa, ed e' scritto cosi'. **Regge con la condizione** |
| 3. MC | il numero buono di (a) dipende dal Guardian ideale? | si': senza Guardian il muro giornaliero passa da 0,0 a **15,6%**. Il 01/10 la perdita potenziale e' arrivata a 7,66%: che l'emergenza tagli davvero a 4,5% senza gap e' **[INCERTO]** |
| 4. O3 utile | un campione dove togliere il secondo ingresso costa | **c'e'**: (b2) -1,36 punti. Conclusione gia' scritta come [INCERTO], **regge come incertezza** |
| 5. aggregato FUORI in basso | sedie US correlate dal regime: tre zeri insieme non sono tre eventi indipendenti | con correlazione forte l'aggregato vale meno di P=0,021: **[INCERTO]**; i test per sedia non ne sono toccati |
| strumento: R e rischio | i miei R contro numeri gia' scritti da altri | rischio DAX trial 3.237 (analisi del giorno 1: 3.199-3.237), NZDCHF 1.326 (1.326), GBPNZD B 1.596 (1.596); PF flotta challenge 2.013,92/6.514,85 = **0,31** (chiusura: 0,31); somma giorno trial in R x taglia -3,89% contro -3,90% realizzato. **Torna** |
| strumento: posizioni aperte | un report con una posizione ancora aperta | il primo passaggio del parser leggeva solo `Posizioni` e perdeva la GBPNZD A (1.288 EUR): picco 4,02% invece di 4,85%. **Trovato e corretto prima della consegna** (classe 1016) |

## F. Che cosa questo audit NON misura

- Le righe del Guardian sul trial (bandiera C1 alle 10:00:01 e 12:00:01, pausa 3,5% dalle 13:36): [NON VERIFICATO].
- Le regole vere della Free Trial (5%/10%, statico o no): [NON MISURATO]; qui sono quelle del 2-Step.
- Il contributo del **Bulge** al contratto: nessun per-trade di contratto in repo; (a) contiene **4 sedie su 9** (mancano
  770105, 770260, 770511, Bulge A/B, ORB): e' un **pavimento** del rischio.
- O3 nel contratto: solo per eccesso (il per-trade non ha le ore d'ingresso). Un C1 "che somma" non e' modellabile sulle
  somme giornaliere.
- 100k 50504263: niente SL iniziale nel CSV, R e stop pieni non calcolabili.
- Gap, flottante intragiornaliero, slippage oltre quello gia' dentro i P/L, rifiuti di ordine, margine e leva del trial.
- Un solo regime (fine estate 2026) in tutto il forward.
