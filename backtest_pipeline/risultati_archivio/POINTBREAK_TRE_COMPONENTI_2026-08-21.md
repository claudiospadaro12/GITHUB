# 🧩 POINT BREAK — LE TRE COMPONENTI SUPERSTITI, PORTATE ALLO STADIO DECIDIBILE

**Data:** 21/08/2026 · **Mandato:** _"1,2,3 si guardano"_ (Claudio, in chat) — il
punto 3 erano le tre proposte superstiti del Point Break.
**Consegna:** ogni proposta esce da qui con **uno stato**, non con un'opinione.

> 🔒 **IL VERDETTO DEL 18/08 NON SI TOCCA.**
> _"Point Break NON e' testabile come STRATEGIA"_ — 9 pattern grafici, zero
> definizioni numeriche. Qui **non si riapre la strategia**: si guardano **tre
> COMPONENTI** che potrebbero valere da sole, staccate dal metodo che le ospita.
> Se una di esse richiedesse di ricostruire il motore Point Break, sarebbe
> **fuori mandato per definizione** — ed e' esattamente quello che succede alla
> n° 2 (§3).

---

## 📊 IL VERDETTO IN UNA TABELLA

| | proposta | STATO | cosa serve |
|---|---|---|---|
| 🥇 | **P-PB1** — pavimento di volatilita' sullo stop | 🟡 **BLOCCATA, ma il blocco e' ORA MISURABILE** — lo strumento e' scritto e pronto | 10 minuti di MT5 sul PC di backtest (`ABTG_SondaADR`), poi la risposta arriva dai numeri. La domanda a Claudio resta, ma **potrebbe non servire piu'** |
| 🥈 | **P-PB2** — il filtro "EMA200 lontana ≥100 pip" | 🔴 **ARCHIVIATA** — la contraddizione **non esiste**: e' un artefatto di due letture su motori, mercati e timeframe diversi. **Il round non serve** | niente. Serve solo la presa d'atto di Claudio + la correzione agli atti (richiesta 3) |
| 🥉 | **P-PB3** — Bollinger (37 · 1.4) come cella | ✅ **FIRMATA (21/08) E PRONTA AL LANCIO** come **R94** — resta una sonda di **FREQUENZA**: il merito e' sospeso dal campione | niente: riga di lancio pronta in `righe/RIGA_R94_BB37.md`. Il rischio 1,0% e' un'**assunzione dichiarata**, non una firma |

---

# 📮 LE RICHIESTE A CLAUDIO — corte e secche

> **1. 📏 [P-PB1 · sblocca tutto] Il nome e il file dell'indicatore "Volatilita'
> Media Giornaliera · ImpPeriods: 50"**, o in alternativa **uno screenshot del
> suo pannello parametri** (Proprieta' → Parametri di input). Il nome del file
> `.ex4/.ex5` basta.
> ⚠️ **Ma prima di chiederlo a Christian, guarda la richiesta 2**: potremmo non
> averne piu' bisogno.

> **2. ▶️ [P-PB1 · 10 minuti di macchina] Il via a far girare
> `mql5\Scripts\ABTG_SondaADR.mq5`** sul PC di backtest, dopo R92 e senza
> intralciare la coda. Non apre posizioni, non tocca nessuna sedia: legge lo
> storico D1 e stampa. **Puo' chiudere da solo la richiesta 1**, perche' prova a
> riprodurre le due letture stampate sulle slide (AUDUSD 57.02 · GBPUSD 83.73).

> **3. ✅ [P-PB2 · presa d'atto] Accetti l'archiviazione**, e vuoi che la
> correzione venga scritta **dentro** i due file che oggi portano la frase
> imprecisa? Sono `ANALISI_POINTBREAK_2026-08-18.md` (righe 287-288 e 893-898) e
> `report/STATO_QUATTRO_STRATEGIE_2026-08-21.md` (scheda 4).
> 🔒 **Non ho toccato nessuno dei due**: correggere un'analisi gia' agli atti e'
> una decisione tua, non mia.

> **4. ✅ [P-PB3] FATTA — Claudio ha firmato il 21/08: _"r94 lancia"_.**
> Criteri firmati, 6 file prova, driver e **riga di lancio pronti**
> (`righe/RIGA_R94_BB37.md`, due blocchi: giro a vuoto e corsa).
> ⚠️ **Resta una cosa sola da sapere, non da fare:** il **rischio 1,0%** non e'
> stato firmato — e' un'**assunzione dichiarata** e verificata nel sorgente
> (non cambia il conteggio operazioni). Ribaltabile con una parola.

> **5. 🕐 [contorno, non blocca] Il nome del server MT5 di Christian.**
> Serve alla taratura della richiesta 2 (broker diverso = numeri diversi) **e**
> risponde alla domanda 1 del dossier del 18/08 (il fuso del PIANO DI TRADING),
> che oggi e' bloccante per qualunque uso degli orari del corso.

---

# 1. 🥇 P-PB1 — IL PAVIMENTO DI VOLATILITA' SULLO STOP

## 1.1 Cosa dice la fonte, alla lettera

Estratto oggi dal PDF `POINT BREAK - PIANO DI TRADING.pdf`, **slide 20** — il
numero e' stampato in basso a destra sulla pagina, verificato sull'immagine:

> **2.** _"Lo stop verra' determinato dalle candele precedenti e verra'
> posizionato **10/15 pip sopra la spike piu' alta** o sopra il massimo raggiunto
> dal prezzo"_
> **3.** _"Avendo a disposizione sul nostro grafico l'indicatore della
> **volatilita' media del prezzo**, **se il nostro stop e' inferiore in termini
> di pip** (seguendo il punto 2), allora utilizzeremo il dato fornito
> dall'indi**o**catore e aggiungeremo **10/15 pip**"_ `[T]`

Cioe': `SL = max( spike ± 10/15 pip , ADR(50) + 10/15 pip )`. La proposta era
letta bene.

## 1.2 🔬 DUE FATTI NUOVI, letti oggi dalle IMMAGINI delle slide (non dal testo)

Le due letture dell'indicatore stavano nelle figure e non nel livello testo:
le ho rese leggibili con `pdftoppm -r 200` e guardate.

| | slide 4 | slide 20 |
|---|---|---|
| simbolo | **AUDUSD** | **GBPUSD** |
| **timeframe del grafico** | 🔴 **H12** | **Daily** |
| lettura dell'indicatore | **57.02 pips** | **83.73 pips** |
| ultimo prezzo a schermo | 0.65157 | 1.35407 |
| periodo a schermo | 4 Ott 2024 → ~meta' giugno 2025 | 14 Apr 2024 → ~meta' giugno 2025 |

> ### 🎯 FATTO NUOVO n°1 — l'indicatore stampa **57 pip su un grafico H12**.
> Se calcolasse i range **delle barre del grafico**, su H12 leggerebbe mezze
> giornate: un numero **sensibilmente piu' basso** del range giornaliero di
> AUDUSD in quel periodo. Che stampi un valore da giornata intera su un grafico
> a mezza giornata e' un **indizio forte** `[INFERITO]` che l'indicatore legge
> **barre D1 a prescindere dal timeframe del grafico** — coerente col suo nome,
> "Volatilita' Media **Giornaliera**".
> ➡️ **Questo taglia via da solo il ramo di ambiguita' piu' grosso** (la
> variante V6 dello strumento del §1.4). Ma resta un indizio finche' un numero
> non lo conferma.

> ### 🎯 FATTO NUOVO n°2 — nell'unico esempio operativo che il corso mostra, **il pavimento NON morde**.
> Sulla slide dello STOP LOSS c'e' un'operazione vera: `SELL 1 at 1.34970` con
> la linea `SL` tracciata a **~1.3653/1.3660** = **156-163 pip di stop**
> `[LETTO DALL'IMMAGINE, ±10 pip di tolleranza di lettura]`, contro un ADR di
> **83.73**. Lo stop viene dal **punto 2** (la spike), ed e' quasi **il doppio**
> del pavimento.
> ➡️ **Conseguenza pratica, dichiarata prima di misurare:** il pavimento agisce
> solo su un **sottoinsieme** dei trade (quelli con lo stop stretto). Quanto sia
> grande quel sottoinsieme e' a sua volta misurabile — ma **dopo**, e solo se la
> componente sopravvive.

## 1.3 ⚠️ COSA NON HO POTUTO MISURARE, e perche' (nessuna scusa, i fatti)

Il mandato chiedeva di **pesare l'ambiguita'**. Non l'ho potuta pesare **qui**:

- ❌ **niente MT5** in questo ambiente (regola nota);
- ❌ **niente storico prezzi** nel repo: nessun OHLC giornaliero di AUDUSD/GBPUSD
  (i CSV in archivio sono **risultati** di backtest, non serie di prezzo);
- ❌ **niente dati da fuori**: ho provato `stooq`, `yahoo`, `dukascopy`,
  `frankfurter` — il proxy risponde **403** a tutti (solo `github` passa).

**Quindi ho fatto l'unica cosa onesta: ho scritto lo strumento che la misura**,
invece di stimare a occhio e chiamarla misura.

### L'unico numero che si puo' dare a tavolino — ed e' etichettato per quello che e'
🧮 **[ARITMETICA SU UN'ASSUNZIONE, NON MISURA]** Sul forex BCM il mercato
**riapre la domenica sera** (fatto agli atti: la famiglia GAP debutta *"alla
riapertura di domenica sera"*, `DIARIO.md`). Se esiste una barra D1 della
domenica, in 50 barre ce ne sono **~8,3**, e valgono un paio d'ore di mercato
sottile. Assumendo il loro range al **15%** di una giornata vera:

```
media CON domeniche  = (41,7 x D + 8,3 x 0,15 D) / 50 = 0,859 x D
media SENZA domeniche = D
```

➡️ **~14% di differenza. Su un ADR di 83,73 pip fanno ~12 pip: quanto TUTTO il
buffer che il corso concede (10/15).** Un solo ramo di ambiguita' vale l'intera
discrezionalita' della regola. **L'assunzione del 15% e' mia e va misurata** —
lo strumento conta le domeniche e stampa V1 contro V3 proprio per questo.

## 1.4 🛠️ LO STRUMENTO — `mql5\Scripts\ABTG_SondaADR.mq5` (scritto, mai compilato)

Uno **script** (non un EA): si trascina su un grafico, non apre posizioni, non
tocca nessuna sedia in forward. Stampa nella scheda Esperti e scrive
`MQL5\Files\ABTG_SondaADR.csv`.

Mette a confronto **sette definizioni tutte legittime** dello stesso ADR(50):

| | definizione | perche' e' li' |
|---|---|---|
| **V1** | media(High−Low) su 50 D1 chiuse | la piu' comune |
| **V2** | media(True Range) su 50 D1 | include i gap |
| **V3** | come V1 **senza le barre della domenica** | il ramo del §1.3 |
| **V4** | **mediana**(High−Low) su 50 D1 | robusta agli spike |
| **V5** | **ATR(50) di Wilder** su D1 | media smorzata |
| **V6** | media(H−L) su 50 barre **del TF del grafico** | il ramo che il FATTO n°1 rende improbabile — si verifica, non si assume |
| **V7** | come V1 ma **con la barra di oggi** in formazione | scelta d'implementazione plausibile |
| _(V8)_ | media(H−L) su **20** D1 | ⚠️ **fuori forchetta**: e' un PERIODO diverso, non una definizione diversa. Sta li' solo come scala |

**Cosa stampa:**
1. la **fotografia di oggi** per ogni simbolo, con il pavimento `V + buffer`;
2. la **forchetta** (max−min fra le sei definizioni alternative) **giorno per
   giorno su 500 giorni**: mediana, 90° percentile, peggior giorno, e la
   percentuale di giorni oltre 5 / 10 / 15 pip;
3. la **TARATURA**: cerca all'indietro se e in che giorno una definizione
   riproduce **57.02** (AUDUSD) e **83.73** (GBPUSD), tolleranza 0,05 pip.

### 📐 IL CRITERIO DI LETTURA — dichiarato **PRIMA** dei numeri (BOZZA, va firmata)
Il corso si concede gia' **5 pip di discrezionalita'** da solo ("10/15 pip"):
quello e' il metro naturale.

| esito | soglia | conseguenza |
|---|---|---|
| 🟢 **NON blocca piu'** | forchetta mediana **< 5 pip** e p90 **< 10 pip** | l'ambiguita' pesa **meno** della discrezionalita' del corso: si **DICHIARA** la definizione (V1) e si va avanti **senza chiedere niente a nessuno** |
| 🟡 **zona grigia** | in mezzo | si procede solo **dichiarando** la definizione come assunzione nostra e mettendo le due piu' distanti in **A/B** |
| 🔴 **resta bloccante** | p90 **> 15 pip** | l'ambiguita' vale **piu' dell'intero buffer**: si aspetta la risposta di Christian |

E la **taratura** puo' scavalcare tutto: se **una sola** definizione riproduce
**entrambe** le letture (due simboli, due timeframe diversi), la domanda 4 del
dossier del 18/08 e' **risposta da una misura**, non da una mail.
⚠️ **Il contrario non vale**: se nessuna riproduce i numeri, non e' una
smentita — il dato e' del broker di Christian, non BCM. Sta scritto anche
dentro lo script.

## 1.5 📌 STATO E PROSSIMO PASSO
🟡 **BLOCCATA — ma il blocco e' diventato misurabile.** Nessun round, nessun
`.mqh`, nessuna riga di codice negli EA: prima si sa **quanto pesa**, poi
semmai si costruisce. Prossimo passo = **richiesta 2** (10 minuti di MT5).

---

# 2. 🥈 P-PB2 — LA "CONTRADDIZIONE" CHE NON C'E'

> ## 🔴 ESITO: **ARCHIVIATA. Il round non serve.**
> E il mandato lo prevedeva esplicitamente: _"verifica se sono davvero in
> contraddizione **o se parlano di mercati/timeframe diversi** (se e' cosi', non
> c'e' nessuna contraddizione e il round non serve: dillo e chiudi)"_.
> **E' cosi'. Chiudo.** Sotto ci sono le tre prove, riga di codice contro
> citazione.

## 2.1 Le due letture, testuali

**Il corso (Point Break, Christian Bertacchi)** — checklist d'ingresso, punto 4:
> _"**La media esponenziale 200 deve essere distante almeno 100 pip** dal nostro
> punto d'ingresso"_ `[T]`

E' un **cancello d'ingresso**: si entra **solo se** la media e' lontana → *stare
vicino alla EMA200 = non si opera*. (La frase "condizione di NON ingresso" che
gira nei nostri appunti dice la stessa cosa al rovescio — non e' li' l'errore.)

**Il nostro `ABTG_EMA200`** — `mql5/Experts/ABTG_EMA200.mq5`, righe 55-56:
```
input double InpMinDistAtr  = 0.3;   // prezzo non gia' sulla media (dist. minima)
input double InpMaxDistAtr  = 1.5;   // prezzo abbastanza vicino (dist. massima; guida ~50/70 pip)
```
E' una **finestra di prossimita'**: si entra solo se il prezzo e' **vicino**
alla media (e non gia' incollato). Sembra l'opposto esatto. **Non lo e'**, per
tre motivi indipendenti — e ne basterebbe uno.

## 2.2 🥇 PROVA 1 — le due letture convivono **DENTRO LO STESSO CORSO**, senza contraddirsi

Questa e' la prova che chiude la questione, e stava gia' in casa:
`backtest_pipeline/prove/MEDIA200_CORSO_SPEC.md` §11-12, dal modulo **Media 200
di Paolo** (lezioni 21-24) — **lo stesso corso, un altro relatore**:

| voce | numero del corso |
|---|---|
| distanza operativa prezzo → EMA200 | **50-70 pip** |
| test-case AUDCAD | distanza **51 pip** → ✅ **accettato** |
| test-case AUDCHF | distanza **12 pip** → ❌ **scartato (troppo vicino)** |

E il verdetto gia' agli atti in quel file: _"**Verdetto: non "somiglia". E' LO
STESSO MOTORE**"_ — il nostro `ABTG_EMA200` **e' il porting del modulo di
Paolo**, i commenti del sorgente ne citano i numeri (`"guida ~50/70 pip"`,
`"guida ~5 pip"`, `"guida ~15 pip"`).

> 🎯 **Quindi: il corso prescrive contemporaneamente "vicino 50-70 pip" (Paolo,
> rimbalzo sulla media) e "lontano ≥100 pip" (Christian, inversione
> sull'estremo) — e non si contraddice**, perche' sono **due strategie
> diverse**: una entra *sulla* media nel verso del trend, l'altra entra
> *lontano* dalla media contro l'ultimo movimento. Il nostro EA non e'
> "l'opposto del corso": **e' un pezzo del corso**, quello di Paolo.
> La frase _"le due letture non possono essere entrambe giuste"_ **e' falsa**:
> possono, e nel corso lo sono gia'.

## 2.3 🥈 PROVA 2 — non e' lo stesso mercato, e non e' nemmeno la stessa RIGA

| | corso Point Break | sedia 12 (il 30/30 di R29) |
|---|---|---|
| mercato | **forex** (AUDUSD, GBPUSD) | 🔴 **U30USD — il Dow, un INDICE** |
| timeframe | **H12** (slide 4) e **D1** (slide 20) | 🔴 **H1** (titolo di `REFERTO_ROUND29_EMA200_WF.md`: _"walk-forward EMA200 **H1**"_) |
| che linea e' la "EMA200" | 200 giorni (D1) / 100 giorni (H12) | 🔴 **200 ore ≈ 8 giorni di mercato** |
| unita' della soglia | **pip** | **punti indice**: "100 pip" sul Dow **non e' definito** |

> **Non e' un dettaglio da pignoli: l'EMA200 su D1 e l'EMA200 su H1 sono DUE
> LINEE DIVERSE**, calcolate su orizzonti che differiscono di ~24 volte.
> Chiamarle con lo stesso nome e concluderne una contraddizione e' un errore di
> confronto, non una scoperta.
>
> Le altre 5 sedie EMA200 in flotta (`771511-15`: 200AUD, AUDJPY, GBPJPY,
> SPXUSD, GBPUSD short) girano su **H4** → EMA200 ≈ **33 giorni**. Nemmeno
> quelle guardano la linea del corso.

## 2.4 🥉 PROVA 3 — e comunque il round sarebbe **degenere o fuori mandato**

Provo a costruirlo lo stesso, per vedere se regge. Ci sono due sole strade e
**muoiono tutte e due**:

1. **Filtro ≥100 pip sulla EMA200 dello STESSO TF del motore** (H1 per la sedia
   12): la finestra operativa del nostro EA e' `0,3-1,5 × ATR` da quella stessa
   linea. Il filtro non sarebbe un **asse**, sarebbe un **interruttore**:
   spegnerebbe per costruzione quasi tutti gli ingressi. **Misurare "il motore
   spento" non e' un round, e' una tautologia.**
2. **Filtro ≥100 pip sulla EMA200 di D1** (linea diversa, quindi asse vero e non
   degenere): ma sul Dow **i pip non esistono** → andrebbe riscritto in ATR →
   🔴 **e a quel punto non e' piu' la regola del corso, e' una regola nostra con
   l'etichetta del corso** — precisamente l'errore che il metodo di casa vieta
   e che ha gia' motivato il verdetto del 18/08.
3. Testarlo sul suo motore naturale (il Point Break) richiederebbe **il motore
   Point Break**, che non esiste: `ABTG_PointBreak.mq5` si dichiara infedele nel
   proprio header, **non risulta mai compilato**, e ricostruirlo significa
   **riaprire la strategia** → **fuori mandato**.

📎 Nota d'archivio: quell'EA, alla riga 168, implementa la regola cosi':
`if(MathAbs(close1-ema[0]) < InpEma200DistAtr*atr) return;` con
`InpEma200DistAtr = 1.5` e il commento `// doc: ~100 pip`. Cioe' **i 100 pip
fissi del corso erano gia' stati tradotti in 1,5 × ATR da noi**: la conversione
"nostra" era gia' li' dentro, mai dichiarata come assunzione. Sul GBPUSD D1 di
quelle slide 1,5 × ATR ≈ 125 pip contro i 100 dichiarati — **stesso ordine di
grandezza, non lo stesso numero.**

## 2.5 📌 ESITO E CORREZIONE AGLI ATTI

🔴 **ARCHIVIATA.** Nessun file prova, nessun R__ , nessun criterio: **avrebbero
misurato un artefatto.**

E resta una cosa da sistemare, che **non ho fatto io** (richiesta 3): due file
agli atti portano la frase _"e' l'esatto opposto del nostro `ABTG_EMA200`"_ e
_"le due letture non possono essere entrambe giuste sullo stesso mercato e
timeframe"_ — `ANALISI_POINTBREAK_2026-08-18.md:287-288, 893-898` e
`report/STATO_QUATTRO_STRATEGIE_2026-08-21.md` scheda 4. Con quanto sopra,
**quelle due righe sono imprecise**: non "sullo stesso mercato e timeframe",
perche' mercato e timeframe **non sono gli stessi**.

> 💡 **La lezione vera, e vale piu' del round mancato:** l'analisi del 18/08
> aveva confrontato una regola del corso col NOME di un nostro EA invece che con
> il suo CODICE e il suo MERCATO. Il controllo che l'ha smontata e' costato
> venti minuti di lettura. **Prima di dichiarare una contraddizione: stabilire
> se i due numeri misurano lo stesso oggetto** — e' la gemella della regola
> _"prima di dire che un EA e' in ritardo, stabilire in quale ora e' scritto il
> numero"_ (06/08, imparata sbagliando).

---

# 3. 🥉 P-PB3 — BOLLINGER (37 · 1.4) NELLA FAMIGLIA BREAKING BAND

## 3.1 E' innestabile? ✅ **Si', tecnicamente e' banale**

`mql5/Experts/ABTG_BreakingBand.mq5`, righe 216-217:
```
input int    InpBBPeriod       = 20;    // Bollinger: periodo (guida: 20)
input double InpBBDev          = 2.0;   // Bollinger: deviazioni standard (guida: 2)
```
Sono **input dalla v1.00**: nessuna modifica al sorgente, nessuna
ricompilazione obbligatoria, la cella si scrive nel file prova e basta. Il
formato dei round della famiglia (R91) e' identico.

## 3.2 Ma vale qualcosa? Le tre cose scomode, dette prima dei numeri

**(a) 🧬 Si trapianta un parametro SENZA la sua tesi.** Il 37/1.4 nasce su
mean-reversion **fuori** dalle bande, su **D1/H12**. Il Breaking Band fa
bulge → ritracciamento → tocco/retest, su **H1**. La regola di casa e'
_"si raccoglie la MECCANICA e la TESI, mai il risultato"_: qui passa la
meccanica, **non la tesi**.

**(b) 🔢 Il campione non consente un giudizio di merito.** Base R34, tick reali:

| sedia | pattern | n IS | n OOS |
|---|---|---:|---:|
| GBPUSD | CONT+INV | 13 | 26 |
| EURUSD | solo CONT | **4** | 13 |
| AUDUSD | solo INV | **5** | 11 |

L'Emendamento chiede **≥150 operazioni**; R91 aveva gia' scritto _"n < 30 → il
MERITO e' SOSPESO"_. **Nessuna cella di R94 puo' essere promossa**, qualunque
numero faccia.

**(c) 🎣 Senza vincolo, 12 combinazioni su questo campione sono PESCA.** E' la
"cella verde per caso" che la Regola della Seconda Caccia indica come quella che
brucia la challenge.

## 3.3 🎯 Il vincolo che rende il round onesto

> **La domanda di R94 non e' "quale cella rende di piu'". E' "la geometria
> 37/1.4 produce piu' OPERAZIONI?"**

Meccanismo leggibile **prima** di misurare: deviazione **1.4** = bande piu'
strette = **piu' tocchi e piu' retest**, e il tocco della banda e' l'innesco di
entrambi i pattern. Se il conteggio sale, la famiglia guadagna il **campione
leggibile che oggi non ha** — un risultato piu' utile del profitto di 26 trade.
**Se non sale, la cella si archivia senza nemmeno aprire la colonna Profit.**

📎 Contesto di famiglia che va detto: `BREAKING_BAND_TESI.md` (righe 15 e 41) —
il corso Bollinger di casa prescrive **BB(37, dev 3) sugli INDICI** e
**BB(20, dev 2) sulle VALUTE**. Quindi **il periodo 37 non e' estraneo alla
famiglia; la deviazione 1.4 si'.** Per questo il disegno e' un **fattoriale
2×2** (20/37 × 1.4/2.0): senza le celle miste un eventuale effetto non sarebbe
attribuibile.

## 3.4 📦 COSA HO PREPARATO (pronto, non lanciato)

| file | cosa contiene |
|---|---|
| `backtest_pipeline/prove/R94a_bb_GBPUSD_p20.txt` + `_p37.txt` | patt. 2 (CONT+INV) — il **p20** porta il canarino |
| `backtest_pipeline/prove/R94b_bb_EURUSD_p20.txt` + `_p37.txt` | patt. 0 (solo CONT) — effetto puro su un pattern |
| `backtest_pipeline/prove/R94c_bb_AUDUSD_p20.txt` + `_p37.txt` | patt. 1 (solo INV) — **la sorella che conta di piu'**: l'inversione entra sul retest della banda |
| `backtest_pipeline/risultati_archivio/R94_CRITERI.md` | criteri — ✅ **FIRMATI da Claudio il 21/08** |
| `backtest_pipeline/lancia_r94.ps1` | driver del round (marcatore `R94-LANCIO-v1`) |
| `backtest_pipeline/righe/RIGA_R94_BB37.md` | la **riga di lancio**, due blocchi |

> 🔁 **Aggiornamento del 21/08, dopo la firma:** il disegno e' passato da 3 file
> con due assi a **6 file con un asse ciascuno**, perche' `controlla_prova.py` ha
> bocciato i due assi (*"un file prova misura UNA variabile alla volta"*).
> **Le celle misurate sono le stesse: 12 celle, 24 passate, stesso 2×2, stesse
> soglie.** E' cambiata la forma dell'artefatto, non la misura — il dettaglio sta
> nella nota tecnica in fondo a `R94_CRITERI.md`.

**24 passate in tutto.** Ogni file porta: canarino (la cella 20/2.0 **deve**
riprodurre R34 al centesimo), soglie di frequenza per simbolo decise prima,
cancello di rischio che **non** si sospende col campione piccolo, e l'elenco di
cosa **non** si tocca (`InpStdPeriod`, `InpStdSmaPeriod`, `InpRetestBufferATR`,
e **le sedie vive in campo**).

**Perche' R94 e non R93:** R93 e' gia' prenotato dal
`DOSSIER_NEWS_FILTER_2026-08-21.md` per il filtro news del FiboH4. Verificato:
nessun altro file nel repo usa R94.

## 3.5 📌 STATO
✅ **FIRMATA E PRONTA AL LANCIO.** Claudio ha firmato il 21/08:
*"metro,frequenza, firmo r93, **r94 lancia**, e prepara jpy"* — a numeri mai visti.
Resta una **sonda di frequenza**: il merito e' sospeso per dichiarazione, e
**se la frequenza non sale il profitto non si guarda nemmeno**.
⚠️ Il **rischio (1,0%)** non e' stato firmato: e' un'**assunzione dichiarata**,
verificata nel sorgente come **non influente sul conteggio operazioni**
(Guardian fail-open nel tester, nessun kill switch giornaliero). Claudio puo'
ribaltarla con una parola; in quel caso la base R34 va rimisurata.

---

# 4. 🧾 COSA NON HO FATTO — dichiarato, per non farlo scoprire dopo

- ❌ **Non ho compilato e non ho backtestato niente**: MT5 e' sul PC di Claudio.
  Lo script `ABTG_SondaADR.mq5` **non e' mai stato compilato da nessuno**, come
  ogni sorgente nuovo di questa casa.
- ❌ **Non ho firmato criteri**: `R94_CRITERI.md` e' e resta una **BOZZA** con la
  sezione firma **vuota**.
- ❌ **Non ho toccato la sedia 12** (`ABTG_EMA200`, U30USD, magic 771531) ne'
  nessun'altra sedia in forward: **nessun file di EA e' stato modificato**.
  Gli unici file toccati sono **nuovi**.
- ❌ **Non ho corretto** `ANALISI_POINTBREAK_2026-08-18.md` ne'
  `STATO_QUATTRO_STRATEGIE_2026-08-21.md`: la correzione agli atti e' la
  **richiesta 3**, non un'iniziativa mia.
- ❌ **Non ho riaperto il Point Break come strategia**, e quando la proposta 2 mi
  ci ha portato vicino (§2.4 punto 3) **ho chiuso invece di proseguire**.

---

# 5. 📁 FILE DI QUESTA CONSEGNA

| file | stato |
|---|---|
| `backtest_pipeline/risultati_archivio/POINTBREAK_TRE_COMPONENTI_2026-08-21.md` | questo referto |
| `mql5/Scripts/ABTG_SondaADR.mq5` | 🆕 strumento P-PB1 — **mai compilato** |
| `backtest_pipeline/risultati_archivio/R94_CRITERI.md` | 🆕 **BOZZA non firmata** |
| `backtest_pipeline/prove/R94a_bb37_GBPUSD.txt` | 🆕 file prova |
| `backtest_pipeline/prove/R94b_bb37_EURUSD.txt` | 🆕 file prova |
| `backtest_pipeline/prove/R94c_bb37_AUDUSD.txt` | 🆕 file prova |

**Riproducibilita' dei due fatti nuovi del §1.2** (poppler, gia' in casa):
```bash
cd backtest_pipeline/caccia_strategie/trascrizioni_corso_2026-08-18/materiale_pointbreak
pdftoppm -r 200 -png -f 4  -l 4  "POINT BREAK - PIANO DI TRADING.pdf" p   # AUDUSD H12, 57.02
pdftoppm -r 200 -png -f 20 -l 20 "POINT BREAK - PIANO DI TRADING.pdf" p   # GBPUSD D1, 83.73
```
