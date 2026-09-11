# 🌙 CACCIA NOTTE — 12/09/2026 · livello NOTTURNO + motori su EVENTO

_Mandato: due filoni. (1) meccanismi **diversi dal breakout** sul riferimento
**massimo/minimo della notte** (il metodo a mano di Claudio, `Europe/Rome
00:00-08:00`); (2) motori su **rilascio programmato** (CPI/NFP/FOMC) su **oro e
indici**, varianti sul **come si entra DOPO** il dato._

---

# 0. 🥇 LA RIGA CHE VA LETTA PER PRIMA

> ## Su **9 candidati arrivati al sorgente** (5 file `.mq5`/`.mqh` scaricati e letti riga per riga + 3 articoli MQL5 col codice in pagina + 1 README GitHub), **ZERO motori promossi**.
> **Non e' una resa: e' che ogni meccanismo trovato stanotte sul livello notturno cade su una lapide di casa CHE HA GIA' IL NUMERO** — e le lapidi le ho verificate una per una in `REGISTRO_TEST.md`.
>
> 🔧 **L'unica cosa che porto a casa e' un ATTREZZO, e va dichiarato come tale (ponteggio, non sedia):** `Calendar-Based Backtesting` (Code Base **55630**, Muller Peter, 06/02/2025) — **sorgente letto, 3 file, 492 righe, nessuna bandiera §4** (gli unici due match del grep sono il campo `multiplier` di `MqlCalendarEvent`, §4) — scrive gli `MqlCalendarValue` (**actual + forecast + prev**) in un file binario nella cartella **COMMON** e li rilegge **dentro lo Strategy Tester**.
> 🎯 **E' esattamente il blocco dichiarato il 05/09**: _"UNICO MECCANISMO ANCORA IN PIEDI, e NON misurabile da qui: la SORPRESA (actual vs forecast)"_.

---

# 1. 🎯 CONTROLLO POSITIVO — fonte per fonte, misurato stanotte (12/09/2026)

| fonte | bersaglio | esito misurato | verdetto |
|---|---|---|---|
| **MQL5 Code Base** (elenco) | `mql5.com/en/code/mt5/experts` | **200** · 85.612 byte · id veri estratti (77236, 77234, 77232, 77220, 77206) | 🟢 **PASSA** |
| **MQL5 Code Base** (scheda) | `/en/code/55064`, `/55630`, `/76951` | **200** · 65.492 / 66.573 / 62.057 byte · `<meta description>` con autore e data | 🟢 **PASSA** |
| 🥇 **MQL5 sorgente** | `/en/code/download/<ID>/<file>` | **200** su **5 file**: `FetchNews.mq5` 14.260 B · `CalendarRetriever.mq5` 2.212 B · `NewsBacktest.mq5` 15.916 B · `CalendarFile.mqh` 22.814 B · `CalendarExport.mq5` 14.613 B | 🟢 **PASSA** |
| **MQL5 Articoli** | `/en/articles/22196`, `/16752`, `/18486` | **200** · 202.250 / 156.195 / 118.836 byte · **codice sorgente nel corpo della pagina** | 🟢 **PASSA** |
| **arXiv API** | `export.arxiv.org/api/query` (3 query) | **200** · 14.248 / 21.036 / 19.344 byte · entry con titolo+data+id | 🟢 **PASSA** (solo HTTPS, conferma 05/09) |
| **TradingView** (suggest) | `/pubscripts-suggest-json/?search=liquidity` | **200** · 27.670 byte · JSON con `access` e `scriptIdPart` | 🟢 raggiungibile (titoli) |
| **raw.githubusercontent.com** | README di un repo puntato per nome | **200** · 10.031 byte | 🟢 **PASSA** (serve il percorso esatto) |
| 🔴 **github.com** (UI) | `/nsclk/Asian-Range-Breakout-...` | **403** | 🔴 **NON RAGGIUNTA** (coerente con 11/09) |
| 🔴 **codeload.github.com** | tarball `main` dello stesso repo | **403** (378 byte di JSON d'errore) | 🔴 **NON RAGGIUNTA** |
| 🔴 **data.jsdelivr.com** (aggiro per elencare i file del repo) | `/v1/packages/gh/...` | **000** — connessione fallita | 🔴 **NON RAGGIUNTA** |
| 🔴 **Quantpedia** | `/strategies/` con redirect seguiti | **502** | 🔴 **NON RAGGIUNTA** (l'11/09 era 308: **e' un 5xx, cioe' "non adesso", non "non esiste"**) |

⚠️ **Popolarita' (download/visualizzazioni) sulle schede Code Base: [NON MISURATO].**
I contatori sono renderizzati in JS, nell'HTML c'e' solo l'etichetta `Views:` vuota.
**Non li invento e non li peso.**

---

# 2. 🌙 FILONE 1 — IL LIVELLO NOTTURNO. Tre candidati letti, tre scarti, e il motivo e' SEMPRE lo stesso

## 2.1 La regola di casa che decide il filone (e non l'ho scritta io stanotte)

`REGISTRO_TEST.md` r.1773, verdetto del 03/09, verificato stasera:
> _"box su finestra oraria + rottura = ORB (~210 celle), box + fade = R42 (0/24 IS
> e 0/24 OOS). **Cambiare il LIVELLO non cambia la geometria**."_

E la **mappa delle geometrie gia' sepolte**, con i numeri presi dal registro:

| geometria sul box di sessione | dove sta in casa | 🔴 il numero |
|---|---|---|
| **rottura** (breakout) | `ABTG_MaxMinNotte` + ORB | ~**210 celle** girate; solo DAX **short** sopravvive (PF 1,19 → 2,0 col gate S&P) |
| **fade** (entra al contrario alla rottura) | R42 · seconda caccia post-news 05/09 | **0/24 IS e 0/24 OOS**; ISM **PF 0,85** EURUSD e **0,73** oro |
| **falsa rottura → rientro nel box** | `ABTG_BreakinBox`, chiuso 31/08 **a tick** | **PF 1,007 · DD 24,1%** — e l'ablazione lo smaschera come R95 con un livello nuovo |
| **sweep + reclaim** | R95 | **0/30** |
| **rottura → retest → ri-rottura** | `ABTG_IBRetest`, scartato 09/09 dal cancello C0 | **PF famiglia 0,7798 su n=344** (U30USD 0,38/0,70 · NASUSD 0,56/0,59 · D30EUR 1,21/0,96) |

👉 **Le cinque caselle della geometria sono tutte occupate, e tutte da un numero misurato in casa, tre delle quali a tick reali.**

## 2.2 I candidati trovati stanotte, e dove cadono

### 🚫 C1 — `Asian-Range-Breakout-Expert-Advisor-for-MT5` v2.03 (GitHub, `nsclk`, licenza **MIT dichiarata nel README**)
- **Letto:** README **completo** (10.031 byte via `raw.githubusercontent.com`, branch `main`), tabella input compresa. 🔴 **Il `.mq5` NON l'ho potuto leggere**: `AsianRangeEA_v2.03.mq5` alla radice del branch da **404**, la UI GitHub e' **403**, codeload **403**, jsDelivr **000**. **Per la regola 1 del mandato questo candidato e' NON VALUTABILE, non "promettente".**
- **Meccanica dichiarata dall'autore** (README §"How the Strategy Works", punti 3-5): chiusura di una candela M5 **fuori** dal range asiatico → si aspetta la chiusura **di nuovo dentro** → ingresso a mercato, **SL all'estremo fra rottura e rientro**, TP = multiplo dell'SL.
- 🔴 **SCARTO, e per due motivi indipendenti:** (a) **e' `ABTG_BreakinBox` riga per riga** — geometria chiusa a tick il 31/08 con **PF 1,007 e DD 24,1%** (contro il muro prop del 10%); (b) sorgente non leggibile.
- ⚠️ Rilievi dalla sola tabella input (e restano [INFERITO], non letti nel codice): `RiskPercentage = 2.0` di default (**3,1x il nostro 0,65%**) e **Telegram bot token** fra gli input → `WebRequest`, che e' bandiera §4.

### 🚫 C2 — MQL5 articolo **18486**, _Price Action Toolkit (Part 28): Opening Range Breakout Tool_
- **Letto:** l'articolo intero in testo (40.249 caratteri), **classe `CRetestSignal` compresa** — tre booleani `breakLong/breakShort/retested`, `OnBreak()` e `CheckRetest()`.
- **E' la geometria "rottura → retest → ri-rottura"**, cioe' la variante che il mandato chiedeva per il box notturno.
- 🔴 **SCARTO doppio:** (a) **NON e' un EA**: alla riga 1189 l'autore scrive testualmente _"Although we're **not sending orders here**, we include `static CTrade trade;` to show how you'd integrate real trades later"_ → produce frecce, `Alert()`, `SendMail()`, `SendNotification()`. **Niente ordini = niente backtest = fuori dall'imbuto.** (b) La geometria e' **gia' misurata in casa su un altro livello**: `ABTG_IBRetest`, **PF famiglia 0,78 su n=344**, tre indici, M30, tick reali.
- 🟡 **Cosa tengo (mestiere, non candidato):** la macchina a stati del retest sta in **tre booleani e due metodi**. Se un giorno si rifacesse, il costo di scrittura e' un'ora, non una settimana.

### 🚫 C3 — Code Base **75221** `Asian Session Breakout` e **72882** `SessionRangeBreakout`
- 🔴 **Fuori perimetro per costruzione: sono INDICATORI, non EA.** Disegnano il box e le frecce. **Nessun ordine, nessun SL, nessun backtest.** Registrati qui solo perche' non li si ricerchi il giro prossimo.

## 2.3 🔴 E LA COSA ONESTA DA DIRE SUL FILONE 1

**Il buco vero che il metodo di Claudio mostra NON e' un meccanismo d'ingresso da
importare: e' una manopola di casa.** Dal referto di oggi
`report/IL_TERZO_TRADE_E_I_LIVELLI_2026-09-11.md`:
- il suo box finisce alle **07:00 server**, i preset **vivi** finiscono alle **04:59** → due livelli diversi;
- `InpBoxEndHour=6` **e' gia' stato girato in archivio** (526 righe di CSV) e **non e' mai andato in campo**;
- e nel suo terzo trade il livello notturno era il **TARGET** (TP 4.358,05 contro "Max notturno" ~4.352,03), **non il trigger d'ingresso**: e' entrato alle **15:36 server**, cioe' **sette ore dopo** la finestra in cui `ABTG_MaxMinNotte` smette di operare (piazza 07:59, taglia 08:30).

> 🎯 **Tradotto: il livello notturno come TARGET di un motore diurno e' l'unico
> uso che NON ha una lapide nel cimitero** — perche' e' **gestione dell'uscita**,
> non geometria d'ingresso. E la gestione e' §5.F, cioe' la parte che sappiamo
> fare noi. 🔴 **Ma non e' un candidato da caccia: e' lavoro di casa su un EA
> che gia' esiste, e va chiesto a Claudio, non importato dal web.**

---

# 3. 📰 FILONE 2 — MOTORI SU EVENTO. Due EA letti nel sorgente, due scarti, e un attrezzo che vale

## 3.1 🚫 `NewsBacktest.mq5` (Code Base **55630**, Muller Peter, 06/02/2025) — come MOTORE
**Sorgente letto per intero: 178 righe, 4 input.** Righe 74-75:
```
trade.BuyStop (Volume, ask + TPPoints*_Point, NULL, ...);
trade.SellStop(Volume, bid - TPPoints*_Point, NULL, ...);
```
piazzati quando l'evento e' entro **50 secondi** (r.51), cancellati dopo `ExpirySeconds = 500`.

🔴 **SCARTO — tre motivi, e il primo e' MISURATO OGGI SUL CONTO DI CLAUDIO:**
1. **E' lo straddle classico**, che il mandato escludeva esplicitamente. E il
   contro-esempio non e' teorico: il **11/09 sulla CPI** i due pendenti sarebbero
   finiti nel whipsaw delle 13:30 (**−46 $ poi +106 $**), mentre l'ingresso vero
   e' arrivato a **news + 13 min 48 s** (`report/TRADE_MANUALI_CPI_2026-09-11.md`).
2. **`Volume = 0.1` fisso** (r.10): non e' rischio in %, non e' scalabile a 100k
   — motivo di scarto ricorrente del `SETACCIO_MANUALE.md`.
3. **`TPPoints/SLPoints = 150` punti MT5 identici per ogni simbolo**: su XAUUSD
   (`Point = 0,01`) sono **1,50 $** contro un costo pieno misurato di **0,2003 $**
   = **7,5x**, cioe' **sotto il pavimento DURO (13,3x)** e a **19%** del pavimento
   di lavoro (40x). 🔴 **Bocciato per COSTO prima che per merito**, come chiede la
   regola 3 del mandato.
4. 🐛 **E c'e' un bug vero nel filtro eventi** (r.112): `if(ct == containing.Length() - 1) return true;` — la funzione `StringContains` dichiara vero **un carattere prima** della fine della sottostringa: cercando `"cpi"` basta `"cp"`. **Chi lo girasse cosi' com'e' entrerebbe su eventi sbagliati e non lo saprebbe.**

## 3.2 🚫 `FetchNews.mq5` (Code Base **55064**, stesso autore, 21/01/2025)
**Sorgente letto: 169 righe, 5 input.** Stessa coppia di pendenti (r.102/106),
stesso `Volume = 0.1`, stessi 150 punti.

🐛 **Secondo difetto, ed e' peggio di come l'avevo scritto di primo acchito —
ho riletto le righe 60-115 apposta per rompere la mia stessa frase, e si e'
rotta:**
- riga **79**: `if(CalendarEvent.importance == CALENDAR_IMPORTANCE_MODERATE && Type == Alerting)`
  → in modalita' **Alerting** avvisa **solo** sugli eventi di importanza
  **MEDIA** (`==`, non `>=`), mentre la scheda promette _"**high-impact** forex
  news events"_: **sugli eventi ad alta importanza non avvisa**;
- righe **86-88**: nel ramo **Trading** **non c'e' NESSUN filtro di importanza**
  — si entra sul solo **nome** dell'evento. 🔴 **Combinato col bug di
  `StringContains`, il ramo che manda ordini e' quello meno filtrato dei due.**

🔴 **SCARTO** (e vale lo stesso conto di costo del §3.1: 150 punti su oro = 1,50 $ = **7,5x**).

## 3.3 🚫 MQL5 articolo **16752** _Developing a Calendar-Based News Event Breakout EA_
Letto in testo (54.386 caratteri). Meccanica dichiarata dall'autore (r.888):
_"For each closed bar, we check if there is a high-impact news event within the
next 5 minutes. If so, we place **buy stop and sell stop** orders within a given
deviation from the current bid price."_
🔴 **SCARTO: e' di nuovo lo straddle a due pendenti PRIMA del dato** — la cosa
che il mandato escludeva e che il conto di Claudio ha falsificato in diretta l'11/09.

## 3.4 🚫 MQL5 articolo **22196** _Turn News into a Reproducible Trading System_ — non e' un motore, **ma dice una cosa che ci riguarda**
Letto in testo (85.909 caratteri). Non contiene un EA: e' infrastruttura.
🟡 **Il pezzo che tengo** (§"typical mistakes", r.2622-2628), perche' e' una
**conferma esterna e indipendente** della nostra lapide del 05/09:
> _"The correct approach is to use the calendar as a **volatility filter, not as
> an entry trigger** … Golden rule: the calendar answers the question 'When to
> expect increased volatility?', **not 'Which direction to trade?'**"_

🔴 **Attenzione a come si usa questa citazione: e' un'opinione d'autore, non una
misura.** Vale come **contro-esempio da battere**, non come prova. Se la sonda
sulla sorpresa (§4) uscisse positiva, questa frase sarebbe semplicemente smentita
dai nostri dati — ed e' il modo giusto di trattarla.

## 3.5 🚫 `CalendarExport.mq5` (Code Base **76951**, GianlucaGangemi, 04/09/2026)
**Sorgente letto: 319 righe, ASCII, ben scritto** (UTF-8 esplicito, ordinamento
per tempo, decodifica delle entita' HTML, scrittura atomica: quattro difetti veri
evitati apposta). 🔴 **Ma NON serve al nostro scopo:** `InpHoursAhead = 48` /
`InpHoursBack = 3` → **e' un ponte per il forward, non un estrattore di storico.**
Utile semmai al Guardian, non alla misura della sorpresa.

---

# 4. 🔧 L'UNICA COSA CHE PORTO A CASA — e la dichiaro **PONTEGGIO**, non una sedia

## `CalendarRetriever.mq5` + `CalendarFile.mqh` (Code Base **55630**)

| | |
|---|---|
| **FONTE / URL** | https://www.mql5.com/en/code/55630 — `download/55630/CalendarRetriever.mq5`, `/CalendarFile.mqh` |
| **AUTORE / DATA** | Muller Peter (`Mullerp04`) · **2025.02.06** (`published_time` nella pagina) |
| **POPOLARITA'** | 🔴 **[NON MISURATO]** — contatori in JS |
| **LICENZA** | 🔴 **nessuna licenza libera dichiarata** nel sorgente (`#property copyright "Muller Peter"`). ➡️ **si LEGGE e si IMPARA il meccanismo, NON si copia.** Se serve, si riscrive in casa citando l'autore in testa al file |
| **RIGHE / INPUT** | 38 + 276 righe · **2 input** (`StartDate`, `EndDate`) |
| **BANDIERE ROSSE §4** | **NESSUNA.** Grep su `martingal\|multiplier\|grid\|recovery\|hedge\|#import\|WebRequest\|DLL\|ACCOUNT_LOGIN`: **0 in `CalendarRetriever.mq5`**, **2 in `CalendarFile.mqh`** — e le ho aperte: r.76 `FileWrite(handle, event.multiplier)` e r.154 `event.multiplier = (ENUM_CALENDAR_EVENT_MULTIPLIER)...`, cioe' il **campo `multiplier` della struttura `MqlCalendarEvent`** (mille/milione/miliardo), **non un moltiplicatore di lotto**. 🟢 Falso positivo del grep, dichiarato invece che nascosto. Non apre posizioni: scrive file |

**COSA FA, verificato riga per riga:**
- `CalendarFileWriter::WriteValueFile` (r.26-33) apre in `FILE_BIN|FILE_COMMON|FILE_WRITE` e scrive **gli `MqlCalendarValue` interi** con `FileWriteStruct` → dentro ci sono **`actual_value`, `forecast_value`, `prev_value`, `revised_prev_value`**;
- `WriteEventFile` / `WriteCountryFile` salvano nomi, importanza, paese, valuta;
- `CalendarFileReader::LoadValues` (r.162-166) rilegge con `FILE_BIN|FILE_COMMON|FILE_READ`.

> ## 🎯 **Il punto e' `FILE_COMMON`: la cartella comune e' leggibile DALLO STRATEGY TESTER.** Cioe' un EA in backtest puo' sapere, all'istante giusto, **quanto il dato ha sorpreso il consenso** — che e' precisamente la misura che il 05/09 e' stata dichiarata impossibile da qui.

## 🔴 I TRE BUCHI DI QUESTO ATTREZZO, prima che qualcuno si entusiasmi

1. **La profondita' del calendario nativo MT5 su BCM e' [NON MISURATA].** Il
   retriever ha `StartDate = D'2021.01.01'` di **default dell'autore**, il che
   **non dimostra niente** su quanto indietro arrivi il nostro terminale. 🎯 **E'
   una misura da due minuti sul VPS** (conto **50503392**, cartella
   `BCM Markets MT5 Terminal`) e va fatta **prima** di qualunque round.
2. **DST: [INCERTO].** Il 04/09 abbiamo misurato **10 NFP su 174 caduti a 12:30
   invece che 13:30**. Questo attrezzo salva il timestamp **cosi' com'e'**: non
   corregge niente. Chi lo usasse senza controllare rifarebbe l'errore.
3. **Non e' un motore.** Non compra e non vende: **abilita una misura**. Una
   giornata che produce solo questo **e' ponteggio, e va scritto cosi'** (regola
   del 10/09).

---

# 5. 🧪 IL CONTRO-ESEMPIO — come si falsifica cio' che propongo

**Quello che propongo e' UNA SONDA, non un EA.** Quindi il contro-esempio va
costruito sulla sonda, e lo costruisco qui.

| | |
|---|---|
| **IPOTESI** | la **sorpresa** (`actual − forecast`, normalizzata) predice il **segno** del movimento fra news+15' e news+45' su XAUUSD |
| 🔴 **COSA LA FALSIFICA** | il **controllo a ingressi casuali** sugli stessi giorni-evento. Il 05/09 quel controllo e' uscito **PF 1,00 / 1,06** — e **sull'oro ha guadagnato da solo (+0,055R)**. 👉 **Se la sonda con la sorpresa non batte il casuale, il meccanismo e' morto**, e non per poco: e' deriva 2010-2012 |
| 🔴 **SECONDO test che la ucciderebbe** | la **prova dell'epoca**. Sulla stessa famiglia l'uscita a tempo 30' faceva **+7,87 pip nel 2010-2011** e **+0,36 pip nel 2012-2020**: **l'84% del profitto dal 20% del campione**. Se il segnale della sorpresa vive solo nel blocco vecchio, e' la stessa trappola |
| 🔴 **TERZO, e sta nella letteratura che ho letto** | **Takahashi arXiv 2508.06788**: _"shocks dissipate almost entirely within a second"_; **Ben Omrane & Savaser 2016**: in regimi di forte avversione al rischio **il segno della reazione FX si INVERTE**. Se hanno ragione, al minuto 15 non resta niente da prendere |
| ⚠️ **PERCHE' potrebbe non funzionare DA NOI** | (a) **costo**: su XAUUSD il pedaggio pieno e' **0,2003 $** e il pavimento di lavoro **8,01 $** — il movimento deve restare grande **anche nei giorni normali**, non solo l'11/09 (**106 $ = 531x**); (b) **muro giornaliero prop**: gli eventi sono concentrati, e piu' simboli sullo **stesso** evento sono **la stessa scommessa** (tetto cluster 3,0% **firmato ma NON attivo nel Guardian**); (c) **orari in ora server**: CPI **13:30 server**, e il DST ci ha gia' morso |
| 📉 **FREQUENZA, il numero che decide se vale la pena** | i nostri CSV danno **452 giornate-evento distinte in 3,8 anni** = **~119/anno** = **~0,47 op/giorno** su un simbolo. **Sotto il pavimento di 1,00.** Arriva al pavimento **solo** come famiglia su piu' simboli — che pero' e' esattamente il punto (b) qui sopra. 🔴 **Questa tensione va risolta da Claudio prima di spendere un round, non dopo** |

---

# 6. 🏛️ LA RIGA PROP

**Nessun promosso, quindi nessuna riga prop da scrivere per un motore.** Sull'attrezzo:
- non apre posizioni → **non tocca il DD**, ne' totale (10% = 90.000 su 100k) ne'
  giornaliero (5% = **−5.000 in una giornata**);
- **l'unico rischio prop che introduce e' indiretto e va detto**: se la sonda
  uscisse positiva, la famiglia news e' **concentrata per costruzione** (piu'
  sedie che sparano **nello stesso minuto**) → e' il profilo che il **muro
  giornaliero** punisce, e che il **DD trailing** di certe prop punisce due volte.

---

# 7. 🚧 COSA NON HO POTUTO VEDERE — dichiarato, non tappato

- 🔴 **Il `.mq5` di `nsclk/Asian-Range-Breakout-EA`**: quattro strade provate
  (raw 404 sul nome del README, UI 403, codeload 403, jsDelivr 000). **Candidato
  NON VALUTABILE** — e non serve comunque, la geometria e' sepolta.
- 🔴 **Quantpedia: 502.** E' un **5xx**, cioe' *"non adesso"*: **non si cancella
  dal catalogo delle fonti**, si riprova.
- 🔴 **SSRN, Forex Factory, earnforex, GitHub ricerca**: non riprovati stanotte —
  l'11/09 erano **403/403/000/403**. Li dichiaro **non coperti**, non "vuoti".
- 🔴 **La ricerca interna del Code Base resta in JS**: ho aggirato il limite con
  la ricerca web ristretta a `mql5.com`, che ha funzionato (e ha tirato fuori
  55064/55630/76951, **mai setacciati prima**). 🎯 **Questo canale va scritto in
  `PROMEMORIA_SBLOCCO_FONTI.md`: e' il primo modo che funziona per CERCARE nel
  Code Base per parola chiave.** ⚠️ Ma restituisce **moltissimo `/market/`**, che
  e' fuori perimetro in modo permanente.
- 🔴 **La profondita' del calendario MT5 su BCM**: non misurabile da qui, serve il VPS.

---

# 8. ❓ LA DOMANDA A CUI IL PRIMO PASSO DEVE RISPONDERE

> ## **"Il calendario nativo del nostro MT5 su BCM, quanto indietro arriva con `actual` e `forecast` — e quei timestamp sono in ora server o sfasati dal DST?"**

**Finche' non c'e' quel numero, il meccanismo della sorpresa resta [NON
MISURATO], e nessun file prova va scritto.** E' una misura di due minuti, non un
round: si attacca il retriever a un grafico sul conto **50503392**
(`BCM Markets MT5 Terminal`), si guarda la prima data scritta e si confronta un
NFP noto col nostro CSV.

🔴 **Nessun file prova consegnato stanotte, e la ragione e' quella: `@DAQUANDO`
non si inventa** (LEGGIMI.md). Scrivere una griglia su una profondita' di
calendario ipotizzata sarebbe esattamente l'errore degli indici (driver
2024.01.01, dati dal 26/09/2024: **meta' finestra IS non esisteva**).

---

## 📎 Provenienza, licenze, e cosa NON e' stato toccato

| artefatto | licenza dichiarata | uso ammesso |
|---|---|---|
| `CalendarRetriever.mq5`, `CalendarFile.mqh`, `NewsBacktest.mq5` (55630) | **nessuna** — solo `#property copyright "Muller Peter"` | leggere e imparare; riscrivere in casa citando l'autore |
| `FetchNews.mq5` (55064) | idem | idem |
| `CalendarExport.mq5` (76951) | `#property copyright "CalendarExport"`, nessuna licenza esplicita | idem |
| articoli MQL5 22196 / 16752 / 18486 | contenuto editoriale MQL5 | citazione, non copia |
| `nsclk/Asian-Range-Breakout-EA-for-MT5` | **MIT** (dichiarata nel README) | riutilizzo ammesso con attribuzione — **ma il sorgente non e' stato letto** |

🚫 **Nessun EA, preset, file prova o sedia forward e' stato toccato. Nessun
commit. Nessun conto.** I sorgenti scaricati stanno nella cartella temporanea di
sessione, **non nel repo**.
