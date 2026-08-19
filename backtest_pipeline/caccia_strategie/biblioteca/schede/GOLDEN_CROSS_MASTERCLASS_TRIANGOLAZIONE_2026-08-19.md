# 🥇 GOLDEN CROSS HA — la triangolazione delle tre fonti (19/08/2026)

_Materiale caricato da Claudio il 19/08 pomeriggio: (1) PDF "MASTERCLASS ABTG —
GOLDEN CROSS HA Strategy" v1.0 del 1 luglio 2026, 12 pagine, letto INTERO in
sessione; (2) `DASHBOARD_GOLDEN_CROSS_V03.ex5` v3.01, input misurati dagli
screenshot della finestra parametri (NASUSD M15); (3) il nostro
`mql5/Experts/ABTG_GoldenCross.mq5`, gia' in campo. Missione madre: "un EA che
regga alle prop" — verifica di fedelta' EA-vs-PDF affidata allo sviluppatore
(scheda separata `VERIFICA_FEDELTA_GOLDENCROSS_PDF_2026-08-19.md`)._

## 1. Il cuore: LE TRE FONTI COINCIDONO sui parametri

| parametro | PDF Masterclass | Dashboard V03 (misurata) | ABTG_GoldenCross (sorgente) |
|---|---|---|---|
| EMA veloce | 9 | **9** | InpEmaFast=9 |
| EMA lenta (trigger) | 21 | **21** | InpEmaMid=21 |
| EMA trend/contesto | 50 | **50** ("EMA TREND operativa") | InpEmaSlow=50 |
| metodo | EMA | **Exponential** | iMA MODE_EMA |
| prezzo | — (implicito close) | **Close price** | PRICE_CLOSE |

Nessuna divergenza sulla tripla 9/21/50. Il "Golden Cross" della Masterclass
NON e' il classico 50/200: e' il 9/21 col 50 come campo di gioco.

## 2. Cos'e' la Dashboard (e cosa NON e')

**E' il RADAR, non il grilletto.** Scanner multi-simbolo e multi-timeframe che
segnala gli incroci EMA9/21 freschi: NON piazza ordini, NON gestisce posizioni.
E' lo strumento della frase-guida del corso: "l'incrocio accende il radar, ma
sono Heiken Ashi, EMA50 e ADX a decidere".

Input misurati (v3.01):
- **Simboli monitorati**: 3 gruppi forex (tutte le majors+cross, 30+ simboli),
  indici JPN225/D30EUR/SPX500/U30USD/NASUSD, commodities XAUUSD/USOIL, slot custom.
- **MA CROSS**: 9/21/50 Exponential su Close; `ShowOnlyFreshCross=true`,
  segnale mantenuto 5 candele chiuse; segnali compatti.
- **Timeframe della griglia**: M15 / H1 / H4 / D1 (le fasce "ordinaria" e
  "swing" del cap.4 del PDF — niente M5).
- Alert e push: spenti di default; cooldown 300 s.
- **LICENZA: scadenza 31/12/2026** (sola lettura, intestatario facoltativo) —
  stesso schema di licenza del `PL-SUPERTREND 3_LIVELLI v09 2.4` catalogato il
  19/08 mattina: stessa famiglia di strumenti dei coach (Lavorenti / SM
  Solution). [DA CONFERMARE con Claudio la provenienza esatta]

## 3. Le regole del PDF in una pagina (per i round futuri)

- **Sequenza a 6 fasi**: contesto EMA50 -> trigger incrocio 9/21 ->
  allineamento (prezzo>9>21>50 inclinate) -> momentum (>=3 Heiken Ashi coerenti
  senza stoppino contrario, corpo non in riduzione) -> forza (ADX>20, meglio
  >25, crescente; DI+/DI- coerenti) -> tradeability (stop tecnico, spazio, RR>=1).
- **Distanze ATR** (cap.9.1): ingresso preferibile entro 0,5 ATR dalla EMA9;
  accettabile entro 1 ATR dalla EMA21; oltre = tardivo, si aspetta il pullback.
- **ADX a scala**: <15 no trade · 15-20 solo setup pulitissimo · >20 valutabile
  · >25 preferibile · >35/40 non inseguire.
- **Stop**: minimo significativo / EMA21 / candela di conferma / ATR.
  **Target**: RR 1:1 minimo, 1:1,5 preferibile, 1:2 ideale, tecnici su S/R.
- **Gestione**: a 1R valutare pareggio/parziale; mantenere finche' HA+ADX+medie
  coerenti; uscita su chiusura oltre EMA21, incrocio inverso, cambio colore HA,
  calo ADX.
- **Setup A/B/C** (cap.13): A = tutto allineato + ADX>25 + RR>=1:1,5; B =
  principale ok + ADX>20 + RR>=1:1; C = scartare.
- **MONEY MANAGEMENT (cap.14) — il capitolo PROP**: 0,5% test · 1% ordinario ·
  1,5% MAX solo setup A · MAI >2% · max 2 trade/giorno per strumento · max 3
  complessivi/giorno · **STOP OPERATIVO dopo 2 perdite consecutive** · **stop
  giornaliero -2R/-3R** · mai aumentare la size dopo una perdita.

## 4. Il disegno sperimentale che ne esce

Abbiamo ORA una scala completa dello stesso motore:
1. **ABTG_CrossEma** (nato stamattina): incrocio 9/21 NUDO + filtri singoli — round R86 pronto.
2. **ABTG_GoldenCross** (in campo: 770331/2/3 + 970301 oro): incrocio VESTITO
   con tutti i pilastri della Masterclass.
3. La verifica di fedelta' dira' quanto il vestito in campo combacia col PDF, e
   il cap.14 dira' quali protezioni prop mancano ancora (candidate opt-in).

Stessa molla, gradazione di filtri misurabile cella per cella. I round si
lanciano DOPO il collaudo Guardian (criterio 4 gia' passato il 19/08; resta il
BLOCCO 4 stasera) e si ri-pinnano a un commit nuovo.
