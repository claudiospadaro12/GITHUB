# 🔎 AUDIT DI FLOTTA — il pattern "PositionSelect cieco su conto HEDGING"

_03/09/2026 · repo `/home/user/GITHUB`, branch `lavoro` · **SOLO LETTURA: nessun
EA e' stato modificato, nessun fix e' stato scritto in questo giro.**_

**Mandato** (passo 1 dei "prossimi passi" di
`report/ORB_GEMELLI_DIVERGENZA_2026-08-22.md`, sezione del 03/09 08:19):
dopo che la **FOTO A** ha inchiodato l'ipotesi A su `ABTG_ORB_Ottimizzato`
(`LARRY DOW S` 772341 aperta dal 01/09 08:45 su U30USD, viva per tutta la vita
del trade ORB), censire **quali ALTRI EA della flotta hanno lo stesso difetto**.

---

## 📐 IL DIFETTO, detto una volta sola

```
bool SelPos(){ if(!PositionSelect(_Symbol)) return(false); return(PositionGetInteger(POSITION_MAGIC)==InpMagic); }
```

Su conto **HEDGING** (`CLAUDE.md`: BCM 50503392 e' hedging)
`PositionSelect(_Symbol)` seleziona **la posizione PIU' VECCHIA del simbolo,
qualunque sia il magic**. Se quella non e' la nostra, il confronto sul magic
fallisce e l'EA **diventa cieco alla PROPRIA posizione**: esce in silenzio da
gestione, breakeven, parziali, trailing, chiusure.

**Il codice e' identico sui due conti: cambia solo il VICINATO.** Ecco perche'
lo stesso `.ex5`, con gli stessi input fotografati, traila sul 100k (dove l'ORB
sul Dow e' quasi sempre solo) e non traila sul piccolo (dove U30USD ha 10
sedie). Il difetto **morde solo con i vicini**: e' per questo che l'audit
incrocia SEMPRE codice + sedie vive + affollamento del simbolo.

### ⚠️ E c'e' un SECONDO grado del difetto, che nessuno aveva ancora nominato

`PositionSelect` sbaglia in **lettura**. Ma `CTrade` sbaglia anche in
**SCRITTURA**, e in modo peggiore:

| chiamata | cosa fa davvero su hedging |
|---|---|
| `gTrade.PositionClose(_Symbol)` | seleziona la posizione **piu' vecchia** del simbolo e **la chiude** |
| `gTrade.PositionModify(_Symbol, sl, tp)` | sposta **lo stop della posizione piu' vecchia** del simbolo |
| `trade.PositionClosePartial(_Symbol, vol)` | chiude una **frazione della posizione piu' vecchia** |

Nei 🔴 "puri" i due errori si **annullano**: se `SelPos()` e' vero vuol dire che
la piu' vecchia E' la nostra, quindi anche `PositionClose(_Symbol)` colpisce la
nostra. La cecita' e' totale ma **coerente**: l'EA non fa niente, non fa danni
agli altri.

🔥 **Dove i due errori si SCOLLANO nasce il danno vero**: negli EA in cui
qualcuno ha gia' corretto la *lettura* (loop hedge-safe su `PositionsTotal()`)
ma **ha lasciato la scrittura per simbolo**. Li' l'EA trova la propria
posizione, decide di chiuderla... **e chiude quella del vicino.** E' la
categoria 🟠 qui sotto: un mezzo fix che, su un simbolo affollato, e' **piu'
pericoloso del bug originale**.

---

## 🧮 IL CENSIMENTO IN NUMERI

**126 file esaminati** (`mql5/Experts/*.mq5` 101 · `mql5/Experts/standalone/*.mq5`
22 · `mql5/Include/**/*.mqh` 3).
_Codifiche verificate una per una con `file --mime-encoding`: **tutti utf-8 o
us-ascii, nessun UTF-16LE**. Nessun grep e' tornato a vuoto per colpa
dell'encoding._

| classe | n | cosa vuol dire |
|---:|---:|---|
| 🔴 **VULNERABILE** | **26** | `PositionSelect(_Symbol)` + check magic con `return`/skip |
| 🟠 **MEZZO FIX (piu' pericoloso)** | **8** | lettura hedge-safe, **scrittura ancora per simbolo** |
| 🟢 **SANO** | **85** | itera `PositionsTotal()` con `PositionGetTicket(i)` e filtra simbolo+magic |
| ⚪ **N/A** | **7** | non tradano affatto (sonde, exporter, framework) |

**26 + 8 = 34 file su 126 toccati dal difetto**, in un grado o nell'altro.

---

## 🏆 CLASSIFICA PER GRAVITA' MISURATA

Ordine = **(vulnerabile) x (sedia viva) x (simbolo affollato)**. Nessun altro
criterio: un 🔴 senza sedia viva sta sotto a un 🟠 con sedia viva su U30USD.

| # | EA | classe | simbolo · magic | vicini sullo stesso simbolo | perche' e' li' |
|---:|---|:---:|---|---:|---|
| **1** | `ABTG_ORB_Ottimizzato` | 🔴 | **U30USD · 770611** (piccolo E 100k) | **9** | **MISURATO 3 volte** (19/08, 21/08, 02/09). Contratto DD 9,92% col doppio asterisco |
| **2** | `ABTG_MaxMinNotte` | 🔴 | **XAUUSD · 770402** + EURUSD M15 | **13** / 6 | Due istanze vive. Contratto R100 DD 10,0% a 0,5%. **Motore a OCO**: la cecita' non toglie solo la gestione, **sblocca il secondo lato** (vedi sotto) |
| **3** | `Gold_Ichimoku_TK_ATR_EA` | 🔴 | **XAUUSD · 250604** | **13** | Sedia viva a 0,5%, contratto 🟡 PARZIALE. Oro = simbolo piu' affollato della flotta |
| **4** | `ABTG_DAX_Apertura_EU_Ottimizzato` | 🟠 | **D30EUR · 770101** | **7** | Sedia con contratto PIENO e **DD 10,60%** (R83). `EndOfSession()` puo' chiudere il DAX del vicino |
| **5** | `ABTG_Dow_Apertura_US` | 🟠 | **U30USD · 770202** | **9** | Stesso quadro, sul simbolo piu' affollato. `PIANO_MIGRAZIONE_100K` dice che ORB/Dow_Apertura/EMA200 operano **negli stessi minuti** |
| **6** | `ABTG_Nasdaq_Apertura_US_Ottimizzato` | 🟠 | NASUSD | **6** | sedia apertura viva |
| **7** | `ABTG_Nasdaq_Apertura_US` | 🟠 | **NASUSD · 770250** (conto piccolo ~5k) | **6** | GATED SHORT, deploy 30/08 |
| **8** | `ABTG_DAX_Apertura_EU` (nativo) | 🟠 | D30EUR | **7** | gira in parallelo all'Ottimizzato |
| **9** | `ABTG_Nasdaq_Live5m` | 🔴 | NASUSD | **6** | ☠️ "morto tenuto per osservazione" — ma **e' acceso**, e i suoi numeri di osservazione sono falsati dalla cecita' |
| **10** | `ABTG_ORB` (nativo) | 🔴 | NASUSD | **6** | ☠️ come sopra + **OCO sbloccato** |
| **11** | `ABTG_ORB_Fibo` | 🔴 | NASUSD | **6** | ☠️ come sopra |
| **12** | `ABTG_DAX_Live5m` | 🔴 | D30EUR | **7** | ☠️ come sopra |
| **13** | `ABTG_DAX_Live5m_v2` | 🔴 | D30EUR | **7** | ☠️ come sopra |
| — | `Include/ABTG/ABTG_ApertureCore.mqh` | 🔴 | _libreria_ | — | **la sorgente del contagio** della famiglia Live5m/Aperture: se non si corregge qui, il difetto rientra al prossimo EA generato |
| — | gli altri 🔴 (12) | 🔴 | **non in campo** | — | `ABTG_Londra_ORB`, `ABTG_DAX_M3`, `ABTG_IntradayMomentum`, `GoldBreakout_Levels`, `Gold_Scalper_TK_BB_BE_EA`, `IchiCross_Gold_722` + 11 copie in `standalone/` |

📌 **Nota onesta sulle righe 9-13**: sono sedie ☠️ "morte in osservazione".
Il difetto **non le rende piu' pericolose** (rischio invariato: senza gestione
lo SL iniziale regge), ma **invalida l'osservazione**: stiamo giudicando dei
motori che sui giorni con vicini non hanno mai eseguito la loro gestione. Se un
domani si vuole leggere il loro forward, va detto che il campione e' sporco.

---

## 🔥 LA SCOPERTA CHE ALLARGA IL CASO: non e' solo il trailing, e' il RISCHIO

Il dossier del 22/08-03/09 imputava a `SelPos()` **trailing, breakeven,
parziale e chiusura di fine giornata**. Vero, ma **incompleto**. In
`ABTG_ORB_Ottimizzato` la stessa `SelPos()` governa altre DUE cose:

```
274:   HandleOCO();
280:   if(SelPos()) gHadPos=true;
281:   else if(gHadPos && InpOneTradePerDay) CancelPendings();
782: void HandleOCO(){ if(SelPos()) CancelPendings(); }
```

1. 🚨 **L'OCO non si disarma.** `HandleOCO()` cancella il pendente OPPOSTO solo
   `if(SelPos())`. Con un vicino piu' vecchio, `SelPos()` e' falso →
   **il secondo lato resta armato mentre siamo gia' dentro** → i due lati del
   breakout possono riempirsi **entrambi** → **due posizioni, DOPPIO del rischio
   contrattuale** sulla stessa giornata.
2. 🚨 **`InpOneTradePerDay` non si arma MAI.** `gHadPos` diventa vero solo
   `if(SelPos())`. Cieco → `gHadPos` resta falso per sempre → il ramo 281 non
   scatta → dopo la chiusura della prima posizione i pendenti **non** vengono
   cancellati → **rientro nello stesso giorno**, contro l'input a pannello
   (fotografato `OneTradePerDay = true` su entrambi i conti).

**Lo stesso schema `HandleOCO(){ if(SelPos()) CancelPendings(); }` e' in:**
`ABTG_ORB.mq5:450` · `ABTG_MaxMinNotte.mq5:371` (**sedia viva 770402 sull'oro,
BuyStop+SellStop alle righe 253/265**) · `ABTG_Londra_ORB.mq5:304`.

⚖️ **Conseguenza per le FIRME 18/08**: questo non e' un difetto di MERITO, e'
un difetto di **RISCHIO**. Il cap "rischio aperto 3,25%" (C1) e' calcolato su
"5 SL vivi da 0,65%": un EA che puo' aprire **due lati invece di uno** su un
simbolo affollato **sfonda il conteggio senza che nessuno lo veda**.
📌 **Non e' stato osservato in campo** — e' una lettura del codice. Ma e' una
lettura che si verifica in un minuto sullo storico: _"nei giorni con vicino
piu' vecchio, l'ORB/MaxMinNotte ha mai aperto DUE posizioni?"_

---

## 🔴 I 26 VULNERABILI — tabella con la riga di codice che prova la classificazione

### In campo o potenzialmente in campo (14 file in `Experts/`)

| EA | riga della prova | funzioni COLPITE (file:riga) |
|---|---|---|
| **`ABTG_ORB_Ottimizzato.mq5`** | `857: bool SelPos(){ if(!PositionSelect(_Symbol)) return(false); return(PositionGetInteger(POSITION_MAGIC)==InpMagic); }` | `ManageTP1()` 565 · `ManageRunner()` 637 · `HandleOCO()` 782 · `EndOfDay()` 799 · flatten news `OnTick()` 287 · **`gHadPos`/OneTradePerDay 280-281** |
| **`ABTG_MaxMinNotte.mq5`** | `469: bool SelPos(){ if(!PositionSelect(_Symbol)) ... }` | `ManagePos()` 294 (parziali+BE+trailing) · `HandleOCO()` 371 · `EndOfDay()` 388 · flatten news 164 · cutoff pendenti 171 |
| **`Gold_Ichimoku_TK_ATR_EA.mq5`** | `672: if(!PositionSelect(_Symbol))` in `HasOpenPosition()` | `HasOpenPosition()` 672 (= conteggio ingressi) · `ModifyStop()` 644 e `ClosePosition()` 654 scrivono per **simbolo** |
| `ABTG_ORB.mq5` | `525: bool SelPos(){ if(!PositionSelect(_Symbol)) ... }` | `ManageTP1()` 387 · `ManageRunner()` 425 · `HandleOCO()` 450 · `EndOfDay()` 467 · flatten news 153 |
| `ABTG_ORB_Fibo.mq5` | `431: bool SelPos(){ ... }` | `ManageTP1()` 285 · `ManageRunner()` 318 · `EndOfDay()` 341 · flatten news 144 |
| `ABTG_Nasdaq_Live5m.mq5` | `1176: if(!PositionSelect(_Symbol)) return(false);` in `SelectMyPosition()` | `ManagePosition()` 1014/1047/1053 (BE + trailing) · `EndOfSession()` 1165 · flatten news 473 |
| `ABTG_DAX_Live5m.mq5` | `1173: if(!PositionSelect(_Symbol)) return(false);` | `ManagePosition()` 1011/1044/1050 · `EndOfSession()` 1162 · flatten news 470 |
| `ABTG_DAX_Live5m_v2.mq5` | `1220: if(!PositionSelect(_Symbol)) return(false);` | `ManagePosition()` 1040/1091/1097 · `EndOfSession()` 1209 · flatten news 483 |
| `ABTG_Londra_ORB.mq5` | `377: bool SelPos(){ ... }` | `ManagePos()` 250 · `HandleOCO()` 304 · `EndOfDay()` 321 · flatten news 142 · cutoff 148 |
| `ABTG_DAX_M3.mq5` | `455: bool SelPos(){ ... }` | uscita Supertrend `OnNewM3Bar()` 169-177 · `ManageTP1()` 295 · `FlatAll()` 397 |
| `ABTG_IntradayMomentum.mq5` | `734: bool SelPos(){ ... }` | **`TentaIngresso()` 623** (`if(SelPos()){gTradeFatto=true;...}` = il "un trade al giorno" **non si arma** se e' cieco) · `ChiusuraCassa()` 680 |
| `GoldBreakout_Levels.mq5` | `342: if(!PositionSelect(_Symbol)) return;` · `378: ... return(false);` | `ManageTrailing()` 342 (+ `PositionModify(_Symbol)` 365/371) · `HasOpenPosition()` 378 |
| `Gold_Scalper_TK_BB_BE_EA.mq5` | `1073: if(!PositionSelect(_Symbol))` in `HasOpenPosition()` | `HasOpenPosition()` 1073 · `ManagePosition()` 812 (`ClosePartial(_Symbol)`) e 844 · `ModifyStop()` 1055 · `CheckTimeExit()` 1251 · `CheckDailyPnLStop()` 1330 |
| **`IchiCross_Gold_722.mq5`** | `429`, `470`, `484`, `522: if(!PositionSelect(_Symbol))` — **quattro volte** | `ManageOpenPosition()` 429 (ingresso della gestione), 467 parziale, 470 breakeven, 484 trailing · `CloseCurrent()` 509 · `HasOpenPosition()` 522 |

📌 `IchiCross_Gold_722` e' l'EA della strategia personale (XAUUSD M5, config
v1.4). **Non risulta fra le sedie censite** — ma XAUUSD e' il simbolo **piu'
affollato della flotta (12-14 grafici)**: se lo si mette in campo cosi' com'e',
**nasce gia' cieco**. Da mettere in cima alla lista del fix prima del deploy,
non dopo.

### La libreria madre (1 file) — il contagio all'origine

| file | riga della prova | chi ne discende |
|---|---|---|
| **`mql5/Include/ABTG/ABTG_ApertureCore.mqh`** | `1027: bool SelectMyPosition(){ if(!PositionSelect(_Symbol)) return(false); return(PositionGetInteger(POSITION_MAGIC)==InpMagic); }` | + `ManagePosition()` scrive per simbolo a 884/898/904 e `EndOfSession()` a 1016. **14 EA la citano** in testa (famiglia Aperture + Live5m). Nei `.mq5` il motore e' **appiattito** (copiato dentro), non `#include`-ato: percio' il fix nel `.mqh` **NON si propaga da solo** ai file gia' esistenti — ma se non lo si fa, il prossimo EA generato dal motore rinasce col difetto |

### In archivio, NON in campo (11 file in `Experts/standalone/`)

Copie congelate del 16/08. **Nessuna gira sul VPS** (la cartella non e'
compilata), ma vanno corrette nello stesso giro, altrimenti il difetto rientra
alla prima "ricostruzione da standalone" — esattamente come nell'
`INCIDENTE_TEMPLATE_2026-08-19.md`.

| file | riga |
|---|---|
| `standalone/ABTG_ORB.mq5` | 355 |
| `standalone/ABTG_ORB_Fibo.mq5` | 388 |
| `standalone/ABTG_MaxMinNotte.mq5` | 418 |
| `standalone/ABTG_Londra_ORB.mq5` | 349 |
| `standalone/ABTG_DAX_M3.mq5` | 427 |
| `standalone/ABTG_GoldenCross.mq5` | **363** (`ManageOpen()`: `if(!PositionSelect(_Symbol)) return;`) e **499** (`HasOpenPos()`) |
| `standalone/ABTG_SupertrendInvert.mq5` | 398 |
| `standalone/ABTG_DAX_Live5m.mq5` | 1050 |
| `standalone/ABTG_DAX_Apertura_EU.mq5` | 1047 |
| `standalone/ABTG_Nasdaq_Live5m.mq5` | 1053 |
| `standalone/ABTG_Nasdaq_Apertura_US.mq5` | 1050 |

✅ **Buona notizia da dichiarare**: le versioni **in campo** di `ABTG_GoldenCross`,
`ABTG_SupertrendInvert`, `ABTG_EMA200`, `ABTG_PTE` ecc. (quelle in
`Experts/`, non in `standalone/`) sono **gia' 🟢**: qualcuno le ha riscritte a
ticket. Il difetto e' rimasto **solo dove non e' passata quella mano**.

---

## 🟠 GLI 8 "MEZZO FIX" — leggono bene, scrivono male

Tutti hanno gia' la lettura hedge-safe, con tanto di commento che racconta il
fix:

```
Experts/ABTG_Dow_Apertura_US.mq5:1945-1956
bool SelectMyPosition()
  {
   // Hedge-safe: scorro TUTTE le posizioni e seleziono la MIA (simbolo+magic).
   // PositionSelect(_Symbol) prendeva la prima posizione qualsiasi sul simbolo:
   // con piu' EA sullo stesso strumento la gestione saltava. Ora per ticket.
   for(int _i=PositionsTotal()-1;_i>=0;_i--)
     { ulong _tk=PositionGetTicket(_i);
       if(_tk>0 && PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic)
          return(true); }
   return(false);
  }
```

...**e poi chiudono per simbolo**:

| EA | riga che scrive alla cieca | funzione |
|---|---|---|
| **`ABTG_Dow_Apertura_US.mq5`** | `609: if(SelectMyPosition()) gTrade.PositionClose(_Symbol);` · `1936: gTrade.PositionClose(_Symbol);` | flatten news `ABTG_OnTick()` · `EndOfSession()` |
| **`ABTG_DAX_Apertura_EU_Ottimizzato.mq5`** | `485` · `1225` | idem |
| **`ABTG_DAX_Apertura_EU.mq5`** | `669` · `2105` | idem |
| **`ABTG_Nasdaq_Apertura_US_Ottimizzato.mq5`** | `486` · `1226` | idem |
| **`ABTG_Nasdaq_Apertura_US.mq5`** | `697` · `2355` | idem |
| `ABTG_Apertura_3Ingressi.mq5` | `839` · `2470` | idem (non in campo) |
| `ABTG_Apertura_Marco.mq5` | `565` · `1398` | idem (**RITIRATO 06/08**) |
| `ABTG_DaxValueArea.mq5` | `913: gTrade.PositionModify(_Symbol, be, tp);` — **dentro un loop dove `ticket` e' gia' in mano** | `GestisciPosizione()`, breakeven dopo il parziale (non in campo) |

🚨 **La riga 609 letta ad alta voce**: _"se la MIA posizione esiste, chiudi la
posizione PIU' VECCHIA del simbolo"_. Sul Dow del conto piccolo, il 02/09,
sarebbe stata **`LARRY DOW S` 772341**. `ABTG_DaxValueArea:913` e' il caso piu'
netto: la variabile `ticket` e' **gia' disponibile due righe sopra** (la usa
`PositionClosePartial(ticket, ...)` a riga 900) e la `PositionModify` usa
`_Symbol` lo stesso — e' un refuso di scrittura, non una scelta.

📌 **Perche' non l'abbiamo mai visto succedere**: perche' `InpCloseAtEnd` e il
flatten news devono ATTIVARSI mentre un vicino piu' vecchio e' aperto. Se una
sedia Aperture ha mai chiuso "da sola" la posizione di un'altra sedia, si vede
nello storico: **chiusura market di un ticket X a un orario che coincide col
`InpCloseHour` di un ALTRO magic**. E' una verifica misurabile su
`trades_auto.csv` / `ABTG_Trades.csv`, e va fatta prima di decidere il fix.

---

## 🟢 GLI 85 SANI — il modello corretto, gia' scritto in casa

Filtrano **simbolo + magic** iterando le posizioni. Esempio pulito, da usare
come riferimento (`ABTG_CanaleLento.mq5:503-507`):

```
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;
```

Rientrano qui, fra gli altri, **tutte le sedie contrattuali a piu' alto peso
che non compaiono nelle liste sopra**: `ABTG_PTE` / `_Ottimizzato` (771321,
771322, 771332), `ABTG_SuperWave` e i `_DOW_H1/_DAX_H4_Ottimizzato` (770511,
770531), `ABTG_EMA200` / `_Ottimizzato` (771531, 971501, 771511-15),
`ABTG_PunteLarry` (772341-46), `ABTG_GapFill` (772231-35), `ABTG_BreakingBand`
(772161-63), `ABTG_CostToCost` (772361-63), `ABTG_EasyTrend` (772421-23),
`ABTG_SupertrendReversal` e famiglia `SupRev_*_Ottimizzato` (770901, 770921-25,
970901, 970912-14, 971001), `ABTG_GoldenCross` / `_Ottimizzato` (770331-33,
970301), **`ABTG_MaxMinNotte_DAX_Short_Ottimizzato` (770411)**,
`ABTG_GapContinuation` (774101), `ABTG_Nightly`, `ABTG_WOL`, `ABTG_HARSI`,
`ABTG_PostNews`, `DAX_MASTER_PROP`, `ORB_DAX_BASE_EA`, `ORB_DAX_PM_EA`,
`ORB_GOLD_FIBONACCI_EA` (+ v3.21), `ORB_OpeningRange`, `DAX_M3_Supertrend`,
`BULGE_MASTER`, `ABTG_Bulge`, `ABTG_DaxReEntry`, `ABTG_VwapRevert`,
`ABTG_CanaleLento`, `ABTG_AllineaLondra`, `ABTG_SondaOrologio`,
`Include/ABTG_PausaGuardian.mqh`.

⚠️ **Attenzione a non confondere due file quasi omonimi:**
`ABTG_MaxMinNotte.mq5` e' 🔴 (sedia oro 770402 + EURUSD),
`ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5` e' 🟢 (sedia DAX 770411).
**Sono due sorgenti diversi**: la 770411 non e' toccata da questo audit.

### Due 🟢 con una nota da dichiarare (non sono bug, sono scelte)

| file | nota |
|---|---|
| `HARSI_Assistant.mq5` | itera per ticket ma filtra **solo per SIMBOLO, mai per magic** (righe 237-238, 256-257, 387-388): `ManageManualTrades` aggancia SL/TP a **qualunque** posizione del simbolo. E' il suo mestiere (assistente di trade manuali) — ma su un simbolo affollato **riscriverebbe lo stop degli EA vicini**. Non risulta in campo; se ci va, **va su un simbolo suo** |
| `ABTG_Guardian.mq5` | `394: if(PositionsTotal()>0 \|\| OrdersTotal()>0) FlattenAll();` — globale **per disegno**: e' il guardiano, deve chiudere tutto. Nessuna correzione |

---

## ⚪ I 7 N/A — non gestiscono posizioni perche' non ne aprono

`ABTG_SondaLondonFx.mq5` · `ABTG_SondaM0PB.mq5` · `ABTG_SondaRsiEmaV8.mq5` ·
`ABTG_SondaMargine.mq5` · `ABTG_Apertura_Study_EA.mq5` ·
`ABTG_TradeExporter.mq5` · `Include/OptFrame.mqh`.

Verificato: **zero `OrderSend`, zero `CTrade`, zero `PositionClose`** (le sonde
lo dichiarano in testa al file, riga 10-11; verificato che la dichiarazione
corrisponde al codice). Sono simulatori/esportatori: **niente da correggere, e
nessun conteggio cieco** perche' non contano niente.

---

## 🗺️ LA MAPPA DEI VICINATI — dove il difetto morde

_(fonte: `FLOTTA_ATTIVA.md` + `report/CONTRATTI_SEDIE.md`. Il difetto e'
proporzionale al numero di vicini: su un simbolo con una sola sedia, un 🔴 si
comporta come un 🟢.)_

| simbolo | sedie vive | di cui 🔴 | di cui 🟠 |
|---|---:|---|---|
| **XAUUSD** | **~14** (970901, 971501, 970301, 971001, 770402, 772343, 250604 + 7 nativi) | **MaxMinNotte 770402 · Gold_Ichimoku 250604** | — |
| **U30USD** | **10** (770202, 770611, 771321, 770511, 770531, 771531, 772234, 772341, 970914, SupRev_DOW_H1) | **ORB_Ottimizzato 770611** | **Dow_Apertura_US 770202** |
| **D30EUR** | **8** (770101, DAX_Apertura nativo, 770411, 970912, 770923, SuperWave_EA, Live5m, Live5m_v2) | **DAX_Live5m · DAX_Live5m_v2** | **770101 · DAX_Apertura_EU nativo** |
| **NASUSD** | **7** (970913, Nasdaq_Apertura_Ott, 770250, Nasdaq_Live5m, ORB, ORB_Fibo, SupRev nativo) | **Nasdaq_Live5m · ORB · ORB_Fibo** | **Nasdaq_Apertura_Ott · 770250** |
| **GBPUSD** | 7 (771322, 771332, 772161, 772231, 772345, 772422, 771515) | — | — |
| **EURUSD** | 6 (MaxMinNotte, Nightly, HARSI, PostNews, 772162, 772232) | **MaxMinNotte** | — |
| **225JPY** | 3 (770901, 774101, 772235) | — | — |

🔎 **Il vicino piu' pericoloso in assoluto e' `ABTG_EMA200` U30USD 771531**:
**33-35 operazioni al mese** (contratto R29/R31). Su U30USD e' la sedia che
tiene una posizione aperta piu' spesso di tutte — cioe' la macchina che
acceca gli altri piu' spesso. Non e' colpa sua (e' 🟢), ma va sappiuto: **se si
volesse una misura empirica del difetto, e' la sua serie a dare le "finestre di
cecita'" del Dow.**

---

## 🛠️ PROPOSTA DI STRATEGIA DI FIX (da discutere — NON scritta in questo giro)

### La domanda vera: helper condiviso o fix per-EA?

| | 📦 **A — helper condiviso** (`Include/ABTG/ABTG_PosHedge.mqh`) | 🔧 **B — fix per-EA** |
|---|---|---|
| **pro** | si scrive e si autotesta **una volta sola**; la prossima sedia nasce sana; il difetto non puo' rientrare da copia-incolla | tocca solo cio' che serve; **zero rischio di rompere gli 85 🟢** |
| **contro** | i `.mq5` della flotta **NON `#include`-ano niente** (il motore Aperture e' **appiattito**): adottare l'helper vuol dire **toccare 34 file** e ricompilarli tutti, in un colpo. Contro la regola di casa "una variabile alla volta" | 34 diff separate, 34 verifiche, 34 ricompilazioni firmate. Ripetitivo e **facile da dimenticare a meta'** — e' esattamente cosi' che sono nati gli 8 🟠 |
| **rischio di regressione** | alto in un colpo solo | basso per volta, ma diluito su settimane |

### 💡 La proposta: **A per il futuro, B per il presente, in QUEST'ORDINE**

1. **Scrivere l'helper `ABTG_PosHedge.mqh`** con tre sole funzioni, tutte a
   ticket: `PosTicketMio(sym,magic)` (0 se non c'e'), `ContaPosizioniMie(...)`,
   e nient'altro. **Non adottarlo subito da nessuno**: nasce come **standard
   dichiarato** per gli EA nuovi (a partire da `IchiCross_Gold_722`, che non e'
   ancora in campo). Costo zero sul forward.
   📌 Il codice esiste **gia'** in casa, provato: `ABTG_ORB_Ottimizzato.mq5:767`
   (`ContaPosizioniMagic()`, scritta ieri per la diagnostica) e
   `ABTG_MaxMinNotte.mq5:184` (la guardia anti-duplicato). **Non c'e' niente
   da inventare: c'e' da spostare.**

2. **Fix per-EA sulla sola CIMA della classifica**, uno alla volta, ognuno con
   la sua ricompilazione firmata:
   **(1) `ABTG_ORB_Ottimizzato` → (2) `ABTG_MaxMinNotte` → (3)
   `Gold_Ichimoku_TK_ATR_EA` → (4) i due Aperture 🟠 su D30EUR/U30USD.**
   Cinque interventi coprono **tutte le sedie contrattuali a rischio**. Gli
   altri 29 file sono ☠️/archivio e possono aspettare un giro di pulizia unico.

3. **La forma del fix, in due mosse che vanno INSIEME** (farne una sola
   ricrea la categoria 🟠, il caso peggiore):
   - **lettura**: `SelPos()` → loop `PositionsTotal()` + `PositionGetTicket(i)`
     + filtro simbolo **e** magic, che **memorizza il ticket** in una globale;
   - **scrittura**: ogni `PositionClose(_Symbol)`, `PositionModify(_Symbol,...)`,
     `PositionClosePartial(_Symbol,...)` → **la variante a ticket**.

4. **Come lo si misura** (regola di casa: una variabile alla volta, e la prova
   non e' un'opinione):
   - **Backtest**: girare la stessa cella **prima e dopo**, a parita' di tutto.
     Nel tester **il difetto e' invisibile** (l'EA e' solo sul simbolo, nessun
     vicino): il risultato atteso e' **IDENTICO al centesimo**. Se cambia, il
     fix ha rotto qualcos'altro. **E' il test di non-regressione, non di
     merito.**
   - **Il merito** si vede **solo in forward**, e si misura cosi': dal primo
     trade dopo il fix, i giorni **con vicino piu' vecchio** devono mostrare il
     trailing nel log (le righe `ORB RUNNER:` della v1.03 servono a questo).
   - **Metrica attesa**: nessun cambio di frequenza; **peggior giornata e
     drawdown in calo** sui giorni con vicini (la gestione torna a esistere);
     e — se il ramo OCO viene corretto — **sparizione dei doppi ingressi**.
     🚨 **Non promettiamo piu' profitto**: promettiamo che l'EA **fara' quello
     che dice il suo pannello**. Che sia meglio, lo dice il forward.

5. 🚨 **Prima di toccare qualunque cosa, una verifica storica che costa
   mezz'ora**: cercare su `ABTG_Trades.csv` / `trades_auto.csv` se una sedia
   Aperture 🟠 ha **gia'** chiuso la posizione di un vicino (chiusura market a
   un orario che e' il `InpCloseHour` di un ALTRO magic). Se la si trova,
   l'ordine di priorita' si **capovolge**: i 🟠 salgono sopra i 🔴, perche' un
   EA che chiude il trade di un altro fa danno **attivo**, non passivo.

### ⛔ Cosa NON fare
- **Non correggere tutti e 34 i file in un commit.** Con 34 diff e una
  ricompilazione unica, se il forward peggiora **non sappiamo quale riga e'
  stata**. Vale qui la regola A dell'emendamento: una variabile alla volta.
- **Non toccare gli 85 🟢** "per uniformita' di stile". Funzionano.
- **Non trasformare `PositionClose(_Symbol)` in `PositionClose(ticket)` da
  solo** lasciando `PositionSelect(_Symbol)` in lettura: si ottiene il
  simmetrico degli 🟠, altrettanto rotto.
- **Non dichiarare risolto il caso ORB con questo audit.** Questo referto
  dice **chi altro ha il difetto**; la conferma **strumentale** su ORB resta il
  log n.4 della v1.03 al prossimo trade con vicini, come scritto nel dossier.

---

## 📋 LIMITI DICHIARATI DI QUESTO AUDIT

1. **E' una lettura del codice, non una misura sul campo.** Solo per l'ORB
   esiste la prova osservata (3 giorni + FOTO A). Per gli altri 33 file il
   difetto e' **dimostrato nel sorgente** e **plausibile in campo**: quanto
   abbia morso davvero, lo dicono gli storici, non io.
2. **La lista delle sedie vive viene dai documenti** (`FLOTTA_ATTIVA.md` del
   02/08 + aggiornamenti, `CONTRATTI_SEDIE.md` del 18/08 + revisione 24/08),
   **non da un censimento `.chr` di oggi**. `FLOTTA_ATTIVA.md` porta gia' righe
   invecchiate ammesse nel file stesso. **Prima del fix va rifatta la foto**:
   se una sedia 🔴 e' stata spenta, esce dalla classifica; se una 🟢 e' finita
   su un simbolo affollato, entra.
3. **Il conteggio dei "vicini" e' per SIMBOLO, non per finestra oraria.** Due
   sedie sullo stesso simbolo che non sono mai aperte insieme non si accecano.
   La stima e' quindi un **limite superiore** del danno.
4. **`.ex5` non ispezionati**: `Experts/esterni/NasdaqOpeningBreakout_EA_v21_OPTIMIZED.ex5`
   e' un binario senza sorgente. **Non classificabile.** Se gira su un simbolo
   affollato, e' un buco nell'audit — da dichiarare, non da indovinare.
5. **Non ho compilato ne' testato niente**: qui non c'e' MetaEditor ne'
   Strategy Tester. Ogni numero di questo referto viene da `file:riga` del
   repo o da un documento gia' agli atti.

---

_Audit del 03/09/2026. Nessun EA modificato, nessun fix scritto, come da
mandato. Prossimo passo su firma di Claudio: la verifica storica del punto 5
della proposta, poi il fix v1.04 dell'ORB._
