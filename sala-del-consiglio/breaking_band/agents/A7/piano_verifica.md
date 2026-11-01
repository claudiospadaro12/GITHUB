# Piano di verifica indipendente — Breaking Band (A7, R004) — versione 2 (fase 3)
Aggiornato a: `congelati/specifica_v1.md` (sha256 4da8af64af86d216c592f5ba95166a3d72d072a7be09dc734915d09bdbb60a92), `disegno_test_v1.md` (4cde9896...b022), `criteri_previsioni_v1.md` (83750bad...30a8) e a D003-D005 (H1 pooled CONT+INV ipotesi primaria unica; M30 esplorativo, M15 NON testato; target ricalcolato ogni 3 ORE = H1 3 barre, M30 6 barre; fill del target in gap AL LIVELLO; log con schedule completa dei target). Gli hash dei tre documenti sono stati ricalcolati il 01/11 e coincidono con `congelati/HASH_DOCUMENTI.txt`.
Regola ferrea di C0 rispettata: NESSUN CSV reale e stato letto o eseguito (nemmeno hashato). Tutto cio che e "ESEGUITO" qui sotto e su dati SINTETICI.
Stati: SUPERATO / FALLITO / NON_CONCLUSIVO / NON ESEGUITO. Un controllo non eseguito o non concluso NON e superato.

## 1. Interfaccia (aggiornata): cosa offre A4 oggi (letta da README/interfaccia, NON ispezionato riga per riga)
- `signals.signal_fn_factory(variante, tf_min)` -> `fn(bars)` con `bars` = dict time/open/high/low/close[/spread]; restituisce `{signal, atr, sma20}`. `signals.rileva(...)`: segnali, imbuto per barra (B1-B6) e per episodio, episodi.
- `engine.simula_trade(...)`: log con schedule COMPLETA dei target, `entry`, `stop`, `exit`, `motivo` (SL/TP/MKT/TF/FINE_DATI), `R`, `sl_e_tp_stesso_minuto`, scarti con codice. U-A7-1 (interfaccia) risolto; U-A7-2 (fill target in gap) risolto (A4 riempie al livello).
- Aperto: U-A7-3 la chiusura a tempo (solo sensibilita Sc, maxhold 150): A4 usa l'ultima M1 della barra, il mio ricalcolatore l'apertura della prima M1 dopo l'istante; irrilevante nella primaria (maxhold 1000). DA_VERIFICARE per Sc.

## 2. Convenzioni del ricalcolatore (allineate alla specifica sez. 6) — `verifica_generica.simulate_trade`
Modello `executable` (prezzi dati = BID, ask = bid + spread della stessa M1; long entra ad ask ed esce a bid: stop se Low<=stop, target se High>=target; short entra a bid, esce ad ask: stop se High+spread>=stop, target se Low+spread<=target); ingresso all'open della prima M1 della barra tau+1; stop = entry -/+ 3 ATR(tau) dal fill (livello preso dal log); target = schedule del log; **stop prima del target** nella stessa M1 (anche M1 di ingresso e di ricalcolo); gap: stop all'apertura se peggiore, **target AL LIVELLO**; (a) target0 gia oltre il prezzo -> nessun trade (`TARGET_OLTRE_INGRESSO`); (b) dopo un ricalcolo, target gia superato all'apertura -> uscita a mercato (`mkt`); gap ingresso > 180 min -> nessun trade; fine dati: close ultima M1; spread 0 sostituito dalla mediana dei non nulli dello stesso periodo e ora server (`replace_zero_spread`). Verificate con casi a mano (auto-test 62/62).

## 3. Controlli e stato (V01-V23)
Gravita: B = bloccante per "verificato localmente", S = significativa (va dichiarata). Colonna "Stato": cosa e stato fatto VERAMENTE; "Quando" per il resto: ESEGUIBILE ORA (codice di A4 esiste, nessun dato reale necessario) / DOPO CODICE (congelamento del codice) / DOPO RUN (servono i risultati) / DOPO AUTORIZZAZIONE C0 (tocca i CSV reali).

| ID | Controllo (req.) | Tipo | Criterio SUPERATO / FALLITO | Gr. | Stato / Quando |
|---|---|---|---|---|---|
| V01 | Invarianza al troncamento del futuro (R003, R004) | E | SUPERATO: zero differenze su tutti i tagli (esaustivi se n<=3000, altrimenti 150-200 casuali + intorno ai segnali) e >= 2 segnali nella regione; FALLITO: una differenza | B | **ESEGUITO su A4, sintetico: SUPERATO** (CONT H1/M30, INV H1/M30; 158-173 tagli; INV solo 2 segnali: potenza bassa) e sui pattern piantati con coda. Reale: DOPO AUTORIZZAZIONE (su un estratto, CK-01) |
| V02 | Perturbazione del futuro (R003) | E | passato invariato in tutte le prove (40; 200 per pochi segnali) | B | **ESEGUITO su A4, sintetico: SUPERATO** (40 prove x 4 configurazioni). Reale: DOPO AUTORIZZAZIONE |
| V03 | Ispezione anti look-ahead di `signals.py`/`engine.py` (R003): `p` solo running extreme, nessun center=True, nessuna statistica globale, niente barra H1 in formazione | I | nessuna occorrenza non giustificata | B | **NON ESEGUITO** (ho letto solo interfaccia e docstring). ESEGUIBILE ORA |
| V04 | Simmetria rialzo/ribasso del SEGNALE (R003) | E | segnale' = -segnale; sma20' = K - sma20 (tol 1e-9); asimmetrie ammesse solo se dichiarate | B | **ESEGUITO su A4, sintetico: SUPERATO** (CONT 3/4 -> 4/3; INV 2/0 -> 0/2). Reale: non necessario (e una proprieta del codice) |
| V05 | Simmetria del MOTORE (R003) | E | uscite/pnl speculari per modello `executable` con specchio bid/ask | B | **NON ESEGUITO su A4** (eseguito sul mio ricalcolatore, 400 trade). ESEGUIBILE ORA |
| V06 | Contabilita dello spread long/short (R003) | E+R | pnl motore = pnl ricalcolo (tol 1e-6) con spread variabile e costante; costo presente su entrambi i lati | B | **ESEGUITO su A4, sintetico: SUPERATO** (1185 trade identici su 4 serie x TF; test "somma pnl = lordo - N x s" letterale NON fatto). Reale: DOPO RUN |
| V07 | Stop prima del target nella stessa M1 (R003) | E+R | tutti gli eventi `both_touched` escono a stop; conteggio nei dati reali | B | **ESEGUITO su A4, sintetico: SUPERATO** (60/60 M1 iniettate che toccano stop e target). Conteggio reale: DOPO RUN. Gap sullo stop non esercitato esplicitamente: ESEGUIBILE ORA |
| V08 | Ingresso alla barra successiva, prezzo da M1 (R003) | E+R | `entry_time` = apertura della barra tau+1; entry = open M1 (+spread long) | B | **ESEGUITO su A4, sintetico: SUPERATO** (stesso ingresso nel ricalcolo su 1185 trade). Reale: DOPO RUN (`check_entry_next_bar` sul log) |
| V09 | Nessun segnale accettato con trade aperto (R003, R007) | E | `check_no_overlap` con `signal_known_time` | B | DOPO RUN (sul log); ESEGUIBILE ORA su sintetico (non fatto) |
| V10 | Coerenza dei conteggi dell'imbuto (R006) | E+R | stadi non crescenti, uguali al ricalcolo dalle maschere, segnali = trade + scartati (incl. `TARGET_OLTRE_INGRESSO`, gap, posizione aperta), per ogni cella | B | DOPO RUN. Predisposto `funnel_recount`/`check_funnel`; l'imbuto per episodio di A4 e la mia reimplementazione hanno nomi di stadi diversi: la riconciliazione e fatta sui conteggi finali (segnali, armati) |
| V11 | Riproducibilita (R004) | E | stesso hash di output in 2 esecuzioni (PYTHONHASHSEED diversi per il run completo) | B | signal_fn **ESEGUITO sintetico: SUPERATO** (hash uguali). Run completo: DOPO RUN (`run_test.py` scrive gia `sha256_risultati`: due esecuzioni da confrontare) |
| V12 | 20 trade per cella ricalcolati a mano + codice, livelli da M1 (R004) | R | 20/20 coincidono; livelli stop/target coincidono col ricalcolo da M1 (ATR3, SMA20) | B | DOPO RUN (seme dal sha256 del LOG_TRADE). Ricalcolo con codice gia **SUPERATO su sintetico** (1185 trade); i livelli (ATR/SMA20) verificati solo indirettamente |
| V13 | n/vincite/PF sull'intera popolazione (R004, R006) | R | n e vincite identici, PF entro 1e-9, tutte le celle | B | DOPO RUN. Sintetico: n/win/PF identici per 4 serie x TF |
| V14 | Soglie/criteri non modificati (hash) (R005) | R | sha256 attuale = congelato = citato nel rapporto | B | Documenti: **SUPERATO oggi** (3 hash ricalcolati = HASH_DOCUMENTI). Codice (signals/engine/params/run_test): DOPO CODICE (C0 deve hashare prima del run). CSV: DOPO AUTORIZZAZIONE (solo sha256) |
| V15 | Ordine temporale criteri -> risultati (R005) | R | mtime criteri <= risultati (debole) + hash registrato in events.jsonl PRIMA del run (U-A7-5) | S | DOPO RUN |
| V16 | Completezza delle celle (R006) | I+R | presenti **16 celle = {CONT, INV} x {H1, M30} x {2013, 2018, 2020, 2025-26}** (M15 NON testato: se compare e un errore) + totali per variante + pooled H1 e pooled M30; T6 sensibilita Sa, Sb, Sc, Sd, Se20, Se50, Sf (+ Sg esplorativa di A4, D007) tutte riportate; B1, B0, B2; T1-T9; anche con n=0 o PF non definito; 15 numeri del rapporto riconciliati con le tabelle | B | DOPO RUN |
| V17 | Chiusure a fine dati / a mercato / target oltre ingresso / spread 0 dichiarati (R003) | I+R | conteggi per cella (`FINE_DATI`, `MKT`, `TARGET_OLTRE_INGRESSO`, spread 0 sostituito), inclusi nelle statistiche; nessuna uscita a tempo nella primaria (maxhold 1000) | S | DOPO RUN. Regola sintetica gia coerente (mkt, oltre ingresso) |
| V18 | Provenienza dati (R002) | R | sha256 dei 4 CSV = `HASH_DATI.txt`; righe = audit A3 (348.647 / 349.730 / 351.258 / 611.062) | S | DOPO AUTORIZZAZIONE (solo hashing; `confronto_con_A4.py --reale` lo fa prima di leggere) |
| V19 | Test di mutazione sulla COPIA del motore (R004) | E | ogni difetto iniettato (look-ahead, spread omesso, target prima dello stop, ingresso stessa barra, nessun controllo di posizione) e rilevato | S | **NON ESEGUITO** su A4. Fatto sulla MIA reimplementazione: 14/14 mutanti uccisi. ESEGUIBILE ORA |
| V20 | Test di A4 rieseguiti da A7 (R003) | E | tutti passano, non tautologici | B | **ESEGUITO**: test_engine 30 OK, test_signals 31 OK, test_run 11 OK (esecuzione del 01/11, `PYTHONDONTWRITEBYTECODE=1`). Qualita dei test (non tautologici): NON ispezionata |
| V21 | Reimplementazione indipendente del nucleo dei segnali (CK-16) | R | segnali (barra, lato, tipo) e episodi (d, s, p) identici ad A4 su sintetico; poi su reale | B | **ESEGUITO su sintetico**: segnali IDENTICI (pattern piantati: 0 divergenze; 6 serie a regimi: 26 = 26). **1 divergenza di episodi: Q1** (armamento prima della barra 200; A4 arma solo da t>=200; riconcilia `alt_arm_from_warmup`). Reale: DOPO AUTORIZZAZIONE (`confronto_con_A4.py --reale`) |
| V22 | Pattern piantati con gemello negativo per criterio (CK-14) | E | segnale alla barra attesa (positivi); nessun segnale e flag attribuito (negativi), long e specchio | B | **ESEGUITO**: reimplementazione 131/131 + 14/14 mutanti; **codice A4: 36/36** (solo segnali). Coperti: CONT (tocco, C1 nel ritracciamento e sul test, sd<S50, sd<=sd[-3], SEQ, band riding, warm-up), INV (I0, I1, retest, I2, I3, sd<S50, sd<=sd[-3]), armamento B1, B3, B4, B5. NON coperti: B2 e B6 isolati, tocco precoce naturale, MIN_RETR/T_MAX congelati (solo come meccanismo con parametro alterato), uguaglianze esatte sulle soglie |
| V23 | Placebo su passeggiata casuale (CK-13) | E | lordo medio per trade con |z|<=3 in ogni variante/TF; netto = -costo | B | DOPO RUN (T7 di `run_test.py`; eseguibile su sintetico ORA, non eseguito da A7) |

## 4. CK [B] di A6: stato
| CK | Stato |
|---|---|
| 01 troncamento | ESEGUITO sintetico SUPERATO (V01); estratto reale: DOPO AUTORIZZAZIONE |
| 02 aggregazione barre | PARZIALE: barre A4 = mio aggregatore (sintetico, con gap di fine settimana, 4 serie x TF) SUPERATO; barra segnale/ingresso coperto da V08; reale DOPO AUTORIZZAZIONE |
| 03 perturbazione | ESEGUITO sintetico SUPERATO (V02) |
| 04 niente normalizzazione globale | PARZIALE: troncamento+perturbazione SUPERATI; ispezione V03 NON ESEGUITA (ESEGUIBILE ORA) |
| 05 target ricalcolato | PARZIALE: ricalcolo con schedule su 1185 trade identico (ricalcoli, fase, mkt, livello); scenario con mediana nota a mano su motore A4 NON scritto (ESEGUIBILE ORA) |
| 06 stop-first | ESEGUITO sintetico SUPERATO (60/60); conteggio reale DOPO RUN; gap stop esplicito ESEGUIBILE ORA |
| 07 spread | PARZIALE (V06) |
| 08 simmetria | segnale SUPERATO; motore NON ESEGUITO su A4 (V05) |
| 09 un segnale per episodio / una posizione / esclusivita | NON ESEGUITO (ESEGUIBILE ORA con scenari a tocchi multipli e nuova bulge a trade aperto) |
| 13 placebo | DOPO RUN (V23) |
| 14 pattern piantati | ESEGUITO (V22) con i limiti elencati |
| 20 hash CSV | DOPO AUTORIZZAZIONE |
| 21 spread (unita, zeri, mediane) | sostituzione zeri: SUPERATO su sintetico; dati reali: audit A3, riverifica DOPO AUTORIZZAZIONE |
| 22 copertura / buchi | regola gap ingresso 180 min coerente su sintetico (GAP_INGRESSO 2-5 per serie); reale DOPO AUTORIZZAZIONE |
| 30 ipotesi primaria unica | PRESENTE in disegno_test_v1 sez. 1 e criteri Parte B (presenza documentale verificata; qualita non giudicata) |
| 31 N minimo | PRESENTE (N<30 INCONCLUSIVO, 30-99 PRELIMINARE, >=100 PIENO) |
| 32 hash che copra tutto | PARZIALE: documenti e CSV si; CODICE DOPO CODICE |
| 33 tabella interpretazioni | PRESENTE (specifica sez. 8) |
| 34 previsioni falsificabili | PRESENTE (Q1-Q26 con probabilita; incl. INCONCLUSIVO) |
| 35 linea di base abbinata | PRESENTE nel disegno (B1/B0/B2); risultati e correttezza dell'implementazione: DOPO RUN (+ ispezione di `run_test.py`: ESEGUIBILE ORA) |

## 5. Limiti dichiarati
- Un look-ahead di 1 barra emerge solo se un taglio cade dove il dato futuro cambia l'esito: tagli esaustivi dove possibile + ispezione V03 obbligatoria. Con INV nei sintetici i segnali sono 2: potenza bassa.
- I gemelli negativi sono stati cercati numericamente (rilevatore usato per l'attribuzione) e poi riconfermati con un calcolo naive indipendente e con attese scritte a mano; non dimostrano la fedelta della specifica alla Guida.
- La SEQ e verificata via imbuto (C0 vero, C3 falso) non via segnale: nei miei scenari il contrafattuale "senza SEQ" non da segnale (falliscono anche i cancelli sd).
- Il mtime (V15) e modificabile; la prova forte e l'hash registrato prima del run.
- "Verificato localmente" non dimostra un vantaggio statistico, ne validita fuori campione, ne conto demo/reale.

## 6. Ordine di esecuzione e regole
1. ORA (ESEGUIBILE ORA, sintetico): V03, V05, V19, CK-05/06/09, ispezione di `run_test.py` (B1), scenari motore a mano. Nessun CSV.
2. Dopo congelamento del codice: hash del codice (V14), rilancio di V01-V08, V20-V22 sul codice congelato.
3. Con AUTORIZZAZIONE di C0: V18 (sha256 CSV), `confronto_con_A4.py --reale ... --autorizzazione-C0 "<riferimento>"` (hash prima, registro `registro_esecuzioni_A7.txt`), estratto reale per CK-01.
4. Dopo il run: V06-V17 sul log reale, V23.
5. A7 non corregge il codice di A4: riporta difetto/file/evidenza a C0. Dopo ogni correzione si rilanciano TUTTI i controlli e si rigenerano i risultati.
