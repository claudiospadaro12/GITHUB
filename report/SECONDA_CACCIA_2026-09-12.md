# 🏹 SECONDA CACCIA SUI MOTORI BOCCIATI — 12/09/2026

**Partita per la REGOLA DELLA SECONDA CACCIA (firmata da Claudio, 19/08)**, sulla sua
domanda di oggi: _"Si ma lavoriamo sui motori bocciati. No?"_ — si cercano **meccanismi
ALTERNATIVI sulla STESSA inefficienza**, mai parametri diversi di un motore morto.

> 🔒 **PERIMETRO DI QUESTO LAVORO, dichiarato prima di tutto il resto.**
> **Zero EA scritti o toccati. Zero preset. Zero parametri di forward. Zero backtest
> lanciati. Zero righe in `CODA.txt`.** Non ho toccato `walkforward_generico.ps1`,
> `RIGA_SOTTILE_ROUND.ps1`, nessun `.mq5`, nessun file degli altri due agenti al lavoro
> sullo stesso albero. Gli unici file nuovi sono **questo `.md` e due sonde Python** in
> `caccia_strategie/biblioteca/sonde_esterne/`.
> Il **secondo strato del cancello** (agente `controllo-preventivo`) **lo lancia il
> chiamante**: io lo dichiaro e non lo aggiro.

---

# 0. 🔴 LA RIGA CHE VA LETTA PER PRIMA

> ## Su **~180 titoli** guardati su **6 fonti vive**, **14 famiglie di inefficienza** ripassate una per una nel cimitero, **1 candidato portato fino alla MISURA** su **3,8 milioni di barre M1**: **ZERO PROMOSSI. ZERO file prova consegnati.**
>
> **E non e' una resa. La caccia consegna TRE cose che non c'erano ieri sera, e tutte
> e tre sono numeri:**
>
> ### 1️⃣ 🪦 La famiglia NOTTE/GIORNO si chiude con un INVARIANTE, non con un'opinione
> Il pattern di Knuteson **esiste anche sul DAX** e l'ho misurato io: su **2.053 notti**
> (2010-2018) la **notte** rende **+0,04488% (t = +2,86, 55,6% positive)** mentre il
> **giorno** rende **−0,01575% (t = −1,13)** — stesse giornate, gambe opposte, controllo
> appaiato. E **passa anche il cancello del costo** sul DAX: **3,17x** contro il 3x.
> 🔴 **Ma muore sul RISCHIO, e il numero non si aggira con una manopola:**
>
> | | stop 1,0% | stop 1,5% | stop 2,0% |
> |---|---:|---:|---:|
> | edge atteso | **5,03%/anno** | 3,35%/anno | 2,52%/anno |
> | peggior notte misurata (**−11,66%**, 16/03/2020) | **7,58%** | 5,05% | 3,79% |
> | **rapporto peggior-notte / anno-di-edge** | **1,51** | **1,51** | **1,50** |
>
> 🎯 **Il rapporto e' INVARIANTE rispetto allo stop** — perche' edge e perdita da gap
> scalano entrambi come `1/stop`. **Nessuna scelta di parametro salva l'aritmetica: la
> peggior notte misurata costa una volta e mezza un anno intero di edge**, e su 100k
> sfonda **da sola** il muro giornaliero del 5%. Con tre indici accesi insieme (la notte
> di crollo li colpisce **tutti**) fa **22,74%** dell'equity in una notte.
>
> ### 2️⃣ ⚠️ Il certificato di morte del 05/09 su questa famiglia era SBAGLIATO, in due punti su due
> `CACCIA_TF_M30_2026-09-05.md` (r.297) la scarto' con due motivi: **"swap 450 volte
> l'anno (mai misurato)"** e **"spread notturno D30EUR 3,5-3,9"**.
> 🔴 **Il primo e' FALSIFICATO**: il 12/09 `EMA200_I_DUE_REQUISITI` ha misurato **swap
> 0,00 su 4 posizioni tenute oltre la mezzanotte** e **commissione 0,00 su 302 deal**.
> 🔴 **Il secondo e' MAL APPLICATO**: chi entra alla chiusura cash ed esce all'apertura
> cash **non paga mai lo spread notturno**, paga l'**ora 16** e l'**ora 8** (mediana
> **1,70 + 1,70 = 3,40**), non 3,5-3,9 due volte.
> ✅ **Il verdetto finale resta NO — ma per il motivo giusto, e ora ha un certificato
> vero.** Questa e' la regola del 09/09 che funziona: _"un morto senza certificato non
> e' un morto"_.
>
> ### 3️⃣ 🐛 `ABTG_SondaOrologio` **NON PUO' tenere una posizione la notte**, e 24 delle sue 72 celle in coda portano una durata FALSA
> Il flat di fine giornata **non e' disattivabile per progetto** (4 difese nel sorgente):
> `MinutiFlat_Calc(30) = 1439 − 30 = 1409 = 23:29 server` (r.296-301), applicato a ogni
> tick da r.575 e anche all'ingresso da r.636.
> 👉 Nelle celle `SONDA_OROLOGIO_11..14` (in coda, **mai girate**) lo sweep dichiara
> `24 ore x 3 durate = 72 celle`: **24 sono troncate dal flat** e **12 sono DOPPIONI
> esatti di un'altra cella**. Le ore 20/21/22/23 danno la **stessa** tenuta per durata
> 4, 8 e 12 (**3,48 / 2,48 / 1,48 / 0,48 ore**). **Chi legge quella tabella senza questa
> nota leggera' "durata 12" su una tenuta di 29 minuti.**

---

# 1. ⚖️ I CRITERI, congelati PRIMA di aprire un browser

Presi alla lettera dal mandato, non riscritti dopo.

| # | criterio | soglia |
|---|---|---|
| **S1** | meccanismo **DIVERSO** sulla stessa inefficienza | se e' lo stesso motore con nomi diversi → **scarto, e lo scrivo** |
| **S2** | passa la **lista dei caduti** | `REGISTRO_TEST.md` (2.347 righe) + i **60** dossier `CACCIA_*`. Se l'abbiamo provato, **dove** |
| **S3** | **frontiera del costo**, col numero | `stop >= 40x spread`, pavimento **duro 13,3x**. Indici: banda **M30/H1**. Forex: EURUSD **M5 9,30x** e **M15 12,56x** = sotto il pavimento duro |
| **S4** | **profondita' di storico** | i 150 trade/lato **vengono solo dal backtest**: 11,5 op/gg/lato per farli in 18 giorni = impossibile. Forex 1999 · indici **21 mesi, un solo toro** |
| **S5** | §4 non si ammorbidisce | martingala · griglia · recovery · mediazione · niente stop · repaint · look-ahead → fuori |
| **S6** | niente che **viva sul tick dentro la barra** | validiamo a **tick reali (`Modello 4`)**; `Modello 1` e' solo screening |
| **S7** | i **numeri dichiarati dagli autori non pesano** | dove li cito sono etichettati |
| **S8** | **contro-esempio obbligatorio** (regola 10/09) | prima di consegnare un numero, costruisco io quello che lo romperebbe |

---

# 2. 🔌 CONTROLLO POSITIVO — misurato oggi, fonte per fonte

| fonte | bersaglio | esito MISURATO oggi | verdetto |
|---|---|---|---|
| **MQL5 Code Base** | `/en/code/mt5/experts` | **200**, 86.853 byte, **40 titoli + id** estratti | 🟢 **PASSA** |
| **MQL5 sorgente** | `/en/code/download/74582` | **200**, `application/zip`, 2.888 byte | 🟢 **PASSA** |
| 🆕 **Quantpedia** | `/strategies/` (redirige a `/screener`) | **200**, 641.496 byte, **82 strategie** della sezione gratuita | 🟢 **PASSA — ed era dichiarata NULLA (308) ieri** |
| 🆕 **Quantpedia scheda** | `/strategies/market-sentiment-and-an-overnight-anomaly/` | **200**, 186.756 byte, testo integrale + fonte accademica | 🟢 **PASSA** |
| 🆕 **arXiv API** | `export.arxiv.org/api/query` | **200** su ricerca per parola chiave **e** su `id_list` | 🟢 **PASSA — era in TIMEOUT ieri** |
| **arXiv elenco** | `arxiv.org/list/q-fin.TR/recent` | **200**, 20.030 byte | 🟢 **PASSA** |
| **TradingView elenchi** | `/scripts/{bearish,short,trendanalysis}/?script_type=strategies` | **200** su tutti e tre (361K / 422K / 621K byte), **~140 titoli** | 🟢 **PASSA** |
| 🥇 **Dati indice esterni** | `raw.githubusercontent.com/FutureSharks/financial-data` | **200 x 22 file**, **3,84 milioni di barre M1** | 🟢 **PASSA — e' la fonte che ha deciso la caccia** |
| **SSRN** | `abstract_id=689282` | **403** | 🔴 **NULLA** (quinta volta di fila) |
| **GitHub ricerca** | UI `/search` e `api.github.com/search` | **403 entrambe** — ⚠️ e il corpo dice *"sessions are bound to their configured repositories"* | 🔴 **NULLA, e STRUTTURALE**: non e' quota e non e' 404, e' **scoping della sessione**. Riprovare non serve: **serve un canale diverso** |
| **Forex Factory** | `/forum/71-trading-systems` | **403** | 🔴 **NULLA** |
| **newyorkfed.org** | staff report sr917 (pagina e PDF) | **connect_rejected** dal proxy | 🔴 **NULLA** |
| **stooq.com** | CSV giornalieri indici | **connect_rejected** dal proxy | 🔴 **NULLA** |

### 2.1 🕐 IL COLLAUDO DELL'OROLOGIO — e come la mia sonda ha certificato il FALSO al primo giro

Regola di casa: si verifica l'orologio **prima** di leggere qualunque altro numero.

🔴 **La prima stesura della mia sonda ha sbagliato, e lo scrivo perche' e' esattamente
il difetto del 10/09.** Cercava il minuto file a piu' alta |variazione| media M1 **senza
soglia sul campione**, e mi ha risposto **`18:00` (n=5)** e **`02:00` (n=8)**: rumore
puro, presentato come collaudo. Con la soglia **n >= 500** il collaudo passa:

| simbolo | i 4 minuti piu' mossi (n) | cosa devono essere | esito |
|---|---|---|---|
| `GRXEUR` (DAX) | **03:00** (n=1.919) · 03:05 · 10:00 · 03:02 | apertura DAX = **08:00 server** = 03:00 file | ✅ |
| `SPXUSD` | **15:59** (n=2.019) · 10:00 · **09:35** · **09:31** | chiusura (21:00 srv) e apertura (14:30 srv) cash USA | ✅ |

➡️ **`ora file + 5 = ora server BCM` ricollaudata da me**, non ereditata. E riproduce
alla cifra il collaudo indipendente fatto stamattina dalla caccia SUPREV (03:00 sul DAX).

---

# 3. 🗺️ LA TABELLA DELLE INEFFICIENZE GIA' PAGATE — e il meccanismo alternativo, trovato o no

Costruita **solo** su inefficienze con un **PF o un cancello MISURATO** (non su
"bocciati per frequenza": quelli sono dell'altro agente). Ordinata per quanto abbiamo
speso.

| # | inefficienza | il motore che l'ha pagata, col NUMERO | meccanismo alternativo cercato oggi | esito |
|---:|---|---|---|---|
| 1 | **rottura del range d'apertura** | ORB/Apertura, **~210 celle a tick**; `R45 0/48`; `R12 48/48 negative`; `ORB NASUSD` PF OOS 1,03-1,25 con **DD 32,57%** | Code Base `76927 Session Range Desk` (= il nostro ORB, l'autore lo chiama *"a programming example"*), `76153`, `76333`, TV `Session Opening Range Breakout ORBO`, `ORB VWAP NY Bounce` | 🔴 **NON TROVATO** — sono lo stesso motore. Scartati per S1 |
| 2 | **fade del range d'apertura** | **R42: 0/24 IS e 0/24 OOS** | — | 🔴 **NON TROVATO** (chiuso 3 volte: R42, box+fade 06/09, oggi) |
| 3 | **fade della banda** (BB/Keltner) | **R108/R111: 6 finestre su 6 rosse**, gradiente H1 > M30 > M15 | TV `Power Surge BB Momentum Squeeze`, `Momentum Bands Breakout` | 🔴 **NON TROVATO** — M14, e la compressione ATR e' L3 (**0/8 sopra il pavimento, 7/8 sotto H8**) |
| 4 | **fade dell'estremo a lookback** | `ABTG_MeanRevert` **R60: 12 celle su 12 in perdita**, PF max **0,986**, **DD 37%** | TV `SzsLYlho Mean reversion`, `Average Highest High / Lowest Low Swinger` | 🔴 **NON TROVATO** |
| 5 | **esaurimento + spike di volume** | `ABTG_AtrExhaustVol` **R109: DD 44-68%** | — | 🔴 **NON TROVATO**; e sul nostro feed `volume` e' **tick volume**, non contratti |
| 6 | **falsa rottura di livello** (CRT/Turtle Soup/BreakinBox) | **tre volte, 0/30 celle a tick** | TV `Sweep & Reverse`, Code Base **77094 `SMC Liquidity Sweep Scalper`** | 🔴 **NON TROVATO** — stessa famiglia |
| 7 | **sweep di liquidita' su micro-pivot** | **R95: 30/30 passate in perdita, PF 0,65-0,80**; M24 chiuso; misura esterna su **22.616 segnali**, delta vs caso **−0,2 pt** | idem sopra | 🔴 **NON TROVATO** (quarta chiusura) |
| 8 | **ritorno alla VWAP** | `ABTG_VwapRevert` **FALSIFICATO**: punti/spread **negativo su 4 celle su 4** | TV `VWAP Trend Momentum Artillery` | 🔴 **NON TROVATO** |
| 9 | **apertura della sessione di Londra** | `ABTG_LondonFx` **R116**: PF OOS **0,843**, E OOS **−0,1078R**, **DD OOS 37,14%**, e l'IS era **gia'** in perdita (PF 0,795) | 🔎 **gia' cercato DUE volte**: `CACCIA_LONDRA_MECCANISMI_2026-08-19` e `CACCIA_LONDRA_ALTERNATIVA_2026-09-03` (**47 strategie, 10 sorgenti letti, 0 promossi**: i 4 migliori erano `ABTG_BreakinBox` riga per riga) | 🔴 **NON TROVATO**, e non l'ho ricercato: sarebbe la **terza** battuta sullo stesso bersaglio |
| 10 | **rottura del box notturno** | `ABTG_Nightly` GBPUSD: **IS PF 0,59, DD 22,62%**; `BreakinBox` smascherato come R95 con un livello nuovo | — | 🔴 **NON TROVATO** |
| 11 | **breakout post-notizia** | `ABTG_PostNews` **PF sotto 1 su 4 letture su 4**: ISM/EURUSD **0,76 / 0,79** · blocco 13:30/USDJPY **0,66 / 0,90**, campione pieno | 🔎 **gia' cercato**: `CACCIA_POSTNEWS_MECCANISMI_2026-09-05` (**3 meccanismi misurati, 3 bocciati**) | 🔴 **NON TROVATO** |
| 12 | **incrocio di medie / flip di Supertrend** | `SuperWave` PF OOS **0,98**; `SupRev NAS H1` PF OOS **1,01**; **R123 blocchi B e C = A6** *"non c'e' una configurazione robusta"* | TV `Adaptive Supertrend MA Crossover`, `TrendShift Supertrend ADX`, `Bitcoin SuperFlip`, `TEMA Cross`, `Short Swing Bearish MACD Cross`, Code Base `77009 SuperTrend TV EA` (**l'autore stesso**: *"modest results due to spread costs from frequent reversals"*) | 🔴 **NON TROVATO** — e proporli sarebbe "un'altra taratura dello stesso Supertrend", vietato dalla regola |
| 13 | **inversione da esaurimento su indice** | 🔎 **battuta stamattina** dall'agente gemello: `CACCIA_SUPREV_ALTERNATIVE_2026-09-12`, 126 titoli, 5 sorgenti letti, **1 candidato misurato e bocciato** (segno positivo in **2 anni su 4**) | non la rifaccio | 🔴 **NON TROVATO** (agli atti di stamattina) |
| 14 | 🌙 **decomposizione NOTTE / GIORNO** — la gamba notturna | `sonda_m30_onid.py` (05/09) chiuse la **reversione notte→giorno** (cancelli K1-K4 falliti: la mezz'ora migliore vale **1,63 pt** contro un cancello di **4,95** = **0,33x**), e scarto' la gamba **long overnight** con **due motivi che oggi cadono** (§0.2) | 🟢 **TROVATO**: *"non fare il fade della notte — TIENILA"*. Fonte aperta: **Quantpedia** + **2 paper arXiv verificati con l'API**. **Portato fino alla misura** su 3,8M di barre | 🔴 **MISURATO E BOCCIATO PER RISCHIO** — §4. **E' l'unico candidato vero della giornata** |

---

# 4. 🧪 IL CANDIDATO PORTATO FINO ALLA MISURA — e come e' morto

## 4.1 La scheda

```
NOME            Gamba NOTTURNA della decomposizione notte/giorno su indice
                (in casa sarebbe un motore nuovo: "tieni la notte, stai fuori il giorno")
FONTE / URL     https://quantpedia.com/strategies/market-sentiment-and-an-overnight-anomaly/
                  [APERTA E LETTA, 186.756 byte]  -> rimanda a SSRN 3829582 (Vojtko,
                  Hanicova), che NON ho potuto aprire: SSRN 403. Lo dichiaro.
                arXiv 2010.01727  Bruce Knuteson, 05/10/2020,
                  "Strikingly Suspicious Overnight and Intraday Returns"
                arXiv 2507.04481  Glasserman, Krstovski, Laliberte, Mamaysky, 06/07/2025,
                  "Does Overnight News Explain Overnight Returns?"
                  [metadati dei due paper VERIFICATI con l'API arXiv, non con la pagina]
LICENZA         n/d (non c'e' codice da portare: e' un meccanismo, non un EA)

TESI IN UNA RIGA
  "Il premio per il rischio azionario si incassa di NOTTE, non di giorno: chi compra
   alla chiusura del cash e vende all'apertura prende la parte che paga, e sta fuori
   dalla parte che non paga."

MECCANICA        ingresso al CLOSE della sessione cash · uscita all'OPEN della
                 sessione cash successiva · nessuna condizione di prezzo · stop
                 di sola protezione. Un'operazione per seduta, per simbolo.
GESTIONE RISCHIO sarebbe la nostra (rischio %, stop vero). Non e' il problema.
BANDIERE ROSSE   nessuna del §4: niente martingala, griglia, recovery, mediazione,
                 repaint, look-ahead. Decide su barre chiuse e su un orologio.
COSTO DI PORTING un EA NUOVO, piccolo (orologio + stop + rischio %), ~2-4 ore di
                 mql5-ea-developer. NON scritto: non e' il mio perimetro.
```

### 🔍 Perche' e' un meccanismo DIVERSO, e non il morto del 05/09 con un altro nome
Il 05/09 e' stata misurata e chiusa la **reversione notte → giorno**: *il rendimento
notturno predice quello diurno*. Quella e' una **regola condizionale sul prezzo della
notte**. Questa **non guarda nessun rendimento**: e' un **calendario**. E' la differenza
che il file `SONDA_OROLOGIO_INDICI.txt` scrive nero su bianco distinguendo l'orologio da
Gao (R98): *"Gao entra CONDIZIONATO al rendimento della prima mezz'ora, cioe' su una
regola di PREZZO. L'orologio non guarda nessun prezzo"*. Stessa inefficienza, meccanismo
di famiglia diversa. **S1 passato.**

### 🐛 E la scoperta che rende la misura NECESSARIA: nessun EA di casa puo' girarla
`ABTG_SondaOrologio` sembra il candidato naturale (entra all'ora, esce all'ora, zero
prezzo) e il suo sweep dichiarato include `InpOraIngresso=21` con `InpOreDurata=12`.
🔴 **Non puo'**: il flat di fine giornata e' **non disattivabile per progetto** —
`MinutiFlat_Calc(30) = 24*60 − 1 − 30 = 1409 = 23:29 server` (r.296-301), chiamato da
r.575 a ogni tick e da r.636 anche in ingresso, con `OnInit` che **rifiuta** valori fuori
da 0..720 (r.433-434). **Una posizione entrata alle 21:00 muore alle 23:29.** Quindi:
niente EA esistente → **niente file prova** → **la via piu' corta al numero era una
sonda Python**, e l'ho fatta.

## 4.2 🥇 LA MISURA — 2 simboli, 9 anni, 3,84 milioni di barre M1, ZERO passate di tester

Sonda: `caccia_strategie/biblioteca/sonde_esterne/sonda_notte_giorno.py` (nuova).
Dati: **FutureSharks/financial-data**, histdata M1, **GPL-3.0**, `GRXEUR` (DAX, stessa
scala di `D30EUR`) e `SPXUSD`, **2010-2018**, 22 file, 200 OK su tutti.
Sessione cash: DAX **file 03:00-11:30 = server 08:00-16:30** · SPX **file 09:30-16:00 =
server 14:30-21:00**. **Controllo appaiato**: le due gambe sono le **stesse giornate**.

### Il fatto, e regge

| simbolo | gamba | n | media pt | mediana pt | **media %** | **t** | % positive |
|---|---|---:|---:|---:|---:|---:|---:|
| **GRXEUR** | 🌙 **NOTTE** | **2.053** | +4,077 | +5,500 | **+0,04488%** | **+2,86** | **55,6%** |
| GRXEUR | ☀️ GIORNO | 2.053 | −2,237 | +2,250 | **−0,01575%** | −1,13 | 51,4% |
| **SPXUSD** | 🌙 **NOTTE** | **2.076** | +0,465 | +0,750 | **+0,02404%** | **+2,12** | 53,4% |
| SPXUSD | ☀️ GIORNO | 2.076 | +0,166 | +0,750 | +0,01561% | +0,55 | 54,4% |

**Per ANNO, la notte e' positiva in 8 anni su 9** su entrambi i simboli (l'unico
negativo e' il 2011 sul DAX, a **−0,00227%**, cioe' zero; e il 2016 su SPX, −0,022%).
🎯 **E il 2018 — l'anno d'orso — la notte sul DAX e' POSITIVA (+0,02933%) mentre il
GIORNO fa −0,10230%.** Cioe': la stabilita' di regime che a tutta questa famiglia e'
sempre mancata, qui **c'e'** — ed e' il motivo per cui l'ho portata avanti invece di
archiviarla.

### Il cancello del costo, con gli spread MISURATI NELL'ORA GIUSTA
Da `risultati_archivio/spread_flotta/` (**30,9M tick** D30EUR, **64,7M** U30USD), mediane
in punti indice, **ora server**:

| simbolo | livello oggi | lordo notte | spread ingresso | spread uscita | **round-trip** | **lordo/RT** | cancello 3x |
|---|---:|---:|---:|---:|---:|---:|---|
| **D30EUR** | 24.000 | **10,77 pt** | ora 16 = **1,70** | ora 8 = **1,70** | **3,40** | **3,17x** | 🟢 **PASSA** |
| `U30USD` | 45.000 | 10,82 pt | ora 21 = 1,80 | ora 14 = 2,00 | 3,80 | **2,85x** | 🔴 **NON PASSA** |

⚠️ La riga `U30USD` e' **`[INFERITO]`**: la deriva misurata e' quella di **SPXUSD**,
riscalata sul livello del Dow. E' la stessa riserva che la caccia M15 ha dichiarato il
05/09. **Non ci poggia nessuna conclusione**: il verdetto e' costruito sul DAX, dove la
deriva e' **misurata sullo stesso strumento** (GRXEUR = scala di D30EUR).

📌 E una cosa non ovvia che vale per ogni caccia futura: **questo cancello si allenta da
solo quando l'indice sale.** L'edge e' una **percentuale**, lo spread e' **punti indice
quasi costanti**. La stessa deriva che nel 2015 (DAX a 11.000) valeva **1,45x** oggi (DAX
a 24.000) vale **3,17x**. 👉 **Un "morto per costo" misurato su dati vecchi va rifatto
al livello di prezzo di oggi prima di crederci.** Qui ha cambiato il segno del cancello.

## 4.3 🛑 IL CONTRO-ESEMPIO OBBLIGATORIO — e ha ucciso il candidato

**Cancello scritto PRIMA di guardare il 2020** (§1, S8): *un meccanismo che tiene una
posizione senza presidio deve essere giudicato sul RISCHIO prima che sul merito
(Emendamento della Finestra, punto B: "il VECCHIO giudica il RISCHIO")*. E la domanda che
rompe la tesi e' una sola: **un gap SALTA lo stop.**

🔴 **Primo buco, dichiarato appena l'ho visto: la mia finestra 2010-2018 NON contiene il
2020.** E i file histdata degli indici si fermano al 2018 — **404 VERIFICATO** su
`GRXEUR_2019`, `GRXEUR_2020`, `SPXUSD_2019`, `SPXUSD_2020` (404, **non** 503). Invece di
dichiarare il buco e fermarmi, sono andato a prendere il 2020 **dalla cartella Oanda**
(`SPX500_USD`, UTC, DST USA dell'8 marzo 2020 gestita nel codice):
`sonda_notte_giorno_2020.py`, **116.586 barre M1**, 93 notti dal 02/01 al 13/05/2020.

| 2020 (gen-mag), SPX500_USD | valore |
|---|---:|
| 🌙 **NOTTE, media** | **−0,14804%** ⬅️ **NEGATIVA** |
| ☀️ GIORNO, media | **+0,03219%** ⬅️ **POSITIVA** |
| σ della notte | **2,3325%** (contro 0,55-0,70% nel 2010-2018) |

> 🔴 **Nel crollo la decomposizione SI INVERTE**: la notte perde e il giorno guadagna.
> Esattamente il regime in cui una sedia "tieni la notte" e' accesa e non puo' fare
> niente.

### Le notti peggiori, e cosa costano su un conto da 100k

| notte | gap | quanto costa con **stop 1,0%** del livello e rischio **0,65%** |
|---|---:|---|
| **16/03/2020** | **−11,66%** | **7,58% dell'equity IN UNA NOTTE** 🧱 **sfonda il muro giornaliero del 5%** |
| 09/03/2020 | −7,54% | 4,90% (a un soffio dal muro) |
| 12/03/2020 | −6,30% | 4,09% |
| 18/03/2020 | −4,88% | 3,17% |
| **24/06/2016 (Brexit, DAX)** | **−9,65%** | **6,27%** 🧱 **sfonda il muro giornaliero** |

E non e' una coda sottile: nel 2020 **8 notti su 93 (8,60%)** sono sotto **−3,0%**,
contro **una ogni 411** nel 2010-2018 sul DAX. Il rischio di questa famiglia **non e'
stazionario**: si concentra tutto dove fa male.

### 🎯 E LA RIGA CHE CHIUDE LA PORTA: il rapporto NON DIPENDE DALLO STOP

L'obiezione ovvia e' *"allarga lo stop e il gap pesa meno"*. È vero e **non serve a
niente**, perche' allargando lo stop cala anche la taglia, quindi cala l'edge nella
stessa proporzione:

| | stop 1,0% | stop 1,5% | stop 2,0% |
|---|---:|---:|---:|
| edge netto atteso (gamba DAX) | **5,03%/anno** | 3,35%/anno | 2,52%/anno |
| costo della notte del 16/03/2020 | **7,58%** | 5,05% | 3,79% |
| **rapporto** | **1,51** | **1,51** | **1,50** |

> ## 🔴 VERDETTO: **MERITO SI', RISCHIO NO. IL CANDIDATO NON ENTRA NELL'IMBUTO.**
> Il pattern e' reale, misurato, stabile per regime (8 anni su 9) e **passa il cancello
> del costo sul DAX (3,17x)**. Ma **la peggior notte misurata costa 1,51 volte un anno
> intero di edge, e quel rapporto e' invariante rispetto a ogni parametro.** Su 100k
> sfonda **da sola** il muro giornaliero del 5%; con i tre indici accesi insieme — e una
> notte di crollo li colpisce **tutti**, quindi il tetto per cluster al 3,0% (firmato
> 07/09, 🔴 **firmato ma NON attivo**) e' esattamente il presidio che manca — fa
> **22,74% dell'equity in una notte**.
>
> ✅ **E l'altra meta' del contro-esempio: ho provato a ROMPERE anche il verdetto al
> contrario.** Se la notte paga e il giorno no, lo **specchio** (short intraday, flat la
> notte, **zero rischio da gap**) sarebbe il candidato perfetto — e riempirebbe il buco
> **short sugli indici**, il primo della lista. 🔴 **Non regge, e ha due numeri contro:**
> il lordo del giorno sul DAX e' **−0,01575% = 3,78 pt** su 24.000 contro un round-trip
> di **3,40** → **1,11x**, cioe' **NON PASSA il cancello 3x** (e nemmeno il 2x); e
> **`t = −1,13` non e' significativo**, con la **mediana POSITIVA (+2,250 pt)**: la media
> negativa del giorno e' fatta dalla **coda dei giorni di crollo**, non da una deriva.
> *Lo specchio di un perdente non e' un vincitore* — verificato, non assunto.

## 4.4 🏛️ La riga prop, scritta anche quando e' sfavorevole

In ottica prop questa famiglia ha **una** cosa giusta e **tre** sbagliate.
🟢 Giusta: **la frequenza e la scorrelazione**. 1 op/seduta per simbolo, **459 feriali**
nella cassaforte tick = **~229 operazioni per meta' IS/OOS** (sopra il pavimento dei
150 — e' una delle pochissime famiglie su indice che il muro del campione non uccide), su
un **orario che la flotta non occupa** (le aperture DAX lavorano 08:00-12:00, `DaxReEntry`
dalle 12:05, le due sedie Dow 14:30-19:30).
🔴 Sbagliate: **(1)** il rischio e' **fuori presidio per costruzione** — con la posizione
aperta la notte lo stop e' un'intenzione, non una protezione; **(2)** il **DD trailing**
di diverse prop punisce proprio la forma "tanti piccoli passi e un salto indietro";
**(3)** su **FTMO Standard funded** va **chiuso prima del weekend** e se il rollover dura
oltre 2 ore (`REGOLAMENTI_PROP_2026-09-08.md` r.101) — si aggira solo col conto **SWING**,
e **il meccanismo di chiusura weekend non ce l'abbiamo** (r.258).

---

# 5. 🚫 GLI SCARTI, con il motivo e senza sconti

### 5.1 MQL5 Code Base — 40 titoli, pagina 1, settima conferma di fila

| gruppo | quanti | perche' |
|---|---:|---|
| **attrezzi, pannelli, logger, demo Renko, calcolatori** | **31** | non sono strategie. `GDS Renko *Demo EA` x8, `RiskPilot`, `TrueCostReport`, `CalendarExport`, `TradeHistoryLogger`, `Position Peak Logger`, `Market Replay`, `PropFirmGuard`, `Quantora Spread Monitor`, `Server Clock`, ... |
| **§4 dal titolo** | **3** | `Sniper Gold Hybrid Recovery EA`, `Daily Zone Recovery EA`, `GridCapitalCalculator` — recovery / griglia |
| **famiglie sepolte** | **4** | `77094 SMC Liquidity Sweep Scalper` (= M24/R95), `77009 SuperTrend TV EA` (= SupRev/A6), `76927 Session Range Desk` (= ORB), `76153 Session Opening Range Breakout` |
| **scatole nere, tesi non scrivibile** | **2** | `EA AurumNeuro Vanguard`, `HybridMicrostructure EA` — **gia'** scartati (16/08, 11/09) |
| **gia' letti nel sorgente in cacce precedenti** | — | `ZetaBurst Scalper`, `Chaos Theory Lyapunov`, `Market Miner`, `KCI Embeded Sniper`, `AAPL cfd ORB`, `SessionReopenEA` |

**Zero sorgenti nuovi da aprire.** 🔴 **E' la settima battuta di fila che dice la stessa
cosa: il Code Base non produce piu' MOTORI.** Merita di essere detto come conclusione
operativa: **come fonte di motori e' esaurita**, e continuare a sfogliarla e' tempo a
rendimento zero. Resta utile per gli **attrezzi** (il `RealCost Spread P95 Logger` 74148
e' li' dal 23/08 e **non e' mai stato usato**).

### 5.2 TradingView — ~140 titoli su 3 tag, zero sorgenti aperti, e il motivo

Non ho aperto nemmeno un Pine oggi, **ed e' una scelta con un conto dietro**: Pine → MQL5
e' una **riscrittura**, e ogni titolo dei tre tag cade in una famiglia gia' sepolta.

| gruppo | esempi | famiglia morta |
|---|---|---|
| incroci/pullback di medie | `Adaptive Supertrend MA Crossover`, `TEMA Cross HTF`, `EMA Pullback Trend Continuation`, `Gradient Ribbon`, `Short Swing Bearish MACD Cross`, `Combo 2/20 EMA Bear Power` | CrossEma · SuperWave · SupRev (**A6**) · M0PB |
| candele classiche | `Bearish Engulfing`, `Bearish Harami`, `Bull/Bear Power`, `123 Reversal` | inversione da esaurimento, chiusa **stamattina** |
| sweep / liquidita' | `Sweep & Reverse Liquidity Sweep Reversal` | M24 · **R95 PF 0,65-0,80** |
| ORB / box | `Session Opening Range Breakout ORBO`, `ORB VWAP NY Bounce`, `Tristan's Box` | ~210 celle · R45 0/48 |
| banda / squeeze | `Power Surge BB Momentum Squeeze`, `Momentum Bands Breakout` | M14 (**6/6 rosse**) · L3 |
| mashup multi-indicatore | `Ichimoku + RSI/ADX/MACD by Coinrule` (x4), `StackLight MTF`, `Traffic Lights`, `Golden Trident`, `Zl0fql8o VWAP Artillery` | 🔴 **nessuna tesi in una riga** = spazzolata |
| §4 dal titolo | `Strategy PyramiCover`, `TRADLEWARE DCA Trend ETF`, `TURKS Tiered Unit Risk Kernel` | piramidazione / DCA / taglia a scaglioni |
| cross-sezionali | `Momentum Rotor Basket Breakout`, `Swing Stock Market Multi MA Correlation`, `Stock Gaps SPY Correlation` | servono panieri che su MT5/BCM **non esistono** |
| strumenti che non abbiamo | `Bitfinex Shorts Strat`, `Bitcoin SuperFlip`, `LINK`, `FCPO KDJ`, `astropark Moon Phases` | — |
| **gia' in casa / gia' misurati** | `Momentum Sequence Strategy [Herman]` | 🔴 **misurato e bocciato STAMATTINA** dall'agente gemello |

### 5.3 🆕 Quantpedia — 82 strategie gratuite, e una conclusione che risparmia la prossima battuta

**La fonte e' viva (200 dopo un 308) e vale la pena averla in elenco. Ma la sua forma NON
e' la nostra**, e il conto e' netto: delle **82** strategie della sezione gratuita,

- **65** sono **cross-sezionali** (azioni, paesi, materie prime, valute: momentum, value, accrual, F-score, short interest, 13F, ESG, lexical density, carry...): richiedono **panieri** che su MT5/BCM
  non esistono, o **decine di strumenti ribilanciati insieme**. Stessa obiezione con cui la tassonomia del 03/09 scarto'
  M12 e con cui il 05/09 e' stato scartato *Overnight-Intraday Reversal Everywhere*;
- **9** sono a **ribilanciamento mensile o su evento rado** (`turn-of-the-month`,
  `option-expiration-week`, `pre-holiday`, `january-effect`, `FOMC-meeting`,
  `ramadan-effect`, `payday-anomaly`): **4-12 operazioni l'anno**. Sul nostro storico
  indici (21 mesi) `turn-of-the-month` darebbe **n = 21**, contro un pavimento di **150**.
  🔴 **Muoiono sul CAMPIONE prima di qualunque discussione di merito**, e il pavimento di
  frequenza per famiglia (1,00 op/gg) e' fuori portata di un fattore 20-60;
- **5** sono su strumenti che non quotiamo (VIX term structure, dispersion trading,
  crypto rebalancing, WTI-Brent spread, *intraday seasonality in bitcoin*) **+1** che
  vuole le **opzioni** (`volatility-risk-premium-effect`);
- **1** e' quella che ho lavorato (§4);
- **1** e' `time-series-momentum-effect`, cioe' **la famiglia di `ABTG_EMA200`** — che in
  casa e' **viva ed e' il nostro miglior risultato**.

**65 + 9 + 5 + 1 + 1 + 1 = 82**, contate una per una sui link della pagina, non a occhio.

> 📌 **Da mettere agli atti per chi caccia dopo di me:** Quantpedia e' una buona fonte di
> **TESI**, ed e' una fonte quasi inutile di **MOTORI PER NOI** — perche' il suo
> catalogo gratuito e' fatto di strategie **mensili e cross-sezionali**, e il nostro
> imbuto chiede **intraday/giornaliero su 3-26 simboli con 150 operazioni per lato**.
> Non e' un difetto della fonte: e' un disallineamento di forma, e va saputo **prima** di
> spenderci una battuta.

### 5.4 arXiv — 12 titoli su "overnight returns", 2 aperti e usati, il resto scartato
Scartati: `2402.07134` (tail risk forecasting, non e' una strategia), `2201.09319`
(option volume imbalance: **serve il flusso opzioni**), `1612.07802` e `1309.5806`
(definizione del tempo e feedback di volatilita': **teoria**, nessuna regola),
`1410.5513` (4-factor **cross-sezionale**), `1508.04883` (risk model), `1103.6143`,
`physics/0702106`, `cond-mat/9903220` (modellistica).
⚠️ **E una nota di metodo su me stesso**: cercando il paper della *overnight drift* ho
provato a mano l'id `arXiv 1807.04713` — **e' un paper di viscosita' in QCD**. L'ho
aperto, ho visto che non c'entrava niente e **non l'ho citato**. 🔴 **Un id plausibile e'
la cosa piu' facile da allucinare che ci sia: si apre, o non esiste.**

---

# 6. 🕳️ COSA NON HO POTUTO VEDERE — dichiarato, non riempito

| buco | cosa ci costa |
|---|---|
| 🔴 **GitHub ricerca: 403 STRUTTURALE** | il corpo della risposta dice *"sessions are bound to their configured repositories"*: **non e' quota, non e' un 404, non passera' riprovando.** E' la fonte che di solito da' **il sorgente col contorno** (`.set`, risultati, storia dei commit). **Quarta caccia di fila senza GitHub.** 🙋 **Serve una decisione, non un altro tentativo**: o `gh` CLI autenticato, o due minuti del browser di Claudio su una query concordata |
| 🔴 **SSRN 403 (quinta volta)** | non ho letto **SSRN 3829582** (Vojtko-Hanicova), la fonte primaria della scheda Quantpedia che ho usato. Della tesi ho la **descrizione della scheda**, non il paper. 🙋 **Due minuti del browser di Claudio** |
| 🔴 **newyorkfed.org e stooq.com: `connect_rejected` dal proxy** | niente *staff report* sulla overnight drift, e niente dati giornalieri di indice a basso costo (avrei voluto **decenni**, non 9 anni) |
| 🔴 **Forex Factory 403** | resta chiuso il solo posto dove si legge **come una strategia e' invecchiata** |
| 🟠 **2019 e 2020 assenti dagli indici histdata (404 verificato)** | la finestra piu' importante per il **rischio** di §4 l'ho dovuta prendere da **un altro provider** (Oanda `SPX500_USD`) e su **un altro simbolo**: 93 notti, gen-mag 2020. **Il DAX nel 2020 NON l'ho misurato** |
| 🟠 **`U30USD` e' un `[INFERITO]`** | la deriva notturna del **Dow** non e' misurata: ho riscalato quella di SPXUSD. Nessuna conclusione poggia su quella riga |
| 🟠 **Le sonde sono OHLC M1, non tick, e non sono BCM** | zero slippage, zero spread variabile, altri orari, e **niente regime 2024-2026**. Misure di **occasione e di taglia**, mai verdetti |
| 🟠 **I 5 Pine scaricati e non letti l'08/09** | (`H-L Range Strategy`, `Breakout Scalper Session`, `cATRpillar`, `Linear Regression Reverse`, `Moving Regression Band`) **non recuperati**: nel dossier dell'08/09 non ci sono ne' gli URL ne' gli hash `PUB;`, quindi non e' un "recupero in 10 minuti" come quel dossier sperava — **sono da ritrovare da zero**. Lo scrivo perche' resti un debito visibile |
| 🟠 **TradingView: ricerca testuale in JS, tag troncati** | ho navigato **3 tag**. Uno script taggato male e' invisibile |
| 🟠 **Il 2010 dei miei dati e' mezzo** | 32-33 sedute (da metA' novembre): pesa quasi zero, ma il suo `+0,145%` sul DAX e' su campione minuscolo e **non va letto come un anno** |

---

# 7. 📊 ORDINAMENTO PER VALORE / COSTO — e le passate che ho RISPARMIATO

| # | cosa | passate di tester | costo umano | valore | verdetto di oggi |
|---:|---|---:|---|---|---|
| — | **gamba notturna su indice** | **0** | — | 🔴 **negativo**: il rischio e' bocciato da un invariante | ⬛ **CHIUSA. Non si riapre con altri parametri** |
| 1 | ⚠️ **nota da leggere PRIMA di girare `SONDA_OROLOGIO_11..14`** | 0 | 5 minuti di lettura | 🟢 **alto**: senza quella nota **24 righe su 72** di quella tabella portano una durata falsa e **12 sono doppioni** | 🙋 **da girare a chi ha quelle celle in coda** (non l'ho scritto nei loro file: non sono miei) |
| 2 | 🔑 **rifare i "morti per COSTO" al livello di prezzo di OGGI** | 0 | ~1 ora | 🟢 **alto e strutturale**: la stessa deriva passa da **1,45x** (DAX 11.000) a **3,17x** (DAX 24.000). Chi ha chiuso una pista per costo su dati 2015-2018 **potrebbe aver chiuso una pista viva** | 🟡 **proposta di metodo, decide Claudio** |
| 3 | **chiedere a Claudio due pagine** (SSRN 3829582 · una query GitHub concordata) | 0 | **2 minuti suoi** | 🟢 due fonti murate da 5 cacce | 🙋 **richiesta** |
| 4 | usare finalmente il **`RealCost Spread P95 Logger`** (CB 74148, promosso il 23/08, **mai usato**) | 0 | mezz'ora | 🟡 tutti i cancelli di costo dei **forex** poggiano ancora su **letture uniche** di spread | 🟡 in coda |

🧮 **Il tempo macchina risparmiato, contato:** un round completo su questa famiglia
(EA nuovo + IS/OOS a tick su 2 simboli e 2 lati) sono **~12-16 passate** piu' **2-4 ore**
di `mql5-ea-developer`. Sono state spese **zero passate** e la famiglia e' chiusa con un
certificato che ha un PF-equivalente, un n, un DD, il regime e i due simboli. **Questo e'
il prodotto della giornata.**

---

# 8. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

Non e' *"quale altro motore"*. Dopo 14 famiglie di inefficienza e **60 dossier di caccia** gia' agli atti,
i numeri dicono sempre la stessa cosa, e la domanda giusta e' **una**:

> ## **"Esiste un meccanismo il cui LORDO per operazione sia almeno 3 volte lo spread dell'ora in cui opera, SENZA tenere la posizione dove non possiamo difenderla?"**

Perche' i due vincoli mordono **in direzioni opposte**, e tutto il cimitero sta in mezzo:
- 💰 per battere il costo serve un **lordo grande**, cioe' una **tenuta lunga**
  (la mezz'ora vale 0,33x · la notte 3,17x · il giorno 1,11x · **`EMA200` Dow con stop
  88-104 pt contro spread 2,0 = 44-52x**);
- 🛡️ ma la tenuta lunga **attraversa il buio**, e nel buio lo stop e' un'intenzione.

🥇 **E l'unica cosa in casa che risolve tutte e due contemporaneamente esiste gia' ed e'
`ABTG_EMA200` sul Dow a H1**: lordo enorme in rapporto allo spread (**44-52x**), tenuta
lunga **ma con lo stop vivo dentro la sessione**, PF OOS **1,52** su **n = 517**, **30
celle su 30 a PASS** al walk-forward a tick. **Dopo una giornata passata a cercare fuori,
la risposta migliore resta quella che il censimento del 09/09 ha trovato ferma sul demo.**
👉 In ottica **1° ottobre** questo e' il fatto che conta piu' di qualunque candidato
esterno, e va detto cosi'.

---

# 9. 🧾 RIEPILOGO NUMERICO DELLA BATTUTA

| | |
|---|---:|
| fonti col controllo positivo **passato** | **6** (Code Base elenco+sorgente · Quantpedia elenco+scheda · arXiv API+elenco · TradingView x3 tag · dati esterni) |
| fonti **NULLE oggi**, dichiarate | **5** (SSRN 403 · GitHub 403 **strutturale** · Forex Factory 403 · newyorkfed *connect_rejected* · stooq *connect_rejected*) |
| titoli di strategia **visti** | **~180** (40 Code Base + ~140 TradingView) + **82** schede Quantpedia + **12** titoli arXiv |
| famiglie di inefficienza **ripassate nel cimitero** | **14** |
| candidati **portati alla MISURA** | **1** |
| barre M1 **misurate** | **3.836.472** (GRXEUR 1.718.805 + SPXUSD 2.117.667) **+ 116.586** (SPX500_USD 2020) |
| notti / giornate cash decomposte | **4.129** notti + **4.129** giornate, **controllo appaiato** |
| **promossi** | **0** |
| **file prova consegnati** | **0** — e §10 spiega perche' non ne ho inventati due |
| passate di tester spese | **0** |
| EA / preset / parametri di forward / righe di coda toccati | **0** |

**Attribuzione, come da regola di casa:** la scheda della *overnight anomaly* e' di
**Quantpedia** (rimanda a **Vojtko, Hanicova**, SSRN 3829582 — **non aperto**);
*Strikingly Suspicious Overnight and Intraday Returns* e' di **Bruce Knuteson**
(arXiv 2010.01727); *Does Overnight News Explain Overnight Returns?* e' di **Glasserman,
Krstovski, Laliberte, Mamaysky** (arXiv 2507.04481). I dati M1 vengono da
**FutureSharks/financial-data** (**GPL-3.0**). Le due sonde sono scritte da zero: non c'e'
una riga di codice di nessuno nel repo.

---

# 10. 🎯 E LA RISPOSTA ONESTA ALLA DOMANDA CHE CONTA

## Quanti di questi candidati diventano una sedia entro il 1° ottobre?

# 🔴 ZERO. E lo scrivo come zero.

Non c'e' nemmeno un candidato **in coda**, quindi non c'e' niente da cui possa nascere una
sedia in 19 giorni. E **non ho consegnato i due file prova che il mandato chiedeva**, per
un motivo che e' un conto e non una pigrizia: l'unico candidato arrivato alla misura
**non ha un EA che possa girarlo** (`ABTG_SondaOrologio` non puo' tenere la notte, §4.1) e
**e' stato bocciato dal suo proprio cancello di rischio prima di meritarne uno**. Due file
prova scritti stasera sarebbero stati due file prova su niente: **tempo macchina che non
abbiamo, speso per non tornare a mani vuote.** Il mandato stesso lo dice, ed e' la clausola
che ho seguito alla lettera.

## Allora a cosa serve la giornata? A tre cose, e vanno pesate per quello che sono

1. 🪦 **Una famiglia chiusa con un certificato vero, a costo zero di macchina.** La gamba
   notturna non tornera' piu' in coda con un "e se provassimo...", perche' adesso ha un
   numero invariante davanti. E il certificato **sbagliato** del 05/09 e' corretto agli
   atti: quella e' la regola del 09/09 che lavora.
2. 🐛 **Un difetto trovato in un artefatto che sta in coda.** Le celle
   `SONDA_OROLOGIO_11..14` non sono mai girate: se giravano stanotte, **un terzo della
   tabella** usciva con una durata falsa e nessuno avrebbe avuto modo di accorgersene.
3. 🔑 **Una regola di metodo con un numero dietro**, ed e' quella che potrebbe valere piu'
   di tutto il resto: **"morto per costo" non e' un verdetto permanente, perche' il
   cancello si muove col livello dell'indice.** Da 1,45x a 3,17x sulla stessa deriva. Ci
   sono piste chiuse per costo su dati vecchi che vanno **ricontate ai prezzi di oggi**.

🧭 **Ma la bussola va tenuta ferma, e la regola di casa pretende che lo dica: questa
giornata ha prodotto PONTEGGIO, non una sedia.** Utile, misurato, onesto — e ponteggio.
🥇 **La sedia piu' vicina al 1° ottobre non sta in questo dossier: sta in casa, e si
chiama `ABTG_EMA200` sul Dow a H1** — PF OOS **1,52** su **n = 517**, **30 celle su 30 a
PASS**. Stato agli atti, detto con precisione e non arrotondato in meglio: il censimento del
09/09 l'ha trovata **ferma sul demo**, e al **12/09** il suo pacchetto (5 file prova +
criteri congelati) e' **al cancello** — strato deterministico **PASS**, strato di
giudizio **in corso** (`report/VERIFICHE_ALLA_FONTE_2026-09-12.md`). Non e' schierata, ma
e' **l'unica cosa a un cancello di distanza da una sedia**. Se stasera c'e' un'ora da
spendere, va spesa li', non qui. 💪
