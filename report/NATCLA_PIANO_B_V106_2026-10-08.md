# NATCLA - PIANO B: EA_NatCla v1.06 (preparato l'08/10/2026, NON applicato)

**Stato:** PREPARATO E NON APPLICATO. Nessun file pinnato toccato (`EA_NatCla.mq5`, driver, lettore, righe, file prova restano come al pin `d6586360`). Nessun pin nuovo, nessuna riga, niente inviato a Claudio. Qui ci sono la patch esatta, il modello che la giustifica e l'elenco delle modifiche per applicarla in circa un'ora **se e solo se** scatta il grilletto del par. 0.
**Strati:** strato 1 parziale (modello del tester pigro esteso + collaudo esistente fatto girare sulla v1.06 in scratch, par. 3-4). Lo strato 2 (cancello) si fa al momento dell'uso, sulla v1.06 vera e sul suo pin.
**Limite dichiarato:** nessun MetaEditor e nessun tester qui. Il modello in C++ **non e' MT5**: spiega i numeri misurati dalla diagnosi, non li sostituisce. La prova e' il lotto C0 rifatto con la v1.06.

---

## 0. Quando si usa (il grilletto, scritto PRIMA del risultato di C0)

Il piano B si usa in DUE casi, non in uno solo:

1. **C0 NON SUPERATA per lo stallo**: su almeno una delle 4 passate niente riga VERIFICA ADX e/o zero righe CONTA, con compilazione, AVVIO e finestra in regola. E' l'ipotesi alternativa gia' scritta nella riga C0 (modello 3: il tester ricalcola solo per copie di piu' elementi).
2. **C0 "SUPERATA" ma in ritardo.** Il driver dichiara SUPERATA se ci sono VERIFICA ADX e CONTA > 0. La data della VERIFICA ADX su H1 pero' non blocca ("molto dopo = da capire, non blocca"). Il modello esteso (par. 3, modello 4: ricalcolo **parziale** fino a start+count) prevede questa firma per la v1.05: **VERIFICA ADX alla barra H1 n. 1699 invece che alla 302, cioe' verso il 2025-01-14 invece che il 2024-10-16** (circa 1400 barre H1, 3 mesi di borsa persi). Su H4 il ritardo sarebbe molto piu' grande, e su H12 e D1 lo stallo resterebbe totale (n non arriva mai al tetto di 1500 barre). **Se la VERIFICA ADX di C0 su H1 cade dopo il 2024-10-17 la v1.05 NON e' guarita davvero: si applica la v1.06 anche con C0 "SUPERATA".**

**NON si usa** se C0 cade per un altro motivo (compilazione, AVVIO, VERIFICA ADX "Wilder"/"NESSUNA", finestra non letta, CSV assente). Quelli non sono lo stallo: vanno letti nel MANIFEST.

---

## 1. Il codice esatto

### 1a. Patch v1.05 -> v1.06 (applicabile con `git apply`)
Verificata: `git apply --check` passa contro `mql5/Experts/EA_NatCla.mq5` a HEAD (identico al pin `d6586360`, sha256 `7d89a3df...c9ac`). Il risultato ha sha256 `f9c35285...37ae` e 2258 righe. Controllo fatto in scratch: v1.06 senza commenti, senza le righe del tocco e con la versione riportata a 1.05 e' **identica** alla v1.05 nelle stesse condizioni. Il contro-esempio regge: con `NC_BARRE_MIN` cambiato il confronto cade.

```diff
--- a/mql5/Experts/EA_NatCla.mq5
+++ b/mql5/Experts/EA_NatCla.mq5
@@ -51,6 +51,13 @@
 //|  Nessun'altra modifica. Dal vivo, e nel tester con storia        |
 //|  davanti, nessun cambiamento atteso (il tocco non cambia valori  |
 //|  ne' stato). NON compilato qui: la verifica e' il lotto C0.      |
+//|  v1.06 (PIANO B, solo se il lotto C0 della v1.05 NON e' superato:|
+//|  report/NATCLA_PIANO_B_V106_2026-10-08.md): il tocco chiede lo   |
+//|  STESSO blocco della catena (n = min(Bars-2, NC_BARRE) elementi  |
+//|  dalla barra 1), non 1 elemento: e' la richiesta che la diagnosi |
+//|  ha visto guarire. Con meno di NC_BARRE_MIN barre si tocca con   |
+//|  quelle che ci sono (almeno 1), PRIMA dell'uscita. Nessun'altra  |
+//|  modifica. NON compilato qui: la verifica e' il lotto C0 rifatto.|
 //|                                                                  |
 //|  MAPPA REGOLA -> CODICE (sigle della specifica, par. 1)          |
 //|   I1-I3 Supertrend HL2 +/- k x ATR10 ......... NC_STCore (puro)  |
@@ -91,10 +98,10 @@
 //+------------------------------------------------------------------+
 #property copyright "Ea Nat&Cla - progetto Claudio (ABTG)"
 #property description "Ea Nat&Cla: modo AUDIO (collega) / motore solo EMA200 (audio WA0092). Modo PDF ESCLUSO da Claudio il 07/10/2026. Specifica report/NATCLA_SPECIFICA_2026-10-07.md. Rischio 0,25% = SEGNAPOSTO da firmare da Claudio."
-#property version   "1.05"
+#property version   "1.06"
 #property strict
 
-#define NC_VER "1.05"
+#define NC_VER "1.06"
 
 #include <Trade/Trade.mqh>
 #include <ABTG_PausaGuardian.mqh>
@@ -1275,14 +1282,20 @@
    //    di ogni BarsCalculated. Nel tester un indicatore si calcola SOLO quando si chiede un suo buffer: se
    //    alla creazione non c'era storia (indici BCM dal 26/09/2024, < 200 barre) BarsCalculated resta -1 e
    //    senza una richiesta il controllo qui sotto non lascerebbe MAI arrivare ai CopyBuffer (stallo).
+   //--- v1.06 [PIANO B, report/NATCLA_PIANO_B_V106_2026-10-08.md]: il tocco chiede lo STESSO blocco della
+   //    catena (nTocco = n elementi dalla barra 1), non 1 elemento: la diagnosi ha visto guarire le passate
+   //    (a)/(c) con copie di n elementi, MAI con copie di 1 (che il lotto C0 della v1.05 ha smentito).
+   //    Con n < NC_BARRE_MIN si tocca con le barre che ci sono (almeno 1) e SOLO DOPO si esce: cosi'
+   //    l'indicatore e' gia' calcolato quando n arriva a NC_BARRE_MIN, come in (a)/(c) alla barra 302.
    //    Esito IGNORATO apposta: alla prima chiamata un 4806 (dati non pronti) e' atteso; decidono i controlli
    //    di sempre qui sotto. Il tocco non scrive nessuno stato dell'EA (array locale, mai letto).
-   double tocco[1];
-   CopyBuffer(hEma200,0,1,1,tocco);
-   CopyBuffer(hAtrN,0,1,1,tocco);
-   CopyBuffer(hAdx,0,1,1,tocco);
    int barre=Bars(_Symbol,gTF);
    int n=(barre-2<NC_BARRE) ? barre-2 : NC_BARRE;
+   int nTocco=(n>1) ? n : 1;
+   double tocco[];
+   CopyBuffer(hEma200,0,1,nTocco,tocco);
+   CopyBuffer(hAtrN,0,1,nTocco,tocco);
+   CopyBuffer(hAdx,0,1,nTocco,tocco);
    if(n<NC_BARRE_MIN) return false;
    if(BarsCalculated(hEma200)<n+1 || BarsCalculated(hAtrN)<n+1 || BarsCalculated(hAdx)<n+1) return false;
    MqlRates r[];
```

Da `MqlRates r[];` in giu' `CaricaDati` resta **identica** alla v1.05 (CopyRates n, i tre CopyBuffer n della catena, `gN=n`).

### 1b. Variante v1.06b (+2 righe): copia INTERA della sequenza della passata (a)
La passata (a) della diagnosi, a ogni barra in cui la catena cadeva, faceva in `NCD_Completa` **CopyRates di n barre E** i tre CopyBuffer di n elementi, in quest'ordine (EA_NatCla_Diag r.209-219). La diagnosi quindi **non separa** le due chiamate: (a) e (e) differiscono per tutte e due. La v1.06b le copia entrambe. Sopra la v1.06, al posto di `double tocco[];`:

```mql5
   MqlRates toccoR[];
   CopyRates(_Symbol,gTF,1,nTocco,toccoR);
   double tocco[];
```
(e una riga di commento: "v1.06b: anche la CopyRates di n barre, come NCD_Completa della passata (a)"). Il risultato e' di 2260 righe, sha256 `4ed4f7c6...4cb2`.

**Raccomandazione dello Sviluppatore: v1.06b.** Il piano B si usa solo dopo che la nostra prima teoria (1 elemento basta) e' stata smentita da C0. A quel punto il secondo tentativo dovrebbe essere la **ricetta misurata** di (a) per intero, non una seconda teoria. Nel modello costa zero: v1.06b e v1.06 sono identiche barra per barra in 6 modelli su 7 (par. 3). Copre in piu' il modello 5 (sblocca la serie, non il buffer), che la v1.06 non copre.
**Contro la v1.06b:** l'EA chiama gia' `iTime(_Symbol,gTF,0)` a ogni tick (r.1257), quindi la serie e' gia' consultata e il modello 5 e' improbabile. Pero' anche `iTime` e' un accesso di 1 elemento, e "1 elemento non basta" e' proprio l'ipotesi di C0: quindi improbabile, non escluso.
Il collaudo esistente, al raccordo (7) r.497-503, rifiuta una CopyRates in `CaricaDati` diversa da (1, n). Va esentata per nome dell'array (`toccoR`), come si fa gia' per `tocco`.
**La scelta fra v1.06 e v1.06b la fa il chiamante/cancello.** Tutto quello che segue vale per entrambe, salvo dove indicato.

---

## 2. Il ragionamento

- **Perche' n e non 1.** Quello che e' MISURATO e' che le passate (a) e (c), con richieste di n elementi (115...299 nelle barre con n < 300), sono guarite alla barra 302 con `BarsCalculated` = 301/301/301 (log (a) r.4). La v1.05 copre questo fatto con una nostra IPOTESI, cioe' che basti una richiesta qualunque. Se C0 la smentisce, la cosa piu' vicina al fatto misurato e' chiedere esattamente quello che chiedeva (a): **lo stesso blocco della catena**, n = min(Bars-2, NC_BARRE) elementi dalla barra 1. Serve quindi `BarsCalculated >= n+1`, cioe' la stessa soglia del controllo successivo.
- **Perche' il tocco sta PRIMA dell'uscita `n < NC_BARRE_MIN`.** In (a) i tocchi sono avvenuti alle barre 117..301, quando n < 300. E' per questo che alla barra 302 l'EMA200 era gia' calcolata. Un tocco messo dopo l'uscita parte solo alla barra 302: nel modello sincrono non cambia niente, nel modello differito costa una barra (303 invece di 302). Lo dimostra il mutante M_A del par. 3. Sotto le 300 barre si tocca con le barre che ci sono: `nTocco = n` se n > 1, altrimenti 1 (con 2 barre o meno la copia fallisce, esito ignorato, nessun effetto).
- **Esito ignorato, array locale.** Alla prima chiamata un 4806 e' atteso. Decidono i controlli di sempre, intatti. `tocco[]` e' dinamico, locale e mai letto: nessuno stato dell'EA cambia. `gEma/gAtrN/gAdx` li scrive solo la catena, come prima.
- **Carico nel tester.** Il modello, sulla passata U30USD (9946 barre), conta per handle 13,9 milioni di elementi copiati con la v1.05 e 27,9 milioni con la v1.06: **x2,00** (tocco n + catena n). Le richieste sono le stesse (19707 per handle). In byte sono circa 670 MB di copie in memoria su tutta la passata, per i tre handle. [STIMA, non misurata] Meno di un secondo su una passata misurata a 28-30 s. Il lotto C0 rifatto misura il tempo vero: il driver stampa la media in secondi per passata. Se la media sale di piu' del 20% rispetto a C0 v1.05, va letto prima di lanciare il lotto C.
- **Dal vivo.** Una chiamata `CaricaDati` per nuova barra del TF, quindi 3 copie da 1500 double (36 KB) in piu' all'ora su H1. Il comportamento non cambia: nel modello 2 (zelante = dal vivo) la v1.04, la v1.05 e la v1.06 sono **identiche barra per barra**. Con storia davanti, cioe' forex, oro e (b), la v1.06 e' identica alla v1.04 in tutti e 7 i modelli.
- **Cosa NON copre (residui dichiarati).**
  - `Buf1` (r.1315-1322) fa ancora `BarsCalculated<2` prima di un CopyBuffer di 1 elemento su hEma14/hEma89/hEma9/hEma21/hBands. In AUDIO servono SOLO alle colonne di log `ema9;ema21;bb_larg` del CSV. Il TP EMA14/EMA89 e' solo PDF, escluso da Risolvi dalla v1.04. In un tester "modello 3" quelle colonne potrebbero restare ferme sugli indici. **Controllo gratis sul CSV di C0: le tre colonne devono variare riga per riga.** Se sono ferme, e' un difetto di solo log e non si corregge nella stessa versione (una modifica alla volta).
  - Il compilatore MQL5 puo' avvisare "return value of 'CopyBuffer' should be checked". La v1.05 ha gia' tre chiamate ignorate, quindi il numero di avvisi di C0 v1.05 e' il riferimento: la v1.06 deve averne lo stesso numero (la v1.06b al massimo uno in piu').

---

## 3. Il modello esteso del tester pigro (scratch, NON committato)

Script in scratch (`modello_esteso.py` + `costruisci_v106.py`, fuori dal repo). Prende **CaricaDati VERA** estratta dai tre sorgenti: v1.05 al pin, v1.06 e v1.06b costruite dalla patch. La v1.04 si ottiene togliendo il tocco, con la stessa funzione `tocchi_via` del collaudo. La compila in C++ contro **7 modelli** e usa i numeri della diagnosi scritti nel collaudo (`DIAG_U30/D30/U30_STORIA`). Le attese erano scritte prima di girare. Una era sbagliata ed e' stata **corretta a tavolino prima del giro**: nel modello 4 la v1.05 non e' "bloccata" ma "ritardata alla barra 1699", calcolo nel commento dello script. **Esito: 32 attese su 32, 0 cadute (rc 0).**

| modello | come calcola il tester | v1.05 U30 (barre ok / prima) | v1.06 | v1.06b |
|---|---|---|---|---|
| 0 | pigro sincrono (riproduce la diagnosi) | 9761 / 302 | 9761 / 302 | 9761 / 302 |
| 1 | pigro differito (servito all'evento dopo) | 9761 / 302 | 9761 / 302 | 9761 / 302 |
| 2 | zelante (= dal vivo) | 9761 / 302 | 9761 / 302 | 9761 / 302 |
| 3 | solo richieste di PIU' di 1 elemento | **0 / mai** | **9761 / 302** | 9761 / 302 |
| 4 | ricalcolo PARZIALE fino a start+count (+1 a barra) | **8364 / 1699** | **9761 / 302** | 9761 / 302 |
| 5 | CONTRO-ESEMPIO: sblocca solo una CopyRates > 1 | 0 / mai | **0 / mai** | **9761 / 302** |
| 6 | solo richieste di almeno un periodo (count >= 200) | **0 / mai** | **9761 / 302** | 9761 / 302 |

Su D30EUR i numeri sono gli stessi in proporzione: 9453 dalla 302 dove sblocca, v1.05 0 nei modelli 3 e 6 e 8056 dalla 1699 nel modello 4. Misurato (c): 9453 dalla 302.

Le attese verificate:
- **Riproduzione:** nel modello 0 la v1.04 resta bloccata (= (e)/(f)). La v1.05, la v1.06 e la v1.06b danno 9761 dalla 302 su U30 e 9453 dalla 302 su D30 (= (a)/(c) misurati).
- **Il caso del piano B:** nei modelli 3, 4 e 6 la v1.05 e' bloccata (o ritardata a 1699) e la **v1.06 sblocca come (a)/(c)**, barra per barra identica alla v1.06 del modello 0.
- **Il modello distingue n da 1:** il mutante M_B (`nTocco=1`, cioe' la v1.05 riscritta) resta bloccato nei modelli 3 e 6 e ritardato a 1699 nel 4.
- **Il tocco prima dell'uscita serve:** il mutante M_A (tocco DOPO `if(n<NC_BARRE_MIN)`) parte alla barra 303 invece che alla 302 nel modello differito. Nel sincrono non si distingue: e' dichiarato, lo vede solo il differito.
- **Nessun effetto dove non serve:** con storia davanti, cioe' (b) a 8600 dalla 1463, la v1.06 e' identica alla v1.04 in tutti e 7 i modelli. Nel modello 2 (dal vivo) v1.04 = v1.05 = v1.06.
- **Il limite della v1.06, costruito apposta (modello 5):** se a sbloccare fosse la serie e non il buffer, v1.05 e v1.06 restano entrambe bloccate e solo la v1.06b sblocca. E' l'argomento del par. 1b.

**Cosa il modello NON dice:** quale dei 7 sia il tester vero. Lo dice solo il lotto C0, quello della v1.05 e poi quello della v1.06. Se ANCHE la v1.06(b) resta a zero, il meccanismo non e' nessuno dei 7 e si passa al par. 5 (FromDate), che e' l'unica via MISURATA dalla passata (b).

---

## 4. Cosa cambiare per applicarla in un'ora (elenco per file; NIENTE di questo e' stato fatto)

### 4.0 Prima di tutto: il collaudo e' ROSSO GIA' A HEAD (difetto preesistente, non della v1.06)
`python3 backtest_pipeline/collaudo_natcla.py --senza-mutanti` a HEAD (`d78aebde`) esce **"1 CONTROLLI FALLITI"**: "blocco magic 7786xx libero". Il controllo trova `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md:37772`, cioe' la riga aggiunta dal commit del cancello `d78aebde`. Quella riga **cita** un magic del blocco proprio mentre descrive questo stesso falso positivo. Al pin `d6586360` la CHECKLIST non conteneva nessun 7786xx e il collaudo era verde. Ci sono due rimedi, e la scelta spetta al chiamante:
- (a) riscrivere quella riga della CHECKLIST senza il numero intero (per esempio `77861x` non corrisponde a `\b7786[0-9]{2}\b`);
- (b) escludere la CHECKLIST per nome in `magic_libero()`. Sconsigliato: la CHECKLIST e' un file vivo e un'esclusione per file intero e' larga.

Da fare comunque **prima** di qualunque collaudo della v1.06, altrimenti il rosso preesistente copre quelli nuovi.

### 4.1 EA (5 minuti)
`git apply` della patch del par. 1a (piu' le 2 righe e il commento della v1.06b, se scelta) su `mql5/Experts/EA_NatCla.mq5`. **Stesso nome di file**: driver (`$EXPERT='EA_NatCla'`) e bootstrap (`FEA`) lo cercano li'. I pin vecchi restano validi perche' le righe scaricano per commit.

### 4.2 `backtest_pipeline/collaudo_natcla.py` (20-25 minuti). MISURATO cosa cade
Il collaudo esistente, fatto girare in scratch sulla v1.06 (`--senza-mutanti`), cade in esattamente **3 punti nuovi** piu' il 4.0:
1. **Invariante (31)**, r.668-689. Cade: "tocco non e' uno per handle (trovati [])", "array non e' `double tocco[1]`", "NC_VER non e' 1.05". Va riscritto per la v1.06:
   - regex del tocco `CopyBuffer\(\s*(\w+)\s*,\s*0\s*,\s*1\s*,\s*nTocco\s*,\s*tocco\s*\)`, uno per handle su hEma200/hAtrN/hAdx;
   - `int nTocco=(n>1) ? n : 1;` presente alla lettera e **dopo** `int n=`;
   - tocchi **prima** di `if(n<NC_BARRE_MIN)` e di ogni `BarsCalculated`, esito ignorato (stessa verifica di oggi);
   - `double tocco[];` usato SOLO dai tre tocchi;
   - versione `1.06`.

   Per la v1.06b servono in piu': `MqlRates toccoR[]; CopyRates(_Symbol,gTF,1,nTocco,toccoR);` prima dei tocchi, e l'esenzione `toccoR` nel raccordo (7) r.500.
2. **`solo_il_tocco`**, r.1472-1496. Oggi confronta con la v1.04 di `290e1b74`. Va fatto puntare alla **v1.05 del pin `d6586360`** (`V105_COMMIT`): dalla v1.05 si tolgono `double tocco[1]` e i 3 tocchi da 1 elemento, dalla v1.06 `int nTocco`, `double tocco[]` e i 3 tocchi da nTocco, poi si confrontano senza commenti e con la versione riportata. In scratch questo confronto e' **vero**, e cade col contro-esempio. Il testo del check r.1657 va aggiornato.
3. **Modello del tester** (`ModelloTester`, r.948). La v1.06 **non compila** nel modello ("storage size of 'tocco' isn't known") perche' manca la conversione `double x[];` -> `std::vector<double>`. Va aggiunta la regex, come gia' si fa per `MqlRates r[]`. Poi:
   - `tocchi_via` (r.934-937) va generalizzata (count `\w+`, `double tocco[...]` con o senza dimensione, riga `int nTocco`);
   - `tester_pigro` (r.965-1010) cambia cosi': nel **modello 3 l'attesa si capovolge** (v1.06 = 9761 dalla 302; la v1.05 di confronto si prende al pin `d6586360` ed e' quella che resta a 0); si aggiungono i modelli 4, 5 e 6 del par. 3 (`richiesta()` con `calcola_fino`, `SERIE_OK` sulla CopyRates, soglia `count >= PER`); il CARICO si aggiorna a x2.
4. **Mutanti** (r.1608-1615 e costanti `TOCCO`/`DOPO_TOCCO`, r.1472-1474). T1-T7 vanno riscritti con le righe `nTocco`. Si aggiungono: **T8** `nTocco=1` (preso dal modello 3); **T9** tocco dopo l'uscita `n<NC_BARRE_MIN` (preso dall'invariante 31 e dal modello 1); **T10** tocco su `gEma` invece che sull'array locale (preso dall'invariante "array usato solo dai tocchi"); **T11** versione rimasta 1.05. Con la v1.06b anche **T12**, CopyRates del tocco tolta (preso dal modello 5).
5. Intestazione del docstring, r.39-45: v1.06 e piano B.

### 4.3 Driver `backtest_pipeline/righe/NATCLA_F0_PASSATE.ps1` (10 minuti, ASCII puro)
- r.125 `$VERSIONE_ATTESA = '1.05'` -> `'1.06'`. **E' l'unica riga che cambia il comportamento.** Il bootstrap verifica da solo che coincida con `NC_VER` al pin (bootstrap.py r.49-50).
- r.631, r.672, r.689, r.690: oggi il testo dice "v1.05" alla lettera. Va sostituito con `'v' + $VERSIONE_ATTESA`, cosi' al prossimo salto cambia una riga sola. Il testo di r.672 deve dire che la v1.05 (tocco a 1 elemento) e' stata smentita da C0 del <data>.
- Commenti r.40-42, r.47, r.80-81, r.357: da 1.05 a 1.06 (n elementi), con una deviazione 16 che rimanda a questo referto.
- La cartella e lo zip `NATCLA_F0_C0` del giro v1.05 sul Desktop NON vanno persi: il driver li **rinomina** con la data (r.393-394), non li cancella. Va comunque detto nella riga che lo zip v1.05 va mandato PRIMA di lanciare quello v1.06.

### 4.4 Lettore `backtest_pipeline/leggi_natcla_f0.py` (10 minuti). MISURATO cosa cade
- r.29 `VERSIONE_EA = "1.06"`; r.33 `VERSIONI_ARCHIVIO = ("1.04", "1.05")`.
- La regola r.132-135 ("versione d'archivio su un INDICE = motivo") copre gia' la v1.05 sugli indici, che e' lo stallo se C0 e' caduto, appena la 1.05 entra nell'archivio. Serve un autotest che lo dica: "AVVIO v1.05 su U30USD = motivo, v1.06 nessun motivo".
- Con SOLO le due costanti cambiate (copia in scratch), `--autotest` passa da 101/0 a **101/3 falliti**:
  - r.817 (`VERSIONE_EA == "1.05"`);
  - r.818-819 ("v1.06 rifiutata": diventa "v1.07 rifiutata");
  - r.995-997 (stringa "v1.04 e v1.05" del DETERMINISMO).

  Da riscrivere tutti e tre, insieme alla stringa fissa di r.498 ("misura anche che la v1.05 non cambia..." -> versione dalla variabile) e ai testi r.778, r.821-824, r.1024.
- Il DETERMINISMO XAUUSD fra PILOTA (v1.04) e lotto C (v1.06) resta valido: tolta la riga `#AVVIO`, i CSV devono essere IDENTICI (modelli 0 e 2: con storia davanti la v1.06 e' identica alla v1.04).

### 4.5 `backtest_pipeline/collaudo_natcla_f0/` (10 minuti)
- `sim_mt5.py` r.110: `"1.05"` -> `"1.06"`.
- `battery.py` r.130 (S14): il mutante serve un EA con `NC_VER "1.06"` -> `"1.05"`, cioe' il sorgente di PRIMA del piano B, e deve fermarsi. Rileggere S33/S35 (r.213-231): l'attesa C0 e' la stessa.
- `mutazioni_script.py` r.198 (D38): `'1.06'` -> `'1.05'`. `mutazioni_reader.py` r.74 (M54): `VERSIONE_EA = "1.06"` -> `"1.05"`.
- `bootstrap_test.py` r.38: `"v1.05" in riga` -> `"v" + VER in riga`, letto dal pin come fa gia' bootstrap.py.
- `bootstrap.py`: docstring r.10. Il testo C0 (r.92-93) va adattato: "con la v1.04 l EMA200 non si calcolava mai; con la v1.05 (tocco di 1 elemento) il lotto C0 del <data> non e' guarito". `VER` arriva gia' dal pin. Nessun apostrofo nelle stringhe (assert r.124).

### 4.6 File prova `backtest_pipeline/prove/NATCLA_F0_conteggio_2026-10-07.txt` (5 minuti, facoltativo ma consigliato)
I blocchi `@F0-*` non cambiano: stessi lotti, C0 = U30USD, D30EUR x AUDIO_H1, M2_H1. Si aggiorna solo il commento C0 (r.74-82): v1.06, tocco di n elementi, nuova IPOTESI ALTERNATIVA = modello 5 (v1.06) o "nessuno dei 7" (v1.06b), e la data attesa della VERIFICA ADX resta il 2024.10.16. Cambia lo SHA del prova, ma lo ricalcola il bootstrap. I 71 pin di `prova_pins.py` non cambiano: la v1.06 non tocca nessun input.

### 4.7 Righe (5 minuti + cancello)
Commit e push su `lavoro`. Il commit diventa il pin nuovo. Poi:
- `bootstrap.py <PIN> C0` e `bootstrap.py <PIN> C`: le righe C0 e C si rigenerano. La riga C deve dire "solo dopo C0 v1.06 SUPERATA".
- PILOTA, A, B, D **non si toccano**: pin `e2f0506b`, v1.04 su forex e oro, letta come archivio.
- Poi `bash backtest_pipeline/collaudo_natcla_f0/collaudo.sh <PIN>`, `collaudo_natcla.py` con i mutanti, `controlla_riga.py` sulle due righe, e infine il cancello (`controllo-preventivo`) prima di qualunque consegna.
- Se C0 v1.05 e' caduto, va aggiunta la **classe** in `CHECKLIST_RIGA_DI_LANCIO.md` ("tocco di 1 elemento non sblocca il tester pigro").

**Totale stimato:** circa 60-75 minuti di lavoro piu' il cancello. Il punto lungo e' il 4.2: modello e mutanti.

---

## 5. L'alternativa senza toccare l'EA: FromDate piu' tardi sugli indici

**Cosa e':** si cambia solo `da=` nei blocchi `@F0-SIMBOLO classe=IDX` del file prova. Il driver scrive `FromDate=$sim.da` nel .ini (r.539). Con abbastanza barre davanti all'inizio, l'EMA200 e' calcolata **alla creazione**: e' quello che e' MISURATO in (b), con 1462 barre davanti, `BarsCalculated` 1462 alla prima barra e lavoro dalla prima barra. **E' l'unica via misurata che funziona qualunque sia il meccanismo**: dopo la creazione la catena chiede n elementi a ogni barra. EA, driver e lettore non cambiano. Cambiano il file prova (SHA), le righe e i test con la data scritta: `battery.py` S01/S33 r.80-81 e r.218-220 (finestra "2024.09.26"), il testo C0 di `bootstrap.py` r.94 ("dal 2024.09.26").

**Il costo, calcolato e non stimato a occhio.** Barre per giorno feriale dagli indici BCM (dati dal 2024.09.26). Taratura H1 sui numeri della diagnosi: 117 barre al 10.04 e 302 al 10.16 12:00. Il conto predice 308 al 10.16. Su H4 si assumono 6 barre al giorno, su H12 2, su D1 1 [STIMA: sessioni da ~22 ore].

| data | H1 | H4 | H12 | D1 |
|---|---|---|---|---|
| 2024.11.15 | ~790 | ~190-216 (**a cavallo di 200**) | ~72 | ~36 |
| 2024.12.16 | ~1250 | ~340 | ~114 | ~57 |
| riscaldamento dell'EA (302 barre del TF) | 2024.10.16 | ~2024.12.06 | ~2025.04.25 | ~2025.11.22 |

- **Su H1 il costo NON sono "7 settimane".** Quelle si contano dal 2024.09.26 nominale, che l'EA non poteva comunque usare: le prime 302 barre sono di riscaldamento anche con il rimedio che funziona. Rispetto a un rimedio funzionante (inizio effettivo 2024.10.16):
  - FromDate **2024.11.15** costa **22 giorni feriali, il 5,0% della finestra H1** (444 feriali fino al 2026.06.30);
  - FromDate **2024.12.16** costa 43 feriali, il **9,7%**.

  Una data piu' stretta (circa 2024.10.17, ~300 barre davanti) costerebbe circa 0. Pero' **non e' misurata**: fra 116 barre (fallisce) e 1462 (funziona) nessuna passata ha provato. Che bastino 200 barre e' solo l'ipotesi del modello 0.
- **Il costo vero e' sui TF alti, e una data per classe non lo risolve.** Il driver ha UNA data per classe di simbolo, uguale per tutte le configurazioni. Con quella data, senza un rimedio nell'EA, ogni TF con meno di ~200 barre davanti resta in stallo per tutta la finestra:
  - con il **2024.11.15**: H1 ok; **AUDIO_H4 e M2_H4 a cavallo** di 200 barre H4 (NON MISURATO se bastano); **AUDIO_H12 e AUDIO_D1 in stallo sicuro**. Fino a **4 configurazioni x 10 indici = 40 passate del lotto C a zero setup**, cioe' NON MISURATE;
  - con il **2024.12.16**: H1 e H4 ok, con H1 al -9,7%. **AUDIO_H12 e AUDIO_D1 in stallo**: 20 passate NON MISURATE.
- **La versione senza costo** sarebbe una data **per TF** sugli indici, messa al riscaldamento: H4 ~2024.12.06, H12 ~2025.04.25, D1 ~2025.11.22. Costerebbe quasi zero rispetto al rimedio, perche' il riscaldamento si perde comunque. Pero' richiede una chiave nuova nel formato `@F0-*` (data per classe x config), con modifiche a driver, lettore, `prova_pins.py` e battery: **mezza giornata, non un'ora**, e un cancello pieno sul driver.
- **Regime:** la finestra indici resta "toro" (file prova r.30). Accorciarla non cambia il regime, ma riduce il campione H1 del 5-10%.

**Ordine consigliato se C0 v1.05 cade:** (1) **v1.06b** (o v1.06): un'ora di lavoro, C0 rifatto in ~3 minuti di macchina, nessuna perdita di finestra se funziona. (2) Solo se anche quella resta a zero: **FromDate 2024.12.16 sugli indici**. E' misurato da (b) e copre H1 e H4. H12 e D1 sugli indici vanno dichiarati **NON ANCORA MISURATI**, non morti (certificato di morte: manca la misura). In alternativa si fa il lavoro di mezza giornata sulle date per TF.

---

## 6. Cosa NON e' stato fatto (perimetro rispettato)
- Nessuna modifica a `mql5/Experts/EA_NatCla.mq5`, al driver, al lettore, alle righe, al file prova, a `collaudo_natcla*.py` o alla CHECKLIST.
- Nessun pin nuovo, nessuna riga generata, niente inviato a Claudio o al VPS.
- Gli script del par. 3 e le copie della v1.06/v1.06b sono in scratch, fuori dal repo, non committati.
- Committato solo questo referto.
