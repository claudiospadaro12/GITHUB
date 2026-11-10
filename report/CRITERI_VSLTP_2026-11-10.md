# Virtual SL/TP e richieste al server: CRITERI e PREVISIONI (10/11/2026, scritti PRIMA dei numeri)

**Natura: CRITERI, non ancora lanciato.** Nasce dall'avviso di iperattivita di FTMO (10/11, conto trial 1515150476: soglia 2.000 richieste al giorno, comprese le modifiche SL/TP) e dalla nota di Massimo (`Limite_richieste_FTMO_trailing_per_Claudio.pdf`) che propone `EnableVirtualSLTP`. Stima dai giornali del tester in `RICHIESTE_AL_SERVER_STIMA_DAI_TEST_2026-11-10.md`. **Dipende dai dati del VPS di stasera** (`RIGA_CONTA_RICHIESTE_FTMO.txt`): se il picco non e quello previsto, si rivede il test. Solo tester; reale, trial FTMO e VPS non si toccano; nessun lotto ne taglia.

## Domanda
Se si accende `EnableVirtualSLTP=true` nei set oro, (1) **calano le richieste al server** (righe del giornale per giorno, in particolare le modifiche fallite "Market closed" e gli errori di trailing/breakeven) e (2) **a che costo** sul profitto, sul DD e sul peggior giorno?

## Cosa si testa
Le stesse passate del test D160 (`RISULTATI_D160_ORO_2026-11-09.md`), con **un solo input cambiato: `EnableVirtualSLTP=true`** (nel base e `false`; `SetVSL_to_hardSL_sec_delay=99` e gli altri input restano). XAUUSD, BCM, deposito **160.000 EUR** (cosi i riferimenti sono le passate D160 gia fatte), Modello 1, anni **2013, 2020, 2025**, set ufficiali di Wim:
| EA, livello | Passate per anno | Riferimento |
|---|---|---|
| Goldbot One L0 Prop | 1 (deterministico) | D160 R1 |
| Gold Trade Pro Combo | 1 (deterministico) | D160 GTP |
| Phantom L1 Gradino 1 (Randomization 50) | 2 | D160 R1 e R2 |
| Reaper L3 Combo (Randomization 50) | 2 | D160 R1 e R2 |
**18 passate** (3 + 3 + 6 + 6), circa 2-3 minuti ciascuna (stima dai tempi misurati, non garantita). Si lanciano in due righe (oro e Gold Trade Pro), come D160.
**Validita di una passata**: report presente, deposito 160.000, **`EnableVirtualSLTP=true` confermato dal report**, altri input uguali al set, qualita >= 98%, almeno 1 operazione, giornale leggibile.

## Misure
1. **Risultato**: netto, DD equity relativa, operazioni, PF, peggior giorno realizzato.
2. **Richieste (proxy dal giornale del tester, righe per giorno)**: righe totali per anno, giorno piu pieno, giorni con piu di 1.000 / 1.600 / 2.000 righe, e per tipo: `failed modify`, `Market closed`, `TrailStop error`, `error when setting breakeven`, modifiche riuscite.
Il proxy NON e il conteggio di FTMO (il live e a timer, non a barre).

## Regole di lettura (fissate ora)
- **RICHIESTE**: **RIDUCE** se il giorno piu pieno e le righe di tipo `failed modify` + `Market closed` + `TrailStop error` + `breakeven` calano di almeno il **50%** rispetto al base; **RIDUCE POCO** se calano del 20-50%; **NON RIDUCE** sotto il 20%.
- **COSTO** (per EA, sui 3 anni; per Phantom e Reaper si usano le due ripetizioni e il base come banda): **NEUTRO** se il netto medio resta entro **+-10%** del base (entro la banda di rumore per le rumorose: |rapporto - 1| <= max(0,10; il doppio dello scarto fra le due ripetizioni del base)), il DD non sale oltre **1 punto** e il peggior giorno non peggiora oltre **0,5 punti** del conto; **COSTOSO** se il netto cala oltre il 15% o il DD sale di 2 punti o piu; in mezzo ZONA GRIGIA.
- **Verdetto per EA**: **VIRTUAL CONVIENE** se RIDUCE **e** NEUTRO; **VIRTUAL DA SCARTARE** se NON RIDUCE o COSTOSO; altrimenti **DA VALUTARE**.
- Una passata o un anno non decide: si riporta il quadro per EA e anno.

## Previsioni dichiarate ORA (non misurate)
- **V1** 18 passate valide, `EnableVirtualSLTP=true` confermato: 80%.
- **V2** Goldbot: RIDUCE (>= 50%): 55%; NEUTRO sul netto (+-10%): 60%.
- **V3** Phantom L1: RIDUCE: 65%; il giorno piu pieno del 02/06/2025 (1.262 righe nel base) scende sotto 1.000: 55%.
- **V4** Reaper L3: RIDUCE: 55%.
- **V5** Gold Trade Pro: RIDUCE: 50%.
- **V6** Almeno un EA ha il netto che cambia oltre la banda (COSTOSO o ZONA GRIGIA): 40%.
- **V7** Il peggior giorno realizzato peggiora di oltre 0,5 punti in almeno una coppia EA-anno: 25%.
- **V8** Tutti e 4 gli EA VIRTUAL CONVIENE: 25%; almeno 2 su 4: 55%; nessuno: 20%.
- **V9** Le righe del giornale non cambiano affatto (il tester non modella il virtual SL/TP o lo applica alla stessa maniera): 20%.
- **V10** Il numero di operazioni cambia di oltre il 10% in almeno un EA: 30%.

## Cosa NON dice (limiti dichiarati)
- Il **tester non e il live**: il conteggio di FTMO e sul registro del terminale; il proxy dei giornali puo non coincidere. La misura vera resta quella sul VPS.
- **Rischio di sicurezza del virtual SL/TP non misurato**: lo stop non sta sul server; se si ferma il terminale o il VPS, o in caso di gap, la posizione resta senza protezione. Va pesato a parte.
- Il significato esatto di `SetVSL_to_hardSL_sec_delay=99` e di `useVirtualStops` NON e verificato (manuale o Wim).
- Rumore della Randomization 50 su Phantom e Reaper (due ripetizioni, non di piu); un solo percorso per anno; versione degli EA sul VPS e sul trial NON verificata (Wim ha aggiunto il trailing virtuale il 30/09).
- Nessun giudizio su acquisti, lotti, taglie o su quale soluzione scegliere (virtual SL/TP, meno trailing, meno strategie, nessuna posizione attraverso la pausa).
