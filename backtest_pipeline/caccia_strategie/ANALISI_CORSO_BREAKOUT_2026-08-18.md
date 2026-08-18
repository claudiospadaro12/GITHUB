# 🎓 ANALISI DELLE TRASCRIZIONI — MODULO BREAKOUT DEL CORSO DI CLAUDIO

**Data:** 18/08/2026 · **Fonte:** 7 trascrizioni, lezioni 34-40, in
`backtest_pipeline/caccia_strategie/trascrizioni_corso_2026-08-18/` (54.787
caratteri, **lette per intero, riga per riga**).

**Consegna gemella:** la specifica implementabile sta in
`backtest_pipeline/prove/BREAKOUT_CORSO_SPEC.md`. **Qui** ci sono le schede per
lezione, le citazioni, le contraddizioni e il confronto col repo; **li'** c'e' la
strategia montata per un developer. Non duplico: linko.

> ⚠️ **Differenza rispetto a un'analisi di video di terzi.** Questa non e' una
> fonte esterna da soppesare: e' **il corso che Claudio ha comprato**, ed e' la
> **tesi** dietro alla sedia `BREAKOUT_EA_JPY_v3` che gira sul conto piccolo
> **senza contratto** (`report/CONTRATTI_SEDIE.md`, riga 46: _"famiglia
> SCARTATA pre-progetto ... della v3 non esiste alcun referto"_). L'obiettivo
> non e' promuovere ne' demolire: e' **dare finalmente un processo** alla
> strategia prima della decisione in D-SPEGNIMENTI.
>
> 🔒 **Nessuna modifica al forward. Nessuna modifica a `PIANO_PROP.md`.**
> Qui si misura e si propone, non si tocca.

---

> 🆕🆕 **AGGIORNAMENTO 18/08 sera — E' STATO ANALIZZATO IL MODULO PRECEDENTE
> (MEDIAZIONE, lezioni 26-33), E CHIUDE TRE NODI DI QUESTO REFERTO.**
> **Referto:** `ANALISI_CORSO_MEDIAZIONE_2026-08-18.md` §1.8 ·
> **spec:** `backtest_pipeline/prove/MEDIAZIONE_CORSO_SPEC.md`
> **Non duplico qui: linko.** In sintesi di una riga per nodo:
>
> | nodo di questo referto | esito dal modulo Mediazione |
> |---|---|
> | **§1.7 — Williams 140 o 14?** | ✅ **CHIUSO: 140.** Altre **TRE** occorrenze (lez. 26 ×2, 27, 33), **PDF incluso**, con motivazione (_"non e' casuale, e' stato studiato"_). Il sospetto storpiatura e' morto. |
> | **§1.9 punto 2 — dov'e' il modulo che imposta il SuperTrend?** | 🟡 **LOCALIZZATO: e' il modulo di LEONARDO**, prima della lezione 26 (`[T]` lez. 26: _"il setup che voi avete gia' ... costruito insieme a **Leonardo**"_). Catena: Breakout → Mediazione → Leonardo. **I parametri restano un buco, ma ora si sa a chi chiederli.** |
> | **§1.5(a) — "gli scenari 1%/3% sono UNA lista ri-scalata"** (era `[I]`, dedotto per aritmetica) | ✅ **CONFERMATO DALLA FONTE.** Lez. 32 della Mediazione descrive il metodo: _"moltiplicando per 2 o per 3 quelli che sono i profitti e le perdite maturate"_. **L'inferenza si promuove a citazione.** |
>
> ➕ **Bonus:** le soglie Williams **−20 / −80 / −50**, qui inferite (§1.3), nel
> modulo Mediazione sono confermate da **valori letti ad alta voce** (−78,46 ·
> −22,93 · −49).
> ➕ **Coerenza:** la lez. 39 attribuiva alla mediazione _"27-30%"_; la lez. 32
> della Mediazione dice **30%** ✅ — ⚠️ ma e' **la stessa autrice: una fonte.**

---

# PARTE 1 — 🔥 LA SINTESI, PRIMA DI TUTTO

> 🆕 **AGGIORNATO 18/08 ~15:15 — SONO ARRIVATE LE SLIDE DEL PDF (lez. 40).**
> 14 screenshot = **10 slide uniche**. Hanno **chiuso 6 ambiguita' su 10** e
> alzato la meccanizzabilita' **dal 71% all'87%**. **Ma NON hanno chiuso i due
> nodi bloccanti** (periodo Williams, parametri SuperTrend), perche' **il PDF
> non tratta i parametri degli indicatori**.
> ➡️ **Dettaglio completo nella PARTE 2-BIS.** Le due novita' che cambiano il
> giudizio: la **regola discrezionale NON esiste nel PDF** (§2b.5, cade
> l'obiezione "nessun EA puo' replicare il corso") e la **contraddizione 1% per
> operazione / 1% complessivo** (§2b.6, e' un fattore 7 sul rischio).
> **I conteggi nel §1.1 qui sotto sono quelli originali, pre-slide.**

## 1.1 Il verdetto in tre righe

1. **La strategia e' meccanizzabile al 71%** (24 regole certe su 34 decisioni
   operative). Le altre 10 sono ambiguita': **8 le ho risolte con un
   argomento**, 2 restano aperte. Piu' **13 buchi**, di cui **uno bloccante**.
2. **L'EA che gira e' fedele — molto piu' di quanto mi aspettassi.** Implementa
   correttamente perfino il dettaglio piu' controintuitivo del corso (il
   break-even sulla **chiusura della candela di segnale**, non sul proprio
   prezzo di ingresso). Ho trovato **2 sole divergenze**.
3. **Il corso e il nostro backtest si contraddicono frontalmente** sullo stesso
   perimetro: **+133%** contro **−20.853 EUR**. Uno dei due e' sbagliato, e
   solo uno dei due ha un artefatto riproducibile.

## 1.2 🚨 IL FATTO PIU' PESANTE: corso contro backtest, stesso perimetro

| | **corso** (lez. 39) | **noi** (`docs/Portafoglio_Strategie.md` §Breakout JPY) |
|---|---|---|
| universo | 7 cross JPY | 7 cross JPY — **identico** |
| timeframe | M15 | M15 — **identico** |
| rischio | 1% | 1% — **identico** |
| orizzonte | _"ultimi due anni"_ | 2022-2024 — **quasi identico** |
| **risultato** | **+133%** su 5.000 EUR | **−20.853 EUR** aggregato |
| **PF** | non dichiarato | **0,67-0,95 su TUTTE e 7** |
| **max DD** | _"quasi 4%"_ | **30-48% per coppia** |

Non e' una divergenza di sfumatura: e' **segno opposto e ordine di grandezza
incompatibile**. Le tre spiegazioni possibili, in ordine di quanto le ritengo
probabili:

- **(A) I numeri del corso non reggono.** Vedi §1.5: sono un foglio di calcolo
  senza N operazioni, senza win rate, senza broker, senza date — e con
  un'aritmetica che tradisce una **ri-scalatura**, non una simulazione.
- **(B) Il nostro EA e' infedele su un punto che conta.** Ho trovato **due
  candidati concreti** (§1.4). Questa possibilita' **non e' esclusa** e finora
  non e' mai stata verificata: della v3 **non esiste referto**.
- **(C) Parametri diversi.** Il SuperTrend del corso **non e' mai stato
  dettato**: i nostri `ATR 10 / mult 3.0` potrebbero non essere i suoi.

> 🎯 **Questo e' il processo che mancava alla sedia.** Prima di oggi la
> famiglia JPY era "scartata pre-progetto" con un numero e nessun referto.
> Adesso ci sono **tre ipotesi falsificabili** e si sa **cosa chiedere** per
> chiuderle.

## 1.3 📊 TABELLA DEI VALORI CONVERGENTI

> ⚠️ **Avvertenza metodologica obbligatoria: qui la convergenza vale POCO.**
> Le 7 trascrizioni sono **7 lezioni dello stesso relatore nello stesso corso**:
> sono **UNA fonte**, non sette. Un valore ripetuto 4 volte non e' "confermato
> da 4 fonti", e' **la stessa persona che si ripete**. La ripetizione qui serve
> solo a distinguere cio' che il corso **sostiene stabilmente** da cio' che ha
> detto **una volta sola** (e che quindi puo' essere un lapsus o un errore
> speech-to-text).

| parametro | valore | lezioni che lo dicono | robustezza interna |
|---|---|---|---|
| Timeframe | **M15** | 37, 40 | 🟢 stabile |
| Universo | **7 cross JPY** (elencati nominalmente) | 35, 40 | 🟢 **elenco completo due volte, coincidente** |
| Rettangolo | **20 candele** | 36 (×5), 38 (×4), 40 (×3) | 🟢 dominante |
| Rettangolo | ~~15 candele~~ | **solo 36, all'inizio** | 🔴 **contraddetta dal relatore stesso mentre conta ad alta voce** |
| Rischio/operazione | **1%** | 35, 37, 39, 40 | 🟢 stabile |
| R:R target | **1:3** | 37, 40 | 🟢 stabile |
| R:R minimo su ingresso ritardato | **1:2** | 37, 40 | 🟢 stabile |
| SL | **1 pip oltre l'estremo del rettangolo** | 37, 40 | 🟢 stabile |
| Ancora dei livelli | **chiusura della candela di segnale** | 37, 38 (×3), 40 (×2) | 🟢 **martellata: e' il cuore del metodo** |
| BE | **a +1R, sulla chiusura del segnale** | 37, 38, 40 | 🟢 stabile |
| Linea mediana Williams | **−50** | 38, 40 | 🟢 stabile |
| Banda Williams SELL | **−50 / −20** | 38 | 🟠 **una volta sola** (40 dice "0/−50", vedi §1.6) |
| Banda Williams BUY | **−80 / −50** | 40 | 🟠 una volta sola, ma simmetrica |
| **Williams periodo** | **140** | **solo 35** | 🔴 **UNA occorrenza in tutto il corpus** — vedi §1.7 |
| Trailing stop | **400 punti = 40 pip** | solo 37 | 🟠 una volta, e declassato a facoltativo in 40 |
| Tetto DD complessivo | **20%** | 39, 40 | 🟢 stabile |
| Storico minimo prima di alzare il rischio | **20 operazioni** | solo 40 | 🟠 una volta |
| Filtro orario | **NESSUNO, esplicitamente** | 40 | 🟢 **assenza dichiarata, non dimenticata** |
| SuperTrend: parametri | — | **MAI** | 🔴 **buco bloccante** |

## 1.4 🔬 CONFRONTO COL REPO — le 2 divergenze del codice

Ho ricostruito la spec dal **solo parlato**, e **poi** ho aperto
`mql5/Experts/BREAKOUT_EA_JPY.mq5` (706 righe). Dettaglio completo in
`BREAKOUT_CORSO_SPEC.md` §10.

### ✅ Fedele su 18 punti su 20
Compresi quelli che un implementatore distratto sbaglia: candela di segnale
**esclusa** dal rettangolo (`CopyHigh(..., 2, RectBars, ...)`), R misurato
**dalla chiusura del segnale** (`stopDist = MathAbs(cl1 - sl)`), e soprattutto
il break-even posto su `sigClose` con tanto di commento nel codice
_"FEDELTA' (video 38): il BE NON usa il prezzo di fill reale"_.

### 🔴 Divergenza 1 — manca il vincolo delle 20 candele dall'ingresso in zona
Il corso e' esplicito (lez. 36):
> _"si iniziera' a contare il nostro canale, nel senso che dovremo andare da
> quella candela in avanti per almeno 20 candele seguenti. **Quindi prima di
> quel tempo noi non riusciremo ad avere nessun setup di breakout.**"_

Il codice attiva `trackZone` appena `W >= -20` e da li' accetta il segnale, ma
`UpdateRectangle()` prende **sempre le ultime 20 candele chiuse**. **Non esiste
nel file alcun contatore di barre dall'ingresso in zona.** → L'EA puo' entrare
poche candele dopo l'ingresso in ipercomprato, su un rettangolo composto in
gran parte da candele **precedenti** la fase che il corso vuole misurare.

**E' la divergenza piu' seria, ed e' la piu' facile da correggere** (un
contatore). Effetto atteso: **meno segnali, piu' selettivi** — cioe' proprio la
direzione in cui un PF di 0,67-0,95 avrebbe bisogno di muoversi.

### 🔴 Divergenza 2 — i parametri del SuperTrend non vengono dal corso
Il codice ha `ATRPeriod = 10`, `ATRMultiplier = 3.0`. **Questi due numeri non
compaiono in nessuna delle 7 lezioni.** La lez. 35 tratta il SuperTrend come
gia' impostato: _"Utilizzeremo il Supertrend ancora una volta"_, _"Lo abbiamo
fatto nel modulo precedente"_.
→ **Finche' non si verifica, sono parametri NOSTRI.** Un backtest a −20.853 EUR
puo' dipendere da due numeri che abbiamo scelto noi.

### ⚠️ E il problema di fondo: il sorgente in campo non c'e'
Sul conto piccolo gira **`BREAKOUT_EA_JPY_v3`**. Nel repo esistono **solo**
`BREAKOUT_EA_JPY.mq5` e `BREAKOUT_EA_JPY_Multi.mq5`. **Il confronto qui sopra
e' fatto sulla v1**, e non e' dimostrato che descriva cio' che gira.

## 1.5 🧮 I NUMERI DEL CORSO — cosa dice l'aritmetica

> Tutti `[dichiarato dal corso, NON verificato da noi]`. Unica lezione con
> numeri: la 39, che commenta a voce **un foglio di calcolo mai dettato**.

**(a) I drawdown scalano ESATTAMENTE col rischio** — e questo tradisce il metodo.
Da 1% a 3% (fattore 3): `4% × 3 = 12%` ≈ **11% dichiarato**; `7% × 3 = 21%` ≈
**20% dichiarato**. Due conseguenze:
- **Le etichette a rischio 3% sono INVERTITE** (dice _"20% atteso e 11%
  stimato"_ dove a 1% l'ordine era _"4% effettivo e 7% atteso"_).
- **Non sono due simulazioni: e' UNA lista di operazioni ri-scalata.** Quindi
  gli scenari 1% e 3% **non sono due conferme, sono una sola fonte.**

**(b) I termini non sono mai definiti.** Cosa distingue drawdown _"effettivo"_,
_"atteso"_ e _"stimato"_ non e' spiegato in nessuna delle 7 lezioni. **Senza
definizione quei numeri non sono confrontabili** con i nostri max DD da report
MT5. Non e' pignoleria: e' la ragione per cui "4%" e "30-48%" potrebbero
perfino non misurare la stessa cosa.

**(c) Il 4% di max DD a rischio 1% e' difficile da credere.** Con R:R 1:3 la
maggioranza delle operazioni perde. Un max DD del 4% a 1% per trade significa
**mai piu' di ~4 stop pieni consecutivi in due anni su 7 cross**. Su un
campione dell'ordine di 100+ operazioni con ~60% di esiti negativi, l'assenza di
una serie di 5+ perdite ha probabilita' trascurabile. **Attenuante onesta:** il
BE a +1R converte molte perdite in **zeri**, e questo comprime il DD davvero —
ma non fino al 4%.

**(d) Cosa NON dichiara:** N operazioni · win rate · broker · spread · date
esatte · slippage. **Sei buchi su una lezione che esiste per dare numeri.**

## 1.6 ⚔️ LE CONTRADDIZIONI INTERNE DEL CORSO

| # | contraddizione | dove | esito |
|---|---|---|---|
| 1 | **15 vs 20 candele** | lez. 36 dice "15" due volte, poi conta fino a 20 ad alta voce e dice "almeno 20" | ✅ risolta: **20** (tutte le altre lezioni) |
| 2 | **"almeno 20" vs "al massimo 20"** | lez. 36 vs lez. 40 | ✅ risolta: **esattamente 20**, finestra mobile |
| 3 | **candela di rottura dentro o fuori il rettangolo** | lez. 36: _"compresa anche la candela di rottura, **se vogliamo**"_ vs, 2 righe dopo, _"le 20 candele **che precedono** la candela di rottura"_ | ✅ risolta per necessita' logica: **fuori** (altrimenti la candela non puo' rompere il proprio minimo) |
| 4 | **Williams "ancora in ipercomprato" MA "uscito dall'ipercomprato"** — nella **stessa frase** | lez. 40 | ✅ risolta: **uscito**, banda [−50,−20] |
| 5 | **banda SELL "tra 0 e −50" vs "tra −20 e −50"** | lez. 40 vs lez. 38 | ✅ risolta: **−50/−20** (la 38 e' piu' specifica; la simmetria col caso BUY −80/−50 lo impone) |
| 6 | **trailing stop dal proprio fill vs BE sulla chiusura del segnale** | lez. 37 vs lez. 38/40 | ✅ risolta: **BE sulla chiusura del segnale, niente trailing** (la 40 declassa il trailing ad aiuto facoltativo) |
| 7 | **le 20 candele dall'ingresso in zona sono obbligatorie?** | lez. 36 dice di si' esplicitamente; lez. 38 valida un segnale dove _"non ci sono state le 20 candele di congestione nel frattempo"_ | 🔴 **APERTA** — e cambia il numero di segnali |
| 8 | **"un unico ordine per volta": per cross o per portafoglio?** | lez. 37, detto in contesto mono-cross ma con 7 grafici preparati | 🔴 **APERTA** — cambia il rischio di portafoglio di **7 volte** |
| 9 | **errore di trascrizione**: _"Williams che esce dall'area di **ipervenduto**"_ in un setup **SELL** | lez. 36 riga 19 | ✅ lapsus evidente: il contesto e tutta la lezione dicono ipercomprato |

## 1.7 🔴 IL NUMERO DA VERIFICARE PRIMA DI TUTTI: Williams 140

- Compare **una sola volta in 54.787 caratteri** (lez. 35: _"il nostro Williams,
  sempre settato a 140 periodi"_). **Zero convergenza interna.**
- Il default di mercato del Williams %R e' **14**.
- Su M15, 140 periodi = **35 ore** di look-back: toccare −20 significa essere sul
  massimo di 35 ore. **Fra 14 e 140 la frequenza dei setup cambia di un ordine
  di grandezza.**
- Il codice ha `WilliamsPeriod = 140`, quindi **l'errore, se c'e', e' gia'
  dentro il backtest a −20.853 EUR**.

> ⚖️ **Non sto dicendo che sia sbagliato.** Il corso dice _"sempre"_, come di
> cosa gia' stabilita nel modulo precedente — coerente con un settaggio reale.
> Sto dicendo che **e' un numero critico appeso a una singola frase
> trascritta**, e che verificarlo costa uno screenshot.

## 1.8 🏛️ ATTRITI CON LE REGOLE PROP (il corso non parla mai di prop)

1. **News.** L'esempio-principe della lez. 37 e' un ingresso **su rilascio
   macro**: _"un salto collegato allo ... pubblicazione di alcune notizie
   macroeconomiche"_. `report/METRO_PROP.md` §7 registra che diverse prop
   **limitano il news trading**. La strategia **non ha filtro news** e nel suo
   esempio migliore fa proprio cio' che alcune prop vietano.
2. **Rischio simultaneo.** Se "un ordine per volta" e' per **cross**, 7
   posizioni all'1% su 7 coppie che condividono lo yen = fino al **7% su
   un'unica direzione**. Contro un daily loss del 5%, e' una violazione a
   portata di **una singola giornata di yen**. Il nostro stesso dossier lo dice
   gia': _"7 cross JPY altamente correlati = un'unica scommessa sullo yen"_.
3. **Nessun cap giornaliero.** L'unico tetto del corso e' il **20% di drawdown
   complessivo** — misura di portafoglio personale, non regola prop.

## 1.9 ❓ LE DOMANDE PER CLAUDIO (in ordine di quanto sbloccano)

> 🆕 **Aggiornate dopo le slide.** ✅ La n.1 (il PDF) **e' stata evasa**: ha
> chiuso 6 ambiguita', **non i due nodi bloccanti**. La nuova n.1 e' il
> **modulo precedente**, e si e' aggiunta una domanda **piu' urgente di tutte**
> (la n.0 qui sotto).

0. 🔴🔴 **NUOVA E PRIORITARIA — "1% per operazione" o "1% COMPLESSIVO"?**
   Il parlato dice per operazione, **la slide S10 scrive "complessivo"**
   (§2b.6). **E' un fattore 7 sul rischio di portafoglio** e tocca direttamente
   l'interpretazione del nostro `−20.853 €`. **Va sciolta prima di qualunque
   nuova misura.**
1. ✅ ~~Il PDF della lezione 40~~ — **RICEVUTO**, 10 slide, 6 ambiguita' chiuse.
2. 🔴 **La trascrizione (o gli screenshot) del MODULO PRECEDENTE**, quello che
   imposta Williams+SuperTrend — citato in lez. 35 come _"Lo abbiamo fatto nel
   modulo precedente"_. 🆕 **Ora e' la richiesta n.1 fra i documenti**, perche'
   le slide hanno **dimostrato** che il PDF del modulo Breakout **non contiene i
   parametri degli indicatori**: non esiste altra fonte. Senza, i nostri
   `ATR 10 / 3.0` e il `Williams 140` restano **scelte nostre**.
3. 🟠 **Screenshot del pannello del Williams: 140 o 14?** (§1.7)
4. 🟠 **Dov'e' il sorgente di `BREAKOUT_EA_JPY_v3`?** Non e' nel repo: non
   sappiamo con certezza cosa gira sul conto piccolo.
5. 🟡 **Screenshot del foglio di calcolo della lez. 39** (il minuto in cui
   mostra il report): servono **N operazioni, win rate, date, broker**. Senza,
   i suoi numeri non sono confrontabili coi nostri e la contraddizione di §1.2
   resta indecidibile.
6. 🟡 **Sciogliere l'ambiguita' 7** (20 candele dall'ingresso in zona:
   obbligo o no) e l'**ambiguita' 8** ("un ordine per volta": cross o
   portafoglio).

## 1.10 🧭 COSA PROPONGO (proposta, non azione)

> 🔒 Nessuna modifica applicata. La sedia resta dov'e', in D-SPEGNIMENTI.

Il punto non e' "riaccendere" o "spegnere": e' che **il verdetto attuale
giudica un'implementazione mai verificata**. Tre passi in ordine di costo:

1. **Costo zero:** chiedere PDF + modulo precedente (§1.9 punti 1-2). Senza
   quelli, qualunque nuovo backtest ripete lo stesso possibile errore.
2. **Costo basso:** aggiungere il **contatore delle 20 candele dall'ingresso in
   zona** (divergenza 1) come **input A/B**, e ri-misurare il paniere 2022-24.
   E' l'unica divergenza di logica accertata, va nella direzione della
   selettivita', ed e' falsificabile in un round.
3. **Costo medio:** se e solo se arrivano i parametri veri del SuperTrend,
   ri-misurare con quelli. Prima no: si ottimizzerebbe su una nostra scelta
   spacciandola per "il corso".

**E comunque, indipendentemente dall'esito**, resta in piedi l'obiezione
strutturale che non dipende dal corso: **7 cross JPY correlati sono una sola
scommessa**, e il corso **non affronta mai il tema della correlazione**.

---

# PARTE 2 — 📇 LE SCHEDE, LEZIONE PER LEZIONE

---

## 📄 SCHEDA 1 — `34. STRATEGIA DI BREAKOUT.txt`

| campo | contenuto |
|---|---|
| **FILE** | `34. STRATEGIA DI BREAKOUT.txt` (1.977 caratteri) |
| **RELATORE** | non nominato nel testo `[INCERTO]`. Dalla lez. 37 (_"io sono entrat**a**"_) e dalla lez. 40 (_"vi lascio con Emiliano Monza per il prossimo capitolo"_) si deduce una **relatrice donna, diversa da Emiliano Monza** `[INFERITO]` |
| **OGGETTO** | Video introduttivo. Nessuna regola operativa. |

**PARAMETRI CON VALORE:** 🚫 **nessuno.**

**MECCANISMI (annunciati, non specificati):**
- Coglie l'uscita da fase laterale: _"coglie i segnali del mercato di uscita da
  una fase laterale"_ `[TRASCRITTO]`
- Promette un filtro per le false rotture: _"selezionare o isolare le cosiddette
  false rotture"_ `[TRASCRITTO]` — ⚠️ **promessa mai mantenuta con una regola
  dedicata**: l'unico filtro che il corso fornira' sono le 3 condizioni di
  ingresso (lez. 38/40)
- Criterio di scelta degli strumenti: _"valute che hanno come caratteristica
  quella di muoversi **senza forti ritracciamenti**"_ `[TRASCRITTO]`

**REGOLE PROP CITATE:** nessuna (il corso non parla mai di prop).

**NUMERI DI PERFORMANCE:** nessuno; solo la promessa _"Ti parlero' anche dei
risultati di questa strategia"_.

**BANDIERE ROSSE:** 🟢 nessuna. Nessuna griglia, nessuna martingala, nessun
recovery, nessun "senza stop loss". Apertura sobria.
🟠 Unica nota di marketing: _"una strategia **estremamente performante**"_ —
affermazione senza numero, in apertura.

**A SCHERMO E NON NEL PARLATO:** niente (video parlato, nessun grafico).

**COSA NE COPIAMO:** 🚫 **niente di operativo.** Serve solo a fissare l'intento
dichiarato (uscita da compressione + coppie senza ritracciamenti), che poi va
confrontato con cio' che la strategia fa davvero: **un fade**, non una
continuazione (vedi SPEC §1).

---

## 📄 SCHEDA 2 — `35. BREAKOUT SETUP OPERATIVO.txt`

| campo | contenuto |
|---|---|
| **FILE** | `35. BREAKOUT SETUP OPERATIVO.txt` (2.717 caratteri) |
| **OGGETTO** | Preparazione di piattaforma, indicatori e universo. **Lezione ad alta densita' di parametri.** |

**PARAMETRI CON VALORE:**

| parametro | valore | citazione | etichetta |
|---|---|---|---|
| Piattaforma | MT4 | _"Andiamo sulla nostra piattaforma MT4"_ | 🟢 TRASCRITTO chiaro |
| Indicatori | Supertrend + Williams | _"Utilizzeremo il Supertrend ancora una volta e il nostro Williams"_ | 🟢 chiaro |
| **Williams periodo** | **140** | _"il nostro Williams, sempre settato a **140 periodi**"_ | 🔴 **TRASCRITTO chiaro MA fonte singola** — vedi §1.7 |
| Universo | **7 cross JPY** | _"dollaro, euro Yen, sterlina Yen, Franco Yen, CAD Yen, NZD Yen e Audi Yen. Ok, **sono 7**"_ | 🟢 chiaro (_"Audi Yen"_ = AUDJPY, storpiatura ovvia) |
| **Rischio** | **1% per operazione** | _"iniziamo a inserire il rischio **1% per l'operazione**"_ | 🟢 chiaro |
| SuperTrend: parametri | — | **mai pronunciati** | 🔴 **BUCO** |

**MECCANISMI:**
- Profilo MT4 salvato con nome `breakout`, template `Williams e Supertrend`
  `[TRASCRITTO]` — organizzativo, non operativo.
- **Calcolatore di posizione esterno** (sito web): input = valuta conto, valore
  conto, rischio %, pip di stop → output = volume. `[TRASCRITTO]`
- Motivazione dell'universo: _"la strategia di breakout e' estremamente
  performante per alcune coppie in particolare, **in modo specifico per le
  coppie con lo Yen**"_ `[TRASCRITTO]` — ⚠️ **affermazione di selezione senza
  alcun dato a supporto**: non viene mostrato nessun confronto fra coppie.

**REGOLE PROP CITATE:** nessuna.

**NUMERI DI PERFORMANCE:** nessuno.

**BANDIERE ROSSE:**
- 🟠 **Selezione dell'universo non giustificata da numeri.** "Le coppie JPY
  rispondono meglio" e' affermato, mai misurato davanti allo studente. E'
  esattamente il punto su cui il nostro backtest dice il contrario.
- 🟠 **Il SuperTrend viene dato per gia' configurato** (_"Lo abbiamo fatto nel
  modulo precedente"_): il modulo Breakout **non e' autosufficiente**.

**A SCHERMO E NON NEL PARLATO:** 🖼️
1. **Il pannello parametri del SuperTrend** — mai letto ad alta voce.
   **E' il buco bloccante.**
2. Il template `Williams e Supertrend` (quali linee/soglie grafiche).
3. Il sito del calcolatore di posizione (nome mai pronunciato).

**COSA NE COPIAMO:** ✅ **Universo (7 cross JPY), Williams 140 (da verificare),
rischio 1%, MT4/M15.** Tutti gia' presenti in `BREAKOUT_EA_JPY.mq5`.

---

## 📄 SCHEDA 3 — `36.BREAKOUT SEGNALE, LIVELLI DI INGRESSO STO E TARGET. ESEMPIO 1.txt`

| campo | contenuto |
|---|---|
| **FILE** | `36.BREAKOUT SEGNALE, LIVELLI DI INGRESSO STO E TARGET. ESEMPIO 1.txt` (10.392 car.) |
| **OGGETTO** | Costruzione del rettangolo di congestione + definizione del segnale. **La lezione fondativa — e la piu' contraddittoria.** |

**PARAMETRI CON VALORE:**

| parametro | valore | citazione | etichetta |
|---|---|---|---|
| Rettangolo | ~~15~~ → **20 candele** | _"un rettangolo che deve contenere **15 candele**"_ → poi _"1, 2, 3, 12...19 e **20**"_ → _"deve abbracciare almeno **20 candele**"_ | 🔴 **CONTRADDIZIONE INTERNA risolta a favore di 20** |
| Ancoraggio | candela di ingresso del Williams in zona | _"Il canale deve essere realizzato nel momento in cui il Williams entra o in ipercomprato o in ipervenduto"_ | 🟢 chiaro |
| **Attesa minima** | **20 candele dall'ingresso in zona** | _"dovremo andare da quella candela in avanti per almeno 20 candele seguenti. **Quindi prima di quel tempo noi non riusciremo ad avere nessun setup di breakout**"_ | 🟢 chiaro — 🔴 **ed e' la divergenza 1 col codice** |
| Livelli | massimo e minimo **assoluti** (wick) | _"questo e' il livello piu' basso **toccato dalle candele**"_ | 🟢 chiaro |
| Fuso piattaforma | ora italiana − 2 | _"la piattaforma indietro di due ore rispetto alle ore al nostro orario effettivo"_ | 🟠 **TRASCRITTO ambiguo** sulla direzione — irrilevante (nessun filtro orario) |

**MECCANISMI:**
- **Filtro direzionale one-way:** _"Le rotture a rialzo non saranno valutate in
  questo contesto"_ (con Williams in ipercomprato) `[TRASCRITTO]`.
- **Rettangolo mobile:** _"il rettangolo traslera' in avanti e quindi ci
  definira' dei nuovi livelli di massimo e di minimo"_ `[TRASCRITTO]`.
- **Le 3 condizioni di segnale** (prima formulazione): _"rottura del canale con
  chiusura di candela ... Dobbiamo avere un super trend rosso e un Williams che
  esce dall'area di **ipervenduto**"_ — ⚠️ **lapsus**: il contesto e' un SELL da
  ipercomprato. `[TRASCRITTO — errore evidente del parlato]`
- **Motivazione del filtro oscillatore:** _"Se il Williams non e' in ipercomprato
  vuol dire che **non ho la forza adeguata** per poter realizzare un movimento a
  scendere"_ `[TRASCRITTO]` — ⚠️ e' una tesi, presentata come fatto, mai
  verificata nel corso.
- **Passaggio in rassegna dei 7 cross in diretta** (EURJPY, CHFJPY, CADJPY,
  GBPJPY, NZDJPY, AUDJPY): 3 in zona → si traccia; 3 fuori zona → **non si
  traccia niente**. Utile: mostra che il filtro **scarta molto**.

**REGOLE PROP CITATE:** nessuna.

**NUMERI DI PERFORMANCE:** nessuno.

**BANDIERE ROSSE:**
- 🔴 **Contraddizione 15/20 nella lezione fondativa.** Se uno studente si ferma
  alla prima definizione, implementa una strategia diversa.
- 🟠 **_"compresa anche la candela di rottura, SE VOGLIAMO"_** — una regola
  strutturale lasciata a discrezione, e per giunta **logicamente impossibile**
  (una candela non puo' rompere il proprio minimo).
- 🟠 **Il rettangolo si traccia a mano, a occhio**, contando le candele in
  diretta. Meccanizzabile senza problemi, ma spiega perche' due studenti
  possono ottenere livelli diversi.

**A SCHERMO E NON NEL PARLATO:** 🖼️
1. Le **soglie grafiche** dell'ipercomprato/ipervenduto sul Williams (guarda il
   grafico e dice "e' in ipercomprato" senza leggere il valore).
2. Lo strumento MT4 che conta le candele (_"possiamo usare anche questo
   strumento che vi fara' vedere il numero di candele"_).
3. Data e ora dell'esempio USDJPY.

**COSA NE COPIAMO:** ✅ **Rettangolo 20 candele mobile, ancorato all'ingresso in
zona, con attesa minima di 20 candele** (quest'ultima **manca nel codice**);
estremi assoluti; filtro direzionale one-way.

---

## 📄 SCHEDA 4 — `37. BREAKOUT GESTIONE DI RISCHIO CON SIZE DI INGRESSO E INSERIMENTO ORDINE A MERCATO.txt`

| campo | contenuto |
|---|---|
| **FILE** | `37. ... GESTIONE DI RISCHIO CON SIZE DI INGRESSO ...txt` (10.273 car.) |
| **OGGETTO** | Livelli concreti, sizing, ordine a mercato, break-even. **La lezione con l'unico esempio numerico completo.** |

**PARAMETRI CON VALORE — l'esempio USDJPY, verificato:**

| voce | valore | citazione | etichetta |
|---|---|---|---|
| Massimo congestione | **155,95** | _"il massimo e' stato segnato a 155,95"_ | 🟢 chiaro |
| **Stop loss** | **155,96** (1 pip sopra) | _"lo stop va a un pip sopra rispetto al massimo"_ | 🟢 chiaro |
| Chiusura candela di segnale | **155,57** | _"abbiamo una chiusura a 155 e 57"_ | 🟢 chiaro |
| **R teorico** | **40 pip** | _"se calcoliamo la distanza tra l'entrata teorica e lo stop, abbiamo 40 pip"_ | 🟢 chiaro |
| **Take profit** | **154,37** (= 120 pip) | _"40 pip per 3, quindi andiamo a 154 e 37"_ | 🟢 **aritmetica verificata: 155,57 − 1,20 = 154,37 ✅** |
| Distanza dal SUO ingresso | 41 pip | _"ci sono 41 pip di distanza"_ | 🟢 chiaro (ingresso reale ≠ teorico) |
| **Volume** | **0,41 lotti** | _"Abbiamo 0,41 come volume da inserire"_ | 🟠 **non trasportabile** — implica un conto ~17.000 EUR, non i 5.000 della lez. 39 (vedi SPEC §8.2) |
| Suo ingresso reale | 155,61 | _"io sono entrata a 155,61"_ | 🟢 chiaro |
| **Trailing stop** | **400 punti = 40 pip** | _"Io devo mettere un trailing stop a 40 pip, quindi questi 40 pip devono essere **400 punti**"_ | 🟢 chiaro |
| Nota punti/pip | 15 punti = 1,5 pip | _"15 punti sono un pip e mezzo"_ | 🟢 chiaro (broker a 3 decimali) |
| **R:R minimo** | **1:2** | _"L'importante e' mantenere un rapporto di rischio-rendimento almeno di tipo 1 a 2"_ | 🟢 chiaro |
| Durata rettangolo | 20 × M15 = **~3 ore** | _"20 candele di 15 minuti, stiamo parlando di circa tre ore"_ | 🟢 chiaro |

**MECCANISMI:**
- **Livelli ancorati alla candela di segnale, non al proprio fill:** _"il target
  rimane uguale per tutte le operazioni, indipendentemente dal punto di entrata"_
  `[TRASCRITTO]`.
- **Break-even a +1R:** _"al raggiungimento del primo 1% di profitto, noi
  dovremmo spostare lo stop a 0"_ `[TRASCRITTO]`.
- **Trailing come espediente, da rimuovere a mano:** _"Una volta che il mercato
  raggiunge il livello di trailing stop, ritorniamo sull'ordine, togliamo il
  trailing stop"_ `[TRASCRITTO]` — ⚠️ **contraddice il BE della lez. 38** (vedi
  §1.6 n.6).
- **🚫 Divieto di ordini pendenti:** _"e' bene non inserire degli ordini
  pendenti, perche' abbiamo bisogno di verificare intanto la posizione del
  Williams"_ `[TRASCRITTO]` — ⚠️ **vincolo umano, non logico**: un EA verifica
  gli indicatori alla chiusura per costruzione (vedi SPEC §6.5).
- **Un ordine per volta:** _"naturalmente dovete fare un unico ordine per volta"_
  `[TRASCRITTO]` — 🔴 **ambiguo**: per cross o per portafoglio? (§1.6 n.8)

**REGOLE PROP CITATE:** nessuna.

**NUMERI DI PERFORMANCE:** nessuno (solo l'operazione in corso).

**BANDIERE ROSSE:**
- 🔴 **Entra su una notizia macro** senza alcuna cautela: _"il mercato ha rotto
  la congestione attraverso tra l'altro anche un salto collegato allo ...
  pubblicazione di alcune notizie macroeconomiche"_. **Nessun filtro news
  esiste nella strategia.** Attrito diretto con le regole prop (§1.8).
- 🟠 **Due posizioni aperte sullo stesso cross** a scopo dimostrativo, subito
  dopo aver detto "un ordine per volta". Confonde la regola.
- 🟢 Nessuna griglia, nessuna martingala, **stop loss sempre presente**, size
  calcolata su rischio fisso. **Impianto di rischio sano.**

**A SCHERMO E NON NEL PARLATO:** 🖼️
1. 🔴 **Il capitale inserito nel calcolatore** — dice _"la montale del conto in
   questo caso"_ **senza pronunciare la cifra**. E' il motivo per cui 0,41
   lotti non e' verificabile.
2. Il calcolatore di posizione (interfaccia, formula).
3. Il pannello del trailing stop di MT4.

**COSA NE COPIAMO:** ✅ **Tutto l'impianto dei livelli** (SL 1 pip oltre,
R dalla chiusura del segnale, TP 3R, BE a +1R, R:R minimo 1:2, ordini a mercato)
+ **il test-case numerico 155,95 / 155,96 / 155,57 / 154,37** come regressione
per un EA.

---

## 📄 SCHEDA 5 — `38. BREAKOUT GESTIONE DEGLI ORDINI. ESEMPIO 2 E ESEMPIO 3.txt`

| campo | contenuto |
|---|---|
| **FILE** | `38. BREAKOUT GESTIONE DEGLI ORDINI. ESEMPIO 2 E ESEMPIO 3.txt` (13.323 car., **il piu' lungo**) |
| **OGGETTO** | Due esempi storici + la regola piu' sottile del corso + l'unica regola discrezionale. |

**PARAMETRI CON VALORE:**

| voce | valore | citazione | etichetta |
|---|---|---|---|
| **Banda Williams SELL** | **[−50, −20]** | _"entro appunto il livello tra meno 20, compreso il livello tra **meno 20 e meno 50**"_ | 🟢 chiaro — **unica formulazione precisa in tutto il corpus** |
| Esempio 1° maggio: stop | **35 pip** | _"lo stop andrebbe inserito a 35 pip di distanza"_ | 🟢 chiaro |
| Esempio 1° maggio: 1° target | 35 pip | _"il nostro primo target era a 35 pip di distanza"_ | 🟢 coerente (1R) |
| Esempio 1° maggio: esito | **+3%** | _"del 3% che invece e' stato portato a casa"_ | 🟠 **[dichiarato, NON verificato]** (= 3R a rischio 1%) |
| Esempio 3 maggio: esito | **+3%**, a target | _"e' andato a target, ha portato il suo 3%"_ | 🟠 **[dichiarato, NON verificato]** |
| Terzo esempio: stop | 37-38 pip | _"stiamo parlando di 38 pip di stop, 37 pip di stop"_ | 🟠 **TRASCRITTO oscillante** (si corregge in diretta) |
| Terzo esempio: movimento | 90 pip contro ~105-110 di target | _"il mercato si e' mosso per 90 pip e poi si e' fermato"_ | 🟢 chiaro — **esempio di operazione NON andata a target** |
| Orario segnale | "le 15" | _"questo segnale e' stato dato alle 15, perche' la piattaforma va indietro di due ore"_ | 🟠 ambiguo sul fuso |

**MECCANISMI — i due che contano:**

1. 🔑 **Il break-even va sulla CHIUSURA DEL SEGNALE, non sul proprio fill.** La
   regola piu' sottile del corso, spiegata con la sua motivazione:
   > _"lo stop va spostato **non sul livello di entrata che avete realizzato
   > voi** ... ma va spostato **sul livello di chiusura della candela del
   > segnale**"_ ... _"Se infatti voi aveste fatto un'entrata su queste aree ...
   > e aveste spostato il vostro stop a zero appena raggiunto il primo target,
   > vedete, i prezzi sarebbero ritornati indietro e vi avrebbero appunto
   > scacciati fuori dal mercato, con un guadagno pari a zero invece appunto
   > del 3%"_ `[TRASCRITTO]`
   ✅ **Il codice lo implementa correttamente** (`nSL = sigClose`).

2. **Le 3 condizioni possono arrivare in qualsiasi ordine, ma devono essere
   tutte vere sulla candela di segnale:**
   > _"e' possibile ... che il Williams esca prima rispetto al super trend ...
   > **bisogna aspettare tutti questi tre elementi** prima di poter entrare"_
   `[TRASCRITTO]` — l'esempio del 1° maggio e' esattamente questo: rottura e
   SuperTrend pronti, segnale **posticipato** fino all'uscita del Williams.

**🔴 LA REGOLA NON MECCANIZZABILE:**
> _"quando gia' il Williams va in area di ipercomprato prima del raggiungimento
> del target, **cominciamo un po' ad allertarci**"_ ... _"**Io personalmente mi
> preoccupo** ... pero' se si vuole essere un pochettino piu' [larghi] ... e'
> possibile **avanzare gli stop, magari**, o comunque **chiudere l'operazione**
> ... nel momento in cui abbiamo il segnale contrario"_ `[TRASCRITTO]`

→ **Tre comportamenti alternativi per la stessa situazione, senza criterio di
scelta**, e uno dei tre ("avanzare gli stop") **senza nemmeno un quanto**.
⚖️ **E' l'unica vera discrezionalita' della strategia, e incide molto**: decide
quante operazioni muoiono a BE invece di andare a 3R. Un EA deve sceglierne una,
e **la scelta e' nostra, non del corso**.

**REGOLE PROP CITATE:** nessuna.

**NUMERI DI PERFORMANCE:** due operazioni a +3% e una fermata a 90 pip su ~105
di target. Tutti `[dichiarato dal corso, NON verificato]`. ⚠️ **Sono esempi
scelti dal relatore**, non un campione: **selection bias per costruzione.**

**BANDIERE ROSSE:**
- 🟠 **Contraddizione aperta sulle 20 candele:** _"non ci sono state le 20
  candele di congestione nel frattempo"_ e il segnale viene comunque validato
  (§1.6 n.7).
- 🟠 **Esempi selezionati**: 2 vincenti raccontati per intero, 1 mezza-vincente.
  Nessun esempio di **perdita piena**. In una lezione intitolata "gestione degli
  ordini", **l'operazione che va a stop non viene mai mostrata.**
- 🟢 Nessuna martingala, nessun mediare in perdita, stop sempre presente.

**A SCHERMO E NON NEL PARLATO:** 🖼️
1. I grafici dei tre esempi: **coppia e anno non sempre dichiarati** (dice "1
   maggio", "3 maggio" — di quale anno? su quale cross?).
2. I livelli esatti dei rettangoli degli esempi 2 e 3.
3. Il valore del Williams nei punti chiave (letto a occhio).

**COSA NE COPIAMO:** ✅ **La banda Williams [−50,−20]**, ✅ **il BE sulla
chiusura del segnale**, ✅ **le 3 condizioni simultanee**. ⚠️ **NON copiamo** la
gestione "Williams all'estremo opposto": non e' una regola, e' un'inclinazione.

---

## 📄 SCHEDA 6 — `39. BREAKOUT BACKTEST STRATEGIA E MONEY MENAGEMENT.txt`

| campo | contenuto |
|---|---|
| **FILE** | `39. BREAKOUT BACKTEST STRATEGIA E MONEY MENAGEMENT.txt` (3.809 car.) |
| **OGGETTO** | **L'unica lezione con numeri di risultato.** Ed e' anche la piu' cieca: commenta un foglio di calcolo mai dettato. |

**PARAMETRI CON VALORE:**

| voce | valore | citazione | etichetta |
|---|---|---|---|
| Periodo | "ultimi due anni" | _"il report delle operazioni degli ultimi due anni"_ | 🟠 **date esatte MAI dichiarate** |
| Universo | tutte le coppie JPY | _"che sono state valutate su tutte le coppie con lo yen"_ | 🟢 chiaro |
| Capitale | **5.000 EUR** | _"con capitale di 5000 euro"_ | 🟢 chiaro |
| Tetto DD complessivo | **20%** | _"non dovrebbe superare il 20%"_ (lez. 40 conferma) | 🟢 chiaro |

**NUMERI DI PERFORMANCE — tutti `[dichiarato dal corso, NON verificato da noi]`:**

| scenario | dichiarato | citazione |
|---|---|---|
| **rischio 1%** | profitto **+133%** | _"il profitto ammonta al 133% rispetto al capitale iniziale"_ |
| **rischio 1%** | DD **~4% "effettivo"**, **7% "atteso"** | _"quasi un 4% di drawdown effettivo e un 7% di drawdown atteso"_ |
| **rischio 3%** | capitale **x8** | _"il capitale appunto aumenta di 8 volte"_ |
| **rischio 3%** | DD **20% "atteso"**, **11% "stimato"** | _"il drawdown all'interno della soglia del 20% come drawdown atteso e dell'11% come drawdown stimato"_ |
| confronto "mediazione" | +27-30% | _"era intorno al 27-30%"_ |
| N. operazioni · win rate · broker · date | **[BUCO] ×4** | mai dichiarati |

**🧮 ANALISI CRITICA (nostra, non del corso):**

1. **I DD scalano linearmente col rischio** → `4×3=12≈11` e `7×3=21≈20`.
   Conseguenze: (a) **le etichette a rischio 3% sono invertite**; (b) **non sono
   due simulazioni ma UNA lista di operazioni ri-scalata** → **una sola fonte,
   non due conferme**.
2. **"Effettivo" / "atteso" / "stimato" non sono mai definiti** → i numeri **non
   sono confrontabili** con i nostri max DD da report MT5.
3. **Il 4% di max DD a 1% per trade e' difficilmente credibile** con R:R 1:3 (la
   maggioranza delle operazioni perde): implicherebbe mai piu' di ~4 stop pieni
   consecutivi in 2 anni su 7 cross. Attenuante onesta: **il BE a +1R converte
   molte perdite in zeri**, e questo comprime il DD davvero — ma non fino al 4%.
4. **"Raddoppio" e "+133%" convivono** ✅ (2,33x, arrotondamento verbale).

**MECCANISMI:**
- **Aumento del rischio solo dopo storico** (dettagliato nella lez. 40).
- **Diversificazione come contenimento:** _"con tutte le strategie ... riuscirete
  ad avere il vantaggio della diversificazione contenendo comunque il rischio"_
  `[TRASCRITTO]` — 🔴 **e qui c'e' il problema di fondo**: applicare questa
  strategia a **7 cross che condividono tutti lo yen NON e' diversificazione**.
  Il corso **non affronta mai la correlazione**. Il nostro dossier lo aveva
  gia' scritto: _"7 cross JPY altamente correlati = un'unica scommessa"_.

**BANDIERE ROSSE:**
- 🔴 **Numeri di performance senza N operazioni, win rate, broker, date.** In una
  lezione che si chiama "backtest".
- 🔴 **Confronto competitivo con l'altra strategia del corso** ("la mediazione")
  presentato come dato: 133% vs 27-30%. Nessun controllo di rischio comparato.
- 🟠 **Linguaggio promozionale sui drawdown:** _"i profitti sono cosi' importanti
  che si **rimangiano prontamente** tutte le eventuali situazioni di
  difficolta'"_ — e' esattamente il ragionamento che porta ad alzare il rischio.
  ⚖️ **Va detto in favore del corso** che subito dopo frena: _"la strategia di
  breakout permette di avere ottimi risultati anche con dei rischi molto
  contenuti, quindi **non richiede esasperazione del rischio**"_.

**A SCHERMO E NON NEL PARLATO:** 🖼️
🔴 **L'INTERO FOGLIO DI CALCOLO.** Curva, lista operazioni, N, win rate, date,
broker: tutto mostrato, nulla dettato. **E' la lezione con i numeri ed e' la
piu' cieca del corpus.** → **Domanda 5 per Claudio.**

**COSA NE COPIAMO:** 🚫 **Nessun numero.** Si registra la dichiarazione (+133% /
DD 4% a 1%) **solo** per contrapporla al nostro backtest (§1.2). ✅ Si copiano
le due regole di money management (**20 operazioni prima di alzare il rischio**,
**tetto DD 20% complessivo**), che sono sane e sono le uniche cose verificabili
di questa lezione.

---

## 📄 SCHEDA 7 — `40. BREAKOUT PDF RIEPILOGATIVO.txt`

| campo | contenuto |
|---|---|
| **FILE** | `40. BREAKOUT PDF RIEPILOGATIVO.txt` (12.296 car.) |
| **OGGETTO** | Checklist finale. **La lezione piu' densa di regole e la piu' affidabile per la spec** — ma commenta un PDF che non abbiamo. |

**PARAMETRI CON VALORE (checklist completa):**

| voce | valore | etichetta |
|---|---|---|
| Universo | 7 cross JPY, elencati nominalmente | 🟢 **secondo elenco, coincidente con lez. 35** |
| Oro | `XAUSD` — _"risponde molto bene"_ ma **escluso** per capitale | 🟠 codice trascritto storpiato (XAUUSD) |
| **Orari** | **nessun filtro, esplicito** — _"possono essere tradate in qualsiasi momento della giornata"_ | 🟢 **assenza DICHIARATA** |
| Rettangolo | **20 candele su M15** | 🟢 chiaro |
| Rettangolo | _"al massimo 20 candele"_ | 🟠 vs "almeno 20" della lez. 36 |
| Banda Williams BUY | **[−80, −50]** | 🟢 chiaro |
| Banda Williams SELL | _"tra 0 e meno 50"_ | 🔴 **contraddice la lez. 38 (−20/−50)** |
| SL sell / buy | 1 pip sopra la resistenza / sotto il supporto | 🟢 chiaro |
| **TP** | **3R dalla chiusura della candela di segnale** | 🟢 chiaro (esempio: 20 pip → 60 pip) |
| R:R nominale | **1:3** | 🟢 chiaro |
| R:R minimo ingressi ritardati | **1:2** | 🟢 chiaro |
| BE | a +1R (= +1% se rischio 1%), sulla chiusura del segnale | 🟢 chiaro |
| Trailing | **facoltativo**, da disabilitare dopo il BE | 🟢 chiaro |
| Storico prima di alzare il rischio | **>= 20 operazioni** (anche demo) | 🟢 chiaro |
| Tetto DD | **20% complessivo su tutte le strategie** | 🟢 chiaro |

**MECCANISMI:**
- **Le tre condizioni di ingresso**, formulate simmetricamente per BUY e SELL —
  **la formulazione piu' pulita del corpus**, base della SPEC §5.
- **Uscita su segnale contrario:** _"non avrebbe senso mantenere un'operazione in
  piedi e quindi ... possiamo chiudere"_ `[TRASCRITTO]` — ⚠️ _"possiamo"_,
  formulato come facolta'.
- **Ancoraggio dei livelli alla candela di segnale**, ribadito due volte.

**🔴 LA CONTRADDIZIONE NELLA STESSA FRASE:**
> _"il Williams si deve **ancora trovare nell'area di ipercomprato**, quindi
> nell'area compresa ... **tra 0 e meno 50** ... **che deve essere uscito
> dall'area di ipercomprato**"_

"Ancora dentro" e "deve essere uscito" nella **stessa proposizione**. ✅ Risolta
a favore di **[−50,−20]** (SPEC §5.4): la lez. 38 e' piu' specifica, e il caso
BUY della stessa lezione (−80/−50) e' **simmetrico e non ambiguo**.

**REGOLE PROP CITATE:** nessuna.

**NUMERI DI PERFORMANCE:** nessuno nuovo; rimanda alla lez. 39.

**BANDIERE ROSSE:**
- 🟠 **La banda SELL sbagliata nella lezione di riepilogo.** Uno studente che
  studia **solo il PDF** implementa una banda diversa da quella della lez. 38.
  **E' l'errore piu' probabile per chi replica il corso.**
- 🟠 **L'oro dichiarato "risponde molto bene"** senza uno straccio di dato, e
  con una motivazione storica discutibile (_"per molti anni sono state
  agganciate le valute ... parita' con l'oro"_ — Bretton Woods e' finito nel
  1971: irrilevante per il comportamento intraday su M15 oggi).
- 🟢 Nessuna bandiera rossa di rischio: niente griglia, niente martingala, stop
  sempre, tetto DD dichiarato, gradualita' sul rischio.

**A SCHERMO E NON NEL PARLATO:** 🖼️
🔴 **LE SLIDE DEL PDF.** Il parlato le **commenta** ma non le **legge
integralmente**. **Il PDF e' il documento che puo' chiudere il buco del
SuperTrend** → **Domanda 1 per Claudio.**

**COSA NE COPIAMO:** ✅ **Praticamente tutta la checklist.** E' la spina dorsale
di `BREAKOUT_CORSO_SPEC.md`. ⚠️ **Con una correzione dichiarata**: banda SELL
[−50,−20] dalla lez. 38, **non** "0/−50".

---

# PARTE 2-BIS — 🖼️ LE SLIDE DELLA LEZIONE 40 (aggiornamento 18/08 ~15:15)

> Claudio ha mandato **14 screenshot** del PDF riepilogativo →
> `trascrizioni_corso_2026-08-18/slide_lezione40/`. Sono **10 slide uniche**
> (4 doppioni con timestamp diverso). **E' la meta' SCRITTA del corso**, quella
> che le trascrizioni non potevano vedere: la fonte piu' forte che abbiamo,
> perche' e' il **documento**, non il parlato.
>
> Etichetta: **`[SLIDE Sn]`**.

## 2b.1 Le 10 slide

| # | titolo | screenshot | cosa porta |
|---|---|---|---|
| S1 | Descrizione | `151240` | definizione: _"movimenti direzionali successivi ad una fase di compressione di volatilita'"_ |
| S2 | Insidie | `151302` + `151336` | le 3 difficolta': false rotture · R:R adeguato · strumenti adatti |
| S3 | **Cross da tradare** | `151343` | 🟢 i 7 cross + **XAU/USD** |
| S4 | **Identificazione area di congestione** | `151406` | 🔥 **20 candele + aggiornamento ad ogni chiusura** |
| S5 | **Segnale ingresso SELL** | `151429` | 🔥 **William's tra −20 e −50** |
| S6 | **Segnale ingresso BUY** | `151442` | 🔥 **William's tra −80 e −50** |
| S7 | **Livelli ingresso/stop/target** | `151456` + `151515` | 🔥 stop 1 pip · target ×3 · R:R 1:3 |
| S8 | **Validita' del segnale** | `151527` + `151537` | 🔥 **le tre uscite obbligatorie** |
| S9 | **Gestione dell'operazione** | `151549` + `151600` | 🔥 **stop in pari dai parametri della strategia** |
| S10 | **Money management** | `151619` | 🔥 **"rischio COMPLESSIVO dell'1%"** |

## 2b.2 🎯 I tre nodi prioritari: 1 chiuso a meta', 2 NON chiusi

| nodo | esito |
|---|---|
| **(a) Williams 140 o 14?** | 🔴 **NON CHIUSO.** Nessuna slide scrive il periodo: dicono solo _"dell'indicatore William's"_. Il dubbio **sopravvive** intatto. |
| **(b) Parametri SuperTrend** | 🔴 **NON CHIUSO — ma ora sappiamo PERCHE'.** Le slide dicono _"supertrend rosso"_ / _"verde"_ e **mai** ATR o moltiplicatore. ⚠️ **Il PDF non tratta i parametri degli indicatori**: non e' uno screenshot mancante, e' che il documento non se ne occupa. **Solo il modulo precedente puo' chiuderlo.** |
| **(c) Vincolo 20 candele** | 🟡 **CHIUSO A META'.** S4: _"Esso deve contenere 20 candele"_; S5/S6: _"si costruisce a partire dal primo ingresso del William's nell'area"_. **Ne segue** che 20 candele devono essere trascorse. Ma **nessuna slide lo scrive come attesa esplicita** → implicazione forte, non citazione. **La divergenza n.1 del codice resta molto probabile, non certa.** |

## 2b.3 ✅ Sei ambiguita' su dieci: CHIUSE DALLA FONTE

| ambiguita' | prima | ora |
|---|---|---|
| **15 vs 20 candele** | risolta per argomento | ✅ `[S4]` _"deve contenere **20 candele**"_ |
| **"almeno" vs "al massimo" 20** | risolta per argomento | ✅ `[S4]` _"aggiornato ad ogni chiusura di candela"_ = **finestra mobile di 20** |
| **banda SELL "0/−50" vs "−20/−50"** | risolta per argomento | ✅ `[S5]` **_"William's compreso tra -20 e -50"_** → il _"tra 0 e meno 50"_ del parlato era **un errore verbale**, ora e' dimostrato |
| **"ancora dentro" vs "uscito"** | risolta per argomento | ✅ `[S5]`/`[S6]` danno solo la banda numerica, senza la frase contraddittoria |
| **trailing vs break-even** | risolta per argomento | ✅ `[S9]` scrive **solo** lo stop in pari. **La parola "trailing" non compare in NESSUNA slide** → e' un espediente del video, non strategia |
| **XAU dentro o fuori** | incerta, ticker storpiato | ✅ `[S3]` _"Anche il gold **XAU/USD** risponde bene ma richiede capitali di partenza piu' elevati"_ |

## 2b.4 🆕 Tre cose che le slide AGGIUNGONO

1. **`[S4]` Cadenza esplicita:** _"Il rettangolo dovra' essere **aggiornato ad
   ogni chiusura di candela**"_. Il parlato diceva solo "man mano". Ora e' una
   regola implementabile alla lettera.

2. **`[S8]` Le uscite diventano OBBLIGO:** _"L'operazione **si chiudera'** in
   caso di: Stop loss / Take profit / **Segnale direzionale contrario**"_.
   Nel parlato era _"**possiamo** chiudere"_. La slide usa l'indicativo.
   → 🔴 **Impatto sul codice:** nell'EA la chiusura su segnale contrario e' un
   **flag A/B** (`CloseOnOppositeSignal`). Secondo il PDF **non e' opzionale**.
   E il nostro dossier annotava che _"disattivare le chiusure anticipate
   aiutava"_ — cioe' **il test che aiutava era il test INFEDELE**.

3. **`[S10]` La parola che cambia tutto:** _"si consiglia per le prime 20
   operazioni di tenere un **rischio COMPLESSIVO dell'1%**"_.

## 2b.5 🔥 IL REPERTO PIU' IMPORTANTE: cosa NON c'e' nel PDF

**La regola discrezionale — _"il Williams arriva all'estremo opposto prima del
target"_, con i suoi tre comportamenti alternativi e l'_"io personalmente mi
preoccupo"_ — NON COMPARE IN NESSUNA SLIDE.**

Nella checklist ufficiale della stessa autrice, la slide S8 elenca **tre e sole
tre** uscite. Quel blocco della lez. 38 e' un **commento a braccio**, non una
regola.

> ⚖️ **Conseguenza:** un EA che NON la implementa **non e' infedele: e' piu'
> fedele al documento**. **Cade l'unica vera discrezionalita' della strategia**,
> e con essa l'obiezione "nessun EA puo' replicare il corso".

## 2b.6 🚨 LA NUOVA CONTRADDIZIONE: 1% per operazione o 1% complessivo?

| fonte | cosa dice |
|---|---|
| lez. 35 (parlato) | _"iniziamo a inserire il rischio **1% per l'operazione**"_ |
| lez. 37 (parlato) | _"un per cento come **rischio per operazione**"_ |
| **`[S10]` (scritto)** | _"tenere un **rischio COMPLESSIVO dell'1%**"_ |

La stessa autrice usa "complessivo" nel senso di *aggregato su tutto* anche
altrove (_"drawdown **complessivo** con tutte le strategie"_, lez. 39/40).

> 🔴 **Perche' e' il punto piu' pesante emerso oggi:** e' un **fattore 7** sul
> rischio di portafoglio. Con "per operazione" su 7 cross correlati si arriva al
> **7% a rischio su un'unica direzione dello yen**; con "complessivo",
> all'**1%**.
>
> **E tocca direttamente il nostro −20.853 €:** e' plausibile che il backtest di
> paniere abbia girato in modalita' "1% per cross", cioe' con **7 volte** il
> rischio che il PDF consiglia. Non spiegherebbe un PF < 1 (il PF non dipende
> dalla size), **ma spiegherebbe benissimo i drawdown del 30-48% per coppia** e
> il confronto impietoso col _"quasi 4%"_ dichiarato.
>
> 🎯 **E' diventata la prima domanda da porre**, prima ancora del SuperTrend.

## 2b.7 📋 Conteggio aggiornato

| | prima delle slide | dopo le slide |
|---|---|---|
| Regole certe | 24 | **26** |
| Ambiguita' | 10 | **4** |
| Buchi | 13 | **11** |
| Regole discrezionali | 1 | **0** |
| **Meccanizzabilita'** | **71%** | **87%** |

## 2b.8 🕳️ Cosa resta FUORI (e da chi puo' arrivare)

| manca | ancora fuori? | da dove puo' venire |
|---|---|---|
| **Parametri SuperTrend** | 🔴 **SI — bloccante** | **Solo dal modulo precedente.** Il PDF Breakout non li tratta: dimostrato |
| **Periodo Williams (140?)** | 🔴 **SI** | Modulo precedente o screenshot del pannello indicatore |
| **Trascrizione modulo SuperTrend** | 🔴 **SI, resta fuori** | Claudio |
| **Sorgente `BREAKOUT_EA_JPY_v3`** | 🔴 **SI, resta fuori** | Non e' nel repo: nessuna slide poteva chiuderlo |
| **Foglio di calcolo lez. 39** (N operazioni, win rate, broker, date) | 🔴 **SI** | Fra le 14 slide **non ce n'e' nessuna della lezione 39**: i numeri di performance restano senza documento |
| Attesa 20 candele | 🟡 implicata, non scritta | Domanda a Claudio |
| 1% per operazione o complessivo | 🔴 **contraddizione nuova** | Domanda a Claudio |

---

# PARTE 3 — 🗑️ GLI SCARTI

**Nessuna trascrizione e' stata scartata.** Tutte e 7 hanno contribuito.
La sola con **zero contenuto operativo** e' la **34** (introduzione): non e' uno
scarto perche' fissa l'intento dichiarato della strategia, che serve a mostrare
lo scarto fra cio' che il corso **dice di fare** (cavalcare un'espansione di
volatilita') e cio' che le regole **fanno davvero** (vendere la rottura del
minimo con l'oscillatore in ipercomprato = **un fade**).

**Cosa NON c'e' in nessuna delle 7 trascrizioni** (e che era lecito aspettarsi):
- ❌ Parametri del SuperTrend
- ❌ Un solo esempio di operazione **perdente** raccontato per intero
- ❌ Il numero di operazioni del backtest
- ❌ Qualunque menzione di **correlazione** fra i 7 cross
- ❌ Qualunque menzione di prop firm, drawdown giornaliero, news filter
- ❌ Qualunque menzione di **spread** o costi di transazione

---

# 📎 APPENDICE — INDICE DELLE CONSEGNE

| file | contenuto |
|---|---|
| `backtest_pipeline/prove/BREAKOUT_CORSO_SPEC.md` | **La specifica implementabile** — 24 regole certe, 10 ambiguita', 13 buchi, confronto col codice, test-case numerico |
| `backtest_pipeline/caccia_strategie/ANALISI_CORSO_BREAKOUT_2026-08-18.md` | **questo file** — sintesi incrociata + 7 schede + scarti |
| `backtest_pipeline/caccia_strategie/trascrizioni_corso_2026-08-18/` | le 7 trascrizioni (fonte) |
| `report/CONTRATTI_SEDIE.md` riga 46 | la sedia `BREAKOUT_EA_JPY_v3` **senza contratto** |
| `docs/Portafoglio_Strategie.md` §Breakout JPY | il backtest 2022-24 che contraddice il corso |
| `mql5/Experts/BREAKOUT_EA_JPY.mq5` | il codice confrontato (⚠️ **non e' la v3**) |
