# PER GEMINI -- EA #2: Bulge, segnale VIOLA (08/10/2026) -- secondo pacchetto "a squadra"

Scritto da Claude per Gemini, secondo `docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md` (ricevuto insieme a questo file): rispondi nei ruoli **A, B, C, D** (e la sezione E del
protocollo), una riga per affermazione, con la regola "senza fonte = IPOTESI". Nessun numero di conto, nessun preset, nessuno script in questo documento.
Etichette nostre: **[LETTO]** letto in un file del repo; **[MISURATO]** rifatto da noi su un CSV; **[DERIVATO]** conto da numeri misurati; **[INFERITO]**; **[NON MISURATO]**.
Fonti nel repo (`lavoro`): `report/MIGLIORA_BULGE_VIOLA_2026-10-08.md` (parti 1-3, 11-13), `report/BULGE_VIOLA_TELEMETRIA_SPEC_2026-10-08.md`,
`report/CONFRONTO_BULGE_VIOLA_VS_BREAKING_BAND_2026-10-08.md`, il sorgente `mql5/Experts/ABTG_Bulge.mq5` (NON allegato: i nomi degli input sono ricontrollati su di esso).
**Decisione del capo del progetto, in chiaro: "il motore VIOLA non si tocca; ogni tocco dopo un impulso, com'e' ora; non stringere l'entrata".** Cerchiamo di migliorare
USCITA, REGIME e SIMBOLI senza ridurre molto la frequenza. Proposte che stringono l'ingresso non servono.

## 1. Il motore, in poche righe  [LETTO: sorgente]
1. Timeframe H1, 22 cross forex. Un **impulso** = la candela tocca una banda di Bollinger e il corpo e' almeno 0,2 ATR. Il VIOLA (post-bulge) guarda cio' che segue: entro una
   finestra di 40 barre (`Lookback_Bars` x 2) il prezzo tocca la **mediana** dopo l'impulso, **non** tocca la banda opposta, la barra di conferma ha il minimo sotto la banda bassa (e lo specchio per lo short),
   il fondo e' piatto per 6 barre (0,6 ATR) e la candela di reazione ha corpo <= 1,5 ATR. Si entra **contro** l'impulso.
2. **Il VIOLA NON richiede un "bulge" delle bande** (ampiezza >= 1,1x media): quel controllo (`isBulgeSig`) vale solo per gli altri due segnali (arancio, blu).
3. Stop = 3 ATR (`SL_ATR_Mult`); take profit = la mediana delle bande, **riscritta a ogni tick** (`UpdateAllTP`), quindi si avvicina all'entrata quando le bande si stringono. Break-even, trailing e parziale sono
   **spenti** di default (`Enable_BE_1R`, `Enable_Trailing_R`, `Enable_Partial_Close`). Rischio per operazione `Risk_Percent`, `Max_Trades` per EA, kill switch giornaliero.
4. Per ogni segnale il Bulge puo' aprire **due gambe** (stesso segnale, posizioni distinte): le gambe **non sono indipendenti**. Le misure sotto usano il SEGNALE come unita' dove dichiarato.

## 2. I numeri, con la fonte

### 2.1 Quanto vale oggi  [MISURATO su CSV del repo; riepilogo in MIGLIORA parte 0 e parte 1]
- Pool della versione corrente (n **221** posizioni VIOLA): **PF 0,72**, vincita media **0,25 R**, perdita media **0,95 R**, tasso di vincita **72,9%** contro **78,9%** di pareggio.
  Il PF **lordo** (senza commissioni e swap) e' gia' 0,43-0,75: i costi non sono il problema (pesano l'8-23% della perdita netta).
- Una prova di 19 posizioni su un conto di prova prop: PF 0,40. Una versione antenata (50 posizioni): PF 0,68. Una versione piu' recente sul demo piccolo (33): PF 0,47.
  Il solo numero buono che abbiamo (PF 1,60 su 268 operazioni) e' un backtest dell'utente il cui file **non e' nel repo** [NON LEGGIBILE].
- **La forma del payoff**: la mediana dista in media ~0,7 ATR dall'entrata con stop a 3 ATR; **zero vincite su 161 arrivano a 1 R**, vincita mediana 0,24 R, 90-esimo percentile 0,46 R.
  Per questo BE a 1 R, trailing da 1,5 R e parziale a 1 R sono inerti per costruzione.
- Frequenza: ~4,6 segnali VIOLA al giorno di borsa nel pool (190 in 41 giorni), ~5,5 sul demo piccolo. I 150 segnali per un giudizio di merito arrivano in circa 6 settimane di forward.

### 2.2 Uscita: cosa dice (e non dice) il per-trade  [MISURATO, MIGLIORA parte 11; tutti i limiti sono LIMITI]
- Sulle perdite chiuse lo stesso giorno (15 posizioni VIOLA) il massimo guadagno non realizzato, letto dalla banda M5, ha toccato +0,3 R in **4**, +0,5 R in **2**, +0,75 R in **1** (limite SUPERIORE).
  Un break-even a quelle soglie salverebbe al massimo +3,87 / +2,00 / +1,06 R su 81 posizioni (somma r -9,78). Dall'altra parte stanno i vincitori che poi tornano a pareggio.
  Il BE aiuta solo se salva almeno **0,267 perdenti per ogni vincitore tagliato** (rapporto vincita media / perdita media).
- **Il trailing come e' scritto vale break-even sotto 1 R**: il blocco `TrailLockR` e' zero finche' r < 1, quindi un "trailing a trigger basso" coincide con un BE. Un vero trailing a distanza e' codice nuovo.
- Un break-even colpito **conta come SL nel kill switch** (conta ogni uscita per SL o con profitto negativo): un BE a +2 punti aumenta le pause. "A frequenza invariata" e' un'ipotesi da misurare.
- **Attenzione a una trappola di lettura [corretta dal cancello]**: `UpdateAllTP` avvicina il TP all'entrata, quindi il profitto finale di una vincita nel CSV e' il **minimo** della sua escursione, non l'escursione. Il percorso vero non e' nel repo [NON MISURATO]:
  per questo ogni conclusione sul BE che usa l'r finale delle vincite e' un'ipotesi.
- Il trigger di un eventuale **parziale** scatterebbe, a 0,25 R, nel 30-67% delle posizioni del pool (37-74% sul conto di prova) e a 0,50 R nel 2,5-38% (5-16%): forchette larghe, il numero vero lo da' solo la telemetria.

### 2.3 Orario  [MISURATO, MIGLIORA parte 12; pool 81 posizioni, 78 segnali]
Sei fasce fissate a priori (ora server). Una sola e' fuori attesa: **08-12 (europa mattina)**, n 14, r medio **-0,527 R**, PF 0,15, p 0,003 (0,005 per segnale; soglia corretta per 6 fasce 0,0083).
Togliendola il PF del pool passa da 0,56 a 0,83 (da 0,53 a 0,78 per segnale): ancora sotto 1. La replica in campioni disgiunti ha lo stesso segno ma nessuna soglia raggiunta (-0,72 n 7; -0,33 n 7; -0,16 n 7).
Il campione e' dominato da un episodio (5 stop in 3 giorni). Notte 00-08: r medio -0,04, non distinguibile da zero. **INDIZIO, non esito.**
**Orologio**: il server segue l'ora di Londra per il forex fino a dicembre 2024 e UTC+1 fisso dopo; per gli anni prima del 2015 e' estrapolato, non misurato. Sul tester `TimeGMT()` e `TimeTradeServer()` coincidono (documentazione MQL5).

### 2.4 Simboli  [MISURATO, MIGLIORA parte 3]
- Correlazione di Spearman fra volatilita' (ATR/prezzo) e r medio per simbolo: **rho -0,03**, p 0,89 (20 simboli). Dispersione fra simboli: p 0,97. Nessun simbolo passa la soglia congelata (p < 0,05/22): il migliore ha p 0,073 su 6 vincite su 6.
- Il test e' **debole**: con ~10 segnali per simbolo trova un vantaggio di 0,25 R solo nel 43% dei casi; per +0,10 R servono ~490 segnali per simbolo. La volatilita' e' stata misurata sui soli trade stoppati.
- Valuta NZD peggiore (-12,05 R su 69 posizioni) ma "peggiore fra 8 valute" da' p 0,17.

### 2.5 Cosa e' gia' stato giudicato e cosa manca (certificato a 5 caselle)
(1) PF: fatto. (2) n e DD: fatto sul pool (n 221). (3) uscita ad asse: **non fatta** nel tester (solo carta sopra). (4) simboli gemelli: carta, nessun simbolo distinguibile. (5) TF: **mai cambiato**.
Verdetto: **NON ANCORA MISURATO**, non "morto". Regole di portafoglio simulate a carta (14 regole x 4 fonti) non sono distinguibili dal caso.

## 3. Cosa manca e quanto costa
- Una sola **copia di banco con telemetria** (massimo e minimo per posizione, ora d'ingresso, ATR e spread alla barra del segnale) chiuderebbe quasi tutti i buchi. Richiede una firma del capo: **non e' ancora data**.
- Il tester gira solo su un PC separato dai conti. Ritmi misurati: una corsa corta (1 simbolo) dura circa 68 secondi, una lunga (22 simboli) circa 95: **circa 67 secondi fissi per ogni passata + una parte per simbolo**. La stima per le 38 passate previste e' **1-3 ore** [DERIVATO, forchetta larga].
- Per la prova di `TimeGMT` nel tester serve una finestra con almeno **5 ingressi attesi** all'ora discriminante; una finestra piu' corta non distingue le due ipotesi.

## 4. Le domande

**Ruolo A -- Cacciatore (massimo 2+2 meccanismi, niente parametri del motore).**
- A-1. Sulla stessa inefficienza (fade di un tocco di banda dopo un impulso, SL 3 ATR, TP sulla mediana, payoff ~0,27, win rate 72,9%), proponi al massimo **2 meccanismi di USCITA** diversi da BE, parziale e trailing a R
  (qui inerti: zero vincite su 161 arrivano a 1 R). Per ognuno: nome esatto dell'input o "nome da verificare", attesa con banda e **numero dell'ipotesi alternativa**, falsificatore, costo in passate.
- A-2. Proponi al massimo **2 filtri di REGIME** esterni al segnale (orario, evento, volatilita' del cesto, correlazione fra valute) che non cambino la condizione d'ingresso e non richiedano di conoscere il futuro.
  Dichiara se riducono il numero di ingressi e di quanto.
**Ruolo B -- Avvocato del diavolo.** Per ogni proposta di A e per queste letture nostre, il contro-esempio concreto (cosa produce l'ipotesi alternativa e se cade nella banda):
- B-1. "La fascia 08-12 e' peggiore": spiegala con un episodio (5 stop in 3 giorni) o con il regime; quale numero atteso se e' solo l'episodio?
- B-2. "Le regole di portafoglio non aiutano": quando una regola che toglie il 26-48% dei segnali sembra neutra con la sola rimozione e invece non lo e'?
- B-3. "La volatilita' non spiega il r medio per simbolo (misurata sui soli trade stoppati)": in quale caso concreto la misura darebbe zero anche se l'effetto esistesse?
**Ruolo C -- Auditor dei numeri** (deroga: **al massimo 3 conti**, uno per riga, con formula e controllo di verso; solo dati di questo pacchetto; NON LO SO se manca).
- C-1. Vincita media 0,254 R, perdita media 0,951 R, tasso di vincita osservato 72,9%: qual e' il tasso di vincita di pareggio `L/(W+L)` e l'osservato sta sopra o sotto?
- C-2. Servono segnali per simbolo per distinguere un vantaggio di +0,10 R da zero: sigma 0,570 R, alpha = 0,05/22 a due code, potenza 80%. Con `n = (sigma x (z(1-alpha/2)+z(0,80))/delta)^2`, quanto vale n?
- C-3. Un break-even riporta a pareggio ogni vincitore (perde la vincita media 0,254 R) e salva ogni perdente (recupera 0,951 R): qual e' il rapporto minimo perdenti salvati / vincitori riportati a BE perche' il BE non costi?
**Ruolo D -- Sintesi.** Al massimo 5 cose da MISURARE, in ordine di vicinanza a una sedia schierabile, ognuna con asse unico, finestra, cella di controllo, attesa con banda, falsificatore, costo (usa i ritmi di sez. 3),
"Firma Claudio SI/NO"; poi l'elenco dei punti dove tu e la nostra lettura vi contraddite. Poi la sezione E del protocollo.

## 5. Vincoli
Niente martingala/griglia/recovery; stop >= 40 x (spread + commissione) all'ora d'ingresso; centro dell'altopiano mai il picco; nessun criterio si abbassa; **non stringere l'entrata del VIOLA**; il certificato di morte a 5 caselle vale;
ogni numero con la fonte o NON LO SO; nomi degli input, mai numeri di riga; taglie, rischio, Guardian, conti e spese = "Firma Claudio: SI". Le tue proposte tornano a Claude e passano dal cancello: non si eseguono.
