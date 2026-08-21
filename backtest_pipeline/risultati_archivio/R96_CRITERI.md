# ⚖️ R96 — CRITERI — ✅ **FIRMATI DA CLAUDIO IL 21/08/2026, PRIMA DEI NUMERI**

> ## ✍️ FIRMA DI CLAUDIO — 21/08/2026, in chat: **"FIRMO TUTTE"**
>
> Dichiarazione di cecità: nessun risultato di R96 è stato prodotto, letto o
> guardato al momento della firma. L'EA `ABTG_CrossEmaApertura.mq5` non è mai
> stato compilato né fatto girare. Le soglie di questo file **non sono state
> toccate dalla firma**: restano quelle scritte sopra, comprese le due appena
> completate (§4.2 "frazione alta" ≥ 0,50 · "vicino a zero" < 30) e
> l'etichetta [DICHIARATO] sul paragrafo anti-DAX (§2).
>
> **Finché questa riga è vuota, R96 NON SI LANCIA.** Regola di casa, non
> negoziabile: *i criteri si cambiano PRIMA dei numeri, non dopo*. Se un numero
> uscito suggerisse un criterio migliore, quel criterio vale **dal round dopo**.
>
> _Chi scrive questa bozza **non ha visto un solo numero di R96**: l'EA
> `ABTG_CrossEmaApertura.mq5` è stato scritto oggi e **non è mai girato**, su
> nessuna macchina. Tutte le cifre citate qui dentro vengono da round **già
> refertati e già agli atti** (R86, R88, R84, R45, R42, REGISTRO_TEST), citate
> per nome._

---

## 0. 🧨 LA COSA PIÙ IMPORTANTE, E VA LETTA PRIMA DI TUTTO IL RESTO

### R96 **NON È UNA VARIANTE DI R86**. Non lo è, e non deve diventarlo.

R86 ha bocciato `ABTG_CrossEma` (incrocio EMA 9/21 sulla serie **continua**) su
D30EUR H1 e XAUUSD H1. La tentazione naturale — *"rifacciamolo solo nell'ora
dell'apertura americana"* — è **vietata**, e non per gusto: è lo schema
**"filtro orario appiccicato a un motore già tarato"**, che in questa casa ha un
punteggio misurato di **0 successi su 5** (R20 ADX · R12 · R26 · R45 · R54),
scritto per esteso in `caccia_strategie/CACCIA_JPY_MECCANISMI_2026-08-21.md`
(§8, righe 534-535).

**Quindi R96 misura un MOTORE DIVERSO**, e la differenza sta in una riga di
algebra, non in una sfumatura di parole:

| | R86 — `ABTG_CrossEma` (BOCCIATO) | R96 — `ABTG_CrossEmaApertura` |
|---|---|---|
| su quale serie è calcolata la media | la serie **continua** del simbolo | **solo le barre della sessione**, ri-seminate ogni giorno all'apertura |
| il numero esiste alle 03:00? | **sì** (e noi sceglieremmo di non usarlo → è un FILTRO) | **no**: prima dell'apertura non c'è nessuna media, quindi non c'è nessun incrocio da filtrare |
| cosa misura la media | il prezzo contro le ultime 21 barre, notte compresa | **lo spostamento dall'apertura**, e nient'altro |
| cosa succede a fine sessione | niente, la posizione vive | la posizione **muore con la sessione che l'ha generata** |
| il segnale | incrocio EMA 9/21 continua | incrocio delle **medie di sessione** |

> ✅ **Classificazione dichiarata: SESSIONE COSTITUTIVA.** L'apertura non
> seleziona un segnale preesistente: lo **genera**. Togliendo l'ancora, il
> segnale non diventa "meno frequente": **cessa di esistere**.

### 🔴 E LA CONSEGUENZA CHE MORDE: **nessun numero di R96 si confronta con un numero di R86**

Simboli diversi (U30USD/NASUSD contro D30EUR/XAUUSD), timeframe diverso (M5
contro H1), motore diverso, criteri diversi. **Si confrontano solo le
CONCLUSIONI**, e in una sola forma ammessa:

> *"R86 ha misurato che l'incrocio continuo non ha edge su DAX e oro. R96
> misura se un motore ANCORATO ALL'APERTURA ne ha uno sugli indici USA."*

**Mai** *"R96 fa PF 1,3 contro lo 0,95 di R86, quindi l'ora funziona"*: sarebbe
un confronto fra due mercati diversi su due timeframe diversi, cioè niente.

**E mai** *"se anche R96 dice di no, il capitolo incrocio 9/21 si chiude"* —
questa frase c'era nella prima stesura, in due punti, ed è **stata tolta da
entrambi**: R96 **non muove i periodi 9 e 21** (§1 e §4.2), quindi non può
chiudere nessun capitolo che li riguardi. L'unica cosa che R96 può chiudere è
**il proprio motore**.

---

## 1. 🎯 LA DOMANDA DEL ROUND — **una sola**

> **"Il momento della sessione misurato da medie RI-SEMINATE all'apertura
> americana (14:30 server = 15:30 IT) ha un edge sugli indici USA — e quello
> che eventualmente si vede viene dall'ANCORA o solo dall'OROLOGIO?"**

La seconda metà della domanda **non è un di più: è il round**. Senza di essa
R96 non saprebbe distinguere sé stesso dalla cosa che ha il divieto sopra.

### 🔴 PERCHÉ LA DOMANDA NON DICE PIÙ "l'incrocio 9/21"

_La prima stesura la intitolava così, ed era **una promessa che il round non
può mantenere**. Corretta alla prima verifica — **checklist punto 52**._

Con `InpMinBarreSessione=2` il segnale **dominante** di ogni sessione è
l'incrocio della **seconda barra**, e lì l'algebra del seme dà una direzione
pari a **`sign(c1 − c0)`**: la stessa con 9/21, con 5/13 o con 8/21, perché
l'unica cosa che conta è `af > as`. **I periodi non muovono quel segnale.**

Quindi:

- ✅ R96 misura **il momentum delle prime barre dopo la campanella**, più la
  coda degli incroci successivi. È un motore legittimo e mai misurato in casa.
- ⛔ R96 **non misura l'effetto dei periodi 9 e 21**, e **nessuna sua
  conclusione può riguardarli** (vedi §6-bis, dove una clausola che lo faceva
  è stata cancellata).
- 📏 L'artefatto **si conta**: colonna **`Incroci Seme`** nel CSV e campo
  `seme=` nella riga `[XEMAAP][CONTEGGIO]`. Gli **INCROCI VERI** —
  `Incroci Sessione − Incroci Seme` — sono quelli in cui i periodi hanno
  deciso qualcosa, ed è **su quelli** che si legge il cancello del §4.2.

> Il nome di un round è una promessa su cosa verrà misurato. Meglio un titolo
> più modesto e vero che uno che chiude una strada mai percorsa.

### Le due celle, e perché sono due

| cella | file prova | cosa cambia | cosa risponde |
|---|---|---|---|
| **A** ⚓ **IL MOTORE** | `R96a_ancora_{U30USD,NASUSD}.txt` | `InpAncoraSessione=1` | *l'incrocio costruito dall'apertura ha un edge?* |
| **B** 🕰️ **CONTROLLO NEGATIVO** | `R96b_controllo_{U30USD,NASUSD}.txt` | `InpAncoraSessione=0` | *lo stesso orario, ma con le medie CONTINUE: cioè lo schema vietato. Quanto di A è l'ancora e quanto è solo l'ora?* |

**Le due celle differiscono per UNA riga** (`InpAncoraSessione`) più il magic.
Tutto il resto — finestra, durata, medie, stop, target, rischio, gestione — è
**identico**, e va verificato col `diff` prima di lanciare (punto 33 della
checklist).

### 🚫 LA CELLA B NON È PROMUOVIBILE. MAI. NEMMENO SE VINCE.

Va scritto qui, **prima** dei numeri, altrimenti fra un mese qualcuno la
promuove in buona fede:

1. La cella B **è** lo schema 0/5. È in questo round come **strumento di
   misura**, esattamente come un termometro non è la febbre.
2. **Se B esce meglio di A**, R96 conclude: *"il motore dell'ancora non regge, e
   quello che si vede è l'orologio su un motore già bocciato"*. Questo è un
   risultato **negativo per R96**, e diventa — al massimo — **un'ipotesi per un
   round nuovo con criteri nuovi**, mai una sedia. Motivo misurato: su un
   motore già bocciato, un'altra fetta di dati che sembra verde è la cella
   *"verde per caso"* che brucia la challenge (REGOLA DELLA SECONDA CACCIA,
   19/08).
3. **Se A e B escono uguali**, l'ancora è **cosmetica** e la risposta alla
   domanda del round è **NO** — qualunque sia il PF. Vedi §4.2.

---

## 2. 🧭 IL SIMBOLO GIUSTO PER QUESTA TESI — e perché **NON è il DAX**

L'alert di stamattina di Claudio era **sul DAX**. La tesi che ha formulato
parla dell'**apertura americana**. **Sono due cose diverse, e vanno tenute
separate o il round non misura niente:**

| | apertura EUROPEA | apertura AMERICANA |
|---|---|---|
| quando | 09:00 IT = **08:00 server** | 15:30 IT = **14:30 server** |
| chi apre davvero | DAX (D30EUR), FTSE, CAC | Dow (U30USD), Nasdaq (NASUSD), S&P |
| il DAX alle 14:30 server | — | **è aperto da 6 ore e mezza**: la campanella è passata da un pezzo |

> ⚓ **L'ancora ha senso solo dove, in quell'istante, arriva un EVENTO DI
> VOLATILITÀ REALE.** Alle 14:30 server apre il mercato **cash** americano, e
> *quello* è l'evento che giustifica di buttare via la storia precedente e
> ripartire da un seme.
>
> **[DICHIARATO], non [MISURATO]**: che alle 14:30 server "sul DAX non
> cominci niente" è un'affermazione di buon senso (il DAX è già aperto da ore),
> non un numero verificato in casa — nessun round ha misurato la volatilità
> del DAX in quella fascia. Non tocca R96 (il DAX non gira in questo round),
> ma la motivazione va letta con questa etichetta finché qualcuno non la misura.
>
> 🔧 **E qui va corretta una motivazione più debole che questo file conteneva
> nella prima stesura**, perché era imprecisa e le imprecisioni si propagano:
> diceva *"sul DAX alle 14:30 non c'è nessun seme da piantare"*. **Non è vero
> in quei termini**: il seme lo piantiamo **noi**, è una scelta algebrica
> nostra, e su un CFD che quota quasi 24 ore lo si potrebbe piantare a
> qualunque ora del giorno. Tecnicamente **si può** ri-seminare il DAX alle
> 14:30.
>
> **Il motivo vero per cui non si fa è un altro, ed è più forte:** sarebbe una
> **risemina senza un evento che la giustifichi**. Sul DAX alle 14:30 non
> comincia niente — il mercato è aperto da 6 ore e mezza e sta reagendo
> all'apertura di *un altro* mercato. L'evento equivalente, per il DAX, è
> l'apertura cash europea delle **08:00 server**. Una risemina scelta senza un
> evento sotto è **un parametro pescato**, non un motore.

**Quindi R96 gira su U30USD e NASUSD, M5.** La versione DAX esiste ed è a un
input di distanza (`InpOpenHour=8`, `InpOpenMin=0`), **ma è un altro round**:
una domanda per round, o non si sa più chi ha spostato cosa.

### ⚠️ E il conflitto che va dichiarato PRIMA, non scoperto dopo

Su **U30USD M5, all'apertura americana, esiste già una sedia viva**:
`ABTG_ORB` (magic 770601), refertata in `REFERTO_ROUND88_ORB_MIGLIORAMENTO.md`
— cella base **PF 1,6742 · DD 9,7623% · 119 trade**, a tick reali, deposito
100.000. E quell'EA **ha già dentro le EMA 9/21** (trailing su EMA9, uscita su
chiusura oltre l'EMA9, filtro EMA opt-in).

Due conseguenze, entrambe scritte adesso:

1. **R96 non è un buco su U30USD: è un secondo motore sullo stesso evento.**
   Anche se la cella A vincesse tutti i cancelli, **non nasce nessuna sedia**
   finché non è misurata la **SOVRAPPOSIZIONE** con `ABTG_ORB`
   (`backtest_pipeline/sovrapposizione_sedie.py`, sulle serie per-trade). Due
   motori che perdono negli stessi giorni non sono diversificazione: sono la
   stessa scommessa pagata due volte. Vedi §6 punto 5.
2. **Su NASUSD il buco invece c'è, ed è documentato:** l'apertura USA sul
   Nasdaq è **morta** (`REGISTRO_TEST.md` test A4: *"0% combo pos, best PF
   0,91"*; e §2 *"capitolo BREAKOUT M5 CHIUSO (26.07.26)"*). Lì un meccanismo
   **diverso dal breakout** è esattamente ciò che la REGOLA DELLA SECONDA
   CACCIA autorizza a cercare.

📌 **Corollario di lettura**: i due simboli rispondono a due domande diverse
(U30USD = *"aggiunge qualcosa a una sedia che c'è già?"*, NASUSD = *"c'è vita
dove il breakout è morto?"*). **Nessun pooling.** Verdetto per simbolo, sempre.

---

## 3. 🪟 LA FINESTRA — dimensionata sulle OPERAZIONI (Emendamento, regola A)

### 3.0 🚧 PASSO 0 — e stavolta è **già misurato**, con la fonte

Non c'è nessun `@DAQUANDO` inventato in questo round. I tick reali dei due
simboli sono **misurati e agli atti**:

| simbolo | tick | prima data | fonte | etichetta |
|---|---:|---|---|---|
| **U30USD** | **67.618.571** | **2024.09.26** | `REFERTO_ROUND88_ORB_MIGLIORAMENTO.md` §7 (misura del 20/08, ore 19:53) | **[MISURATO]** |
| **NASUSD** | **164.636.788** | **2024.09.26** | `REFERTO_R83_R84_PREPARAZIONE.md` riga 620 | **[MISURATO]** |

⚠️ **Come si legge il `Verdetto` di quelle righe** (checklist punto 47: *un
valore letto dall'artefatto di un gemello si interpreta leggendo la FORMULA che
lo produce, non il suo NOME*). `ABTG_HistoryDownloader.mq5` scrive, sulle righe
`TICK`:

```mql5
(tfirst > from + 86400 ? "TICK REALI PARZIALI" : "COMPLETO")
```

dove `from` è **la data che gli abbiamo passato noi** (`-Da 2015.01.01` o
simile). Quindi **`TICK REALI PARZIALI` NON significa "i tick sono bucati":
significa "non arrivano fino alla data che hai chiesto"**. Per la finestra di
R96, che **inizia esattamente al 2024.09.26**, la copertura è piena.

> 🔴 **REGOLA CONGELATA:** il PASSO 0-A di R96 **non riscarica lo storico** (è
> già misurato): **verifica l'ETÀ del referto** e la riga dei due simboli
> (checklist punto 23). Se il referto ha più di 48 ore, o se la colonna
> `Verdetto` manca del tutto (schema cambiato), **il round si ferma** e la
> misura si rifà.

### 3.1 La finestra dichiarata

| voce | valore | fonte |
|---|---|---|
| simboli / TF | **U30USD M5** e **NASUSD M5** | tesi: apertura USA su indice USA. M5 perché la finestra è di 3 ore: su H1 sarebbero 3 barre |
| storico | **`@DAQUANDO 2024.09.26`** | **misurato**, §3.0 |
| fine | `2026.06.30` | default `-Fino` di `walkforward_generico.ps1` |
| split | **40/60** (`-FrazioneIS 0.40`) | come R83 / R84-bis / R86: **non si cambia lo split per far tornare un numero** |
| **IS / OOS** | **si leggono nell'anteprima `.ini` del giro a vuoto** | ⚠️ non li scrivo qui a memoria: il driver li calcola con `AddDays(floor(giorni*0,40))` e l'artefatto che conta è quello che gira (checklist punto 43) |
| modello | **4 = tick reali** | §3.0 lo consente |
| deposito | **100.000** | come `REFERTO_ROUND88` su U30USD M5: è l'unico riferimento confrontabile che abbiamo su questo simbolo e questo TF |
| rischio | **1,00% pinnato** | non è la taglia di campo (0,65%): è un valore comune che rende le celle confrontabili fra loro. Come R86 |

### 3.2 🐤 IL CANARINO DELLA FREQUENZA, detto prima dei numeri

L'Emendamento (regola A) chiede **≥150 operazioni IS** e altrettante OOS.

**[STIMA, MAI MISURATA]** finestra di 3 ore su M5 = 36 barre di sessione; un
incrocio di medie di sessione dovrebbe produrre **1-3 segnali per sessione**;
con ~440 sessioni di borsa nella finestra, **~450-1.100 operazioni totali**.
Se la stima regge, 40/60 lascia **~180-440 IS** e **~270-660 OOS**: entrambi
sopra 150.

> ### 🔴 CONSEGUENZE, ACCETTATE IN ANTICIPO — tutte e quattro
>
> 1. **`Sessioni Viste` = 0 in una cella** → quella cella **NON HA GIRATO**.
>    Non è "brutta": è **assente**. L'ora dell'ancora non ha trovato barre su
>    quel simbolo. Si scrive **"cella non eseguita"**, si va a vedere l'orario,
>    e il round si rilancia per quella cella. *(È il difetto 31-bis della
>    checklist — il filtro che, se gli manca il dato, diventa neutro in
>    silenzio — reso visibile con una COLONNA invece che con una `Print`, come
>    prescrive il punto 34.)*
> 2. **`Ingressi Aperti` = 0** con `Sessioni Viste` > 0 → il motore ha visto le
>    sessioni e non ha mai tirato il grilletto: **merito non misurabile**, e la
>    conclusione è sulla **frequenza**, non sull'edge.
> 3. **IS della cella A sotto 150 operazioni** → **il MERITO è SOSPESO in tutto
>    R96** (valvola R59: *il campione sottile sospende il giudizio sul MERITO,
>    mai sul RISCHIO*). Si legge il **RISCHIO** (§4.3) e si scrive che la
>    finestra non basta — e che allargarla **non si può**, perché il 2024.09.26
>    è il muro del broker, non il muro del nostro disco.
> 4. **Sotto 30 operazioni totali (IS+OOS) in una cella** → merito di quella
>    cella **sospeso**, si scrive **"non misurabile"**, mai *"peggiora"*.
>    Soglia identica a `R84_ABLAZIONE_CRITERI.md` §3.3 e a `R86_CRITERI.md`
>    §2.2: non è inventata oggi.

### 3.3 Il REGIME contenuto — va scritto accanto a OGNI numero

Con `2024.09.26 → 2026.06.30` il regime è **UNO E MEZZO**: toro americano
2024-25 più la correzione 2025. Niente 2020, niente 2022, niente 2008.

**R96 misura un motore dentro un regime; NON dichiara robustezza.** La
robustezza è la regola C dell'Emendamento (quattro finestre toro / orso /
laterale / crollo) ed è un altro round. E qui **non c'è scelta**: il broker non
ha U30USD prima del 26/09/2024, né a tick né a barre.

---

## 4. 🚪 I CANCELLI — le soglie NUMERICHE, da congelare

### 4.0 🧪 I controlli di sanità, prima di qualunque altra riga

R96 **non ha una riga di riferimento storica**: l'EA è nuovo e non è mai
girato. Quindi la sanità si fa in quattro pezzi, tutti obbligatori:

1. **AUTOTEST letto UNA VOLTA, in un test SINGOLO, PRIMA del round**
   (`InpAutoTest=1` fuori dalla griglia; nei file prova è pinnato a 0 apposta).
   La riga `[XEMAAP][AUTOTEST] esito motore:` deve dire **SEI BLOCCHI SU SEI**. ⚠️ Si legge **eseguendo**, non compilando: quelle `Print` stanno
   in `OnInit` (checklist punto 20). E **mai** attaccando l'EA a un grafico del
   PC di backtest: quel terminale è sul conto vivo (punto 26).
2. **Gemelli identici**: ogni file prova spazzola solo la coppia di magic
   gemelli. Le due passate **devono uscire IDENTICHE al centesimo**. Una sola
   coppia che diverge → **il round si ferma** (checklist punto 5). In R84 ha
   funzionato 18/18.
3. **`diff` fra A e B**: devono differire per **UNA riga di logica** (
   `InpAncoraSessione`) **più il magic**. Si verifica sui file **scaricati dal
   pin**, non su quelli che ricordiamo (checklist punto 33).
4. **Cache del tester svuotata** (`<cartella dati>\Tester\cache`) prima della
   corsa, contando i file **prima E dopo** (checklist punti 38 e 46). ⚠️ **Solo
   `Tester\cache`. MAI `bases\<server>\ticks\`.** I magic sono vergini (blocco
   7796xx mai usato nel repo), quindi la cache non dovrebbe mordere: si svuota
   lo stesso, perché "non dovrebbe" non è una misura.

### 4.1 🟢 CANCELLO A — "il motore dell'ancora ha un edge"

Tutti e quattro, non tre su quattro:

| # | soglia | da dove esce il numero |
|---|---|---|
| **A1** | **n IS ≥ 150 e n OOS ≥ 150** | Emendamento della finestra, regola A. Sotto: merito **SOSPESO** (§3.2 punto 3) |
| **A2** | **PF ≥ 1,10 in ENTRAMBE le finestre**, e **profit > 0 in entrambe** | 1,10 è la soglia **già firmata** da Claudio in `R88_CRITERI.md` per un motore da apertura su U30USD. Non è pescata oggi |
| **A3** | **il segno del Profit non si ribalta fra IS e OOS** | è il criterio che in R84 ha smascherato le celle C, E, H, I. E in R20 è la lezione USDJPY: *"IS rosso ovunque + OOS verde ovunque è la configurazione PIÙ pericolosa"* |
| **A4** | **passa il CANCELLO DELLA DISTINZIONE** (§4.2) | senza, un PF alto non dice se viene dall'ancora o dall'orologio: cioè non risponde alla domanda del round |

### 4.2 🔬 CANCELLO DELLA DISTINZIONE — **il cancello proprio di R96**

È la trasposizione del *"filtro che non filtra"* di `R86_CRITERI.md` §4.5, e
qui vale più del PF perché **è la domanda**:

> **Se la cella A e la cella B, sullo stesso simbolo, hanno `n` entro il ±10%
> E gli INCROCI VERI entro il ±10%, l'ancora è COSMETICA**: sta producendo
> (quasi) gli stessi segnali delle medie continue, e R96 risponde **NO** alla
> propria domanda, qualunque sia il profitto.
>
> In quel caso si scrive, con queste parole: **"l'ancora non ha costruito un
> segnale diverso: ha ridisegnato lo stesso"** — e il capitolo si chiude, senza
> proporre niente.

### 🔴 E QUI VA LETTA UNA CORREZIONE, perché la prima stesura di questo cancello **non poteva mordere**

_Trovata alla prima verifica di R96, ed è la **checklist punto 52**._

La prima stesura confrontava **`Incroci Sessione`** (il totale). **Quel confronto
sarebbe uscito SEMPRE "non cosmetica", a prescindere dai numeri**, per una
ragione algebrica e non statistica:

```
alla SECONDA barra di sessione (n = InpMinBarreSessione = 2):
  fPrev = sPrev = c0            <-- il SEME: le due medie COINCIDONO
  fNow  = c0 + 0,2000*(c1-c0)   af = 2/(9+1)
  sNow  = c0 + 0,0909*(c1-c0)   as = 2/(21+1)
CrossDirezione chiede fPrev<=sPrev, che qui e' VERO PER COSTRUZIONE:
  c1 > c0  ->  +1 LONG   (sempre)
  c1 < c0  ->  -1 SHORT  (sempre)
```

Cioè: **in cella A ogni sessione produce un incrocio garantito**, quindi
`Incroci Sessione >= Sessioni Viste` è un **pavimento strutturale** che in
cella B **non esiste**. Confrontare i totali significava confrontare una cosa
con un pavimento e un'altra senza: il gate sarebbe stato **decorativo**.

> ✅ **La forma corretta, congelata:**
> **INCROCI VERI = `Incroci Sessione` − `Incroci Seme`**, e il ±10% si misura
> **su quelli**. La colonna `Incroci Seme` esiste apposta nel CSV (e il campo
> `seme=` nella riga `[XEMAAP][CONTEGGIO]` per la passata singola del PASSO 0):
> l'artefatto **si conta, non si nasconde e non si "corregge" dentro l'EA**.
>
> ⚠️ **E se `INCROCI VERI` è vicino a zero, il cancello nemmeno si applica**:
> vuol dire che R96 ha misurato **il momentum delle prime barre dopo la
> campanella**, che è un motore legittimo e interessante — ma **non è
> l'incrocio 9/21**, e il referto deve dirlo con quelle parole prima di ogni
> altra riga.
>
> **I due numeri, congelati con la firma del 21/08 (chiudono l'annotazione
> cosmetica lasciata aperta dal secondo giro di verifica):**
> - **"FRAZIONE ALTA" (§8 punto 5) = `Incroci Seme` / `Sessioni Viste` ≥ 0,50.**
> - **"VICINO A ZERO" (qui sopra) = `INCROCI VERI` < 30** (stessa soglia di
>   casa del §3.2 punto 4: sotto, il campione non è nemmeno leggibile).

📌 **La misura fine, se i conteggi divergono ma non abbastanza:** le serie
per-trade escono in `Common\Files\abtg_trades_ABTG_CrossEmaApertura_<sym>_<magic>.csv`
per **ogni** cella. La sovrapposizione dei trade fra A e B si calcola offline.
⚠️ **Limite dichiarato del formato**: quel CSV riporta l'ora di **chiusura**,
non di apertura (è il formato standard di casa, e non lo cambio dentro un round
per non rompere il confronto con tutti gli altri EA). La sovrapposizione che se
ne ricava è quindi **approssimata**, e va etichettata **[INFERITO]**.

### 4.3 🔴 CANCELLO DEL RISCHIO — assoluto, a qualunque `n`

**Non si sospende mai** (Emendamento, regola B: *un drawdown è un fatto
accaduto, non una stima*). Vale per **ogni** cella, B compresa:

| # | soglia | da dove esce il numero |
|---|---|---|
| **C1** | **DD (IS o OOS) > 15,0%** → cella **BOCCIATA PER RISCHIO**, qualunque sia il PF | muro prop **10% di DD totale** (`report/METRO_PROP.md` §1-bis); le passate girano a **1,00%** di rischio, la taglia di campo è **0,65%**: 10% ÷ (1,00/0,65) = 15,4% → arrotondato **in basso a 15,0%**. Identico a `R86_CRITERI.md` §4.3. ⚠️ **[INFERITO per scalatura lineare del rischio, NON misurato]**: il DD non scala esattamente col lotto |
| **C2** | **Peggior Giornata % peggiore di −7,5%** → **BOCCIATA PER RISCHIO** | muro prop giornaliero **5%**, scalato allo stesso modo: 5% ÷ 1,538 = 7,7% → **7,5%**. La colonna *Peggior Giornata %* c'è nel CSV apposta |

⚠️ **La trappola già misurata, scritta prima** (`REFERTO_ROUND84_ABLAZIONE.md`
punto 3): *"i filtri comprimono il DD decimando i trade, non proteggendo quelli
che restano"*. **Un DD più basso ottenuto tagliando il campione NON è gestione
del rischio: è selezione di giornate, e va scritto con quelle parole.** Qui
morde in modo specifico: la cella A opera **3 ore al giorno** invece di 24, e
un DD basso ottenuto così **non è merito del motore, è merito dell'orologio**.
Il confronto giusto è **DD per operazione**, non DD assoluto.

### 4.4 ⚪ CANCELLO DEL PAREGGIO — si dichiara e non si tira

Se A e B stanno **dentro il 5% di PF e dentro 0,5 punti di DD**, è un
**PAREGGIO**, e il pareggio lo vince **il default di casa: nessuna sedia
nuova**. Un motore in più ha un costo (da capire, da misurare, da mantenere,
da sorvegliare) che un pareggio non paga.

---

## 5. 🎚️ LA REGOLA DI SELEZIONE — centro dell'altopiano, MAI il picco

⚠️ **Va detta con la sua limitazione, o il numero non vuol dire niente**
(Emendamento, regola A, terzo punto).

**R96 NON spazzola nessuna griglia**: l'unico asse con flag `Y` è la coppia di
magic gemelli, che è un controllo, non una manopola. **Quindi non esiste nessun
altopiano da cui prendere il centro**, e va scritto invece di far finta.

La regola si trasporta così — identico a come ha fatto `R86_CRITERI.md` §3:

1. Si guarda **l'insieme delle quattro celle**, non la riga più bella.
2. Una cella che sporge da sola, con le sorelle che non la accompagnano, è
   **rumore**: a referto si scrive *"picco isolato, non proposto"*.
3. **Coerenza fra i due simboli**: se l'ancora funziona su uno e non sull'altro,
   **non si sceglie il simbolo che piace**. Si scrive che ha **segno opposto sui
   due mercati** — è la lezione PTE (GBPUSD sì, USDJPY no), ed è un risultato,
   non un imbarazzo. **Nessun pooling**; se si somma, la riga porta **[INFERITO]**.
4. **`n` IS e OOS accanto a OGNI numero.** Un numero senza `n` **non entra nel
   referto**.
5. **`Sessioni Viste` accanto a ogni numero**, per lo stesso motivo: distingue
   *"ha girato e ha perso"* da *"non ha girato"*.
6. Ogni riga porta **[MISURATO] / [INFERITO] / [DICHIARATO]**.

---

## 6. 🛑 IL VINCOLO — R96 PROPONE, CLAUDIO DECIDE

1. **`ABTG_CrossEmaApertura` NON È UNA SEDIA.** È un candidato mai girato. Dal
   round non esce nessun `.set`, nessun EA attaccato a un grafico, nessun magic
   in campo. **Nessun deploy automatico, in nessun caso.**
2. **Il massimo che R96 può produrre è "il permesso di fare un walk-forward
   vero"**, e per la cella A soltanto.
3. **Nessuna sedia viva si tocca mentre R96 gira.** In particolare `ABTG_ORB`
   (770601) su U30USD **non viene sfiorato**: R96 usa magic vergini del blocco
   **7796xx**, mai comparso nel repo.
4. **Un solo cambio alla volta.** La versione DAX (`InpOpenHour=8`), lo sweep di
   `InpMinBarreSessione`, la durata della finestra e `InpSoloPrimoIngresso` sono
   **round successivi**, non celle di questo.
5. **Se e solo se la cella A passa tutti i cancelli**, PRIMA di qualunque
   proposta servono, nell'ordine:
   (a) **misura di SOVRAPPOSIZIONE con `ABTG_ORB` su U30USD**
   (`sovrapposizione_sedie.py` sulle serie per-trade) — §2;
   (b) **prova di regime** (regola C dell'Emendamento);
   (c) **R55-bis** su slippage e spread della cella proposta;
   (d) **contratto della sedia** in `report/CONTRATTI_SEDIE.md` con DD e
   frequenza **promessi** (è su quelli che il criterio di uscita del 18/08
   misurerà il forward);
   (e) **forward demo**, mai live da un backtest.

### 6-bis. 🔁 LA CLAUSOLA DELLA SECONDA CACCIA — **riscritta**, e con una cosa in MENO

> 🗑️ **QUI C'ERA UNA CLAUSOLA CHE È STATA CANCELLATA, e va detto invece di
> farla sparire.** La prima stesura autorizzava, in anticipo, a *"chiudere il
> capitolo incrocio EMA 9/21 in questa casa"* se la cella A fosse uscita senza
> edge. **Era sbagliato**, e il motivo è quello del §4.2: con
> `InpMinBarreSessione=2` il segnale dominante di ogni sessione è l'artefatto
> del seme, la cui direzione è `sign(c1-c0)` — **identica con 9/21, 5/13 o
> 8/21**. R96 **non muove i periodi**, quindi **non può concludere niente su di
> loro**. Chiudere quel capitolo con i numeri di R96 sarebbe stato **chiudere
> una strada che nessuno ha percorso**, che è peggio di un referto sbagliato.

Quello che la clausola dice **adesso**:

- Se **la cella A esce senza edge su entrambi i simboli**, quello che si chiude
  è **il motore di R96** — *"il momentum delle prime barre dopo l'apertura USA,
  gestito così"* — e nient'altro.
- **Resta vietato** un R96-bis che riprovi **lo stesso motore** con un'altra
  durata di finestra o un altro `InpSLatr`: sarebbe *"parametri diversi dello
  stesso motore morto"*.
- **Resta APERTA** la domanda sui periodi 9/21 dentro una sessione ancorata,
  perché R96 non la tocca. Il round che la aprirebbe davvero è quello che
  **spazzola `InpMinBarreSessione`** (2 / 4 / 6): solo alzandolo il segnale
  smette di essere l'artefatto del seme e comincia a dipendere dalle due medie.
- **Resta autorizzato**, come sempre, un **meccanismo diverso** sulla stessa
  inefficienza (la prima ora americana).

---

## 7. 🕳️ COSA R96 **NON** PUÒ MISURARE — dichiarato prima, non dopo

Un piano che sembra completo ma ha buchi nascosti è peggio di un piano corto.

| ❌ non misurabile in R96 | perché | dove va |
|---|---|---|
| 🔴 **L'EFFETTO DEI PERIODI 9 E 21** — ed è la riga più importante della tabella | con `InpMinBarreSessione=2` il segnale **dominante** di ogni sessione è l'incrocio garantito della barra 2, e lì la direzione è `sign(c1-c0)`: **la stessa con 9/21, 5/13 o 8/21**, perché conta solo `af > as`. **R96 misura il momentum delle prime barre dopo la campanella, non l'incrocio.** Il referto deve dirlo prima di ogni numero, e la colonna `Incroci Seme` dice **quanti** trade vengono da lì | il round che spazzola **`InpMinBarreSessione`** (2 / 4 / 6): è l'unico posto dove i periodi mordono |
| **L'apertura EUROPEA (il DAX di stamattina)** | l'ancora è pinnata a 14:30 server; sul DAX l'evento di volatilità equivalente è alle 08:00 server | **round successivo**, un input di distanza |
| **`InpMinBarreSessione`** (pinnato a **2**) | 2 è il **primo confronto matematicamente possibile** (alla prima barra le due medie coincidono per costruzione). Alzarlo cambia **classe di evento**: non più la spinta d'apertura ma il primo ribaltamento della deriva — **ed è anche l'unica manopola che fa entrare 9 e 21 nel segnale** | round successivo, **solo se A sopravvive** |
| **La durata della finestra** (pinnata a **180 min**) | 3 ore coprono la prima ora e mezza "calda" più il seguito; non è ottimizzata, è scelta | coda |
| **`InpSoloPrimoIngresso`, uscita opposta, parziale, breakeven** | pinnati e spenti in tutte e quattro le celle | altro round: **la gestione è la domanda di un altro giro** |
| **Le COMBINAZIONI** (ancora + qualunque filtro) | non esiste una cella multi-gamba | round successivo, solo se la cella singola regge |
| **La ROBUSTEZZA DI REGIME** | un regime e mezzo, e il broker non ha altro | regola C dell'Emendamento |
| **Lo SLIPPAGE e lo SPREAD** | `InpMaxSpread=0`, nessuno slittamento simulato. ⚠️ E qui morde più che altrove: **la prima mezz'ora americana è il momento di spread peggiore della giornata** | **R55-bis**, obbligatorio se esce una proposta |
| **La SOVRAPPOSIZIONE con `ABTG_ORB`** | serve un passo di analisi a parte sulle serie per-trade | §6 punto 5a, **prima** di qualunque sedia |
| **Il GUARDIAN** | acceso come in campo ma **INERTE nel tester** (le sue GlobalVariable non esistono): fail-open totale | il collaudo Guardian, non questo round |
| **Il confronto numerico con R86** | motore, simboli e TF diversi | **vietato**: §0 |

⚠️ **E il buco di processo, che vale per ogni round di questa casa:**
`walkforward_generico.ps1` scarica l'EA da `$EABranch="lavoro"` scritto fisso
nel sorgente (cercare `$EABranch=`), **non dal `-Rif`**. Gira sempre l'EA che
sta sulla punta di `lavoro` ADESSO. Quindi: **il branch `lavoro` si congela per
tutta la durata di R96**, e il commit che era sulla punta all'ora della corsa
**va scritto nel referto**.

---

## 8. 🤝 L'ASPETTATIVA DICHIARATA **PRIMA** DEI NUMERI

Quattro cose, tutte pretese in anticipo: se i numeri le smentiscono il round ha
imparato qualcosa; se le confermano, nessuno può dire *"l'avevo detto dopo"*.

1. **Mi aspetto che la cella B (controllo) NON regga.** È la previsione dello
   0/5. ⚠️ **Se invece B regge e A no**, quello **non** è una promozione di B:
   è una crepa in una regola di casa, e va trattata come tale — una misura
   nuova su un round nuovo, non una sedia.
2. **Mi aspetto che la cella A faccia POCHE operazioni e un DD contenuto**,
   perché opera 3 ore su 24. **E mi aspetto di dovermi difendere da me stesso su
   questo**: un DD basso ottenuto stando fuori dal mercato non è merito del
   motore (§4.3).
3. **Mi aspetto che A sia CORRELATA con `ABTG_ORB` su U30USD.** Entrambi si
   accendono quando il prezzo si allontana dall'apertura. **Questo è il rischio
   più serio del round** — non che A perda, ma che A vinca *ed sia la stessa
   scommessa già in campo, pagata due volte*.
4. **Il dubbio onesto sul motore, scritto per esteso:** la media di sessione
   seminata sull'apertura è, matematicamente, uno **spostamento smussato dal
   prezzo di apertura**. È un indicatore **che ci siamo inventati noi**, non una
   ricetta da manuale. Il suo antidoto al curve-fitting è che **non ha manopole
   spazzolate**: 9 e 21 li ha dettati Claudio, 2 è il minimo matematico, 180 è
   dichiarato. **Se un giorno qualcuno spazzolasse quei numeri per far tornare
   il PF, questo round andrebbe buttato insieme a quelli.**
5. 🔴 **E l'aspettativa più scomoda di tutte, che nasce dalla verifica invece
   che dall'entusiasmo: mi aspetto che `Incroci Seme` sia una FRAZIONE ALTA di
   `Incroci Sessione`.** Se lo è — ed è quello che l'algebra suggerisce — allora
   il motore che R96 sta misurando **non è quello che il nome del round
   prometteva**: è il momentum delle prime barre dopo la campanella. **Questo
   non lo rende meno interessante** (nessun round di casa lo ha mai misurato, e
   `CODA_PROSSIMA_SESSIONE.md` lo elenca fra le direzioni aperte come *opening
   drive*), **ma cambia cosa si può scrivere alla fine.** Dichiararlo adesso è
   l'unico modo perché il referto non lo scopra dopo e non ci si costruisca
   sopra una conclusione che i numeri non reggono.

---

## 9. 📋 CHECKLIST DEL REFERTO DI R96

- [ ] **PASSO 0-A** dichiarato: età del referto storico, riga `Verdetto` dei due simboli, e la **formula** con cui è calcolata (§3.0).
- [ ] Il **commit sulla punta di `lavoro` all'ora della corsa**, dichiarato.
- [ ] Il **MODO** dell'artefatto (giro a vuoto / corsa vera) nel **nome del file**, **dentro** il referto e nella riga di **ESITO** (checklist punto 50).
- [ ] **AUTOTEST** letto e dichiarato: *sei blocchi su sei* (il sesto e la riga CONSEGUENZA DICHIARATA sono il controllo del punto 52: i periodi 9/21 non muovono il segnale della barra 2).
- [ ] **Gemelli identici**, 4 coppie su 4, dichiarato.
- [ ] **Cache del tester**: file contati **prima e dopo** (punto 46).
- [ ] **`Sessioni Viste` di ogni cella**, per prima: distingue *non eseguita* da *brutta*.
- [ ] **`n` IS e `n` OOS accanto a OGNI numero**, senza eccezioni.
- [ ] Il **regime** dichiarato accanto a ogni tabella (§3.3).
- [ ] La colonna **`Incroci Seme`** e gli **INCROCI VERI** (`Incroci Sessione` − `Incroci Seme`) scritti **prima** del cancello §4.2 e prima di qualunque PF: se gli incroci veri sono vicini a zero, il referto **dichiara che R96 ha misurato il momentum delle prime barre e NON l'incrocio 9/21** (punto 52).
- [ ] Il **CANCELLO DELLA DISTINZIONE** (§4.2) applicato **sugli INCROCI VERI, mai sul totale**, e scritto prima del PF.
- [ ] **Nessuna riga del referto conclude qualcosa sui periodi 9 e 21.** R96 non li muove.
- [ ] Il **verdetto per simbolo**, mai un pooling silenzioso (§5 punto 3).
- [ ] La frase su **`ABTG_ORB`**: correlazione dichiarata o misurata, mai taciuta.
- [ ] Le celle bocciate scritte **per nome, col cancello che le ha bocciate**.
- [ ] Etichette **[MISURATO] / [INFERITO] / [DICHIARATO]** su ogni riga.
- [ ] Le **ipotesi falsificate** dette per prime, non nascoste in fondo.

---

## 10. 📎 TRACCIABILITÀ

- **File prova**: `backtest_pipeline/prove/R96{a,b}_*_{U30USD,NASUSD}.txt`
- **Sorgente**: `mql5/Experts/ABTG_CrossEmaApertura.mq5` v1.00 — **EA NUOVO,
  mai compilato né girato**. `ABTG_CrossEma.mq5` **non è stato toccato**.
- **Magic**: blocco **7796xx**, mai comparso nel repo prima di oggi.
  A: 779610/779611 (U30USD) · 779620/779621 (NASUSD) —
  B: 779630/779631 (U30USD) · 779640/779641 (NASUSD) —
  **779690** riservato al PASSO 0 / gate, **mai condiviso con la corsa**
  (checklist punto 41).
- **Precedenti citati**: `REFERTO_R86_R87_R89_NOTTE.md` §3 (CrossEma continuo
  bocciato) · `REFERTO_ROUND88_ORB_MIGLIORAMENTO.md` (sedia viva U30USD M5 e
  profondità tick) · `REFERTO_R83_R84_PREPARAZIONE.md` (tick NASUSD) ·
  `REFERTO_ROUND84_ABLAZIONE.md` (DD compresso decimando) ·
  `REGISTRO_TEST.md` §1 A4 e §2 (apertura Nasdaq morta, capitolo M5 chiuso) ·
  `caccia_strategie/CACCIA_JPY_MECCANISMI_2026-08-21.md` §8 (filtro
  appiccicato 0/5 contro sessione costitutiva) · `report/METRO_PROP.md`
- **Regole di casa applicate**: EMENDAMENTO DELLA FINESTRA (A/B/C/D) · valvola
  R59 · REGOLA DELLA SECONDA CACCIA · FUSO BCM (ora italiana − 1) ·
  CHECKLIST_RIGA_DI_LANCIO punti 5, 13, 14, 18, 20, 23, 26, 33, 34, 38, 41,
  43, 46, 47, 50, 51
