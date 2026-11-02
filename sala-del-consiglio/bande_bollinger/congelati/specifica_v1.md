# Bande di Bollinger (37/3 + S/R) sugli indici — SPECIFICA v1 (congelata prima di ogni risultato)

Fonte: presentazione `breaking_band/materiali/strategia_bande_bollinger.pptx` (testo in `..._pptx_testo.txt`).
La presentazione e' qualitativa: le scelte numeriche sotto sono di C0, dichiarate PRIMA dei risultati e non modificabili dopo.
Verdetto solo sul test PRIMARIO (sezione 9). Tutto il resto e' esplorativo.

## 1. Dati
- NASUSD_EXT e SPXUSD_EXT, M1, CSV `time;open;high;low;close;tickvol;spread` (`;`, tempo `YYYY.MM.DD HH:MM`).
- Periodi: P2015 (anno 2015), P2020 (anno 2020), P2025 (01/01/2025–31/07/2026). File con sha256 in `HASH_DATI.txt`.
- Orario: ai timestamp dei file si aggiunge +60 minuti (i `_EXT` sono 1 h indietro rispetto al server BCM). Tutta la specifica usa questo orario "server BCM".
- Prezzi = BID. Spread nei file = 0 -> spread assunto: `sp(t) = SPREAD_BP * 1e-4 * open_t` con SPREAD_BP = 1.0 (Nasdaq), 2.2 (S&P500) (da spread reale BCM 2025: 2,20 pt su 21.227 e 1,30 pt su 5.922).
- Ask = bid + sp. Long entra ask, esce bid. Short entra bid, esce ask.

## 2. Barre
- H1: aggregazione M1 per ora piena (orario server). Barre senza M1 non esistono (nessun riempimento). open=prima M1, high/low=max/min, close=ultima M1.
- D1: giorno di calendario server; W1: settimana ISO (lun–dom) sulla data server; MN: mese di calendario. Solo periodi COMPLETI e precedenti alla data della barra di segnale (data = data di inizio barra): D1 = giorno precedente con dati (ultimo giorno con M1 prima di quella data), W1 = ultima settimana ISO precedente a quella della barra, MN = ultimo mese precedente.
- Livelli S/R: SUPPORTI = low di D1, W1, MN precedenti; RESISTENZE = high di D1, W1, MN precedenti (6 livelli).

## 3. Indicatori (su close H1, barra j inclusa)
- SMA37_j = media dei 37 close; sigma_j = deviazione standard POPOLAZIONE (ddof=0) dei 37 close.
- Upper_j = SMA37_j + 3·sigma_j; Lower_j = SMA37_j − 3·sigma_j.
- ATR_j = media semplice dei 14 True Range (TR_k = max(h_k−l_k, |h_k−c_{k−1}|, |l_k−c_{k−1}|)), k=j−13..j.
- Si genera segnale solo se j ha almeno 38 barre precedenti nell'elenco delle barre del periodo.

## 4. Segnale (a barra j chiusa)
- LONG se: low_j <= Lower_j E esiste un supporto L con |L − low_j| <= TOL·ATR_j (TOL = 0.5).
- SHORT se: high_j >= Upper_j E esiste una resistenza L con |L − high_j| <= TOL·ATR_j.
- Filtro "dopo rilascio dati" (proxy, calendario non disponibile): si scartano i segnali di barre con ora di inizio 13:00 o 14:00 (server).
- Se l'inizio della barra j+1 dista piu di 2 ore dall'inizio di j -> segnale scartato (weekend/pausa).

## 5. Ingresso (primario = A)
- A: a mercato all'apertura della prima M1 della barra j+1 (long ask, short bid).
- Stop: LONG SL = low_j − K·ATR_j; SHORT SL = high_j + K·ATR_j, K = 1.5. Fisso, non si muove.
- Se al prezzo d'ingresso lo stop e' gia raggiunto o superato -> segnale scartato.
- Rischio R0 = |ingresso − SL| (l'ingresso include lo spread).

## 6. Uscita
- Target = SMA37 dell'ultima barra H1 chiusa (inizialmente SMA37_j; aggiornata a ogni chiusura barra, attiva dalla M1 seguente). Se all'ingresso il target e' dalla parte sbagliata (long: target <= ingresso; short: target >= ingresso) -> segnale scartato.
- Minuto per minuto, SL controllato PRIMA del target. LONG: SL se bid_low <= SL (fill a SL, o all'open se open <= SL); target se bid_high >= target (fill AL LIVELLO). SHORT: SL se ask_high = high+sp >= SL (fill a SL, o all'ask open se piu alto); target se ask_low = low+sp <= target (fill al livello).
- Dopo un aggiornamento del target, se all'open della M1 seguente il target e' gia superato dal prezzo: uscita a mercato a quell'open (motivo MKT).
- Chiusura forzata dopo MAXHOLD = 100 barre H1 dall'ingresso: a mercato all'open della M1 successiva (motivo TF). Dati finiti: ultimo close (motivo FINE_DATI).
- Esito in R = P&L / R0 (long: (uscita_bid − ingresso_ask)/R0; short: (ingresso_bid − uscita_ask)/R0).
- Una sola posizione per (strumento, periodo) alla volta; nuovi segnali considerati solo se la chiusura di j e' successiva alla chiusura del trade precedente.

## 7. Baseline e placebo
- B1 "solo bande": stessa cosa SENZA condizione S/R (qualsiasi uscita dalle bande, filtro orario e resto uguali).
- PLACEBO S/R: i 6 livelli sono spostati di δ = s·U(1,3)·ATR_j con s=±1 casuale (per livello e per barra), 100 semi (seed 1..100). Si confronta il R medio reale col 90° percentile dei R medi placebo; p = frazione dei placebo con R medio >= reale.

## 8. Statistica
- Bootstrap a blocchi per settimana ISO di ingresso, 10.000 ricampionamenti, seed 20261102; IC90 = percentili 5 e 95 del R medio.
- Win rate, R medio vincite/perdite, breakeven = |R medio perdite|/(R medio vincite+|R medio perdite|).
- Si riportano anche long e short separati e per strumento/periodo (descrittivo).

## 9. Test primario (UNICO che decide il verdetto)
H1; strumenti NASUSD_EXT e SPXUSD_EXT; periodi P2015+P2020+P2025 insieme; ingresso A; K=1.5; TOL=0.5; spread SPREAD_BP; MAXHOLD=100; filtro orario attivo.

## 10. Esplorativi (non cambiano il verdetto)
- M15 (stesse regole, barre M15, MAXHOLD=100 barre, filtro orario sui segnali delle barre con inizio 13:00–14:59, 'barra successiva' dista >30 min -> scartato).
- K in {1.0, 2.5}; TOL in {0.25, 1.0}; senza filtro orario; spread x2.
- Ingresso B (limit al livello S/R, validita 4 barre): non implementato in v1.
- Se il verdetto e' INCONCLUSIVO per N<30: estensione pre-registrata con gli anni 2011–2014, 2016–2019, 2021–2024 (stesse regole, nessun parametro cambiato), se Claudio manda i file.
