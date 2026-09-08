# 🧭 PORTING P2 — `ABTG_LVNArbitro`: l'arbitro del livello — 08/09/2026

**Cosa consegno oggi**, e in una riga: il candidato **P2** della caccia M30
(`report/CACCIA_M30_INDICI_2026-09-08.md`, **9/10**, il più economico dei tre)
è **passato da 57 righe di Pine a un EA di casa**, con lo stop vero al broker, il
rischio in percentuale, il flat di seduta e il PASSO 0 pronto da lanciare.

| prodotto | percorso |
|---|---|
| 🧠 l'EA | `/home/user/GITHUB/mql5/Experts/ABTG_LVNArbitro.mq5` (1.009 righe, 28 input) |
| 🧪 il file prova PASSO 0 | `/home/user/GITHUB/backtest_pipeline/prove/ABTG_LVNArbitro_00_conta.txt` |
| 📄 questo referto | `/home/user/GITHUB/report/EA_LVN_ARBITRO_2026-09-08.md` |
| 📚 la fonte archiviata | `/home/user/GITHUB/backtest_pipeline/caccia_strategie/biblioteca/sorgenti/LvnRejectionAcceptance_AIScripts-MPL2_tvj35ygZIm_2026-09-08.pine` |
| 📝 la spec congelata prima | `/home/user/GITHUB/backtest_pipeline/prove/LVNARBITRO_M30_BOZZA.txt` |

🔴 **E LA RIGA CHE VA DETTA PER PRIMA: NON HO COMPILATO NIENTE.** Qui non c'è
MetaEditor, non c'è MT5, non c'è lo Strategy Tester. Quello che ho fatto è una
**revisione statica** (parentesi bilanciate, ASCII puro, conteggio degli
argomenti di ogni `StringFormat`/`PrintFormat`, API confrontate riga per riga con
gli EA di casa già compilati). **La compilazione la fa il round sul VPS**, ed è
lì che si scopriranno gli errori che una revisione statica non vede.

---

## 1. ⚙️ IL MECCANISMO, COM'È FINITO NEL CODICE

Banda mobile, e sullo **stesso bordo** due letture opposte:

```
banda:   base  = SMA(close, InpBandaLen)
         alto  = base + InpBandaAtr * ATR(InpAtrLen)
         basso = base - InpBandaAtr * ATR(InpAtrLen)

RIFIUTO  (fade, chiede anche il volume basso)
  LONG :  min[1] < basso  E  close[1] > basso  E  volume basso
  SHORT:  max[1] > alto   E  close[1] < alto   E  volume basso

ACCETTAZIONE (breakout, niente volume)
  LONG :  close[1] > alto   E  close[2] > alto
  SHORT:  close[1] < basso  E  close[2] < basso
```

Tutto **su barra chiusa** (shift 1), ingresso a mercato all'apertura della barra
successiva. Niente look-ahead, niente repaint, **una posizione alla volta**.

👉 **L'arbitro È il motore**: togli la condizione e non resta un motore peggiore,
**non resta nemmeno la direzione dell'operazione**. È la condizione B di
`ROBUSTEZZA.md` (filtro che è la strategia: 30 celle su 30), non la condizione A
(filtro appiccicato dopo: 0 successi su 5).

---

## 2. ✂️ COSA HO PRESO DAL PINE E COSA HO DECISO IO

**Regola di casa applicata alla lettera: una scelta non dichiarata è un parametro
nascosto.** Quindi eccole tutte, una per riga.

### 2.1 🟢 PRESO DALLA FONTE (tale e quale)

| cosa | valore | dove sta nel Pine |
|---|---|---|
| banda SMA ± ATR | `SMA(40) ± 0,8 × ATR(14)` | righe 16-20 |
| media volumi sulla **stessa** finestra della banda | `SMA(volume, 40)` | riga 23 |
| soglia "volume basso" | `< 0,8 × media` | riga 24 |
| le 4 condizioni rifiuto/accettazione | identiche | righe 27-31 |
| una posizione alla volta | sì | righe 37-41 |
| stop = `1,5 × ATR` | sì | righe 44-48 |
| target = `RR × R`, RR = 2,0 | sì | righe 45-48 |
| simmetria esatta long/short | sì | tutto il blocco |

### 2.2 🟡 DECISIONI MIE — dichiarate una per una

| # | decisione | perché, in una riga |
|---|---|---|
| **D1** | **Lo stop viaggia DENTRO l'ordine di mercato** | Nel Pine `strategy.exit` è fuori dal blocco d'ingresso e usa `strategy.position_avg_price`, che sulla barra d'ingresso vale `na`: **la prima barra è scoperta**, su M30 sono **30 minuti senza stop**. È il difetto vero della fonte, ed è la parte che sappiamo rifare |
| **D2** | **Rischio in % (`InpRiskPercent` 0,65), mai `percent_of_equity`** | Il Pine usa **5% dell'equity per operazione**: è taglia, non rischio. UNA posizione, **UNA tranche** → il difetto del lotto in tranche corretto oggi in 15 sorgenti (`report/FIX_LOTTO_PENDENTE_2026-09-08.md`) **qui non può nemmeno presentarsi** |
| **D3** | **`close[2]` si confronta col bordo della barra DI SEGNALE**, non col bordo di due barre fa | È **fedeltà**, non licenza: nel Pine `lvnUpper` non è indicizzato, quindi `close[1] > lvnUpper` guarda la banda **corrente**. Cioè "due chiusure sopra lo **stesso** bordo" — che è anche la lettura più sensata |
| **D4** | **Barra che accende ENTRAMBE le direzioni → NESSUN TRADE** | Una barra enorme può perforare i due bordi e chiudere dentro. Nel Pine quel caso manda **due ordini opposti sulla stessa barra**: non è una strategia, è un ribaltamento involontario. Contato in `gCntAmbiguo` |
| **D5** | Rifiuto **e** accettazione sullo stesso lato e sulla stessa barra → si **conta come RIFIUTO** | È la condizione più rara e più informativa. Cambia solo l'etichetta e il commento dell'ordine, non l'operazione |
| **D6** | **Finestra oraria 08:00-20:30 SERVER + flat 21:00** (non c'è nella fonte) | Il Pine opera 24h. Fuori sessione lo spread misurato sugli indici BCM **raddoppia** (DAX 3,5-3,9 punti contro 1,6-1,7) e la frontiera `stop ≥ 40 × spread` salterebbe. **Zero overnight** è regola di casa. Allargare è un input, non una riscrittura |
| **D7** | **Pavimento di stop `InpMinStopPts` = 25 punti indice** (R109) | `OnInit` **rifiuta** se è 0. Non viene dalla fonte |
| **D8** | **Gate di spread in % dello stop** (`InpMaxSpreadPctOfStop` 2,5) | R55: un cancello in punti fissi mente cambiando simbolo, questo no |
| **D9** | 🔴 **NIENTE PARZIALE, contro quanto ipotizzava la bozza** | La bozza proponeva "parziale a 1R + BE + runner". **Non l'ho fatto, e lo dichiaro**: (a) reintrodurrebbe il calcolo del lotto in tranche, il difetto appena corretto in 15 file; (b) il PASSO 0 deve misurare **il motore nudo**, non la nostra gestione. Il BE c'è ma **`InpBEatR = 0` = SPENTO** = default neutro rispetto alla fonte |
| **D10** | **`InpMaxTradesPerDay = 0` (illimitato) = come la fonte** | Il dossier segnala che P2 è "il candidato col rischio giornaliero peggiore dei tre". Il tetto **esiste** come input, ma si accende **dopo** aver misurato la colonna *Peggior Giornata %*, non prima. Tappare a tavolino sarebbe curve-fitting sulla paura |
| **D11** | **Il filtro volume si può SPEGNERE** (`InpUsaFiltroVolume`) | Vedi §3: è l'unico modo di misurare quanto pesa una variabile che sul nostro feed **significa un'altra cosa**. Default `true` = come la fonte |
| **D12** | **I segnali grezzi si contano anche a posizione APERTA** | Il PASSO 0 deve dire quante **occasioni** c'erano, non quante ne abbiamo prese. Se `segnali >> Trades`, il collo di bottiglia è **l'occupazione**, non il motore — e si legge dal CSV invece di doverlo indovinare al round dopo |

---

## 3. 🔴 IL LIMITE NOTO N.1, SCRITTO IN TESTA AL `.mq5`: IL VOLUME

Il sorgente usa `volume`, che su TradingView per i futures è **volume scambiato**.
Su BCM, sugli indici CFD, MT5 espone **TICK VOLUME**: conta i **cambi di prezzo**,
non i contratti. **Non è la stessa variabile**, e il ramo *rifiuto* ci poggia
sopra per intero: **può cambiare segno per questo motivo e per nessun altro**.

Come l'ho gestito, invece di sperare:

1. ✅ **Dichiarato in testa al file** (blocco `LIMITE NOTO N.1`) e ripetuto nel
   log di avvio — regola di casa già pagata su un altro motore;
2. ✅ **la soglia è un input** (`InpVolFrazione`);
3. ✅ **il filtro si può spegnere** (`InpUsaFiltroVolume`) → la prova successiva è
   già scritta: se il ramo rifiuto esce a zero, si rigira con `false`;
4. ✅ **i due rami hanno contatori SEPARATI nel CSV** (`Rifiuto Long/Short`,
   `Accett Long/Short`) — un numero aggregato non saprebbe dire **se ha fallito
   il meccanismo o la variabile**.

---

## 4. 📋 TABELLA DEGLI INPUT (28)

| input | default | da dove viene |
|---|---|---|
| `InpUsaGuardian` | `true` | casa (firme B1/C1 del 18/08) |
| `InpBandaLen` | `40` | 🟢 fonte |
| `InpBandaAtr` | `0.8` | 🟢 fonte |
| `InpAtrLen` | `14` | 🟢 fonte |
| `InpVolFrazione` | `0.8` | 🟢 fonte (soglia resa input: D11) |
| `InpUsaFiltroVolume` | `true` | 🟡 mio (D11) — default = fonte |
| `InpUsaRamoRifiuto` | `true` | 🟡 mio — serve a misurare i rami separati (C5) |
| `InpUsaRamoAccettazione` | `true` | 🟡 mio — idem |
| `InpAllowLong` / `InpAllowShort` | `true` / `true` | casa (regola dei due lati, 25/08) |
| `InpOraInizio` / `InpMinInizio` | `8` / `0` | 🟡 mio (D6) — **ORA SERVER** |
| `InpOraFine` / `InpMinFine` | `20` / `30` | 🟡 mio (D6) — **ORA SERVER** |
| `InpUsaFlatSeduta` | `true` | casa — zero overnight |
| `InpOraFlat` / `InpMinFlat` | `21` / `0` | casa — **ORA SERVER** |
| `InpStopAtr` | `1.5` | 🟢 fonte |
| `InpMinStopPts` | `25` | casa (R109, `OnInit` rifiuta lo 0) |
| `InpMT5PerPuntoIndice` | `100` | casa (indici BCM) |
| `InpRR` | `2.0` | 🟢 fonte |
| `InpBEatR` | `0.0` **spento** | 🟡 mio (D9) — default neutro |
| `InpRiskPercent` | `0.65` | casa (contratto) |
| `InpMaxSpreadPctOfStop` | `2.5` | casa (R55) |
| `InpMaxTradesPerDay` | `0` **illimitato** | 🟡 mio (D10) — default = fonte |
| `InpMagic` | `769900` | vedi §5 |
| `InpComment` | `"LVN"` | casa |
| `InpVerbose` | `true` | casa |

⏰ **Gli orari sono TUTTI in ORA SERVER BCM (= ora italiana − 1)**, scritto nel
commento di ogni input e ripetuto nel log di avvio. Un'ora sbagliata qui **non dà
errore: misura un'altra strategia.**

---

## 5. 🔢 IL MAGIC: **769900**, e perché

- 📖 Letto `backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260908_033003.log`:
  le sedie vive stanno tutte nel blocco **77xxxx** (più tre `97xxxx` degli
  `_Ottimizzato`). Nessuna usa 76xxxx.
- 🔍 `grep -rn "76[0-9]\{4\}" mql5/` → occupati: `769000, 769100, 769200, 769300,
  769400, 769500, 769501, 769502, 769503, 769510, 769600, 769700, **769800**`.
  **769800 è di `ABTG_ImpulsoApertura`, scritto stamattina.**
- ✅ `grep` su tutto il repo per `769900` e `769950`: **zero occorrenze**.
  Servono entrambi perché l'asse tecnico del PASSO 0 gira `769900 → 769950`.

👉 **Scelto `769900`**: primo libero dopo quello di stamattina, stesso blocco
(76xxxx = motori in imbuto), **nessuna collisione possibile** con le sedie in
forward.

---

## 6. 🛡️ LE REGOLE DI CASA, UNA PER UNA — dove sono nel codice

| regola | dove | ✅ |
|---|---|---|
| Orari in **ora server**, ora e minuti come `input` | `InpOraInizio/Min…`, commenti + log di avvio | ✅ |
| **`InpRiskPercent`** e lotto per rischio | `LotByRisk()`, **una sola tranche** (D2) | ✅ |
| **Nessun pavimento-lotto in tranche** | non esiste una seconda tranche: il difetto non è rappresentabile | ✅ |
| **`InpMagic` libero** | `769900`, verificato (§5) | ✅ |
| **Guardian prima di ogni ingresso** | `ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_LVNArbitro")` **immediatamente prima** del `Buy/Sell`, mai in cima all'imbuto | ✅ |
| **Stop SEMPRE presente all'ingresso** | `gTrade.Buy(lot,_Symbol,0.0,sP,tP,cm)` — SL **dentro** l'ordine, più pavimento R109 e `SYMBOL_TRADE_STOPS_LEVEL` | ✅ |
| **Flat di fine seduta**, zero overnight | `FlatFineSedutaCheck()`, ora server, `InpUsaFlatSeduta` per l'esperimento dichiarato | ✅ |
| **Log di avvio con la configurazione** | `OnInit` stampa 26 campi (censimenti) + due righe di avvertenza | ✅ |
| **Niente martingala/griglia/recovery/piramidazione** | ingresso singolo, `HoPosizione()` blocca il secondo | ✅ |
| **Tick-volume dichiarato come limite noto** | testa del file + log + soglia input + interruttore | ✅ |
| Normalizzazione prezzi / volumi / retcode | `NormalizePrice()` su tick size, `VOLUME_MIN/MAX/STEP`, retcode controllato dopo l'ordine | ✅ |
| Handle rilasciato in `OnDeinit` | `IndicatorRelease(gAtrH)` | ✅ |
| Commenti in italiano, **zero emoji nel `.mq5`** | verificato a macchina: **0 byte non-ASCII** | ✅ |

---

## 7. 🧪 IL FILE PROVA DEL PASSO 0 — e l'attesa dichiarata

`backtest_pipeline/prove/ABTG_LVNArbitro_00_conta.txt`
`@SIMBOLO U30USD` · `@PERIODO M30` · `@DAQUANDO 2024.09.26` ·
**un solo asse Y** (il magic, due celle identiche = gemelli di determinismo G1) ·
**27 pin**, tutti gli altri input fissati **uno per uno** al default del sorgente.

### 📏 L'ATTESA, congelata PRIMA dei numeri (è la parte che vale di più)

Il conto, con le ipotesi in chiaro: finestra 08:00-20:30 server su M30 = **25
barre di decisione per seduta**, ~440 sedute nei 21 mesi; il segnale **non è
raro** (la banda è larga solo 0,8×ATR attorno alla SMA40); il vincolo vero non è
il segnale ma **l'occupazione** — una posizione alla volta, che vive fino a stop
(1,5 ATR), target (3 ATR) o flat.

> ### 🎯 **Attesa centrale: 1,0-2,5 operazioni per seduta su U30USD → ~450-1.100 operazioni in 21 mesi.**
> Diviso IS/OOS fa **~225-550 per parte**: **sopra il pavimento dei 150** su **un
> solo simbolo**. Se regge, è il **primo candidato della coda M30 che non ha
> bisogno di mettere in comune i tre indici** per avere un campione.

Le soglie, dichiarate adesso e non dopo:

| esito | verdetto |
|---|---|
| **< 100** operazioni (0,23 op/g) | la mia stima è sbagliata e va detto; resta in piedi solo come famiglia a tre simboli |
| **< 30** operazioni | 🔴 **BOCCIATO per frequenza**, come `ABTG_OpeningReversalB` stamattina (2 operazioni in 21 mesi). Senza appello |
| **> 2.000** operazioni (4,5 op/g) | il motore mitraglia → la colonna **Peggior Giornata %** diventa il cancello principale |
| **= 0** | ⚠️ **non è un verdetto: non è girata.** Si legge il log prima di scrivere qualsiasi cosa |

Attesa sui **rami**: molti più segnali di **accettazione** che di **rifiuto**
(il rifiuto chiede tre condizioni congiunte) — stima grezza **10-25%** di
rifiuti. Se il rifiuto esce ≈ 0, il sospetto n.1 è **il tick volume**, non il
motore. Attesa sui **lati**: stesso ordine di grandezza; oltre 70/30 è deriva del
sottostante (il Dow 2024-2026 sale), non del codice, e va scritto così.

### ✅ L'ESITO DEL CONTROLLORE, incollato

```
$ python3 backtest_pipeline/controlla_prova.py backtest_pipeline/prove/ABTG_LVNArbitro_00_conta.txt
=== CONTROLLO FILE PROVA ===
  ABTG_LVNArbitro_00_conta.txt     ABTG_LVNArbitro.mq5        pin=27 celle= 2  OK

file: 1 | celle totali: 2 | passate (celle x 2 finestre): 4 | problemi: 0
ESITO: OK
```

---

## 8. ⚠️ LIMITI DI QUESTA CONSEGNA — dichiarati, non nascosti

1. 🔴 **NON COMPILATO.** Nessun `.ex5` esiste. La revisione è **statica**:
   parentesi bilanciate (0 di sbilancio), 0 byte non-ASCII, argomenti di ogni
   `StringFormat`/`PrintFormat` contati a macchina, API confrontate con
   `ABTG_ImpulsoApertura.mq5` e `ABTG_DAX_Apertura_EU.mq5`. **Un errore di
   compilazione resta possibile** e lo troverà MetaEditor.
2. 🔴 **Nessun backtest, nessun numero.** Non ho lanciato niente, non ho MT5.
   Tutto ciò che c'è in §7 è **una previsione**, scritta apposta prima.
3. 🟠 **ATR di MT5 ≠ `ta.atr` di Pine bit a bit** (stessa formula RMA/SMMA, ma
   inizializzazione e storico disponibile differiscono). Le prime decine di barre
   della finestra possono dare bande leggermente diverse dal grafico TradingView:
   **non si confrontano i due backtest**, si misura il nostro.
4. 🟠 **La finestra oraria (D6) è una mia scelta e cambia il motore**: la fonte
   opera 24h. Se la frequenza uscisse sotto le attese, **il primo esperimento è
   allargare la finestra**, non toccare la banda.
5. 🟠 **Un solo regime**: 21 mesi di indici 2024-2026 non contengono un orso, né
   un crollo, né un laterale lungo. Questo round **non può** dare un verdetto di
   regime e non deve pretenderlo.
6. ⬜ **Non ho scritto i gemelli** `D30EUR` e `NASUSD`: si scrivono quando il
   conteggio su U30USD dice che ha senso girarli (diff meccanico, solo
   `@SIMBOLO` diverso).

---

## 9. 🚦 COSA SUCCEDE DOPO (e cosa NON succede)

1. **Compilare** `ABTG_LVNArbitro.mq5` in MetaEditor (F7) sul terminale da
   backtest **C:\MT5_Backtest (conto 50504400)** — **non** sui terminali delle
   sedie vive.
2. **Girare il PASSO 0** (`ABTG_LVNArbitro_00_conta.txt`, 2 celle) e leggere:
   `Trades`, `Long`/`Short`, i quattro contatori dei rami, `Peggior Giornata %`.
3. **Solo se il conteggio regge** → gemelli D30EUR/NASUSD, poi la griglia da
   **27 celle** già congelata in `LVNARBITRO_M30_BOZZA.txt`, con la cella scelta
   **al centro dell'altopiano, MAI al picco**.
4. 🛑 **Cosa NON succede: nessuna promozione da qui.** Il PASSO 0 non ha assi di
   merito. Un motore letto nel sorgente e portato in MQL5 è un **candidato**,
   non una sedia — e nessuno va in campo senza passare l'imbuto e il forward.

🔒 **Nessun EA in forward toccato, nessun preset, nessun parametro, nessun magic
esistente, nessuna sedia accesa o spenta, nessun backtest lanciato.**

---

## 📎 ATTRIBUZIONE E LICENZA

| | |
|---|---|
| **fonte** | *LVN Rejection / Acceptance Strategy* — TradingView, slug `j35ygZIm` |
| **autore** | **AIScripts**, creato 06/05/2026, Pine v6, 57 righe, 5 input |
| **licenza** | 🟢 **MPL 2.0**, dichiarata in testa al sorgente [VERIFICATO] — https://mozilla.org/MPL/2.0/ |
| **come l'ho usata** | sorgente **LETTO riga per riga**, **nessuna riga copiata**. `.mq5` scritto **da specifica** |
| **dove sta l'attribuzione** | in **testa al `.mq5`** (righe 8-22), nel file prova, e qui |

⚠️ **E il promemoria che il dossier voleva in evidenza: il nome della fonte
mente.** Non c'è nessun Volume Profile e nessun Low Volume Node: è una banda
SMA ± ATR. Chi promuovesse questo motore **per il nome** comprerebbe una cosa che
non esiste. È promosso per **le sei righe** che lo definiscono.
