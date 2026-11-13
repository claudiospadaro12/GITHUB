# Risposte scritte di FTMO (supporto, 13/11/2026; prima risposta del 10/11 reinoltrata) e cosa cambiano

**Fonte**: mail del supporto FTMO (Nicolas Novak) incollata da Claudio il 13/11/2026. Riassunto per argomento (non per numero di domanda: la numerazione 1-12 della risposta non e quella delle mie bozze). Non controllata da altri.

## Cosa dice FTMO
| Tema | Risposta |
|---|---|
| EA di terzi | Si possono usare, ma altri possono usare lo STESSO EA/strategia: se si supera la Maximum Capital Allocation il conto puo essere rifiutato |
| Maximum Capital Allocation | Applicata "per trader o per strategia": i conti che eseguono la stessa strategia sono valutati INSIEME (compresi altri trader sullo stesso EA o segnale); se il totale supera **400.000 $** puo scattare la violazione. Strategie/EA davvero diversi: ogni strategia ha il suo limite di 400.000 $, purche non siano identiche o molto correlate per aggirare il tetto. Challenge e conti contano; un conto fallito non conta piu |
| Come si accorgono / altro | "Non possiamo rivelarlo": motivi di sicurezza (la domanda 3 della loro numerazione) |
| Prezzi | Link: trader.ftmo.com/start-challenge |
| Leva | Standard fino a 1:100; **Swing fino a 1:30 (solo sul 2-Step)**. Forex maggiori/minori 1:100 / 1:30; esotici 1:66,67 / 1:20; **metalli, petrolio cash e indici maggiori 1:50 Standard / 1:15 Swing**; indici minori e materie prime 1:30 / 1:9; crypto, azioni e agricole 1:3,33 / 1:1. Calcolatore del margine: trader.ftmo.com/calculator/margin |
| Weekend e news | Standard: chiudere se il mercato e chiuso piu di 2 ore. **Swing: nessuna restrizione su news e weekend** (solo 2-Step) |
| Richieste al server | "Tutti i tipi di ordine sono considerati per le richieste al server" (nessun numero) |
| Hedging | Consentito nello stesso conto. **Cross-account hedging vietato in modo rigoroso**: aprire posizioni opposte su piu conti, a prescindere da entita/societa (prop firm o broker), viola i termini e puo portare alla chiusura dei conti |
| Gap trading | Vietato: aprire posizioni apposta poco prima della chiusura del mercato per sfruttare il gap alla riapertura (pagina Forbidden Trading Practices, clausola e (i, ii)) |
| Valute dei conti | USD, EUR, CZK, CAD, GBP, AUD, CHF |
| Familiari | Familiari nella stessa casa possono avere conti propri, non collegati sotto un unico limite di capitale **perche ognuno gestisce capitale e strategie diverse**; ogni conto deve essere operato solo dal suo titolare, senza gestione incrociata |

## Cosa cambia per il piano
1. **Tetto 400.000 $ per strategia**: nel portafoglio P1+P3+P4 il Goldbot e il Daytrade Pro stanno su TUTTI e tre i conti (P1 160k, P3 80k, P4 80k = circa 360.000-400.000 $ a seconda della conversione in dollari). Con le due challenge di Massimo sugli stessi EA (Goldbot, Phantom, Reaper), lo stesso EA supererebbe il tetto se FTMO considera "stessa strategia" lo stesso EA con set diversi (non chiarito). **Va ripartito: EA diversi per conto e per fratello.** Il conteggio di altri trader sullo stesso EA di Wim e noto solo a FTMO.
2. **Posizioni opposte fra conti**: confermato vietato "a prescindere". Nei test: 2.451-10.718 ore a coppia di conti con posizioni opposte (EA diversi o set diversi fanno lati diversi). Piu il portafoglio e diversificato per EA, piu cresce questo rischio; piu e uguale, piu cresce il rischio del tetto. **Nessuna misura di FTMO su come lo valuta** (tempo di sovrapposizione, dimensione).
3. **Leva Swing sull'oro 1:15 confermata**: margine fino al 50-59% del saldo (calcolo del 11/11). **Livello di stop out NON comunicato.**
4. **Richieste al server**: i nostri EA piazzano e cancellano molti ordini pendenti (trial: 1.776 ordini in circa 9 giorni, reale 27.629 in circa 2 mesi, in gran parte Finlab X); FTMO non da il limite. Le modifiche di SL/TP, che contano come richieste, non sono nello storico.
5. **Swing confermato** per news e weekend; prezzo e ripartizione del profitto non indicati (vedi link); conti in EUR ammessi.
6. **Gap trading**: i nostri EA non aprono apposta prima della chiusura; da verificare solo che nessun set apra a ridosso del venerdi sera (FridayStopHour=25 = nessuna chiusura del venerdi).
## Domande rimaste senza risposta
Livello di stop out Swing; prezzi e profit split dello Swing (link); come FTMO misura le posizioni opposte; se lo stesso EA con set diversi e "stessa strategia"; limite di richieste al giorno; reset del limite giornaliero (CET o CEST); regola sul conto Standard/Swing dopo l'acquisto.
