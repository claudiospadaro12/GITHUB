# 🔦 I QUATTRO INVISIBILI — quattro EA scritti fra il 22/08 e l'08/09, **mai girati nemmeno una volta**. Adesso hanno un file prova, una riga di registro e un numero.

**12/09/2026 (sabato), ~19:00 UTC.** Alla challenge restano **~19 giorni**, di cui **13 giornate di borsa**.
Referto di **sola lettura di sorgente + lettura d'archivio**.
🛑 **Nessun backtest eseguito. `CODA.txt` NON toccata (39 righe). Nessun `.mq5`, preset, magic o sedia
in forward toccati. `walkforward_generico.ps1` e `RIGA_SOTTILE_ROUND.ps1` non sfiorati.**
Taglie, rischio e accensioni restano **firma di Claudio**.

> 🚦 **CANCELLO: primo strato VERDE, secondo strato DA LANCIARE.** I cinque file prova passano
> `controlla_prova.py` (**OK 5/5, 0 problemi, 14 celle**) e `controlla_riga.py --oggetto prova`
> (**EXIT 0, 5 su 5**), e sono **ASCII puro** (0 byte >127, contati con `python3` — 🔴 **mai con
> `grep '[^\x00-\x7F]'`, che senza `-P` e' rotta**).
> 🔴 **L'agente `controllo-preventivo` NON l'ho potuto invocare io: lo lancia il coordinatore.**
> Finche' non torna, niente di questo referto va verso il VPS. **Dichiarato, non aggirato.**

---

# 0. 🥇 LA RISPOSTA IN SEI RIGHE

1. 🔴 **Il fatto e' vero e peggiore di come sembrava.** I quattro EA non hanno **nessuna** riga di
   registro, **nessun** CSV, **nessun** round in coda. Ma due dei quattro **avevano un file prova, e
   NESSUNO DEI DUE ERA LANCIABILE COME SCRITTO** — e uno dei due difetti e' di **aritmetica**, non di
   forma.
2. 🚨 **`prove/ABTG_HVAncora_00_conta.txt` (08/09) dichiara "50-200 OPERAZIONI" e l'EA ne avrebbe
   rifiutate il 100%.** Il motore porta il cancello di costo **dentro di se'** (r.239
   `InpMaxSpreadPctOfStop = 2.5` = *`stop >= 40 x spread`*; r.935 salta il trade) e con
   `InpStopAtr = 1,0` su U30USD M30 lo spread **MISURATO** e' il **4,41%** (ore 14-20) e il **5,73%**
   (ore 08-13) dello stop, contro una soglia del **2,50%**. 👉 **Attesa NON RAGGIUNGIBILE, classe
   278** — e uno zero letto come *"niente segnali"* avrebbe **sepolto un motore mai interrogato**.
   🟢 Il buco **#4** di `LA_BANDA_BASSA` (*"cancello VERDE, serve solo metterlo in coda"*) **va
   corretto**, e la correzione e' gia' in `REGISTRO_TEST.md`.
3. 🚨 **`prove/ABTG_DaxValueArea.txt` (30/08) ha QUATTRO difetti bloccanti**, fra cui uno che e' un
   **punto cieco del cancello**: le direttive sono scritte `# @SIMBOLO  D30EUR`, il driver salta le
   righe con `#` **prima** di guardare la `@` (`walkforward_generico.ps1` r.495-501) e **muore** su
   r.737 — ma `controlla_prova.py` cerca la **sottostringa** `"@DAQUANDO"` e **la trova dentro il
   commento**. Il cancello certificava la finestra presente mentre il driver non l'avrebbe vista.
4. 🧩 **L'ANCORA UNICA divide i quattro esattamente in due**, e si legge nel sorgente:
   🟢 **SI** per `AtrExhaustVol` (r.649 `tp = entry + R*InpTP_RR`, con `R` = lo stop) e per `HVAncora`
   (r.945 `tp = entry + InpRR*slDist`) · 🔴 **NO** per `DaxValueArea` (stop da una **barra** + buffer
   **fisso**, target dalla **larghezza della Value Area**) e per `IntradayMomentum` (stop da
   `ATR(M30)`, uscita dalla **campanella**).
5. 🔧 **Una MANOPOLA INERTE trovata leggendo, prima di spendere una notte**: in `AtrExhaustVol`
   r.557-561 la tolleranza di prossimita' del **modo dell'autore** e' lo **0,5% del prezzo del
   pivot** = **145,0 punti indice** su NASUSD a 29.001 (prezzo mediano **MISURATO**) = **3,2 RANGE DI
   BARRA M30**. 👉 **Una delle tre condizioni COSTITUTIVE del motore non filtra niente.** L'asse di
   `R141c` **e' proprio quella manopola.**
6. 🎯 **E la cosa che decide l'ordine non e' il timeframe: e' il CAMPIONE.**
   `ABTG_IntradayMomentum` fa **1,00 operazione al giorno per costruzione** e nella finestra dei tick
   BCM ci sono **~443 sedute**: **IS ~160-180, OOS ~240-270**, cioe' 🟢 **l'unico dei quattro che
   arriva a `n >= 150` in TUTTE E DUE le finestre.** 🔴 **Ma il suo pedaggio MISURATO e' 3,40 punti
   indice andata-e-ritorno e, col success rate DEL PAPER, l'edge atteso e' 1,98-3,96: sta SUL FILO.**

---

# 1. 📋 I QUATTRO, UNO PER UNO

## 1.1 🥇 `ABTG_IntradayMomentum` — 22/08/2026 · **1.009 righe** · **21 giorni fermo**

**Il motore in cinque righe** (letto nel sorgente, non nel titolo):
1. `r1` = rendimento della **prima mezz'ora di cassa USA**, 14:30-15:00 **ORA SERVER BCM**, misurato
   su barre `PERIOD_M1` (r.494).
2. Con `InpUseOvernightInR1 = true` (**definizione del paper**) dentro `r1` c'e' anche il **gap
   notturno**: si parte dalla chiusura di cassa di ieri (r.113-114).
3. All'inizio dell'**ultima mezz'ora** (20:30 SERVER) si apre **nel verso di `r1`**. Soglia
   `InpMinAbsR1Pct = 0` = si opera **sempre**: conta il **segno**.
4. Si chiude entro la chiusura di cassa, **21:00 SERVER**. Sempre. **Zero overnight per
   costruzione**: non esiste un input per spegnerlo.
5. Esposizione: **trenta minuti al giorno. Una operazione al giorno.**

| | |
|---|---|
| **ANCORA UNICA** | 🔴 **NO** — stop `2,0 x ATR(InpAtrTF = M30)` (r.157-160, `InpAtrTF` e' un input **SEPARATO** dal grafico) · uscita = **la CAMPANELLA** (r.136-137 `InpExitHour = 21`, `InpExitMin = 0`). **Due ancore diverse: un ATR e un orologio.** |
| **BARRE o CALENDARIO** | 🔴 **CALENDARIO al 100%.** Il sorgente lo dice a parole sue, r.57-60: *"IL TF DEL GRAFICO NON CONTA: le misure si fanno su barre M1"*. 👉 **Guadagno di frequenza scendendo di TF: 0,00 op/giorno, MISURATO DAL CODICE.** |
| **PF · n · DD** | **[NON MISURATO]** tutti e tre. Zero CSV, zero righe di registro. |

### 🔴 Ma «calendario» qui **non e' un difetto**, ed e' il punto che ribalta la classifica
Questo motore **non chiede di scendere di TF**: fa **1 op/giorno** di per se', e su tre indici fa
**3 op/giorno di FAMIGLIA** = **tre volte** il pavimento firmato il 07/09.
🎯 **Ed e' M30 in un senso che nessun altro nostro motore e': la POSIZIONE dura trenta minuti.**
Il grafico e' un dettaglio.

### 📐 La frontiera del costo, e qui **il cancello di casa e' COSMETICO** (per la mia stessa regola)
`stop/spread` si calcola perche' e' il cancello di casa, ma su un motore ad ancore diverse **non
misura niente**. Lo scrivo e poi calcolo quello che decide.

| | NASUSD | U30USD |
|---|---:|---:|
| range giornaliero **MISURATO** (n=24 giorni, `ROUND_ORB_ATR_PS5` r.233-234) | **313,8** idx | **314,5** idx |
| `ATR(M30)` [DERIVATO] `x sqrt(30/1440)` | 45,3 | 45,4 |
| stop = `2,0 x ATR(M30)` | 90,6 | 90,8 |
| spread ora 20 **MISURATO** (mediana) | **1,70** (11.182.176 tick) | **1,90** (5.311.323 tick) |
| **`stop/spread`** | 🟢 **53,3x** | 🟢 **47,8x** |
| al p95 dello spread | 🟢 50,3x (1,80) | 🟢 45,4x (2,00) |

🔴 **E LA FRONTIERA E' UNA DISTRIBUZIONE, non una mediana** — ed e' questo il numero che **ordina i
due gemelli**:

| simbolo | range giornaliero **p25** (MIS) | `ATR(M30)` al p25 [DER] | stop | **`stop/spread` al p25** |
|---|---:|---:|---:|---:|
| **NASUSD** | **239,4** | 34,6 | 69,1 | 🟢 **40,6x — passa ANCORA il 40x** |
| **U30USD** | **172,0** | 24,8 | 49,7 | 🟡 **26,1x — sopra il duro 13,3x, sotto il 40x** |
| D30EUR | 146,0 | 21,1 | 42,2 | 🟡 **24,8x** |

> 🎯 **NASUSD e' l'unico dei tre indici dove anche il giorno al 25esimo percentile sta sopra il
> pavimento di lavoro.** E' **l'unico numero** che mette NASUSD primo e U30USD secondo.
> 🔴 **Frazione delle operazioni sotto il 40x su U30USD: almeno il 25%** [DERIVATO dal p25 del range].
> **Sotto il pavimento DURO 13,3x: [NON MISURATO]** — servirebbe un giorno **1,7 volte piu' quieto
> del p25**. Non lo invento.

### 💰 Il cancello che **decide davvero**: edge contro costo
Pedaggio all-in sugli indici = **spread e basta** (commissione **0,0000 MISURATA**, n=302 deal,
`CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.181-183).

```
costo ANDATA + RITORNO su NASUSD = 1,70 (ora 20) + 1,70 (ora 21) = 3,40 punti indice   MISURATO
movimento della mezz'ora finale: range 30' [DERIVATO] 45,3 idx
   il movimento medio ASSOLUTO e' una FRAZIONE del range, e la frazione e' [NON MISURATA]:
   la dichiaro come BANDA 0,5 - 1,0 del range  =  22,7 - 45,3 punti indice

col success rate DEL PAPER (54,37%, solo r1)   [DICHIARATO NEL PAPER, NON MISURATO DA NOI]
   edge = (2 x 0,5437 - 1) x [22,7..45,3] = 1,98 - 3,96 punti indice
   edge / costo = 0,58 - 1,16          <-- SUL FILO, e la meta' bassa e' in PERDITA

col doppio predittore (77,05% dichiarato dal paper)
   edge = 0,541 x [22,7..45,3] = 12,3 - 24,5 punti indice
   edge / costo = 3,6 - 7,2            <-- ha margine
```

> ## 🎯 **ED E' ESATTAMENTE PERCHE' L'ASSE DEL ROUND E' `InpUseSecondSignal`.** Non e' una taratura: e' **l'unica cosa che in aritmetica separa un motore che paga il pedaggio da uno che non lo paga.**

🔴 **CONTRADDIZIONE CHE NON RIESCO A SCIOGLIERE, E CHE DICHIARO:** il paper da' al doppio predittore
un rendimento **annuo piu' basso** (2,10% contro 6,67%) con un **edge per operazione 6,2 volte piu'
grande**. Le due cose insieme implicano un numero di operazioni che non riesco a ricostruire
(sarebbe ~5% dei giorni). Quindi **il numero di operazioni della cella `r12` e' `[NON MISURATO]`** e
lo misura la corsa. **Non lo indovino.**

---

## 1.2 🥈 `ABTG_AtrExhaustVol` — 25/08/2026 · **1.142 righe** · **18 giorni fermo**

**Il motore in cinque righe:**
1. **PIVOT** confermato a (5,5) barre. La barra candidata e' la `[1+InpPivotRight]`: nessuna barra in
   formazione entra nel calcolo -> **niente ridipintura, per costruzione** (r.523-528).
2. **PROSSIMITA'**: il minimo (long) della barra di segnale dentro una tolleranza dal pivot basso.
3. **ESAURIMENTO**: la strada percorsa **dal pivot OPPOSTO** supera `2,0 x ATR(14)`.
4. **VOLUME**: volume della barra di segnale `> 1,5 x` la media a 20 barre. **E' COSTITUTIVO**:
   nessun input lo spegne, e a dati mancanti il segnale **non passa** (r.488).
5. Piu' un grilletto di price action. Decide **solo a barra chiusa**.

| | |
|---|---|
| **ANCORA UNICA** | 🟢 **SI** — stop `MathMin(gLastPL, l1) - InpSLBufferPts*_Point` (r.500 long, r.514 short) · `tp = entry + R*InpTP_RR` (**r.649**) dove `R = distSL`, cioe' **LO STOP STESSO** (r.638-645). **Il target e' espresso in unita' dello stop**, come `ABTG_DAX_Apertura_EU` r.1070. |
| **BARRE o CALENDARIO** | 🟢 **BARRE PIENE — CLASSE S.** Pivot (5,5) **del grafico**, `ATR(14)` **del grafico**, media volume su 20 **barre del grafico**, stop = estremo di una **barra del grafico**. Nessun `InpOneTradePerDay`, nessun box notturno, nessuna candela D1, nessun gap, nessun pip fisso. |
| **PF · n · DD** | **[NON MISURATO]** tutti e tre. |

> ## 🟢 **E' L'UNICO DEI QUATTRO A CUI LA DOMANDA DI CLAUDIO SI APPLICA ALLA LETTERA.** Scendendo di TF **lo stop si stringe E i segnali crescono** (atteso **x1,97** per gradino, mediana **MISURATA** su 58 serie, `LA_BANDA_BASSA` par. 2.2). Ed e' l'unico su cui la frontiera del costo **si compra senza pagare edge**, perche' l'ancora e' unica.

### 📐 La frontiera del costo, **per timeframe, col numero**
Spread NASUSD **MISURATO** su 156.146.398 tick. Nella banda 14-20 SERVER: mediane **1,60-1,80**,
p95 **1,80-2,70**. Fuori dalla cassa USA: mediane **2,30-2,60**, cioe' il **28-62% piu' alto**.
Stop naturale ≈ **un range di barra** (l'estremo della barra di segnale) + buffer.

| TF | range di barra [DER da 313,8 MIS] | `stop/spread` a buffer 0 (spread 1,70) | verdetto |
|---|---:|---:|---|
| **M5** | 18,5 idx | **10,9x** | 🔴 **ESCLUSO PER COSTO**: sfonda il pavimento **DURO 13,3x**. Non e' *"M5 e' basso"*: e' un conto |
| **M15** | 32,0 idx | 18,8x | 🟡 sopra il duro, sotto il 40x |
| **M30** | 45,3 idx | 26,6x | 🟡 sopra il duro, sotto il 40x |
| **H1** | 64,1 idx | 37,7x | 🟡 a un soffio dal 40x |

🟢 **E POI LA SI COMPRA, perche' l'ancora e' unica:**
```
InpSLBufferPts = 3000 punti MT5 = 30,0 punti indice
InpMinSLPts    = 7200 punti MT5 = 72,0 punti indice (PAVIMENTO R109)

stop tipico M30  = 45,3 + 30,0 = 75,3 idx  ->  /1,80 = 41,8x
stop MINIMO GARANTITO dal pavimento = 72,0 -> /1,80 = 40,0x   PASSA
                                             /1,70 = 42,4x   PASSA
```
> 🎯 **IL PAVIMENTO R109 FA DA CANCELLO DI COSTO.** Non e' un trucco: e' lo stesso numero che serve a
> non lasciare lo stop scoperto. 🔴 **E ripara un difetto vero del sorgente**: `InpMinSLPts` parte a
> **0**, cioe' **pavimento SPENTO**, contro la lezione R109. Con la tolleranza dell'autore lo stop
> puo' essere di pochi punti: **il lotto esploderebbe e il rischio con lui.**

**La frazione sotto i pavimenti** (la frontiera e' una distribuzione):
sotto il **40x** serve spread > 1,80 → [DERIVATO] **fra il 5% e il 10%** delle occorrenze,
**concentrate nella prima ora di cassa** (p95 2,60-2,70 alle ore 14-15 contro 1,80 alle ore 16-20).
Sotto il **duro 13,3x** serve spread > 5,41 → **oltre il p95 e sotto il max (8,20)**: frazione
**[NON MISURATA]**, confinata alla coda. 🔴 **Non la invento: l'istogramma di casa e' ORARIO, non al
minuto** (buco #3 di `LA_BANDA_BASSA`).

---

## 1.3 🥉 `ABTG_HVAncora` — 08/09/2026 · **1.327 righe** · **4 giorni fermo, con un file prova VERDE che non si poteva lanciare**

**Il motore in cinque righe:**
1. **ANCORA**: la barra in cui la volatilita' storica (stdev dei log-rendimenti a 30 barre)
   **attraversa verso l'alto** il proprio percentile 50 su 252 barre. Il suo massimo e minimo
   diventano il livello, il suo range il metro.
2. **CONTINUAZIONE**: chiusura oltre il **100%** del range dell'ancora → si entra **nel verso**.
3. **ESAURIMENTO**: estensione del 100% fatta e poi **rientro** → si entra **contro**.
4. **Il lato non e' un input: lo decide l'ancora.** L'ancora vive 20 barre e muore col giorno.
5. **Il motore non sa che ora e'.** Finestra 08:00-20:30 SERVER e flat 21:00 sono **gestione di
   casa**, non della fonte.

| | |
|---|---|
| **ANCORA UNICA** | 🟢 **SI, con una crepa** — stop `InpStopAtr * atr` (**r.927**, `atr = iATR(_Symbol, gTF, InpAtrLen)` con `gTF = PERIOD_CURRENT` r.255/657) · `tp = entry + InpRR * slDist` (**r.945**). 🔴 **CREPA:** esiste anche un **flat di seduta alle 21:00** (r.223-225), che e' un'ancora di **CALENDARIO**. |
| **BARRE o CALENDARIO** | 🟡 **MISTO.** HV su 30/252 **barre**, stop in **ATR del grafico** (classe S) — **ma** `InpAncoraSoloOggi = true` e il flat sono **calendario**. Guadagno di frequenza scendendo di TF: **atteso x1,97 ma TAGLIATO da un'ancora al giorno → [NON MISURATO]**. |
| **PF · n · DD** | **[NON MISURATO]** tutti e tre. |

### 🚨 IL DIFETTO DI ARITMETICA — e perche' una corsa a `InpStopAtr = 1,0` avrebbe **sepolto** il motore
```
ABTG_HVAncora.mq5 r.239   input double InpMaxSpreadPctOfStop = 2.5;
ABTG_HVAncora.mq5 r.935   if(spreadPrezzo > (InpMaxSpreadPctOfStop/100.0)*slDist)
                             -> IL TRADE SI SALTA
```
`2,5%` dello stop = *"spread <= 1/40 dello stop"* = **il pavimento di lavoro `stop >= 40 x spread`,
applicato tick per tick dall'EA**. Con `InpStopAtr = 1,0` e lo stop tipico di **45,4 idx**:

| ore SERVER | spread mediano **MISURATO** | spread / stop | soglia | esito |
|---|---:|---:|---:|---|
| 08-13 | **2,60** (1.676.013 tick alla sola ora 08) | **5,73%** | 2,50% | 🔴 **RIFIUTA** |
| 14-20 | **1,90 - 2,00** (4.931.660 tick alla sola ora 14) | **4,41%** | 2,50% | 🔴 **RIFIUTA** |

> ## 🔴 **Il file del 08/09 avrebbe tornato con ~ZERO OPERAZIONI, a ogni ora della finestra. Le "50-200 operazioni" dichiarate erano impossibili PER COSTRUZIONE.** E il danno peggiore non e' la corsa buttata: **uno zero letto come "niente segnali" avrebbe sepolto un motore che non era nemmeno stato interrogato.**

🟢 **Il file del 08/09 NON l'ho modificato** (stessa scelta fatta oggi su
`prove/ABTG_ImpulsoApertura.txt` in `LA_BANDA_BASSA` par. 5.1): resta come **reperto** dei criteri,
che sono buoni. La riparazione e' un file **nuovo**.

### 📐 La scala della frontiera, che **e' il round**
| `InpStopAtr` | stop [DER] | spread/stop ore 14-20 | ore 08-13 | `stop/spread` | esito col cancello dell'EA |
|---:|---:|---:|---:|---:|---|
| **1,0** (la fonte) | 45,4 | **4,41%** | **5,73%** | 22,7x / 17,5x | 🔴 **rifiuta sempre** |
| **1,5** | 68,1 | **2,94%** | **3,82%** | 34,1x / 26,2x | 🔴 **rifiuta sempre** |
| **2,0** | 90,8 | **2,20%** | 2,86% | 45,4x / 34,9x | 🟡 **passa il pomeriggio** |
| **2,5** | 113,5 | **1,76%** | **2,29%** | 56,7x / 43,7x | 🟢 **passa a tutte le ore** |

✅ **CLASSE 278 verificata: l'esito positivo E' RAGGIUNGIBILE.** Se la cima della scala fosse stata
sotto 40x, **il file non andava scritto**: si andava a H1 o H2.

🔴 **E LA CREPA, quantificata PRIMA di vedere i numeri.** Col range giornaliero **MISURATO** di
**314,5 idx** e `InpRR = 2,0`, il TP sta a:

| `InpStopAtr` | TP | **quota del range del giorno** | raggiungibile entro la campanella? |
|---:|---:|---:|---|
| 1,0 | 90,8 | **29%** | 🟢 si |
| 1,5 | 136,2 | **43%** | 🟢 si |
| 2,0 | 181,6 | **58%** | 🟡 marginale |
| 2,5 | 227,0 | **72%** | 🔴 quasi mai |

> 🎯 **Questo round misura DUE muri insieme, e sono la stessa cosa guardata da due lati: dove cade il
> muro del COSTO (in basso) e dove cade il muro del CALENDARIO (in alto).** Se esiste una cella al
> centro che passa entrambi, quella cella e' il motore. **Se non esiste, il motore e' schiacciato fra
> il suo pedaggio e la sua campanella** — e quello e' un **verdetto**, non un fallimento della corsa.

🎁 **E un effetto collaterale che vale da solo:** il `k` a cui compaiono le prime operazioni
**MISURA l'`ATR(M30)` vero di U30USD**, che oggi e' `[DERIVATO]` e mai misurato. Se compaiono gia' a
`k = 1,5`, allora `ATR(M30) >= 80,0/1,5 = 53,3 idx`, cioe' la derivazione da ADR **sottostima di
almeno il 17%** — che e' **esattamente** la sottostima del **18-27%** gia' misurata in casa su un
altro motore (`EMA200_I_DUE_REQUISITI_2026-09-12.md` r.182). **Due strade indipendenti.**

---

## 1.4 🔴 `ABTG_DaxValueArea` — 30/08/2026 · **1.387 righe** · **13 giorni fermo, e il file prova NON E' LANCIABILE**

**Il motore in cinque righe:**
1. A fine seduta cash DAX si costruisce il **volume profile** della seduta: ogni barra distribuisce
   il suo **tick-volume** **uniformemente** sui bin che il suo range attraversa (r.286-312).
2. Dal **POC** si espande al vicino piu' pesante finche' si copre il **70%** del volume: escono
   **VAL** e **VAH**, i bordi della **Value Area** (r.323-350).
3. **L'apertura di domani** rispetto a quella VA seleziona il motore (**FASE 5** del metodo,
   r.359-365): dentro → **BALANCE**, sopra VAH → **DIREZIONALE** rialzista, sotto VAL → ribassista.
4. **BALANCE**: fade del bordo verso il POC. **DIREZIONALE**: `InpAcceptBars = 2` barre che
   **chiudono fuori** dalla VA = l'**accettazione**, che e' la conferma, non la rottura nuda.
5. Flat a fine cassa DAX, **16:30 ORA SERVER**. Zero overnight.

| | |
|---|---|
| **ANCORA UNICA** | 🔴 **NO** — stop `SlValueArea_Calc` **r.415-421**: `VAL - buffer` (balance long) / `VAH - buffer` (direzionale long), con l'ingresso **al mercato sulla barra dopo** (r.795-799) → la distanza vera e' **(escursione di una BARRA) + (un BUFFER FISSO)**. Target `Targets_Calc` **r.432-446**: `tp1 = POC`, `finalTP = bordo opposto` o `bordo +- InpExtVaMult x LARGHEZZA VA`. **Nessuna delle due ancore sa niente dell'altra.** |
| **BARRE o CALENDARIO** | 🔴 **CALENDARIO per il segnale** (1 VA al giorno dalla seduta precedente r.690-695, tetto `InpMaxTradesPerDay = 2` r.130, cassa 08:00-16:30 r.110-113) · **BARRE per lo stop**. 👉 **IL PEGGIORE DEI QUATTRO ABBINAMENTI: scendere di TF costa DUE VOLTE** (stop piu' stretto **e** nessuna operazione in piu'), esattamente come `ABTG_ImpulsoApertura` (`LA_BANDA_BASSA` par. 4). |
| **PF · n · DD** | **[NON MISURATO]** tutti e tre. |

### 🚨 I QUATTRO DIFETTI BLOCCANTI del file del 30/08
| # | difetto | conseguenza, verificata sul sorgente del driver |
|---|---|---|
| 1 | **TRE assi Y** (`InpVaPercent`, `InpAcceptBars`, `InpSide`) | `controlla_prova.py` **FALLISCE** |
| 2 | 🔴 **le direttive `@` sono COMMENTATE** (`# @SIMBOLO  D30EUR`, `# @PERIODO  M5`, ...) | `walkforward_generico.ps1` **r.495-501** salta le righe che iniziano con `#` **PRIMA** di guardare la `@` → `$Direttive` resta vuoto → il driver **MUORE** su **r.737** |
| 3 | **nessuna riga `#  EA: <nome>`** | il cancello stampa *"EA NON TROVATO -> non misurabile"* e **non controlla niente** |
| 4 | **`@PERIODO M5`** su 21 mesi | **~126.700 barre** [DER], **sopra** il tetto delle ~100.000: finestra piu' corta di quella dichiarata, **in silenzio** |

🔴 **E IL PUNTO CIECO DEL CANCELLO, che e' una classe nuova:** `controlla_prova.py` verifica la
finestra cercando la **sottostringa** `"@DAQUANDO"` — e **la trova dentro il commento**. Su questo
file **il cancello dichiarava la finestra presente mentre il driver non l'avrebbe vista.**
👉 Va in `CHECKLIST_RIGA_DI_LANCIO.md`.

### 📐 La frontiera del costo — **sfonda il pavimento DURO a M5, M15 e M30**
Spread D30EUR **MISURATO** su 30.974.789 tick: ora 08 mediana **1,70** p95 **2,70** max **12,00**
(su 1.847.049 tick a quella sola ora); ore 09-16 **1,60-1,70**. Uso **1,70**, la mediana peggiore
dentro la cassa. Escursione della barra di segnale stimata al **60%** del range — **STIMA MIA,
dichiarata**, e **non entra** nella scala del round.

| TF | range di barra [DER da 186,5 MIS] | stop col buffer della fonte (3,0 idx) | `stop/spread` | verdetto |
|---|---:|---:|---:|---|
| M5 | 11,0 | ~9,6 | **5,6x** | 🔴 **SFONDA il duro 13,3x** |
| M15 | 19,0 | ~14,4 | **8,5x** | 🔴 **SFONDA il duro** |
| M30 | 26,9 | ~19,2 | **11,3x** | 🔴 **SFONDA il duro** |
| H1 | 38,1 | ~25,8 | 15,2x | 🟡 sopra il duro, sotto il 40x |

🔴 **E `InpMinStopPts = 500` punti MT5 = 5,0 punti indice = 2,9x NON PROTEGGE NIENTE**: e' un
pavimento **nominale**, **12 volte sotto** il pavimento duro di casa. E' un difetto vero del
sorgente.

### 🔬 E UNA TERZA TENSIONE, che non sta in nessuna regola di casa e che ho trovato **leggendo il costruttore del profilo**
Il profilo si costruisce con le barre **del grafico** (r.585, r.641 `CopyRates(_Symbol, gTF, ...)`) e
ogni barra spalma il suo volume **uniformemente** sui bin del suo range (r.286-312). Seduta cash DAX
= **510 minuti**; bin = **5 punti indice**; range di seduta [DER da 186,5 MIS] = **111,0 idx** = ~22
bin.

| TF | barre per seduta | bin coperti da **una** barra | **quota del profilo, per barra** |
|---|---:|---:|---:|
| M5 | 102 | 2,2 | **10%** |
| M15 | 34 | 3,8 | **18%** |
| M30 | 17 | 5,4 | 🔴 **25%** |

> ## 🔴 **A M30 ogni singola barra sporca un QUARTO del profilo: il POC tende al centro del range e la VA tende al range x 0,7. IL PROFILO VOLUMETRICO DEGENERA IN UNA STATISTICA GEOMETRICA DI RANGE** — cioe' il motore diventa **un ORB con un altro nome**, e l'ORB in casa e' chiuso con **~210 celle a tick** (R45 0/48, R12 48/48 negative OOS).
> 🔴 A **M5** il profilo e' il migliore **ma** la corsa **sfonda il tetto delle ~100.000 barre**.
> 🟢 **M15 e' l'unico TF dentro TUTTI E TRE i vincoli**: profilo campionato (34 barre, 18% per
> barra), tetto rispettato (**42.200 barre**), frontiera raggiungibile col buffer.
> **La scelta del TF e' un CONTO, non una preferenza.**

### 💸 E IL PREZZO DEL BUFFER — **la doppia morsa, scritta col numero prima della corsa**
Il buffer e' un **pavimento geometrico**: lo stop e' **sempre >= buffer**, quindi i rapporti sono
**GARANTITI, non stimati**. Il target **non** si allarga col buffer (ancora unica = NO), quindi il
rischio/rendimento **crolla** salendo la scala. Larghezza VA [DER]: 67-83 idx (60-75% del range di
seduta, **stima dichiarata**); meta' VA 33-42 idx.

| cella | buffer | stop garantito | **`stop/spread`** | **RR al POC** | **RR a VAH** |
|---|---:|---:|---:|---:|---:|
| 1 | 800 pt MT5 = 8,0 idx | >= 8,0 | 🔴 **4,7x** (sotto il duro) | 4,1-5,2 | 8,4-10,4 |
| 2 | 2800 = 28,0 idx | >= 28,0 | 🟡 16,5x | 1,2-1,5 | 2,4-3,0 |
| 3 | 4800 = 48,0 idx | >= 48,0 | 🟡 28,2x | 0,7-0,9 | 1,4-1,7 |
| 4 | 6800 = 68,0 idx | >= 68,0 | 🟢 **40,0x** | **0,5-0,6** | **1,0-1,2** |

> ## 🔴 **LA CELLA CHE PAGA IL PEDAGGIO HA RR ~1,0 SUL TARGET FINALE E ~0,5 SUL PRIMO. La cella con un RR buono sta a 4,7x, cioe' TRE VOLTE sotto il pavimento duro.** Questa e' la doppia morsa, e per questo l'esito che mi aspetto e' **(b), il numero brutto**.
> 🟢 **E il round vale lo stesso**, perche' misura una LEGGE: se il **PF SALE col buffer**, la regola
> dell'ancora unica e' **FALSIFICATA** su questo motore. **Lo scrivo adesso perche' altrimenti dopo
> lo spiegherei via.**

---

# 2. 📦 I CINQUE FILE PROVA — 14 celle, **28 passate, 5,16 minuti**

Metro di casa: **`T(min) = 0,6 + 0,077 x passate`, per ROUND.**
📌 Riferimento: la coda di stanotte fa **258 passate** in tutto.

| ord. | file | EA · simbolo · TF | **asse unico** | celle | passate | **T (min)** |
|---:|---|---|---|---:|---:|---:|
| **1** | `prove/R141a_momentum_NASUSD_r12.txt` | `IntradayMomentum` · **NASUSD** · M30 | `InpUseSecondSignal` | 2 | 4 | **0,91** |
| **2** | `prove/R141b_momentum_U30USD_gemello.txt` | `IntradayMomentum` · **U30USD** · M30 | `InpUseSecondSignal` (gemello, **ablazione a stella**) | 2 | 4 | **0,91** |
| **3** | `prove/R141c_atrexh_M30_NASUSD.txt` | `AtrExhaustVol` · **NASUSD** · M30 | `InpProxMode` (**la manopola inerte**) | 2 | 4 | **0,91** |
| **4** | `prove/R141d_hvancora_stopatr_M30_U30USD.txt` | `HVAncora` · **U30USD** · M30 | `InpStopAtr` (1,0/1,5/2,0/2,5) | 4 | 8 | **1,22** |
| **5** | `prove/R141e_daxva_buffer_M15_D30EUR.txt` | `DaxValueArea` · **D30EUR** · M15 | `InpSlBufferPts` (800/2800/4800/6800) | 4 | 8 | **1,22** |
| | **TOTALE** | | | **14** | **28** | **5,16** |

## 2.1 ✅ IL CANCELLO, riprodotto — **e il numero di celle GUARDATO, non assunto**
```
=== CONTROLLO FILE PROVA ===
  R141a_momentum_NASUSD_r12.txt          ABTG_IntradayMomentum.mq5  pin=27 celle= 2  OK
  R141b_momentum_U30USD_gemello.txt      ABTG_IntradayMomentum.mq5  pin=27 celle= 2  OK
  R141c_atrexh_M30_NASUSD.txt            ABTG_AtrExhaustVol.mq5     pin=35 celle= 2  OK
      . asse ENUM (ENUM_EX_PROX): il passo e' IGNORATO, celle = membri fra 0 e 1 = 2
  R141d_hvancora_stopatr_M30_U30USD.txt  ABTG_HVAncora.mq5          pin=29 celle= 4  OK
  R141e_daxva_buffer_M15_D30EUR.txt      ABTG_DaxValueArea.mq5      pin=25 celle= 4  OK
file: 5 | celle totali: 14 | passate (celle x 2 finestre): 28 | problemi: 0
ESITO: OK

controlla_riga.py --oggetto prova : EXIT 0 su 5 file su 5
byte >127 contati con python3 : 0 su tutti e cinque
```
🚨 **CLASSE NUOVISSIMA (asse ENUM scritto come intervallo con passo): il numero di celle e' stato
GUARDATO dopo aver scritto ogni file**, come impone la classe. Atteso 2·2·2·4·4 → uscito 2·2·2·4·4.
Gli unici ENUM in gioco sono `InpAtrTF` (pinnato col **valore esplicito 30** = `PERIOD_M30`),
`InpProxMode` e `InpTrigMode` (due membri ciascuno, **valori espliciti 0 e 1**). **Nessun intervallo
largo su un enum.**

## 2.2 🧹 Igiene che i cancelli **non** controllano, verificata a mano
- 🚨 **CLASSE 273, e in tutti e cinque i file il commento NON e' invertito: `-Modello 4` = TICK REALI
  · `-Modello 1` = OHLC M1 = SOLO SCREENING.** Il modello non e' pinnato: arriva dalla riga di
  lancio, dove il default del driver e' **4** (`walkforward_generico.ps1` r.180).
- **Pavimento dei tick: `@DAQUANDO 2024.09.26`** (indici) in tutti e cinque. Nessuno dei cinque
  chiede una finestra piu' lunga dei tick → **nessuno e' screening: sono verdetti.**
- 🕐 **ORA SERVER BCM in tutti e cinque** (= ora italiana − 1): `InpSessionHour = 8` per il DAX
  (**non 9**), `InpEntryHour = 20` / `InpExitHour = 21` / `InpHourStart = 14` per gli USA (**non 21 /
  22 / 15**). **Un CSV con l'ora italiana si CESTINA.**
- **Tetto delle barre**, calcolato per ciascuno: M30 su NASUSD/U30USD = **~21.100 barre**; M15 su
  D30EUR = **~42.200**. Entrambi sotto le ~100.000. M5 sarebbe **~126.700** → **sfonda**, e lo dico
  ogni volta che escludo M5.
- **Magic VERGINI**: `784101` · `784102` · `784103` · `784104` · `784105` — `grep -rl` repo-wide il
  12/09/2026, `.git` escluso: **ZERO occorrenze** per ciascuno.
- **Etichette**: blocco **`r141`** — le **29** etichette in coda stanotte arrivano a **`r139c`**
  (piu' `canfrz`, `cemad02`, `cemad05`). **Zero collisioni.**
- **Nessun pin di stringa**: `InpComment`, `InpNewsFile`, `InpNewsCurrencies` restano al default
  compilato. Un pin di stringa **vuota** MT5 lo ignora in silenzio — e' la classe che costo' il round
  FiboH4. (In `AtrExhaustVol` `InpNewsCurrencies` **e' `""` nel sorgente**: pinnarlo sarebbe
  esattamente quel difetto.)
- 🔴 **Per-trade sovrascritto**: in tutti e cinque i file le celle condividono il magic, quindi
  scrivono lo **stesso** file per-trade e l'ultima **sovrascrive** le altre. I numeri delle celle si
  leggono nell'**OPTFRAME**, che ha una riga per passata. **Dichiarato nei file, non scoperto dopo.**
- 🔴 **G1 (determinismo con due magic gemelli): `[NON MISURATO]` su tutti e quattro gli EA**, perche'
  il driver ammette **un solo asse Y** e su ciascun file l'asse serve alla domanda. **Il controllo
  interno** e' diverso in ogni round e sta scritto dentro: la **monotonia** di `Trades` su
  `InpStopAtr` (R141d), la **costanza** di `Trades` sulle quattro celle (R141e), la **cella 0 come
  configurazione piu' larga possibile** (R141c), la **differenza fra le due celle** (R141a/b).
- 🔴 **UN SOLO agente locale** in MT5 → Strategy Tester → Agenti (**classe 129**).

---

# 3. 🧪 IL CONTRO-ESEMPIO CONTRO IL PRIMO CLASSIFICATO — costruito da me, e **una parte lo scalfisce**

Il primo della consegna e' **`R141a`** (`ABTG_IntradayMomentum` NASUSD M30). Il contro-esempio non e'
contro il round: e' **contro la ragione per cui lo metto primo**, cioe' *"e' l'unico con campione
pieno garantito e la frontiera del costo passata con margine"*.

## 3.1 La trappola A — **«l'hai messo primo con ANCORA UNICA = NO, nel giorno in cui tu stesso hai misurato che l'ancora doppia UCCIDE un motore a 52,4x»** · 🟡 **regge, ma con una crepa che dichiaro**
**L'ipotesi alternativa:** `IntradayMomentum` morira' esattamente come il **cono di rumore**
(`stop/spread` **52,4x** e informazione direzionale **+0,0012 R**, cioe' **zero**, misurato oggi su
1.266.562 barre).
**Quale numero distingue i due casi?** Il cono e' morto perche' **lo stop ERA l'uscita**: allargandolo
di **x2,7** l'edge in punti cresceva del **7,8%** e l'edge in R **si divideva per 4,6** (misurato,
`CACCIA_TF_BASSO` par. 2.4). Su `IntradayMomentum` **lo stop NON e' l'uscita**: l'uscita e' la
campanella, e lo stop e' un **guardrail** che il sorgente stesso dichiara *"NON FA PARTE DEL PAPER"*
(r.146). Se il guardrail e' raramente toccato, **il P/L non dipende dall'ampiezza dello stop e la
diluizione in R non si applica.**
**E' raramente toccato?**
```
stop = 2,0 x ATR(M30) = 90,6 punti indice
range della finestra di esposizione (30 minuti) [DERIVATO] = 45,3 punti indice
=> lo stop e' 2,00 VOLTE il range tipico dell'intera finestra
```
Perche' lo stop scatti, l'escursione **avversa** in trenta minuti deve superare **due volte il range
tipico completo** della stessa finestra. 🟢 **Raro.**
🔴 **MA LA CREPA E' VERA E LA SCRIVO:** il **45,3** viene dalla legge `sqrt(t/1440)`, che sulle
finestre di campanella **SOTTOSTIMA** — in casa il fattore d'amplificazione **misurato** per
l'apertura DAX a 15 minuti e' **3,05** (`ROUND_ORB_ATR_PS5` par. 2.2). Se l'**ultima** mezz'ora fosse
amplificata anche solo **x2**, il range sarebbe **90,6 = esattamente lo stop**, e allora **circa
meta' delle operazioni potrebbe morire sullo stop** — e la diluizione in R **tornerebbe a morderlo**.
> 🎯 **QUINDI LA MIA PRIMA POSIZIONE E' CONDIZIONATA, E LA CONDIZIONE SI LEGGE NELLO STESSO CSV:**
> se la frazione di operazioni chiuse **dallo stop** e' piccola (**< 10-15%**), il guardrail e' un
> guardrail e l'ancora doppia **non e' un problema**. Se invece **la maggioranza** muore sullo stop,
> **lo stop E' l'uscita, la regola dell'ancora unica morde, e la mia classifica era sbagliata.**
> **Falsificabile, e falsificabile con i dati che il round produce.** L'amplificazione della mezz'ora
> finale su NASUSD e' **[NON MISURATA]** e non la estrapolo dal DAX.

## 3.2 La trappola B — **«il tuo `n ~ 443` torna PER COSTRUZIONE: e' un'identita' di calendario, non una misura»** · ✅ **VERO, e lo dico io**
🔴 **E' esattamente cosi', e non lo vendo per altro.** `n ~ 443` non e' una misura della **qualita'**
del motore: e' una **proprieta' del suo disegno** (1 operazione per seduta, `InpMinAbsR1Pct = 0`,
nessun filtro acceso). Cio' che garantisce e' che **il MERITO sara' LEGGIBILE**, non che sara'
**buono** — ed e' precisamente il motivo per cui **non dichiaro nessun PF atteso in valore**.
🔎 **E il contro-esempio contro l'identita' stessa**, perche' anche un'identita' si puo' rompere: il
motore **salta** la giornata se `r1 = 0` esatto, se la **finestra d'ingresso di 5 minuti** viene
mancata (`InpEntryWindowMin = 5`: *"oltre, la giornata si salta"*), o se la chiusura di cassa di ieri
non si trova entro 5 giorni. Su NASUSD all'ora 20 ci sono **11.182.176 tick MISURATI**: la barra
esiste. 👉 **Quindi un `n` totale sotto ~300 non e' un motore lento: e' la CATENA ROTTA**, ed e'
scritto come esito **(c)** nel file prova.

## 3.3 La trappola C — **«la tua banda edge/costo 0,58-1,16 poggia su una frazione INVENTATA»**
🟡 **In parte vero, e la banda e' dichiarata come banda proprio per questo**: la frazione
`E|movimento| / range` e' **[NON MISURATA]** e l'ho scritta come **0,5-1,0**, non come un numero.
**A cosa serve allora?** A **una cosa sola, e basta quella**: stabilire se l'esito positivo e'
**RAGGIUNGIBILE** (classe 278). Il limite superiore della banda e' **1,16 > 1,00** → 🟢 **esiste un
valore, dentro numeri nostri misurati, che produce un PASS.** Se il limite superiore fosse stato
**sotto 1,00**, il round sarebbe stato *"una condanna travestita da test"* e **il file non andava
scritto**. Col doppio predittore la banda e' **3,6-7,2**: comodamente sopra.
🔴 **E la parte che la banda NON puo' dire**: quale dei due estremi sia vero. **Non lo so, e non lo
scelgo.**

## 3.4 🚫 E cosa **non** ho potuto rompere, quindi resta in piedi
- **La prova di regime.** 21 mesi di tick BCM sugli indici = **UN regime, rialzista**. La regola **C**
  dell'Emendamento della Finestra **non e' soddisfatta e non lo sara' il 30/09**. Vale per **tutti e
  cinque** i file. 🔴 **Nessuna cella di questo dossier e' promuovibile senza.**
- **Il valore del tetto delle barre** sul terminale di backtest **50504400** (`C:\MT5_Backtest`) e'
  `[NON MISURATO]` (buco #8 di `LA_BANDA_BASSA`): i margini 21.100 e 42.200 su ~100.000 sono margini
  su un tetto **PRESUNTO**. **Leggerlo costa ZERO passate.**
- **L'`ATR(M30)` vero dei tre indici.** Tutti i miei `stop/spread` poggiano su
  `ADR x sqrt(t/1440)`, che la casa ha **misurato sottostimare del 18-27%**. L'errore va nella
  direzione **prudente** (lo stop vero e' piu' largo → i rapporti sono un **pavimento**), ma resta
  un'inferenza. **`R141d` lo misura di straforo.**
- **La frazione esatta sotto i pavimenti.** L'istogramma di casa e' **ORARIO**, non al minuto, e le
  ore 08 (DAX) e 14 (USA) **contengono la campanella**: 🔴 **tutti i rapporti di questo dossier sulle
  ore d'apertura sono OTTIMISTI PER COSTRUZIONE.**

---

# 4. 🕳️ I BUCHI DICHIARATI — elencati **per nome** (classe 180)

| # | cosa manca | perche' | conseguenza, in numeri | costo per chiuderlo |
|---:|---|---|---|---|
| 1 | 🔴 **l'amplificazione della MEZZ'ORA FINALE** su NASUSD e U30USD | il fattore **3,05** e' misurato sul **DAX**, a **15 minuti**, in **APERTURA** | 🔴 **fa oscillare la frazione di operazioni chiuse dallo stop di `IntradayMomentum` fra "rara" e "~meta'"** — ed e' la condizione della sua PRIMA POSIZIONE (par. 3.1) | si legge nello stesso CSV del round: frazione di uscite per stop |
| 2 | **`E|movimento|/range` della mezz'ora finale** | mai misurato in casa | la banda edge/costo e' **0,58-1,16**, cioe' non distingue un PASS da un FAIL | una sonda su barre M1, **ZERO passate di tester** |
| 3 | **l'`ATR(M30)` vero di U30USD, NASUSD e D30EUR** | tutti i rapporti poggiano su `ADR x sqrt(t/1440)`, che **sottostima del 18-27%** (MIS) | i miei `stop/spread` sono un **pavimento**, non una stima centrata | `R141d` lo misura di straforo dal muro dei rifiuti |
| 4 | **la LARGHEZZA della Value Area** su D30EUR | derivata (60-75% del range di seduta, **stima mia**) | gli RR di `R141e` (0,5-1,2 sulla cella che paga il pedaggio) sono **[DERIVATI]**, non misurati | una passata con l'export per-trade |
| 5 | **la frequenza di `AtrExhaustVol`, `HVAncora`, `DaxValueArea`** | mai girati | **la meta' bassa di tutte e tre le bande sta sotto il pavimento dei 150 per finestra** → merito **SOSPESO** (valvola R59) | **sono i round stessi** |
| 6 | **«Max barre nel grafico» sul terminale `50504400`** (`C:\MT5_Backtest`) | `walkforward_generico.ps1` **non scrive `[Charts] MaxBars`** | i margini 21.100 / 42.200 sono su un tetto **PRESUNTO** | **ZERO passate**: MT5 → Strumenti → Opzioni → Grafici |
| 7 | **lo spread al MINUTO dentro l'ora** | l'istogramma e' **ORARIO** e le ore 08 e 14 contengono la campanella | 🔴 **ogni rapporto sulle ore d'apertura di questo dossier e' OTTIMISTA per costruzione** (indizio nel dato: D30EUR ora 08 ha mediana 1,70 e **max 12,00**) | `ABTG_SpreadLogger` al minuto, **ZERO passate di tester** |
| 8 | **il terzo indice di `IntradayMomentum` (D30EUR, campanella 16:30 SERVER)** | non l'ho scritto per non consegnare 12 passate quando la domanda si decide sulle prime 8 | la sua riga e' **peggiore**: `stop/spread` **31,7x** alla mediana e **24,8x** al p25, sotto il 40x | 4 passate, file da scrivere |
| 9 | **la prova di REGIME sugli indici** | storico BCM dal **2024.09.26**: il broker non ha nulla prima | **UN solo regime, toro.** La regola C **non e' soddisfatta e non lo sara' il 30/09** | dati esterni, e solo come **screening** |
| 10 | **`n` in POSIZIONI contro DEAL** su `R141e` | risolto **pinnando `InpTP1_ClosePct = 0`**, ma va detto perche' e' la trappola d'archivio | col parziale acceso la colonna `Trades` conta **DEAL**: in archivio una cella M30 leggeva `n = 257/427` quando in posizioni erano **~128/212**, e **l'IS scendeva sotto i 150** (`LA_BANDA_BASSA` buco #6) | 🟢 **gia' chiuso nel file** |

---

# 5. 🏁 QUALE DEI QUATTRO MERITA DI GIRARE STANOTTE, IN CHE ORDINE, E QUALE NO

| ord. | chi | passate | perche' in quest'ordine, col numero |
|---:|---|---:|---|
| 🥇 **1** | **`R141a` + `R141b`** — `IntradayMomentum` NASUSD e U30USD | **8** (1,82 min) | 🟢 **L'unico dei quattro con `n >= 150` GARANTITO in entrambe le finestre** (~443 sedute, IS 160-180 / OOS 240-270) · **1,00 op/giorno per costruzione**, **3 di famiglia** su tre indici = **3x il pavimento firmato il 07/09** · frontiera del costo passata con margine (**53,3x** e **47,8x**) e **NASUSD l'unico indice sopra il 40x anche al p25** (40,6x). Rispondono **in tutti e due i versi**: un PASS apre la prima sedia a campione pieno, un FAIL chiude con un numero un candidato di classe A1 fermo da 21 giorni |
| 🥈 **2** | **`R141c`** — `AtrExhaustVol` NASUSD M30 | **4** (0,91 min) | 🟢 **L'unico ad ANCORA UNICA + BARRE PIENE**: il solo dei quattro a cui la domanda di Claudio si applica alla lettera, e il solo su cui la frontiera del costo **si compra senza pagare edge** (pavimento R109 a **72,0 idx = 40,0x garantiti**) · e smaschera una **manopola inerte** (145,0 idx = **3,2 range di barra**) 🔴 **Ma la frequenza e' `[NON MISURATA]` e la meta' bassa della banda sta sotto 150** |
| 🥉 **3** | **`R141d`** — `HVAncora` U30USD M30 | **8** (1,22 min) | 🟢 Ripara un'**attesa impossibile** che avrebbe sepolto il motore, e **misura l'`ATR(M30)` vero di U30USD** che non abbiamo 🔴 **Ma l'attesa di frequenza del file del 08/09 (0,11-0,45 op/g) non arriva a 150 in NESSUNA finestra**: e' un **PASSO 0 di costo**, non un candidato a sedia. E il muro del calendario (TP al 72% del range del giorno a k=2,5) puo' mangiarsi la cima della scala |
| 🔴 **4 — NON stanotte** | **`R141e`** — `DaxValueArea` D30EUR M15 | 8 (1,22 min) | 🔴 **ANCORA UNICA = NO** + **CALENDARIO per il segnale e BARRE per lo stop** (l'abbinamento che costa **due volte**) + il profilo che **degenera in un ORB** salendo di TF (25% per barra a M30) + il **tetto delle barre** che chiude M5 + la **doppia morsa**: la cella che paga il pedaggio (**40,0x**) ha **RR ~1,0** sul finale e **~0,5** sul primo, la cella con RR buono (4,1-5,2) sta a **4,7x**, **tre volte sotto il duro**. 👉 **Gira come MISURA DI UNA LEGGE, non come candidato**: se il PF **sale** col buffer, la regola dell'ancora unica e' **falsificata** — e quello e' il risultato piu' importante che il round possa dare. **Ma non e' una sedia, e stanotte servono sedie.** |

## 🎯 E LA COSA PIU' UTILE CHE ESCE DA OGGI, in una riga
🔴 **Non e' che i quattro fossero cattivi: e' che NESSUNO LI AVEVA INTERROGATI, e due dei quattro
avevano un file prova che NON POTEVA rispondere.** Uno per **aritmetica** (HVAncora: l'EA avrebbe
rifiutato il 100% dei trade col pin dichiarato), uno per **quattro difetti di forma** (DaxValueArea:
il driver non sarebbe nemmeno partito). 👉 **Un motore con un file prova verde che non puo' dare una
risposta positiva e' piu' pericoloso di un motore senza file prova**, perche' il primo torna con uno
zero che qualcuno leggera' come un verdetto.

## 🙋 LE TRE COSE CHE CHIEDO A CLAUDIO, e costano meno di cinque minuti in tutto
1. 🖥️ **Finestra PowerShell sul PC di backtest** (nessun terminale MT5 da toccare, e **nessuno dei
   quattro conti BCM sul VPS viene sfiorato**): leggere `MT5 → Strumenti → Opzioni → Grafici → «Max
   barre nel grafico»` sul terminale **50504400** (`C:\MT5_Backtest`). **ZERO passate**, e chiude il
   buco #6 che oggi rende tutti i miei margini di barre dei margini su un tetto **presunto**.
2. 🔓 **Una firma, non un round**: in `R141c` il pin `InpFridayClose = true` e' **NOSTRO** — il
   sorgente parte a `false`, cioe' **tiene le posizioni nel fine settimana**, e su un CFD indice
   quello misurerebbe il **gap del weekend**, non il motore. E' una restrizione **piu' prudente** del
   default, ma **rischio e taglie sono di Claudio**: la segnalo, non la decido.
3. 📄 **Un PDF che lui puo' scaricare da un browser normale in due minuti** e io no: **SSRN 5095349**
   (Ákos Maróy, *"Improvements to Intraday Momentum Strategies Using Parameter Optimization and
   Different Exit Strategies"*) — secondo l'indice di ricerca contiene **le uscite alternative** del
   motore che sta in prima posizione stanotte. **403 su SSRN** per la settima volta di fila.

## 🟢 E COSA E' ANDATO BENE, perche' un elenco di difetti senza le vittorie descrive male la realta'
- 🔦 **Quattro motori sono usciti dall'invisibilita' in un pomeriggio**, e non con un'opinione: con
  **cinque file prova gatati**, **quattro righe di registro** e **dieci scarti col numero**. Il
  09/09 quella stessa insistenza ci trovo' `EMA200` sul Dow.
- 🚨 **Un'attesa impossibile intercettata PRIMA della corsa.** `HVAncora` sarebbe tornato con uno zero
  e, molto probabilmente, sarebbe stato archiviato. **Quel motore era a una corsa dal cimitero, per
  un pin.**
- 🔧 **Una manopola inerte trovata LEGGENDO**, non girando: `0,5%` di 29.001 = **145 punti indice** =
  **3,2 range di barra**. Trenta secondi di lettura, una notte di macchina risparmiata — ed e'
  diventata **l'asse** del round invece di restare un difetto.
- 🧩 **Una tensione strutturale nuova, che non sta in nessuna regola di casa**: su
  `DaxValueArea` **lo stesso input governa il campionamento del profilo e l'ampiezza dello stop, in
  direzioni OPPOSTE**. Costa zero applicarla al prossimo motore volumetrico.
- 🎯 **E un numero che ordina due gemelli**: al p25 del range giornaliero **NASUSD sta a 40,6x e
  U30USD a 26,1x**. Prima di oggi i due indici USA erano intercambiabili nelle nostre schede. **Non
  lo sono.**

---

## 📚 FONTI — tutte sul branch `lavoro`, tutte aperte e ricontate oggi

**🥇 MISURATO (rango 1), riletto sui file grezzi:**
`backtest_pipeline/risultati_archivio/spread_flotta/spread_orario_{D30EUR,U30USD,NASUSD}.csv`
(**30.974.789 + 64.711.285 + 156.146.398 tick**, mediana · p95 · max **ora per ora**) ·
`report/ROUND_ORB_ATR_PS5_2026-09-10.md` r.233-234 (**range giornaliero e prezzo mediano MISURATI**:
U30USD 314,5 / 53.465 su 24 giorni · D30EUR 186,5 / 25.421 su 49 · NASUSD 313,8 / 29.001 su 24, con
p25 e p75) · `report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.181-183 (**commissione 0,0000 su n=302
deal**) e r.290 (**1 punto indice = 100 punti MT5**, misurato su D30EUR/U30USD/NASUSD) ·
`report/EMA200_I_DUE_REQUISITI_2026-09-12.md` r.182 (**la legge ancorata all'ADR sottostima del
18-27%**) · `backtest_pipeline/coda/CODA.txt` (**39 righe, SOLA LETTURA**, 29 etichette) ·
`backtest_pipeline/controlla_prova.py` e `controlla_riga.py` (**girati da me, senza pipe**)

**📖 SORGENTI LETTI RIGA PER RIGA:**
`mql5/Experts/ABTG_IntradayMomentum.mq5` (r.57-60 · 88-91 · 95-137 · 146-160 · 494 · 519-521) ·
`ABTG_AtrExhaustVol.mq5` (r.119-125 · 130-181 · 414 · 470-517 · 523-528 · 557-561 · 602 · 625-649 ·
765-769 · 815-834) ·
`ABTG_HVAncora.mq5` (r.60-110 · 136 · 179-250 · 255 · 627-677 · 714-796 · 921-951 · 1040-1067) ·
`ABTG_DaxValueArea.mq5` (r.74 · 92-140 · 145-154 · 250-350 · 355-446 · 475-501 · 585 · 641 · 690-695
· 785-860 · 1108-1184) ·
`backtest_pipeline/walkforward_generico.ps1` (r.173-185 · **495-503** · 506-508 · 511-584 · 737-755)

**🥈 REFERTI E CRITERI (e dove questo dossier li CORREGGE):**
`report/LA_BANDA_BASSA_2026-09-12.md` (par. 2.2 il x1,97 su 58 serie · par. 4 la legge
dell'ancoraggio · buco #4 🔴 **CORRETTO QUI** · buco #6 il deal-contro-posizione · buco #8 il tetto
delle barre) · `report/CACCIA_TF_BASSO_2026-09-12.md` (par. 0 la **regola dell'ancora unica** ·
par. 2.4 il test di scala · par. 6.2 🟢 **il fatto "visto di straforo" che ha aperto questo dossier**)
· `report/CACCIA_M30_INDICI_2026-09-08.md` (la scheda P3 di HVAncora) ·
`backtest_pipeline/caccia_strategie/CACCIA_M5M15_INDICI_2026-08-25.md` (la scheda P2 di
AtrExhaustVol) · `report/SWEEP_MECCANISMI_LIBERI_2026-08-22.md` par. A1 (IntradayMomentum) ·
`backtest_pipeline/risultati_archivio/R98_CRITERI_BOZZA.md` ·
`docs/metodi/ANALISI_METODO_VOLUMETRICO_DAX_V5.md` (il metodo di Claudio dietro DaxValueArea) ·
`backtest_pipeline/REGISTRO_TEST.md` (le **quattro righe nuove** sono in fondo) ·
`report/FIRME_2026-09-07.md` (pavimento di frequenza per FAMIGLIA) ·
`report/FIRME_2026-08-18.md` (criterio di uscita delle sedie)

> **Se un referto e questo dossier divergono, comanda il referto** — tranne sui numeri che questo
> dossier **ricalcola dai file grezzi e dichiara come misura nuova** (par. 1.1 le tabelle del p25,
> par. 1.2 la scala per TF, par. 1.3 la scala di `InpStopAtr`, par. 1.4 la tabella del profilo).
