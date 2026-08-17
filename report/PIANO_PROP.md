# 🏛️ PIANO PROP — la tabella madre dei parametri per passare una prop

_Prodotto dall'**architetto-prop**. Versione **v1**, primo giro: 18/08/2026 ~01:00._
_Un solo documento, vivo: ogni numero ha la sua fonte e il suo stato. Le
modifiche stanno nel CHANGELOG in fondo._

> ⛔ **Niente di questo documento e' applicato da solo.** Gli stati sono tre:
> **PROPOSTO** (argomentato, in attesa di Claudio) · **CONGELATO** (data +
> parola di Claudio: non si riapre senza una misura nuova) · **APERTO** (le
> fonti divergono o mancano — e' scritto cosa serve per chiudere).
> Il forward **non si tocca mai** da qui.

**Gerarchia delle fonti** (risolve i conflitti): 🥇 misurato da noi → 🥈 regole
prop (con etichetta di verifica) → 🥉 convergenza di fonti esterne indipendenti
→ 4° dichiarazione singola. Se una misura nostra contraddice tre video, vince
la misura — e il conflitto si scrive lo stesso.

**Fonti di questo giro** (v1):
- 🥇 `report/METRO_PROP.md` (15/08) · `report/ROBUSTEZZA.md` (15/08) ·
  `report/ROTTA_PROP.md` (09/08) · `report/DOVE_SIAMO_17-08.md` ·
  `backtest_pipeline/risultati_archivio/REFERTO_CENSIMENTO_RISCHIO.md` (17-18/08)
  · `REFERTO_PORTAFOGLIO_R16.md` · `report/DEPLOY_GUARDIANO_100K.md` (09/08)
- 🥈🥉 `backtest_pipeline/caccia_strategie/CONFIG_PROP_2026-08-18.md` (dossier
  del cacciatore-config-prop: 3 preset `.set` [VERIFICATO], censimento 6 prop
  **[LETTO-VIA-SEARCH, non verificato]**, tabella dei 36 buchi) ·
  `PROPOSTE_PROP_2026-08-18.md` (P1-P9)
- il parco com'e' oggi: `FLOTTA_ATTIVA.md` · `mql5/Experts/ABTG_Guardian.mq5`
  (209 righe, letto integralmente) · `mql5/Presets/ABTG_Guardian_FTMO_2Step.set`
- 4° **script CrewAI/articolo incollato da Claudio in chat (18/08 ~01:10)** —
  dichiarazione singola, non nostro codice, NON eseguito: schedate solo le 4
  voci con valore (breaker 4,3-4,5%, equity vs snapshot, snapshot a
  mezzanotte broker, sizing 0,5%); il resto (pipeline senza backtest reale,
  news via WebRequest) non porta valore
- 🥉/4° `ANALISI_TRASCRIZIONI_2026-08-18.md` (analista-trascrizioni,
  consegnato — **incorporato al secondo giro, v2**): 11 trascrizioni = **7
  fonti indipendenti** (3 video Petko contano 1, 2 Cash&Prop contano 1).
  **Resa numerica BASSA**: nessun `.set` dettato a voce, zero finestre news in
  minuti, zero ore di reset, zero conferma del pattern 4/9 nel parlato. Il
  marchio 🎬 sulle righe ora significa: **la fonte trascrizioni ha risposto, e
  la risposta e' "niente di numerico"** — il dettaglio riga per riga.

---

## 📍 IL PUNTO DI PARTENZA, IN QUATTRO NUMERI (perche' il piano serve)

| fatto | numero | fonte |
|---|---|---|
| agosto sul conto piccolo | **−11%** (90 op, −617,49 € su ~5.100 €) — su una prop saremmo **gia' fuori dal muro del 10%**; scalato a 0,65% farebbe −7,2% | 🥇 `DOVE_SIAMO_17-08.md` §1 |
| il rischio di casa | **0,65%** per trade → p99 Monte Carlo **~8,1%** su DD **statico**, contro muro 10% | 🥇 `METRO_PROP.md` §1-bis |
| il buco aritmetico | **8 sedie × 0,65% = 5,2% di rischio aperto simultaneo**, oltre il muro giornaliero del 5% | 🥇 nostro parco + 🥈 dossier §1A |
| il Guardian oggi | soglie **5,0 / 10,0 = esattamente sul muro**: quando scatta, la challenge e' **gia' persa**. Tre vendor indipendenti mettono **4 e 9** | 🥇 preset nostro + 🥉 dossier §1A-ZERO |

E il vincolo che pesa su TUTTO il documento: **le Monte Carlo col DD TRAILING
non esistono ancora** (`METRO_PROP` §1: _"non l'abbiamo mai calcolato"_). Ogni
numero di rischio qui dentro vale **solo su DD statico**.

---

# AREA A — 💰 RISCHIO PER TRADE

| # | parametro | valore PROPOSTO | fonti (rango) | conflitti | stato |
|---|---|---|---|---|---|
| A1 | **Rischio per trade a taglia prop** | **0,65%** | 🥇 MC R16 + 27 serie (`METRO_PROP` §1-bis: p99 12,47% a 1% → ~8,1% a 0,65% vs muro 10%); decisione in `DEPLOY_GUARDIANO_100K.md` | 🥉 blog MQL5 (E0) suggerisce 0,25-0,4%; 🥉 PROPstyle ragiona per rischio TOTALE ≤1%; 4° script CrewAI (18/08): 0,5% per trade contro muro 5% ("10 perdite per sfondare"); 4° trascrizioni: Petko "1% per trade, regola semplice" [dichiarato]. Le voci esterne stanno sopra e sotto il nostro 0,65 — ma la nostra misura vince, e vale **solo su DD statico**: col trailing il numero e' da rifare (→ C5) | 🧊 **CONGELATO (09/08/2026, decisione di Claudio, verbale in `DEPLOY_GUARDIANO_100K.md`: "Rischio per trade: 0,65% (non 1%!)")** |
| A2 | Rischio sedie **giovani** (<30 trade OOS-forward) | **0,3%** (mezzo peso) | 🥇 stessa decisione del 09/08 (ORB a 0,3% nel dry-run: "+41k dei +73,8k sono suoi: mezzo peso finche' non ha 30 trade") | nessuno | 📋 PROPOSTO — applicato di fatto sul dry-run; da congelare come **regola generale**, non caso singolo |
| A3 | Taglia in **fase 2** della challenge | ridurre (meta', o −20%) | 4° dichiarazione singola: blog MQL5 E0-bis ("fase 2: lotto ridotto della meta'") | una sola fonte: non chiude niente | 🔓 APERTO — 🎬 **le trascrizioni hanno risposto: NIENTE** sul sizing di fase 2 (nessuno dei 7 relatori lo tocca). Resta a una fonte; si chiude solo con un round nostro o una seconda fonte scritta |
| A4 | Rischio massimo per sedia sul **conto piccolo** (forward) | **1,0%** (nessuna sedia sopra) | 🥇 `REFERTO_CENSIMENTO_RISCHIO.md`: tre sedie al 2% trovate 17/08, corrette a 1% (controprova 00:01 del 18/08 PASSATA, zero righe rosse); le sei peggiori perdite (−2,00…−2,19%) erano esattamente le sedie al 2% | il 100k a 0,65% conferma per contrasto: la sua peggior perdita e' **−0,65%**, il rischio di casa esatto | 📋 PROPOSTO — in vigore di fatto dal 18/08 00:01; da congelare come regola scritta ("mai sopra 1% sul piccolo") |

> 📌 Nota su A1: congelato **non** vuol dire eterno. La riga si riapre da sola
> il giorno in cui esiste la MC col DD trailing (C5) o cambia il muro della
> prop scelta (area F). E' esattamente il caso previsto dalla regola: _"non si
> riapre senza una misura nuova che lo contraddica"_.

# AREA B — 🛡️ GUARDIANO E CAP (ABTG_Guardian + preset)

Il Guardian oggi ha: cap giornaliero su **balance di inizio giornata vs equity**
(= formula FundedNext, e compatibile con FTMO), DD totale statico o trailing da
picco equity, lockdown persistente con ricaccia degli ordini. Gli mancano 26
dei 36 meccanismi censiti (dossier, Parte 3) — qui sotto i sette che contano.

> ✅ **Verifica fatta sul sorgente (18/08, su segnalazione dello script CrewAI
> che prescrive "floating + realizzato"):** `ABTG_Guardian.mq5` riga 155:
> `dailyLoss = dayStart - eq` — la misura corrente e' l'**EQUITY**, quindi
> **il flottante E' contato**: una posizione aperta in forte perdita fa
> scattare il breaker, non serve che chiuda. Il sospetto di buco NON sussiste
> sul lato misura. Resta aperto solo il lato **baseline** (il `dayStart` e'
> solo balance — riga B4).

| # | parametro | valore PROPOSTO | fonti (rango) | conflitti | stato |
|---|---|---|---|---|---|
| B1 | **Cap giornaliero interno** (soglia effettiva del Guardian) | **4,0%** (= muro 5% − buffer 1 punto) — nuovi input `InpDailyBufferPct=1.0` | 🥉 **convergenza tre vendor indipendenti**: Gold Reaper `PropFirmMaxDailyDD=4`, Gold Phantom idem, Prop Firm Pass pausa a 4 (+buffer 0,1) — [VERIFICATO 18/08] · 4° script CrewAI (18/08): hard stop a **4,3-4,5%** contro muro 5%, con chiusura totale + cancellazione pendenti + EA spento fino al giorno dopo — **quarta voce indipendente della notte che converge su "guardiano PRIMA del muro, mai SUL muro"** · 🥇 peggior giornata nostra misurata −2,06% (R51): il 4% resta largo il doppio | rischio opposto documentato (P2): un guardiano che scatta presto chiude una giornata che sarebbe rientrata; e `FlattenAll()` chiude a mercato anche su spread largo. Da misurare in dry-run quante volte scatterebbe | 📋 PROPOSTO (= proposta **P2**, la n.1 del cacciatore) |
| B2 | **Cap totale interno** | **9,0%** (= muro 10% − buffer 1 punto), `InpTotalBufferPct=1.0` | 🥉 stessi tre vendor: `MaxAllowedDD=9` due volte su due nei preset "propfirm" · 🥇 p99 nostro ~8,1%: sta SOTTO il 9 proposto, il portafoglio ci passa | nessuno di rilievo | 📋 PROPOSTO (P2) |
| B3 | **`InpDailyResetHour`** nel preset FTMO su demo BCM | **23** (oggi: 0) — reset FTMO **00:00 CE(S)T = 23:00 ora server BCM** (agosto: Italia UTC+2, BCM = italiana−1 = UTC+1) | 🥈 scheda FTMO del dossier §2A/§2H — ⚠️ **[LETTO-VIA-SEARCH], NON verificata** · 4° script CrewAI: snapshot alla mezzanotte del broker come base del giorno prop (coerente col principio) | ⚠️ triplo caveat: (1) la scheda prop non e' verificata sul sito ufficiale; (2) il numero dipende dal SERVER, non dalla prop — sul server FTMO tornerebbe 0; (3) lo script CrewAI dice pero' **00:00 GMT**, non CET: **discordanza di fuso fra le fonti — l'ora esatta resta [INCERTO] finche' il supporto non risponde per iscritto**. Va scritto in commento nel preset. Col valore attuale (0) il dry-run misura una giornata **sfasata di un'ora** | 📋 PROPOSTO (P1 — 5 minuti, solo il preset, il codice non si tocca) |
| B4 | **Baseline giornaliera**: balance / equity / max dei due | aggiungere l'input modo (oggi: solo balance, cablato) | 🥈 le prop divergono per regolamento: FundedNext = balance inizio giornata (come noi) · FundingPips = **max(balance, equity)** · The5ers = equity o balance di chiusura · 🥉 Bneu e Take a Break ce l'hanno come input | il valore GIUSTO dipende dalla prop scelta (area F): finche' F1 e' aperto, qui si puo' solo predisporre l'input | 🔓 APERTO — buco n.5 del censimento |
| B5 | **`InpDDMode=2`**: trailing EOD sul saldo di fine giornata piu' alto | aggiungere la modalita' (oggi: 0 statico, 1 trailing equity) | 🥉 KT Equity Protector dichiara esattamente 3 modelli · 🥈 FTMO 1-Step usa proprio questo ("il limite puo' solo salire") · 4° trascrizioni (video PropEA): _"usatelo solo su firme con drawdown STATICO invece del trailing, e' molto importante"_ — un venditore di scorciatoie che conferma la nostra cautela | scrivere il codice **non risponde** alla domanda vera (METRO_PROP §1: MC trailing mai fatta) — la rende solo misurabile. L'uso resta bloccato da C5 | 📋 PROPOSTO (P7) — il codice si'; l'USO resta APERTO |
| B6 | **Pausa morbida giornaliera** (blocca i NUOVI ingressi, non chiude) | soglia **2,5%**, `InpDailyPauseDays=1` | 🥇 il 2,5% e' la NOSTRA misura: peggior giornata storica −2,06% (R51) → "hai gia' fatto peggio del tuo peggior giorno: smetti di aprire" · 🥉 Prop Firm Pass (pausa a 4, 1 giorno) + blog MQL5 (cap 2,5%) | 🔴 il canale di blocco non esiste: il Guardian sa solo `FlattenAll()`. GlobalVariable letta dagli EA (ma chi non la legge la ignora) vs spegnere l'autotrading (ma orfana le posizioni aperte): **nessuna delle due e' gratis** — il come e' APERTO | 📋 PROPOSTO (P4) — soglia proposta, meccanismo da decidere |
| B7 | **Filtro duplicati** (la ferita del 29/07: due EA, stesso segnale, stesso secondo) | finestra **60 s** · tolleranza prezzo **50 pts** · volume **20%** — in `OnTradeTransaction` del Guardian | 🥉 Bneu "Duplicate Filter" (unico prodotto letto che ce l'ha: finestra in secondi + tolleranze) · 🥇 `CENSIMENTO_ORDINI_PC.md` §3 (il caso misurato) · regola 1 di `ROTTA_PROP` — oggi scritta in un file, **niente la fa rispettare** | 🔴 falsi positivi: due EA possono essere legittimamente long sullo stesso simbolo (swing H4 + intraday M5). Serve la lista delle coppie esentate, altrimenti fa piu' male che bene → quella lista e' APERTA | 📋 PROPOSTO (P6) — con esenzioni da definire prima |

Registrati e **non** proposti ora (dal dossier, con motivo): riduzione
automatica del rischio vicino al muro (nessuno dei 7 prodotti la fa — non si
inventa), chiusura del venerdi' (entrambi i preset prop letti la DISABILITANO,
e dipende dalla prop), notifiche/log CSV/pannelli (utili, non cambiano il
rischio di una riga), reset con minuti oltre che ore (serve solo se la prop
scelta resetta a mezz'ore).

# AREA C — 🧺 PORTAFOGLIO (il rischio delle sedie INSIEME)

**Il DD della prop e' UNO: quello del conto** (`ROTTA_PROP`). E' l'area con la
falla aritmetica piu' grossa del piano.

| # | parametro | valore PROPOSTO | fonti (rango) | conflitti | stato |
|---|---|---|---|---|---|
| C1 | **Cap sul rischio APERTO simultaneo** (`InpMaxOpenRiskPct`, somma degli SL vivi) | da misurare PRIMA di sceglierlo | 🥇 aritmetica di casa: 8 sedie × 0,65% = **5,2% > muro giornaliero 5%** (e ben oltre il 4% di E8) · 🥉 le fonti esterne DIVERGONO: PROPstyle **1,0%** · Bneu default **3%** · regola NYAO: SL × maxpos ≈ basket stop | 1% contro 3% e' un fattore 3: due fonti dello stesso rango in disaccordo → il parametro resta aperto. Prima mossa: **misurare la sovrapposizione reale** sui dati per-trade R16 (P3a, ~2 ore, zero backtest nuovi). 🎬 trascrizioni: **zero valori di esposizione simultanea** (unica voce: canale affiliato Top-3, FundedNext "one position at a time" — [INCERTO], contraddice la scheda 4 dello stesso referto) | 🔓 APERTO — la chiusura ora e' attesa SOLO dalla misura M2 |
| C2 | **Max sedie accese simultaneamente** a taglia prop | deriva da C1 (il dry-run 100k oggi ha 5 EA + Guardian) | 🥇 `DEPLOY_GUARDIANO_100K.md` (squadra da 5) vs 28 magic sul conto piccolo (`DOVE_SIAMO` §3: "il conto non e' dimensionato per 28 EA") | il numero giusto esce dalla misura C1, non da un'opinione | 🔓 APERTO |
| C3 | **CRITERIO DI USCITA delle sedie accese** | bozza da discutere: _"si spegne se, su ≥20 op in forward, e' in perdita E il suo DD ha superato quello del backtest della cella che l'ha promossa"_ | 🥇 `DOVE_SIAMO_17-08.md` §5 (proposta n.1, "il pezzo che manca al sistema"): `770101` a −649 su 26 op nel file **e ancora acceso** | i numeri della bozza (20 op? quale DD?) vanno decisi PRIMA di guardare chi verrebbe colpito, per non tarare la regola sul colpevole | 🔓 APERTO — **decisione di Claudio, la piu' urgente del piano** |
| C4 | **Budget DD per sedia quando CONDIVIDE il conto** | registrare la lezione: Gold Phantom `Propfirm_combo` taglia `MaxAllowedDD` da 9 a **4** quando l'EA gira con altri — noi facciamo l'esatto contrario (ogni sedia col rischio pieno come fosse sola) | 🥉 il diff n.2 del dossier ("la riga piu' importante del dossier per noi") | tagliare il rischio taglia il rendimento, e il target di fase 1 va comunque raggiunto nei giorni disponibili: compromesso da MISURARE (dopo C1) | 🔓 APERTO |
| C5 | **Rischio per trade se il DD e' TRAILING** | **NON LO SAPPIAMO** — e va scritto cosi' | 🥇 `METRO_PROP` §1: tutte le MC sono su DD statico; col trailing "quei numeri non valgono". La MC trailing EOD si fa **sulle serie R16 gia' in casa, costo zero dati** | nessuno: manca proprio la misura | 🔓 APERTO — **blocca ogni prop 1-Step / trailing** (vedi F3) |

# AREA D — 📰 NEWS E ORARI

| # | parametro | valore PROPOSTO | fonti (rango) | conflitti | stato |
|---|---|---|---|---|---|
| D1 | **Filtro news di CONFORMITA'** (finestre strette, per non violare la regola) | modulo `.mqh` con `CalendarValueHistory()` (nativo MT5, zero DLL/WebRequest), input SPENTO di default; minuti = quelli della prop scelta | 🥈 regole prop [LETTO-VIA-SEARCH]: FTMO Standard ±2 min · The5ers ±2 · E8 ±5 · FundingPips **±10 anche solo TENENDO** · FTMO **Swing: nessuna restrizione** · 🥉 NYAO + Gold Phantom per la tecnica | 🔴🔴 **non backtestabile**: `CalendarValueHistory()` non risponde nello Strategy Tester ([VERIFICATO]) — l'imbuto di casa non si applica. Per la strada-conformita' e' accettabile (e' un obbligo, non un edge); e i minuti giusti dipendono da F1 | 🔓 APERTO — 🎬 **le trascrizioni hanno risposto: ZERO finestre in minuti** in 11 video. Rinforzo solo qualitativo (Titan X: il news filter e' "dove molte persone perdono la loro roba"). I minuti verranno da schede prop [VERIFICATO] + screenshot M8, non dal parlato |
| D2 | **Filtro news di PROTEZIONE** (finestre larghe, es. NFP 100 min prima) | **non accenderla** senza decisione esplicita: cambia l'edge e non si puo' misurare | 🥉 Gold Phantom (NFP 100/60 con chiusura dell'aperto) | e' una modifica di strategia travestita da protezione; "lo fanno tutti" non e' una fonte | 🔓 APERTO — 🎬 trascrizioni: niente anche qui (nessuna finestra larga dettata) |
| D3 | **Auto-GMT** (orari di sessione in UTC + offset rilevato, invece che cablati in ora server BCM) | helper `ABTG_TimeZone.mqh`, `InpAutoGMT=false` di default | 🥉 Gold Phantom (`AutoGMT=true`, offset 2/3) · 🥇 `METRO_PROP` §11: Pepperstone e' UTC+0, un'ora dietro BCM; il giorno della challenge il server e' quello della prop | 🔴🔴 la proposta **piu' pericolosa** (P9): tocca `InpSessionHour`, dove il progetto ha gia' sbagliato (regola: DAX=8, se 9 → cestinare). Un bug qui rende spazzatura ogni backtest. Non urgente oggi; lo diventa il giorno dell'acquisto | 🔓 APERTO — da fare SOLO con round di verifica dedicato |
| D4 | **Compatibilita' overnight delle sedie notturne** | vincolo di scelta prop, non parametro: `MaxMinNotte` (box 23:00-04:59 srv), `Nightly` (22:00-04:59), variante oro (22:00-06:00) devono essere AMMESSE | 🥇 `METRO_PROP` §3 · 🥈 E8 Signature chiude tutto alle 23:00 server → **tre sedie senza setup, non "da adattare"** | nessuno: e' un filtro sulla scelta in area F | 🔓 APERTO (si chiude con F1 + risposta scritta) |

⏰ **Orari, sempre anche in ora server BCM** (agosto: BCM = italiana − 1 = UTC+1):
reset FTMO 00:00 CE(S)T = **23:00 BCM** · FundedNext / FundingPips / Alpha
00:00 UTC+3 = **22:00 BCM** · The5ers / E8 "00:00 ora server" = **[INCERTO]**,
offset dei loro server non verificato. Tutta la riga e' [LETTO-VIA-SEARCH].

# AREA E — 📜 CONFORMITA' ALLE REGOLE

| # | parametro | valore PROPOSTO | fonti (rango) | conflitti | stato |
|---|---|---|---|---|---|
| E1 | **Invio delle domande al supporto (regola D3)** | riattivare l'invio quando il forward pulito ha 1-2 settimane | 🥇 `DOMANDE_SUPPORTO_PROP.md` (pronte dal 13/08, invio RINVIATO per decisione di Claudio) · `METRO_PROP`: il forward pulito ricomincia dal 15/08 (contaminazione PC fantasma) → 1-2 settimane ≈ **fine agosto** | tutto il censimento prop e' [LETTO-VIA-SEARCH]: **una regola letta male squalifica un conto vero**. E' la cosa a costo zero che vale piu' di tutto il dossier | 🔓 APERTO — decide Claudio quando |
| E2 | **Stessa flotta su due conti = "copy trading"?** | chiarire per iscritto (domanda gia' nel file D3) | 🥇 `METRO_PROP` §5 · 🥈 FTMO cap $400k per trader O strategia · E8 "una strategia per utente" | senza risposta scritta, due conti insieme sono un rischio regolamentare, non una diversificazione | 🔓 APERTO |
| E3 | **Consistency / best-day**: quanto pesa il nostro giorno migliore? | misurarlo sui dati che abbiamo (agosto + serie R16) — oggi **non lo misuriamo neanche a posteriori** (buco n.27) | 🥈 FTMO 50% · FundedNext 40% (Rapid Pro) · E8 ~40/35% [INCERTO, fonti terze] · 🥇 `METRO_PROP` §6: con 27 serie una giornata grossa e' statisticamente ATTESA — la regola colpisce la forma della nostra curva | nessuno sul fatto che vada misurato | 🔓 APERTO — misura interna, costo basso |
| E4 | **Cap richieste server** (FTMO: max 2.000/giorno) | contare quante ne facciamo (28 magic + Guardian a timer 1 s) — [INCERTO] oggi | 🥈 scheda FTMO (buco n.30) | nessuno | 🔓 APERTO — misura interna |
| E5 | **Randomizzazione degli ingressi** | **NON farla ora**, registrata | 🥉 5 prodotti su 7 ce l'hanno, uno la accende SOLO nel preset prop (Gold Phantom `Randomization=50`) | serve solo con due conti/prop insieme (→ E2); farla oggi e' complessita' senza beneficio | 📋 PROPOSTO (proposta = rinvio esplicito, P8) |

# AREA F — 🎯 SCELTA DELLA PROP

| # | parametro | valore PROPOSTO | fonti (rango) | conflitti | stato |
|---|---|---|---|---|---|
| F1 | **Prop di riferimento del piano** | **FTMO 2-Step 100k** come ipotesi di lavoro (e' gia' il preset del Guardian e il modello del dry-run): daily 5% / totale 10% **STATICO** — l'unico modello coerente con le MC che abbiamo | 🥇 dry-run impostato cosi' dal 09/08 · 🥈 confronto 6 prop del dossier §2G: FundingPips ±10 min news anche tenendo (ostile), E8 daily 4% + chiusura 23:00 (uccide 3 sedie), Alpha/FundedNext/The5ers possibili alternative · 4° trascrizioni: **FundedNext 1-Step = 3% daily / 6% totale** [dichiarato a voce, 2 fonti su 7] — daily 3% e' 🔴 per il metro di casa (la nostra peggior giornata −2,06% ne mangia i due terzi, `METRO_PROP` §2); FundedTrading+ "5%/5% con DD rimosso dopo il target" [INCERTO, canale affiliato] | 🔴 TUTTO il censimento e' [LETTO-VIA-SEARCH]: nessuna riga autorizza un acquisto. FTMO Swing da confermare (F2). **Non e' una scelta d'acquisto: e' il metro su cui si tara il piano** | 📋 PROPOSTO |
| F2 | **Tipo di conto** (se FTMO) | **Swing** — nessuna restrizione news, overnight/weekend ammessi: toglie di mezzo D1 e D4 in un colpo | 🥈 scheda FTMO §2A [LETTO-VIA-SEARCH] · 🥇 le domande D3 sono gia' scritte per lo Swing | da confermare per iscritto (gap weekend, bracket OCO, multi-firm: le 3 domande del file D3) | 🔓 APERTO — 🎬 le trascrizioni possono portare esperienze Swing |
| F3 | **Prop 1-Step / DD trailing** | **vietato guardarle** finche' la MC trailing (C5) non esiste | 🥇 `METRO_PROP` §1: "comprare una challenge col trailing e' comprare un biglietto per una gara di cui non conosciamo il percorso" · 4° trascrizioni (PropEA): perfino chi vende hedge dice "solo su drawdown statico, mai trailing" | nessuno | 📋 PROPOSTO (divieto temporaneo, si scioglie con C5) |
| F4 | **Quando si compra** | solo dopo **forward maturo** + **risposte scritte** del supporto | 🥇 regola madre di `METRO_PROP` (decisione di Claudio del 13/08 sul rinvio D3); il forward pulito parte dal 15/08 | agosto a −11% sul piccolo dice che la domanda "quando" oggi ha una sola risposta onesta: **non adesso** | 🧊 **CONGELATO (13/08/2026, decisione di Claudio: D3 in pausa, prop pagata solo dopo forward maturo)** |

---

## 🕳️ COSA MANCA E CHI LO PORTA

| # | buco | chi lo porta | la domanda esatta |
|---|---|---|---|
| M1 | **MC con DD trailing EOD** sulle serie per-trade R16 (chiude C5, sblocca F3, ricalibra A1) | chat principale / PC backtest (misura di casa — costo zero dati nuovi) | "p95/p99 del DD trailing end-of-day del portafoglio a 0,65%: sopra o sotto il 10%?" |
| M2 | **Misura della sovrapposizione reale delle sedie** (chiude C1, poi C2 e C4) | chat principale (P3a: ~2 ore sui dati R16 + forward) | "quante sedie sono state aperte NELLO STESSO momento, e quanto rischio aperto faceva la somma, giorno per giorno?" |
| M3 | Convergenze dai video: finestre news, sizing fase 1 vs 2, cap di esposizione, prop citate da chi passa | **analista-trascrizioni** (in corso ADESSO su 11 trascrizioni) | gia' lanciato — al referto si chiudono/aggiornano A3, C1, D1, D2, F2 |
| M4 | Schede prop **[VERIFICATO]** (oggi tutte [LETTO-VIA-SEARCH]); offset server The5ers/E8; un `.mq5` completo di guardiano open-source | **cacciatore-config-prop** (quando i domini si sbloccano / GitHub esce dal 429) | "aprire le pagine ufficiali di FTMO trading objectives + Swing e datare la scheda; che UTC hanno i server The5ers e E8?" |
| M5 | **Motori con edge sufficiente**: `DOVE_SIAMO` §4 dice che oggi non abbiamo un motore che passerebbe una prop | **cacciatore-strategie** + i round di casa | il piano configura il rischio; il rendimento lo devono portare le sedie |
| M6 | Conferma che il **100k del dry-run e' ancora `50504263`** (il 17/08 un conto 109k e' stato cancellato) | **Claudio** (`conto_attivo.ps1` sul VPS) | "il giornale del terminale V3 dice 50504263 o un numero nuovo?" |
| M7 | Verifica **lotto fisso** dei due EA esterni (`BREAKOUT_EA_JPY_v3`, `DAXMasterEA_v2_0`) | Claudio/VPS (censimento gia' pronto) | rischio non controllato per definizione su un conto da 5.100 € |

## ✍️ LE FIRME CHE SERVONO A CLAUDIO (in ordine di urgenza)

1. **C3 — il criterio di uscita.** La piu' urgente e la piu' di fondo: agosto
   −11% con 28 magic e nessuno che ha il compito di spegnerne uno. I numeri
   della bozza vanno congelati PRIMA di guardare chi colpiscono.
2. **B1+B2+B3 — il pacchetto Guardian** (P2+P1): buffer 4/9 e reset 23. Un'ora
   di lavoro in tutto, ed e' l'unico punto dove tre vendor indipendenti hanno
   scritto lo stesso numero e noi quello sbagliato.
3. **A2/A4 — congelare per iscritto** le due regole di taglia gia' in vigore di
   fatto (0,3% giovani, tetto 1% sul piccolo).
4. **E1 — la data di invio** delle domande al supporto (fine agosto, a forward
   pulito maturo?).

---

## 📊 IL CONTO DEL GIRO

**29 parametri censiti: 2 congelati · 12 proposti · 15 aperti.**
Congelati: A1 (rischio 0,65%, 09/08) · F4 (niente acquisti prima del forward
maturo + risposte scritte, 13/08). Dei 15 aperti, 5 sono marcati 🎬 (possibile
chiusura dall'analista-trascrizioni) e 4 si chiudono con misure di casa a
costo zero dati (M1, M2 + E3, E4).

---

## 📜 CHANGELOG

| data | versione | cosa e' cambiato | perche' |
|---|---|---|---|
| 18/08/2026 ~01:00 | **v1** | prima stesura: 29 parametri in 6 aree, dalle fonti elencate in testa. Incorporati: dossier config-prop 18/08 (3 preset .set veri, censimento 6 prop non verificato, 36 buchi), le 9 proposte P1-P9, il censimento rischio 17-18/08 (tre sedie al 2% corrette a 1%), DOVE_SIAMO 17/08 (agosto −11%, manca il criterio di uscita). **NON incorporata** l'analisi trascrizioni (in lavorazione): 5 parametri marcati 🎬 in attesa | non esisteva un posto unico dove i numeri della prop stessero con fonte e stato |
| 18/08/2026 ~01:15 | v1.1 | incorporato lo **script CrewAI incollato da Claudio** (rango 4): breaker 4,3-4,5% aggiunto alle fonti di B1 (quarta voce convergente sul buffer prima del muro), sizing 0,5% aggiunto ai conflitti di A1, snapshot mezzanotte broker in B3 **con la discordanza di fuso (00:00 GMT vs 00:00 CET) segnata come [INCERTO]**. Eseguita la verifica richiesta sul Guardian: riga 155 misura su **equity** → il flottante e' contato, nessun buco nuovo (resta B4 sulla baseline) | materiale nuovo in chat durante il primo giro |
