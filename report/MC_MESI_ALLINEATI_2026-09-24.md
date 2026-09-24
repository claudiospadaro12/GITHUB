# 🎲 MC challenge FTMO con le sedie a orario lette SOLO nei mesi allineati — 24/09/2026

**Domanda**: quanto vale la probabilità di passare la challenge FTMO (conto **541452707**, `C:\FTMO`)
se le tre sedie a orario (`770101` DAX Apertura, `770202` Dow Apertura, `770411` MaxMin DAX Short)
si leggono **solo nei mesi in cui il backtest armava all'apertura cash**, cioè come operano oggi
in FTMO? Origine: `report/OROLOGIO_BCM_2026-09-24.md` §5.1.

**Strumento**: `backtest_pipeline/mc_challenge_ftmo_allineati.py` (nuovo). **Importa**
`mc_challenge_ftmo.py` senza modificarlo (`carica`, `serie`, `simula`). Si rifà con:
`python3 backtest_pipeline/mc_challenge_ftmo_allineati.py` (~12 s).

Parametri di **tutte** le varianti = quelli del 74,6% di `report/SECONDO_STOP_FTMO_2026-09-24.md`:
rischio 2,00% (scala ×2 dalla misura a 1,00%), Guardian 4,5%/giorno, saldo di partenza
76.573,86 / 80.000 = **0,95717**, seme **11**, **20.000** simulazioni.

---

## 1. ✅ Riproduzione del riferimento (prima di tutto il resto)

- `mc_challenge_ftmo.main()` via import con `SALDO_VERO_2209 = 76573.86`: **tutta** la tabella del
  24/09 torna al decimale (61,8 · **74,6** · 68,4 · 91,3 · pessimisti 57,6 / 57,2).
- Il simulatore della variante (`simula_mix`, copia riga per riga di `simula` con un solo aggancio
  sul valore della giornata) **con aggancio nullo** dà lo stesso esito di `m.simula` — **identico**,
  stessi esiti e stessa mediana dei giorni (74,6000% · statico 25,4% · 20 giorni). Lo script si
  ferma se non è così.

## 2. 📅 Calendario e ricontro dei PF (§5.1.1)

Classificazione per **data di chiusura** del trade (ora server BCM, UTC+1 fisso). Nella finestra
2025.06.10 → 2026.06.29 c'è **un solo inverno**.
- DAX sfasato: **26/10/2025 ≤ d < 29/03/2026** · USA sfasato: **02/11/2025 ≤ d < 08/03/2026**.

| sedia | n allineati | n sfasati | PF allineati | PF sfasati | netto allineati | netto sfasati |
|---|---:|---:|---:|---:|---:|---:|
| `770101` DAX Apertura | 144 | 126 | **1,27** | 1,48 | +5.065,53 | +12.964,05 |
| `770202` Dow Apertura | 73 | 57 | **0,78** | 1,66 | −2.415,84 | +9.137,77 |
| `770411` MaxMin DAX | 8 | 13 | **2,03** | 2,25 | +2.189,51 | +3.953,87 |
| `771531` EMA200 *(calendario USA)* | 347 | 170 | 2,05 | 0,87 | +25.939,44 | −2.617,97 |
| `771531` EMA200 *(calendario DAX)* | 319 | 198 | 1,84 | 1,14 | | |

✅ **Ricontati alla fonte: coincidono con il report al centesimo** (1,27 / 0,78 / 2,03 e i netti).

🔴 **n piccoli, da dichiarare**: nei mesi allineati **144 / 73 / 8** — **tutte e tre sotto 150**.
Il **merito** di queste sedie nei mesi allineati **non si legge** su questi campioni (8 operazioni
per `770411` non sono un campione). Il numero del Monte Carlo qui sotto è uno **scenario di
rischio**, non un verdetto di merito.

## 3. 🎲 Le varianti

| variante | cosa cambia | giornate | op/giornata simulata | **PASS** | Δ vs rif. |
|---|---|---:|---:|---:|---:|
| **V0 riferimento** | niente (`mc_challenge_ftmo` com'è) | 242 | 3,88 | **74,6%** | — |
| **V1 orario → allineati** | le 3 sedie a orario, nei giorni sfasati, sostituite da un giorno feriale allineato estratto a caso; EMA200 intatta | 242 (103 sostituite) | 3,61 | **70,8%** | **−3,8** |
| V1, semi 12 / 13 / 14 | idem | | | 71,1 / 70,7 / 70,8% | |
| V1, donatori = solo giornate con trade | sensibilità sulla frequenza del donatore | 242 (103) | 3,72 | 70,2% | −4,4 |
| **V2 tutti estivi** | solo giornate "tutto allineato", **tutte** le sedie | 139 | 3,90 | **81,3%** | **+6,7** |
| V4 tutti invernali | solo giornate "tutto sfasato", tutte le sedie | 87 | 3,91 | 71,6% | −3,0 |
| **V3 placebo** | sedie a orario **intatte**, **solo EMA200** ai mesi estivi | 242 (87 sostituite) | 3,86 | **83,2%** | **+8,6** |

n per sedia: V2 = `770101` 144 · `770202` 71 · `770411` 8 · `771531` 319; V4 = 105 · 57 · 8 · 170.
In nessuna variante il muro giornaliero morde (0,0%): il Guardian lo copre; tutto il rischio è sul
**muro statico** (V1: 29,2% contro 25,4%). Giorni mediani per passare: V0 20, V1 32.

### Come è trattata la frequenza (dichiarato)
Il MC originale ricampiona le **giornate con almeno un trade** (242). In V1 ogni giornata in cui una
sedia a orario è sfasata tiene il contributo **vero** delle sedie non sfasate (EMA200 sempre; il
Dow fra il 26/10 e il 01/11 e fra l'08/03 e il 28/03, perché lì solo il DAX è sfasato) e riceve per
le sedie sfasate il contributo di un **giorno feriale "tutto allineato"** estratto a caso (nuova
estrazione a ogni uso; zero se quel giorno la sedia non ha operato). Il gruppo DAX (`770101`+`770411`)
e il Dow si sostituiscono insieme quando sono sfasati insieme, quindi la loro correlazione reciproca
resta. Così la frequenza delle sedie a orario è quella **per feriale** dei mesi allineati:

| sedia | op/feriale allineati | op/feriale sfasati | salto |
|---|---:|---:|---:|
| `770101` DAX | 0,873 | 1,145 | **+31%** |
| `770202` Dow | 0,395 | 0,633 | **+60%** |
| `770411` MaxMin | 0,048 | 0,118 | **+146%** |
| `771531` EMA200 | 1,843 | 1,889 | +2,5% |

La flotta passa da **3,88 a 3,61 op/giornata simulata**. Con i donatori presi solo fra le giornate
con trade (frequenza un po' più alta) viene 70,2% invece di 70,8%: **la forchetta di V1 è
70,2-71,1%** fra definizione del donatore e seme. Errore Monte Carlo a 20.000 prove: ±0,3 punti.

## 4. 🧪 Il contro-esempio — e che cosa dice

1. **La stagione da sola sposta di più dell'orologio.** Applicare lo stesso filtro estivo alla
   **sola EMA200** — che dall'orologio non dipende — sposta la probabilità di **+8,6 punti** (V3),
   più del doppio dei −3,8 di V1, e **nel verso opposto**. Filtrare **tutte** le sedie all'estate
   (V2) dà **81,3%**, cioè **più** del riferimento: il semestre estivo, preso intero, è stato
   **migliore** per la flotta, non peggiore. V2 e V1 **non** sono simili (81,3 contro 70,8), e la
   differenza (+10,5) è tutta EMA200 estiva.
2. **Placebo sui mesi** (tutti i 1.716 sottoinsiemi di 7 mesi su 13): il PF allineato del Dow
   (0,78) sta al **3,3%** più basso della distribuzione; quello di EMA200 (2,05) al **94,4%**, cioè
   nel 5,6% più alto. **Due code di estremità simile**, una su una sedia a orario e una su una sedia
   che l'orologio non tocca: un taglio stagionale contiguo produce estremi di questa taglia anche
   senza orologio. (`770101` 31,6%, `770411` 46,2%: dentro la massa.)
3. **L'unica asimmetria che il contro-esempio NON riproduce è la frequenza**: le tre sedie a orario
   operano +31% / +60% / +146% in più per feriale nei mesi sfasati, EMA200 solo +2,5%. È coerente
   con un meccanismo d'orologio (range costruito sul pre-mercato, §5.1.2 del report orologio), ma
   **non lo dimostra**: con un solo inverno anche un regime di volatilità diverso può farlo.

## 5. 📌 Cosa è dimostrato e cosa no

- ✅ **Dimostrato**: il riferimento 74,6% si riproduce al decimale; i PF di §5.1.1 si ricontano al
  centesimo; **se** le tre sedie a orario si comportano come nei mesi allineati dell'unica estate
  misurata e il resto della flotta come in tutto l'anno, la probabilità di passare è **70,8%**
  (forchetta **70,2-71,1%**), cioè **−3,8 punti** sul 74,6%. Il rischio sale tutto sul muro statico.
- ❌ **NON dimostrato**: che quei −3,8 punti siano **dell'orologio**. Nella finestra c'è **un solo
  inverno**, quindi "mesi sfasati" e "inverno 2025/26" sono **la stessa cosa** e non si separano:
  lo stesso filtro stagionale su una sedia insensibile all'ora muove la probabilità di +8,6 punti.
  Il 70,8% è lo scenario "orologio colpevole"; il 74,6% resta lo scenario "tutto è stagione";
  **nessuno dei due è misurato come vero**.
- ⚠️ **Merito non leggibile**: n allineati 144 / 73 / 8, tutti sotto 150. Il rischio si legge a
  qualunque n, e V1 è una lettura di rischio.
- 🔎 **Che cosa separerebbe le due cause** (solo misura, nessuna decisione): uno storico che
  contenga **più inverni con l'orologio nuovo** o, sullo storico `_EXT`/vecchio orologio, gli
  stessi EA con `InpSessionHour` spostato di un'ora d'inverno — cioè l'orologio cambiato **a
  stagione ferma**.

**Limiti ereditati da `mc_challenge_ftmo.py`** (non cambiano qui): 4 sedie su 6 (`770260` e
`770511` fuori: SuperWave non è nel MC, quindi "invariata" vuol dire assente), P/L realizzato e non
equity, un solo regime (toro), scala ×2 misurata a ×1,956-1,990. **In più per V1**: nelle 103
giornate sostituite si rompe la correlazione fra EMA200 e le sedie a orario (il donatore viene da
un altro giorno); 7 feriali sfasati senza nessun trade (27/10, 25/12, 01/01, 03/03, 11/03, 16/03,
27/03) non sono nel pool e non ricevono donatore (su 110 feriali sfasati DAX).

Nessuna proposta di taglia né di spegnimento: i numeri sono per la decisione di Claudio.
