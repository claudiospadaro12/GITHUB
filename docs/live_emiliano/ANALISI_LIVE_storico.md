# Analisi live STORICHE Emiliano/Paolo (apr–mag 2026) — estrazione per EA

Sigle: **FIBA H4** = Fibonacci H4 · **WOL** = Weekly Open Line (protocollo del martedì) · **PTE** = canali TMA su iperestensione ("PTE l'ho creata io" – Emiliano) · **SuperTrend Inverte** = il nostro SupertrendReversal.

## Priorità (dal più azionabile)
1. **SupertrendReversal** — aggiungere filtri: MA50 taglia il ST + ordine MA200 (200 sopra 50 se short / sotto se long); **medie NON intrecciate** (50 diverge dalla 200) = evita laterale; **DX/ADX** soglie 20/25/50; **StdDev crescente**; MA200 come barriera. Entry su terzo ST, setup H1 / trigger M15. Stop dietro il ST. (stocastico RIMOSSO da Paolo.)
2. **Motore Apertura** — (a) filtro **volume breakout ≥ +50%** sulla media; (b) modulo **Larry "cost-to-cost"** per tradare DENTRO il range ORB; (c) **VWAP M15** come spartiacque (sopra=supporto/sotto=resistenza); (d) gap-fill in giornata; (e) 2° ingresso su Fibo 50/61.8 dell'impulso.
3. **PTE** — verificare che l'EA usi **canali TMA fast+slow** (non Bollinger/VWAP): candela (in **Heikin Ashi**) **fuori da ENTRAMBI** i canali = segnale forte; + **pattern di inversione** (doji/engulfing/hammer/tombstone/dragonfly) + **livello tecnico** (S/R, ST, media) che interseca entro N pip. TF H4/D1 (H1 solo con livello D1/W). No indici.
4. **FiboH4** — **laddering a 3 ordini**: limite al **50%**, ordine più grande poco prima **MA200**, il più grosso a **61.8**; **SL** sotto struttura; **TP su MA14** (RR ~1:1 sul primo); filtro **ADR-in-giornata** (TP raggiungibile con la volatilità del giorno); **re-entry** quando il prezzo supera lo swing precedente. Livelli: 23.6 debole, 38.2 sano, 50 psic., golden fino 61.8, rottura 100 = cambio carattere. Estensioni 127 (parziale) / 161.8 (esci). Swing = ZigZag depth 12.
5. **WOL (Weekly Open Line)** — martedì: sopra WOL = bias long, sotto = short. **2 pattern:** apre SOPRA la WOL a fine trend → inversione (WOL supporto); apre SOTTO → continuazione. Filtro posizione mediana della doji; **scarta doji notturne (~23:00)**; pendenti **post-rollover (~mezzanotte)**; TP MA14; filtro ADR.

## Nuove strategie costruibili
6. **Bollinger Squeeze / Band-riding** [MECCANIZZABILE, nuova]: squeeze = bande parallele + **StdDev piatta/sotto la SMA**; entry quando la **3ª candela chiude FUORI banda**; **SL sulla banda opposta**; **BE dopo 15-20 pip**. (Paolo ammette molti falsi breakout.)
7. **Filtro FVG/Imbalance** [MECCANIZZABILE, filtro trasversale]: dopo candela veloce con imbalance → se la successiva chiude **dentro** l'imbalance = rientro (fade); se chiude **oltre** = continuazione. Utile per PostNews e apertura.
8. **Cost-to-cost range trading** [priorità media]: **pomeriggio > 17:00 IT** (bassa volatilità), bande parallele + StdDev sotto la linea gialla; entra alla banda, target mediana, parzializza. Squeeze-straddle rischioso (doppio riempimento); su news NON funziona.

## Le "5 forze" di Emiliano (checklist di conferma)
1) supporto/resistenza · 2) condizione di eccesso · 3) massimo/minimo assoluto · 4) candela d'origine · 5) conferma.

## Note utili (non EA a sé)
- **Correlazione DAX vs S&P**: se DAX fermo mentre S&P sale, alla discesa dell'S&P il DAX scende **più forte** (peso automotive/energia). → filtro direzione apertura DAX + già nel report.
- ADR DAX ~**489-500 punti** (10 settimane) → conferma/quantifica il filtro ADR ~0,8.

## Discrezionale / da IGNORARE
Volume/Market Profile (POC, value area) · Wyckoff (Paolo: "non sono ancora bravo") · micro-scalping candela-per-candela di Emiliano · Fibonacci come trend-detection a occhio · oro discrezionale/anti-martingala (già segnato: da EVITARE) · indicatori ancora in beta (ZenFX, forza valute, BOS) → nessuna regola stabile.
