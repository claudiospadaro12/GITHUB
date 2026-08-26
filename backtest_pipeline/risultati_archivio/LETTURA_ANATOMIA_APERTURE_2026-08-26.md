# 📖 LETTURA — ANATOMIA DELLE APERTURE NASDAQ, 16 ANNI (FASE 1)

_Corsa di Claudio 26/08 18:22-18:23 (27 secondi), pin `3b95be3`, autotest
13/13, ESITO: MISURATO CON RILIEVI (1 rilievo). Artefatti completi in
`ANATOMIA_APERTURE_20260826/`. Questa lettura usa SOLO il referto
`_IS_2010_2020` (regola delle due fasi): la cassaforte 2021-2026 resta
sigillata — archiviata, non letta._

## 0) 🕐 IL CANARINO DEL FUSO — VERDE, su tutte e due le misure

- Pausa giornaliera: **16:14 in TUTTI i 12 mesi** (gennaio = luglio).
- Riapertura di settimana: **18:00 in TUTTI i 12 mesi**.
- Unica eccezione: **marzo** (15:14 / 17:00) = le settimane di DST sfasato
  fra USA ed Europa, attese e dichiarate nei criteri.

**Verdetto: il feed segue il DST americano → l'ora del file È ora locale di
New York → le 09:30 del file sono l'apertura cash TUTTO l'anno.** La
specifica pubblica di HistData ("EST fisso") è **smentita dalla misura**
anche su questo file, come sugli 8 forex. Lo studio è valido: si legge.

## 1) 🩺 COPERTURA — l'IS è quasi immacolato; il malato è il 2023 (cassaforte)

- **IS 2010-2020: %SOSPETTI fra 0,0 e 2,0** su tutti gli anni pieni
  (2010 è un moncone nov-dic, sotto G1, non si cita). Zero righe fuori
  ordine, zero duplicati, zero OHLC incoerenti su 5.233.590 barre.
- **Il rilievo unico della corsa: 2023 = 22,9% di giorni sospetti**
  (47 sospetti + 104 senza apertura su 309). Sta nella CASSAFORTE, quindi
  **non tocca l'addestramento**, ma resta agli atti: quando in FASE 2 si
  validerà sul 2021-2026, **i conteggi 2023 valgono meno** e il confronto
  va fatto anche senza quell'anno. (Coerente con la mappa import: le
  diff-max peggiori stavano lì.)

## 2) 📊 LA RISPOSTA ALLA DOMANDA DI CLAUDIO — quale setup si presenta di più

Distribuzione sui **2.569 giorni buoni** dell'IS (2010-2020), stabilissima
anno per anno:

| Classe | n | % | banda annuale |
|---|---:|---:|---|
| **RIENTRO** | 993 | **38,7%** | 30-45% |
| DRIVE-UP | 634 | 24,7% | 18-28% |
| DRIVE-DOWN | 534 | 20,8% | 19-23% |
| RANGE | 223 | 8,7% | 7-10% |
| FADE-DOWN | 96 | 3,7% | 1-10% |
| FADE-UP | 89 | 3,5% | 1-6% |

- Il 91% dei giorni **rompe** il range dei primi 15'. Di questi, ~50%
  tiene la rottura (DRIVE), ~42% rientra, ~8% inverte (FADE).
- 2LATI = 308/2311 (13%): il peso della regola di priorità è moderato ma
  non trascurabile — dichiarato.
- Covid 2020 ≈ 2010-2019 come distribuzione: le FREQUENZE delle classi
  sono stazionarie anche nell'anno più anomalo del campione.

## 3) 📏 IL NUMERO PIÙ CARICO DEL REFERTO — l'asimmetria dei DRIVE

Mediane in % del prezzo, finestra 60':

| Classe | MFE60 (favorevole) | MAE60 (contraria) | rapporto |
|---|---:|---:|---:|
| DRIVE-UP (n 634) | **+0,529** | −0,106 | **5,0 : 1** |
| DRIVE-DOWN (n 534) | **+0,643** | −0,107 | **6,0 : 1** |
| RIENTRO (n 993) | +0,212 | −0,237 | ~1:1, chiusura ≈ 0 |
| RANGE (n 223) | +0,204 | −0,204 | 1:1, chiusura −0,01 |

**Nei giorni che tengono la rottura, il movimento favorevole mediano è 5-6
volte quello contrario** — e la coda è lunga (DRIVE-DOWN Q3 0,90%, max
3,06%). Nei giorni RIENTRO/RANGE la chiusura a 60' è ~zero: andata e
ritorno. Su un Nasdaq a 24.000, lo 0,53-0,64% mediano = **125-155 punti
indice**: non è il DAX del 03/08 col trailing da 4 punti — c'è spazio
fisico per pagare spread e stop. **Se paga lo dirà la FASE 2 sui tick BCM.**

## 4) 🔁 PERSISTENZA — la direzione nuda dei primi 15' è quasi una moneta

SU: persiste 52,6% (estensione mediana +0,024%). GIÙ: 46,8% (−0,021%).
**Comprare/vendere "la direzione dei primi 15 minuti" da sola non è
un'informazione.** L'informazione sta **nella selezione** (quali rotture
tengono) e **nella forma del payoff** (l'asimmetria del §3), non nel verso.
Asimmetria long/short visibile anche qui: il lato SU persiste di più.

## 5) 🚪 IL GAP NON SPOSTA LE FREQUENZE (alle soglie di casa)

Con le tre fasce ±0,25%: RIENTRO 38/42/35, DRIVE-UP 24/23/27,
DRIVE-DOWN 22/18/23. **Nessuna fascia cambia il quadro.** Il gap, a queste
soglie, non è un interruttore di regime per le FREQUENZE — se ha valore,
va cercato sulle escursioni condizionate, non sulle classi. |gap| mediano
0,315%, Q3 0,601%.

## ➡️ COSA NE SEGUE (proposte, non firme)

1. **La FASE 2 non si disegna sulla frequenza ma sull'asimmetria**: la
   classe più frequente (RIENTRO 39%) ha payoff ~zero; le classi DRIVE
   (45% insieme) hanno payoff 5-6:1. Le due famiglie di ipotesi oneste,
   da scrivere GUARDANDO SOLO QUESTO REFERTO e da validare su cassaforte
   + tick BCM: (a) selezione delle rotture che tengono (drive-following
   con che filtro?); (b) fade delle rotture con stop stretto — che vive
   della frequenza 42% ma paga il 45% di drive contro.
2. **Il 2023 va maneggiato con le pinze in validazione** (22,9% sospetti).
3. I criteri della FASE 2 (quali ipotesi, quali soglie congelate, come si
   valida) sono un documento a sé, con la sua firma. Niente motore oggi.
