# Pilota oro: risultati della griglia da 625 passaggi (16/11/2026): un altopiano piatto, e un dato da verificare prima di tutto

**Fonte:** `UBS_PILOTA_ORO_dati/G_ORO_griglia_625_ReportOptimizer_2026-11-16.xml` (esportato da Claudio dal MT5 portable; intestazione: `Ultimate_Breakout_EA_WSC_V9.5 XAUUSD,Daily 2013.01.01-2022.12.31`, BCMMarkets-Server, 100.000 EUR, creato alle 06:45 ora italiana del 16/11). Criteri e previsioni scritti prima: `UBS_PILOTA_ORO_OTTIMIZZAZIONE_CRITERI_2026-11-15.md` (sezioni 4-13). Analisi: `UBS_PILOTA_ORO_dati/analisi_oro.py`. Avvio 23:09 del 15/11, quindi **durata massima 7 h 36 min** (MT5 stimava 8 h 12 min). **Nessun uso di OOS, tick o hold-out in questo passo.**

## Cosa c'e nel file
- **625 passaggi su 625, tutti diversi** (5 x 5 x 5 x 5), tutti con valori nei range scritti (MinDist 350-750, Scadenza 96-480, Stop 300-900, Limit 900-2500). Colonne: Result (Custom), Profit, Expected Payoff, PF, Recovery factor, Sharpe, Equity DD %, Trades.
- **C0 (550 / 480 / 600 / 1700) = passaggio 322**: profitto +1.323,40 EUR, 286 operazioni, PF 1,65, recovery 6,53, DD equity 0,20%.

## Il risultato: un altopiano piatto
| | minimo | mediana | massimo |
|---|---|---|---|
| Profitto (EUR, 0,1 lotti, 10 anni) | 865,62 | 1.232 | 1.449 |
| Profit factor | 1,42 | 1,60 | 1,71 |
| Operazioni | 267 | 284 | 294 |
| DD equity % | 0,19 | 0,21 | 0,25 |
| Profitto / DD (Calmar a 10 anni) | 3,7 | 5,8 | 7,3 |
- **Tutti i 625 passaggi sono positivi e superano ogni filtro** (PF >= 1,30, operazioni >= 150, recovery >= 1,5): **625 su 625 passano la selezione grezza e 625 su 625 sono "centri di zona stabile"**. La regola della sezione 5 non discrimina: non c'e un punto isolato da scartare perche TUTTO e uguale. Solo 400 profili (profitto, operazioni) distinti su 625.
- **Il miglior passaggio per Calmar (365: MinDist 350, Scadenza 384, Stop 900, Limit 1700) vale 7,30 contro 6,61 di C0 (+10,4%)**: profitto +1.426 contro +1.323 (+7,8%), PF 1,69 contro 1,65. **C0 e solo 99-esimo su 625 per Calmar.** Differenze di questo ordine sono dentro il rumore di scelta: con 625 tentativi e naturale che il massimo superi il centro del 10%. Non e un miglioramento dimostrato.
- **Effetto dei parametri (media su tutta la griglia):** la distanza minima dal massimo/minimo piu bassa (350) da il Calmar medio piu alto (6,38 contro 5,24 a 750); la scadenza non conta oltre 192 ore (risultati identici a 192, 288, 384); lo stop 300 e il limit 900 sono i valori peggiori (Calmar 5,1-5,2). Niente di drammatico: il campo di variazione e +-25% sul profitto.
- **Conseguenza per l'obiettivo "strategie diverse da Wim":** i 625 set fanno quasi gli stessi 286-294 scambi: sono la STESSA strategia con parametri ritoccati (livello 1 del piano). Correlazione col set di Wim **NON MISURATA** (non ho le liste degli affari), ma e quasi certamente vicina a 1. **Questo filone non puo dare una strategia diversa.** Da solo, serve solo se FTMO considera "diverso" un set con parametri diversi (risposta in attesa).
- **Rendimento in assoluto:** C0 a 0,1 lotti = +0,13% l'anno con DD 0,20%. Per un DD dell'1-2% servirebbero 5-10 volte il lotto (rendimento 0,7-1,3% l'anno): la famiglia ha un rapporto rendimento/DD di circa 0,65 annuo, **lontano da un motore per superare una challenge**.

## ANOMALIA da verificare prima di qualsiasi convalida (V0)
**Il C0 della griglia (2013-2022) rende +1.323 con 286 operazioni e PF 1,65; il nostro test U5 (pipeline del terminale principale, stesso GTP E V9.0 con candela ON, lotto fisso 0,1, 100.000 EUR, Modello 1) dava per 2013-2018 +2.242 con 153 operazioni e PF 1,92, e per 2019-2025 +3.873 con 169 operazioni e PF 2,64.** Gia il solo 2013-2018 vale piu dell'intera griglia su 10 anni; le operazioni del 2013-2022 sono 286 contro circa 250 attese. **Cosa non so:** se (a) il set non e caricato negli stessi valori (nell'ottimizzazione da ini i parametri non ottimizzati potrebbero essere quelli di default dell'EA, non del GTP E), (b) il periodo del grafico (D1) o altri ingressi differiscono dai test U5, oppure (c) il confronto e solo sfortunato. **Non lo scarto e non lo accetto:** la regola V0 della sezione 6 impone la riproduzione.
**Verifica V0 (4 passate singole, circa 2 minuti ciascuna):** A) `OPT2_ORO.set` 2013-2022 (deve dare +1.323,40 / 286 / PF 1,65 se il percorso e identico alla griglia); B) GTP E originale 2013-2022 (se B != A, il set viene caricato diversamente); C) GTP E originale 2013-2018 (attesi 153 / +2.242 / PF 1,92); D) GTP E originale 2019-2025 (attesi 169 / +3.873 / PF 2,64). Se C e D riproducono U5 e A differisce, l'ottimizzazione e invalida (set caricato male) e la griglia va rifatta dopo la correzione.

## Previsioni: esito
- **G-1** storico dal 2013 (qualita >= 98%): l'ottimizzazione e partita senza errori su 625 passaggi con 267-294 operazioni; la qualita storica esatta si legge dai report V0.
- **G-3** (>= 100 passaggi/ora): **FALSA**: circa 82 all'ora (625 in al massimo 7 h 36 min). **G-4** (entro 14 ore): **VERA** (circa 7 ore).
- **G-5** (>= 5 passaggi superano la selezione grezza): **VERA** (625). **G-6** (>= 1 centro di zona stabile): **VERA**, ma banale: tutti. La mia nota "con la griglia i vicini misurano la stabilita" e confermata nel senso opposto a quello che speravo: **l'altopiano e cosi piatto che la stabilita non seleziona niente.**
- **G-7 ... G-11:** non ancora valutabili (servono V0-V4).
- **Bilancio:** ho sottostimato la piattezza: avevo previsto una "zona" da trovare, il risultato e un'intera griglia quasi uguale.

## Se V0 e positiva: candidati (regole sezione 5, con un chiarimento scritto ORA, dopo aver visto che i primi 10 per Calmar sono quasi doppioni)
La selezione grezza ammette tutti i 625: **candidati = i 10 migliori per Calmar fra le COMBINAZIONI DISTINTE SENZA SCADENZA** (la scadenza non cambia i risultati sopra 192 ore: prendo il passaggio con la scadenza di Calmar migliore), piu C0. E una regola di semplificazione che non guarda OOS ne tick. Elenco: pass 365, 615, 490, 315, 565, 440, 356, 240, 606, 481 (tutti MinDist 350-450, Stop 600-900, Limit 1300-2500), cioe 10 vicini che fanno quasi la stessa cosa: **il test fuori campione dira se un qualunque ritocco batte C0 di piu del 10% (V1); la mia aspettativa e di no (G-7: 25%, G-10: 75% che il rapporto in OOS scenda sotto il 60% di quello in IS).**

## Cosa NON sappiamo
La causa della differenza con U5 (sopra); se i 625 passaggi usano davvero tutti gli input del GTP E; il rapporto tra le candele D1 BCM e FTMO (vedi sezione 13 dei criteri); la correlazione dei 625 set con il C0; la qualita storica esatta di XAUUSD 2013-2022 nel portable.
