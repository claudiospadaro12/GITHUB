# 🏋️ R114 — LA PROVA DELLA LEVA (fase 2 della prova della taglia) — CRITERI **FIRMATI**

> 🖊️ **FIRMA: "FIRMO R114" — Claudio, 27/08/2026 mattina** (pre-autorizzata
> in chat: "FIRMO R114 QUANDO E' PRONTA, MANDAMI LE STRINGHE", registrata
> alla presentazione delle 10 decisioni con la verifica di coerenza col
> perimetro descritto — deviazioni segnalate: disegno a tre passate
> P0/P1/P2, canarino G-CAN, soglia margine 20% firmata qui, oro=970901
> con alternativa 971501 offerta e non esercitata). Firma a numeri non
> visti. 🔓 Lucchetto tolto da titolo e § 10 (checklist 82).

_Bozza scritta il 27/08/2026, PRIMA di qualunque numero, dalla sessione
agente su incarico della sessione principale. Nessun driver e nessun file
prova esiste ancora: arrivano DOPO la revisione della sessione principale
e DOPO la firma. Il lucchetto di questo file e' il token di stato nel
titolo e nel § 10; ovunque altro, quando lo si CITA, lo si scrive spezzato
— `[DA` + `FIRMARE]` — per non tenere chiuso il cancello con una
citazione (checklist 82)._

---

## 0. 🎯 LA DOMANDA DEL ROUND (nata da due atti dello stesso giorno)

**Con la leva prop (1:15 indici e oro, 1:100 forex, margin call 100%) e il
deposito challenge (200.000), quali sedie della flotta ricevono RIFIUTI DI
MARGINE o riduzioni, e come cambiano i loro numeri rispetto al banco di
casa?** E' la misura che decide QUALI SEDIE SALGONO sul conto prop.

I due atti che la generano, entrambi del 27/08:

| atto | cosa dice |
|---|---|
| `ANALISI_TAGLIA_FASE1_2026-08-27.md` | l'aritmetica: a leva 1:15 UN ingresso di ORB Dow impegna il **44%** del conto, EMADOW **39%**, MaxMinNotte **31%** (mediana 29%: il giorno TIPICO, non quello raro); il basket C1 (5 SL vivi) fa **149% del margine ai massimi / 84% alle mediane**. Il § 5 di quel file e' il mandato esplicito di questa FASE 2: _"rifare le celle vive con deposito 200k e leva 1:15 indici"_ |
| `RISPOSTA_FUNDEDNEXT_2026-08-27.md` | **[RISPOSTA SCRITTA]**, il rango piu' alto: Forex **1:100** · **Indici & Commodities 1:15** (challenge E funded), **margin call al 100%**, **zero tetti di lotti**. E la mossa che sblocca: _"il tester MT5 ha il campo `Leverage` nell'.ini: la FASE 2 puo' girare il banco a Leverage=15 e MISURARE i rifiuti invece di stimarli"_ |

La FASE 1 e' aritmetica su massimi di 2 settimane (17 chiusure): **pavimenti,
non tetti**. Questo round mette il tester al posto della calcolatrice.

---

## 1. ⚠️ IL PARAGRAFO PIU' IMPORTANTE — IL BANCO, LE SUE APPROSSIMAZIONI E CIO' CHE DA QUI NON E' VERIFICABILE

Il banco e' quello di casa (BCM, tick reali dove l'antenato li usa), con UN
solo parametro cambiato per la corsa che conta: **`Leverage=15`** nell'.ini.
Verificato negli atti prima di scriverlo (checklist 89: ogni parametro di
banco si RILEGGE, non si copia col suo commento):

1. 📐 **La leva di casa e' MISURATA, non ignota: `Leverage=100`.** Grep su
   tutte le righe di lancio (`righe/RIGA_R*.ps1`): ogni .ini di casa scrive
   `Leverage=100` (R97, R99, R100, R102, R103, R108, R109, R111, R113 —
   nessuna eccezione trovata). La FASE 1 diceva "leva demo BCM non agli
   atti": vero per il CONTO demo, ma **il BANCO ha sempre girato a 1:100**,
   ed e' il banco che questo round confronta. Conseguenza gia' misurabile
   senza accendere nulla: **per il forex la leva prop FundedNext (1:100) E'
   la leva del banco di casa** — la corsa a "leva prop" e quella di
   riferimento coinciderebbero per costruzione, zero informazione. Per
   questo il perimetro (§ 2) e' SOLO indici e oro. (Nota a margine: il
   ~50% di margine di Nightly EURUSD in FASE 1 era calcolato a 1:30 FTMO;
   a 1:100 FundedNext quel numero si divide per ~3,3 — aritmetica, da non
   confondere con una misura.)
2. 🧭 **La leva dell'.ini e' UNA leva per tutto il conto; la prop la
   dichiara PER CLASSE di strumento.** L'approssimazione pero' qui NON
   mescola: **ogni corsa del tester e' MONO-simbolo**, quindi
   `Leverage=15` su una corsa U30USD/D30EUR/XAUUSD E' la leva di quello
   strumento. L'approssimazione resta dichiarata per cio' che il round NON
   copre: un conto reale con sedie forex (a 1:100) e indici (a 1:15)
   aperte INSIEME non e' rappresentabile in una corsa sola — vedi punto 6.
3. 💶 **Il margine del tester passa dalle specifiche del SIMBOLO BCM**
   (contract size, `SYMBOL_MARGIN_INITIAL`, margin rate, valuta margine).
   Se il simbolo BCM porta un margin rate proprio, la leva dell'.ini
   **potrebbe non essere l'unico fattore** nel margine calcolato. NON e'
   verificabile da qui: **il giro a vuoto DEVE stampare le specifiche
   margine del simbolo** (sonda § 4, G-SPEC) e il referto deve mostrare,
   per cella, margine ATTESO per lotto (formula FASE 1) contro margine
   OSSERVATO dal tester. Se divergono, fa fede l'osservato e la FASE 1 si
   corregge.
4. 🕳️ **Mai girato in casa un `Leverage` diverso da 100**: che il tester
   onori davvero `Leverage=15` nel calcolo margine su questi simboli e'
   PLAUSIBILE ma NON MISURATO. Lo dimostra (o lo smentisce) il canarino
   G-CAN del § 4, che DEVE produrre un rifiuto: se a leva strozzata il
   rifiuto non arriva, il banco non sta simulando la leva e il round si
   ferma li'.
5. 📞 **Margin call 100% / stop-out della prop**: quale margin level il
   tester usi per rifiutare (e per l'eventuale stop-out) non e'
   impostabile ne' leggibile da qui. Il giro a vuoto stampa
   `ACCOUNT_MARGIN_SO_CALL` / `ACCOUNT_MARGIN_SO_SO` visti dall'EA nel
   tester; il referto li dichiara accanto al 100% scritto di FundedNext.
   Se differiscono, i rifiuti misurati sono un'approssimazione DICHIARATA
   del comportamento prop.
6. 🧺 **Questo round misura il margine PER SEDIA, non il basket.** Il
   149%/84% del C1 (FASE 1 § 3b) resta aritmetica: un banco multi-sedia
   simultaneo non esiste e non si improvvisa qui. Fuori perimetro,
   dichiarato — e' il buco che resta aperto DOPO questo round.
7. 💱 **Valuta**: banco di casa `Currency=EUR`, deposito 200.000 EUR; la
   challenge FundedNext e' in USD. Il margine in % e' quasi invariante
   alla valuta del conto ma non esattamente (conversioni USD/EUR):
   approssimazione dichiarata, non misurata.

---

## 2. 🔩 PERIMETRO — le QUATTRO celle col margine piu' pesante, ognuna col suo antenato CONGELATO

Le celle sono quelle che la FASE 1 mette in cima alla colonna del margine,
e per tutte esiste il file prova congelato in `prove/` (verificato):

| cella | sedia (magic vivo) | simbolo/TF | antenato (file prova agli atti) | rischio antenato | finestra antenato | modello antenato |
|---|---|---|---|---|---|---|
| `C0_ORB` | ORB Dow (770611) | U30USD M5 | `prove/R103_ABTG_ORB_Ottimizzato_U30USD_770611.txt` | 0,3% | 2024.09.26-2026.06.30 | tick reali (4) |
| `C1_EMADOW` | EMA200 Dow (771531) | U30USD | `prove/R112_00_metro.txt` | 1,0% | 2024.09.26-2026.06.30 | tick reali (4) |
| `C2_MAXMIN` | MaxMinNotte DAX Short (770411) | D30EUR | `prove/R103_ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_770411.txt` | 0,65% | 2024.09.26-2026.06.30 | tick reali (4) |
| `C3_ORO` | SupertrendReversal oro (970901) | XAUUSD H4 | `prove/R103_ABTG_SupertrendReversal_Ottimizzato_XAUUSD_970901.txt` | come da antenato | 2020.01.01-2026.06.30 | OHLC M1 (1) |

**Tre scelte di perimetro motivate (adattamenti rispetto alla proposta di
partenza, da firmare):**

- **Per EMADOW l'antenato e' il metro R112, non il file R103.** Ragione
  misurata: R112 e' l'unico banco di casa col **G0-B dimostrato al
  centesimo, due volte** — l'aggancio P0 (§ 3) su quella cella e' una
  controprova al centesimo, non "circa". E il metro gira a 1% mentre la
  sedia in campo sta a 0,65%: **a fini margine 1% e' PIU' severo** (lotti
  ×1,54) — se il metro passa pulito a 1:15, la sedia in campo passa a
  maggior ragione; se il metro prende rifiuti, si legge dove.
- **La sedia oro rappresentativa e' 970901** (SupRev XAUUSD H4): e' la
  sedia oro viva col dossier storico piu' lungo di casa (R99, 22 anni).
  Alternativa equivalente se Claudio preferisce: 971501 (EMA200 oro H4,
  `prove/R103_ABTG_EMA200_Ottimizzato_XAUUSD_971501.txt`) — da indicare
  in firma. FundedNext scrive "Commodities 1:15": l'oro gira a 15.
- **Ogni cella tiene LA FINESTRA E IL MODELLO DEL SUO ANTENATO** — per
  gli indici e' proprio la finestra di casa 2024.09.26-2026.06.30 a tick
  reali; per l'oro e' la finestra del gruppo forex R103 (2020-2026, OHLC
  M1, l'unico banco congelato di quella sedia). Uniformare l'oro alla
  finestra corta avrebbe richiesto un delta sulle date e **avrebbe
  rotto l'aggancio ai numeri agli atti** (P0 non avrebbe piu' nulla da
  riprodurre). Il confronto che decide (§ 3) e' comunque INTERNO alla
  cella: stessa finestra, stesso modello, cambia solo la leva. I numeri
  dell'oro non si confrontano con quelli degli indici — finestre diverse,
  dichiarato.

**Fuori perimetro, dichiarato**: le sedie forex (leva prop = leva banco,
punto 1 del § 1), Aperture DAX/DOW (margine FASE 1 sotto o al filo della
soglia: entrano in un eventuale R114-bis solo se questo round trova
sorprese), il basket multi-sedia (§ 1 punto 6), le altre ~27 sedie senza
volumi agli atti.

---

## 3. 🧪 IL DISEGNO — TRE PASSATE PER CELLA, per separare TAGLIA e LEVA

Per ogni cella, tre passate a parametri EA IDENTICI (il lotto nasce dal
rischio %, NON dalla leva — quindi ogni differenza fra P1 e P2 puo' venire
SOLO dal margine):

| passata | deposito | leva | cosa misura | attesa PRE-DICHIARATA |
|---|---:|---:|---|---|
| **P0 — aggancio** | 100.000 | 100 | il banco e' LO STESSO dell'antenato? | riproduzione dei numeri agli atti: **al centesimo** su C1 (G0-B R112 gia' dimostrato); sulle celle R103 riproduzione attesa ma MAI dimostrata prima — se non torna, PRIMA si spiega P0, POI si guarda il resto |
| **P1 — taglia** | 200.000 | 100 | il raddoppio di taglia da solo | n IDENTICO a P0; profitto/DD in % uguali a meno di granularita' del lotto e di eventuali tagli a `SYMBOL_VOLUME_MAX=100` (righe a 100 nel per-trade: SI CONTANO — e' la parte "taglia" del cancello 6) |
| **P2 — leva** | 200.000 | **15** | LA DOMANDA DEL ROUND | se il margine non morde: **IDENTICA a P1 al centesimo** (stesso banco deterministico, la leva non tocca il sizing). QUALUNQUE differenza P2−P1 = margine che ha morso, e va spiegata riga per riga |

Il DELTA che il referto stampa per cella e' **P2 contro P1** (leva a parita'
di tutto) piu' **P1 contro P0** (taglia a parita' di tutto): n, profitto,
PF, DD %, peggior giornata, vol max/mediana, righe tagliate a 100, righe
rifiutate. DD confrontati come magnitudini positive, verso dichiarato
(checklist 87). Split IS/OOS 40/60 di casa, SOLO per comparabilita' coi
numeri esistenti: il verdetto leva si legge sull'intera finestra, il
dettaglio IS/OOS va a referto perche' e' il formato degli atti.

### 3-bis. 🔎 COME SI VEDONO I RIFIUTI (e cosa l'assenza della riga NON prova)

1. **Il journal del tester logga i rifiuti** (la classe "not enough
   money"). Il driver DEVE raccogliere i log del tester per ogni passata
   e cercare quella riga. Sono tutte passate SINGOLE (`Optimization=0`):
   il journal esiste — in ottimizzazione non lo legge nessuno (checklist
   34) e infatti qui non si ottimizza niente.
2. **La stringa esatta NON si assume** (VPS in italiano, checklist 5: la
   riga potrebbe essere localizzata). La stringa la INSEGNA il canarino
   G-CAN (§ 4): il pattern del rilevatore si estrae dal journal del
   canarino, dove il rifiuto DEVE esserci — misurato, non ipotizzato.
3. **L'assenza della riga NON prova l'assenza di riduzioni silenziose.**
   Verificato nei sorgenti PRIMA di scriverlo, cella per cella: grep
   `OrderCalcMargin|FreeMargin` su tutto `mql5/` trova logica margine
   SOLO in ABTG_TurnaroundTuesday, ABTG_CanaleLento, ABTG_MeanRevert —
   **NESSUNO dei 4 EA del perimetro** (ABTG_ORB_Ottimizzato,
   ABTG_EMA200, ABTG_MaxMinNotte_DAX_Short_Ottimizzato,
   ABTG_SupertrendReversal_Ottimizzato) **riduce il lotto sul margine**:
   il loro sizing fa solo clamp a `SYMBOL_VOLUME_MIN`/`MAX` (righe
   655-665 / 353-363 / 452-462 / 415-425 rispettivamente). Quindi per
   QUESTE quattro celle un rifiuto e' NETTO (il trade manca, n cala) e
   l'unica riduzione silenziosa possibile e' il clamp a 100 lotti — che
   si conta dal per-trade CSV (righe a volume 100), non dal journal.
   Se un round futuro imbarca un EA con logica margine, questa frase va
   RIFATTA per quell'EA, non ereditata.
4. **Il rilevatore n. 1 resta il DELTA di n**: ogni trade di P1 assente
   in P2 e' un ingresso non fatto, journal o non journal.

---

## 4. 🚧 I CANCELLI

### G0-A — l'antenato (checklist 72: delta pretesi PER NOME, mai solo il gemello)
Ogni file prova R114 e' la COPIA RIGA PER RIGA del suo antenato del § 2.
**Il delta ammesso e' UNO SOLO: `InpMagic`** (blocco vergine § 5).
Deposito, leva, valuta e modello NON stanno nel file prova: **sono
parametri di banco che il DRIVER scrive nell'.ini** (`Deposit=`,
`Leverage=`, `Currency=`, `Model=`), passata per passata, e il giro a
vuoto li stampa tutti e quattro per ogni .ini generato. Ne' un buffer,
ne' un lato, ne' una data: rischio, finestra e parametri restano quelli
dell'antenato.

### G0-C — i gemelli
Ogni passata gira in coppia gemella (magic +1, § 5): risultati IDENTICI o
la corsa non vale.

### G-SPEC — la sonda delle specifiche margine (nel giro a vuoto, obbligatoria)
Prima delle corse, per ognuno dei 3 simboli del perimetro si stampano:
`SYMBOL_TRADE_CALC_MODE`, `SYMBOL_MARGIN_INITIAL`,
`SYMBOL_MARGIN_MAINTENANCE`, i margin rate (`SymbolInfoMarginRate` per
BUY e SELL), `SYMBOL_CURRENCY_MARGIN`, contract size,
`SYMBOL_VOLUME_MIN/MAX/STEP/LIMIT`, piu' `ACCOUNT_MARGIN_SO_CALL` /
`ACCOUNT_MARGIN_SO_SO` visti nel tester. E' la chiusura del limite § 1
punto 3: senza questa stampa il referto non puo' dire PERCHE' un margine
osservato differisce dall'atteso.

### G-CAN — il canarino del rilevatore (checklist 40/84-bis: un gate deve DIMOSTRARE di saper mordere)
Una passata extra su `C0_ORB` con **deposito strozzato apposta**
(proposta: `Deposit=2000`, `Leverage=15`) che DEVE produrre almeno un
rifiuto di margine. Doppio uso: (a) e' il controllo positivo del
rilevatore — se il driver non trova NESSUNA riga di rifiuto nel journal
del canarino, il rilevatore e' rotto e **exit ≠ 0** (non si legge nessun
"zero rifiuti" delle corse vere con un rilevatore mai visto mordere);
(b) dal suo journal si estrae la STRINGA vera del rifiuto (§ 3-bis
punto 2). Il canarino non entra in nessuna tabella di verdetto.

### G1 — il campione
Le celle sono le sedie vive coi loro n gia' agli atti (C1: 517 uscite nel
solo OOS R112). Nessuna soglia nuova: il round non giudica il MERITO dei
motori — giudica il banco. Vale pero' la convenzione R112: **n conta i
DEAL DI USCITA** (~2 uscite ≈ 1 posizione), ripetuta accanto a ogni n.

### G4 — l'ordine di lettura (anti-alibi, pre-dichiarato)
Se P0 NON riproduce l'antenato, la cella e' **NON MISURABILE in questo
round** (il banco non e' quello degli atti): niente verdetto leva su un
aggancio rotto. Se P0 riproduce e P1 mostra tagli a 100 lotti, i tagli
si dichiarano PRIMA di leggere P2 (sono effetto taglia, non leva).

---

## 5. 🔢 MAGIC — blocco vergine 7636xx (verificato)

Grep `7636` su `mql5/`, `prove/`, `righe/`, `report/` e
`risultati_archivio/` (md/txt/ps1/mq5): **zero occorrenze come magic** —
le uniche ricorrenze della cifra sono coincidenze numeriche dentro CSV di
scansione, snapshot JSON e un PDF. R112 ha bruciato 7634xx, R113 si e'
riservato 7635xx: il blocco **763600-763699 e' vergine**.

Schema: **`763600 + C×20 + P×2 + G`** — C = cella 0-3 (§ 2), P = passata
0-2 (§ 3), G = gemello 0/1. Esempi: C0-P0 763600/763601; C1-P2
763624/763625; C3-P2 763664/763665. Canarino G-CAN: **763690/763691**.
Range totale: 763600-763665 + 763690/763691. I magic vivi 770611, 771531,
770411, 970901 sono **VIETATI** nel round e il driver li controlla.

---

## 6. 🧠 LA LETTURA PRE-DICHIARATA — il verdetto per sedia, scritto PRIMA dei numeri

Per ogni cella, il confronto **P2 contro P1** (la leva, a parita' di
tutto), con i rifiuti = (n P1 − n P2) riscontrati + righe journal:

| verdetto | condizione (pre-dichiarata) | conseguenza sulla lista § 7 |
|---|---|---|
| 🟢 **VERDE** | P2 IDENTICA a P1 al centesimo E zero righe di rifiuto nel journal E zero righe a volume 100 comparse in P2 che in P1 non c'erano | la sedia sale sulla prop alla taglia firmata, senza riserve di margine |
| 🟡 **GIALLO** | differenze CON rifiuti loggati/riscontrati su **≤ 5% degli ingressi di P1**, E profitto di finestra ancora positivo, E DD% non oltre il DD promesso della cella (criterio sedie del 18/08) | la sedia sale **SOLO RIDOTTA**: la % di riduzione si CALCOLA (lotto massimo finanziabile al 20% del conto a 1:15, formula FASE 1 § 3a — soglia 20% ancora non firmata, si firma qui) e va nella delibera d'acquisto, non qui |
| 🔴 **ROSSO** | rifiuti su **> 5% degli ingressi di P1**, O profitto di finestra che cambia segno, O DD% oltre il DD promesso della cella | la sedia **NON sale a questa leva**: o resta a casa, o rientra solo con una gestione nuova (round suo, Seconda Caccia se serve) |
| ⬜ **NON MISURABILE** | P0 non riproduce l'antenato (G4) | nessun verdetto: prima si ripara l'aggancio |

Vincoli di lettura: il 5% si conta sugli INGRESSI (posizioni, non deal di
uscita — convenzione R112 dichiarata accanto); "identico al centesimo" e'
la soglia giusta perche' il banco e' deterministico (G0-B R112) e la leva
non tocca il sizing — **non esiste un "quasi verde"**: una differenza
qualsiasi ha una causa di margine e va trovata. Il quadro "P2 diversa da
P1 ma zero rifiuti trovati" e' un'ANOMALIA da spiegare prima del verdetto
(rilevatore o banco), non un giallo d'ufficio.

---

## 7. 🚫 G5 — NESSUN DEPLOY, PER COSTRUZIONE

Il round non tocca VPS, non tocca sedie, non compra niente. Produce UN
artefatto decisionale: **la LISTA DELLE SEDIE AMMISSIBILI ALLA PROP** —
per ognuna verdetto 🟢/🟡/🔴, i delta P2−P1 e P1−P0, l'eventuale riduzione
calcolata — da firmare POI dentro la delibera d'acquisto (PIANO_PROP,
cancello 6). Le celle qui misurate parlano per le sedie omonime; per le
~27 sedie senza volumi agli atti la lista scrive ⚫ NON MISURATO, mai un
verdetto per analogia.

---

## 8. 🛡️ PREVENZIONI DALLA CHECKLIST (difetti gia' pagati)

| punto | prevenzione in R114 |
|---|---|
| **72** | G0-A confronta ogni file prova con l'ANTENATO per nome dei delta (uno solo: `InpMagic`); il gemello da solo non vede la corruzione simmetrica |
| **80** | i criteri poggiano solo su artefatti che questo banco esporta DAVVERO: journal delle passate singole, per-trade CSV (modello export R112), report .htm; nessuna colonna ereditata da un banco che qui non c'e' |
| **82** | token di stato solo nei due lucchetti veri (titolo e § 10); ogni citazione in prosa e' spezzata; alla firma si rigrepa il file INTERO per il token, non solo il titolo |
| **84** | ogni cancello (G0-A, G0-C, G-SPEC, G-CAN, G4) vive nel codice d'uscita del driver, MAI solo nel renderer del referto: esito ≠ OK ⇒ exit ≠ 0 |
| **86** | le finestre sono date server BCM; ogni orario nel referto dichiara il suo orologio (i log del tester sul VPS sono in ora locale italiana, il grafico in ora server) |
| **87** | DD confrontati come magnitudini positive col verso dichiarato; profitti col segno; nessun `<=` letterale su grandezze a segno misto |
| **88** | pulizia degli artefatti condivisi PER PASSATA subito prima del suo lancio, mai globale a inizio corsa; passate saltate ⇒ artefatti esistenti raccolti con eta' dichiarata; rilancio solo con `-Rifai` |
| **89** | `Leverage=`, `Deposit=`, `Currency=`, `Model=` riletti nel significato di QUESTO banco (simboli broker BCM, non custom) e stampati dal giro a vuoto per ogni .ini; il § 1 separa riga per riga il VERIFICATO (leva di casa 1:100, sorgenti senza logica margine) dal NON VERIFICABILE DA QUI (tester che onora Leverage=15, stringa del journal, stop-out level, margin rate del server prop) |

E la lezione madre della FASE 1 resta scolpita: **misurato, o dichiarato
mancante, mai ipotizzato** — ogni numero del referto porterà la sua
etichetta come nella FASE 1.

---

## 9. 📋 COSA RESTA FUORI E DOVE VA (perche' nessuno lo cerchi qui)

- **Basket multi-sedia a 1:15** (149%/84% FASE 1): buco dichiarato, serve
  un banco multi-sedia che non esiste — decisione operativa possibile
  senza tester: cap C1 riformulato anche in MARGINE, da discutere in
  delibera.
- **Slippage alla taglia** (21,5 pt R109): il tester non modella il book,
  nessuna corsa lo misurera' — resta nelle domande scritte.
- **Margin rate reali del server FundedNext** (≠ leva di conto, possono
  variare per simbolo/orario): domanda scritta gia' impostata sul modello
  FTMO (FASE 1 § 6), da spedire anche a FundedNext se la delibera avanza.
- **`SYMBOL_VOLUME_MAX` su XAUUSD**: la sonda G-SPEC lo stampa — chiude
  in corsa il buco dichiarato in FASE 1 § 0c.

---

## 10. ✍️ LE DECISIONI — **FIRMATE** ("FIRMO R114", 27/08/2026 mattina)

_Si firmano con **"FIRMO R114"** (eventualmente "con proposte", indicando
la D e il valore). Dopo la firma: il token di stato va tolto dal titolo E
da questo paragrafo, e il file va rigrepato per intero (checklist 82)._

1. **D1 — PERIMETRO**: le 4 celle del § 2 (ORB Dow, EMADOW metro R112,
   MaxMinNotte DAX Short, SupRev oro 970901), ognuna col SUO antenato
   congelato, la SUA finestra e il SUO modello. Fuori: forex (leva prop =
   leva banco, misurato § 1), Aperture DAX/DOW, basket, le ~27 sedie
   senza volumi. In firma si puo' sostituire 970901 con 971501.
2. **D2 — BANCO**: deposito challenge 200.000 (Currency=EUR, approssimazione
   dichiarata § 1 punto 7), leva PER STRUMENTO via corse mono-simbolo:
   indici e oro `Leverage=15`, riferimento `Leverage=100` (la leva di
   casa, misurata nelle righe di lancio). Split 40/60 solo per
   comparabilita'.
3. **D3 — DISEGNO A TRE PASSATE**: P0 aggancio (100k/lev100, deve
   riprodurre gli atti), P1 taglia (200k/lev100), P2 leva (200k/lev15);
   attese pre-dichiarate del § 3; delta P2−P1 e P1−P0 stampati per cella.
4. **D4 — RILEVATORE RIFIUTI**: raccolta journal per passata + conteggio
   righe rifiuto + delta n come rilevatore primario; stringa del journal
   IMPARATA dal canarino, mai assunta; dichiarazione cella per cella che
   gli EA del perimetro NON riducono il lotto sul margine (grep agli
   atti, § 3-bis punto 3) e che il clamp a 100 lotti si conta dal
   per-trade.
5. **D5 — G-SPEC**: sonda specifiche margine obbligatoria nel giro a
   vuoto (elenco § 4), margine atteso vs osservato nel referto.
6. **D6 — G-CAN**: canarino a deposito strozzato (proposta: 2.000 a
   leva 15 su C0) che DEVE produrre un rifiuto; rilevatore che non morde
   sul canarino ⇒ exit ≠ 0 e round fermo.
7. **D7 — LETTURA**: la griglia 🟢/🟡/🔴/⬜ del § 6, con la soglia rifiuti
   al 5% degli ingressi, il DD promesso come limite del giallo, e la
   **soglia margine 20% del conto** (nata in FASE 1, qui si firma) come
   base del calcolo delle riduzioni.
8. **D8 — MAGIC**: blocco 763600-763665 + canarino 763690/763691, schema
   `763600+C×20+P×2+G`; magic vivi vietati e controllati dal driver.
9. **D9 — G4/ORDINE DI LETTURA**: P0 rotto ⇒ cella NON MISURABILE,
   nessun verdetto leva; tagli a 100 lotti dichiarati come effetto
   taglia PRIMA di leggere P2.
10. **D10 — G5**: nessun deploy, nessuna sedia mossa. Il round produce la
    LISTA DELLE SEDIE AMMISSIBILI ALLA PROP (verdetti + riduzioni
    calcolate), che entra nella delibera d'acquisto del cancello 6 e si
    firma la', non qui.

---

_Dopo la firma: driver e file prova (4 celle × 1 file prova ciascuno — le
passate P0/P1/P2 e i gemelli vivono negli .ini e nell'asse magic del
driver, non in file prova separati) li prepara la sessione principale;
questo file diventa il cancello che il driver legge al pin, e la corsa
parte senza switch. Nota di costruzione: il driver pilota il tester con
`Deposit`/`Leverage` propri per passata — `walkforward_generico` scrive
`Leverage=100` fisso, quindi NON si passa dal generico cosi' com'e'
(stessa classe della nota R113 sulle finestre)._
