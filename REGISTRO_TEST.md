
---

## 21/09/2026 — SEI ROUND SULLE TRE APERTURE (primo giorno di challenge FTMO)

Tutti sul **PC di backtest** `DESKTOP-H4D7CAJ` (firma di Claudio del 21/09: i round
non girano piu' sul VPS finche' una challenge e' viva), tick reali, banco 80.000.
🔵 **Nessuna manopola toccata in campo.** Le sedie hanno operato tutto il giorno
senza che nessuno ci mettesse mano.

| round | sedia | asse | esito | verdetto |
|---|---|---|---|---|
| **R196a** | `770260` Nasdaq | `InpMinRangePts` 0 / 7200 | GIRATO | 🟠 il pavimento compra DD e paga in frequenza (n −27/−33%). PF discordante. **Firma di Claudio**, non data |
| **R197A** | `770202` Dow | `InpEntryMode` breakout / retest | GIRATO | 🟢 **retest confermato**: costa il 15-20% degli ingressi e li ripaga. Col breakout l'IS va in perdita |
| **R197B** | `770202` Dow | `InpRetestOffsetPts` 0..600 | GIRATO | 🟢 **400 confermato** = centro altopiano + miglior DD OOS. La profondita' non costa ingressi |
| **R198** | `770260` Nasdaq | `InpRetestOffsetPts` 0..600 | GIRATO | 🔴 **lo 0 in campo e' l'unica cella positiva OOS.** IS e OOS opposti; la cella 600 fa DD OOS 26,1% |
| **R199A** | `770260` Nasdaq | `InpBEatR` 0..1,5 | GIRATO | 🟢 `0,5` **domina** (PF su, DD giu', n invariato) ma 🔴 **il DD non e' risolto** (OOS 9,12→8,65%). **Firma di Claudio** |
| R200b | `770260` Nasdaq | `InpTrailStartR` | 🛑 **RITIRATO** | la risposta era gia' in archivio (`..._OOS_r24.csv`): il DD sale in 5 righe su 5. E r.2224 dice `<= 0`: **0 e' il pavimento dell'asse** |

### In coda, gatati e non ancora girati
`R200c` (modo di trailing, Nasdaq) · `R172d` (`InpBEatR`, Dow — scritto il **16/09**
e mai girato) · `R201a` (`InpBEatR`, DAX) · `R199b` (parziale, Nasdaq) ·
`R200a` (TF del trailing) · `R200d`/`R200e` condizionali.

### Cosa hanno prodotto, oltre ai verdetti
- 🔴 **Il no-op di `InpBreakevenAtTP1`**: incatenato a `InpTP1_ClosePct > 0`, in
  **16 file**. Sulla `770260` (`ClosePct=0`) e' **attivo**: quel flag non si puo'
  accendere. Prova in `risultati_prove/gestione_20260909/` — 36/36 righe identiche
  a parziale spenta, 15/36 diverse a parziale accesa.
- 🔴 **`InpTrailMode` e' la leva piu' grande mai misurata sul DD di questo EA**:
  stesse operazioni, stesso PF, DD da 17,65% a 7,17% (cella d'archivio, PF<1: vale
  lo span, non il livello). E' il prossimo round.
- 📌 Classi nuove in checklist: **538** (la riga su piu' righe fisiche: il `throw`
  non ferma le successive) · **539** · **540** (`-ArgumentList` non cita: uno spazio
  spezza il comando) · **541** · **542** · **543** · **544**.
