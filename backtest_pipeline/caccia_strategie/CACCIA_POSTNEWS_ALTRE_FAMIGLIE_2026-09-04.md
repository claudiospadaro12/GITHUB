# 📰 QUALI ALTRE NOTIZIE ROSSE REGGONO IL MECCANISMO POST-NEWS

> **Ricognizione, 04/09/2026.** Mandato di Claudio: _"quali ALTRE notizie rosse
> ad alto impatto potrebbero essere tradate con LA STESSA filosofia (due ordini
> pendenti sul range post-notizia)? Per ognuna che sembra buona, serve capire il
> SIMBOLO giusto e il MECCANISMO esatto (orario, offset, quale asset reagisce
> di piu')."_
>
> 🔒 **Nessun EA toccato. Nessun codice scritto. Nessun `.set` creato. Nessun
> file prova scritto** (il mandato lo vieta esplicitamente: _"la costruzione di
> un nuovo calendario/preset e' un passo successivo che deciderà Claudio"_).
> Nessun forward toccato.
>
> Predecessori letti per intero prima di uscire, e **non riscritti qui**:
> `CACCIA_NOTIZIE_TASSONOMIA_2026-09-03.md` (19 famiglie mappate) ·
> `CACCIA_CANDELA_NEWS_2026-09-03.md` (3 meccanismi, 8 implementazioni, 0
> promossi) · `prove/POSTNEWS_CORSO_SPEC.md` · `REGISTRO_TEST.md` §2-ter ·
> `docs/REGOLAMENTO_FTMO_2026-08.md` §4 · `report/CONTRATTI_SEDIE.md` ·
> `report/ROTTA_PROP.md`.

---

## 0. 🔴 LE SEI RIGHE CHE CONTANO, SUBITO

1. 🎯 **Il candidato numero uno non e' una notizia: e' un'ORA. Le 15:00 server
   (10:00 ET).** ISM Manufacturing + ISM Services + CB Consumer Confidence
   escono **tutti e tre alla stessa ora**, **441 giornate distinte** nel
   calendario di casa 2010-2023 (**31,5/anno**), stabilita' d'orario
   **93,4%**, e — il numero che decide — **solo il 7,0% di quelle giornate ha
   un altro evento ad alto impatto dentro la finestra viva del trade.** E' il
   blocco **piu' pulito che esista nel nostro calendario**, misurato oggi. §4.A
2. 💰 **Il secondo candidato non costa nulla: e' l'ora che la sedia NFP usa
   gia'.** Allargando il filtro del CSV delle 13:30 server da NFP a
   **CPI + Retail Sales + PPI + Advance GDP**, le giornate distinte passano da
   **164** (solo NFP) a **609** — **+271%, con `InpActionHour/Min` invariato a
   13:45.** Zero input nuovi, zero righe di codice. §4.B
3. 🧱 **Il filtro numero 1 del mandato ("orario di rilascio FISSO") non e' un
   dettaglio: e' il coltello che taglia meta' del calendario, e oggi e'
   MISURATO, non supposto.** Sui 14 anni del file di casa, in ora server:
   BoJ Monetary Policy Statement **3,1%** di stabilita', BOJ Press Conference
   **20,3%**, discorsi Fed/BoE **9-16%**. 🪦 **Il Giappone non ha un evento
   automatizzabile: la gamba JPY del nostro parco resta senza famiglia news.** §5
4. ⚠️ **Anche il "fisso" degli USA non e' fisso al 100%, ed e' un difetto che
   la sedia NFP ha GIA' oggi.** Nelle ~4 settimane l'anno in cui il DST
   americano ed europeo sono sfasati, i dati delle 8:30 ET escono alle
   **12:30 server invece che 13:30**: **10 NFP su 174** (5,7%). In quelle
   giornate l'EA agisce a **news+75 minuti**, non a news+15. 🔴 **Non e' un
   rischio nuovo che introduco io: e' un rilievo su cio' che gira.** §3.2
5. 🇬🇧 **Il Regno Unito e' fuori per un motivo che nessun dossier di casa aveva
   ancora misurato: l'ONS ha SPOSTATO l'ora di rilascio.** GBP CPI y/y nel
   file di casa: **09:30 server x122 fino al 2019**, **07:00 server x30 dal
   2020**. Un solo `InpActionHour` non copre due regimi. §5
6. 🏛️ **In ottica prop la 15:00 e' regalata:** accendere il blocco ISM accanto
   alla sedia NFP esistente produce **due trade lo stesso giorno solo il 7,3%
   delle volte** (32 giornate in 14 anni ≈ **2,3/anno**). **Scorrelazione
   misurata, non sperata.** §6

---

## 1. 🎯 CONTROLLO POSITIVO — fonte per fonte

| fonte | bersaglio di controllo | esito |
|---|---|---|
| **CSV di casa** `biblioteca/dati/CALENDARIO_FF_High_2010-2023_UTC.csv` | 8.313 righe, intestazione `Data Ora;Impatto;Valuta;Titolo`, NFP di gennaio 2010 alle 13:30 UTC | ✅ **PASSA** — e' la fonte primaria di ogni numero misurato in questo dossier |
| **CSV di casa** `mql5/Files/abtg_news_postnews_2010_2025_UTC.csv` | 599 eventi + intestazione, 4 titoli | ✅ **PASSA** (186 Nonfarm, 186 Unemployment Rate, 143 ECB PC, 84 FOMC PC) |
| **ricerca web generale** | FOMC statement = 2:00 p.m. ET | ✅ **PASSA** — risposta corretta e coerente su piu' risultati |
| **bankofcanada.ca** | pagina eventi | 🔴 **EGRESS_BLOCKED — FONTE NULLA** (l'orario BoC viene da snippet di ricerca) |
| **bankofengland.co.uk** | date MPC | 🔴 **EGRESS_BLOCKED — FONTE NULLA** (l'orario BoE viene da snippet) |
| **nber.org · public.econ.duke.edu · sas.upenn.edu** | ABDV 2003, tabella dei coefficienti per annuncio | 🔴 **TUTTI EGRESS_BLOCKED — FONTI NULLE.** Tre tentativi, tre domini. §7 |

📌 **Conseguenza dichiarata:** la domanda del mandato _"quale asset reagisce di
piu'"_ **non ha una risposta VERIFICATA in questo dossier.** La tabella
accademica che la contiene (Andersen-Bollerslev-Diebold-Vega, *AER* 2003) e'
irraggiungibile da questa postazione, per la seconda caccia di fila. §7.

---

## 2. 🔧 IL VINCOLO CHE DECIDE TUTTO: cosa la MACCHINA di casa sa fare

> Letto oggi in `mql5/Experts/ABTG_PostNews.mq5` **v1.10, 666 righe**
> (il dossier del 03/09 ne contava 473: **la v1.10 e' cresciuta**, la scheda
> vecchia va letta come storica).

Un candidato non e' "una notizia interessante": e' **una notizia che questa
macchina puo' eseguire senza riscritture**. I cinque vincoli, letti nel sorgente:

| # | vincolo | dove sta nel codice | cosa implica per un candidato |
|---|---|---|---|
| 1 | **L'ora d'azione e' UNA COSTANTE dell'istanza** (`InpActionHour` / `InpActionMin`, righe 74-75, ora server) | non c'e' nessuna lettura dell'ora dell'evento dal CSV | 🔴 **l'evento DEVE uscire sempre alla stessa ora server.** E' il filtro #1 del mandato, ed e' meccanico, non estetico |
| 2 | **Il match sul calendario e' sulla DATA, non sull'ora** (`NewsToday`, riga 263: confronta anno/mese/giorno) | riga 516: _"NewsToday() confronta SOLO anno/mese/giorno"_ | 🟢 il fuso del CSV non conta · 🔴 **un solo evento per giornata per istanza** (`gPlacedDay`, riga 244) |
| 3 | **Il range e' le DUE candele M5 gia' chiuse** all'ora d'azione (`iHigh/iLow` shift [1] e [2]) | — | ⚙️ **azione = news+10 → tiene la candela della notizia** · **azione = news+15 → la butta.** E' l'ablazione A/B gia' agli atti (`POSTNEWS_CORSO_SPEC.md` §3.2) |
| 4 | **Filtro CSV: valuta + sottostringa del titolo + impatto minimo** (`InpNewsCurrencies`, `InpNewsTitleMatch`, `InpNewsMinImpact`, righe 89-91) | `StringFind` righe 271-272 | 🟢 **una famiglia nuova si accende cambiando UNA STRINGA**, se il calendario ce l'ha |
| 5 | **Offset / SL / TP in PIP fissi** (righe 95-98) | — | 🔴 lo stesso preset **non e' trasportabile** fra simboli a volatilita' diversa: SL/TP vanno **rimisurati per simbolo**, mai copiati |

### 🔎 E il rilievo che chiude una domanda del mandato

Il mandato descrive la terza famiglia viva come **"FOMC Statement"**.
🔧 **Correzione misurata:** il preset `ABTG_PostNews_FOMC_EURUSD.set` ha
`InpActionHour=19 / InpActionMin=40`. Nel file di casa, in ora server:

- **FOMC Statement** → **19:00** (2:00 p.m. ET) — 67 occorrenze su 113
- **FOMC Press Conference** → **19:30** (2:30 p.m. ET) — 49 su 73, **stabile
  su 19:30 dal 2013 in poi** (nel 2011-2012 era 19:15)

➡️ **[VERIFICATO per conteggio]** azione 19:40 = **news+10 sulla CONFERENZA
STAMPA**, non sullo Statement. **La sedia viva e' sulla conferenza stampa**, ed
e' coerente con la tesi del corso (_"una persona parla"_). Va scritto giusto,
perche' se un giorno si costruisce il CSV cercando `"FOMC Statement"` si prende
un evento **30 minuti prima** e il preset diventa news+40.

---

## 3. 📏 LA MISURA — stabilita' d'orario in ORA SERVER, famiglia per famiglia

> **Metodo, dichiarato:** `CALENDARIO_FF_High_2010-2023_UTC.csv` (8.313 righe,
> impatto High, 2010-2023), timestamp UTC convertiti in **Europe/London**
> (= ora server BCM: `REGISTRO_TEST.md`, Passo 0 di `ABTG_AllineaLondra`).
> "stab" = quota dell'orario piu' frequente. [VERIFICATO per conteggio]

### 3.1 🟢 Le famiglie con un orario server VERO

| famiglia | valuta | ora server | stab | n | copertura anni |
|---|---|---|---:|---:|---|
| **German Flash Manufacturing PMI** | EUR | **08:30** | **100,0%** | 102 | 2012-2023, con buchi 2016-2018 |
| **German Flash Services PMI** | EUR | **08:30** | **100,0%** | 57 | 2019-2023 |
| **German ZEW Economic Sentiment** | EUR | **10:00** | **100,0%** | 84 | 2010-2020 |
| **German ifo Business Climate** | EUR | **09:00** | 99,0% | 96 | buchi 2017-2022 |
| **GBP Official Bank Rate (BoE)** | GBP | **12:00** | 96,9% | 130 | 2010-2023 |
| **ISM Services PMI** | USD | **15:00** | 95,2% | 166 | 2010-2023 completa |
| **Non-Farm Employment Change** | USD | **13:30** | 94,3% | 174 | 2010-2023 completa |
| **CPI m/m USA** | USD | **13:30** | 93,5% | 108 | 2010-2023 |
| **ISM Manufacturing PMI** | USD | **15:00** | 93,2% | 177 | 2010-2023 **completa** |
| **Unemployment Claims** | USD | **13:30** | 93,2% | 470 | 🔴 **buco 2018-2022** |
| **ADP Non-Farm Employment Change** | USD | **13:15** | 92,9% | 156 | buchi 2018-2021 |
| **Retail Sales m/m USA** | USD | **13:30** | 92,2% | 167 | 2010-2023 completa |
| **Core Retail Sales m/m** | USD | **13:30** | 91,7% | 168 | 2010-2023 **completa** |
| **CB Consumer Confidence** | USD | **15:00** | 91,5% | 142 | buchi 2020-2022 |
| **CPI y/y USA** | USD | **13:30** | 91,1% | 168 | 2010-2023 **completa (12/12 ogni anno)** |
| **Advance GDP q/q** | USD | **13:30** | 91,1% | 56 | 2010-2023 **completa (4/4 ogni anno)** |
| **PPI m/m USA** | USD | **13:30** | 91,0% | 145 | buchi 2019-2021 |
| **ECB Press Conference** | EUR | **13:30** (→ **13:45** dal 2022) | 90,9% | 132 | 🟡 due regimi, gia' noto |

### 3.2 ⚠️ Il "9%" che manca non e' rumore: e' il DST sfasato — e morde gia' oggi

Gli eventi USA delle 8:30 ET stanno a **13:30 server** per ~92% dei rilasci e a
**12:30 server** per il resto. La causa e' deterministica e ricorrente:

- **marzo:** gli USA passano all'ora legale la **2ª domenica**, il Regno Unito
  l'**ultima** → ~3 settimane di sfasamento;
- **fine ottobre/novembre:** il Regno Unito torna all'ora solare l'**ultima
  domenica di ottobre**, gli USA la **1ª domenica di novembre** → ~1 settimana.

➡️ **[VERIFICATO per conteggio]** **NFP: 164 rilasci a 13:30, 10 a 12:30.**
🔴 **In quelle ~4 giornate l'anno la sedia NFP viva (azione 13:45) calcola il
range su candele che stanno 60-75 minuti DOPO la notizia, non 15.** Il trade
parte lo stesso, su un range diverso da quello che la strategia descrive.
**Non e' un difetto dei candidati nuovi: e' un difetto di cio' che gira**, e
vale per **qualunque** famiglia USA si aggiunga. 📌 Le due strade note
(nessuna delle due e' un mandato di questo dossier): (a) escludere quelle date
dal CSV, (b) leggere l'ora dell'evento dal CSV invece che dall'input — che e'
**una modifica al motore**, quindi decisione di Claudio.

🟢 **Il blocco tedesco non ha questo problema: 100,0% di stabilita'**, perche'
Germania e Regno Unito cambiano ora **lo stesso giorno**. E' l'unico blocco
perfetto del calendario.

---

## 4. ✅ I PROMOSSI — tre famiglie, in ordine di priorita'

> Ogni scheda dichiara **cosa terrei** (il motore, che e' gia' nostro) e **cosa
> va MISURATO** (mai inventato). Dove scrivo "da misurare", **non c'e' un
> numero da qualche parte che sto omettendo: non esiste.**

---

### 🥇 A. BLOCCO DELLE 15:00 SERVER — **ISM Manufacturing + ISM Services + CB Consumer Confidence**

```
NOME             Blocco 10:00 ET / 15:00 server (USD)
EVENTI           "ISM Manufacturing PMI" · "ISM Services PMI" · "CB Consumer Confidence"
VALUTA           USD
ORA SERVER       15:00  (= 16:00 ora italiana)   stab. 93,4% [VERIFICATO, n=485]
FREQUENZA        441 GIORNATE DISTINTE 2010-2023 = 31,5/anno
                 copertura ogni anno: 36 33 36 34 33 35 36 33 33 29 25 17 26 35
                 giornate con >1 evento del blocco: 12 su 441 (2,7%)
CONTAMINAZIONE   7,0% delle giornate ha un ALTRO evento high dentro la finestra
                 viva [news+15 .. news+90]  -> 31 su 441, di cui 16 Crude Oil
                 Inventories (15:30) e il resto discorsi
                 🥇 IL PIU' PULITO DEL CALENDARIO DI CASA
```

**TESI IN UNA RIGA**
> _"L'ISM esce 30 minuti dopo l'apertura di New York, quando il book e' gia'
> pieno e la sessione ha una direzione: il riprezzamento non e' uno spike su
> book vuoto ma una rottura di range che i partecipanti gia' presenti devono
> seguire."_
⚠️ **[INCERTO] Questa tesi NON ha appoggio in letteratura verificato oggi.**
La tassonomia del 03/09 lo dice gia' esplicitamente per il PMI/ISM (*"nessuna
letteratura trovata che dia al PMI un comportamento post-notizia
sfruttabile"*). **La tesi e' plausibile e falsificabile, non dimostrata.**

**MECCANICA PROPOSTA** (per analogia con la sedia NFP viva, non per misura)
| voce | valore | stato |
|---|---|---|
| ora azione | **15:10** (news+10, **tiene** la candela della notizia) oppure **15:15** (news+15, la **butta**) | 🔬 **e' l'ablazione A/B**: le due sedie vive fanno una ciascuna e nessuna delle due ha mai avuto un numero |
| range | max/min delle **2 candele M5 chiuse**, ombre incluse | ereditato dal motore |
| offset | BUY STOP = max **+3 pip** · SELL STOP = min **−2 pip** | ereditato dal preset NFP |
| SL / TP | 🔴 **DA MISURARE.** Punto di partenza dichiarato: **25 / 30 pip** (il preset NFP) — *non* 25/50 (ECB/FOMC, tarato su una conferenza stampa che dura un'ora) | — |
| scadenza pendenti | **16:25 server** (news+85) | 🔴 **NON** 16:59 come il preset NFP: vedi §6 |
| rischio | **0,65%** | 🔴 mai il 3,0% di default del corso |

**SIMBOLO**
- 🥇 **EURUSD** come primo banco. Motivo **misurato in casa**, non estetico:
  e' l'unico maggiore di cui abbiamo lo spread reale BCM archiviato — **mediana
  0,100-0,200 pip in sessione Londra** (`REGISTRO_TEST.md` R115, F9/H12). Con SL
  25 pip lo spread e' **0,4-0,8% dello stop**: sotto qualunque soglia di casa.
- 🥈 **USDJPY** come secondo banco: e' gia' il simbolo della sedia NFP, quindi
  il confronto "stesso motore, stesso simbolo, evento diverso" e' **pulito**.
- 🔴 **NIENTE INDICI su questo blocco.** 15:00 server cade **dentro** la
  finestra di `ABTG_Dow_Apertura_US` (15:30-19:30 IT = **14:30-18:30 server**,
  `report/CONTRATTI_SEDIE.md`). Due EA sullo stesso simbolo, nella stessa ora,
  sullo stesso evento = **violazione diretta della regola 1 di
  `ROTTA_PROP.md`**.
- ⚠️ **[INCERTO] Quale dei due reagisca di piu' NON lo so** e non lo invento:
  §7. Si misura in un passo 0 conta-occasioni sui due simboli.

**FTMO** — azione a **news+10 = 15:10 server**, cioe' **8 minuti dopo la fine**
della finestra vietata (±2 min). ✅ **Compatibile su qualunque tipo di conto.**
✅ **[VERIFICATO 04/09/2026, Claudio ha copiato la tabella letterale da
ftmo.com]**: ISM Manufacturing PMI, ISM Services PMI e CB Consumer Confidence
**NON compaiono nella lista dei "Restricted event"** (che per USD copre solo
Federal Funds Rate/Statement, Non-Farm Employment Change, Unemployment
Rate/Wages, GDP q/q, FOMC minutes, CPI y/y). **Questo blocco è fuori dalla
restrizione ANCHE su conto Standard funded, non solo in Challenge o su
Swing.** Buco chiuso: vedi `docs/REGOLAMENTO_FTMO_2026-08.md` §4.

**PUNTEGGIO**
```
[2] semplicita'          motore gia' scritto, si accende con 3 stringhe
[2] il filtro E' il motore  senza l'evento non esiste il trade (InpRestrictToNews)
[1] tesi di mercato      scrivibile, ma SENZA appoggio in letteratura
[2] riempie un BUCO      ora server 15:00-16:25 = fascia non toccata da nessuna
                         sedia guidata da EVENTO; +31,5 occasioni/anno alla
                         famiglia piu' scorrelata del parco
[2] testabile senza riscritture   zero input nuovi, zero righe nuove
= 9/10  -> 🟢 PROVA SUBITO
```

**🏛️ In ottica prop, questo motore...**
- **aggiunge 31,5 giornate l'anno** alla sola famiglia del parco che non
  condivide il fattore di rischio con nessun'altra (`CACCIA_CANDELA_NEWS` §6);
- **e non le somma dove fa male:** coincide con una giornata del blocco 13:30
  solo il **7,5%** delle volte (33 su 441) e con l'**NFP** solo il **7,3%**
  (32 su 441 = **2,3 giornate l'anno**). 🟢 Con 1 R per evento, **il cap C1
  (3,25% aperto = 5 SL vivi) non viene nemmeno sfiorato**;
- ⚠️ **la peggior giornata e' da misurare**, non da assumere: il metro di casa
  e' −2,06% (R51), e un evento nuovo puo' avere una coda diversa.

---

### 🥈 B. ALLARGAMENTO DEL BLOCCO 13:30 — **CPI + Retail Sales + PPI + Advance GDP**

```
NOME             Blocco 8:30 ET / 13:30 server (USD), oltre l'NFP
EVENTI           "CPI y/y" · "CPI m/m" · "Core CPI m/m" · "Retail Sales m/m" ·
                 "Core Retail Sales m/m" · "PPI m/m" · "Advance GDP q/q"
VALUTA           USD
ORA SERVER       13:30    stab. ~91-94% per famiglia [VERIFICATO]
FREQUENZA        609 GIORNATE DISTINTE 2010-2023 = 43,5/anno
                 (contro le 164 giornate = 11,7/anno del solo NFP: +271%)
COMPLETEZZA      CPI y/y 12/12 ogni anno per 14 anni · Core Retail Sales 12/12
                 ogni anno · Advance GDP 4/4 ogni anno · Retail Sales 167/168
                 🔴 PPI ha buchi 2019-2021 (0 righe nel 2020)
CONTAMINAZIONE   28,1% delle giornate ha un altro evento high in finestra
                 (57 volte Prelim UoM alle 15:00, 24 ISM Services, 22 Philly Fed)
```

**TESI IN UNA RIGA**
> _"Il motore range-M5 + OCO non dipende dal TIPO di evento ma dal fatto che ci
> sia un rilascio programmato che riprezza il dollaro: se e' vero, ogni dato
> delle 8:30 ET vale quanto l'NFP."_
🟢 **E' la domanda che i due dossier del 03/09 avevano gia' isolato come "la
mossa che vale il round"** (`CACCIA_CANDELA_NEWS` §7). Qui la porto avanti di
un passo: **non due famiglie, ma il blocco intero**, e con le giornate contate.

**MECCANICA PROPOSTA** — 🟢 **identica al preset NFP vivo, cambia solo il CSV**
| voce | valore |
|---|---|
| ora azione | **13:45** — 🟢 **gia' cosi'** in `ABTG_PostNews_NFP_USDJPY.set` |
| offset / SL / TP | **+3 / −2 pip**, **25 / 30 pip** — 🟢 gia' cosi' |
| scadenza pendenti | 🔴 **da accorciare a 14:45 (news+75)**: oggi il preset dice **16:59**, cioe' una finestra viva di **3 ore e mezza** che contiene le 15:00 (UoM, ISM) — vedi §6 |
| rischio | **0,65%** (il preset NFP oggi dice 1,30) |
| istanza | 🟢 **UNA sola**, con `InpNewsTitleMatch` allargato e **lo stesso magic**: cosi' `gPlacedDay` garantisce **1 trade/giorno** anche quando due dati coincidono |

**SIMBOLO** — **USDJPY**, per continuita' con la sedia NFP viva (magic 771203):
e' l'unico modo di ottenere un confronto **a simbolo costante** fra "NFP" e
"resto del blocco 13:30". EURUSD come banco gemello.
⚠️ **Attenzione al doppio conteggio, gia' segnalato il 03/09 e confermato oggi:**
NFP, Unemployment Rate e Average Hourly Earnings **escono nello stesso minuto**
(463 righe, **164 giornate**). Con un match largo il CSV mostra **tre eventi**
dove il prezzo ne vede **uno**.

**FTMO** — azione **13:45 = news+15**. ✅ Compatibile.
✅ **[VERIFICATO 04/09/2026, tabella letterale ftmo.com]** — CORREZIONE rispetto
alla stima iniziale: **solo GDP q/q e CPI y/y sono nella lista restricted per
USD. CPI m/m, Retail Sales e PPI NON ci sono.** Quindi buona parte di questo
blocco (CPI m/m, Retail Sales, PPI) è **fuori dalla restrizione anche su
Standard funded** — solo GDP q/q e (se mai si aggiungesse) CPI y/y andrebbero
trattati con l'accorgimento del minuto. Con la scadenza accorciata a
14:45 la finestra viva **non tocca nessun altro evento delle 15:00**.

**PUNTEGGIO**: `[2] semplicita' · [2] filtro=motore · [2] tesi · [1] buco
(stessa ora e stesso simbolo della sedia NFP: allarga, non diversifica) ·
[2] testabile` = **9/10 → 🟢 PROVA SUBITO**

**🏛️ In ottica prop...** 🟢 **+31,8 giornate l'anno a costo zero.**
🔴 Ma **allo stesso orario e (se si sceglie USDJPY) sullo stesso simbolo della
sedia NFP**: e' **frequenza**, non scorrelazione. Se si accendono ISM (A) e
blocco 13:30 (B) insieme, le due si sovrappongono **solo il 7,5% dei giorni** —
🟢 **e' la coppia giusta.** Se invece si accendono B e NFP come **istanze
separate**, servono magic diversi e il rischio va **diviso**, non raddoppiato.

---

### 🥉 C. INITIAL / UNEMPLOYMENT CLAIMS — **il campione di frequenza, con un prezzo**

```
NOME             Unemployment Claims (Initial Jobless Claims)
VALUTA           USD
ORA SERVER       13:30  (8:30 ET, ogni GIOVEDI')  stab. 93,2% [VERIFICATO]
                 [VERIFICATO su ricerca: DOL, ogni giovedi' 8:30 ET, eccezione
                  quando il giovedi' e' festa federale]
FREQUENZA        52/anno VERE.  Nel file di casa: 438 giornate distinte,
                 ma per anno: 50 50 50 49 49 47 50 48 | 1 0 6 0 0 | 38
                 🔴 IL FILE E' ROTTO 2018-2022: cinque anni quasi vuoti
CONTAMINAZIONE   40,6% -- la PEGGIORE dei tre promossi (Philly Fed, ISM
                 Services, Pending/Existing Home Sales alle 15:00)
```

**TESI IN UNA RIGA**
> _"E' l'unico dato macro USA settimanale: il mercato ci arriva senza il
> posizionamento pesante di un CPI, quindi la sorpresa e' piccola ma il
> riprezzamento e' pulito e ripetibile 52 volte l'anno."_
🟡 **[INCERTO da snippet, pagina non aperta]** ABDV 2003 elenca *"gross
domestic product, jobless claims, and nonfarm payroll"* fra le sorprese che
muovono sia l'order flow sia il cambio. **Non ho letto il paper** (§7): e' un
indizio, non un appoggio.

**MECCANICA** — identica al blocco 13:30 (§B): azione 13:45, scadenza 14:45.

**SIMBOLO** — **EURUSD** o **USDJPY**, da misurare. ⚠️ Qui il punto e' un
altro: **la sorpresa media e' piccola**, quindi con `SL 25 / TP 30 pip` fissi
**il rapporto movimento/costo peggiora**. 🔴 Il preset NFP **non e'
trasportabile qui**: SL e TP vanno rimisurati, altrimenti si compra rumore
allargato dallo spread.

**PERCHE' E' TERZO E NON PRIMO, nonostante 52 eventi l'anno**
1. 🔴 **Il calendario NON C'E'.** Cinque anni vuoti nel file di casa: si
   dovrebbe **costruire** una serie nuova. 🟢 Fattibile — il DOL pubblica
   l'archivio completo e le date sono deterministiche (ogni giovedi') — ma
   **e' un lavoro, non un cambio di stringa.**
2. 🔴 **40,6% di contaminazione**: il doppio del blocco 13:30 e sei volte il
   blocco ISM.
3. 🔴 **Il rischio giornaliero e' settimanale.** 52 eventi l'anno significa
   **un trade ogni giovedi'**, cioe' una **serie temporalmente fitta** sullo
   stesso motore: e' esattamente la forma che il **DD trailing** di certe prop
   punisce (`ROTTA_PROP`/`METRO_PROP`), e le nostre Monte Carlo sono tutte su
   **DD statico**.

**VERDETTO: 🟡 IN CODA** — si promuove **dopo** che A e B hanno dato un segno,
perche' se il motore non regge su 441 e 609 giornate gia' disponibili, non ha
senso costruire un calendario nuovo per provarlo su una terza.

---

### 🟡 D-E. I DUE "IN CODA" MINORI, per completezza

| famiglia | ora server | n giornate | perche' non e' promossa ora |
|---|---|---:|---|
| **ADP Non-Farm Employment Change** | **13:15** (92,9%) | 143 (10,2/anno) | 🔴 **32,9% di contaminazione**, di cui **24 volte le Unemployment Claims** (stesso giorno). Bassa frequenza. 🟡 Unico pregio: e' l'unico evento del calendario alle **13:15**, cioe' un'ora tutta sua |
| **German Flash PMI (Manu + Serv)** | **08:30** (**100,0%** — l'unico perfetto) | 102 (7,3/anno) | 🔴 buchi enormi nel file (2016-2018 quasi vuoti) · 🔴 **45,1% di contaminazione**, e la fonte e' il **PMI UK 30 minuti dopo** · 🔴 08:30 server e' dentro la finestra di `ABTG_DAX_Apertura_EU` (**su D30EUR e' vietato**; su EURUSD sarebbe libero) |

---

## 5. 🚫 GLI SCARTATI — una riga di motivo a testa, e il motivo e' MISURATO

| famiglia | valuta | motivo dello scarto | prova |
|---|---|---|---|
| **BoJ Monetary Policy Statement** | JPY | 🔴 **NON HA UN'ORA DI RILASCIO.** Stabilita' **3,1%**: gli orari piu' frequenti sono 03:49, 04:14, 03:50, 05:31 — quattro orari diversi con 4, 4, 4 e 3 occorrenze | n=130, misurato |
| **BOJ Press Conference** | JPY | 🔴 stessa cosa: stabilita' **20,3%** (07:30 x26, 06:30 x19, 07:32 x8...) | n=128 |
| **Discorsi (Fed Chair, BoE Gov, ECB President)** | tutte | 🔴 **non sono eventi, sono finestre.** Stabilita': Draghi **16,0%**, Carney **9,5%**, Bailey **10,0%**, King **33,9%** | n=181/158/90/56 |
| **Prelim UoM Consumer Sentiment** | USD | 🔴 **stabilita' 52,8%**, e per un motivo peggiore del DST: l'orario e' **cambiato da 14:55 a 15:00 nel 2015**. Cinque minuti su M5 = **una candela intera** | 14:55 x57 (≤2014), 15:00 x44 (≥2015) |
| **Philly Fed Manufacturing Index** | USD | 🔴 **due regimi**: 15:00 fino al 2014, **13:30 dal 2015**. Stabilita' 67,0% | n=94 |
| **UK CPI / GDP / Retail Sales / Claimant Count (ONS)** | GBP | 🔴 **l'ONS ha spostato l'ora**: CPI y/y **09:30 x122 (≤2019) → 07:00 x30 (≥2020)**; GDP m/m 07:00 x18 / 09:30 x16; Claimant Count 09:30 x87 / 07:00 x17. Un solo `InpActionHour` non copre due regimi. [VERIFICATO su ricerca: l'ONS ha anticipato a 7:00 durante il Covid e l'ha reso permanente] | misurato |
| **BoE Official Bank Rate** | GBP | 🟡 **orario ottimo (12:00 server, 96,9%) ma frequenza fatale: 8/anno.** 130 eventi in 14 anni: sotto il pavimento di casa (IS ≥150 op) su qualunque finestra ragionevole. [VERIFICATO su ricerca: decisione + verbali alle 12:00 UK] | n=130 |
| **BoC Interest Rate Decision** | CAD | 🔴 **8/anno.** [VERIFICATO su ricerca: 09:45 ET = **14:45 server**, conferenza ~10:30 ET] — orario buono, frequenza no. In piu' il calendario di casa non marca il CAD ad alto impatto | tassonomia 03/09 §2.2 |
| **RBA Interest Rate Decision** | AUD | 🔴 **l'ora server NON e' fissa**: 14:30 Sydney con **due calendari DST diversi** (Australia e Regno Unito) → oscilla fra **03:30 e 05:30 server**. [VERIFICATO su ricerca: 2:30 pm AEST/AEDT, 8 riunioni/anno dal 2024] + frequenza 8/anno | — |
| **RBNZ · SNB** | NZD · CHF | 🔴 **frequenza 7 e 3,8/anno.** SNB: [VERIFICATO su ricerca] 09:30 CET = **08:30 server**, quattro volte l'anno. Con ≥150 operazioni per finestra servirebbero **~40 anni** | tassonomia 03/09 §2.2 |
| **Crude Oil Inventories** | USD | 🔴 stabilita' **78,3%** (15:30 x119, 16:00 x25 nelle settimane di festa) e nel file **solo 2016-2020**. E lo strumento naturale e' il **WTI, che non tradiamo** | n=152 |
| **EUR CPI flash · Employment Change CA/AU · CPI CA/AU/CH** | EUR/CAD/AUD/CHF | 🔴 **non valutabili con i dati di casa**: nel file Forex Factory non ci sono, nel file MQL5 sono a **impatto 2** e con un'ora **sbagliata di un'ora** (difetto gia' documentato in `costruisci_news_postnews.py`, righe 90-92). **Nessuna misura possibile → nessun candidato**, non "scartati per demerito" | — |
| **FOMC Statement come famiglia SEPARATA** | USD | 🔴 non aggiunge **nessuna giornata**: esce **gli stessi giorni** della conferenza stampa, 30 minuti prima. Zero guadagno di frequenza, e stabilita' 59,3% per via del regime 2:15 p.m. ET pre-2013 | n=113 |
| **Pre-announcement drift D-1/D-2** | — | 🔴 gia' scartato il 03/09 e **non lo riapro**: e' long su indice overnight = doppione del nostro libro, 32 eventi/anno, IS da ~19 anni | tassonomia 03/09 §3.A |
| **Spike & fade (Ederington-Lee)** | — | 🪦 **lapide gia' scritta il 03/09**: orizzonte 40 secondi, sotto M5, dentro la finestra vietata FTMO | `CACCIA_CANDELA_NEWS` §2.1 |

### 🪦 E la riga che vale piu' di tutte le altre messe insieme

> **Il Giappone non ha un evento automatizzabile.** L'unica famiglia JPY ad alto
> impatto e' la BoJ, e la BoJ **non pubblica a un'ora fissa** (3,1% e 20,3% di
> stabilita', misurati su 258 righe). ➡️ **Nessun motore a orario fisso puo'
> lavorare sullo yen come VALUTA DELLA NOTIZIA.** Lo yen resta utilizzabile solo
> come **gamba passiva** (USDJPY su notizia USD, EURJPY su notizia EUR) — che e'
> esattamente cio' che le due sedie vive gia' fanno. **Non e' una scelta: e' un
> vincolo del calendario giapponese.**

---

## 6. 🏛️ IL CANCELLO PROP — e un rilievo su cio' che gira

**I muri** (`report/METRO_PROP.md`): DD totale **10%** · DD **giornaliero 5%**
(−5.000 su 100k) · cap di casa **C1 3,25% di rischio aperto = 5 SL vivi a 0,65%**.

| candidato | occasioni/anno | trade/giorno | sovrapposizione con le sedie news vive | verdetto prop |
|---|---:|---|---|---|
| **A. ISM 15:00** | 31,5 | 1 (garantito da `gPlacedDay`) | **7,5%** col blocco 13:30 · **7,3%** con l'NFP (2,3 giornate/anno) | 🟢 **il migliore**: frequenza nuova, ora nuova, quasi zero collisione |
| **B. blocco 13:30** | 43,5 | 1 per istanza | **100%** dell'ora e (se USDJPY) del simbolo della sedia NFP | 🟡 **allarga, non diversifica**: una sola istanza, magic unico, rischio non raddoppiato |
| **C. Claims** | 52 | 1 | 40,6% di contaminazione, serie settimanale fitta | 🟡 rischio di forma "a scalini" → **il DD trailing la punisce**, e non l'abbiamo mai ricalcolato |

### 🔴 IL RILIEVO — la scadenza del preset NFP vivo e' lunga tre ore e mezza

`ABTG_PostNews_NFP_USDJPY.set` (e la copia LIVE del 04/09) hanno
`InpExpiryHour=16 / InpExpiryMin=59` con azione alle 13:45.
➡️ **La finestra viva e' 13:45 → 16:59 server: 3 ore e 14 minuti**, e contiene
**le 15:00**, cioe' l'ora di ISM, CB Consumer Confidence e (dal 2015) UoM.

Due conseguenze, entrambe misurate:
1. 📉 **Contaminazione del segnale.** Nella finestra [news+15 .. news+90] la
   contaminazione del blocco 13:30 e' del **28,1%**; allungando fino a
   news+209 quel numero **puo' solo salire**, perche' incorpora l'intera
   fascia 15:00 (57 UoM + 24 ISM Services + 11 ISM Manufacturing sono gia'
   dentro la finestra corta).
2. 🧱 **Rischio FTMO in USCITA.** L'insidia gia' scritta il 03/09
   (_"un EA news FTMO-compatibile ha bisogno del calendario per USCIRE"_) qui
   e' **quantificata**: con la scadenza a 16:59 lo SL/TP puo' scattare dentro
   la finestra ±2 min delle 15:00 in almeno il **28%** delle giornate. Il TP a
   30 pip e lo SL a 25 rendono lo scatto probabile, non teorico.

📌 **Non e' un mandato di questo dossier** (non tocco preset ne' EA). E' un
rilievo da mettere davanti a Claudio: **la scadenza a news+75/85 e' la
configurazione che i due dossier del 03/09 descrivono, quella a 16:59 no.**

### 🎯 La coppia che consiglierei di accendere insieme
**A (ISM, 15:10, EURUSD) + B (blocco 13:30, 13:45, USDJPY)**: ore diverse,
simboli diversi, e **sovrapposizione misurata al 7,5%**. Le due sedie news
esistenti (ECB 14:00 EURJPY, FOMC 19:40 EURUSD) restano su ore ancora diverse.
➡️ **Quattro ore server distinte — 13:45, 14:00, 15:10, 19:40 — su tre
simboli.** Per una prop dove **il DD e' UNO**, e' la definizione operativa di
scorrelazione.

---

## 7. 🚧 COSA NON HO POTUTO VEDERE — e la domanda del mandato che resta aperta

- 🔴 **"Quale asset reagisce di piu'" NON HA RISPOSTA VERIFICATA.** La fonte
  canonica e' Andersen-Bollerslev-Diebold-Vega, *Micro Effects of Macro
  Announcements: Real-Time Price Discovery in Foreign Exchange*, **AER 2003**
  (NBER w8959): contiene la tabella dei coefficienti annuncio-per-annuncio su
  DEM/GBP/JPY/CHF/EUR contro USD. **Tre domini tentati oggi, tre bloccati:**
  `nber.org`, `public.econ.duke.edu`, `sas.upenn.edu`. Dallo snippet di
  ricerca [INCERTO, pagina non aperta]: *"the nonfarm payroll is among the most
  significant of the announcements for all of the markets"*, *"announcement
  surprises in gross domestic product, jobless claims, and nonfarm payroll
  affect both order flows and exchange-rate changes"*, e *"bad news has greater
  impact than good news"*.
  🎯 **La strada di casa che NON dipende da quel paper:** un **passo 0
  conta-occasioni** con l'EA che gia' abbiamo, stessa data, due o tre simboli —
  misura **il nostro** broker sui **nostri** costi, che e' l'unica cosa che poi
  conta nel tester.
- 🔴 **La lista letterale FTMO dei "Restricted event"** — `ftmo.com` bloccato,
  **terza caccia consecutiva**. Resta aperta la domanda: **ISM e CB Consumer
  Confidence sono restricted?** Sono 2 minuti di lavoro **dal browser di
  Claudio** e chiudono un buco che io non posso chiudere.
- 🔴 **Forex Factory e Investing** — bloccate (403 / egress), come il 03/09.
  Tutti i numeri di frequenza di questo dossier vengono dall'**estratto** in
  casa: dove il file ha buchi (Claims, PPI, ADP, ifo, German PMI) i conteggi
  sono un **limite inferiore**, ed e' segnato famiglia per famiglia.
- 🟡 **Il calendario ad alto impatto per CAD/AUD/NZD/CHF/EUR-flash non esiste
  in casa.** Non e' "scartato": e' **non valutabile**. Se un giorno servisse,
  va scaricato prima.
- 🟡 **`@DAQUANDO` non e' stato misurato** — non ho MT5, e la regola di casa
  vieta di ipotizzarlo. 🟢 Ma il vincolo qui probabilmente **non e' il prezzo**:
  sul forex abbiamo **~27 anni di M1 OHLC misurati (pavimento 1999)**
  (`REGISTRO_TEST.md`, correzione R102) — **il collo di bottiglia e' il
  CALENDARIO (2010-2023), non lo storico.** Da confermare con la sonda.

---

## 8. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> 🎯 **"Il motore range-M5 + OCO di `ABTG_PostNews` funziona su un evento che
> esce a mercato USA GIA' APERTO (ISM, 15:00 server) come su uno che esce a
> mercato chiuso (NFP, 13:30 server)?"**

E' la domanda giusta per tre motivi, tutti verificabili prima di guardare un
numero:

1. **Separa il MOTORE dal SEGNALE**, che e' l'ablazione che questo progetto sa
   fare — e stavolta con **441 giornate** invece delle 164 dell'NFP, cioe' con
   un campione che per la prima volta **puo' superare il pavimento dei 150
   trade per finestra** (Emendamento A). 🟢 **Sulla famiglia news e' la prima
   volta.**
2. **Cambia UNA cosa sola**: l'evento e l'ora. Motore identico, offset
   identici, gestione identica. Se va uguale, **il motore e' l'edge**; se va
   peggio, **la fascia oraria conta** — e in entrambi i casi abbiamo
   un'informazione che oggi non abbiamo.
3. **E' l'unica delle tre che non richiede di costruire niente**: il
   calendario ISM e' **gia' nel file di casa**, completo su 14 anni su 14.

⚠️ **Le tre cose da congelare PRIMA dei numeri** (criteri, non risultati):
- **`InpRiskPercent = 0,65`** — non 3,0 (default del corso), non 1,30 (preset NFP);
- **scadenza a news+85 (16:25 server)**, non 16:59: altrimenti la finestra viva
  contiene altri eventi e il test misura due cose insieme;
- **il verdetto sul MERITO resta sospeso finche' n < 150 per finestra**
  (valvola R59 / Emendamento B). 🟢 **Sul RISCHIO invece si giudica sempre**:
  DD e peggior giornata sono fatti accaduti, a qualunque n.

🔴 **E la regola che non si vende:** OHLC solo screening, **verdetti solo a tick
reali** (R57: cambiando solo il modello il segno si e' ribaltato), **centro
dell'altopiano, mai la cella migliore** (12 Spearman IS→OOS negative su 13).

---

## 9. 🔗 FONTI (04/09/2026)

**In casa (misurate oggi, riga per riga):**
- `backtest_pipeline/caccia_strategie/biblioteca/dati/CALENDARIO_FF_High_2010-2023_UTC.csv` — **8.313 righe**, tutte le misure di §3, §4, §6
- `mql5/Files/abtg_news_postnews_2010_2025_UTC.csv` — 599 eventi + intestazione
- `mql5/Experts/ABTG_PostNews.mq5` — **v1.10, 666 righe**, vincoli di §2
- `mql5/Presets/ABTG_PostNews_{ECB_EURJPY,FOMC_EURUSD,NFP_USDJPY,NFP_USDJPY_LIVE_2026-09-04}.set`
- `backtest_pipeline/costruisci_news_postnews.py` — difetto d'ora della sorgente MQL5, righe 90-92
- `backtest_pipeline/prove/POSTNEWS_CORSO_SPEC.md` · `backtest_pipeline/REGISTRO_TEST.md`
- `backtest_pipeline/caccia_strategie/CACCIA_NOTIZIE_TASSONOMIA_2026-09-03.md` · `CACCIA_CANDELA_NEWS_2026-09-03.md`
- `docs/REGOLAMENTO_FTMO_2026-08.md` §4 · `report/CONTRATTI_SEDIE.md` · `report/ROTTA_PROP.md`

**Fuori (aperte o lette da snippet di ricerca, etichettate nel testo):**
- ricerca `FOMC statement release time` — controllo positivo, 2:00 p.m. ET · federalreserve.gov (elenco risultati)
- ricerca `Bank of Canada interest rate announcement time` — **09:45 ET**, conferenza ~10:30 ET
- ricerca `Bank of England MPC Bank Rate announcement time` — **12:00 ora UK**, 8 volte l'anno
- ricerca `Swiss National Bank monetary policy assessment` — **09:30 CET**, 4 volte l'anno, conferenza 10:00
- ricerca `RBA monetary policy decision announcement time` — **14:30 AEST/AEDT**, 8 riunioni/anno dal 2024
- ricerca `BLS CPI PPI release time` — **8:30 a.m. ET** (CPI 11/09/2026, PPI 10/09/2026)
- ricerca `ONS statistical releases 7am` — tutte le macro ONS alle **07:00 UK**, spostate dalle 09:30 durante il Covid e rese permanenti
- ricerca `US initial jobless claims` — **ogni giovedi', 8:30 a.m. ET**, DOL
- ricerca `Andersen Bollerslev Diebold Vega` — paper individuato, **PDF non aperto** (3 domini bloccati)

**Fonti NULLE dichiarate oggi:** `nber.org` · `public.econ.duke.edu` ·
`sas.upenn.edu` · `bankofcanada.ca` · `bankofengland.co.uk`
(e, per continuita' con il 03/09: `ftmo.com` · `forexfactory.com` ·
`investing.com` · `ssrn.com`).
