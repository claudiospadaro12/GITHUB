<!-- claude — 2026-09-12T21:32:15 -->

# DOSSIER EA — ABTG_MaxMinNotte_DAX_Short_Ottimizzato

_Generato automaticamente da Claude Code il 2026-09-12 dal repository di progetto. Ogni numero qui dentro e' letto dai file reali; dove manca il dato c'e' scritto **DATO NON DISPONIBILE**._

## 0. Cosa ti chiedo (leggi prima il paragrafo 8: formato di risposta)

I parametri di questo EA sono ottimizzati al massimo o c'e' margine? Mi serve un giudizio sulla ROBUSTEZZA in ottica prop firm: conta il drawdown, non il profitto. Dimmi anche se sospetti overfitting.

---

## 1. Contesto operativo

**Chi sono e cosa faccio**
Sviluppo Expert Advisor per MetaTrader 5 con l'obiettivo di superare e mantenere
le sfide delle **prop firm**. Gli EA girano in forward su un conto demo e vengono
promossi solo dopo che il forward conferma il backtest.

**Ambiente**
- Broker/dati: **BCM**, conto demo 50503392, tipo **hedging**.
- Fuso orario del server BCM: **1 ora indietro rispetto all'ora italiana**.
  Quindi DAX apre 09:00 IT = **08:00 server**, Nasdaq 15:30 IT = **14:30 server**.
  Nei parametri degli EA le ore sono SEMPRE in ora server.
- Simboli: `D30EUR` (DAX), `NASUSD` (Nasdaq), `U30USD` (Dow), `F40EUR` (CAC),
  `XAUUSD` (oro), `EURUSD`, `GBPUSD`.
- Backtest: MT5 Strategy Tester, **modello 4 (tick reali)**, ottimizzazione genetica.
- Ottimizzazioni sul PC di backtest, forward sul VPS.

**Money management**
- Rischio per trade: **1%** del conto (non si ottimizza mai: e' un vincolo, non un parametro).
- Obiettivo: sopravvivere ai limiti della prop firm → conta il **drawdown**, non il rendimento.
- Limiti prop tipici da rispettare: perdita giornaliera e drawdown massimo totale.
  DA COMPILARE con i valori esatti della tua sfida: daily loss ___%, max DD ___%,
  target ___%, giorni minimi ___.

**Regole fisse di progetto**
- Gli EA `_Ottimizzato` girano **in parallelo** agli originali (magic number diverso),
  non li sostituiscono: dopo il forward si tiene il migliore.
- I set di parametri si scelgono per **plateau** (zona stabile), mai per il picco isolato.
- Lo storico di alcuni indici CFD e' corto: i numeri vanno presi con le pinze.

## 2. Strategia dell'EA (intestazione del sorgente)

```
------------------------------------------------------------------
ABTG_MaxMinNotte.mq5
EA "MAX-MIN DELLA NOTTE" - MetaTrader 5 - VERSIONE TUTTO-IN-UNO
(metti in MQL5\Experts e compila con F7: niente cartelle)
Basato sul "Piano di trading Strategia MAX-MIN Notte" (ABTG).
LOGICA:
1) BOX NOTTURNO: max/min della sessione notturna (default
00:00-05:59 CET). Gli orari qui sono in ORA SERVER.
2) Pre-apertura (~08:59 CET) piazza ordini pendenti:
BUY STOP sopra il MAX notte +buffer, SELL STOP sotto il
MIN notte -buffer. OCO (parte uno -> cancella l'altro).
3) SL: estremo opposto del box, ATR M15, o punti fissi.
4) Target: 1o a R/R 1:1 (parziale + stop in pari), runner
verso EMA200 (mgmt TF) con trailing; 2o target opzionale.
5) Cancella i pendenti non eseguiti / chiude entro le 18:30.
6) Filtri opzionali: correlazione (SPX500) e news (CSV).
ATTENZIONE Orari in ORA SERVER (controlla sul TUO grafico).
Nessun EA garantisce profitti. TESTA SU DEMO.
------------------------------------------------------------------
```

- File: `mql5/Experts/ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5`
- Magic number: 770411

## 3. Parametri ATTUALI (valori che girano adesso)

| Gruppo | Parametro | Tipo | Valore attuale | Nota nel codice |
|---|---|---|---|---|
| Box notturno (ORA SERVER!) | `InpBoxStartHour` | int | `23` | Ora inizio box (server). BCM: 23 = 00:00 CET |
| Box notturno (ORA SERVER!) | `InpBoxStartMin` | int | `0` | Minuti inizio box |
| Box notturno (ORA SERVER!) | `InpBoxEndHour` | int | `4` | Ora fine box (server). BCM: 4:59 = 05:59 CET |
| Box notturno (ORA SERVER!) | `InpBoxEndMin` | int | `59` | Minuti fine box |
| Box notturno (ORA SERVER!) | `InpMinBoxPts` | double | `0` | Ampiezza MIN del box in punti (0=off; filtro anti-lateralita') |
| Box notturno (ORA SERVER!) | `InpMaxBoxPts` | double | `0` | Ampiezza MAX del box in punti (0=off) |
| Piazzamento e chiusura (ORA SERVER) | `InpPlaceHour` | int | `7` | Ora piazzamento ordini (server). BCM: 7:59 = 08:59 CET |
| Piazzamento e chiusura (ORA SERVER) | `InpPlaceMin` | int | `59` |  |
| Piazzamento e chiusura (ORA SERVER) | `InpEntryCutoffHour` | int | `8` | CUTOFF ingressi (server): dopo, cancella i pendenti non scattati |
| Piazzamento e chiusura (ORA SERVER) | `InpEntryCutoffMin` | int | `30` | BCM: 8:30 = 09:30 CET (solo la rottura "fresca" dell'apertura) |
| Piazzamento e chiusura (ORA SERVER) | `InpCloseHour` | int | `17` | Ora cancellazione/flat (server). BCM: 17:30 = 18:30 CET |
| Piazzamento e chiusura (ORA SERVER) | `InpCloseMin` | int | `30` |  |
| Piazzamento e chiusura (ORA SERVER) | `InpCloseAtEnd` | bool | `true` | Chiudi posizioni residue a fine finestra |
| Piazzamento e chiusura (ORA SERVER) | `InpOneTradePerDay` | bool | `true` |  |
| Piazzamento e chiusura (ORA SERVER) | `InpPendingExpiryMin` | int | `90` | Cancella il pendente non eseguito dopo N minuti |
| Ingresso | `InpBufferPoints` | double | `1000` | OTT DAX short |
| Ingresso | `InpAllowLong` | bool | `false` | OTT: solo SHORT |
| Ingresso | `InpAllowShort` | bool | `true` |  |
| Stop loss | `InpSLMode` | ENUM_MM_SL | `MM_SL_ATR` | Estremo opposto box / ATR M15 / punti fissi |
| Stop loss | `InpMgmtTF` | ENUM_TIMEFRAMES | `PERIOD_M15` | TF di gestione (ATR, EMA200) |
| Stop loss | `InpAtrPeriod` | int | `14` |  |
| Stop loss | `InpAtrSLmult` | double | `2.5` | OTT DAX short real-tick |
| Stop loss | `InpSLFixedPts` | double | `3000` | (FIXED) stop in punti (DAX BCM: 3000 = 30 punti indice) |
| Target e gestione | `InpTP1_R` | double | `1.0` | 1o target in R (piano: R/R 1:1) |
| Target e gestione | `InpTP1Pct` | double | `50` | % chiusa al 1o target |
| Target e gestione | `InpBreakeven` | bool | `true` | Stop in pari dopo la 1a parziale |
| Target e gestione | `InpTP2_R` | double | `3.0` | OTT DAX short |
| Target e gestione | `InpTP2Pct` | double | `50` | % (del residuo) chiusa al 2o target |
| Target e gestione | `InpUseEMA200Target` | bool | `true` | 3o target = EMA200 sul TF di gestione |
| Target e gestione | `InpEMA200Period` | int | `200` |  |
| Target e gestione | `InpTPfinal_R` | double | `4.0` | Target di sicurezza sull'ordine (in R) |
| Target e gestione | `InpUseTrailing` | bool | `true` |  |
| Target e gestione | `InpTrailAtrMult` | double | `2.0` | Trailing = X * ATR (mgmt TF) |
| Filtro correlazione (opzionale) | `InpUseCorrelation` | bool | `true` | OTT: filtro correlazione S&P ON (chiave!) |
| Filtro correlazione (opzionale) | `InpCorrSymbol` | string | `"SPXUSD"` |  |
| Filtro correlazione (opzionale) | `InpCorrTF` | ENUM_TIMEFRAMES | `PERIOD_H1` |  |
| Filtro correlazione (opzionale) | `InpCorrEmaFast` | int | `14` |  |
| Filtro correlazione (opzionale) | `InpCorrEmaSlow` | int | `100` |  |
| Rischio | `InpRiskPercent` | double | `1.0` | OTT: rischio 1% |
| Filtro notizie (CSV in MQL5/Files) | `InpUseNewsFilter` | bool | `false` |  |
| Filtro notizie (CSV in MQL5/Files) | `InpNewsFile` | string | `"abtg_news.csv"` |  |
| Filtro notizie (CSV in MQL5/Files) | `InpNewsMinImpact` | int | `3` |  |
| Filtro notizie (CSV in MQL5/Files) | `InpNewsBeforeMin` | int | `30` |  |
| Filtro notizie (CSV in MQL5/Files) | `InpNewsAfterMin` | int | `30` |  |
| Filtro notizie (CSV in MQL5/Files) | `InpNewsShiftMinutes` | int | `0` |  |
| Filtro notizie (CSV in MQL5/Files) | `InpNewsCurrencies` | string | `""` |  |
| Filtro notizie (CSV in MQL5/Files) | `InpNewsFlatten` | bool | `true` |  |
| Generali | `InpComment` | string | `"MAXMIN DAX SHORT"` |  |
| Generali | `InpMagic` | long | `770411` |  |
| Generali | `InpMaxSpread` | int | `0` |  |
| Generali | `InpVerbose` | bool | `true` |  |

## 4. Griglia di ottimizzazione usata

> ATTENZIONE: questa variante non ha una sua voce in `ea_config.json`. Quella qui sotto e' la griglia dell'EA di partenza **ABTG_MaxMinNotte**: i valori attuali della sezione 3 possono stare FUORI da questi range.

- simbolo: `D30EUR` — timeframe: `M15`
- periodo backtest: 2024.01.01 → 2026.06.30, deposito 10000 EUR, modello 4 (4 = tick reali), criterio 6

| Parametro | start | step | stop | n. valori |
|---|---|---|---|---|
| `InpBufferPoints` | 200 | 200 | 2000 | 10 |
| `InpAtrSLmult` | 1.0 | 0.5 | 3.0 | 5 |
| `InpTP2_R` | 1.5 | 0.5 | 4.0 | 6 |

## 5. Risultati di ottimizzazione (dai file reali del tester)

### File `backtest_pipeline/risultati_archivio/MaxMinNotte/valid_MaxMin_DAX_short_refine.csv`

- combinazioni testate: **36**
- combinazioni in profitto: **32 (88%)** ← superficie robusta se alta, fortuna isolata se bassa
- combinazioni con almeno 20 trade: 36

**Top set (per Profit Factor):**

| PF | Profit | Trade | DD% | Recovery | InpMinBoxPts | InpBufferPoints | InpAtrSLmult | InpUseCorrelation |
|---|---|---|---|---|---|---|---|---|
| 2.25 | 1163 | 38 | 3.2 | 3.54 | 0 | 1300 | 2.5 | 1 |
| 2.25 | 1163 | 38 | 3.2 | 3.54 | 1500 | 1300 | 2.5 | 1 |
| 2.10 | 1040 | 39 | 3.5 | 2.95 | 0 | 700 | 2.0 | 1 |
| 2.10 | 1040 | 39 | 3.5 | 2.95 | 1500 | 700 | 2.0 | 1 |
| 2.05 | 1112 | 41 | 3.1 | 3.58 | 0 | 1000 | 2.5 | 1 |

**Robustezza per singolo parametro** (per ogni valore: quante combinazioni restano in profitto e il PF mediano):

- `InpMinBoxPts` → 0: 88% pos, PF med 1.21 | 1500: 88% pos, PF med 1.21
- `InpBufferPoints` → 700: 83% pos, PF med 1.17 | 1000: 100% pos, PF med 1.22 | 1300: 83% pos, PF med 1.20
- `InpAtrSLmult` → 1.5: 83% pos, PF med 1.18 | 2.0: 83% pos, PF med 1.21 | 2.5: 100% pos, PF med 1.57
- `InpUseCorrelation` → 0: 77% pos, PF med 1.18 | 1: 100% pos, PF med 1.75



## 6. Note di progetto su questo EA (backtest annotati / forward demo)

**backtest_pipeline/TRACKING_FORWARD.md**
```
| 770411 | MaxMinNotte_DAX_Short_Ottimizzato | D30EUR | M15 | 2.05 | 3.1% |
| (nativo) | MaxMinNotte | edge solo DAX short |
```

**backtest_pipeline/RIEPILOGO_FORWARD.md**
```
| 8 | ABTG_MaxMinNotte_DAX_Short_Ottimizzato | DAX | D30EUR | M15 | **SHORT** | 2.05 | 3.1 | 770411 |
- **D30EUR M15** → MaxMinNotte_DAX_Short (night-box SHORT)
- **MaxMinNotte** su FTSE/CAC/Stoxx: solo il DAX (SHORT + correlazione) rende.
```

**backtest_pipeline/RISULTATI_OTTIMIZZAZIONE.md**
```
| MaxMinNotte | D30EUR | 8% | ❌ nessun edge, DD 22% |
DAX_Apertura_EU, DAX_M3, DAX_Live5m, MaxMinNotte, FiboH4_Multi, Londra_ORB,
```

**backtest_pipeline/CLASSIFICA_PF.md**
```
| 4 | MaxMinNotte_DAX_Short_Ottimizzato | DAX D30EUR | M15 | 770411 | 2.05 | 3.1 | | | |
| MaxMinNotte (default) | DAX D30EUR | M15 | ~1.0 | solo SHORT+corr rende | | |
```

**backtest_pipeline/REGISTRO_TEST.md**
```
## MaxMinNotte — rottura range notturno all'apertura europea (26.07.26, real-tick)
- Promosso: `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` (magic 770411) — short only, corr S&P ON, buffer 1000, SL ATR x2.5, TP2 3.0, rischio 1%.
```

## 7. Limiti dichiarati (per non farti trarre in inganno)

- Lo storico di alcuni indici CFD e' corto: i numeri di backtest hanno un intervallo di confidenza ampio.
- Il backtest NON misura lo slippage reale; negli EA delle aperture si paga uno slippage fisso simulato.
- La validazione vera e' il forward in demo, non il backtest.
- Se ti serve un dato che qui non c'e', NON stimarlo: chiedilo esplicitamente nel campo `domande_a_claude`.

## 8. Protocollo di risposta (OBBLIGATORIO)

Sei l'IA **revisore** (il "secondo parere") in un confronto tra due IA su Expert
Advisor per MetaTrader 5, sviluppati per superare le sfide delle prop firm.
L'altra IA (Claude Code) ha scritto il codice e ha fatto le ottimizzazioni: il tuo
compito NON e' compiacerla, e' trovare quello che non torna.

**Regole del confronto**

1. Giudica la **robustezza**, non il profitto di backtest. Un set che rende tanto
   in un solo punto della griglia vale meno di un set un po' peggiore ma circondato
   da valori vicini che rendono anche loro (plateau).
2. Usa **solo** i numeri contenuti nel dossier. Non inventare metriche, non stimare
   valori "plausibili". Se un dato ti serve e non c'e', mettilo in `domande_a_claude`.
3. Segnala esplicitamente i sospetti di **overfitting** (pochi trade, parametri troppi
   rispetto ai trade, picco isolato, periodo di test corto, curve fitting sull'orario).
4. Ricorda i vincoli della prop firm: quello che conta e' il **drawdown massimo** e la
   **perdita giornaliera**, non il rendimento. Un EA con PF alto ma DD che sfonda il
   limite e' un EA bocciato.
5. Ogni proposta di modifica deve essere **verificabile**: indica il test da lanciare
   (parametro, range, periodo, simbolo) e cosa ti aspetti di vedere se hai ragione.
6. Se la risposta onesta e' "i parametri sono gia' a posto, non toccare niente",
   dilla: non inventare miglioramenti per avere qualcosa da dire.
7. Scrivi in italiano, in modo diretto. Niente disclaimer generici sul rischio.

**Formato di risposta OBBLIGATORIO**

Prima la parte discorsiva (analisi libera, quanto vuoi), poi — come **ultima cosa
del messaggio** — un blocco di codice ```json con esattamente questa struttura:

```json
{
  "ea": "nome dell'EA",
  "verdetto": "ottimizzato | migliorabile | da_rifare",
  "punteggio_robustezza": 7,
  "fiducia": "alta | media | bassa",
  "criticita": [
    {"gravita": "alta|media|bassa", "punto": "cosa non va", "perche": "sulla base di quale dato del dossier"}
  ],
  "proposte": [
    {
      "parametro": "InpXxx",
      "valore_attuale": "3.0",
      "valore_proposto": "2.5-3.5 da riottimizzare",
      "motivo": "...",
      "come_verificare": "test da lanciare e risultato atteso"
    }
  ],
  "test_da_lanciare": ["descrizione compatta del test 1", "test 2"],
  "domande_a_claude": ["dati che ti mancano per giudicare"]
}
```

Il blocco JSON viene letto da un programma: niente commenti dentro, niente virgole
finali, usa `punteggio_robustezza` da 0 a 10 (10 = set robusto, non toccherei nulla).
