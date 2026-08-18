# 🧭 ANALISI DEL MATERIALE **POINT BREAK** — il framework ufficiale del corso

**Data:** 18/08/2026 (sera) · **Fonte:** 6 documenti in
`backtest_pipeline/caccia_strategie/trascrizioni_corso_2026-08-18/materiale_pointbreak/`
(4 PDF + 2 PPTX), **letti per intero**: testo estratto con `pdftotext -layout`
e con parser XML sulle slide/note dei PPTX; le pagine che contengono **solo
immagini** sono state **renderizzate e guardate** (`pdftoppm`), e questo ha
prodotto due delle tre scoperte.

**Autore del materiale:** **Christian Bertacchi** `[T]` (PIANO DI TRADING, pag. 1;
ABTG deck slide 6: _"Trader professionista da oltre 5 anni · Nuovo coach della
famiglia Bardolla"_).
**Editore:** **Alfio Bardolla Training Group SpA** `[T]` (disclaimer, ABTG pag. 2)
→ **ABTG = Alfio Bardolla Training Group** — vedi §5 per la risposta secca sulla
domanda del prefisso.

> 🔒 **Nessuna modifica al forward. Nessun EA toccato. Nessuna riga di
> `PIANO_PROP.md` cambiata.** Qui si estrae, si cita e si propone.
>
> ⚠️ **Regola di etichetta usata in tutto il referto:**
> `[T]` = c'è scritto, cito testualmente · `[INFERITO]` = dedotto da più
> passaggi, e dico quali · `[INCERTO]` = non ho abbastanza per dirlo ·
> `[dichiarato, NON verificato]` = numero del relatore.
> **Nessun numero di performance è presente in questo corpus** — il che è di per
> sé un dato (§4.4).

**Documenti gemelli già in casa** (non duplico, linko):
`ANALISI_CORSO_BREAKOUT_2026-08-18.md` · `ANALISI_CORSO_MEDIAZIONE_2026-08-18.md` ·
`docs/live_emiliano/CATALOGO_STRATEGIE_CORSO.md` ·
`docs/live_emiliano/ANALISI_SLIDE_APERTURE.md` · `report/PIANO_PROP.md` ·
`report/FIRME_2026-08-18.md` · `backtest_pipeline/prove/TORNEO_JPY_CRITERI.md`

---

# PARTE 1 — 🔥 LA SINTESI, PRIMA DI TUTTO

## 1.1 La risposta secca alla domanda che ha lanciato la missione

> ### ❓ **«Il corso ha regole di correlazione QUANTITATIVE?»**
> ## 🔴 **NO.**
> Il PDF CORRELAZIONI contiene **43 coefficienti numerici** e **ZERO regole
> operative**. Non una riga che dica quante posizioni correlate si possono
> tenere, sopra quale soglia si rinuncia a un ingresso, come si somma il rischio
> fra coppie correlate. **Non c'è un solo verbo all'imperativo in tutto il
> documento.** È una tabella di consultazione, non una regola.

E c'è di peggio, ed è misurato, non opinato: **due dei tre pezzi del documento
si smentiscono da soli** (§2.1) — la matrice allegata contraddice le tabelle che
dovrebbe illustrare, e una riga delle tabelle è **aritmeticamente impossibile**.

## 1.2 🥇 SCOPERTA 1 — La matrice di correlazione allegata è **ROTTA**, e si vede a occhio

Pagina 3 del PDF CORRELAZIONI è una heatmap («Matrice di Correlazione tra Coppie
Valutarie (Major, Minor, JPY inclusi, Asia esclusa)»). Renderizzata e guardata:

- **Tutte le celle fuori diagonale sono pallide** = correlazioni ≈ 0. La cella
  EUR/USD × GBP/USD è **grigio-rosa**, cioè ~0,0 — mentre la **tabella a pagina 1
  dello stesso PDF** dichiara per quella coppia `+0.85–0.95` `[T]`.
  **La figura contraddice il testo che accompagna.**
- La **legenda scritta contraddice la scala colori del grafico**: il testo dice
  `[T]` _"Colori rossi: correlazione negativa … Colori blu intensi: correlazione
  positiva"_, ma la colorbar del grafico ha **il rosso in alto a +1,0** (ed è
  rosso che la diagonale, che vale 1,0 per definizione, è dipinta).
  **I colori sono dichiarati al contrario.**
- Conclusione: la heatmap è **decorativa e generata da dati che non sono quelli
  delle tabelle** (l'aspetto — diagonale 1,0 e tutto il resto rumore attorno a
  zero — è quello di una matrice costruita su serie casuali). `[INFERITO]` dalla
  lettura diretta dell'immagine + dal confronto cella-per-cella con le tabelle.

📎 Immagini di prova rigenerabili in un comando:
`pdftoppm -r 400 -png -f 3 -l 3 -x 300 -y 500 -W 1400 -H 900 "POINT BREAK - CORRELAZIONI.pdf" out`

## 1.3 🥈 SCOPERTA 2 — Una riga delle tabelle è **impossibile per aritmetica**, non per opinione

Il PDF dichiara, nella stessa tabella «Correlazioni Positive Forti (+0.80)»:

| riga | valore dichiarato `[T]` |
|---|---|
| EUR/USD ↔ GBP/USD | **+0.85–0.95** |
| EUR/USD ↔ EUR/GBP | **+0.80** |
| GBP/USD ↔ EUR/GBP | **+0.83** |

**Le tre righe non possono coesistere.** EUR/GBP è per identità triangolare il
rapporto EUR/USD ÷ GBP/USD: in logaritmi `eurgbp = eurusd − gbpusd`. Se
`corr(eurusd, gbpusd) = ρ` e le due hanno volatilità simili, allora
**necessariamente**:

```
corr(eurgbp, eurusd) = +sqrt((1−ρ)/2)      corr(eurgbp, gbpusd) = −sqrt((1−ρ)/2)
```

Con ρ = 0,90 → **+0,22 e −0,22**. Cioè: EUR/GBP è **debolmente** correlata con
EUR/USD e **NEGATIVAMENTE** con GBP/USD. Il documento scrive **+0.80 e +0.83**,
sbagliando **la grandezza su entrambe** e **il segno su una**. E le due righe
sono **incompatibili fra loro** a qualunque ρ: non possono essere entrambe
positive e forti.

> 🧨 **Conseguenza operativa, e non è piccola:** il PDF CORRELAZIONI **non è una
> fonte di misura**. Alcune sue righe sono plausibili e note (EUR/USD ↔ USD/CHF
> −0,90/−1,00; AUD/USD ↔ NZD/USD +0,88-0,96), altre sono **dimostrabilmente
> false**. Senza periodo, senza timeframe, senza metodo di calcolo e senza fonte
> dichiarati — la tabella si intitola _"Correlazione **stimata**"_ `[T]` — **non
> si può usare per tarare niente.** Si usa, al massimo, come **conferma
> qualitativa di direzione**. Vedi §4.2 per l'uso che ne facciamo davvero.

## 1.4 🥉 SCOPERTA 3 — Il documento «METODI DI GESTIONE OPERAZIONI NEGATIVE» è un **manuale di recovery**, per intero

15 pagine, **sei metodi**, e **cinque su sei** sono esattamente ciò che il
setaccio di casa scarta a priori:

| # | metodo `[T]` | cosa è, nella nostra lingua | verdetto prop |
|---|---|---|---|
| 1 | «Attesa del rientro (Buy & Hold stile Forex)» | **posizione perdente tenuta senza SL** | 🔴 |
| 2 | «Mediazione della posizione in **Martingala**» | **martingala** classica `S × 2ⁿ`, modificata (+30/+50%), a fasce (ogni 50 pip) | 🔴🔴 |
| 3 | «**Hedging** (Copertura con operazioni inverse)» | blocco long+short per **congelare** la perdita | 🟠 |
| 4 | «Gestione a **griglia** (Grid Trading **senza SL**)» | griglia ogni 20-50 pip, **`NON si utilizza SL sugli ordini`** `[T]` | 🔴🔴 |
| 5 | «Accettazione della perdita controllata su equity (**senza SL, ma con stop mentale**)» | DD accettato **`10% - 20% -30%`** `[T]` | 🔴🔴🔴 |
| 6 | «Reingresso strategico su breakout / inversione» | posizione contraria **`con maggiore size`** `[T]` per recuperare | 🔴 |

**Il metodo 5, da solo, brucia una challenge tre volte.** Il documento propone
come soglia accettabile di drawdown `10% - 20% -30%`: il muro totale FTMO è
**10%**, il giornaliero **5%**. La soglia più bassa suggerita **coincide con la
morte del conto**; le altre due sono 2× e 3× oltre.

⚖️ **Onestà verso la fonte, che va detta:** il documento **non prescrive**, e le
sue avvertenze sono dure e corrette — `[T]` _"tende a premiare l'imprudenza fino
al momento in cui polverizza il conto"_, _"Molti trader evitano lo stop loss in
Martingala … **comportamento letale**"_, _"È una tecnica di gestione del rischio
**camuffata da metodo di recupero**"_. È materiale **descrittivo con guardrail**,
non un invito. **Ma è nel pacchetto ufficiale del framework**, e la matematica
che insegna è quella. Per noi la riga è una sola, ed è già scritta dal 12/08
(`CATALOGO_STRATEGIE_CORSO.md`): **non si meccanizza, mai in prop.**

## 1.5 Il quadro in una tabella

| documento | pagine/slide | parametri con valore | regole operative | bandiere rosse | ci serve? |
|---|---|---|---|---|---|
| PIANO DI TRADING | 22 | **12** | 20 | 3 | 🟡 **due pezzi sì** (§4.5) |
| CORRELAZIONI | 3 | 43 coefficienti | **0** | 2 (auto-contraddizioni) | 🟡 solo come corroborazione |
| METODI GESTIONE NEGATIVE | 15 | 8 | 6 metodi | **🔴 5 su 6** | 🔴 solo come intelligence |
| ABTG-Point break 20250429 | 18 | 3 | 0 | 0 | 🟢 chiude un buco d'archivio |
| Come tradare il gold (PPTX) | 14 | 7 | ~10 qualitative | 1 | 🟡 contesto |
| Come tradare il petrolio (PPTX) | 12 | 4 | **1 regola a punteggio** | 1 | 🟡 contesto |
| ESERCIZI PER IMPULSIVITÀ | 3 | 2 | 6 esercizi | 0 | ⚪ **scarto motivato** (§3.6) |

---

# PARTE 2 — 📑 LE SCHEDE, DOCUMENTO PER DOCUMENTO

# 2.1 🔗 `POINT BREAK - CORRELAZIONI.pdf` — **la priorità n.1 della missione**

```
FILE            POINT BREAK - CORRELAZIONI.pdf
AUTORE          [INCERTO] — nessuna firma nel documento; sta nel pacchetto
                Point Break di Christian Bertacchi
OGGETTO         tabelle di correlazione fra coppie forex + una matrice grafica
STRUTTURA       pag.1 glossario + correlazioni positive forti · pag.2 negative
                forti + neutre · pag.3 la matrice (immagine) + legenda
```

### 📚 Il glossario `[T]` — l'unica tassonomia esplicita del corso

| classe | strumenti elencati `[T]` |
|---|---|
| **Major** | EUR/USD, GBP/USD, USD/CHF, USD/CAD, AUD/USD, NZD/USD |
| **Minor** (escluse asiatiche) | EUR/GBP, EUR/CAD, EUR/CHF, EUR/AUD, EUR/NZD, GBP/CAD, GBP/CHF, GBP/AUD, GBP/NZD, AUD/CAD, AUD/CHF, CAD/CHF, NZD/CAD, NZD/CHF |
| **JPY Cross** | **USD/JPY, EUR/JPY, GBP/JPY, CHF/JPY, CAD/JPY, AUD/JPY, NZD/JPY** |

📌 **I «JPY Cross» del corso sono ESATTAMENTE i sette del nostro torneo JPY**
(`prove/TORNEO_JPY_CRITERI.md` §3.2). Stessa lista, stesso ordine di famiglia.

### ✅ Correlazioni positive forti dichiarate (`+0.80 o +80%`) `[T]`

| Coppia 1 | Coppia 2 | valore `[T]` | nota |
|---|---|---|---|
| EUR/USD | GBP/USD | +0.85–0.95 | plausibile |
| EUR/USD | EUR/GBP | +0.80 | 🔴 **impossibile** (§1.3) |
| EUR/USD | AUD/USD | +0.82–0.95 | plausibile |
| GBP/USD | AUD/USD | +0.80 | plausibile |
| GBP/USD | EUR/GBP | +0.83 | 🔴 **segno sbagliato** (§1.3) |
| AUD/USD | NZD/USD | +0.88–0.96 | plausibile, è la coppia più nota |
| EUR/CAD | GBP/CAD | +0.82 | plausibile |
| CAD/CHF | EUR/CHF | +0.80 | plausibile |
| AUD/CAD | AUD/CHF | +0.81 | plausibile |
| EUR/AUD | EUR/NZD | +0.80 | plausibile |
| 🟨 **EUR/JPY** | **GBP/JPY** | **+0.85** | **JPY × JPY** |
| 🟨 **AUD/JPY** | **NZD/JPY** | **+0.88** | **JPY × JPY** |
| 🟨 **USD/JPY** | **CAD/JPY** | **+0.83** | **JPY × JPY** |
| 🟨 **GBP/JPY** | **AUD/JPY** | **+0.82** | **JPY × JPY** |
| 🟨 **EUR/JPY** | **AUD/JPY** | **+0.81** | **JPY × JPY** |

> 🎯 **Il dato che ci riguarda, ed è il motivo per cui questo PDF valeva la
> missione: su 15 righe di «correlazione positiva forte», CINQUE sono
> JPY-contro-JPY.** È **un terzo dell'intera tabella**, prodotto da una famiglia
> che ha **7 membri su ~27 strumenti censiti** nel glossario. La famiglia più
> auto-correlata dell'elenco, **secondo i numeri del corso stesso**, è la JPY.

### 🔻 Correlazioni negative forti dichiarate (`–0.80 o –80%`) `[T]`

EUR/USD↔USD/CHF **–0.90/–1.00** · EUR/USD↔CAD/CHF –0.82 · GBP/USD↔USD/CHF –0.84 ·
GBP/USD↔CAD/CHF –0.81 · AUD/USD↔USD/CAD –0.81 · AUD/USD↔CAD/CHF –0.83 ·
NZD/USD↔USD/CHF –0.82 · NZD/USD↔CAD/CHF –0.80 · EUR/AUD↔USD/CHF –0.80 ·
EUR/CAD↔USD/CHF –0.81 · **USD/JPY↔EUR/USD –0.89** · **USD/JPY↔GBP/USD –0.85** ·
**USD/JPY↔AUD/USD –0.84** · **USD/JPY↔NZD/USD –0.82** · **USD/JPY↔EUR/AUD –0.81**

📌 **USD/JPY occupa 5 righe su 15 anche qui.** Sommando le due tabelle: **USD/JPY
e i suoi fratelli compaiono in 10 righe su 30**. Il corso, senza dirlo mai a
parole, **ha disegnato lo yen come il fattore di rischio più concentrato del suo
universo** — e poi non ne trae nessuna conseguenza operativa.

### 🧩 Neutre/moderate `[T]` (tra –0.80 e +0.80)

EUR/GBP↔AUD/USD ≈+0.60 · GBP/NZD↔EUR/CAD ≈+0.55 · **EUR/JPY↔EUR/USD ≈+0.65** ·
**GBP/JPY↔GBP/USD ≈+0.68** · CHF/JPY↔USD/CHF ≈–0.67 · CAD/JPY↔USD/CAD ≈–0.66 ·
**AUD/JPY↔AUD/USD ≈+0.71** · **NZD/JPY↔NZD/USD ≈+0.70**

```
REGOLE OPERATIVE       🔴 NESSUNA. Zero soglie, zero cap, zero "non aprire
                       più di N posizioni correlate", zero somma del rischio.
NUMERI PERFORMANCE     nessuno
BANDIERE ROSSE         (a) matrice contraddice le tabelle (§1.2)
                       (b) legenda colori invertita (§1.2)
                       (c) riga EUR/GBP aritmeticamente impossibile (§1.3)
                       (d) "Correlazione stimata": nessun periodo, nessun TF,
                           nessun metodo, nessuna fonte
A SCHERMO E NON DETTATO  la matrice di pag.3 è l'unico contenuto grafico e
                       l'ho letta direttamente: nessun buco da colmare qui
COSA NE COPIAMO        🟡 la DIREZIONE, non i numeri: corroborazione di 4°
                       rango alla regola JPY già firmata (§4.2)
```

---

# 2.2 📋 `POINT BREAK - PIANO DI TRADING.pdf` — **il framework ufficiale**

```
FILE            POINT BREAK - PIANO DI TRADING.pdf (22 slide)
RELATORE        Christian Bertacchi [T] (pag. 1)
OGGETTO         il piano operativo completo della strategia Point Break
```

### ⏰ Timeframe e orari `[T]`

| voce | testo citato | etichetta |
|---|---|---|
| **H12** | _"Questo studio viene fatto la mattina **alle ore 11** (orario di cambio candela)"_ | `[T]`, **fuso NON dichiarato** |
| **D1** | _"il primo studio per trovare oppurtunità di trading nella fascia oraria serale **tra le 21 e le 22**"_ | `[T]`, **fuso NON dichiarato** |
| vincolo tecnico | _"Per l'utilizzo del Timeframe H12 è necessario utilizzare **MT5 oppure TradingView**"_ | `[T]` |

> 🕐 **IL FUSO — e qui la regola di casa morde.** Il documento **non dichiara mai
> il fuso**, e l'inciso _"orario di cambio candela"_ è l'unico appiglio: una
> candela H12 cambia alle **00:00 e 12:00 ora server**. Se «ore 11» è ora
> italiana, il server del relatore è **italiana +1 = UTC+3** — il default della
> maggioranza dei broker MT5. `[INFERITO]` da un solo indizio.
>
> **Sul NOSTRO server (BCM = italiana −1 = UTC+1 in agosto) lo stesso momento è
> le 12:00 server = 13:00 italiane**, non le 11. **Chi copia «ore 11» su BCM
> studia il grafico a metà candela**, che è esattamente l'errore che il piano
> vuole evitare.
> ➡️ Va confermato da Claudio (§5, domanda 1). Finché non è confermato: `[INCERTO]`.
> ⚠️ E per la finestra serale «21-22» vale lo stesso: `[INCERTO]`.

### 🎛️ Indicatori — i 5 settaggi ufficiali `[T]`

| # | indicatore | parametri `[T]` | etichetta |
|---|---|---|---|
| 1 | **Bande di Bollinger** | **Periodo: 37 · Deviazione: 1.4** | chiaro (confermato dal grafico di pag. 4) |
| 2 | **Stocastico** | **%K 5 · %D 3 · Rallentamento 3** | chiaro (grafico: `Stoch(5,3,3)`) |
| 3 | **Media mobile** | **200 · Esponenziale** | chiaro |
| 4 | **Volatilità Media Giornaliera** | **`ImpPeriods: 50`** | ⚠️ **nome storpiato** — quasi certamente `InpPeriods` (prefisso `Inp` degli input MQL5). Indicatore **non nominato**: buco §5 domanda 4 |
| 5 | **Candle Time and Spread** | — | utility, nessun parametro |

📐 **Il settaggio Bollinger 37/1.4 è insolito e va notato**: periodo lungo (37
contro i 20 canonici) con deviazione **stretta** (1.4 contro 2.0). Produce bande
**molto più spesso violate** — coerente con una strategia che entra *fuori* dalle
bande (checklist punto 2). **È un parametro copiabile e misurabile così com'è.**

### ✅ Check list d'ingresso — 5 condizioni `[T]`

1. _"Formazione completa o in fase di realizzazione di un pattern"_
2. _"Il prezzo deve essere **fuori dalle bande** ( + è fuori migliore è l'occasione )"_
3. _"Lo stocastico deve essere in **ipercomprato o ipervenduto** e le linee devo essere **incrociate o in prossimità** dell'intersezione"_
4. 🎯 _"**La media esponenziale 200 deve essere distante almeno 100 pip** dal nostro punto d'ingresso"_
5. _"Tracciare supporti e resistenze **metodo Larry W.** in D1 E w1"_

> 🥇 **Il punto 4 è l'unica regola PIENAMENTE MECCANIZZABILE del documento**, ed è
> un filtro che **non abbiamo**: `|prezzo_ingresso − EMA200| ≥ 100 pip`. È il
> **contrario** del nostro `ABTG_EMA200` (che segue la media): qui la media è una
> **zona di esclusione**. Misurabile domani mattina.
> 📌 Il punto 5 aggancia il framework a **Larry Williams**, che in casa nostra è
> già una famiglia viva (`R39` punte di Larry, 6 sedie) — **non è una novità**.

### 💰 Money Management `[T]` — i numeri che contano

| voce | testo `[T]` | il nostro numero |
|---|---|---|
| **Rapporto rischio/rendimento minimo** | **`1/1`** | — |
| **Perdita massima per singola operazione** | **`2/3% del capitale`** | **A1 = 0,65%** · **A4 = 1,0% max** |
| formula size | _"Capitale + numero di pip di stop"_ | equivalente alla nostra |
| esempio | conto 10k → perdita 200/300€ → con SL 100 pip size **0,20 / 0,30** | ✅ **aritmetica verificata**: 0,20 lotti × 2€/pip × 100 pip = 200€ ✔ |
| convenzione pip | `0,01 = 10 cent` · `0,10 = 1€` · `1,00 = 10€` | approssimazione **dichiarata** dal documento (_"per comodità attribuiamo un valore fisso a pip"_) |

> 🔴 **Il 2/3% è il rischio per trade più alto letto in tutto il dossier prop
> tranne uno** (Range Breakout ExtraLow 2,4%, `PIANO_PROP` F6). È **3,1×–4,6× il
> nostro A1 (0,65%)** e **2×–3× il tetto A4 (1%, firmato oggi)**. Con 3
> operazioni aperte insieme fa **6-9% di rischio aperto**: sfonda **da solo** il
> muro giornaliero FTMO del 5%, e sta a **2-3× il nostro cap C1 di 3,25%**.

### 🎯 Ingresso / Take profit / gestione `[T]`

- _"**La media delle Bande è il primo obbiettivo** che deve sempre avere un
  rapporto rischi rendimento **almeno di 1/1** rispetto allo stop, viceversa
  **l'operazione non viene eseguita**"_ — 🥇 è una **condizione di scarto
  meccanizzabile**.
- _"spesso potrebbero essere **oltre 100/200 pip**"_ (distanza del target).
- **Gestione:** _"Una volta raggiunti **40/60 pip** parzializzare e chiudere tra
  il **50% / 70%** della size, portare lo stop **in pari** e lasciare correre"_.
- **Trailing:** _"La mattina successiva spostare lo stop in profit posizionandolo
  **sul sedere della candela odierna**. Eseguire la stessa manovra nei giorni
  successivi"_ — trailing giornaliero sul minimo/massimo della candela D1.
- ⚠️ _"**NB.: I valori riportati come pip raggiunti e % di parzializzazione sono
  discrezionali**"_ `[T]`.

> 🧨 **IL BUCO STRUTTURALE DEL PIANO, e va detto con un numero.** Il documento
> impone RR **minimo 1/1**, e poi prescrive di **chiudere il 50-70% della size a
> 40-60 pip** su un target che sta a 100-200 pip. Il RR **effettivo** della parte
> chiusa scende sotto 1. Tre scenari, tutti dentro le regole dichiarate
> (calcolo mio, `[INFERITO]` dalle due regole citate sopra):
>
> | scenario (tutti ammessi dal piano) | R medio del trade vincente | **win rate di pareggio** |
> |---|---|---|
> | parziale 60% a 0,5R, resto stoppato in pari | +0,30 R | **76,9%** |
> | parziale 50% a 0,5R, resto al target 1R | +0,75 R | **57,1%** |
> | parziale 70% a 0,6R, resto lasciato correre a 2R | +1,02 R | **49,5%** |
>
> **La forbice del win rate richiesto va dal 49% al 77% — e a decidere dove si
> cade è una scelta che il piano dichiara «discrezionale».** Il piano consegna
> alla discrezionalità **l'unico numero che determina se il metodo guadagna.**
> È **lo stesso identico difetto** già trovato nel modulo Mediazione
> (`ANALISI_CORSO_MEDIAZIONE_2026-08-18.md` §1.1 punto 4: win rate richiesto
> 60-77%, mai dichiarato). **Due moduli diversi, due relatori diversi, stessa
> falla** → §4.4.

### 🛑 Stop loss `[T]` — la regola più pulita del documento

1. _"Per determinare lo stop ci sposteremo dal grafico a linea al **grafico a candele**"_
2. _"Lo stop … verrà posizionato **10/15 pip sopra la spike più alta** o sopra il
   massimo raggiunto dal prezzo"_
3. _"se il nostro stop è **inferiore in termini di pip** (seguendo il punto 2),
   allora utilizzeremo **il dato fornito dall'indicatore** [volatilità media] e
   **aggiungeremo 10/15 pip**"_

> 🥇 **Tradotto in una formula, ed è pronta per il tester:**
> `SL = max( swing_estremo + 10..15 pip , ADR(50) + 10..15 pip )`
> **È un pavimento di volatilità sullo stop.** Non ce l'ha nessuno dei nostri
> EA. È il secondo pezzo copiabile del documento (§4.5).

### 🧠 Fase operativa — le 6 regole di condotta `[T]`

_"La nostra operatività è … **DISCREZIONALE, ovvero senza l'ausilio di EA / Bot**"_ `[T]`
→ 📌 **il framework dichiara di NON essere automatizzabile.** Va scritto qui,
perché condiziona tutto ciò che ne estraiamo.

1. _"Lucidi – **NON SI OPERA SE SI E' STANCHI**"_
2. _"**Con Atteggiamento militare**: Se tutte le condizioni della strategia non si sono evidenziate **NON SI APRONO POSIZIONI**"_
3. 🎯 _"**Non si vanno a cercare operazioni da fare su altri timeframe ( m15 – m30 – h1 – h4 ) saresti sempre contro trend**"_
4. _"**Se non si può operare si spegne il pc e si fa altro**"_
5. _"Se ritieni che l'operazione ti possa portare stress ( stop molto lunghi ecc. ) **meglio non farla**"_
6. _"Se ci siamo persi l'operazione ed è già partita, **non entriamo in ritardo — non si fa**"_

```
MECCANISMI            parzializzazione 50-70% a 40-60 pip · breakeven dopo il
                      parziale · trailing giornaliero sulla candela D1 ·
                      pavimento di volatilità sullo SL · filtro EMA200 ≥100 pip ·
                      scarto per RR < 1/1
REGOLE PROP CITATE    🔴 NESSUNA. Il documento non nomina mai le prop firm,
                      né un limite giornaliero, né un limite totale.
NUMERI PERFORMANCE    🔴 NESSUNO. Non un win rate, non un profit factor, non un
                      backtest. In un "piano di trading" di 22 slide.
BANDIERE ROSSE        (a) rischio 2/3% per trade
                      (b) win rate decisivo lasciato alla discrezionalità
                      (c) nessun cap giornaliero né sul rischio simultaneo
A SCHERMO NON DETTATO 🔴 le 9 slide dei PATTERN (pag. 6-15) mostrano
                      "Grafico a Linea" + "Grafico a Candele con Ingresso e
                      StopLoss" — le frecce di ingresso e stop sono DISEGNATE,
                      MAI descritte con un numero né con una definizione
                      geometrica. I pattern (Testa e Spalle, Montagna, Doppia W,
                      M, Chiesa, Orecchie di Lupo, + rovesciati) restano
                      "a occhio" → §5 domanda 5.
COSA NE COPIAMO       🟢 due componenti misurabili (§4.5): il pavimento di
                      volatilità sullo SL e il filtro EMA200 ≥100 pip.
                      🔴 NON la strategia: i pattern non sono definiti.
```

---

# 2.3 🩸 `POINT BREAK - METODI DI GESTIONE OPERAZIONI NEGATIVE.pdf`

```
FILE            POINT BREAK - METODI DI GESTIONE OPERAZIONI NEGATIVE.pdf (15 pag.)
AUTORE          [INCERTO] — nessuna firma; pacchetto Point Break
OGGETTO         catalogo di 6 tecniche per gestire una posizione in perdita
```

> 🚨 **Setaccio al massimo, come da mandato. Verdetto: il sospetto era fondato.**
> Il titolo «gestione delle operazioni negative» nasconde **esattamente** ciò che
> il protocollo prevede di cercare: **recovery e mediazione strutturale**.

### 🧮 LA MATEMATICA ESATTA, come da protocollo

**Metodo 2 — Martingala.** Definizione `[T]`: _"aumentare progressivamente
l'esposizione su una posizione che ci è andata contro, aprendo **nuovi ordini
nella stessa direzione** a livelli di prezzo più favorevoli … con l'obiettivo di
**abbassare il prezzo medio d'ingresso**"_.

| variante `[T]` | progressione | citazione |
|---|---|---|
| **Classica** | **`Size = S × 2ⁿ`** | _"la size d'ingresso viene raddoppiata rispetto all'operazione precedente (Size = S × 2ⁿ)"_ |
| **Modificata (Controllata)** | **+30% / +50%** per livello | _"incrementati mammano su base percentuale (es. +30%, +50%)"_ |
| **Averaging Down a fasce** | nuovo livello **ogni 50 pip** | _"Il mercato viene suddiviso in fasce di prezzo predefinite (es. **ogni 50 pips**). La size aumenta solo entrando in nuove fasce"_ |

**Esempio numerico del documento** `[T]`: _"Long su EUR/USD a **1.1000** → il
prezzo scende a **1.0950** → nuova long con **size doppia** → prezzo medio si
abbassa a **1.0966** → il prezzo rimbalza a **1.0970** → si chiude tutto in
profitto"_.

> ✅ **Aritmetica VERIFICATA da me:** `(1×1.1000 + 2×1.0950) / 3 = 3.2900/3 =
> **1.096667**` → arrotondato **1.0966**. **Il conto torna.** È l'unico numero
> di tutto il corpus Point Break che ho potuto verificare in modo indipendente,
> **e torna**. (Il che rende ancora più notevole che la tabella delle
> correlazioni non torni.)
>
> 📉 **Ciò che l'esempio NON dice, e che è il punto:** il recupero avviene con un
> rimbalzo di **20 pip su una discesa di 50** — cioè il metodo funziona
> **finché il mercato ritraccia**, e il documento lo ammette
> (`[T]` _"L'intera strategia si basa sull'idea che il mercato rientri. **Ma se
> non lo fa?** Il trader si trova senza vie di uscita, se non la margin call"_).
> **Esposizione dopo n raddoppi: `S × (2ⁿ⁺¹ − 1)`. A 4 step = 15× la size
> iniziale.** Il documento suggerisce come guardrail `[T]` _"Prevedi un numero
> massimo di ingressi (es. **3 o 4 step**)"_ → **anche col cap suggerito,
> l'esposizione finale è 7×-15× l'iniziale.**

**Metodo 4 — Griglia senza SL.** `[T]`: _"una serie di ordini pendenti buy e/o
sell, disposti a **intervalli regolari di prezzo (es. ogni 20 o 50 pips), senza
stop loss**"_ · esempio `[T]`: _"EUR/USD a 1.1000 → Buy a **1.1000, 1.0950,
1.0900, 1.0850**…"_ (passo **50 pip**) · `[T]` _"Ogni nuova posizione abbassa il
prezzo medio, **NON si utilizza SL sugli ordini**"_ · due gestioni: **statica**
(_"chiudi tutto quando raggiungi un certo profitto totale (es. **100€**)"_) e
**dinamica** (_"chiudi parzialmente le posizioni che tornano in profitto"_) ·
il documento stesso ammette `[T]` _"Vedere un conto in drawdown del **30-40-50%**
e continuare ad aggiungere posizioni"_.

**Metodo 5 — Stop mentale su equity.** `[T]`: _"il trader … stabilisce una soglia
massima di drawdown (es. **10% - 20% -30%** ecc.)"_ · motivazione dichiarata
`[T]`: _"**Nessuno SL visibile dal Broker e nel book**, quindi meno vulnerabilità
agli spike"_.

**Metodo 6 — Reverse entry.** `[T]`: _"si apre un'operazione nella direzione
opposta, **con maggiore size** o con un'esposizione calibrata **per recuperare le
perdite pregresse**"_ — 🔴 è **raddoppio del rischio con giustificazione tecnica**.

**Metodo 3 — Hedging.** `[T]`: _"aprire una posizione **short di pari
dimensione**, creando una copertura. In quel momento, **la perdita si congela**"_.
Uso dichiarato: `[T]` _"Per **evitare uno stop loss forzato**"_. Avvertenza del
documento `[T]`: _"se entrambe le posizioni restano in perdita a lungo, stai
**pagando swap e spread doppi** ogni giorno"_ e `[T]` _"**Evita di usare
l'hedging: Come sostituto dello stop loss**"_ — cioè il documento **elenca**
l'uso e poi lo **vieta**, nella stessa pagina.

```
REGOLE PROP CITATE    🔴 NESSUNA. Il documento ragiona su margine, leva e
                      margin call — cioè sul mondo del conto retail — e non
                      nomina MAI un limite giornaliero né una prop firm.
                      È scritto per un mondo dove l'unico limite è la
                      MARGIN CALL. Su una prop, il limite arriva 10-20 volte
                      prima.
NUMERI PERFORMANCE    nessuno
BANDIERE ROSSE        🚩 martingala S×2ⁿ · 🚩 griglia SENZA SL passo 20-50 pip ·
                      🚩 assenza di SL come scelta (metodi 1, 4, 5) ·
                      🚩 DD accettato 10/20/30% · 🚩 hedging come blocco ·
                      🚩 reverse entry con size maggiorata
A SCHERMO NON DETTATO nulla: documento interamente testuale, nessuna figura
                      con informazione mancante
COSA NE COPIAMO       ⛔ NIENTE, in nessuna forma.
                      🕵️ Valore SOLO come intelligence: è la mappa di ciò che
                      una prop cerca nei nostri ticket (§4.3).
```

---

# 2.4 🏛️ `ABTG-Point break 20250429.pdf` — **cos'è davvero**

```
FILE            ABTG-Point break 20250429.pdf (18 slide)
RELATORE        Christian Bertacchi [T] slide 6
EDITORE         Alfio Bardolla Training Group SpA [T] (disclaimer, slide 2)
DATE            "Realise 18.04.2025" (slide 1) e "Realise 09.04.2025"
                (slide 11) — due date di rilascio nello stesso file;
                nel NOME del file: 20250429
OGGETTO         il deck di PRESENTAZIONE/LANCIO della strategia Point Break
```

### ❓ Risposta alla domanda della missione: «è il documento fondativo del progetto?»

> ## 🔵 **NO.**
> **ABTG = Alfio Bardolla Training Group SpA** — è la **casa editrice del corso**,
> `[T]` nel disclaimer della slide 2, ripetuto 14 volte nella stessa pagina.
> Il prefisso `ABTG_` dei nostri EA viene **da lì**: è il nome della scuola i cui
> materiali Claudio segue. **Ma questo PDF non è fondativo di niente per noi**:
> è il **deck commerciale di lancio** di una strategia (Point Break) partita ad
> **aprile 2025**, mentre il nostro archivio ha già un
> `ABTGApertura_Mercati_20240507.pdf` (analizzato in
> `docs/live_emiliano/ANALISI_SLIDE_APERTURE.md`) — **stesso editore, altro
> coach, altra strategia, un anno prima.**
> `ABTG` nel nome dei nostri EA = **etichetta di provenienza del metodo**, non
> acronimo di un progetto. `[INFERITO]` da: disclaimer `[T]` + il file gemello
> già in archivio + i nomi degli EA nel repo.

### 📌 Ciò che questo deck aggiunge (poco, ma due cose contano)

| slide | contenuto `[T]` | valore |
|---|---|---|
| 8 | _"Basata **sull'inversione del mercato** · Operatività principale su **Time Frame D1** · Utilizzabile anche su Time Frame più stretti (con gestione adattata)"_ · strumenti: **Forex, Indici, Materie prime** | 🟢 classifica la strategia: **mean-reversion su D1** |
| 9 | **«Bande di Bollinger 3.7-1,4»** | 🔴 **CONTRADDIZIONE** col PIANO DI TRADING (`Periodo:37 Deviazione:1.4`). `3.7` è quasi certamente un refuso di `37` `[INFERITO]`, ma **il deck ufficiale porta un numero sbagliato** |
| 10 | i 6 pattern: Montagna, W, M, Chiesa, Orecchie di Lupo, Testa e Spalle | coerente col PIANO (che ne elenca 9 contando i rovesciati) |
| 6 | _"Trader professionista da **oltre 5 anni**"_ | `[dichiarato, NON verificato]` |

### 🔎 **Due scoperte dalla LETTURA DELL'IMMAGINE della slide 9** (nessuna era nel testo)

1. 🟡 **L'oscillatore nello screenshot NON è lo stocastico standard.** La
   sotto-finestra è etichettata **`Elliott Wave False Breakout Stochastic
   72.1627 83.6910`** e disegna **frecce verdi e rosse di segnale** sul grafico.
   Il PIANO DI TRADING ufficiale prescrive invece _"Indicatore Stocastico:
   Periodo K: 5 Periodo D: 3 Rallentamento: 3"_ `[T]`, cioè lo stocastico nudo.
   **Il coach mostra a schermo un indicatore custom che il piano non nomina.**
   → §5 domanda 3.
2. 🟢 **Il coach lavora sul NOSTRO broker.** Il grafico è `AUDJPY.**bcm**,Daily` e
   la barra delle schede mostra:
   `UKOIL.bcm,H1 · D30EUR.bcm,H1/M15/H4/Daily · SPXUSD.bcm,H4 · 225JPY.bcm,Daily ·
   EURUSD.bcm,M1/M5 · USDJPY.bcm,H1 · GBPUSD.bcm,H1 · NZDJPY.bcm,H4 · AUDJPY.bcm,Daily`.
   **Suffisso `.bcm` = BCM, lo stesso broker del conto demo 50503392** e gli
   stessi nomi-simbolo che usiamo negli `.ini`.
   ➡️ **Conseguenza pratica: qualunque componente di Point Break si decida di
   misurare, lo si misura sugli STESSI dati che il coach ha sotto gli occhi.**
   Niente disallineamento di simbolo, niente conversione di spread. È il regalo
   più concreto di questo PDF.
   📌 E si nota che **3 delle 13 schede aperte sono cross JPY** (USDJPY, NZDJPY,
   AUDJPY) — il coach tiene aperti insieme più membri della famiglia più
   correlata del suo stesso glossario.

```
PARAMETRI CON VALORE  EMA 200 · Bande di Bollinger "3.7-1,4" (refuso) · D1
MECCANISMI            nessuno descritto (è un deck di lancio)
REGOLE PROP CITATE    nessuna
NUMERI PERFORMANCE    nessuno — 18 slide di lancio SENZA un solo numero di
                      risultato. 🟢 Onesto (nessuna promessa numerica da
                      smontare) e 🔴 vuoto (niente da verificare).
BANDIERE ROSSE        nessuna
A SCHERMO NON DETTATO le 6 slide dei pattern (12-17) sono SOLO immagini con
                      la didascalia "Pattern valido anche rovesciato" —
                      stessa lacuna del PIANO
COSA NE COPIAMO       🟢 chiude una richiesta d'archivio (§4.6) + il fatto
                      che il corso gira su BCM
```

---

# 2.5 🟡 `Come tradare il gold.pptx` — 14 slide

```
FILE            Come tradare il gold.pptx
RELATORE        [INCERTO] — nessuna firma nelle slide
OGGETTO         XAU/USD: contesto macro e fondamentale, non regole di ingresso
```

### Regole dichiarate `[T]`

| tema | regola `[T]` |
|---|---|
| **DXY** | _"Oro e USD sono **inversamente correlati**. DXY forte → pressione ribassista su Gold. DXY debole → supporto per Gold"_ · _"**DXY forte → Gold short. DXY debole → Gold long**"_ |
| **tassi reali** | _"Quando i tassi reali **scendono o sono negativi**, l'oro diventa più attraente → **LONG**. Quando i tassi reali **salgono** … → **SHORT**"_ (fonte dati: _"rendimenti Treasury a 10 anni e CPI"_) |
| **inflazione** | _"Se l'inflazione sale e i tassi non vengono alzati in modo aggressivo → **LONG** oro. Se l'inflazione è contenuta e le banche centrali sono **hawkish** → **SHORT**"_ |
| **geopolitica** | _"Guerre, atti terroristici … → aumentano la domanda rifugio. In questi casi il Gold sale rapidamente → **LONG**"_ |
| **volatilità** | _"l'oro può fare **spike da 30-60 pip in pochi minuti** → pazienza"_ · _"**Mai inseguire la candela emozionale**"_ |
| **rischio** | 🟢 _"Gestione del rischio chirurgica: **SL sempre definito**, gold è volatile"_ |
| **orari** | _"Orari di maggiore attività: **sessioni Londra e New York**"_ — fuso non dichiarato → `[INCERTO]` |
| **correlazioni** | _"Osserva la correlazione con altri asset: es. **EUR/USD, SP500, Crude Oil**"_ · _"Crude Oil ⬆ → inflazione ⬆ → oro ⬆ · SP500 ⬇ → flight to safety → oro ⬆ · USD ⬆ → oro ⬇"_ |
| **overtrading** | _"**Evita overtrading**: attendi i momenti, **non entrare per noia**"_ |

**Indicatori proposti con timeframe** `[T]` (slide 11): RSI(14) su H1-H4-D1 ·
MACD su H4-D1 · EMA 50 / EMA 200 su H1-H4-D1 · Volumi (OBV) su H1-H4 ·
Fibonacci su H1-D1. ⚠️ **Nessun parametro oltre il periodo di RSI ed EMA.**

**Esempi storici citati** `[T]`: _"Invasione Ucraina 2022 → **XAU/USD +10%**"_,
_"Crisi banche SVB/CS 2023 → Gold spike"_ — `[dichiarato, NON verificato]`.

```
BANDIERE ROSSE        🚩 slide 10: dentro la definizione di "DXY in rally" è
                      incollata una FOTOGRAFIA DI MERCATO DATATA — "Il DXY
                      estende il rally nei pressi di 98,70 … Il cambio GBP/USD
                      rompe al ribasso a 1,3367" [T] — presentata come se
                      fosse parte della regola. È un commento di giornata
                      copiato in una slide didattica: fra sei mesi è falso.
COSA NE COPIAMO       ⚪ niente di meccanizzabile: zero ingressi, zero SL,
                      zero TP numerici. Solo contesto.
```

---

# 2.6 🛢️ `Come tradare il petrolio.pptx` — 12 slide

```
FILE            Come tradare il petrolio.pptx
RELATORE        [INCERTO]
OGGETTO         WTI / Brent: driver macro + due checklist a punteggio
```

### Regole dichiarate `[T]`

- **Strumenti**: _"**WTI** … scambiato al NYMEX · **Brent** … scambiato all'ICE"_,
  _"hanno **correlazioni molto strette**"_ (nessun numero).
- **Dollaro**: _"**DOLLARO SALE → PETROLIO SCENDE · DOLLARO SCENDE → PETROLIO SALE**"_.
- **Scorte**: 🎯 _"**ogni mercoledì** l'EIA pubblica le scorte. Aumento delle
  scorte = offerta in eccesso → prezzi giù; calo delle scorte → prezzi su"_ —
  **l'unico evento a cadenza fissa e verificabile di tutto il corpus.**
  ⚠️ **Orario non dichiarato** → `[INCERTO]`.
- **Rischio**: 🟢 _"Il petrolio è volatile: gestisci bene la size e **usa
  stop-loss sempre**"_.
- **Macro**: _"PMI sotto 50"_ come soglia di rallentamento; _"driving season USA"_
  estiva e riscaldamento invernale come stagionalità.

### 🥇 L'unica regola quasi-quantitativa dei due PPTX

Due checklist da 7 voci ciascuna (LONG e SHORT), con **regola di soglia esplicita** `[T]`:

> _"**3–4 segni ✔️ = possibilità di rimbalzo tecnico. 5+ segni ✔️ = condizione
> macro strutturale per operatività long**"_ (e speculare per lo short).

Le 7 voci LONG `[T]`: dati macro positivi (PMI > 50, PIL su, disoccupazione giù) ·
domanda stagionale in crescita · taglio produzione OPEC/OPEC+ · scorte EIA in calo ·
tensioni geopolitiche · dollaro debole (DXY in discesa) · **conferma tecnica
(prezzo sopra media mobile, breakout rialzista, RSI > 50)**.

📌 **È un sistema a punteggio 0-7 con due soglie (3 e 5)** — la sola struttura
decisionale numerica dell'intero materiale Point Break. **Ma 6 voci su 7 sono
giudizi macro discrezionali**, e la settima («conferma tecnica») ne impacchetta
tre in una. **Non è meccanizzabile senza inventare le definizioni mancanti.**

```
BANDIERE ROSSE        nessuna sul metodo
COSA NE COPIAMO       ⚪ niente di operativo. 🟡 Va registrato che la scuola,
                      quando vuole, SA scrivere una regola a soglie — il che
                      rende più notevole che il PDF CORRELAZIONI non lo faccia.
```

---

# 2.7 🚩 LA BANDIERA ROSSA COMUNE AI DUE PPTX — le note del relatore sono **RICICLATE**

Estraendo `ppt/notesSlides/` di entrambi i deck: **le note del relatore non
parlano di oro né di petrolio.** Parlano dell'**apertura dei mercati**:

> `[T]` (note, slide 5 del deck GOLD e slide 4 del deck PETROLIO, **identiche**):
> _"Ogni giorno, ci sono due momenti in cui il mercato prende vita: le **9:00**
> del mattino e le **15:30** del pomeriggio. **Emiliano** ci ricorda sempre con
> grande enfasi …"_
>
> `[T]` (note, slide 6 GOLD / slide 5 PETROLIO): _"🕘 Alle **9:00 del mattino,
> ora italiana**, si apre ufficialmente il mercato europeo … l'indice che più di
> ogni altro incarna questa fase è il **DAX** … Preferiamo il **Dow Jones** per la
> sua struttura più lenta e prevedibile … ci rivolgiamo al **Nasdaq** quando
> cerchiamo reattività e spike più forti … **E l'S&P 500?** … a volte troppo
> 'compresso' e difficile da gestire"_
>
> `[T]`: _"Usate questo sito: **mataf.net/forex/tools/volatility**"_

**Sono le note della lezione «La Magia delle Aperture», di Emiliano** — quella
già analizzata in `docs/live_emiliano/ANALISI_SLIDE_APERTURE.md`. Chi ha montato
i due PPTX ha **duplicato un file esistente e cambiato solo le slide**.

**Le tre conseguenze, in ordine di importanza:**
1. ⚠️ **Le note NON sono commento alle slide.** Chi legge i due deck cercando
   "cosa dice il relatore sull'oro" trova un discorso sul DAX. Nessuna
   informazione su gold/petrolio va estratta dalle note.
2. 🟢 **Ma le note confermano, per iscritto e in un secondo file, il contenuto
   della lezione aperture** che avevamo già: DAX alle **9:00 ora italiana**
   (dichiarato! = **08:00 server BCM**, la nostra regola di casa), Dow preferito
   per struttura, Nasdaq per gli spike, S&P scartato. **Il "9:00 ora italiana"
   è dichiarato esplicitamente**: è uno dei rarissimi orari con fuso nel corpus.
3. 🔴 **NON è una fonte indipendente.** Stessa scuola, stesso file d'origine:
   **una fonte, non due.** Va contato come tale in ogni convergenza.

---

# 3. ⚪ LO SCARTO, DICHIARATO — `POINT BREAK - ESERCIZI PER IMPULSIVITÀ`

```
FILE            POINT BREAK - ESERCIZI PER IMPULSIVITA' NEL TRADING.pdf (3 pag.)
OGGETTO         6 esercizi psicologici + piano settimanale lun-dom
```

Contenuto `[T]`: (1) Diario dell'impulso · (2) Tecnica «Sedia Vuota» · (3)
Visualizzazione 3 minuti ogni mattina · (4) Protocollo **STOP-3-Respiro**
(_"inspira 4 sec – trattieni 2 – espira 6 sec"_) · (5) Scommessa a freddo
(_"donerò **10 euro** a una causa che non supporto"_) · (6) **Checklist Bloccante**.

**Motivo dello scarto: zero parametri di trading, zero regole di mercato.**
È materiale per un operatore **discrezionale**; noi siamo sistematici e il
problema che questi esercizi risolvono (l'impulso davanti al grafico) **da noi
non esiste per costruzione**.

🟢 **Salvo una riga, e vale la pena registrarla.** L'esercizio 6 `[T]`: _"Creare
una checklist da spuntare prima di ogni trade … **Se anche solo una risposta è
NO, non si entra. La checklist diventa un gatekeeper**"_. È **letteralmente la
descrizione a parole del nostro Guardian**: un cancello che nega l'ingresso
quando una condizione non è soddisfatta. Con una differenza che è tutto:
**da loro il gatekeeper è la volontà del trader, da noi è codice.**
📌 **E questo è il punto di contatto vero fra il corso e il nostro piano prop:
la scuola risponde al rischio con la DISCIPLINA; noi rispondiamo con un CAP.**

---

# PARTE 4 — 🏠 **COSA CAMBIA PER NOI**

## 4.1 Confronto riga per riga col `PIANO_PROP.md`

| riga PIANO_PROP | nostro valore (stato) | **Point Break** | verdetto |
|---|---|---|---|
| **A1** rischio/trade prop | **0,65%** 🧊 congelato | **2/3%** `[T]` | 🔴 **il corso è 3,1×–4,6× più largo**. Fonte di **4° rango** (materiale didattico, zero misure, zero backtest): **non riapre A1**. Sposta solo il bordo alto della distribuzione già nota (0,5 · 0,5 · **0,65** · 1,0 · 2,4 → ora anche **2,0-3,0**) |
| **A4** tetto per sedia sul conto piccolo | **1,0% mai oltre** 🧊 firmato oggi | **2/3%** | 🔴 il corso sta **2×-3× sopra il tetto firmato stamattina**. Nessuna misura lo sostiene → A4 resta |
| **B1** cap giornaliero | pausa 4,0% + emergenza 4,9% 🧊 | 🔴 **NON ESISTE** | ⚠️ **il piano ufficiale del corso non ha alcun limite di perdita giornaliera.** Non è un valore diverso: è un **meccanismo assente** |
| **B2** cap totale | emergenza 9,9% 🧊 | 🔴 **NON ESISTE** (anzi: il doc gestione negative propone DD accettabili del **10/20/30%**) | 🔴 **conflitto frontale**: il loro *minimo* accettabile è il nostro *muro* |
| **C1** cap rischio aperto simultaneo | **3,25%** (5 SL vivi da 0,65) 🧊 firmato oggi | 🔴 **NON ESISTE**, e col 2/3% bastano **2 posizioni** per superarlo | ✅ **C1 non è contraddetto: è semplicemente un problema che il corso non affronta.** Vedi §4.2 |
| **C2** max sedie | «conta gli SL vivi, non le sedie» 🧊 | nessun numero di posizioni contemporanee | — |
| **C3** criterio di uscita sedie | 3 corsie 🧊 | nessun criterio di dismissione | — |
| **D1/D2** filtro news | aperto/proposto | 🟡 solo consigli qualitativi: _"non tradare senza sapere cosa sta per uscire"_ `[T]` (gold), _"Non tradare il petrolio senza sapere cosa fa l'EIA ogni mercoledì"_ `[T]` | nessuna gamba nuova: **nessun minuto dichiarato** |
| **E5/E6** randomizzazione / anti-detection | proposto / registro difensivo | nessuna menzione | — |
| — | **SL sempre presente** (regola implicita di casa) | 🟢 il PIANO e i due PPTX dicono **SL sempre**; 🔴 il doc gestione negative propone **tre metodi senza SL** | 🚨 **il pacchetto si contraddice con se stesso** (§4.4) |

> ### 📐 Dove il corso è PIÙ SEVERO di noi (e va detto, perché ci sono due voci)
> 1. 🥇 **La regola 3 della fase operativa**: `[T]` _"Non si vanno a cercare
>    operazioni da fare su altri timeframe (m15 – m30 – h1 – h4) **saresti sempre
>    contro trend**"_. È un **divieto esplicito di scendere di timeframe per
>    cercare trade** — noi non abbiamo nessuna regola scritta che lo vieti, e la
>    nostra flotta opera su M5/M15/H1/H4/D1 insieme. **Non è un difetto nostro**
>    (i nostri sono motori separati e misurati, non una caccia discrezionale), ma
>    **la regola andrebbe scritta come principio di casa nella forma giusta**:
>    _"non si aggiunge un timeframe per trovare un trade che il timeframe
>    dichiarato non ha dato"_.
> 2. 🥈 **La regola 6**: `[T]` _"Se ci siamo persi l'operazione ed è già partita,
>    **non entriamo in ritardo — non si fa**"_. Da noi questo è un rischio reale
>    e concreto: gli EA di apertura che riarmano dopo il primo segnale. **Vale
>    come domanda di audit sulla flotta**, non come regola da firmare oggi.
> 3. 🥉 Il filtro **RR ≥ 1/1 come condizione di SCARTO** (_"viceversa
>    l'operazione non viene eseguita"_ `[T]`) è più duro di quanto facciamo:
>    diversi nostri motori aprono senza un vincolo minimo di RR.

## 4.2 🎯 L'incrocio con la REGOLA JPY FIRMATA OGGI

**La regola in vigore** (`prove/TORNEO_JPY_CRITERI.md` §2, firmata **prima** dei
numeri):
> _"**Dalla famiglia JPY entra al massimo UNA sedia. Mai il paniere.** Qualunque
> cosa dicano i numeri degli altri sei."_

**Cosa dice il materiale Point Break, e come va pesato:**

| aspetto | esito |
|---|---|
| **Il corso ha una regola di correlazione?** | 🔴 **NO** (§1.1) — nessuna soglia, nessun cap, nessun imperativo |
| **I numeri del corso sostengono la nostra regola?** | 🟢 **SÌ, e in modo netto**: 5 righe su 15 delle «positive forti» sono JPY×JPY (+0.81 … +0.88), e USD/JPY compare in altre 5 su 15 delle «negative forti». **La famiglia JPY è la più concentrata dell'intero glossario del corso** |
| **Quanto valgono, quei numeri?** | 🔴 **Poco**: sono `[dichiarati, "stimati"]`, senza periodo/TF/metodo/fonte, in un documento che **contiene una riga aritmeticamente impossibile** e **una figura che smentisce le sue stesse tabelle** |
| **Il corso è una fonte indipendente?** | 🔴 **NO**: stesso editore (ABTG) dei moduli Breakout/Mediazione già analizzati. **Una scuola = una fonte** |

> ## ✅ **VERDETTO: la regola JPY NON si tocca, e NON si rinforza con questo PDF.**
> Resta in piedi **sulla base che aveva già** — `docs/Portafoglio_Strategie.md`
> (_"7 EA sui cross JPY = un'unica scommessa sullo yen"_) e i criteri del torneo
> congelati stamattina. Il PDF CORRELAZIONI entra agli atti come **corroborazione
> qualitativa di 4° rango**: dice che la scuola *vede* la concentrazione JPY, non
> che l'abbia *misurata*.
>
> 🧨 **E c'è un risvolto che pesa più della corroborazione, ed è quello che
> davvero cambia qualcosa per noi:**
> **il corso mette in mano all'allievo una tabella che segnala 5 coppie JPY
> fortemente correlate, e nella stessa cartella un piano operativo che non
> contiene una sola parola su quante posizioni correlate si possano tenere
> aperte.** La correlazione è **documentata e poi orfana**. E lo screenshot del
> coach (§2.4) mostra **tre schede JPY aperte insieme** sul suo terminale.
> ➡️ **L'intuizione di Claudio del 18/08 non solo regge: colma un buco che la
> fonte stessa lascia aperto.**

## 4.3 🕵️ L'incrocio con la CONFORMITÀ PROP (aree B, C, E)

Il documento «METODI DI GESTIONE OPERAZIONI NEGATIVE» **non ci dà un parametro**,
ma è **il miglior catalogo che abbiamo di ciò che una prop cerca nei ticket** —
stesso uso difensivo della riga **E6** del `PIANO_PROP` (intelligence, mai
pratica):

| pattern insegnato | come si vede nella cronologia ordini | tocca noi? |
|---|---|---|
| martingala `S × 2ⁿ` | volumi in progressione geometrica sullo stesso simbolo/lato | ❌ nessun nostro EA raddoppia |
| griglia senza SL, passo 20-50 pip | ordini pendenti equispaziati, `sl = 0` | ⚠️ **la griglia BULGE è già segnalata in `PIANO_PROP` C1** (10 posizioni = 6,50% con UNA sedia) — **il meccanismo esiste in casa nostra** |
| posizioni **senza SL** (metodi 1, 4, 5) | `sl == 0` sul ticket | ⚠️ il Guardian **oggi non blocca** le posizioni senza SL: le **logga come warning** (`PIANO_PROP` C1, `OpenRiskPct()`). Una posizione senza SL **non consuma il cap C1**: è un buco noto e va tenuto d'occhio |
| hedging long+short pari size | due posizioni opposte sullo stesso simbolo | ⚠️ conto BCM è **HEDGING**: tecnicamente possibile. `PIANO_PROP` E2 registra che FundedNext vieta l'hedge **multi-account** e ammette quello **stesso conto** `[dichiarato]` |
| stop mentale / DD 10-20-30% | nessuna traccia nei ticket, ma **DD in equity** | 🔴 incompatibile con qualunque muro prop |

> 🔴 **VIETATO PER NOI, senza eccezioni.** Nessuno dei sei metodi entra in un EA,
> in un preset, in una proposta. La riga sta qui perché **saperli riconoscere è
> parte della conformità**, non perché siano un'opzione.

## 4.4 🧩 IL FILO CHE UNISCE I TRE MODULI ANALIZZATI OGGI

Tre analisi, tre relatori diversi, **stessa scuola**, **stesso difetto strutturale**:

| modulo | relatore | il numero che manca |
|---|---|---|
| **Mediazione** (lez. 26-33) | Manuela Negro | win rate richiesto **60-77%**, **mai dichiarato** (`ANALISI_CORSO_MEDIAZIONE` §1.1) |
| **Breakout** (lez. 34-40) | Manuela Negro | **la correlazione fra i 7 cross JPY, mai nominata** (`ANALISI_CORSO_BREAKOUT` §buco n.4) |
| **Point Break** (questo referto) | Christian Bertacchi | win rate richiesto **49-77%**, **mai dichiarato**; parzializzazione **«discrezionale»** |

> 🎯 **La regolarità, ed è la cosa più utile che porto a casa oggi:**
> **la scuola insegna con precisione DOVE entrare e DOVE mettere lo stop, e
> lascia sistematicamente indeterminato il parametro che decide se il metodo
> guadagna.** In tutti e tre i moduli quel parametro è **la gestione dell'uscita**
> — parzializzazione, aggiunta, media — e in tutti e tre è **«discrezionale»**.
>
> **Per noi la conseguenza è operativa, non filosofica:** ogni volta che
> ricostruiamo una strategia del corso, **il pezzo che il tester deve decidere
> non è l'ingresso — è l'uscita.** L'ingresso ce lo danno; l'uscita dobbiamo
> misurarla noi. È già successo con la Mediazione (spec §5, la scatola nera
> ricostruita) e con la Breakout (le due divergenze di implementazione).
>
> ⚠️ E c'è la **contraddizione interna del pacchetto Point Break**, che va scritta
> nero su bianco: il PIANO DI TRADING dice `[T]` _"lo stop verrà determinato…"_ e
> il PPTX gold dice `[T]` _"**SL sempre definito**"_, mentre il documento
> METODI DI GESTIONE, **nella stessa cartella**, descrive **tre metodi che
> funzionano solo togliendo lo stop**. **Non è ambiguità: è contraddizione.**

## 4.5 🟢 COSA COPIAMO DAVVERO — due componenti, non una strategia

**Point Break come strategia NON entra nell'imbuto**, e il motivo è dichiarato
dalla fonte stessa: i 9 pattern (Testa e Spalle, Montagna, Doppia W, M, Chiesa,
Orecchie di Lupo + rovesciati) sono **mostrati come immagini e mai definiti con
un numero**. Senza definizione geometrica **non c'è niente da codificare**, e
inventarla noi significherebbe testare una nostra invenzione con l'etichetta del
corso — l'errore che il metodo di casa vieta.

**Ma due componenti sono meccanizzabili così come sono scritte**, e nessuna delle
due esiste nella nostra flotta:

> ### 🥇 **PROPOSTA P-PB1 — il pavimento di volatilità sullo stop**
> `SL = max( swing_estremo ± 10..15 pip , ADR(50) + 10..15 pip )`
> Fonte `[T]`: PIANO DI TRADING slide 20, punti 2-3.
> **Perché ci interessa:** i nostri SL sono a struttura (range/swing) o a
> moltiplicatore ATR, **mai con un pavimento assoluto legato all'ADR a 50
> giorni**. È esattamente la protezione contro lo «stop troppo stretto in
> giornata volatile». **Costo: un modulo `.mqh` piccolo. Misurabile su qualunque
> sedia esistente come variante A/B.**
> ⚠️ **Prerequisito bloccante**: sapere QUALE indicatore è la «Volatilità Media
> Giornaliera · `ImpPeriods: 50`» (§5 domanda 4). Senza, l'ADR lo definiamo noi
> e non è più la loro regola.

> ### 🥈 **PROPOSTA P-PB2 — il filtro «EMA200 lontana almeno 100 pip»**
> `|prezzo_ingresso − EMA200| ≥ 100 pip` come **condizione di NON ingresso**.
> Fonte `[T]`: PIANO DI TRADING slide 16, punto 4.
> **Perché ci interessa:** è l'**esatto opposto** del nostro `ABTG_EMA200`
> (sedia 12, promossa con 30/30 in R29). Qui la media è **zona di esclusione**,
> lì è **segnale di ingresso**. **Le due letture non possono essere entrambe
> giuste sullo stesso mercato e timeframe** → è una domanda misurabile, e la
> misura è economica: si aggiunge il filtro come asse booleano a un round
> esistente. 🟢 **Bonus: i dati sono gli STESSI del coach** (BCM, §2.4).

> ### 🥉 **PROPOSTA P-PB3 — Bollinger (37, 1.4) nel vivaio parametri**
> Il settaggio è insolito e **dichiarato due volte** (PIANO `[T]` + grafico di
> pag. 4). La nostra famiglia **Breaking Band** già lavora sulle Bollinger:
> **aggiungere (37, 1.4) come cella di confronto costa quasi nulla.**
> ⚠️ Con la nota che il deck ABTG scrive **«3.7-1,4»** (§2.4): il numero giusto
> è **37**, `[INFERITO]` dal grafico e dal PIANO.

**Nessuna delle tre è una decisione**: sono proposte, e la parola è di Claudio.

## 4.6 📁 UNA RICHIESTA D'ARCHIVIO CHE SI CHIUDE OGGI

`docs/live_emiliano/CATALOGO_STRATEGIE_CORSO.md` (12/08), sezione **«MATERIALI DA
CHIEDERE (Claudio)»**, quarta riga: _"Materiale «punte di Larry» · **slide Point
Break di Christian**"_. E nella classifica d'attacco, punto 4: _"**Point Break:
upgrade solo con le slide di Christian (BB 37/1.4 + figura «a occhio»)**"_.

> ✅ **Le slide sono arrivate, e il censimento del 12/08 aveva ragione su
> entrambi i punti**, alla lettera:
> - **«BB 37/1.4»** → **confermato testualmente** `[T]` (PIANO slide 3).
> - **«figura a occhio»** → **confermato**: i 9 pattern sono immagini senza una
>   sola definizione numerica (§2.2).
>
> 🎯 **Cioè: l'"upgrade" atteso da sei giorni è arrivato, ed è arrivato con la
> conferma che l'upgrade non è possibile come strategia** — ma con **due
> componenti nuove e misurabili** che il censimento non poteva prevedere (§4.5).
> La riga del catalogo si può marcare **EVASA**.

---

# PARTE 5 — ❓ LE DOMANDE PER CLAUDIO

In ordine di quanto sbloccano.

| # | domanda | perché blocca |
|---|---|---|
| **1** | 🕐 **In che FUSO è scritto il PIANO DI TRADING?** («studio H12 **alle ore 11**, orario di cambio candela» + «D1 fra le **21 e le 22**»). Serve: uno **screenshot dell'orologio del terminale di Christian** o il nome del server MT5 che usa. | 🔴 **Bloccante per qualunque uso.** Se il suo server è UTC+3 (`[INFERITO]` dal «cambio candela alle 11»), su **BCM** lo stesso momento è le **12:00 server = 13:00 italiane**. Un orario col fuso sbagliato è **peggio di nessun orario** (regola di casa) |
| **2** | 🔗 **Esiste una LEZIONE o un VIDEO sulle correlazioni?** Il PDF è solo tabelle: **nessuna regola**. Se la regola («non più di N posizioni correlate», «sopra 0,80 si sceglie una sola») è stata detta **a voce**, serve la trascrizione. | 🥇 È **la domanda della missione**. Oggi la risposta agli atti è «il corso non ha regole di correlazione» — e cambierebbe solo con una fonte parlata |
| **3** | 🎛️ **Quale oscillatore è quello vero?** Il PIANO prescrive lo **Stocastico 5/3/3**; lo screenshot ufficiale del deck ABTG mostra **«Elliott Wave False Breakout Stochastic»** con **frecce di segnale**. Il corso distribuisce quel file `.ex5`/`.mq5`? | 🔴 Se i segnali del corso vengono da un indicatore custom con frecce, **la checklist scritta non descrive ciò che il coach fa a schermo** |
| **4** | 📏 **Nome e file esatti dell'indicatore «Volatilità Media Giornaliera» (`ImpPeriods: 50`)** — nel grafico stampa `AUDUSD: 57.02 pips` (pag. 4) e `GBPUSD: 83.73 pips` (pag. 20). | 🔴 **Prerequisito della proposta P-PB1**: senza sapere come calcola l'ADR, il pavimento di volatilità lo definiamo noi e non è più la loro regola |
| **5** | 📐 **I 9 pattern hanno una definizione numerica da qualche parte?** (quante candele, che profondità di ritracciamento, che tolleranza fra le spalle). Nelle slide sono **solo disegni**. | 🔴 Decide se Point Break è **testabile come strategia** o solo come **due componenti** (§4.5) |
| **6** | 🩸 **Il documento «METODI DI GESTIONE OPERAZIONI NEGATIVE» è materiale INFORMATIVO o è la gestione RACCOMANDATA dal corso?** Il coach, nelle lezioni, dice di usarne uno? | 🔴 Cambia la natura del framework: catalogo enciclopedico con avvertenze **oppure** metodo insegnato. Nella seconda ipotesi il framework è **inutilizzabile in prop** in blocco |
| **7** | 🖼️ **I 6 PPTX/PDF hanno dei VIDEO corrispondenti?** Le note dei due PPTX sono **riciclate da un'altra lezione** (§2.7): il parlato vero su oro e petrolio, se esiste, è solo nei video | 🟡 Le due presentazioni oggi valgono come contesto; con l'audio potrebbero valere di più |
| **8** | ⏰ **A che ora escono le scorte EIA del mercoledì**, e in che fuso il corso lo intende? (deck petrolio: _"ogni mercoledì l'EIA pubblica le scorte"_ `[T]`, **orario assente**) | 🟡 È **l'unico evento a cadenza fissa** del corpus: con l'orario diventerebbe un filtro news misurabile su UKOIL/USOIL |

---

# 📌 APPENDICE — riproducibilità

Tutto ciò che c'è qui sopra si rigenera con tre comandi (poppler + python3):

```bash
cd backtest_pipeline/caccia_strategie/trascrizioni_corso_2026-08-18/materiale_pointbreak
pdftotext -layout "POINT BREAK - PIANO DI TRADING.pdf" -          # testo slide
pdftoppm -r 400 -png -f 3 -l 3 "POINT BREAK - CORRELAZIONI.pdf" m  # la matrice rotta
unzip -o "Come tradare il gold.pptx" -d /tmp/gold                  # slide + note XML
```

Le note dei PPTX stanno in `ppt/notesSlides/notesSlideN.xml`, le slide in
`ppt/slides/slideN.xml`; il testo è nei nodi `<a:t>`.

---

_Referto chiuso il 18/08/2026. Nessuna sedia toccata, nessun parametro cambiato,
nessuna riga di `PIANO_PROP.md` modificata. Tre proposte (P-PB1, P-PB2, P-PB3) e
otto domande sul tavolo di Claudio._
