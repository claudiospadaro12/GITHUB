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
- **Punti di innesto totali: ~100** (1-3 per EA, 11 sui tre "grossi", 4 sui
  ridotti).
- **0 modifiche di sostanza al Guardian** (il canale c'e' gia').
- **0 modifiche alla logica di trading**: nessun calcolo di lotto, SL, TP,
  filtro o segnale viene toccato in nessun file.

---

_Parte 1 chiusa il 19/08/2026. Il disegno, l'implementazione e il piano di
collaudo seguono qui sotto man mano che i pezzi vengono committati._
