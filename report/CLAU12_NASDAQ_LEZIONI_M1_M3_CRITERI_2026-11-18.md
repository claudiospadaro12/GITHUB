# Moduli delle lezioni ABTG sul Nasdaq (M1 stop sull'H1 prima dell'apertura USA, M3 breakout dell'apertura con candela di conferma): criteri e previsioni scritti PRIMA dei numeri (18/11/2026)

**Natura:** simulatore Python su M1 NASUSD storico ESTERNO (2015-2019 ricevuto, 2020-2024 ancora sul PC di Claudio), nessun ordine, nessun giudizio su lotti. Scelta di Claudio: "c". Filtro come per orari fissi/fade: eventuale esito positivo va confermato su BCM (cancello D: operazioni +-15%, PF +-20%, profitto +-25%).
**Perche e un test diverso:** logica d'apertura (ordini stop/breakout dell'apertura USA), strumento diverso dall'oro: candidato a essere scorrelato dal breakout D1 di Wim.

## 1. Dati e fuso (verificato sui dati, non assunto)
Diagnostica 2015-2019: il picco di ampiezza M1 e a **09:30 in tutto l'anno**; le riaperture sono alle 18:00. I file sono quindi in **ora di New York con ora legale USA**: apertura cash 09:30, chiusura cash 16:00, nessuna correzione estate/inverno necessaria. Spread = 0 nel file: il costo e un valore fisso (punti indice).

## 2. Moduli (regole fissate, nessuna modifica dopo i numeri)
- **Comune:** una sola operazione al giorno per modulo (lun-ven), nessuna riapertura dopo lo stop, uscita forzata alle 16:00 NY (apertura barra). Se SL e TP cadono nella stessa barra M1: SL (caso peggiore). Fill di stop e uscite al livello dell'ordine (come MT5, gap_fill=False). **Costo fisso 2,0 punti indice per operazione** (andata e ritorno); risultati in punti netti. Si scarta il giorno se il rischio R < 8 punti.
- **M1:** livelli = massimo/minimo dei 60 minuti 08:30-09:30 NY. Alle 09:30 ordini buy stop sul massimo +buf e sell stop sul minimo -buf (OCO: al primo fill l'altro si cancella). SL = livello opposto, TP = rr x R, scadenza degli ordini a 09:30 + E minuti. **Griglia: buf {0; 10% del range} x rr {1; 1,5; 2} x E {120; 390} = 12 set.**
- **M3:** range di apertura = massimo/minimo 09:30 -> 09:30+OR minuti. Dopo, si guardano le candele **M5** (allineate alle 09:30): la prima che CHIUDE sopra il massimo (sotto il minimo) del range e la conferma; entrata all'apertura della barra successiva (verso del breakout), solo fino alle 11:30. SL = livello opposto del range oppure meta range, TP = rr x R. **Griglia: OR {15; 30} x SL {opposto; meta} x rr {1; 2} = 8 set.**
- **Non testati in questa fase** (gestione O3/O4 delle lezioni: parziale 50% a 1R, stop in pari, trailing ATR): si aggiungono solo se un modulo passa le porte. M2 (box notturno DAX) richiede D30EUR: non in questo test.
- **Contatore looks famiglia: 20.**

## 3. Porte (nessuna ritoccata)
- **Selezione 2015-2017:** netto > 0, PF netto >= 1,20, t >= 2,0, operazioni >= 100, almeno 2 anni su 3 in profitto. **Massimo 3 candidati** (t piu alto).
- **Validazione 2018-2020 (richiede i file 2020):** per ogni candidato netto > 0, PF >= 1,20, t >= 2,0, operazioni >= 100, almeno 2 anni su 3 positivi. Si chiedono gli zip 2020-2024 SOLO se c'e almeno un candidato.
- **Poi (solo finalisti):** vicini, meta periodo, OOS 2021-2022 e 2023-2024 (PF >= 1,20 e profitto > 0 in entrambi, WFE >= 0,5), conferma su BCM (cancello D). **2025-2026 non si apre.**
- Nessun candidato o nessun finalista = famiglia chiusa, regole invariate.

## 4. Previsioni (scritte ora)
- >= 1 set passa la selezione: **35%**; >= 1 candidato passa la validazione: **10%**; nessun finalista: **90%**; finalista che supera anche l'OOS 2021-24: **4%**.
- Il modulo M1 (stop prima dell'apertura) ha piu probabilita di M3 di passare la selezione (60/40 sul totale delle probabilita).
