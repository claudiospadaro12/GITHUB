# TRAILFIX sul pin `9fca63d9` (25/09/2026)

**Stato: NON in campo.** Sono sorgenti pronti da compilare, non installati. Portarli in campo
richiede la firma di Claudio.

## Cosa c'e' in questa cartella

| file | cosa e' |
|---|---|
| `CLAU12_DAX_Apertura_EU.mq5` | sedie `770101` (BUY) e `770105` (SELL), GER40.cash M5 |
| `CLAU12_Dow_Apertura_US.mq5` | sedia `770202`, US30.cash M5 |
| `CLAU12_Nasdaq_Apertura_US.mq5` | sedia `770260` (RETEST, long e short), US100.cash M5 |
| `DIFF_<EA>.patch` | `git diff --no-index` fra il file al pin e il file di questa cartella |

## Da dove viene

- **Origine:** `mql5/Experts/ABTG_<EA>.mq5` al commit **`9fca63d9`**, cioe' il sorgente compilato
  sul terminale FTMO `541452707` (`C:\FTMO`) il 20/09. Verificato con l'impronta "scheletro" di
  `backtest_pipeline/righe/RINOMINA_CLAU12.ps1`: righe e SHA combaciano con la sua tabella
  (2425 / 2205 / 2624 righe) per tutti e tre i file. **Non viene da HEAD**: su HEAD il DAX ha +460
  righe che in campo non hanno mai girato.
- **Nome `CLAU12_`:** e' la stessa trasformazione di `RINOMINA_CLAU12.ps1`, che fa solo
  `Rename-Item`: il nome del file cambia, il contenuto no. Il prefisso nel log (`ABTG_DEF_NAME`)
  e l'include `ABTG_PausaGuardian.mqh` restano quelli del pin, come sono oggi in campo.
- **Modifica:** SOLO la **Parte A** di `report/MODIFY_A_RAFFICA_FTMO_2026-09-25.md` par. 4. Prima
  della `PositionModify` del trailing si controlla il lato del prezzo (`bid - SL >= stopsDist` per
  un BUY, `SL - ask >= stopsDist` per un SELL, con `stopsDist` = `SYMBOL_TRADE_STOPS_LEVEL` riletto
  a ogni tick). Se lo stop proposto e' dal lato sbagliato non parte nessuna richiesta, e
  `TrailRinvioLog` scrive una riga per ticket per candela di `InpTrailTF`. Niente Parte B, niente
  `input` nuovi, nessun altro cambio. Piu' un commento ASCII in testa.
- **Diff:** in ogni file cambiano due punti: la testa (+16) e il blocco trailing piu' la funzione
  nuova (+34 / -2). Il file al pin si ricostruisce byte per byte togliendo queste due parti.

## Cosa manca per portarli in campo

1. **Firma di Claudio.** Si tocca il binario di tre sedie vive sul conto della challenge.
2. **Prova di neutralita' sul PC di backtest** (non sul VPS, regola del 21/09):
   - pin `9fca63d9` contro pin + Parte A, "Ogni tick basato su tick reali", preset FTMO delle sedie;
   - su **tutti e tre** i file (DAX anche col preset SELL `770105`);
   - finestra che contenga l'**11/09 e il 17/09**, e nella corsa del pin le righe `invalid stops`
     devono essere **N > 0**. Se sono 0, "deal uguali" non prova niente;
   - superata se la **lista dei deal e' identica al centesimo** e le righe `invalid stops` passano
     **da N a 0**. Se i deal cambiano, la guardia non e' neutra e non si schiera. Il caso da
     guardare e' uno stop esattamente uguale al Bid/Ask con `StopsLevel=0`: la guardia (`>=`) lo
     lascia passare.
3. **Ricompilazione CLAU12 sul terminale FTMO `541452707` (`C:\FTMO`)**, NON sui BCM:
   - si fa **senza posizioni aperte** delle sedie `770101`, `770105`, `770202`, `770260`, perche' la
     ricompilazione ricarica l'EA;
   - si sostituiscono i `CLAU12_*.mq5` gia' presenti. Ricompilare gli `ABTG_*` li' non cambia il
     binario attaccato al grafico;
   - dopo: verifica con `CODA_06` (quale codice gira) e con la riga "avviato" nel giornale;
   - regola dei terminali multipli e i due strati del cancello prima di mandare qualunque riga.

## Limiti noti

- `TrailRinvioLog` scrive solo se `InpVerbose=true`, che e' il valore nei tre preset FTMO. Con
  `false` non scrive niente, ma la guardia funziona lo stesso.
- La memoria anti-ripetizione tiene un solo ticket. Con due posizioni aperte insieme sullo stesso
  grafico (stesso magic) le righe di log potrebbero alternarsi a ogni tick. Sarebbe solo rumore nel
  giornale: al server non parte nessuna richiesta.
