# 🧪 R80 — **LA SEDIA USDJPY HA UN MANDATO, ED È UNO SOLO: IL LATERALE.** E il giro nativo apre un problema più grande.

_Prova di regime su `PTE`. Criteri congelati in `prove/R80_CRITERI.md`.
40 CSV su 40 (20 `_EXT` + 20 nativi), 4 celle × 5 finestre × 2 giri._

---

## 1. ✅ IL CONTROLLO CHE VIENE PRIMA DI TUTTO: **`_EXT` RIPRODUCE R56 AL CENTESIMO**

**Otto misure su otto, a giorni di distanza, con lo script rilanciato da zero:**

| cella | finestra | **R56 (allora)** | **R80 (adesso)** |
|---|---|---|---|
| PTE_USDJPY | ORSO | −1.888 PF 0,81 DD 5,4 n46 | **−1.888 PF 0,813 DD 5,36 n46** ✅ |
| PTE_USDJPY | CROLLO | +1.079 PF 2,08 DD 1,6 n7 | **+1.079 PF 2,084 DD 1,64 n7** ✅ |
| PTE_USDJPY | TORO | +203 PF 1,04 n36 | **+203 PF 1,044 n36** ✅ |
| PTE_USDJPY | LATERALE | +3.744 PF 1,90 n40 | **+3.744 PF 1,900 n40** ✅ |
| PTE_GBPUSD | ORSO | +1.245 PF 1,62 DD 2,0 n18 | **+1.245 PF 1,616 DD 1,99 n18** ✅ |
| PTE_GBPUSD | CROLLO | +70 PF 1,07 DD 1,4 n11 | **+70 PF 1,068 DD 1,41 n11** ✅ |
| PTE_GBPUSD | TORO | +1.362 PF 1,45 n37 | **+1.362 PF 1,447 n37** ✅ |
| PTE_GBPUSD | LATERALE | +5.284 PF 1,84 n51 | **+5.284 PF 1,838 n51** ✅ |

✍️ **E correggo un mio errore di ieri sera**: nel messaggio di lancio avevo scritto
*"LATERALE +203 · TORO +3.744"*, **invertendo le due finestre**. L'ordine delle
colonne di R56 è `ORSO | CROLLO | TORO | LATERALE` e i numeri combaciano
esattamente. **La macchina era giusta, il mio promemoria no.**

## 2. 🔴 IL SECONDO CONTROLLO **FALLISCE** — e non è un dettaglio di questo round

Stessa cella, stessa finestra, stessi parametri. Cambia **solo il feed**:

| cella | finestra | **`_EXT`** | **NATIVO BCM** |
|---|---|---:|---:|
| **PTEJPY_VIVA** | CROLLO_ANNO | **−2.863** (n52) | **+601** (n48) |
| **PTEJPY_VIVA** | TORO | **+203** (n36) | **−4.660** (n22) |
| **PTEGBP_VIVA** | ORSO | **+1.245** PF 1,62 (n18) | **−4.646** PF **0,23** (n16) |
| **PTEGBP_VIVA** | TORO | **+1.362** (n37) | **−914** (n17) |

**Quattro cambi di segno su misure che dovrebbero essere la stessa cosa.**

### 🔍 Ma NON concludo "i dati importati sono sbagliati". Ecco perché

**Le operazioni sul nativo sono SISTEMATICAMENTE MENO, in tutte e sedici le
celle confrontabili**: 46→32, 36→22, 37→17, 51→40, 18→16…

Un difetto di *qualità* dei dati darebbe differenze **a macchie**. Un calo
**sistematico** del 20-55% dei trade ha una spiegazione molto più semplice:

> 🎯 **Il Modello 1 lavora sulle barre M1. Sul nativo le M1 del 2019-2022 in
> locale NON CI SONO: la sonda del 17/08 dice `da scaricare (parziale)` per
> GBPUSD e USDJPY, e `ABTG_HistoryDownloader` NON è ancora stato lanciato.**
> Senza M1, MT5 le costruisce dai timeframe superiori — e vengono fuori meno
> segnali.

🔴 **Quindi il giro NATIVO è SOSPESO, non "smentito".** È
**[IPOTESI, non misurata]**, e si chiude in un modo solo: **scaricare le M1 e
rifare il giro.** Finché non è fatto, **nessun numero del giro nativo entra in
un verdetto.**

⚠️ **E il punto grosso resta aperto lo stesso**: se dopo il download la
divergenza restasse, non riguarderebbe R80 — riguarderebbe **R50, R56 e R59**,
cioè tutti i round costruiti sui `_EXT`. **È la cosa più importante da chiudere
di tutto questo blocco.**

---

## 3. 🎯 IL VERDETTO SU `PTE USDJPY` — sul giro `_EXT`, l'unico giudicabile oggi

| cella | ORSO | CROLLO_ANNO | TORO | LATERALE |
|---|---:|---:|---:|---:|
| 🪑 **VIVA** (771323) | **−1.888** PF **0,813** n46 | **−2.863** PF **0,716** n52 | +203 PF 1,044 n36 | **+3.744** PF **1,900** n40 |
| `S25` (solo short) | **−896** PF **0,765** n32 | +370 PF 1,159 n30 | +66 PF 1,052 n21 | **+2.022** n20 |

**Criterio B dei criteri di regime — _PF ≥ 0,90 nelle finestre avverse_:**

> ## 🔴 **BOCCIATO. La sedia viva fa PF 0,813 nell'ORSO e 0,716 nel CROLLO_ANNO: sanguina in ENTRAMBE le avverse, con n=46 e n=52 (campione pieno, verdetto pieno).**
> **E la variante `solo short` non la salva: PF 0,765 nell'orso.**

**Ma la domanda del round era un'altra — *in quali regimi funziona?* — e una risposta ce l'ha:**

> ### 🎯 **FUNZIONA NEL LATERALE. +3.744 con PF 1,90 su 40 operazioni. E praticamente solo lì.**
>
> Il TORO fa **+203 con PF 1,044**: zero travestito da positivo.
> **Un mandato c'è, ma è UNO SOLO su cinque finestre.**

📌 **È anche l'unica cosa che ha sempre avuto senso**: la PTE è un
**mean-reversion sugli estremi di un canale**. Nel laterale il prezzo torna
sempre; nel trend no. **Il motore fa quello che dice di fare — su un simbolo
che dal 2013 ha trendato quasi sempre.** Ed è coerente con R77/R78 (13 anni
negativi) e R79 (nessun lato si salva): **non gli mancava una taratura, gli
mancava il mercato.**

## 4. ⚔️ E IL DUELLO GBPUSD, LETTO PER REGIME — questo serve da domani

| finestra | 🪑 **storica** `771322` | 🧪 **candidata** `771332` | chi vince |
|---|---:|---:|---|
| **ORSO 2022** | +1.245 PF 1,616 | **+1.406 PF 2,387** | 🧪 candidata *(n=19, merito sospeso)* |
| **CROLLO** | **+70** | −302 | 🪑 storica *(n=11, sospeso)* |
| **CROLLO_ANNO** | +66 PF 1,013 | **+432 PF 1,142** | 🧪 candidata |
| **TORO 2021** | **+1.362 PF 1,447** | +674 PF 1,331 | 🪑 storica |
| **LATERALE 2019** | **+5.284 PF 1,838** | +1.110 PF 1,182 | 🪑 **storica, nettamente** |

> ### 🎯 **La candidata vince nell'ORSO, la storica nel LATERALE e nel TORO.**
>
> **Non è un dettaglio: è la chiave per leggere i prossimi dieci mesi di duello.**
> Se il periodo che viene è laterale, la storica sembrerà migliore; se è un
> mercato in discesa, la candidata. **Scritto adesso, prima di vedere il primo
> trade** — così quando arriveranno i numeri non ci racconteremo che uno dei
> due "ha ragione" quando invece ha solo avuto il suo regime.

📌 E rende ancora più solido il perché non abbiamo scelto: **su tredici anni
contigui vince la candidata (R78), su due anni a tick reali vince la storica
(R73), e per regime vincono in finestre diverse.** Il forward è l'unico giudice
che le vede entrambe nello stesso mercato.

---

## 5. 🚦 VERDETTO

> **1. ✅ Il giro `_EXT` riproduce R56 su 8 misure su 8, al centesimo.** La
> macchina della prova di regime è affidabile.
>
> **2. 🔴 `_EXT` e NATIVO divergono, anche di segno — ma il giro nativo è
> SOSPESO**: mancano le M1 in locale, e il calo sistematico dei trade lo dice.
> **Si chiude scaricando lo storico, non discutendo.**
>
> **3. 🎯 `PTE USDJPY` funziona nel LATERALE (+3.744, PF 1,90, n=40) e in
> nessun altro regime. E NON tiene nelle avverse: PF 0,813 e 0,716.**
>
> **4. ⚔️ Nel duello GBPUSD: candidata forte nell'ORSO, storica forte nel
> LATERALE.** Da tenere a mente per tutti i prossimi mesi.
>
> **5. 🔴 Nessuna modifica in forward.** Tredici round, zero parametri toccati
> (l'unico intervento è stato *aggiungere* una sedia, non cambiarne una).

## 6. 🪑 LA DOMANDA CHE ADESSO È DI CLAUDIO

La serie R77 → R80 ha risposto a tutto quello a cui poteva rispondere:

| | |
|---|---|
| È la taratura? | ❌ no — R77 (0/28), R78 (1/14) |
| È un lato? | ❌ no — R79 (0/8) |
| **In quali regimi funziona?** | 🎯 **nel laterale, e solo lì** |
| Tiene nelle avverse? | ❌ **no**, PF 0,813 e 0,716 |

**Le tre strade, con quello che costano:**

| | | pro | contro |
|---|---|---|---|
| **A** | 🔴 **Spegnere `771323`** | libera un posto; su 13 anni perde e non tiene nelle avverse | rinuncia a un motore che nel laterale fa PF 1,90 |
| **B** | 🟡 **Tenerla col mandato scritto**: "sedia da laterale, si giudica solo lì" | onesto e coerente con la regola C | una sedia che va bene in 1 regime su 5 costa comunque un posto |
| **C** | ⏸️ **Aspettare il giro nativo rifatto** | è l'unico dato su cui l'EA opera davvero | qualche giorno |

**Io farei C e poi A**: prima si scaricano le M1 e si rifà il giro nativo — che
è comunque da fare, perché **riguarda anche R50/R56/R59** — e poi si decide con
il dato del broker in mano invece che con quello importato.

## 7. ➡️ IL SEGUITO, IN ORDINE

1. 📥 **`ABTG_HistoryDownloader`, M1 dal 2018** su GBPUSD e USDJPY. **È il
   passo che sblocca tutto**: chiude la divergenza EXT/NAT e mette al sicuro
   R50/R56/R59.
2. 🔁 **Rifare il giro nativo di R80** (`-Nativo`) e confrontare di nuovo.
3. 🪑 **Poi la decisione su `771323`**, con il dato giusto.
4. 📥 **Dukascopy per gli indici**: resta l'unico buco che nessun download BCM
   può chiudere.
