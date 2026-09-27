# 🎲 MC della challenge FTMO v2 — BLOCCHI PER GIORNATA, la 770105 e l'ORO LONG (27/09/2026)

**Conto**: FTMO **`541452707`** (`C:\FTMO`), 2-Step fase 1, 80.000 EUR. **SOLA LETTURA**: nessun EA,
preset, conto o file di campo toccato. Nessuna riga di lancio in questo documento.
**Domanda**: il MC del 25/09 (`report/MC_DALLO_STATO_DI_OGGI_2026-09-25.md`, PASS **57,2%**) aveva due buchi
dichiarati: **(1)** non conosce le sedie nuove (`770105` DAX short attaccata il 25/09, `770212` Dow short in
firma, l'ORO long possibile `770421`); **(2)** Gemini (`docs/RISPOSTA_GEMINI_2026-09-27.md` §2) lo accusa di
assumere **trade indipendenti**, ignorando il crollo sistemico DAX/Dow/Nasdaq insieme. Quanto cambiano i numeri
se si chiudono i due buchi?
**Strumento**: `backtest_pipeline/mc_challenge_ftmo_v2.py` (**nuovo**; importa la v1
`mc_challenge_ftmo_stato.py` e ne riusa `simula_stato()`, `pool_feriali()` e lo stato del conto, **senza
modificarla**). `--autotest`: **28** controlli, tutti verdi, ~25 s. Tabelle: ~3 min.

> 🔴 **Taglie, cap e Guardian sono firme di Claudio. Qui ci sono SOLO curve a taglie DATE: nessuna proposta.**
> Le righe a 1,00% e 0,65% sono riferimenti già in casa (preset demo BCM / 100k e reale), non suggerimenti.

---

## 0. 📌 In cinque righe

1. ✅ **L'ancora regge**: la v1 rifatta da qui dà **57,2%** (semi 12-14: 57,4 / 56,7 / 57,2), al decimale come
   il 25/09. I blocchi giornalieri con le stesse 4 sedie riproducono la riga "feriali" della v1 **bit per bit**
   (57,5%): la macchina nuova è la vecchia più due agganci, non un'altra macchina (§1, §2).
2. 🔎 **Il buco (2) di Gemini, misurato — e scomposto**: la v1 ricampiona **già** giornate intere, quindi la
   correlazione intra-giornata fra le sue 4 sedie era **già conservata**. Un modello "a trade indipendenti" (per
   posizione) darebbe **61,6%** (+4,1 punti) e **fine entro 5 giorni 16,8%** contro 21,4%. 🔴 **Ma quei +4,1 NON sono
   il "crollo insieme" di Gemini**: a disegno neutro (§3.1, semi 11-13) la parte **FRA sedie** vale **+1,4 punti**
   di PASS (−1,5 di fine ≤ 5) sulle 4 sedie, e con la 770105 dentro è **di segno opposto (−1,8)**; il grosso è
   **DENTRO la `771531`** (giornate con fino a 8 posizioni; in campo la coppia serale ha SL comune): da sola, +16,6 punti nell'IID per posizione
   (contro-esempio iv). La v1 aveva già pagato tutti e due i conti.
3. 🥇 **L'ORO long agganciato per data** sposta poco perché nella finestra degli indici ha **43 giornate su 277**:
   a 0,5% del saldo **+1,3 punti** (58,8%), a 1,0% **+2,3** (59,8%). Sull'intera storia 2020-26, pescato
   indipendente dagli indici: +0,1 / +0,6. **Non è una sedia che cambia la challenge: è un cerotto** (§3).
4. 🔴 **La 770105 (DAX short) NON aggiunge probabilità di passare e aggiunge probabilità di finire presto**: nella
   sua finestra (2025.07 → 2026.06) le 4 sedie fanno 55,4%, con la 770105 **55,1%**; ma **P(fine ≤ 5 giorni) sale
   da 22,5% a 25,4%**. A 1,00% e 0,65% la sedia **toglie 5-6 punti** di PASS (§3, §4). Coerente col suo contratto:
   PF OOS 1,065, DD_fisso 12,7% a 1% (`SEDIA_SHORT_DAX_FTMO_2026-09-25.md` §⑥).
5. 🎯 **Il campo di OGGI, per quanto i dati permettono** (4 sedie + 770105, blocchi, finestra B): **PASS 55,1%**
   (semi 54,4-55,2), **fermata Guardian 44,9%**, **fine ≤ 5 giorni 25,4%**. **SE** si aggiungesse l'oro long a
   1,0% (**in bozza, NON in campo**): **57,0%** (semi 56,3-57,3), fermata 43,0%, fine ≤ 5 giorni 24,7%, mediana
   **20 giorni** al target; con lo slittamento misurato ×1,048: **54,5%**. `770260`, `770511` (in campo) e `770212`
   (in firma) **non sono modellate**: nessun per-trade in repo (§6).

---

## 1. ✅ I contro-esempi PRIMA dei numeri (regola del 10/09)

Tutti in `--autotest`, tutti verdi. Se uno non tornava, la formula era rotta e si scriveva qui.

| # | contro-esempio | atteso | misurato | esito |
|---|---|---|---|---|
| G0 | la v1 dallo stato di oggi, 2,00%, Guardian 4,5/9,3 | 57,2% | **57,24%** | ✅ ancora |
| G0' | `simula_v2(comp=None)` contro `st.simula_stato` (n 242 / 277, con `attivo`, con slip ×1,048) | identici | **identici bit per bit** (57,24 / 57,53 / 54,41) | ✅ |
| G0'' | costruttore a blocchi con le 4 sedie v1 contro `pool_feriali` della v1 | identici | **277 voci, 35 a zero, uguali bit per bit** | ✅ |
| R | rovina del giocatore, passi 1/64, Guardian 9,3% (2/13 = 15,38%) · muro 10% (3/14 = 21,43%) | 15,38 / 21,43 | **15,35 / 21,33** | ✅ come nella v1 |
| **(i)** | **un solo trade per giorno** (ogni posizione delle 4 sedie è la sua giornata, 560 giornate): blocchi e IID devono coincidere entro il rumore | Δ ≈ 0 (±0,5 su 20.000 sim) | blocchi 58,06% · IID 57,45% → **Δ −0,61** | ✅ |
| **(ii)** | **correlazione artificiale 1** (giornata j = j-esimo peggiore di OGNI sedia; marginali identiche): a Guardian SPENTO **P(muro giornaliero 5%)** dei blocchi deve superare l'IID | blocchi > IID | **59,6% contro 20,0%** | ✅ |
| (i') | la stessa prova (i) nella **configurazione della tabella**: blocchi **senza** reimmissione (come la v1), IID **con** | informativo | blocchi 59,06 · IID 57,87 → **Δ −1,19** (semi 12/13: −1,00 / −0,72) | ⚠️ **disegno, non correlazione**: nella tabella IID e blocchi non pescano allo stesso modo; per questo la decomposizione (§3.1) gira tutta **con** reimmissione |
| **(iii)** | **oro a taglia 0** = tabella "senza oro" | identiche | valori, `attivo` e tabella **identici bit per bit** (57,525%) | ✅ |
| **(iv)** | **una sedia sola** (`771531`, finestra A, tutto con reimmissione): fra sedie non c'è niente da distruggere, quindi l'**IID-S** (giornate di sedia indipendenti) deve coincidere coi blocchi; l'IID **per posizione** invece spezza le sue giornate a più posizioni | IID-S ≈ BLK; IID ≫ BLK | BLK 61,37 · IID-S 61,04 (**Δ −0,33**) · IID per posizione **77,94 (Δ +16,57)** | ✅ — ed è il contro-esempio che **cambia la lettura** dell'IID (§3.1) |
| S | scala: −500 EUR oro su 100k → −0,5% (t 0,5) / −1,0% (t 1,0), e NON segue il fattore; −100 EUR 770105 su 10k → −2% a fattore 2 | esatti | **esatti** | ✅ |
| D | somma giornaliera = somma per posizione, per ogni sedia; 770105 181 posizioni +254,74 (RIEPILOGO_R251); oro 279 posizioni dal 2020.01.03 | | ✅ | ✅ |

🔴 **Un fatto trovato costruendo il (ii), e va detto con la sua etichetta**: col **Guardian ACCESO** la
correlazione 1 dà **P(fermata) 38,0% a blocchi contro 39,3% IID** (semi 12/13/14: 38,0-38,6 · 38,5-38,7 ·
39,1-39,3) — cioè **non più alta, e la differenza è dentro il rumore**. Il meccanismo è misurato: col **solo**
taglio totale 9,3% e il B1 spento, la correlazione 1 porta la fine corsa da **49,2% (IID) a 70,0% (blocchi)**; col
B1 acceso la differenza sparisce, perché nel modello il B1 **tronca** a 4,5% ogni giornata (nell'universo comonotono
18 giornate oltre soglia; sommata sulle 193 giornate, la perdita tagliata vale il 40,5% del banco). Prima stesura del test: usava P(fermata) e
**falliva**; la misura giusta per il "crollo insieme" è il muro giornaliero a Guardian spento, ed è quella che il
test usa.
🟠 **Ma è una proprietà del MODELLO, non una misura del Guardian in campo**: il taglio del modello è **perfetto**
(esatto a 4,5% del saldo, sul realizzato, senza slittamento della chiusura d'emergenza, senza gap). Che il B1 vero
tagli la coda di una giornata storta è **plausibile nel verso** (è un taglio giornaliero, e in campo prima arrivano
pausa 3,5% e cap 4,00); **quanto** la tagli è `[NON MISURATO]` (§6.4-6.5).

---

## 2. 🧾 Cosa c'è dentro, con le etichette

**Stato di partenza** [MISURATO, `NOTTE_2026-09-26.md`, MetriX al centesimo]: saldo **75.090,72** = 0,938634 del
banco, DD 6,14%, giorni di trading fatti **3** (ne manca **1**), target 88.000, muri FTMO 5% giornaliero (4.000 dal
saldo iniziale) e 10% totale (72.000), Guardian in campo **4,5 / 9,3 / pausa 3,5 / cap 4,00** (emergenza a
72.560), nessun limite di tempo. Tutto letto dalla v1, non riscritto. Si parte dall'apertura del prossimo giorno
di borsa (lun 28/09).

**Sorgenti per-trade** (tutte a tick reali BCM tranne l'oro):

| sedia | file | finestra | posizioni | deposito · rischio di misura | etichetta |
|---|---|---|---|---:|---|
| 770101 DAX | `aperture_r47/..._772501.csv` (v1) | 2025.06.11 → 2026.06.25 | 193 | 100k · 1% | [MISURATO] |
| 770202 Dow | `aperture_r47/..._772505.csv` (v1) | 2025.06.10 → 2026.06.29 | 96 | 100k · 1% | [MISURATO] |
| 770411 MaxMin DAX | `trades_portafoglio/..._770413.csv` (v1) | 2025.08.19 → 2026.06.24 | 14 | 100k · 1% | [MISURATO] |
| 771531 EMA200 Dow | `trades_candidati_r23/..._771521.csv` (v1) | 2025.06.12 → 2026.06.26 | 257 (102 giornate) | 100k · 1% | [MISURATO] |
| **770105 DAX short** | `risultati_archivio/R251/PERTRADE/..._792520.csv` (R251b cella ancora = short identico al long, TP1 50%) | **solo OOS 2025.07.01 → 2026.06.29** | **181** | **10k · 1%** | [MISURATO] a ora fissa BCM; la versione **in fase** (R252) **non è arrivata** |
| **795301 ORO long** | `risultati_archivio/ROUND_CORTI_B_2026-09-27/PERTRADE/..._795301.csv` (R260a) | 2020.01.03 → 2026.06.26 | **279** (375 deal) | **100k · 0,5%** | [MISURATO su **OHLC M1**], k BCM 1,8113 EUR/lotto già dentro il net |
| 770212 Dow short | — | — | — | — | 🔴 **[NON MODELLATA]**: R54a ha solo CSV di riepilogo, R255 non girato |
| 770260 Nasdaq · 770511 SuperWave | — | — | — | — | 🔴 **[NON MODELLATE]** (già fuori dalla v1) |

**Unità** [DERIVATO, regole della v1]: valore = net / deposito di misura, alla taglia di misura; `simula_stato`
moltiplica per il fattore (2,0 = taglia 2,00% delle sedie indici) e applica la frazione fissa sul saldo del giorno.
L'oro è a **taglia assoluta** (0,5% o 1,0% del saldo) e **non** segue il fattore: la sua scala vale
`(t / 0,5) / (100.000 × fattore)`. Tutti i coefficienti sono potenze di due: le somme restano identiche alla v1
quando le sedie nuove pesano zero (è il contro-esempio iii).

**Calendario** [DERIVATO]: l'unità è la **giornata di borsa** (feriali + giornate con operazioni, come
`pool_feriali` della v1); una giornata vuota vale 0 e non conta come trading day.
- **Finestra A** = quella della v1: 2025.06.10 → 2026.06.29, **277 giorni**; l'oro vi ha **43 giornate** (4 senza
  sedie indici).
- **Finestra B** = dove esiste la 770105: 2025.07.01 → 2026.06.29, **262 giorni**; oro 41 giornate.
- **Oro intera storia** = variante etichettata: 2020.01.03 → 2026.06.26, 1.691 giorni, 279 con operazioni; l'oro è
  pescato da questo secondo calendario **indipendentemente** dalla giornata indici (più regimi, correlazione
  oro-indici persa per costruzione).

**Blocchi contro IID** [DERIVATO]:
- **BLK**: tutti i trade di tutte le sedie dello stesso giorno restano insieme (la v1 estesa alle sedie nuove).
- **IID**: stesso calendario e **stesso conteggio di posizioni per sedia e per giornata**, ma il P/L di ogni
  posizione è estratto a caso dal pool della sua sedia. È il modello "trade indipendenti" che Gemini critica,
  messo accanto per **misurare** quanto vale la correlazione, non per usarlo. 🔴 Distrugge **due** cose: il
  co-movimento FRA sedie **e** quello DENTRO la sedia (la `771531` ha 77 giornate con ≥2 posizioni, fino a 8, 47
  con tutte dello stesso segno; le altre sedie ne hanno al massimo 1 al giorno).
- **IID-S** (aggiunto al cancello): stesso calendario e stessa presenza, ma il **totale di giornata** di ogni sedia
  presente è estratto a caso dalle giornate della **stessa sedia**. Distrugge **solo** il co-movimento FRA sedie:
  è la misura del "crollo insieme" di Gemini.

**Correlazione intra-giornata, misurata sui per-trade** [MISURATO, finestra B]: giornate con ≥2 sedie operative
**203**, con ≥2 sedie in **perdita insieme 37**. Coppie: 770202×771531 **ρ +0,62** (22 giorni comuni), 770411×770105
**+0,79** (11 giorni), 771531×oro +0,34 (17), 770202×oro +0,36 (18), 770101×oro **−0,33** (29), 770101×770105 −0,02
(127). Le due coppie forti sono **sullo stesso simbolo** (US30 e DAX), su **n piccoli** (22 e 11 giorni).

---

## 3. 🎲 LA TABELLA — taglia indici 2,00% (in campo), Guardian 4,5 / 9,3, seme 11, 20.000 sim (±0,35 punti)

"gg" = giorni di borsa (nella riga G0 = giornate con operazioni, come nella v1).

| riga | modello | **P(PASS)** | **P(fermata Guardian 9,3)** | P(muro 5% gg) | P(muro 10%) | **P(fine ≤ 5 gg)** | gg mediani al PASS | gg mediani alla fine | semi 12/13/14 |
|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| **G0** | v1 com'è (242 giornate con operazioni) — **ANCORA** | **57,2** | 42,8 | 0,0 | 0,0 | 23,6 | 22 | 5 | 57,4 / 56,7 / 57,2 |
| G0f | v1 feriali (277 gg, 35 a zero) | 57,5 | 42,5 | 0,0 | 0,0 | 21,4 | 24 | 5 | 57,4 / 57,5 / 57,7 |
| **IID A** | 4 sedie, posizioni indipendenti *(il modello criticato)* | **61,6** | 38,4 | 0,0 | 0,0 | **16,8** | 27 | 6 | 62,5 / 61,6 / 62,2 |
| IID-S A | 4 sedie, giornate di sedia indipendenti *(solo FRA sedie)* | 58,0 | 42,0 | 0,0 | 0,0 | 19,9 | 25 | 6 | 57,4 / 57,8 / 57,7 |
| **BLK A** | 4 sedie a blocchi giornalieri (**= G0f bit per bit**) | **57,5** | 42,5 | 0,0 | 0,0 | 21,4 | 24 | 5 | 57,4 / 57,5 / 57,7 |
| BLK A | + ORO **0,5%** (43 giornate, per data) | 58,8 | 41,2 | 0,0 | 0,0 | 21,0 | 24 | 5 | 58,5 / 58,7 / 58,8 |
| BLK A | + ORO **1,0%** (43 giornate, per data) | 59,8 | 40,2 | 0,0 | 0,0 | 20,8 | 24 | 5 | 59,2 / 59,4 / 59,7 |
| IID A | + ORO 1,0%, posizioni indipendenti | 63,9 | 36,1 | 0,0 | 0,0 | 16,5 | 26 | 6 | 64,2 / 64,2 / 64,0 |
| BLK A | + ORO 0,5% **intera storia 2020-26, indipendente** | 57,6 | 42,4 | 0,0 | 0,0 | 21,1 | 24 | 6 | 57,9 / 57,6 / 57,9 |
| BLK A | + ORO 1,0% **intera storia, indipendente** | 58,1 | 41,9 | 0,0 | 0,0 | 21,3 | 23 | 5 | 58,2 / 58,4 / 58,1 |
| **BLK B** | 4 sedie, finestra B (2025.07.01 → 2026.06.29, 262 gg) | 55,4 | 44,6 | 0,0 | 0,0 | 22,5 | 24 | 5 | 55,9 / 55,1 / 55,7 |
| **BLK B** | **+ 770105** (DAX short, 181 giornate) | **55,1** | 44,9 | 0,0 | 0,0 | **25,4** | 21 | 5 | 55,0 / 54,4 / 55,2 |
| IID B | + 770105, posizioni indipendenti | 55,1 | 44,9 | 0,0 | 0,0 | 22,5 | 23 | 5 | 55,4 / 55,0 / 54,8 |
| IID-S B | + 770105, giornate di sedia indipendenti *(solo FRA sedie)* | 52,6 | 47,4 | 0,0 | 0,0 | 24,4 | 21 | 5 | 52,3 / 53,1 / 52,8 |
| BLK B | + 770105 + ORO 0,5% | 56,2 | 43,8 | 0,0 | 0,0 | 24,9 | 20 | 5 | 56,2 / 55,5 / 56,4 |
| **BLK B** | **+ 770105 + ORO 1,0%** *(il più completo)* | **57,0** | **43,0** | 0,0 | 0,0 | **24,7** | **20** | 4 | 57,3 / 56,3 / 57,3 |
| IID B | + 770105 + ORO 1,0%, posizioni indipendenti | 57,4 | 42,6 | 0,0 | 0,0 | 22,0 | 22 | 5 | 58,0 / 58,3 / 57,2 |
| BLK B | + 770105 + ORO 1,0% intera storia, indipendente | 54,9 | 45,1 | 0,0 | 0,0 | 25,6 | 20 | 5 | 55,4 / 55,3 / 56,1 |
| BLK B | + 770105 + ORO 1,0% + **slittamento ×1,048** (misurato sui 3 stop) | 54,5 | 45,5 | 0,0 | 0,0 | 26,1 | 20 | 4 | 54,4 / 53,6 / 54,6 |

**Come si legge**
- 🔎 **Quanto vale la correlazione (buco 2)**: sulla stessa finestra e stesse sedie, **IID − BLK = +4,1 punti di
  PASS e −4,6 punti di fine ≤ 5 gg** (4 sedie), **+4,1 / −4,3** con l'oro; con la 770105 dentro la differenza sul
  PASS si azzera (55,1 = 55,1) ma la fine entro 5 giorni resta sottostimata dall'IID di 2,9 punti. 🔴 **Questi
  numeri mescolano due co-movimenti e un effetto di disegno** (contro-esempi i' e iv): la lettura pulita è in §3.1.
  Quello che resta vero: **il 57,2 del 25/09 non era un numero da trade indipendenti.**
- 🥇 **Oro (buco 1a)**: +1,3 / +2,3 punti agganciato per data; +0,1 / +0,6 pescato dall'intera storia. Poco, per
  un motivo aritmetico: **43 giornate d'oro in 277** e una taglia da 0,5-1,0% contro quattro sedie al 2%. Con
  ρ −0,33 contro il DAX long l'oro **non** amplifica le giornate storte (perdono insieme in 2 giorni su 29).
- 🔴 **770105 (buco 1b)**: −0,3 punti di PASS e **+2,9 di fine entro 5 giorni** rispetto alle stesse 4 sedie sulla
  stessa finestra. A 2% la sedia è **rischio senza merito** nel modello; e il suo per-trade è **a ora fissa BCM**
  (d'inverno un'ora prima della cash): la versione in fase (R252) **può spostare il numero in un verso che oggi non
  si conosce**.
- ⚠️ **Il muro FTMO vale 0,0 per costruzione** finché il Guardian lavora (come nella v1): la fermata a 9,3% arriva
  prima. Il numero che conta è la **fermata del Guardian**: conto fermo, non violato.

### 3.1 🧩 La decomposizione del co-movimento — a disegno NEUTRO (tutto con reimmissione), 2,00%, semi 11 / 12 / 13

Nella tabella i blocchi pescano **senza** reimmissione (come la v1) e l'IID **con**: il confronto porta dentro 1-3
punti di solo disegno (contro-esempio i'). Qui tutte e tre le varianti pescano **con** reimmissione, quindi le
differenze sono solo co-movimento. Stampata da `main` (blocco `[DECOMPOSIZIONE ...]`). PASS · fine ≤ 5 gg:

| sedie | BLK (niente distrutto) | IID-S (distrutto FRA sedie) | IID (distrutto anche DENTRO) | **FRA sedie** = IID-S − BLK | **DENTRO la sedia** = IID − IID-S |
|---|---|---|---|---:|---:|
| A: 4 sedie v1 | 56,5 · 21,4 / 56,7 · 21,3 / 56,5 · 21,7 | 58,0 · 20,0 / 57,5 · 20,4 / 58,4 · 19,4 | 61,8 · 17,0 / 62,0 · 16,9 / 61,5 · 16,6 | **+1,4** PASS · **−1,5** fine≤5 | **+3,8** · **−3,1** |
| B: 4 sedie + 770105 | 54,6 · 25,1 / 54,7 · 25,0 / 54,0 · 25,4 | 52,5 · 24,9 / 52,5 · 25,2 / 53,0 · 24,6 | 54,8 · 23,0 / 55,3 · 22,9 / 54,7 · 23,1 | **−1,8** · −0,3 | **+2,3** · −1,9 |
| A: 771531 sola *(contro-esempio iv)* | 61,4 · 8,1 / 61,7 · 8,4 / 60,8 · 8,5 | 61,0 · 8,2 / 61,8 · 8,2 / 61,4 · 8,1 | 77,9 · 2,7 / 78,1 · 2,6 / 77,4 · 2,8 | +0,1 (atteso 0) | **+16,4** |

(differenze = medie dei tre semi)

- 🔴 **Il "crollo insieme" di Gemini, misurato da solo**: sulle 4 sedie v1 ignorarlo rende il modello ottimista di
  **~1,4 punti** di PASS e **~1,5** di fine ≤ 5 giorni — reale, ma **circa un quarto** dell'ottimismo IID totale a disegno neutro (+5,2 = +1,4 FRA + 3,8 DENTRO). Con la 770105
  dentro il segno si **rovescia** (−1,8: le giornate vere sono **meno** storte insieme di quelle indipendenti); quale
  coppia lo fa è `[NON ATTRIBUITO]` (770101 long × 770105 short sullo stesso DAX è la candidata: 127 giorni comuni,
  perdono insieme 14).
- 🔴 **Il grosso dell'ottimismo IID è DENTRO la `771531`**: le sue giornate a più posizioni (coppia di SELL LIMIT con
  SL comune, fino a 8 posizioni) si muovono spesso insieme (47 giornate su 77 con tutte le posizioni dello stesso segno); spezzarle vale +16,4 punti sulla sedia sola (media dei semi, IID − IID-S; il contro-esempio iv misura IID − BLK = +16,6 al seme 11).
  Non è correlazione fra indici: è la struttura di un EA (la coppia serale con SL comune è il caso visto in campo il 25/09, `NOTTE_2026-09-26.md`).
- 🟠 **Un regime solo** (toro 2025-26) e **due sedie USA in campo fuori dal modello** (`770260`, `770511`): un crollo
  sistemico vero è proprio quello che questo campione **non contiene** (§6.7). Il +1,4 è la misura di **questo**
  anno, non un tetto.

---

## 4. 📉 Le stesse curve alle taglie GIÀ IN CASA (riferimento, seme 11, NESSUNA PROPOSTA)

Oro sempre a taglia assoluta (0,5 / 1,0). A 1,00% e 0,65% il cap 3,25/4,00 non morde mai nel modello (come §4 della v1).

| modello | **1,00%**: PASS · fermata · fine≤5 · gg | **0,65%**: PASS · fermata · fine≤5 · gg |
|---|---|---|
| G0 v1 com'è | 75,3 · 24,7 · 6,3 · 58 | 88,1 · 11,9 · 1,0 · 99 |
| BLK A, 4 sedie (= G0f) | 76,1 · 23,9 · 5,0 · 66 | 88,1 · 11,9 · 0,9 · 113 |
| IID A, 4 sedie *(criticato)* | 80,7 · 19,3 · 2,8 · 69 | 91,4 · 8,6 · 0,2 · 116 |
| IID-S A, 4 sedie *(solo FRA sedie)* | 75,7 · 24,3 · 4,1 · 65 | 87,6 · 12,4 · 0,5 · 112 |
| BLK A + ORO 0,5% | 78,0 · 22,0 · 4,9 · 62 | 90,0 · 10,0 · 0,8 · 102 |
| BLK A + ORO 1,0% | 78,9 · 21,1 · 5,0 · 59 | 90,5 · 9,5 · 0,8 · 92 |
| BLK A + ORO 1,0% intera storia, indip. | 75,3 · 24,7 · 5,7 · 60 | 85,9 · 14,1 · 1,2 · 97 |
| BLK B, 4 sedie | 73,3 · 26,7 · 5,7 · 66 | 86,4 · 13,6 · 1,0 · 113 |
| **BLK B + 770105** | **67,5** · 32,5 · 9,0 · 58 | **81,1** · 18,9 · 2,2 · 104 |
| IID B + 770105 | 72,8 · 27,2 · 5,2 · 61 | 85,0 · 14,9 · 0,7 · 106 |
| IID-S B + 770105 *(solo FRA sedie)* | 69,4 · 30,6 · 6,6 · 59 | 81,8 · 18,2 · 1,1 · 103 |
| BLK B + 770105 + ORO 0,5% | 69,9 · 30,1 · 8,8 · 55 | 84,0 · 16,0 · 2,1 · 93 |
| BLK B + 770105 + ORO 1,0% | 71,6 · 28,4 · 8,9 · 52 | 85,1 · 14,9 · 2,2 · 83 |
| BLK B + 770105 + ORO 1,0% + slip ×1,048 | 67,3 · 32,7 · 10,0 · 53 | 81,8 · 18,2 · 2,8 · 87 |

- A taglie più piccole **la 770105 pesa di più in negativo** (−5,8 e −5,3 punti contro le 4 sedie sulla stessa
  finestra) perché la corsa è lunga (58-104 giorni) e un PF 1,065 con 0,7 posizioni al giorno **erode**, mentre a
  2% la corsa finisce prima che la sua media conti. L'IID per posizione resta ottimista (IID − BLK = +4,6 / +3,3
  sulle 4 sedie), ma la parte **FRA sedie** (IID-S − BLK) qui è −0,4 / −0,5 sulle 4 sedie e +1,9 / +0,7 con la 770105:
  a queste taglie è **dentro il disegno di campionamento** (1-3 punti, contro-esempio i'), quindi **non letta**. La
  decomposizione a disegno neutro è fatta solo a 2,00% (§3.1).
- L'oro **1,0% pesato per data** vale +2,8 / +2,4 punti a queste taglie; **pescato dall'intera storia toglie**
  (−0,8 / −2,2): le 236 giornate d'oro **fuori** dal toro 2025-26 hanno un altro bilancio, e 0,5% a saldo fisso
  non lo compensa. È il segno che le 43 giornate in finestra sono **un campione sottile** dell'oro.

---

## 5. 🔬 Perché il buco (2) era più piccolo di come lo descriveva Gemini — detto senza sconti

- La frase di casa nel documento Gemini (prima della correzione di `c05e87cd`), *"il MC di casa ricampiona per-trade per sedia"*, **era falsa per la v1**:
  `m.serie()` somma per **giornata**, `simula_stato()` pesca **giornate**. Il referto v1 §6.1 lo diceva già
  (*"dentro le 4, la correlazione per giornata è conservata"*). Non l'ho assunto: **l'ho fatto riprodurre bit per
  bit dal costruttore a blocchi** (G0'' in §1).
- Quello che la v1 **non** poteva fare era agganciare per data una sedia **nuova**: qui è fatto per 770105 e oro.
- E il "trade indipendenti" che Gemini temeva, misurato da solo (IID-S, §3.1), vale **~1,4 punti** sulle 4 sedie di
  questo anno: la maggior parte dell'ottimismo di un MC per posizione verrebbe dalla struttura della `771531`, non
  dal crollo congiunto degli indici.
- Quello che **nessuno** dei due fa: la correlazione **fra giornate** (una settimana storta è una sequenza, non un
  giorno) e il **crollo di regime** (2020). Il rimescolamento di giornate non fabbrica né l'una né l'altro: resta
  scritto in §6.

---

## 6. 🚧 Limiti — dichiarati, con l'etichetta

1. 🔴 **[NON MODELLATE]**: **770212** (Dow short, in firma) — nessun per-trade in repo (R54a: solo CSV `_IS/_OOS`
   di riepilogo, PF OOS 0,840 su 73; R255 in mano a Claudio). **Nessun proxy col segno cambiato**: sarebbe un
   numero inventato. **770260** e **770511** (in campo) come nella v1. Il numero resta un **pavimento del
   rischio**, non un tetto.
2. 🔴 **La 770105 è a ora fissa BCM** (d'inverno arma un'ora prima della cash; FTMO arma in fase): il per-trade
   **mescola due tempistiche**, e la misura in fase (R252) non è arrivata. Solo gamba **OOS** (2025.07 → 2026.06):
   per questo esiste la finestra B, e le righe A e B **non si confrontano fra loro** ma con la propria base.
3. 🔴 **L'oro è OHLC M1**, non tick: il DD OHLC è un **limite inferiore** (R268 lo sta misurando). E in finestra
   ha **43 giornate**: il suo contributo qui è un campione sottile; l'"intera storia" ne ha 279 ma senza
   co-movimento con gli indici. Nessuna delle due varianti è "la vera". La commissione FTMO su XAUUSD è
   **[NON MISURATA]**; nel net c'è la k BCM di banco (1,8113 EUR/lotto).
4. 🟠 **Slittamento**: una riga sola, ×1,048 misurato su **3** stop (non è un tasso). Moltiplica le **giornate** in
   perdita, non il singolo stop. Lo slittamento della chiusura d'emergenza contro il cuscino 72.560 → 72.000 resta
   **[NON MISURATO]** (unica strada per cui il muro FTMO può diventare > 0 col Guardian vivo).
5. 🟠 **Il Guardian è codificato come nella v1**: taglio giornaliero a 4,5% sul **realizzato** (l'equity non c'è:
   fermata **sottostimata**), fermata a 9,3% = fine corsa, **pausa 3,5% e cap C1 non rimodellati** qui (le righe di
   sensibilità restano nella v1 §5). Col cap 4,00 e sei sedie a 2% in campo, **la terza posizione simultanea è
   bloccata solo all'INVIO** (classe 645): il modello non toglie niente, cioè **sovrastima** l'esposizione
   possibile nelle giornate a 3+ sedie.
6. 🟠 **Posizione aperta sul weekend**: `771531` SELL 4,84 US30 con SL a 51.993,81 (~735 EUR = 0,92% di rischio)
   aperta il 25/09 (`NOTTE_2026-09-26.md`). Il modello parte dal saldo chiuso: quel rischio flottante **non è
   dentro** il primo giorno simulato.
7. 🟠 **Correlazione fra giornate e regime**: i blocchi sono di **un giorno**; settimane storte e un 2020 non si
   rimescolano. Un solo regime (toro 2025-26) per gli indici.
8. 🟠 **Unità IID = posizione** (deal sommati per `position_id`, datata all'ultimo deal): con i deal parziali come
   unità l'IID sarebbe ancora più ottimista. La scelta è dichiarata nel docstring. 🔴 E l'IID per posizione
   **non** misura solo la correlazione fra sedie: spezza anche le giornate a più posizioni della `771531`
   (contro-esempio iv); la lettura "fra sedie" è l'**IID-S** (§3.1).
10. 🟠 **Disegno di campionamento** (contro-esempio i'): i blocchi pescano **senza** reimmissione (come la v1), IID e
    IID-S **con**. Nella tabella di §3 il confronto IID/BLK porta dentro 1-3 punti di solo disegno; i numeri della
    decomposizione (§3.1) sono tutti **con** reimmissione.
11. 🟠 **Scala dell'oro, classe 321** [MISURATO]: l'EA dimensiona sul **saldo corrente** del backtest, che nella
    finestra A vale 110.029-114.352: gli stop veri sono −535,56 e −558,68 (0,487-0,489% del saldo corrente, ma
    0,54-0,56% del 100.000 fisso). L'oro "0,5%" delle righe per data è quindi un **~0,55%** effettivo (e l'"1,0%" un
    ~1,1%). Rifatte le righe oro con il net rinormalizzato sul saldo corrente: **spostamento ≤ 0,3 punti** su tutte
    (es. BLK B + 770105 + oro 1,0% a 2%: 57,0 → 56,8). Si dichiara, non si corregge: le 4 sedie v1 hanno lo stesso
    effetto **ereditato** (saldi finali 106.143-123.321), la 770105 quasi nullo (10.000 → 10.254,74). Il
    contro-esempio "−500 EUR → −0,5%" di §1 verifica l'**aritmetica** del coefficiente, non che −500 sia lo stop vero.
12. 🟠 **Cambio di taglia a metà challenge**: le colonne 1,00% / 0,65% di §4 misurano il conto, **non** la regola FTMO
    (Forbidden Practices, v1 §6.9: `[NON VERIFICATO]` con FTMO).
9. 🟠 **Scala ×2 dalla misura a 1,00%** (misurata ×1,956-1,990 nella v1): sovrastima leggermente il DD. Per la
   770105 a deposito 10.000 vale in più l'arrotondamento del lotto (classe 791).

---

## 7. ✅ Cosa è andato bene

- 🥇 **Zero numeri cambiati nella v1**: 57,2 riprodotto, blocchi = feriali bit per bit, rovina del giocatore
  come nella v1. La v2 è un'estensione, non una sostituzione.
- 🔎 **La critica di Gemini è stata misurata, non discussa — e scomposta**: +4,1 punti di ottimismo nell'IID per
  posizione, di cui **~1,4** FRA sedie (il suo "crollo insieme") e il resto dentro la `771531` (§3.1). Il
  contro-esempio (ii) prova che il modello a blocchi **vede** il crollo congiunto quando c'è (59,6% contro 20,0% di
  muro giornaliero a Guardian spento); a Guardian acceso il taglio B1 **del modello** lo assorbe — proprietà del
  modello, nel verso plausibile, magnitudo in campo `[NON MISURATA]`.
- 🧪 **Un contro-esempio ha fallito in prima stesura ed è stato corretto PRIMA di consegnare** (Agente dei
  Controlli, 13/09): la versione con P(fermata) a Guardian acceso dava il segno opposto per una ragione vera, ed è
  diventata una misura informativa, non un test.
- 📐 **Sulla propria finestra B** il campo di oggi (4 sedie + 770105) fa **55,1** contro **55,4** delle 4 sedie, e
  la fine ≤ 5 giorni sale da **22,5 a 25,4**: la 770105 che nel modello **non paga** è la lettura nuova (A e B non si
  confrontano fra loro, §6.2).

**Nessuna proposta di taglia, di cap o di Guardian.** I numeri sono per la decisione di Claudio.

---

## 📎 Riproducibilità

```text
python3 backtest_pipeline/mc_challenge_ftmo_v2.py --autotest   # 28 controlli + contro-esempi (i)(i')(ii)(iii)(iv), esce 0 se verde, ~25 s
python3 backtest_pipeline/mc_challenge_ftmo_v2.py              # tabelle di §2 (correlazione), §3, §3.1 e §4, ~3 min
```
