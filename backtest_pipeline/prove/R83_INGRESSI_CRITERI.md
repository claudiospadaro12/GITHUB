# 🥊 R83 — IL DUELLO DEGLI INGRESSI (stop / limit sul retest / market alla conferma)

_Criteri congelati il **18/08/2026 sera**, PRIMA di qualunque numero.
Nasce da **FIRMA 6** (`report/FIRME_2026-08-18.md`): Claudio — *"SI, FIRMO
R83BIS"* — dopo la sua domanda **"3 EA diversi sulle aperture, oppure un EA
che contiene 3 tipologie di ingresso?"** e la raccomandazione di casa:
**UN solo EA, mai tre.**_

> 🎯 **LA DOMANDA, UNA SOLA:**
> **"A parita' ASSOLUTA di tutto il resto (livello, orario, stop, gestione,
> uscite), quale STILE D'INGRESSO regge meglio sull'apertura — e su QUALE
> mercato?"**

Le tre parole di Claudio, tradotte in modalita':

| `InpEntryMode` | nome | cosa fa | cosa costa |
|---|---|---|---|
| **0** | **STOP** (breakout) | BUY/SELL **STOP** oltre il livello + buffer | **slippage**: si riempie SEMPRE, spesso peggio del prezzo |
| **1** | **LIMIT sul retest** | il livello viene rotto, poi **LIMIT** sul ritorno | **no-fill**: se non torna, non entri (campione piu' piccolo) |
| **2** | **MARKET alla conferma** | una candela **CHIUDE** oltre il livello → si entra a mercato | **ritardo**: entri piu' lontano dal livello, stop piu' largo |

Nessuna delle tre e' gratis: **il duello serve a vedere quale costo pesa meno
su QUESTO mercato**, non a trovare "l'ingresso giusto" in astratto.

---

## 1. 🔒 COSA E' CONGELATO QUI

1. **L'ingresso e' l'UNICA variabile.** Tutto il resto (livello, buffer,
   sessione, SL, TP1+parziale, breakeven, trailing, flat, un ciclo al giorno,
   rischio) e' **identico** fra le tre modalita' dello stesso mercato, ed e'
   scritto per intero nei file prova.
2. **Un magic per modalita', mai segnali miscelati** (vincolo della firma):
   ogni cella e' attribuibile, sempre.
3. **Nessuna griglia.** Non si spazzola nessun parametro di strategia. L'unico
   asse spazzolato e' la coppia di magic gemelli (controllo di identita').
4. **L'EA nuovo NON sostituisce niente.** Gira in parallelo, regola
   `_Ottimizzato`. Le sedie vive non vengono toccate da questo round.
5. **Al massimo UNA modalita' per mercato potra' andare in forward** — e non
   da qui: le tre modalita' si innescano sullo stesso evento, quindi in campo
   sarebbero posizioni **correlate** e mangerebbero il cap C1 (3,25%) tre
   volte. Lo dice la firma stessa.

## 2. 🧪 L'EA DEL ROUND — e le due divergenze dichiarate

**`mql5/Experts/ABTG_Apertura_3Ingressi.mq5`** (nuovo, scritto il 18/08 sera).

- E' un **fork del motore del Nasdaq** (`ABTG_Nasdaq_Apertura_US.mq5`,
  versione tutto-in-uno). Scelta dichiarata, perche' i due motori vivi **sono
  gia' divergenti** fra loro:
  - il core **Nasdaq** ha le leve R30 (`InpUseVolRegime`, `InpUseSRFilter`) e
    **non** ha `InpAllowReverse`;
  - il core **DAX** ha `InpAllowReverse` (R51) e **non** ha le leve R30.
- **Conseguenza operativa:** l'EA del round **non ha `InpAllowReverse`**. In
  campo il DAX gira con `InpAllowReverse=false` (default), quindi il
  comportamento atteso e' identico — ma **atteso non vuol dire misurato**:
  lo verifica il canarino §4.
- Le leve R30 esistono nel fork e sono **pinnate spente** in tutti i file
  prova.
- **La modalita' 2 e' codice NUOVO.** Il motore vivo ha `OPENCONFIRM`, che
  pretende una candela che **APRE** oltre il livello. La firma chiede la
  **CHIUSURA** oltre il livello. Sono due regole diverse (differiscono a ogni
  gap fra chiusura e apertura, e sull'apertura di sessione sono proprio i casi
  interessanti): quindi la 2 e' implementata a parte, **non e' un alias di
  OPENCONFIRM**, ed e' la sola parte del round che non ha mai girato.

## 3. 📅 MERCATI, ORARI, FINESTRA

| | Nasdaq | DAX |
|---|---|---|
| simbolo | **NASUSD** | **D30EUR** |
| apertura (ora **SERVER BCM**) | **14:30** (= 15:30 IT) | **8:00** (= 09:00 IT) |
| flat | 21:45 | 17:30 |
| livello | candela **H1 precedente** (`RANGE_PREVBAR`) | **range di apertura 35 min** (`RANGE_OPENING`) |
| buffer | 200 pt | 500 pt |
| offset del limit (mod. 1) | 0 pt | 200 pt |
| trailing | base candela **M1** | base candela **M5** |
| TF del grafico nel tester | M15 | M15 |

Ogni valore qui sopra viene dai **default del sorgente della sedia viva**
corrispondente e **non si tocca**: se cambiassi anche solo il buffer, il
duello non isolerebbe piu' l'ingresso.

**Finestra:** `2024.09.26 → 2026.06.30`, modello **4 (tick reali)**, deposito
**10.000**, rischio pinnato **1,00%** su tutte le celle.

> ⚠️ **STESSO PASSO 0 DI R84, ed e' vincolante:** la profondita' dei **tick
> reali degli INDICI** a BCM **non e' mai stata misurata** (il referto del
> 15/08 misura GBPUSD: tick dal 2024.07.05, e dice *"da misurare allo stesso
> modo: i tick degli INDICI"*). Il 2024.09.26 e' la profondita' delle
> **BARRE**. Si misura prima, si legge la riga `TICK`, e se i tick partono
> dopo, **la finestra si riscrive**. E' il difetto n.18 della checklist.

**Regime contenuto:** toro USA 2024-2025 + correzione 2025 sul Nasdaq; DAX
2024-2026. **Un regime e mezzo, niente 2020, niente 2022.** Va scritto
accanto a ogni numero: R83 misura **il riempimento e lo stile d'ingresso**,
mai la robustezza di regime.

## 4. 🐤 IL CANARINO DI EQUIVALENZA — senza questo, il duello non conta

Un EA nuovo che gira accanto a uno vivo **deve prima dimostrare di essere lo
stesso motore**. Due controlli, tutti e due obbligatori **prima** di leggere
il duello:

**(a) Nasdaq, modalita' 0 = cella A di R84.** Stessa finestra, stesso
modello, stesso deposito, stessa configurazione riga per riga. **I numeri
devono coincidere** (Profit, PF, DD, Trades). Costa **zero macchina in piu'**:
la cella A la gira R84.

**(b) DAX, modalita' 1 = sedia viva `ABTG_DAX_Apertura_EU`.** Cella di
controllo `V`, l'EA **vivo** girato sulla stessa finestra e configurazione.
I numeri devono coincidere con la modalita' 1 dell'EA nuovo.

> **Se (a) o (b) NON coincidono, il round si ferma.** Non si "spiega" la
> differenza a posteriori: si trova la divergenza nel codice. Un duello fra un
> EA e un suo clone che non e' un clone non misura gli ingressi, misura un bug.

⚠️ Attenzione onesta su (b): la sedia viva DAX **gira gia' in RETEST**
(`ABTG_DAX_Apertura_EU.mq5`: `input ENUM_ABTG_ENTRY InpEntryMode = ABTG_RETEST;`
con `InpRetestOffsetPts=200`, misura del 06/08). Quindi **sul DAX la baseline
non e' il breakout stop: e' gia' il limit sul retest**, e le sfidanti sono la
0 e la 2. Sul Nasdaq invece la baseline e' la 0. La premessa "A = breakout
stop com'e'" vale solo per il Nasdaq: qui e' corretta, non ipotizzata.

## 5. 🧬 LE CELLE

| cella | mercato | modalita' | magic (2 gemelli) | ruolo |
|---|---|---|---|---|
| **N0** | NASUSD | 0 STOP | 777010 / 777011 | baseline Nasdaq (+ canarino (a) contro R84-A) |
| **N1** | NASUSD | 1 LIMIT retest | 777020 / 777021 | sfidante |
| **N2** | NASUSD | 2 MARKET conferma | 777030 / 777031 | sfidante (codice nuovo) |
| **D0** | D30EUR | 0 STOP | 777110 / 777111 | sfidante |
| **D1** | D30EUR | 1 LIMIT retest | 777120 / 777121 | baseline DAX (= sedia viva) |
| **D2** | D30EUR | 2 MARKET conferma | 777130 / 777131 | sfidante (codice nuovo) |
| **V** | D30EUR | (EA VIVO, retest) | 777190 / 777191 | canarino (b): equivalenza col motore vivo |

**7 celle x 2 passate gemelle.** Tutti i filtri (EMA, Supertrend, ST x3,
correlazione, VWAP, volumi, ATR, news, R30) sono **pinnati SPENTI** in tutte:
i filtri sono la domanda di **R84**, non di questo round. Mescolarli qui
renderebbe illeggibili tutti e due.

## 6. ⚖️ I CRITERI DI LETTURA — congelati adesso

Si leggono **Profit, PF, Equity DD %, Trades** per IS, OOS e totale, **per
mercato separatamente**.

1. **Il verdetto e' PER MERCATO.** Una modalita' puo' vincere sul Nasdaq e
   perdere sul DAX: e' un risultato, non una contraddizione (lezione PTE —
   GBPUSD si', USDJPY no). **Non si cerca "la modalita' migliore in
   generale".**
2. **Il numero di trade e' INFORMAZIONE, non un difetto.** Il limit riempie
   meno (no-fill), la conferma entra piu' tardi: si scrive **quante** entrate
   perde ciascuno rispetto alla 0, ed e' meta' della risposta.
3. **Valvola R59:** sotto **30 operazioni** in una cella, il giudizio di
   **merito e' SOSPESO** (si scrive "non misurabile"). Il **rischio** non si
   sospende mai: un DD accaduto e' un fatto.
4. **Vince una modalita' solo se** batte la baseline del suo mercato su
   **PF di almeno +0,10** sul campione intero **e** non ha il segno
   ribaltato fra IS e OOS **e** non peggiora il DD di piu' di 1 punto.
   Altrimenti: **"le tre modalita' non sono distinguibili su questa finestra"**
   — verdetto valido e probabile, da scrivere senza giri di parole.
5. **ZERO vincitori e' un esito legittimo.** In quel caso la firma si chiude
   cosi': l'EA a 3 ingressi resta uno strumento di misura, non diventa una
   sedia.
6. **R83 non promuove niente in forward.** Un eventuale vincitore passa dal
   processo completo (prova di regime, walk-forward, contratto DD+frequenza,
   firma di Claudio). E anche allora: **una sola modalita' per mercato**.

## 7. ⚠️ L'ASIMMETRIA CHE FALSEREBBE IL DUELLO — lo slippage

Nel motore, `InpSlippagePts` **peggiora l'entry SOLO degli ordini STOP**
(`TryPlaceBreakout`, righe 930 e 955 del sorgente vivo): il limit del retest e
il market della conferma **non lo pagano**.

- **GIRO 1 (questo round): `InpSlippagePts=0` su tutte le celle.** Dichiarato:
  **la modalita' 0 e' avvantaggiata**. I tick reali portano lo spread vero, ma
  **non** il fatto che uno stop si riempie oltre il livello nei primi minuti
  d'apertura.
- **Se la modalita' 0 vince il giro 1**, il verdetto **non e' chiuso**: serve
  il **GIRO 2** con slippage acceso, e il valore **non si inventa** — si
  prende da un referto che l'abbia misurato (fase C dei walk-forward
  aperture). Se quel numero non esiste, si dichiara che **non esiste** e la
  vittoria della 0 resta con l'asterisco.
- Se vincono la 1 o la 2, il giro 2 e' inutile: hanno vinto **nonostante** il
  vantaggio dell'avversaria.

## 8. ⏱️ ORDINE DI ESECUZIONE E STIME (dichiarate come STIME)

1. **PASSO 0** (comune con R84): profondita' tick `NASUSD` e `D30EUR`.
   **Stima 30-120 min.**
2. **COMPILAZIONE + AUTOTEST dell'EA nuovo.** L'EA stampa `[3ING][AUTOTEST]`
   in `OnInit`: quelle righe **le produce un'ESECUZIONE**, non il tasto F7
   (difetto n.20 della checklist). Si leggono facendo **un test singolo nello
   Strategy Tester**, mai attaccando l'EA a un grafico (sul PC di backtest il
   terminale e' collegato al conto vivo). **Stima 5 min.**
3. **GIRO A VUOTO** — `lancia_r83.ps1 -SoloControllo`. **Stima 1-2 min**;
   esce **1** se anche una sola cella non produce l'anteprima.
4. **CANARINO** — `-Solo N0` (e, appena c'e' R84, il confronto con la cella A)
   e `-Solo V,D1` per l'equivalenza DAX. **Stima 40-120 min.**
5. **LE CELLE RESTANTI.** **Stima 2-6 ore** complessive. Il `-TimeoutMin` si
   dimensiona **dopo** il canarino, numero contro numero (difetto n.19).

⚠️ **UNA MACCHINA, UN LAVORO**: un solo MT5 sul PC di backtest. R83 e R84 non
possono girare insieme, e nemmeno accanto a HistData/Dukascopy.

## 9. 📎 TRACCIABILITA'

- EA del round: `mql5/Experts/ABTG_Apertura_3Ingressi.mq5`
- File prova: `prove/R83n0_stop_NASUSD.txt` ... `prove/R83v_vivo_D30EUR.txt`
- Driver: `backtest_pipeline/lancia_r83.ps1`
- Firma: `report/FIRME_2026-08-18.md` — FIRMA 6
- Regole di casa applicate: EMENDAMENTO DELLA FINESTRA · valvola R59 ·
  cap C1 (correlazione) · CHECKLIST_RIGA_DI_LANCIO punti 5, 13, 14, 18, 19, 20
