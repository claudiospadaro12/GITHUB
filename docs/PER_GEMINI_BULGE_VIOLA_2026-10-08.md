# PER GEMINI -- EA #2: Bulge, segnale VIOLA (08/10/2026) -- secondo pacchetto "a squadra"

Scritto da Claude per Gemini, secondo `docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md` (ricevuto insieme a questo file): rispondi nei ruoli **A, B, C, D** (e la sezione E del
protocollo), una riga per affermazione, con la regola "senza fonte = IPOTESI". Se l'intestazione o l'istruzione di sistema che ricevi parla di "Agente 1-4" o di "Agente 3 e
Agente 4", per questo scambio vale il protocollo: i ruoli A e B corrispondono agli Agenti 3 e 4, C e D sono nuovi. Nessun numero di conto, nessun preset, nessuno script in questo documento.
Etichette nostre: **[LETTO]** letto in un file del repo; **[MISURATO]** rifatto da noi su un CSV; **[DERIVATO]** conto da numeri misurati; **[INFERITO]**; **[NON MISURATO]**.
Fonti nel repo (`lavoro`): `report/MIGLIORA_BULGE_VIOLA_2026-10-08.md` (parti 1-3, 11-13), `report/BULGE_VIOLA_TELEMETRIA_SPEC_2026-10-08.md`,
`report/CONFRONTO_BULGE_VIOLA_VS_BREAKING_BAND_2026-10-08.md`, il sorgente `mql5/Experts/ABTG_Bulge.mq5` (citati per riferimento, **nessuno allegato**: i nomi degli input sono ricontrollati sul sorgente).
**Dati forward chiusi al 07/10** (i numeri MISURATI si riproducono solo con quel taglio).
**Decisione del capo del progetto, in chiaro: "il motore VIOLA non si tocca; ogni tocco dopo un impulso, com'e' ora; non stringere l'entrata".** Cerchiamo di migliorare
USCITA, REGIME e SIMBOLI senza ridurre molto la frequenza. Proposte che stringono l'ingresso non servono.

## 1. Il motore, in poche righe  [LETTO: sorgente, salvo dove indicato]
1. Timeframe H1 **scritto nel codice** (nessun input per cambiarlo: cambiare TF e' codice nuovo), 22 coppie forex (`Symbols_List`: 15 cross e 7 coppie con l'USD). Un **impulso** = una candela nella direzione della banda
   (ribassista per la banda bassa) che la tocca, con corpo di almeno 0,2 ATR. Il VIOLA (post-bulge) guarda cio' che segue: entro 40 barre dall'impulso (`Lookback_Bars` x 2)
   il prezzo tocca la **mediana**, **non** tocca la banda opposta, la barra di conferma ha il minimo sotto la banda bassa (e lo specchio per lo short), la banda bassa e' quasi
   piatta (variazione <= 0,6 ATR rispetto a 6 barre prima) e la candela di conferma ha corpo <= 1,5 ATR. Si entra **contro** l'impulso (long dopo un impulso ribassista).
2. **Il VIOLA NON richiede un "bulge" delle bande** (ampiezza >= 1,1x media): quel controllo (`isBulgeSig`) vale solo per gli altri due segnali (arancio, blu).
3. Stop = 3 ATR (`SL_ATR_Mult`); take profit = la mediana delle bande (media mobile centrale), **ricontrollata a ogni tick** (`UpdateAllTP`) sulla mediana dell'ultima barra chiusa e riscritta se resta oltre
   l'entrata: il codice la sposta in **tutte e due** le direzioni; sul conto di prova il TP alla chiusura e' **piu' vicino** all'entrata di quello d'apertura in **13 posizioni su 19**, uguale nelle altre 6, mai piu' lontano [MISURATO: ordini contro posizioni del rendiconto; e' un'osservazione, il codice non lo impone]. Break-even, trailing e parziale sono
   **spenti** di default (`Enable_BE_1R`, `Enable_Trailing_R`, `Enable_Partial_Close`). Rischio per operazione `Risk_Percent`, `Max_Trades` sulle posizioni aperte dell'intero cesto e di **tutti** i segnali accesi, kill switch giornaliero (`Use_Kill_Switch`: anche lui conta gli stop e la perdita del giorno di **tutti** i segnali dell'istanza).
   **Filtri di regime GIA' nel codice**: `Use_ATR_Filter` (default acceso: ATR della barra chiusa fra `ATR_Min_Mult` 0,5 e `ATR_Max_Mult` 1,8 volte la sua media a 20) vale
   **anche per il VIOLA**; era **spento** nel backtest di screening (190 delle 221 posizioni del pool), acceso nella configurazione dell'istanza principale del conto di prova
   e in quelle scritte per l'istanza del demo (la copia che gira davvero sul demo e' NON VERIFICATA): il pool mescola i due stati [LETTO: file di prova e configurazioni].
   Nello stesso backtest erano accesi **anche ARANCIO e BLU** (173 delle 363 posizioni della gamba fuori campione) e dividevano col VIOLA i 4 posti di `Max_Trades` e il kill switch; sul demo gira anche il BLU, nella stessa istanza (13 posizioni BLU contro 33 VIOLA al 07/10; il valore di `Max_Trades` in campo e' NON VERIFICATO). `Use_ADX_Filter` esiste ma di default non si applica al VIOLA (`ADX_Apply_On_Purple` spento). Filtro orario: `Use_News_Filter` + `News_Block_Hours` (spento; una lista di ore uguale per tutti i simboli, letta con `TimeGMT()`: in campo e' UTC, nel tester e' l'ora server, vedi 2.3).
4. Nel codice corrente una sola posizione per simbolo, segnale e lato (confronto sul commento dell'ordine), per istanza dell'EA. Nel forward della versione antenata **3 segnali hanno aperto due posizioni identiche** [LETTO: per-trade;
   causa NON verificata]: dove serve, le misure sotto distinguono POSIZIONI e SEGNALI, e le due posizioni dello stesso segnale **non sono indipendenti**.

## 2. I numeri, con la fonte

### 2.1 Quanto vale oggi  [MISURATO su CSV del repo; riepilogo in MIGLIORA parte 0 e parte 1]
- Pool della versione corrente (n **221** posizioni VIOLA: gamba fuori campione di **2 mesi** (maggio-giugno 2026) di un backtest di screening di 4 mesi, 190, + forward demo, 31): **PF 0,72** (in R), tasso di vincita **72,9%**;
  vincita media e perdita media in R sono i dati del conto C-1. DD sulle sole chiusure VIOLA del backtest: 14,9% a 0,8% di rischio per operazione.
- Commissioni e swap pesano l'8-23% della perdita netta; il PF **prima di commissioni e swap** e' gia' 0,43-0,75 nelle tre fonti forward (19, 33, 50 posizioni). **Lo spread
  e' dentro quel lordo e per 19 delle 22 coppie NON e' misurato** (lo abbiamo solo per EURUSD, GBPUSD, USDJPY: alle 22 ora server vale il 3-21% di R contro <1% nelle altre ore, con un ATR stimato da 1-4 stop): "i costi non spiegano
  la perdita" vale per commissioni e swap, non per lo spread.
- Forward: 19 posizioni su un conto di prova prop, PF 0,40; versione antenata (50 posizioni), PF 0,68; versione corrente sul demo (33, al 07/10), PF 0,47; l'08/10 il demo ha chiuso altre 9 VIOLA, tutte a TP: con quelle, 42 posizioni e PF 0,75 sul netto in valuta [MISURATO; fuori dal pool e da ogni numero sotto]: un solo giorno sposta il PF di 0,28. **Non sono quattro conferme
  indipendenti**: 31 delle 33 del demo sono dentro il pool (le altre 2 sono su XAUUSD, fuori dalle 22 coppie del codice: la lista di simboli dell'istanza del demo non e' quella di default ed e' NON VERIFICATA); il conto di prova condivide le operazioni del demo sui cross comuni; il backtest e l'antenato coprono lo stesso periodo.
  Il solo numero buono che abbiamo (PF 1,60 su 268 operazioni) e' un backtest del capo del progetto su **BLU+VIOLA insieme**, 6 cross, 2022-2026.03, il cui file **non e' nel repo** [NON LEGGIBILE]: non e' una misura del solo VIOLA.
- **La forma del payoff**: la mediana dista ~0,7 ATR dall'entrata (mediana fra simboli, ricavata come 3 x la vincita mediana in R) con stop a 3 ATR; **nessuna delle 161 vincite
  CHIUDE a 1 R o piu'** (massimo 0,83 R), vincita mediana 0,24 R, 90-esimo percentile 0,46 R; sul conto di prova il TP iniziale non supera 0,73 R in nessuna delle 19 posizioni.
  Per questo BE a 1 R, trailing da 1,5 R e parziale a 1 R non scattano quasi mai [DERIVATO].
- Frequenza: ~4,6 posizioni VIOLA al giorno di borsa nella gamba fuori campione del backtest (190 in 41 giorni, 4 maggio-29 giugno; filtro ATR spento, posti condivisi con ARANCIO e BLU), ~5,5 sul demo (33 in 6 giorni). 150 posizioni in forward arriverebbero in circa 6 settimane.

### 2.2 Uscita: cosa dice (e non dice) il per-trade  [MISURATO, MIGLIORA parte 11; insieme di 81 posizioni sulle 22 coppie, con banda M5: demo v. corrente 31 + antenato 50]
- Delle 21 perdite a SL, **15 chiudono lo stesso giorno**: fra queste il massimo guadagno non realizzato (banda M5) ha toccato +0,3 R in **4**, +0,5 R in **2**, +0,75 R in **1**
  (limite SUPERIORE). Un break-even a quelle soglie salverebbe su queste 15 al massimo +3,87 / +2,00 / +1,06 R (somma r delle 81: -9,78). **Le altre 6 perdite durano piu' giorni
  e per loro il massimo e' ignoto**: se tutte e 6 avessero toccato +0,3 R, il tetto complessivo a 0,3 R salirebbe a +10,64 R (per loro il pavimento e' 0). Dall'altra parte stanno i vincitori che poi tornano a pareggio: quanti, NON MISURATO.
  Quanti perdenti salvati servono per ogni vincitore tagliato e' il conto C-3.
- **Il trailing come e' scritto vale break-even sotto 1 R**: il blocco `TrailLockR` e' zero finche' r < 1, quindi un "trailing a trigger basso" coincide con un BE. Un vero trailing a distanza e' codice nuovo.
- Un break-even colpito **conta come SL nel kill switch** (conta ogni uscita per SL o con profitto negativo): un BE che sostituisce una vincita puo' aumentare le pause. "A frequenza invariata" e' un'ipotesi da misurare.
- **Attenzione a una trappola di lettura [corretta dal cancello]**: `UpdateAllTP` sposta il TP (sul conto di prova verso l'entrata in 13 posizioni su 19, mai lontano), e una vincita a TP ha toccato almeno quel livello: il profitto finale di una vincita nel CSV e' un **pavimento** della sua escursione, non l'escursione. Il percorso vero non e' nel repo [NON MISURATO]:
  per questo ogni conclusione sul BE che usa l'r finale delle vincite e' un'ipotesi.
- Il trigger di un eventuale **parziale** scatterebbe, a 0,25 R, nel 30-67% delle posizioni del demo e dell'antenato (37-74% sul conto di prova) e a 0,50 R nel 2,5-38% (5-16%): forchette larghe, il numero vero lo da' solo la telemetria.

### 2.3 Orario  [MISURATO, MIGLIORA parte 12; stesse 81 posizioni = 78 segnali]
Sei fasce fissate prima del ricalcolo (ora server). **Ma la fascia 08-12 non e' una scoperta fresca**: un blocco vicino (08-13) era gia' stato visto sugli stessi dati
qualche giorno prima. Una sola fascia e' fuori attesa: **08-12 (europa mattina)**, n 14, r medio **-0,527 R**, PF 0,15, p 0,003 (0,005 per segnale; soglia corretta per 6 fasce 0,0083).
Togliendola il PF delle 81 passa da 0,56 a 0,83 (da 0,53 a 0,78 per segnale): ancora sotto 1. Le 14 si dividono nelle due fonti che formano l'insieme: antenato -0,72 (n 7),
demo v. corrente -0,33 (n 7, p 0,17); il conto di prova -0,16 (n 7) condivide operazioni col demo. Senza il giorno peggiore la fascia resta negativa (-0,35 R, n 11) ma **non e' piu' significativa** (p 0,09) [MISURATO]. L'antenato
e' dominato da un episodio (5 stop in 3 giorni). Notte 00-08: r medio -0,04, non distinguibile da zero. **INDIZIO, non esito.**
**Orologio**: il server segue l'ora di Londra per il forex fino a dicembre 2024 e UTC+1 fisso dopo; per gli anni prima del 2015 e' estrapolato, non misurato. Sul tester `TimeGMT()` e `TimeTradeServer()` coincidono (documentazione MQL5).

### 2.4 Simboli  [MISURATO, MIGLIORA parte 3; pool 221]
- Correlazione di Spearman fra volatilita' (ATR/prezzo) e r medio per simbolo: **rho -0,03**, p 0,89 (20 simboli). Dispersione fra simboli: p 0,97. Nessun simbolo passa la soglia congelata (p < 0,05/22): il migliore ha p 0,073 su 6 vincite su 6.
- Il test e' **debole**: con ~10 segnali per simbolo una differenza lineare di 0,25 R fra simboli si trova solo nel 43% dei casi (simulazione); quanti segnali servono per +0,10 R e' il conto C-2. La volatilita' e' stata misurata sui soli trade stoppati.
- Valuta NZD peggiore (-12,05 R su 69 posizioni) ma "peggiore fra 8 valute" da' p 0,17.

### 2.5 Cosa e' gia' stato giudicato e cosa manca (certificato a 5 caselle)
(1) PF: si', **ma solo 2026** (gamba fuori campione di 2 mesi di un backtest di screening di 4 mesi, merito non misurato per costruzione, + forward); la cella lunga 2010-2026 e' scritta e **mai girata**. (2) n e DD: si', n 190-221, DD solo sulle chiusure o per il cesto intero.
(3) uscita ad asse: **non fatta** nel tester (solo carta sopra). (4) simboli gemelli: **no** a lungo (cesto 22 contro 15 mai confrontato); a carta nessun simbolo distinguibile.
(5) TF: **mai cambiato** (H1 nel codice). **M30 e' escluso per costo solo sui cross a stop corto** (es. NZDCHF: stop M30 stimato ~11,9 pip, budget 0,30 pip contro 0,41 di
sola commissione, ricavata dal conto di prova; stima con ATR M30 ~ ATR H1 / radice di 2 [DERIVATO, non misurato]); sui cross a stop lungo (GBPNZD, EURNZD: 77-80 pip a H1) dipende dallo spread, NON MISURATO.
E gia' a H1 la frontiera di sez. 5 non regge su tutti: EURGBP e' fuori anche a spread zero, NZDCHF ha 0,01 pip di margine. H4: non escluso per costo, ~1/4 della frequenza [DERIVATO], mai misurato.
Verdetto: **NON ANCORA MISURATO**, non "morto". Regole di portafoglio simulate a carta (14 regole x 4 fonti) non sono distinguibili dal caso.

## 3. Cosa manca e quanto costa
- Una sola **copia di banco con telemetria** (massimo e minimo per posizione, ora d'ingresso, ATR e spread alla barra del segnale) chiuderebbe quasi tutti i buchi. Richiede una firma del capo: **non e' ancora data**.
- Il tester gira solo su un PC separato dai conti. Ritmi misurati sulla stessa finestra (job di 2 celle su 4 mesi): **68 secondi con 1 simbolo, 95 con 22**, cioe' **circa 67 secondi fissi
  per job + circa 1,3 secondi per simbolo**. La stima per le 38 passate previste (9 file) e' **1-3 ore** [DERIVATO, forchetta larga; primo caricamento dello storico NON MISURATO].
- **Gia' scritti, MAI girati** (9 file, solo VIOLA, 2010-2026.06, 15 coppie = 12 cross + 3 con l'USD, non i 15 cross di sez. 1; filtro ATR acceso, solo input esistenti; un asse per file): cella base; BE a 0,25 / 0,50 / 0,75 R;
  parziale del 50% a 0,25 / 0,50 R (il codice porta anche lo stop a pareggio sul residuo); ADX applicato al VIOLA a 25 / 30; `ATR_Max_Mult` 1,2 / 1,5; `SL_ATR_Mult` 2,5 / 3,5 (solo con decisione del capo); tre fasce
  orarie bloccate con `News_Block_Hours` (00-08, 08-12, 22-24 ora server). Solo nel simulatore offline (aspetta la telemetria): chiusura d'invalidazione a 15 / 30 / 45 minuti
  dall'ingresso (prezzo avverso di 0 / 0,25 / 0,5 ATR; candela d'entrata di colore opposto con prezzo oltre il centro della candela di conferma; gap contro che continua), uscita a fine candela d'entrata se chiude di colore opposto,
  time-stop a 6 / 12 ore se la posizione e' in perdita, trailing a R con partenza 0,50 / 0,75 R (sotto 1 R vale un BE, vedi 2.2).
- Per la prova di `TimeGMT` nel tester serve una finestra con almeno **5 ingressi attesi** all'ora discriminante; una finestra piu' corta non distingue le due ipotesi.

## 4. Le domande

**Ruolo A -- Cacciatore (massimo 2+2 meccanismi, niente parametri del motore).**
- A-1. Sulla stessa inefficienza (fade di un tocco di banda dopo un impulso, SL 3 ATR, TP sulla mediana, tasso di vincita 72,9%), proponi al massimo **2 meccanismi di USCITA** diversi da BE, parziale e trailing a R
  (qui quasi inerti: nessuna vincita chiude a 1 R) e da quelli gia' in lista in sez. 3 (se un tuo meccanismo coincide, dillo). Per ognuno: nome esatto dell'input o "nome da verificare", attesa con banda e **numero dell'ipotesi alternativa**, falsificatore, costo in passate.
- A-2. Proponi al massimo **2 filtri di REGIME** esterni al segnale (orario, evento, volatilita' del cesto, correlazione fra valute) che non cambino la condizione d'ingresso e non richiedano di conoscere il futuro. Filtro ATR per simbolo, ADX sul VIOLA e lista di ore
  esistono gia' e sono gia' in prova (sez. 1 e 3): se ne riproponi uno, dillo e spiega quale meccanismo nuovo aggiungi (un'altra soglia dello stesso filtro non conta).
  Nessuna proposta tocca le condizioni del segnale VIOLA di sez. 1: dire che una proposta coincide con una gia' in lista non la rende ammessa.
  Dichiara se riducono il numero di ingressi e di quanto. Se un filtro che scarta segnali conti come "stringere l'entrata" e' una domanda **ancora aperta** al capo: per ora sono ipotesi da misurare.
**Ruolo B -- Avvocato del diavolo.** Per ogni proposta di A e per queste letture nostre, il contro-esempio concreto (cosa produce l'ipotesi alternativa e se cade nella banda):
- B-1. "La fascia 08-12 e' peggiore": spiegala con un episodio (5 stop in 3 giorni) o con il regime; quale numero atteso se e' solo l'episodio?
- B-2. "Le regole di portafoglio non aiutano": quando una regola (es. al massimo 1 posizione per valuta, che toglie il 26-48% delle posizioni) sembra neutra in una simulazione che sa solo TOGLIERE ingressi (non vede quelli che entrerebbero negli slot liberati) e invece non lo e'?
- B-3. "La volatilita' non spiega il r medio per simbolo (misurata sui soli trade stoppati)": in quale caso concreto la misura darebbe zero anche se l'effetto esistesse?
**Ruolo C -- Auditor dei numeri** (deroga: **al massimo 3 conti**, uno per riga, con formula e controllo di verso; solo dati di questo pacchetto; NON LO SO se manca).
- C-1. Vincita media 0,254 R, perdita media 0,951 R, tasso di vincita osservato 72,9%: qual e' il tasso di vincita di pareggio `L/(W+L)` e l'osservato sta sopra o sotto?
- C-2. Servono segnali per simbolo per distinguere un vantaggio di +0,10 R da zero: sigma 0,570 R (misurata per POSIZIONE sul pool 221), alpha = 0,05/22 a due code, potenza 80%. Con `n = (sigma x (z(1-alpha/2)+z(0,80))/delta)^2`, quanto vale n?
- C-3. Un break-even riporta a pareggio ogni vincitore (perde la vincita media 0,254 R) e salva ogni perdente (recupera 0,951 R): qual e' il rapporto minimo perdenti salvati / vincitori riportati a BE perche' il BE non costi?
**Ruolo D -- Sintesi.** Al massimo 5 cose da MISURARE, in ordine di vicinanza a una sedia schierabile, ognuna con asse unico, finestra, cella di controllo, attesa con banda, falsificatore, costo (usa i ritmi di sez. 3),
"Firma Claudio SI/NO"; poi l'elenco dei punti dove tu e la nostra lettura vi contraddite. Poi la sezione E del protocollo.

## 5. Vincoli
Niente martingala/griglia/recovery; stop >= 40 x (spread + commissione) all'ora d'ingresso; centro dell'altopiano mai il picco; nessun criterio si abbassa; **non stringere l'entrata del VIOLA**; il certificato di morte a 5 caselle vale;
ogni numero con la fonte o NON LO SO; nomi degli input, mai numeri di riga; taglie, rischio, Guardian, conti e spese = "Firma Claudio: SI". Le tue proposte tornano a Claude e passano dal cancello: non si eseguono.
