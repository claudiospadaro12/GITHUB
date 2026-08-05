# WALK-FORWARD APERTURE — DAX + NASDAQ (05/08/2026)

EA: `ABTG_DAX_Apertura_EU` (magic 770101, D30EUR) e `ABTG_Nasdaq_Apertura_US` (magic 770201, NASUSD).
Driver: `backtest_pipeline/walkforward_aperture.ps1`. Tick reali.
Finestre: **IS** 2024.01.01→2025.06.30 · **OOS** 2025.07.01→2026.06.30 · **FULL** 2024.01.01→2026.06.30.
Gestione fissa in tutte le fasi: rischio 1%, SL a range, TP1_R 0.5 (=1.5R), trailing su candela base M5, chiusura 17:30 server.

---

## ⚠️ PRIMA DI TUTTO: le date scritte nei CSV sono FALSE — si parte dal 26/09/2024

Il sospetto era nato da qui: l'EA fa **al massimo un trade al giorno** (`InpOneTradePerDay=1`) e i mesi
hanno ~21 giorni di borsa, quindi deve stare intorno a 20 trade/mese. La OOS ne dava 20.4, la IS **10.0**.
Rapporto **2.03 sul DAX e 2.03 sul Nasdaq** — due simboli, due sessioni, stesso identico numero. Non e'
mercato, e' storico.

**Misurato il 06/08** con `scarica_storico.ps1` (legge `SERIES_SERVER_FIRSTDATE`, cioe' cosa possiede il
broker, accanto a cosa c'e' sul disco): su **D30EUR, NASUSD e U30USD**, su **tutti e 7 i timeframe**,
locale e server coincidono al giorno — **2024.09.26**. Non manca nulla in locale: **BCM prima di quella
data non ha nulla.** Tick reali completi da li' (33.6 M · 162.7 M · 67.0 M).

Quindi la finestra "IS 2024.01.01 → 2025.06.30" non era di 18 mesi ma di **9.1**. Rifatto il conto:

| finestra | mesi VERI | trade medi | trade/mese |
|---|---:|---:|---:|
| DAX IS | **9.1** | 180.8 | **19.80** |
| DAX OOS | 12.0 | 244.7 | 20.39 |
| NASDAQ IS | **9.1** | 184.0 | **20.15** |
| NASDAQ OOS | 12.0 | 249.0 | 20.75 |

L'anomalia sparisce. Stesso conto sul Dow (8.1 nominali → **16.0** reali contro 16.4): torna anche li'.

**Conseguenze — e sono l'opposto di quello che avevo scritto la sera del 05/08:**
1. **Il walk-forward e' valido.** IS 26/09/2024→30/06/2025 e OOS 01/07/2025→30/06/2026 sono due finestre
   vere, contigue, non sovrapposte (43% / 57%). Non c'e' niente da riscaricare e niente da rifare.
2. **I crolli IS→OOS sono crolli veri.** OPENCONFIRM Nasdaq +2086 (PF 1.816) → −145 resta un caso da
   manuale di sovra-ottimizzazione, e lo **Spearman −0.357 del Dow resta in piedi**.
3. **L'IS pesa meno di quanto sembrasse**: 181 trade, non 360. Campione piccolo = piu' rumore. Un motivo
   in piu' per fidarsi dell'altopiano e non della cella migliore.
4. **Il periodo massimo testabile su questi indici e' 26/09/2024 → oggi**, ~22 mesi. Oltre non si va.

→ Resta da correggere la **documentazione**: ogni CSV e ogni referto scrive "2024.01.01" come inizio.
E' un'etichetta falsa e va sostituita con `2024.09.26` anche nei driver `.ps1`.

---

## FASE A — geometria (range × buffer), motore BREAKOUT, filtro volumi OFF

### DAX — profitto IS / profitto OOS

| range | buf 100 | buf 300 | buf 500 | buf 700 |
|---:|---|---|---|---|
| 5 | −1078 / **−113** | +2713 / **−1313** | +1644 / **−1001** | +2342 / **−1614** |
| 15 | +1975 / **−609** | +735 / **−1464** | +740 / **−1015** | +1164 / **−878** |
| 25 | +1461 / **−417** | +988 / **−743** | +921 / **−644** | +796 / **−836** |
| 35 | +2253 / **+170** | +761 / **+18** | +162 / **+794** | +24 / **+445** |
| 45 | +283 / **+743** | −562 / **+494** | −511 / **+1018** | −83 / **+387** |

Somma OOS per riga: range 5 −4041 (0/4 positivi) · 15 −3966 (0/4) · 25 −2640 (0/4) ·
**35 +1428 (4/4)** · **45 +2641 (4/4)**.

Questo e' il risultato pulito della giornata. Non e' una cella fortunata: e' un **blocco intero**.
Tutte e 12 le celle con range 5/15/25 sono negative, tutte e 8 quelle con range 35/45 sono positive.
Non serve scegliere il massimo (45/500, +1018, PF 1.172): come sul Dow, **su questi parametri non si
ottimizza, si prende il centro dell'altopiano** — che qui e' **range 40, buffer 400–500**.

DD e Sharpe nell'altopiano OOS: range 45 sta fra 10.7% e 12.4% di DD con Sharpe 2.2–5.3; range 35 fra
13.8% e 16.1% con Sharpe 0.1–4.3. **Il 45 e' piu' redditizio E meno volatile del 35.**

### NASDAQ — profitto IS / profitto OOS

| range | buf 100 | buf 300 | buf 500 | buf 700 |
|---:|---|---|---|---|
| 5 | −1809 / **−650** | −2391 / **+100** | −1922 / **−473** | −1718 / **−631** |
| 15 | +57 / **−1691** | −22 / **−1271** | −505 / **−1161** | −312 / **−1288** |
| 25 | +603 / **−1972** | +67 / **−2124** | −246 / **−1472** | −91 / **−1167** |
| 35 | +28 / **−274** | −23 / **−603** | +238 / **−239** | +355 / **−139** |
| 45 | −688 / **−534** | −632 / **−758** | −962 / **−710** | −771 / **−542** |

**19 celle su 20 negative in OOS.** L'unica positiva (+100.36, PF 1.012) e' rumore.

---

## FASE C — slippage (periodo FULL, buffer 200, BREAKOUT, volumi OFF)

### DAX

| range | slip 0 | slip 100 | slip 200 | slip 300 | media | positivi |
|---:|---|---|---|---|---|---|
| 5 | −524 | +958 | +1833 | +793 | +765 | 3/4 |
| 15 | −79 | −819 | +449 | −409 | −214 | 1/4 |
| 25 | +630 | +170 | +216 | +247 | +316 | 4/4 |
| **35** | **+1014** | **+949** | **+869** | **+835** | **+917** | **4/4** |
| 45 | +515 | −22 | −10 | +360 | +211 | 2/4 |

Il range 35 e' l'unico che **degrada in modo ordinato**: 1014 → 949 → 869 → 835, monotono, −179 € su
300 punti di slippage, cioe' ~0.43 € per trade. Questa e' la firma di un edge vero che paga un costo vero.

Il range 5 fa il contrario: **migliora** con lo slippage (−524 → +1833) a parita' di trade (437→440).
Un'oscillazione di 2400 € su 440 operazioni prodotta solo dal prezzo di riempimento significa una cosa
sola: quella configurazione **non ha edge, ha rumore**. Vale come controprova del metodo — se un test di
costo produce un miglioramento, la riga va cestinata, non festeggiata.

Attenzione pero': il DD nel FULL sta fra il 18% e il 25% **all'1% di rischio**. In forward il conto gira
al **2%**, quindi il doppio. Va guardato prima di alzare qualunque size.

### NASDAQ

**Tutte e 20 le celle negative**, migliore −196.25 (range 35, slip 300). Nessuna riga si salva.

---

## FASE B — motore (range 35, buffer 200): qui il test si e' rotto

| motore | vol | DAX IS | DAX OOS | NAS IS | NAS OOS |
|---|---|---|---|---|---|
| BREAKOUT (0) | off | +1352 | −225 | −467 | −282 |
| BREAKOUT (0) | on | +1130 | −1033 | +148 | +122 |
| GAPFILL (1) | off | +1352 | −225 | −467 | −282 |
| GAPFILL (1) | on | +1130 | −1033 | +148 | +122 |
| RETEST (2) | off | +807 | **+393** | −801 | **+219** |
| RETEST (2) | on | −106 | −482 | **+357** | **+279** |
| RANGE_FADE (3) | off | −1036 | −1661 | −1874 | −392 |
| RANGE_FADE (3) | on | −1036 | −1661 | −1874 | −392 |
| DELAYED (4) | off | 0 trade | 0 trade | 1 trade | 0 trade |
| DELAYED (4) | on | 0 trade | 0 trade | 0 trade | 0 trade |
| OPENCONFIRM (5) | off | −308 | +209 | +433 | −366 |
| OPENCONFIRM (5) | on | +863 | −508 | +2086 | −145 |

Tre anomalie nella tabella, e nessuna delle tre e' un risultato di mercato. Sono **tre difetti del codice**.

### Difetto 1 — GAPFILL non e' mai stato provato
`GAPFILL` e `BREAKOUT` danno numeri **identici al centesimo** su 2 mercati × 2 finestre × 2 filtri.
Causa, `ABTG_DAX_Apertura_EU.mq5:530`:
```
if(InpEntryMode == ABTG_GAPFILL && InpUseGapFill)
```
Nel test `InpUseGapFill=0`, quindi la condizione e' falsa e l'EA **cade nel ramo `else // BREAKOUT`**
senza scriverlo da nessuna parte. Il motore 1 non e' mai stato eseguito, ne' oggi ne' in nessun test
precedente che spazzasse le modalita'.

### Difetto 2 — il filtro volumi non tocca il RANGE_FADE
`RANGE_FADE` con filtro ON e OFF da' **la stessa identica riga** (stesso profitto, stesso numero di trade).
`TryPlaceRangeFade()` non chiama mai `VolumeOK()` ne' `ConfirmOK()` — a differenza di breakout, retest e
delayed che lo fanno. Il filtro era inerte. Quindi il fade "con volumi" non e' mai stato misurato.

### Difetto 3 — DELAYED non poteva entrare, per costruzione
0 trade su 30 mesi. La spiegazione facile ("`InpDelayMinutes=30` < `range 35`") **e' sbagliata**: il codice
gia' allinea la decisione alla fine del range (`if(decideMin < refEndMin) decideMin = refEndMin;`).
Il problema e' peggiore. La decisione cade **nell'istante esatto in cui il range si chiude**, e con
`InpDelayDirMode=BREAK` si chiede che il prezzo sia FUORI dal range. Ma il range e' l'high/low di quella
stessa finestra: **il prezzo e' dentro per definizione**. La condizione non poteva essere vera mai. E il
ramo faceva `return(true)`, che chiude la giornata: nessun secondo tentativo. L'unico trade (Nasdaq IS)
e' un giorno con un buco nei dati M1.

**Le tre correzioni sono state applicate** a `ABTG_DAX_Apertura_EU`, `ABTG_Nasdaq_Apertura_US`,
`ABTG_Dow_Apertura_US` (commit di oggi): la modalita' GAPFILL ora comanda sul flag legacy; il fade passa
da `ConfirmOK()`; DELAYED+BREAK aspetta la rottura vera entro `InpPendingExpiryMin` invece di bruciare la
giornata. **Con i filtri spenti e in modalita' BREAKOUT il comportamento e' identico a prima**, quindi
nessun EA in forward cambia.
→ **La FASE B va rifatta da capo.** Al momento sono stati misurati davvero solo 4 motori su 6.

### Cosa resta leggibile della FASE B
Il **RETEST** e' l'unico motore positivo in OOS su entrambi i mercati: DAX +393 (PF 1.065, n=244) con
filtro OFF, Nasdaq +279 (PF 1.111, n=94) con filtro ON — e sul Nasdaq e' positivo anche a filtro OFF
(+219, PF 1.041). E' l'unico candidato che passa la regola dei due mercati.

L'**OPENCONFIRM** conferma la bocciatura di ieri: dove va bene in IS va male in OOS, su tutti e due i
mercati, in croce. Nasdaq IS +2086 con PF 1.816 → OOS −145. Chiuso.

---

## VERDETTI

1. **DAX, geometria: promosso.** Range 35–45 con buffer 300–500 e' positivo in **8 celle su 8 fuori
   campione**, e il range 35 e' l'unico che regge **tutti e quattro** i livelli di slippage degradando in
   modo ordinato. E' la prima configurazione che passa i tre cancelli (fuori campione, robustezza di
   vicinato, costo). Da portare a **range 40, buffer 400** — centro dell'altopiano, non massimo.
   Verificato il 06/08 che lo storico non e' incompleto ma solo piu' corto del previsto: **il verdetto
   regge**. Resta un limite di campione, non di dati: 12 mesi di OOS, 240 trade per cella.
2. **Nasdaq, breakout d'apertura: bocciato.** 19 celle su 20 negative fuori campione, 20 su 20 negative
   sotto costo. Nella configurazione testata (BREAKOUT, volumi OFF, RangeMode OPENING) la linea va chiusa.
   **Ma non e' la parola definitiva sul Nasdaq**: la FASE B mostra che con **RETEST** il Nasdaq e'
   positivo in OOS sia con filtro volumi ON che OFF, e il forward gira con `RangeMode=2` (candela H1
   precedente) che **nessun test ha mai usato**. Prima di spegnere: provare RETEST e RangeMode 2.
3. **Il walk-forward e' valido** (verificato il 06/08): la IS non era corrotta, era **piu' corta di come
   la chiamavamo** — 9.1 mesi invece di 18, perche' BCM parte dal 26/09/2024. Le due finestre sono vere e
   contigue. Quindi i crolli IS→OOS della FASE B sono crolli veri, non artefatti.
   Da correggere sono le **etichette**: ovunque c'e' scritto "dal 2024.01.01" va messo **2024.09.26**.
4. **Tre difetti del motore trovati grazie a righe identiche in tabella.** Se due righe che dovrebbero
   differire coincidono al centesimo, non e' una coincidenza: e' un ramo di codice che non gira.
