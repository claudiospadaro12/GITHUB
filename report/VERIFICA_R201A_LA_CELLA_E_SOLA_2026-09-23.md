# 🔍 VERIFICA INDIPENDENTE DI R201A — la cella sotto il muro esiste, **ma è SOLA** (23/09/2026)

Controllo mio sui CSV grezzi, **non ereditato** dal dossier di R222. Zero minuti macchina.
Fonte: `backtest_pipeline/risultati_prove/R201A/ABTG_DAX_Apertura_EU_D30EUR_{IS,OOS}_R201A.csv`
(sedia **`770101`** DAX Apertura EU · D30EUR · **deposito 80.000**, la taglia vera della
challenge · tick reali · rischio 1% · girato il **21/09 alle 19:13**).

Metro: `DD fisso = (Profit/RF)/deposito`, riletto alla taglia di campo (**×2**). È un **limite
superiore rigoroso** della perdita statica FTMO — classe 562: **sotto soglia DIMOSTRA, sopra
NON CONCLUDE**.

## Le sette celle

| `InpBEatR` | DD@2% **IS** | DD@2% **OOS** | sotto il muro del 10% |
|---|---:|---:|---|
| 0,00 *(la cella che vola)* | 11,69% | 🔴 **17,81%** | no / no |
| **0,15** | **7,53%** | 🟢 **8,74%** | 🟢 **SÌ / SÌ** |
| 0,30 | 7,04% | 🔴 14,53% | SÌ / **no** |
| 0,45 | 11,07% | 15,24% | no / no |
| 0,60 | 12,65% | 17,72% | no / no |
| 0,75 | 12,53% | 17,49% | no / no |
| 0,90 | 12,17% | 17,65% | no / no |

## 🔴 IL FATTO CHE AGGIUNGO, e cambia il peso della scoperta

> **Una cella su sette sta sotto il muro in TUTTE E DUE le finestre. Una sola. E non ha vicini.**

`0,00` a sinistra sfonda (17,81%), `0,30` a destra **passa in IS e sfonda in OOS** (7,04% → 14,53%).
👉 Con questa griglia **non si può distinguere un altopiano da un picco**, ed è esattamente la
situazione che la regola di casa del 19/08 descrive: *la cella verde per caso è quella che brucia
la challenge*.

## 🟢 MA IL MECCANISMO TRASFERISCE, e questo è il motivo per cui vale la pena insistere

Correlazione IS→OOS sulle sette celle (calcolata da me):

| grandezza | ρ |
|---|---:|
| **DD@2%** | 🟢 **+0,813** |
| PF | +0,613 |
| profitto | +0,595 |
| RF | +0,094 |

🎯 **L'ordinamento del drawdown regge fuori campione; quello del merito molto meno, e il RF
quasi per niente.** Quindi: *armare il breakeven prima* **abbassa il drawdown per una legge che
tiene**, non per fortuna. È il **valore esatto 0,15** che non è dimostrato, non il meccanismo.

## ⚖️ E il prezzo, che va detto insieme

`0,15` contro la cella viva, in OOS: profitto **8.677 contro 14.355 = −39,6%**.
🟢 Il RF **sale** (2,482 contro 2,015, +23,2%), quindi **non è solo rimpicciolimento**.
🔴 Ma in IS il RF **scende** (0,623 contro 0,652): lì è scaling. Le due finestre **non dicono la
stessa cosa sul merito**, e dicono la stessa cosa sul rischio.

## 🎯 La misura che chiude: **8 passate**

`InpBEatR` = **0,00 · 0,10 · 0,15 · 0,20** × 2 finestre. Dà allo `0,15` i **vicini che oggi non
ha**: se reggono, è un altopiano e la cella si promuove; se crollano come lo `0,30`, era un picco
e **non si schiera**. 🔴 E il per-trade va acceso, perché `n` qui conta **uscite**, non posizioni.

## Cosa NON dice questo referto

1. **Non promuove e non archivia niente.** `InpBEatR` non tocca il lotto (sta solo in gestione
   posizione), quindi il vincolo *"non si abbassa il rischio"* è rispettato — ma la decisione di
   schierare è **di Claudio**.
2. **Il muro GIORNALIERO qui è comprato solo a metà**: `InpBEatR` sul muro giornaliero è
   **inerte** (escursione 0,005 punti su 7 passate). L'altra metà era già passata per conto suo.
3. **`n` è in USCITE, non in posizioni** (270→248): `[NON MISURATO]` in posizioni.
4. Un solo regime, finestra contigua. Nessuna prova di regime.
