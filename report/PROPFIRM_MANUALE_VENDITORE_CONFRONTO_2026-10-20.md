# Prop Firm Gold EA: cosa dice il manuale del venditore contro come lo abbiamo testato (20/10/2026)

**Non controllata da agenti.** Fonte: 5 screenshot di Claudio della pagina mql5.com/en/blogs/post/765213 (Eriksson Systems, 7/11/2025). Test nostri: `MARKET_TEST_80K_PROPFIRM_LETTURA_2026-10-19.md`, `MARKET_STAB_PROPFIRM_LETTURA_2026-10-19.md`.

## Cosa raccomanda il venditore
- XAUUSD, "qualsiasi timeframe" ma impostazioni rapide: **M30**, **basso rischio (prop firm)**, stop loss piccolo/grande secondo il conto, **protezione drawdown giornaliero ATTIVA (solo prop)**, **backtest OHLC a 1 minuto** (NON ogni tick, NON ticks reali: "la logica gira sull'apertura delle candele M1"), test lungo (2010+), numero magico unico per EA.
- Rischio: lotto fisso sconsigliato; il lotto si adatta alla volatilita'; rischio manuale % = massimo per operazione, fino a 3 operazioni al giorno (1% -> fino a circa 3% al giorno nel caso peggiore). Backtest col rischio sul **saldo iniziale/fisso**, non sul patrimonio netto.
- **La protezione giornaliera chiude TUTTE le posizioni del conto, anche quelle di altri EA**; "sconsigliata per conti personali".
- Saldo minimo 500 USD (1000+ in alta volatilita'); broker con fuso GMT+2/+3 (BCM e' UTC+1 fisso: stessa questione di Gold Reaper / ORB Master, [NON VERIFICATO] se questo EA usa l'orario del broker: non ha input di offset).

## Come l'abbiamo testato (dal referto del 19/10)
H1 (non M30), **ticks reali** (non OHLC 1 minuto), input NON imposti = default/ultimo salvato: `InpRiskType=0, InpRiskLevel=0, InpRiskPercent=0.0, InpLots=0.0, InpBaseMoneyMode=0, InpCloseTradesOnEquityDrawdown=false (limite 4.0), InpActivateTester=false`. Quale livello di rischio sia "0" e cosa sia `InpBaseMoneyMode=0` NON e' verificato (enum non letti).

## Cosa cambia
1. I nostri numeri (+42,7%, PF 1,25, DD 13,8% di 80K) valgono per **H1 coi default**, NON per le "impostazioni rapide consigliate". Con basso rischio e protezione giornaliera il DD potrebbe scendere e il rendimento pure; e la verdetto S-PORT (non passa) puo' cambiare. Non lo so: [NON MISURATO].
2. Ticks reali sono piu' severi/realistici dell'OHLC 1 minuto (spread veri): non e' un difetto del test. Ma se i numeri del venditore nascono da OHLC 1 minuto, il confronto con le sue pagine va fatto con lo stesso modello. Un confronto Modello 4 contro OHLC 1 minuto dice quanto il risultato dipende dal modello.
3. Se si usa sullo stesso conto con Gold Reaper, la protezione giornaliera va lasciata spenta (chiuderebbe anche le sue posizioni): quindi la combinazione va testata senza.

## Prova proposta (non lanciata)
Prop Firm, XAUUSD **M30**, 80K, 01/01/2025-01/10/2026, input del venditore imposti (basso rischio; protezione giornaliera 4% ON e OFF), in due modelli: ticks reali e OHLC 1 minuto. L'esecuzione costa pochi minuti (5K: 151 s). Prima servono i nomi/valori esatti degli enum di `InpRiskType/InpRiskLevel/InpBaseMoneyMode` (dal pannello input dell'EA o da un .set).
