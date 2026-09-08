# 🛡️ GUARDIAN — MODO DICHIARATO PER LA BASELINE GIORNALIERA (v1.14, 08/09/2026)

_Scritto dall'**agente MQL5** l'**08/09/2026**, su mandato che nasce da
`report/REGOLAMENTI_PROP_2026-09-08.md` §3.1 + sezione «VERIFICA DI CLAUDE»._

> ## 🔴 LA RIGA CHE SERVE A CLAUDIO, SUBITO
> **Il modo NON è attivo da nessuna parte.** `InpDailyBaseline` nasce a **0 =
> EQUITÀ**, cioè **esattamente il comportamento della v1.13**: nessun preset lo
> contiene, nessuna sedia in campo cambia, nessuna soglia è stata toccata.
> **Metterlo a 1 o a 2 su un conto è una FIRMA DI CLAUDIO**, non una decisione
> dell'EA né di chi ha scritto il codice.
> ⚠️ E **non è compilato**: vedi §6.

---

# 1. 🎯 IL PROBLEMA, in tre righe

- **Noi** misuriamo la giornata dall'**EQUITÀ** al reset (`GV_DAYSTART`).
- **FTMO** la misura dal **SALDO** alle 00:00 CE(S)T; **FundingPips** dal
  **più alto** fra saldo ed equità di apertura.
- Con **flottante negativo al reset**, l'equità sta **sotto** il saldo → il
  nostro pavimento scende con lei, **il loro no**. Numeri del dossier, 100k
  con −0,8% flottante al reset:

| | baseline | pavimento (−5%) |
|---|---:|---:|
| **FTMO** (saldo) | 100.000 | **95.000** |
| **noi v1.13** (equità) | 99.200 | **94.200** |

🔴 **800 € di scarto, e nel verso sbagliato**: siamo **più permissivi** della
prop. La challenge può essere **già violata** mentre il Guardian è ancora "in
pausa morbida". Tocca **solo le sedie che tengono posizioni attraverso l'ora
del reset** — e la flotta ne ha (le swing multi-day di `ROTTA_PROP.md`).

## ⛔ MA NON SI TORNA AL BILANCIO
Quella riga è un **fix deliberato del 06/09 (v1.12)**, che ha chiuso un bug
**misurato sul conto REALE 10105439**: lì il broker tiene un **credito stabile
e non prelevabile** (bilancio 5.000, credito 2.500). Baseline dal bilancio +
confronto sull'equità = il credito diventa un **cuscinetto falso da 2.500 €**,
e pausa/blocco non scattano fino a oltre metà del capitale vero.
👉 Le due esigenze sono **entrambe vere, su conti diversi**. Per questo la
correzione è un **MODO**, non un cambio di riga.

---

# 2. 🔧 IL DIFF COMMENTATO

File toccato: **uno solo** → `/home/user/GITHUB/mql5/Experts/ABTG_Guardian.mq5`
(199 righe aggiunte, 5 modificate). `#property version` **1.13 → 1.14**.

## 2.1 L'input (opt-in, no-op — stessa forma del cap C2)

```mql5
input int    InpDailyBaseline  = 0;      // Baseline giornaliera: 0=EQUITA' (come oggi) . 1=SALDO (FTMO) . 2=MAX(saldo,equita)
```
Sopra c'è il blocco di commento che spiega **perché esiste** (FTMO misura dal
saldo), **perché il default resta l'equità** (il credito del conto reale) e che
**la scelta del modo per un conto è una firma di Claudio**. Stessa identica
forma di `InpMaxClusterRiskPct` / `InpClusterMappa` (C2): **opt-in, no-op**.

## 2.2 La funzione PURA (è pura apposta: così l'autotest la collauda)

```mql5
double BaselineGiorno_Calc(const double bal,const double eq,const int modo)
  {
   if(modo==1) return(bal);
   if(modo==2) return(MathMax(bal,eq));
   return(eq);                       // 0 e qualunque valore fuori scala
  }
```
Non legge il conto, non tocca GlobalVariable. **Un input fuori scala ripiega
sul default** (e lo dichiara nel giornale): un dito storto non deve mai
cambiare da solo il comportamento in campo.
Accanto: `BaselineModoTesto(modo)` → `EQUITA'` / `SALDO` / `MAX(saldo,equita)`.

## 2.3 I due punti di cattura (erano le righe 428 e 529)

**Sono esattamente due, li ho cercati tutti.** `grep GV_DAYSTART` dà 5
occorrenze: 1 dichiarazione, 1 costruzione del nome, **2 scritture** (le
nostre), 1 lettura (`dayStart`, non toccata).

| prima (v1.13) | dopo (v1.14) |
|---|---|
| `GlobalVariableSet(GV_DAYSTART,eq);` (OnInit) | `double base=BaselineGiorno_Calc(bal,eq,InpDailyBaseline);` → `GlobalVariableSet(GV_DAYSTART,base);` |
| `GlobalVariableSet(GV_DAYSTART,eq);` (OnTimer) | idem |

A `InpDailyBaseline=0`, `base` **è `eq`**: stesso numero, stessa
GlobalVariable, stesse decisioni. Il resto del calcolo
(`dailyLoss=dayStart-eq`, `dailyLimit`, pausa, cap, lockdown) **non è stato
sfiorato**.

## 2.4 Il modo si STAMPA (una protezione muta non è verificabile)

```
[GUARDIAN] nuovo giorno prop: baseline=99200.00 (modo=EQUITA')  [equity=99200.00 bilancio=100000.00]
```
- **OnTimer**: la riga esisteva già (sotto `InpVerbose`) e ora dichiara il modo.
- **OnInit**: la stessa riga alla cattura del giorno.
- **Solo se il modo NON è 0**, all'avvio esce anche una riga a voce alta che
  dice che è una **scelta di conto firmata** e che sui conti **con credito**
  vale solo il modo 0. A default quella riga **non compare**.

> ### ⚠️ L'UNICA differenza a default, dichiarata
> Le **decisioni** e i **numeri** sono identici alla v1.13, bit per bit. La
> sola cosa che cambia con `InpDailyBaseline=0` è **il testo di quella riga di
> giornale** (e una riga in più alla cattura in `OnInit`). È il requisito n.3
> del mandato: il modo va stampato a ogni nuovo giorno prop. **Nessun collaudo
> dipende da quella stringa**: `grep "nuovo giorno prop"` su tutto il repo
> trova **solo** il sorgente del Guardian (le attese di
> `attese_enforcement_fase1.txt` cercano `CAP RISCHIO APERTO` e
> `rischioAperto=`, che non ho toccato).

---

# 3. 🧭 QUALE MODO PER QUALE CONTO (bussola, NON una firma)

| conto | chi fa da arbitro | modo | perché |
|---|---|---|---|
| **REALE 10105439** (`C:\BCM_Reale`) | il nostro Guardian | **0 = EQUITÀ** ✅ | c'è il **credito** del broker: col modo 1 tornerebbe il bug del 06/09. Il modo 2 lo evita *finché* l'equità sta sopra il bilancio — vedi §4 |
| **demo 50503392 / 50504263** | il nostro Guardian | **0 = EQUITÀ** | nessun motivo di cambiare: stessa misura di sempre |
| **prop FTMO** | **FTMO** | **1 = SALDO** | il regolamento dice *saldo registrato alle 00:00 CE(S)T* |
| **FundingPips** | FundingPips | **2 = MAX** | *il più alto fra saldo ed equity di apertura* — testuale |
| **The5ers High Stakes** | The5ers | **2 = MAX** | *equity **o** saldo di chiusura del giorno prima*: il MAX è il conservativo dei due |
| **Alpha Capital** | Alpha Capital | **2 = MAX** | *saldo **e/o** equity di inizio giornata*: formula ambigua → si prende la più severa |

🔴 **Classe di prova**: questi regolamenti sono `[LETTO-VIA-SEARCH]`, non
letture dirette (il proxy blocca tutti i domini prop). **Prima di firmare un
modo per un conto pagato, i due numeri vanno confermati da Claudio sul sito o
per iscritto dal supporto** — è la F4 di `PIANO_PROP.md`.

---

# 4. 🧪 L'AUTOTEST — 22 casi nuovi

Sì, il Guardian ha `InpAutotest` (default `false`, non tocca il conto). Ora fa:

```mql5
   if(InpAutotest)
     {
      ABTG_AutotestGuardia();       // casi del canale (nell'include, INVARIATI)
      AutotestBaselineGiorno();     // v1.14: casi del modo della baseline
     }
```

📌 **I casi nuovi stanno nel `.mq5` del Guardian, NON nell'include.** Motivo:
`ABTG_PausaGuardian.mqh` è condiviso con **tutti** gli altri EA e il conteggio
dei suoi casi (**159**, marcatore v1.60) è un **cancello di collaudo**.
Toccarlo avrebbe spostato quel numero per EA che non c'entrano niente. Il conto
dell'include resta **159/v1.60**, intatto.

| gruppo | casi | cosa fissa |
|---|---:|---|
| **A. il caso del dossier** (100k, −0,8% flottante) | 5 | modo 0 → 99.200 · modo 1 → 100.000 · modo 2 → 100.000, **e i due pavimenti 94.200 vs 95.000** |
| **B. flottante positivo** | 3 | il verso si inverte: a modo 0 siamo **più prudenti** della prop (innocuo) |
| **C. conto REALE col credito** (5.000 / 7.500) | 4 | modo 0 → 7.500 (**fix v1.12 intatto**) · modo 1 → 5.000 (**riapre il bug**) · modo 2 → 7.500 · **e il limite dichiarato**: con flottante peggiore del credito il MAX ripesca il saldo contaminato |
| **D. input fuori scala** (7, −1) | 2 | ripiegano su EQUITÀ, mai su un modo inventato |
| **E. invarianti** | 3 | il modo 2 **non sta mai sotto** agli altri due; a conto fermo i tre coincidono |
| **F. il nome del modo** | 5 | i tre testi esistono, sono **distinti**, e il ripiego si dichiara |

🔴 **ESITO: NON MISURATO.** L'autotest è **scritto**, non **eseguito**: qui non
c'è MetaEditor. Gira alla prima apertura con `InpAutotest=true` e la riga da
cercare nella scheda Esperti è:

```
[AUTOTEST] baseline giornaliera: TUTTI I 22 CASI PASSATI.
```
Se compare `%d CASI FALLITI`, **non si mette in campo**.

---

# 5. 🔍 QUELLO CHE HO TROVATO E NON HO TOCCATO (lo dico, non lo aggiusto)

1. **`mql5/Scripts/ABTG_CanarinoGuardian.mq5`** (riga 607 e dintorni) legge le
   GlobalVariable **senza il suffisso `_V2`**: `ABTG_GUARD_%I64d_DAYSTART`,
   `..._START`, `..._PEAK`, `..._DAYKEY`, `..._BLOCKDAY`. Il Guardian dalla
   **v1.12** scrive sui nomi **`_V2`**. 👉 Il canarino sta guardando **caselle
   vuote o vecchie**: è un **difetto pre-esistente al mio intervento**, fuori
   dal mandato di oggi, ma va sistemato prima di fidarsi di quel referto.
2. Il **pannello** non mostra il modo. Non l'ho aggiunto per non toccare niente
   oltre la baseline: se Claudio lo vuole, è una riga.
3. `gStart` (saldo iniziale della challenge) resta **sempre dall'equità**, come
   da v1.12: **non** l'ho legato al modo. Il modo governa **solo la giornata**.

---

# 6. ⚠️ QUELLO CHE NON È STATO FATTO

- 🔴 **NON COMPILATO.** In questo ambiente non c'è MetaEditor: nessun `.ex5`,
  nessun warning letto. Ho fatto solo controlli statici: **0 caratteri non
  ASCII** (niente emoji nel `.mq5`), **graffe e parentesi bilanciate**
  (parser che ignora stringhe e commenti), nessuna collisione di nome con
  l'include, `%s/%d/%.2f` coerenti coi tipi, funzioni definite **prima**
  dell'uso. **La prova è la compilazione di Claudio con F7.**
- 🔴 **NON PROVATO IN CAMPO.** Nessun preset modificato, nessun EA riattaccato.
- ✅ **NON toccati**: soglie (pausa 4,0 / emergenza 4,9 e 9,9 / reset 23), cap
  C1 (3,25%), cap C2 (per cluster), logica di chiusura `FlattenAll`, canale
  GlobalVariable verso gli EA, `ABTG_PausaGuardian.mqh`, altri EA, preset.

## 📋 Cosa deve fare Claudio, in ordine
1. **F7** su `ABTG_Guardian.mq5` in MetaEditor → 0 errori (i warning si leggono).
2. Aprirlo **una volta con `InpAutotest=true`** su un grafico qualsiasi del
   **demo 50503392** (`BCM Markets MT5 Terminal`) → cercare
   `TUTTI I 22 CASI PASSATI`. **Non sul reale.**
3. Rimetterlo a `InpAutotest=false`, `InpDailyBaseline=0`, e verificare nel
   giornale che la riga del nuovo giorno prop dica `(modo=EQUITA')`.
4. **Solo dopo**, e **solo se lo firma**, decidere il modo per il conto prop.
