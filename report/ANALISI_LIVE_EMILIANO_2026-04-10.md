# 🎙️ ANALISI — LIVE EMILIANO + PAOLO SCAGLIONE del 10/04/2026

**Fonte, e unica fonte**: `trascrizioni/LIVE_EMILIANO_2026-04-10.txt` (208 righe,
caricata da Claudio il 21/09/2026).
**Domanda di Claudio**: *"analizzala e vedi se c'e' qualcosa di interessante"*.
**Bussola**: quanto avvicina una **sedia schierabile**. Il resto scala.

> 🔴 **Regola che vale per tutto il documento**: ogni affermazione porta il **numero
> di riga**. Nessun numero della live e' MISURATO: sono tutti **DICHIARATI** da un
> relatore in diretta, e non diventano mai un criterio di casa.
> ⚠️ La trascrizione e' automatica e **sbaglia le parole**: `SMP` (r.5, probabilmente
> S&P500), `VPUUP` (r.11, probabilmente VWAP), `intradio range` (r.15), `cadilla di
> rifiuto` (r.123, probabilmente *candela di rifiuto*), `supertrello` (r.123,
> *supertrend*), `piano a sette fasi` (r.95), `500 rubi` (r.39, probabilmente
> *500 punti*), `menini da notte` (r.95, *minimi della notte*). Dove il senso e'
> ambiguo lo **dichiaro**, non lo indovino.

> 📌 **NOTA SUI NUMERI DI RIGA DEI SORGENTI.** Tutte le righe di codice citate sono
> state **riverificate con `grep` il 21/09/2026** sul branch `lavoro`.
> 🔴 **Avvertenza**: durante questa analisi `mql5/Experts/ABTG_DAX_Apertura_EU.mq5`
> risultava **modificato nell'albero di lavoro da un'altra sessione** (`git status`:
> ` M`), e le sue righe si sono spostate di ~12 posizioni a meta' analisi. I numeri
> qui sotto sono quelli **dell'albero di lavoro al momento del referto**; se non
> tornano, si cerchi per **nome dell'input o della funzione**, che non cambia.
> Gli altri sei sorgenti citati erano **puliti** (nessuna modifica pendente).

---

## 📍 NOTA DI LETTURA: le righe 93 e 95 sono due MURI

La trascrizione ha due paragrafi giganteschi, **r.93 e r.95**, che da soli contengono
la meta' del contenuto operativo della live. Claudio nel brief ha attribuito a r.93
alcune citazioni che in realta' stanno a **r.95** (la "correzione", i "59 punti", i
"10 contratti", la "media 200 mai senza supporto", il "culetto fuori"). **Le ho
riassegnate alla riga giusta, verificandole una per una con `grep`.** Non e' pedanteria:
se un domani si rilegge il file, una riga sbagliata e' una citazione che non si trova.

---

## 🧭 IDENTIFICAZIONE

| campo | valore | riga |
|---|---|---|
| **Relatori** | Emiliano (che conduce), **Renzo** (l'allievo che opera in diretta), **Paolo Scaglione** (r.93 *"mi potete dire chi e' che ha fatto i minimi? Paolo, hai fatto i minimi? **Paolo Scaglione** non li ho fatti ho fatto l'orbe"*), **Luca Benedini** (r.93), **Gavo/Gabu/Giovanni** (r.95), **Giorgia** (r.95, r.185), Marco, Matte, Ciro | r.93, r.95, r.133 |
| **Strumento** | **DAX** — r.95: *"ora oggi che cazzo puo' fare il **Dax**"*. Piu' un'analisi iniziale su `SMP` = S&P500 `[TRASCRITTO dubbio]` | r.5, r.95 |
| **Broker citato** | 🟢 **BCM** — r.95: *"dico, ragazzi **su BCM**, i minimi e i massimi devono essere uguali almeno i minimi e i massimi, quindi 710 e' 710"*. **E' il nostro stesso broker.** Il senso della frase resta `[INCERTO]`: sembra un invito a verificare che i livelli coincidano fra il loro feed e BCM | r.95 |
| **Esito operativo** | Emiliano **entra male, va in drawdown, e chiude in pari**; Renzo **non entra**; Luca **non viene eseguito**; Gabu entra sulle bande. La live e' quasi tutta **studio**, non operativita' | r.95, r.135, r.175 |
| **Fuso orario** | ❌ **MAI DICHIARATO.** L'unico orario e' *"notizie alle **14.30** ... c'e' il **CPI**"* (r.47). Il CPI USA esce alle 08:30 ET; in aprile 08:30 EDT = 14:30 CEST, quindi 14:30 e' **verosimilmente ora italiana** → **13:30 ora server BCM**. 🔴 **Ma il fuso non e' detto nel parlato**, quindi resta `[INCERTO]` e **non si travasa in nessun `.ini`** | r.47 |

---

# 1. 🔧 I MECCANISMI CODIFICABILI

Dodici meccanismi trovati. I quattro del brief di Claudio sono tutti confermati alla
riga; **ne ho trovati altri otto**. La colonna "ce l'abbiamo?" e' verificata con `grep`
sui sorgenti, non a memoria.

---

## 🔴 M1 — IL FILTRO DELLO SPAZIO — *il pezzo che vale tutta la live*

### Le citazioni, tutte

| # | citazione | riga | numero |
|---|---|---|---|
| 1 | *"Vai a fare l'analisi multi-frame. **Siamo in H1, vai in H4. In H4 c'e' spazio per portare del profitto?** C'abbiamo subito la media."* | **r.71** | — |
| 2 | *"Cosa puo' succedere? **C'e' poco spazio. Allora, non si puo' fare.** Ovviamente, in maniera cautelativa, e' giusto tirare il suo piede dall'acceleratore."* | **r.73** | — |
| 3 | *"Perche' c'e' traffico sotto i minimi della notte c'e' traffico, **30 punti**, giusto? **Secondo me sono pochini.**"* | **r.83** | **30 pt = poco** |
| 4 | *"i minimi da notte oggi non li farei perche' **c'e' poco spazio** ma **poco spazio sono circa 30 punti 26 punti in realta'** la media dovrebbe sostenere la media in H4 anche se la media e' a 14"* | **r.93** | **26-30 pt = poco** |
| 5 | *"poi quando piazzo l'ordine **non mi basta vedere che ce l'ho in H1 vado in H4, in H4 c'e' spazio per scendere**, si c'e' un po' di spazio ma questa zona in realta' la vedo pericolosa"* | **r.93** | — |
| 6 | *"nell'analisi di [multi] time frame, poi vado a vedere **in D1 abbiamo dello spazio**, quindi mi sono posizionato in D1"* | **r.93** | — |
| 7 | *"noi non vogliamo essere in operazione per **30 punticini** dove dobbiamo essere subito li' pronti a chiudere"* | **r.95** | **30 pt** |
| 8 | 🟢 **E IL LIMITE DALL'ALTRA PARTE**: *"quanti punti sono? Sono tanti. **Sono 170 punti.** Se dovessimo andare a questo livello qua, nel prezzo attuale sono **500** [punti], **e' troppo distante**"* | **r.37-39** | **170 / 500 pt = troppo** |
| 9 | *"710 e' 710 **troppo distante** perche' io il livello, se lo voglio fare qua ... devo trovare un livello di massimi e minimi contrapposti, cosa che non c'e'"* | **r.95** | `[TRASCRITTO dubbio]` |
| 10 | La sintesi che il relatore stesso fa del metodo: *"come si limitano i rischi? **i rischi si limitano andando a fare l'analisi multi time frame individuando la direzione del mercato e andando a vedere i possibili ostacoli**"* | **r.95** | — |
| 11 | E il catalogo degli ostacoli: *"**gli ostacoli sono le medie, i super trend**, cioe' dove il mercato si puo' fermare, dove il prezzo si puo' fermare"* | **r.95** | — |

### 📐 LA SPECIFICA, scritta perche' un EA la possa implementare

> **Nome di casa proposto: `SPAZIO` (headroom band verso l'ostacolo dinamico).**
>
> | elemento | come lo dice la fonte | riga |
> |---|---|---|
> | **quando si valuta** | **PRIMA di piazzare l'ordine**, non dopo (*"se io metto l'ordine pendente ... vai a fare l'analisi multi-frame"*) — e' un **veto d'ingresso** | r.69-71 |
> | **da dove si misura** | dal **prezzo d'ingresso** (il livello dove sta il pendente), non dal prezzo corrente | r.93 |
> | **verso dove** | **nella direzione del trade** (per uno short: l'ostacolo SOTTO) | r.93 |
> | **quale ostacolo** | 🟢 **medie mobili e Supertrend**, esplicito a r.95. Nella live nominate: **EMA 14 / 50 / 100 / 200** (r.87, r.93) e **Supertrend a 3 livelli** (r.29, r.43) | r.95 |
> | **su quale TF** | 🔴 **il TF SUPERIORE, a scala**: opero in H1 → guardo **H4** → se H4 e' stretto guardo **D1** (*"Siamo in H1, vai in H4"* r.71; *"non mi basta vedere che ce l'ho in H1 vado in H4"* r.93; *"in D1 abbiamo dello spazio"* r.93) | r.71, r.93 |
> | **soglia BASSA** | **~26-30 punti indice DAX** = "poco spazio" → **non si entra** | r.83, r.93 |
> | **soglia ALTA** | **170 punti = "tanti"**, **500 punti = "troppo distante"** → non si piazza neanche | r.37-39 |
> | **forma della regola** | 🔴 **E' UNA BANDA, NON UN PAVIMENTO.** Serve spazio *abbastanza*, ma un livello *troppo lontano* viene scartato anche lui | r.39 + r.83 |

### ✅ CE L'ABBIAMO? — **NO. E questa e' la risposta piu' interessante del documento.**

Verificato con `grep` su tutti i sorgenti (`mql5/Experts/`, worktree esclusi):

| cosa c'e' da noi | cosa fa | perche' **NON** e' M1 |
|---|---|---|
| `SRBlocked()` / `InpUseSRFilter` / `InpSRProximityPts=1500` — `ABTG_Apertura_3Ingressi.mq5` r.380-384 e r.2097-2136 · `ABTG_Nasdaq_Apertura_US.mq5` r.361-365 e r.1982 | veta l'ingresso se c'e' un ostacolo davanti entro N punti | 🔴 gli ostacoli sono **solo PDH/PDL e numeri tondi** (r.2111-2122: `iHigh(_Symbol,PERIOD_D1,1)` + `MathCeil(entryPx/step)*step`). **Nessuna media, nessun Supertrend.** E **nessun TF superiore**: e' tutto sul simbolo, senza scala |
| `InpFilterTF = PERIOD_H4/H1` + `iMA(...)` — `ABTG_Dow_Apertura_US.mq5` r.262/405-406 · `ABTG_Nasdaq_Apertura_US.mq5` r.241/459 · `ABTG_Apertura_3Ingressi.mq5` r.291/602 | filtro **di DIREZIONE**: EMA veloce sopra/sotto la lenta sul TF superiore | 🔴 e' un filtro di **BIAS**, non di **DISTANZA**. Non misura **mai** quanti punti ci sono fra l'ingresso e la media |
| `InpMinRR` / `InpGapMinRR` — `ABTG_AltaVelocita.mq5` r.167 · `ABTG_Apertura_3Ingressi.mq5` r.285 · `ABTG_BreakingBand.mq5` r.335 · `ABTG_EMA200.mq5` r.56 | veta se il rapporto rischio/rendimento e' sotto soglia | 🟠 e' il **cugino piu' vicino**, ma il denominatore e' lo **stop**, non l'ostacolo: un TP fissato a 3R passa il cancello anche con la EMA200 di H4 a 5 punti |
| `InpMinDistAtr=0.3` / `InpMaxDistAtr=1.5` — `ABTG_EMA200.mq5` r.42-43 | banda di distanza **dalla media su cui si entra** | 🟠 stessa forma matematica (una **banda**!) ma misura la distanza **verso il livello d'ingresso**, non lo **spazio davanti** |
| `InpRoundMinDistPts=50` — `ABTG_DAX_Apertura_EU.mq5` r.343 | distanza minima per **validare un numero tondo come target** | 🟠 sceglie il target, non veta il trade |
| Sonde `ABTG_SondaM0PB` r.72 (*"Quanto spazio ha davanti quel rientro, in PUNTI INDICE?"*), `ABTG_SondaLondonFx` r.94, `ABTG_SondaRsiEmaV8` r.131 | misurano lo spazio davanti a un segnale | ✅ **il metodo di misura esiste gia' in casa**, ma e' spazio verso un **massimo recente**, non verso un **ostacolo dinamico sul TF superiore** |

> ## 🟢 **VERDETTO M1: il meccanismo e' NUOVO per noi in TRE dimensioni contemporaneamente — l'insieme degli ostacoli (medie + Supertrend invece di PDH/PDL+tondi), il TF (superiore a scala invece dello stesso), e la forma (banda min-E-max invece di soglia singola).**
> 🔴 **E c'e' un precedente che va detto subito, prima di entusiasmarsi: R30.**
> Il 12/08 abbiamo misurato `InpUseSRFilter` sul Nasdaq — che e' il **parente stretto**
> di M1 — e l'abbiamo **BOCCIATO con la 20ª apparizione del ribaltamento**:
> in campione la cella piu' bella del lotto (**+221, PF 1,27, DD dimezzato**), fuori
> campione **l'unica rossa** (**−57, PF 0,97**), tagliando il **13% dei trade**, e
> tagliando quelli buoni (`backtest_pipeline/risultati_archivio/REFERTO_ROUND30_REGALI_AMICO.md`
> r.20, r.28, r.33-37).
> 👉 **R30 non chiude M1** — ha misurato un insieme di ostacoli diverso su un TF
> diverso — **ma alza l'asticella della prova**, e la proposta in §5 ne tiene conto.

---

## M2 — LA CONFERMA PER APERTURA DI CANDELA FUORI DAL RANGE

| citazione | riga |
|---|---|
| *"la conferma di tutto e' scendo in time frame e vado a vedere **la candela che mi ha aperto il siderino sotto** [= il corpo/l'apertura sotto]"* | **r.95** |
| *"noi **aspettiamo sempre l'apertura della candela sotto fuori, quindi col culetto fuori dal massimo o dal minimo della candela dell'M15**, lo aspettiamo sempre"* | **r.95** |
| *"effettivamente **si aspetta l'apertura della candela sotto**"* | **r.95** |
| 🔴 **e qui la fonte alza il TF**: *"non abbiamo ancora la conferma, secondo me. Dove abbiamo la conferma? **E' quando aprira' piu' sopra, almeno in H1**"* | **r.145** |
| *"piano C va oltre il supertrend **mi apre col culetto sopra** questa zona, cambia completamente la struttura"* | **r.95** |

### ✅ CE L'ABBIAMO? — **SI', ed e' LA STESSA COSA. Verificato riga per riga.**

`ABTG_DAX_Apertura_EU.mq5` r.1374-1484, `MonitorOpenConfirm()`:

- r.1421 `double op = iOpen(_Symbol, octf, 0);` → guarda l'**APERTURA** della candela
- r.1434-1441 `buyTrig = gRangeHigh+gBuffer` … `if(... op >= buyTrig) dir=+1; if(... op <= sellTrig) dir=-1;` → entra **solo** se l'apertura e' gia' oltre il livello + buffer
- r.1418 `if(bt==gLastOCBar) return;` → una valutazione per candela
- r.1415 `octf = (InpOCTimeframe==PERIOD_CURRENT) ? Period() : InpOCTimeframe;` → **il TF della conferma e' una manopola** (`InpOCTimeframe`, r.278)

E il commento al codice cita gia' la fonte: r.1374 *"OPENCONFIRM — la regola come la
descrive Emiliano nelle live"*, con la motivazione misurata (r.1385-1388): il 04/08
lo sweep d'apertura ha preso i due `Live5m` **perche' avevano pendenti appoggiati al
livello** (DAX stoppato in **61 secondi**, Nasdaq in **20 secondi** dopo aver venduto
133 punti sopra il massimo notturno); *"una candela che APRE oltre non puo' essere
prodotta da uno sweep: lo sweep e' intra-candela"*.

> 🟢 **Stesso meccanismo, stessa motivazione, gia' in codice.** `ABTG_Dow_Apertura_US`,
> `ABTG_Nasdaq_Apertura_US` e `ABTG_Apertura_3Ingressi` lo hanno tutti.
> 🆕 **L'UNICA cosa nuova e' r.145: la conferma "almeno in H1"**, che in casa nostra e'
> esattamente `InpOCTimeframe`. **E c'e' una tensione dentro la fonte stessa**: r.95
> dice M15, r.145 dice *"almeno in H1"*. `[INCERTO]` quale dei due sia la regola —
> e la tensione **e' la cosa utile**, perche' dice che il TF della conferma e' una
> **manopola vera anche per loro**, non una costante.

---

## M3 — MINIMI/MASSIMI DELLA NOTTE + 10 PUNTI

| citazione | riga |
|---|---|
| *"Se dovessimo applicare la strategia dei minimi da notte, prima di tutto cosa faccio? **Metto un ordine pendente di 5, sempre rispetto allo stop, e lo metto sotto i minimi da notte di circa 10 punti**, questa e' la strategia che noi utilizziamo, cosi' la ripasso per tutti"* | **r.93** |
| *"prendo i minimi da notte e **prendo 10 punti**"* | **r.93** |
| *"**I minimi importanti generati durante la notte nella sessione.** ... ma questi minimi della notte servono anche durante la giornata? **Si', e' un livello di prezzo importante**"* | **r.75-77** |
| *"**lo stop lo metti sotto il minimo della candela** ... certo non subito sotto ma lo metti a **circa 10 punti**"* | **r.93** |
| *"sotto non lo mettiamo appiccicato al minimo ... lo mettiamo **circa 5-10 punti**"* | **r.93** |
| *"si puo' mettere **gia' lo stop legato ai due ordini**? Si, si puo' mettere"* | **r.93** |

### ✅ CE L'ABBIAMO? — **SI', ed e' LO STESSO NUMERO. Confronto parametro per parametro.**

`ABTG_MaxMinNotte.mq5`:

| loro (dichiarato) | noi (codice) | riga nostra | verdetto |
|---|---|---|---|
| offset d'ingresso **10 punti** oltre l'estremo | `InpBufferPoints = 1000` — commento: *"Buffer oltre max/min notte, in punti (**DAX BCM: 1000 = 10 punti indice**)"* | r.140 | 🟢🟢 **IDENTICO, e sullo stesso broker e simbolo** |
| stop **5-10 punti** oltre il minimo della candela | `InpSLMode = MM_SL_ATR` (default ATR×1,5) · `InpSLFixedPts = 3000` = 30 punti indice se si sceglie FIXED · pavimento `MathMax(InpBufferPoints, stops)` | r.145-149, r.727 | 🟠 **DIVERSO**: noi di default lo stop e' **ATR-adattivo**, loro e' **offset fisso dall'estremo**. La loro modalita' esiste da noi solo come `MM_SL_BOX` / `FIXED` |
| box notturno | `InpBoxStartHour=23` → `InpBoxEndHour=4, Min=59` (**ora server**: 00:00-05:59 CET) | r.118-121 | 🔴 **la live NON dice mai le ore del box** → non confrontabile |
| cutoff degli ingressi | `InpEntryCutoffHour=8, Min=30` (= 09:30 CET) + `InpPendingExpiryMin=90` | r.128-129, r.137 | 🔴 **la live non ha nessun cutoff** — e' discrezionale, guardano tutto il giorno |
| un solo trade | `InpOneTradePerDay = true` | r.136 | 🔴 la live ne fa **piu' di uno** (r.149: Emiliano fa anche *"una short veloce"*) |
| stop legato ai due ordini | i nostri pendenti nascono gia' con SL/TP | — | 🟢 converge |

> 🟢 **Il nostro `InpBufferPoints=1000` e' CONFERMATO da una fonte esterna che opera
> sullo STESSO strumento e sullo STESSO broker.** E' la convergenza piu' pulita del
> documento — ma vale come **conferma di una scelta gia' fatta**, non come lavoro nuovo.
> 🔴 **Le differenze vere sono tre** (stop fisso vs ATR, nessun cutoff, piu' trade al
> giorno), e **tutte e tre sono differenze che a noi convengono su un conto prop**: il
> cutoff e il trade unico esistono proprio per non trasformare una sedia in un
> discrezionale.

---

## M4 — I TRE LIVELLI DI PREZZO CHE CONTANO

La fonte li elenca due volte, identici:

| citazione | riga |
|---|---|
| *"Sostanzialmente, **quali sono i prezzi importanti**, Renzo? **Open Weekly, massimi minimi della notte e massimi minimi del giorno prima**"* | **r.81** |
| *"i livelli di massimo e minimo precedenti, i livelli di massimo e minimo della notte **che sono i due livelli piu' importanti**, e abbiamo aggiunto **un terzo livello che e' l'open weekly**"* | **r.95** |
| e la funzione dell'Open Weekly: *"l'open weekly **fa da spartiacque** ... immagina che tu sei in un contesto short e hai l'open weekly sopra i prezzi attuali, quindi **l'open weekly ti sta spingendo verso il basso, hai un bias short**"* | **r.95** · r.79 |

### ✅ QUALI DEI TRE USIAMO DAVVERO — verificato con `grep`

| livello | chi lo usa nel nostro codice | come | copertura |
|---|---|---|---|
| **Max/min della NOTTE** | 🟢 `ABTG_MaxMinNotte.mq5` (famiglia intera: `_DAX_Short_Ottimizzato`, `_MFE`, preset FTMO `770411`, `770402`) | e' **il motore**, box notturno + buffer | ✅ **pieno** |
| **Max/min del GIORNO PRIMA (PDH/PDL)** | 🟠 `iHigh/iLow(_Symbol,PERIOD_D1,1)` in: `ABTG_Apertura_3Ingressi.mq5` r.2111-2112 · `ABTG_Nasdaq_Apertura_US.mq5` r.1996-1997 · `GoldBreakout_Levels.mq5` r.233-234 · `ABTG_PunteLarry.mq5` r.416-417 · `ABTG_TurnaroundTuesday.mq5` r.530-533 | **solo dentro `SRBlocked`**, che e' `InpUseSRFilter=false` di default — e `grep` sui `.set`/`.ini` conferma: **`InpUseSRFilter=false` in TUTTI i preset** (`ABTG_Nasdaq_Apertura_US_RETEST_770260.set` r.161, versione FTMO r.217, e i 4 `.ini` di GapFill con `=0`) | 🔴 **presente ma SPENTO ovunque** |
| **OPEN WEEKLY** | 🔴 **UN SOLO EA in tutto il repo**: `ABTG_WOL.mq5` r.154 `double WeeklyOpen(){ return(iOpen(_Symbol,PERIOD_W1,0)); }` (+ `GoldBreakout_Levels.mq5` r.229 come livello fra gli altri) | e in `ABTG_WOL` **non e' uno spartiacque direzionale**: e' il livello **su cui si entra** (`InpWolProximityAtr=0.5`, r.53: *"in prossimita' della WOL"*), cercando una Doji | 🔴 **il ruolo che gli da' la fonte — BIAS DIREZIONALE sopra/sotto — non esiste in nessun nostro EA** |

> ## 🔴 **BUCO MISURATO: l'Open Weekly come SPARTIACQUE DIREZIONALE non e' implementato da nessuna parte.**
> Da noi la WOL e' un **bersaglio**; per loro e' un **filtro di bias** (r.95: *"l'open
> weekly ti sta spingendo verso il basso, hai un bias short"*). Sono due usi opposti
> dello stesso numero.
> ⚠️ **Ma va detto subito che questo NON diventa una proposta**: e' una regola
> **senza nessuna soglia dichiarata** (quanto sopra? quanti punti? conta anche a 2
> punti di distanza?), e un filtro di bias senza soglia non si misura. Finisce nelle
> domande, non nell'imbuto.

---

## M5 — L'ORB E' **UNA CANDELA M15**, e la fonte lo ripete

| citazione | riga |
|---|---|
| *"cosa dice l'orb? che **finche' sta all'interno del range determinato dal massimo al minimo della candela in M15, si sta fermi**; l'orb ti da' una direzione e te la da' **quando esce dal massimo al minimo in M15**"* | **r.95** |
| *"per il momento **la linea rossa corrisponde al minimo della candela in M15**"* | **r.95** |
| *"deve ancora completarsi perche' mancano due minuti, **15 minuti**, poi scendono i time frame sui 5 minuti"* | **r.95** |

### ❌ CE L'ABBIAMO? — **SI', e la nostra misura DICE IL CONTRARIO**

`ABTG_DAX_Apertura_EU.mq5` r.265 / `ABTG_Nasdaq_Apertura_US.mq5` r.201: `InpRangeMinutes`.
Misura di casa (`report/DIARIO.md`, 06/08): banda **35-45 min = 8/8 celle positive
OOS**; banda **5-15 min = 0/8**; due motori concordi in **18 celle su 20**.

> 🏆 **Vince la nostra misura.** E attenzione al conteggio delle fonti: questa e' la
> **quarta** volta che la stessa regola dei 15 minuti arriva **dallo stesso canale**
> (14/09, 16/09, 18/09, e ora questa del 10/04). 🔴 **Quattro ripetizioni della stessa
> fonte sono UNA fonte, non quattro.** Il cancello non si riapre.
> 🟢 **Pero' questa live chiude un buco del referto del 18/09**: li' la domanda aperta
> n.2 era *«l'ORB e' 3 candele di QUALE timeframe?»* (S1, r.173 della live 18/09). Qui
> r.95 lo dice in chiaro: **il range e' il massimo-minimo di UNA candela M15**, quindi
> **15 minuti**. La contraddizione col nostro 35-45 e' **reale**, non un malinteso di TF.

---

## M6 — LA CONFLUENZA MULTI-TIMEFRAME COME CONDIZIONE D'INGRESSO

| citazione | riga |
|---|---|
| *"io lo aspetterei **sulla media 200 in D1, che corrisponde alla media 14 in H4 e alla media 50 in H1**. E tra l'altro in H1 corrisponde anche a questo livello qui, quindi mi posizionerei li'"* | **r.85-87** |
| *"la **M200 in M15 corrisponde a che cosa? corrisponde alla 14 in H4** ... bravo Luca ... **e' andato a vedere una confluenza**"* | **r.95** |
| *"una cosa: **la media 200 M15 corrisponde a media 50 in H1 e media 14 in H4** — in questo caso un buy su questo livello avrebbe senso? **si', avrebbe senso**. La media 50? **no, non avrebbe senso**"* | **r.95** |
| *"sotto hai il prezzo rimbalzato fuori dalle medie, e' una **confluenza delle medie di 50-14-200**"* | **r.95** |

**Regola estraibile**: si entra su un livello **solo se almeno 2-3 medie di TF diversi
cadono sullo stesso prezzo**. La corrispondenza `EMA200@M15 ≈ EMA50@H1 ≈ EMA14@H4` e'
peraltro **aritmetica** (M15×200 ≈ 3.000 min; H1×50 = 3.000 min; H4×14 = 3.360 min):
non e' una coincidenza di mercato, e' la stessa finestra temporale letta da tre TF.
`[INFERITO]` da r.87 + r.95, il calcolo e' mio.

### ❌ CE L'ABBIAMO? — **NO.** Nessun EA verifica la **coincidenza di prezzo** fra medie
di TF diversi. Abbiamo medie su TF superiore come **bias** (`InpFilterTF`), mai come
**confluenza di livello**.
⚠️ Onesta': visto il calcolo qui sopra, **la confluenza e' quasi sempre vera per
costruzione** → un filtro cosi' rischia di non filtrare niente. Lo segnalo come
meccanismo, **non lo propongo**.

---

## 🟢 M7 — «LA MEDIA 200 NON SI LAVORA MAI DA SOLA» — il filtro di confluenza STATICA

Detto **tre volte in dieci righe**, ed e' la regola piu' insistita della live:

| citazione | riga |
|---|---|
| *"ragazzi, **io la media 200 non la lavoro mai solo perche' e' la media 200: lavoro media 200 legata a un livello di supporto**"* | **r.95** |
| *"non puoi prescindere da **trovare un livello di supporto STATICO** ... **anche dinamico mi sta bene ma statico e' fondamentale**"* | **r.95** |
| *"**io la media 200 non la lavoro mai senza un livello di supporto** ... la lavoro sempre con un livello di supporto, **sempre**"* | **r.95** |
| e il criterio di cosa **conta** come livello statico: *"**devo trovare un livello di massimi e minimi contrapposti, cosa che non c'e'**"* | **r.95** |
| e il contro-caso in diretta: *"se non c'e' un livello di supporto qua **i prezzi possono continuare a scendere e fare lo squeeze sulle bande**"* | **r.95** |

**Regola estraibile e codificabile**: un ingresso su EMA200 e' valido **solo se entro
X punti dalla media esiste anche un livello STATICO** (massimo/minimo contrapposto,
numero tondo, zona di price action precedente).

### ❌ CE L'ABBIAMO? — **NO, e casca sulla sedia che ci sta piu' a cuore.**

`ABTG_EMA200.mq5` (la **prima sedia**, magic `771531`, l'unica delle 41 vive che passa
i cancelli di oggi alla lettera — CLAUDE.md):

| input | cosa fa | riga |
|---|---|---|
| `InpMinDistAtr = 0.3` / `InpMaxDistAtr = 1.5` | *"prezzo non gia' sulla media"* / *"prezzo abbastanza vicino"* | r.42-43 |
| `InpUseEma14Bias = true` | richiede EMA14 dallo stesso lato (**bias dinamico**) | r.44 |
| `InpOrder1Atr = 0.10` / `InpOrder2Atr = 0.35` | due pendenti: uno **prima** della media, uno in **overshoot** | r.49-50 |
| `InpMinRR = 1.0` | salta se RR < 1 | r.56 |

🔴 **Nessun input richiede un livello STATICO.** L'EA entra sulla EMA200 *"solo perche'
e' la media 200"* — che e' testualmente quello che la fonte dice di **non fare mai**.

---

## M8 — L'ORDINE NON SI APPOGGIA AL LIVELLO: si anticipa

| citazione | riga |
|---|---|
| *"il **primo ordine deve essere eseguito e non lo puoi mettere appiccicato**, un po' sopra e' la M200 in D1, e' corretto, **lo metti un po' sopra** ... **lo metti leggermente sopra**"* | **r.95** |
| *"io quando metto i due ordini **io voglio essere eseguito**"* | **r.93** |
| *"il primo ordine lo metto subito sotto il super trend o lo metto sotto la media? **Questo dipende se vuoi essere eseguito o meno**"* | **r.93** |

### 🟢 CE L'ABBIAMO? — **SI', ed e' quasi identico**: `ABTG_EMA200.mq5` r.49
`InpOrder1Atr = 0.10; // 1o ordine: verso il prezzo, oltre la EMA200 di N*ATR (guida ~5 pip)`.
**Il nostro primo ordine sta gia' "un po' prima" della media, esattamente come dice
r.95.** ✅ Convergenza, nessun lavoro.

---

## M9 — LA DISTANZA FRA I DUE ORDINI DELLO SCALE-IN

| citazione | riga |
|---|---|
| *"gli ordini che io ho piazzato **non mi piacciono come li ho piazzati**; e' vero che mi sono messo vicino al numero tondo ma **sono troppo distanti** ... sono **distanti circa 59 punti uno dall'altro**. Che cosa vuol dire questa roba? Vuol dire che e' molto probabile che **i prezzi mi toccano il primo e rimbalzano**, oppure arrivo a meta' strada: **e' difficile che me lo vada a prendere, molto difficile**"* | **r.95** |
| e il posizionamento del secondo: *"il secondo ordine **lo vado a mettere sul numero tondo**, di solito"* | **r.93** |
| *"**il secondo ordine deve essere sempre messo in prospettiva**"* | **r.93** |

### 🔗 CONVERGENZA COL REFERTO DEL 18/09 — ma **attenzione al conteggio delle fonti**
Il referto `report/ANALISI_LIVE_EMILIANO_2026-09-18.md` (voce **N1**) aveva estratto
dalla stessa fonte: **20 pt si', 40-50 pt no** sul DAX. Qui: **59 pt = troppo**.
🟢 I due numeri sono **coerenti fra loro** (la soglia sta fra 20 e 40).
🔴 **Ma e' lo STESSO relatore sullo STESSO strumento: e' una fonte sola, non due.**
Vale come **taratura interna coerente**, non come verifica indipendente.

**Da noi**: `InpFirstFraction` / `InpOrder1Atr`+`InpOrder2Atr` esistono, ed e' gia' la
proposta **C1** del referto del 18/09 (voce 17 dell'audit = **MAI misurata**).
👉 **Non la riapro qui: la rinforzo.** Vedi §5.

---

## M10 — IL FILTRO NOTIZIE

| citazione | riga |
|---|---|
| *"Ci sono delle **notizie alle 14.30** ... **c'e' il CPI**. Quindi CPI, ragazzi, e' un dato estremamente importante ... quindi alle 14.30 **state attenti, in qualsiasi posizione che avete, [gli ordini] pendenti vanno cancellati**"* | **r.47** |

### 🟢 CE L'ABBIAMO? — **SI', ed e' piu' completo del loro.**
`ABTG_MaxMinNotte.mq5` r.173-181: `InpUseNewsFilter`, `InpNewsMinImpact=3`,
`InpNewsBeforeMin=30`, `InpNewsAfterMin=30`, `InpNewsShiftMinutes`, `InpNewsCurrencies`,
**`InpNewsFlatten=true`** (= chiude, non solo cancella). Stessa batteria in
`ABTG_DAX_Apertura_EU.mq5` r.345-353 e in `ABTG_EMA200.mq5` r.73-79.
🔴 **Ma di default `InpUseNewsFilter = false`** in tutti e tre.
🟠 **Fuso**: il "14.30" resta `[INCERTO]` (vedi §Identificazione). Il nostro
`InpNewsShiftMinutes` esiste proprio per questo problema.

---

## M11 — LO SCENARIO A TRE RAMI (piano A / B / C) SCRITTO PRIMA DI ENTRARE

| citazione | riga |
|---|---|
| *"**caso A**: immaginiamo, arriva sulla media, prende, rimbalza, ci prende solo il primo ordine, siamo dentro e lo gestiamo ... **caso B** mi sorpassa la media, mi va a prendere [anche] il [secondo] ordine ... poi **caso C**, prende, va giu' e rompe anche questo minimo: ragazzi, **c'entra lo stop**, succede. Pero' io devo avere, caso A, caso B e caso C, **devo avere ben chiara l'idea di come mettere lo stop**"* | **r.93** |
| *"io devo avere **piano A, piano B e piano C**: piano A prende l'ordine e scende; piano B prende il secondo ordine e scende; piano C va oltre il supertrend, mi apre col culetto sopra questa zona, **cambia completamente la struttura e quindi [cancello] l'ordine**"* | **r.95** |
| *"noi dobbiamo **anticipare le mosse del mercato** ... o meglio, **dobbiamo sapere cosa fare se il mercato fa una determinata cosa** o cosa fare se ne fa un'altra"* | **r.95** |
| e l'aneddoto del padre pilota: *"**non guardare mai la macchina che c'e' subito davanti, guarda quella dopo**"* | **r.95** |

### 🟢 CE L'ABBIAMO? — **SI', per costruzione.** Un EA **E'** un piano A/B/C: tutti i
rami sono scritti prima. E' la voce che vale come **validazione filosofica del nostro
approccio**, non come lavoro: il "trucco" che il relatore insegna ai discrezionali e'
quello che a noi il codice impone gratis. Da mettere in tabella fra le **vittorie**.

---

## M12 — LA CANCELLAZIONE DEI PENDENTI SU CAMBIO DI STRUTTURA

| citazione | riga |
|---|---|
| *"**siamo pronti anche a cancellare gli ordini nel momento in cui vediamo un eccesso di volatilita'**, magari verso il basso o verso l'alto ... **siamo pronti anche a spostarli**"* | **r.93** |
| *"se il mercato dovesse andare ad aggredire ancora la media 14 o la media 200, **la sorpassa, e quindi l'operazione in questo caso io la cancellerei** e lo aspetterei piuttosto sotto"* | **r.95** |
| *"adesso ovviamente **devi cancellare gli ordini oppure devi tirare verso il basso**"* | **r.95** |
| *"il secondo movimento **lo devi spostare verso il basso** ... perche' comunque te lo puo' superare"* | **r.95** |

### 🟠 CE L'ABBIAMO? — **A META'.** Abbiamo la **scadenza a tempo**
(`InpPendingExpiryMin=90`, `ABTG_MaxMinNotte.mq5` r.137; `InpPendingExpiryBars=6`,
`ABTG_EMA200.mq5` r.52) e il **cutoff orario** (r.128-129). 🔴 **Non abbiamo la
cancellazione per CAMBIO DI STRUTTURA** (il livello viene superato → il pendente non
ha piu' senso) ne' lo **spostamento del pendente**. Sono due meccanismi distinti:
il nostro e' *"e' passato troppo tempo"*, il loro e' *"il motivo per cui l'avevo messo
non c'e' piu'"*.

---

# 2. 🚩 LE BANDIERE ROSSE

## 🔴🔴 BR1 — LA «CORREZIONE» DELL'OPERAZIONE = **MEDIA VALORE / AVERAGING DOWN**

Claudio l'ha vista, ed e' la piu' grossa. La ricostruisco **completa**, perche' la
fonte la ammette per iscritto e questo rende il caso chiuso.

| # | citazione | riga |
|---|---|---|
| 1 | *"ma siccome questa e' **un'operazione che dovro' correggere** perche' non mi piace assolutamente ... **sono entrato qua con 10 contratti, entro qua sulla media**"* | **r.95** |
| 2 | 🔴 **LA DEFINIZIONE**: *"quando metto il secondo ordine, **il secondo ordine deve essere in un punto tale che posso prevedere che una discesa della meta' mi porti almeno in pareggio dell'operazione**"* | **r.95** |
| 3 | *"cerchero' di correggerla in questa zona; se non riesco a correggerla in questa zona, **la correggero' qua sotto** ... **pero' mi sto aumentando di tanto il rischio**"* | **r.123** |
| 4 | *"i livelli che vedo dove posso andare a correggere l'operazione ... **qua mi posso mettere la parte grande**"* | **r.95** |
| 5 | 🔴 **L'AMMISSIONE**: *"**correggere l'operazione vuol dire che io qua sto aumentando il rischio.** Perche' vuol dire che sto aumentando il rischio: **non e' piu' il mio x per cento, diventa l'x per cento piu' il rischio della seconda operazione**"* | **r.127-129** |
| 6 | E il gate, che e' **soggettivo**: *"**la correzione la possono fare solo quelli che sono avanti nel percorso** ... la faccio **se e solo se ci sono dei livelli opportuni** ... devo essere **molto certo e molto sicuro**"* | **r.123-129** |

### 🔴 E LA SIZE CRESCENTE, che Claudio non aveva segnalato e che peggiora il quadro

> *"adesso cosa posso fare in questa situazione? Al limite, **anziche' accoglierlo con
> 20 contratti, io posso dividere 10, 10 e 20** e metterlo come un ultimo baluardo"* — **r.95**

**La terza tranche e' il DOPPIO delle prime due, e sta al prezzo PEGGIORE.** Totale
esposto: 40 contratti contro i 20 di partenza, con la fetta piu' grande sul livello
piu' lontano. 🔴 **Questa non e' "media valore" e basta: e' media valore con SIZE
PROGRESSIVA** — la forma aritmetica della martingala, anche se la parola non viene
mai pronunciata (verificato: **0 occorrenze** di *martingal\**, *griglia*, *recovery*,
*raddopp\**, *mediaz\** in tutto il file).

### ⛔ VERDETTO

> ## 🔴 **NON ADOTTABILE, ne' su conto prop ne' su nessun conto nostro. Marcata: MEDIA VALORE / AVERAGING DOWN CON SIZE PROGRESSIVA.**
>
> **I motivi, in ordine di costo:**
> 1. 🔴 **Rompe il cap di rischio per costruzione, e la fonte lo dice lei**: *"non e'
>    piu' il mio x per cento, diventa l'x per cento piu' il rischio della seconda
>    operazione"* (r.129). Il nostro **C1 al 3,25% di rischio aperto** (firmato
>    18/08, `ABTG_Guardian.mq5`) e' esattamente il cancello che questa pratica
>    aggira: un EA che "corregge" fa saltare il conto degli SL vivi.
> 2. 🔴 **Il gate e' soggettivo** — *"quelli avanti nel percorso"*, *"molto certo e
>    molto sicuro"* (r.125-129). **Un gate che non si scrive in codice non e' un
>    gate.** Ed e' il difetto che ha gia' un precedente in casa:
>    `backtest_pipeline/caccia_strategie/ANALISI_CORSO_MEDIAZIONE_2026-08-18.md`.
> 3. 🔴 **Cambia la distribuzione degli esiti nel verso peggiore per una challenge**:
>    tante piccole vincite (i pareggi "corretti") e poche perdite molto grandi. Una
>    prop non fallisce sulla media: fallisce sul **giorno peggiore**.
> 4. 🟠 **E ha gia' fatto danno in diretta, nella live stessa**: r.95 *"in questo
>    momento **sono sotto di 135 euro**"*, r.123 *"**ho subito 100€** e questa cosa
>    non mi piace"*, r.113 *"se io vado **sotto i 300**"*, r.95 *"sono stato **sotto
>    di 200 euro**"*. La correzione non ha impedito il drawdown: l'ha accompagnato.

---

## 🔴 BR2 — «NON HO IL PERMESSO DI CHIUDERE» — la regola che **vieta** di tagliare una perdita

Questa **non era nel brief** e a mio avviso e' la seconda piu' pericolosa per noi.

| citazione | riga |
|---|---|
| *"perche' **non e' giusto andare sotto i 300 e chiudere in pari**"* | **r.109** |
| *"**se io vado sotto i 300, sto sbagliando a chiudere la posizione**"* | **r.113** |
| *"**l'unico caso dove siamo autorizzati tutti a chiudere l'operazione** [e' l'ingresso nato male]. **Tutto il resto**, se io studio bene e faccio un'operazione e vado in drawdown, io l'operazione, se la ristudio e continua a darmi quel tipo di bias, **allora io la tengo**"* | **r.137-139** |
| *"se invece l'ho studiata bene e l'ho fatta bene, l'operazione rimane ... **Non ho il permesso di chiudere, non ho il permesso**"* | **r.179** |
| *"se capisco che sto prendendo uno stop, posso chiudere prima l'operazione o no? ... **la risposta e' si', lo posso fare. Pero' sto violando il mio piano** di trading"* | **r.195-197** |

### ⛔ VERDETTO

> 🔴 **INCOMPATIBILE con la disciplina di un conto prop, e la ragione e' aritmetica,
> non filosofica.** Su un conto a **limite di perdita GIORNALIERA** (FTMO), "non ho il
> permesso di chiudere" significa che la decisione di fermarsi e' delegata **allo stop
> della singola operazione**, mai al **conto**. Noi facciamo l'opposto e l'abbiamo
> firmato: **pausa B1 al 4,0%**, **emergenza 4,9 / 9,9**, **reset alle 23** (firme del
> 18/08). Sono cancelli **di conto**, che chiudono e mettono in pausa **a prescindere
> da quanto era bella l'analisi**.
> 🟢 **Da rubare c'e' pero' una cosa, ed e' sana**: la fonte pretende che la decisione
> di chiudere sia **una regola scritta prima**, non un impulso (r.111: *"devo avere
> **una metrica** che mi dice: va bene, in questo caso sei autorizzato a chiudere in
> pari"*). Quella e' esattamente la filosofia del Guardian. **Il principio converge,
> la soglia no.**

---

## 🟠 BR3 — GLI STOP DA «QUALCHE PUNTO» E LE OPERAZIONI DA 20 PUNTI

| citazione | riga |
|---|---|
| *"perche' **lo stop e' vicino**, solo per questo: cioe' io in quella situazione **lo stop ce l'ho a qualche punto**"* | **r.169** |
| *"**Il rischio e' bassissimo.** E poi sono pronto a girarmi long. **Questa e' un'operazione da 20 punti**, tranquilli"* | **r.171** |
| *"Io ho fatto **una short veloce** ... ho fatto una short sul terzo livello di supertrend"* | **r.149** |
| *"Io **l'ho recuperato per 90 euro**, giusto perche' l'ho fatto perdere Renzo"* | **r.149** |

### ⛔ VERDETTO

> 🟠 **NON TRASFERIBILE per un motivo che abbiamo gia' MISURATO in casa: la frontiera
> del costo `stop >= 40 x spread`** (CLAUDE.md). Uno stop *"a qualche punto"* sul DAX
> sfonda quella frontiera di netto. E la fonte **chiama "rischio bassissimo" una cosa
> che per un EA e' rischio MASSIMO**: piu' lo stop e' stretto, piu' il costo di
> transazione e lo slippage mangiano il bordo.
> 🔴 **E c'e' un secondo problema, piu' sottile**: la "short veloce" di r.149 e'
> **contraria** alla posizione che l'altro relatore ha aperta sullo stesso livello
> (r.153: *"sullo stesso livello io ho fatto un'operazione veloce e lui ha fatto
> un'operazione di posizione"*). Su un conto solo, questo e' **hedging interno**: due
> sedie che si annullano pagando due spread. Il nostro tetto per cluster (C2, firmato
> ma non attivo) nasce da questa famiglia di problemi.

---

## 🟠 BR4 — NESSUN TETTO DI PERDITA GIORNALIERA, E NESSUNA MENZIONE DI PROP

Conteggi fatti sul file, non a memoria:

| cercato | occorrenze |
|---|---:|
| `martingal*` | **0** |
| `griglia` / `grid` | **0** |
| `recovery` | **0** |
| `raddopp*` | **0** |
| `mediaz*` (la parola) | **0** — 🔴 **ma la PRATICA c'e', sotto il nome "correzione"** (BR1) |
| `prop` / `challenge` / `FTMO` | **0** — l'unico `prop` e' *"proprio"* (r.95) |
| `hedg*` | **0** |
| `drawdown` | 4 (r.95, r.97, r.143) |
| trading senza stop | **0** — 🟢 al contrario: *"ogni operazione per noi ha uno **stop loss gia' definito**"* (r.93), *"**c'entra lo stop, succede**"* (r.93), *"vai in stop, non la correggere, **vai in stop**"* (r.95) |
| 🔴 **trucchi per aggirare le regole prop** | **0** — e non c'e' nemmeno il contesto |

> 🟢 **Materiale pulito sul fronte che ci preoccupa di piu'**: nessun trucco anti-prop,
> nessuna martingala dichiarata, lo stop c'e' sempre ed e' definito prima.
> 🟠 **Ma il tetto di perdita GIORNALIERA non compare mai in cifre.** L'unica regola di
> fermata e' **a conteggio, non a percentuale** → vedi §3, D5. Per un conto prop questo
> e' il buco piu' grande della metodologia.

---

# 3. 🧠 QUELLO CHE E' DISCIPLINA, NON MECCANISMO

> 🔴 **Dichiarazione preliminare, e vale per tutta la sezione: queste regole servono a
> un trader DISCREZIONALE davanti al monitor. Su un EA NON SI APPLICANO — non perche'
> siano sbagliate, ma perche' il problema che risolvono (l'emozione) NOI NON CE
> L'ABBIAMO: il piano sta nel codice, e il codice non spera.** Le elenco perche' sono
> il 40% della live e vanno archiviate, non perche' aprano un lavoro.

| # | regola | citazione | riga |
|---|---|---|---|
| **D1** | **Quando sei in difficolta', RISTUDIA il grafico — non sperare** | *"non e' vivere un'emozione ma e' andare a **ristudiare il grafico** ... quando siete in difficolta' la cosa e' semplice, non dovete fare nient'altro che **ristudiare il grafico**"* | **r.95** |
| **D2** | **La "metrica" per chiudere in pari: SOLO se l'ingresso e' nato male** | *"devo avere **una metrica** che mi dice: va bene, in questo caso **sei autorizzato a chiudere in pari**"* · *"**se l'operazione e' nata male, la chiudo in pari**"* · *"**questo e' l'unico caso dove siamo autorizzati tutti a chiudere**"* | **r.111, r.133, r.137** |
| **D3** | **Staccarsi dal monitor** | *"provate veramente a **staccarvi dal monitor** ... **se sono davanti al monitor sto male** ... le operazioni piu' belle ... le ho fatte **quando mi sono allontanato dal monitor**"* · *"**Fai l'operazione, impostala, studiala bene e vattene via**"* | **r.179-185** |
| **D4** | **Cambiare convinzione e' la cosa difficile** | *"il vero problema di tutti e' **cambiare la convinzione**: se io ho determinato che il mercato va short, sono sicuro che va short e anche se va long, **continuo imperterrito a vedere la visione short**"* | **r.101-103** |
| **D5** | 🟠 **LA REGOLA DI FERMATA A CONTEGGIO** — l'unica della live che sfiora un daily stop | *"una volta che tu sai che sei profittevole alla mattina, e **incominci a fare il primo ingresso male e lo esci in pari, il secondo ingresso lo fai male e lo esci in stop, vuol dire che quella mattina non ci stai capendo un cazzo e quindi ti stacchi. E' regola anche questa**"* | **r.203** |
| **D6** | **Anti revenge-trading** | *"se continuo ad essere attaccato al monitor **faccio il revenge trading e spacco tutto**"* | **r.205** |
| **D7** | **Non entrare per vivere un'emozione** | *"**non sei obbligato ad entrare al mercato perche' devi vivere una cazzo di emozione**: noi siamo qua per guadagnare soldi, e per guadagnare soldi **devi aspettare il mercato, non andargli dietro**"* | **r.93** |
| **D8** | **La direzione la decidi tu, non il mercato** | *"io voglio stare in quelle posizioni dove **prendo il mercato, va nella direzione che ho stabilito a priori** ... **la stabilisco io la direzione**"* | **r.93** |
| **D9** | **Lo stop ti libera** | *"**lo stop ti libera**, lo stop ti porta in una posizione tale per cui, se tu l'hai stabilito a priori, **non ti deve cambiare niente**"* | **r.197** |

> 🟠 **D5 e' l'unica che avrebbe una traduzione in codice** (*"2 operazioni gestite male
> = chiusa la giornata"*): sarebbe un **daily stop A CONTEGGIO**, accanto al nostro
> **B1 a percentuale (4,0%)**. 🔴 **Ma nella fonte il predicato e' "nate male", che e'
> un giudizio, non un fatto misurabile** — e un cancello che dipende da un giudizio non
> e' un cancello. La versione codificabile (*"2 stop consecutivi = stop per oggi"*) **non
> e' quello che la fonte dice**: sarebbe una nostra invenzione con la sua etichetta.
> **Non la propongo**, la registro.

---

# 4. 📊 I NUMERI DICHIARATI

> 🔴 **TUTTI [DICHIARATI, NON MISURATI].** Nessuno di questi numeri entra in un `.set`,
> in un `.ini` o in un criterio. Sono **indizi**, e l'unita' di misura ("punti") non e'
> mai definita nel parlato: sul DAX vale **punti indice** `[INFERITO dal contesto]`,
> non punti MT5 (che da noi sono **100 punti MT5 = 1 punto indice**).

## 4.1 Distanze e spazio

| valore | contesto | riga | etichetta |
|---:|---|---|---|
| **170 punti** | distanza al livello analizzato — *"Sono tanti"* | r.39 | `[TRASCRITTO chiaro]` |
| **500 punti** | *"e' troppo distante"* — la trascrizione dice *"500 rubi"* | r.39 | `[TRASCRITTO dubbio]` — "rubi" e' rumore |
| **30 punti** | traffico sotto i minimi della notte: *"secondo me **sono pochini**"* | r.83 | `[TRASCRITTO chiaro]` |
| **30 punti → 26 punti** | *"poco spazio sono circa 30 punti, **26 punti in realta'**"* — 🟢 l'autocorrezione in diretta e' la prova che e' una **misura fatta a schermo**, non una frase | r.93 | `[TRASCRITTO chiaro]` |
| **30 punticini** | *"non vogliamo essere in operazione per 30 punticini"* | r.95 | `[TRASCRITTO chiaro]` |
| **59 punti** | distanza fra i due ordini: *"sono troppo distanti"* | r.95 | `[TRASCRITTO chiaro]` |
| **10 punti** | offset dell'ingresso sotto i minimi della notte | r.93 | 🟢 `[TRASCRITTO chiaro]` — **coincide col nostro `InpBufferPoints=1000`** |
| **10 punti** | offset dello stop sotto il minimo della candela | r.93 | `[TRASCRITTO chiaro]` |
| **5-10 punti** | stessa regola, ripetuta con banda | r.93 | `[TRASCRITTO chiaro]` |
| **100 punti** | distanza dello stop *"in chiuso"* → *"**usi le size di conseguenza**"* | r.93 | `[TRASCRITTO chiaro]` |
| **15 punti** | *"puo' scendere almeno di 15 punti"* | r.95 | `[TRASCRITTO chiaro]` |
| **20 punti** | *"questa e' un'operazione da 20 punti"* | r.171 | `[TRASCRITTO chiaro]` |
| **710** | *"710 e' 710, troppo distante"* | r.95 | `[TRASCRITTO dubbio]` — frase sconnessa |
| **23 8 47** | *"i minimi della notte ... **io ce li ho 23, 8 e 47**"* → verosimilmente **23.847** | r.57 | 🔴 `[TRASCRITTO dubbio]` — decimali persi |
| **14,94** | *"e' arrivato esattamente alla **media 14,94**"* → `[INCERTO]`: sembra un **prezzo** (…94), non la media 14 | r.95 | 🔴 `[TRASCRITTO dubbio]` |

## 4.2 Size

| valore | contesto | riga | etichetta |
|---:|---|---|---|
| **1** | *"metti l'ordine pendente di 1"* | r.61 | `[TRASCRITTO chiaro]`, **unita' ignota** |
| **5** | *"metto un ordine pendente di 5, sempre rispetto allo stop"* | r.93 | `[TRASCRITTO chiaro]`, unita' ignota |
| **50 e 1** | *"adesso ho usato 50 e 1"* | r.93 | 🔴 `[TRASCRITTO dubbio]` — potrebbe essere *"0,50 e 1"* |
| **10 contratti** | size del primo ingresso | r.95 | `[TRASCRITTO chiaro]` |
| **20 contratti → 10, 10 e 20** | 🔴 lo **scale-in a size crescente** di BR1 | r.95 | `[TRASCRITTO chiaro]` |
| **un terzo** | *"il primo ordine ... **quindi un terzo** lo vado a piazzare"* | r.93 | 🟢 converge col nostro `InpFirstFraction=0,3333` |

## 4.3 Denaro (P/L dichiarati in diretta)

| valore | contesto | riga |
|---:|---|---|
| **−135 €** | *"in questo momento **sono sotto di 135 euro**"* | r.95 |
| **−100 €** | *"**ho subito 100€** e questa cosa non mi piace"* | r.123 |
| **−200 €** | *"cazzo **sono stato sotto di 200 euro**, adesso devo chiudere"* | r.95 |
| **−300 €** | *"**sotto i 300**"* / *"200 euro, **anzi 300 euro**, lo chiuderai in pari"* | r.95, r.109, r.113 |
| **+90 €** | *"io **l'ho recuperato per 90 euro**"* (la short veloce) | r.149 |
| **80 €** | *"anche se l'ho fatto per l'80 euro"* | r.145 — 🔴 `[TRASCRITTO dubbio]`, frase sconnessa |

> 🔴 **Nessuno di questi importi e' convertibile in percentuale**: il **saldo del conto
> non e' mai detto**. Senza il denominatore, "−300 €" non dice niente sul rischio.

## 4.4 Indicatori e periodi

| valore | contesto | riga | etichetta |
|---|---|---|---|
| **EMA 14 / 50 / 100 / 200** | le quattro medie usate su tutti i TF | r.11, r.13, r.29, r.87, r.93, r.95 | `[TRASCRITTO chiaro]` |
| **Supertrend a 3 livelli** (1°, 2°, 3°) | *"terzo livello di Supertrend in D1"* | r.5, r.9, r.29, r.43, r.149 | `[TRASCRITTO chiaro]` — 🟢 noi: `InpUseSupertrend3` con **2,5 / 3,0 / 3,5** (`ABTG_Dow_Apertura_US.mq5` r.267) |
| **Bande di Bollinger "37, 3"** | *"bande di Bollinger io le tengo **37, 3**"* | r.95 | 🔴 `[TRASCRITTO dubbio]` — plausibile **periodo 37, deviazione 3**, ma non e' detto. **Non si usa un parametro indovinato** |
| **Fibonacci 38,2 / 50 / 61,8** | ritracciamenti su daily | r.19, r.23 | `[TRASCRITTO chiaro]` |
| **VWAP in M15** | *"in M15 ha toccato la media 100 e il **VWAP** ... e' **l'ultimo baluardo** in M15"* | r.95 | 🟢 converge col nostro `InpVwapTF = PERIOD_M15` (`ABTG_Dow_Apertura_US.mq5` r.278, commento in codice: *"guida Emiliano: M15"*) |
| **TF usati** | D1 · H4 · H1 · M15 · M5 · M3 | r.11-13, r.51, r.71, r.95, r.161 | `[TRASCRITTO chiaro]` |
| **14:30 — CPI** | l'unico orario della live | r.47 | 🔴 **fuso NON dichiarato** → `[INCERTO]` |

---

## 5-bis. 📷 COSA C'ERA A SCHERMO E NON NEL PARLATO — le domande per Claudio

🔴 **La trascrizione e' solo AUDIO.** Tutta la live e' *"guarda qui"*, *"questo
livello"*, *"questa zona"*. Quei pannelli **non li conosco e non li deduco**.

| # | cosa serve | perche' | riga |
|---|---|---|---|
| **S1** 🔴 | **Il grafico H4/H1 al momento del rifiuto per "poco spazio"** | E' l'unico modo di sapere **da quale media** siano misurati i **26-30 punti** (EMA14 di H4? EMA200 di D1?) e **da dove a dove**. 🔴 **Senza questo, M1 non e' implementabile con una soglia: si puo' solo misurare la distribuzione** (vedi §5, P1) | **r.83, r.93** |
| **S2** 🔴 | **Il pannello ordini con le size** (*"50 e 1"*, *"10 contratti"*, *"10, 10 e 20"*) | Ci serve **l'unita'** (lotti? contratti? mini?) e il **saldo del conto**, altrimenti i P/L in euro (−135, −300) non diventano mai percentuali | **r.93, r.95** |
| **S3** 🟠 | **L'orologio dello strumento / l'ultima candela** | Chiuderebbe il buco del **FUSO** sul "14.30" del CPI (r.47) | **r.47** |
| **S4** 🟠 | **Il pannello delle Bande di Bollinger** | *"le tengo 37, 3"* e' l'unico parametro numerico di indicatore della live, ed e' **dubbio in trascrizione** | **r.95** |
| **S5** 🟠 | **Le impostazioni del Supertrend** (i "tre livelli") | Il **periodo ATR** non e' mai detto. Noi usiamo `InpStAtrPeriod=10`: un pannello chiuderebbe il confronto | **r.5, r.29, r.43** |
| **S6** 🟡 | **La "zona di price action / presection" tracciata** | 🔴 **Settima live consecutiva** in cui questo concetto e' il perno del ragionamento (r.93, r.95, r.193) **senza una regola di costruzione dichiarata**. Uno screenshot con la zona tracciata vale piu' di mille righe | **r.193** |

---

# 5. 🎯 LA PROPOSTA — due cose, non di piu'

> 🔴 **Nessuna delle due e' stata fatta. Sono proposte. Non ho toccato EA, preset,
> parametri, forward, ne' il conto 10105439.**
> 🧭 **Criterio della bussola**: la challenge e' **viva da oggi** e i round **non girano
> piu' sul VPS** (firma del 21/09). Quindi propongo **una sola cosa che consuma tempo
> macchina**, e la piu' economica possibile.

---

## 🥇 P1 — LA SONDA DELLO SPAZIO (misura in sola lettura, **nessun EA toccato**)

| campo | contenuto |
|---|---|
| **Che cosa si misura** | Per ogni segnale che una sedia esistente avrebbe preso, si registra **la distanza in punti indice fra il prezzo d'ingresso e il PRIMO ostacolo dinamico davanti** — EMA 14/50/100/200 e Supertrend — **su TF+1 e TF+2** (H1 → H4 → D1), e la si incrocia con **l'esito del trade**. Output: la **distribuzione** dello spazio nei trade vinti contro i persi, e la **curva della soglia** (che succede al PF se veto sotto 10/20/30/40/50 punti, e sopra 150/200/300). |
| **Perche' questa forma e non un input nell'EA** | 🔴 **Perche' R30.** Il parente stretto di M1 (`InpUseSRFilter`) e' stato **bocciato fuori campione** dopo essere stato *"la cella piu' bella del lotto"* in campione. Mettere subito un input nuovo e ottimizzarlo significherebbe **rifare R30 con un altro nome**. La sonda invece risponde alla domanda **prima** di scrivere un parametro da ottimizzare: *lo spazio davanti separa i vinti dai persi, si' o no?* Se la risposta e' no, il lavoro finisce li' a costo quasi zero. |
| **Su quale sedia** | Le due **candidate della rosa** dove il materiale della live e' pertinente: `ABTG_Nasdaq_Apertura_US` (NASUSD) e `ABTG_DAX_Apertura_EU` in RETEST (`770101`, D30EUR — **la live e' tutta sul DAX**). Due lati separati (regola del 25/08). |
| **Precedente in casa** | ✅ **Il mestiere c'e' gia'**: `ABTG_SondaM0PB.mq5` r.72 misura *"Quanto spazio ha davanti quel rientro, in PUNTI INDICE?"*; `ABTG_SondaLondonFx.mq5` r.94 e `ABTG_SondaRsiEmaV8.mq5` r.131 fanno lo stesso in pip. **Si riusa lo schema**, cambiando **cosa** e' l'ostacolo (media/Supertrend su TF superiore invece del massimo recente). |
| **Costo in tempo macchina** | 🟢 **Molto basso**: una sonda **non apre posizioni**, quindi gira **su barre M1/OHLC, non a tick reali** — i due lati nella stessa corsa (come M0PB). Stima: **1 corsa da ~10-20 minuti per simbolo** sul **PC di backtest** (mai sul VPS, firma del 21/09). Piu' il tempo di scrivere la sonda. |
| **Costo umano** | 1 sorgente nuovo (`ABTG_SondaSpazio.mq5`) + 1 file prova coi cancelli **congelati prima dei numeri** + passaggio dal **cancello** (`controlla_riga.py` + `controllo-preventivo`). |
| **Cosa NON fa** | ❌ non tocca nessun EA vivo · ❌ non propone nessuna soglia · ❌ non entra in campo. **Produce un istogramma e una tabella.** |

### 🧪 IL CONTRO-ESEMPIO — in quale situazione M1 farebbe PEGGIO

Come richiesto, provo a **rompere** la mia stessa proposta. Ci riesco, in quattro modi:

1. 🔴 **Il contro-esempio MISURATO, e vale piu' degli altri tre: R30.**
   `InpUseSRFilter` tagliava il **13% dei trade** e **tagliava quelli buoni**: IS
   **+221 / PF 1,27**, OOS **−57 / PF 0,97** — **l'unica cella rossa del round**
   (`REFERTO_ROUND30_REGALI_AMICO.md` r.20, r.28, r.33-37). Il meccanismo di M1 e'
   della stessa famiglia. **Se la sonda dicesse che lo spazio separa i vinti dai persi,
   il primo sospetto dev'essere che stia guardando il campione, non il mercato.**
2. 🔴 **Il giorno di breakout vero.** Un breakout parte **proprio** quando il prezzo e'
   addosso alla media che sta per tagliare: "poco spazio" **e' la condizione iniziale
   della giornata migliore**. Il filtro veta l'ingresso alle 09:00 con la EMA200 di H4
   a 25 punti, e il DAX poi fa 200 punti nella stessa direzione. **La fonte stessa lo
   ammette in diretta** (r.95): *"lui adesso sta rompendo, perche' la forza da sotto e'
   uscita ... la forza di questa strategia e' piu' forte rispetto al fatto che abbiamo
   qua un minimo precedente"*. **Hanno rinunciato a un movimento che poi e' arrivato.**
3. 🔴 **Sui motori di RITORNO ALLA MEDIA il filtro e' rovesciato.** Se la media e' il
   **bersaglio** (`ABTG_VwapRevert`; `ABTG_EMA200` r.58 `InpTP1_ATRmult = 0` = *"TP1
   su EMA14"*, cioe' **il primo target E' una media**), "poca
   distanza dalla media" e' **esattamente cio' che si vuole**. Applicare M1 a quei
   motori li spegnerebbe. 👉 **Conseguenza operativa: M1 va misurato SOLO su motori di
   BREAKOUT/CONTINUAZIONE**, e la sonda deve dichiararlo nel file prova.
4. 🟠 **Il costo in FREQUENZA, che oggi e' il vincolo n.1.** Il pavimento e' **1,00
   op/giorno per famiglia** (firma del 07/09). Un filtro che taglia il 13-30% dei
   segnali puo' portare una famiglia **sotto il pavimento**: sarebbe un PF piu' bello
   su una sedia **non schierabile**. 👉 **La sonda deve stampare il conteggio dei
   segnali persi PER LATO**, non solo il PF: e' un cancello, non una curiosita'.

> ✅ **Il contro-esempio l'ho costruito e non e' debole: e' il motivo per cui P1 e' una
> SONDA e non un input.** Se non riuscissi a costruirlo, non consegnerei la proposta.

---

## 🥈 P2 — RINFORZO DI UNA PROPOSTA GIA' APERTA (costo macchina: **ZERO in piu'**)

Non apro un secondo fronte. **Aggiungo una prova a una proposta gia' scritta.**

| campo | contenuto |
|---|---|
| **Che cos'e'** | La proposta **C1 del referto del 18/09** (`report/ANALISI_LIVE_EMILIANO_2026-09-18.md`): mettere ad asse **`InpFirstFraction` + la distanza fra il 1° e il 2° ordine** — voce **17 dell'audit = MAI misurata**, valore vivo `0,3333` mai giustificato. |
| **Che cosa aggiunge QUESTA live** | 🟢 Un **terzo punto sulla stessa curva**: r.95 **59 punti = troppo distanti**, con la meccanica spiegata (*"e' molto probabile che i prezzi mi toccano il primo e rimbalzano ... e' difficile che me lo vada a prendere"*). Insieme al 18/09 (**20 pt si' · 40-50 pt no**) la fonte disegna una soglia **fra 20 e 40 punti indice DAX**. 🟢 E conferma la frazione: r.93 *"**un terzo** lo vado a piazzare"* = il nostro `0,3333`. |
| **Su quale sedia** | `SuperWave DOW H1` (`770511`) come da C1, e — 🆕 **aggiunta di oggi** — `ABTG_EMA200` (`771531`), dove i due pendenti sono `InpOrder1Atr=0.10` / `InpOrder2Atr=0.35` (r.49-50): la **distanza fra i due ordini e' 0,25 ATR, e non e' mai stata misurata**. |
| **Costo in tempo macchina** | 🟢 **ZERO in piu' rispetto a C1**: e' lo **stesso asse**, con un valore in piu' nella griglia. |
| **Perche' vale la bussola** | `ABTG_EMA200` e' **la prima sedia**, l'unica che passa i cancelli alla lettera — **e CLAUDE.md dice che il binario in campo ha DUE fail-open sul Guardian**. Qualunque cosa la riguardi ha priorita' strutturale. |

### 🧪 IL CONTRO-ESEMPIO su P2

🔴 **In quale caso "due ordini vicini" e' PEGGIO?** Quando il secondo ordine serve da
**assicurazione contro lo sweep**: se i due pendenti sono vicini, uno sweep di 30 punti
li prende **entrambi** e raddoppia la perdita; se sono lontani, il secondo resta fuori
e viene cancellato. 👉 **"Vicini" ottimizza il tasso di riempimento e PEGGIORA il
rischio di sweep** — ed e' esattamente il rischio che il 04/08 ci ha stoppato due
`Live5m` in **61 e 20 secondi** (`ABTG_DAX_Apertura_EU.mq5` r.1385-1388).
✅ **Conseguenza: l'asse deve riportare il DD e il peggior giorno accanto al PF**, non
solo il profitto. Altrimenti si compra frequenza col rischio, che e' il modo classico
di bruciare una challenge.

---

## ❌ COSA **NON** PROPONGO, e perche' (la parte che conta quanto le proposte)

| meccanismo | perche' NO |
|---|---|
| **M4 — Open Weekly come bias direzionale** | 🔴 **Nessuna soglia dichiarata.** *"Fa da spartiacque"* non si misura. Un filtro di bias senza distanza minima non e' codificabile → **va nelle domande** |
| **M6 — confluenza fra medie di TF diversi** | 🟠 E' **vera per costruzione aritmetica** (EMA200@M15 ≈ EMA50@H1 ≈ EMA14@H4 = la stessa finestra di ~3.000 minuti): un filtro che non filtra |
| **M7 — livello statico obbligatorio per la EMA200** | 🟠 **La piu' tentante, e la lascio fuori per disciplina**: richiede di definire *"livello di massimi e minimi contrapposti"* (r.95) **senza che la fonte lo definisca**, e richiede **codice nuovo** su una sedia della rosa a dieci giorni dalla challenge. 👉 **Diventa il PASSO 2 di P1** se la sonda dice che lo spazio conta: la sonda puo' misurare **anche** la presenza di un livello statico, a costo zero |
| **M12 — cancellazione per cambio di struttura** | 🟠 Vero buco nostro, ma **la fonte non da' nessuna soglia** (*"un eccesso di volatilita'"*) |
| **D5 — stop giornaliero a conteggio** | 🔴 Il predicato della fonte e' *"nate male"* = un giudizio. La versione codificabile sarebbe **una nostra invenzione con la sua etichetta**, e quello non si fa |
| **BR1 — la "correzione"** | ⛔ **Vietato per noi.** Documentato come intelligence, mai proposto |
| **Bande di Bollinger "37, 3"** | 🔴 Parametro **dubbio in trascrizione**. Non si mette in griglia un numero indovinato |
| **M5 — ORB 15 minuti** | 🏆 La nostra misura (35-45 min, 8/8 OOS) batte la quarta ripetizione della stessa fonte |

---

# 📎 FILE COLLEGATI

- 🗂️ **Fonte**: `trascrizioni/LIVE_EMILIANO_2026-04-10.txt`
- 🎙️ Live precedenti dello stesso canale: `report/ANALISI_LIVE_EMILIANO_2026-09-18.md`
  (**C1/C2** — da leggere insieme a questo) · `report/ANALISI_LIVE_EMILIANO_2026-09-09.md` ·
  `backtest_pipeline/caccia_strategie/ANALISI_TRASCRIZIONI_2026-09-14.md`
- 🔬 **Il precedente che pesa su P1**: `backtest_pipeline/risultati_archivio/REFERTO_ROUND30_REGALI_AMICO.md`
- 🚩 Il precedente sulla mediazione: `backtest_pipeline/caccia_strategie/ANALISI_CORSO_MEDIAZIONE_2026-08-18.md`
- 🧪 Modello di sonda da riusare per P1: `mql5/Experts/ABTG_SondaM0PB.mq5` (r.60-90)
- 🔧 Sorgenti citati: `mql5/Experts/ABTG_MaxMinNotte.mq5` · `ABTG_DAX_Apertura_EU.mq5` ·
  `ABTG_Nasdaq_Apertura_US.mq5` · `ABTG_Apertura_3Ingressi.mq5` ·
  `mql5/Experts/standalone/ABTG_EMA200.mq5` · `ABTG_WOL.mq5`

---

## ✅ IN UNA RIGA

**Su 208 righe: 12 meccanismi codificabili (2 nuovi per noi, 4 gia' in codice, 3
confermati al centesimo, 3 non misurabili), 4 bandiere rosse (1 grave: media valore
con size progressiva, ammessa dalla fonte stessa a r.127-129), 9 regole di sola
disciplina, ~35 numeri dichiarati.**
🏆 **Il dato piu' solido e' il piu' noioso: il nostro `InpBufferPoints = 1000` (10 punti
indice sotto i minimi della notte) e' confermato parola per parola da una fonte esterna
che opera sullo STESSO strumento e sullo STESSO broker** (r.93 contro
`ABTG_MaxMinNotte.mq5` r.140).
🆕 **La cosa nuova e' UNA: il filtro dello spazio verso l'ostacolo DINAMICO sul TF
SUPERIORE, in forma di BANDA (26-30 punti = troppo poco · 170-500 = troppo).** Non ce
l'abbiamo in nessun EA — e il parente che avevamo, R30, e' stato bocciato fuori
campione. 👉 **Per questo la proposta e' una SONDA, non un input.**
