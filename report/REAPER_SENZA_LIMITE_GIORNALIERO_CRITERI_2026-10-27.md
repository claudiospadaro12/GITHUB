# Gold Reaper senza il limite giornaliero interno: CRITERI e PREVISIONI (27/10/2026, scritti PRIMA dei numeri)
**Natura: CRITERI. Non controllata da agenti.** Richiesta di Claudio (27/10): la riga del Reaper senza il limite giornaliero (passo 2 corretto del controllo indipendente di Massimo).

## Perche
Il giro del 27/10 con `MaxAllowedDD=0` e `PropFirmMaxDailyDD=0` non misurava la protezione: con `MaxAllowedDD=0` il lotto cadde a 0,01 su tutte le 791 operazioni (stesse operazioni di prima, 1.582 deal identici). Il venditore scrive che MaxAllowedDD decide il lotto dal DD storico. Quindi qui **MaxAllowedDD resta 9** e si cambia UN solo input: `PropFirmMaxDailyDD` da 4 a 0 (limite giornaliero spento). Dalla pagina del Gold Trade Pro e del Phantom il limite giornaliero e descritto cosi: se la perdita del giorno lo raggiunge, l'EA chiude tutto e aspetta il giorno dopo.

## Passate (riga `RIGA_LANCIA_REAPER_SENZA_LIMITE_80K.txt`, script ANNO80K v5, pin 3e43646d)
4 passate, 80.000 EUR, XAUUSD H1: 2013 ribasso, 2018 laterale, 2020 rialzo a Modello 1 (pochi minuti ciascuna), poi 21 mesi (01/01/2025-01/10/2026) a tick reali (circa 3 ore; a limite acceso 10.835 s). Input imposti: `TradeFrequency=2`, `MaxAllowedDD=9.0`, `PropFirmMaxDailyDD=0.0`, `OnlyUp=false`. Riferimenti col limite a 4: 21 mesi `GR80K_20261020` (+59.796, PF 2,89, DD equity 3.854, 791 operazioni, nessun giorno >= 3% realizzato); tre anni `ANNO80K_TRE_EA_ZIP_1444` (2013 +21.757, giorno peggiore -4,6%; 2018 +13.535; 2020 +20.388).

## Lettura (strumento `confronta_reaper_limite.py`, congelato con autotest)
Per ogni corsa: numero di operazioni diverse rispetto al riferimento (istante, direzione e volume dei deal), netto, PF, DD equity, stop out, giorni con perdita realizzata >= 3% / 4% / 5%, peggior giorno. **Se le operazioni sono identiche il limite non ha mai agito** (con i lotti veri del set di Claudio, in quella finestra). Se differiscono, si riporta la prima differenza e si legge il giorno.

## Criteri (come scritti per le protezioni spente, soglie non toccate)
Netto > 0; DD equity <= 8.000 EUR (10% di 80.000); nessun giorno con perdita realizzata >= 5%; si riportano i giorni >= 3% e >= 4%. La soglia di Massimo (-4% sull'equita) si legge dopo, con l'export M1 gia fatto (21 mesi e 2013), con `leggi_equita_reaper_goldbot.py` sulla nuova corsa.

## Previsioni dichiarate ORA
- J1: le 791 operazioni dei 21 mesi sono identiche a quelle col limite acceso (0 differenze): 75%.
- J2: il netto dei 21 mesi sta entro +-1% di +59.796: 75% (coerente con J1).
- J3: nel 2013 la corsa differisce dal riferimento (il giorno a -4,6%, sopra il 4%, e il candidato a far scattare il limite): 40%.
- J4: nei 2018 e 2020 le operazioni sono identiche: 85%.
- J5: nessuna delle 4 corse ha un giorno >= 5% realizzato: 80%.
- J6: DD equity dei 21 mesi <= 8.000: 90%.

## Cosa NON dice
Un percorso per anno; 2013-2020 a Modello 1; il limite agisce su tick e le corse a tick reali sono solo i 21 mesi; AutoGMT con offset 2/3 contro un server BCM diverso (l'orologio del limite giornaliero e quello del server: NON verificato); MaxAllowedDD come limite (non come lotto) non e separabile nel tester. Nessun giudizio su acquisto, lotto o taglia.
