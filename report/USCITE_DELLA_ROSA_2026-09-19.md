# 🚪 LE USCITE DELLE QUATTRO SEDIE DELLA ROSA — censimento rifatto da zero

**19/09/2026** · mandato: *«per le QUATTRO sedie che schiereremo davvero, quali manopole
d'USCITA non sono mai state mosse?»* · perimetro: `770411` · `770511` · `770402` · `770101`.
Fonti: i **2.186 CSV con colonne `Inp*`** del repo, i sorgenti `.mq5`, i preset vivi,
`report/CENSIMENTO_USCITE_MAI_PROVATE_2026-09-11.md` (letto come **cronaca**, non come coda:
lo dice lui stesso al §7) e `report/LA_ROSA_PER_LA_PROP_2026-09-19.md`.

🚫 Nessun backtest eseguito. Nessun EA, preset o forward toccato. Niente verso il VPS: la
consegna sono due file prova e questo referto.

---

## 🔴 0. LA COSA PIÙ GRANDE CHE HO TROVATO NON È UNA MANOPOLA: È CHE **NON STIAMO CONTANDO LE OPERAZIONI**

> Questa sezione viene prima di tutto perché cambia il significato di **ogni `n` scritto nel
> progetto**, compreso quello di un round scritto **oggi**.

**Il fatto.** Il round **R81** (18/08/2026, sei varianti d'uscita su `770411`) ha prodotto, oltre
ai CSV di ottimizzazione, **dodici file per-trade** che **nessun referto aveva mai aperto**.
Contando i `position_id` **distinti** in
`backtest_pipeline/risultati_archivio/r81_csv/pertrade_r81*.csv`:

| variante | gestione d'uscita | righe (deal) | **posizioni** | colonna `Trades` del CSV |
|---|---|---:|---:|---:|
| `r81a` — **la sedia viva** | scala piena | 21 | **14** | **21** |
| `r81b` | 🔴 tutta SPENTA | 14 | **14** | **14** |
| `r81c` | solo breakeven | 22 | **14** | **22** |
| `r81d` | scala, trail 3,5 | 21 | **14** | **21** |
| `r81e` | scala, trail 1,0 | 15 | **14** | **15** |
| `r81f` | 🔴 tutta SPENTA | 14 | **14** | **14** |

👉 **`Trades` coincide riga per riga col numero di DEAL IN USCITA, mai col numero di POSIZIONI.**
E il contro-esempio è dentro la tabella: **le due sole varianti con la gestione completamente
spenta** fanno `14 = 14` (un deal per posizione), le altre quattro ne fanno 15-22 **sulle stesse
14 posizioni**. Se fosse un caso, non sarebbero proprio quelle due.

### Che cosa rompe, col numero
- **`770411` non ha 41 operazioni: ne ha ~27.** Il contratto (`CONTRATTI_SEDIE.md` r.93) scrive
  *«PF 2,05 · DD 3,1% · **41 tr**»*. Quei 41 sono **20 + 21 = 41 DEAL**. L'OOS misurato vale
  **14 posizioni**; l'IS è `[NON MISURATO]` (nessun per-trade per la gamba IS) ma il rapporto
  osservato è 1,5.
- **Tocca un round scritto oggi.** `R190b` poggia la sua ragione d'essere su *«106 + 184 = 290
  contro il pavimento di 300: mancano 10 operazioni»*. Quei 106 e 184 sono **deal**, e su
  `ABTG_SuperWave_DOW_H1_Ottimizzato` (parziale 50% a 1R + stop in pari) le posizioni vere sono
  `[NON MISURATO]`: **nessun file per-trade esiste per `r120e11`**. Il pavimento può essere molto
  più lontano di come è scritto. 👉 **Va portato a chi legge R190b oggi.**
- **E falsifica il sospetto "filtro travestito" nel verso sbagliato**: un round che *spegne* la
  gestione vede `Trades` scendere **senza un solo ingresso in meno**.

📌 Registrato come **classe 454** in `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`. E la trappola
che ho trovato **provando a usarla** è la **classe 455**: il file per-trade si chiama col magic e
in ottimizzazione ogni cella sovrascrive la precedente — un criterio appoggiato ai `position_id`
in un round a più celle **misura solo l'ultima passata**. La prima stesura di `R191a` lo faceva.
È stata corretta prima della consegna.

---

## 🔬 1. COME HO RIFATTO IL CENSIMENTO (e cosa ho fatto diversamente)

1. **Attribuzione CSV → EA**, con tre regole e un veto: nome dell'EA nel percorso tenendo solo i
   **massimali** (così i CSV di `..._DAX_Short_Ottimizzato` **non** finiscono su
   `ABTG_MaxMinNotte`), oppure `InpMagic` della famiglia; e in tutti e due i casi il veto *«ogni
   colonna `Inp*` del CSV dev'essere un input dichiarato in quel `.mq5`»*.
   🔴 **La prima stesura del mio script sbagliava proprio quello** (il ramo "nome nel percorso"
   rispondeva prima del controllo di massimalità) e attribuiva 20 CSV di R81 anche al motore base,
   inventando per `770402` sei manopole "mosse fra corse" che sull'oro non sono mai state toccate.
   Corretto e rigirato prima di scrivere questa riga.
   Esito: **84 · 22 · 23 · 20** CSV per i quattro EA.
2. **Per ogni manopola, tre stati e non due**: `AD ASSE` (più valori dentro un file),
   `A CORSE` (un valore per file, valori diversi fra file), `MAI MOSSA`.
3. **Per ogni asse, la prova che ha MORSO**: numero di `Profit` distinti e stato delle colonne
   che lo accendono (`InpSLMode`, `InpTrailMode`, `InpUseTrailing`, `InpTP1Pct`, `InpUseNewsFilter`…).
   Un asse a 8 valori con 7 `Profit` distinti su 96 righe **non ha misurato niente**.
4. **Per ogni "mai mossa", la domanda in più**: *è VIVA nella configurazione della sedia, o è
   inerte per costruzione?* Letta nel codice, non dedotta.
5. **E il simbolo si legge dal PERCORSO**, perché nel CSV non c'è (classe 444): un asse girato su
   `100GBP` non dice niente su `D30EUR`.

---

## 📋 2. LE QUATTRO SEDIE, UNA PER UNA

### 🥈 `770411` — `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` · D30EUR M15 · 20 CSV

**Già messe ad asse (a corse, R81, 18/08, fattoriale di 6 varianti con G1 su ogni cella):**
`InpTP1Pct` · `InpBreakeven` · `InpTP2Pct` · `InpUseEMA200Target` · `InpUseTrailing` ·
`InpTrailAtrMult` (1,0 / 2,0 / 3,5). 👉 **La casella «gestione dell'uscita messa ad asse» del
certificato di morte, su questa sedia, è PIENA.** E R81 in `REGISTRO_TEST.md` compariva **solo
come nome di cartella** in una colonna "catena di prova": zero numeri, zero verdetto. Riga vera
aggiunta oggi.

| manopola | stato | prova |
|---|---|---|
| **`InpEntryCutoffHour` / `InpEntryCutoffMin`** | 🔓 **MAI MOSSA, e VIVA** | costanti `8` e `30` in **tutti e 20** i CSV; non compaiono in nessuno dei 6 file prova di R81 |
| `InpTP1_R` | 🔓 MAI MOSSA, viva | costante `1` in tutti e 20 |
| `InpTP2_R` | 🔓 MAI MOSSA, viva | costante `3` in tutti e 20 *(il 2,5→4,0 dell'archivio è su **indici EU**, e sul binario **base**)* |
| `InpAtrSLmult` | 🔓 MAI MOSSA su questo binario | costante `2.5` in tutti e 20. L'asse 1,5/2,0/2,5 di `valid_MaxMin_DAX_short_refine.csv` è sul binario **`ABTG_MaxMinNotte`**, magic 770401 — **altro eseguibile** |
| `InpSLMode` | 🔓 MAI MOSSA su questo binario | costante `1` (ATR) in tutti e 20 |
| `InpCloseHour` / `InpCloseMin` / `InpCloseAtEnd` | 🔓 MAI MOSSA, viva | `17` / `30` / `true` in tutti e 20 |
| `InpEMA200Period` | 🔓 MAI MOSSA, viva | `200` in tutti e 20 — **non era nell'elenco dell'11/09** |
| `InpTPfinal_R` | 🟠 mossa **solo nel regime sbagliato** | `4` vs `2` esiste (r81b vs r81f), ma **solo con tutta la gestione spenta**. Sulla configurazione VIVA è `[NON MISURATO]` |
| **`InpPendingExpiryMin`** | 🧊 **INERTE PER COSTRUZIONE** | piazzamento 7:59 + 90 min = **9:29**, cutoff a **8:30**: l'ordine è morto da 59 minuti quando scadrebbe. Qualunque valore sopra 31 minuti dà lo stesso risultato |
| `InpSLFixedPts` · `InpNewsFlatten` | 🧊 inerti | `InpSLMode=1` e `InpUseNewsFilter=false` nel preset vivo (confermo l'11/09) |

### 🥇 `770511` — `ABTG_SuperWave_DOW_H1_Ottimizzato` · U30USD H1 · 22 CSV

🟢 **La riga dell'11/09 («11 manopole mai mosse, 114 passate») è SUPERATA dai fatti: quattro sono
girate nel frattempo.**

| manopola | stato | prova |
|---|---|---|
| `InpTrailOnST` × `InpExitOnFlip` | ✅ **AD ASSE** (a corse) | **R120b** (00/01/10/11) e **R120e** (00/11), tick reali, ogni cella con G1. `r120e00` IS PF 0,97751 · `r120e11` IS PF 1,39744 |
| `InpSLBufferAtr` | ✅ AD ASSE | **R126a**, 9 celle 0,000…1,000, **9 `Profit` distinti su 9** |
| `InpSLLookback` | ✅ AD ASSE | **R126b**, 7 celle 1…13, **7 `Profit` distinti su 7** |
| `InpTF` | 🕓 round scritto oggi | `R190b` (M30 vs H1) |
| **`InpTP_RR`** | 🔓 **MAI MOSSA, e VIVA** | costante `3` in **tutti e 22**. 🔴 **E R120e ha misurato il trailing SOTTO questo tetto**: le due manopole sono accoppiate e ne è stata misurata una sola |
| `InpTP1_R` · `InpTP1Pct` · `InpBreakeven` | 🔓 MAI MOSSE, vive | `1` / `50` / `1` in tutti e 22 — la scala «parziale + stop in pari» non è mai stata messa in discussione |
| `InpFirstFraction` | 🔓 MAI MOSSA, viva | `0.3333` in tutti e 22. Il file `R124a` esiste e **non è mai girato** |
| `InpSLBufferPips` | 🟠 MAI MOSSA, ma **quasi nulla nei fatti** | `3` in tutti e 22 = **0,03 punti indice** su U30USD. E il suo gemello in ATR (`InpSLBufferAtr`) **è già stato messo ad asse**: il MECCANISMO è coperto, la manopola no |
| `InpEndHour` | 🧊 inerte | `InpUseTimeWindow=false` in tutti e 22 |

### 🥉 `770402` — `ABTG_MaxMinNotte` · XAUUSD · 14 CSV sull'oro (23 sull'EA)

🟢 **Chiude un buco che il censimento dell'11/09 dichiarava aperto** (*«una fra `InpAtrSLmult` e
`InpSLFixedPts` è inerte, ma quale è [NON MISURATO]»*).

**Risposta: lo sono TUTTE E DUE.** In **10 dei 14** CSV sull'oro — compresi i due con magic
`770402`, cioè la sedia stessa (`MaxMin_Oro_r17/*`) — `InpSLMode` vale **0 = `MM_SL_OPPOSITE`**.
Con lo stop sull'estremo opposto del box, **né il ramo ATR né il ramo FIXED vengono mai eseguiti**
(`ABTG_MaxMinNotte.mq5`, enum a r.112). 👉 Su questa sedia **non esiste una manopola di larghezza
dello stop**: la geometria è il box.

| manopola | stato |
|---|---|
| `InpSLMode` | ✅ AD ASSE sull'oro (0/1/2, `MaxMin_Oro/oro_maxmin_fase1_*`, 12 `Profit` distinti su 12) |
| **`InpPendingExpiryMin`** | 🔓 **MAI MOSSA, e QUI È LEI CHE MORDE**: piazzamento 7:00 + 90 = **8:30**, cutoff a **9:30** → l'ordine muore per scadenza, non per cutoff |
| `InpEntryCutoffHour/Min` | 🧊 **INERTE PER COSTRUZIONE** — i ruoli sono **invertiti** rispetto a `770411` |
| `InpTP1_R` · `InpTP1Pct` · `InpBreakeven` · `InpTP2Pct` · `InpTPfinal_R` · `InpUseTrailing` · `InpTrailAtrMult` · `InpUseEMA200Target` · `InpEMA200Period` · `InpCloseHour/Min/AtEnd` | 🔓 MAI MOSSE sull'oro (costanti in tutti e 14) |
| `InpTP2_R` | 🔓 MAI MOSSA sull'oro (`2.5` in tutti e 14) — l'asse 1,5…4,0 è su **D30EUR / F40EUR / E50EUR / 100GBP** |
| `InpAtrSLmult` · `InpSLFixedPts` · `InpNewsFlatten` | 🧊 inerti |

### 4️⃣ `770101` — `ABTG_DAX_Apertura_EU` · D30EUR M5 · 84 CSV

È la sedia con l'uscita **più esplorata** delle quattro. Due correzioni all'11/09:

- 🟢 **`InpTrailFixedPts` NON è `[NON MISURATO]` sul D30EUR.** L'11/09 diceva che sui file DAX il
  ramo FIXED era spento. **Falso su sei file**: `DAX_Apertura/apert_DAX_M5_*_realtick_D30EUR.csv`
  hanno `InpTrailMode=2` (FIXED) con l'asse 100…800 — e su
  `apert_DAX_M5_retest_realtick_D30EUR.csv` (**retest = il modo d'ingresso VIVO**) fa **130
  `Profit` distinti su 130 righe**. Ha morso, sul simbolo giusto, nel modo d'ingresso giusto.
- 🔓 **E c'è un MECCANISMO d'uscita intero che nessuno ha mai acceso, e che il censimento
  dell'11/09 non elencava nemmeno**: `InpUseRoundLevels` + `InpRoundStep` + `InpRoundMinDistPts`.
  A r.1905-1906 quel ramo **sostituisce** il primo obiettivo: invece di `1R` si usa **il prossimo
  numero tondo di PREZZO**. È `false` in **tutti e 84** i CSV. Non è un decimale: è un'altra
  regola di uscita.

| manopola | stato |
|---|---|
| già ad asse, con morso verificato | `InpAtrSlMult` · `InpMinStopPts` · `InpSkipIfTight` · `InpTP1_R` · `InpTP1_ClosePct` · `InpBreakevenAtTP1` · `InpBEatR` · `InpUseTrailing` · `InpTrailStartR` · `InpTrailMode` · `InpTrailTF` · `InpTrailFixedPts` · `InpSlippagePts` |
| `InpSLMode` | ✅ a corse (`0` in 82 file, `1` in 2: `Walkforward_Aperture/DAX_H_drawdown_*`) |
| **`InpUseRoundLevels` / `InpRoundStep` / `InpRoundMinDistPts`** | 🔓 **MAI MOSSE, e VIVE** (`false` / `100` / `50` in tutti e 84) |
| `InpCloseHour` / `InpCloseMin` / `InpCloseAtEnd` | 🔓 MAI MOSSE, vive (`17` / `30` / `true` in tutti e 84) |
| `InpTrailAtrMult` | 🧊 inerte (`InpTrailMode=1` = PREVBAR nella configurazione viva) |
| `InpNewsFlatten` | 🧊 inerte (`InpUseNewsFilter=false`) |

---

## 🏆 3. LA CLASSIFICA — valore del MECCANISMO diviso costo in PASSATE

Ordine dichiarato **prima** di guardare i numeri: vale di più una manopola che cambia **QUANDO si
esce** (o **se l'ordine vive**) di una che sposta un decimale; e a parità di meccanismo vale di
più la sedia il cui **vincolo attuale** è proprio quello che la manopola tocca.

| # | manopola | sedia | il MECCANISMO che cambia | perché lì | passate |
|---|---|---|---|---|---:|
| 🥇 | **`InpEntryCutoffMin`** | **`770411`** | **quanto vive l'ordine** prima di essere cancellato | è l'**unica** manopola della famiglia uscita/tempo, su tutta la rosa, che possa muovere il **numero di operazioni** — e `770411` ha il DD promesso più basso della flotta **e** il campione più sottile (~27 posizioni). Mai mossa in 20 CSV | **10** |
| 🥈 | **`InpTP_RR`** | **`770511`** | **se il trade lo chiude un TETTO o il mercato** | R120e ha misurato trailing e flip **sotto un tetto di 3R mai toccato**: le due manopole sono accoppiate e ne è stata misurata una sola. E il tetto **morde**: sul binario fratello, stesso simbolo e TF a tick reali, il PF va da **1,139 a 1,521** su quell'asse | **14** |
| 🥉 | `InpPendingExpiryMin` | `770402` | **quanto vive l'ordine**, sull'altra sedia MaxMin | stesso meccanismo del 🥇 su un secondo simbolo = la misura in **due modi indipendenti**. ⚠️ Ma il DD promesso è **10,0%**, cioè il muro: comprare frequenza lì è l'affare più caro della rosa | ~12 |
| 4 | `InpTP1_R` (+`InpTP2_R`) | `770411` | **dove** si scarica metà posizione | R81 ha messo ad asse **se** il parziale esiste, mai **dove**. E `r81c` (solo breakeven) batte la sedia viva in tutte e due le finestre | ~12 |
| 5 | `InpUseRoundLevels` | `770101` | **un'altra regola per il primo obiettivo** (numero tondo invece di 1R) | meccanismo intero mai acceso in 84 CSV, e non era nemmeno censito | ~6 |
| 6 | `InpCloseHour`/`Min` | tutte e quattro | **l'ora del flat di fine seduta** | mai mossa su nessuna delle quattro, mai in nessun CSV | 4 ×4 |
| 7 | `InpTP1Pct` / `InpBreakeven` | `770511` | **se il parziale esiste** | già misurato altrove nella flotta; qui cambia un pezzo della scala, non il momento dell'uscita | ~8 |
| 8 | `InpSLBufferPips` | `770511` | (niente) | 🟠 **da NON fare**: vale 0,03 punti indice su U30USD e il gemello in ATR è già stato messo ad asse in R126a | — |

**Prove scritte oggi: le prime due.** Le altre restano in coda, con il numero accanto.

---

## 🎯 4. PERCHÉ `770411` VA GUARDATA PER PRIMA — e qual è la risposta onesta sulla FREQUENZA

Il mandato chiede: *«se una manopola d'uscita le alza la frequenza o le tiene il DD basso alzando
il merito, è il guadagno più grande disponibile oggi»*.

### 🔴 Sulla frequenza la risposta è NO per 15 manopole su 16, e si legge nel codice
`ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5` r.156-193: la giornata ha **tre stati**
(`MMP_WAIT` → `MMP_PLACED` → `MMP_DONE`) e si piazza **una sola volta**. Con
`InpOneTradePerDay=true` il tetto è **1 operazione al giorno, per costruzione**. 👉 Nessuna
manopola che governa l'**uscita della posizione** (TP, parziale, breakeven, trailing, flat)
può aggiungere una sola operazione.

### 🟢 Ne resta UNA, ed è l'orologio che ammazza l'ORDINE
Con `InpPlaceHour/Min = 7:59` e `InpEntryCutoffHour/Min = 8:30`, **i due pendenti sul box notturno
vivono 31 minuti**. Tutte le rotture che arrivano dopo le 8:30 non diventano operazioni. Spostare
quel cutoff è l'unico modo, dentro la famiglia uscita/tempo, di comprare campione **senza toccare
un filtro d'ingresso** (il box, il buffer, lo stop e il filtro di correlazione restano identici).

### 🧊 E il suo gemello è INERTE, il che è metà della scoperta
`InpPendingExpiryMin = 90` → l'ordine scadrebbe alle **9:29**, quando è già morto da 59 minuti.
**Sulla `770411` quella manopola è una casella da segnare "inerte", non "mai provata".**
🔁 E il rovescio lo conferma: su `770402` (oro) il piazzamento è alle **7:00** e il cutoff alle
**9:30**, quindi l'expiry a 90 minuti scatta alle 8:30 e **il cutoff è inerte**. *Stessa coppia di
manopole, ruoli invertiti dai due orologi.* È il motivo per cui il round dell'oro va scritto
sull'**altra** manopola — e il motivo per cui un round scritto "per analogia" avrebbe misurato una
costante.

### 💡 E sul MERITO c'è già un numero in archivio che nessuno ha letto
I sei CSV di R81, mai entrati in `REGISTRO_TEST.md`:

| variante | IS PF / DD / `Trades` | OOS PF / DD / `Trades` |
|---|---|---|
| `r81a` **sedia viva** | 1,87803 / 3,0977 / 20 | 2,15985 / **1,9213** / 21 |
| `r81c` **solo breakeven** | **2,92019** / 4,0891 / 20 | **2,69515** / 3,7338 / 22 |
| `r81b` gestione spenta | 2,37960 / 7,0155 / 13 | 2,20206 / 6,1401 / 14 |

👉 **`r81c` batte la sedia viva in TUTTE E DUE le finestre**, pagando ~1-2 punti di DD.
🛑 **E non si promuove**: sono **14 posizioni** fuori campione, il merito è **sospeso** (valvola
R59) e la differenza fra 2,16 e 2,70 di PF su 14 posizioni **è rumore fino a prova contraria**.
Vale come indizio e come riga da mettere in `REGISTRO_TEST.md`, non come decisione.

---

## 🛑 5. IL CONTRO-ESEMPIO OBBLIGATORIO — che cosa vedrei se questi round misurassero la cosa sbagliata

**Muovere una manopola d'uscita cambia il motore, non solo il risultato.** I cinque modi in cui
questi due round possono mentire, scritti **prima** dei numeri e congelati dentro i file prova:

| # | il modo di mentire | come si vedrebbe | difesa messa nel file prova |
|---|---|---|---|
| **1** | **filtro travestito da uscita** | `InpEntryCutoffMin` a 8:10: PF **su**, `n` **giù** | 🔴 **soglia congelata: nessuna cella con meno `Trades` dell'ancora è promuovibile, a nessun PF.** La cella 10 sta nell'asse **apposta** come trappola |
| **2** | **il campione che non è un campione** | `Trades` sale ma le posizioni no | il proxy `ΔTrades ≈ Δposizioni` vale **solo** se la scala d'uscita è pinnata e identica fra le celle. In `R191a` lo è (e lo si dichiara); in `R191b` **no**, perché l'asse È un pezzo della scala — e lì il criterio si scrive su PF e DD, con la soglia dei 150 applicata al numero **più basso** fra le celle |
| **3** | **la forma NASUSD** (dentro campione sale, fuori crolla: PF OOS 1,147 → 0,688, misurato oggi) | IS monotono, OOS che si gira | nessuna cella è "meglio dell'ancora" se non lo è in **tutte e due** le finestre. Se l'IS è monotono e l'OOS no, il verdetto è **«asse non stazionario»** e si scrive così |
| **4** | **il picco scambiato per altopiano** | una cella sporge, le vicine no | centro dell'altopiano, **MAI** il picco. Se l'altopiano non c'è, il verdetto è *«non c'è una configurazione robusta»* |
| **5** | 🔴 **il COSTO che si sposta sotto i piedi** (vale solo per `R191a`) | niente: **non si vede nei CSV** | allungando il cutoff i trade nascono **più tardi**: l'ATR intraday cala (stop più stretto) e lo spread `D30EUR` alle 09-10 server è `[NON MISURATO]` (il referto ha solo l'ora 08 = 1,70 e l'ora 21 = 2,80). La sedia è già **🟠 FRAGILE** (37,8x-51,5x contro il pavimento 40x). 👉 **Nessuna cella oltre l'ancora è promuovibile senza una misura NUOVA di spread e ATR nella fascia oraria che apre** |

E il sesto, che è specifico di `R191b` e l'ho trovato leggendo il codice: **`InpTP_RR = 0` non
vuol dire "nessun tetto".** A r.375 non c'è nessun `if(tp>0)` — con 0 il take profit cade
**esattamente sul prezzo d'ingresso**, e la cella misurerebbe *«nessun trade»*, non *«lascia
correre»*. (Il confronto che lo rende evidente: `ABTG_CostToCost.mq5` r.829-834 quella guardia
ce l'ha.) **L'asse parte da 1,50 apposta.**

---

## 📦 6. I DUE FILE PROVA CONSEGNATI

| file | sedia | asse | celle | passate | ancora | deposito |
|---|---|---|---:|---:|---|---|
| `backtest_pipeline/prove/R191a_orologio_ordine_MAXMINDAX_D30EUR.txt` | `770411` D30EUR M15 | `InpEntryCutoffMin` 10/30/50/70/90 | 5 | **10** | cella **30** = `r81a` (IS PF 1,87803 DD 3,0977 `Trades` 20 · OOS PF 2,15985 DD 1,9213 `Trades` 21) | **100000** |
| `backtest_pipeline/prove/R191b_tprr_SUPERWAVEDOW_U30USD.txt` | `770511` U30USD H1 | `InpTP_RR` 1,50→6,00 passo 0,75 | 7 | **14** | cella **3,00** = `r120e11` (IS PF 1,39744 DD 3,4846 `Trades` 106 · OOS PF 1,22034 DD 4,2149 `Trades` 184) | **100000** |

### 💰 Il deposito, scritto NELLA TESTA di ogni file (classe 453)
Tutti e due portano in riga 7 `#  Si lancia con: -Deposito 100000 -Modello 4`, **con fonti
DIVERSE e non ereditate l'una dall'altra**:
- `R191b` → **`backtest_pipeline/coda/CODA.txt` r.335**, la riga ARMATA di `r120e11`: fonte grezza.
- `R191a` → 🔴 **buco dichiarato**: la riga di lancio di R81 **non esiste** in `CODA.txt` né nei
  referti runner (cercata il 19/09 con `grep -rn`: zero righe con `R81` e `Deposito` insieme). La
  fonte più grezza sopravvissuta è l'intestazione di `prove/R81a_uscita_A_viva.txt` r.5. Per questo
  è stata **controincrociata col metodo della classe 453 stessa**: `+4.766,96` su 20 deal a
  rischio 1% = **+4,77%** del capitale; a 10.000 sarebbe +47,7% con un payoff medio di **2,4R** a
  PF 1,88 — aritmeticamente impossibile. **100.000 confermato in due modi.**

### ⏱️ Il costo — STIMA, con le basi dichiarate
**24 passate in tutto.**
- 🟢 **`R191a`: 10 × 0,700 = 7,0 minuti**, e la base **non è una trasposizione**:
  `risultati_archivio/R104_REFERTO_DRIVER_20260825_0738.txt` r.15 — *«durata: 0.7 minuti di
  passata»* — sullo **stesso EA** (copia di misura `_MFE`), **stesso simbolo D30EUR, stesso M15,
  stessi tick reali, stesso deposito 100000**, su una finestra perfino **più lunga di due mesi**.
  Il numero è scritto due volte in due posti diversi (quel referto e `REGISTRO_TEST.md`, sezione
  R187) e le due scritture coincidono.
- 🟠 **`R191b`: 14 × 0,700 = 9,8 minuti**, usando l'estremo alto come chiede il mandato. La base
  misurata più vicina è **0,083 min/passata** (R88a, 96 passate in 8,0 minuti, **stesso U30USD a
  tick reali**, ma su M5 e su un altro EA) → il costo vero è probabilmente **1,2 minuti**: su H1 le
  barre da costruire sono ~10.900 contro le ~120.000 di M5.
👉 **Totale dichiarato all'estremo alto: ~17 minuti. Banda vera attesa: 8 – 17 minuti.**

### ✅ I cancelli, primo strato
```
python3 backtest_pipeline/controlla_prova.py  -> 2 file, 12 celle, 24 passate, 0 problemi
python3 backtest_pipeline/controlla_riga.py --oggetto prova (x2) -> nessun difetto meccanico
```
⚠️ Un **avviso di quota** (non bloccante): `R191b` pesa 7 celle su 12 = 58,3% del gruppo. È voluto:
7 celle sono il minimo per vedere un altopiano su un asse continuo.
🔒 **Magic vergini, cercati il 19/09 con `grep -rl` su tutto il repo (`.git` e `.claude` esclusi):
`787410` e `787420` → ZERO occorrenze.** Etichette `r191a` / `r191b`: ZERO.
⏳ **Il secondo strato (`controllo-preventivo`) lo lancia il coordinatore. Finché non torna, questi
file non vanno verso il VPS.**
🎯 **Bersaglio dei round: banco `C:\MT5_Backtest`, demo `50504400`.** NON il piccolo `50503392`,
NON il 100k `50504263`, NON il reale `10105439`.

---

## 🕳️ 7. I BUCHI, DICHIARATI

1. **Le posizioni vere di `r120e11` sono `[NON MISURATO]`** (nessun per-trade per quel round). I
   `106` / `184` sono **deal**. Tocca l'argomento centrale di `R190b`.
2. **Le posizioni della gamba IS di `r81a` sono `[NON MISURATO]`** (i per-trade coprono solo l'OOS,
   2025.08.19 → 2026.06.24). Il rapporto osservato in OOS è **1,5 deal per posizione**.
3. **Lo spread `D30EUR` nella fascia 09-10 server è `[NON MISURATO]`** — e senza quel numero
   nessuna cella larga di `R191a` è promuovibile.
4. **`R81` era in `REGISTRO_TEST.md` solo come NOME DI CARTELLA** (r.3611, colonna "catena di
   prova"): un round completo, girato e caricato il 18/08, con sei varianti e i per-trade, di cui
   il registro non portava **un solo numero**. Riga vera aggiunta oggi.
5. **Il DD promesso di `770411` (1,27%) non è il DD dell'ancora** (3,0977% IS / 1,9213% OOS a
   rischio 1,0%). Vengono da due misure diverse e `CONTRATTI_SEDIE.md` non lo dice. **Serve una
   decisione su quale sia il contratto**, non una correzione automatica.
6. **`770411` gira su DUE conti con lo STESSO magic** (preset `..._770411_100K.set`, nota R1):
   qualunque conteggio di campo per magic mescola due taglie. Non tocca questi round, tocca chi
   legge il forward.
7. **Nessuna base di tempo macchina è mai stata misurata su `ABTG_SuperWave_DOW_H1_Ottimizzato`**
   (per `R191a` la base c'è, misurata, ed è citata sopra). Si misura al primo giro e si scrive.

---

*Script del censimento: `/tmp/.../cens4.py` + `cens4b.py` (usa e getta, non versionati: tutti i
numeri qui sopra sono riproducibili aprendo i CSV citati per nome). Classi nuove:
**454** e **455** in `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`.*
