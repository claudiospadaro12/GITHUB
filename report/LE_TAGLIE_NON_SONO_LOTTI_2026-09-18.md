# 🎚️ «PIÙ LOTTI CHE POSSIAMO» — ma le nostre sedie **non si tarano a lotti**

**18/09/2026** · nasce da Claudio: *«Facciamo più lotti che possiamo»* · *«Ma sono bassi.
Io pensavo su dax 10 lotti, oro 3 lotti ecc ecc»*

> ## 🟢 **LA NOTIZIA BUONA È CHE LA MANOPOLA C'È GIÀ, ED È UNA SOLA PER SEDIA.** Non dobbiamo inventare un dimensionatore: tutte e quattro le sedie della rosa calcolano il lotto **da sole**, partendo da `InpRiskPercent` e dalla distanza dello stop. Il lotto non è un input: è un **risultato**.

---

## ① IL FATTO, verificato nel sorgente di tutte e quattro

| magic | EA | riga del sorgente | manopola |
|---|---|---|---|
| `770201` | `ABTG_Nasdaq_Apertura_US.mq5` | r.260 (+ r.47) | `InpRiskPercent = ABTG_DEF_RISK` (**2.0**) — *«Rischio per trade in % (piano: **max 2%**)»* |
| `770511` | `ABTG_SuperWave.mq5` | r.89 | `InpRiskPercent = 1.0` — *«rischio per trade in % (sull'intera size)»* |
| `770402` | `ABTG_MaxMinNotte.mq5` | r.171 | `InpRiskPercent = 2.0` — *«piano: 2%»* |
| `770101` | `ABTG_DAX_Apertura_EU.mq5` | r.313 | `InpRiskPercent` — *«contratto sedia: 1,0 — tetto A4: mai sopra 1»* |

**E il campo lo conferma** — ⚠️ **sul DAX**, non su tutte: `770402` ha **0,01 lotti su tutte e
11 le posizioni**, lotto **invariante**, e lì il campo non conferma niente (serve
`SYMBOL_VOLUME_MIN` letto sul terminale). Ma la sedia `770101` ha operato con lotti da **0,40 a 2,70** (6,75 volte)
sullo stesso simbolo. Non è incoerenza — è il dimensionatore che lavora: **quando lo stop è
stretto il lotto cresce, quando è largo cala, e la perdita resta la stessa.**

👉 Quindi *«DAX 10 lotti»* non è un parametro che si scrive da nessuna parte. Si scrive
**una percentuale**, e i 10 lotti escono (o non escono) a seconda di quanto è lontano lo stop
quel giorno. 🔴 **E `InpRiskPercent` è firma di Claudio, non mia** (mandato 08/09).

---

## ② LA PROVA CHE IL DIMENSIONATORE FUNZIONA — i sette stop del DAX

Sette stop in perdita di `770101`, dal 23/07 al 14/08. Lotto e perdita, affiancati:

| chiusura | lotto | perdita |
|---|---:|---:|
| 2026.07.23 13:39 | 0,90 | 114,30 |
| 2026.07.29 13:01 | 1,60 | 115,04 |
| 2026.07.29 13:01 | 1,60 | 120,80 |
| 2026.07.29 13:16 | 1,60 | 115,04 |
| 2026.08.06 09:11 | 0,90 | 102,96 |
| 2026.08.10 09:00 | 1,70 | 101,83 |
| 2026.08.14 09:17 | 2,00 | 104,60 |

### ⚠️ MA LA RIGA NON È IL SEGNALE, E IL 29/07 LO DIMOSTRA
Le due posizioni del 29/07 (−115,04 e −120,80) sono **lo stesso segnale**: stesso `open_time`,
08:53:56, 1,60 lotti ciascuna. Il rischio di quel segnale è stato **−235,84 € = 3,91% del saldo
all'apertura (6.035,11 €)**, non due volte 2%. Con la ripartenza delle 13:01 la giornata fa
**−350,88 = 5,8%**.
🔴 E lo schema era già in repo: `report/A1_A4_rischio_immediato.md` §A1 — *«due EA identici, 4%
su un segnale solo»* — sulla gemella `770311` (`Apertura Marco`, identica su 64 parametri).
👉 **Il dimensionatore per POSIZIONE funziona. Per SEGNALE no.**

> ## ✅ **Il lotto varia di 2,2 volte (0,90 → 2,00). La perdita varia del 18,6% (101,83 → 120,80).** È esattamente il comportamento che deve avere un dimensionatore a rischio. Funziona.

---

## ③ 🔴 E IL CAMPO HA CONFERMATO, DA SOLO, IL BUG C4 DEL 02/09

Ricostruito il saldo al momento di ogni stop (ancora: bilancio **5.129,30 €** del
`ReportTrade50503392.xlsx` timbrato 2026.09.09 09:04, più il P/L cumulato del CSV a ritroso):

| chiusura | perdita | saldo **all'APERTURA** | **= % del saldo** |
|---|---:|---:|---:|
| 2026.07.23 | 114,30 | 6.005,19 | **1,903%** |
| 2026.07.29 | 115,04 | 6.035,11 | **1,906%** |
| 2026.07.29 | 120,80 | 6.035,11 | **2,002%** |
| 2026.07.29 | 115,04 | 5.703,59 | **2,017%** |
| 2026.08.06 | 102,96 | 5.643,42 | **1,824%** |
| 2026.08.10 | 101,83 | 5.309,99 | **1,918%** |
| 2026.08.14 | 104,60 | 5.252,41 | **1,991%** |

**Sette su sette fra 1,82% e 2,02%.** Il contratto di quella sedia dice **1,0%**.

📐 Il saldo è quello che il **codice legge davvero**: `AccountInfoDouble(ACCOUNT_BALANCE)`
all'**apertura** (`ABTG_DAX_Apertura_EU.mq5` r.1794-1795). Ricostruirlo alla **chiusura** sposta
la banda a 1,88-2,26% **e la rende sensibile all'ordine dei trade che chiudono nello stesso
secondo** (la gemella `770311`): non è una misura, è un artefatto di ordinamento. Classe **428**.

🟢 **Ma non è una ferita aperta: è il FIX C4 che si vede in campo.** Il sorgente lo dice
a `ABTG_DAX_Apertura_EU.mq5` **r.90**: *«02/09: era 2.0. Il default compilato era il DOPPIO
del contratto (1,0%) e della riga rossa A4: ogni RIPRISTINA rimetteva il 2%. FIX firmato C4.»*
Commit `9638318f`. **Tutti e sette gli stop sono PRIMA del 02/09.**

> ## 🟠 **NON È UNA SCOPERTA NUOVA, ED È GIUSTO DIRLO.** Il campo aveva già parlato: `report/PIANO_PROP.md` r.1072 (M27) misurava **tre stop pieni a −2,02 / −2,00 / −2,05%** su 06, 10 e 14/08 — ed è **quella** misura che ha portato al FIX C4 del 02/09, non il contrario.

🔴 **E i tre numeri non coincidono con i miei** (1,824 / 1,918 / 1,991% a saldo d'apertura):
stessa storia, **tre basi di calcolo diverse**. Prima di citarne una qualunque va detto **su che
saldo** è presa. Quello che questa passata aggiunge è il **campione completo (7 stop, non 3)** e
la base dichiarata — **non** una seconda strada indipendente. *(Classe 423: verifica circolare
travestita da conferma indipendente. L'avevo già pagata stamattina sul 41,7×.)*

### 🧪 Il contro-esempio, perché il 2% non è un artefatto della mia ricostruzione
Tre ipotesi alternative, tutte e tre chiuse con un numero:
1. *«il saldo di luglio era il doppio»* — **no**: fra il 23/07 00:00 e l'ancora del 09/09 09:04
   il P/L cumulato (profit+commissioni+swap) è **−941,78 €**, e il saldo ricostruito al 23/07 è
   **6.071,08 €**. Per arrivare a ~11.000 servirebbe un calo che nei trade non c'è.
2. *«la taglia si calcola sull'EQUITÀ»* — **no**: il codice legge `ACCOUNT_BALANCE`
   (DAX r.1794-1795 · SuperWave r.526 · MaxMin r.733 · Nasdaq r.2032).
3. *«è il lotto minimo»* — **no**: lotti fra 0,40 e 2,70, lontanissimi dal minimo.

🔴 **L'ipotesi che invece REGGE, ed è un'altra cosa**: due posizioni sullo stesso segnale
(29/07 08:53:56). Non smentisce il 2% per posizione — **lo raddoppia per segnale**.
🕳️ **E una che resta aperta**: la ricostruzione assume che il CSV contenga tutti i movimenti e
**nessun versamento**. Il CSV porta solo trade: un'operazione di saldo non comparirebbe.
Si chiude con uno statement MT5 che abbia le righe di balance — non ce l'ho.

---

## ④ IL RISCHIO **REALIZZATO**, sedia per sedia — ed è qui che si decide

| magic | sedia | **contratto FIRMATO** | **realizzato in campo** | |
|---|---|---:|---:|---|
| `770101` | DAX Apertura | 1,0% (era 2,0 fino al 02/09) | **~1,93%** (n=7 posiz.) | 🟠 spiegato dal C4 |
| `770402` | MaxMin ORO | **0,5%** (firma R100 del 23/08 — `CONTRATTI_SEDIE.md` r.95) | **~0,55%** (n=2) | 🟢 **IN CONTRATTO** |
| `770511` | SuperWave DOW | 1,0% | **~0,33%** (n=**1 SEGNALE**, 2 gambe) | 🔴 **campione da uno** |
| `770201` | Nasdaq Apertura | **0,25%** — ed è 🔴 **[SENZA CONTRATTO]** | **MAI STOPPATA** | 🔴 **spenta dal 18/08** |

⚠️ La colonna si chiama **«contratto firmato»**, non «preset»: per `770511` e `770402` il numero
viene da `CONTRATTI_SEDIE.md`, non da un `.set` del piccolo (che in repo non c'è).

### 🔴 Due cose qui non tornano, e tutte e due contano per la challenge

**(a) `770511` ha UN SOLO segnale perdente in tutto il forward**: 03/09, due gambe (−8,48 e
−8,49), **−16,97 € = 0,332% del saldo**, contro un contratto dell'1,0%.
⚠️ Le altre tre gambe negative del CSV **non sono perdite**: appartengono ai segnali del 27/07
(netto **+10,45**) e del 31/07 (netto **+4,59**), chiusi in **utile**. Contarle dà *«0,13% su
n=4»* — **2,5 volte sotto il vero, con una n quattro volte più grande di quella reale**.
🔴 **Classe 427**, ed è l'errore che Claudio aveva corretto poche ore prima sulla **stessa
sedia** (`LE_SEDIE_PER_LA_PROP` r.76: *«n = 5 SEGNALI, non 10»*): l'avevo sistemato nella colonna
del conteggio e me l'ero fatto rientrare da quella del rischio.
👉 **Con n=1 il rischio realizzato di questa sedia NON è misurato.** Il perché sta in
`report/PERCHE_SUPERWAVE_FA_013_2026-09-18.md`: è il **trailing**, non la taglia.

**(b) `770201` non è mai stata stoppata in perdita: 10 posizioni, 10 vinte, ZERO perse.**
👉 Il suo drawdown per lotto **non esiste nei dati di campo**. È esattamente il buco che
l'agente sta misurando adesso col p99 per riordino — e adesso sappiamo **perché** quel numero
mancava: non è una svista d'archivio, **è che il campo non ha mai prodotto il dato**.
🔴 **E manca il pezzo che pesa di più: `770201` è SPENTA dal 18/08 09:41 (FIRMA 5) ed è
[SENZA CONTRATTO].** Non è un buco d'archivio: è stata **MISURATA e bocciata** — tick reali del
31/07 **PF 0,82 · DD 17% · SCARTATO**, walk-forward del 05/08 **19 celle OOS negative su 20**
(`report/CONTRATTI_SEDIE.md` r.54 · `report/CENSIMENTO_CONTRATTI_v2.md` r.363).
👉 Le 10 vittorie vanno dal 20/07 all'11/08 e **finiscono lì perché la sedia è stata spenta**.
Dieci trade in tre settimane non ribaltano un walk-forward 19/20 negativo.

⚠️ E il suo preset `mql5/Presets/ABTG_Nasdaq_Apertura_US.set` porta `InpRiskPercent=2.0` contro
un contratto di **0,25** — **otto volte** — e sopra la riga rossa **A4**, che non è un commento
nel codice ma una **firma di Claudio**: *«nessuna sedia sopra l'1% sul conto piccolo, mai»*
(FIRMA 4 del 18/08/2026 — `report/PIANO_PROP.md` r.1072, verbale `report/FIRME_2026-08-18.md`).
🔴 Il sorgente del Nasdaq, **da solo, dice l'opposto**: r.260 *«piano: max 2%»* con
`ABTG_DEF_RISK = 2.0` a r.47. **Chi apre quel file trova il permesso, non il divieto** — stessa
forma del bug C4 sul DAX, su un'altra sedia. *(Classe **429**: il vincolo firmato citato dal
commento di un altro EA. E attenzione: in repo ci sono **due «A4»** — il tetto di rischio e la
guardia «ho già operato oggi» di `A1_A4_rischio_immediato.md`.)*
📌 A4 è firmata sul **conto piccolo in forward**: per la challenge prop la taglia è una **firma
nuova**, non un'estensione automatica.

---

## ⑤ 🔴 UNA CORREZIONE ALLA SELEZIONE DI UN'ORA FA

`report/LE_SEDIE_PER_LA_PROP_2026-09-18.md` mette fra i criteri **«un solo simbolo»** e lo
applica anche a `770101`. **È falso**: `770101` ha **38 posizioni su D30EUR e 1 su NASUSD**.

Una posizione su 39 non cambia il giudizio sulla sedia, **ma cambia il criterio**: se
«un solo simbolo» è un cancello, allora `770101` non lo passa e va detto.

🔴 **E c'è una SECONDA contraddizione con lo stesso referto, da chiudere:** lì `770201` ha
**7 segnali e +98,49 €**, qui **10 posizioni e 10 vinte**. Il CSV dice **10 posizioni, su 10
giorni distinti, una per segnale, somma profit +228,34 €**. Tre numeri, due finestre diverse,
nessuna riconciliazione: finché non si chiude, **la n di `770201` non è utilizzabile**.

---

## ⑥ COSA RESTA DA MISURARE PRIMA DI TOCCARE UNA TAGLIA

1. ⏳ **p99 del DD di `770201`** — in corso. Senza, il Nasdaq è la sedia col record migliore
   e **il rischio ignoto**.
2. 🔎 **Perché `770511` realizza 0,13% invece di 1,0%.** Finché non si sa, «alziamola» è un
   auspicio, non una leva.
3. 📐 **Quale preset è davvero in campo per `770201`** — la lezione `EMA200` (il binario del
   04/08 senza Guardian) dice che il repo e il VPS possono non combaciare. Il 2,0% nel `.set`
   va verificato sul terminale **50503392 (`BCM Markets MT5 Terminal`)**, in sola lettura.
4. ✍️ **E poi firma Claudio.** `InpRiskPercent` è suo, per mandato.

---

## 📌 In una riga
**Non si mettono più lotti: si alza una percentuale, e i lotti seguono.** Il dimensionatore
funziona (provato sui sette stop del DAX), il bug che raddoppiava il rischio era reale ed è
stato chiuso il 02/09 (riconfermato qui dai P/L veri), **ma due delle quattro sedie hanno un
rischio realizzato che non somiglia al contratto** — e una delle due non è mai stata stoppata.
🔴 **Alzare una taglia sopra un numero che non abbiamo misurato sarebbe il modo più veloce di
ripetere il 18 settembre.**

---
*Fonti: `data/statements/trades_auto.csv` (piccolo 50503392, dichiarato in
`backtest_pipeline/pubblica_trades.ps1` r.9) · i quattro sorgenti `.mq5` e i quattro `.set`
citati per riga · `report/PICCOLO_50503392_2026-09-09.md` r.9 per l'ancora di bilancio ·
commit `9638318f` per il fix C4.*
