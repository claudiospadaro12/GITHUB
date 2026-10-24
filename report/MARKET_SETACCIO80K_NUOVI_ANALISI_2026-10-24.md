# Screening a 80.000 EUR dei 50 EA nuovi del Market: analisi secca (24/10/2026)
**Natura: MISURA (screening) + LETTURA.** Pin `93099342`, PC di backtest DESKTOP-H4D7CAJ, XAUUSD, 01/01-01/03/2026, H1 e M15, input di default, tick reali (modello 4), **deposito 80.000 EUR**, leva 1:100. Archivio: `backtest_pipeline/risultati_archivio/SETACCIO80K_MARKET_NUOVI_20261024`. Lettore dei set: `backtest_pipeline/leggi_setaccio_nuovi.py`.

## Numeri
- `.ex5` nel Market: **81**; gia conosciuti **31**; nuovi **50**. Setacciati **49** (30 nel primo giro + 19 nella ripresa); **1 bloccato** (Opening Range Breakout MT5, tester fermo oltre 9 minuti) e **1 timeout** (Trend DCA, 20 minuti senza report).
- Con almeno 10 operazioni in una passata: **37**. Con 1-9: **4**. Con **zero**: **8** (7 + Trend DCA). Di quelli con 10 o piu operazioni: **27** con DD equity <= 10% in entrambe le passate, **10** sopra il 10%.
- **Cosa questo NON e:** due mesi, default, solo oro. Non e merito, non sono le soglie S-* (S-N: 150 operazioni in 21 mesi). Le **regole di classificazione qui sotto le ho scritte DOPO aver visto i numeri**: servono a ordinare il lavoro, non a giudicare.

## Regole di ordinamento (post-hoc, dichiarate)
1. **Strumento sbagliato:** un EA con nome da indice, da BTC, da petrolio o da forex major, provato sull oro, e NON MISURATO (inferito dal nome e dagli input).
2. **S-DD:** DD equity > 10% a 80.000 in una delle due passate = scarto per rischio (soglia gia scritta il 19/10, `MARKET_TRIAGE_AGENTI_CRITERI_2026-10-20.md`).
3. **Classe C del triage:** griglia, martingala, recupero o averaging attivi = scarto.
4. **Troppo bello:** crescita irreale in due mesi = rosso, da capire PRIMA di spendere un test a fondo.
5. Il profitto dei due mesi non entra in nessuna regola.

## Tabella (H1/M15)
| Gruppo | EA | operazioni | netto % su 80K | PF | DD equity % | nota |
|---|---|---|---|---|---|---|
| 1. TEST A FONDO 80K, PRIORITA | Gold Snap | 13/13 | 35/35 | molto alto | 3.1/3.1 | triage A; 13 operazioni, 100% vincenti, lotti 3,6-4,3: coda da misurare |
| 1. TEST A FONDO 80K, PRIORITA | SixtyNine EA | 92/119 | 28/32 | 3.32/3.06 | 4.8/4.5 | triage A (33-36 sett. di signal); lotto 0,8-1,0 |
| 10. BLOCCO DEL TESTER | Trend DCA | 0/0 | 0/0 | 0.00/0.00 | 0.0/0.0 | timeout 20 minuti senza report (tester bloccato); DCA = averaging |
| 2. TEST A FONDO 80K | Entry Points Pro Robot | 18/18 | 1/1 | 1.34/1.34 | 2.3/2.3 | 18 operazioni, lotti 0,03-0,23 |
| 2. TEST A FONDO 80K | Microedge Neural Matrix EA | 36/36 | 13/13 | 34.73/34.73 | 3.7/3.7 | lotti 2,4-2,7; PF 35 su 36 operazioni: coda da misurare |
| 2. TEST A FONDO 80K | ORB Revolution | 11/11 | 1/1 | 1.15/1.15 | 5.0/5.0 | 11 operazioni; nome da indice (ORB): strumento da confermare |
| 2. TEST A FONDO 80K | Rocket Breakout EA | 14/24 | 2/9 | 1.21/1.66 | 6.0/4.4 | 14/24 operazioni; DD 6,0/4,4% |
| 2. TEST A FONDO 80K | Umbra Vault AI EA | 42/42 | 11/11 | 16.40/16.40 | 5.0/5.0 | lotti 2,4-2,7; vincita media 300 contro perdita media -35: coda da misurare |
| 2. TEST A FONDO 80K | Vortex Turbo EA | 73/73 | 7/7 | 2.50/2.50 | 3.3/3.3 | lotti 0,4-3,4; Recovery=false |
| 2. TEST A FONDO 80K, ma serve il set di lotto | Diagonal Resistance EA | 357/357 | 3/3 | 3.19/3.19 | 1.5/1.5 | lotto fisso 0,01: serve il set di lotto per 80K; gia in campo sul piccolo (magic 20260728) |
| 3. ROSSO: troppo bello, capire il rischio prima | Aetheris Gold Stack | 390/390 | 167/167 | 4.09/4.09 | 9.8/9.8 | +167% in 2 mesi, 390 ingressi, lotto medio 1,29 (max 2,13), Basket_Stop_USD 8: "stack" = impilamento; troppo bello, rischio da capire PRIMA |
| 4. SERVE IL SET (strumento o periodo) | FundedBridge EA for Prop Firms | 4/9 | -1/1 | 0.21/4.77 | 1.1/0.9 | InpToken vuoto: serve il token/set del venditore (4/9 operazioni) |
| 4. SERVE IL SET (strumento o periodo) | Karat Killer | 38/38 | 10/10 | 1.94/1.94 | 4.9/4.9 | 38 operazioni, PF 1,94, DD 4,9%; input con US500 e XAGUSD: strumento/set da confermare |
| 4. SERVE IL SET (strumento o periodo) | PatternCore | 41/41 | 3/3 | 2.90/2.90 | 0.6/0.6 | portafoglio multi-simbolo (BTCUSD, EURUSD, GBPUSD, NAS100, USDJPY): serve la mappa dei nomi BCM; utile come decorrelazione |
| 4. SERVE IL SET (strumento o periodo) | Prop Firm RM EA | 11/24 | 2/-8 | 1.51/0.27 | 2.7/9.8 | dipende dal periodo: H1 11 op PF 1,51; M15 24 op PF 0,27 DD 9,8%: serve il periodo dichiarato dal venditore |
| 4. SERVE IL SET (strumento o periodo) | PropGuardian Pro | 820/820 | 1/1 | 1.18/1.18 | 0.7/0.7 | forex multi (AUDUSD, EURUSD, USDJPY): 820 operazioni, 21 perdite di fila; serve mappa simboli |
| 4. SERVE IL SET (strumento o periodo) | The ORB Master | 168/168 | -0/-0 | 0.76/0.76 | 0.4/0.4 | opera su D30EUR, NASUSD, SPXUSD, U30USD (indici): PF 0,76 in 2 mesi, 168 operazioni |
| 5. SCARTO per DD sopra 10% a 80K (S-DD) | ArtQuant Gold | 108/108 | -13/-13 | 0.57/0.57 | 23.1/23.1 | DD 23,1%, PF 0,57, -13% |
| 5. SCARTO per DD sopra 10% a 80K (S-DD) | BROKK intraday | 178/178 | 183/183 | 2.88/2.88 | 29.6/29.6 | DD 29,6%; +183% con griglia a intervalli (InpGridIntervalMinutes 30) |
| 5. SCARTO per DD sopra 10% a 80K (S-DD) | Cent Guardian | 1896/1896 | 50/50 | 1.94/1.94 | 12.5/12.5 | DD 12,5% (>10%), griglia (InpTL_ContAllowGrid), 1896 operazioni |
| 5. SCARTO per DD sopra 10% a 80K (S-DD) | Challenge Edge | 9/45 | -6/-8 | 0.47/0.74 | 21.5/18.8 | DD 21,5/18,8%, -6/-8% |
| 5. SCARTO per DD sopra 10% a 80K (S-DD) | Cross Hedge EA MT5 | 698/185 | 0/-18 | 1.03/0.33 | 1.4/18.1 | M15: DD 18,1%, PF 0,33; "hedge" |
| 5. SCARTO per DD sopra 10% a 80K (S-DD) | Gold Sniper Alpha AI Robot MT5 | 83/83 | -17/-17 | 0.65/0.65 | 24.6/24.6 | DD 24,6%, PF 0,65, -17% |
| 6. NON MISURATO: EA da indice provato sull oro | Artemis NAS100 Orb Edge EA MT5 | 1/1 | -0/-0 | 0.00/0.00 | 0.0/0.0 | 1 operazione: EA da Nasdaq provato sull oro |
| 6. NON MISURATO: EA da indice provato sull oro | DAX Robot MT5 | 82/146 | -5/15 | 0.77/3.69 | 67.3/4.9 | EA da indice provato sull oro: H1 DD 67%: NON MISURATO sul DAX |
| 6. NON MISURATO: EA da indice provato sull oro | Dax30 Ea Mt5 Hk | 5/3 | 2/2 | 27.91/30.73 | 6.0/34.9 | 5/3 operazioni: EA da DAX provato sull oro |
| 6. NON MISURATO: EA da indice provato sull oro | Index Bender EA | 91/91 | 6/6 | 1.32/1.32 | 6.5/6.5 | EA da indici provato sull oro: PF 1,32, DD 6,5%, lotto 0,05-0,15 |
| 6. NON MISURATO: EA da indice provato sull oro | Index Sniper Pro MT5 | 18/18 | 2/2 | 4.37/4.37 | 0.8/0.8 | EA da indici provato sull oro: 18 operazioni |
| 6. NON MISURATO: EA da indice provato sull oro | Master Nasdaq FTMO MT5 | 23/16 | -1/-0 | 0.34/0.79 | 0.9/0.6 | EA da Nasdaq provato sull oro: 23/16 operazioni, PF 0,34/0,79 |
| 6. NON MISURATO: EA da indice provato sull oro | NBX Killer EA | 236/236 | 0/0 | 1.48/1.48 | 0.1/0.1 | nome da Nasdaq (NBX): 236 operazioni a lotto 0,01 |
| 6. NON MISURATO: EA da indice provato sull oro | Nasadaq rsi macd | 60/249 | 5/-5 | 1.08/0.97 | 42.8/47.8 | EA da indice provato sull oro: DD 43-48%: NON MISURATO sul Nasdaq |
| 6. NON MISURATO: EA da indice provato sull oro | Nasdaq Hacking Pro | 9/18 | -0/0 | 0.00/1.43 | 0.3/0.1 | EA da Nasdaq provato sull oro: 9/18 operazioni |
| 6. NON MISURATO: EA da indice provato sull oro | The DAX Morning Scalp | 17/17 | -7/-7 | 0.32/0.32 | 8.8/8.8 | EA da DAX provato sull oro: -7%, PF 0,32 |
| 6. NON MISURATO: EA da indice provato sull oro | US100 Nasdaq EA | 4766/4766 | -93/-93 | 0.85/0.85 | 93.7/93.7 | EA da indice provato sull oro: -93%, DD 93,7%: NON MISURATO sul Nasdaq |
| 6. NON MISURATO: EA da indice provato sull oro | USTEC Dynamics Pro | 280/280 | 16/16 | 1.10/1.10 | 15.7/15.7 | EA da indice provato sull oro: DD 15,7%: NON MISURATO su USTEC |
| 7. SCARTO classe C: griglia/recupero attivi | AW Double Grids MT5 | 10/10 | 7/7 | 5.82/5.82 | 3.4/3.4 | griglia con moltiplicatore 1,7 (TypeOfMultiplier 1): classe C |
| 7. SCARTO classe C: griglia/recupero attivi | Epicus Prime MT5 EA | 34/232 | 0/-8 | 2.15/0.16 | 0.1/8.5 | posizioni di recupero attive (APPLY_MaxNumberOfRecoveryPositions=true), BOS_Lot_Multiplier 2,0 |
| 7. SCARTO classe C: griglia/recupero attivi | Squid X | 69/69 | 0/0 | 6.77/6.77 | 0.1/0.1 | griglia attiva (ENABLE_GRID_TRADING=true), lotto 0,01: classe C del triage |
| 8. NON UTILE: opera pochissimo o costi | Daytrade Pro Algo MT5 | 3/3 | 0/0 | 10.82/10.82 | 0.0/0.0 | 3 operazioni |
| 8. NON UTILE: opera pochissimo o costi | Easy Funded MT5 | 1695/1774 | -0/-0 | 0.60/0.63 | 0.5/0.4 | 1695/1774 operazioni, PF 0,60-0,63, profitto circa 0: i costi si mangiano tutto |
| 8. NON UTILE: opera pochissimo o costi | Grabber Bot | 89/168 | -0/-0 | 0.88/0.96 | 0.2/0.2 | 89/168 operazioni, PF 0,88-0,96, profitto circa 0 |
| 8. NON UTILE: opera pochissimo o costi | New Era Gold | 4/10 | 0/0 | 2.42/2.92 | 0.1/0.2 | 4/10 operazioni, DD 0,1%: opera pochissimo |
| 9. ZERO OPERAZIONI: serve capire/set | Mad Turtle | 0/0 | 0/0 | 0.00/0.00 | 0.0/0.0 | 0 operazioni, nessun no money: causa non trovata |
| 9. ZERO OPERAZIONI: serve capire/set | New York Bull | 0/0 | 0/0 | 0.00/0.00 | 0.0/0.0 | 0 operazioni; apertura NY (InpMarketOpenHour=16): da indice, non da oro |
| 9. ZERO OPERAZIONI: serve capire/set | Prophet EA MT5 | 0/0 | 0/0 | 0.00/0.00 | 0.0/0.0 | 0 operazioni; finestra 9:01-17:01, NConsBars 7: causa non trovata |
| 9. ZERO OPERAZIONI: serve capire/set | SNeox AI MT5 | 0/0 | 0/0 | 0.00/0.00 | 0.0/0.0 | 0 operazioni; "Sneox AI Major": da forex major, non da oro |
| 9. ZERO OPERAZIONI: serve capire/set | SomaBTC | 0/0 | 0/0 | 0.00/0.00 | 0.0/0.0 | 0 operazioni: EA da BTC provato sull oro |
| 9. ZERO OPERAZIONI: serve capire/set | SomaGold | 0/0 | 0/0 | 0.00/0.00 | 0.0/0.0 | 0 operazioni su XAUUSD con 32 strategie attive: serve il set |
| 9. ZERO OPERAZIONI: serve capire/set | SomaOil | 0/0 | 0/0 | 0.00/0.00 | 0.0/0.0 | 0 operazioni: EA da petrolio provato sull oro |
| 10. BLOCCO DEL TESTER | Opening Range Breakout MT5 | - | - | - | - | tester fermo oltre 9 minuti in TRANCHE1: NON MISURATO; il nome ha spazi nel .ini (non verificato se e la causa) |
