# GEMINI E' AL LIVELLO DI CLAUDE? -- valutazione misurata (04/10/2026)

Richiesta di Claudio: *"dimmi se allo stato attuale Gemini e' al tuo livello o se necessita di conoscenze piu' approfondite sui nostri
argomenti... se dobbiamo dargli delle info in piu' per aggiornarlo al tuo pari livello."* Documento per Claudio. Non si manda a Gemini.

---

## 0. LA RISPOSTA, IN TRE RIGHE

1. 🔴 **No: oggi, cosi' come lo usiamo, Gemini NON e' al livello di Claude sui nostri argomenti.** Esame di allineamento di oggi
   (15 domande con risposta nota nel repo): **17 punti su 30 (57%)** (prima stesura 18; il cancello indipendente ha abbassato A4, sez. 1), e **zero** volte ha scritto "NON LO SO" anche dove non sapeva.
2. 🟡 **Il divario ha DUE cause, e vanno separate**: (a) **contesto che non ha** (non vede il repo, vede solo i 2-3 file di ogni pacchetto);
   (b) **errori di ragionamento suoi** (un calcolo di break-even sbagliato in modo grave). La (a) si colma con informazioni; la (b) no.
3. 🟢 **Ma ha un ruolo vero**: genera idee che da soli non avremmo avuto (rischio per fattore comune, tocco di corpo, MFE/MAE...), e il
   nostro cancello le verifica. Va tenuto: come **generatore di ipotesi**, non come giudice.

---

## 1. L'ESAME (misura, non opinione)

File: `docs/gemini/ESAME_ALLINEAMENTO_2026-10-04.md` (domande, mandate) · `ESAME_ALLINEAMENTO_CHIAVE_2026-10-04.md` (risposte attese, NON mandate)
· risposta: `docs/gemini/RISPOSTA_GEMINI_2026-10-04_1938.md`. Modello usato: `gemini-3.1-flash-lite`, con la nostra memoria condivisa e **nient'altro**.
Punteggio: 2 = giusta e completa · 1 = giusta ma incompleta o con errore minore · 0 = sbagliata/inventata.

| # | Argomento | Cosa ha risposto | Punti |
|---|---|---|---:|
| A1 | orologio BCM | UTC+1 fisso (giusto) ma non dice la relazione con l'ora italiana d'estate/inverno ne' che l'EA arma un'ora PRIMA d'inverno; e aggiunge un fatto **sbagliato**: "FTMO segue l'ora italiana" (e' ora italiana **+ 1**, `OROLOGIO_BCM_2026-09-24.md` 5.3) | 1 |
| A2 | frontiera del costo | stop >= 40 x costo: giusto | 2 |
| A3 | certificato di morte | PF, n, DD, uscita ad asse, gemelli, TF: giusto | 2 |
| A4 | regola del 19/08 | ✏️ *(cancello)* **meta' giusta**: "su un motore morto una griglia trova solo rumore" si'; ma "vietato su motori che non hanno **gia' dimostrato** un edge" rovescia l'onere: vieterebbe le griglie anche sui NON ANCORA MISURATI (es. asse `InpSLatr` su EMA200 EURUSD H4, candidato accolto). Manca su cosa si allarga | 1 |
| A5 | chi firma / valore di criterio | giusto | 2 |
| A6 | parole di verdetto | 🔴 **inventa** "Promosso / Da monitorare / Bocciato"; solo "Non ancora misurato" coincide; sbaglia anche quale e' la piu' prudente | 0 |
| A7 | dove girano i round | giusto | 2 |
| A8 | tetto di rischio per cluster | 🟡 nome sbagliato (`InpClusterMappa` invece di `InpMaxClusterRiskPct`), conclusione giusta (non in uso), manca il default 0 | 1 |
| A9 | la pausa chiude le posizioni? | giusto (no) | 2 |
| A10 | l'unica sedia che passa i cancelli | 🔴 dice "nessuna" e indica `770101`: **sbagliato** (e' la EMA200 Dow H1 771531, PF 1,52 su 257 posizioni) | 0 |
| B1 | break-even TP 10 / SL 30, costo 1 pip | 🔴 **23,68%** invece di **77,5%**: ha invertito il rapporto. Errore di ragionamento, non di contesto | 0 |
| B2 | cella con n < 150, un solo regime | non promuove (giusto) ma cita solo il regime, non n < 150 | 1 |
| B3 | trial: sfortuna o EA (5,8%)? | 🔴 dice **"Sfortuna"**: la parola giusta e' ZONA GRIGIA (la sfortuna non si esclude, ma non e' dimostrata) | 0 |
| B4 | cosa fornire per un filtro nuovo | disegno, contro-esempio: buono ma manca il nome reale, il costo, la firma | 1 |
| B5 | errore piu' pericoloso | giusto (abbassare una soglia dopo il numero) | 2 |
| | **TOTALE** | | **17 / 30** |

**Cosa dice l'esame:**
- 🟢 Sulle **regole di fondo** e' bravo: 6 risposte piene (A2, A3, A5, A7, A9, B5). La memoria condivisa fa il suo lavoro. Ma anche dove la regola la conosce, la **parafrasa spostandone il senso** (A4): la regola va citata, non riassunta.
- 🔴 Sui **fatti specifici e recenti** (A6, A10) **inventa con sicurezza** invece di dire "non lo so". Questo e' il difetto piu' pericoloso.
- 🔴 Sul **ragionamento numerico** (B1) sbaglia in modo grave. Con quel 23,68%, una sedia a payoff 1:3 sembrerebbe promuovibile. **Nessuna informazione in piu' risolve questo**: serve un modello piu' capace, oppure controllarlo sempre (come fa il cancello).

---

## 2. LO STORICO CONFERMA IL QUADRO (gli scambi dal 28/09 al 04/10)

Dalle verifiche in `docs/RISPOSTA_A_GEMINI_*.md`:
- **Numeri di riga sbagliati 3 volte su 3** (29/09): per questo abbiamo la regola "cita il NOME dell'input, non la riga".
- **01/10:** formula del break-even sbagliata (100,1% invece di 87,9% sul nostro NZDCHF); libro attribuito all'autore sbagliato; "Firma Claudio? No" su
  due modifiche di rischio (che sono tue); un controesempio sbagliato nella sostanza sull'hedging; ha riproposto come nuovo un blocco che avevamo gia' misurato.
- **03/10:** payoff atteso del trial intero attribuito al Bulge; un **input inventato** (`InpMaxClusterRisk`, quello vero e' `InpMaxClusterRiskPct`); soglie
  inventate (PF 1,2; p-value 0,05; 60% di uscite in pari); non ha risposto a meta' della parte (b) (quattro delle cinque cose chieste in (b)3); la tabella del primo controllo, poi, ha dato torto a
  Gemini in alcuni punti dove aveva ragione (il fattore NZD, il filtro da 300 secondi: poi corretto dal secondo sguardo): **non e' solo Gemini che sbaglia**, e' il motivo per cui ogni verifica passa da un secondo sguardo.
- **Cio' che ha portato di utile:** tocco di CORPO come asse separato per H4/D1; rischio per FATTORE comune (verificato vero: due coppie NZD nello stesso secondo, 01 e 02/10);
  MFE/MAE nell'export per-trade; il tokenizer PowerShell nel cancello; uscita a tempo.

---

## 3. PERCHE' C'E' IL DIVARIO (cause misurabili)

| Causa | Fatto | Colmabile con informazioni? |
|---|---|---|
| **Modello piccolo** | via API usiamo `gemini-3.1-flash-lite`; i modelli "pro" rispondono 429 sul piano gratuito (verbale 28/09). Il tuo account Pro e' nell'APP, non raggiungibile dall'API (`MEMORIA_CONDIVISA.md` §intro) | ❌ no: e' una **spesa** = tua firma |
| **Contesto minimo** | l'app Gemini riceveva il briefing PDF, CLAUDE.md e i sorgenti EA (`COMANDO_GEMINI` §0); **l'API automatica no**: l'istruzione di sistema (~8,6 KB), la memoria (9 KB) e il pacchetto del giorno (~13 KB) | ✅ **si'**: una base di conoscenza fissa |
| **Istruzione di sistema vecchia** | ✏️ *(cancello)* il COMANDO mandato a OGNI chiamata dice ancora *"oggi FTMO 2-Step da 80.000 EUR, conto ..., viva dal 22/09"* (col **numero di conto**, che la memoria dichiara omesso di proposito) e gli dice che criteri e numeri *"sono nel briefing allegato e in CLAUDE.md"*, **che via API non gli arrivano**: lo invita a credere di avere regole che non vede | ✅ si': va riscritto (costo zero, passa dal cancello) |
| **Memoria in ritardo** | `MEMORIA_CONDIVISA.md` §1 dice ancora *"Challenge FTMO 2-Step da 80k viva dal 22/09... sette sedie in campo"*: **e' superato** (oggi il banco di prova e' la Free Trial da 160k, dal 30/09-01/10) | ✅ si': va aggiornata |
| **Non dichiara l'ignoranza** | in 15 domande mai un "NON LO SO", **benche' fosse gia' chiesto due volte**: nel COMANDO (*"«Non lo so» e' una risposta valida"*) e in testa all'esame (*"scrivi esattamente NON LO SO"*) | ⚠️ **misurato che chiederlo non basta**: la regola 1 della base da sola non lo risolvera'; si vedra' all'esame ripetuto |
| **Come glielo chiediamo** | domande aperte invitano a riempire; quelle falsificabili con nomi e numeri vanno meglio | ✅ si' |

---

## 4. COSA FARE (in ordine di costo)

1. 🟢 **Subito, costo zero: la BASE DI CONOSCENZA** (`docs/gemini/BASE_CONOSCENZA_PER_GEMINI_2026-10-04.md`, bozza pronta): le regole di casa in
   forma compatta, il vocabolario dei verdetti, la tabella dei fatti misurati con la fonte, i nomi veri degli input, le formule (break-even con un
   esempio svolto), e le **regole di risposta** ("NON LO SO" e' una risposta valida; mai soglie inventate; cita nomi, non righe; separa fatto e ipotesi;
   il rischio e' sempre una firma di Claudio). Va in testa a ogni pacchetto, accanto alla memoria. **Passa dal cancello prima di partire.**
2. 🟢 **Ripetere l'esame DOPO la base** (stesse 15 domande, stessa chiave) e confrontare i punteggi: se A6, A8, A10 migliorano e B1 no, abbiamo
   **misurato** cosa e' contesto e cosa e' capacita'. Costa una chiamata.
3. 🟢 **Aggiornare `MEMORIA_CONDIVISA.md` §1 e il COMANDO** (stato del banco di prova). ✏️ *(cancello)* **Non serve una tua conferma**: il repo lo dice gia' (`report/FTMO_CHALLENGE_CHIUSURA_2026-09-30.md`: Max Loss violato il 30/09, equity 71.968,19 contro 72.000; e la stessa memoria al §6 "Aggiornamento 01/10"). Il §1 contraddice il §6 dello stesso file. Costo zero, passa dal cancello.
4. 🟠 **Decisione tua (spesa): un modello piu' capace via API.** Non conosco il costo reale: **[NON MISURATO]**; va chiesto al piano. Si decide **solo se** l'esame dopo la base mostra che B1-tipo (ragionamento) resta il problema.
5. 🟠 **Alternativa gratuita: sessioni "profonde" a mano nell'APP Gemini Pro** (tu incolli la base + il briefing + i file indicati in `COMANDO_GEMINI` §0 e riporti la risposta). Piu' lento, ma usa il modello migliore che gia' paghi.

---

## 5. COME LEGGERE I NUMERI (onesta')

- 15 domande sono **poche**: il 57% e' un ordine di grandezza, non un punteggio fine. Il valore e' nel **tipo** di errori (invenzione sicura, calcolo invertito), non nel numero.
- La chiave l'ho scritta io, dal repo: puo' contenere un mio errore. Un secondo valutatore (il cancello, 04/10) ha ricorretto le 15 risposte: 17 contro 18, unica differenza A4; i conti piu' netti (A6, A10, B1) sono pero' verificabili da chiunque in 30 secondi.
- ✏️ *(cancello)* **B3 ha una domanda imprecisa**: il 5,8% del repo e' la probabilita' di -4,34% in 2 giorni sulle sedie **con contratto** (senza Bulge), non del -5,5% del conto intero (`TRIAL_SFORTUNA_O_EA_2026-10-03.md` sez. D). Il verdetto atteso (ZONA GRIGIA) regge sulla misura congelata, e lo 0 resta: Gemini ha letto l'IC 3,3-9,4% come un "intervallo atteso" degli esiti. La domanda si lascia uguale all'esame ripetuto, per confrontare i punteggi.
- 🔴 **Un confronto "a pari condizioni" con me non e' possibile**: io leggo il repo, lui no. Il confronto giusto e' **dopo** la base, a parita' di informazioni.
- La domanda di Claudio ("serve dargli piu' info?") ha una risposta onesta: **si' per i fatti (A6/A8/A10), non basta per il ragionamento (B1)**. L'esame ripetuto dira' quanto.
