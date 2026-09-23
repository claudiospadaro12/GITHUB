# 🧱 LE DUE SEDIE SOPRA IL MURO — cercate nei CSV che abbiamo già, trovate, e pesate

**R222 · 23/09/2026 · branch `lavoro`**
🛑 **SOLA LETTURA E ZERO MINUTI MACCHINA.** Nessun round lanciato, nessun EA toccato, nessun
preset toccato, nessuna sedia toccata. Niente sul conto reale **10105439**. Nessuna taglia e
nessun parametro di rischio **proposti come decisione**: restano firma di Claudio.

> ## 🎯 LA RISPOSTA IN SEI RIGHE
> 1. 🟢 **SÌ, la cella esiste — per tutte e due le sedie — e nessuna delle due abbassa
>    `InpRiskPercent`.** `770101` → **`InpBEatR = 0,15`**; `771531` → **`InpTP1_ATRmult = 0,25`
>    (o `0,50`)**. Tutte e due portano il **limite superiore** della perdita statica **sotto il
>    muro del 10%**, **in campione e fuori campione**.
> 2. 🔥 **E la prima era in casa da 48 ore senza che nessuno l'avesse letta**: il round
>    **`R201A`** è girato il **21/09 alle 21:05**, al deposito **vero della challenge (80.000)**
>    e a **tick reali**, e il suo referto dice testualmente *«QUESTO REFERTO NON GIUDICA»*.
>    **Nessun documento in repo ne ha mai letto i numeri.**
> 3. 🧩 **Le due sedie hanno trovato la STESSA leva per strade diverse**: su tutte e due
>    l'unica manopola d'archivio che abbassa il drawdown è **«arma il breakeven molto prima»**.
>    Non è un'analogia: è lo stesso ramo di codice con due nomi.
> 4. 🔴 **Ma il prezzo è scritto e non si sconta: il profitto scende del 38-58%.** E il
>    **Recovery Factor** — l'unica grandezza che sopravvive alla taglia — sale **fuori campione**
>    (+23,2% e +75,1%) e **scende o si annulla in campione** (−4,5% e da +0,79 a −0,02).
> 5. 🔴 **La regola di casa dice NO a una delle due, e lo dice col numero.** Su `770101`
>    lo `0,15` è **il picco**: 1ª cella su 7 per PF, e il suo unico vicino `0,30` è **l'ultima
>    su 7**. Su `771531` invece le celle sotto il muro sono **DUE contigue**, ed è
>    strutturalmente più solido.
> 6. 🧱 **E metà del muro non l'aveva guardata nessuno** (classe 618): sulla colonna
>    **giornaliera** `InpBEatR` è **INERTE** — 7 passate, escursione **0,005 punti**. Compra
>    metà muro e non compra l'altra metà. 🟢 Per fortuna quella metà non era il problema
>    (−1,08% a taglia banco contro il muro del 5%).

---

# 0️⃣ ⚖️ LE UNITÀ DI MISURA — dichiarate PRIMA dei numeri

| cosa | come si legge qui, e perché |
|---|---|
| **`DD fisso`** 🥇 | `DD_ass / deposito`, con **`DD_ass = Profit / Recovery Factor`**. È la formula **già riconciliata in casa su 1.845 righe di affari** (`report/IL_MURO_MISURATO_2026-09-22.md` **r.101** e **r.226**) ed è un **limite SUPERIORE rigoroso della perdita statica FTMO**. 👉 **È la colonna con cui giudico**, non `Equity DD %` |
| **`Equity DD %`** | la colonna grezza del tester: discesa **dal PICCO**. La riporto sempre accanto perché è quella dei contratti, ma **non** è la grandezza del muro |
| **classe 562** | 🔴 **Sotto la soglia DIMOSTRA, sopra NON CONCLUDE.** Una cella che scende sotto il 10% è **dimostrata sicura**; una che resta sopra è **«non dimostrata»**, **non** «bocciata». Scritto cella per cella |
| **il muro è DOPPIO** (classe 618) | **totale 10%** *(qui: `DD fisso`)* **+ giornaliero 5%** *(qui: `Peggior Giornata %`)*. **Guardo tutte e due le colonne**, e dove una manca lo dichiaro |
| **la scala del rischio** | tutto l'archivio gira a **`InpRiskPercent = 1,00`**, i preset FTMO a **2,00**. Il `→ @2%` è **×2 lineare**, 🔴 **convenzione di casa e SOVRASTIMA** (misurato: `CONTRATTI_DELLE_SEDIE_FTMO` §riepilogo, errore +0,58% / +1,35%). Quindi **i miei `@2%` sono TETTI**: la cella che passa, passa **con margine** |
| **classe 604 — il deposito** | ogni riga porta il suo deposito, **verificato alla fonte** (file prova o referto di round). **Non confronto mai due depositi diversi in colonna** |
| **`n`** | ⚠️ è la colonna `Trades` = **DEAL DI USCITA**, non posizioni. Dove morde, lo dico |
| **selezione** | **centro dell'altopiano, MAI il picco.** Dichiarata qui, applicata sotto cella per cella, **anche quando mi costa il candidato** |

---

# 1️⃣ 🪑 LA SEDIA `770101` — DAX Apertura EU · D30EUR M5

## 1.1 La cella che vola OGGI, verificata alla fonte

**Fonte primaria, e non è quella del contratto**: `backtest_pipeline/risultati_prove/R201A/ABTG_DAX_Apertura_EU_D30EUR_{IS,OOS}_R201A.csv` **riga dati 1 (`Pass 0`)**.
Deposito **80.000** · rischio **1,00%** · **Modello 4 (tick reali)** · girato **21/09/2026 21:05:24** sul PC di backtest
(`risultati_prove/R201A/REFERTO_ROUND_R201A.txt`, righe `deposito`/`modello`/`data`).

| finestra | PF | **RF** | `Equity DD %` | **`DD fisso`** | **→ @2,00%** | `Peggior Giornata %` | n `[uscite]` | profitto |
|---|--:|--:|--:|--:|--:|--:|--:|--:|
| **IS** 2024.09.26→2025.06.09 | 1,12733 | 0,65219 | 5,4089 | **5,8468%** | 🔴 **11,69%** | −1,0195 | 175 | 3.050,56 |
| **OOS** 2025.06.10→2026.06.30 | 1,39520 | 2,01544 | 7,2506 | **8,9033%** | 🔴 **17,81%** | −1,0782 | 270 | 14.355,32 |

🟢 **Il controllo di regressione PASSA — ma solo se si legge col deposito in mano.** Il file
prova pretendeva `OOS profitto 18.029,58` (dai sei CSV d'archivio a **100.000**) e ha ottenuto
**14.355,32**. Rapporto **0,7962 ≈ 0,80 = 80.000/100.000**, con `PF`, `Equity DD %` e `n`
identici allo 0,3%. 🔴 **Senza questo conto, il criterio congelato dal file prova dice
«IL ROUND SI FERMA QUI» su un round perfettamente riuscito.** → **classe 619**.

## 1.2 🏆 L'ASSE `InpBEatR` — l'unico dell'archivio che scende sotto il muro

7 celle × 2 finestre, **tutte e 14 nello stesso round, stesso deposito, stesso binario**.
`InpBEatR` = breakeven indipendente: sposta lo stop a pari a quel multiplo di R, **e non chiude
niente** (`mql5/Experts/ABTG_DAX_Apertura_EU.mq5` **r.332** e **r.2404-2418**).

### OOS — la finestra che giudica il MERITO

| `InpBEatR` | PF | **RF** | `Eq.DD%` | **`DD fisso`** | **→ @2%** | vs muro 10% | n | profitto |
|--:|--:|--:|--:|--:|--:|---|--:|--:|
| **0,00** ← VOLA | 1,39520 | 2,01544 | 7,2506 | 8,9033% | 17,81% | 🔴 non dimostrata | 270 | 14.355,32 |
| **0,15** | 🟢 **1,51555** | 🟢 **2,48219** | **3,9389** | 🟢 **4,3696%** | 🟢 **8,74%** | 🟢 **DIMOSTRATA** | 248 | 8.677,00 |
| 0,30 | 🔴 **1,25071** | 1,24774 | 6,4619 | 7,2674% | 14,53% | 🔴 non dimostrata | 266 | 7.254,30 |
| 0,45 | 1,33981 | 1,79656 | 6,4891 | 7,6195% | 15,24% | 🔴 | 270 | 10.951,11 |
| 0,60 | 1,35133 | 1,69776 | 7,3859 | 8,8580% | 17,72% | 🔴 | 271 | 12.031,01 |
| 0,75 | 1,34508 | 1,76883 | 7,2728 | 8,7453% | 17,49% | 🔴 | 271 | 12.375,14 |
| 0,90 | 1,37994 | 1,94562 | 7,2343 | 8,8239% | 17,65% | 🔴 | 271 | 13.734,40 |

### IS — la finestra che giudica il RISCHIO (Emendamento B)

| `InpBEatR` | PF | **RF** | `Eq.DD%` | **`DD fisso`** | **→ @2%** | vs muro | n | profitto |
|--:|--:|--:|--:|--:|--:|---|--:|--:|
| **0,00** ← VOLA | 1,12733 | 0,65219 | 5,4089 | 5,8468% | 11,69% | 🔴 | 175 | 3.050,56 |
| **0,15** | 🟢 1,14812 | 0,62268 | 3,6667 | 🟢 **3,7675%** | 🟢 **7,53%** | 🟢 **DIMOSTRATA** | 158 | 1.876,74 |
| 0,30 | 1,09700 | 0,67859 | 3,3950 | 🟢 **3,5182%** | 🟢 **7,04%** | 🟢 DIMOSTRATA | 172 | 1.909,94 |
| 0,45 | 1,03942 | 0,20290 | 5,2892 | 5,5350% | 11,07% | 🔴 | 175 | 898,44 |
| 0,60 | 1,08046 | 0,37818 | 5,9016 | 6,3250% | 12,65% | 🔴 | 177 | 1.913,60 |
| 0,75 | 1,10624 | 0,50666 | 5,8051 | 6,2628% | 12,53% | 🔴 | 175 | 2.538,47 |
| 0,90 | 1,11649 | 0,57262 | 5,6346 | 6,0860% | 12,17% | 🔴 | 174 | 2.787,99 |

## 1.3 🧪 I CONTRO-ESEMPI, costruiti PER ROMPERLA — quattro, e **due la rompono**

### (a) *«vince perché è più piccola»* → **RESPINTO fuori campione, ACCOLTO in campione**
Se fosse puro ridimensionamento, il **RF sarebbe piatto**. Non lo è:
**OOS `RF 2,01544 → 2,48219` = +23,2%** — il drawdown scende **più in fretta** del profitto, quindi
c'è efficienza vera, non solo taglia. 🔴 **IS `RF 0,65219 → 0,62268` = −4,5%**: lì è, entro il
rumore, **esattamente un ridimensionamento**, e il profitto (−38,5%) lo conferma.
🟢 **E meccanicamente NON può essere `InpRiskPercent` travestito**: `InpBEatR` compare **solo**
nel blocco di gestione posizione (r.2404-2418). **Il lotto è dimensionato sullo stop
d'ingresso, che questa manopola non tocca.** La perdita massima di un trade che va dritto allo
stop è **identica**. ✅ **Vincolo 1 rispettato.**

### (b) *«è il picco di una griglia»* → 🔴 **ACCOLTO, ed è il difetto che decide**
Ordinando le 7 celle **per PF OOS**: `0,15` è la **1ª**, e il suo unico vicino `0,30` è la
**7ª, cioè l'ULTIMA**. Una cella che sporge con il vicino che crolla è la definizione di rumore.
👉 **Per la regola di casa, `0,15` NON è selezionabile.**
🟢 **Ma la regola va applicata colonna per colonna, e il risultato si divide in due:**

| affermazione | sostenuta da | verdetto |
|---|---|---|
| *«`InpBEatR` basso abbassa il drawdown»* | **altopiano di 2 celle contigue** (`0,15` + `0,30` sono 1ª e 2ª su 7 per `DD fisso` in tutte e due le finestre) **+ Spearman IS→OOS `DD` = +0,929** su 7 celle | 🟢 **SOSTENUTA** |
| *«`0,15` porta sotto il muro»* | **una cella sola**: `0,30` risale a 14,53% @2% | 🟠 **una cella, nessun vicino** |
| *«`0,15` alza anche il PF»* | **picco isolato**, vicino peggiore di tutti | 🔴 **NON SOSTENUTA** |

🔴 **La riga onesta è quindi: il merito che ci si deve ASPETTARE dall'altopiano è più vicino al
PF 1,25 dello `0,30` che al PF 1,52 dello `0,15`.**

### (c) *«è una manopola inerte»* → **RESPINTO, e con il criterio del file prova**
Il file prova chiedeva in anticipo *«se su sette celle i Profit distinti sono meno di cinque,
l'asse non ha morso»*. Misurato: **7 profitti distinti su 7**, in tutte e due le finestre. ✅

### (d) 🧱 *«e l'ALTRA metà del muro?»* (classe 618) → 🔴 **ACCOLTO: la manopola lì è INERTE**
`Peggior Giornata %` sulle 7 celle: OOS da **−1,0748 a −1,0801**; IS da **−1,0152 a −1,0195**.
**Escursione: 0,005 punti percentuali.** 👉 **`InpBEatR` sposta il muro TOTALE del 45,7% e il
muro GIORNALIERO di ZERO.** Compra metà muro.
🟢 **Notizia buona che va detta**: quella metà non era il problema — **−1,08% a taglia banco
≈ 2,16% @2,00% contro il muro giornaliero del 5%**, con margine.
🟢 **E una terza colonna di rischio concorda**: `Serie Perdente Peggiore` OOS scende da
**−2.794,68 a −1.723,50** (**−38,3%**).

### (e) Il cancello **(d)** del file prova: *«n non deve calare»* → **FALLITO come scritto**
`n` cala: 270→248 (OOS), 175→158 (IS). Il file prova dice *«un BE non può togliere ingressi: se
n scende, il round ha un difetto»*.
🟢 **Ma `n` sono USCITE, e un BE che scatta PRIMA della parziale chiude la posizione in UN deal
invece di DUE.** Con `P` posizioni e `n = P + f`: base OOS `270 = 193 + 77`, cella `0,15`
`248 = 193 + 55`. **Coerente con `P` invariato**, ed è coerente anche col codice (nessun ramo
d'ingresso legge `InpBEatR`) — lo stesso argomento che `VERDETTO_R202` §7 usa per `InpTP1_R`.
🔴 **Resta però `[NON MISURATO]`: non esiste per-trade di R201A.** → **classe 620**.

### (f) Il **gemello**: *«allora funziona su tutta la famiglia Aperture»* → 🔴 **NO, misurato**
`R199A` aveva trovato `InpBEatR = 0,5` **dominante** sul Nasdaq `770260`. Sul DAX la cella più
vicina (`0,45`) fa **PF 1,33981 (−4,0%)** e **RF 1,79656 (−10,9%)**: peggio della cella viva.
👉 **L'ipotesi che il file prova aveva scritto PRIMA dei numeri — *«il risultato del Nasdaq NON
si ripete sul DAX»* — è CONFERMATA.** L'effetto è del mercato, non del meccanismo.

## 1.4 Le altre celle di `770101` trovate in archivio, e perché **non** arrivano al muro

| manopola | cella | `DD fisso` OOS → @2% | PF OOS | RF OOS | perché non passa |
|---|---|--:|--:|--:|---|
| **`InpTP1_ClosePct`** | 50 → **0** | 7,9739% → **15,95%** | 🟢 1,49140 | 🟢 **2,96058** | 🥇 **il miglior candidato di MERITO dell'intero dossier** — PF, RF, DD **e profitto** migliorano in **tutte e due** le finestre (RF +45,9% OOS, +58,7% IS; profitto +30,9% / +47,0%). 🔴 **Ma resta a 15,95%: NON porta sotto il muro.** Già a referto in `CELLE_MIGLIORI_GIA_MISURATE` §2A, qui solo confermato |
| `InpTrailTF` | 5 → 2 / 3 | ~11,9% / ~11,6% *(dep. 10.000)* | 1,69139 / 1,57692 | 3,12848 / 3,21573 | 🔴 **Spearman IS→OOS `PF` = −0,900** e `RF` = −0,700: su quest'asse il campione **anti-predice** il fuori campione. E in IS tutte e tre le celle **perdono soldi**. Cella `1` sotto il muro (5,89%) ma profitto −37% e IS in perdita |
| `InpRangeMinutes` | 35 → 40 | 6,6719% → 🔴 **13,34%** | 1,38985 | 2,49897 (+23%) | 🟢 **riprodotto su due corse indipendenti e due depositi** (r35 @10k e ptd @100k, accordo al 2%). 🔴 **Ma l'IS va in perdita e il suo `DD fisso` SALE da 5,8764% a 9,0145% → 18,03% @2%**: bocciato sulla **corsia RISCHIO**, che legge la finestra vecchia |
| `InpTP1_R` | 1,0 → 0,25 | 10,75% | 1,36404 | 1,89804 | già giudicato: `report/VERDETTO_R202_2026-09-21.md` §6 — **veto strutturale**, e PF e RF **scendono** |
| `InpBufferPoints` | 15 celle | nessuna sotto | — | — | la cella viva `500` è il **massimo di PF OOS** dell'intero asse |
| `InpTrailStartR` · `InpTrailMode` · `InpUseTrailing` | — | — | — | — | 🟢 **il default vince** in tutte e tre. `InpUseTrailing=0` è il ribaltone perfetto: **IS eccellente, OOS disastro** (PF 1,39378 → 1,02626) |
| `InpVolMult` | 3 celle | — | — | — | 🔩 **INERTE** con `InpUseVolumeFilter=0` (3 passate, 1 esito) — già censita |
| `InpUseVolumeFilter` | 0 → 1 | — | — | — | `n` crolla del 61%: è **selezione**, non gestione |

---

# 2️⃣ 🪑 LA SEDIA `771531` — EMA200 Dow · U30USD H1

## 2.1 La cella che vola OGGI, verificata alla fonte

`backtest_pipeline/risultati_archivio/R112_CORSA_20260826/ABTG_EMA200_U30USD_{IS,OOS}_00_metro.csv` **riga dati 1**.
Deposito **100.000** (`backtest_pipeline/righe/RIGA_R112_EMADOW_CONTRATTO.ps1` **r.204**) · rischio **1,00%** · **tick reali**.

| finestra | PF | **RF** | `Equity DD %` | **`DD fisso`** | **→ @2,00%** | n `[uscite]` | profitto |
|---|--:|--:|--:|--:|--:|--:|--:|
| **IS** | 1,20110 | 0,78806 | 5,7325 | **5,8186%** | 🔴 **11,64%** | 237 | 4.585,40 |
| **OOS** | 1,52365 | 2,53681 | 7,8323 | **9,1932%** | 🔴 **18,39%** | 517 *(257 posizioni, contate)* | 23.321,47 |

🔴 **E qui metà del muro non è proprio misurabile**: i CSV di `EMA200` **non hanno la colonna
`Peggior Giornata %`** (verificato su tutti quelli citati). 👉 **Il muro giornaliero del 5% su
questa sedia è `[NON MISURATO]` su OGNI cella**, quella viva compresa.

## 2.2 🏆 L'ASSE `InpTP1_ATRmult` — due celle contigue sotto il muro

`risultati_prove/dal_vps/ABTG_EMA200/ABTG_EMA200_U30USD_{IS,OOS}_r136b.csv`, 7 celle × 2 finestre.
Deposito **100.000** dichiarato nel file prova (`prove/R136b_primobersaglio_U30USD.txt`:
*«IL DEPOSITO 100.000 NON E' OPZIONALE»*) · tick reali.

🔑 **La semantica, letta nel sorgente e non dedotta** (`mql5/Experts/ABTG_EMA200.mq5` **r.77**,
**r.410-421**): `InpTP1_ATRmult = 0` **non è «zero su un continuo»: è un CAMBIO DI MODO** — TP1
sull'**EMA14** (bersaglio mobile) contro un **N×ATR fisso**. E poiché `InpBreakeven` scatta
**al TP1**, portare il TP1 a 0,25 ATR vuol dire **armare il breakeven quasi subito**.
👉 **È esattamente la stessa leva del `InpBEatR` del DAX, con un altro nome.**

| `InpTP1_ATRmult` | **`DD fisso` OOS → @2%** | PF OOS | **RF OOS** | prof. OOS | **`DD fisso` IS → @2%** | PF IS | RF IS | prof. IS |
|--:|--:|--:|--:|--:|--:|--:|--:|--:|
| **0,00** ← VOLA | 9,1932% → 🔴 18,39% | 1,52365 | 2,53681 | 23.321 | 5,8186% → 🔴 11,64% | 🟢 **1,20110** | 🟢 **0,78806** | 4.585 |
| **0,25** | 🟢 **2,2195% → 4,44%** | 🟢 **1,58999** | 🟢 **4,44157** | 9.858 | 🟢 **3,1362% → 6,27%** | 🔴 **0,99392** | 🔴 −0,02328 | −73 |
| **0,50** | 🟢 **3,5046% → 7,01%** | 1,40862 | 🟢 **3,56244** | 12.485 | 🟢 **3,1591% → 6,32%** | 🔴 1,01379 | 🔴 0,07560 | +239 |
| 0,75 | 8,6368% → 🔴 17,27% | 1,43601 | 1,98910 | 17.179 | 🟢 4,9350% → 9,87% | 🔴 0,89988 | −0,46685 | −2.304 |
| 1,00 | 10,1736% → 🔴 20,35% | 1,54867 | 2,20879 | 22.471 | 6,0007% → 🔴 12,00% | 🔴 0,86890 | −0,53947 | −3.237 |
| 1,25 | 11,2829% → 🔴 22,57% | 1,54040 | 2,15540 | 24.319 | 7,1695% → 🔴 14,34% | 🔴 0,83743 | −0,59790 | −4.287 |
| 1,50 | 11,7328% → 🔴 23,47% | 1,58656 | 2,36253 | 27.719 | 8,9072% → 🔴 17,81% | 🔴 0,76200 | −0,76566 | −6.820 |

## 2.3 🧪 I CONTRO-ESEMPI — cinque, e il quinto è quello che conta

### (a) *«vince perché è più piccola»* → **RESPINTO fuori campione**
`RF 2,53681 → 4,44157` = **+75,1%**, il valore più alto di tutto il dossier. Con puro
ridimensionamento sarebbe piatto. E l'asse lo conferma: **`RF` OOS quasi raddoppia** scendendo
verso l'estremo a bassa esposizione (2,36 a 1,50 → 4,44 a 0,25). Il lotto è dimensionato su
`InpSLatr`, **che questa manopola non tocca**: la perdita massima di un trade è identica.
✅ **Vincolo 1 rispettato.** 🔴 In IS il `RF` **si annulla** (0,78806 → −0,02328): lì non c'è
efficienza, c'è solo meno esposizione.

### (b) *«è il picco di una griglia»* → 🟢 **RESPINTO — qui l'altopiano c'è**
**DUE celle CONTIGUE** (`0,25` e `0,50`) stanno sotto il muro in **tutte e due** le finestre,
e in IS ce n'è anche una terza (`0,75`, 9,87%). Il salto è sul vicino successivo:
`0,75` in OOS risale a 17,27%. 🔴 **Ma il centro del blocco sarebbe `~0,375`, e NON È MISURATO**:
l'asse ha passo 0,25 e `0,25` è l'**estremo basso** della griglia. **Sotto non c'è niente.**

### (c) **Spearman IS→OOS — ed è la misura che divide in due il risultato**

| grandezza | ρ(IS→OOS) su 7 celle | lettura |
|---|--:|---|
| **`Equity DD %`** | 🟢 **+1,000** | **accordo PERFETTO di rango.** L'ordinamento del drawdown lungo quest'asse si riproduce **esattamente** fuori campione |
| `RF` | +0,536 | moderato |
| **`PF`** | 🔴 **−0,464** | **anti-correlato** |
| **profitto** | 🔴 **−0,607** | **anti-correlato** |

> 🎯 **Tradotto, ed è la frase più utile del dossier:** su questa manopola **il drawdown si
> COMPRA con una legge che regge fuori campione**; **il merito NO**. Il `PF OOS 1,58999` della
> cella `0,25` **non è una cosa che si poteva selezionare**: è la cella dove un asse
> anti-correlato è atterrato bene.

### (d) *«la formula `Profit/RF` esplode con RF≈0»* → **verificato, NON morde qui**
Avvertenza di casa (`IL_MURO_MISURATO` r.325). Sulla cella `0,25` IS il `RF` vale **−0,02328**,
vicinissimo a zero. **L'ho provato a rompere**: con `RF ∈ [−0,023285 · −0,023275]` (l'ultima
cifra stampata) `DD_ass ∈ [3.135,5 · 3.136,9]`, cioè **±0,04%**. Il `3,1362%` regge.
Il motivo è che **anche il profitto è piccolo** (−73,01): è il rapporto di due numeri piccoli,
non una divisione per zero.

### (e) 🔴 *«e le POSIZIONI?»* → **il buco vero di questa sedia, e non è teorico**
Su `EMA200` **le manopole d'uscita CAMBIANO GLI INGRESSI** — non è un'ipotesi, è **misurato e
agli atti**: `CONTRATTI_DELLE_SEDIE_FTMO` §3.2 mostra che `InpTP1Pct=0` dà **165 deal** mentre
le posizioni contate sono **257**, *«e chi la usasse sbaglierebbe del 36%»*. Causa strutturale:
l'EA rifiuta il segnale se è già impegnato (`ABTG_EMA200.mq5` **r.322**: `if(HasPosition() ||
HasPending())`), quindi **chiudere prima libera il posto per segnali successivi**.
👉 **Lungo tutto l'asse `InpTP1_ATRmult` le posizioni sono `[NON MISURATO]`** e il conteggio
`n` **non è decomponibile**. Il `517 → 495` non si sa cosa voglia dire.

## 2.4 Le altre celle di `771531`, e perché non arrivano al muro

| manopola | cella | `DD fisso` OOS → @2% | PF OOS | RF OOS | lettura |
|---|---|--:|--:|--:|---|
| `InpSLatr` | 1,0 → **1,4** | 6,5116% → 🔴 **13,02%** | 🟢 1,59482 | 🟢 3,01112 | ✏️ **CORREGGO `CELLE_MIGLIORI` §2D**, che lo declassa dicendo *«è un cambio di rischio»* perché il profitto scende: 🔴 **con puro ridimensionamento il RF sarebbe PIATTO, e invece sale del +18,7% OOS e +17,6% IS.** Non è solo taglia. 🟢 **Resta declassato, ma per l'ALTRA ragione, che è valida: è un picco** (i vicini `1,2` e `1,6` falliscono sul PF OOS). E comunque **non arriva al muro** |
| `InpUseTrailing` | 1 → 0 | 8,7942% → 🔴 17,59% | 🟢 **1,77080** | 🟢 3,21232 | ✏️ **CORREGGO `CELLE_MIGLIORI` §2C**, che scrive *«la cella migliore è esattamente il valore che vola (1)»*: **vero in IS, FALSO in OOS** — a `0` il fuori campione è migliore su **tutte e tre** le grandezze (PF 1,77080 vs 1,52365 · RF 3,21232 vs 2,53681 · Eq.DD 7,4151 vs 7,8323). La frase giusta è *«IS e OOS si contraddicono»*, e su **2 celle** l'altopiano **non esiste** |
| `InpTP_RR` | 2,0 → 2,5 | 16,77% *(dep. 10.000)* | 1,53175 | 2,57232 | conferma `CELLE_MIGLIORI` §2C: **alza il PF, sul DD non compra niente.** 🟢 Aggiungo il vicino mai citato: **`1,5`** fa `DD fisso` **14,20%** con RF **2,90878 (+16,1%)** e profitto **−1,2%** — cioè **DD −15,6% a profitto fermo**. Miglior rapporto dell'asse, **ma sempre sopra il muro** |
| `InpOrder1Atr` | 0,20 → 0,10 | — | 1,58102 | 2,87490 | 🔴 **Spearman IS→OOS NEGATIVO su tutto**: `PF −0,700`, `RF −0,700`, `DD −0,600`. L'asse **anti-predice**. `CELLE_MIGLIORI` §2E lo dava *«non misurato abbastanza»*: aggiungo **perché** non basterà misurarlo di più su questa partizione |
| **`InpTF`** | H1 → M15/M20/M30 | 🔴 **da 15,87% a 30,71%** di `Equity DD` | 🔴 0,83-0,95 | 🔴 **negativo** | 📉 **La risposta col numero al mandato «si preferiscono i TF più bassi»**: su questo motore i TF bassi **perdono soldi e triplicano il drawdown**. M20 fa `PF 0,83338 · DD 30,7078 · n 1642`. **H1 non è una scelta di comodo: è l'unico TF che regge**, ed è misurato |
| `InpTF` | H1 → **H4** | 4,4906% → 🟢 **8,98%** | 1,42483 | 🔴 **1,02529** | scende sotto il muro, **ma RF −59,6% e n 116**: è **puro rimpicciolimento** più un crollo di frequenza. 🔴 **Esattamente il caso che il vincolo 2 vieta di chiamare miglioramento** |
| `InpTP1Pct` | 25 / 50 / 75 | — | — | — | 🔩 **quasi inerte** (escursione PF 0,5%) — **casella CHIUSA**, come da mandato. `0` è il disastro già noto |

---

# 3️⃣ 🧩 LA COSA CHE LE DUE SEDIE DICONO INSIEME

Le ho cercate separatamente, con due EA diversi, due mercati, due timeframe e due round scritti
da persone diverse a un mese di distanza. **Hanno restituito la stessa leva.**

| | `770101` DAX | `771531` EMA200 Dow |
|---|---|---|
| manopola | `InpBEatR = 0,15` | `InpTP1_ATRmult = 0,25` |
| **che cosa fa davvero** | sposta lo stop a pari a **0,15 R** | porta il TP1 a **0,25 ATR**, e `InpBreakeven` scatta **al TP1** |
| **in una frase** | 🔑 **arma il breakeven molto prima** | 🔑 **arma il breakeven molto prima** |
| `DD fisso` OOS | 8,90% → **4,37%** (−50,9%) | 9,19% → **2,22%** (−75,9%) |
| **RF OOS** | +23,2% | +75,1% |
| **prezzo, profitto OOS** | 🔴 −39,6% | 🔴 −57,7% |
| **in campione** | 🟠 PF +1,8%, RF −4,5% | 🔴 PF 0,99392, RF ≈ 0 |
| altopiano? | 🔴 **una cella sola** sotto il muro | 🟢 **due celle contigue** |
| ρ(IS→OOS) sul DD | +0,929 | 🟢 **+1,000** |
| ρ(IS→OOS) sul PF | +0,821 | 🔴 **−0,464** |
| muro giornaliero | 🔩 manopola **inerte** (0,005 punti), 🟢 ma il muro è già passato (−1,08%) | 🔴 **colonna assente: `[NON MISURATO]`** |

> 🎯 **La lettura che ne esce, e non è quella che speravo di scrivere:**
> **il drawdown di queste due sedie si può comprare, e il prezzo è il 40-58% del profitto.**
> Non è un parametro «migliore»: è uno **scambio**, e l'archivio adesso ne conosce il cambio
> esatto. 🔴 **Se quello scambio conviene o no dipende da una cosa che non è mia: se la
> challenge si vince restando dentro il muro o facendo il target.** È una firma di Claudio.

---

# 4️⃣ 🔴 LA RISPOSTA SECCA ALLE TRE DOMANDE DEL MANDATO

### 1. *Esiste una cella che porti il DD sotto il muro?*
🟢 **SÌ, due — una per sedia — e nessuna delle due tocca `InpRiskPercent`.**
Portano il **limite superiore** della perdita statica a **8,74% / 7,53%** (`770101`) e a
**4,44% / 6,27%** (`771531`), contro il muro del **10%**. Per la **classe 562** questo
**DIMOSTRA** la sicurezza: non è una stima ottimista, è un tetto.

### 2. *Senza perdere il merito?*
🔴 **NO. Il merito si perde, e ho il numero.** Il profitto scende del **39,6%** e del **57,7%**
fuori campione. **Il `RF` sale** (che è il test giusto e lo passa), **ma il `PF` in campione
regge solo sul DAX** (1,14812), mentre su `EMA200` **va a 0,99392: il motore non guadagna nella
finestra vecchia.**
👉 **Quindi la risposta completa è: «sì al muro, no al pasto gratis».** Una cella che compra
sicurezza vendendo il 40-58% del rendimento **non è un parametro migliore**: è un'altra sedia,
più lenta e più sicura. **E chiamarla "miglioramento" sarebbe barare quanto abbassare il
rischio.**

### 3. *E la regola di casa cosa dice?*
- **`771531 · InpTP1_ATRmult`**: 🟢 **l'altopiano c'è** (2 celle contigue), 🟢 **ρ(DD) = +1,000**,
  🔴 **ma ρ(PF) = −0,464 e il centro `~0,375` non è misurato**, 🔴 **e le posizioni sono
  `[NON MISURATO]` su un EA dove il conteggio deal è dimostrato fuorviante del 36%.**
  → **NON PROMUOVIBILE OGGI. Misurabile domani con 8 passate.**
- **`770101 · InpBEatR`**: 🔴 **è il picco**, 🔴 **fallisce il cancello (d) congelato dal suo
  stesso file prova**, 🔴 **e il test del gemello (Nasdaq→DAX) NON si ripete.**
  → **«MISURATO E NON PROMOSSO»**, che il file prova stesso chiama *«un esito»*.

---

# 5️⃣ 📐 LA MISURA PIÙ CORTA CHE CHIUDEREBBE TUTTO — 16 passate, una serata

Nessuna delle due è una griglia larga su un motore morto: **una manopola sola, su una sedia
viva, sulla gestione dell'uscita.** ✅ È esattamente la categoria che il mandato autorizza.

| # | sedia | asse | celle | passate | che cosa chiude |
|--:|---|---|---|--:|---|
| **1** | `770101` | `InpBEatR` | **0 · 0,10 · 0,15 · 0,20** | **8** (4 × 2 finestre) | 🎯 **dà un VICINO allo `0,15`.** Oggi non ne ha: sotto non c'è griglia, sopra c'è il crollo. Se `0,10` e `0,20` restano sotto il muro, **smette di essere un picco e diventa un centro**. Deposito **80.000**, tick, **export per-trade ACCESO** → chiude anche il cancello (d) in POSIZIONI |
| **2** | `771531` | `InpTP1_ATRmult` | **0,125 · 0,25 · 0,375 · 0,50** | **8** | 🎯 **trova il CENTRO del blocco `{0,25 · 0,50}`** e sonda sotto lo `0,25`. **Export per-trade ACCESO**: oggi le posizioni di quest'asse sono `[NON MISURATO]` e su questo EA il conteggio deal sbaglia del 36% |

**Costo totale: 16 passate.** Metro: `R201A` ne ha fatte **14 in una sola corsa** il 21/09
(referto: lanciato 21:05:24) → **stima ~5-10 minuti di tester** sul PC di backtest.
🔴 **Non sul VPS** (regola del 21/09: la challenge sta operando).
🚫 **I file prova NON li ho scritti**: è il passo dopo, e devono passare `controlla_prova.py`
**e** l'agente `controllo-preventivo` prima di uscire.

### 💡 E una misura che costa ZERO macchina, che non è mia ma va segnalata
🔴 **`R201A` è girato il 21/09 e non è mai stato giudicato.** Il verdetto di quel round —
con i suoi quattro cancelli congelati — **si scrive leggendo i CSV che sono già in repo.**
Costo: **zero passate.** 👉 È la cosa più a buon mercato di questo dossier.

---

# 6️⃣ 🕳️ I BUCHI, PER NOME — quello che NON ho coperto e perché

| # | che cosa **non** ho coperto | perché | quanto costa chiuderlo |
|--:|---|---|---|
| **H1** | 🔴 **Il muro GIORNALIERO (5%) su `771531`** | **la colonna `Peggior Giornata %` non esiste** in nessun CSV di `EMA200` (verificati tutti quelli citati): OPTFRAME più vecchio, 8 colonne invece di 11. **Metà del muro non è misurata su questa sedia, cella viva compresa** | gratis dentro qualunque corsa nuova (l'OPTFRAME di oggi la stampa) |
| **H2** | 🔴 **Le POSIZIONI di tutte le celle candidate** | nessun per-trade in repo, né per R201A né per r136b. E su `EMA200` è **dimostrato** che il conteggio deal inganna del 36% | export per-trade: gratis dentro le 16 passate del §5 |
| **H3** | 🔴 **Il BINARIO che vola** | R201A è ancorato al pin `c4510e85` del 21/09; r136b viene dal VPS di settembre; R112 è del 26/08. **Nessuna misura di questo dossier descrive il `.ex5` che sta operando adesso su `541452707`** | è la stessa domanda del buco **B6** dei contratti, ancora aperta |
| **H4** | 🔴 **Il SIMBOLO che vola** | tutto è misurato su `D30EUR`/`U30USD` (BCM); le sedie volano su `GER40.cash`/`US30.cash` (FTMO). Il trasferimento è **assunto** | `[NON MISURATO]`, e non si chiude da backtest BCM |
| **H5** | 🟠 **La PROVA DI REGIME** | 21 mesi = **un solo regime (toro)**. La regola **C** dell'Emendamento della Finestra **non è soddisfatta da nessuna cella**, nemmeno da quelle vive | una corsa per finestra di regime, non stimata qui |
| **H6** | 🟠 **`Recovery Factor`: bilancio o equity?** | ambiguità **non risolta in casa** (`IL_MURO_MISURATO` r.365). Tutto il mio `DD fisso` ci poggia | non morde sul CONFRONTO fra celle (stesso metro per tutte); morderebbe sul valore assoluto |
| **H7** | 🟠 **Le COMBINAZIONI di due manopole** | l'archivio ha solo assi a **una** variabile (ed è giusto così). `InpTP1_ClosePct=0` **+** `InpBEatR=0,15` sul DAX **non è mai stata misurata**, e sarebbe il candidato naturale: la prima porta il merito, la seconda il muro | fuori dal mandato «una variabile per file prova»: sono **due** round in fila, non uno |
| **H8** | ⚪ **Le altre quattro sedie FTMO** | il mandato chiedeva le due sopra il muro. `770202`, `770260`, `770411`, `770511` **non le ho guardate** | — |
| **H9** | ⚪ **I round `R196A` · `R197A/B` · `R198` · `R199B` · `R200A/C/E` · `R172D` · `R202A`** | girati il 21/09 ma su **Nasdaq `770260`** e **Dow `770202`**: fuori bersaglio. 🔴 **Però sono nella stessa condizione di `R201A`: girati e in gran parte non giudicati** | segnalato, non misurato |

---

# 7️⃣ ✅ COSA È ANDATO BENE — perché un elenco di difetti senza le vittorie descrive male la realtà

- 🥇 **Una misura buona e recente era in casa e nessuno l'aveva letta.** `R201A`: deposito
  **giusto** (80.000), modello **giusto** (tick), sedia **giusta**, 48 ore fa. Ritrovarla è
  costato **zero minuti macchina** — esattamente quello che il mandato chiedeva.
- 🟢 **Il metro `DD fisso` funziona e lo prendo in prestito**: costruito da un altro il 22/09,
  riconciliato su 1.845 righe, e qui applicato a **60 celle** senza una sola corsa nuova.
  👉 **È la prova che gli attrezzi di casa si ripagano.**
- 🟢 **Due sedie indipendenti hanno indicato la stessa leva.** Quando due strade diverse
  arrivano allo stesso ramo di codice, non è coincidenza: è un **meccanismo**.
- 🟢 **Due affermazioni sbagliate in repo corrette col numero in mano** (`InpUseTrailing`
  sull'EMA200, `InpSLatr` declassato per la ragione sbagliata) — e **la seconda correzione
  NON salva il candidato**: resta declassato, solo per il motivo giusto. 🔴 Correggere in
  favore proprio sarebbe stato più comodo e più falso.
- 🟢 **Il controllo di regressione di `R201A`, che sembrava fallito, PASSA** — e il modo in cui
  passa (0,7962 ≈ 80.000/100.000) è **esattamente la classe 604 applicata bene**.
- 🟢 **La classe 618 ha morso al primo colpo.** Ho guardato la colonna giornaliera perché
  quella classe è stata scritta stamattina, e ho trovato una manopola **inerte su metà muro**.
  Senza quella riga di checklist, avrei consegnato mezza diagnosi.

---

# 8️⃣ 🖊️ LA RIGA PER CLAUDIO

> 🧱 **Il muro si può scavalcare, e adesso sappiamo quanto costa il biglietto.**
> Per tutte e due le sedie esiste **in archivio, già misurata, senza toccare il rischio**, una
> cella che porta la perdita statica **sotto il 10%** — e in tutte e due i casi è **la stessa
> idea**: armare il breakeven molto prima. Il prezzo è **il 40-58% del profitto**.
> 🟢 Quella dell'**EMA200** è la più solida: **due celle contigue** e l'ordine del drawdown che
> si riproduce **perfettamente** fuori campione.
> 🔴 Quella del **DAX** è un **picco**, e fallisce un cancello che il suo stesso file prova
> aveva congelato prima dei numeri.
> 📐 **16 passate — una serata sul PC di backtest — dicono se sono centri di altopiano o
> rumore.** E **una lettura a costo zero** (`R201A`, girato il 21/09 e mai giudicato) va fatta
> comunque.
> ✋ **Non ho promosso niente, non ho archiviato niente e non ho toccato niente.** Le due sedie
> stanno operando: tutto quello che c'è qui è **carta**, ed è firma tua.

---

*Misura prodotta in sola lettura il 23/09/2026 su **2.202 CSV** con intestazione OPTFRAME
(su 2.409 totali in repo), dei quali **35** compatibili con `ABTG_EMA200` su `U30USD` e **70**
con `ABTG_DAX_Apertura_EU` su `D30EUR`. Ogni numero è stato letto da me al file sorgente e
ricalcolato; nessuno è stato ripreso da un referto. Dove un numero non esiste, c'è scritto
`[NON MISURATO]`.*
