# 🎲 MC della challenge FTMO rifatto DALLO STATO DI OGGI — 25/09/2026

**Conto**: FTMO **`541452707`** (`C:\FTMO`), 2-Step fase 1, 80.000 EUR. **Sola lettura**: nessun EA,
preset o conto toccato.
**Domanda**: dopo il terzo stop (`770101` DAX, −1.552,80), quanto vale la challenge **da qui**,
con la taglia in campo e con le altre taglie già firmate in casa?
**Strumento**: `backtest_pipeline/mc_challenge_ftmo_stato.py` (nuovo). **Importa**
`mc_challenge_ftmo.py` e `mc_challenge_ftmo_allineati.py` senza modificarli.
Si rifà con `python3 backtest_pipeline/mc_challenge_ftmo_stato.py` (~50 s) · controlli:
`--autotest` (~10 s, tutto verde).

> 🔴 **Taglie, cap e Guardian sono firme di Claudio. Qui ci sono SOLO numeri: nessuna proposta.**

---

## 0. 📌 In quattro righe

1. ✅ **La macchina è sana**: i numeri del 23/09, del 24/09 e del referto sui mesi allineati si
   riproducono **al decimale** dal loro stato di partenza, prima di cambiare qualsiasi cosa (§1).
2. 🔴 **Il Guardian in campo NON è quello del 4,9 / 9,9 / 4,0**: il `.chr` letto stanotte da
   `CODA_08` dice **4,5 / 9,3 / 3,5 / cap 4,00**. L'emergenza totale scatta a **72.560 EUR**, cioè
   **2.530,72 EUR** sotto il saldo di oggi: a 2,00% vuol dire **due stop pieni di fila** (§2).
3. 🎲 **Dallo stato di oggi, a 2,00%, col Guardian di campo: PASS 57,2%** (semi 12-14:
   56,7-57,4). Il resto (**42,8%**) è la **fermata del Guardian al 9,3%**, e metà di quelle
   fermate arriva **entro 5 giornate**: **P(fine corsa nei prossimi 5 giorni di borsa) = 21-24%** (§4).
4. ⚠️ **Il cap 3,25 NON blocca la seconda posizione a 2%**: nel codice il cap non è
   prospettico, quindi **a 2,00% il 3,25 e il 4,00 lasciano entrare entrambi due posizioni** e
   bloccano l'INVIO di un terzo ordine, non un pendente già piazzato: nessuno dei due è un tetto al rischio simultaneo, è una guardia sull'aggiunta (classe 645). Lo scenario (b) come era stato descritto **non esiste nel codice** (§3).

---

## 1. ✅ Riproduzione PRIMA di tutto (il contro-esempio)

Prima di toccare lo stato di partenza ho rilanciato gli strumenti vecchi **così come sono**:

| referto | stato di partenza | numeri pubblicati | rilanciati oggi |
|---|---:|---|---|
| `IL_PIANO_DEGLI_OTTO_GIORNI` (23/09) | 78.242,32 | 70,3 · **84,0** · 78,4 · 96,6 · pess. 67,8 / 69,0 | ✅ **identici** |
| `SECONDO_STOP_FTMO` (24/09) | 76.573,86 | 61,8 · **74,6** · 68,4 · 91,3 · pess. 57,6 / 57,2 | ✅ **identici** |
| `MC_MESI_ALLINEATI` (24/09) | 76.573,86 | V0 74,6 · **V1 70,8** · V2 81,3 · V3 83,2 | ✅ **identici** |

Poi il simulatore nuovo (`simula_stato`), **con i ganci nuovi spenti**, contro il vecchio
`m.simula`: **stessi esiti al bit e stessa mediana** in quattro configurazioni (74,6000% ·
83,9950% · 61,8400% · 68,4100%), e la V1 ricostruita qui contro `simula_mix`: **70,7600% =
70,7600%**, 103 giornate sostituite. Lo script **si ferma** se non è così.

🧪 **Il contro-esempio per il gancio nuovo** (l'emergenza totale del Guardian): una rovina del
giocatore con aritmetica esatta (passi da 1/64, partenza 60/64). Col Guardian a 9,3% il muro è
a 2 passi → **P(PASS) = 2/13 = 15,38%**; col solo muro FTMO del 10% è a 3 passi → **3/14 =
21,43%**. Il simulatore dà **15,35%** e **21,33%**: se il Guardian fosse codificato come il muro
statico, il primo test darebbe 21,4 e **fallirebbe**. Stesso trattamento per la giornata da −6%
(col Guardian → fermata al giorno 1; senza → morte giornaliera al giorno 1), per la pausa e per
il taglio delle sedie: tutti verdi.

🔎 **E il test ha trovato una proprietà del modello di casa che va scritta**: `m.simula` pesca le
giornate **senza reimmissione, a blocchi di un anno** (rimescola le 242 e le consuma tutte prima di
rimescolare). Ogni blocco da 242 somma quindi **esattamente** il +108,4% dell'anno. Non è un
errore, ma è una scelta: la riga "con reimmissione (iid)" in §5 ne misura il peso (**−0,7 punti**
a 2,00%).

---

## 2. 🧾 Lo stato di partenza, ricontato

| voce | valore | fonte |
|---|---:|---|
| saldo a inizio 25/09 | **76.643,52** | riga Guardian del 24/09 23:55 (`eq=76643.52 totDD=4.20%`), `CODA_09` del 25/09 |
| stop del 25/09 (`770101`) | −1.552,80 | `TERZO_STOP_FTMO_2026-09-25.md` §1 |
| scarto fra il 76.573,86 del 24/09 e il 76.643,52 | **+69,66** | [DERIVATO, non ricontato dal deal]: la 770101 del 24/09 (#170199888, BUY LIMIT retest 10,70 lotti, CODA_09 25/09) chiusa in positivo |
| **saldo di partenza** | **75.090,72** = **0,938634** del 80.000 | ✅ torna con il referto |
| DD totale statico | **6,14%** | ✅ torna |
| target fase 1 (+10% = 88.000) | mancano **12.909,28** = **+17,19%** dal saldo | |
| giorni di trading fatti | **3** (22/09, 24/09, 25/09 — il 23/09 nessuna posizione, `CODA_09`) | minimo FTMO 4 → ne manca **1** |
| muri FTMO | statico **72.000** (10%) · giornaliero **4.000** (5% del iniziale, reset 00:00 CE(S)T) · **nessun limite di tempo** | `docs/REGOLAMENTO_FTMO_2026-09-20.md` §③ |
| **sedie in campo** | `770101` · `770202` · `770260` · `771531` · `770511` · `770411`, **tutte a rischio 2.0** | `CODA_01` del 25/09, sezione `C:\FTMO` |

**Si parte dall'apertura del prossimo giorno di borsa** (lunedì **28/09**): il −1.552,80 di oggi
pesa sul giornaliero di **oggi** e nel modello non entra. Assunto dichiarato: **nessuna posizione
aperta** al momento del via (le foto di stanotte sono delle 03:30, prima dello stop).

### 🔴 Il Guardian in campo — e perché il 4,9 / 9,9 / 4,0 non è quello giusto

`CODA_08` del 25/09, `C:\FTMO`, `CLAU12_Guardian` magic `779001`, `.chr` modificato il **24/09 08:06**:

```text
InpStartBalance=80000  InpDailyLossPct=4.5  InpTotalDDPct=9.3  InpDDMode=0
InpDailyPausePct=3.5   InpMaxOpenRiskPct=4.00  InpAction=0 (CHIUDI+BLOCCA)
```

È lo stesso di `mql5/Presets/ABTG_Guardian_FTMO_2Step.set` (firme del 20/09 *«si 80000»* e *«si
cuscino»*). Il 4,9 / 9,9 / 4,0 viene da `DD_PORTAFOGLIO_FTMO_2026-09-20.md` §5, scritto **prima**
di quelle due firme (e su `InpStartBalance=100000`).

| | con **9,9%** (vecchio) | con **9,3%** (in campo) |
|---|---:|---:|
| emergenza totale | 72.080 | **72.560** |
| margine dal saldo di oggi | 3.010,72 | 🔴 **2.530,72** |

🔴 **Conseguenza su `TERZO_STOP_FTMO_2026-09-25.md` §2-§3** (non l'ho modificato: lo segnalo): la
riga *«margine dall'emergenza Guardian 9,9% (72.080) 3.010,72»* va letta con il 9,3%, e la riga
*«Due di fila: saldo ~72.117, 37 EUR sopra l'emergenza»* si capovolge: **72.117 è 443 EUR SOTTO
72.560**, quindi **il secondo stop pieno di fila fa scattare il Guardian**. Quando scatta, il
codice (`ABTG_Guardian.mq5` r.752-757; righe del sorgente a HEAD; in campo gira la v1.12, CODA_06 25/09 r.212: stessa logica alle r.410/423/436/444 di d884f7e1) chiude tutto e scrive **«CHALLENGE FERMATA»**
(`GV_FAILED`). Il blocco NON scade: il codice non azzera mai GV_FAILED, ripete FlattenAll a ogni secondo (r.771-773; v1.12 in campo r.423) e rinnova a ogni giro la scadenza di 30 giorni della pausa (r.781; v1.12 r.436). Si riparte solo cancellando a mano ABTG_GUARD_541452707_FAILED. Il conto **non è violato**, ma la corsa **finisce**. Nel modello
è un esito a sé, `FERMATA GUARDIAN`.

**Stop pieni consecutivi che portano a ≤ 72.560** (taglia in % del saldo, composta):

| taglia | senza slittamento | slittamento misurato ×1,048 | ×1,105 |
|---|---:|---:|---:|
| **2,00%** | **2** (dopo il 1°: 73.588,91) | 2 | 2 |
| 1,00% | 4 (dopo il 3°: 72.860,45) | 4 | 4 |
| 0,65% | 6 (dopo il 5°: 72.681,79) | 6 (dopo il 5°: **72.567,93**, 8 EUR sopra) | **5** |

---

## 3. 🔬 Il cap C1, letto nel CODICE — lo scenario (b) come era descritto non esiste

- `ABTG_Guardian.mq5` r.789: il flag del cap si accende se `riskPct >= InpMaxOpenRiskPct`, con
  `riskPct` = somma ingresso→SL delle posizioni **aperte** (`OpenRiskPct`, r.385-413), in % dell'equity.
- `ABTG_PausaGuardian.mqh` `ABTG_MotivoStop_Calc()` r.357-367: l'EA rifiuta l'ingresso **se il flag è
  acceso**. **Non c'è nessun controllo prospettico** (*"rischio aperto + il mio > cap"*).

Quindi, con sedie a 2,00%:

| cap | 0 posizioni | 1 aperta (2,0%) | 2 aperte (~4,0%) |
|---|---|---|---|
| **4,00** (in campo) | entra | 2,0 < 4,00 → **entra la 2ª** | ≥ 4,00 → blocca l'INVIO di un 3° ordine (stessa riserva sui pendenti) *(solo se la somma arriva a 4,00: con gli arrotondamenti del lotto può fermarsi a 3,99 e lasciar entrare la 3ª)* |
| **3,25** (firmato 18/08) | entra | 2,0 < 3,25 → 🔴 **entra la 2ª** | ≥ 3,25 → blocca l'INVIO di un 3° ordine; un pendente piazzato quando il cap era libero scatta lo stesso (ABTG_PausaGuardian.mqh r.49-51, classe 645: le sei sedie FTMO entrano tutte per pendente, CODA_08 25/09) |

🔴 Il commento del preset (*«3.25 … lasciava passare UNA SOLA posizione»*) e la descrizione dello
scenario (b) (*«blocca una seconda posizione da 2%»*) **non corrispondono al codice**. A 2,00% la
sola differenza fra 3,25 e 4,00 è il **bordo della terza posizione** quando due lotti arrotondati
sommano meno di 4,00%. Il valore del cap resta una firma di Claudio: qui c'è solo cosa fa il codice.

**E nel modello a giornate il cap non si può misurare**: il per-trade dei backtest ha solo l'ora di
**chiusura**, non quella d'ingresso, quindi la sovrapposizione non si vede. Ci sono **due limiti
estremi** (tutte le operazioni della giornata considerate sovrapposte, ordine = prima chiusura):
- **"max 2 sedie/giornata"**: il morso massimo di un cap a due posizioni (vale per 3,25 **e** 4,00);
- **"1 sedia/giornata"**: la lettura *"una alla volta"* del commento del preset (**non è il codice**).
Le giornate con ≥3 sedie sono **25 su 242**, con ≥2 sono 137.
Il limite "max 2 sedie/giornata" è il morso MASSIMO del cap, non quello atteso: coi pendenti il cap morde meno.

---

## 4. 🎲 LA TABELLA — dallo stato di oggi, Guardian di campo (4,5 / 9,3)

Parametri comuni: 4 sedie su 6 (quelle con per-trade), 242 giornate con operazioni
(2025.06.10 → 2026.06.29, tick reali), seme **11**, **20.000** simulazioni (errore ±0,35 punti),
minimo di 1 giorno di trading ancora da fare. "gg" = **giornate con operazioni**; la colonna
"feriali" usa il pool dei 277 feriali (35 a zero), dove una giornata = un giorno di borsa.

| scenario | taglia / cap | **P(PASS)** | **P(fermata Guardian 9,3%)** | P(muro FTMO 10%) | P(muro giorn. 5%) | gg mediani al PASS (feriali) | gg mediani alla fine (feriali) | **P(fine ≤ 5 giorni di borsa)** |
|---|---|---:|---:|---:|---:|---:|---:|---:|
| **(a) come in campo** | 2,00% · cap 4,00 | **57,2%** | **42,8%** | 0,0% | 0,0% | 22 (24) | 5 (5) | **21,4%** *(23,6% su 5 giornate)* |
| **(b) cap firmato** | 2,00% · cap 3,25 | **= (a)** nel modello (§3) | | | | | | |
| ↳ limite: max 2 sedie/giornata | 2,00% · 3,25 o 4,00 | 59,3% | 40,7% | 0,0% | 0,0% | 22 (25) | 5 (6) | 20,1% |
| ↳ limite: 1 sedia/giornata *(non è il codice)* | 2,00% | 49,3% | 50,7% | 0,0% | 0,0% | 37 (42) | 8 (9) | 17,5% |
| **(c)** *1,00%: taglia di preset demo BCM e tetto PROPOSTO il 19/09 (FIRME_2026-09-19_SERA.md r.71), NON firmato — solo riferimento, NESSUNA PROPOSTA* | **1,00%** · cap 3,25 | **75,3%** | **24,7%** | 0,0% | 0,0% | 58 (66) | 10 (12) | **5,0%** |
| **(c)** *0,65%: taglia firmata di casa (preset 100k 50504263 e REALE) — solo riferimento, NESSUNA PROPOSTA* | **0,65%** · cap 3,25 | **88,1%** | **11,9%** | 0,0% | 0,0% | 99 (113) | 16 (18) | **0,9%** |

- **Il muro FTMO (10% e 5%) vale 0,0% per costruzione** finché il Guardian lavora: il taglio del
  giornaliero a 4,5% e la fermata a 9,3% arrivano prima. Quanto costa se il Guardian **non** lavora
  è in §5 (riga "Guardian SPENTO").
- **(c) — il cap**: a 1,00% e 0,65% il cap delle case (3,25, preset del 100k `50504263` e del reale)
  lascia entrare 4 e 5 posizioni: con **4 sedie nel modello non morde mai**. Per (c) cambiano solo
  la taglia; il Guardian resta quello di campo (4,5 / 9,3 / 3,5).
- **P(PASS entro 5 giorni di borsa)**: 0,3% a 2,00%, 0,0% a 1,00% e 0,65%.
- **Stabilità al seme** (a): semi 12 / 13 / 14 → PASS 57,4 / 56,7 / 57,2 · fine ≤5 giornate 22,7 / 23,8 / 23,3.
- **I 5 giorni di borsa veri** sono lun 28/09 → ven 02/10: tutti **prima** del cambio d'ora (DAX
  26/10, USA 02/11), quindi con l'orario allineato.

---

## 5. 🧪 Sensibilità — che cosa sposta il numero

**Taglia 2,00%** (le stesse righe per 1,00% e 0,65% sono nell'uscita dello script):

| variante | PASS | fermata G 9,3 | muro 10% | muro 5% | P(fine ≤5 giornate) | Δ PASS su (a) |
|---|---:|---:|---:|---:|---:|---:|
| **(a) modello di campo** | **57,2** | 42,8 | 0 | 0 | 23,6 | — |
| + slittamento **misurato** sui 3 stop veri (×1,048) | 54,5 | 45,5 | 0 | 0 | 25,0 | −2,7 |
| + slittamento ×1,105 (lo scenario di casa) | 51,3 | 48,7 | 0 | 0 | 26,5 | −5,9 |
| + pausa 3,5% (approssimata, tocca 4 giornate) | 56,0 | 44,0 | 0 | 0 | 24,4 | −1,2 |
| V1: sedie a orario lette solo nei mesi allineati | 52,0 | 48,0 | 0 | 0 | 19,2 | −5,2 |
| pessimista di casa (5ª sedia correlata + ×1,157 + ×1,105) | 41,9 | 58,1 | 0 | 0 | 35,9 | −15,3 |
| campionamento CON reimmissione (iid) | 56,5 | 43,5 | 0 | 0 | 23,2 | −0,7 |
| Guardian totale non modellato (la semantica dei MC precedenti) | 62,4 | — | 37,6 | 0 | 18,3 | +5,2 |
| Guardian 4,9 / 9,9 (valori NON in campo) | 60,8 | 39,2 | 0 | 0 | 19,6 | +3,6 |
| 🔴 Guardian SPENTO (fail-open, buco B3) | 51,8 | — | **30,9** | **17,4** | 20,1 | −5,4 |

**Stessa tabella in breve per le altre due taglie** (*1,00%: preset demo BCM e tetto PROPOSTO il 19/09, NON firmato · 0,65%: taglia firmata di casa — solo riferimento, NESSUNA PROPOSTA*):

| variante | 1,00% PASS | 0,65% PASS |
|---|---:|---:|
| modello di campo | 75,3 | 88,1 |
| + slittamento ×1,048 / ×1,105 | 71,2 / 65,9 | 85,1 / 80,7 |
| V1 mesi allineati | 72,0 | 86,0 |
| pessimista di casa | 39,2 | 47,5 |
| Guardian SPENTO | 81,7 *(muro 10% 18,3, giornaliero 0)* | 92,4 *(muro 10% 7,6)* |

📏 **Il confronto con il 24/09, a semantica fissa**: il MC del 24/09 dava **74,6%** senza
modellare la fermata del Guardian. **Con** il 9,3% dallo stesso stato (76.573,86) viene **70,84%** (non è la V1 del 24/09, 70,76%: i due numeri coincidono solo per arrotondamento, come il −3,8; lo stampa lo script, riga «CONFRONTO COL 24/09»):
i MC precedenti erano **3,8 punti ottimisti** su questo punto. Da oggi, con la semantica vecchia,
si passa da 74,6% a **62,4%** (−12,2, lo stop di oggi). Con la semantica di campo si passa da 70,84% a
**57,2%** (−13,6).

---

## 6. 🚧 Limiti del modello — dichiarati

1. 🔴 **Correlazione fra sedie: 4 su 6.** `770260` (Nasdaq) e `770511` (SuperWave Dow) sono in
   campo ma **non hanno per-trade** in repo: fuori dal modello. Sono **correlate** alle presenti
   (stessa campana USA, terza sedia su `US30.cash`). Il numero è quindi un **pavimento del rischio**,
   non un tetto; la riga "pessimista" ne simula una con una copia di `770202`. Dentro le 4, la
   correlazione per giornata è **conservata** (si ricampionano giornate intere), ma fra giornate no.
2. 🔴 **Orologio / inverno.** Il pool contiene **un solo inverno** in cui le sedie a orario del
   backtest armavano un'ora prima dell'apertura; le sedie FTMO armano all'apertura tutto l'anno. La
   riga **V1** (−5,2 punti a 2%) è lo scenario "orologio colpevole", la (a) è "tutto è stagione":
   **nessuno dei due è misurato come vero** (`MC_MESI_ALLINEATI_2026-09-24.md` §5).
3. 🔴 **Slittamento.** Oggi **0,65 punti = +0,84%** sulla perdita voluta; i tre stop veri della
   challenge sommano **4.978,94 EUR** reali contro **4.751,26** allo SL = **×1,048** (22/09 +10,5%
   con il cambio, 24/09 +2,9%, 25/09 +0,84%). **n = 3**: non è un tasso. Nel modello lo
   slittamento moltiplica le **giornate** in perdita, non il singolo stop. 🔴 **Lo slittamento della
   chiusura d'emergenza del Guardian contro il cuscino di 560 EUR (72.560 → 72.000) è `[NON
   MISURATO]`**: è l'unica strada per cui il muro FTMO del 10% può diventare > 0 col Guardian vivo.
4. 🔴 **P/L realizzato, non equity.** Il 5% FTMO e il Guardian leggono l'**equity**: una
   giornata che scende sotto 72.560 e poi risale **non** è vista dal modello → la fermata del
   Guardian è **sottostimata**. Scarto misurato sul DAX: −15,7% (DD_PORTAFOGLIO_FTMO_2026-09-20.md r.125: 6,25% contro 7,2328% del tester a tick).
5. 🟠 **Il cap e la pausa sono approssimati**: senza l'ora d'ingresso il cap ha solo due limiti
   estremi (§3), e la pausa 3,5% toglie le operazioni che **chiudono** dopo la soglia (anche quelle
   aperte prima, che in campo resterebbero).
6. 🟠 **Scala ×2 dalla misura a 1,00%** (misurata ×1,956-1,990): a 2,00% il modello **sovrastima**
   leggermente il DD. **×0,65** idem in proporzione.
7. 🟠 **Un solo regime** (toro 2025-26). Nessun rimescolamento fabbrica un 2020.
8. 🟠 **La fermata del Guardian è trattata come fine della corsa.** Nel codice lo è
   (`GV_FAILED`, blocco senza scadenza finché la GV non si cancella a mano); ripartire a mano da 72.560 con 560 EUR di spazio non è
   modellato.
9. 🔴 **Cambio di taglia a metà challenge: non modellato e non verificato.** Le Forbidden Practices valgono anche in Challenge (docs/REGOLAMENTO_FTMO_2026-09-20.md §④). Il testo letto il 20/09 nomina «substantially larger position sizes compared to your other simulated trades»; la lettura di casa del 19/09 (FIRME_2026-09-19_SERA.md r.71-73) dice «alzare e poi abbassare è una pratica proibita». Se passare da 2,00% a 1,00%/0,65% sia ammesso è [NON VERIFICATO] con FTMO: le righe (c) misurano il conto, non la regola.

---

## 7. ✅ Cosa è andato bene

- 🥇 **Tre MC di casa riprodotti al decimale** dal loro stato: la macchina su cui si decide è la
  stessa di ieri, e adesso ha un **autotest** che lo dimostra da solo (17 controlli, tutti verdi).
- 🔎 **Due fatti trovati andando a leggere invece di assumere**: il Guardian in campo (9,3%, non
  9,9%) e il cap che **non è prospettico**. Tutti e due cambiano come si leggono i numeri di oggi,
  e sono stati trovati **prima** di consegnare, non dopo.
- 🟢 **I tre stop sono stati eseguiti come da contratto**: taglia ~2,0%, stop sul server,
  slittamento medio misurato ×1,048, cioè **sotto** lo scenario ×1,105 che i MC portano da una settimana.
- 🟢 **FTMO non ha limite di tempo**, e in nessuna riga il muro FTMO viene toccato finché il Guardian
  lavora: il rischio vero è la **fermata del Guardian**, che è un conto fermo, **non** un conto violato.

**Nessuna proposta di taglia, di cap o di Guardian**: i numeri sono per la decisione di Claudio.

---

## 📎 Riproducibilità

```text
python3 backtest_pipeline/mc_challenge_ftmo_stato.py --autotest   # 17 controlli, esce 0 se verde
python3 backtest_pipeline/mc_challenge_ftmo_stato.py              # tabelle di §2, §4, §5
```
