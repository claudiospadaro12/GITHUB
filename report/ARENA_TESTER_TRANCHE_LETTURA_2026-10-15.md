# Arena nel nostro Strategy Tester -- LETTURA delle tre tranche (15/10/2026)

Zip `ARENA_TESTER_TRANCHE.zip` (giro v2, pin `5c5d7dc0`, PC di backtest DESKTOP-H4D7CAJ, partito 15/10 08:24, REFERTO 16:11). Archivio: `backtest_pipeline/risultati_archivio/ARENA_TESTER_TRANCHE_20261015/` (uscita completa del lettore in `LETTURA_USCITA.txt`). Letto con `leggi_arena_tranche.py`; ipotesi H1-H4 e regole "quando non si decide" scritte PRIMA dei numeri in `ARENA_TESTER_TRANCHE_SCHEDA_2026-10-14.md`.

## 1. Provenienza e conformita'
- Marcatore v2, pin passato dal cancello, `.ex5` UGUALE dopo ognuna (SHA `B261E252...`), data 15/10: provenienza OK [MISURATO].
- **Una sola tranche su tre e' conforme: TRANCHE2 (agosto).** TRANCHE1 e TRANCHE3 non hanno scritto il report (deposito 0, leva 1:0, periodo 1970): NON CONFORMI, numeri solo descrittivi.

## 2. Perche' due tranche non hanno il report [MISURATO sui giornali; CORRETTO il 15/10 sera]
🔴 **Correzione.** La prima stesura di questa sezione diceva «19 minuti per giorno simulato» e «un mese costa 9-10 ore»: era SBAGLIATA, nata dividendo per l'orologio da parete. I giornali hanno buchi di sospensione del PC.
- **TRANCHE1 (luglio): il PC e' rimasto fermo 153 minuti** (nessuna riga fra 10:34 e 13:07; `AutoTesting processing 47 %` alle 10:29:58, poi di nuovo 47 % alle 13:07:02; prima c'era gia' un buco di 64 minuti, 09:28-10:33). Il timeout di 270 minuti, a orologio da parete, e' scaduto mentre il PC dormiva (tester al 15/07 ore 20:00 simulate). Questo spiega «timeout» e «report non scritto».
- **TRANCHE3 (settembre): buco di 90 minuti** (14:41-16:11), poi `prepare for shutdown`, `tester forced to close`, `some error after pass finished`, nessun report. NON era un timeout (160 < 270): e' il risveglio dalla sospensione [MISURATO come buco nei timestamp; che fosse sospensione e non altro resta la lettura piu' semplice, non una prova di causa].
- **Velocita' vera, tolti i buchi:** luglio 14,8 giorni simulati in 129 minuti, settembre 7,9 giorni in 69 minuti, circa **9 minuti per giorno** → un mese circa **4-5 ore** [ESTRAPOLATO, il 28/09 con il cesto profondo non e' stato raggiunto]. La stima della riga («170 minuti a mese») era comunque troppo bassa, di circa 1,5-2 volte, ma la causa dei due fallimenti NON e' la lentezza.
- TRANCHE2 e' finita in 23 minuti perche' il conto e' morto per stop out il 5/08.
- Segnale ulteriore nei giornali: migliaia di `BUY/SELL blocked: current margin level too low` e di `modify failed ... close to market` (retcode 10029) dal primo giorno in tutte e tre le tranche: il margine dell'oro nel tester (10.000 USD a lotto [DERIVATO]) tiene l'EA in blocco.

## 3. TRANCHE2 (agosto 2026) -- l'unica conforme
- XAUUSD M1, ticks reali 100%, deposito 5.000 EUR, leva 1:100 (stampata), input imposti confermati dal report, enum al default 0/0.
- 1.481 operazioni, **netto -3.063,29 EUR, PF 0,47, DD equita' 4.072,45 EUR (67,8%)**, saldo finale 1.936,71 EUR.
- **STOP OUT il 05/08 alle 12:59 (49,64%)**: da qui il conto del tester e' morto, i giorni dopo non misurano l'EA: la "tranche" misura **3 giorni**.
- Per giorno (netto realizzato): 03/08 **+429,70**, 04/08 **+545,15**, 05/08 **-4.038,14** (ingressi 74; picco lotti vivi 0,48).
- Cesti di recupero [R]: 266, netto -3.088,44; profondita' 1: 144 cesti +114,80; 2: 56 +68,06; 3-4: 44 +303,84; 5-9: 18 +388,34; **>=10 livelli: 4 cesti, -3.963,48 EUR (128,3% del netto [R])**, profondita' massima 19, peggior cesto -4.086,37. Netti per cesto APPROSSIMATI (quota incerta 19 su 266).
- Modulo [F]: CF -8,98 (PF 0,98), FinlabX +34,13 (PF 1,44).

## 4. Le ipotesi, secondo le regole scritte prima
- **H1 (stop out in almeno una tranche): REGGE** -- stop out in una tranche conforme (TRANCHE2). La sua smentita ("nessuno stop out in nessuna") non e' decidibile con una tranche sola, ma qui la smentita non serve: l'evento c'e'.
- **H2 (somma dei cesti >=10 livelli negativa in OGNI tranche conforme): REGGE sull'unica tranche conforme** (-3.963,48), con n = 4 cesti approssimati. Una tranche non e' "ogni tranche".
- **H3 (cesti >=10 in almeno due tranche su tre): NON SI DECIDE** (una sola tranche conforme, e ce l'ha; le altre due sono quelle che servono).
- **H4 (le tranche senza cesti profondi guadagnano): NON SI DECIDE** (nessuna tranche conforme senza cesti >=10).

## 5. Cosa NON si puo' concludere (e cosa si, con il costo)
- ❌ Il tester ha **margine 10.000 USD a lotto** ([DERIVATO], letto in R114): lo stop out del 5/08 dice "a QUEL margine", **non** "il conto reale BCM ci andrebbe". La perdita flottante si', il margine no. Il margine vero del conto reale sull'oro e' **[NON VISTO]** (resta il controllo n. 2 dato a Claudio).
- ❌ Il 28/09 non e' in nessun report (la TRANCHE3 non e' arrivata oltre l'8/09).
- ✅ Detto questo, il quadro di H1/H2 e' coerente con la demo (cesti >=10 livelli = 24,5% il 13/10 e 50,8% il 14/10 del netto [R]) e con la descrizione del venditore ("Solo Cent/Micro"): a 0,01 lotti su 5.000 EUR in un mese pieno il tester fa **+975 in due giorni e -4.038 nel terzo**.
- Nessuna promozione, nessuna archiviazione: l'EA resta sul demo in osservazione. Nessuna taglia: decisione di Claudio.

## 6. Che cosa manca per chiudere (e la via piu' corta)
1. TRANCHE3 (settembre, contiene il 28/09): circa 4-5 ore SE il PC non va in sospensione. Riga `RIGA_LANCIA_ARENA_TESTER_TRANCHE_LUNGA.txt` (script v4, timeout 840 min, richiesta di veglia a Windows). Luglio resta da fare solo se serve a decidere H3/H4.
2. Ogni cambio di riga o script passa dai due cancelli prima di arrivare a Claudio.
