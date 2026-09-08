# 🏗️ `ABTG_IBRetest` — PORTING DEL CANDIDATO **P1** (9/10), da specifica

**08/09/2026.** Terzo EA scritto oggi, e il primo che arriva dalla caccia M30 col
punteggio più alto: **P1 `IB Completed`**, 9/10 nel dossier
`report/CACCIA_M30_INDICI_2026-09-08.md`.

> ## ⚠️ PRIMA RIGA, PRIMA DI TUTTO: **NON HO COMPILATO E NON HO TESTATO.**
> Qui non c'è MetaEditor e non c'è lo Strategy Tester. Questa è una **revisione
> statica**: codice scritto da specifica, riletto contro il sorgente Pine riga
> per riga, controllato per parentesi/ASCII/nomi degli input con uno script.
> **Il primo fatto misurato arriverà dal PASSO 0 sul VPS.** Tutto ciò che segue
> è "coerente con la specifica", non "funziona".

---

## 🎯 IL MECCANISMO IN TRE RIGHE (ed è tutto qui)

Si costruisce l'**Initial Balance** (massimo/minimo della prima ora di
contrattazione). Poi una macchina a **TRE STATI**, identica sui due lati:

| passo | LONG | SHORT |
|---|---|---|
| **S1 ROTTURA** | `high > IB_high` | `low < IB_low` |
| **S2 RITORNO** | `low <= IB_high` **E** `close < SMA(9)` | `high >= IB_low` **E** `close > SMA(9)` |
| **S3 FALLIMENTO → INGRESSO** | `close > SMA(9)` **E** `close > IB_high` | `close < SMA(9)` **E** `close < IB_low` |

Ogni passo deve stare su una barra **diversa** dal precedente. Se S2 non arriva,
**non si entra affatto**.

🔑 **Ed è il motivo per cui non è un caduto di casa:** l'ORB (⬛ ~210 celle a
tick, R45 0/48) entra al **passo 1**. Il CRT/Turtle Soup (⬛ 0/30) entra **contro**
la rottura. Qui si entra al **passo 3**, **nella direzione** della rottura, e si
scartano per costruzione tutte le rotture che tengono al primo colpo.

**Stop = strutturale**: al **pivot confermato** (2 barre per lato) formatosi dopo
la rottura, più un buffer. Se quel pivot non c'è, ripiego sull'estremo del
ritorno — e **le due cose hanno contatori separati nel CSV**, perché "stop
strutturale" dev'essere un fatto misurato, non un'etichetta.

---

## 🔍 LA RIGA CHE HO CONTROLLATO PER PRIMA (come chiede la regola di casa)

Il baco Pine che ha ucciso **3 sorgenti su 13** nella caccia di oggi è
`strategy.position_avg_price` letto **prima** dell'ingresso, quando vale ancora
`na` → `strategy.exit(stop = na)` non piazza niente → **backtest senza stop**.

> ### ✅ In `IB Completed` **quel baco NON c'è**, e l'ho verificato riga per riga.
> Le uscite si calcolano da variabili **proprie** (`L_entryPrice` / `L_stopPrice`)
> **dentro lo stesso blocco** dell'ingresso (righe 849-880 del sorgente
> archiviato). L'unico uso di `position_avg_price` è nel **breakeven**, che gira
> quando la posizione **esiste già**: lì è corretto.
> 🟢 È una delle ragioni per cui questo candidato valeva 9/10 e gli altri no.

E comunque **da noi il problema non può esistere**: lo stop viaggia **dentro**
`gTrade.Buy/Sell`, mai messo dopo.

---

## 🧩 COSA HO PRESO DAL PINE / COSA HO DECISO IO — separati, senza sfumare

### ✅ PRESO DALLA FONTE (il motore, ed è quasi tutto)
- la macchina a tre stati **rottura → ritorno → fallimento**, con il vincolo che
  ogni passo stia su una barra diversa;
- la **SMA di innesco a 9** usata sia al passo 2 sia al passo 3;
- lo **stop strutturale** sul pivot confermato (2/2) + buffer, col ripiego
  sull'estremo del ritorno;
- la logica dei riferimenti: un pivot **oltre** il livello IB "arma" il lato e
  azzera il riferimento opposto; il primo pivot contrario **successivo** diventa
  lo stop;
- **una operazione per seduta che blocca ENTRAMBI i lati** (`sessionTradeDone`);
- **cutoff** degli ingressi e **flat di fine seduta** obbligatorio;
- l'**invalidazione opzionale** sul livello IB opposto (default `false`, come lì);
- il **filtro d'ampiezza dell'IB** (default spento, come lì);
- la **simmetria esatta** fra i due lati.

### 🛠️ DECISO DA ME (e dichiarato)
| scelta | perché |
|---|---|
| **Rischio in % dell'equity (0,65%)** invece dell'importo fisso in dollari + `tickVal` a mano della fonte | scala a 100k senza toccare niente, ed è il contratto di casa |
| **Una posizione, UNA TRANCHE.** La scala 1R/2R/3R/4R/5R **non è portata**: TP unico a `InpRR` = 2R | cinque scaglioni sono cinque manopole da girare verso il passato; e il difetto del lotto in tranche dell'08/09 qui **non può presentarsi** |
| **Breakeven SPENTO** (`InpBEatR=0`) anche se la fonte lo ha acceso a 2R | con un TP unico a 2R, un BE a 2R è **inerte**: accenderlo vorrebbe dire *scegliere un numero nuovo*, cioè un asse in più |
| **Filtro HTF portato ma SPENTO**, mentre la fonte lo ha **acceso** (SMA9 su H4) | il passo 0 misura il **motore nudo**. In casa un filtro appiccicato fa **0 successi su 5**. Si accende dopo, come asse da misurare |
| Filtro HTF letto sullo **shift 1** (ultima barra H4 **chiusa**) | il Pine usa `request.security(lookahead_off)`, che sulla barra HTF **aperta** si aggiorna tick per tick. La mia versione è più lenta ma **non ridipinge mai** |
| **Gli altri ~60 filtri opzionali della fonte NON sono portati** (PWH/PWL, PDH/PDL, magic lines, ONL, SMA D9/H4/100/200, day-of-week) | erano **tutti a default `false`** e sono 45 colori + livelli da grafico. Si scende da **124 input a 30** |
| **Orari in ORA SERVER BCM** e sessione 14:30-15:30 / cutoff 20:00 / flat 21:00 | la fonte lavora in `America/New_York` su futures. Cutoff e flat di casa servono al **costo** (fuori sessione lo spread raddoppia) e al divieto di overnight |
| **R calcolata dal prezzo REALE di riempimento**, non dalla chiusura della barra di segnale come la fonte | più onesto e leggermente meno generoso: lo scarto è ~mezzo spread |
| **Pivot con confronto STRETTO** su entrambi i lati | in caso di pareggio esatto il pivot non si forma: preferisco perdere un pivot che accettarne uno ambiguo, **perché da lì dipende lo stop** |
| **Il setup si consuma al primo innesco valido**, anche se l'ordine poi fallisce | come la fonte (`L_entryDone` si alza al segnale). Senza, un rifiuto del broker lascerebbe il setup vivo per ore → ingresso **tardivo** con uno stop strutturale ormai vecchio |

---

## 🚦 `InpMaxTradesPerDay` — **DEFAULT 1**, e il perché è la parte importante

> ### Non è un meccanismo nuovo: è la regola `sessionTradeDone` della fonte, resa **esplicita e misurabile** invece che sepolta nel codice.

La fonte fa **una operazione per seduta e blocca entrambi i lati**. Nel mio EA il
tetto **congela la RILEVAZIONE** dei due lati (non solo l'invio), esattamente
come il Pine, e il contatore dice **quante barre** la seduta passa congelata.

**Perché 1 e non 0 (illimitato):** dopo il verdetto di stasera su `LVNArbitro`
(**1.010 operazioni, DD 19,35% / 11,76%, morto di erosione lunga**), il tetto
strutturale è l'unica cosa che tiene basso il numero di operazioni per seduta.
🔴 Alzarlo sopra 1 **non fa parte di questo round**: sarebbe un altro motore.

### ❌ E ciò che NON ho messo, come da mandato
**Nessun tetto di perdita giornaliera/settimanale interno.** La fonte non ce l'ha,
sarebbe un **meccanismo nuovo e non misurato** infilato dentro un porting. Sta
qui sotto come **proposta separata**, non nel codice.

---

## 💡 PROPOSTA SEPARATA (da decidere, NON implementata)

**Freno di perdita consecutiva / giornaliera per EA.** È la "porta di rientro"
che il verdetto `LVNArbitro` indicava: *un DD cumulato non si cura con parametri
diversi, si cura con un meccanismo di gestione nuovo.*

🟢 **La buona notizia: in casa esiste già e non va scritto.**
`ABTG_PausaGuardian.mqh` espone `ABTG_GuardiaIngresso(..., soglia_perdite_consecutive, magic)`
— il freno P1, **spento di default**. Basterebbe **un input** (`InpStopDopoNPerdite = 0`)
e **due argomenti in più** sulla riga della guardia che è già al posto giusto.

🔴 **Ma NON l'ho fatto oggi**, e la ragione è la disciplina: sarebbe una seconda
variabile nello stesso round. **Prima si misura il motore nudo**, poi, se muore
di DD e solo allora, si misura il freno **come asse dichiarato** (con/senza, a
parità di tutto il resto).

---

## 🔢 GLI INPUT — **30**, contro i 124 della fonte

| gruppo | input |
|---|---|
| Guardian | `InpUsaGuardian` |
| Initial Balance (**ora server**) | `InpIbInizioOra` `InpIbInizioMin` `InpIbFineOra` `InpIbFineMin` |
| Motore | `InpSmaLen` `InpPivot` `InpStopBufferPunti` `InpInvalidaSuIbOpposto` `InpMaxIbPunti` |
| Filtro HTF (spento) | `InpUsaFiltroHTF` `InpHtfMinuti` `InpHtfMaLen` |
| Lati | `InpAllowLong` `InpAllowShort` |
| Sessione (**ora server**) | `InpCutoffOra` `InpCutoffMin` `InpUsaFlatSeduta` `InpGoFlatOra` `InpGoFlatMin` |
| Stop | `InpMinStopPts` `InpMT5PerPuntoIndice` |
| Uscita | `InpRR` `InpBEatR` |
| Rischio | `InpRiskPercent` `InpMaxSpreadPctOfStop` `InpMaxTradesPerDay` |
| Generali | `InpMagic` `InpComment` `InpVerbose` |

⏰ `InpHtfMinuti` è in **minuti** (5/15/30/60/240/1440) e non un enum: **un enum
si sbaglia a scrivere in un `.ini`**, un intero no.

### 📎 DUE NOTE DI ALLINEAMENTO CON LA BOZZA, per chi viene dopo
1. 🔴 **Il file si chiama `ABTG_IBRetest.mq5`** (I-B maiuscole). La bozza
   `IBRETEST_M30_BOZZA.txt` lo chiamava `ABTG_IbRetest.mq5`: **quel file non
   esiste**, e cercarlo con quel nome è un giro a vuoto.
2. 🔴 **I nomi degli input della bozza erano "PROPOSTI" e vanno ricopiati dal
   `.mq5`** — la bozza stessa lo scrive (è la classe d'errore FiboH4: MT5 ignora
   **in silenzio** un pin che non trova). Differenze: `InpParzialeR` e
   `InpRunnerR` **non esistono** (niente parziali, vedi sopra); `InpCutoffOra` e
   `InpGoFlatOra` hanno guadagnato il gemello `*Min`; sono nuovi
   `InpMinStopPts`, `InpMT5PerPuntoIndice`, `InpRR`, `InpBEatR`,
   `InpMaxSpreadPctOfStop`, `InpMaxTradesPerDay`, `InpUsaFlatSeduta`,
   `InpInvalidaSuIbOpposto` e il gruppo HTF. **Il file prova del passo 0 usa già
   i nomi veri** e passa il controllore: si copia da lì, non dalla bozza.

---

## 🔢 IL MAGIC: **772900** (blocco `7729xx`)

**Verificato VERGINE l'08/09/2026** con `grep` repo-wide su **tutti** i numeri a
6 cifre che iniziano per 7 (1.269 valori distinti) + il censimento
`backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260908_033003.log`:
il prefisso `7729` **non compare in nessun `.mq5`, `.ini`, `.set`, `.txt`, `.csv`
o referto del repo**.

- `769800` = `ABTG_ImpulsoApertura` (stamattina) — occupato
- `769900` = `ABTG_LVNArbitro` (stasera), che ha già **prenotato fino a 769950**
  col suo asse gemello — occupato
- `770000-770929` = fittissimo di sedie esistenti → **evitato**

---

## 🛡️ LE REGOLE DI CASA, una per una (guardate nel codice, non inventate)

| regola | dove sta |
|---|---|
| **Orari in ORA SERVER**, come input, col commento che lo dice | tutti gli input orario, più 3 righe di log all'avvio e un blocco in testa al file |
| **Rischio %, mai lotto fisso; una posizione una tranche** | `LotByRisk()` — pavimento del lotto minimo applicato **in un punto solo**, nessuna seconda tranche possibile |
| **`InpMagic` libero** | `772900`, verificato sopra |
| **Guardian a ridosso dell'invio** | `ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_IBRetest")` — riga immediatamente prima di `gTrade.Buy/Sell`, mai in cima all'imbuto |
| **Stop SEMPRE allegato all'ordine** | `gTrade.Buy(lot,_Symbol,0.0,sP,tP,cm)` — SL e TP dentro l'invio. **Mai** una `PositionModify` per mettere lo stop |
| **Flat di fine seduta, zero overnight** | `FlatFineSedutaCheck()`, ora server, `InpUsaFlatSeduta=true` |
| **Log di avvio con la configurazione** | una riga `CONFIG IN USO ->` con **tutti** i parametri di segnale, rischio e orario |
| **Colonne diagnostiche in `OnTester`** | 25 colonne, vedi sotto |
| **Niente martingala/griglia/recovery/piramidazione** | ingresso singolo, una posizione per magic, `HoPosizione()` hedge-safe (simbolo **+** magic) |
| **Robustezza ordini** | `NormalizePrice` su tick size, `SYMBOL_TRADE_STOPS_LEVEL` dentro il pavimento dello stop **e** ricontrollato sul TP, `VOLUME_MIN/MAX/STEP`, retcode letto dopo ogni invio, `SetTypeFillingBySymbol` |
| **ASCII puro, zero emoji nel `.mq5`** | verificato: **0 righe non-ASCII** |

---

## 📊 LE COLONNE DIAGNOSTICHE (25) — e perché queste

Il `LVNArbitro` stasera ha dimostrato che **le colonne giuste valgono un round
intero**. Qui i **tre stati sono contati separatamente**, per lato:

`Barre Valutate · Sedute con IB · Rottura Long/Short · Ritorno Long/Short ·
Segnale Long/Short · Long · Short · **Stop Mediano Punti** · **Stop Da Pivot** ·
**Lotto Al Minimo** · Reject · Flat Chiusure` + `Peggior Giornata % ·
Perdite Consecutive Max · Serie Perdente Peggiore`.

Così il referto del passo 0 potrà dire **dove** si perde il segnale invece di
indovinarlo al round dopo:
- `Rottura >> Ritorno` → collo di bottiglia al **passo 2**;
- `Ritorno >> Segnale` → al **passo 3**;
- `Segnale >> Trades` → sono i **cancelli** (orario, lato, spread).

🟢 **Due colonne nuove, nate dai verdetti di stasera:**
- **`Stop Mediano Punti`** → verifica il cancello **C3** (frontiera
  `stop >= 40 × spread`: su U30USD **76-80 punti indice**). L'ipotesi "lo stop
  strutturale è largo" **si misura**, non si assume.
- **`Lotto Al Minimo`** → conta quante volte il pavimento del lotto ha rialzato
  il volume (rischio vero **sopra** lo 0,65% dichiarato). Se esce **0**, la
  seconda corsa a `-Deposito 100000` **non serve**: è una corsa risparmiata
  rispetto a stasera.

---

## 🧪 IL FILE PROVA DEL PASSO 0 — **ESITO: OK**

`backtest_pipeline/prove/ABTG_IBRetest_00_conta.txt`

```
=== CONTROLLO FILE PROVA ===
  ABTG_IBRetest_00_conta.txt       ABTG_IBRetest.mq5          pin=29 celle= 2  OK

file: 1 | celle totali: 2 | passate (celle x 2 finestre): 4 | problemi: 0
ESITO: OK
```

**UN SOLO asse Y** (il magic, due celle gemelle = determinismo G1), tutti gli
altri **29 pin fissati uno per uno**, `@SIMBOLO U30USD` · `@PERIODO M30` ·
`@DAQUANDO 2024.09.26`.

### 🎲 LE ATTESE, CONGELATE PRIMA DEI NUMERI
| | |
|---|---|
| **frequenza attesa** | **0,20-0,32 op/seduta** = **~90-140 operazioni** in 21 mesi |
| massimo **teorico** | **440** (1 per seduta). Se esce di più → **è un BACO nel tetto**, corsa nulla |
| 🔴 **BOCCIA** | **< 30 operazioni** (frequenza) · **DD > 10,0%** (rischio) · **peggior giornata < −5,0%** |
| 🟠 **ALLARME** | DD **6-10%**: con ~120 trade a 0,65% quel DD lo produce già un cammino casuale |
| **stop mediano atteso** | 80-180 punti indice; **sotto 76 → il motore vive dentro il costo** |
| **due lati** | stesso ordine di grandezza; oltre 70/30 è deriva del sottostante, non del codice |

🔴 **E la conseguenza scomoda, detta prima:** ~120 operazioni su **un** simbolo
sono **sotto** il pavimento dei 150 per finestra. **È il caso previsto dalla
SPEC**: campione e frequenza si raggiungono solo mettendo in comune i **tre**
indici (unità **FAMIGLIA**, firmata il 07/09). Se esce 120, **non è una brutta
notizia: è la notizia attesa.**

---

## 🕳️ I LIMITI, dichiarati e non riempiti

1. 🔴 **NON COMPILATO, NON TESTATO.** Revisione statica. Il primo errore di
   compilazione possibile è mio.
2. 🔴 **Licenza della fonte [INCERTA]**: `open_no_auth` = sorgente leggibile,
   **non** licenza permissiva. Per questo **non è stata copiata una riga**:
   c'è una meccanica riscritta, e l'attribuzione è in testa al `.mq5`, al file
   prova e qui.
3. 🟠 **La curva di equity NON sarà quella della fonte**: niente scala
   1R/2R/3R/4R/5R, niente breakeven, filtro HTF spento. È voluto (motore nudo),
   ma vuol dire che **non si può confrontare col grafico dell'autore** — e
   comunque i numeri dell'autore non pesano, per criterio.
4. 🟠 **Il pivot ricalcolato a mano** può differire da `ta.pivothigh` sui
   pareggi esatti. La conseguenza non è un segnale in più: è **uno stop diverso**.
5. 🟠 **La finestra IB deve essere allineata alla griglia del timeframe**
   (su M30, orari a `:00`/`:30`). Non è un limite del codice, è aritmetica: se
   qualcuno mettesse 14:20, la prima barra utile slitterebbe.
6. 🟠 **21 mesi = UN SOLO REGIME.** Nessun orso, nessun crollo. Questo round non
   può dare un verdetto di regime e non deve pretenderlo.
7. 🟠 **Tre simboli correlati.** Se D30EUR, U30USD e NASUSD completano la
   sequenza lo stesso giorno nella stessa direzione, le tre perdite arrivano
   **insieme** (1,95% a 0,65%). Il **tetto per cluster al 3,0%** è **FIRMATO ma
   NON ATTIVO** nel Guardian: oggi è un'intenzione, non una protezione. Va detto
   ogni volta che si cita.

---

## ✅ IN SINTESI

🟢 **Cosa è andato bene oggi:** il candidato col punteggio più alto della caccia
è passato **da 1.092 righe di Pine a 30 input di casa** senza perdere un pezzo
del motore, il baco Pine che ha ucciso 3 sorgenti su 13 **qui non c'era** (ed è
stato verificato, non sperato), e il file prova passa il controllore **al primo
colpo**.

🔴 **Cosa non sappiamo ancora:** se spara abbastanza, se lo stop sta sopra la
frontiera del costo, e **se il DD cumulato — che è quello che ha ucciso il
motore precedente stasera — sta sotto il 10%.** Le tre soglie sono congelate
**prima** dei numeri.

> **Prossimo passo:** compilare in MetaEditor (F7) e far girare il **PASSO 0**
> sul VPS. Nessun EA in forward è stato toccato, nessun preset, nessun magic
> esistente.
