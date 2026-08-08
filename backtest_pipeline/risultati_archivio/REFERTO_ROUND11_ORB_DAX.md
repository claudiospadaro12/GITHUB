# 🔬 REFERTO ROUND 11 — la scheda "Dax Open Range Breakout", misurata

_Girato l'08/08/2026 sera sul laboratorio `ABTG_ORB_Ottimizzato`, tick reali, M5,
D30EUR, 2024.09.26 → 2026.06.30, taglio 40%. Scheda del sito: range 08:00→09:05 IT
(07:00→08:05 server), stop pendenti, SL = 1× range (estremo opposto), TP 2R, uscita
20:50 server, filtro ampiezza minima 0,2% dell'indice, EMA50 direzionale su M5.
File prova: `R11_ORB_DAX_openrange.txt`; sweep sui due filtri = 4 celle._

## I numeri

| filtro 0,2% / EMA50 | IS | OOS |
|---|---:|---:|
| off / off | **+4914,16** · PF 1,437 · DD 6,6% · 171 | **−963,19** · PF 0,940 · DD 29,7% · 267 |
| off / on | +2403,44 · PF 1,280 · 142 | −73,85 · PF 0,995 · 233 |
| on / off | +1473,98 · PF 1,228 · 115 | +108,85 · PF 1,008 · 220 |
| **on / on (scheda completa)** | +177,69 · PF 1,033 · 97 | **+240,16 · PF 1,022 · DD 17,5% · 191** |

Rilevatore storico: 20 trade/mese IS contro 21 OOS — finestre sane, confronto lecito.

## Le tre cose che il round stabilisce

1. **UNDICESIMO ribaltamento IS→OOS, il più simmetrico mai misurato**: l'ordine
   fuori campione è l'esatto rovescio di quello in campione (Spearman −1,0).
   La cella migliore IS (niente filtri, +4914) è la peggiore OOS (−963, DD 30%);
   la peggiore IS (scheda completa) è la migliore OOS. Scegliere dall'IS avrebbe
   comprato il disastro.
2. **I filtri fanno il mestiere già visto sul Nasdaq (R8): da "perde" a
   "pareggia", mai a "guadagna".** La scheda completa fa PF OOS 1,022 con DD
   17,5%: 1,26 euro a trade. Il traguardo pre-dichiarato (PF ≥ 1,10) non è
   raggiunto da nessuna cella. Il tasso di successo dichiarato dalla scheda
   (40-45%) non è verificabile dal CSV, ma con questi PF è irrilevante.
3. **Anche sul DAX il breakout puro d'apertura non paga** — coerente con la
   FASE M, dove il D30EUR si è validato SOLO col RETEST (l'attuale DAX Apertura
   EU). Terza voce della stessa storia: il breakout al tocco perde o pareggia
   su Nasdaq (60+ celle), DAX (4 celle) e — verdetto in arrivo — oro/geometrie
   alternative (R10/R12/R13).

## Verdetto (dal criterio pre-dichiarato in R11)

Nessuna cella al traguardo → **la scheda del sito non aggiunge edge**. Nessun
cambio a niente. La riga XAUUSD del round 10 e le geometrie R12/R13 restano le
ultime carte della batteria.

## Dove sono i numeri

`backtest_pipeline/risultati_prove/ABTG_ORB_Ottimizzato/*_r11.csv`.
