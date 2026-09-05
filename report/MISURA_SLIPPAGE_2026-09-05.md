# 📏 MISURA DELLA DISTRIBUZIONE DELLO SLIPPAGE — P7 pagata (in parte)

**Data: 05/09/2026.** Risposta alla proposta **P7** del dossier
`backtest_pipeline/caccia_strategie/CONFIG_PROP_SPREAD_SLIPPAGE_2026-09-05.md`
(riga 641), che diceva: _"Oggi abbiamo UN numero (21,5 punti, un evento, R109).
Non e' una misura, e' un aneddoto."_

> 🛑 **Questo referto non tocca niente.** Nessun EA, nessun preset, nessun
> conto, nessun forward. Porta **misure** e **una proposta di fix dichiarata e
> NON applicata**. Decide Claudio.

---

## 0. 🥇 LA RIGA CHE RESTA

> **Lo slippage sugli stop NON e' un numero: sono DUE mondi.**
>
> **In sessione** e' piccolo e prevedibile: mediana **0,4 punti indice**,
> P95 **3,3**, massimo **25,8** su 484 stop misurati (D30EUR).
> **Fuori sessione** e' un altro pianeta: P95 **92,7**, massimo **294,4**
> su 67 stop.
>
> **Il 12% degli stop (quelli fuori sessione) porta il 58% del costo totale
> dello slippage.** Non e' una coda: e' un orario.
>
> 🔴 **E il 21,5 di R109, su cui il dossier ha costruito la priorita' del
> mandato, e' il PERCENTILE 98,6 della distribuzione — 99,8 se si guarda la
> sola sessione.** Non e' il costo che paghiamo di solito: e' l'evento raro.
> Questo **non** annulla il mandato (l'evento raro e' quello che brucia una
> challenge), ma **cambia quale numero si usa per tarare cosa**.

---

## 1. ⛔ CONTROLLO POSITIVO — il canale risponde, e c'e' una prova che lo dimostra

Regola di casa: prima di misurare, si verifica che lo strumento veda.

**Il canale.** Stesso di `R109_INDAGINE_DEAL_2026-08-26.md`: la tabella
**`Affari`** (Deals — il report del tester e' in italiano) dei report `.htm`
dello Strategy Tester. Su ogni deal di uscita ci sono, **sulla stessa riga**:

| colonna | contiene |
|---|---|
| `Prezzo` | il prezzo **REALMENTE ESEGUITO** |
| `Commento` | `sl <livello>` oppure `tp <livello>` = il **LIVELLO RICHIESTO** |

Esempio letterale, prima riga del report D30EUR:
```
2024.09.30 09:01:53 | aff 3 | D30EUR | sell | out | 51.2 | 19394.40 | ... | sl 19396.20
                                              eseguito ^^^^^^^^         richiesto ^^^^^^^^
                                              scarto = 1,80 punti indice, SFAVOREVOLE
```

**Il controllo positivo, ed e' bello perche' non poteva uscire per caso:**
il parser misura con la **stessa formula** anche i **take profit**. Se il segno
o la formula fossero sbagliati, i TP uscirebbero a caso. Invece:

| | n | mediana | P95 | max | % riempiti PEGGIO del livello |
|---|---:|---:|---:|---:|---:|
| **stop loss** | 638 | +0,50 | +3,82 | **+294,40** | **81%** |
| **take profit** | 283 | **−0,40** | 0,00 | **0,00** | **0%** |

> 🎯 **Zero TP su 283 sono stati riempiti peggio del livello. 81% degli SL si'.**
> La formula e' giusta e l'asimmetria e' reale: **gli stop scivolano contro di
> noi, i take non scivolano mai a favore del broker.** E' il termine che si
> mangia l'aspettativa e che nessun backtest "ottimista" mostra.

**Secondo controllo positivo — contro numeri gia' pubblicati in casa.**
`R109_INDAGINE_DEAL_2026-08-26.md` §7 (oss. 8) aveva calcolato **a mano** due
scivolate, su un lato **short** (formula opposta a quella dei long qui sopra).
La formula del parser, applicata a quelle stesse righe:

| riga (dal referto del 26/08) | livello | eseguito | parser | referto 26/08 |
|---|---:|---:|---:|---:|
| NASUSD short 2025.06.06 | 21 660,10 | 21 681,60 | **+21,50** | _"21,5 punti indice oltre"_ ✅ |
| D30EUR short 2026.05.13 | 24 178,20 | 24 186,80 | **+8,60** | _"8,6 punti"_ ✅ |

> ✅ **Coincide al centesimo su entrambi i lati.** Il segno e' giusto anche
> sugli short, che nel campione di oggi sono quasi assenti. (Nota: quei due
> `.htm` **non sono in repo** — le righe sono citate dal referto del 26/08,
> quindi qui e' una verifica della **formula**, non un dato nuovo.)

---

## 2. 📦 I DATI: cosa c'e' gia' in casa, cosa NO (la domanda n.2 del mandato)

### 2.1 ❌ I CSV per-trade NON bastano — verificato su tutti

Auditati **tutti** i file `pertrade*.csv` / `abtg_trades_*.csv` in
`backtest_pipeline/risultati_archivio/` e `risultati_prove/`: **hanno tutti la
stessa identica intestazione**, senza eccezioni:

```
close_time;symbol;magic;position_id;deal_type;volume;price;net_profit
```

`price` e' il prezzo **ESEGUITO**. **Il livello RICHIESTO non c'e'.**
👉 **Con questi file lo slippage NON e' calcolabile.** Il dossier diceva
_"i dati sono gia' negli zip dei round"_: **e' vero solo per i `.htm`, non per
i CSV per-trade.** Vale la pena metterlo agli atti perche' cambia il costo
della cosa.

### 2.2 ✅ I `.htm` bastano — ma in repo ce ne sono solo TRE

Cercati in tutta la storia di git (`git log --all -- '*.htm'`): **3 file, e
basta.** Gli zip completi delle corse stanno sul PC di backtest di Claudio,
non qui.

| file | expert | simbolo | periodo | modello | uscite misurabili |
|---|---|---|---|---|---:|
| `risultati_archivio/R109_deal_anomali/D30EUR_00_long_report_singola.htm` | `ABTG_AtrExhaustVol` | **D30EUR long** | 2024.09.26 → 2026.08.21 | 34,4 M tick reali | **551 SL + 267 TP** |
| `risultati_prove/v21_esterno/V21_IS.htm` | `NasdaqOpeningBreakout_v21_OPT` | **NASUSD** | 2024.09.26 → 2025.06.09 | 61,0 M tick reali | 25 SL + 7 TP |
| `risultati_prove/v21_esterno/V21_OOS.htm` | idem | **NASUSD** | 2025.06.10 → 2026.06.30 | 94,4 M tick reali | 62 SL + 9 TP |

**Totale misurato oggi: 638 stop loss + 283 take profit = 921 uscite.**
Non e' un aneddoto: e' un campione.

### 2.3 🔴 E il buco che vale di piu': il FORWARD VIVO ha gia' 720 stop, e non li sappiamo leggere

`data/statements/trades_auto.csv` — l'export di `ABTG_TradeExporter` dal conto
demo, **30/03/2026 → 04/09/2026**, 1280 posizioni chiuse:

```
close_reason:  sl 720 · tp 389 · mobile 101 · manuale 44 · expert 20 · stopout 6
sl per simbolo: XAUUSD 340 · D30EUR 134 · U30USD 61 · NASUSD 44 · GBPUSD 10 · ...
```
(e `trades_100k.csv`: altri 25 SL su D30EUR/U30USD/225JPY dal 10/08).

> 🚨 **SETTECENTOVENTI stop reali, su conto vero, cinque mesi di forward — e
> non possiamo misurarne lo slippage, perche' l'exporter scrive `close_price`
> (eseguito) ma NON il livello di stop richiesto.**
> Questo e' **lo slippage VERO** (esecuzione del broker), non quello del
> tester. E' il dato che serve, ce l'abbiamo sotto il naso, e ci manca **una
> colonna**. Vedi §5.

---

## 3. 📊 LA MISURA — punti INDICE, ora SERVER

Conversione di casa **MISURATA**: **1 punto indice = 100 punti MT5**
(`mql5/Scripts/ABTG_SpreadOrario.mq5:57`, valida sui tre indici).
Segno: **>0 = riempito PEGGIO del livello richiesto** (sfavorevole).

### 3.1 🥇 La tabella che decide — SESSIONE contro NOTTE

**D30EUR, 551 stop, 23 mesi a tick reali:**

| fascia (ora server) | n | mediana | P90 | P95 | P99 | **max** | media |
|---|---:|---:|---:|---:|---:|---:|---:|
| **IN SESSIONE 07-20** | **484** | **0,40** | 2,30 | **3,25** | 8,25 | **25,80** | 0,91 |
| **FUORI SESSIONE 21-06** | **67** | 0,40 | **45,98** | **92,68** | 175,86 | **294,40** | **14,44** |
| tutte le ore (media che non descrive nessuno) | 551 | 0,40 | 2,50 | 4,05 | 62,30 | 294,40 | 2,56 |

> 🔴 **La riga "tutte le ore" e' esattamente il tipo di media che il progetto
> ha imparato a non usare** (Emendamento C, 16/08: _"sei anni brutti + dieci
> buoni fanno una media che non descrive nessun mercato"_). Qui: **un P95 di
> 4,05 che non e' ne' quello della sessione (3,25) ne' quello della notte
> (92,68).** Lo slippage si legge **per ora**, come lo spread dal 03/09.

**Il costo in euro** (contract size D30EUR verificato sui dati: 1 lotto ×
1 punto indice = 1 EUR):

| | stop | costo slippage | quota |
|---|---:|---:|---:|
| in sessione 07-20 | 484 (87,8%) | 8 862 EUR | 42% |
| **fuori sessione 21-06** | **67 (12,2%)** | **12 098 EUR** | **58%** |
| **totale** | **551** | **20 959 EUR** | 100% |

Su 481 216 EUR di perdite totali di quei 551 stop, **lo slippage vale il 4,4%**.
Ma e' concentrato: **il 12% degli stop porta il 58% del costo.**

### 3.2 NASUSD all'ora dell'apertura USA — n=87

`NasdaqOpeningBreakout_v21`, IS+OOS, 2024.09 → 2026.06, **tutti all'ora 14
server** (= 15:30 IT, l'apertura cash USA: la stessa ora in cui lavorano le
nostre sedie Nasdaq).

| | n | mediana | P90 | P95 | P99 | max | % sfav |
|---|---:|---:|---:|---:|---:|---:|---:|
| **NASUSD h14** | **87** | **1,00** | 1,94 | **2,27** | 3,51 | **3,60** | **94%** |

> 🟢 **Nell'ora piu' violenta della giornata USA, su 87 stop, lo slippage
> massimo e' 3,6 punti indice.** Mediana 1,0 — cioe' **meno dello spread
> mediano dell'ora (1,6-1,8)**. Il 94% scivola, ma di pochissimo.
> ⚠️ Campione di **un solo motore**, e con stop non strettissimi: vedi §4.

### 3.3 Il dettaglio orario D30EUR (dove sta la coda, ora per ora)

| ora server | n | mediana | max | costo EUR |
|---:|---:|---:|---:|---:|
| **00** | 11 | 0,90 | **294,40** | **6 477** |
| **01** | 13 | **2,70** | **114,80** | **3 284** |
| 02 | 11 | 0,30 | 18,80 | 535 |
| 03-06 | 27 | 0,20-1,00 | ≤5,80 | 405 |
| 07 | 41 | 0,40 | 6,50 | 1 339 |
| **08** | **102** | 0,50 | 8,50 | 2 119 |
| **09** | **102** | 0,40 | 5,70 | 1 781 |
| 10 | 46 | 0,40 | 3,80 | 652 |
| 11 | 28 | 0,90 | 5,70 | 503 |
| 12 | 19 | 0,40 | 8,20 | 240 |
| 13 | 9 | 0,70 | 2,30 | 110 |
| 14 | 22 | 0,30 | 12,80 | 316 |
| 15 | 42 | 0,35 | **25,80** | 811 |
| 16 | 33 | 0,30 | 4,00 | 478 |
| 17-20 | 40 | 0,30-1,10 | ≤4,10 | 514 |
| 21 | 1 | 0,00 | 0,00 | 0 |
| **23** | **4** | **38,75** | **79,80** | **1 397** |

🚩 **Le ore 23-00-01 hanno mediane e massimi fuori scala.** E la firma e'
inequivocabile: **le scivolate ≥15 punti cadono tutte su pochi orari esatti e
RICORRENTI** — `00:05:15` ×3, `23:05:15` ×2, `01:16:00` ×2, `00:00:00` ×2.
Lo stesso secondo, anni diversi. **[INFERITO, non provato]**: e' il **primo
tick dopo l'interruzione di quotazione** — cioe' **gap di riapertura**, non
esecuzione lenta. **[VERIFICATO in casa, controprova indipendente]** la misura
dello spread del 03/09 dice la stessa cosa dall'altro lato:
_"D30EUR NOTTE 3,5-3,9 (piu' del doppio)"_ e _"U30USD ora 23: P95 7,0, **max
101 punti indice**"_ (`SPREAD_FLOTTA_MISURA_2026-09-03.md` §2).
**Due misure indipendenti, stesso orario, stessa diagnosi.**

### 3.4 Le dieci peggiori — con il conto in euro davanti

```
2025.02.03 00:05:15  sl 21558.80 -> 21264.40   294.40 pti   vol 12.1   perdita -4617.36
2025.04.22 01:16:14  sl 21142.20 -> 21027.40   114.80 pti   vol 11.8   perdita -2350.56
2026.01.19 00:05:15  sl 25197.90 -> 25096.20   101.70 pti   vol 11.1   perdita -1862.58
2026.01.26 00:05:15  sl 24787.30 -> 24689.10    98.20 pti   vol 10.7   perdita -1721.63
2025.06.22 23:05:15  sl 23243.40 -> 23163.60    79.80 pti   vol  8.1   perdita -1645.11
2025.07.13 23:05:15  sl 24162.20 -> 24085.50    76.70 pti   vol  9.6   perdita -1713.60
2026.03.12 00:00:00  sl 23540.10 -> 23492.20    47.90 pti   vol  5.0   perdita  -863.00
2025.06.17 00:00:00  sl 23546.20 -> 23501.50    44.70 pti   vol  9.6   perdita -1504.32
2026.07.13 15:16:45  sl 25046.90 -> 25021.10    25.80 pti   vol  8.7   perdita  -839.55   <-- unica IN sessione
2025.08.26 01:16:00  sl 24259.50 -> 24239.30    20.20 pti   vol 43.4   perdita -1896.58
```
**Nove su dieci sono fuori sessione. Una sola in sessione, ed e' la nona.**

---

## 4. 🕳️ COSA QUESTA MISURA **NON** DICE — i limiti, senza sconti

1. 🔴 **E' slippage DEL TESTER, non del broker.** Il tester a tick reali chiude
   lo stop al **primo tick che attraversa il livello**: quello che misuriamo e'
   il **gap fra tick**, non la coda di esecuzione (latenza, coda dell'ordine,
   riprezzatura). **E' un PAVIMENTO: sul reale lo slippage puo' solo essere
   ≥ a questo.** Il dossier lo diceva gia' del 21,5 (§4, D6): _"il nostro unico
   slippage misurato viene da un backtest a tick reali, non dalla demo"_.
   👉 **Chi chiude questo buco e' il §5, non un altro backtest.**
2. 🔴 **Due simboli su tre. Il DOW (U30USD) NON e' misurato**, e proprio il Dow
   e' il simbolo che nella misura dello spread ha la coda peggiore (max 101 a
   ora 23). Manca perche' in repo non c'e' il suo `.htm`.
3. 🔴 **Un solo lato su D30EUR** (long). Lo short non e' misurato — e la
   **regola dei due lati del 25/08** dice che si misurano sempre entrambi.
4. ⚠️ **Un motore per simbolo.** Lo slippage sugli stop dipende anche
   dall'EA: `ABTG_AtrExhaustVol` ha **stop molto stretti**
   (`R109_INDAGINE_DEAL` §7, oss. 7) e lotti da 5-100, quindi si fa stoppare
   piu' spesso **dentro** le fiammate. Un motore con stop larghi vedrebbe
   un'altra distribuzione. **La distribuzione e' del motore quanto del
   simbolo.**
5. ⚠️ **L'ora e' quella SERVER** (i report del tester sono in ora server).
   Coerente con la regola di casa; non confondere con i log MT5 (ora locale).
6. ⚠️ **Slippage in INGRESSO non misurabile** da qui: gli ordini di apertura
   sono a mercato, e il report scrive `Prezzo = 0.00` sull'ordine. Non c'e' un
   prezzo richiesto con cui confrontare. Servirebbe che l'EA registrasse il
   prezzo visto al momento della decisione.
7. ⚠️ **`Modello di prezzo`**: i tre report sono a tick reali (34-94 M tick),
   ma la **profondita' tick** di D30EUR non e' stata riverificata qui (riserva
   gia' aperta in `R109_INDAGINE_DEAL` §8).

---

## 5. 🔧 IL FIX MINIMO PER MISURARE QUELLO VERO — dichiarato, **NON applicato**

> 🛑 **`ABTG_TradeExporter` E' VIVO SUL VPS** (grafico `NZDCADH1`,
> `FLOTTA_ATTIVA.md`). **Non l'ho toccato.** Qui c'e' la proposta, come da
> mandato. La applica Claudio, con revisione.

### 5.1 Cosa manca, esattamente

`mql5/Experts/ABTG_TradeExporter.mq5`, righe **163-170**: sul deal di
**uscita** l'exporter legge ora, prezzo, simbolo e `DEAL_REASON` (che gia'
distingue `sl` / `tp` / `expert` / `stopout`) — **ma NON legge
`DEAL_COMMENT`.** Il commento lo legge solo sul deal di **ingresso**
(riga 158), dove serve per la firma della strategia.

**E' proprio nel commento dell'uscita che MT5 scrive `sl <livello>`.**
Una lettura in piu' e una colonna in piu'.

### 5.2 La modifica (≈8 righe)

Nella struttura `PRec`, due campi nuovi:
```mql5
   string   ccomment;   // commento del deal di USCITA: MT5 ci scrive "sl 19396.20"
   double   clevel;     // livello RICHIESTO estratto dal commento (0 se assente)
```

Nel ramo di chiusura (dopo la riga 168, `recs[idx].creason = ...`):
```mql5
      //  Lo SLIPPAGE si misura solo se sulla stessa riga ci sono il livello
      //  RICHIESTO e il prezzo ESEGUITO. Il prezzo eseguito c'e' gia'
      //  (cprice); il livello richiesto sta SOLO qui, nel commento che MT5
      //  scrive sul deal di uscita: "sl 19396.20" / "tp 19454.70".
      //  Senza questa riga i 720 stop del forward 30/03-04/09/2026 restano
      //  non misurabili (MISURA_SLIPPAGE_2026-09-05.md par. 2.3).
      recs[idx].ccomment = HistoryDealGetString(tk, DEAL_COMMENT);
      recs[idx].clevel   = LivelloDaCommento(recs[idx].ccomment);
```

Piu' una funzione di due righe:
```mql5
//  "sl 19396.20" -> 19396.20 ; "tp 1.23456" -> 1.23456 ; qualunque altro -> 0
double LivelloDaCommento(const string c)
  {
   string s = c; StringTrimLeft(s); StringTrimRight(s);
   string lo = s; StringToLower(lo);
   if(StringSubstr(lo,0,3)!="sl " && StringSubstr(lo,0,3)!="tp ") return(0.0);
   return(StringToDouble(StringSubstr(s,3)));
  }
```

E **due colonne** in coda all'intestazione e alla `FileWrite` (in coda, cosi'
**nessun parser esistente si rompe**):
```
... ;session_high;session_low;close_comment;close_level_req
```

### 5.3 ⛔ Il controllo positivo da fare PRIMA di fidarsi (e' la parte importante)

> 🔴 **NON e' garantito che BCM scriva il livello nel commento sul REALE.**
> Nel **tester** lo fa (verificato: 921 uscite su 921 hanno il numero). Sul
> conto vero il commento lo compila il **server del broker**: molti scrivono
> solo `sl`, senza prezzo.

**Come si chiude in 5 minuti, senza rischio:** applicato il fix, si esegue
l'exporter **una volta sola** sulla storia gia' presente nel terminale
(`HistorySelect` la rilegge tutta: **non serve aspettare nuovi trade**, i 720
stop di 5 mesi sono gia' li'). Poi si conta:

- **se `close_level_req` > 0 su una buona quota dei 720** → 🥇 **abbiamo la
  distribuzione dello slippage REALE, retroattiva, di 5 mesi, gratis.**
- **se e' 0 su tutti** → il broker non scrive il livello, e allora serve la
  **strada B**: un logger che campiona `PositionGetDouble(POSITION_SL)` sulle
  posizioni aperte e lo scrive; quando la posizione sparisce si confronta
  l'ultimo SL noto col prezzo di chiusura. **Piu' invasivo, da preparare solo
  se la strada A fallisce.** Per questo la strada A si prova per prima.

**Nessuna riga di lancio nuova in questo referto.** Il fix e' un `.mq5` da
compilare e uno script da eseguire a mano: se Claudio lo approva, la pagina di
lancio si scrive allora, e **passera' dal verificatore-stringhe** come da
regola di casa.

---

## 6. 🎯 COSA CAMBIA NELLE PROPOSTE DEL DOSSIER

### P6 (pavimento di stop) — la premessa va CORRETTA, e in meglio

Il dossier (§P6, e §1.4) dice: _"`InpMinStopPts = 500` sul Dow (5,0 punti
indice) contro uno slippage misurato di 21,5. Il pavimento e' 4,3 volte PIU'
PICCOLO dello slippage osservato."_

**Con la distribuzione davanti, quel confronto e' fra un pavimento e un evento
di coda.** I fatti misurati:

| | valore | il pavimento 5,0 pti indice dove cade |
|---|---:|---|
| slippage mediano in sessione (D30EUR) | 0,40 | **12× piu' largo del tipico** |
| P95 in sessione (D30EUR) | 3,25 | **1,5× piu' largo del P95** |
| P99 in sessione (D30EUR) | 8,25 | 🟡 **piu' stretto del P99** |
| max in sessione (D30EUR, 484 stop) | 25,80 | 🔴 5× piu' stretto del max |
| P95 NASUSD h14 (87 stop) | 2,27 | 2,2× piu' largo del P95 |
| **il 21,5 di R109** | **percentile 98,6 (99,8 in sessione)** | — |

> 🥇 **Il pavimento di 5,0 punti indice NON e' fuori scala: e' fra il P95 e il
> P99 dello slippage misurato in sessione.** Il dossier lo dava per
> "4,3 volte troppo piccolo" perche' lo confrontava con un evento al
> percentile 98,6. **P6 non e' urgente come sembrava.**
>
> ⚠️ **Ma resta vero su un punto**: contro le code **fuori sessione** (P95
> 92,7) nessun pavimento ragionevole protegge. **La difesa contro quella coda
> non e' un pavimento piu' alto: e' non avere posizioni aperte in quelle ore**,
> oppure metterlo in conto come costo strutturale.
> 🔴 **Questo riguarda direttamente `ABTG_MaxMinNotte`** (D30EUR M15, sedia
> viva 770411) e ogni sedia che tiene posizioni oltre le 21 server.

### P3 (filtro spread coi P95) — non e' toccata, e prende un rinforzo
Il filtro spread lavora su un numero da 1,6 a 3,0 punti indice. Lo slippage in
sessione ha mediana 0,4-1,0. **Sono grandezze dello stesso ordine**: nessuna
delle due, da sola, e' "il problema". **La coda notturna e' un ordine di
grandezza sopra entrambe** (92,7 al P95). Se una sola cosa merita un filtro,
e' **l'ORA**, non lo spread.

### P7 — **pagata al 60%.** Restano fuori:
il DOW, il lato short del DAX, e soprattutto **lo slippage REALE del broker**
(§5). Il metro pero' adesso esiste ed e' riutilizzabile.

---

## 7. 🧰 LO STRUMENTO (riutilizzabile, gia' in repo)

`backtest_pipeline/misura_slippage.py` — parser Python, nessuna dipendenza.

```bash
python3 backtest_pipeline/misura_slippage.py <cartella_con_gli_htm> --csv dettaglio.csv
python3 backtest_pipeline/misura_slippage.py --auto          # cerca in tutto il repo
```

Legge i `.htm` del tester (UTF-16), estrae ogni uscita con livello richiesto e
prezzo eseguito, e stampa: mediana/P90/P95/P99/max **per simbolo, per lato,
per ora server**, il controllo positivo sui TP, e le dieci peggiori scivolate.

> 🥇 **Serve solo che Claudio ci punti addosso gli zip delle corse passate.**
> Il costo di questa misura, per ogni round futuro, e' **zero**: i `.htm` li
> produce gia' il tester. Va aggiunto agli artefatti che si archiviano.
>
> 🛡️ **Una nota di igiene, ereditata da R109:** il parser **NON ordina** i
> deal. Li legge nell'ordine nativo del file (= ordine di ticket, cronologico
> e senza pari). E' esattamente il `Sort-Object` su chiave con pari che nel
> driver R109 aveva prodotto 34 false anomalie
> (`R109_INDAGINE_DEAL_2026-08-26.md` §5). Qui ogni riga e' autosufficiente:
> l'ordine non serve, e quindi non si ordina.

**Artefatti di questa corsa** (numeri riproducibili riga per riga):
- `backtest_pipeline/risultati_archivio/slippage_20260905/slippage_dettaglio_2026-09-05.csv` — 921 uscite
- `backtest_pipeline/risultati_archivio/slippage_20260905/REFERTO_PARSER_2026-09-05.txt` — uscita grezza

---

## 8. 📌 LE TRE COSE DA FARE, IN ORDINE DI RESA/COSTO

| # | cosa | costo | resa |
|---|---|---|---|
| **1** | 🥇 **Fix di `ABTG_TradeExporter` (§5) + una corsa sulla storia gia' presente** | ~1 h + 5 min | **720 stop REALI di 5 mesi, retroattivi.** E' l'unico modo di sapere se lo slippage del broker e' piu' grande del gap del tester. Se il controllo positivo (§5.3) va male, si sa subito e si passa alla strada B |
| **2** | 🥈 **Puntare `misura_slippage.py` sugli zip dei round passati** (Dow, lato short, altri motori) | ~20 min di Claudio (mandare gli `.htm`) | chiude i buchi 2 e 3 del §4 con dati **gia' esistenti**, zero backtest nuovi |
| **3** | 🥉 **Portare l'ORA nella discussione dei costi**, non solo lo spread | decisione | il 58% del costo dello slippage sta nel 12% degli stop, ed e' un **orario**. Riguarda `MaxMinNotte` e ogni sedia con posizioni oltre le 21 server |

> ⚠️ **Nessuna di queste tocca un conto vivo.** La 1 modifica un EA che gira
> sul VPS: **va fatta con revisione e con la sedia ferma**, non al volo.

---

*Misura condotta sui soli file gia' presenti nel repo. Nessun EA modificato,
nessun conto toccato, nessun forward interrotto. Nessuna riga di lancio nuova
consegnata (quindi niente da mandare al verificatore-stringhe per questo
referto).*
