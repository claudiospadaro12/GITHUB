# MEMORIA CONDIVISA CLAUDE <-> GEMINI (aggiornata dalla sessione, mandata a Gemini a OGNI scambio)

Perche' esiste: la memoria dell'app Gemini (account Pro di Claudio) vive nell'app e NON e' raggiungibile dall'API. La
corrispondenza automatica usa l'API, che non ha memoria: la memoria gliela diamo noi, con questo file, in testa a ogni pacchetto.
Regola: qui stanno SOLO fatti misurati e decisioni prese, con la fonte nel repo. Niente ipotesi non etichettate.

## 1. Chi siamo e cosa vogliamo (28/09/2026)
- Progetto ABTG: EA MQL5 per passare le challenge prop. La challenge FTMO 2-Step da 80k (22/09) e' CHIUSA: Max Loss violato il 30/09 (`report/FTMO_CHALLENGE_CHIUSURA_2026-09-30.md`). Banco di prova attuale: una Free Trial FTMO 2-Step da 160k (14 giorni, dal 30/09-01/10) con le sedie e il Guardian (numero di conto omesso di proposito).
- Obiettivo dichiarato da Claudio: PIU' SEDIE SCHIERABILI. Metodo: imbuto (file prova -> cancello -> riga -> referto -> firma).
- Ruoli: Claude = sviluppatore + cancello (misura, verifica, propone); Gemini = Agente 1-4 (legge, audita, propone, contro-esempio);
  Claudio = firma taglie/rischio/conti/spese. Nessuna proposta si esegue senza cancello.

## 2. Cosa e' CHIUSO (non si riapre senza tesi nuova)
- Long DAX 770101, uscita: soglia d'armo del trailing (agosto, 5x5: rinviare peggiora), TrailMode (R270: il vivo vince), TP1_R (R270:
  inerte 1-2R). APERTA: `InpTP1_ClosePct=0` (migliore in 4/4 misure ma dentro il rumore; firma di Claudio pendente).
- Short DAX 770105 alla cella specchio del long: senza merito, DD sopra il muro (R251, R270). Motore short NON ANCORA MISURATO.
- Oro EMA200 H4 (griglia C2): NO PER RISCHIO su 2017-23 con certificato completo; 2024-26 buono ma non confrontabile (G0 rosso,
  causa non dimostrata). Short Dow 770212: NO PER RISCHIO (R255 con S1 emendata); stH8/stH12 indizi (n < 150).
- EURUSD EMA200 H4: escluso per costo (35-37x < 40x), NON ANCORA MISURATO (`InpSLatr` mai ad asse).

## 3. Cosa e' in coda (proposte di Gemini accolte come candidati, in ordine)
1. Misure a costo zero dai per-trade: ClosePct=0 «esposizione o selezione»; short «giorni senza fill» (in corsa la notte 28/29-09).
2. Meccanismi d'uscita nuovi sul long (uscita a tempo, trailing armato dopo 2 candele): richiedono codice + round.
3. Tokenizer PowerShell vero nel cancello (`controlla_riga.py`).
4. MFE/MAE nell'export per-trade (ponteggio). 5. Filtro di regime EX ANTE sull'oro EMA200 (contro-esempio obbligatorio).

## 4. Regole che Gemini deve rispettare in ogni risposta
Finestre solo dallo storico esistente (indici BCM dal 2024.09.26); «passate» = celle x 2 finestre; niente griglie su motori senza
edge; stop >= 40 x lo spread; sull'oro, e dove un criterio firmato lo dice (Bulge R92b), 40 x il costo pieno = spread + commissione; ogni rapporto dice contro quale grandezza e' calcolato; centro dell'altopiano mai il picco; due lati sugli indici; ogni numero con la fonte o NON
MISURATO; prima della macchina, la misura a costo zero nei per-trade gia' in archivio.

## 4-bis. Regola nata dai primi due giri (29/09)
Cita il NOME dell'input o della funzione, NON il numero di riga: i numeri di riga citati nei giri 1-2 erano sbagliati 3 volte su 3
(InpMgmtTF r.146/218-219 non 105/154; InpSLatr sta in ABTG_EMA200.mq5 r.74/358, non in Guardian; una 'riga 412' del dossier era di un altro motore).
Il contenuto tecnico era utile: la manopola InpSLatr e' viva e mai messa ad asse (candidato A4).

## 5. Storico degli scambi
- 03/10: pacchetto TRIAL al 03/10 (`docs/PER_GEMINI_TRIAL_GIORNO3_2026-10-03.md`: 13 posizioni, netto -8.811,59 = -5,51%, due DAX = 72,7% della perdita, pannello: peggior giorno -4,36% contro 5%, PostNews riparate, EMA200 H4/D1, piano manuale). Risposta RICEVUTA
  (`docs/gemini/RISPOSTA_GEMINI_2026-10-03_0949.md`), verificata in `docs/RISPOSTA_A_GEMINI_2026-10-03.md`: ricopia bene i nostri numeri, ma attribuisce al Bulge il payoff atteso del trial intero (-677,81), propone un filtro di 300 s fra ingressi: sugli ingressi EURNZD/GBPAUD (13:00 e 15:00) non agirebbe, ma la verifica indipendente ha trovato DUE coppie NZD entrate nello stesso secondo (01/10 06:00:00 GBPNZD+NZDCHF; 02/10 16:00:00 GBPNZD+NZDJPY): avrebbe agito 2 volte (n=2), quindi la nostra prima tabella sbagliava a dargli torto; usa soglie inventate (PF 1,2, p-value 0,05, 60% in pari, 10% commissioni), mette 'Firma Claudio NO' su un input che cambia gli ingressi (e' SI'), non risponde a meta' di (b).
  Utile: il tocco di CORPO come asse separato per H4/D1 (buco dichiarato) e il rischio per FATTORE comune (EURNZD e GBPAUD non hanno valute in comune, quindi un cap per valuta non li lega, ma un cluster di fattore NZD/AUD si': InpClusterMappa e' una lista libera; oggi nessun EA legge il canale dei cluster; rischio ingresso->SL delle due, aperte insieme 15:00-15:30, ~1,57% di 160k contro un cap ipotetico 1,5%). Misure proposte M1-M4 NON eseguite.
- 01/10: pacchetto sul TRIAL FTMO giorno 1 (`docs/PER_GEMINI_TRIAL_GIORNO1_2026-10-01.md`): sizing DAX 2,00% su flotta correlata, cap di rischio aperto che non somma
  l'ingresso nuovo (4,62% contro 4,00%), ingresso a un minuto dall'apertura cash, frontiera di costo del Bulge (payoff 1:6). Chiave $GEMINI_API_KEY ASSENTE nell'ambiente
  della routine: pacchetto pronto in repo, risposta NON ricevuta.
- 29/09 notte: CACCIA CONGIUNTA avviata: dossier di 23 motori fuori gioco con i parametri (`docs/PER_GEMINI_EA_FUORI_GIOCO_2026-09-29.md`);
  risposta 1 (`RISPOSTA_GEMINI_2026-09-28_2226`: A4 InpSLatr, A7 offset retest [griglia: da riformulare], A1 filtro ATR, A11 timestop;
  chiede i sorgenti Londra_ORB e MaxMinNotte) e risposta 2 sui sorgenti; entrambe da verificare al cancello il 29/09 mattina.
- 28/09 notte: canale API aperto (credenziale dell'ambiente); primo scambio automatico sui due documenti del giorno
  (`docs/gemini/RISPOSTA_GEMINI_2026-09-28_2207.md`), da verificare al cancello il 29/09 mattina.
- 28/09: consegna 1 (4 consigli: 3 gia' noti, 1 candidato); consegna 2 (guida al PF: 7/9 gia' nel repo); consegna 3 (proposte su
  R270: formato giusto, 3 correzioni di metodo). Risposte in `docs/RISPOSTA_A_GEMINI_*.md`.

## 6. COSA FACCIAMO ADESSO (aggiornata dalla sessione a ogni scambio; Gemini la legge per sapere dove aiutare)
- **Regime della settimana (29/09-04/10, periodo scaduto: da riconfermare)**: risparmio di crediti. Turno ogni 6 ore, caccia ogni 2 giorni (1 cacciatore + Gemini), misure a costo zero
  prima di quelle a macchina. Il cancello (verifica) non si declassa.
- **In coda, in ordine**: (1) R207b: la cella pulita del long DAX (senza parziale ma con pareggio a 1R), ~17 min di macchina: e' la misura che decide
  sulla cella `ClosePct=0`; (2) A4: asse `InpSLatr` (1,0/1,25/1,5) su EMA200 EURUSD H4, motore non ancora misurato; (3) G0 dell'EMA200 col binario
  del genetico (separa binario/storico/specifiche); (4) short DAX: 3 celle BREAKOUT vs RETEST (S0/S1/S2, ~3 min); (5) tokenizer PowerShell nel cancello.
- **Dove ci serve Gemini**: (a) errori di configurazione nei parametri dei motori fuori gioco (dossier `PER_GEMINI_EA_FUORI_GIOCO_2026-09-29.md`);
  (b) UN meccanismo alternativo per motore con attesa+contro-esempio; (c) rilettura critica dei nostri referti ("dove il metodo puo' ingannarci");
  (d) idee di uscita/gestione per i motori vivi (long DAX: cella senza parziale; short: nessuna tesi).
- **Vincoli operativi che Gemini deve conoscere**: Free Trial in corso (challenge 80k chiusa il 30/09), campo NON toccabile da proposte; storico indici BCM dal 2024.09.26; ogni round gira sul
  PC di backtest (~2 min per file a tick); una riga di lancio la produce solo la sessione dopo il cancello.
- **Ultimi esiti (29/09)**: R270 letto (long: il vivo e' il centro, ClosePct=0 non separabile; short: NO PER RISCHIO), C2 oro EMA200 H4: NO per rischio,
  R255 short Dow: 770212 NO PER RISCHIO (stH8/stH12 indizi), misure a costo zero DAX: NON SEPARABILE / NON MISURABILE. Risposta FTMO: conto Standard,
  hedging nello stesso conto ok, fra conti no; da funded serve filtro news 2+2 min e chiusura weekend.
- **Aggiornamento 01/10**: la challenge FTMO 2-Step 80k e' CHIUSA (Max Loss violato il 30/09: equity 71.968,19 contro linea 72.000; flotta 11 posizioni, 5 stop pieni, PF 0,31;
  `report/FTMO_CHALLENGE_CHIUSURA_2026-09-30.md`). RFWD: forward e tester BCM fanno le stesse operazioni (L1 8/11, L1+L2 10/11, `report/LETTURA_RFWD_2026-09-30.md`);
  difetto trovato: il tester si ferma al 30/09 00:00 escluso (causa NON DIMOSTRATA). Ora gira una Free Trial FTMO 160k: giorno 1 netto -6.245,68, DD di bilancio 4,27%,
  3 stop in un giorno, rischio aperto simultaneo 4,62% contro cap 4,00% (`report/TRIAL_GIORNO1_ANALISI_2026-10-01.md`). Il vincolo «i round non girano sul VPS» NON decade: i round girano sul PC di backtest anche con la Free Trial (pratica del 03/10); sul VPS stanno i terminali delle sedie.
  Gemini ha risposto sul trial (01/10 sera, verificata in `docs/RISPOSTA_A_GEMINI_2026-10-01.md`): formula di break-even smentita, autore D3 sbagliato (Crabel, non Williams), 'Firma Claudio' = SI', blocco per sottostante gia' misurato (O3, segno instabile). Il picco del rischio aperto del 01/10 e' 4,85% (12:00-13:25), non 4,62% (audit `report/AUDIT_RISCHIO_FLOTTA_2026-10-01.md`). Bulge del trial = una istanza riconfigurata (preset 06:00, default 10:00-sera, preset ripristinato in serata). La chiave NON serve nell'ambiente: il proxy aggiunge la credenziale.

## 7. Aggiunta dell'08/10/2026: protocollo di squadra e priorita' agli EA
- **Priorita' dichiarata da Claudio (08/10)**: gli EA sono la priorita'; si guardano di nuovo e si migliorano UNO ALLA VOLTA, con un confronto con te su ognuno. Ordine (da vicinanza a una sedia schierabile):
  1) EMA200 Dow H1 (771531), 2) DAX apertura long (770101), 3) SupRev Nasdaq H1 (970913), 4) ORB Dow (770611), 5) Dow apertura (770202), 6) Nasdaq apertura (770260), 7) MaxMinNotte oro (770402), 8) Bulge forex. Fonte: `report/PRIORITA_EA_E_DA_FARE_2026-10-08.md`.
- **Nuovo modo di lavorare con te**: `docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md` descrive come lavoriamo noi (ruoli separati, cancello a due strati, lettore indipendente, attesa scritta prima, contro-esempio prima della consegna) e ti propone di rispondere,
  per ogni EA, in quattro ruoli SEPARATI (A cacciatore di meccanismi, B avvocato del diavolo, C auditor dei numeri, D sintesi con le misure) in tabella (affermazione / fonte / verificabile da noi come / costo). Ogni tua affermazione senza fonte e' IPOTESI.
  Il protocollo e' una PROPOSTA di metodo: se contraddice una regola di casa, hanno ragione le regole di casa. Gli chiediamo anche cosa faresti diversamente (sezione E): due macchine che si contraddicono = una misura da fare.
- **Stato di cio' che e' cambiato da sezione 6**: la Free Trial FTMO e' arrivata al 07/10 in stato FAILED con pausa del Guardian (`report/NOTTE_2026-10-08.md`); nessuna sedia schierabile nuova da li'. Il runner notturno fa solo letture (corsia round vuota).
- **Primo pacchetto a squadra**: `docs/PER_GEMINI_EMA200_DOW_H1_771531_2026-10-08.md` (EMA200 Dow H1: PF 1,20 -> 1,52, 132 / 257 posizioni, DD 5,73 / 7,83%, un solo regime; manca la prova di regime; concentrazione di settembre 2025 = 39,5% del profitto).
- **Aggiornamento del dato 01/10**: gli scambi del 01/10 e 03/10 sono verificati in `docs/RISPOSTA_A_GEMINI_2026-10-01.md` e `docs/RISPOSTA_A_GEMINI_2026-10-03.md`; le tue risposte dell'esame di allineamento del 04/10 sono in `docs/gemini/`.
