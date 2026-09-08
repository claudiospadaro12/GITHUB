# 🧭 PORTING P3 — `ABTG_HVAncora`: la volatilità che crea il livello — 09/09/2026

**Terzo e ultimo della caccia M30** (`report/CACCIA_M30_INDICI_2026-09-08.md`,
candidato **P3 · HV Spike**, 8/10). I fratelli maggiori sono già passati
dall'imbuto: **P1 `ABTG_IBRetest`** scritto, **P2 `ABTG_LVNArbitro`** scritto,
girato due volte sul VPS e **bocciato per rischio**.

> ## 🔴 LA RIGA CHE VIENE PRIMA DI TUTTE
> **Non ho compilato niente e non ho girato niente.** Qui non c'è MetaEditor e
> non c'è lo Strategy Tester. Quello che segue è **revisione statica**: il file
> è scritto da specifica, riletto riga per riga, e il controllore del file prova
> dice OK. **Un EA che compila è un fatto; questo, per ora, è un'ipotesi ben
> scritta.** Il primo verdetto è la compilazione in MetaEditor (F7).

🔒 Nessun EA in forward toccato, nessun preset, nessun parametro, nessun magic
esistente, nessun backtest lanciato. File nuovi: **3** (EA, file prova, questo
referto).

---

## 0. 📌 HO LETTO I TRE VERDETTI DI IERI, E HANNO CAMBIATO IL FILE

| verdetto | cosa mi ha imposto |
|---|---|
| `P0_OPENINGREVERSALB` — **2 operazioni in 21 mesi** | il PASSO 0 conta **prima** le occasioni, e il file prova dichiara **quattro soglie di frequenza** prima dei numeri |
| `P0_LVNARBITRO` — **1.010 operazioni, DD 19,35% / 11,76%** a due taglie | il rischio si legge **a qualunque n**, e va riletto **anche all'altra taglia di conto** prima di scrivere un verdetto |
| 🔴 `PERCHE_MUOIONO` — **13 motori su 13 bocciati per rischio hanno PF ≤ 1,19** | **il collo di bottiglia non è trovare i trade: è il PF.** Da qui la soglia di scarto **prima della griglia** (§7) |

> ### 🎯 Tradotto in una frase che vale per questo EA:
> un motore che macina operazioni con **PF a ridosso di 1 muore di drawdown
> cumulato, sempre**. Questo file è scritto sapendolo — e per un motore **a
> raffiche** come questo la cosa è **peggio**, non uguale (§7.2).

---

## 1. ⚙️ IL MECCANISMO, COM'È FINITO NEL CODICE

**L'evento sceglie il livello. Noi non scegliamo niente.**

| passo | dove sta nel codice |
|---|---|
| **HV** = deviazione standard dei log-rendimenti su `InpHvLen` barre | `HvSerie_Calc()` |
| **Percentile** della HV nelle ultime `InpHvLookback` barre | `Percentile_Calc()` |
| **ANCORA** = la barra in cui il percentile **ATTRAVERSA verso l'alto** la soglia (non "sta sopra": è un **evento**, non uno stato) | `Attivazione_Calc()` |
| **livelli** 100% e 50% dal range della barra-ancora | `LivelliAncora_Calc()` |
| **CONTINUAZIONE**: chiusura oltre il 100% → si va **nella** direzione | `Motore_Calc()`, ramo 1 |
| **ESAURIMENTO**: estensione 100% fatta, poi chiusura **rientrata dentro l'ancora** → si va **contro** | `Motore_Calc()`, ramo 2 |
| una sola operazione per ancora; ancora con **scadenza** | `gAncUsata`, `InpAncoraBarre`, `InpAncoraSoloOggi` |

Tutte le funzioni `*_Calc` sono **nucleo puro**: non leggono niente dal
terminale. È voluto — sono le uniche verificabili a tavolino, e qui MT5 non c'è.

**Il motore non sa che ora è**: nessun box d'apertura, nessuna campanella. È la
differenza da **M2** (ORB autorizzato dalla volatilità) e da **M1/ORB nudo**
(chiuso in casa con ~210 celle rosse).

---

## 2. 🔬 TRE COSE TROVATE LEGGENDO IL PINE — e cambiano cosa È questo motore

### 2.1 🔴 Nella fonte **lo stop e il take non esistono affatto**
Riga 113: `entryPrice = strategy.position_avg_price` è calcolato **prima**
dell'ingresso (righe 122-130) → sulla barra d'ingresso vale `na` →
`strategy.exit(stop=na, limit=na)` **non piazza niente**, e `strategy.exit`
non viene richiamato dopo.

👉 **Qualunque numero mostrato dall'autore è il risultato di una strategia senza
uscite.** Non pesa comunque (i numeri degli autori non sono un criterio di
casa), ma è **la ragione per cui questo motore vale solo con una gestione
nostra**. Era il primo controllo chiesto dalla consegna: **fatto per primo**, e
il baco c'era — il terzo su tredici sorgenti in questa stessa caccia.

Qui non può esistere: **lo stop viaggia dentro l'`OrderSend`**, dal primo tick.

### 2.2 🔴 Nella fonte il ramo **"Reversal" è codice morto**
La **stessa barra** che accende `longBreakout100` (riga 96) accende anche
`breakoutLong` (riga 106): il trade di continuazione parte subito e mette
`tradeTaken := true`. Il ramo reversal pretende `not tradeTaken` → **non può
più scattare**. E non esiste **nessun input** per spegnere il breakout.

> 👉 **Nel sorgente il "Reversal" del titolo non gira mai.** Il ramo che il
> dossier considerava metà del motore **non è mai stato misurato da nessuno**.

**Cosa ho fatto:** fedeltà quando entrambi i rami sono accesi (una sola
operazione per ancora, la continuazione arriva prima) **ma**:
- i **contatori** dei due rami sono separati e contano le **occasioni** per
  tutta la vita dell'ancora, anche dopo l'operazione;
- `InpUsaRamoContinuazione=false` **rende raggiungibile** l'esaurimento — è
  l'unico modo di misurarlo, ed è una cella dedicata, non questa.

⚠️ **Conseguenza da scrivere nei referti prima di leggerli:** nella cella di
default gli **ingressi** di esaurimento saranno **~0 per costruzione**. Non è un
bug e non è un verdetto sul ramo: è la gerarchia della fonte.

### 2.3 🟡 Il "percentile a **252 barre**" su M30 **non è un anno: è una settimana**
252 è il numero di sedute di un anno su un grafico **giornaliero**. Su M30, con
~46 barre al giorno sugli indici, **252 barre ≈ 5-6 sedute**.

👉 Il motore non misura la volatilità rara dell'anno: misura la volatilità
rispetto **all'ultima settimana**. Questo **ribalta in parte** la paura del
dossier (*"senza il ramo sessioni la frequenza crolla"*): l'attivazione è molto
meno rara di quanto il nome "HV Spike" faccia pensare. 🔴 **Ma resta una
previsione**, ed è il PASSO 0 a dire il numero.

---

## 3. ✂️ COSA HO PRESO DALLA FONTE E COSA HO DECISO IO

**🟢 Preso (il motore):** attraversamento del percentile come ancora · geometria
50%/100% del range della barra-evento · i due rami simmetrici sui due lati · una
sola operazione per ancora · stop 1,0×ATR(14) e take 2,0×ATR (= **2R**) ·
i valori 30 / 252 / 50.

**🟡 Deciso da me, dichiarato uno per uno:**

| decisione | perché |
|---|---|
| **stop VERO nell'ordine** | nella fonte non esiste (§2.1) |
| **rischio 0,65% dell'equity**, una posizione, **una tranche** | la fonte usa **10% dell'equity a trade**, che non è un rischio: è una taglia. E senza seconda tranche il difetto del lotto (`FIX_LOTTO_PENDENTE`) non può presentarsi |
| **finestra 08:00-20:30 e flat 21:00 SERVER** | serve al **costo** (fuori sessione lo spread indici BCM raddoppia) e al divieto di overnight. La fonte opera 24h e tiene la posizione per giorni |
| **`InpAncoraBarre`** (tetto di vita) + **`InpAncoraSoloOggi`** | nella fonte l'ancora vive finché non arriva la successiva: **un'ancora di tre settimane fa può ancora sparare**. E un'ancora di ieri che scatta sul gap di stamattina non è questo motore: è un altro |
| **rientro "ambiguo" = si sta fuori** | se l'ancora ha esteso **da tutte e due le parti**, il rientro accende esaurimento long **e** short. Nella fonte il caso non si vede solo perché il ramo è irraggiungibile; appena si spegne la continuazione diventa reale |
| **l'ancora si consuma solo se l'ordine passa** | un rifiuto del broker non deve bruciare l'occasione (e `gBarraValutata` impedisce comunque il secondo tentativo sulla stessa barra) |
| **niente annualizzazione della HV** | la fonte moltiplica per `100·√365`: è una **costante positiva** uguale per tutte le barre, e il motore usa solo il **percentile**, che è un **rango**. Non è una semplificazione: **è la stessa funzione** |

**🟠 Nota di fedeltà che va detta:** nella fonte il test sul livello **50% è
logicamente implicato**. `short50` sta **sotto** il minimo dell'ancora e
`backInsideORB` pretende già `close > spikeLow > short50`: quindi
`close > short50` **non aggiunge niente**, e l'esaurimento scatta sulla **prima
chiusura che rientra dentro il range dell'ancora**. La bozza lo descriveva come
una terza condizione: **non lo è**. I livelli 50% restano calcolati e loggati
perché sono nel disegno della fonte, ma **non sono una condizione** — e non
invento una condizione che nel sorgente non c'è.

---

## 4. ✅ QUESTO MOTORE **NON USA IL VOLUME**

Detto apposta, perché la consegna lo chiedeva: il **limite noto n.1** di
`ABTG_LVNArbitro` (su CFD MT5 espone **tick volume**, non volume scambiato)
**qui non si applica**. La HV si calcola sui **prezzi di chiusura**, che sul
nostro feed sono la stessa variabile della fonte.

> 🟢 **È l'unico dei tre candidati M30 senza quel rischio di porting.** Una
> buona notizia vera, e va scritta accanto alle altre.

---

## 5. 🔢 IL MAGIC: **776900** (gemello **776950**)

**Verificato libero il 09/09/2026**, non assunto:
- `grep` repo-wide su `776900` e `776950` → **zero occorrenze**;
- incrociato col censimento `backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260908_033003.log`
  (nessun 7769xx fra le sedie attaccate);
- incrociato con le liste `$MagicVietati` delle righe di lancio (il blocco
  7769xx non compare).

🔴 **Occupati e NON toccati:** `769800` (ABTG_ImpulsoApertura), `769900` +
`769950` (ABTG_LVNArbitro), **`772900` (ABTG_IBRetest — controllato come chiesto:
è già committato e il numero è quello)**. Il blocco 769xxx è **pieno da 769000 a
769900**: per questo salgo a 7769xx invece di infilarmi in mezzo.

---

## 6. 🛡️ LE REGOLE DI CASA, UNA PER UNA — dove sono nel codice

| regola | dove |
|---|---|
| **orari in ORA SERVER** (BCM = italiana − 1) | `InpOraInizio/Fine/Flat`, log di `OnInit` che lo ricorda |
| **rischio %, mai lotto fisso; una posizione, una tranche** | `LotByRisk()`, `HoPosizione()` |
| **stop SEMPRE allegato all'ordine** | `Entra()` → `gTrade.Buy/Sell(lot,sym,0,sP,tP,cm)` |
| **pavimento SL (R109), mai zero** | `SlFloor_Calc()` + `OnInit` **rifiuta** `InpMinStopPts<=0` |
| **`STOPS_LEVEL` rispettato** | dentro il pavimento **e** ricontrollo sul TP |
| **vincoli di volume** (min/max/step) | `LotByRisk()` |
| **retcode controllato dopo ogni ordine** | `Entra()`, `GestisciBreakeven()`, `FlatFineSedutaCheck()` |
| **gate di spread in % dello stop (R55)** | `Entra()` |
| **Guardian a ridosso dell'invio** | `ABTG_GuardiaIngresso(...)` **immediatamente prima** del `Buy/Sell` |
| **flat di fine seduta** | `FlatFineSedutaCheck()` |
| **decisione solo a barra chiusa** | `IsNewBar()` + valutazione allo shift 1 |
| **niente martingala/griglia/recovery/piramidazione** | ingresso singolo, `gAncUsata`, una posizione per magic |
| **divieto B0 (modalità "Market Sessions" = ORB)** | 🔴 `OnInit` **RIFIUTA di partire** se `InpModoAttivazione != 0`. Non è una promessa: è impossibile da violare |

**Colonne diagnostiche in `OnTester`** (come `LVNArbitro`, più due sue):
`Ancore`, `Ancore Scadute`, `Cont Long/Short`, `Esaur Long/Short`, `Long`,
`Short`, `Reject`, `Guardian`, `Flat Chiusure`, `Barre Valutate`,
**`Peggior Giornata %`**, e — nuove — **`Max Trade Giorno`** e
**`Max Trade Settimana`**: su un motore **a raffiche** la media non descrive
niente, e il cancello C6 della bozza chiedeva proprio quelle.

---

## 7. 🧪 IL FILE PROVA DEL PASSO 0 — attese congelate PRIMA dei numeri

`backtest_pipeline/prove/ABTG_HVAncora_00_conta.txt` ·
`@SIMBOLO U30USD` · `@PERIODO M30` · `@DAQUANDO 2024.09.26` ·
**un solo asse Y** (il magic, due celle gemelle: determinismo G1) · tutti gli
altri **29 pin** fissati uno per uno al default del sorgente.

*(Mi discosto dalla bozza, che proponeva NASUSD per primo: su **U30USD** il
gemello `LVNArbitro` è appena girato con la stessa finestra e gli stessi costi,
quindi i due conteggi **si confrontano direttamente**.)*

### 📏 L'attesa, con le ipotesi in chiaro
- ~17,5 barre valutate/seduta (**numero misurato** da LVNArbitro, non stimato)
  × ~440 sedute;
- la HV è liscia e autocorrelata → **0,3-0,8 ancore per seduta** = **130-350
  ancore**;
- conversione ancora → operazione (serve un intero range in più) **25-40%**.

> ### 🎯 **ATTESA CENTRALE: 130-350 ancore, 50-200 operazioni** in 21 mesi
> (0,11-0,45 op/giorno di seduta).
> 🔴 E lo dico chiaro: **la metà bassa sta sotto la quota per simbolo (0,33) e
> sotto il pavimento dei 150 per parte.** Questo è il candidato più fragile dei
> tre, il dossier lo diceva, e **non sto scommettendo il contrario**.

**Le quattro soglie di frequenza:** `<30` → **bocciato senza appello** ·
`30-100` → sta in piedi **solo come famiglia** a tre simboli, merito sospeso ·
`≥150 per parte` → si passa alla griglia · `>1.500` → il motore mitraglia e il
cancello diventa la **peggior giornata**.

### 7.1 🚪 LA SOGLIA DI PF — **e da dove viene**
**Adotto il cancello C0** proposto in `report/PERCHE_MUOIONO_2026-09-08.md` §5.
**Lo dichiaro come adottato**, e dichiaro anche che **non è firmato da Claudio**:
lì è scritto *"PROPOSTO, non congelato"*, e resta così. Qui è un **criterio di
questo round**, congelato prima dei numeri.

```
SE  in una finestra (IS o OOS) n >= 150
E   il PF misurato A TICK REALI in QUELLA finestra e' < 1,10
ALLORA il candidato si SCARTA: niente griglia, niente ottimizzazione.
Si applica al PEGGIORE dei PF leggibili. Se n < 150 ovunque, C0 NON
si applica (il PF non e' una misura) e si torna al conteggio.
```

**Perché 1,10, col meccanismo e non col fatto che separa i dati:** un muro prop
vincola il **massimo** della curva di equity, non la media. Il drawdown massimo
atteso converge a **σ²/(2μ)** (Magdon-Ismail & Atiya, 2004): cresce col
**quadrato del rumore**, cala con la **prima potenza dell'edge** — e **μ è
proporzionale a (PF − 1)**. A PF vicino a 1 la deriva sparisce, resta il rumore,
e **il DD esplode a prescindere da quanto sei bravo per trade**. È il ritratto
di `LVNArbitro`: **+11,31% su 100k con DD 11,76%** — *guadagna e muore per
strada*. Il numero **1,10** è il punto di mezzo fra il massimo dei bocciati per
rischio (**1,12**) e il minimo delle sedie vive leggibili (**1,154**).
⚠️ **Margine 0,034 punti di PF: sottile, e lo dico.** C0 non ha ancora sbagliato
sui dati che abbiamo; non è una legge di natura.

### 7.2 ⚠️ E LA POSTILLA CHE RIGUARDA PROPRIO QUESTO MOTORE
`HVAncora` lavora **a raffiche** (gli attraversamenti di percentile si
raggruppano: la volatilità è persistente). Più il percorso è a grumi, più **σ**
per unità di tempo è grande, **più la formula punisce un PF vicino a 1**.

> 👉 **Qui 1,10 è un pavimento, non un obiettivo.** Un PF fra 1,10 e 1,20 su
> questo motore **non è una buona notizia: è un rinvio.**

🔴 E l'avvertenza del dossier resta intera: tutte le nostre Monte Carlo sono su
**DD statico dal deposito**. Se Claudio sceglie una prop con **drawdown
trailing**, questo candidato — lunghi piatti e poi movimenti — **va rivalutato
da zero**.

### ✅ L'esito del controllore, incollato
```
=== CONTROLLO FILE PROVA ===
  ABTG_HVAncora_00_conta.txt       ABTG_HVAncora.mq5          pin=29 celle= 2  OK

file: 1 | celle totali: 2 | passate (celle x 2 finestre): 4 | problemi: 0
ESITO: OK
```

---

## 8. ⚠️ LIMITI DI QUESTA CONSEGNA — dichiarati, non nascosti

1. 🔴 **Non compilato, non testato.** Zero righe eseguite. Il primo verdetto è F7.
2. 🔴 **Nessun numero di performance esiste.** Non c'è nessun backtest di
   riferimento: qualunque frase su "quanto rende" sarebbe inventata.
3. 🟠 **Regime unico.** 21 mesi di indici 2024-2026: niente orso, niente crollo,
   niente laterale lungo. Per un motore **ancorato alla volatilità** è il limite
   più grave dei tre candidati: è misurato in un'epoca di volatilità omogenea,
   cioè **non ha visto il caso che gli interessa**.
4. 🟠 **La finestra oraria costa frequenza**, e non è un dettaglio: fuori
   finestra non si valuta niente, quindi **non nascono ancore**. Un
   attraversamento notturno non viene visto. È un prezzo **scelto** (il costo),
   non un difetto nascosto — allargarla è un input.
5. 🟠 **La bozza `HVANCHOR_M30_BOZZA.txt` non pinna `InpAncoraSoloOggi`**
   (l'input non esisteva quando è stata scritta). Va aggiunto alla griglia da 27
   celle, altrimenti quella cella misura un default invece di una scelta.
6. 🟡 **`InpModoAttivazione` è un input che accetta un solo valore.** È voluto
   (compatibilità col file prova + divieto B0 reso impossibile da violare), ma
   è una stranezza e va saputa leggendo il codice.

---

## 9. 🚦 COSA SUCCEDE DOPO (e cosa NON succede)

1. **Compilare in MetaEditor (F7)** e correggere quello che il compilatore dice.
2. **PASSO 0** con `ABTG_HVAncora_00_conta.txt`: si guarda **prima** `Ancore`,
   poi `Trades`, poi i due lati, poi `Peggior Giornata %`.
3. Se la frequenza regge → gemelli **NASUSD** e **D30EUR**, poi la griglia da 27
   celle (**centro dell'altopiano, mai il picco**).
4. Se `n ≥ 150` in una finestra e **PF < 1,10** → **si scarta lì**, senza griglia.
5. Se il ramo **esaurimento** mostra molte **occasioni** → merita una cella
   dedicata con `InpUsaRamoContinuazione=false`: **nella fonte quel ramo non è
   mai stato misurato da nessuno.**

❌ **Cosa NON succede:** nessuna sedia accesa, nessun forward, nessun conto
reale. Un motore letto nel sorgente e portato in MQL5 è un **candidato**, non
una sedia — e a **tre settimane dalla challenge** la fretta è esattamente ciò
che pagheremmo caro.

---

## 📎 ATTRIBUZIONE E LICENZA

| | |
|---|---|
| **fonte** | *HV Spike Strategy (HVP + OR Breakout + Reversal + TP/SL Modes)* |
| **autore / data** | **kostastrovas**, TradingView, slug `1oZNa7Oq`, 26/10/2025, Pine v6, 134 righe |
| **licenza** | 🟠 **[INCERTO]** — **nessuna intestazione di licenza nel sorgente**. È verificato solo che `scriptAccess = "open_no_auth"`, cioè che il sorgente è **leggibile**. **Leggibile non vuol dire riutilizzabile** |
| **copia archiviata** | `backtest_pipeline/caccia_strategie/biblioteca/sorgenti/HvSpikeOrBreakoutReversal_kostastrovas-NOLICENSE_tv1oZNa7Oq_2026-09-08.pine` |
| **cosa è stato copiato** | **niente**. Il sorgente è stato **letto** riga per riga; il `.mq5` è scritto da specifica. Gestione, prop-hardening, orari, sizing, scadenza dell'ancora e diagnostica **non vengono dalla fonte** |

L'attribuzione completa è **ripetuta in testa a `mql5/Experts/ABTG_HVAncora.mq5`**
e nel file prova, come vuole la regola di casa.
