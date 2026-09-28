# 🧯 La dipendenza nelle giornate di stress — il punto 2 di Emiliano, misurato (28/09/2026)

Nasce dal punto 2 del parere di Emiliano (`docs/PARERE_EMILIANO_2026-09-28.md`): *"le correlazioni giornaliere vicine
allo zero non bastano: controlla la dipendenza condizionale nelle giornate di stress (apertura USA, shock macro,
volatilita' estrema, piu' EA sullo stesso indice che ricevono segnali insieme)"*.

Misura di **SOLA LETTURA**, costo macchina zero (CPU su dati gia' in repo). Nessuna proposta di taglia, di soglia del
Guardian o di sedia: sono firme di Claudio.

---

## §1. 🧊 I CRITERI, CONGELATI PRIMA DEI NUMERI

Scritti e committati **prima** di far girare lo script sulle sedie. Ogni numero del §3 in poi si legge contro queste
righe, e solo contro queste.

### §1.1 Le sedie, e quali hanno un per-trade (la stessa base del Monte Carlo)

Fonte dei per-trade: **gli stessi file che carica `backtest_pipeline/mc_challenge_ftmo_v2.py`** (`SORGENTI_V2`, letti
con la sua `carica_v2()`, importata e non modificata), cosi' la misura e' coerente col Monte Carlo del 27/09.

| sedia FTMO `541452707` al 28/09 | per-trade usato | stato nella misura |
|---|---|---|
| `770101` DAX long M5 | `risultati_prove/aperture_r47/..._772501.csv` (100k, 1%) | [MISURATO] |
| `770202` Dow long M5 | `risultati_prove/aperture_r47/..._772505.csv` (100k, 1%) | [MISURATO] |
| `770411` MaxMinNotte DAX short M15 | `risultati_prove/trades_portafoglio/..._770413.csv` (100k, 1%) | [MISURATO] |
| `771531` EMA200 Dow H1 L+S | `risultati_prove/trades_candidati_r23/..._771521.csv` (100k, 1%) | [MISURATO] |
| `770260` Nasdaq L+S M5 | **nessuno** (il MC la dichiara gia' `[NON MODELLATA]`; i per-trade `ABTG_Nasdaq_Apertura_US` in repo girano su **U30USD**, non su NASUSD: non sono questa sedia) | 🔴 **[NON MISURATO]** |
| `770511` SuperWave Dow H1 L+S | **nessuno della cella**. In repo c'e' `770521` = `ABTG_SuperWave` **H2**, cella R23d, 100k, rischio di default **1,0% letto a HEAD** (non verificato alla data del round) | 🔴 **[NON MISURATO]**; `770521` entra **solo** come PROXY etichettato `[DERIVATO]` nelle righe di sensibilita' |
| `770212` Dow short (in firma) | nessuno in repo (R255 non arrivato; il MC la dichiara `[NON MODELLATA]`) | 🔴 **[NON MISURATO]** |
| `770105` DAX short (fuori dall'elenco CODA_01 del 28/09, ma `loaded` il 25/09 20:47 nel giornale FTMO: `NOTTE_2026-09-26.md`) | `risultati_archivio/R251/PERTRADE/..._792520.csv` (10k, 1%), solo 2025.07.01 → 2026.06.29 | riga di **sensibilita'** sulla finestra B, come nel MC |

### §1.2 L'universo e le unita'

- **Universo U = calendario A del MC**: `calendario(dati, V1)` = feriali dal 2025.06.10 al 2026.06.29 + giornate con
  operazioni (277 giornate). Sensibilita' con la `770105`: **calendario B** del MC (2025.07.01 → 2026.06.29, 262).
- **Giornata di una sedia** = somma dei deal chiusi in quella data (colonna `close_time`, ora BCM), come `carica_v2()`.
  Sedia **in perdita nel giorno** = quella somma < 0. Sedia **che ha operato** = almeno un deal chiuso in quella data.
- **% al 2%** = netto / deposito di misura × 2 × 100 (fattore 2,0 del MC: misura all'1% portata al 2,00% di campo).
- 🔴 **Il per-trade ha SOLO le uscite** (`close_time`, nessun orario di apertura): gli orari di apertura non si
  ricostruiscono, quindi **il cap C1 al 4,00% NON si simula**. Si dichiara cosi', e vale per tutto il §3-§5:
  - **netto di giornata N_d** (somma dei deal chiusi quel giorno): rispetto al C1 **ne' tetto ne' pavimento** — il C1
    toglie posizioni, e togliere una posizione vincente peggiora il netto, togliere una perdente lo migliora;
  - **lordo di giornata G_d** (somma dei soli deal in perdita chiusi quel giorno): rispetto al C1 e' un **TETTO**
    (il C1 puo' solo togliere deal); rispetto alle sedie mancanti (`770260`, `770511`, `770212`) e' un **PAVIMENTO**
    (aggiungere una sedia puo' solo aggiungere deal in perdita);
  - rispetto al **muro giornaliero FTMO**, che conta l'equity **con il flottante**, nessuno dei due e' un limite: il
    per-trade non vede il percorso dentro la giornata ne' il flottante delle posizioni che scavalcano la mezzanotte.
    Stesso limite del MC (`mc_challenge_ftmo.py`, limite 2: *"P/L REALIZZATO, non equity"*).
  - la pausa del Guardian (3,5%) **non** e' applicata: si CONTANO le giornate che la supererebbero, non si tagliano.

### §1.3 Le tre definizioni di STRESS (congelate)

**(a) Dato USA ad alto impatto.** Righe `Impatto=High`, `Valuta=USD` di `mql5/Files/abtg_news_2021_2025_UTC.csv`,
a **grana di GIORNO** (la data della riga). Classe 862, applicata: prima di usarlo si stampano i **buchi** (distanza
fra eventi USD consecutivi) e si usa **solo il tratto dove il file e' completo**. Dentro U il file e' completo solo dal
2025.06.10 al **2025.07.03**; dopo restano **solo le decisioni Fed**. Quindi l'insieme (a) e', per nome:
  - (a1) tutte le giornate USD High del file fra 2025.06.10 e 2025.07.03;
  - (a2) le righe `Fed Interest Rate Decision` del file dopo il 2025.07.03;
  - (a3) le righe USD High di `mql5/Files/abtg_news.csv` (2026; orologio del file non verificato, irrilevante a grana
    di giorno: nessun evento cade vicino alla mezzanotte).
  L'insieme si **elenca per nome** nel referto (classe 180): non si usa MAI il suo complemento ("giornate senza
  news"), perche' fuori dal tratto completo "senza news" vuol dire "file bucato" (classe 862 (b)). Il confronto e'
  **STRESS contro TUTTE**. Lo spostamento UTC-1 del file dal 2025.03.30 (classe 862 (c)) **non tocca la data**:
  gli eventi USD dei due file dentro U cadono fra le 11:15 e le 20:00 (lo script lo stampa), lontani dalla
  mezzanotte in ogni orologio in gioco.
  La grana di giorno e' quella giusta **per questa domanda** (il muro FTMO e' giornaliero), non per dire "lo stop lo
  fa il dato" (che vivrebbe nei minuti, classe 862 (a)): quella frase qui NON si dice.

**(b) Volatilita' estrema.** Il range giornaliero dell'indice richiederebbe un archivio prezzi giornaliero di
U30USD/NASUSD/D30EUR sulla finestra U: **in repo non c'e'** (cercato: `studio_apertura/` non ha date, `r91_csv/` ha
due giornate M1 isolate). Quindi **(b) come scritta = [NON MISURATO]**. PROXY dichiarato, e NON circolare (si decide
all'ingresso, non dall'esito):
  - lo stop delle sedie d'apertura e' sul **range d'apertura** (`ABTG_Dow_Apertura_US.mq5` r.282 `InpSLMode =
    ABTG_SL_RANGE`, floor r.313), e il lotto e' dimensionato sul saldo: **stop ∝ saldo / volume della posizione**.
    Saldo = 100.000 + netto cumulato delle posizioni della sedia chiuse prima; volume = somma dei volumi dei deal
    d'uscita della posizione; per giornata il massimo.
  - **(b-US)** = le `ceil(n/10)` giornate col proxy piu' alto fra le n giornate in cui `770202` ha operato
    ("volatilita' all'apertura USA", non "range giornaliero"); **(b-DAX)** = idem su `770101` ("apertura DAX").
  - Limiti dichiarati: vede solo le giornate in cui la sedia ha operato; sul Dow il cambio EURUSD sposta il proxy di
    qualche punto percentuale nell'anno; il floor dello stop satura il fondo, non la cima.

**(c) Almeno 3 sedie USA che hanno operato nello stesso giorno.** Le sedie USA in campo sono quattro (`770202`,
`770260`, `771531`, `770511`); con per-trade misurato ce ne sono **due**. Quindi **(c) come scritta = [NON
MISURATO]**. Si calcolano accanto, etichettati:
  - **(c2) [MISURATO]**: giornate in cui `770202` **e** `771531` hanno operato (>=2, non >=3: e' un sostituto piu'
    debole, e si dice);
  - **(c3) [DERIVATO, proxy]**: giornate in cui `770202`, `771531` **e** il proxy `770521` hanno operato.

### §1.4 Le misure e le soglie di lettura

**Domanda 1 — co-perdita per coppia**, su ogni insieme S (TUTTE = U; poi a, b-US, b-DAX, c2, c3):
- n = giornate di S; pA, pB = frazione di giornate di S in cui la sedia e' in perdita; pAB = frazione in cui lo sono
  **tutte e due**; **lift = pAB / (pA × pB)** (1 = indipendenti; > 1 = perdono insieme piu' del caso);
- **p di Fisher** a una coda (ipergeometrica: co-perdite >= osservate date le marginali dentro S);
- accanto, la versione **"solo giornate in cui operano entrambe"** (n2 = co-operative in S): separa il legame
  degli ESITI dal semplice fatto di operare insieme;
- 🔴 **n < 20 giornate (o n2 < 20 per la versione accanto) = NON LEGGIBILE**, e al posto del numero si scrive la
  parola. Se pA o pB = 0 in S: **NON DEFINITO**.
- Verdetto per coppia e insieme: **LEGATE** se leggibile, lift > 1 e Fisher p < 0,05; **NESSUN LEGAME MISURABILE**
  se leggibile e p >= 0,05; altrimenti NON LEGGIBILE / NON DEFINITO.
- **"Lo stress le lega di piu'"** (per coppia e insieme S): S leggibile **e** lift_S > lift_TUTTE **e** p di
  permutazione < 0,05, dove la permutazione estrae 10.000 sottoinsiemi casuali di U della stessa taglia di S
  (seme 20260928) e conta la frazione con **co-perdite >= quelle di S**. Per (c2)/(c3) il conteggio e' gonfiato per
  costruzione (le sedie operano per definizione): li' vale solo il lift nella versione "operano entrambe", e il test
  di permutazione si estrae fra le giornate co-operative di U.

**Domanda 2 — perdita del portafoglio nel giorno**, sulle 4 sedie misurate al 2,00% (poi la sensibilita'):
- per ogni S: n, peggior giornata, p95, p99 di **L_d = −N_d** (netto) e di **G_d** (lordo), in % del saldo;
  quante giornate con L_d > **3,5%** (pausa del Guardian) e > **4,5%** (taglio giornaliero), idem per G_d;
- percentili a rango piu' vicino su tutte le giornate di S (zeri compresi); 🔴 **il p99 si stampa solo con n >= 100**,
  sotto e' "= massimo osservato", non un p99; **n < 20 = NON LEGGIBILE**.

**Domanda 3 — le tre sedie Dow** (`770202`, `771531`, `770511`): con i dati misurati e' la **coppia** `770202` ×
`771531` (giornate con 2 in perdita, su U e sugli insiemi di stress, criteri della domanda 1). Il **tris** con
`770521` al posto di `770511` e' `[DERIVATO, proxy]`: giornate con 2 o 3 in perdita, stesse soglie.

**Sensibilita' congelate**: (s1) finestra B con `770105` (5 sedie); (s2) + proxy `770521` (per la domanda 2 alla
taglia 2% assumendo misura all'1% = default a HEAD, `[DERIVATO]`).

**Contro-esempio prima della consegna** (regola del 10/09): lo script ha un `--autotest` con serie sintetiche a
dipendenza NOTA — due serie identiche (lift = 1/pA, Fisher ~0), due serie indipendenti (lift ~1, Fisher non
significativo), una coppia indipendente fuori dallo stress e identica dentro (lo strumento deve dire "lo stress le
lega di piu'"), e il suo **placebo** (etichetta di stress a caso: non deve dirlo); piu' la soglia n < 20 e i conteggi
della domanda 2 fatti a mano. Se l'autotest fallisce, i numeri non si leggono.

---
