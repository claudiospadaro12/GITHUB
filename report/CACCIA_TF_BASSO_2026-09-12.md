# 🏹 CACCIA TF BASSO — 12/09/2026 · M5 / M15 / M30 con STOP STRUTTURALE

> 🔒 **PERIMETRO, dichiarato prima di tutto il resto.**
> **Zero EA scritti o toccati. Zero backtest eseguiti. Zero righe in `CODA.txt`.**
> Non ho toccato `coda/CODA.txt`, `walkforward_generico.ps1`,
> `RIGA_SOTTILE_ROUND.ps1`, nessun `.mq5`, nessun `.set`, niente in forward,
> nessun file dell'agente che lavora in parallelo sull'inventario dei nostri
> motori. I file nuovi sono **questo `.md`**, **due file prova** e **due sonde
> Python** in `caccia_strategie/biblioteca/sonde_esterne/`.
> Il **secondo strato del cancello** (agente `controllo-preventivo`) **lo lancia
> il chiamante**: io lo dichiaro e non lo aggiro. Il primo strato
> (`controlla_prova.py`) l'ho girato **da solo, senza pipe**: `ESITO: OK`.

---

# 0. 🔴 LA RIGA CHE VA LETTA PER PRIMA

> ## Su **1.642 titoli** del Code Base (6 pagine) + **72 strategie** TradingView + 2 ricerche web, **118** passati al filtro dello stop strutturale, **1 sorgente esterno scaricato e letto riga per riga**, **1 motore portato fino alla MISURA su 1.266.562 barre M1**: **ZERO EA ESTERNI PROMOSSI**. Due file prova consegnati, e sono su un motore che **abbiamo già in casa**.
>
> **E la cosa che porto a casa non è un candidato: è un CRITERIO che ribalta
> metà del mandato di oggi — e l'ho misurato io, contro la mia stessa tesi.**

## 🎯 IL MANDATO CHIEDEVA «STOP STRUTTURALMENTE LARGO». MISURATO: NON BASTA, E NON DI POCO

Il brief dice, testuale: _"meccanismi che vivono su M5/M15/M30 E il cui STOP è
STRUTTURALMENTE LARGO"_. Ho preso la famiglia con l'evidenza esterna più forte
che esista in questa classe (il **cono di rumore** di Zarattini-Aziz-Barbon,
M18 della tassonomia di casa) e l'ho misurata sul DAX su **1.493 sedute**:

| | numero misurato oggi |
|---|---:|
| ampiezza del cono = **lo stop strutturale**, mediana sui 17 controlli a orologio | **89,1 punti indice** |
| **`stop/spread`** (spread D30EUR **1,70** MISURATO su 30.974.789 tick) | 🟢 **52,4x** |
| quota di operazioni sotto il pavimento **DURO 13,3x** | 🟢 **0,4%** |
| informazione **DIREZIONALE** netta, controllo appaiato, geometria FEDELE (n=1012) | 🔴 **+0,0012 R** |

> ## 🔴 **`stop/spread` 52,4x — e l'edge è ZERO.** La frontiera del costo è passata di quattro volte, e non compra niente.
>
> **Questo è il secondo esperimento indipendente che dice la stessa cosa.** Il
> primo è di casa, 05/09, sul salto statistico M31: _"l'edge per segnale è una
> QUANTITÀ FISSA DI ATR (~0,16), non un multiplo fisso di R: allargando lo stop
> l'edge in R si diluisce esattamente quanto il costo. **Nessuna geometria salva
> l'aritmetica**"_.

## 🔑 IL CRITERIO CHE NE ESCE — **LA REGOLA DELL'ANCORA UNICA**

L'aritmetica, scritta per intero perché è tutto il contenuto della giornata:

```
E_netta(R)  =  (edge_in_punti  -  costo_in_punti)  /  stop_in_punti
```

Il costo è fisso. Quindi allargare lo stop **divide** l'edge in R. Un mercato
non ti regala niente per il fatto che tu metta lo stop più lontano.
👉 **Lo stop largo è gratis SOLO se l'edge in punti cresce con lo stop.** E
l'edge in punti cresce con lo stop **solo se il TARGET nasce dalla STESSA
struttura che ha dato lo stop.**

| motore | stop nasce da | target nasce da | stessa ancora? | E in R al variare dello stop |
|---|---|---|---|---|
| 🟢 **`ABTG_DAX_Apertura_EU` (770101, VIVA)** | estremo opposto del range di sessione (`ABTG_SL_RANGE`, r.236) | `tp = entry + dist * TpTotalR()` — **`dist` È lo stop** (r.1070) | ✅ **SÌ** | **INVARIANTE** |
| 🔴 **cono di rumore (M18)** | bordo opposto del cono (r.814-815) | la campanella / il rientro nel cono: **non scala** | ❌ NO | **crolla**: +0,054 R → +0,012 R (misurato oggi, terzili) |
| 🔴 **salto statistico (M31)** | ATR x k | edge fisso ~0,16 ATR | ❌ NO | **crolla** (misurato in casa 05/09) |

> 🎯 **Ecco perché `770101` vive a 33,0x e il cono muore a 34,0x con lo stesso
> rapporto.** Non è il rapporto `stop/spread` che li separa: è **l'ancora**.
>
> 🔴 **Conseguenza operativa per ogni caccia futura, e costa trenta secondi per
> candidato:** dopo aver letto da dove nasce lo stop, **leggi da dove nasce il
> target**. Se sono due posti diversi, `stop/spread` è un numero cosmetico e il
> candidato va scartato **prima** di aprire il tester.
> Questa colonna non esisteva nelle nostre schede di caccia. Da oggi c'è.

---

# 1. 🔌 CONTROLLO POSITIVO — fonte per fonte, misurato oggi (12/09/2026)

| fonte | bersaglio | esito MISURATO | verdetto |
|---|---|---|---|
| **MQL5 Code Base** (elenco) | `/en/code/mt5/experts` + `/page2`…`/page6` | **200 x 6** · 86.761 + 83.614 + 84.076 + 78.552 + 80.193 + 81.672 = **494.868 byte** · **1.642 coppie id+titolo** estratte | 🟢 **PASSA** |
| **MQL5 Code Base** (scheda) | `/en/code/15907` | **200** · 61.023 byte · `<meta description>` con **autore `GODZILLA` e data 2016.10.10** | 🟢 **PASSA** |
| 🥇 **MQL5 sorgente** | `/en/code/download/15907/exp_darvasboxes_system.mq5` | **200** · **6.276 byte** · 144 righe, ISO-8859 · **letto riga per riga** | 🟢 **PASSA** |
| **TradingView** (elenchi strategie) | `/scripts/{breakout,volatility,sessions,intradaymomentum,atr}/?script_type=strategies` | **200 x 5** · **2.035.363 byte** · **74 voci `script_type:"strategy"`** (72 distinte) | 🟢 **PASSA** |
| **TradingView** (scheda script) | `/script/OR2EflPg/` | **200** · 354.796 byte · titolo+autore+`access:1` letti | 🟡 **raggiunta, sorgente NO** (campo `content` vuoto nell'HTML) |
| **TradingView** (suggest JSON) | `/pubscripts-suggest-json/?search=…` x4 | **200 x 4** · 34 titoli · `access` e `scriptIdPart` | 🟢 **PASSA** (solo titoli) |
| 🥇 **raw.githubusercontent.com** | README + **6 CSV M1 DAX** `pyfinancialdata/data/stocks/histdata/GRXEUR/` | **200 x 7** · **86.579.436 byte** · **1.266.562 barre M1** 2013-2018 | 🟢 **PASSA — è la fonte che ha deciso la caccia** |
| **arxiv.org** (PDF diretto) | `/pdf/2605.04004` | **200** · 1.130.529 byte | 🟢 **PASSA** (paper già in casa) |
| **WebSearch** (strumento) | 2 query su intraday momentum / noise boundaries | risultati con URL veri | 🟢 **PASSA** (usata **solo come indice**, mai citata come pagina) |
| 🔴 **SSRN** | `abstract_id=5095349` **e** `Delivery.cfm/5095349.pdf` | **403 su entrambe** | 🔴 **NULLA** (sesta volta di fila) |
| 🔴 **arXiv API** | `export.arxiv.org/api/query` | **429**, poi **503** dopo attesa | 🔴 **NON RAGGIUNTA OGGI** — ⚠️ **è un 4xx/5xx di quota, NON un 404**: le altre cacce l'hanno aperta, quindi **non si cancella la fonte** |
| 🔴 **api.github.com** | `/repos/FutureSharks/financial-data/contents/…` | **403** · corpo: *"GitHub access to this repository is not enabled for this session"* | 🔴 **NULLA, e STRUTTURALE** (scoping di sessione, non quota). ⚠️ ma `raw.githubusercontent.com` funziona **se si conosce il percorso esatto** |
| 🔴 **researchgate.net** | `/publication/380582442` | **000** (connessione fallita) | 🔴 **NULLA** |
| 🔴 **alexandria.unisg.ch** | bitstream del PDF Zarattini | **000** | 🔴 **NULLA** |
| 🔴 **quantseeker · quantitativo · quantmacro · quantifiedstrategies** | 4 articoli di replica | **EGRESS_BLOCKED x 4** | 🔴 **NULLA** |
| ⬜ **Quantpedia** | — | **non tentata oggi** | ⬜ buco dichiarato (l'11/09 dava 308, il 12/09 502) |

⚠️ **Popolarità delle schede Code Base: [NON MISURATO]** (contatori in JS).
**Non li invento e non li peso.**

---

# 2. 🔬 LA MISURA — cono di rumore sul DAX, 1.493 sedute, 6 anni

**Attrezzi archiviati in casa** (input di questo referto, non report):
`caccia_strategie/biblioteca/sonde_esterne/sonda_cono_ampiezza_dax.py` e
`sonda_cono_rumore_dax.py`.

## 2.1 🕐 COLLAUDO DELL'OROLOGIO, prima di leggere qualunque altro numero

Regola di casa. E **col contro-esempio, non contro il nulla**: l'ipotesi
alternativa è *"i file histdata sono in UTC"*, che metterebbe l'apertura DAX
(08:00 server) al minuto **07:00 di file**.

| i 5 minuti di file a più alta \|variazione\| media M1 (soglia **n >= 500**) | media | n |
|---|---:|---:|
| **03:00** | **0,000641** | 1.489 |
| 03:05 | 0,000534 | 1.506 |
| 02:00 | 0,000530 | 1.071 |
| 03:02 | 0,000470 | 1.505 |
| 03:06 | 0,000454 | 1.506 |

✅ **`ora file + 5 = ora server BCM`**: 03:00 file = **08:00 server** = campanella
DAX. **E l'ipotesi UTC è respinta**: il minuto che essa predice (07:00 file)
**non è nemmeno nei primi cinque**. La banda discrimina.
Riproduce alla cifra i due collaudi indipendenti di casa (05/09 e 12/09).

## 2.2 📏 LO STOP STRUTTURALE, ora per ora — la colonna che il brief chiedeva

Ampiezza **intera** del cono (= lo stop nel modo `SL_CONO`: si entra su un
bordo, lo stop è sull'**altro**), in punti indice DAX. Spread **1,70**
(mediana MISURATA dell'ora 08, la più alta della seduta: uso il valore
sfavorevole).

| controllo (ora SERVER) | mediana | p10 | p90 | **`stop/spread`** | n |
|---|---:|---:|---:|---:|---:|
| 08:30 | 47,3 | 28,2 | 81,4 | **27,8x** | 1.479 |
| 09:30 | 67,3 | 37,3 | 113,8 | **39,6x** | 1.493 |
| 11:00 | 81,0 | 47,6 | 137,8 | **47,6x** | 1.465 |
| 13:00 | 93,1 | 52,5 | 154,6 | **54,7x** | 1.493 |
| 15:00 | 114,3 | 64,7 | 191,7 | **67,2x** | 1.479 |
| 16:30 | 130,6 | 71,9 | 212,4 | **76,9x** | 1.493 |
| **tutti i 17 controlli** | **89,1** | 45,3 | 160,5 | 🟢 **52,4x** | **25.239** |

- 🟢 **Sotto il pavimento DURO 13,3x: 0,4%.** Sotto il pavimento di lavoro 40x:
  28,9% (tutte nella prima ora e mezza di seduta, dove il cono è ancora stretto).
- 🟢 **Robustezza al costo**: allo stress **p95** dello spread (2,70) lo stop
  mediano è **36,3x**; a **spread +100%** (3,40) è **28,9x**. **Resta sopra il
  pavimento duro in tutti e due gli stress.**
- 📈 **E lo stop CRESCE con l'ora**, 27,8x → 76,9x: è **esattamente** la forma
  che il brief cercava (stop dato dalla struttura, non dal TF).

## 2.3 🔴 E POI L'EDGE — misurato con il controllo APPAIATO, come impone la casa

Cammino su M1 dentro la seduta, convenzione **pessimista** (se in una barra ci
stanno sia lo stop sia l'uscita, **vince lo stop**), costo 1,70 punti dedotto,
un solo primo-segnale per seduta, uscita alla campanella o stop al cono.
**Controllo appaiato** = stesso segnale, stessa barra, **stessa distanza di
stop**, **lato opposto** (media dei due = monetina esatta).

| geometria | n | op/gg | E netta | t | controllo appaiato | **informazione direzionale** |
|---|---:|---:|---:|---:|---:|---:|
| **con gap adjustment** (= quella del sorgente, `baseUp=max(open,close_pre)` r.697-700) | 1.012 | 0,678 | −0,0131 R | −0,49 | −0,0156 R | 🔴 **+0,0012 R** |
| senza gap adjustment (variante **non** fedele) | 1.258 | 0,843 | +0,0314 R | +0,86 | −0,0172 R | 🟠 **+0,0243 R** |

- 🔴 **La geometria FEDELE alla fonte dà ZERO.** La variante che dà il numero
  meno brutto è quella **infedele** — e pescarla sarebbe esattamente il
  curve-fitting che il progetto esiste per non comprare. **Lo scrivo perché la
  tentazione era mia.**
- 🟠 **E anche il +0,0243 R non passa**: il cancello H8 di casa è **0,075 R
  netti**, e `t = +0,86` non distingue quel numero da zero.

## 2.4 🧪 IL TEST DI SCALA — la misura che genera la regola dell'ancora unica

Divido le operazioni in terzili per **ampiezza dello stop** e guardo l'edge
**in punti** (non in R):

| terzile (geometria non-gap, la migliore delle due) | stop mediano | **E LORDA in punti** | E netta in R |
|---|---:|---:|---:|
| stop **STRETTO** | 34,6 pti | **+3,07** | **+0,0542 R** |
| stop **LARGO** | 94,7 pti | **+3,31** | **+0,0118 R** |

> 🎯 **Lo stop cresce di 2,7 volte, l'edge in punti cresce del 7,8%.**
> Risultato: l'edge in R **si divide per 4,6**. È la dimostrazione diretta che
> su questo meccanismo **il target non è ancorato alla struttura dello stop**, e
> che quindi lo stop largo è un costo travestito da virtù.
>
> ⚠️ **Contro-esempio che mi sono costruito contro:** sulla geometria
> gap-adjusted il terzile largo va **meglio** (+6,38 pti contro −2,32). Non lo
> nascondo, e non lo uso: su quella geometria l'informazione direzionale
> complessiva è **+0,0012 R**, cioè i due terzili sono rumore che si compensa,
> non una scala. **Un terzile favorevole dentro un totale nullo non è una
> misura: è una selezione.**

## 2.5 🚧 COSA QUESTA MISURA NON PUÒ DIRE — quattro scostamenti, dichiarati

1. **OHLC M1, non tick reali** → è **SCREENING**. I verdetti li dà `Modello 4`.
2. **Un solo primo-segnale per seduta**; il motore ne ammette **2**.
3. 🔴 **Non può misurare l'uscita che la fonte e la letteratura di seguito
   dichiarano DECISIVA — il trailing su VWAP.** Nei file histdata degli indici
   **la colonna volume è 0**, quindi la VWAP **non è calcolabile**. È
   letteralmente il pezzo che decide, ed è fuori dalla portata di questi dati.
4. **DAX cash 2013-2018**, non il CFD `D30EUR` di BCM 2024-2026.

👉 **Per questo il verdetto sul cono è `NON ANCORA MISURATO`, non "morto"**: il
numero che manca è un numero **mancante**, non un numero **brutto** — ed è
esattamente il caso in cui la regola del 09/09 dice *"si trova la via più corta
al numero"*. La via più corta costa **1,22 minuti di macchina** (§5).

---

# 3. 📋 LA TABELLA DEI CANDIDATI

Ordinata per quanto è vicina a una sedia. **La colonna che decide non è
`stop/spread`: è ANCORA UNICA** (§0).

| # | candidato · fonte | meccanismo (5 righe) | **da cosa è dato lo STOP** | **ANCORA UNICA?** | TF | **`stop/spread`** | op/gg | storico utile | già fra i caduti? | verdetto |
|---|---|---|---|---|---|---:|---:|---|---|---|
| **1** | **Cono di rumore** — Zarattini/Aziz/Barbon, SFI 24-97 (SSRN **4824172**, PDF **NON aperto: 403**) · impl. in casa `ABTG_OutOfNoise.mq5` (porting MIT del Pine `tv gJeM3LZ5`) | ① banda ancorata all'**apertura del giorno**, larghezza = movimento medio **a quell'ora** su 14 sedute; ② bordi corretti per il **gap notturno**; ③ si guarda **solo** a HH:00 / HH:30; ④ fuori dalla banda = squilibrio, si entra **nel verso**; ⑤ trailing su VWAP, **flat a fine seduta** | 🟢 **bordo OPPOSTO del cono** (`slRaw = isLong ? lower : upper`, r.814-815) — **strutturale, e cresce con l'ora del giorno** | ❌ **NO** — il target è la campanella | **M30** (la griglia HH:00/HH:30 **è** M30) | 🟢 **52,4x** mediana · **34,0x** sulle operazioni vere · sotto il duro **0,4%** | **0,68-0,84** per simbolo → **2,0-2,5** di famiglia su 3 indici 🟢 | 🟢 **tick BCM dal 2024.09.26** → ~440 sedute → **n ~300-600 > 150**; M30 = ~7.900 barre, **niente tetto** | ⬜ **NO**: mai girato. L'unica corsa (29/08) è **n=0 per baco di warmup**, corretto e mai rifatto | 🟡 **NON ANCORA MISURATO** → **due file prova, §5** |
| **2** | **Gemello USA** dello stesso motore (`NASUSD`) | idem, sessione **14:30-21:00 server** | idem | ❌ NO | **M30** | ampiezza cono su NASUSD **[NON MISURATA DA ME]** · pavimenti: duro **23,9 pti**, lavoro **72,0 pti** | idem | idem | ⬜ NO | 🟡 **NON ANCORA MISURATO** → **file prova, §5** |
| — | `Exp_DarvasBoxes_System` — Code Base **15907** (`GODZILLA`, 2016.10.10), **sorgente scaricato e letto** | box di Darvas (struttura di swing, **non** un box orario) + rottura | 🔴 **`StopLoss_ = 1000` punti MT5 FISSI** (r.29), `TakeProfit_ = 2000` fissi (r.30) | ❌ NO (e nemmeno strutturale) | indicatore a **H4** di default | 🔴 **1000 punti MT5 = 10 punti indice = 5,9x** → **SFONDA il pavimento duro (44% di esso)** | — | — | — | 🔴 **SCARTO PER COSTO, col numero** (§4) |

> 🔴 **Nota di onestà sulla tabella: i candidati 1 e 2 sono lo STESSO MOTORE, e
> quel motore è NOSTRO, non trovato oggi.** Di esterno, oggi, ho portato a casa
> **un sorgente letto e scartato** e **una misura**. Non gonfio la tabella per
> non tornare a mani vuote: il brief lo vieta e costa tempo macchina che non
> abbiamo.

---

# 4. 🪦 GLI SCARTI — una riga di motivo a testa, e dove possibile il numero

## 4.1 Il sorgente esterno letto oggi

**`Exp_DarvasBoxes_System`** · https://www.mql5.com/en/code/15907 · `GODZILLA`,
**2016.10.10** · nessuna licenza dichiarata → NOLICENSE · **144 righe, 16 input**
· file: `exp_darvasboxes_system.mq5` + `darvasboxes_system.mq5` (indicatore
**allegato**, quindi compilerebbe) + `tradealgorithms.mqh`.

L'ho aperto perché il box di Darvas è uno dei **pochissimi livelli strutturali
che NON è un box orario** — cioè non cade nelle cinque geometrie di sessione già
sepolte (rottura · fade · falsa rottura · sweep+reclaim · rottura-retest-rirottura,
mappa in `CACCIA_NOTTE_2026-09-12.md` §2.1).

| bandiera | esito |
|---|---|
| **stop non strutturale** | 🔴 **`input int StopLoss_=1000`** (r.29) e **`TakeProfit_=2000`** (r.30): **punti MT5 fissi**. Il livello di Darvas governa **solo l'ingresso**; lo stop **non sa niente** dell'altezza del box → **si stringe insieme al TF** esattamente come il brief teme |
| **costo** | 🔴 su `D30EUR` 1000 punti MT5 = **10 punti indice** (1 pto indice = 100 punti MT5, MISURATO, `CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.290) → **10 / 1,70 = 5,9x**, cioè **44% del pavimento DURO 13,3x** |
| **lotto fisso / sizing per perdite** | 🔴 `MM=0.1` con `MMMode=LOT` (r.27-28) = **lotto fisso, non rischio %**; e l'enum `MarginMode` espone **`LOSSFREEMARGIN` / `LOSSBALANCE`** (r.20-21) = taglia **in funzione delle perdite**, cioè la **firma della martingala** come modalità selezionabile (non default, ma presente) |
| repaint / look-ahead | 🟢 **NO**: `SignalBar=1` (r.42) → decide su barra **chiusa** |
| indicatori esterni | 🟢 **NO**: `iCustom(...,"DarvasBoxes_System",...)` (r.56) e l'indicatore **è nel pacchetto** |
| DLL / WebRequest | 🟢 **NO** |

**VERDETTO: SCARTO** — stop a punti fissi (fuori mandato per costruzione) **+**
5,9x contro un pavimento duro di 13,3x **+** lotto fisso **+** modalità di
sizing per perdite. **Cosa terrei (mestiere, non candidato):** niente. Il box di
Darvas come **sorgente di livello** resta un'idea non sepolta, ma questo codice
non la implementa in una forma misurabile da noi.

## 4.2 Le famiglie scartate **senza aprire il sorgente**, e il numero che le scarta

Regola di casa: ciò che è già setacciato non si ricontrolla. Tutte queste sono
cadute sulla **mappa delle cinque geometrie di sessione**, che è piena.

| titoli (fonte) | famiglia | 🔴 il numero che li scarta |
|---|---|---|
| `yc6JyC1T Initial-Balance-Breakout-samjNQ-v3`, `Y6cGGA73 Session-ORBO`, `10yYqaY7 ORB-Strategy-LuciTech`, `IQy5gWhR CP-Strat-ORB`, `t7Tp4qnu ORB-Pro-Session-Breakout-Scalper`, `Tr0vgxkq Open-Range-Breakout-Multi-TP`, `tSoUhlM9 Universal-Breakout-KedArc` (TradingView) · Code Base `31198`, `26451`, `68764`/`71460`, `23334`, `69545`, `17057`, `19498`, `18645`, `20879`/`21983`/`22145` | **rottura di un box orario (M1/ORB)** | ~**210 celle** a tick, **R45 0/48**, **R12 48/48 negative OOS**. Capitolo chiuso a verbale il 26/07 |
| `tA0tSNcn Tristan's-Box-Pre-Market-Range-Breakout-Retest` (TradingView) | **rottura → retest → ri-rottura** | `ABTG_IBRetest`, **PF di famiglia 0,7798 su n=344**, tre indici, M30, **tick reali**, cancello C0, 09/09 |
| `slqi9xMe Asian-Breakout-AutoBot` (TradingView) | **rottura del box notturno** | già **IN FLOTTA** come `ABTG_MaxMinNotte_DAX_Short` (M28); sul forex `ABTG_Nightly` GBPUSD **IS PF 0,59, DD 22,62%** |
| `GoeqO1ev Sweep-Reverse`, `On7JaUut Liquidity-Sweep-Tracker`, `jSNZ1CmV Liquidity-Hunter-SMC` (TradingView) | **sweep di liquidità / falsa rottura** | **M24, cimitero TRE volte**: CRT Turtle Soup **0/30** a tick · BreakinBox **PF 1,007 DD 24,1%** · R95 **0/30** |
| `dwgn7hrE Coil-Breaker`, `M6uONKNI Power-Surge-BB-Squeeze`, `N1OCoFkf Bollinger-Squeeze-Breakout`, `bN8jxMy5 Momentum-Squeeze-Breakout` (TradingView) · Code Base `1598 Narrowest Range`, `1071 Exp_BBSqueeze` | **contrazione/espansione, NR4/NR7** | **M2/M20**: doppione con evidenza peggiore, e l'ORB sotto è ⬛. Scarto per **costo di validazione > valore atteso** |
| `1oZNa7Oq HV-Spike` · `8ltrS3Yg ATR-Exhaustion` · `j35ygZIm LVN-Rejection` (TradingView) | — | 🔴 **già portati in casa come EA l'08/09** (`ABTG_HVAncora`, `ABTG_AtrExhaustVol`, `ABTG_LVNArbitro`): **cercarli di nuovo sarebbe ricomprare quello che abbiamo**. Vedi §6.2 |
| `Hi0gI790 ATR-ZigZag-Breakout`, `43eIQfDj ATR-Trailing+EMA`, `lDGmh7ou UT-Bot-v2`, `fM3YQz8i ATR-Trend-Fixed-TP-SL`, `NeEiwmDq Donchian+ATR-Trailing`, `UPuf4zqJ High-Low-Breakout-ATR` (TradingView) | stop **ATR del TF corrente** | 🔴 **fuori mandato per costruzione**: lo stop si stringe col TF. È la classe che il brief dice di scartare **col numero** — su `U30USD` la gamba ATR fa **11,5-13,1x a M5** e **20,0-22,6x a M15**, cioè sotto o dentro il pavimento duro (`REGISTRO_TEST.md`, 12/09) |
| ~**11 titoli** `JOAT` (`AuknbPLW`, `zpKLbjA0`, `7AxuzW05`, `7f1o7zhJ`, `BXDmlQdj`, `C7SRrSSH`, `NwMwuyA5`, `fDrDSlEM`, `hVJ4WG1v`, `MI47rsio`, `NEtMdbmJ`) | framework multi-regime | **non sono meccanismi, sono cataloghi**: manopole molto oltre il tetto di ~15 (§5.A) |
| ~**1.400 titoli** Code Base | pannelli, calcolatori, trailing, logger, copier, `Quantora*`, `GDS Renko*`, ONNX | **non sono motori**. Fuori perimetro per costruzione |
| ~**30 titoli** Code Base | `XANDER Grid`, `MultiMartin`, `Breakout Martin Gale`, `MA Grid Trade`, `Daily Zone Recovery`, `HedgeCover`, `VR Locker`, `Basket Protective Close`, … | **§4 nel TITOLO**: martingala / griglia / recovery / lock. **Scarto immediato**, vietati anche come intelligence |
| `Noise Area Indicator with Gap Adjustments`, `Noise Area (TS Intraday…)` `OR2EflPg`, `Atty Noise Area`, 31 titoli ADR/IB/session (TradingView suggest) | — | 🔴 **sono INDICATORI (`script_type:"study"`), non strategie**: nessun ordine, nessuno stop, **niente backtest** → fuori dall'imbuto |

---

# 5. 📦 I DUE FILE PROVA — cancello deterministico PASSATO

```
=== CONTROLLO FILE PROVA ===
  NOISE_M30_D30EUR_ancora.txt      ABTG_OutOfNoise.mq5   pin=20 celle= 2  OK
  NOISE_M30_NASUSD_gemello.txt     ABTG_OutOfNoise.mq5   pin=20 celle= 2  OK
file: 2 | celle totali: 4 | passate (celle x 2 finestre): 8 | problemi: 0
ESITO: OK
```

| file | cosa misura | simbolo · TF | @DAQUANDO | magic | celle |
|---|---|---|---|---|---:|
| `prove/NOISE_M30_D30EUR_ancora.txt` | **l'unico asse: `InpSlMode`** — stop dal **CONO** (0, strutturale, **mai girato**) contro **ATR** del TF (1, il default) | `D30EUR` · **M30** | **2024.09.26** (MISURATO) | **773810** (vergine, 0 occorrenze nel repo) | 2 |
| `prove/NOISE_M30_NASUSD_gemello.txt` | **lo stesso asse sul mercato della FONTE** (l'evidenza è su SPY, un indice USA, non sul DAX) | `NASUSD` · **M30** | **2024.09.26** | **773820** (vergine) | 2 |

- ⏱️ **Costo, col metro di casa `T(min) = 0,6 + 0,077 x passate`: 8 passate →
  1,22 minuti.** I due file insieme.
- 🚨 **Modello**: questi file vanno girati a **tick reali = `-Modello 4`**
  (`-Modello 1` è OHLC M1 = solo screening). **Il commento della riga di lancio
  deve dire la stessa cosa del numero** — classe 273, difetto pagato tre volte
  oggi.
- 🕐 **Ore in ORA SERVER BCM** e **pinnate**, non lasciate al default: DAX
  **08:00-16:30 server**, Nasdaq **14:30-21:00 server**. Un CSV con
  `InpSessionStartHour=9` (DAX) o `=15` (Nasdaq) è da **CESTINARE**.
- 📐 `InpMT5PerPuntoIndice=100` su **entrambi**, ed è **MISURATO** non assunto
  (`CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.290: D30EUR/U30USD/NASUSD, 2
  decimali, `_Point = 0,01`). 🟢 **Questo chiude di passaggio la riga M23 di
  `PIANO_PROP.md`**, che dava la conversione del DAX come *"da VERIFICARE"*.
- 🔴 **Trappola dichiarata dentro i file**: le due celle scrivono lo **stesso**
  file per-trade (il nome porta il **magic**, non la cella) → la seconda
  **sovrascrive** la prima. I numeri delle due celle si leggono
  nell'**OPTFRAME**, che ha una riga per passata.
- ⚠️ **Un asse Y solo** (limite del driver) → **non c'è** l'asse gemello sui
  magic, cioè il controllo di determinismo **G1**: per questo EA il determinismo
  resta **[NON MISURATO]**, e sta scritto nel file.

### L'attesa, dichiarata PRIMA, con **TRE** uscite

| esito | come si legge |
|---|---|
| **A** | `n >= 150` in **posizioni** e almeno una cella con **PF >= 1,10** nella finestra a campione pieno → il cono **esiste sui nostri dati**, e si disegna il round vero (due lati separati, regola del 25/08) |
| **B** | `n >= 150` e **entrambe** le celle `PF < 1,10` → **cancello C0**: si scrive il **CERTIFICATO** con PF/n/DD e **la famiglia M18 si chiude**. È un esito buono: chiude un capitolo con un numero |
| **C** | 🔴 **`n = 0` di nuovo, oppure la catena si rompe (EA che non compila, tick assenti, CSV vuoto): NON È UNA RISPOSTA.** Non si cambia nessun parametro: si leggono le **colonne di diagnostica v1.02** (`Ret Warmup`, `Ret Cono Ko`, `Cono Ok`, `Max nDays`) e si riapre il **baco**. Un `n=0` letto come "niente edge" è il modo esatto in cui questo motore è stato perso per 14 giorni |

---

# 6. 🚧 COSA NON HO POTUTO VEDERE, E COSA HO VISTO DI STRAFORO

## 6.1 Buchi dichiarati

1. 🔴 **Il paper di Zarattini NON è stato aperto.** SSRN **403** (pagina *e*
   PDF), `alexandria.unisg.ch` **000**, ResearchGate **000**, e i quattro
   articoli di replica **EGRESS_BLOCKED**. Le regole del meccanismo che cito
   sono **[LETTO-VIA-SEARCH]** più la scheda TradingView di replica aperta oggi
   (HTTP 200). 🙋 **È un buco che Claudio può chiudere in due minuti**
   scaricando il PDF da un browser normale: `SSRN 4824172`.
2. 🔴 **`SSRN 5095349`** — Ákos Maróy, *"Improvements to Intraday Momentum
   Strategies Using Parameter Optimization and Different Exit Strategies"*:
   secondo l'indice di ricerca **le uscite migliori sono VWAP e "ladder"**, che è
   **esattamente** la parte che il nostro EA implementa e che la mia sonda non
   può misurare. **PDF 403.** È il documento più utile che esista per questo
   candidato, e **non l'ho letto**.
3. **arXiv API 429 → 503**: non raggiunta **oggi**. ⚠️ **Non è un 404**: la
   fonte c'è, e il catalogo non si cancella.
4. **Quantpedia: non tentata** in questa battuta. Buco di scelta, dichiarato.
5. **Ampiezza del cono su NASUSD e U30USD: [NON MISURATA].** La sonda ha girato
   sul DAX. **Non la estrapolo** (la legge di scala fra indici è un'inferenza, e
   l'ho vista sbagliare).
6. **Nessun dato dopo il 2018** in questa misura: il regime **2024-2026** delle
   sedie **non è coperto**, e i dati non sono BCM.
7. **Volume = 0** nei file histdata degli indici → **nessuna VWAP**, quindi
   nessuna misura dell'uscita della fonte.

## 6.2 ⚠️ IL FATTO CHE HO VISTO DI STRAFORO, e che non è mio da lavorare

Cercando doppioni su TradingView mi sono accorto che **tre** degli script che
avrei proposto oggi sono già **EA scritti in casa l'08/09**, e ho controllato
`risultati_archivio/` e `REGISTRO_TEST.md` per tutti e cinque i motori M30 di
quella giornata:

| EA (esiste in `mql5/Experts/`) | fonte | referti in archivio | righe nel registro |
|---|---|---:|---:|
| `ABTG_LVNArbitro.mq5` | TradingView `j35ygZIm` (MPL 2.0) | **0** | **0** |
| `ABTG_HVAncora.mq5` | TradingView `1oZNa7Oq` | **0** | **0** |
| `ABTG_AtrExhaustVol.mq5` | TradingView `8ltrS3Yg` | **0** | **0** |
| `ABTG_DaxValueArea.mq5` | metodo volumetrico di Claudio | **0** | **0** |
| `ABTG_IntradayMomentum.mq5` | Gao-Han-Li-Zhou, *JFE* | **0** | **0** |

> 🔴 **Cinque EA scritti, zero corse, zero righe di registro — e la coda di
> stanotte (28 round) non ne contiene nessuno.** Con M30 a **zero round**
> mentre questi cinque sono motori **da M30**.
> 🙏 **Non è il mio perimetro** (l'inventario dei nostri motori lo sta facendo
> l'agente in parallelo) e **non ci ho lavorato**: lo segnalo perché un fatto
> visto e non detto è la cosa che il 09/09 ci è costata quattro candidati.

---

# 7. ⏳ QUANTI DI QUESTI POSSONO DIVENTARE UNA SEDIA ENTRO IL 1 OTTOBRE

## 🔴 Onestamente: **ZERO OGGI. UNO POSSIBILE, e ha una data.**

- **Zero adesso**, e il motivo è aritmetico, non di pigrizia: oggi il cono ha
  una misura di screening che dice **informazione direzionale +0,0012 R** sulla
  geometria fedele. **Nessuno mette in campo quello.**
- **Uno possibile**: se il round da **1,22 minuti** del §5 esce in **esito A**
  (`n >= 150`, `PF >= 1,10` a tick reali sul nostro feed), allora `OutOfNoise`
  M30 è un candidato con **frequenza di famiglia 2,0-2,5 op/giorno** su tre
  indici, **campione pieno già nei 21 mesi di tick** e **stop a 52,4x**. Da lì
  al forward ci sono ancora due lati da separare, un'ablazione e una scelta di
  cella al **centro dell'altopiano** — **fattibile entro il 1 ottobre solo se il
  round A arriva nei prossimi giorni.**
- 🔴 **E la parte che non è una sedia va detta come tale.** Il contributo
  principale di oggi — **la regola dell'ancora unica** — **non è una sedia: è
  ponteggio**, e serve a non pagare i prossimi round. Vale perché cambia
  **quali** candidati si aprono: per la prima volta abbiamo un criterio che
  scarta un candidato TF-basso in trenta secondi leggendo **due** righe di
  codice (da dove nasce lo stop, da dove nasce il target) invece di una.
- 🟢 **E la buona notizia, perché senza sarebbe un elenco di difetti:** la
  domanda di Claudio — _"dobbiamo trovare M5, 15 e 30 per le prop"_ — **ha una
  risposta misurata oggi, e non è "no"**. Su M30 il DAX offre uno stop
  strutturale da **89 punti indice mediani** con lo **0,4%** delle occorrenze
  sotto il pavimento duro: 🟢 **su M30 la frontiera del costo NON è il collo di
  bottiglia. Il collo di bottiglia è l'EDGE.** È una notizia migliore di quella
  del forex M5/M15, dove il costo chiude la porta **prima** di poter discutere
  di edge.

---

# 8. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

Non *"quale altro motore a TF basso"*. Questa:

> ## Su `D30EUR` M30 a tick reali, con lo stop preso dal **bordo opposto del cono** — 52,4x lo spread, un modo che il nostro EA ha in un `enum` e che **non è mai stato girato** — il motore produce **n >= 150 posizioni** e un **PF >= 1,10**, oppure ci consegna il certificato che chiude la famiglia M18?
>
> Perché quello è l'unico punto in cui questa caccia può diventare una sedia, e
> costa **1,22 minuti di macchina**. E perché la risposta è utile **in tutti e
> due i versi**: un PASS apre il primo motore M30 di casa, un FAIL chiude con un
> numero una famiglia che nella tassonomia porta ancora il 🥇 e che quindi
> continuerebbe a essere riproposta da ogni caccia futura.

---

## Firma di onestà

**Zero EA esterni promossi.** Un sorgente esterno scaricato, letto riga per
riga e scartato **col numero** (5,9x contro un pavimento di 13,3x). Una misura
nuova su **1.266.562 barre M1** e **1.493 sedute**, con collaudo dell'orologio
**contro l'ipotesi alternativa** e controllo **appaiato**. **Un mio finding
ucciso da me stesso** (§2.4: il terzile favorevole dentro un totale nullo).
**Una regola nuova che contraddice metà del mandato di oggi**, e che ho scritto
perché è misurata e non perché è comoda.

Nessun EA scritto o toccato, nessun backtest eseguito, nessuna riga in
`CODA.txt`, nessun forward toccato, nessuna taglia o rischio deciso.
Secondo strato del cancello: **da lanciare dal chiamante**.
