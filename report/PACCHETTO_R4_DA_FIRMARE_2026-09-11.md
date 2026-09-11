# ✍️ PACCHETTO R4 — LA FIRMA DEL MATTINO DELL'11/09/2026

**Preparato il 10/09/2026 · branch `lavoro` · da firmare UNA VOLTA SOLA.**
**Oggetto:** ricompilare e ricaricare **15 sorgenti gia' corretti** perche' il
requisito **R4** (*rischio VERO = rischio DICHIARATO*) smetta di essere una
promessa e diventi un fatto sui terminali.

> 🛑 **QUESTO DOCUMENTO NON CAMBIA NIENTE.** Nessun `.mq5`, nessun `.set`,
> nessun parametro, nessun terminale e' stato toccato per scriverlo. **Le taglie
> e il rischio sono firma di Claudio; il conto reale 10105439 e' suo e basta.**
> Qui c'e' **la decisione scritta**, non il cambiamento.

---

# 🔴 PRIMA DI TUTTO: UNA CORREZIONE AL PIANO, ED E' LA COSA PIU' IMPORTANTE DELLA PAGINA

`PIANO_CHALLENGE_OTTOBRE.md` §1.2 dice che il difetto e' *"di due righe di
codice, gia' individuato e **non applicato**"*.

## ✅ **NON E' PIU' VERO. IL FIX E' GIA' NEI SORGENTI DA DUE GIORNI.**

Commit **`872dba8`, 08/09/2026** — verificato adesso, file per file, non citato:
tutti e **15** i sorgenti hanno l'ordine corretto `lotMkt -> pavimento ->
lotPend`, con la versione alzata **1.00 -> 1.01**.

```
$ per ogni file: riga di  if(lotMkt<=0)  vs riga di  double lotPend=NormVol(...)
FIXED  floor=271 pend=272  ABTG_SupRev_CAC_H4_Ottimizzato.mq5
FIXED  floor=271 pend=272  ABTG_SupRev_DAX_H1_Ottimizzato.mq5
FIXED  floor=271 pend=272  ABTG_SupRev_DAX_H4_Ottimizzato.mq5
FIXED  floor=271 pend=272  ABTG_SupRev_DOW_H1_Ottimizzato.mq5
FIXED  floor=271 pend=272  ABTG_SupRev_DOW_H4_Ottimizzato.mq5
FIXED  floor=271 pend=272  ABTG_SupRev_NAS_H1_Ottimizzato.mq5
FIXED  floor=263 pend=264  ABTG_SuperWave.mq5
FIXED  floor=263 pend=264  ABTG_SuperWave_DAX_H4_Ottimizzato.mq5
FIXED  floor=263 pend=264  ABTG_SuperWave_DOW_H1_Ottimizzato.mq5
FIXED  floor=284 pend=285  ABTG_SupertrendReversal.mq5
FIXED  floor=274 pend=275  ABTG_SupertrendReversal_Multi.mq5
FIXED  floor=274 pend=275  ABTG_SupertrendReversal_Multi_Ottimizzato.mq5
FIXED  floor=270 pend=271  ABTG_SupertrendReversal_Ottimizzato.mq5
FIXED  floor=256 pend=257  standalone/ABTG_SupertrendReversal.mq5
FIXED  floor=260 pend=261  standalone/ABTG_SupertrendReversal_Multi.mq5
```

**15 su 15 corretti. Zero da correggere.** 👉 **Quello che Claudio firma domani
NON e' una modifica al codice: e' una COMPILAZIONE (F7) e un RICARICO.** Sui
terminali gira l'`.ex5`, non il `.mq5`: finche' non si ricompila, il codice che
rischia e' ancora quello vecchio.

🟢 **La buona notizia dentro la correzione:** il lavoro pericoloso (toccare 15
sorgenti di sizing) **e' gia' fatto, gia' verificato e gia' su GitHub**. Resta il
passo che costa **dieci minuti**, non una giornata.

---

# 🏛️ SEZIONE 0 — IL CONTO REALE **10105439**, IN CIMA PERCHE' E' LA FIRMA PIU' PESANTE

## ✅ **DI QUANTO CAMBIA LA TAGLIA SUL REALE? DI ZERO. E si dimostra per nome.**

Sul reale girano **due sedie sole**:

| sedia | magic | simbolo | EA | e' fra i 15 file? |
|---|---:|---|---|---|
| DAX Apertura EU | **770101** | D30EUR M5 | `ABTG_DAX_Apertura_EU.mq5` | ❌ **NO** |
| ORB Ottimizzato | **770611** | U30USD M5 | `ABTG_ORB_Ottimizzato.mq5` | ❌ **NO** |

I 15 file corretti sono **tutti e soli** della famiglia
`SuperWave` / `SupertrendReversal` / `SupRev_*` (elenco per nome in §5).
👉 **Nessuno dei due EA del reale e' toccato da questo pacchetto: taglia
invariata, rischio invariato, 0,65% prima e 0,65% dopo.**

## 🔴 MA IL PERICOLO SUL REALE ESISTE, E NON E' IL FIX: E' IL GESTO

⚠️ **Il rischio non e' cosa cambia il fix. E' cosa potrebbe cambiare Claudio
mentre lo applica.** Tre trappole misurate, tutte e tre sul terminale
**10105439**, cartella **`C:\BCM_Reale`**:

| # | trappola | numero misurato | fonte |
|---|---|---|---|
| **T1** | 🔥 un **"Compila tutto"** in MetaEditor ricompila **anche** i due EA del reale, i cui sorgenti sono cambiati il **02/09** (`ABTG_DAX_Apertura_EU`, fix C4) e il **03/09** (`ABTG_ORB_Ottimizzato` v1.04). Il binario in campo potrebbe essere **piu' vecchio del sorgente**: ricompilare cambierebbe il comportamento **senza che nessuno l'abbia deciso** | `git log`: `9638318` 02/09 · `19312c8` 03/09 | verificato ora |
| **T2** | 🔥 un **RIPRISTINA che perde il preset** riporta le due sedie al default compilato **1.0** *e* riapre `InpAllowShort=true` → **2,00% per sedia** invece di 0,65% = **3,08x**, e **4,00% sul conto** = **sopra il cap C1 di 3,25%** | `CENSIMENTO_RISCHIO_VERO_2026-09-10.md`, righe REALE, colonna `xRes` | misurato |
| **T3** | 🔥 se qualcuno compilasse la copia **`mql5/Experts/standalone/ABTG_DAX_Apertura_EU.mq5`** (riga 33: `#define ABTG_DEF_RISK 2.0`, **non allineata** al fix C4) il reale andrebbe a **4,00% per sedia** dopo un Ripristina | `CENSIMENTO_RISCHIO_VERO_2026-09-10.md` §conto reale, punto 2 | letto nel sorgente |

## 🟢 LA RACCOMANDAZIONE SUL REALE, in una riga

> ### 🔒 **NON APRIRE MetaEditor sul terminale 10105439 (`C:\BCM_Reale`). NON toccare le sedie 770101 e 770611. La compilazione si fa sulla macchina che serve il PICCOLO 50503392 e il 100k 50504263.**

Se per un motivo qualsiasi il reale dovesse essere toccato, **prima** si fotografa
la configurazione delle due sedie (`config_in_uso.ps1`), **poi** si tocca.
🔴 E vale la regola di casa dei terminali multipli: **conto in chiaro + cartella
in chiaro**, mai riconoscere la finestra a occhio.

---

# 🧮 SEZIONE 1 — LA TABELLA SEDIA PER SEDIA

**Fonte del "gira":** `backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260910_033002.log`
**Fonte delle righe:** i `.mq5`, letti adesso.
**Fonte del "morde":** vedi la formula qui sotto — e' aritmetica, non opinione.

## 📐 LA FORMULA CHE DECIDE TUTTO (e che nessun referto precedente aveva scritto)

Il difetto vive **solo** quando la tranche a mercato normalizza a zero:

> ### `il bug morde  ⟺  totLot × 0,3333 < volMin  ⟺  totLot < 3 × volMin`

E l'effetto **non e' sempre 2x**. Dipende da quanti passi di lotto sta `totLot`:

| `totLot` | volume PRIMA | volume DOPO | **fattore vero** | la gamba pendente? |
|---|---|---|---:|---|
| `= 1 × volMin` | `2 × volMin` | `1 × volMin` | 🔥 **2,00x** | ❌ **sparisce** |
| `= 2 × volMin` | `3 × volMin` | `2 × volMin` | **1,50x** | ✅ resta |
| `= 2,9 × volMin` | `3,9 × volMin` | `2,9 × volMin` | **1,34x** | ✅ resta |
| `>= 3 × volMin` | `totLot` | `totLot` | ✅ **1,00x — nessun cambio** | ✅ resta |

🔴 **Conseguenza che cambia la tabella del piano: il "2,00x" vale SOLO per le
sedie che stanno esattamente al lotto minimo. Le altre valgono meno, e alcune
valgono ZERO.** Ripetere "2x" su tutte le righe manderebbe Claudio a firmare
la cosa sbagliata — ed e' esattamente il difetto contro cui e' nata la regola
del 10/09.

## 🪑 LE 7 SEDIE VIVE CHE MONTANO UNO DEI 15 EA

Saldi usati: piccolo **5.344,34 EUR** · 100k **103.025,49 EUR** (censimento 10/09).

### 🟡 TERMINALE PICCOLO — conto **50503392** — `C:\Program Files\BCM Markets MT5 Terminal` — profilo `ORO`

| # | EA · magic | sym · TF | risk **dichiarato** | risk **VERO** | **fattore** | file : righe del difetto | il bug **morde**? |
|---:|---|---|---:|---:|---:|---|---|
| 1 | `ABTG_SuperWave_DOW_H1_Ottimizzato` · **770511** | U30USD H1 | **1,00%** | 🔥 **~1,42%** | 🔥 **2,00x** *(volume)* | `ABTG_SuperWave_DOW_H1_Ottimizzato.mq5:263-264` | ✅ **SI — MISURATO IN CAMPO** |
| 2 | `ABTG_SuperWave` · **770531** | U30USD H4 | **1,00%** | 🔥 **~2,00%** | 🔥 **2,00x** | `ABTG_SuperWave.mq5:263-264` | ✅ **SI** (stesso simbolo, stesso volMin, stop **piu' largo** su H4 → `totLot` ancora piu' basso) |
| 3 | `ABTG_SupertrendReversal_Ottimizzato` · **970901** | XAUUSD H4 | **1,00%** | 🔥 **2,00%** | 🔥 **2,00x** | `ABTG_SupertrendReversal_Ottimizzato.mq5:270-271` | ✅ **SI** — gamba osservata a **0,01 lotti** = `volMin` esatto (DIARIO 28/08) |
| 4 | `ABTG_SupRev_DAX_H4_Ottimizzato` · **970912** | D30EUR H4 | **1,00%** | 🟠 **1,50-2,00%** | 🟠 **1,50-2,00x** | `ABTG_SupRev_DAX_H4_Ottimizzato.mq5:271-272` | 🟠 **PROBABILE, non misurato** — `volMin` 0,10 noto (R114), **distanza di stop di questa sedia NON misurata** |
| 5 | `ABTG_SupRev_NAS_H1_Ottimizzato` · **970913** ⭐ | NASUSD H1 | **1,00%** | 🟠 **1,34-2,00%** | 🟠 **1,34-2,00x** | `ABTG_SupRev_NAS_H1_Ottimizzato.mq5:271-272` | 🟠 **PROBABILE, non misurato** — 🔴 **`SYMBOL_VOLUME_MIN` di NASUSD NON E' MAI STATO MISURATO** (R114 copre solo U30USD, D30EUR, XAUUSD) |
| 6 | `ABTG_SupertrendReversal` · **770924** | 225JPY H2 | **1,00%** | ✅ **1,00%** | ✅ **1,00x** | `ABTG_SupertrendReversal.mq5:284-285` | ❌ **NO — E CONTRADDICE IL CENSIMENTO DEL 10/09.** Vedi §6, contro-esempio 2 |

### 🟠 TERMINALE 100K — conto **50504263** — `C:\Program Files\BCM Markets MT5 Terminal -V3` — profilo `SQUADRA 100K`

| # | EA · magic | sym · TF | risk **dichiarato** | risk **VERO** | **fattore** | file : righe | il bug **morde**? |
|---:|---|---|---:|---:|---:|---|---|
| 7 | `ABTG_SupertrendReversal` · **770901** | 225JPY H2 | **0,65%** | ✅ **0,65%** | ✅ **1,00x** | `ABTG_SupertrendReversal.mq5:284-285` | ❌ **NO** — gamba osservata a **6,90 lotti** (DIARIO 28/08): `totLot` e' 60+ volte `volMin`. Concorda col contro-esempio 2 del 10/09 |

### 🏛️ TERMINALE REALE — conto **10105439** — `C:\BCM_Reale`
> ## ✅ **ZERO SEDIE COLPITE. ZERO CAMBIO DI TAGLIA.** (§0)

## 🔧 IL DIFF PROPOSTO — ed e' gia' scritto, va solo compilato

**Prima** (il codice che gira **oggi** sui terminali):
```mql5
double lotMkt=NormVol(totLot*InpFirstFraction);
double lotPend=NormVol(totLot-lotMkt);                              // <- calcolato PRIMA
if(lotMkt<=0) lotMkt=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);   // <- il pavimento DOPO
```
**Dopo** (il codice che sta **gia' nel repo** dal commit `872dba8`):
```mql5
double lotMkt=NormVol(totLot*InpFirstFraction);
if(lotMkt<=0) lotMkt=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);   // <- il pavimento PRIMA
double lotPend=NormVol(totLot-lotMkt);                              // <- il resto DAVVERO
```

### ⚠️ **"E' un fix di due righe" — VERO A META', e la meta' vera va detta**
- ✅ **Vero:** le righe di **logica** scambiate sono **due**, e sono queste. Nessun
  `if` nuovo, nessuna funzione nuova, nessun parametro nuovo. Il caso limite
  (`lotPend = 0`) e' gia' coperto dalla guardia **preesistente**
  `if(InpUsePending && lotPend>0)`, verificata presente in tutti e 15 i file.
- 🔴 **Falso:** il **diff** e' di **13 righe per file** (2 di logica + 9 di
  commento + versione), e i file sono **15**. `git show --stat 872dba8` →
  **404 inserzioni, 30 cancellazioni**. Chiamarlo "due righe" fa sembrare
  l'intervento piu' piccolo di quello che e': **tocca 15 sorgenti di sizing**.
- 🔴 **E soprattutto:** il fix **cambia i numeri di backtest** di questi motori.
  Non e' cosmetico. §3 e §6.

---

# 📏 SEZIONE 2 — QUANTE SEDIE PASSANO **R4** DOPO IL FIX

## 🚨 IL PIANO DICE "**da 1 a 5**". **L'HO RIFATTO SEDIA PER SEDIA. NON E' 5.**

I quattro requisiti (`PIANO_CHALLENGE_OTTOBRE.md` §1.1): **R1** cella promossa ·
**R2** DD di backtest dichiarato · **R3** frequenza misurata · **R4** rischio
vero = dichiarato.

| # | candidata · magic | R1 | R2 | R3 | **R4 OGGI** | **R4 DOPO IL FIX** | **passa tutti e 4 dopo?** |
|---:|---|:---:|:---:|:---:|:---:|:---:|---|
| 1 | `ORB_Ottimizzato` **770611** 🏛️ | ✅ | ✅ | ✅ | ✅ | ✅ *(fix non la tocca)* | ✅ **SI — e passava gia' ieri** |
| 2 | `DAX_Apertura_EU` **770101** 🏛️ | ✅ | ~~🔴 conflitto R83 vs R119~~ ✅ 🆕 **CHIUSO 11/09** — **4,3501% @0,65%**, dep. **10.000 EUR**, tick | ✅ | ✅ | ✅ *(non la tocca)* | ~~❌ **NO — la blocca R2, non R4**~~ → 🆕 ✅ **SI, ALLA LETTERA DEI QUATTRO** (R2 era l'unico requisito rotto ed e' stato chiuso **da una lettura d'archivio, non da questa firma**). 🔴 **MA NON E' UN VIA LIBERA, e per due motivi misurati**: **(a)** il **quinto** requisito, il **cancello del costo** (`R5 >= 40x`), la boccia — **33,0x sulla geometria VIVA**; **(b)** il DD promesso e' **[MISURATO a deposito 10.000 EUR]** e su un banco da **100.000 EUR** e' **[NON MISURATO]** (+7,8% misurato sul solo effetto deposito). 📄 `CONFLITTO_DD_770101_2026-09-11.md` |
| 3 | `Dow_Apertura_US` **770202** | ✅ | ✅ | ✅ | 🔴 nessun preset su file | 🔴 **invariato** | ❌ **NO — serve un `.set`, non una compilazione** |
| 4 | `MaxMinNotte_DAX_Short_Ott` **770411** | ✅ | ✅ | ✅ | 🟠 2 pendenti opposti | 🟠 **invariato** | ❌ **NO — altro difetto, il fix non lo tocca** |
| 5 | `SupertrendReversal` **770901** | ✅ | ✅ | ✅ | ✅ *(il bug non morde a 100k)* | ✅ *(nessun cambio)* | ✅ **SI — e passava gia' ieri** |
| 6 | `SupRev_NAS_H1_Ott` **970913** ⭐ | 🟠 etichetta `REGISTRO_TEST`, non cella promossa | 🟠 **deposito NON DICHIARATO** | ✅ | 🔴 | ✅ **guadagnata** | 🟠 **NO in senso stretto** — R4 si', R1 e R2 no |
| 7 | `SuperWave_DOW_H1_Ott` **770511** | 🟠 etichetta `REGISTRO_TEST` | 🟠 **deposito NON DICHIARATO** | ✅ | 🔴 | ✅ **guadagnata** | 🟠 **NO in senso stretto** — R4 si', R1 e R2 no |
| 8 | `EMA200` **771531** 🚄 | ✅ | ✅ | ✅ 1,55 op/g | 🟠 pavimento **per gamba** (`:357`) | 🟠 **invariato** | ❌ **NO — altro difetto, il fix non lo tocca** |

## 🔢 IL CONTO VERO, con la regola di lettura dichiarata PRIMA

| lettura | oggi | **dopo il fix** | delta |
|---|---:|---:|---:|
| 🔴 **STRETTA** — R1/R2/R3/R4 tutti e quattro ✅ pieni | ~~2~~ 🆕 **3** | 🔴 ~~2~~ 🆕 **3** | **+0** |
| 🟠 **LARGA** — si accetta R1 🟠 (`REGISTRO_TEST`) e R2 🟠 (deposito ignoto) | ~~2~~ 🆕 **3** | 🟠 ~~4~~ 🆕 **5** | **+2** |

> ### 🆕 **PERCHE' I NUMERI SONO SALITI DI UNO (11/09 sera)**
> La **`770101`** entra nella lettura STRETTA: il suo unico requisito rotto era
> **R2**, e il conflitto di DD **e' stato chiuso** (**4,3501% @0,65%**, dep.
> **10.000 EUR**, tick — `report/CONFLITTO_DD_770101_2026-09-11.md`).
> 🔴 **Ma NON grazie a questa firma**: e' stata una **lettura d'archivio**, e il
> **delta della firma resta +0**, che e' esattamente cio' che questa pagina
> sostiene. ⚠️ E il conto dei quattro requisiti **non include il cancello del
> costo (R5)**, che la `770101` **non passa** (**33,0x** contro 40x richiesti),
> ne' l'asterisco del deposito (**a 100.000 EUR il DD promesso e'
> `[NON MISURATO]`**). **Tre sedie che passano quattro requisiti non sono tre
> sedie schierabili.**

> ## 🔴 **LA RIGA CHE CLAUDIO DEVE LEGGERE: il numero "5" del piano NON ESCE IN NESSUNA DELLE DUE LETTURE.**
> Il massimo raggiungibile con questa firma e' ~~**4**~~ 🆕 **5**, e solo
> abbassando due requisiti — 🔴 **e ci si arriva solo perche' una sedia e'
> rientrata da sola, non per effetto della firma**. **Con i requisiti come sono
> scritti, la firma di domani porta le schierabili da ~~2 a 2~~ 🆕 3 a 3: il
> delta e' e resta ZERO.**

### 😐 E allora perche' firmarla lo stesso? Tre motivi, tutti veri

1. 🛡️ **Perche' toglie rischio VERO da tre sedie vive, subito.** 970901, 770511 e
   770531 oggi rischiano **il doppio** di quello che il Guardian e il cap C1
   contano. Questo e' un fatto misurato in campo (**1,42% su un contratto da
   1,0%**, DIARIO 20/08), non un'ipotesi. **Il rischio non aspetta ottobre.**
2. 🔓 **Perche' sblocca R4 su 970913 e 770511**, cioe' i **due candidati piu'
   prop-friendly del parco** (`n = 155` e `n = 227`, MERITO PIENO). Dopo la
   firma quello che li blocca non e' piu' un bug: e' **un round di validazione**,
   che e' lavoro che sappiamo fare.
3. ⏱️ **Perche' costa dieci minuti** e il lavoro pericoloso e' gia' fatto.

### 🔴 E la cosa che va detta con altrettanta forza: **la firma di domani non e' la strada per le 5 sedie.** Le altre tre passano solo con:
- ~~**770101** → attribuire il conflitto **R83 (6,89%) vs R119 (4,35%)**;~~ ✅ 🆕 **FATTO l'11/09**: la causa e' **`InpAllowShort` 1 contro 0** (R83 aveva il lato corto acceso, a taglia 1,0%, magic 777120/777121). **DD promesso = 4,3501% @0,65%**, ⚠️ **[MISURATO a deposito 10.000 EUR]** — su banco **100.000 EUR** e' **[NON MISURATO]** (+7,8% misurato sul solo effetto deposito: 7,2328% contro 6,7111% a parita' di 270 operazioni). 🔴 **Ma questo NON sblocca la sedia**: il conflitto era un buco di MISURA, non di R4 — la `770101` aveva gia' **R4 verificata** e resta ferma su cio' che le manca altrove. 📄 `report/CONFLITTO_DD_770101_2026-09-11.md`;
- **770202** → **scrivere un `.set`** con `InpRiskPercent=0.65` e `InpAllowShort=false`;
- **771531 EMA200** → misurare `S*` (`volMin` + valore punto) e sapere se il
  pavimento per gamba morde a 100k.
👉 **Nessuna delle tre e' una compilazione. Sono tre lavori separati**, e due
costano meno di un'ora.

---

# ⚠️ SEZIONE 3 — IL CONTO DI **COSA COSTA**

## 💸 3.1 — DI QUANTO CAMBIA LA TAGLIA, sedia per sedia e conto per conto

| conto | sedia · magic | volume **oggi** | volume **dopo** | **Δ taglia** | **Δ rischio** |
|---|---|---:|---:|---:|---|
| 🟡 **50503392** | `SuperWave_DOW_H1_Ott` **770511** | **0,20** *(0,10 + 0,10)* | **0,10** | 🔻 **−50%** | 1,42% → **~0,71%** |
| 🟡 **50503392** | `SuperWave` **770531** | **0,20** *(atteso)* | **0,10** | 🔻 **−50%** | ~2,0% → **~1,0%** |
| 🟡 **50503392** | `SupertrendReversal_Ott` **970901** | **0,02** *(0,01 + 0,01)* | **0,01** | 🔻 **−50%** | 2,0% → **1,0%** |
| 🟡 **50503392** | `SupRev_DAX_H4_Ott` **970912** | 🟠 *non misurato* | — | 🔻 **−25% … −50%** | 1,5-2,0% → **1,0%** |
| 🟡 **50503392** | `SupRev_NAS_H1_Ott` **970913** | 🟠 *non misurato* | — | 🔻 **−25% … −50%** | 1,34-2,0% → **1,0%** |
| 🟡 **50503392** | `SupertrendReversal` **770924** | 0,20 + 0,50 | **identico** | ✅ **0%** | 1,0% → **1,0%** |
| 🟠 **50504263** | `SupertrendReversal` **770901** | ~3,00 + ~6,90 | **identico** | ✅ **0%** | 0,65% → **0,65%** |
| 🏛️ **10105439** | *(nessuna sedia)* | — | — | ✅ **0%** | — |

📌 **La riga 770511 non e' una stima: e' il caso del 20/08 riletto.** Due gambe da
**0,10 lotti**, **−72,32 EUR su 5.076,62 = 1,42%** contro un contratto da 1,0%.
Con il fix quella stessa giornata avrebbe piazzato **0,10** e sarebbe costata
**~36,16 EUR = 0,71%**. **Costo aritmetico: meta'.**

## 📉 3.2 — 🔴 **IL COSTO CHE NESSUNO HA ANCORA SCRITTO: LA FREQUENZA**

E la frequenza e' **il requisito n.1** verso ottobre (`CLAUDE.md`, mandato 08/09).

Quando `totLot = 1 × volMin` esatto, dopo il fix `lotPend = NormVol(0) = 0` e la
guardia `if(InpUsePending && lotPend>0)` **salta il pendente**. 👉 **La gamba
"2/3" in continuazione SPARISCE.**

| conto | sedia | **op/g promessa** | **operazioni per segnale: oggi → dopo** | **op/g dopo, se si contano i DEAL** |
|---|---|---:|---:|---:|
| 🟡 piccolo | `SuperWave_DOW_H1_Ott` **770511** | 0,50 | **2 → 1** | 🔻 **~0,25** |
| 🟡 piccolo | `SuperWave` **770531** | *(n/d)* | **2 → 1** | 🔻 **meta'** |
| 🟡 piccolo | `SupertrendReversal_Ott` **970901** | 0,18 | **2 → 1** | 🔻 **~0,09** |
| 🟡 piccolo | `SupRev_NAS_H1_Ott` **970913** | 0,34 | 🟠 **2 → 1 o 2 → 2** | 🟠 **0,17 … 0,34** |
| 🟡 piccolo | `SupRev_DAX_H4_Ott` **970912** | *(n/d)* | 🟠 idem | 🟠 |

### 🧠 MA LA LETTURA GIUSTA E' UN'ALTRA, e va scritta prima che qualcuno si spaventi

> ### 🔴 **I SEGNALI AL GIORNO NON CAMBIANO DI UNO. Cambia il numero di DEAL per segnale.**
> La gamba `2/3` **non e' un secondo segnale**: e' una **seconda tranche dello
> stesso ingresso**, piazzata a 20 pip di distanza sullo **stesso stop**. Sparendo,
> il motore non "opera meno": **opera con una taglia sola invece che con due.**

🔴 **E qui c'e' la trappola di misura, che e' il vero costo:** se
`CENSIMENTO_CONTRATTI.md` conta le **op/g dai deal** (ed e' cosi' che le contano
i CSV), allora **dopo la firma le sedie sembreranno dimezzate in frequenza senza
che il motore sia cambiato**. E il pavimento di 1,00 op/g per famiglia
verrebbe misurato **su un metro diverso da prima**.
👉 **Prima di applicare il criterio di frequenza a queste sedie, il conteggio va
riportato ai SEGNALI (una posizione `1/3` = un'operazione), non ai deal.**
Altrimenti si spegne una sedia per un artefatto di conteggio.

## 🧾 3.3 — IL TERZO COSTO: **I NUMERI DI BACKTEST DI DUE CANDIDATI DIVENTANO DA RIMISURARE**

🔴 **Questo e' il costo piu' scomodo, e vale piu' del guadagno di R4.**

`ROUND_ALTOPIANO_SUPREV_2026-09-09.md` §1 l'ha gia' scritto per il DOW:
> *"I CSV sono usciti quasi CINQUE ORE prima del primo dei tre cambi... `n = 118`
> e `n = 155` non sono garantiti dal codice di oggi."*

**Vale identico per le due candidate che questa firma "promuove":**

| candidata | DD promesso agli atti | il deposito del round | il fix cambia quel numero? |
|---|---|---|---|
| `SupRev_NAS_H1_Ott` **970913** | 1,17% @1% · **n 155** | 🔴 **NON DICHIARATO** (`CENSIMENTO_CONTRATTI.md:190`) | 🔴 **NON SI PUO' SAPERE** — senza il deposito non si sa se `totLot < 3 × volMin` in quel backtest |
| `SuperWave_DOW_H1_Ott` **770511** | 4,0% @1% · **n 227** | 🔴 **NON DICHIARATO** (M-C5) | 🔴 **idem** |

> ### 😬 **L'ironia va detta in faccia: la firma che rende VERO il rischio di queste due sedie rende INCERTO il loro DD promesso.** R4 si guadagna, R2 si indebolisce.

✅ **E la risposta non e' rinunciare al fix** (il rischio vero in campo viene
prima di un numero d'archivio): la risposta e' **rimisurare quelle due celle col
binario 1.01**, che e' **una corsa di tester**, non una decisione di Claudio.
**Costo stimato: due corse a tick reali.** E il deposito, stavolta, si dichiara.

---

# 🧪 SEZIONE 4 — IL COLLAUDO: **COME SI VERIFICA SENZA FIDARSI DEL CODICE**

Quattro prove, **in ordine di forza**. Nessuna richiede di credere a una riga
di `.mq5`. Tutte si leggono da cose che il broker o il terminale stampano.

## 🥇 PROVA 1 — **LA GAMBA `2/3` DEVE SPARIRE.** *(la piu' forte, e costa zero)*
Gli EA scrivono la tranche **nel commento dell'ordine**, in chiaro:
```mql5
gTrade.Buy (lotMkt ,..., InpComment+" L 1/3")   // tranche a mercato
gTrade.BuyStop(lotPend,..., InpComment+" L 2/3")  // tranche in continuazione
```
👉 **Dopo il ricarico, su `770511`, `770531` e `970901` ogni nuovo segnale deve
produrre UNA riga con `1/3` e ZERO righe con `2/3`.**
- ✅ **se compare ancora un `2/3` su quelle tre sedie → il fix NON ha morso**
  (binario vecchio, o profilo non ricaricato);
- 📄 si legge da `trades_auto.csv` / dalla pagella serale. **Nessuno strumento
  nuovo da scrivere.**
- ⚠️ **Su `770924` e `770901` (225JPY) il `2/3` DEVE RESTARE**: li' il bug non
  morde. Se sparisse anche li', qualcosa e' cambiato che non doveva.

## 🥈 PROVA 2 — **IL PRIMO STOP PIENO DEVE COSTARE LA META'**
Il numero "prima" ce l'abbiamo **al centesimo**: `SW DOW H2`, 20/08,
**−72,32 EUR su 5.076,62 = 1,4246%**, due gambe da 0,10.
👉 **Predizione firmata prima della misura: a parita' di distanza di stop e di
saldo, il primo stop pieno di `770511` dopo il ricarico deve costare
~0,68-0,71% del saldo, cioe' circa −36 EUR.** Se costa ancora ~1,4%: **il fix
non ha morso.**

## 🥉 PROVA 3 — **IL RAPPORTO DEI LOTTI FRA I DUE CONTI** *(la tecnica del 02/09 — ma usata come CONTROLLO NEGATIVO, e spiego perche')*
Il 02/09 il rapporto dei lotti 100k/piccolo sullo stesso segnale dell'ORB ha
smascherato una violazione di contratto (`DIARIO.md`: **5,86 / 6,25 / 6,17 /
6,44** poi **20,29 / 19,70** — *"si e' mossa la manopola"*). Funziona anche al
contrario.

🔴 **MA HO PROVATO A ROMPERLA, E NON REGGE COME PROVA POSITIVA QUI.** L'unico EA
fra i 15 che gira **specchiato su due conti** e' `ABTG_SupertrendReversal` su
225JPY — **`770924` sul piccolo e `770901` sul 100k**. E su **nessuno dei due il
bug morde** (§6, contro-esempio 2). 👉 **Il rapporto NON deve muoversi.**

✅ **Allora la si usa per quello che vale davvero, ed e' molto:**
> **Se dopo il ricarico il rapporto dei lotti su 225JPY CAMBIA, il fix ha
> cambiato qualcosa che NON doveva cambiare** → si ferma tutto e si guarda.
Un controllo negativo che nessuno aveva messo in lista. Costa zero: le due sedie
operano sullo stesso segnale e finiscono in due CSV che gia' esistono.

## 4️⃣ PROVA 4 — **LA VERSIONE 1.01** *(necessaria, NON sufficiente)*
Il `#property version` e' passato a **1.01**. Si legge nel titolo della finestra
dell'EA / nella scheda Esperti. **Se dice 1.00, sta girando il vecchio.**
⚠️ Ma **1.01 non dimostra che il fix abbia morso**: dimostra solo che il binario
e' nuovo. La prova che morde e' la **PROVA 1**.

## 📋 4.5 — LA SEQUENZA, e i due terminali dichiarati per numero

| passo | dove | cosa |
|---:|---|---|
| 1 | qualunque macchina | `Get-Process terminal64 \| select Id, MainWindowTitle, Path` → **il riconoscimento e' stampato, non a occhio** |
| 2 | MetaEditor | **compilare i 13 file di `mql5/Experts/`** (F7 uno per uno, **NON "Compila tutto"**) |
| 3 | 🟡 **50503392** — `C:\Program Files\BCM Markets MT5 Terminal`, profilo `ORO` | ricaricare le **6 sedie**: 770511, 770531, 970901, 970912, 970913, 770924 |
| 4 | 🟠 **50504263** — `C:\Program Files\BCM Markets MT5 Terminal -V3`, profilo `SQUADRA 100K` | ricaricare **1 sedia**: 770901 |
| 5 | 🏛️ **10105439** — `C:\BCM_Reale` | ❌ **NON TOCCARE NIENTE** |
| 6 | dopo ogni ricarico | 🔴 **verificare che `InpRiskPercent` sia ancora quello del preset** — un RIPRISTINA atterra sul default (1.0, e su 970901 il sorgente porta **2.0**) |

🔴 **Il passo 6 e' il piu' pericoloso dell'intera operazione**, ed e' su
**`970901`**: default compilato **2.0** contro **1** che gira. Un preset perso
li' **raddoppia** invece di dimezzare.

🚦 **E vale il cancello del 09/09: la riga di lancio / la procedura passo-passo
per Claudio NON esce da qui senza `controlla_riga.py` + agente
`controllo-preventivo` in PASS.** Questo documento e' la **decisione**, non la
riga operativa.

---

# 🛑 SEZIONE 5 — COSA **NON** SI TOCCA IN QUESTO PACCHETTO, ELENCATO PER NOME

## ✅ I 15 file che il pacchetto copre — e sono TUTTI E SOLI questi
`ABTG_SuperWave` · `ABTG_SuperWave_DAX_H4_Ottimizzato` ·
`ABTG_SuperWave_DOW_H1_Ottimizzato` · `ABTG_SupertrendReversal` ·
`ABTG_SupertrendReversal_Ottimizzato` · `ABTG_SupertrendReversal_Multi` ·
`ABTG_SupertrendReversal_Multi_Ottimizzato` · `ABTG_SupRev_CAC_H4_Ottimizzato` ·
`ABTG_SupRev_DAX_H1_Ottimizzato` · `ABTG_SupRev_DAX_H4_Ottimizzato` ·
`ABTG_SupRev_DOW_H1_Ottimizzato` · `ABTG_SupRev_DOW_H4_Ottimizzato` ·
`ABTG_SupRev_NAS_H1_Ottimizzato` · `standalone/ABTG_SupertrendReversal` ·
`standalone/ABTG_SupertrendReversal_Multi`

## 🚫 COSA RESTA FUORI — per nome, mai "tutto il resto" *(regola del 10/09, classe 180)*

| # | cosa | perche' fuori | dove sta scritto |
|---:|---|---|---|
| 1 | 🏛️ **il conto reale 10105439** e le sedie **770101** e **770611** | non montano nessuno dei 15 file | §0 |
| 2 | 🔥 **`ABTG_PostNews` default `3.0`** (`:113`) — 3 sedie vive, **771201 e 771202 girano a 3,0 ADESSO** | e' **piu' urgente di questo**, ma e' una **firma diversa** (tocca il rischio, non il volume). Ha gia' pagato **80,90 EUR il 10/09** | `CENSIMENTO_RISCHIO_VERO_2026-09-10.md` §1 |
| 3 | 🔥 **`standalone/ABTG_DAX_Apertura_EU.mq5:33`** `ABTG_DEF_RISK 2.0` non allineato al fix C4 | **e' il file di una sedia del REALE**: si tocca solo con firma dedicata | ibid. §conto reale |
| 4 | 🔥 **`ABTG_MaxMinNotte` default `2.0`** (`:171`) — sedia viva **770402** XAUUSD, salto su Ripristina **4,00x** | difetto di default, non di tranche | ibid. §2 |
| 5 | 🔥 **`ABTG_Nasdaq_Apertura_US` (GatedShort **770250**)** — salto su Ripristina **11,43x**, il record del parco | idem | ibid. §3 |
| 6 | 🔒 **l'OCO software** dei 15+ EA a due pendenti opposti (misurato: **4 giornate su 16** col secondo lato riempito) | e' il difetto **#3** della lista, tocca 15 file diversi | `RISCHIO_DICHIARATO_VS_VERO_2026-09-08.md` §7 |
| 7 | 📏 **il flag `alMinimo`** da estendere ai 72 EA con `MathMax(minLot, ...)` | difetto **#4**, di manutenzione | ibid. |
| 8 | 🧮 **il ripiego `OrderCalcProfit`** in `BreakoutCorso`, `Relativo`, `SuperWave_EA` | difetto **#5** | ibid. |
| 9 | 🧹 **`DAX_Apertura_EU.mq5:669`** `PositionClose(_Symbol)` per simbolo invece che per ticket | difetto **#6**, ed e' **nel file di una sedia del REALE** | ibid. |
| 10 | 🛡️ **il Guardian**: cap **cieco sui pendenti**, assente sul **piccolo 50503392**, tetto per cluster **firmato ma SPENTO** (`InpMaxClusterRiskPct = 0`) | tre difetti separati, nessuno risolto qui | `CENSIMENTO_RISCHIO_VERO_2026-09-10.md` §cap C1 |
| 11 | 📐 **nessun `InpRiskPercent`, nessun `.set`, nessuna taglia** | **firma esclusiva di Claudio** | mandato |
| 12 | 🌳 **la domanda "quale albero viene compilato sul VPS"** (CODA_06) | risposta certa **solo per `ABTG_PostNews`** (albero principale). Sugli altri **non chiusa** — per questo sono stati corretti **entrambi** gli alberi | `QUALE_CODICE_GIRA_2026-09-08.md` |

> ## 🔴 **LA FRASE ONESTA DI QUESTO PACCHETTO**
> **Questa firma toglie UN difetto su SEI dalla lista del 08/09, e non e' il piu'
> pericoloso.** Il piu' pericoloso e' il **n.2** (PostNews a 3,0, che gira
> **adesso** e ha gia' pagato). Firmare questo e credere di aver messo a posto il
> rischio della flotta sarebbe **l'errore piu' costoso possibile**.

---

# 🧪 SEZIONE 6 — I CONTRO-ESEMPI, costruiti PRIMA di consegnare *(regola del 10/09)*

## 🧪 1. *"Il fix e' davvero di due righe?"* → 🟠 **META' SI, META' NO**
- ✅ Le righe di **logica** sono due, e sono uno **scambio d'ordine**. Nessuna
  `if` nuova: la guardia `lotPend>0` **esisteva gia'** in tutti e 15 i file.
- 🔴 Il **diff reale** e' **13 righe x 15 file = 404 inserzioni / 30 cancellazioni**
  (`git show --stat 872dba8`).
- 🔴 E **l'effetto non e' di due righe**: cambia il **volume** di 3-5 sedie vive,
  **fa sparire una tranche** su almeno 3, e **mette in dubbio i backtest** di 2
  candidati (§3.3).
👉 **Verdetto: "e' un riordino di due righe di logica in 15 file, con effetti
sulla taglia, sulla frequenza e sui numeri d'archivio."** Chiamarlo "solo due
righe" e' come si fanno passare i cambiamenti pericolosi.

## 🧪 2. *"Sei sicuro che il vero sia 2x e non 1x?"* → 🔴 **NO, E CORREGGO DUE RIGHE DEL CENSIMENTO DEL 10/09**
**Questo contro-esempio ha cambiato la tabella, ed e' il motivo per cui si fa.**

Il bug morde **solo** se `totLot < 3 × volMin`. Su **`ABTG_SupertrendReversal`
225JPY** le taglie in campo sono **misurate**, non stimate
(`DIARIO.md`, 28/08/2026): *"il 50% di **0,50 lotti**... mentre il 50% di **6,90
lotti**"*, e su 225JPY lo **step e' 0,10**.

| sedia | conto | gamba osservata | `totLot` implicito | `3 × volMin` | il bug morde? | il censimento 10/09 dice |
|---|---|---:|---:|---:|---|---|
| **770924** | piccolo | **0,50** | **~0,70** | 0,30 | ❌ **NO** | 🔴 *"2,00% · bug tranche (r.274-276)"* → **SBAGLIATO** |
| **770901** | 100k | **6,90** | **~9,9** | 0,30 | ❌ **NO** | ✅ corretto (`n = 1`) |

👉 **CORREZIONE AGLI ATTI: la riga `SupertrendReversal 225JPY 770924 piccolo` del
`CENSIMENTO_RISCHIO_VERO_2026-09-10.md` (rapporto 3,08, EVENTO 2,00%) attribuisce
alla sedia un difetto che su quel simbolo NON PUO' MORDERE.** Il suo rischio vero
e' **1,00% = il dichiarato**, e il fattore e' **1,00x, non 2,00x**.
🔴 **Se non l'avessi rifatto, Claudio avrebbe firmato aspettandosi un
dimezzamento su una sedia dove non succedera' NIENTE** — e poi, non vedendolo,
avrebbe concluso che il fix non ha funzionato.

⚠️ E lo stesso dubbio resta **aperto** su **970912** (D30EUR) e **970913**
(NASUSD): li' la taglia in campo **non e' stata osservata** e per NASUSD **non
conosciamo nemmeno `SYMBOL_VOLUME_MIN`**. Per quelle due il "2,00x" e'
**un'attesa dichiarata, non una misura**.

## 🧪 3. *"Il fix riduce il rischio o lo SPOSTA?"* → ✅ **RIDUCE. Ma sposta la FREQUENZA, e va quantificato**
- ✅ **Riduce davvero**: il volume totale passa da `totLot + volMin` a `totLot`.
  Non e' rischio spostato su un'altra gamba: e' **volume che non viene piazzato**.
- 🔴 **Ma sposta il conteggio**: dove `totLot = volMin` esatto, i **deal per
  segnale passano da 2 a 1** (§3.2). **I segnali al giorno non cambiano.**
- 📐 **Quantificato**: `770511` **0,50 → ~0,25 op/g** se si contano i deal,
  **0,50 → 0,50** se si contano i segnali. 👉 **Prima di applicare il pavimento
  di frequenza a queste sedie, si dichiara quale dei due metri si usa.**

## 🧪 4. *"E se il ricarico non cambiasse nulla perche' il VPS compila l'albero `standalone/`?"*
✅ **Coperto**: il commit `872dba8` ha corretto **entrambi** gli alberi (13 +
**2 standalone**). 🔴 **Ma resta il fatto che sui 12 EA non-PostNews non sappiamo
quale albero gira**, e va detto: la prova che il fix ha morso **non e' la
compilazione, e' la PROVA 1** (la gamba `2/3` che sparisce).

## 🧪 5. *"Il fix potrebbe rompere qualcosa?"* → 🟠 **UN RISCHIO RESIDUO, dichiarato**
🔴 **Qui non c'e' MetaEditor: che il codice COMPILI e' un'inferenza da lettura,
non un fatto.** Le due dichiarazioni `double` sono state riordinate e `lotPend`
non e' usata prima della sua dichiarazione (il primo uso e' decine di righe
sotto), ma **la prova e' F7**. Se il compilatore protesta, si torna indietro con
`git revert 872dba8` e **non si e' perso niente**.

---

# ✍️ LA FIRMA — quattro caselle, e si possono firmare separatamente

| # | cosa si firma | effetto | chi lo fa |
|---:|---|---|---|
| **F1** | ✅ **Compilare i 13 file di `mql5/Experts/`** (F7, uno per uno, **non "Compila tutto"**) | nessuno finche' non si ricarica | Claudio, MetaEditor |
| **F2** | ✅ **Ricaricare le 6 sedie del PICCOLO 50503392** (770511, 770531, 970901, 970912, 970913, 770924) verificando il preset a ogni ricarico | 🔻 taglia **−25%…−50%** su 3-5 sedie · rischio vero **allineato al dichiarato** | Claudio |
| **F3** | ✅ **Ricaricare 770901 sul 100k 50504263** | ✅ **nessun cambio di taglia** (il bug non morde li') — serve solo ad allineare i binari | Claudio |
| **F4** | 🔴 **NON toccare il REALE 10105439** | ✅ zero cambiamenti sul conto vero | — |

## 🔴 E LE TRE COSE CHE QUESTA FIRMA **NON** FA, ripetute perche' contano
1. **Non porta le schierabili a 5.** Le porta **da 2 a 2** (lettura stretta) o
   **da 2 a 4** (lettura larga). §2.
2. **Non tocca il difetto piu' pericoloso della flotta** (`PostNews` a 3,0, che
   gira **adesso**). §5, riga 2.
3. **Non chiude R2 su 970913 e 770511: lo riapre.** Servono due corse a tick col
   binario 1.01, **col deposito dichiarato**. §3.3.

---

# 📌 FATTO / INFERENZA / DA MISURARE

## ✅ FATTO — letto o misurato, con la fonte
- Il fix e' **gia' nei 15 sorgenti** (commit `872dba8`, 08/09) — **verificato
  file per file adesso**, non citato.
- Il diff e' **13 righe x 15 file**, `404 +` / `30 −` (`git show --stat`).
- **Nessuno dei 2 EA del conto reale 10105439 e' fra i 15 file.**
- `SW DOW H2`, 20/08: **due gambe da 0,10 lotti, −72,32 EUR su 5.076,62 = 1,42%**
  contro contratto 1,0% (`DIARIO.md`).
- `STREV Nikkei` 28/08: gamba **0,50** sul piccolo e **6,90** sul 100k, step
  225JPY **0,10** (`DIARIO.md`) → **il bug non morde su nessuno dei due**.
- `SupertrendReversal_Ott` XAUUSD: gamba **0,01 = volMin** (`DIARIO.md` 28/08)
  → **il bug morde**.
- `VOLUME_MIN` **misurato**: U30USD **0,10** · D30EUR **0,10** · XAUUSD **0,01**
  (`R114_CORSA_20260827/REFERTO_R114.txt`).
- Il deposito dei round di **970913** e **770511** e' **NON DICHIARATO**
  (`CENSIMENTO_CONTRATTI.md:190` e M-C5).
- Il Guardian **conta euro veri** (`OrderCalcProfit`), **non** le etichette — ma
  **e' cieco sui pendenti** e **non gira sul piccolo 50503392**.

## 🔎 INFERENZA DICHIARATA
- Che i 15 file **compilino**: letto, non compilato. **Non c'e' MetaEditor qui.**
- Il **−50%** su `970912` (D30EUR) e `970913` (NASUSD): **atteso** dalla formula,
  **non osservato** — la taglia in campo di quelle due non e' mai stata letta.
- Il `totLot ≈ 0,70` di `770924` e' **dedotto** dalla gamba 0,50 osservata e
  dalla ripartizione 1/3-2/3. Regge il verdetto (`0,70 > 0,30`) con **piu' del
  doppio di margine**, ma resta una deduzione.

## 🔴 DA MISURARE — e ognuna ha il suo strumento gia' scritto
| # | cosa manca | strumento | costo |
|---:|---|---|---|
| **M1** | 🔴 `SYMBOL_VOLUME_MIN` / `STEP` / valore-punto di **NASUSD** e **225JPY** | `ABTG_SondaMargine` (non tocca niente) su **50503392** | minuti |
| **M2** | la taglia in campo di **970912** e **970913** | si legge dal **prossimo trade**, non si stima | zero |
| **M3** | il **DD delle celle 970913 e 770511 col binario 1.01**, **col deposito dichiarato** | 2 corse a tick reali | 2 corse |
| **M4** | se `CENSIMENTO_CONTRATTI` conta le op/g **dai deal o dai segnali** | lettura dello script | minuti |
| **M5** | quale **albero** compila il VPS sui 12 EA non-PostNews | **CODA_06** | una notte |

---

## 🎯 E LA BUSSOLA, perche' e' la meta' che conta

**L'obiettivo sono le sedie schierabili il 1 ottobre.** Questa firma **non ne
aggiunge**: toglie **rischio vero non contato** da tre sedie vive e **sblocca un
requisito** su due candidati che poi vanno comunque validati. 🟢 **E' un pezzo di
ponteggio che serve** — ma va chiamato ponteggio, non progresso.

🔥 **La cosa che avvicina davvero il 1 ottobre non e' in questa pagina**: e' il
**preset del 770202** (un file), l'**attribuzione R83-vs-R119 sul 770101** (una
lettura) e l'`S*` dell'**EMA200**, che e' **la sola sedia della flotta che supera
il pavimento di frequenza da sola**. 👉 **Tre lavori, nessuno dei quali richiede
una firma sul rischio.** Sono quelli la strada per le 5 sedie.

**E non ci accontentiamo.** 💪
