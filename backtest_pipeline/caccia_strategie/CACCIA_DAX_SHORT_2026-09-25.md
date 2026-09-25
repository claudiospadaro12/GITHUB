# 🐻 CACCIA DAX SHORT — seconda caccia dopo R251 (25/09/2026)

**Mandato:** regola della seconda caccia (19/08). R251 ha BOCCIATO PER RISCHIO lo short retest d'apertura DAX (`report/REFERTO_R251_2026-09-25.md`). Claudio: _"TROVIAMO LA VERSIONE SHORT DEL DAX! ADESSO!"_. Qui si cercano **meccanismi alternativi** per uno short intraday su D30EUR, **non** parametri diversi del motore morto.
**Perimetro rispettato:** zero preset, zero EA, zero sedie, zero forward toccati. Niente a Claudio, niente al VPS. Nessuna riga di lancio.
Etichette: **[VERIFICATO]** letto sulla pagina o nel sorgente · **[MISURATO]** contato dalla sonda di questo dossier · **[DERIVATO]** aritmetica su numeri misurati · **[INFERITO]** dal codice (riga citata) · **[INCERTO]** non lo so.

---

## 0. 🎯 La riga che conta

> **Ho guardato 120 titoli del Code Base, 194 script TradingView (29 strategie) e ~15 paper o pagine, più la prima pagina di QuantConnect Research: 6 fonti vive e 6 murate. Poi ho misurato io 10 meccanismi con una sonda su 8 anni di DAX esterno. 1 solo arriva al sorgente e passa i cancelli della sonda: la CONTINUAZIONE DEL GAP-DOWN all'apertura Xetra (`ABTG_GapContinuation`, già in casa, zero codice).** La proverei **come prova di catena, costo e sovrapposizione, non come candidato sedia**. È l'unica delle 10 celle che passa G1-G4. Dei contro-esempi il più importante: nei giorni senza gap la stessa meccanica perde, quindi il motore è il gap. Il lato lungo speculare sul DAX non ha la stessa informazione, quindi è un motore corto per costruzione.
> **Onestà sui numeri (corretta dopo l'audit controllo-caccia del 25/09):** è un **indizio debole, non una scoperta**. Passa 1 cella su 10, con t +2,12. Nel **90%** delle operazioni lo stop è il pavimento di 68 punti, non la struttura. **Con la geometria dell'EA scende a t 1,83, sotto G1.** In scala invariante **nessuna soglia passa G1 e G3 insieme**. Senza le 5 operazioni migliori ha t 1,53. Il gemello EuroStoxx concorda (t 1,51), il gemello S&P no (t 0,49). Un precedente di casa (A69 GapCash Nasdaq) ha già **ribaltato il segno** passando dai dati esterni ai tick BCM. Sul feed BCM fa **~0,075 posizioni per seduta, ~34-35 in fase (tetto)**, quindi il merito resta sospeso. Il primo round giudica catena, costo, rischio e sovrapposizione con 770411/770105.

---

## 1. 📕 Cosa ho letto in casa prima di uscire (il bersaglio)

`CLAUDE.md` · `report/LATO_SHORT_DAX_APERTURA_2026-09-25.md` · `report/REFERTO_R251_2026-09-25.md` · `report/ORA_10ET_SULLA_770101_2026-09-25.md` · `report/IL_CORTO_DI_DAX_E_NASDAQ_2026-09-23.md` (R233, censimento dei corti per colonne) · `report/CENSIMENTO_LATO_SHORT_2026-09-09.md` · `report/CACCIA_TF_BASSO_2026-09-12.md` (cono di rumore) · `report/CACCIA_M30_INDICI_2026-09-08.md` e `report/CACCIA_SUPREV_ALTERNATIVE_2026-09-12.md` (il cimitero per meccanismo) · `backtest_pipeline/REGISTRO_TEST.md` (r.840-972, 1195-1262, 1901-2012, 2250-2300, 4025-4060) · `caccia_strategie/ANALISI_TRASCRIZIONI_2026-09-25.md` (S1) · le cacce short precedenti (`CACCIA_2026-08-16_F_SHORT`, `_H_SHORT_APERTURE`, `CACCIA_SHORT_INDICI_2026-08-29`, `CACCIA_SHORT_FREQUENZA_2026-09-06`) · `PROMEMORIA_SBLOCCO_FONTI.md` · prove `R249*`, `R251*`, `R252*` · preset FTMO `770411` · sorgenti `ABTG_GapContinuation.mq5`, `ABTG_DAX_Apertura_EU.mq5` (modi d'ingresso), `ABTG_IntradayMomentum.mq5`, `ABTG_OutOfNoise.mq5`, `ABTG_GapFill.mq5`, `ABTG_LiquiditySweep.mq5`, `ABTG_TurnaroundTuesday.mq5`, `ABTG_SupRev_DAX_H1_Ottimizzato.mq5`.

**Il buco, con i numeri:** il corto DAX in campo è uno solo, `770411` (rottura del box notturno, apertura). Il 25/09 Claudio ha firmato `770105` (gemella short della 770101 su FTMO). Tutte e due **lavorano nella prima mezz'ora sullo stesso lato**. Il buco vero è quindi un corto che **guadagni nelle discese** ("lavora nel crollo", ROBUSTEZZA) **senza essere lo stesso segnale** delle due corte del mattino.

**Archivio che NON avevo incrociato alla prima stesura (aggiunto dopo l'audit):**
- `report/SWEEP_MECCANISMI_2026-08-23.md` §4 **D1**: **stesso candidato, stesso EA, stesso paper**. Proposto il 23/08 dietro un **PASSO 0** (contare i gap veri su D30EUR/U30USD, "se <150: chiuso"), **mai girato**.
- **A69 GapCash Nasdaq** (07/09, `risultati_archivio/REFERTO_GAPCASH_PASSO0_2026-09-07.md`): positivo sui dati esterni (**+0,0988%**), **segno ROVESCIATO sui tick BCM (−0,0487%)**. È il precedente diretto di uno screening esterno sul gap che non ha retto su BCM.
- `prove/GAPCASH_RICONQUISTA_PASSO0.txt` (08/09): stessa famiglia, in coda, **mai girato**.
- Sul **225JPY** il lato short dello **stesso EA** ha P/L OOS **−2.182** (`report/CENSIMENTO_LATO_SHORT_2026-09-09.md` r.419; R65/R66).

**Già in corsa o pronto, e non lo duplico:** R252 (short retest d'apertura con l'orologio in fase, in corso) · R249a-h (Unger A: STOP contro LIMIT sul massimo/minimo di ieri, riga pronta) · R233 punto 3 (corona SupRev corto D30EUR H1).

---

## 2. 📡 Controllo positivo, fonte per fonte (misurato oggi)

| fonte | bersaglio noto | esito | verdetto |
|---|---|---|---|
| **MQL5 Code Base** elenco `/en/code/mt5/experts` (+page2, page3) | titoli veri | **200**, 120 titoli con id. Fra questi `75301 Nikkei 225 Gap Continuation EA`, `73674 001 - Turnaround Tuesday`, `68951 Liquidity Sweep H4 - M15`, tutti già in casa | 🟢 PASSA |
| **MQL5** scheda `/en/code/75301` | autore + data | **200**: _"by 'MauriyKiku' … 2026.07.24"_, `datePublished 2026-07-24T10:56:57`, **`dateModified 2026-09-15T12:58:37`**, `UserDownloads:771` | 🟢 PASSA |
| **TradingView** `pubscripts-suggest-json` | risultati per tag | **200** su 8 query (`dax`, `gap fill`, `gap fade`, `previous day high`, `failed breakout`, `intraday momentum`, `us open`, `overnight gap`): 194 script, **29 strategie** (`type 2`: 12 `access 1` aperte, 12 `access 2`, 5 `access 3`) | 🟢 PASSA |
| **arXiv** pagina `abs/2010.01727` | titolo noto | **200**, _"Strikingly Suspicious Overnight and Intraday Returns"_ | 🟢 PASSA |
| **arXiv** PDF `pdf/2605.04004` | PDF vero | **200, 834.734 byte**, letto (sez. 4.4, tab. 6 e 13) | 🟢 PASSA |
| `export.arxiv.org` API | 4 voci | 🔴 **HTTP 406** (anche con `Accept: application/atom+xml`): oggi l'API è muta | 🔴 NULLA oggi, sostituita da `abs`/`pdf` |
| `raw.githubusercontent.com` (FutureSharks, GPL-3.0) | file histdata | **200**, 8 file `ETXEUR` 2011-2018 scaricati (8-12 MB l'uno) | 🟢 PASSA |
| **WebSearch** | indice | URL veri (usata **solo come indice**) | 🟢 PASSA |
| 🔴 `papers.ssrn.com` | abstract 4729284 | **403** | 🔴 NULLA |
| 🔴 `github.com/search` e `api.github.com` | ricerca repo | **403** tutti e due | 🔴 NULLA (quarta caccia di fila) |
| 🔴 `forexfactory.com` | home | **403** | 🔴 NULLA |
| 🔴 `quantpedia.com/strategies/` | slug | **308, redirect a `/screener`** (pagina Next.js senza contenuto leggibile: 0 slug) | 🔴 NULLA di fatto |
| **QuantConnect** `quantconnect.com/research/` (mandato §3.F) | pagina vera | **200, 272.356 byte**, 20 discussioni in prima pagina (bug report, broker, un _"Intraday Trading Strategy for Futures Contract NQ"_ a indicatori). **Nessuna** su DAX, gap o short intraday. La ricerca è in JS, quindi **non** l'ho battuta per tema | 🟡 VISITATA, resa zero, dichiarata |
| 🔴 `centaur.reading.ac.uk`, `nottingham-repository`, `sciencedirect.com`, `researchgate.net`, `mdpi.com` | PDF dei paper | **EGRESS_BLOCKED / connect_rejected** | 🔴 NULLA |

---

## 3. 🔬 La misura che ho fatto io: 10 meccanismi, un solo banco

**Perché:** la letteratura sul DAX intraday non si raggiunge (vedi §2), e il cimitero di casa è pieno. Invece di portare titoli, ho misurato **tutti i meccanismi del mandato sullo stesso banco**, con i **criteri congelati e pushati prima di girare** (commit `473c57f6`).
**Banco:** `GRXEUR` histdata M1 **2011-2018** (8 anni: crollo 2011, crollo 2015, laterale 2016, orso 2018), **2.017 sedute cash**. Orologio `file+5 = server`, collaudato tre volte in casa. Costo 1,70 punti per operazione. Ambiguità intrabarra sempre a sfavore. Il controllo **appaiato** è stessa barra, stessa distanza, lato opposto. **Non è BCM e non sono tick: è screening.**
**Cancelli:** G1 E netta > 0 con t ≥ 2,0 · G2 informazione direzionale ≥ +0,05 R · G3 ≥ 6 anni su 8 positivi · G4 stop mediano ≥ 68 punti (40×). Attrezzo: `biblioteca/sonde_esterne/sonda_dax_short_meccanismi.py`. Uscite: `…/uscite_dax_short_2026-09-25/`.

| cella (meccanismo del mandato) | n | op/seduta | E netta | t | info dir. | stop med | anni + | esito |
|---|---:|---:|---:|---:|---:|---:|---:|---|
| P1a ITSM Gao/LSU: 1ª mezz'ora (con notte) → ultima mezz'ora, corto | 921 | 0,457 | −0,046 R | −3,26 | −0,014 | 51,6 (30x) | 2/8 | 🔴 no, anche per COSTO |
| P1b ITSM, 1ª mezz'ora solo seduta | 1.037 | 0,514 | −0,057 R | −4,51 | −0,024 | 52,3 (31x) | 1/8 | 🔴 no, anche per COSTO |
| P2a **gap-up FADE** ≥0,25% verso la chiusura | 663 | 0,329 | −0,018 R | −0,62 | +0,003 | 68 | 3/8 | 🔴 no |
| P2b gap-up FADE ≥0,50% | 380 | 0,188 | −0,030 R | −0,74 | −0,017 | 70,5 | 3/8 | 🔴 no |
| P2c **gap-down CONTINUAZIONE** ≥0,25% | 313 | 0,155 | +0,110 R | +1,80 | +0,116 | 68 | 5/8 | 🟠 manca G1 (t) e G3 |
| **P2d gap-down CONTINUAZIONE ≥0,50%** | **175** | **0,087** | **+0,185 R** | **+2,12** | **+0,160** | **68** | **6/8** | 🟢 **PASSA-SONDA** |
| P3a apertura USA, INVERSIONE dopo mattina ≥ +0,5 ATR | 322 | 0,160 | −0,022 R | −0,57 | +0,005 | 68 | 5/8 | 🔴 no |
| P3b apertura USA, CONTINUAZIONE dopo mattina ≤ −0,5 ATR | 319 | 0,158 | +0,007 R | +0,15 | +0,019 | 68 | 3/8 | 🔴 no |
| P4 **10:00 New York** (15:00 server), corto incondizionato | 1.994 | 0,989 | −0,010 R | −1,26 | +0,015 | 68 | 2/8 | 🔴 no: volatilità, non direzione |
| P5 **cono di rumore SOLO CORTO** (formula OutOfNoise r.697-700) | 731 | 0,362 | −0,028 R | −0,80 | −0,012 | 94 (55x) | 3/8 | 🔴 no (conferma lo zero del 12/09) |

P2d per anno **[MISURATO]**: 2011 +0,17 · 2012 −0,01 · 2013 +0,02 · 2014 +0,14 · **2015 +0,50** · 2016 +0,29 · 2017 −0,20 (n 8) · **2018 +0,30**. Somma +32,4 R, **DD massimo 6,5 R**, serie perdente più lunga 5.
⚠️ **Tre fragilità di P2d, misurate dall'audit e riprodotte da me alla cifra** (`sonde_esterne/sonda_dax_short_verifica_audit.py`):
- **La sonda non è l'EA.** Nel **90%** delle 175 operazioni lo stop è il **pavimento di 68 punti**; lo stop naturale ha mediana **37,5**. Con la geometria dell'EA approssimata (massimo del range + 15, nessun pavimento, cancellazione a metà gap, TWAP al posto della VWAP) fa **n 152, +0,196 R, t 1,83: SOTTO G1**.
- **Coda:** senza le 3 operazioni migliori ha t **1,77**; senza le 5 migliori **1,53**.
- **Orologio di histdata:** il file è in ora di New York con l'ora legale USA. Nelle settimane in cui USA e UE cambiano ora in date diverse, le 08:00 della sonda cadono **un'ora prima della cash**. **9 operazioni su 175** cadono lì; senza di loro: n 166, +0,190 R, t 2,10. Il "collaudato tre volte" **non copre** quelle settimane.

⚠️ **Molteplicità dichiarata:** su 10 celle, una che passa per caso ha una probabilità non trascurabile. Per questo la cella viene portata al tester, e ha senso solo coi contro-esempi del §3.1.

### 3.1 🧪 I contro-esempi: ho provato a rompere P2d (post-hoc e dichiarati; `sonda_dax_short_controesempi.py`)

| contro-esempio | cosa direbbe "P2d è un artefatto" | numero | esito |
|---|---|---|---|
| CE1 **scala**: 68 punti su un DAX a 7.000 sono uno stop più largo che a 24.000 | l'edge sparisce con lo stop in unità di volatilità | pavimento 0,27×ATR20 e costo scalato: **+0,243 R, t 2,30, ma solo 5/8 anni** · CE1b 0,25%: t 1,42 · CE6c 0,35%: +0,149 R, t 1,67 | 🔴 **FALLISCE G3.** Nella scala che somiglia a BCM **nessuna soglia passa G1 e G3 insieme**: l'altopiano esiste **solo col pavimento di 68 punti** (corretto dopo l'audit; la prima stesura diceva "regge") |
| CE2 **il gap è il motore?** | la stessa rottura del minimo fa uguale ogni giorno | tutte le sedute **+0,035 R** (t 1,27); **senza gap −0,038 R** | ✅ il motore è il gap |
| CE3 **verso** | basta un gap qualsiasi | corto dopo un gap-**UP** ≥0,50%: +0,054 R, t 0,77 | ✅ conta il verso |
| CE4 **uscita** | è il bersaglio 2R | senza bersaglio (stop o tempo): **+0,131 R**, 6/8 anni | ✅ non è il 2R |
| CE5 **specchio** | è "continuazione del gap" simmetrica | **LUNGO** dopo un gap-up ≥0,50%: +0,043 R, t 0,65, 4/8 anni | ✅ sul DAX è **asimmetrico: motore corto** |
| CE6 **soglia** | la cella 0,50 è un picco | 0,35% **+0,146 (t 2,03)** · 0,50% +0,185 · 0,75% +0,170 (t 1,47) | ✅ altopiano, centro 0,50 |
| CE8 gemello **EuroStoxx** (ETXEUR, stessa seduta) | sul gemello non c'è | ≥0,50% **+0,151 R, t 1,51**; ≥0,75% **+0,262, t 1,87**; senza gap −0,043 | 🟡 concorde, ma lì vive anche il lungo (+0,106, t 1,26), e non è indipendente dal DAX |
| CE7 gemello **S&P 500** (SPXUSD 2013-2018) | è universale | ≥0,50% **+0,074 R, t 0,49**; ≥0,35% −0,036 | 🔴 **non conferma** |
| CE9 **cancellazione a metà gap** come l'EA (r.815, lato SELL), aggiunta dopo il cancello del 25/09 | la sonda senza cancellazione gonfia il segno | n **152**, **+0,230 R, t 2,47**, 7/8 anni, DD 4,8 R | ✅ regge col pavimento di 68; il **filtro VWAP** dell'EA (r.1104) non si calcola (histdata senza volumi). L'audit l'ha approssimato con la TWAP e **senza pavimento**: t 1,83 (§3) |

📄 **Fonte esterna, letta sul PDF [VERIFICATO]:** Mesfin, _"Structural Limits of OHLCV-Based Intraday Momentum Signals in MNQ Futures"_, **arXiv 2605.04004** (05/05/2026), sez. 4.4, tab. 6 e 13. Il **gap continuation short** su MNQ 2021-2025 fa **lordo +16,53 · netto +14,52 punti, T 1,46, 35 operazioni OOS**, con il **2024 a −11,87**. L'autore lo chiama _"the most credible near-miss in the study"_ e lo tiene _"as a candidate for future investigation"_. Il meccanismo è lo stesso, la geometria no (lì velocità Kalman, qui rottura del range). Tabella 6: **2023 (toro) +14,53**, 2024 −11,87, 2025 parziale +10,27, 2022 escluso. "Vive nelle discese e cede nel toro" **non è nel paper** [INFERITO, non dal paper].
🔴 **Versioni:** io ho letto la **v3** (online 15/09/2026). La casa aveva letto la **v2** il 23/08 (`report/SWEEP_MECCANISMI_2026-08-23.md` r.285-313): **T 3,23, n 22, win 68%**, _"Statistically, it looks real"_. **Fra le due versioni l'autore ha RIDOTTO il suo stesso segnale (T 3,23 → 1,46).** Numeri **dell'autore, NON verificati da noi**: non pesano sul punteggio.

---

## 4. 🏆 La shortlist (ordinata)

### 🥇 1. Continuazione del gap-down all'apertura Xetra: **PROVA SUBITO come prova di catena, costo e sovrapposizione, non come candidato sedia**

```
NOME            Nikkei 225 Gap Continuation EA  -> in casa: ABTG_GapContinuation.mq5 (adozione minima 16/08)
FONTE / URL     https://www.mql5.com/en/code/75301  [VERIFICATO 25/09, HTTP 200]
AUTORE / DATA   pagina: 'MauriyKiku', 2026.07.24 (modificato 2026-09-15); #property copyright del
                sorgente: Francesc Jordi Mallol Nolden  POPOLARITA' 771 download
                [INCERTO] se l'aggiornamento del 15/09 cambi la logica: la nostra copia e' la v1.50 del 16/08
LICENZA         NON dichiarata (header EA r.20-26): uso INTERNO di ricerca
RIGHE / INPUT   1.654 righe, 34 input (sopra il tetto ~15: un punto in meno, SCRITTO)
TESI            "guadagna perche' il gap-down del DAX e' prezzo gia' scoperto fuori dalla cash (USA dopo
                 le 17:30, Asia, pre-mercato): se il primo quarto d'ora non lo richiude e rompe il minimo,
                 il flusso della cash europea arriva DOPO e spinge nello stesso verso"
MECCANICA       ingresso: gap <= -0,50% dalla chiusura cash di ieri, ask < minimo del range 15' E < VWAP,
                entro 90'; uscita: parziale 40% a 1R + pari, finale 2R, flat 5' prima della chiusura;
                stop: massimo del range + buffer. Cancellata se richiude meta' del gap (r.815; r.804 e' il ramo gap-up).
GESTIONE RISCHIO % dell'equity (CalculateEntryVolume r.866, OrderCalcProfit), SL vero al broker,
                1 posizione al giorno
BANDIERE ROSSE  nessuna (niente martingala, griglia, recovery, DLL, WebRequest; stop vero r.1110)
COSTO PORTING   0 ore (zero codice: InpSessionTimeMode=1 manuale in ora server, InpEnableBuyGaps=false)
PUNTEGGIO       semplicita' 1 (34 input) · il filtro E' il motore 2 (CE2: senza gap perde) · tesi 2 ·
                buco 1 (lavora nel crollo, ma sovrapposizione probabile con 770411/770105:
                O2 stimato sulla sonda 69%) · testabile senza riscritture 2   -> 8
VERDETTO        PROVA SUBITO come prova di catena, costo e sovrapposizione, NON come candidato sedia
PERCHE'         unica cella su 10 che passa la sonda, zero codice; ma con la geometria dell'EA
                t 1,83 (sotto G1), in scala invariante manca G3, n basso: e' un indizio debole.
```
- **Cosa terrei:** il motore (gap + rottura del range + VWAP + annullamento a meta' gap).
- **Cosa rifarei, dopo:** la gestione dell'uscita, a turno (certificato p.3). Poi il buffer dello stop in funzione dello spread (R55).
- **Frontiera del costo [DERIVATO]:** stop ≥ range 15' + 15 punti. Il range 15' D30EUR BCM ha **mediana 54,65 e P10 23,89 (n 440, MISURATO)**, quindi stop mediano ≥ ~69,7 punti = **~41x** lo spread di 1,70. Al P10 fa ~22,9x. Il numero vero lo dà il per-trade (cancello K1).
- **Frequenza [DERIVATO dalla sonda]:** gap-down ≥0,50% nel **14,0%** delle sedute. Con la cancellazione a metà gap (CE9) l'ingresso scende al **54%** → **~0,075 posizioni per seduta, ~35 posizioni** sulle ~458 sedute in fase del feed BCM (P2d senza cancellazione: 62%, ~40). È un **TETTO** (classe 777): il VWAP e il toro ne tolgono altre. Banda attesa 10-45. **Merito sospeso per aritmetica, qualunque cosa esca.**
- ⚠️ **Zero codice, ma non con l'EA della sedia.** `ABTG_DAX_Apertura_EU` ha un modo `GAPFILL` (`InpEntryMode=1`), ma **misura il gap sulle barre D1 del CFD** (`iClose(D1,1)` e `iOpen(D1,0)`, r.2013-2014), cioè il gap di mezzanotte, **non quello della cash** [INFERITO dal codice]. Coerente: nella FASE B ha fatto **7 e 9 operazioni** (`DAX_B_motore_IS/OOS.csv`). Il veicolo giusto è `ABTG_GapContinuation`, che trova la chiusura della seduta precedente sulle M1 (r.637-655).

🏛️ **Riga prop.** In ottica prop questo motore fa **al massimo 1 posizione al giorno**, quindi la peggior giornata è ~−1 R (−0,65% al rischio di casa). I guadagni si concentrano negli **episodi di discesa**, dove la flotta long perde: è l'unico candidato di oggi che **copre il crollo**. Nel toro la sonda dice ~0 per posizione e poche posizioni, quindi una curva **piatta, non discendente**. Il DD trailing la punisce poco [INFERITO dalla sonda, non misurato]. 🔴 **Rischio di sovrapposizione vero:** nei giorni di gap-down anche `770411` (rottura del box notturno, ordine alle 07:59 server) e `770105` (retest short) sono probabilmente corte **la stessa mattina**. **O2 stimato sulla sonda** (tutto dentro la cash, geometria della 770105 approssimata sulle M1: range 35', rottura sotto il minimo − 5, limit a minimo + 2, scadenza 120'): **121 giornate su 175 = 69%** con un corto 770105 lo stesso giorno. È un indizio di **NON ADDITIVO A RISCHIO PIENO**. Per 770411 serve la notte, che nei dati esterni non c'è: **[NON MISURATO]**. Decidono i cancelli O1/O2 del file prova sul per-trade BCM: sopra il 50% di giornate in comune, **non è additivo a rischio pieno**. Estendere la famiglia a E50EUR non aggiunge giornate indipendenti, perché i gap-down arrivano gli stessi giorni.

### 🥈 2. Falsa rottura del massimo di ieri → corto (sell limit sul PDH): **GIÀ PRONTO, non lo duplico → IN CODA (lanciare R249)**
- **Meccanismo:** stop-run sopra il massimo di ieri e rientro. È il "liquidity sweep" del mandato, portato sul livello più ovvio.
- **Dove sta:** `prove/R249b` (blocco ATR, strumento di misura, ~14x) e `R249f` (pavimento 68, **ammissibile per costo**), riga `righe/RIGA_R249_UNGER_A.txt` già al PASS, ~7 minuti per tutto R249 (`report/NOTTE_2026-09-25.md`).
- **Prior debole, scritto:** la famiglia "falsa rottura di livello" ha tre lapidi a tick sul DAX (CRT 0/30, BreakinBox, micro-pivot L2). La sonda di R249a sulla colonna ATR dà PF 0,757 **non leggibile** (83 barre ambigue su 463).
- **Riga prop:** stessa mattina e stesso lato di 770105/770411, quindi sovrapposizione probabile.

### 🥉 3. Retest del minimo di ieri dal basso (S1 di Emiliano, lato corto): **IN CODA**
- **Meccanismo:** rottura del PDL, ritorno sul livello, sell limit (`ABTG_DAX_Apertura_EU`, `InpEntryMode=2`, `InpRangeMode=2`, `InpLevelTF=D1`). Zero codice.
- **Perché terzo:** è il terzo braccio di R249 (STOP / LIMIT / RETEST sugli stessi livelli). Va scritto **dal proprietario di R249**, con gli stessi blocchi di costo, non in parallelo da me.
- ⚠️ **Trappola [INFERITO dal codice r.1116-1117]:** il "D1 di ieri" è la candela del **CFD** (00:00-22:00 server), non la giornata cash.
- La casa ha già detto _"cambiare il livello non cambia la geometria"_ (03/09), e il retest short d'apertura è appena stato bocciato per rischio. Punteggio 7.

**Nessun quarto o quinto:** gli altri meccanismi del mandato hanno un numero contro (§5). Riempire la lista per non tornare a mani più vuote sarebbe il difetto che il §8 del ruolo vieta.

---

## 5. ❌ Scartati: una riga di motivo a testa

| candidato / meccanismo | fonte | motivo (col numero) |
|---|---|---|
| ITSM "1ª mezz'ora → ultima" sul DAX (Gao 2018; Li-Sakkas-Urquhart, internazionale) | WebSearch (snippet: _"12 su 16 mercati"_), PDF **murati** | sonda P1a/P1b: **−0,046/−0,057 R, t −3,3/−4,5**, e stop 30x **sotto la frontiera**. `ABTG_IntradayMomentum` su D30EUR **non proposto** (sul Nasdaq resta R233 n.1, qui non c'entra) |
| Corto alle 10:00 di New York | `report/ORA_10ET_…` + sonda P4 | **−0,010 R, 2/8 anni**, informazione +0,015: le 10 ET sono **volatilità, non direzione**. Il grappolo di stop long del 25/09 non è un edge corto |
| Fade del gap-up verso la chiusura | sonda P2a/P2b; `CACCIA_TF_M30` (onid 4/4 cancelli falliti, 05/09) | **−0,018/−0,030 R**, 3/8 anni. Il riempimento non paga, sul DAX il gap continua |
| Reazione all'apertura USA (inversione / continuazione) | sonda P3a/P3b | **−0,022 / +0,007 R**: piatto in tutti e due i versi |
| Cono di rumore (Zarattini-Aziz-Barbon), solo corto | sonda P5; `CACCIA_TF_BASSO_2026-09-12` §2.3 | **−0,028 R**, informazione −0,012: conferma lo zero del 12/09. **NON morto**: il trailing VWAP della fonte non si misura senza volume |
| Esaurimento/ATR del pomeriggio → corto | cimitero di casa | R109 DD 44-68%, R108/R111 6/6 rosse, `InvEsaurimento` baseline PF 1,00, `AtrExhaustVol` caduto. Non riproposto |
| Debolezza di fine giornata / stagionalità (giorno della settimana, fine mese) | M27 (05/09), R63 | mezz'ora migliore **0,33x** il cancello; calendario **0/24 OOS** su 11.928 operazioni. Non riproposto |
| Corto quando la notte è ribassista | onid (05/09) + `770411` | reversione notte → giorno piatta (K1-K4 falliti); la rottura del box notturno **è già in campo** (770411) |
| Sweep/falsa rottura generici (CRT, Turtle Soup, micro-pivot, BreakinBox) | REGISTRO r.840, r.958, L2 | 0/30 a tick, PF 1,007 DD 24%, TP-prima-di-SL sotto il caso. Resta **solo** il PDH di R249 (§4.2) |
| Sequenza H1 N=3 corta (sonda 12/09) | REGISTRO r.2250 | il cancello congelato era 3 anni su 4, il risultato è **2 su 4**: il segno lo decide l'anno. Non riproposta |
| `ABTG_DAX_Apertura_EU` modo `GAPFILL` su D30EUR | sorgente r.2011-2075 | **non fedele**: gap sulle D1 del CFD, non sulla cash (7/9 operazioni in FASE B). Difetto di strumento, non un verdetto sul meccanismo |
| `SupRev` corto D30EUR H1 | R233 §5.3 | **fuori dal perimetro intraday** [INFERITO dagli input di `ABTG_SupRev_DAX_H1_Ottimizzato.mq5` r.51-108: nessuna chiusura di sessione, solo `InpExitOnFlip`/trailing]. Resta la proposta di R233, non la duplico |
| Code Base, arrivi dal 13/09: 77595 PSAR, 77535 RegimeRouter, 77167/77220 scalper "burst", 77470 EMA cross, 77639/77691/77206 oro, più attrezzi (pannelli, guardiani prop, logger) e demo Renko | MQL5 (titoli; descrizioni lette per 77595, 77535, 77167, 77220, 77470) | nessun motore DAX o corto. Famiglie morte (incroci, breakout/MR generici), scalper a tick sotto la frontiera del costo, oro fuori bersaglio. **Quinta conferma: il Code Base produce attrezzi, non motori** |
| TradingView, 29 strategie su 8 tag (12 aperte) | suggest-json | quelle pertinenti sono **già in biblioteca**: `DAX Shooter 5M` (th3web), `SP500 Session Gap Fade` (exlux), `Gap Filling Strategy` (alexgrover: **nessuno stop**), `IU Gap Fill`, `Previous Day High and Low Breakout` (ceyhun). Le altre sono scalper DAX a TP fisso da 7-20 punti (peba1967: sotto la frontiera per costruzione, e sorgente non aperto, `access 2`) o multi-asset generiche. `Overnight Gap Analysis` (TradeAutomation) **non letto**, dichiarato |

---

## 6. 🕳️ Cosa NON ho potuto vedere

1. **SSRN, GitHub (UI e API), Forex Factory: 403.** Quantpedia: **redirect 308** a `/screener`, senza contenuto. QuantConnect: prima pagina vista, ricerca per tema non battuta (JS). **Tutti i PDF accademici** (Reading, Nottingham, ScienceDirect, ResearchGate, MDPI): EGRESS_BLOCKED. Per questo Li-Sakkas-Urquhart (ITSM internazionale) e _"When overnight is not simultaneous…"_ (ScienceDirect) sono **solo titoli**: non so se il DAX sia fra i 12 mercati su 16 **[INCERTO]**. Ho sostituito la lettura con la misura (§3).
2. **API arXiv: HTTP 406** oggi. Ho usato `abs` e `pdf`.
3. **La notte del DAX non c'è** nei dati esterni (histdata copre 07:00-21:00 server): **la sovrapposizione con 770411 non si stima fuori**. Si misura solo sul per-trade BCM (cancello O1).
4. **Nessuna barra D30EUR BCM in repo**: quante giornate di gap-down ≥0,50% ci siano sul feed BCM è **[NON MISURATO]**. Il numero di §4.1 è derivato dal 2011-2018.
5. **L'orologio della sonda nelle settimane di disallineamento USA/UE** (9 operazioni su 175): i numeri senza di loro sono al §3.
6. **Il sorgente 75301 è stato modificato il 15/09** (dopo la nostra adozione del 16/08, v1.50): cosa sia cambiato è **[INCERTO]**. Non l'ho riscaricato: la nostra copia è quella del file prova.

---

## 7. 📦 Consegnato

- `backtest_pipeline/prove/R253a_gapcont_DAX_short_ora8.txt` (file di testa: estate, 08:00-16:30 BCM) e `R253b_gapcont_DAX_short_ora9.txt` (inverno, 09:00-17:30). Criteri congelati **prima** dei numeri; asse = magic gemello (G1); 2 file × 2 celle = **8 passate, 4 lunghe**, stima 5-12 minuti **[STIMA]**. `controlla_prova.py`: **OK, 0 problemi**. Sigla **R253** (assegnata dal coordinatore). Prima stesura FAIL allo strato 2 del cancello; corretta con i cancelli P0 (classe 780), S2 riscritto, le sedute di confine (805), il verdetto asimmetrico di R1 (804), la frequenza come TETTO (777), il moncone (766) e O1/O2 (781).
- Attrezzi: `biblioteca/sonde_esterne/sonda_dax_short_meccanismi.py` (criteri pushati prima, `473c57f6`), `sonda_dax_short_controesempi.py` e `sonda_dax_short_verifica_audit.py` (riproduce le cifre dell'audit controllo-caccia). Uscite in `biblioteca/sonde_esterne/uscite_dax_short_2026-09-25/`.
- 🔴 **Nessuna riga di lancio.** Prima di scriverla va passata da `CHECKLIST_RIGA_DI_LANCIO.md` e dai due strati del cancello. Gira **solo sul PC di backtest**.

## 8. ❓ La domanda a cui il primo test deve rispondere

> **Sul feed BCM 2024-2026, con l'orologio in fase con la cash, il corto di continuazione del gap-down su D30EUR: (1) gira sul gap VERO della cash (catena)? (2) Ha uno stop mediano ≥ 68 punti? (3) Resta dentro i 6,5 R di DD, cioè il peggio di otto anni esterni? (4) Quante delle sue giornate sono le stesse di 770411 e 770105?** Il merito resta sospeso qualunque cosa esca. Se passa (1)-(3), il passo dopo è la gestione dell'uscita ad asse. Se (4) supera il 50%, **non va acceso accanto alle altre due corte a rischio pieno**.
