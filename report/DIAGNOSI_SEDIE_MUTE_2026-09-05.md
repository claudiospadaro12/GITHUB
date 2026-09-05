# 🔇🔎 DIAGNOSI DELLE SEDIE MUTE — 05/09/2026

> **Mandato di Claudio**: _"cerchiamo di andare a fondo e capire perche' alcune
> sedie sul conto piccolo non fanno trade o ne fanno pochissimi? Proviamo TF
> diversi? Allentiamo qualche filtro?"_
>
> 🛑 **Questo referto e' DIAGNOSI, non cura.** Nessun `.mq5`, `.mqh`, `.set`
> toccato. Nessun conto vivo, nessun forward, nessuna riga di lancio. Il
> risultato e' una classificazione con le prove sotto: le riparazioni e i round
> sono firme di Claudio, dopo.

---

## 🎯 RIEPILOGO ESEGUIBILE — le tre righe che contano

### 1️⃣ **I 13 MUTI NON SONO PIU' 13. SONO 6.** E tre di loro non lo sono mai stati.

Dal 28/08 (chiusura della finestra H0) a oggi lo statement e' cresciuto fino al
**04/09 21:30**. Rileggendolo, **sette delle tredici sedie hanno la loro riga**:

| sedia | quando ha parlato | dove sta la prova |
|---|---|---|
| `772234` GapFill DOW | **31/08 01:00** | riga nello statement **+ log del funnel** letto da Claudio il 31/08 |
| `772162` BB EURUSD | **31/08 13:00** | `BB EURUSD CONT S` |
| `772163` BB AUDUSD | **31/08 12:00** | `BB AUDUSD INV L` |
| `771321` PTE DOW | **03/09 23:05** | `PTE DOW S` |
| `772341` Larry DOW | 🔴 **25/08 07:53** — **DENTRO la finestra H0** | `LARRY DOW L`, chiusa 31/08 |
| `772344` Larry GBPJPY | 🔴 **28/08 06:00** — **DENTRO la finestra H0** | `LARRY GBPJPY L`, chiusa 31/08 |
| `250604` Gold Ichimoku | ⚰️ **mai** — ed e' la scoperta piu' grossa: **la sedia non esiste** | vedi §2 |

### 2️⃣ 🚨 **DUE BUG VERI TROVATI — e NESSUNO DEI DUE E' IN UN EA.** Sono nello STRUMENTO che misura.

- 🐛 **BUG A — il censimento conta le CHIUSURE e le chiama INGRESSI.** H0 dichiara
  _"ingressi = righe raggruppate per (magic, simbolo, `open_time`, lato)"_, ma la
  fonte (`trades_auto.csv`) contiene **solo trade CHIUSI**. Una posizione **aperta
  dentro la finestra e chiusa dopo il taglio del CSV e' invisibile**.
  👉 **Larry DOW (25/08) e Larry GBPJPY (28/08) erano DENTRO la finestra e sono
  state contate a zero.** Non erano mute: erano **a mercato**. Il censimento
  penalizza sistematicamente le sedie che tengono posizioni per giorni — cioe'
  proprio quelle a bassa frequenza, cioe' proprio quelle che stiamo giudicando.
- 🐛 **BUG B — la sedia fantasma.** `250604` e' **in lista da settimane e non
  esiste in campo**: Claudio stesso l'ha rimossa a giugno, e c'e' agli atti
  (`ERRATA_R103_ICHIMOKU_2026-08-25.md`). Il censimento la conta viva per un
  **file `.chr` residuo su disco**. Aggravante: nello statement **non c'e' una
  sola riga scritta da quell'EA** (§2).

### 3️⃣ ✅ **LE 6 RIMASTE SONO BASSA FREQUENZA VERA. NON SI ALLENTA NIENTE.**

Rimisurando il silenzio sulla **finestra di osservazione REALE (dal deploy, non
dal 30/03)**, il silenzio e' l'esito **piu' probabile** per quasi tutte:

| sedia | finestra reale | attesi | P(zero) | verdetto |
|---|---:|---:|---:|---|
| `772231` GapFill GBPUSD | 23 gg (dal 13/08) | 0,46 | **63%** | 🟢 normale |
| `772232` GapFill EURUSD | 23 gg | 0,54 | **59%** | 🟢 normale |
| `772233` GapFill AUDUSD | 23 gg | 0,69 | **50%** | 🟢 normale |
| `772235` GapFill 225JPY | 23 gg | 0,92 | **40%** | 🟢 normale (+ un sospetto spread, §5) |
| `771332` PTE GBPUSD B25 | 19 gg (dal 17/08) | 1,90 | **15%** | 🟢 normale — **e il test "tagliente" si e' ribaltato** (§4) |
| `970912` SupRev DAX H4 | 38 gg | 5,07 → **2,98 corretti** | 0,6% → **5,1%** | 🟡 **l'unica con tensione vera** (§6) |

**👉 Risposta secca alle due domande di Claudio: NO, non si cambia TF e NO, non
si allentano filtri.** Non perche' sia vietato per principio, ma perche' oggi
**non abbiamo ancora una misura che dica che il filtro e' il problema** — e su
finestre da 19-38 giorni con motori da 0,6-4 op/mese **non c'e' informazione
sufficiente per giustificare un solo cambio di parametro**. La leva giusta oggi
e' **leggere i log** (costo zero, rischio zero), non toccare i motori.

### 📋 COSA FARE, in ordine

| # | azione | chi | costo |
|---:|---|---|---|
| 1 | 🧹 **Cancellare `250604` dalla lista dei muti E il `.chr` residuo dal VPS** | Claudio | 2 min |
| 2 | 🔧 **Riparare il contatore di H0** (contare gli INGRESSI includendo le posizioni ancora aperte) e ricalcolare le "op/mese non consegnate" | chi mantiene `PIANO_PROP.md` | — |
| 3 | ✅ **Chiudere come VIVE-MA-SELETTIVE**: `771321`, `772162`, `772163`, `772234`, `772341`, `772344` | referto | fatto qui |
| 4 | 👀 **Un solo controllo di campo, 3 minuti**: log Esperti di `970912` e di `772235` (§6, §5) | Claudio | 3 min |
| 5 | 🚫 **NON aprire nessun round oggi.** Le proposte di round sono in §7, coi criteri **congelati prima dei numeri**, e restano proposte | — | — |

---

## 📊 LA TABELLA MADRE — sedia per sedia, causa e prova

Categorie del mandato: **(a)** bug vero · **(b)** configurazione ambientale ·
**(c)** filtro selettivo per disegno · **(d)** EA non attaccato ·
**(e)** _[categoria aggiunta da questo referto]_ **artefatto di misura**.

| sedia | EA | causa piu' probabile | prove lette | proposta |
|---|---|---|---|---|
| **`250604`** Gold Ichimoku | `Gold_Ichimoku_TK_ATR_EA.mq5` | 🔴 **(d)+(e) SEDIA FANTASMA** — rimossa dal campo a giugno da Claudio; la lista la porta avanti per inerzia | ① `ERRATA_R103_ICHIMOKU_2026-08-25.md`: _"NON gira su nessuno dei due conti… poi rimossa. Il censimento .chr del 23/08 l'ha contata viva per un FILE GRAFICO RESIDUO"_. ② **Prova indipendente trovata in questo referto**: l'EA firma gli ordini `TK long`/`TK short` (riga 490) e nello statement **quelle stringhe compaiono ZERO volte in 1.281 righe**. ③ I 2 trade di giugno attribuiti a questa sedia portano il commento **`IchiCross long`/`IchiCross short`** = li ha scritti **`IchiCross_Gold_722.mq5`**, un EA DIVERSO che ha lo **stesso magic 250604 di default**. ④ Il motore era gia' **BOCCIATO dalla corsia rischio**: DD 21,52% a taglia 0,5% (stessa ERRATA) | 🧹 **Rimuovere la riga dalla lista muti e il `.chr` dal disco.** Non e' una riparazione: e' **pulizia d'inventario**. ⚠️ E prima che *uno qualunque* dei due EA oro torni mai in campo, **il magic 250604 va ritirato o rinumerato** (§8) |
| **`772341`** Larry DOW | `ABTG_PunteLarry.mq5` | 🟢 **(e) ARTEFATTO DI MISURA — non era muta** | **Ingresso 25/08 07:53** (`LARRY DOW L`), chiuso 31/08 → aperto **dentro** la finestra 03-28/08, invisibile al CSV dei chiusi. Poi altri 2 (31/08, 01/09). Confermata attaccata dalla foto del 03/09 | ✅ nessuna. Toglierla dalla lista |
| **`772344`** Larry GBPJPY | `ABTG_PunteLarry.mq5` | 🟢 **(e) ARTEFATTO DI MISURA — non era muta** | **Ingresso 28/08 06:00**, chiuso 31/08 → stesso meccanismo. Tutte e 6 le sedie Larry (772341-46) hanno trade | ✅ nessuna. Toglierla dalla lista |
| **`771321`** PTE DOW | `ABTG_PTE.mq5` | 🟢 **(c) bassa frequenza — HA PARLATO** | Trade **03/09 23:05** (`PTE DOW S`). Deploy **11/08** (`VIVAIO_R23_DEPLOY.md`) → finestra reale **25 gg**, non 5 mesi | ✅ nessuna riparazione. 🟡 Resta il **tagliando C3 sulla FREQUENZA**: contratto 3,2 op/mese, misurato 1 in 25 gg. Ma **tutta la famiglia PTE e' cosi'** (771322: 1 trade, 771323: 1 trade) → e' una **revisione di FAMIGLIA**, non di sedia |
| **`772162`** BB EURUSD | `ABTG_BreakingBand.mq5` | 🟢 **(c) bassa frequenza — HA PARLATO** | Trade **31/08 13:00** (`BB EURUSD CONT S`). Deploy **13/08 mattina** (`DIARIO.md`) → **23 gg**, contratto 1,0 op/mese → attesi 0,77, **P(zero)=46%** | ✅ nessuna |
| **`772163`** BB AUDUSD | `ABTG_BreakingBand.mq5` | 🟢 **(c) bassa frequenza — HA PARLATO** | Trade **31/08 12:00** (`BB AUDUSD INV L`). Stesso deploy. Attesi 0,61, **P(zero)=54%**. Anche la sorella 772161 gira (2 trade) | ✅ nessuna |
| **`772234`** GapFill DOW | `ABTG_GapFill.mq5` | 🟢 **(c) selettivita' PROVATA DAL LOG** | Trade **31/08 01:00→14:30**. Log del 31/08 gia' agli atti: `01:00 spread 1000 sopra il limite 300: rinvio (barra 2 di 3)` → `02:00 GAP-FILL BUY … gap −124.00 = 0.34 x ATR D1, barra 3 della settimana`. **Il gap ha superato la soglia 0,30 di un pelo (0,34)**: e' la prova che il filtro morde, non che e' rotto | ✅ nessuna |
| **`772231`** GapFill GBPUSD | `ABTG_GapFill.mq5` | 🟢 **(c) RARO PER DISEGNO — spiegazione strutturale** | Vedi §5. Deploy **13/08 sera** → **3 sole finestre settimanali** osservate. Attesi 0,46, **P(zero)=63%** | ✅ nessuna. 👀 conferma dal log (§5) |
| **`772232`** GapFill EURUSD | `ABTG_GapFill.mq5` | 🟢 **(c) RARO PER DISEGNO** | idem. Attesi 0,54, **P(zero)=59%** | ✅ nessuna |
| **`772233`** GapFill AUDUSD | `ABTG_GapFill.mq5` | 🟢 **(c) RARO PER DISEGNO** | idem. Attesi 0,69, **P(zero)=50%** | ✅ nessuna |
| **`772235`** GapFill 225JPY | `ABTG_GapFill.mq5` | 🟡 **(c) + sospetto (b) sulla GUARDIA SPREAD** | Attesi 0,92, **P(zero)=40%** = di per se' normale. **Ma** il Nikkei riapre in sessione asiatica e il preset R36 porta `InpMaxSpreadPts=300`: se lo spread BCM sul 225JPY sta sopra 300 punti per tutte e 3 le barre della finestra, **la settimana e' persa ogni settimana** — esattamente quello che ha rischiato di succedere al DOW il 31/08 (spread 1000 alla barra 2 su 3) | 👀 **verifica di campo a costo zero** (§5). **NON toccare la soglia prima di aver LETTO lo spread reale** |
| **`771332`** PTE GBPUSD B25 | `ABTG_PTE.mq5` | 🟢 **(c) bassa frequenza — e il test "tagliente" si e' RIBALTATO** | Vedi §4. Deploy **17/08** → **19 gg**. Attesi 1,90, **P(zero)=15%** | ✅ nessuna. 🔵 Il giudizio del duello resta **sospeso a 30 trade** |
| **`970912`** SupRev DAX H4 | `ABTG_SupRev_DAX_H4_Ottimizzato.mq5` | 🟡 **(c) — l'UNICA con tensione statistica vera** | Vedi §6 | 👀 **verifica di campo a costo zero** (§6) + 📐 proposta di round **congelata ma NON aperta** (§7) |

---

## 🥇 §2 — `250604`: la sedia che non c'e' (e il magic in doppio)

**Cosa deve succedere perche' faccia un trade** (letto in
`Gold_Ichimoku_TK_ATR_EA.mq5`): su nuova barra H1 chiusa, incrocio
Tenkan/Kijun **calcolati come Donchian** (7/22, `Donchian()` righe 236-250),
filtro nuvola attivo (`close1 > max(SenkouA, SenkouB)`), **solo long**
(`DIR_LONG_ONLY`), poi `OpenTrade()`.

**Il codice e' pulito.** Nessun input dichiarato-e-mai-letto, handle rilasciati
in `OnDeinit`, `IsNewBar()` corretto, filling adattivo, normalizzazione ai
digits. **Non c'e' un bug che spieghi il silenzio** — e non serve cercarlo,
perche' **l'EA non e' in campo**.

### 🔬 La prova nuova che chiude il caso (indipendente dall'ERRATA)

L'EA firma ogni ordine con `"TK long"` / `"TK short"` (riga 490):

```
string cmt = (type == ORDER_TYPE_BUY) ? "TK long" : "TK short";
```

Nello statement (**1.281 righe, 30/03 → 04/09**) quelle due stringhe compaiono
**zero volte**. I due trade di giugno accreditati alla sedia sono:

```
2026.06.09 20:15  XAUUSD buy  … IchiCross long  ;250604
2026.06.19 13:49  XAUUSD sell … IchiCross short ;250604
```

`IchiCross long/short` e' la firma di **`IchiCross_Gold_722.mq5`** (riga 375),
un EA **diverso** — XAUUSD **M5**, long **e** short — che ha lo **stesso
`InpMagic = 250604` di default** (riga 84). E infatti quei due trade sono
**short** e **chiusi in 1-3 minuti**: comportamento M5, non H1 long-only.

👉 **`Gold_Ichimoku_TK_ATR_EA` non ha MAI aperto un trade su questo conto.**
E la riga della sedia nel censimento del 25/08 (`censimento_rischio_2026-08-25_0731.txt`
riga 47) e' esattamente l'artefatto che l'ERRATA aveva gia' segnalato.

### ⚠️ Correzione a un sospetto plausibile ma sbagliato

`AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md` classifica questo EA **🔴 #3**
(`PositionSelect(_Symbol)` + magic, riga 672, **13 vicini su XAUUSD**).
Verificato: **quel difetto NON puo' causare mutismo.** Su conto hedging,
`PositionSelect(_Symbol)` aggancia la posizione del **vicino**, il magic non
combacia, `HasOpenPosition()` torna **false** → l'EA si crede **flat** e
**apre di piu'**, non di meno. Il difetto e' un **rischio di gestione**
(potrebbe modificare/chiudere la posizione di un altro), **non** una
spiegazione del silenzio. Va scritto per non farlo diventare la risposta
comoda.

---

## 🧪 §4 — `771332` PTE GBPUSD B25: il test piu' tagliente si e' RIBALTATO

La `CHECKLIST_SEDIE_MUTE_2026-08-31.md` (§ PTE B25) diceva:

> _"La gemella del duello (**771322**, stessi segnali d'ingresso) **ha operato**
> (1 trade il 14/08). Stesso segnale, due esiti: se la 771322 apre e la 771332
> no, il sospetto e' sul GRAFICO della 771332."_
>
> Attesa dichiarata: **771332 = probabile GUASTA**.

**La data smonta il test.** La 771332 e' stata deployata il **17/08**. L'unico
trade della gemella 771322 e' del **14/08**, cioe' **TRE GIORNI PRIMA che la
771332 esistesse**.

| | 771322 (gemella storica) | 771332 (B25) |
|---|---|---|
| trade **prima** del 17/08 | 1 (14/08) | — (non esisteva) |
| trade **dal 17/08 al 04/09** | **0** | **0** |

👉 **Nella finestra in cui il confronto e' possibile, le due gemelle hanno
esattamente lo stesso esito: zero.** Non c'e' nessuna divergenza da spiegare.
Il sospetto di guasto **non ha piu' base**: 19 giorni, 1,90 trade attesi,
**P(zero) = 15%**.

🔵 **E il giudizio di merito resta sospeso**: il duello si decide a **30 trade**
(regola di casa, valvola R59 — _"il campione sottile sospende il giudizio sul
MERITO"_). A questa frequenza servono anni, ed e' un fatto da mettere sul tavolo
del tagliando, non un motivo per toccare il motore.

---

## 🟠 §5 — GapFill: perche' i tre forex tacciono, ed e' scritto nel disegno

**Cosa deve succedere** (`ABTG_GapFill.mq5`, `StartWeek()` righe 356-399):
alla **prima barra H1 della nuova settimana** l'EA misura
`gap = weekOpen − venClose` e lo confronta con l'ATR(D1):

```
if(InpGapMinATR>0.0 && ag < InpGapMinATR*atr)   →  cW_min++ , settimana persa
if(InpGapMaxATR>0.0 && ag > InpGapMaxATR*atr)   →  cW_max++ , settimana persa
```

Con `InpGapMinATR = 0,3`: **serve un gap del weekend pari ad almeno il 30%
dell'ATR giornaliero.** Su GBPUSD/EURUSD/AUDUSD, con ATR(D1) tipico intorno a
80-100 pip, vuol dire **25-30 pip di salto fra la chiusura del venerdi' e la
riapertura della domenica**. Sui major **non succede quasi mai** — e la soglia
esiste apposta, il commento nel sorgente lo dice: _"Sotto, lo spread si mangia
tutto"_.

Gli **indici** invece gappano davvero, ed e' esattamente cio' che si e' visto:
il DOW ha sparato il 31/08 con `gap −124.00 = **0,34 x ATR D1**` — **appena
sopra la soglia 0,30**. Il filtro non e' rotto: e' **al limite**, come da
progetto.

📐 **E la finestra di osservazione e' minuscola**: deploy **13/08 sera**
(`DIARIO.md`), primo appuntamento la riapertura del 17/08 → **3 sole occasioni**
(17/08, 24/08, 31/08). Un motore ha al massimo **3 colpi possibili** in tutto.
Chiamarlo muto e' come dire che un dado e' rotto perche' in tre lanci non ha
fatto sei.

> ⚠️ **Correzione da mettere agli atti**: la colonna "Zero da (misurato)" della
> checklist del 31/08 dice **"sempre (mai 1 riga nello statement)"** per tutti e
> cinque i GapFill. E' vero alla lettera e **fuorviante nella sostanza**: lo
> statement parte dal 30/03, ma **la famiglia esiste dal 13/08**. La finestra
> reale e' **23 giorni / 3 weekend**, non 5 mesi.

### 👀 La verifica di campo, costo zero, per `772235` (Nikkei)

L'EA ha `InpVerbose = true` e **logga OGNI settimana il motivo dello scarto**
con la frase esatta (righe 386, 393, 423). Quindi sul VPS, scheda **Esperti**
filtrata su `ABTG_GapFill` **(225JPY,H1)**, alle righe del lunedi' si legge una
di queste tre:

| riga nel log | significato | verdetto |
|---|---|---|
| `gap … (0.NN x ATR) sotto il minimo 0.30 x ATR` | il mercato non ha gappato | 🟢 **(c) selettivita' vera** — chiuso |
| `spread NNNN points sopra il limite 300 … finestra esaurita` | 🔴 **la guardia spread brucia la settimana** | 🟡 **(b) taratura ambientale** — apre il discorso di §7 |
| **nessuna riga il lunedi'** | l'EA non valuta | 🔴 **(d) guasta** — riparazione |

🛑 **E qui la regola di casa va detta forte**: se il log dicesse "spread",
la tentazione sarebbe alzare `InpMaxSpreadPts`. **NO.** Prima si **MISURA lo
spread reale** del 225JPY alle barre di riapertura (e' scritto nel log stesso,
in chiaro: `spread 1000 points`), poi si decide **con un numero in mano** se
300 e' la soglia sbagliata. **Misura prima, parametro dopo** — mai il contrario.

---

## 🌊 §6 — `970912` SupRev DAX H4: l'unica con una tensione statistica vera

**Cosa deve succedere** (`OnNewBar()`, righe 168-222) — **sei** condizioni in AND
sulla nuova barra H4:

1. nessuna posizione **e** nessun pendente del magic (`HasPosition`/`HasPending`);
2. il Supertrend **non ha girato**: `dir[2] == dir[1]` (continuazione, non flip);
3. **tocco**: l'ombra della barra [2] viola la linea Supertrend;
4. **chiusura vicina**: la [2] richiude dalla parte giusta **entro `InpNearAtr` = 1,0 × ATR**;
5. **apertura dentro**: la barra [1] apre oltre la linea, con **corpo coerente** (`InpRequireConfirmBody = true`);
6. **confluenza EMA**: il livello del rimbalzo dista **≤ 1,5 × ATR** da almeno una fra **EMA 14 / 89 / 100 / 200** (`ConfluenceOK`, riga 226).

✅ **Nessun bug.** `HasPosition()` e `HasPending()` (righe 435, 472) ciclano su
**tutte** le posizioni/ordini filtrando **simbolo + magic** → **hedging-safe**,
coerente con l'audit che mette questo EA nella lista 🟢. `InpTF=16388` nel
preset = **PERIOD_H4**, giusto. Il TF del grafico fotografato il 03/09 e' **H4**,
giusto. Nessun filtro orario attivo (`InpUseTimeWindow=false`). E il **1/3 va
sempre a MERCATO** (riga 267): **un segnale produce SEMPRE almeno una riga nello
statement** → qui **zero trade = zero segnali**, senza ambiguita' da pendenti
scaduti.

### 🔢 Ma il contratto promette 4 op/mese, e a 38 giorni P(zero) = 0,6%

Due correzioni, entrambe misurate, che sgonfiano la tensione **senza cancellarla**:

**🅰️ Il contratto conta i DEAL, non i SEGNALI.** L'EA entra **frazionato**:
1/3 a mercato + 2/3 su pendente stop. Nello statement questo si vede nero su
bianco:

```
970911 D30EUR 2026.07.29 07:00  STREV DAX H1 L 1/3
970911 D30EUR 2026.07.29 07:00  STREV DAX H1 L 2/3   ← stesso segnale, seconda riga
```

Sulla famiglia viva il rapporto misurato e' **~1,67 righe per segnale**
(970916 DOW H1: 5 righe = 3 segnali). Se i **"86 tr"** del contratto sono deal
di backtest, i segnali promessi sono **~2,4/mese, non 4,0** → attesi **2,98**,
**P(zero) = 5,1%**. Improbabile, non anomalo.

**🅱️ Su H4 la famiglia e' DAVVERO 4 volte piu' lenta, ed e' misurato in casa:**

| sedia | TF | trade nello statement (dal 29/07) |
|---|---|---:|
| `970913` SupRev NAS | **H1** | **6** |
| `970916` SupRev DOW | **H1** | **5 righe / 3 segnali** |
| `970911` SupRev DAX | **H1** | 2 righe / **1 segnale** |
| `970915` SupRev CAC | **H4** | 2 righe / **1 segnale** |
| **`970912` SupRev DAX** | **H4** | **0** |

👉 Le due sedie **H4** della famiglia fanno **1 e 0** segnali; le **H1** fanno
**3 e 6**. Il TF piu' alto quarta le barre e quindi le occasioni: e' aritmetica,
non guasto. **`970912` e' la piu' lenta di una coppia gia' lenta.**

### 👀 La verifica di campo, costo zero (e la sola cosa da fare adesso)

`InpVerbose = true` → sul VPS, scheda **Esperti** filtrata
`[STReversal]` **(D30EUR,H4)**:

| cosa si legge | dove si e' fermato l'imbuto | verdetto |
|---|---|---|
| `nessuna confluenza EMA vicina: skip.` (riga 220) | 🎯 **il pattern arriva, la confluenza lo boccia** | apre il round di §7 |
| **nessuna riga di skip in settimane** | il pattern (tocco+chiusura+conferma) **non si e' mai formato** | 🟢 **(c) chiuso** — nessun round |
| `SL troppo vicino: skip.` / `lotto nullo.` | 🔴 problema **di taratura ambientale (b)** | riparazione mirata |
| **nessuna riga di nessun tipo** | 🔴 **(d)** non gira | riparazione |

🛑 **Finche' non si sa QUALE riga c'e', qualunque discorso su `InpConflAtr` o
`InpNearAtr` e' pescare.** Un solo screenshot della scheda Esperti risolve una
domanda che nessun backtest puo' rispondere.

---

## 📐 §7 — LE PROPOSTE DI ROUND: congelate PRIMA dei numeri, e **NON aperte oggi**

> **Perche' sono qui e non in esecuzione.** La domanda di Claudio (_"proviamo TF
> diversi? allentiamo qualche filtro?"_) e' legittima, ma la regola di casa dice
> che **un filtro si allenta solo dopo aver rimisurato la cella con un vero passo
> 0**, mai "per farla sparare di piu'". E l'**emendamento della finestra
> (regola A)** dice che l'unita' di misura e' **l'OPERAZIONE (≥150), non l'anno**.
> Scrivo i criteri adesso, **prima** di vedere qualunque numero, cosi' che il
> risultato ci possa giudicare.

### 🎯 PROPOSTA R-A — `SupRev DAX H4`: quale filtro e' il collo di bottiglia?

- 🚦 **CONDIZIONE DI APERTURA (non negoziabile)**: si apre **SOLO SE** il log di
  campo (§6) mostra `nessuna confluenza EMA vicina: skip.` con **frequenza
  significativa**. Se il log dice che il **pattern** non si forma, il round
  **non si fa**: allargare la confluenza non crea tocchi che non ci sono.
- 🔬 **Cosa si misura**: griglia **a due assi soli**
  `InpConflAtr ∈ {1,0 · 1,5 · 2,0 · 2,5}` × `InpNearAtr ∈ {0,75 · 1,0 · 1,25}`
  = 12 celle. **`InpTF` NON entra nella griglia** (cambiare TF e' un altro
  motore, non un'altra taratura — e va confrontato **a parte**, contro l'H1 che
  in famiglia **esiste gia'** come `970911`).
- 📏 **Dimensionamento IS (regola A)**: **≥150 operazioni** in-sample. A ~2,4
  segnali/mese su H4 servono **~5 anni**. ✅ Vincolo tester verificato: H4 = 6
  barre/giorno → 5 anni ≈ **7.800 barre**, larghissimamente sotto il tetto delle
  100.000 (il tetto morde su M15/M5, non qui).
- 🧭 **Regola di selezione, dichiarata prima**: **centro dell'altopiano, MAI il
  picco.** Se la superficie e' frastagliata → **campione insufficiente, si
  sospende**, non si sceglie.
- ⚖️ **Regola B**: la finestra vecchia giudica il **RISCHIO** (il DD e' un fatto
  accaduto), la recente il **MERITO**. Il contratto porta gia' un ⚠️ (**PFmed
  reale 1,05, "marginale"**): se il round non alza il merito **oltre** la
  marginalita', **la conclusione onesta e' il tagliando C3 — spegnere — non una
  cella nuova**.
- 🛑 **Criterio di scarto scritto prima**: si tiene **solo** se migliora
  **l'INSIEME degli anni**. Se aggiusta un anno e ne rovina altri → curve
  fitting, si butta.

### 🚫 PROPOSTA R-B — GapFill forex: **NON e' un candidato a round.** (proposta negativa, ed e' voluta)

Abbassare `InpGapMinATR` sotto 0,3 sui major farebbe entrare la sedia su gap da
5-10 pip, cioe' **esattamente dove lo spread se li mangia** — che e' la ragione
**dichiarata nel sorgente** per cui la soglia esiste. Sarebbe comprare frequenza
pagandola in aspettativa negativa: **il contrario di un miglioramento.**

Se un giorno servisse piu' portata da questa famiglia, la leva onesta **non e'
la soglia**: e' **il paniere di simboli** (gli indici gappano, i major no — il
DOW l'ha appena dimostrato). E anche quella **si misura**, non si decide.

### ⏸️ PROPOSTA R-C — PTE (`771321` · `771332` · e famiglia): **niente round, tagliando**

La famiglia PTE promette 3,0-3,2 op/mese e ne misura **~0,2** su **tre** sedie
indipendenti. Non e' un problema di una sedia: e' un **contratto scritto su una
frequenza che il forward non conferma**. La corsia giusta e' il **TAGLIANDO
(6 mesi)** del criterio di uscita delle sedie — _"frequenza molto sotto il
promesso → revisione"_ — **non** una griglia sui filtri d'ingresso.

---

## 🧯 §8 — RILIEVO DI SICUREZZA trovato per strada (non riguarda il mutismo)

🔴 **Il magic `250604` e' il default di DUE EA diversi**:

| file | riga | simbolo/TF di progetto | direzioni |
|---|---:|---|---|
| `mql5/Experts/Gold_Ichimoku_TK_ATR_EA.mq5` | 109 | XAUUSD **H1** | solo long |
| `mql5/Experts/IchiCross_Gold_722.mq5` | 84 | XAUUSD **M5** | long + short |

Oggi e' innocuo (**nessuno dei due e' in campo**). Diventa pericoloso **il
giorno in cui uno dei due torna**: entrambi riconoscono "la propria" posizione
**dal solo magic** (`Gold_Ichimoku` riga 674, `IchiCross` riga 524). Se
girassero insieme, **ciascuno gestirebbe e chiuderebbe la posizione dell'altro**.

👉 **Non serve fare niente adesso.** Serve che sia **scritto**: prima di
ridispiegare *uno qualunque* dei due, il magic va **ritirato o rinumerato**.
(Stessa classe della collisione `770901` gia' trovata nel censimento del 22/08 §5.)

---

## 📎 LIMITI DICHIARATI DI QUESTO REFERTO

1. 🔵 **Nessuna lettura diretta del VPS.** Tutto viene da: sorgenti `.mq5` in
   repo, `data/statements/trades_auto.csv` (1.281 righe, **30/03 → 04/09 21:30**),
   preset in repo, e i referti citati. **Le due verifiche di §5 e §6 richiedono
   Claudio davanti al terminale** e nessuno le puo' fare da qui.
2. 🔵 **Lo statement contiene solo trade CHIUSI.** Una sedia con una posizione
   **aperta adesso** apparirebbe muta anche in questo referto. E' il **BUG A**
   applicato a me stesso: dichiarato, non nascosto.
3. 🔵 **I P(zero) sono Poisson su frequenza da contratto.** Servono a dire
   _"questo silenzio e' sorprendente o no"_, **non** a promuovere o bocciare
   nessuno. Se la frequenza del contratto e' sbagliata (e su `970912` **lo e'
   quasi certamente**, §6🅰️), il P(zero) e' sbagliato con lei.
4. 🔵 **Le date di deploy** vengono da `DIARIO.md` (13/08 BB/GapFill/Larry),
   `VIVAIO_R23_DEPLOY.md` (11/08 PTE) e dalla checklist del 31/08 (17/08 per la
   771332). `970912` e' stimata **~29/07** dalla prima attivita' delle sorelle:
   e' l'unica finestra **inferita**, ed e' quella della sedia piu' in tensione.
5. 🔵 **La discrepanza aritmetica di H0 non e' risolta qui**: H0 dice che i 13
   muti valgono **21,0 op/mese**, ma la somma della colonna "Op/mese promesse"
   di `CONTRATTI_SEDIE.md` sulle stesse 13 sedie fa **28,5**. Non so quale delle
   due sia giusta e **non l'ho indovinata**: il ricalcolo (dopo aver tolto
   `250604`, `772341`, `772344`) spetta a chi mantiene `PIANO_PROP.md`.
6. 🔵 **Nessun `.mq5` / `.mqh` / `.set` e' stato modificato**, come da mandato.
