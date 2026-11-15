# Pilota di ottimizzazione UBS su EURUSD: criteri e previsioni scritti PRIMA dei numeri (15/11/2026)

**Natura: CRITERI.** Nessuna ottimizzazione lanciata, nessun numero. Solo tester sul PC di backtest; reale, FTMO e VPS non si toccano; nessun giudizio su lotti, taglie o acquisti. **Sostituisce, per i periodi e per il metodo, `UBS_OPTIMIZER_CRITERI_2026-11-15.md`** (l'app UBS Optimizer non e ancora sul PC: si ottimizza dentro MT5 col metodo del manuale v8.3, pagg. 10-13, e la convalida la fanno le nostre righe del tester). Basi: `RISULTATI_UBS_C_FOREX_2026-11-15.md`, `RISULTATI_UBS_C_FOREX_TICK_2026-11-15.md`, `UBS_COMBINAZIONI_PIANO_2026-11-15.md`.

## 1. Perche questo pilota
I set di Wim cosi come consegnati non rendono abbastanza per superare una challenge: rendimento annuo / DD massimo (Calmar) fra 0,3 e 1,0 sul forex, e gli scalper crollano a tick reali (PF -45%, netto quasi zero). Obiettivo: **trovare, con l'ottimizzazione, almeno un set EURUSD con rendimento/DD piu alto che regga fuori campione, a tick reali e nel 2025.** Obiettivo di Claudio: meno rischio di fallire, max 4 EA, portafoglio separato dall'oro.
**Lezione dai tick:** vittorie piccole (2-4 EUR a 0,1 lotti) spariscono con lo spread vero. Il manuale lo dice ("non fissare stop/target troppo piccoli: con uno stop di 2 pip lo slippage uccide la strategia").

## 2. Dati (tre blocchi, scritti ora)
- **Dentro campione (IS):** 2013-01-01 -> 2022-12-31 (10 anni, come il metodo di Wim 2013-2023).
- **Fuori campione 1 (OOS1):** 2023-01-01 -> 2024-12-31.
- **Fuori campione 2 (OOS2), se i dati BCM EURUSD esistono:** dal primo anno disponibile al 2012-12-31 (da verificare con una passata).
- **Hold-out finale 2025:** 2025-01-01 -> 2026-01-01, a tick reali. **Mai aperto durante l'ottimizzazione e la scelta**; si usa UNA volta sui finalisti. Se si cambia qualcosa dopo averlo visto, non e piu un hold-out e va dichiarato.
- Nota: questo cambia i periodi del criterio precedente (IS 2013-2018) per seguire il metodo di Wim (10 anni di IS) e per avere piu dati dentro; l'OOS e piu corto.

## 3. Impostazioni dell'ottimizzazione (in MT5 portable `C:\MT5_BCM_Opt`, fatta da Claudio con foto)
- EA `WIM\Ultimate_Breakout_EA_WSC_V9.5`, **EURUSD**, un solo modello d'ingresso e un solo timeframe (vedi "Set base").
- Modello **"1 minute OHLC"**, ritardo zero, **Forward: No**, deposito 100000 EUR, leva 1:100, **lotto fisso 0,1** (`Risk=0`, `StartLots=0.1`), spread filter OFF (come nel manuale per le prime ottimizzazioni).
- Algoritmo **genetico veloce**, criterio **"Custom max"** con i tre minimi dell'EA: **operazioni >= 150, recovery factor >= 1,5, expected payoff >= 3 EUR** (a 0,1 lotti). Questi valori sono miei, non di Wim.
- **Set base: da scegliere DOPO aver letto i parametri liberi dei set di ottimizzazione (riga di sola lettura), PRIMA di vedere qualunque risultato.** Copiati nel portable il 15/11 (15 set di ottimizzazione in `UBS_V9_0`). Candidati per EURUSD: (a) `Range Breakout\Range_Optimization_EURUSD.set` (fatto per EURUSD, modello Range Breakout; ATTENZIONE: usa orari di sessione, e le nostre misure sugli ORB mostrano che la finestra segue l'orologio del server SENZA ora legale: va fissata una regola per estate/inverno prima di usarlo); (b) `Other sets\daytrade 2(DAILY)\optimization.set` (supporto/resistenza, giornaliero, forex, nessun orario di sessione); (c) `Volatility Breakout\...` solo se esiste un set di ottimizzazione per forex (quelli trovati sono ETH e indici: NO). **Scartati:** `Advanced Scalper\Optimization_set.set` (famiglia che e crollata a tick reali), set oro, Bitcoin e indici. **Regola di scelta (scritta ora):** si preferisce (b) se i suoi parametri liberi permettono stop e target >= 30 pip senza orari di sessione; si usa (a) solo se (b) non e utilizzabile e dopo aver deciso come gestire l'ora legale.
- **Timeframe:** quello previsto dal set base scelto (se (b), giornaliero D1; il pilota diventa EURUSD D1 e non H1). In ogni caso un solo timeframe, non ottimizzato.
- Gli intervalli restano quelli del set tranne i **pavimenti anti-scalper: stop-loss iniziale >= 30 pip e take-profit iniziale >= 30 pip**.
- **Massimo 6 parametri liberi** (stop, target, trailing, distanza minima dal massimo/minimo, forza di H/L, pip extra); tutto il resto fisso. (Manuale: "non ottimizzare ogni parametro".)
- **UNA sola ottimizzazione.** Non si rilancia con intervalli diversi dopo aver visto i risultati. Si registra: numero di passaggi, tempo, numero di risultati che superano i minimi.

## 4. Scelta dei candidati (regole fisse, le applico io sul file dei risultati)
1. Dal risultato dell'ottimizzazione (esportato da Claudio): tengo i passaggi con **PF IS >= 1,30, operazioni >= 150, recovery factor >= 1,5**.
2. Fra quelli: **massimo 10 candidati**, scelti cosi: i migliori 4 per "Custom max" e 6 "diversi" (parametri lontani dai migliori, uno per ogni gruppo simile), per non provare 10 copie dello stesso set.
3. Si salva ogni candidato come file `.set` con nome fisso (`OPT1_01` ... `OPT1_10`) e **si scrive la lista dei numeri prima di vederne i risultati fuori campione**.

## 5. Convalida (le faccio con le nostre righe del tester, set per set, lotto 0,1)
- **V1 OOS1 (2023-2024, M1):** PF >= 1,20, netto > 0, recovery factor >= 1, operazioni >= 15, nessuno stop out.
- **V2 OOS2** (se i dati esistono): stessi minimi, scalati agli anni.
- **V3 tick reali contro M1 su 2023-2024** (stesse soglie di Wim e del nostro piano): PF tick/M1 >= 0,7, DD tick <= 1,5 x M1, operazioni +-10%, win rate +-10 punti.
- **V4 perturbazione:** per ogni parametro libero un passo a destra e uno a sinistra: >= 70% delle varianti con PF > 1 su IS e OOS1, e PF mediano >= 0,8 volte quello base.
- **V5 hold-out 2025 a tick reali, SOLO sui finalisti:** PF >= 1,20, netto > 0, DD <= 5% del deposito.
- **V6 utilita:** rendimento medio annuo / DD massimo (su OOS1+2025 a lotto 0,1) **>= 2** per dirlo "utile" a una challenge. Sotto 2: scritto "valido ma troppo lento".
- Un candidato e **FINALISTA** se passa V1-V4; e **CANDIDATO** se passa anche V5; e **UTILE** se passa anche V6.

## 6. Regole di arresto
- Se nessun candidato passa V1: **"nessun candidato"**, si scrive il referto, **non si cambiano intervalli ne soglie per forzare un esito.**
- Se nessuno passa V3 (tick): idem; il problema sarebbe strutturale (target troppo corti).
- Si conta quanti candidati e passaggi sono stati guardati: l'esito si legge con questo numero accanto.

## 7. Previsioni (scritte ora)
- **P-1** L'ottimizzazione finisce in meno di 8 ore dall'avvio (compreso il primo download di 10 anni di dati EURUSD): 60%.
- **P-2** Almeno 5 passaggi superano i minimi del punto 4: 70%.
- **P-3** Almeno 1 candidato passa V1 (OOS1): 55%.
- **P-4** Almeno 1 candidato passa V3 (tick): 40%.
- **P-5** Almeno 1 candidato passa V4 (perturbazione): 30%.
- **P-6** Almeno 1 candidato passa V5 (hold-out 2025): 20%.
- **P-7** Almeno 1 candidato "UTILE" (V6, rendimento/DD >= 2): 10%.
- **P-8** Il miglior candidato supera, nello stesso hold-out 2025 a tick reali e a lotto uguale, il miglior set di Wim consegnato (VOL_o o VOL_f): 25%.
- **P-9** Il rendimento/DD del miglior candidato nell'hold-out e meno della meta di quello che aveva nell'IS: 70% (sovra-adattamento tipico).

## 8. Cosa NON sappiamo
Se i dati BCM EURUSD sono completi per 10 anni (la qualita del download); quale set base forex sia il piu adatto; quanto dura l'ottimizzazione sul nostro i7 portatile; se il genetico trova qualcosa con soli 6 parametri; se uno stesso set funziona sugli altri anni (non e provato dal solo hold-out 2025); lo spread FTMO.

## 9. Passi pratici (uno alla volta, io annuncio in grassetto)
1. Copia dei set nel portable (riga `COPIA_SET_OPT`).
2. Prima passata di prova EURUSD H1 per scaricare i dati (10 anni) e vedere la qualita storico.
3. Claudio imposta l'ottimizzazione con le mie istruzioni e foto delle schermate prima di avviare.
4. Ottimizzazione (ore). Nessuna riga mia nel frattempo.
5. Claudio esporta i risultati; li leggo e applico la sezione 4.
6. Convalida V1-V6 con le righe del tester, un blocco alla volta.

## 10. Decisione sul set base e sui parametri (15/11/2026 18:30, PRIMA di qualunque risultato)
Letti i parametri liberi (riga di sola lettura, output di Claudio): `Range_Optimization_EURUSD.set` ha sessione oraria (`RNG_CheckHour` 0-23, `RNG_TimeZone`) e stop/target fissi; `Other sets\daytrade 2(DAILY)\optimization.set` ha stop e target liberi 30-300 pip (passo 5), nessun orario di sessione, `ST1_Timeframe=0` (timeframe del grafico). **Per la regola del punto 3: base = `daytrade 2(DAILY)\optimization.set`, pilota = EURUSD D1.**
- **6 parametri liberi (regola: uscite e distanza minima dai massimi/minimi):** `Exit_stop` (30-300, passo 5), `Exit_limit` (30-300, passo 5), `ST1_MinDist_to_HL` (10-100, passo 1), `Exit_TrailSL_size` (0-200, passo 5), `Exit_TrailSL_Start` (0-200, passo 5), `ST1_Expiration_hours` (10-240, passo 5).
- **Fissi ai valori del set:** `ST1_HL_strength_L=2`, `ST1_HL_strength_R=6`, `ST1_countback=50`, `ST1_UpDiff=2`, `ST1_DownDiff=3`, `Exit_TrailTP_size=200`, `Exit_TrailTP_Start=160`, `Exit_BE_start=35`, `Exit_BE_extra_pips=115`.
- **Timeframe:** giornaliero (D1), con `Entry_Timing` del set (H1 per il controllo dei segnali). Con D1 le operazioni sono poche: il minimo di 150 in 10 anni (15 l'anno) potrebbe escludere molte combinazioni. Se la passata base mostra meno di 100 operazioni in 10 anni a lotto 0,1, il minimo diventa 100 e lo scrivo nel referto PRIMA di ottimizzare.
- **Primo passo:** una passata normale (non ottimizzazione) con il set base su EURUSD D1 2013-2022 per scaricare i dati, misurare il tempo e contare le operazioni.
- **P-1 riscritta per D1:** l'ottimizzazione (6 parametri, genetico veloce) finisce in meno di 6 ore: 60%.
