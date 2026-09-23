# 🔎 L'ORB SUL NASDAQ: PERCHÉ È SPENTO — e che cosa dicono **I NOSTRI** numeri

**23/09/2026** · domanda di Claudio: *«un collega dice che l'ORB sul Nasdaq dà sempre belle
soddisfazioni — perché non lo riattiviamo?»*

🔴 **Regola di questo referto, dichiarata prima dei numeri**: la frase del collega è
un'**ipotesi da misurare**, non una fonte. Non compare più da qui in avanti e **non sostiene
niente**. Quello che segue è misurato in casa, file e riga.

🚫 **Sola lettura.** Zero backtest, zero righe di lancio, zero preset toccati, zero sedie
accese o spente. La challenge FTMO `541452707` sta operando: le sei sedie non si toccano.
**Io propongo, decide Claudio.**

---

# 🎯 LA RISPOSTA IN CINQUE RIGHE

> ## 1. **L'ORB sul Nasdaq non è "spento": è già acceso, in un'altra forma.** La sedia **6 su 6** della challenge, `770260` *Nasdaq RETEST*, è **la famiglia apertura sul Nasdaq** — con `InpEntryMode=2` (RETEST) invece del breakout nudo. OOS **PF 1,21546 · 102 posizioni · DD 7,86%** alla taglia vera.
> ## 2. **Il BREAKOUT nudo sul Nasdaq è l'unica cosa che abbiamo davvero ucciso, e con i numeri**: `R97`, quattro geometrie di stop, **tick reali**, **stessi ingressi**, **PF OOS 0,84 / 0,86 / 0,89 / 0,91 su n=135**. Non è la geometria: **sono gli ingressi**.
> ## 3. 🔴 **MA su OTTO varianti ORB-apertura su NASUSD che oggi non operano, il CERTIFICATO DI MORTE è completo in ZERO casi.** Il verdetto corretto su sette di esse è **«NON ANCORA MISURATO»**, non «morto».
> ## 4. 💸 **Ricompilando il cancello del costo sullo spread FTMO `US100.cash` (1,53 invece di 1,80 BCM), NESSUNA sedia spenta che prima non passava passa adesso.** La più vicina, `770601`, va da **26,5×** a **31,2×**: manca ancora il **28%** per arrivare al 40×.
> ## 5. ❓ **Nessuna sedia ORB-Nasdaq spenta merita di essere riaccesa oggi** — e la riga più onesta del referto è questa: **`770601` non fu spenta per il rendimento** (chiuse a **+351,51 su 20 operazioni**), fu spenta per un **bug**. Ho cercato apposta quel contro-esempio, l'ho trovato, e §7 mostra perché non regge.

---

# 1. 🗂️ CHI SONO — l'elenco PER NOME delle varianti ORB/apertura su NASUSD

Cercate io, non prese dal mandato. Fonti: `mql5/Presets/*.set`, `mql5/Experts/*.mq5`,
`FLOTTA_ATTIVA.md`, `backtest_pipeline/REGISTRO_TEST.md`, e i magic realmente presenti in
`data/statements/trades_auto.csv` (1.333 righe, fino al **22/09/2026 20:37**).

| # | variante | EA | magic | TF | geometria d'ingresso | stato **oggi** |
|---|---|---|---:|---|---|---|
| 1 | **Nasdaq RETEST** | `ABTG_Nasdaq_Apertura_US` | **`770260`** | M5 | range **35'** · `EntryMode=2` RETEST | 🟢 **VIVA — challenge FTMO** |
| 2 | Nasdaq Apertura US (breakout) | `ABTG_Nasdaq_Apertura_US` | `770201` | M5 | `RangeMode=2` (candela **H1** prec.) · `EntryMode=0` | 🔴 spenta **18/08** |
| 3 | Nasdaq Apertura US **OTT** | `ABTG_Nasdaq_Apertura_US_Ottimizzato` | `770211` | M5 | idem, cella ottimizzata | 🔴 spenta **18/08** |
| 4 | Nasdaq **Live5m** | `ABTG_Nasdaq_Live5m` | `770203` | M5 | candela **5'** pre-apertura · cancello 17-40 idx | 🔴 spenta (ultimo trade **06/08**) |
| 5 | Nasdaq **GatedShort** | `ABTG_Nasdaq_Apertura_US` | `770250` | **M15** | breakdown **solo SHORT** + gate EMA 50×200 H4 | 🟠 **viva sul DEMO BCM 50503392**, **fuori** dalla challenge |
| 6 | **ORB** (del corso) | `ABTG_ORB` | **`770601`** | M5 | range **14:25-14:30** (5', PRE-apertura) · `SLMode=0` OPPRANGE | 🔴 spenta **10/08** |
| 7 | **ORB Fibo** | `ABTG_ORB_Fibo` | `770602`/`770603` | M5 | OR 30' → LIMIT in Golden Zone 50-61,8% · SL 78,6% | ⚪ **mai in campo** |
| 8 | **ORB Ottimizzato** su NASUSD | `ABTG_ORB_Ottimizzato` | *(nessuno: le corse portano `770611`, il magic della sedia **Dow**)* | M5 | range **14:30-14:45** (15') | ⚪ **mai in campo** |
| 9 | Apertura 3 Ingressi | `ABTG_Apertura_3Ingressi` | `777010`/`777020`/`777030` | M5 | tre ingressi alternativi | ⚪ **mai in campo** |
| 10 | **GAPFILL** Nasdaq | `ABTG_Nasdaq_Apertura_US` | `770202` *(nel preset — 🔴 **collide col Dow Apertura**)* | M5 | `EntryMode=1`, chiusura del gap d'apertura | ⚪ **mai in campo** |
| 11 | *(esterno)* PreOpen Breakout | `Nasdaq_PreOpen_Breakout_EA` | `20260617` | M5 | candela 14:25-14:30 | ⚪ **mai girato** |
| 12 | *(preset gemello di #2)* Apertura Nasdaq H4 | `ABTG_Nasdaq_Apertura_US` | `770201` | M5 | #2 + filtro EMA50 H4 | ⚪ stesso magic di #2 |

🔴 **L'elenco del mandato ne aveva tre (`770601`, `770250`, `770211`): sono DODICI righe, e
tre di queste non avevano mai avuto un nome in nessuna tabella** (#9, #10, #12).

## 1.1 🟢 `770260` **HA OPERATO in campo?** — verificato, e la risposta è **NO**

Il mandato chiedeva di ricontrollare r.225 di `SCHIERAMENTO_FTMO_2026-09-20.md`
(*«0 — magic mai girato in campo»*). **Ricontrollato in tutte le fonti di campo in repo:**

| fonte | copertura | operazioni `770260` |
|---|---|---:|
| `data/statements/trades_auto.csv` (demo BCM 50503392) | fino al **22/09 20:37** | **0** |
| `data/statements/trades_100k.csv` (100k 50504263) | fino al **22/09 11:13** | **0** |
| `report/giornata_2026-09-21.md` · `giornata_2026-09-22.md` | 21-22/09 | **0** |
| referti FTMO 21-23/09 | challenge | **0** *(l'unica operazione FTMO documentata è lo stop di `771531` del 22/09, `report/PRIMO_STOP_FTMO_2026-09-22.md`)* |

> 🔴 **E il motivo per cui la risposta non può essere più precisa va detto: sul conto FTMO
> `541452707` NON gira un `ABTG_TradeExporter` che finisca in repo.** L'unico canale sono le
> schermate del telefono di Claudio. 👉 **«Zero operazioni» qui vuol dire «zero operazioni
> documentate», e la differenza non è cosmetica.** `[MISURATO su ciò che c'è]` ·
> `[NON MISURATO: il libro affari FTMO]`.

📊 Contesto: la frequenza promessa di `770260` è **0,370 op/giorno**
(`report/IL_PIANO_DEGLI_OTTO_GIORNI_2026-09-23.md` r.75-83). Con la challenge partita il
**21/09**, **zero operazioni in tre sedute è dentro l'atteso** (~1,1 attese): non è un sintomo.

---

# 2. 🪦 LA TABELLA DEI CERTIFICATI DI MORTE

Regola di casa del 09/09: servono **cinque** cose per scrivere «morto» —
① un **PF** misurato · ② un **n** e un **DD** · ③ la **gestione dell'uscita** ad asse almeno
una volta · ④ i **simboli gemelli** provati · ⑤ il **TF** cambiato almeno una volta.
🔴 **Se ne manca una, il verdetto è «NON ANCORA MISURATO».**

| variante | ① PF | ② n + DD | ③ uscita ad asse | ④ gemelli | ⑤ TF | **verdetto oggi** | **cosa manca, per nome** |
|---|:--:|:--:|:--:|:--:|:--:|---|---|
| **`770260` RETEST** *(viva)* | ✅ | ✅ | ✅ | 🟡 | 🟡 | 🟢 **VIVA, merito sospeso** (102 pos < 150) | ④ CSV **solo NASUSD** · ⑤ `InpLevelTF` **mai mosso** (H1 ovunque), `InpSessionHour` mai ad asse |
| **`770201` breakout** | ✅ | ✅ | ✅ | 🔴 | 🔴 | ⚪ **NON ANCORA MISURATO** | ④ **zero gemelli** su questo binario · ⑤ **nessun TF mai mosso**: il file `NASDAQ_openconfirm_M15` **NON è un cambio di TF** (§2.2) |
| **`770211` OTT** | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 | ⚪ **NON ANCORA MISURATO — 0 su 5** | **tutto**: nessun CSV in repo, nessun per-trade (`IL_DRAWDOWN_CHE_NON_ABBIAMO_MISURATO_2026-09-18.md` r.524, r.880) |
| **`770203` Live5m** | ✅ | ✅ | 🔴 | 🟡 | 🔴 | ⚪ **NON ANCORA MISURATO** | ③ asse uscita **mai girato su `RangeMode=1`** · ④ solo D30EUR, mai U30USD/SPXUSD · ⑤ TF d'**ingresso** mai toccato (firma di Claudio) |
| **`770250` GatedShort** | ✅ | ✅ | 🔴 | 🔴 | 🟡 | ⚪ **NON ANCORA MISURATO** | ③ `InpCloseAtEnd`/`InpRunnerTP_R` **mai in nessun CSV** (`CENSIMENTO_USCITE_MAI_PROVATE_2026-09-11.md` r.165) · ④ nessun gemello · ⑤ M15 esiste **solo** come `InpOCTimeframe`, non come TF di grafico |
| **`770601` ORB** | ✅ | ✅ | 🔴 | 🔴 | 🔴 | ⚪ **NON ANCORA MISURATO** | ③ `InpBreakeven`/`InpUseTrailEMA`/`InpTP1Pct`/`InpExitOnEmaClose` **mai ad asse** · ④ **`ABTG_ORB` non ha MAI girato su un altro simbolo**: 8 CSV in tutto, tutti NASUSD · ⑤ `InpExecTF`=M5 in **tutte** le passate |
| **`770602` ORB Fibo** | 🟡 | 🟡 | 🔴 | 🔴 | 🔴 | ⚪ **NON ANCORA MISURATO** | ① PF **solo OHLC**, **zero passate a tick** · ② n OOS **75 < 150** · ③ mai · ④ mai · ⑤ `InpExecTF` e `InpORMinutes` mai mossi |
| **ORB Ottimizzato · NASUSD** | ✅ | ✅ | 🟡 | ✅ | 🔴 | ⚪ **NON ANCORA MISURATO** | ③ `InpBreakeven`, `InpAtrSLmult`, `InpSLFixedPts` mai ad asse su NASUSD · ⑤ `InpExecTF`=M5 in tutte le 216 passate; **il LATO non è mai stato un asse** (216 passate, tutte `(1,1)`/`(1,0)`/`(0,0)` — `IL_CORTO_DI_DAX_E_NASDAQ_2026-09-23.md` r.149) |
| **Apertura 3 Ingressi** | ✅ | ✅ | 🔴 | 🟡 | 🔴 | ⚪ **NON ANCORA MISURATO** | ③ mai · ⑤ mai. 🔴 **E l'asse dei tre CSV è `InpMagic`** (777010/777011 ecc.): **asse TECNICO**, 2 passate = 1 esito |
| **GAPFILL** | ✅ | 🟡 | 🔴 | 🔴 | 🔴 | ⚪ **NON ANCORA MISURATO** *(+ 🛑 bloccata da una REGOLA, §6)* | ② n OOS **16-43**, merito sospeso · ③④⑤ mai |
| **PreOpen esterno** | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 **NON SI SCHIERA** — e non per il PF: **fuso cablato** (`InpLocalUtcOffsetHours=2`) che dal 01/11 arma **un'ora prima in silenzio** | *(bocciato su un difetto strutturale, non su un numero mancante)* |

> ## 🔴 **ZERO certificati completi su dodici. Sette verdetti sono «NON ANCORA MISURATO».**
> E la voce che manca più spesso è la ⑤: **il TF non è MAI stato cambiato su nessuna
> variante ORB-Nasdaq**, `770260` compresa.

## 2.1 🧨 LE MANOPOLE INERTI — misurate io, adesso

Il censimento del 09/09 diceva che 874 CSV su 1.960 hanno passate con esito identico. **Su
questa famiglia ho contato riga per riga**, e ce ne sono tre che contano:

| file | passate | **esiti distinti** | manopola **INERTE** | perché |
|---|---:|---:|---|---|
| `risultati_archivio/Openconfirm/NASDAQ_openconfirm_M15.csv` | **96** | 🔴 **9** | `InpTrailFixedPts` (**8 valori**) | `InpTrailMode=1` (PREVBAR): il ramo FIXED è morto. **12 gruppi su 12 identici al centesimo** |
| `risultati_prove/ABTG_ORB_Ottimizzato/..._NASUSD_{IS,OOS}_r12.csv` | **48** | 🔴 **24** | `InpUseVolumeFilter` | **24 coppie su 24 identiche**, in IS **e** in OOS |
| `risultati_archivio/GapFill_Nasdaq/..._IS_gapnas.csv` | **24** | 🔴 **6** | `InpGapMinPoints` fra 100 e 300 | la soglia **non morde** in quell'intervallo (già detto in `REFERTO_ROUND61` r.57) |

🔥 **Il caso `r12` è quello che brucia**: sull'`ABTG_ORB` il filtro volumi è **l'unica cosa
vista in tutta la maratona dell'08/08 che migliora TUTTI e 4 i confronti in ENTRAMBE le
finestre** (R8) — e sull'`ABTG_ORB_Ottimizzato`, sullo stesso simbolo, **non ha mai morso**.
👉 **«L'abbiamo provato» lì voleva dire «l'abbiamo girato senza che cambiasse niente».**

## 2.2 🧪 IL CONTRO-ESEMPIO CHE HO COSTRUITO CONTRO ME STESSO — e che mi ha smentito

**Stavo per scrivere una cosa falsa.** Avevo visto che
`NASDAQ_openconfirm_M15.csv` e `NASDAQ_openconfirm_graficoM5.csv` danno risultati
**identici in 10 celle su 12** (differisce solo `EntryMode=5`), e la conclusione comoda era:
*«il TF del grafico è stato cambiato ed è inerte — casella ⑤ chiusa»*.

🔴 **È sbagliata.** Aperto `backtest_pipeline/aperture_openconfirm.ps1` r.34 e r.197: il
parametro del giro è **`-OCTimeframe`**, che scrive **`InpOCTimeframe`** — e
`ABTG_Nasdaq_Apertura_US.mq5` r.214-217 dice che quell'input **serve SOLO a `EntryMode=5`
(OPENCONFIRM)**. Il nome del file mette `M15` nel titolo, ma **il TF del grafico non è mai
cambiato**: le 10 celle identiche lo sono **per costruzione**, non per misura.

> 🎯 **Conseguenza: la casella ⑤ di `770201` e `770250` resta APERTA**, e il file che sembrava
> chiuderla è il contrario di una prova. Se avessi controllato che la risposta fosse coerente
> con la mia aspettativa invece di provare a romperla, avrei chiuso una casella **con una
> certificazione falsa** — il difetto del 10/09, identico.

---

# 3. 💸 IL CANCELLO DEL COSTO, RICOMPILATO SULLO SPREAD FTMO

## 3.1 🔴 Prima: **QUALE** spread FTMO — perché i verdetti cambiano col numero che si sceglie

| metro | valore `US100.cash` | tag | fonte |
|---|---:|---|---|
| **prevolo 20/09**, mercato **CHIUSO**, **un solo tick** | **1,53** | `[MISURATO n=1]` | `STOP_VS_SPREAD_FTMO_2026-09-20.md` §5.2 |
| **ora 10 server** (mattina europea, **cash USA chiuso**): mediana / P95 | **1,45** / **1,65** | `[MISURATO, GG=1]` | `SPREAD_APERTURA_FTMO_2026-09-21.md` §① |
| 🔴 **ora d'apertura del Nasdaq (16:30 server FTMO)** | **—** | ⚪ **[NON MISURATO]** | lo spread logger ha girato **01:05→10:50**: quell'ora **non c'è** |
| **derivato**: BCM ora 14 (1,80) × rapporto FTMO/BCM misurato (0,90) | **1,62** | `[DERIVATO]` | rapporto §5.2 dello stesso referto |

🔴 **Il 1,53 del mandato è un tick solo, letto a mercato chiuso, in un'ora in cui il Nasdaq
non scambia.** Do **tutte e tre** le letture. E la conclusione **non cambia con nessuna**.

Frontiere che ne escono: **BCM 40×1,80 = 72,00 idx** · **FTMO 40×1,53 = 61,20 idx**
(già compilata a r.249 di `STOP_VS_SPREAD_FTMO`) · **FTMO-derivato 40×1,62 = 64,80 idx**.
Pavimento **duro** 13,3×: BCM **23,94** · FTMO **20,35**.

## 3.2 📊 LA TABELLA — chi passa adesso e prima no

**Colonna «× MFE» = stop ÷ 65,00 idx**, l'escursione favorevole mediana misurata su NASUSD
(`IL_NASDAQ_IN_PUNTI_E_IL_DAX_2026-09-23.md` r.17, **n=447**). Vincolo di Claudio del 23/09:
*«50 punti. Non 90»* — **sotto 1,0× comodo · fino a ~1,24× accettato · oltre 1,5× è una cella
che il mercato non può pagare.**

| variante | **stop idx** | tag | **× BCM 1,80** | **× FTMO 1,53** | **× FTMO-der. 1,62** | **× MFE** | 40× su FTMO? | **cambia col nuovo spread?** |
|---|---:|---|---:|---:|---:|---:|---|---|
| **`770601` ORB** 14:25-14:30 | **47,70** | `[MIS n=9]` | 26,5× | **31,2×** | 29,4× | 🟢 **0,73×** | 🔴 **NO (−22%)** | 🟠 migliora, **non basta** |
| **`770203` Live5m** — forward | **48,70** | `[MIS n=3]` 🆕 | 27,1× | **31,8×** | 30,1× | 🟢 0,75× | 🔴 **NO (−20%)** | 🟠 migliora, non basta |
| `770203` Live5m — **cella minima** | 24,00 | `[DER]` | 13,3× | **15,7×** | 14,8× | 🟢 0,37× | 🔴 **NO** — e sfiora il **duro** | 🟠 da 13,3× (= il duro **esatto**) a 15,7× |
| **`770211` OTT** — forward | 115,50 | `[MIS n=1]` | 64,2× | 🟢 **75,5×** | 71,3× | 🔴 **1,78×** | 🟢 **sì** | 🟢 passava già · 🔴 **ma sfonda l'escursione** |
| **`770201`** / apertura 15' | 80,62 | `[MIS n=447]` | 44,8× | 🟢 **52,7×** | 49,8× | 🟡 **1,24×** | 🟢 **sì** | 🟢 passava già |
| **`770260` viva** — stima di casa | 83,20 | `[INF]` | 46,2× | 🟢 **54,4×** | 51,4× | 🟡 1,28× | 🟢 sì | 🟢 passava già |
| **`770260` viva** — ricostruzione B | 117,02 | `[INF]` | 65,0× | 🟢 **76,5×** | 72,2× | 🔴 **1,80×** | 🟢 sì | 🟢 sì · 🔴 **ma §3.4** |
| **ORB Ott** 15' · **HALFRANGE** (la geometria misurata) | 37,65 | `[DER]` 🆕 | 20,9× | **24,6×** | 23,2× | 🟢 0,58× | 🔴 **NO (−60%)** | 🟠 migliora, non basta |
| **ORB Ott** 15' · **OPPRANGE** (la riparazione) | 75,30 | `[DER]` 🆕 | 41,8× | 🟢 **49,2×** | 46,5× | 🟡 1,16× | 🟢 **SÌ** | 🟢 **e passava già anche su BCM** |
| **ORB Fibo** — **limite INFERIORE** | ≥16,36 | `[DER]` 🆕 | ≥9,1× | **≥10,7×** | ≥10,1× | 0,25× | 🔴 **NO, e sotto il DURO** | 🔴 il più esposto della famiglia |
| **R8 «da manuale»** — OR **30'** | 97,40 | `[DER]` 🆕 | 54,1× | 🟢 **63,7×** | 60,1× | 🔴 **1,50×** | 🟢 **SÌ** | 🟢 **l'unica geometria ORB che passa** |

### 🎯 LA RISPOSTA SECCA ALLA DOMANDA 2
> **Con lo spread FTMO NON passa nessuno che prima non passasse.** Chi passa (`770201`,
> `770211`, `770260`, ORB-OPPRANGE, R8-30') **passava già anche sullo spread BCM**. Chi non
> passava (`770601`, `770203`, ORB-HALFRANGE, ORB-Fibo) **continua a non passare**: il
> guadagno è del **+17,6%** sul rapporto (1,80→1,53), e a `770601` ne servirebbe il **+28%**.
> 🔬 **Verificato l'esempio del mandato**: `47,70 / 1,53 = 31,18×`. ✅ Torna.

## 3.3 🆕 QUELLO CHE QUESTO CONTO CHIUDE, e che era `[NON MISURATO]` fino a stamattina

`IL_CORTO_DI_DAX_E_NASDAQ_2026-09-23.md` r.386-389 lascia aperto: *«costo `770611` ORB
`U30USD` M5 **29,5×** 🔴, riparabile a **~64,0×** con `InpSLMode: HALFRANGE → OPPRANGE`. Su
`NASUSD` **[NON MISURATO]»**.

🟢 **Adesso c'è, ed è `[DERIVATO]` da numeri già scritti da altri**: geometria `14:30-14:45`
= **15 minuti**, ampiezza mediana misurata su NASUSD **75,30 idx** `[MIS n=447]`
(`IL_NASDAQ_IN_PUNTI_E_IL_DAX_2026-09-23.md` r.227), `InpSLBufferPts=0` verificato nel CSV e
nel sorgente (`ABTG_ORB_Ottimizzato.mq5` r.192, r.627-638):

- **HALFRANGE** (`SLMode=3`) = `0,5 × ampiezza` = **37,65 idx** → **24,6×** su FTMO 🔴
- **OPPRANGE** (`SLMode=0`) = `ampiezza` = **75,30 idx** → **49,2×** su FTMO 🟢

👉 **La riparazione che funziona sul Dow funziona anche sul Nasdaq**, e il numero adesso è
scritto. ⚠️ **Ma non serve a riaccendere niente**: §5 mostra che su NASUSD anche la
geometria che passa il costo perde fuori campione.

## 3.4 🔴 LA COSA SCOMODA, e va detta lo stesso: **il vincolo di Claudio morde la sedia VIVA**

Se la **ricostruzione B** (117,02 idx) è la lettura giusta dello stop di `770260`, quella
sedia gira a **1,80× l'escursione favorevole mediana** — cioè **oltre** la riga dell'1,5×.
Con la stima di casa (83,20) sta a **1,28×**, dentro.

🟢 **Due cose la attenuano, e sono misurate**: la cella viva prende **il 50% a mezzo R**
(`InpTP1_R=0,5` · `InpTP1_ClosePct=50`, R199B), quindi **non aspetta** l'escursione piena; e
il DD alla **taglia vera** è **7,31% / 7,86%**, sotto il muro del 10%.
🔴 **Quello che NON è attenuato: quale dei due stop sia quello vero è `[NON MISURATO]`**, e si
misura in un modo solo — **dalle prime operazioni vere sulla challenge**, che ancora non ci
sono. 👉 **Non è un'azione: è un numero da leggere quando arriva.**

---

# 4. 🔢 I NUMERI VERI — PF, n, DD, finestra, **banco dichiarato**

## 4.1 Al banco (backtest)

| variante | finestra | **banco** | PF IS | PF **OOS** | n OOS | DD OOS | rischio | fonte |
|---|---|---|---:|---:|---:|---:|---:|---|
| 🟢 **`770260` RETEST** (cella viva) | IS 2024.09→2025.06 · OOS 2025.06→2026.06 | 🟢 **tick** | **1,22116** | 🟢 **1,21546** | **172 deal = 102 pos** | 🟢 **7,8576%** | 🟢 **2,00% = la taglia di campo**, banco **80.000** | `risultati_prove/R199B/..._{IS,OOS}_R199B.csv` Pass 2 |
| 🔴 **ORB_Ott NASUSD** `R97-rif` HALFRANGE | idem | tick | 1,32 | 🔴 **0,91** | 135 | 12,4% | 1% | `risultati_archivio/R97_REFERTO.md` |
| 🔴 `R97a` OPPRANGE buf 0 TP 2R | idem | tick | 1,27 | 🔴 **0,89** | 135 | 9,0% | 1% | id. |
| 🔴 `R97b` OPPRANGE buf 500 TP 1,5R | idem | tick | 1,28 | 🔴 **0,86** | 135 | 8,2% | 1% | id. |
| 🔴 `R97c` OPPRANGE buf 500 TP 2R | idem | tick | 1,13 | 🔴 **0,84** | 135 | 8,4% | 1% | id. |
| 🟠 **ORB_Ott NASUSD** `r44b` best | idem | tick | 1,10107 | 🟠 **1,15564** | 135 | 🔴 **12,2611%** | 1% → **24,5% a 2%** | `..._ORB_Ottimizzato/r44/..._r44b.csv` |
| 🟠 **`770601` ORB** `R8` volume **ON** | idem | tick | 1,49060 / 1,45601 | 🟠 **1,03159 / 1,02307** | 190 / 185 | 🟢 4,85% / 5,24% | 1% | `..._ABTG_ORB/ABTG_ORB_NASUSD_{IS,OOS}_r8.csv` |
| 🔴 `770601` ORB · **config VIVA** (R7a) | idem | tick | 🔴 **0,82392** | 1,04998 | 355 | 🔴 **19,4104%** | 1% | `..._ABTG_ORB/..._r7a.csv` |
| 🔴 `770601` ORB · R7b (range 35') | idem | tick | 1,69254 (n=64) | 🔴 **0,93061** | 379 | 6,13% | 1% | `..._ABTG_ORB/..._r7b.csv` |
| 🔴 **`770203` Live5m** cella mediana | idem | tick | 1,01621 | 🔴 **0,96265** | 175 deal | 🔴 **19,40%** | 2% | `REGISTRO_TEST.md` L2 |
| 🔴 **`770201` breakout** (fase B/D/L/M) | idem | tick | best 1,13163 | 🔴 mediana **0,87813**, best 1,01167 | 250-255 | fino a **24,23%** | 1% | `Walkforward_Aperture/NASDAQ_A_geometria_{IS,OOS}.csv` |
| 🟠 **`770250` GatedShort** | 2024.09→2026 (**toro**) | tick | — | 🟠 **1,097** | **104** | 🟢 4,54% | 0,65% → campo 0,35% | `REFERTO_SHORTGATE_2026-08-30.md` r.67 |
| 🟠 `770250` — regime **ORSO** | 2020-2023 | 🔴 **OHLC** | — | 🟠 **1,84** | **93** | 2,07% | — | id. r.11-16 |
| 🔴 **ORB Fibo** `770602` | idem | 🔴 **OHLC, zero tick** | 0,83507 | 🔴 **0,96816** | **75** | 3,10% *(rischio realizzato ignoto)* | nominale 1 | `..._ABTG_ORB_Fibo/..._ohlc.csv` |
| 🔴 **Apertura 3 Ingressi** (3 varianti) | idem | tick | 1,25367 / 0,94654 / 0,70462 | 🔴 **0,87315 / 0,62394 / 0,97849** | 291 / 303 / 313 | 17,07 / **29,14** / 6,18% | 1% | `risultati_archivio/r83_csv/*` |
| 🟢 **GAPFILL** best OOS | idem | tick | 2,08964-2,53613 | 🟢 **1,54466-2,87054** | 🔴 **16-43** | 🟢 2,92-6,02% | 1% | `risultati_archivio/GapFill_Nasdaq/*` |

🔴 **Chi ha numeri SOLO OHLC, dichiarato per nome**: **`ORB Fibo`** (zero passate a tick in
tutta la storia di git) e **il verdetto ORSO di `770250`**. Su questa famiglia il fattore
OHLC→tick misurato vale **2,246** sul Nasdaq Live5m (`REGISTRO_TEST.md`): **un PF OHLC di
0,97 non promette un PF tick di 0,97, ne promette ~0,43.**

## 4.2 In campo (forward) — e l'unità è *«quante operazioni»*, non *«quanto ha fatto»*

| magic | n | somma netta | vinte | finestra | PF forward |
|---|---:|---:|---:|---|---:|
| `770601` ORB | **20** | 🟢 **+351,51** | 10/20 | 20/07 → **10/08** | **1,853** |
| `770201` breakout | 10 | +228,34 | **10/10** | 20/07 → 11/08 | *(nessuna perdita: PF non definito)* |
| `770203` Live5m | 6 | +206,63 | 3/6 | 20/07 → 06/08 | 1,738 |
| `770211` OTT | 3 | +46,34 | 2/3 | 03/08 → 10/08 | 5,634 |
| `770250` GatedShort | **2** | +7,56 | 2/2 | **15/09 → 18/09** | *(nessuna perdita)* |
| `770260` RETEST | 🔴 **0** | — | — | — | — |

*(Calcolo mio su `data/statements/trades_auto.csv`, `profit + commission + swap`.)*

🔴 **E il contro-numero che quasi nessuno cita**: `CLASSIFICA_CAMPO_50503392_2026-09-18.md`
r.86 dà l'ORB a **−86,40 su 7 posizioni, PF 0,54**. **Non è una contraddizione: è un'altra
finestra** (dal 03/08). **Venti operazioni divise in due finestre danno +1,85 e 0,54.**
👉 **Questo è il vero valore informativo di n=20: zero.**

---

# 5. 🧬 PERCHÉ È SPENTO — la ricostruzione, con le date

| data | cosa è successo | fonte |
|---|---|---|
| **08/08** | Letto il codice: **`InpOneTradePerDay` dichiarato e MAI LETTO**. Dopo lo stop il pendente opposto restava vivo 600 minuti e riapriva al contrario. **Corretto** (`4dcf06f1`, poi `7d0da9f9` v1.01) | `report/DIARIO.md` r.34 |
| **08/08 notte** | **R7**: 8 celle a tick reali, due geometrie di range. **La config VIVA è la peggiore del lotto**: IS PF **0,82** · DD **24,8%**. La geometria curata ferma l'emorragia in IS **ma le 4 celle OOS sono tutte rosse** | `REFERTO_ROUND7_ORB.md` · r.33 del DIARIO |
| **08/08 notte** | **R8**, la strategia *da manuale*: il filtro volumi **migliora tutti e 4 i confronti in entrambe le finestre** (l'unica cosa della serata che migliora tutto) — **ma OOS PF 1,02-1,03**: *«un pareggio, non un edge»* | `REFERTO_ROUND8_ORB_MANUALE.md` · r.32 |
| **10/08** | 🔴 **`770601` SPENTA — numero 1 della lista TIER 1 «SPEGNERE»**, motivazione testuale: *«bug pendente noto; oggi −42,91 in 4 min»*. **Non il rendimento** | `report/PULIZIA_VPS_10-08.md` r.37 |
| **15/08** | Verificato: la pulizia ha tenuto, `770601` non opera più. **Nota d'archivio già scritta allora**: *«chiude con +351,51 su 20 trade — era in utile, spento per un difetto tecnico e non per il rendimento»* | `report/PAGELLA_SETT_2026-08-15.md` r.104 |
| **18/08** | Spente `770201` e `770211` (famiglia apertura Nasdaq, +274,68 su 13 op) | `report/PIANO_PROP.md` r.960 |
| **22/08** | 🔴 **R97: il verdetto vero.** 4 geometrie di stop, **stessi ingressi** (74 IS / 135 OOS, identici per costruzione), tick reali: **OOS 0,84 / 0,86 / 0,89 / 0,91**. *«Il problema NON è la geometria dell'uscita: sono gli INGRESSI»* | `R97_REFERTO.md` |
| **30/08** | Nasce `770250` GatedShort: **non il breakout**, un breakdown **gated** su regime H4 | `report/CONTRATTO_GATEDSHORT_770250.md` |
| **18/09** | Nasce `770260` **RETEST**: **la stessa inefficienza con un ingresso diverso** | `report/NASDAQ_RETEST_VOLUMI_LA_SEDIA_2026-09-18.md` |
| **20/09** | `770260` schierata: **sedia 6 su 6 della challenge FTMO** | `report/SCHIERAMENTO_FTMO_2026-09-20.md` r.204 |

> ## 🎯 **La storia in una riga: il breakout d'apertura sul Nasdaq NON è stato abbandonato. È stato SOSTITUITO** — dalla stessa famiglia, sullo stesso simbolo, alla stessa ora, con un ingresso che nelle nostre misure paga (**RETEST**) invece di uno che non paga (**breakout nudo**).

---

# 6. 🛑 LA VARIANTE VERDE CHE NON È BLOCCATA DAI NUMERI — **GAPFILL**

È l'unica variante della famiglia con **PF OOS > 1,5 a tick reali in entrambe le finestre**:
IS **2,09-2,54** · OOS **1,54-2,87**, DD **2,9-6,0%** a rischio 1%.

🔴 **E non si schiera lo stesso, per tre ragioni che non sono il PF:**
1. **n = 16-43 in OOS.** Il merito è **sospeso per aritmetica** (< 150). Il miglior compromesso
   frequenza/PF (`gapmin=0` · `RR=0,5`) fa **43 operazioni in ~13 mesi = 0,16 op/giorno**.
2. 🛑 **Il «gap trading» è fra le FORBIDDEN TRADING PRACTICES di FTMO**, e **non sappiamo se
   la clausola valga in Evaluation**: tre mail scritte, **l'ultima mai inviata**, risposta
   diretta **mai ricevuta** (`MAIL_FTMO_GAP_TRADING_TERZO_GIRO_2026-08-28.md` ·
   `LE_PROP_E_GLI_EA_COSA_SAPPIAMO_2026-09-19.md` **B2**). *È l'unica clausola che può
   squalificare un conto che rispetta tutti i numeri.*
3. 🔴 **Il preset porta `InpMagic=770202`, che è il magic del Dow Apertura in campo.** Chi lo
   caricasse oggi creerebbe una **collisione di magic** su due simboli.

> 🙋 **QUESTO È IL BUCO CHE CLAUDIO PUÒ CHIUDERE LUI, e costa una mail**: la risposta scritta
> di FTMO sul gap trading in Evaluation. Finché non c'è, il numero verde **non si può usare**
> — e non è una scelta nostra.

---

# 7. 🧪 I CONTRO-ESEMPI — costruiti **prima** di concludere

## 7.1 Se la conclusione fosse **«l'ORB sul Nasdaq è buono, riaccendiamolo»** — che numero la smentisce?
**`R97`.** Quattro geometrie, **stessi ingressi per costruzione**, **tick reali**, `n=135` in
OOS: **PF 0,84 / 0,86 / 0,89 / 0,91**. E le celle che sembravano salvarsi **sono verdi solo
in IS** (1,13-1,32): è la firma classica dell'edge che c'era nel 2024 e non c'è più.
Seconda misura, indipendente e più larga: `NASDAQ_A_geometria_OOS` — **20 celle di ampiezza
range × buffer, PF mediano 0,87813**, best 1,01167.
🟢 **Il numero c'è, ed è nostro.**

## 7.2 Se la conclusione fosse **«è spento a ragione»** — che numero la smentisce? **L'HO CERCATO DAVVERO, E NE HO TROVATI TRE**

| # | il contro-esempio | 🔴 perché non regge |
|---|---|---|
| **A** | 🟢 **`770601` chiuse in UTILE: +351,51 su 20 operazioni, PF forward 1,853** — e fu spenta per un **bug**, non per il rendimento | **Tre colpi, tutti misurati**: ① **n=20 in tre settimane**: la stessa sedia, sulla finestra dal 03/08, fa **−86,40 · PF 0,54** — *le stesse 20 operazioni, due finestre, 1,85 e 0,54*; ② **quella identica configurazione a tick reali su n=222 fa `PF 0,82392 · DD 24,84%`** (R7a): **la peggiore delle 4 celle per profitto (−1.477,26) e per DD**; ③ **costo: 31,2× su FTMO, sotto il 40×**. 🟠 **E il pezzo che NON nascondo: la stessa cella in OOS fa `PF 1,04998 · n 355` — positiva.** Muore lo stesso, e su un criterio che vale a qualunque `n`: **DD OOS 19,4104% a rischio 1% ⇒ ~38,8% alla taglia di campo**, quasi quattro volte il muro |
| **B** | 🟢 **Le due celle R8 «volume ON» sono verdi in ENTRAMBE le finestre a tick**: OOS **1,03159** (n=190, DD 4,85%) e **1,02307** (n=185, DD 5,24%) | **PF 1,02-1,03 ≈ 40 centesimi a operazione**: dentro il rumore, e il crollo IS→OOS è **1,46 → 1,03**. 🟠 **Ma una parte regge e la scrivo: la geometria R8 (OR 30') è l'UNICA ORB-Nasdaq che passa il 40× su FTMO (63,7×)** — e costa **1,50× l'escursione mediana**, cioè esattamente la riga rossa di Claudio |
| **C** | 🟢 **`ORB_Ottimizzato` `r44b` fa OOS `PF 1,15564 · n 135`** — il miglior PF OOS di tutte le varianti spente | **DD OOS 12,2611% a rischio 1% ⇒ ~24,5% alla taglia di campo (2%)**, e IS **19,7-23,9%**. 🔴 **Bocciata sul RISCHIO, che si legge a qualunque n** (Emendamento B) |

> ## 🎯 **Il contro-esempio A è il migliore dei tre, ed è quello che risponde alla domanda di Claudio.** *«Era in utile quando l'abbiamo spenta»* **è vero**. Ma venti operazioni in tre settimane non sono una misura: **la stessa configurazione, misurata su 222 operazioni a tick reali, fa PF 0,82 con un drawdown del 24,8%.** 👉 **Non la riaccendiamo perché era in utile: la lasciamo spenta perché sappiamo cosa fa su un campione vero.**

## 7.3 🔴 E un conflitto che NON ho risolto, dichiarato come tale
L'ampiezza d'apertura del Nasdaq ha **due fonti di casa che non tornano**: `Studio_NASUSD`
(BCM, 15', **75,30 idx**, n=447, 2024.09→2026.06) e
`ANATOMIA_APERTURE_PERGIORNO_NASUSD` (feed storico/HistData, 30', mediana **2025 = 116,6** e
**2026 = 176,6 idx**). Riportate alla stessa finestra **differiscono di quasi 2×**, e
`AMPIEZZA_RANGE_NASDAQ_2026-09-21.md` §2 lo dice già: *«il costo vero è [NON RISOLTO]»*.
👉 **Tutte le mie righe `[DERIVATO]` di §3.2 usano la fonte BCM (la più conservativa sul
costo). Con l'altra fonte gli stop derivati RADDOPPIANO** — e allora anche HALFRANGE
passerebbe il 40×, ma sfonderebbe l'escursione. **La conclusione non cambia; la ragione sì.**

---

# 8. ❓ LA DOMANDA 5, SECCA: c'è una sedia ORB-Nasdaq che meriterebbe di essere riaccesa?

> ## 🔴 **NO. Nessuna. Oggi, 23/09, a otto giorni dalla challenge, nessuna delle varianti spente merita un posto in campo.** E il motivo non è *«è spenta da un po'»*: sono quattro numeri.

| # | il motivo | il numero |
|---|---|---:|
| 1 | Il **breakout nudo** perde fuori campione, su campione pieno, a tick, in ogni geometria di uscita provata | **PF OOS 0,84-0,91 · n=135** (R97) |
| 2 | Le uniche celle verdi in entrambe le finestre valgono **un pareggio** | **PF OOS 1,023 e 1,032** (R8) |
| 3 | Chi ha il PF OOS migliore è **bocciato sul rischio** alla taglia vera | **DD 12,26% @1% ⇒ ~24,5% @2%** (r44b) |
| 4 | Chi ha il costo migliore **non passa comunque il 40×** nemmeno con lo spread FTMO | **31,2×** contro 40 (`770601`) |

## 8.1 🟢 E questo **non è un fallimento: è già stato risolto**
La famiglia **è in campo**: `770260` RETEST, sedia 6 su 6, **OOS PF 1,21546 · DD 7,86% alla
taglia vera** — il DD **più basso** fra le tre aperture della challenge. 👉 **La domanda
«perché non riattiviamo l'ORB sul Nasdaq?» ha come risposta migliore: «l'abbiamo già fatto,
il 20 settembre, con l'ingresso che nei nostri dati paga».**

## 8.2 📋 E che cosa manca ESATTAMENTE, se un giorno si volesse proporlo
Non lo propongo — lo scrivo perché **la prossima volta che qualcuno chiede, la risposta sia
già misurata e non si ricominci da capo**:

| candidato | cosa manca, per nome | costo stimato | 🛑 perché **NON** lo propongo oggi |
|---|---|---|---|
| `ABTG_ORB` config **R8 30' volume ON** | ③ uscita ad asse · ④ un gemello (D30EUR/U30USD) · ⑤ un TF | ~24 passate | 🔴 **Violerebbe la regola del 19/08**: il motore è **dichiarato senza edge** (R97). Una griglia più fitta su un morto trova **picchi di rumore**. E PF 1,03 **non è un edge da cui partire** |
| `ORB_Ottimizzato` NASUSD **OPPRANGE** | il lato (216 passate, mai ad asse) | 6 passate | 🟠 già in coda in `R233` §5, **e la sua tesi è condizionata** a un cambio d'ingresso |
| **GAPFILL** | ② `n` · e **la risposta scritta di FTMO** | 0 minuti macchina | 🛑 **bloccata da una REGOLA, non da un numero** — §6 |
| `770602` **ORB Fibo** | ① **una sola passata a tick** (oggi: zero) | ~4 passate | 🟠 la geometria è un **RETEST** (paga, in casa), ma n OOS **75** e il costo derivato sfiora il **pavimento duro** |

## 8.3 🙋 LE DUE COSE CHE CHIEDO A CLAUDIO — **nessuna delle due è un round**
1. 📧 **La mail a FTMO sul gap trading in Evaluation.** È scritta dal 28/08, non è mai partita,
   e sblocca l'unica variante verde della famiglia. **Costo: zero minuti macchina.**
2. 📊 **Quando `770260` farà le sue prime operazioni vere, leggere la distanza di stop
   riempita.** È il solo modo di sciogliere l'83,20 contro 117,02 di §3.4 — cioè di sapere se
   la sedia viva sta a **1,28×** o a **1,80×** l'escursione mediana. **Costo: leggere un
   libro affari.**

---

# 9. 🕳️ COSA **NON** HO COPERTO — per nome

1. 🔴 **Il libro affari del conto FTMO `541452707`.** Non c'è un `TradeExporter` che finisca in
   repo: «`770260` non ha operato» vale **su ciò che è documentato**, non sul conto.
2. 🔴 **Lo spread FTMO `US100.cash` ALL'ORA DELL'APERTURA (16:30 server).** Lo spread logger
   ha coperto **01:05→10:50**. Il 1,53 è **un tick a mercato chiuso**; il 1,62 è **[DERIVATO]**.
3. 🔴 **Il conflitto sull'ampiezza d'apertura** fra `Studio_NASUSD` e
   `ANATOMIA_APERTURE_PERGIORNO_NASUSD` (§7.3): **non risolto**, e tutte le mie righe
   `[DERIVATO]` di §3.2 ereditano l'incertezza.
4. 🔴 **`770211`: zero CSV in repo.** I suoi tre numeri di campo (n=3) sono **tutto** quello
   che esiste. Il suo certificato è **0 su 5** e io non l'ho migliorato.
5. 🔴 **I 216 pass di `ORB_Ottimizzato` NASUSD non li ho letti cella per cella**: ho letto
   `r9`, `r9largo`, `r12`, `r13`, `r44b` (192 passate su 216). **Mancano `r11` e i file
   `ancora_passo7`**, che sono su U30USD/D30EUR.
6. 🔴 **Non ho aperto `NASDAQ_ingresso.csv`, `NASDAQ_trailing.csv` e le 7 corse
   `csv_ablazione/apert_APERT_US_M5_*`**: riguardano `770201`/`770250` e potrebbero spostare
   la casella ③ di quelle due righe. Il tempo è finito lì.
7. 🔴 **Non ho verificato quale binario di `ABTG_ORB` gira oggi**, perché **non gira**: se un
   giorno `770601` tornasse, **va prima verificato che il binario abbia il fix `7d0da9f9`**
   (`InpOneTradePerDay` letto davvero) — il bug per cui fu spenta.
8. 🔴 **Non ho misurato niente di nuovo al tester.** Ogni numero di questo referto è **letto**
   da file già in repo o **ricalcolato** da quei file. **Zero minuti macchina.**

---

## ✅ APPENDICE — le verifiche di riproduzione che ho fatto contro numeri scritti da ALTRI

| controllo | scritto altrove | ricalcolato da me | esito |
|---|---|---|---|
| stop mediano `770601` | **47,70** `[MIS n=9]` — `CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.242 | mediana di 9 gambe `sl` perdenti: `35,6 · 38,5 · 41,3 · 47,7 · 47,7 · 54,7 · 55,0 · 55,1 · 57,2` → **47,70** | ✅ **identico** |
| stop mediano `770611` | **59,00** `[MIS n=7]` — stesso referto | `33,3 · 49,1 · 57,7 · 59,0 · 60,0 · 73,5 · 94,0` → **59,00** | ✅ **identico** |
| `47,70 / 1,53` | **31,2×** *(esempio del mandato)* | **31,18×** | ✅ torna |
| frontiera FTMO `US100.cash` | **61,20** — `STOP_VS_SPREAD_FTMO_2026-09-20.md` r.249 | `40 × 1,53` = **61,20** | ✅ torna |
| escursione mediana NASUSD | **65,00** `[MIS n=447]` — `IL_NASDAQ_IN_PUNTI_E_IL_DAX_2026-09-23.md` r.17 | riletto a r.17 e r.227 | ✅ |
| `770260` OOS | **PF 1,21546 · DD 7,8576%** — `REGISTRO_TEST.md` A4 | `R199B/..._OOS_R199B.csv`: PF best 1,22396, **Pass 2 = 1,21546**, n 172, DD 8,2581 max | ✅ *(il DD 7,8576 è di Pass 2, non il max del file)* |

🧪 **Il contro-esempio del righello**: se la mia funzione di filtro fosse diversa da quella di
chi ha scritto `CANCELLO_COSTO_FLOTTA`, i due stop mediani (**47,70** e **59,00**) non
tornerebbero **entrambi** alla seconda cifra. Tornano. 👉 **La mia riga «`770203` = 48,70
`[MIS n=3]`», che è nuova e non l'aveva mai scritta nessuno, nasce dallo stesso filtro
validato.**
