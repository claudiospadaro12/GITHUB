# ABTG_VwapRevert v1.00 (A2) - sorgente: ABTG_VwapRevert.mq5, 1755 righe
Tag: FV = FATTO_VERIFICATO (file:riga), INF = INFERENZA, DV = DA_VERIFICARE. Nessuna istruzione per l'agente nel sorgente. Le frasi del sorgente su "30 celle su 30" (r.60-62), "voto 8/10" (r.21) e sul porting fedele (r.29, 128) sono dichiarazioni dell'autore del file: non evidenza. Il file dichiara di non essere stato compilato ne' testato (r.128).

## Regole (FV)
- Motore a due barre chiuse: setup [2] e conferma [1] (r.37-47, 809-852). Decide solo a nuova barra (r.695, 704-709).
- Setup: hammer/shooting star o doji (r.494-497, 361-401), tocco dell'estremo delle ultime 20 barre (r.490-491, 826-838), chiusura FUORI banda VWAP +/- 1 sigma (r.487, 349-355). VWAP di sessione = hlc3 pesato col TICK VOLUME, sigma pesata (r.312-340, 774-802).
- Conferma: chiusura nel 30% favorevole, range <= 1,5 ATR(10), engulfing o continuazione (r.499-505). Segnale a fronte: vero ora e falso alla barra prima (r.731-737).
- Ingresso: ordine STOP oltre la barra di conferma con buffer 0,01 ATR, vivo 3 barre (r.901, 973-974, 1016). SL all'estremo opposto della conferma; TP 2R (r.902, 953). Modo pavimento AUTORE: il pavimento 0,2 ATR entra solo in R e nel lotto, non sposta lo stop (r.190, 917-920).
- Uscite: SL/TP, segnale opposto (r.744, 1050-1073), flat 20:45 server acceso di default con cancellazione dei pendenti (r.217-219, 1196-1223). Parziale, trailing, news, venerdi' spenti.
- Una posizione per magic (r.746), tetto 2 ingressi al giorno (r.206, 747). Magic 773400, commento "VWAPREV" (r.240-241).

## Controlli R2
Barra in formazione: NO (shift >= 1: r.777, 887, 1040-1060 non toccano la [0]). Orari/ora legale: SI, difetto (vedi 2). Distanze: scalate su ATR e su range barra (r.188-189, 901-902); l'unico input in punti fissi e' InpSpreadExtraPts, default 0 (r.195). Nuova barra: SI (r.704). Stop minimo: SI sul livello e sullo stop (r.930-939). Spread: filtro a barra nuova, non al riempimento, spento di default (r.242-243, 750, 1333-1337, 942-947). Ordine rifiutato: log, nessun nuovo tentativo (r.984-985). Magic/commento: SI. Dati futuri: NO.

## Difetti
1. FALSA I TEST, alta: la tesi dice "dentro la sessione" (r.30-35) ma il filtro orario e' spento (r.207), la VWAP si ancora alla mezzanotte server (r.172, 764) e le barre minime di sessione sono 0 (r.173). L'EA puo' segnalare alle 00:15 server su 1-3 barre notturne di CFD sottile. Si risolve solo con input (filtro orario, ancoraggio, barre minime): logica invariata.
2. FALSA I TEST, alta: ora server senza ora legale. L'intestazione dice "server un'ora indietro, DAX 09:00 IT = 08:00 server" (r.122-123) e "20 server = 21 italiana" (r.218): vero solo in estate. In inverno il server e' uguale all'ora italiana (CLAUDE.md). Fascia 10-16 (r.208-209), flat 20:45 (r.218-219) e distanza dell'ancoraggio dall'apertura cash cambiano di 1 ora; per il Nasdaq si aggiungono le tre settimane di sfasamento USA/Europa.
3. FALSA I TEST, media: il peso e' il tick volume (r.796). Nei file `_EXT` tickvol=1 e spread=0 (CLAUDE.md): VWAP e sigma diventano medie nel tempo e il costo e' zero. Misura valida solo su dati nativi (BCM D30EUR/NASUSD/U30USD 2024-26) o FTMO (se il tickvol e' vero, DV).
4. media: spread/stop. Lo stop e' il range di una singola barra con anti-candelone (r.500): puo' essere stretto, e in modo AUTORE resta stretto mentre lotto e target usano R piu' largo (r.917-919): il rischio reale e' sotto il dichiarato e il target sopra 2R reali. Nessun filtro spread di default.
5. minore: `VR_MAX_SESSION_BARS` 600 (r.155) tronca la VWAP su M1; M5 e M15 vanno bene. Include `ABTG_PausaGuardian.mqh` (r.136) non presente nei materiali (DV: serve per compilare; nel tester passa tutto, dichiarazione r.140-147 non verificata). Lotto minimo forzato (r.1321). `SetDeviationInPoints(30)` (r.592) non vale per i pendenti.
6. INF: se all'apertura della barra il prezzo ha gia' superato il livello d'ingresso, il segnale e' scartato (r.933-934): sono scartati i casi di spinta piu' forte; il tester li scarta allo stesso modo, quindi coerente.
7. INF: il nome "Revert" inganna: l'ingresso e' una continuazione dopo la candela di rifiuto (BuyStop sopra la conferma), il bersaglio e' 2R, non la VWAP.

## Mediazione / griglia
NO: una posizione per magic (r.746), massimo 2 ingressi al giorno (r.747), niente aggiunte, flat serale. Piu' simile a un reversal a breve che a una griglia.

## Misurabilita'
Solo su indici con tickvol reale: BCM nativo D30EUR/NASUSD/U30USD 2024-26 (circa 2,3 anni), FTMO CSV Nasdaq/S&P dal 12/2017 e Dow dal 2019 (tickvol DV, orari FTMO = IT + 1, non quelli BCM). M15 (M5/M30 secondari). Il numero di segnali e' incognito: quattro condizioni insieme su pochi anni possono dare un campione troppo piccolo (DV, va contato prima).

## Ipotesi (criteri scritti prima; cancelli di campagna come in MeanRevert)
- H1 solo conteggio dei setup, nessun PF: per indice e stagione (estate/inverno separate) accetta di misurare solo se >= 150 operazioni nel pooled e >= 30 per cella. Probabilita' di raggiungere 150 sul 2024-26: 40%.
- H2 baseline con fascia pre-registrata a parita' di ora italiana (conferma 10:00-16:00 IT, cioe' 9-15 server in estate e 10-16 in inverno), VWAP ancorata all'apertura cash, barre minime 4, flat 17:00 IT: accetta se IS PF >= 1,30, V1/OOS >= 1,20, HO > 1,0. Probabilita': 5%.
- H3 controllo nullo: stessa candela di rifiuto + estremo + conferma senza banda VWAP (variante Python, non l'EA). Accetta che la banda abbia valore solo se PF con banda - PF senza >= 0,15 su >= 2 indici. Probabilita': 20%.

## Classe: B (correggere prima di misurare)
Correzioni a logica invariata, solo protocollo e input: filtro orario e ancoraggio per stagione, barre minime, dati nativi con tickvol, conteggio preliminare dei setup. Prima del PF.
