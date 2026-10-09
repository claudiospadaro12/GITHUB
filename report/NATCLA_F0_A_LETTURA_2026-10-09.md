# NATCLA F0 - lotto A (11 simboli forex) - 08/10/2026 16:24-17:01

Fonte: `backtest_pipeline/risultati_archivio/NATCLA_F0_A_20261009/NATCLA_F0_A.zip` (SHA256 6829a122...; PC di backtest, BCM demo, pin e2f0506b, **EA v1.04**, compilazione 0/0, 37 minuti, media 33 s a passata). Lettore `leggi_natcla_f0.py` (stesso del lotto C). Tabella completa: lanciare il lettore sullo zip. Modello 1 OHLC M1, InpSoloConta: **nessun ordine, nessun PF, nessun DD, nessun merito.**
Simboli: EURUSD, GBPUSD, AUDUSD, NZDUSD, USDCAD, USDCHF, USDJPY, EURGBP, EURNZD, GBPJPY, GBPAUD.

## Esito
- **66 passate: 66 OK, 0 KO, 0 non lanciate.** VERIFICA ADX **MetaQuotes su tutte e 66**. AVVIO v1.04 x 66 (per il forex vale: il rimedio v1.05 serve solo dove la v1.04 restava bloccata, cioe' gli indici).
- Tempo: mediana 33 s, media 33 s, min 28, max 58 -> la stima del pilota (28-40 s) **tiene anche su H4/H12/D1** (non misurato prima). F0 intera (216 passate) = **2,0 ore**.
- Finestra: **1,99 anni** (dalla barra della VERIFICA ADX, luglio 2024, al 30/06/2026) = **un solo regime**, non misurato come regime. Proxy prezzo della linea: EURNZD +14,0%, USDCHF -10,0%, NZDUSD -7,4%, EURUSD +5,3%, gli altri fra +0,3% e +4,3%.

## Setup per famiglia (n = setup; soglia E3 = 300)
| famiglia | simboli | setup | E3 | simboli con >= 70 |
|---|---:|---:|---|---|
| AUDIO_H1 | 11 | 5.089 | SOPRA | **11 su 11 (E0: tutti VIVI)**, 434-485 ciascuno |
| AUDIO_H4 | 11 | 1.225 | SOPRA | 11 su 11 |
| AUDIO_H12 | 11 | 461 | SOPRA | 0 su 11 (28-52 per simbolo) |
| AUDIO_D1 | 11 | 252 | **SOTTO: merito SOSPESO per n** | 0 su 11 (17-29) |
| M2_H1 | 11 | 4.334 | SOPRA | 11 su 11 |
| M2_H4 | 11 | 1.082 | SOPRA | 11 su 11 (71-137) |
Frequenza AUDIO_H1: ~218-244 setup/anno per simbolo (circa 1 al giorno di borsa per simbolo). Forex AUDIO_H4: 49-67/anno; D1: 9-15/anno.
Linee AUDIO_H1: ST25 ~230, ST30 ~180, **ST35 solo ~50 per simbolo** (la linea piu' lontana dalla EMA e' anche la piu' rara). In M2 tutti i setup sono sulla linea EMA200.

## Costo (stop >= 40 x pedaggio; geometria AUDIO letterale, commissione DERIVATA 0,004% del prezzo)
- **Con commissione quasi tutti i simboli "puliti" stanno nella fascia FRA (13,3-40x)**; senza commissione molti passano (colonna `senza` del lettore: es. AUDUSD, EURGBP, GBPUSD, NZDUSD, USDJPY su H1/H4/M2), ma USDCHF resta FRA anche senza e EURUSD/USDCAD/USDCHF su H12-D1 pure. La commissione e' DERIVATA (0,004% del prezzo), non misurata: il verdetto dipende da quel numero. Non e' un'esclusione.
- **ESCLUSO PER COSTO anche senza commissione**: **EURNZD su tutte le 6 configurazioni**; GBPAUD su H12, D1, M2_H4; GBPJPY su D1.
- **ESCLUSO PER COSTO solo con la commissione**: GBPAUD (H1, H4, M2_H1), GBPJPY (H1, H4, H12, M2_H1, M2_H4), USDCAD su D1.
- Lotto B (11 altri forex, letto oggi per la prima volta con lo stesso lettore): CHFJPY e GBPNZD esclusi per costo in tutte le configurazioni H1-H12-M2; D1 esclusa quasi ovunque. Dettaglio: lanciare il lettore su `NATCLA_F0_B_20261007/NATCLA_F0_B.zip`.
- 🔴 Limite: tutto questo vale per la geometria AUDIO letterale. La regola di stop di Claudio ("20 unita' oltre EMA200/ST3.5") **non e' ancora nel codice**: con stop piu' lontani i rapporti salgono e la classificazione puo' cambiare. **[NON MISURATO]** per il forex; sugli indici resta ~10-12x (lotto C).

## Controlli e incoerenze
- Spread del tester (VARIABILE da barra M1): mediana 0,1-0,2 pip sui maggiori (EURUSD, GBPUSD, USDJPY coerenti con lo spread vivo, rapporto 0,50-0,67); **gli altri 8 simboli non hanno spread vivo** (primo numero).
- **Il lettore segnala 990 righe-ordine con stop_ped fuori tolleranza.** Verificato a mano (contro-esempio): non e' un'incoerenza dell'EA. Lo spread nel CSV e' arrotondato a 1 punto (es. 0,00006) mentre l'EA calcola stop_ped con lo spread vero; ricalcolando per tutte le righe-ordine (senza il filtro sul tocco) escono 1.459 righe fuori tolleranza stretta, e **0 fuori dalla tolleranza dovuta all'arrotondamento a mezzo punto**. Nel lotto C dava 0 perche' gli indici hanno spread grandi. La tolleranza del lettore (0,06 + 0,2%) e' troppo stretta per il forex con spread da 0,1 pip; conseguenza sui numeri di costo: errore massimo ~+/-8% su AUDUSD, e piu' sui maggiori con spread 0,1 pip (EURUSD: ordine di 150 contro 149). **I verdetti PASSA/FRA/ESCLUSO** sul bordo (rapporto vicino a 40 o a 13,3) vanno letti con questa incertezza.
- Orologio BCM sul forex (H4/H12/D1): setup prima del cambio ~25%, dopo ~72% (finestra 0,48 anni prima, 1,40 dopo): il campione "prima" e' corto.
- Determinismo: nessuna passata del lotto A si ripete in altri lotti con la stessa v1.04; non verificato qui.
- XAUUSD E0 vs feed esterno: non nel lotto A (e' nel C).

## Cosa dice e cosa NON dice
- Dice: il motore **conta setup in abbondanza su tutti gli 11 forex** a H1, H4 e in M2 (H12 e D1 per simbolo sono sotto 70); ADX MetaQuotes confermato su 66/66; i tempi di macchina sono noti (F0 = ~2 h).
- Non dice niente sul merito (nessun PF, DD): il Modello 1 puo' solo bocciare. Il forex non e' boccato; EURNZD lo e' per costo.
- Mappa NatCla dopo A, B, C, D: forex e oro hanno setup in abbondanza a H1/H4; H12 e D1 sono sotto soglia per simbolo (D1 anche in famiglia); gli indici sono esclusi per costo con la geometria letterale.

## Aperto
1. Regola di stop di Claudio (20 u oltre la linea) nel codice (v1.06, piano B in `NATCLA_PIANO_B_V106_2026-10-08.md`) -> poi riclassificare il costo.
2. Periodo ATR e simboli: domande ancora aperte a Claudio (`data/natcla/LEGGIMI.md`).
3. Tolleranza del lettore sul forex: da allargare (modifica allo script, serve il cancello) o dichiarare come limite.
4. Un solo regime (luglio 2024-giugno 2026): la prova di regime resta da fare prima di qualunque merito.
5. Letture indipendenti: questa nota non e' ancora passata dal lettore indipendente.
