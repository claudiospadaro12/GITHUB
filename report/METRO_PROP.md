# 📏 IL METRO PROP — le 12 domande, e il NOSTRO numero accanto a ognuna

_Scritto il 15/08/2026. Nasce da un link mandato da Claudio
(`axiconnect.online/it-ch/blog/education/proprietary-trading-firms`) che
**non ho potuto leggere**: il proxy dell'ambiente lo blocca, come blocca
Dukascopy. Invece di indovinare cosa c'e' scritto, ho scritto il metro._

**A cosa serve.** Ogni volta che arriva una prop nuova, invece di rileggere
tutto da capo si passa questa lista. Ogni domanda ha gia' **il nostro numero**
accanto, cosi' la risposta non e' "sembra buona" ma **"passiamo" / "non
passiamo" / "non lo sappiamo ancora"**.

**Regola D3, che vale sopra tutto:** _niente acquisti prima delle risposte
**per iscritto** dal supporto._ Il marketing non e' il regolamento. Su
Upcomers la pubblicita' diceva target **5%** e le recensioni **8-10%**.

---

## 🔴 LE TRE CHE DA SOLE POSSONO CHIUDERE IL DISCORSO

### 1. Il drawdown massimo e' **TRAILING** o **STATICO dal deposito**?

**Il nostro numero:** tutte le Monte Carlo del portafoglio sono su **DD
STATICO**: p50 **5,74%** · p95 **9,89%** · p99 **12,47%** su 27 serie a
rischio 1%, che a taglia 0,65% diventa **~8,1%**.

⚠️ Con un DD **trailing sull'equity** quei numeri **non valgono**. La domanda
cambia da "quanto ho perso dal deposito" a "quanto ho restituito dal picco", e
per una curva che sale a scalini come la nostra il secondo e' sempre peggiore.

**Verdetto onesto: NON LO SAPPIAMO.** Non perche' sia difficile — perche'
**non l'abbiamo mai calcolato**. Finche' quel numero non c'e', comprare una
challenge col trailing e' comprare un biglietto per una gara di cui non
conosciamo il percorso.

### 2. Il cap di perdita **GIORNALIERA** quant'e'?

**Il nostro numero:** R51 ha misurato la peggior giornata del portafoglio a
**−2,06%** (era −1,07% prima del cambio, e il round l'ha **raddoppiata**).

- cap **5%** → 🟢 larghi
- cap **4%** → 🟡 due giornate storte di fila e ci siamo
- cap **3% o meno** → 🔴 il nostro peggior giorno misurato ne mangia i due terzi

### 3. Le posizioni **overnight** e nel **weekend** sono ammesse?

**Il nostro numero:** `ABTG_MaxMinNotte` lavora sul box **23:00–04:59**,
`ABTG_Nightly` su **22:00–04:59**, la variante oro su **22:00–06:00**.

🚨 **Se l'overnight e' vietato, tre EA della flotta sono fuori dal giorno
uno.** Non "vanno adattati": sono strategie il cui setup vive di notte. E' la
domanda che quasi nessuno fa prima di comprare.

---

## 🟡 LE QUATTRO CHE CI RIGUARDANO IN MODO SPECIFICO

### 4. Il cap di rischio **per trade** somma le posizioni aperte insieme?

**Il nostro numero:** giriamo a **0,65%**, quindi sotto qualunque cap
ragionevole. **Ma** il 29/07 due EA hanno aperto **lo stesso segnale nello
stesso secondo** (`CENSIMENTO_ORDINI_PC.md` §3). Se il cap somma le posizioni
correlate — come fa Funding Pips entro 10 minuti — quel secondo diventa una
violazione.

### 5. Gli **EA** sono ammessi? E far girare lo **stesso EA su due conti**?

**Il nostro numero:** oggi la stessa flotta gira su **50503392** (piccolo) e
**50504263** (100k). Per noi e' un solo sistema su due conti nostri; per un
regolamento puo' chiamarsi **"copy trading"**, che spesso e' vietato.
**Da chiarire per iscritto**, con queste parole esatte.

### 6. C'e' una **consistency rule** / "best day rule"?

**Il nostro numero:** 27 serie con code Monte Carlo vuol dire che **una
giornata grossa e' statisticamente attesa**, non un'anomalia. Una regola che
nega il payout quando un giorno pesa troppo colpisce esattamente la forma
della nostra curva.

### 7. Il **news trading** e' limitato?

**Il nostro numero:** `ABTG_DAX_Apertura_EU` entra **alle 08:00 server in
punto**, alla campanella. Molte prop vietano di operare **±2 minuti** attorno
alle news ad alto impatto. Le aperture di borsa non sono "news", ma i
comunicati tedeschi delle 08:00 lo sono. **Da chiarire.**

---

## 🟢 LE CINQUE DI CONTORNO (contano, ma non chiudono)

### 8. Profit target, numero di fasi, giorni minimi e massimi
### 9. Payout: frequenza, tetto del primo, split, tempi reali
### 10. Costo, e cosa dice il **modello di business**

> Upcomers vendeva un 100k a **$115,90 invece di $1.159**. Non e' un affare da
> valutare: e' un'informazione. Chi vende a un decimo del listino guadagna
> sulla **vendita delle challenge**, non sui payout — e questo fa pesare di
> piu' ogni regola soggettiva.

### 11. 🕐 Su che **broker e server** gira? Che **fuso** ha? Come si chiamano i simboli?

**Domanda nuova, aggiunta oggi con le cicatrici fresche.** Tutti i nostri EA
hanno gli orari in **ORA SERVER**: DAX `InpSessionHour=8`, apertura USA 14:30,
box notturno 23:00. Su BCM la regola e' "ora italiana − 1".

Oggi abbiamo misurato che **PepperstoneUK-Demo e' a UTC+0**, cioe' **un'ora
piu' indietro di BCM**. Se il server della prop ha un offset diverso e non lo
si rimappa, **l'EA opera a un'ora che non c'entra niente con l'apertura di
borsa** — e ogni verdetto e' spazzatura.

E i **nomi dei simboli** cambiano: il DAX e' `D30EUR` su BCM e **`GER40`** su
Pepperstone; il Dow `U30USD` contro **`US30`**. Un `.set` copiato senza
rimappare non parte, o peggio parte sul simbolo sbagliato.

### 12. 💰 La **taglia** del conto (e perche' conta meno di quanto sembra)

**Primo fatto, contro-intuitivo: la taglia NON cambia la probabilita' di
passare.** Le regole sono tutte in percentuale, e le nostre percentuali sono
identiche su 100k e su 1,5M. Se passiamo, passiamo a tutte le taglie.

**Secondo fatto, che invece cambia le cose in natura:** a 1,5M il rischio per
trade a 0,65% e' **9.750 EUR**, cioe' **177 lotti sul DAX** in un colpo solo,
alle 08:00 in punto. Li' lo slippage non e' un dettaglio: l'aspettativa del
DAX Apertura e' **+0,075R**, e **1 punto indice di slippage se ne mangia il
24%**.

---

## 🧭 Come si usa questa scheda

1. Si scaricano le **risposte scritte** del supporto sulle domande 1-7.
2. Si compila una scheda `report/SCHEDA_PROP_<nome>.md` come quella di
   Upcomers, con le fonti e la data.
3. **Se la 1 dice "trailing", prima si fa la Monte Carlo col DD trailing** —
   e solo dopo si decide. E' un calcolo su dati che abbiamo gia', costa zero, e
   serve per **qualunque** prop moderna, perche' il trailing e' lo standard.

> ### 🛑 E la regola madre, sopra tutte
> **Prop pagata solo dopo forward maturo.** D3 e' in pausa per decisione di
> Claudio del 13/08. E il 15/08 abbiamo scoperto che il forward era
> **contaminato** dai 33 trade del PC fantasma: **il forward pulito comincia
> adesso, non due settimane fa.** La settimana di dati su cui volevamo
> decidere non esiste ancora.
