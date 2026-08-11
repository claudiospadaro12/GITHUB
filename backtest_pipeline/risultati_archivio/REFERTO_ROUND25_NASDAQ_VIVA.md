# REFERTO R25 — la config VIVA del Nasdaq base (11/08 sera): BOCCIATA
# E il colpevole ha un nome: manca il filtro volumi

## I numeri (tick reali, 1%, sweep del RangeMode a parita' di tutto)

| RangeMode | IS | OOS |
|---|---|---|
| OPENING | +330 (PF 1,11) | -720 (PF 0,85) |
| PRE-apertura | +100 (PF 1,03) | -935 (PF 0,86) |
| **PREVBAR (la cella VIVA)** | **+649 (PF 1,24)** | **-764 (PF 0,88, DD 17%)** |

- **Tutte e tre rosse fuori campione**: il motore BREAKOUT senza filtro
  non ha edge sul Nasdaq con NESSUN range. Ri-conferma su dati freschi
  del verdetto del 02/08 (famiglia breakout eliminata).
- **La cella viva e' la 18^ apparizione del ribaltamento**: la migliore
  in campione (+649, PF 1,24 — proprio il tipo di numero che convince
  ad accendere un grafico) e rossa fuori. PREVBAR si conferma il
  RangeMode del vizio: bello dentro, morto fuori.

## Il tesoro nel confronto R24 vs R25 (stessa base, UNA differenza)

| Config (BREAKOUT+PREVBAR) | IS | OOS |
|---|---|---|
| SENZA volumi (R25 = grafico vivo) | +649 | **-764** |
| CON volumi 1,5 AND (R24) | +70 | **+476 (PF 1,27)** |

**Il filtro volumi da solo vale +1.240 EUR di OOS: e' l'UNICO edge del
Nasdaq Apertura.** Terza conferma indipendente dell'ablazione del 03/08
("su sei filtri candidati ne funziona uno solo: i volumi").

## DECISIONE (regola pre-dichiarata nel file di prova: cella viva
## bocciata -> allineare o spegnere)
**ALLINEARE il grafico vivo alla config misurata**: accendere il filtro
volumi sul Nasdaq base del piccolo — 2 input da cambiare:
`InpUseVolumeFilter=true` e `InpConfirmMode=AND` (VolMult 1,5 e' gia'
il default; ATR gia' spento). Da fare A MERCATO FERMO (domattina prima
delle 14:30 server), con screenshot di verifica. Il rischio resta 0,25%.
Status invariato: osservato, non candidato (IS +70 resta esile).
