# 🧊 CRITERI CONGELATI — CHIUSURA DEL BUCO SPREAD DELLA FLOTTA (10/09/2026)

> 🛑 **File scritto PRIMA dei numeri della corsa.** Nessun terminale toccato,
> nessun parametro in forward, nessuno script nuovo. Chi legge questo file dopo
> i risultati deve poter verificare che le soglie non sono state spostate.

**Da dove viene.** `report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` §4.3 e §8:
`backtest_pipeline/risultati_archivio/spread_flotta/` ha **3 file su 15 simboli
vivi**, e per gli altri 12 l'unica lettura e' **una sonda istantanea del 17/08
alle 17:34 server**. Il referto dichiara aperta una contraddizione da **fattore
3-5** fra quella sonda (0,2-0,4 pip) e le schede del broker (0,8-1,0 pip), e
avverte che **a 1,0 pip otto sedie che "passano" non passano piu'**.

---

## 1. 🎯 LA DOMANDA, SPEZZATA IN TRE — e cosa risponde a ciascuna

| domanda | strumento che risponde | stato |
|---|---|---|
| **A.** la contraddizione 0,3 vs 1,0 pip e' un errore di misura o di categoria? | commissione MISURATA sui deal veri (`data/statements/trades_auto.csv`) + `TickValue` (`sonda_storico_17-08/215D85D7_ABTG_InfoBroker.csv`) | ✅ **CHIUSA IN CASA, senza corse** (§2) |
| **B.** quanto costa lo spread **all'ORA in cui ogni sedia lavora**? | `ABTG_SpreadOrario` v2 sui **tick storici**, gia' scritto e gia' passato dal cancello il 03/09 | 🔜 **5 corse, §4** |
| **C.** il feed del conto **REALE 10105439** e' lo stesso del DEMO 50503392? | — | 🔴 **[NON MISURATO]**, §6 |

---

## 2. 🔬 IL TERMINE CHE MANCAVA: LA COMMISSIONE SUL FOREX

Il cancello del costo somma, sull'oro, **spread + commissione**
(`ORO_1530_CANCELLO_COSTO` §2.4, ripreso in `CANCELLO_COSTO_FLOTTA` §1). Sul
forex **quel secondo termine non e' mai stato sommato**: il referto scrive
*"sugli indici e sul nostro forex la commissione e' 0,00 — verificata su 7
simboli"*. 🔴 **Sul forex non e' 0,00.**

**Misura** (`trades_auto.csv`, 1.296 posizioni, 30/03→09/09/2026, colonne
`commission` e `volume`; nessuna stima):

| classe | commissione misurata | n posizioni |
|---|---:|---:|
| indici (D30EUR · U30USD · NASUSD · 225JPY · SPXUSD · F40EUR · USOIL) | **0,0000 EUR/lotto** | 302 |
| XAUUSD | **3,4858 EUR/lotto** | 520 |
| forex, base EUR (EURUSD · EURJPY · EURAUD · EURCAD · EURGBP · EURNZD · EURCHF) | **4,0000 EUR/lotto** — *valore unico, varianza zero* | 84 |
| forex, altre basi | 2,00 → 4,66 EUR/lotto (segue il cambio della valuta base) | ~250 |

**La legge che ne esce, e che si riproduce su 20+ simboli a 3 cifre:**
`commissione = 0,004% del nozionale in valuta base, GIRO COMPLETO, addebitata in EUR`.
- EURUSD: 100.000 EUR x 0,004% = **4,00 EUR** ✅ misurato 4,0000
- USDJPY: 100.000 USD x 0,004% = $4,00 → x0,8565 = **3,43 EUR** ✅ misurato 3,4262
- GBPUSD: rapporto 4,6613/4,00 = **1,1653** = GBP/EUR ✅ · AUDUSD 0,6088 = AUD/EUR ✅ · NZDUSD 0,5026 ✅ · CHFJPY 1,0894 ✅

### ✅ L'ANCORA — verificata contro un numero scritto da un'altra sessione
`ORO_1530_CANCELLO_COSTO` §2.4 riporta la commissione oro come **0,0403 $**.
Il mio conto, per la stessa strada ma partendo dai lotti: 3,4858 EUR/lotto
÷ (TickValue 0,86289 EUR x 100 punti per 1,00 $) = **0,0404 $**.
🎯 **Stesso numero alla terza cifra, ricavato senza averlo letto.** Il metodo di
conversione e' quindi verificato **prima** di applicarlo al forex.

### 🧪 IL CONTRO-ESEMPIO CHE HO COSTRUITO PER ROMPERLO
*"E se la commissione fosse addebitata solo all'ingresso su alcuni trade e a
giro completo su altri? Allora la media sarebbe un miscuglio di due regimi."*
👉 **Rotto:** su EURUSD i valori per lotto sono **27 su 27 esattamente -4,0000**,
un **solo valore distinto**, con uscite miste (17 tp · 6 sl · 4 manuali). Stesso
risultato su EURJPY (7/7), EURAUD (7/7), EURCAD (4/4). **Nessuna bimodalita':
la cifra registrata e' il costo completo della posizione.** Le piccole variazioni
sulle basi non-EUR sono il cambio del giorno, e sono **previste dal modello**.

### 🔓 CONSEGUENZA: LA CONTRADDIZIONE NON ESISTE
Pedaggio **TUTTO COMPRESO** = spread (attraversato una volta per giro) +
commissione (giro completo), nell'unita' del simbolo:

| simbolo | spread sonda 17/08 h17 | commissione misurata | **PEDAGGIO ALL-IN** | scheda broker conto STANDARD |
|---|---:|---:|---:|---:|
| EURUSD | 0,400 pip | 0,464 pip | **0,864 pip** | 0,8-1,0 pip |
| GBPUSD | 0,200 | 0,540 | **0,740 pip** | 0,8-1,0 |
| USDJPY | 0,300 | 0,633 | **0,933 pip** | 0,8-1,0 |
| EURJPY | 0,400 | 0,739 | **1,139 pip** | 0,8-1,0 |
| EURCAD | 1,000 | 0,643 | **1,643 pip** | — |
| GBPCAD | 1,200 | 0,744 | **1,944 pip** | — |
| CHFJPY | 🔴 0 illeggibile | 0,805 | **≥ 0,805 pip** *(limite inferiore)* | — |
| GBPJPY | 🔴 0 | 0,852 | **≥ 0,852 pip** | — |
| EURAUD | 🔴 0 | 0,652 | **≥ 0,652 pip** | — |
| AUDUSD | 🔴 0 | 0,282 | **≥ 0,282 pip** | — |
| XAUUSD | 0,160 $ | 0,040 $ | **0,200 $** | — |
| 225JPY · D30EUR · U30USD · NASUSD | 35 / 2,80 / 2,00 / 1,80 pti | **0,00** | invariato | — |

> 🥇 **La riga che chiude il caso:** sui tre major il pedaggio all-in misurato
> (**0,74 · 0,86 · 0,93 pip**) cade **dentro la forbice 0,8-1,0 pip** delle
> schede. Le due letture **non si contraddicono: descrivono due prodotti
> diversi dello stesso broker.** Il nostro 50503392 e' un conto **a commissione**
> (= profilo PRO/raw: spread stretto + commissione); le schede citate danno lo
> **STANDARD** (spread largo, commissione zero). Il broker dichiara *"stesse
> condizioni di esecuzione"* per i due conti — e **il costo totale infatti
> coincide**. 👉 **Errore di CATEGORIA, non di misura. Non si media niente: si
> somma la commissione, che e' misurata.**

> 🧪 **Contro-esempio all'ipotesi alternativa** *("la sonda sbaglia di 3-5x")*:
> la sonda legge `SYMBOL_SPREAD`, **la stessa chiamata per tutti i simboli**, e
> sui tre indici la sua lettura e' **verificata contro 30,9 / 64,7 / 156,1
> milioni di tick** (D30EUR 2,80 dentro l'ora 17 che ha mediana 2,60 e P95 2,90;
> U30USD 2,00 su 1,90/2,00; NASUSD 1,80 su 1,70/1,80). Perche' l'ipotesi
> "sonda rotta" regga servirebbe un guasto **che colpisce solo il forex**: non
> ha meccanismo. L'ipotesi "commissione" ne ha uno **e riproduce il numero**.

---

## 3. ⏰ IL SECONDO ERRORE, DI CLASSE DIVERSA: L'ORA DELLA SONDA

`InfoBroker.csv` blocco `[SERVER]`: `OraServer 2026.08.17 17:34:09`,
`OraGMT 16:34:09`, `OraLocalePC 18:34:09`.
👉 **17:34 server = 16:34 GMT = 12:34 a New York = 17:34 a Londra.** E' il
tratto finale della giornata di Londra sovrapposto alla mattina di New York
(subito dopo il fixing delle 16:00 GMT): **una delle due-tre finestre piu'
liquide delle 24 ore.**

**Le ore MODALI vere delle sedie, misurate dai loro trade** (`trades_auto.csv`,
`open_time`, ora SERVER — stesso metodo che il referto ha usato sugli indici):

| sedia | simbolo | ore di apertura osservate | ora modale |
|---|---|---|---|
| 772422 EasyTrend | GBPUSD | 15, 16x3, 19 | **h16** |
| 772421 EasyTrend | CHFJPY | 13, 14, 19 | h13 |
| 772361 CostToCost | EURJPY | 4, 8, 12, 16, 20 | sparsa |
| 772362 CostToCost | GBPCAD | 4x2, 8, 12 | **h04** |
| 772162 BreakingBand | EURUSD | 13 | h13 |
| 772342 PunteLarry | EURAUD | 0x2, 9x2 | **h00** |
| 772344 PunteLarry | GBPJPY | 6 | **h06** |
| 772345 PunteLarry | GBPUSD | 4, 8 | h04 |
| 771201/02/03 PostNews | EURJPY/EURUSD/USDJPY | 14 · 19 · 13 | ora della **notizia** |
| 774101 GapContinuation | 225JPY | 1, 1 | **h01** ✅ conferma 01:00-07:30 |
| 772235 GapFill | 225JPY | 23 | **h23** |
| 770402 MaxMinNotte | XAUUSD | 7 x9 su 9 | **h07** ✅ conferma il referto |

> 🔴 **NESSUNA delle sedie forex/JPY/oro ha l'ora 17 come moda.** La sonda del
> 17/08 e' **giusta per un'ora in cui nessuna sedia lavora.** Non e' una lettura
> sbagliata: e' una lettura **fuori posto**, ed e' un difetto di classe diversa
> (va corretto misurando l'ora giusta, non buttando la sonda).

**E il VERSO dell'errore, che e' quello pericoloso.** Sui tre simboli dove
abbiamo la tabella oraria vera, le ore **00-06** costano molto piu' dell'ora 17:

| simbolo | mediana h17 | mediana h00-h06 | scarto |
|---|---:|---:|---:|
| D30EUR | 2,60 | 3,50 - 3,90 | **+35% / +50%** |
| U30USD | 1,90 | 2,70 - 2,80 | **+42% / +47%** |
| NASUSD | 1,70 | 2,30 - 2,50 | **+35% / +47%** |

👉 **Se il forex si comporta come i tre indici, le sedie che lavorano alle
h00-h08 (772362 GBPCAD, 772342 EURAUD, 772344 GBPJPY, 772345 GBPUSD, 772346
EURCAD) pagano il 35-50% IN PIU' di quanto scritto oggi.**
🔴 **Il verso e' sfavorevole: il rischio e' di aver dato per BUONE delle sedie
che non lo sono.** Questo scarto **NON viene applicato ai numeri** (sul forex e'
[NON MISURATO]): e' la ragione per cui si fa la corsa.

⚠️ **L'unica eccezione, e va detta perche' e' favorevole:** sul **225JPY** i 35
punti sono letti alle 17:34 srv = **01:34 a Tokyo con il cash CHIUSO**, mentre
`774101` lavora **h01-h07** (cash aperto). Li' il verso e' **a favore**: la
misura vera puo' solo migliorare i 13,6x/13,7x di `770924` e `774101`.

---

## 4. 🧪 LA PROVA — 5 CORSE, ZERO CODICE NUOVO

**Lo strumento esiste gia' ed e' gia' multi-simbolo.**
`mql5/Scripts/ABTG_SpreadOrario.mq5` r.54: `input string InpSimboli`.
🔴 **I file in archivio sono 3 non per un limite dello strumento, ma perche' la
corsa del 03/09 gli ha passato una lista di 3.**
✅ `RIGA_SPREAD_FLOTTA.ps1` accetta gia' `-Simboli` e `-PuntiPerIndice`
(blocco `param()`), raccoglie su Desktop in cartelle `SPREAD_FLOTTA_*`
timbrate, salva i `_PRIMA` e stampa la RIPRESA dei simboli mancanti.
✅ **Verificato che `.ps1` e `.mq5` al pin `e1c81430...` sono IDENTICI a HEAD**
(`git diff` vuoto): si riusa il pin gia' collaudato, **nessuno script nuovo
passa dal cancello**, nessun `.ps1` da riscrivere (e quindi nessun rischio
emoji/ANSI).

### 🔴 L'UNICO VINCOLO VERO: `InpPuntiPerIndice` E' GLOBALE, NON PER SIMBOLO
r.57 del `.mq5`: un solo divisore per tutta la corsa. Mescolare classi di
`Digits` nella stessa corsa **produrrebbe una tabella plausibile e falsa** —
esattamente il difetto che il referto §3 dichiara costare un fattore 100.
👉 **Si spezza per CLASSE DI DIGITS.** Divisore verificato contro la tabella
`CANCELLO_COSTO_FLOTTA` §3, che l'ha scritta indipendentemente:

| Digits | Point | divisore da passare | unita' del CSV | simboli |
|---:|---:|---:|---|---|
| 2 | 0,01 | **100** | punto indice / **dollaro** su XAUUSD | XAUUSD *(e i 3 indici gia' fatti)* |
| 0 | 1,00 | **1** | punto Nikkei | 225JPY |
| 5 e 3 | 0,00001 / 0,001 | **10** | **pip** | i 10 forex |

🧪 **Regressione obbligatoria:** con divisore 100 i tre indici gia' in archivio
**devono riprodurre cifra per cifra** (D30EUR h08 = 1,7000; U30USD h14 = 2,0000;
NASUSD h15 = 1,8000). Se non riproducono, la corsa e' invalida e si ferma.

### Le cinque tranche, in ordine di VERDETTI SBLOCCATI

| # | `-Simboli` | `-PuntiPerIndice` | sedie che sblocca | perche' prima |
|---:|---|---:|---|---|
| **T1** | `225JPY` | **1** | 770924 · 770901 · 774101 · 772235 | 4 sedie oggi NON MISURATE, due a **13,6x/13,7x**, un soffio sopra il pavimento DURO 13,3x. Base tick piccola (dal 2024.09.26) = corsa breve |
| **T2** | `EURUSD,GBPUSD,USDJPY` | **10** | 771202 · 771203 · 772422 · 772162 · 772161 · 772231 · 772232 · 772345 · 771322 · 771332 | contiene 2 delle 5 sedie che ribaltano |
| **T3** | `EURJPY,GBPJPY,CHFJPY` | **10** | 771201 · 772361 · 772344 · 772421 | contiene le altre, **e i 3 simboli con `SpreadPt = 0`** |
| **T4** | `EURCAD,GBPCAD,AUDUSD,EURAUD` | **10** | 772362 · 772342 · 772346 · 772163 · 772233 | ore modali h00-h04 = dove il verso dell'errore morde di piu' |
| **T5** | `XAUUSD` | **100** | 770402 · 971501 · 970901 · 772343 | 520 operazioni sul demo, ma tutte passano con margini +216%/+490%: **urgenza bassa** |

⚠️ **Una tranche per volta, e si raccoglie dopo ognuna**: il motore riscrive
`REFERTO_SPREAD_FLOTTA.txt` **da zero** a ogni corsa (r.384 del `.mq5`, modo
`FILE_WRITE`). I CSV per simbolo non si sovrascrivono fra tranche (nomi diversi),
**il referto .txt SI'.** Servono tutti e cinque gli zip.

⚠️ **Pre-volo**: la finestra `2024.09.26 → 2026.06.30` presume i tick gia' su
disco. Se non ci sono, il motore li chiede al server e, se non arrivano, li
conta in `blocchi persi` (r.171). 🔴 **`blocchi persi > 0` = tabella PARZIALE:
il verdetto NON si da', si riscarica con `ABTG_HistoryDownloader` e si rifa'.**

---

## 5. 🧊 LE SOGLIE — congelate qui, invariate rispetto al cancello del costo

Identiche a `R125_ORB_COSTO_CRITERI.md` §2 (non si riscrivono i criteri quando
arrivano i numeri):

| pavimento | soglia | uso |
|---|---:|---|
| **DI LAVORO** | `stop >= 40 x pedaggio` | il pedaggio vale <= 2,5% del movimento tipico |
| **DURO** | `stop >= 13,3 x pedaggio` | sotto: si scarta per aritmetica |

**Tre precisazioni congelate ADESSO, perche' cambiano i conti:**
1. 💰 **Il denominatore e' il pedaggio ALL-IN** = `spread mediano dell'ora modale
   della sedia` **+** `commissione misurata` (§2). Sull'oro il referto lo fa
   gia'; da qui in avanti si fa **anche sul forex**.
2. 📉 **Si pubblica anche la riga al P95** dell'ora, come per gli indici. Un
   verdetto dato solo sulla mediana e' meta' verdetto.
3. ⚖️ **La regola di casa non si tocca**: il campione sottile (n=1, n=2 sugli
   stop) sospende il giudizio sul **MERITO**, mai sul **RISCHIO**. E lo stop
   misurato resta un **limite inferiore** (§2.3 del referto): chi **passa**
   passa a maggior ragione, chi **non passa** e' *da confermare*.

### Verdetti, per sedia
- 🟢 **PASSA**: `>= 40x` col pedaggio all-in alla **mediana dell'ora modale**.
- 🟡 **FRAGILE**: passa alla mediana, **non** al P95 della stessa ora → si scrive
  il margine e la decisione passa a Claudio.
- 🔴 **SOTTO IL PAVIMENTO DI LAVORO**: `< 40x` alla mediana. **Non e' uno
  spegnimento**: e' una raccomandazione, e si elenca la manopola che esiste.
- ⛔ **SOTTO IL PAVIMENTO DURO**: `< 13,3x` alla mediana → si scarta per
  aritmetica, e si dice subito a Claudio.
- ⚪ **NON ANCORA MISURATO**: manca lo stop, o `blocchi persi > 0` su quel simbolo.

---

## 6. 📋 LA LISTA CHE DICE QUANTO COSTA NON MISURARE

Stop dal referto §5.4 (misurati sui trade veri, `n` a fianco). Colonna **A** =
verdetto di oggi (spread sonda, commissione dimenticata). Colonna **C** =
pedaggio all-in **misurato** di §2, ancora **all'ora sbagliata (h17)**.

| sedia | EA · simbolo | stop | **A: x (oggi)** | **C: x (all-in misurato)** | verdetto A → C | pedaggio di pareggio a 40x |
|---|---|---:|---:|---:|:--|---:|
| **772361** | CostToCost EURJPY H4 | 29,2 pip (n=3) | 73,0x 🟢 | **25,6x** 🔴 (64%) | 🔴 **RIBALTA** | 0,730 pip |
| **772162** | BreakingBand EURUSD H1 | 22,1 (n=1) | 55,2x 🟢 | **25,6x** 🔴 (64%) | 🔴 **RIBALTA** | 0,553 pip |
| **771201** | PostNews EURJPY M5 | 25,0 fissi | 62,5x 🟢 | **21,9x** 🔴 (55%) | 🔴 **RIBALTA** | 0,625 pip |
| **771202** | PostNews EURUSD M5 | 25,0 fissi | 62,5x 🟢 | **28,9x** 🔴 (72%) | 🔴 **RIBALTA** | 0,625 pip |
| **771203** | PostNews USDJPY M5 | 25,0 fissi | 83,3x 🟢 | **26,8x** 🔴 (67%) | 🔴 **RIBALTA** | 0,625 pip |
| **772422** | EasyTrend GBPUSD H1 | 35,0 (n=1) | 175,0x 🟢 | **47,3x** 🟢 (+18%) | 🟡 **regge, margine da +338% a +18%** | 0,875 pip |
| **772421** | EasyTrend CHFJPY H1 | 47,0 (n=2) | ⚪ (spread 0) | **≤ 58,4x** 🟢 *[limite superiore: spread ignoto]* | ⚪ → 🟡 **[CONDIZIONATO]** | 1,175 pip |
| **772344** | PunteLarry GBPJPY H1 | 58,6 (n=1) | ⚪ (spread 0) | **≤ 68,8x** 🟢 *[limite superiore]* | ⚪ → 🟡 **[CONDIZIONATO]** | 1,465 pip |
| **772342** | PunteLarry EURAUD H1 | 35,6 (n=2) | ⚪ (spread 0) | **≤ 54,6x** *[limite superiore]* | ⚪ → 🟡 | 0,890 pip |
| **772362** | CostToCost GBPCAD H4 | 38,9 (n=2) | 32,4x 🔴 | **20,0x** 🔴 (50%) | 🔴 resta, **peggiora** | 0,973 pip |

> ⛔ **E IL NUMERO NUOVO CHE NESSUNO AVEVA VISTO — un pavimento DURO sfondato.**
> `771201` PostNews EURJPY, **dopo il trailing a 15 pip** (`ABTG_PostNews.mq5`
> r.105): `15,0 / 1,139 = ` **13,2x**, **sotto il pavimento DURO 13,3x**.
> Il referto la dava a 37,5x. 🔴 E' la **prima sedia della flotta** che sfonda
> il muro duro con numeri misurati da tutte e due le parti.
> *(le gemelle trailate: `771202` 17,4x · `771203` 16,1x — sopra, ma di poco)*

> 🔴 **CONTEGGIO, e corregge il referto.** §4.3 dice *"otto sedie che passano
> non passano piu'"* a 1,0 pip. **A 1,0 pip le sedie che ribaltano sono SEI**
> (le cinque qui sopra + `772422`), e le altre due dell'"otto" sono `772421` e
> `772344`, che a 1,0 pip **passano** — sono i due 🟢 **[CONDIZIONATI]** aperti
> dal cancello, non dei ribaltamenti.
> 👉 **Col pedaggio ALL-IN misurato le sedie che ribaltano sono CINQUE**, e
> `772422` sopravvive con il margine sceso da +338% a **+18%**.

⚠️ **Le tre righe con `spread = 0 illeggibile` (CHFJPY, GBPJPY, EURAUD) hanno
in colonna C un LIMITE SUPERIORE**, non un verdetto: li' il pedaggio e' la sola
commissione, e lo spread vero **si somma**. Sono i tre simboli che **T3 e T4
devono misurare per primi**.

---

## 7. 🚩 COSA QUESTO COLLAUDO **NON** COPRE — dichiarato prima

| buco | stato | perche' resta aperto |
|---|---|---|
| **feed REALE 10105439 contro DEMO 50503392** | 🔴 **[NON MISURATO]** | tutte le letture (sonda, tick storici, commissioni) vengono dal **demo**. `sonda_storico_17-08/` ha 2 file BCM e **sono tutti e due del piccolo**. Il reale non e' mai stato sondato. Se il feed reale fosse piu' largo, **tutta la tabella e' ottimista** |
| **spread al MINUTO dentro l'ora** | 🔴 [NON MISURATO] | l'istogramma e' orario. Su U30USD l'ora 14 ha mediana 2,00 e **massimo 47,0** |
| **le tre PostNews** | 🔴 **il caso peggiore per costruzione** | lavorano **sul rilascio della notizia**, dove lo spread si allarga per secondi. Nemmeno la tabella oraria lo cattura: serve una misura **al minuto attorno all'evento**. I 21,9x / 28,9x / 26,8x di §6 sono quindi anch'essi **ottimisti** |
| **requote e rifiuti** | 🔴 [NON MISURABILE] dai tick | il tick storico non contiene ordini rifiutati |
| **slippage sul forex** | 🔴 [NON MISURATO] | `slippage_dettaglio_2026-09-05.csv` ha **818 righe D30EUR + 103 NASUSD e zero forex**; sul reale il ledger ha **3 deal, tutti DAX** |
| **spread di Tickmill** (`250604`) | 🔴 [NON MISURATO] | altro broker, mai sondato |
| **commissione oltre il forex/oro** | 🟢 misurata 0,00 su 7 simboli indice | conferma la riga del referto **per gli indici** (era il forex a essere sbagliato) |

---

## 8. 🪦 IL PEZZO DEL REFERTO CHE VA RITIRATO — e dove sta esattamente

`report/CANCELLO_COSTO_FLOTTA_2026-09-10.md`:
- **r.438** (§5.3, riquadro Nikkei): *"Serve `ABTG_SpreadLogger` con `,225JPY`
  nella lista. E' il buco piu' economico e piu' redditizio del referto."*
- **r.630** (§8, prima riga della tabella dei buchi): *"`ABTG_SpreadLogger` sul
  demo 50503392 raccoglie gia' dal 06/09 su 8 simboli oro compreso: manca solo
  la raccolta (`RIGA_SPREADLOGGER_RACCOLTA.ps1`) e l'aggiunta di `,225JPY`"*.

🔴 **Sono sbagliate tutte e due, e per due motivi indipendenti:**
1. **`225JPY` c'e' gia'.** `mql5/Experts/ABTG_SpreadLogger.mq5` **r.134**:
   `input string InpSimboli = "D30EUR,U30USD,NASUSD,225JPY,EURUSD,GBPUSD,USDJPY";`
   Il Nikkei e' **il quarto della lista di serie**. Non c'e' niente da
   aggiungere. *(l'unica aggiunta chiesta a Claudio il 06/09 e' `,XAUUSD`:
   `RIGA_SPREADLOGGER_DA_MANDARE.md` r.184-186 — e infatti il log dice
   **"8 simboli (8 selezionabili)"**)*
2. **Il logger NON sta raccogliendo.**
   `backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260910_033002.log`
   (10/09 03:30) elenca **52 sedie in profilo attivo su 6 cartelle dati** e
   **`ABTG_SpreadLogger` non c'e' in nessuna**: sul piccolo **50503392**
   (`C:\Program Files\BCM Markets MT5 Terminal`, profilo `ORO`) ci sono **40
   sedie**, nessuna e' lui. Era su `EURCHF H1` e `CADCHF H1` il 06-07/09
   (`CODA_02` del 07/09 e 08/09) e sul 08/09 il log dice **"fermato (motivo 1)"**.
   *(l'unico logger vivo e' `ABTG_SlippageLogger` su `C:\BCM_Reale` — un altro
   artefatto, che misura un'altra cosa e lo dichiara: "NON c'e' lo SPREAD")*

👉 **Il buco piu' economico NON e' quello.** E' `ABTG_SpreadOrario` sui **tick
storici**, §4: strumento gia' scritto, gia' passato dal cancello, gia'
multi-simbolo, **nessuna attesa** (21 mesi di storia invece di giorni di
raccolta), e **copre le ore notturne del Nikkei h01-h07 subito**, che e'
esattamente quello che a `774101` serve.
🟢 **Il SpreadLogger resta utile per il buco del §7 riga 1** (il feed **vivo**,
e soprattutto quello del **conto reale**), che i tick storici del demo non
possono chiudere. Ma e' un secondo passo, non questo.

---

_Fonti primarie, tutte sul branch `lavoro`:_
`report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` §1, §3, §4.3, §5.3, §5.4, §7, §8 ·
`data/statements/trades_auto.csv` (colonne `commission`, `volume`, `open_time`, `magic`) ·
`backtest_pipeline/risultati_archivio/sonda_storico_17-08/215D85D7_ABTG_InfoBroker.csv` blocchi `[SERVER]` e `[SIMBOLI]` ·
`backtest_pipeline/risultati_archivio/spread_flotta/spread_orario_{D30EUR,U30USD,NASUSD}.csv` + `REFERTO_SPREAD_FLOTTA.txt` ·
`backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260910_033002.log` · `CODA_02_chi_ha_operato_{20260907,20260908,20260910}*.log` · `CODA_10_slippage_20260910_033002.log` ·
`mql5/Scripts/ABTG_SpreadOrario.mq5` r.54-60, r.171, r.384 · `mql5/Experts/ABTG_SpreadLogger.mq5` r.124-134 · `mql5/Experts/ABTG_TradeExporter.mq5` r.147 ·
`backtest_pipeline/righe/RIGA_SPREAD_FLOTTA.ps1` blocco `param()` · `RIGA_SPREADLOGGER_DA_MANDARE.md` r.184-186 ·
`backtest_pipeline/caccia_strategie/CONFIG_PROP_SPREAD_SLIPPAGE_2026-09-05.md` §1.2-1.3 ·
`report/ORO_1530_CANCELLO_COSTO_2026-09-10.md` §2.4 · `backtest_pipeline/prove/R125_ORB_COSTO_CRITERI.md` §2
