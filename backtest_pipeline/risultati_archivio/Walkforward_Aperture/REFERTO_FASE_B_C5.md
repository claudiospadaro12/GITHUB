# FASE B RIFATTA (C5) — i sei motori, stavolta eseguiti davvero

06/08/2026 · `walkforward_aperture.ps1 -SoloMotore -Rifai` · **48 pass** a tick reali
(12 per finestra × 2 finestre × 2 mercati)
Range 35, buffer 200, gestione fissa (rischio 1%, SL a range, TP 1.5R, trailing base candela M5).
IS 26/09/2024→30/06/2025 (9.1 mesi) · OOS 01/07/2025→30/06/2026 (12 mesi).
La versione precedente e' conservata in `faseB_v1/` per il confronto.

---

## I tre controlli: passati tutti e tre

| controllo | prima | ora |
|---|---|---|
| GAPFILL ≠ BREAKOUT | identici al centesimo su 8 righe | diversi su 8 righe su 8 ✅ |
| DELAYED entra | **0 trade** su 22 mesi (1 su una riga) | 51–247 trade per riga ✅ |
| RANGE_FADE volumi ON ≠ OFF | identici su 4 righe | diversi su 4 righe su 4 ✅ |

Controllo di sicurezza: RETEST e OPENCONFIRM non dovevano cambiare, e infatti sono identici al
centesimo su 14 righe su 16. Le due che cambiano sono discusse in fondo.

---

## La tabella

### DAX

| motore | vol | IS | PF | n | OOS | PF | n | DD OOS |
|---|---|---:|---:|---:|---:|---:|---:|---:|
| BREAKOUT | off | +1352.27 | 1.271 | 179 | −225.44 | 0.966 | 243 | 14.54% |
| BREAKOUT | on | +1130.44 | 1.369 | 113 | −1032.74 | 0.769 | 153 | 14.75% |
| GAPFILL | off | −1.36 | 0.993 | **7** | +33.10 | 1.110 | **9** | 2.68% |
| **RETEST** | **off** | **+807.30** | **1.168** | **180** | **+392.96** | **1.065** | **244** | **13.32%** |
| RETEST | on | −106.43 | 0.962 | 95 | −481.65 | 0.864 | 116 | 12.27% |
| RANGE_FADE | off | −1035.83 | 0.824 | 179 | −1660.69 | 0.772 | 245 | 16.91% |
| RANGE_FADE | on | −553.16 | 0.840 | 113 | −629.26 | 0.861 | 155 | 10.50% |
| DELAYED | off | +1528.06 | 1.278 | 179 | −379.23 | 0.946 | 245 | 15.85% |
| DELAYED | on | +180.22 | 1.113 | 58 | −568.91 | 0.717 | 64 | 8.79% |
| OPENCONFIRM | off | −307.69 | 0.935 | 186 | +209.36 | 1.035 | 250 | 13.52% |
| OPENCONFIRM | on | +862.77 | 1.233 | 179 | −508.04 | 0.902 | 233 | 14.28% |

### NASDAQ

| motore | vol | IS | PF | n | OOS | PF | n | DD OOS |
|---|---|---:|---:|---:|---:|---:|---:|---:|
| BREAKOUT | off | −467.45 | 0.894 | 182 | −281.55 | 0.949 | 244 | 9.60% |
| BREAKOUT | on | +147.61 | 1.071 | 114 | +122.28 | 1.063 | 108 | 4.13% |
| **GAPFILL** | off | **+758.34** | **2.083** | **23** | **+487.09** | **1.937** | **19** | 3.28% |
| RETEST | off | −800.98 | 0.814 | 176 | +218.98 | 1.041 | 240 | 8.79% |
| **RETEST** | **on** | **+332.40** | **1.145** | **91** | **+274.35** | **1.109** | **94** | **3.68%** |
| RANGE_FADE | off | −1873.70 | 0.684 | 181 | −392.49 | 0.930 | 244 | 17.29% |
| RANGE_FADE | on | −994.57 | 0.714 | 113 | −786.98 | 0.696 | 108 | 12.73% |
| DELAYED | off | +54.34 | 1.013 | 184 | −615.74 | 0.890 | 247 | 12.18% |
| DELAYED | on | +523.42 | 1.710 | 56 | −356.42 | 0.696 | 51 | 4.61% |
| OPENCONFIRM | off | +432.66 | 1.107 | 178 | −365.50 | 0.927 | 240 | 7.18% |
| OPENCONFIRM | on | +2086.22 | 1.816 | 108 | −145.20 | 0.956 | 104 | 6.72% |

---

## Chi sopravvive fuori campione su ENTRAMBI i mercati

Il filtro e' quello di sempre: **si guarda l'OOS, e deve funzionare su due mercati**, non su uno.

| motore | DAX OOS | NASDAQ OOS | verdetto |
|---|---:|---:|---|
| **RETEST volumi OFF** | **+392.96** (PF 1.065, n=244) | **+218.98** (PF 1.041, n=240) | ✅ **passa** |
| **GAPFILL** | +33.10 (PF 1.110, n=9) | +487.09 (PF 1.937, n=19) | ⚠️ passa ma con 9 e 19 trade |
| OPENCONFIRM off | +209.36 | −365.50 | ❌ |
| BREAKOUT volumi ON | −1032.74 | +122.28 | ❌ |
| tutti gli altri | — | — | ❌ |

### 1. RETEST a volumi spenti — l'unico candidato serio
E' l'unico motore in utile fuori campione su tutti e due i mercati **con un campione vero**
(244 e 240 trade). PF modesti — 1.065 e 1.041 — ma sono numeri che si possono difendere:
sul DAX e' positivo anche in campione (+807.30), quindi non e' un colpo di fortuna dell'OOS.
Sul Nasdaq l'IS e' negativo (−800.98) e l'OOS positivo: e' il segno opposto all'overfitting,
e semmai dice che i due periodi sono diversi fra loro.

**Perche' ha senso che sia questo a funzionare.** Il RETEST non insegue la rottura con un ordine
STOP appoggiato al livello: aspetta la rottura, poi mette un LIMIT **sul livello rotto** e viene
eseguito solo se il prezzo ci torna. Non c'e' nessun ordine appoggiato che lo sweep d'apertura
possa andare a prendere — che e' il difetto che ci e' costato di piu' in forward (4 sweep in 3
giorni sui `Live5m`).

### 2. GAPFILL — il numero piu' alto della tabella, e il campione piu' piccolo
Sul Nasdaq fa **PF 2.083 in campione e 1.937 fuori**, con DD 3.28%. Una stabilita' del genere
fra IS e OOS non l'abbiamo mai vista su nessun altro motore.
Ma sono **23 e 19 trade** in 9 e 12 mesi: con quei numeri l'intervallo di confidenza e' enorme e
due o tre operazioni sbagliate ribaltano il risultato. Sul DAX ne fa 7 e 9, e li' il +33.10 non
significa niente.
**Non e' una bocciatura, e' una misura da rifare in grande**: gap minimo (`InpGapMinPoints=150`)
e RR minimo (`InpGapMinRR=1.5`) vanno spazzolati per capire se il numero di occasioni sale
restando redditizio. Da fare su un periodo piu' lungo che qui non abbiamo (il tetto e' il
26/09/2024).

### 3. DELAYED: la mia ipotesi di ieri era sbagliata
Avevo scritto che DELAYED, entrando **a mercato** dopo la rottura invece di appoggiare uno STOP,
poteva essere la risposta diretta al problema dello sweep. **Non lo e'.**
DAX: IS **+1528.06** (il miglior risultato in campione di tutta la tabella) → OOS **−379.23**.
Nasdaq: IS +54.34 e +523.42 → OOS **−615.74** e **−356.42**.
Crolla fuori campione su entrambi i mercati e con tutte e due le impostazioni del filtro.
E' un caso da manuale: il risultato in campione piu' alto e' anche quello che regge meno fuori.

### 4. RANGE_FADE: adesso e' bocciato davvero
Ieri era bocciato su una misura in cui il filtro volumi non faceva niente. Ora il filtro funziona,
il fade migliora (da −1035.83 a −553.16 sul DAX in IS) **ma resta negativo in 4 finestre su 4 su
tutti e due i mercati.** Chiuso, e stavolta chiuso su un dato valido.

### 5. OPENCONFIRM: confermata la bocciatura
Nasdaq IS +2086.22 con PF 1.816 → OOS −145.20. DAX il contrario. Non regge.

---

## ⚠️ Un quarto difetto: anche GAPFILL ignorava il filtro volumi

`GAPFILL vol0` e `GAPFILL vol1` danno la stessa identica riga su tutti e due i mercati e tutte e
due le finestre. Causa: `TryPlaceGapFill()` non chiamava ne' `VolumeOK()` ne' `ConfirmOK()` —
**lo stesso identico difetto del RANGE_FADE, che avevo corretto il 05/08 senza controllare gli
altri rami con lo stesso schema.** Correggere il caso singolo invece della classe di difetto e'
costato un secondo giro.

Corretto il 06/08 su DAX/Nasdaq/Dow, e stavolta con l'audit di tutti e sei i motori:

| motore | filtro applicato dove |
|---|---|
| BREAKOUT | `TryPlaceBreakout` ✅ |
| GAPFILL | `TryPlaceGapFill` ✅ *(aggiunto oggi)* |
| RETEST | `MonitorRetest`, sui due lati ✅ |
| RANGE_FADE | `TryPlaceRangeFade` ✅ *(aggiunto il 05/08)* |
| DELAYED | `TryPlaceDelayed` ✅ |
| OPENCONFIRM | `MonitorOpenConfirm` ✅ *(`ArmOpenConfirm` non deve averlo: arma soltanto)* |

**Conseguenza:** la riga `GAPFILL volumi ON` di questo referto **non e' valida** (e' una copia
della riga a volumi spenti). La riga a volumi spenti invece lo e'.

---

## ⚠️ Due righe cambiate che non dovevano cambiare — non spiegate

`NASDAQ RETEST volumi ON` e' l'unica riga che si muove fra la vecchia e la nuova FASE B:
IS +357.30 → **+332.40** (−24.90) e OOS +279.11 → **+274.35** (−4.76). **Stesso numero di trade**
(91 e 94), stessi parametri tranne `InpUseGapFill` passato da 0 a 1.

`InpUseGapFill` compare nel codice **solo** dentro il ramo GAPFILL: non puo' toccare il retest.
Quindi la causa e' un'altra, e la piu' probabile e' che fra i due giri **e' stato riscaricato lo
storico a tick reali** (`scarica_storico.ps1`, notte fra il 5 e il 6): se qualche tick e' stato
riempito, i **volumi tick** cambiano, e il retest e' l'unico motore che legge i volumi
**nel momento della rottura** invece che al piazzamento. Sarebbe coerente col fatto che
BREAKOUT vol1 e OPENCONFIRM vol1 non si sono mossi di un centesimo.

**Non e' dimostrato.** Test decisivo, 2 pass: stesso binario, `InpEntryMode=2`,
`InpUseVolumeFilter=1`, una volta con `InpUseGapFill=0` e una con `=1`. Se sono identici, la
differenza viene dai dati e non dal codice.
L'entita' e' comunque trascurabile — 0.27 € su trade in IS, 0.05 € in OOS — e **non cambia nessun
verdetto**.

---

## Cosa fare adesso

1. **RETEST volumi OFF e' il motore da portare avanti.** Va unito al risultato della FASE A
   (range 35–45, buffer 300–500 sul DAX): finora il RETEST e' stato misurato **solo a range 35 e
   buffer 200**. Serve la sua griglia geometria × OOS, come si e' fatto per il breakout.
2. **GAPFILL: misura da rifare in grande**, spazzolando `InpGapMinPoints` e `InpGapMinRR` per
   vedere se le occasioni salgono restando redditizie. Con 19 trade non si decide niente.
3. **Rifare la sola colonna `GAPFILL volumi ON`** col binario corretto (4 pass).
4. **Chiudere DELAYED e RANGE_FADE.** Misurati bene, bocciati bene.
