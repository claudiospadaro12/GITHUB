# R84 — L'ABLAZIONE DEI FILTRI DEL CORSO: **9 CELLE SU 9 NEGATIVE IN OOS.** Nessun filtro crea l'edge; una combinazione (D, volumi-OR-ATR) riduce la perdita; il debito M16 e' chiuso PER MISURA.

_19/08/2026. Corsa notturna del 18/08 (raccolta 22:24, commit di riferimento
`2458b33`). NASUSD M15, modello **4 = tick reali** (PASSO 0 promosso: tick
NASUSD dal 2024.09.26, 164,6 mln), deposito 10.000, rischio pinnato 1%/op.
Finestra `2024.09.26 → 2026.06.30`, split IS 40% / OOS 60%: IS fino al
2025.06.09, OOS dal 2025.06.10 [VERIFICATO: anteprime PASSO 2 + prima/ultima
riga per-trade]. Criteri congelati PRIMA dei numeri in
`prove/R84_ABLAZIONE_CRITERI.md`. CSV in `r84_csv/`._

## 🧾 Igiene della corsa [VERIFICATO]

- **18 CSV attesi / 0 mancanti** (referto di raccolta, `data:` 2026-08-18 22:24).
- **Gemelli deterministici**: le due passate magic (776xx0/776xx1) sono
  identiche in TUTTI i 18 aggregati e in TUTTE le 16 serie per-trade del
  pacchetto R84+R83, riverificato con diff Python in fase di referto.
- Un filtro alla volta, soglie da manuale, **nessuna griglia**: l'unico asse
  spazzolato e' la coppia di magic.

## 📊 Tabellone — le nove celle

**IS (2024.09.26 → 2025.06.09)** [VERIFICATO, colonne dai CSV `_IS_`]:

| cella | filtro acceso | Profit | PF | n | DD % | Peggior giornata % | Serie perdente peggiore |
|---|---|---:|---:|---:|---:|---:|---:|
| A | nudo (baseline) | +686 | 1,254 | 156 | 6,14 | −1,89 | −235,65 |
| B | volumi | −175 | 0,876 | 62 | 5,86 | −1,90 | −225,43 |
| C | ATR ≥ media | +349 | 1,283 | 89 | 3,45 | −1,20 | −202,52 |
| D | volumi OR ATR | +858 | 1,514 | 110 | 3,02 | −1,89 | −202,52 |
| E | EMA 14/200 H1 | +607 | 1,385 | 104 | 6,92 | −1,88 | −199,22 |
| F | Supertrend H1 | −316 | 0,823 | 90 | 10,97 | −1,88 | −327,80 |
| G | Supertrend ×3 | −214 | 0,848 | 72 | 9,61 | −1,89 | −282,58 |
| H | correlazione SPXUSD | +445 | 1,305 | 98 | 7,71 | −1,90 | −199,22 |
| I | METODO COMPLETO | +214 | 1,537 | 33 | 3,14 | −1,88 | −190,17 |

**OOS (2025.06.10 → 2026.06.30)** [VERIFICATO, colonne dai CSV `_OOS_`]:

| cella | filtro acceso | Profit | PF | n | DD % | Peggior giornata % | Serie perdente peggiore |
|---|---|---:|---:|---:|---:|---:|---:|
| A | nudo (baseline) | −795 | 0,873 | 291 | 17,07 | −1,05 | −376,55 |
| B | volumi | −85 | 0,950 | 92 | 4,59 | −1,03 | −204,70 |
| C | ATR ≥ media | −92 | 0,972 | 180 | 6,73 | −1,04 | −208,00 |
| D | volumi OR ATR | −287 | 0,924 | 201 | 6,92 | −1,06 | −208,00 |
| E | EMA 14/200 H1 | −1.456 | 0,681 | 202 | 15,66 | −1,19 | −514,89 |
| F | Supertrend H1 | −899 | 0,815 | 217 | 10,84 | −1,05 | −455,17 |
| G | Supertrend ×3 | −994 | 0,739 | 169 | 13,02 | −1,06 | −269,98 |
| H | correlazione SPXUSD | −624 | 0,857 | 211 | 10,13 | −1,18 | −578,73 |
| I | METODO COMPLETO | −289 | 0,785 | 69 | 8,88 | −1,03 | −380,93 |

**Campione intero (IS+OOS)** — Profit e n sono somme [VERIFICATO]; il PF
totale e' ricavato per aritmetica dai due aggregati (GL = Net/(PF−1)) ed e'
quindi **[INFERITO]**, con controprova sul per-trade OOS della cella A
(perdita lorda ricalcolata dal per-trade = 6.267,64 = derivata al centesimo):

| cella | Profit tot | PF tot [INFERITO] | n tot | PF vs A |
|---|---:|---:|---:|---:|
| A | −109 | 0,988 | 447 | — |
| B | −260 | 0,917 | 154 | −0,071 |
| C | +257 | 1,057 | 269 | +0,069 |
| D | **+571** | **1,104** | 311 | **+0,116** |
| E | −849 | 0,862 | 306 | −0,126 |
| F | −1.215 | 0,817 | 307 | −0,171 |
| G | −1.208 | 0,768 | 241 | −0,220 |
| H | −178 | 0,969 | 309 | −0,019 |
| I | −75 | 0,957 | 102 | −0,031 |

## ⚖️ Lettura filtro per filtro — SOLO coi quattro cancelli congelati

I cancelli (`R84_ABLAZIONE_CRITERI.md` §5): (1) ≥30 op totali; (2) coerenza
fra le meta' (segno non ribaltato, O miglioramento in entrambe rispetto ad A);
(3) PF ≥ A+0,10 sul campione intero; (4) DD non peggiore di A di >1pp.
"TOGLIE" = peggiora PF e taglia il campione, o peggiora il DD.

| cella | (1) n | (2) coerenza | (3) PF vs A | (4) DD | **verdetto** |
|---|---|---|---|---|---|
| B volumi | ✅ 154 | ✅ (−/− come segno proprio) | ❌ −0,071 | ✅ (migliora) | **TOGLIE** (PF giu' E campione 447→154) |
| C ATR | ✅ 269 | ❌ (segno ribaltato, IS non migliora vs A) | ❌ +0,069 < +0,10 | ✅ (migliora) | **NON DISTINGUIBILE** (unico PF sopra A, ma sotto la soglia di rumore; non TOGLIE) |
| D vol OR ATR | ✅ 311 | ✅ (migliora in ENTRAMBE vs A: IS +858 vs +686, OOS −287 vs −795) | ✅ +0,116 | ✅ (migliora in tutte e due) | **passa i 4 cancelli** → vedi §"Il caso D" |
| E EMA | ✅ 306 | ❌ ribaltato | ❌ −0,126 | ✅/≈ | **TOGLIE** (l'OOS 0,681 e' PEGGIO del nudo 0,873) |
| F Supertrend | ✅ 307 | ✅ (−/−) | ❌ −0,171 | ❌ IS +4,8pp | **TOGLIE** (doppio titolo: PF e DD) |
| G Supertrend ×3 | ✅ 241 | ✅ (−/−) | ❌ −0,220 | ❌ IS +3,5pp | **TOGLIE** |
| H correlazione | ✅ 309 | ❌ ribaltato | ❌ −0,019 | ❌ IS +1,6pp | **TOGLIE** (via clausola DD; sul PF e' entro il rumore) |
| I METODO COMPLETO | ✅ 102 (ma vedi cautela) | ❌ ribaltato | ❌ −0,031 | ✅ | **TOGLIE** — con cautela formale, sotto |

Tre fatti trasversali, tutti [VERIFICATO] in tabella:

1. **Nessun filtro porta l'OOS sopra PF 1.** Il migliore in OOS e' l'ATR a
   0,972; il nudo fa 0,873. Nove celle su nove OOS-negative.
2. **L'EMA — il filtro di trend piu' citato del corso — e' il PEGGIORE**:
   OOS 0,681, −1.456, serie perdente −514,89. Peggio dello scheletro nudo su
   tutto tranne il DD.
3. **I filtri "comprimono il DD" decimando i trade, non proteggendo quelli
   che restano**: la cella B porta il DD OOS da 17,1% a 4,6% tagliando il
   campione a un terzo (291→92 op). E' selezione di giornate, non gestione
   del rischio.

## 🔍 Il caso D — la lettera dei criteri, e cosa significa davvero

**Per la lettera dei quattro cancelli congelati, la conferma "volumi OR ATR
come la scrive il PDF" (cella D) AGGIUNGE**: campione 311, migliora in
entrambe le meta' rispetto ad A, PF totale +0,116 sopra A, DD dimezzato in
tutte e due le finestre. Non lo si nasconde: i criteri sono stati congelati
prima apposta, e la lettura rapida della notte ("nessun filtro salva niente")
su questo punto era piu' sbrigativa dei criteri stessi.

Ma va scritto per intero cosa quel cancello misura:

- **"Aggiunge" rispetto a una baseline PERDENTE.** La cella D in OOS resta
  negativa (−287, PF 0,924): il filtro **riduce la perdita**, non crea un
  guadagno. Il totale +571 e' fatto tutto nell'IS (+858) [VERIFICATO].
- Il margine +0,116 supera la soglia +0,10 **di poco**, su un PF totale
  ricavato per aritmetica [INFERITO], su un regime e mezzo (Emendamento C).
- I criteri stessi lo dicono (§2): anche se un filtro migliora i numeri,
  **R84 da solo non promuove niente**. La riga di verdetto congelata per
  questo esito prevede al massimo "si apre un round di validazione vera
  (regimi + walk-forward) prima di qualunque forward" — ed e' una PROPOSTA
  che passa dall'architetto e da Claudio, non un'accensione.

## 🧾 La chiusura del debito M16

Il debito (PIANO_PROP v11, M16): *"l'ablazione dei filtri Nasdaq non risulta
mai girata — 'il metodo del corso non funziona' resta NON dimostrato"*.
**Adesso e' girata, a tick reali. Il debito e' CHIUSO, e la frase si puo'
scrivere per misura:**

> **Il metodo del corso sul Nasdaq apertura non regge.** Le nove celle sono
> 9/9 negative in OOS; il miglior filtro singolo (ATR) si ferma a 0,97;
> l'EMA fa 0,68, peggio dello scheletro nudo; il **METODO COMPLETO** (cella
> I, *"se anche un punto e' NO, aspetta"*) chiude l'OOS a 0,785 con **n=69**
> — e con **cautela formale**: la I e' leggibile per la valvola congelata
> (102 op totali ≥ 30) ma e' l'**unica cella sotto le 150 operazioni** del
> campione intero, quindi il suo e' il verdetto meno campionato dei nove.
> Unica sfumatura misurata: la conferma volumi-OR-ATR (cella D) perde meno
> del nudo e passa i cancelli formali — come **riduttore di perdita**, mai
> come edge.

I default spenti delle sedie restano spenti **adesso PER MISURA e non per
omissione** — con l'eccezione documentata della cella D, che resta una
proposta sul tavolo, non un default nuovo (nessun EA e' stato toccato).

## 🪑 Implicazioni — sedia 770201 e FIRMA 5

- **La sedia 770201 (Nasdaq Apertura US) RESTA SPENTA.** Questo e' il
  **terzo verdetto indipendente** contro l'apertura US: (1) walk-forward del
  31/07 (PF 0,82); (2) 05/08, 19/20 celle OOS negative; (3) R84 a tick
  reali, 9/9 OOS negative — e in parallelo R83 aggiunge che nemmeno cambiare
  STILE D'INGRESSO la salva (nessuna delle tre modalita' positiva su NASUSD).
  [VERIFICATO sui referti citati per (1)-(2), sui CSV per (3)]
- **La FIRMA 5 ("spegnile tutte e tre", 18/08) esce RAFFORZATA dalla
  misura**: lo spegnimento della 770201, deciso sul censimento dei contratti,
  oggi ha dietro anche l'ablazione completa dei filtri. Porta di rientro C3
  invariata: serve una tesi NUOVA (o la validazione vera della cella D su
  regimi e walk-forward), non una taratura.

## ⚠️ Limiti dichiarati

- **Un regime e mezzo** (toro USA 2024-2025 + correzione 2025): niente 2020,
  niente 2022. Nessun numero di R84 e' "robusto"; ma il verdetto e' di NON
  promozione su segno OOS unanime, e la clausola di segno si applica.
- **Filtro news ESCLUSO apposta** (copertura del CSV non misurata → R84-bis
  in coda). La regola #12 del corso resta non misurata.
- Soglie dei filtri **da manuale, non spazzolate**: un filtro che
  funzionerebbe con un'altra soglia e' un altro round.
- IS sotto le 150 op in tutte le celle filtrate (62-110): dichiarato in
  anticipo nei criteri (§3.3); il verdetto si legge sul campione intero.

## 📎 Tracciabilita'

- Criteri: `backtest_pipeline/prove/R84_ABLAZIONE_CRITERI.md` (congelati 18/08 sera)
- CSV: `backtest_pipeline/risultati_archivio/r84_csv/` (18 aggregati + 18
  per-trade OOS + `REFERTO_RACCOLTA_R84.txt`, commit `2458b33`)
- Cronaca della corsa: `REFERTO_R83_R84_PREPARAZIONE.md`, PASSO 0-6
- Round gemello della stessa notte: `REFERTO_ROUND83_INGRESSI.md`
