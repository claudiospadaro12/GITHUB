# 🔬 ANALISI DELLO STUDIO ESTERNO «PS5 ORB BOT» — cosa ci serve, cosa no, cosa ci CONTRADDICE

**Data: 06/09/2026** · dossier dell'**architetto-prop**
**Fonte esaminata:** `PS5 ORB BOT — DOCUMENTO MASTER`, Marco Garbuglia,
10/08/2026, EA v2.60 (190 righe, letto integralmente).
Consegnato a Claudio da un collega del corso trading. **Materiale di TERZI.**

> 🛑 **Questo dossier non tocca niente.** Nessun EA, nessun preset, nessun
> parametro di forward, nessun conto. Porta un **confronto** e delle
> **proposte dichiarate e NON applicate**. Decide Claudio.

---

## 0. 🥇 LA RIGA CHE RESTA

> **Su NOVE punti su undici il documento di Garbuglia dice, con numeri suoi e
> per strade sue, quello che noi diciamo con numeri nostri: la conferma
> esterna più densa che questo progetto abbia mai ricevuto.**
>
> **Ma sul parametro che riguarda la sedia che abbiamo acceso OGGI sul conto
> reale — il pavimento dello stop dell'ORB — dice l'ESATTO CONTRARIO di
> R55.** E non è un errore né suo né nostro: **misuriamo due grandezze
> diverse.** Lui misura cosa fa allo *edge per trade* (PF), noi cosa fa al
> *drawdown a rischio percentuale* (la taglia). **Allargare lo stop peggiora
> il PF e migliora il DD.** Un ORB a stop stretto è ottimo per il profit
> factor e **pessimo per il muro di una prop**.
>
> 🎯 E la cosa che nessuno dei due ha misurato è **già un input dei nostri
> EA**: `InpSkipIfTight` — *saltare* il trade invece di allargarlo.

---

## 1. 📜 CHE RANGO HA QUESTA FONTE (dichiarato prima dei numeri)

Applicando la gerarchia di casa (`report/PIANO_PROP.md`, intestazione):

| | |
|---|---|
| **Rango** | **4° — DICHIARAZIONE SINGOLA.** Un solo autore, un solo corpus, un solo broker. **Non** è convergenza esterna: i «4 documenti di ricerca» che cita sono suoi, prodotti da lui fra il 21 e il 27 luglio |
| **Cosa NON è allegato** | nessun `.htm` del tester, nessun CSV per-trade, nessun `.set`, nessuno screenshot. **Ogni numero è da prendere sulla parola.** |
| **Cosa lo rende comunque prezioso** | **è un forward REALE finito in perdita, raccontato con il conto in euro davanti** (§8), e con le tre cause nominate. Questa è la parte che vale, ed è la parte che quasi nessuna fonte esterna porta mai |
| **Regola di casa applicata** | *«i numeri dichiarati da vendor/video non decidono niente da soli: al massimo aprono un parametro, mai lo chiudono»*. 👉 **Niente qui dentro chiude una nostra riga. Una la APRE** (§4) |

### 1-bis. 🔴 I QUATTRO DIFETTI DEL DOCUMENTO, trovati leggendolo

Vanno agli atti perché tarano quanto peso dargli:

1. **Incoerenza interna sui numeri di US2000.** §4 (tabella portafoglio) dà
   **PF 2,46**; §5 e §7 dicono *«US2000 da **2,97** a 1,05-1,40»*. Due valori
   diversi per lo stesso asset nello stesso documento, senza nota.
2. **«Quattro sedute su quattro», ma le coppie elencate sono TRE** (§5:
   −104/−1.415 · −1.632/−1.422 · −1.738/−1.694). La quarta non c'è.
3. 🔴 **Il difetto che pesa di più: la tabella che decide il deploy usa
   numeri che il documento stesso dichiara inaffidabili.** §2 misura che il
   coarse **gonfia il PF di ~2×** (US100: 2,18 coarse → **1,15** al tick);
   §4 pubblica il portafoglio con PF 2,17-3,01 e ammette solo *«sono di
   backtest e vanno letti con la sezione 2 in mente»* — **senza mai dare la
   versione al tick**. E §10 lo conferma: *«US30 è il motore principale ed è
   ancora l'unico grande asset senza verdetto tick sulla sua vera finestra»*.
   👉 **Il PF 3,01 di US30, che è la riga migliore del portafoglio, non ha un
   verdetto tick.** Con il suo stesso fattore 2× diventerebbe ~1,5.
4. **Stessa riserva sul confronto del pavimento** (§5: DAX 2,40 → 1,26): non
   è dichiarato **con quale modello** è stato misurato. Se fosse coarse,
   ricade nel suo stesso avvertimento.

> ⚖️ Questo **non** squalifica il documento: lo colloca. È una fonte di
> 4° rango, onesta sui metodi, **debole sulla tracciabilità dei numeri** —
> esattamente il difetto che la nostra regola *«un numero senza fonte non
> entra»* esiste per evitare.

---

## 2. ✅ CONFERMA INDIPENDENTE — undici voci, con l'evidenza dei DUE lati

Regole che **già abbiamo** e che qui trovano una conferma indipendente, con
numeri diversi dai nostri. **Non richiedono azione**: rafforzano la fiducia.

| # | tema | LUI (numeri suoi) | NOI (numeri nostri, fonte) | lettura |
|---|---|---|---|---|
| **C1** | 🚫 **Recovery / martingala SEMPRE spenta** | coarse US30 no-rec **PF 3,01** · ×1 **2,65** · ×1,5 **1,73** → **al tick: PF 0,91, DD 17%**. E sul conto vero, 29/07-04/08: rientro dopo lo stop in **4 sedute su 4**, costo netto **−2.836 €** | clausola scritta **in testata** su 8 sorgenti (`ABTG_BreakinBox.mq5:112`, `ABTG_CRT_TurtleSoup.mq5:52`, `ABTG_ChaosLyapunov.mq5:35`…): *«NIENTE martingala/griglia/recovery/DCA/mediazione»*; `ABTG_BreakingBand.mq5:347` `InpMaxPositions = 1` | 🥇 **La conferma più forte del dossier.** Noi la recovery l'abbiamo esclusa **per principio, senza mai misurarla**: il suo numero è **la misura che a noi manca**. E il costo in euro su conto vero è la prova che nessun backtest ci avrebbe dato |
| **C2** | 📉 **Il modello di prezzo grossolano GONFIA il profit factor** | coarse M1 → tick: US100 **2,18 → 1,15** (fattore **1,9×**). *«12 mesi verdi in coarse diventano −11% al tick»* | `SupRev_DOW_H4` (magic 970914): OHLC **PF 2,77** → tick reali **0,79** = fattore **3,5×**, **promozione REVOCATA** (`CONTRATTI_SEDIE.md:106`, `CLASSIFICHE.md:42`) | Due misure **indipendenti**, stesso fenomeno. **La nostra è peggiore della sua.** Nessuno dei due sta esagerando |
| **C3** | 🔍 **Si verifica il TERMINALE, non il file `.set`** | §8: la config live era impostata su un documento **superato di due giorni**, con moltiplicatore ×1,0 invece di ×0,75; lo stop del DAX **misurava 13,9 punti** mentre il set ne prevedeva altri. **−6.395 € = 74%** della settimana negativa, tutto di configurazione | **la sovrataglia ORB sul 100k**: `770611` a **1,0% invece di 0,3% = 3,3×**, vissuta **NOVE GIORNI** (21→24/08 e oltre), misurata su **sei coppie appaiate** — rapporto lotti da 5,86-6,44 a **20,29 e 19,70**. Verifica indipendente: 59,00 pt × 19,70 lotti × 0,8625 = **1.002 € = 0,996% del conto** (`PIANO_PROP.md` riga A2, `ORB_GEMELLI_DIVERGENZA_2026-08-22.md`) | **La stessa classe di errore, sui due conti, nello stesso mese.** Lui l'ha pagata 6.395 €, noi abbiamo scoperto che *«il dry-run FTMO aveva una sedia in positivo solo perché era fuori contratto»*. 👉 Vedi **P4** |
| **C4** | 🧨 **Il DEFAULT SILENZIOSO è una trappola** | §9 passo 2: verificare **da F7** i tre valori critici (pavimento 0, chase 15, livelli recovery 0) prima di partire | **la trappola del 2%**: `ABTG_DEF_RISK = 2.0` nel sorgente + un preset che **non copriva l'input** → riga A5 del piano, chiusa il 02/09 (`VERBALE_CHIUSURA_770101_2026-09-02.md` §C4). E il 06/09 i due preset del conto reale sono stati resi **esaustivi**, col commento in chiaro: *«il default silenzioso è esattamente la trappola del 2%»* | Stessa diagnosi. **Noi siamo un passo avanti**: lui verifica a mano da F7 (che si dimentica), noi rendiamo il file **completo** (82 chiavi = 82 input sul DAX, 54 = 54 sull'ORB) **e** lo verifichiamo dal log |
| **C5** | ✂️ **L'haircut sul backtest ideale — e l'onestà di dire che non è tarato** | §6: haircut **30%** (+130%/anno, DD 4,72%) e **50%** (+93%, 6,38%). *«L'haircut non è ancora tarato sul dato vero»* = **loop aperto n.1** | `ASPETTATIVE_REALISTICHE.md`: *«il tester dice ~11%/mese a taglia 0,65%; si **divide per tre**… il "diviso tre" è un giudizio d'esperienza, **non una misura**»* (= haircut **67%**). E `STIMA_GUADAGNI_5PROP_2026-08-27.md:23`: haircut 50% **[DICHIARATO ARBITRARIO]** | Stesso metodo, **stessa onestà sull'incalibratura**, indipendentemente. **Il nostro è più severo del suo** (67% contro 30-50%) |
| **C6** | 📏 **Lo slippage è IL loop aperto, e si misura con due campioni in mano** | §6: **due soli campioni**. US30 **4,67 punti = 27% dello stop**; NAS **2,38 = 13%**. *«Servono 2-4 settimane di log»* | **stesso giorno, stesso problema**: `MISURA_SLIPPAGE_2026-09-05.md` (921 uscite dal tester: mediana in sessione **0,40**, P95 **3,25**, ma **fuori sessione P95 92,68 e max 294,40**) + `ABTG_SlippageLogger.mq5` **deployato sul conto REALE** il 05-06/09, perché *«BCM ha confermato che il conto DEMO NON simula lo slippage»* | **Convergenza perfetta sul problema, e noi abbiamo già lo strumento.** Lui ha 2 campioni e nessun attrezzo; noi abbiamo 921 misure del tester (che è un **pavimento**, non il vero) e un logger che raccoglie il vero. 👉 Vedi **P7** |
| **C7** | 🎲 **Monte Carlo con ricampionamento PER GIORNATA** | §6: *«10.000 percorsi con ricampionamento per giornata, che preserva la sequenza intraday»* | `REFERTO_M1_MC_TRAILING.md`: *«rimescolo dei **GIORNI INTERI** (correlazione same-day conservata), 2000 iterazioni, seed 42»* | **Identica scelta metodologica, presa indipendentemente.** Ed è quella giusta, perché il muro **giornaliero** di una prop si sfonda *dentro* la giornata. Unica differenza: **10.000 contro 2.000 percorsi** → vedi **P6** |
| **C8** | 📐 **Lo spread si legge come % dello STOP, non in punti** | §7/§9: regola **spread÷SL**, *«sotto il 20% vive, oltre il 50% muore»*. US2000 su FTMO scartato per **spread pari al 90% dello stop**; UK100 spread **19% del range** | lezione **R55**, citata in almeno **10 dossier di caccia**: *«lo spread va misurato in % dello stop, non in punti»* (`CACCIA_LONDRA_2026-08-19:168`, `CACCIA_M5M15_INDICI:263`, `CACCIA_FREQUENZA4_GH_TV_FF:654`…) e `InpMaxSpreadToStopPercent=10.0` in `CACCIA_2026-08-16_C_NIKKEI_GAP.md:229` | **Stessa metrica, numeri diversi** (noi 10%, lui 20/50) e **nessuno dei due tarato**. 👉 Parametro da APRIRE, chiudibile con dati che **abbiamo già**: vedi **P2** |
| **C9** | ⏰ **Lo spread si misura NELL'ORARIO DI TRADE, non a mercato calmo** | §9: *«misurare lo spread ÷ SL per ciascun asset nell'orario di trade (15:30 per gli USA, 09:00 per il DAX), non a mercato calmo»* | `SPREAD_FLOTTA_MISURA_2026-09-03.md`: **252 milioni di tick**, spread **ora per ora**. In sessione NASUSD 1,6-1,8 · U30USD 1,9-2,0 · D30EUR 1,6-1,7. **Fuori sessione: DAX di notte 3,5-3,9 (più del doppio), Dow ora 23 P95 7,0 e massimo 101 punti indice** | Stessa regola. **Noi l'abbiamo già pagata con la misura**, e la misura ha trovato una coda che nessuna media mostrava |
| **C10** | 🎯 **Il giudizio si dà su PF e DD, MAI sul rendimento netto** | §3: *«il compounding lo gonfia a piacere»* | `ASPETTATIVE_REALISTICHE.md` intero (*«metro di laboratorio, non busta paga»*) + criterio `OnTester` su **Recovery Factor** su tutta la flotta (`stats[3] = TesterStatistics(STAT_RECOVERY_FACTOR)`, ~30 sorgenti) | Conferma piena. **Ironia**: è la regola che lui stesso viola in §6, pubblicando **+186% / +130% annuo** come titolo (vedi **N4**) |
| **C11** | 🔗 **La cancellazione della gamba opposta (OCO) è una PROTEZIONE, non una preferenza** | §3: *«le aperture hanno frequenze di inversione altissime — **35% su UK100, 57% su DAX, 68% sul Russell** — e qualsiasi schema che rientri dopo uno stop moltiplica l'esposizione proprio all'evento che ha causato la perdita»* | `ABTG_ORB_Ottimizzato.mq5:1021`: *«OCO: appena una posizione NOSTRA esiste, il pendente opposto si cancella»* — con **due bug pagati e corretti**: riga 1022 *«v1.04: prima questa riga era dietro il `SelPos()` cieco»* e riga 344 *«il pendente opposto restava vivo (scadenza 600') e riapriva in giornata»* | **Abbiamo pagato lo stesso bug e l'abbiamo corretto due volte.** E lui porta il **perché numerico** che noi non avevamo: le frequenze di inversione all'apertura |

---

## 3. 💡 IDEA NUOVA DA VALUTARE — otto voci

Cose che **non facciamo** e che potrebbero valere. Ciascuna con il costo vero.

| # | idea | cosa fa lui | cosa facciamo noi OGGI | perché vale / cosa costa |
|---|---|---|---|---|
| **I1** | 🎯 **La parziale a 80% / 1,5R** (contro il nostro 50% / 1,0R e contro *nessuna parziale*) | `InpPartialRR / Pct = **1,5 / 80**`, con la nota: *«testato: chiudere il 50%, o aspettare 2,0R, **peggiora entrambi**»* | **DAX reale**: `InpTP1_R=1.0` · `InpTP1_ClosePct=50.0` · `InpBreakevenAtTP1=true`. **ORB reale**: `InpTP_R=1.0` · **`InpTP1Pct=0.0` = NESSUNA parziale** (100% a 1R), con BE e trailing EMA | 🥇 **È una griglia GRATIS: sono già input dei nostri due EA, zero codice.** ⚠️ La sua è una **affermazione senza numeri** («testato» e basta) → rango 4°, apre un parametro, non lo chiude. ⚠️⚠️ E cambiare la parziale su una cella promossa **è cambiare la cella**: serve il suo round, con i criteri congelati **prima**. Vedi **P5** |
| **I2** | 🏷️ **La gerarchia del MODELLO DI PREZZO come etichetta obbligatoria accanto a ogni numero** | §2 è la **prima** sezione del documento, prima della strategia: *«prima di qualunque numero va dichiarato come è stato prodotto. Confonderli è l'errore più costoso di tutto il progetto, ed è stato pagato due volte»* | abbiamo la gerarchia delle **FONTI** (piano prop) e la regola per-round (`R86_CRITERI.md:113`: *«ogni numero porta scritto accanto "OHLC, non tick"»*) — ma **`CONTRATTI_SEDIE.md` NON ha una colonna "modello"** | 🔴 **Nella tabella dei contratti oggi convivono senza dirlo**: DD da **OHLC 22 anni** (R99/R100, dichiarati *«limite inferiore»*), DD da **tick reali** (R65 GapContinuation), DD da **walk-forward** (R33-R48), DD da **per-trade 100k** (R16). E abbiamo **già una promozione revocata** proprio per questa confusione (970914). Vedi **P8** |
| **I3** | 🧾 **Tre controlli d'avvio che noi non abbiamo** | §9: **(a)** offset del server dal **Market Watch** confrontato con l'ora locale — *«non fidarsi del Diario»* — atteso +1, **da ricontrollare dopo il cambio di ora legale del 26 ottobre**; **(b)** **clamp lotti** verificato nel Diario al primo armo (*«DAX e NAS sono già vicini al tetto del broker»*); **(c)** **ri-verifica del timbro e dei parametri sul terminale dopo qualche giorno di operatività** | la nostra procedura (`RIGA_DEPLOY_CONTOREALE_DA_MANDARE.md`, 6 passi manuali + 48 casi provati eseguendo) è **molto più forte** su pin/sha/preset/compilazione, e ha già la *legge dello screenshot*, ma **non ha nessuno dei tre** | **(a)** morde ADESSO: **B3** del piano è congelata su `InpDailyResetHour=23` con il **DST dichiarato [INCERTO]** (→ E1), e lui ci ricorda la data: **26 ottobre**. **(b)** morde ADESSO: sul reale a ~7.500 € il lotto calcolato può finire **sotto il minimo del broker** → il rischio effettivo sale sopra lo 0,65% **e nessuno lo vede** (abbiamo già `BUG_BREAKEVEN_lotto_minimo.md` agli atti). **(c)** è la contromisura **diretta** ai nove giorni di sovrataglia ORB. Vedi **P3** e **P4** |
| **I4** | 📐 **Geometria INTERAMENTE adattiva alla volatilità** (SL, TP, **buffer d'ingresso** e **ampiezza minima di range** tutti multipli dell'ATR14 su D1 già chiusa) | `InpUseATR=true`, quattro moltiplicatori ATR. Motivazione §7: *«stop/TP fisso muore al cambio di regime — ATR **+25%** contro fisso **−2,5%**»* | **misto**: ORB SL `OPPRANGE/HALFRANGE` (adattivo al range) e `InpMaxRangePct=0.8` (% del prezzo, adattivo), **ma** `InpEntryPoints=10.0 × K` **fisso**; DAX `InpBufferPoints=500`, `InpMinRangePts`/`InpMaxRangePts` **in punti fissi** | 🟢 **Non è una novità: è una conferma esterna che il cantiere aperto va nella direzione giusta.** `PROPOSTA_RELATIVO_TICK_REALI_2026-09-04.md` (**R117**, `ABTG_Relativo.mq5`) fa esattamente questo, con **σ** al posto dell'ATR: `InpFinestraN=40`, `InpSogliaIngressoSigma=1.35`. 👉 Il pezzo che il documento aggiunge è il **buffer d'ingresso e il filtro di range** resi adattivi — su cui il nostro RELATIVO non si è ancora espresso |
| **I5** | 🔢 **Le soglie numeriche su spread ÷ SL: <20% vive, >50% muore** | §7/§9, usate per **buttare fuori due asset** (US2000 su FTMO al 90%, UK100 al 19% del range) | abbiamo la **metrica** (R55) ma il numero di casa è **10%**, usato in **un solo dossier** e **mai tarato** | Due soglie non tarate che divergono di **2-5×**. 👉 **Ma noi possiamo chiudere il parametro con dati che ABBIAMO GIÀ**: spread ora per ora (03/09) ÷ stop di ogni sedia viva (CONTRATTI_SEDIE). **Zero backtest.** Vedi **P2** |
| **I6** | 🏃 **`ChaseOnInvalid` — se il prezzo ha già rotto, entra a mercato entro 15 punti** | recupera i segnali persi quando il pendente non è stato piazzato o riempito in tempo | **non ce l'abbiamo**, su nessuno dei due EA (verificato: zero occorrenze di *chase* nei due sorgenti) | 🟡 **Registrata, NON proposta.** È il meccanismo che recupera portata — e la portata è esattamente la valuta che **H2/H3** del piano dicono ci manca. **Ma è anche il meccanismo più esposto allo slippage** (entra a mercato nel momento in cui il book è più sottile), e **R55 dice che l'ORB muore proprio di lì**. 🔒 **Non si valuta finché il logger non dice quanto costa un ingresso a mercato sulla rottura** |
| **I7** | 🪦 **«Cosa è stato scartato, CON I NUMERI» come pagina UNICA dentro il documento operativo** | §7: dieci righe, ciascuna col numero che l'ha uccisa. §11: *«il valore di questo progetto non sta solo nella strategia, ma in ciò che ha imparato a rifiutare»* | ce l'abbiamo, **ma sparso**: `REGISTRO_TEST.md`, `CLASSIFICHE.md §Scartati`, `SETACCIO_MANUALE.md`, i dossier di caccia | 🟡 **L'idea non è il contenuto (è già la "lista dei caduti" della REGOLA DELLA SECONDA CACCIA): è la COLLOCAZIONE.** La sua sta in una pagina, **dentro il documento che legge chi accende la sedia**. Costo: una tabella in testa a `CONTRATTI_SEDIE.md`. Resa: bassa ma reale |
| **I8** | 🎲 **Monte Carlo a 10.000 percorsi** | §6: 10.000 | `mc_trailing.py`: **2000 iterazioni**, seed 42 | Su 2.000 percorsi il **p99** poggia su ~20 percorsi: è rumoroso **proprio nel punto in cui decidiamo**. E **A1 è congelata** su un p99 di **8,51% contro un muro di 10** — margine 1,49 punti. **Costo: secondi di CPU.** Vedi **P6** |

---

## 4. ⚔️ IL CONFLITTO — il pavimento dello stop, e perché NON è un errore di nessuno

**È il punto più importante di tutto il dossier, e riguarda la sedia accesa
oggi sul conto reale.**

### 4.1 Le due affermazioni, una accanto all'altra

| | LUI (PS5 §5, §7) | NOI (R55, 15/08) |
|---|---|---|
| **verdetto** | 🚫 **il pavimento dello stop DEVE restare a ZERO** | ✅ **la via coerente è ALLARGARE lo stop** |
| **numero** | pavimento a 20 punti: DAX **PF 2,40 → 1,26** · US2000 **2,97 → 1,05-1,40**. *«Dimezza l'edge»* | l'ORB *«non muore di PF (1,57 anche a 200 punti), **muore di DRAWDOWN**: sfonda il 10% con **1,5 punti indice** di slippage (9,76 → 10,21 → 10,34%)»*. Costo per trade **−44,55 €** = **4,5% di un R**, **undici volte** il PTE |
| **causa dichiarata** | *«lo stop stretto è **portante**: buffer, target, filtro di range e dimensionamento sono proporzionati a lui — allargarlo non protegge, **scardina le proporzioni**»* | *«lotto = R / distanza_stop → **stop stretto = più lotti = ogni punto costa di più**»* (`ORB_100K_CRITERI.md:32,71`) |
| **grandezza misurata** | **PROFIT FACTOR** (l'edge per trade) | **DRAWDOWN a rischio percentuale** (la taglia) |

### 4.2 🥇 La lettura: **non si contraddicono. Misurano due cose diverse.**

**Allargare lo stop fa DUE cose opposte:**

- **peggiora il PF** — meno R per trade, più stop presi per intero → **è
  esattamente il suo numero**;
- **migliora il DD** — meno lotti a parità di rischio % → **è esattamente il
  nostro**.

👉 **Un ORB a stop stretto è ottimo per il profit factor e pessimo per il
muro di una prop.** Le due misure, messe insieme, dicono che **il pavimento
dello stop è un trade-off dichiarato fra edge e sopravvivenza**, non una
verità.

🔎 **E il nostro EA lo sapeva già, con parole quasi identiche alle sue.**
`ABTG_ORB_Ottimizzato.mq5`, righe 189-191, commento all'input
`InpSLBufferPts`:

> *«EFFETTO ATTESO (da verificare col tester, non dichiarato come fatto):
> meno lotti a parità di rischio %, quindi **DD più basso e meno fragilità
> allo slippage; in cambio più stop presi per intero**.»*

**Lui ha MISURATO il secondo termine di quella frase** (il prezzo in PF),
che noi avevamo solo previsto. **Il documento non smentisce R55: gli mette
accanto il prezzo che R55 non aveva misurato. E il prezzo è alto: −47% di PF
sul DAX.**

### 4.3 🎯 La terza via, che nessuno dei due ha misurato — ed è già nel nostro codice

`ABTG_DAX_Apertura_EU.mq5`, righe **1063-1068** e **1087-1092**:

```mql5
if(InpMinStopPts > 0 && dist < InpMinStopPts*_Point)
  {
   if(InpSkipIfTight) { skip=true; ... "BUY saltato: stop troppo stretto per lo slippage" }
   else               { sl = NormalizePrice(entry - InpMinStopPts*_Point); dist = entry - sl; }
  }
```

**Il nostro EA implementa ENTRAMBI i rami del conflitto, scelti da un
booleano** — e ne ha **un terzo che lui non ha considerato**:

| ramo | cosa fa | chi lo sostiene |
|---|---|---|
| `InpMinStopPts = 0` | pavimento spento | **LUI** (§5, «non si tocca») — ed è **la nostra configurazione in campo oggi** |
| `InpMinStopPts > 0` + `InpSkipIfTight = false` | **allarga** lo stop al pavimento | **NOI** (R55 → `ORB_100K_CRITERI` punto D) |
| `InpMinStopPts > 0` + `InpSkipIfTight = **true**` | 🆕 **SALTA il trade** invece di allargarlo | **nessuno dei due l'ha misurato** |

🥇 **Il terzo ramo scioglie proprio la sua obiezione**: non allarga niente,
quindi **non scardina nessuna proporzione** — toglie soltanto i trade in cui
lo stop è così stretto che lo slippage se ne mangia l'edge. **Il costo è la
frequenza**, che è la valuta scarsa di H2/H3.

⚠️ **E una precisazione tecnica che vale, perché smonta metà della sua
obiezione anche sul ramo "allarga":** nel nostro codice il TP è calcolato
**dopo** il pavimento (`double tp = ... entry + dist*TpTotalR()`, riga 1070),
quindi **allargando lo stop il target si allarga in proporzione: l'R resta
l'R**. La sua accusa *«scardina le proporzioni»* colpirebbe da noi **solo il
buffer d'ingresso** (`InpBufferPoints`, fisso), non il target né la size.
**Nella sua implementazione può essere diverso — non lo sappiamo, il codice
non ce l'abbiamo.**

### 4.4 📌 Dove siamo in campo, oggi (fotografia, non giudizio)

| sedia | preset conto reale | posizione nel conflitto |
|---|---|---|
| `ABTG_DAX_Apertura_EU` 770101 | `InpMinStopPts=0.0` · `InpSkipIfTight=true` **(no-op: con pavimento 0 il blocco non si attiva)** · `InpSlippagePts=0.0` | **sul ramo che LUI dichiara intoccabile** |
| `ABTG_ORB_Ottimizzato` 770611 | `InpSLBufferPts=0` · `InpSlippagePts=0` · `InpSLMode=3` (HALFRANGE = **50% del range**, lo stop stretto di R55) | **idem** — ed è **la cella che R55 ha marcato «vive solo a taglia piccola»** |

> 🎯 **Oggi siamo esattamente sulla configurazione che il documento del
> collega dichiara "intoccabile" — ma ci siamo arrivati per un motivo
> diverso dal suo (nessun round ha mai promosso un pavimento), e su una
> sedia che il nostro R55 ha dichiarato la più fragile del portafoglio.**
> Il parametro va **APERTO** nel piano, con entrambe le voci scritte.

---

## 5. 🚫 NON APPLICABILE O GIÀ SUPERATO — sei voci

| # | cosa | perché non si trasferisce |
|---|---|---|
| **N1** | **Il portafoglio Pepperstone** (GER40.cash · US30.cash · US100.cash · US2000.cash; `MaxMult` 0,105-0,145; sessioni 08:55 e 15:25 IT) | Broker e simboli diversi dai nostri. **Lo dice lui stesso** (§9): *«le prime cinque sono la periferia da rifare a ogni broker: valori che dipendono dall'ambiente e non si trasferiscono»*. I `MaxMult` sono strutturali **del suo strumento**. ⏰ E gli orari sono in **ora italiana**: da noi diventerebbero **07:55 e 14:25 server BCM** |
| **N2** | **I moltiplicatori ATR** (`SLMult 0,03208` · `TPMult 0,09625` · `BufMult 0,00802` · `MinMult 0,02727`) | 🔴 **Cinque decimali su una griglia di ottimizzazione**, e **non è dichiarato se vengono dal centro di un altopiano o dal picco**. Il nostro **Emendamento della finestra, punto A** è esplicito: *«centro dell'altopiano, MAI il picco — **la regola di selezione va dichiarata insieme al numero, altrimenti il numero non vuol dire niente**»*. Da copiare: **niente**. 🟢 Da leggere: **i RAPPORTI** — SL:TP = **1:3**, buffer = **25% dello SL**, range minimo = **85% dello SL** |
| **N3** | **`InpDailyCapPct = 100`** — cap giornaliero **disattivato** (*«serviva solo per la prop»*) | Ha senso per lui, che dalla prop è **uscito** (§6: *«perché Pepperstone e non la prop»*). Per noi è l'opposto: **B1 è CONGELATA** il 18/08 (pausa 4,0 / emergenza 4,9) e **B2** (totale 9,9). **Non si importa nulla da questa riga** |
| **N4** | **I rendimenti dichiarati: +186% ideale, +130% «realistico»** | La **prova del buon senso di casa** si applica identica: `ASPETTATIVE_REALISTICHE.md` — *«+223% annuo metterebbe il progetto sopra qualunque fondo al mondo (i migliori: 20-40% annuo). **Se un numero suona così, non è una previsione**»*. 🔴 E c'è la controprova nel documento stesso: **DD max 2,84-6,38% con 0-4 mesi negativi su 37**, mentre **il suo unico forward reale è finito in perdita** (§8). Il modello e il campo non si sono mai incontrati |
| **N5** | **La conclusione «tutte di configurazione, nessuna di strategia» (§8)** | Aritmetica: **−8.597 totali − 6.395 spiegati = −2.202 € NON attribuiti**, il **26%** della settimana. Il documento non li nomina. 👉 Con il nostro **criterio di uscita a tre corsie (C3, 18/08)** quella settimana andrebbe comunque in **revisione**, non archiviata come incidente di processo. **La lezione di processo è ottima; la conclusione «nessuna di strategia» non è dimostrata** |
| **N6** | **La procedura d'avvio in 6 passi, presa in blocco** | Tre dei suoi sei passi noi li facciamo **molto meglio e automatizzati** (pin + sha256 + ASCII + parser sui sorgenti, copertura preset **chiave per chiave**, gate sul rischio compilato, ripristino tutto-o-niente, **48 casi provati eseguendo**). 👉 **Si prendono solo i tre pezzi che ci mancano** — sono in **I3**, non tutto il blocco |

---

## 6. ✍️ PROPOSTE CONCRETE PER CLAUDIO

> 🛑 **Nessuna di queste è stata applicata.** Sono **otto proposte**, ordinate
> per **resa ÷ costo**. Le prime quattro **non toccano niente in campo**.

### 🥇 P1 — Aprire nel PIANO_PROP la riga «pavimento dello stop» (costo: zero, oggi)

Una riga nuova in **AREA A** con **entrambe le voci** e lo stato **APERTO**:

| voce | fonte | rango |
|---|---|---|
| *allargare lo stop* (l'ORB muore di DD, non di PF) | 🥇 `REFERTO_ROUND55_SLIPPAGE.md` · `ORB_100K_CRITERI.md` punto D | **nostra misura** |
| *mai allargare* (dimezza il PF: DAX 2,40 → 1,26) | 4° PS5 §5/§7 | dichiarazione singola |
| *saltare invece di allargare* (`InpSkipIfTight`) | ⬜ **mai misurato da nessuno** | — |

**Perché adesso**: le due sedie sul conto reale girano da oggi **sul ramo
"pavimento 0"**, e finora nel piano quel valore non era nemmeno una riga.
**Non cambia un parametro: scrive che è una scelta, e non un default.**

### 🥈 P2 — Il rapporto **spread ÷ stop** di ogni sedia viva, su carta, con dati che abbiamo già (costo: ~30 minuti, zero backtest)

Numeratore: `SPREAD_FLOTTA_MISURA_2026-09-03.md`, **ora per ora**.
Denominatore: lo stop di ogni sedia da `CONTRATTI_SEDIE.md` / dai preset.

**Serve a decidere quale soglia adottare — la nostra 10% o la sua 20/50 —
con un numero invece che con una preferenza.** E ha già un bersaglio noto:
`ABTG_MaxMinNotte` D30EUR **lavora di notte**, dove lo spread è **3,5-3,9**
contro 1,6-1,7 in sessione, e dove il P95 dello slippage è **92,68** contro
**3,25** (`MISURA_SLIPPAGE_2026-09-05.md`). **Quella sedia va misurata con
questo rapporto prima di qualunque altra cosa.**

### 🥉 P3 — Due controlli in più ai PASSI MANUALI del conto reale (costo: due screenshot)

1. 🕐 **Offset del server letto dal MARKET WATCH** (non dal Diario, non dal
   Giornale), con screenshot che contenga **anche l'orologio di Windows**.
   👉 È **la stessa prova** che il 18/08 ha deciso B3 (*«Market Watch
   19:35:27 con Windows 20:35 nello stesso screenshot»*), ma **all'avvio di
   ogni sedia**, non una volta sola. 📅 **E lui ci porta la data che ci
   serve: ri-verifica dopo il cambio di ora legale del 26 ottobre** — che è
   esattamente il caveat **[INCERTO]** rimasto aperto su B3 e su E1.
2. 📦 **Clamp lotti al primo armo**: il volume dell'ordine confrontato col
   **minimo e col massimo del broker**. Su ~7.500 € allo 0,65% il lotto
   calcolato può finire **sotto il minimo**, e allora **il rischio vero è
   sopra lo 0,65% e nessuno lo vede** (precedente agli atti:
   `BUG_BREAKEVEN_lotto_minimo.md`).

### 🏅 P4 — **La ri-verifica a T+3 giorni** (costo: una riga in `HANDOFF.md` + uno screenshot)

Tre giorni dopo ogni deploy, **due sole foto**:

- la riga `[DAX Apertura EU] CONFIG IN USO -> ... rischio=0.65% | ...` nella
  scheda **Esperti**;
- il **volume dell'ultimo ordine** confrontato col contratto della sedia.

> 🎯 **È la proposta con la resa più alta di tutto il dossier.** La
> sovrataglia ORB del 100k (**3,3×**) è vissuta **NOVE GIORNI** perché
> nessuno riguardava dopo l'avvio. Lui ha pagato **6.395 €** per la stessa
> classe di errore. Questo controllo l'avrebbe presa **in tre giorni invece
> che in nove**, e costa **due screenshot**.

### 5️⃣ P5 — Un round sulla parziale, sui due EA vivi (costo: un round, zero codice)

Griglia a due assi, su input **che esistono già**:

| EA | assi | oggi | tesi esterna |
|---|---|---|---|
| `ABTG_DAX_Apertura_EU` | `InpTP1_ClosePct` × `InpTP1_R` | **50% / 1,0R** | 80% / 1,5R |
| `ABTG_ORB_Ottimizzato` | `InpTP1Pct` × `InpTP_R` | **0% / 1,0R** (nessuna parziale) | 80% / 1,5R |

⚠️ **Criteri congelati PRIMA dei numeri** (regola di casa) e **centro
dell'altopiano, mai il picco** (Emendamento A). ⚠️ **Cambiare la parziale su
una cella promossa È cambiare la cella**: se passa, va riscritto il
contratto in `CONTRATTI_SEDIE.md`. ⚠️ E il modello di prezzo va dichiarato:
su questa griglia il coarse mentirebbe (C2).

### 6️⃣ P6 — Rifare M1 a **10.000** iterazioni invece di 2.000 (costo: secondi di CPU)

`mc_trailing.py`, stesso seed dichiarato. **A1 (rischio 0,65%) è CONGELATA
su un p99 di 8,51% contro un muro di 10**: margine **1,49 punti**, misurato
su 2.000 percorsi. Vale la pena sapere **quanto è stabile quel numero**
prima che ci si appoggi una challenge.

### 7️⃣ P7 — Quando il logger avrà i primi stop reali: **lo slippage come % dello STOP**, sedia per sedia (costo: zero, è una divisione)

`backtest_pipeline/misura_slippage.py` produce già mediana/P95/max **per
simbolo e per ora**. Manca **la divisione per lo stop della sedia**.

👉 È la metrica con cui lui ragiona (**27% su US30, 13% su NAS**), ed è
**l'unico modo di rendere i due corpus confrontabili**. È anche il numero
che **tara l'haircut** (C5) — cioè il loop aperto n.1 suo e nostro, nello
stesso giorno.

### 8️⃣ P8 — Una colonna «MODELLO DI PREZZO» in `CONTRATTI_SEDIE.md` (costo: ~1 ora)

`tick reali` / `M1 OHLC` / `walk-forward` / `per-trade 100k`, accanto a ogni
DD promesso. Oggi la tabella li mescola **senza dirlo**, e abbiamo **già
pagato** questa confusione con una promozione revocata (970914, PF 2,77 →
0,79). **È la §2 del suo documento, applicata alla nostra tabella madre.**

### 🚫 Cosa NON propongo, e perché

| non proposto | motivo |
|---|---|
| copiare i moltiplicatori ATR | N2 — non è dichiarata la regola di selezione della cella |
| adottare il `ChaseOnInvalid` | I6 — è il meccanismo **più** esposto allo slippage, e R55 dice che l'ORB muore lì. **Si riapre dopo il logger** |
| spegnere il cap giornaliero | N3 — B1/B2 sono **congelate** |
| usare i suoi PF come riferimento di merito | §1-bis punto 3 — il PF migliore del suo portafoglio **non ha verdetto tick** |
| toccare **qualunque cosa** in forward | regola di casa. **Questo dossier non applica niente** |

---

## 7. 🗂️ RIFERIMENTI INCROCIATI — dove sta ogni numero citato

**Il piano e i contratti**
- `report/PIANO_PROP.md` — righe **A1** (0,65% congelato, p99 8,51%), **A2**
  (sovrataglia ORB 3,3×, nove giorni), **A4/A5** (trappola del 2%,
  `ABTG_DEF_RISK`), **B1/B2** (cap 4,0/4,9 e 9,9), **B3** (reset 23, DST
  [INCERTO]), **C3** (criterio di uscita), **H2/H3** (fabbisogno di portata),
  **H12** (spread misurato ora per ora)
- `report/CONTRATTI_SEDIE.md` — DAX 770101 **10,60%** (R83) · ORB 770611
  **9,92%** (R15, *doppio asterisco*) · SupRev_DOW_H4 970914 (**revocata,
  illusione OHLC**)
- `report/FIRME_2026-08-18.md` — le tre firme (Guardian, uscita sedie, cap)
- `CLAUDE.md` — Emendamento della finestra (A: centro dell'altopiano · C:
  prova di regime), criterio di uscita, regola della seconda caccia, regola
  dei due lati, **fuso BCM = IT − 1**

**Le misure che reggono il confronto**
- `backtest_pipeline/risultati_archivio/REFERTO_ROUND55_SLIPPAGE.md` — l'ORB
  «non muore di PF, muore di DD»: **1,5 punti indice sfondano il 10%**
- `report/MISURA_SLIPPAGE_2026-09-05.md` — 921 uscite; in sessione mediana
  **0,40** / P95 **3,25**; fuori sessione P95 **92,68**, max **294,40**
- `backtest_pipeline/risultati_archivio/SPREAD_FLOTTA_MISURA_2026-09-03.md` —
  **252 M tick**, spread ora per ora
- `backtest_pipeline/risultati_archivio/REFERTO_M1_MC_TRAILING.md` — MC a
  giorni interi, 2000 iterazioni, seed 42
- `report/ASPETTATIVE_REALISTICHE.md` — l'haircut «diviso tre» e la prova del
  buon senso sui rendimenti
- `report/ORB_100K_CRITERI.md` — punto **D**: *«la via coerente con R55 non è
  abbassare il peso: è allargare lo stop»*
- `report/ORB_GEMELLI_DIVERGENZA_2026-08-22.md` — le coppie appaiate
- `report/VERBALE_CHIUSURA_770101_2026-09-02.md` §C4 — la trappola del 2%

**Il codice e i preset toccati dal confronto (letti, NON modificati)**
- `mql5/Experts/ABTG_ORB_Ottimizzato.mq5` — righe **160-192**
  (`InpSLBufferPts` e il suo commento), **231-248** (`InpSlippagePts`),
  **1021-1039** (OCO), **344-346** (il pendente opposto)
- `mql5/Experts/ABTG_DAX_Apertura_EU.mq5` — righe **343-346** (`InpMinStopPts`
  / `InpSkipIfTight`), **1063-1070** e **1087-1094** (i due rami)
- `mql5/Experts/ABTG_SlippageLogger.mq5` — righe **1-60** (perché sul reale:
  *«BCM ha confermato che il conto DEMO NON simula lo slippage»*)
- `mql5/Presets/conto_reale/ABTG_DAX_Apertura_EU_770101_REALE.set` (82 chiavi)
- `mql5/Presets/conto_reale/ABTG_ORB_Ottimizzato_770611_REALE.set` (54 chiavi)
- `backtest_pipeline/righe/RIGA_DEPLOY_CONTOREALE_DA_MANDARE.md` — i 6 passi
  manuali e la sezione *«quello che questo deploy NON protegge»*
- `report/PROPOSTA_RELATIVO_TICK_REALI_2026-09-04.md` — **R117 RELATIVO**, la
  geometria in σ

---

## 8. 🕳️ COSA QUESTO DOSSIER **NON** DICE

1. 🔴 **Non ho verificato nessuno dei suoi numeri.** Non c'è un file, un
   `.htm`, un CSV. **Tutto quanto è attribuito a lui va letto con
   «[DICHIARATO]» davanti**, e in questo dossier lo è.
2. 🔴 **Non ho girato un solo backtest.** Le otto proposte sono **proposte**:
   nessuna è stata misurata qui dentro.
3. ⚠️ **Il conflitto del §4 resta APERTO anche dopo questa analisi.** La
   lettura «misurano due grandezze diverse» è **un'inferenza mia, coerente
   coi due corpus, non una misura**. La chiude un round, non un dossier.
4. ⚠️ **Non ho esaminato il PDF originale**, solo il markdown consegnato: se
   il PDF contiene grafici o tabelle in più, questo confronto ne è cieco.
5. ⚠️ **Le sue frequenze di inversione all'apertura** (35/57/68%) sono
   citate in C11 come *motivazione*, non come dato nostro: **sul DAX e sul
   Dow non le abbiamo mai misurate**, e sarebbero misurabili.

---

*Dossier di sola analisi. Nessun EA modificato, nessun preset toccato,
nessun parametro di forward cambiato, nessun conto sfiorato. Nessuna riga di
lancio prodotta. Le proposte sono otto, tutte dichiarate e nessuna
applicata: decide Claudio.*
