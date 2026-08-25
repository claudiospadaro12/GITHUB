# ⚖️ IL CANCELLO ZERO DEGLI INDICI _EXT — METRO ASSOLUTO O METRO RELATIVO? (25/08/2026)

_Analisi DA REPO (niente web, niente MT5), branch `lavoro`. Missione: capire se
il metro 0,05% che tiene in frigo `NASUSD_EXT` / `225JPY_EXT` / `SPXUSD_EXT` e'
giusto o tarato male, e preparare la decisione per Claudio CON UNA MISURA
DAVANTI. Non tocca script, non tocca R109 ne' la RIGA_STORICO_INDICI._

---

## 1. 🔬 COSA MISURA ESATTAMENTE IL CANCELLO ZERO (letto nel sorgente, non a memoria)

**Definizione della soglia** — `backtest_pipeline/prove/PROVA_REGIME_CRITERI.md`
§2, congelato il 14/08/2026: _"differenza media > 0,05% del prezzo, oppure meno
dell'80% delle barre H1 in comune -> il simbolo NON si usa"_. La soglia nacque
quel giorno da una CORREZIONE DICHIARATA (la prima stesura diceva "2 points",
unita' sbagliata) ed e' **una sola, assoluta, per tutti gli strumenti**:
_"la soglia in percentuale di prezzo vale identica su EURUSD, oro e indici"_.
**Quindi si': il metro e' stato tarato guardando i forex** (EURUSD_EXT 0,0041%
e GBPUSD_EXT 0,0052% sono citati nel testo stesso della correzione come prova
che "passano larghi"). Gli indici, quel 14/08, non esistevano ancora come _EXT.

**La formula** — `mql5/Scripts/ABTG_ImportaStoricoEsterno.mq5` (v1), funzione
di confronto, righe 497-511:

- per ogni **bucket H1** presente in ENTRAMBI i feed nel periodo di
  sovrapposizione (nativo BCM: dal 26/09/2024 → fine import), si prende
  `|CloseH1_importato - CloseH1_nativo|` (la close H1 importata = close
  dell'ultima M1 dell'ora);
- `diffMediaPct = 100 × Σ|diff| / Σprezzo` → e' una **media pesata sul
  prezzo** delle differenze assolute di chiusura H1, in % del prezzo;
- il verdetto in codice (righe 639-644): `<= 0,05%` → `OK CONFRONTABILE`,
  `<= 0,20%` → `DIFFERENZE FEED APPREZZABILI`, oltre → peggio.

**Su quali ore**: TUTTE le ore H1 della sovrapposizione, **DST incluso** —
nella v1 con shift FISSO (+5), quindi le ~503-671 ore l'anno in cui il
calendario DST USA e quello europeo non coincidono entrano nella media **con
un'ora di disallineamento** (REFERTO_HISTDATA §14-bis.1: 5,7-7,7% delle ore).
La v2 (`IMP-EXT-v2`, DST-aware) corregge lo shift ora per ora e **spacca la
diff dentro/fuori le finestre sfasate** — ed e' stata misurata il 19/08.

---

## 2. 📊 I NUMERI AGLI ATTI (fonti riga per riga)

### 2a. I forex _EXT PROMOSSI (v1, shift +5, intero periodo di sovrapposizione)

| simbolo | diff media H1 | copertura | fonte |
|---|---:|---:|---|
| EURUSD_EXT | 0,0041% | 99,6% | `PROVA_REGIME_CRITERI.md` §2 + `REFERTO_ROUND50_REGIME.md` r.8 |
| GBPUSD_EXT | 0,0052% | 99,6% | idem |
| USDJPY_EXT | 0,0054% | 99,6% | `REFERTO_IMPORT_6_SIMBOLI.md` §1 |
| EURJPY_EXT | 0,0063% | 99,6% | idem |
| GBPCAD_EXT | 0,0072% | 99,5% | idem |
| CHFJPY_EXT | 0,0080% | 99,6% | idem |
| AUDJPY_EXT | 0,0090% | 99,6% | idem |
| XAUUSD_EXT | 0,0110% | 99,2% | idem |

### 2b. Gli indici _EXT IN FRIGO (v2 DST-aware, 19/08 — `import_ext_v2_referto_2026-08-19.csv`)

| simbolo | diff TOTALE v1 (+5 fisso) | diff TOTALE v2 (DST-aware) | **diff FUORI finestre sfasate** | diff DENTRO | bias mediano | copertura |
|---|---:|---:|---:|---:|---:|---:|
| SPXUSD_EXT | 0,0608% | 0,0655% | **0,0527%** | 0,2167% | +0,0075% | 96,8% |
| NASUSD_EXT | 0,0756% | 0,0815% | **0,0662%** | 0,2673% | +0,0013% | 96,8% |
| 225JPY_EXT | 0,1010% | 0,1097% | **0,0871%** | 0,3741% | +0,0062% | 96,9% |

Per il confronto col metro si usa la colonna **FUORI finestre** (come gia'
argomentato in REFERTO_HISTDATA §16.2): l'evento anomalo del 23/03/2026 cade
DENTRO la finestra di marzo e non la inquina. Onesta' simmetrica: le diff
forex sono sull'INTERO periodo (dentro+fuori); il loro "fuori" sarebbe al piu'
qualche percento piu' basso (le finestre sono ~6,6% delle barre).

---

## 3. 📐 LA VOLATILITA' ORARIA — cosa il repo HA e cosa NON ha

**Cercato in tutto il repo (25/08): NON esiste una misura archiviata del range
H1 medio** ne' per i forex ne' per gli indici. Quello che esiste:

1. **[MISURATO in casa]** Studio aperture FASE A, tick reali BCM
   (`risultati_archivio/studio_apertura/Studio_*_RIEPILOGO.csv`, colonna
   `ampiezza_pt`, scenario "TUTTI i breakout"): range medio dei **primi 15
   minuti di seduta** — **NASUSD 8.523 pt su 447 giorni, SPXUSD 1.553 pt su
   444 giorni**. Normalizzato sui prezzi medi derivati dal CSV v2 (algebra
   `prezzo = 100 × DiffMediaPunti / DiffMediaPct`, stesso periodo 2024-09 →
   2026-07: NASUSD ~2.375.000 pt, SPXUSD ~646.000 pt): **NASUSD ~0,36%,
   SPXUSD ~0,24% nei 15' di apertura**. E' un TETTO plausibile del range H1
   medio (l'apertura e' la fetta piu' volatile), non il range H1 medio.
2. **[NIENTE] per 225JPY** (nessuno Studio sul Nikkei) e **[NIENTE] per gli 8
   forex/oro**: zero ATR H1, zero range orari archiviati.
3. **Lo strumento per misurarla ESISTE GIA' ed e' collaudato**:
   `histdata_m1.py` HD-M1-v4, modo **`--vol-oraria`** (range orario medio in %
   del prezzo, per anno e totale, ore sottili <30 barre M1 scartate; autotest
   11/11, tempo misurato ~24 s/simbolo su CSV da 3M righe). **Mai eseguito sui
   dati veri**: la riga di lancio corretta e' gia' scritta in
   `REFERTO_HISTDATA_FATTIBILITA.md` §16.2 (bozza verificata dal
   verificatore-stringhe il 19/08, difetto zip-che-tronca gia' corretto).

Le bande usate sotto sono quindi le stesse del §16.2, **[INFERITO] con fonte
dichiarata**: forex maggiori 0,04-0,08% (ancora: il conto del 14-bis.2 usava
~0,05%), XAUUSD 0,15-0,25%, NASUSD 0,20-0,36% e SPXUSD 0,14-0,24% (tetto 15'
misurato), 225JPY 0,25-0,35%.

---

## 4. 🧮 LA TABELLA — metro assoluto contro metro relativo

Rapporto = diff / volatilita' oraria. Metro relativo di riferimento: la
proposta gia' formulata in REFERTO_HISTDATA §16.2, **soglia 0,20 × range H1
medio** (= tetto arrotondato del peggior forex promosso, AUDJPY).

| simbolo | diff media misurata | vol oraria | rapporto diff/vol | metro ASSOLUTO ≤0,05% | metro RELATIVO ≤0,20×vol |
|---|---:|---:|---:|---|---|
| EURUSD | 0,0041% [MIS] | 0,04-0,08% [INF, DA MISURARE] | 0,05-0,10 | ✅ passa | ✅ passa |
| GBPUSD | 0,0052% [MIS] | 0,04-0,08% [INF] | 0,07-0,13 | ✅ | ✅ |
| USDJPY | 0,0054% [MIS] | 0,04-0,08% [INF] | 0,07-0,14 | ✅ | ✅ |
| EURJPY | 0,0063% [MIS] | 0,04-0,08% [INF] | 0,08-0,16 | ✅ | ✅ |
| GBPCAD | 0,0072% [MIS] | 0,04-0,08% [INF] | 0,09-0,18 | ✅ | ✅ (al pelo in banda alta) |
| CHFJPY | 0,0080% [MIS] | 0,04-0,08% [INF] | 0,10-0,20 | ✅ | 🟡 al limite |
| AUDJPY | 0,0090% [MIS] | 0,04-0,08% [INF] | 0,11-0,23 | ✅ | 🟡 e' LUI che fissa la soglia |
| XAUUSD | 0,0110% [MIS] | 0,15-0,25% [INF] | **0,04-0,07** | ✅ | ✅ **il piu' basso di tutti** |
| SPXUSD (fuori fin.) | 0,0527% [MIS] | 0,14-0,24% [15' MIS, H1 INF] | **0,22-0,38** | ❌ frigo (1,05×) | ❌/🟡 **sopra 0,20 anche in relativo** |
| NASUSD (fuori fin.) | 0,0662% [MIS] | 0,20-0,36% [15' MIS, H1 INF] | **0,18-0,33** | ❌ frigo (1,32×) | ❌/🟡 a cavallo della soglia |
| 225JPY (fuori fin.) | 0,0871% [MIS] | 0,25-0,35% [INF] | **0,25-0,35** | ❌ frigo (1,74×) | ❌ sopra anche in relativo |

**Legenda onesta**: [MIS] = misurato e agli atti; [INF] = banda inferita
dichiarata (§3); ❌/🟡 = il verdetto relativo DIPENDE da dove cade la misura
vera della vol dentro la banda — ed e' esattamente il motivo per cui **non si
firma niente prima di `--vol-oraria`**.

---

## 5. 🧾 CONCLUSIONI ONESTE

### (a) Il metro relativo NON ribalta il frigo — lo rende leggibile

- Il sospetto del builder di oggi (dubbio #4) **e' fondato a meta'**: il metro
  0,05% E' assoluto ed E' stato tarato sui forex (§1). In relativo, il divario
  **6-16×** del metro assoluto **crolla a ~1,5-2,5×**: il frigo "urlato" era
  in parte un artefatto dell'unita' di misura.
- **MA con le stime attuali i tre indici restano SOPRA l'intera banda forex
  anche in relativo** (0,18-0,38 contro 0,04-0,23), e sopra la soglia proposta
  0,20 in quasi tutta la banda. **Il metro relativo non e' un condono: e' un
  metro che boccia "di poco" invece che "di 6-16 volte".**
- Il controllo piu' bello resta l'ORO: lo strumento piu' volatile fra i
  promossi ha il rapporto **piu' basso** (0,04-0,07) — e' la firma che il
  rumore di allineamento scala con la volatilita', cioe' che l'ipotesi dietro
  il metro relativo e' fisicamente sensata.
- **Con quale soglia relativa i forex promossi restano promossi**: 0,20×vol
  tiene dentro tutti e 8 (il peggiore, AUDJPY, sta a 0,11-0,23: e' lui il
  bordo). Una soglia piu' larga (0,25-0,30) farebbe passare NASUSD e forse
  SPXUSD **con le stime attuali** — ma sarebbe una soglia scelta GUARDANDO i
  numeri degli indici, cioe' esattamente il vizio che il metodo vieta.

### (b) Cosa manca per chiudere — e con quale riga

Il repo NON basta a firmare: le volatilita' H1 sono bande inferite. Servono
**due misure, entrambe gia' pronte e mai eseguite** (PC di backtest
DESKTOP-H4D7CAJ, zero rete, ~5 min totali):

1. **`--vol-oraria`** su `nsxusd,jpxjpy,spxusd` + `eurusd` (e se i CSV del
   15/08 sono ancora in `abtg_storico_esterno`, anche gli altri forex): riga
   corretta e verificata in `REFERTO_HISTDATA_FATTIBILITA.md` **§16.2**.
   Sostituisce le bande [INF] con numeri e ricalcola la colonna "rapporto".
2. **`--estrai "2026.03.23 06:00" --ore 3`** sui tre indici: riga in **§16.1**.
   Isola l'evento del 23/03 (diff max simultanea sui tre simboli, ~3-4% del
   prezzo, 40-50× la media) e dice se e' un buco di feed, un evento macro
   disallineato o la malattia-sessioni. **Senza questa diagnosi anche il
   "dentro le finestre" resta non interpretabile.**

### (c) I rischi del metro relativo — perche' NON basta da solo

**La diff degli indici NON e' rumore bianco proporzionale alla volatilita': ha
struttura, ed e' misurata.**

1. **Struttura oraria/di calendario**: dentro le finestre DST sfasate la diff
   e' **4-5 volte peggio** che fuori (0,217-0,374% contro 0,053-0,087%) — e la
   cura DST v2 **PEGGIORAVA la media totale del 7,7-8,6%** (§15): quindi il
   disallineamento non e' nemmeno il semplice +4/+5 del calendario, c'e'
   dell'altro (orari di sessione del feed: la malattia gia' vista sul GRXEUR;
   coerente con la copertura 96,8-97,0% contro 99,2-99,6% dei forex).
2. **Un evento singolo enorme** (23/03/2026 11:00 server, tre simboli
   insieme): una media "sotto soglia relativa" puo' conviverci — e una diff
   SISTEMATICA (DST sbagliato, sessione spostata, barre marce) e' velenosa
   per la prova di regime **anche se piccola rispetto alla volatilita'**,
   perche' non e' rumore che si media a zero: e' un errore sempre dallo
   stesso lato nelle stesse ore, e le strategie a orario (aperture, ORB,
   sessioni) leggono proprio quelle ore.
3. Percio' un eventuale metro relativo **deve tenersi i compagni di guardia**:
   (i) si giudica sulla **diff FUORI finestre** con l'esclusione DICHIARATA
   (o dopo cura del calendario che funzioni davvero); (ii) **bias mediano
   ~0** obbligatorio (gia' vero: +0,0013/+0,0075% — niente basis
   cash-vs-future); (iii) **l'evento del 23/03 va spiegato PRIMA** della
   firma; (iv) la copertura ≥80% resta com'e'.

---

## 6. 🖋️ LA PROPOSTA DI DECISIONE PER CLAUDIO (da firmare, non firmata qui)

**PRIMA LA MISURA X, POI LA FIRMA. Ordine proposto:**

1. **Subito (5 min, zero rete)**: le due righe del punto (b) —
   `--vol-oraria` (§16.2) e `--estrai` sul 23/03 (§16.1). Sono il
   prerequisito che il §16.2 stesso aveva gia' dichiarato per la firma.
2. **Poi, coi numeri veri sul tavolo**, la scelta fra:
   - **OPZIONE 1 (proposta di casa, gia' formulata al §16.2)**: metro
     RELATIVO per gli import esterni — **diff media fuori-finestre ≤ 0,20 ×
     range orario medio H1** dello stesso simbolo, con i quattro compagni di
     guardia del punto (c). Il cancello assoluto 0,05% **resta com'e' per il
     forex**. Soglia 0,20 = tetto del peggior promosso (AUDJPY), fissata
     PRIMA di vedere le vol misurate degli indici.
   - **OPZIONE 2**: il metro assoluto resta unico per tutti → i tre indici
     restano in frigo finche' la diff non scende (diagnosi sessioni/evento).
3. **Dichiarato prima della misura, per non raccontarsi storie dopo**: con le
   stime attuali i tre indici **NON passerebbero nemmeno il metro relativo**
   (0,18-0,38 contro 0,20). Se le vol misurate usciranno nella meta' ALTA
   delle bande, NASUSD (0,18) e forse SPXUSD (0,22) si avvicinano alla
   soglia; 225JPY resta fuori quasi certamente. **Il frigo, oggi, e' giusto
   con entrambi i metri** — la differenza e' che col relativo sapremo di
   QUANTO, e su una scala che vale anche per i prossimi import.

**RESTA [DA MISURARE]** (tutto sul PC di Claudio, righe gia' pronte):
- range H1 medio di `nsxusd`, `jpxjpy`, `spxusd`, `eurusd` (+ altri forex se
  i CSV ci sono) → §16.2 REFERTO_HISTDATA;
- anatomia dell'evento 2026.03.23 11:00 server → §16.1 REFERTO_HISTDATA;
- (facolt., solo se si vuole il confronto perfetto) diff forex spaccata
  dentro/fuori finestre: richiederebbe re-import v2 dei forex — **non
  deciso qui**, il §14-bis.2 dice gia' che il loro numero puo' solo scendere.

**Nessun parametro degli EA in forward cambia per questa analisi. Nessuno
script e' stato toccato. Il cancello resta 0,05% finche' Claudio non firma.**
