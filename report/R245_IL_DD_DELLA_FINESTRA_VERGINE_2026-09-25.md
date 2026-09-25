# 🔬 R245: da dove viene il DD dell'8,38% nella finestra vergine

**25/09/2026** · sola lettura, **zero tempo macchina** · script `backtest_pipeline/r245_dd_vergine.py` (autotest **21/21 PASS**) · seme **248** e generatore **identici** a `r248_bande_vergine.py` (le finestre simulate sono quelle della banda congelata: il p95 d'estate torna **7,44%** alla cifra)
Dati: per-trade vergine `R248/PERTRADE/…765281.csv` (39 posizioni, deposito 100.000) · sorgente `R247/PERTRADE/…765273.csv` (R247b, 197 posizioni, deposito 10.000) · tranche precedente `…765271.csv` (R247a, 154 posizioni) · rendiconti vivi `data/statements/trades_auto.csv`, `trades_100k.csv` · calendari `mql5/Files/abtg_news*.csv` · EURUSD `data/snapshots/*.json`

Riproduzione: `python3 backtest_pipeline/r245_dd_vergine.py` (lettura) · `--autotest` (contro-esempi)

---

## 0. 🧭 In una riga
> **Il DD non viene da una serie di stop e nemmeno da poche perdite grandi: è un'emorragia lenta di 24 posizioni in 36 feriali. Tutte le FREQUENZE sono nella norma (quante posizioni, quanti stop, quante uscite a ORA, serie perdenti, lati). La perdita media degli stop, che grezza esce fuori, è un effetto del BANCO (lotto arrotondato a passo 0,1: d'estate a 10.000 ogni uscita pesa ~6,6% in meno) e a lotto pari torna uguale (−1,04% contro −1,03%). Lo stesso effetto tocca TUTTE le uscite: a lotto pari, contro la sorgente d'estate resta fuori la PROFONDITÀ delle 6 uscite a ORA fissa delle 17:30 (−0,62% contro −0,25%, P 0,2%) e il DD è al bordo (8,45% contro p95 7,93%, P 3,3%); contro tutta la storia della cella DD e uscite a ORA stanno nella norma (P 5,2% e 5,0%, sul filo) e resta fuori la media delle TRAIL (guadagni piccoli, P 0,8%) [DERIVATO]. La causa resta [NON SEPARATA] fra sfortuna del contratto e regime di mercato. Escluse dalla misura: serie di stop, feed (sui punti confrontabili), orologio fra le due estati, FOMC dentro la posizione, stop diverso, binario (sul tratto comune).**

## 1. 📉 Scomposizione del DD (domanda 1)

**Il tratto peggiore**: picco **09/07** → minimo **28/08/2026**, cioè **50 giorni di calendario, 36 feriali, 24 posizioni chiuse DOPO il picco** (dal 10/07 al 28/08 inclusi; 25 contando anche la chiusura del 09/07 che fa il picco), DD **8,38%** (è tutto il DD della finestra; dopo il 28/08 non si approfondisce più: massimo 8,30% il 14/09, chiusura al 7,51% sotto il picco).

| tipo d'uscita (dedotto) | posizioni nel tratto | somma | media |
|---|---:|---:|---:|
| **SL** (stop iniziale, ~−1R) | 7 | **−7,20%** | −1,029% |
| **ORA** (chiusura alle 17:30 server) | 6 | **−3,66%** | **−0,610%** |
| **TRAIL** (trailing M5, esce sempre in pari o in utile) | 11 | +2,16% | +0,196% |
| **TP** (1,5R) | **0** | — | — |

- **Lati**: 23 LONG, 1 SHORT (30/07, il giorno dopo il FOMC, SL −0,98%).
- **Forma**: serie perdente massima **4** posizioni, **SL consecutivi al massimo 2**, le **2 perdite peggiori valgono solo il 20%** delle perdite lorde (10,86%). 👉 **Non è una serie di stop e non sono poche perdite grandi: è un'emorragia lenta.** Le perdite sono di taglia piena (7 SL da −1R e 6 ORA da −0,24 a −0,88R), mentre i guadagni restano briciole: 11 TRAIL con media +0,20% e nessun TP. _(Il criterio "forma" è scritto dopo aver visto i numeri: lo dichiaro.)_
- **Le 6 uscite a ORA** (tutte LONG, tutte ≤ 20/08): 10/07 −0,53 · 14/07 −0,85 · 07/08 −0,46 · 14/08 −0,71 · 18/08 −0,24 · 20/08 −0,88.
- **Ore di uscita**: gli SL chiudono fra le 15:06 e le 17:21, le TRAIL fra le 14:55 e le 17:00.
- **Durata**: nel per-trade non c'è l'ora d'ingresso, quindi ho solo un **maggiorante** [DERIVATO]: chiusura − 14:45 (nessun ingresso può avvenire prima della fine del range). Le uscite a ORA stanno aperte al massimo 165 minuti, gli SL al massimo 21-156.

La tabella completa, posizione per posizione, la stampa lo script nella sezione [1].

## 2. ⚖️ Confronto con la sorgente e con l'anno prima (domanda 2)
Nullo 1 = bootstrap a blocchi di 5 feriali sui **170 feriali d'estate di R247b** (120 posizioni): è il nullo della banda congelata. Nullo 2 (contro-esempio del primo) = i feriali d'estate di **R247a + R247b**, cioè 277 feriali e 199 posizioni: **tutta la storia della cella su questo banco**, aprile 2025 compreso. Le finestre sono da 58 feriali e le repliche 20.000.

| statistica | VERGINE | sorgente estate | stessa finestra 2025 | R247a estate | nel nullo 1 | nel nullo 2 |
|---|---:|---:|---:|---:|---|---|
| posizioni | 39 | 120 | 39 | 79 | norma | norma |
| win rate | 61,5% | 67,5% | 61,5% | 68,4% | norma | norma |
| perdita media | −0,850% | −0,766% | −0,651% | −0,826% | norma | norma |
| guadagno medio | +0,255% | +0,347% | +0,422% | +0,387% | norma (P 0,095) | norma (P 0,06) |
| rendimento medio | −0,148% | −0,015% | +0,010% | +0,004% | al bordo (P 0,048) | norma (P 0,06) |
| serie perdente max | 4 | 3 | 3 | 3 | norma | norma |
| SL consecutivi max | 2 | 2 | 2 | 2 | norma | norma |
| quota LONG | 69,2% | 84,2% | 97,4% | 53,2% | norma | norma |
| quota uscite SL | 20,5% | 23,3% | 20,5% | 22,8% | norma | norma |
| quota uscite a ORA | 15,4% | 10,0% | 15,4% | 10,1% | norma | norma |
| quota uscite TP | 2,6% | 5,0% | 10,3% | 3,8% | norma | norma |
| quota uscite TRAIL | 61,5% | 61,7% | 53,8% | 63,3% | norma | norma |
| **perdita media degli SL** | **−1,029%** | −0,964% | −0,990% | −0,926% | 🔴 **FUORI** (P 0,006) | 🔴 **FUORI** (P 0,001) |
| **media delle uscite a ORA** | **−0,610%** | −0,232% | −0,306% | −0,435% | 🔴 **FUORI** (P < 0,0001) | 🟠 **al bordo** (P 0,031) |
| media delle TRAIL | +0,192% | +0,266% | +0,216% | +0,324% | norma (P 0,063) | 🔴 FUORI (P 0,018) |
| **DD saldo chiuso** | **8,38%** | 7,00% | 3,11% | 6,38% | 🔴 FUORI (P 0,022) | 🟠 al bordo (P 0,036; p95 **7,92%**) |

⚠️ La tabella è GREZZA: vergine a 100.000, nulli a 10.000. A lotto pari (sezione [2e] dello script, tarata sugli SL: T11) cambiano quattro giudizi, nullo 1 / nullo 2: perdita media SL → norma / norma; media ORA → FUORI (P 0,002) / norma (P 0,050); media TRAIL → al bordo (P 0,034) / FUORI (P 0,008); DD 8,45% → al bordo (P 3,3%, p95 7,93%) / norma (P 5,2%, p95 8,52%).

**Controlli con numeri scritti da altri, tutti tornati**: DD della vergine 8,38% e netto −5.686,90 (R248) · 120 posizioni estive con PF 0,94 (R248a §7) · stessa finestra 2025: 39 posizioni, DD 3,11%, PF 1,04 (R248a §7) · DD della sorgente 5,9447% (R247) · R247a 154 posizioni, somma 1.180,94 (R247) · p95 estivo 7,44% (R248).

**Cosa NON può spiegare il DD, ed è nella norma (il contro-esempio chiesto)**: la **frequenza degli stop** (20,5% contro 23,3%), la **lunghezza delle serie** (2 SL consecutivi, 4 perdenti), il **numero di posizioni**, la **quota di uscite a ORA** (15,4%, la stessa identica dell'anno prima), il **lato** e il **win rate**. Se il DD venisse da "più stop del solito" o da "una serie", almeno una di queste sarebbe fuori, e invece nessuna lo è.

**Cosa è fuori norma, e quanto pesa** (controfattuali sul percorso vergine, [DERIVATO], **scelti DOPO aver visto quali componenti uscivano fuori**: non sono misure della causa):
- 🟠 **La perdita media degli SL è un effetto del BANCO, ed è misurato.** A 10.000 il lotto arrotondato sotto a passo 0,1 rende gli stop più leggeri del 6-7%. Il fattore d'estate si ricava posizione per posizione dai volumi (frazione di lotto 0,934 a 10.000, 0,991 a 100.000) ed è tarato sugli SL: a lotto pari −1,028 contro −1,037 (T11). L'ancora annuale (Equity DD 6,864% contro 7,010%, fattore 1,021) NON è il fattore d'estate: d'inverno i lotti sono ~3 volte più grandi. A lotto pari la vergine fa 8,45% contro un p95 di 7,93%: 👉 **È vero ma non basta da solo.**
- 🟠 **Controfattuale sulle uscite a ORA** (scelto dopo i numeri): a lotto pari, con le 6 uscite a ORA alla media della sorgente (−0,252%) il DD scende da 8,45% a **6,41%**; scalando anche le TRAIL arriva a **5,45%**; le sole TRAIL lo portano a 7,51%.
- ⚠️ **Però "FUORI" contro il nullo 1 è anche un limite del nullo** (autotest T10). La sorgente ha solo **12** uscite a ORA: in grezzo la peggiore è −0,605% e la vergine sta a −0,610, sotto il supporto del bootstrap (P < 0,0001). A lotto pari la peggiore diventa −0,655 contro −0,616 della vergine: il supporto non morde più del tutto e il FUORI resta (P 0,002), ma poggia su 12 valori. Contro tutta la storia della cella, dove **R247a d'estate ha tre uscite a ORA fra −0,73 e −0,83**, le uscite a ORA e il DD sono "al bordo" in grezzo (P 0,031 e 0,036) e **nella norma a lotto pari** (P 0,050 e 0,052, sul filo). **Profondità così la cella le ha già fatte, ma non in un anno solo.**
- 📌 Sui confronti multipli: 16 statistiche per 2 nulli. La calibrazione T6 misura fino al **7,5%** di falsi "FUORI" per statistica (discrete), quindi un "al bordo" isolato non pesa da solo.

## 3. 🗓️ Eventi macro (domanda 3)
- **FOMC**: 29/07 (dentro il tratto) e 16/09, alle 20:00 ora italiana = **19:00 server BCM**. La sedia chiude **alle 17:30 server**, quindi una posizione non può essere aperta durante un FOMC. **ESCLUSO come causa intraday** (per costruzione dell'orario). Il 30/07, giorno dopo, c'è l'unico short del tratto (SL).
- **Dati 8:30 ET** = 13:30 server d'estate (UTC+1 fisso, `OROLOGIO_BCM_2026-09-24`): arrivano **prima** del range 14:30-14:45. Possono agire solo sull'ampiezza del range, cioè sullo stop, e lo stop risulta nella norma (§4).
- **Dati 10:00 ET** (ISM, JOLTS, fiducia) = **15:00 server**, dentro la finestra d'ingresso e di tenuta: 🔴 **[NON MISURATO]**. **Il calendario del repo ha un buco in TUTTE E DUE le estati**: il file 2021-2025 ha 42/42/40 eventi USD al mese in aprile-giugno 2025, **10 a luglio, 0 ad agosto, 1 a settembre**; per il 2026 ci sono solo FOMC (`abtg_news.csv`) e l'NFP del 04/09 (file live). Le date degli ISM 2026 **non le scrivo a memoria**.

## 4. 📏 Distanza dello stop / range dei 15 minuti (domanda 4)
Il per-trade **non ha né ingresso né SL**. Si può usare solo un **proxy dal volume** [DERIVATO]: lotto = floor(1% saldo / (stop × valore del punto)). Il valore del punto è 1 USD/punto/lotto, cioè 0,857-0,863 EUR (`EMA200_I_DUE_REQUISITI_2026-09-12` p.4), e commissione e swap sono 0. Da qui si ricava stop%/EURUSD fra un minorante (vol + 0,1) e un maggiorante (vol).

| finestra | mediana stop%/EURUSD [min ; max] |
|---|---|
| **vergine** (100.000, lotto quasi esatto) | **[0,289 ; 0,293]** |
| sorgente estate (10.000) | [0,279 ; 0,315] |
| stessa finestra 2025 | [0,240 ; 0,270] |
| sorgente **inverno** | **[0,082 ; 0,085]** |

- **Vergine contro sorgente d'estate: DENTRO** (banda del nullo sulla mediana 0,251-0,362). Con EURUSD 2026 dalle foto (27 posizioni su 39) lo stop mediano esce **~0,36% del prezzo ≈ 190 punti indice**. **Lo stop più largo o più stretto è ESCLUSO**, entro la risoluzione del proxy. I limiti: EURUSD 2025 **non è nel repo** [NON MISURATO] e a 10.000 l'arrotondamento del lotto arriva al 33% sui lotti piccoli, quindi una differenza sotto il ~10% non si risolve.
- 🟢 **Misura di passaggio, che va a R250 e non a questo DD**: **d'inverno lo stop è 3,5 volte più stretto**. L'EA arma alle 14:30 server, cioè un'ora prima della cash, e il range che trova è quello del pre-mercato. Il proxy lo vede (autotest T8, il contro-esempio che il proxy doveva superare), ed è compatibile con il merito tutto invernale (TP 40% d'inverno contro 5% d'estate).
- **La misura esatta** chiede un **test singolo con log** (classe 771: ingresso, SL e ora per ogni posizione) oppure `ExportTrades` con ingresso e SL, che però è una modifica all'EA.

## 5. 🎯 Conclusione onesta (domanda 5)

| ipotesi | esito | la misura |
|---|---|---|
| **Serie di stop / più stop del solito** | ❌ **ESCLUSA** | quota SL, serie e win rate nella norma in tutti e due i nulli |
| **Dati o feed del PC di backtest** | ❌ **ESCLUSA sui punti verificabili** | frequenza in banda, G-DATI verde; **3 uscite di R245 su 39 identiche al centesimo al feed VIVO** (07/08 17:30:00 ORA, 10/08, 13/08), più il per-trade vergine di 770202 (R248b 765283) identico al vivo su **3 uscite distinte** (10/08, 13/08, 28/08; 6 confronti perché ognuna è sia in `trades_auto.csv` sia in `trades_100k.csv`): **4 istanti distinti** in tutto. Delle 6 uscite a ORA ne è verificata **1** (07/08). Le altre 36 uscite restano [NON VERIFICATE] |
| **Orologio** | ❌ **ESCLUSA fra le due estati** | stesso orologio (UTC+1 fisso sugli indici): 17:30 server = 12:30 ET in tutte e due; quota ORA **identica** (15,4%) all'anno prima |
| **Binario diverso fra sorgente e vergine** | ❌ **ESCLUSA sul tratto comune** | stesso pin della vergine (`4d142cbb`, R248a) sulla corsa 2025.07.01-2026.06.30: 197 posizioni, PF 1,484 a 100.000 contro 197 e 1,489 di R247b a 10.000 (`REFERTO_ROUND_R248a.txt`) |
| **FOMC dentro la posizione** | ❌ **ESCLUSA** | FOMC alle 19:00 server, uscita forzata alle 17:30 |
| **Stop più largo / range diverso** | ❌ **ESCLUSA** (entro il proxy) | §4 |
| **Banco: deposito 100.000 contro 10.000** | 🟠 **MISURATA, parziale** | lotto a passo 0,1: d'estate a 10.000 ogni uscita pesa ~6,6% in meno (a 100.000 ~0,9%); spiega tutto lo scarto degli SL; a lotto pari la vergine fa 8,45% contro p95 7,93%: non basta da solo |
| **Sfortuna del contratto (H0)** | ✅ **COMPATIBILE** | DD P 2,2% (contratto) e **3,6%** (storia intera, p95 7,92%); a lotto pari **3,3%** (p95 7,93%) e **5,2%** (p95 8,52%) [DERIVATO]; ORA "al bordo" contro la storia in grezzo (P 0,031), nella norma a lotto pari (P 0,050, sul filo) |
| **Regime: rotture che si spengono e scivolano fino alle 12:30 ET** (lug-ago 2026, 23 long su 24) | ✅ **COMPATIBILE** | è la forma osservata (ORA profonde, TRAIL piccole, zero TP) ma non ha una misura propria |
| **Dati 10:00 ET dentro la posizione** | ❓ **[NON MISURATO]** | calendario bucato |

**La misura successiva, sulla stessa metrica (il DD, classe 790)**, in ordine di costo:
1. **Separa regime da sfortuna, zero tempo del tester.** Un export di **sola lettura** delle barre U30USD M5 14:30-17:30 server dal terminale del **PC di backtest** (a tranche, per il tetto di barre), dal 2024.09.26 al 2026.09.18, più uno script Python che misura una grandezza **indipendente dall'EA**: la deriva avversa alle 17:30 dopo la prima rottura del range di 15', in unità di range. Con la stessa grandezza si calcola il **DD di una rottura semplificata** con uscita alle 17:30 su ogni finestra estiva. Se lug-ago 2026 sta fuori dalla distribuzione storica di quella grandezza, il DD è **del mercato**; se ci sta dentro, restano sfortuna o percorso dell'EA. Costo: pochi secondi di export e lo script da scrivere; la riga passa dai cancelli.
2. **Chiude §4 e le durate**: test singolo con log (classe 771), stessi pin, finestra vergine più stessa finestra 2025. **~2-4 minuti** sul PC di backtest, mai sul VPS. Dà l'R esatto di ogni uscita a ORA e lo stop in punti.
3. **Chiude §3**: il calendario storico 2025-2026 dalla stessa fonte del file 2021-2025 (`tools/converti_calendario_news.py`). Zero tempo macchina, ma **serve il dataset**: 🙋 **Claudio, questo buco lo puoi chiudere tu.**

⚠️ **Il limite, detto chiaro**: nessuna di queste misure trasforma 58 feriali in una prova. **Sfortuna e regime si separano davvero solo con altro fuori campione.** Questo referto non promuove, non archivia e non tocca il ramo "revisione" di R248.

## 6. 🪦 Cosa resta aperto
Causa del DD: **[NON SEPARATA]** fra sfortuna del contratto e regime. Escluse con misura: serie di stop, feed (sui punti confrontabili), orologio fra le estati, FOMC intraday, stop diverso. Il banco (deposito) è misurato e parziale; a lotto pari il DD resta sopra il p95 della banda d'estate portata a lotto pari (8,45% contro 7,93%). Escluso anche il binario sul tratto comune. Restano [NON MISURATI]: dati 10:00 ET, 36 uscite su 39 contro il feed vivo, EURUSD 2025, ingresso e SL esatti.

_Nessun EA toccato, nessuna taglia, nessuna sedia, nessun conto. Zero tempo macchina._

---
_Cancello: strato 1 OK; strato 2 FAIL (D1 banco non propagato -> classe 791; D2 data; D3 conteggio; D4 etichetta; D5 binario) -> seconda passata: PASS con E1-E5 applicate._
