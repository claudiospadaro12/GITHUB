# R50 — perche' 32 lanci hanno prodotto zero CSV (14/08/2026)

**La risposta, con le parole di MT5**, dal giornale del terminale
(`<CartellaDati>\logs\20260814.log`):

```
16:50:18.106  Network   '50503392': terminal synchronized ... 51 symbols
16:50:18.227  Tester    symbol GBPUSD_EXT not exist
16:50:18.227  Terminal  tester didn't start
16:50:24.452  Terminal  shutdown with -1000012358 (tester symbol does not exist)
```

Ripetuto identico a ogni lancio, per tutte e due i simboli. **51 symbols**:
il terminale conosce solo quelli del broker. I simboli `_EXT` non ci sono.

## La contraddizione apparente

Sul disco, in `bases\Custom\history\`, ci sono **EURUSD_EXT 148,7 MB** e
**GBPUSD_EXT 148,9 MB**. Le barre esistono. Il simbolo no.

Non e' una contraddizione: in MT5 sono due cose separate.

- le **barre** le scrive `CustomRatesUpdate` mano a mano, e restano su disco;
- la **registrazione** del simbolo (quella creata da `CustomSymbolCreate`)
  vive in memoria e viene scritta su disco **alla chiusura pulita** del
  terminale.

## La causa

`importa_storico_esterno.ps1`, riga 475, finiva cosi':

```powershell
Get-Process -Name "terminal64" | Stop-Process -Force
```

**Ammazzava il terminale invece di chiuderlo.** L'import riusciva (referto di
validazione compreso: 2,55 milioni di barre, differenza 0,004%, copertura
99,6%), le barre finivano su disco, e la registrazione del simbolo moriva col
processo. Il giorno dopo: 148 MB di storico e un simbolo che non esiste.

Lo stesso `Stop-Process -Force` c'era in `prepara_broker_esterno.ps1` (2
punti) e in `installa_pepperstone.ps1` (2 punti): stessa trappola, non ancora
esplosa perche' quegli script non erano ancora stati usati per creare simboli.

## Le correzioni

1. **`Chiudi-MT5-Pulito`** nei tre script: chiede la chiusura educata
   (`CloseMainWindow`), aspetta fino a 60 secondi, e forza **solo** se il
   terminale non obbedisce — dicendolo a voce alta, perche' in quel caso i
   simboli creati possono non essere salvati.
2. **Cancello preliminare in `prova_regime.ps1`**: prima di lanciare
   controlla che le barre custom esistano per tutti i simboli richiesti, e si
   ferma subito invece che dopo mezz'ora.
3. **Messaggio di fallimento riscritto**: prima era una domanda ("il simbolo
   esiste? lo storico copre il periodo?"), adesso indica il file dove MT5
   scrive la risposta.

## Quello che questo round ha insegnato, al netto dei numeri

R50 non ha ancora prodotto un solo dato di regime. Ha pero' fatto emergere
cinque difetti veri, tutti corretti: il genetico su due combinazioni, la
memoria dei flag di ottimizzazione, il percorso non quotato, l'assenza del
ripiego sul nome del CSV, e questo. Piu' un errore nel file delle celle
(`SW_GBPUSD` dichiarava H4 ma passava `InpTF=16386`, cioe' H2).

**La lezione operativa**, da mettere accanto alle altre: *un file su disco non
e' un dato disponibile*. Il cancello zero della prova di regime chiedeva
copertura e differenza di prezzo; da adesso chiede anche che **il tester veda
il simbolo**, e quella verifica si fa leggendo il giornale, non i megabyte.
