# 🔧 LE MANOPOLE INERTI — v2 (12/09/2026)

> **Che cos'e' questo file.** Il censimento del 09/09 aveva trovato che una
> parte delle passate di tester gia' pagate **non ha misurato niente**: la
> manopola messa ad asse non veniva letta dall'EA, perche' un altro
> interruttore la teneva spenta. Quello era **v1** e aveva un difetto grosso:
> raggruppava per "motore" dedotto **dal nome del file**. Questo e' **v2**,
> rifatto da zero con l'attribuzione riparata (`ea_of()`: PATH -> MAGIC ->
> FIRMA + veto sulle colonne) e su **tutto il repo**, non tre cartelle.
>
> Strumento riproducibile, un comando: `backtest_pipeline/manopole_inerti_v2.py`
>
> 🔴 **Niente qui dentro e' un verdetto.** Sono misure d'archivio: dicono
> **dove** guardare, non cosa concludere.

---

## 1. I numeri, e cosa cambia rispetto al 09/09

| misura | 09/09 (v1) | 12/09 (v2) |
|---|---:|---:|
| CSV di risultati letti | 2.069 | **2.083** (+14: `r123_dal_vps` e `gestione_20260909`, arrivati dal VPS il 09/09 **dopo** il censimento) |
| passate di tester | 61.633 | **61.829** |
| passate con Trades>0 | 45.865 | **46.061** |
| CSV con esiti duplicati fra le passate vive | 874 | **881** (6.006 passate vive senza esito nuovo) |
| CSV attribuiti a un EA REALE | *(non lo faceva: usava il nome del file)* | **1.990 su 2.083**; 93 non attribuibili, **dichiarati** |
| colonne `Inp*` distinte / mai ad asse | 552 / 444 | **554 / 445** |

**L'attribuzione riparata ha ribaltato la lettura di v1 in un punto chiave.**
v1 vedeva `ingresso`, `trailing`, `openconfirm`, `apert_APERT_US` come quattro
motori diversi con `InpTrailFixedPts` inerte. Sono **lo stesso nucleo**
(`ABTG_ApertureCore` / i tre cloni Apertura), e sullo stesso EA quella manopola
**morde altrove**. Non e' una casella "morta ovunque": e' una casella **chiusa
a chiave in quei round**, e la chiave si sa qual e'.

---

## 2. 🧪 IL CONTRO-ESEMPIO OBBLIGATORIO: inerzia != influenza debole

Se misuro solo "gli esiti sono diversi?", una manopola **letta** con effetto
microscopico si confonde col rumore di tick e la conto come "morso". Metrica
dichiarata **prima** dei numeri, tre classi per ogni gruppo ceteris paribus
**vivo** (>=30 operazioni):

- **IDENTICO** = Profit, PF, Trades, Equity DD% uguali cifra per cifra
  -> la manopola **non e' stata letta**;
- **DEBOLE** = esiti diversi ma `dTrades = 0` e `dPF <= 0,05`
  -> **e' stata letta**, effetto minimo: conta come **provata**;
- **FORTE** = tutto il resto.

**Risultato su 43.584 gruppi vivi** (escluso l'asse tecnico `InpMagic`):

| classe | gruppi | quota |
|---|---:|---:|
| **IDENTICI (inerzia vera)** | **1.048** | 2,4% dei gruppi vivi |
| DIVERSI | 42.536 | 97,6% |
| ...di cui **INFLUENZA DEBOLE** | **2.087** | 4,9% dei diversi |

A livello di coppia (EA x manopola): **36 coppie totalmente inerti**, ma **32
sono `InpMagic`** — che *non* e' spreco, e' il **cancello G1 di determinismo**,
e **passa**: 767 gruppi gemelli identici, piu' 22 gruppi su
`ABTG_Dow_Apertura_US` di cui **4 differiscono di un centesimo di Profit** a
PF/Trades/DD uguali (classe DEBOLE, non non-determinismo). Restano **4 coppie
inerti vere** e **6 coppie a influenza debole pura**.

Il caso di scuola, riga contro riga, da
`backtest_pipeline/risultati_archivio/MaxMinNotte/valid_MaxMin_DAX_short_refine.csv`:

```
InpMinBoxPts=0     profit -163,82  PF 0,95488  n 103  DD 8,9919
InpMinBoxPts=1500  profit -163,82  PF 0,95488  n 103  DD 8,9919   (x18 coppie su 18)
```

Contro un esempio di **influenza debole** che v1 avrebbe contato come "morso" e
che invece e' **rumore di tick** (`apert_US_M5_doc_delay_realtick_U30USD.csv`,
`InpTrailFixedPts` con `InpTrailMode=1`): 15 gruppi con `dPF = 0,00007`,
`dTrades = 0`, valori **non monotoni** col parametro. **Non e' la manopola: e'
il banco.** Su quell'EA il trailing FIXED ha **0 morsi FORTI in 190 gruppi** con
`TrailMode=1` e **12 su 12** con `TrailMode=2`.

---

## 3. 🔑 Perche' erano chiuse, e con quale valore si aprono

La colonna "chiave" e' trovata **dai dati** (purezza della separazione
FORTE/IDENTICO) **e confermata nel sorgente**, riga per riga.

| EA (sedia) | manopola | gruppi vivi F/D/I | CHIAVE: si accende con | verifica nel sorgente |
|---|---|---|---|---|
| Apertura US (Nasdaq/Dow) | `InpTrailFixedPts` | 12 / 15 / 175 | **`InpTrailMode = 2`** (purezza **100%**) | `ABTG_Nasdaq_Apertura_US.mq5:2249` e `:2262` — letto solo se `TRAIL_FIXED` |
| Apertura DAX | `InpTrailFixedPts` | 241 / 4 / 44 | **`InpTrailMode = 2`** (99%) | idem, `ABTG_DAX_Apertura_EU.mq5` |
| Apertura (tutti) | `InpBufferPoints` | 455 / 19 / 119 | **`InpEntryMode != 3`** (fade) — con FADE **119 gruppi su 119 identici** | `:1089`/`:1106` il fade e' un LIMIT su `gRangeHigh +/- InpFadeOffsetPts`; `EffectiveBuffer()` entra solo se `slDist<=0` (`:1080`) |
| Apertura (tutti) | `InpRangeMinutes` | 400 / 17 / 173 | **`InpRangeMode = 0`** (OPENING) | `ComputeLevels()` `:907-914`: con PREVBAR **ritorna prima** di leggerlo. **Eccezione misurata**: con `InpEntryMode=4` (DELAY/GAPFILL) morde lo stesso (10 gruppi FORTI a `RangeMode=2`), perche' `:1635` usa `openMin+InpRangeMinutes` **fuori** da `ComputeLevels` |
| `ABTG_ORB_Ottimizzato` (770611) | `InpUseVolumeFilter` | 32 / 0 / 52 | **`InpUseCloseConfirm = 1`** (purezza **100%**) | `VolumeOK()` `:533` chiamata solo da `TryCloseConfirmEntry()` `:573`, raggiungibile solo da `:384-398` sotto `if(InpUseCloseConfirm)` |
| Apertura (gestione) | `InpTrailMode` | 24 / 5 / 28 | **`InpUseTrailing = 1`** (100%) | ovvio nel codice, ma **misurato**: 28 gruppi buttati nei round gestione |
| Apertura DAX | `InpSkipIfTight` | 37 / 0 / 23 | **`InpMinStopPts >= 4000`** (98%) — a 0 e 2000 **inerte**, a 4000/6000 morde 24/24 | `r118_csv/..._r118b.csv`: la scala c'e' gia' ed e' la prova che il metodo funziona |
| `ABTG_MaxMinNotte` | `InpMinBoxPts` | **0 / 0 / 18** | **nessun interruttore: e' la SCALA del valore.** 1500 punti = **15 punti indice**, il box notturno DAX non e' mai cosi' stretto | `:329-331` `widthPts=(hi-lo)/_Point; if(InpMinBoxPts>0 && widthPts<InpMinBoxPts)` |
| `ABTG_DAX_Live5m_v2` | `InpMinStopPts`, `InpSkipIfTight` | **0 / 0 / 16** ciascuna | **scala del valore**: provati 200/400 punti. **Numero nuovo**: sullo stesso simbolo la soglia comincia a mordere **fra 2000 e 4000** (R118b) -> erano **10 volte troppo piccoli**. `SkipIfTight` e' annidato dentro quel `if` (`:678-681`), quindi muore con lui | `ABTG_DAX_Live5m_v2.mq5:678`/`:702` |
| `ABTG_BreakingBand` | `InpBulgeMinBars` | 0 / 0 / **1** | **un solo gruppo vivo** | verdetto **NON ANCORA MISURATO**, non "inerte" |

⚠️ **Onesta' sulla parte debole:** per un pugno di coppie minori
(`InpSLBufferPts`->`InpAutoTest`, `InpTrailTF`->`InpMaxPosSimbolo`) la colonna
"chiave" trovata dai dati e' **spuria** — separa per file, non per causa. Sono
marcate e **NON** entrano nella classifica.

---

## 4. 📊 Classifica valore/costo, col cancello dell'edge applicato

**Calibrazione: 5,0 s/passata.** E qui si corregge v1: quella calibrazione e' a
**TICK REALI**, non OHLC (R88a girava `-Modello 4`, 96 passate in 8,0 min, i CSV
**non** hanno il suffisso `_ohlc`). Quindi il **buco n.2 di v1** ("costo tick
[NON MISURATO]") **e' chiuso**. Forbice dello stesso referto: 2,9-33,0 s.

| # | casella da riaprire | sedia viva toccata | edge misurato | costo | verdetto cancello 19/08 |
|---|---|---|---|---|---|
| **1** | **`InpLevelTF`** — mai ad asse in **0 CSV su 2.083**, ed e' **l'unica cosa che decide i livelli** sulla sedia 770250 (preset vivo: `InpRangeMode=2`) | **770250 NASUSD M15** (viva sul piccolo 50503392) | tick 21 mesi: n 104 · PF **1,097** · DD 4,54% @0,65% · OHLC orso: n 93 · PF **1,84** | 7 celle x 2 = **14 passate ~ 1,2 min** | ✅ **APRIRE.** n=104 < 150 -> merito **sospeso**, non "senza edge". Ed e' un **TF**, la classe di manopola piu' potente misurata (dPF 1,8-8,4 contro 1,1 della migliore non-TF) |
| **2** | **`InpUseCloseConfirm` x `InpUseVolumeFilter`** — filtro **scritto e mai eseguito** (52 gruppi su 52 morti) | **770611 U30USD M5** (viva sul conto reale) | cella r88a tick: IS PF 1,250 n 71 · OOS PF **1,674** n 119 DD 9,76% | 2 celle x 2 = **4 passate ~ 20 s** | ✅ **APRIRE (lato long).** Lato short **NO**: PF OOS 0,520, DD 26,37% |
| **3** | **`InpMinBoxPts`** — 18/18 identici; la scala e' fuori range di **10x** | 770402 XAUUSD H2 e **770411 D30EUR** (stesso filtro, `:230`) | cella mediana d'archivio: PF **1,187** n 107 DD 7,29% | 9 celle x 2 = **18 passate ~ 1,5 min** | ✅ **APRIRE.** In piu' la colonna `Trades` lungo la scala **E'** la distribuzione dell'ampiezza del box: chiude il buco n.1 di v1 senza una sonda dedicata |
| 4 | `InpMinStopPts` + `InpSkipIfTight` con valori **veri** (2000-8000, non 200/400) | Live5m **non e' una sedia viva** | tick n=445: PF **0,922** · DD 16,8% | 9x2 = 18 passate | 🔴 **NON per MERITO: motore senza edge** (PF 0,922 su n=445 a tick reali). Ha senso solo come misura di **RISCHIO** (il pavimento dello stop e' un parametro di rischio, leggibile a qualunque n — Emendamento B) |
| 5 | manopole del ramo **FADE** (`InpFadeOffsetPts`, `InpAtrSlMult`) | 770101 / 770202 | fade DAX PF **0,715** (n 419) e **0,720** (n 430); fade US PF **0,806** (n 324) | — | 🔴 **NON RIAPRIRE: motore senza edge.** Tre misure indipendenti sotto 0,81 su campioni da 324-430 operazioni |
| 6 | `InpRangeMinutes` sui round `doc_delay` | 770101 / 770202 | doc_delay U30USD PF **0,707** (n 139); doc_delay DAX PF **0,733** (n 87) | — | 🔴 **NON RIAPRIRE: motore senza edge** |
| 7 | `InpUseVolumeFilter` su **NASUSD r12** | 770250 (altra config) | IS PF 0,977 n 171 · **OOS PF 0,800 n 267 DD 41,9%** | — | 🔴 **NON su quella cella: senza edge e con DD 41,9%.** E' il motivo per cui la casella #2 si apre **sul U30USD**, non li' |

### 💸 Il prezzo delle caselle chiuse, in tempo macchina GIA' SPESO
Su 13 file dove l'inerzia e' documentata: **1.284 passate -> 155 esiti
distinti**. Cioe' **1.129 passate (88%) non hanno misurato niente**. A 5,0
s/passata sono **1,6 ore** di tester (forbice 1,6-10,3 ore).
**I tre round che si propongono ne costano 36 in tutto (~3 minuti).**

---

## 5. ✅ I tre file prova, pronti e passati dai cancelli

| file | asse | celle x finestre | `controlla_prova.py` | `controlla_riga.py --oggetto prova` |
|---|---|---|---|---|
| `backtest_pipeline/prove/R133a_livelliTF_NASUSD.txt` | `InpLevelTF` M15->H4 (enum, **7 celle vere**) | 14 passate | **OK** (stampa `celle=16374`: conteggio aritmetico, atteso e spiegato dentro il file) | **PASS**, ASCII puro |
| `backtest_pipeline/prove/R133b_filtrovolumi_U30USD.txt` | `InpUseCloseConfirm` 0->1 | 4 passate | **OK**, `celle=2` | **PASS**, ASCII puro |
| `backtest_pipeline/prove/R133c_ampiezzabox_D30EUR.txt` | `InpMinBoxPts` 0->12000 passo 1500 | 18 passate | **OK**, `celle=9` | **PASS**, ASCII puro |

Magic **vergini** 779650 / 779660 / 779670 (cercati su tutto il repo, `.git`
escluso). Ogni file ha dentro: attesa dichiarata **prima** dei numeri, soglie
congelate, costo in tempo macchina, buchi dichiarati, e **un contro-esempio
costruito apposta**:

- **R133a**: lo step e' `1` e **non** un numero che "fa tornare 7" apposta — con
  step 1 le due ipotesi (enum riconosciuto / non riconosciuto) danno **7 contro
  16374**, cioe' si **distinguono**. Con uno step calcolato darebbero 7
  entrambe e il controllo non misurerebbe piu' niente (classe 178).
- **R133b**: la cella `CloseConfirm=false` **ri-misura l'inerzia** invece di
  darla per buona; se cella 0 e cella 1 tornano identiche cifra per cifra, non
  e' il round ad essere fallito: **e' un bug**, e va aperta la segnalazione.
- **R133c**: la scala **non puo'** tornare tutta inerte se il codice e' sano (a
  120 punti indice le operazioni devono crollare). Se torna inerte,
  `widthPts` non viene calcolato.

Ancore dichiarate **morbide**, col motivo: l'EA ORB e' cambiato due volte dopo
R88a (v1.03 02/09, v1.04 hedge-safe 03/09) e `ABTG_MaxMinNotte` e' cambiato il
03/09 (`InpOneTradePerDay` **era dichiarato e mai letto** — un'altra manopola
inerte, trovata a mano; il commit stesso prevedeva "attesi MENO trade"). In
tutti e tre i casi il confronto **interno** fra le celle resta valido, perche'
girano sullo stesso binario.

🪑 **E le sedie vive NON si toccano**: i round girano su magic vergini, in
backtest, sul terminale 50504400 (`C:\MT5_Backtest`). Il conto reale non entra
in nessuna di queste righe.

---

## 6. 🔎 Tre cose trovate per strada, e una era urgente

**(a) 🔴 BLOCCANTE — ed e' gia' stato corretto.** I tre file
`backtest_pipeline/prove/R132{a,b,c}_nearatr_*.txt` dicevano `-Modello 1`
scrivendoci accanto *"= TICK REALI"*. **E' il contrario**:
`walkforward_generico.ps1:172` -> *"4 = tick reali (verita'). 1 = OHLC M1: SOLO
screening"*. Lanciato cosi', R132c avrebbe girato OHLC e il suo cancello di
riproduzione sarebbe **fallito per costruzione**, annullando R132a e R132b
insieme. **Verificato alla fonte e corretto il 12/09** (commit `1764a0e`).

> **Il contro-esempio che chiude la verifica**: con `Modello != 4` il driver
> appende `_ohlc` al nome del CSV (`:1347`), e i due CSV R123D **non ce
> l'hanno**. Ma l'assenza di un suffisso e' una prova solo se quel suffisso
> **spara davvero**: e spara — ci sono **14 CSV `_ohlc`** in
> `backtest_pipeline/risultati_archivio/r82_csv/` (328 in tutto il repo). Senza quel secondo controllo, "non c'e'
> `_ohlc`" poteva voler dire solo "quel pezzo di codice non ha mai funzionato".

**(b) La priorita' n.1 del referto del 09/09 e' GIA' STATA FATTA, e v1 non
poteva vederlo.** `InpTrailMode` ad asse (0/1/2) esiste in
`risultati_prove/gestione_20260909/` (R120): quei file erano fra i 668 che la
vecchia `ea_of()` non attribuiva. Risultato gia' a referto
(`report/R120_GESTIONE_APERTURE_2026-09-09.md`: DAX PF 1,379 con parziale OFF +
PREVBAR, DD 6,03% contro 22,21% senza trailing; NASUSD tutte e 48 le celle sotto
PF 1,00). **Quella casella e' chiusa.** Restano aperti `InpLevelTF` (mai) e, sul
**U30USD**, la griglia di gestione su finestra lunga: in archivio c'e' solo
`aperture_r46b` con 8 passate e n 56/96.

**(c) Correzioni a v1 da mettere a verbale**: il costo a tick reali **e'**
misurato (5,0 s/passata su U30USD M5); i round `ingresso`/`trailing`/
`openconfirm` **non** sono quattro motori ma **un nucleo solo**; e
`InpTrailFixedPts` sul DAX **non** e' mai stato inerte se non nei round con
`TrailMode=1` (241 gruppi FORTI altrove).

---

## 7. 🕳️ Buchi dichiarati

1. Il CSV della corsa tick del 30/08 che produce il contratto della 770250
   (**n 104, PF 1,097**) **non e' nel repo** — cercato su tutti i 2.083 CSV:
   nessuna riga NASUSD solo-short con n fra 95 e 112. Quel numero oggi vive
   **solo dentro due `.md`**.
2. Le "chiavi" trovate dai dati sono **indizi statistici**; sono confermate nel
   sorgente **solo** per le coppie in classifica. Per le altre resta il rischio
   "colonna costante per file".
3. `InpMinBoxPts` / `InpMinStopPts`: si sa **da quale ordine di grandezza**
   cominciano a mordere (2000-4000 punti sul DAX, da R118b), **non** la
   distribuzione completa. E' quello che R133c va a misurare.
4. **Nessun numero di questo dossier e' un verdetto.**

---

## 8. 🎯 E la bussola

Questo referto e' **ponteggio**, e va detto: non consegna nessuna sedia nuova.
Quello che consegna e' **36 passate (~3 minuti di tester)** che vanno a
misurare tre caselle mai misurate su **due sedie vive** — la 770250 sul piccolo
e la 770611 — piu' un difetto bloccante intercettato **prima** che una riga
partisse. Con la challenge ai primi di ottobre, il valore sta li': tre minuti
per aprire tre caselle chiuse, non tre ore per raffinare un motore morto.

*Fonte primaria: `backtest_pipeline/manopole_inerti_v2.py` (rilanciabile).
Dossier prodotto dall'agente `cercatore-parametri`, verificato e messo a
verbale nella sessione principale il 12/09/2026.*
