# 🔬 RANGE BREAKOUT EA WITH RANGE FILTERS — Jimmy Peter Eriksson

_Referto scritto il **22/08/2026**. Tutte le pagine citate sono state **aperte
davvero**; la data di lettura e' **22/08/2026** salvo diversa indicazione.
Ogni numero che viene da fuori e' etichettato **[DICHIARATO DALL'AUTORE, NON
MISURATO DA NOI]**. Stesso rigore di `DOSSIER_EA_NASDAQ_ESTERNI_2026-08-21.md`._

**Mandato di Claudio (5° EA esterno)**: indagare a fondo il prodotto
"Range Breakout EA with Range Filters", categoria Experts su MQL5 Market,
autore Jimmy Peter Eriksson (`jimmy282`), rating 4,55.

> ## 🎯 LA RIGA CHE CONTA
> **Questo NON e' un ORB di apertura come Diego/Artemis: e' un breakout del
> RANGE ASIATICO all'apertura di Londra, su 5 mercati (XAUUSD, USDJPY,
> BTCUSD, US30, DE40) — e il Nasdaq NON c'e'.** E' anche il primo dei cinque
> prodotti esterni guardati finora che ha un **track record pubblico vero**:
> 13 signals, 92 settimane, 1.876 operazioni. Ed e' proprio quel track record
> a bocciarlo per noi: **drawdown massimo dichiarato dal SUO STESSO signal
> 25,53% sul saldo**, cioe' **2,5 volte il muro totale del 10%** di
> `METRO_PROP.md`. Il secondo motivo e' geografico e non si aggiusta:
> **l'autore scrive nero su bianco che l'EA vuole un broker GMT+2/GMT+3, e
> BCM oggi e' GMT+1.**
>
> **Ma il `.set` pubblico che ho scaricato vale il viaggio**: e' il pannello
> input completo con i valori veri, ed e' materiale copiabile.

---

## 0. ✅ CONTROLLO POSITIVO DELLE FONTI (fatto prima di cercare)

| fonte | bersaglio noto | esito |
|---|---|---|
| MQL5 Market (curl diretto) | pagina 122237 deve mostrare nome/autore/prezzo/versione | ✅ HTTP 200, 306 kB, testo integrale |
| MQL5 tab `/comments` (pag. 1-2) | thread completo | ✅ 200, **33 commenti** letti per intero |
| MQL5 tab `/updates` | changelog | ✅ 200, **25 versioni** |
| MQL5 recensioni (schema.org + HTML) | 23 dichiarate in intestazione | ✅ 20 testi + **voti di tutte** (§4) |
| MQL5 Signals | signal 2271995 deve dare statistiche | ✅ 200, statistiche complete |
| c.mql5.com (allegati) | i 3 `.set` del commento #18 | ✅ 200, **scaricati e letti** |
| Google / ricerca web | tracce indipendenti | ✅ risponde, **trova** Trustpilot + Myfxbook |
| **www.trustpilot.com** | pagina recensioni erikssonsystems.com | ❌ **BLOCCATO dal proxy** (`EGRESS_BLOCKED`) |
| **www.myfxbook.com** | conto "Range Breakout EA Live" | ❌ **BLOCCATO dal proxy** (`EGRESS_BLOCKED`) |
| endpoint AJAX recensioni MQL5 | pagina 2 delle recensioni | ❌ **404 senza sessione** (§4) |

🔴 **Cosa NON ho potuto vedere, e va dichiarato:**
1. **Myfxbook**: esiste un conto pubblico `JimmyEriksson/range-breakout-ea-live/12007277`
   ma il proxy blocca il dominio → **non so se sia "verified"** ne' quali numeri
   riporti. **[INCERTO]**
2. **Trustpilot**: la ricerca dice *4 stelle su 8 recensioni* ma **non ho potuto
   aprire la pagina** → il dato resta di seconda mano. **[INCERTO]**
3. **3 recensioni su 23** non hanno testo visibile (§4) — ma so quanto valgono.

---

## 1. 🪪 SCHEDA PRODOTTO

| voce | valore | fonte |
|---|---|---|
| **nome esatto** | Range Breakout EA with Range Filters | [VERIFICATO] |
| **piattaforma** | **MetaTrader 5**, categoria Experts. ⚠️ **Non esiste versione MT4** in catalogo | [VERIFICATO] |
| **URL** | https://www.mql5.com/en/market/product/122237 | [VERIFICATO] |
| **autore** | Jimmy Peter Eriksson (`jimmy282`), **Australia** | [VERIFICATO] |
| **prezzo** | **649 USD** (schema.org: `"price":"649.00"`) · **niente noleggio esposto** | [VERIFICATO] |
| **pubblicato** | **25 agosto 2024** (schema.org: `2024-08-25T21:18:05`) → **2 anni** di vita | [VERIFICATO] |
| **versione attuale** | **5.10**, aggiornata **21 agosto 2026** (ieri l'altro) | [VERIFICATO] |
| **attivazioni** | 10 | [VERIFICATO] |
| **demo scaricate** | **2.562** | [VERIFICATO] |
| **acquisti/mese** | 16 (dato MQL5 in intestazione) | [VERIFICATO] |
| **rating** | **4,5454…** su **22** voti (schema.org `aggregateRating`); l'intestazione ne dichiara 23 | [VERIFICATO] |
| **commenti** | 33 | [VERIFICATO] |
| **deposito minimo** | ⚠️ **NON dichiarato da nessuna parte** nella scheda | [VERIFICATO — assenza] |

⚠️ **Attenzione a un omonimo**: esiste `Range Breakout EA` (MQL5 87520, 197 USD,
autore **BM Trading GmbH**, pubblicato 10/10/2022) e la sua versione MT4 (87609).
**Sono di un altro venditore.** Il nostro e' il 122237.

### 1.1 💰 Il prezzo e' un obiettivo mobile — e sale
La scheda apre con: *"UPDATE: Few Copies Left At Current Price! **Final price:
$999**"*. Ma nel commento **#8 del 03/11/2025** un cliente scrive: *"I have
purchased this bot in addition to the range breakout EA (**before price went
north**)"*. E la recensione di Rudy Bompeix (10/11/2025) dice *"**Don't be
fooled by the low price**"* — su un prodotto che oggi ne costa 649.

> 📌 **[VERIFICATO]** Il prezzo e' salito almeno una volta in nove mesi, e la
> scheda ne annuncia un altro aumento a 999. Il *"few copies left"* con
> **2.562 demo scaricate** e **16 acquisti al mese** e' **leva di vendita, non
> scarsita'**. Non e' una bandiera rossa grave — e' il tono commerciale
> standard di MQL5 — ma va scritto perche' entra nel giudizio sul venditore.

---

## 2. ⚙️ IL MECCANISMO DICHIARATO — che genere di "range breakout" e'

**[VERIFICATO 22/08, testo integrale della scheda]**:

> *"Range Breakout EA is based on a well-known market behaviour: **changes in
> volatility between trading sessions**. Volatility is usually low during the
> **Asian session**, creating a tight price range. **When the London session
> opens**, volatility increases and price often breaks out of this range and
> continues moving in the breakout direction. The system trades this breakout
> and **closes positions later in the day when volatility starts to slow down**.
> **It does not use indicators or fixed timeframes**, which helps reduce
> overfitting. An **internal breakout filter** is used to avoid low-quality
> breakout trades."*

### 2.1 🧩 Risposta alla domanda del mandato: e' della famiglia di Diego/Artemis?
**NO, e va detto chiaro.**

| | **Diego / Artemis / il nostro R97** | **Range Breakout EA** |
|---|---|---|
| range costruito | sui minuti dopo la **campana USA** (15:30 IT / 14:30 server) | sull'**intera sessione asiatica** (4-6 ore di notte) |
| rottura attesa | apertura Nasdaq | **apertura di Londra** |
| durata del range | 5-15 minuti | **240-360 minuti** |
| simbolo | NAS100 / US30 | XAUUSD, USDJPY, BTCUSD, US30, DE40 |
| uscita | TP/SL o trailing | 🔵 **uscita a TEMPO** (nessun take profit) |

📌 **Meccanicamente e' l'archetipo "Asian range → London breakout"**, cioe' la
stessa inefficienza della **caccia Londra del 19/08** (regola della seconda
caccia, dopo il verdetto R45 0/48), **non** quella di R97.

> ⚠️ **NON tocco R97, e' firmato.** Segnalo solo il fatto: **questo prodotto
> non porta niente a R97**, perche' non parla del Nasdaq ne' della campana USA.
> Chi cerchera' materiale per R97 deve guardare altrove.

### 2.2 🔍 I "Range Filters" del nome — cosa filtrano davvero
Nel `.set` (§5) i filtri sono **quattro, tutti sull'AMPIEZZA**, non sull'orario:

| filtro | cosa fa | stato nei preset ufficiali |
|---|---|---|
| `InpRangeFilter` + Min/Max`Percent` | scarta il range di OGGI se troppo stretto/largo | ❌ **spento su tutti e 3** |
| `InpYesterdayRangeFilter` + Min/Max`Percent` | scarta la giornata se il range di **IERI** era troppo largo | ✅ **acceso su XAUUSD (max 0,81) e USDJPY (max 0,70)**, spento su BTCUSD |
| `InpYesterdayBigRange` + `InpAtrFilterMin/MaxSize` | filtro su **ATR del giorno prima** | ✅ acceso **solo su BTCUSD** (max 1) |
| `InpAdxFilter` + Min/Max`Value` | filtro **ADX** | ❌ **spento su tutti e 3** |

> 🔵 **Questo e' il pezzo di intelligence piu' pulito del prodotto.** Il filtro
> che il venditore tiene ACCESO su 2 mercati su 3 non guarda il range di oggi:
> guarda **quanto ha corso il mercato IERI**, e **rinuncia a operare dopo una
> giornata troppo mossa**. E' un filtro di **regime di volatilita' a memoria di
> un giorno**, ed e' esattamente il tipo di meccanismo che nei nostri EA
> **non esiste**. Vedi §8, proposta P1.

### 2.3 🚩 La contraddizione: "non usa indicatori" contro il proprio changelog
La scheda di oggi dice *"It does not use indicators or fixed timeframes"*.
**Ma il changelog dice il contrario, ed e' scritto dallo stesso autore:**
- **v1.70 (27/11/2024)**: *"Added **ATR Filter** 'Min Size'. Added **Trailing
  Stop Loss**. Added **ADX Filter**."*
- e il `.set` ufficiale ha ancora dentro `InpAtrPeriod`, `InpAdxPeriod`,
  `InpAdxFilter`, `InpAdxMinValue`, `InpAdxMaxValue`.

> **[VERIFICATO]** Gli indicatori ci sono, sono ATR e ADX, e sono **spenti nei
> preset** — non assenti dal codice. La frase di marketing e' **imprecisa**,
> non falsa. E' lo stesso genere di scivolone di Artemis sul filtro news
> (§2.2 del dossier di stanotte), ma **molto meno grave**: qui non c'e' una
> promessa non mantenuta, c'e' una semplificazione commerciale.

---

## 3. 📜 CHANGELOG COMPLETO — 25 versioni, e la firma della ri-ottimizzazione

**[VERIFICATO 22/08, tab `/updates`, tutte le voci lette]**

| ver | data | testo dell'autore (sintesi fedele) |
|---|---|---|
| 1.10 | 2024.08.29 | fix input "Breakout Range Min/Max" |
| 1.20 | 2024.08.31 | fix ATR Stop Loss Multiplier |
| 1.30 | 2024.08.31 | **+ Day Of The Week Filter**, + moltiplicatore ATR giorno prima |
| 1.40 | 2024.09.13 | migliorato calcolo rischio |
| 1.50 | 2024.11.05 | + `Allow Buy` / `Allow Sell` |
| 1.60 | 2024.11.18 | + rischio su **Account Equity** |
| 1.70 | 2024.11.27 | **+ ATR Filter Min Size, + Trailing Stop Loss, + ADX Filter** |
| — | — | 🕳️ **BUCO DI 10 MESI E MEZZO — nessun aggiornamento** |
| 1.80/1.90 | 2025.10.15 | fix Risk Type / fix calcolo rischio |
| 2.0 | 2025.10.28 | **"Adjusted Preset & Optimized Inputs for XAUUSD"** |
| 2.10 | 2025.11.11 | 🔴 **"Removed most of the input settings – now fully plug & play"** · + Automatic Risk System · **+ Randomization di ingressi, uscite e stop loss** · **+ Daily Drawdown Protector** |
| 3.0 | 2025.11.11 | fix commento a schermo |
| 3.10 | 2025.11.16 | **"Improved the randomization feature for more unique trades"** |
| 3.12 | 2025.11.25 | + avviso a schermo quando il filtro blocca · **"Updated inputs for improved stability"** · + rischio sul saldo di partenza |
| 3.20 | 2025.11.27 | **+ "full Manual Override mode"** *(Not recommended for normal use)* |
| 3.21 | 2025.11.30 | chiariti gli input di orario |
| **4.0** | 2025.12.04 | 🔴 **"Added markets US30 and DE40"** |
| 4.1 | 2025.12.09 | fix lotti FundedNext su US30 |
| 4.2 | 2025.12.11 | fix lotti + funzione per **The5ers** |
| 4.35 | 2025.12.16 | **+ modalita' compatibilita' FTMO** per i lotti su US30/DE40 |
| 4.36 | 2025.12.19 | + compatibilita' **FundedNext** e Fusion Markets |
| 4.37/4.38 | 2025.12.21-22 | fix lotti BTCUSD |
| 4.50 | 2026.01.18 | **"Updated optimized inputs for better live stability"** · **+ spread filter** |
| 4.60 | 2026.02.06 | fix: DE40 non chiudeva a fine serata su certi broker |
| 4.70 | 2026.02.17 | **"Improved SL calculation on Gold to avoid very big losses in High volatility periods"** |
| 4.80 | 2026.03.28 | fix: US30 non chiudeva il venerdi' sera su certi broker |
| 5.0 | 2026.07.08 | **+ One Chart Mode** · **"Optimized the strategy inputs using data from the latest market environment"** |
| **5.10** | **2026.08.21** | 🔴 **fix: il Daily Drawdown Protector NON si azzerava a inizio giornata in One Chart Mode** |

### 3.1 🔴 Le tre cose che il changelog racconta (e la scheda no)

**a) Gli input sono stati TOLTI, non aggiunti.** v2.10: *"Removed most of the
input settings"*. Il cliente **Alvin Kurniawan** (recensione 27/11/2025) lo
dice in faccia: *"sadly dev patch 2.0 **remove all the input and locked the
setting**. I just felt like i purchased the wrong EA, **can i ask for refund**?"*
Risposta del venditore: *"many users were unintentionally **over-optimizing and
destroying the real-life performance**. To protect everyone's long-term results
… **I locked the core parameters** in version 2.0."*
Il cliente poi corregge: *"developer … agree to bring back the customization
inputs … **Version 3.2 is good**"* (= il Manual Override di v3.20).

> ⚠️ **Per noi questo e' il difetto strutturale.** Un EA che **nasconde i
> parametri del motore** e' un EA che **non entra nell'imbuto di casa**: la
> nostra macchina (griglia IS/OOS, altopiano, centro mai picco) ha bisogno di
> spazzolare gli assi. Con i parametri chiusi **non c'e' round possibile**, si
> puo' solo accendere e sperare. E' lo stesso movimento nella direzione
> sbagliata gia' visto su Artemis v1.30 (*"now handled internally by the EA"*).

**b) Le "inputs ottimizzate" sono state ri-tarate QUATTRO volte** in dieci mesi
(v2.0, v3.12, v4.50, v5.0), l'ultima dichiarando esplicitamente
*"using data from the **latest market environment**"* (08/07/2026).

> 🔴 **Questa e' la firma della manutenzione per ri-ottimizzazione.** E' lo
> stesso reperto trovato su Master Nasdaq (§3.3 del dossier di stanotte:
> indicatori aggiunti e poi rimossi), qui in forma diversa e **piu' onesta**
> — l'autore lo scrive — ma l'effetto sul nostro metro e' identico: **le
> statistiche storiche del prodotto NON sono le statistiche di UN motore**,
> sono la somma di quattro tarature diverse cucite insieme.

**c) Il prodotto e' NATO su 3 mercati e ne ha aggiunti 2 dopo 15 mesi.**
XAUUSD/USDJPY/BTCUSD dal 2024; **US30 e DE40 solo dal 04/12/2025**.
E il cliente **1228 TimYeh** (30/01/2026, §4) si lamenta esattamente di
**US30, DE40 e USDJPY**. Il track record "22 mesi" **non copre 22 mesi di
US30 e DE40**: ne copre 8.

📌 **E c'e' un dettaglio che dice tutto sul rapporto col mondo prop**: cinque
versioni consecutive (4.1 → 4.38, dicembre 2025) sono **fix del calcolo dei
lotti su FTMO, FundedNext, The5ers e Fusion Markets**. Cioe': **per un mese
intero, chi ha usato questo EA su una prop ha dimensionato le posizioni in
modo sbagliato.** Lo conferma la recensione di Oly.FX (§4).

---

## 4. ⭐ LE RECENSIONI — tutte, coi voti, e l'aritmetica che chiude il conto

### 4.1 La distribuzione ESATTA dei voti
**[VERIFICATO 22/08 — `schema.org/aggregateRating` + i 20 blocchi `review_*`]**

- `aggregateRating`: **ratingValue 4,5454545 su ratingCount 22**.
- Ho letto **20 recensioni** con voto e testo: **17 da 5 stelle, 1 da 3, 2 da 1**.
- Somma dei 20 letti = 90. Somma totale necessaria = 4,5454545 × 22 = **100**.
- **→ le 2 che non ho potuto aprire valgono 10 punti = due 5 stelle.**

> ✅ **Conseguenza forte, e la scrivo perche' e' il punto piu' utile del §4:
> ho letto TUTTE le recensioni non-positive che esistono.** Le tre critiche
> (§4.2) sono l'intero campione negativo del prodotto. Il buco di pagina 2
> non nasconde niente.

### 4.2 🔴 Le TRE recensioni critiche, testo integrale

**① Julien Metz — 1 stella — 21/03/2026** *(la piu' pesante)*
> *"It seems like we have another case of **bought reviews** here. After having
> tested the system for a month I was on a **loss of 3 percent**, the dev said
> yeah thats pretty good, thats no problem, this happens. I stopped using it,
> because I had profitable eas, I saw those feedbacks and thought alright, lets
> try it again and once again, **high losses, small wins and it ate the profit
> of my other experts**. Sad, I have to add that I trade with RoboForex and can
> only judge XAUUSD and USDJPY."*

Risposta del venditore, **18 minuti dopo**: *"There is absolutely no bought
reviews here! The EA is **plus 21% profit this month** which is extremely good
results so I am not sure what you have done with your setup."*

**② 1228 TimYeh — 1 stella — 30/01/2026** *(con screenshot allegati, 3 file)*
> *(dal cinese, traduzione del venditore stesso pubblicata nel thread)*
> *"I almost lost 10K recently, and today I'm back to the initial 10K… The win
> rates for **US30, DE40, and USDJPY** in this EA are shockingly low.
> **If I hadn't installed this EA, I would have already beaten the game**
> [= passato la challenge]. Even flipping a coin wouldn't be this bad!
> I even bought three EAs here."*

Risposta: *"…up a total of **121%**, with an average of around **10% profit per
month**. The screenshots … only show results from around 2 weeks. That is far
too short… **win rate has nothing to do with overall performance**. This system,
especially on US30 and DE40, is designed with a **lower win rate but higher
risk-reward**."*

> 🔴 **Questo e' il reperto piu' rilevante per NOI**, e non per il punteggio:
> e' **un cliente che dichiara di aver FALLITO una challenge per colpa
> dell'EA**, sui due indici (US30, DE40) aggiunti al prodotto **due mesi
> prima**. E' esattamente il tipo di fallimento che il ruolo cerca:
> "come la gente brucia le challenge".

**③ Oly.FX — 3 stelle — 10/12/2025** *(cliente di 14 mesi, non un impaziente)*
> *"This is an edition to my previous review… I bought Range Breakout EA
> **14 months ago**. I used it with relative success for 2 periods few months
> ago… but **now with it's most recent updates this EA lost the correct way to
> calculate lot sizes**. I have shown the author the problem and he suggested
> the problem was on my side. **I have proved it is not, sending screenshots,
> and he silenced.** It was a good EA back in time… **Not running in my personal
> portfolio anymore.**"*

Risposta (7 giorni dopo): *"After adding support for US30 and DE40, the lot
calculation did behave incorrectly on some brokers due to non-standard tick
values and contract specifications **used by certain prop firms**."*

> ⚠️ **Il venditore AMMETTE il bug, e lo ammette proprio sulle prop.** Il
> cliente non era arrabbiato per una perdita: era arrabbiato perche' **il
> lotto era sbagliato** e il supporto lo ha zittito. Su un conto prop un lotto
> sbagliato non e' una perdita: e' **il muro giornaliero sfondato per errore
> di calcolo**.

### 4.3 Le 17 positive — cosa dicono, e cosa NON dicono
Le ho lette tutte. Riassunto onesto:
- **Zero numeri verificabili.** Nessuna riporta un drawdown, un periodo, una
  challenge passata con importi. La piu' concreta e' **PT1000 (29/06/2026)**:
  *"Been running this for around 6 months… **tracked close to the backtest
  results**… Jimmy's live signal speaks for itself — **147% total growth**"*
  → e' comunque il **numero del signal del venditore**, non del cliente.
- **Una sola nota tecnica utile, ed e' una critica travestita** — **bi mo
  (02/05/2026)**: *"Great system, some pairs struggle more than others, but
  well diversify. **Be mindful that some strategies have high correlation with
  other EAs from the author.**"*
  🔵 **Questo e' un dato**, ed e' il piu' importante fra le positive:
  **i prodotti dello stesso venditore si sovrappongono.** Chi compra due suoi
  EA per "diversificare" **raddoppia lo stesso rischio**. Torna nel §7.
- **Due recensioni (Carl-Gustav Öberg, 07/02/2026) sono in un inglese
  artificiale** (*"Jimmy's practices **gleam** with their direct, hardy
  designs… **stochastic touches** for individualized trades, and **prop entity
  adaptability**"*), praticamente identiche a quella che lo stesso utente ha
  lasciato su Prop Firm Gold EA lo stesso giorno. **[INFERITO]**: testo
  generato/parafrasato. Non e' prova di recensioni comprate — l'accusa di
  Julien Metz resta **non dimostrata** — ma **due recensioni gemelle dello
  stesso utente in un giorno non sono due opinioni**.

---

## 5. 🧾 IL `.set` PUBBLICO — il pannello input con i valori veri

**[VERIFICATO 22/08]** Nel commento **#18 del 28/10/2025** il venditore ha
allegato **tre file `.set` ufficiali** (`RangeBreakout_EA_XAUUSD.set`,
`_USDJPY.set`, `_BTCUSD.set`, 5 kB ciascuno). **Li ho scaricati da
`c.mql5.com/31/1588/` — HTTP 200, scaricabili senza acquisto** — e letti riga
per riga. Intestazione interna: *"saved on 2025.10.28 … input parameters for
… RangeBreakout EA **V2.00**"*.

⚠️ **Onesta' obbligatoria**: nel commento **#27 (24/11/2025)** il venditore
scrive *"**The setfiles was for the previous version. They do not apply
anymore.** I will contact Mql5 to remove that comment."* — **nove mesi dopo
sono ancora li'.** Quindi: **sono i valori di V2.00, non di V5.10.** Restano
l'unica finestra che abbiamo sui numeri veri del motore, e come **esempio
copiabile** valgono lo stesso.

### 5.1 📋 LA TABELLA DEGLI ESEMPI — i tre preset a confronto

| input | **XAUUSD** | **USDJPY** | **BTCUSD** | cosa significa |
|---|---|---|---|---|
| `InpEntryTimeframe` | 1 (M1) | 1 (M1) | 1 (M1) | logica su barra M1 |
| `InpRiskType` | 2 | 2 | **1** | modalita' di rischio (3 = diverse) |
| **`InpRiskPercent`** | **1,0** | **1,0** | **1,0** | 🔴 **1,0% per operazione** — noi: **0,65%** |
| `InpStopLoss` (tipo) | 1 | **0** | **2** | tre metodi di SL diversi per i tre mercati |
| `InpStopLossPercent` | 1,0 | 1,0 | 1,0 | parametro dello SL |
| **`InpTwoTradesPerDay`** | **false** | **true** | **false** | 🔵 **tetto operazioni: 1/giorno (2 su USDJPY)** |
| `InpAllowBuy/SellTrades` | true/true | true/true | true/true | entrambi i lati |
| **`InpActivateTralingSl`** | **false** | **false** | **false** | 🔴 **trailing SPENTO su tutti e tre** |
| **`InpRangeStartHour:Minute`** | **02:30** | **01:00** | **00:00** | inizio del range asiatico |
| **`InpRangeEndHour:Minute`** | **06:30** | **06:00** | **06:00** | fine range: **4h / 5h / 6h** |
| **`InpEntryEndHour`** | **16:00** | **14:00** | **15:00** | ultimo orario in cui puo' entrare |
| **`InpTradeCloseHour`** | **19:00** | **19:00** | **20:00** | 🔵 **flat a orario fisso, tutti i giorni** |
| `InpFirst/LastTradingDay` | 1→5 | 1→5 | 1→5 | **lun-ven, mai weekend** |
| `InpRangeFilter` | false | false | false | filtro range di oggi: spento |
| **`InpYesterdayRangeFilter`** | **true, max 0,81** | **true, max 0,70** | false | 🔵 **salta il giorno dopo una giornata troppo larga** |
| `InpYesterdayBigRange` / `AtrFilterMaxSize` | false / 0 | false / 0 | **true / 1** | filtro ATR giorno prima (solo BTC) |
| `InpAdxFilter` | false | false | false | ADX spento |
| `InpAtrPeriod` / `InpAdxPeriod` | 14 / 14 | 14 / 14 | **10 / 10** | periodi indicatori |
| `InpMagicNumber` | **1** | **2** | **3** | ⚠️ magic 1/2/3 — vedi §5.3 |

### 5.2 📐 Quello che questi numeri dicono, letti col metro di casa

1. 🔴 **Rischio 1,0% per operazione contro il nostro 0,65%** = **+54%**.
   Con `TwoTradesPerDay=false` il caso peggiore giornaliero **per simbolo**
   e' 1,0%. Ma i mercati sono **5** e girano **in parallelo dallo stesso
   chart** (One Chart Mode): **caso peggiore teorico 5,0-6,0% in un giorno**
   = **il muro giornaliero intero**, e **oltre il cap C1 (3,25%)** di casa.
   ⚠️ **[INCERTO]**: non so se le versioni 4.x/5.x dividano il rischio fra i
   mercati. Su **Prop Firm Gold** il venditore ha aggiunto una funzione che lo
   fa (v1.94) — **su Range Breakout non l'ho trovata in nessuna voce del
   changelog**.
2. 🔵 **Uscita a TEMPO, non a target.** Nessun `TakeProfit` in tutto il file.
   Il vincitore lo decide l'orologio (19:00/20:00), non il prezzo.
   **Nessuno dei nostri EA fa cosi'**, ed e' un'idea a costo zero (§8, P2).
3. 🔵 **Flat prima della fine giornata, mai overnight, mai weekend.**
   `LastTradingDay=5`. E' **esattamente il "buco" del flat serale** gia'
   segnato nella tabella §5 del dossier di stanotte.
4. 🟠 **Trailing spento e sconsigliato dall'autore stesso** — commento #20:
   *"Regarding the trailing stop, **I actually don't recommend using it on
   these markets — I've tested it quite a lot and never found stable or
   consistent results**."* 📌 Detto da uno che vende: e' un'ammissione onesta,
   e coincide con quello che il progetto ha misurato piu' volte.
5. ⚫ **Tre metodi di stop loss diversi per tre mercati** (`InpStopLoss` = 1, 0, 2)
   e **periodi ATR/ADX diversi su BTC** (10 invece di 14). **[INFERITO]**:
   e' un motore **tarato per simbolo**, non un motore unico. Non e' un difetto
   di per se' (anche noi facciamo sedie per simbolo), ma smentisce l'idea di
   "una logica sola su cinque mercati".

### 5.3 ⚠️ Magic 1, 2, 3 — collisione potenziale sul nostro conto
I preset usano `InpMagicNumber` **1, 2, 3**. I nostri magic sono **770xxx** e
**779001** (Guardian): nessuna collisione diretta. **Ma un magic = 1 e' il
numero piu' probabile del mondo**: qualunque altro EA di prova sullo stesso
conto lo userebbe. Se un giorno si provasse, **va cambiato subito**.

---

## 6. ⏰ IL FUSO — il punto che chiude la questione per BCM

### 6.1 Cosa dichiara la scheda
> *"This system is designed for brokers using **standard US trading time
> (GMT+2 / GMT+3)**, which is the most common server time used by major brokers
> worldwide."*

### 6.2 Cosa dice il venditore ai clienti, verbatim
- **Commento #20 (03/11/2025)**, a un cliente su broker GMT+0:
  > *"the EA is **optimised for GMT+2**, so if your broker/server runs on GMT,
  > you'll need to **shift all time inputs 2 hours earlier**… **Just subtract 2
  > hours from every time input** (range start, end, and trade close)."*
- **Commento #21**, lo stesso giorno: *"The important thing is that if your
  broker is using gmt+2/3, then **you don't have to adjust anything**."*
- E sul prodotto gemello, **commento #63 (13/02/2026)**, a un cliente tedesco
  che chiede *"The broker has a **GMT+1 server, not GMT+2** — is that a problem?"*:
  > 🔴 *"Yes the broker **has to be GMT+2/3 or it will not take correct trades**."*

### 6.3 🧮 Il conto per BCM, in ora server
**Regola di casa**: ora server BCM = ora italiana − 1. Oggi (agosto 2026) l'Italia
e' CEST = UTC+2 → **BCM = UTC+1 = GMT+1**. Il broker di riferimento del
venditore, che segue l'ora legale USA, oggi e' **GMT+3**.

> ### 🚨 **Lo scarto e' di DUE ORE, ed e' [VERIFICATO] su entrambi i lati.**
> **BCM e' esattamente il caso che il venditore dichiara NON supportato.**

Le due letture possibili, entrambe scritte perche' onestamente non so quale
usi il codice:

| | lettura (a): il `.set` e' letterale GMT+2 → **−1h** | lettura (b): il `.set` segue l'orologio del broker, oggi GMT+3 → **−2h** |
|---|---|---|
| XAUUSD range | 01:30 → 05:30 server BCM | 00:30 → 04:30 server BCM |
| XAUUSD ultimo ingresso / flat | 15:00 / **18:00** | 14:00 / **17:00** |
| USDJPY range | 00:00 → 05:00 | **23:00** → 04:00 |
| BTCUSD range | **23:00** → 05:00 | **22:00** → 04:00 |
| BTCUSD flat | 19:00 | 18:00 |

### 6.4 🔴 E qui c'e' una collisione operativa CONCRETA col nostro Guardian
Il preset firmato `ABTG_Guardian_FTMO_2Step.set` ha **`InpDailyResetHour=23`**
(= mezzanotte CET, l'ora a cui FTMO dichiara di azzerare il contatore).

> **Il range di BTCUSD (e, nella lettura b, anche quello di USDJPY) si
> FORMEREBBE A CAVALLO DELLE 23:00 SERVER**, cioe' **a cavallo del cambio di
> giornata prop.** Un range che inizia nel giorno prop N e produce un ingresso
> nel giorno prop N+1: la contabilita' giornaliera del Guardian e quella
> dell'EA **guarderebbero due giornate diverse**.
> Non e' un difetto del prodotto: e' un **fatto di incompatibilita' fra il suo
> orologio e il nostro**. E da solo basta a fermare qualunque prova su BCM
> prima di aver risolto il fuso.

---

## 7. 📈 IL TRACK RECORD — l'unico dei cinque prodotti esterni che ne ha uno

### 7.1 Il signal ufficiale: **Range Breakout EA Live** (`/signals/2271995`)
**[VERIFICATO 22/08 — statistiche MQL5, non del venditore]**

| voce | valore |
|---|---|
| Growth | **319,51%** ("growth since 2024") |
| Profit | 2.591,31 USD · Equity 3.667,40 USD |
| Initial Deposit | **1.000 USD** · Depositi **1.578,52** · Prelievi **1.502,43** |
| Broker / leva | **ICMarketsSC-MT5-2** · **1:500** |
| Settimane | **92** · giorni di vita del signal **640** · giorni operativi 455 (71%) |
| Operazioni | **1.876** (996 long / 880 short) · **17/settimana** |
| Vincenti | **788 (42,00%)** · Perdenti 1.088 (58,00%) |
| Profit Factor | **1,17** · Expected payoff **1,38 USD** |
| **Sharpe Ratio** | 🔴 **0,05** |
| Media vinta / persa | +23,09 / −14,34 USD |
| Miglior / peggior trade | +238,95 / **−141,93 USD** |
| Max perdite consecutive | 🔴 **17** (−169,89) · max perdita consecutiva −249,62 (12) |
| **Drawdown max sul saldo** | 🔴 **512,56 USD = 25,53%** |
| Drawdown relativo | 🔴 **28,29% sul saldo** · 8,96% sull'equity |
| Max deposit load | 10,55% |
| **Subscribers** | **1** |
| Distribuzione | USDJPY 558 · US30 361 · DE40 343 · BTCUSD 332 · XAUUSD 282 |

### 7.2 🔴 L'avviso automatico di MQL5, sulla pagina del signal
Non e' mio, e non e' del venditore. **Lo scrive MQL5:**
> *"**80% of growth achieved within 10 days.** This comprises **1,56% of days**
> out of 640 days of the signal's entire lifetime."*

> 🎯 **Questa riga vale piu' di tutte le recensioni messe insieme.**
> Il "+290% Live Growth" della scheda **non e' una curva**: e' **dieci giorni**
> su 640. Con Sharpe 0,05, PF 1,17 e 42% di vincenti, il resto della vita del
> conto e' rumore. E' **precisamente** il profilo che la regola di casa
> (Emendamento §C, prova di regime) e' fatta per smascherare.

### 7.3 🧨 Il confronto con `METRO_PROP.md` — e qui finisce il discorso

| metro | **casa nostra** | **Range Breakout EA (suo signal)** | verdetto |
|---|---|---|---|
| muro totale | **10% statico** | **DD max 25,53% sul saldo** | 🔴 **2,5× il muro** |
| muro giornaliero | **5%** (Guardian: pausa 4,0 / emergenza 4,9) | non misurabile dal signal | ⚫ |
| rischio per trade | **0,65%** | **1,0%** nel `.set` | 🔴 **+54%** |
| peggior giornata misurata | **−2,06% (R51)** | peggior trade −141,93 = **10× la perdita media** | 🔴 coda spessa |
| perdite consecutive | — | **17** | 🔴 a 0,65% farebbero **11,05%**: **oltre il muro totale** |

> ### ⚫ **Il verdetto numerico e' secco: il signal del venditore avrebbe
> ### fallito una challenge FTMO da 10% due volte e mezza.**
> E questo **al SUO rischio** (che nel `.set` e' 1,0%), non al nostro.

### 7.4 ⚠️ Due anomalie del signal che vanno scritte
1. **Depositi e prelievi**: 1.578,52 di depositi e 1.502,43 di prelievi su
   1.000 iniziali. La "crescita %" di MQL5 tiene conto dei versamenti, ma un
   conto **ricapitalizzato e prelevato in continuazione** e' un conto la cui
   curva **non e' leggibile** come quella di un conto fermo. **[VERIFICATO]**
2. **Data di inizio incoerente**: la pagina dichiara *"Started: **2026.01.01**"*
   ma anche *"**Weeks: 92**"* e *"640 days of the signal's entire lifetime"*
   (= inizio novembre 2024, coerente col *"22 Months Live Signal"* della
   scheda). **[INCERTO]**: non so quale dei due campi sia quello giusto; li
   riporto entrambi senza scegliere.

### 7.5 🔴 DUE SIGNAL DEL VENDITORE SONO STATI CANCELLATI
**[VERIFICATO 22/08 — HTTP 200 con il messaggio di MQL5 "The signal you
requested has probably been deleted"]**
- **`/signals/2290544`** — il **"V2 Signal"** che il cliente NN chiedeva di
  replicare nel commento #26 (24/11/2025): **cancellato**.
- **`/signals/2339929`** — quello che il venditore aveva postato come **prova
  live di Prop Firm Gold EA** il 31/10/2025 (commento #5 di quel prodotto):
  **cancellato**.

> ⚠️ **Non e' prova di malafede** — si cancella un signal anche per chiudere un
> conto o cambiare broker. **Ma e' un fatto**: due dei riferimenti che il
> venditore ha usato per vendere **oggi non sono piu' verificabili da nessuno**,
> e i signal vivi partono tutti **dopo** quella data. **Chi valuta oggi non puo'
> ricostruire la storia che gli e' stata mostrata allora.**

---

## 8. 🧱 TABELLA DEI BUCHI — cosa ha lui che a noi manca

Confronto contro `ABTG_Guardian.mq5` (letto oggi, v1.11, righe 50-70) e contro
gli input dei nostri EA.

| meccanismo | **noi** | **Range Breakout EA** |
|---|---|---|
| cap perdita giornaliera su **equity vs saldo di inizio giornata** | ✅ Guardian: emergenza 4,9%, pausa 4,0% (`dayStart−eq`, riga 366) | ✅ Daily Drawdown Protector (stessa identica formula, §PFG) |
| DD totale | ✅ 9,9% statico (+ `InpDDMode=1` trailing, mai misurato) | ❌ **assente** |
| cap rischio APERTO simultaneo | ✅ **C1 3,25%** | ❌ **assente** — 5 mercati in parallelo |
| chiude posizioni di **qualsiasi magic** | ✅ `InpCloseAllMagics` | ❌ solo le sue |
| **filtro "ieri e' stato troppo mosso"** | ❌ **BUCO** | ✅ `InpYesterdayRangeFilter` max 0,81 / 0,70 |
| **uscita a TEMPO invece che a target** | ❌ **BUCO** | ✅ `InpTradeCloseHour` 19:00/20:00 |
| **flat serale / niente overnight** | ❌ **BUCO** (gia' segnato ieri) | ✅ sempre |
| **niente weekend** | 🟠 non uniforme | ✅ `LastTradingDay=5` |
| **tetto operazioni al giorno** | ❌ **BUCO** (gia' segnato ieri) | ✅ 1-2/giorno per simbolo |
| **guardia spread** | 🟠 da verificare EA per EA | ✅ dalla v4.50 |
| **randomizzatore anti-impronta** | ❌ | ✅ ingressi/uscite/SL (⚠️ vedi referto PFG §6 — **dual-use**) |
| filtro news | 🟠 `InpUseNewsFilter` sui nostri EA | ❌ **assente** |
| stop dopo N perdite di fila | ❌ **BUCO** | ❌ **assente** (e ne ha fatte **17** di fila) |
| rischio ridotto in alta volatilita' | ❌ **BUCO** | 🟠 solo indirettamente (filtro di ieri) |
| parametri ispezionabili | ✅ tutti i nostri | 🔴 **CHIUSI dalla v2.10** |

> ### 🎯 **Sui MURI siamo avanti noi. Sul PIANO DI SOTTO e' avanti lui.**
> I tre meccanismi che ci mancano davvero e che lui ha **misurati e in
> produzione da 22 mesi** sono: **uscita a tempo**, **flat serale/venerdi'**,
> **filtro sul range di ieri**. Sono tutti e tre **riscrivibili da noi in un
> pomeriggio**, e nessuno dei tre richiede di comprare niente.

---

## 9. ⚖️ RACCOMANDAZIONE ONESTA

### 🔴 **SI SCARTA COME EA. SI TIENE COME FONTE DI CONFIGURAZIONE.**
### Non e' una bocciatura del prodotto: e' un "non e' per noi", e i motivi sono tre fatti, non tre impressioni.

**1. 🌍 Il fuso lo esclude, e lo dice l'autore.** *"Yes the broker **has to be
GMT+2/3 or it will not take correct trades**"* (commento #63). **BCM oggi e'
GMT+1: scarto di 2 ore.** E dalla v2.10 **gli input sono chiusi**, quindi non
si puo' nemmeno spostare l'orologio a mano come faceva il cliente del commento
#20 col vecchio `.set`. In piu' il range di BTCUSD/USDJPY cadrebbe **a cavallo
delle 23:00 server**, cioe' del reset giornaliero del nostro Guardian (§6.4).

**2. 📉 Il suo track record non passa il nostro metro.** DD massimo **25,53%**
contro il muro del **10%**; **17 perdite consecutive**; **Sharpe 0,05**; e
l'avviso automatico di MQL5 — *"**80% of growth achieved within 10 days**"* su
640 — che riduce il "+290%" a **dieci giornate fortunate**. Non c'e'
configurazione di rischio che aggiusti un drawdown gia' accaduto: la regola B
dell'Emendamento e' esplicita, **il drawdown e' un fatto, non una stima**.

**3. 🔒 Non e' misurabile col nostro imbuto.** I parametri del motore sono
**chiusi dalla v2.10** e le "inputs ottimizzate" sono state ri-tarate **quattro
volte** in dieci mesi, l'ultima dichiaratamente *"using data from the latest
market environment"*. **Un motore che cambia taratura ogni tre mesi non ha una
superficie IS/OOS da leggere**: non c'e' altopiano, non c'e' centro, non c'e'
round. E senza sorgente non lo sapremo mai.

**Cosa NON e' un motivo di scarto, e va detto per correttezza:**
- ✅ **Non c'e' griglia ne' martingala.** Ho cercato: nessun moltiplicatore di
  lotto, nessun layer di recovery, nessun basket nel `.set`, **nessuna voce
  del changelog** che li nomini, e il rapporto **42% di vincenti con perdita
  media (14,34) inferiore alla vinta media (23,09)** e' **incompatibile** con
  un motore a recupero. **Il gradino 2 del cancello acquisti lo passa.**
  E' il primo dei cinque prodotti esterni di cui posso dirlo con dati alla mano.
- ✅ **Il venditore non e' un fantasma**: 13 signals pubblici, 2 anni di
  changelog, risposte pubbliche anche alle critiche. Rispetto ad Artemis
  (0 signals, 19 prodotti in 77 giorni) e' un altro pianeta.
- ✅ **Ammette cose contro il proprio interesse**: il trailing che non funziona
  (#20), il bug dei lotti sulle prop (risposta a Oly.FX), *"you will for sure
  find something that works. **Just be careful to not over-optimize too much**"* (#5).

### 💰 E il CANCELLO ACQUISTI?
**Non arriva al gradino 3.** Costa **649 USD**, non ha noleggio, e la demo
Market — che pure girerebbe **gratis** nel tester — **misurerebbe un motore
sul fuso sbagliato con i parametri chiusi**. Sarebbe un numero senza
significato. **Nessuna proposta d'acquisto.**

---

## 10. 📋 LE PROPOSTE — cosa ci portiamo a casa (NON applicate, decide Claudio)

| # | proposta | dove | fonte | costo | rischio |
|---|---|---|---|---|---|
| **P1** | **Filtro "IERI E' STATO TROPPO MOSSO"**: salta la giornata se il range/ATR del giorno precedente supera una soglia | input nuovo negli EA di apertura | `.set` XAUUSD max **0,81**, USDJPY max **0,70** (§2.2, §5.1) | ~2h + 1 round (1 asse) | e' un **filtro appiccicato** finche' non ha un round suo: entra solo misurato |
| **P2** | **USCITA A TEMPO** invece che a target: chiusura a orario fisso, in ora server BCM | input nuovo negli EA intraday | `InpTradeCloseHour` 19:00/20:00 (§5.1) | ~2h + 1 asse | chiusura forzata su spread largo → serve la guardia spread |
| **P3** | **FLAT SERALE + FLAT VENERDI'** su tutto il conto | `ABTG_Guardian` (la funzione "chiudi tutto" c'e' gia') | §5.1 + Prop Guard Pro (dossier di ieri) | ~2h | idem P2; **gia' proposto ieri come P3, questo e' un secondo riscontro indipendente** |
| **P4** | **Tetto operazioni/giorno per simbolo** (lui: 1, al massimo 2) | Guardian o EA | `InpTwoTradesPerDay` (§5.1) | ~1h | blocca un ingresso buono dopo una giornata movimentata |
| **P5** | **Verificare che i nostri EA di notte non attraversino le 23:00 server** (reset prop del Guardian) | controllo, non codice | §6.4 | ~1h di lettura | 🔵 **e' un CONTROLLO, non una modifica: costo quasi zero, e potrebbe scoprire un problema che abbiamo gia'** |

🔴 **Nessuna di queste si applica da sola.** Vanno in coda all'imbuto come
qualunque modifica; gli `_Ottimizzato` girano in parallelo, mai sostituiti.

---

## 11. 👤 IL VENDITORE, VISTO ATTRAVERSO I SUOI DUE PRODOTTI

_(sezione condivisa con `report/PROPFIRM_GOLD_ERIKSSON_2026-08-21.md`)_

### 11.1 I numeri del profilo
**[VERIFICATO 22/08, `mql5.com/en/users/jimmy282/seller`]**
Jimmy Peter Eriksson · **Australia** · reputazione **8.619** ·
**4,4 stelle su 146 recensioni** a livello venditore · **7 prodotti** ·
🔵 **13 signals** · 1 commento · sito proprio **erikssonsystems.com** ·
esperienza dichiarata: *"over 5 years of trading and system development"* ·
dichiarazione di metodo: *"**no martingale, no grid systems, and no hidden
risk mechanics**"*.

> 🔵 **I 13 signals sono la differenza piu' importante rispetto ai tre venditori
> di stanotte.** Artemis: 0 signals, 0 subscribers. Yudi Warsito: 0 signals,
> 0 subscribers. **Qui c'e' materiale verificabile da terzi.** Che poi quel
> materiale lo bocci e' un altro discorso — ma **e' verificabile**, e questo,
> per il nostro metro, e' il minimo sindacale che i primi tre non avevano.

### 11.2 Il catalogo completo — 7 prodotti, non 19 in 77 giorni

| prodotto | prezzo | rating | note |
|---|---|---|---|
| Pulse Engine | 599 USD | 4,08 (37) | *"does not use any indicators or specific timeframes"* |
| **Range Breakout EA with Range Filters** | **649 USD** | **4,55 (22)** | pubblicato 25/08/2024 |
| Gold Atlas | 449 USD | 4,61 (23) | *"multi-breakout system for Gold"* |
| Market Anomalies EA | 349 USD | 4,71 (17) | **solo USDJPY** |
| **Prop Firm Gold EA** | **399 USD** | **4,56 (32)** | pubblicato 29/10/2025 |
| The Bitcoin Core | 349 USD | 4,85 (13) | **solo BTC** |
| EA Portfolio Analyzer | 49 USD | 4 (1) | utility |

📌 **Il ritmo e' sostenibile**: 7 prodotti, il piu' vecchio di 2 anni. **Non e'
una fabbrica.** Confronto diretto: Artemis = **19 prodotti in 77 giorni**.

### 11.3 🔴 MA i motori si somigliano, e lo dicono i suoi stessi clienti
Questa e' la domanda del mandato ("se sono varianti minime dello stesso motore
ri-taroccato, va detto"). **La risposta e' SI, e non e' un sospetto mio.**

**Prova 1 — un cliente, sulla scheda di Range Breakout (bi mo, 02/05/2026):**
> *"Great system… but **Be mindful that some strategies have high correlation
> with other EAs from the author.**"*

**Prova 2 — le due schede si sovrappongono nel testo:**

| | Range Breakout | Prop Firm Gold |
|---|---|---|
| *"not based on indicators or fixed timeframes"* | ✅ | ✅ (identico) |
| *"No Martingale / No Grid"* | ✅ | ✅ |
| *"Daily drawdown protector (prop firm friendly, e.g. FTMO)"* | ✅ | ✅ (identico) |
| *"Built-in trade randomizer (prop firm friendly)"* | ✅ | ✅ (identico) |
| *"brokers using standard US trading time (GMT+2/GMT+3)"* | ✅ | ✅ (**paragrafo identico parola per parola**) |
| *"Warning"* sui buzzword AI/ICT/SMC | ✅ | ✅ (**identico parola per parola**) |
| risk level Low / Medium / High | ✅ | ✅ |
| uscita a tempo, mai overnight | ✅ | ✅ |
| XAUUSD tra i mercati | ✅ | ✅ (**e' l'unico di PFG**) |

**Prova 3 — il venditore stesso, commento #20 di Prop Firm Gold (11/11/2025)**,
a chi chiedeva la differenza fra i due:
> *"The Prop Firm EA uses **multiple strategies inside the same EA**.
> RangeBreakout is **just one strategy**, but it works for 3 markets."*

> ### 🎯 **Traduzione col nostro vocabolario: e' UNA CASA con UN telaio.**
> Uscita a tempo, niente indicatori, niente TF, rischio Low/Medium/High,
> randomizzatore, drawdown protector, GMT+2/3, XAUUSD al centro. **Range
> Breakout = un motore su 5 mercati. Prop Firm Gold = piu' motori su 1
> mercato.** Comprarli entrambi **non e' diversificare**: e' **concentrare**.
> E questo e' esattamente il difetto che il progetto ha imparato a temere con
> i 5 blocchi "diversi" di Master Nasdaq (§3.2 del dossier di ieri) — con la
> differenza che **qui un cliente lo ha scritto in una recensione a 5 stelle**.

### 11.4 🎭 Il tono con i clienti scontenti — un dato, non un giudizio
Ho letto **115 commenti** (33 + 82) e **40 recensioni** fra i due prodotti.
Lo schema di risposta e' **sempre lo stesso**, ed e' un dato caratteriale utile:
1. *"due settimane sono troppo poche per giudicare"*;
2. il numero aggregato del proprio signal contrapposto al conto del cliente;
3. *"se vuoi vincere ogni giorno, comprati un martingala"*.

Casi in cui e' **corretto** (un cliente che molla dopo 3 giorni ha torto) e casi
in cui e' **una scorciatoia** — Oly.FX aveva **14 mesi** di uso e un **bug dei
lotti dimostrato con screenshot**, e la risposta e' stata il silenzio prima e
la spiegazione tecnica dopo la recensione a 3 stelle. E su Prop Firm Gold, a un
cliente che chiedeva il rimborso dopo aver perso un conto funded da 200k, la
risposta e' stata: *"That is less than 5% drawdown, which is completely normal
for this system… **MQL5 does not offer refunds**"* (§5 del referto PFG).

### 11.5 ⚠️ I suoi EA sono PIRATATI su almeno tre siti di "group buy"
**[VERIFICATO 22/08 via ricerca]**: `eafxstore.com`, `ecomforex.com`,
`simpleforextools.com` rivendono/regalano entrambi i prodotti.

> 🔴 **Perche' ci riguarda, e non e' un problema morale**: significa che un
> numero **ignoto e non controllabile** di conti gira **lo stesso EA** — ed e'
> esattamente il motivo per cui esiste il randomizzatore. **Su una prop, "molti
> conti che fanno gli stessi trade" e' la definizione operativa di copy
> trading**, che quasi tutte vietano. Chi compra questo EA per una challenge
> compra **anche il comportamento di tutti i pirati che lo usano**. Regola D3
> di casa (chiedere per iscritto alla prop prima di comprare una challenge):
> **si applica in pieno**.

---

## 12. 🗂️ ELENCO DELLE PAGINE APERTE (per chi verra' dopo)

| URL | cosa ci ho preso |
|---|---|
| `mql5.com/en/market/product/122237` | scheda integrale, prezzo 649, v5.10, schema.org (rating 4,5454/22, 20 voti nominali) |
| `mql5.com/en/market/product/122237/comments` (+ `/page2`) | **33 commenti verbatim** — fuso GMT+2, `.set`, bug buy&sell, TimYeh |
| `mql5.com/en/market/product/122237/updates` | **changelog completo, 25 versioni** |
| `c.mql5.com/31/1588/RangeBreakout_EA_XAUUSD.set` (+ USDJPY, BTCUSD) | 🔵 **i 3 preset ufficiali V2.00, scaricati e letti riga per riga** |
| `mql5.com/en/signals/2271995` | **Range Breakout EA Live**: 1.876 trade, DD 25,53%, Sharpe 0,05, avviso "80% in 10 days" |
| `mql5.com/en/signals/author/jimmy282` | i **13 signals** con crescita/DD/subscribers |
| `mql5.com/en/users/jimmy282/seller` | 7 prodotti coi prezzi, 4,4 (146), 13 signals |
| `mql5.com/en/signals/2290544` · `/2339929` | 🔴 **entrambi CANCELLATI** |
| `mql5.com/en/blogs/post/771906` | guida al backtest (1-min OHLC, ≥5 anni, One Chart Setup) |
| `mql5.com/en/market/product/87520` | verifica omonimo: e' di **BM Trading GmbH**, non suo |
| `www.trustpilot.com/review/erikssonsystems.com` | ❌ **bloccato dal proxy** — 4★/8 recensioni solo di seconda mano |
| `www.myfxbook.com/members/JimmyEriksson/...` | ❌ **bloccato dal proxy** — esiste, contenuto **[INCERTO]** |
