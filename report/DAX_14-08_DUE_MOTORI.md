# 14/08/2026 — i due DAX non sono lo stesso DAX

_Nato dalla domanda di Claudio ("Cosa e' successo?" sul 100k, poi "Stessa cosa
nel conto piccolo"). Fonte: i due screenshot dello storico MT5 mobile +
`data/statements/trades_auto.csv` + il codice degli EA._

---

## 1. I due trade, uno accanto all'altro

| | conto 100k (50504263) | conto piccolo (50503392) |
|---|---|---|
| commento | **DAX Apertura EU RETEST BUY** | **DAX Apertura EU BUY** |
| apertura | 08:50:21 server @ **26.476,80** | 08:49:24 server @ **26.479,00** |
| stop | 26.421,90 (**54,90** pt) | 26.426,70 (**52,30** pt) |
| target | 26.641,50 (164,70 = **3,00 R**) | 26.635,90 (156,90 = **3,00 R**) |
| chiusura | 09:18:20 sullo stop | 09:17:54 sullo stop |
| volume | 11,80 lotti | 2,00 lotti |
| perdita | **−647,82** = 1R = **0,65%** | **−104,60** = 1R |

Tutti e due hanno perso **esattamente 1R** sullo stesso crollo (le 10:10-10:20
italiane, ~100 punti indice in dieci minuti dopo il massimo a 26.509).
Aritmetica verificata: 54,90 x 11,80 = 647,82 · 52,30 x 2,00 = 104,60.
**Il rischio ha funzionato come tarato.**

## 2. Ma NON e' lo stesso trade: sono due motori diversi

Le due stringhe del commento stanno in **due rami del codice che non si
incrociano mai** (`mql5/Experts/ABTG_DAX_Apertura_EU.mq5`):

- `"... RETEST BUY"` la scrive **solo** `MonitorRetest()` -> **BUY LIMIT**
  sul livello rotto (riga 1310);
- `"... BUY"` la scrive **solo** `TryPlaceBreakout()` -> **BUY STOP** oltre
  il livello (riga 893).

Quindi: il 100k ha comprato **col limit in ritorno**, il piccolo **con lo stop
sulla rottura**. Due motori, non due size dello stesso trade.

### La prova aritmetica (stesso range, due geometrie)

Dal codice: retest -> `entry = H - offset`, `SL = L - buffer`;
breakout -> `entry = H + buffer (+ slippage)`, `SL = L - buffer`.
Con la cella validata del 100k (offset 200 pt = 2,00 · buffer 500 pt = 5,00):

- **H = 26.476,80 + 2,00 = 26.478,80**
- **L = 26.421,90 + 5,00 = 26.426,90**

Rimettendo lo stesso range dentro la formula del breakout:
`26.478,80 + b = 26.479,00` -> **b = 0,20** e
`26.426,90 - 0,20 = 26.426,70` = **lo stop del conto piccolo, al centesimo**.

I due EA hanno misurato **lo stesso identico range di apertura** e ci hanno
appoggiato sopra due geometrie diverse. Il piccolo gira con **buffer 20 punti
(0,2 punti indice)**, cioe' praticamente incollato al livello.

### E l'orologio conferma

Lo stop sta **sopra** (26.479,00), il limit sta **sotto** (26.476,80). Infatti
il piccolo si e' riempito **prima** (08:49:24, il prezzo saliva) e il 100k
**57 secondi dopo** (08:50:21, sul ritorno). E' esattamente la sequenza
rottura -> ritorno. Nessuna delle due e' un errore di esecuzione.

## 3. Perche' e' un problema (e non un dettaglio)

Il motore **BREAKOUT sulle aperture e' quello bocciato dal banco**, quattro
volte e con criteri congelati prima: R7, 02/08, R25, R42 (48/48), R43 (64
celle). La riga che riassume tutto sta nel DIARIO: *"sugli estremi del range di
apertura non c'e' edge in nessuna direzione — **paga solo il RETEST**"*. Il
06/08 alle 19:25:33 il RETEST 35/500/200 e' andato in produzione ed e' la
cella misurata (+1198,79 · PF 1,237 · DD 10,49% all'1%, referto B1).

Sul piccolo, **dopo quel deploy**, il magic 770101 ha prodotto tutte e due le
cose:

| data | commento | motore | P/L |
|---|---|---|---:|
| 07/08 08:58 | RETEST BUY | retest | **+5,40** |
| 10/08 08:16 | SELL | breakout | −101,83 |
| 11/08 13:22 | RETEST BUY | retest | **+3,90** |
| 12/08 09:46 | BUY | breakout | +19,17 |
| 13/08 12:36 | SELL | breakout | +4,62 |
| 14/08 08:49 | BUY | breakout | **−104,60** |

**Retest (validato): +9,30 in 2 trade. Breakout (bocciato): −182,64 in 4.**

Un solo EA non puo' cambiare motore da solo: **stanno girando due istanze**
del `DAX Apertura EU`, e — questo e' il punto vero — **con lo STESSO magic
770101**. Conseguenza pratica: ogni strumento che raggruppa per magic (pagella
inclusa) mescola la cella misurata con una configurazione mai promossa, e il
forward della cella validata risulta sporcato. Indizio a sostegno: il 10/08 il
breakout e' entrato alle **08:16**, cioe' col range da **15 minuti** (la
geometria VECCHIA), mentre il retest del 07/08 e' entrato alle 08:58, col range
da 35. Sono due tarature diverse, non due momenti della stessa.

**[INCERTO]** quale grafico sia: `FLOTTA_ATTIVA.md` elenca `D30EURM5`
(Ottimizzato, magic 770111, commento "OTT") e `D30EURM56` (nativo, 770101).
La seconda istanza a 770101 non e' in mappa. Si risolve leggendo la riga
`CONFIG IN USO`, che ogni EA scrive all'avvio.

## 4. Che cosa si fa

1. **Misurare, non indovinare**: `backtest_pipeline/config_in_uso.ps1` sul VPS
   (non tocca niente, MT5 puo' restare aperto). Spazzola i log di **tutti** i
   terminali e tiene l'**ultima** riga `CONFIG IN USO` per ogni EA: dice quante
   istanze del DAX Apertura girano, su che motore, con che range e che buffer.
2. Poi la decisione, che e' di Claudio: **spegnere l'istanza breakout** oppure
   — se la si vuole tenere come confronto — **darle un magic suo** (es. 770102)
   in modo che le due statistiche restino separate.
3. Solo dopo, in pagella, il DAX torna a essere un numero leggibile.

## 5. Quello che questo NON dice

- Non dice che il trade di oggi era sbagliato: **la perdita di oggi e' 1R
  esatto su tutti e due i conti**, cioe' il comportamento previsto.
- Non dice che il breakout perde: quattro trade non misurano niente. Lo dicono
  i cinque round di banco, e questi quattro trade ci vanno soltanto d'accordo.
- Non tocca il 100k, che sta girando **la cella giusta**.

---

# APPENDICE — LA MISURA (14/08, referto `config_in_uso.txt`)

Lanciato `config_in_uso.ps1` sul VPS. **Una riga sola**, sul terminale del
conto **50503392**:

```
20260814  09:25:23  ABTG_DAX_Apertura_EU (D30EUR,M3)
  CONFIG IN USO -> motore=ABTG_BREAKOUT | rangemode=ABTG_RANGE_OPENING |
  range=15 min | buffer=20 pt | offset retest=0 pt | lati=long+short |
  rischio=2.00% | TP=3.0R | parziale=50% | BE=si |
  trail=ABTG_TRAIL_FIXED PERIOD_M1 | trail da=0.00R
```

## 1. L'aritmetica di stamattina era giusta al centesimo

Dai due prezzi degli screenshot avevo ricavato **buffer = 0,20 punti indice
= 20 punti**. Il referto dice **`buffer=20 pt`**. La derivazione (stesso
range di apertura, due geometrie diverse) era corretta, e ora e' confermata
da una misura indipendente.

## 2. Che cos'e' davvero quell'istanza

| parametro | l'istanza trovata | la cella VALIDATA (06/08) | giudizio |
|---|---|---|---|
| motore | **BREAKOUT** | RETEST | bocciato 5 volte al banco |
| range | **15 min** | 35 min | 0 celle positive su 12 sotto i 35 |
| buffer | **20 pt** | 500 pt | mai stato ne' default ne' validato |
| offset retest | 0 | 200 | — |
| trailing | **FIXED M1** | PREVBAR M5 | M1 e' il PEGGIORE dei sei sul DAX (-801 contro -79 su 440 trade) |
| rischio | 2,00% | 2,00% | uguale |
| grafico | **D30EUR M3** | M5 | in `FLOTTA_ATTIVA.md` l'M3 e' del `SuperWave_EA` |

**Non e' una configurazione vecchia rimasta indietro: e' una configurazione
che non e' MAI esistita.** Il pre-06/08 era breakout/15/**200**/0. Qui il
buffer e' **20**, cioe' 200 con uno zero in meno — un numero digitato a mano
in una casella, non un parametro scelto. E il trailing FIXED M1 non e' la
ricetta di famiglia di nessuna epoca.

Tradotto: un EA su un grafico di prova (M3), con parametri buttati dentro a
mano, che opera al **2% di rischio** col motore bocciato e **con lo stesso
magic 770101** della cella promossa. Il 14/08 ha perso 1R (−104,60).

## 3. ⚠️ QUELLO CHE IL REFERTO NON DIMOSTRA

`CONFIG IN USO` la scrive **solo chi si riavvia**. Con la finestra a 30
giorni e' uscita una riga sola — e non perche' giri un EA solo, ma perche'
gli altri sono accesi da mesi e non si sono mai riavviati. **Assenza non
vuol dire "non gira".** In particolare:

- **il conto 100k (50504263) non compare affatto**: o il suo terminale non
  sta su quella macchina, o nessuno dei suoi EA si e' riavviato di recente.
  Non e' un problema di per se'.
- **l'istanza a RETEST esiste quasi certamente**: i trade del 07/08 e
  dell'11/08 (magic 770101, commento `RETEST BUY`) non possono venire da
  questa, che il retest non lo sa fare. Semplicemente non si e' riavviata
  nel periodo guardato.

Correzioni gia' fatte allo strumento: finestra di default portata a **120
giorni**, e in coda al referto viene ora stampato a chiare lettere che
l'assenza non e' una prova.

## 4. La domanda che resta aperta (una sola)

Perche' quell'EA si e' **riavviato stamattina alle 09:25:23 locali** (08:25
server), 24 minuti prima di comprare? Un EA si re-inizializza quando viene
attaccato, ricompilato, o quando gli si cambiano i parametri o il
timeframe. Nessuna di queste cose succede da sola.

## 5. Prossimo passo

`elenco_ea_attaccati.ps1` incrocia **due** fonti (i log + i profili `.chr`)
e dice chi e' **attaccato adesso**, anche se muto. E' l'altra meta' della
risposta: `config_in_uso` dice *con che parametri e' partito chi e'
ripartito*, questo dice *chi c'e*'.

---

# APPENDICE 2 — IL SECONDO DAX NON E' SUL VPS: E' SUL PC DI BACKTEST

Il referto delle **16:13** non viene dalla stessa macchina di quello delle
13:11. Si riconosce da quattro cose, tutte dentro il file:

1. c'e' **un conto solo** (50503392), mentre alle 13:11 ce n'erano tre
   (50503392, 50504263, 25336156);
2. compaiono **`ABTG_ImportaStoricoEsterno`** (EURUSD e GBPUSD, 17 righe) e
   **`ABTG_HistoryDownloader`**: sono gli script dell'import, girati **sul PC**;
3. ci sono **511 coppie EA+simbolo** con ogni EA su **tutti i 50 simboli**
   (BreakingBand H1+H4, CostToCost, EasyTrend, EMA200, GapFill, PunteLarry...):
   e' la firma di `scan_market.ps1`, cioe' del **tester**;
4. **manca l'avviso "MT5 e' APERTO"**: sul PC il terminale era chiuso, quindi
   qui i profili `.chr` sono **freschi e affidabili** (al contrario del VPS).

## 1. Il numero che chiude la questione

```
50503392   ABTG_DAX_Apertura_EU   D30EUR   M3   5678
50503392   ABTG_DAX_Apertura_EU   D30EUR   M5     46
```

E dai profili, letti a terminale chiuso:

```
profilo 'Default'   (20 grafici)
  D30EUR      ABTG_DAX_Apertura_EU     <-- ATTACCATO
```

**Il grafico M3 col motore breakout e il buffer da 20 punti sta sul PC di
backtest, non sul VPS.** E il PC e' collegato al conto **50503392**, lo stesso
del VPS: qualunque ordine parta da li' finisce sul conto vivo.

Questo spiega tutto quello che restava aperto:

- perche' l'EA si e' **re-inizializzato alle 09:25:23** (Claudio era al PC);
- perche' i parametri sono **scritti a mano** (buffer 20 = 200 con uno zero in
  meno, trailing FIXED M1): e' un grafico di prova, non un deploy;
- perche' non e' in `FLOTTA_ATTIVA.md`, che descrive **il VPS**;
- perche' dal 07/08 il magic 770101 alternava retest e breakout: **erano due
  macchine diverse** che scrivevano sullo stesso conto con lo stesso magic.

## 2. Non e' solo il DAX Apertura

Sempre sul PC, sempre conto 50503392, attaccati a grafici (fonte affidabile):

```
D30EUR   PTE_V3_23                      D30EUR   GOLDEN_CROSS_V03
D30EUR   HeikinAshi_Switch_3Mode_V10 x2 NASUSD   NQ_v21_S
USDCAD   BULGE_MULTI_SIGNAL_VIOLA_L     XAUUSD   NIGHT_BREAK_BOX_BRK_UP x2
GBPUSD   BULGE_MULTI_SIGNAL_ARANCIO_S   EURUSD   BULGE_MULTI_SIGNAL_BLU_S
```

Dieci EA di terzi attaccati a grafici del conto vivo, piu' il nostro. Nei log:
`PTE_V3_23 EURNZD H1` **15.238 righe**, `GOLDEN_CROSS_V03` **2.636** su USDCAD
e altrettante su XAUUSD.

## 3. La regola che questo caso scrive

Il PC e' il **banco di prova**, il VPS e' dove **lavorano i conti**. La regola
esisteva gia' per il tester ("mai lanciare il tester sul VPS"); mancava il
verso opposto, che e' quello che ha fatto danno:

> **Sul PC di backtest, AutoTrading SPENTO e nessun EA attaccato a grafici del
> conto vivo.** Se serve provare un EA su grafico, si usa un conto demo
> separato - mai il 50503392 e mai il 50504263.

## 4. Cosa NON e' ancora dimostrato

Che il trade delle 08:49 sia partito dal PC e non dal VPS e' **molto
probabile** ma non certificato: lo dimostra solo la riga
`BUY STOP @ 26479.00 SL 26426.70` nel log della macchina che l'ha piazzato.
Si cerca con `log_ea.ps1 -Filtro "STOP|LIMIT|2647" -Tutto` sulle due macchine:
quella che ce l'ha e' quella che ha operato.

## 5. Correzione allo strumento

Due referti identici nell'aspetto arrivavano da due macchine diverse e non
c'era modo di distinguerli: ci sono volute quattro deduzioni indirette. Ora
`elenco_ea_attaccati.ps1` e `config_in_uso.ps1` scrivono in testa
**`MACCHINA: <nome> utente: <utente>`**.

---

# APPENDICE 3 — LA PROVA DEL GIORNALE (e un secondo episodio, oggi)

Claudio ha contestato la ricostruzione: "e' impossibile che MT5 da PC fosse
aperto, io ero al mare". Giusto contestare, e la risposta non poteva venire da
un'altra deduzione: doveva venire dal **giornale**, dove il broker registra gli
ordini. Filtro sul prezzo dell'ordine, `26479`, sul PC:

```
09:25:01.109  Trades  '50503392': buy stop 2 D30EUR at 26479.00 sl 26426.70 tp 26635.90
09:25:01.180  Trades  '50503392': order #3160534 buy stop 2/2 D30EUR at 26479.00 done in 70.989 ms
09:25:01.180  Trades  '50503392': sell stop 2 D30EUR at 26426.70 sl 26479.00 tp 26269.80
09:25:01.242  Trades  '50503392': order #3160535 sell stop 2/2 D30EUR at 26426.70 done in 62.803 ms
```

**L'ordine e' partito dal PC.** Non e' piu' un'inferenza: c'e' il ticket
(#3160534), il conto (50503392) e il millisecondo. Gli ordini sono stati
piazzati alle **09:25:01 locali** dall'istanza sul grafico **M3**, e il BUY
STOP e' stato riempito alle 08:49 server (09:49 locali) — un'ora e mezza
prima che Claudio tornasse.

## Due cose che questo referto aggiunge

**1. L'EA piazza ENTRAMBI i lati.** Buy stop a 26479,00 e sell stop a 26426,70,
nello stesso secondo. Il breakout arma sopra e sotto: quello riempito e' stato
il long, l'altro e' morto per OCO. La geometria ricavata a mano il mattino
combacia anche qui.

**2. E' RISUCCESSO OGGI, alle 16:17:43.**

```
16:17:43.444  buy stop 1.9 D30EUR at 26479.00      -> order #3165434
16:17:43.517  sell stop 1.9 D30EUR at 26426.70     -> order #3165435
16:18:43.887  cancel order #3165434
16:18:48.454  cancel order #3165435
```

Stessi prezzi, lotto 1,90 invece di 2,00 (il conto e' piu' piccolo dopo la
perdita del mattino). Sono ordini VERI su un conto VIVO, piazzati mentre
stavamo diagnosticando. E i due `cancel` un minuto dopo hanno un nome preciso:
sono l'effetto di **Claudio che spegne AutoTrading**. Nel giornale si vede il
gesto.

## Il difetto che ha permesso il secondo episodio (e la correzione)

Il secondo armamento **non sarebbe dovuto avvenire**: la guardia A4
(`InpOneTradePerDay`) esiste apposta per non riarmare in una giornata gia'
operata, e alle 08:49 il trade c'era gia' stato. Ha ceduto per una ragione
precisa, visibile nel codice:

```
gGuardiaGiorno = now.day_of_year;   // <-- si timbra PRIMA di sapere
if(HaGiaOperatoOggi()) { ... gPhase = PH_DONE; }
```

e dentro, `CicliOggi()` faceva:

```
if(!HistorySelect(inizioGiorno, TimeCurrent()+60)) return(0);   // 0 = "non ho operato"
```

Appena il terminale parte lo storico dei deal puo' non essere ancora
sincronizzato. `HistorySelect` ritorna false, la funzione risponde **zero
cicli**, la guardia legge "oggi non ho operato" e lascia armare. E siccome
`gGuardiaGiorno` era gia' stato timbrato, il controllo **non si ripete mai
piu'** per quella giornata. E' lo stesso difetto del 05/08 in un vestito
nuovo: allora la guardia guardava solo le posizioni aperte, adesso confonde
"non lo so" con "no".

**Correzione** (`ABTG_DAX_Apertura_EU.mq5`): `CicliOggi()` restituisce anche
`storicoOk`. Se lo storico non ha risposto, la giornata **non si timbra** e il
controllo si ripete al tick successivo. "Non lo so" e "non ho operato" sono
due risposte diverse.

**Da fare, stesso difetto:** `ABTG_Dow_Apertura_US.mq5:704`,
`ABTG_Nasdaq_Apertura_US.mq5:751`, `ABTG_Apertura_Marco.mq5:636` hanno la
stessa riga e vanno corretti allo stesso modo.
