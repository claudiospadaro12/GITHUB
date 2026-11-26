# ABTG_PunteLarry (A1) - scheda
Sorgente: `materiali_ea/ABTG_PunteLarry.mq5` (1214 righe, v1.00). FV = FATTO_VERIFICATO, INF = INFERENZA, DV = DA_VERIFICARE.

## Identita' con la versione misurata (FV)
Il file differisce da `mql5/Experts/ABTG_PunteLarry_F1.mq5` solo per la riga di include (r.123; diff di testo, 4 righe). I risultati F1 valgono quindi per questo codice: la dicitura "versione PC" della matrice non cambia la logica.

## Misure esistenti (FV, `report/`)
Oro, default, rischio 1%, Modello 1: 2005-14 71 op, PF 1,43, t 0,86; 2015-23 56 op, PF 1,66, t 1,21 (2017 pesa il 54%); 2024-26 41 op, PF 1,28, t 0,57 (2026 pesa il 72%); tick reali 2024-08/2026-10 39 op, PF 1,44 contro 1,50 su M1. Z combinato circa 1,5, p circa 0,06 (`FAMIGLIA1_ORO_CRITERI` r.25, `PUNTELARRY_ORO_2024_26_CRITERI`, `PUNTELARRY_ORO_TICK_CRITERI` r.13-17). EURUSD 0/3 finestre (PF 1,08/0,74/0,96; bonus 2010-17 PF 1,34), modalita' 1 e 2 non confermate (`PUNTELARRY_EURUSD_CRITERI`, `COSA_ABBIAMO_DAVVERO` r.11).

## Regole (modo 0, default; FV)
- Pattern su D1, esecuzione scandita da H1 (r.142, 353-357). Alla prima barra della nuova giornata (r.365): SMASH "libro": ieri ha chiuso sotto il minimo di due giorni fa = setup LONG, sopra il massimo = SHORT (r.497-511).
- BUY STOP sul massimo di ieri (SELL STOP sul minimo) con scadenza a fine giornata (r.501, 505-510, 696-702). SL oltre l'estremo opposto di ieri + 0,1 ATR(D1) (r.650, 153). Nessun TP: uscita "first profitable open" alla prima apertura D1 successiva se P/L+swap > 0 (r.835-864), altrimenti SL o time-stop 5 barre D1 (r.162, 871-892). Rischio 1% (r.173, 1008-1038). Magic 772301, commento "LARRY L/S" (r.176-177, 704).

## Controlli R2
| Controllo | Esito |
|---|---|
| Barra in formazione per decidere | NO per i modi 0/1 (D1 shift 1 e 2, r.416-420). Modo 2 usa open D1 shift 0 (r.415, noto a inizio giornata) e massimo/minimo di oggi per lo SL (r.643-647, 784-785): causale; ATR cade su barra 0 se shift 1 nullo (r.958) |
| Orari in input vs DST | NO: nessun input di ora. Ma il confine D1 e' la mezzanotte del server BCM (GMT+1 fisso = 23:00 UTC): relativo alla pausa/ripresa dell'oro slitta di un'ora tra estate e inverno (INF, DV con M1) |
| Distanze in punti fissi | NO per le distanze (ATR D1, r.640, 653); fissi: deviazione 30 punti (r.278), soglia spread in points (r.169) |
| Nuova barra | SI (r.353-355, 365; retry spread r.387-389) |
| Stop minimo | SI: max(stops level, spread) (r.982-987) usato in r.611-620, 656, 677 |
| Spread nel filtro | presente ma spento (default 0, r.169, 578): i risultati M1 non vedono il costo di piazzamento |
| Ordine rifiutato | log, giornata consumata, nessun retry (r.715-717) |
| Dati futuri | NO |

## Difetti
1. Falsa i test (media): confine D1 = server. Su FTMO (server IT+1 con DST) il D1 taglia a un'ora diversa: PF e frequenza BCM non si trasferiscono. Prima del forward su prova prop: replica per feed (INF).
2. Falsa i test (minore): first profitable open valuta P/L al primo tick del D1, il momento di spread piu' largo (INF); commissioni escluse (r.851-855); in tester a barre lo spread e' quello di barra.
3. Falsa i test (minore): filtro spread spento (r.169): solo run a tick lo verificano (rapporto 0,96, ok su 39 op.).
4. Minore: lotto riportato al minimo (r.1037); dopo riavvio un pendente preesistente non e' tracciato (r.293-303) e viene cancellato al cambio giorno (r.898-916); metrica "peggior giornata" non coincide col giorno della prop (r.333-342); scarto sistematico dei giorni in gap (livello non piazzabile, r.611-620): selezione, non errore.

## Misurabilita'
Oro D1 da M1 BCM 2004-2026 gia' coperto, tick dal 07/2024. Seconda fonte indipendente nel feed: oro FTMO 2021-26 (scartare riga 00:00 con tickvol > 2000; feed FTMO nel tester rotto: Python o simulatore). Argento FTMO dal 2008 (CLAUDE.md): secondo metallo, prima del forex. Frequenza ~7-15 op/anno: il vincolo e' il campione, non il codice. Correlazione con GoldenZoe da misurare (soglia 0,5).

## Ipotesi (criteri prima dei numeri; contatore: ogni cella e' uno sguardo)
- H1: argento (XAUUSD sostituito da XAGUSD, default): PF >= 1,20 e rendimento > 0 in >= 2 finestre su 3, nessuna sotto -5%, >= 8 op per finestra (porte EURUSD). Probabilita' 25%.
- H2: replica su oro FTMO 2021-26 con confine D1 diverso: PF >= 1,20 e segno concorde con BCM nello stesso periodo. 40%.
- H3: filtro spread acceso a tick (soglia dal 95o percentile dello spread alle 00:00-01:00 server, non dal PnL): operazioni -10% al massimo, PF >= 1,20 su 2024-08/2026-10. 60%.

## Classe: A
Difetti "falsa i test" risolvibili senza toccare la logica: spread a tick, commissione nel P/L, replica per feed. E' l'unico indizio nostro sull'oro ma resta indizio: non promuove da solo.
