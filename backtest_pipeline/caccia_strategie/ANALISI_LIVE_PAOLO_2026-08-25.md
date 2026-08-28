# 📼 ANALISI TRASCRIZIONE — Live Paolo del 25/08/2026 (lezione SUPERTREND)

_Analisi: 26/08/2026. Fonte UNICA: `trascrizioni_2026-08-18/LIVE_PAOLO_2026-08-25.txt`
(321 righe, letto integralmente). Nessuna integrazione da memoria, nessun web.
Ogni numero qui dentro è **[FONTE CORSO — dichiarato dal docente]**, MAI un
criterio di casa finché non è misurato da noi._

**Etichette:** `[TRASCRITTO]` = c'è scritto, cito · `[TRASCRITTO dubbio]` = lo
speech-to-text probabilmente ha storpiato il numero/nome · `[INFERITO]` = lo
deduco da più passaggi, e dico quali · `[INCERTO]`.

---

# 🚩 BANDIERE IN CIMA (le cose che Claudio deve leggere per prime)

## 🔴 B1 — JACKSON HOLE: "non si fa, non sai dove va il mercato"

**È la conferma del watchpoint aperto il 24/08.** Testuale (righe 309-313):

> «È mai tradatta la notizia che c'è una volta all'anno, adesso a fine agosto?
> Quella sul simposio che fanno tutti i banchieri mondiali? **Sì. Ma quella non
> è un rilascio notizia. Quello è sui movimenti anomali del mercato in base
> alle interviste che rilasciano. Quello sono giorni di altissima volatilità
> che non sai dove va il mercato.** Quindi non l'hai mai fatta perché è molto
> pericolosa, vero? **No, ma non si fa quella. Non sai quando esce e non sai
> come esce la notizia. Non lo puoi spiegare.**»

E prima, riga 291-295:
> «Però domani c'è una notizia importante, non ho guardato come sono appunto
> letto mattina. […] **Comunque conviene aspettare domattina.** […] Jackson
> Hole ma più avanti mi sembra. **Jackson Hole ma venerdì.**»

⚠️ **CORREZIONE DI ROTTA sulla data.** La scheda `ANALISI_LIVE_EMILIANO_2026-08-24.md`
ha registrato "Jackson Hole giovedì 27 e venerdì 28/08". **In QUESTA trascrizione
Paolo dice solo «venerdì» e «fine agosto»** — le date 27/28 NON compaiono nel
parlato. Righe 293-295: prima dice «più avanti mi sembra», poi si corregge in
«venerdì». `[TRASCRITTO — ma data non dettata]`. Il "giovedì" viene dall'altra
fonte, non da qui: si tiene la finestra gio-ven come **prudenziale**, senza
attribuirla a Paolo.

**Cosa vale per noi:** due docenti indipendenti (Emiliano 24/08 + Paolo 25/08)
dichiarano la stessa cosa: **fuori dal mercato sul simposio Fed**. La flotta gira
**senza news filter attivo** (`InpUseNewsFilter=false` in tutti i SupRev — verificato
nel sorgente `ABTG_SupRev_NAS_H1_Ottimizzato.mq5` riga 96). La rete è il Guardian
B1 (pausa 4,0%). **Da sapere, non da agire**: i numeri di quelle giornate si
leggeranno col contesto (regola B dell'emendamento: il DD accaduto è un fatto).

---

## 🟡 B2 — Il suo "cavallo di battaglia" è la DAX M3. Noi l'abbiamo MISURATA MORTA.

Riga 305-307, testuale:
> «Paolo, il tuo cavallo di battaglia è ancora la strategia **Daxin M3**? **Sì,
> sì.** Ora ho messo che non la faccio perché sono stato in vacanze e poi il
> mercato era laterale. **Quella, l'Orbe, il Golden Cross e Supertrend e
> Inverter sono quelle che mi piacciono di più.**»

**Accanto, i NOSTRI numeri** (`backtest_pipeline/REGISTRO_TEST.md`):
- riga 78: `| O3 | DAX_M3 | D30EUR | — | OHLC 33% pos, short 0% | 🔴 morto |`
- riga 40, **verdetto definitivo del 26.07.26**: «capitolo **BREAKOUT M5 CHIUSO**.
  Provati e morti in real-tick: Live5m nativo, Live5m_v2, **DAX_M3**, aperture
  Nasdaq, ORB_Fibo, Londra_ORB. Il breakout in apertura su M5 NON ha edge sul
  tick vero. **Non costruire altri v2 M5.**»

📌 **Lettura onesta:** non è "Paolo ha torto". È che **la sua M3 è discrezionale
e la nostra M3 è meccanica**, e quello che sopravvive al suo occhio muore
nell'automa. È esattamente la nota già scritta nel registro (riga 299): «la sua
lettura discrezionale live è un'altra cosa e **non è automatizzabile 1:1**».
👉 **Non riaprire il capitolo M5/M3.** Vale come conferma della regola, non come
invito a rifare la griglia.

⚡ **Contraddizione interna dichiarata:** in tutta la lezione predica **H4 → Weekly**
(riga 67: «Time frame consigliati. **Da H4 a Wheatley**»), e poi dichiara come
cavallo di battaglia il **M3**. I due estremi opposti dello stesso parco. Va
registrato, non risolto.

---

## 🟢 B3 — Preferisce il SUPERTREND **INVERT** al reversal. E noi abbiamo l'EA già scritto, mai misurato sugli indici.

Riga 301: «No, tanto la devo riguardare perché **io questa strategia la faccio
poco. Io preferisco fare Supertrend e Inverter, mi piace di più.**»
Riga 305: «**A me piace di più Supertrend e Inverter.**»

La ragione tecnica che dà (riga 39, testuale):
> «quando c'è una rottura del super trend […] **il trend normalmente è sempre
> più lungo** […] Il grosso vantaggio è che in queste rotture **normalmente lo
> stop è stretto**, pertanto il rapporto rischio rendimento è sempre un rapporto
> rischio rendimento **piuttosto elevato**.»

**STATO NEL REPO — verificato riga per riga:**

| Cosa | Dove | Stato |
|---|---|---|
| `ABTG_SupertrendInvert.mq5` | `mql5/Experts/` | ✅ **esiste ed è completo** |
| Default nel codice | righe 52-53 | `InpStMult = 3.5` / `InpStAtrPeriod = 10` — **identici a quelli dettati stasera** |
| Filtro STRONG | righe 55-58 | EMA50 **e** EMA200 coerenti (`InpRequireStrong=true`) |
| Filtri forza/momentum | righe 62-76 | ADX(14)≥20 in crescita, Stocastico 14/3/3, conferma H4 opzionale |
| Anti-inseguimento | righe 78-80 | `InpMaxExtAtr = 2.0` — salta se `\|prezzo − ST\| > 2×ATR` |
| Gestione | righe 82-88 | TP1 = 1×ATR, **parziale 50%**, breakeven, exit su segnale opposto, trailing sulla linea ST |
| **Misurato su** | `report/PULIZIA_VPS_10-08.md` riga 44 | **SOLO `@XAUUSD H1` → "FASE 0: niente edge"** → spento il 10/08 |
| Mai misurato su | — | **indici (DAX/NAS/DOW/CAC), forex, e QUALSIASI TF ≥ H4** |
| Nota classifica | `risultati_archivio/CLASSIFICA_STRATEGIE.md` riga 44 | «❌ **Da aggiungere allo scan: SuperWave (H1/H4) · SupertrendInvert (H1)**» — mai fatto |

🎯 **Questo è lo spunto più grosso della serata.** Abbiamo bocciato l'Invert su
**un simbolo e un TF** (oro H1), e lo abbiamo bocciato **prima** che il SupRev
dimostrasse di generalizzare sugli indici (registro riga 347: «Il SupRev ora ha
edge REAL-TICK confermato su: Oro, DAX (H1/H4), Nasdaq (H1), Dow (H4/H1), CAC
(H4). **Motore che generalizza, dimostrato.**»). L'Invert è il **meccanismo
opposto sulla stessa inefficienza** (rottura invece di rimbalzo) — cioè
**esattamente** quello che la 🔁 REGOLA DELLA SECONDA CACCIA autorizza a cercare.
E qui non serve nemmeno cercarlo: **è già scritto, compilabile, con i filtri
dentro.**

---

# 📋 SCHEDA DELLA TRASCRIZIONE

```
FILE            LIVE_PAOLO_2026-08-25.txt  (321 righe)
RELATORE        Paolo [TRASCRITTO — nominato dagli allievi: righe 125, 145, 193,
                305, 317]. Emiliano assente/dimesso, farà la live del giorno dopo
                (riga 7). Allievi nominati: Stefano, Fabrizio, Antonio Ingarossa,
                Natalia, Giacomino.
CONTESTO       Ciclo TEORICO del corso, lezione dedicata alla strategia
                SUPERTREND. Il ciclo chiude a settembre e riparte da zero a
                ottobre (riga 9). Prossime lezioni dichiarate: FIBO H4 + teoria
                trasversale (riga 13).
OGGETTO        SuperTrend Reversal (+ accenno a SuperTrend Invert), confluenze,
                ADR, gestione. Nessuna prop citata, nessun EA, nessun automatismo.
```

---

## 1️⃣ PARAMETRI CON VALORE

### 🔧 SuperTrend — i tre caricamenti

| Parametro | Valore dichiarato | Citazione | Etichetta |
|---|---|---|---|
| Configurazione "standard" | mult **3** / ATR **10** | «la modalità standard del super trend è quando è settato con **un periodo 3.10**» (riga 25) | `[TRASCRITTO dubbio]` — "3.10" è quasi certamente **3 / 10** (mult 3, ATR 10): il separatore è saltato. Confermato dal contesto dei tre caricamenti |
| I tre caricamenti sul grafico | **2.5 / 3 / 3.5**, tutti con ATR **10** | «nei nostri grafici noi lo caricheremo **3 volte** e l'avremo anche in un periodo **2.5 barra 10** e **3.5 barra 10**» (riga 25); «la prima volta di default è **3.5**, la seconda volta lo caricate a **3** e quindi lo ricaricate a **2.5**» (riga 41) | `[TRASCRITTO chiaro]` — due passaggi indipendenti nella stessa lezione |
| **Il valore operativo** | **3.5 / ATR 10** | «Nelle strategie di Emiliano di reversal noi useremo il punto **3.5.10 barra 10 perché è l'evento più forte**» (riga 25) | `[TRASCRITTO dubbio]` sul testo ("3.5.10 barra 10" è biascicato), `[TRASCRITTO chiaro]` sul valore: ribadito 3 volte |
| Conferma del 3.5 | idem | «questo è il super trend che vi ho mandato, **è già settato con un periodo da TR10 e un moltiplicatore di 3.5**» (riga 37) | `[TRASCRITTO chiaro]` — "TR10" = ATR 10 |
| Riduzione all'uso | solo il 3.5 serve | «**Per la strategia che noi andremo a studiare non ci interessano i tre livelli, ci è sufficiente avere il livello 3.5**» (riga 41) | `[TRASCRITTO chiaro]` |
| Ribadito in esempio | idem | «supertrend **3.5**, media 200 che mi sostiene» (riga 277); «normalmente se il super trend non è mai stato testato non lo rompe mai al primo colpo **il 3.5**» (riga 95) | `[TRASCRITTO chiaro]` |

### ⏱️ Timeframe

| Cosa | Valore | Citazione | Etichetta |
|---|---|---|---|
| TF consigliati | **da H4 a Weekly** | «Punti chiave. Time frame consigliati. **Da H4 a Wheatley**» (riga 67) | `[TRASCRITTO chiaro]` — "Wheatley" = Weekly |
| TF più efficaci | **H4, D1, Weekly** | «È particolarmente efficace sui time frame **h4 di uni e weekly**» (riga 29) | `[TRASCRITTO dubbio]` sul testo — "di uni" = **D1** (il resto della lezione usa D1 costantemente) |
| Trend più forti | **H4 e D1** | «i trend più forti sono in **H4 e in D1**, pertanto cercare sempre di trovare a lavorare il super trend soprattutto quando siamo in reversal su livelli H4 o D1» (riga 39) | `[TRASCRITTO chiaro]` |
| TF bassi | **sconsigliati ma non vietati** | «questo se non possiamo lavorare un super trend in di uno come un super trend in **m15 o in h1**» (riga 29) | `[TRASCRITTO dubbio]` — frase mal trascritta, il senso `[INFERITO]` è "si può anche lavorare in M15/H1, ma i TF alti sono meglio" |
| Prezzo del TF alto | meno rumore, più durata | «Avremo **meno rumore di mercato**, ma […] possiamo avere operazioni che **stanno in macchina un po' più di tempo**» (riga 69) | `[TRASCRITTO chiaro]` |

### 🌊 Il teorema di Dow a 3 timeframe

Riga 159, testuale:
> «Ricordiamoci, secondo **il teorema di Dow che viene ricoperto da Helder**, il
> trend si guarda sempre su **tre time frame**. Un time frame dove si va a vedere
> il **trend di fondo** che è il time frame **superiore**. Il trend dove si vede il
> **segnale** che è il time frame **operativo** e il trend **inferiore** che è il
> trend con il quale si va a fare **l'ingresso a mercato**.»

- `[TRASCRITTO dubbio]` su "Helder": nome storpiato. Non lo ricostruisco — **non è
  la mia memoria che decide chi è**. Ciò che conta è il meccanismo, che è dettato
  per intero.
- Le cascate dichiarate negli esempi (`[TRASCRITTO chiaro]`):

| Fondo (marea) | Operativo (segnale) | Ingresso | Citazione |
|---|---|---|---|
| **D1** | **H4** | — | «se sei in H4 la vai a vedere in D1» (riga 243) |
| **W1** | **D1** | — | «V1 la vai a vedere in V1» (riga 243, "V1"=D1/W1 storpiato — `[INCERTO]` su quale) |
| **Monthly** | **Weekly** | **D1** | «se il segnale lo vedi in weekly […] il tuo trend frame di **monto** lo devi andare a cercare in **monthly** […] In monthly il trend frame di fondo e **in D1 il trend frame di ingresso**» (righe 169-171) |
| **D1** | **D1** | **H4** | «lavori in **D1** e ti vai in **H4** a cercare un'etappa a favore della marea» (riga 233) |

- Il vocabolario di casa sua: **"marea"** = trend del TF superiore. «La marea com'è?
  **Short**. […] Il prezzo è sotto la media 200 uniti» (riga 153); «**Però per fare
  operazioni io cerco sempre il trend superiore e la passo in direzione di marea**»
  (riga 215).

### ✅ La conferma dell'inversione (la regola più netta della serata)

Riga 93-95, testuale:
> «L'inversione quando è confermata Fabrizio? **Quando la candela successiva apre
> oltre. Quando tutto il corpo della candela successiva, l'apertura e anche la
> chiusura**, questa sarebbe una conferma, però questa conferma è rosso o verde?
> […] in questo caso **la candela successiva chiude con tutto il corpo sopra, con
> lo stesso colore, questa alla chiusura di questa candela è una conferma di
> inversione. […] questa qui rappresentava un'indecisione perché la candela
> successiva ce l'hai di colore inverso**»

📐 **Regola meccanizzabile al 100%, dettata a voce, senza ambiguità** `[TRASCRITTO chiaro]`:
> conferma = candela successiva con **APERTURA e CHIUSURA entrambe oltre** la linea
> SuperTrend **E** con lo **stesso colore** della candela di rottura.
> Colore opposto = **indecisione**, non conferma.

E la regola generale (riga 27): «**come in tutte le strategie anche sul super
trend reversal dobbiamo sempre attendere la conferma della candela successiva**».

### 🎚️ TOCCA / VIOLA / BRECCA — le tre interazioni col SuperTrend

Riga 91, testuale (la definizione più operativa del file):
> «**il prezzo tocca il super trend**, questo è un tocco del super trend, cioè il
> prezzo è arrivato sul super trend, l'ha toccato ma **non lo ha superato**;
> **questa invece è una violazione** del super trend, perché il prezzo è **andato
> oltre il super trend e poi è stato respinto**, pertanto **questo è un ottimo
> segnale di ingresso**; poi abbiamo il prezzo invece **brecca** il super trend
> quando il prezzo **chiude** sopra la candela […] **quando il prezzo chiude oltre
> il livello del super trend abbiamo l'inversione**.»

| Interazione | Definizione dettata | Uso |
|---|---|---|
| **TOCCO** | arriva sulla linea, non la supera | reversal, segnale normale |
| **VIOLAZIONE** | va **oltre** la linea in intra-candela ma **viene respinto** (chiude dentro) | 🏆 «**un ottimo segnale di ingresso**» — il migliore dei tre |
| **BREAK** | **chiude** oltre la linea | inversione del ST → si passa alla strategia **Invert** |

`[TRASCRITTO chiaro]`. Ribadito riga 133: «tu hai o il reversal, cioè il prezzo
viene respinto e **chiude all'interno** del super trend, dentro il floor, oppure
**si chiude fuori. Quando si chiude fuori c'è l'inversione**».

### 🥇 La regola del PRIMO TOCCO (perla nascosta)

Riga 95, testuale:
> «**normalmente se il super trend non è mai stato testato non lo rompe mai al
> primo colpo il 3.5**»

`[TRASCRITTO chiaro]` — è una **regola condizionale meccanizzabile**: il primo
contatto con un livello ST **non ancora testato** ha probabilità di rottura più
bassa. Traduzione in codice: contatore di tocchi del livello ST corrente dal flip;
`tocco == 1` → reversal più affidabile. **Noi non abbiamo nulla del genere.**

---

## 2️⃣ IL BLOCCO CONFLUENZE — il cuore della lezione

### La lista dei quattro elementi

Riga 41: «Ovviamente il livello di super trend **diventa più potente se è
combinato con altri elementi, come la media mobile, i livelli di Fibonacci, il
supporto e resistenza**.»
Riga 65: «**noi dobbiamo sempre combinarlo con media mobile, livelli di Fibonacci
e supporti resistenti.** È ovvio come in questo caso abbiamo la confluenza di
**tutti e quattro gli elementi** nella condizione assolutamente più favorevole.»

| # | Elemento | Valore/dettaglio dichiarato |
|---|---|---|
| 1 | **SuperTrend** 3.5/10 | il segnale base |
| 2 | **EMA 200** | «mettiamo dentro una **media 200**. Quando noi abbiamo la confluenza della media 200 con il livello di super trend […] **questo diventa un punto di reazione più forte**» (riga 43) |
| 3 | **Fibonacci** golden area | vedi sotto |
| 4 | **S/R multi-timeframe** | vedi sotto |

Bonus dichiarato: **medie 50 e 100 su TF superiore** (riga 139-143): «In weekly
potrei trovare anche una **media 50**. […] se qui ci avessi avuto la media 50 in
weekly sarebbe stato **un altro punto di rimbalzo interessante**.»

### 📐 Fibonacci — i numeri

| Livello | Ruolo | Citazione | Etichetta |
|---|---|---|---|
| **38,2 – 61,8** | 🎯 **golden area** = zona di ingresso | «qual è la nostra area di interesse? **L'area compresa tra 38,2 e 61,8**» (riga 55) | `[TRASCRITTO chiaro]` |
| **78,6** | 🛑 **invalidazione** | «Quando il prezzo rompe **71,8** il movimento è invalidato, si sta predisponendo un nuovo movimento inverso» (riga 55) | 🔴 `[TRASCRITTO dubbio]` — **"71,8" è un errore**: due passaggi successivi dicono **78,6**. Riga 261: «Lo stoppi dove me lo vado a mettere, me lo vado a mettere **sotto il 78,6**»; riga 265: «**lo stop tecnico va messo sotto il 78,6**»; riga 131: «qui siamo su **78** di Timonacci, **stiamo proprio al limite dell'invalidazione**». **Il valore vero dettato è 78,6.** |
| **38,2** | 1ª parzializzazione | «La mia prima parzializzazione la metterò sul **38.2**» (riga 275) | `[TRASCRITTO chiaro]` |
| **100** | stop "sicuro" alternativo | «Se voglio star sicuro lo metto **sotto il 100**» (riga 265) | `[TRASCRITTO chiaro]` |
| Come si traccia | dall'inizio alla fine del movimento | «Fibonacci si tratta sempre **dal punto a dove parte il movimento, a dove finisce**» (riga 53) | `[TRASCRITTO chiaro]` |
| ⚠️ Vincolo d'uso | **solo in trend** | «**Fibonacci funziona sempre quando è in trend, non quando è laterale**» (riga 95) | `[TRASCRITTO chiaro]` |
| ⚠️ Vincolo d'uso | invalidato dal doppio massimo | «qui Fibonacci non mi aiuta, perché qui ho un **doppio massimo**. […] questa qui in basso, **invalida un po' Fibonacci**» (riga 111) | `[TRASCRITTO chiaro]` |
| Cosa NON è | non predittivo | «**Fibonacci non è che ci aiuta a predire il futuro** […] ci aiuta a **misurare** i movimenti dei prezzi» (riga 57) | `[TRASCRITTO chiaro]` |

### 🧱 S/R multi-timeframe — i "livelli di RERRI"

- `[TRASCRITTO dubbio]` **sul nome**: la trascrizione scrive **"RERRI"** (righe
  47, 49). Alla riga 31 lo stesso oggetto compare come «**i livelli di Larry**».
  👉 `[INFERITO]` da questi due passaggi: è **lo stesso indicatore**, e "RERRI" è
  la storpiatura di **"Larry"**. ⚠️ Non lo do per certo — **e non uso la mia
  memoria per deciderlo**: se serve, chiedere a Claudio il nome esatto
  dell'indicatore nella sezione "indicatori" di Circle.
- **Il meccanismo è chiaro comunque** `[TRASCRITTO chiaro]`: sono **livelli di
  supporto/resistenza etichettati per TIMEFRAME**, e la confluenza si conta per TF.
  - riga 47: «Qui ci sono **tre livelli** […] qui abbiamo un livello **H1, H4 e D1**»
  - riga 89: «qui abbiamo una **resistenza in H12**, qui una **resistenza in D1**,
    pertanto questa è una **bella zona** da considerare come un punto possibile di
    rimbalzo. Vedete? **H12, D1, Supertrend**, se la media 200 arriva in questa
    zona, qui un rimbalzo di Supertrend **ci sta tutto**»
  - riga 131: «qui c'è una **resistenza monthly** […] Pertanto ho una **resistenza
    forte** qua»
  - riga 263: «Abbiamo qua una resistenza **H4-H1**, qui abbiamo delle altre, qui
    abbiamo un **H12**»
  - **Gerarchia dichiarata** `[INFERITO]` da 47+89+131: più alto è il TF del
    livello, più pesa (monthly > D1 > H12 > H4 > H1).

### 🔢 QUANTE confluenze servono — la risposta

**Non c'è una soglia numerica esplicita per la validità.** C'è però un numero
dichiarato **per il caso specifico**, ed è **TRE**:

Riga 125, testuale (risposta diretta a un allievo):
> «**No, se avessi avuto la TERZA confluenza** perché avevo la media e
> quell'altro **io normalmente cerco anche una resistenza o un pibonacci
> favorevole**, capito?»

Cioè: ST + EMA200 = **due**, non basta; serve **almeno un terzo** fra S/R e
Fibonacci. `[TRASCRITTO chiaro]`, `[INFERITO]` la generalizzazione a "3 minimo".

E la regola qualitativa, ripetuta tre volte `[TRASCRITTO chiaro]`:
- riga 111: «**In questo caso non avrei avuto delle confluenze e non l'avrei
  fatta**, perché non ho la media a 200, ho il super trend, non ho Fibonacci»
- riga 117: «bisogna **non farsi prendere dalla FOMO** e bisogna **sempre cercare
  la massima confluenza dei fattori positivi** che ci sostengano il nostro trend»
- riga 143: «**Noi dobbiamo andare a cercare il numero di confluenze. Più
  confluenze importanti hai su quel livello, più sicuro, più probabile è la
  possibilità che il prezzo venga respinto.**»
- riga 137: «Il rimbalzo è tanto più probabile quanto **il muro è più solido**. La
  solidità gli dà la **confluenza tecnica** con gli altri fattori.»

### 🧭 La sequenza operativa dichiarata (riga 123) — testuale

> «Il percorso logico che noi dobbiamo fare è sempre lo stesso.
> **Primo, esiste una configurazione di trend favorevole?**
> **Secondo**, trovata la configurazione di trend favorevole **esistono più
> confluenze che sostengono il mio trigger**?
> A questo punto, se ho queste confluenze, **prima di mettere l'ordine metto lo
> stop e mi vado a cercare il punto tecnico dove metterlo**.
> Una volta individuato il punto tecnico […] a questo punto **calcolo la size in
> base al mio livello di rischio** e vedo, anzi prima di calcolare la size, **il
> profit che mi garantisce un rischio di rendimento almeno 1 a 1**, se ho tutte
> queste condizioni **calcolo la size e metto il mio ingresso**.»

📌 Ordine dichiarato: **trend → confluenze → STOP TECNICO → verifica RR ≥ 1:1 →
size → ingresso**. Lo stop viene **prima** della size, mai il contrario (riga 121:
«**la size si determina sempre in funzione da dove mettiamo lo stop**»).

⚠️ **`RR ≥ 1:1` è UN NUMERO CHE STONA** — vedi § Contraddizioni.

### 🔀 Il filtro madre: SOLO a favore del trend di fondo

Riga 109, testuale:
> «**nel mio piano di trading** […] Ve l'ho sempre detto, **io cerco sempre di
> fare operazioni a favore di trend, non operazioni contro trend.**»

Applicato in diretta a un esempio che **sarebbe andato in profitto** e che rifiuta
lo stesso (riga 95):
> «il rimbalzo massimo è stato […] **di 80 pip**, per tanto **questo è andato in
> profit, però io non l'avrei fatta perché arrivavo da un trend crescente,
> solido, perché avrei fatto un reversal contro trend**»

💡 **Nota metodologica notevole:** rifiuta un trade **vincente** perché viola la
regola. È l'unico passaggio della serata in cui la disciplina batte il risultato —
e vale più di tutti i numeri di performance del file.

E la ragione asimmetrica (righe 227-231):
> «**se te lo fai in direzione di trend, in qualsiasi punto entri tu sei sicura di
> non andare in stop. Se la fai contro trend non lo recuperi più.** […] Andrai in
> slow down [drawdown] **ma poi il prezzo ti torna a tuo favore**. […] Per
> recuperare questo punto, che è il **24 ottobre 2021**, devi aspettare che il
> prezzo arrivi al **primo gennaio del 2023, dopo un anno e mezzo**.»

🚩 **BANDIERA ROSSA METODOLOGICA:** «in qualsiasi punto entri **sei sicura di non
andare in stop**» + «andrai in drawdown ma poi il prezzo ti torna a favore» è, in
sostanza, la **giustificazione teorica del non usare stop / dell'aspettare che
torni**. Detto da un discrezionale su TF weekly può reggere; **per noi è
esattamente il ragionamento che brucia una challenge** (un DD del 25% è un fatto
accaduto, regola B dell'emendamento). **Da NON portare in casa in nessuna forma.**

---

## 3️⃣ ADR (Average Daily Range) — lo spunto meccanizzabile 🏆

**Noi non usiamo l'ADR da nessuna parte** (verificato: `grep -i "ADR"` su
`REGISTRO_TEST.md` e `HANDOFF.md` → **solo due righe, ed entrambe sono IDEE MAI
IMPLEMENTATE**, righe 228 e 243, e riguardano il motore APERTURE, non i reversal).
Qui invece Paolo lo usa **tre volte, in tre modi diversi**, tutti dettati a voce.

### Definizione e strumento

| Cosa | Dichiarato | Citazione |
|---|---|---|
| Sigla | **A**verage **D**aily **R**ange | «**L'ADR vuol dire Average Daily Range**» (riga 71) |
| Definizione | media del movimento giornaliero | «È **la media del movimento che fa il prezzo ogni singolo giorno**» (riga 69) |
| Formula dettata | media dell'**escursione massima** delle candele daily | «Prende la **media dell'estensione massima della candela degli ultimi 50 giorni**» (riga 77) |
| **Lookback** | **50 giorni** | «Questa ADR non mi ricordo quant'è, **50 giorni** pare. **50 giorni, l'abbiamo trattato sempre così. Range Analysis, 50 giorni**» (riga 79) `[TRASCRITTO chiaro]` — esita, poi conferma due volte |
| Indicatore | **"Range Analysis"** | «un indicatore […] **che si chiama Range Analysis**» (riga 71); «Quando voi lo caricate in Range Analysis, lo trovate con **questo pulsantino in alto a destra, ADR**» (riga 73) |
| Cosa disegna | 5 righe | «La **riga azzurra centrale è il livello di apertura del prezzo nella data odierna**» (riga 75) + due righe a **½ ADR** e due a **ADR pieno**, sopra e sotto (righe 81-83) |
| Riferimento temporale | **apertura di mezzanotte** | «se si va **qui a mezzanotte, questo è il punto di apertura del prezzo**» (riga 77) — ⚠️ mezzanotte di **quale fuso NON è dichiarato** → `[INCERTO]`, vedi § Fusi |

### I TRE usi dichiarati

**(a) 🎯 VALIDARE che il target sia raggiungibile in giornata**
> «se io metto un'operazione e quel prezzo mi va a testare la nostra media, **il
> rimbalzo che io mi aspetto nella giornata sarà analogo a quello che può essere
> l'ADR di quel prezzo**» (riga 71)
> «**Pertanto qualora gli avessi ipotizzato stamattina di fare un'operazione
> reversal su Supertrend aspettandolo a questo livello, questo era un livello
> raggiungibile.**» (riga 83)
> «Siamo a **una distanza compatibile con l'ADR**» (riga 247)
> «si ha una **distanza più o meno compatibile con l'ADR** se dovesse arrivarsi»
> (riga 91)

**(b) 🛑 STOP a METÀ ADR** — il numero più netto:
> «devi mettere **perlomeno una ventina di punti dalla media a 200, a metà
> dell'ADR. L'ADR è 50, devi mettere a 25 punti.**» (riga 113) `[TRASCRITTO chiaro]`

**(c) 🎯 TARGET al livello ADR:**
> «Io come obiettivo metto **60 punti della DR**. Sì, **è ragionevolmente
> raggiungibile**.» (riga 153) — nell'esempio l'ADR era 60 («La DR quant'è? **60**»,
> riga 149) `[TRASCRITTO chiaro]` — "DR" = ADR

### 🔴 ERRORE ARITMETICO NEL PARLATO (o nella trascrizione)

Riga 83, testuale:
> «Abbiamo una riga che rappresenta **la metà di 55 pip**, pertanto dalla linea
> blu a questa linea in questo caso sono **22,5 pip**.»

**55 / 2 = 27,5, non 22,5.** `[TRASCRITTO dubbio]` — o ha detto 27,5 e la
trascrizione ha storpiato, o ha sbagliato il conto a voce. **Il MECCANISMO (½ ADR)
è chiaro; il numero dell'esempio no.** Confermato dall'altro esempio, dove il
conto torna: «L'ADR è 50, devi mettere a **25 punti**» (riga 113). ✅ **Il
meccanismo è ½ ADR.**

### Altri valori ADR citati negli esempi

| Strumento | ADR dichiarato | Riga | Nota |
|---|---|---|---|
| (non nominato) | **55 pip** | 77-83 | «il prezzo negli ultimi 50 giorni ha fatto **una media di 55 pip al giorno**» |
| (non nominato) | **50 pip** | 95, 113 | «a fronte di un'**ADR di 50 pip**» |
| "Odicad" (**AUDCAD** `[INCERTO]`) | **50 pip**, movimento reale **63 pip** | 91 | «ho messo Odicad, a Odicad quanto c'è di **50 pip di HDR**? […] da qua a qua giù ci sono **63 pip**» |
| (non nominato) | **60 pip** | 149-153 | «La DR quant'è? **60**» |
| (non nominato) | **200 pip poi 100 pip** | 129 | «Mi vado a vedere quant'è l'**ADR 50** […] **A 200 pip**. Bisogna vedere quanti giorni sono […] **da qui a qui sono 100 pip**» — `[TRASCRITTO dubbio]`, passaggio confuso |

---

## 4️⃣ MECCANISMI DI GESTIONE DICHIARATI

| Meccanismo | Valore | Citazione | Etichetta |
|---|---|---|---|
| **Parzializzazione** | **1/3 – 2/3** | «Un terzo o due terzi, vero? **Un terzo o due terzi qua, qua parzializzi, porti lo stop in pari**» (riga 287) | `[TRASCRITTO chiaro]` |
| Punto della parziale | **Fibo 38,2** | «**La mia prima parzializzazione la metterò sul 38.2**» (riga 275) | `[TRASCRITTO chiaro]` |
| **Stop a pari** dopo parziale | sempre | «Io a 17 punti **metto la parzializzazione e mi porto lo stop in pari. E come money management sto tranquillo**» (riga 281); ribadito riga 287 | `[TRASCRITTO chiaro]` — 3 occorrenze |
| **Doppio ingresso** | 1° a mercato/pendente + 2° a **20-25 pip** | «doveva mettere un **primo ordine** qua e un **secondo ordine** più o meno […] l'avrei messo più o meno a **20-25 pip** da questo punto» (riga 107); «È detto che metto **un ordine qua, un ordine qua** che sono in **golden area**» (riga 269) | `[TRASCRITTO chiaro]` |
| **Stop MAI meccanico** | livello tecnico | «**Non lo metto in punti, lo metto a livello tecnico**» (riga 255); «**Lo stop lo devi considerare a livello tecnico, dove c'è una zona di liquidità**» (riga 253); «gli indicatori li possiamo tenere molto, però **gli stop loss dobbiamo impararli a cercare noi, a cercarli noi i livelli**» (riga 119) | `[TRASCRITTO chiaro]` — 3 occorrenze |
| Dove, in concreto | sotto la **cuspide** / sotto il minimo / sotto la linea di liquidità | «Lo stop lo andiamo a mettere in questo caso **sotto la cuspide**» (riga 251); «**Questa è la linea di massima liquidità**» (riga 107); «lo vai a mettere **sopra questo massimo**» (riga 187); «sotto il **78,6**» (riga 261) | `[TRASCRITTO chiaro]` |
| **Uscita anticipata su flip ST** | sì, ammessa | «mentre abbiamo l'operazione in macchina, il super trend ci cambia colore **a sfavore** della nostra posizione, **possiamo permetterci di uscire anticipatamente? Certo.**» (riga 145) | `[TRASCRITTO chiaro]` |
| **Size in funzione dello stop** | sempre | «**Allontanandosi molto dal livello dobbiamo diminuire la size**, perché **la size si determina sempre in funzione da dove mettiamo lo stop**» (riga 121); «**O sennò dobbiamo allargare il trend, diminuire la size di ingresso e aumentare molto lo stop**» (riga 117) | `[TRASCRITTO chiaro]` |
| **Take profit su S/R** | sì | «quando sei in time frame così alti, **i take profit li metti sempre sulle resistenze/supporti? Certo, ragiono.**» (riga 269) | `[TRASCRITTO chiaro]` |
| **RR minimo** | **1:1** | riga 123 (citata sopra) | 🔴 `[TRASCRITTO chiaro]` ma **incoerente** — vedi Contraddizioni |
| **Studio serale, ordini al mattino** | routine dichiarata | «**lo studio serale lo potete fare, cioè la sera voi potete studiare quello che può verificare il giorno dopo**» (riga 91); «uno se le può studiare la sera e poi **entra al mercato magari dopo due giorni**» (riga 183); «**Io domattina metto gli ordini e poi vediamo dopo domani come andrà a finire**» (riga 289) | `[TRASCRITTO chiaro]` |
| **Anti-FOMO** | esplicito | «**Ti dici di conto che qui siamo in D1 perché qui siamo dopo due giorni e non ti fai prendere da FOMO**» (riga 187) | `[TRASCRITTO chiaro]` |
| **Non essere meccanici** | esplicito | «Qua bisogna anche un po' ragionare, **non bisogna essere meccanici**» (riga 267) | `[TRASCRITTO chiaro]` — ⚠️ è la frase che segna il confine fra il suo lavoro e il nostro |

### 🌊 Teoria del movimento (contorno, non meccanizzabile così com'è)

- **Onde**: «il prezzo si muove **sempre ad onde**, il prezzo per andare da A a B
  **non va mai in modo diritto**» (riga 197)
- **Trend sano**: «Quando **il ritracciamento è fatto più o meno allo stesso
  livello dell'espansione precedente, il trend è sano**. […] **non devono mai
  rimanere spazi vuoti** […] non devono mai rimanere **spazi senza negoziazione**»
  (riga 199) `[TRASCRITTO chiaro]` — 💡 questa è di fatto una **regola sui gap /
  imbalance**, e noi abbiamo già `ABTG_GapFill` / `ABTG_GapContinuation`
- **Esaurimento**: «**Quando il ritracciamento tende a diminuire** […] **Il
  movimento sta esaurendo**» (riga 57) `[TRASCRITTO chiaro]` — meccanizzabile:
  ritracciamenti in contrazione = fine trend
- **Change of character**: «Quando il prezzo va a chiudere il suo movimento
  **sopra l'ultimo minimo**, cosa abbiamo? **Un cambio di carattere**» (riga 59)
- **Frattalità**: «all'interno di un movimento unico c'è tanti movimenti secondari.
  **Questo concetto si chiama frattalità**» (riga 203)
- **Espansione/riposo/espansione** attribuito a «un certo signore **Weikoff**»
  (riga 201) `[TRASCRITTO dubbio]` sul nome; «fa un movimento espansivo, fa una
  fase di **riposo** e poi fa un altro movimento espansivo. **Normalmente qui il
  super trend inverte**» (righe 201-207) — 💡 **il flip del ST in fase di riposo è
  un FALSO segnale**: altro filtro potenziale.

---

## 5️⃣ NUMERI DI PERFORMANCE — tutti [DICHIARATI, NON VERIFICATI]

_Nessuno di questi è un backtest, un track record o un conto: sono **letture a
posteriori su grafico**, fatte a voce durante la lezione. Si registrano, **non
pesano**._

| Numero | Citazione | Riga |
|---|---|---|
| **80 pip** di rimbalzo | «il rimbalzo massimo è stato […] di **80 pip**» — e lui **non l'avrebbe fatta** | 95 |
| **500 pip** | «uscito qua, aveva fatto **500 pip**» | 165 |
| **800 pip** | «avesse avuto un altro bel movimento di **altri 800 pip**» | 167 |
| **1.300 €** con lotto **0.10** | «queste potevano essere **due operazioni** che con un ingresso di **0.10** uno faceva **1.300 euro**» | 167 |
| **158 pip** | «Movimento di quanto? Di **158 pippe**» | 179 |
| **154 punti** | «questo è un **profitto da 154 punti**» | 187 |
| **340 punti** | «è un ritracciamento di **340 punti**» | 225 |
| **86 pip** | «tra super trend e questa EMA ci sono **86 pip**» | 169 |
| Short di **1 anno e mezzo** | «inizia il **6 di giugno di maggio del 2021** e finisce il **23 di ottobre del 2022**. **Dura un anno e mezzo**» — `[TRASCRITTO dubbio]` sulla data («6 di giugno di maggio») | 221 |
| **10 pip / 20 pip** sul doppio ordine | «se mi entra questo qua ho fatto **10 pippe di profitto**. Se mi entra il secondo ordine ne faccio **20**» | 275 |
| Stop **11 / 14 / 17 punti** | tre numeri per **lo stesso setup** — vedi Contraddizioni | 251, 275, 279 |

⛔ **Zero prop citate. Zero regole prop. Zero challenge. Zero EA. Zero trucchi
anti-prop.** La lezione è puramente discrezionale-manuale: **la sezione "REGOLE
PROP CITATE" della griglia di casa è VUOTA per questo file**, e va detto.

---

## 6️⃣ 🖥️ COSA C'ERA A SCHERMO E NON NEL PARLATO — le domande per Claudio

_La trascrizione è **solo audio**. Tutto quanto segue è stato **mostrato e non
dettato**: NON lo conosciamo._

| # | Cosa | Minuto/riga | Cosa chiedere |
|---|---|---|---|
| 1 | 🏆 **Dashboard "Supertrend V6"** — «Mettiamo la dashboard, **dashboard supertrend V6**, eccola qua» (riga 241); «**Questa è Supertrend e la media. Questa è Supertrend e Inverter**» (riga 303); «Dico, è possibile avere questa dashboard che hai tu? Sì […] **Comunque ve la do questa dashboard**» (riga 299-303) | ~riga 241 e ~riga 303 | **SCREENSHOT delle colonne della dashboard.** Sembra un pannello multi-simbolo/multi-TF con DUE modalità (ST+media / ST+Invert). Se Paolo l'ha distribuita, **chiedere anche il FILE**: è la stessa strada da cui è nato `ABTG_SuperWave` (registro riga 397: «Nuovo EA **dalla dashboard SuperWave**»). Precedente vincente. |
| 2 | **Indicatore "Range Analysis"** — pannello di configurazione: dice "50 giorni" ma **esita** («non mi ricordo quant'è, 50 giorni pare», riga 79) | ~riga 73-79 | **Screenshot del pannello input**: lookback esatto, se usa High-Low o True Range, se esclude weekend/festivi. **Serve per implementare l'ADR correttamente.** |
| 3 | **Indicatore S/R multi-TF ("RERRI"/"Larry")** | ~righe 47-49, 89, 263 | **Nome esatto + screenshot dei settaggi.** Come calcola i livelli? Frattali? Massimi/minimi di periodo? È il pezzo che ci manca per la confluenza #4. |
| 4 | Indicatore **"gnasci" / "H3Mode" / "Switch mode"** — «mettiamo **le gnasci** […] Vedi il trend, **doji, ripartenza**. Pertanto questo era un movimento **confermato anche dalle gnasci**» (righe 173-179) | ~riga 173-179 | ⁉️ Nome completamente illeggibile nella trascrizione. `[INCERTO]`. **Screenshot.** Dal contesto (doji, colore, conferma di trend) sembra un pannello a candele filtrate, ma **non lo deduco**. |
| 5 | **Gli STRUMENTI degli esempi** — mai nominati chiaramente: «un RGB bio», «un **EUROSDK**» (riga 43), «**Odicad**» (riga 91), «**auditi HF**» (riga 245), «Tu **audì**, mi sa che stanotte c'è notizia» (riga 291) | varie | Gli ADR (50/55/60 pip) sono **inutilizzabili senza sapere il simbolo**. `[INCERTO]` su tutti. Se serve validare i numeri, servono gli screenshot. |
| 6 | **Le 3 combinazioni ST caricate** sul grafico | ~riga 41 | Screenshot: verificare che i tre siano davvero **2.5/10, 3/10, 3.5/10** e non abbiano ATR diversi. |
| 7 | I **tre documenti di outlook settimanale** postati da Emiliano (fondamentale + COT + geopolitica) — «**Qui mi hanno messo tre documenti sull'outlook settimanale**» (riga 299) | ~riga 297-299 | **Sono documenti, non video.** Se servono, si scaricano da Circle. Contenuto dichiarato: «Audì l'outlook di questa settimana **lo dà debole** e il **[USD] la dà forte**» (riga 295). |
| 8 | Sezione **"slide di ripasso operativo"** e **"registrazioni"** su Circle, numerate per argomento (righe 11-13) | ~righe 11-13 | 📚 **Indice completo del corso, già esistente.** Vale la pena chiedere a Claudio uno screenshot dell'elenco: dice quali argomenti esistono e quali ci mancano. |

---

# 🔗 SINTESI INCROCIATA — CORSO ↔ REPO

## A. 📊 TABELLA DEI VALORI CONVERGENTI (SuperTrend)

⚠️ **Avvertenza sull'indipendenza delle fonti:** Paolo ed Emiliano sono **lo
stesso corso**. Le loro affermazioni **NON sono due fonti indipendenti** — sono
una sola. L'unica vera verifica incrociata qui è **corso ↔ NOSTRE MISURE
real-tick**, che sono indipendenti per costruzione.

| Parametro | 📚 CORSO (Paolo, dichiarato) | 🔬 NOSTRO (misurato real-tick, R5v e successivi) | Verdetto |
|---|---|---|---|
| **StMult** | **3.5** «l'evento più forte» (riga 25) | **DAX H1: 3.5** (solo 3.5 positivo, 4/8; «StMult 3.0 tutte negative», registro riga 110) · **DOW H4: 3.5** (PF 2.77, riga 340) · **DOW H1: 3.5** (riga 342) · **DAX H4: 3.0** (riga 107) · **NAS H1: 3.0** (riga 108) · **CAC H4: 2.5** («StMult 3.0 negativo», riga 345) | 🟡 **CONVERGENZA PARZIALE, 3 sedie su 6.** Il 3.5 è il valore migliore su DAX H1, DOW H4 e DOW H1. Ma **NON è universale**: su CAC H4 il 3.5 è battuto dal 2.5, su NAS H1 e DAX H4 dal 3.0. **Il "più forte" del corso è vero per metà del parco.** |
| **ATR period** | **10** (sempre, in tutti e tre i caricamenti) | **10** su DAX H1, NAS H1 · **9** su DAX H4, DOW H1, CAC H4 · **8** su DOW H4 | 🟢 **CONVERGENZA BUONA.** 10 è il centro del nostro altopiano (griglia 8-10) e il valore del corso. Nessun conflitto. |
| **Il caso NAS H1** | 3.5 «il più forte» | **8/8 combo positive** (registro riga 112, ⭐) su griglia `3.0/3.5 × AtrP 9/10 × TP_RR 2.5/3.0`. **Cella scelta: 3.0/10/3.0** | 🟢🟡 **Doppia lettura, va detta bene.** Il 3.5 su NAS H1 **è positivo** (fa parte dell'8/8): il corso non è smentito. Ma la cella promossa è **3.0**, scelta col **centro dell'altopiano, MAI il picco**. 👉 **Divergenza di UN gradino sul parametro, non sul motore.** E la nostra è **misurata**, la sua è **dichiarata**: a parità di dubbio, vince il numero misurato. |
| **Timeframe** | **H4 → Weekly**; «i trend più forti sono in H4 e in D1» | Sedie vive: **H1** (NAS, DOW, DAX) e **H4** (DAX, DOW, CAC, oro, Nikkei). **M5 morto** (registro: DAX M5 «0% pos, DD 30-37%», NAS M5 «5% pos») | 🟢 **CONVERGENZA FORTE sul lato basso.** Il corso dice "H4 e su"; noi abbiamo **misurato** che M5 è morto e che H1/H4 funzionano. **Stessa conclusione, per due strade.** ⚠️ **BUCO SIMMETRICO: D1 e W1 — che il corso indica come i MIGLIORI — noi non li abbiamo MAI misurati sul SupRev.** |
| **Conferma candela successiva** | corpo intero oltre + **stesso colore** | `InpRequireConfirmBody = true` («candela di conferma coerente (corpo in direzione)», SupRev riga 57) | 🟢 **CONVERGENZA — con un DELTA.** Noi chiediamo il **corpo in direzione**; lui chiede **apertura E chiusura entrambe oltre la linea** + stesso colore. **La sua è più stringente.** → Spunto S5. |
| **Confluenza EMA** | **EMA 200** (+ 50/100 su TF alto) | `InpUseConfluence=true`, EMA **14/89/100/200**, «vicino» = `≤1.5×ATR` (SupRev righe 62-67) | 🟢 **CONVERGENZA — noi siamo già PIÙ RICCHI.** Abbiamo 4 EMA dove lui ne nomina 1-3. ✅ Nessuna azione. |
| **Ingresso frazionato** | 1° ordine + 2° a **20-25 pip** | `InpFirstFraction=0.3333` (1/3 a mercato) + `InpUsePending=true`, `InpPendingPips=20` (SupRev righe 70-73) | 🟢 **CONVERGENZA QUASI PERFETTA.** Noi 20 pip, lui «20-25». **Il codice già implementa la lezione di stasera.** ✅ |
| **Parzializzazione** | **1/3 – 2/3** al primo target | `InpTP1Pct = 50` — **50%** a 1R (SupRev riga 79) | 🟡 **DELTA REALE.** Lui chiude 1/3 (33%) e lascia correre 2/3; noi chiudiamo 50% e lasciamo 50%. → Spunto S4. |
| **Punto della parziale** | **Fibo 38,2** del movimento | **1R** (`InpTP1_R = 1.0`) | 🟡 **DELTA STRUTTURALE.** Il suo target è **geometrico** (livello di prezzo), il nostro è **in rischio** (multiplo di R). Il suo è agganciato al mercato, il nostro allo stop. → Spunto S4. |
| **Stop a pari dopo parziale** | sì, sempre | `InpBreakeven = true` (SupRev riga 80) | 🟢 **CONVERGENZA PIENA.** ✅ |
| **Uscita su flip ST** | «Certo» (riga 145) | `InpExitOnFlip = true` (SupRev riga 83) | 🟢 **CONVERGENZA PIENA.** ✅ |
| **Trailing sul ST** | non dettato esplicitamente stasera | `InpTrailOnST = true` (SupRev riga 82) | ⚪ Noi facciamo di più. Nessun conflitto. |
| **Stop tecnico** | livello tecnico / cuspide / liquidità, **mai in punti** | `InpSLLookback=5` (min/max delle ultime 5 barre) + `InpSLBufferPips=3` (SupRev righe 76-77) | 🟢 **CONVERGENZA CONCETTUALE.** Il nostro "min/max 5 barre + buffer" **È** un livello tecnico automatizzato: la traduzione meccanica del "sotto la cuspide". 👍 Siamo già allineati, e senza discrezionalità. |
| **Fibonacci golden area** | 38,2-61,8 ingresso / 78,6 invalidazione | ❌ **ASSENTE** dai SupRev | 🔴 **DELTA VERO** → Spunto S3 |
| **S/R multi-TF** | H1/H4/H12/D1/Monthly pesati | ❌ **ASSENTE** dai SupRev | 🔴 **DELTA VERO** → Spunto S6 |
| **Filtro trend TF superiore** | obbligatorio (3 TF di Dow) | ❌ **ASSENTE** dai SupRev (le EMA sono sul TF operativo) | 🔴 **DELTA VERO** → 🏆 Spunto S1 |
| **ADR** | 3 usi (validazione target / stop ½ADR / target ADR) | ❌ **ASSENTE ovunque** — solo idea mai implementata (registro righe 228, 243) | 🔴 **DELTA VERO** → 🏆 Spunto S2 |
| **RR minimo** | **1:1** (riga 123) | `InpTP_RR = 3.0` sulle sedie vive; commento del codice: «documento: **RR ≥ 1:2**» | 🔴 **CONTRADDIZIONE** — vedi sotto |
| **Filtro news** | «non si trada» sul simposio, «guardare sempre che non ci sono le notizie» | `InpUseNewsFilter = false` su tutta la flotta | 🔴 **DIVERGENZA APERTA** — R101 ha messo news OUT per criterio. La rete è il Guardian. → riga B1 |

## B. ⚡ CONTRADDIZIONI (dichiarate, non risolte)

| # | Contraddizione | Prova |
|---|---|---|
| 1 | 🔴 **RR: «almeno 1 a 1» vs «≥ 1:2» del documento vs `TP_RR 3.0` misurato** | Riga 123: «il profit che mi garantisce **un rischio di rendimento almeno 1 a 1**». Il commento nel nostro `ABTG_SupertrendReversal.mq5` riga 81 dice «documento: **RR >= 1:2**» — cioè **il materiale scritto del corso dice il doppio di quello che ha detto a voce stasera**. E le nostre celle validate girano tutte a **TP_RR 3.0**. 👉 **Un RR 1:1 su un reversal è, per i nostri numeri, la ricetta per un PF < 1.** Il numero dettato stasera **NON va portato in casa.** |
| 2 | 🔴 **Lo stop dello stesso setup vale 11, 14 o 17 punti** | Riga 251: «Quanti punti sono di stop? Sono **11 punti** di stop». Riga 275: «Qui come stop ho **14 punti**». Riga 279: «Ma **17 punti** non sono troppo pochi». Riga 281: «Io a **17 punti** metto la parzializzazione». `[TRASCRITTO dubbio]` su tutti e tre — ma **non c'è modo di sapere quale sia giusto**. Ennesima prova che i numeri dettati a voce su grafico non sono dati. |
| 3 | 🟡 **Predica H4-Weekly, trada M3** | Riga 67 «Time frame consigliati: da H4 a Weekly» vs riga 305 «il tuo cavallo di battaglia è ancora la strategia DAX M3? **Sì, sì**». |
| 4 | 🟡 **Insegna il Reversal, ma dichiara di non farlo** | Riga 301: «**io questa strategia la faccio poco. Io preferisco fare Supertrend e Inverter**». La lezione di 320 righe è sul motore che il docente **non usa**. |
| 5 | 🟡 **Il 3.5 è "default" o è "una scelta"?** | Riga 25: «la modalità **standard** […] è 3/10» → poi «noi useremo il 3.5 perché è l'evento più forte». Riga 41: «la prima volta **di default è 3.5**». Due "default" diversi a 16 righe di distanza. `[TRASCRITTO dubbio]` — probabilmente "default" alla riga 41 significa "come ve l'ho mandato io". |
| 6 | 🟡 **Fibo invalidazione: 71,8 o 78,6?** | Riga 55 dice **71,8**; righe 131, 261, 265 dicono **78,6/78**. **Vince il 78,6** (3 occorrenze contro 1). |
| 7 | 🟡 **½ di 55 = 22,5** | Riga 83. Errore aritmetico o di trascrizione. Il meccanismo (½ ADR) regge, il numero no. |
| 8 | 🟠 **vs Emiliano 24/08 — data di Jackson Hole** | La scheda del 24/08 registra «giovedì 27 e venerdì 28». Paolo qui dice solo «**venerdì**» e «fine agosto» (righe 293-295), dopo aver prima detto «più avanti mi sembra». **La data 27/28 NON è in questa trascrizione.** |
| 9 | 🟠 **vs Emiliano 24/08 — il piano operativo** | Il 24/08 il materiale era tutto **intraday su indici** (ORB M5/M15 sul DAX, volumi, slippage sugli stop in apertura). Il 25/08 Paolo è tutto **swing forex H4-Weekly** con posizioni «che stanno in macchina» giorni o settimane (riga 183: «entra al mercato **magari dopo due giorni**»; riga 239: «l'operazione che faccio anche **due settimane** a volte»). **Non si smentiscono — sono due mestieri diversi nello stesso corso.** Da tenere presente quando si incrociano: **una regola detta da Emiliano sull'intraday NON vale automaticamente per il SupRev H4.** |
| 10 | ⚪ **Attribuzioni storpiate** | «creato da un certo **Oliver Swan**» (riga 17, autore del SuperTrend), «il teorema di Dow ripreso da **Helder**» (riga 159), «un certo signore **Weikoff**» (riga 201). Tutti `[TRASCRITTO dubbio]`. **Non li correggo dalla mia memoria** — non è una fonte. Irrilevanti per l'operatività. |

## C. 🏗️ CONFRONTO COL REPO — dove siamo già avanti

_Da non riscoprire: già letti `REGISTRO_TEST.md`, `HANDOFF.md`,
`ANALISI_LIVE_EMILIANO_2026-08-24.md`, `PULIZIA_VPS_10-08.md`._

✅ **Cose che il corso insegna stasera e che i nostri EA GIÀ FANNO** (verificate
nel sorgente, non a memoria):
1. Conferma sulla candela successiva → `InpRequireConfirmBody`
2. Confluenza con le EMA (e noi ne abbiamo **4**, lui **1**) → `InpUseConfluence` + EMA 14/89/100/200
3. Ingresso frazionato 1/3 + pendente a 20 pip → `InpFirstFraction` + `InpPendingPips`
4. Parziale al primo target + **stop a pari** → `InpTP1Pct` + `InpBreakeven`
5. Uscita se il ST gira contro → `InpExitOnFlip`
6. Trailing sulla linea ST → `InpTrailOnST` (lui non l'ha nemmeno nominato)
7. Stop su livello tecnico (min/max 5 barre + buffer) → `InpSLLookback` + `InpSLBufferPips`
8. StMult 3.5 / ATR 10 → **è il DEFAULT nel codice di entrambi** gli EA

📌 **Traduzione: la lezione di stasera è, per 8 punti su 8 della gestione, il
manuale del nostro `ABTG_SupertrendReversal.mq5` — che era già stato scritto DAL
DOCUMENTO dello stesso corso.** Nessuna sorpresa, e nessuna correzione da fare.
**Il valore nuovo della serata sta tutto nei 6 DELTA** (multi-TF, ADR, Fibonacci,
frazione della parziale, conferma più stringente, S/R multi-TF) + nella bandiera
sull'**Invert**.

---

# 🎯 GLI SPUNTI — TABELLA ORDINATA

_⚠️ Regola di casa, senza eccezioni: **NESSUNA modifica al forward. Proposte sì,
azioni no.** Tutto quanto segue è materiale per l'imbuto, non per il VPS._

| # | Spunto | Meccanizzabile? | Dove nell'imbuto | Cosa serve | Priorità |
|---|---|---|---|---|---|
| **S1** | 🌊 **Filtro TREND DI FONDO su TF superiore** (teorema dei 3 TF): il SupRev H1 entra solo se il TF superiore (H4 o D1) è concorde — ST e/o prezzo vs EMA200 del TF alto | ✅ **SÌ, facilissimo** — un solo handle `iMA`/ST sul TF superiore + un `if` | **G1** (gradino singolo, on/off). Griglia minima: `off / ST-H4 / EMA200-D1 / entrambi` | Solo ricompilare. **Non serve dato nuovo.** Sedie su cui misurarlo: NAS H1, DAX H1, DOW H4 | 🔴 **ALTA** |
| **S2** | 📏 **ADR (50 gg) come filtro e come sizing del target**: (a) skip se il target è > ADR residuo della giornata, (b) SL minimo = ½ ADR, (c) TP = livello ADR | ✅ **SÌ** — ADR = media 50 giorni di `High-Low` daily. 15 righe di codice | **G1**, tre gradini SEPARATI (mai insieme: si misura un fattore per volta) | Implementare la funzione ADR. ⚠️ Prima **chiedere a Claudio lo screenshot del pannello "Range Analysis"** (High-Low o True Range?) | 🔴 **ALTA** |
| **S3** | 🏆 **`ABTG_SupertrendInvert` PORTATO SUGLI INDICI** — è già scritto, coi default 3.5/10, filtri STRONG+ADX+Stoch+anti-estensione e gestione completa. Bocciato SOLO su oro H1 | ✅ **SÌ — codice già pronto**, zero sviluppo | **Screen OHLC** su DAX/NAS/DOW/CAC × H1/H4 (la stessa scaletta che ha fatto vivere il SupRev, registro §"SupRev su NUOVI INDICI") → poi real-tick sui sopravvissuti | Una corsa di ottimizzazione. Griglia: `StMult 2.5/3.0/3.5 × AtrP 8/9/10 × RequireStrong on/off` | 🔴 **ALTA** |
| **S4** | ✂️ **Frazione della parziale 1/3 vs 1/2** (`InpTP1Pct` 33 vs 50) + **target della parziale**: 1R (nostro) vs Fibo 38,2 (suo) | ✅ SÌ il primo (è già un input!) · 🟡 il secondo richiede il calcolo del ritracciamento | **G1**, gradino di GESTIONE. Fila naturale dietro alla domanda già aperta di Claudio sul trailing (vedi spunto 3 della scheda Emiliano 24/08) | La parte `InpTP1Pct` **non serve nemmeno ricompilare**: è un input. Corsa a 3 valori: 33 / 50 / 67 | 🟡 MEDIA |
| **S5** | ✅ **Conferma più stringente**: oggi `corpo in direzione`; sua versione = **apertura E chiusura entrambe oltre la linea ST + stesso colore** | ✅ SÌ, poche righe | **G1**, gradino singolo on/off sul SupRev | Ricompilare. Attenzione: **irrigidire il filtro riduce i trade** → su NAS H1 (155 trade) e DAX H4 (86 trade) si rischia di scendere sotto i **150 dell'emendamento**. Misurare il costo in operazioni | 🟡 MEDIA |
| **S6** | 🧱 **S/R multi-TF pesati per timeframe** (monthly > D1 > H12 > H4 > H1) come confluenza aggiuntiva | 🟡 **PARZIALE** — dipende da come sono costruiti i livelli, e **quello NON è dettato** | **Non entra ancora nell'imbuto.** Prima serve la definizione | 📷 **Screenshot dell'indicatore "RERRI"/"Larry"** + suoi settaggi. Senza, non si implementa niente di sensato | 🟡 MEDIA |
| **S7** | 🥇 **Filtro PRIMO TOCCO**: «se il ST non è mai stato testato non lo rompe mai al primo colpo» → contatore di tocchi dal flip; entra in reversal solo al tocco #1 (o solo dal #2) | ✅ **SÌ** — un contatore, banale | **G1**, gradino singolo. È una **regola condizionale pulita**, il tipo di cosa che il tester misura bene | Ricompilare | 🟡 MEDIA |
| **S8** | 📐 **Fibonacci golden area 38,2-61,8 come filtro di ingresso**, invalidazione a 78,6 | 🟡 **PARZIALE** — «da dove parte il movimento a dove finisce» **non è una definizione meccanica**: serve un algoritmo di swing detection (ZigZag/frattali), e la scelta dell'algoritmo cambia tutti i livelli | **G2 al massimo.** ⚠️ Rischio curve-fitting alto (2 parametri liberi in più) | Definire prima lo swing detector, e **dichiararlo** | 🟢 BASSA |
| **S9** | 🕳️ **"Non devono mai rimanere spazi senza negoziazione"** (riga 199) — gap/imbalance da riempire come filtro o come target | ✅ SÌ | **Già coperto in parte**: abbiamo `ABTG_GapFill` e `ABTG_GapContinuation` (225JPY M1 in forward dal 16/08). **Verificare nel registro prima di riaprire** | Nulla di nuovo, forse | 🟢 BASSA |
| **S10** | 😮‍💨 **Il flip del ST in "fase di riposo" è un falso segnale** (riga 207: «Quando il movimento fa questa fase di respiro […] **normalmente qui il super trend inverte**») → filtro di compressione (ATR in contrazione / range in contrazione) prima di accettare un flip | ✅ SÌ | **G1**, ma **serve prima di decidere la misura di "riposo"** (ATR corrente vs ATR medio? range delle ultime N barre?) | Definizione + ricompilazione | 🟢 BASSA |
| **S11** | 🖥️ **Chiedere il FILE della dashboard "Supertrend V6"** — Paolo l'ha distribuita in live | ✅ SÌ, indirettamente | **Fuori imbuto — è ACQUISIZIONE.** Ma il precedente è d'oro: `ABTG_SuperWave` è nato **da una dashboard del corso** (registro riga 397) ed è finito validato real-tick su DOW H1 (PF 1.52) e DAX H4 (PF 1.28) | Chiederlo a Claudio | 🔴 **ALTA (costo zero)** |
| **S12** | 🛑 **Filtro "evento macro annuale"** (Jackson Hole & simili): finestra di flat dichiarata | ⚪ **NO, non ora** | R101 ha già messo il **news filter OUT per criterio**. Riaprirlo richiede un round, non uno spunto | — | ⚪ **NON AGIRE** — vedi B1 |

## 🚫 SPUNTI RESPINTI IN PARTENZA (e perché)

| Cosa | Perché NO |
|---|---|
| **DAX M3** (il suo cavallo di battaglia) | Misurato **morto** in real-tick, capitolo chiuso il 26.07.26. La regola dice testualmente «**Non costruire altri v2 M5**». |
| **RR 1:1** | Contraddice il documento dello stesso corso (1:2) e le nostre celle validate (3.0). Numero dettato a voce, non misurato. |
| **«In direzione di trend, in qualsiasi punto entri, sei sicura di non andare in stop»** (riga 227) | 🚩 È la logica del "aspetta che torni". **Per una challenge è veleno.** Regola B: il DD accaduto è un fatto. |
| **«Non bisogna essere meccanici»** (riga 267) | È l'onesta descrizione del suo mestiere. È anche l'esatto opposto del nostro. Si registra, non si adotta. |
| Wyckoff / lettura discrezionale degli swing / "a sentimento" | Già classificato «**Da NON automatizzare (Paolo)**» nel registro, riga 245. Confermato stasera. |

---

# 🕐 NOTA SUI FUSI ORARI

**Nella trascrizione NON è dichiarato NESSUN fuso orario.** L'unico riferimento
temporale operativo è «**mezzanotte**» come punto di apertura giornaliera per
l'ADR (righe 75-77, 147: «questo è un programma a mezzanotte. Il prezzo rimbalza
a mezzanotte qua»).

⚠️ **Mezzanotte di CHI?** Del suo broker, quasi certamente — **ma non lo dice**, e
il suo broker **non è il nostro**. `[INCERTO]`.

👉 **Conseguenza concreta per lo spunto ADR (S2):** l'ADR e le sue righe dipendono
**interamente** da dove cade il confine di giornata. Se implementiamo l'ADR, il
"giorno" è quello del **server BCM** (ora italiana − 1), e **va dichiarato nel
codice e nel referto** — non si eredita il suo. Un ADR calcolato sul confine
sbagliato è peggio di nessun ADR.

Nessun altro orario da convertire: **non ci sono orari di sessione in questa
lezione.**

---

# ♻️ SCARTI — cosa NON è estraibile da questo file

_Detto con il motivo, come vuole la regola di casa._

| Cosa | Perché non è estraibile |
|---|---|
| I **valori di ADR** degli esempi (50/55/60 pip) | Gli **strumenti non sono identificabili** («EUROSDK», «Odicad», «auditi HF», «RGB bio»). Un ADR senza simbolo è un numero orfano. |
| I **numeri di performance** (500/800/1300/158/154/340) | Letture a posteriori su grafico, senza data, senza simbolo, senza conto. `[dichiarato, NON verificato]` per definizione. |
| I **livelli di prezzo** degli esempi | Tutti indicati con «qua», «qui», «questo livello». **Puro deittico**: senza schermo, zero informazione. Il file è pieno di «eccolo qua». |
| Le **date** degli esempi storici | «6 di giugno di maggio del 2021» (riga 221) è irrecuperabile. |
| I settaggi della **dashboard V6**, del **Range Analysis**, dei **livelli RERRI**, delle **"gnasci"** | Mostrati a schermo, **mai letti ad alta voce**. → tabella "domande per Claudio". |
| Il **contenuto dell'outlook settimanale** di Emiliano | Sono 3 documenti su Circle, non parlato. Unica frase estraibile: «Audì lo dà debole e il [dollaro] la dà forte» (riga 295) — analisi, non regola. |
| Tutta la **parte organizzativa** (righe 1-13) | Calendario del corso, sezioni di Circle, saluti. Utile solo per il punto 8 della tabella screenshot. |
| **Regole prop, challenge, EA, trucchi anti-prop** | ⛔ **ASSENTI. Zero occorrenze in 321 righe.** Questa live non tocca il mondo prop in nessun punto. La sezione della griglia resta vuota, e va detto. |

---

_Referto compilato leggendo il file **riga per riga** (321/321). Ogni valore
riportato ha la sua citazione e il numero di riga. Ogni incrocio col repo è
verificato **nel sorgente o nel registro**, mai a memoria._

---

# 🔁 SEGUITO — LIVE PAOLO DEL 27/08 SERA (referto separato)

📄 **`risultati_archivio/ANALISI_LIVE_PAOLO_2026-08-27.md`** — è **il seguito
diretto di questa lezione**, dichiarato in apertura dal docente: _"riprendiamo
il discorso dal Supertrend, **come avevamo fatto martedì sera**"_.
**Non duplico i contenuti: si legge lì.** Qui restano solo le **quattro
correzioni che riguardano QUESTO file**:

| # | Cosa cambia | Dove |
|---|---|---|
| **1** | 🔴 **B3 / S3 vanno CORRETTI: `ABTG_SupertrendInvert` NON è stato misurato solo su oro H1.** `REFERTO_CODA_FASCIA_B.md` riga 31: su **USDJPY** fa **0 trade su 10 TF su 11** (2 trade in 14 mesi su M15) → _"non è un candidato, è un grafico acceso a vuoto"_. **Il problema non è che perde: è che con `RequireStrong` + ADX + Stocastico + anti-estensione tutti accesi NON OPERA.** L'entusiasmo di S3 va ricalibrato di conseguenza | referto 27/08 §7 e §7.1 |
| **2** | 🔴 **S8 (Fibonacci golden area) DECLASSATO a NON IMPLEMENTABILE.** Due giorni dopo il docente sposta la golden area da **38,2-61,8** a **61-78,6**, e il **78,6 passa da INVALIDAZIONE (stop) a INGRESSO**. Confini instabili = la sceglierebbe l'implementatore | referto 27/08 §2 |
| **3** | 🟡 **La riduzione «ci basta il 3.5» è RITRATTATA**: _"non va trascurato nemmeno il livello standard, che è il **3.0**"_ → **doppio ordine sulle DUE linee ST (1° sul 3.0, 2° sotto il 3.5)**. ✅ **E questa versione è quella che i NOSTRI numeri sostengono** (3.5 su 3 sedie, 3.0 su 2, 2.5 su 1) | referto 27/08 §3.3 |
| **4** | 🟢 **La bandiera rossa metodologica** (_"in qualsiasi punto entri sei sicura di non andare in stop"_) è **ammorbidita dallo stesso docente**: _"**non dico sei sicuro di non prenderlo stop**, ma riduci notevolmente la possibilità"_ | referto 27/08 §5, Y8 |

➕ **E l'ADR (S2) guadagna il pezzo che mancava:** il lookback è **spiegato**
(_"10 settimane, per tante 50 giorni di operatività"_ → 10×5 = 50 giorni di
borsa, il che **risolve l'esitazione** di questa lezione) e arrivano **tre casi
di scarto/accettazione decisi in diretta** su `distanza(prezzo, ST) ≤ ADR`.
⚠️ Il prerequisito **Q6 (High-Low o True Range? quale confine di giornata?)
resta APERTO**, come qui.
