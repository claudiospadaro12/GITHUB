# TRIANGOLAZIONE DI FEDELTA' — BULGE "Leonardo v4" vs Pine vecchio vs famiglia EA
**28/08/2026** — fonte nuova: `docs/breaking_band/bulge_leonardo_v4_2026-08-28.pine`
(incollato da Claudio oggi, salvato integrale, mai toccato).
Confronto contro: `docs/breaking_band/PROTOCOLLI_LEONARDO.md`,
`docs/breaking_band/indicatore_inbulge_claudio.pine`,
`mql5/Experts/BULGE_MASTER.mq5` (righe 745-906),
`mql5/Experts/ABTG_Bulge.mq5` (righe 1440-1580),
`docs/Analisi_EA_BULGE.md`,
e la triangolazione del 21/08 (`TRIANGOLAZIONE_BULGE_PINE_2026-08-21.md`).

---

## 🔴 VERDETTO IN UNA RIGA
**Il v4 e' un RAMO INDIPENDENTE, non un'evoluzione: e' l'UNICO codice in casa che
implementa la meccanica IN-BULGE di Leonardo (attraversamento completo verso la banda
opposta) — ma cosi' com'e' incollato NON PUO' MAI SCATTARE (bug dell'anti-spam, riga 50)
e la soglia short e' 2,8x piu' larga di quella long (`pos > 0.35` contro `pos < 0.20`).**

---

## 1. LA DOMANDA PRINCIPALE — il v4 fa davvero IN-BULGE?

### Risposta: SI, condizione per condizione. E' la meccanica che il codice esistente non ha.

Confronto della sola direzione LONG (lo short e' speculare) fra le tre fonti.

| # | regola di Leonardo (IN-BULGE, `PROTOCOLLI_LEONARDO.md` righe 5-16) | v4 (righe 34-36) | Pine vecchio `inBulgeLong` (righe 78-84) | BULGE_MASTER `origLong1` (riga 841) |
|---|---|---|---|---|
| 1 | bande "fortemente gonfie" dopo esplosione | `bande_gonfie = width > width[5]` (riga 22) — **derivata** | `isBulge = bbWidth >= bbWidthMA*1.1` — **livello** | `isBulge1` idem (riga 766) |
| 2 | c'e' stato un IMPULSO | `ta.highest(high,10) >= upper[5]` — impulso **verso l'ALTO** (banda superiore) | `impulseDown` = **impulso verso il BASSO** (`low<=lower`, riga 40) | `impDown` (riga 789) idem |
| 3 | il prezzo ritraccia **DIRETTAMENTE verso la banda OPPOSTA** | `pos < 0.20` — prezzo **sulla banda INFERIORE**, cioe' l'OPPOSTA rispetto all'impulso ✅ | `not oppAfterImpDown` — la banda opposta **NON deve essere stata toccata** ❌ | `!oppAfterImpDown` (riga 843) ❌ |
| 4 | entrata sul **retest della banda opposta all'impulso** | entra LONG con prezzo alla banda inferiore dopo impulso all'insu' ✅ | entra LONG con `low <= lower` = **la STESSA banda dell'impulso** ❌ | `bullReaction1 = closes[1]>opens[1] && lows[1]<=bbLower1` ❌ |
| 5 | TP sulla mediana, SL 3xATR | `mid` + `atr*3` (righe 61-64, 87) ✅ | non gestito (indicatore) | `bbBasis` + `SL_ATR_Mult=3` ✅ |

**Il punto che chiude la questione aperta il 21/08.** I due codici partono da impulsi di
segno OPPOSTO per produrre lo STESSO trade:

- **Pine vecchio / EA — LONG** nasce da un **`impulseDown`** (candela rossa che buca la
  banda **inferiore**), e chiede che il prezzo **non** abbia toccato ne' la mediana
  (`not midAfterImpDown`) ne' la banda superiore (`not oppAfterImpDown`): il prezzo e'
  rimasto schiacciato sotto, e si compra **sulla stessa banda dell'impulso**. E' un fade.
- **v4 — LONG** nasce da un tocco della banda **SUPERIORE** (`ta.highest(high,10) >=
  upper[5]`), e pretende che il prezzo sia **arrivato fino alla banda opposta**
  (`pos < 0.20`): l'attraversamento completo che Leonardo descrive. Si compra
  **sulla banda opposta all'impulso**, con TP sulla mediana → il trade e' nella
  direzione dell'impulso = **continuazione**, come dice il nome IN-BULGE.

Le condizioni 3 e 4 sono **logicamente incompatibili** fra le due implementazioni: il
Pine vecchio ha un `not oppAfterImpDown` che **esclude** proprio l'evento che il v4
**richiede**. Non e' una sfumatura di parametro: e' il segno invertito.

> ➡️ **La triangolazione del 21/08 aveva ragione** ("l'IN-BULGE del Pine entra in fade
> sulla banda DELL'IMPULSO, non sul retest della banda opposta"). Il v4 e' la prima volta
> che quella meccanica mancante compare scritta in casa. **Non "corregge" il vecchio
> codice: e' un secondo motore, diverso.**

### ⚠️ Ma la fedelta' NON e' piena: tre regole di Leonardo mancano nel v4
Leonardo, punto 2, mette due esclusioni e una qualita'. Il v4 non ne ha nessuna:

1. **"EVITARE: prezzo che testa la mediana, torna sulla banda dell'impulso e solo dopo
   ritesta l'opposta."** Il v4 chiede solo *tocco superiore entro 10 barre* + *pos<0.20
   adesso*: qualunque percorso dentro quelle 10 barre e' ammesso, **compreso quello che
   Leonardo dice di evitare**. La macchina per escluderlo esiste gia' ed e' collaudata:
   `barsSinceMidTouch`/`barsSinceUpperTouch` del Pine vecchio (righe 48-61) e i due loop
   di BULGE_MASTER (righe 803-820).
2. **"EVITARE arrivo sull'opposta con candela direzionale dal corpo grande"** e
   **"meglio con candele piccole"**. Nel v4 non c'e' **nessun** filtro sulla candela di
   arrivo. Vedi §4: questa e' esattamente la regola che l'EA implementa come
   `candleNotImpulsive`.
3. **Punto 3 del protocollo** ("bande ristrette; deviazione standard tornata sotto la
   media a 50 periodi"): **non implementato in nessuna delle tre fonti** — vedi §6,
   domanda aperta B.

---

## 2. 🐛 CANARINO GROSSO — il v4, cosi' com'e', non stampa mai un segnale

```pine
46  var int cl = 999
48  cl := sig_long  ? 0 : cl + 1
50  long_ok  = sig_long  and cl > 5
```

Pine esegue le righe **in ordine sulla stessa barra**. Se `sig_long` e' vero, la riga 48
azzera `cl` **prima** che la riga 50 lo legga: `cl` vale 0, quindi `cl > 5` e' falso.
Se `sig_long` e' falso, `long_ok` e' falso comunque.
➡️ **`long_ok` e `short_ok` sono falsi per costruzione, su ogni barra.**
Nessuna label, nessun alert, mai.

E' lo stesso tipo di difetto del canarino del 21/08 (il BLU dell'EA con
`closes[0] > opens[0]` valutato al primo tick di barra nuova: falso per costruzione).
La forma corretta e' leggere il contatore **prima** dell'aggiornamento
(es. `long_ok = sig_long and cl[1] > 5`, oppure aggiornare `cl` dopo).

**[DA VERIFICARE con Claudio]** Se sul suo TradingView le frecce si vedono, allora la
versione incollata **non e' quella che gira** e va ripescata quella buona (regola #1).
Se non si vedono, il file e' da correggere di una riga prima di qualunque misura.
Finche' non e' chiarito, **qualunque giudizio sul rendimento del v4 e' sospeso**: non
esiste nemmeno un campione da guardare.

---

## 3. 🔍 ASIMMETRIA LONG/SHORT — e commenti che contraddicono il codice

| | commento nel file | codice reale | quanto e' selettiva |
|---|---|---|---|
| LONG | "pos < 0.35" (riga 33) | **`pos < 0.20`** (riga 36) | stretta |
| SHORT | "pos > 0.65" (riga 40) | **`pos > 0.35`** (riga 43) | larghissima |

Lo specchio di `pos < 0.20` sarebbe `pos > 0.80`. `pos > 0.35` significa "il prezzo sta
appena sopra il terzo basso delle bande" — non e' un retest della banda superiore, e'
quasi tutto il grafico.

**Stima sintetica** (simulazione GBM a volatilita' persistente, 200.000 barre — serve
solo per l'ordine di grandezza, **non sono dati di mercato**):

| soglia | % di barre che la soddisfano |
|---|---|
| `pos < 0.20` (long, codice) | 22,5% |
| `pos > 0.35` (short, codice) | **63,1%** |
| `pos > 0.80` (short, se fosse speculare) | 23,0% |

➡️ **Il lato short e' circa 2,8 volte piu' permissivo del long.** Con questa soglia lo
short **non implementa** il protocollo IN-BULGE (che vuole il *retest della banda
opposta*): fa short ovunque sopra il terzo basso, purche' la banda inferiore sia stata
toccata entro 10 barre. Il lato long e' fedele, il lato short no.

**[DA DECIDERE di Claudio]** `0.35` sullo short e' un refuso (doveva essere `0.65` come
dice il commento, o `0.80` per essere speculare) o e' una taratura voluta? La differenza
e' enorme e va dichiarata prima di misurare — non dopo, come vuole la regola di casa.

---

## 4. QUANTI SEGNALI — il v4 non e' una semplificazione di ARANCIO/BLU/VIOLA

L'EA ha tre segnali (`Use_Orange=false`, `Use_Blue=true`, `Use_Purple=true`), tutti
costruiti su `origLong1` o sul `postBulge`. Il v4 ne ha **uno solo**. La domanda era: di
quale dei tre e' la versione nuda?

**Di nessuno. E' un quarto segnale.** Motivo: ARANCIO, BLU e VIOLA condividono tutti il
`not oppAfterImp*` (o, per il VIOLA, il `midAfterImp*` + `not oppAfterImp*`) — cioe'
**tutti e tre escludono che la banda opposta sia stata toccata**. Il v4 la **pretende**.

| segnale | impulso | mediana toccata dopo | banda opposta toccata dopo | dove entra |
|---|---|---|---|---|
| ARANCIO (EA) | down | vietata | vietata | banda **dell'impulso** + `close >= meta' candela impulso` |
| BLU (EA) | down | vietata | vietata | banda **dell'impulso** + 2a candela di conferma |
| VIOLA (EA) | down | **obbligatoria** | vietata | banda **dell'impulso**, piatta, candela non impulsiva |
| **v4** | **up** (per il long) | indifferente | **obbligatoria** (`pos<0.20` = ci sta sopra adesso) | banda **OPPOSTA all'impulso** |

Le tre righe dell'EA sono tre gradi di conferma sullo stesso fade. Il v4 e' l'altra
meta' del protocollo, quella che in casa non e' mai stata codificata.

### Ricaduta sulla divergenza VIOLA rimasta aperta il 21/08
Il 21/08 restava da decidere: la candela di reazione del POST-BULGE deve essere
`close > open` (Pine vecchio, riga 107) o `|close-open| <= 1.5*ATR` (EA, riga 887)?

**Il v4 non vota: non ha nessun filtro sulla candela.** Pero' aggiunge un elemento a
favore dell'EA, e va detto come inferenza, non come fatto:
la guida di Leonardo **non contiene da nessuna parte** la richiesta di candela verde;
contiene invece, due volte, la richiesta opposta di **corpo piccolo**
(`PROTOCOLLI_LEONARDO.md` riga 9: "arrivo con candela direzionale dal corpo grande" da
evitare; riga 28-29: "retest a *tocchi*, non con candelona direzionale").
`candleNotImpulsive` e' la traduzione letterale di quella regola; `close > open` non ha
riscontro nel testo. **Resta comunque [DA DECIDERE di Claudio]** quale delle due ha
prodotto il backtest PF 1,599 / 80,22%: si decide con la passata contatore, non a
tavolino.

---

## 5. LA MISURA DEL "BULGE" — derivata contro livello

| | formula | cosa misura |
|---|---|---|
| **v4** riga 22 | `width > width[5]` | la **derivata**: le bande si stanno allargando *rispetto a 5 barre fa* |
| **Pine vecchio** riga 34 / **EA** riga 766 | `width >= SMA50(width) * 1.1` | il **livello**: le bande sono *larghe in assoluto*, +10% sopra la loro media a 50 |

Non sono versioni piu' o meno fini della stessa cosa: misurano **due grandezze diverse**.
`width > width[5]` e' vero anche dentro una compressione, purche' l'ultima manciata di
barre si sia allargata di un capello — cioe' esattamente nella "fase laterale" che
Leonardo mette **prima** dell'esplosione, non dopo.

**Stima sintetica** (stessa simulazione di §3, 199.883 barre — ordine di grandezza, **non
dati di mercato**; su serie reali con volatilita' piu' a grappoli i numeri cambiano, il
segno no):

| condizione | % barre in cui e' vera |
|---|---|
| A) `width > width[5]` (v4) | **49,9%** |
| B) `width >= 1.1 * SMA50(width)` (EA) | 36,1% |
| A vera **mentre B e' falsa** ("bulge finto") | **24,1%** |
| B vera mentre A e' falsa (bande larghe ma in contrazione) | 10,3% |
| A e B concordi | 65,5% |

➡️ **Il cancello del v4 e' ~1,4x piu' permissivo, e su ~1 barra su 4 apre dove l'EA
tiene chiuso.** Il 49,9% non e' un caso: la differenza prima-dopo di una serie e' vicina
a una monetina, quindi `bande_gonfie` da sola **non filtra quasi niente**. La `SMA50`
e' un cancello vero; `width[5]` e' quasi rumore.

Nota: le altre condizioni del v4 restringono comunque (il tocco entro 10 barre + `pos`),
quindi il numero di segnali finale non e' il 50% delle barre. Ma il *cancello di bulge*,
che nel protocollo di Leonardo e' il cuore ("bande **fortemente** gonfie"), nel v4 e'
di fatto disattivato.

---

## 6. COSA NON C'E' NEL v4 — dichiarazioni, non accuse

- **Nessun filtro ADX.** v3/v3_PARALLEL_KILL e BULGE_MASTER hanno
  `Use_ADX_Filter=true`, soglia 30, applicato ai BLU (`ADX_Apply_On_Blue=true`) come
  anti-bandriding (`Analisi_EA_BULGE.md`, riga 19). Nel v4 non c'e'. **Va registrato come
  assenza, non come difetto**: una versione "nuda" del protocollo e' legittima e anzi e'
  la base giusta per un A/B (feature dietro input, default neutro — regola di casa).
  Da notare pero' che il rischio bandriding e' **strutturalmente diverso** qui: il v4
  entra *dopo* un attraversamento completo, non su un fade contro un trend che spinge.
  Se serva davvero l'ADX su questo motore e' una domanda **da misurare**, non da dedurre.
- **Nessun risk management.** Nessun kill switch, nessun rischio %, nessun cap
  giornaliero, nessun multi-simbolo, nessun break-even, nessun trailing.
  **Coerente con l'oggetto**: e' un `indicator`, non una `strategy` — non ha ne'
  posizioni ne' equity da gestire. Non e' un'omissione, e' la natura del file.
  (Per confronto: il Manager MQ4 con cui Claudio operava a mano aveva BE a 1R e
  trailing a gradini di R — vedi Parte 2 della triangolazione del 21/08.)
- **Nessun filtro news, nessun filtro ATR** (l'EA ha `Use_ATR_Filter` con banda
  0,5x-1,8x sulla media).
- **SL disegnato da `low`, non dall'entry.** Righe 61 e 71: la linea rossa e'
  `low - atr*3` (long) e `high + atr*3` (short); l'EA usa entry ± ATR*3. Su una candela
  lunga la differenza vale una frazione di ATR. Cosmetico finche' e' un indicatore,
  **da decidere** se il v4 diventasse un EA.
- **Finestra di 10 barre** contro `Lookback_Bars=20` dell'EA (e 40 per il VIOLA).
- **Nessuna delle due esclusioni di percorso di Leonardo** (§1, punto ⚠️).

### Dettaglio tecnico che va segnalato: il confronto sfasato di riga 35
```pine
35  and ta.highest(high, 10) >= upper[5]
```
`ta.highest(high,10)` guarda le barre 0..9; `upper[5]` e' il valore della banda **5 barre
fa**. Il massimo puo' quindi essere confrontato con una banda di un istante **diverso da
quando quel massimo e' avvenuto** — e con le bande in espansione `upper[5]` e' piu'
**basso** della banda attuale, quindi il test e' **piu' facile** da superare di un vero
"tocco della banda superiore". Il Pine vecchio e l'EA fanno la cosa esatta
(`ta.barssince(high >= upper)` / il loop `highs[k] >= bbUSeries[k]`, riga 790: ogni barra
confrontata con la **sua** banda). **Se il v4 va portato in MQL5, questa e' la prima
cosa da rifare bene**, altrimenti il conteggio dei segnali non e' riproducibile.

---

## 7. RIEPILOGO: dove si colloca il v4 nella famiglia

| | Pine vecchio (12/08) | famiglia EA v1→v3_KILL / BULGE_MASTER | **v4 (28/08)** |
|---|---|---|---|
| meccanica | fade sulla **banda dell'impulso** | idem | **retest della banda OPPOSTA** |
| corrisponde a Leonardo | POST-BULGE (e "IN-BULGE" mal etichettato) | idem | **IN-BULGE** (lato long) |
| segnali | 2 (IN + POST) | 3 (ARANCIO/BLU/VIOLA) | 1 |
| bulge | livello, SMA50 x1,1 | livello, SMA50 x1,1 | **derivata, width[5]** |
| lookback impulso | 20 / 40 | 20 / 40 | 10 |
| esclusioni di percorso | si (mid / opposta) | si | **nessuna** |
| filtro candela | `close > open` | `\|c-o\| <= 1.5 ATR` (VIOLA) | nessuno |
| ADX | no | si (BLU) | no |
| SL / TP | — | 3xATR / mediana dinamica | 3xATR / mediana (solo disegnati) |
| stato | fonte di verita' storica | in forward/misura | **non eseguibile: bug riga 50** |

**Non e' la versione fedele di un protocollo che il codice implementava male: e' il
protocollo GEMELLO, quello che il codice non implementava affatto.** I due motori
possono convivere — e anzi, essendo IN-BULGE (continuazione) e POST-BULGE (inversione)
meccaniche opposte, sono candidati naturali alla **scorrelazione**, che e' la leva vera
per fare piu' profitto (piu' strategie scorrelate, non piu' filtri).

---

## 8. DOMANDE APERTE PER CLAUDIO (in ordine di urgenza)

1. 🐛 **Il v4 che gira sul tuo TradingView ti disegna le frecce?** Se si', il file
   incollato non e' quello vivo → serve la copia buona. Se no, e' il bug di riga 50.
   *Finche' non e' risolto, non esiste nessun segnale da misurare.*
2. ⚖️ **`pos > 0.35` sullo short: refuso o voluto?** Il commento dice `0.65`, lo
   speculare del long sarebbe `0.80`. Il lato short cosi' com'e' **non fa IN-BULGE**.
3. 🎯 **Vuoi che il v4 diventi il secondo motore Bulge** (IN-BULGE, continuazione)
   accanto alla famiglia esistente (POST-BULGE, fade), o e' uno studio a schermo?
4. 📏 **La misura del bulge la teniamo o la allineiamo?** Proposta: **non scegliere a
   tavolino** — un solo `input` che seleziona `derivata` / `livello SMA50 x1,1`, default
   sul **livello** (quello gia' validato nella famiglia), e A/B a parita' di tutto il
   resto. Metrica attesa da guardare: **numero di trade** (dovrebbe crollare col livello)
   e **profit factor**.
5. 🚧 **Le due esclusioni di percorso di Leonardo** (niente mediana→ritorno→opposta;
   niente candelona in arrivo sull'opposta) le portiamo nel v4? La macchina esiste gia'
   in BULGE_MASTER. **Una alla volta, dietro input, default spento.**
6. ❓ **Punto 3 del protocollo, mai implementato da nessuno dei tre codici:**
   "bande ristrette (StdDev + media mobile); deviazione standard tornata **sotto** la
   media a 50 periodi". Va letto come (a) descrizione della **fase laterale precedente**
   all'esplosione, o (b) condizione **al momento dell'entrata** (StdDev gia' rientrata
   sotto la sua media a 50)? Sono due filtri completamente diversi, e (b) e' l'**opposto**
   dell'`isBulge` dell'EA. **Da chiedere a Leonardo, non da indovinare.**
7. 🔵 **Resta aperta dal 21/08**: `close > open` (Pine) o `candleNotImpulsive` (EA) sul
   VIOLA? Il v4 non decide. Si chiude con la passata contatore
   `[BULGE-CONTA] BLU=x VIOLA=y ARANCIO=z`, gia' scritta nell'EA.

---

## 9. PROPOSTA SEPARATA (NON fa parte del confronto — default SPENTO)

> Sezione tenuta a parte apposta: il compito di oggi era la fedelta', non lo sviluppo.
> Niente e' stato scritto in codice. Qui c'e' solo il progetto, per quando Claudio dira'.

**Se** si decide di portare l'IN-BULGE vero in MQL5, la strada meno rischiosa **non** e'
un EA nuovo: e' un **quarto segnale dentro BULGE_MASTER**, dietro
`input bool Use_Green = false;` (default che **non cambia** il comportamento attuale,
cosi' l'A/B e' pulito). Riuserebbe pezzi gia' collaudati e misurati:

- `barsSinceImpUp` / `barsSinceImpDown` (loop righe 784-795) — impulso **fatto bene**,
  ogni barra contro la **sua** banda, con corpo >= 0,2xATR: risolve da solo lo sfasamento
  di `upper[5]` (§6).
- `oppAfterImpUp` (riga 818) — che qui va usato **richiesto**, non negato: e' la
  differenza di segno di tutto il documento.
- `midAfterImp*` per l'esclusione di percorso di Leonardo, dietro un secondo input.
- `candleNotImpulsive` (riga 887) per "niente candelona in arrivo sull'opposta".
- `isBulge1` (SMA50 x1,1) come cancello di bulge, con l'A/B della domanda 4.
- SL/TP/gestione/kill switch: **gia' tutti li'**, zero righe nuove.

Il vantaggio pratico e' che il segnale nuovo eredita in blocco tutto il risk management
(rischio 0,5%, cap, kill switch) invece di ricostruirlo — ed e' isolabile col contatore
per simbolo, come si e' fatto per BLU/VIOLA.

**Prima di scrivere una riga servono le risposte 1, 2 e 3.**

---

## CAVEAT — cosa e' fatto e cosa e' inferenza
- ✅ **FATTO (verificabile nel sorgente):** le tabelle di §1, §4, §7; il bug di riga 50;
  l'asimmetria `0.20`/`0.35`; lo sfasamento di `upper[5]`; le assenze di §6.
- 📐 **STIMA SINTETICA, non dati di mercato:** tutte le percentuali di §3 e §5 vengono da
  una simulazione GBM a volatilita' persistente (200.000 barre). Servono per l'**ordine
  di grandezza e il segno**, non come numeri di backtest. Su serie reali (grappoli di
  volatilita', gap, sessioni) cambiano. **Non usarle per tarare niente.**
- ❓ **INFERENZA:** che `candleNotImpulsive` sia piu' fedele a Leonardo di `close > open`
  (§4) e' una lettura del testo della guida, non una misura. La misura e' il backtest.
- 🚫 **NESSUN GIUDIZIO DI RENDIMENTO sul v4.** Non e' stato ne' compilato ne' testato — e
  col bug di riga 50 non produce nemmeno un segnale da contare. Nessuna delle differenze
  qui elencate e' stata dimostrata "migliore": sono differenze **misurabili**, e si
  misurano una alla volta.
