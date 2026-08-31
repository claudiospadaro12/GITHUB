# 🔬 M27 — IL SEGNO DI E: il conflitto banco +0,091R vs forward −0,091R, risolto

_MOSSA 1 della **FIRMA "PORTATA"** (Claudio, 31/08: "FIRMO TUTTE E DUE,
PARTIAMO" — `report/FIRME_2026-08-31.md`). **Solo analisi: zero round, zero ore
di tester, zero modifiche al forward.** Consegnato il 31/08/2026._

---

## 🏁 IL VERDETTO IN QUATTRO RIGHE

1. **Il conflitto non e' simmetrico.** Il **+0,091R del banco e' OHLC** (R103
   §modello: _"1 = OHLC su M1, per tutte e 40"_; R105 e l'analisi dial ne
   discendono) — e i **criteri di R103 stessi** dichiarano che _"sugli indici
   l'OHLC HA GIA' MENTITO"_. Il forward e' reale. Non sono due misure alla pari:
   **una e' un limite superiore ottimista, l'altra e' cio' che e' successo.**
2. **Il −0,091R NON e' sistemico: e' concentrato in DUE sedie.** Tolte
   `770101` e `770611`, i restanti **76 ingressi fanno +22,97 €** = **+0,006%
   per trade**: **piatto**, non negativo.
3. **La causa n.1 e' una TAGLIA, non un edge.** Le **3 peggiori operazioni di
   tutto agosto valgono −309,39 € = l'85% della perdita**, sono **tutte e tre
   della stessa sedia** (`770101` DAX Apertura, modalita' vecchia) e sono
   **tutte e tre a −2,0% del conto contro l'1,0% dichiarato**. La controprova
   sul 100k dimostra che **l'EA calcola giusto**: e' la sedia del conto piccolo
   a girare a taglia doppia. 🔴 **E' una violazione della A4 congelata.**
4. **Il segno di E, onestamente: INDISTINGUIBILE DA ZERO.** Mediana
   dell'ingresso **0,00 €**, **49% di operazioni positive**, n=97 in 26 giorni.
   Non c'e' nessuna misura che dica che la flotta guadagna in forward — ma non
   c'e' piu' nemmeno il "bleeder" che il −0,091R faceva temere.

---

## 📐 METODO E CONVENZIONI (dichiarate prima dei numeri)

| voce | scelta |
|---|---|
| **fonte** | `data/statements/trades_auto.csv` (conto piccolo **50503392**) e `trades_100k.csv` (dry-run **50504263**), aggiornati 29/08, chiusure fino al **28/08 19:14** |
| **universo** | le **37 sedie di trading** del censimento `.chr` piu' fresco in repo (`censimento_rischio_2026-08-25_0731.txt`). Escluse le sedie assenti da quella foto (i "morti in osservazione", tutte con l'ultima chiusura fra il 27/07 e l'11/08) |
| **finestra primaria** | **03/08 → 28/08** (26 giorni, 22 giornate con chiusure). Finestra lunga **20/07 → 28/08** usata solo per il conteggio C3 per famiglia |
| **unita'** | **INGRESSO** = righe raggruppate per (magic, simbolo, `open_time`, lato): i parziali 1/3-2/3 contano **uno** |
| **netto** | `profit + commission + swap` |
| **R nominale** | rischio % dichiarato nel censimento × **saldo di riferimento 5.100 €** ⚠️ **[APPROSSIMATO]** — saldo agli atti 5.076,62 / 5.139,11 € (`PAGELLA_2026-08-19.md`). A 1% → **51,00 €** |
| 🔴 **limite dichiarato** | il contratto delle sedie (`CONTRATTI_SEDIE.md`) **NON contiene l'aspettativa per trade promessa**: contiene DD e op/mese. Il confronto (b) e' quindi fatto su **DD forward vs DD promesso** (la corsia RISCHIO, che e' quella firmata) e non su E vs E. **E' un buco del censimento M11 → richiesta in coda** |

---

## 🅐 IL −0,091R E' SISTEMICO O CONCENTRATO? — **CONCENTRATO, e di molto**

### La distribuzione dei 97 ingressi

| misura | valore | lettura |
|---|---:|---|
| netto totale | **−365,06 €** (−7,16% del conto) | il fatto da spiegare |
| media per ingresso | **−3,76 €** = −0,0738% = **−0,091R** | il numero del conflitto |
| **mediana per ingresso** | **0,00 €** | 🔴 **l'operazione TIPICA della flotta non perde: chiude a pari** (molti stop portati a breakeven) |
| ingressi positivi | **48 su 97 = 49%** | una moneta |
| **3 ingressi peggiori** | **−309,39 €** = **85% di tutta la perdita** | 👉 tutti e tre della **stessa sedia** |
| 3 ingressi migliori | +297,60 € | tre sedie **diverse** |

📌 **La media e la mediana raccontano due storie diverse, ed e' il punto**: una
mediana a **zero** con una media a **−3,76 €** significa che il segno negativo
**non viene dal corpo della distribuzione, viene dalla coda** — e la coda ha un
nome e cognome.

### La concentrazione per giorno

22 giornate con chiusure: **8 positive (+290,64 €)** e **14 negative
(−655,70 €)**, mediana giornaliera **−14,21 €**. Le **3 giornate peggiori**
(06/08 −102,96 · 10/08 −94,30 · 14/08 −93,22) valgono **−290,48 €**; le altre
19 giornate insieme fanno **−74,58 €**.

🔴 **E le tre giornate peggiori dell'estate SONO le tre operazioni peggiori**:
il 06/08, il 10/08 e il 14/08 la perdita del giorno **e' quasi interamente una
sola operazione** della `770101`.

### La prova del nove: togliere le due sedie imputate

| perimetro | n | netto | E per trade |
|---|---:|---:|---:|
| flotta viva intera | 97 | **−365,06 €** | **−0,0738%** (−0,091R) |
| **senza `770101` e `770611`** | **76** | **+22,97 €** | **+0,0059%** — **PIATTO** |

⚖️ **La controprova onesta, che indebolisce in parte la tesi e va scritta**: se
invece del taglio mirato si fa un **taglio simmetrico** (via i 3 ingressi
migliori **e** i 3 peggiori), la media resta **−3,88 € = −0,076%**. I due
risultati non si contraddicono — il taglio simmetrico toglie **tre vincite
legittime di tre sedie diverse** per togliere **tre perdite di una sedia sola**
— ma dicono che **il corpo della distribuzione non e' brillante**: e' lo zero,
non il verde.

---

## 🅑 CHI TRADISCE DI PIU'? — il confronto col contratto, corsia per corsia

### B1 — 🔴 LA SCOPERTA: `770101` gira a TAGLIA DOPPIA sul conto piccolo

Le tre perdite piene della DAX Apertura in agosto, righe grezze dallo statement:

| data | volume | prezzi | chiusura | netto | **% del conto** |
|---|---:|---|---|---:|---:|
| 06/08 | 0,90 | 26203,10 → 26088,70 | `sl` | −102,96 | **−2,02%** |
| 10/08 | 1,70 | 26313,00 → 26372,90 | `sl` | −101,83 | **−2,00%** |
| 14/08 | 2,00 | 26479,00 → 26426,70 | `sl` | −104,60 | **−2,05%** |

**Volumi diversi, distanze di stop diverse, stessa perdita in percentuale: e'
un sizing a rischio percentuale che funziona — puntato pero' su ~2,0%, non
sull'1,0% dichiarato nel censimento.**

🥇 **LA CONTROPROVA CHE CHIUDE IL CASO — lo STESSO trade sul 100k:**

| conto | rischio dichiarato | volume 14/08 | perdita | in % del conto |
|---|---:|---:|---:|---:|
| **100k** (dry-run prop) | 0,65% | **11,80** | −647,82 | **−0,648%** ✅ **esattamente 1R** |
| **piccolo** | 1,00% | **2,00** | −104,60 | **−2,05%** ❌ **2,05R** |

Rapporto dei volumi atteso se entrambi fossero corretti: 650 € ⁄ 51 € =
**12,75×**. Rapporto **reale**: 11,80 ⁄ 2,00 = **5,9×**. 👉 **Il conto piccolo
sta girando ~2,16 volte piu' grosso del dichiarato.**

**Conseguenze, tutte gia' agli atti come regole:**
- ✍️ **A4 e' CONGELATA** (18/08, FIRMA 4): _"nessuna sedia sopra l'1% sul conto
  piccolo, mai — una riga rossa e' una VIOLAZIONE, non una curiosita'"_.
  **Questa e' una riga rossa**, ed e' la sedia **piu' numerosa della flotta**.
- 🔎 **E il censimento `.chr` non l'ha vista**: legge `770101 … rischio 1`. Il
  campo dichiara 1, il campo **realizza** 2. 👉 **Non e' solo una sedia da
  correggere: e' lo strumento di verifica di A4 che ha un punto cieco.**
- 🛡️ **Tocca il cap C1**: il cap conta gli **SL vivi al rischio DICHIARATO**.
  Se una sedia vale il doppio, **5 SL "da 0,65%" non fanno 3,25%**. Il cap va
  ricontrollato contro il rischio **realizzato**, non contro l'input letto.

⚠️ **Cosa NON dice questa misura**: non dice **perche'**. Le ipotesi possibili
(input a 2% sul grafico · due istanze dello stesso magic su due grafici che
aprono insieme · conversione punti del DAX, cfr. **M23**) **non sono
distinguibili dallo statement**. Serve una **verifica sul VPS**, ed e' un
controllo, non una decisione.

### B2 — La DAX Apertura, scomposta per MODALITA' (e il terzo verdetto concorde)

`770101`, finestra 20/07 → 28/08:

| modalita' | conto piccolo | E per trade | conto 100k |
|---|---:|---:|---:|
| **BUY** (modalita' vecchia) | n=15 · **−266,60 €** (−5,23% del conto) | −0,348% | _non presente_ |
| **SELL** (modalita' vecchia) | n=8 · **−392,22 €** (−7,69%) | **−0,961%** | _non presente_ |
| 🟢 **RETEST** | n=8 · **+58,22 €** (+1,14%) | **+0,143%** | n=8 · **+92,58 €** ✅ |

👉 **Il 100k mirrorizza SOLO la modalita' RETEST — ed e' l'unica in verde su
ENTRAMBI i conti.** E' il **terzo verdetto indipendente e concorde**: 🥇 **R83**
(duello a criteri congelati: sul DAX vince il retest) + forward piccolo +
forward 100k. Le due modalita' vecchie, da sole, valgono **−658,82 €**: **piu'
di tutta la perdita della flotta**.

### B3 — Il DD forward per famiglia contro il DD promesso (**chiude in parte M20**)

Finestra 20/07 → 28/08, DD = massimo picco-valle della serie cumulata, in % di
5.100 €. **Soglia C3 (corsia MERITO) = 20 ingressi per famiglia.**

| famiglia | ing | netto € | E/trade | **DD fwd** | DD promesso (al rischio in campo) | corsia |
|---|---:|---:|---:|---:|---|---|
| **Aperture DAX** | **41** | **−689,02** | −16,81 | 🔴 **16,39%** | **6,25%** (R16, a 1%) | 🔴🔴 **RISCHIO SCATTATA — 2,6× il promesso** · **MERITO scattata** (≥20 e in perdita) |
| **ORB** | 25 | +167,19 | +6,69 | 6,48% | 9,92% (R15, a 1%) | 🟢 rischio dentro · merito attivo ma **positiva** _(⚠️ vedi B4: la sedia viva `770611` da sola e' negativa)_ |
| **SupertrendReversal** | 23 | −18,06 | −0,79 | 2,77% | 0,14-9,0% secondo la sedia | 🟡 **MERITO formalmente scattata** (≥20 e in perdita) — ma la perdita e' **−0,35% del conto**: e' un pareggio, non un'emorragia |
| SuperWave | 16 | −50,10 | −3,13 | 3,27% | 2,96-4,0% | ⚪ sotto 20 → merito sospeso |
| EMA200 indici/forex | 16 | +30,64 | +1,92 | 0,84% | 7,21% | ⚪ sotto 20 |
| MaxMinNotte | 11 | +188,21 | +17,11 | 2,10% | 1,27% / 10,0% | ⚪ sotto 20 |
| EMA200 oro | 11 | −110,49 | −10,04 | 3,26% | 11,5% (a 0,25%) | ⚪ sotto 20 |
| CostToCost | 8 | −121,24 | −15,15 | 3,04% | 8,0-10,4% | ⚪ sotto 20 |
| EasyTrend | 8 | +182,98 | +22,87 | 1,99% | 6,5-7,9% | ⚪ sotto 20 |
| PunteLarry | 5 | +79,25 | +15,85 | 1,03% | 3,9-9,0% | ⚪ sotto 20 |
| Aperture DOW · PTE · BreakingBand · GapContinuation | 4 · 3 · 2 · 1 | +0,35 · −4,15 · +20,75 · −51,90 | — | ≤1,02% | — | ⚪ campione muto |

⚠️ **Il limite del confronto, dichiarato**: un DD forward su 5-40 operazioni e'
**per costruzione piu' piccolo** di un DD di backtest su centinaia. Il test e'
quindi **asimmetrico e va letto solo in un verso**: _"non sfora"_ **non dice
niente**; _"sfora gia' adesso"_ e' un fatto grave. **La Aperture DAX sfora gia'
adesso, di 2,6 volte.**

### B4 — 🔴 `ORB 770611`: **0 vittorie su 10 operazioni, su DUE conti indipendenti**

| conto | n | vittorie | netto | % del conto | finestra |
|---|---:|---:|---:|---:|---|
| piccolo (1,0%) | 5 | **0** | −184,32 | −3,61% | 11/08 → 24/08 |
| 100k (0,3%) | 5 | **0** | −1.183,91 | −1,18% | 11/08 → 24/08 |

Il **+167,19 €** della famiglia ORB nella tabella B3 **non e' suo**: viene dal
`770601` (ORB nativo Nasdaq) **spento a inizio agosto**. La sedia viva, da
sola, e' **0/10**. Il DD forward (3,61%) resta **sotto** il promesso (9,92%):
la corsia RISCHIO **non** scatta. Ma il capitolo ORB era **gia' chiuso ai
banchi** (R7/R42/R43, 0/64 celle) e la `PAGELLA_SETT_2026-08-29.md` lo aveva
gia' indicato come _"candidato n.1 a revisione/spegnimento"_. **Questo e' il
secondo verdetto forward concorde.**

### B5 — 🧊 Gli altri 7 "sfori" apparenti: **6 spiegati, e uno dice una cosa nuova**

Confrontando la peggior perdita per ingresso col rischio dichiarato, otto sedie
sembravano sforare. Guardando **le date**:

- ✅ **Cinque sono spiegate dalla firma "A+b" del 24/08**: `772362` `772421`
  `772342` `772422` `772361` hanno perso oltre il nominale **con trade chiusi
  PRIMA della riduzione**. Ricalcolate al rischio di allora fanno
  **−1,04 · −0,97 · −1,03 · −1,02 · −1,00 R**. 👉 **La disciplina dello stop
  e' CONFERMATA, al centesimo**: quando la taglia e' quella giusta, uno stop
  pieno costa esattamente 1R.
- 🟠 **Due sono il LOTTO MINIMO**, ed e' un fatto strutturale nuovo:
  `971501` (EMA200 oro, dichiarata **0,25%**) perde **2,83× il nominale** e
  `770402` (MaxMin oro, **0,50%**) **1,37×** — entrambe girano a **0,01 lotti**,
  il minimo del broker. 🔴 **Su un conto da 5.100 € le riduzioni sotto ~0,5%
  su XAUUSD sono FINZIONE**: il pavimento del lotto minimo impone un rischio
  reale di **~0,7%** qualunque cosa dica l'input. **Sei sedie girano a 0,01
  lotti** (`971501` `770402` `772343` `770901` `772363` `970901`).
  👉 **Conseguenza per il piano: il conto piccolo non puo' piu' fare da banco
  di prova alle taglie ridotte.** E' un argomento in piu' per la **MOSSA 2**
  (migrazione sul 100k), dove 0,25% = 250 € e il lotto minimo non morde.
- 🔴 **Uno resta non spiegato: `770101`** → §B1.

---

## 🅒 SEPARARE PER QUALITA' DEL BANCO — **il test NON da' segnale, e lo dico**

| gruppo | definizione | n | netto | E/trade |
|---|---|---:|---:|---:|
| **G1** | banco a **TICK REALI** su finestra recente (R16 _"tick reali"_ + walk-forward su storico tick BCM) | 62 | −495,13 | **−0,157%** |
| **G2** | banco **nominale/misto** (2024.01→2026.06 dichiarato, ma i tick indici partono dal 26/09/2024) | 9 | −5,59 | −0,012% |
| **G3** | banco **OHLC lungo** (R99/R100/R103), **altro broker** (Gold Ichimoku) o **contratto contestato** (PTE vs R78) | 26 | +135,66 | **+0,102%** |

🔴 **Il risultato e' rovesciato rispetto all'attesa** (il banco migliore va
peggio) — e proprio per questo **non lo uso come conclusione**: G1 contiene
`770101` e `770611`, cioe' **le due sedie imputate**, e G3 e' trascinato da
**una singola operazione** (`772343` Larry oro, **+144,89 € con un solo
trade**). Tolte le due imputate, G1 fa **−0,051%** per trade e il quadro si
appiattisce come tutto il resto.

📌 **Verdetto onesto sul test (c): con 97 ingressi divisi in 62/9/26 e due o
tre operazioni che dominano ogni gruppo, la qualita' del banco NON e'
distinguibile nel forward. Il test si ripete quando le famiglie hanno un
campione, non adesso.**

🥇 **Ma un fatto di gerarchia esce lo stesso, e conta piu' del test**: il
**+0,091R del banco** non viene da un banco a tick. Viene dalla catena
**R103 → R105 → analisi dial**, e `R103_CRITERI.md` dichiara **modello 1 =
OHLC su M1 per tutte e 40** le sedie, con due avvertenze scritte dai suoi
stessi autori: _"l'OHLC non vede i percorsi dentro la barra: il rischio vero e'
peggiore"_ e _"sugli indici l'OHLC HA GIA' MENTITO"_ (SupRev DOW: **PF 2,77
OHLC → 0,79 a tick reali**). 👉 **Il conflitto di H7 non e' fra due misure
pari: e' fra un LIMITE SUPERIORE OHLC e un forward reale.**

---

## 🅓 IL VERDETTO — campione sottile o segnale vero?

### Tutte e due, e la riga di separazione e' netta

| domanda | risposta misurata |
|---|---|
| **Il campione basta per un verdetto di MERITO sulla flotta?** | 🔴 **NO.** 97 ingressi in 26 giorni, mediana **0,00 €**, 49% positivi. Il muro R59 (150 op) non e' avvicinato da nessuna famiglia; la soglia C3 (20 op) e' superata da **3 famiglie su 14**. **Il merito della flotta e' SOSPESO.** |
| **Il campione basta per la corsia RISCHIO?** | 🟢 **SI', e la corsia RISCHIO non ha soglia di campione** (C3, testo firmato: _"per sedia, sempre, a qualunque n"_). E ha **gia' morso**: DD Aperture DAX **16,39% contro 6,25% promesso**. |
| **E per un fatto di TAGLIA?** | 🟢 **SI'. Un solo trade basta**: tre stop pieni a −2,0% su una sedia dichiarata all'1,0%, con la controprova sul 100k che esclude l'errore di misura. **Non e' statistica, e' aritmetica.** |
| **Quindi il segno di E?** | 🟡 **INDISTINGUIBILE DA ZERO** per la flotta (+0,006% per trade tolte le due sedie imputate; −0,076% col taglio simmetrico: **lo zero sta in mezzo**). 🔴 **NEGATIVO e accertato** per `770101` modalita' vecchia e `770611`. |

### 🚦 Le sedie che vanno in revisione, secondo il criterio firmato il 18/08

| sedia / famiglia | corsia che scatta | il numero |
|---|---|---|
| 🔴 **`770101` Aperture DAX — modalita' BUY e SELL** | **RISCHIO** (per sedia, sempre) **+ MERITO** (famiglia ≥20 op in perdita) **+ violazione A4** | DD fwd **16,39%** vs **6,25%** promesso (**2,6×**) · BUY −266,60 e SELL −392,22 su 23 ingressi · **tre stop pieni a taglia doppia** |
| 🔴 **`770611` ORB** | **MERITO** (secondo verdetto forward concorde; il capitolo era gia' chiuso ai banchi) | **0 vittorie su 10** operazioni su **due conti indipendenti**; −3,61% e −1,18% |
| 🟡 **famiglia SupertrendReversal** | MERITO formalmente scattata (23 op, in perdita) | **−18,06 € = −0,35% del conto** su 23 operazioni: e' un **pareggio**. Proposta: **tagliando**, non spegnimento |
| 🟠 **le 6 sedie a lotto minimo** | nessuna corsia — e' un **difetto di banco** | le riduzioni firmate 23-24/08 **non sono attuabili** sul conto piccolo: rischio reale ~0,7% dove l'input dice 0,25-0,5% |

### ✅ E cio' che il forward CONFERMA (va detto: non e' tutto rosso)

- **La modalita' RETEST del DAX e' verde su tutti e tre i banchi** — R83
  (criteri congelati), forward piccolo (+58,22 su 8), forward 100k (+92,58 su 8).
- **La disciplina dello stop e' esatta**: dove la taglia e' quella dichiarata,
  uno stop pieno costa **1,00R** (cinque casi verificati al centesimo).
- **Il conto configurato PROP e' in utile**: 100k **+635,69 € (+0,64%)** in 19
  giorni, mentre le stesse 5 sedie sul piccolo fanno **−3,38%**. Stessa
  finestra, stessi motori: **4 sedie su 5 concordi nel segno**, e l'unica
  discorde e' `770101` — cioe' proprio la sedia col difetto di taglia e con la
  modalita' vecchia che il 100k **non copia**.

---

## 🧭 RACCOMANDAZIONE (dell'architetto-prop, dichiarata come tale — decide Claudio)

**MOSSA 1 NON e' finita finche' non si chiude questo controllo. In ordine:**

1. 🔴 **VERIFICA SUL VPS DELLA TAGLIA DELLA `770101`** — e' un **controllo, non
   una decisione**, ed e' la cosa piu' urgente del piano: aprire gli input del
   grafico DAX e leggere `InpRiskPercent`, e verificare che **non esistano due
   grafici con lo stesso magic**. Finche' non e' chiarito, **la MOSSA 2
   (migrazione) non va fatta**: migrare una sedia a taglia doppia moltiplica il
   difetto invece della portata.
2. 🟠 **Aperture DAX — proposta (non decisione): spegnere le modalita' BUY e
   SELL, tenere il RETEST.** E' la lettera della C3 (_"si spegne la SEDIA
   colpevole, la gemella positiva resta"_) applicata alle modalita', ed e'
   sostenuta da **tre banchi concordi**. Effetto sul periodo misurato: la
   famiglia passa da **−689,02 €** a **+58,22 €**.
3. 🟠 **`ORB 770611` — proposta: revisione con presunzione di spegnimento.**
   0/10 in forward su due conti + capitolo gia' chiuso ai banchi.
4. 🟢 **POI la MOSSA 2 (migrazione)** — e con due precisazioni che escono da
   qui: **(a)** si migra la modalita' **RETEST**, non quella vecchia; **(b)** il
   100k e' anche la **cura del lotto minimo** (a 100k lo 0,25% sono 250 €, e le
   taglie ridotte tornano reali).
5. 🔁 **Poi si rimisura E.** Con `770101` corretta, il RETEST al posto della
   vecchia e ORB fuori, la stima del periodo appena passato sarebbe **positiva**
   — ma sarebbe una **ricostruzione controfattuale, non una misura**. Il segno
   vero di E si dichiara **solo su forward nuovo**, con la flotta ferma.

⚠️ **E la cosa che questo referto NON autorizza**: non autorizza a dire che la
flotta guadagna. Dice che **non sta perdendo per mancanza di edge — sta
perdendo per due sedie identificate, una delle quali per un difetto di
configurazione.** E' una notizia migliore di un edge negativo, perche' un
difetto si corregge; ma **finche' non e' corretto e rimisurato, E resta APERTA**.

---

## 📥 RICHIESTE CHE NASCONO DA QUI

| # | cosa | a chi |
|---|---|---|
| **R1** | 🔴 verifica VPS `InpRiskPercent` della `770101` + ricerca di **doppi grafici sullo stesso magic** (e' anche il test del punto cieco del censimento) | **Claudio** |
| **R2** | il **censimento `.chr` deve incrociare il rischio DICHIARATO col rischio REALIZZATO** (perdita mediana degli stop pieni ÷ saldo): oggi legge solo l'input, e l'input ha mentito | chat principale / strumenti |
| **R3** | aggiungere ai contratti (`CONTRATTI_SEDIE.md`) la colonna **"aspettativa per trade promessa"** — senza, il confronto (b) di questo referto non si puo' fare sull'unita' giusta | chat principale |
| **R4** | ripetere questo referto **fra 4 settimane** con la flotta ferma: e' l'unica strada al segno vero di E | architetto-prop |

_Nessun EA, nessun parametro, nessun preset e' stato toccato: solo lettura e
conteggio. Ogni numero di questo file viene dai due CSV degli statement, dal
censimento `.chr` del 25/08 e dai contratti in `report/CONTRATTI_SEDIE.md`._
