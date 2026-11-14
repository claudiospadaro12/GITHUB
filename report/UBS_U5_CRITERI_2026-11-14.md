# UBS U5: la candela di conferma dei set V9.0 cambia il risultato? — CRITERI e PREVISIONI (14/11/2026, scritti PRIMA dei numeri)

**Natura: CRITERI, riga NON ancora preparata ne lanciata.** Chiude il punto aperto di `UBS_CATALOGO_SET_V9_0_2026-11-14.md`: i test U1-U4 usano i 283 set del sito, che hanno la candela di conferma SPENTA; nel pacchetto V9.0 (382 set, 27/10) i set Goldbot One daily e Goldtrade Pro l'hanno ACCESA. Solo tester su PC di backtest (BCM, Modello 1); reale, trial FTMO e VPS non si toccano; nessun giudizio su lotti, taglie o acquisti. (Il nome U5 evita confusione con U3 gia fatto; e la ripetizione di U3 sui 4 set cambiati.)

## Cosa cambia fra le due versioni dei 4 set (letto da `UBS_CATALOGO_dati/differenze_43_set_stesso_nome.json`)
| Set | Differenza fra 283 (vecchio) e V9.0 "Breakout_Support_Resistance/GOLD" |
|---|---|
| Goldbot dailyC, dailyI | `UseConfirmationCandleA` e `UseConfirmationCandleD`: false -> true. Nient'altro |
| GOLDTRADEPRO_a, _E | `UseConfirmationCandleA`: false -> true. Nient'altro |
| GOLDTRADEPRO_E "UBS live portfolio" (variante) | come sopra e in piu `EnableNFP_Filter` false -> true |
**Cosa faccia la candela di conferma NON e verificato** (manuale V9.0 non letto per questo punto): si legge dal nome come una conferma di candela sull'entrata. Quindi la domanda e empirica.

## Domande
1. **Q1**: a lotto fisso, la versione V9.0 (candela ON) cambia netto, PF, numero di operazioni e DD rispetto alla versione vecchia (candela OFF) sugli stessi periodi?
2. **Q2**: cambia la stabilita del DD fra i due periodi? (Goldbot dailyC aveva DD01 3,08 volte piu alto nel 2013-18 che nel 2019-25: questo rende fragile il dimensionamento di U3.)
3. **Q3 (secondaria)**: sul GTP_E, la versione "live" con filtro NFP acceso riduce le operazioni o cambia il risultato rispetto alla V9.0 senza NFP?

## Disegno (12 passate)
Stessi parametri di U3 tappa 1 (`UBS_U3_CRITERI_2026-11-12.md`): XAUUSD, Modello 1, deposito 100.000 EUR, EA `Ultimate_Breakout_EA_WSC_V9.5`, lotto fisso 0,1, nessun input imposto, set cosi come consegnati. Periodi **P1 2013-01-01 -> 2019-01-01** e **P2 2019-01-01 -> 2026-01-01**.
- **Braccio V1 (nuovo, 8 passate)**: i 4 set V9.0 (dailyC, dailyI, GTP_E, GTP_a) x P1 e P2.
- **Braccio V2 (secondario, 2 passate)**: GTP_E dal "UBS live portfolio" (candela ON + NFP ON) x P1 e P2.
- **Controllo (2 passate)**: ripetere la versione VECCHIA di dailyC su P1 e GTP_E su P2 e confrontare con i risultati di U3 tappa 1 (`D160_dati/ubsu3m.json`) per verificare che le passate siano riproducibili (Randomization 0).
- Riferimento V0 (candela OFF): `ubsu3m.json` (gia misurato, 18 passate): dailyC DD01 16,73 / 5,44, ops 163 / 165, net 794 / 1.074; GTP_E 33,12 / 41,30, ops 153 / 169, net 2.604 / 3.998; dailyI 87,15 / 69,80, ops 348 / 375, net 2.320 / 4.405; GTP_a 96,98 / 118,61, ops 428 / 483, net 7.555 / 7.878.
Stima: 1-2 ore di tester (candele da 1 minuto, EA daily).

## Misure
Per passata: netto, PF, operazioni, DD equity (in % e in EUR; DD01 = DD/10), win rate, peggior giorno. Per cella (set x periodo): rapporti V1/V0 di netto, PF, operazioni, DD01. Per set: DD01(P1)/DD01(P2) per V1 contro V0.

## Regole di lettura (fissate ora)
- **Validita**: report presente, deposito 100.000, qualita >= 95%, almeno 1 operazione, nessuno stop out/no money; input uguali al set e candela ON (V1/V2) o OFF (controllo) confermata nel report. Controllo valido se netto e operazioni coincidono con U3 entro 1%.
- **Esito di una cella V1 contro V0**: **MIGLIORE** = PF >= 1,05 x PF(V0) e DD01 <= 1,10 x DD01(V0) e netto >= 0,90 x netto(V0); **PEGGIORE** = PF <= 0,95 x PF(V0) oppure DD01 >= 1,25 x DD01(V0) o netto <= 0,75 x netto(V0); **NEUTRA** = netto, PF e DD01 tutti entro +-10%; **MISTA** = tutto il resto.
- **Verdetto sulle 8 celle**: **LA CANDELA CAMBIA POCO** se NEUTRE >= 6; **LA CANDELA AIUTA** se MIGLIORI >= 5 e PEGGIORI <= 1; **LA CANDELA PEGGIORA** se PEGGIORI >= 4; altrimenti **EFFETTO MISTO** (si legge set per set).
- **Q2**: la fragilita di dailyC resta se DD01(P1)/DD01(P2) >= 2 anche nella V1.
- Conclusioni non ammesse: nessun giudizio su quale versione sia "giusta" per Wim (il test dice solo cosa fa a noi); nessuna regola sul lotto da questo test.

## Previsioni dichiarate ORA (non misurate; probabilita)
- **U5-1** Almeno 11 passate su 12 valide e controllo riproducibile (<= 1%): 85%.
- **U5-2** Operazioni V1 inferiori alle V0 in tutte e 8 le celle: 80%; rapporto mediano fra 0,70 e 0,97: 65%.
- **U5-3** Netto V1 inferiore al V0 in almeno 5 celle su 8: 55%.
- **U5-4** PF V1 >= PF V0 in almeno 5 celle su 8: 55%.
- **U5-5** DD01 V1 <= DD01 V0 in almeno 5 celle su 8: 60%.
- **U5-6** Goldbot dailyC: DD01(P1)/DD01(P2) resta >= 2 nella V1: 65%.
- **U5-7** GTP_E variante live (NFP ON) contro V1: operazioni almeno 0,90 x quelle di V1 in entrambi i periodi: 75%.
- **U5-8** Verdetto: CAMBIA POCO 30%, AIUTA 25%, PEGGIORA 15%, EFFETTO MISTO 30%.
Ragione dei numeri: una candela di conferma ritarda o filtra l'entrata, quindi meno operazioni; che migliori il PF e un'ipotesi (Wim l'ha accesa nel portafoglio live, ma e un indizio, non una prova); nessun dato nostro finora.

## Cosa NON misura (limiti dichiarati)
Solo oro, solo 4 set, solo Modello 1 (niente tick), lotto fisso (U5 non dimensiona il rischio), un percorso per passata (Randomization 0), solo 2 periodi; l'EA e V9.5, quello dei nostri U1-U4 (se la versione dei set V9.0 e pensata per un EA piu recente, NON verificato); la differenza fra Modello 1 e tick per questi set non e misurata; **e un risultato sul passato, non una previsione**.

## Decisione che informa (non presa qui)
Quale pacchetto (283 o V9.0) usare come base per i prossimi test UBS. Non decide acquisti, lotti o portafoglio.
