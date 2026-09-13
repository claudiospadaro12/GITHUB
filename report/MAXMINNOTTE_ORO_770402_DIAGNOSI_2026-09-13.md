# 🌙 DIAGNOSI — `ABTG_MaxMinNotte` `770402` XAUUSD sul piccolo `50503392`

> **13/09/2026 · SOLA LETTURA.** Nessun EA toccato, nessun preset scritto, nessuna
> ricompilazione, nessun `CODA.txt`, nessun backtest. La macchina di backtest è ferma
> e **questo lavoro non la usa**.
>
> 🚫 **Non è una proposta di schieramento.** È la diagnosi che Claudio vede prima.
>
> 📌 Conto **DEMO** `50503392`: qui i P/L non sono sotto il vincolo del repo pubblico.
> Ho scritto lo stesso **solo prezzi, orari, lotti e ticket**, mai un saldo.

---

## 🎯 IN UNA RIGA

Il binario in campo è del **28/07** e gli mancano 5 commit. 🟢 **Il difetto annunciato —
`InpOneTradePerDay` non applicato — è MISURATO NON MORDERE: 9 operazioni, 9 giornate
distinte, ZERO giorni con due ingressi.** 🔴 **Ma cercando il contro-esempio ne è saltato
fuori uno più grosso e MAI CENSITO, con data e ticket**: l'8 settembre questa sedia è
rimasta aperta **2 ore e 19 minuti oltre la propria ora di chiusura**, perché un'altra
sedia sull'oro le ha accecato `PositionSelect`. 🔴 **E ricompilare a HEAD NON lo
risolve**, perché il difetto c'è anche a HEAD.

---

# A. 📌 DATAZIONE ESATTA DEL BINARIO IN CAMPO

**Il pin è `0823951` del 2026-07-28, ed è UNIVOCO** `[MISURATO]`.

| fonte | dato |
|---|---|
| cartella | `C:\Program Files\BCM Markets MT5 Terminal` (**piccolo `50503392`**) |
| sorgente in cartella | `ABTG_MaxMinNotte.mq5` **v1.10**, **540 righe**, `.ex5` compilato **2026-08-06 19:33** — `CODA_06_quale_codice_gira_20260910_033002.log` **r.81** |
| grafico | `chart29.chr`, XAUUSD, profilo `ORO`, `.chr` del 2026-09-06 22:55 — `CODA_08_preset_dai_chr_20260912_033002.log` **r.1669** |

Conteggi (`wc -l` + 1, taratura del runner):
```
a86089c 26/07 531 · 779e44d 27/07 532
0823951 28/07 540  v1.10   <-- IL BINARIO IN CAMPO  ✅ unico a combaciare
d4da7d7 06/08 553 · 3af47ed 08/08 567 · ec518d5 10/08 601 · 5fc0bc3 19/08 616
7d0da9f 03/09 919  v1.11   <-- HEAD
```

🟢 **E il contro-esempio sulla data torna al minuto.** L'`.ex5` è del **06/08 19:33 ora
VPS** = **17:33 UTC**; `d4da7d7` (la versione a 553 righe) è stato committato alle
**22:40:16 UTC** dello stesso giorno. La compilazione **precede di ~5 ore** il commit
successivo: è coerente che abbia compilato il sorgente del **28/07**.
👉 **Data di compilazione ≠ data del codice.** Qui differiscono di **9 giorni**.

**Commit mancanti: 5.**

---

# B. 🗂️ CLASSIFICAZIONE DEI 5 COMMIT MANCANTI — letti dal diff

| # | commit | data | classe | 🔴 morde al **default**? | 🔴 morde su **QUESTA sedia**? |
|---|---|---|---|---|---|
| 1 | `d4da7d7` | 06/08 | 🟠 **GESTIONE** | 🔴 **SÌ** | 🔴 **SÌ — su 9 trade su 9** (§B.1) |
| 2 | `3af47ed` | 08/08 | 🟠 **GESTIONE** | 🔴 **SÌ** | 🟢 **NO — smentito da una misura** (§C.2) |
| 3 | `ec518d5` | 10/08 | 🟡 DIAGNOSTICA | no | ❌ no (`ExportTrades`) |
| 4 | `5fc0bc3` | 19/08 | 🔴 SEGNALE | no | 🟢 **NO — il Guardian non gira sul piccolo** (§C.3) |
| 5 | `7d0da9f` | 03/09 | 🔴 **SEGNALE** | 🔴 **SÌ** | 🟢 **NO in campo — smentito da 9 giornate** (§C.1) |

### Il preset in campo, che serve per leggere tutto il resto
`CODA_08…log` r.1673-1723 (ricopiato in `mql5/Presets/sedie_piccolo/sedia_MAXMIN_ORO_770402.set`):
```
InpBoxStartHour=23  InpBoxEndHour=4:59      (box notturno, ora SERVER)
InpPlaceHour=7:00   InpEntryCutoffHour=8:30  InpPendingExpiryMin=90
InpCloseHour=17:30  InpCloseAtEnd=true
InpOneTradePerDay=true        <-- il preset LO CHIEDE
InpSLMode=0                   <-- = MM_SL_OPPOSITE: lo SL e' l'ESTREMO OPPOSTO DEL BOX
InpBufferPoints=250           InpAllowLong=true  InpAllowShort=true
InpTP1_R=1.0  InpTP1Pct=50    InpBreakeven=true
InpUseTrailing=true  InpTrailAtrMult=2.0  InpMgmtTF=16386 (= PERIOD_H2, non M15)
InpRiskPercent=0.5            InpUseCorrelation=false  InpUseNewsFilter=false
```
⚠️ Da segnare: `InpSLMode=0` è **`MM_SL_OPPOSITE`** (`enum ENUM_MM_SL { MM_SL_OPPOSITE=0,
MM_SL_ATR=1, MM_SL_FIXED=2 }`, r.31), **non** ATR. E `InpMgmtTF=16386` è **H2**, mentre
il default dichiarato nel commento è M15.

## 1️⃣ 🔴 `d4da7d7` — il BREAKEVEN annidato nella parziale. **Morde su 9 trade su 9**

Binario in campo, **r.300-303**:
```
double cv=NormVol(vol*InpTP1Pct/100.0);
if(cv>0 && cv<vol && gTrade.PositionClosePartial(ticket,cv))
  { gPart1=true; if(InpBreakeven) gTrade.PositionModify(_Symbol,NormalizePrice(openP),tp);
    Log("1o target (1R): parziale + stop in pari."); }
```
🔴 **Lo stop in pari è DENTRO la condizione della parziale.** Se la parziale non parte,
il breakeven **non viene nemmeno tentato**.

E `NormVol`, **r.416-423** del binario in campo:
```
v = MathFloor(v/st)*st;
return(v<mn ? 0 : v);
```
Con `vol=0.01`, `st=0.01`, `mn=0.01`: `NormVol(0.01·50%) = NormVol(0.005) = MathFloor(0.5)·0.01 = 0`
→ `cv=0` → `cv>0` **falso** → **niente parziale E niente breakeven**.

### 📏 E qui non è teoria: è misurato su ogni singolo trade
`data/statements/trades_auto.csv`, `magic=770402` — **9 operazioni, 11/08 → 08/09/2026**:

| | |
|---|---:|
| operazioni | **9** |
| 🔴 **operazioni al lotto 0,01 (il minimo)** | **9 su 9 — il 100%** |
| parziali eseguite | **0** (nessun volume ≠ 0,01) |

👉 **La condizione che disarma il breakeven si è verificata su OGNI trade della sedia.**

🎯 **E il commit lo aveva PREVISTO ALLA LETTERA.** Il commento che `d4da7d7` inserisce
(`mql5/Experts/ABTG_MaxMinNotte.mq5:418-421` a HEAD) dice:
> *"Al lotto minimo `NormVol(vol*%)` arrotonda a 0: il parziale non parte, e con lui
> saltava anche il breakeven. Stessa correzione già fatta il 04/08 sugli EMA200, dove era
> **costata −112,78 EUR su due short oro a 0,01 lotti**."*

**Stesso EA-pattern, stesso simbolo, stesso lotto, stesso difetto — e questa sedia lo
porta ancora addosso da 38 giorni.**

### ⚖️ Quanto è costato qui? **Si può LIMITARE, non misurare**
Delle 9 operazioni, **2 sono uscite a `sl`**. Ricavando R dalla chiusura (per uno short
uscito a SL, `R = close − open`):

| data | lato | R (USD/oz) | ingresso | il +1R sarebbe stato | estremo a favore entro le 23:59 ⚠️ |
|---|---|---:|---:|---:|---:|
| 28/08 | sell | 40,64 | 4572,62 | 4531,98 | 4445,42 |
| 04/09 | sell | 25,23 | 4464,48 | 4439,25 | 4365,59 |

⚠️ **`session_high/low` NON sono MFE/MAE**: sono max/min su M5 **dall'ingresso fino alle
23:59 dello stesso giorno**, quindi **includono ciò che è successo DOPO la chiusura**
(`report/STOP_VERO_770101_2026-09-11.md` r.35). Sono un **limite superiore**.

👉 Il test è quindi solo **necessario, non sufficiente**: in tutte e due le giornate il
+1R **è stato toccato**, ma **`[NON MISURATO]` se PRIMA o DOPO lo SL**. Verdetto onesto:

> **limite superiore del danno di `d4da7d7` nella finestra osservata: 2 perdite piene su 9
> trade** (≈ −2R). Il valore vero sta fra 0 e 2, **e da qui non si stringe.**

🧐 **E il contro-esempio contrario, che va detto**: il breakeven **non è gratis** — può
anche tappare vincenti. Sulle 7 uscite `expert` non so quante avrebbero toccato +1R e poi
fatto retromarcia. **Il segno NETTO di `d4da7d7` su questa sedia è `[NON MISURATO]`, e
solo il tester può darlo.**

🧐 **Secondo contro-esempio, e morde a metà**: il **trailing** è acceso e fa
breakeven-o-meglio da solo, r.333-340 — per un long `if(n>sl && n>openP)` con
`n = bid − 2·ATR(H2)`, cioè si arma solo oltre `openP + 2·ATR(H2)`. Quindi copre
**parte** della stessa funzione. Se `2·ATR(H2)` sia sopra o sotto **1R** (= larghezza del
box + 5,00 USD/oz di buffer) **dipende dalla giornata e da qui è `[NON MISURATO]`**: non
posso dire quanto della protezione sia già data dal trailing.

## 2️⃣ `3af47ed` — lotto da `OrderCalcProfit`. **Vedi §C.2: smentito da una misura**

## 5️⃣ `7d0da9f` — `InpOneTradePerDay` applicato davvero. **Vedi §C.1**

---

# C. 🧪 IL CONTRO-ESEMPIO — costruito PRIMA del verdetto. **Ha retto TRE volte su quattro, e alla quarta ha trovato di peggio**

## 🟢 C.1 — «`InpOneTradePerDay` non applicato → può fare più di un trade al giorno». ❌ **La tesi CADE: nei fatti ne fa uno solo**

### Prima la domanda che Claudio ha posto: **quante operazioni al giorno può fare, esattamente?**
Ho seguito la macchina a stati del binario in campo, riga per riga.

**Il percorso normale, e si chiude da solo in TRE punti:**
1. **r.144-145 `OnTick`**: `ManagePos(); HandleOCO();`
2. **r.343**: `void HandleOCO(){ if(SelPos()) CancelPendings(); }` → 🟢 **l'OCO ESISTE ed è
   chiamato a ogni tick**: appena una posizione è aperta, il pendente opposto **muore**.
   Una straddle non può quindi produrre due posizioni.
3. **r.174-177**: `if(gPhase==MMP_WAIT && nowMin>=InpPlaceHour…) if(TryPlace()) gPhase=MMP_PLACED;`
   e `ResetDay()` (r.181) rimette `gPhase=MMP_WAIT` **solo al cambio di giornata**
   (r.148). 👉 **`TryPlace()` non può girare due volte nello stesso giorno.**
4. I pendenti nascono con `ORDER_TIME_SPECIFIED` a `TimeCurrent()+90 min` (r.~215) e il
   **cutoff** delle 08:30 (r.158-164) li cancella comunque.

> ### 🟢 **Conclusione: nel percorso normale il binario del 28/07 fa GIÀ un solo ingresso al giorno.** `InpOneTradePerDay` era una manopola inerte su un comportamento che **l'OCO + la macchina a stati già imponevano**.

### E la misura lo conferma, su operazioni vere
`data/statements/trades_auto.csv`, `magic=770402`:

| | |
|---|---:|
| operazioni | **9** |
| **giornate distinte con un ingresso** | **9** |
| 🟢 **giornate con PIÙ di un ingresso** | **0** |
| ora di apertura | **sempre fra 07:00 e 07:35 server** (mai una seconda finestra) |

> 🟢 **ZERO doppioni in 29 giorni di campo.** ✅ **IL CONTRO-ESEMPIO REGGE: `7d0da9f`
> NON è un'emergenza su questa sedia.**

### 🔎 Ma la porta esiste: **due sole**, e sono entrambe strette
- **Porta 1 — l'OCO fallisce** se `SelPos()` è accecato da un vicino sull'oro (§C.4).
  **Misurato: 1 giornata su 9.** Quel giorno il BUY STOP opposto è rimasto vivo dalle
  07:19 fino al cutoff delle 08:30 — **~71 minuti di finestra**. 🟢 **Non è entrato niente.**
- **Porta 2 — riavvio del terminale a giornata iniziata**: `gPhase` è una variabile globale
  e riparte da `MMP_WAIT`. La guardia anti-duplicato (r.166-173) è **hedge-safe** (scorre
  `OrdersTotal()`/`PositionsTotal()` filtrando **simbolo + magic**, non usa
  `PositionSelect`), ma **a trade già chiuso e pendenti già spariti non vede niente** →
  `TryPlace()` riparte. 🟢 **Mitigazione misurata dal codice stesso**: fuori dalla finestra
  07:00-08:30 il cutoff (r.158) uccide i nuovi pendenti **al tick successivo**. La finestra
  pericolosa vera è **un riavvio fra le 07:00 e le 08:30 a trade del giorno già chiuso**.
  Quante volte si riavvia quel terminale: **`[NON MISURATO]`**.

## 🟢 C.2 — «`3af47ed` (lotto da `OrderCalcProfit`) morde sull'oro». ❌ **La tesi CADE, e la prova è un caso di controllo vero**

Il commit stesso dichiara il proprio perimetro
(`git show 3af47ed:mql5/Experts/ABTG_MaxMinNotte.mq5` r.416-421):
> *"Su 225JPY il tick value arriva non convertito… **Sui simboli sani i due calcoli
> coincidono: il comportamento cambia SOLO dove il tick value mente.**"*

**Il caso di controllo**: sul **piccolo**, la sedia `772343` (`ABTG_PunteLarry` XAUUSD)
gira il pin **`cb7dc20` del 13/08**, che è **posteriore** a `3af47ed` (08/08) — e
**contiene già** il calcolo nuovo `[MISURATO]`: `git show cb7dc20:mql5/Experts/ABTG_PunteLarry.mq5`
**r.1000-1004** ha `OrderCalcProfit` in `LotByRisk`.

**Se `3af47ed` sollevasse l'oro dal lotto minimo, `772343` dovrebbe avere lotti diversi da
`770402`. Non li ha.**

| magic | EA | ha `3af47ed`? | n | volumi osservati |
|---|---|---|---:|---|
| `770402` | MaxMinNotte | ❌ no | 9 | **0,01** |
| `772343` | PunteLarry | ✅ **sì** | 2 | **0,01** |
| `971501` | EMA200_Ott | ❌ no | 9 | **0,01** |
| `970901` · `770901` · `771001` · `771301` · `771501` | vari | misto | 12 | **0,01** |
| `20260001` | (non una sedia ABTG in campo) | — | 3 | **0,01** |

👉 **35 operazioni XAUUSD su 37 della flotta sono a 0,01**, con e senza il fix. Le uniche
due eccezioni (0,03 e 0,11) sono `250604`, un EA **di terze parti su Tickmill**, fuori flotta.

🟢 **E il controllo che chiude il cerchio: il motore del lotto NON è rotto in generale.**
Sugli altri simboli della stessa flotta i volumi sono vivi e variabili — `D30EUR` 0,10-…,
`U30USD` 0,10-…, `CADJPY` 0,37-0,60, `AUDNZD` 0,13-0,72, **`225JPY` 0,50-2,30**. Se il
problema fosse il calcolo, si vedrebbe **ovunque**. Si vede **solo sull'oro**.

> ✅ **CONTRO-ESEMPIO REGGE: `3af47ed` su questa sedia è verosimilmente un NO-OP.**
> ⚠️ **Riserva dichiarata**: non ho letto `SYMBOL_TRADE_TICK_VALUE` di XAUUSD sul feed BCM
> — **`[NON MISURATO]`**. La prova è **per confronto fra due sedie sullo stesso simbolo e
> sullo stesso terminale**, che è forte ma indiretta.

### 🔴 E allora **perché** l'oro sta al minimo? Ed è una cosa che va scritta
`LotByRisk`, **r.413** del binario in campo:
```
return(MathMax(mn,MathMin(mx,lot)));     // <-- PAVIMENTO al lotto minimo
```
👉 **Il lotto viene ALZATO al minimo, non rifiutato.** Quindi `InpRiskPercent=0.5` **non è
una garanzia**: è un obiettivo che il codice abbandona in silenzio quando il lotto-di-rischio
scende sotto `SYMBOL_VOLUME_MIN`. Sull'oro (contratto 100 oz, SL misurati **25-41 USD/oz** =
**2.523-4.064 USD per lotto**), `MathFloor(lot/0.01)*0.01 = 0.01` significa che il
lotto-di-rischio era **sotto 0,02** su tutte e 9 le operazioni.
🎯 **È esattamente la lezione di `EMA200` citata nel mandato: *"un rischio che il codice non
garantiva"*.** 🟢 Sul piccolo il verso è **prudente** (si rischia MENO del dichiarato); su un
conto prop da 100k il pavimento **non morderebbe** e il lotto tornerebbe al rischio vero.
📌 **Questo difetto è presente ANCHE a HEAD** (`mql5/Experts/ABTG_MaxMinNotte.mq5`, stessa
riga di ritorno): **non si ripara ricompilando.**

## 🟢 C.3 — «manca il cancello del Guardian (`5fc0bc3`)». ❌ **CADE**

Sul piccolo `50503392` **il Guardian non gira** `[MISURATO]`:
`CODA_09_giornale_operativo_20260912_033002.log` r.73 e r.79 (blocco
`C:\Program Files\BCM Markets MT5 Terminal`, 11 e 12/09): *"GUARDIAN: nessuna riga in
questo giorno."* E in `CODA_08` **nessun `.chr` del piccolo monta `ABTG_Guardian`**.
Il cancello è **fail-open totale** quando le GlobalVariable non esistono.
👉 **Ricompilare non cambierebbe un solo ingresso.** Il 🔴 di questa riga è **formale**,
come per le altre 32 sedie del piccolo (censimento 13/09 §3-bis).

## 🔴 C.4 — IL QUARTO CONTRO-ESEMPIO **HA TROVATO DI PEGGIO**: un incidente vero, con data e ticket

Cercando **perché** l'OCO potesse fallire, sono arrivato a `SelPos()`, **r.427** del
binario in campo — **e identico a HEAD, r.772**:
```
bool SelPos(){ if(!PositionSelect(_Symbol)) return(false); return(PositionGetInteger(POSITION_MAGIC)==InpMagic); }
```
🔴 `PositionSelect(_Symbol)` su conto **HEDGING** seleziona **il ticket più basso** del
simbolo. Se il vicino ha il ticket più basso, `SelPos()` torna **false** e allora, in un
colpo solo:

| funzione | riga (in campo) | cosa smette di funzionare |
|---|---|---|
| `ManagePos()` | r.279 `if(!SelPos()) return;` | 🔴 niente parziale, niente breakeven, niente target EMA200, **niente trailing** |
| `HandleOCO()` | r.343 | 🔴 il pendente opposto **non viene cancellato** |
| `EndOfDay()` | r.360 `if(InpCloseAtEnd && SelPos())` | 🔴 **la posizione NON viene chiusa a fine finestra** |

### 📸 E l'8 settembre 2026 è successo. Qui sotto ci sono i ticket.
```
pid 3328278  magic 772343 (PunteLarry oro)  BUY  0.01   08/09 02:23:31 -> 08/09 19:48:57  (sl)
pid 3330293  magic 770402 (MaxMinNotte)     SELL 0.01   08/09 07:19:13 -> 08/09 19:48:57  (expert)
```
Il vicino ha il **ticket più basso** (3328278 < 3330293) ed era **già aperto** quando
`770402` è entrata. Quindi, dalle 07:19 alle 19:48, `PositionSelect("XAUUSD")` selezionava
**la posizione del vicino** e `SelPos()` tornava **false**.

🔴 **`EndOfDay()` alle 17:30 non ha chiuso niente.** E la posizione si è chiusa
**alle 19:48:57 — lo STESSO SECONDO in cui il vicino è morto a SL**: appena il ticket basso
è sparito, `PositionSelect` ha finalmente selezionato la nostra, `SelPos()` è tornato vero,
e `EndOfDay()` (già oltre le 17:30) l'ha chiusa con `close_reason=expert`.

**La firma è nei dati, e non è interpretabile in altro modo:**

| giornata | chiusura `expert` |
|---|---|
| 11/08 · 13/08 · 24/08 · 26/08 · 07/09 | **17:30:00 esatte** ×5 |
| 03/09 | 09:03:54 (target EMA200, r.319-324 — uscita prevista) |
| 🔴 **08/09** | **19:48:57** — **+2h 18m 57s oltre la propria ora di flat** |

> ### 🔴 **Una sedia rimasta sul mercato 2h19m oltre il proprio orario, senza gestione, senza trailing, e nessuno se n'era accorto.**

**Frequenza misurata:** `770402` ha avuto un vicino XAUUSD vivo all'ingresso in
**1 giornata su 9**; in quella giornata il ticket del vicino era **più basso**, quindi
**1 su 1** delle compresenze ha prodotto l'accecamento. (Nel file ci sono **513** posizioni
XAUUSD di altri magic: la compresenza non è un'ipotesi di laboratorio.)

### 🔴 E LA COSA CHE CAMBIA LA PRIORITÀ: **ricompilare NON lo risolve**
Il changelog di `7d0da9f` lo dichiara, testuale:
> *"ATTENZIONE, QUELLO CHE QUESTO FIX NON FA. **NON tocca `SelPos()`**, che resta il
> `PositionSelect(_Symbol)` cieco di sempre, né `ManagePos()`/`EndOfDay()` che ci si
> appoggiano: quello è il difetto **C9**…"*

E lo confermo a HEAD `[MISURATO]`: `mql5/Experts/ABTG_MaxMinNotte.mq5` **r.772** (`SelPos`
invariato), **r.490** (`EndOfDay` ancora dietro `SelPos()`), **r.473** (`HandleOCO` idem).

> ✅ **Il contro-esempio REGGE alla grande, ma nel verso opposto a quello sperato**:
> **il difetto che è costato un fatto misurabile in campo NON è fra i 5 commit mancanti.**
> **Aggiornare questa sedia non la mette in sicurezza.**

---

# D. ⚖️ VERDETTO SU QUESTA SEDIA

| difetto | classe | stato |
|---|---|---|
| `InpOneTradePerDay` inerte (`7d0da9f`) | SEGNALE | 🟢 **non morde** — 0 doppioni su 9 giornate. Due porte strette, una misurata aperta 71 min senza conseguenze |
| Breakeven annidato nella parziale (`d4da7d7`) | GESTIONE | 🔴 **morde su 9 trade su 9**. Danno ≤ 2 perdite piene su 9, **segno netto `[NON MISURATO]`** |
| Lotto da `OrderCalcProfit` (`3af47ed`) | GESTIONE | 🟢 **verosimile no-op sull'oro** — caso di controllo `772343` |
| Cancello Guardian (`5fc0bc3`) | SEGNALE | 🟢 **formale**: il Guardian non gira sul piccolo |
| `ExportTrades` (`ec518d5`) | DIAGNOSTICA | ⚪ nessun effetto sul trading |
| 🔴 **`SelPos()` cieco (C9)** | **SEGNALE + GESTIONE** | 🔴 **manifestato in campo l'08/09** · **presente ANCHE a HEAD** · **NON è un commit mancante** |

> ## 🟠 **Urgenza dell'AGGIORNAMENTO: BASSA-MEDIA.** Su 5 commit mancanti, **uno solo morde** (`d4da7d7`), e il suo segno netto non è misurato.
> ## 🔴 **Urgenza del DIFETTO C9: ALTA — ma è un lavoro DIVERSO**, perché nessuna ricompilazione lo tocca.

📊 **Il confronto di priorità con l'altra sedia** (`779001` Guardian sul 100k) sta in
`report/GUARDIAN_100K_779001_DIAGNOSI_2026-09-13.md` **§E**. In breve: **prima il
Guardian**, perché lì l'aggiornamento ripara la cosa peggiore che la sedia ha, mentre
qui **0 dei 5 commit mancanti** tocca il difetto che ha prodotto l'unico danno misurato.

---

## 📌 DICHIARAZIONE DI ONESTÀ

- **Ponteggio, non sedia.** Nessun PF nuovo, nessuna sedia più vicina al 1° ottobre.
  🟢 **Però un fatto nuovo sì**: un incidente reale, datato e ricostruito, che nessun
  referto del progetto aveva censito.
- 🔴 **`[NON MISURATO]`, elencati per nome**: (1) se il +1R sia arrivato **prima** dello SL
  nelle due giornate perse; (2) il **segno netto** di `d4da7d7` (il breakeven taglia anche
  vincenti); (3) quanto della sua funzione sia già coperto dal **trailing** (dipende da
  `2·ATR(H2)` contro 1R); (4) il **tick value** di XAUUSD sul feed BCM; (5) la **frequenza
  di riavvio** del terminale del piccolo.
- ⚠️ **Campione sottile, dichiarato**: **9 operazioni in 29 giorni**. Basta a dire *"non fa
  doppioni"* e *"il lotto è sempre al minimo"*; **non** basta per un PF né per un DD.
- 🧐 **Un difetto che ho visto ma NON ho approfondito** (non è un commit mancante, vale per
  tutte e due le versioni): in `ManagePos` r.290 `risk` si ricalcola dallo **SL corrente**,
  che il trailing sposta — quindi il bersaglio del TP1 **si muove** mentre la posizione
  corre. Lo segnalo, non lo quantifico.
- **Non ho letto nessun `.ex5`.** `[LIMITE DICHIARATO]`, come nel censimento del 13/09.

_Fonti: `backtest_pipeline/coda/referti/CODA_06_quale_codice_gira_20260910_033002.log` ·
`CODA_08_preset_dai_chr_20260912_033002.log` · `CODA_09_giornale_operativo_20260912_033002.log` ·
`data/statements/trades_auto.csv` · `git log`/`git show`/`git diff` del branch `lavoro` a HEAD._
