# STATO DELLE QUATTRO STRATEGIE DEL CORSO — 21/08/2026
_Ricostruito su richiesta di Claudio ("non ricordo cosa avevamo deciso").
Ogni riga ha la fonte. "Misurato da noi" e "detto dal corso" restano distinti._

## Tabella riassuntiva

| | EA esiste? | compilato? | in forward? | ROUND | verdetto numerico | DECISIONE ultima + data | cosa blocca |
|---|---|---|---|---|---|---|---|
| **MEDIAZIONE** | 🔴 **NO EA** (nessun `.mq5`) | — | ❌ mai | ❌ **nessun R__** | **nessun numero misurato in casa** (solo +30% dichiarato dal corso, 1 cross, 2 anni non datati, zero N) | 🟡 **DUE DECISIONI IN CONFLITTO, mai riconciliate**: (a) 12/08 DIARIO "NON si meccanizza, MAI in prop"; (b) 18/08 ANALISI corso "SI', puo' andare all'imbuto, con 6 condizioni". **Nessuna firma di Claudio su nessuna delle due.** | **M14** (voce griglia/martingala assente dal METRO_PROP, da scrivere PRIMA dei numeri) + fattore 2,29 sul sizing + frequenza mai misurata |
| **FIBO H4** | 🟢 SI' `ABTG_FiboH4_Multi.mq5` (magic 771602) | 🟢 si' (ha girato in coda fascia B) | ❌ **NO** — assente da FLOTTA_ATTIVA e da CONTRATTI_SEDIE; e' in `$KillSempre` della pulizia VPS | 🟡 **CODA FASCIA B** (10-11/08), non R-numerata | **0/8 promossi** su 8 coppie forex+oro H4 | 🔴 **BOCCIATO 11/08** ("mai piu' senza una tesi nuova") → 🔄 **VERDETTO RITIRATO DI FATTO il 18/08**: il 0/8 ha bocciato *la nostra* geometria, non quella del corso. **Ri-misura PROPOSTA, NON decisa.** + **D5 APERTA** (filtro news gia' nel codice e SPENTO) | serve **decisione di Claudio** se vale un EA nuovo dato un 0/8 in archivio; 4 richieste bloccanti; D5 legata a D1/F1 |
| **BREAKOUT del corso** | 🟢 SI' `ABTG_BreakoutCorso.mq5` (nuovo, 18/08) | 🟢 si' (autotest PASSATO nel log) | ❌ no — EA da tester. La vecchia `BREAKOUT_EA_JPY_v3` e' **SPENTA** (era gia' fantasma) | 🟢 **R82 — TORNEO JPY, CHIUSO 18/08 18:05** | **ZERO vincitori su 7 cross**. Miglior caso EURJPY IS +5.476/PF 1,112 → OOS −6.108/PF 0,902. 264-2.138 op/finestra | 🔴 **BOCCIATA con processo completo** (18/08). Sedia spenta con **FIRMA 5 di Claudio "SPEGNILE TUTTE E TRE"**, eseguita e verificata 09:41. Porta di rientro C3: **solo con una TESI NUOVA, non una taratura** | non blocca nulla: **capitolo chiuso**. Resta il collaudo `[BRK][AUTOTEST]` mai eseguito — igiene, non decisione |
| **POINT BREAK** | 🟡 SI' `standalone/ABTG_PointBreak.mq5` (magic 771101) ma **e' un'automazione del solo "cuore meccanico"**, dichiarata infedele nel suo stesso header | ❓ **nessuna traccia di compilazione** | ❌ mai — assente da FLOTTA_ATTIVA, CONTRATTI_SEDIE, `ea_config.json`, `scan_market.ps1` | ❌ **nessun R__, mai testato** | **nessun numero misurato**. Del corso: win rate 49-77% mai dichiarato; 43 coefficienti di correlazione e **ZERO regole operative** | 🔴 **"NON testabile come strategia"** (18/08). Non entra nell'imbuto: 9 pattern = immagini senza una sola definizione numerica. **3 proposte di componenti (P-PB1/2/3), "nessuna e' una decisione"** | **8 domande a Claudio aperte**; le bloccanti: fuso del PIANO, nome dell'indicatore ADR `ImpPeriods:50`, definizione numerica dei 9 pattern |

---

## SCHEDA 1 — MEDIAZIONE

**EA:** 🔴 **NON ESISTE.** Nessun `.mq5`/`.mqh` nel repo contiene la parola "Mediazione"
(grep su `mql5/` -> 0 risultati). Non e' in `ea_config.json`, non e' in `scan_market.ps1`.
**Forward:** mai. Nessuna riga in `FLOTTA_ATTIVA.md` ne' in `report/CONTRATTI_SEDIE.md`.
**Round:** 🔴 **NESSUNO.**

**Cosa e' MISURATO da noi:** **niente.** Zero backtest, zero tick, zero screening.
**Cosa e' DETTO DAL CORSO:** +30% su un solo cross, in due anni non datati, senza N,
senza win rate, con lo scenario a 3% ottenuto moltiplicando a mano per 3 — *ammesso
dalla relatrice*.
> `ANALISI_CORSO_MEDIAZIONE_2026-08-18.md:395-405` — *"I «profitti ottimi» del mandato
> NON esistono ancora come dato... **Se questa strategia dara' profitti ottimi lo dira'
> il nostro tester. Oggi non lo sa nessuno.**"*

### Le due decisioni in conflitto (entrambe agli atti, mai riconciliate)

**1) 12/08 — verdetto negativo secco**, ma su una cosa diversa (la pratica di Emiliano,
non il modulo del corso):
> `report/DIARIO.md:88` — *"🚩🚩 «Mediazione»: mai insegnata col suo nome ma praticata da
> Emiliano come coperture/martingala (conto 10k bruciato a luglio, sessione 03/08 da
> +1.200 a −800): **verdetto scolpito, NON si meccanizza, MAI in prop.**"*

**2) 18/08 — verdetto tecnico positivo**, sul modulo vero (lezioni 26-33), dopo che le
trascrizioni sono arrivate:
> `ANALISI_CORSO_MEDIAZIONE_2026-08-18.md:378-381` — *"✅ **SI', PUO' ANDARE ALL'IMBUTO**
> — e per una volta il motivo e' tecnico, non di fiducia: e' la prima strategia di questo
> corso che possiamo implementare **AL 100% NELLA SUA MATEMATICA** senza chiedere niente
> a nessuno."*

Con setaccio letto riga per riga:
> `:234` — *"`[T]` lez. 31: «propriamente appunto un sistema di Martingala». **E' la
> bandiera n.1 del §4, e c'e'.**"*
> `:245-252` — *"**VERDETTO DI SETACCIO:** la mediazione inciampa nella bandiera n.1...
> **ma supera tutte le sotto-bandiere che normalmente rendono una griglia letale**: stop
> vero, cap, perdita massima nota. **E' il caso raro in cui la bandiera va letta, non
> applicata a vista.**"*

> ⚠️ **NON DECISO, nessuna traccia:** non esiste **nessuna firma di Claudio** ne' sulla
> riconciliazione delle due letture, ne' sull'apertura di un round Mediazione.
> `report/FIRME_2026-08-18.md` non la nomina.

### Le 6 condizioni non negoziabili poste dall'analisi (`:384-394`)
1. sciogliere il **fattore 2,29** sul sizing
2. parametri SuperTrend dichiarati come **assunzione NOSTRA**
3. **l'unita' di conto e' il PACCHETTO, non il ticket** (un pacchetto = fino a 6 ticket:
   contare ticket gonfia il campione x6)
4. le 3 coppie sono un **triangolo chiuso**, non 3 conferme indipendenti
5. il setaccio deve leggere la **CODA**, non solo PF e max DD
6. misurare **PRIMA la frequenza** — su H1 con Williams 140 i segnali potrebbero essere
   pochissimi, e sotto 150 pacchetti IS il giudizio di merito e' sospeso

### COSA BLOCCA — M14, aperta e assegnata
> `report/PIANO_PROP.md:227` — *"**Il METRO_PROP non ha la voce griglia/martingala**...
> Le prop la vietano (FundedNext: GRID vietato [dichiarato]; flottante di griglia vs muro
> giornaliero = bomba). **Se mai andasse all'imbuto, il metro va scritto PRIMA dei
> numeri** — regola di casa"* · responsabile: *architetto-prop + **Claudio** (congelamento)*.

> 🆕 **AGGIORNAMENTO 21/08 (architetto-prop):** M14 e' **chiusa a meta'** — la voce
> esiste: `report/METRO_PROP.md` **§13 GRIGLIA / MARTINGALA** (bozza da firmare,
> commit `0a787ca`). Resta il **congelamento di Claudio** e resta aperta la meta'
> "quali prop la ammettono **per iscritto**" (nel repo c'e' solo una voce di 4°
> rango). I due verdetti in conflitto sono ora **riconciliati e pronti per la
> firma** in `report/NODO_MEDIAZIONE_2026-08-21.md` (vertono su **due oggetti
> diversi**; opzioni **A = ARCHIVIA · B = IMBUTO · C = FREQUENZA**).

Blocchi secondari: il fattore 2,29, la base del volume (`[BUCO] parziale`, l'unico anello
che non chiude), gli orari/sessioni (`[BUCO] vero`), i parametri SuperTrend mai dettati
(M15b: il file `super trend.ex4` della lezione 10, chiesto a Claudio).

---

## SCHEDA 2 — FIBO H4

**EA:** 🟢 `mql5/Experts/ABTG_FiboH4_Multi.mq5`, magic **771602** + variante standalone
`ABTG_FiboH4.mq5` (771601). Integrato nella pipeline (`scan_market.ps1:171`,
`ea_config.json:526`).
**Compilato:** si' — ha girato 8 mercati nella coda fascia B.
**Forward:** ❌ **NO.** Non compare in `FLOTTA_ATTIVA.md` (l'unico "Fibo" e' `ORB_Fibo` su
Nasdaq M5, motore diverso) ne' in `report/CONTRATTI_SEDIE.md`. E' in `$KillSempre` di
`backtest_pipeline/pulizia_vps.ps1:52`.

**ROUND:** coda fascia B del **10-11/08** (48 lavori, non R-numerata).
> `REFERTO_CODA_FASCIA_B.md:30` — *"| **ABTG_FiboH4_Multi** | **0/8 promossi** | — | Zero
> promozioni su 8 coppie forex+oro H4. **Mai piu' senza una tesi nuova.** |"*

### Il ribaltamento del 18/08 — il 0/8 NON e' un verdetto sulla strategia del corso
> `ANALISI_CORSO_FIBOH4_MEDIA200_2026-08-18.md:45-48` — *"**Il nostro `ABTG_FiboH4_Multi`
> non implementa la strategia del corso. Implementa una strategia diversa che porta lo
> stesso nome. Il «0/8 promossi» della fascia B ha bocciato la NOSTRA geometria, non
> quella insegnata — e non lo sapevamo perche' nessuno aveva mai letto le lezioni.**"*

Le tre divergenze **misurate** (`:53-57`):
| divergenza | il nostro EA | il corso | fattore |
|---|---|---|---|
| distanza degli ordini | **1,0 x range** | **0,10 x range** | ~**x10** |
| target | estremo opposto | livello **100** | **x2,1** |
| stop | 4,236 fisso (il piu' largo dei 7) | uno dei 7 metodi, mai messo a sweep | ~**x4** |

Conseguenza aritmetica (`:59-62`): *"la gamba EZ1 dell'EA ha un **R:R strutturale di
0,80** -> le serve **win rate > 56%** solo per pareggiare, prima di spread e commissioni"*.

Verdetto d'imbuto: 🟡 *"**SI', MA SOLO COME RI-MISURA**"*, meccanizzabilita' **50% secco /
79% con 8 assunzioni dichiarate**.

> ⚠️ **NON DECISO:** la ri-misura resta **proposta, non azione** — `:311-321`: *"⚠️
> **Costo:** non e' un ritocco di parametri, e' **un EA diverso**. **Va deciso se vale,
> dato un 0/8 gia' in archivio.**"* e `:283`: *"🔒 Nessuna modifica applicata. Nessun round
> lanciato."*

### D5 — l'unica riga di piano dedicata (APERTA)
> `report/PIANO_PROP.md:181` — *"il modulo FiboH4 e' **il piu' prop-compatibile del corso
> intero**: filtro news **OBBLIGATORIO**, overnight vietato (cancella alle 18:30-19),
> weekend «mai e qua dico mai». 🔎 E la scoperta di casa: **il nostro `ABTG_FiboH4_Multi`
> il filtro CE L'HA GIA', a CSV, ed e' SPENTO** (`InpUseNewsFilter=false`)... | 🔓 APERTO
> — accensione legata a D1/F1; il costo di sviluppo e' ~zero perche' il codice c'e'"*
Verificato nel sorgente: righe 74-80 -> `InpUseNewsFilter = false`,
`InpNewsFile = "abtg_news.csv"`, impatto/minuti configurabili.

### COSA BLOCCA
- **Decisione pendente di Claudio**: vale un EA nuovo con la geometria del corso, dato un
  0/8 in archivio?
- **4 richieste bloccanti** (`:258-275`): (1) **le slide di entrambi i moduli** — citate
  10 volte, mai lette (sul Breakout le slide alzarono la meccanizzabilita' dal 71% all'87%);
  (2) screenshot del Fibonacci con la linea **100** visibile -> chiude il fattore 2,1;
  (3) screenshot del pannello Fibo con le 4 descrizioni -> chiude il fattore 10;
  (4) il **fuso** della piattaforma -> gli orari 08:00 / 18:30-19:00 sono inutilizzabili senza.
- **3 assunzioni pesanti da scrivere PRIMA dei numeri**: "la fine di un trend" mai definita;
  quale dei 7 stop (cambia il rischio ~x4); la % di rischio mai pronunciata -> si usa lo
  **0,65% di casa**, ❌ non l'1% preso in prestito dal modulo Breakout.
- D5 e' subordinata a **D1** (filtro news di conformita') e **F1** (prop di riferimento).

---

## SCHEDA 3 — BREAKOUT DEL CORSO (i cross JPY)

**EA:** 🟢 `mql5/Experts/ABTG_BreakoutCorso.mq5` — costruito il 18/08 come implementazione
**fedele** della spec, con mappa regola<->codice in testa al sorgente.
SHA256 agli atti: `8ab269c0...ffeac3`.
**Compilato:** si' — **autotest del test-case del corso PASSATO** nel log.
**Forward:** ❌ no, e' un EA da tester. Predecessore `BREAKOUT_EA_JPY_v3` su USDJPY: **SPENTA**.

**ROUND:** 🟢 **R82 — TORNEO JPY**, chiuso **18/08/2026 18:05**. Criteri congelati prima in
`prove/TORNEO_JPY_CRITERI.md`. Screening OHLC-M1, finestra identica per tutti
(2007.02.12->, IS/OOS al 2014.11.13), deposito 10k, 1%/op. Igiene 14/14, gemelle identiche.

| cross | IS profit | IS PF | OOS profit | OOS PF | trade IS/OOS |
|---|---:|---:|---:|---:|---|
| USDJPY | −6.643 | 0,783 | −7.765 | 0,884 | 927 / 2.138 |
| EURJPY | **+5.476** | **1,112** | −6.108 | 0,902 | 895 / 2.068 |
| GBPJPY | −704 | 0,942 | −1.684 | 0,980 | 264 / 1.467 |
| AUDJPY | −3.634 | 0,888 | −8.394 | 0,839 | 687 / 2.059 |
| CHFJPY | −2.732 | 0,861 | −8.730 | 0,769 | 493 / 1.782 |
| CADJPY | −4.219 | 0,802 | −7.878 | 0,831 | 566 / 2.063 |
| NZDJPY | −5.062 | 0,722 | −8.228 | 0,817 | 502 / 1.966 |

> *"**ZERO vincitori**: nessun cross positivo in entrambe le finestre -> NIENTE giro 2.
> «Zero e' un verdetto valido» era scritto prima, ed e' successo."*
> *"**Ipotesi A dimostrata a livello screening**: il **+133% della lez. 39 non si riproduce
> su nessun cross** con l'implementazione fedele."*
> *"**EURJPY, l'unico lampo**: positivo 2007-2014, negativo 2014-2026. Profilo dell'edge
> mangiato dal mercato."*

### DECISIONE — la piu' completa delle quattro, in due atti
**1) 18/08 mattina — FIRMA 5 di Claudio, parola esatta "SPEGNILE TUTTE E TRE"**
(`report/FIRME_2026-08-18.md:92-102`), prima applicazione del criterio di uscita C3.
Eseguita e verificata alle **09:41**: il segugio ha provato che era gia' un **FANTASMA** —
viveva solo in `Profiles\Charts\Default\chart02.chr`, ultima modifica 20/07/2026: **non
girava da un mese**. Censimento 44,55% -> 43,30%, esatta al decimale.
Motivo agli atti (`CONTRATTI_SEDIE.md:46`): *"**NESSUNO** — famiglia **SCARTATA**
pre-progetto (paniere 7 cross JPY 2022-24: **−20.853 EUR, PF 0,67-0,95 su TUTTE, DD
30-48%**); della v3 non esiste alcun referto"*.

**2) 18/08 sera — R82 chiude la porta di rientro con un numero:**
> *"**La sedia BREAKOUT_JPY resta spenta con processo completo alle spalle.** Porta di
> rientro C3: **solo con una tesi NUOVA, non con una taratura.** La regola di portafoglio
> «**max UNA sedia dalla famiglia JPY**» resta firmata e in vigore."*

**Nota di qualita':** la spec e' la piu' solida del corpus — meccanizzabilita' **87%**
(era 71%) dopo l'arrivo delle slide; Williams **140** chiuso da Claudio che ha ri-ascoltato
il video il 18/08; SuperTrend dichiarato come assunzione nostra su sua decisione.

**COSA BLOCCA:** 🟢 **niente — capitolo chiuso con processo completo.** Residui di igiene:
il collaudo `[BRK][AUTOTEST]` mai prodotto (*"F7 compila e basta, non esegue niente"*) e il
`.chr` residuo da sfrattare.
**Limite dichiarato dal round:** screening OHLC-M1 — l'OHLC non da' verdetti di promozione,
ma qui il verdetto e' di **NON** promozione su segno negativo unanime con campioni enormi,
quindi la clausola di segno si applica in pieno. Il DD 70-89% e' artefatto della cella di
screening, non stima d'esercizio.

---

## SCHEDA 4 — POINT BREAK

**EA:** 🟡 `mql5/Experts/standalone/ABTG_PointBreak.mq5`, magic **771101**. Ma l'EA dichiara
da solo di non essere la strategia — header righe 7-18:
> *"La strategia e' **DICHIARATAMENTE DISCREZIONALE** e basata su **PATTERN GRAFICI VISIVI**
> (Montagna, W, M, Chiesa, Orecchie di Lupo, Testa e Spalle) che **NON sono automatizzabili
> in modo fedele**. Questo EA automatizza **il solo CUORE MECCANICO** della checklist
> d'ingresso... **I PATTERN e i supporti/resistenze restano all'occhio umano.**"*
Implementa: Bollinger **(37, 1.4)**, Stocastico **(5,3,3)**, EMA200 distante, TP = media
delle Bollinger con RR >= 1:1, SL su spike + floor ATR.

**Compilato:** ❓ **nessuna traccia.** **Forward:** ❌ mai. Il magic 771101 compare in **un
solo file** dell'intero repo. **ROUND:** ❌ nessuno, mai.

**Cosa e' MISURATO da noi:** 🔴 **niente, zero.**

### DECISIONE — 18/08 sera: non testabile come strategia
> `CATALOGO_STRATEGIE_CORSO.md:58-60` — *"i pattern sono davvero «a occhio» (**9 figure,
> zero definizioni numeriche**) -> **Point Break NON e' testabile come strategia.**"*
> `ANALISI_POINTBREAK_2026-08-18.md:871-876` — *"Senza definizione geometrica **non c'e'
> niente da codificare**, e inventarla noi significherebbe testare una nostra invenzione
> con l'etichetta del corso — **l'errore che il metodo di casa vieta.**"*
> `:38-45` — *"❓ «Il corso ha regole di correlazione QUANTITATIVE?» -> 🔴 **NO.** Il PDF
> CORRELAZIONI contiene **43 coefficienti numerici** e **ZERO regole operative**... **Non
> c'e' un solo verbo all'imperativo in tutto il documento.**"* — e due dei tre pezzi si
> smentiscono da soli: la matrice contraddice le tabelle, e **una riga e' aritmeticamente
> impossibile**.
> `report/PIANO_PROP.md:336` — *"**Point Break**: correlazioni del corso aritmeticamente
> rotte — **corroborazione di 4° rango** della nostra regola JPY, **nessuna riga si riapre**."*

### Le 3 proposte superstiti — esplicitamente NON decisioni
- 🥇 **P-PB1** — pavimento di volatilita' sullo stop:
  `SL = max( swing +- 10..15 pip , ADR(50) + 10..15 pip )`.
  ⚠️ **Prerequisito bloccante**: sapere QUALE indicatore e' la "Volatilita' Media
  Giornaliera · ImpPeriods: 50".
- 🥈 **P-PB2** — filtro *"EMA200 lontana >= 100 pip"* come condizione di **NON** ingresso:
  *"e' l'**esatto opposto** del nostro `ABTG_EMA200` (sedia 12, promossa con 30/30 in R29)
  ... **le due letture non possono essere entrambe giuste sullo stesso mercato e
  timeframe** -> e' una domanda misurabile"*.
- 🥉 **P-PB3** — Bollinger (37, 1.4) come cella di confronto nella famiglia Breaking Band.
> `:910` — *"**Nessuna delle tre e' una decisione**: sono proposte, e la parola e' di Claudio."*

### COSA BLOCCA — 8 domande a Claudio, mai risposte. Le bloccanti:
1. 🔴 **In che FUSO e' scritto il PIANO DI TRADING?** — *"Un orario col fuso sbagliato e'
   peggio di nessun orario"*
2. 🥇 **Esiste una lezione/video sulle correlazioni?**
3. 🔴 **Quale oscillatore e' quello vero?** (il PIANO dice Stocastico 5/3/3; lo screenshot
   ufficiale mostra "Elliott Wave False Breakout Stochastic")
4. 🔴 **Nome e file dell'indicatore ADR `ImpPeriods:50`** — prerequisito di P-PB1
5. 🔴 **I 9 pattern hanno una definizione numerica da qualche parte?** — decide se Point
   Break e' testabile come strategia o solo come due componenti
6. 🔴 **"METODI DI GESTIONE OPERAZIONI NEGATIVE" e' informativo o raccomandato?** — nella
   seconda ipotesi il framework e' **inutilizzabile in prop** in blocco (5 bandiere rosse
   su 6 metodi; il metodo 4 e' grid **senza SL**)

---

## Nota trasversale — il filo rosso, e cosa NON risulta da nessuna parte

**Il filo rosso misurato sui sei moduli del corso** (`PIANO_PROP.md:336`, v10 del 18/08):
> *"**l'uscita e' il pezzo sempre indeterminato del corso**"*
Vale per Mediazione, Breakout, Fibo H4, Media 200, Point Break. Rafforza la linea di casa
del "processo alle uscite" aperto da R81 (**M13**, oggi bloccata dal cancello ZERO di M12).

**Nessuna delle quattro e' in coda operativa al 21/08.** `CODA_PROSSIMA_SESSIONE.md` in
testa ha: passo 0 tick U30USD -> R90 -> R91 (letto: cancello RR **bocciato**) -> **R92
BULGE** (firmato il 21/08).

**Cio' che NON risulta scritto da nessuna parte — e va detto:**
- **Mediazione**: nessuna riconciliazione fra il "MAI in prop" del 12/08 e il "puo' andare
  all'imbuto" del 18/08. Nessuna firma. Nessun EA.
- **Fibo H4**: nessuna decisione su *"vale un EA nuovo dato un 0/8 in archivio?"*.
- **Point Break**: nessuna decisione sulle tre proposte P-PB1/2/3; nessuna prova che l'EA
  771101 sia mai stato compilato.
- **Breakout**: nessun buco decisionale — e' l'unica delle quattro con il ciclo completo
  firma -> misura -> verdetto -> esecuzione verificata.
