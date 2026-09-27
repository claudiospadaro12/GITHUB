# BRIEFING PROGETTO ABTG — per Gemini (27/09/2026)

Scritto da Claude (socio di lavoro di Claudio) per mettere un secondo modello in condizione di
ragionare sul progetto con gli stessi fatti. Ogni numero ha la fonte nel repo GitHub
`claudiospadaro12/GITHUB`, branch `lavoro`. Dove un numero non esiste è scritto NON MISURATO.

## 1. Obiettivo, in due righe
Costruire Expert Advisor (EA, MQL5 per MetaTrader 5) che passino le challenge delle prop firm.
Challenge FTMO 2-Step da 80.000 EUR, conto `541452707`, viva dal 22/09/2026. Muri FTMO: perdita
giornaliera 5% (4.000 EUR, sull'equity), perdita massima 10% (72.000 EUR), minimo 4 giorni di
trading. Saldo al 26/09: 75.090,72 (drawdown 6,14%). Claudio decide taglie, rischio, conto reale e
spese; Claude ha carta bianca sulle decisioni operative. Il conto reale `10105439` non è toccato.

## 2. Il metodo: come si nasce sedia (una "sedia" = un EA + simbolo + preset in campo)
Imbuto in ordine, nessun salto:
1. **File prova** (`backtest_pipeline/prove/R<n>*.txt`): pin di TUTTI gli input dell'EA, un solo
   asse per file, finestra IS/OOS, magic vergini, e le **attese scritte PRIMA dei numeri** con
   ipotesi che non si sovrappongono (edge / niente / campione insufficiente).
2. **Cancello** in due strati: `controlla_riga.py`/`controlla_prova.py` (deterministico) + agente
   `controllo-preventivo` (giudizio, che prova a ROMPERE la misura con un contro-esempio). Niente
   esce verso Claudio o verso il VPS senza PASS. Ogni difetto di classe nuova finisce in
   `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md` (oggi 856 classi).
3. **Riga di lancio**: una sola riga PowerShell che scarica driver e file prova da un commit
   inchiodato (SHA256), gira lo Strategy Tester sul **PC di backtest** (mai sul VPS dove opera la
   challenge), verifica dopo ogni corsa che il motore compilato sia quello del pin, e produce uno zip.
4. **Referto** coi criteri congelati prima; poi **pacchetto** (preset FTMO + riga che lo scrive
   sul VPS + istruzioni per l'attacco a mano) -> **firma di Claudio** -> campo.

## 3. I cancelli (criteri congelati, non si abbassano)
| Cancello | Soglia |
|---|---|
| MERITO | PF >= 1,10 in IS **e** in OOS (a volte anche su due metà della finestra) |
| CAMPIONE | n >= 150 **posizioni** (non deal) per finestra |
| RISCHIO | DD alla taglia che vola dentro il muro 10%; soglia interna S3 8% a 2% |
| COSTO | stop >= 40 x (spread + commissione) all'ora d'ingresso; pavimento duro 13,3x |
| FREQUENZA | >= 1,00 operazioni/giorno per FAMIGLIA (motore x simboli), non per sedia |
| SELEZIONE | la cella è il **centro dell'altopiano, mai il picco** |
| ANCORA (G0) | ogni round deve riprodurre al centesimo una corsa d'archivio, altrimenti non si legge |
| GEMELLE (G1) | ogni cella gira due volte con magic diversi: se differiscono, il file è nullo |

**L'altopiano di scelta.** Su una griglia di parametri si NON sceglie la cella col PF più alto:
si cerca il blocco contiguo di celle che passano tutti i cancelli e si prende il centro. Un picco
isolato è rumore; un altopiano è un motore. Se l'altopiano è tagliato dal bordo della griglia (il
miglior valore è l'ultimo provato), la selezione non è possibile finché non si estende l'asse.
Esempio vero: 770201, asse `InpEmaSlow` 160-200 tutte buone e 200 = bordo -> R245 ha esteso a 260
(ancora aperto) -> R262 (27/09) ha esteso a 320: 300 e 320 cadono, quindi l'altopiano è 160-280,
chiuso, e il centro si legge.

**Emendamento della finestra.** L'IS si dimensiona in operazioni (>=150), non in anni; il vecchio
giudica il RISCHIO (un DD del 2020 è un fatto), il recente il MERITO. Quattro finestre di regime
(toro/orso/laterale/crollo) valgono più di 16 anni di media.

**Certificato di morte.** Un candidato è "morto" solo con: PF misurato, n e DD, gestione
dell'uscita messa ad asse, simboli gemelli provati, TF cambiato. Se manca una voce è "NON ANCORA
MISURATO". Se un motore è senza edge, NON si riottimizzano i suoi parametri (griglia più fitta =
picchi di rumore): si cercano meccanismi, simboli, TF, uscite diverse.

**Regola del contro-esempio.** Prima di consegnare, chi misura costruisce il caso che farebbe
sbagliare la misura e mostra che non sbaglia. Coerenza con l'attesa non è verifica.

## 4. Cosa è in campo su FTMO (541452707), oggi
| Magic | EA | Simbolo | Lati | Rischio |
|---|---|---|---|---|
| 770101 | DAX Apertura EU (retest) | GER40.cash M5 | long | 2% |
| 770105 | DAX Apertura EU | GER40.cash M5 | short (attaccata 25/09) | 2% |
| 770202 | Dow Apertura US (retest, range 35') | US30.cash M5 | long | 2% |
| 770260 | Nasdaq Apertura US | US100.cash M5 | long+short | 2% |
| 771531 | EMA200 | US30.cash H1 | long+short | 2% |
| 770511 | SuperWave DOW | US30.cash H1 | long+short | 2% |
| 770411 | MaxMinNotte DAX (box notturno, filtro S&P a specchio) | GER40.cash M15 | short | 2% |
| 779001 | Guardian (pausa 4,5 / emergenza 9,3 / cap rischio aperto 4,00%) | — | — | — |
Aritmetica che vincola tutto: cap 4,00% = **due posizioni al 2% aperte insieme**, la terza non
entra. Più sedie al 2% non aggiungono portata; le taglie sono firma di Claudio.
Numeri di contratto del 770202 (l'unico con per-trade in fase): DD chiuso 4,69% IS / 4,27% OOS a
1%. Orologio: server BCM (backtest) UTC+1 fisso; FTMO = ora italiana +1 tutto l'anno; dal 26/10
(EU) e 02/11 (USA) le sedie a ora fissa su BCM armano un'ora prima della cash — decisione entro
il 25/10.

## 5. I candidati, coi numeri (stato al 27/09)
| Candidato | Numeri misurati | Stato |
|---|---|---|
| **ORO 770402 lato LONG** (box notturno 23:00-04:59, rottura al rialzo) | R260 (27/09, OHLC M1 2020-2026, 0,5%): **279 posizioni, PF 1,336**, metà 1,171/1,521, DD equity 4,52% a 0,5% -> ~9% a 1%, 16-18% a 2% [derivato]; due lati = R103 PF 1,308 n 693 riprodotto al centesimo | merito RISPETTATO; tappo = taglia (firma), EA non compilato su C:\FTMO, preset solo-long da fare |
| **770201 breakout apertura USA 2 lati** (Nasdaq_Apertura_US su U30USD) | OOS PF 1,27-1,56 in 40/40 celle, n 186-198, DD 4-9% a 1%; R262: altopiano 160-280 chiuso; R263g: muro 10% cade fra rischio 1,25% (DD 9,1%) e 1,50% (10,8%); a 2% DD 14%; estate PF 0,98 (199) / inverno 1,80 (152); R248 finestra vergine DD 8,38% > p95 -> revisione | merito buono, taglia = firma; su FTMO alle 16:30 farebbe la cella estiva; R250 (in fase) in corsa nella riga A |
| **770212 Dow SHORT** (gemella short della 770202) | R54a short solo: IS PF 1,511 n 73 / OOS **0,840** n 73, DD 8,76% -> ~17,5% a 2% | pacchetto pronto e con PASS; fermo finché Claudio non conferma con R54a davanti; R255 (24 config in fase) da girare |
| **DAX LONG del box notturno** (specchio della 770411) | 0/33 celle sopra PF 1; R261 (27/09): filtro S&P morde (147->103) ma PF 0,883 su 72 pos; 7 TF tutti < 0,89 | manca solo l'uscita (R267g) per il certificato; atteso morto |
| **Londra ORB** (canale 07-08, GBPUSD/EURUSD) | MAI misurato (il vecchio "0/48" era un altro EA); sonda esterna: canale mediano 22,7 pip, il 40x passa nel 2-26% dei giorni | R258 (24 file) in corsa nella riga A |
| **Nightly** (fade della notte asiatica) | morta su EURUSD/GBPUSD/USDCHF (~160 trade, PF<1) e EURCHF (rischio); 6 simboli a zero per filtri (nome JPY/AUD; QB pip-vs-punti) | R259 in corsa nella riga A |
| **EMA200 H4** su GBPUSD/AUDJPY/GBPJPY/XAUUSD + EURUSD short | genetico in campione: PF 1,23-1,51 su 187-362 deal; AUDJPY già sotto 1,10 su 400-700 pos (R139a) | R264/R265 walk-forward nella riga C; attesa: bocciature in IS |
| ORB 770611 (Dow) | OOS PF 1,675 n 119 DD 6,5% ma forward negativo (peggior sedia 24-29/08) | osservazione |
| CostToCost EURJPY H4 | OOS PF 1,52 n 242 ma peggior giornata -8,0% | fermo per rischio giornaliero |

## 6. Gli agenti (Claude Code, lanciati in parallelo, ognuno con un perimetro)
- **controllo-preventivo**: il cancello. Riceve file prova/righe/EA/verdetti, esegue lo strato
  deterministico e poi prova a rompere la misura; risponde PASS/FAIL e corregge prima di consegnare.
- **cercatore-parametri**: dato un motore, cerca la configurazione senza curve fitting: scava
  nell'archivio (2.069 CSV, 148+ round), poi nelle uscite mai messe ad asse, poi nei default
  pubblici; scrive i file prova con attese dichiarate e cella al centro dell'altopiano.
- **cacciatore-strategie**: caccia meccanismi alternativi sulla stessa inefficienza (Code Base
  MQL5, TradingView, GitHub, paper); legge il sorgente, scarta martingala/griglia/no-SL/repaint.
- **cacciatore-config-prop**: caccia .set pubblici, pannelli input e regole prop; mappa i valori
  sui nostri input con il costo in passate.
- **controllo-caccia**: audita le cacce riaprendo le fonti (oggi: fiducia 7/10, zero invenzioni,
  ma soglia di costo applicata male in una sonda).
- **mql5-ea-developer**: scrive/modifica EA (mai in campo senza firma e cancello).
- **collaudatore-prop**: stress test (spread +25/50/100%, slippage) sulle celle validate.
- **architetto-prop**: sintesi in `report/PIANO_PROP.md`.
- **verificatore-stringhe**: controllo delle righe PowerShell (ASCII, PS 5.1, ora server, pin).
- **analista-trascrizioni**: schede da video/webinar.
Regole degli agenti: commit per percorso esplicito, mai `git add -A`; ogni consegna passa dal
cancello; nessun agente tocca preset in campo, taglie o il conto reale.

## 7. Cosa gira in questo momento (27/09)
- Sul PC di backtest: **riga A** (R250 770201 in fase + R258 Londra + R259 Nightly, 36 job,
  80-150 min). Poi **R255** (Dow short in fase, 24 job) e **riga C** (37 job: EMA200, box asiatico
  intero su GBPUSD/EURUSD, trend dell'oro come cancello sul long 770402, 11 manopole da caccia).
- **Riga B** già girata (43 min, 18/18): è la fonte dei numeri dell'oro, del DAX long e del 770201
  nella tabella sopra. Referto in scrittura.
- Difetti trovati dai cancelli SOLO oggi e ieri, prima che i numeri esistessero: classi 833-856.
  Esempi: un controllo che avrebbe annullato tutto il round dell'oro per la mezza commissione
  d'ingresso; una lettura che raddoppiava un DD già a 2%; una riga che avrebbe saltato 96 passate
  per aver letto il verdetto del server invece della data del disco.

## 8. Vincoli che non si muovono
- Conto reale 10105439: niente. Taglie e rischio: firma di Claudio. Runner notturno sul VPS:
  sola lettura. Round: solo sul PC di backtest mentre la challenge è viva.
- FTMO (scritto dal supporto 24-25/09): posizioni opposte sullo STESSO conto permesse;
  cross-account vietato, demo compresi, strumenti correlati compresi (DAX/Dow/Nasdaq), nessuna
  soglia. Domande aperte inviate il 27/09: tipo conto (Standard/Swing) e regole in Challenge,
  "gap trading" sulla pausa notturna del DAX, straddle di pendenti.

## 9. Cosa chiediamo a Gemini
1. Una seconda opinione sui criteri (§3): c'è un cancello che manca o uno che punisce senza motivo?
2. Sull'oro long (§5, prima riga): cosa faresti per decidere la taglia con un DD misurato in OHLC
   (limite inferiore) e ~279 posizioni? Che prova aggiungeresti prima di schierarlo?
3. Meccanismi alternativi, non parametri, per: Dow short d'apertura (R54a OOS 0,84), DAX long
   notturno (0/33), Londra (costo 40x). Ogni proposta con: regola precisa, simbolo/TF, ora server,
   numero dichiarato dalla fonte etichettato come tale, e costo in passate.
4. Errori di metodo che vedi in quello che leggi qui. Non serve essere gentili: serve essere utili.
