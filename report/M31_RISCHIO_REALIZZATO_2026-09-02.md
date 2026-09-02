# ⚖️ M31 — LA CORSIA RISCHIO C3 DELLE APERTURE DAX, RIFATTA A RISCHIO REALIZZATO

_Missione aperta da `PIANO_PROP.md` v17 (nasce da M27 §B3 + la "correzione
onesta" della `DIAGNOSI_770101_SIZING_2026-08-31.md`). Eseguita il 02/09/2026,
**solo scrivania**: nessun MT5, nessun tester, nessun forward toccato. Lo scopo
e' UNO: il 16,39% che ha fatto scattare la corsia RISCHIO era misurato su una
sedia che girava a **taglia doppia** — qui si ricalcola il DD **come se la
taglia fosse stata quella da contratto**, e SOLO DOPO si riapre il tavolo delle
decisioni. **Nessuna decisione viene presa in questo referto.**_

---

## 🏁 I TRE NUMERI, SUBITO

| misura | DD forward famiglia | vs 6,25% promesso |
|---|---:|---:|
| 🔴 **REALIZZATO** (com'e' successo, taglia doppia inclusa) | **836,02 € = 16,39%** di 5.100 | **2,6×** (il numero di M27) |
| ⚖️ **NORMALIZZATO a contratto** (taglia 1%, fattori misurati trade per trade) | **375,60 € = 7,36%** di 5.100 | **1,18×** |
| 📏 forchetta delle sensibilita' (vedi §4) | 7,21% – 8,41% | 1,15× – 1,35× |

👉 **Il 2,6× dell'emergenza NON esiste piu'. Ma il numero onesto NON rientra
del tutto: 7,36% contro 6,25% promesso e' ancora sopra, di misura (1,2×).**
La corsia passa da "allarme rosso" a "sforo marginale" — e **tutto lo sforo
viene dalle modalita' vecchie (BUY/SELL), che oggi non sono in campo**: la
serie RETEST-only normalizzata ha DD **0,28%**.

---

## 1️⃣ CHI E' LA "FAMIGLIA APERTURE DAX" (dichiarato, non assunto)

Ho **riprodotto al centesimo** il numero di M27 §B3 per essere certo di
misurare la stessa cosa: la combinazione che restituisce **esattamente
−689,02 €** nella finestra 20/07 → 28/08 e'

| magic | sedia | n | netto € |
|---|---|---:|---:|
| **770101** | ABTG_DAX_Apertura_EU (la sedia del caso chiuso il 02/09) | 32 | **−600,60** |
| 770102 | DAX Apertura EU OTT (gemello _Ottimizzato_, prima serie) | 2 | −118,74 |
| 770111 | DAX Apertura EU OTT (gemello _Ottimizzato_, seconda serie) | 8 | +30,32 |
| | **totale famiglia** | **42** | **−689,02** ✅ |

- ⚠️ M27 scriveva "41 ingressi": il 42° e' la **riga anomala su NASUSD**
  (22/07, magic 770101, +15,46 €) gia' segnalata e verificata da Claudio il
  26/08. La somma di M27 (−689,02) **la include**; il conteggio no. Qui la
  tengo dentro (e' rischio della famiglia comunque) e do' anche il numero
  senza (§4): cambia lo 0,3%, non cambia nulla del verdetto.
- I `Live5m` (770103/770121) e `Apertura Marco` (770311) **non** erano nella
  famiglia di M27 e restano fuori anche qui.

## 2️⃣ IL SALDO RICOSTRUITO (stesso metodo della diagnosi, ancora verificata)

Curva = somma dei netti di **tutte** le operazioni di
`data/statements/trades_auto.csv` in ordine di chiusura, **ancorata al fatto
noto**: 14/08 12:00, la sedia `772361` (all'1%) perde **51,02 €** ⇒ saldo
**5.102 €** all'apertura di quel trade (pid `3162959`, −49,82 −1,20).

✅ **Controprova contro la diagnosi**: i saldi@apertura degli stop pieni
tornano — 5.959 · 6.049 · 5.989 · 5.598 · 5.264 · 5.207 (identici all'euro).
Unica divergenza: il 29/07 13:01 io leggo 5.658 dove la diagnosi legge 5.543
(convenzione sui due stop che chiudono **nello stesso secondo** dell'apertura
successiva). Non tocca nessun numero di questo referto: per la
normalizzazione uso i **lotti-se-1%** gia' calcolati dalla diagnosi.

## 3️⃣ COME HO NORMALIZZATO (trade per trade, fattori MISURATI)

Finestra incriminata = tutti i trade **770101 chiusi prima del 18/08 00:00**
(la notte del fix: censimento `.chr` 17/08 23:45 = `2.0`, 18/08 00:01 = `1`).
Dal 21/08 in poi la sedia gira all'1% (verbale di chiusura, C2): **quei trade
non si toccano**.

| classe di trade | fattore usato | perche' |
|---|---|---|
| gli **8 stop pieni** 770101 (23/07 → 14/08) | **lotto reale ÷ lotto-se-1%** della tabella 🅐 della diagnosi (2,00–2,29) | e' il **controfattuale esatto**: all'1% l'EA avrebbe calcolato QUEL lotto (floor allo step 0,10) sugli stessi prezzi |
| lo **stop 770102 del 23/07** (−119,70 €) | 0,90 ÷ 0,40 = 2,25 | 🆕 **rilievo di questo referto**: rischio realizzato **2,009%** del saldo ricostruito — **anche il gemello OTT era a taglia doppia quel giorno**, non solo la 770101 |
| il RETEST dell'**11/08** (+3,90 €) | **1,98** | il fattore misurato dal confronto lotti col mirror 100k (diagnosi 🅑) |
| tutti gli altri 770101 (e il 770102 del 24/07) pre-fix — piccole vincite | **2,0** | fattore taglia della finestra; niente stop pieno da misurare |
| **770111** (8 trade, +30,32 €) | **1,0 (non toccato)** | i gemelli `_Ottimizzato` hanno default 1.0 nel sorgente e nessuno stop pieno da misurare — assunzione dichiarata, sensibilita' in §4 |
| tutto dal 21/08 in poi | 1,0 | la sedia e' all'1% (C2, screenshot agli atti) |

## 4️⃣ IL RISULTATO — punto 1 del mandato

**(a) REALIZZATO** (picco 22/07 08:19 → valle 14/08 09:18):
- DD massimo picco-valle: **836,02 €**
- **= 16,39% di 5.100 €** (convenzione M27: **riprodotto al centesimo**)
- **= 15,35% sul saldo ricostruito al picco** (5.445 €) — il numero "com'e'
  successo davvero" e' un filo meno brutto di come M27 lo esprimeva, perche'
  al picco il conto valeva piu' di 5.100.
- netto famiglia: **−689,02 €**.

**(b) NORMALIZZATO A CONTRATTO** — 🥇 **IL numero della corsia C3 onesta**
(stesso picco, stessa valle: la forma della curva non cambia, cambia la scala
delle perdite):
- DD massimo picco-valle: **375,60 €**
- **= 7,36% di 5.100 € → 1,18× il 6,25% promesso**
- = 6,90% sul saldo ricostruito al picco
- netto famiglia normalizzato: **−277,64 € (−5,4% del conto)** — ancora
  negativo: la normalizzazione dimezza la ferita, **non la chiude**.

**Sensibilita' (la forchetta dichiarata):**
| variante | DD | vs 6,25% |
|---|---:|---:|
| senza la riga NASUSD del 22/07 | 7,21% | 1,15× |
| stop normalizzati a **−1,00% esatto** del saldo (senza il "beneficio" dell'arrotondamento per difetto del lotto all'1%) | **8,41%** | **1,35×** |
| anche i gemelli OTT divisi per 2 nella finestra | 7,66% | 1,23× |

📌 La variante a −1,00% esatto e' la piu' severa **ed e' istruttiva**: parte
del sollievo del numero primario (7,36%) viene dal fatto che all'1% il floor
allo step 0,10 avrebbe tagliato il rischio reale fino a ~0,85% su alcuni
trade. E' un beneficio **vero** (il floor c'e', diagnosi punto 6), ma va
detto che c'e'.

### La scomposizione che decide il senso di tutto (770101, normalizzata)

| modalita' | n | netto realizzato | netto normalizzato | in campo oggi? |
|---|---:|---:|---:|---|
| BUY (vecchia) | 15 | −266,60 | **−108,81** | ❌ no |
| SELL (vecchia) | 9 | −392,22 | **−200,02** | ❌ no |
| 🟢 **RETEST** (cella validata) | 8 | +58,22 | **+53,59** | ✅ **si'** — DD della serie: **0,28%** |

## 5️⃣ IL VERDETTO DELLA CORSIA — punto 2 del mandato

### 🪑 FAMIGLIA Aperture DAX — corsia RISCHIO: **SCATTATA DI MISURA, non piu' d'emergenza**

| contro quale promessa | DD normalizzato 7,36% | esito |
|---|---:|---|
| **6,25%** (contratto, `CONTRATTI_SEDIE.md` r.81, R16 a 1%) | **1,18×** (forchetta 1,15–1,35×) | 🔴 **sfora ancora, di misura** |
| 7,23% (griglia R46 sulla cella LIVE, stesso rigo del contratto) | 1,02× | 🟡 a cavallo della soglia |
| 10,60% (DD OOS **misurato in R83** della cella RETEST oggi viva, a 1%) | 0,69× | 🟢 dentro |
| 12,5% (il 6,25% scalato al 2% — il confronto della diagnosi) | 0,59× | (superato: qui la taglia e' gia' riscalata) |
| 20,40% (intestazione EA al 2%) | 0,36× | (idem) |

👉 **Lettura onesta**: contro la promessa contrattuale la corsia **resta
formalmente scattata** (1,2×, e nessuna variante di calcolo la porta sotto
1,0×) — ma lo sforo non e' piu' il 2,6× che in M27 giustificava l'urgenza, e
**proviene al 100% da modalita' che non girano piu'**. Contro il DD che la
cella oggi viva ha **dichiarato dalla sua misura** (R83: 10,60%), non sfora.

### 🪑 SEDIA 770101 da sola

- realizzato: DD **747,60 € = 14,66%**
- normalizzato: DD **353,20 € = 6,93%** → **1,11×** il 6,25% del contratto ·
  **0,96×** il 7,23% di R46 · **0,65×** il 10,60% della cella RETEST (R83).
- 👉 stessa lettura della famiglia: **sforo marginale contro il contratto
  scritto, nessuno sforo contro la misura della cella promossa e validata**.
- ✍️ E resta agli atti che la violazione **grave e certa** di quella finestra
  e' la **TAGLIA** (A4, 2× per quattro settimane) — gia' spiegata, attribuita
  e **chiusa col FIX C4** del 02/09.

### ⚠️ Le approssimazioni, dichiarate (punto 2 del mandato)

1. **Lotti a step 0,10**: i lotti-se-1% sono floor allo step vero di D30EUR
   (dalla diagnosi); il controfattuale li usa cosi'. La variante "−1,00%
   esatto" mostra il costo dell'assunzione: +1,05pp di DD.
2. **Trade non-stop-pieni**: divisi per il fattore taglia 2,0 (o 1,98
   misurato l'11/08), non per un lotto controfattuale calcolato — per le
   vincite piccole (max +19,17 €) l'errore e' di centesimi.
3. **Expert close 28/07** (−86,70): normalizzato col rapporto lotti 1,50→1,00
   (2,14 impliciti nel floor); e' un limite inferiore come in diagnosi.
4. **770111 non riscalato** (default sorgente 1.0, nessuno stop misurabile):
   la sensibilita' col /2 sposta il DD di +0,3pp.
5. **Il controfattuale non ricalcola i segnali**: stessi trade, stessi prezzi,
   solo la taglia. All'1% l'EA avrebbe fatto **gli stessi ingressi** (il
   rischio non entra nella logica di segnale — diagnosi §1), quindi
   l'assunzione e' solida; l'unico effetto di secondo ordine ignorato e' che
   un saldo meno eroso avrebbe alzato leggermente i lotti successivi.
6. **Convenzione del denominatore**: 5.100 fisso per confrontabilita' con M27;
   il saldo ricostruito al picco (5.445) da' sempre numeri ~0,4-1pp piu'
   bassi. Riportati entrambi.
7. 🆕 **Rilievo emerso**: lo stop 770102 del 23/07 realizzava **2,009%** —
   la finestra a taglia doppia toccava anche quel gemello OTT, cosa che la
   diagnosi non copriva (guardava la 770101). Non cambia il caso chiuso
   (stesso default `ABTG_DEF_RISK`? il 770102 non e' piu' in campo), ma va
   scritto.

## 6️⃣ IL QUADRO PER LE DUE DECISIONI PARCHEGGIATE — punto 3: **NESSUNA DECISIONE QUI**

Le due revisioni del 31/08 tornano sul tavolo **col numero pulito**, come
PIANO_PROP prescriveva ("nessuno spegnimento prima di questo numero").

### Decisione 1 — RETEST-only per le Aperture DAX?

| cosa dice ciascun numero | |
|---|---|
| R83 (banco, criteri congelati) | il retest e' l'**unica** modalita' positiva in entrambe le meta' (PF tot 1,143), incoronata ad armi pari |
| forward normalizzato (questo referto) | BUY −108,81 · SELL −200,02 · RETEST **+53,59** — anche a taglia giusta le modalita' vecchie **perdono**, non era (solo) la taglia |
| DD della serie RETEST-only | **0,28%** contro il 10,60% che la sua stessa misura le concede |
| stato di fatto | dal 21/08 la sedia viva gira **gia'** RETEST-only sulla cella validata (C2) — la decisione formalizzerebbe cio' che e' in campo |
| contro | n=8 forward: campione sottile, il merito resta sotto la valvola R59; formalizzare chiude la porta a un futuro duello dei lati (short e' oggi `false`, nota C2) |

### Decisione 2 — spegnimento della famiglia?

| cosa dice ciascun numero | |
|---|---|
| il motivo dell'urgenza (2,6×) | **caduto**: era misurato a taglia doppia |
| corsia RISCHIO onesta | 1,18× il contratto: **scatta ancora formalmente**, ma come **revisione**, non come emergenza — e la fonte dello sforo (BUY/SELL) e' gia' fuori campo |
| corsia MERITO (famiglia ≥20 op in perdita) | **resta scattata anche normalizzata**: −277,64 € su 42 op. La normalizzazione dimezza la perdita, non la annulla |
| a favore dello spegnimento | il netto normalizzato e' comunque negativo; il contratto scritto (6,25%) e' comunque sforato; tre banchi concordi bocciano le modalita' vecchie |
| contro lo spegnimento | la **sedia colpevole** (per la regola C3 firmata si spegne la sedia, non la famiglia) sarebbe la configurazione BUY/SELL **che non esiste piu' in campo**; la parte viva (RETEST) e' positiva su due conti, DD 0,28%, e ha appena passato il collaudo C1-C4 |
| via di mezzo disponibile | aggiornare il **contratto** della 770101 alla cella realmente promossa (RETEST, R83: DD 10,60% a 1%) — il 6,25% di R16 descrive una cella che non gira piu'; e' manutenzione del censimento (FIX 4 / M30), non un indulto |

## 📎 Fonti e metodo

`data/statements/trades_auto.csv` (42 op famiglia; curva su tutte le 1.256) ·
`report/DIAGNOSI_770101_SIZING_2026-08-31.md` (lotti-se-1%, fattore 1,98,
ancora del saldo) · `report/M27_SEGNO_ASPETTATIVA_2026-08-31.md` §B3
(riprodotto: −689,02 e 16,39% al centesimo) ·
`report/VERBALE_CHIUSURA_770101_2026-09-02.md` · `report/CONTRATTI_SEDIE.md`
r.81 · `backtest_pipeline/risultati_archivio/REFERTO_ROUND83_INGRESSI.md`
(DD 10,60% della cella RETEST). Script di calcolo: ricostruzione saldo
ancorata + serie normalizzata, eseguito in sessione (scratchpad), esiti
integralmente in questo referto.
