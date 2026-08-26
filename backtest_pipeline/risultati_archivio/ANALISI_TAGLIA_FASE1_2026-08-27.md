# 📏 PROVA DELLA TAGLIA — FASE 1 (aritmetica sui dati GIA' misurati, zero tester)

_Cancello 6 del CANCELLO CHALLENGE (`report/PIANO_PROP.md` §CANCELLO 6),
27/08/2026. Domanda di Claudio: challenge FTMO **200k subito**, forse
**2×200k = tetto strategia $400k**. Le percentuali della flotta sono misurate
a **base 100k**; a taglia N i lotti scalano ×N/100k — **SE la scala e'
lineare**, e R109 ha gia' misurato che non sempre lo e'._

> ⚠️ **Cosa e' questa FASE 1 e cosa NON e'.** Solo aritmetica su volumi GIA'
> misurati negli artefatti del repo (per-trade R112, statement forward 100k e
> conto piccolo). **Nessuna corsa di tester e' stata fatta a 200k/400k**: i
> verdetti qui sotto sono PAVIMENTI del problema, non tetti — i massimi del
> 100k vengono da **2 settimane e 17 chiusure**. La misura vera e' la FASE 2.

## 🏷️ ETICHETTE E SOGLIE (dichiarate PRIMA dei numeri)

- **[MISURATO fonte]** = numero letto in un artefatto agli atti, fonte riga per riga.
- **[PROIETTATO scala lineare]** = lotto × (taglia target / taglia fonte) ×
  (dial target / dial fonte). **E' un'IPOTESI**: R109 ha misurato che la
  linearita' si rompe (tetto volume, slippage 21,5 pt).
- **[ASSUNTO DA VERIFICARE]** = valore standard non presente negli atti.
- 🚨 **Soglia di attenzione MARGINE: 20% del conto** per un ingresso pieno
  (soglia dichiarata qui, non firmata altrove).
- 🚨 **Soglia di attenzione VOLUME: 50% del `SYMBOL_VOLUME_MAX` noto**
  (soglia dichiarata qui).

---

## 0. 🧱 LE COSTANTI DEL CALCOLO — quasi tutte MISURATE, non assunte

### 0a. Valore del punto / contract size — **ricavati dai P&L veri di `data/statements/trades_auto.csv`** (profit ÷ (lotti × escursione), verificato su piu' trade per simbolo)

| strumento | valore misurato | contract size implicito | etichetta |
|---|---|---|---|
| D30EUR (DAX) | **1,000 €/punto/lotto esatto** (decine di trade, tutti a 1,000) | 1 × indice, in EUR | 🥇 [MISURATO trades_auto] |
| U30USD (Dow) | ~0,86-0,88 €/punto/lotto ≈ **1 $/punto** al cambio | 1 × indice, in USD | 🥇 [MISURATO trades_auto] |
| NASUSD (Nasdaq) | ~0,84-0,87 €/punto/lotto ≈ **1 $/punto** | 1 × indice, in USD | 🥇 [MISURATO trades_auto] |
| XAUUSD (oro) | ~85 €/$ per lotto ≈ **98 $/lotto per 1 $** → **≈100 oz/lotto** | 100 oz | 🥇 [MISURATO trades_auto, righe a 0,01 lotti] |
| EURUSD | ~86.500 €/lotto per unita' ≈ **100.000 di base** | 100.000 EUR | 🥇 [MISURATO trades_auto] |
| 225JPY (Nikkei) | 0,054 €/punto/lotto ≈ **10 JPY/punto** | nozionale ~3.800 €/lotto | 🟡 [MISURATO su UN SOLO trade, 19/08] |
| cambio EURUSD | **≈1,152** | — | 🥇 [MISURATO — implicito nei P&L, stesso numero di PIANO_PROP §4] |

### 0b. Prezzi usati (ultimo close forward per simbolo, da `trades_auto.csv`)

D30EUR **26.313** (26/08) · U30USD **53.519** (26/08) · NASUSD **30.080**
(17/08) · XAUUSD **4.595** (26/08) — 🥇 [MISURATO], ma sono istantanee:
il margine si muove col prezzo.

### 0c. Tetto di volume e leva

- **`SYMBOL_VOLUME_MAX` = 100** su **D30EUR, U30USD e NASUSD** — 🥇 [MISURATO
  `R109_INDAGINE_DEAL_2026-08-26.md` §6: frequenza al tetto contata su TUTTE
  e sei le celle dei tre simboli; su NASUSD short 66/743 = 8,9% dei trade
  TAGLIATI]. Su **XAUUSD, forex, F40EUR, 225JPY: NON MISURATO** — non agli
  atti, non lo invento.
- **Leva FTMO Swing**: **1:15 indici · 1:30 forex · metalli 1:9 O 1:15** —
  🟡 [LETTO-VIA-SEARCH, `DOSSIER_PROP_CANDIDATE_2026-08-26.md` §2 e §5-bis-D;
  sul metallo le due letture DIVERGONO (FAQ: 1:9; Trading Update 02/02/2026:
  1:15) → domanda scritta n.1]. Formula margine = lotti × contract × prezzo /
  leva, **margine sulla valuta base per il forex** [ASSUNTO DA VERIFICARE —
  convenzione standard]. Conto assunto in EUR [ASSUNTO DA VERIFICARE].
- **FTMO non vende un conto singolo sopra i $200.000** — 🟡 [LETTO-VIA-SEARCH,
  DOSSIER §5-bis-A]. Quindi "400k" = **2 conti da 200k** (esattamente al tetto
  $400k per trader/strategia): la colonna 400k qui sotto descrive un **conto
  singolo ipotetico** e serve da stress; su 2×200k ogni conto vede i numeri
  della colonna 200k, **due volte in parallelo**.

### 0d. 📐 Un fatto aritmetico che semplifica (e peggiora) tutto

**Il margine in % del conto e' INVARIANTE rispetto alla taglia** finche' la
scala e' lineare: margine% = lotti × prezzo / (leva × conto), e i lotti
crescono come il conto. → [PROIETTATO — proprieta' dell'ipotesi lineare]
**Conseguenza: i problemi di MARGINE qui sotto NON sono della taglia grande —
mordono identici a 100k.** Non li abbiamo mai visti solo perche' la leva del
demo BCM e' molto piu' larga di 1:15 (valore esatto BCM: NON AGLI ATTI).
La taglia grande aggiunge **solo** il problema del TETTO DI VOLUME (che e'
assoluto, 100 lotti, e non scala).

---

## 1. 📋 I VOLUMI MASSIMI PER SEDIA GIA' MISURATI — fonte, taglia e dial riga per riga

### 1a. Dry-run 100k (`data/statements/trades_100k.csv`, 10-26/08/2026 — 17 chiusure in tutto)

| sedia | magic | simbolo | dial | **vol max** | mediana | n | data del max |
|---|---|---|---|---:|---:|---:|---|
| Aperture DAX (`DAX_Apertura_EU`) | 770101 | D30EUR | 0,65% | **11,8** | 7,95 | 6 | 14/08 |
| MaxMinNotte DAX Short | 770411 | D30EUR | 0,65% | **17,9** | 16,45 | 4 | 26/08 |
| Aperture DOW (`Dow_Apertura_US`) | 770202 | U30USD | 0,65% | **4,7** | 4,55 | 2 | 13/08 |
| ORB (Dow) | 770611 | U30USD | **0,3%** ⚠️ | **14,2** | 5,0 | 5 | 24/08 |

🥇 [MISURATO]. Dial per sedia da `report/CONTRATTI_SEDIE.md` righe 81-84
("copie sul dry-run 100k": 0,65 — **tranne ORB a 0,3**). ⚠️ Il 14,2 di ORB e'
quasi **3× la sua mediana**: giorno a stop stretto — il lotto per-rischio
esplode quando lo stop si stringe, ed e' il meccanismo R109.

### 1b. Banco R112 (`R112_CORSA_20260826/pertrade_*.csv`, EMADOW = EMA200 U30USD, deposito 100k, tick reali)

| cella | dial | vol max **per DEAL** (colonna volume) | 🆕 vol max **per POSIZIONE** (somma dei deal della stessa `position_id`) | mediana per posizione |
|---|---|---:|---:|---:|
| 00_metro (sedia viva L+S) | 1% | 14,6 | **19,3** | 5,6 |
| 02_short r2 (bocciata R112) | 2% | 30,3 | — | — |
| 03_short r3 (bocciata R112) | 3% | 48,4 | **59,2** | — |

🥇 [MISURATO — CALCOLO DI QUESTO GIRO sui CSV per-trade]. ⚠️ **Il "vol max
14,6" del referto R112 e' per DEAL di uscita**: con TP1 al 50% + trailing ogni
posizione chiude in ~2 deal, quindi **il lotto APERTO (quello che occupa
margine) arriva a 19,3**. La sedia in campo (771531) gira a **0,65%**
(`R112_REFERTO.md` §verdetto) → a 100k: **19,3 × 0,65 = 12,5 lotti**
[PROIETTATO ×0,65].

### 1c. Conto piccolo (`data/statements/trades_auto.csv`, saldo ~5.100 € [INFERITO, PIANO_PROP §4 + DOVE_SIAMO 17/08], dial 1% salvo ridotte post-24/08)

| sedia | magic | simbolo | vol max | n | nota |
|---|---|---|---:|---:|---|
| Aperture DAX | 770101 | D30EUR | **2,70** (12/08) | 29 | stop implicito ≈ **19 punti** (1% di ~5,1k = ~52 € / 2,7 lotti) |
| MaxMinNotte DAX | 770401 | D30EUR | 2,50 | 2 | |
| Nightly | 771701 | EURUSD | **1,17** (23/07) | 6 | stop implicito ≈ **5 pip** |
| GapContinuation | 774101 | 225JPY | 2,00 | 1 | n=1: indicativo |
| sedie ORO (770901/771001/771501/971501/770402/…) | varie | XAUUSD | **0,01 = PAVIMENTO** | — | 🚫 NON scala: e' l'arrotondamento in giu' (rischio reale 0,52%, non 1% — 🥇 PIANO_PROP §4). Per l'oro si usa il lotto teorico a 100k: **0,32 @1%** [MISURATO PIANO_PROP §4, calcolo 03/08] → **0,21 @0,65%** [PROIETTATO] |

🥇 [MISURATO] salvo dove indicato.

### 1d. ⚠️ Il controllo incrociato che smaschera il campione corto

La stessa sedia Aperture DAX: max **11,8 lotti** sul 100k (6 trade, stop
~55 pt) ma **stop da 19 punti misurato** sul conto piccolo il 12/08. Quello
stesso giorno, a 100k@0,65%, il lotto sarebbe stato 650 € / 19,3 pt ≈
**~34 lotti** [PROIETTATO, doppio salto taglia+dial]. **Cioe': i massimi del
100k (2 settimane) sottostimano di ~3× i giorni a stop stretto.** Tutta la
tabella §2 va letta come pavimento.

---

## 2. 📈 PROIEZIONE A 200k / 400k vs TETTO DI VOLUME — [PROIETTATO scala lineare, IPOTESI DICHIARATA]

Base: colonna "a 100k" = vol max misurato (o convertito al dial di campo).
Tetto = 100 lotti [MISURATO su D30EUR/U30USD/NASUSD]. Soglia segnalazione: >50%.

| sedia | a 100k (dial) | **a 200k** | **a 400k** | % del tetto a 400k | verdetto volume |
|---|---:|---:|---:|---:|---|
| Aperture DAX 770101 | 11,8 (0,65%) | 23,6 | 47,2 | 47% | 🟡 sotto soglia **ma**: nei giorni a stop 19 pt il lotto proiettato e' **~68 a 200k e ~135 a 400k → TAPPATO** (§1d) |
| MaxMinNotte DAX 770411 | 17,9 (0,65%) | 35,8 | **71,6** | **72%** 🚨 | 🔴 oltre soglia a 400k |
| ORB Dow 770611 | 14,2 (0,3%) | 28,4 | **56,8** | **57%** 🚨 | 🔴 oltre soglia a 400k — e il max e' 3× la mediana: il prossimo giorno a stop stretto puo' tapparla anche a 200k |
| Aperture DOW 770202 | 4,7 (0,65%) | 9,4 | 18,8 | 19% | 🟢 (campione n=2) |
| EMADOW 771531 | 12,5 (0,65%, per posizione) | 25,1 | **50,2** | **50%** 🚨 | 🔴 esattamente in soglia a 400k — e i dial 2/3 bocciati da R112 avrebbero fatto 121/193 lotti = **OLTRE il tetto assoluto** |
| sedie ORO | 0,21 (0,65%) | 0,42 | 0,84 | tetto **NON MISURATO** | ⚪ non giudicabile sul volume |
| Nightly EURUSD 771701 | ~14,9 [PROIETTATO doppio salto §1c] | ~29,8 | ~59,7 | tetto **NON MISURATO** | ⚪ non giudicabile sul volume |
| GapContinuation 225JPY | ~26 [PROIETTATO, n=1] | ~51 | ~102 | tetto **NON MISURATO** | ⚪ |
| **le altre ~27 sedie della flotta** | **NESSUN volume agli atti a 100k** | — | — | — | ⚫ FASE 1 muta |

📌 Promemoria del precedente misurato: in R109 (motore bocciato, stessi
simboli, deposito 100k @1%) il tetto ha morso **davvero**: 66/743 trade
tagliati su NASUSD short, 12-20 per cella sugli altri — 🥇 [MISURATO
R109_INDAGINE §6]. Il meccanismo esiste; la flotta viva ci arriva a 400k.

---

## 3. 💰 IL MARGINE A LEVA FTMO SWING — il vincolo che NESSUNO ha mai guardato (e morde GIA' a 100k)

Margine per lotto [calcolato da §0, prezzi 26/08, cambio 1,152]:
D30EUR **1.754 €** · U30USD **3.097 €** · XAUUSD **44.321 €** (1:9) /
**26.592 €** (1:15) · EURUSD **3.333 €**.

### 3a. UN ingresso pieno, per sedia — % del conto (identica a 100k / 200k / 400k, §0d)

| sedia | lotti a 200k (max / mediana) | margine max | **% conto (max)** | % conto (mediana) | vs soglia 20% |
|---|---|---:|---:|---:|---|
| ORB Dow 770611 | 28,4 / 10,0 | 87.960 € | **44,0%** | 15,5% | 🔴🔴 — **e gira a dial 0,3: a parita' di stop, un eventuale ritorno a 1% farebbe ×3,3** |
| EMADOW 771531 | 25,1 / 7,3 | 77.739 € | **38,9%** | 11,3% | 🔴 |
| MaxMinNotte DAX 770411 | 35,8 / 32,9 | 62.801 € | **31,4%** | **28,9%** | 🔴 — qui anche la MEDIANA supera il 20%: non e' un giorno raro, e' il giorno tipico |
| Aperture DAX 770101 | 23,6 / 15,9 | 41.400 € | **20,7%** | 13,9% | 🟠 in soglia — e ~60% nei giorni a stop 19 pt [PROIETTATO §1d] |
| Nightly EURUSD 771701 (1:30) | ~29,8 [PROIETTATO doppio salto] | 99.333 € | **~49,7%** | — | 🔴 con incertezza ALTA dichiarata: da misurare prima di crederci |
| Aperture DOW 770202 | 9,4 / 9,1 | 29.113 € | 14,6% | 14,1% | 🟢 (n=2) |
| UNA sedia oro (1:9) | 0,42 | 18.615 € | 9,3% | — | 🟢 singola — **ma** la flotta ha ≥5 sedie oro: 3 aperte insieme ≈ **28%** (a 1:15: ≈17%) — e il precedente delle DUE posizioni oro insieme e' MISURATO (PIANO_PROP §4, 03/08) |
| GapContinuation 225JPY | ~51 [PROIETTATO, n=1] | ~13.000 € | ~6,5% | — | 🟢 indicativo |

### 3b. 🔥 Il cap C1 (5 SL vivi da 0,65% = 3,25% di rischio) — quanto MARGINE occupa

La simultaneita' non e' un'ipotesi: **il 13/08 ORB Dow e Aperture DOW erano
aperte INSIEME sul 100k** (15:05-15:17, righe del CSV) e il 03/08 il conto
piccolo ha avuto **9 posizioni di 8 sedie insieme** — 🥇 [MISURATO
trades_100k + `REFERTO_M2_SOVRAPPOSIZIONE.md`].

| scenario 5 ingressi indice (ApertDAX + MaxMin + ORB + ApertDOW + EMADOW) | margine totale | % del conto |
|---|---:|---:|
| tutti al **massimo misurato** | ~299.000 € su 200k | **🔴 149,5% — IMPOSSIBILE: il margine finisce prima del 4°-5° ingresso** |
| tutti alla **mediana** | ~167.400 € su 200k | **🔴 83,7% — il giorno TIPICO impegna 5/6 del conto** |

→ [PROIETTATO scala lineare, prezzi 26/08]. E il margine LIBERO deve anche
assorbire il flottante negativo dei 5 SL vivi. **Con leva 1:15 il vincolo che
morde per primo NON e' il cap di rischio C1: e' il margine.** Un ingresso
rifiutato per margine = una sedia che non fa il trade che il banco 100k
(leva BCM) le accredita → **la curva reale diverge dal banco in silenzio** —
esattamente il rischio che il cancello 6 esiste per misurare.

---

## 4. 🚦 TABELLA FINALE VERDE/GIALLO/ROSSO PER SEDIA

Criteri: 🔴 = margine 1 ingresso >20% del conto E/O volume >50% del tetto
alla taglia; 🟡 = vicino a soglia, o incertezza dominante; 🟢 = sotto
entrambe le soglie; ⚫ = nessun dato FASE 1.

| sedia | a 200k | a 400k (conto singolo ipotetico) | motivo in una riga |
|---|---|---|---|
| ORB Dow 770611 | 🔴 | 🔴 | margine 44% per UN ingresso (a dial 0,3!); volume 57% del tetto a 400k |
| MaxMinNotte DAX 770411 | 🔴 | 🔴 | margine 31% (mediana 29%!); volume 72% del tetto a 400k |
| EMADOW 771531 | 🔴 | 🔴 | margine 39%; volume al 50% del tetto a 400k |
| Aperture DAX 770101 | 🟡 | 🔴 | margine 20,7% al filo; nei giorni a stop stretto TAPPATA a 400k (~135 lotti richiesti) |
| Nightly EURUSD 771701 | 🟡 | 🟡 | margine proiettato ~50% MA con doppio salto dal conto piccolo: prima misurare, poi giudicare |
| Aperture DOW 770202 | 🟢 | 🟢 | 15% margine, 19% tetto — pero' n=2 |
| sedie ORO (famiglia) | 🟡 | 🟡 | singola 9,3% ok; cumulo 3 sedie ~28% a leva 1:9; leva 1:9/1:15 [INCERTO]; tetto volume NON MISURATO |
| GapContinuation 225JPY | 🟢 | 🟡 | nozionale piccolo (~6,5% margine) ma n=1 e contract da confermare |
| **le altre ~27 sedie** | ⚫ | ⚫ | **nessun volume misurato a 100k: la FASE 1 non puo' dire nulla** |
| **LA FLOTTA (cap C1, 5 SL vivi)** | 🔴 | 🔴 | **5 ingressi massimi = 149% del margine; mediani = 84%. A leva 1:15 il C1 non e' esercitabile com'e'** |

📌 **La frase da portare a Claudio:** il problema n.1 emerso dalla FASE 1
**non e' la taglia — e' la LEVA**. A 1:15/1:9 il margine morde uguale a 100k
e a 400k; la taglia grande aggiunge il tetto dei 100 lotti (3 sedie oltre il
50% a 400k, una tappata nei giorni a stop stretto). E **2×200k e' piu'
gentile di un 400k singolo** sul tetto volume (ogni conto vede i lotti del
200k) — ma raddoppia i conti da gestire ed e' esattamente al tetto strategia
$400k di FTMO.

---

## 5. 🧪 COSA LA FASE 1 NON PUO' DIRE — il mandato della FASE 2 (tester)

1. **Il margine con la leva VERA.** Tutti i banchi di casa girano con la leva
   demo BCM: nessuna corsa ha mai simulato 1:15/1:9/1:30. Nel tester MT5 la
   leva e' impostabile → **rifare le celle vive con deposito 200k (e 400k) e
   leva 1:15 indici**:
   - celle: Aperture DAX (cella live R46) · MaxMinNotte DAX · ORB Dow ·
     Aperture DOW · **EMADOW metro R112** (quest'ultima e' la migliore:
     grazie al G0-B di R112 il gemello 100k e' riproducibile al centesimo →
     il confronto 100k vs 200k e' pulito);
   - cosa guardare: **(a)** errori "not enough money"/margin call nel
     giornale; **(b)** trade a lotto TAPPATO (confronto lotto teorico da
     rischio vs lotto eseguito, e conteggio righe a 100 lotti); **(c)**
     deviazione % di profitto, DD, n e peggior giornata rispetto al gemello a
     100k — se non coincidono, le percentuali NON sono trasferibili (regola
     del cancello 6).
2. **`SYMBOL_VOLUME_MAX` (e `SYMBOL_VOLUME_LIMIT`) su oro, forex, F40EUR,
   225JPY**: sonda MQL5 sui simboli della flotta (come la sonda profondita'
   R102) — oggi il tetto e' noto solo sui 3 indici.
3. **I volumi delle altre ~27 sedie a 100k**: il dry-run ha 17 chiusure da 4
   sedie. Servono o piu' settimane di forward 100k o i per-trade CSV delle
   celle promosse (l'export di R112 e' il modello).
4. **Il margine col FLOTTANTE**: la FASE 2 misura il margine degli ingressi,
   ma il margin level scende anche col flottante negativo dei 5 SL vivi —
   guardare il margin level minimo nel giornale, non solo gli ingressi.
5. **Cio' che nemmeno la FASE 2 puo' dire**: lo slippage alla taglia (21,5 pt
   misurati su UNO stop a lotti 60-100, R109 §8 — il tester non modella il
   book) e i margin rate REALI del server FTMO (≠ leva conto, possono
   differire per simbolo e per orario) → domande scritte.

## 6. ✉️ LE DOMANDE DA FARE A FTMO PER ISCRITTO (prima di qualunque euro)

1. **Leva/margin rate esatti PER STRUMENTO sul conto Swing 200k**: XAUUSD e'
   1:9 o 1:15? (le vostre FAQ e il Trading Update del 02/02/2026 dicono due
   numeri diversi). US30/GER40/NAS100 sono tutti 1:15? Il margin rate cambia
   con la taglia del conto?
2. **Margine intraday vs overnight/weekend**: i requisiti di margine
   aumentano di notte o sul weekend sul conto Swing? E quali sono **margin
   call e stop-out level** (a che margin level % chiudete le posizioni, e in
   che ordine)?
3. **Limiti di volume**: qual e' il volume massimo per ORDINE e per SIMBOLO
   (US30, GER40, NAS100, XAUUSD) sul server FTMO a 200k? Esiste un tetto di
   esposizione nozionale per conto?

_(Restano in coda le due domande D3 gia' agli atti nel
`DOSSIER_PROP_CANDIDATE_2026-08-26.md`: clausola gap-trading vs famiglia
GapFill, e one-sided bets vs sedie mono-direzione.)_

---

_FASE 1 chiusa il 27/08/2026 — solo aritmetica, zero tester, nessun numero
nudo. Prossimo passo: FASE 2 §5, poi il cancello 6 si giudica sui numeri
nuovi, non su questa estrapolazione._
