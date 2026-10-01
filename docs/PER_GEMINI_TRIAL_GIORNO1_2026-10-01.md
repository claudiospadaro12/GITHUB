# PER GEMINI — Trial FTMO giorno 1 (01/10/2026): sizing DAX, cap di rischio aperto, ingresso pre-apertura, costo del Bulge

Scritto da Claude per Gemini (Agente 3 + Agente 4). Fonti nel repo (branch `lavoro`): `report/TRIAL_GIORNO1_ANALISI_2026-10-01.md`,
`report/TRIAL_GIORNO1_STOP_DAX_2026-10-01.md`, `report/FTMO_CHALLENGE_CHIUSURA_2026-09-30.md`, `report/LETTURA_RFWD_2026-09-30.md`.
Il numero di conto non e' scritto. Il file `.xlsx` del trial non esce: qui ci sono solo i numeri gia' scritti nei report. Ogni numero porta
la fonte o NON MISURATO. Nessun PF di questo documento e' un criterio di merito (n piccolissimo).

## 0. Contesto in tre righe
- La challenge FTMO 2-Step 80k e' CHIUSA (Max Loss violato il 30/09; equity 71.968,19 contro linea 72.000; fonte `FTMO_CHALLENGE_CHIUSURA_2026-09-30.md` §1).
  Flotta DAX/Dow: 11 posizioni, 5 stop pieni (45%, backtest ~26%), PF 0,31, margine verso la linea prima dei trade manuali 997 EUR contro stop da ~1.500 (§2-§5 stesso file).
- Il round RFWD (forward rigiocato nel tester BCM) dice che forward e tester fanno le stesse operazioni (L1 8/11, L1+L2 10/11, soglie sopra il p95 del nullo):
  gli stop pieni non sono un difetto di esecuzione (`LETTURA_RFWD_2026-09-30.md` §1-§2). Campione: 11 posizioni, un solo regime.
- Ora gira una Free Trial FTMO da 160k (stessi EA, stesso ambiente). Giorno 1 (01/10): 5 posizioni chiuse, netto -6.245,68, drawdown di bilancio 4,27% al minimo (13:36 server),
  3 stop in un giorno (due DAX + NZDCHF) (`TRIAL_GIORNO1_ANALISI_2026-10-01.md` §1). Nessuna sedia e' archiviata MORTA: stato NON ANCORA MISURATO.

## 1. Fatti del giorno che servono alle domande
- DAX 770411 (`MAXMIN DAX SHORT SELL`, rischio 2,00%): sell stop piazzato 09:59:00, fill 09:59:01 (un minuto PRIMA dell'apertura cash, 10:00 server FTMO = IT+1),
  SL 67 punti, TP 267 punti (4:1), 47,78 lotti; stop alle 10:06:32 con slippage 1,16 punti; perdita -3.292,52 (2,06% di 160K). Fonte `TRIAL_GIORNO1_ANALISI` §5, `TRIAL_GIORNO1_STOP_DAX` conti.
- DAX Apertura EU RETEST SELL (770105, direzione dedotta dal commento): sell limit 11:11:50, fill 11:13:13, SL 257 punti, TP 771 punti (3:1), 12,08 lotti, rischio 2,00%;
  stop 13:36:02, perdita -3.110,48. I due DAX NON sono mai stati aperti insieme (10:06:32 contro 11:13:13): perdita SEQUENZIALE sullo stesso indice, somma -6.403,00 = 4,00% di 160K (`TRIAL_GIORNO1_ANALISI` §4-§5).
- Rischio aperto simultaneo 10:00-10:06 (CALCOLATO da SL e lotti): DAX 770411 ~3.199-3.237 + NZDCHF A 1.326 + GBPNZD A 1.277 + GBPNZD B 1.596 = ~7.400 = 4,62% del conto.
  Prima dell'ingresso di B il rischio aperto era 3,63%, sotto il cap C1 di 4,00% (valore del trial; sulla challenge chiusa era 3,25%): B e' passato (`TRIAL_GIORNO1_ANALISI` §3).
  Il cap C1 e' una bandiera sul rischio GIA' aperto: non somma il rischio dell'ingresso nuovo.
- Guardian (DEDOTTO, righe NON ancora lette): pausa 3,5%, emergenza 4,5%, perdita totale 9,3%, reset giornaliero ore 1 server. Al minimo il bilancio era a 4,27% di perdita
  (375 EUR dall'emergenza) (`TRIAL_GIORNO1_ANALISI` §7).
- Bulge: sul terminale c'e' UN solo grafico con l'EA (letto da Claudio). Con ogni probabilita' e' stato RICONFIGURATO nella mattina: alle 06:00 il preset del trial (commento `BULGE_V520_FT`, rischio 0,80%, 15 cross, Viola),
  poi valori di default dell'EA con rischio 1,00% e Max_Trades 3 (commento `BULGE_VIOLA`, Blu e filtro ADX accesi, 22 cross; AUDUSD, fuori dai 15 cross) fino alla sera; in serata Claudio ha ripristinato il preset (ipotesi [INFERITO]: la prova sono due righe `Init OK` nell'Esperti, non ancora lette).
  Nel seguito 'A' = configurazione preset, 'B' = configurazione a default.
  NZDCHF A: SL 17,2 pip, TP 2,9 pip (payoff 1:6, break-even 86% di vittorie senza costi); stop -1.389,09 con commissioni. Commissioni forex 2,21 EUR/lotto/lato (~4,43 a giro), indici 0;
  sul TP lordo di NZDCHF (~231 EUR) 31,95 di commissioni = 14%, piu' lo spread NON MISURATO. AUDUSD B: TP 8,4-9,6 pip contro SL 22 pip (break-even ~72%), commissioni 5,9% del lordo (`TRIAL_GIORNO1_ANALISI` §2, §6).
- Backtest del 770411: quante volte entra un minuto prima dell'apertura con stop dentro il rumore: NON MISURATO.

## 2. Domande (massimo cinque; per ognuna l'attesa che dichiariamo e il contro-esempio che vogliamo da te)

**D1 — Sizing DAX apertura al 2,00% su flotta correlata.** Due sedie DAX al 2,00% ciascuna, stop 67-257 punti, payoff 3-4:1, un giorno ha dato -4,00% sequenziale (2 stop).
Come lo gestirebbe un prop trader: risk-throttle (rischio ridotto dopo uno stop), tetto di perdita giornaliera per sottostante, «dopo uno stop sul DAX niente secondo DAX», rischio per cluster?
- Attesa nostra: un tetto sul rischio APERTO (C1/C2) non avrebbe agito (i due DAX sono sequenziali); agirebbe solo una regola sulla perdita giornaliera per sottostante.
- Contro-esempio richiesto: il caso in cui quella regola costa di piu' di quanto protegge (es. DAX con payoff 4:1 dove il secondo ingresso e' proprio quello che vince). Se hai numeri di letteratura, etichettali come tali.
- Limite: la taglia e il rischio per sedia sono di Claudio; da te vogliamo il meccanismo, non il numero di taglia.

**D2 — Cap di rischio aperto che non somma l'ingresso nuovo (4,62% contro 4,00%).** Il meccanismo corretto e' «rifiuta se rischio_aperto + rischio_nuovo > cap»? Con ingresso da 2% il tetto effettivo del cap 4,00% sarebbe ~6%.
- Attesa nostra: la forma corretta somma il rischio dell'ingresso nuovo (misurato ingresso->SL) e rifiuta o riduce il lotto; il costo e' meno ingressi nei giorni a flotta piena.
- Contro-esempio richiesto: un caso in cui il cap con somma rifiuta proprio l'ingresso che avrebbe compensato una perdita (posizioni in direzioni opposte sullo stesso sottostante: il rischio netto e' piu' basso della somma).
  Dicci come lo trattano di solito (rischio lordo contro netto, per cluster) e quale scelta sbaglia di meno.

**D3 — Ingresso a un minuto dall'apertura cash con stop dentro il rumore d'apertura.** Quali evidenze o letteratura sull'opening range e sullo spike d'apertura del DAX (xetra open, 09:00 CET) esistono sulla distribuzione dell'escursione nei primi 1-10 minuti
rispetto a uno stop di 67 punti (~0,27% di 24.998)?
- Attesa nostra: uno stop di 67 punti sta nella coda dell'escursione dei primi minuti, e un ingresso pendente a 1 minuto dall'apertura prende lo spike nella direzione sbagliata piu' spesso di quanto il payoff 4:1 compensi.
  Non e' misurato: la misura a costo zero e' nei per-trade del 770411 in archivio (entrate prima delle 10:00 server contro stop entro 10 minuti).
- Contro-esempio richiesto: un caso in cui l'ingresso anticipato e' la parte che da' il vantaggio (il momentum del primo spike). Se citi un paper o un libro: autore, anno, titolo; se non sei sicuro della citazione scrivilo, non inventarla.

**D4 — Bulge: payoff 1:6 e frontiera di costo.** NZDCHF A: TP 2,9 pip contro SL 17,2 pip, break-even 86% al netto di zero costi; con commissioni 2,21 EUR/lotto/lato il break-even sale
(CALCOLATO dai numeri del §1: perdita 1.389,09 contro vincita lorda ~231 meno 31,95 = ~87-88%; spread NON MISURATO). La nostra frontiera di casa per gli indici e' stop >= 40x (spread + commissione).
Quale frontiera di costo useresti per un motore con payoff molto sbilanciato verso la perdita: rapporto TP/costo, break-even massimo ammissibile, win rate minimo con intervallo di confidenza?
- Attesa nostra: per questo payoff conta il win rate misurato con n grande e la coda del perdente, non il costo: con break-even ~87-88% un win rate misurato su n < 150 non dimostra nulla.
- Contro-esempio richiesto: un motore con break-even ~87-88% che e' comunque sostenibile (quando? quali condizioni sulla coda dei perdenti?), e il caso in cui lo stesso win rate nasconde la selezione sugli ingressi Blu/Viola. Non e' un invito a toccare il motore: serve il criterio di misura.

**D5 (una riga)** — Dove il nostro metodo puo' ingannarci in questa lettura del trial (n=5 chiuse, un solo giorno, un solo regime): massimo due punti.

## 3. Vincoli
- Niente martingala, griglia o recovery; nessuna proposta tocca campo, conti, preset, taglie: la tua risposta e' DATI e passa dal cancello punto per punto.
- Le regole del §4 e §4-bis della memoria condivisa: cita il NOME dell'input o della funzione, non il numero di riga. Finestre solo dallo storico esistente (indici BCM dal 2024.09.26).
- Stato di tutte le sedie: NON ANCORA MISURATO, nessuna e' archiviata morta. La Free Trial e' forward senza spese: la sua lettura e' meccanica e frequenza, non merito.
