# 🔍 Audit: quello che GIRA contro quello che abbiamo MISURATO

_05/08/2026. Nato dalla richiesta di Claudio: "dobbiamo controllare queste cose per
migliorarci, devi controllare più attentamente e scrupolosamente"._

Oggi lo stesso errore è saltato fuori **due volte**: ho misurato o descritto una
configurazione **diversa da quella accesa**. Prima il trailing del DAX (credevo base
candela M1, era a punti fissi 410), poi il Nasdaq (credevo range d'apertura, è la candela
H1 precedente). In tutti e due i casi non l'ho trovato io: l'ha fatto emergere una domanda
di Claudio su un trade vero.

Quindi ho estratto **i default effettivi di ogni EA acceso** e li ho messi accanto a quello
che i backtest pinnavano. Sotto c'è tutto.

## Cosa gira davvero

| | DAX_Ap | NASDAQ_Ap | DOW_Ap | MARCO | DAXLive5m | DAXLive_v2 | NASLive5m |
|---|---|---|---|---|---|---|---|
| magic | 770101 | 770201 | 770202 | 770311 | 770103 | 770121 | 770203 |
| sessione (server) | 8:00 | 14:30 | 14:30 | 8:00 | 8:00 | 8:00 | 14:30 |
| **RangeMode** | 0 apertura | **2 candela H1 prec.** | 0 apertura | 0 apertura | 1 prev 5m | 1 prev 5m | 1 prev 5m |
| RangeMinutes | 15 | 15 | 15 | 15 | 15 | 15 | 15 |
| Buffer (pts) | 200 | 200 | 200 | 200 | 700 | 700 | 700 |
| Min/MaxRange | 0 / 0 | 0 / 0 | 0 / 0 | 0 / 0 | 0 / 0 | 1500 / 4000 | 1700 / 4000 |
| **TP1_R** | **1,0 → TP a 3R** | **1,0 → 3R** | 0,5 → 1,5R | **1,0 → 3R** | 1,0 | 1,0 | 1,0 |
| **TP1_ClosePct** | **50** | **50** | 0 | **50** | 50 | 50 | 50 |
| **BreakevenAtTP1** | **true** | **true** | false | **true** | true | true | true |
| MinStopPts | 0 | 0 | 500 | 0 | — | 200 | — |
| SkipIfTight | true | true | false | true | — | false | — |
| TrailMode | 1 base candela | 1 | 1 | 1 | 1 | 1 | 1 |
| **TrailTF** | M5 *(oggi)* | **M1** | M5 | M5 *(oggi)* | M1 | M1 | M1 |
| **RiskPercent** | **2,0** | **2,0** | 1,0 | **2,0** | 2,0 | 1,0 | 2,0 |
| filtro EMA | false | false | **true** | false | false | false | false |
| filtro volumi | false | **false** | false | false | — | false | — |
| chiusura (server) | 17:30 | **21:45** | 17:30 | 17:30 | 17:30 | 17:30 | 20:45 |

## 🔴 Divergenza 1 — il verdetto di stamattina non descrive gli EA accesi

`aperture_trailing.ps1` (24 pass, 700 trade, il test che ha prodotto *"nessuna
configurazione in utile"*) pinnava questo:

| parametro | pinnato nel test | **DAX acceso** | **Nasdaq acceso** |
|---|---|---|---|
| `InpRangeMode` | 0 | 0 ✅ | **2** ❌ |
| `InpTP1_R` | 0,5 (TP a 1,5R) | **1,0 → TP a 3R** ❌ | **1,0 → 3R** ❌ |
| `InpTP1_ClosePct` | 0 | **50** ❌ | **50** ❌ |
| `InpBreakevenAtTP1` | 0 | **true** ❌ | **true** ❌ |
| `InpMinStopPts` | 500 | 0 ❌ | 0 ❌ |
| `InpSkipIfTight` | 0 | true ❌ | true ❌ |
| `InpRiskPercent` | 1,0 | **2,0** ❌ | **2,0** ❌ |
| `InpUseVolumeFilter` | DAX 0 / NAS **1** | false ✅ | **false** ❌ |
| `InpCloseHour` | 17:30 | 17:30 ✅ | **21:45** ❌ |

**Sei divergenze sul DAX, nove sul Nasdaq.** Non sono dettagli: il test chiudeva tutto a
1,5R senza parziale né breakeven, l'EA acceso punta a **3R prendendo il 50% a 1R e
mettendo lo stop in pari**. Sono due gestioni diverse. E il Nasdaq acceso non usa nemmeno
lo stesso *ingresso* (candela H1 precedente invece del range d'apertura), né la stessa ora
di chiusura (21:45 contro 17:30).

**Conseguenza da dire chiaramente:** la frase *"nessuna combinazione è in profitto"* è vera
**per la configurazione testata**. NON è dimostrato che descriva il DAX e il Nasdaq che
girano sul VPS. Il verdetto va sospeso finché non si misura ciò che è acceso.

**Il Dow fa eccezione**: i suoi default sono stati scritti *dopo* la validazione e
combaciano (TP1_R 0,5 · ClosePct 0 · BE false · MinStop 500 · risk 1,0 · trailing M5).
Quello sì che è stato misurato per com'è.

## 🔴 Divergenza 2 — DAX Apertura e Apertura Marco sono lo stesso EA due volte

Confrontando riga per riga: **stessa ora, stesso RangeMode, stesso buffer 200, stesso
RangeMinutes 15, stessa gestione, stesso rischio 2%.** Non c'è un solo parametro operativo
che li distingua — solo il magic (770101 contro 770311).

E infatti il 05/08 hanno fatto **lo stesso identico trade**:

```
08:34:46  DAX Apertura EU SELL   26.339,50 -> 26.332,30   +7,20
08:34:46  Apertura Marco SELL    26.339,50 -> 26.332,30   +7,20
```

Stesso secondo, stesso prezzo, stessa uscita. **Non sono due strategie: è una strategia con
il doppio della size.** Rischio reale sul segnale d'apertura del DAX: **2% + 2% = 4%**.
Con una regola prop da −5% giornaliero, **un trade solo arriva a un passo dal limite**.

## 🟡 Da verificare

- **`InpTrailFixedPts = 410` sopravvive ovunque** come default, anche dove ora
  `TrailMode = 1`. È inerte finché il modo è 1, ma se qualcuno rimette il modo 2 da preset
  torna in gioco senza avvisare.
- **`InpRiskPercent = 2,0`** su DAX, Nasdaq, Marco, DAXLive5m, NASLive5m: **nessun backtest
  è mai stato fatto al 2%**, sono tutti all'1%. Il drawdown misurato va raddoppiato.
- **`InpConfirmMode = CONF_OR`** è ancora il default: è l'errore che avevo introdotto il
  02/08 e che l'ablazione ha dimostrato neutralizzare il filtro volumi. È innocuo solo
  finché volumi e ATR non sono accesi insieme — ma resta una mina.

## Cosa fare (decisione di Claudio)

Due strade, e sono alternative:

**A) Misurare ciò che è acceso.** Rifare `aperture_trailing` con i default veri
(TP 3R + parziale 50% + BE, risk 2%, Nasdaq in PREVBAR H1 e chiusura 21:45). Dice se gli
EA accesi hanno un edge. È la risposta alla domanda giusta.

**B) Allineare l'acceso al misurato.** Portare DAX e Nasdaq alla configurazione del Dow,
che è l'unica validata in walk-forward. Più veloce, ma applica al DAX/Nasdaq una taratura
trovata sul Dow.

**A prescindere da A o B**, due cose andrebbero fatte comunque:
1. decidere se `Apertura Marco` deve restare acceso, o se è solo raddoppio del rischio
2. riportare il rischio a **1%** dove i backtest sono all'1%

## Regola per me, da qui in avanti

Prima di dare un verdetto su un EA: **estrarre i suoi default effettivi e metterli accanto
a quelli del test**. Se non combaciano, il verdetto non vale e va detto prima, non dopo.

## 🟢 Verificato, nessun problema — la famiglia SuperWave e il timeframe del grafico

Claudio: *"che poi superwave io ce l'ho in M3..."*. Controllato: **va bene così**, e sono
EA diversi che si somigliano nel nome.

| EA | magic | TF del segnale | dipende dal grafico? |
|---|---|---|---|
| `ABTG_SuperWave` | 770501 | `InpTF = H4` | **no**, esplicito |
| `ABTG_SuperWave_DAX_H4_Ottimizzato` | 770512 | `InpTF = H4` | **no** |
| `ABTG_SuperWave_DOW_H1_Ottimizzato` | 770511 | `InpTF = H1` | **no** |
| `ABTG_SuperWave_EA` | 990001 | `InpDirTF = H4` + `InpEntryTF = **M3**` | **no**, esplicito |

Nessuno dei quattro usa `PERIOD_CURRENT` o `Period()`: **il timeframe del grafico su cui
li attacchi non li tocca.** Lo stesso vale per gli EA d'apertura (DAX su grafico M3, e va
bene).

E `ABTG_SuperWave_EA` **è nato per l'M3**: header del file, *"INGRESSO: quando il
Supertrend M3 si inverte nella stessa direzione dell'H4"*, `InpEntryTF = PERIOD_M3`.
Non è la stessa strategia di `ABTG_SuperWave` (che è l'incrocio EMA 14/200 filtrato dal
Supertrend): sono **due motori diversi con nomi quasi uguali**, magic 990001 contro 770501.

L'unica cosa che vale la pena sapere: sul grafico D30EUR M3 c'è anche l'**indicatore**
`ABTG_SuperWave_Chart` — è solo disegno, non opera.
