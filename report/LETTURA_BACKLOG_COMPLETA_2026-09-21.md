# 📚 IL BACKLOG LETTO FINO IN FONDO — 98 CSV, 18 motori, 390 passate, una domanda sola

**Data:** 21/09/2026 · **Fonte:** `backtest_pipeline/risultati_prove/dal_vps/`
**Letture precedenti:** `report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` (49 etichette, letta PRIMA)

> **LA DOMANDA:** *c'è dentro questi 98 file un motore che oggi meriterebbe una
> sedia, o una cella che rende migliore una delle sei che già volano?*

## 🎯 LA RISPOSTA, IN TRE RIGHE

🔴 **NO a un motore nuovo: nessuno dei 18 arriva a una sedia.** Dei 18, **4 sono
bocciati per RISCHIO** (fatto accaduto, leggibile a qualunque n), **4 per MERITO con
n ≥ 150**, **3 sono FERMI a un cancello di riproduzione** (i loro PF non sono
leggibili), e **7 restano «NON ANCORA MISURATI»** con il certificato di morte
incompleto — nessuno di loro è morto, e nessuno di loro è pronto.

🟢 **SÌ a UNA cella, e non è nuova: `770101` `InpTP1_ClosePct` 50 → 0** sul
`ABTG_DAX_Apertura_EU`. Era già il primo punto della lettura del 13/09; qui è
**ri-verificata contro le due trappole** (denominatore e scala del lotto) e **le
supera tutte e due**. Resta una **firma di Claudio**.

🔴 **E una cosa NUOVA, che va nella direzione opposta all'entusiasmo:** l'asse
`InpSLatr` della sedia migliore della flotta (`771531`) *sembrava* comprare 2 punti
di DD. **Non li compra: è il lotto che si rimpicciolisce.** Misurato su 4 celle
contigue, con un errore del 2-4%. §4.

---

## 📋 §1 · LA TABELLA DEI DICIOTTO — nessuno manca

`DD valuta` = `Profit / Recovery Factor` (definizione MT5: il *maximal drawdown* su
cui l'RF è costruito). ⚠️ **NON è la stessa grandezza di `Equity DD %`**: quello è il
drawdown di *equity* in percentuale del picco, questo è il drawdown che sta al
denominatore dell'RF. È **coerente fra celle** — che è ciò che serve per confrontarle
— ma **non si deve leggere come «il DD in euro della colonna accanto»**. Dichiarato.

`n` = colonna `Trades` = **deal di uscita**, non posizioni (classe 226).

| # | motore | CSV | passate | miglior cella per PF OOS | DD % | DD valuta | n | verdetto |
|--:|---|--:|--:|--:|--:|--:|--:|---|
| 1 | `ABTG_AtrExhaustVol` | 2 | 4 | **1,22915** (`InpProxMode=1`) | 4,14 | 4.341 | 96 | ⏸️ **NON ANCORA MISURATO** — merito sospeso (n 70/96 ≪ 150); segno discorde IS/OOS; l'altra cella bocciata per rischio (DD IS **19,25 %**) |
| 2 | `ABTG_CostToCost` | 2 | 16 | **1,52364** (`InpMaxBarsHold=50`) | 12,26 | 16.571 | 242 | ❌ **SEDIA BOCCIATA PER RISCHIO** — DD > 10 % in **tutte e due** le finestre (IS 10,99 / OOS 12,26), e su OHLC il DD è un **limite inferiore** → il rifiuto regge a tick. 🔎 **+ asse INERTE**: 6 celle su 8 identiche alla 5ª cifra |
| 3 | `ABTG_DAX_Apertura_EU` | 10 | 44 | 1,49624 (`InpMinStopPts=4800`) — 🔴 **ESCLUSA PER COSTO** (17,8× al p95 < 40×) | 7,25 | 9.105 | 272 | 🟢 **UNA CELLA PROMOSSA** (non questa): `InpTP1_ClosePct` 50→0, **PF OOS 1,49140 · DD 6,2719 % · 193 posizioni**. Vedi §2 |
| 4 | `ABTG_EMA200` | 16 | 72 | 1,77080 (`InpUseTrailing=0`) — 🔴 **segno invertito in IS** (1,107 < 1,201) | 7,42 | 8.794 | 427 | ⚖️ **IL DEFAULT VA BENE** — A1 passa con **5 celle contigue**, ma il **centro** dell'altopiano (`SLatr` 1,2) è **peggiore** della cella viva e nessuna cella la batte di ≥ 0,10 (banda A9). Vedi §3 e §4 |
| 5 | `ABTG_FiboH4_Multi` | 2 | 6 | **0,97210** (`InpEngulfLookback=8`) | 17,29 | 1.980 | 725 | ❌ **BOCCIATO DUE VOLTE** — rischio: DD **17-23 %** su 6 celle su 6; merito: PF < 1,00 su **6 su 6** con n 548-737 (≫ 150, quindi il merito **è** giudicabile) |
| 6 | `ABTG_HVAncora` | 2 | 8 | **1,92073** (`InpStopAtr=1,0`) | 2,06 | 2.092 | 31 | ⏸️ **NON ANCORA MISURATO** — n 22-37, merito **sospeso**; rischio **OK** (DD max 3,84 %). Il tappo è misurato e sta a monte: **91 ancore IS e 165 OOS scadono** |
| 7 | `ABTG_IBRetest` | 6 | 12 | **0,96493** (D30EUR) | 5,25 | 549 | 107 | ⏸️ **NON ANCORA MISURATO** — 🔴 **l'unico "asse" è `InpMagic`**: sono 3 coppie di celle **gemelle**, cioè il cancello G0 di determinismo, **non una griglia**. Zero manopole girate |
| 8 | `ABTG_IntradayMomentum` | 4 | 8 | **1,48607** (`InpUseSecondSignal=1`, NASUSD) | 1,37 | 1.407 | 133 | ❌ **REGIME, NON EDGE** — IS PF **0,46-0,61**, OOS **1,04-1,49**, su **4 celle su 4** e su **tutti e due i gemelli**. Il segno si ribalta ovunque |
| 9 | `ABTG_LVNArbitro` | 4 | 8 | **1,05227** | 11,76 | 12.227 | 618 | ❌ **SEDIA MORTA** — n 392/618 (≫ 150) **e** PF < 1,10 in entrambe (C0), **più** DD IS **18,0-19,4 %**. Asse = `InpMagic` (gemelle) |
| 10 | `ABTG_MaxMinNotte` | 2 | 18 | **1,06212** (`InpMinBoxPts=4500`) | 8,21 | 890 | 59 | ⏸️ **NON GIUDICABILE** (n 10-65) + 🔴 **firma di sovradattamento da manuale**: IS sale **monotono** a PF 9,41 mentre n crolla a 13, OOS scende **monotono** a 0,197. Nessuna cella OOS ≥ 1,10 |
| 11 | `ABTG_Nasdaq_Live5m` | 6 | 22 | **1,07031** (`InpTrailTF`) | 17,62 | 2.074 | 185 | ❌ **BOCCIATO DUE VOLTE** — merito: **nessuna** delle 11 passate OOS arriva a 1,10 (max **1,07031**), e tre hanno n ≥ 150; rischio: DD OOS **17,6-33,6 %** contro un muro del 10 % |
| 12 | `ABTG_Nightly` | 2 | 4 | **0,81429** | 15,39 | 1.546 | 85 | ❌ **BOCCIATO PER RISCHIO** — DD 11,10 % IS e **15,39 %** OOS. Il rischio si legge **a qualunque n** (Emendamento B). Merito negativo e **concorde**. Asse = `InpMagic` |
| 13 | `ABTG_ORB_Ottimizzato` | 2 | 4 | **1,67419** (`InpUseCloseConfirm=0`) | 9,76 | 11.668 | 119 | ⏸️ **NON ANCORA MISURATO — ed è il miglior "sospeso" del backlog**. Segno **positivo e concorde** (IS 1,250 / OOS 1,674), ma n 71/119 ≪ 150 e **DD OOS a 0,24 punti dal muro**. Vedi §5 |
| 14 | `ABTG_OpeningReversalB` | 8 | 22 | **[NON MISURATO]** | — | — | **0** | ⏸️ **NON MISURABILE** — 🔴 **zero operazioni fuori campione su 11 passate OOS su 11**. In IS 1-3 operazioni. Non è un PF basso: è un **campione vuoto** |
| 15 | `ABTG_SupRev_DOW_H1_Ottimizzato` | 10 | 54 | 1,41820 (`InpStMult`) | 5,70 | 630 | 117 | ❌ **ROUND NULLO — PF NON LEGGIBILE.** `r132c` non riproduce l'ancora `R123DNEARATR` su **3 celle su 5** (criterio congelato: identiche cifra per cifra) |
| 16 | `ABTG_SuperWave` | 2 | 18 | **0,84330** | 2,71 | 272 | 58 | ❌ **MERITO ASSENTE, E NON È IL CAMPIONE** — PF OOS < 0,85 e **profitto negativo su 9 celle su 9**, IS negativo su 8 su 9. Segno negativo **concorde su 18 passate**. Rischio OK (DD < 3,3 %) |
| 17 | `ABTG_SuperWave_DOW_H1_Ottimizzato` | 16 | 56 | 1,40233 (`InpSLBufferAtr`) | 4,03 | 432 | 124 | ❌ **ROUND FERMO — PF NON CONFRONTABILE.** Grado C (PF IS 1,48166 contro 1,84892 d'archivio, Δ 0,367 > ±0,15) **+ dipendenza dal DEPOSITO misurata**: n OOS **131 a 10k contro 184 a 100k** (+40 %) |
| 18 | `ABTG_SupertrendReversal_Ottimizzato` | 2 | 14 | **1,12525** (`InpSLLookback`) | 5,91 | 6.023 | 427 | ❌ **MERITO NEGATIVO IN IS, E L'IS È GIUDICABILE** — PF IS < 1,00 su **7 celle su 7** con **n = 230 ≥ 150**. OOS 1,05-1,13: segno discorde. OHLC = screening, mai un verdetto |
| | **TOTALE** | **98** | **390** | | | | | |

**Un CSV è vuoto e doveva esserlo:** `ABTG_EMA200_U30USD_IS_cemad02.csv` (0 byte) —
il file prova dichiara `@FRAZIONEIS 0.002`, la gamba IS è un giorno solo e si butta
per costruzione. Il «codice 2 = NON MISURATO» del runner era un **falso allarme**,
già accertato il 13/09.

---

## 🟢 §2 · L'UNICO PROMOSSO — e il contro-esempio che gli ho costruito contro

### `ABTG_DAX_Apertura_EU` · sedia **770101** · D30EUR M5 LONG · `InpTP1_ClosePct` **50 → 0**

| | finestra | PF | DD % | **DD valuta** | n (deal) | posizioni | profit |
|---|---|---|---|---|---|---|---|
| cella **viva** (50) | IS | 1,12634 | 5,4362 | 5.876 | 175 | — | +3.789,36 |
| cella **viva** (50) | OOS | 1,39709 | 7,2328 | **8.886** | 270 | **193** | +18.029,58 |
| cella **0** | IS | **1,18323** | **4,9576** | **5.441** | 132 | — | **+5.569,37** |
| cella **0** | OOS | **1,49140** | **6,2719** | **7.974** | 193 | **193** | **+23.607,28** |

**Fonte:** `backtest_pipeline/risultati_prove/dal_vps/ABTG_DAX_Apertura_EU/ABTG_DAX_Apertura_EU_D30EUR_OOS_r137c.csv`
**righe 2 e 3** (IS: stesso nome, `_IS_`, righe 2 e 3).

### 🧪 IL CONTRO-ESEMPIO, le due trappole una per una

**Trappola 1 — effetto denominatore.** *«Il profitto sale, quindi lo stesso DD in
valuta sembra più piccolo in percentuale.»* Qui il profitto **sale davvero**
(+18.030 → +23.607, **+31 %**), quindi il sospetto è legittimo e va rotto, non
aggirato.
🟢 **Rotto: il DD in VALUTA scende anche lui, 8.886 → 7.974, −10,3 %.** Se fosse
denominatore, il DD in valuta sarebbe rimasto **uguale o salito**. Non lo fa.

**Trappola 2 — scala del lotto.** *«Una manopola che allarga lo stop rimpicciolisce
il lotto: profitto e DD scendono insieme e il motore non è migliorato.»*
🟢 **Non si applica, e per due motivi indipendenti.** (a) **Meccanico**:
`InpTP1_ClosePct` non tocca la distanza dello stop — sorgente `ABTG_DAX_Apertura_EU.mq5`
r.1899, la manopola governa **solo** la chiusura parziale; il breakeven (r.1945) e il
trailing (r.1981) sono input **separati**. Il lotto è identico nelle due celle.
(b) **Aritmetico**: la firma della scala del lotto è *profitto e DD scendono insieme*.
Qui il profitto **sale** del 31 % e il DD **scende** del 10 %. È il verso **opposto**.

**Trappola 3 — due passate dello stesso CSV non sono due misure.** Le due celle sono
**due passate**, quindi il confronto interno vale una misura sola. 🟢 **L'indipendenza
c'è e viene da altrove**: gli stessi 8 numeri sono riprodotti **al quinto decimale**
contro R47 (agosto), su un **binario diverso** — e il conteggio delle **193 posizioni
identiche** viene dal per-trade `CODA_12` (magic 786201: 270 deal / 193 posizioni),
che è un file **diverso** dal CSV.

👉 **Le 193 posizioni identiche sono il controllo perfetto**: stesse operazioni,
stessi ingressi, stesse barre. **Non è selezione: è gestione.**

### ❓ COSA MANCA per portarlo in imbuto (e non è poco)

1. 🔴 **UN SOLO REGIME.** Finestra 2024.09.26 → 2026.06.30 = 21 mesi di **toro** sugli
   indici. La regola C dell'Emendamento della Finestra **non è soddisfatta**. Una prova
   di regime (orso / laterale / crollo) **non esiste** per questa cella.
2. 🔴 **R5 non è chiuso su questa sedia.** Il round `r137a` misura che al pavimento
   *severo* (p95) servirebbe `InpMinStopPts` = 10800, e **costa 0,110 punti di PF**.
   Al pavimento di *lavoro* (6800, 40× alla mediana) il costo è **+0,023 = dentro il
   rumore**. Il baratto è un numero, ma è **una firma, non una misura mancante**.
3. ⚠️ **La peggior giornata resta −1,0793 %** e il round `q770be` ha provato a taparla
   col breakeven: **miglioramento 0,0000 punti su 4 celle su 4**. Il buco **resta
   aperto** e va detto ogni volta che si cita questa sedia.
4. 🔴 **E LA FAMIGLIA NON RAGGIUNGE IL PAVIMENTO.** Il 13/09 si è scritto «famiglia a
   1,25 op/g» sommando D30EUR (0,70 pos/g) e F40EUR (0,551 pos/g). 🔴 **Ma F40EUR è
   BOCCIATO PER RISCHIO** (DD OOS **11,82 %** > 10 %): non è schierabile, quindi non
   può contare nel pavimento di famiglia. **La famiglia schierabile sta a 0,70 op/g,
   non a 1,25.** Questa è una correzione alla lettura del 13/09.

### 🔴 E UN AVVERTIMENTO CHE NASCE DA QUESTA LETTURA: la ricetta NON è generale

Lo stesso gesto — *togliere la chiusura parziale* — sull'altro motore fa il
**contrario**: `ABTG_EMA200` `InpTP1Pct=0` dà **PF OOS 1,28144 e DD 13,9367 %** contro
1,52365 e 7,8323 %.

🟢 **Ma i due numeri NON si contraddicono, e la ragione è nel sorgente, non
nell'opinione.** `ABTG_EMA200.mq5` r.410: il blocco `if(!beDone && InpTP1Pct>0 …)`
racchiude **anche** il breakeven (r.429) e **arma** il trailing (r.436, che richiede
`beDone`). Quindi su EMA200 `InpTP1Pct=0` spegne **tre meccanismi con una manopola
sola**; sul DAX ne spegne **uno**.
👉 **Conseguenza:** *«togliere la parziale su EMA200»* **non è mai stato misurato**.
La cella che lo misurerebbe **non esiste** in questi 98 file. **Buco dichiarato.**

---

## ⚖️ §3 · LA SEDIA MIGLIORE DELLA FLOTTA (`771531`): «IL DEFAULT VA BENE» — cella per cella

`ABTG_EMA200` U30USD H1, asse `InpSLatr`, 7 celle, criteri congelati **prima** dei
numeri in `backtest_pipeline/prove/R136a_slatr_U30USD.txt`. Li applico alla lettera.

**A1** chiede ≥ 3 celle contigue con, ciascuna: PF OOS ≥ 1,40 **e** posizioni OOS ≥ 150
**e** DD OOS ≤ 8,5 % **e** costo ≥ 40× all'angolo **pessimista**, **e la cella viva
dentro**. Posizioni = `Trades` / 2,0117 (classe 226).

| `InpSLatr` | PF OOS | DD % OOS | pos. OOS | costo (angolo pess.) | A1 |
|--:|--:|--:|--:|--:|:-:|
| 0,4 | 1,26434 | 9,955 | 235 | 21,9× | ❌ PF **e** costo **e** DD |
| 0,6 | 1,52077 | 7,150 | 246 | **32,9×** | ❌ **FUORI COSTO** (congelato prima) |
| 0,8 | 1,61199 | 8,189 | 252 | 43,9× | ✅ |
| **1,0 (viva)** | 1,52365 | 7,832 | 257 | 54,9× | ✅ |
| 1,2 | 1,46170 | 5,967 | 258 | 62,2× | ✅ |
| 1,4 | 1,59482 | 5,768 | 263 | 69,5× | ✅ |
| 1,6 | 1,45763 | 6,245 | 262 | 76,8× | ✅ |

- ✅ **A1 PASSA, e con 5 celle contigue (0,8-1,6), la viva dentro.** L'asse **non è
  inerte** (A5 non scatta) e **non è un picco** (A4: le due vicine della viva fanno
  1,612 e 1,462, ben sopra la soglia di 1,25).
- 📐 **A8 — il CENTRO, mai il picco.** Centro di {0,8 · 1,0 · 1,2 · 1,4 · 1,6} = **1,2**.
  🔴 **E la cella 1,2 fa PF OOS 1,46170, cioè PEGGIO della viva (1,52365).**
- 📏 **A9 — banda di rumore 0,10.** Il picco è 0,8 (1,612): vantaggio **+0,088 < 0,10**.
  Il secondo è 1,4 (1,595): **+0,071 < 0,10**. **Nessuna cella batte la viva oltre il
  rumore dichiarato.**
- 🔴 **E l'IS non conferma nessuno dei due.** L'IS è una gobba liscia col **massimo a
  1,2** (1,073 · 1,145 · 1,189 · **1,201** · **1,255** · 1,218 · 1,072). La cella che
  l'IS sceglierebbe (1,2) è **la peggiore dell'altopiano in OOS**. **L'asse non
  seleziona.**

> 🟢 **VERDETTO A6: «IL DEFAULT VA BENE.»** E questa è la seconda lettura indipendente
> che ci arriva (la prima è del 13/09): qui è **derivata cella per cella contro i
> criteri congelati**, con il costo e il DD nella stessa tabella.
> 🟢 **E chiude col numero la casella 3 del certificato sulla sedia migliore della
> flotta** — quella che il censimento dell'11/09 trovava **vuota su 213 CSV**.

**A2 dichiarato:** l'IS è **sospeso sul merito su tutte le celle** — 132 posizioni
**misurate** (per-trade `CODA_12`, non inferite), sotto il pavimento di 150. L'IS qui
serve al **segno** e al **rischio**, non al merito.

---

## 🔴 §4 · LA COSA NUOVA DI QUESTA LETTURA — e va contro l'entusiasmo, non a favore

Guardando la tabella di §3 salta all'occhio una cosa che **non** è nella lettura del
13/09: alle celle 1,2 e 1,4 il **DD OOS scende da 7,83 % a 5,97 / 5,77 %** — circa
**2 punti** — e **anche in IS** (5,73 % → 4,73 / 4,27 %). Due punti di DD su una sedia
da challenge non sono un dettaglio. Sembra un regalo.

🧪 **Allora ho costruito il contro-esempio, come chiede la regola del 10/09. E il
contro-esempio VINCE: il regalo non c'è.**

### La domanda giusta: *il profitto scende quanto il DD?*

Su questo EA il lotto è `risk / lossPerLot` (r.490) con `lossPerLot` **proporzionale
alla distanza dello stop**. Le due gambe rischiano `(0,5+SLatr)·ATR` e `SLatr·ATR`,
quindi l'**indice di lotto** atteso è `1/(0,5+SLatr) + 1/SLatr`.
Il volume lordo di P&L è `(P+L)`, ricavato da `Profit` e `PF` (i lordi sono determinati
in modo unico: `L = Profit/(PF−1)`, `P = L·PF`).

| `InpSLatr` | lordo P+L (OOS) | indice lordo | **indice LOTTO atteso** | residuo | n |
|--:|--:|--:|--:|--:|--:|
| 0,4 | 156.059 | 1,388 | 2,167 | 0,641 | 473 |
| 0,6 | 143.702 | 1,279 | 1,545 | 0,827 | 494 |
| **0,8** | 135.798 | **1,208** | **1,212** | **0,997** | 506 |
| **1,0** | 112.394 | **1,000** | **1,000** | **1,000** | 517 |
| **1,2** | 98.820 | **0,879** | **0,853** | **1,031** | 519 |
| **1,4** | 85.534 | **0,761** | **0,744** | **1,022** | 529 |
| **1,6** | 77.444 | **0,689** | **0,661** | **1,043** | 527 |

> 🔴 **Su tutta la metà destra dell'asse (0,8 → 1,6) il denaro mosso dal motore segue
> il LOTTO, cella per cella, con un errore del 2-4 %.** In quel tratto `InpSLatr`
> **non è una manopola di geometria: è una manopola di TAGLIA.**
> Il DD da 9.193 a 6.512 valuta (×0,708) è quello che il lotto ×0,744 prevede. **Non è
> il motore che migliora: è la posizione che rimpicciolisce.**

**E questo SMENTISCE un'attesa congelata nel file prova**, che va detto perché è il
punto: `R136a_slatr_U30USD.txt` dichiarava *«il rischio in denaro per operazione è
costante … il confronto fra celle è ONESTO per costruzione (non è una leva)»*.
🟢 **È vero per la perdita a stop pieno e per il TP (sono in R, quindi denaro fisso).
È FALSO per la maggior parte del P&L di questa sedia**, perché la parziale (r.421) e il
trailing (r.436) chiudono su **EMA14**, cioè a una distanza di **prezzo** che con
`InpSLatr` non si muove: quel denaro scala col **lotto**.
🔎 **La prova che il modello "denaro costante" è rigettato:** prevede un lordo
**×1,023** (= il rapporto di n) fra 1,0 e 1,4. Misurato **×0,761**. Sbagliato del 26 %.
Il modello "lotto" prevede ×0,744 e sbaglia del 2 %.
👉 **Conseguenza misurata, e non la sapevamo: su `771531` i soldi si fanno e si perdono
a EMA14, non allo stop.**
⚠️ **[INFERENZA, non isolamento]:** i due rapporti concordano ma la causa non è stata
separata da sola. Isolarla costa **una corsa** con parziale e trailing spenti in croce
con `InpSLatr` — e quella corsa **non esiste** in questi 98 file (vedi §2, ultimo
paragrafo).

🎯 **E la conclusione operativa è netta: chi vuole 2 punti di DD in meno non deve
toccare la geometria dello stop — deve abbassare `InpRiskPercent`.** È lo stesso
effetto, costa zero round, e non cambia quali operazioni il motore prende.
**`InpRiskPercent` è [FIRMA DI CLAUDIO], sempre.**

---

## 🪦 §5 · I BOCCIATI, COL CERTIFICATO DI MORTE

Le cinque caselle: **(a)** un PF misurato · **(b)** un n e un DD · **(c)** la gestione
dell'uscita messa ad asse almeno una volta · **(d)** i simboli gemelli provati ·
**(e)** il TF cambiato almeno una volta.
🔴 **Se ne manca una, il verdetto è «NON ANCORA MISURATO», non «morto».**

### 🪦 MORTI CERTIFICATI — zero motori

**Nessuno dei 18 motori ha il certificato pieno.** Su **17 su 18** manca la casella
**(e)** — il TF non è mai stato cambiato in questo backlog. L'**unica** eccezione è
`ABTG_EMA200`, che ha (a)(b)(c)(d)(e) tutte chiuse — e infatti **non è un bocciato: è
la sedia migliore della flotta.**

### ⛔ SEDIE MORTE (il motore no, la sedia sì) — il rischio e il merito con n ≥ 150 non aspettano il certificato

Il certificato protegge il **MOTORE**. La singola **SEDIA** (motore × simbolo × TF) si
chiude su un fatto accaduto — è l'Emendamento B: *il rischio si legge a qualunque n*.

| sedia | cancello | il numero | fonte |
|---|---|---|---|
| `LVNArbitro` U30USD M30 | **C0 + rischio** | PF 0,975 / 1,052 con n **392/618**; DD IS **18,0-19,4 %** | `..._U30USD_{IS,OOS}_P0CONTA.csv` · `..._P0_100K.csv` |
| `Nightly` EURCHF | **rischio** | DD **11,10 % IS / 15,39 % OOS**; PF 0,891 / 0,814 concordi | `ABTG_Nightly_EURCHF_{IS,OOS}_P0_EURCHF.csv` r.2-3 |
| `FiboH4_Multi` GBPUSD H4 | **rischio + merito** | DD **17,3-23,3 %** su 6/6; PF < 1,00 su 6/6 con n 548-737 | `..._GBPUSD_{IS,OOS}_ohlc_r139c.csv` |
| `EMA200` AUDJPY H4 | **rischio** | DD **15,4-20,4 %** su 8 passate su 8 | `ABTG_EMA200_AUDJPY_{IS,OOS}_ohlc_r139a.csv` |
| `EMA200` GBPUSD H4 | **rischio + segno** | DD IS **17,7-20,3 %**; segno opposto fra finestre su 4 celle su 4 | `ABTG_EMA200_GBPUSD_{IS,OOS}_ohlc_r139b.csv` |
| `CostToCost` EURJPY H4 | **rischio** | DD **10,99 % IS / 12,26 % OOS** su tutte le celle | `..._EURJPY_{IS,OOS}_ohlc_r127c.csv` |
| `DAX_Apertura_EU` F40EUR M5 | **rischio** | DD OOS **11,82 %**; PF OOS **0,76965** con n 195 | `..._F40EUR_{IS,OOS}_r138a.csv` |
| `Nasdaq_Live5m` NASUSD M5 | **rischio + merito** | DD OOS **17,6-33,6 %**; PF < 1,10 su 11 passate su 11 | `ABTG_Nasdaq_Live5m_NASUSD_*_r142{a,b,c}.csv` |
| `SupertrendReversal_Ott` XAUUSD H4 | **merito, con n leggibile** | PF IS < 1,00 su **7 su 7** con **n = 230 ≥ 150** | `..._XAUUSD_{IS,OOS}_ohlc_r127b.csv` |

🔎 **Sulle quattro righe OHLC** (`r127b/c`, `r139a/b/c`) il rifiuto **per rischio**
regge lo stesso, e per un motivo aritmetico: su OHLC il DD è un **limite inferiore**,
quindi un DD OHLC sopra soglia è sopra soglia anche a tick. Il **merito**, invece, su
OHLC è screening e **non è mai un verdetto**: dove ho scritto «merito» c'è sempre
anche un cancello di rischio o un n ≥ 150 a tenerlo in piedi.

### ⏸️ I SETTE «NON ANCORA MISURATI» — e COSA manca a ciascuno

| motore | (a) PF | (b) n+DD | (c) uscita ad asse | (d) gemelli | (e) TF | la via più corta |
|---|:-:|:-:|:-:|:-:|:-:|---|
| `ORB_Ottimizzato` | ✅ | ✅ (n<150) | ❌ l'unico asse è un filtro d'**ingresso** | ❌ | ❌ | 🥇 **il gemello D30EUR/NASUSD**: raddoppia il campione senza toccare i parametri |
| `AtrExhaustVol` | ✅ | ✅ | ❌ | ❌ | ❌ | il gemello (0,37 op/g di seduta: su tre indici la famiglia sfiora 1,00) |
| `HVAncora` | ✅ | ✅ (n 22-37) | ✅ `InpStopAtr` | ❌ | ❌ | 🔴 **non i parametri**: il tappo è a monte, **91+165 ancore che SCADONO** |
| `IntradayMomentum` | ✅ | ✅ | ❌ | ✅ 2 gemelli | ❌ | ⚠️ tesi nuova richiesta: il segno si ribalta su **entrambi** i gemelli |
| `IBRetest` | ✅ | ✅ | ❌ **zero manopole**: l'asse è `InpMagic` | ✅ 3 gemelli | ❌ | una manopola qualunque: oggi è a **zero assi** |
| `MaxMinNotte` | ✅ | ✅ (n 10-65) | ❌ l'asse è un filtro d'ingresso | ❌ | ❌ | ⚠️ **con cautela**: l'asse provato fabbrica picchi di rumore |
| `OpeningReversalB` | ❌ | ❌ **n=0 in OOS** | ❌ | ❌ | ❌ | 🔴 **niente griglie**: il tappo è a valle dei punteggi (State1 arriva a 49, gli ingressi restano 1-2) |

### 🚧 I TRE FERMI A UN CANCELLO — il PF non si legge, quindi non si giudica

| motore | cancello | perché nessun numero è leggibile |
|---|---|---|
| `SupRev_DOW_H1_Ottimizzato` | **riproduzione** | `r132c` diverge dall'ancora `R123DNEARATR` su **3 celle su 5** (0,50/0,75/1,00 sì, 1,25/1,50 no), in **entrambe** le finestre. Criterio congelato: identiche cifra per cifra → **ROUND NULLO** |
| `SuperWave_DOW_H1_Ottimizzato` | **riproduzione + banco** | grado C (PF IS 1,48166 vs 1,84892, Δ 0,367) **e** n OOS che dipende dal **deposito** (131 a 10k, 184 a 100k). Ogni confronto d'archivio a depositi diversi **non è confrontabile** |
| `SuperWave` (NASUSD) | *(nessun cancello: è il merito)* | 9 celle su 9 con PF OOS < 0,85 e profitto **negativo**. Qui il numero si legge benissimo, ed è brutto |

---

## 🚪 §6 · I CANCELLI DI CASA, applicati e citati

- **n ≥ 150 (merito).** Motori con almeno una finestra sopra il pavimento: `EMA200`,
  `DAX_Apertura_EU`, `CostToCost`, `FiboH4_Multi`, `LVNArbitro`, `Nasdaq_Live5m`,
  `SupertrendReversal`, `SupRev_DOW_H1`, `IntradayMomentum` (n IS = **146**, quattro
  operazioni sotto: il cancello **non scatta per un soffio**, e si dichiara così).
  Per gli **altri 9** il merito è **SOSPESO — non bocciato**.
- **Rischio a qualunque n (Emendamento B).** È il cancello che chiude **9 sedie** su
  questi 98 file, ed è l'unico che non ha bisogno del campione.
- **Centro dell'altopiano, mai il picco.** Applicato per esteso in §3. 🔴 **E applicato
  contro il risultato che avrei voluto**: il picco 0,8 (PF 1,612) **non si sceglie**, e
  il centro 1,2 **non batte il default**.
- **Frontiera del costo `stop ≥ 40 × spread`:**
  - `EMA200` U30USD **H1**: **54,9×** ✅ (stop mediano 104,30 idx / spread 1,90) —
    misurato, dossier 09/09. La cella `SLatr` **0,4 è ESCLUSA PER COSTO a 21,9×** e la
    **0,6 a 32,9×** all'angolo pessimista, **congelato prima dei numeri**.
  - `EMA200` U30USD ai **TF bassi**: esclusi **per RISCHIO col numero**, non per
    pigrizia — M15 **DD 26,34 %** (−9.456), M20 **DD 30,71 %** (−26.415), M30
    **DD 15,87 %** (−11.404): profitto **negativo su tutti e tre** (`cemad05` OOS,
    passate 0/1/2). ✏️ **E qui correggo la lettura del 13/09**, che scriveva *«non
    esiste un altopiano sopra 1,40: solo H1»*: **anche H4 fa 1,42483** (DD 4,45 %).
    Ma **non è un altopiano lo stesso**, e per due motivi: H1 e H4 **non sono
    contigui** (in mezzo H2 = 1,17278 e H3 = 0,90825) e **H4 ha n = 116 < 150**, quindi
    il suo merito è **sospeso**. H1 resta l'unico TF sopra 1,40 **con il campione**.
  - `DAX_Apertura_EU` D30EUR **M5**: R5 si chiude solo alzando `InpMinStopPts` a 6800
    (**40,0× alla mediana**, costo in PF **+0,023 = dentro il rumore**) o a 10800
    (**40,0× al p95**, costo **−0,110 di PF**). Oggi la sedia gira col floor **spento**.
  - **M30 e M5 degli altri motori (`IntradayMomentum`, `AtrExhaustVol`, `HVAncora`,
    `ORB`, `LVNArbitro`, `IBRetest`, `MaxMinNotte`, `Nasdaq_Live5m`): costo
    [NON MISURATO]** in questo backlog. Nessuno di loro passa comunque un cancello a
    monte, quindi non morde oggi — ma è un buco, non un via libera.
- **Pavimento di frequenza 1,00 op/g per FAMIGLIA.** Finestra OOS = 2025.06.10 →
  2026.06.30 = **385 giorni ≈ 275 di seduta**.
  - `EMA200` famiglia: U30USD H1 fa **257 pos / 275 = 0,93 pos/g**, ed è **l'unica
    sedia schierabile della famiglia** (AUDJPY e GBPUSD bocciati per rischio) →
    **famiglia a 0,93: sotto il pavimento di un soffio.**
  - `DAX_Apertura_EU` famiglia: **193/275 = 0,70 pos/g**, non 1,25 (vedi §2, punto 4).
  - Per tutti gli altri le **posizioni sono [NON MISURATE]** (solo deal): non calcolo
    frequenze che non ho.

---

## 🕳️ §7 · I BUCHI DICHIARATI DI QUESTA LETTURA

1. 🔴 **UN SOLO REGIME, per tutti e 98 i file.** Gli indici girano su 21 mesi di
   **toro**; i forex su finestre H4 più lunghe ma comunque contigue. La regola C
   dell'Emendamento della Finestra **non è soddisfatta da nessun numero di questo
   dossier**. 👉 **Niente qui dentro è promuovibile senza una prova di regime**, incluso
   il promosso di §2.
2. ⚠️ **Le posizioni sono misurate solo dove il per-trade è sopravvissuto** (`CODA_12`:
   sedie 771531 e 770101). Altrove sono **deal**, e dove ho convertito l'ho scritto.
3. ⚠️ **`DD valuta` = `Profit/RF` non è `Equity DD %`.** Definizioni diverse in MT5
   (drawdown massimo dell'RF contro drawdown di equity in % del picco). È **coerente
   fra celle**, che è quel che serve per confrontarle. **Non è il DD di contratto** di
   nessuna sedia.
4. 🔴 **«Togliere la parziale su `EMA200`» non è mai stato misurato**, perché la
   manopola ne spegne tre insieme (§2). La cella che lo misura **non esiste**.
5. ⚠️ **La causa del "lotto invece della geometria" (§4) è INFERITA**, non isolata: due
   rapporti che concordano al 2-4 % e un meccanismo letto nel sorgente. L'isolamento
   costa una corsa in croce.
6. 🔴 **62 passate su 390 (15,9 %) NON sono una griglia.** In **16 etichette** l'unico
   campo che varia è `InpMagic`: sono **celle gemelle = cancello G0 di determinismo**.
   Per **tre motori interi** — `IBRetest`, `LVNArbitro`, `Nightly` — **non esiste
   nessun altro asse in tutto il backlog**: zero manopole girate. Contare quelle
   passate come «parametri provati» sarebbe l'errore delle **manopole inerti** del
   censimento 09/09, al contrario.
7. 🔴 **Non ho trovato il verbale che ELENCA le sei sedie del dry-run 100k.** Le
   `giornata_2026-09-17/18` le contano («6 sedie su 119») ma non le nominano. Ho quindi
   risposto alla domanda «una cella migliora una delle sei» **sulle due sedie vive che
   questi CSV toccano davvero** (`771531` EMA200 U30USD H1 e `770101` DAX D30EUR M5).
   Se una delle sei è un'altra, **questo backlog non la tocca**. **Buco, non risposta.**
8. 🚫 **Questa lettura non promuove niente, non accende niente, non tocca nessun preset.**
   Taglie, rischio, accensioni e il conto reale **10105439** sono **[FIRMA DI CLAUDIO]**.

---

## 🎯 §8 · COSA AVVICINA UNA SEDIA SCHIERABILE, E COSA NO

**SÌ, col numero:**
1. 🥇 **`770101` `InpTP1_ClosePct` 50 → 0.** PF OOS 1,39709 → **1,49140**, DD 7,2328 %
   → **6,2719 %**, DD valuta 8.886 → **7.974**, a parità di **193 posizioni**.
   Supera **tutte e tre** le trappole. **Manca solo una firma** (e una prova di regime).
2. 🥈 **La casella 3 del certificato di `771531` è chiusa col numero**, e la risposta è
   **«il default va bene»** — derivata cella per cella contro i criteri congelati.
   **È un risultato, non un round buttato.**
3. 🥉 **`ORB_Ottimizzato` U30USD M30 è il miglior "sospeso" del backlog** e ha una via
   corta che non costa una griglia: **il gemello**. Segno concorde e positivo in
   entrambe le finestre, PF OOS 1,674. Gli manca **solo campione**, che è un numero
   **mancante**, non un numero **brutto**. 🔴 **Non si archivia.**

**NO, e va detto:**
- ❌ **I 2 punti di DD di `SLatr` 1,2-1,4 non esistono**: è il lotto (§4). Chi li vuole
  abbassi `InpRiskPercent` — stesso effetto, zero round, **firma di Claudio**.
- ❌ **La famiglia `EMA200` sta a 0,93 op/g e quella `DAX_Apertura` a 0,70**: nessuna
  delle due raggiunge il pavimento **da sola**, e i gemelli provati in questo backlog
  sono **tutti bocciati per rischio**.
- ❌ **`SuperWave`, `Nightly`, `LVNArbitro`, `FiboH4_Multi`, `Nasdaq_Live5m` e le cinque
  sedie H4 forex/oro**: qui non c'è un campione sottile da riempire, c'è un **segno**.
- 🚧 **Le due famiglie `SuperWave`/`SupRev` restano fuori discorso** finché non è chiusa
  la **dipendenza dal deposito** (+40 % di operazioni fra 10k e 100k). **Non è un
  verdetto sul motore: è che il banco ha un difetto da misurare prima.**

---

*21/09/2026 — lettura completa dei 98 CSV del backlog della notte 12/13-09. Nessun
round eseguito, nessun EA modificato, nessun preset toccato, nessun candidato promosso.
Il conto reale 10105439 non compare da nessuna parte. Perimetro di sola lettura
rispettato.*
