# Ea Nat&Cla - note sul CODICE di `EA_NatCla.mq5` v1.00 (07/10/2026)

**STATO: strato 1 fatto dove possibile, strato 2 (`controllo-preventivo`) DA FARE. NON consegnabile.**
Il file NON e' stato compilato (nessun MetaEditor qui) e NON e' girato nel tester. Nessun backtest lanciato, VPS non toccato.

- Codice: `mql5/Experts/EA_NatCla.mq5` (2048 righe, ASCII puro). Regole SOLO da `report/NATCLA_SPECIFICA_2026-10-07.md`.
- Collaudo: `python3 backtest_pipeline/collaudo_natcla.py` (circa 1 minuto; `--senza-mutanti` circa 16 s). Esito al commit: **TUTTO OK**, mutanti ciechi **21/21 presi**.

## 1. Che cosa il collaudo ha MISURATO (feed HistData dell'oro, orologio +6 h, NON BCM)

| controllo | esito |
|---|---|
| `NC_STCore` == `SW_STCore` della casa (testo) e == `py_stcore` bit per bit, 3 livelli, 21.228 barre H1 | 0 differenze |
| `NC_Episodi` (scansione all'indietro, C++ vero) == macchina a stati in avanti (Python indipendente), 4 linee x 3 configurazioni (base; SFIORA + distacco; placebo 1 ATR) | 0 differenze su ogni barra |
| finestra EA di 1500 barre == serie intera (534 punti, ST 2.5 e 3.5) | 0 differenze, 0 segmenti troncati |
| contro-esempio: finestra di 40 barre | 62/83 differenze: il controllo morde |
| episodi/anno AUDIO H1, 2024-07-10 -> 2026-09-18 | **150,7 / 121,0 / 97,2** (specifica 151 / 121 / 97) |
| entro il limite audio 1/1/2 | **101,4 / 84,9 / 88,1** (specifica 101 / 84 / 88) |
| + ADX **Wilder** <= 20 alla barra del tocco | **40,2 / 35,6 / 35,6** (specifica 37/34/37, ricontato dal cancello 40/36/36) |
| + ADX Wilder alla barra PRIMA (quella in cui la scala si arma) | 37,4 / 34,2 / 37,9 |
| + ADX **iADX di MT5** <= 20 (specchio di ADX.mq5 scritto a memoria, **NON verificato col terminale**) | **16,4 / 17,8 / 15,5** |
| H4 / D1 (informativo, dipendono dall'orologio) | 44/25/26 e 5/5/3 episodi; +ADX Wilder 11/6/10 e 1/0/1 |

## 2. Il punto che pesa: QUALE ADX

La specifica dice **`iADX`** al par. 2.1, ma la frequenza attesa del par. 5.4 ("35-40 setup l'anno per linea") e' contata con
l'**ADX di Wilder**. Le due formule NON danno lo stesso numero: con lo specchio di `iADX` la soglia `<= 20` lascia passare
**meno della meta'** dei setup (16-18 l'anno contro 36-40). Nel codice ho messo l'input `InpAdxTipo` con default **`iADX`**
(lettera della specifica, par. 2.1) e `iADXWilder` come asse. **Da decidere prima del passo 0**: o si cambia il default, o si
corregge l'attesa E0 della specifica. Il numero 16-18 va confermato sul terminale (lo specchio non e' verificato).

## 3. Interpretazioni [NOSTRA] entrate nel codice OLTRE quelle gia' scritte nella specifica

1. **Tocco valido** (C1-C3): oltre a "niente flip sulla barra" serve la chiusura non oltre la linea in vigore. Per i Supertrend e'
   la stessa condizione; per la EMA200 (M2) e per il placebo e' una condizione in piu', dichiarata.
2. **Direzione della EMA200** (M2): +1 se la chiusura sta sopra la EMA, -1 sotto; chiusura uguale = direzione precedente.
3. **ADX mai sulla EMA200**: `TUTTE` = le tre linee Supertrend (nessuna fonte lega l'ADX alla EMA).
4. **Modalita' EMA200** (base M2, par. 3.3): scala AUDIO, inclinazione accesa, ADX spento, nessun limite di tocchi,
   stop sull'ordine profondo, TP dalla linea.
5. **Contesto** misurato alla barra chiusa `last`: per la scala e' la barra PRIMA del riempimento, per il PDF e' la barra del
   tocco. La confluenza si misura sulla linea USATA (spostata dal placebo, se acceso).
6. **Unita' AUTO_CLASSE**: XAU/XAG dal nome -> 1,0; modalita' di calcolo forex -> pip; il resto -> 1,0. Aggiunto
   `NC_UNITA_MANUALE` per l'asse dell'oro a 0,1 USD.
7. **Magic**: `InpMagic=0` -> automatico `7786` + motore + TF (H1/H4/H12/D1); per W1 e altri TF va messo a mano. Fuori dal
   blocco 778600-778699 l'EA non parte. Blocco verificato libero nel repo (collaudo); i **preset vivi sui terminali** restano da
   verificare (non sono nel repo).
8. **Contraddizione interna della specifica su `InpMoltConfluenza`** (par. 2.1 "rifiuta l'avvio" contro S4 "lo tronca"): ho
   seguito il par. 2.1 (rifiuto all'avvio, lato prudente) e tenuto anche il troncamento a runtime come seconda rete.
9. **Scala**: i tre LIMIT sono GTC, cancellati e ripiazzati a ogni barra (il lotto cambia con la distanza dallo stop). Un ordine
   il cui prezzo e' gia' stato superato dal mercato **si scarta** (non diventa un ordine a mercato). **Rischio dichiarato**: se
   l'EA si ferma, i limit restano vivi al prezzo vecchio (con il loro stop). I pendenti PDF hanno la scadenza sul server, se il
   simbolo la accetta, e comunque gestita dall'EA.
10. **Lotti**: calcolati sugli ordini rimasti; un ordine scartato sotto il minimo NON fa ricalcolare gli altri (prudente).
    Tolleranza di arrotondamento 1e-9 step (0,30/0,01 resta 30 step; 0,299999999 lotti restano 0,29).
11. **PDF**: il secondo ordine e' un LIMIT (pseudocodice della specifica; l'analisi PDF dice che il tipo non e' scritto). Se la
    tranche a mercato fallisce, il pendente da solo non parte. Ingresso a mercato solo entro 300 s dall'apertura della barra
    (convenzione `InpGraceSec` di `ABTG_EMA200_Ombra`): dopo un riavvio a meta' barra niente ingresso tardivo.
12. **TP1 raggiunto** (PDF): oltre a parziale e pareggio si cancellano i pendenti residui (nessun riempimento nuovo dopo il
    pareggio). Il pareggio va al prezzo medio ponderato solo se migliora lo stop ed e' lecito rispetto allo stops level.
13. **X10**: la prima uscita di una qualunque posizione del setup (TP o SL) cancella i pendenti residui.
14. **Conti netting rifiutati** (ogni ordine della scala deve restare una posizione con la sua etichetta nel commento).
15. **Riavvio**: le posizioni con etichetta si ADOTTANO; i pendenti senza posizione si cancellano e la scala si riarma dai dati.
    TP1, pareggio e chiave dell'episodio **non sono ricostruibili** dopo un riavvio (scritto a log).
16. **CSV per-setup** (`natcla_setup_<simbolo>_<magic>.csv`, cartella comune) non scritto in ottimizzazione; l'export di casa
    `abtg_trades_...` ha una colonna in piu' IN CODA (`entry_comment`), le prime 8 restano identiche.
17. **Costo**: `InpCommissionePrezzo` (commissione in prezzo, 0 = non contata) e `InpCancelloCostoX=40` solo come AVVISO in log e
    colonna `stop_ped` nel CSV: **non blocca** niente.

## 4. Cosa il cancello deve guardare (strato 2)

- **Semaforo con piu' linee armate** (lettera della specifica, E7/2.2): sulla scala AUDIO le tre linee possono avere limit vivi
  insieme; se due si riempiono nello stesso tick (linee vicine, spike) i setup aperti diventano 2-3, cioe' **fino a 3 R**. Il
  codice lo CONTA (`semaforo sforato`) e lo scrive a log ma **non chiude**. Va deciso se basta.
- **Buco B6** del Guardian: con la scala il rischio vive nei pendenti, che C1 non vede.
- **ADX** (par. 2 qui sopra): default `iADX` contro frequenza contata con Wilder.
- **Compilazione**: la lista delle 69 funzioni MQL5 e dei 13 metodi CTrade con il numero di argomenti e' controllata dal
  collaudo, ma solo MetaEditor puo' dire se compila (tipi, overload, avvisi).
- **Non provato**: riempimenti, cancellazione e riprezzamento nel tester, `OnTradeTransaction`, il Guardian, `iATR`/`iMA`/`iADX`
  del terminale, il calcolo di `OrderCalcProfit`, l'orologio BCM, il modo PDF a mercato (nessun dato di tick qui).
