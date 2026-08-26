# 🧭 R113 — PROVA DI REGIME NASUSD_EXT — CRITERI **[DA FIRMARE]**

_Bozza scritta il 27/08/2026, PRIMA di qualunque numero, dalla sessione
agente su incarico della sessione principale. Nessun driver e nessun file
prova esiste ancora: arrivano DOPO la revisione della sessione principale
e DOPO la firma. Il lucchetto di questo file e' il token di stato nel
titolo e nel § 9; ovunque altro, quando lo si CITA, lo si scrive spezzato
— `[DA` + `FIRMARE]` — per non tenere chiuso il cancello con una
citazione (checklist 82)._

---

## 0. 🎯 LA DOMANDA DEL ROUND (gia' agli atti, tre volte)

**"L'edge short sul Nasdaq vive nelle discese?"** Non e' un'ipotesi di
fantasia: e' lo stesso disegno comparso TRE volte nell'archivio, sempre
sulla stessa finestra 2024-2026 che di discese ne contiene una sola (e
sta nell'IS):

| dove | fatto |
|---|---|
| **R107** | NAS short di apertura: **IS PF 3,220** (+8.399, n 58) → **OOS PF 0,460** (−10.569) |
| **R110** | SWDOW short: IS 1,446 → OOS 0,429 — stesso disegno, terzo caso |
| **R110** | SUPNAS short: **verde anche in OOS** (PF 1,870, DD 0,93 < long) ma **n 34 → indizio, merito sospeso** |

R110 chiude cosi': _"da verificare in prova di regime sui 16 anni"_. Il
26/08 Claudio ha firmato **"FIRMO FRIGO NASUSD"**: `NASUSD_EXT` e'
**AMMESSO alla prova di regime** (rapporto 0,199 sul metro relativo 0,20
— bordo sottile, dichiarato), con i limiti D-C **invariati e non
negoziabili**: parametri CONGELATI, SOLO prova di regime, **MAI
promozione**. Questo round e' esattamente quel seguito. I dati ci sono:
`NASUSD_EXT` **2010.11.14 → 2026.07.31**, 5,23 M barre M1, H1 = 93.085
barre totali (referto `STORICO_INDICI_20260826_2320`).

---

## 1. ⚠️ IL PARAGRAFO PIU' IMPORTANTE — IL BANCO E IL SUO LIMITE COSTITUTIVO

**`NASUSD_EXT` e' fatto di barre M1 importate (HistData). NON ha tick
reali BCM: il modello 4 su questo simbolo NON ESISTE** (e' scritto nello
strumento stesso, `importa_storico_esterno.ps1` riga 525). Il banco di
questo round e' **modello "OHLC su M1" (modello 1)**, e questo non e' un
dettaglio tecnico: e' un limite costitutivo, perche' la differenza tra i
due banchi e' MISURATA, non temuta — **SupRev_DOW_H4 fece PF 2,77 in
OHLC e PF 0,79 a tick reali** (revalidation 30/07, contratto REVOCATO).

Quindi, regole di lettura SCOLPITE prima dei numeri:

1. 📐 **Questo round misura la FORMA dell'edge attraverso i regimi**
   — verde/rosso, ordini di grandezza, dove il motore vive e dove muore
   — **MAI i numeri fini.** Un PF 1,3 contro un PF 1,5 fra due finestre
   _EXT e' rumore di banco; un verde contro un rosso e' informazione.
2. 🔒 **I confronti si fanno SOLO _EXT-contro-_EXT fra finestre.** Mai
   "_EXT 2022 contro BCM 2025", mai "questa cella su _EXT contro il suo
   numero R110 a tick reali". I numeri R110 stanno in questo file come
   ORIGINE delle celle, non come metro di paragone.
3. 💶 **Spread e commissioni**: niente spread storico, niente slippage
   vero (prezzo dichiarato della decisione D-A del 25/08). Lo spread e'
   quello FISSO impostato sul simbolo custom, **identico per tutte le
   finestre** — il valore effettivo va letto e dichiarato nel referto.
   La coerenza interna e' cio' che rende leggibile il confronto
   relativo; il valore assoluto no, e non lo si legge.
4. 🧾 **In testa al referto** andra' la frase fissa di D-C: _questi sono
   dati di un ALTRO broker — spread, orari di seduta e prezzi non sono
   BCM._

---

## 2. 🔩 PERIMETRO MOTORI — UN motore, TRE celle, zero spazzolate

**Motore unico: `ABTG_SupRev_NAS_H1_Ottimizzato` su NASUSD_EXT H1**, le
tre celle di R110, parametri **CONGELATI** riga per riga:

| cella | cos'e' | antenato (file prova agli atti) |
|---|---|---|
| `00_metro` | la cella VIVA L+S (sedia 970913) | `prove/R110_SUPNAS_00_metro.txt` |
| `01_long` | solo long | `prove/R110_SUPNAS_01_long.txt` |
| `02_short` | solo short — **la domanda del round** | `prove/R110_SUPNAS_02_short.txt` |

**Nessun secondo motore, ed e' un perimetro onesto, non pigro**: l'unico
altro motore NAS con un round suo e' l'intraday momentum di **R98 —
BOCCIATO 0/6, nessuna cella promossa ne' definita** ("la seconda caccia
sul NASUSD si chiude qui"). Non esiste una cella congelata da portare al
banco: portarcene una inventata sarebbe una spazzolata travestita.

Totale: **3 celle × 6 finestre (§ 3) × 2 gemelli = 36 passate**, tutte a
parametri identici agli antenati salvo i delta del G0-A (§ 4).

---

## 3. 📅 LE FINESTRE — la macchina di casa, piu' una VECCHIA, con un adattamento dichiarato

Base: la macchina di regime R50-R56-R59 (`prove/PROVA_REGIME_CRITERI.md`),
finestre CONGELATE, compreso lo sdoppiamento CROLLO/CROLLO_ANNO
dell'Emendamento 2 (rischio a 3 mesi, merito a 12).

| # | finestra | periodo | che cos'e' sul Nasdaq | giudica |
|---|---|---|---|---|
| F0 | **TORO** | 2021.01.01 - 2021.12.31 | anno di salita di riferimento | merito (controllo) |
| F1 | **ORSO** | 2022.01.01 - 2022.10.31 | il calo vero: −30%+ con inflazione | merito + rischio |
| F2 | **CROLLO** | 2020.02.01 - 2020.04.30 | shock Covid | **SOLO rischio** (E.3) |
| F3 | **CROLLO_ANNO** | 2020.01.01 - 2020.12.31 | l'anno intero dello shock | merito |
| F4 | **LATERALE_NAS** | 2015.01.01 - 2016.06.30 | 🆕 vedi adattamento sotto | merito + rischio |
| F5 | **VECCHIA** | 2011.01.01 - 2012.12.31 | crisi del debito europeo | **SOLO rischio** (regola B) |

**🔧 ADATTAMENTO DICHIARATO (F4), da firmare:** la macchina di casa usa
LATERALE = 2019. Ma quell'etichetta e' nata sui FOREX: **sul Nasdaq il
2019 e' un anno di rally pieno (~+38%)** — chiamarlo "laterale" farebbe
mentire l'etichetta, ed e' l'etichetta che poi si legge (la lezione del
criterio B corretto: il giudizio dipende da cosa la finestra E', non da
come si chiama). Si propone **2015.01–2016.06**: l'unico tratto della
storia NASUSD_EXT genuinamente piatto e nervoso (correzione ago-2015,
correzione gen-feb-2016, ritorno al punto di partenza). Le altre cinque
finestre restano IDENTICHE alla macchina firmata — la comparabilita' coi
round forex si perde solo dove l'etichetta avrebbe mentito.

**🕰️ F5 (VECCHIA) applica la regola B dell'Emendamento della finestra:
il vecchio giudica il RISCHIO, il recente il MERITO.** Nessuna cella
viene giudicata nel merito perche' non guadagnava nel 2011; il suo DD
del 2011-2012 invece e' un fatto e si legge sempre.

**📏 Il tetto barre NON morde, ed e' misurato, non sperato:** il motore
e' H1 e l'INTERA storia _EXT fa 93.085 barre H1 (< 100.000). Ogni
finestra e' una corsa singola, nessuna tranche, TF dichiarato H1.
Nessuna finestra scende sotto M15/M5: il vincolo di
`STORICO_INDICI_CRITERI.md` resta scritto qui per il prossimo che legge.

**🕐 Orologi (checklist 86):** le barre _EXT sono gia' allineate all'ora
server BCM (shift +5 applicato e verificato all'import). Le finestre
sono date di calendario a giorni interi: il fuso non sposta il verdetto.
Qualunque orario finisca nel referto dichiara di quale orologio e'.

---

## 4. 🚧 I CANCELLI

### G0-EXT — l'ammissione del simbolo (gia' superato, per firma)
`NASUSD_EXT` e' ammesso dall'emendamento FIRMATO del 26/08 ("FIRMO FRIGO
NASUSD"): rapporto 0,199 sul metro relativo, copertura H1 97%, 3/3
eventi diff-max spiegati. **Bordo sottile, e resta dichiarato in testa
al referto.** SPXUSD_EXT e 225JPY_EXT restano in frigo e NON entrano.

### G0-A — l'antenato (il gate anti-corruzione, checklist 72)
Ogni file prova R113 e' la **COPIA RIGA PER RIGA** del suo antenato
`prove/R110_SUPNAS_0*.txt`. I delta ammessi, e il driver li pretendera'
**PER NOME** (il confronto col solo gemello non vede la corruzione
simmetrica):

- `@SIMBOLO` : `NASUSD` → `NASUSD_EXT`
- le **date finestra** (`@DAQUANDO`/`@FINOA` secondo la finestra F0-F5)
- `InpMagic` : blocco vergine 7635xx (§ 5)

**Nient'altro.** Ne' un buffer, ne' un lato, ne' un sotto-parametro di
un filtro spento. Rischio resta 1,0% come negli antenati.

### G0-C — i gemelli
Ogni cella gira in coppia gemella (magic +5): risultati IDENTICI o la
corsa non vale.

### G1 — il campione, per finestra, con l'unita' DICHIARATA
**Unita': USCITE (deal di uscita, `STAT_TRADES` dell'OPTFRAME) — la
stessa di tutti i round di casa.** La scoperta di R112 § 3 dice che con
TP1 50% + trailing **~2 uscite ≈ 1 posizione** (misurato: 517 uscite =
257 posizioni sul metro EMADOW): quindi "n 40" qui significa **~20
posizioni**, e il referto lo ripete accanto a ogni n. La domanda aperta
di R112 ("l'unita' dell'Emendamento e' l'uscita o la posizione?") NON si
decide qui di nascosto: qui si dichiara l'unita' usata e si tiene la
soglia storica della macchina di regime, che con quell'unita' e' nata.

Soglie (Emendamento 1 della macchina di regime, E.2, congelate):

| campione (uscite) | cosa si puo' dire |
|---|---|
| **n ≥ 20** | verdetto pieno di MERITO |
| **8 ≤ n ≤ 19** | 🟡 SOSPESO — il numero si scrive, la decisione no |
| **n < 8** | ⬜ NON MISURATO per quella finestra |

**E la valvola E.3 vale sempre: il campione sottile sospende il MERITO,
MAI il RISCHIO.** Un drawdown e' un fatto accaduto a qualunque n.

### G2 — la lettura del RISCHIO (criterio A della macchina, adattato al D-C)
Metro: il DD OOS R110 della cella corrispondente (metro 1,29 / long
1,62 / short 0,93 — a rischio 1%). Se in una finestra avversa (F1, F2,
F5) una cella fa **DD > 2× il suo metro E comunque > 20%**, scatta la
**SEGNALAZIONE FORMALE DI REVISIONE** della sedia viva 970913 alla
sessione principale, decisione a Claudio. NON un declassamento
automatico: D-C vieta di muovere sedie su dati esterni, ma la regola B
vieta anche di ignorare un rischio misurato. La segnalazione e' il punto
d'equilibrio, e si legge sulla FORMA (ordine di grandezza), coerente col
§ 1. I DD si confrontano come **magnitudini positive, verso dichiarato**
(checklist 87).

---

## 5. 🔢 MAGIC — blocco vergine 7635xx (verificato)

`grep -r "7635"` su tutto il repo: **l'unica occorrenza e' un conteggio
di barre orarie** nella diagnosi DAX (`MAPPA_SESSIONI.txt` riga 37,
`07:00=7635`), nessun magic, nessun file prova, nessuna sedia. R110 ha
bruciato 7630xx, R112 i 7634xx: il blocco **763500-763599 e' vergine**.

Schema: `763500 + F×10 + C` (F = finestra 0-5, C = cella 0-2), gemello
= **+5**. Esempi: metro-TORO 763500/763505; short-VECCHIA 763552/763557.
Range totale usato: 763500-763557. Il magic vivo **970913 e' VIETATO**
nel round e il driver dovra' controllarlo.

---

## 6. 🧠 LA LETTURA PRE-DICHIARATA — il cuore anti-bias del round

Scritta ORA, prima di qualunque numero. L'ipotesi (nome: IPOTESI-S, per non confonderla col TF H1 del motore) si legge sulla cella
`02_short`; `00_metro` e `01_long` sono il contesto (dove sta l'edge
della sedia viva, regime per regime).

**IPOTESI-S — "l'edge short vive nelle discese" e':**

| esito | condizione (pre-dichiarata) |
|---|---|
| ✅ **CONFERMATA** | short **PF ≥ 1,10 con n ≥ 20 in ORSO _E_ in CROLLO_ANNO** (due banchi avversi, regola D della macchina: uno solo e' un aneddoto), **E PF < 1,10 in TORO** |
| ❌ **SMENTITA** | short **PF < 0,90 con n ≥ 20 in ORSO _E_ in CROLLO_ANNO** |
| 🌦️ **MOTORE PER TUTTE LE STAGIONI** (esito diverso, previsto ora per non inventarlo dopo) | short **PF ≥ 1,10 con n ≥ 20 in ORSO, CROLLO_ANNO _E_ TORO**: l'ipotesi "solo discese" cade al rialzo — etichetta diversa, non promozione (G5 resta) |
| 🤷 **NON CONCLUSIVA** | ogni altro quadro: segni misti fra le due finestre avverse, o campioni sottili/non misurati dove serviva il verdetto |

Vincoli di lettura: **F2 (CROLLO 3 mesi) e F5 (VECCHIA) NON entrano nel
verdetto di IPOTESI-S** — giudicano solo il rischio (E.3 / regola B). F4
(LATERALE_NAS) e' contesto: nessuna condizione di IPOTESI-S ci poggia sopra.
Il quadro "verde in ORSO ma sottile in CROLLO_ANNO" (o viceversa) e'
NON CONCLUSIVO: non si declassa a "confermata a meta'" dopo aver visto
i numeri.

---

## 7. 🚫 G5 — NESSUNA PROMOZIONE, PER COSTRUZIONE

Vincolo D-C, FIRMATO il 25/08 e ribadito nell'emendamento del 26/08:
**nessuna cella entra in flotta, cambia stato o si sposta in classifica
per un numero uscito su un _EXT.** Questo round produce SOLO conoscenza
di regime: la risposta a IPOTESI-S, la mappa verde/rosso della sedia viva
attraverso 16 anni, e al piu' la segnalazione di revisione del G2.
Qualunque "e allora facciamo la sedia short-only" e' **un round
successivo, su dati BCM, con la sua firma** (il precedente e' R110 → 
R112: la misura prima, il contratto poi).

---

## 8. 🛡️ PREVENZIONI DALLA CHECKLIST (difetti gia' pagati)

| punto | prevenzione in R113 |
|---|---|
| **72** | G0-A confronta con l'ANTENATO per nome dei delta, non solo col gemello (la corruzione simmetrica e' invisibile al differenziale) |
| **80** | i criteri poggiano SOLO su colonne che l'OPTFRAME di questo banco esporta DAVVERO, verificate sull'intestazione vera prima della corsa; "peggior giornata" su _EXT senza per-trade = **n/d PER COSTRUZIONE, dichiarato**, mai criterio fantasma |
| **82** | token di stato solo nei due lucchetti veri (titolo e § 9); ogni citazione in prosa e' spezzata; alla firma si rigrepa il file INTERO per il token, non solo il titolo |
| **84** | ogni cancello del driver vivra' nel codice d'uscita, MAI solo nel renderer del referto: esito ≠ OK ⇒ exit ≠ 0 |
| **86** | ogni orario nel referto dichiara il suo orologio; barre _EXT = ora server BCM (shift +5 verificato all'import) |
| **87** | ogni confronto dichiara il VERSO: DD come magnitudine positiva, profitti col segno; nessun `<=` letterale su grandezze col segno misto |
| **88** | pulizia degli artefatti condivisi PER CELLA subito prima del suo lancio, mai globale a inizio corsa; celle saltate ⇒ artefatti esistenti RACCOLTI con eta' dichiarata; rilancio solo con `-Rifai` |

---

## 9. ✍️ LE DECISIONI — **[DA FIRMARE]**

_Si firmano con **"FIRMO R113"** (eventualmente "con proposte", indicando
la D e il valore). Dopo la firma: il token di stato va tolto dal titolo E
da questo paragrafo, e il file va rigrepato per intero (checklist 82)._

1. **D1 — PERIMETRO**: un solo motore, `ABTG_SupRev_NAS_H1_Ottimizzato`,
   le 3 celle di R110 (metro / long / short), parametri congelati.
   Nessun secondo motore: R98 e' bocciato 0/6, non ha celle da portare.
2. **D2 — FINESTRE**: le sei del § 3, incluse **LATERALE_NAS
   2015.01-2016.06** (adattamento dichiarato: il 2019 sul NAS non e'
   laterale) e **VECCHIA 2011-2012** (solo rischio, regola B).
3. **D3 — BANCO**: modello OHLC su M1, spread fisso identico su tutte le
   finestre e dichiarato nel referto; limite costitutivo del § 1 in
   testa al referto; confronti SOLO _EXT-vs-_EXT.
4. **D4 — CAMPIONE**: unita' = USCITE (STAT_TRADES), dichiarata accanto
   a ogni n con l'equivalenza ~2 uscite ≈ 1 posizione (R112 § 3);
   soglie E.2 (20 / 8) della macchina di regime.
5. **D5 — LETTURA IPOTESI-S**: la griglia pre-dichiarata del § 6, compreso
   l'esito "motore per tutte le stagioni". Non si tocca dopo i numeri.
6. **D6 — RISCHIO**: G2 del § 4 — sfondamento (2× metro E >20%) in
   finestra avversa ⇒ segnalazione formale di revisione della sedia
   970913, decisione a Claudio; nessun automatismo su dati esterni.
7. **D7 — MAGIC**: blocco 763500-763557, schema `763500+F×10+C`,
   gemello +5; 970913 vietato e controllato dal driver.
8. **D8 — G5**: nessuna promozione, nessun cambio di stato, nessuna
   classifica mossa da questo round (vincolo D-C). Il round produce
   conoscenza di regime e basta.

---

_Dopo la firma: driver e **18 file prova** (3 celle × 6 finestre; i due
gemelli vivono DENTRO ogni file come asse magic, non sono file a parte —
36 sono le PASSATE) li prepara la sessione principale; questo file
diventa il cancello che il driver legge al pin, e la corsa parte senza
switch (lezione R110). Nota di costruzione per il driver: le finestre di
regime sono FINESTRE UNICHE senza split IS/OOS — `walkforward_generico`
costruisce SEMPRE le due gambe (righe 465-468), quindi il driver di R113
dovra' pilotare il tester con date proprie per finestra, non passare dal
generico cosi' com'e'. Da risolvere PRIMA del verificatore._
