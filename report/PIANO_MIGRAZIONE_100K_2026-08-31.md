# 🚚💯 PIANO DI MIGRAZIONE — flotta validata → conto 100k (MOSSA 2 della firma PORTATA)

_Deliverable della **MOSSA 2 della FIRMA "PORTATA"** (`report/FIRME_2026-08-31.md`).
E' un PIANO: **non tocca niente in forward**. Ogni deploy lo esegue Claudio a
mano, con la legge dello screenshot, quando i cancelli qui sotto sono verdi._

## 🛑 SUBORDINATA DICHIARATA — il piano NON parte finche' M27 non parla

**Questo piano si esegue SOLO dopo il verdetto M27 sul SEGNO di E** (mossa 1
della firma): oggi il banco dice **+0,091R** per trade e il forward di agosto
**−0,091R** — stesso modulo, segno opposto (`PIANO_PROP.md` H1/H7). Migrare
significa moltiplicare N per 3,2: **con E<0 e' moltiplicare una perdita**.
Se M27 misura E forward negativa per le famiglie principali, la migrazione si
FERMA e si torna alla firma. Punto.

**Il premio, se E ha il segno giusto** (Area H, H2): da 34,7 a 111,9 op/mese
misurate = le due fasi di una challenge passano da **8,9-14,4 mesi a 2,8-4,5
mesi**. Costo di ricerca zero: le sedie esistono, i contratti sono scritti, e
**R105 D5 ha verificato senza pesca che la squadra ottima E' la flotta intera**
(nessun sottoinsieme la batte).

**Conto di destinazione**: il 100k dry-run **50504263** (Guardian FTMO 2-Step
gia' a bordo, `report/DEPLOY_GUARDIANO_100K.md`) — da riconfermare con
`conto_attivo.ps1` prima della fase 1, come da verbale di quel file.

---

## 1️⃣ LA LISTA — chi migra, chi no, chi dopo (38 sedie passate al setaccio)

_Universo: le 37 sedie vive del censimento `.chr` del 25/08
(`censimento_rischio_2026-08-25_0731.txt`) + la GatedShort 770250 (deploy
30/08, conto ~5k). Contratti: `report/CONTRATTI_SEDIE.md` (con le revisioni
firmate del 23-24/08)._

### 🔢 La regola dei MAGIC NUOVI (verificata repo-wide)

**Mai riusare sul 100k i magic del conto piccolo**: se le due flotte finissero
mai nello stesso CSV/censimento, i numeri doppi sommerebbero sedie diverse
(lezione della collisione 770901, censimento 22/08 §5).

**Blocco proposto: `88xxxx` — VERIFICATO LIBERO repo-wide il 31/08** (grep su
`.md/.mq5/.set/.txt/.ps1/.ini`: zero magic col prefisso 88; le uniche
occorrenze `88____` in repo sono valori di profitto dentro un XML di
ottimizzazione, non magic). Regola di derivazione, per tracciabilita':
**`88` + le ultime 4 cifre del magic del piccolo** (es. 771531 → **881531**).
**Unica eccezione dichiarata**: 970901 e 770901 condividono le ultime 4 cifre
→ collisione su 880901; la 970901 (STREV Ott oro) prende **889901**.

### 📏 La regola della TAGLIA

- **Base di casa**: rischio del contratto (colonna `CONTRATTI_SEDIE.md`,
  gia' con le riduzioni firmate il 23-24/08) **× 0,65** — lo stesso fattore
  gia' in uso sui 5 mirror del dry-run (e la manopola D4 di R105: 0,65 e'
  "perfino piu' prudente" del ×0,74 misurato). Sedia a contratto 1,0% →
  **0,65%** sul 100k; a 0,5% → **0,33%**; a 0,3% → **0,20%**; a 0,25% →
  **0,16%**.
- **A2 (firmata 18/08)**: sedia con **meno di 30 trade in forward → 0,3%**
  (e mai sopra la taglia da contratto). ⚠️ Letta alla lettera, A2 oggi
  prende QUASI TUTTA la flotta (le finestre forward reali sono sotto le 4-5
  settimane): applicarla a tappeto ridurrebbe la portata in € proprio del
  fattore che la migrazione vuole comprare. **→ DECISIONE DI CLAUDIO n.1**
  (in fondo): A2 letterale (tutte le nuove a 0,3% fino a 30 trade) oppure
  A2 interpretata "30 trade di famiglia fra piccolo+100k" (le validate
  partono subito a contratto×0,65). Il piano sotto scrive ENTRAMBE le
  colonne.

### ✅ GIA' SUL 100K (5) — non si migrano, si CONSOLIDANO

| EA | Simbolo | Magic attuale (riusato dal piccolo!) | Taglia | Nota |
|---|---|---|---:|---|
| ABTG_DAX_Apertura_EU | D30EUR | 770101 | 0,65 | viva, 3 trade |
| ABTG_Dow_Apertura_US | U30USD | 770202 | 0,65 | viva |
| ABTG_MaxMinNotte_DAX_Short_Ott | D30EUR | 770411 | 0,65 | viva |
| ABTG_ORB_Ottimizzato | U30USD | 770611 | 0,30 | A2 (giovane, doppio asterisco R15) |
| ABTG_SupertrendReversal (Nikkei H2) | 225JPY | 770901 | 0,65 | zero trade anche sul piccolo nella finestra |

⚠️ **Le 5 usano i magic del piccolo** (deploy 09/08, prima di questa regola).
**→ DECISIONE DI CLAUDIO n.2**: rinumerarle nel blocco 88 (880101, 880202,
880411, 880611, 880901) **spezza la continuita' statistica del dry-run**
(21 giorni di storia, H5 e M27 ci misurano sopra) — raccomandazione di casa:
**rinumerare SOLO all'apertura della challenge vera**, quando comunque si
riparte da zero; fino ad allora tenerle cosi' e conviverci nei censimenti
(i due CSV sono gia' separati per file, non per magic).

### 🟢 SI' — MIGRARE (13 sedie nuove sul 100k)

_Preset: per tutte la procedura e' quella collaudata del deploy 09/08 —
**set estratto dal `.chr` VIVO del piccolo con `estrai_set_forward.ps1` (v3)
col rischio riscritto dallo script**, poi verifica campo-per-campo a schermo
(legge dello screenshot). Il "riferimento cella" e' il referto che ha promosso
la sedia: se set e referto divergono, comanda il referto._

| # | EA | Simbolo | Magic piccolo | **Magic 100k** | Taglia (contratto×0,65) | Taglia se A2 letterale | Riferimento cella (preset) | Perche' si' |
|---|---|---|---|---|---:|---:|---|---|
| 1 | ABTG_SupRev_NAS_H1_Ottimizzato ⭐ | NASUSD | 970913 | **880913** | 0,65 | 0,30 | `REGISTRO_TEST.md` §4 S5v (PF 1,57, 8/8 combo, DD 1,17%) | il prop-friendly della flotta, DD promesso minuscolo |
| 2 | ABTG_SuperWave_DOW_H1_Ottimizzato | U30USD | 770511 | **880511** | 0,65 | 0,30 | `REGISTRO_TEST.md` §SuperWave (PF 1,52, 9/9) | in linea col contratto in forward (0,94×) |
| 3 | ABTG_SuperWave (H2) | U30USD | 770531 | **880531** | 0,65 | 0,30 | `REFERTO_ROUND23_PERTRADE.md` | vivaio R23, DD 2,96% |
| 4 | ABTG_EMA200 | U30USD | 771531 | **881531** | 0,65 | 0,30 | `REFERTO_ROUND29/31` (cella CENTRO, 30/30 PASS) | **il grande motore: 33-35 op/mese da sola** — ma vedi §3 (e' anche il grande rischio di finestra) |
| 5 | ABTG_SupertrendReversal_Ottimizzato | XAUUSD | 970901 | **889901** (eccezione collisione) | 0,65 | 0,30 | `R99_REFERTO.md` (22 anni, DD 9,0% a 1%) | contratto pieno da R99, firmato 23/08 |
| 6 | ABTG_BreakingBand | GBPUSD | 772161 | **882161** | 0,65 | 0,30 | `REFERTO_ROUND33/34` | l'unica BB viva in forward |
| 7 | ABTG_PunteLarry | GBPUSD | 772345 | **882345** | 0,65 | 0,30 | `REFERTO_ROUND38/39` (solo S, PF 1,84) | contratto pieno, famiglia viva |
| 8 | ABTG_PunteLarry | EURCAD | 772346 | **882346** | 0,65 | 0,30 | R38/R39 ("il piu' tirato", PF 1,25) | contratto pieno; sorvegliata |
| 9 | ABTG_PunteLarry | EURAUD | 772342 | **882342** | 0,33 | 0,30 | R38/R39 + revisione R103 (0,5%) | contratto ridotto firmato 24/08 |
| 10 | ABTG_CostToCost | EURJPY | 772361 | **882361** | 0,42 | 0,30 | CSV r40 cella L + R41 + revisione R103 (0,65%) | contratto ridotto firmato |
| 11 | ABTG_CostToCost | GBPCAD | 772362 | **882362** | 0,16 | 0,16 | CSV r40 + R41 + R103 (0,25%) | contratto ridotto firmato |
| 12 | ABTG_MaxMinNotte (oro notte) | XAUUSD | 770402 | **880402** | 0,33 | 0,30 | `R100_REFERTO.md` (prop: solo ≤0,5%) | riscritta da R100, notturna scorrelata |
| 13 | ABTG_PunteLarry | XAUUSD | 772343 | **882343** | 0,20 | 0,20 | `R100_REFERTO.md` (prop: solo ≤0,3%) | col tagliando 6 mesi gia' scritto nel contratto |

### 🔴 NO — NON MIGRARE (7 sedie, motivo per ciascuna)

| EA · simbolo · magic | Perche' NO |
|---|---|
| ABTG_EasyTrend GBPUSD 772422 · CHFJPY 772421 | famiglia **BOCCIATA in portafoglio (R49): porta 100k CHIUSA** da referto — si riapre solo con una misura nuova |
| ABTG_GapFill U30USD 772234 · 225JPY 772235 | **escluse dal portafoglio (R37: cumulo del lunedi'): porta 100k CHIUSA** — e sono pure fra le 13 mute |
| ABTG_EMA200_Ottimizzato XAUUSD 971501 | contratto R100: **"prop: NO a nessuna taglia"** (DD 22 anni 45,91% a rischio 1) |
| Gold_Ichimoku_TK_ATR_EA XAUUSD 250604 | contratto **PARZIALE**, validata su ALTRO broker (su BCM PF 1,01/DD 28%), **muta da >70 giorni** — prima il verdetto della checklist mute e il tagliando C3 |
| ABTG_Nasdaq_Apertura_US (GatedShort) NASUSD 770250 🌩️ | **la storm-gated NON si porta, per ora — dichiarato**: firma di Claudio del 30/08 = conto PICCOLO ~5k in osservazione, NON il 100k (`CONTRATTO_GATEDSHORT_770250.md`); verdetto ORSO solo OHLC, n=104<150 (merito sospeso R59). Porta di rientro: tick Dukascopy orso (M26) o 20 trade forward puliti |

_(Le gia' spente restano spente: 771323, 770532, 772363, 772423 — revisione
24/08; 770201, 970914, BREAKOUT_EA_JPY_v3 — FIRMA 5 del 18/08.)_

### 🟡 DOPO / SUBORDINATE (13 sedie — la porta non e' chiusa, e' condizionata)

| EA · simbolo · magic | Magic 100k riservato | Condizione per migrare |
|---|---|---|
| GapFill GBPUSD 772231 · EURUSD 772232 · AUDUSD 772233 | 882231 · 882232 · 882233 | **prima la checklist mute** (sospetto guasto dal 22/08); poi ⚠️ vincolo R105: il PEGGIOR GIORNO del banco (−4,74%) e' il **cluster GapFill del lunedi'** — se rientrano, MAI tutte insieme nella stessa fase, e col conto del §3 in mano |
| PTE U30USD 771321 | 881321 | verdetto checklist mute + revisione C3 (frequenza 0 vs 3,2 promessa) |
| BreakingBand EURUSD 772162 · AUDUSD 772163 | 882162 · 882163 | verdetto checklist mute (attesa: vive-ma-selettive → migrabili in coda) |
| PunteLarry U30USD 772341 · GBPJPY 772344 | 882341 · 882344 | verdetto checklist mute |
| SupRev_DAX_H4_Ott D30EUR 970912 | 880912 | checklist mute + revisione C3: contratto gia' "marginale" (PFmed 1,05) — candidata piu' al tagliando che alla migrazione |
| PTE GBPUSD 771322 (storica) · 771332 (candidata) | 881322 · 881332 | **il DUELLO si giudica sul piccolo a 30 trade** (regole congelate 17/08): migrare a meta' duello romperebbe il confronto a pari condizioni. **Migra SOLO il vincitore**, dopo il verdetto |
| SupertrendReversal 225JPY H4 FW 770924 | 880924 | contratto marginale (PFmed tick 1,05, ~1 op/mese, DD 0,14%): costa poco ma compra poco — **DA-DECIDERE** di Claudio |
| GapContinuation 225JPY 774101 | 884101 | giovane (deploy 16/08, A2 → 0,3%), "passeggero non pilota", perdite in gruppo nel carattere (Z −4,03); PRIMA sistemare il rischio `n/d` nel censimento `.chr` — in coda, fase finale |

### 🧮 Il conto delle categorie

| categoria | sedie |
|---|---:|
| ✅ gia' sul 100k (consolidare) | **5** |
| 🟢 SI', migrare | **13** |
| 🟡 DOPO / subordinate | **13** |
| 🔴 NO | **7** |
| **totale flotta considerata** | **38** |

A regime (5+13 = **18 sedie** sul 100k) la portata attesa e' la quota
maggiore delle 111,9 op/mese misurate: le grandi frequenze (EMA200 Dow
33-35, DAX Apertura 21-25, ORB ~9-13, SuperWave H1 ~10) sono TUTTE dentro
le 18. Le 13 "dopo" valgono in gran parte le +21 op/mese delle mute — le
compra la MOSSA 3, non questa.

---

## 2️⃣ IL PROBLEMA DEL CAP C1 — 3,25% firmato che NESSUN EA legge

**Il fatto**: C1 = max **3,25% di rischio aperto simultaneo** (5 SL vivi da
0,65%, `FIRME_2026-08-18.md`). Il Guardian **scrive** le bandiere ma **nessun
EA le legge** (PIANO_PROP, lista sviluppo n.1). E la misura M2 dice che la
flotta piena, a taglia 0,65%, ha GIA' fatto **5,85% il 03/08 alle 08:15**
(9 posizioni di 8 sedie) — cioe' **migrare la flotta intera ricrea esattamente
il giorno che sfonda il cap**, stavolta su un conto che simula una prop.

**Tre opzioni operative (niente codice ORA — qui si decide la strada):**

| opzione | cosa si fa | rischi dichiarati |
|---|---|---|
| **(a) SCAGLIONARE le migrazioni** (il §4 e' costruito cosi') | si porta un lotto per volta, si misura il max rischio aperto dalla pagella/censimento, si passa al lotto dopo solo se il picco osservato resta ≤3,25% per una settimana | 🔴 NON e' enforcement: e' esposizione ridotta per via amministrativa. Il pile-up dentro un lotto resta possibile (gli swing si accumulano in giorni, M2); e allunga i tempi — il costo e' TEMPO, proprio cio' che la firma vuole comprare |
| **(b) GUARDIANO DI CONTO (enforcement vero)** | completare la strada GIA' SCRITTA il 19/08: include `ABTG_PausaGuardian.mqh` v1.20 + Guardian v1.11, 48 EA / 74 punti d'ingresso collegati, fail-open totale (`REFERTO_MIGRAZIONE_GUARDIAN_PREPARAZIONE.md`). **Restano da spuntare i 9 criteri congelati di collaudo, sul dry-run 100k** | 🔴 finche' il collaudo non passa, la protezione NON esiste (fail-open = comportamento identico a oggi); il collaudo costa giorni di lavoro e ricompilazione di tutta la flotta (un EA per volta, regola di casa); ⚠️ e il cap e' cieco sugli ordini PENDENTI (nota M14: `ABTG_Guardian.mq5:159` cicla su `PositionsTotal()`) — Larry e le aperture usano pendenti |
| **(c) LIMITI PER-FAMIGLIA** (max SL vivi per famiglia via input gia' esistenti / one-trade-per-day) | tetto amministrativo per famiglia, senza codice nuovo | 🔴 il 03/08 erano **8 sedie DIVERSE**: il pile-up di casa e' TRASVERSALE alle famiglie, un limite per-famiglia non lo vede. Utile solo come complemento (es. GapFill: max 2 simboli attivi) |

**Raccomandazione di casa (dichiarata come tale, decide Claudio): (b) e' la
soluzione, (a) e' il ponte, (c) e' un complemento per i cluster di calendario.**
In concreto: il collaudo dei 9 criteri del Guardian-enforcement diventa il
**cancello della fase 2** — nessun lotto oltre il primo finche' gli EA sul
100k non leggono le bandiere. Cosi' la migrazione stessa fa da banco di
collaudo, che era gia' il disegno del 19/08 ("sul dry-run 100k e mai prima
sul conto piccolo").

---

## 3️⃣ LE MINE PROP — trade simultanei, finestra 10 minuti, best-day

_Regole censite (PIANO_PROP H5/M28): FundingPips **"Risk Per Trade Idea"** =
max 2% combinato per idea, dove "stessa idea" = nuova posizione **entro 10
minuti** nella stessa direzione (Master ≥25k) — **HARD BREACH**; FundingPips
**"high-frequency trading" fra le pratiche VIETATE** (definizione mai trovata,
[INCERTO], M28); **best day ≤50%** (FTMO 1-Step) / **consistency 35%**
(FundingPips): oggi 43,6% sul 100k = gia' al limite/non conforme._

### Il censimento delle FINESTRE — chi spara insieme a chi (misurato, non stimato)

| finestra (ora server) | sedie della migrazione dentro la finestra | il numero misurato |
|---|---|---|
| **08:00-08:16 — apertura DAX** | 770101 (DAX Apertura); a contorno le posizioni notturne ancora vive (770411 MaxMin DAX short, 880402 MaxMin oro) | M2: il picco del giorno e' caduto in questa finestra il 03, 04, 06 e 07/08; il 03/08 il terzetto DAX sparava **nello stesso secondo** (08:15:29-34) — oggi dei tre resta solo 770101, ma gli swing sotto restano |
| **14:30-14:46 — apertura US** | 770202 (Dow Apertura) + 770611 (ORB, range 14:25-14:30) **stesso simbolo U30USD, stessa direzione di breakout, stessi minuti** + 881531 (EMA200 Dow, intraday sul Dow) | R105: Dow_Apertura+ORB co-perdenti **17 giorni**; DAX_Apertura+ORB 20. Per la regola dei 10 minuti, Dow+ORB long insieme = **una "idea" da 0,95-1,30% combinato** → sotto il 2%, MA ogni terza sedia Dow nella finestra avvicina il muro |
| **lunedi' apertura settimana** | GapFill ×3 (se rientrano) + PunteLarry Oops (gap-based, 6 sedie D1) | R105: il **peggior giorno del banco intero (−4,74%) e' il cluster GapFill del lunedi'** (Nikkei+Dow+AUDUSD insieme per costruzione) — con 3 GapFill + Larry attivi il lunedi' mattina e' la finestra piu' affollata del calendario |
| **notte (23:00→mattina)** | 770411 (box 23:00), 880402 (oro notte), swing H4 tenuti | M2: MAXMIN ORO + STREV DOW H1 215 min insieme; secondario ma si somma agli altri |
| **tutto il giorno (swing H1/H4)** | 889901, 880913, 880511, 880531, 882161, 882345/6/2, 882361/2, 882343 | M2: **il cluster swing domina i MINUTI** (coppie insieme per 3.751-5.976 min in 17 giorni): gli swing si accumulano per giorni, le aperture ci si sommano sopra in un secondo — e' l'anatomia esatta del 5,85% |
| **gemelli / stesso segnale** | PTE 771322+771332 (stesso secondo, per costruzione) — **per questo il duello NON migra** | H5: i gemelli sono la voce citata testualmente nella riga HARD BREACH FundingPips |

### L'ordine che MINIMIZZA il rischio regole (e perche')

1. **Prima gli swing scorrelati a bassa frequenza** (STREV oro, SupRev NAS,
   SuperWave, BB GBPUSD, Larry forex, CostToCost, MaxMin oro): finestre
   sparse, nessun burst sincrono, e col cap ancora non-enforced sono il
   carico piu' prevedibile.
2. **Una sola sedia nuova per finestra di apertura per fase**: la finestra
   14:30 ha GIA' due sedie (Dow+ORB); **EMA200 Dow (881531) entra DA SOLA
   in una fase dedicata** — e' il singolo cambiamento piu' grosso del piano
   (33-35 op/mese, il "grande motore con le grandi giornate storte": il
   23/06 ha fatto −2.576 da sola, R105).
3. **I cluster di calendario per ultimi e mai interi**: GapFill max 2-3
   simboli, e SOLO dopo la riparazione e con la decisione (c) del §2 sul
   tetto per-famiglia del lunedi'.
4. **Best-day/consistency: la migrazione AIUTA, non danneggia** — piu'
   giorni operativi diluiscono il giorno migliore (43,6% oggi, al limite
   del 35% FundingPips proprio perche' i giorni positivi sono pochi). Ma va
   MISURATA dopo ogni fase dalla pagella (H9 resta aperta).
5. **La clausola HFT FundingPips resta una mina non disinnescata** ([INCERTO],
   definizione mai trovata): a 111 op/mese di flotta non siamo HFT in senso
   tecnico, ma la domanda scritta al supporto (M28/E1) va inviata PRIMA di
   comprare una challenge li'. Su FTMO la mina non esiste (nessun limite
   censito di frequenza).

---

## 4️⃣ LA SEQUENZA OPERATIVA — fasi con cancello di verifica

_Ogni fase: deploy a mano di Claudio (set estratto + verifica a schermo +
screenshot), poi **censimento `.chr` del 100k** e pagella per il periodo di
osservazione. La fase successiva parte SOLO se il criterio di verifica della
precedente e' verde. Le settimane sono indicative, i cancelli no._

| fase | quando | cosa si fa | cancello di verifica per passare oltre |
|---|---|---|---|
| **0 — PREREQUISITI** | subito | (a) verdetto **M27** sul segno di E (mossa 1); (b) checklist **13 mute** eseguita (mossa 3); (c) conferma conto `50504263` con `conto_attivo.ps1`; (d) DECISIONI 1-4 di Claudio (fondo pagina) | **E forward dichiarata col suo segno**, per famiglia. Se negativa sulle famiglie da migrare → STOP piano |
| **1 — CONSOLIDAMENTO + COLLAUDO ENFORCEMENT** | settimana 1 | zero sedie nuove: si collauda il **Guardian-enforcement (i 9 criteri congelati)** sui 5 mirror esistenti; si sistemano le anomalie note (rischio `n/d` di GapCont sul piccolo NON si tocca; solo il 100k) | 9/9 criteri PASS sul dry-run; una settimana di pagelle con bandiere lette dagli EA (log alla mano); **max rischio aperto osservato ≤3,25%** |
| **2 — LOTTO SWING (8 sedie)** | settimana 2 | 880913 (SupRev NAS ⭐) · 889901 (STREV oro) · 880511 + 880531 (SuperWave Dow) · 882161 (BB GBPUSD) · 882361 + 882362 (CostToCost) · 880402 (MaxMin oro) | 5 giornate di borsa: censimento OK (magic 88, taglie giuste), **picco rischio aperto ≤3,25%**, zero ingressi rifiutati dal cap ingiustificati, pagella senza anomalie di attribuzione |
| **3 — LOTTO LARRY + IL GRANDE MOTORE** | settimana 3 | 882345 · 882346 · 882342 · 882343 (PunteLarry, pendenti: ⚠️ il cap non li vede — sorveglianza manuale dalla pagella) poi, a meta' settimana, **881531 EMA200 Dow DA SOLA** | 5 giornate: picco ≤3,25% CON EMA200 dentro; **finestra 14:30 sorvegliata**: mai 3 sedie Dow stessa direzione negli stessi 10 minuti (conteggio dalla pagella, regola FundingPips provata in casa) |
| **4 — LE RIENTRATE** | settimana 4+ | le mute riparate e classificate VIVA (dalla mossa 3), col loro magic 88 riservato; GapFill **max 2-3 simboli** se e quando rientrano (decisione dedicata, vincolo R105 lunedi'); 774101 GapCont a 0,3% | ogni rientro col suo censimento + una settimana pulita; il lunedi' GapFill misurato per 2 lunedi' prima di aggiungerne un terzo |
| **5 — CODE E VERDETTI** | a maturazione | vincitore del duello PTE (a 30 trade, magic 88 del vincitore); 770924 se Claudio firma; rinumerazione completa 88xxxx dei 5 mirror **all'apertura della challenge vera** | il verdetto che apre ciascuna coda (duello / firma / M26 per la storm-gated) |

**In OGNI fase resta in vigore**: la C3 (DD forward > promesso → revisione
immediata, sui valori GIA' scalati alla taglia 100k), il tetto A4 (nessuna
sedia sopra l'1%), e il monitoraggio H9 (best-day, giorni ≥0,5%).

---

## ✍️ LE DECISIONI CHE SERVONO A CLAUDIO (prima della fase 1)

1. **A2 sulla migrazione**: letterale (ogni sedia nuova sul 100k parte a
   0,3% fino a 30 trade) o "di famiglia" (le validate partono a
   contratto×0,65)? Il piano regge con entrambe; cambia la portata in € dei
   primi 2 mesi.
2. **I 5 magic riusati sul 100k**: rinumerare subito nel blocco 88 (pulizia,
   ma si spezza la serie del dry-run) o alla challenge vera
   (raccomandazione di casa)?
3. **La strada del cap C1**: (b) enforcement come cancello della fase 2
   (raccomandata) — si' o no? Se no, il piano ricade su (a) puro e i tempi
   si allungano.
4. **EMA200 Dow (881531)**: e' il pezzo che da solo cambia la portata (+33-35
   op/mese) E il profilo di rischio (le grandi giornate storte). Dentro in
   fase 3 come proposto, o vuole una fase tutta sua con taglia d'ingresso
   ridotta?
5. **GapFill al rientro**: quanti simboli al massimo il lunedi'? (proposta:
   2, mai i 5 — il peggior giorno del banco e' loro).

_Compilato il 31/08/2026 (sera) in esecuzione della firma PORTATA. Nessun EA,
preset o grafico toccato: solo carta. I numeri vengono da: PIANO_PROP.md v16
Area H · CONTRATTI_SEDIE.md · censimento .chr 25/08 07:31 · R105_REFERTO.md ·
REFERTO_M2_SOVRAPPOSIZIONE.md · FIRME_2026-08-18.md · CONTRATTO_GATEDSHORT_770250.md ·
CENSIMENTO_FREQUENZA_FLOTTA_2026-08-22.md._
