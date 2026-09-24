# 🕰️ L'OROLOGIO DI BCM — da quando non segue piu' l'ora legale, e che cosa sposta

**24/09/2026** · branch `lavoro` · **SOLA LETTURA**: nessun backtest, nessun EA, preset o parametro
toccato, nessuna riga mandata al VPS, nessun terminale aperto. Conto reale **10105439**: citato solo
per dire quali sedie lo toccano, nessuna proposta. Taglie e rischio: di Claudio, non toccati.

Domanda del cancello (classe 762): *l'orologio del server BCM segue l'ora legale europea, o da un
certo momento e' GMT+1 fisso? E da quando?* L'ipotesi del cancello era un **INDIZIO**. Qui e'
verificata alla fonte, riga per riga, e messa contro tre ipotesi alternative.

---

## 0. 🥇 La risposta in sei righe

1. 🟢 **L'ipotesi REGGE, con una correzione sulla data.** Fino a dicembre 2024 BCM = **ora
   italiana − 1** (UTC+0 d'inverno, UTC+1 d'estate, calendario **europeo**). Dal cambio in poi
   BCM = **UTC+1 FISSO**: ora italiana −1 d'estate, **ora italiana ESATTA d'inverno**.
2. 📅 **Data del cambio, storico FOREX: dopo il 26/12/2024 23:03 e entro il 02/02/2025 23:05.**
   Al giorno: **[NON MISURATA]**. Il cancello diceva "fra 03/11/2024 e 02/02/2025": i dati di
   novembre e dicembre 2024 stanno ancora nel **vecchio** orologio (§3.1).
3. 🔴 **Lo storico INDICI (dal 2024.09.26) e' in UTC+1 fisso su TUTTO il suo arco**, anche a
   novembre e dicembre 2024. Forex e indici **non concordano** su quei due mesi (§3.2).
4. 🔴 **Conseguenza grossa: nei backtest delle sedie d'apertura, i mesi d'inverno sono stati misurati
   con l'ingresso UN'ORA PRIMA dell'apertura cash** (DAX armato alle 08:00 CET, Dow/Nasdaq alle 8:30
   di New York). Le sedie FTMO `770101`, `770202`, `770260`, `770411` hanno numeri di contratto che
   contengono il **44-62%** di uscite da mesi "sfasati" (§5.1).
5. 🟠 **Dal 26/10/2026 (DAX) e dal 02/11/2026 (USA) le sedie BCM vive armeranno un'ora prima della
   cash**, e le FTMO no: FTMO resta agganciata all'ora italiana. **Le sedie FTMO d'inverno faranno una
   cosa diversa da quella che il loro backtest ha misurato d'inverno** (§5.3).
6. **Confidenza**: sul cambio d'orologio **ALTA** (tre ancore indipendenti, contro-esempi esclusi);
   sulla data al giorno **[NON MISURATA]**; su quanto dei P/L d'inverno dipenda dall'orologio
   **NON DIMOSTRATO** (il contro-esempio EMA200 lo impedisce, §5.1.3).

🎉 La buona notizia, prima di tutto: **la misura si chiude dal repo, a costo zero**, e ha trovato un
buco che avrebbe morso fra **un mese esatto**, non dopo. E dentro il buco c'e' pure una pista di
ricerca (§7).

---

## 1. 🔬 Il metodo: tre ancore che non dipendono l'una dall'altra

Tutti i CSV per-trade del repo (fuori da `.claude/worktrees`) con colonne `symbol` + orario:
**24.400 affari unici** (i file gemelli `7791x0`/`7791x1` di R82 sono copie identiche: deduplicati
per `(ora, simbolo, prezzo)`). Le ore sono **ora server BCM** del tester o dell'estratto conto.

| ancora | che cosa e' | vecchio orologio (UTC+0 inv.) | nuovo (UTC+1 fisso) | ora italiana CET/CEST |
|---|---|---|---|---|
| **A. apertura FX della domenica** | primo tick della settimana | 22:05-22:10 | **23:05** d'inverno | 23:05 |
| **B. pausa di rollover FX** | 5 minuti senza quotazioni, lun-ven | **22:00-22:04** | **23:00-23:04** d'inverno | 22:00-22:04 |
| **C1. dati USA delle 8:30 ET** | CPI, NFP, vendite al dettaglio | 13:30 (inverno) | **14:30** (inverno) | 14:30 (inverno) |
| **C2. apertura cash Wall Street 9:30 ET** | picco di affari sugli indici | 14:30 (inverno) | **15:30** (inverno) | 15:30 (inverno) |
| **C3. apertura Xetra 09:00 CET** | picco di affari sul DAX | 08:00 (inverno) | **09:00** (inverno) | 09:00 |

📌 **A e B** sono sessioni del broker, **C** sono eventi del mondo a ora fissa (UTC). Un cambio di
sole *sessioni* sposterebbe A e B ma non C: e' esattamente la terza ipotesi alternativa (§4).
D'estate le cinque ancore **devono** cadere uguali nei due regimi (UTC+1 in tutti e due): e' il
controllo interno.

---

## 2. 📏 Le misure

### 2.1 La tabella per periodo (affari lun-ven, forex salvo dove scritto)

| periodo | FX 22:00-04 | FX 22:05-14 | **FX 23:00-04** | **FX 23:05-14** | FX 13:30-33 | FX 14:30-33 | indici USA 14:30-34 | **indici USA 15:30-34** | DAX 08:00-04 | **DAX 09:00-04** |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| A · inverni 2014/15 → 2023/24 | **0** | 26 | 6 | 5 | **99** | 27 | — | — | — | — |
| B · 03/11 → 26/12/2024 | **0** | 1 | **6** | **0** | 3 | 1 | 4 | **26** | 1 | **10** |
| C · 27/12/2024 → 31/01/2025 | 0 | 0 | 0 | 1 | 0 | 1 | 3 | **9** | 2 | **5** |
| D · feb-mar 2025 | 0 | 0 | 0 | 1 | 0 | 4 | 9 | 8 | 2 | **12** |
| E · inverno 2025/26 | 0 | 3 | **0** | **11** | 2 | **8** | 28 | **141** | 6 | **65** |
| settimane sfasate (USA ora legale, UE no) dal 2025 | 0 | 2 | 0 | 0 | 4 | 0 | **22** | 1 | 2 | **18** |
| **ESTATI** (tutte) | **0** | **82** | 30 | 9 | **205** | 59 | **295** | 47 | **135** | 63 |

Come si legge:
- 🟢 **Controllo interno (estati)**: pausa alle 22:00 (**0 su 82**), dati USA alle 13:30, cash USA
  alle 14:30, Xetra alle 08:00 = **UTC+1**. Identico prima e dopo il cambio.
- 🟢 **Inverni vecchi (A)**: pausa alle 22:00 (**0 su 26**), dati USA alle 13:30 (**99 contro 27**)
  = **UTC+0** = ora italiana −1.
- 🔴 **Inverno 2025/26 (E)**: pausa alle **23:00** (**0 affari in 23:00-04, 11 in 23:05-14**), dati
  USA alle **14:30** (8 contro 2), cash USA alle **15:30** (141 contro 28), Xetra alle **09:00**
  (65 contro 6) = **UTC+1**. Quattro ancore su quattro.
- ⚠️ Il fondo di 14:30 in A (27) e di 13:30 in E (2) e' rumore di barra: gli EA M15 agiscono a
  :00/:15/:30/:45 comunque. Conta il **rapporto**, e si ribalta: **3,7 : 1** contro **1 : 4**.

### 2.2 La domenica, una per una (ottobre 2024 → aprile 2026, forex)

Primo affare forex della domenica. D'inverno un'uscita **alla stessa ora esatta su piu' simboli** e'
uno stop in gap: e' il primo tick della settimana.

| domenica | regime | primo affare | simboli | fonte (file:riga) |
|---|---|---|---:|---|
| 13/10/2024 | estate | 22:15:00 | 2 | `r82_csv/pertrade_r82b_779121.csv:1801` |
| *nov 2024 → gen 2025* | inverno | *nessuna domenica con affari* | — | — |
| **02/02/2025** | **inverno** | **23:05:00** | **5** (AUD/CHF/EUR/GBP/NZD-JPY) | `r82d_779141:1813` · `r82e_779151:1559` · `r82b_779121:1851` · `r82c_779131:1229` · `r82g_779170:1723` |
| 16/03/2025 | sfasata | 23:00:40 | 1 | `r82d_779141:1837` *(non decide: tetto superiore)* |
| 06/04 · 13/04 · 11/05 · 18/05/2025 | estate | **22:10:00** | 1-4 | `r82c_779131:1261` · `r82g_779170:1760` · `r82d_779141:1861` · `r82b_779121:1901` |
| 20/07 · 27/07 · 10/08 · 07/09/2025 | estate | **22:10:00** | 1-5 | `r82e_779151:1623` · `r82g_779170:1810` · `r82g_779170:1819` · `r82e_779151:1647` |
| 26/10/2025 | sfasata (UE solare, USA legale) | **22:10:00** | 2 | `r82g_779170:1853` |
| **16/11/2025** | **inverno** | 23:16:00 | 1 | `r82f_779161:1956` |
| **04/01/2026** | **inverno** | 23:56:40 | 1 | `r82g_779170:1891` |
| **18/01/2026** | **inverno** | 23:09:37 | 1 | `risultati_prove/trades_ez/abtg_trades_ABTG_EasyTrend_CHFJPY_772411.csv:32` |
| **25/01/2026** | **inverno** | 23:40:04 | 2 | `trades_ez/abtg_trades_ABTG_EasyTrend_AUDJPY_772415.csv:36` |
| **01/02/2026** | **inverno** | 23:23:40 | 4 | `r82c_779131:1403` |
| **08/02/2026** | **inverno** | 23:15:00 | 1 | `r82c_779131:1406` |
| **15/02/2026** | **inverno** | **23:05:00** | 2 | `r82g_779170:1909` |
| **01/03/2026** | **inverno** | **23:05:00** | **3** | `r82e_779151:1726` · `r82c_779131:1417` · `trades_cost/abtg_trades_ABTG_CostToCost_EURJPY_772351.csv:47` *(23:05:02, lo stop citato dal cancello)* |
| 29/03 · 05/04 · 12/04 · 19/04/2026 | estate | 22:15 | 1-2 | `trades_ez/...CHFJPY_772411.csv:46` · `trades_larry/...GBPUSD_772330.csv:19` · `trades_candidati_r23/...SuperWave_GBPUSD_770524.csv:55` · `r82e_779151:1750` |
| 07/06/2026 | estate, **conto vivo** | 22:10:03 | 7 | `data/statements/trades_auto.csv:439` |
| 13/09/2026 | estate, **conto vivo** | 22:10:00 *(apertura)* | 1 | `data/statements/trades_auto.csv:1306` (GapFill `772233`) |

Le `r82_*` stanno in `backtest_pipeline/risultati_archivio/r82_csv/` (modello OHLC M1, R82 del
18/08). **Riassunto delle domeniche d'inverno**:

| | domeniche | primo affare alle 22:xx | alle 23:xx |
|---|---:|---:|---:|
| inverni 2014/15 → 2023/24 | 58 | **44** (76%) | 14 |
| inverni 2024/25 (da feb) + 2025/26 | 9 | **0** | **9** |

Se l'orologio non fosse cambiato, **0 su 9** avrebbe probabilita' 0,24⁹ ≈ **3 su un milione**.
Esempi del vecchio inverno: 29/11/2020 **22:10:00** (`r82f_779161:1048`), 13/12/2020 22:10:00
(`r82g_779170:1012`), 05/02/2023 22:10:00 (`r82e_779151:1299`), 19/11/2023 22:10:00
(`r82g_779170:1519`), 24/12/2023 22:10:30 (`r82f_779161:1614`), 18/02/2024 22:30:00
(`r82c_779131:1057`) — **l'ultima domenica d'inverno col vecchio orologio**.

### 2.3 Le ancore datate col calendario (dati USA alle 8:30 ET)

Calendario del repo: `mql5/Files/abtg_news_2021_2025_UTC.csv` (UTC) e `mql5/Files/abtg_news.csv`
(ora italiana).

| giorno | dato (fonte calendario) | ora UTC | affari BCM | → BCM = | fonte affari |
|---|---|---|---|---|---|
| 03/11/2023 (sfasata) | NFP (`abtg_news_2021_2025_UTC.csv:1939`) | 12:30 | **12:30:40** | UTC+0 | `r82a_779110:1638` |
| 12/03/2024 (sfasata) | CPI (`...UTC.csv:2168`) | 12:30 | **12:30:40** | UTC+0 | `r82b_779121:1689` |
| 04/11/2022 (sfasata) | NFP (`...UTC.csv:1279`) | 12:30 | **12:30:40** | UTC+0 | `r82c_779131:849` |
| 05/12/2024 | richieste sussidi settimanali *(non "High" nel calendario: indizio)* | 13:30 | 13:30:40 · 13:32:40 · 13:33:40 (3 simboli) | UTC+0 | `r82f_779161:1776` · `r82a_779110:1848` · `r82b_779121:1823` |
| **12/02/2025** | **CPI** (`...UTC.csv:2705`) | 13:30 | **14:30:40 · 14:31:40 · 14:32:20** (3 simboli) | **UTC+1** | `r82f_779161:1821` · `r82d_779141:1820` · `r82g_779170:1729` |
| **14/02/2025** | vendite al dettaglio (`...UTC.csv:2718`) | 13:30 | **14:32:40** | **UTC+1** | `r82a_779110:1880` |
| **09/01/2026** | **NFP** (`abtg_news.csv:3`, 14:30 IT) | 13:30 | **14:30:00 · 14:30:11 · 14:32:32** | **UTC+1** | `r82f_779161:1985` · `trades_candidati_r23/...SuperWave_GBPUSD_770524.csv:33-34` |
| **11/02/2026** | dato USA 8:30 (`abtg_news.csv:8`, 14:30 IT) | 13:30 | **14:30:03** | **UTC+1** | `...SuperWave_GBPUSD_770524.csv:48` |

🟢 **E le prime tre righe chiudono una domanda che nessuno aveva posto**: il **vecchio** orologio
seguiva il calendario **europeo** (nelle settimane sfasate di marzo e ottobre-novembre il dato
delle 8:30 EDT cade alle **12:30** BCM = UTC+0). Quindi "BCM = ora italiana −1" era vero **alla
lettera, tutto l'anno**, fino al cambio. Coerente con lo shift `+5` (± DST) di
`backtest_pipeline/risultati_archivio/REFERTO_IMPORT_6_SIMBOLI.md` §2 su HistData 2018-2024.

---

## 3. 📅 La data del cambio

### 3.1 Storico FOREX — forchetta **(26/12/2024 23:03 ; 02/02/2025 23:05]**

| | ultimo segno del VECCHIO orologio | primo segno del NUOVO |
|---|---|---|
| pausa di rollover | **26/12/2024 23:03:00** AUDJPY (`r82d_779141:1792`): un affare dentro 23:00-04, cioe' dentro la pausa del nuovo orologio. Prima: 04/11 23:00:00 (`r82e_779151:1513`), 13/11 23:00:00 (`:1518`), 20/11 23:00:40 (`r82g_779170:1685`), 28/11 23:01:59 (`r82d_779141:1779`), 11/12 23:00:00 (`r82g_779170:1697`) | 30/01/2025 **23:05:00** GBPJPY (`r82c_779131:1228`): tick di riapertura esatto (**indizio**, non prova) |
| apertura settimanale | 18/02/2024 22:30 (nessuna domenica con affari fra nov 2024 e gen 2025) | **02/02/2025 23:05:00, cinque simboli** (§2.2) — **prova** |
| dati USA 8:30 | 05/12/2024 13:30:40 ×3 (indizio, §2.3) | **12/02/2025 14:30:40 ×3** (CPI) — **prova** |

- 📅 **Data al giorno: [NON MISURATA].** A gennaio 2025 il repo non ha nessuna ancora che decida
  (nessuna domenica con affari, nessun affare nelle finestre dei dati USA del 10/01 e del 15/01).
  Il **01/01/2025** e' l'ipotesi piu' naturale, ma e' un'ipotesi. Si chiude in dieci minuti su un
  grafico (§6).
- 🔴 **Correzione all'indizio del cancello**: il cambio **non** e' "fra il 03/11/2024 e il
  02/02/2025" sul forex. Novembre e dicembre 2024 sono **vecchio orologio** (sei affari in
  23:00-04 contro **zero** su undici in tutto l'inverno 2025/26, e zero su 82 nella pausa d'estate).

### 3.2 Storico INDICI — UTC+1 fisso **da sempre** (dal 2024.09.26)

| periodo | USA 14:30-34 | **USA 15:30-34** | DAX 08:00-04 | **DAX 09:00-04** |
|---|---:|---:|---:|---:|
| nov 2024 | 2 | **13** | 0 | **3** |
| dic 2024 | 3 | **13** | 1 | **9** |
| gen 2025 | 2 | **9** | 2 | **3** |
| inverno 2025/26 | 28 | **141** | 6 | **65** |
| estati | **295** | 47 | **135** | 63 |

Fonti: `backtest_pipeline/risultati_archivio/R109_deal_anomali/{D30EUR,U30USD,NASUSD}_0{0,1}_*_pertrade_singola.csv`
(tick reali, 2024.09.30 → 2026.08.20) piu' gli altri per-trade indici. **A novembre 2024 gli indici
aprono gia' alle 15:30 e alle 09:00 BCM**, mentre il forex degli stessi giorni e' ancora UTC+0.

🔴 **Forex e indici non concordano su nov-dic 2024.** Spiegazione piu' probabile, **[IPOTESI NON
VERIFICATA]**: lo storico degli indici (che parte guarda caso dal 2024.09.26) e' stato caricato o
ri-timbrato dopo il cambio, quello forex no. Non cambia nulla per l'inverno 2025/26, dove concordano.

🟢 **E un indizio indipendente che torna**: `backtest_pipeline/risultati_archivio/import_ext_v2_referto_2026-08-19.csv`
r.2-4 — l'import HistData degli indici con shift "calendario europeo" da' differenza media
**0,27%** *dentro* le settimane sfasate e **0,066%** fuori, contro **0,006-0,011%** del forex
2018-2024. E' la firma di uno storico nativo **che non segue l'ora legale europea**.

---

## 4. 🧪 I contro-esempi (che cosa produrrebbe l'altra spiegazione)

| ipotesi alternativa | che cosa prevede | che cosa c'e' | esito |
|---|---|---|---|
| **H0 · BCM = ora italiana −1 sempre** (la regola di `CLAUDE.md`) | inverno 2025/26: domenica 22:05-22:10, pausa 22:00, dati 13:30, cash USA 14:30, Xetra 08:00 | domenica **23:05** (0/9 alle 22), pausa **23:00** (0 su 11), dati **14:30** (8:2), cash **15:30** (141:28), Xetra **09:00** (65:6) | ❌ **esclusa** |
| **H2 · BCM = ora italiana (CET/CEST, con ora legale)** | estate 2025/26: domenica 23:05, cash USA 15:30, Xetra 09:00 | estate: domenica **22:10**, cash **14:30** (295:47), Xetra **08:00** (135:63); conto vivo 13/09/2026 apre alle **22:10** | ❌ **esclusa** |
| **H3 · orologio invariato, solo le SESSIONI forex spostate di 1h** | sposta domenica e pausa, **non** i dati USA ne' le aperture cash (sono eventi UTC) | dati USA, cash USA e Xetra si spostano **tutti** di +1h, insieme alle sessioni | ❌ **esclusa** |
| **H4 · cambio gia' a fine ottobre 2024 anche sul forex** (l'indizio del cancello) | nov-dic 2024: zero affari forex in 23:00-04 | **sei** affari in 23:00-23:03 (04/11 → 26/12/2024) | ❌ **esclusa sul forex**, vera sugli indici |
| **H1 · UTC+1 fisso dal cambio** | inverno: 23:05 / 23:00 / 14:30 / 15:30 / 09:00; estate: 22:10 / 22:00 / 13:30 / 14:30 / 08:00 | tutto | ✅ **regge** |

---

## 5. 💥 Le conseguenze, sedia per sedia

### 5.1 a) I backtest sugli indici: i mesi d'inverno hanno misurato un'ALTRA strategia

Gli EA leggono `TimeCurrent()` (ora server, `ABTG_DAX_Apertura_EU.mq5` r.745 e r.818) e nessuno ha
logica di ora legale. Con lo storico indici in UTC+1 fisso:

| mercato | mesi "sfasati" | `InpSessionHour` BCM | che ora e' davvero | apertura cash |
|---|---|---|---|---|
| DAX | ultima dom. di ottobre → ultima dom. di marzo | **08:00** | 08:00 CET | 09:00 CET → **1h dopo** |
| Dow / Nasdaq | 1ª dom. di novembre → 2ª dom. di marzo | **14:30** | 8:30 New York (**ora dei dati USA**) | 9:30 NY → **1h dopo** |

#### 5.1.1 Il conto per sedia (per-trade usati da `backtest_pipeline/mc_challenge_ftmo.py` r.40-43)

| sedia FTMO | per-trade | uscite allineate | **uscite sfasate** | netto allineato | **netto sfasato** | PF alli. | PF sfas. |
|---|---|---:|---:|---:|---:|---:|---:|
| `770101` DAX Apertura | `aperture_r47/..._D30EUR_772501.csv` | 144 | **126 (47%)** | +5.065,53 | **+12.964,05 (72%)** | 1,27 | 1,48 |
| `770202` Dow Apertura | `aperture_r47/..._U30USD_772505.csv` | 73 | **57 (44%)** | **−2.415,84** | **+9.137,77 (136%)** | **0,78** | 1,66 |
| `770411` MaxMin DAX Short | `trades_portafoglio/..._770413.csv` | 8 | **13 (62%)** | +2.189,51 | **+3.953,87 (64%)** | 2,03 | 2,25 |
| `770260` Nasdaq RETEST | **non in repo** | — | — | — | — | — | — |
| `771531` EMA200 H1 | `trades_candidati_r23/..._771521.csv` | 347 | 170 | +25.939,44 | −2.617,97 | 2,05 | 0,87 |
| `770511` SuperWave H1 | *(proxy `770521`, cella diversa)* | 42 | 46 | +3.229,70 | +1.141,36 | 5,83 | 1,23 |

Finestra: 2025.06.10 → 2026.06.29 (tick reali). Gemelle della stessa famiglia, stesso segno:
`772503` DAX **1,32 → 1,60**; `772507` Dow **0,81 → 1,55**; `r84a_776010` Nasdaq (cella
`EntryMode=0`, **non** la RETEST) **0,70 → 1,39**.

- 🔴 **`770202`**: nei mesi in cui arma **all'apertura giusta** il backtest e' **in perdita**
  (PF 0,78, n=73). **Tutto** l'utile di contratto viene dai mesi in cui armava alle 8:30 NY.
- 🔴 **`770411`**: in quei mesi il box, il piazzamento (07:59) e il cutoff (**08:30**) cadevano
  **tutti prima dell'apertura Xetra**. 13 uscite su 21.
- 🔴 **`770260`**: per costruzione (14:30 BCM) ha lo stesso sfasamento; il per-trade della cella
  RETEST **non e' nel repo** → **[NON MISURATO]**.
- 🟢 **`771531` e `770511`** non hanno ingressi orari attivi (`InpUseCutoff=false`,
  `InpUseTimeWindow=false`, filtro news spento nei preset FTMO): contengono mesi d'inverno ma **non
  sono sfasate**.

#### 5.1.2 Il meccanismo si vede nelle ore di chiusura
`r84a_776010` (Nasdaq): mesi allineati chiudono alle **14:xx** (158 su 192), mesi sfasati alle
**15:xx** (55 su 99). L'EA arma alle 14:30 BCM, ma d'inverno il mercato si muove alle 15:30: il
range si fa sul **pre-mercato** e l'ingresso lo decide l'apertura cash.

#### 5.1.3 🧪 Il contro-esempio che IMPEDISCE di dare la colpa all'orologio
Dividere per orologio significa dividere per **stagione**. `771531` EMA200 H1, che **non e'
sensibile all'ora**, passa da PF **2,05** a **0,87** fra le stesse due meta' dell'anno: differenze
di quella taglia le fa **il mercato da solo**. Quindi **non e' dimostrato** che le Aperture rendano
di piu' *perche'* armano prima. E' dimostrato **solo** che i loro numeri di contratto **mescolano due
tempistiche diverse**, e che ~45% delle uscite viene da quella che in campo FTMO **non girera'**.

#### 5.1.4 Altri backtest toccati
- **Storici `_EXT` degli indici** (HistData 2010-2024, shift `+5`): d'inverno mettono l'apertura
  USA alle 14:30 e Xetra alle 08:00, cioe' **vecchio orologio**. Un backtest che attacca `_EXT` e
  storico nativo ha **un salto d'orologio alla giuntura** (settembre 2024).
- **R214e/f `CostToCost` EURJPY, colonna FTMO col confine fisso alle 23 BCM** (classe 762): il
  confine giusto e' **23** col vecchio orologio e d'estate, **00** negli inverni dopo il cambio.
  Sui giorni feriali di R214e (2024.07.05 → 2026.06.30, 518 giorni) quelli sbagliati sono
  **150-176 = 29,0-34,0%** secondo la data del cambio nella forchetta, **non il 42,5%** della classe
  762 (che corrisponde a un cambio al 27/10/2024, escluso sul forex in §3.1). La patch del cancello
  va ricalcolata con la forchetta, non con quella data.

### 5.2 b) Le sedie vive BCM (conti **50503392** e **50504263**), se BCM resta UTC+1 fisso

**Previsione, non misura**: l'ultimo inverno misurato (2025/26) e' UTC+1 fisso; l'estate 2026 in
campo e' UTC+1 (`trades_auto.csv:1306`). Salvo cambi di BCM, dal **25/10/2026** BCM = **ora
italiana**. Si verifica il 26/10 (§6.3).

| sedia | conto (terminale) | input orario | dal 26/10/2026 | dal 02/11/2026 |
|---|---|---|---|---|
| `770101` DAX Apertura | 50503392 · 50504263 · *(anche 10105439)* | 08:00 | 🔴 08:00 IT, **1h prima di Xetra** | idem |
| `770411` MaxMin DAX Short | 50503392 · 50504263 | box 23-04:59, place 07:59, cutoff 08:30 | 🔴 **tutto prima di Xetra** | idem |
| `770202` Dow Apertura | 50503392 · 50504263 | 14:30 | 🟢 ancora giusta (NY in ora legale fino al 01/11) | 🔴 **8:30 NY** |
| `770250` Nasdaq Apertura | 50503392 | 14:30 | 🟢 | 🔴 **8:30 NY** |
| `770611` ORB U30USD | 50503392 · 50504263 · *(anche 10105439)* | range 14:xx | 🟢 | 🔴 **8:30 NY** |
| `771203` PostNews NFP USDJPY | 50503392 | azione 13:45 | — | 🔴 NFP alle **14:30**: agisce **45' PRIMA** del dato |
| `771202` PostNews FOMC EURUSD | 50503392 | azione 19:40 | — | 🔴 FOMC alle **20:00**: agisce **20' PRIMA** |
| `771201` PostNews ECB EURJPY | 50503392 | azione 14:00 | 🔴 BCE alle **14:15** BCM: agisce **prima** | idem |
| `772421`/`772422` EasyTrend | 50503392 | finestra 08-18 | 🟠 finestra spostata di 1h rispetto a Londra | idem |
| `774101` GapContinuation 225JPY | 50503392 | 01:00-07:30 | 🟢 Tokyo non ha ora legale: col nuovo orologio **resta giusta** | idem |

Fonte input: `backtest_pipeline/coda/referti/CODA_08_preset_dai_chr_20260924_033003.log` (blocchi
`--- SEDIA:` sotto `BCM Markets MT5 Terminal` = 50503392, `... -V3` = 50504263, `BCM_Reale` =
10105439).
📌 **Nota che conta**: sulle sedie BCM l'inverno **ripete il backtest** (anche lui era sfasato), ma
**non l'intenzione** (l'apertura cash). Sulle FTMO e' il contrario (§5.3).

### 5.3 c) FTMO (conto **541452707**, `C:\FTMO`)

- ✅ **Si', i preset FTMO sono derivati con +2**: `backtest_pipeline/rimappa_preset_ftmo.py` r.8
  `DELTA=2`, r.164 `nv=(v+DELTA)%24`. In campo: DAX `InpSessionHour=10`, Dow e Nasdaq `16:30`,
  MaxMin box 01-06:59 / place 09:59 / cutoff 10:30, Guardian reset `1` (`CODA_08`, blocco `C:\FTMO`).
- 🟢 **Le ORE dei preset restano giuste d'inverno** *se* FTMO segue l'ora legale **europea**
  (`docs/REGOLAMENTO_FTMO_2026-08.md` r.130: GMT+2/+3 = ora italiana +1): 10:00 FTMO = 09:00 IT =
  Xetra tutto l'anno; 16:30 FTMO = 15:30 IT = Wall Street tutto l'anno.
- 🔴 **Ma la frase nei preset e' falsa**: `ABTG_Dow_Apertura_US_770202_FTMO.set` r.49-52 (e i gemelli
  DAX r.42-45, Nasdaq r.34-37) dicono *"Se FTMO e BCM cambiano nello STESSO giorno il delta resta
  +2"*. **BCM non cambia**: d'inverno **FTMO = BCM + 1**. Innocuo per le ore gia' scritte, **pericoloso
  per chi rimappa d'inverno leggendo l'ora del BCM vivo**: `DELTA=2` vale solo per preset BCM con
  semantica "ora italiana −1".
- 🔴 **E il punto grosso**: d'inverno le sedie FTMO armeranno **all'apertura cash**, mentre il loro
  backtest d'inverno armava **un'ora prima**. Per `770202` i mesi "come il campo" hanno PF **0,78**
  (§5.1.1). **Il contratto di queste sedie non descrive quello che faranno da fine ottobre.**
- 🟠 **La settimana 26/10-30/10/2026 resta [NON MISURATA]**: se FTMO segue il calendario europeo,
  Dow e Nasdaq armano alle **10:30 NY** (1h tardi) per cinque sedute; se segue quello americano,
  DAX e MaxMin armano **1h presto** e il Guardian azzera alle 23:00 IT. Una delle due coppie sbaglia
  comunque. Gia' segnalato nei preset (r.53-57), qui ne diventa certo **l'esito**, non il calendario.
- 🟠 **Griglia H4 del Dow** (`InpUseEmaFilter=true`, H4): d'inverno BCM e FTMO distano 1h invece di
  2h. Resta diversa dal backtest.

### 5.4 d) Guardian e reset giornalieri

| dove | input | d'estate | dal 26/10/2026 |
|---|---|---|---|
| Guardian `779001` su **50504263** | `InpDailyResetHour=23` | 23 BCM = **00:00 IT** | 🔴 23 BCM = **23:00 IT**: azzera 1h prima di mezzanotte |
| Guardian `779002` su **10105439** | `InpDailyResetHour=23` | 00:00 IT | 🔴 23:00 IT *(conto reale: decisione di Claudio)* |
| Guardian `779001` su **FTMO 541452707** | `InpDailyResetHour=1` | 01 FTMO = 00:00 IT | 🟢 00:00 IT **se** FTMO segue il calendario europeo |

Il **reset 23** firmato il 18/08 era "mezzanotte italiana" **solo sotto la vecchia regola**.

---

## 6. ✋ La conferma a costo zero (sola lettura, nessun ordine, nessun EA toccato)

🪟 **Terminale: conto `50503392`**, cartella programma **`C:\Program Files\BCM Markets MT5 Terminal`**
(il piccolo). **Non** il `-V3` (50504263), **non** `C:\BCM_Reale` (**10105439**), **non** `C:\FTMO`
(541452707), **non** `C:\MT5_Backtest` (50504400). Si aprono solo grafici: nessun EA, nessun ordine.

Per riconoscere la finestra, **bozza da passare al cancello** (non ancora verificata, non mandare):
🖥️ *finestra PowerShell sul VPS, sola lettura, non tocca nessun terminale*:
```
Get-Process terminal64 | select Id, MainWindowTitle, Path
```

### 6.1 La conferma (due domeniche, cinque minuti)
Grafico **EURJPY M1**, ore del grafico = ora server:
| domenica | vecchio orologio | nuovo orologio |
|---|---|---|
| **07/01/2024** | prima barra **22:05-22:10** | 23:05 |
| **11/01/2026** | 22:05-22:10 | prima barra **23:05** |

Controprova sugli eventi (non sulle sessioni): **USDJPY M1**, la barra piu' lunga del giorno
- **12/03/2024** (CPI): attesa **12:30** · **12/02/2025** (CPI): attesa **14:30** · **09/01/2026**
  (NFP): attesa **14:30**. Col vecchio orologio le ultime due sarebbero alle 13:30.

### 6.2 La data al giorno (dieci minuti)
Stesso grafico EURJPY M1, prime barre delle domeniche **05/01, 12/01, 19/01, 26/01/2025**
(22:0x = vecchio, 23:0x = nuovo) e la barra del NFP di **venerdi' 10/01/2025** (13:30 = vecchio,
14:30 = nuovo). La prima domenica alle 23:0x **e'** la data del cambio.

### 6.3 La conferma dal vivo, da mettere in calendario: **lunedi' 26/10/2026**
Sul terminale **50503392**: ora dell'ultima candela M1 contro l'orologio di Windows (ora italiana).
Oggi differiscono di 1h. **Se il 26/10 coincidono, BCM e' UTC+1 fisso anche dal vivo** e §5.2
diventa realta' quel giorno stesso. (Attenzione alla regola di casa: i log di Esperti/Giornale sono
in ora **locale**, il grafico in ora **server**.)

🔎 **Giornali MT5 del forward nov 2025 - mar 2026: non esistono nel repo.** Gli estratti conto
partono dal 30/03/2026 (`data/statements/trades_auto.csv`, primo affare 2026.03.30 07:08) e il
`ReportHistory50503392.xlsx` copre 20-22/07/2026. **[NON DISPONIBILE]**: la riga "ora grafico
contro ora locale" d'inverno non c'e'. La §6.3 la produce il 26/10.

---

## 7. 🔁 Che cosa ne esce (proposte, NESSUNA eseguita)

1. 📝 **La regola "FUSO ORARIO BCM" di `CLAUDE.md` va riscritta** (non toccata qui): *"BCM = UTC+1
   fisso dal cambio (fra il 27/12/2024 e il 02/02/2025): ora italiana −1 d'estate, ora italiana
   d'inverno. DAX 08:00 server d'estate, **09:00** d'inverno; Nasdaq 14:30 d'estate, **15:30**
   d'inverno (e 14:30 nelle settimane sfasate di marzo e ottobre-novembre)"*. Stessa correzione al
   controllo rapido dei CSV (`InpSessionHour` 8/14 non e' piu' un test valido d'inverno).
2. ⏰ **Decisione di Claudio, con scadenza 25/10/2026**: che cosa fanno d'inverno le sedie BCM
   orarie di §5.2 (lasciarle "come il backtest" o riportarle all'apertura cash). Sono **parametri**:
   non si toccano senza firma.
3. 🔁 **"SE POTREBBE PASSARE, SI INSISTE" — la pista**: in tre celle d'apertura su tre (DAX, Dow,
   Nasdaq R84) i mesi con **range sul pre-mercato e ingresso all'apertura** hanno PF migliore. Non e'
   dimostrato che sia l'orologio (§5.1.3), ma e' **misurabile**: una corsa d'**estate** con
   `InpSessionHour` spostato di −1h (DAX 07:00, USA 13:30) replica la tempistica invernale su mesi
   diversi. Round da **PC di backtest**, da dichiarare prima come regola di selezione, e da passare ai
   cancelli. Se reggesse, e' una cella nuova; se no, il contratto d'inverno va ricalcolato **solo sui
   mesi allineati**.
4. 🧮 **Il Monte Carlo FTMO** (`mc_challenge_ftmo.py`) oggi campiona anche i mesi sfasati: una sua
   variante coi soli mesi allineati per `770101`/`770202`/`770411` dice quanto vale la rosa **come
   girera' d'inverno**. Costo: zero macchina, solo repo.
5. 🩹 **R214EF**: il confine FTMO in ora BCM va scritto come calendario (23 d'estate e col vecchio
   orologio, 00 negli inverni dopo il cambio), con la forchetta di §3.1.

---

## 8. 📚 Come rifare la misura (sola lettura, ~1 minuto)

Tutti i `.csv` del repo fuori da `.claude/` con intestazione `;` che contiene `symbol` e
`close_time`/`open_time`; si tiene ogni affare unico per `(ora, simbolo, prezzo)`; forex = coppie di
valute (EUR, USD, JPY, GBP, CHF, AUD, NZD, CAD), indici = `U30USD`/`NASUSD`/`SPXUSD`/`D30EUR`.
Calendari: ora legale USA = 2ª domenica di marzo → 1ª di novembre; UE = ultima domenica di marzo →
ultima di ottobre. Poi si contano gli affari lun-ven nelle finestre di §2.1 e il minimo di ogni
domenica (§2.2). Nessun numero di questo referto viene da una stima: sono conteggi.

**Limiti dichiarati**: gli affari sono **uscite** (e le entrate degli estratti conto), non tick: il
primo affare di una domenica e' un **tetto** all'ora d'apertura, non l'apertura; per questo le
decisioni poggiano sugli stop in gap multi-simbolo e sui conteggi, non sui singoli affari. Gennaio
2025 e' **scoperto**. Lo storico indici prima del 2024.09.26 non esiste nel nativo BCM.
