# Cancello minimo prima di UBS: oro + forex (CONGELATO l'08/11/2026, scritto PRIMA dei numeri)

Decisione di Claudio (08/11): "va bene, testiamo come hai proposto tu". Il cancello e **congelato**: dopo questa data non si aggiungono ne si tolgono voci senza un'altra decisione scritta. Gli EA di indici e Bitcoin sono fuori (decisione del 07/11).
Regole fisse: criteri e previsioni prima dei numeri; "NON MISURATO" quando non si sa; niente taglie ne lotti; reale 10105439, trial FTMO e VPS non si toccano; ogni zip <= 10 MB.

## Voci del cancello
| # | Voce | EA | Tipo | Stato |
|---|---|---|---|---|
| F-A | Fuori campione 7 anni nuovi | 4 forex | 70 passate | **FATTO** (`RISULTATI_FOREX_OOS_2026-11-08.md`) |
| F-B | Tick reali contro barre, 2025 | DTP Max9, Stab low, Apex Cons, Luna 4DD | 4 passate | **FATTO** (`RISULTATI_FOREX_TICK_2026-11-08.md`) |
| F-E | Costi FTMO, correlazione (senza passate) | 7 set forex | post-elaborazione | **FATTO** (`RISULTATI_FE_FOREX_COSTI_E_CORRELAZIONE_2026-11-08.md`) |
| O-1 | `AdjustLotsizeToVariableValues` e `FridayStopHour` nei set oro | Reaper, Phantom, Goldbot | lettura dei report gia fatti | **FATTO**, esito sotto |
| O-2 | Weekend: costo della chiusura del venerdi (`FridayStopHour`) | Reaper, Phantom, Goldbot | 18 passate | **FATTO** (`RISULTATI_O2_WEEKEND_2026-11-09.md`) |
| O-3 | Randomization 60 contro 0 contro 50 | Reaper, Phantom | 12 passate | **FATTO** (O-3 e O-3b) |
| fuori | giro C (orari GMT), giro D (80k forex), AdjustEntry negativo, strategia 9 del Reaper | | | **limiti dichiarati, non test** |

**CANCELLO CHIUSO il 09/11/2026: `CANCELLO_CHIUSURA_2026-11-09.md`.**

Chiusura del cancello: una pagina con una riga per EA, "TESTATO BENE" oppure "TESTATO CON QUESTI LIMITI", con la regola: *TESTATO BENE* solo se tutte le sue voci sono fatte senza sorprese; altrimenti "con limiti" e i limiti sono elencati. Nessuna promozione a "adatto al reale" o alla prop: la decide Claudio col forward.

## O-1 (FATTO): lettura dei report dei test oro gia fatti
Fonte: 24 configurazioni (Reaper, Phantom, Goldbot, livelli L0-L3, 80k e 3.745) lette nei report del tester: **`AdjustLotsizeToVariableValues=true` e `FridayStopHour=25` in tutte e 24**. Quindi: (1) il parametro che Wim dice "deve essere True" era True in tutti i nostri test su Reaper, Phantom e Goldbot; (2) la chiusura del venerdi e **spenta** nei nostri test (25 = mai), coerente con quanto scritto. Nei set vendita di Gold Trade Pro (GTP) il parametro non compare: NON VERIFICATO il valore usato nei test GTP. Dai file dei set: Reaper "standalone" (default, propfirm, 15%, 60%) non lo riportano, Phantom e Goldbot si (true/1).

## O-2: costo della chiusura del venerdi (`FridayStopHour`)
**Domanda**: cosa perdiamo (profitto, DD) se il venerdi non si tengono posizioni oltre una certa ora? E il parametro chiude le posizioni oppure blocca solo le nuove? (NON VERIFICATO: dal nome non si capisce).
**Passate (18)**: Reaper, Phantom e Goldbot a livello L0 (Prop) e L3 (Combo 3GOLD), anni 2013, 2020, 2025, 80.000 EUR, Modello 1, XAUUSD H1, gli stessi input dei test base **tranne `FridayStopHour`**. Il valore e **19** (ora del server, 3 ore prima della chiusura invernale; se l'ora vale come ora GMT corretta da `AutoGMT_Backtest` non lo so: NON VERIFICATO). Riferimento: le stesse passate con `FridayStopHour=25` gia fatte (96 passate del 06/11).
**Misure**: netto, DD equity, operazioni, peggior giorno realizzato, e dai deal: quante posizioni attraversano il weekend, quanto profitto viene da quelle, ora dell'ultima apertura e dell'ultima chiusura del venerdi.
**Regole di lettura (fissate ora)**:
- **COSTO ACCETTABILE** (per EA e livello): netto con la chiusura >= 92% del netto base in ciascuno dei 3 anni **e** DD equity non piu alta di 1 punto percentuale.
- **COSTO ALTO**: netto < 85% del base in almeno un anno oppure DD +3 punti.
- In mezzo: **ZONA GRIGIA**.
- **CHIUDE** se le posizioni che attraversano il weekend scendono sotto il 2% (del totale aperto); **SOLO BLOCCA NUOVE** se restano oltre il 10%.
**Previsioni dichiarate ORA**:
- **W1** Il parametro chiude davvero le posizioni (attraversamenti < 2%): 50%; solo blocca nuove aperture (attraversamenti > 10%): 35%.
- **W2** Media dei 3 anni: perdita di netto fra il 2% e l'8% per i tre EA al livello L0: 55%; oltre il 15% per almeno un EA: 15%.
- **W3** Il DD equity non peggiora (entro +1 punto) in almeno 15 delle 18 coppie: 65%.
- **W4** Il Reaper ha la perdita relativa maggiore dei tre (e il Goldbot la minore): 45%.
- **W5** Nessuna passata invalida: 85%.

## O-3: Randomization 60 contro 0 contro 50
**Domanda**: la Randomization (ritardo casuale degli ordini per non essere "identici" ad altri utenti) costa profitto o cambia il DD? Nei set prop di Wim e 50, nei Medium 0; mancano 60 contro 0.
**Passate (12)**: Reaper e Phantom a L0 (Prop, Randomization 50 nel base), anni 2013, 2020, 2025, con Randomization **0** e **60** (tutto il resto uguale), 80.000, Modello 1. Riferimento: le passate L0 con 50 (96 passate). Goldbot e GTP non hanno il parametro nei loro set (Goldbot=0 fisso nei set letti).
**Misure**: netto, DD equity, operazioni, peggior giorno realizzato.
**Regole**: **NEUTRA** se il netto resta entro +-10% del base e il DD entro +-2 punti; **COSTOSA** se il netto cala oltre il 10% o il DD sale oltre 2 punti; **UTILE/RISCHIOSA** altrimenti non si classifica. Una sola coppia o un solo anno non decide.
**Previsioni dichiarate ORA**:
- **R1** Randomization 60 e 50 danno risultati simili (netto +-10%): 70% per ogni EA.
- **R2** Randomization 0 ha un netto piu alto del 50 in almeno 4 coppie su 6 (EA x anno): 50%.
- **R3** Il numero di operazioni cambia di meno del 5% fra 0 e 60: 70%.
- **R4** Il peggior giorno realizzato non peggiora di oltre 10% col 60: 60%.

## F-E: costi FTMO e correlazione sui set forex (senza passate nuove)
Si usano i risultati gia raccolti (12 anni, 7 set che hanno superato il fuori campione: DTP Max9, DTP Max20, Stab low, Luna 4DD, Apex Cons, Apex Ultra, e per confronto DTP Max50).
**E1 Costi**: commissione FTMO forex **2,50 USD per lotto per lato**, slippage in 3 scenari (ottimistico / centrale / prudente: 0,1 / 0,3 / 0,6 pip per operazione, valori **ipotesi mie**, NON VERIFICATI sul broker), lotti dai deal dei report; il guadagno netto si ricalcola per anno e si confronta col tester.
**Regola E1**: **REGGE I COSTI** se nello scenario centrale il netto medio resta >= 75% di quello del tester e nessun anno cambia segno rispetto a prima; **FRAGILE** se < 60% oppure se 3 o piu anni cambiano segno.
- Previsioni: **E1a** DTP Max9 REGGE (>=75%): 65%; **E1b** Luna 4DD FRAGILE (< 60%) per le operazioni a lotto minimo e SL stretti: 35%; **E1c** Stab low REGGE: 55%; **E1d** Apex Cons REGGE: 70%.
**E2 Correlazione**: correlazione dei profitti giornalieri realizzati fra coppie di set forex nello stesso anno, e con il trio oro negli anni in comune (2013, 2020, 2025). Soglia: |corr| >= 0,5 = "si muovono insieme" (non conviene sommarli come diversificatori).
- Previsioni: **E2a** DTP Max9 contro il trio oro: |corr| < 0,3: 70%. **E2b** Apex Cons contro Apex Ultra: corr > 0,8 (stessa griglia): 90%. **E2c** Luna 4DD contro DTP Max9: |corr| < 0,3: 70%.
**Non misurabile senza dati nuovi**: perdita giornaliera **con** posizioni aperte (serve l'M1 dei cross AUD/NZD: nessun export); la DD equity del tester gia comprende il flottante a livello di picco-minimo. Dichiarato come limite.

## Cosa cambia quando il cancello e chiuso
La chiusura non autorizza acquisti, lotti o taglie. UBS parte con la prima tappa: ricalibrare il "max historical DD a 0,01 lotti" sul BCM e sul FTMO (Wim 04/09 e 31/07), poi i set. I test di UBS restano separati dal forward in corso.

## O-3b (aggiunta del 09/11/2026, scritta PRIMA dei numeri): il risultato con Randomization 50 si ripete?
**Domanda**: nell'O-3 il Reaper con 60 ha reso il 10-15% meno del 50 e con 0 l'8-17% meno. Se due corse identiche con 50 danno gia risultati diversi fra loro, la differenza e **rumore**.
**Passate (6)**: Reaper L0 (`Gold_reaper_propfirm.set`, Randomization 50 del set), 2013, 2020, 2025, 80.000, Modello 1, **nessun input cambiato**, ripetuto **2 volte** per anno. Riferimento: la passata del 06/11 (96 test) con gli stessi input: ogni anno ha quindi 3 percorsi (base + 2).
**Regole fissate ora** (per anno, sul netto):
- **DETERMINISTICO**: le 3 corse hanno lo stesso netto (scarto <= 0,5%) e lo stesso numero di aperture. Allora le differenze 0/50/60 sono **reali** (non casuali).
- **RUMORE PICCOLO**: scarto massimo fra le 3 corse fra 0,5% e 3%.
- **RUMORE GRANDE**: scarto massimo oltre il 3%. Se supera il 10% in almeno un anno, il confronto 50-60 dell'O-3 e **non conclusivo** per il Reaper (la fascia di rumore e piu grande della differenza).
- Nessun giudizio su quale valore sia migliore da una sola serie.
**Previsioni dichiarate ORA (non misurate)**:
- **N1** Le 3 corse di ogni anno sono identiche (DETERMINISTICO in 3 anni su 3): 45%.
- **N2** Scarto massimo <= 3% in tutti e 3 gli anni (DETERMINISTICO o RUMORE PICCOLO): 65%.
- **N3** Scarto massimo oltre 10% in almeno un anno: 20%.
- **N4** Il numero di aperture varia fra le corse (se le corse non sono identiche): 85%.
- **N5** Le 6 passate sono tutte valide: 90%.

## O-2, REVISIONE del 09/11/2026 (scritta PRIMA dei numeri): con le ripetizioni
**Perche**: l'O-3b ha mostrato che Reaper e Phantom (Randomization 50) danno percorsi diversi a ogni corsa (rumore 6-46% sul netto annuo del Reaper). Una sola passata FRI19 contro una sola base confonderebbe il costo del venerdi con il rumore. Sostituisce la riga O-2 del 08/11 (commit 06ed8d68, 18 passate), che **non si lancia piu**.
**Passate (42)**, trio oro di Wim, L0 (Prop) e L3 (Combo 3GOLD), 2013, 2020, 2025, 80.000 EUR, Modello 1:
- **Reaper e Phantom** (12 celle = 2 EA x 2 livelli x 3 anni): FRI19 (`FridayStopHour=19`, unico input cambiato) in **2 ripetizioni** (R1, R2) + **1 ripetizione del BASE** (nessun input cambiato). Con la passata base del 06/11, ogni cella ha **2 percorsi base e 2 percorsi FRI19**. Totale 36 passate.
- **Goldbot** (Randomization 0, deterministico, 6 celle): una sola passata FRI19, da confrontare con la passata base del 06/11. 6 passate.
**Regole fissate ora** (per cella, sul **netto medio**):
- Rapporto = media FRI19 / media base. **COSTO ACCETTABILE** se il rapporto e >= 0,92 in ciascuno dei 3 anni **e** il DD medio FRI19 non supera quello base di piu di 1 punto; **COSTO ALTO** se il rapporto e < 0,85 in almeno un anno oppure il DD sale di 3 punti; in mezzo ZONA GRIGIA.
- **NON DISTINGUIBILE DAL RUMORE**: se |1 - rapporto| e minore del maggiore fra lo scarto fra le due basi e lo scarto fra le due FRI19 (in % sulla media), la cella non conta ne come ACCETTABILE ne come ALTO.
- **CHIUDE** se le posizioni che attraversano il weekend scendono sotto il 2% (del totale aperto); **SOLO BLOCCA NUOVE** se restano oltre il 10%. (Letto dai deal di ogni passata FRI19.)
- Il **Goldbot** si confronta con la sua unica base: stesse soglie, nessuna fascia di rumore.
**Previsioni dichiarate ORA (W1-W5 del 08/11 restano; si aggiungono)**:
- **W6** Almeno la meta delle 12 celle Reaper/Phantom e NON DISTINGUIBILE dal rumore: 55%.
- **W7** Goldbot: COSTO ACCETTABILE in tutte e 6 le celle: 50%.
- **W8** La ripetizione del base (BASE_R1) differisce dalla base del 06/11 di oltre il 3% sul netto in almeno 6 celle su 12: 75%.
- **W9** Il parametro CHIUDE le posizioni (attraversamenti < 2%) in tutti e tre gli EA: 40%.
- **W10** Tutte le 42 passate valide: 80%.
