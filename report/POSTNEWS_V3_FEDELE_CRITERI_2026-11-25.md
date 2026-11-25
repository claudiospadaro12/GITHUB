# Post News V3: regole ESATTE del corso (lezioni 4-10), criteri scritti PRIMA dei numeri (25/11/2026)

**Fonte:** trascrizioni TurboScribe del corso (copiate in `report/POSTNEWS_dati/lezioni/`). Le regole del corso differiscono dai preset dell'EA `ABTG_PostNews` e quindi V1/V2 NON erano fedeli. Differenze:
1. **BCE solo su EURJPY, FOMC solo su EURUSD** (V1 provava 4 coppie per tipo).
2. **Nessun OCO:** i due ordini restano entrambi attivi; "possono essere eseguiti entrambi" e il rischio 3% e' calcolato su 50 pip proprio per il doppio stop.
3. **Posizioni aperte NON chiuse alla scadenza:** la scadenza vale solo per gli ordini pendenti; la posizione resta fino a TP/SL oppure chiusura manuale **venerdi 22:50 ora italiana**. (V1 chiudeva a +195/+65 minuti: errore.)
4. **Range BCE:** ignorare la candela M5 dell'inizio conferenza; si usano le **due candele successive** (inizio+5 e inizio+10 min), azione a inizio+15. **Range FOMC:** la candela dell'inizio e la successiva (inizio e inizio+5), azione a inizio+10.
5. **Distanze:** buy stop = massimo + 3 pip, sell stop = minimo - **2** pip (V1: 3/3). TP 50, SL 25. Scadenza pendenti: BCE **18:15 ora italiana** fissa; FOMC inizio + 75 min.
6. Trailing solo BCE e "facoltativo" (+25 pip di profitto -> SL da 25 a 15 pip). Il file di backtest del corso mostra anche esiti "-15", quindi il caso primario e' CON trailing; senza trailing e' una misura di sensibilita'.

## Simulazione
Dati M1 BCM (bid), spread dalla barra, orari del calendario (ora server GMT+1 fisso), orari italiani via Europe/Rome. Un evento = fino a 2 operazioni indipendenti. Costi e ambiguita' come V1: slippage 0,5 pip su ingressi stop e SL, 0 sul TP; nella barra di scatto conta solo lo SL; SL prima di TP nella stessa barra; trailing efficace dalla barra successiva. Pendente valido solo se il prezzo di azione e' sotto (buy) o sopra (sell) il livello.

## Celle e soglie (solo 2 celle primarie, piu' 1 di sensibilita')
| Cella | IS | OOS | Hold-out |
|---|---|---|---|
| BCE EURJPY (primaria, con trailing) | 2013-2020, PF >= 1,3 con >= 50 operazioni | 2021-2024, PF > 1,2 con >= 25 | 2025-26 PF > 1,0 con >= 15 |
| FOMC EURUSD (primaria) | 2016-2021 PF >= 1,3, n >= 30 | 2022-2024 PF > 1,2, n >= 20 | 2025-26 PF > 1,0, n >= 15 |
| BCE EURJPY senza trailing (sensibilita', non selettiva) | riportata | riportata | riportata |
- Hold-out **non vergine** (2025-26 visto in V1/V2 su altre regole): lo si dichiara; il verdetto resta sulle soglie sopra, non abbassate.
- Candidata = IS, OOS e hold-out passano nella stessa cella. Con 2 celle un passaggio non e' un colpo di fortuna da molte prove, ma il campione e' piccolo: si riporta anche pip per anno e per operazione e il confronto con il dichiarato.
- Confronto con il corso: BCE "circa 3000 pip in 15,5 anni" (circa 190 pip/anno, 8 eventi); strategia complessiva +20%/anno a 3% di rischio. FOMC 2013-2015 (e 2009-2012 del corso) NON nel nostro calendario: limite dichiarato.

## Previsione (scritta ora)
FOMC EURUSD non passa l'IS (V1/V2 hanno dato PF 0,2-0,9 su tutti gli orari). BCE EURJPY: l'IS probabilmente passa (V1/V2 lo davano 1,3-1,8); il punto aperto e' l'hold-out 2025-26: previsione PF < 1,0 e +190 pip/anno non riprodotti. Probabilita' che ci sia una candidata: circa 25%.
