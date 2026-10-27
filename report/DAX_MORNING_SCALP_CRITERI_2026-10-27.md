# The DAX Morning Scalp (njtrading) sul DAX di BCM: CRITERI e PREVISIONI (27/10/2026, scritti PRIMA dei numeri)
**Natura: CRITERI. Non controllata da agenti.** Richiesta di Claudio (27/10): "lo abbiamo testato? e tra i demo scaricati". Risposta: no, solo un setaccio sull'oro (17 operazioni, -7%, PF 0,32: EA da indice sul simbolo sbagliato, NON MISURATO). Materiale: pagina del Market (prodotto 102586, v2.31, aggiornato 02/04/2024, 7 attivazioni, 920 demo, 30 USD, 5 stelle su 7 recensioni), 5 file .set, 7 immagini di backtest del venditore.

## Fatti letti (DICHIARATO dal venditore)
- **Non e un EA di Wim**: venditore NJtrading, nessun signal. EA di breakout sull'apertura del DAX con ordini pendenti, **timeframe M15** (funziona anche su altri), simbolo GER40/DE40/DE30, deposito minimo 200 $, rischio consigliato 0,5-6% per operazione, conto ECN o raw, leva 1:20 per la modalita normale (1:50 se si usa anche l'aggressiva). Niente griglia, martingala o hedging (dichiarazione del venditore). Un solo ora di input: "DAX_opening_hour_based_on_broker_time" = l'ora del grafico del broker alle 09:00 CET (default 10 = broker IT+1; su BCM UTC+1 fisso: 9 d'inverno, 8 d'estate); il rilevamento automatico NON funziona nel tester.
- **Backtest del venditore** (tutti su un broker FTMO, GER40.cash M15, tick reali, 100 ms, deposito 10.000 USD): 2022-01-01 -> 2023-09-01 default, aggressivo spento: rischio 1% +48,56%, DD equity 7,91%, PF 1,53, 458 operazioni, 84,5% vincenti, vincita media 36 contro perdita media -129; rischio 2% +118,73%, DD 15,29%; con aggressivo acceso (rischio 1%, a fine 09/2023): +124,98%, DD 7,63%, PF 1,28, 1.116 operazioni, 74% vincenti (+4,34% al mese in media, mesi negativi: 03/2022 -2,13%, 12/2022 -4,34%, 03/2023 -0,87%); set "1 a 1" (stop e target 3.100 punti, 2022-01 -> 2023-07): +88,5%, DD 8,98%, PF 1,38, 400 operazioni; una prova ICMarkets 2023 H1: +55%, DD 8,46%, PF 1,83, 171 operazioni.
- **Lettura**: profilo "molte piccole vincite e perdite 3-4 volte piu grandi" (payoff 0,28 a modo normale). Target di 1.000 punti = 10 punti indice: a 25.000 e circa 0,04% del prezzo, contro circa 0,06% quando il DAX era a 16.000: spread e slippage pesano di piu oggi (NON MISURATO su BCM).
- **Dichiarazione del venditore sulla pagina**: il Reversal Mode "ha funzionato particolarmente bene da settembre 2023, quando i breakout hanno iniziato a sottoperformare nel mattino del DAX". **I suoi test di default finiscono a settembre 2023, dove lui stesso dice che il breakout comincia a faticare.** I dati BCM sul DAX partono dal 26/09/2024: tutto il nostro periodo e dopo.
- Il set "brunch 2024" (hour 11, entrata dopo 45 minuti, deviazione 500, trailing e break-even) e salvato il 25/07/2024: il nostro periodo (da 01/2025) e fuori campione per tutti i set.

## Passate (riga `RIGA_LANCIA_DAXMS_80K.txt`, script ANNO80K v5, pin 3e43646d)
10 passate a tick reali, D30EUR M15, 80.000 EUR, 01/01/2025-01/10/2026. 5 set: DEFAULT (v2.31, aggressivo acceso), SENZAAGGR (default con aggressivo spento), UNOAUNO (stop e target 3100: v2.21), REVERSAL (modo inversione), BRUNCH (2024). Ognuno gira **due volte**: con le ore d'INVERNO (apertura 9, cancellazione ordini 14:14 per i default) e con quelle d'ESTATE (8 e 13:14), perche BCM e UTC+1 fisso e il DAX apre alle 09:00 italiane tutto l'anno; il lettore prende da ogni corsa **solo i deal della stagione giusta** (estate = ora legale CEST: 30/03/2025-25/10/2025 e dal 29/03/2026). Ore dei set (broker IT+1) -> BCM: inverno -1, estate -2. Imposti tutti i 36 input dei set (rischio 1%). UltraSafety lasciato fuori (raddoppia il rischio al 2%, non aggiunge informazione).

## Criteri (classe PROP 80K, come per gli altri EA: `PACCHETTO_6_SU_12_SELEZIONE_CRITERI_2026-10-26.md`)
Lettore `leggi_dax_morning.py` (congelato, con autotest): S-N >= 150 operazioni; S-M >= 60% mesi positivi e somma > 0; S-H somma > 0 in entrambe le meta (01/2025-05/2026 e 06/2026-09/2026); nessun giorno con perdita realizzata >= 5%; DD realizzato <= 8.000 EUR. Si riportano anche PF, % vincenti, vincita e perdita media, payoff, giorni >= 3% e >= 4%, risultati per stagione. **Solo realizzato**: l'equity intraday richiede l'export M1 del DAX (non fatto); l'EA tiene la posizione poche ore. **Non misurati**: slippage e spread reali di BCM sugli ordini pendenti (decisivi con target da 10 punti), costi (classifica C0-C3), correlazione, equity.

## Previsioni dichiarate ORA
- D1: almeno un set supera tutti i cancelli: 30%.
- D2: il DEFAULT (aggressivo acceso) ha PF > 1,15 sui 21 mesi: 40%.
- D3: il REVERSAL batte il DEFAULT per netto: 50% (il venditore dice che il breakout fatica da 09/2023).
- D4: SENZAAGGR ha meno del 55% delle operazioni del DEFAULT: 85% (il venditore: 458 contro 1.116).
- D5: nei set normali la % vincenti supera il 70% con payoff sotto 0,5: 70%.
- D6: almeno un set ha un giorno con perdita realizzata >= 3%: 55%.
- D7: nel DEFAULT il PF d'inverno e quello d'estate differiscono di piu di 0,3: 50%.
- D8: il DEFAULT ha tra 800 e 1.300 operazioni nei 21 mesi: 55%.

## Cosa NON dice
Un percorso storico, un solo DAX (BCM), slippage zero nel tester sugli ordini pendenti, il feed BCM che puo differire dal feed FTMO del venditore, le ore dei set convertite per stagione (se l'EA legge altrimenti l'ora la corsa lo mostra come orario sbagliato), nessun giudizio su acquisto, lotto o taglia. Su FTMO valgono le regole sulle posizioni opposte e il DAX ha il problema dell'ora d'inverno gia documentato per le nostre sedie.
