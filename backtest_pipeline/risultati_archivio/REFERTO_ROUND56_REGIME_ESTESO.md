# ⚖️ REFERTO R56 — LA PROVA DI REGIME ESTESA (15/08/2026)

_14 celle × 4 finestre = **56 CSV su 56**. Feed `_EXT` HistData 2018-2024,
modello 1 (OHLC M1), deposito 100.000, rischio 1%._

**Igiene: le due righe gemelle del magic sono identiche in 56 file su 56.**
Nessuna cella ha risposto in modo diverso a se stessa.

> ⚠️ **OHLC = SCREENING.** Questi numeri servono a dire chi sopravvive e chi
> si distrugge, **non** a decidere un profitto. I verdetti di merito restano
> ai tick reali. **Nessun parametro in forward cambia per questo referto.**

---

## 1. LA TABELLA

Profit in EUR su 100.000 al rischio 1%. `n` = operazioni.

| cella | ORSO 2022 | CROLLO 2020 | TORO 2021 | LATERALE 2019 |
|---|---|---|---|---|
| **PTE_GBPUSD** | **+1.245** PF 1,62 DD 2,0 n18 | **+70** PF 1,07 DD 1,4 n11 | +1.362 PF 1,45 n37 | +5.284 PF 1,84 n51 |
| **PTE_USDJPY** | −1.888 PF 0,81 DD 5,4 n46 | **+1.079** PF 2,08 DD 1,6 n7 | +203 PF 1,04 n36 | +3.744 PF 1,90 n40 |
| **COST_EURJPY** | **+47.260** PF 2,65 DD 14,3 n43 | **−12.711** PF **0,02** DD 14,8 n23 | +1.255 PF 1,05 n46 | +8.918 PF 1,38 n54 |
| **COST_GBPCAD** | **−12.754** PF 0,61 DD **18,9** n48 | −5.979 PF 0,50 DD 9,5 n16 | +8.417 PF 1,24 n61 | −5.228 PF 0,85 n58 |
| **EZ_AUDJPY** | −1.246 PF 0,93 DD 4,3 n35 | −185 PF 0,96 DD 5,2 n10 | +5.278 PF 1,28 n44 | −9.993 PF 0,61 n44 |
| **EZ_CHFJPY** | −389 PF 0,98 DD 4,3 n30 | −1.625 PF 0,73 DD 6,0 n9 | +4.587 PF 1,17 n49 | +3 **n1** |
| **EZ_GBPUSD** | −124 PF 0,99 DD 10,0 n32 | −4.507 PF 0,39 DD 4,8 n10 | +279 PF 1,01 n34 | +9.443 PF 1,54 n35 |
| **LARRY_GBPUSD** | +1.587 PF 1,78 DD 2,2 n12 | −708 PF 0,29 DD 2,2 **n3** | +4.095 PF 2,02 n19 | −6.445 PF 0,34 n16 |
| **LARRY_ORO** | −246 PF 0,72 DD 1,5 **n2** | +1.496 DD 1,0 **n1** | +5.052 PF 3,03 n11 | +5.202 PF 4,96 n7 |
| **BB_EURUSD** | +932 PF 1,63 DD 1,4 n7 | +502 DD 0,2 **n1** | −1.561 PF 0,60 n9 | −2.381 PF 0,37 n9 |
| **BB_GBPUSD** | −144 PF 0,93 DD 1,9 n8 | −4 PF 1,00 DD 1,5 n6 | −155 PF 0,97 n18 | +735 PF 1,26 n12 |
| **SW_GBPUSD** | −205 PF 0,96 DD 4,0 n51 | +115 PF 1,07 DD 1,6 n17 | −3.187 PF 0,56 n65 ⚠️ | −938 PF 0,80 n61 |
| **GAP_EURUSD** | **0 trade** | **0 trade** | **0 trade** | **0 trade** |
| **GAP_GBPUSD** | **0 trade** | **0 trade** | **0 trade** | +1.000 **n1** |

---

## 2. 🏆 IL RISULTATO: **PTE_GBPUSD** e' l'unico che passa tutto

Criteri congelati il 14/08. **B** (tenuta): PF ≥ 0,90 in ORSO **e** CROLLO.
**C** (promozione): PF ≥ 1,10 nell'ORSO con DD in regola. **D**: serve la
stessa direzione nelle due finestre avverse.

| cella | ORSO PF | CROLLO PF | B | C | esito |
|---|---:|---:|:--:|:--:|---|
| **PTE_GBPUSD** | **1,62** | **1,07** | ✅ | ✅ | 🏆 **PROMOSSO DI RANGO** |
| BB_GBPUSD | 0,93 | 1,00 | ✅ | ❌ | tiene: non sanguina |
| SW_GBPUSD | 0,96 | 1,07 | ✅ | ❌ | tiene |
| EZ_AUDJPY | 0,93 | 0,96 | ✅ | ❌ | tiene |
| EZ_CHFJPY | 0,98 | **0,73** | ❌ | ❌ | tenuta persa nel crollo |
| EZ_GBPUSD | 0,99 | **0,39** | ❌ | ❌ | tenuta persa nel crollo |
| PTE_USDJPY | **0,81** | 2,08 | ❌ | ❌ | **D**: le due finestre dicono il contrario |
| LARRY_GBPUSD | 1,78 | **0,29** | ❌ | ✅ | **D** non passa |
| COST_EURJPY | **2,65** | **0,02** | ❌ | ✅ | **D** non passa (§3) |
| **COST_GBPCAD** | **0,61** | **0,50** | ❌❌ | ❌ | 🔴 **DECLASSAMENTO** |

> **`PTE_GBPUSD` e' l'unica cella del portafoglio che, senza toccare un
> parametro, sopravvive all'orso 2022 E al crollo Covid, e nell'orso guadagna
> davvero (PF 1,62).** Il criterio C dice testualmente: _"questi sono gli EA
> che cerchiamo davvero"_. Ne abbiamo uno, ed e' misurato.
>
> Da notare: **PTE e' anche la cella con meno parametri di tutte** — tre
> input in tutto. Il piu' semplice e' anche l'unico robusto.

## 3. 🚨 COST_EURJPY: il numero piu' bello della tabella e' anche il piu' pericoloso

**+47.260 con PF 2,65 nell'orso.** E' il miglior risultato assoluto di tutte
e 56 le corse. Chiunque lo guardasse da solo direbbe "ecco l'EA da mercato
orso".

**Poi c'e' il crollo Covid: −12.711 con PF 0,02.**

PF 0,02 non e' "ha perso": vuol dire che su 23 operazioni **il lordo vinto e'
il 2% del lordo perso**. Praticamente solo perdite.

> 🎯 **Il criterio D — "nessuna decisione da una sola finestra" — esiste
> esattamente per questo caso.** Senza quella regola, +47.260 sarebbe bastato
> a promuovere una cella che in un crollo si disintegra.

## 4. 🔴 COST_GBPCAD: l'unico declassamento

Fallisce la tenuta in **entrambe** le finestre avverse (PF 0,61 e 0,50), e
nell'orso ha **DD 18,9%** — a un soffio dal tetto del 20% del criterio A, e
**tre volte** il DD della peggiore fra le altre celle.

**Va a peso dimezzato**, come prescrive il criterio A.

## 5. 📊 Il dato trasversale: la famiglia COST e' di un'altra categoria di rischio

| famiglia | DD nelle finestre avverse |
|---|---|
| PTE | 1,4 – 5,4% |
| BB · LARRY | 0,2 – 2,2% |
| EZ · SW | 1,6 – 10,0% |
| **COST** | **9,5 – 18,9%** |

A parita' di rischio dichiarato (1%), COST produce drawdown **da due a dieci
volte** quelli delle altre famiglie. Non e' un verdetto sulla strategia: e'
un fatto sul suo profilo, e va tenuto presente quando si pesa il portafoglio.

## 6. ⚠️ Le celle NON GIUDICABILI (e non vanno contate come bocciate)

- **`GAP_EURUSD`: ZERO operazioni in tutte e quattro le finestre.**
  `GAP_GBPUSD`: **una** in quattro anni. Su questo feed la famiglia GAP **non
  e' misurabile**. Identico a R50: e' consistente, non e' un guasto nuovo.
- **`LARRY_ORO`**: n=2 nell'orso, **n=1** nel crollo. Il campione non esiste.
  (I numeri di TORO e LATERALE — PF 3,03 e 4,96 — sono ottimi ma su n=11 e
  n=7: da guardare, non da usare.)
- **`BB_EURUSD`** e **`EZ_CHFJPY` nel laterale**: **n=1**. Il PF stampato 0,00
  significa "nessuna perdita, PF indefinito", non "PF zero".

## 7. ⚠️ [INCERTO] Una riga non riproduce R50, e va capita prima di usarla

`SW_GBPUSD` riproduce R50 **al centesimo in tre finestre su quattro**:
ORSO −205 n51 ✓, CROLLO +115 n17 ✓, LATERALE −938 n61 ✓.
**Ma il TORO no**: R50 diceva −2.419 PF 0,63 n63, qui esce **−3.187 PF 0,56
n65**.

Il file celle porta una nota del 14/08: la cella era stata lanciata per
errore a H4 (16388) invece che H2 (16386), e il lancio "va rifatto". **Ma se
il TF fosse cambiato, dovrebbero cambiare tutte e quattro le finestre, non
una.** Non ho una spiegazione, e non la invento.

**Quella singola casella non si usa finche' non e' capita.** Le altre tre di
SW, essendo identiche a R50, valgono.

## 8. ▶️ Cosa si fa adesso

1. **Nessun cambio in forward.** Questo e' screening OHLC.
2. **`PTE_GBPUSD` sale di rango**: e' il candidato numero uno per il peso
   pieno e per la prop, e merita un round dedicato **a tick reali**.
3. **`COST_GBPCAD` a peso dimezzato** (criterio A).
4. **`COST_EURJPY` resta com'e'**, con l'avvertenza del crollo scritta
   accanto: il suo +47.260 nell'orso **non** e' una ragione per aumentarlo.
5. **Da coprire**: `COST_XAGUSD` (import mancante) e tutta la fascia INDICI,
   che aspetta i dati lunghi.
