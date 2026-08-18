# 🎓 ANALISI DELLE TRASCRIZIONI — MODULO MEDIAZIONE DEL CORSO DI CLAUDIO

**Data:** 18/08/2026 · **Fonte:** 8 trascrizioni, lezioni **26-33**, in
`backtest_pipeline/caccia_strategie/trascrizioni_corso_2026-08-18/modulo_mediazione/`
(**58.689 caratteri, lette per intero, riga per riga**).
**Relatrice:** **Manuela Negro** — `[T]` confermata **testualmente** in lez. 33
(l'email di contatto), non piu' solo "riferito da Claudio".

**Consegna gemella:** la specifica implementabile sta in
`backtest_pipeline/prove/MEDIAZIONE_CORSO_SPEC.md`. **Qui** ci sono le schede
per lezione, le citazioni, le contraddizioni, l'aritmetica e il confronto col
setaccio di casa; **li'** c'e' la strategia montata per un developer.
**Non duplico: linko.**

**Analisi del modulo successivo (Breakout, lez. 34-40):**
`ANALISI_CORSO_BREAKOUT_2026-08-18.md` · spec: `prove/BREAKOUT_CORSO_SPEC.md`

> 🔒 **Nessuna modifica al forward. Nessuna modifica a `PIANO_PROP.md`. Nessun
> EA toccato.** Qui si misura e si propone, non si agisce.
>
> ⚠️ **Sui "profitti ottimi" del mandato, subito e chiaro:** tutti i numeri di
> risultato di questo modulo sono `[dichiarati dal corso, NON verificati da
> noi]` — commentati a voce su un foglio di calcolo mai dettato, **senza N
> operazioni, senza win rate, senza date, senza broker**. **I profitti veri li
> misurera' il tester, SE e SOLO SE la strategia passa il setaccio.** In questo
> referto non c'e' un solo numero di profitto che possiamo firmare.

---

# PARTE 1 — 🔥 LA SINTESI, PRIMA DI TUTTO

## 1.1 Il verdetto in cinque righe

1. 🏆 **HO APERTO LA SCATOLA NERA.** Il "foglio Excel proprietario" che il corso
   presenta come il proprio segreto (_"sulla base dei parametri che ho studiato
   appunto per il cross in oggetto"_) **e' stato ricostruito per intero dal solo
   audio**: tre formule, tre parametri. Predicono **21 valori su 3 cross
   diversi** — e **21 su 21 coincidono** col parlato, al centesimo di pip.
   **Non ci serve il file.** (SPEC §5)
2. 📐 **La strategia e' meccanizzabile al 73%** (24 regole certe su 33 decisioni
   operative). 3 ambiguita' aperte, **12 buchi**, di cui **uno bloccante**
   (parametri SuperTrend) e **uno grave** (l'aggancio del rischio al capitale).
3. 🔴 **La classificazione onesta: griglia di averaging contro-movimento, cap
   fisso a 6 ingressi, progressione geometrica ×1,5, con STOP TOTALE HARD sul
   pacchetto.** **La relatrice la chiama lei stessa _"propriamente appunto un
   sistema di Martingala"_** `[T]` lez. 31. **Non e' una martingala illimitata:
   il cap c'e', lo stop c'e' ed e' depositato al broker su ogni singolo ticket.**
   Ma la forma del pagamento e' quella della griglia (§1.4).
4. 🧨 **Il numero che decide tutto NON C'E'.** Il payoff impone un **win rate fra
   il 60% e il 77%** per stare in pari (§1.4). **Il corso non dichiara mai il
   win rate.** In una lezione intitolata "backtest della strategia".
5. 🚨 **E c'e' un sospetto di rischio sottodichiarato di un fattore 2,29** —
   1,76% mostrati all'utente contro **4,03%** ricostruiti (§1.5). **Va sciolto
   PRIMA di qualunque uso, non dopo.**

## 1.2 🔥 IL COLPO GROSSO — la geometria del corso, in tre righe

Sia `C` = chiusura della candela di segnale, `d` = +1 (BUY) / −1 (SELL),
`P` = parametro del cross.

```
6 LIVELLI :  L_k = C − d · k · (P/2)      k = 0..5      ← passo P/2, CONTRO il movimento
STOP LOSS :  SL  = C − d · 3P             unico, uguale su tutti e 6 i ticket
TAKE PROFIT: TP  = C + d · P              unico, uguale su tutti e 6 i ticket

P = 40 pip (EURUSD) · 70 pip (GBPUSD) · 20 pip (EURGBP)      [T] lez. 29
VOLUMI    :  vol_k = base · 1,5^k                             [I] verificato su 6 valori
```

**Verifica su tre esempi indipendenti, tre cross, tre parametri:**

| esempio | cross | `C` | previsti | confermati dal parlato |
|---|---|---|---|---|
| lez. 28+30 | GBPUSD, P=70, BUY | 1,2502 | 6 livelli + SL + TP | **8 / 8** ✅ |
| lez. 28+30 | EURGBP, P=20, SELL | 0,8598 | 6 livelli + SL + TP | **8 / 8** ✅ |
| lez. 31 | EURUSD, P=40, SELL | 1,0823 | 3 livelli + SL + TP | **5 / 5** ✅ |
| | | | **TOTALE** | **21 / 21, zero scarto** |

**E chiude anche l'aritmetica del rischio:** la ricostruzione riproduce **tre**
percentuali dichiarate dal corso — rischio riga 1 = **0,21%**, riga 2 =
**0,26%**, profitto totale = **4,06%** — con errore **sotto l'1%** (SPEC §7.3).

> ⚖️ **Perche' conta:** non e' una ricostruzione "plausibile", e'
> **aritmeticamente vincolata**. Un EA fedele si puo' scrivere **oggi**, senza
> chiedere niente a nessuno — tranne i due parametri del SuperTrend.

## 1.3 🔬 LA CLASSIFICAZIONE — il pezzo che il mandato chiedeva

Le cinque domande del mandato, con la risposta secca:

| # | domanda | risposta |
|---|---|---|
| **1** | **Quante mediazioni massime? C'e' un CAP?** | ✅ **SI, e ferreo: 6 ingressi, mai di piu'.** `[T]` lez. 28 (_"tutti i 6 livelli di entrata"_), lez. 29 (_"Le nostre posizioni vengono divise in sei ingressi diversi"_), lez. 33 (_"il foglio ci restituira' sei livelli di entrata"_). **Tre lezioni, stesso numero.** La griglia non e' aperta: e' un pettine finito. |
| **2** | **Stop totale sul pacchetto, o "sperato"?** | ✅ **STOP TOTALE VERO, E DEPOSITATO AL BROKER.** Un unico prezzo di SL, **scritto su ogni singolo ticket** al momento dell'inserimento. `[T]` lez. 30, ripetuto sei volte di fila: _"stop loss rimane sempre identico per tutte le posizioni, 1,2292"_. `[T]` lez. 31: _"per qualsiasi evenienza avete sempre ... i vostri livelli di stop loss inseriti comunque in macchina"_. **Non e' uno stop mentale. E' il muro contro cui la serie finisce.** |
| **3** | **Size costante, crescente o decrescente?** | 🔴 **CRESCENTE, geometrica ×1,5.** `0,04 / 0,06 / 0,09 / 0,14 / 0,20 / 0,30` — sei valori dettati, sei che coincidono con `0,04 × 1,5^k` arrotondato. **Il volume totale e' 20,78 volte il primo livello. La posizione PIU' GRANDE e' quella PIU' VICINA allo stop.** |
| **4** | **Il rischio: per ingresso, per pacchetto, di portafoglio?** | 🟡 **PER PACCHETTO, e stavolta il corso e' chiaro** — al contrario del Breakout, dove parlato e slide divergevano. `[T]` lez. 29: _"la percentuale di rischio **complessiva di tutta l'operazione**"_ = 1,76%, con la ripartizione riga per riga (0,21%, 0,26%, ...). **Ma NON esiste nessun cap di portafoglio** `[BUCO]`: nell'esempio stesso girano **due pacchetti insieme** (GBPUSD 1,76% + EURGBP 1,00% = **2,76% simultaneo**) e il tema non viene sfiorato. |
| **5** | **Perdita massima di UN ciclo completo?** | 📐 **Vedi §1.4 — e' il cuore del referto.** |

### 🏷️ L'ETICHETTA, per iscritto

> 🔴 **GRIGLIA DI AVERAGING CONTRO-MOVIMENTO, A CAP FISSO 6, PROGRESSIONE
> GEOMETRICA ×1,5, CON STOP TOTALE HARD SUL PACCHETTO.**
>
> **NON e'** una martingala illimitata (c'e' il cap, c'e' lo stop al broker,
> c'e' la perdita massima scritta prima di entrare).
> **NON e'** uno scaling-in neutro (la size cresce del 50% a ogni passo verso
> lo stop).
> **NON e'** recovery (non insegue le perdite di operazioni precedenti: ogni
> pacchetto e' chiuso in se').
>
> ⚖️ **E l'autodefinizione della fonte va agli atti cosi' com'e'** `[T]` lez. 31:
> _"il fatto di aver inserito diversi ordini su diversi livelli attraverso
> questo sistema con un **rischio variabile, propriamente appunto un sistema di
> Martingala**, ci permettera' di chiudere la posizione non necessariamente in
> stop loss"_. **Non e' un'accusa nostra. E' la sua parola.**

## 1.4 🧮 LA PERDITA MASSIMA DI UN CICLO — l'aritmetica che il mandato chiedeva

**Risposta secca, ai numeri del corso (GBPUSD, `P=70`, esempio della lez. 29):**

> 🎯 **La perdita massima di un ciclo completo E' ESATTAMENTE il "rischio
> complessivo" dichiarato: −1,76%.** Perche' tutti e sei i ticket condividono lo
> stesso SL: se lo stop viene toccato, si perde tutto e tutto insieme.
> **Il numero e' definito in anticipo, ed e' onesto.** Su questo la strategia
> **passa** il test che affossa il 90% delle griglie.

**Ma la forma del pagamento e' quella della griglia, e il corso non la mostra
mai.** Aritmetica nostra `[I]`, coi suoi numeri:

| livelli riempiti, poi TP | profitto | quota del massimo |
|---|---|---|
| 1 | **+0,07%** | 2% |
| 2 | **+0,23%** | 6% |
| 3 | **+0,54%** | 13% ← *e' il caso reale del 22 febbraio (lez. 31)* |
| 4 | **+1,15%** | 29% |
| 5 | **+2,20%** | 55% |
| **6** | **+4,03%** | 100% |
| **6, poi SL** | **−1,76%** | **la perdita piena** |

> 🔴 **TRE FATTI CHE IL CORSO NON DICE:**
> 1. **Il 72% del profitto sta negli ultimi DUE livelli.** Con 3 su 6 riempiti
>    si porta a casa **+0,54%**: meno di **un terzo** del rischio corso.
> 2. **Il guadagno grande e la perdita piena vivono sullo STESSO ramo.** Per
>    incassare +4,03% il prezzo deve scendere **175 pip** (riempire tutto) e poi
>    risalire **245 pip**. Ma da li' lo stop dista **35 pip**. **Si guadagna il
>    massimo solo quando si e' a 35 pip dal disastro.**
> 3. **Il ramo perdente e' piu' corto:** −210 pip in una direzione, contro un
>    andata-e-ritorno di 420 pip per il ramo vincente.
>
> 🧨 **IL WIN RATE NECESSARIO — il numero che decide se la strategia esiste:**
> - se la vincita tipica e' quella a 3 livelli (**+0,54%**) → serve il **76,5%**
> - se e' quella a 4 livelli (**+1,15%**) → serve il **60,5%**
> - solo nel caso irrealistico "sempre tutti e 6 riempiti" (+4,03%) basta il
>   **30,4%**
>
> **Il corso NON dichiara MAI il win rate.** `[BUCO]` In una lezione che si
> chiama _"backtest della strategia"_. **Questa e' l'assenza piu' pesante di
> tutto il modulo**: senza quel numero, il "+30%" non e' verificabile nemmeno in
> linea di principio.

### 🔴 E il caso peggiore vero e' peggiore di −1,76%

| # | aggravante | quanto pesa |
|---|---|---|
| A | **Pacchetti simultanei senza cap.** L'esempio del corso ne mostra **due** | 1,76% + 1,00% = **2,76%** in una sola sessione |
| B | **Le tre coppie sono un TRIANGOLO CHIUSO** (`EURGBP = EURUSD/GBPUSD`). Non sono 3 scommesse: sono **2 gradi di liberta'**, e il corso le vende come _"diversificazione"_ | tre pacchetti aperti = **un'unica scommessa su EUR/GBP/USD** |
| C | **Riapertura ammessa dopo il TP** (cap 1) → un ciclo puo' diventare **due** | esposizione sequenziale ×2 |
| D | **Gap oltre lo SL**: 0,83 lotti chiusi tutti allo stesso prezzo. Su GBPUSD un gap di 30 pip oltre lo stop = **+0,62%** su un conto da 40k | coda a sinistra |
| E | 🔴 **Il rischio potrebbe essere 2,29× il dichiarato** (§1.5) | 1,76% → **4,03%** |

## 1.5 🚨 IL SOSPETTO PIU' SERIO: il rischio mostrato non si allaccia al capitale

Questo e' l'unico anello che il solo audio **non chiude**, ed e' anche quello che
**punta nella direzione sbagliata**.

- Dal **rischio dichiarato** (1,76% ↔ 707 USD di perdita a SL): **conto ≈ 40.000**
- Dal **seme del volume** (0,01 lotti × 70 pip = 7 USD = 0,04%): **conto ≈ 17.500**
- **Rapporto: 2,29** — e **lo stesso fattore (2,26) ricompare identico
  nell'esempio EURGBP**, dove il pacchetto ricostruito rischia **2,26%** contro
  l'**1%** dichiarato. `[I]` (SPEC §7.4)

> ⚖️ **Cosa NON e' compromesso:** la geometria e le **proporzioni** fra i livelli
> — quelle dipendono solo dai rapporti fra i volumi e chiudono al decimale.
> **Cosa E' compromesso:** l'ancoraggio al capitale, cioe' **il numero che
> l'utente legge nella cella rossa**.
>
> 🚨 **Se la ricostruzione e' giusta, il foglio mostra all'utente un rischio 2,29
> volte piu' piccolo di quello vero.** 1,76% dichiarati = **4,03% reali**. Su un
> conto prop con daily loss al 5%, la differenza fra i due numeri **e' la
> differenza fra un pacchetto e un conto bruciato.**
>
> **Non lo sto affermando: lo sto isolando.** Solo il file Excel lo scioglie →
> **domanda n.2 per Claudio.**

## 1.6 💣 IL RISCHIO 1% NON E' IMPLEMENTABILE SU 5.000 € — e il corso lo simula su 5.000 €

Aritmetica nostra `[I]`, con i parametri del corso e il pavimento del micro-lotto
(0,01, che e' il minimo negoziabile e **non si puo' scendere**):

Serie minima possibile (`0,01 × 1,5^k` arrotondata):
`0,01 / 0,02 / 0,02 / 0,03 / 0,05 / 0,08` lotti

| cross | `P` | perdita del pacchetto minimo | **su un conto da 5.000 €** |
|---|---|---|---|
| **EURGBP** | 20 | ≈ 59 € | **1,19%** |
| **EURUSD** | 40 | ≈ 94 € | **1,87%** |
| **GBPUSD** | 70 | ≈ 164 € | 🔴 **3,28%** |
| **tutti e tre insieme** | | ≈ 317 € | 🔴 **6,34%** |

> 🔴 **Su GBPUSD il pacchetto piu' piccolo che esiste rischia il 3,28%. Per
> arrivare all'1% servirebbe un livello 1 da 0,003 lotti: SOTTO IL MICRO-LOTTO.
> Non e' difficile: e' IMPOSSIBILE.**
>
> 📐 **Il capitale minimo perche' la regola "rischio 1%" sia implementabile su
> tutti e tre i cross e' ≈ 16.200 €** (`[I]` nostro calcolo) — **e guarda caso
> e' quasi esattamente il conto implicito nel seme del corso (~17.500)**. La
> procedura di Manuela Negro **e' calibrata su un conto da ~17.000, non da
> 5.000**.
>
> 🧨 **Ma la lez. 32 dichiara la simulazione su un conto da 5.000 € a rischio
> 1%.** Con la sua stessa procedura, **quella simulazione non e' eseguibile**.
> Non e' pignoleria: e' un'incoerenza fra il materiale operativo (lez. 29-30) e
> il materiale di vendita (lez. 32).
>
> ✅ **Nota a favore, e importante per noi:** su un conto **prop da 100k il
> problema sparisce** — il pacchetto all'1% ha base 0,057 lotti e tutti e sei i
> livelli stanno larghi sopra il micro-lotto. **E' un problema di conto piccolo,
> non un difetto della strategia.**

## 1.7 ⚖️ IL CONFRONTO COL SETACCIO DI CASA — riga per riga

| criterio del setaccio | esito | dettaglio |
|---|---|---|
| 🔴 **Griglia / averaging / martingala** | ❌ **PRESENTE, e ammessa a voce dalla fonte** | `[T]` lez. 31: _"propriamente appunto un sistema di Martingala"_. **E' la bandiera n.1 del §4, e c'e'.** |
| 🔴 **Assenza di stop loss** | ✅ **SUPERATO, e bene** | SL **hard, unico, depositato al broker su ogni ticket**. Sta dalla parte giusta del **44% di EA del Code Base che lo stop non lo nominano nemmeno** |
| 🔴 **Add-on illimitati** | ✅ **SUPERATO** | cap **6**, dichiarato in 3 lezioni |
| 🔴 **Perdita massima non calcolabile** | ✅ **SUPERATO** | calcolabile **prima** di entrare, e il corso la calcola (1,76%) |
| 🔴 **Lotto fisso / non scalabile** | ✅ **SUPERATO** | sizing a rischio-% |
| 🔴 **Hedging** | ✅ **assente** | mai posizioni opposte |
| 🔴 **Dipendenza esterna** | 🟡 **c'era: il foglio Excel** — 🏆 **ORA DISSOLTA**, ricostruita (§1.2). Resta `iCustom` SuperTrend, che gia' abbiamo | |
| 🔴 **Numeri di performance senza artefatto** | ❌ **PRESENTE** | zero N, zero win rate, zero date, zero broker, e la ri-scalatura **ammessa** (§1.8) |
| 🟠 **Correlazione trattata?** | ❌ **NO** | triangolo chiuso venduto come diversificazione |
| 🟠 **Filtro news / orari** | ❌ **assenti**, e stavolta **nemmeno negati** | nel Breakout l'assenza era dichiarata; qui e' un buco |

> 🧭 **VERDETTO DI SETACCIO:** la mediazione **inciampa nella bandiera n.1** (la
> griglia c'e', ed e' geometrica), **ma supera tutte le sotto-bandiere che
> normalmente rendono una griglia letale**: stop vero, cap, perdita massima
> nota. **E' il caso raro in cui la bandiera va letta, non applicata a vista.**
> Ed e' un caso **diverso** da `Mean_Reversion` (AHARON TZADIK), scartato il
> 16/08 con `LotExponent 1.44` e `Max_Trades 10`: **li' lo scarto era immediato
> perche' la martingala si riarmava sulle PERDITE PRECEDENTI**. Qui ogni
> pacchetto e' chiuso in se' e muore contro un muro.

## 1.8 🔁 QUELLO CHE QUESTO MODULO REGALA AL MODULO BREAKOUT

Tre nodi aperti della `BREAKOUT_CORSO_SPEC.md` si chiudono **da qui**:

| nodo del Breakout | prima | **ora** |
|---|---|---|
| **Williams: 140 o 14?** | 🔴 _"UNA occorrenza in 54.787 caratteri, zero convergenza interna"_ | ✅ **CHIUSO: 140.** Compare **altre TRE volte** in questo modulo (lez. 26 ×2, 27, 33), **PDF riepilogativo incluso**, con tanto di motivazione: _"Questo setup non e' casuale, e' stato studiato"_. **Il sospetto "storpiatura di 14" e' morto.** |
| **Dove stanno i parametri del SuperTrend?** | 🔴 _"un modulo precedente non trascritto"_ | 🟡 **LOCALIZZATI.** `[T]` lez. 26: _"il setup che voi avete gia' sicuramente costruito **insieme a Leonardo** in precedenza"_. Catena: **Breakout (34-40) → Mediazione (26-33) → modulo di LEONARDO (< 26)**. Non e' piu' "un modulo": **ha un nome e una collocazione.** |
| **Gli scenari 1%/3% sono una ri-scalatura?** | `[I]` **dedotto per aritmetica** (`4×3=12≈11`, `7×3=21≈20`) | ✅ **CONFERMATO DALLA FONTE.** `[T]` lez. 32, la relatrice **descrive il metodo**: _"potete andare a simulare un eventuale rischio differente, quindi **moltiplicando per 2 o per 3 quelli che sono i profitti e le perdite maturate** in questo vostro primo storico"_. E infatti `30×3=90` ✅ e `4×3=12` ✅, **esatti**. → **L'inferenza del referto Breakout si promuove a citazione.** |

➕ **Bonus:** le soglie Williams **−20 / −80 / −50**, che nel Breakout erano
**pura inferenza**, qui sono confermate da **valori letti ad alta voce**
(−78,46 · −22,93 · −49). SPEC §3.3.

➕ **Coerenza incrociata:** il Breakout (lez. 39) diceva che la mediazione faceva
_"intorno al 27-30%"_. La mediazione (lez. 32) dice **30%**. ✅ Coerenti —
⚠️ **ma e' la stessa autrice: UNA fonte, non due.**

## 1.9 📊 TABELLA DEI VALORI CONVERGENTI

> ⚠️ **Avvertenza metodologica obbligatoria, identica al referto Breakout: qui la
> convergenza vale POCO.** Le 8 trascrizioni sono **8 lezioni della stessa
> relatrice nello stesso corso**: sono **UNA fonte, non otto**. La ripetizione
> serve solo a distinguere cio' che il corso **sostiene stabilmente** da cio' che
> ha detto **una volta sola** (e che quindi puo' essere un lapsus o un errore
> speech-to-text).
>
> 🟢 **L'unica verifica vera di questo referto non e' la ripetizione: e'
> l'ARITMETICA** — 21 livelli di prezzo e 3 percentuali di rischio che **devono**
> chiudere e che chiudono (§1.2). Quella non e' una fonte che si ripete: e' un
> vincolo che regge.

| parametro | valore | lezioni | robustezza interna |
|---|---|---|---|
| Timeframe | **H1** | 28, 31 | 🟢 stabile |
| Universo | **EURUSD · GBPUSD · EURGBP** | 26, 27, 32, 33 | 🟢 **quattro volte, coincidenti** |
| **Williams periodo** | **140** | 26 (×2), 27, 33 | 🟢 **quattro occorrenze, PDF incluso** |
| N. livelli di ingresso | **6** | 28, 29, 33 | 🟢 stabile |
| Parametro `P` | **40 / 70 / 20** | 29 | 🟠 **una lezione sola** — 🟢 **ma verificato dall'aritmetica su 3 esempi** |
| SL unico per il pacchetto | si' | 30 (×6), 33 | 🟢 martellato |
| TP unico per il pacchetto | si' | 30 (×6), 33 | 🟢 martellato |
| Ancora = chiusura candela segnale | si' | 28, 31, 33 (×2) | 🟢 **e' il cuore del metodo** |
| Banda Williams BUY | **[−80, −50]** | 28, 33 | 🟢 stabile, + valore letto (−78,46) |
| Banda Williams SELL | **[−50, −20]** | 28, 33 | 🟢 stabile, + valore letto (−22,93) |
| Mediana Williams | **−50** | 28, 31, 33 | 🟢 stabile |
| R:R minimo | **1 : 2** | 29, 33 | 🟢 stabile |
| Rischio base | **1% per pacchetto** | 30, 32, 33 | 🟢 stabile |
| Storico prima di alzare il rischio | **20 operazioni** | 33 | 🟠 una volta (= Breakout lez. 40) |
| Riapertura del segnale | **max 1 volta, solo dopo TP** | 33 | 🟠 **una volta sola**, ma e' il PDF |
| Volumi ×1,5 | — | **MAI pronunciato** | 🟢 **ricavato da 6+5 valori dettati** |
| Tetto DD | **20%** | 32 | 🔴 **contraddetto dalla 33** |
| Tetto DD | **3%** | 33 | 🔴 **contraddice la 32** |
| Filtro orario / news | — | **MAI** | 🔴 **buco, nemmeno negato** |
| SuperTrend: parametri | — | **MAI** | 🔴 **buco BLOCCANTE** |

## 1.10 ⚔️ LE CONTRADDIZIONI INTERNE

| # | contraddizione | esito |
|---|---|---|
| 1 | _"settata per **due** coppie"_ poi _"**questi tre** sono gli strumenti"_ (lez. 27) | ✅ **TRE** — autocorretta 2 righe dopo |
| 2 | _"per la **sterlina dollaro** ... 20 pip"_ dopo aver detto 70 per la stessa (lez. 29) | ✅ **lapsus: 20 e' EURGBP** — corretto dalla frase dopo + dall'aritmetica |
| 3 | _"se il Williams si trova nell'area di **ipercomprato** ... tra meno 80 e meno 50"_ in un BUY (lez. 28) | ✅ **lapsus verbale** — la banda numerica e' giusta |
| 4 | ingresso _"1,25 e 0,6"_ (lez. 29) vs `1,2502` (lez. 28) | ✅ **1,2502** — lo impone la griglia |
| 5 | take profit _"1,2575"_ una volta (lez. 30) vs `1,2572` cinque volte | ✅ **1,2572** |
| 6 | _"lavoreremo tra 0,86 e 48 e **0,85 e 96**"_ (lez. 28): 0,8596 non e' ne' livello ne' TP | 🟠 `[TRASCRITTO dubbio]`, irrilevante |
| 7 | 🔴 **tetto DD: 20% (lez. 32) vs 3% (lez. 33)** | 🔴 **APERTA** — sono due numeri, non due formulazioni |
| 8 | 🔴 **chiusura anticipata: basta il Williams in zona opposta (lez. 33) o serve il segnale completo opposto (lez. 31)?** | 🔴 **APERTA** — distano diverse candele, con 6 ticket aperti in mezzo |
| 9 | 🟠 **riapertura dopo STOP**: la 31 la ammette, la 33 dice che lo stop uccide il segnale | 🟡 **conciliabile** (nuova uscita del Williams = segnale nuovo), ma la 31 aggiunge _"a partire dai livelli piu' alti rispetto allo stop"_, geometria **mai specificata** → `[BUCO]` |
| 10 | 🔴 **il seme del volume non si allaccia ai volumi dettati (fattore 2,29)** | 🔴 **APERTA — la piu' pericolosa** (§1.5) |

## 1.11 🏛️ ATTRITI CON LE REGOLE PROP

> ⚠️ **Il corso non nomina MAI una prop firm, in nessuna delle 8 lezioni.**
> Zero regole prop citate. Tutto quello che segue e' **nostro**, dal confronto
> con `report/METRO_PROP.md`.

1. 🔴 **GRIGLIA/MARTINGALA E TERMINI DELLE PROP — e qui abbiamo un buco NOSTRO.**
   Molte prop vietano o limitano esplicitamente griglia e martingala nei termini
   d'uso. **`report/METRO_PROP.md` non contiene una sola riga su griglia,
   martingala o averaging** (verificato con ricerca sul file: **zero
   occorrenze**). → **E' una lacuna del nostro metro, non del corso**, e va
   colmata prima di valutare questa strategia per un conto prop.
   **→ voce nuova per `DOMANDE_SUPPORTO_PROP.md`.**
2. 🔴 **Rischio simultaneo su un triangolo chiuso.** Tre pacchetti = un'unica
   scommessa su EUR/GBP/USD. Contro un daily loss del 5%, con i numeri della
   §1.6 su conto piccolo si arriva al **6,34%**: **violazione in una sola
   sessione storta.** Su 100k il problema si ridimensiona (3 × 1% = 3%), **ma
   resta un 3% che va tutto nella stessa direzione.**
3. 🟠 **Nessun cap giornaliero, nessun filtro news, nessun orario.** L'unico
   tetto e' il DD complessivo, ed e' contraddetto (20% vs 3%).
4. 🟠 **Sei ticket per segnale.** Conta per le regole prop sul numero di
   posizioni/lotti e per il calcolo dell'esposizione: un pacchetto solo su
   EURGBP a 1% e' **1,24 lotti** distribuiti su 6 ticket.
5. 🟢 **In positivo:** SL hard su ogni ticket = il Guardian e le regole di daily
   loss hanno sempre un limite superiore certo da cui partire. **Non esiste il
   caso "posizione senza stop che corre".**

## 1.12 ❓ LE DOMANDE PER CLAUDIO (in ordine di quanto sbloccano)

1. 🔴🔴 **IL MODULO DI LEONARDO** (lezioni **prima** della 26) — trascrizione o
   screenshot del pannello del **SuperTrend**. **E' l'unico buco bloccante, ed
   e' comune ai DUE moduli.** Con quello si chiude anche il Breakout.
   `[T]` lez. 26: _"il setup che voi avete gia' sicuramente costruito insieme a
   **Leonardo** in precedenza"_.
2. 🔴 **IL FILE EXCEL della mediazione** — nello specifico: **la colonna dei
   volumi, la cella rossa del rischio complessivo, e la formula che le lega.**
   ⚠️ **Non serve piu' per i livelli** (ricostruiti, §1.2): serve **solo** per
   sciogliere il fattore **2,29** (§1.5), che e' la differenza fra rischiare
   1,76% e rischiare 4,03%. `[T]` lez. 27: _"Dovreste avere nella vostra area
   personale questo file"_.
3. 🔴 **Screenshot del foglio di calcolo della lez. 32** (il minuto in cui mostra
   la curva e la lista): servono **N operazioni, win rate, date, broker**.
   **Il win rate e' il numero che decide se la strategia esiste** (§1.4).
4. 🟠 **Le slide del PDF della lez. 33** — nel Breakout le slide hanno chiuso 6
   ambiguita' su 10. Qui servirebbero per il **tetto DD (20% o 3%?)** e per la
   **regola di chiusura anticipata** (ambiguita' 7 e 8).
5. 🟡 **L'anno degli esempi** (4 e 17 aprile, 22 e 28 febbraio) — senza, non si
   riverificano sui nostri dati storici.
6. 🟡 **Conferma sul video che i volumi della lez. 30 (0,04 … 0,30) sono lotti e
   non percentuali di rischio** — e' la lettura che regge l'aritmetica, ma la
   relatrice li chiama _"rischio iniziale"_ mentre li legge.

## 1.13 🧭 IL VERDETTO — puo' andare all'imbuto? A quali condizioni?

> ✅ **SI, PUO' ANDARE ALL'IMBUTO — e per una volta il motivo e' tecnico, non
> di fiducia: e' la prima strategia di questo corso che possiamo implementare
> AL 100% NELLA SUA MATEMATICA senza chiedere niente a nessuno.** La geometria
> e' chiusa, verificata su 21 valori, e ha gia' i test-case di regressione
> pronti (SPEC §10.3).

**Ma con SEI condizioni, tutte non negoziabili.**

| # | condizione | perche' |
|---|---|---|
| **1** | 🔴 **Prima si scioglie il fattore 2,29** (§1.5) — o col file Excel, o dichiarando che il sizing e' **NOSTRO** e ignorando il seme del corso | e' la differenza fra 1,76% e 4,03% di perdita per pacchetto |
| **2** | 🔴 **I parametri SuperTrend si dichiarano come ASSUNZIONE NOSTRA** (ATR 10 / mult 3,0, coerenza con la decisione di Claudio sul Breakout del 18/08) | il corso non li ha mai detti: qualunque valore e' nostro, **e va scritto nel referto, non nascosto** |
| **3** | 🔴🔴 **L'UNITA' DI CONTO E' IL PACCHETTO, NON IL TICKET** | ⚠️ **QUESTO E' L'ERRORE METODOLOGICO PIU' FACILE DA COMMETTERE.** Un pacchetto genera **fino a 6 ticket**: un report MT5 leggerebbe **600 "operazioni"** dove ce ne sono **100**. **L'emendamento della finestra (>=150 operazioni) conta PACCHETTI.** Contare ticket gonfierebbe il campione di **6 volte** e renderebbe il giudizio una bugia aritmetica |
| **4** | 🔴 **Le 3 coppie NON sono 3 conferme indipendenti** — sono un triangolo chiuso | vale la stessa regola dei 7 cross JPY del Breakout: _"un'unica scommessa"_. **La prova di regime va fatta per cross, ma il giudizio di portafoglio su UNA scommessa** |
| **5** | 🟠 **Il setaccio deve leggere la CODA, non solo PF e max DD** | il payoff e' "tante briciole + rara perdita piena" (§1.4): un PF di 1,1 su 200 pacchetti puo' nascondere 3 stop pieni che valgono l'anno. **Servono: distribuzione dei livelli riempiti, win rate, perdita massima consecutiva** |
| **6** | 🟠 **Prima di tutto: MISURARE LA FREQUENZA** | `[BUCO]` totale — il corso non dice mai quanti segnali fa. Su H1 con Williams 140 (= **140 ore ≈ 6 giorni** di look-back) i segnali possono essere pochissimi. **Se non si arriva a 150 pacchetti in IS, il giudizio di MERITO e' sospeso** (regola di casa) — e la misura di frequenza si fa **prima** di lanciare la griglia di ottimizzazione, non dopo |

### 🚧 E i due limiti che restano comunque in piedi

1. **Il corso vende come diversificazione un triangolo di cambio.** Non lo e', e
   nessuna misura nostra puo' cambiarlo.
2. **I "profitti ottimi" del mandato NON esistono ancora come dato.** Il corso
   dichiara **+30%** su **un solo cross**, in **due anni non datati**, senza N,
   senza win rate, con lo scenario a 3% ottenuto **moltiplicando a mano per 3**
   (ammesso dalla relatrice). **Se questa strategia dara' profitti ottimi lo
   dira' il nostro tester. Oggi non lo sa nessuno.**

---

# PARTE 2 — 📇 LE SCHEDE, LEZIONE PER LEZIONE

---

## 📄 SCHEDA 1 — `26. STRATEGIA DI MEDIAZIONE.txt`

| campo | contenuto |
|---|---|
| **FILE** | `26. STRATEGIA DI MEDIAZIONE.txt` (4.029 caratteri) |
| **RELATORE** | Manuela Negro `[I]` (confermata testualmente solo in lez. 33) |
| **OGGETTO** | Introduzione + primo setup indicatori. **Corta ma con DUE parametri pesanti.** |

**PARAMETRI CON VALORE:**

| parametro | valore | citazione | etichetta |
|---|---|---|---|
| Universo | **EURUSD, GBPUSD, EURGBP** | _"le coppie euro-dollaro, sterlina-dollaro ed euro-sterlina rispondono in modo particolare a questo approccio"_ | 🟢 TRASCRITTO chiaro |
| Indicatori | SuperTrend + Williams | _"sono il super trend e il Williams"_ | 🟢 chiaro |
| **Williams periodo** | **140** | _"ricorda che **deve essere settato a 140 periodi**. Questo setup non e' casuale, e' stato studiato"_ + _"Supertrend e Williams a **140 periodi**"_ | 🟢 **chiaro, DUE volte nella stessa lezione** |
| SuperTrend: parametri | — | **mai pronunciati** | 🔴 **BUCO** |

**MECCANISMI:**
- Tesi di fondo: le valute lateralizzano prima di invertire — _"queste fasi ...
  di accumulazione e di distribuzione"_ `[T]`. Accumulazione → BUY,
  distribuzione → SELL.
- **Il Williams serve a identificare la fase**, non il timing: _"avendo queste
  aree ... di ipercomprato e di per venduto mi permette proprio di identificare
  quelle ... fasi di accumulazione e di distribuzione"_ `[T]`.
- **La strategia si vende come antidoto agli stop:** _"e' proprio qui che la
  maggior parte degli operatori registrano numerosi stop loss"_ `[T]`.

**🔑 IL REPERTO CHE VALE PIU' DI TUTTI IN QUESTA LEZIONE:**
> `[T]` _"Ecco il setup che voi avete gia' sicuramente costruito **insieme a
> Leonardo** in precedenza"_

→ **Il modulo che contiene i parametri del SuperTrend ha un nome: e' quello di
Leonardo, prima della lezione 26.** Chiude a meta' il buco bloccante di
**entrambi** i moduli. **→ Domanda n.1 per Claudio.**

**REGOLE PROP CITATE:** nessuna.

**NUMERI DI PERFORMANCE:** nessuno. Solo `[T]` _"dando dei risultati veramente
sorprendenti"_ — **affermazione senza numero, in apertura.** 🟠

**BANDIERE ROSSE:**
- 🟠 **Selezione dell'universo affermata, mai misurata:** _"ho studiato che alcuni
  strumenti ... rispondono in modo particolare"_. **Nessun confronto fra coppie
  viene mostrato.** Stesso identico difetto del Breakout lez. 35 con le coppie
  JPY.
- 🟠 **Il "140 non e' casuale, e' stato studiato"** — si asserisce lo studio, non
  si mostra.
- 🟢 Nessuna bandiera di rischio in questa lezione: la parola "mediazione" non
  viene ancora spiegata operativamente.

**A SCHERMO E NON NEL PARLATO:** 🖼️
1. 🔴 **Il pannello parametri del SuperTrend** — l'indicatore c'e' sul grafico,
   i settaggi non vengono mai letti. **Buco bloccante.**
2. Il grafico d'esempio (cross e date non dichiarati).
3. Le soglie grafiche dell'ipercomprato/ipervenduto sul Williams.

**COSA NE COPIAMO:** ✅ **Universo (3 cross), Williams 140, i due indicatori.**
✅ **E la pista "Leonardo".**

---

## 📄 SCHEDA 2 — `27. MEDIAZIONE SETUP OPERATIVO.txt`

| campo | contenuto |
|---|---|
| **FILE** | `27. MEDIAZIONE SETUP OPERATIVO.txt` (4.449 caratteri) |
| **OGGETTO** | Preparazione della piattaforma. **Lezione quasi tutta organizzativa** — ma ci sono 3 informazioni che pesano. |

**PARAMETRI CON VALORE:**

| parametro | valore | citazione | etichetta |
|---|---|---|---|
| Indicatori | solo 2 | _"A noi servira' **soltanto** il Supertrend e il Williams Percent Range a 140 periodi"_ | 🟢 chiaro |
| **Williams periodo** | **140** | idem | 🟢 **terza occorrenza del modulo** |
| Universo | 3 cross | _"**Questi tre** sono gli strumenti che a noi servono"_ | 🟢 chiaro |
| Piattaforma | MT4 | profili/formati MT4 | 🟢 chiaro |

**MECCANISMI:**
- Profilo MT4 salvato come `mediazione`, template `Williams e Supertrend`
  `[T]` — organizzativo. ⚠️ **Ma e' lo stesso template che il modulo Breakout
  (lez. 35) dara' per gia' esistente**: conferma la catena fra i moduli `[I]`.
- 🔴 **I DUE STRUMENTI ESTERNI, dichiarati qui per la prima volta:**
  1. `[T]` _"utilizzeremo il **foglio Excel** ... Dovreste avere nella vostra
     area personale questo file che e' stato costruito per ... tutte e tre le
     coppie valutarie"_ → **la strategia dipende da un file che non abbiamo.**
     🏆 **Dipendenza poi DISSOLTA per la parte livelli** (§1.2).
  2. `[T]` _"abbiamo ancora bisogno di accedere al sito di **Cashbackforex** ...
     per il calcolo del volume"_ → dipendenza da un sito web per il sizing.

**⚠️ CONTRADDIZIONE MINORE:**
> `[T]` _"la strategia e' stata settata per **due coppie** in particolare"_ →
> poi, tre righe dopo, _"**Questi tre** sono gli strumenti"_.
✅ **Risolta: TRE** (autocorrezione immediata + lez. 26, 32, 33).

**REGOLE PROP CITATE:** nessuna.
**NUMERI DI PERFORMANCE:** nessuno.

**BANDIERE ROSSE:**
- 🔴 **La strategia NON e' autosufficiente:** dipende da (a) un Excel
  proprietario, (b) un sito esterno, (c) un setup di indicatori fatto in un
  altro modulo. **Tre dipendenze in una lezione di preparazione.**
- 🟢 Nulla di rischioso in senso stretto.

**A SCHERMO E NON NEL PARLATO:** 🖼️
1. 🔴 **Il pannello del SuperTrend** (di nuovo mostrato, di nuovo non letto).
2. 🔴 **Il foglio Excel**: viene nominato, non aperto.
3. Il tema grafico (irrilevante).

**COSA NE COPIAMO:** ✅ Conferma dell'universo e del Williams 140.
🚫 Niente di operativo: e' una lezione di allestimento.

---

## 📄 SCHEDA 3 — `28. MEDIAZIONE SEGNALE, LIVELLI DI INGRESSO, STOP E TARGET, ESEMPIO 1.txt`

| campo | contenuto |
|---|---|
| **FILE** | `28. MEDIAZIONE SEGNALE ,LIVELLI DI INGRESSO,STOP E TARGET, ESEMPIO 1.txt` (12.503 car., **il piu' lungo**) |
| **OGGETTO** | **LA LEZIONE FONDATIVA.** Segnale, banda, ancora, e — soprattutto — **i numeri che hanno permesso di ricostruire la griglia.** |

**PARAMETRI CON VALORE — la miniera:**

| voce | valore | citazione | etichetta |
|---|---|---|---|
| **Timeframe** | **H1** | _"dobbiamo controllare il grafico sul time frame H1. La strategia e' stata proprio settata per questo time frame"_ | 🟢 chiaro |
| Soglia ipervenduto | **−80** | _"deve aver proprio superato la linea del meno 80"_ | 🟢 chiaro |
| Williams al segnale BUY | **−78,46** | _"in questo caso si trova a meno 78,46"_ | 🟢 **valore letto: conferma la soglia** |
| Invalidatore | **oltre −50 = tardi** | _"non abbia superato la prima meta', cioe' non sia oltre il livello di meno 50 ... sarebbe troppo tardi per noi entrare"_ | 🟢 chiaro |
| Banda BUY | **[−80, −50]** | _"nella sua prima meta' tra meno 80 e meno 50"_ | 🟢 chiaro (⚠️ con lapsus "ipercomprato") |
| Williams al segnale SELL | **−22,93** | _"l'indicatore si posiziona a meno 22,93 ... uscito dal livello di meno 20"_ | 🟢 **valore letto: conferma la soglia −20** |
| **Chiusura segnale GBPUSD** | **1,2502** | _"prendiamo il livello ... che ci da' di close 1,25 e 0,2"_ | 🟢 chiaro |
| **SL GBPUSD** | **1,2292** | _"lo stop loss ... e' 1,22 e 0,92"_ | 🟢 chiaro |
| **TP GBPUSD** | **1,2572** | _"il nostro take profit ... e' 1,25 e 0,72"_ | 🟢 chiaro |
| **N. livelli** | **6** | _"riportate, mi raccomando, **tutti i 6 livelli** di entrata"_ | 🟢 chiaro |
| **I 6 livelli GBPUSD** | 1,2502 / **1,2467** / **1,2432** / **1,2397** / **1,2362** / **1,2327** | dettati uno per uno | 🟢 **tutti e sei** |
| **Chiusura segnale EURGBP** | **0,8598** | _"in questo caso e' 0,8598"_ | 🟢 chiaro |
| **SL / TP EURGBP** | **0,8658 / 0,8578** | dettati | 🟢 chiari |
| Ultimo livello EURGBP | **0,8648** | _"l'ultimo livello 0,86 e 48"_ | 🟢 chiaro |
| Prezzo corrente d'esempio | 1,2476 | — | 🟡 contesto |

> 🏆 **Con questi 16 numeri + i 3 parametri della lez. 29 la griglia si chiude.
> Questa e' la lezione che ha aperto la scatola nera.**

**MECCANISMI:**
1. **La sequenza del segnale** `[T]`: Williams in zona → **poi** rottura del
   SuperTrend in senso contrario → **verifica sulla candela di chiusura** che il
   Williams sia uscito.
2. **R-ATTESA** `[T]`: _"Controllo che su questa candela di chiusura il Williams
   sia uscito dall'area di ipervenduto, **altrimenti attendo la candela
   successiva**"_ → non si scarta, si aspetta. **Meccanizzabile.**
3. **L'ancora unica** `[T]`: _"abbiamo bisogno soltanto di un valore che e' la
   chiusura della candela del segnale ... **Tutto il resto sara' calcolato
   direttamente dal foglio**"_.
4. 🔴 **LA GRIGLIA, dichiarata con la parola giusta** `[T]`: _"La strategia
   permette di costruire una **griglia** di ordini all'interno di questo canale.
   Gli ordini vengono valutati con uno **specifico salto** che e' collegato alla
   tipologia del cross"_ — ✅ **il "salto" e' `P/2`** (SPEC §5.2).
5. **Ordini limit o stop** a seconda di dove sta il prezzo quando arrivi `[T]`.
6. **Validita' del segnale** `[T]`: si puo' entrare _"tutto il tempo che
   vogliamo fino a quando ... il mercato oscillera' all'interno di questo
   canale"_; muore solo sullo stop.

**REGOLE PROP CITATE:** nessuna.
**NUMERI DI PERFORMANCE:** nessuno.

**BANDIERE ROSSE:**
- 🔴 **QUI SI VEDE LA MEDIAZIONE PER LA PRIMA VOLTA, ed e' averaging puro**
  `[T]`: _"fase laterale all'interno della quale andremo ad **accumulare delle
  nuove posizioni di acquisto**"_ su livelli **sotto** l'ingresso, in un BUY.
- 🟠 **Il "salto" e' presentato come esoterico e non spiegato:** _"collegato alla
  tipologia del cross ... **questo per i piu' curiosi** naturalmente"_.
  **Il metodo con cui e' stato scelto non viene mai mostrato.** (Noi lo abbiamo
  ricavato: e' `P/2`. Resta ignoto **come** `P` sia stato scelto.)
- 🟠 **_"Questa e' una strategia abbastanza lenta"_** — e' un pregio dichiarato,
  ma implica **posizioni tenute per giorni**: overnight e weekend, mai discussi.
- 🟢 **Contro-bandiere forti:** SL e TP esistono, sono numerici, si tracciano
  sul grafico PRIMA di entrare, e sono **unici per tutto il pacchetto**.

**A SCHERMO E NON NEL PARLATO:** 🖼️
1. 🔴 **Il foglio Excel aperto** — si vedono le celle, si leggono solo alcuni
   valori. **I VOLUMI non vengono letti in questa lezione.**
2. 🔴 **Il pannello SuperTrend** (ancora).
3. 🟠 **Data e anno dell'esempio GBPUSD** — mai pronunciati.
4. 🟠 I livelli intermedi dell'EURGBP (ne detta 2 su 6; gli altri 4 arrivano
   nella lez. 30).

**COSA NE COPIAMO:** ✅ **TUTTO.** Sequenza del segnale, R-ATTESA, invalidatore
−50, bande, ancora sulla chiusura, e **i 16 numeri che verificano la griglia**
(→ test-case A e B, SPEC §10.3).

---

## 📄 SCHEDA 4 — `29. MEDIAZIONE GESTIONE DEL RISCHIO E SIZE DI INGRESSO.txt`

| campo | contenuto |
|---|---|
| **FILE** | `29. MEDIAZIONE GESTIONE DEL RISCHIO E SIZE DI INGRESSO.txt` (7.847 car.) |
| **OGGETTO** | **La lezione decisiva per la classificazione.** I 3 parametri `P`, la logica del peso crescente, e le percentuali di rischio. |

**PARAMETRI CON VALORE:**

| voce | valore | citazione | etichetta |
|---|---|---|---|
| **`P` GBPUSD** | **70 pip** | _"utilizzeremo un parametro di stop loss pari a 70 pip"_ | 🟢 chiaro |
| **`P` EURUSD** | **40 pip** | _"Per l'euro-dollaro utilizzeremo un parametro di 40 pip"_ | 🟢 chiaro |
| **`P` EURGBP** | **20 pip** | _"se stiamo tradando l'euro-sterlina questo parametro ammontera' a 20"_ | 🟢 chiaro (⚠️ vedi lapsus) |
| N. ingressi | **6** | _"Le nostre posizioni vengono divise in **sei ingressi** diversi"_ | 🟢 chiaro |
| Seme di rischio GBPUSD | **0,04%** ↔ 0,01 lotti | _"con uno stop loss di 70 pips ... noi possiamo rischiare lo 0.04 ... per inserire una posizione pari a un micro lotto, 0.01"_ | 🟢 chiaro — 🔴 **e non si allaccia** (§1.5) |
| **Rischio complessivo** | **1,76%** | _"noi rischieremo **complessivamente l'1,76%** del nostro conto"_ | 🟢 chiaro |
| Rischio livello 1 | **0,21%** | _"Il primo livello di ingresso rischiera' 0,21%"_ | 🟢 chiaro — ✅ **riprodotto dalla ricostruzione** |
| Rischio livello 2 | **0,26%** | _"il secondo 0,26% e cosi' via"_ | 🟢 chiaro — ✅ **riprodotto** |
| **Profitto possibile** | **4,06%** | _"un rischio previsto dell'1,76% e un possibile profitto del 4,06%"_ | 🟢 chiaro — ✅ **riprodotto (4,026%)** |
| R:R minimo consigliato | **1 : 2** | _"le operazioni che vi consiglio di eseguire sono quelle che possono mantenere un rapporto di rischio-rendimento 1 a 2"_ | 🟢 chiaro |
| Tool di sizing | `cashbackforex.com` → _"lot size calculator"_ | trascritto _"opt-size-calculator"_ | 🟠 **TRASCRITTO storpiato**, ricostruibile |

**⚠️ LAPSUS:** _"per la **sterlina dollaro** utilizzeremo invece un parametro di
20 pip"_ subito dopo aver detto 70 per lo stesso cross. ✅ **Corretto due frasi
dopo** (_"euro-sterlina ... 20"_) **e dall'aritmetica** (SPEC §5.4).

**MECCANISMI:**
- 🔴 **LA LOGICA DELL'AVERAGING, dichiarata per esteso** `[T]`: _"i livelli piu'
  in basso ... sono quelli piu' vicini al livello di stop loss in termini di PIP
  e piu' lontani al livello di take profit ... Per questo **daremo un peso
  maggiore a questi ordini**"_ → **e' la giustificazione della progressione
  ×1,5.**
- **Il rischio si "fraziona"** `[T]`: _"dobbiamo frazionare il nostro rischio in
  quanto non abbiamo un'unica operazione"_.
- **Procedura di sizing in 4 passi** (SPEC §6.3), con il tentativo manuale sul
  calcolatore per trovare il micro-lotto.

**REGOLE PROP CITATE:** nessuna.

**NUMERI DI PERFORMANCE:** nessuno di storico. Le percentuali (1,76 / 4,06)
sono **proiezioni del foglio su un'operazione in corso**, non risultati.

**BANDIERE ROSSE:**
- 🔴 **La motivazione della size crescente e' rovesciata rispetto al rischio.**
  Lei dice: piu' in basso = meno spazio verso lo stop = piu' peso. **Ma
  aritmeticamente la size cresce PIU' IN FRETTA di quanto la distanza si
  accorci**: il contributo al rischio non e' uniforme, e **il massimo cade sul
  livello 4** (20,8% del rischio totale, SPEC §7.2). **La "compensazione" che
  descrive non e' quella che il foglio realizza.**
- 🔴 **Il seme non si allaccia ai volumi** → fattore **2,29** (§1.5).
  **La bandiera piu' pericolosa del modulo.**
- 🟠 **_"Non preoccuparti, quest'operazione la fara' il nostro file Excel"_** —
  il calcolo del rischio e' **deliberatamente sottratto** allo studente. In una
  lezione che si chiama "gestione del rischio".
- 🟢 **Il rischio E' quantificato in anticipo e per il pacchetto intero.** Va
  detto: e' piu' di quanto facciano il 90% dei corsi.

**A SCHERMO E NON NEL PARLATO:** 🖼️
1. 🔴 **La cella rossa del rischio complessivo e la colonna verde dei profitti**
   — mostrate, mai lette per intero. Ne legge **due valori su sei**.
2. 🔴 **L'AMMONTARE DEL CONTO** inserito in cashbackforex: _"mettiamo
   l'ammontare del nostro conto"_ **senza pronunciare la cifra**.
   **E' la ragione per cui §1.5 non chiude.**
3. 🟠 L'interfaccia del calcolatore e la sua formula.

**COSA NE COPIAMO:** ✅ **I tre parametri `P` (40/70/20) — sono la chiave di
tutta la geometria.** ✅ Le tre percentuali (0,21 / 0,26 / 4,06) come
**test-case di verifica del sizing**. 🚫 **NON copiamo la procedura di sizing**
(cashbackforex + seme): si usa il rischio-% di casa.

---

## 📄 SCHEDA 5 — `30. MEDIAZIONE INSERIMENTO ORDINI A MERCATO.txt`

| campo | contenuto |
|---|---|
| **FILE** | `30.MEDIAZIONE INSERIMENTO ORDINI A MERCATO.txt` (7.072 car.) |
| **OGGETTO** | L'inserimento ticket per ticket. **La lezione che ha dato i VOLUMI** — cioe' il moltiplicatore ×1,5. |

**PARAMETRI CON VALORE:**

| voce | valore | citazione | etichetta |
|---|---|---|---|
| **Volumi GBPUSD** | **0,04 · 0,06 · 0,09 · 0,14 · 0,20 · 0,30** | dettati uno per uno coi rispettivi livelli | 🟢 **tutti e sei** |
| **Volumi EURGBP** | **0,06 · 0,09 · 0,14 · 0,20 · 0,30 · [—]** | il sesto **non viene pronunciato** | 🟠 **5 su 6** → il sesto e' **0,45** `[I]` |
| **I 6 livelli EURGBP** | 0,8598 / 0,8608 / 0,8618 / 0,8628 / 0,8638 / 0,8648 | dettati uno per uno | 🟢 **tutti e sei** |
| Seme EURGBP | **0,015%** ↔ 0,01 lotti | _"eurosterlina, 20 pip di stop loss. Per una size minima di 0.01 abbiamo un rischio dello 0.015"_ | 🟢 chiaro |
| Scalatura EURGBP | **×5** → 0,075% ↔ 0,06 lotti | _"possiamo in qualche modo aumentare anche di 5 volte il nostro rischio, quindi andiamo a 0.075 ... possiamo intervenire a mercato con 6 micro lotti"_ | 🟢 chiaro — ✅ **coerente** |
| **Rischio obiettivo** | **1%** | _"Almeno cerchiamo di mantenere un rischio pari all'1%"_ | 🟢 chiaro |
| Profitto atteso EURGBP | **2%** | _"abbiamo un rischio dell'1% e un ... take profit del 2%"_ | 🟢 chiaro (R:R 1:2) |
| Rischio GBPUSD | **1,76%** | _"la sterlina ha un rischio leggermente superiore ... quindi parliamo dell'1,76"_ | 🟢 chiaro |
| TP GBPUSD | 1,2572 (una volta "1,2575") | | 🟠 **1,2572**, 5 occorrenze contro 1 |

**MECCANISMI:**
- 🔑 **UN SOLO SL E UN SOLO TP, ripetuti SEI VOLTE mentre inserisce**
  `[T]`: _"ogni posizione avra' un livello di ingresso diverso, ma **identico
  stop loss e take profit dell'operazione**"_ · _"stop loss rimane sempre
  identico per tutte le posizioni, 0.8658"_ (×6).
  ✅ **E' la prova che lo stop totale del pacchetto e' REALE e depositato al
  broker.** Risponde alla domanda n.2 del mandato.
- **Tutti e sei come ordini PENDENTI** (`limit` sotto/sopra il prezzo, `stop`
  dall'altra parte) `[T]`.
- **Durata:** _"tutti gli altri rimangono in posizione fino a quando ... il
  mercato non tocchera' il target o ... il livello di ingresso"_ `[T]`.

**REGOLE PROP CITATE:** nessuna.

**NUMERI DI PERFORMANCE:** nessuno.

**BANDIERE ROSSE:**
- 🔴 **LA PROGRESSIONE ×1,5 E' QUI, in chiaro, anche se non viene mai nominata.**
  `0,04 → 0,06 → 0,09 → 0,14 → 0,20 → 0,30`: **la posizione piu' grande (0,30,
  7,5 volte la prima) e' quella piazzata a 35 pip dallo stop.**
- 🔴 **DUE PACCHETTI APERTI CONTEMPORANEAMENTE** (GBPUSD 1,76% + EURGBP 1,00%)
  su coppie **legate dalla sterlina**, senza una parola sul rischio aggregato.
  **2,76% simultaneo, e nessun cap.**
- 🟠 **_"possiamo in qualche modo aumentare anche di 5 volte il nostro rischio"_**
  — la scalatura al rialzo e' presentata come normalizzazione verso l'1%, ma
  e' comunque un **×5 deciso a occhio in diretta**.
- 🟢 **Contro-bandiera pesante:** ogni singolo ticket parte con SL e TP gia'
  scritti. **Non esiste il ticket "nudo".**

**A SCHERMO E NON NEL PARLATO:** 🖼️
1. 🟠 **Il sesto volume dell'EURGBP** — non pronunciato (lo inferiamo: 0,45).
2. 🔴 **La finestra "Terminale" con tutti gli ordini** — mostrata, mai letta.
3. 🟠 Il prezzo corrente esatto al momento di ogni inserimento.

**COSA NE COPIAMO:** ✅ **I sei volumi (→ il moltiplicatore 1,5), i sei livelli
EURGBP (→ test-case B), la regola "un solo SL e un solo TP".**

---

## 📄 SCHEDA 6 — `31. MEDIAZIONE GESTIONE DEGLI ORDINI ESEMPIO 2 E ESEMPIO 3.txt`

| campo | contenuto |
|---|---|
| **FILE** | `31. MEDIAZIONE GESTIONE DEGLI ORDINI ESEMPIO 2 E ESEMPIO 3.txt` (11.208 car.) |
| **OGGETTO** | Gestione, riaperture, uscite anticipate. **E la frase piu' importante del modulo.** |

**PARAMETRI CON VALORE:**

| voce | valore | citazione | etichetta |
|---|---|---|---|
| **EURUSD 22 feb: chiusura segnale** | **1,0823** | _"un livello di chiusura di 1, 0, 8 e 23"_ | 🟢 chiaro |
| **EURUSD 22 feb: SL** | **1,0943** | _"Stop Loss a 1, 0, 9 e 43"_ | 🟢 chiaro — ✅ **= C + 3P con P=40** |
| **EURUSD 22 feb: TP** | **1,0783** | _"Take Profit a 1, 0, 7 e 83"_ | 🟢 chiaro — ✅ **= C − P** |
| **I 3 livelli riempiti** | **1,0823 / 1,0843 / 1,0863** | _"sono stati lavorati, processati soltanto questi tre livelli"_ | 🟢 **conferma il passo da 20 pip = P/2** |
| Prezzo di chiusura manuale | **1,0829** | _"il livello al quale dovremmo chiudere tutte le nostre operazioni"_ | 🟢 chiaro |
| Williams al TP (esempio 4 apr) | **−49** | _"ha mantenuto un livello di meno 49, quindi siamo all'interno dell'area ... di ipercomprato ancora"_ | 🟢 **valore letto: conferma la mediana −50** |
| Cadenza di controllo | **1-2 ore** | _"potrebbe essere controllato a distanza di un'ora o due senza avere grandi differenze"_ | 🟢 chiaro |
| Date esempi | 4 apr · 17 apr · 22 feb · 28 feb | **anno mai detto** | 🔴 **BUCO** |

**MECCANISMI — i quattro che contano:**

1. **I livelli si ricostruiscono SEMPRE dal segnale, anche a ore di distanza**
   `[T]`: _"anche se noi dovessimo arrivare a distanza di diverse ore dal
   momento del segnale, i livelli di entrata, gli stop, i target vanno comunque
   calcolati a partire dal momento del segnale, quindi **lo dovete ricostruire a
   ritroso**"_. ✅ **Meccanizzabile, e identico al Breakout.**
2. **RIAPERTURA DOPO IL TAKE PROFIT** `[T]`: se al momento del TP il Williams e'
   **ancora entro −50** dalla sua zona, _"si possono riaprire **tutti** gli
   ordini"_ — **stessi livelli, stesso SL, stesso TP**. Il contro-esempio e'
   dato nella stessa lezione: al secondo TP il Williams era gia' oltre, _"a
   partire da questo momento in poi noi **non inseriremo piu'** dei nuovi
   livelli"_. ✅ **Regola con un criterio numerico: meccanizzabile.**
3. **RIAPERTURA DOPO LO STOP** `[T]`: _"O in caso di stop lo riapriamo nuovamente
   nella stessa direzione a partire dalla nuova uscita del Williams ... **a
   partire dai livelli piu' alti rispetto allo stop**"_ — 🟠 **la geometria di
   questa riapertura non e' MAI specificata.** `[BUCO]`
4. **USCITA ANTICIPATA** `[T]`: _"Se il Williams raggiunge l'area opposta ... a
   quel punto **tutte le operazioni devono essere chiuse**"_ — 🔴 ma nell'unico
   esempio concreto **aspetta il segnale completo opposto** (rottura del
   SuperTrend del 28 febbraio), non solo il Williams. **Ambiguita' 8** (§1.10).

**🔴 LA FRASE CHE VALE TUTTA LA LEZIONE** `[T]`:
> _"c'e' da considerare che il fatto di aver inserito diversi ordini su diversi
> livelli attraverso questo sistema con un **rischio variabile, propriamente
> appunto un sistema di Martingala**, ci permettera' di chiudere la posizione
> **non necessariamente in stop loss**. Molte operazioni saranno compensate in
> profitto, alcune saranno chiuse con delle piccole perdite."_

> ⚖️ **Tre cose, in ordine:**
> 1. **L'autodefinizione e' agli atti: "martingala", parola sua.**
> 2. **La descrizione del payoff e' ONESTA** e coincide esattamente con la nostra
>    aritmetica (§1.4): tante compensazioni, poche piccole perdite.
> 3. 🔴 **Ma "non necessariamente in stop loss" e' un ARGOMENTO DI VENDITA
>    ROVESCIATO.** Il fatto che si esca spesso senza toccare lo stop e' proprio
>    cio' che rende **rara** la perdita piena — e le perdite rare e grosse sono
>    la coda che uccide le griglie. **Il corso presenta la coda come un pregio.**

**REGOLE PROP CITATE:** nessuna.

**NUMERI DI PERFORMANCE:** 🟠 solo qualitativi e `[dichiarati, NON verificati]`:
_"In questo caso abbiamo registrato un piccolissimo profitto"_ (22 feb),
_"i prezzi sono ... riscesi direttamente sino al nuovo target"_ (4 apr).
**Nessuna cifra. Nessun R. Nessun euro.**

**BANDIERE ROSSE:**
- 🔴 **"Martingala"**, detto dalla fonte (sopra).
- 🔴 **La riapertura RADDOPPIA l'esposizione sequenziale.** E l'esempio del 4
  aprile mostra proprio un pacchetto riaperto che _"ha preso alcuni altri
  livelli di ingresso"_.
- 🔴 **_"Peccato perche' se ne avesse presi di piu' saremmo stati piu' in
  profitto"_** — 🚨 **e' il rammarico piu' rivelatore del corso: si rimpiange
  che il prezzo NON sia andato piu' contro.** E' esattamente l'incentivo
  rovesciato delle griglie, espresso ad alta voce. **Aritmeticamente e' vero
  (§1.4: il 72% del profitto sta negli ultimi due livelli) — ed e' proprio per
  questo che e' pericoloso.**
- 🟠 **Nessun esempio va a STOP LOSS.** Tre esempi raccontati: uno a target, uno
  riaperto e andato a target, uno chiuso in pari. **In una lezione intitolata
  "gestione degli ordini", l'operazione che perde non viene mai mostrata.**
  Identico difetto del Breakout lez. 38. **Selection bias per costruzione.**
- 🟢 **Contro-bandiera:** _"per qualsiasi evenienza avete sempre le vostre
  operazioni aperte e i vostri **livelli di stop loss inseriti comunque in
  macchina**"_. **Lo stop e' al broker, non nella testa.**

**A SCHERMO E NON NEL PARLATO:** 🖼️
1. 🔴 **Il foglio Excel con la simulazione del 22 feb** — mostra quali livelli
   sono stati presi e con che P&L. **Nessuna cifra letta.**
2. 🔴 **L'ANNO** dei quattro esempi.
3. 🟠 Il terminale con le posizioni aperte in profitto/perdita.
4. 🟠 I livelli 4-5-6 dell'esempio EURUSD (ne detta 3 su 6).

**COSA NE COPIAMO:** ✅ **Ricostruzione a ritroso dal segnale, riapertura post-TP
col criterio −50, uscita su segnale opposto, i 5 numeri del test-case C.**
⚠️ **NON copiamo** la riapertura post-stop (geometria mancante).

---

## 📄 SCHEDA 7 — `32. MEDIAZIONE BACKTEST DELLA STRATEGIA E MONEY MENAGEMENT.txt`

| campo | contenuto |
|---|---|
| **FILE** | `32. MEDIAZIONE BACKTEST DELLA STRATEGIA E MONEY MENAGEMENT.txt` (6.303 car.) |
| **OGGETTO** | **L'unica lezione con numeri di risultato. Ed e' la piu' cieca del modulo** — commenta un foglio mai dettato. |

**PARAMETRI CON VALORE:**

| voce | valore | citazione | etichetta |
|---|---|---|---|
| Universo del test | **solo EURUSD** | _"tutte le operazioni individuate **esclusivamente sulla coppia euro-dollaro**"_ | 🟢 chiaro — 🔴 **e la strategia si vende su TRE** |
| Periodo | _"ultimi due anni"_ | | 🔴 **date esatte MAI dichiarate** |
| Capitale | **5.000 EUR** | _"una simulazione con uno storico che parte da 5 mila euro"_ | 🟢 chiaro — 🔴 **e §1.6 dice che l'1% non ci sta** |
| Tetto DD | **20%** | _"si consigliano dei drawdown complessivi intorno a un 20%"_ | 🟢 chiaro — 🔴 **contraddetto dalla lez. 33** |

**NUMERI DI PERFORMANCE — tutti `[dichiarati dal corso, NON verificati da noi]`:**

| scenario | dichiarato | citazione |
|---|---|---|
| **rischio 1%** | profitto **+30%** | _"qui e' stato raggiunto un profitto del 30%"_ |
| **rischio 1%** | DD **4%** | _"passa dal 4% al 12%"_ (a ritroso) |
| **rischio 3%** | profitto **+90%** | _"che invece del 30% raggiunge il 90%"_ |
| **rischio 3%** | DD **12%** | idem |
| **rischio 3%** | capitale finale **9.492 €** | _"potrebbe arrivare alla somma di 9.492 €, quindi quasi il doppio"_ |
| N. operazioni · win rate · broker · spread · date | **[BUCO] ×5** | mai dichiarati |

**🧮 ANALISI CRITICA (nostra):**

1. 🧨 **IL CORSO AMMETTE DA SOLO CHE NON SONO DUE SIMULAZIONI.** `[T]`:
   _"potete andare a simulare un eventuale rischio differente, quindi
   **moltiplicando per 2 o per 3 quelli che sono i profitti e le perdite
   maturate** in questo vostro primo storico"_.
   E i numeri lo confermano al punto percentuale: `30 × 3 = 90` ✅ ·
   `4 × 3 = 12` ✅.
   → **UNA lista ri-scalata, non due misure.** → **e non c'e' compounding**: un
   motore che capitalizza non produce profitto **e** DD entrambi esattamente
   ×3. Il "+30%" e' una **somma di P&L a size costante**.
   🔁 **E questo CONFERMA DALLA FONTE l'inferenza che avevamo fatto per
   aritmetica sul modulo Breakout** (§1.8).
2. 🔴 **Il "drawdown" non e' un max DD di equity.** `[T]` la sua definizione:
   _"il drawdown, cioe' la **sequenza di perdite consecutive** che sono state
   registrate sul conto"_. → **Conta P&L CHIUSI e ignora il flottante.** In una
   griglia il flottante e' esattamente dove vive il rischio. **Il suo "4%" e il
   nostro "max DD" non misurano la stessa cosa** — e la sua misura e' la piu'
   generosa delle due. ⚠️ Attenuante: qui il flottante e' limitato dallo SL hard.
3. 🔴 **Un cross testato, tre venduti — con estrapolazione a senso unico.**
   `[T]`: _"questi valori dovranno poi essere **aumentati** anche delle
   operazioni individuate sugli altri coppie"_. **Si estrapola in alto il
   profitto, mai il rischio**, e non si dice che i tre cross sono un triangolo
   chiuso.
4. 🟠 **"drawdown effettivo" / "atteso"** mai definiti — identico buco del
   Breakout lez. 39.
5. 🟠 **Coerenza col Breakout:** il Breakout (lez. 39) attribuiva alla mediazione
   _"27-30%"_; qui e' **30%** ✅. **Ma e' la stessa autrice: una fonte.**

**MECCANISMI:**
- Procedura per costruire il proprio storico: esportare da MT4 il *rapporto
  dettagliato* in `.xls` e incollare la colonna profitto nel foglio `[T]`.
  ✅ **Onesto e riproducibile — l'unica cosa verificabile di questa lezione.**
- Gradualita' del rischio (dettagliata nella lez. 33).

**BANDIERE ROSSE:**
- 🔴 **Backtest senza N operazioni, win rate, broker, spread, date.** In una
  lezione che si chiama "backtest della strategia". **Cinque buchi.**
- 🔴 **Linguaggio promozionale sul drawdown:** _"i livelli di drawdown
  rappresentano degli **strumenti di leva** per noi, una **possibilita' appunto
  di profitto**"_ 🚨 — **il drawdown descritto come opportunita'.** E' il
  ragionamento che porta ad alzare il rischio, ed e' piu' spinto di quanto
  facesse il Breakout.
- 🔴 **_"addirittura arriviamo anche a raddoppiare il nostro conto con un periodo
  di operativita' molto molto contenuto e anche contenuto e' il rischio"_** —
  raddoppio + rischio contenuto + tempo contenuto, tutto insieme, **senza un
  solo numero di supporto**.
- 🟠 **_"vale sicuramente la pena inserirle ... e lasciar correre i risultati per
  tutto l'arco dell'anno"_** — invito a non intervenire, senza criterio d'uscita.

**A SCHERMO E NON NEL PARLATO:** 🖼️
🔴 **L'INTERO FOGLIO DI CALCOLO: curva di equity, lista operazioni, N, win rate,
date, colonna gialla, colonna dei DD.** Tutto mostrato, **nulla dettato**.
**E' la lezione con i numeri ed e' la piu' cieca del corpus.**
**→ Domanda n.3 per Claudio.**

**COSA NE COPIAMO:** 🚫 **NESSUN NUMERO DI RISULTATO.** Si registrano le
dichiarazioni (+30% / DD 4% a 1% su solo EURUSD) **solo** per confrontarle col
nostro futuro backtest. ✅ Si copiano le due regole sane: **20 operazioni prima
di alzare il rischio** e **tetto DD** (col conflitto 20/3 dichiarato).

---

## 📄 SCHEDA 8 — `33. MEDIAZIONE PDF RIEPILOGATIVO.txt`

| campo | contenuto |
|---|---|
| **FILE** | `33. MEDIAZIONE PDF RIEPILOGATIVO.txt` (5.278 car.) |
| **OGGETTO** | La checklist finale. **La lezione piu' pulita per la spec** — ma commenta slide che non abbiamo. |

**PARAMETRI CON VALORE (checklist completa):**

| voce | valore | etichetta |
|---|---|---|
| **Williams periodo** | **140** | 🟢 **quarta occorrenza, nel PDF** |
| Universo | EURUSD, GBPUSD, EURGBP | 🟢 **elenco coincidente col terzo** |
| **Divieto di estensione** | _"non potrai applicare questo foglio ... per altre coppie valutarie"_ | 🟢 **esplicito** |
| Banda SELL | **[−20, −50]** | 🟢 chiaro |
| Banda BUY | **[−50, −80]** | 🟢 chiaro |
| Segnale | SuperTrend **cambia colore** | 🟢 chiaro |
| Ancora | chiusura della candela di segnale, _"l'**unico parametro** da inserire"_ | 🟢 chiaro |
| Output del foglio | **6 livelli + 1 SL + 1 TP** | 🟢 chiaro |
| Ordini | pendenti limit o stop | 🟢 chiaro |
| Validita' | fino a SL o TP | 🟢 chiaro |
| **Invalidazione** | Williams nella zona **opposta** | 🟢 chiaro — 🔴 vs lez. 31 |
| **Riutilizzo del segnale** | **UNA sola volta**, dopo un TP, se il Williams e' rimasto entro −50 | 🟢 **chiaro — ed e' il CAP sui cicli** |
| R:R minimo | **1 : 2** | 🟢 chiaro |
| Storico prima di alzare il rischio | **20 operazioni**, da rischio base **1%** | 🟢 chiaro |
| **Tetto DD** | **3%** | 🔴 **contraddice il 20% della lez. 32** |
| **Relatrice** | **Manuela Negro** (email) | 🟢 **conferma testuale del nome** |

**MECCANISMI:**
- **Le condizioni di ingresso in forma simmetrica BUY/SELL** — la formulazione
  piu' pulita del modulo, base della SPEC §4.
- 🔑 **IL CAP SUI CICLI** `[T]`: _"Il segnale potra' essere ... **riutilizzato
  solo un'altra volta, solo una seconda volta** e solo a condizione che, una
  volta raggiunto il primo target, il Williams si sia mantenuto all'interno
  dell'area ... quindi entro la soglia dei meno 50"_
  ✅ **Questo chiude una domanda che la lez. 31 lasciava aperta: la riapertura
  NON e' infinita. Massimo due cicli per segnale.** **E' la seconda gamba del
  contenimento del rischio, dopo il cap a 6 ingressi.**
- **Doppia condizione di morte del segnale:** zona opposta **oppure** stop loss.

**REGOLE PROP CITATE:** nessuna.
**NUMERI DI PERFORMANCE:** nessuno nuovo; rimanda alla lez. 32.

**BANDIERE ROSSE:**
- 🔴 **_"non andare al di la' del 3% come rischio ... di drawdown"_** — 🔴 **nella
  lezione di riepilogo, contro il 20% della lezione precedente.** Uno studente
  che studia **solo il PDF** applica un tetto **quasi 7 volte piu' stretto**.
  **E' l'errore piu' probabile per chi replica il corso** — speculare a quello
  che nel Breakout era la banda SELL sbagliata nel PDF.
- 🟠 **La checklist non contiene NULLA sul rischio del pacchetto** (il famoso
  1,76%), ne' sui volumi, ne' sul moltiplicatore. 🚨 **Come nel Breakout, il PDF
  non tratta i numeri che pesano di piu'.**
- 🟢 **In favore:** il cap sui cicli, il R:R minimo, la gradualita' del rischio e
  il divieto di estendere ad altre coppie sono **quattro regole di contenimento
  chiare e meccanizzabili.**

**A SCHERMO E NON NEL PARLATO:** 🖼️
🔴 **LE SLIDE DEL PDF.** Il parlato le **commenta** ma non le **legge
integralmente**. Nel modulo Breakout le slide hanno chiuso **6 ambiguita' su
10**: qui servirebbero per **il tetto DD (20 o 3?)** e per **la regola di
chiusura anticipata**. **→ Domanda n.4 per Claudio.**

**COSA NE COPIAMO:** ✅ **La checklist intera** (base della SPEC §4 e §10.1),
✅ **il cap "riutilizzabile una sola volta"**, ✅ **il divieto di estensione ad
altre coppie**, ✅ **la conferma del Williams 140 e delle bande.**

---

# PARTE 3 — 🗑️ GLI SCARTI

**Trascrizioni senza nulla di estraibile: ZERO.**

⚠️ **E' un dato inconsueto e va detto:** nel modulo Breakout la lez. 34 era
un'introduzione a vuoto (_"nessuna regola operativa"_). Qui **tutte e otto le
lezioni hanno prodotto almeno un parametro utilizzabile** — perfino la 27, che
e' pura preparazione della piattaforma, ha dato **la terza conferma del Williams
140** e **le due dipendenze esterne**.

**Materiale scartato DENTRO le lezioni** (con motivo):
- Colori dello sfondo, template grafici, salvataggio profili (lez. 27) —
  **estetica, zero impatto operativo.**
- La motivazione storico-narrativa delle fasi di accumulazione/distribuzione
  (lez. 26) — **tesi presentata come fatto, mai verificata nel corso**, e non
  produce una regola.
- La procedura di export da MT4 verso Excel (lez. 32) — **corretta ma non e'
  strategia**: e' contabilita'.
- Tutti i _"vi potete divertire"_, _"siamo stati veramente bravi"_ e simili —
  **riempitivo.**

---

# PARTE 4 — 🔗 RIMANDI

- **Specifica implementabile:** `backtest_pipeline/prove/MEDIAZIONE_CORSO_SPEC.md`
- **Modulo gemello (Breakout, lez. 34-40):**
  `ANALISI_CORSO_BREAKOUT_2026-08-18.md` + `prove/BREAKOUT_CORSO_SPEC.md`
  — ⚠️ **da aggiornare con i tre nodi chiusi da qui** (§1.8)
- **Setaccio di casa:** `backtest_pipeline/caccia_strategie/SETACCIO_MANUALE.md`
- **Metro prop:** `report/METRO_PROP.md` — ⚠️ **lacuna rilevata: nessuna riga su
  griglia/martingala nei termini delle prop** (§1.11 punto 1)
- **Regole di ammissione all'imbuto:** `CLAUDE.md` §Emendamento della finestra
  (⚠️ **le >=150 operazioni si contano in PACCHETTI**, §1.13 condizione 3) e
  §Criterio di uscita delle sedie
