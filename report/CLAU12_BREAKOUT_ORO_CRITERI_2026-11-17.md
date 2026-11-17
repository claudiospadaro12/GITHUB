# CLAU12_BREAKOUT_ORO: criteri e previsioni (17/11/2026, scritti PRIMA di qualsiasi numero)

**Natura:** piano di prova di un EA breakout sull'oro scritto da noi (base: `backtest_runner/Template_EA_Wim.mq5`, modalita ENTRY_BREAKOUT; nome di produzione previsto `CLAU12_BREAKOUT_ORO`). Solo tester/demo. Nessun giudizio su lotti, taglie, conti o acquisti. Decisione di Claudio (17/11): "parti dal breakout e scrivi i criteri".
**Cosa NON e:** non e un clone di Wim (codice mai visto, non imitato). Un breakout su livelli e un'idea generale; il risultato dei test dira se funziona, nessuna garanzia.

## 1. Prerequisiti (bloccanti, prima di leggere qualunque PF)
- P1. Il template compila (MetaEditor F7 o `Compila_EA.ps1`): 0 errori. Se ci sono errori: testo esatto in chat, correzione, si ripete. Previsione: compila entro 2 giri di correzione: 70%.
- P2. **Passata di controllo a occhio** (1 passata, 1 anno qualunque, visualizzatore o elenco operazioni): si verificano a mano 10 operazioni: ordini pendenti piazzati al livello +/- offset, scadenza rispettata, stop e target alle distanze previste, una sola posizione, nessun ordine duplicato. Se una regola non e rispettata: bug da correggere, e i numeri di quel giro NON si usano. Previsione: la prima passata mostra almeno un difetto da correggere: 60%.
- P3. Dati: **FTMO-Demo, XAUUSD**, storico dal 2015-01-01 (Modello 1 = candele da 1 minuto). Login FTMO: la Free Trial 1515150476 e scaduta il 16/11: serve un login FTMO-Demo valido; se il terminale non si collega, lo storico gia scaricato potrebbe bastare (NON VERIFICATO). Se non e possibile usare FTMO, si ferma e si decide.

## 2. Logica provata (fissa, non si cambia durante la ricerca)
Ingresso solo BREAKOUT: a ogni nuova barra del timeframe dei livelli si cancellano i pendenti e si piazzano buy stop sopra il massimo e sell stop sotto il minimo delle ultime N barre (N = Countback), con offset 0,10 ATR; distanza minima dal prezzo 0,20 ATR; una sola posizione alla volta; con una posizione aperta si cancella l'altro pendente. Stop = multiplo di ATR, target = multiplo del rischio (R). **Fissi per tutti i test:** lotto fisso 0,1; break-even e trailing spenti; tetti di perdita dell'EA spenti (`InpMaxDailyLossPct=0`, `InpMaxTotalDDPct=0`: cosi si misura il DD vero); `InpMaxTradesPerDay=1`; nessun filtro orario/spread/EMA; deposito 100.000 EUR; leva 100; ATR periodo 14 sullo stesso timeframe dei livelli. **Nessun filtro orario: l'ora legale/solare non entra** (regola CLAUDE.md: se in futuro si attivano sessioni, ora SERVER e controllo estate/inverno).

## 3. Batch logico (niente genetico: orto-gonale L9 + vicini, come `GeneraSet_Wim.py`)
Due timeframe dei livelli, **D1** e **H4**; per ciascuno una griglia ortogonale L9 su 4 fattori a 3 livelli:
| Fattore | D1 | H4 |
|---|---|---|
| A. Countback (barre) | 10 / 20 / 40 | 30 / 60 / 120 |
| B. Stop (ATR) | 1,0 / 1,5 / 2,5 | uguale |
| C. Target (R) | 1,5 / 2,0 / 3,0 | uguale |
| D. Scadenza pendenti (barre) | 3 / 6 / 12 | 18 / 36 / 72 |
Righe L9 (livelli 1-3 per A,B,C,D): 1111, 1222, 1333, 2123, 2231, 2312, 3132, 3213, 3321. **18 set in tutto.** Poi, SOLO per i candidati che superano G1-G3 (max 3), i **vicini a un passo** (un fattore alla volta, +/-1 livello: fino a 8 per candidato).
**Contatore di tentativi di questa campagna:** 18 + fino a 24 vicini = **fino a 42 set guardati**.

## 4. Finestre (dati FTMO)
- **Dentro-campione (IS): 2015-01-01 -> 2020-12-31** (sei anni; per G3 diviso in 2015-2017 e 2018-2020).
- **OOS1:** 2021-01-01 -> 2022-12-31. **OOS2:** 2023-01-01 -> 2024-12-31.
- **Hold-out: 2025-01-01 -> 2026-10-31**, a candele (tick FTMO non disponibili), **aperto UNA volta** solo per i finalisti. **Limite dichiarato:** non e un hold-out puro: l'andamento dell'oro nel 2025-26 e gia noto a noi (analisi precedenti con i set di Wim) e l'idea "breakout sull'oro" ne e influenzata; l'unica prova indipendente e il forward.
- Tick: i tick FTMO non sono scaricati. Controllo di fedelta a tick sul **BCM** (tick locali 2024-07-15 -> 2024-12-31): rapporto PF tick/candele, DD tick/candele, operazioni. E un **proxy** (broker diverso), non una prova FTMO; si dichiara.

## 5. Costi
Il tester FTMO puo non includere commissioni/slippage reali (NON VERIFICATO). Si calcola il **risultato netto = risultato del tester - 36 EUR per lotto a giro** (scenario centrale gia usato per l'oro, `COMBINAZIONI_SOLO_ORO`), con 0,1 lotti = 3,6 EUR a operazione, e si valuta tutto sul netto (scenario prudente: 72 EUR/lotto).

## 6. Soglie (porte, in ordine; chi non passa una porta si ferma li)
- **G1 (IS, netto):** profitto > 0, PF >= 1,30, operazioni >= 100, recovery >= 1,5, **statistica t >= 3,0** calcolata sul profitto netto per giornata con operazioni (serie di `Esporta_Operazioni.ps1`; soglia di 3,0 perche si guardano fino a ~40 set: 0,05/40 e circa p=0,001 monolaterale). Nessun requisito di DD assoluto qui: il DD si riporta per ogni set.
- **G2 (perturbazione):** vicini a un passo: >= 70% in profitto e PF mediano >= 0,8 x PF del candidato.
- **G3 (stabilita interna):** profitto > 0 e PF >= 1,10 in **entrambe** le meta dell'IS (2015-2017 e 2018-2020).
- **G4 (OOS1 e OOS2, netto):** PF >= 1,20 e profitto > 0 in **entrambe**, almeno 20 operazioni ciascuna, efficienza walk-forward (profitto/mese OOS su IS) >= 0,5.
- **G5 (hold-out):** profitto > 0 e PF >= 1,15; e **informativo**, non d'approvazione: serve il forward.
- **G6 (tick, proxy BCM):** PF tick/candele >= 0,7; DD tick <= 1,5 x candele; operazioni +/- 10%.
- **Scelta tra i sopravvissuti:** il centro di una **zona stabile** (la maggior parte dei vicini in profitto), non il massimo di PF.

## 7. Confronto con Wim e correlazione (nessuna soglia di approvazione, solo etichetta)
Profitto netto giornaliero del candidato contro quello del set C0 di Wim (GTP E, FTMO, stessi giorni): `Correlazione.py`, valore piu alto tra giornaliero e settimanale: <= 0,30 diverso, 0,30-0,60 parente, > 0,60 stessa cosa. Si riporta anche il numero di operazioni in comune per giorno di ingresso. **Uso:** dice quanto diversifica il bundle; **non** e il criterio di FTMO (ignoto).

## 8. Previsioni (scritte ora)
- Almeno un set dei 18 ha PF netto >= 1,30 con >= 100 operazioni in IS: **65%**.
- Almeno un set passa G1: **40%** (la soglia t = 3,0 e severa).
- Almeno un set passa G1-G4: **25%**.
- Un finalista passa anche G5 (hold-out): **15%**; passa G6 (tick, proxy): **12%** (i breakout con stop stretti perdono a tick).
- Il migliore ha D1 come timeframe: 60%.
- Correlazione con Wim C0 del finalista >= 0,30: **70%** (>= 0,60: 25%).
- La zona migliore ha target 2,0-3,0 R: 55%.

## 9. Regole d'arresto
- Se nessuno dei 18 supera G1: scrivo **"nessun candidato"** per questo disegno, riporto il miglior PF/t come informazione e **mi fermo**: nessun secondo batch senza criteri nuovi scritti prima (massimo UN secondo giro di criteri, e solo se Claudio lo decide).
- Soglie non ritoccate dopo aver visto i numeri. Se un set viene guardato oltre i 42 previsti, il contatore e la soglia di t si aggiornano e si dichiara.
- Nessun set va in demo/conto prima di G1-G4 + decisione di Claudio.

## 10. Cosa serve da Claudio
1. Compilare il template (`Compila_EA.ps1` o F7) e la **passata di controllo a occhio** (P2); incollare eventuali errori.
2. Un terminale FTMO con login valido (o conferma che lo storico basta).
3. Via libera per il giro (PC libero); lancio per il batch via `Run_MT5_Engine.ps1`/`BacktestRunner.ps1` (da adattare ai fattori sopra) con criteri gia scritti.

## 11. Esito della passata di controllo P2 (17/11/2026, aggiunto DOPO il giro: non cambia i criteri sopra)
- **Cosa e stato verificato a mano su 24 operazioni (BCM portable, XAUUSD D1, 2019, riga 1 della griglia L9):** stop = 1,0 ATR e target = 1,5 x stop su tutte le operazioni lette; un ordine opposto cancellato al riempimento; scadenza a 3 barre rispettata; mai due posizioni insieme.
- **Difetto trovato (il 60% previsto in P2):** gli ordini venivano rimessi solo domenica 23:05 e lunedi 00:00. Il Journal del tester (InpDebug) mostra `ordine rifiutato (10018)` = **TRADE_RETCODE_MARKET_CLOSED** a ogni 00:00 da martedi a venerdi: l'EA tentava di armare solo al primo tick della barra D1, a mercato chiuso (pausa giornaliera dell'oro sul BCM) e **non riprovava**; inoltre la cancellazione dei vecchi pendenti non riusciva a mercato chiuso. Risultato: gli ordini erano attivi quasi solo a inizio settimana.
- **Correzione (template 1.02):** l'armamento si ripete una volta al minuto finche non riesce (cancellazione dei vecchi pendenti + nuovi ordini); gli esiti di Piazza distinguono rifiuto transitorio (mercato chiuso/senza quotazioni: si riprova) da rifiuto per regola (non si riprova).
- **I numeri del giro (-1.117,55, PF 0,47, 24 operazioni) NON si usano**: erano generati dal difetto. Nessuna soglia cambia. P2 va ripetuta con la versione 1.02 prima di lanciare il batch dei 18 set.
- Osservazioni utili emerse, da tenere presenti per i costi: **swap sul BCM molto pesante sui long dell'oro** (circa -8,7 EUR a notte per 0,1 lotti: una prima operazione al target, +127,77 lordi, ha chiuso a -88,79 netti dopo 23 notti di swap); commissione solo -0,18 EUR a operazione; la **candela D1 della domenica (1 ora) del BCM** altera ATR e livelli del lunedi (assente sui dati FTMO). Le decisioni restano sui dati FTMO; lo swap FTMO va misurato.

## 12. P2 ripetuta con il template 1.02 (17/11/2026, sera; BCM portable, XAUUSD D1, 2019-01-01 -> 2019-03-01) - esito
- **Riarmo giornaliero ora funziona:** da martedi a venerdi gli ordini vengono rimessi alle 00:05 (a 00:00-00:04 il Journal mostra 10018 = mercato chiuso e `riprovo`; 60 rifiuti in tutto, tutti 10018, alle 00:00-00:04). Domenica 23:05 e lunedi 00:00 il mercato e aperto (arma subito). I vecchi pendenti vengono cancellati solo quando il mercato riapre (00:05) e subito sostituiti.
- **Regole verificate sulle 5 operazioni del giro:** stop = 1,0 ATR e target = 1,5 x stop (es. buy 1324,25 / stop 1315,42 / target 1337,49); un ordine opposto cancellato al riempimento; una sola posizione alla volta; nessun ordine duplicato; il test chiude l'ultima posizione a fine test.
- **Comportamento di progetto da non scambiare per un difetto:** quando il prezzo e a meno di 0,2 ATR dal livello (regola `InpMinDistLevelAtr`) l'ordine su quel lato non viene piazzato (29/01 e 30/01: 1 solo ordine invece di 2); dopo una chiusura nella stessa barra non si riarma fino alla barra successiva.
- **Verdetto P2 (BCM): superata.** Il prossimo passo e P3: stesso controllo sul terminale FTMO (dati e orari di pausa possono essere diversi) prima del batch dei 18 set. Previsione scritta ora: il tester FTMO parte anche con il login scaduto (storico locale): 70%; l'armamento giornaliero funziona senza modifiche: 75%.

## 13. P3: controllo sul terminale FTMO (17/11/2026, sera) - esito
- **Il tester FTMO parte anche con il login scaduto** (storico locale): previsione 70%, confermata.
- **Armamento giornaliero senza modifiche:** funziona (previsione 75%, confermata). Su FTMO a mezzanotte server (00:00) il mercato dell'oro e chiuso (10018) e riapre alle **01:05 server** (= 00:05 ora italiana, identico al BCM dove riapre alle 00:05 server): la pausa e la stessa nel tempo reale, cambia solo l'ora del server. L'EA riprova al minuto e arma alle 01:05.
- **Nessuna candela D1 della domenica sui dati FTMO** (le barre iniziano lunedi-venerdi): sul BCM ATR e livelli del lunedi erano alterati. Esempio sul 02/01/2019: ATR implicito 11,40 su FTMO contro 9,71 sul BCM (le candele D1 hanno anche tagli diversi: non sono confrontabili 1:1).
- **Swap:** il long dell'oro costa meno su FTMO (circa -5,6 EUR a notte per 0,1 lotti nella prima operazione, 23 notti: -127,97) che sul BCM (-9,4 a notte); commissione -0,08 EUR a deal. Da misurare nel batch.
- **Regole verificate:** stop 1,0 ATR e target 1,5 R, ordine opposto cancellato al riempimento, una sola posizione. **P3 superata.** Si puo lanciare il batch dei 18 set (porta G1) su FTMO.
