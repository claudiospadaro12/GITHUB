
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
| **R199A** | `770260` Nasdaq | `InpBEatR` 0..1,5 | GIRATO, 🕰️ **VERDETTO SCADUTO** | 🟢 `0,5` domina la cella viva **DI ALLORA**. 🔴 Il 21/09 alle 20:22 (`496408a9`) la firma ha acceso la parziale: quella configurazione non esiste piu'. Le 4 celle cadono **fuori dal dominio nuovo** (`0 < x < 0,5`, tetto `gBETk`). **Classe 577** |
| **R199B** | `770260` Nasdaq | `InpTP1_ClosePct` 0..75 | GIRATO | 🟢 **l'unica manopola di otto che dice SI**: `50` firmato e **in campo** dal 21/09 sera. Cella viva di oggi: IS 1,22116 · DD 7,3069 · n 135 — OOS 1,21546 · DD 7,8576 · n 172 |
| **R209a** | `770260` Nasdaq | `InpBEatR` 0..0,5 (passo 0,125) | ✅ **GATATO, da girare** | riempie il **dominio mai misurato** aperto dalla firma del 21/09. Ancora di regressione: la cella `0` deve riprodurre la riga `ClosePct=50` di R199B. Bersaglio: **PC di backtest** |
| R200b | `770260` Nasdaq | `InpTrailStartR` | 🛑 **RITIRATO** | la risposta era gia' in archivio (`..._OOS_r24.csv`): il DD sale in 5 righe su 5. E r.2224 dice `<= 0`: **0 e' il pavimento dell'asse** |

### In coda, gatati e non ancora girati
`R209a` (`InpBEatR` dentro `0-0,5`, Nasdaq — scritto il **22/09**).

🔴 **I sette che qui erano elencati come "in coda" (`R200c`, `R172d`, `R201a`, `R199b`,
`R200a`, `R200d`/`R200e`) SONO TUTTI GIRATI** fra le 21:05 e le 23:27 del 21/09. Il
registro era stato scritto a meta' giornata — **classe 576: lo stato di un round si legge
dall'archivio, non dal registro.**

### 🕰️ Riaperti dalla firma del 21/09 sera (parziale al 50% in campo sulla `770260`)
La firma tocca la **gestione dell'uscita**, quindi riapre i round sull'**uscita** e NON
quelli sull'**ingresso** (che scelgono quali operazioni esistono, e quelle non cambiano):
- 🔴 **riaperti davvero**: `R199A` (`InpBEatR` — dominio ristretto, vedi sopra → `R209a`) ·
  `R200b` (`InpTrailStartR`, ritirato su archivio a parziale SPENTA: dopo la parziale
  `InitialSL` r.2294 ripiega sull'ATR, quindi `profR` cambia denominatore) ·
  `R200c`/`R200a`/`R200e` (`InpTrailMode`/`InpTrailTF`/`InpTrailFixedPts`: il trailing ora
  gestisce **meta' posizione** partendo da uno stop gia' a pari — e' un altro mestiere);
- 🟢 **NON riaperti**: `R196a` (`InpMinRangePts`) e `R198` (`InpRetestOffsetPts`) — sono
  filtri d'**ingresso**, e l'insieme delle operazioni non cambia. R197/R198 avevano gia'
  misurato che *il DD si muove con l'uscita, non con l'ingresso*. Le loro classifiche
  furono decise con margini larghi (R198: lo `0` e' **l'unica** cella positiva OOS), quindi
  sopra il pavimento di rumore: **non si rifanno.**

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
