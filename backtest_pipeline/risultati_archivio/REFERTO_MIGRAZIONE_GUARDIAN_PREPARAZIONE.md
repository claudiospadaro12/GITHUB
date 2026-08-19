# 🛡️ MIGRAZIONE GUARDIAN → FLOTTA — REFERTO DI PREPARAZIONE

_Decisione **n.1** del `report/PIANO_PROP.md` v12. Verbale delle firme:
`report/FIRME_2026-08-18.md` (B1 pausa morbida 4,0% · C1 cap 3,25% di rischio
aperto = 5 SL vivi da 0,65%)._

**Il problema, in una riga:** le firme B1 e C1 sono congelate dal 18/08, ma
**nessun EA legge le bandiere**. Ieri sera il conto piccolo stava a **~4,84% di
rischio aperto simultaneo** contro un cap firmato di **3,25%**: il Guardian
**vedeva** e **scriveva**, ma dall'altra parte del filo non c'era nessuno.

> ⚠️ **Nota di ambiente, dichiarata subito.** Questa sessione **non compila e non
> fa backtest**: niente MetaEditor, niente Strategy Tester. Tutto quello che
> segue e' **revisione statica + scrittura di codice**. La prova la fa Claudio,
> col ciclo di collaudo scritto in fondo. Nessuna riga qui dentro dice "funziona":
> dicono "e' coerente con la logica" e "va verificato cosi'".

---

## PARTE 1 — 🔎 LA RICOGNIZIONE (fatta PRIMA di toccare il codice)

### 1.1 Scoperta principale: **il filo e' gia' teso da UNA parte sola**

Il canale non e' da inventare: **esiste ed e' completo lato Guardian.**

`mql5/Experts/ABTG_Guardian.mq5` **v1.10** gia' scrive, a ogni giro di timer
(1 secondo), tutte e cinque le GlobalVariable per-conto:

| GlobalVariable | scritta a | significato |
|---|---|---|
| `ABTG_PAUSA_GIORNO_<login>` | `SetPausa()` (riga 174) | timestamp di accensione della pausa morbida B1 |
| `ABTG_PAUSA_FINO_<login>` | `SetPausa()` | scadenza dichiarata (rete di sicurezza se il Guardian muore acceso) |
| `ABTG_CAP_RISCHIO_<login>` | `OnTimer()` (righe 359-373) | timestamp **ri-timbrato ogni secondo** finche' il cap C1 e' violato; `0` appena rientra |
| `ABTG_RISCHIO_APERTO_<login>` | `OnTimer()` (riga 357) | il rischio aperto in % (informativo, sempre aggiornato) |
| `ABTG_GUARDIAN_BATTITO_<login>` | `OnTimer()` (riga 286) | battito; azzerato in `OnDeinit()` |

Il calcolo del cap **c'e' gia' ed e' quello giusto**: `OpenRiskPct()` (riga 140)
somma su **TUTTE** le posizioni del conto, **qualsiasi magic** — la regola prop e'
sul conto, non sulla sedia — usando `OrderCalcProfit()` con ripiego
`tick_value/tick_size`, e conta a parte le posizioni **senza SL** (rischio
IGNOTO: si segnala, non si somma).

📌 **Conseguenza operativa:** il punto 2 della missione ("se il calcolo c'e'
gia', aggiungi SOLO la pubblicazione della bandiera") si riduce a **ZERO
modifiche di sostanza al Guardian**. La bandiera e' gia' pubblicata, con la
semantica giusta: **timestamp ri-timbrato** invece di un `0/1` secco. E' la
stessa cosa del `0/1 + battito` chiesto dalla missione, ma **piu' robusta**,
perche' il fail-open e' incorporato nella bandiera stessa: se il Guardian
smette di timbrare, il cap **scade da solo** e nessuno resta bloccato.

E anche il lettore esiste: `mql5/Include/ABTG_PausaGuardian.mqh` **v1.00** ha
gia' `PausaGiornoAttiva()`, `CapRischioAttivo()`, `GuardianVivo()`,
`RischioApertoPct()` e la scorciatoia `ABTG_PuoAprire()`.

🔴 **Quindi il buco vero e' UNO SOLO, ed e' l'ultimo metro: NESSUN EA include
quel file e nessuno chiama quelle funzioni.** Verificato meccanicamente:
`ABTG_PausaGuardian.mqh` compare in **0** file di `mql5/Experts/`.

### 1.2 Il censimento dei punti di apertura — 48 EA vivi

Fonte della lista sedie: `FLOTTA_ATTIVA.md` (52 grafici del 02/08 + la sedia
nuova GapContinuation del 16/08 + il duello PTE del 17/08) incrociato con
`report/CONTRATTI_SEDIE.md` (44 sedie di trading censite dai `.chr` del 18/08).
Esclusi: `ABTG_Guardian` e `ABTG_TradeExporter` (utility, non tradano) e
`ABTG_Apertura_Marco` (🛑 **ritirato il 06/08**, doppione del DAX_Apertura_EU).

**Buona notizia: la flotta ha uno stile unico.** Quasi ogni EA ha **UN SOLO
imbuto d'ingresso**, una funzione dedicata che calcola lotto/SL/TP e manda
l'ordine. Il censimento completo:

#### A) Imbuto SINGOLO, invio a coppia `Buy`/`Sell` in un ternario (1 punto di innesto)

| EA | funzione | riga | tipo ordine |
|---|---|---:|---|
| `ABTG_PTE` | `Enter()` | 356 | market |
| `ABTG_PTE_Ottimizzato` | `Enter()` | 412 | market |
| `ABTG_EMA200` | `PlaceLimit()` | 229 | limit |
| `ABTG_EMA200_Ottimizzato` | `PlaceLimit()` | 229 | limit |
| `ABTG_BreakingBand` | `Enter()` | 1075 | market |
| `ABTG_GapFill` | `TryEnter()` | 478 | market |
| `ABTG_CostToCost` | `TryEnter()` | 724 | market |
| `ABTG_WOL` | `Enter()` | 264 | market |
| `ABTG_HARSI` | `Enter()` | 239 | market (una riga sola) |
| `ABTG_ORB_Fibo` | `EnterFibo()` | 259 | market |
| `ABTG_SupertrendInvert` | `Enter()` | 270 | market |
| `Gold_Ichimoku_TK_ATR_EA` | `OpenTrade()` | 477-479 | market (due `if`) |
| `BREAKOUT_EA_JPY` | `TryOpen()` | 333 | market |
| `BREAKOUT_EA_JPY_Multi` | `TryOpen()` | 438 | market (multi-simbolo) |

#### B) Imbuto SINGOLO con **due invii** (market + pendente, o buy + sell separati) — 2 punti

| EA | funzione | righe | nota |
|---|---|---:|---|
| `ABTG_SupertrendReversal` | `Enter()` | 265 / 278 | 1/3 a mercato + 2/3 pendente |
| `ABTG_SupertrendReversal_Ottimizzato` | `Enter()` | 251 / 264 | idem |
| `ABTG_SupertrendReversal_Multi` | `Enter()` | 255 / 268 | idem |
| `ABTG_SupertrendReversal_Multi_Ottimizzato` | `Enter()` | 255 / 268 | idem |
| `ABTG_SupRev_DAX_H1_Ottimizzato` | `Enter()` | 252 / 265 | idem |
| `ABTG_SupRev_DAX_H4_Ottimizzato` | `Enter()` | 252 / 265 | idem |
| `ABTG_SupRev_DOW_H1_Ottimizzato` | `Enter()` | 252 / 265 | idem |
| `ABTG_SupRev_DOW_H4_Ottimizzato` | `Enter()` | 252 / 265 | idem |
| `ABTG_SupRev_NAS_H1_Ottimizzato` | `Enter()` | 252 / 265 | idem |
| `ABTG_SupRev_CAC_H4_Ottimizzato` | `Enter()` | 252 / 265 | idem |
| `ABTG_SuperWave` | `Enter()` | 244 / 258 | idem |
| `ABTG_SuperWave_DAX_H4_Ottimizzato` | `Enter()` | 244 / 258 | idem |
| `ABTG_SuperWave_DOW_H1_Ottimizzato` | `Enter()` | 244 / 258 | idem |
| `ABTG_MaxMinNotte` | `TryPlace()` | 238 / 250 | BuyStop + SellStop (straddle) |
| `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` | `TryPlace()` | 239 / 251 | straddle |
| `ABTG_Nightly` | `TryPlace()` | 218 / 229 | SellLimit + BuyLimit |
| `ABTG_Nightly_Ottimizzato` | `TryPlace()` | 218 / 229 | idem |
| `ABTG_PostNews` | `PlaceOrders()` | 192 / 202 | straddle sulla news |
| `ABTG_PunteLarry` | `TryPlace()` | 694 / 697 | stop **oppure** limit (due rami) |
| `ABTG_EasyTrend` | `TryEnter()` | 1101 / 1117 | limit **oppure** market |
| `ABTG_GoldenCross` | `Enter()` | 425 / 434 | market **oppure** limit |
| `ABTG_GoldenCross_Ottimizzato` | `Enter()` | 360 / 369 | idem |
| `ABTG_ORB` | `TryPlace()` 220/232 + `TryCloseConfirmEntry()` 333 | 3 punti | straddle + conferma di chiusura |
| `ABTG_ORB_Ottimizzato` | `TryPlace()` 281/296 + `TryCloseConfirmEntry()` 427 | 3 punti | idem |
| `ABTG_SuperWave_EA` | `TryEnter()` | 237/238/239 | **3 tranche** L1/L2/L3 in un colpo |

#### C) 🔴 I quattro "grossi" — motori a fasi con **6 imbuti** ciascuno

`ABTG_DAX_Apertura_EU`, `ABTG_Dow_Apertura_US`, `ABTG_Nasdaq_Apertura_US`
(e i tre `_Live5m` che ne sono i fratelli ridotti a 2 imbuti):

| imbuto | cosa fa | stato mutato PRIMA dell'invio? |
|---|---|---|
| `TryPlaceBreakout()` | straddle BuyStop/SellStop sul range | ❌ no |
| `TryPlaceRangeFade()` | limit contro-rottura | ❌ no |
| `TryPlaceDelayed()` | ingresso a mercato ritardato | ❌ no |
| `TryPlaceGapFill()` | stop sul riempimento del gap | ❌ no |
| `MonitorOpenConfirm()` | entra se la candela **apre** oltre | ✅ **SI**: `gLastOCBar = bt` (riga 1348) |
| `MonitorRetest()` | rottura → limit sul livello | ✅ **SI**: `gBrokeHigh/gBrokeLow = true` (riga 1455) |

Le versioni `_Ottimizzato` di DAX_Apertura_EU e Nasdaq_Apertura_US sono
**potate**: solo `TryPlaceBreakout()` + `TryPlaceGapFill()` (2 imbuti, 4 punti).

### 1.3 🚨 Le tre trappole trovate nella ricognizione

**Trappola 1 — la guardia NON va in cima alla funzione.**
`MonitorRetest()` scrive `gBrokeHigh = true` **prima** di mandare l'ordine, e
`MonitorOpenConfirm()` scrive `gLastOCBar`. Se la guardia stesse in cima e
bloccasse l'ingresso, la rottura **non verrebbe registrata**: appena il cap
rientra, l'EA piazzerebbe il limit su un livello ormai vecchio, a prezzi che il
backtest non ha mai visto. **Sarebbe un cambio di strategia mascherato da
regola di rischio.**
✅ **Regola di casa fissata qui: la guardia va SEMPRE immediatamente PRIMA
dell'invio, mai in cima all'imbuto.** Cosi' l'EA continua a ragionare come
sempre e cambia una cosa sola: **l'ordine non parte**. E' esattamente
equivalente a un rifiuto del broker, caso che ogni EA gestisce gia'.

**Trappola 2 — `ABTG_GapContinuation` usa `Trade.Buy/Sell` anche per CHIUDERE.**
`ClosePartial()` (righe 1101-1103, commento `PARZ`) manda un ordine di senso
opposto per la chiusura parziale in **hedging**. 🔴 **Se la guardia finisse li',
bloccherebbe una PRESA DI PROFITTO** — cioe' aumenterebbe il rischio invece di
ridurlo, l'esatto contrario della firma C1.
✅ **`ClosePartial()` NON si tocca.** Innesto solo in `TryEntry()` (righe 994 e
1047). Questa e' anche la ragione per cui si e' **scartato** il disegno
elegante (una sottoclasse di `CTrade` che intercetta tutti gli invii con **una
riga per EA**): non sa distinguere un'apertura da una chiusura. Piu' righe, ma
verificabili una per una.

**Trappola 3 — i pendenti gia' piazzati restano vivi.**
Meta' della flotta lavora con ordini **pendenti** (stop/limit). La guardia
impedisce di **piazzarne di nuovi**; un pendente piazzato ieri, quando il cap
era libero, **scattera' lo stesso** e potra' portare il rischio aperto oltre il
3,25%.
📌 **Va detto e non nascosto: questo e' un cap sull'AGGIUNTA di rischio, non un
cap istantaneo.** Il tetto duro sul rischio gia' in campo resta mestiere del
Guardian (che chiude), non degli EA. Da mettere agli atti come limite noto,
insieme al pacchetto Guardian firmato (pausa 4,0 / emergenza 4,9 e 9,9).

### 1.4 Conteggio finale della ricognizione

- **48 EA vivi** da modificare.
- **Punti di innesto reali: 74** (contati a lavoro finito: 1-2 per EA, **7 sui
  tre "grossi"**, 2 sui ridotti).
- **0 modifiche di sostanza al Guardian** (il canale c'e' gia').
- **0 modifiche alla logica di trading**: nessun calcolo di lotto, SL, TP,
  filtro o segnale viene toccato in nessun file.

---

## PARTE 2 — 🔧 IL DISEGNO E COSA E' STATO SCRITTO

### 2.1 La forma della guardia (`ABTG_PausaGuardian.mqh` v1.20)

La logica di decisione e' stata separata in un **nucleo puro**: funzioni
`..._Calc` che **non leggono niente**, prendono i timestamp come argomenti e
rispondono. Le funzioni pubbliche di v1.00 (`PausaGiornoAttiva()`,
`CapRischioAttivo()`, `GuardianVivo()`, `ABTG_PuoAprire()`) **restano identiche
in firma e comportamento** e ora delegano al nucleo.

📌 **Perche' vale la pena:** un nucleo puro **si collauda a tavolino**, senza
terminale, senza conto e senza guardiano acceso. E' l'unico pezzo di questa
migrazione che si puo' verificare **prima** di rischiare un euro.

La riga che va negli EA e' una sola:

```
if(!ABTG_GuardiaIngresso(InpUsaGuardian,"NOME_EA")) return;
```

**Il fail-open e' a TRE livelli, tutti dichiarati:**

| # | condizione | effetto |
|---|---|---|
| 1 | `InpUsaGuardian = false` | passa tutto (comportamento pre-migrazione) |
| 2 | **`ABTG_CanaleEsiste()` = false** | passa tutto: su questo conto il Guardian non e' MAI stato avviato |
| 3 | battito vecchio (>120 s) | il cap **scade da solo**: un Guardian morto non congela la flotta |

🔴 **Il livello 2 e' quello che rende sicuro il default `true`.** Nel **Strategy
Tester** le GlobalVariable del Guardian non esistono: la guardia lascia passare
tutto e **i backtest restano confrontabili con quelli di ieri**. Su un conto
senza Guardian, idem. Il default acceso **non cambia niente da solo**: cambia
qualcosa solo dove il Guardian sta effettivamente girando.

⚠️ **Divergenza dichiarata rispetto alla missione:** la tolleranza sul battito
e' **120 s**, non 60. E' il valore gia' scritto e documentato in v1.00 e non e'
stato cambiato per non toccare una semantica firmata. Il guardiano batte **1
volta al secondo**: con 120 s si tollera un terminale impegnato senza aprire
buchi veri. **Se Claudio preferisce 60, e' un `#define` solo** — ma e' una
decisione sua, non una svista.

### 2.2 Il Guardian (v1.11) — quasi niente, e apposta

Il cap C1 e la pubblicazione delle bandiere **c'erano gia' in v1.10 e non sono
stati toccati**. Aggiunte due cose di **sola lettura**:

1. **`VerificaFilo()`** in `OnInit`. Il guardiano costruisce i nomi delle
   GlobalVariable in un posto, gli EA li costruiscono nell'include: **due posti
   diversi**. Se un giorno divergono — un refuso, una radice cambiata a meta' —
   **il canale muore in silenzio**: il guardiano scrive, nessuno legge, nessun
   errore da nessuna parte, e ce ne accorgeremmo solo da un drawdown. Ora
   all'avvio confronta i 5 nomi e **urla nel giornale** se non coincidono.
2. **`input InpAutotest`** (default **false**): esegue i 19 casi del nucleo.

### 2.3 Dove e' finita la guardia — le regole applicate

| famiglia | EA | punti | scelta del punto |
|---|---:|---:|---|
| SupRev / SuperWave | 13 | 13 | prima della **PRIMA gamba** (1/3 mercato + 2/3 pendente): o l'ingresso parte intero o non parte |
| imbuto singolo | 16 | 17 | subito prima dell'invio |
| straddle e bivi | 11 | 13 | prima del **primo ramo**: mai mezzo straddle, mai un ramo solo |
| Apertura (a fasi) | 8 | 31 | 7 sui tre grossi, 2 sui ridotti |
| **totale** | **48** | **74** | |

**Controlli automatici passati a lavoro finito:**
- ✅ **74/74** punti con il `return` **coerente col tipo della funzione**
  ospitante (`bool` → `return(false);`, `void` → `return;`);
- ✅ le **16 funzioni** che ospitano la guardia sono **tutte imbuti d'ingresso**
  (`Enter`, `TryPlace*`, `TryEnter`, `Monitor*`, `OpenTrade`, `PlaceOrders`,
  `PlaceLimit`, `EnterFibo`, `TryOpen`, `TryCloseConfirmEntry`). **Nessuna
  funzione di uscita, parziale, trailing o gestione e' stata toccata.**
  _(`TryCloseConfirmEntry` sembra una chiusura dal nome ma e' un INGRESSO su
  chiusura confermata: verificato a mano nel codice.)_

### 2.4 🔴 I LIMITI NOTI — da leggere prima di firmare qualsiasi cosa

1. **Non e' un cap istantaneo.** Un **pendente gia' piazzato** quando il cap era
   libero **scattera' lo stesso**, e puo' portare il rischio aperto oltre il
   3,25%. Meta' della flotta lavora con pendenti. Questa e' una guardia
   sull'**AGGIUNTA** di rischio.
2. **Sul retest, il trade e' PERSO, non rimandato.** Negli EA "Apertura" la
   guardia sta dopo la registrazione della rottura: se il cap e' attivo in quel
   momento esatto, quel trade non si recupera. **E' il prezzo giusto**: mettere
   la guardia in cima avrebbe fatto entrare l'EA piu' tardi su un livello
   vecchio, cioe' avrebbe falsificato la strategia.
3. **I preset esistenti non contengono `InpUsaGuardian`.** I `.set` gia' salvati
   non hanno il campo nuovo: MT5 usera' il **default (true)**. Coerente con la
   firma, ma **va saputo**: nessun preset lo spegne, nemmeno per sbaglio.
4. **Le copie in `mql5/Experts/standalone/` NON sono state migrate** (22 file,
   duplicati piu' vecchi). Se qualcuna di quelle gira davvero su un terminale,
   **e' fuori dal canale**. Da verificare nel censimento dei `.chr`.
5. **Niente di tutto questo e' stato compilato.** Vedi la nota di ambiente in
   testa.
6. 🔴 **LA MIGRAZIONE INVESTE R83 E R84, ed e' da coordinare oggi stesso**
   _(trovato dal verificatore il 19/08)_. Fra i 48 migrati ci sono
   **`ABTG_Nasdaq_Apertura_US`** (la cella A di R84, che e' anche il **metro
   del canarino di R83**) e **`ABTG_DAX_Apertura_EU`** (la cella **V** di R83).
   `walkforward_generico.ps1` scarica gli EA da **`lavoro` HEAD**, quindi
   **qualunque corsa di R83/R84 lanciata da adesso gira sugli EA MIGRATI**.
   Conseguenze pratiche, tutte e tre:
   - il **PASSO 1a** di `REFERTO_R83_R84_PREPARAZIONE.md` confronta byte a byte
     gli EA su `lavoro` col pin `2458b33`: **adesso quel confronto FALLISCE**
     (e ha fatto il suo mestiere). Non e' un errore della riga: e' il
     congelamento del branch che e' stato rotto da questa migrazione;
   - la strada pulita e' **in quest'ordine**: prima il **criterio 4** qui
     (FASE 2). Se passa, gli EA migrati sono dimostrati identici nel tester e
     R83/R84 possono ri-pinnare all'hash nuovo **dicendolo nel referto**;
     se non passa, R83/R84 restano fermi comunque, perche' misurerebbero un
     motore cambiato;
   - **R83 ha anche un'asimmetria nuova**: `ABTG_Apertura_3Ingressi` (le celle
     N0-N2, D0-D2) **non e' stato migrato**, mentre la cella **V** (EA vivo del
     DAX) **si'**. Il canarino (b) D1 vs V confronterebbe un EA senza guardia
     con uno con la guardia: regge **solo** se il criterio 4 e' passato.

---

## PARTE 3 — 🧪 IL PIANO DI COLLAUDO (da eseguire, in quest'ordine)

> 🛑 **Regola non negoziabile: il conto piccolo e' l'ULTIMO, mai il primo.**
> Il collaudo si fa sul **dry-run 100k**. Come da firma B1: _"si testa sul
> dry-run 100k PRIMA di qualunque conto che conti"_.

### FASE 0 — Compilazione (la prima cosa che puo' rompersi)

**49 file** da ricompilare: 48 EA + `ABTG_Guardian`. L'include
`ABTG_PausaGuardian.mqh` va copiato in `MQL5\Include\`.

✅ **Criterio di successo: 49 su 49 compilano con 0 ERRORI.**
Sui *warning* si e' tolleranti (i file sono vecchi e ne avevano gia'), ma
**qualunque warning nuovo che nomini `ABTG_` va letto**, non ignorato.

🔍 **Se qualcosa non compila, i sospetti in ordine:**
1. `ABTG_PausaGuardian.mqh` non e' in `MQL5\Include\` → "cannot open include file";
2. un EA che dichiara gia' un simbolo di nome `InpUsaGuardian` (nessuno
   dovrebbe, verificato, ma il compilatore ha l'ultima parola);
3. `return(false);` in una funzione che il mio audit ha letto come `bool` e
   invece non lo e' (l'audit e' statico, il compilatore e' il giudice).

### FASE 1 — Autotest a tavolino (nessun conto, nessun ordine)

> 🔴 **CORREZIONE DEL VERIFICATORE (19/08).** La versione precedente di questa
> fase diceva *"avviarlo su un grafico qualsiasi"* e basta. **Non si fa cosi'**:
> il Guardian con i suoi default e' **armato** — `InpAction=0` (CHIUDI+BLOCCA)
> e `InpCloseAllMagics=true` — e `OnInit` **non si ferma dopo l'autotest**:
> prosegue, arma il timer da 1 s e chiama subito `OnTimer()`. Sul PC di
> backtest il terminale e' collegato al **conto vivo 50503392**, lo stesso su
> cui opera la flotta del VPS: se in quel momento la giornata fosse oltre il
> limite, `FlattenAll()` **chiuderebbe tutte le posizioni del conto**, quelle
> del VPS comprese. Un collaudo che fa danno mentre misura.

**Come si fa davvero** (Guardian **disarmato**, tre campi):

1. trascina `ABTG_Guardian` su un grafico qualsiasi e nella finestra parametri
   metti **`InpAction = 1`** (SOLO ALLARME), **`InpDailyPausePct = 0`**,
   **`InpMaxOpenRiskPct = 0`**, **`InpAutotest = true`**. Cosi' non chiude
   niente e non alza nessuna bandiera: stampa e basta.
2. leggi la scheda **Esperti** (non il Journal: `Print()` di un EA finisce li'
   e in `MQL5\Logs\<data>.log`);
3. **togli il Guardian dal grafico** appena letto l'esito. Le sue
   GlobalVariable restano sul terminale ma sono tutte a **0** = via libera;
4. la verifica automatica e' il **BLOCCO 2** delle righe di lancio (§ Righe):
   conta i casi e cerca i FAIL da solo, senza screenshot.

✅ **Criterio: `[AUTOTEST] ABTG_PausaGuardian: TUTTI I CASI PASSATI.`** — e i
casi sono **19** (contati nel sorgente: 5 pausa + 4 cap + 3 battito + 7
decisione). Se anche **un solo** caso e' `*** FAIL ***`: **ci si ferma qui.**

✅ **Criterio: `[GUARDIAN] filo verificato: 5 GlobalVariable su 5`.**
Se compare `*** FILO ROTTO ***`, il canale non esiste e tutto il resto e'
teatro.

### FASE 2 — Il "non cambia niente" (la prova piu' importante)

**Prima di provare che la guardia morde, va provato che da SPENTA non esiste.**

> 🔴 **CORREZIONE DEL VERIFICATORE (19/08): "stesso EA prima e dopo" non era
> eseguibile.** `walkforward_generico.ps1` (riga 78) **riscarica il `.mq5` da
> `lavoro` HEAD ignorando `-Rif`** — e su HEAD l'EA pre-migrazione **non esiste
> piu'**. Chiedere "rifai lo stesso backtest di prima" avrebbe confrontato la
> versione nuova con se stessa, e il criterio 4 sarebbe passato **sempre**,
> anche con un difetto dentro (punto 24 della checklist).
> Per questo esistono ora, committate apposta e **temporanee**:
> `mql5/Experts/ABTG_Nasdaq_Apertura_US_PREMIGRAZIONE.mq5` e
> `..._DAX_Apertura_EU_PREMIGRAZIONE.mq5`, **copie byte-identiche** della
> versione a `2458b33` (verificato con `diff`). Si cancellano quando il
> criterio 4 e' passato.

**Due coppie, non una**, scelte perche' coprono i due casi che contano:

| coppia | EA | file prova | cosa esercita |
|---|---|---|---|
| 1 | `ABTG_Nasdaq_Apertura_US` | `prove/R84a_base_NASUSD.txt` (`InpEntryMode=0`) | `TryPlaceBreakout` — l'imbuto piu' usato |
| 2 | `ABTG_DAX_Apertura_EU` | `prove/R83v_vivo_D30EUR.txt` (`InpEntryMode=2`=retest) | **`MonitorRetest`** — l'imbuto che MUTA lo stato prima di inviare (trappola 1) |

E si gira a **`-Modello 1` (OHLC M1)**: qui non si misura la strategia, si
misura la **differenza fra due versioni**. Serve solo che il modello sia
**deterministico e identico nei due giri** — e l'OHLC costa minuti invece di
ore. I CSV escono col suffisso `_ohlc`, quindi non possono finire in nessuna
tabella di R83/R84.

✅ **Criterio congelato: il rapporto dev'essere IDENTICO** — stesso numero di
trade, stesso profitto **al centesimo**. Nel tester le GV del Guardian non
esistono, quindi la guardia deve essere trasparente.
🔴 **Se cambia anche un solo trade, la migrazione ha un difetto e non va in
campo.** Non si cerca una spiegazione: si torna indietro.
📌 **Il confronto lo fa la riga**, colonna per colonna (`Profit`,
`Profit Factor`, `Equity DD %`, `Trades`) su tutte e otto le righe: non e'
affidato all'occhio.

### FASE 3 — Dry-run 100k, la pausa che morde (B1)

> 📍 **DOVE, detto una volta per tutte** (era implicito, e non doveva esserlo):
> il dry-run 100k e' il conto **50504263**, e gira sul **VPS**, sull'istanza
> **separata** `BCM Markets MT5 Terminal **-V3**` (`DEPLOY_GUARDIANO_100K.md`).
> L'istanza originale del VPS, quella del conto piccolo **50503392**, **non si
> tocca in nessuna delle fasi 3-5**. Le GlobalVariable sono **per-terminale**:
> il canale del 100k vive dentro il -V3 e li' resta. Sul 100k ci sono **5 EA +
> Guardian + TradeExporter**, non 48: le fasi 3-5 collaudano quei cinque.
> ⚠️ E vale la **B9**: **un solo Guardian per conto**. Prima di attaccarne uno,
> si guarda che non ce ne sia gia' un altro su un altro grafico.

**Scenario, senza aspettare una giornata storta vera:**
1. sul 100k, Guardian acceso, EA con `InpUsaGuardian = true`;
2. abbassare **`InpDailyPausePct`** a un valore che la giornata corrente
   **supera gia'** (es. 0,1 se la giornata e' a -0,2%). ⚠️ **Si tocca la soglia
   del Guardian, NON si perdono soldi apposta.**
3. Attendere il giro di timer (1 s).

✅ **Criteri:**
- il giornale del **Guardian** scrive `* PAUSA NUOVI INGRESSI attiva`;
- al primo tentativo d'ingresso, il giornale dell'**EA** scrive
  `[GUARDIA] <nome>: INGRESSO BLOCCATO -- PAUSA GIORNALIERA del Guardian (firma B1)`;
- 🔴 **le posizioni gia' aperte restano aperte e continuano a essere gestite**
  (parziali, breakeven, trailing funzionano come sempre). **Questa e' la
  verifica che vale piu' di tutte: la guardia non deve toccare le uscite.**
- rialzando la soglia, entro un giro compare `via libera, il blocco e' rientrato`.

### FASE 4 — Dry-run 100k, il cap che rifiuta il sesto SL (C1)

**Lo scopo e' proprio quello di ieri sera: il sesto SL vivo non deve entrare.**

1. sul 100k, portare **`InpMaxOpenRiskPct`** a un valore **appena sotto** il
   rischio aperto in quel momento (leggerlo dal pannello del Guardian, campo
   `rischioAperto`). Non serve avere davvero 5 posizioni: serve che la
   **condizione** sia vera.
2. Provocare/attendere un ingresso.

✅ **Criteri:**
- Guardian: `cap rischio aperto ATTIVO ... >= 3,25%` (o la soglia messa);
- EA: `[GUARDIA] ...: INGRESSO BLOCCATO -- CAP RISCHIO APERTO raggiunto (firma C1)`;
- **nessun ordine nuovo** compare nella scheda Trade;
- rialzando la soglia: `cap rischio aperto rientrato` e l'EA riprende.

**Prova del fail-open (obbligatoria, non facoltativa):** con il **cap** attivo,
**togliere il Guardian dal grafico**. ✅ **Entro ~2 minuti gli EA devono tornare
a operare.** Se restano bloccati per sempre, il fail-open non funziona e **la
migrazione e' pericolosa**: un cane da guardia morto avrebbe spento la flotta.

> ⚠️ **La prova si fa col CAP, MAI con la PAUSA — e non e' un dettaglio.** I due
> meccanismi hanno due fail-open diversi, per disegno: il **cap** e' un
> timestamp ri-timbrato ogni secondo e scade da solo entro la tolleranza (120 s,
> `ABTG_CapAttivo_Calc`); la **pausa** ha una **scadenza dichiarata** (il
> prossimo reset del giorno prop) e, se quella manca, un ripiego di **24 ore**
> (`ABTG_PausaAttiva_Calc`). Una pausa **deve** sopravvivere alla morte del
> guardiano: e' il suo mestiere. Chi facesse la prova con la pausa attiva
> vedrebbe la flotta ferma per ore e concluderebbe che il fail-open e' rotto,
> **bocciando una cosa che funziona**.
> 📐 E i 2 minuti sono `ABTG_BATTITO_TOLLERANZA = 120` s: se un giorno il
> `#define` scende a 60, questa attesa scende con lui.

### FASE 5 — Osservazione, poi e solo poi il conto piccolo

- **Almeno 3 giorni** di dry-run 100k con la flotta migrata e i valori **veri**
  (pausa 4,0 · cap 3,25) prima di proporre il conto piccolo.
- ✅ **Criterio: zero blocchi non spiegati.** Ogni `INGRESSO BLOCCATO` nel
  giornale dev'essere riconducibile a un evento visibile nel pannello del
  Guardian. Un blocco che non si sa spiegare **e' un difetto**, non un caso.
- 🛑 **La messa in campo sul conto piccolo la decide Claudio.** Qui non si
  sostituisce nessun EA in campo.

### 📋 Criteri di successo — CONGELATI PRIMA DELLA PROVA

| # | criterio | esito |
|---|---|---|
| 1 | 49/49 file compilano, 0 errori | ☐ |
| 2 | autotest: 19/19 casi PASS | ☐ |
| 3 | filo verificato: 5/5 nomi coincidono | ☐ |
| 4 | **backtest identico al centesimo** prima/dopo | ☐ |
| 5 | pausa B1: il giornale dell'EA la nomina e l'ordine non parte | ☐ |
| 6 | **posizioni aperte gestite normalmente durante la pausa** | ☐ |
| 7 | cap C1: l'ingresso in eccesso viene rifiutato | ☐ |
| 8 | **fail-open: Guardian rimosso → la flotta riparte entro ~2 min** | ☐ |
| 9 | 3 giorni di dry-run senza blocchi inspiegati | ☐ |

🔴 **Sono tutti e nove obbligatori. Uno solo che fallisce ferma la migrazione.**
Il 4 e l'8 sono quelli che proteggono dal danno peggiore: rispettivamente
"aver cambiato la strategia senza accorgersene" e "aver costruito un
interruttore che spegne la flotta da solo".

### 🚀 Righe di lancio — verificate il 19/08

> 🔴 **LA BOZZA E' BOCCIATA.** Sei difetti, e tre erano fatali:
> **(1)** `$ME` e `$DATA` scritti a mano con `<ID_TERMINALE>` — il percorso si
> **misura** da `origin.txt`, non si indovina, ed era gia' fatto cosi' in
> quattro script di casa; **(2)** `/log:"$env:TEMP\comp.log"` **fisso dentro il
> ciclo**: 49 compilazioni riscrivono lo stesso file, quindi il cancello
> _"0 errori su TUTTI"_ leggeva **l'ultimo file e basta** (punto 14: il codice
> d'uscita deve dipendere dai sotto-lavori, e gli artefatti si contano);
> **(3)** `Get-ChildItem "$DATA\Experts\ABTG_*.mq5"` compila **quello che c'e'
> sulla macchina**, non i 49 migrati — se un EA non fosse mai stato installato
> li', il cancello direbbe verde su 47; e prende `ABTG_*`, cioe' **salta
> `BREAKOUT_EA_JPY*` e `Gold_Ichimoku_TK_ATR_EA`**, che sono migrati;
> **(4)** nessun `irm` pinnato: compilava i sorgenti **locali**, che possono
> essere di ieri (punti 6, 8, 24); **(5)** nessuna guardia **MT5 chiuso**
> (punto 7) mentre si riscrive `MQL5\Include` e `MQL5\Experts`;
> **(6)** nessuna raccolta sul Desktop, nessuno zip (regola di casa).
> Sotto ci sono le righe **corrette**: **quattro blocchi**, uno per volta,
> graffe comprese.

**Il pin e' `d0241ff60d003f257a77930b4d686c0d87901cbc`** — contiene la
migrazione, il manifesto dei 49 e le due copie `_PREMIGRAZIONE`. Il manifesto
`backtest_pipeline/migrazione_guardian_v120.txt` **non e' scritto a mano**: e'
generato da `git diff --name-only` sui file toccati, e il blocco si ferma se
non ha esattamente 49 righe.

🖥️ **BLOCCHI 1-3 sul PC DI BACKTEST** (MT5 chiuso). **BLOCCO 4 sul VPS**,
istanza `-V3` del 100k. Fra un blocco e l'altro **ci si ferma e si legge**.

#### BLOCCO 1 — FASE 0: include + 49 compilazioni (MT5 CHIUSO, ~5 min)
```powershell
& {
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
  if(Get-Process -Name terminal64 -EA SilentlyContinue){ throw "MT5 E' APERTO: chiudilo. Questo blocco riscrive MQL5\Include e MQL5\Experts." }
  $h="d0241ff60d003f257a77930b4d686c0d87901cbc"
  $b="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$h"
  $tutti=@(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter terminal64.exe -EA SilentlyContinue)
  $t=@($tutti | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" })
  if($t.Count -eq 0){ $t=@($tutti | Where-Object { $_.DirectoryName -like "*BCM Markets*" -and $_.DirectoryName -notlike "*-V3*" }) }
  if($t.Count -eq 0){ throw "terminale BCM non trovato (l'istanza -V3 e' quella del 100k e NON si tocca da qui)" }
  $inst=$t[0].DirectoryName
  $df=@(Get-ChildItem (Join-Path $env:APPDATA "MetaQuotes\Terminal") -Directory -EA SilentlyContinue | Where-Object { $o=Join-Path $_.FullName "origin.txt"; (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $inst) })
  if($df.Count -eq 0){ throw "cartella dati MT5 non trovata (origin.txt)" }
  $data=$df[0].FullName
  Write-Host ("    terminale: " + $inst) -ForegroundColor Gray
  $inc=Join-Path $data "MQL5\Include\ABTG_PausaGuardian.mqh"
  New-Item -ItemType Directory -Force -Path (Split-Path $inc) | Out-Null
  Remove-Item $inc -Force -EA SilentlyContinue
  irm "$b/mql5/Include/ABTG_PausaGuardian.mqh" -OutFile $inc -EA Stop
  if(-not (Select-String -Path $inc -SimpleMatch -Pattern 'ABTG_PausaGuardian v1.20' -Quiet)){ throw "include VECCHIO o tronco: manca il marcatore v1.20" }
  $man=Join-Path $env:TEMP "migrazione_guardian_v120.txt"
  Remove-Item $man -Force -EA SilentlyContinue
  irm "$b/backtest_pipeline/migrazione_guardian_v120.txt" -OutFile $man -EA Stop
  $lista=@(Get-Content $man | Where-Object { $_ -notmatch '^#' -and $_.Trim() -ne "" })
  if($lista.Count -ne 49){ throw ("il manifesto ha " + $lista.Count + " righe invece di 49: scaricato male") }
  $exp=Join-Path $data "MQL5\Experts"
  New-Item -ItemType Directory -Force -Path $exp | Out-Null
  $dsk=[Environment]::GetFolderPath('Desktop'); $rac=Join-Path $dsk 'MIGRAZIONE_GUARDIAN'
  Remove-Item $rac -Recurse -Force -EA SilentlyContinue
  New-Item -ItemType Directory -Force -Path $rac | Out-Null
  $me=Join-Path $inst "metaeditor64.exe"
  $t0=(Get-Date).AddSeconds(-5)
  $falliti=@(); $note=@()
  foreach($f in $lista){
    $mq=Join-Path $exp $f
    $ex5=[IO.Path]::ChangeExtension($mq,'.ex5'); $log=[IO.Path]::ChangeExtension($mq,'.log')
    Remove-Item $log -Force -EA SilentlyContinue
    try { irm "$b/mql5/Experts/$f" -OutFile $mq -EA Stop } catch { $falliti+=("SCARICO  " + $f); continue }
    & $me "/compile:$mq" "/log" | Out-Null
    if(Test-Path $log){
      Copy-Item $log (Join-Path $rac ([IO.Path]::GetFileNameWithoutExtension($f) + ".log")) -Force
      $fs=New-Object System.IO.FileStream($log,[System.IO.FileMode]::Open,[System.IO.FileAccess]::Read,[System.IO.FileShare]::ReadWrite)
      $sr=New-Object System.IO.StreamReader($fs,[System.Text.Encoding]::Unicode,$true)
      $tx=$sr.ReadToEnd(); $sr.Close(); $fs.Close()
      foreach($r in ($tx -split "`r?`n")){ if($r -match 'ABTG_' -and $r -match '(?i)(error|warning)'){ $note+=($f + " | " + $r.Trim()) } }
    }
    if((Test-Path $ex5) -and ((Get-Item $ex5).LastWriteTime -ge $t0)){ Write-Host ("    ok  " + $f) -ForegroundColor Green }
    else { Write-Host ("    NO  " + $f) -ForegroundColor Red; $falliti+=("COMPILA  " + $f) }
  }
  if($note.Count -gt 0){
    Write-Host ""
    Write-Host "  RIGHE DEL COMPILATORE CHE NOMINANO ABTG_ (vanno LETTE, non ignorate):" -ForegroundColor Yellow
    $note | ForEach-Object { Write-Host ("      " + $_) -ForegroundColor Yellow }
  }
  $note | Set-Content (Join-Path $rac 'righe_ABTG_del_compilatore.txt') -Encoding ASCII
  @(("data: " + (Get-Date -Format 'yyyy-MM-dd HH:mm')), ("pin : " + $h), ("compilati: " + ($lista.Count - $falliti.Count) + " su " + $lista.Count), ("falliti: " + ($falliti -join " ; "))) | Set-Content (Join-Path $rac 'REFERTO_FASE0.txt') -Encoding ASCII
  Compress-Archive -Path (Join-Path $rac '*') -DestinationPath (Join-Path $dsk 'MIGRAZIONE_GUARDIAN.zip') -Force
  if($falliti.Count -gt 0){ throw ("FASE 0 FALLITA su " + $falliti.Count + " file: " + ($falliti -join " ; ") + " -- i log sono in Desktop\MIGRAZIONE_GUARDIAN") }
  Write-Host ""
  Write-Host "FASE 0 OK: 49 su 49 compilati adesso. Zip: Desktop\MIGRAZIONE_GUARDIAN.zip" -ForegroundColor Green
  Write-Host "Adesso il BLOCCO 2 (autotest: prima il gesto a mano in MT5, poi il blocco)." -ForegroundColor Cyan
}
```
🛑 **Stop.** Il cancello e' **49 `.ex5` scritti ADESSO** (timestamp), non "il
file c'e'": un `.ex5` di ieri non e' una compilazione riuscita.

#### BLOCCO 2 — FASE 1: verifica dell'autotest, letta dal log (dopo il gesto a mano)
Prima il gesto (vedi **FASE 1**: Guardian **disarmato** — `InpAction=1`,
`InpDailyPausePct=0`, `InpMaxOpenRiskPct=0`, `InpAutotest=true` — e poi tolto
dal grafico). Poi, con MT5 anche aperto:
```powershell
& {
  $tutti=@(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter terminal64.exe -EA SilentlyContinue)
  $t=@($tutti | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" })
  if($t.Count -eq 0){ $t=@($tutti | Where-Object { $_.DirectoryName -like "*BCM Markets*" -and $_.DirectoryName -notlike "*-V3*" }) }
  if($t.Count -eq 0){ throw "terminale BCM non trovato" }
  $df=@(Get-ChildItem (Join-Path $env:APPDATA "MetaQuotes\Terminal") -Directory -EA SilentlyContinue | Where-Object { $o=Join-Path $_.FullName "origin.txt"; (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $t[0].DirectoryName) })
  if($df.Count -eq 0){ throw "cartella dati MT5 non trovata" }
  $dsk=[Environment]::GetFolderPath('Desktop'); $rac=Join-Path $dsk 'MIGRAZIONE_GUARDIAN'
  if(-not (Test-Path $rac)){ throw "manca Desktop\MIGRAZIONE_GUARDIAN: il BLOCCO 1 non e' stato fatto" }
  $lg=@(Get-ChildItem (Join-Path $df[0].FullName "MQL5\Logs") -Filter "*.log" -EA SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1)
  if($lg.Count -eq 0){ throw "nessun log in MQL5\Logs: il Guardian non e' mai partito" }
  $fs=New-Object System.IO.FileStream($lg[0].FullName,[System.IO.FileMode]::Open,[System.IO.FileAccess]::Read,[System.IO.FileShare]::ReadWrite)
  $sr=New-Object System.IO.StreamReader($fs,[System.Text.Encoding]::Unicode,$true)
  $testo=$sr.ReadToEnd(); $sr.Close(); $fs.Close()
  Copy-Item $lg[0].FullName (Join-Path $rac ("esperti_" + $lg[0].Name)) -Force
  $i=$testo.LastIndexOf("[AUTOTEST] ABTG_PausaGuardian v1.20")
  if($i -lt 0){ throw "nel log non c'e' nessun autotest v1.20: InpAutotest era false? Rifai il gesto della FASE 1." }
  $coda=$testo.Substring($i)
  ($coda -split "`r?`n") | Where-Object { $_ -match 'AUTOTEST|FILO|filo verificato' } | ForEach-Object { Write-Host $_ }
  if($coda -match '\*\*\* FAIL \*\*\*'){ throw "AUTOTEST FALLITO: la migrazione NON va in campo. Il log e' sul Desktop." }
  # NB: si contano le righe dei CASI (hanno 'atteso='), non tutte quelle con 'PASS':
  # la riga finale 'TUTTI I CASI PASSATI' contiene PASS e falserebbe il conto (provato).
  $pass=@($coda -split "`r?`n" | Where-Object { $_ -match 'atteso=' -and $_ -match 'PASS' }).Count
  if($pass -ne 19){ throw ("casi passati: " + $pass + " invece di 19. Log troncato o autotest a meta': rifai il gesto.") }
  if($coda -notmatch 'TUTTI I CASI PASSATI'){ throw "manca la riga 'TUTTI I CASI PASSATI'" }
  $filo=$testo.LastIndexOf("[GUARDIAN] filo verificato")
  if($testo -match 'FILO ROTTO'){ throw "*** FILO ROTTO ***: guardiano e include usano nomi diversi. Tutto il resto e' teatro." }
  if($filo -lt 0){ throw "manca la riga '[GUARDIAN] filo verificato: 5 GlobalVariable su 5'" }
  Compress-Archive -Path (Join-Path $rac '*') -DestinationPath (Join-Path $dsk 'MIGRAZIONE_GUARDIAN.zip') -Force
  Write-Host "FASE 1 OK: 19 casi su 19, filo 5 su 5. Criteri 2 e 3 passati." -ForegroundColor Green
}
```

#### BLOCCO 3 — FASE 2: il canarino del criterio 4 (MT5 CHIUSO, ~10-20 min)
```powershell
& {
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
  if(Get-Process -Name terminal64 -EA SilentlyContinue){ throw "MT5 E' APERTO: chiudilo, altrimenti il tester non parte e escono 0 CSV." }
  $h="d0241ff60d003f257a77930b4d686c0d87901cbc"
  $b="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$h/backtest_pipeline"
  $w=Join-Path $env:USERPROFILE "mig4"
  New-Item -ItemType Directory -Force -Path (Join-Path $w "prove") | Out-Null
  $wf=Join-Path $w "walkforward_generico.ps1"
  Remove-Item $wf -Force -EA SilentlyContinue
  irm "$b/walkforward_generico.ps1" -OutFile $wf -EA Stop
  if(-not (Select-String -Path $wf -SimpleMatch -Pattern 'WALK-FORWARD GENERICO' -Quiet)){ throw "driver VECCHIO o tronco" }
  foreach($p in @('R84a_base_NASUSD.txt','R83v_vivo_D30EUR.txt')){
    $d=Join-Path $w ("prove\" + $p)
    Remove-Item $d -Force -EA SilentlyContinue
    irm "$b/prove/$p" -OutFile $d -EA Stop
  }
  $coppie=@(
    @{ Post="ABTG_Nasdaq_Apertura_US"; Pre="ABTG_Nasdaq_Apertura_US_PREMIGRAZIONE"; Prova="prove\R84a_base_NASUSD.txt"; Sym="NASUSD" },
    @{ Post="ABTG_DAX_Apertura_EU";    Pre="ABTG_DAX_Apertura_EU_PREMIGRAZIONE";    Prova="prove\R83v_vivo_D30EUR.txt"; Sym="D30EUR" }
  )
  foreach($c in $coppie){
    foreach($ea in @($c.Pre,$c.Post)){
      Write-Host ""
      Write-Host ("=== " + $ea + " ===") -ForegroundColor Cyan
      $global:LASTEXITCODE=0
      & powershell -ExecutionPolicy Bypass -File $wf $ea -Prova $c.Prova -Modello 1 -Etichetta mig4 -Rifai
      if($LASTEXITCODE -ne 0){ throw ("canarino: la corsa di " + $ea + " e' fallita (codice " + $LASTEXITCODE + ")") }
    }
  }
  $tab=@()
  foreach($c in $coppie){
    foreach($fin in @("IS","OOS")){
      $fPre =Join-Path $w ("risultati_prove\" + $c.Pre  + "\" + $c.Pre  + "_" + $c.Sym + "_" + $fin + "_ohlc_mig4.csv")
      $fPost=Join-Path $w ("risultati_prove\" + $c.Post + "\" + $c.Post + "_" + $c.Sym + "_" + $fin + "_ohlc_mig4.csv")
      if(-not (Test-Path -LiteralPath $fPre)){  throw ("manca il CSV PRE: "  + $fPre) }
      if(-not (Test-Path -LiteralPath $fPost)){ throw ("manca il CSV POST: " + $fPost) }
      $a=@(Import-Csv -LiteralPath $fPre  | Sort-Object InpMagic)
      $z=@(Import-Csv -LiteralPath $fPost | Sort-Object InpMagic)
      if($a.Count -eq 0){ throw ("il CSV PRE di " + $c.Sym + " " + $fin + " ha ZERO passate") }
      if($a.Count -ne $z.Count){ throw ("righe diverse fra PRE e POST su " + $c.Sym + " " + $fin + ": " + $a.Count + " vs " + $z.Count) }
      for($i=0;$i -lt $a.Count;$i++){
        foreach($col in @("Profit","Profit Factor","Equity DD %","Trades")){
          if($a[$i].$col -ne $z[$i].$col){ throw ("*** CRITERIO 4 FALLITO *** " + $c.Sym + " " + $fin + " riga " + ($i+1) + " colonna '" + $col + "': PRE=" + $a[$i].$col + " POST=" + $z[$i].$col + " -- la migrazione NON va in campo.") }
        }
        $tab += New-Object PSObject -Property @{ EA=$c.Post; Finestra=$fin; Magic=$a[$i].InpMagic; Profit=$a[$i].Profit; PF=$a[$i].'Profit Factor'; DD=$a[$i].'Equity DD %'; Trades=$a[$i].Trades; Esito="IDENTICO" }
      }
    }
  }
  $tab | Format-Table EA,Finestra,Magic,Profit,PF,DD,Trades,Esito -AutoSize
  $dsk=[Environment]::GetFolderPath('Desktop'); $rac=Join-Path $dsk 'MIGRAZIONE_GUARDIAN'
  New-Item -ItemType Directory -Force -Path $rac | Out-Null
  Get-ChildItem (Join-Path $w "risultati_prove") -Recurse -Filter "*_mig4.csv" -EA SilentlyContinue | ForEach-Object { Copy-Item $_.FullName $rac -Force }
  @(("data: " + (Get-Date -Format 'yyyy-MM-dd HH:mm')), ("pin : " + $h), ("confronti identici: " + $tab.Count + " (attesi 8)")) | Set-Content (Join-Path $rac 'REFERTO_CRITERIO4.txt') -Encoding ASCII
  Compress-Archive -Path (Join-Path $rac '*') -DestinationPath (Join-Path $dsk 'MIGRAZIONE_GUARDIAN.zip') -Force
  if($tab.Count -ne 8){ throw ("confronti fatti: " + $tab.Count + " invece di 8") }
  Write-Host ""
  Write-Host "CRITERIO 4 PASSATO: 8 confronti su 8 identici (Profit, PF, DD, trades)." -ForegroundColor Green
  Write-Host "Zip aggiornato: Desktop\MIGRAZIONE_GUARDIAN.zip" -ForegroundColor Cyan
}
```
🛑 **Stop.** Se questo blocco urla, **non si va sul 100k**: si torna indietro,
come dice il criterio 4.

#### BLOCCO 4 — SUL VPS, istanza -V3: installare i migrati sul 100k
> ⚠️ **Solo quando i BLOCCHI 1-3 sono verdi.** Da fare **fuori dagli orari di
> sessione** (mai fra le 08:00 e le 22:00 server): il terminale del 100k va
> **chiuso da File > Esci** e riaperto, e alla riapertura gli EA ripartono da
> `OnInit` (uno stato di fase in corso si perde). **L'istanza del conto piccolo
> 50503392 non si tocca**: il blocco si rifiuta di partire se non riconosce la
> `-V3`, e non chiude nessun processo da solo.
```powershell
& {
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
  $h="d0241ff60d003f257a77930b4d686c0d87901cbc"
  $b="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$h"
  $tutti=@(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter terminal64.exe -EA SilentlyContinue)
  $t=@($tutti | Where-Object { $_.DirectoryName -like "*BCM Markets*" -and $_.DirectoryName -like "*-V3*" })
  if($t.Count -eq 0){ throw "istanza -V3 (100k) non trovata su questa macchina: sei sul PC sbagliato" }
  $inst=$t[0].DirectoryName
  if(@(Get-Process -Name terminal64 -EA SilentlyContinue | Where-Object { $_.Path -like "*-V3*" }).Count -gt 0){ throw "il terminale -V3 (100k) e' APERTO: chiudilo da File > Esci (chiusura pulita). L'altra istanza resta accesa." }
  $df=@(Get-ChildItem (Join-Path $env:APPDATA "MetaQuotes\Terminal") -Directory -EA SilentlyContinue | Where-Object { $o=Join-Path $_.FullName "origin.txt"; (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $inst) })
  if($df.Count -eq 0){ throw "cartella dati della -V3 non trovata (origin.txt)" }
  $data=$df[0].FullName
  $inc=Join-Path $data "MQL5\Include\ABTG_PausaGuardian.mqh"
  New-Item -ItemType Directory -Force -Path (Split-Path $inc) | Out-Null
  Remove-Item $inc -Force -EA SilentlyContinue
  irm "$b/mql5/Include/ABTG_PausaGuardian.mqh" -OutFile $inc -EA Stop
  if(-not (Select-String -Path $inc -SimpleMatch -Pattern 'ABTG_PausaGuardian v1.20' -Quiet)){ throw "include VECCHIO o tronco" }
  $man=Join-Path $env:TEMP "migrazione_guardian_v120.txt"
  Remove-Item $man -Force -EA SilentlyContinue
  irm "$b/backtest_pipeline/migrazione_guardian_v120.txt" -OutFile $man -EA Stop
  $lista=@(Get-Content $man | Where-Object { $_ -notmatch '^#' -and $_.Trim() -ne "" })
  if($lista.Count -ne 49){ throw "manifesto scaricato male" }
  $exp=Join-Path $data "MQL5\Experts"
  # SOLO gli EA che su QUESTA macchina ci sono gia': non si installa niente di nuovo sul 100k
  $qui=@($lista | Where-Object { Test-Path -LiteralPath (Join-Path $exp $_) })
  if($qui.Count -eq 0){ throw "nella -V3 non c'e' nessuno dei 49: cartella sbagliata" }
  Write-Host ("    da aggiornare sulla -V3: " + $qui.Count + " file") -ForegroundColor Cyan
  $qui | ForEach-Object { Write-Host ("      " + $_) -ForegroundColor Gray }
  $me=Join-Path $inst "metaeditor64.exe"
  $t0=(Get-Date).AddSeconds(-5); $falliti=@()
  $dsk=[Environment]::GetFolderPath('Desktop'); $rac=Join-Path $dsk 'MIGRAZIONE_100K'
  Remove-Item $rac -Recurse -Force -EA SilentlyContinue
  New-Item -ItemType Directory -Force -Path $rac | Out-Null
  foreach($f in $qui){
    $mq=Join-Path $exp $f
    $ex5=[IO.Path]::ChangeExtension($mq,'.ex5'); $log=[IO.Path]::ChangeExtension($mq,'.log')
    $bak=$mq + ".prima_migrazione"
    if(-not (Test-Path -LiteralPath $bak)){ Copy-Item -LiteralPath $mq $bak -Force }   # backup UNA volta sola (punto 12)
    Remove-Item $log -Force -EA SilentlyContinue
    try { irm "$b/mql5/Experts/$f" -OutFile $mq -EA Stop } catch { $falliti+=("SCARICO  " + $f); continue }
    & $me "/compile:$mq" "/log" | Out-Null
    if(Test-Path $log){ Copy-Item $log (Join-Path $rac ([IO.Path]::GetFileNameWithoutExtension($f) + ".log")) -Force }
    if((Test-Path $ex5) -and ((Get-Item $ex5).LastWriteTime -ge $t0)){ Write-Host ("    ok  " + $f) -ForegroundColor Green }
    else { Write-Host ("    NO  " + $f) -ForegroundColor Red; $falliti+=("COMPILA  " + $f) }
  }
  @(("data: " + (Get-Date -Format 'yyyy-MM-dd HH:mm')), ("pin : " + $h), ("aggiornati: " + ($qui.Count - $falliti.Count) + " su " + $qui.Count), ("falliti: " + ($falliti -join " ; ")), "backup: <nome>.mq5.prima_migrazione accanto a ogni file") | Set-Content (Join-Path $rac 'REFERTO_100K.txt') -Encoding ASCII
  Compress-Archive -Path (Join-Path $rac '*') -DestinationPath (Join-Path $dsk 'MIGRAZIONE_100K.zip') -Force
  if($falliti.Count -gt 0){ throw ("100k: " + $falliti.Count + " file non aggiornati: " + ($falliti -join " ; ")) }
  Write-Host ""
  Write-Host "100k aggiornato. RIAPRI il terminale -V3 e controlla, in quest'ordine:" -ForegroundColor Cyan
  Write-Host "  1) Algo Trading VERDE;  2) il pannello del Guardian (limite 4.9 / totale 9.9 / pausa 4.0 / cap 3.25);" -ForegroundColor Cyan
  Write-Host "  3) nel giornale: '[GUARDIAN] filo verificato: 5 GlobalVariable su 5';" -ForegroundColor Cyan
  Write-Host "  4) UN SOLO Guardian sul conto (regola B9). Poi le FASI 3-4." -ForegroundColor Cyan
}
```

**Cosa NON fanno queste righe, dichiarato:** non toccano l'istanza del **conto
piccolo 50503392** (la messa in campo li' e' la FASE 5 e la decide Claudio),
non spengono e non riavviano niente da sole, non cambiano nessun `.set` e non
scrivono nessuna soglia: le prove delle FASI 3-4 si fanno **a mano**, cambiando
i parametri del Guardian dalla sua finestra, come scritto sopra.

---

_Parte 1 chiusa il 19/08/2026 prima di toccare il codice. Parti 2 e 3 chiuse a
codice scritto e pushato. **Nessun numero di performance in questo referto:
non c'era niente da misurare, solo da collegare.**_

---

## ESITI DEL COLLAUDO — 19/08/2026 pomeriggio (PC di backtest)

| fase | esito | misura |
|---|---|---|
| FASE 0 (49 compilazioni, pin d0241ff) | VERDE 15:43 | 49/49 compilati ADESSO; 2 warning 63 su PTE/PTE_Ottimizzato = PRE-esistenti alla migrazione (stessa riga `double w[2]; ArraySetAsSeries` al pin 2458b33) |
| FASE 1 (autotest DISARMATO) | VERDE 15:49-15:52 | 19 casi su 19 PASS, filo 5/5 (conto 50503392); primo intercetto del verificatore in campo: Claudio ha mandato lo screenshot col Guardian ARMATO (Action=0, pausa 4.0, cap 3.25) e i 4 campi sono stati corretti PRIMA dell'OK. Bonus di osservazione dal log: `rischioAperto=4.35%` in monitor = il cap firmato 3,25% oggi non e' rispettato, come previsto dalla decisione n.1 |
| FASE 2 / CRITERIO 4 | VERDE 15:56 | 8 confronti su 8 IDENTICI; ricontrollato in sessione con diff byte-a-byte sui CSV: TUTTE le metriche uguali (Profit/PF/DD/Trades/Sharpe/Recovery/peggior giornata), unica differenza la colonna nuova InpUsaGuardian. Le copie _PREMIGRAZIONE sono state cancellate dal repo come previsto |

Artefatti: `guardian_REFERTO_FASE0_2026-08-19.txt` · `guardian_REFERTO_CRITERIO4_2026-08-19.txt` · zip completo sul Desktop del PC (MIGRAZIONE_GUARDIAN.zip).

**CONSEGUENZE:** il criterio 4 e' passato -> la regola del traffico si scioglie:
R83/R84/R84-bis/R86 possono rilanciare (le stringhe vanno RI-PINNATE a un
commit >= questo, gli EA a HEAD sono i migrati e sono dimostrati identici).
Restano da fare: BLOCCO 4 (VPS -V3, FUORI orario di sessione: mai fra le
08:00 e le 22:00 server), poi FASI 3-5 (pausa che morde, cap che rifiuta,
osservazione — MAI col conto piccolo prima della FASE 5).

### 📸 FOTO "PRIMA" DEL BLOCCO 4 — pannello Guardian sul 100k, 19/08 ore 23:06 IT

Letto dallo screenshot del terminale -V3 (istanza 100k, conto 50504263),
Guardian su AUDNZD H1, PRIMA della migrazione:

```
Stato: OK - operativo          Saldo iniziale: 100000.00
Equity: 99380.25   Balance: 99380.25
GIORNO   inizio 99497.62   perdita oggi 117.37 (0.12% / limite 4.9%)
TOTALE   picco equity 100323.58   drawdown 619.75 (0.62% / limite 9.9%)
Azione: CHIUDI+BLOCCA
NUOVI INGRESSI  pausa morbida (4.0%): libera
                rischio aperto 0.00% / cap 3.25% -> ok
```

Tre conferme che valgono per il collaudo:
1. **Le soglie firmate sono in campo**: 4.9 / 9.9 / pausa 4.0 / cap 3.25.
2. **UN SOLO Guardian sul conto** (regola B9): nel Navigatore del 100k gli EA
   attaccati sono 7 — DAX_Apertura_EU M5, Dow_Apertura_US M5,
   MaxMinNotte_DAX_Short_Ott, SupertrendReversal 225JPY H2, ORB_Ottimizzato
   U30USD M5, TradeExporter EURUSD H1, Guardian AUDNZD H1.
3. **Rischio aperto 0,00%**: a quest'ora il 100k non ha NESSUNA posizione
   aperta -> il riavvio del BLOCCO 4 non perde nessuno stato di posizione.
   E' la condizione migliore possibile per farlo.

Confermato anche che **ABTG_Look e ABTG_LivelliChiave sono installati e
compilati sull'istanza -V3** (visibili nel Navigatore, indicatori disegnati
sul grafico AUDNZD: EMA 9/21/50/200, Bollinger, MAX IERI / OPEN OGGI / MIN IERI).

### ✅ BLOCCO 4 ESEGUITO — 19/08/2026 ore 23:10 (VPS, istanza -V3, conto 100k)

**Esito: 6 su 6 aggiornati, 0 falliti.** Log di compilazione letti uno per uno
in sessione: **"Result: 0 errors, 0 warnings"** su tutti e sei.

| EA aggiornato sul 100k | compilazione |
|---|---|
| ABTG_DAX_Apertura_EU | 0 errori, 0 warning |
| ABTG_Dow_Apertura_US | 0 errori, 0 warning |
| ABTG_MaxMinNotte_DAX_Short_Ottimizzato | 0 errori, 0 warning |
| ABTG_ORB_Ottimizzato | 0 errori, 0 warning |
| ABTG_SupertrendReversal | 0 errori, 0 warning |
| ABTG_Guardian | 0 errori, 0 warning |

Sono **esattamente** gli EA che sul 100k c'erano gia' (il blocco per disegno
non installa nulla di nuovo). Backup `.mq5.prima_migrazione` creato accanto a
ogni file. Referto agli atti: `guardian_REFERTO_BLOCCO4_100K_2026-08-19.txt`.

**Stato del collaudo: FASI 0, 1, 2 e BLOCCO 4 tutti VERDI.** Il 100k gira ora
su EA migrati compilati oggi, dimostrati identici al centesimo alla versione
pre-migrazione (criterio 4).

Restano le prove di campo, da fare con calma e MAI insieme:
- **FASE 3** (la pausa che morde, B1) e **FASE 4** (il cap che rifiuta, C1):
  si fanno a mano dalla finestra del Guardian, una alla volta.
- **FASE 5**: il conto piccolo. La decide Claudio, dopo l'osservazione.
