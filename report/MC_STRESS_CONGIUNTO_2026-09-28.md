# 🧪 MC della challenge FTMO sotto STRESS CONGIUNTO: superamento alla fermata, costi, grappoli (28/09/2026)

**Conto**: FTMO **`541452707`** (`C:\FTMO`), 2-Step fase 1, 80.000 EUR. **SOLA LETTURA**: nessun EA, preset, conto
o file di campo toccato. Nessuna riga di lancio in questo documento: lo strumento gira sulla macchina di sviluppo,
costo macchina zero (~3 min 20 s per le tabelle, ~50 s per l'autotest).
**Domanda**: i punti **1** e **5** del parere di Emiliano (`docs/PARERE_EMILIANO_2026-09-28.md`):
(1) *"il Guardiano interviene al limite formale, mentre nella realta' slippage, commissioni, posizioni simultanee e
latenza possono portarti oltre prima che la chiusura sia completata"*; (5) *"prova stress con clustering delle
perdite e peggioramento simultaneo di spread e slippage"*.
Il MC di casa (`report/MC_CON_ORO_E_BLOCCHI_2026-09-27.md`) tratta la fermata a 9,3% come **esatta** (r.172: *"il
muro FTMO vale 0,0 per costruzione finche' il Guardian lavora"*). Qui si toglie quell'ipotesi, una perturbazione
alla volta e poi insieme.
**Strumento**: `backtest_pipeline/mc_stress_congiunto.py` (**nuovo**). Importa `mc_challenge_ftmo_v2.py` (commit
`1c0029a6`, **non modificato**) e la v1, ne riusa dati, calendario, blocchi e simulatore, e aggiunge **solo** tre
agganci inerti a valore zero. `--autotest`: **26 controlli, tutti verdi**.

> 🔴 **Taglie, cap e soglie del Guardian sono firme di Claudio. Qui NON c'e' nessuna proposta**: ci sono le curve
> alla configurazione in campo (sedie indici a 2,00%, Guardian 4,5 / 9,3) e, dove richiesto, **la misura** di quale
> superamento accende il muro FTMO.

---

## 0. 📌 In sei righe

1. ✅ **A perturbazione zero lo script nuovo E' il v2**: dallo stato del 27/09 ridà **55,1%** (semi 55,0 / 54,4 /
   55,2), fermata **44,9**, fine entro 5 giorni **25,4**, giorni mediani **21 / 5**: al decimale come il referto del
   27/09, e il simulatore coincide con quello della v1 **bit per bit** su cinque configurazioni (§2).
2. 🟢 **Lo stato di oggi vale +7,3 punti da solo**: col saldo **75.841,54** (trade del weekend +750,82) la base
   sale a **62,4%** (semi 62,7 / 61,9 / 62,7), fermata **37,6** (§3).
3. 🔴 **Il punto debole del Guardian e' il cuscinetto GIORNALIERO, non quello totale**: fra il taglio 4,5% (3.600
   EUR) e il muro FTMO del 5% (4.000 EUR) ci sono **400 EUR = 26,4% di UNO stop** a 2% del saldo di oggi (13,2% se
   si chiudono **due** posizioni). Nel modello **7 giornate su 262** superano il taglio. **Un superamento del 25% dello
   stop** (k=1) porta **P(muro 5% giornaliero) da 0,0 a 18,8%** e il PASS da 62,4 a **45,2**; dal **27,5%** il muro
   giornaliero vale **~30%** e il PASS **41,2**; dal **40%** ogni fermata diventa una violazione (**MURO 58,8%**) (§5).
4. 📏 **Il superamento misurato finora sta sotto quella soglia**: sui tre stop veri FTMO lo scivolamento e' stato
   **0,8% / 2,9% / 9,9%** dello stop (il peggiore, 156,68 EUR su due posizioni con SL comune, e' il **39%** dei 400
   EUR). A **10%** il muro resta **0,0** e il PASS perde **0,6** punti. Ma sono **3 campioni**, nessuno e' una
   chiusura del Guardian, e nessuno e' un gap (§1, §7).
5. 💸 **I costi mordono piu' dei grappoli**: spread x2 **−9,2** punti, ingresso +3 punti **−14,1**, spread x2 + 1
   punto **−14,4**, pur costando solo **0,02-0,05 R** per posizione: l'edge del campo e' sottile. I **grappoli** del
   calendario vero **non si distinguono da un ordine a caso** (contro L=1, semi 11-14: blocchi 5 da +0,5 a +0,9;
   blocchi 10 da +5,2 a +6,3, **a favore** e dentro il rumore d'ordinamento, dev. st. 4,3). Lo scenario avverso (le 5 settimane peggiori a peso 3) toglie **22,6** punti contro il riferimento a disegno neutro L=1 (**23,5** contro la base, che ha un altro campionamento).
6. 🧨 **Insieme**: moderato **PASS 31,8% / MURO 24,7%**; severo **18,4% / 81,6%**; severo con le settimane peggiori
   **9,5% / 90,5%** (§4). Sono **scenari pessimisti dichiarati**, non previsioni: dicono **dove** il margine si rompe.

---

## 1. 🧊 I valori, scritti PRIMA dei numeri, con la fonte

Sono nel docstring dello script (costanti `SCEN_A`, `SCEN_B`, `SCEN_C`, `INSIEME`, `SPREAD_BASE`) e non sono stati
toccati dopo aver visto le tabelle. L'unica correzione successiva e' al **contro-esempio** Z6 (§2), non a un valore.

| perturbazione | valori | fonte / motivo | etichetta |
|---|---|---|---|
| **(a) superamento alla fermata** | perdita finale = soglia + **sup x k x stop**; sup **10% / 25% / 50%** dello stop; stop = 1 posizione alla taglia (2,00% del saldo d'inizio giornata); **k = 1** e **k = 2** posizioni aperte | stop FTMO veri: **9,9%** (22/09, 156,68 su 1.590,37, due posizioni con SL comune, `PRIMO_STOP_FTMO_2026-09-22.md` r.32), **2,9%** (24/09, `SECONDO_STOP` r.24), **0,8%** (25/09, `TERZO_STOP` r.13); tester D30EUR a tick reali, 551 stop (`MISURA_SLIPPAGE_2026-09-05.md` §3.1): in sessione P99 **8,25** punti, max **25,8**; fuori sessione P90 **46,0**, P95 **92,7**, max **294,4** (su stop DAX di ~55-77 punti: 10% ~ il peggiore FTMO, 25-50% ~ la coda fuori sessione); NASUSD ora 14, 87 stop: max **3,6** punti. k=2 = il **cap C1 4,00** a 2,00% (la terza entra solo per pendente, classe 645) | stop slippage [MISURATO, n piccolo]; **chiusura del Guardian [NON MISURATA]**, gap [NON MISURATO su FTMO] |
| **(b) costi peggiorati** | per posizione, dai **volumi veri**: costo = [(ms−1) x s + p] x volume x q. **ms** = spread **x1,5 / x2**; **p** = ingresso **+1 / +3 punti indice**; combinato x2 + 1 punto | **s** = spread di base del backtest all'ora d'ingresso: D30EUR **1,70**, U30USD **3,00** (`MAPPA_COSTO_SIMBOLI_TF_2026-09-24.md` r.193-194; su U30USD le due fonti dicono 2,00 e 3,00: preso il lato pessimista). FTMO all'apertura e' piu' stretto: GER40 **1,23** (P95 1,33), US30 **2,10** (P95 2,48) (`SPREAD_APERTURA_FTMO_2026-09-21.md` §1, 1 giornata). **p**: il solo ingresso vero misurato, **+0,70** punti (`IL_PRIMO_SLIPPAGE_VERO_2026-09-11.md`, n=1); stop del tester in sessione mediana 0,4-1,0, P95 2,3-3,3 punti. **q** misurato dai file: D30EUR **1,0000** (35 coppie), U30USD **0,8571** (66 coppie; `STOP_VS_SPREAD` dice 0,86091 su 62 trade: scarto 0,4%) | spread [MISURATO]; ingresso [n=1: banda]; ora d'ingresso della 771531 [NON MISURATA] |
| **(c) grappoli** | blocchi **circolari** di **5 e 10** giornate di borsa consecutive; **settimane** ISO intere a peso 1; **le 5 settimane peggiori (10%) a peso 3** (la loro quota di pescata passa da 9,4% a 23,8%) | peso dichiarato qui, non misurato: e' uno scenario avverso, non una stima | [SCENARIO] |
| **insieme** | **I1** moderato = sup 25% k1 + spread x1,5 + 1 punto + blocchi 5 · **I2** severo = sup 50% k2 + spread x2 + 3 punti + blocchi 10 · **I3** = I2 con le settimane peggiori x3 al posto dei blocchi | | [SCENARIO] |

**Commissioni**: sui tre stop FTMO degli indici *"swap e commissioni 0,00"* (`TERZO_STOP_FTMO_2026-09-25.md` r.13):
per le sedie indici modellate la commissione FTMO e' **misurata zero**, quindi non entra. **Swap**: non modellato (il
weekend del 25-28/09 ha dato **+7,26**, a favore).

**Costo extra medio per posizione, in R di misura** (stampato dallo script, dai volumi veri):

| scenario | 770101 DAX | 770202 Dow | 770411 MaxMin | 771531 EMA200 | 770105 DAX short |
|---|---:|---:|---:|---:|---:|
| spread x1,5 | 0,0143 | 0,0152 | 0,0142 | 0,0078 | 0,0123 |
| spread x2 | 0,0286 | 0,0304 | 0,0284 | 0,0155 | 0,0245 |
| ingresso +1 punto | 0,0168 | 0,0101 | 0,0167 | 0,0052 | 0,0144 |
| ingresso +3 punti | 0,0504 | 0,0304 | 0,0501 | 0,0155 | 0,0433 |
| spread x2 + 1 punto | 0,0454 | 0,0405 | 0,0451 | 0,0207 | 0,0390 |
| posizioni | 193 | 96 | 14 | 257 | 181 |

---

## 2. ✅ I contro-esempi PRIMA dei numeri (regola del 10/09)

Tutti in `--autotest`, tutti verdi (26 su 26).

| # | contro-esempio | atteso | misurato | esito |
|---|---|---|---|---|
| Z0 | stato: 75.090,72 + 750,82 | 75.841,54 | **75.841,54** | ✅ |
| Z1 | a perturbazione zero == `st.simula_stato` della v1: G0 (242), feriali (277), feriali con slittamento x1,048, base B (262) al 27/09 e al 28/09 | identici | **identici bit per bit** (57,24 / 57,525 / 54,41 / 55,07 / 62,365) | ✅ |
| Z1' | Guardian SPENTO con sup 50% k2: nessuna chiusura, il superamento non puo' agire | identico alla v1 | **identico** | ✅ |
| Z2 | le ancore del 27/09: G0 **57,2**; base B + 770105 **55,1** con semi **55,0 / 54,4 / 55,2** | al decimale | **57,24**; **55,07 / 54,95 / 54,44 / 55,18**; e sulla stessa riga fermata **44,93**, fine ≤ 5 gg **25,36**, gg **21 / 5** (asserito, aggiunto al cancello del 28/09) | ✅ |
| Z3 | blocchi con L=1 == `v2.simula_v2(reimmissione=True)` | identici | **bit per bit** (61,455) | ✅ |
| Z4 | costo tutto a zero == nessun costo; un giorno per sedia rifatto a mano (770101 2025.07.03, 2 deal, 14,20 lotti; 771531 2025.07.11, 2 deal, 4,50 lotti; 770105 2025.07.01, 0,90 lotti) | uguali | **uguali a 1e-15**; q D30EUR 1,0000, q U30USD 0,8571 entro l'1% del numero gia' in casa | ✅ |
| Z5 | soglie del superamento costruite a mano: **totale** dal saldo di oggi, giornata da −10%: muro 10% se sup > 0,35 / 0,948 = **36,92%**; **giornaliero** da 80.000: muro 5% se sup > **25%**; k=2 dimezza | fermata sotto, muro sopra | sup 36,42% → fermata 100%, 37,42% → **muro 10% 100%**; 24% → fermata, 26% → **muro 5% 100%**; 13% x 2 → muro 5% 100% | ✅ |
| Z6 | i blocchi **vedono** il grappolo quando c'e': calendario ORDINATO (perdite in fila), fine entro 5 giorni | blocchi 10 >> L=1 | **26,4% contro 17,3%** | ✅ |
| Z6' | e **non lo fabbricano** quando non c'e': media su **40** calendari mescolati a caso di (blocchi 10 − L=1) | ~0 | **+0,69 punti di PASS** (dev. st. 4,26) | ✅ |
| Z7 | settimane: 53, le 5 peggiori a peso 3 → quota pescata attesa 23,81% | ±0,5 | **23,59%**; ogni giornata in una sola settimana | ✅ |

🧪 **Il contro-esempio che ha fallito in prima stesura, corretto PRIMA di consegnare**: Z6' usava **un solo**
calendario mescolato con tolleranza 2 punti, e dava **+4,5** punti di fermata → FAIL. Non era un difetto del
campionatore: **un** ordinamento a caso ha la sua autocorrelazione per caso, e i blocchi la riproducono fedelmente.
Misurata sui 40 ordinamenti, quella **nube** ha deviazione standard **3,0** (L=5) e **4,3** (L=10) punti di PASS. 👉
**E' diventata una misura** (§6): il calendario vero si legge **contro quella nube**, non contro lo zero.
🔴 **Da dire in chiaro: il criterio di Z6' e' stato cambiato DOPO averne visto l'esito** (da "un calendario, tolleranza 2"
a "media di 40, |media| < 2"), e la metrica e' passata dalla fermata al PASS (qui equivalenti: il muro e' 0). Per
questo Z6' e' uno **strumento tarato**, non una prova indipendente: dice che il campionatore non fabbrica grappoli
**in media**, e la nube di §6 va letta come la sua scala, non come un verdetto passato al primo colpo (classe 900).

---

## 3. 📍 Lo stato di partenza e la differenza col 27/09

| | referto 27/09 | **oggi 28/09** | fonte |
|---|---:|---:|---|
| saldo | 75.090,72 | **75.841,54** | `NOTTE_2026-09-28.md`: +750,82 netto del trade del weekend `771531`, incrociato col Guardian `eq=75841.54` |
| DD sul 80.000 | 6,14% | **5,20%** | |
| distanza dall'emergenza 72.560 | 2.530,72 | **3.281,54** (< 3.600 del taglio: il **primo giorno** scatta prima il totale) | |
| giorni di trading ancora da fare | 1 | 1 | se il 28/09 conti gia' come giorno FTMO e' [NON VERIFICATO]; con 0 il PASS cambia di **+0,0** punti (misurato) |
| **base: PASS** | **55,1** (55,0 / 54,4 / 55,2) | **62,4** (62,7 / 61,9 / 62,7) | stessa macchina, stesso seme: la differenza e' **solo** il saldo |
| base: fermata Guardian | 44,9 | **37,6** | |
| base: fine entro 5 giorni | 25,4 | **17,6** | |
| base: giorni mediani al PASS / alla fine | 21 / 5 | **20 / 6** | |

Il v2 prende lo stato da `st.S_OGGI` (costante della v1, saldo del 25/09 sera). Lo script nuovo **non** lo cambia:
passa `saldo_iniziale` esplicito al proprio simulatore (75.090,72 per il contro-esempio, 75.841,54 per le tabelle).

---

## 4. 🎲 LA TABELLA — base B (4 sedie + 770105), taglia indici 2,00%, Guardian 4,5 / 9,3, seme 11, 20.000 sim (±0,35)

"MURO" = muro giornaliero 5% + muro totale 10% di FTMO (conto **violato**). "FERM" = fermata del Guardian (conto fermo,
**non** violato). Banda = semi 12 / 13 / 14. Righe (a) e (b): campionamento come la base (senza reimmissione).
Righe (c) e INSIEME: **con** reimmissione (a blocchi), il loro riferimento a disegno neutro e' **L=1 = 61,5**.

| riga | **P(PASS)** | **P(fermata)** | P(muro 5% gg) | P(muro 10%) | **P(MURO)** | fine ≤ 5 gg | gg mediani PASS / fine | semi 12/13/14: PASS · FERM · MURO | Δ PASS |
|---|---:|---:|---:|---:|---:|---:|---:|---|---:|
| **BASE 27/09** (contro-esempio: = v2) | **55,1** | 44,9 | 0,0 | 0,0 | 0,0 | 25,4 | 21 / 5 | 55,0/54,4/55,2 · 45,0/45,6/44,8 · 0/0/0 | |
| **BASE 28/09** | **62,4** | 37,6 | 0,0 | 0,0 | **0,0** | 17,6 | 20 / 6 | 62,7/61,9/62,7 · 37,3/38,1/37,3 · 0/0/0 | — |
| (a) sup 10% x 1 posizione | 61,8 | 38,2 | 0,0 | 0,0 | **0,0** | 17,9 | 20 / 6 | 62,0/61,3/62,1 · 38,0/38,7/37,9 · 0/0/0 | −0,6 |
| (a) sup 25% x 1 | 45,2 | 35,9 | 18,8 | 0,0 | **18,8** | 19,5 | 17 / 8 | 45,4/44,6/45,7 · 35,6/36,3/35,5 · 19,0/19,1/18,7 | −17,1 |
| (a) sup 50% x 1 | 41,2 | 0,0 | 34,4 | 24,4 | **58,8** | 22,6 | 16 / 7 | 41,5/40,7/41,7 · 0/0/0 · 58,5/59,3/58,3 | −21,2 |
| (a) sup 10% x 2 | 61,4 | 38,6 | 0,0 | 0,0 | **0,0** | 18,1 | 20 / 6 | 61,3/60,6/61,6 · 38,7/39,4/38,4 · 0/0/0 | −1,0 |
| (a) sup 25% x 2 | 41,2 | 0,0 | 34,4 | 24,4 | **58,8** | 22,6 | 16 / 7 | 41,5/40,7/41,7 · 0/0/0 · 58,5/59,3/58,3 | −21,2 |
| (a) sup 50% x 2 | 41,2 | 0,0 | 38,1 | 20,7 | **58,8** | 22,6 | 16 / 7 | 41,5/40,7/41,7 · 0/0/0 · 58,5/59,3/58,3 | −21,2 |
| (b) spread x1,5 | 58,2 | 41,8 | 0,0 | 0,0 | 0,0 | 19,0 | 21 / 6 | 58,1/57,5/58,2 · 41,9/42,5/41,8 · 0/0/0 | −4,2 |
| (b) spread x2 | 53,2 | 46,8 | 0,0 | 0,0 | 0,0 | 20,7 | 22 / 7 | 53,3/52,4/53,2 · 46,7/47,6/46,8 · 0/0/0 | −9,2 |
| (b) ingresso +1 punto | 58,3 | 41,7 | 0,0 | 0,0 | 0,0 | 19,0 | 21 / 6 | 58,1/57,6/58,3 · 41,9/42,4/41,7 · 0/0/0 | −4,1 |
| (b) ingresso +3 punti | 48,3 | 51,7 | 0,0 | 0,0 | 0,0 | 22,0 | 23 / 7 | 48,6/47,6/48,5 · 51,4/52,4/51,5 · 0/0/0 | −14,1 |
| (b) spread x2 + ingresso +1 | 48,0 | 52,0 | 0,0 | 0,0 | 0,0 | 22,1 | 23 / 7 | 48,3/47,4/48,3 · 51,7/52,6/51,7 · 0/0/0 | −14,4 |
| (c) IID giornate, L=1 *(riferimento neutro)* | 61,5 | 38,5 | 0,0 | 0,0 | 0,0 | 17,2 | 20 / 6 | 61,3/61,5/61,2 · 38,7/38,5/38,8 · 0/0/0 | −0,9 |
| (c) blocchi 5 giornate | 62,0 | 38,0 | 0,0 | 0,0 | 0,0 | 18,6 | 20 / 6 | 61,8/62,1/62,1 · 38,2/37,9/37,9 · 0/0/0 | −0,3 |
| (c) blocchi 10 giornate | 66,7 | 33,3 | 0,0 | 0,0 | 0,0 | 18,9 | 23 / 5 | 67,4/67,1/67,5 · 32,6/32,9/32,5 · 0/0/0 | +4,3 |
| (c) settimane intere, peso 1 | 62,7 | 37,3 | 0,0 | 0,0 | 0,0 | 15,5 | 21 / 7 | 63,0/63,2/63,3 · 37,0/36,8/36,7 · 0/0/0 | +0,3 |
| (c) **settimane, 5 peggiori x3** | **38,9** | **61,1** | 0,0 | 0,0 | 0,0 | 23,2 | 20 / 7 | 39,1/39,6/39,4 · 60,9/60,4/60,6 · 0/0/0 | **−23,5** |
| **I1 moderato** | **31,8** | 43,6 | 24,7 | 0,0 | **24,7** | 26,6 | 18 / 8 | 32,2/32,4/32,5 · 43,3/43,2/43,2 · 24,5/24,4/24,3 | −30,6 |
| **I2 severo** | **18,4** | 0,0 | 51,5 | 30,1 | **81,6** | 33,6 | 19 / 8 | 17,7/18,2/17,9 · 0/0/0 · 82,3/81,8/82,1 | −44,0 |
| **I3 severo + settimane peggiori** | **9,5** | 0,0 | 56,6 | 33,9 | **90,5** | 45,2 | 15 / 6 | 8,7/8,9/8,9 · 0/0/0 · 91,3/91,1/91,1 | −52,9 |

**Come si legge**
- 🔎 **sup x k e' l'unica cosa che conta in (a)**: "25% x 2" coincide **al decimale** con "50% x 1" (stesso
  generatore, stesso prodotto 0,50): e' un controllo di coerenza gratuito, ed e' tornato.
- 🔴 **Il salto fra 10% e 25% non e' graduale**: e' la soglia del cuscinetto giornaliero (§5) che viene attraversata.
  Sotto soglia il superamento costa solo qualche decimo di PASS (il saldo scende un po' a ogni taglio); sopra, **ogni**
  giornata tagliata diventa una violazione.
- 💸 **(b) non tocca mai il muro** (il Guardian regge, a sup 0): sposta PASS in fermata. **Tre centesimi di R per
  posizione valgono ~9 punti**: e' la misura di quanto e' sottile il margine delle sedie modellate.
- 🧩 **(c) si confronta con L=1 (61,5), non con la base**: la differenza base → L=1 (−0,9) e' **disegno**
  (reimmissione), come il contro-esempio i' del 27/09.
- 🧨 **INSIEME**: nelle righe I2 e I3 la fermata vale 0,0 perche' **ogni** fermata e' diventata una violazione
  (sup x k = 1,00, oltre la soglia del 10% totale).

---

## 5. 🎯 LA MISURA CHIESTA: quale superamento accende il muro FTMO, e di quanto

**A mano** (Z5 lo verifica): con taglio giornaliero a 4,5% e muro FTMO a 5% del banco (differenza **0,005** = 400 EUR)
e emergenza a 72.560 contro muro a 72.000 (differenza **0,007** = 560 EUR), e uno stop = 0,02 x b0 del banco
(b0 = saldo d'inizio giornata / 80.000):

| cuscinetto | EUR | superamento che lo buca, **k = 1** | **k = 2** |
|---|---:|---:|---:|
| giornaliero (taglio 4,5% → muro 5%) | **400** | sup > 0,25 / b0 = **26,4%** oggi (22,7% a saldo 88.000, 25,0% a 80.000) | **13,2%** oggi |
| totale (emergenza 9,3% → muro 10%) | **560** | sup > 0,35 / b0 = **36,9%** oggi (36,8% al limite 0,952 in cui il totale scatta prima del taglio) | **18,5%** oggi |

**Nel MC** (base 28/09, seme 11, 20.000 sim, passo 2,5%; tabella completa stampata dallo script):

| sup x k (quota di UNO stop) | 0-22,5% | **25%** | 27,5-35% | **37,5%** | ≥ **40%** |
|---|---:|---:|---:|---:|---:|
| P(PASS) | 62,4 → 61,2 | **45,2** | 41,2 | 41,2 | 41,2 |
| P(fermata Guardian) | 37,6 → 38,8 | 35,9 | 28,6 → 28,1 | 18,3 | **0,0** |
| P(muro 5% giornaliero) | **0,00** | **18,84** | 30,2 → 30,7 | 30,9 | 31,1 → 34,8 |
| P(muro 10% totale) | **0,00** | 0,00 | 0,00 | **9,63** | 27,8 → 24,0 |
| **P(MURO)** | **0,00** | **18,84** | 30,2 → 30,7 | 40,5 | **58,83** |

- 👉 **k = 1**: primo gradino con P(muro) > 0 = **25,0%** (a 22,5% ancora zero; la soglia a mano, 22,7% al saldo
  massimo, cade in mezzo) → **P(muro) 18,8%**. **k = 2**: primo gradino **12,5%** → 18,8%; a 15% **30,3%**; a 20%
  **58,8%**.
- 🔎 **Perche' tanto**: nel calendario B ci sono **7 giornate su 262** con perdita oltre il taglio del 4,5% (tutte con
  **3-4 sedie in stop lo stesso giorno**: 15/10/2025 −7,9% del banco a b0 di oggi con 4 sedie; 02/12, 16/12, 23/01,
  06/02, 19/02, 26/02: −5,6 / −6,4%). In una corsa di 20-60 giornate la probabilita' di pescarne almeno una e'
  alta: sono **quelle** giornate che il cuscinetto giornaliero deve reggere. In quelle giornate chiudono **3-7
  posizioni**, quindi alla chiusura del Guardian **k = 2 e' plausibile, non estremo** `[INFERITO: l'ora d'ingresso
  non c'e', la sovrapposizione non si misura]`.
- 📏 **Contro il misurato**: il peggior scivolamento FTMO finora (22/09, 156,68 EUR su due posizioni) e' **9,9%** di
  uno stop combinato = **39%** del cuscinetto giornaliero. **Il MC dice che a quel livello il muro resta 0,0.** Il
  margine fra il peggior misurato (9,9%) e la soglia (26,4% con k=1, 13,2% con k=2) e' **x2,7** con una posizione e
  **x1,3** con due. Con **n = 3** e zero chiusure del Guardian, quel margine **non e' dimostrato**: e' un rapporto fra
  un aneddoto e una soglia.

---

## 6. 🧩 I grappoli: il calendario vero contro il rumore d'ordinamento

| L | nube dei 40 calendari mescolati: dPASS (blocchi − L=1) | calendario VERO | posizione |
|---:|---|---:|---|
| 5 | media **+0,55**, dev. st. **2,97**, da −4,30 a +8,02 | **+0,44** | sopra 19 dei 40 |
| 10 | media **+0,69**, dev. st. **4,26**, da −6,52 a +11,10 | **+5,54** | sopra 34 dei 40 (~1,1 dev. st.) |

- 🟢 **In questo anno di dati le perdite NON si raggruppano in giornate consecutive piu' di un ordine a caso**: a
  L=5 il calendario vero sta nel mezzo della nube; a L=10 e' **sul lato favorevole** (le giornate buone si
  raggruppano un po'), ma dentro la dispersione. Il modello a blocchi di un giorno del v2 **non** e' ottimista sul
  grappolo, **in questo campione**.
- 🔴 **E' un campione di un anno solo (toro 2025-26)**: il grappolo vero di un crollo di regime (2020) qui non c'e',
  e un ricampionamento non lo fabbrica. Per questo esiste lo scenario avverso: le **5 settimane peggiori** (08-12/12/2025
  **−10,0%** del saldo a 2%; 30/03-03/04/2026 −7,7%; 13-17/10/2025 −6,8%; 15-19/12/2025 −6,7%; 02-06/02/2026 −5,0%)
  **a peso 3** tolgono **22,6 punti** di PASS contro L=1 (semi: −22,6 / −22,2 / −21,9 / −21,8), tutti in fermata, muro 0.
  Da notare: **la sola settimana dell'8-12 dicembre, ripetuta oggi, supera da sola i 4,1 punti** che separano il saldo
  dall'emergenza del Guardian.

---

## 7. 🚧 Le ipotesi NON misurate, per nome

1. 🔴 **Superamento alla chiusura del Guardian** `[NON MISURATO]`: il Guardian in campo non ha mai chiuso niente. I
   valori 10/25/50% vengono dallo scivolamento degli **stop** (FTMO n=3, tester D30EUR n=551, NASUSD n=87), che e'
   un'**altra** esecuzione (ordine lato server, non chiusura a mercato da EA).
2. 🔴 **Posizioni aperte al momento della chiusura (k)** `[NON MISURATO]`: il per-trade non ha l'ora d'ingresso;
   k = 1 e k = 2 sono i due casi dichiarati (2 = cap C1 4,00 a 2,00%; con un pendente oltre il cap, classe 645, possono
   essere 3).
3. 🔴 **Gap d'apertura** `[NON MISURATO su FTMO]`: la `771531` tiene posizioni la notte e il weekend. Fuori sessione il
   tester D30EUR arriva a **294,4** punti oltre lo stop (4 stop DAX): un gap del genere e' **fuori scala** rispetto a
   tutte le righe di questo referto, e nessuna soglia del Guardian lo intercetta (`PROPOSTA_GUARDIAN_FTMO_2026-08-27.md`
   §4.4, rischio residuo accettato).
4. 🔴 **Latenza del Guardian** `[NON MISURATA]`: controllo dell'equity una volta al secondo e tempo per chiudere 2
   posizioni; e' dentro "sup", non separata.
5. 🟠 **Il Guardian del modello e' quello del v2**: taglio sul **realizzato** di fine giornata (l'equity intraday non
   c'e': sottostima), **pausa 3,5% e cap C1 non rimodellati** (sovrastima delle 7 giornate oltre il taglio: in campo
   dopo due stop la pausa blocca i nuovi ingressi). Il verso netto sulla frequenza dei tagli e' **ignoto**.
6. 🟠 **Spread all'ora d'ingresso della `771531`** `[NON MISURATO]`: la sedia entra a tutte le ore; lo spread usato
   (3,00 US30) e' quello dell'apertura BCM. Di notte il GER40 FTMO costa **2,5 volte** l'apertura: su US30 notturno
   FTMO nessuna misura.
7. 🟠 **Slittamento d'ingresso**: **n = 1** (+0,70 punti, BCM reale). Gli ingressi a LIMITE (retest, coppia serale
   `771531`) non scivolano contro: applicarlo a tutte le posizioni e' pessimista.
8. 🟠 **Cambio EUR/USD** sulle sedie Dow: deriva misurata **+0,67%** in due ore sul primo stop (`PRIMO_STOP` §2B), non
   modellata.
9. 🟠 **Ereditate dal v2**: un solo regime (toro 2025-26); **770260, 770511, 770212 non modellate**; 770105 a ora fissa
   BCM; scala x2 dalla misura a 1% (classe 321); oro fuori dalla base.
10. 🟠 **Il 28/09 e' gia' iniziato**: il riferimento giornaliero FTMO del 28/09 e' il valore della mezzanotte, non il
    saldo simulato; e se il 28/09 conti come giorno di trading e' `[NON VERIFICATO]` (sensibilita' misurata: +0,0).

**Cosa questo stress NON copre**: requote, rifiuti d'ordine, disconnessioni, VPS fermo, l'esecuzione vera di FTMO
sotto stress, e tutto il punto 4 di Emiliano (failure injection del Guardian), che e' un altro lavoro.

---

## 8. ✅ Cosa e' andato bene

- 🥇 **La macchina nuova e' la vecchia piu' tre agganci**: a perturbazione zero **bit per bit** la v1 e il v2 su
  cinque configurazioni, e il 55,1 del 27/09 rifatto al decimale su quattro semi.
- 🟢 **Il saldo di oggi e' migliore di quello del referto**: +750,82 EUR valgono **+7,3 punti** di PASS e **−7,8
  punti** di fine entro 5 giorni.
- 🟢 **Il "clustering" di Emiliano e' stato misurato, non discusso**: sulle giornate vere non c'e' grappolo oltre il
  caso; il timore resta vero **fuori** dal campione (regime), e ha la sua riga avversa.
- 🎯 **La domanda "quanto oltre?" ha un numero**: 400 EUR di cuscinetto giornaliero = **26,4% di uno stop** (13,2% con
  due posizioni), contro un peggiore misurato di 9,9%. E' la misura che serve a Claudio per giudicare il punto 1 di
  Emiliano. **La decisione su soglie e taglie resta sua.**
- 🧪 **Un contro-esempio ha fallito ed e' stato capito prima di consegnare**: il rumore d'ordinamento (§2, §6).

**Nessuna proposta di taglia, di cap o di soglia del Guardian.**

---

## 📎 Riproducibilita'

```text
python3 backtest_pipeline/mc_stress_congiunto.py --autotest    # 26 controlli, esce 0 se verde, ~50 s
python3 backtest_pipeline/mc_stress_congiunto.py               # tutte le tabelle di questo referto, ~3 min 20 s
python3 backtest_pipeline/mc_stress_congiunto.py --solo-base   # solo le due righe base (27/09 e 28/09)
```
