# MODIFY A RAFFICA SU FTMO: il trailing che chiede uno stop sopra il prezzo (25/09/2026)

**Perimetro:** sola lettura e diagnosi. Nessun EA, nessun preset toccato, nessun commit.
La correzione in fondo e' un **diff NON applicato**: modificare un EA vivo sul conto della
challenge `541452707` e' una **firma di Claudio**.

Etichette: **[MISURATO]** = letto in un file del repo, con fonte · **[INFERITO]** = dedotto dal
codice o dall'aritmetica · **[NON VERIFICATO]** / **[NON MISURATO]** = manca il dato.

---

## 0. Il verdetto in quattro righe

1. **Il ramo e' il TRAILING PREVBAR, non il breakeven.** Lo stop chiesto (25400,14) e' il minimo
   della candela M5 precedente, sopra l'ingresso (25392,54). Il breakeven lo metterebbe a 25392,54
   e `InpBEatR=0`.
2. **"invalid stops" = stop DAL LATO SBAGLIATO del prezzo**, non stop troppo vicino: su FTMO
   `GER40.cash` ha `StopsLevel=0` e `FreezeLevel=0`. Il trailing non confronta mai lo stop proposto
   col Bid. Dopo un riempimento RETEST, ogni volta che il trailing vuole muovere (minimo della
   candela precedente sopra l'ingresso), quello stop sta sopra il Bid per costruzione
   (`Bid < Ask <= ingresso < minimo precedente`). Se il minimo precedente e' sotto l'ingresso non
   parte niente: e' il caso del reale il 24/09 (§1).
3. **Ritenta a ogni tick** perche' il rifiuto non cambia niente: lo stop resta quello vecchio, le
   condizioni restano vere, `OnTick` rilancia `ManagePosition`. Si ferma solo quando il Bid risale
   sopra 25400,14, quando chiude la candela, o quando la posizione chiude.
4. **Non e' un caso isolato**: stessa raffica sul DAX BCM l'11/09 e il 17/09, **su tutti e tre i
   conti BCM, reale `10105439` compreso**. E il difetto sta, identico riga per riga, anche in
   `770202` Dow e `770260` Nasdaq.

---

## 1. Quale codice gira, e quale ramo manda la modify

**Versione in campo:** sul grafico FTMO gira **`CLAU12_DAX_Apertura_EU.ex5`**, copia rinominata
(`report/RINOMINA_CLAU12_2026-09-20.md`), compilata il **20/09 16:58**. Il suo sorgente in `C:\FTMO`
ha **2426 righe** = `ABTG_DAX_Apertura_EU.mq5` al pin **`9fca63d9`** (2425) + 1 [MISURATO per
numero di righe, **NON** per impronta byte] (`backtest_pipeline/coda/referti/CODA_06_quale_codice_gira_20260925_033004.log`
r.209-214; pin da `report/SCHIERAMENTO_FTMO_2026-09-20.md` §5.1 r.179). Le righe della raffica sono
firmate `CLAU12_DAX_Apertura_EU`. Gli `ABTG_*.mq5` presenti in `C:\FTMO` **non hanno `.ex5`**
(`CODA_06` r.183-188): correggere e compilare quelli **non cambia niente sul grafico**.

**Preset** [MISURATO sul file del repo `mql5/Presets/FTMO/ABTG_DAX_Apertura_EU_770101_FTMO.set`,
`SCHIERAMENTO` §5.2 r.199; **NON VERIFICATO** che sia quello caricato sul grafico]: `InpEntryMode=2` (RETEST) · `InpTP1_R=1.0` ·
`InpTP1_ClosePct=50` · `InpBreakevenAtTP1=true` · **`InpBEatR=0.0`** · `InpUseTrailing=true` ·
**`InpTrailStartR=0.0`** (il trailing si arma subito) · **`InpTrailMode=1`** (PREVBAR) ·
**`InpTrailTF=5`** (M5).

**Le quattro `PositionModify` del file (pin `9fca63d9`):**

| riga | ramo | puo' aver prodotto `sl: 25400.14`? |
|---|---|---|
| r.1936 | breakeven al 1o obiettivo | **No**: metterebbe lo stop a `openP` = 25392,54. E ritenta mai: `TkMark(ticket, gBETk)` a r.1937 lo segna fatto al primo colpo |
| r.1956 | breakeven indipendente | **No**: spento, `InpBEatR=0` (r.1945) |
| **r.1987** | **trailing BUY** | **Si'**: `newSL = iLow(_Symbol, InpTrailTF, 1)` (r.2004), minimo della candela M5 precedente |
| r.1993 | trailing SELL | no, la posizione e' BUY |

**Il condizionale che manda la richiesta** (r.1985-1987, identico a HEAD r.2445-2447):

```mql5
double newSL = TrailStopBuy(bid);
if(newSL > 0 && newSL > sl && newSL > openP)
   gTrade.PositionModify(ticket, NormalizePrice(newSL), tp);
```

Controlla che lo stop salga (`> sl`) e che stia sopra l'ingresso (`> openP`). **Non controlla mai
che stia sotto il Bid.** Per un BUY il server accetta lo stop solo se `Bid - SL >= StopsLevel`.

### Perche' "invalid stops", e perche' e' strutturale nel RETEST

- `GER40.cash` su FTMO: **`StopsLevelPts=0`, `FreezeLevelPts=0`** [MISURATO,
  `backtest_pipeline/risultati_prove/PREVOLO_FTMO_specifiche_2026-09-20.csv`, riga DAX, r.40, colonne 16-17
  dell'intestazione a r.39]. Quindi **non** e' "troppo vicino": e' lo stop **sopra** il Bid.
- Un BUY LIMIT si riempie quando l'Ask scende fino al livello: al riempimento
  `Bid < Ask <= 25392,54 < 25400,14`. Se la candela precedente e' rimasta tutta sopra il livello (il
  caso tipico di un ritracciamento che arriva dall'alto), **il primo tick dopo il riempimento propone
  uno stop sopra il prezzo**.
- **Prova che la raffica parte AL RIEMPIMENTO** [MISURATO, due casi sul reale]: SlippageLogger
  (`CODA_10_slippage_20260925_033004.log` r.23 e r.31) dà gli ingressi `770101` alle **10:07:34** e
  **13:43:36 ora BCM**; le raffiche nei giornali (ora locale italiana = BCM + 1) partono alle
  **11:07:34.548** e **14:43:36.319**. Stesso secondo.
- **Il contro-esempio dello stesso giorno** [MISURATO]: il 24/09 il reale BCM ha preso lo stesso
  RETEST (BUY LIMIT 25392,10, riempito 14:23:03 BCM) e **non ha nessuna riga di modify rifiutata**
  (`CODA_09_..._20260925_033004.log` r.198-206: 1 sola riga ordine, r.205). Il suo trailing ha messo lo
  stop a 25396,00 senza rifiuti (uscita SL alle 14:35:00, `CODA_10` r.36). Il difetto non scatta a
  ogni RETEST: scatta quando il Bid al riempimento sta sotto il minimo della candela precedente.

### Perche' ritenta a ogni tick, senza limite

- `ABTG_OnTick` chiama `ManagePosition()` **a ogni tick** (r.589; HEAD r.727).
- Il rifiuto non lascia traccia: nessuno stato per-ticket (a differenza di `gBETk`/`gPartialTk`),
  nessun controllo del `retcode`. Al tick dopo `sl` e' ancora lo stop iniziale 25249,54, quindi
  `newSL > sl` e `newSL > openP` sono ancora vere, e parte la stessa richiesta.
- **Quando si ferma** [INFERITO dal codice]: (a) il Bid risale sopra 25400,14 e la modify passa;
  (b) chiude la candela M5: il nuovo "minimo precedente" e' quello della candela del riempimento,
  che e' `<= Bid al riempimento < openP`, quindi `newSL > openP` diventa falsa; (c) la posizione
  chiude.
- Sul caso del 24/09: ultima chiusura FTMO del giorno **2026.09.24 16:36:01 ora server** =
  15:36:01 italiana [MISURATO, `CODA_12_pertrade_posizioni_20260925_033004.log` r.21, estremo
  `close_time` di `ABTG_Trades_FTMO.csv`]. Quindi la raffica e' durata **al massimo ~42 s**
  (15:35:18.757 -> 15:36:01) [INFERITO: che quella chiusura sia la #170199888 e' dedotto, e' la
  sola sedia FTMO che ha chiuso nel pomeriggio secondo `report/RESOCONTO_2026-09-24.md` r.16].
- Nota di contorno: +69,66 EUR / 10,70 lotti / 1 EUR per punto per lotto (TickValue 0,01 per
  0,01 punti, CSV PREVOLO) = **~6,5 punti**, uscita **~25399,05** [INFERITO, senza commissioni]:
  compatibile con lo stop 25400,14 infine accettato quando il Bid e' risalito e poi colpito con
  ~1 punto di scivolamento. Non e' dimostrato.
- Nota di contorno 2: rischio del trade = 143 punti x 10,70 = **1.530 EUR ~ 2,0%** dell'equity
  ~76,6k [INFERITO]: coerente con `InpRiskPercent=2.00` del preset, gia' documentato in
  `SCHIERAMENTO_FTMO_2026-09-20.md` r.410-412. Non e' un fatto nuovo.

---

## 2. Quante richieste puo' fare, nel caso peggiore

### I ritmi misurati (7 raffiche, tutte `770101` salvo dove detto)

| giorno | conto | righe stampate | durata visibile | ritmo | intervallo min |
|---|---|---:|---:|---:|---:|
| 24/09 | FTMO `541452707` | 38 | 16,904 s | **2,19/s** | 0,082 s |
| 11/09 | reale `10105439` | 39 | 25,508 s | 1,49/s | 0,229 s |
| 11/09 | 100k `50504263` | 38 | 24,227 s | 1,53/s | 0,226 s |
| 11/09 | piccolo `50503392` | 28 | 15,668 s | 1,72/s | 0,222 s |
| 17/09 | reale `10105439` | 39 | 22,278 s | 1,71/s | 0,225 s |
| 17/09 | 100k `50504263` | 37 | 20,927 s | 1,72/s | 0,149 s |
| 17/09 | piccolo `50503392` | 33 | 18,099 s | 1,77/s | 0,022 s |

[MISURATO: `CODA_09_giornale_operativo_20260925_033004.log` r.95-135 (modify r.98-135),
`..._20260912_033002.log`, `..._20260918_033004.log`; ritmo = intervalli/durata.]

**La durata vera NON e' misurata**: la sonda stampa al massimo 40 righe per file
(`backtest_pipeline/righe/CODA_09_giornale_operativo.ps1` r.38, `$MAX_RIGHE = 40`). I totali del
giorno sono solo **tetti**, perche' contano anche le righe d'ordine delle altre sedie: FTMO 24/09
**103** (quindi <= 101 modify), reale 11/09 **269**, reale 17/09 **199** [MISURATO].

### I tetti

| scenario | richieste | etichetta |
|---|---:|---|
| 24/09 FTMO, com'e' andata | **38 certe, <= ~93** (42 s x 2,19/s), <= 101 dal totale della sonda | MISURATO / INFERITO |
| **un episodio RETEST, candela intera** (riempimento al primo secondo, Bid mai sopra il minimo per 300 s), al ritmo MEDIO | **<= 657** a 2,19/s | INFERITO (tetto dalla chiusura della candela, §1) |
| **idem, al ritmo MASSIMO misurato**: intervallo minimo 0,082 s su FTMO = ~12/s | **<= ~3.660 con UNA sedia sola**; supera le 2.000 se tiene >= 6,7 richieste/s per 300 s | INFERITO |
| **le tre sedie Apertura sullo stesso conto** (`770101`+`770202`+`770260`, stesso codice, §3) nello stesso giorno, ognuna a candela intera | **<= ~1.971** a 2,19/s | INFERITO |
| idem al ritmo piu' alto visto nel repo (5,27/s, `EMA200_Ottimizzato` XAUUSD, 23/09) | 1.581 per sedia, **~4.743** per tre | INFERITO |
| caso generale (non-RETEST): posizione in profitto, ogni candela scambia sotto il minimo della precedente restando sopra l'ingresso | **nessun tetto nel codice**: una candela alla volta, finche' la condizione si ripete | INFERITO |

**Lettura onesta:**
- **La raffica** del 24/09 vale **~5% della soglia** (<= 101 su 2.000). **Il TOTALE DEL GIORNO
  NON e' misurato**: la sonda legge `MQL5\Logs`, dove `CTrade` stampa solo le richieste
  **FALLITE**. Ordini, modify riuscite (come il trailing tick per tick di `770411`), parziali e
  chiusure li' non ci sono.
- **Ma la distanza dal tetto non e' grande**: al ritmo **medio** (2,19/s) servono **tre sedie**
  d'apertura riempite male nello stesso giorno per toccare le 2.000; al ritmo **massimo misurato**
  (~12/s) ne basta **UNA** [INFERITO]. Improbabile (serve un riempimento sotto il minimo
  precedente e un prezzo che non risale per minuti), **non impossibile**: su 6 ingressi `770101`
  del reale coperti dai giornali (11, 15, 16, 17, 22, 24/09) **2 hanno avuto la raffica** [MISURATO].
- [NON VERIFICATO] se il rifiuto arrivi dal **server FTMO** o sia un **controllo del terminale**
  (e quindi se conti come "richiesta al server"; per prudenza si conta). [NON VERIFICATO]
  l'**unita'** del limite: per conto e per giorno, o "su singoli trade/pendenti" come dice
  `report/REGOLAMENTI_PROP_2026-09-08.md` r.99.

---

## 3. Le altre sedie FTMO

Letti i sorgenti **ai pin in campo** (`SCHIERAMENTO_FTMO_2026-09-20.md` §5.1).

| sedia | sorgente @ pin | trailing | guardia sul lato del prezzo? | verdetto |
|---|---|---|---|---|
| `770202` Dow | `ABTG_Dow_Apertura_US.mq5` @ `9fca63d9`, **r.1812-1826** | PREVBAR M5, `TrailStartR=0`, RETEST (`InpEntryMode=2`) | **NO** | **STESSO DIFETTO** (blocco identico a `770101`, verificato con `diff`) |
| `770260` Nasdaq | `ABTG_Nasdaq_Apertura_US.mq5` @ `9fca63d9`, **r.2225-2239** (HEAD r.2245-2259) | PREVBAR M5, `TrailStartR=0`, RETEST, `RetestOffsetPts=0` | **NO** | **STESSO DIFETTO** (blocco identico) |
| `770411` MaxMin DAX Short | `ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5` @ `5fc0bc31`, r.363-364 | ATR: `ask + 2*ATR` | implicita: lo stop e' calcolato DAL prezzo corrente | niente raffica di rifiuti; ma e' un trailing **tick per tick**: una modify **riuscita** a ogni nuovo minimo (tick 0,01) oltre 2 ATR di profitto. Richieste vere, non rifiuti [INFERITO] |
| `771531` EMA200 | `ABTG_EMA200.mq5` @ `26a18566`, r.302-303 | EMA14 | **SI'**: `n<bid` / `n>ask` | trailing sicuro con `StopsLevel=0` su `US30.cash` (CSV PREVOLO); **vedi sotto il breakeven r.291** |
| `770511` SuperWave | `ABTG_SuperWave_DOW_H1_Ottimizzato.mq5` @ `872dba82`, r.341-342 | Supertrend | **SI'**: `stLine<bid` / `>ask` | trailing sicuro; il breakeven r.331 scatta a +1R, lontano dal prezzo |
| PostNews `77120x` (non chiesta) | `ABTG_PostNews.mq5` @ `61dc18c9`, r.406-407 | fisso: +25 pip -> SL a 15 pip | implicita (trigger 25 > 15) | sicuro |

Nei giornali delle sonde 09/09-24/09 non ci sono rifiuti per Dow e Nasdaq, ma l'assenza e'
**MISURATA solo sulle righe stampate**. In sette giorni-conto la sonda ha tagliato (11/09 e 17/09
sui tre BCM: 302/232/229 e 168/161/159 righe non stampate; 24/09 FTMO: 63), e li' l'assenza **non
e' misurata**.
- `770260` Nasdaq: **nessun riempimento RETEST letto nei giornali**, quindi il difetto **non ha mai avuto
  l'occasione di scattare**: latente, mai messo alla prova, come il Dow. Le sei righe Nasdaq dei giorni NON
  tagliati non sono occasioni: 14, 15, 16 e 18/09 sul piccolo sono `ABTG_Nasdaq_Apertura_US` **M15 a rottura
  (SELL STOP)**, un'altra configurazione (preset di repo `InpEntryMode=0`, magic `770201` [INFERITO: la magic
  non e' nel giornale]); 22 e 23/09 su FTMO sono **segnali RETEST scartati per volumi** ("salto", nessun
  ordine) [MISURATO].
- `770202` Dow: **nessuna riga d'ordine in nessun giornale letto** -> difetto **latente, mai messo
  alla prova**.

**Un rischio in piu', latente, su `771531`** [INFERITO, mai osservato]: a r.272-291 il 1o obiettivo
e' la EMA14 (`InpTP1_ATRmult=0`). L'ordine 1 sta a `EMA200 + 0,2 ATR`; il filtro d'ingresso chiede
solo `EMA14 > EMA200`. Se la EMA14 sta fra EMA200 e l'ingresso, al riempimento `hit` e' gia' vera:
parte la parziale e poi il breakeven a `openP` **sopra** il Bid -> rifiutato, e siccome `beDone`
resta falso, **al tick dopo parte un'altra parziale e un altro breakeven**, fino al lotto minimo.
Da verificare con un backtest che conti le righe `invalid stops` del tester; non tocca questa
diagnosi.

**Parente, fuori da FTMO** [MISURATO, causa NON diagnosticata]: `ABTG_EMA200_Ottimizzato` XAUUSD
sul piccolo `50503392` ha rifiuti a raffica il 09/09 (30 righe, `#3340278`) e il 23/09 (28 righe in
5,1 s, **5,27/s**, `#3430899`), **nonostante** la guardia `n<bid`: probabile `StopsLevel > 0` su
XAUUSD BCM (la guardia controlla il lato, non la distanza) [NON MISURATO].

---

## 4. La correzione minima (DIFF NON APPLICATO)

### Parte A — necessaria, neutra sui risultati

Replica prima dell'invio la regola del server (`Bid - SL >= StopsLevel` per un BUY,
`SL - Ask >= StopsLevel` per un SELL). Le modify che il server avrebbe accettato partono
**identiche**; quelle che avrebbe rifiutato **non partono**, e si scrive una riga di log per ticket
per candela. Il blocco, al **PIN in campo**: DAX `9fca63d9` **r.1981-1996** · Dow **r.1812-1827** ·
Nasdaq **r.2225-2240**; identici fra loro e a HEAD (verificato con `diff`).

**La correzione si applica SOPRA `9fca63d9`, NON sopra HEAD**: HEAD porta **+460 righe** sul DAX e
**+21/-1** sul Nasdaq mai girate in campo. **Il diff qui sotto e' ILLUSTRATIVO**: e' numerato su
HEAD, l'intestazione `+2441,40` dovrebbe essere `+2441,49`, manca il contesto in coda, e
`git apply --check` lo rifiuta. Quello vero si genera sul ramo aperto dal pin.

```diff
--- a/mql5/Experts/ABTG_DAX_Apertura_EU.mq5
+++ b/mql5/Experts/ABTG_DAX_Apertura_EU.mq5
@@ -2441,16 +2441,40 @@
    if(InpUseTrailing && trailArmato)
      {
+      //  25/09/2026 -- GUARDIA DEL LATO GIUSTO (raffica FTMO del 24/09, #170199888).
+      //  Il trailing PREVBAR propone il minimo/massimo della candela PRECEDENTE e
+      //  non guarda dove sta il prezzo ADESSO. Dopo un riempimento RETEST il Bid
+      //  e' sotto quel minimo: il server risponde [invalid stops], lo stop resta
+      //  quello vecchio e al tick dopo si rimanda la stessa richiesta (38 rifiuti
+      //  in 16,9 s). Qui si replica la regola del server PRIMA di inviare: le
+      //  modifiche che sarebbero passate partono identiche, le altre non partono.
+      double stopsDist = (double)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL) * _Point;
       if(type == POSITION_TYPE_BUY)
         {
          double newSL = TrailStopBuy(bid);
          if(newSL > 0 && newSL > sl && newSL > openP)
-            gTrade.PositionModify(ticket, NormalizePrice(newSL), tp);
+           {
+            if(bid - NormalizePrice(newSL) >= stopsDist)
+               gTrade.PositionModify(ticket, NormalizePrice(newSL), tp);
+            else
+               TrailRinvioLog(ticket, NormalizePrice(newSL), bid);
+           }
         }
       else if(type == POSITION_TYPE_SELL)
         {
          double newSL = TrailStopSell(ask);
          if(newSL > 0 && (newSL < sl || sl == 0) && newSL < openP)
-            gTrade.PositionModify(ticket, NormalizePrice(newSL), tp);
+           {
+            if(NormalizePrice(newSL) - ask >= stopsDist)
+               gTrade.PositionModify(ticket, NormalizePrice(newSL), tp);
+            else
+               TrailRinvioLog(ticket, NormalizePrice(newSL), ask);
+           }
         }
      }
   }
+
+//+------------------------------------------------------------------+
+//| Trailing rinviato (stop dal lato sbagliato del prezzo): UNA riga  |
+//| per ticket per candela, e nessuna richiesta al server.           |
+//+------------------------------------------------------------------+
+void TrailRinvioLog(ulong ticket, double newSL, double px)
+  {
+   static ulong    sTk  = 0;
+   static datetime sBar = 0;
+   datetime bar = iTime(_Symbol, InpTrailTF, 0);
+   if(ticket == sTk && bar == sBar) return;
+   sTk = ticket; sBar = bar;
+   ABTGLog(StringFormat("trailing rinviato: stop %.2f dal lato sbagliato del prezzo %.2f (ticket %I64u), nessuna richiesta al server.",
+                        newSL, px, ticket));
+  }
```

Scelte, e perche':
- **`FreezeLevel` lasciato fuori apposta**: riguarda lo stop ESISTENTE vicino al prezzo, non quello
  nuovo; metterlo nella stessa disuguaglianza bloccherebbe modify che il server accetta, e la parte
  A non sarebbe piu' neutra. Su FTMO vale 0 [MISURATO]; sui BCM [NON MISURATO].
- **Niente `input`**: la regola di casa vuole ogni comportamento nuovo dietro un input col default
  neutro. Qui il default "acceso" **e'** neutro sui risultati (le modify escluse sarebbero state
  rifiutate comunque). Se Claudio preferisce la lettera della regola, basta un
  `input bool InpGuardiaLatoStop = true;` in `&&` davanti al confronto.
- `StopsLevel` riletto a ogni tick: se il broker lo alza (news), la guardia lo segue.

### Parte B — cintura, facoltativa, NON neutra in live

Per rifiuti di **altra natura** (mercato chiuso, requote, "no changes"): contare i fallimenti di
`PositionModify` per ticket e per candela, e dopo 3 non riprovare fino alla candela dopo. In tester
non cambia niente se la parte A e' presente (gli unici rifiuti del tester su questo ramo sono gli
`invalid stops`) [INFERITO]; **in live puo' ritardare** di una candela un trailing che al quarto
tentativo sarebbe passato. Per questo e' separata: e' una scelta, non una riparazione.

### Cosa cambia nei backtest

- **Deal attesi IDENTICI** [INFERITO]: il tester applica la stessa regola del server e rifiuta le
  stesse modify, che non cambiano lo stato della posizione. Sparisce solo il rumore nel giornale del
  tester.
- **Il contro-esempio che lo romperebbe, e come si prova**: se il tester accettasse uno stop che la
  guardia esclude (per esempio `SL == Bid` con `StopsLevel=0`), la lista dei deal cambierebbe. La
  prova: `770101` sulla stessa finestra, "Ogni tick basato su tick reali", pin `9fca63d9` contro
  pin + parte A. **Lista dei deal uguale al centesimo e righe `invalid stops` da N a 0** = neutra.
  Deal diversi = la guardia non e' neutra e non si schiera. Tre condizioni perche' la prova valga:
  1. nella corsa del pin le righe `invalid stops` devono essere **N > 0**, con una finestra che
     contenga l'**11/09 e il 17/09**: altrimenti "deal uguali" non prova niente;
  2. su **tutti e tre** i file (`770101`, `770202`, `770260`);
  3. sul **PC di backtest**, non sul VPS.
- In campo cambia una cosa sola: le raffiche spariscono (da 38-101 richieste per episodio a 0, piu'
  1 riga di log per candela).

### Cosa serve per portarla in campo (tutto firma di Claudio)

Tre file (`770101`, `770202`, `770260`): **pin nuovo = `9fca63d9` + parte A**, ricopiato nei tre
**`CLAU12_*.mq5`** e ricompilato sul terminale FTMO **`541452707` (`C:\FTMO`)**, con la regola dei
terminali multipli e i due strati del cancello prima dell'invio. **Ricompilare gli `ABTG_*` li' non
tocca il binario attaccato.** La ricompilazione **ricarica l'EA**: si fa **senza posizioni aperte**
delle tre sedie, poi si verifica con `CODA_06` e con la riga "avviato" del giornale.

Fino ad allora il **rischio vivo misurato** = raffiche da **28-39 righe stampate** (<= 101 su FTMO),
**~5%** della soglia nel giorno visto. Il **caso peggiore teorico** la supera con **tre sedie al
ritmo medio** o con **una sola al ritmo massimo**; probabilita' **bassa** [INFERITO]; conseguenza
[NON VERIFICATO].

_Cancello: strato 1 OK; strato 2 FAIL (4+3) -> FAIL (solo r.179-182, `770260`) -> corretto col testo del cancello; **PASS** condizionato a questa sostituzione, dichiarato dal cancello stesso._
