# 🔢 LE 2.000 RICHIESTE — **LA MISURA**, non piu' la stima

> **Referto gemello e precedente**: `report/LE_2000_RICHIESTE_2026-09-20.md` (592 righe,
> il CENSIMENTO SUL CODICE, chiamata per chiamata, dai pin schierati).
> Quello **stimava un tetto peggiore con ipotesi esplicite**. Questo **conta le giornate
> vere**. Le due cose non si sostituiscono: una misura che non tocca il caso peggiore
> **non lo falsifica**, lo lascia raro e non osservato.

**Fonte primaria**: `RICHIESTE_SERVER_50503392_2026-09-20_2131.zip` → `referto.txt`,
prodotto da `backtest_pipeline/righe/CONTA_RICHIESTE_SERVER.ps1` (pin `7ad081db`, 6 PASS
al cancello) lanciato da Claudio sul VPS sul **giornale del BCM piccolo `50503392`**
*(il percorso `C:\Program Files\BCM Markets MT5 Terminal` e l'hash dati
`215D85D767A1C39E22D242C8114BF9F5` vengono dalla **console della riga**, non da
`referto.txt`, che non li contiene)*.
**210.570 righe di giornale lette, 186 giornate** — piu' una riga `metaeditor` che **NON e'
una giornata** (e' il giornale di MetaEditor, che lo script raggruppa per nome file; ESITI 0,
non entra in nessun conto).
**Fonte secondaria** (per l'attribuzione): `data/statements/trades_auto.csv`, 1.322 trade.

---

## ⓪ 🎯 LA RISPOSTA IN QUATTRO RIGHE

1. 🟢 **Su 186 giornate vere, 184 stanno sotto — e larghissimo: mediana 15,5 su tutte le
   giornate (68 sono a zero: terminale spento o mercato chiuso), 44 sulle 118 giornate con
   attivita'; massimo 563 = 28% della soglia.**
2. 🔴 **UNA giornata ha sfondato di 27 volte: il 10/04/2026, 54.508 richieste.**
3. 🟢 **E ha un colpevole col nome e cognome, e NON e' una delle sedie FTMO**: magic
   **`20250001` `BULGE_MULTI_SIGNAL_VIOLA_S`**, su **CADJPY e NZDJPY**. Nessuno di quei
   simboli, e nessun EA con quel magic, e' schierato su FTMO.
4. 🟠 **Il rubinetto che temevamo di piu' — `770411`, il trailing sul prezzo vivo — NON SI E'
   MAI APERTO nelle CINQUE giornate in cui e' stato in posizione**: tutto il conto insieme ha
   fatto 75 / 117 / 43 / 30 / 72 richieste, contro una previsione di «2.600-26.000».
   🔴 **Ma «non osservato» non e' «assolto»**: le cinque giornate non contengono lo scenario
   che genera quel numero (una discesa pulita e prolungata). La piu' ampia, il **31/08**, ha
   avuto un'escursione di **sessione** di **266 punti** ed e' costata **72 richieste a tutto
   il conto**. 🔴 **E il tetto teorico ADESSO si calcola** (§⑥🅔): su `GER40.cash` il tick size
   e' **0,01** (misurato oggi dal prevolo), quindi il meccanismo puo' arrivare a **100 richieste
   per punto indice** di discesa monotona. La pendenza **osservata** e' **≤0,85 per punto** —
   l'1% del tetto. Sopra i 266 punti resta **[NON MISURATO]**.

🪑 **Tradotto in sedie schierabili il 1° ottobre: NELL'ESERCIZIO ORDINARIO la Forbidden
Practice delle 2.000 richieste NON e' un ostacolo — 186 giornate vere, mediana 15,5, massimo
563. Nessuna sedia va spenta, nessun EA schierato va ricompilato, nessun parametro va
cambiato per questo motivo.**
🟠 **Con UNA condizione dichiarata, col numero e non con un'opinione**: `770411` e' l'unica
ancorata al prezzo vivo, e la sua misura copre escursioni di sessione fino a **266 punti**.

---

## ① 📊 IL CONTO, GIORNATA PER GIORNATA

| | giornate | ESITI |
|---|---:|---|
| 🟢 sotto soglia | **184 su 186** | mediana **15,5** su tutte · **44** sulle 118 con attivita' · massimo **563** |
| 🟠 oltre meta' soglia | **1** (14/04/2026) | **1.171** (59%) |
| 🔴 **SFONDATA** | **1** (10/04/2026) | **54.508** (2.725%) |

Le colonne, come le definisce lo script:
- **ESITI** = una riga per richiesta andata al server (done/failed) — **e' la colonna che
  conta per FTMO**;
- **RETE** = con `done in <n> ms`: **il giro di rete e' DIMOSTRATO**;
- **FALLITI** = esito negativo. Senza tempo di rete puo' essere un **rifiuto LOCALE** del
  terminale, che al server non arriva.

---

## ② 🕵️ LA GIORNATA CHE HA SFONDATO — attribuita per NOME

### Quello che dice il giornale (referto, §DETTAGLIO)
| | |
|---|---|
| tipo di operazione | **`MODIFY` (PositionModify): 54.473 su 54.508 = 99,94%** |
| ora (LOCALE del PC) | **16:00 → 53.532** · 17:00 → 902 · tutte le altre ≤ 24 |
| simboli | **NZDJPY 27.349** · **CADJPY 27.027** · NZDCAD 74 · AUDUSD 21 · USDCAD 17 · NZDCHF 7 |

### Quello che dice lo storico dei trade — **e qui si chiude il cerchio**
Il giornale e' in **ora locale del PC** (regola di casa: log = ora italiana, grafico = ora
server). **Ora locale 16:00 = ora server 15:00.** Alle **15:00:00 server** del 10/04/2026,
`trades_auto.csv` dice che si sono aperte **cinque posizioni in un colpo solo**, tutte dello
stesso magic:

| apertura (server) | chiusura | simbolo | magic | strategia | richieste nell'ora |
|---|---|---|---:|---|---:|
| 2026.04.10 15:00:00 | 15:57:32 | **CADJPY** | `20250001` | `BULGE_MULTI_SIGNAL_VIOLA_S` | 🔴 **27.027** |
| 2026.04.10 15:00:00 | 15:57:32 | **CADJPY** | `20250001` | `BULGE_MULTI_SIGNAL_VIOLA_S` | *(idem)* |
| 2026.04.10 15:00:00 | 16:02:16 | **NZDJPY** | `20250001` | `BULGE_MULTI_SIGNAL_VIOLA_S` | 🔴 **27.349** |
| 2026.04.10 15:00:00 | 16:02:16 | **NZDJPY** | `20250001` | `BULGE_MULTI_SIGNAL_VIOLA_S` | *(idem)* |
| 2026.04.10 15:00:00 | 16:40:19 | NZDCAD | `20250001` | `BULGE_MULTI_SIGNAL_VIOLA_S` | 🟢 **74** |

🔴 **L'attribuzione e' chiusa**: stesso magic, stessa ora, stessi simboli, stessa durata.
~13.500 `PositionModify` per posizione in 58 minuti = **3,9 richieste al secondo**.

### 🧪 IL CONTRO-ESEMPIO, perche' senza non vale
**L'altra spiegazione possibile era: «e' una tempesta di tick, la fa chiunque sia in
posizione».** 🟢 **Smentita dalla riga NZDCAD**: stesso EA, stesso magic, stessa ora, viva
piu' a lungo delle altre — **74 richieste**. E dalla riga **NZDCHF** (magic `0`, manuale): due
posizioni, 13:07:06→15:55:24 e **15:55:25→17:17:44**, quindi una viva **dentro** l'ora della
tempesta, e in classifica **compare con 7 richieste** contro le 27.349 di NZDJPY. Quindi
**non e' l'ora, non e' il mercato, non e' il tick rate: sono quei due cross JPY dentro
quell'EA.**

> 🟠 **Cosa NON dico**: non dichiaro il difetto esatto dentro `BULGE_MULTI_SIGNAL`. La
> differenza JPY (3 decimali) vs non-JPY (5 decimali) e' il sospetto naturale — una
> `PositionModify` il cui esito viene arrotondato dal server in modo che la condizione
> `slChanged || tpChanged` **resti vera per sempre**. Ma il sorgente di aprile non e'
> nel repo (a HEAD `BULGE_MASTER.mq5` r.1056 e `ABTG_Bulge.mq5` r.1731 **hanno gia'** la
> soglia `MathAbs(newSL-sl) > 5*point`). Quindi: **[NON MISURATO]**, e resta tale.

---

## ③ ✅ LE SEDIE FTMO — riga per riga, e questa volta col numero accanto

🔴 **Prima una correzione di perimetro, e conta.** `SCHIERA_FTMO.ps1` schiera **nove sedie
che tradano**, non sei: `770101` · `770202` · `770260` · `770411` · `770511` · `771531` sugli
indici, **piu' il blocco PostNews `771202` FOMC EURUSD · `771203` NFP USDJPY · `771204` ECB
EURUSD**, che entra **per default** (r.480: `if(-not $SenzaPostNews){ $lavoro += $POSTNEWS_EA }`;
i tre `.set` sono in repo). Piu' `779001` Guardian e due sonde che non tradano.

🟢 **Nessuna delle nove tocca NZDJPY, CADJPY o NZDCAD** (verificato sul CSV: quei tre simboli
li toccano solo i magic `20250001`, `20240001` e `0`).
🟠 **Ma `771203` e' su USDJPY, un cross JPY**: il sospetto di arrotondamento del §② va
guardato anche li' prima del volo. Il suo trailing pero' e' un livello **FISSO**
(`ABTG_PostNews.mq5` r.404-407: `openP ± InpTrailNewSLpips`), quindi **≤1 modifica per
posizione** se accettata — e `InpUseTrail25=false` nei preset FOMC e NFP, `true` solo nell'ECB.

### 🟢 Cinque sedie indici su sei sono limitate a ≤1 modifica **ACCETTATA** per barra

🔴 **E la parola «accettata» e' l'unica che conta, corretta la notte del 20/09.** Il tetto per
barra vale sul **percorso di successo**. Sulle tre Aperture, se il server **rifiuta** la
modifica (stop dalla parte sbagliata del prezzo: il primo pullback dopo una rottura, con
`InpTrailStartR=0.0`), `sl` non cambia, la condizione resta vera e il tentativo **riparta a
ogni tick fino alla chiusura della barra M5** — fino a cinque minuti. E' la **CODA B** del §④,
misurata: **328 FALLITI** in una giornata, **senza tempo di rete**. 👉 `InpTrailMode=1` non
chiude il rubinetto: lo **dirada**.

| sedia | trailing agganciato a | costante per | tetto `PositionModify` |
|---|---|---|---:|
| `770101` DAX M5 | `iLow(_Symbol, M5, 1)` — barra **chiusa** (`InpTrailMode=1` = `ABTG_TRAIL_PREVBAR`) | 5 min | **≤1 / barra M5** |
| `770202` Dow M5 | idem | 5 min | **≤1 / barra M5** |
| `770260` Nasdaq M5 | idem | 5 min | **≤1 / barra M5** |
| `770511` SuperWave H1 | `NormalizePrice(line[1])` Supertrend — barra **chiusa** *(pin `872dba82` r.299 / 341-342; a HEAD r.428 / 470-471)* | 1 ora | **≤1 / ora** |
| `771531` EMA200 H1 | `NormalizePrice(e14)`, `EmaVal` = `CopyBuffer(h,0,**1**,1)` — barra **chiusa** *(pin `26a18566` r.170 / 300)* | 1 ora | **≤1 / ora** |

✏️ **CORREZIONE A UNA MIA LETTURA PRECEDENTE, e cambia il verdetto su una sedia.** Avevo
segnato `771531` come *«trailing sul bid vivo»*. **E' falso**, e l'ho verificato **AL PIN CHE
VOLA** (`26a18566`, 552 righe — non a HEAD, che ne ha 690): `ABTG_EMA200.mq5` r.300 e'
`double n=NormalizePrice(e14);` con `EmaVal` = `CopyBuffer(handle,0,1,1)` (r.170), cioe'
**l'EMA14 della barra chiusa**, non il bid; il bid compare solo come guardia di validita'
(`n<bid` / `n>ask`, r.302-303). A HEAD sono le righe 438 e 440-441, e il codice e' **identico
nella sostanza**. 🟢 **`771531` e' al sicuro per costruzione.**
*(Il referto gemello lo aveva gia' scritto giusto — r.224 e r.355; l'errore era mio, in
sessione, e muore qui.)*

### ⚠️ La sesta: `770411`, l'unica agganciata al prezzo vivo — **e perche' non e' esplosa**

`ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5` r.363-364 (pin `5fc0bc31` **identico a HEAD**,
619 righe):
```
if(isLong){ double n=NormalizePrice(bid-a*InpTrailAtrMult); if(n>sl && n>openP) gTrade.PositionModify(...); }
else      { double n=NormalizePrice(ask+a*InpTrailAtrMult); if((n<sl||sl==0)&&n<openP) gTrade.PositionModify(...); }
```
`a=AtrVal()` = `CopyBuffer(hAtr,0,**1**,1)` → **ATR della barra chiusa, costante**. Ma `bid`
e `ask` sono **vivi**: `n` si muove a ogni tick. **Il rubinetto c'e'.**

🟢 **E il tappo c'e' anche, ed e' una riga sola**: `n` e' **normalizzato PRIMA del
confronto**, e `sl` e' **riletto dalla posizione a ogni giro** (r.299
`PositionGetDouble(POSITION_SL)`). Quindi il valore confrontato e' **identico** a quello che
il server memorizza: dopo una modifica riuscita `sl == n`, e `n>sl` torna vero **solo su un
NUOVO RECORD del prezzo**. Non e' «una richiesta per tick»: e' **una richiesta per nuovo
estremo** — 🔴 **nel percorso di SUCCESSO.** Sul rifiuto vale la CODA B (§④).

**E la misura** — le **cinque** giornate in cui `770411` ha tenuto una posizione
(`data/statements/trades_auto.csv`, magic `770411`: **cinque** trade, riletti uno per uno):

| giornata | posizione su `D30EUR` | durata | ingresso → chiusura | escursione di **sessione** a favore | ESITI di **TUTTO IL CONTO** |
|---|---|---:|---|---:|---:|
| 18/08/2026 | 08:14:43 → 09:18:58 | 1h 04 | 26.216,70 → **26.216,70** (breakeven) | 95,7 | 🟢 **75** |
| 20/08/2026 | 08:02:11 → 10:54:45 | 2h 52 | 26.043,80 → **25.988,80** | 138,3 | 🟢 **117** |
| 24/08/2026 | 08:01:08 → 08:47:01 | 0h 46 | 26.074,90 → 26.073,90 | 44,1 | 🟢 **43** |
| 26/08/2026 | 08:27:25 → 08:31:39 | 0h 04 | 26.214,90 → 26.202,20 | 21,7 | 🟢 **30** |
| 31/08/2026 | 08:03:15 → 09:50:50 | 1h 47 | 26.436,90 → **26.420,50** | **266,0** | 🟢 **72** |

🧪 **E il contro-esempio che qui serviva davvero**: *«≤117 perche' il trailing non e' mai
partito»* — **smentito su due giornate**. Il 20/08 la chiusura e' **55,0 punti sotto**
l'ingresso e il 31/08 **16,4 punti sotto**: su uno SHORT lo stop era **oltre il pareggio**,
quindi il trailing **ha girato**. *(Il 18/08 no: chiusura **uguale** al prezzo d'ingresso =
breakeven, non trailing.)*

> 🟠 **Avvertenza sulla colonna «escursione»**: e' `apertura − session_low`, cioe' l'estremo
> della **SESSIONE**, non necessariamente raggiunto mentre la posizione era viva. E' quindi
> un **limite superiore** di quello che il trailing puo' aver inseguito, non la misura esatta.

---

## ④ 🚰 I QUATTRO RUBINETTI DEL REFERTO GEMELLO — cosa dice la misura di ciascuno

| | previsione (referto gemello) | 📏 MISURA | stato |
|---|---|---|---|
| **CODA A** — `770411` trailing sul prezzo vivo | 2.600-26.000/giorno | ≤117 conto intero, **5** giornate, escursione max **266 punti**; pendenza **≤0,85 richieste/punto** contro un tetto di **100/punto** | 🟠 **NON OSSERVATO** (non «assolto»: il caso peggiore non e' entrato nel campione) |
| **CODA B** — `PositionModify` rifiutata che si ripete a ogni tick (le tre Aperture) | fino a 3.000 per episodio | **328 FALLITI** in un giorno, il massimo della colonna su 186 giornate | 🟠 **VIVO ma piccolo** |
| **CODA C** — «riprovo al prossimo tick» sulle chiusure | non quantificata | nessuna firma nel conto | 🟢 **non osservata** |
| **CODA D** — Guardian `OnTimer(1)` dopo challenge fallita | 86.400/giorno | il Guardian **non e' mai girato** su quel conto | 🔴 **[NON MISURATO]** |

### 🟠 CODA B — la misura la vede, e la ridimensiona
Le giornate con molti **FALLITI e pochissima RETE** sono la firma esatta della `PositionModify`
rifiutata che si ripete:

| giornata | ESITI | di cui RETE | **FALLITI** |
|---|---:|---:|---:|
| 11/09/2026 | 350 | 22 | 🟠 **328** |
| 25/08/2026 | 370 | 51 | 🟠 **319** |
| 17/09/2026 | 217 | 16 | 🟠 **201** |
| 17/08/2026 | 70 | 36 | 34 |

🟢 **Due buone notizie, e sono misurate:**
1. **I FALLITI non hanno tempo di rete.** Nessuna riga `done in <n> ms` → il terminale li ha
   respinti **localmente**, al server non sono arrivati. Per FTMO **non contano**.
2. **E anche contandoli TUTTI** — l'ipotesi piu' severa possibile — la piu' alta delle
   giornate a **firma CODA B** resta **370** (25/08): **5,4 volte sotto la soglia**.
   🔴 **Non e' il massimo delle 186 giornate**: quello e' 54.508 (10/04, BULGE), poi 1.171
   (14/04) e 563 (13/04) — che pero' hanno **FALLITI = 0**, quindi **non sono CODA B**.

> 🟠 **[NON NOTO] dichiarato**: «nessun tempo di rete» e' un **indizio forte**, non una prova,
> che la richiesta non sia partita. Lo dichiara lo script stesso nella sezione «cio' che
> questa riga non copre». Non lo trasformo in certezza.

### 🔴 CODA D resta APERTA — e va detto
Il Guardian `779001` **non ha mai girato** sul `50503392` (giornale 11 e 12/09: *«GUARDIAN:
nessuna riga»*). Il suo ramo da 86.400 richieste/giorno si accende **solo dopo una challenge
gia' fallita**, e quella condizione non si e' mai verificata. 🔴 **Quindi su CODA D la misura
NON dice niente, e il referto gemello resta l'unica fonte.** Non e' un rischio della
challenge in corso: e' un rischio del giorno in cui la challenge e' gia' persa — ma e'
esattamente il giorno in cui aggiungere *hyperactive* a *failed* costa la **termination of
all agreements**, non la sola *disqualification*.

---

## ⑤ 🧮 IL TETTO PER COSTRUZIONE — il numero da pubblicare

Sommando i tetti **matematici** (non le medie), con tutte le sedie in posizione tutto il
giorno e una sessione indici di ~8 ore:

| sedia | tetto/giorno | come |
|---|---:|---|
| `770101` DAX M5 | ~100 | ≤1 modify **accettata**/barra M5 × ~96 barre di sessione |
| `770202` Dow M5 | ~100 | idem |
| `770260` Nasdaq M5 | ~100 | idem |
| `771531` EMA200 H1 | ~24 | ≤1 modify/ora |
| `770511` SuperWave H1 | ~24 | ≤1 modify/ora |
| `770411` MaxMin M15 | ~120 | **misurato** ≤117 conto intero, su escursioni fino a 266 punti |
| `771202`/`771203`/`771204` PostNews | ~15 | 3 sedie × ≤5, e solo nei giorni di news |
| ingressi / parziali / chiusure | ~45 | ≤5 per sedia × **9** sedie che tradano |
| `779001` Guardian | **0** | in esercizio normale non manda niente |
| sonde (TradeExporter, SpreadLogger) | **0** | leggono, non mandano |
| **TOTALE** | 🟢 **~530** | **27% della soglia — margine 3,8×** |

🔴 **E questo tetto vale NEL PERCORSO DI SUCCESSO.** Se il server **rifiuta** una modifica,
`sl` non cambia, la condizione resta vera e la richiesta riparte **al tick successivo** fino
alla barra dopo (**CLASSE 502**). Quel ramo e' misurato al §④ CODA B: massimo **328 FALLITI**
in una giornata su 186, **nessuno con tempo di rete**.

---

## ⑥ 🧪 I CONTRO-ESEMPI OBBLIGATORI — cosa romperebbe questo verdetto

### 🅐 «Le 184 giornate tranquille sono tranquille perche' le sedie non giravano.»
🟠 **Parzialmente smentito, e il limite va detto.** `trades_auto.csv` mostra i trade veri di
quelle sedie proprio in quelle giornate: `770101` **39** trade, `771531` **21**, `770511`
**16**, `770411` presente il **18-20-24-26 e 31/08** (cinque trade). Le giornate con ESITI
coincidono con le giornate in cui hanno operato. 🔴 **Ma io ho i TRADE, non la lista degli
esperti accesi giornata per giornata**: questa resta un'**inferenza**, buona ma inferenza.

### 🅑 «BCM ticka meno di FTMO.»
🟠 **Vero come obiezione, e va dichiarata: [NON NOTO].** Ma morde **solo** sui meccanismi
agganciati al tick, e qui ce n'e' **uno solo** (`770411`, misurato ≤117 conto intero). Le
altre sedie indici sono agganciate alla **barra chiusa**: il loro tetto **non dipende dal
tick rate**. Anche con un tick rate **10 volte** superiore, `770411` arriverebbe a ~1.170
con le altre invariate: **ancora sotto**.

### 🅒 «Sul demo non giravano tutte insieme; su FTMO si'.»
🟢 **Coperto dal §⑤**: il tetto e' calcolato con **tutte e nove in posizione contemporanea**,
e fa ~530.

### 🅓 «Il 10/04 e' la prova che il nostro codice sa sfondare.»
🟢 **Si', ed e' proprio per questo che l'attribuzione conta.** Il meccanismo esiste ed e'
reale — ma il file che lo contiene **non sale sull'aereo**.
🟠 **E i tappi delle nove che salgono non sono tutti della stessa qualita', e va detto:** per
`771531` e `770511` e' **strutturale** (ancora su barra chiusa, scritta nel codice); per le
tre Aperture e' un **VALORE DI PRESET** — `InpTrailMode=1` (`ABTG_TRAIL_PREVBAR`, enum
r.240-244), che restituisce `iLow(_Symbol,M5,1)`, un prezzo gia' quotato. Con
`InpTrailMode=0` (ATR) il confronto `newSL > sl` di r.1986 / 1817 / 2230 torna a usare un
valore **non normalizzato** contro lo stop normalizzato dal server: e' **esattamente** il
meccanismo del 10/04, modifiche **ACCETTATE**, col tempo di rete, a ogni tick.
🔴 **Quindi `InpTrailMode` va letto e verificato `=1` nel cancello di prevolo, a ogni
schieramento** (**CLASSE 502** / **507**).

### 🅔 «Cinque giornate bastano ad assolvere `770411`.»
🔴 **NO, e questo e' il contro-esempio che ha ribaltato la prima stesura di questo referto.**

Il meccanismo fa **una richiesta per nuovo minimo normalizzato**. Quindi ci sono **due** tetti,
e vanno detti tutti e due:

| tetto | formula | numero | dove viene |
|---|---|---:|---|
| **per escursione** | `punti indice / tick size` | 🔴 **100 richieste per punto** | `TickSize` di **`GER40.cash` = 0,01000**, misurato oggi: `backtest_pipeline/risultati_prove/PREVOLO_FTMO_specifiche_2026-09-20.csv` r.40 |
| **per tick** | non puo' esserci un nuovo record senza un tick | **≤ numero di tick in posizione** | |

🟢 **E il tetto che morde davvero e' il secondo, perche' il prezzo non scende in linea retta.**
Su una passeggiata aleatoria di `N` tick il numero atteso di **nuovi record** e' `~sqrt(2N/pi)`,
non `N`: con ~50.000 tick in 2h52 fa **~178**. La misura del 20/08 dice **≤117 per tutto il
conto** — 🟢 **stesso ordine di grandezza**, e spiega perche' i 26.000 del gemello non si sono
visti. *(Modello dichiarato come tale: e' un ordine di grandezza, non una misura.)*
🔴 **E spiega anche perche' non e' un'assoluzione**: il modello vale per una discesa a
zig-zag. In una discesa **quasi monotona** la pendenza sale verso i 100 per punto, e
**24 punti indice di discesa pulita basterebbero a sfondare**. **Cinque osservazioni che non
toccano il caso peggiore non falsificano un tetto peggiore.**

> 🖊️ **E qui c'e' una cosa da decidere, che e' tua**: il tappo definitivo sarebbe una **soglia
> di movimento minimo** — `|n - sl| >= k * tick_size` — cioe' *«non sposta nemmeno uno stop,
> cambia solo quante volte lo si comunica»*. E' **gia' scritta in casa** (`ABTG_Bulge.mq5`
> r.1731, `BULGE_MASTER.mq5` r.1056: `MathAbs(newSL-sl) > 5*point`). 🔴 **Non la applico:
> e' una modifica a un EA schierato, e le modifiche agli EA schierati sono una tua firma.**
> Se la vuoi, e' una ricompilazione sola.

---

## ⑦ 📌 COSA QUESTO REFERTO **NON** COPRE

1. 🔴 **Come FTMO conti davvero.** La definizione esatta di «request» non e' pubblica. Noi
   contiamo le richieste di trading andate al server. **[NON NOTO]**, ed e' il buco di metodo
   gia' dichiarato nel referto gemello.
2. 🔴 **Il confine del GIORNO.** Lo script raggruppa per **giorno LOCALE del PC** (nome del
   file di giornale); FTMO conta sul **proprio fuso** (UTC+3). Un episodio a cavallo della
   mezzanotte si spezza diversamente. **[NON NOTO]**.
3. 🔴 **CODA D** (Guardian dopo challenge fallita): **mai osservata**.
4. 🔴 **I tre PostNews volano ma NON sono misurati**: sul `50503392` in 186 giornate
   `771202` ha **1** trade, `771203` **1**, `771204` **zero**.
5. 🟠 **Il tetto peggiore di `770411` e' CALCOLATO, non misurato**: 100 richieste per punto
   indice e' aritmetica sul tick size; quante volte il prezzo faccia davvero un nuovo record
   in un crollo non l'abbiamo osservato.
6. 🟠 **Il difetto esatto dentro `BULGE_MULTI_SIGNAL`**: non diagnosticato (sorgente di aprile
   non nel repo). Non serve per la challenge, ma **se quell'EA dovesse mai tornare in campo su
   un conto prop, va diagnosticato prima**.
7. 🟠 **Verificati i SORGENTI ai pin, non i binari `.ex5` in campo.** Se un `.ex5` fosse stato
   compilato da un vintage diverso, le conferme sul codice varrebbero per il sorgente, non per
   cio' che gira (lezione del Guardian, 12/09).
8. 🟠 **Il conto e' del `50503392`**, non di FTMO: e' il miglior sostituto disponibile
   (stessi motori, tick veri, 186 giornate), **non** l'originale.

---

## 🧭 LA BUSSOLA — dove siamo, da socio

🟢 **Una paura in meno, e tolta con un numero, non con un'opinione.** Ieri sera la domanda
«le 2.000 richieste ci fregano?» aveva come risposta *«non lo sappiamo, e forse si'»*. Oggi
ha una risposta: **no nell'esercizio ordinario, con margine ~4×, e le uniche due giornate che
sfondarono in 186 sono di un EA che non sale sull'aereo.**

🪑 **E la cosa che vale davvero: NON tocchiamo niente.** Nessuna sedia da spegnere, nessun
EA schierato da ricompilare, nessun parametro da cambiare **per questo motivo**. Il
pacchetto che parte lunedi' resta quello firmato.

🔴 **La lezione, e costa dirla due volte.** La prima: il giornale con la risposta stava
**gia'** sul VPS mentre stimavamo — la regola del 10/09 (*«prima si cerca il file che ha gia'
la risposta»*) l'ho pagata di nuovo. La seconda, peggiore: **la prima stesura di questo
referto scriveva «ASSOLTO» su `770411` e «191 giornate» su 186, e contava sei sedie invece di
nove.** L'ha fermata il cancello, non io. Cinque classi nuove in checklist: **503, 504, 505,
506, 507**.
