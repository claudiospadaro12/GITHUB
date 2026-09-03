# 📅 TASSONOMIA DELLE NOTIZIE ROSSE — quali famiglie esistono, quante volte l'anno, e quali possiamo toccare su una prop

> **Ricerca 1 di 2**, 03/09/2026. Gemella: `CACCIA_CANDELA_NEWS_2026-09-03.md`.
> Mandato: non fermarsi a FOMC/ECB/NFP, mappare **tutte** le famiglie di eventi
> ad alto impatto, e per ognuna dire: **quante volte l'anno**, **cosa dice la
> letteratura**, **se la nostra libreria le copre**, **se il vincolo FTMO ±2
> minuti le tocca**.
>
> ⚠️ Nessun EA toccato, nessun forward toccato, nessuna riga di lancio.
> Zero file prova scritti in questo dossier.

---

## 0. 🔴 LE SEI RIGHE CHE CONTANO, SUBITO

1. 🧱 **Il vincolo FTMO NON dipende dalla famiglia di evento: dipende dallo
   STRUMENTO e dal MOMENTO.** La regola vieta di aprire **o chiudere** (SL/TP
   inclusi) **entro ±2 minuti** dal rilascio **sugli strumenti colpiti**.
   ➡️ Un motore che lavora **da news+3 minuti in poi** e' **compatibile con
   ogni famiglia**; un motore che piazza pendenti **prima** del dato e'
   **incompatibile con tutte**. La domanda giusta non e' *"quale notizia?"*,
   e' ***"a che minuto tocchi il mercato?"***
2. 📏 **La finestra vietata e' 4 minuti su 1.440.** Su un anno di eventi USD
   ad alto impatto (**269/anno misurati**, §2) sono **~18 ore l'anno**.
   Il vincolo e' **strettissimo nel tempo e larghissimo nella percezione**:
   ci ha spaventati piu' di quanto pesi.
3. 📊 **La libreria di casa copre 4 valute su 8.** I 3 CSV in
   `biblioteca/dati/` contengono **USD, GBP, EUR, JPY** ad impatto alto
   (file Forex Factory) e **USD/UK/EZ/JP/CA/AU/NZ/CH** ad impatto misto (file
   MQL5). 🔴 **Nessun file di casa marca ad alto impatto i dati di CAD, AUD,
   NZD, CHF**: sono tutti a impatto 2 nel calendario MQL5 (§3).
4. 🎯 **Solo 6 famiglie su 19 hanno una tesi con appoggio in letteratura
   verificato oggi.** Le altre 13 hanno frequenza e volatilita', **non una
   tesi**. Le sei: tassi Fed, tassi ECB, tassi BoE/BoJ/SNB (pre-drift
   giornaliero), NFP, CPI, GDP (spike/fade a secondi).
5. ⚠️ **L'unica tesi accademica solida sulla "reazione" e' a orizzonte di
   SECONDI** (Ederington-Lee 1995: sovrareazione nei primi 40 secondi,
   corretta al 2º-3º minuto). **E' dentro la finestra vietata FTMO e sotto il
   nostro timeframe minimo.** ➡️ Non e' un candidato: e' una lapide.
6. 🟢 **La tesi che sopravvive al vincolo prop e' l'unica NON intraday:
   il PRE-announcement drift a D-1/D-2 sulle banche centrali** (Quantpedia,
   letto oggi, pagina libera). Compatibile con FTMO al 100% — ma e' un long
   azionario overnight, cioe' **doppione del nostro libro long sugli indici**,
   e su FTMO Standard l'overnight sul DAX e' vietato (pausa >2h). §5.

---

## 1. 🎯 CONTROLLO POSITIVO — fonte per fonte, prima di cercare

| fonte | bersaglio noto | esito |
|---|---|---|
| **forexfactory.com/calendar** | lista eventi | 🔴 **HTTP 403 — FONTE NULLA.** Non e' stata raggiunta, ne' oggi ne' in nessun tentativo. |
| **investing.com/economic-calendar** | lista eventi | 🔴 **EGRESS_BLOCKED dal proxy — FONTE NULLA.** |
| **ftmo.com** (FAQ news + calendario) | testo regola | 🔴 **EGRESS_BLOCKED — FONTE NULLA.** Confermato il blocco gia' registrato il 13/08 in `docs/REGOLAMENTO_FTMO_2026-08.md`. |
| **CSV di casa** `biblioteca/dati/*.csv` | 3 file, 46.112 righe totali | ✅ **PASSA** — e' diventata la fonte primaria di questo dossier |
| **arxiv.org** (listing + API `export.arxiv.org`) | `cat:q-fin.TR` restituisce 5 titoli veri | ✅ **PASSA** |
| **quantpedia.com** (articoli del blog) | 2 pagine lette per intero | ✅ **PASSA** — 🔧 **correzione agli atti**, vedi §7 |
| **mql5.com** (Code Base, articoli, libro) | lista EA = 40 titoli veri | 🟡 **PARZIALE** (titoli si', autori/date no in lista; le pagine singole danno tutto) |
| **github.com/search** | query `mql5` = **2,6k repo** | ✅ **PASSA** — quindi gli zero che seguono sono zeri VERI |
| ssrn.com · federalreserve.gov · nber.org · ecb.europa.eu · cambridge.org · sciencedirect · semanticscholar · skidmore.edu · proptraders.club · propfirmsfinder · propjournal · backtrex · eafunded | paper e regolamenti | 🔴 **TUTTI EGRESS_BLOCKED o 403 — FONTI NULLE** (13 domini) |

📌 **Conseguenza dichiarata e non aggirata:** **la lista ufficiale FTMO degli
eventi marcati "Restricted event" NON e' stata letta.** Tutto cio' che questo
dossier dice sul perimetro FTMO poggia su (a) il testo gia' agli atti in
`docs/REGOLAMENTO_FTMO_2026-08.md` §4 e (b) uno snippet di ricerca del 03/09
che lo conferma per categorie. **Non e' la lista.** §6.

---

## 2. 📊 LA MISURA DI CASA — 46.112 righe di calendario, contate oggi

Tre file, tre coperture diverse. **Nessuno dei tre e' completo.**

| file | righe | periodo | fuso dichiarato | copertura |
|---|---:|---|---|---|
| `CALENDARIO_FF_High_2010-2023_UTC.csv` | **8.313** | 2010.01.03 → 2023.12.22 | UTC | **solo impatto High**, **solo USD/GBP/EUR/JPY** |
| `CALENDARIO_news-2021-2024_...csv` | 20.386 | 2021.01.01 → 2024.12.31 | UTC+2 | tutti i paesi, **impatto 0/1/2/3** |
| `CALENDARIO_news-2022-2025_...csv` | 17.413 | 2022.01.01 → 2025.12.26 | UTC+2 | idem |

🔴 **Buchi misurati, non supposti:**
- Nel file Forex Factory le **Unemployment Claims settimanali** hanno anni
  interi vuoti (2018: **1** riga; 2019 e 2021 e 2022: **zero**; 2023: 42).
  ➡️ **Il file NON e' una serie storica completa**: e' un estratto.
- Nel file MQL5 gli eventi lavoro di **Canada, Australia, UK** sono tutti a
  **impatto 2**, non 3. L'unico "impatto 3" fuori dagli USA e' la **decisione
  sui tassi** (BoC 32, RBA 41, RBNZ 28, SNB 15, BoJ 33, BoE 32, ECB 63 in 4 anni).
- Nel file MQL5 l'impatto 3 e' **US-centrico al 76%** (2.051 righe su 2.699).

### 2.1 📈 Frequenza per famiglia — **contata sul file FF, finestra 2019-2023 (5 anni)**

> Metodo: `grep` sui titoli esatti, diviso 5. Conta le **occorrenze nel file**,
> non gli eventi "veri": dove il file ha buchi (§sopra) il numero e' **sotto**
> il vero, ed e' segnato. [VERIFICATO per conteggio]

| famiglia | valuta | eventi/anno | note |
|---|---|---:|---|
| **CPI (tutte le varianti USA)** | USD | **33,4** | headline+core, m/m e y/y. `CPI y/y` da solo: **12/anno esatti in 14 anni su 14** |
| **Fed / FOMC (blocco intero)** | USD | **34,4** | di cui **Statement 8,2** · **Press Conf. 8,2** · **Minute 7,6** |
| **BoE (blocco intero)** | GBP | **33,4** | Bank Rate + Summary + voti MPC + Monetary Policy Report |
| **PMI flash Germania/Francia** | EUR | 33,6 | manifatturiero + servizi, mensili |
| **Retail Sales USA** (headline+core) | USD | 23,8 | |
| **Discorsi del capo della Fed** | USD | 22,6 | Speaks + Testifies |
| **ECB (blocco intero)** | EUR | **22,2** | Main Refinancing Rate + Statement + Press Conference |
| **Discorsi del governatore BoE** | GBP | 24,2 | |
| **BoJ (blocco intero)** | JPY | **14,0** | Policy Statement + Press Conf. + Outlook |
| **NFP** (`Non-Farm Employment Change`) | USD | **12,4** | 12-13/anno **in tutti e 14 gli anni** |
| **Unemployment Rate USA** | USD | **12,4** | esce **insieme** all'NFP, stesso minuto |
| **Average Hourly Earnings** | USD | **12,4** | idem — 🔴 sono **3 righe di calendario, UN solo evento di prezzo** |
| **ISM Manufacturing PMI** | USD | 12,0 | |
| **ADP** | USD | 9,0 | 🔴 nel file ha anni monchi (2019: 6). Il vero e' 12 |
| **PPI USA** | USD | 10,2 | |
| **ISM Services PMI** | USD | 10,0 | |
| **CPI UK** | GBP | 9,0 | |
| **GDP USA** (advance/prelim/final) | USD | 8,0 | 🔴 il vero e' 12 (3 stime × 4 trimestri) |
| **GDP UK** | GBP | 7,0 | |
| **CB Consumer Confidence** | USD | 7,0 | |
| **Core PCE** | USD | 6,0 | 🔴 il vero e' 12 |
| **UoM Consumer Sentiment** | USD | 5,2 | |
| **Retail Sales UK** | GBP | 4,2 | |
| **Unemployment Claims** | USD | 9,8 ⚠️ | **il vero e' 52.** Il file e' bucato: vedi §2 |
| **Discorsi governatore BoJ** | JPY | 2,2 | |
| **ifo / ZEW Germania** | EUR | 2,0 | |

### 2.2 🌍 Le valute che il file FF **non ha**, contate sul file MQL5 (2021-2024, 4 anni)

| famiglia | paese | eventi/anno | impatto MQL5 |
|---|---|---:|---|
| **BoC Interest Rate Decision** | Canada | **8,0** | 3 (alto) |
| **RBA Interest Rate Decision** | Australia | **10,2** | 3 (alto) |
| **RBNZ Interest Rate Decision** | Nuova Zelanda | **7,0** | 3 (alto) |
| **SNB Interest Rate Decision** | Svizzera | **3,8** | 3 (alto) |
| Employment Change | Canada | 11,8 | 🟡 **2** (medio) |
| Employment Change | Australia | 11,8 | 🟡 **2** (medio) |
| CPI | Canada | 35,2 | 🟡 2 |
| CPI | Australia | 12,0 | 🟡 2 |
| CPI | Svizzera | 11,2 | 🟡 2 |
| GDP | Canada | 28,5 | 🟡 2 |

➡️ **[VERIFICATO]** Fuori dagli USA/UK/EZ/JP, **l'unica cosa che il nostro
calendario riconosce come alto impatto e' la decisione sui tassi.**
Se un giorno vorremo un motore su AUD/CAD/NZD, **il filtro news di casa non lo
protegge**: quegli eventi passerebbero per "impatto 2".

### 2.3 ⏰ Dove cadono nell'orologio — **ora server BCM**, 2019-2023

> Conversione: server BCM = **ora di Londra** (misurato il 03/09 dal Passo 0 di
> `ABTG_AllineaLondra`, citato in `REGISTRO_TEST.md`) = UTC+1 d'estate, UTC
> d'inverno. DST europeo calcolato (ultima domenica di marzo → ultima di
> ottobre). ⚠️ **[INFERITO]**: nelle 2 settimane l'anno in cui USA ed Europa
> sono sfasate, gli eventi USA scivolano di un'ora. Il conteggio sotto ne
> risente per ~4% delle righe.

```
ora server   eventi        cosa c'e'
  07:00       109   ████████████    dati UK mattina
  08:00       184   ████████████████████  dati UK/DE, apertura Londra e DAX
  09:00       147   ████████████████
  12:00       271   █████████████████████████████   ECB (tasso 12:45)
  13:00       762   ███████████████████████████████████████████████████████████████████████████
                     🎯 NFP · CPI · PPI · Retail Sales · GDP · ECB press conf.
  14:00       114   ███████████
  15:00       267   ███████████████████████████     ISM · dati 10:00 ET
  19:00       164   ████████████████                🎯 FOMC (statement 18-19, conf. +30')
```

🎯 **Il 33% di tutte le notizie ad alto impatto di 5 anni cade nell'ora 13:00
server.** E' l'ora dei nostri EA pomeridiani. **Un'ora sola concentra un terzo
del rischio-evento dell'anno.**

### 2.4 💥 La concentrazione — il numero che parla al muro giornaliero prop

| misura (2019-2023, eventi High) | valore |
|---|---:|
| giorni di calendario con **≥1** evento ad alto impatto | **889 su 1.826 = 48,7%** |
| eventi per giorno-attivo (media) | **2,57** |
| giorni con **≥4** eventi ad alto impatto | **216 in 5 anni = 43/anno** |
| giorni con **≥8** | 22 in 5 anni |
| giorni con **≥1 evento USD** ad alto impatto | **137/anno** |
| eventi USD ad alto impatto | **269/anno** |

🧱 **Lettura prop:** ci sono **43 giornate l'anno** in cui un motore
news-driven prenderebbe **4 o piu' segnali correlati**. Il muro FTMO
giornaliero e' **−5.000 su 100k**; a 0,65% per trade sono **3,2 stop pieni** e
il cap C1 di casa e' **3,25% di rischio aperto = 5 SL vivi**.
➡️ **Un motore news multi-evento sfonda il cap C1 prima del muro FTMO**, e lo
fa 43 volte l'anno. **Qualunque famiglia si scelga, va scelto UN evento per
giorno, non "tutti gli high".**

---

## 3. 🗂️ LA TASSONOMIA — famiglia per famiglia

Legenda **FTMO**: 🔴 = evento che le fonti nominano fra i "restricted";
🟡 = **non nominato, non escluso** (la lista vera non e' leggibile, §6);
la colonna dice se il **vincolo ±2 min** morde, **non** se la famiglia e' buona.

### A. 🏛️ DECISIONI SUI TASSI — 8 banche centrali

| banca | eventi/anno | ora server tipica | copertura CSV di casa | FTMO |
|---|---:|---|---|---|
| **Fed / FOMC** | **8** (+8 conf. stampa, +8 minute, +4 proiezioni) | **18:00-19:00** (conf. +30') | ✅ FF High **e** MQL5 imp.3 | 🔴 |
| **ECB** | **8** (tasso 11:45/12:45, conf. stampa +45') | **12:45** / conf. **13:30** | ✅ FF High + MQL5 imp.3 | 🔴 |
| **BoE** | **8** (Bank Rate + summary + voti insieme) | **11:00/12:00** | ✅ FF High + MQL5 imp.3 | 🔴 |
| **BoJ** | **8** (statement + press conf.) | **03:00-04:00** ⚠️ ora **senza orario fisso** | ✅ FF High + MQL5 imp.3 | 🔴 |
| **BoC** | **8** | 14:00-15:00 | 🟡 solo MQL5 (imp.3) | 🔴 |
| **RBA** | **10,2** (11 riunioni/anno fino al 2023, 8 dal 2024) | **04:30** | 🟡 solo MQL5 (imp.3) | 🔴 |
| **RBNZ** | **7,0** | **02:00-03:00** | 🟡 solo MQL5 (imp.3) | 🔴 |
| **SNB** | **3,8** (trimestrale) | 08:30 | 🟡 solo MQL5 (imp.3) | 🔴 |

**Letteratura verificata oggi:**
- 🟢 **Pre-announcement drift D-2/D-1 su BoE, BoJ, SNB** — Quantpedia,
  ricerca propria dell'editore (non un paper terzo), **ETF EWU/EWJ/EWL,
  13/12/2010 → maggio 2025**. Citazione letta: *"The D-2 plus D-1 strategy
  emerges as the superior pre-announcement trading framework"*; BoE = miglior
  rendimento **ma volatilita' e drawdown piu' alti**; SNB = *"very predictable
  and stable monetary decisions, which result in a small strategy's
  performance"*. [VERIFICATO sulla pagina]
- 🟢 **Pre-ECB drift** — Quantpedia 22/04/2025, **DAX da settembre 1998**,
  STOXX 50 dal 2007. Deriva positiva su tre sessioni (overnight D-2→D-1,
  intraday D-1, overnight D-1→D0) e — riga importante — *"The equity curves
  for D0 Open-to-Close sessions in both indices reveal an **adverse market
  reaction** to ECB announcements"*. [VERIFICATO sulla pagina]
- 🟡 **Pre-FOMC drift** — famiglia notissima; Quantpedia ha sia una pagina
  strategia (premium, non aperta) sia articoli liberi. **Non ho letto il paper
  originale** (Lucca-Moench): SSRN/NBER/Fed **tutti bloccati**. [INCERTO sulla
  quantificazione, la famiglia esiste]

**Traduzione per noi, onesta:**
- 🎯 Il pre-drift e' **D-1/D-2 sull'indice azionario**, non intraday sul FX.
  Su **DAX/Dow** vorrebbe dire **entrare il giorno prima e tenere overnight**.
- 🧱 **Su FTMO Standard funded l'overnight sul DAX e' vietato** (pausa mercato
  >2h, `REGOLAMENTO_FTMO_2026-08.md` §5): servirebbe **Swing**.
- 🕳️ **E riempie un buco? NO.** Sarebbe **long su indice** = la cosa che
  facciamo gia' (DAX Apertura, SupRev, SuperWave). Scorrelazione bassa.
- ✅ **Compatibilita' FTMO ±2 min: PIENA** (si entra il giorno prima).
- ⏱️ Frequenza: **8/anno per banca**. Su 4 banche = **32/anno**. Con la regola
  di casa (IS ≥150 operazioni) servirebbero **~19 anni** per l'IS. 🔴 **Fuori
  scala per il nostro imbuto.**

### B. 👷 DATI SUL LAVORO

| evento | eventi/anno | ora server | copertura | FTMO |
|---|---:|---|---|---|
| **NFP + Unemployment Rate + Avg Hourly Earnings** (stesso minuto) | **12** eventi di prezzo (36 righe) | **13:30** estate / 13:30 inverno | ✅ FF High + MQL5 imp.3 | 🔴 **nominato testualmente** |
| **ADP** | **12** | 13:15 | ✅ (file bucato) | 🟡 |
| **Initial Jobless Claims** | **52** | 13:30 | 🔴 **file FF bucato**; MQL5 imp.3 lo ha (201 in 4 anni) | 🟡 |
| **Employment Change Canada** | 12 | 13:30 (stesso minuto dell'NFP nei mesi in cui coincidono) | 🟡 MQL5 imp.**2** | 🟡 |
| **Employment Change Australia** | 12 | 02:30 | 🟡 MQL5 imp.**2** | 🟡 |
| **Claimant Count UK** | 12 | 07:00 | ✅ FF High | 🟡 |

🎯 **Il dato piu' utile di tutta la sezione:** **NFP, Unemployment Rate e
Average Hourly Earnings escono nello STESSO MINUTO** (12,4 righe/anno
ciascuno, stesso timestamp). Un EA che filtra per titolo e conta 3 eventi
**apre 3 volte sullo stesso movimento**. 🔴 **E' un moltiplicatore di rischio
giornaliero nascosto in una riga di CSV.**

📌 **Initial Jobless Claims — il candidato di frequenza della sezione:**
**52 all'anno**, ora fissa **13:30 server**, sempre di **giovedi'**.
E' l'unico evento macro USA con frequenza **settimanale**. La libreria MQL5 lo
marca impatto 3 (201 righe in 4 anni = 50/anno). 🟡 **Non l'ho trovato nominato
fra i "restricted" FTMO** — ma **non ho letto la lista** (§6).

**Letteratura:** nessuna trovata oggi specifica sui claims. Sull'NFP c'e'
tutto (e' l'evento piu' studiato del calendario), ma le due misure che
abbiamo lette per intero — Ederington-Lee (§4) e arXiv 2605.04004 §4.7 — dicono
la stessa cosa: **il movimento e' reale e velocissimo, la deriva successiva no.**

### C. 💸 INFLAZIONE

| evento | eventi/anno | ora server | copertura | FTMO |
|---|---:|---|---|---|
| **CPI USA** | **12** (33,4 righe/anno con le varianti) | **13:30** | ✅ FF High + MQL5 imp.3 | 🔴 **nominato** |
| **Core PCE** | 12 | 13:30 | 🟡 FF bucato (6/anno); MQL5 imp.3 ok | 🔴 (inflazione) |
| **PPI USA** | 12 | 13:30 | ✅ | 🟡 |
| **CPI UK** | 12 | **07:00** | ✅ | 🔴 |
| **CPI Euro Zone (flash)** | 12 | 10:00 | 🟡 MQL5 imp.3 (94 in 4 anni) | 🔴 |
| **CPI Canada / Australia / Svizzera** | 12 / 4 / 12 | varie | 🟡 MQL5 imp.**2** | 🔴 |

🔎 **Nota di calendario che vale un round:** **CPI USA e NFP escono alla stessa
ora (13:30 server) ma MAI lo stesso giorno.** Sommati fanno **24 eventi/anno
sullo stesso orologio**. Per un motore che lavora **a orario fisso** — cioe'
esattamente come `ABTG_PostNews` — questo e' il modo piu' economico di
**raddoppiare la frequenza senza cambiare una riga di codice**: cambia il
filtro del CSV, non il motore. 👉 e' il lascito principale per la Ricerca 2.

### D. 📈 CRESCITA

| evento | eventi/anno | ora server | copertura | FTMO |
|---|---:|---|---|---|
| **GDP USA** (Advance/Prelim/Final) | **12** (3 stime × 4 trim.) | 13:30 | 🟡 FF bucato (8/anno) | 🔴 **nominato** |
| **GDP UK** | 7-12 | 07:00 | ✅ | 🔴 |
| **GDP Canada** | 28,5 righe/anno (mensile+trim.) | 13:30 | 🟡 MQL5 imp.2 | 🔴 |

⚠️ **Le tre stime del PIL non sono tre eventi uguali:** l'**Advance** e' il
primo dato e concentra la sorpresa; Prelim e Final sono revisioni. **Trattarli
allo stesso modo diluisce il campione.** [INFERITO dalla struttura del dato,
non da un paper letto]

### E. 🏭 PMI

| evento | eventi/anno | ora server | copertura | FTMO |
|---|---:|---|---|---|
| **ISM Manufacturing PMI** | 12 | **15:00** | ✅ FF High | 🟡 |
| **ISM Services PMI** | 10-12 | **15:00** | ✅ FF High | 🟡 |
| **PMI flash Germania/Francia** | 33,6 righe/anno | 08:00-09:00 | ✅ FF High | 🟡 |
| **PMI UK (Final Manu/Serv/Constr.)** | ~36 righe/anno | 09:30 | ✅ FF High | 🟡 |
| **S&P Global US PMI** | ~24 | 14:45 | 🟡 MQL5 imp.3 | 🟡 |

📌 **L'ISM e' l'unica famiglia ad alto impatto che cade alle 15:00 server**
(= 10:00 ET, **30 minuti dopo l'apertura USA**). Per i nostri motori
pomeridiani sugli indici e' **il disturbatore ricorrente numero uno** e
nessuno dei nostri EA lo filtra. **Nessuna letteratura trovata** che dia al
PMI un comportamento post-notizia sfruttabile.

### F. 🛒 VENDITE AL DETTAGLIO

| evento | eventi/anno | ora server | copertura | FTMO |
|---|---:|---|---|---|
| **Retail Sales USA** (headline + core, stesso minuto) | 12 eventi (23,8 righe) | 13:30 | ✅ | 🟡 |
| **Retail Sales UK** | 12 | 07:00 | 🟡 FF bucato | 🟡 |

Stessa trappola dell'NFP: **headline e core escono insieme** → 2 righe, 1
movimento. Nessuna letteratura trovata.

### G. 🎤 DISCORSI E CONFERENZE STAMPA

| famiglia | righe/anno (FF High) | FTMO |
|---|---:|---|
| **Discorsi capo Fed** (Speaks + Testifies) | **22,6** | 🟡 |
| **Discorsi governatore BoE** | **24,2** | 🟡 |
| **Discorsi presidente ECB** | 7,2 | 🟡 |
| **Discorsi governatore BoJ** | 2,2 | 🟡 |
| **Conferenze stampa** (FOMC 8,2 · ECB 8,2 · BoJ 8) | ~24 | 🔴 (sono la banca centrale) |

🔴 **La famiglia peggiore per un EA, e per una ragione strutturale, non di
gusto:** un discorso **non ha un istante di rilascio**. Dura 30-60 minuti, il
movimento arriva **quando arriva la frase**, e nel calendario MQL5 i discorsi
esplodono a **208 righe/anno per gli USA e 248 per l'ECB a impatto 2**
(misurato oggi). ➡️ **Non e' un evento: e' una finestra.** Nessun motore a
orario fisso puo' lavorarci, e nessun filtro news puo' escluderli senza
spegnere mezza giornata.
🟢 **Unica eccezione: le conferenze stampa hanno un orario di INIZIO fisso**
(FOMC = statement+30', ECB = tasso+45') — ed e' esattamente cio' su cui e'
costruito `ABTG_PostNews`.

### H. ⚫ ALTRO (per completezza — nessuna tesi, nessun candidato)
Crude Oil Inventories (**200 righe in 4 anni, impatto 3 nel file MQL5**,
settimanale, 15:30 server), aste di titoli USA (10-Year Note **47**,
30-Year Bond **47** in 4 anni), CB Consumer Confidence (7/anno), UoM Sentiment
(5,2), ifo/ZEW (2,0), Building Permits, Philly Fed, JOLTS, Trade Balance.
🔴 **Nessuna letteratura trovata, nessuna copertura da verificare, nessun
candidato.** Li elenco perche' **stanno nel calendario e un filtro news mal
tarato li prende**: il Crude Oil Inventories da solo aggiunge **52 blocchi
l'anno** a un filtro che leggesse "impatto 3" dal calendario MQL5.

---

## 4. 📚 LA LETTERATURA — cosa ho VERIFICATO oggi, e cosa NON ho potuto leggere

### 4.1 🪦 Ederington & Lee (1995) — la lapide dei secondi

**"The Short-Run Dynamics of the Price Adjustment to New Information"**,
*Journal of Financial and Quantitative Analysis* **30(1), 117-134, marzo 1995**.
[VERIFICATO su `ideas.repec.org` via ricerca — 🔴 **la pagina Cambridge Core e
IDEAS sono egress-blocked: non ho letto ne' il paper ne' l'abstract su una
pagina aperta**. Cio' che segue viene da **snippet di ricerca**, e lo marco:]

> [INCERTO — da snippet, non da pagina aperta] *"prices adjust in a series of
> numerous small, but rapid, price changes that begin within 10 seconds of the
> news release and are basically completed within 40 seconds"*; *"there is some
> evidence that prices **overreact in the first 40 seconds** but that this is
> **corrected in the second or third minute** after the release."*

🎯 **Perche' conta piu' di ogni altra riga di questo dossier:**
1. **E' la tesi accademica dello "spike and fade"** — la Ricerca 2 la cercava,
   ed e' questa. Mercato: futures su tassi e cambi (DM), dati **1988-1992**.
2. **Il fade sta nel minuto 2-3.** 🧱 **Dentro la finestra vietata FTMO**
   (±2 min) e **sotto il nostro timeframe minimo** (M5 = 1 barra intera).
3. **La finestra e' 1988-1992.** Trentaquattro anni, mercati che non esistono
   piu' (voice broking, niente HFT). ⚠️ **Regime dichiarato: non il nostro.**

### 4.2 🧾 arXiv 2605.04004 §4.7 — e una **CORREZIONE alla nostra lapide L1**

Il paper **e' gia' agli atti** (`REGISTRO_TEST.md` riga 785 — lapide **L1**,
*"post-news drift 15-30 min su Nasdaq: CHIUSO"*).
🔴 **Oggi ho aperto la pagina arXiv e verificato un dato che nel repo non era
scritto: le barre sono da CINQUE MINUTI.**
[VERIFICATO su `arxiv.org/abs/2605.04004`: *"Bar size/Timeframe: Five-minute
bars"*, Mathias Mesfin, MNQ, 947 giorni 2021-2025, revisione 13/07/2026]

Rimettendo i due pezzi insieme:

| il paper dice | tradotto in minuti |
|---|---|
| *"The drift is real in the **first five bars** after the release"* | **minuti 0 → 25** |
| *"From **bar +6** onward, T-statistics … between 0.14 and 0.69"* | **dal minuto 30 in poi** |

➡️ **[INFERITO, aritmetica dichiarata]** La lapide L1 boccia il post-news
**dal minuto 30**. **Non boccia i minuti 0-25.** E `ABTG_PostNews` agisce a
**news+10 (FOMC)** e **news+15 (ECB)** — cioe' **dentro** la fascia che il
paper chiama *reale*.
⚠️ **Non e' una promozione**: l'autore aggiunge *"That is just the news spike
itself"*, cioe' attribuisce la deriva **al salto**, non a una continuazione
prendibile **entrando dopo**. Ma la distinzione va scritta, perche' finora nel
repo L1 era citata come se chiudesse tutta la famiglia. **Non la chiude.**

### 4.3 🟢 Quantpedia — pre-announcement drift (§3.A). Letto per intero, pagine libere.

### 4.4 📄 Gli altri paper: nominati ma **NON letti** — buco dichiarato

| paper | perche' interessa | esito |
|---|---|---|
| Andersen-Bollerslev-Diebold-Vega, *Real-Time Price Discovery in FX* (NBER w8959) | la classifica **quale annuncio muove di piu' il FX** | 🔴 **nber.org egress-blocked** |
| Chaboud et al., *High-Frequency Effects of U.S. Macro Data Releases* (Fed IFDP 823, 2004) | velocita' di aggiustamento nel FX interdealer | 🔴 **federalreserve.gov egress-blocked** |
| Kurov-Sancetta-Strasser-Wolfe (2017), *Price Drift before U.S. Macro News* | il **pre-drift a 30 minuti** (~42% del movimento totale) | 🔴 **skidmore.edu, ecb.europa.eu, researchgate tutti bloccati** — [INCERTO: il "30 minuti / 42%" viene da uno snippet] |
| Lahaye-Laurent-Neely, *Jumps, cojumps and macro announcements* | quali annunci generano **salti statistici** | 🔴 **wiley bloccato** |
| Rambaldi-Pennesi-Lillo, arXiv **1405.6047**, *Modeling FX market activity around macroeconomic news* | attivita' FX attorno alle news, processi di Hawkes | 🟡 **trovato su arXiv, non aperto** (fuori portata operativa: modella l'attivita', non una regola) |

🔴 **Tredici domini bloccati.** La letteratura di microstruttura vive su
JF/JFE/RFS/JBF e su siti di banche centrali: **da questa postazione e'
sostanzialmente irraggiungibile.** E' la stessa conclusione della quinta
caccia (`REGISTRO_TEST.md`: *"uno zero su arXiv NON e' assenza di
letteratura"*), e va ripetuta ogni volta.

---

## 5. 🏛️ IL CANCELLO PROP — una riga per famiglia

**I muri** (`report/METRO_PROP.md`, `docs/REGOLAMENTO_FTMO_2026-08.md`):
DD totale **10%** · DD **giornaliero 5%** (−5.000 su 100k) · cap di casa **C1
3,25% di rischio aperto** = **5 SL vivi a 0,65%**.

| famiglia | frequenza | rischio giornaliero | scorrelazione dal nostro libro | verdetto prop |
|---|---|---|---|---|
| **Tassi (pre-drift D-1/D-2)** | 8/anno/banca | basso (1 trade) | 🔴 **bassa**: e' long su indice, come 6 sedie su 10 | 🟡 compatibile FTMO, **ma doppione e IS da 19 anni** |
| **Tassi (conf. stampa, news+10/15)** | 16/anno (FOMC+ECB) | medio | 🟢 alta (evento, non livello) | 🟢 **gia' in casa**, vedi Ricerca 2 |
| **NFP** | 12/anno | 🔴 **alto**: 3 righe = 1 movimento, e trascina piu' simboli | 🟢 alta | 🟡 compatibile **solo** se si tocca dopo +3 min |
| **CPI USA** | 12/anno | come NFP | 🟢 alta | 🟡 idem |
| **Jobless Claims** | **52/anno** | basso (evento singolo, sorpresa piccola) | 🟢 alta | 🟢 **la frequenza migliore della tassonomia** |
| **ISM** | 24/anno | medio | 🟡 media (15:00 = dentro la nostra sessione USA) | 🟡 |
| **GDP** | 12/anno (solo Advance conta) | medio | 🟢 alta | 🟡 |
| **PMI EU/UK** | 70/anno | basso | 🔴 **si sovrappone al DAX Apertura** (08:00-09:00) | 🔴 |
| **Discorsi** | 50+/anno | 🔴 imprevedibile | — | 🔴 **non automatizzabile** |
| **Retail Sales / PPI / PCE / altro** | 12/anno cad. | medio | 🟢 | 🟡 nessuna tesi |

🔴 **Il rilievo che vale per tutte:** **43 giorni l'anno hanno ≥4 eventi ad
alto impatto** (§2.4). Un motore che li prendesse tutti sfonderebbe C1
**prima** del muro FTMO. **La regola operativa che ne esce e': un evento per
giorno, dichiarato in anticipo, non "tutti gli high del calendario".**

---

## 6. 🧱 IL VINCOLO FTMO — cosa e' verificato e cosa NO

### ✅ VERIFICATO (testo gia' agli atti, `docs/REGOLAMENTO_FTMO_2026-08.md` §4)

> *"On the targeted instruments, it is not permitted to open or close any
> trades, **including pending orders (such as Stop Loss or Take Profit)**,
> within a time window starting **2 minutes before and ending 2 minutes
> after** the release of selected news announcements."*
> — e — *"**if a Stop Loss or Take Profit is triggered within the restricted
> time window, this will also be considered a breach**"*
> — e — *"during the US NFP release, you may trade EURGBP or AUDNZD; however,
> you must not open or close trades on **USDJPY or GBPUSD**"*

Le tre sfumature che cambiano tutto, **tutte agli atti**:
1. 🟢 **NON vale in Challenge/Verification.** *"Restrictions… apply only once
   you start trading on an FTMO Account."*
2. 🟢 **NON vale sul conto SWING.** *"The FTMO Swing account type does not have
   any restrictions on trading during news releases."*
3. 🟢 **Le posizioni aperte >2 minuti prima si possono TENERE.**

📌 E dal confronto in casa (`docs/REGOLAMENTO_FUNDINGPIPS_2026-08.md` §4):
**FundingPips e' PIU' severa** — ±5 min con profitto **decurtato** (Master),
±10 min **hard breach** (Zero), e **nessun conto esente stile Swing**.

### 🟡 CONFERMATO OGGI, ma da snippet e non dalla lista
Ricerca del 03/09: gli eventi restricted sono *"mostly reports on gross
domestic product, inflation, or the labour market (especially in the USA,
where NFP is monitored), which then influence central bankers' decisions on
interest rates"*, e sono marcati **"Restricted event"** nel calendario FTMO,
che usa **dati Forex Factory**.

➡️ **[INFERITO] Le famiglie sicuramente colpite: tassi (tutte le banche),
CPI/inflazione, GDP, NFP/lavoro USA.**
➡️ **[INCERTO] NON so** se sono colpiti: **ISM, PMI, retail sales, ADP,
jobless claims, discorsi**. Sono i piu' probabili "non restricted", ma
**non l'ho letto**.

### 🔴 NON VERIFICATO — e va chiesto
1. **La lista letterale degli eventi "Restricted"** → `ftmo.com/en/calendar/`
   e' **egress-blocked**. Serve che **Claudio apra la pagina dal suo browser**:
   e' un lavoro di 2 minuti che chiude un buco che io non posso chiudere.
2. **Che cosa conta come "targeted instrument"** per un indice: un evento USD
   colpisce **US30/NASUSD**? E un evento EUR colpisce **D30EUR**? Il testo
   parla di coppie FX. **Da chiedere per iscritto**, ed e' nella lista domande
   gia' preparata in `REGOLAMENTO_FTMO_2026-08.md` §(b).

### 🎯 LA REGOLA OPERATIVA CHE NE ESCE — una riga, e vale per la Ricerca 2

> **Un motore che tocca il mercato da news+3 minuti in poi e' compatibile con
> FTMO su qualunque famiglia di evento, su qualunque conto.**
> Un motore che piazza pendenti *prima* del dato **non lo e' mai** — e non
> perche' l'ordine parte, ma perche' **lo SL/TP che scatta dentro la finestra
> e' gia' un breach**.

⚠️ **E l'insidia che nessuno nomina:** anche un motore che entra a news+10
minuti puo' avere lo **SL colpito dentro la finestra ±2 min dell'evento
SUCCESSIVO**. Con **43 giorni l'anno a ≥4 eventi**, non e' un caso di scuola.
**Un EA news-compatibile con FTMO ha bisogno del calendario per USCIRE, non
solo per entrare.**

---

## 7. 🔧 CORREZIONI AGLI ATTI (misurate oggi)

1. **Quantpedia NON e' interamente premium.** `REGISTRO_TEST.md` (quinta
   caccia) dice *"Quantpedia riconfermata PREMIUM su 4 slug reali"*.
   ✅ **Vero per le pagine `/strategies/`**. 🔴 **Falso per gli articoli del
   blog**: due letti oggi per intero, senza paywall
   (`/uncovering-the-pre-ecb-drift...`, `/pre-announcement-drift-for-boe-boj-snb...`).
   👉 **Su Quantpedia si entra dagli ARTICOLI, non dalle STRATEGIE.**
2. **La ricerca repository di GitHub FUNZIONA.** Controllo positivo:
   `q=mql5` → **2,6k repository**. Gli zero dei dossier precedenti sono
   **zeri veri**, non un canale rotto. (Le query lunghe danno 0 perche' GitHub
   richiede **tutti** i termini: vanno spezzate.)
3. **Il calendario nativo MQL5 non gira nel tester — confermato su due pagine
   indipendenti.** Libro MQL5 (`advanced/calendar/calendar_trading`):
   *"the MQL5 calendar is not available in the tester"*. Articolo **22580**
   (Ushana Kevin Iorkumbul, **28/05/2026**): *"None work in the Strategy Tester
   because the tester has no server connection during historical replay."*
   ➡️ **Qualunque EA news di casa DEVE essere guidato da CSV.** E' esattamente
   cio' che `ABTG_PostNews` gia' fa (`InpNewsFile="abtg_news.csv"`).
   🟢 **Non e' un limite per noi: e' un vantaggio gia' incassato.**
4. **La lapide L1 non copre i minuti 0-25.** Vedi §4.2. Va scritto nel
   registro, perche' finora era citata come chiusura totale della famiglia.

---

## 8. 🚧 COSA NON HO POTUTO VEDERE

- 🔴 **La lista FTMO dei "Restricted event"** — la cosa piu' importante del
  dossier. `ftmo.com` bloccato, 3 aggregatori bloccati.
- 🔴 **Forex Factory** — 403 su calendario e thread. Il mandato citava la
  fonte: **non e' stata raggiunta.** ✅ Ma il suo contenuto storico e' in casa
  (`CALENDARIO_FF_High_2010-2023_UTC.csv`), ed e' da li' che vengono tutti i
  numeri di questo dossier.
- 🔴 **Investing.com, DailyFX** — bloccati.
- 🔴 **13 domini accademici/istituzionali** (§4.4).
- 🟡 **Il calendario 2024-2026 ad alto impatto per CAD/AUD/NZD/CHF**: in casa
  esiste solo a impatto 2. **Se serve, va scaricato** — i repo scraper
  ForexFactory su GitHub esistono e sono raggiungibili (13 risultati, il piu'
  stellato `maurodelazeri/forexcalendar` 28 ⭐ ma **fermo al 2019**;
  `FabianStammen/ForexFactory_Scraper` 22 ⭐, agg. 08/02/2023). **Nessuno
  letto nel sorgente, nessuna licenza verificata: non sono candidati, sono
  una porta.**

---

## 9. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

Non ho promosso nessun motore nuovo in questo dossier — la tassonomia non
serve a quello. Serve a scegliere **quale evento** dare al motore che gia'
abbiamo. E la domanda e' una sola:

> 🎯 **"Il motore `ABTG_PostNews` — che oggi lavora su 16 eventi l'anno
> (FOMC + ECB) — cambia comportamento se gli si danno i 24 eventi
> NFP+CPI USA, che escono alla STESSA ora (13:30 server) e MAI lo stesso
> giorno?"**
>
> E' una domanda di **frequenza** (16 → 40 eventi/anno, **+150%**) su un
> motore gia' scritto, gia' compilato, gia' guidato da CSV, **senza toccare
> una riga di codice** — solo `InpNewsTitleMatch`, `InpNewsCurrencies`,
> `InpActionHour/Min` e le righe del CSV.
>
> ⚠️ **Prerequisito non aggirabile:** `@DAQUANDO` **si misura** con
> `scarica_storico.ps1`. Non scrivo un file prova senza quella data, e non
> l'ho misurata: non ho MT5.

**La spec del test sta nella Ricerca 2**, `CACCIA_CANDELA_NEWS_2026-09-03.md` §7.

---

## 10. 🔗 FONTI EFFETTIVAMENTE APERTE (03/09/2026)

**Fuori:**
- https://arxiv.org/abs/2605.04004 — Mesfin, *Structural Limits of OHLCV-Based Intraday Signals in MNQ Futures*, barre **5 minuti** ✅
- https://arxiv.org/list/q-fin.TR/recent — controllo positivo
- http://export.arxiv.org/api/query — API, controllo positivo + 2 ricerche
- https://quantpedia.com/pre-announcement-drift-for-boe-boj-snb-do-markets-move-before-the-word-is-out/ — letta intera
- https://quantpedia.com/uncovering-the-pre-ecb-drift-and-its-trading-strategy-applications/ — letta intera
- https://www.mql5.com/en/book/advanced/calendar/calendar_trading — limite calendario/tester
- https://www.mql5.com/en/articles/22580 — Iorkumbul, 28/05/2026, CSV fallback
- https://www.mql5.com/en/code/mt5/experts — controllo positivo
- https://github.com/search?q=mql5 — controllo positivo (2,6k repo)
- https://github.com/search?q=forexfactory+calendar+scraper — 13 repo

**In casa:**
- `backtest_pipeline/caccia_strategie/biblioteca/dati/CALENDARIO_FF_High_2010-2023_UTC.csv` (8.313 righe)
- `backtest_pipeline/caccia_strategie/biblioteca/dati/CALENDARIO_news-2021-2024_*.csv` (20.386)
- `backtest_pipeline/caccia_strategie/biblioteca/dati/CALENDARIO_news-2022-2025_*.csv` (17.413)
- `docs/REGOLAMENTO_FTMO_2026-08.md` · `docs/REGOLAMENTO_FUNDINGPIPS_2026-08.md`
- `backtest_pipeline/REGISTRO_TEST.md` (917 righe, letto per intero)
- `report/coach_paolo/NEWS_BREAKOUT_OCO_NFP_2026-09-03.md`
- `backtest_pipeline/prove/POSTNEWS_CORSO_SPEC.md` · `mql5/Experts/ABTG_PostNews.mq5`

**Fonti NULLE dichiarate:** forexfactory.com (403) · investing.com · ftmo.com ·
ssrn.com · nber.org · federalreserve.gov · ecb.europa.eu · cambridge.org ·
sciencedirect.com · semanticscholar.org · skidmore.edu · researchgate.net ·
proptraders.club · propfirmsfinder.com · propjournal.net · backtrex.com ·
eafunded.com
