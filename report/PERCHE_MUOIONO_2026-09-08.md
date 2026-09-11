# 🔬 PERCHE' MUOIONO — la struttura c'e', ma NON e' quella del sospetto

> # ✅ **LA STRUTTURA C'E'.**
> # 🔴 **MA NON E' UNA "BANDA DI MEZZO", E NON C'ENTRA LA FREQUENZA.**
>
> E' **un numero solo**: il **Profit Factor letto nella finestra dove il
> drawdown e' stato misurato**.
> **13 motori su 13** bocciati o sospesi per RISCHIO in tutto l'archivio hanno
> **PF ≤ 1,19**. Zero eccezioni. Le due sedie vive stanno **sopra**.
>
> 🔴 E la meta' "poche centinaia di operazioni" del sospetto e' **SMONTATA
> CON I NUMERI**: **25 righe d'archivio su 39** stanno nella stessa zona
> (PF ≥ 1,20 · DD < 10%) delle due sedie vive, con `n` che va da **13 a 712**.
> Il numero di operazioni **non separa niente**.
>
> 🟡 E la seconda meta' — *"i motori lenti hanno PF piu' alto"* — e' un
> **ARTEFATTO DI CAMPIONE SOTTILE**, e lo dimostro in §3.2: sotto le 150
> operazioni la correlazione e' **−0,879**, sopra le 150 e' **−0,011**.
> Sparisce esattamente dove i numeri diventano leggibili.

_Compilato l'**08/09/2026** in sola lettura d'archivio. **Nessun EA, preset,
parametro, magic o sedia viva e' stato toccato.** Ogni numero e' letto da un
file citato per nome; dove il numero non esiste la riga dice **NON MISURATO**._

---

## 0. 🧊 IL LIMITE DI QUESTO DOCUMENTO, dichiarato PRIMA dei numeri

**Lo dico io prima che me lo dica Claudio**, perche' e' la regola di casa:

1. 🔢 **I punti sono pochi, e su un archivio SELEZIONATO.** Le 39 righe di R103
   sono motori che qualcuno ha costruito, ottimizzato e tenuto: **non e' un
   campione casuale di motori**. Qualunque separazione misurata qui e'
   **sovrastimata** rispetto al mondo.
2. 📊 **Le correlazioni su 6 e su 14 punti NON LE USO** per concludere niente.
   Dove i punti scendono sotto ~14 scrivo il numero e dico che non regge.
   Le due sole conclusioni forti di questo file sono **CONTEGGI**, non
   correlazioni: il 13/13 e il 25/39.
3. 🪟 **Le finestre non sono omogenee.** Gli indici hanno **21 mesi di tick BCM
   e UN SOLO REGIME** (`REFERTO_SONDA_DUKASCOPY.md`: *"BCM sugli indici parte
   dal 26/09/2024: 21 mesi e un solo regime"*); il forex ha **6,5 anni**.
   Li tengo in **due blocchi separati** e non li mescolo mai per concludere.
4. ⚖️ **Correlazione ≠ meccanismo.** Il cancello che propongo al §5 e'
   giustificato da un **meccanismo matematico** (§5.1); i dati lo **orientano**,
   non lo dimostrano. E dove i dati **contraddicono** il meccanismo — succede,
   §5.2 — lo scrivo.

---

## 1. 🗂️ LA TABELLA UNICA — tutti i verdetti che ho trovato

### 1.1 🪑 LE DUE SEDIE VIVE SUL CONTO REALE 10105439 — **tutte le letture, non solo la migliore**

🔴 **Prima correzione al mandato, e pesa.** I numeri citati nella domanda
(*"PF 1,41105"* e *"PF 1,67490"*) sono **la meta' OOS** di una misura a due
finestre. La stessa corsa ancora dell'08/09 ha anche una meta' IS, e dice altro.

| sedia | finestra | fonte (file) | `n` | PF | DD % | rischio | pegg. giorn. | freq. op/g |
|---|---|---|---:|---:|---:|---:|---:|---:|
| `ABTG_DAX_Apertura_EU` 770101 D30EUR M5 | **IS** ancora 08/09 | `ancora_passo7/ABTG_DAX_Apertura_EU_D30EUR_IS_ANCORA.csv` | **175** | 🟡 **1,15396** | 3,1749 | 0,65% | −0,6572 | ~0,97 |
| idem | **OOS** ancora 08/09 | `..._OOS_ANCORA.csv` | **270** | **1,41105** | 4,3501 | 0,65% | −0,6825 | ~0,98 |
| idem | **OOS R83/R118** ~~(= la cella del CONTRATTO)~~ 🔴🆕 **ERRATA 11/09: NON e' la cella del contratto** — ha **`InpAllowShort=1`** (lato corto ACCESO, spento nel preset vivo) e magic di laboratorio. La cella del contratto e' quella dell'ancora qui sopra (**4,3501% @0,65%**) e, a 1,0%, **6,7111%** (`aperture_r35/..._OOS_r35.csv` r.8, PF 1,41521, n 270). 📄 `report/CONFLITTO_DD_770101_2026-09-11.md` | `r118_csv/ABTG_DAX_Apertura_EU_D30EUR_OOS_r118c.csv` | **311** | 🟡 **1,18776** | 🔴 **10,5984** | **1,0%** | −1,0671 | ~0,97 |
| idem | **21 mesi R103** | `R103_REFERTO_BLOCCO1_INDICI.md` r.14 | **446** | **1,34** | 4,73 (7,28 @1%) | 0,65% | — | 0,98 |
| `ABTG_ORB_Ottimizzato` 770611 U30USD M5 | **IS** ancora 08/09 | `ancora_passo7/ABTG_ORB_Ottimizzato_U30USD_IS_ANCORA.csv` | 🟠 **71** | **1,23076** | 5,6530 | 0,65% | — | ~0,39 |
| idem | **OOS** ancora 08/09 | `..._OOS_ANCORA.csv` | 🟠 **119** | **1,67490** | 6,5389 | 0,65% | — | ~0,43 |
| idem | **21 mesi R103** | `R103_REFERTO_BLOCCO1_INDICI.md` r.12 | **190** | **1,67** | 3,00 (🔴 **10,00** @1%) | 0,30% | — | 0,42 |
| idem | contratto storico R15 | `report/CENSIMENTO_CONTRATTI.md` §2 | 119 | — | 🔴 **9,92 @1%** ⚠️ doppio asterisco | 1,0% | — | 0,43 |

> ### 🔴 TRE FATTI CHE IL MANDATO NON AVEVA, e cambiano la domanda
> 1. **Il DAX ha PF 1,154 sull'IS della stessa corsa ancora.** Il "1,41" e' la
>    finestra buona di due. ~~E la **cella del contratto** (R83/R118, 1%) da'
>    **PF 1,188 e DD 10,5984% — sopra il muro del 10%**.~~
>    🔴🆕 **ERRATA 11/09 — questa mezza riga e' SBAGLIATA, e cade.** R83/R118
>    **non e' la cella del contratto**: ha **`InpAllowShort=1`**, cioe' il lato
>    corto acceso, che sul conto reale non gira. La cella del contratto, a 1,0%,
>    fa **PF 1,41521 e DD 6,7111%** — **dentro** il muro del 10%, con 3,3 punti
>    di margine; a 0,65% fa **4,3501%** ⚠️ **[MISURATO a deposito 10.000 EUR]**
>    (su banco 100.000 EUR: **[NON MISURATO]**). Il lato corto da solo valeva
>    **+3,8873 punti** di DD. 🟢 **Il primo fatto — PF 1,154 sull'IS — resta in
>    piedi**: e' l'unica meta' della riga che regge. 📄 `report/CONFLITTO_DD_770101_2026-09-11.md`.
> 2. **L'ORB non ha MAI avuto un giudizio di merito leggibile**: `n` 71 e 119,
>    **sotto 150 in ENTRAMBE le finestre**. Il "PF 1,675" e' un numero a merito
>    formalmente **sospeso** dalla nostra stessa regola (`CENSIMENTO_CONTRATTI.md`
>    §2 lo dichiara: 🟠 SOSPESO).
> 3. **A rischio 1% l'ORB e' AL MURO: 10,00%** (R103) / **9,92%** (R15). Sta
>    dentro solo perche' e' **rimpicciolito a 0,65% e 0,30%**. Il margine
>    **viene dalla taglia, non dal motore** — ed e' scritto in
>    `CENSIMENTO_CONTRATTI.md` §2, non lo aggiungo io oggi.

### 1.2 💀 I MOTORI BOCCIATI O SOSPESI **PER RISCHIO** — con `n`, PF e DD veri

| motore · simbolo · TF | `n` | PF | DD % | pegg. giorn. | verdetto | fonte |
|---|---:|---:|---:|---:|---|---|
| `AtrExhaustVol` D30EUR LONG | 818 | 0,911 | **56,2** | −4,82 | 🔴 RISCHIO | `R109_REFERTO.md` |
| `AtrExhaustVol` D30EUR SHORT | 927 | 0,831 | **67,8** | −5,01 | 🔴 RISCHIO | idem |
| `AtrExhaustVol` U30USD LONG | 886 | 0,978 | **44,3** | −4,38 | 🔴 RISCHIO | idem |
| `AtrExhaustVol` U30USD SHORT | 923 | 0,917 | **57,2** | 🔴 **−9,72** | 🔴 RISCHIO (2 muri) | idem |
| `AtrExhaustVol` NASUSD LONG | 655 | 0,885 | **59,2** | −4,57 | 🔴 RISCHIO | idem |
| `AtrExhaustVol` NASUSD SHORT | 743 | 0,990 | **44,1** | −4,30 | 🔴 RISCHIO | idem |
| `LondonFx` EURUSD M15 canale nudo | 2253 | 0,898 | **45,29** | — | 🔴 RISCHIO | `r116_londonfx/CORSA_EURUSD_..._BOCCIATA.txt` |
| `LondonFx` EURUSD canale+RSI *(il promuovibile)* | 1132 | 0,843 | **37,14** | — | 🔴 RISCHIO | idem |
| `LondonFx` EURUSD 5 medie | 1343 | 0,923 | **31,26** | — | 🔴 RISCHIO | idem |
| `LondonFx` GBPUSD canale+RSI | 1132 | 0,763 | **55,03** | — | 🔴 RISCHIO ⚠️ banco sporco cl.129 | `..._GBPUSD_..._BANCO_SPORCO.txt` |
| `RELATIVO` D30EUR M5 (R117) | NON MISURATO | 0,452 | **25,01** | 🔴 **−5,20** | 🔴 RISCHIO (2 muri) | `REGISTRO_TEST.md` §R117 |
| `RELATIVO` NASUSD M5 (R117) | 87 / 154 | 1,189 | 8,40 | −2,12 | 🟠 MERITO SOSPESO (rischio mai rosso) | idem |
| `LVNArbitro` U30USD M30 **IS** | **392** | **0,975** | 🔴 **19,35** @100k | −2,80 | 🔴 RISCHIO | `report/P0_LVNARBITRO_2026-09-08.md` |
| `LVNArbitro` U30USD M30 **OOS** | **618** | **1,053** | 🔴 **11,76** @100k | −2,45 | 🔴 RISCHIO | idem |
| `AllineaLondra` EURUSD M15 (8 letture) | NON MISURATO | 0,60–1,12 | **10,44–46,62** | — | 🔴 RISCHIO, 7/8 in perdita | `allinealondra/REFERTO_PASSO0_...txt` |
| FASE 2 Nasdaq drive-following LONG M15 | 297 OOS | 1,083 | 🔴 **11,73 @0,65%** | — | 🔴 RISCHIO (merito misurabile e sotto barra) | `REFERTO_FASE2_CASSA_2026-08-30.md` |
| FASE 2 cella simmetrica | NON MISURATO | 0,796 | **19,09** | — | 🔴 RISCHIO+EDGE | idem |
| `CrossEmaApertura` (R96) | NON MISURATO | NON MISURATO | **29–35** | — | 🔴 RISCHIO | R96 |
| `ORB` Dow **SHORT** (R54) | NON MISURATO | 0,520 | **26,37** | — | 🔴 RISCHIO+EDGE | `CORSIA_DEMO_CANDIDATI.md` §3 r.26 |
| `Nasdaq_Apertura_US` breakout 770201 | NON MISURATO | 0,82 | **17** | — | 🔴 spenta 18/08, 19/20 celle OOS neg. | `report/CONTRATTI_SEDIE.md` r.45 |
| `AltaVelocita` v1/v1.1 GBPUSD (8 celle) | NON MISURATO | 0,54–0,82 | fino a **37** | — | 🔴 8/8 negative | `REFERTO_ALTA_VELOCITA_V1.md` |
| `BreakinBox` DAX (tesi) | NON MISURATO | 1,007 | **24,1** | — | 🔴 tesi falsificata + DD | `REFERTO_BREAKIN_2026-08-31.md` |

> ### 🎯 **IL CONTEGGIO CHE VALE PIU' DI OGNI CORRELAZIONE IN QUESTO FILE**
> Prendendo i **13 motori bocciati/sospesi per rischio con un PF misurato**
> (le righe con un numero in colonna PF, contando una volta sola per motore):
> **PF minimo 0,763 · mediano 0,917 · MASSIMO 1,189.**
> 🔴 **NESSUNO, MAI, ha superato 1,19.**
> Le due sedie vive: **1,15–1,41** (DAX) e **1,23–1,67** (ORB).

### 1.3 ⏱️ I MOTORI MORTI **PER FREQUENZA** — e sono pochissimi

| motore | op/giorno misurate | `n` | verdetto | fonte |
|---|---:|---:|---|---|
| `ABTG_OpeningReversalB` U30USD M5 | 🔴 **0,0078** (128× sotto il pavimento) | **2** IS · **0** OOS su 12 celle | 🔴 ARCHIVIATO per FREQUENZA | `report/P0_OPENINGREVERSALB_2026-09-08.md` |
| `SuperWave DAX H4` 770512 | 0,12 | 56 | 🎣 riaperto 08/09 (freq-only) | `RIPESCAGGIO_FREQUENZA_2026-09-08.md` R1 |
| Gap sessione cash (4 indici) | 0,14/simbolo | — | 🎣 riaperto (freq-only) | idem R2 |
| `IU Gap Fill` riconquista | NON MISURATA | — | 🎣 riaperto | idem R3 |
| M27 overnight→intraday | 1,00 `[DERIVATA]` | — | 🎣 riaperto | idem R4 |
| `M0PB` (sonda) | 0,147–0,500 | 12/12 morto a F1 | 🎣 riaperto | idem R5 |
| `RSI Ea MT5` (CB 59303) | NON MISURATA | — | 🎣 riaperto | idem R6 |
| Power Hour + ICT Opening Gap | ~1,00 `[DERIVATA]` | — | 🎣 riaperto | idem R7 |

### 1.4 🧪 I MOTORI MORTI **PER MANCANZA DI EDGE** — e sono la maggioranza schiacciante

_Non li riscrivo uno per uno: comanda `report/CORSIA_DEMO_CANDIDATI.md` §3
(35 righe) + `RIPESCAGGIO_FREQUENZA_2026-09-08.md` §4.2. I capisaldi:_

| famiglia | il numero che la uccide |
|---|---|
| FADE estremi range apertura (R42) | **0/48** celle positive, IS **e** OOS, n 195–333 |
| Londra ORB (R45) | **0/48** |
| Rimbalzo ORL/ORH (R43) | **0/8 + 0/8** |
| R95 sweep+reclaim JPY | **0/30**, con **21.354 livelli creati** — *non e' fame di segnali* |
| `CRT_TurtleSoup` | **0/30** a tick; il gate ADX **non salva** (0,459 gated vs 0,462 ungated) |
| Micro-pivot sweep M5/M15 | delta vs ingressi **CASUALI** stessa geometria: **−0,2 punti su 22.616 segnali** |
| Compressione ATR → espansione | **−1,2 punti su 9.723 segnali** contro il caso |
| Lead-lag S&P→DAX M5 | frequenza **PASSAVA** (2–7/gg) — **8/8 celle negative al netto** |
| Numeri tondi (Osler) | 93.000+ segnali, **5 letture su 6 negative** |
| Asta LBMA oro | **72 celle su 72 negative** |
| `VwapRevert` D30EUR M15 | S0 **negativo su 4/4** (−0,11 / −0,21 / −0,14 / −0,21) |
| Sonda Orologio ramo DAX | **0 fasce asimmetriche su 72** in OOS |
| Breakout M5 in apertura (Live5m &c.) | real tick **27/27 combo negative** |
| Lati SHORT delle aperture | R107 DAX PF OOS **0,957** con n **257** (campione PIENO) · R54 Dow 0,840 · R107 NAS **0,460** |
| SupRev DOW/CAC H4 | promozioni **REVOCATE**: PFmed tick **0,79** e **0,96** contro OHLC 2,58 e 7,37 |
| ~20 lapidi da sonda/paper | `CORSIA_DEMO_CANDIDATI.md` §3.4 |

### 1.5 🧮 IL BLOCCO OMOGENEO — R103, 39 righe, stesso metro, stesso rischio 1%

E' l'unico posto del repo dove **PF, DD e `n` sono misurati con lo stesso metro
su molte sedie**. E' su queste 39 righe che ho fatto tutti i conti del §3.

- **15 sedie INDICI**, finestra **21 mesi** (2024.09.26→2026.06.30), **un solo
  regime** — `R103_REFERTO_BLOCCO1_INDICI.md`
- **24 sedie FOREX/METALLI**, finestra **6,5 anni** — `R103_REFERTO_FINALE.md`
  *(la 25ª, Gold_Ichimoku, ha DD `n/d` ed e' esclusa dai conti)*

---

## 2. 📊 DOVE STA IL COLLO DI BOTTIGLIA DELL'IMBUTO — il conteggio per causa

| causa di morte | quanti | quota | fonte del conteggio |
|---|---:|---:|---|
| 🧪 **MANCANZA DI EDGE** | **~43** (23 righe nominate + ~20 lapidi da sonda/paper) | **61%** | `RIPESCAGGIO_FREQUENZA_2026-09-08.md` §1 + §4.2 |
| 🩸 **RISCHIO** (DD fuori dai muri) | **~14** (12 nominate + LVNArbitro + 1) | **20%** | idem §4.1 + `P0_LVNARBITRO_2026-09-08.md` |
| 📏 **CAMPIONE** (< 150 op nell'IS) | **6** famiglie di eventi macro | **8%** | idem §3.3 |
| ⏱️ **FREQUENZA** | **8** (7 del ripescaggio + `OpeningReversalB`) | **11%** | idem §2 + `P0_OPENINGREVERSALB_2026-09-08.md` |
| **totale righe censite** | **~71** | | |

> ## 🔴 **IL COLLO DI BOTTIGLIA NON E' LA FREQUENZA. E' L'EDGE, DI CINQUE VOLTE.**
> Uno su nove muore di frequenza. **Tre su cinque muoiono perche' sotto non
> c'e' niente.**
>
> 🎯 **E i due gruppi non sono nemmeno separati**: **13 morti per RISCHIO su 13
> hanno anche PF ≤ 1,19.** Non sono motori buoni che sbandano — sono motori
> senza edge, e il drawdown e' il modo in cui la cosa **si vede**.
> 👉 Sommando: **~57 righe su 71 = l'80% dell'imbuto muore della stessa
> malattia**, chiamata con due nomi diversi.
>
> ✅ Questo **conferma e rinforza** `report/PERCHE_NON_ARRIVIAMO_2026-09-07.md`
> (*"nessun allentamento di cancello lo avrebbe salvato... e' stato fermato dal
> RISCHIO"*) e la firma del 07/09 sul pavimento di frequenza per famiglia:
> **allargare il cancello di frequenza non aumenta il numero di sedie**, perche'
> la frequenza non e' quello che le sta uccidendo.

---

## 3. 🔍 LE QUATTRO DOMANDE DEL MANDATO, una per una

### 3.1 ❓ C'e' relazione fra **numero di operazioni** e **DD%**?

**SI, ed e' replicata su due blocchi indipendenti** (segno uguale, metro diverso):

| blocco | punti | Spearman(`n`, DD%) | Spearman parziale a **PF costante** |
|---|---:|---:|---:|
| INDICI 21 mesi | 15 | **+0,518** | **+0,445** |
| FOREX/METALLI 6,5 anni | 24 | **+0,640** | **+0,429** |

E si legge anche senza statistica, per fasce (tutte e 39, rischio 1%):

| fascia di `n` | righe | PF mediano | **DD mediano** |
|---|---:|---:|---:|
| 0–49 | 6 | 2,27 | **3,05%** |
| 50–149 | 13 | 1,65 | **3,96%** |
| **150–399** | **16** | **1,11** | 🔴 **12,30%** |
| 400+ | 4 | 1,34 | 7,80% |

🔴 **MA ATTENZIONE, e questo e' il punto**: la fascia 400+ ha **DD MEDIANO PIU'
BASSO** della fascia 150–399. **Quindi non e' "piu' operazioni = piu' DD" in
modo monotono.** Le due righe con piu' operazioni di tutto l'archivio —
`EMA200 U30USD` (n **712**, DD **6,48%**) e `EMA200_Ott XAUUSD` (n **610**,
DD **7,80%**) — stanno **dentro il muro**. 👉 Il numero di operazioni **da solo
non predice il drawdown**: quello che cambia fra le due fasce e' il **PF
mediano** (1,11 contro 1,34).

### 3.2 ❓ I motori piu' **lenti** hanno **PF piu' alto**?

**NO. E' un artefatto di campione sottile, e si smonta in una riga.**

| sottoinsieme | punti | Spearman(`n`, PF) |
|---|---:|---:|
| FOREX, **tutti** | 24 | −0,527 |
| FOREX, **`n` < 150** (merito sospeso per regola di casa) | 10 | 🔴 **−0,879** |
| FOREX, **`n` ≥ 150** (merito leggibile) | 14 | ✅ **−0,011** |
| INDICI, tutti | 15 | −0,490 |
| INDICI, `n` ≥ 150 | 6 | −0,371 ⚠️ *6 punti: non lo uso* |

> ### 🎯 **LA RELAZIONE SPARISCE ESATTAMENTE DOVE I NUMERI DIVENTANO LEGGIBILI.**
> Non e' che i motori lenti guadagnano di piu': e' che **sotto le 150 operazioni
> il PF non e' una misura**, e le righe lente che l'archivio si e' tenuto sono
> quelle a cui e' andata bene.
>
> **Le prove nominate, e sono imbarazzanti nella loro chiarezza:**
> - `GapFill GBPUSD`: **PF 2,46 su 13 trade** · `GapFill EURUSD`: **2,45 su 14** ·
>   `GapFill AUDUSD`: **2,27 su 17**. Sono i tre PF piu' alti del blocco forex e
>   sono **quarantaquattro operazioni in totale, in 6 anni e mezzo**.
> - `ABTG_OpeningReversalB`: **PF 1,826 su 2 operazioni** — e su una cella del
>   passo 0-bis arriva a **PF 3,562 su 3 trade**. Il suo stesso referto lo dice:
>   *"PF 3,56 sulla cella FT=50 e' tre trade, non una scoperta"*.
>
> ✅ **Questo e' un rinforzo QUANTITATIVO dell'Emendamento della Finestra §A**
> (`CLAUDE.md`): la soglia dei 150 non e' prudenza, e' il punto **misurato** in
> cui la correlazione fittizia si spegne. Non era mai stato mostrato con un
> numero. Adesso lo e'.

### 3.3 ❓ I sopravvissuti stanno tutti su un **TF**, un **evento**, un **tipo di ingresso**?

| proprieta' | DAX 770101 | ORB 770611 | condivisa? | il contro-esempio che la smonta |
|---|---|---|---|---|
| **timeframe** | M5 | M5 | ✅ SI | 🔴 **ma non e' la causa**: `SupRev_NAS_H1` (H1) fa **PF 1,65 · DD 1,48% · n 172** e `SuperWave U30USD` (H2) fa **PF 2,78 · DD 3,85%** — **meglio dell'ORB su tutti e tre gli assi**, e non sono sul reale. E `CLAUDE.md` dice che la banda buona sugli indici e' **M30/H1**, non M5 |
| **evento** | apertura di sessione | apertura di sessione | ✅ SI | 🟡 e' la proprieta' condivisa piu' solida — ma vedi il §3.3-bis |
| **tipo di ingresso** | 🔴 **BuyLimit** (cella viva = **RETEST**, `ABTG_DAX_Apertura_EU.mq5:1504`) | 🔴 **BuyStop** (`ABTG_ORB_Ottimizzato.mq5:456`) | ❌ **NO** | i due ingressi sono **opposti**: uno compra sul ritorno, l'altro sulla rottura |
| **lato** | SOLO LONG | SOLO LONG | ✅ SI | 🔴 **ed e' un allarme, non una virtu'** — vedi §3.3-bis |
| **mercato** | indice | indice | ✅ SI | `EMA200 U30USD` (indice, H1, n 712, PF 1,42, DD 6,48%) ha numeri **migliori del DAX** ed e' sul piccolo |

#### 3.3-bis 🚨 LA PROPRIETA' CONDIVISA PIU' FORTE E' ANCHE LA PIU' SCOMODA

`backtest_pipeline/prove/R52_CENSIMENTO_LATI.md` lo dice a chiare lettere:
sulle sedie 770101, 770202 e 770611 il lato e' **"SOLO LONG"** e la casella
"lato mancante" dice **"SCELTO"** — cioe' *"esiste, ed e' stato spento su 21
mesi di mercato in salita"*.

E i lati short sono stati misurati, e sono morti: **R107 DAX PF OOS 0,957 con
n 257** (campione pieno, discesa feb-apr 2025 inclusa) · **R54 Dow 0,840** ·
**R107 NAS 0,460** · **ORB Dow short PF 0,520 con DD 26,37%**.

> ### 🔴 QUINDI LA RISPOSTA ONESTA ALLA DOMANDA "COSA HANNO LE DUE VIVE"
> Hanno in comune: **sono long su un indice, in apertura di sessione, misurate
> su 21 mesi di UN SOLO REGIME, e quel regime e' un TORO.**
> **Non e' possibile, con i dati che abbiamo, distinguere "hanno un edge" da
> "erano dalla parte giusta del toro".** Non e' un'accusa: e' un limite del
> nostro storico, ed e' gia' scritto in `REFERTO_SONDA_DUKASCOPY.md`.
> 👉 **Va detto adesso, a 23 giorni dalla challenge, non dopo.**

### 3.4 ❓ Quanti morti per frequenza, quanti per DD?

**8 contro ~14, su ~71 righe totali.** Il §2 ha la tabella. La riga che conta:
**~43 su 71 muoiono per EDGE**, e **13 su 13 dei morti "per rischio" hanno
anche PF ≤ 1,19**. Il collo di bottiglia e' uno solo.

---

## 4. ⚖️ IL SOSPETTO: **META' CONFERMATO, META' SMONTATO**

> Il sospetto: *"i motori falliscono in due modi opposti — o non operano, o
> operano tanto con PF a ridosso di 1 e DD che sfonda. Le due vive stanno nel
> mezzo: poche centinaia di operazioni con PF 1,4–1,7."*

| meta' del sospetto | verdetto | il numero |
|---|---|---|
| *"operano tanto con **PF a ridosso di 1** e DD che sfonda"* | ✅ **CONFERMATO, e piu' forte di come era formulato** | 13/13 dei bocciati per rischio hanno PF ≤ 1,19; PF mediano **0,917** |
| *"le vive stanno **nel mezzo per numero di operazioni**"* | 🔴 **SMONTATO** | **25 righe su 39** stanno nella zona (PF ≥1,20 · DD <10%) con `n` da **13 a 712**. `n` non separa. E `EMA200 U30USD` con **n 712** ha DD **6,48%** |
| *"PF **1,4–1,7**"* | 🟡 **NON REGGE COME BANDA** | e' la lettura **migliore** delle due sedie. La lettura peggiore e' **1,154** (DAX IS) e **1,188** (DAX contratto R83). Sono **sotto 1,20** |
| *"o **non operano**"* | ✅ **CONFERMATO, ma e' un caso raro** | `OpeningReversalB` a **0,0078 op/g** e' **l'unico** caso puro nell'archivio. Gli altri 7 "per frequenza" sono ripescaggi, non lapidi |
| *"e' un caso, o e' una **PROPRIETA'**?"* | 🔴 **NON E' LA PROPRIETA' CHE HA SELEZIONATO LE DUE SEDIE** | `SupRev_NAS_H1` (n 172 · PF 1,65 · DD **1,48%**) **domina `ORB_Ott` (n 190 · PF 1,67 · DD 10,00%) su tutti e tre gli assi** e **non e' sul conto reale**. Le due vive non sono l'optimum di quella tripla: sono **il risultato di una storia di deploy** |

> ### 🎯 LA RIFORMULAZIONE CHE I NUMERI SOSTENGONO
> Non e' una **banda di mezzo** con due bordi.
> E' **un pavimento solo, e sta sul PF.**
> Sopra il pavimento, il numero di operazioni **e' un pregio** (`EMA200`: n 712,
> PF 1,42, DD 6,48%, **1,55 op/giorno**, il motore piu' veloce della flotta).
> Sotto il pavimento, il numero di operazioni **e' la miccia**: piu' operazioni
> fai con un PF vicino a 1, piu' in fretta arrivi al muro.

---

## 5. 🚪 IL CANCELLO CHE PROPONGO — **C0 · PAVIMENTO DI PF SULLA FINESTRA PEGGIORE**

🔴 **E' UNA PROPOSTA. Non e' congelata, non e' applicata, non tocca niente.
La firma e' di Claudio.**

```
CANCELLO C0 — al PASSO 0, PRIMA di qualunque griglia:

  SE  n >= 150  in una finestra (IS o OOS)
  E   il PF misurato a TICK REALI in QUELLA finestra e' < 1,10
  ALLORA  il candidato si SCARTA. Niente griglia, niente ottimizzazione.

  Si applica al PEGGIORE dei PF leggibili, non al migliore.
  Se n < 150 in tutte le finestre: C0 NON SI APPLICA (il PF non e' una
  misura) e si passa al cancello di frequenza / al conteggio occasioni.
```

### 5.1 🧠 IL MECCANISMO — perche' 1,10 e perche' il PF e non `n`

Un muro prop e' un vincolo sul **MASSIMO** della curva di equity, non sulla sua
media. Per un percorso con media per operazione **μ** e deviazione **σ**, il
drawdown massimo atteso **non cresce all'infinito con `n`**: converge verso
**σ²/(2μ)** — cresce con il **quadrato del rumore** e cala con la **prima
potenza dell'edge** (Magdon-Ismail & Atiya, 2004, sul massimo drawdown di un
moto browniano con deriva). E **μ e' proporzionale a (PF − 1)**.

👉 Tre conseguenze, e sono esattamente cio' che l'archivio mostra:
1. **A PF vicino a 1 la deriva sparisce e resta solo il rumore**: il DD massimo
   esplode **indipendentemente da quanto sei bravo per trade**. E' il ritratto
   esatto di `LVNArbitro`: sull'OOS fa **+11,31% su 100k — sopra il target del
   +10% — ma con DD 11,76% avrebbe sfondato il muro PRIMA di arrivarci.**
   *Guadagna, e muore per strada.* Il suo stesso referto lo chiama
   **"un'erosione lunga"**: peggior giornata −2,80% contro un muro del −5%.
2. **Sopra un edge sufficiente il DD si stabilizza e `n` smette di far male.**
   `EMA200 U30USD`: **712 operazioni, DD 6,48%**. `SuperWave_DOW_H1`: 290
   operazioni, DD **4,14%**.
3. **Il cancello non puo' stare su `n`**, perche' `n` e' quello che ci serve:
   la challenge parte il **1° ottobre** e le operazioni sono l'unica cosa che
   produce un verdetto in tre settimane. Un cancello su `n` taglierebbe
   **esattamente cio' che stiamo cercando**.

### 5.2 📏 PERCHE' **1,10** E NON **1,20** — e perche' i dati mi correggono

Il taglio "naturale" dei dati sarebbe **1,20** (PF <1,20 → DD ≥10% nell'**82%**
delle righe R103; PF ≥1,20 → solo **11%**, un rapporto di **7,5×**).

🔴 **Ma a 1,20 il cancello scarterebbe una sedia che sta sul CONTO REALE**: il
DAX 770101 ha **PF 1,154** sull'IS dell'ancora e **1,188** sulla cella del suo
contratto. **Un cancello che boccia una sedia viva non e' un cancello: e' un
errore.** Quindi lo abbasso al punto dove separa davvero:

| | PF |
|---|---|
| massimo fra **tutti** i bocciati per rischio dell'archivio | **1,12** (`AllineaLondra`, estremo alto di 8 letture; il secondo e' **1,083**, FASE 2) |
| minimo fra le **letture leggibili delle sedie vive** | **1,154** (DAX IS ancora, n 175) |
| **la soglia sta nel mezzo** | **1,10** |

⚠️ **E il margine e' SOTTILE: 1,12 contro 1,154 = 0,034 punti di PF.**
Non lo nascondo. Significa che C0 **non e' una legge di natura**: e' un
cancello che, sui dati che abbiamo, non ha ancora sbagliato — e ha **pochissimo
spazio** prima di sbagliare.

🔴 **E il meccanismo NON regge quantitativamente, va detto.** Se `DD × (PF−1)`
fosse costante come vorrebbe la formula, dovrebbe stare in una banda stretta.
**Misurato sulle 35 righe R103 con PF > 1: va da 0,16 a 6,85 — un fattore 40.**
👉 **La formula da' la DIREZIONE, non la taglia.** Per questo il cancello e' di
**SCARTO** e non di **PROMOZIONE**.

### 5.3 ✅ COSA C0 AVREBBE FATTO, se fosse esistito

| | |
|---|---|
| **avrebbe scartato al PASSO 0** | `LVNArbitro` (IS PF 0,975 con n 392 → scartato **prima** della seconda corsa a 100k) · tutti e 3 i motori `LondonFx` (IS PF 0,795 / 0,688) · `RELATIVO` D30EUR (0,452) · tutte e 6 le celle `AtrExhaustVol` (0,83–0,99) · FASE 2 simmetrica (0,796) · `AllineaLondra` (7/8 letture) · `Nasdaq_Apertura_US` breakout (0,82) · `ORB` Dow short (0,520) · `BreakinBox` (1,007) |
| **NON avrebbe scartato** | nessuna delle due sedie vive (DAX peggiore **1,154**; ORB **non applicabile**, n 71/119 < 150) |
| **falsi positivi noti** (scartati pur avendo DD sotto il muro) | **2 righe su 39**: `PunteLarry GBPUSD` (PF 1,05 · DD 8,5% · 3/7 anni negativi) e, di un soffio, `PTE GBPUSD B25` (PF 1,11 · DD 5,8% · **5/7 anni negativi**) — 🟡 **due sedie che l'archivio descrive gia' come marginali**, ma restano falsi positivi e li conto |
| **risparmio misurabile** | su `LVNArbitro` erano **due round**; il referto stesso dice *"~15 minuti"*. Il valore vero non e' il tempo: e' **non portare davanti a una challenge una cella scelta fra numeri che non separano** |

### 5.4 🚫 COSA C0 **NON** COPRE — e va letto tutto

1. ❌ **Non copre `n` < 150.** Sotto le 150 operazioni **non si applica**, e il
   §3.2 spiega perche': li' il PF non e' una misura. 🔴 **Conseguenza diretta e
   scomoda: sull'`ABTG_ORB_Ottimizzato` del conto reale (n 71 e 119) questo
   cancello NON DICE NIENTE.** Non lo assolve: **non lo esamina**.
2. ❌ **Non copre "PF alto e DD lo stesso fuori dal muro".** Succede in **3
   righe su 28** (11%): `ORB_Ott` (PF 1,67 · DD **10,00%** @1%), `CostToCost
   EURJPY` (1,41 · **12,3%**), `MaxMinNotte XAUUSD` (1,31 · **10,6%**).
   👉 **C0 NON sostituisce la lettura del drawdown: la ANTICIPA.** Il DD si
   guarda comunque, sempre, come dice l'Emendamento §B.
3. ❌ **Non copre il muro GIORNALIERO** (−5%). Sono muri diversi:
   `AtrExhaustVol U30USD SHORT` ha peggior giornata **−9,72%**, `RELATIVO`
   D30EUR **−5,20%**.
4. ❌ **Non copre la frequenza.** `OpeningReversalB` (2 operazioni) e le 7
   righe del ripescaggio muoiono altrove. C0 e **il pavimento di frequenza per
   famiglia** (firma 07/09) sono cancelli **indipendenti**: servono tutti e due.
5. ❌ **Non copre l'illusione OHLC.** Il PF di C0 dev'essere misurato **a tick
   reali**. `SupRev_DOW_H4` aveva PFmed **2,58 in OHLC** e **0,79 a tick**:
   C0 letto su OHLC lo avrebbe **promosso**.
6. ❌ **Non copre il REGIME.** `InvEsaurimento` cella E3 e' verde nel totale
   (PF 1,16 · n 215) e fa **−5.604 nel toro pulito 2017**. Un PF medio su un
   solo regime non e' un giudizio: resta la **prova di regime**
   (Emendamento §C).
7. ❌ **Non copre il portafoglio.** `GapFill U30USD` e' stata esclusa da R37 per
   il **cumulo del lunedi'**, non per il suo PF. E il tetto per cluster al 3,0%
   firmato il 07/09 e' 🔴 **FIRMATO MA NON ATTIVO** — nel Guardian non esiste.
8. ❌ **Non e' un cancello di PROMOZIONE.** **25 righe su 39** lo passano largo,
   incluse sedie **spente**. Passare C0 non vuol dire niente: **non passarlo
   vuol dire tutto.**
9. ⚠️ **Il margine e' 0,034 punti di PF** (§5.2), su un archivio **selezionato**
   (§0.1). Il primo motore che sbaglia C0 va scritto qui dentro e la soglia si
   rivede.

---

## 6. 📮 COSA MANCA, E CHI LO PORTA

| # | il buco | chi | la domanda esatta |
|---|---|---|---|
| 1 | ✅ 🆕 **RISPOSTO l'11/09 — e la domanda posta qui era ESATTA.** ~~**Il PF del DAX 770101 ha QUATTRO valori diversi** (1,154 · 1,188 · 1,34 · 1,411) su quattro finestre. **Non e' un conflitto di fonti: sono quattro finestre diverse.**~~ 🔴 **Mezza riga era sbagliata**: il **1,188** non e' *un'altra finestra*, e' **un'altra CONFIGURAZIONE** — R83/R118 gira con **`InpAllowShort=1`**, finestra e split **identici** all'ancora. Le altre tre restano finestre diverse. 🎯 **E la domanda finale — *"Le due celle sono la stessa cella?"* — ha risposta: NO.** Il "DD promesso" del contratto era quello della cella col lato corto acceso; quello vero e' **4,3501% @0,65%** e **6,7111% @1,0%**, ⚠️ **[MISURATO a deposito 10.000 EUR]** (a 100k: **[NON MISURATO]**). 🏆 **E il conto abbozzato qui era buono al terzo decimale**: *"4,35% a 0,65% ⇒ 6,69% a 1%"* contro **6,7111% misurato** — scarto **0,3%**. La scala lineare del rischio regge, era la CELLA a essere sbagliata. 📄 `report/CONFLITTO_DD_770101_2026-09-11.md` | **Claudio + chi gira i round** | *"Qual e' la finestra di riferimento del contratto della 770101? Perche' R83 (n 311, 1%) da' DD 10,60% e l'ancora dell'08/09 (n 270, 0,65%) da' 4,35% = 6,69% a 1%? Le due celle sono la stessa cella?"* → ✅ **chiusa** |
| 2 | 🟠 **L'ORB 770611 non ha MAI avuto un merito leggibile** (n 71 e 119, sotto 150 in **entrambe** le finestre) ed e' **sul conto reale** | **cacciatore-strategie** | *"Esiste una finestra sul Dow che porti l'ORB sopra 150 operazioni in ENTRAMBI i lati dello split? Se no, quante settimane di forward servono?"* (aritmetica gia' fatta per RELATIVO in R117: si fa uguale) |
| 3 | 🚨 **Un solo regime sugli indici.** Tutte le sedie indici sono misurate su 21 mesi di toro, e i loro lati long sono **SCELTI**, non strutturali (`R52_CENSIMENTO_LATI.md`) | **cacciatore-strategie** | *"La prova di regime (Emendamento §C) sulle due sedie vive: si puo' fare con lo storico `_EXT` in frigo, o serve Dukascopy?"* |
| 4 | ❓ **`SupRev_NAS_H1` 970913 domina l'ORB su tutti e tre gli assi** (n 172 · PF 1,65 · DD **1,48%** · 0,34 op/g) e **non e' sul reale** | **Claudio** | *"C'e' una ragione — che io non trovo nei file — per cui la 970913 non e' fra le due sedie del conto reale?"* |
| 5 | 📏 **`EMA200 U30USD` 771531 fa 1,55 op/giorno da sola** (n 712 · PF 1,42 · DD 6,48%): **il motore piu' veloce della flotta**, e da solo supererebbe il pavimento di famiglia | **Claudio** | *"Perche' il motore piu' veloce e con DD dentro il muro sta sul demo piccolo e non nel piano della challenge?"* |
| 6 | 🔴 **C0 non ha ancora un banco di prova cieco** | **cacciatore-config-prop** | *"Esiste una prop che pubblica il PF minimo dei suoi funded? Se una fonte esterna indipendente dice un numero vicino a 1,10, il cancello smette di essere solo nostro"* |
| 7 | ⚠️ **Foto `.chr` dei tre terminali ferma al 25/08** (buco gia' dichiarato in `CENSIMENTO_CONTRATTI.md` §5) | **Claudio** | ~10 minuti, rischio zero. Senza quella, ogni riga di flotta di questo file e' **approssimata** |

---

## 7. 🏁 LE CINQUE RIGHE DA PORTARSI VIA

1. ✅ **La struttura c'e'**, ed e' **un pavimento sul PF**, non una banda su `n`.
   **13 bocciati per rischio su 13 hanno PF ≤ 1,19.**
2. 🔴 **Il numero di operazioni NON separa niente**: 25 righe su 39 stanno nella
   zona buona con `n` da 13 a 712, e la riga con **712 operazioni ha DD 6,48%**.
3. 🟡 **"I lenti hanno PF piu' alto" e' un artefatto**: −0,879 sotto le 150
   operazioni, **−0,011 sopra**. E' la conferma quantitativa di una regola di
   casa che finora era solo prudente.
4. 🚨 **Il collo di bottiglia dell'imbuto e' l'EDGE, di cinque volte.** 43 morti
   per edge contro 8 per frequenza — e **i 14 morti "per rischio" sono morti per
   edge anche loro** (PF ≤ 1,19, tutti). **Allargare i cancelli di frequenza non
   produrra' sedie.**
5. 🎯 **La cosa piu' scomoda che ho trovato, e non era nel mandato**: le due
   sedie vive **non sono l'optimum** dei nostri stessi dati. `SupRev_NAS_H1`
   le batte su tutti e tre gli assi e sta sul demo. **Prima di cercare motori
   nuovi a 23 giorni dalla challenge, varrebbe la pena guardare quelli che
   abbiamo gia' misurato e non abbiamo mai schierato.**

---

_Fonti principali: `backtest_pipeline/risultati_archivio/R103_REFERTO_FINALE.md` ·
`R103_REFERTO_BLOCCO1_INDICI.md` · `R109_REFERTO.md` · `R110_REFERTO.md` ·
`ancora_passo7/*.csv` · `r118_csv/*.csv` · `r116_londonfx/*.txt` ·
`report/CENSIMENTO_CONTRATTI.md` · `report/CORSIA_DEMO_CANDIDATI.md` ·
`report/RIPESCAGGIO_FREQUENZA_2026-09-08.md` · `report/P0_LVNARBITRO_2026-09-08.md` ·
`report/P0_OPENINGREVERSALB_2026-09-08.md` · `report/PASSO7_ANCORA_SUPERATA_2026-09-08.md` ·
`report/PERCHE_NON_ARRIVIAMO_2026-09-07.md` · `backtest_pipeline/prove/R52_CENSIMENTO_LATI.md` ·
`backtest_pipeline/REGISTRO_TEST.md` · `mql5/Experts/ABTG_DAX_Apertura_EU.mq5` ·
`mql5/Experts/ABTG_ORB_Ottimizzato.mq5`._

_Riferimento del meccanismo (§5.1): Magdon-Ismail & Atiya, "Maximum Drawdown",
Risk Magazine, 2004 — **citato come meccanismo, non come misura nostra**._

## 📋 CHANGELOG
| data | cosa |
|---|---|
| 08/09/2026 | Prima stesura. Censimento di ~71 righe-verdetto, 39 righe omogenee R103, 22 righe di bocciatura per rischio. Proposto il cancello **C0 (PF ≥ 1,10 sulla finestra peggiore, solo se n ≥ 150)** — **PROPOSTO, non congelato**. Smontata la meta' "banda di mezzo" del sospetto; confermata la meta' "PF a ridosso di 1". |
