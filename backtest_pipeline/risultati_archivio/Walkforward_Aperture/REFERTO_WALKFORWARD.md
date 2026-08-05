# WALK-FORWARD APERTURE — DAX + NASDAQ (05/08/2026)

EA: `ABTG_DAX_Apertura_EU` (magic 770101, D30EUR) e `ABTG_Nasdaq_Apertura_US` (magic 770201, NASUSD).
Driver: `backtest_pipeline/walkforward_aperture.ps1`. Tick reali.
Finestre: **IS** 2024.01.01→2025.06.30 · **OOS** 2025.07.01→2026.06.30 · **FULL** 2024.01.01→2026.06.30.
Gestione fissa in tutte le fasi: rischio 1%, SL a range, TP1_R 0.5 (=1.5R), trailing su candela base M5, chiusura 17:30 server.

---

## ⚠️ PRIMA DI TUTTO: la finestra IS ha meta' dei giorni mancanti

| finestra | mesi | trade medi | trade/mese |
|---|---:|---:|---:|
| DAX IS | 18 | 180.8 | **10.04** |
| DAX OOS | 12 | 244.7 | **20.39** |
| NASDAQ IS | 18 | 184.0 | **10.22** |
| NASDAQ OOS | 12 | 249.0 | **20.75** |

L'EA fa **al massimo un trade al giorno** (`InpOneTradePerDay=1`) e i mesi hanno ~21 giorni di borsa.
L'OOS gira a 20.4 trade/mese = **quasi tutti i giorni**. L'IS gira a 10.0 = **meta' dei giorni**.
Il rapporto e' 2.03 su DAX e 2.03 su Nasdaq — due simboli diversi, sessioni diverse, stesso identico rapporto.
Non e' un effetto di mercato: **e' lo storico BCM che non copre tutto il 2024**. Con ogni probabilita' parte
verso ottobre 2024, quindi la finestra "18 mesi" ne contiene davvero ~9.

Lo stesso rapporto era comparso sul Dow (8.1 IS vs 16.4 OOS). Tre simboli, stesso segno.

**Conseguenze, e vanno prese sul serio:**
1. Il confronto IS→OOS **non e' un test di overfitting valido**: le due finestre non sono confrontabili.
   Dove sotto scrivo "crolla fuori campione" sto descrivendo il dato, non dimostrando l'overfit.
2. La FASE C su FULL mescola meta' vuota e meta' piena: i **valori assoluti** sono sottostimati, ma il
   **confronto fra livelli di slippage** resta valido perche' avviene sullo stesso periodo.
3. L'unica finestra di cui ci si puo' fidare in assoluto e' l'**OOS**.

→ Da fare: verificare in MT5 la data del primo trade nel report IS, scaricare lo storico completo,
rifare la FASE A/B in IS. Finche' non e' fatto, **l'IS non decide niente**.

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
   *Non e' ancora un via libera al forward*: manca la verifica con lo storico completo in IS.
2. **Nasdaq, breakout d'apertura: bocciato.** 19 celle su 20 negative fuori campione, 20 su 20 negative
   sotto costo. Nella configurazione testata (BREAKOUT, volumi OFF, RangeMode OPENING) la linea va chiusa.
   **Ma non e' la parola definitiva sul Nasdaq**: la FASE B mostra che con **RETEST** il Nasdaq e'
   positivo in OOS sia con filtro volumi ON che OFF, e il forward gira con `RangeMode=2` (candela H1
   precedente) che **nessun test ha mai usato**. Prima di spegnere: provare RETEST e RangeMode 2.
3. **Il walk-forward come l'abbiamo impostato non e' ancora valido**, per via dello storico IS dimezzato.
   Il pezzo che tiene e' l'OOS, ed e' su quello che si basano i punti 1 e 2.
4. **Tre difetti del motore trovati grazie a righe identiche in tabella.** Se due righe che dovrebbero
   differire coincidono al centesimo, non e' una coincidenza: e' un ramo di codice che non gira.
