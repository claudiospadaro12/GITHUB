# 🎯 CACCIA — MECCANISMI ALTERNATIVI ALL'ESAURIMENTO DI SUPREV (indici, M30/H1) — 12/09/2026

**Partita da sola**, per la **regola della seconda caccia** (19/08), dopo il verdetto
**A6** dei blocchi B e C di `ABTG_SupRev` sul Dow
(`backtest_pipeline/risultati_archivio/R123_BLOCCO_C_2026-09-12.md`): *"non c'e' una
configurazione robusta su questo asse"* — e, applicando lo stesso cancello A4,
**nemmeno sul blocco B**.

🔒 **Nessun EA toccato. Nessun preset. Nessun parametro di forward. Nessun backtest
lanciato sul tester.** Le misure di questo dossier vengono da **sonde Python su dati
INDICE ESTERNI** (histdata via `raw.githubusercontent.com`), non da MT5.

---

## 🔴 LA PRIMA RIGA, quella che conta

> ## Su **~126 titoli** guardati su **5 fonti vive**, **5 sorgenti letti riga per riga**, **1 candidato portato fino alla MISURA** su 4 anni di dati indice — e **ZERO PROMOSSI**.
>
> Il candidato migliore (**sequenza di inversione monotona**, geometria vergine in
> casa) **e' stato misurato PRIMA di spendere una passata di tester** e ha **fallito
> il cancello che gli avevo scritto addosso prima di guardare i numeri**: il segno
> della E netta doveva reggere in **≥3 anni su 4** e regge in **2 su 4** — positivo
> nel **2015 (crollo d'agosto)** e nel **2018 (orso)**, negativo nel **2016 e 2017
> (toro tranquillo)**.
>
> 🎯 **E questo non e' un caso isolato: e' la TERZA misura indipendente che dice la
> stessa cosa.** In casa, `ABTG_InvEsaurimento` E3 (conferma di spinta persa) fa
> **PF 1,16 nel totale** ma per regime: **−5.604 nel toro 2017**, **+2.946 nell'orso
> Q4-2018** (`REFERTO_INVES_2026-08-30.md`). Il paper **arXiv 2605.04004** (MNQ, 14
> famiglie di segnale, 947 giorni) chiude con *"MNQ OU mean reversion permanently
> rejected (Hurst 0.59, trending)"* e *"MNQ is momentum-dominant at 5-minute
> resolution"*.
>
> ➡️ **L'inversione da esaurimento su indice non e' un motore: e' una scommessa sul
> REGIME.** E la cassaforte tick BCM sugli indici e' **21 mesi di UN SOLO toro**
> (2024.09.26, `COMPLETO`, sonda del 17/08) — cioe' **proprio il regime in cui
> questa famiglia perde**. 🔴 **Spendere passate di tester qui, a tre settimane
> dalla challenge, compra un rosso che non insegna niente.**

---

## 0. ⚖️ I CRITERI, congelati prima di aprire un browser

Presi alla lettera dal mandato, non riscritti dopo.

| # | criterio | soglia |
|---|---|---|
| **C1** | meccanismo **DIVERSO**, non un Supertrend ritarato | niente banda ATR + moltiplicatore. Il detector deve essere di **un'altra famiglia** |
| **C2** | TF **M30 o H1** sugli indici | M5/M15 fuori per costo (frontiera `stop ≥ 40 × spread`) |
| **C3** | **stop vero all'ingresso** | niente stop = scarto, per quanto bello sia il grafico |
| **C4** | **frontiera del costo** | stop tipico ≥ **40 × spread**. Spread misurati: **D30EUR 1,65** · U30USD 1,95 · NASUSD 1,6-1,8 → soglia **66 / 78 / 64-72 punti indice** |
| **C5** | **frequenza di FAMIGLIA ≥ 1,00 op/giorno** (firma 07/09) | motore × simboli schierabili |
| **C6** | §4 non si ammorbidisce | martingala · griglia · recovery · mediazione · size variabile (FTMO Forbidden Practice n.8) · repaint · look-ahead → fuori, **con la riga di codice** |
| **C7** | passa la **lista dei caduti** | `backtest_pipeline/REGISTRO_TEST.md` + i dossier `CACCIA_*` (in particolare quelli del 06/09 e dell'08/09, che hanno battuto **questo stesso** bersaglio) |
| **C8** | i **numeri dichiarati dagli autori non pesano** | non ne ho guardato nemmeno uno. Dove li cito sono etichettati |

---

## 1. 📕 COSA HO LETTO IN CASA PRIMA DI USCIRE — e perche' il bersaglio era quasi vuoto

`CLAUDE.md` · `report/ROBUSTEZZA.md` · `report/ROTTA_PROP.md` ·
`backtest_pipeline/prove/CELLE_REGIME.txt` ·
`backtest_pipeline/caccia_strategie/SETACCIO_MANUALE.md` ·
`backtest_pipeline/REGISTRO_TEST.md` (2.049 righe) ·
`backtest_pipeline/risultati_archivio/R123_BLOCCO_C_2026-09-12.md` ·
`backtest_pipeline/prove/R123c_U30USD_02_atrperiod.txt` (378 righe, per la forma del
file prova) · `report/CACCIA_M30_INDICI_2026-09-08.md` (la battuta **gemella** di 4
giorni fa, stesso TF, stessi simboli) · `report/GIACIMENTO_DI_CASA_2026-09-03.md` ·
`backtest_pipeline/risultati_archivio/REFERTO_INVES_2026-08-30.md` ·
`report/CENSIMENTO_LATO_SHORT_2026-09-09.md` ·
`backtest_pipeline/caccia_strategie/biblioteca/sorgenti/` (108 sorgenti gia' archiviati).

### 1.1 ⛔ La famiglia "esaurimento su indice" e' il pezzo di cimitero piu' pieno che abbiamo

Non l'ho dedotto: l'ho contato. Ognuna di queste righe e' una **misura di casa**.

| geometria | stato, col numero |
|---|---|
| **fade della banda incondizionato** (Bollinger/Keltner) | ⬛ **R108/R111: 6 finestre su 6 rosse**, con gradiente **H1 > M30 > M15** — peggiora **proprio dove sto cercando** |
| **fade degli estremi del range d'apertura** | ⬛ **R42: 0/24 IS e 0/24 OOS** |
| **fade dell'estremo a lookback** (`ABTG_MeanRevert`) | ⬛ **R60: 12 celle su 12 in perdita**, PF max **0,986**, DD fino al **37%** |
| **RSI/ATR exhaust + spike di volume** (`ABTG_AtrExhaustVol`) | ⬛ **R109: DD 44-68%** |
| **falsa rottura di livello** (CRT / Turtle Soup / BreakinBox) | ⬛ **tre volte, 0/30 celle a tick** |
| **sweep di liquidita' su micro-pivot** | ⬛ chiuso (M24), **R89** |
| **ritorno alla VWAP** (`ABTG_VwapRevert`) | ⬛ **falsificato il 03/09**: rapporto punti/spread **negativo su 4 celle su 4** |
| **fade del salto statistico** (Lee-Mykland) | ⬛ **9 celle su 9** peggio del controllo casuale: *"sui nostri strumenti il salto CONTINUA"* |
| **fade post-notizia** | ⬛ **PF 0,85 / 0,66-0,90** |
| **momentum "prima mezz'ora → ultima mezz'ora"** (Gao) | ⬛ **R98**, bocciato dal cancello del costo |
| **deriva a mezz'ora** (M27) | ⬛ chiuso su **1.518 sedute**: la mezz'ora migliore vale **1,63 punti** contro un cancello di **4,95** = **0,33×** |
| **reversione overnight → intraday** | ⬛ chiusa il 05/09 |
| **stagionalita' / giorno della settimana** | ⬛ **R63: 0/24 OOS** su 11.928 operazioni |
| **IBS (Internal Bar Strength)** | 🟡 **gia' in coda dal 06/09** — non si conta due volte |

### 1.2 🔑 E la misura di casa che orienta tutta la caccia — `ABTG_InvEsaurimento` (30/08)

E' l'unico EA nostro nato **esattamente** su questa inefficienza (contratto firmato,
stop vero, rischio %, flat di fine seduta, zero martingala). Screening OHLC su
NASUSD_EXT M15, 2017-2020:

| cella | n | PF | DD% | lettura |
|---|---:|---:|---:|---|
| baseline (inversione nuda al livello) | 323 | **1,00** | 9,25 | **una moneta** |
| **E1 = esaurimento >= 1,0× ADR14** (l'ipotesi firmata) | 68 | **0,95** | 9,93 | 🔴 **la chiave firmata NON gira** |
| **E3 = perdita di spinta** (2-3 barre a range calante) | 215 | **1,16** | 8,16 | 🟢 l'unica verde... |

...ma **per regime**: **2017 toro −5.604** · **Q4-2018 orso +2.946** · ripresa-V 2020
**+839** · resto-2020 **+5.597**.

> 🎯 **La legge che ne esce, e che ho usato come bussola oggi: sull'esaurimento di
> indice la variabile viva non e' l'ESAURIMENTO, e' la CONFERMA — e anche la
> conferma e' REGIME-CONDIZIONALE.** Quindi non cercavo "un altro fade": cercavo
> **un detector di conferma di un'altra famiglia**, e poi l'ho messo alla prova del
> regime **prima** di chiedere il tester.

---

## 2. 🔎 LE FONTI E IL CONTROLLO POSITIVO — misurato oggi, una per una

| fonte | bersaglio del controllo | esito misurato | verdetto |
|---|---|---|---|
| **MQL5 Code Base — elenco** | `/en/code/mt5/experts` e `/page2` | **200**, **80 titoli** resi (page1 40 + page2 40) — ⚠️ **ma autore e data NON compaiono** nella resa markdown | 🟡 **PASSA a meta'**: i titoli sono veri, i metadati vanno presi sulla scheda |
| **MQL5 Code Base — scheda** | `/en/code/74582` | **200**, titolo + autore (**Syamsurizal Dimjati / RitzFalih**) + data (**02/07/2026**) | 🟢 **PASSA** |
| **MQL5 Code Base — sorgente** | `/en/code/download/74582` | **200**, `application/zip`, **2.888 byte** → `KCI_Embeded_EA_Sniper_Ver_1.mq5`, **234 righe** vere | 🟢 **PASSA** (il §4 e' applicabile senza intermediari) |
| **TradingView — elenchi per tag** | `/scripts/reversal`, `/scripts/meanreversion`, `/scripts/exhaustion` (`script_type=strategies`) | **200**, **23 + 22 + 1 = 46 titoli** con autore | 🟢 **PASSA** |
| **TradingView — sorgente Pine** | `pine-facade/get/PUB;<hash>/last` | **200**, `scriptAccess = open_no_auth`, **4 sorgenti** scaricati in chiaro (3.162 / 3.511 / 2.246 / 12.575 byte) | 🟢 **PASSA** |
| **arXiv — pagina elenco** | `arxiv.org/list/q-fin.TR/recent` | **200**, 8 titoli + id (2609.11614 … 2609.03115) | 🟢 **PASSA** |
| **arXiv — API** | `export.arxiv.org/api/query` | **301 su http**, **timeout a 60 s su https** | 🔴 **NULLA oggi** (ieri passava: **non e' un 404**) |
| **SSRN** | `papers.ssrn.com/sol3/papers.cfm?abstract_id=689282` e `=5039009` | **403** entrambe | 🔴 **NULLA** (quarta volta di fila: 06/09, 08/09, oggi) |
| **Quantpedia** | `quantpedia.com/strategies/` | **308** | 🔴 **NULLA** |
| **GitHub** | UI `search?q=...` e `api.github.com/search/repositories` | **403** entrambe | 🔴 **NULLA** (scoping, non quota) |
| **Forex Factory** | `/forum/71-trading-systems` | **403** | 🔴 **NULLA** |
| **QuantConnect** | `/docs/v2/writing-algorithms` | **200** (solo documentazione) | 🟡 raggiungibile, **libreria di strategie non setacciata** — dichiarato |
| 🥇 **Dati indice esterni** | `raw.githubusercontent.com/FutureSharks/financial-data` — `GRXEUR` e `SPXUSD` M1 2015-2018 | **200 × 8 file**, **131 MB**, **1.942.126 barre M1** | 🟢 **PASSA** — ed e' la fonte che ha deciso la caccia |

### 2.1 🕐 Il collaudo dell'OROLOGIO, fatto PRIMA di leggere qualunque altro numero

Regola di casa (e lezione del 10/09: *"un orologio sbagliato produce un numero pulito
e falso"*). Minuto file a piu' alta |variazione| media M1, misurato da me oggi:

| simbolo | i 3 minuti piu' mossi | cosa dovrebbero essere | esito |
|---|---|---|---|
| `GRXEUR` (DAX) | **03:00** (7,51) · 03:05 (6,66) · 03:02 (5,68) | apertura DAX = **08:00 server** = 03:00 file | ✅ |
| `SPXUSD` | **15:59** (1,05) · **09:31** (0,94) · 09:35 (0,93) | chiusura e apertura cash USA | ✅ |

➡️ **`ora file + 5 = ora server BCM` confermata sui dati che ho scaricato io**, non
ereditata. Le finestre cash usate: DAX **file 03:00-11:30** (= server 08:00-16:30),
SPX **file 09:30-16:00** (= server 14:30-21:00).

---

## 3. 🧪 IL CANDIDATO PORTATO FINO ALLA MISURA

### 3.1 La scheda

```
NOME            Momentum Sequence Strategy [Herman]
FONTE / URL     https://www.tradingview.com/script/mmrInMTp-Momentum-Sequence-Strategy-Herman/
                sorgente: pine-facade PUB;11d65a5fe0724173b72c230c576947fc  [LETTO, 12.575 byte]
AUTORE / DATA   helmans13 · creato 2026-09-04 (campo `created` della pine-facade)
POPOLARITA'     non letta -- non e' un criterio                       [INCERTO]
LICENZA         MPL 2.0, dichiarata nelle prime due righe del sorgente
RIGHE / INPUT   ~330 righe Pine · input di STRATEGIA: 2 (lunghezza sequenza, TP in R)
                + 2 interruttori di lato + 6 cosmetici (tabella/visuali)

TESI IN UNA RIGA
  "Dopo una candela direzionale, una sequenza MONOTONA di candele contrarie che
   non viola l'estremo di quella candela dice che il movimento e' finito e che il
   nuovo verso e' stato ACCETTATO: si entra col nuovo verso, stop all'estremo
   della candela esaurita."

MECCANICA (letta nel sorgente, righe 137-233)
  ingresso  candela madre bearish (close<open) + N candele (2..5) tutte bullish,
            tutte con low > low(madre), con chiusure STRETTAMENTE crescenti ->
            LONG al close della N-esima. SHORT = specchio esatto.
  stop      low(madre) per il long, high(madre) per lo short -> STRUTTURALE, non ATR
  target    TP = entry +/- RR x 1R, con RR in {0,5 · 1 · 1,5 · 2}
GESTIONE RISCHIO  `default_qty_type = strategy.fixed`, 1 contratto -> LOTTO FISSO
                  (e' la parte che rifaremmo noi), `pyramiding = 0`,
                  una posizione per volta, `strategy.exit(stop=..., limit=...)`
BANDIERE ROSSE    NESSUNA del §4: niente martingala, niente griglia, niente hedge,
                  nessuna aggiunta su posizione aperta, niente `request.security`,
                  `calc_on_every_tick` NON impostato (default false) -> no repaint
COSTO DI PORTING  Pine -> MQL5 = RISCRITTURA, ma e' il motore piu' piccolo che
                  abbiamo mai valutato: ~200-250 righe con chassis di casa
                  (LotByRisk, sessione in ora server, OnTester). ~2-4 ore uomo
                  di `mql5-ea-developer`. NON scritto: non e' il mio perimetro.
```

**Perche' e' un meccanismo DIVERSO e non un Supertrend ritarato** — e lo dico con la
riga di codice: `ABTG_SupRev` decide con `iATR` + moltiplicatore di banda
(`R123c…txt`, mq5 r.133/r.373) e conferma con **corpo candela + confluenza EMA**.
Questo motore **non ha nessun indicatore**: nessun ATR, nessuna EMA, nessuna banda,
nessun oscillatore. Il detector e' la **forma della sequenza** e lo stop e' un
**livello strutturale**. In tutto il repo la geometria "N chiusure monotone" ha **zero
occorrenze** (`grep -i "streak|consecutiv"` su `report/` + `backtest_pipeline/`: solo
falsi positivi su "perdite consecutive" e "corse consecutive").

### 3.2 🥇 LA MISURA — 2 simboli, 4 anni, 1,94 milioni di barre M1, nessuna passata di tester

Sonda: `backtest_pipeline/caccia_strategie/biblioteca/sonde_esterne/sonda_sequenza.py`
(geometria copiata riga per riga dal Pine, verificata punto per punto contro il
sorgente). Ambiguita' intrabarra **sempre a sfavore** (lo SL si controlla **prima** del
TP), zero costi dentro la sonda, costo aggiunto dopo **in R** con gli spread misurati
di casa. **Controllo APPAIATO** come da regola del 05/09: stessa barra, stesso 1R,
**lato opposto**.

**GRXEUR (DAX), sessione cash, RR = 2,0, orizzonte 96 barre M30 / 48 barre H1:**

| TF | N | lato | n | op/gg | **1R mediano** | **1R / spread** | costo | WR | WR appaiato | **E netta** |
|---|---:|---|---:|---:|---:|---:|---:|---:|---:|---:|
| M30 | 2 | L | 1.145 | 1,138 | 40,5 pt | **24,5×** ❌ | 0,041R | 34,1% | 32,4% | **−0,018R** |
| M30 | 2 | **S** | 1.097 | 1,090 | 43,5 pt | **26,4×** ❌ | 0,038R | 35,7% | 33,1% | **+0,032R** |
| M30 | 3 | L | 543 | 0,540 | 55,0 pt | 33,3× ❌ | 0,030R | 30,3% | 32,6% | **−0,122R** |
| M30 | 3 | **S** | 498 | 0,495 | 59,3 pt | 35,9× ❌ | 0,028R | 35,6% | 30,1% | **+0,041R** |
| M30 | 4 | L | 233 | 0,232 | 74,0 pt | **44,8×** ✅ | 0,022R | 29,5% | 34,4% | **−0,138R** |
| M30 | 4 | **S** | 209 | 0,208 | 83,3 pt | **50,5×** ✅ | 0,020R | 34,2% | 28,7% | **+0,006R** |
| H1 | 2 | L | 596 | 0,592 | 57,5 pt | 34,8× ❌ | 0,029R | 30,1% | 32,2% | **−0,124R** |
| H1 | 2 | **S** | 564 | 0,561 | 60,1 pt | 36,4× ❌ | 0,027R | 36,1% | 33,2% | **+0,055R** |
| H1 | 3 | L | 265 | 0,263 | 79,3 pt | **48,0×** ✅ | 0,021R | 27,0% | 33,2% | **−0,211R** |
| H1 | 3 | **S** | 251 | 0,250 | 85,8 pt | **52,0×** ✅ | 0,019R | 35,9% | 27,8% | **+0,057R** |
| H1 | 4 | **S** | 97 | 0,096 | 103,5 pt | **62,7×** ✅ | 0,016R | 35,9% | 21,9% | **+0,061R** |

_(1.006 giorni di sessione. La tabella completa — 3 valori di RR × 4 valori di N × 2
lati × 2 TF × 2 simboli — sta nell'uscita della sonda; qui riporto le righe che
decidono.)_

**Tre fatti veri e utili, che tengo anche se il candidato cade:**

1. 🐻 **L'ASIMMETRIA DEI LATI E' NETTA E MONOTONA.** Lo **short** e' positivo in
   **tutte e 6** le combinazioni (N × TF) su DAX; il **long** e' negativo in **6 su
   6**, e peggiora al crescere di N (fino a **−0,211R** su H1 N=3). Sullo stesso
   segnale il controllo appaiato conferma: quando lo short fa 35,9%, il lato opposto
   sulla **stessa barra** fa 27,8%.
   👉 Tesi leggibile: *una sequenza monotona di chiusure in DISCESA che rispetta il
   massimo della candela madre e' una liquidazione in corso e continua; la stessa
   geometria in salita non paga, perche' il rialzo di un indice non liquida nessuno.*
2. 💰 **LA FRONTIERA DEL COSTO E' UN CONTO, E DICE DOVE SI PUO' STARE.** Con lo
   spread **misurato** del DAX (1,65 punti indice) il cancello `stop ≥ 40 × spread`
   vale **66 punti indice**. La geometria lo passa **solo** da **N=3 su H1** (85,8 pt
   = 52×) e da **N=4 su M30** (83,3 pt = 50×). A N=2 siamo a **24-36×**: fuori.
3. 📉 **E DOVE PASSA IL COSTO NON PASSA IL CAMPIONE.** Sui 459 feriali della
   cassaforte tick BCM (2024.09.26 → 2026.06.30): H1 N=3 short = **0,250/gg → 115
   operazioni in tutto**, spezzate 40/60 fanno **46 e 69**. **Sotto il pavimento dei
   150 in entrambe le finestre** (Emendamento A). Le celle che arrivano al campione
   sono quelle che **non passano il costo**: M30 N=3 L+S = **1,035/gg → ~475
   operazioni** (190/285, passa il pavimento) ma **1R = 33-36× lo spread**; M30 N=2
   L+S = **2,23/gg → ~1.020 operazioni** e **1R = 24-26×**, cioe' ancora peggio.
   🎯 **E' la stessa tenaglia di M31**: *la cella con l'edge non ha campione, la
   cella col campione non ha edge.*

### 3.3 🛑 IL CONTRO-ESEMPIO OBBLIGATORIO — e ha ucciso il candidato

**Cancello scritto PRIMA di guardare l'uscita** (sta nell'intestazione di
`sonda_sequenza_anni.py`, righe 8-11): *"il segno della E netta deve reggere in almeno
**3 anni su 4**. Se sta in 1 anno su 4, il candidato NON entra nell'imbuto."*
Costruito cosi' proprio perche' il modo piu' facile di sembrare buono per caso, su
questa famiglia, e' **avere dentro un anno di orso**.

**GRXEUR, RR 2,0, E netta per anno:**

| TF | N | lato | 2015 | 2016 | 2017 | 2018 | anni positivi |
|---|---:|---|---:|---:|---:|---:|:---:|
| M30 | 2 | S | **+0,116** | −0,100 | −0,133 | **+0,210** | **2/4** ❌ |
| M30 | 3 | S | **+0,061** | −0,119 | −0,004 | **+0,169** | **2/4** ❌ |
| H1 | 2 | S | **+0,266** | −0,013 | −0,062 | **+0,025** | **2/4** ❌ |
| H1 | 3 | S | **+0,297** | −0,115 | −0,241 | **+0,201** | **2/4** ❌ |
| H1 | 4 | S | **+0,337** | **+0,125** | −0,420 | **+0,222** | 3/4 ✅ **ma n = 21-26 per anno** |
| M30 | 3 | L | +0,081 | −0,208 | −0,063 | −0,351 | 1/4 ❌ |
| H1 | 3 | L | −0,084 | −0,171 | −0,293 | −0,314 | **0/4** ❌ |

> ### 🔴 VERDETTO: **IL CANDIDATO NON ENTRA NELL'IMBUTO.**
> Il lato short e' positivo **esattamente e solo** nei due anni con volatilita' e
> discese (**2015**: crollo d'agosto; **2018**: orso di febbraio e del Q4) e negativo
> **in entrambi** gli anni di toro tranquillo (**2016, 2017**). L'unica riga che passa
> il cancello 3/4 (H1 N=4) lo fa con **21-26 operazioni per anno**: e' un campione su
> cui non si pronuncia nessuno, e sta nel capo **ad alta varianza** della griglia.
>
> ✅ **E l'altra meta' del contro-esempio: ho provato anche a ROMPERE il risultato
> al contrario.** Se il lato long e' un perdente affidabile (0/4 anni su H1 N=3,
> **−0,211R**), non se ne ricava un vincitore invertendolo: il controllo appaiato —
> stessa barra, stesso 1R, lato opposto — da' **−0,023R**, non +0,2R. Il motivo e'
> geometrico e va scritto perche' e' una trappola ricorrente: **con SL e TP asimmetrici
> (1R contro 2R) i due lati NON hanno payoff simmetrico**, quindi *"lo specchio di un
> perdente e' un vincitore"* e' falso. Verificato, non assunto.

### 3.4 🏛️ La riga prop, che si scrive anche quando e' sfavorevole

In ottica prop questo motore sarebbe **interessante per il lato** (short su indice =
il nostro buco: `CENSIMENTO_LATO_SHORT_2026-09-09.md`) e **rassicurante per la
geometria** (stop strutturale = piccolo in punti, quindi taglia scalabile a 100k).
🔴 **Ma il profilo temporale e' quello sbagliato per una prop**: le operazioni si
addensano nei giorni di liquidazione, cioe' **N trade correlati nella stessa seduta**
— che e' rischio **giornaliero** (muro 5% = **−5.000 su 100k**), non edge
diversificato. E il DD di una famiglia che vive solo in due anni su quattro, sul
trailing drawdown di alcune prop, e' **[NON MISURATO]**.

---

## 4. 🚫 GLI ALTRI SORGENTI LETTI RIGA PER RIGA — quattro scarti, con la riga di codice

### 4.1 `EA KCI Embeded Sniper` — **SCARTO** (tesi non scrivibile + volume tick + lotto fisso)
```
FONTE   https://www.mql5.com/en/code/74582   [.mq5 SCARICATO E LETTO, 234 righe]
AUTORE  Syamsurizal Dimjati (RitzFalih) · 02/07/2026 · licenza NON dichiarata [INCERTO]
```
Meccanica (r.106-152): calcola quattro z-score (`vq` velocita' netta/percorso, `kd`
distanza dalla media, `ed` dispersione, `pv` spostamento netto), li somma a coppie in
valore assoluto (`Raw_KCI`), e spara quando `Raw_KCI` fa un **minimo locale** sotto
soglia **+** cala l'"energia" **+** il Williams %R e' a un estremo (r.225-233).
- 🟢 **Niente §4**: nessun martingala, nessuna griglia, nessun hedge, **SL e TP veri
  passati nell'ordine** (r.228: `trade.Buy(..., ask - current_ed*InpEDMultiplierSL, ask + ...)`),
  una sola posizione (r.200), decisione **solo su barra nuova** (r.199) e su indici
  `[1]`/`[2]` = **nessun look-ahead**.
- 🔴 **§5.C — la tesi non si scrive in una riga**: *"la somma delle differenze
  assolute di quattro z-score fa un minimo locale"* non e' un meccanismo di mercato,
  e' una quantita' inventata. Non e' rifinibile: non so **che cosa** starei misurando.
- 🔴 **r.145: `is_energy_drop` usa `CopyTickVolume`** → su un CFD di indice quello
  conta **i tick, non i contratti** (regola Paolo). Variabile diversa da quella del
  sorgente.
- 🔴 **r.14: `input double InpLotSize = 0.01`** → lotto fisso, non scalabile (§4).
- 🧨 **E UN BACO VERO, che regalo a chi lo usera'**: r.206-215, se
  `InpUseTrendFilter = true` l'EA **non puo' piu' aprire niente** — la condizione
  buy (`bid < ma → return`) e la condizione sell (`bid > ma → return`) sono **entrambe
  applicate a ogni tick**, quindi passa solo `bid == ma`. Il filtro, accendendolo,
  spegne l'EA. Default `false`, quindi inerte: e' un baco silenzioso.
- 🔵 **Pezzo che tengo come IDEA (non come candidato)**: *"la conferma e' il CALO DI
  ENERGIA"* — parente del nostro **E3** (barre a range calante), misurato in modo
  diverso. Se un giorno E3 tornera' in pista, questa e' una seconda formulazione da
  confrontare.

### 4.2 `The Bar Counter Trend Reversal Strategy [TradeDots]` — **SCARTO C3 + famiglia morta**
```
FONTE   https://www.tradingview.com/script/0KAtQQDD-...  (PUB;5ac70a223eed41a991aa7f2140d06d9b)
AUTORE  tradedots · pagina 07/10/2024 · open-source [SORGENTE LETTO, 67 righe]
```
- 🔴 **NESSUNO STOP, in nessuna forma**: nel sorgente non esiste `strategy.exit`;
  ci sono solo `strategy.entry` (r.55, r.61), quindi la posizione si chiude **solo
  quando arriva il segnale opposto**. C3 non si ammorbidisce.
- 🔴 **Il motore e' l'esaurimento GREZZO** (`ta.falling(close, N)` / `ta.rising(close, N)`,
  r.29-41) con, per default, la conferma di **bordo di canale Keltner/Bollinger**
  (r.22-34): cioe' **E1 + fade della banda**, le due cose che in casa hanno **PF 0,95**
  e **6 finestre su 6 rosse**.
- 🔴 `volume_confirm` usa `volume` (r.29-30, r.37-38) → tick volume su CFD.

### 4.3 `AxMan Exhaustion Detection Reversal Rider` / `Sniper V4: Liquidity & Fast Exhaustion` — **SCARTO C3 + doppia famiglia morta**
```
FONTE   https://www.tradingview.com/script/72gQqAzW-AxMan-Exhaustion-Detection-Reversal-Rider/
        sorgente: PUB;d71c8d016bc44debb3d7507dea838a6c  [LETTO, 81 righe]
AUTORE  Axj_Stev (pagina) · creato 2026-03-02 · open_no_auth
⚠️ [INCERTO] il nome reso dalla pine-facade e' `Sniper V4: Liquidity & Fast Exhaustion`,
   diverso dal titolo della pagina: e' l'UNICO PUB presente in quell'HTML, quindi
   e' quel sorgente -- ma il titolo non combacia e lo dichiaro.
```
- 🟢 Struttura interessante e coerente con la nostra legge della conferma: **arma**
  su esaurimento (r.24-26) e **poi aspetta** la conferma entro 12 barre (r.40-41).
- 🔴 **Nessuno stop**: si esce **solo** sul segnale di esaurimento opposto
  (r.44-45, r.61-64). C3.
- 🔴 L'armamento e' **RSI estremo + spike di volume** (= `ABTG_AtrExhaustVol`, **R109
  DD 44-68%**) **+ liquidity grab** (r.20-22 = M24, **0/30 celle a tick, chiuso tre
  volte**). Due famiglie sepolte in tre righe.

### 4.4 `Bearish Wick Reversal` (Botnet101) — **SCARTO C3 + repaint + frequenza zero sul bersaglio**
```
FONTE   https://www.tradingview.com/script/Kz4wRzup-Bearish-Wick-Reversal/
        sorgente: PUB;ec397d909b2a4feea71cc37ad75bd2dc  [LETTO, 57 righe]
AUTORE  Botnet101 · creato 2025-01-24
```
- 🔴 **Nessuno stop** (solo `strategy.close_all()` su `close > high[1]`).
- 🔴 **`calc_on_every_tick = true`** nella dichiarazione `strategy(...)` → e' la
  firma che il §4 elenca come rischio di repaint/ottimismo di riempimento.
- 🔴 **Un lato solo** (long).
- 🔴 **Soglia dimensionale incompatibile col bersaglio**: entra se
  `100*(low-close)/close <= -1`, cioe' se la coda inferiore vale **≥ 1% del prezzo**.
  Sul DAX a 24.000 sono **240 punti in una barra**; su H1 in sessione non capita
  quasi mai. Il motore e' giornaliero su azionario, non intraday su indice.

---

## 5. 🗂️ GLI SCARTI DI GRUPPO — visti, non aperti, col motivo

| gruppo | quanti | perche' non ho aperto il sorgente |
|---|---:|---|
| **Code Base page 1-2: pannelli, calcolatori, logger, copier, demo Renko** | ~52 | non sono strategie. Confermato per la **sesta** volta di fila (31/08, 06/09, 08/09, 11/09, oggi) |
| **Code Base: `EA KCI N-Matrix engine`** | 1 | ⬛ **gia' scartato il 06/09 leggendo il sorgente**: `InpLotMultiplier = 1.3` (martingala), `InpAveragingKVRStep` (griglia), 222 input |
| **Code Base: `002 - Inside Bar`, `003 - Weekly Day Reversal`, `001 - Turnaround Tuesday`** | 3 | ⬛ **scartati per iscritto tre volte** (16/08, 22/08, 08/09). `003` mette la **direzione fra gli input** e lascia decidere all'ottimizzatore se la tesi e' inversione o continuazione |
| **Code Base: `Sniper Gold Hybrid Recovery`, `Daily Zone Recovery EA`, `RSI Grid Overlap Pro`** | 3 | **§4 dal titolo**: recovery / griglia |
| **Code Base: ORB e breakout** (`Session Opening Range Breakout`, `AAPL cfd - ORB`, `Universal Breakout Study`, `GoldLondonBreakout`, `MA + Envelope Breakouts`) | 5 | ⬛ **~210 celle a tick**, R45 0/48, R12 48/48 negative |
| **Code Base: `SuperTrend TV EA`, `SuperTrend_Amarnath...`** | 2 | 🔴 **e' il motore che oggi ha detto A6**: sarebbe "un'altra taratura dello stesso Supertrend" = esattamente cio' che la regola della seconda caccia vieta |
| **Code Base: scatole nere** (`Aegis Quantum Lite`, `Market Miner`, `BlueMoon`, `EA AurumNeuro Vanguard`, `HybridMicrostructure`) | 5 | §5.C tesi non scrivibile; 4 su 5 **gia'** scartati (16/08, 29/08, 11/09) |
| **TradingView: IBS in tutte le sue forme** | 4 | 🟡 **gia' in coda dal 06/09** — contarlo due volte sarebbe barare sul numero dei candidati |
| **TradingView: short-only giornalieri di Botnet101** (`10-Bar Low Pullback`, `Consecutive Bars Above MA`, `Consecutive Close>High[1]`, `ATR Sell the Rip`, `Gap Down Reversal`) | 5 | il **lato** e' il nostro buco, ma sono **giornalieri su SPY/QQQ** e **senza stop**: C1 + C3. (Ne ho letto uno nel sorgente, §4.4, per verificare che la firma fosse davvero quella) |
| **TradingView: mashup multi-indicatore** (`Tristan's Multi-Indicator ×3`, `ULTIMATE TEMA/LSMA`, `Ultimate Institutional`, `Squared9 Pro`, `MACD Volume`, `SSL Wave Trend`, `EWO+RSI Exhaustion Filter`) | ~9 | nessuna tesi in una riga → spazzolata. E `EWO+RSI ... Exhaustion **Filter**` e' letteralmente un **filtro appiccicato**: **0 successi su 5** in casa |
| **TradingView: sweep/liquidita'** (`Sweep & Reverse`, `Liquidity Sweep Rider HFT`, `Rally Base Drop SND`) | 3 | ⬛ M24, chiuso tre volte, 0/30 |
| **TradingView: banda/z-score/VWAP** (`Z-Score Mean Reversion Pro`, `BB SPY`, `Reverse Keltner`, `Tri-band`, `RVWAP Mean Reversion`, `VWAP Mean Reversion ... RSI Volume`, `TriAnchor Elastic Reversion`, `Bollinger+RSI`) | ~8 | ⬛ M14 (R108/R111 6/6 rosse) e VwapRevert **falsificato**. `TriAnchor` e' anche **gia' in biblioteca** dall'08/09 |
| **TradingView: `ATR Exhaustion & Volume Spike`, `HV Spike`** | 2 | 🟡 **gia' in casa**: il primo **e'** `ABTG_AtrExhaustVol` (**R109**), il secondo e' il **promosso P3 dell'08/09**. Riconosciuti, non riproposti |
| **TradingView: cripto / indiani / ETF-only** | ~6 | strumenti che BCM non quota |

---

## 6. 🕳️ COSA NON HO POTUTO VEDERE — dichiarato, non riempito

| buco | cosa ci costa |
|---|---|
| 🔴 **SSRN 403** | i due paper che avrei voluto leggere per la tesi — **Grant-Wolf-Yu, "Intraday Price Reversals in the US Stock Index Futures Market: A 15-Year Study"** (`abstract_id=689282`) e **Baltussen-Da-Soebhag, "End-of-Day Reversal"** (`=5039009`) — **NON li ho aperti**. Li nomino come **bersagli**, non come fonti: di entrambi ho visto solo il titolo nell'elenco dei risultati di ricerca, e un titolo non e' un paper. Sono due minuti del browser di Claudio |
| 🔴 **arXiv API in timeout** | ho potuto leggere solo la **pagina** `q-fin.TR/recent` (8 titoli, tutti microstruttura/ML/order flow: nessuno traducibile su un CFD di indice). La ricerca per parola chiave nella letteratura **non l'ho fatta** |
| 🔴 **GitHub 403 (UI e API)** | fronte **non battuto**. ⚠️ E' uno **scoping**, non un 404 e non una quota: si riprova |
| 🔴 **Forex Factory 403** | il posto dove si legge **come una strategia e' invecchiata** resta chiuso |
| 🔴 **Quantpedia 308** | niente |
| 🟠 **QuantConnect raggiungibile ma non setacciato** | la sua libreria di strategie Python non l'ho guardata: e' un fronte aperto per la prossima battuta |
| 🟠 **MQL5: la ricerca interna e' in JS** | posso solo **scorrere l'elenco per data**. Un EA con il motore perfetto ma pubblicato sei mesi fa e' **invisibile** senza scorrere 12 pagine |
| 🟠 **TradingView: la ricerca testuale e' in JS e i tag sono troncati a ~24** | ho navigato 3 tag. Uno script taggato male e' invisibile |
| 🟠 **Lo spread BCM di SPXUSD e' [NON MISURATO]** | nella sonda ho usato **1,95** (il valore U30USD) come **proxy dichiarato**, ed e' **sbagliato in scala** (SPX stava a 2.000-2.800 in quegli anni, il Dow a 25.000): tutte le righe SPXUSD del costo sono un **tetto**, non una misura. ⚠️ **Nessuna conclusione poggia su di esse**: il verdetto e' costruito sul DAX, dove lo spread e' misurato (1,65) |
| 🟠 **Le sonde sono OHLC M1, non tick, e sul feed histdata** | non e' BCM: niente slippage, niente spread variabile, altri orari. Sono **misure di occasione e di taglia**, mai verdetti (LEGGIMI.md, limiti 1-6) |
| 🟠 **La finestra della sonda e' 2015-2018** | **non** copre il regime 2024-2026 delle sedie. ✅ Ma copre i due regimi che su BCM sugli indici **non esistono** (laterale 2015-2016, orso 2018) — ed e' precisamente questo che ha permesso il contro-esempio |
| 🟠 **Sovrapposizione dei segnali** | la sonda conta **tutti** i setup, anche sovrapposti, mentre il Pine entra solo se e' piatto. Quindi le op/giorno della tabella sono un **tetto**, e il pavimento di frequenza va letto con quella riserva |

---

## 7. 📊 ORDINAMENTO PER VALORE/COSTO, in passate di tester

Ordinato per **valore atteso diviso costo**, non per simpatia. Le passate sono
**IS+OOS a tick reali sul banco 50504400 (`C:\MT5_Backtest`)**.

| # | cosa | passate | costo umano | valore atteso | verdetto di oggi |
|---|---|---:|---|---|---|
| — | **Sequenza di inversione** (il candidato di §3) | 14 (6 sul lato + 8 sull'asse N) | 2-4 h di `mql5-ea-developer` per un EA nuovo | 🔴 **basso ADESSO**: il cancello 3/4 anni e' **fallito**, e la finestra BCM e' il regime in cui la famiglia **perde**. Una corsa qui compra un rosso prevedibile | ⏸️ **CONGELATO, non morto**. Spec e criteri congelati in `prove/SEQUENZA_INDICI_SPEC.txt`, **NON LANCIABILE** |
| 1 | **`ABTG_InvEsaurimento` E3 a tick su D30EUR/U30USD M30-H1** | 12-16 | **ZERO**: l'EA esiste, e' prop-hardened (stop vero, rischio %, flat di seduta), ha 3 file prova gia' scritti | 🟡 **medio**: e' la **stessa tesi** misurata con un detector nostro, mai girato ne' sul DAX/Dow, ne' a tick, ne' su M30/H1. ⚠️ Ma la previsione dichiarata dal suo stesso referto e' **rosso nel toro** | 🟡 **in coda, e con la previsione scritta prima** |
| 2 | **Riprendere i 5 sorgenti TradingView scaricati e NON letti l'08/09** (`H-L Range Strategy`, `Breakout Scalper Session`, `cATRpillar`, `Linear Regression Reverse`, `Moving Regression Band`) | 0 | ~20 minuti di lettura | 🟢 **alto per unita' di costo**: sono in `open_no_auth`, e il dossier dell'08/09 li dichiara **non valutati per budget** | 🟢 **da fare, e non l'ho fatto io per non sforare il perimetro di questa caccia** |
| 3 | **Chiedere a Claudio i due paper SSRN** (689282, 5039009) | 0 | 2 minuti **suoi** | 🟢 la tesi accademica dell'inversione intraday su **futures di indice** e' l'unica cosa che potrebbe riaprire la famiglia con una variabile nuova | 🙋 **richiesta a Claudio** |

> 🎯 **E la conclusione che vale per la bussola del 1° ottobre**: questa caccia
> **non consegna una sedia**, e dirlo e' il suo contributo. Il tempo macchina
> risparmiato (14 passate che avrebbero dato un rosso prevedibile) vale piu' di un
> candidato mediocre messo in coda per non tornare a mani vuote.

---

## 8. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

Se e quando questa famiglia si riapre, la domanda **non** e' *"la sequenza funziona?"*.
E':

> ### **"Esiste UNA variabile, misurabile su barre chiuse, che dica IN TEMPO REALE se siamo nel regime in cui l'inversione da esaurimento paga — senza guardare il futuro e senza essere un filtro appiccicato dopo?"**

Perche' i numeri dicono che la risposta al *se funziona* e' **"dipende dall'anno"**, in
tre misure indipendenti (E3 di casa, la sequenza di oggi, il paper MNQ). E in casa il
filtro aggiunto dopo a un motore tarato e' **0 successi su 5**, mentre il filtro che
**E'** il motore ha dato il miglior risultato del progetto (`ABTG_EMA200` Dow, **30
celle su 30 PASS**). Quindi la variabile di regime dovrebbe nascere **dentro** il
motore, o non nascere.

---

## 9. 🧾 RIEPILOGO NUMERICO DELLA BATTUTA

| | |
|---|---:|
| fonti col controllo positivo **passato** | **5** (Code Base elenco/scheda/sorgente · TradingView elenco/pine-facade · arXiv pagina · dati esterni · + collaudo orologio) |
| fonti **NULLE oggi** (dichiarate) | **5** (SSRN 403 · Quantpedia 308 · GitHub 403 · Forex Factory 403 · arXiv API timeout) |
| titoli di strategia **visti** | **~126** (80 Code Base + 46 TradingView) |
| sorgenti **scaricati** | **5** (4 Pine + 1 `.mq5`) |
| sorgenti **letti riga per riga** | **5** |
| candidati **portati alla misura** | **1** |
| barre M1 di dati indice **misurate** | **1.942.126** (GRXEUR + SPXUSD, 2015-2018) |
| celle di sonda calcolate | **~200** (2 simboli × 2 TF × 4 N × 2 lati × 3 RR + 96 celle per anno) |
| **promossi** | **0** |
| EA / preset / parametri di forward toccati | **0** |
| passate di tester spese | **0** |

**Attribuzione, come da regola di casa:** `Momentum Sequence Strategy [Herman]` e' di
**helmans13** (TradingView, **MPL 2.0**); `The Bar Counter Trend Reversal Strategy` di
**tradedots**; `Sniper V4 / AxMan Exhaustion` di **Axj_Stev**; `Bearish Wick Reversal`
di **Botnet101**; `EA KCI Embeded Sniper` di **Syamsurizal Dimjati (RitzFalih)**,
MQL5 Code Base 74582. I dati M1 vengono da **FutureSharks/financial-data**
(**GPL-3.0**). Nessuna riga di codice di nessuno di loro e' stata copiata nel repo:
le due sonde sono scritte da zero e implementano **la geometria descritta**, con la
mappatura riga-per-riga dichiarata nella loro intestazione.
