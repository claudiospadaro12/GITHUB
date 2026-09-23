# 🐻🐂 I LATI MANCANTI DI DAX E NASDAQ — R230

**Data**: 23/09/2026 · **Branch**: `lavoro` · **Sigla**: `R230` (grepata libera prima dell'uso,
classe 194: zero occorrenze in repo al momento della scrittura).

> 🧾 **SOLA LETTURA, ZERO MINUTI MACCHINA.** Nessun round eseguito, nessun file prova scritto,
> nessun preset/EA/sedia/VPS toccato. Claudio e' da cellulare: tutto quello che c'e' qui viene
> da file gia' in repo. Dove un numero richiede MT5, c'e' scritto **`[NON MISURATO]`**, non una
> stima.

---

## 🎯 LA RISPOSTA IN SETTE RIGHE

1. ✅ **Il censimento dei preset e' CONFERMATO**, riga per riga (§0).
2. 🟢 **Il corto spento su DAX `770101` e Dow `770202` NON e' un'abitudine: e' MISURATO**, due
   volte a testa, con round indipendenti — e sul DAX **sulla geometria IDENTICA** a quella che
   gira (verificata a macchina, campo per campo). §1 e §2.
3. 🔴 **Il corto ACCESO sul Nasdaq `770260` e' l'unico lato della rosa SENZA una misura sua.**
   Su **12 CSV** della sua geometria viva, **tutti e 12** hanno `(AllowLong, AllowShort)=(1,1)`:
   il lato non e' **mai** stato un asse li'. E' acceso **per eredita' del default**, non per un
   numero. **E' l'esatto contrario di quello che si direbbe a occhio.** §3.
4. 🪦 **Una correzione a un file di casa**: `prove/R205a_lato_corto_DAX_D30EUR.txt` (22/09)
   scrive *«il retest-short sul DAX non e' mai stato girato»*. **E' falso**: `R107` lo ha girato
   il **25/08** sulla geometria identica, a tick reali, con **n OOS 257**. §1.3.
5. 🎁 **Un lato mancante che nessuno citava**: il **LUNGO** della MaxMinNotte DAX `770411` **e'
   misurato e bocciato** — `0 celle positive su 18`, e accenderlo porta il DD da 7,3% a 15,2%.
   Il CSV era in repo da mesi, citato per altro. §4.
6. 🧪 **Il contro-esempio TIENE: «il corto sugli indici non funziona perche' salgono» e' ROTTO**,
   e si rompe in casa senza dati nuovi. Ma la conclusione giusta e' **tripartita**, non
   *«il corto e' un'assicurazione»*. §6.
7. ⚖️ **Accendere un lato su queste tre sedie NON tocca il cap C1 al 3,25%** — verificato nel
   codice, non assunto (§7). Cambia **quali** giornate si operano, non **quante** posizioni sono
   aperte insieme.

8. 🔥 **AGGIUNTA DEL MANDATO, e vale da sola il round**: l'`[INFERITO]` sul MARGINE
   **era gia' chiuso in repo dal 20/09**. La leva FTMO sugli indici e' **1:50 MISURATA**, non
   1:15 — quindi **il 140,6%, il 357,6% e il 121,9% che girano nei nostri referti sono tutti
   costruiti su un'ipotesi FALSIFICATA**, e c'e' **piu' di tre volte** lo spazio che crediamo.
   E accendere un lato costa **0,00% di margine di picco**, dimostrato nel codice. **§11**.

---

# 0️⃣ ✅ IL CENSIMENTO, VERIFICATO

Letto direttamente da `mql5/Presets/FTMO/*.set`, campi `InpAllowLong` / `InpAllowShort`:

| sedia | `InpAllowLong` | `InpAllowShort` | esito |
|---|---|---|---|
| `770101` **DAX Apertura EU** | `true` | 🔴 `false` | ✅ confermato |
| `770202` **Dow Apertura US** | `true` | 🔴 `false` | ✅ confermato |
| `770411` MaxMinNotte DAX Short | 🔴 `false` | `true` | ✅ confermato |
| `770260` **Nasdaq Apertura RETEST** | `true` | `true` | ✅ confermato |
| `771531` EMA200 · `770402` MaxMin Oro · `770511` SuperWave | `true` | `true` | ✅ confermato |

## 🔬 E la premessa della domanda va RAFFINATA, perche' cambia la risposta

*«`DAX_Apertura_EU`, `Dow_Apertura_US` e `Nasdaq_Apertura_US` sono LO STESSO MECCANISMO su tre
simboli»*: vero per l'**innesco** (`InpEntryMode=2` = `ABTG_RETEST`, `InpRangeMode=0`,
`InpRangeMinutes=35` su tutte e tre), **falso per la TARATURA**. Letto dai tre preset:

| campo | `770101` DAX | `770202` Dow | `770260` Nasdaq |
|---|---:|---:|---:|
| `InpBufferPoints` | **500** | **1000** | **200** |
| `InpRetestOffsetPts` | **200** | **400** | **0** |
| `InpUseEmaFilter` (H4) | `false` | 🔴 **`true`** | `false` |
| `InpUseGapFill` | `false` | `false` | 🔴 **`true`** |
| `InpMinStopPts` | 0 | 500 | 500 |
| `InpSkipIfTight` | `true` | `false` | *(vedi §3)* |

👉 **Tre tarature diverse, e due di queste differenze cambiano il significato del lato**:
il **filtro EMA H4 acceso solo sul Dow** e' **direzionale** — in una giornata data ammette un
lato solo. **E' la ragione per cui sul Dow i lati si sommano esatti e sul DAX no** (§2.3): non
e' un dettaglio di contabilita', e' il motivo per cui i due simboli **non si leggono con lo
stesso metro**.

---

# 1️⃣ 🇩🇪 DAX `770101` — IL LATO CORTO: **MISURATO, E BOCCIATO DUE VOLTE**

## 1.1 La misura che REGGE: `R107` (25/08/2026, tick reali)

**Perche' regge: la geometria e' IDENTICA a quella che gira.** Non l'ho dedotto, l'ho
confrontato a macchina — `prove/R107_DAX_01_short.txt` contro
`mql5/Presets/FTMO/ABTG_DAX_Apertura_EU_770101_FTMO.set`, campo per campo. **Le uniche
differenze sono quattro, e sono tutte attese:**

| campo | vivo | `R107` | perche' non e' una differenza |
|---|---|---|---|
| `InpAllowLong`/`InpAllowShort` | `true`/`false` | `0`/`1` | 🎯 **e' l'asse del round** |
| `InpMagic` | 770101 | 761110 | magic vergine, obbligatorio |
| `InpSessionHour` / `InpCloseHour` | 10 / 19 | 8 / 17 | **stesso momento di mercato**: il preset e' rimappato FTMO `= BCM + 2` |
| `InpRiskPercent` | 2,00 | 1,0 | taglia del banco. PF e `n` sono invarianti, il DD scala (classe 547) |

Dieci campi non sono pinnati in `R107` (`InpLevelTF`, `InpOCTimeframe`, `InpCorrSymbol`, i sette
`InpNews*`): prendono i default compilati, che **coincidono** col vivo (`ABTG_DEF_LEVEL_TF` =
`PERIOD_H1` = 16385, r.167-168 del sorgente) **o sono inerti** (`InpUseNewsFilter=0` e
`InpUseCorrelation=0` pinnati in `R107`).

### 📊 I numeri (`risultati_archivio/R107_REFERTO.md`, tabella madre — deposito 100.000, rischio 1%, split IS 2024.09.26→2025.06.09 · OOS 2025.06.10→2026.06.30)

| cella | IS profitto | IS PF | IS `n` | OOS profitto | OOS PF | OOS DD% | OOS `n` |
|---|---:|---:|---:|---:|---:|---:|---:|
| **DAX long (il metro)** | +3.789 | 1,397... | 175 | **+18.030** | **1,397** | 7,23 | 270 |
| 🔴 **DAX short** | **−996** | **0,965** | 138 | **−1.865** | **0,957** | **12,31** | **257** |

🚦 **Perche' questo e' un VERDETTO e non un'opinione**: `n` OOS = **257, sopra il pavimento dei
150** dell'Emendamento A. Il merito e' **misurabile**, ed e' **no**. Ed e' rosso in **tutte e
due** le finestre — compresa l'IS, che contiene la discesa feb-apr 2025.

## 1.2 La seconda misura, indipendente: `FASE M` (07/08/2026, tick reali)

`risultati_archivio/Walkforward_Aperture/DAX_M_direzione_{IS,OOS}.csv` — **4 celle di lato × 3
range**, magic 770101, deposito **10.000**, rischio 1%.
🟡 **Geometria vicina ma NON identica** (dichiarato): retest / buffer 500 / offset 200 /
range 35 = **uguali** al vivo; ma `InpUseGapFill=1` mentre il vivo ha `false`.

**Riga `InpRangeMinutes=35`, cioe' il valore che gira:**

| cella | IS `n` | IS PF | IS profitto | OOS `n` | OOS PF | **OOS RF** | OOS DD% | OOS profitto |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| solo long | 189 | 1,13119 | +394,97 | 256 | **1,42325** | **2,19287** | **6,7169** | **+1800,19** |
| solo short | 152 | 0,84559 | −501,27 | 243 | 1,06519 | 0,19989 | 12,0490 | +254,74 |
| **entrambi** | 224 | 0,99775 | −9,02 | **316** | 1,23727 | **1,03363** | **10,4865** | **+1198,79** |
| nessuno | 0 | — | 0,00 | 0 | — | — | — | 0,00 | 

✅ **Controllo di sanita' passato**: la cella `0/0` fa **zero trade** in tutti e quattro i file —
i flag mordono davvero, quindi il resto della tabella si puo' leggere.

🔴 **Accendere il corto, in OOS**: profitto **−33%** · **RF 2,193 → 1,034 (−53%)** · DD **6,72%
→ 10,49% (+56%)**. **E il DD sale MENTRE il profitto scende**: non c'e' nessuna lettura in cui
questo sia un miglioramento. E in IS il corto e' **negativo** (PF 0,846), quindi le due finestre
sono **concordi**.

📐 **E non e' un picco, e' un altopiano**: il solo-long e' positivo in **6 celle su 6**
(3 range × 2 finestre). Il referto della fase lo dice con le sue parole: *«E' un altopiano, non
un picco»*.

## 1.3 🪦 LA CORREZIONE A UN FILE DI CASA — e la classe nuova che ne esce

`backtest_pipeline/prove/R205a_lato_corto_DAX_D30EUR.txt` (scritto il 22/09, **mai eseguito** —
confermato da `report/I_FILE_FERMI_2026-09-22.md` §Caso 3) contiene questa affermazione, marcata
`[MISURATO]`:

> *«QUESTO ROUND NON E' UNA RIPETIZIONE: il retest-short sul DAX non e' mai stato girato.»*

🔴 **E' FALSA.** `R107_DAX_01_short.txt` e' **esattamente** il retest-short sul DAX, con
**esattamente** la geometria viva, girato a **tick reali il 25/08/2026** — quasi un mese prima.

**Come e' successo**: l'autore ha cercato la bocciatura **per NOME DI ROUND nel `DIARIO.md`** e
ha trovato `R42` (il FADE) e `R43` (il RIMBALZO). Ha verificato benissimo che quei sei file
pinnano `InpEntryMode=3` e non `2` — e su questo **ha ragione**. Ma **non ha cercato per
GEOMETRIA**, e la geometria giusta stava in un file prova che si chiama `R107`, non `R42`.

🟢 **Cosa di `R205a` resta in piedi, e va detto**: la sua cella *`true`* e' `long+short`
(`InpAllowLong=1`), che **non e'** la cella di `R107` (`short-only`). Quella domanda specifica
`R107` non la risponde. **Ma `FASE M` la risponde** (riga *entrambi* qui sopra), e la risposta e'
peggio del solo-long su **profitto, PF, RF e DD insieme**.

👉 **Conseguenza operativa**: `R205a` non e' piu' *«il round piu' economico della lista, chiude un
NON MISURATO travestito da gia' bocciato»* (come lo classifica `I_FILE_FERMI_2026-09-22.md`
voce 1). E' **la terza misura di una cosa gia' misurata due volte**. Scende in classifica (§8).

## ✅ VERDETTO DAX, lato corto: **BOCCIATO — e la bocciatura REGGE**
Geometria identica · `n` OOS 257 sopra il pavimento · due round indipendenti · IS e OOS concordi
· l'altopiano del solo-long positivo 6/6. **Non e' un candidato da riaprire.**

---

# 2️⃣ 🇺🇸 DOW `770202` — IL LATO CORTO: **MISURATO, E BOCCIATO CON UN ALTOPIANO**

## 2.1 `R54a` (14/08/2026, tick reali) — **e i CSV SONO in repo**

`risultati_archivio/csv_r54/ABTG_Dow_Apertura_US_U30USD_{IS,OOS}_r54a.csv` — 8 passate
(4 celle × 2 magic gemelli), deposito 100.000, rischio 1%.
Geometria: **identica** al vivo (confronto a macchina: differiscono solo l'asse, il magic, il
rischio 1% vs 2% e il rimappaggio orario FTMO).

| cella | IS `n` | IS PF | IS RF | IS DD% | IS profitto | OOS `n` | OOS PF | **OOS RF** | OOS DD% | OOS profitto |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| solo long | 74 | 1,22247 | 0,48864 | 5,6692 | +2811,84 | 130 | **1,27013** | **1,51073** | **4,3941** | **+6721,93** |
| 🔴 solo short | 73 | **1,51111** | **2,31319** | 2,6777 | **+6463,44** | 73 | **0,83968** | **−0,29574** | 8,6214 | **−2591,58** |
| entrambi | 147 | 1,37179 | 1,65419 | 5,5299 | +9461,23 | 203 | 1,09627 | 0,44101 | 8,6757 | +3926,85 |
| nessuno | 0 | — | — | — | 0,00 | 0 | — | — | — | 0,00 |

✅ Controllo d'igiene dei gemelli: le due serie `772601`/`772602` escono **identiche fino
all'ultima cifra** su tutte e quattro le celle. Il banco e' deterministico.

🔴 **Il corto e' la cella MIGLIORE in IS e la PEGGIORE in OOS.** Segni **discordi** fra le due
finestre = il cancello di coerenza G3 fallisce. E in OOS il corto **perde soldi in assoluto**
(RF **negativo**), non "rende meno".

## 2.2 La conferma su tre range: `R6` / `ptc` — **3 su 3**, CSV in repo

`risultati_prove/ABTG_Dow_Apertura_US/ABTG_Dow_Apertura_US_U30USD_{IS,OOS}_{r6,ptc}.csv`.
Stessa geometria viva, tre valori di `InpRangeMinutes`. **In OOS, accendere il corto peggiora
il Recovery Factor a TUTTI E TRE i range:**

| `InpRangeMinutes` | RF OOS solo-long → entrambi | DD% OOS → | profitto OOS → |
|---:|---|---|---|
| 25 | **2,03462 → 0,81301** | 5,2367 → **9,9244** | 11.720,93 → 8.439,48 |
| **35 (il vivo)** | **1,51073 → 0,44101** | 4,3941 → **8,6757** | 6.721,93 → 3.926,85 |
| 45 | **4,17307 → 0,74385** | 2,6547 → **7,2881** | 11.793,89 → 5.784,38 |

📐 **Questo non e' un picco: e' un altopiano di bocciatura.** Tre celle vicine, tre volte lo
stesso verso, sempre con **RF giu' e DD su insieme**.

## 2.3 🔬 UN DETTAGLIO CHE SEMBRA UN DIFETTO E INVECE E' LA SPIEGAZIONE

Sul Dow: `74 + 73 = 147` e `130 + 73 = 203` — **additivita' ESATTA**.
Sul DAX: `256 + 243 = 499` ma *entrambi* = **316** — **sotto-additivo**.

Sembrano due comportamenti incompatibili dello stesso motore. **Non lo sono, ed e' il filtro:**
- sul **Dow** `InpUseEmaFilter=1` con `InpEmaFast=1` (= il prezzo), `InpEmaSlow=50`,
  `InpFilterTF=16388` (H4): **e' direzionale**. In una giornata data **un lato solo e'
  ammesso**, quindi i due lati **non si contendono lo slot** e gli `n` si sommano esatti.
- sul **DAX** il filtro e' **spento**: tutti e due i lati possono armarsi nello stesso giorno, e
  con `InpOneTradePerDay=true` **il primo che spara consuma il posto dell'altro**.

👉 **Quindi sul Dow lo short AGGIUNGE davvero 73 operazioni perdenti; sul DAX ne aggiunge 60 e
ne RUBA 183 al lungo.** Sono due danni diversi, e vanno raccontati diversi.
🟢 E questo e' anche un **controllo di sanita' riutilizzabile**: su un asse di lato,
`n` **additivo esatto** non e' un difetto — e' la firma di un filtro direzionale a monte.
**Sub-additivo** e' la firma dello slot. **Super-additivo** sarebbe l'unico vero allarme.

## ✅ VERDETTO DOW, lato corto: **BOCCIATO — e la bocciatura REGGE**
Geometria identica · tre round (`R6`/`R54a`/`R107`, con `R107` che riproduce `R54a` al
millesimo) · altopiano 3/3 sui range · RF **negativo** in OOS.
🟡 **Con UNA riserva dichiarata**: `n` OOS = 73, **sotto il pavimento dei 150**. Per la regola
del 16/08 il **MERITO** su questa famiglia e' **SOSPESO**; il **RISCHIO** si legge a qualunque
`n`, e il rischio dice DD 4,39% → 8,68% (+97%). 👉 **La bocciatura poggia sul RISCHIO, non sul
merito** — e cosi' va citata.

---

# 3️⃣ 🇺🇸 NASDAQ `770260` — IL LATO CORTO ACCESO: 🔴 **NON ANCORA MISURATO**

## 3.1 La misura a macchina, e non lascia spazio

Ho scansionato **tutti** i CSV del repo che portano insieme `InpAllowShort` e
`InpRetestOffsetPts` e riguardano `NASUSD`, raggruppando per la **geometria** della sedia viva:

> `InpEntryMode=2` · `InpBufferPoints=200` · `InpRetestOffsetPts=0` · `InpRangeMinutes=35` ·
> `InpUseGapFill=1` · `InpUseEmaFilter=0`

**Risultato: 12 CSV** — `ABTG_Nasdaq_Apertura_US_NASUSD_{IS,OOS}_{R196A, R198, R199A, R199B,
R200A, R200C, R200E}` e `Walkforward_Aperture/NASDAQ_B_motore_{IS,OOS}.csv` — e
**TUTTI E DODICI portano `(InpAllowLong, InpAllowShort) = (1, 1)` e nient'altro.**

👉 **Sulla geometria che gira oggi sul conto della challenge, il LATO non e' MAI stato un asse.**
Il corto della `770260` e' acceso perche' il sorgente ha
`ABTG_Nasdaq_Apertura_US.mq5` con default `true`, e **nessun round l'ha mai spento per
confronto**. Verificato anche sulla fonte della cella: la riga `Pass=8` di
`NASDAQ_B_motore_{IS,OOS}.csv` (da cui nasce il preset, come dichiara la sua intestazione) ha
`InpAllowLong=1, InpAllowShort=1` **senza asse**.

> 🔴 **Ed e' l'esatto contrario di quello che si direbbe a occhio.** Sul DAX e sul Dow lo
> **spegnimento** del corto e' MISURATO. Sul Nasdaq l'**accensione** non lo e'. L'unica sedia
> della rosa che opera **su tutti e due i lati** e' quella che ha **meno** giustificazione
> misurata per il lato che le abbiamo lasciato.

## 3.2 La misura piu' vicina che esiste — e va letta come PRIOR, non come verdetto

`Walkforward_Aperture/NASDAQ_M_direzione_{IS,OOS}.csv` (FASE M, 07/08/2026, tick reali,
magic 770201, deposito 10.000, rischio 1%). 🟡 **Geometria DIVERSA**: buffer **500** e offset
**200**, contro i **200** e **0** del vivo. Riga `InpRangeMinutes=35`:

| cella | IS `n` | IS PF | IS profitto | OOS `n` | OOS PF | **OOS RF** | OOS DD% | OOS profitto |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| solo long | 156 | 0,96316 | −105,58 | 196 | **1,12953** | **0,69500** | **4,8977** | **+342,32** |
| solo short | 142 | **1,16526** | **+404,12** | 197 | 0,82293 | **−0,74873** | 9,0971 | **−694,01** |
| **entrambi** | 220 | 0,92822 | −261,87 | **301** | 1,02233 | **0,12466** | 7,8775 | +107,19 |

🔴 Accendere il corto, in OOS: **RF 0,695 → 0,125** · DD **4,90% → 7,88%** · profitto
**342 → 107**. Stesso verso del DAX e del Dow.
⚠️ **MA la geometria non e' quella viva, quindi questo NON boccia la `770260`.** E' un **prior
direzionale**, e cosi' va citato. Lo dice anche il referto della fase, che chiudeva il Nasdaq
d'apertura come ricerca — salvo poi che la sedia viva **nasce da una geometria trovata dopo**
(`R199B`) e su quella nessuno ha rifatto la domanda del lato.

## 3.3 🔴 «Il corto acceso ha mai prodotto in forward?» — **`[NON MISURATO]`**, e dico perche'

- Il magic `770260` **non compare** ne' in `data/statements/trades_auto.csv` (1.333 righe, fino
  al **22/09/2026 20:37**) ne' in `data/statements/trades_100k.csv` (36 righe): sono statement
  **BCM**, e la `770260` vive sul terminale **FTMO `541452707`** (`C:\FTMO`).
- Il per-trade FTMO **esiste** (`ABTG_Trades_FTMO.csv`, scritto il 23/09 alle 03:27) ma
  **contiene 2 posizioni chiuse in tutto** e **non e' mai stato pubblicato in repo**:
  `data/statements/trades_ftmo.csv` non e' mai esistito (fonte:
  `report/IL_PERTRADE_FTMO_ESISTE_2026-09-23.md`, punti 2 e 4).
👉 **Per sapere se il corto della `770260` ha mai sparato serve una riga di lettura sul VPS.**
Oggi non si puo' fare (zero minuti macchina), e **non lo stimo**.

🟢 **Quello che INVECE ho potuto misurare, ed e' l'informazione gemella**: sulla `770101`, in 39
operazioni forward su `D30EUR` (`trades_auto.csv`, 20/07 → 22/09), **nessuna delle 9 `sell` porta
l'etichetta `RETEST`** — sono tutte `DAX Apertura EU SELL`, e l'ultima e' del **13/08**. Dal
21/08 in poi ogni riga e' `DAX Apertura EU RETEST BUY`. 👉 **La geometria retest non ha MAI
prodotto un corto in forward**, su nessun conto. Coerente col preset, e utile saperlo.

---

# 4️⃣ 🎁 MAXMINNOTTE DAX `770411` — IL LATO LUNGO: **MISURATO E BOCCIATO**, e nessuno lo citava

Il lato spento di questa sedia e' il **LUNGO**, ed e' il piu' facile da dare per scontato
("l'EA si chiama `_DAX_Short`"). **Invece un numero c'e', ed e' in repo da mesi.**

`risultati_archivio/MaxMinNotte/080957cf-valid_MaxMin_D30EUR.csv` — **72 passate**, magic
770401, rischio 1%, correlazione **OFF**, finestra di **911 giorni** (la base usata da
`report/R187_...` §4). Quattro celle di lato × 18 combinazioni (`InpBufferPoints` × `InpTP2_R`):

| cella | celle positive | la migliore |
|---|---:|---|
| 🟢 **solo short** | **17 / 18** | buf **1000** · `TP2_R` **3,0** → `n` 107 · PF **1,18742** · RF **0,86511** · DD **7,2851%** · **+630,26** |
| 🔴 **solo long** | **0 / 18** | buf 500 · `TP2_R` 1,5 → `n` 173 · PF **0,94712** · RF **−0,26397** · DD 10,3101% · **−290,93** |
| 🔴 **entrambi** | **0 / 18** | buf 500 · `TP2_R` 1,5 → `n` 286 · PF 0,99179 · RF −0,04245 · DD **15,1948%** · −73,53 |
| ⚪ nessuno | 0 trade / 18 | ✅ controllo di sanita': i flag mordono |

🎯 **E la cella migliore del solo-short e' `buffer 1000` + `TP2_R 3,0` — esattamente i due valori
del preset vivo.** Non e' una coincidenza fortunata: e' la conferma che la sedia sta al centro
del suo altopiano su quei due assi.

🟡 **LA RISERVA, dichiarata**: il preset vivo ha `InpAtrSLmult=2,5` e `InpUseCorrelation=true`;
questo CSV gira a **1,5** e **corr OFF**. **La geometria oraria invece coincide esattamente** —
verificato campo per campo contro `ABTG_MaxMinNotte_DAX_Short_770411_FTMO.set` riportato in ora
BCM: box **23:00 → 04:59**, piazza **07:59**, cutoff **08:30**, flat **17:30**, `InpSLMode=1`,
`InpMgmtTF=15`, `InpTP1_R=1`, `InpTP1Pct=50`, `InpBreakeven`, `InpTP2Pct=50`,
`InpTPfinal_R=4`, `InpTrailAtrMult=2`, `InpUseEMA200Target`, `InpOneTradePerDay`,
`InpPendingExpiryMin=90`.

## ✅ VERDETTO `770411`, lato lungo: **BOCCIATO nella sostanza, NON ANCORA sulla cella esatta**
18 celle su 18 negative da solo, 18 su 18 negative anche insieme al corto, e il DD che
**raddoppia** (7,29% → 15,19%). Per essere una bocciatura **sulla cella viva** mancherebbe la
ripetizione a `InpAtrSLmult=2,5` con `InpUseCorrelation=true`: **4 passate** (§8, voce 3).

---

# 5️⃣ 🐂 I LATI **ACCESI** RILETTI — e sul Dow c'e' il numero piu' importante del dossier

La regola del 25/08 chiede di ritestare anche i lati vivi. Sulla `771531` il numero esiste ed e'
grosso — `R110` (26/08/2026, tick reali, `risultati_archivio/R110_REFERTO.md`), riprodotto al
centesimo da `R112`:

| `ABTG_EMA200` `771531` · U30USD | `n` OOS | PF OOS | DD OOS | PF IS |
|---|---:|---:|---:|---:|
| 🐻 **lato SHORT** | **302** | **1,891** | **2,66%** | 1,232 |
| 🐂 lato LONG | 241 | 1,241 | 8,90% | 1,16 |

👉 `n` **302**, sopra il pavimento dei 150. IS **e** OOS verdi. DD **un terzo** di quello del
lungo. **Su questa finestra, quasi tutto l'edge dell'EMA200 Dow sta nel lato CORTO** — nello
stesso toro in cui il corto delle aperture perde.
🔴 **Ma la `771531` non si tocca**: `R110` §G5 dice che il cambio di contratto e' un round con
la sua firma, e `R112` ha gia' misurato i dial 1/2/3% contro il cancello di portafoglio —
nessuno passa.
🟡 LIMITE: di `R110` solo il CSV `EMADOW` e' archiviato in repo; gli altri tre hanno il referto e
non i dati grezzi (dichiarato nel censimento del 09/09).

---

# 6️⃣ 🧪 IL CONTRO-ESEMPIO — **«il corto non funziona perche' gli indici salgono» e' ROTTO**

**La conclusione facile sarebbe questa.** Se fosse vera, il corto dovrebbe perdere su **tutti e
tre** i simboli e in **tutte** le epoche. Ho provato a romperla, e si rompe **in casa, senza un
solo dato nuovo:**

### 🔨 Rottura 1 — stesso simbolo, stessa epoca, esito OPPOSTO a seconda del MOTORE
Sul **Dow**, negli **stessi** 21 mesi di toro:
- apertura-retest (`770202`): corto OOS PF **0,840**, RF **−0,296** → **perde**
- EMA200 H1 (`771531`): corto OOS PF **1,891** su `n` **302**, DD 2,66% → **vince, e batte il
  suo stesso lungo**

👉 *«Gli indici salgono»* **non spiega** perche' lo stesso indice, nello stesso anno, paghi il
corto di un motore e non dell'altro. **Non e' il lato: e' il motore.**

### 🔨 Rottura 2 — su un simbolo, il corto e' l'UNICO lato che funziona
`MaxMinNotte` su `D30EUR`: short **17/18** celle positive, long **0/18**. Su un DAX che sale.

### 🔨 Rottura 3 — il verso IS→OOS dice "regime", non "lato"
Il corto delle aperture e' **positivo** nella finestra che contiene la discesa **feb-apr 2025** e
**negativo** in quella che non ce l'ha:

| motore · simbolo | PF IS | PF OOS | fonte |
|---|---:|---:|---|
| Dow apertura | **1,511** | 0,840 | `csv_r54` (CSV in repo) |
| Nasdaq apertura (geom. Dow) | **3,220** | 0,460 | `R107_REFERTO.md` |
| Nasdaq apertura (geom. FASE M) | **1,165** | 0,823 | `NASDAQ_M_direzione_*.csv` |

👉 Per **due simboli su tre** il disegno e' quello dell'**assicurazione pagata in un solo
regime** — che, come dice il mandato, e' una conclusione **molto** diversa da "il corto non
funziona".

### 🔴 MA IL DAX E' L'ECCEZIONE, E VA DETTA PERCHE' COSTA
Il corto del **DAX** in apertura e' rosso **anche in IS**, cioe' **anche con la discesa dentro**:
PF **0,965** (`R107`) e **0,846** (`FASE M`). 👉 Per il DAX non e' "assicurazione cara": e'
**"assicurazione che non paga nemmeno quando l'incendio c'e'"**.

## 🎯 LA CONCLUSIONE ONESTA E' **TRIPARTITA**, non binaria
1. **DAX apertura** — il corto e' **bocciato anche nel suo regime favorevole**. ✅ `[MISURATO]`
2. **Dow / Nasdaq apertura** — il corto e' **plausibilmente** un'assicurazione di regime.
   🟡 `[INFERITO]`: nessun round ha mai isolato il sotto-periodo.
3. **EMA200 Dow e MaxMinNotte DAX** — il corto e' **l'edge principale**. ✅ `[MISURATO]`

## ⚠️ IL LIMITE DEI DATI, che non si aggira
I tick BCM sugli indici partono dal **2024.09.26**, e lo stato della sonda del 17/08 su tutti e
12 gli indici e' **`COMPLETO`**: **il broker non ha il resto**, non e' un buco del nostro disco.
**ORSO 2022 e CROLLO 2020 non esistono**; gli 8 simboli `_EXT` importati dal 2018 sono **tutti
forex e oro, nessun indice**. 👉 **La prova di regime dell'Emendamento C NON e' eseguibile sugli
indici**, e non lo sara' finche' lo storico resta questo.

🟢 **Ma una discesa vera sta dentro i 21 mesi, ed e' gia' nominata in casa**:
**2025.02.01 → 2025.04.30** (`R107_CRITERI.md` r.246). E **quattro file prova che misurano LATO ×
REGIME su quella finestra esistono dal 09/09 e non sono MAI stati lanciati**:
`prove/LATI_A1_EMA200_U30USD_DISCESA_{long,short}.txt` · `prove/LATI_A2_EMA200_U30USD_TORO_{long,short}.txt`.
**8 passate.** Sono il modo piu' economico che il progetto abbia di trasformare l'`[INFERITO]`
del punto 2 in un misurato.

---

# 7️⃣ ⚖️ IL RISCHIO DI PORTAFOGLIO — accendere un lato **NON tocca il cap C1**

Verificato **nel codice**, non assunto:

- `mql5/Experts/ABTG_Dow_Apertura_US.mq5` r.695-697 e
  `mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5` r.792-794:
  `case PH_PLACED: case PH_DONE: break;` — e **`InpAllowReverse` non esiste proprio** in questi
  due EA (0 occorrenze). Piazzato il primo LIMIT, **la giornata e' finita**.
- `mql5/Experts/ABTG_DAX_Apertura_EU.mq5` r.893-900: in `PH_PLACED` si chiama **solo**
  `MonitorReverse()`, che con `InpAllowReverse=false` (il valore vivo del preset) ritorna subito.
- `InpOneTradePerDay=true` e' pinnato su tutte e quattro le sedie considerate.

👉 **Su `770101`, `770202` e `770260` i due lati NON possono essere aperti insieme.** Accendere o
spegnere un lato cambia **quali** giornate si operano, **non quante posizioni sono vive
contemporaneamente**. 🟢 **Il cap C1 al 3,25% di rischio aperto non e' toccato da quest'asse.**
Lo stesso vale per `770411` (`InpOneTradePerDay=true`).

🔴 **Cio' che INVECE cambia e' il DRAWDOWN della singola sedia**, e i numeri sono nelle tabelle
sopra: DAX 6,72% → 10,49% · Dow 4,39% → 8,68% · Nasdaq (geom. FASE M) 4,90% → 7,88% ·
MaxMin 7,29% → 15,19%. **Tutti a rischio 1%: a taglia 2,00% vanno raddoppiati**, e il raddoppio
e' un **limite superiore**, non un'identita' (classe 547).

---

# 8️⃣ 🏁 LA CLASSIFICA DI COSA MISURARE — col cancello scritto PRIMA

> 🔴 **QUESTA CLASSIFICA E' ORDINATA PER SOLO MERITO.** L'ordine **definitivo**, che tiene
> conto del **margine occupato**, sta in **§11.7** e **non coincide**: li' la voce n.1 non e' un
> lato, e i corti di DAX e Dow scendono all'ultimo posto con un secondo motivo oltre al merito.

> 🚫 Questi sono round **descritti**, non file prova scritti: il mandato di oggi non li include e
> non voglio consegnare un file di cui non ho potuto far girare `controlla_prova.py` su una
> geometria che non ho ricontrollato due volte.

### 🥇 1. IL CORTO DELLA `770260` SULLA **SUA** GEOMETRIA — **4 passate** (2 celle × 2 finestre)
**Perche' e' primo**: e' l'unico lato **acceso su una sedia che opera adesso** senza una misura
sua, ed e' l'unica casella della rosa dove *«non e' misurato»* e *«sta sui soldi»* coincidono.
- **Asse unico**: `InpAllowShort` `1 → 0` (cella di merito = **solo-long**). Tutto il resto
  pinnato da `mql5/Presets/ABTG_Nasdaq_Apertura_US_RETEST_770260.set` (versione **BCM**: 14:30 /
  17:30, **non** la rimappata FTMO). `NASUSD` M5, `2024.09.26 → 2026.06.30`,
  `@FRAZIONEIS 0.40`, **tick reali**, magic **vergine**.
- 🔴 **ATTESA, prima dei numeri**: `n` **DEVE SCENDERE** spegnendo il corto. Su un asse di lato
  `n` identico vuol dire che **la manopola non e' arrivata al motore** — e' l'opposto di un asse
  d'uscita. **Ancora di riproduzione**: la riga `Pass=8` di `NASDAQ_B_motore_{IS,OOS}.csv`,
  cella *entrambi* — IS `n` **91** PF **1,14498** DD **5,9528%** · OOS `n` **94** PF **1,10936**
  DD **3,6753%**. Se non riproduce, il round non e' confrontabile e si cerca il pin che balla.
  ⚠️ Riserva gia' agli atti: quel CSV viene da un binario **precedente** al fix di sizing
  `3af47ed9` — **PF e `n` reggono** (invarianti alla scala del lotto), **DD e profitto no**.
- 🚦 **CANCELLO, congelato adesso**: si spegne il corto **solo se** solo-long fa
  `PF OOS ≥` entrambi **E** `RF OOS ≥` entrambi **E** `DD` non peggiora. **Se il solo-long e'
  peggio sul RF, il corto resta acceso — e per la prima volta ha una ragione misurata.**
- ✋ **E la decisione di cambiare un lato su una sedia che opera e' FIRMA DI CLAUDIO**, non mia.

### 🥈 2. `LATI_A1` / `LATI_A2` EMA200 Dow — **8 passate, file gia' scritti e gatati dal 09/09**
Costo stimato agli atti: **~3 minuti**. Zero preparazione.
Trasformano il punto 2 della conclusione tripartita (§6) da `[INFERITO]` a misurato: e' la
**prova di robustezza di regime piu' vicina** che il progetto possa avere sugli indici.
- 🚦 **Cancello, gia' congelato nei file**: devono riprodurre i bersagli `R110`
  (`+5.670,52 / PF 1,24103 / DD 8,8973% / n 241` per il long puro ·
  `+23.321,47 / PF 1,52365 / DD 7,8323% / n 517` per long+short).
- ⚠️ E si dice cosa **non** sono: una discesa di 60 giorni **non** e' l'Emendamento C.
  Chiamarla cosi' sarebbe barare.

### 🥉 3. IL LUNGO DELLA `770411` ALLA TARATURA **VIVA** — **4 passate**
Chiude l'unica riserva sull'unica bocciatura di lato che non e' sulla cella esatta: le 4 celle di
lato con `InpAtrSLmult=2,5` e `InpUseCorrelation=true` (e non 1,5 / OFF).
- 🚦 **Cancello**: il lungo entra **solo se** la cella *entrambi* fa `RF ≥` solo-short **E**
  `DD ≤`. **Attesa dichiarata: NON PASSA** — base storica 0/18 celle positive, e il DD raddoppia.
- 💡 Il valore vero non e' "accendere il lungo": e' **chiudere il certificato della `770411`**,
  che oggi ha la voce *«simboli/lati gemelli»* aperta.

### 4️⃣ `R205a` — **declassato, non cancellato**
Da *«il round piu' economico della lista, chiude un NON MISURATO»* a **«terza misura di una cosa
gia' misurata due volte»**. Se si gira, si gira per **due** ragioni residue e vere:
1. e' l'unica corsa che userebbe il **deposito 80.000** — e per la **classe 604** i DD di `R107`
   (100.000) e di `FASE M` (10.000) **non si trasportano**;
2. misurerebbe `long+short` con **`InpUseGapFill=false`**, che `FASE M` non ha.
🔴 **E prima di girarlo va corretta la sua intestazione**, che contiene un'affermazione falsa
marcata `[MISURATO]`. Un file prova che mente nella motivazione e' peggio di un file assente:
chi lo legge fra un mese si fida.

### 5️⃣ IL CORTO DI DAX E DOW — **NON si rigira**
Geometria identica, `n` OOS 257 sul DAX, altopiano 3/3 sul Dow, due round indipendenti a testa,
DD che peggiora sempre. Rigirarlo sarebbe *«un'altra griglia sui parametri d'ingresso di un
motore gia' dichiarato senza edge su quel lato»* = **picchi di rumore** (regola del 19/08).
🟢 La strada permessa resta l'altra: **meccanismi diversi sulla stessa inefficienza**, e uno
l'abbiamo gia' in casa e funziona — l'EMA200 sul Dow.

---

# 9️⃣ 📌 DUE CLASSI NUOVE — **da riportare in `CHECKLIST_RIGA_DI_LANCIO.md`**

> 🔴 **Perche' NON le ho scritte io nel file**: al momento di consegnare,
> `git status` mostra `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md` **modificato e non
> committato da un altro agente** (33 righe aggiunte, nessuna intestazione `## CLASSE` nuova).
> Scriverci dentro e committarlo significherebbe **portarmi via il lavoro di un collega ancora in
> corso — che e' esattamente la classe 599.** Le lascio qui, pronte da incollare.
> **Numeri grepati al momento della scrittura** (`^## CLASSE [0-9]+`, copia di lavoro): il
> massimo e' **612**, quindi **613** e **614**.

### CLASSE 613 — 🔎🪦 CERCARE UNA BOCCIATURA **PER NOME DI ROUND** INVECE CHE **PER GEOMETRIA**: si "scopre" un NON MISURATO che era misurato da un mese (23/09/2026, figlia del certificato di morte del 09/09)
**Il caso reale**: `prove/R205a_lato_corto_DAX_D30EUR.txt` (22/09) dichiara, marcandolo
`[MISURATO]`, che *«il retest-short sul DAX non e' mai stato girato»*, dopo aver aperto e
verificato i sei file prova di `R42`/`R43` e constatato che pinnano tutti
`InpEntryMode=3` (`RANGE_FADE`) e nessuno `2` (`RETEST`). **Quella verifica e' impeccabile e la
conclusione e' comunque falsa**: `prove/R107_DAX_01_short.txt` aveva girato **esattamente** il
retest-short sul DAX il **25/08**, a tick reali, con `n` OOS **257**, ed era **in repo**.
🔴 **La causa**: la ricerca e' passata dal `DIARIO.md` e dai **nomi dei round**. Un round si
chiama `R107` e parla di DAX-short: nessuna stringa lo lega a *«fade»* o a *«R205»*.
### ✅ La regola
1. 🔎 **Una bocciatura si cerca per GEOMETRIA, non per nome.** Si prendono i 5-8 campi che
   definiscono il mestiere (`InpEntryMode`, `InpRangeMode`, `InpBufferPoints`,
   `InpRetestOffsetPts`, `InpRangeMinutes`, il filtro direzionale) e si **scansionano tutti i CSV
   e tutti i file prova** cercando quella combinazione. Sono venti righe di Python e chiude la
   domanda in modo **esaustivo**, non aneddotico.
2. 🧪 **E il contro-esempio da costruire e' il suo opposto**: non *«trovo un round che parla del
   mio tema?»* ma **«esiste in repo una riga con la MIA geometria e un asse sul MIO input?»**.
   La prima domanda si puo' rispondere di no per stanchezza; la seconda no.
3. 🛑 **Vale in tutte e due le direzioni**: la stessa scansione impedisce di **riaprire** un
   candidato gia' morto **e** di **archiviare** un candidato mai misurato.

### CLASSE 614 — 🔢⚖️ SU UN ASSE DI **LATO**, L'ADDITIVITA' DI `n` E' UNA **DIAGNOSI**, NON UN CONTROLLO DI SANITA': esatta, sotto-additiva e super-additiva vogliono dire tre cose diverse (23/09/2026)
**Il caso reale**: stesso motore d'apertura, stessa finestra, due simboli.
Dow (`csv_r54`): `74 + 73 = 147` e `130 + 73 = 203` — **additivita' esatta**.
DAX (`DAX_M_direzione_*`): `256 + 243 = 499` ma *entrambi* fa **316** — **sotto-additivo**.
Sembra che uno dei due file sia sbagliato. **Non lo e'**: sul Dow `InpUseEmaFilter=1` su H4 e'
**direzionale** e ammette un lato solo per giornata, quindi i lati **non si contendono lo slot**;
sul DAX il filtro e' spento e `InpOneTradePerDay=true` fa si' che **il primo che spara consuma il
posto dell'altro**.
### ✅ La regola
- ✅ **`n` esattamente additivo** → c'e' un **filtro direzionale a monte**. Va **nominato** prima
  di leggere i PF, perche' vuol dire che il lato aggiunge operazioni **senza toglierne**.
- 🟠 **`n` sotto-additivo** → morde uno **slot** (`InpOneTradePerDay`, `return` dopo il primo
  lato, `PH_PLACED`). Il lato in piu' **ruba** operazioni all'altro: **i due lati separati non si
  sommano**, e chi li somma si illude.
- 🔴 **`n` super-additivo** → **l'unico vero allarme**: significa che accendere un lato ha
  **cambiato qualcos'altro** (un tetto di posizioni, un reverse, un filtro). Il round non ha
  misurato il lato.
- 🔴 E resta la regola madre: **se `n` NON CAMBIA, la manopola non e' arrivata al motore.** E'
  l'**opposto** di un asse d'uscita, dove `n` identico e' il controllo di sanita' che si vuole.

---

# 🔟 🕳️ COSA NON HO COPERTO — **elencato per nome**, mai "tutto il resto"

1. **`ABTG_Trades_FTMO.csv`** — il forward vero delle sei sedie della challenge. Non e' in repo
   (`data/statements/trades_ftmo.csv` non e' mai esistito). **Non so se il corto della `770260`
   abbia mai sparato**, e non lo stimo.
2. **I CSV di `R107`** — **non esistono in repo**: `find` su `*r107*` e `*761*` torna solo file
   prova, la riga di lancio e i tre referti. I numeri DAX/Dow/NAS short di `R107` li ho letti
   **dal referto**, non dai dati grezzi. 🟢 **Attenuante misurata, e l'ho cercata apposta**: la
   riga Dow di `R107` dichiara di riprodurre `R54a`, i cui CSV **sono** in repo e li ho aperti —
   **`PF 0,83968` / `DD 8,6214` / `n 73` contro il «0,840 / 8,62 / 73» del referto.
   L'unica riga verificabile torna.** Le righe DAX e NAS restano non verificabili da qui.
3. **`ABTG_SuperWave_DOW_H1` `770511`** e **`ABTG_MaxMinNotte_ORO` `770402`** — ho letto il loro
   lato dai preset (entrambi accesi) ma **non ho fatto per loro la scansione per geometria** che
   ho fatto per DAX/Dow/Nasdaq. Non c'e' un lato spento da giustificare, ma la rilettura chiesta
   dalla regola del 25/08 **io l'ho fatta solo per l'`EMA200`**.
4. **La peggior giornata (classe 618)** — la colonna `Peggior Giornata %` dell'OPTFRAME **c'e'
   solo nei CSV di `R54a`** (li' sta fra **−1,00%** e **−1,06%** a rischio 1%). Nei CSV di
   `FASE M`, `R201A`, `r6`/`ptc` e `MaxMin` **non c'e'**. 🔴 Per tutte quelle celle il **muro
   giornaliero del 5% e' `[NON MISURATO]`, non "passato"**.
5. **Le POSIZIONI vere** — ogni `n` di questo documento e' un conteggio di **USCITE**
   (classe 550): `InpTP1_ClosePct=50` e' acceso su tutte le aperture e `InpTP1Pct=50` sulla
   MaxMin. Le posizioni stanno fra `n/2` e `n`. **Non ho aperto nessun per-trade per contarle.**
6. **I DEPOSITI** — `R54a`/`R107` = **100.000** · `FASE M` = **10.000** ·
   `R201A`/`R202B` = **80.000** · il CSV `valid_MaxMin_D30EUR` **non dichiara il deposito**
   (`[NON LETTO]`). 🔴 **Classe 604 applicata**: ho confrontato i DD% **solo dentro lo stesso
   round**, mai fra round diversi, e ogni tabella dichiara il suo deposito.
7. **`ABTG_DAX_Apertura_EU_Ottimizzato`** e **`ABTG_Nasdaq_Apertura_US_Ottimizzato`** (i due
   sorgenti con `InpAllowShort=false` nel **default del codice**) — non li ho guardati: non sono
   sedie della rosa FTMO.
8. **La caccia esterna** (`.set` pubblici, GitHub, Code Base) — **non fatta, e a ragione**: qui
   non serviva un valore di riferimento di fuori, servivano i nostri CSV. Dichiarato perche' e'
   un pezzo del mandato che ho **scelto** di non spendere, non che ho dimenticato.

---

## 🗂️ LE FONTI, per nome

**Preset**: `mql5/Presets/FTMO/ABTG_{DAX_Apertura_EU_770101, Dow_Apertura_US_770202,
Nasdaq_Apertura_US_RETEST_770260, MaxMinNotte_DAX_Short_770411}_FTMO.set`
**CSV letti riga per riga**: `risultati_archivio/csv_r54/*.csv` ·
`risultati_archivio/Walkforward_Aperture/{DAX,NASDAQ}_M_direzione_{IS,OOS}.csv` ·
`.../NASDAQ_B_motore_{IS,OOS}.csv` ·
`risultati_prove/ABTG_Dow_Apertura_US/..._{r6,ptc}.csv` ·
`risultati_prove/R201A/..._R201A.csv` ·
`risultati_archivio/MaxMinNotte/080957cf-valid_MaxMin_D30EUR.csv`
**Referti**: `risultati_archivio/R107_REFERTO.md` ·
`risultati_archivio/Walkforward_Aperture/{REFERTO_FASE_M,REFERTO_WALKFORWARD}.md` ·
`report/CENSIMENTO_LATO_SHORT_2026-09-09.md` ·
`report/PERCHE_NESSUNO_HA_SHORTATO_IL_DAX_2026-09-09.md` ·
`report/IL_PERTRADE_FTMO_ESISTE_2026-09-23.md` · `report/I_FILE_FERMI_2026-09-22.md` ·
`report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` · `report/EMA200_DOW_COSA_MANCA_2026-09-12.md`
**File prova**: `prove/{R107_DAX_01_short, R107_DOW_01_short, R107_NAS_01_short, R54a_lato_DOW_apertura,
R54b_lato_ORB_DOW, R205a_lato_corto_DAX_D30EUR, LATI_A1_EMA200_U30USD_DISCESA_short,
LATI_A2_EMA200_U30USD_TORO_short}.txt`
**Sorgenti**: `mql5/Experts/ABTG_{DAX_Apertura_EU, Dow_Apertura_US, Nasdaq_Apertura_US}.mq5`
**Forward**: `data/statements/{trades_auto, trades_100k}.csv`

---
---

# 1️⃣1️⃣ 💰 ADDENDUM MARGINE — **il vincolo vero, e il numero era gia' in casa dal 20/09**

> **Aggiunta al mandato R230**, dopo la frase di Claudio: *«Dobbiamo accendere tutte le sedie e
> tutti i lati sia long che short. Ce la dobbiamo fare.»*

## 11.0 🔥 PRIMA DI TUTTO: **l'`[INFERITO]` E' GIA' CHIUSO, E NESSUNO SE N'E' ACCORTO**

Mi e' stato chiesto *«scrivi qual e' la misura piu' corta per togliere l'`[INFERITO]`»*.
**La misura e' gia' stata fatta.** Il file sta in repo:

> **`backtest_pipeline/risultati_prove/PREVOLO_FTMO_specifiche_2026-09-20.csv`**
> prodotto il **20/09/2026 alle 17:08:07** da `mql5/Scripts/ABTG_PrevoloFTMO_Specifiche.mq5`,
> sul conto **541452707**, a **mercato APERTO**.

E il campo `Margine1Lotto` **non e' una stima**: viene da **`OrderCalcMargin()`** (r.266 dello
script), cioe' **e' il broker stesso a fare il conto**, non noi.

🔴 **Quindi ogni cifra di margine in circolazione e' costruita su un'ipotesi che il repo
FALSIFICA da tre giorni.** Il **140,6%** (`SCHIERAMENTO_FTMO_2026-09-20.md` r.404), il
**357,6%** (`DD_PORTAFOGLIO_FTMO_2026-09-20.md` r.347) e il **121,9%**
(`PACCHETTO_SCHIERAMENTO_PROP_2026-09-21.md` §②) poggiano **tutti** su
*«leva 1:15, ipotesi H2, nessuno ha mai letto una specifica FTMO»*. **Una specifica FTMO e'
stata letta**, lo stesso giorno, tre ore prima.

## 11.1 📖 COSA DICE IL CONTO — e due sorprese che cambiano i conti a monte

Blocco `[CONTO]` del CSV, letto testualmente:

| campo | valore misurato | 🔴 cosa si diceva in giro |
|---|---|---|
| `Conto` | **541452707** | ✅ |
| `Intestatario` | **80k FTMO Challenge 2-Step** | 🔴 tutti i conti margine sono fatti su **100.000** |
| `Valuta` | **EUR** | 🔴 tutte le tabelle sono in **$** |
| `Saldo` | **80.000,00** | 🔴 idem |
| `Leva` | **1:100** | 🔴 le tabelle assumono **1:15** |
| `StopOutLivello` | **50,000** | — |

🟢 **Il saldo NON cambia le percentuali** — e lo dimostro invece di darlo per buono: i lotti si
calcolano dal rischio, quindi scalano col saldo; il margine scala coi lotti; il rapporto
`margine / saldo` **e' invariante al saldo**. Le % qui sotto valgono sia su 80k sia su 100k.
🔴 **La leva e la valuta invece cambiano tutto.**

## 11.2 🧪 LA LEVA VERA E' **1:50 SUGLI INDICI**, non 1:15 — e il contro-esempio che lo prova

`Margine1Lotto` misurato (valuta conto = **EUR**), blocco `[SIMBOLI]`:

| mercato | simbolo FTMO | prezzo | contratto | **margine / 1 lotto** |
|---|---|---:|---:|---:|
| DAX | `GER40.cash` | 25.312,17 | 1,000 | **506,24 EUR** |
| DOW | `US30.cash` | 51.735,36 | 1,000 | **900,87 EUR** |
| NASDAQ | `US100.cash` | 29.686,67 | 1,000 | **516,94 EUR** |
| ORO | `XAUUSD` | 4.378,25 | 100,000 | **7.623,89 EUR** |
| forex | `USDJPY` | 156,882 | 100.000 | **870,66 EUR** |

### 🔨 Il contro-esempio, costruito per ROMPERE la mia risposta, non per confermarla
Ipotesi da provare: *«conto in EUR, margine = nozionale / leva, una sola leva per classe»*.
Sul `GER40` non c'e' conversione (simbolo in EUR), quindi la leva si legge nuda:
**25.312,17 / 506,24 = 50,0001 → esattamente 1:50.**
🎯 **E adesso la rottura**: se l'ipotesi fosse sbagliata, i tre simboli in **USD** — che hanno
prezzi, contratti e classi d'attivo **diversissimi** (un indice a 51.735, uno a 29.686, un
metallo a 4.378 con contratto 100) — darebbero **tre cambi EUR/USD impliciti diversi**.
**Misurato, assumendo 1:50:**

| simbolo | EURUSD implicito |
|---|---:|
| `US30.cash` | **1,14856** |
| `US100.cash` | **1,14855** |
| `XAUUSD` | **1,14856** |
| `USDJPY` *(a 1:100, classe forex)* | **1,14856** |

👉 **Quattro simboli indipendenti, lo stesso cambio alla QUINTA cifra.** L'ipotesi regge.
🔴 **E le alternative cadono da sole**: a **1:15** il `GER40` darebbe un cambio di **3,33**;
a **1:100** darebbe **0,50**. Nessuno dei due e' un cambio. **L'ipotesi 1:15 e' FALSIFICATA.**

> ## 🟢 **LEVA MISURATA: 1:50 su indici e metalli · 1:100 sul forex.** La riga `Leva 1:100` del
> conto e' la leva **di conto**; sui CFD indici/metalli il broker applica **meta'**.
> 👉 **Tutte le tabelle di margine del progetto sono sbagliate di un fattore 50/15 = 3,33×,
> nel verso BUONO.** C'e' piu' di TRE VOLTE lo spazio che credevamo.

## 11.3 📏 E UNA SECONDA CORREZIONE, misurata su 121 operazioni VERE

Le tabelle dei lotti in circolazione poggiano su *«valore punto 1 per lotto su `D30EUR`,
`U30USD`, `NASUSD`»* (`DD_PORTAFOGLIO` §5.2), **verificato pero' solo sul DAX**
(`8,30 lotti × 3,00 punti = 24,90 €`). L'ho rimisurato su **tutti** i trade veri
(`data/statements/trades_auto.csv`, `profit+commission+swap` diviso `lotti × punti`):

| simbolo | `n` operazioni | **EUR / punto / lotto (mediana)** | esito |
|---|---:|---:|---|
| `D30EUR` | 152 | **1,0000** | ✅ l'assunto regge |
| `U30USD` | 64 | 🔴 **0,8610** | 🔴 **−13,9%** |
| `NASUSD` | 57 | 🔴 **0,8673** | 🔴 **−13,3%** |

🟢 **E torna con la specifica FTMO in modo indipendente**: `US30.cash` e `US100.cash` hanno
`TickValue = 0,00871` su `TickSize = 0,01`, cioe' **0,871 EUR/punto/lotto** — che e'
`1 USD / 1,14856`. **Due strade diverse (i nostri trade BCM e la specifica FTMO) danno lo stesso
numero.** 👉 Sui simboli USD, a parita' di rischio, **servono ~15% di lotti IN PIU'** di quanto
dicono le tabelle esistenti, quindi **~15% di margine in piu'**.

## 11.4 💰 IL MARGINE PER SEDIA, RICALCOLATO — taglia **2,00%**, la firma del 20/09

🔴 **Nota che ribalta la premessa del mandato**: **tutti e SETTE** i preset FTMO portano
`InpRiskPercent=2.00` (letto adesso, riga per riga). La flotta mista **0,65 / 1,00** su cui e'
costruito il 140,6% **non esiste piu'**.

`margine % del conto = lotti@2,00%(su 100k) × margine_1_lotto / 100.000`
Lotti da `DD_PORTAFOGLIO` §5.2, **corretti** per il valore punto di §11.3.

| sedia | simbolo | lotti @2,00% | × m/lotto | **% del conto** |
|---|---|---:|---:|---:|
| `770101` DAX Apertura | `GER40.cash` | 23,97 | 506,24 | **12,13%** |
| `770411` MaxMin DAX Short | `GER40.cash` | 22,72 | 506,24 | **11,50%** |
| `770260` Nasdaq RETEST | `US100.cash` | 27,71 | 516,94 | **14,32%** |
| `770202` Dow Apertura | `US30.cash` | 18,76 | 900,87 | **16,90%** |
| `771531` EMA200 Dow | `US30.cash` | 22,26 | 900,87 | **20,06%** |
| 🔴 **`770511` SuperWave Dow** | `US30.cash` | **30,13** | 900,87 | 🔴 **27,14%** |
| | | | **TOTALE sei** | 🔴 **102,06%** |

🟡 **BANDA DICHIARATA, e dico perche' c'e'**: se i lotti di `DD_PORTAFOGLIO` avessero **gia'**
dentro la conversione di valuta (non posso verificarlo senza riaprire tutta la loro catena), il
totale sarebbe **91,25%** invece di 102,06%. 👉 **La banda onesta e' 91-102% del conto a taglia
2,00%.** Non do una cifra sola che non so difendere.
🟢 **Alla taglia di famiglia 0,65%** (× 0,325): **29,65% - 33,17%**.
🔴 `770411` e' l'unica riga in cui i lotti li ho **derivati** (dal rapporto dei margini
`45.271/47.757` con `770101`, stesso simbolo), non letti: **`[DERIVATO]`**.
⚪ `770402` MaxMin ORO **non e' nella rosa** schierata (omissione dichiarata,
`SCHIERAMENTO` §6.2) e non e' in questo totale.

## 11.5 🕐 CHI ARMA QUANDO — la mappa delle collisioni (ora **server FTMO** = italiana +1)

Letta dai preset FTMO, campi `InpSessionHour` / `InpPlaceHour` / `InpBoxStartHour`:

| ora FTMO | sedia | simbolo | % conto |
|---|---|---|---:|
| **09:59 → 10:30** | `770411` piazza il pendente | `GER40` | 11,50% |
| **10:00 → 10:35** | `770101` costruisce il range, poi retest | `GER40` | 12,13% |
| **16:30 → 17:05** | 🔴 `770202` **E** `770260` armano **nello STESSO minuto** | `US30` + `US100` | **31,22%** |
| **0-24, nessuna guardia** | `771531` (H1) | `US30` | 20,06% |
| **0-24, nessuna guardia** | 🔴 `770511` — misurato: ha aperto alle **03:00-06:00** | `US30` | 27,14% |

### 🔴 I DUE PICCHI, e il secondo e' quello che fa male

| momento | sedie compresenti possibili | margine impegnato |
|---|---|---:|
| mattina EU (10:00-10:35) | `770411` + `770101` + eventuale H1 gia' aperta | **23,64%** → **70,84%** |
| 🔴 **pomeriggio US (16:30)** | `770202` + `770260` + `771531` + `770511` | 🔴 **78,42%** |
| 🔴 **peggiore** | i quattro sopra **+ il DAX ancora aperto** (chiude 19:30) | 🔴 **90,55%** |

🔴 **E adesso il numero che rende concreto l'«ordine rifiutato in silenzio»**: a 90,55% impegnato
su un conto da **80.000 EUR**, il margine **libero** e' `80.000 × 9,45% = 7.560 EUR`. Una nuova
posizione sul Dow ne chiede `18,76 × 0,8 × 900,87 = 13.518 EUR`. 👉 **RIFIUTATA**, con un
`not enough money` nel Giornale e **nessun allarme**. `771531` e `770511` sono le due che armano
piu' tardi o a qualunque ora: **sono loro le vittime**, ed e' esattamente il *«si crede di
correre con sei sedie e si corre con tre»* del referto — **ma alla taglia 2,00%, non per la leva.**

## 11.6 🎯 **QUANTO MARGINE AGGIUNGE UN LATO? ZERO AL PICCO** — e lo dimostro nel codice

Questa e' la domanda 1 del mandato, e la risposta e' netta:

> ## 🟢 **Accendere un lato su `770101`, `770202` o `770260` aggiunge ESATTAMENTE 0,00% di margine di PICCO.**

**Perche', verificato nel codice e non assunto** (e' lo stesso accertamento di §7):
`InpOneTradePerDay=true` su tutte · `ABTG_Dow_Apertura_US.mq5` r.695-697 e
`ABTG_Nasdaq_Apertura_US.mq5` r.792-794 hanno `case PH_PLACED: case PH_DONE: break;` e **zero
occorrenze di `InpAllowReverse`** · `ABTG_DAX_Apertura_EU.mq5` r.893-900 chiama solo
`MonitorReverse()`, inerte con `InpAllowReverse=false`.
👉 **La sedia occupa al massimo UNA posizione al giorno, comunque.** Il lato cambia **la
direzione** e **il giorno**, non **l'ingombro**.

### 🔴 MA AGGIUNGE **GIORNI-MARGINE**, ed e' li' che morde
Il lato in piu' fa operare la sedia in giornate in cui prima stava ferma:

| sedia | uscite OOS solo-long → entrambi | **giornate occupate** | effetto sul pomeriggio US |
|---|---:|---:|---|
| `770101` DAX | 256 → 316 (`FASE M`) | 🔴 **+23,4%** | il DAX chiude alle **19:30**: ogni giorno in piu' toglie **12,13%** proprio alle **16:30** |
| `770202` Dow | 130 → 203 (`csv_r54`) | 🔴 **+56,2%** | **+16,90%** occupato su `US30`, lo **stesso simbolo** di `771531` e `770511` |
| `770260` Nasdaq | 301 → 196 **spegnendo** il corto (`FASE M`, geom. diversa) | 🟢 **−34,9%** | 🟢 **libererebbe 14,32%** su ~1 giorno su 3 |

⚠️ Le percentuali di giornate sono ricavate da **conteggi di USCITE** (classe 550) e valgono come
giornate **solo se il tasso di parziale e' lo stesso fra le celle**: `[INFERITO]`, dichiarato.

## 11.7 🏁 LA CLASSIFICA RIORDINATA — **operazioni guadagnate AL NETTO del margine occupato**

| # | azione | operazioni guadagnate | margine di picco | giorni-margine | **verdetto netto** |
|---|---|---|---:|---|---|
| 🥇 **1** | 🟢 **Portare `770511` alla taglia di famiglia 0,65%** | 0 dirette | **27,14% → 8,82%** | — | 🟢 **libera 18,3 punti di conto = **14.656 EUR**.** Vale **piu' di qualunque lato**: il picco US passa da **90,55%** a **72,23%**, e l'ordine rifiutato sparisce |
| 🥈 **2** | **Misurare il corto della `770260`** (4 passate) | `[NON MISURATO]` | 0,00% | 🟢 **−34,9% se si spegne** | 🟢 **l'unica mossa sui lati che PUO' liberare margine**, e l'unico lato acceso senza misura |
| 🥉 **3** | `LATI_A1/A2` EMA200 (8 passate) | 0 dirette | 0,00% | 0 | 🟢 conoscenza pura a costo zero di margine |
| 4 | Il **lungo** della `770411` (4 passate) | atteso **0** (0/18 celle positive) | 0,00% | +giorni su `GER40` | 🟠 chiude un certificato, non aggiunge nulla |
| 🔴 **5** | **Accendere il corto del DAX `770101`** | 🔴 **−601 EUR** OOS @1% *(1800 → 1199)* | 0,00% | 🔴 **+23,4%** di 12,13% nel pomeriggio | 🔴 **DANNO DOPPIO**: perde soldi **e** ruba margine alle americane |
| 🔴 **6** | **Accendere il corto del Dow `770202`** | 🔴 **+73 uscite TUTTE perdenti**, −2.795 EUR OOS @1% *(6722 → 3927)* | 0,00% | 🔴 **+56,2%** di 16,90% **su `US30`** | 🔴 **DANNO TRIPLO**: perde, occupa, e occupa **lo stesso simbolo** delle altre due americane |

> ## 🔴 LA RISPOSTA ONESTA A *«ACCENDIAMO TUTTI I LATI»*
> **Il margine NON e' cio' che lo impedisce.** Alla taglia di famiglia 0,65% la rosa intera, con
> **tutti e due i lati ovunque**, starebbe intorno al **29,65-33,17% del conto**: **ci sta comodamente**.
> 🔴 **Cio' che lo impedisce sono i NUMERI dei lati**: tre dei quattro lati spenti sono spenti
> **perche' perdono**, misurati su geometria identica e con `n` sopra il pavimento sul DAX.
> Accenderli non produce piu' operazioni buone: produce **piu' operazioni perdenti** e, in piu',
> fa **rifiutare in silenzio** quelle delle sedie americane.
> 🟢 **E la buona notizia e' grossa e va detta forte: con la leva VERA (1:50, misurata) c'e'
> PIU' DI TRE VOLTE lo spazio che i nostri documenti dichiarano.** Il vero collo di bottiglia
> non e' il broker: e' **la taglia al 2,00%**, ed e' **una firma di Claudio**, non un lavoro.

✋ **E lo dico come NUMERO, non come decisione**: `InpRiskPercent` e' territorio di Claudio
(CLAUDE.md). Io porto il conto, non la proposta.

## 11.8 🔴 CHE COSA RESTA `[NON CALCOLABILE]` — per nome

1. **Il margine dei tre PostNews** (`771202`, `771203`, `771204`): non sono nelle tabelle di
   lotti esistenti e non ho i loro stop medi. `[NON CALCOLABILE DA QUI]`.
2. **Il margine di `770402` MaxMin ORO**: il suo `Margine1Lotto` e' misurato (**7.623,89 EUR**,
   il piu' caro della lista) ma **i lotti no** — e la sedia e' fuori rosa. `[NON CALCOLABILE]`.
3. **I lotti veri sui simboli FTMO**: i miei vengono da tabelle costruite su simboli **BCM**.
   `GER40.cash` / `US30.cash` / `US100.cash` hanno `Digits=2` come BCM e `ContractSize=1`
   (verificato nel CSV), quindi trasferiscono — **ma `InpBufferPoints` e `InpMinStopPts` sono in
   PUNTI** e la verifica del `Digits` FTMO e' l'unica cosa che rende valido il trasferimento.
   🟢 Il CSV la chiude: `Digits=2` su tutti e tre. ✅
4. **La compresenza VERA**: quante volte due sedie sono davvero aperte insieme non e' misurato —
   servirebbe il per-trade FTMO, che ha **2 posizioni** (§3.3). I picchi di §11.5 sono **limiti
   superiori strutturali**, non frequenze osservate. `[NON MISURATO]`.
5. **Lo `StopsLevel` e il `FreezeLevel`**: entrambi **0** su tutti e cinque i simboli (letto nel
   CSV) — quindi **nessun vincolo di distanza minima sui pendenti**. Buona notizia, la riporto
   perche' era una domanda aperta altrove, ma non l'ho verificata contro nessun documento.

## 11.9 ✅ LA CASELLA CHE SI CHIUDE — e non costa NIENTE

**Non serve una misura nuova: serve che qualcuno APRA IL FILE.**
`backtest_pipeline/risultati_prove/PREVOLO_FTMO_specifiche_2026-09-20.csv` e' in repo dal 20/09 e
contiene, gia' misurati: **fuso** (chiuso, `+03:00`), **`Digits`** (chiuso), **spread**
(`SpreadPts` per simbolo), **`StopsLevel`/`FreezeLevel`** (chiusi, zero), **margine per lotto**
(chiuso), **leva reale** (deducibile, e l'ho dedotta qui con il contro-esempio).

🔴 **L'unica cosa da rifare e' la DATA**: lo script scrive in testa *«SE QUESTA DATA NON E DI
ADESSO STAI LEGGENDO UN CSV VECCHIO»*. Il mio e' del **20/09**, e i **prezzi** (e quindi i
margini, che sono `nozionale/leva`) si sono mossi. 👉 **La leva 1:50 e la valuta EUR NON
scadono** — sono strutturali. **I margini in EUR si': vanno riletti quando serve la cifra al
centesimo.** Rilanciare lo script costa **un F7 + un trascinamento su un grafico ~2 minuti**, ed
e' un'azione a mano dentro **MT5 `541452707` (`C:\FTMO`)** — non oggi, che Claudio e' da
cellulare.

### 🧾 E UNA CORREZIONE CHE VA FATTA AI DOCUMENTI, non a un EA
Tre referti del 20-21/09 portano cifre di margine **costruite su `1:15`, che il CSV dello stesso
giorno falsifica**. Finche' non sono corrette, chi le legge decide di ridurre la rosa per un
muro che **e' piu' di tre volte piu' lontano** di come e' scritto:
- `report/SCHIERAMENTO_FTMO_2026-09-20.md` r.401-411 (140,6%)
- `report/DD_PORTAFOGLIO_FTMO_2026-09-20.md` r.339-351 (357,6%)
- `report/PACCHETTO_SCHIERAMENTO_PROP_2026-09-21.md` §② (121,9%)
🔴 **Non li ho modificati io**: sono referti di altre sessioni e la correzione di un verdetto
altrui e' una consegna a se', non una nota a margine della mia.
