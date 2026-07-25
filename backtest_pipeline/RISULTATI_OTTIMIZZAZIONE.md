# Risultati ottimizzazione REAL TICK (modello 4) — 25/07/2026

Ottimizzazione genetica su **tick reali** (non su 1-min OHLC). Criterio: robustezza,
non il picco di profitto. Per ogni EA ho guardato **quante combinazioni sono in
profitto** (superficie robusta) e ho scelto un punto **stabile** (tanti trade, DD
basso, PF e Recovery buoni), NON il massimo isolato (che è overfit).

## Sintesi onesta

| EA | Simbolo | % combinazioni positive | Verdetto |
|----|---------|------------------------|----------|
| **EMA200** | XAUUSD | **100%** (120/120) | ✅ EDGE FORTE — tieni |
| **GoldenCross** | XAUUSD | **93%** (60/64) | ✅ EDGE BUONO — tieni |
| **Nightly** | EURUSD | **84%** (119/141) | ✅ EDGE BUONO — tieni |
| Nasdaq_Apertura_US | NASUSD | 34% | 🟡 MARGINALE — vale un forward |
| Nasdaq_Live5m | NASUSD | 40% | 🟡 debole (PF max 1.14) |
| DAX_M3 | D30EUR | 21% | ❌ debole, DD 21% |
| FiboH4_Multi | GBPUSD | 28% | ❌ nessun edge (PF max 1.11) |
| MaxMinNotte | D30EUR | 8% | ❌ nessun edge, DD 22% |
| **DAX_Apertura_EU** | D30EUR | **3%** (5/150) | ❌ NESSUN EDGE su tick reali |
| DAX_Live5m | D30EUR | 0% | ❌ morto (DD 45%) |
| Londra_ORB | GBPUSD | ~poche positive | ❌ nessun edge |
| PostNews | EURUSD | — | ⚠️ 0 trade nel test (file news assente nel backtest) |

### Il dato più importante (e scomodo)
**Su tick reali l'edge è nell'ORO, non nel DAX.** Tutte le strategie DAX (D30EUR)
— comprese le aperture, che erano la tua priorità — vanno da deboli a morte.
Le due gold (EMA200, GoldenCross) sono le più solide di tutto il parco.
L'unica apertura con un edge (marginale) è il **Nasdaq**, non il DAX.

## Parametri robusti scelti (baked nei _Ottimizzato)

**ABTG_EMA200_Ottimizzato** (XAUUSD) — magic 971501
`InpOrder1Atr=0.05, InpOrder2Atr=0.60, InpTP_RR=2.0`
→ PF 1.92, Recovery 3.68, DD 4.4%, 199 trade. Superficie 100% positiva = molto robusto.

**ABTG_GoldenCross_Ottimizzato** (XAUUSD) — magic 970301
`InpAdxMin=15, InpAtrSLmult=1.0, InpTP_R=3.0`
→ PF 1.58, Recovery 1.63, DD 8.2%, 132 trade. (AdxMin=30 uccide la strategia.)

**ABTG_Nightly_Ottimizzato** (EURUSD) — magic 971701
`InpEdgeOffsetPips=2, InpSLatrMult=1.25, InpTPfrac=0.3`
→ PF 1.47, Recovery 5.0, DD 5.0%, 252 trade. Scelto il punto ad alto numero di
trade e DD minimo (NON il picco PF 2.34 a soli 43 trade = overfit).

**ABTG_Nasdaq_Apertura_US_Ottimizzato** (NASUSD) — magic 970201
`InpRangeMinutes=25, InpBufferPoints=100, InpTrailFixedPts=500` (RangeMode=candela prec.)
→ PF 1.34, Recovery 2.11, DD 11.6%, 340 trade. Marginale ma è l'unica apertura con edge.

## Regola rispettata
Gli _Ottimizzato **non sostituiscono** gli originali: girano **in parallelo**, con
**magic diverso** (blocco 97xxxx). Falli girare qualche giorno in DEMO a fianco degli
attuali e poi confrontiamo il forward reale.

## NON promossi (nessun _Ottimizzato)
DAX_Apertura_EU, DAX_M3, DAX_Live5m, MaxMinNotte, FiboH4_Multi, Londra_ORB,
Nasdaq_Live5m: nessun edge robusto su tick reali. Costruire un _Ottimizzato qui
vorrebbe dire solo perdere soldi più lentamente.

⚠️ Esiste già `ABTG_DAX_Apertura_EU_Ottimizzato.mq5` (magic 770102) creato **prima**
di questa ottimizzazione a tick reali: NON è validato da questi dati (3% positive).
Consiglio di NON metterlo in forward finché non troviamo parametri che reggano.
