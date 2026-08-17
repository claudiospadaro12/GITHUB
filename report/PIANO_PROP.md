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
- 🥉 `CONFIG_PROP_RACCOLTA_SET_2026-08-18.md` (seconda notte del cacciatore,
  **incorporato al terzo giro, v3**): **50 `.set` nuovi da 11 fonti**, 75 file
  in `biblioteca/` (indice: `biblioteca/CATALOGO.md`, ora con stanza `dati/`).
  Correzione d'evidenza sul 4/9 (Gold Reaper e Gold Phantom = STESSO autore,
  Profalgo/WSC), buco n.8 tappato due volte, **filtro news backtestabile via
  CSV**, canale di blocco fra EA trovato in natura (The Impossible Prop)
- 🥇 `CANCELLO_ACQUISTI_EA.md` (18/08 notte, **decisione di Claudio**: "sono
  disposto a pagarli" — procedura d'acquisto EA a 5 gradini + 1-bis, congelata
  prima dei casi)
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
| il Guardian oggi | soglie **5,0 / 10,0 = esattamente sul muro**: quando scatta, la challenge e' **gia' persa**. Sul "guardiano PRIMA del muro" convergono **5+ fonti indipendenti** (il VALORE del buffer invece diverge: 0,1–1,0 punti — vedi B1). **Siamo l'unico caso letto che sta sul muro esatto** | 🥇 preset nostro + 🥉 dossier 1ª notte §1A-ZERO + raccolta 2ª notte §2A-2B |

E il vincolo che pesa su TUTTO il documento: **le Monte Carlo col DD TRAILING
non esistono ancora** (`METRO_PROP` §1: _"non l'abbiamo mai calcolato"_). Ogni
numero di rischio qui dentro vale **solo su DD statico**.

---

# AREA A — 💰 RISCHIO PER TRADE

| # | parametro | valore PROPOSTO | fonti (rango) | conflitti | stato |
|---|---|---|---|---|---|
| A1 | **Rischio per trade a taglia prop** | **0,65%** | 🥇 MC R16 + 27 serie (`METRO_PROP` §1-bis: p99 12,47% a 1% → ~8,1% a 0,65% vs muro 10%); decisione in `DEPLOY_GUARDIANO_100K.md` | 🥉 blog MQL5 (E0) suggerisce 0,25-0,4%; 🥉 PROPstyle ragiona per rischio TOTALE ≤1%; 4° script CrewAI (18/08): 0,5% per trade contro muro 5% ("10 perdite per sfondare"); 4° trascrizioni: Petko "1% per trade, regola semplice" [dichiarato]. Le voci esterne stanno sopra e sotto il nostro 0,65 — 2ª notte, distribuzione aggiornata: 0,5 (Prop Firm Pass) · 0,5 (TIP preset; 0,75 di listino) · **0,65 (noi)** · 1,0 (Ultimate EA) · 2,4 ⚠️ (Range Breakout ExtraLow): **siamo nel corpo della distribuzione, nessuna misura nuova lo contraddice**. E vale **solo su DD statico**: col trailing il numero e' da rifare (→ C5). ⚠️ Vale per UNA sedia: il problema e' la SOMMA (C1/C4) | 🧊 **CONGELATO (09/08/2026, decisione di Claudio, verbale in `DEPLOY_GUARDIANO_100K.md`: "Rischio per trade: 0,65% (non 1%!)")** |
| A2 | Rischio sedie **giovani** (<30 trade OOS-forward) | **0,3%** (mezzo peso) | 🥇 stessa decisione del 09/08 (ORB a 0,3% nel dry-run: "+41k dei +73,8k sono suoi: mezzo peso finche' non ha 30 trade") | nessuno | 📋 PROPOSTO — applicato di fatto sul dry-run; da congelare come **regola generale**, non caso singolo |
| A3 | Taglia in **fase 2** della challenge | in dubbio: ridurre (meta'/−20%) **oppure non toccare il rischio e abbassare solo il target** | 4° blog MQL5 E0-bis ("fase 2: lotto ridotto della meta'") **CONTRO** 🥉 Ultimate EA, coi file alla mano [VERIFICATO]: `riskPercentage` **1,0 / 1,0 / 1,0** su Phase 1 / Phase 2 / Funded — cambia SOLO il target (**8 → 5 → 2**) | 🔴 **PEGGIORATO v3 (ed e' un bene saperlo): da "1 fonte a favore" a 1 CONTRO 1** — e la fonte contraria e' piu' forte (un file di configurazione, non una frase) | 🔓 APERTO — 🎬 trascrizioni: niente. Si chiude con un round nostro o col peso delle fonti future |
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
| B1 | **Cap giornaliero interno — DUE livelli** (riscritta al v3: prima confondeva due meccanismi in uno) | **pausa morbida a 4,0%** (ferma i NUOVI ingressi per la giornata) **+ chiusura d'emergenza a 4,9%** (= muro 5 − 0,1 di margine tecnico contro spread/slippage/commissioni in chiusura) — modello Prop Firm Pass | **PRINCIPIO "mai sul muro": 5+ fonti indipendenti** (Profalgo, Eriksson 4%, Ultimate EA 4,9, guida 772732 4,90, Prop Firm Pass 4,0+0,1, EquityGuard 4,5, CrewAI 4,3-4,5) — noi a 5,0 siamo **l'unico caso letto sul muro esatto** · 🥇 peggior giornata nostra −2,06% (R51): il livello morbido a 4 resta largo il doppio | 🔴 **CORREZIONE D'EVIDENZA (2ª notte)**: la "convergenza tre vendor" sul 4/9 era in realta' **DUE** — Gold Phantom dichiara `The_Gold_Phantom_V1.0_WSC` = Wim Schrynemakers = **Profalgo, lo stesso autore di Gold Reaper**, stessa lista input. E il VALORE del buffer **diverge per un fattore 10**: 1,0 pt (Profalgo+Eriksson) · 0,1 pt (Ultimate EA + guida 772732 + Prop Firm Pass, **tre fonti indipendenti**) · 0,5 pt (EquityGuard + CrewAI). Sono **due meccanismi diversi**: chi mette 4 FERMA la giornata, chi mette 4,9 para solo i costi di chiusura. Il rischio di scattare troppo presto (giornata che sarebbe rientrata) riguarda solo il livello morbido; da misurare in dry-run | 📋 PROPOSTO (P2 **riscritta v3**: doppia soglia) |
| B2 | **Cap totale interno** | **chiusura d'emergenza a 9,9%** (= 10 − 0,1 tecnico); un eventuale fermo deliberato prima (es. 9,0) e' una **scelta di gestione**, non un buffer tecnico, e va decisa come tale | 🥉 il 9 secco viene da **UNA casa sola** (Profalgo, due prodotti); le tre fonti a buffer sottile direbbero **9,9** · 🥇 p99 nostro ~8,1%: sta sotto entrambe le soglie, il portafoglio ci passa | stessa correzione d'evidenza di B1: il "9" non e' "quello che dicono tutti" | 📋 PROPOSTO (P2, valore rivisto v3) |
| B3 | **`InpDailyResetHour`** nel preset FTMO su demo BCM | **23** (oggi: 0) — reset FTMO **00:00 CE(S)T = 23:00 ora server BCM** (agosto: Italia UTC+2, BCM = italiana−1 = UTC+1) | 🥈 scheda FTMO del dossier §2A/§2H — ⚠️ **[LETTO-VIA-SEARCH], NON verificata** · 4° script CrewAI: snapshot alla mezzanotte del broker come base del giorno prop (coerente col principio) | ⚠️ triplo caveat: (1) la scheda prop non e' verificata sul sito ufficiale; (2) il numero dipende dal SERVER, non dalla prop — sul server FTMO tornerebbe 0; (3) lo script CrewAI dice pero' **00:00 GMT**, non CET: **discordanza di fuso fra le fonti — l'ora esatta resta [INCERTO] finche' il supporto non risponde per iscritto**. Va scritto in commento nel preset. Col valore attuale (0) il dry-run misura una giornata **sfasata di un'ora**. 2ª notte: **nessuna gamba nuova** — nessun `.set` su 50 dichiara l'ora di reset del muro (quasi nessun EA prop-ready ha quell'input: solo Prop Firm Pass, ora+minuto; TIP dichiara il fuso di SESSIONE in GMT, non del reset). Resta [INCERTO], si chiude solo col supporto | 📋 PROPOSTO (P1 — 5 minuti, solo il preset, il codice non si tocca) |
| B4 | **Baseline giornaliera**: balance / equity / max dei due | aggiungere l'input modo (oggi: solo balance, cablato) | 🥈 le prop divergono per regolamento: FundedNext = balance inizio giornata (come noi) · FundingPips = **max(balance, equity)** · The5ers = equity o balance di chiusura · 🥉 Bneu e Take a Break ce l'hanno come input | il valore GIUSTO dipende dalla prop scelta (area F): finche' F1 e' aperto, qui si puo' solo predisporre l'input | 🔓 APERTO — buco n.5 del censimento |
| B5 | **`InpDDMode=2`**: trailing EOD sul saldo di fine giornata piu' alto | aggiungere la modalita' (oggi: 0 statico, 1 trailing equity) | 🥉 KT Equity Protector dichiara esattamente 3 modelli · 🥈 FTMO 1-Step usa proprio questo ("il limite puo' solo salire") · 4° trascrizioni (video PropEA): _"usatelo solo su firme con drawdown STATICO invece del trailing, e' molto importante"_ — un venditore di scorciatoie che conferma la nostra cautela | scrivere il codice **non risponde** alla domanda vera (METRO_PROP §1: MC trailing mai fatta) — la rende solo misurabile. L'uso resta bloccato da C5 | 📋 PROPOSTO (P7) — il codice si'; l'USO resta APERTO |
| B6 | **Pausa morbida giornaliera** (blocca i NUOVI ingressi, non chiude) | soglia **2,5%**, `InpDailyPauseDays=1` | 🥇 il 2,5% e' la NOSTRA misura: peggior giornata storica −2,06% (R51) → "hai gia' fatto peggio del tuo peggior giorno: smetti di aprire" · 🥉 Prop Firm Pass (pausa a 4, 1 giorno) + blog MQL5 (cap 2,5%) — e la struttura a due livelli ora e' anche in B1 | 🔄 **AGGIORNATO v3: il canale di blocco ESISTE in natura.** The Impossible Prop lo implementa gratuito: **7 campi trasmessi via GlobalVariable a ogni tick** (battito, posizioni, direzione, P&L, stato di halt) + **staleness detection `SiblingStaleSec=30`** (se l'emittente muore, chi legge se ne accorge) + **`BlockIfSiblingHalted=true`**. Il nostro Guardian **gia' scrive** GlobalVariable (`BLOCKDAY`/`FAILED`): mancano la LETTURA negli EA e il battito con staleness. Resta vero che ogni EA che non legge la variabile la ignora: la verifica va fatta EA per EA, non assunta | 📋 PROPOSTO (P4) — soglia proposta, meccanismo ora con un modello documentato da copiare |
| B7 | **Filtro duplicati** (la ferita del 29/07: due EA, stesso segnale, stesso secondo) | finestra **60 s** · tolleranza prezzo **50 pts** · volume **20%** — in `OnTradeTransaction` del Guardian | 🥉 Bneu "Duplicate Filter" (unico prodotto letto che ce l'ha: finestra in secondi + tolleranze) · 🥇 `CENSIMENTO_ORDINI_PC.md` §3 (il caso misurato) · regola 1 di `ROTTA_PROP` — oggi scritta in un file, **niente la fa rispettare** | 🔴 falsi positivi: due EA possono essere legittimamente long sullo stesso simbolo (swing H4 + intraday M5). Serve la lista delle coppie esentate, altrimenti fa piu' male che bene → quella lista e' APERTA | 📋 PROPOSTO (P6) — con esenzioni da definire prima |
| B8 | **Riduzione del rischio in avvicinamento al muro** (ex buco n.8 — al v1 era nei "non proposti" perche' _"nessun prodotto la implementa"_: **la 2ª notte l'ha trovata DUE volte**) | da definire: due meccanismi documentati — (a) **zone automatiche** alla The Impossible Bullion (`PropYellowPct`/`PropRedPct`/`PropDeadPct` + `YellowRiskMult`/`RedRiskMult` + cap trade + soglia qualita' per zona); (b) **scala manuale a 2 gradini** alla Range Breakout (ExtraLow↔Low legata al cuscinetto: _"sotto zero, torna a ExtraLow"_) | 🥉 raccolta §1E/§4: Bullion (guida config) + Range Breakout (manuale) · affine: EquityGuard `Warning at 80%` e PropGuard `InpWarningThresholdPercent=10` (allarme di avvicinamento, buco n.28) | ⚠️ le **soglie della Bullion NON sono pubblicate** ([INCERTO]: nomi e logica si', numeri no); la scala manuale richiede disciplina umana. E il monito del v1 resta: i moltiplicatori andrebbero tarati su misure NOSTRE, non copiati | 🔓 APERTO — da buco "di nessuno" a parametro con due modelli reali |

Registrati e **non** proposti ora (con motivo): chiusura del venerdi' (i
preset prop della 1ª notte la DISABILITANO e dipende dalla prop — pero' la 2ª
notte nota che Range Breakout ha `InpClosingSession=true` su 32 preset su 32:
la **chiusura di FINE SESSIONE**, cosa diversa dal venerdi', resta nel
registro), notifiche/log CSV/pannelli (utili, non cambiano il rischio di una
riga), reset con minuti oltre che ore (serve solo se la prop scelta resetta a
mezz'ore). ~~Riduzione del rischio vicino al muro~~ → **promossa a riga B8**
al v3: la 2ª notte l'ha trovata implementata due volte.

# AREA C — 🧺 PORTAFOGLIO (il rischio delle sedie INSIEME)

**Il DD della prop e' UNO: quello del conto** (`ROTTA_PROP`). E' l'area con la
falla aritmetica piu' grossa del piano.

| # | parametro | valore PROPOSTO | fonti (rango) | conflitti | stato |
|---|---|---|---|---|---|
| C1 | **Cap sul rischio APERTO simultaneo** (`InpMaxOpenRiskPct`, somma degli SL vivi) | da misurare PRIMA di sceglierlo | 🥇 aritmetica di casa: 8 sedie × 0,65% = **5,2% > muro giornaliero 5%** (e ben oltre il 4% di E8) · 🥉 le fonti esterne DIVERGONO: PROPstyle **1,0%** · Bneu default **3%** · regola NYAO: SL × maxpos ≈ basket stop | 1% contro 3% e' un fattore 3: due fonti dello stesso rango in disaccordo → il parametro resta aperto. Prima mossa: **misurare la sovrapposizione reale** sui dati per-trade R16 (P3a, ~2 ore, zero backtest nuovi). 🎬 trascrizioni: zero valori. **2ª notte: due gambe nuove ma ancora divergenti** — The Impossible Prop fa il conto esplicito (_"0,75 × 2 = 1,5% per evento di perdita simultanea, well under il 5%"_) **e sceglie di fermarsi a 2 EA**; Eriksson: 1% × 3 trade = 3% max giornaliero. Il campione dei valori resta 1% / 1,5% / 3%: piu' fonti, stessa divergenza | 🔓 APERTO — la chiusura resta SOLO la misura M2 |
| C2 | **Max sedie accese simultaneamente** a taglia prop | deriva da C1 (il dry-run 100k oggi ha 5 EA + Guardian) | 🥇 `DEPLOY_GUARDIANO_100K.md` (squadra da 5) vs 28 magic sul conto piccolo (`DOVE_SIAMO` §3: "il conto non e' dimensionato per 28 EA") | il numero giusto esce dalla misura C1, non da un'opinione | 🔓 APERTO |
| C3 | **CRITERIO DI USCITA delle sedie accese** | bozza da discutere: _"si spegne se, su ≥20 op in forward, e' in perdita E il suo DD ha superato quello del backtest della cella che l'ha promossa"_ | 🥇 `DOVE_SIAMO_17-08.md` §5 (proposta n.1, "il pezzo che manca al sistema"): `770101` a −649 su 26 op nel file **e ancora acceso** | i numeri della bozza (20 op? quale DD?) vanno decisi PRIMA di guardare chi verrebbe colpito, per non tarare la regola sul colpevole | 🔓 APERTO — **decisione di Claudio, la piu' urgente del piano** |
| C4 | **Budget DD per sedia quando CONDIVIDE il conto** | la regola implicita che esce da tre fonti: **rischio per sedia ≈ budget totale ÷ n. sedie** (e per una sedia sola si puo' salire) | 🥉 **da 1 fonte a 3 (v3)**: Gold Phantom `Propfirm_combo` 9→4 (Profalgo) · The Impossible Prop (_"both EAs **share the daily DD budget**"_; da solo si sale a 1,0-1,25%) · Eriksson (_"**divide** total account risk **equally** across multiple EAs"_) — piu' le affini PROPstyle/NYAO della 1ª notte | noi facciamo l'esatto contrario (ogni sedia col rischio pieno come fosse sola). Tagliare il rischio taglia il rendimento e il target va comunque raggiunto: compromesso da MISURARE (dopo C1/M2) | 🔓 APERTO — evidenza molto piu' forte, valore ancora da misurare |
| C5 | **Rischio per trade se il DD e' TRAILING** | **NON LO SAPPIAMO** — e va scritto cosi' | 🥇 `METRO_PROP` §1: tutte le MC sono su DD statico; col trailing "quei numeri non valgono". La MC trailing EOD si fa **sulle serie R16 gia' in casa, costo zero dati** | nessuno: manca proprio la misura | 🔓 APERTO — **blocca ogni prop 1-Step / trailing** (vedi F3) |

# AREA D — 📰 NEWS E ORARI

| # | parametro | valore PROPOSTO | fonti (rango) | conflitti | stato |
|---|---|---|---|---|---|
| D1 | **Filtro news di CONFORMITA'** (finestre strette, per non violare la regola) | modulo `.mqh` con doppia alimentazione: **dal vivo** `CalendarValueHistory()` (zero DLL/WebRequest — base gratuita gia' in biblioteca: `NewsFilter_IvanPochta_*.mqh`, 283 righe, default 60/60 da stringere) · **nel tester** lettura del **calendario esportato in CSV** da `Common/Files`. Input SPENTO di default; minuti = quelli della prop scelta | 🥈 regole prop [LETTO-VIA-SEARCH]: FTMO Standard ±2 · The5ers ±2 · E8 ±5 · FundingPips **±10 anche solo TENENDO** · FTMO Swing: nessuna · 🥉 metodo CSV: manuale Range Breakout [VERIFICATO] (_"save the MT5 economic calendar as a CSV-file in the Common/Files directory"_) · 🥉 **2 CSV gia' in `biblioteca/dati/`**: 2021-2025, 37.799 righe, `data;paese;impatto 0-3;evento`, fuso **UTC+2 [VERIFICATO per ricalcolo su ISM e ADP] → su BCM (UTC+1 in agosto) va tolta UN'ORA** | 🔄 **SBLOCCATA v3: il "non backtestabile" CADE.** Resta vero per la FUNZIONE (`CalendarValueHistory` muto nel tester), falso per il metodo: il calendario si esporta dal terminale vivo e si rilegge da file — **il filtro diventa misurabile con l'imbuto di casa**. Restano: i minuti dipendono da F1; l'attenzione al fuso dei CSV; e la parita' vivo/tester va verificata (due percorsi di codice = da collaudare che decidano uguale) | 📋 **PROPOSTO (v3, era APERTO)** — costruzione del modulo backtestabile; i MINUTI restano legati a F1 |
| D2 | **Filtro news di PROTEZIONE** (finestre larghe, es. NFP 100 min prima) | **non accenderla** senza decisione esplicita: cambia l'edge e non si puo' misurare | 🥉 Gold Phantom (NFP 100/60 con chiusura dell'aperto) | e' una modifica di strategia travestita da protezione; "lo fanno tutti" non e' una fonte. 2ª notte: il campione delle finestre va **da 5 a 100 minuti** (Range Breakout 5 · TIP 30/15 · guida 772732 30/30 · NewsFilter.mqh 60/60 · Gold Phantom 100/60): **nessuna convergenza, nessun numero da copiare** — la cautela del piano e' confermata dai numeri. Nota: col metodo CSV di D1 anche QUESTA diventa misurabile, se un giorno la si vuole giudicare | 🔓 APERTO — 🎬 trascrizioni: niente anche qui |
| D3 | **Auto-GMT** (orari di sessione in UTC + offset rilevato, invece che cablati in ora server BCM) | helper `ABTG_TimeZone.mqh`, `InpAutoGMT=false` di default | 🥉 Gold Phantom (`AutoGMT=true`, offset 2/3) · 🥉 2ª notte, mezza gamba: TIP dichiara le sessioni **in GMT** e Range Breakout ha `TimeOffset` per correggere da UTC+2 — **due modi diversi, ma l'offset e' sempre un INPUT, mai cablato** (noi lo cabliamo) · 🥇 `METRO_PROP` §11: Pepperstone e' UTC+0, un'ora dietro BCM; il giorno della challenge il server e' quello della prop | 🔴🔴 la proposta **piu' pericolosa** (P9): tocca `InpSessionHour`, dove il progetto ha gia' sbagliato (regola: DAX=8, se 9 → cestinare). Un bug qui rende spazzatura ogni backtest. Non urgente oggi; lo diventa il giorno dell'acquisto | 🔓 APERTO — da fare SOLO con round di verifica dedicato |
| D4 | **Compatibilita' overnight delle sedie notturne** | vincolo di scelta prop, non parametro: `MaxMinNotte` (box 23:00-04:59 srv), `Nightly` (22:00-04:59), variante oro (22:00-06:00) devono essere AMMESSE | 🥇 `METRO_PROP` §3 · 🥈 E8 Signature chiude tutto alle 23:00 server → **tre sedie senza setup, non "da adattare"** | nessuno: e' un filtro sulla scelta in area F | 🔓 APERTO (si chiude con F1 + risposta scritta) |

⏰ **Orari, sempre anche in ora server BCM** (agosto: BCM = italiana − 1 = UTC+1):
reset FTMO 00:00 CE(S)T = **23:00 BCM** · FundedNext / FundingPips / Alpha
00:00 UTC+3 = **22:00 BCM** · The5ers / E8 "00:00 ora server" = **[INCERTO]**,
offset dei loro server non verificato. Tutta la riga e' [LETTO-VIA-SEARCH].

# AREA E — 📜 CONFORMITA' ALLE REGOLE

| # | parametro | valore PROPOSTO | fonti (rango) | conflitti | stato |
|---|---|---|---|---|---|
| E1 | **Invio delle domande al supporto (regola D3)** | riattivare l'invio quando il forward pulito ha 1-2 settimane | 🥇 `DOMANDE_SUPPORTO_PROP.md` (pronte dal 13/08, invio RINVIATO per decisione di Claudio) · `METRO_PROP`: il forward pulito ricomincia dal 15/08 (contaminazione PC fantasma) → 1-2 settimane ≈ **fine agosto** | tutto il censimento prop e' [LETTO-VIA-SEARCH]: **una regola letta male squalifica un conto vero**. E' la cosa a costo zero che vale piu' di tutto il dossier | 🔓 APERTO — decide Claudio quando |
| E2 | **Stessa flotta su due conti = "copy trading"?** E l'hedge? | chiarire per iscritto (domanda gia' nel file D3) | 🥇 `METRO_PROP` §5 · 🥈 FTMO cap $400k per trader O strategia · E8 "una strategia per utente" · 4° trascrizioni (scheda 4, FundedNext): **hedge multi-account VIETATO** (stesso simbolo, long su un conto e short sull'altro), **hedge sullo stesso conto permesso** — risponde a voce alla domanda tipo-2 del file D3 (OCO stesso conto = ok) — e il relatore dichiara di averlo confermato **per iscritto col supporto: e' la regola D3 in azione, fatta da un altro** | la conferma e' SUA, non nostra: per la regola di casa serve la NOSTRA risposta scritta. E il nostro caso vero (stessi EA, stesso LATO, su due conti) e' copy, non hedge: resta da chiedere | 🔓 APERTO — perimetro piu' chiaro, chiusura solo per iscritto |
| E3 | **Consistency / best-day**: quanto pesa il nostro giorno migliore? | misurarlo sui dati che abbiamo (agosto + serie R16) — oggi **non lo misuriamo neanche a posteriori** (buco n.27) | 🥈 FTMO 50% · FundedNext 40% (Rapid Pro) · E8 ~40/35% [INCERTO, fonti terze] · 🥇 `METRO_PROP` §6: con 27 serie una giornata grossa e' statisticamente ATTESA — la regola colpisce la forma della nostra curva · 🥉 **2ª notte: un vendor la misura DENTRO l'EA** (guida 772732): `Best Day Rule Max=50%`, `Minimum Trading Days=4`, `Challenge Start Date` per non contare lo storico vecchio — **meccanismo copiabile**, non solo metrica a posteriori | nessuno sul fatto che vada misurato | 🔓 APERTO — misura interna, costo basso; ora c'e' anche il modello per farla in tempo reale |
| E4 | **Cap richieste server** (FTMO: max 2.000/giorno) | contare quante ne facciamo (28 magic + Guardian a timer 1 s) — [INCERTO] oggi | 🥈 scheda FTMO (buco n.30) | nessuno | 🔓 APERTO — misura interna |
| E5 | **Randomizzazione degli ingressi** | **NON farla ora**, registrata | 🥉 5 prodotti su 7 ce l'hanno, uno la accende SOLO nel preset prop (Gold Phantom `Randomization=50`) · 🥉 trascrizioni: 3 fonti su 7 la usano — ma per **anti-detection**, che per noi e' vietato (→ E6) | serve solo con due conti/prop insieme (→ E2); farla oggi e' complessita' senza beneficio — e la lettura di P8 ("serve a non risultare strategia identica") e' confermata dal parlato | 📋 PROPOSTO (proposta = rinvio esplicito, P8) |
| E6 | **Cosa le prop RILEVANO** (intelligence difensiva, dal video marcato VIETATO PER NOI) | registrare e rispettare: le prop leggono **(a) il magic number** (magic 0 simula trading manuale — e' il trucco insegnato, quindi e' il controllo che fanno), **(b) input identici fra conti**, **(c) "tratti simili"** fra utenti dello stesso EA di mercato. Per noi: **mai magic 0, mai mascherare** — i nostri EA sono nostri, magic dichiarati, e la trasparenza e' la difesa (un EA proprietario non ha "magic condiviso fra utenti" da nascondere) | 🥉 trascrizioni: 3 fonti su 7 vendono anti-detection (Petko/app "magic unico per download", venditore-86% "soluzione tecnica per mascherarlo", Blue Edge randomization) — convergenza alta su COSA viene rilevato | nessuno: e' intelligence, non un valore da tarare. L'unico uso operativo e' in E2 (due conti nostri) e nella domanda D3 gia' scritta | 📋 PROPOSTO (registro difensivo; nessuna pratica di occultamento, MAI) |
| E7 | **Igiene di configurazione — le lezioni del setaccio 2ª notte** (regole di casa da tenere a registro) | tre lezioni: **(1)** _"prop-ready" ≠ senza recovery_: **3 famiglie su 8** lette hanno un moltiplicatore di recupero nei parametri (Ultimate EA: input `martingala` + TIME GRID 15 trade senza SL individuali · FTMO Smart Trader: `DOWN_LOTS=2,02` **con `equity_stop=0`, spento in tutti e 6 i preset** · guida 772732: `Multiplier After Loss=2,0`, max lot recovery 20,48) — e il "preset prop" e' spesso **il preset normale con la martingala disinnescata** (`DOWN_LOTS` 2,02→1,01); **(2)** 🚩 anti-pattern del **cap in VALUTA**: FTMO Smart Trader mette `DAILY_DD_` a −500/−1000/−2000 — su 100k e' 0,5-2%, su 10k e' **5-20%: lo stesso file passa o sfonda a seconda della taglia**. I cap si esprimono SEMPRE in % (il nostro Guardian lo fa gia' ✅); **(3)** l'aggressivita' si cambia nel motore o nella taglia, **mai nelle protezioni** (regola visibile in Prop Firm Pass 5/5 e Range Breakout 32/32: i profili differiscono solo su rischio/taglia, le protezioni sono identiche) | 🥉 raccolta §1D/§6 (setaccio su 8 famiglie, `.set` alla mano [VERIFICATO]) | nessuno | 📋 PROPOSTO (registro d'igiene: vincola come scriviamo/leggiamo i preset, non tocca il forward) |

# AREA F — 🎯 SCELTA DELLA PROP

| # | parametro | valore PROPOSTO | fonti (rango) | conflitti | stato |
|---|---|---|---|---|---|
| F1 | **Prop di riferimento del piano** | **FTMO 2-Step 100k** come ipotesi di lavoro (e' gia' il preset del Guardian e il modello del dry-run): daily 5% / totale 10% **STATICO** — l'unico modello coerente con le MC che abbiamo | 🥇 dry-run impostato cosi' dal 09/08 · 🥈 confronto 6 prop del dossier §2G: FundingPips ±10 min news anche tenendo (ostile), E8 daily 4% + chiusura 23:00 (uccide 3 sedie), Alpha/FundedNext/The5ers possibili alternative · 4° trascrizioni: **FundedNext 1-Step = 3% daily / 6% totale** [dichiarato a voce, 2 fonti su 7] — daily 3% e' 🔴 per il metro di casa (la nostra peggior giornata −2,06% ne mangia i due terzi, `METRO_PROP` §2); FundedTrading+ "5%/5% con DD rimosso dopo il target" [INCERTO, canale affiliato] | 🔴 TUTTO il censimento e' [LETTO-VIA-SEARCH]: nessuna riga autorizza un acquisto. FTMO Swing da confermare (F2). **Non e' una scelta d'acquisto: e' il metro su cui si tara il piano** | 📋 PROPOSTO |
| F2 | **Tipo di conto** (se FTMO) | **Swing** — nessuna restrizione news, overnight/weekend ammessi: toglie di mezzo D1 e D4 in un colpo | 🥈 scheda FTMO §2A [LETTO-VIA-SEARCH] · 🥇 le domande D3 sono gia' scritte per lo Swing | da confermare per iscritto (gap weekend, bracket OCO, multi-firm: le 3 domande del file D3) | 🔓 APERTO — 🎬 trascrizioni: **nessuna esperienza Swing** nei 7 relatori (l'unico racconto FTMO vissuto, BM Trading, non dice il tipo di conto). Si chiude solo con la risposta scritta |
| F3 | **Prop 1-Step / DD trailing** | **vietato guardarle** finche' la MC trailing (C5) non esiste | 🥇 `METRO_PROP` §1: "comprare una challenge col trailing e' comprare un biglietto per una gara di cui non conosciamo il percorso" · 4° trascrizioni (PropEA): perfino chi vende hedge dice "solo su drawdown statico, mai trailing" | nessuno | 📋 PROPOSTO (divieto temporaneo, si scioglie con C5) |
| F4 | **Quando si compra** | solo dopo **forward maturo** + **risposte scritte** del supporto | 🥇 regola madre di `METRO_PROP` (decisione di Claudio del 13/08 sul rinvio D3); il forward pulito parte dal 15/08 | agosto a −11% sul piccolo dice che la domanda "quando" oggi ha una sola risposta onesta: **non adesso** | 🧊 **CONGELATO (13/08/2026, decisione di Claudio: D3 in pausa, prop pagata solo dopo forward maturo)** — riguarda le CHALLENGE; per gli EA a pagamento vedi F5 |
| F5 | **Cancello d'acquisto degli EA a pagamento** (procedura) | 5 gradini in ordine, nessuno si salta: scheda prodotto → **1-bis due diligence sul VENDITORE** (Market → Google → Forex Peace Army → Forex Factory; nato dal caso XT Prop Firms: vendor con dossier FPA guilty 79-0) → setaccio bandiere (recovery = scarto anche a 10 euro) → **demo nel tester coi criteri scritti PRIMA** → verdetto col metro di casa → decisione di Claudio. Regole dure: niente sorgente = niente modifiche ne' certezze · **noleggio prima dell'acquisto dove esiste** · i numeri del venditore valgono ZERO | 🥇 `backtest_pipeline/caccia_strategie/CANCELLO_ACQUISTI_EA.md` (18/08 notte) | nessuno — e il file dichiara che F4 (challenge) resta intatto | 🧊 **CONGELATO (18/08/2026, decisione di Claudio: "se ci dovessero essere degli EA a pagamento che possono essere utili... sono disposto a pagarli" — procedura congelata prima dei casi)** |
| F6 | **Primo candidato al cancello: `Range Breakout Daytrader`** | avviare i gradini 1→3 del cancello F5 (nessun acquisto: prima scheda completa, due diligence, poi demo nel tester coi criteri congelati prima) | 🥉 raccolta §1C [VERIFICATO]: **32 preset pubblici letti** — e' la famiglia **piu' vicina alle nostre sedie di apertura** (range breakout su USDJPY/US30/XAUUSD/BTCUSD), con filtro news a 5 min, chiusura di sessione, scala di rischio pulita (protezioni identiche sui 4 profili) e il manuale che insegna il metodo CSV di D1 · setaccio §6: nessuna bandiera trovata nelle pagine lette ([INCERTO]: senza sorgente non e' escludibile) | ⚠️ riserve: **`ExtraLowRisk` = 2,4%/trade = 3,7× il nostro 0,65** (e' un input, si riscrive — ma dice come ragiona l'autore); niente sorgente, mai. 💰 Prezzo/noleggio/demo e **criteri del test** (riferiti in chat: $179, noleggio 3 mesi ~$59, demo disponibile, 3 recensioni; PF>1,2 su n≥150 per finestra, DD<9% a taglia 0,65%, 3 finestre di regime su 4 positive, noleggio prima dell'acquisto) **NON sono ancora depositati in un file del repo** → senza la scheda gradino-1 e i criteri scritti PRIMA, il cancello non parte (M10) | 📋 PROPOSTO — decisione di Claudio, gradino per gradino |

---

## 🕳️ COSA MANCA E CHI LO PORTA

| # | buco | chi lo porta | la domanda esatta |
|---|---|---|---|
| M1 | **MC con DD trailing EOD** sulle serie per-trade R16 (chiude C5, sblocca F3, ricalibra A1) | chat principale / PC backtest (misura di casa — costo zero dati nuovi) | "p95/p99 del DD trailing end-of-day del portafoglio a 0,65%: sopra o sotto il 10%?" |
| M2 | **Misura della sovrapposizione reale delle sedie** (chiude C1, poi C2 e C4) | chat principale (P3a: ~2 ore sui dati R16 + forward) | "quante sedie sono state aperte NELLO STESSO momento, e quanto rischio aperto faceva la somma, giorno per giorno?" |
| M3 | ~~Convergenze dai video~~ → ✅ **CONSEGNATO** (18/08 ~01:30, `ANALISI_TRASCRIZIONI_2026-08-18.md`): resa numerica bassa, i 4 punti caldi NON confermati dal parlato; A3/C1/D1/D2/F2 aggiornati (restano APERTI), E6 aggiunta, FundedNext 1-Step 3/6 registrato | — | — |
| M8 | **I 4 screenshot dei pannelli mostrati a video e mai dettati** (referto trascrizioni, §"Le domande per Claudio"): (1) pannello PropEA — solo per capire il meccanismo hedge, NON per usarlo; (2) **Titan X: pannello MDL + finestra news filter** — l'unico dei 4 che puo' portare un campo MINUTI per D1; (3) lista input `Prop Firm Gold EA` (motore gold time-based, affine alle nostre aperture) — ⚠️ 2ª notte: **il `.set` di questo EA non esiste pubblicamente** (verificato: c'e' solo il manuale) → lo screenshot e' l'UNICA via; (4) metriche FTMO del video BM Trading | **Claudio** (fermando i video ai punti indicati nel referto) | "screenshot del pannello, non serve il video intero — il n.2 e' quello che vale di piu'" |
| M10 | **Scheda gradino-1 del candidato F6** (`Range Breakout Daytrader`): prezzo pieno vs noleggio, attivazioni, recensioni, autore (+ due diligence 1-bis) **e i criteri del test demo scritti e congelati PRIMA di lanciarlo** (i valori girati in chat — PF>1,2 su n≥150/finestra, DD<9% a taglia 0,65%, 3 finestre su 4 — vanno messi in un file, senno' non esistono) | **cacciatore-config-prop** (scheda) + **Claudio** (congelamento criteri) | "senza scheda depositata e criteri congelati, il gradino 3 non si lancia" |
| M9 | Ri-trascrizione completa di `Why This Prop Firm EA Robot Survives Long-Term` — **il file e' TRONCATO** prima della parte col prodotto (12 righe utili) | **Claudio** (TurboScribe di nuovo sul video intero) | "la meta' mancante e' quella coi parametri, se ci sono" |
| M4 | Schede prop **[VERIFICATO]** (oggi tutte [LETTO-VIA-SEARCH]); offset server The5ers/E8; un `.mq5` completo di guardiano open-source | **cacciatore-config-prop** (quando i domini si sbloccano / GitHub esce dal 429) | "aprire le pagine ufficiali di FTMO trading objectives + Swing e datare la scheda; che UTC hanno i server The5ers e E8?" |
| M5 | **Motori con edge sufficiente**: `DOVE_SIAMO` §4 dice che oggi non abbiamo un motore che passerebbe una prop | **cacciatore-strategie** + i round di casa | il piano configura il rischio; il rendimento lo devono portare le sedie |
| M6 | Conferma che il **100k del dry-run e' ancora `50504263`** (il 17/08 un conto 109k e' stato cancellato) | **Claudio** (`conto_attivo.ps1` sul VPS) | "il giornale del terminale V3 dice 50504263 o un numero nuovo?" |
| M7 | Verifica **lotto fisso** dei due EA esterni (`BREAKOUT_EA_JPY_v3`, `DAXMasterEA_v2_0`) | Claudio/VPS (censimento gia' pronto) | rischio non controllato per definizione su un conto da 5.100 € |

## ✍️ LE FIRME CHE SERVONO A CLAUDIO (in ordine di urgenza)

1. **C3 — il criterio di uscita.** La piu' urgente e la piu' di fondo: agosto
   −11% con 28 magic e nessuno che ha il compito di spegnerne uno. I numeri
   della bozza vanno congelati PRIMA di guardare chi colpiscono.
2. **B1+B2+B3 — il pacchetto Guardian** (P2+P1, riscritto v3): **doppia
   soglia giornaliera (pausa 4,0 + emergenza 4,9)**, totale a 9,9, reset 23.
   Il principio "mai sul muro" ha 5+ fonti indipendenti e noi siamo l'unico
   caso letto che sta sul muro esatto.
3. **A2/A4 — congelare per iscritto** le due regole di taglia gia' in vigore di
   fatto (0,3% giovani, tetto 1% sul piccolo).
4. **E1 — la data di invio** delle domande al supporto (fine agosto, a forward
   pulito maturo?).
5. **F6 — il candidato al cancello**: dire si'/no all'avvio dei gradini 1-2
   (scheda + due diligence, costo zero) e congelare i criteri del test demo
   PRIMA che parta (M10).

---

## 📊 IL CONTO DEL GIRO

**34 parametri censiti: 3 congelati · 16 proposti · 15 aperti.**
Congelati: A1 (rischio 0,65%, 09/08) · F4 (niente challenge prima del forward
maturo + risposte scritte, 13/08) · **F5 (cancello d'acquisto EA a 5 gradini,
18/08 — nuovo)**. Cambi di stato del v3: **D1 APERTO→PROPOSTO** (il filtro
news e' backtestabile via CSV) · **B8 nuova APERTA** (ex buco n.8, trovato
implementato due volte) · **E7 e F6 nuove PROPOSTE** · B1/B2 riscritte
(doppia soglia, evidenza corretta). Dei 15 aperti, 4 si chiudono con misure
di casa a costo zero dati (M1, M2 + E3, E4).

---

## 📜 CHANGELOG

| data | versione | cosa e' cambiato | perche' |
|---|---|---|---|
| 18/08/2026 ~01:00 | **v1** | prima stesura: 29 parametri in 6 aree, dalle fonti elencate in testa. Incorporati: dossier config-prop 18/08 (3 preset .set veri, censimento 6 prop non verificato, 36 buchi), le 9 proposte P1-P9, il censimento rischio 17-18/08 (tre sedie al 2% corrette a 1%), DOVE_SIAMO 17/08 (agosto −11%, manca il criterio di uscita). **NON incorporata** l'analisi trascrizioni (in lavorazione): 5 parametri marcati 🎬 in attesa | non esisteva un posto unico dove i numeri della prop stessero con fonte e stato |
| 18/08/2026 ~01:15 | v1.1 | incorporato lo **script CrewAI incollato da Claudio** (rango 4): breaker 4,3-4,5% aggiunto alle fonti di B1 (quarta voce convergente sul buffer prima del muro), sizing 0,5% aggiunto ai conflitti di A1, snapshot mezzanotte broker in B3 **con la discordanza di fuso (00:00 GMT vs 00:00 CET) segnata come [INCERTO]**. Eseguita la verifica richiesta sul Guardian: riga 155 misura su **equity** → il flottante e' contato, nessun buco nuovo (resta B4 sulla baseline) | materiale nuovo in chat durante il primo giro |
| 18/08/2026 ~01:45 | **v2** | incorporato il referto dell'**analista-trascrizioni** (11 trascrizioni = 7 fonti indipendenti, resa numerica bassa). **Nessun parametro cambia valore e nessuno si chiude**: i 4 punti caldi (buffer 4/9, ora reset, minuti news, recovery dei 4 EA) NON sono confermati dal parlato → le note 🎬 su A3/C1/D1/D2/F2 passano da "in arrivo" a "risposto: niente". Novita' incorporate: **FundedNext 1-Step 3%/6%** [a voce] in F1 (daily 3% = 🔴 per il metro di casa) · rinforzo **static-not-trailing** su B5/F3 (video PropEA) · **divieto hedge multi-account FundedNext** in E2 (risposta a voce alla domanda tipo-2 D3; la nostra conferma scritta resta da fare) · **nuova riga E6**: cosa le prop rilevano (magic condiviso, input identici, tratti simili — dal video VIETATO PER NOI, tenuto come intelligence difensiva) → **30 parametri (2C · 13P · 15A)**. In COSA MANCA: M3 chiuso, **M8** (4 screenshot, Claudio) e **M9** (ri-trascrizione del file troncato, Claudio) aggiunti | consegna dell'analista-trascrizioni (commit `bd78950`) |
| 18/08/2026 ~02:15 | **v3** | incorporata la **2ª notte del cacciatore** (`CONFIG_PROP_RACCOLTA_SET_2026-08-18.md`: 50 `.set` nuovi da 11 fonti, 75 file in biblioteca) + `CANCELLO_ACQUISTI_EA.md`. **Correzione d'evidenza su B1/B2**: la "convergenza tre vendor" sul 4/9 era a DUE (Gold Phantom = Gold Reaper = Profalgo/WSC); il principio "mai sul muro" sale a 5+ fonti, il valore del buffer diverge (1,0 / 0,5 / 0,1 pt) → **B1 riscritta a DUE livelli** (pausa 4,0 + emergenza 4,9, modello Prop Firm Pass), B2 a 9,9. **D1 APERTO→PROPOSTO**: il "non backtestabile" cade — calendario esportabile in CSV ([VERIFICATO] dal manuale Range Breakout), 2 CSV 2021-2025 (37.799 righe, UTC+2: su BCM −1h) e `NewsFilter.mqh` (283 righe, zero DLL) gia' in biblioteca. **B6**: il canale di blocco esiste in natura (TIP: GlobalVariable + battito + `SiblingStaleSec=30` + `BlockIfSiblingHalted`). **B8 nuova** (ex buco n.8: zone Bullion + scala Range Breakout, soglie Bullion [INCERTO]). **C4** da 1 a 3 fonti (regola: rischio ≈ budget ÷ sedie); **C1** +2 gambe ma resta APERTO (1% / 1,5% / 3% divergenti → M2). **A3 peggiora onestamente**: Ultimate EA coi file veri NON tocca il rischio fra fasi (1,0/1,0/1,0, target 8→5→2) → 1 contro 1. **A1 confermato per contorno** (0,5 · 0,5 · 0,65 · 1,0 · 2,4). **E3**: consistency misurabile DENTRO l'EA (Best Day 50%, min days 4, start date). **E7 nuova** (igiene: 3 recovery su 8 famiglie, anti-pattern cap in valuta, protezioni mai toccate dai profili). **F5 CONGELATA** (cancello acquisti EA, decisione di Claudio 18/08) e **F6 nuova**: primo candidato `Range Breakout Daytrader` — scheda costi e criteri demo riferiti in chat ma NON ancora depositati → M10. B3: nessuna gamba nuova (0 `.set` su 50 con ora di reset). → **34 parametri (3C · 16P · 15A)** | seconda caccia consegnata (commit `a1e8b51`/`4815ed8`/`2cd983f`) |
