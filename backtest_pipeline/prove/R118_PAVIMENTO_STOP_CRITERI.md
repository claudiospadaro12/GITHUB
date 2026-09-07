# 🧊 R118 — IL PAVIMENTO DELLO STOP SOTTO SLIPPAGE

## Criteri congelati il **07/09/2026**, PRIMA di qualunque numero di questo round

> 🛑 **Questo file si legge PRIMA delle tabelle.** Un collaudo senza criteri
> congelati prima dei numeri non e' un collaudo: e' una spazzolata.
>
> 🚫 **Questo round non esegue niente qui, non tocca nessun EA, nessun preset,
> nessun parametro di forward, nessun conto.** MT5 sta sul PC di backtest.
> Da qui esce una RACCOMANDAZIONE per Claudio, mai un cambio automatico.

---

## 0. 📜 DA DOVE NASCE — un conflitto documentato, non una curiosita'

| | **LUI** (PS5 ORB BOT §5/§7, Garbuglia, fonte di **4° rango**) | **NOI** (R55, 15/08/2026) |
|---|---|---|
| verdetto | 🚫 il **pavimento dello stop deve restare a ZERO** | ✅ la via coerente e' **ALLARGARE** lo stop |
| numero | pavimento a 20 punti: DAX **PF 2,40 → 1,26**; US2000 2,97 → 1,05-1,40. *«dimezza l'edge»* | l'ORB **non muore di PF** (1,57 anche a 200 punti), **muore di DRAWDOWN**: sfonda il 10% con **1,5 punti indice** di slippage |
| grandezza misurata | **PROFIT FACTOR** | **DRAWDOWN a rischio percentuale** |

Analisi che ha isolato il conflitto: `report/ANALISI_STUDIO_PS5_ORB_2026-09-06.md`
§4 e §4.3. La lettura *«non si contraddicono: misurano due grandezze diverse»*
e' un'**inferenza**, non una misura. **Questo round e' il tentativo di
chiuderla con una misura.**

E i rami sono **TRE**, non due (`ABTG_DAX_Apertura_EU.mq5` righe 1064-1067,
1088-1091, 1297-1301, 1405-1410, 1493-1496, 1526-1529):

| ramo | configurazione | chi lo sostiene | stato |
|---|---|---|---|
| **A** | `InpMinStopPts = 0` | **LUI** | 🟢 **e' la configurazione VIVA oggi sul conto reale 10105439** |
| **B** | `InpMinStopPts > 0` + `InpSkipIfTight = false` → **allarga** lo stop | **NOI** (R55, `ORB_100K_CRITERI.md` punto D) | 🟡 misurato **solo a slippage 0** e **solo sull'ORB** (R88) |
| **C** | `InpMinStopPts > 0` + `InpSkipIfTight = true` → **SALTA** il trade | ⬜ **nessuno dei due** | 🔴 **MAI MISURATO DA NESSUNO** |

---

## 1. 🔴 IL PUNTO PIU' IMPORTANTE DEL DISEGNO, scritto per primo

> **Non si puo' misurare il valore di un pavimento anti-slippage in un mondo a
> slippage ZERO.**

Oggi `InpSlippagePts = 0` su tutte e due le sedie vive. Con slippage 0 il ramo
C **per costruzione** toglie solo trade e non protegge da niente: ne uscirebbe
*«il pavimento costa e non da' niente»*, che sarebbe una **conclusione falsa e
garantita in partenza**.

👉 **Lo slippage e' un ASSE di questo round, non una costante.** E i suoi valori
sono **SCENARI ASSUNTI, non misure** (§4).

---

## 2. 🔬 DOVE OGNI RAMO E' MISURABILE — e i tre limiti dichiarati

Letto nei sorgenti, riga per riga, il **07/09/2026**. Il codice **NON si tocca
in questo round**: dove il codice non arriva, la misura **esce dal round**.

| | `ABTG_DAX_Apertura_EU` | `ABTG_ORB_Ottimizzato` |
|---|---|---|
| `InpSlippagePts` | riga **344** — applicato **SOLO** agli ingressi a **pendente STOP** (righe 1059, 1083) e ai rami DELAYED/OPENCONFIRM. **NON applicato al RETEST** (riga 1487: *«limit sul livello (niente buffer/slippage)»*) | riga **248** — applicato a **SL e TP dopo** il calcolo del lotto (righe 454-455, 469-470, 597-598) |
| `InpMinStopPts` | riga **345** — presente in **tutti** i rami d'ingresso, RETEST compreso (1493, 1526) | 🔴 **NON ESISTE** |
| `InpSkipIfTight` | riga **346** — idem | 🔴 **NON ESISTE** |
| equivalente di B | — | `InpSLBufferPts` riga **192**, **solo** nei modi OPPRANGE(0) e HALFRANGE(3) |

### 🕳️ LIMITE 1 — **il ramo C sull'ORB non e' implementabile.**
`ABTG_ORB_Ottimizzato.mq5` non ha ne' `InpMinStopPts` ne' `InpSkipIfTight`.
Servirebbe codice nuovo → **la misura esce dal round**. Sull'ORB si confrontano
**A** e un **equivalente di B** (`InpSLBufferPts`), e nient'altro.

### 🕳️ LIMITE 2 — `InpSLBufferPts` **non e' un pavimento: e' un allargamento SEMPRE.**
Il pavimento agisce **solo quando lo stop e' piu' stretto della soglia**; il
buffer si somma **a ogni trade**. Sono parenti, non gemelli. Ogni riga del
referto che li accosta lo deve **scrivere accanto al numero**.

### 🕳️ LIMITE 3 — **sulla cella VIVA del DAX lo slippage non e' simulabile.**
La 770101 gira in **RETEST** (`InpEntryMode=2`), e il codice **non applica lo
slippage a un ingresso LIMIT**. Quindi la corsa **c** misura del pavimento
**solo il canale lotto→DD** (stop piu' largo = meno lotti = meno DD), **mai il
canale protezione-dallo-slippage**.
👉 **Il segno del bias e' NOTO: la corsa c SOTTOSTIMA il valore del pavimento.**
Un bias di cui si conosce il verso si dichiara e si tiene; non si aggira.

---

## 3. ⚠️ LE UNITA' — la trappola che da sola avrebbe reso il round privo di senso

Nel codice il pavimento si applica come `InpMinStopPts * _Point`: **e' in PUNTI
MT5**. Su questi indici BCM (2 decimali) **100 punti MT5 = 1 punto indice**.

> **[MISURATO, non assunto]** — `REFERTO_ROUND55_SLIPPAGE.md` (*«200 punti = 2
> punti indice sul Dow»*, *«150 punti, cioe' 1,5 punti indice»*),
> `prove/R55b_slippage_ORB.txt` riga 25, `prove/R88a_stoplargo_U30USD.txt`
> (*«100 PUNTI MT5 = 1 PUNTO INDICE su U30USD a BCM»*, con l'errore di un
> fattore dieci della missione R88 gia' agli atti).

**I «20 punti» del collega sono quasi certamente 20 punti INDICE = 2000 punti
MT5.** Chi scrivesse `20` imposterebbe **0,2 punti indice**: un no-op, tre rami
identici, e un referto che conclude il falso con numeri veri.

🧾 **REGOLA DI QUESTO ROUND, non negoziabile: ogni valore si scrive in TUTTE E
DUE le unita', sempre, in ogni tabella e in ogni frase.**

| punti MT5 | punti indice |
|---:|---:|
| 500 | 5 |
| 1000 | 10 |
| 2000 | **20 ← il numero del collega** |
| 4000 | 40 |
| 6000 | 60 |
| 6500 | **65 ← la frontiera MISURATA di casa** (40 × spread D30EUR) |
| 8000 | 80 |

---

## 4. 📏 LA SCALA DELLO SLIPPAGE — **SCENARI ASSUNTI**, e si dice

> 🔴 **NON SAPPIAMO QUANTO SLIPPAGE C'E' DAVVERO.**
> `ABTG_SlippageLogger` sul conto reale ha **0 deal registrati** (deployato il
> 05-06/09/2026). BCM ha confermato che **il conto DEMO non simula lo
> slippage**. `MISURA_SLIPPAGE_2026-09-05.md` misura **921 uscite del TESTER**,
> che e' un **PAVIMENTO** del vero, non il vero.
> 👉 **Ogni livello qui sotto e' uno SCENARIO ASSUNTO. Nessuno e' una misura del
> nostro slippage reale, e il referto lo deve ripetere sotto ogni tabella.**

### 4.1 La scala dell'ORB (corsa **a**) — **identica a quella di R55**

`0 / 50 / 100 / 150 / 200` punti MT5 = `0 / 0,5 / 1,0 / 1,5 / 2,0` punti indice.

| livello | perche' proprio questo |
|---|---|
| **0** | il **controllo**: e' la configurazione viva, e deve riprodurre numeri gia' noti (§6) |
| **50** = 0,5 pt indice | ordine di grandezza della **mediana in sessione** delle 921 uscite del tester (0,40) — pavimento, non verita' |
| **100** = 1,0 | gradino intermedio, serve a vedere la **pendenza** (una curva a due punti non e' una curva) |
| **150** = 1,5 | 🔴 **il numero di R55**: e' qui che il DD di questa cella sfonda il 10% (9,76 → 10,21) |
| **200** = 2,0 | il tetto della scala R55: **la tabella di questo round si appoggia direttamente a quella di R55** |

**Motivo della scelta: comparabilita' diretta.** Sull'ORB il modello di
slippage e' lo stesso di R55 (SL e TP spostati contro il trade **dopo** il
calcolo del lotto), quindi la colonna slippage di questo round e la tabella §2
di R55 si leggono **una accanto all'altra**. Cambiare scala avrebbe buttato via
l'unica misura di casa gia' esistente su questa cella.

### 4.2 La scala del DAX (corsa **b**) — **piu' lunga, e NON comparabile con R55**

`0 / 100 / 200 / 300 / 400` punti MT5 = `0 / 1 / 2 / 3 / 4` punti indice.

| livello | perche' proprio questo |
|---|---|
| **0** | controllo |
| **100** = 1,0 | sotto la soglia che ha ucciso l'ORB in R55 |
| **200** = 2,0 | il tetto di R55 |
| **300** = 3,0 | ≈ il **P95 IN SESSIONE** delle 921 uscite del tester (**3,25**) — e il tester e' un pavimento |
| **400** = 4,0 | l'ordine di grandezza degli **unici due campioni di esecuzione VERA** esistenti nei due corpus: PS5 §6, US30 **4,67** e NAS **2,38** punti indice. **[DICHIARATO da lui, non verificato da noi]** |

> 🔴 **E QUI IL MODELLO E' DIVERSO, quindi i numeri NON si confrontano con R55.**
> Sul DAX `InpSlippagePts` **sposta il livello del pendente STOP**
> (`entry = buyPx + InpSlippagePts*_Point`, riga 1059). Conseguenze, tutte e
> quattro da scrivere a referto:
> 1. l'ingresso e' peggiore → **primo ordine, e' quello che vogliamo**;
> 2. il **grilletto si sposta**: alcuni trade **non partono piu'** → **n cambia
>    lungo l'asse dello slippage**. Lo slippage vero NON sposta il grilletto;
> 3. con `InpSLMode=0` (RANGE) lo stop e' il bordo opposto, quindi la
>    **distanza cresce** e il **lotto si RIDUCE** → il DD puo' **scendere**
>    all'aumentare dello slippage. **E' un artefatto del modello, non
>    robustezza**;
> 4. il TP e' ricalcolato su `dist` (riga 1070) → **l'R resta l'R**.
>
> ⚖️ **Il verso del bias complessivo NON e' determinabile a priori.** Va
> dichiarato cosi', senza sceglierne uno che faccia comodo.

### 4.3 Lo SPREAD non e' un asse di questo round
Resta quello dei tick reali. La riga `Spread` dell'`.ini` a Modello 4 e'
**[NON MISURATO]**: non sappiamo se MT5 la onori. Chi volesse aggiungerlo deve
prima passare il **canarino** (stesso EA con spread assurdo → numeri DIVERSI).
Spread misurati agli atti, per la lettura: D30EUR **1,6-1,7** pt indice in
sessione (notte 3,5-3,9), U30USD **1,9-2,0**
(`SPREAD_FLOTTA_MISURA_2026-09-03.md`, 252 M tick).

### 4.4 Da dove vengono i valori del PAVIMENTO (corse b e c)
`0 / 2000 / 4000 / 6000 / 8000` punti MT5 = `0 / 20 / 40 / 60 / 80` punti indice.

- **0** = ramo A, la configurazione viva;
- **2000 = 20 pt indice** = 🎯 **il numero esatto del collega**, e per pura
  convergenza ≈ il nostro **pavimento DURO** (13,3 × spread = **21-23** pt
  indice su D30EUR, `CACCIA_TFBASSO_FREQUENZA_2026-09-06.md` §6.2);
- **4000 = 40** = ponte. Nessuna ancora: serve a leggere l'altopiano, e senza
  di lui fra 20 e 60 non c'e' niente;
- **6000 = 60** e **8000 = 80** = 🎯 **incastrano la frontiera MISURATA di
  casa**: `stop >= 40 × spread` → su D30EUR **64-68 pt indice** (= 6400-6800
  punti MT5). La frontiera resta **dentro** la griglia, non ai suoi bordi.

📌 **PREVISIONE SCRITTA PRIMA, falsificabile** (e se sbaglio resta scritto):
lo stop di questa cella e' l'**intero range d'apertura** (SLMode=RANGE), quindi
stimo che **2000 (20 pt indice) non morda quasi mai**, 4000 a volte, 6000
spesso, 8000 quasi sempre. **Se 20 non morde, il numero del collega su questa
geometria non e' nemmeno confutabile: e' un no-op** — e allora il conflitto non
si chiude sul DAX Apertura, si sposta sull'ORB, dove lo stop e' **meta'** range.

---

## 5. 🧮 LO SWEEP — dichiarato e contato

| corsa | EA | simbolo | TF | dep. | assi | celle/finestra | passate |
|---|---|---|---|---:|---|---:|---:|
| **a** | `ABTG_ORB_Ottimizzato` | U30USD | M5 | 100.000 | `InpSLBufferPts` (5) × `InpSlippagePts` (5) | **25** | **50** |
| **b** | `ABTG_DAX_Apertura_EU` | D30EUR | M15 | 10.000 | `InpMinStopPts` (5) × `InpSkipIfTight` (2) × `InpSlippagePts` (5) | **50** | **100** |
| **c** | `ABTG_DAX_Apertura_EU` | D30EUR | M15 | 10.000 | `InpMinStopPts` (5) × `InpSkipIfTight` (2) | **10** | **20** |
| | | | | | **TOTALE** | **85** | **170** |

Finestra unica per tutte e tre: **2024.09.26 → 2026.06.30**, `-FrazioneIS 0.40`
→ IS `2024.09.26 → 2025.06.09`, OOS `2025.06.10 → 2026.06.30`. Sono le finestre
di R15 / R54b / R55 / R83 / R88: **i numeri restano confrontabili**.
`@DAQUANDO 2024.09.26` e' il **muro MISURATO dei tick BCM sugli indici**
(`REFERTO_SONDA_STORICO_17-08.md`, stato COMPLETO), non una scelta.
**Modello 4 = tick reali** in tutte e tre: nessun gradino di questo round gira
in OHLC (R57: il solo modello ribalta il segno).

📌 **Nota di scrittura, non di merito**: `InpSkipIfTight` e' un `bool` e nei
file prova e' scritto **`0||0||1||1||Y`**, non `false||...||true`. Motivo
misurato: `walkforward_generico.ps1`, quando blinda da solo un bool, produce
gia' la forma **numerica** (`Risolvi()` converte `true→1`, `false→0`), ed e' la
forma con cui sono girati **tutti** i round di questa casa. La forma con le
parole compare in due file prova **mai lanciati**: non e' provata, e un round
non e' il posto dove provarla.

### 5.1 🐤 Le celle GEMELLE che escono gratis, e vanno verificate
- **corsa b**: a `InpMinStopPts=0` il blocco del pavimento non si attiva mai,
  quindi `InpSkipIfTight` e' inerte → **5 coppie identiche al centesimo**.
- **corsa c**: stesso motivo → **1 coppia identica al centesimo**.
- **corsa a**: `InpSLBufferPts` e `InpSlippagePts` **non toccano gli ingressi**
  → 🔴 **il numero di trade DEVE restare 71 (IS) e 119 (OOS) in TUTTE E 25 le
  celle.**

**Se una di queste uguaglianze si rompe, c'e' un effetto che non abbiamo
capito: il round si ferma PRIMA di leggere il resto.**

### 5.2 Magic vergini, e perche'
`778220` (a), `778230` (b), `778240` (c). **Nessuna corsa usa 770611 o 770101**:
il driver cancella i per-trade per magic, e i magic vivi non si sfiorano
nemmeno in backtest.

---

## 6. ⚓ LE ANCORE — cancelli BLOCCANTI, si leggono PRIMA di tutto il resto

Sono numeri **gia' pubblicati**. Se una corsa non riproduce la sua ancora, **i
suoi numeri non si leggono**: si cerca cosa e' cambiato (EA riscaricato dalla
punta di `lavoro`, cache del tester, dati). Il resto del referto resta chiuso.

### A1 — corsa **a**, la colonna a slippage 0 (tre ancore su cinque celle)
Fonte: `r88_csv/ABTG_ORB_Ottimizzato_U30USD_{IS,OOS}_r88a.csv`, celle
`InpSLMode=3` + `InpTPMode=1`. Triplicemente verificata su buffer 0 (R54b
14/08, R55 15/08, R88 20/08 — identici a quattro decimali).

| `InpSLBufferPts` | IS Profit / PF / DD% / n | OOS Profit / PF / DD% / n |
|---|---|---|
| **0** (0 pt indice) | **9.509,39 / 1,24979 / 7,8885 / 71** | **41.057,00 / 1,67419 / 9,7623 / 119** |
| **500** (5) | 3.193,77 / 1,09174 / 7,8098 / 71 | 29.295,20 / 1,51284 / 9,5573 / 119 |
| **1000** (10) | 1.095,82 / 1,03507 / 7,0616 / 71 | 28.466,13 / 1,55394 / 8,0454 / 119 |

Le celle **1500** e **2000** sono **nuove**: nessuna ancora, e non se ne
inventa una.

### A2 — corsa **c**, la riga `InpMinStopPts=0` (= la cella VIVA della 770101)
Fonte: `r83_csv/ABTG_DAX_Apertura_EU_D30EUR_{IS,OOS}_r83v.csv` (R83, 18/08).

| | Profit | PF | DD% | n | Peggior giornata % |
|---|---:|---:|---:|---:|---:|
| **IS** | **282,12** | **1,07810** | **7,0257** | **197** | −1,0502 |
| **OOS** | **999,42** | **1,18776** | **10,5984** | **311** | −1,0671 |

⚠️ Il **10,5984%** e' il DD scritto nel **contratto** della sedia 770101
(`CONTRATTI_SEDIE.md`), ed e' la cella incoronata da R83. **E' il metro.**

### A3 — corsa **b**, la riga `InpMinStopPts=0`, `InpSlippagePts=0`
Confronto **ATTESO, NON GARANTITO** con R83 cella **D0**: IS 203,66 / 1,04668 /
7,9333 / 220 · OOS 251,22 / 1,04089 / **13,2624** / 325.
🔴 **Non e' bloccante, e il motivo va scritto**: D0 e' girata sul **fork**
`ABTG_Apertura_3Ingressi.mq5`, e l'equivalenza fork↔vivo e' stata **VERIFICATA
solo su D1/V (DAX) e N0/A (Nasdaq)**, mai su D0 del DAX. Se non coincide, il
round non si ferma: si scrive lo scarto e il riferimento della corsa b diventa
la sua stessa riga `pavimento 0 / slippage 0`.

### A4 — le due sedie VIVE e le tre differenze dichiarate
Le corse girano a **rischio 1,00%** e ai depositi dei round di provenienza. Le
sedie sul conto reale **10105439** girano a **0,65%**. Inoltre:

| | cella misurata qui | sedia viva sul reale |
|---|---|---|
| DAX 770101 | rischio **1,0%**, **long+short**, chart **M15** (= R83 V) | rischio **0,65%**, **solo long**, chart **M5** |
| ORB 770611 | rischio **1,0%**, dep. **100k** (= R55/R88) | rischio **0,65%**, conto ~7.500 € |

👉 **Quindi i numeri assoluti di questo round descrivono la cella del
CONTRATTO, non il preset di campo.** Il round e' **comparativo**: i confronti
si leggono **dentro la stessa corsa**, mai fra corse e mai contro il campo.

---

## 7. 🐤 IL CANARINO DEL PAVIMENTO — senza questo, il round non ha contenuto

**Prima di qualunque giudizio** si verifica che il pavimento **morda**.

Nelle corse b e c, a slippage 0, con `InpSkipIfTight=true`:

- se **n(pavimento) = n(pavimento 0)** a un dato gradino, li' il pavimento
  **non si attiva mai**;
- 🚦 **CANCELLO: almeno un valore di pavimento deve cambiare n di >= 5%.**

Se **nessuno** lo fa → **ESITO 3** (§9): il round **non dice niente** sul
conflitto per quella cella, e dice **solo** che *«20 punti indice, su questa
geometria, sono un no-op»*. Che e' un risultato — ma di un'altra specie, e va
scritto con quelle parole, non con «il pavimento non serve».

---

## 8. ⚖️ IL GIUDIZIO — **PF, DRAWDOWN e FREQUENZA nella stessa riga**

> 🥇 **IL SENSO DI TUTTO IL ROUND E' CHE LEGGERNE UNA SOLA INGANNA.** Il
> collega ha letto il PF e ha concluso «mai il pavimento». R55 ha letto il DD e
> ha concluso «allargare». Nessuno dei due ha letto la FREQUENZA, che e' il
> prezzo del ramo C.
>
> 🚫 **E' VIETATO promuovere o bocciare un ramo leggendo una sola colonna.**
> Ogni riga del referto porta **PF, DD e n insieme**. Una tabella con meno di
> quelle tre colonne **non e' un risultato** e non entra nel referto.

### 8.1 Definizioni
Cella = **(F, S, X)** — F = pavimento (o buffer), S = ramo (B allarga / C
salta), X = gradino di slippage. **Baseline B(X) = (F=0, ·, X)**: stesso EA,
stessa finestra, **stesso gradino di slippage**.

⚠️ **Il confronto e' SEMPRE a slippage PARI.** Confrontare un pavimento a
slippage alto con la baseline a slippage 0 e' l'errore che questo paragrafo
esiste per vietare.

### 8.2 I tre cancelli — servono **TUTTI E TRE**, allo stesso gradino X

| | cancello | soglia | perche' quella soglia |
|---|---|---|---|
| **G1** 🛡️ | **RISCHIO** | `DD_OOS(F,S,X) <= DD_OOS(B(X))` **E** `DD_OOS(F,S,X) <=` **ancora assoluta** della corsa | l'ancora assoluta e' il **DD gia' promesso** dalla sedia: **9,7623%** (ORB, corsa a) e **10,5984%** (DAX, corsa c). Il criterio di uscita delle sedie (C3, 18/08) dice *«DD forward > DD promesso → revisione»*: qui e' lo stesso metro, applicato prima |
| **G2** 💰 | **MERITO** | `PF_OOS(F,S,X) >= 1,00` **E** `PF_OOS(F,S,X) >= 0,80 × PF_OOS(B(X))` | il prezzo massimo che accettiamo di pagare in edge e' **un quinto**. La soglia viene dalla **scala del conflitto**: lui misura **−47%** («dimezza l'edge») e lo giudica inaccettabile; **−20% e' un quinto, e lo dichiariamo accettabile PRIMA** |
| **G3** 🚚 | **FREQUENZA** | `n_OOS(F,S,X) >= 0,80 × n_OOS(B(X))` **E** `n_OOS >= 150` perche' il MERITO sia leggibile | la portata e' la **valuta scarsa** (H2/H3 del piano). Il ramo C compra sicurezza **pagando in trade**, e il prezzo si scrive. I 150 sono l'**Emendamento della finestra, regola A** |

Cella che passa **tutti e tre** al gradino X → **SOPRAVVISSUTA a X**.
Cella che ne manca **anche uno solo** → **NON sopravvissuta**, e si scrive
**quale** cancello ha mancato e **di quanto**.

### 8.3 🚨 Trasparenza obbligatoria sul cancello G2
**Ho letto la colonna a slippage 0 della corsa a (§6, A1) PRIMA di scrivere
questi criteri**: e' gia' pubblicata in R88 e serviva come ancora. Quindi **G2
NON e' cieco su quelle tre celle** (buffer 0/500/1000 a slippage 0, che pagano
−9,6% e −7,2% di PF e passerebbero). **G2 e' cieco su tutto il resto**: tutta
la scala di slippage, i buffer 1500-2000, e tutte e 60 le celle del DAX.
Sta scritto qui perche' nessuno debba scoprirlo dopo.

### 8.4 Dal cancello al verdetto — **la CURVA, mai il punto**
- 🥇 **PROMOSSA A RACCOMANDAZIONE**: cella sopravvissuta ad **almeno DUE
  gradini consecutivi** di slippage `>= 100` punti MT5 (1 pt indice), **E** con
  i **vicini nell'asse del pavimento** anch'essi sopravvissuti agli stessi
  gradini. **Centro dell'altopiano, MAI il picco** (Emendamento A). Una cella
  che sporge da sola e' rumore: in R70 il confronto si e' ribaltato quando e'
  stato rifatto con la regola giusta.
- 🟡 **FRAGILE**: sopravvive a un solo gradino, o e' un picco isolato. Si scrive
  **quanto margine reale ha**, in punti indice, e la decisione passa a Claudio.
- 🔴 **BOCCIATA**: non sopravvive a nessun gradino, oppure sfonda un muro
  (`DD > 10,00%` totale, o peggior giornata oltre il margine sul 5%) in
  **qualunque** gradino della scala.

### 8.5 ⚔️ Il pareggio B contro C — **regola dichiarata PRIMA**
Se ramo B e ramo C sopravvivono entrambi allo stesso gradino:
1. vince chi ha il **DD_OOS piu' basso** al gradino piu' alto in cui entrambi
   sopravvivono;
2. se il DD dista **meno di 0,5 punti percentuali**, vince chi ha **n piu'
   alto** (la portata e' la valuta scarsa);
3. se restano pari, vince **B**, perche' non cambia la popolazione dei trade e
   **il TP e' ricalcolato su `dist`** (righe 1070 e 1497): allargando lo stop il
   target si allarga in proporzione, **l'R resta l'R**. L'accusa del collega
   («allargare scardina le proporzioni») **da noi colpirebbe solo il buffer
   d'ingresso `InpBufferPoints`, che e' fisso** — non il target, non la size.

### 8.6 ⚠️ La regola che non cambia
> **Il campione sottile sospende il giudizio sul MERITO, mai sul RISCHIO.**
> Un drawdown accaduto vale a qualunque n.

Applicata **corsa per corsa, scritta prima**:

| corsa | n IS / n OOS attesi | MERITO | RISCHIO |
|---|---|---|---|
| **a** (ORB) | **71 / 119** (R15, R55, R88) | 🔴 **SOSPESO**: entrambi sotto 150, e non e' rimediabile (il muro dei tick non si sposta indietro, e spostare lo split lascerebbe un OOS di ~40) | ✅ **si legge** |
| **b** (DAX stop) | **220 / 325** (R83 D0) | ✅ **si legge** | ✅ si legge, **ma** la baseline parte gia' a **13,26% > muro**: la corsa b **NON PUO' PROMUOVERE NIENTE**, e' una misura di **MECCANISMO** |
| **c** (DAX retest) | **197 / 311** (R83 V) | ✅ **si legge** | ✅ si legge — **ma con il bias del LIMITE 3**, che la sottostima |

📌 E il **regime contenuto e' UNO SOLO** (indici 2024-2026, prevalentemente
rialzista). Va scritto accanto a ogni tabella. **Questo round non e' una prova
di regime** (Emendamento C).

---

## 9. 🧭 LA REGOLA DI DECISIONE SUL CONFLITTO — i quattro esiti, scritti PRIMA

Cosi' nessuno puo' raccontarla diversamente dopo.

| esito | quando si verifica | cosa si scrive a referto |
|---|---|---|
| **1️⃣ HA RAGIONE LUI** (su questa geometria) | la baseline `F=0` resta sotto l'**ancora assoluta di DD a TUTTI** i gradini di slippage, **e** nessuna cella con pavimento passa G1+G2+G3 | *«su questa cella il pavimento e' un costo puro: PS5 §5 e' confermato sui nostri dati. E il motivo e' che il DD non aveva bisogno di protezione qui»* |
| **2️⃣ HA RAGIONE R55** | la baseline **sfonda** l'ancora di DD a un gradino X, **e** almeno una cella con pavimento passa **tutti e tre** i cancelli **allo stesso X** | *«il pavimento e' una protezione, e questo e' il suo prezzo»*, col prezzo scritto **in PF e in trade**, e con **quale ramo** e **quale valore** (nelle due unita') |
| **3️⃣ IL PAVIMENTO NON MORDE** | il canarino §7 non scatta | *«20 punti indice su questa geometria sono un no-op»*. **Non** si scrive «il pavimento non serve»: si scrive che **su questa cella non e' nemmeno confutabile**, e ci si sposta sulla geometria dove morde |
| **4️⃣ IL RAMO C VINCE MA COSTA** | una cella passa G1 e G2 **solo** con `SkipIfTight=true`, e **manca G3** | verdetto **FRAGILE**, decisione a Claudio, col prezzo scritto **in trade/mese** e con la riga: *«la terza via esiste, funziona, e si paga in portata»* |

⚠️ **Esito misto per corsa e' legittimo e previsto**: la stessa regola puo'
cambiare segno fra ORB e DAX, esattamente come il retest ha cambiato segno fra
DAX e Nasdaq in R83. **Non e' una contraddizione: e' un risultato**, e allora
il verdetto si scrive **per geometria**, mai in generale.

---

## 10. 🕳️ COSA QUESTO ROUND **NON** DIRA' — scritto PRIMA, non dopo

1. 🔴 **Non dice quanto slippage c'e' davvero.** Il logger sul conto reale ha
   **0 deal**. Tutti i gradini sono **SCENARI ASSUNTI** (§4).
2. 🔴 **Non simula requote, rifiuti, riempimento parziale, profondita' del
   book, no-fill del limit.** MT5 non li modella, e **nessun backtest
   rispondera' mai** a quella domanda: solo il forward a taglia crescente.
3. 🔴 **Non copre il ramo C sull'ORB** (LIMITE 1): il codice non ce l'ha e **il
   codice non si tocca**.
4. 🔴 **Non copre lo slippage sulla cella VIVA del DAX** (LIMITE 3): il RETEST
   e' un LIMIT e il codice non gli applica slippage. La corsa c **sottostima**
   il valore del pavimento, e il verso del bias e' dichiarato.
5. 🔴 **Non giudica il MERITO sull'ORB** (n = 71/119, sotto 150).
6. 🔴 **La corsa b non puo' promuovere niente**: la sua baseline parte gia' a
   DD 13,26%.
7. ⚠️ **Non e' una prova di regime.** Una finestra e mezza, un regime solo.
8. ⚠️ **Non e' comparabile con R55 sul DAX** (modello di slippage diverso,
   §4.2). **Lo e' sull'ORB.**
9. ⚠️ **Non misura lo SPREAD come asse** (§4.3), e non tocca la scala a gradini
   di spread del collaudo: quella e' un'altra prova.
10. ⚠️ **Non verifica i numeri del collega.** Nessun `.htm`, nessun CSV,
    nessun `.set`: tutto quanto e' suo resta **[DICHIARATO]**. E **non abbiamo
    il suo codice**: se da lui il TP non si ricalcola sullo stop, la sua
    obiezione *«scardina le proporzioni»* puo' essere vera **a casa sua** e
    falsa a casa nostra. **Questo round non puo' chiudere quel punto.**
11. ⚠️ **Non dice niente sulla parziale, sui filtri, sulla taglia.** P5 e' un
    altro round; la taglia la decide il forward.
12. 🚫 **Non promuove, non spegne, non cambia niente in forward.** Da qui esce
    una **raccomandazione**, e decide Claudio.

---

## 11. ✅ IL PROCEDIMENTO, e dove si ferma

1. `-SoloControllo` su tutte e tre le corse. Il driver **deve stampare
   25 / 50 / 10 celle per finestra**. Se stampa altro, **ci si ferma li'**.
2. Corsa **c** per prima (20 passate, la piu' corta): e' il **cancello A2**.
   Se non riproduce R83 V, **il round si ferma prima di spendere macchina**.
3. Corsa **a** (50 passate): cancello **A1** sulla colonna a slippage 0.
4. Corsa **b** (100 passate): confronto **A3**, non bloccante.
5. Canarini gemelli (§5.1) e canarino del pavimento (§7).
6. Solo dopo: le tabelle, **complete di tutti i gradini** — mai solo quelli
   favorevoli — con **PF, DD e n sulla stessa riga** e le **due unita'** accanto
   a ogni valore.
7. Referto in
   `backtest_pipeline/risultati_archivio/REFERTO_R118_PAVIMENTO_STOP.md`.

---

*Criteri congelati il 07/09/2026, prima di qualunque numero di R118. Nessun EA
modificato, nessun preset toccato, nessun parametro di forward cambiato,
nessuna sedia sfiorata. Se questi criteri sono sbagliati, si cambiano nel round
DOPO: un criterio migliore non si applica retroattivamente ai numeri che ha
gia' visto.*
