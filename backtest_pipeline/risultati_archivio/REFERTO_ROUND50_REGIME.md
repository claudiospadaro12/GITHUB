# REFERTO ROUND 50 — LA PROVA DI REGIME (14/08/2026 sera)

**La domanda:** le celle vive della fascia forex reggono in un mercato che non
sale? Fino a oggi erano state misurate su **21 mesi con un regime solo**.

**Come:** 8 celle congelate x 4 finestre su storico esterno importato
(`GBPUSD_EXT`, `EURUSD_EXT`, 2018-2024, 2,55 milioni di barre M1, differenza
dal feed BCM 0,0041-0,0052%, copertura 99,6%). Modello 1 (OHLC M1), deposito
100.000, rischio 1%.

**Igiene:** 32 CSV su 32, e le **due righe gemelle del magic sono identiche in
tutti e 32** — nessuna cella ha risposto in modo diverso a se stessa.

---

## 1. LA TABELLA

Profit in EUR su 100.000 al rischio 1%. `n` = numero di operazioni.

| cella | ORSO 2022 | CROLLO 2020 | TORO 2021 | LATERALE 2019 |
|---|---|---|---|---|
| **PTE_GBPUSD** | **+1.245** PF 1,62 DD 1,99 n18 | **+70** PF 1,07 DD 1,41 n11 | +1.362 PF 1,45 DD 2,48 n37 | +5.284 PF 1,84 DD 4,67 n51 |
| **LARRY_GBPUSD** | **+1.587** PF 1,78 DD 2,18 n12 | **−708** PF 0,29 DD 2,20 n3 | +4.095 PF 2,02 DD 2,50 n19 | −6.445 PF 0,34 DD 6,62 n16 |
| **BB_EURUSD** | **+932** PF 1,63 DD 1,40 n7 | **+502** PF — DD 0,24 **n1** | −1.561 PF 0,60 DD 3,29 n9 | −2.381 PF 0,37 DD 2,95 n9 |
| **BB_GBPUSD** | **−144** PF 0,93 DD 1,88 n8 | **−4** PF 1,00 DD 1,46 n6 | −155 PF 0,97 DD 3,23 n18 | +735 PF 1,26 DD 2,95 n12 |
| **SW_GBPUSD** | **−205** PF 0,96 DD 4,04 n51 | **+115** PF 1,07 DD 1,60 n17 | −2.419 PF 0,63 DD 4,72 n63 | −938 PF 0,80 DD 3,23 n61 |
| **EZ_GBPUSD** | **−124** PF 0,99 DD 9,96 n32 | **−4.507** PF 0,39 DD 4,77 n10 | +279 PF 1,01 DD 6,95 n34 | +9.443 PF 1,54 DD 5,62 n35 |
| **GAP_GBPUSD** | 0 trade | 0 trade | 0 trade | +1.000 n1 |
| **GAP_EURUSD** | 0 trade | 0 trade | 0 trade | 0 trade |

Le due colonne in grassetto (ORSO e CROLLO) sono le **finestre avverse**: e'
li' che i criteri A, B, C e D guardano.

---

## 2. I VERDETTI, ognuno col criterio che lo produce

### PTE_GBPUSD -> **PROMOZIONE DI RANGO** (criterio C)

L'unica cella **positiva in tutte e quattro le finestre**. Nell'orso PF 1,62
(soglia C: >= 1,10), nel crollo PF 1,07 e comunque in utile. Criterio D
soddisfatto: ORSO e CROLLO vanno **nella stessa direzione**. Campioni
decenti (18 e 11 operazioni nelle finestre avverse, 51 nel laterale).

E' esattamente il profilo che il round cercava: **un motore che lavora in
entrambi i regimi**, non uno che vive di un mercato solo. Priorita' in prop e
candidato al peso pieno.

### BB_GBPUSD -> **SOPRAVVIVE** (criterio B), nessun cambio di rango

PF 0,93 e 1,00 nelle due finestre avverse: sopra la soglia di
non-sanguinamento (0,90). Non guadagna, ma non si distrugge — che e'
esattamente cio' che il criterio B chiede. Numeri piccoli in valore assoluto
(−144 e −4 EUR): e' una cella che nelle finestre avverse **quasi non opera**.

### SW_GBPUSD -> **MISURA ANNULLATA, DA RIFARE** (errore mio nel file celle)

**La riga di SuperWave in `CELLE_REGIME.txt` era sbagliata, e l'ho peggiorata
io poche ore prima del lancio.** Diceva `H4` nella colonna del periodo ma
passava `InpTF=16386`, che e' **H2**. Su segnalazione dell'audit ho
"corretto" il numero portandolo a 16388 (H4). Era il contrario: la cella VIVA
e' **SuperWave GBPUSD H2** (`CAMPAGNA_ARSENALE`, sedia +1, magic 770532), e il
file fuori campione di riferimento e' a TF 16386. Sbagliata era l'etichetta,
non il parametro.

**Conseguenza:** le quattro finestre di SW_GBPUSD hanno misurato una cella che
in vivaio non esiste. I numeri qui sotto restano agli atti ma **non valgono
come verdetto**, e i quattro lanci vanno rifatti con `InpTF=16386`.

Come si e' scoperto: cercando il DD fuori campione per chiudere il criterio A,
il file archiviato conteneva TF 16386 e non 16388. **La verifica di un criterio
ha trovato l'errore in un altro punto**: e' il motivo per cui i criteri si
scrivono prima.

_Quello che segue vale solo come annotazione sulla cella H4, che non esiste:_

### SW_GBPUSD (H4, cella inesistente) — annotazione, NON un verdetto

PF 0,96 e 1,07 nelle avverse: criterio B passato. Pero' e' **negativo in tre
finestre su quattro**, e la peggiore e' il **TORO 2021** (−2.419, PF 0,63),
cioe' il regime piu' simile a quello in cui e' stata tarata. I criteri di R50
non giudicano le finestre non avverse, quindi **questo non e' un verdetto**:
e' un dato che va portato al prossimo round di portafoglio.

### LARRY_GBPUSD -> **NESSUNA DECISIONE** (criterio D)

Nell'orso fa PF 1,78 (+1.587): sarebbe promozione di rango. Nel crollo fa PF
0,29 (−708): sarebbe bocciatura per criterio B. **Le due finestre avverse
dicono il contrario l'una dell'altra**, e la regola dei due banchi vieta di
decidere da una sola. Nessuna promozione, nessun declassamento.

Da leggere ricordando che **e' l'unica cella short-only**: l'orso e' il suo
terreno naturale, quindi il +1.587 e' meno sorprendente di quanto sembri. Il
crollo 2020 ha **3 sole operazioni**: non ci si costruisce niente sopra.
Il dato che colpisce di piu' non e' nelle finestre avverse: e' il
**−6.445 del laterale 2019**, con DD 6,62%, il peggiore di tutta la tabella.

### BB_EURUSD -> **NIENTE PROMOZIONE** (criterio D), con una bandiera rossa

Nell'orso fa PF 1,63: sarebbe criterio C. Ma nel crollo c'e' **UNA sola
operazione**: non e' una misura, e la regola dei due banchi non puo' essere
soddisfatta. Quindi niente promozione.

**La bandiera rossa sta fuori dai criteri** e va detta lo stesso: questa cella
guadagna nell'orso (+932) e **perde nel toro (−1.561) e nel laterale
(−2.381)**. Cioe' va peggio proprio nel regime piu' simile a quello in cui e'
stata promossa (2024-2026, mercato in salita). O il regime recente e' meno
"toro" di quanto pensiamo sul forex, o c'e' qualcosa da capire. **[INCERTO]**:
non e' un verdetto, e' una domanda da mettere in coda.

### EZ_GBPUSD -> **RIPESCAGGIO NEGATO** (criterio E, per fallimento di B)

Easy Trend era stato bocciato in R49 dal portafoglio (alzava la coda MC da
12,47 a 14,63). Il criterio E gli dava una seconda porta: passare A **e** C.
Non passa nemmeno B: nel crollo 2020 fa **PF 0,39 e −4.507 EUR**, il peggior
numero singolo del round.

**Resta fuori**, e questa volta per un motivo indipendente dal primo. Due
bocciature che arrivano da strade diverse valgono piu' di due dalla stessa.

### GAP_GBPUSD e GAP_EURUSD -> **NON MISURATE** (nessun verdetto)

**Zero operazioni** in quasi tutte le finestre (una sola in tutto il 2019 su
GBPUSD). Non e' una bocciatura: e' una **non-misura**, e va trattata come
tale.

Il motivo piu' probabile e' tecnico e riguarda proprio questa famiglia: il
gap-fill vive sui **confini di sessione** (chiusura del venerdi', apertura
della domenica). Il feed importato ha confini diversi da quelli di BCM, e in
piu' l'import applica uno **shift costante di +5 ore** che sposta l'inizio e
la fine della settimana. Una strategia che misura il salto fra due sessioni e'
la piu' sensibile in assoluto a questo.

**Regola che ne esce:** le famiglie che dipendono dai confini di sessione non
si possono provare su un feed esterno con uno shift costante. Per GAP la prova
di regime va rifatta **sul feed nativo** quando ci sara' storico, o non va
fatta affatto.

---

## 3. QUELLO CHE IL ROUND NON HA POTUTO CHIUDERE

**Criterio A, la meta' assoluta: verificata per tutte.** Il DD peggiore di
tutto il round e' **9,96%** (EZ nell'orso), contro un tetto del 20%.

**Criterio A, la meta' relativa: CHIUSA per PTE, aperta per le altre.**
Ripescato dall'archivio il fuori campione della cella promossa
(`risultati_prove/ABTG_PTE/ABTG_PTE_GBPUSD_OOS_r23b.csv`, TF 16385,
TP1_ATRmult 0,5, rischio 1%):

| | DD | soglia (2x) | ORSO | CROLLO | esito |
|---|---|---|---|---|---|
| **PTE_GBPUSD** | OOS **3,27%** | 6,54% | **1,99%** | **1,41%** | ✅ passato con larghezza |

Quindi per PTE il criterio A e' soddisfatto in tutte e due le meta', e la
promozione di rango **non e' piu' sospesa**.

Per BB, LARRY e GAP i CSV fuori campione stanno in sottocartelle di round
diversi (`r33`/`r34`, `r39`, `r36`/`r37`) e vanno ripescati uno per uno:
**[DA COMPLETARE]**, ma nessuna di quelle celle e' in promozione, quindi non
blocca nessuna decisione.

**I campioni sono piccoli.** Nelle finestre avverse si va da 1 a 51 operazioni,
con la maggior parte fra 3 e 18. Il crollo 2020 dura tre mesi: su strategie
H1/H4 sono pochi segnali per definizione. Le direzioni contano piu' dei
numeri.

**Manca il grosso della squadra.** Niente indici (DAX, Dow, Nasdaq, Nikkei) e
niente oro: HistData non li ha. Sono **4 titolari su 5**. Questo round parla
solo della fascia forex, e va citato cosi' ogni volta che se ne parla.

---

## 4. DECISIONI

1. **PTE GBPUSD sale di rango.** E' l'unico che ha superato C con D
   soddisfatto. Da qui in avanti va trattato come motore da entrambi i
   regimi — dopo il completamento del criterio A.
2. **EZ resta fuori.** Seconda bocciatura, motivo indipendente.
3. **BB_GBPUSD resta dov'e'.** Sopravvive (criterio B), non promuove.
3-bis. **SW_GBPUSD: misura annullata.** Quattro lanci da rifare con
   `InpTF=16386` (H2), la cella che gira davvero.
4. **LARRY e BB_EURUSD: nessuna decisione**, per regola dei due banchi.
5. **GAP: prova non valida**, da rifare altrove. Nessun effetto sulla squadra.
6. **Da fare prima di muovere pesi:** la tabella dei DD fuori campione per
   cella, per chiudere il criterio A.

Nessun EA cambia lato, peso o parametro per effetto di questo referto: le
celle erano e restano congelate.
