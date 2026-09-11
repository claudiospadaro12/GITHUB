# R127 -- LE MANOPOLE DELL'USCITA MAI MESSE AD ASSE -- CRITERI CONGELATI

> **Questi criteri si leggono PRIMA dei numeri. Data: 11/09/2026.**
> Se un numero di questo round viene letto senza questa pagina davanti, non
> vuol dire niente. Regola di casa, non formalita'.
>
> **STATO: NON FIRMATO.** Nessuna cella di R127 e' mai girata (verificato:
> nessun CSV `r127*` nel repo, 11/09/2026). La firma e' di Claudio, non mia.
>
> **ASCII PURO, apposta** (classe 202 del 10/09): cosi' questa pagina passa
> dalla porta `--ps1` di `controlla_riga.py` e i controlli meccanici girano
> davvero. Le emoji restano nei referti e nei messaggi in chat.

---

## 0. LA DOMANDA DEL ROUND, in una riga

**Su tre sedie vive che stanno a ridosso di un cancello, la manopola
dell'USCITA che nessuno ha MAI mosso vale abbastanza da spostare il verdetto,
e di quanto costa in merito?**

Non e' "quale valore fa il PF piu' alto". Il PF di queste tre celle lo
conosciamo gia' e non e' mai stato il problema.

---

## 1. DA DOVE NASCE (fatti misurati, non opinioni)

1. **Censimento del 11/09/2026** (`report/CENSIMENTO_USCITE_MAI_PROVATE_2026-09-11.md`):
   su 41 sedie vive e 333 coppie (sedia x manopola d'uscita), **274 coppie
   non sono MAI state mosse su quella sedia**; **65 coppie (EA x manopola)
   non hanno MAI preso due valori in NESSUNO dei 2.087 CSV con colonne `Inp*`
   del repo**. Le tre manopole di questo round stanno tutte e tre in
   quest'ultimo gruppo.
2. **R46 (14/08, tick reali, fuori campione, ingresso identico e pinnato per
   nome)**: la sola struttura d'uscita muove il PF da **0,88 a 1,49** e il DD
   da **22,50% a 6,27%** sul DAX. Fonte:
   `risultati_archivio/REFERTO_ROUND46_GESTIONE.md`.
3. **La larghezza dello stop e' la leva che governa insieme DD e pedaggio**:
   misurato tre volte in casa (R55 budget del pedaggio, R88 OPPRANGE contro
   HALFRANGE, R118 pavimento dello stop).
4. **`CANCELLO_COSTO_FLOTTA_2026-09-10.md`**: `970913` sta a **28,7x** contro
   il pavimento di lavoro `stop >= 40 x spread` (= **72%** del pavimento);
   `970901` sta a **DD 9,02%** contro il muro prop del **10%** (= **90%** del
   muro, `R99_REFERTO.md` par. A).

---

## 2. PERCHE' L'ALLARGAMENTO E' LEGITTIMO

La regola del 19/08 vieta di infittire la griglia dei parametri di un motore
**gia' dichiarato senza edge**. Nessuna delle tre sedie lo e', e i numeri
sono questi (tutti gia' agli atti, nessuno prodotto oggi):

| sedia | PF | DD % | n | merito | fonte |
|---|---:|---:|---:|---|---|
| `970913` SupRev NAS H1 | **1,57** | **1,17** | **155** | PIENO | `REGISTRO_TEST.md` par. 4 S5v |
| `970913` IS (tick) | 1,34237 | 0,9670 | 69 | | `risultati_prove/ABTG_SupRev_NAS_H1_Ottimizzato/..._NASUSD_IS.csv` riga InpTF=16385 |
| `970913` OOS (tick) | 1,68815 | 0,8567 | 86 | | idem `..._NASUSD_OOS.csv` |
| `970901` STREV Ott XAUUSD H4 | [NON MISURATO in R99: il referto dichiara DD, giornata e regimi, non il PF] | **9,02** | **657** | PIENO | `risultati_archivio/R99_REFERTO.md` par. A |
| `772361` COST EURJPY | **1,41** | **12,3** | **394** | PIENO | `R103_REFERTO_FINALE.md` pos. 2 |

E l'allargamento e' su manopole **MAI messe ad asse**, non su manopole gia'
spremute. Verifica meccanica rifatta oggi su tutti i CSV del repo:

    InpSLBufferPips : 0 file con >1 valore ; costante = 3 in 280 file
    InpSLLookback   : 0 file con >1 valore ; costante = 5 in 290 file
    InpMaxBarsHold  : 0 file con >1 valore ; costante = 100 in 128 file

---

## 3. IL CONTRO-ESEMPIO, costruito PRIMA (regola del 10/09)

"La colonna esiste nel CSV ed e' costante" NON vuol dire "non e' mai stata
provata". Tre modi in cui quella frase e' FALSA, e come li ho esclusi:

1. **Provata a file separati (pin diversi in corse diverse).** Misurato:
   `InpBreakeven` vale 1 in 985 file e 0 in 14 file -- costante DENTRO ogni
   CSV, ma VARIATA fra corse. Per le tre manopole di R127 il conto e' fatto
   e da' **un solo valore in tutto l'archivio**: nessuna corsa le ha mai
   cambiate. (Tabella completa nel referto del censimento.)
2. **Inerte per costruzione.** Misurato: `InpNewsFlatten` e' dentro il ramo
   il ramo che richiede insieme il blackout notizie E il flatten, e `InNewsBlackout()` torna `false` quando
   `InpUseNewsFilter=false` -- che e' il valore di TUTTI i preset vivi. Metterla
   ad asse costa passate e non misura niente. Idem `InpBreakeven` sull'ORB, che
   il codice stesso dichiara morto con `InpTP1Pct=0` (`ABTG_ORB_Ottimizzato.mq5`
   r.662). **Le tre manopole di R127 sono state lette nel codice una per una:**
   - `InpSLBufferPips` -> `ABTG_SupRev_NAS_H1_Ottimizzato.mq5` r.242-243,
     `buf=InpSLBufferPips*pip; sl = min(stLine,ext)-buf`. **Nessuna guardia**,
     nessun altro input la disattiva (l'EA NON ha `InpSLBufferAtr`: verificato,
     esiste solo nella famiglia SuperWave / STREV_Multi).
   - `InpSLLookback` -> `ABTG_SupertrendReversal_Ottimizzato.mq5`, stesso
     blocco: entra dentro `iLowest(...,InpSLLookback,1)`. Nessuna guardia.
   - `InpMaxBarsHold` -> `ABTG_CostToCost.mq5` r.799-804, `if(InpMaxBarsHold>0)`
     ... `if(shift<InpMaxBarsHold) continue;`. Attiva a 100, e il campo l'ha
     gia' vista mordere (`report/DIARIO.md`, 24/08: COST EURJPY chiusa
     DALL'OROLOGIO al 54% catturato).
3. **Provata in un round i cui CSV non sono in archivio.** Controllato anche
   fuori dai CSV: una ricerca per nome della sintassi d asse (cinque campi, ultimo Y) su `prove/`, `righe/`, `ini/` e
   tutti i `.ps1` -> **zero righe** per tutte e tre. Per `InpSLLookback` esiste
   UN file prova (`R126b_stop_lookback_U30USD.txt`) ma e' su **un altro EA e un
   altro simbolo** (SuperWave DOW H1 su U30USD), **non e' mai girato** (nessun
   CSV `r126*`) e R126 **non e' firmato**.

> **Se uno solo di questi tre controlli fosse saltato, la frase "mai provata"
> sarebbe stata un'invenzione.** Sono i tre modi in cui il censimento del
> 09/09 poteva sbagliarsi, ed e' per questo che sono scritti qui.

---

## 4. I CANCELLI, per nome e col numero (congelati)

**`R127-G0` -- FINESTRA PIENA.** La prima operazione della cella ancora deve
cadere entro i primi 60 giorni della finestra dichiarata. Se no: dati corti,
il round si ferma.

**`R127-G1` -- DETERMINISMO.** Ogni file ha un **asse tecnico gemello sul
magic** NO -- **non ce l'ha**, e lo dico qui perche' e' una scelta: i tre file
hanno **un asse vero ciascuno** (regola "una variabile per file prova", che
`controlla_prova.py` impone come UN SOLO asse marcato Y). Il determinismo si legge
sull'**ANCORA**: la cella che coincide col valore VIVO deve riprodurre il
numero d'archivio. Le tolleranze sono al paragrafo 6.

**`R127-G2` -- CAMPIONE.** Il **MERITO** si legge solo sopra **150
operazioni** sulla finestra in cui lo si legge. Sotto, il merito e' SOSPESO e
si legge **solo il RISCHIO** (Emendamento B del 16/08). Per `970913` la
finestra OOS da 86 operazioni **NON basta**: il merito di questo round si
legge sulla **finestra PIENA (155)**, e si dichiara che e' finestra piena.

**`R127-G3` -- SOGLIA DI AMMISSIBILITA'.** Una cella e' ammissibile solo con
**PF > 1,00 sulla finestra in cui la si giudica**. Serve contro il difetto
della classe 210: senza, un altopiano di celle PERDENTI vince per lunghezza.

**`R127-G4` -- RISCHIO, e vale a qualunque n.** Una cella con **DD superiore
a quello della cella VIVA** sulla stessa finestra e' **SCARTATA**, anche se ha
il PF piu' alto. Numeri: `970913` DD OOS **0,8567%**; `970901` DD 22 anni
**9,02%**; `772361` DD **12,3%**.

**`R127-G5` -- IL CANCELLO DI COSTO, solo per `R127a`.** La cella e'
**DENTRO LA FRONTIERA** se `stop_mediano >= 40 x spread`. Numeri congelati:
stop misurato oggi **51,65 punti indice** (n=4 gambe,
`CANCELLO_COSTO_FLOTTA_2026-09-10.md`), spread mediano dell'ora modale
**1,80**, soglia **72,0 punti indice**. Il buffer si somma allo stop, quindi
il passaggio avviene a **b >= 20,35 punti indice**, cioe' fra la cella
**1878** (18,78) e la cella **2253** (22,53). **E' un conto aritmetico, non
un esito del backtest**: il backtest misura cosa COSTA arrivarci.

---

## 5. COME SI SCEGLIE LA CELLA -- procedura `P1..P8`, per riferimento

**Si usa, senza riscriverla, la procedura `P1..P8` di
`backtest_pipeline/prove/R125_ORB_COSTO_CRITERI.md`**, inclusi `P3-bis`
(ripescaggio, classe 209), la distinzione fra bordo **LIMITE FISICO** e bordo
**FINE GRIGLIA** in `P5`, e la dichiarazione obbligatoria di `P8`.
Non la reinvento: e' stata torturata su 200.000 griglie e ha retto.

Mappatura sui tre assi di R127 (le uniche cose specifiche di questo round):

| file | asse | bordo BASSO | bordo ALTO |
|---|---|---|---|
| R127a | `InpSLBufferPips` | **3** = LIMITE FISICO (e' il valore vivo; sotto si andrebbe a buffer negativo = altra geometria) | **3003** = FINE GRIGLIA (scelto da me) |
| R127b | `InpSLLookback` | **1** = LIMITE FISICO (`iLowest(...,count,1)` con count 0 non esiste) | **13** = FINE GRIGLIA |
| R127c | `InpMaxBarsHold` | **25** = FINE GRIGLIA | **200** = FINE GRIGLIA |

`P1` legge l'ammissibilita' con `R127-G3` e `R127-G4`. La banda di `P2` e'
**0,15 di PF** (stessa di R125). `P4` resta a **3 celle minime**: sotto, il
verdetto e' **"non c'e' una configurazione robusta"**, e si scrive cosi'.

---

## 6. L'ANCORA, e le sue tolleranze (congelate)

| file | cella ancora | deve riprodurre | tolleranza |
|---|---|---|---|
| R127a | `InpSLBufferPips = 3` | IS: PF **1,34237** DD **0,9670%** n **69** / OOS: PF **1,68815** DD **0,8567%** n **86** | **n IDENTICO**; PF entro **+/-0,5%**. Fuori: banco sporco, il round si ferma |
| R127b | `InpSLLookback = 5` | DD 22 anni **9,02%**, n **657** (R99, OHLC M1) | n entro **+/-2%**; DD entro **+/-0,20 punti**. Fuori: si dichiara la differenza e si ferma |
| R127c | `InpMaxBarsHold = 100` | PF **1,41**, DD **12,3%**, n **394** (R103, OHLC) | n entro **+/-2%**; PF entro **+/-0,03** |

> **Perche' le tolleranze sono diverse:** R127a e' **tick reali** e la sua
> ancora e' la STESSA corsa dell'archivio -> deve tornare al centesimo.
> R127b e R127c sono **OHLC M1**, e i loro numeri d'archivio vengono da
> corse con driver e date di corsa diverse: li' una differenza piccola e'
> attesa, e va DICHIARATA, non nascosta.

---

## 7. IL COSTO, dichiarato

| file | EA | simbolo/TF | finestra | celle | passate | modello |
|---|---|---|---|---:|---:|---|
| R127a | `ABTG_SupRev_NAS_H1_Ottimizzato` | NASUSD H1 | 2024.09.26 -> 2026.06.30 | 9 | **18** | tick reali |
| R127b | `ABTG_SupertrendReversal_Ottimizzato` | XAUUSD H4 | 2004.06.11 -> 2026.06.30 | 7 | **14** | OHLC M1 |
| R127c | `ABTG_CostToCost` | EURJPY H4 | 2020.01.01 -> 2026.06.30 | 8 | **16** | OHLC M1 |
| | | | **TOTALE** | **24** | **48** | |

Calibrazione del tempo: R88a ha girato **48 celle x 2 finestre in 8,0 minuti**
(tick, M5, 21 mesi -- `r88_csv/REFERTO_R88.txt`). R127a e' meno della meta' di
quel lavoro. **Il tempo di R127b (22 anni H4 OHLC) e' `[NON MISURATO]`**: la
corsa R99 sullo stesso EA/finestra esiste (zip `R99_ORO_22ANNI_CORSA_20260823_1333`)
ma il suo tempo non e' scritto in nessun referto. Si misura col primo giro.

---

## 8. COSA QUESTO ROUND NON PUO' DIRE (i buchi, dichiarati)

1. **R127b e R127c sono OHLC.** Un numero OHLC e' **screening, mai un
   verdetto**. Il verdetto lo danno i tick reali, che su 22 anni non esistono.
2. **R127a non misura lo spread nell'ora del trade.** Il cancello `R127-G5`
   usa lo spread mediano dell'ora modale gia' misurato il 10/09; se la
   distribuzione oraria cambia, cambia la soglia.
3. **Nessuno di questi round autorizza un cambio in forward.** Producono un
   numero. Cosa farne e' una decisione di Claudio.
4. **Il perimetro e' 41 sedie** (`report/CENSIMENTO_CONTRATTI.md`, 07/09), e
   quel censimento dichiara a sua volta 4 buchi (foto `.chr` vecchia del
   25/08, 5 sedie "aperture" contese, GatedShort su conto non deducibile).
   R127 eredita quei buchi: non li chiude.
