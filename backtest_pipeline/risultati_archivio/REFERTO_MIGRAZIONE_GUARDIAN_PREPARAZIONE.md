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

Sul Guardian, mettere **`InpAutotest = true`**, avviarlo su un grafico
qualsiasi, leggere la scheda **Esperti**, poi **rimetterlo a false**.

✅ **Criterio: `[AUTOTEST] ABTG_PausaGuardian: TUTTI I CASI PASSATI.`**
Se anche **un solo** caso e' `*** FAIL ***`: **ci si ferma qui.**

✅ **Criterio: `[GUARDIAN] filo verificato: 5 GlobalVariable su 5`.**
Se compare `*** FILO ROTTO ***`, il canale non esiste e tutto il resto e'
teatro.

### FASE 2 — Il "non cambia niente" (la prova piu' importante)

**Prima di provare che la guardia morde, va provato che da SPENTA non esiste.**

Su un EA qualsiasi, nel **Strategy Tester**, un periodo breve gia' girato in
passato: **stesso EA, stessi input, stesso periodo, prima e dopo la migrazione.**

✅ **Criterio congelato: il rapporto dev'essere IDENTICO** — stesso numero di
trade, stesso profitto **al centesimo**. Nel tester le GV del Guardian non
esistono, quindi la guardia deve essere trasparente.
🔴 **Se cambia anche un solo trade, la migrazione ha un difetto e non va in
campo.** Non si cerca una spiegazione: si torna indietro.

### FASE 3 — Dry-run 100k, la pausa che morde (B1)

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

**Prova del fail-open (obbligatoria, non facoltativa):** con il cap **attivo**,
**togliere il Guardian dal grafico**. ✅ **Entro ~2 minuti gli EA devono tornare
a operare.** Se restano bloccati per sempre, il fail-open non funziona e **la
migrazione e' pericolosa**: un cane da guardia morto avrebbe spento la flotta.

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

### 🚀 Righe di lancio — ⚠️ BOZZA DA VERIFICARE, NON DETTARE COSI'

> 🛑 **Queste righe NON sono state provate** (qui non c'e' Windows, non c'e'
> MT5, non c'e' MetaEditor). Mancano i percorsi veri del terminale, che vanno
> letti sulla macchina. Come da regola di casa la riga definitiva vuole
> **l'`irm` in testa** e **la riga di raccolta in coda**: le metto quando i
> percorsi sono confermati. **ASCII puro, nessuna emoji dentro il `.ps1`.**

```powershell
# BOZZA -- compilazione di massa. VERIFICARE $ME e $DATA prima dell'uso.
$ME   = "C:\Program Files\MetaTrader 5\metaeditor64.exe"   # DA VERIFICARE
$DATA = "$env:APPDATA\MetaQuotes\Terminal\<ID_TERMINALE>\MQL5"  # DA VERIFICARE
Copy-Item "$HOME\GITHUB\mql5\Include\ABTG_PausaGuardian.mqh" "$DATA\Include\" -Force
Get-ChildItem "$DATA\Experts\ABTG_*.mq5" | ForEach-Object {
  & $ME /compile:"$($_.FullName)" /log:"$env:TEMP\comp.log" | Out-Null
}
Select-String -Path "$env:TEMP\comp.log" -Pattern "error" -SimpleMatch
```

---

_Parte 1 chiusa il 19/08/2026 prima di toccare il codice. Parti 2 e 3 chiuse a
codice scritto e pushato. **Nessun numero di performance in questo referto:
non c'era niente da misurare, solo da collegare.**_
