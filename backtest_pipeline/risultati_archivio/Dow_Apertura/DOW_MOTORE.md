# 🎯 DOW APERTURA — fase MOTORE, tick reali

_03/08/2026. `ABTG_Nasdaq_Apertura_US` su **U30USD** M5 (apertura USA 14:30 server = 15:30 IT), 2024.01–2026.06._
_Replica esatta della FASE A sui P&L veri: range di apertura 15 min, buffer 200 pt, stop sull'estremo opposto, TP a 1,5R, **gestione nuda** (niente parziale, niente BE, niente trailing). 12 pass._

## Risultati

| filtro H4 | filtro volumi | soglia | profit | **PF** | **DD%** | trade |
|---|---|---|---|---|---|---|
| — | — | — | 633 | 1,03 | 14,9 | 445 |
| — | ✔ | 1,2 | 158 | 1,01 | 13,0 | 358 |
| — | ✔ | 1,5 | −157 | 0,99 | 13,5 | 321 |
| — | ✔ | 1,8 | 511 | 1,05 | 8,5 | 288 |
| **✔** | **—** | — | **3 917** | **1,24** | **6,9** | **329** |
| ✔ | ✔ | 1,2 | 2 247 | 1,21 | 7,2 | 247 |
| ✔ | ✔ | 1,5 | 17 | 1,00 | 15,1 | 214 |
| ✔ | ✔ | 1,8 | −286 | 0,96 | 13,2 | 186 |

_(le righe con filtro volumi spento sono ripetute tre volte perché la soglia è inerte: 4 pass ridondanti su 12, previsti)_

## ✅ Il filtro trend H4 funziona sul Dow — confermato sui P&L veri

**PF 1,03 → 1,24. DD 14,9% → 6,9%. Trade 445 → 329.**

Migliora **tutte e tre** le colonne che contano: il PF sale, il drawdown si dimezza, e il campione resta ampio (329 trade, ben oltre la soglia dei 150). Non sta comprando PF pagando in campione — è il contrario di quello che fa il filtro volumi sul Nasdaq, dove per arrivare a PF 1,38 si scende a 80 trade.

La FASE A prevedeva **+0,052 R/trade** dal filtro H4 sul Dow. Il backtest completo, con costi e slippage veri, conferma: **Expected Payoff 11,91 per trade** contro 1,42 senza filtro.

## ❌ Il filtro volumi NON si trasferisce dal Nasdaq

Da solo sul Dow: 1,01 / 0,99 / 1,05 al variare della soglia — **nessun ordine, nessuna tendenza**. È la firma del rumore, la stessa che aveva l'ATR sul Nasdaq.

Peggio: **sopra al filtro H4 fa danno**, e in modo monotòno — 1,24 → 1,21 → 1,00 → 0,96 stringendo la soglia. Sta togliendo trade buoni.

> **Lezione da mettere a verbale: un filtro che funziona su un indice non funziona sull'altro.** Il volume di pre-apertura porta informazione sul Nasdaq (0,90 → 1,15) e zero sul Dow. Il trend H4 porta informazione sul Dow (1,03 → 1,24) ed è dannoso sugli indici europei (FASE A: DAX −0,043, CAC −0,053, IBEX −0,081). **Non esiste "il filtro giusto": esiste il filtro giusto per QUEL mercato.**

## 📊 Dov'è arrivato il Dow rispetto al resto

| | PF | DD | trade |
|---|---|---|---|
| **Dow + H4** | **1,24** | **6,9%** | **329** |
| Nasdaq + volumi 1,5× | 1,15 | 9,6% | 152 |
| Nasdaq + volumi 1,8× | 1,38 | 7,6% | 80 ⚠️ |
| Nasdaq nudo | 0,90 | 34,4% | 482 |

**È il miglior risultato che abbiamo su un sistema di aperture**, e l'unico che regge su tutti e tre i criteri insieme.

## ⚠️ Cosa NON è ancora dimostrato

1. **Il numero dentro l'interruttore non è mai stato testato.** Il filtro H4 usa una EMA a **50 periodi**, scelta e mai messa in discussione. Se il PF 1,24 esiste solo a 50 e crolla a 40 o 60, è una punta fortunata. → **fase `robustezza`**, 10 pass.
2. **Nessun out-of-sample.** Un solo periodo 2024.01–2026.06, nessuna divisione IS/OOS.
3. **Gestione ancora nuda.** Qui non c'è né BE né trailing: il risultato è il valore *grezzo* del segnale. La fase `distanze` dirà quanto se ne può tenere.

## ▶️ Prossimi passi, in ordine

```powershell
# 1) l'altopiano c'e' o no? 10 pass, ~1 ora. Decide se le ore dopo hanno senso.
.\dow_apertura.ps1 -Fase robustezza

# 2) solo se il punto 1 regge: le distanze di gestione. 48 pass.
.\dow_apertura.ps1 -Fase distanze          # gia' tarato su -H4 1 -Vol 0
```
