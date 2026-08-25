# 🏁 R107 — REFERTO DEL ROUND: I LATI SHORT DELLE APERTURE (Dow · DAX · Nasdaq)

_Corsa: 25/08/2026 21:14-21:23 (0,2 ore), tick reali, pin `690773f`, driver
`RIGA_R107_LATI_SHORT.ps1` (marcatore v1). Esito driver: **COMPLETO CON
RILIEVI, 0 guasti** — tutte e 6 le celle hanno prodotto i numeri.
Zip agli atti: `R107_LATI_SHORT_CORSA_20260825_2114.zip`.
Criteri firmati da Claudio il 25/08 ("FIRMO CON PROPOSTE", verbale in
`R107_CRITERI.md`, commit 52ebe61); la corsa e' partita con `-CriteriFirmati`
e il rilievo del driver sul `[DA FIRMARE]` al pin e' spiegato li'._

## ✅ IL BANCO E' SANO — G0 e G0-bis riprodotti al millesimo

| Gate | Atteso | Misurato | Verdetto |
|---|---|---|---|
| G0 Dow (cella viva long) | PF 1.270 / DD 4.39 / n 130 | PF 1.270 / DD 4.39 / n 130 | **RIPRODOTTO** |
| G0 DAX (cella viva long) | PF 1.397 / DD 7.23 / n 270 | PF 1.397 / DD 7.23 / n 270 | **RIPRODOTTO** |
| G0-bis Dow short (R54) | PF 0.840 / DD 8.62 / n 73 | PF 0.840 / DD 8.62 / n 73 | **RIPRODOTTO** |
| G0 NAS | non applicabile (nessuna sedia viva) | rif. long: PF 1.110 / DD 5.62 / n 113 | dichiarato |

Le celle short si leggono quindi **sullo stesso metro di agosto**. E la regola
dei due lati (25/08) e' servita: **il lato long e' stato RITESTATO davvero**,
non dato per buono.

## 📊 LA TABELLA MADRE (IS 24.09.26→09.06.25 · OOS 10.06.25→30.06.26 · rischio 1%)

| FAM | Cella | IS prof | IS PF | IS n | OOS prof | OOS PF | OOS DD% | OOS n | dPF vs long |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|
| DOW | long (metro) | +2.812 | 1.222 | 74 | +6.722 | 1.270 | 4.39 | 130 | — |
| DOW | **short** | +6.463 | 1.511 | 73 | **−2.592** | **0.840** | 8.62 | 73 | −0.430 |
| DAX | long (metro) | +3.789 | 1.126 | 175 | +18.030 | 1.397 | 7.23 | 270 | — |
| DAX | **short** | **−996** | **0.965** | 138 | **−1.865** | **0.957** | 12.31 | **257** | −0.440 |
| NAS | long (rif.) | +1.371 | 1.080 | 85 | +1.873 | 1.110 | 5.62 | 113 | — |
| NAS | **short** | **+8.399** | **3.220** | 58 | **−10.569** | **0.460** | 11.34 | 59 | −0.650 |

## ⚖️ I CANCELLI, APPLICATI A MANO

- **G1 (n≥30 per cella):** passano tutte (58-257).
- **G2 (merito: PF OOS ≥ 1,10 E IS positivo):** **0 su 3.** Dow short 0,840
  (IS positivo ma OOS rosso), DAX short 0,957 (rosso in ENTRAMBE le finestre),
  NAS short 0,460 (IS verdissimo, OOS il piu' rosso del round).
- **G3 (coerenza cross-mercato):** **COERENTE — ed e' l'informazione forte del
  round.** Il delta short-vs-long in OOS e' negativo su tutti e tre i mercati
  (−0,43 / −0,44 / −0,65): non e' un mercato storto, e' il LATO.
- **G4 (campione):** Dow (74/130) e NAS (85/58-113) sotto i 150
  dell'Emendamento A → **merito SOSPESO su quelle famiglie**. Il **DAX ha
  n OOS 257: il merito e' MISURABILE** — ed e' no.
- **G5:** nessuna promozione. Niente tocca il forward.

## 🧭 I TRE VERDETTI

1. **DAX SHORT — LA MISURA NUOVA DEL ROUND (registro riga A3, in coda da un
   anno): NIENTE EDGE, e stavolta e' MISURATO.** PF 0,965 in IS e 0,957 in
   OOS con n 257: rosso in tutte e due le finestre, **compresa quella che
   contiene la discesa di febbraio-aprile 2025**. Non e' nemmeno la scusa del
   regime: il lato short del DAX in apertura non paga neppure quando il
   calendario glielo apparecchia. Riga A3 del registro: **da ⏳ a 🔴.**
2. **DOW SHORT: la bocciatura di R54 e' CONFERMATA** (riproduzione esatta,
   PF OOS 0,840). Nessuna domanda riaperta.
3. **NASUSD SHORT: la geometria del Dow NON SI TRASPORTA** — verdetto
   pre-dichiarato nei criteri (par. 2.3): punti assoluti su scale diverse.
   'Non si trasporta' ≠ 'il Nasdaq non ha edge in apertura': solo la prima
   frase e' misurata qui.

## 🔍 IL DETTAGLIO CHE VALE UN ROUND FUTURO (e resta [INFERITO])

**NAS short IS: PF 3,220, +8.399 in 58 trade — poi PF 0,460 in OOS.** Insieme
al Dow short (IS 1,511 → OOS 0,840) disegna il pattern che i criteri avevano
pre-scritto: **l'edge dello short vive nelle DISCESE, e la discesa
documentata (feb-apr 2025) sta nell'IS mentre l'OOS e' quasi tutto salita.**
Questo round NON misura i sotto-periodi, quindi resta [INFERITO]. La misura
vera e' la **prova di regime** (decisione D3 dei criteri: round dedicato)
— che oggi e' **bloccata dal frigo dei dati esterni indici** (vedi
`ANALISI_CANCELLO_ZERO_EXT_2026-08-25.md`): le due misure lampo sul cancello
qualita' e la riga storico indici sono il prerequisito.
⚠️ Il DAX e' l'eccezione che pesa: short rosso ANCHE nell'IS con la discesa
dentro. Se la prova di regime un giorno assolvesse gli short di Dow/Nasdaq
nelle discese, quella del DAX resterebbe comunque una bocciatura.

## 📌 A REGISTRO

- La finestra e' UN SOLO regime (21 mesi di salita): i verdetti short valgono
  **per questa epoca e queste geometrie** (criteri par. 11.5) — tranne il DAX,
  bocciato anche nella sotto-finestra favorevole (con la riserva [INFERITO]
  sopra).
- Magic 761xxx: bruciati da questo round, non si riusano.
- Seconda Caccia: gia' assolta in anticipo — la caccia M5/M15 del 25/08 ha
  promosso i meccanismi alternativi (fade/VWAP/volume) e il lato short
  simmetrico arriva dai candidati nuovi (VWAP Mean Reversion), non da
  un'altra griglia su questo motore.
