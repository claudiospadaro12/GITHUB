# PIANO MISURE CANDIDATI - 06/10/2026

> **BOZZA, NON passata dal cancello.** Strato 1 (`controlla_riga.py --oggetto md`) e `controlla_prova.py` sulle due bozze: esiti in sez. 10. Strato 2 (`controllo-preventivo`): **DA FARE**. Nessun backtest lanciato, nessun VPS / forward / conto toccato, nessuna taglia proposta (il rischio e' di Claudio). Le due bozze di file prova e di riga stanno **qui dentro**, non in `backtest_pipeline/prove/` ne' in `backtest_pipeline/righe/`.
> **Etichette**: `[MISURATO]` riletto da me su CSV/referto in questa sessione; `[LETTO]` da un documento; `[DERIVATO]` calcolato da numeri scritti; `[INFERITO]`; `[NON MISURATO]`. Le probabilita' sono **priori miei**, non misure: lo dico dove le uso.

---

## 0. RISPOSTA IN 20 RIGHE

1. **Ordine** (valore atteso di arrivare a una sedia / ore di PC, sez. 3): **(a) SupRev NAS H1 970913** >> **(d) C2C EURJPY** > **(c) SupRev 225JPY H2** > **(b) ORB_Ott D30EUR** > **(e) CrossEma oro K03**. Dopo il primo, i punteggi stanno entro un fattore 2: valgono come ordine di lancio, non come verdetto.
2. **Costo totale**: le cinque *prime misure* fanno circa **42-66 minuti di PC piu' la corsa dello spread 225JPY (T1, durata `[NON MISURATO]`, tetto 240 min)**; con tutti i passi opzionali circa **2-2,5 ore**. Tempi presi dai referti runner (sez. 6), misurati sul banco VPS in contesa: la velocita' del PC `DESKTOP-H4D7CAJ` e' `[NON MISURATA]`.
3. **Prima misura da lanciare**: una passata singola a tick di `SupertrendReversal` su NASUSD H1 con la geometria 970913, due lati insieme (bozza R290a, sez. 7). Chiude il cancello di costo con una misura e fa da riproduzione (G0). 10-17 minuti. **Prima serve una versione NAS dello script `PASSATA_STOP_SUPREV.ps1`**, che oggi e' cablato su U30USD: e' codice nuovo e passa dai due strati.
4. **Quattro correzioni ai numeri di partenza** (sez. 2): R163a **e' gia' girato** (CSV in repo; 14 passate in 55-82 minuti, non "3-5"); il "28,7x" **non e' piu' il numero** (rivisto il 18/09 a 15,1x, coda 10,4x; sono due limiti inferiori che stanno ai due lati del 40); r125e **ha gia' fallito il suo stesso criterio scritto prima** (PF OOS sale monotono mentre n crolla); la **profondita' tick dell'oro e' misurata** (dal 10/07/2024) e copre la finestra di K03.
5. **Una scoperta che cambia (d)**: i CSV r146a (tick, in repo) mostrano che il buffer dello stop abbassa DD e peggior giornata del C2C EURJPY senza toccare il PF OOS (DD OOS 12,11 -> 5,68-7,36; giornata -6,73 -> -2,51/-3,27). Nessuno l'ha mai messo ad asse sulla finestra lunga, che e' quella che boccia la sedia: bozza R290b, 1 minuto di tester.
6. **Nessun candidato e' MORTO**: tutti e cinque restano "NON ANCORA MISURATO" (sez. 5): a ognuno manca almeno una casella del certificato.
7. **Nessun candidato arriva a n >= 150 con un backtest**: tick veri dal 26/09/2024 (indici), 05/07/2024 (forex), 10/07/2024 (oro). Il merito resta **sospeso** per (a), (b), (c), (e); (d) ha n >= 150 solo a barre. "Sedia candidata al forward demo" vuol dire quindi: **rischio letto, costo misurato, merito dichiarato sospeso** (definizione in sez. 1, **non e' un testo firmato**).
8. **Dubbi principali**: (i) le probabilita' sono giudizi miei; (ii) l'EA base `SupertrendReversal` e' identico all'Ottimizzato solo per **inferenza sul sorgente**: lo verifica G0, non io; (iii) il buffer 2253 non e' quello del preset in campo (3): la scelta e' di Claudio; (iv) 970913 e' stata tolta dal demo il 25/09 per firma di Claudio: riaccenderla e' una sua decisione.

---

## 1. IL METRO E LE ETICHETTE

**"Sedia candidata al forward demo"** (SC-FD). Non ho trovato un testo firmato che la definisca con soglie. Uso il metro di `PERCHE_NON_PASSANO_2026-09-09.md` §3.1 e `DOSSIER_SCHIERAMENTO_EMA200_DOW_2026-09-09.md` §5, e lo **dichiaro**:

| # | cancello | soglia | come lo leggo qui |
|---|---|---|---|
| 1 | rischio | DD <= 10,0%, peggior giornata > -5,0% (alla taglia dichiarata) | letto **a qualunque n**; il VECCHIO giudica il rischio (Emendamento B) |
| 2 | campione | n >= 150 per finestra (Emendamento A) | sotto: **merito SOSPESO**, dichiarato, non "dimostrato" |
| 3 | C0 | PF >= 1,10 nella finestra peggiore (se n >= 150) | sotto 150 si legge come "non escluso" |
| 4 | C3 costo | stop mediano >= 40 x spread mediano dell'ora; pavimento duro 13,3 x spread di coda | **misurato**, mai stimato |
| 5 | R4 | rischio vero = dichiarato | sorgente + log del lotto |
| 6 | frequenza | >= 1,00 op/giorno **per famiglia** (firma 07/09) | dichiarata per famiglia, mai per sedia sola |
| 7 | regime | 4 finestre (toro / orso / laterale / crollo), Emendamento C | oggi `NON MISURATO` per **tutte** le sedie: un solo regime a tick |

SC-FD = 1, 3, 4, 5 passati o dichiarati; 2 e 7 **dichiarati non passati** (e' il forward a comprare il campione); **piu' la firma di Claudio**. Nessuna soglia e' abbassata: 2 e 7 restano rossi, si ammette solo di portare la sedia a comprare campione in demo, dove nessun capitale e' a rischio. **Se Claudio non accetta questa lettura, nessuno dei cinque e' SC-FD.**

**Verdetti possibili** per ogni candidato: **SOPRA** (la misura passa il suo cancello con la soglia scritta prima), **SOTTO** (non passa), **FRAGILE** (cade nella banda dichiarata, non decide), **NON MISURATO** (la misura non e' stata fatta o non e' valida). Un SOTTO non e' un MORTO: il certificato a 5 caselle e' in sez. 5.

**Regole tenute**: nessuna griglia larga su motori senza edge (regola 19/08); si allarga solo su meccanismi, simboli, TF, uscita; una variabile per file prova; attese e soglie prima dei numeri; centro dell'altopiano, mai il picco; nessuna soglia abbassata.

---

## 2. CORREZIONI AI NUMERI DI PARTENZA (trovate rileggendo le fonti)

| # | cosa dicevano le letture | cosa dicono le fonti | fonte |
|---|---|---|---|
| C1 | (a) G5 propone "G0, R163a, R113, ~10 min"; la passata stop e' per Dow | **R163a e' gia' girato**: 4 notti del runner (17-20/09), uscita 0, **4914 / 4187 / 3357 / 3279 s** per 14 passate (3,9-5,9 min/passata, **55-82 min** in tutto); CSV IS/OOS in `risultati_prove/dal_vps/ABTG_SupRev_NAS_H1_Ottimizzato/`. G5 lo stimava "3-5 min" (sottostima da 11 a 27 volte) | `coda/referti/REFERTO_RUNNER_2026091[7-9]*.txt`, `..._20260920_*.txt` righe `r163a` |
| C2 | (a) "ferma per costo stimato 28,7x" | il 28,7x (10/09, stop 51,65 idx, n=4) e' stato **rivisto il 18/09**: stop 27,10 idx (n=5) -> **15,1x** a spread 1,80, **10,4x** con la coda 2,60, sotto il pavimento duro 13,3x, **"NON PASSA, da confermare"**. Sono **limiti inferiori** (distanze realizzate dopo trailing/pareggio). I due stanno **dai due lati del 40**: a buffer 2253 danno 27,6x e 41,2x. Il numero vero e' `[NON MISURATO]` | `CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.412 e §E1; `prove/R163a_...txt` r.380-400 |
| C3 | (a) "tre binari non riconciliati" | a **100k** due round indipendenti danno lo stesso n: **76 / 96** (R110 [LETTO], r163a [MISURATO]); a **10k** n e' 69-71 / 86-87 (R3, r127a). Il divario e' il difetto M45 (n dipende dal deposito), non tre binari indipendenti. Cambia la lettura, non il verdetto | G5 Y01; `LETTURA_CSV_..._B` 4.12 |
| C4 | (a) "28,7x ... misura diretta mai fatta; passata stop SupRev 15-25 min" | `PASSATA_STOP_SUPREV.ps1` misura `ABTG_SupertrendReversal` su **U30USD** con le ancore R243 e **richiede** il log `[STREV-IMBUTO]` (r.142: scarica il sorgente e controlla che lo contenga). L'EA 970913 **non ha** IMBUTO. Per NAS serve una versione nuova | `righe/PASSATA_STOP_SUPREV.ps1` r.60-66, 142 |
| C5 | (b) "celle scelte DOPO aver visto i numeri" | e' vero per la **scelta di 0,15 / 0,20 fra le 5 celle**, ma la **griglia** (0,15 = soglia derivata dal cancello di costo) era scritta prima. E soprattutto la prova **aveva scritto il proprio falsificatore**: "se il PF sale in modo MONOTONO fino a 0,20 mentre n crolla, NON e' un edge: e' selezione di campione". Il PF OOS fa 0,997 / 0,997 / 0,999 / 1,152 / 1,372 mentre n fa 128 / 128 / 118 / 88 / 71. **Il falsificatore e' scattato** | `prove/R125e_...txt` r.55-95; CSV `dal_vps/ABTG_ORB_Ottimizzato/..._r125e.csv` |
| C6 | (e) "profondita' tick dell'oro non verificata" | **misurata**: `XAUUSD: ticks data begins from 2024.07.10` (giornale del tester di R268a, 28/09). R86 parte dal 2024.09.26: **la finestra di K03 e' tutta dentro i tick veri**. Il `[T nominale]` di G6b nasce dal passo 0 di R86, scritto prima di quella misura | `risultati_archivio/ROUND_CORTI_D_2026-09-28/RIEPILOGO_ROUND_CORTI_D.txt` r.33 |
| C7 | (d) "NO PER RISCHIO" per il C2C | vero **per la cella exit 2 a buffer 0,2**. Ma i CSV r146a (tick) in repo mostrano l'asse `InpSLBufferATR` 0,0-0,8: DD OOS 12,1063 -> 5,6764, giornata OOS -6,7316 -> -2,5110, PF OOS 1,74-2,11, n 62-64. G4 lo dava "CSV non nel repo" | `dal_vps/ABTG_CostToCost/..._r146a.csv` `[MISURATO]` |
| C8 | (c) "scala dei P/L non verificata" | confermato e **peggio**: dei 7 valori di r166a lo stop di 225JPY e' noto da **una gamba** (477 idx, n=1) e lo spread da **una lettura fuori sessione Tokyo** (35 pt): 13,6x. La scala (+1461 su 100k in 21 mesi a 0,65% = 18,5 EUR a deal = 0,03 R) fa pensare a lotto troncato `[IPOTESI]` | `CANCELLO_COSTO_FLOTTA` r.487; `LETTURA_..._A` D7 |

---

## 3. CLASSIFICA: VALORE ATTESO / ORE DI PC

**Convenzione dichiarata PRIMA di ordinare**: P(SC-FD) = prodotto di probabilita' dei passi che mancano, **priori miei**; costo = ore di PC delle prime misure (sez. 6); sotto P = 0,05 il rapporto esplode al calare del costo e il candidato viene messo **dopo** quelli sopra la soglia ("sotto la risoluzione").

| # | candidato | P(SC-FD) e come la compongo | ore PC (prime misure) | P / ore | nota |
|---|---|---|---:|---:|---|
| 1 | **(a) SupRev NAS H1 970913** | 0,5 (cancello di costo passa a un buffer <= 4503) x 0,85 (G0 riproduce, nessun blocco nuovo) x 0,7 (merito sospeso accettato + firma) = **0,30** | 0,17-0,28 | **~1,4** | unico con DD ~1% e 16 celle sopra 1 in IS e OOS |
| 2 | **(d) C2C EURJPY** | 0,35 (rischio passa sulla finestra lunga) x 0,5 (costo non blocca) x 0,4 (tick: IS 0,89-0,98, un regime) x 0,9 = **0,06** | 0,13-0,20 | ~0,3 | unico con n >= 150 in IS **e** OOS (a barre) |
| 3 | **(c) SupRev 225JPY H2** | 0,4 (spread orario basso abbastanza) x 0,5 (OOS regge) x 0,6 (scala/R4 ok) x 0,8 = **0,10** | 0,30-0,45 + T1 `[NM]` | ~0,2 | dipende da due misure di costo oggi quasi assenti |
| 4 | **(b) ORB_Ott D30EUR** | **0,02** (falsificatore scattato, PF aggregato 1,087) | 0,05-0,08 | 0,3 (sotto la risoluzione) | si chiude la casella TF e basta |
| 5 | **(e) CrossEma oro K03** | **0,04** (DD OOS 12,30% a 1%; PF dentro il rumore; sorelle d'oro a 22 anni 25-46%) | 0,05-0,08 il primo passo; 0,45-0,67 tutto | 0,07 (percorso intero) | il primo passo e' un interruttore economico |

**Sensibilita'**: se dimezzo P(costo) di (a), il rapporto di (a) scende a ~0,7 e resta sopra tutti gli altri (<= 0,3). L'ordine fra (d), (c), (b) e' dentro il mio rumore: spareggio per "ha una misura che puo' ribaltare il verdetto" e "ha n >= 150 raggiungibile".

---

## 4. LE SCHEDE

### 4.1 (a) SupRev NAS H1, sedia `970913` (`ABTG_SupRev_NAS_H1_Ottimizzato`)

**Stato `[MISURATO]`** (CSV in repo, riletti): r163a, NASUSD H1 tick, 100k, 1%, buffer 2253-4503 passo 375 (7 celle):

| buffer (idx) | IS PF / DD / profitto | OOS PF / DD / profitto |
|---|---|---|
| 2253 (22,53) | 1,5399 / 0,8128 / +1964,39 | 1,5905 / 1,3380 / +2734,64 |
| 2628 (26,28) | 1,4785 / 0,8048 / +1691,20 | 1,5567 / 1,3126 / +2493,14 |
| 3003 (30,03) | 1,5262 / 0,7905 / +1785,73 | 1,5996 / 1,2500 / +2568,49 |
| **3378 (33,78) = centro** | 1,5425 / 0,7706 / +1785,36 | 1,6149 / 1,2332 / +2554,36 |
| 3753 (37,53) | 1,4979 / 0,7575 / +1590,88 | 1,4851 / 1,1889 / +1940,58 |
| 4128 (41,28) | 1,4998 / 0,7379 / +1562,58 | 1,5114 / 1,1717 / +1995,63 |
| 4503 (45,03) | 1,4316 / 0,7948 / +1305,25 | 1,5397 / 1,0988 / +2009,05 |

n = **76 (IS) e 96 (OOS) su tutte e sette le celle**. Escursione PF IS 0,110, OOS 0,130: dentro la banda 0,15 della procedura P1-P8 dei criteri R125 `[DERIVATO]`. Con r127a (10k, buffer 3-3003, 9 celle, tutte sopra 1) sono **16 passate di cella su 16 sopra 1 in IS e OOS** (13 buffer distinti: tre in comune a depositi diversi): **l'asse stop e' un altopiano**, non un picco. DD OOS 1,10-1,34% a 1%. Forward demo 30/07-23/09: 9 righe, +53,48 (campione sottile, non classifica).

**Il numero che MANCA e perche' blocca**: lo **stop iniziale mediano all'ingresso**, in punti indice, e il suo rapporto con lo spread dell'ora. Senza, il cancello C3 e' "sospeso" e la sedia non e' SC-FD. Le due stime in repo (27,10 e 51,65 idx) sono limiti inferiori e a buffer 2253 danno rapporti 27,6 e 41,2: **stanno dalle due parti del 40**, quindi non decidono. Secondari e **non comprabili con un backtest**: n >= 150 posizioni (96 deal in OOS; le posizioni sono `NON LEGGIBILI` nei CSV; tick dal 26/09/2024); regime `NON MISURATO` (laterale 2015-16 su feed esterno: PF 0,664 su 55 uscite; il motore fa 13,3 op/anno su `_EXT` contro 77 sul nativo).

**Via piu' corta**: **una** passata singola a tick, 2024.09.26-2026.06.30, 100k, **due lati insieme**, buffer 2253, che stampa per ogni ingresso `LONG|SHORT mercato <lot> lot @ <entry> SL <sl>`. Poiche' n e' invariante lungo l'asse, lo stop di ogni ingresso a un altro buffer b e' `stop(2253) + (b - 2253)/100` **per algebra esatta** (`risk = baseStop + buf`, sorgente r.248/251): una passata copre le sette celle, etichettate `DERIVATO`. Ingredienti gia' in repo: lo spread orario (`spread_flotta/spread_orario_NASUSD.csv`, 156,1 M tick); il lettore dei log (`PASSATA_STOP_SUPREV.ps1`, da adattare). Bonus: il conteggio delle righe "mercato" da' **le posizioni** (colonna `NON LEGGIBILE` oggi). Non serve ripetere R163a.

**Costo**: tester 7,6-15,3 min per una cella a finestra intera (r163a: 3279-4914 s / 7 celle = 7,8-11,7 min; r127a: 4120-8245 s / 9 celle = 7,6-15,3 min) + avvio/chiusura ~2 min = **10-17 min**. Opzionali: R113 coda "feed o epoca?" (3 celle su `NASUSD_EXT`, ~2 min, **stima di G5, non misurata**); R120a NASUSD (4 file, trailing/flip/frazione mai ad asse, ~31-47 min per analogia r163a) **solo se il costo non passa**, per chiudere la casella 3.

**Attesa scritta prima** (dentro la bozza R290a): stop di base mediano 70-165 idx (ATR(14) H1 del Nasdaq 80,2 `[INFERITO]`, mai misurato), quindi 93-188 a buffer 2253; n entrate 75-172; G0: n deal 172 +/- 3, profitto 4699 +/- 4% (r163a cella 2253, IS + OOS). **Contro-esempio**: l'ipotesi alternativa "lo stop vero e' come le gambe realizzate" da' rapporti 27,6 (NON PASSA) o 41,2 (FRAGILE alto); la mia da' 51-104. **Se la mediana di stop(2253) misurata cade sotto 65, la mia ipotesi e' smentita.**

**Soglie congelate**: C3 PASSA se la mediana di `stop_i / spread_h(i)` (spread = mediana dell'ora server dell'ingresso) >= 40; FRAGILE 36-44; NON PASSA < 36. Equivalenti sullo stop di base (spread 1,80): >= 49,5 / 38,2 / 27,0 idx a buffer 2253 / 3378 / 4503; (spread 2,40): 73,5 / 62,2 / 51,0. Pavimento duro: stop >= 34,6 idx (13,3 x 2,60). Per stress, non per cancello: spread equipesato 2,40 e P95.

**Verdetti possibili**
- **SOPRA** (C3 passa a un buffer <= 4503 con G0 verde): la sedia ha rischio ~1%, PF 1,30-1,72 su 16 passate di cella (a 100k 1,43-1,62), costo misurato. **Diventa SC-FD**: merito sospeso dichiarato (96 deal OOS), regime NM, frequenza di famiglia da misurare; **riaccenderla e il buffer da usare sono firme di Claudio**. Il buffer si sceglie **al centro** dell'altopiano che passa il cancello, mai al bordo: se passa solo a 4503 (bordo; oltre "e' un altro motore", r163a r.514-520) **non e' un centro** e si scrive FRAGILE.
- **FRAGILE** (36-44): non decide; la via e' lo spread di coda o altre ore, non un'altra griglia.
- **SOTTO** (< 36 a ogni buffer <= 4503): **ESCLUSA PER COSTO con misura diretta**, ma **non MORTA**: la casella 3 resta aperta (R120a mai girato).
- **NON MISURATO**: G0 fuori banda (l'EA base non riproduce l'Ottimizzato) o `ESITO LATO: NON AFFIDABILE`: nessun numero di stop si usa.

---

### 4.2 (d) C2C EURJPY H4, sedia `772361` (`ABTG_CostToCost`)

**Stato `[MISURATO]`**: r127c (OHLC [B], 2020.01.01-2026.06.30, 100k): IS 1,17686 / n 153 / DD 10,9946 / giornata -4,2160; **OOS 1,52341 / n 242 / DD 12,2627 / giornata -8,0159**. r146a (tick, 21 mesi, 100k, asse `InpSLBufferATR`): IS n 48-49 PF 0,77-1,02 (0,89-0,98 a 0,4-0,7), **OOS n 62-64 PF 1,74-2,11**, DD OOS 5,68-12,11, giornata OOS -2,51/-6,73. Regimi `_EXT` `[LETTO]`: crollo 2020 PF 0,025 (n 23, DD 14,83%); orso 2022 PF 2,654 ma **giornata -10,07%**. Forward demo: 7 posizioni, PF 0,19, -134,46 EUR (campione sottile). Costo `[LETTO]`: 73,0x senza commissione, **25,6x con commissione**: la lettura da usare e' una decisione del cancello, non mia.

**Il numero che MANCA**: DD e peggior giornata **con il buffer 0,4-0,8 sulla finestra lunga 2020-2026**. E' la finestra che boccia la sedia (il VECCHIO giudica il rischio) e il buffer non ci e' mai stato messo ad asse. Blocca perche' senza quel numero "NO PER RISCHIO" e' vero per una cella (buffer 0,2) e non per il motore.

**Via piu' corta**: **tre file, tutti pronti o quasi**. (1) `R214e` (tick, tre uscite exit 0/1/2) e `R214f` (OHLC lungo, tre uscite): **scritti il 22/09, riga `RIGA_R214EF_COSTTOCOST.txt` con PASS dello strato 2 del 24/09** `[LETTO REGISTRO_TEST.md (radice) r.150]`, **mai girati** (nessun CSV in `dal_vps`, nessuna riga in CODA); attese e soglie gia' congelate dentro i file, compresa "la cella exit 2 e' attesa in bocciatura su C7". (2) **R290b nuovo** (bozza sez. 7): buffer 0,2 / 0,4 / 0,6 / 0,8 sulla finestra di r127c, exit 2 pinnato, 4 celle.

**Costo**: dichiarato tetto 18 min per R214e + R214f (12 passate) `[LETTO CHI_E_PIU_VICINO r.216]`. Analoghi misurati: r146a 9 celle in 228-394 s (25-44 s/cella), r127c 8 celle in 51-99 s (6-12 s/cella): **R214e ~1,3-2,2 min, R214f ~0,3-0,6, R290b ~0,4-0,8 di tester, piu' ~2 min di avvio per job = 8-12 min**.

**Attese scritte prima** (dentro R290b): n invariante (IS 153 +/- 3, OOS 242 +/- 5); DD OOS in calo 7,0-10,5; giornata OOS da -8,02 a -3,5 / -5,5; PF +/- 0,15; canarino di manopola inerte (< 3% relativo a 0,4 = non ha morso). **Contro-esempio**: se la giornata -8,02 non si muove (resta -7 / -9 a tutte le celle) e' un gap OHLC, non una funzione dello stop: **NO PER RISCHIO confermato con una misura in piu'**. Se si muove solo a 0,8, e' un picco.

**Verdetti possibili**
- **SOPRA rischio** (DD <= 9,0 e giornata FTMO > -5,00 in IS e OOS su >= 3 celle contigue): il rischio e' assolto sulla finestra lunga. **Non basta**: resta il costo (25,6x o 73,0x), l'IS tick sotto 1 (0,89-0,98, n 48) e il regime. **SC-FD solo se** anche R214e tiene OOS PF >= 1,10 a tick e il cancello di costo e' letto SOPRA; **la taglia e' di Claudio**.
- **SOTTO**: giornata ferma a -7/-9: NO PER RISCHIO con misura; si archivia **la cella**, e il motore resta NON ANCORA MISURATO (casella 3: R214e/f).
- **NON MISURATO**: l'ancora 0,2 non riproduce r127c alla quinta cifra.

**Taglia**: la taglia che porterebbe la giornata dentro il muro e' una decisione di Claudio e questo piano **non la propone**; ogni riscalatura lineare dei numeri a 1% e' non verificata (lotto troncato, gap).

---

### 4.3 (c) SupRev 225JPY H2, sedia `770901` (`ABTG_SupertrendReversal`; la prova r166a la nomina cosi')

**Stato `[MISURATO]`**: r166a (tick, 2024.09.26-2026.06.30 **intera, FrazioneIS 1,0: nessun OOS**, 100k, **0,65%**, asse `InpSLBufferPips` 3-423 passo 70 in punti Nikkei):

| buffer | PF | n deal | DD | profitto |
|---|---:|---:|---:|---:|
| 3 | 1,535 | 79 | 0,71 | 1461 |
| 73 | 1,436 | 89 | 0,77 | 1034 |
| 143 | 1,434 | 89 | 0,57 | 940 |
| 213 | 1,537 | 89 | 0,45 | 1010 |
| 283 | 1,819 | 89 | 0,37 | 1241 |
| 353 | 1,848 | 89 | 0,32 | 1149 |
| 423 | 1,765 | 88 | 0,29 | 937 |

7 su 7 sopra 1 **ma solo in IS** (stessa finestra su cui si e' scelto). Per la base R5 (sizing corretto, buffer 3) l'OOS esiste: IS 1,542 / OOS 1,653, n 29 / 50, DD 0,65 / 0,88 ("OOS guardata quattro volte") `[LETTO G5 S10]`.

**I numeri che MANCANO** (tre, e il primo e' economico): (1) **spread orario di 225JPY** al momento degli ingressi: oggi **una lettura sola, fuori sessione Tokyo** (35 pt); (2) **distribuzione dello stop**: **una gamba** (477 idx); (3) **OOS** a buffer scelto e **scala/R4** (lotto troncato? `[IPOTESI]`). Blocca perche' il costo e' al pavimento: 477 / 35 = **13,6x** contro 40 (duro 13,3). **Soglie sullo spread, derivate**: per passare il 40 con lo stop 477 serve spread <= **12,0** pt; con buffer 213 <= 17,25; con 353 <= 20,75; con 423 <= 22,5 `[DERIVATO]`. Se la mediana oraria vera e' sopra 22,5, **nemmeno il bordo dell'asse di r166a** passa e la sedia e' ESCLUSA PER COSTO con misura.

**Via piu' corta**: (i) **T1**: riga gia' scritta `RIGA_SPREAD_FLOTTA_TRANCHE_DA_MANDARE.md` (`-Simboli 225JPY -PuntiPerIndice 1 -TimeoutMin 240`, motore `ABTG_SpreadOrario`, "base tick piccola = corsa breve"): **zero codice nuovo**, `blocchi persi` deve essere 0. Pin del 14/09 (post-riparazione); **se la riga ha il PASS di strato 2 non l'ho verificato** `[NON VERIFICATO]`. (ii) passata stop 225JPY H2 con lo script NAS/generalizzato di (a): stessa famiglia di codice, 1 passata ~2-3 min. (iii) **R166b** (WF, FrazioneIS 0,40, stesse 7 celle, 0,65%): 12-20 min per analogia r166a (726-1216 s per 7 celle).

**Costo**: T1 `[NON MISURATO]` (tetto 240 min; il numero di tick di 225JPY e' `[NON MISURATO]`: non scrivo una durata) + ~4-5 min + 14-22 min = **~0,30-0,45 h + T1**.

**Attesa scritta prima** (`[PRIORE MIO]`, nessuna misura dietro): spread mediano dell'ora degli ingressi **8-20 pt**, perche' l'unica lettura (35) e' dichiarata **fuori sessione Tokyo** -> rapporto 24-60x per stop 477. **Contro-esempio**: se la mediana e' ~35 come la lettura unica, il rapporto resta 13,6x e il caso e' chiuso con una misura sola.

**Verdetti possibili**: **SOPRA costo** (mediana oraria <= soglia del buffer scelto, stop misurato su >= 30 ingressi) -> si procede con R166b; **SOTTO** -> ESCLUSA PER COSTO (non MORTA: casella 3 = TrailOnST/ExitOnFlip mai ad asse); **NON MISURATO** se `blocchi persi` > 0. **SC-FD** richiede in piu' l'OOS di R166b con PF >= 1,10 a buffer centrale **e** la scala verificata (lotto vero contro 0,65%).

---

### 4.4 (b) ORB_Ottimizzato D30EUR, `InpMinRangePct` 0,15-0,20 (`r125e`)

**Stato `[MISURATO]`** (D30EUR M5 tick, 100k, 1%, solo long, buffer 2000):

| MinRangePct | IS PF / n / DD | OOS PF / n / DD | PF aggregato `[DERIVATO]` |
|---|---|---|---:|
| 0,00 = 0,05 (identiche: asse inerte) | 1,2562 / 84 / 4,01 | 0,9966 / 128 / 7,49 | **1,087** (n 212) |
| 0,10 | 1,3599 / 72 / 3,02 | 0,9990 / 118 / 7,68 | - |
| 0,15 | 1,2066 / 58 / 3,45 | 1,1519 / 88 / 2,95 | 1,172 (n 146) |
| 0,20 | 1,2222 / 44 / 3,17 | 1,3723 / 71 / 2,31 | 1,316 (n 115) |

**Perche' non si allarga**: (1) il PF **aggregato** della cella senza filtro e' **1,087 < 1,10** su campione pieno: la regola del 19/08 vieta di allargare sui parametri d'ingresso; (2) il **falsificatore scritto nel file prima dei numeri** e' scattato (PF OOS monotono in salita mentre n crolla 128 -> 71; in IS non c'e' monotonia: 1,256 / 1,256 / 1,360 / 1,207 / 1,222); (3) la differenza fra aggregato filtrato e non (1,172 contro 1,087 = 0,085) e' **dentro il rumore di casa A3 = 0,147** `[LETTO R270]`; (4) a spread P95 (2,70) la soglia del costo richiederebbe range >= 0,307%, fuori griglia.

**Il numero che MANCA**: nessuno che un backtest possa comprare per rendere questa cella una sedia: n < 150 in entrambe le finestre e il PF filtrato non e' distinguibile da 1,087. Resta **una casella del certificato**: il **TF** (`InpExecTF` e' sempre 5). **Costo**: 3 celle (1 / 5 / 15) con `MinRangePct` pinnato a **0,15** (la soglia derivata dal cancello, non il picco 0,20): r125e 5 celle in 82-123 s -> circa 16-25 s/cella `[DERIVATO]`, **3-5 min con l'avvio**. **Non ho scritto la bozza** (fuori dai primi 2). **Verdetto atteso**: SOTTO o FRAGILE; **SC-FD: nessun percorso** finche' il PF aggregato e' < 1,10. Con la casella TF chiusa il certificato si compila e il verdetto diventa **MORTO CON CERTIFICATO** o resta NON ANCORA MISURATO se qualche altra casella apre.

---

### 4.5 (e) CrossEma XAUUSD H1 filtro EMA200, cella K03 (`ABTG_CrossEma`, R86c)

**Stato `[MISURATO]`** (`r86_r87_r89_csv/ABTG_CrossEma_XAUUSD_{IS,OOS}_r86coro.csv`, 10k, 1%, EMA 9/21, filtro EMA200, SLatr 1,5, TP_RR 2,0, senza parziale: **deal = posizioni**): **IS PF 1,10689 / n 84 / DD 10,9219 / +619,57; OOS PF 1,18324 / n 119 / DD 12,3006 / +1344,03**. Delle 8 celle CrossEma, **7 sfondano il muro DD 15% di R86** `[LETTO G6b]`; K03 e' l'unica dentro quel muro, ma **sopra il 10% a 1%**: alla taglia 1% fallirebbe il cancello 1 di sez. 1, a taglia ridotta no (**taglia: di Claudio**). Margine PF OOS 0,183 contro il rumore di casa A3 = 0,147 (trattato come scarto tipico, `[INTERPRETAZIONE MIA]`): **z = 1,25**; IS 0,107: z = 0,73.

**I numeri che MANCANO**: (1) **DD sui 22 anni a barre** dell'oro (il VECCHIO giudica il rischio): mai misurato per CrossEma; le sorelle sull'oro li hanno: EMA200_Ott **45,91%** (contro 4,40% promesso), GoldenCross **25,18%** a 1%, MaxMin oro **10,30% a 0,5%**; (2) n >= 150 per finestra: 84 / 119; (3) tre caselle del certificato: uscita (`InpTP_RR`, `InpSLatr`, trailing, parziale, BE mai ad asse), TF (solo H1), gemelli (XAU e D30EUR; D30EUR K07: OOS 1,021, DD IS 18,42).

**Via piu' corta, a due passi**. **Passo 1 (interruttore)**: K03 invariata su **XAUUSD H1 a barre dal 2004.06.11 al 2026.06.30** (M1 gold dal 2004.06.11 per il giornale di R268d): una cella, 2 passate. Costo per analogia **r127b** (XAUUSD H4, 2004-2026, 12 celle in 617-1187 s = 51-99 s/cella): **1-3 min con l'avvio ~3-5 min**. **Passo 2**, solo se DD 22 anni <= 10% a 1%: TF (H2, H4, M30), gemelli e un asse d'uscita alla volta, **~25-35 min** `[LETTO G6b; R86: 1,6-2,2 min/file XAU, 0,5-0,6 D30EUR]`.

**Attesa scritta prima**: DD 22 anni **> 15%** a 1% (le tre sorelle d'oro stanno fra 10,3% a mezzo punto e 45,9%); P(<= 10%) = 0,1. **Contro-esempio**: se il DD 22 anni uscisse <= 10%, la lettura facile sarebbe "rischio assolto": **sarebbe falsa da sola**, perche' le 22 anni a barre hanno PF screening e `[T nominale]` per il solo oro prima del 2024. **Soglie**: DD 22 anni <= 10,0 a 1% e peggior giornata > -5,0.

**Verdetti**: **SOTTO rischio** (DD > 10%): **NO PER RISCHIO con misura** a taglia 1%; non morto (caselle 3, 5 aperte). **SOPRA** (<= 10%): passo 2. **SC-FD**: richiede anche n >= 150 per finestra (203 operazioni in 21 mesi = 9,6/mese: ne servono ~100 in piu', circa 10 mesi) o accettare il merito sospeso.

---

## 5. CERTIFICATO DI MORTE A 5 CASELLE (per chi e' "scartato" o "non allargato")

| candidato / cosa si scarta | 1 PF | 2 n + DD | 3 uscita ad asse | 4 gemelli | 5 TF | verdetto |
|---|---|---|---|---|---|---|
| (a) SupRev NAS, **se SOTTO per costo** | si (r127a, r163a, R3, R110) | si | **parziale**: buffer 16 celle; TrailOnST / ExitOnFlip / FirstFraction mai (R120a NASUSD scritto, non girato) | si (DAX, Dow, CAC, oro) | si (11 TF) | **NON ANCORA MISURATO** |
| (b) ORB_Ott D30EUR `MinRangePct` > 0,20 (non allargare) | si | si | **parziale**: buffer (r125c), parziale (r125b U30USD), lato (r125d) | si (U30USD r125a/b, NASUSD r125f) | **NO** (`InpExecTF` sempre 5) | **NON ANCORA MISURATO**; non si allarga per regola 19/08 |
| (c) buffer 225JPY oltre 423 | si | si (DD) | parziale (SLBufferPips; TrailOnST ecc. mai) | si (10 simboli) | si (11 TF) | **NON ANCORA MISURATO**; non si allarga (altro motore) |
| (d) cella exit 2 buffer 0,2 (**si archivia la cella, non il motore**) | si | si | **parziale**: SLBufferATR su tick (r146a), MaxBarsHold inerte; **exit 0/1 non ancora (R214e/f)** | si (48 simboli) | parziale (H1 catastrofico, H4; M30, H2, D1 mai) | cella **NO PER RISCHIO** (fatto); motore **NON ANCORA MISURATO** |
| (e) CrossEma K03 | si | si | **NO** (TP_RR, SLatr, trailing, parziale, BE mai) | parziale (XAU, D30EUR) | **NO** (solo H1) | **NON ANCORA MISURATO** |

Nessun candidato e' MORTO. Se una misura di questo piano dice SOTTO, il verdetto scritto e' "ESCLUSO PER COSTO / NO PER RISCHIO **con misura**", col numero accanto e le caselle aperte, in `REGISTRO_TEST.md`.

---

## 6. COSTO IN TEMPO MACCHINA, CON LA FONTE

Tutti i tempi: `REFERTO_RUNNER_*.txt` (righe `ESEGUITO in N s`), sul **banco VPS `C:\MT5_Backtest`** durante il runner delle 03:30, **macchina in contesa** (le notti piu' recenti sono le piu' veloci). Il **PC `DESKTOP-H4D7CAJ` e' `[NON MISURATO]`**: leggere come +/- 50%.

| misura | minuti di tester | + avvio (~2 min/job) | fonte dell'analogo |
|---|---:|---:|---|
| (a) passata NAS L+S, 1 cella a finestra intera | 7,6-15,3 | 10-17 | r163a 3279-4914 s / 7 celle; r127a 4120-8245 s / 9 celle |
| (a) R113 feed o epoca (opz.) | ~2 | - | stima G5, **non misurata** |
| (a) R120a NASUSD (opz., se SOTTO) | 31-47 | 33-49 | 4 celle x r163a |
| (d) R214e (tick, 3 celle) | 1,3-2,2 | | r146a 9 celle in 228-394 s |
| (d) R214f (OHLC, 3 celle) | 0,3-0,6 | | r127c 8 celle in 51-99 s |
| (d) R290b (OHLC, 4 celle) | 0,4-0,8 | | r127c idem |
| (d) totale | 2-4 | **8-12** (tetto dichiarato 18) | |
| (c) T1 spread 225JPY | `[NON MISURATO]` (tetto 240) | | riga `..._TRANCHE_...` |
| (c) passata stop 225JPY | 2-3 | 4-5 | r166a 726-1216 s / 7 celle |
| (c) R166b WF 7 celle | 12-20 | 14-22 | r166a |
| (b) TF 3 celle | ~1 | 3-5 | r125e 82-123 s / 5 celle |
| (e) passo 1, 22 anni a barre | 1-3 | 3-5 | r127b 617-1187 s / 12 celle |
| (e) passo 2 (opz.) | 25-35 | | `REFERTO_R88.txt`: 1,6-2,2 min/file XAU |

**Totale prime misure**: 10-17 + 8-12 + (4-5 + 14-22) + 3-5 + 3-5 = **42-66 min + T1**. **Con tutti gli opzionali**: + 2 + 33-49 + 25-35 = circa **100-150 min (1,7-2,5 h) + T1**. Il lancio non e' parallelizzabile: MT5 e' un solo terminale e il tester usa tutte le CPU (incidente del 21/09: **mai sul VPS**).

---

## 7. LE DUE BOZZE (a) E (d)

Entrambe sono **bozze, NON passate dal cancello**. Hanno superato `controlla_prova.py` (sez. 10); **non** hanno superato lo strato 2. Se passano, vanno copiate in `backtest_pipeline/prove/` e la riga di lancio si costruisce **dopo**. Magic `799810` e `799820`: nessuna occorrenza in `backtest_pipeline`, `report`, `mql5`, `HANDOFF.md` il 06/10; il blocco 7998xx-7999xx e' libero a oggi (collisioni con worktree altrui `[NON VERIFICATE]`: lo ricontrolla il cancello).

### 7.1 Bozza R290a - la passata di stop su NASUSD per la sedia 970913

```text
# ==========================================================================
#  EA: ABTG_SupertrendReversal
#  R290a -- BOZZA 06/10/2026, NON passata dal cancello (strato 2 DA FARE).
#  LA DISTANZA INGRESSO->SL DELLA SEDIA 970913 (NASUSD H1), MISURATA.
#  UNA passata singola a tick reali, DUE LATI INSIEME (come gira la sedia).
#  Finestra 2024.09.26 -> 2026.06.30, deposito 100000.
# ==========================================================================
#  CHE COSA MISURA, UNA COSA SOLA
#    La distanza fra prezzo d'ingresso e SL di ogni ingresso a mercato
#    (riga "[STReversal] LONG|SHORT mercato <lot> lot @ <entry> SL <sl>"),
#    con la geometria della cella di r163a a buffer 2253. Il numero dice se
#    il cancello di costo "stop >= 40 x spread" passa, sulla sedia, con una
#    MISURA e non con una stima. Le stime in repo sono due LIMITI INFERIORI:
#    27,10 idx (n=5) e 51,65 idx (n=4), distanze REALIZZATE di gambe chiuse
#    in stop dopo trailing/pareggio (CANCELLO_COSTO_FLOTTA E1;
#    R163a r.380-400). Il "28,7x" del 10/09 e' stato rivisto il 18/09 a
#    15,1x (coda 10,4x); nessuno dei due e' una misura dell'ingresso.
#
#  PERCHE' L'EA BASE E NON L'OTTIMIZZATO
#    ABTG_SupertrendReversal ha il log [STREV-IMBUTO] che il lettore della
#    passata usa come CONTROLLO INCROCIATO (somma ENTRATE = righe "mercato").
#    ABTG_SupRev_NAS_H1_Ottimizzato non ce l'ha. Il diff dei due sorgenti
#    (06/10/2026) mostra, oltre ai contatori IMBUTO e alla chiusura del
#    venerdi', SOLO i default (TF H4->H1, StMult 3,5->3,0, TP_RR 2,0->3,0,
#    magic, commento): SL = MathMin(stLine,ext) -/+ buf identico (base
#    r.386-389, Ott r.244-250). Questa e' un'INFERENZA SUL SORGENTE: la
#    verifica e' G0 (sotto), non questa frase.
#
#  PERCHE' BUFFER 2253 (22,53 idx) E NON 3
#    (1) e' la cella in comune di r127a e r163a: riproducibile a 100k;
#    (2) in r163a n resta 76 (IS) e 96 (OOS) su TUTTE e sette le celle
#        2253..4503: le entrate sono le stesse, quindi lo stop di ogni
#        ingresso si sposta ESATTAMENTE di (buf - 2253)/100 idx
#        (risk = baseStop + buf, sorgente r.248/251). Una passata sola
#        copre l'asse 2253..4503 per ALGEBRA, etichettata DERIVATO.
#    Il preset in campo ha buffer 3 (0,03 idx): se la sedia tornasse, il
#    buffer e' una scelta di Claudio, non di questo file.
#
#  G0 -- CONTROLLO DI RIPRODUZIONE, SCRITTO PRIMA DEI NUMERI
#    r163a cella 2253 (100k, tick): IS 1,5399 / 76 deal / DD 0,8128 /
#    +1964,39; OOS 1,5905 / 96 deal / DD 1,3380 / +2734,64.
#    Questa passata e' a finestra intera: il n atteso e' 172 +/- 3 (un
#    ingresso a cavallo del 2025.06.10 puo' contarsi diverso), il profitto
#    atteso 4699 +/- 4% (le due finestre di r163a ripartono da 100k, questa
#    capitalizza). Fuori banda: l'EA base NON riproduce l'Ottimizzato, si
#    FERMA e nessun numero di stop si usa.
#
#  ATTESA, SCRITTA PRIMA DEI NUMERI
#    Mediana dello stop DI BASE: 70-165 idx, quindi 93-188 a buffer 2253.
#    Fonte: ATR(14) H1 del Nasdaq 80,2 idx [INFERITO: nessun ATR misurato
#    su NASUSD, CANCELLO_COSTO §C]; lo stop e' l'estremo di 5 barre H1 o la
#    linea Supertrend, quindi attorno a 1 ATR o piu'. Ingressi a mercato
#    (posizioni): fra 75 e 172 (rapporto deal/posizione documentato
#    1,00-2,31).
#
#  SOGLIE CONGELATE ORA
#    S1 spread di riferimento = mediana oraria dell'ORA SERVER di ogni
#       ingresso, da spread_flotta/spread_orario_NASUSD.csv (156,1 M tick).
#    C3 PASSA se la MEDIANA di (stop_i / spread_h(i)) >= 40; FRAGILE se
#       cade fra 36 e 44; NON PASSA sotto 36. Valutata a b=2253 (misura) e
#       a b=3003, 3378 (centro), 4503 (derivata). Pavimento duro 13,3 x
#       spread di coda 2,60: stop >= 34,6 idx.
#    Per stress, NON come cancello: spread equipesato 2,40 e P95 2,60.
#    Soglia equivalente sul solo stop di base (spread 1,80): 49,5 / 38,2 /
#    27,0 idx a b = 2253 / 3378 / 4503; (spread 2,40): 73,5 / 62,2 / 51,0.
#
#  CONTRO-ESEMPIO, COSTRUITO PRIMA
#    Ipotesi alternativa = "lo stop vero e' piccolo come le gambe realizzate".
#    I due limiti inferiori in repo STANNO DALLE DUE PARTI del cancello:
#    base 27,10 -> stop(2253) 49,6 -> rapporto 27,6 (NON PASSA); base 51,65
#    -> stop 74,2 -> rapporto 41,2 (FRAGILE alto). La mia ipotesi (stop da
#    ATR) darebbe stop(2253) 93-188 e rapporto 51-104 (PASSA). Se la mediana
#    misurata cade sotto 65 la mia ipotesi e' SMENTITA; la zona 65-80 di
#    stop(2253) (rapporto 36-44) e' dichiarata FRAGILE e NON decide.
#
#  BUCHI DICHIARATI
#    - il lato lungo e il corto vanno riportati SEPARATI (regola dei due
#      lati, 25/08): il lettore deve tagliare per lato di ogni ingresso;
#    - lo script PASSATA_STOP_SUPREV.ps1 a HEAD e' cablato su U30USD e sulle
#      ancore R243: per questa prova serve una versione NAS, NUOVA e quindi
#      da far passare dai due strati. Questo file NON la sostituisce;
#    - velocita' del PC di backtest DESKTOP-H4D7CAJ: [NON MISURATA].
#  BERSAGLIO: PC DI BACKTEST DESKTOP-H4D7CAJ. NON il VPS, NON il piccolo
#    50503392, NON il 100k 50504263, NON il reale 10105439, NON FTMO
#    541452707. Questo file NON LANCIA NIENTE.
# ==========================================================================
@SIMBOLO  NASUSD
@PERIODO  H1
@DAQUANDO 2024.09.26
@FINOA    2026.06.30
@FRAZIONEIS 0.40

# --- DUE LATI INSIEME: e' la sedia com'e'
InpAllowLong=true
InpAllowShort=true

InpTF=16385

# --- geometria 970913, stessi valori di r127a/r163a
InpStMult=3.0
InpStAtrPeriod=10
InpTP_RR=3.0

# --- stop: l'unico valore diverso dal preset in campo (buffer 3) e'
# --- 2253, cella in comune con r127a e r163a
InpSLLookback=5
InpSLBufferPips=2253

InpNearAtr=1.0
InpRequireConfirmBody=true

InpUseConfluence=true
InpEma1=14
InpEma2=89
InpEma3=100
InpEma4=200
InpConflAtr=1.5

InpTP1_R=1.0
InpTP1Pct=50.0
InpBreakeven=true
InpTrailOnST=true
InpExitOnFlip=true

InpFirstFraction=0.3333
InpUsePending=true
InpPendingPips=20.0
InpPendingExpiryBars=3

InpRiskPercent=1.0
InpMaxTradesPerDay=0

InpStartHour=0
InpEndHour=24

InpUseNewsFilter=false
InpNewsMinImpact=3
InpNewsBeforeMin=30
InpNewsAfterMin=30
InpNewsShiftMinutes=0

InpComment=R290A STOP NAS
InpFridayClose=false
InpFridayCloseHour=20
InpUsaGuardian=true
InpMagic=799810
InpMaxSpread=0
InpVerbose=true
InpLogImbuto=true

# --- asse unico: l'interruttore della finestra oraria, come in R243. Qui
# --- si legge SOLO la cella 0 (finestra SPENTA = la sedia com'e'); la cella
# --- 1 (14-22 server) e' il meccanismo di R238 e NON e' questa domanda.
InpUseTimeWindow=0||0||1||1||Y
```

**Cosa serve prima che questa prova giri** (non e' scritto qui, e non lo scrivo io):

```text
SCRIPT NUOVO  backtest_pipeline/righe/PASSATA_STOP_SUPREV_NAS.ps1   (marcatore MARCATORE_PASSATA_STOP_SUPREV_NAS_v1)
  derivato da PASSATA_STOP_SUPREV.ps1 (v2, PASS 24/09). Differenze da fare, TUTTE:
   r.55-56   $SIMBOLO 'U30USD' -> 'NASUSD' ; $PERIODO 'H1' (invariato)
   r.60-63   $LATI : UNA sola prova, 'R290a_stop_SUPREV_NASUSD_LS_ancora970913.txt', Long=true Short=true
             (il taglio per lato si fa sul lato di OGNI ingresso, non su due passate)
   r.66      $ANCORA : InpStMult=3.0 InpStAtrPeriod=10 InpNearAtr=1.0 InpTP_RR=3.0 InpSLLookback=5
             InpSLBufferPips=2253 InpUsaGuardian=true InpAllowLong=true InpAllowShort=true
   r.67      $AVVIO_ATTESO 'avviato su NASUSD PERIOD_H1. Supertrend(10,3.0).'
   verdetto  mediana di stop_i / spread_h(i) con spread da spread_orario_NASUSD.csv,
             soglie 40 / 36-44 / 36 della prova; per lato; derivata a 3003 / 3378 / 4503
   G0        legge il report .htm: n deal 172 +/- 3, profitto 4699 +/- 4%; fuori banda = STOP
  INVARIATI: controllo incrociato IMBUTO, controllo configurazione, AllowLiveTrading=false,
  guardia macchina DESKTOP-H4D7CAJ, guardia MT5 aperto, timeout 60 min.
RIGA DI LANCIO (bozza di schema, NON eseguibile: manca il pin e manca lo script):
  scheletro di RIGA_PASSATA_STOP_SUPREV.txt con:  $PIN = <commit che contiene lo script NAS, da ricavare
  con git log -1 --format=%H -- <percorso> DOPO il commit> ; irm dello script NAS dal pin ;
  controllo del marcatore v1 ; stessa guardia macchina e MT5-chiuso ; stesso blocco di raccolta/zip.
  Messaggi a schermo: tempo atteso 10-17 min per UNA passata, non fermarla prima di 45 min.
  File attesi nello zip: RIEPILOGO_PASSATA.txt + STOP_NAS.csv + passata_NAS.ini (+ per-trade e .htm se trovati).
BERSAGLIO da scrivere in testa alla riga: finestra PowerShell sul PC di backtest DESKTOP-H4D7CAJ (che apre
  e chiude da solo il SUO terminale); NON toccati: VPS VMI3047753 e tutte le sue cartelle dati (FTMO
  541452707, 100k 50504263, piccolo 50503392, manuale 50503635, banco 50504400, Pepperstone, Tickmill)
  e il reale 10105439.
```

### 7.2 Bozza R290b - il buffer dello stop del C2C EURJPY sulla finestra lunga

```text
# ======================================================================
#  EA: ABTG_CostToCost
#  R290b -- BOZZA 06/10/2026, NON passata dal cancello (strato 2 DA FARE).
#  IL BUFFER DELLO STOP (InpSLBufferATR) SULLA FINESTRA LUNGA.
#  EURJPY H4, LONG-ONLY, exit 2, 2020.01.01 -> 2026.06.30, OHLC M1.
#  Asse unico: InpSLBufferATR 0,2 / 0,4 / 0,6 / 0,8. 4 celle, 8 passate.
# ======================================================================
#  GIRA SUL PC DI BACKTEST, NON SUL VPS (firma del 21/09). -Deposito
#  100000 -Modello 1 (OHLC: e' lo stesso modello dell'ANCORA r127c; un
#  numero a modello diverso non si confronta). SCREENING, NON VERDETTO.
#
#  PERCHE' ESISTE
#    Sui tick (r146a, 21 mesi, CSV ora in repo) l'asse SLBufferATR 0,0-0,8
#    ha ABBASSATO il rischio senza toccare il PF OOS: DD OOS 12,1063 (0,0)
#    -> 7,3634 / 7,0700 / 6,8018 / 5,8697 / 5,6764 (0,4 / 0,5 / 0,6 / 0,7 /
#    0,8); peggior giornata -6,7316 -> -3,2700 / -3,0512 / -2,8776 /
#    -2,6856 / -2,5110; PF OOS 1,74-2,11, n 62-64. MA quella finestra ha un
#    solo regime e IS 48 operazioni con PF 0,89-0,98 a 0,4-0,7.
#    Il VECCHIO giudica il RISCHIO (Emendamento B): il -8,0159 di r127c
#    (OOS 2022.08-2026.06) e il -10,07 dell'orso 2022 su feed esterno sono
#    i numeri che bocciano la sedia. Nessuno ha mai messo il buffer ad asse
#    su QUELLA finestra. Questo file lo fa.
#
#  L'ANCORA (cella 0,2) DEVE RIPRODURRE r127c a InpMaxBarsHold 100, come
#  R214f:  IS 1,17686 / n 153 / DD 10,9946 / giornata -4,2160;
#          OOS 1,52341 / n 242 / DD 12,2627 / giornata -8,0159.
#  Se la cella 0,2 NON riproduce alla quinta cifra, si FERMA: il banco non
#  sta girando la storia di r127c e nessun'altra cella si legge.
#
#  ATTESA, SCRITTA PRIMA DEI NUMERI (il segno, non la taglia)
#    - n: INVARIANTE lungo l'asse (a tick 48-49 / 62-64): IS 153 +/- 3,
#      OOS 242 +/- 5. Se cambia di piu', l'asse ha cambiato le ENTRATE e il
#      confronto col tick non vale.
#    - DD OOS: in calo con il buffer, banda 7,0-10,5 a 0,4-0,8.
#    - Peggior giornata OOS (colonna FTMO in coda al CSV): da -8,02 a
#      -3,5 .. -5,5.
#    - PF: invariato entro +/- 0,15 (rumore di casa A3 = 0,147, LETTO R270).
#    - CANARINO DI MANOPOLA INERTE: se a 0,4 DD e giornata OOS differiscono
#      da quelli di 0,2 per meno del 3% relativo, il buffer NON HA MORSO su
#      questa finestra e i valori 0,4-0,8 non si citano.
#
#  SOGLIE CONGELATE ORA
#    G-RISCHIO (a qualunque n): in IS e in OOS, su almeno 3 celle contigue,
#      DD <= 9,0 e peggior giornata FTMO > -5,00 (a 1,00% di rischio: la
#      TAGLIA e' di Claudio, qui non si tocca). Il centro del blocco decide.
#    G-MERITO: n >= 150 SOLO in IS (153). Il PF e' screening OHLC: non
#      promuove.
#    Contro-esempio: se la giornata -8,02 NON si muove (resta -7 .. -9 a
#      tutte le celle) e' un gap OHLC, non una funzione dello stop: la
#      sedia resta NO PER RISCHIO con una misura in piu'. Se si muove ma
#      solo a 0,8 (una cella che sporge) e' un picco, non un altopiano.
#
#  COSTO (cancello stop >= 40 x spread): NON misurato qui. Letture in
#    repo: 73,0 x senza commissione, 25,6 x con commissione (G4 §4.2 p.5):
#    se la commissione conta, il 40 non passa nemmeno col buffer 0,8 senza
#    una misura dello stop. Decisione sulla lettura: NON di questo file.
#  BUCHI: nessun per-trade -> la data della peggior giornata non si legge;
#    R214e/R214f (uscite 0/1/2) sono un'ALTRA variabile e restano file
#    separati. Modello OHLC: DD = limite inferiore.
#  BERSAGLIO: PC DI BACKTEST DESKTOP-H4D7CAJ. NON il VPS, NON il piccolo
#    50503392, NON il 100k 50504263, NON il reale 10105439, NON FTMO
#    541452707. Questo file NON LANCIA NIENTE.
# ======================================================================

@SIMBOLO    EURJPY
@PERIODO    H4
@DAQUANDO   2020.01.01
@FINOA      2026.06.30
@FRAZIONEIS 0.40

# --- IL MOTORE: copiato riga per riga da prove/R214f_uscite_COSTTOCOST_
# --- EURJPY_ohlc_lungo.txt (cella viva). Cambiano il magic e l'asse.
InpUsaGuardian=true
InpTF=16388
InpTP_R=1.5
InpAtrPeriod=14
InpMinRangeATR=0.0
InpMaxBarsHold=100
InpWarmupBars=500
InpAllowLong=true
InpAllowShort=false
InpMaxSpreadPts=300
InpEntryWindowBars=3
InpExitMode=2
InpRiskPercent=1.0
InpComment=R290B BUFFER OHLC
InpMagic=799820
InpVerbose=false
InpFtmoDayHourServer=23
InpFtmoOrologio=1
InpFtmoBcmFissoDal=20250101

# --- L'UNICO ASSE: il buffer dello stop in ATR. 4 celle: 0,2 (ancora),
# --- 0,4 / 0,6 / 0,8. Gli stessi valori di r146a a tick.
InpSLBufferATR=0.2||0.2||0.2||0.8||Y
```

**Riga di round (bozza di schema, NON eseguibile)**. Scheletro di `backtest_pipeline/righe/RIGA_ROUND_CORTI_D_R268_R269.txt` (guardie macchina `DESKTOP-H4D7CAJ`, MT5 chiuso, `RIGA_ROUND_VPS.ps1` scaricato dal pin con **SHA256 verificato**, raccolta + zip) con **un solo job**:

```text
job:   t='R290b'  e='ABTG_CostToCost'  s='EURJPY'  p='R290b_buffer_COSTTOCOST_EURJPY_ohlc_lungo.txt'
       m=1  dp=100000  sm='_ohlc'  nr=4  ax='InpSLBufferATR'  av=@(0.2,0.4,0.6,0.8)  d0='2020.01.01'  d1='2026.06.30'
chiamata del driver (identica a quella dei CORTI):
  RIGA_ROUND_VPS.ps1 -Expert ABTG_CostToCost -Prova R290b_buffer_COSTTOCOST_EURJPY_ohlc_lungo.txt
                     -Etichetta r290b -Pin <pin> -Modello 1 -Deposito 100000
Prima: -SoloControllo deve stampare 4 CELLE per finestra (non guardare "-> N pass": e' un x2 cablato).
Da accodare nello stesso lancio, nell'ordine: R214e, R214f (stesso pin 529fefa0, gia' con PASS), poi R290b.
```

**Hash e pin** non li calcolo: il pin e' il commit che contiene i file, e non esiste finche' i file non sono in repo e passati dal cancello.

---

## 8. VERIFICA DI NON-DUPLICAZIONE (misure gia' pagate)

| file prova / round | girato? | evidenza | cosa significa qui |
|---|---|---|---|
| R163a (NAS buffer 2253-4503) | **SI** | referti runner 17-20/09 (4 notti, uscita 0); CSV in `dal_vps/ABTG_SupRev_NAS_H1_Ottimizzato/`; riga CODA r.2158 ora `[SOSPESO 21/09]` | **non rifare**; G5 lo dava "NM" |
| R127a (NAS buffer 3-3003) | SI | 7 notti (14-20/09), 4120-8245 s | non rifare |
| R113 (regime NASUSD_EXT, 18 lanci) | SI (27/08) | `R113_CORSA_20260827/` | la **coda "feed o epoca?"** e' NUOVA: **non ho trovato un file prova scritto** `[NON VERIFICATO]` |
| R120a NASUSD (trailing/flip) | **NO** | 4 file prova, nessun CSV, nessuna riga CODA | da fare solo se (a) e' SOTTO |
| PASSATA_STOP_SUPREV | **NO** | nessun `STOP_*.csv` / `RIEPILOGO_PASSATA` in repo | e' su U30USD: non risponde a NAS |
| r125e (MinRangePct) | SI | 7 notti (14-20/09), 82-260 s | non rifare |
| r166a (225JPY buffer, intera) | SI | 4 notti (17-20/09), 726-1216 s, uscita 2 (OOS vuoto per costruzione) | l'OOS **non esiste**: R166b e' nuovo |
| r127c (C2C OHLC lungo, MaxBarsHold) | SI | 8 notti (13-20/09), 51-99 s, uscita 3 = "girato con rilievi" | non rifare; l'asse buffer **non c'e'** |
| r146a / r146c (C2C tick, SLBufferATR) | SI | CSV in `dal_vps/ABTG_CostToCost/` | non rifare |
| R214e / R214f | **NO** | nessun CSV, nessuna riga in CODA, riga `RIGA_R214EF` con PASS 24/09 | **pronte, pagabili** |
| R86c XAUUSD (K03) | SI | `REFERTO_R88.txt`: 1,7 min | non rifare; il passo 1 di (e) e' una finestra nuova |
| T1 spread 225JPY | **NO** | `spread_flotta/` ha 3 file (NAS, U30, D30) | pronta (da verificare il PASS) |

`backtest_pipeline/REGISTRO_TEST.md` (4635 righe) e il `REGISTRO_TEST.md` di radice **non contengono** le righe di r163a, r125e, r166a (arrivati con i CSV del 05/10): ne manca la registrazione `[BUCO DI REGISTRO, non lo tocco]`.

---

## 9. BUCHI, DUBBI E DECISIONI CHE NON SONO MIE

**Buchi dichiarati**
- Ritmo del PC di backtest `[NON MISURATO]`; tutti i tempi sono del banco VPS in contesa.
- T1 (spread 225JPY): durata `[NON MISURATO]`.
- Posizioni di 970913: `NON LEGGIBILI` nei CSV; la passata R290a le conta.
- Equivalenza EA base / Ottimizzato: **inferenza sul diff dei sorgenti**, non verificata a tester; la verifica e' G0.
- Stato attuale di 970913 sul piccolo dopo il censimento del 29/09: `[NON VERIFICATO]` (tolta il 25/09; il profilo ORO ha 25 grafici dal 26/09).
- Il valore del lotto di 225JPY e il troncamento: `[IPOTESI]`.
- R113 "feed o epoca": nessun file prova trovato.
- Frequenza di famiglia SupRev: `[NON MISURATA]`; 96 deal OOS in ~12,6 mesi = ~0,35 deal/giorno per sedia (in posizioni meno).

**Dubbi**: i P di sez. 3 sono giudizi; il costo di (a) puo' ribaltarsi dentro la zona FRAGILE; il buffer 2253 e' una cella di misura, non una scelta.

**Decisioni che servono a Claudio** (non sono mie e non le prendo): (1) se la lettura SC-FD di sez. 1 e' quella giusta; (2) via libera a **lanciare** sul PC di backtest (nessuna riga esiste ancora: passano i due strati); (3) riaccendere 970913 e con quale buffer (e' una scelta sulla gestione dell'uscita che cambia il lotto: la dichiaro come sua); (4) la lettura del costo con o senza commissione per il C2C; (5) la taglia, per (d) ed (e), solo dopo i numeri.

---

## 10. CONTROLLI FATTI (Sviluppatore / Agente dei Controlli)

**Contro-esempi costruiti da me**
- *"R163a va rifatto per la passata."* No: e' gia' girato 4 volte, n invariante sulle 7 celle: l'algebra dello stop copre l'asse. Costruito dal sorgente (`risk = baseStop + buf`).
- *"I due limiti inferiori dicono 15x e 28x, quindi (a) e' morta per costo."* No: a buffer 2253 i due limiti danno 27,6 e 41,2 (stanno **dai due lati del 40**); la misura puo' dire entrambe. La banda e' scritta prima.
- *"Il PF sale con il filtro quindi (b) e' un'idea."* La prova stessa ha scritto il falsificatore e il numero lo ha acceso (128 -> 71 con PF OOS in salita monotona). Aggregato 1,087 -> 1,172 dentro A3 = 0,147.
- *"Il buffer del C2C abbassa il DD quindi (d) e' salva."* Il tick e' un solo regime con IS < 1; la finestra lunga e' l'unica che puo' smentire. Il contro-esempio ("la giornata e' un gap OHLC e non si muove") e' nella bozza.
- *"La profondita' tick dell'oro e' un blocco."* No, misurata 2024.07.10; non vale per prima del 2024 (22 anni a barre = screening).
- *Conti ricalcolati con script* (non a memoria): PF aggregati di r125e (1,087 / 1,172 / 1,316), soglie spread e stop di (a) e (c), tempi per cella, z di K03.

**Cosa NON ho verificato**: i CSV R110 (fuori repo), l'esecuzione di R214e/f oltre l'assenza di CSV, l'esistenza di collisioni di magic fuori da questo checkout, il PASS di strato 2 della riga T1, la lettura del per-trade di r163a sul banco.

**Esiti del cancello meccanico** (6/10/2026): vedi riga finale di questo file, scritta dopo i comandi.
