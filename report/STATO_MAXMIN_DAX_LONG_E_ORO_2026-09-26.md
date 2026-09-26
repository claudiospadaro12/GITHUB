# STATO MAXMIN: DAX LATO LONG e ORO `770402` — i numeri misurati prima della firma

**26/09/2026** · branch `lavoro`, HEAD `2bba2d31` · **SOLA LETTURA**: nessun backtest, EA, preset
o forward toccato. Nessun file prova scritto. Bersaglio discusso: FTMO `541452707` (`C:\FTMO`).
Taglie e accensioni restano **firme di Claudio**.

---

## 0. Le due righe di verdetto

| richiesta | verdetto |
|---|---|
| **(1) MaxMin DAX LONG "ottimizzato"** | 🔴 **NIENTE DA FIRMARE.** Il lato long e' stato misurato in **34 celle a tick reali, 0 sopra PF 1,00** (PF 0,547-0,947, n 85-206 deal). Non e' "morto per interruttore": e' misurato e negativo. Il certificato del 09/09 pero' e' **incompleto** (manca il TF di gestione e il filtro S&P a specchio non e' mai stato acceso sul long), quindi in `REGISTRO_TEST` va scritto **NON ANCORA MISURATO (TF, correlazione)**, non "morto". **Un EA "MaxMinNotte DAX LONG Ottimizzato" non esiste** (§A.0). |
| **(2) MaxMin ORO `770402`** | 🔴 **BOCCIATA PER RISCHIO ALLA TAGLIA DEL PRESET (2,00%)** e **NON ANCORA MISURATA sul binario da schierare**. Misurato: **PF 1,308 · n 693 · DD 5,32% a 0,5%** (R103, OHLC M1, 2020-2026, geometria del preset). Riportato a 2,00% in modo lineare fa **~21,3%**, contro il muro FTMO statico del 10% e la soglia congelata di R193b (8,0%). I due round che chiudono i buchi (`R193a`/`R193b`, 12 passate, meno di 4 minuti) **non sono mai girati**. |

---

# A. MAXMIN DAX — LATO LONG

## A.0 Il nome: che cosa esiste davvero
- In `mql5/Experts/` ci sono solo `ABTG_MaxMinNotte.mq5` (generico, due lati, v1.11) e
  `ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5` (`770411`, solo short). **Un "DAX LONG
  ottimizzato" della famiglia MaxMin non c'e'.**
- ⚠️ **Possibile equivoco da chiarire con Claudio**: il "DAX LONG" gia' in campo su FTMO e'
  `770101` `ABTG_DAX_Apertura_EU` (preset `FTMO/ABTG_DAX_Apertura_EU_770101_FTMO.set` r.227-228:
  `InpAllowLong=true`, `InpAllowShort=false`). E' un altro motore (apertura), non il box notturno.

## A.1 Il lato long, tutte le misure in archivio

| round | fonte (commit) | modello | finestra | rischio | celle long | PF long | DD long | n (deal) |
|---|---|---|---|---:|---:|---|---|---|
| griglia `valid_MaxMin` 26/07 | `risultati_archivio/MaxMinNotte/080957cf-valid_MaxMin_D30EUR.csv` (`a86089c8`) · ini `ini/valid_MaxMin_D30EUR.ini` | tick (Model=4) | ini 2024.01.01 → 2026.06.30; dati D30EUR dal 2024.09.26 | 1,0% (dep. 10.000) | **18** (buffer 500/1000/1500 × TP2 1,5-4,0) | **0,716-0,947** | **10,31-23,95%** | 145-173 |
| `R242a` box del giorno prec. | `risultati_archivio/R242/..._IS_R242a.csv` (`c1d3b214`) · `report/REFERTO_R242_2026-09-24.md` | tick | 2024.09.26 → 2026.06.30 | 0,65% (dep. 100.000) | **7** (`InpBoxStartHour` 0-18) | **0,732-0,941** | **4,14-6,34%** | 134-188 |
| `R244b` cutoff d'ingresso | `risultati_archivio/R244/ROUND_R244b/..._IS_R244b.csv` (`b413f2ef`) · `report/REFERTO_R244_2026-09-24.md` | tick | 2024.09.26 → 2026.06.30 | 0,65% | **9** (`InpEntryCutoffHour` 9-17) | **0,547-0,906** | **4,57-6,27%** | 85-206 |
| **totale** | | | | | **34** | 🔴 **0 celle ≥ 1,00** | | |

Numeri riletti **da me sui CSV**, non dai referti. Cella migliore in assoluto: **0,94712**
(archivio, buffer 500, TP2 1,5, n 173, DD 10,31% @1%).

- **n in POSIZIONI (Emendamento A)**: `InpTP1Pct=50` in tutte le righe, quindi `Trades` conta
  **deal**. Misurato sul per-trade di R244b a C=17: **206 deal = 145 posizioni, k = 1,4207**
  (`REFERTO_R244` §2). 👉 **Nessuna cella long arriva a 150 posizioni**: il merito, alla lettera,
  e' **sospeso** (la prima stesura di R242 diceva *"si legge"* ed e' stata ritirata dallo stesso
  referto; `report/CHI_E_PIU_VICINO_AL_CAMPO_2026-09-24.md` r.276 riporta ancora la versione
  ritirata).
- **Ma il segno e' concorde in 34 celle su 34**, attraverso due stop (1,5 e 2,5 × ATR M15),
  sette box, nove cutoff, tre buffer e sei TP2. E lo stop allargato 7 volte ha mosso il PF di
  **+0,002** (`REFERTO_R242`, 0,7302 → 0,73216).
- 🔴 **Il preset generico `mql5/Presets/ABTG_MaxMinNotte_DAX.set` e' GIA' una cella misurata**:
  due lati, buffer 1000, TP2 2,5, ATR 1,5, correlazione OFF = nel CSV d'archivio **PF 0,90443 ·
  DD 14,38% @1% · n 255**. Differisce solo per `InpMaxSpread` (500 contro 0) e `InpRiskPercent`
  (2,0 contro 1,0). **Attaccato cosi' com'e', porterebbe in campo un PF sotto 1.**

## A.2 Rischio alla taglia FTMO (si legge a qualunque n, Emendamento B)

| misura | DD misurato | a 2,00% (lineare, `[DERIVATO]`) |
|---|---|---|
| archivio, long, @1% | 10,31-23,95% | **20,6-47,9%** |
| R242a + R244b, long, @0,65% | 4,14-6,34% | **12,7-19,5%** |

👉 **Nessuna cella long misurata starebbe sotto il muro statico del 10% alla taglia uniforme
del 2,00%.** E' una proiezione lineare di DD misurati a tick (non una misura a 2,00%).

## A.3 Come `ABTG_MaxMinNotte.mq5` applica la correlazione al long
`CorrBias()` r.698-708: EMA14 contro EMA100 di `InpCorrSymbol` su `InpCorrTF` (H1). `+1` →
**solo long**, `-1` → **solo short**; r.341-343 `longOK=(bias==0||bias==+1)`. **Il filtro a
specchio ESISTE nel codice** (long solo se lo S&P tira in su).
🔴 **Non e' MAI stato acceso sul long**: `InpUseCorrelation=0` in tutte le 18 righe long
d'archivio, e `false` pinnato in `R242a` (prova r.138-144, scelta dichiarata: *"il filtro divide
il campione per ~2,4"*) e in `R244b`. Gli unici round con correlazione ON (`R104`, `R191a`,
`R194a`, `R206a`, `valid_MaxMin_DAX_short_refine`) sono tutti `InpAllowLong=false`.

## A.4 Certificato del 09/09 sul lato long

| # | requisito | stato |
|---|---|---|
| ① | PF misurato | ✅ 34 celle, tick, max 0,947 |
| ② | n e DD | ✅ n 85-206 deal (≤ 145 posizioni) · DD sopra |
| ③ | uscita ad asse | 🟡 **parziale**: solo `InpTP2_R` (archivio, 6 valori; 3,5 e 4,0 danno esiti **identici** in tutti e tre i buffer = manopola inerte oltre 3,5). Trailing, breakeven, parziale: mai ad asse sul long. R81 (le 6 uscite) e' sul `770411` short |
| ④ | simboli gemelli | ✅ `F40EUR` long max **0,99852**, `E50EUR` long max **0,83979** (stesse griglie tick, `REGISTRO_TEST` r.633-657) |
| ⑤ | TF cambiato | 🔴 **NO**: il box si legge sempre su `PERIOD_M1` (r.308-318), l'unico asse TF vero e' `InpMgmtTF`, e vale **15 in ogni corsa DAX** (`R214g` e' scritto solo per lo short e mai girato) |
| extra | filtro S&P a specchio | 🔴 **mai acceso sul long** (§A.3) |

👉 **Verdetto per il registro: "NON ANCORA MISURATO (⑤ TF di gestione, ③ uscita, correlazione
a specchio)", con il PF 0/34 accanto.** Buco da chiudere: **`REGISTRO_TEST.md` non ha nessuna
riga per R242 e R244** (grep: zero occorrenze), e il lato long non compare con numeri.

## A.5 Il round piu' corto (NON scritto: la decisione di spenderlo e' di Claudio)
Due file, una variabile ciascuno, ancora = cella `R244b` C=12 (PF **0,74387**, n **157**, deve
riprodursi al centesimo):

| file | asse | celle | cosa chiude |
|---|---|---:|---|
| L1 | `InpUseCorrelation` 0/1, solo long | 2 | lo specchio del filtro che sullo short ha raddoppiato il PF |
| L2 | `InpMgmtTF` M15/M20/M30/H1/H2/H3/H4, solo long | 7 | punto ⑤ del certificato |

**Costo**: 9 passate. Base misurata: **0,700 min/passata** (`R104_REFERTO_DRIVER_20260825_0738.txt`
r.15, stesso EA/simbolo/TF a tick) → **~6,3 min**; R244 reale ha fatto 18 passate in 5 minuti
(`REFERTO_R244` intestazione) → **~2,5 min**. Banco: PC di backtest, **non** il VPS (regola del 21/09).
**Attesa dichiarata ora**: con correlazione ON, n ≈ 157 / 2,4 ≈ **65 deal ≈ 46 posizioni** → sotto
50, cioe' **"NON MISURATO — campione" qualunque sia il PF**; il rischio si leggera' lo stesso.
🔴 **Detto chiaro: nessun round sui dati BCM puo' dare al long un verdetto di MERITO prima del 1°
ottobre.** Lo storico indici BCM parte dal **2024.09.26 ed e' COMPLETO** (`REFERTO_R242`,
`STORICO_MT5BACKTEST_ESITO_2026-09-08.md` r.38-40); il round chiude il certificato, non apre una sedia.

---

# B. MAXMIN ORO `770402`

## B.1 Le misure della cella, con la geometria dichiarata

| round | fonte (commit) | binario | modello | finestra | box / piazza / cutoff (ora BCM) | rischio | **PF** | **n** | **DD** |
|---|---|---|---|---|---|---:|---:|---:|---:|
| **R103** | `risultati_archivio/R103_REFERTO_DRIVER_FOREX_METALLI_20260824_1922.txt` blocco F23 (`05622a77`) · prova `prove/R103_ABTG_MaxMinNotte_XAUUSD_770402.txt` | `5fc0bc31` (per blob, `SEDIA_770402_COSA_MANCA` §1.1) | **OHLC M1** | 2020.01.01 → 2026.06.30 | **23:00-04:59 / 07:00 / 08:30 = GEOMETRIA DEL PRESET** | 0,5% | **1,308** (seconda misura dai deal: 1,314) | **693** | **5,32%** @0,5% (10,64% @1% lineare) |
| R100 | `risultati_archivio/R100_REFERTO.md` r.15 (`fa555567`) · prova `prove/R100_...770402.txt` | `5fc0bc31` | OHLC M1 | 2004.06.11 → 2026.06.30 | **22:00-06:59 / 07:00 / 09:30** (geometria R17, NON quella del preset) | 1,0% | `[NON PUBBLICATO]` | `[NON PUBBLICATO]` | **19,72%** @1% |
| R17 (contratto originale) | `risultati_prove/MaxMin_Oro_r17/..._OOS_r17.csv` (`3837d3de`), magic 770402 | pre-`5fc0bc31` | tick `[INFERITO dal nome senza _ohlc]` | da 2025.03.01 | 22:00-06:59 / 07:00 / 09:30 | 1,0% | OOS **1,908** | OOS **82** | OOS **5,32%** |
| R19b | `risultati_prove/MaxMin_Oro_r19/..._OOS_r19b.csv` | pre-`5fc0bc31` | tick `[INFERITO]` | da 2025.03.01 | 22:00-06:59 / 07:00 / 09:30 | 1,0% | OOS **2,452** | OOS **92** (= **68 posizioni**, per-trade 770405) | OOS **4,24%** |
| forward piccolo | `data/statements/trades_auto.csv` (`5223477d`) | `08239510` (senza fix) | reale | 11/08 → 23/09/2026 | preset | 0,5% (lotto sempre 0,01) | **1,86** (calcolato qui) | **12** | `[NON MISURATO]` |

- 👉 **Il numero di merito valido e' R103**: unica misura con n ≥ 150 **e** con la geometria del
  preset che si schiererebbe. R17/R19 hanno n < 150 e un'altra geometria (la sedia ha girato
  sul piccolo su una finestra diversa dal contratto R17: `LA_SEDIA_ORO_GIRA_ALTROVE_2026-09-11.md`).
- **n 693 sono deal**: con k = 1,353 (per-trade XAUUSD 92/68, `REGISTRO_TEST` r.3977) ≈ **512
  posizioni** `[DERIVATO]` — sopra 150 comunque.
- Anni negativi R103: **2021 e 2023** (2/7). Peggior giornata −0,50% @0,5%.
- 🔴 **R103 e' OHLC**: il DD e' un **limite inferiore** (tick oro BCM dal 2024.07.05, finestra dal 2020).

## B.2 Il rischio alla taglia del preset — il numero che decide

| | valore | fonte |
|---|---|---|
| DD misurato | **5,32% @0,5%** | R103 F23 |
| DD a 2,00% (preset FTMO r.`InpRiskPercent=2.00`) | **~21,3%** `[DERIVATO lineare ×4]` | — |
| DD 22 anni, altra geometria | 19,72% @1% → **~39%** @2% `[DERIVATO]` | R100 |
| muro FTMO | **10% statico** | `docs/REGOLAMENTO_FTMO_2026-08.md` r.27 |
| soglia congelata prima dei numeri | **DD @2,00% > 8,0% → non si schiera a 2,00%** | `prove/R193b_taglia_MaxMinNotte_XAUUSD.txt` |
| taglia che il lineare porta a 8,0% | **~0,75%** (R103) · **~0,41%** (R100) `[DERIVATO]` | — |

🔴 Anche solo a 1% il DD R103 (10,64%) sta sopra la soglia di 8,0%. Scendere sotto la taglia
uniforme tocca il divieto FTMO di size erratiche (commento nel preset stesso): **firma di Claudio**.

## B.3 Il binario: `d4da7d7`, C9 e cosa manca su `C:\FTMO`
- ✅ **`d4da7d7` (06/08) E' la correzione**, ed e' dentro HEAD: `ABTG_MaxMinNotte.mq5` r.418-431
  separa `parzOK` da `beFatto`, il breakeven non dipende piu' dalla parziale. HEAD del file =
  **`7d0da9f9`** (03/09, v1.11, 918 righe; nessun commit dopo). Ce l'ha anche il binario del
  contratto `5fc0bc31`. Lo aveva **solo il binario sul piccolo** (`08239510`), e a 100k/2,00% il
  difetto e' comunque irraggiungibile (servirebbe uno stop > 1.000 $/oz; `SEDIA_770402_COSA_MANCA` §1.2).
- 🔴 **C9 (`SelPos()` cieco) e' ancora a HEAD**, r.772 (`PositionSelect(_Symbol)`). Morde solo con
  un'altra posizione XAUUSD sullo stesso conto: **oggi su FTMO non ce n'e'** (le sei sedie sono
  D30EUR/U30USD/NASUSD). Si riapre alla seconda sedia oro. (Nota: `770411` ha gia' la versione
  hedge-safe, `ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5` r.470.)
- 🔴 **Il binario non c'e' su FTMO**: `RINOMINA_CLAU12.ps1` r.129-135 rinomina **sette** file —
  sei sedie (`770101`, `770411`, `770202`, `771531`, `770511`, `770260`) + Guardian `779001`.
  `ABTG_MaxMinNotte.mq5` **non e' fra loro** ed e' stato escluso di proposito dallo schieramento
  (`SCHIERAMENTO_FTMO_2026-09-20.md` §5.2 e §6.2: *"un preset senza il suo EA e' una trappola"*).
  Per accenderla servono: `.mq5` al pin `7d0da9f9` + F7 contro l'include gia' in campo
  (`26a18566`, v1.20: la firma `ABTG_GuardiaIngresso(attiva,chi)` a r.282 e' compatibile; **la
  compilazione e' `[NON VERIFICATA]`**) + eventuale rinomina CLAU12 + riga passata dai cancelli.
  `InpAutoTest` (default `true` a HEAD r.188) non e' pinnato nel preset: innocuo, stampa e basta.
- 🔴 **Binario del contratto ≠ binario da schierare**: fra `5fc0bc31` e HEAD c'e' solo la guardia
  "un trade al giorno", dichiarata inerte nel tester. **`R193a` (4 passate) e' il controllo, e non
  e' mai girato.** Nemmeno `r151a`/`r170b` (uscite su questa sedia, girati 15-17/09): CSV mai
  caricati.

## B.4 Il costo (frontiera `stop >= 40 x spread`)

| | valore | fonte |
|---|---|---|
| spread XAUUSD FTMO | **45 punti = 0,45 $** (mediana e P95, ora 10 server = finestra d'ingresso) · 47 a mercato chiuso | `SPREAD_APERTURA_FTMO_2026-09-21.md` r.34 · `risultati_prove/PREVOLO_FTMO_specifiche_2026-09-20.csv` |
| stop mediano della sedia | **32,94 $** `[MISURATO]` | `QUANTE_SEDIE_CI_STANNO_2026-09-23.md` r.184 |
| rapporto | **73,2×** 🟢 PASS (stop minimo visto 25,23 $ → **56×**) | — |
| frontiera | stop ≥ **18,0 $** | — |
| commissione FTMO | `[NON MISURATO]` → i × sopra sono un **tetto** | `MAPPA_COSTO_SIMBOLI_TF` r.443 |
| 🟠 `InpMaxSpread=150` nel preset | ammette spread fino a 1,50 $ = **22×** sullo stop mediano: **il filtro non difende la frontiera**. Proposta del 20/09 (60 punti) **mai applicata** | preset FTMO |

## B.5 L'orologio
- Preset FTMO: box **01:00-06:59 FTMO**, piazza **09:00**, cutoff **10:30** = **00:00-05:59 /
  08:00 / 09:30 ora italiana** (FTMO = IT+1 tutto l'anno). Valido cosi' fino al **25/10**, come
  scrive il preset.
- 🟠 **Fatto nuovo da portare, NON applicato**: la premessa della "scadenza" nel preset (*"se FTMO e
  BCM cambiano nello stesso giorno il delta resta +2"*) e' superata dalla misura del 24/09 — BCM
  e' **UTC+1 fisso** e non cambia piu'. Ma cio' che conta e' **quale ora italiana ha misurato
  R103**: dal 2020 al dicembre 2024 il feed forex BCM era **IT−1 tutto l'anno**, quindi R103 ha
  misurato il box **00:00-05:59 IT anche d'inverno** su ~5 dei suoi 6,5 anni; solo l'inverno
  2025/26 e' stato misurato un'ora prima. 👉 **Dopo il 25/10 il preset FTMO invariato resta
  sull'ora della maggior parte di R103** (anche la griglia H2 di `InpMgmtTF` torna: barre alle ore
  dispari italiane in entrambi). `[INFERITO]`: `OROLOGIO_BCM_2026-09-24.md` non ha un'ancora
  specifica per XAUUSD; assumo che l'oro segua l'orologio forex (stesso rollover).

## B.6 Guardian e cluster
- **C1 in campo a 4,00%** (`GUARDIAN_SEI_SEDIE_2026-09-24.md` r.26, r.371): a 2,00% per sedia =
  **due posizioni a stop contemporanee in tutto il conto**.
- 🟠 L'oro arma alle **08:00 IT**, `770411` alle **08:59 IT**, `770101` alle **09:00 IT**: tre sedie
  nella stessa ora e mezza contendono **due posti**. Quante mattine si sovrappongono: `[NON MISURATO]`.
- L'oro e' un **cluster nuovo**. Il tetto per cluster C2 **non e' attivo** (e nessun EA lo legge:
  `CLAUDE.md`, emendamento del 12/09 sera). Margine: **4.253 EUR = 5,32%** del conto a 2,00%
  (`QUANTE_SEDIE` r.184).

## B.7 Cosa manca, per nome, e cosa costa

| buco | costo | stato |
|---|---|---|
| PF/n/DD sul binario HEAD (`R193a`) | 4 passate, ~1 min (base misurata 10,2 s/passata, `REFERTO_RUNNER_20260915_033005.txt` r.465-470) | file pronto, **mai girato** |
| curva DD(taglia) 0,5→2,0 (`R193b`) | 8 passate, ~2 min | file pronto, **mai girato** |
| uscite `r151a` (7 celle) + `r170b` (2 celle) | **0 min**: e' un trasporto | girati 15-17/09, **CSV mai caricati** |
| DD a tick reali | la finestra tick parte dal 2024.07.05: solo ~2 anni | `[NON MISURATO]` |
| commissione FTMO oro | una lettura sul terminale | `[NON MISURATO]` |
| sovrapposizione mattutina con `770411`/`770101` sotto C1 | incrocio dei per-trade | `[NON MISURATO]` |

---

## Il contro-esempio, provato contro i due verdetti
- **Long DAX**: *"sullo short la correlazione ha portato il PF da 1,19 a 2,05, magari sul long fa
  lo stesso"*. E' l'argomento piu' forte e **non lo smentisco**: e' il motivo per cui il verdetto e'
  "non ancora misurato" e non "morto". Ma anche se il filtro rendesse il long positivo, il campione
  scenderebbe a ~46 posizioni: **niente di firmabile per il 1° ottobre** in nessuno dei due esiti.
- **Oro**: *"il DD OHLC e' vecchio, il 2021 pesa, sul recente la sedia va bene (forward PF 1,86)"*.
  Il forward e' n=12 (merito sospeso), e il DD e' un fatto accaduto (Emendamento B): il 2021 fa
  parte di cio' che la sedia ha fatto. E l'OHLC **sottostima** il DD, non lo gonfia: la correzione
  andrebbe nel verso sbagliato per la firma.

_Fonti: quelle in tabella, lette sul branch `lavoro` a HEAD `2bba2d31`; numeri dei CSV
ricontati in questa sessione con `csv.DictReader`._
