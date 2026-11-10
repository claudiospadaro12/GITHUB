# Avviso FTMO di iperattivita (10/11/2026): cosa dicono i nostri giornali del tester sulle richieste al server

**Contesto.** Il 10/11/2026 l'assistenza FTMO ha scritto a Claudio (conto trial 1515150476) che l'account ha un "alto grado di iperattivita": soglia **2.000 scambi o richieste al server al giorno, comprese le modifiche SL/TP e gli annullamenti di ordine**; il numero di **righe del file di registro** del terminale corrisponde alle richieste; se gli avvisi non diminuiscono "nei giorni successivi" il conto viene disabilitato. E la risposta alla domanda 7 della nostra mail (cosa conta nelle 2.000 richieste): contano anche le **modifiche SL/TP**.

**Natura: STIMA dai giornali del tester (D160), NON misura dal campo.** Un giornale del tester e una proxy: sul terminale reale il conteggio puo essere diverso (le ripetizioni "Trying again!" in live dipendono dal timer dell'EA). La misura vera e il registro del terminale FTMO: riga `RIGA_CONTA_RICHIESTE_FTMO.txt`.

## Cosa si vede nei giornali (80k-equivalente, anno intero, un EA alla volta, righe per giorno)
| EA, livello, anno | Righe del giornale (anno) | Giorno piu pieno | Righe "Market closed" (anno) | Righe di modifica |
|---|---|---|---|---|
| Phantom L1, 2025 | 6.584 | **1.262** (02/06/2025) | 1.224 | 2.195 |
| Phantom L0, 2025 | 5.721 | 1.036 (02/06/2025) | 789 | 1.471 |
| Goldbot L0, 2025 | 4.577 | 402 (22/12/2025) | 227 | 379 |
| Reaper L3, 2025 | 4.793 | 496 (02/07/2025) | 353 | 358 |
| Goldbot L0, 2013 | 4.158 | 256 | 31 | 61 |
- **Tutte le 1.262 righe del giorno piu pieno del Phantom L1 cadono nella stessa ora (23:00-24:00 ora server BCM)**: 631 `failed modify ... [Market closed]`, 477 `TrailStop error: 'unknown error 4756' ... Trying again!` e 154 `error when setting breakeven ...`. Cioe il picco non viene dalle operazioni, ma dai **tentativi di modificare SL/TP (trailing e breakeven) durante la pausa giornaliera dell'oro**, quando il mercato e chiuso e il server rifiuta.
- **Somma di piu EA nello stesso giorno (stesso giorno di calendario, tester)**: 02/06/2025 Reaper L3 + Goldbot L0 + Phantom L1 = **1.588** righe; Phantom L1 + Gold Trade Pro = **1.724**; Phantom L1 da solo 1.262. Nessun giorno oltre 2.000 nel tester, ma il 2025 ha un giorno oltre il 1.600 con due EA soli. Nel 2013 il massimo e 867.
- **Il trial FTMO non e un EA singolo**: ha Reaper, Goldbot, Phantom e Gold Trade Pro insieme (e altri EA del conto, NON VERIFICATO quali), con piu posizioni aperte durante la pausa; il 09/11 dieci posizioni long sono rimaste aperte dalle 22:15 alle 02:32 (ora FTMO), cioe attraverso la pausa giornaliera.

## Ipotesi (NON VERIFICATA) sulla causa
Nelle ore di pausa dell'oro, gli EA con trailing SL e breakeven riprovano la modifica a ogni giro mentre il mercato e chiuso; con 10 posizioni aperte e piu EA le righe si sommano, e in live (timer, non barre) il numero puo essere molto piu alto di quello del tester. Il Guardian, in pausa BLOCKED dopo le 02:32, non puo fermare gli EA: le modifiche e i tentativi sono degli EA.

## Cosa serve per decidere
1. **Misura vera**: righe per giorno e per ora nei registri di `C:\FTMO\Logs` e `C:\FTMO\MQL5\Logs` (riga di sola lettura sul VPS, `RIGA_CONTA_RICHIESTE_FTMO.txt`).
2. **Dove si concentrano**: per ora e per tipo di riga (`Market closed`, `modify`).
3. **Poi** gli interventi: ridurre il trailing/breakeven negli input degli EA, evitare posizioni aperte attraverso la pausa, e il contatore del Guardian v1.17 (soglie di avviso 1.000 e di allarme 1.600) — nessuno di questi interventi e deciso: li sceglie Claudio dopo la misura.
4. **Regola per la challenge**: un conto che riceve un avviso del genere rischia la disabilitazione; **il conteggio delle richieste e una condizione da verificare PRIMA di comprare una challenge**.

## Limiti
Giornali del tester (sessione di Windows 'logs' dell'agente, righe con data) usati come proxy; una sola corsa per EA; BCM e il suo orario (pausa 23:00-24:00 ora server BCM = GMT+1 fisso) non coincidono con FTMO; nessun conteggio sul campo.

## AGGIORNAMENTO (10/11, mattina): la causa piu probabile e un ciclo "piazza e cancella" fra gli EA e il Guardian in pausa
Fonti: `.xlsx` del trial 1515150476 (cronistorico del 10/11 05:38, ordini) e screenshot di Claudio dell'app MT5 (08:32 ora italiana, scheda Ordini del trial).
- **Dopo la chiusura del Guardian alle 02:32 (ora FTMO) gli EA hanno continuato a piazzare pendenti e il Guardian, in stato BLOCKED con pausa attiva, li ha cancellati subito**: nel report del trial il 10/11 risultano **760 ordini piazzati e 796 cancellati fra le 02:32 e le 06:35**, di cui **748 piazzati e cancellati nello stesso minuto**. Per ora: 02h 110 chiusi/cancellati, 03h 184, 04h 184, 05h 184, 06h 133. Piazzamenti ricorrenti ogni ora piena (39-40 ordini: 03:00, 04:00, 05:00, 06:00) e ogni 15 minuti (19 ordini: 02:45, 03:15). Per EA: GoldBot One 350 ordini, The Gold Phantom 288, The Gold Reaper 158.
- **Screenshot delle 08:32 ora italiana (09:32 FTMO): "Fatto 10, Annullato 1.337, Totale 1.347"** nella scheda Ordini del trial: il ciclo non si e fermato. Ogni ordine annullato e almeno **due richieste (piazzamento + cancellazione)**: 1.337 annullati = **oltre 2.600 richieste** in sette ore, cioe **gia sopra le 2.000 al giorno** con un ritmo di circa 180 richieste all'ora (circa 3.900 fino al reset del Guardian all'01:00).
- **Meccanismo (ipotesi molto forte, non verificata nel codice)**: la pausa del Guardian cancella ogni pendente nuovo (serve a non far scattare nuove posizioni dopo il -4,3% giornaliero); gli EA di Wim ricreano i pendenti a ogni barra (H1 e M15). Il Guardian non puo spegnere gli EA di terzi: e il caso scritto nella nota del codice ("il Guardian NON puo' fermare le loro modifiche senza chiudere tutto").
- **Questo spiega l'avviso meglio della pausa dell'oro**: l'ipotesi del 10/11 sul picco nell'ora della pausa (tester) resta possibile ma secondaria; il ciclo e un fatto osservato sul conto.
- **NON MISURATO**: il conteggio dei registri del terminale e le richieste di modifica (la riga sul VPS).
- **Cosa fare subito (decide Claudio)**: fermare il ciclo, per esempio **spegnendo il trading algoritmico** sul terminale FTMO fino al reset delle 01:00 (non ci sono posizioni aperte) oppure chiudendo il terminale; non cambiare altro. **Per il futuro**: il Guardian non deve cancellare all'infinito i pendenti rimessi dagli EA; serve un comportamento diverso in pausa (da progettare e provare prima di una challenge).

## Confronto fra i quattro conti (cronistorici `.xlsx` del 10/11 05:38; domanda di Claudio: "il settaggio medio degli EA del trial ha inciso?")
| Conto | Ordini nel report | Annullati / eseguiti | Piazzati per giorno | Lettura |
|---|---|---|---|---|
| FTMO trial 80k (1515150476) | 806 | 796 / 10 | 06/11: 19, 09/11: 27, **10/11: 760** | ciclo piazza-e-cancella dalle 02:32, ancora in corso alle 08:32 (screenshot: annullati 1.337) |
| BCM demo 50504263 | 377 | 351 / 26 | 06/11: 63, **09/11: 314** (21:00: 121, 22:00: 144) | stesso ciclo dopo la chiusura delle 21:18, fermo dopo le 22:50 (motivo NON NOTO) |
| BCM reale 10105439 | 66 | 44 / 22 | 06/11: 30, 09/11: 28, 10/11: 8 | normale: nessun ciclo |
| BCM demo 50504894 | 70 (60 pendenti ancora aperti) | pendenti piazzati il 06/11 e ancora li | 06/11: 30, 09/11: 24, 10/11: 6 | normale: pendenti che restano per giorni |
**Lettura**: in funzionamento normale gli EA piazzano pochi ordini (decine al giorno) e i pendenti restano per giorni. Il numero enorme compare solo sui due conti dove il Guardian e andato in pausa dopo il limite giornaliero: gli EA rimettono i pendenti a ogni barra e la pausa li cancella. Le impostazioni del trial (strategie attive e pendenti per barra: circa 40 ordini a ogni ora piena fra Goldbot, Phantom e Reaper; il trial non mostra ordini del Gold Trade Pro) moltiplicano il ciclo ma non lo creano. **NON VERIFICATO**: che gli input del trial siano uguali a quelli dei demo BCM (serve il confronto dei set caricati).

## Cosa e scritto su Discord (archivi di Wim: settimana 02-09/11 e sintesi precedenti in `UBS_DISCORD_2026-11-03/`; sono dichiarazioni di utenti, NON verificate)
- **Settimana 02-09/11**: nessun messaggio sul numero eccessivo di ordini o sulle richieste al server (cercati: hyperactivity, 2000, too many orders, order limit, requests). Un utente (Flygplan, 07/11) osserva che il broker rimuove i pendenti oltre il suo limite se si caricano 300 set UBS; lo strumento Strategy Ledger Pro (08/11) ha un allarme "order count against your broker's limit".
- **Sintesi precedenti (settembre-ottobre)**:
  - 30/09 Wim: avvisi di iperattivita da ICMarkets circa una volta al mese, che scattano a 2.500-3.000 messaggi, mai superati i 15.000; il 30/09 esce la versione degli EA oro con "virtual trailing SL e TP".
  - Utenti: 3-5 mila messaggi al giorno = avviso, 15 mila = rischio di conto disabilitato; cause citate: trailing stop e lo stesso magic number su due strategie (Micha9886, risolto cambiando i magic).
  - 01/10 Wim: SL/TP virtuali solo se il broker avvisa di iperattivita (altrimenti meglio quelli normali); langesi: il virtuale richiede bassa latenza.
  - 02/10 Eugen, citando Wim: contro l'iperattivita con lo SL virtuale mettere "seconds before pulling real SL" a **0 invece di 99**, cosi non modifica lo SL (e l'input `SetVSL_to_hardSL_sec_delay=99` dei nostri set; significato NON verificato).
  - Maximus: FTMO segnala l'iperattivita **anche senza posizioni aperte**; JOHN: il flag viene da MetaQuotes.
  - Consenso dei veterani (Eugen): non usare EA sulle prop (ban per iperattivita o strategie copiate).
- **Nessuno descrive un ciclo piazza-e-cancella causato da un risk manager**: nel nostro caso la causa e il Guardian, non gli EA.

## Riferimento "normale": demo BCM 50504894 (screenshot dell'app, 10:07 ora italiana)
Scheda Storico → Ordini: **Fatto 7, Annullato 10, Totale 17** (periodo del filtro non noto, probabilmente "oggi"). Le cancellazioni sono a ore piene o quasi (00:05, 06:10, 07:00, 08:00): sono gli EA che aggiornano i propri pendenti con la nuova barra, in gruppi di 3-4 ordini. A parita di ora, il trial FTMO mostrava **1.347 ordini (1.337 annullati)** alle 08:32: circa **80 volte di piu**. Gli stessi livelli di prezzo compaiono su entrambi (buy stop 4.201-4.203, sell stop 3.869-3.870): sul demo BCM un pendente vive circa un'ora, sul trial veniva cancellato entro un secondo. Questo e il riferimento per la prova del Guardian: in funzionamento normale gli EA producono **qualche ordine all'ora**, non centinaia.
