# ⚡ TRIAGE COMPARATIVO — **7 prop firm viste su Instagram** · 27/08/2026

_Mandato: Claudio ha visto una serie di pubblicita' sponsorizzate su Instagram e
chiede un vaglio. Sette dossier completi come `VAGLIO_FINTOKEI` /
`VAGLIO_KEYTOPROP` (stessa giornata) costerebbero troppo in un colpo solo:
**questo e' un TRIAGE, non un vaglio**. Obiettivo: **scartare in fretta chi ha
una bandiera rossa ELIMINATORIA evidente**, e dire su quali (se ce ne sono) vale
la pena spendere il tempo di un vaglio pieno._

> ⚠️ **Cosa NON e' questo file.** Non e' esaustivo, non ha le 5 domande al
> supporto, non ha la scheda prop completa. **Una prop scartata qui e' scartata
> su UNA riga eliminatoria verificata, non su un giudizio complessivo.** Una
> prop promossa qui **non e' approvata**: e' solo candidata a un vaglio vero.

**Nessun acquisto autorizzato da questo file.** Vale la regola D3: risposta
scritta del supporto prima di ogni euro, e decide Claudio.

🚫 **Fuori perimetro per decisione di Claudio: "SicuroProp"** (ottava
pubblicita' vista). **Non e' una prop firm**: e' un servizio TERZO che promette
di "sbloccare" un conto prop garantito in 7 giorni con pagamento posticipato,
usando come prova sociale lo screenshot di un conto FTMO da $2.000.000.
E' un'altra categoria — **far superare la challenge da terzi e' tipicamente
vietato dai ToS di ogni prop** (e' la clausola su cui si perde il conto DOPO
averlo pagato). **Scartata a vista da Claudio, non vagliata qui.**

---

## 0. 🎯 CONTROLLO POSITIVO E STATO DELLE FONTI — leggere PRIMA di tutto

Bersaglio a risposta nota: la pagina obiettivi FTMO **deve** restituire
5% giornaliero / 10% totale / reset mezzanotte CE(S)T.

| canale | bersaglio | esito | uso |
|---|---|---|---|
| **WebSearch** | FTMO trading objectives | ✅ restituisce **5% daily / 10% totale / reset 00:00 CE(S)T / daily = chiusi + flottante** = risposta nota **centrata** | 🟢 **UNICO CANALE VIVO** |
| **WebFetch** | `ftmo.com/en/trading-objectives/` | ❌ `EGRESS_BLOCKED` | 🛑 **NULLO** |
| **WebFetch** | `en.wikipedia.org/wiki/Proprietary_trading` (controllo **neutro** di sanita') | ❌ `EGRESS_BLOCKED` | 🛑 **NULLO — il blocco e' TOTALE, non anti-prop** |

### 🏷️ L'ETICHETTA CHE VALE PER OGNI RIGA DI QUESTO FILE

> 🟡 **`[LETTO-VIA-SEARCH 27/08/2026]`** — stessa convenzione di
> `VAGLIO_KEYTOPROP_2026-08-27.md` e `DOSSIER_PROP_CANDIDATE_2026-08-26.md`.
> **Non ho aperto con i miei occhi una sola pagina di queste sette prop.** Il
> contenuto arriva dal canale di ricerca, che ha letto e riassunto le pagine
> indicate negli URL. La SOSTANZA e' affidabile, **ma non ho la citazione
> letterale**. Dove il numero non e' comparso scrivo **NON DICHIARATO** o
> **[INCERTO]** — mai una deduzione travestita da fatto.

🔴 **Regola anti-eco applicata anche oggi** (imparata stamattina su KeyToProp):
quando ho interrogato il canale con una domanda che conteneva gia' dei numeri,
ho **scartato** le risposte che si limitavano a restituirmeli. Ogni cifra qui
sotto e' comparsa in una lettura **che non gliel'aveva suggerita**, oppure e'
etichettata come terza parte.

---

## 1. 📏 IL METRO DI CASA — contro cui si giudica (invariato dal 26-27/08)

Fonti interne: `ANALISI_DD_TOTALE_2026-08-26.md`, `report/METRO_PROP.md`,
`FIRME_2026-08-18.md`, `DOSSIER_PROP_CANDIDATE_2026-08-26.md`.

| voce | numero di casa |
|---|---|
| flotta | **35 sedie vive** su **MT5**, sorgenti posseduti |
| filtro news | 🔴 **NESSUNO** — gli EA tradano dentro le notizie |
| overnight / weekend | 🔴 **TENUTI** |
| lati | **due** (long e short) |
| rischio per trade | **0,65%** |
| cap rischio **APERTO** firmato (C1) | **3,25%** — 🔴 **misurato realmente fino a 5,85%** |
| peggior giornata CHIUSA | **−4,74%** (25/05/26) a dial 1,00 |
| DD totale misurato (picco-valle, chiusi) | **−6,37%** su 481 giorni |
| Monte Carlo p99 (DD **statico**) | **~8,1%** |
| 🧱 **muri necessari** | **daily 5% / totale 10%, ENTRAMBI STATICI** |
| 🔴 sul trailing | `ANALISI_DD_TOTALE` §4: un totale **trailing 6% si rompe PERSINO sui chiusi** (6,37% > 6%) — **"Muri statici o niente"** |
| leva indici | **1:15 = margine che morde · 1:25 respira** |
| payout | 🔴 niente cap stile $3k/ciclo · niente consistency che congeli 35 sedie |

### 🔪 Le quattro lame che tagliano piu' in fretta

Sono i quattro test che, da soli, chiudono la partita. Li applico in quest'ordine:

1. 🧱 **Muro TOTALE trailing?** → eliminatorio automatico (precedenti: **KeyToProp,
   Upcomers, E8** bocciate il 26-27/08 su questa identica voce).
2. 🧱 **Muro totale < 10% o daily < 5%?** → il nostro **−4,74%** peggior giorno e
   il nostro **−6,37%** picco-valle non ci stanno dentro.
3. 🤖 **EA vietati?** → eliminatorio, non c'e' niente da discutere.
4. 💧 **Cap sulla perdita FLOTTANTE aperta?** → il cap firmato in casa e' **3,25%**
   ma la misura reale e' arrivata a **5,85%**: un tetto sotto quella soglia ci
   squalifica per costruzione.

---

## 2. 🔥 LA TABELLA CHE DECIDE — 7 prop, 4 lame, 1 verdetto

| # | prop | 🧱 **muro TOTALE** | 🧱 **daily** | 🤖 **EA** | 💧 **cap flottante** | 💸 split / payout | ⭐ reputazione ed eta' | 🏁 **VERDETTO** |
|---|---|---|---|---|---|---|---|---|
| 1 | **FTUK** (ftuk.com) · **2 prodotti** | 🔴🔴 **6% TRAILING** su **entrambi** (Instant "relativo" · Flex/4% trailing **che si blocca al balance iniziale**) | 🟢 **5%** su entrambi | 🟢 permessi | 🔴🔴 **2% "Account Protector"** (Instant) | 80% (pubblicita' dice 90%) · payout settimanali/24h | 🟠 **Trustpilot 4,0 · ~580 rec.** · reclami: _"payout rejected per regole nascoste mai comunicate"_ | ❌ **SCARTA SUBITO** |
| 2 | **uzo** (uzo.com) | 🔴 **8% assoluto/statico** (2-step) · 🔴 **6% TRAILING** su "Instant Pro" | 🔴 **NON DICHIARATO** (2-step) · 4% su Instant Pro | 🟢🟢 **permessi, dichiarati senza restrizioni** | 🔴 non dichiarato | 🟢 **90% fisso** a ogni taglia · reward in ~12h | 🔴 **azienda del 2026** (mesi) · Trustpilot senza voto recuperabile · **zero storia** | ❌ **SCARTA SUBITO** (rientro possibile, §3.2) |
| 3 | **PTB** (plutustradebase.com) | 🔴🔴 **4% TRAILING sul picco di EQUITY** (funded da Lightning) · Instant **10% trailing** → 5% statico dopo +5% | 🟠 5% sui funded "statici" | 🟢 permessi (con audit della config) | 🔴 non dichiarato | fino a **95%** · same-day, no minimo | 🔴🔴 **payout NEGATI** per termini vaghi (_"Toxic Gambler behavior"_) · **$99.334 trattenuti** dopo via libera scritta · fondata 09/2024 | ❌ **SCARTA SUBITO** |
| 4 | **RebelsFunding** (rebelsfunding.com) | 🟢🟢 **STATICO** (dall'equity iniziale, **non** high-watermark) | 🟢 statico, snapshot giornaliero | 🔴🔴 **VIETATI** — _"Expert Advisors… not supported on paid Evaluation or RCF Accounts"_ | — | — | 🟠 Trustpilot ~4,3 · account IG verificato | ❌ **SCARTA SUBITO** |
| 5 | **FXP** (thefxp.com) | 🔴 **6%** (1-step e 2-step) | 🔴🔴 **3%** | 🟢 permessi in funded | 🔴 non dichiarato | fino a 100% · payout in 3 giorni · 🟢 **no consistency rules** | 🔴🔴 _"fake firm, total scam"_ · **5 payout negati senza motivo**, utente espulso dal Discord · 🟠 auto-dichiara **150K+ utenti / $10,6M payout** | ❌ **SCARTA SUBITO** |
| 6 | **Eleonex** (eleonex.com) | 🔴 **TRAILING** sul prodotto PUBBLICIZZATO (Ignite instant, ~6%) · 🟡 **esiste linea STATICA** (Forge Core/Flex/Prime) | 🔴 **NON DICHIARATO** in cifre | 🔴 **NON DICHIARATO** | 🔴 non dichiarato | 80/20 in pubblicita' · fino a 90% dichiarato altrove · bi-weekly / on-demand | 🔴🔴 **nata ad APRILE 2026** · _"un singolo payout notevole ($27k) in tutta la sua storia operativa"_ | ❌ **SCARTA SUBITO** (il prodotto in pubblicita') · linea Forge = 🟡 **DATI INSUFFICIENTI** |
| 7 | **Leveraged** (getleveraged.com) | 🔴🔴 **6% TRAILING** (Turbo) · **1% statico** (Sprint) · 6% (Crypto) | 🔴🔴 **3%** (Turbo e Crypto) · **1%** (Sprint) | 🔴 **NON DICHIARATO** | 🔴 non dichiarato | **80%** · primo payout a 14 gg, poi bi-settimanale | 🔴 **~1.000 rec. Trustpilot, ~80 da 1 stella** · payout negati per _"material inconsistencies"_ **senza prove** · articolo terzo _"7 Warnings"_ | ❌ **SCARTA SUBITO** |

### 📊 Il conto secco

> **7 prop viste · 7 scartate · 0 promosse a vaglio completo.**
> **Nessuna** delle sette supera le quattro lame. **Sei su sette** cadono su una
> bandiera rossa **eliminatoria e verificata**, non su un dubbio.
>
> 🔴 **Nemmeno UNA delle sette offre da nessuna parte la coppia che ci serve:
> daily 5% STATICO + totale 10% STATICO.** Il massimo trovato in tutto il
> gruppo e' l'**8% statico** di uzo — sotto la nostra p99.

---

## 3. 🩸 PERCHE' — una riga eliminatoria per ciascuna

### 3.1 🥇 FTUK — **due prodotti, un solo muro: 6%**

FTUK e' l'unica del gruppo con una reputazione **decente** (Trustpilot 4,0 su
~580 recensioni, molti payout confermati). **E' comunque quella che ci taglia
piu' netto.** Claudio ha visto **due pubblicita' diverse della stessa azienda**,
e la cosa piu' utile che ho trovato e' che **portano allo stesso muro**.

#### I due prodotti, affiancati

| | **A. "No Evaluation" / Instant Funding** (1ª pubblicita', "From $9") | **B. "4% Challenge" / Flex** (2ª pubblicita') |
|---|---|---|
| target di profitto | 🟢 **nessuno** | 🟢🟢 **4%** — _"the lowest profit target in prop trading"_ contro l'8-10% standard |
| 🧱 **muro totale** | 🔴 **6% "relative"/trailing** | 🔴 **6% trailing, che si BLOCCA al balance iniziale** una volta raggiunto quel livello |
| 🧱 **daily** | 🔴 **5%** | 🔴 **5%** |
| 💧 **cap flottante** | 🔴🔴 **2% "Account Protector"** | 🟠 **non dichiarato per la Flex** |
| durata / giorni minimi | nessun minimo | 🟢 periodo **illimitato**, **1 solo giorno** minimo |
| stop loss | — | 🟢 _"Manage risk your way **without forced stop-loss constraints**"_ |
| altro | 🔴 **no partial closing**, consistenza "level-based" | — |

> 🎯 **La risposta alla domanda del mandato ("il target basso del 4% nasconde un
> muro piu' stretto in cambio?").**
> **NO — e la risposta vera e' peggiore.** Il muro della 4% Challenge **non e'
> piu' stretto di quello del loro instant funding: e' IDENTICO** (5% daily / 6%
> totale). Non c'e' nessun baratto. **Il punto e' che TUTTA la linea di prodotti
> FTUK e' costruita su un muro del 6%**, contro il 10% statico di una challenge
> normale. Il target al 4% non e' generosita': **e' la contropartita coerente di
> un muro che vale poco piu' della meta' dello standard.** Chiedono meno perche'
> ti danno meno spazio per sbagliare.
>
> 🟡 **Una nota di equita', che va detta:** il trailing della Flex **si blocca al
> balance iniziale** una volta arrivato li'. Meccanicamente **e' molto meglio**
> del trailing perpetuo su picco di equity che ha affossato KeyToProp: dopo il
> lock diventa di fatto un muro statico. 🔴 **Non basta lo stesso**, e per un
> motivo aritmetico e non filosofico: **il muro vale 6%, e il nostro picco-valle
> misurato e' 6,37% sui SOLI chiusi.** Si rompe sullo storico prima ancora di
> cominciare — e si rompe **durante** la fase in cui il trailing e' ancora vivo,
> cioe' prima che il lock possa salvarci.

#### 🔴 La contraddizione da segnalare, ed e' loro

La pubblicita' B dice testualmente **"No consistency rules. No artificial
throttling."** Ma la lettura delle regole (`tradingfinder`, `h2tfunding`) dice
che **_"Consistency conditions affect Instant and Flex payouts"_** — e la Flex
e' esattamente il prodotto pubblicizzato.

> 🔴 **Il marketing dice una cosa, le regole ne dicono un'altra, sullo stesso
> prodotto.** Non ho potuto aprire la pagina ufficiale per dirimere
> (**[INCERTO]**), ma questa e' precisamente la forma che prendono i reclami
> Trustpilot su FTUK: _"payout requests rejected due to specific rules that felt
> hidden and were never clearly communicated"_. **Una regola che compare solo al
> payout e' peggio di una regola stretta scritta in chiaro.**

#### Il conto contro il metro di casa

| regola FTUK | numero di casa | esito |
|---|---|---|
| **6% total drawdown trailing** (entrambi i prodotti) | picco-valle misurato **6,37% sui soli CHIUSI** | 🔴 **si rompe gia' sullo storico** |
| 🔴🔴 **2% massima perdita FLOTTANTE** (Instant) | cap aperto firmato **3,25%**, **misurato fino a 5,85%** | 🔴🔴 **quasi 3 volte il tetto — sfondato di routine** |
| **no partial closing** + consistenza "level-based" | sedie con uscite parziali, 35 frequenze diverse | 🔴 violazione per costruzione |

> 🎯 **La risposta all'altra domanda del mandato ("come funziona il No Evaluation
> a $9, e che rischio si prende la firm?").**
> **La firm non si prende nessun rischio: se lo fa pagare col muro.** Salti la
> valutazione, e in cambio ti danno **6% trailing invece del 10% statico**, piu'
> un **guinzaglio sul flottante al 2%** che chiude le posizioni molto prima che
> il muro vero venga sfiorato. Il "no profit target / no minimum days" e'
> autentico; il costo e' che **il margine di errore e' poco piu' di meta' del
> normale, e si stringe ogni volta che guadagni**.
> 🟠 **Nota onesta:** il "$9" e il "90%" della pubblicita' **non li ho
> verificati** — le letture dicono **80%** di split. Restano **[INCERTO]**.
>
> 🟢 **Due cose buone di FTUK, per completezza:** **news trading permesso** e
> **weekend holding permesso** (dichiarati) — e sono due delle voci su cui e'
> caduta meta' del dossier del 26/08. **FTUK e' l'unica delle sette che le
> dichiara entrambe in verde.** Non basta contro un muro del 6%.

### 3.2 uzo — **il caso piu' interessante del gruppo, e comunque un no**

🟢 **Cosa ha di buono, e va detto perche' e' raro:**
- **EA permessi e dichiarati senza restrizioni** — _"allows users to run
  automated strategies with no restrictions"_. Su una flotta di 35 sedie questa
  e' la voce che di solito ci uccide, e qui e' verde.
- **90% di split fisso a ogni taglia**, senza scalini di anzianita'.
- **2-step con max loss ASSOLUTO** — _"a max loss that holds firm no matter how
  far you run"_: **statico, non trailing**. Passa la lama #1.
- nessun limite di tempo, reward pagati in ~12h.

🔴 **Perche' cade lo stesso:**

| lama | uzo | esito |
|---|---|---|
| muro totale ≥ 10% statico | **8% assoluto** (2-step) | 🔴 **sotto la nostra p99 di 8,1% (statico)** — margine **negativo** |
| daily ≥ 5% | 🔴 **NON DICHIARATO** sul 2-step | 🔴 buco su una voce eliminatoria |
| prodotto "Instant Pro" | **6% max TRAILING**, 4% daily | 🔴 eliminatorio, e **6% < 6,37% misurato** |
| storia verificabile | 🔴 **azienda del 2026**, ~40 persone, HQ Dubai + ufficio Praga | 🔴 **nessun payout track record recuperabile** |

> 🎯 **La riga che decide:** **8% statico contro una p99 di 8,1% statico.** Non
> e' un margine sottile: **e' un margine negativo**. E' l'unica delle sette dove
> il no arriva da un confronto aritmetico coi nostri numeri invece che da una
> bandiera rossa, ed e' per questo che merita la porta di rientro qui sotto.
>
> 🟠 **Anomalia [INCERTO]:** una delle interrogazioni ha restituito come "uzo" un
> dominio **`*.trycloudflare.com`** (tunnel temporaneo Cloudflare) col claim
> _"The market is simulated. The rewards are not."_. Puo' essere un mirror di
> sviluppo indicizzato per sbaglio — **non lo so e non lo interpreto**. Lo scrivo
> perche' un'azienda che serve pagine da un tunnel temporaneo si guarda.
>
> 🟠 **Conflitto di fonti sui target:** **6% + 4%** sul 2-step in una lettura,
> **3% + 3%** in un'altra, **5%** sul 1-step in una terza. **[INCERTO]** — a noi
> cambia poco (i target non ci mordono).

🚪 **PORTA DI RIENTRO uzo** — l'unica delle sette che ne merita una. Rientra come
**candidata a vaglio completo** se e solo se Claudio, aprendo
`uzo.com/challenges` **col suo browser**, verifica **tutte e tre**:
1. esiste un programma con **totale STATICO ≥ 10%** (non 8%);
2. il **daily e' ≥ 5%** ed e' calcolato su **balance iniziale**, non su equity;
3. gli **EA sono permessi anche in FUNDED** (la frase trovata non distingue).
Se anche una sola va storta → resta scartata.

### 3.3 PTB (Plutus Trade Base) — **due bandiere rosse indipendenti**

> 🎯 **La risposta alla domanda del mandato ("Flexible Rewards: e' payout o e'
> muro?").**
> **[VERIFICATO via search 27/08] — e' PAYOUT.** "Flexible Rewards" descrive la
> struttura di prelievo: _"withdraw profits on their own terms"_, same-day
> payout, **nessun minimo di payout**, split fino al 95%, pagamento anche via
> Rise. **Non e' il muro.** Il sospetto del mandato (linguaggio ambiguo alla
> KeyToProp) **e' infondato su QUESTA etichetta**.
>
> 🔴 **Ma il muro e' comunque trailing, e lo dicono altrove.** _"Dynamic
> Trailing drawdown limit set at **4% of the highest account equity**"_ sui
> funded ottenuti dalla Lightning; l'Instant Funding parte da **10% trailing** e
> diventa 5% statico solo dopo aver messo insieme +5% di profitto. Esiste una
> linea funded dichiarata **statica 5%/10%** — ma **la strada per arrivarci passa
> dal trailing**, e un 4% trailing su picco di equity contro un picco-valle
> misurato di 6,37% sui soli chiusi non e' una discussione.

🔴🔴 **E poi c'e' la seconda bandiera, che pesa piu' della prima**: recensioni con
**payout rifiutati su termini interni vaghi** — testuale: _"Toxic Gambler
behavior"_ e "concentrated trading" — con **nuovi requisiti comparsi sulla
dashboard DOPO il rifiuto**, e un caso di **$99.334,44 trattenuti** nonostante un
via libera scritto della direzione. Un rifiuto da $1.000 per "rischio eccessivo"
a un trader che dichiarava **1% per trade** — noi ne rischiamo 0,65% ma con **35
sedie in parallelo**, e "concentrated trading" e' esattamente la descrizione di
cosa fa una flotta quando piu' EA aprono sullo stesso simbolo.

🟠 Il **€59 per una "500.000 EVALUATION"**: le taglie fino a $500k **esistono
davvero** (_"up to $500,000 in simulated capital"_, e su TradeLocker Hub compare
un piano **500k 1-step a 379**). 🔴 **Il prezzo di €59 per quella taglia NON e'
confermato** — **[INCERTO]**, e il 379 va nella direzione opposta.

### 3.4 RebelsFunding — **muri buoni, ma gli EA sono vietati**

🟢 **Ironia del gruppo: e' l'unica con i MURI GIUSTI.** Due letture indipendenti
confermano **drawdown STATICO**: daily da snapshot dell'equity di inizio
giornata, **totale misurato sull'equity iniziale, esplicitamente NON un modello
high-watermark**. Passa la lama piu' dura, quella su cui sono cadute KeyToProp,
Upcomers ed E8.

🔴🔴 **E cade sulla lama #3, che non ha appello.** Dalla loro FAQ:
_"**Expert Advisors, automated trading robots and other systems that place or
manage trades automatically are not supported on paid Evaluation or RCF
Accounts.** Reasonable manual trading styles are allowed"_ — e altrove
_"manual trade execution"_, con Martingale e "aggressive scalping" nella stessa
lista di divieti. Confermato da una seconda fonte
(`tradingfinder.com/props/rebelsfunding/rules/`, titolata **"Hedging & EAs Not
Allowed"**).

> 🎯 **Non c'e' nessun vaglio da fare.** Una flotta di 35 EA su una prop che
> impone l'esecuzione manuale non e' una configurazione da ottimizzare: e' un
> prodotto che non ci riguarda. **Chiuso in una riga.**
>
> 🟠 Il codice **SUMMERSALE** _"until Thursday, August 27"_ scade **oggi** —
> irrilevante, visto il verdetto.

### 3.5 FXP — **la piu' pericolosa: numeri stretti E fama pessima**

Due bandiere, ciascuna sufficiente da sola:

| lama | FXP | numero di casa | esito |
|---|---|---|---|
| daily ≥ 5% | 🔴🔴 **3%** (sia 1-step che 2-step) | peggior giornata chiusa **−4,74%** | 🔴🔴 **la nostra peggior giornata sfonda il muro del 58%** |
| totale ≥ 10% | 🔴 **6%** | picco-valle **6,37%** sui chiusi | 🔴 **rotto dallo storico** |

E la reputazione: recensioni che scrivono **_"a fake firm and its a total
scam"_**, un utente che dichiara **5 richieste di payout negate senza motivo** e
di essere stato **espulso dal Discord** dopo aver aperto un ticket. Nessun
riferimento a un regolatore, nessun indirizzo fisico sulle pagine principali.

#### 🔢 Sul "Trusted by 150K+ users" e sui prezzi — il numero che si commenta da solo

**[dichiarato dal vendor, NON verificato]** — e' il titolo della loro stessa
home (_"FXP | The Prop Firm Chosen by 150K+ Traders"_), ripreso da una rassegna
terza che aggiunge una seconda cifra: **_"150K+ traders and over $10.6M in
payouts"_**.

> 🟠 **Aritmetica [INFERITO], e dico da cosa: dai loro DUE numeri.**
> $10.600.000 ÷ 150.000 utenti = **~$70 di payout per utente**, in tutta la
> storia dell'azienda. Nel frattempo i prezzi dichiarati sono **$62 per una 10k
> scontata** e **$292 per la 200k** (da $584, il "50% off" della pubblicita').
>
> 🔴 **Detto altrimenti: il payout medio per utente e' dell'ordine di UNA fee
> d'ingresso.** Non e' una prova di frode — **e' esattamente cosa ci si aspetta
> da un modello a challenge**, dove i piu' non passano. Ma smonta il "150K+
> users" come argomento di solidita': **150.000 utenti che hanno pagato e ~$10M
> restituiti in totale descrivono un'azienda che incassa fee, non una che paga
> trader.** Il numero grande in pubblicita' misura il MARKETING, non i payout.

> 🎯 **Il tag "NO CONSISTENCY RULES" e' vero e sarebbe stato il nostro punto piu'
> forte** — e' la clausola che ha bocciato KeyToProp e The5ers per una flotta a
> 35 sedie. **Non serve a niente se il daily e' al 3% e i payout non arrivano.**
> E' il promemoria piu' utile di questo triage: **una singola voce verde non
> compensa mai una lama rossa.**
>
> 🟠 **Cautela sull'identita' del marchio, [INCERTO]:** "FXP" e' un nome molto
> conteso (`fxprop.com`, `forexpropfirm.com`, `fxproptraders.in`). I numeri
> (3%/6%) vengono da una recensione che punta a **`thefxp.com`**, coerente con
> l'Instagram `thefxpfirm`. **Le recensioni "scam" potrebbero in parte riferirsi
> a un omonimo.** Non cambia il verdetto — **il 3% di daily basta da solo**.

### 3.6 Eleonex — **il prodotto in pubblicita' e' trailing, e l'azienda ha 4 mesi**

🔴 **Il prodotto pubblicizzato e' eliminatorio.** L'annuncio vende la linea
**Ignite** (instant funding), e la lettura dice: _"The Ignite program provides
immediate capital access with up to 80% profit split **and trailing drawdown**"_,
con un riferimento a **6% trailing** come tipico dell'instant funding contro il
10% delle valutazioni. 🔴 Stessa identica famiglia di FTUK e Leveraged: **salti
la valutazione, paghi col muro**.

🟡 **Ma — e va scritto — Eleonex HA una linea statica.** _"traders can select the
**Forge** model to secure a **static drawdown** across both one-step and two-step
challenges, or choose the **Pulse** model for a trailing drawdown"_. Forge Core /
Forge Flex / Forge Prime sono dichiarati **statici**; Pulse Core e' trailing.
**Questa e' l'unica cosa che tiene Eleonex fuori dallo scarto definitivo.**

🔴 **Perche' non merita comunque un vaglio adesso:**
- **fondata ad APRILE 2026** — 4 mesi di vita;
- una rassegna indipendente lo dice piu' brutalmente di come lo direi io:
  _"a firm that launched in April and is trumpeting a **single $27,000 payout**
  by summer, indicating it has processed **roughly one noteworthy withdrawal in
  its entire operating history**. This makes it **unproven — worth watching, not
  trusting**"_;
- 🔴 **le percentuali esatte dei muri Forge NON sono dichiarate** in nessuna
  lettura, e **la regola sugli EA non e' MAI comparsa**. Su una flotta di 35 EA
  quello e' il primo buco, non l'ultimo.

> 🎯 **Verdetto a due velocita', ed e' onesto tenerle separate:**
> **il prodotto della pubblicita' (Ignite instant, trailing) = SCARTA SUBITO.**
> **La linea Forge (statica) = DATI INSUFFICIENTI** — non bocciata nel merito,
> semplicemente **un'azienda di 4 mesi con un payout noto all'attivo non e' il
> posto dove Claudio mette la sua prima challenge**. Si riguarda fra 6-12 mesi.

### 3.7 🆕 Leveraged — **il prezzo-esca non e' dove sembrava, ma i muri sono i peggiori del gruppo**

Le tre domande del mandato hanno tutte una risposta, e **due su tre sono meno
gravi del sospetto**. La terza chiude la partita.

#### (a) 🔍 La "full simulation fee" nascosta — **quanto e', ed e' dichiarata?**

> 🟢 **NON e' un prezzo-esca occulto: la cifra ESISTE ed e' recuperabile.**
> **[LETTO-VIA-SEARCH 27/08]**: per un conto da **$100.000 la activation fee e'
> $540,12**, e va pagata **entro 30 giorni dal superamento**.
>
> Il confronto col prezzo barrato della pubblicita' e' illuminante:
> **$540,12 pagati dopo ≈ $549 barrato in pubblicita'.** 🎯 **Il "$8.88" non e'
> uno sconto del 99%: e' un ACCONTO.** La pubblicita' mette accanto un prezzo
> barrato di $549 e un prezzo di $8,88 come se fosse la stessa cosa scontata —
> **non lo e'**. Paghi $8,88 per entrare, e **se passi paghi comunque quasi
> l'intero prezzo barrato**.
>
> 🟠 **Il modello e' onesto nella meccanica** (dal loro FAQ: _"you pay only a
> small $8.88 fee to cover platform costs… only then you will pay the program
> activation fee"_) **ed e' disonesto nella PRESENTAZIONE** (il prezzo barrato
> accanto a $8,88 suggerisce uno sconto che non esiste). 🔴 **Non ho trovato la
> tabella completa delle activation fee per TUTTE le taglie** — solo la 100k.
> Resta **[INCERTO]** se le altre seguano lo stesso rapporto ~1:1 col barrato.
>
> 🔴 **E c'e' un dettaglio che va detto a Claudio perche' e' controintuitivo:
> col "pay after you pass" NON hai finito quando passi. Hai una FATTURA.** Se
> passi e non paghi entro 30 giorni, hai perso la challenge superata.

#### (b) 🔍 E' instant funding mascherato o una valutazione vera?

> 🟢 **E' una VALUTAZIONE VERA.** Il Turbo e' una challenge con obiettivi da
> raggiungere; l'instant funding non c'entra. Il sospetto del mandato e'
> **infondato sulla struttura**.
> 🔴 **Ma i muri sono di grado "instant funding"**, ed e' li' che casca:

| programma | muro totale | daily | esito contro il metro |
|---|---|---|---|
| **Turbo** (quello in pubblicita') | 🔴 **6% TRAILING** | 🔴 **3%** | ❌❌ **doppia lama** |
| **Sprint** | 🟢 statico… **all'1%** | 🔴🔴 **1%** | ❌❌ **assurdo per noi** (target 2%, muro 1%) |
| **Crypto** | 🔴 **6%** | 🔴 **3%** | ❌❌ |

> 🎯 **Nessuno dei tre programmi ha un muro che regge la nostra flotta, e non ci
> va nemmeno vicino.** Il **3% di daily** contro la nostra peggior giornata
> chiusa di **−4,74%**: sfondato del **58%**. Il **6% trailing** contro il
> picco-valle di **6,37%**: rotto sullo storico. Lo **Sprint all'1% statico** e'
> l'unico muro statico del gruppo ed e' **sei volte piu' stretto** di quanto ci
> serve — un singolo SL da 0,65% ne consuma i due terzi.
>
> 🟢 **La conferma piu' bella arriva da una fonte terza che non sapeva di noi**:
> una rassegna indipendente scrive che il **_"3% daily e 6% max drawdown"_ di
> Leveraged e' _"unusually restrictive… could be easily breached by typical
> market spreads and overnight slippage"_**. 🎯 **Un recensore esterno dice, per
> un trader qualunque, esattamente quello che il nostro metro dice per noi.**

#### (c) 🔍 Reputazione — **la piu' documentata delle sette, e non in bene**

| voce | valore | etichetta |
|---|---|---|
| Trustpilot — scala | 🟢 **~1.000 recensioni** — **la base piu' larga del gruppo dopo FTUK** | 🟡 search 27/08 |
| — 1 stella | 🔴 **~80 recensioni da 1 stella** (~8%) | 🟡 search 27/08 |
| — payout confermati | 🟢 **~80% di recensioni positive**, con trader che dichiarano di essere stati pagati (un caso: 100k Turbo, payout **lo stesso giorno**) | 🟡 search 27/08 |
| 🔴 **il pattern nei negativi** | _"a worrying pattern of the company **refusing to pay out withdrawals for vague or supposedly unfair reasons**"_ · payout negati citando **_"material inconsistencies"_ rifiutandosi di fornire prove specifiche** · breach per drawdown con **_"lock conditions not clearly communicated upfront"_** | 🟡 search 27/08 |
| articoli terzi | 🔴 esiste una scheda **_"7 Warnings About GetLeveraged: Legit Prop Firm Or Scam?"_** su brokerlistings | 🟡 search 27/08 |
| eta' azienda | 🔴 **NON DICHIARATA** — definita "newer" dalle rassegne | 🔴 buco |
| 🤖 **regola EA** | 🔴🔴 **MAI COMPARSA**, in nessuna lettura | 🔴 **buco su una lama** |

> 🎯 **Leveraged e' il caso piu' istruttivo delle sette, e per questo lo scrivo
> per esteso.** Non e' una firm fantasma: ha ~1.000 recensioni, l'80% positive,
> payout documentati, un modello di pagamento originale e una fee finale che si
> puo' trovare. **Su molte metriche e' la piu' SOLIDA del gruppo dopo FTUK.**
>
> **E la scartiamo lo stesso, in due righe di aritmetica**: **3% di daily** e
> **6% trailing** contro **−4,74%** e **−6,37%** misurati in casa.
>
> 🔴 **E la forma dei reclami e' la stessa identica di PTB, FXP e FTUK**: il
> problema non e' mai il muro dichiarato — e' la **regola che compare al
> momento del payout** ("material inconsistencies", "Toxic Gambler behavior",
> "lock conditions not communicated upfront"). **Quattro aziende diverse, lo
> stesso identico meccanismo di rifiuto.**

---

## 4. 🧩 IL PATTERN — cosa insegnano queste sette, oltre al verdetto

Questo e' il pezzo che vale piu' dei sette verdetti singoli.

### 🔴 4.1 "Instant funding" e' un NOME COMMERCIALE per "muro dimezzato"

**Cinque delle sette** vendono il salto della valutazione (FTUK Instant,
Eleonex Ignite, PTB Instant, uzo Instant Pro) o la sua versione "senza rischio"
(Leveraged Turbo). **Tutte, senza eccezione, lo pagano con un muro trailing e/o
dimezzato**: 6% trailing (FTUK), ~6% trailing (Eleonex), 10% trailing (PTB), 6%
trailing (uzo Instant), 6% trailing + 3% daily (Leveraged Turbo) — contro il
**10% statico** di una challenge normale.

> 🎯 **La regola da portarsi a casa, e vale per le prossime pubblicita':**
> **"No Evaluation" / "Get Funded Today" / "Instant" / "Pay After You Pass" =
> leggere il MURO prima del PREZZO.** La firm non regala niente: sposta il
> rischio dal tuo tempo (o dal tuo portafoglio) al tuo **margine di errore**.
> Per una flotta con **−6,37% di picco-valle misurato**, l'instant funding e'
> **strutturalmente incompatibile, a qualunque prezzo.**
> **Il prezzo scontato e' l'esca; il muro e' l'amo.**

### 🔴 4.2 Il prezzo bassissimo non e' la bandiera rossa — il MURO lo e'

L'istinto (giusto) di Claudio era guardare i prezzi assurdi: $9, $17, €59, $59,
**$8,88**. **Ma il prezzo basso, da solo, non ha scartato nessuna delle sette.**
Le lame hanno tagliato su **muri e regole EA**, non su listini.

Il motivo e' meccanico: **una prop con un muro stretto puo' permettersi di
svendere la fee**, perche' **il muro fa il lavoro di selezione al posto del
prezzo**. **Fee bassa e muro stretto sono lo stesso modello di business visto da
due lati.** Non e' una truffa in se': e' un prodotto tarato su uno scalper con
1-2 posizioni, non su una flotta.

🎯 **Leveraged lo dimostra meglio di tutte**: e' l'unica che spinge il prezzo
d'ingresso al limite teorico (**$8,88 per QUALSIASI taglia** — il prezzo smette
del tutto di scalare col rischio) e in cambio ha **i muri piu' stretti delle
sette**. **La correlazione non e' un sospetto: e' il modello.**

### 🟠 4.3 Il tag di marketing piu' seducente e' quello che conta meno

**FXP** aveva **"NO CONSISTENCY RULES"** — la voce che ha affossato KeyToProp e
The5ers per noi. **FTUK** aveva **il target di profitto piu' basso del settore
(4%)** e **niente stop loss forzato**. **uzo** aveva **EA senza restrizioni** e
**90% fisso**. **RebelsFunding** aveva **i muri statici**. **Leveraged** aveva
**il rischio d'ingresso azzerato**. Ognuna aveva la voce verde che le altre non
hanno. **Nessuna e' passata**, perche' bastava una lama rossa altrove.

> 🎯 **Il triage non somma i punti: cerca il taglio.** Stessa logica del criterio
> di uscita delle sedie firmato il 18/08 — **il rischio non si compensa col
> merito.**

### 🔴 4.4 La forma dei reclami e' SEMPRE la stessa: la regola che appare al payout

**Quattro aziende su sette** hanno reclami documentati, e **nessuno riguarda il
muro dichiarato**. Riguardano tutti una regola comparsa **dopo**:

| prop | la formula usata per negare |
|---|---|
| **PTB** | _"Toxic Gambler behavior"_, "concentrated trading", requisiti nuovi sulla dashboard **dopo** il rifiuto |
| **Leveraged** | _"material inconsistencies"_, **senza fornire prove**; lock conditions _"not clearly communicated upfront"_ |
| **FTUK** | _"rules that felt hidden and were never clearly communicated"_ |
| **FXP** | 5 payout negati **senza motivo**, utente espulso dal Discord |

> 🎯 **Questo e' il rischio vero, e non e' misurabile leggendo le regole.** Il
> nostro metro di casa sa giudicare un muro; **non sa giudicare una clausola
> discrezionale**. E' esattamente per questo che la shortlist di casa privilegia
> **le prop con storia lunga e volume di payout**, non quelle coi numeri
> migliori sulla carta. **Le clausole discrezionali si scoprono al payout, non
> prima** — e con un'azienda di 4 mesi non c'e' nessuno che le abbia scoperte
> per te.

### 🟢 4.5 La reputazione ha confermato i numeri, non li ha contraddetti

Le prop coi numeri peggiori per noi (FXP 3%, Leveraged 3%, PTB 4% trailing) sono
**anche quelle con reclami documentati di payout negati**. Quelle coi numeri
migliori (RebelsFunding statica, uzo 90%) non hanno reclami trovati. 🟠 **Non e'
una legge** e il campione e' minuscolo, ma **oggi le due letture hanno puntato
nella stessa direzione**, e questo alza la fiducia nel triage.

---

## 5. ⚖️ COSA RESTA IN PIEDI — la shortlist NON cambia

> 🏆 **La shortlist di casa resta quella firmata il 26-27/08: FTMO,
> FundedNext, Alpha Capital.**
>
> **Sette pubblicita' Instagram (piu' SicuroProp scartata a vista), sette
> scarti, zero movimenti in classifica.** E' un risultato, non un buco
> nell'acqua: **il tempo di sette vagli completi (che avrebbero prodotto sette
> bocciature) resta disponibile per il debito tecnico che ci blocca davvero** —
> il censimento SL hard sulle 35 sedie e il debito `open_time` in
> `ExportTrades()`, che sono le due misure DI CASA che oggi impediscono di
> dimostrare la conformita' su **Alpha** e su mezza shortlist.

### 📋 Se Claudio vuole comunque spendere del tempo, l'ordine di resa e':

| priorita' | cosa | perche' | costo |
|---|---|---|---|
| 🥇 **1** | **NIENTE su queste sette** — chiudere il **censimento SL hard** e il debito **`open_time`** | sbloccano **Alpha**, gia' in shortlist, che vale piu' di tutte e sette | interno, misurabile |
| 🥈 **2** | **uzo**, solo se le 3 verifiche col browser (§3.2) vanno tutte bene | unica con **EA senza restrizioni + 90% fisso + 2-step statico**; cade su **8% vs p99 8,1%**, cioe' per **0,1 punti** | 15 min di browser di Claudio, poi eventuale vaglio pieno |
| 🥉 **3** | **Eleonex Forge**, **fra 6-12 mesi** | linea statica reale, ma **4 mesi di vita e un payout noto**: si guarda quando avra' una storia | rimandato |
| — | FTUK · PTB · RebelsFunding · FXP · **Leveraged** | 🔴 **chiuse.** Non si riaprono senza un cambio di regole pubblicato dalla prop | zero |

---

## 6. 🧾 COSA NON HO POTUTO VEDERE — l'elenco onesto

1. 🔴 **Nessuna pagina aperta con i miei occhi.** `WebFetch` e' **EGRESS_BLOCKED
   su tutto** (verificato anche su Wikipedia, bersaglio neutro). Tutto passa dal
   canale di ricerca.
2. 🔴 **La regola sugli EA di Leveraged e di Eleonex**: **mai comparsa**, in
   nessun senso. E' una delle quattro lame, e su due prop su sette e' un buco.
3. 🔴 **Le percentuali dei muri Forge di Eleonex**: mai comparse.
4. 🔴 **La tabella completa delle activation fee di Leveraged**: ho **solo la
   100k ($540,12)**. Per le altre taglie e' **[INCERTO]**.
5. 🔴 **Il daily limit del 2-step di uzo**: mai comparso. E i **target di
   profitto uzo sono in conflitto** fra tre letture (6+4 / 3+3 / 5).
6. 🔴 **La contraddizione FTUK** "No consistency rules" (pubblicita') vs
   "Consistency conditions affect Instant **and Flex** payouts" (regole): **non
   dirimibile senza aprire la pagina ufficiale**.
7. 🔴 **Leva su indici e oro: NON DICHIARATA per NESSUNA delle sette.** E' una
   voce del metro di casa (serve ≥ 1:15, meglio 1:25) e oggi e' un buco totale.
8. 🔴 **Regola news, overnight e weekend**: dichiarate **solo per FTUK** (news
   trading e weekend holding **permessi**) — 🔴 **NON DICHIARATE per le altre
   sei**. Sono le voci su cui e' caduta meta' del dossier del 26/08.
9. 🔴 **Ora e fuso del reset del muro giornaliero**: **nessuna delle sette**.
10. 🔴 **I prezzi della pubblicita' non sono confermati**: il "$9" e il "90%" di
    FTUK (le letture dicono **80%**), il "€59 per la 500k" di PTB (una lettura
    dice **379**). Tutti **[INCERTO]**. 🟢 **Unica eccezione: Leveraged**, dove
    l'$8,88 **e'** confermato come acconto e la fee vera pure.
11. 🔴 **Voti Trustpilot con numero di recensioni** recuperati per **FTUK
    (4,0 / ~580)** e **Leveraged (~1.000 rec., ~80 da 1 stella)**; per PTB e FXP
    ho **il contenuto dei reclami ma non il voto aggregato**; per **uzo** la
    pagina **esiste** ma il voto non e' stato restituito; per
    **RebelsFunding** un ~4,3 di terza parte; per **Eleonex** nessun voto.
12. 🔴 **Il cartello Trustpilot "violazione linee guida / recensioni false"**:
    non verificabile da qui su nessuna delle sette — serve l'occhio di Claudio.
13. 🔴 **Eta' dei domini** (WHOIS non interrogabile): le date (PTB 09/2024, uzo
    2026, Eleonex 04/2026) vengono da **letture di terze parti**, non dal
    registro. Per **Leveraged** e **FXP** l'eta' e' **NON DICHIARATA**.
14. 🟠 **Due misure DI CASA che mancano** e che servirebbero comunque prima di
    pagare **ovunque**: (a) tutte le 35 sedie piazzano davvero uno **SL hard** su
    ogni posizione? (b) il debito **`open_time`** in `ExportTrades()`, che
    impedisce di dimostrare qualunque regola di durata minima.

---

## 7. 📎 URL usati — tutti `[LETTO-VIA-SEARCH 27/08/2026]`, nessuno aperto direttamente

**FTUK:** `ftuk.com` · `faq.ftuk.com/en/articles/12310214-instant-funding-program-forex` ·
`faq.ftuk.com/en/articles/12310204-two-step-program-rules-forex` ·
`faq.ftuk.com/en/articles/12310193-one-step-program-rules-forex` ·
`tradingfinder.com/props/ftuk/rules/` · `h2tfunding.com/reviews/ftuk/` ·
`fundedtrading.com/propfirm/ftuk/` · `traderfuel.net/prop-firms/ftuk/` ·
`trustpilot.com/review/ftuk.com` · `dailyforex.com/forex-brokers/ftuk-review` ·
`forexpeacearmy.com/forex-reviews/20544/ftuk-review` ·
`livingfromtrading.com/prop-firms/ftuk/` · `tradelocker.com/hub/prop-firms/ftuk`

**uzo:** `uzo.com/` · `uzo.com/challenges` · `uzo.com/how-it-works` ·
`uzo.com/about` · `uzo.com/contact` · `trustpilot.com/review/uzo.com`

**PTB:** `plutustradebase.com/` · `plutustradebase.com/faqs/` ·
`plutustradebase.com/docs-categories/general-faq/` ·
`plutustradebase.com/blog/understanding-drawdown-limits-plutus-trade-base/` ·
`ptb.global/` · `trustpilot.com/review/plutustradebase.com` ·
`h2tfunding.com/reviews/plutus-trade-base/` · `myfxbook.com/prop-firms/ptb` ·
`tradersunion.com/brokers/prop/view/plutus-trade-base/` ·
`tradelocker.com/hub/prop-firms/plutus-trade-base/500k-1-step-379` · `tracxn.com`

**RebelsFunding:** `rebelsfunding.com/faq/` ·
`tradingfinder.com/props/rebelsfunding/rules/` · `tradingfinder.com/props/rebelsfunding/` ·
`myfxbook.com/prop-firms/rebels-funding` ·
`altfins.com/knowledge-base/rebelsfunding-review-2026...` ·
`propfirmscompared.com/prop-firms/rebels-funding` · `bestpropfirmguide.com/firm/rebelsfunding/`

**FXP:** `thefxp.com/` · `coinspot.io/en/prop-trading-firms/fxp-prop-firm/` ·
`vettedpropfirms.com/fxp-prop-firm-review/`

**Eleonex:** `eleonex.com/` · `eleonex.com/what-we-do/` ·
`eleonex.com/explore-challenges/pulse-flex/` ·
`eleonex.com/blog/which-prop-firms-offer-instant-funding/` ·
`altfins.com/crypto-news/altfins-academy/eleonex-prop-firm-review-2026` ·
`trailingstoploss.com/eleonex-27000-payout-analysis/` ·
`thecoinrepublic.com/2026/06/19/eleonex-prop-firm-review-what-traders-should-know/`

**Leveraged:** `getleveraged.com/` · `getleveraged.com/turbo-trade/` ·
`getleveraged.com/sprint/` · `getleveraged.com/crypto/` ·
`faq.getleveraged.com/en/articles/11982216-what-is-the-turbo-program` ·
`trustpilot.com/review/getleveraged.com` ·
`myfxbook.com/reviews/prop-trading-firms/getleveraged/3317784,1` ·
`brokerlistings.com/scams/getleveraged` ·
`thetrustedprop.com/prop-firms/get-leveraged` ·
`directionsmag.com/reviews/prop-trading-firms/leveraged-prop-firm` ·
`thetradingmarkets.com/getleveraged-review-2026/`

**Controllo positivo:** `ftmo.com/en/trading-objectives/` ·
`academy.ftmo.com/lesson/maximum-daily-loss/` · `academy.ftmo.com/lesson/maximum-loss/`
