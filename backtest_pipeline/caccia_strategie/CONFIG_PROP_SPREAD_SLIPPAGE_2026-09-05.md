# 💸 DOSSIER SPREAD & SLIPPAGE — BCM Markets, tipo di conto, VPS e latenza

**Data della caccia: 05/09/2026.** Mandato di Claudio: _"indagare come abbassare
spread e slippage"_, in due filoni — (1) tipo di conto presso BCM Markets,
(2) VPS e latenza verso il server di trading.

> 🛑 **Questo dossier non tocca niente.** Nessun parametro, nessun EA, nessun
> preset, nessun conto in forward. Porta misure, fonti e **proposte**. Decide
> Claudio.

---

## 0. ⛔ CONTROLLO POSITIVO E FONTI NULLE — leggere PRIMA di tutto il resto

Regola di casa §2: prima di cercare, si verifica che il canale risponda.
**Esito di oggi: il canale principale e' NULLO.**

| fonte | esito controllo positivo | verdetto |
|---|---|---|
| `bcm-markets.com` (sito ufficiale del broker) | 🛑 **EGRESS_BLOCKED** dal proxy | ❌ **FONTE NULLA** |
| `www.bcm-markets.com` | 🛑 EGRESS_BLOCKED | ❌ **FONTE NULLA** |
| `metatrader5.com` (find-broker) | 🛑 EGRESS_BLOCKED | ❌ FONTE NULLA |
| `wikifx.com`, `forexbrokerz.com`, `fastbull.com`, `fx-list.com`, `forexdailyinfo.com` | 🛑 EGRESS_BLOCKED | ❌ FONTE NULLA |
| `web.archive.org` | 🛑 non raggiungibile | ❌ FONTE NULLA |
| `tradersmastermind.com`, `whselfinvest.com`, `petrosky.io`, `forexvps.net` | 🛑 EGRESS_BLOCKED | ❌ FONTE NULLA |
| **`mql5.com`** (docs, forum, Code Base, book) | ✅ **contenuti veri, thread e documentazione leggibili** | 🥇 **CANALE BUONO — l'unico** |
| **WebSearch** (snippet + sintesi) | ✅ risponde con contenuti | 🥈 **[LETTO-VIA-SEARCH]** — pagina **mai aperta** |

> 🔴 **Conseguenza sull'onesta' del dossier, dichiarata qui e non nascosta:
> NON HO POTUTO APRIRE UNA SOLA PAGINA UFFICIALE DI BCM MARKETS.**
> Tutto quello che in §1 riguarda i tipi di conto e' **[LETTO-VIA-SEARCH]**:
> letto di riflesso, non verificato sulla pagina. Vale come indizio per
> **formulare la domanda al broker**, **non** come dato su cui decidere.
> L'unica roba etichettata **[VERIFICATO]** in questo dossier viene da
> `mql5.com` (documentazione MetaQuotes e forum, pagine aperte oggi) e dalle
> **nostre misure in casa**.

⚠️ **Un secondo avviso, e non e' un dettaglio.** Esistono **due domini** con
nome quasi identico e il repo li usa entrambi:
- `bcmmarkets.com` — e' quello che il **corso** indica come broker "Black Ridge"
  e che il repo dichiara essere il nostro (`ANALISI_MODULI_BASE_2026-08-18.md`,
  `MEDIA200_CORSO_SPEC.md` §15.1);
- `bcm-markets.com` — e' quello che i risultati di ricerca associano a
  **BCM Markets Ltd** (Mauritius) e da cui vengono i dati di §1.

**Non ho potuto verificare che siano la stessa societa'.** Il nostro terminale
dice `BCM Markets Ltd` come nome del titolare del conto
(`report/CENSIMENTO_ORDINI_PC.md:194`), il che punta verso `bcm-markets.com`,
ma **e' un'inferenza sul nome, non una prova**. Se sono due entita' diverse,
tutto il §1 parla del broker sbagliato. **[INCERTO — da chiudere con la
domanda D0 del §4.]**

---

## 1. 🏦 BCM MARKETS — quello che ho trovato, con l'etichetta giusta

### 1.1 Scheda broker

```
BROKER          BCM Markets Ltd
SITO            bcm-markets.com  (⚠️ vedi §0: conflitto con bcmmarkets.com)
LETTO IL        05/09/2026 — ⚠️ MAI SULLA PAGINA UFFICIALE (proxy bloccato)
GIURISDIZIONE   Mauritius. Reg. n. 204864, sede 3 Emerald Park, Trianon,
                Quatre Bornes, 72257                        [LETTO-VIA-SEARCH]
LICENZA         FSC Mauritius, Investment Dealer, n. GB233202163
                                                            [LETTO-VIA-SEARCH]
PIATTAFORME     MT4 (WHITE LABEL) + MT5 (LICENZA PIENA)     [LETTO-VIA-SEARCH]
NOSTRO SERVER   BCMMarkets-Server "through Access Server"   ✅ [VERIFICATO in
                casa: report/collaudo_fase1/RIGA1_LETTURA_2026-09-03_1712.txt]
SEDE DEL SERVER ❓ [INCERTO] — vedi §2.2, non e' documentato pubblicamente
                in nessuna fonte che io abbia potuto aprire
```

### 1.2 I due conti — la riga che risponde alla domanda di Claudio

| | **STANDARD** | **PRO** |
|---|---|---|
| deposito minimo | **nessuno** (una fonte dice $0, un'altra non lo cita) | **$2.000** |
| spread da | **0,8 pip** sui major FX (una seconda fonte dice **1,0 pip**) | **0,0 pip** |
| commissione | **nessuna** | **$5 per lotto** |
| leva | fino a 1:500 (indici: max 1:200) | idem |
| esecuzione | _"stesse condizioni di esecuzione"_ per entrambi | idem |

**Etichetta: tutta la tabella e' [LETTO-VIA-SEARCH], 05/09/2026.**
🚩 **Tre incoerenze gia' visibili fra le fonti riflesse**, che da sole
dimostrano perche' non ci si puo' fidare:
1. spread Standard: **0,8 pip** secondo una sintesi, **1,0 pip** secondo
   un'altra. Uno dei due e' sbagliato.
2. commissione Pro: una fonte dice **$5 per lotto**, un'altra dice
   **$5 per lotto _per lato_** (= $10 andata/ritorno). **Fa il doppio.**
3. **NESSUNA fonte da' lo spread sugli INDICI.** Zero. Non esiste in giro un
   numero pubblico su GER40/US30/NAS100 di questo broker — e gli indici sono
   esattamente dove sta il nostro costo.

### 1.3 🧮 IL CONTO CHE DECIDE SE VALE LA PENA CHIEDERE — sul FOREX

`[I]` aritmetica nostra, su 1 lotto standard = 100.000 unita', dove 1 pip = $10.

| | costo per giro (round turn) su 1 lotto EURUSD |
|---|---|
| **Standard** — spread 0,8 pip, 0 commissioni | **$8,00** |
| **Pro** — spread raw + $5/lotto (se **round turn**) | spread_raw × $10 + $5,00 |
| **Pro** — spread raw + $5/lotto **per lato** | spread_raw × $10 + $10,00 |

> 🎯 **Il punto di pareggio:** il Pro conviene **solo** se lo spread raw medio
> sta **sotto 0,30 pip** (caso commissione round-turn) o **sotto 0,00 pip**
> (caso commissione per lato — cioe' **non conviene mai**).
>
> 🔴 **Tradotto: se la commissione e' $5 PER LATO, il conto Pro e' un
> peggioramento matematico rispetto allo Standard, a qualunque spread raw.**
> E' per questo che la domanda n.2 del §4 e' quella che vale di piu': **prima
> di chiedere "posso avere il raw?", bisogna sapere se la commissione e' per
> lato o per giro**, altrimenti si chiede un downgrade.

### 1.4 🔴 E adesso il numero che ribalta la priorita' del mandato

Le nostre misure in casa, da confrontare:

| misura di casa | valore | fonte |
|---|---:|---|
| spread mediano U30USD in sessione | **1,9-2,0 punti indice** | `SPREAD_FLOTTA_MISURA_2026-09-03.md` §2 |
| spread P95 U30USD in sessione | **2,0-3,0** | idem |
| **slippage misurato su UNO stop reale (NASUSD)** | **🔴 21,5 punti indice** | `R109_REFERTO.md` §fatto collaterale 2 |
| conversione (MISURATA su tutti e 3 gli indici) | **1 punto indice = 100 punti MT5** | `ABTG_SpreadOrario.mq5:57` |

> 🚨 **LO SLIPPAGE DI QUELL'EVENTO VALE ~11 VOLTE LO SPREAD MEDIANO.**
> 21,5 contro 1,9-2,0. E vale **4,3 volte** il pavimento di stop del Dow
> (`InpMinStopPts = 500` = 5,0 punti indice, `ABTG_Dow_Apertura_US.mq5:313`).
>
> **Conseguenza per il mandato: la caccia allo spread e' l'ottimizzazione del
> numero PICCOLO.** Anche un conto raw perfetto che azzerasse lo spread
> risparmierebbe ~2 punti indice per giro; un solo evento di slippage come
> quello ne e' costati 21,5. **Il filone che paga e' il secondo — ma, come
> dimostra il §2, non nel modo che il mandato si aspettava.**

---

## 2. 🌐 VPS, LATENZA E SLIPPAGE — e la scoperta che cambia il verdetto

### 2.1 🥇 IL FATTO TECNICO PIU' IMPORTANTE DEL DOSSIER

**Lo stop loss depositato al broker NON viene eseguito dal nostro VPS.
Viene eseguito dal server del broker. La latenza del nostro VPS non lo tocca.**

Fonti, in ordine di rango:

- 🥇 **[VERIFICATO — mql5.com, doc ufficiale MetaQuotes, letta 05/09/2026]**
  `docs/constants/environment_state/marketinfoconstants` — in **Market
  Execution**: _"A broker makes a decision about the order execution price
  without any additional discussion with the trader."_
- 🥇 **[VERIFICATO — mql5.com forum 501937, letto 05/09/2026]** Alain Verleyen
  (moderatore MQL5): _"In market execution the market decide. Yes it could be
  significantly different, **you can use limit order (pending order) to control
  your slippage**"_. Nello stesso thread si cita la documentazione: in
  `SYMBOL_TRADE_EXECUTION_MARKET` _"we can't specify an opening price and a
  maximum deviation"_.
- 🥈 **[LETTO-VIA-SEARCH, 05/09/2026]** consenso su piu' thread MQL5: gli SL/TP
  _"sono gestiti dal lato broker, non dal lato terminale... i livelli di
  attivazione sono memorizzati sul trade-server, non sul terminale"_ — se il
  terminale si disconnette, lo stop funziona lo stesso.
- 🥇 **[VERIFICATO — mql5.com forum 465784, letto 05/09/2026]** Vladislav
  Boyko separa le due cose in modo definitivo: _"you may have a ping < 20 ms,
  but when the broker receives your trade order, it can execute it for several
  hundred ms (**and this does not depend on your ping**)"_. E l'analogia:
  _"If you get to the bar in 20 seconds, it doesn't mean you'll start drinking
  a cocktail in 20 seconds - the bartender needs time to make your cocktail."_
  Nello stesso thread, Erik Shekunts riporta **ping 0,5 ms mostrato da MT5 ma
  40 ms di tempo di esecuzione reale nel giornale**, girando da un datacenter
  Equinix NY.

> 🔴 **VERDETTO SUL FILONE 2, contro l'ipotesi di partenza:
> i 21,5 punti di R109 sono stati presi su uno STOP LOSS. Un VPS piu' vicino
> a BCM NON avrebbe cambiato quel numero di un punto.**
> Il VPS agisce **solo** su cio' che parte dal nostro terminale: l'ordine di
> ingresso a mercato, la modifica di uno stop, la chiusura forzata del
> Guardian. **Non sulla riga che ci e' costata di piu'.**

🚩 **E qui c'e' una contraddizione fra fonti che vale la pena mettere agli
atti**, perche' e' didattica. La stessa affermazione, dai venditori di VPS
**[LETTO-VIA-SEARCH, 05/09/2026]**: _"quando il tuo stop loss viene attivato,
la velocita' con cui quell'ordine raggiunge il server del broker influenza
direttamente il prezzo di riempimento"_. **E' tecnicamente falsa** per uno
stop depositato al broker, e la contraddice la documentazione MetaQuotes.
Chi la scrive **vende VPS**. Stessa pagina: _"1 ms di latenza in meno migliora
i prezzi di circa lo 0,1%"_ — sul DAX lo 0,1% sono **~24 punti indice per
millisecondo**: 🚩 numero assurdo, bandiera rossa, fonte squalificata sul
merito tecnico.

### 2.2 📍 DOVE STA `BCMMarkets-Server` — non e' pubblico, ma si MISURA

**[INCERTO]** Non esiste documentazione pubblica aperta da me sulla sede del
server BCM. Una sintesi di ricerca ha proposto _"BCMMarkets-Live1, Cipro"_ ma
**non ho potuto aprire nessuna pagina che lo confermi e il nome del server non
e' nemmeno il nostro** (il nostro e' `BCMMarkets-Server`): **lo scarto come
non attendibile e non lo riporto come dato.**

✅ **Ma non serve una fonte pubblica: il dato ce l'ha Claudio sul VPS.** Il
nostro giornale dice gia' `BCMMarkets-Server **through Access Server**`
(`RIGA1_LETTURA_2026-09-03_1712.txt:94`). In MT5 gli **Access Server** sono i
punti di ingresso: il terminale li pinga tutti e si aggancia al piu' veloce
**[LETTO-VIA-SEARCH, 05/09/2026]**. Quindi il ping che conta e' quello verso
l'access server scelto, ed e' leggibile.

### 2.3 🔧 LA GUIDA PRATICA — come Claudio misura la latenza del NOSTRO VPS

> 🔴 **Io non posso misurarla da qui.** Non ho accesso al VPS e non ho il
> server BCM. Qui c'e' **come si misura**, non un risultato.

#### Passo 1 — il numero che MT5 gia' conosce (30 secondi, zero installazioni)

Sul VPS, dentro MT5: **angolo in basso a destra**, sulla barra di stato, c'e'
l'indicatore di connessione con i due numeri (kb ricevuti / **ping in ms**).
**Cliccarci sopra** apre l'elenco degli access server con il ping di ciascuno;
la voce **"Rescan servers"** li ripinga tutti e si riaggancia al piu' veloce
**[LETTO-VIA-SEARCH, 05/09/2026]**.
👉 **Da fare comunque una volta, anche solo per vedere se siamo agganciati al
punto migliore.** Costo: zero.

#### Passo 2 — il numero programmatico, quello da registrare nel tempo

**[VERIFICATO — mql5.com, "MQL5 Programming for Traders", letto 05/09/2026]**
esistono queste proprieta' del terminale:

| proprieta' | cosa da' | unita' |
|---|---|---|
| `TerminalInfoInteger(TERMINAL_PING_LAST)` | _"The last known ping to the trade server"_ | **microsecondi** (int) |
| `TerminalInfoInteger(TERMINAL_CONNECTED)` | connessione al server di trading | bool |
| `TerminalInfoDouble(TERMINAL_RETRANSMISSION)` | _"percentage of network packets resent in TCP/IP"_ | **%** |

⚠️ **`TERMINAL_PING_LAST` e' in MICROSECONDI**: per avere i ms si divide per
1000. Un valore di `8000` = **8 ms**.
🥇 **`TERMINAL_RETRANSMISSION` e' il numero sottovalutato**: la ritrasmissione
TCP e' **jitter**, ed e' peggio di un ping alto costante. Un ping di 6 ms con
il 3% di ritrasmissioni e' una linea peggiore di un ping di 20 ms pulito.

#### Passo 3 — la misura di rete vera, da PowerShell **sul VPS**

Serve prima l'IP dell'access server. Si legge nel **Giornale** di MT5 alla
riga di connessione (formato `'50504263': connecting to <IP>:443`), oppure con
`netstat`. Poi, **in ora server e sul VPS, non sul PC di casa**:

```powershell
# 1) l'IP a cui MT5 e' realmente agganciato (mentre MT5 gira)
netstat -ano | Select-String ":443" | Select-String "ESTABLISHED"

# 2) latenza ICMP sostenuta: 100 pacchetti, non 4
ping -n 100 <IP_ACCESS_SERVER>

# 3) latenza sulla PORTA VERA (443/TCP): l'ICMP puo' essere depriorizzato
Test-NetConnection -ComputerName <IP_ACCESS_SERVER> -Port 443 -InformationLevel Detailed

# 4) il percorso: dove si perdono i millisecondi
tracert -d <IP_ACCESS_SERVER>
pathping -q 50 <IP_ACCESS_SERVER>
```

⚠️ **Nota di casa:** questi comandi **non** vanno in un `.ps1` con emoji
(regola 17/08). Se diventano uno script, si scrive in **ASCII puro**.
⚠️ **`ping` misura ICMP, non il percorso di trading.** `Test-NetConnection ...
-Port 443` e' piu' vicino alla verita' perche' usa TCP sulla porta reale.
**[LETTO-VIA-SEARCH, 05/09/2026]**: _"il numero di latenza mostrato in MT4 o
MT5 non e' il tuo vero RTT verso il broker — MT4 e MT5 sono piattaforme di
trading, non strumenti di misura di rete"_.

#### Passo 4 — come si legge il risultato

| ping VPS → access server BCM | lettura | cosa farne |
|---:|---|---|
| **< 5 ms** | 🟢 eccellente, colocation-grade | non c'e' niente da guadagnare qui |
| **5-15 ms** | 🟢 buono per qualunque strategia nostra | **fermarsi**: non spendere per migliorarlo |
| **15-50 ms** | 🟡 accettabile, ma vale la pena chiedersi dov'e' il VPS | valutare un cambio di sede |
| **> 50 ms** | 🔴 lento per strategie attive | 👉 vale la pena spostare il VPS |
| **> 100 ms** | 🔴 tipico di un PC di casa, non di un VPS | 👉 spostare, senza discutere |

**Etichetta: [LETTO-VIA-SEARCH, 05/09/2026]** — soglie di consenso raccolte da
piu' fonti (in gran parte **venditori di VPS**, quindi con interesse a
spaventare: 🚩 le prendo come ordine di grandezza, non come vangelo).
**Il caveat che ripetono tutti e che invece e' credibile:** _"la latenza
stabile (pochi picchi/jitter) conta piu' della ricerca del ping minimo"_ —
ed e' coerente con `TERMINAL_RETRANSMISSION`.

> 🎯 **La riga onesta:** i nostri motori sono su **M5/M15/H1/H4** con stop di
> decine o centinaia di punti indice. **Non siamo scalper a latenza.** Se il
> ping esce sotto i 20 ms, la latenza **non e' il nostro problema** e ogni euro
> speso li' e' sprecato. Se esce sopra i 50 ms, allora si', si guarda.
> **Misurare costa 5 minuti e chiude la domanda in un senso o nell'altro.**

### 2.4 🖥️ MQL5 VPS — l'opzione che risolve il problema senza cercare la sede

**[VERIFICATO — mql5.com/en/vps, letta 05/09/2026]**, citazioni letterali:
- _"96% of broker servers can be accessed in less than 10 ms, while 84% — in
  less than 3 ms."_
- _"More than thirty hosting points around the world provide optimal access to
  trade servers of any broker."_
- confronto dichiarato col PC di casa: _"network delays from 100 ms"_.
- risorse: _"up to 3 GB of RAM, up to 16 GB of hard disk space and several CPUs"_
- prezzi: **Mini $15/mese** (1 mese) · Optimal $13 (3 mesi) · Long $10,83
  (6 mesi) · **Max $10/mese** (12 mesi) · _"Free trial period - 24 hours"_
- attivazione: icona VPS nella piattaforma → scelta del piano → migrazione
  dell'ambiente in un clic.

> 🥇 **Perche' e' interessante ANCHE SOLO come strumento di misura:**
> il servizio **sceglie da solo il punto di hosting piu' vicino al server del
> broker**. Quindi, aprendo la procedura sul nostro MT5, **MT5 ci DICE dove sta
> il server BCM e con che ping** — e c'e' **24 ore di prova gratuita**.
> 🎯 **E' il modo piu' economico che esista per chiudere l'[INCERTO] del §2.2:
> costo zero, tempo ~15 minuti.**
>
> ⚠️ **Limiti da mettere in conto, non taciuti:** (a) 3 GB di RAM e un
> ambiente MT5 solo — **la nostra flotta gira su un VPS Windows con piu' cose
> sopra** (script, raccolta pagella, task pianificate): l'MQL5 VPS **non e' un
> rimpiazzo del nostro VPS**, e' un secondo ambiente; (b) migra l'ambiente di
> UN terminale, e noi ne abbiamo piu' di uno (piccolo + 100k);
> (c) **non e' una proposta di migrazione**: e' una proposta di **misura**.

### 2.5 📦 Dove il VPS conta DAVVERO per noi (le tre righe vere)

Nessuna riguarda lo stop loss. **[INFERITO]** dai fatti di §2.1:

1. **Gli ingressi a mercato alla campanella.** `ABTG_DAX_Apertura_EU` entra
   **alle 08:00 server in punto** (`METRO_PROP.md` §7). E' il momento di
   massima velocita' del prezzo della giornata: li' i millisecondi fra segnale
   e riempimento sono gli unici che contano davvero per noi.
2. **La chiusura d'emergenza del Guardian** (4,9% / 9,9%): e' un ordine che
   parte dal NOSTRO terminale. Se il VPS e' lento **mentre il conto sta
   cadendo**, la chiusura arriva piu' tardi e piu' in basso.
3. **La continuita', non la velocita'.** Un VPS che si disconnette lascia le
   sedie senza sorveglianza; gli SL restano al broker (§2.1) ma il Guardian no.
   **Uptime > ping**, per noi.

---

## 3. 🕳️ LA TABELLA DEI BUCHI — cosa fanno gli altri, cosa abbiamo noi

Confronto fra i meccanismi trovati fuori e il nostro impianto reale
(auditato oggi sul sorgente, 05/09/2026, branch `lavoro`).

| # | meccanismo | fuori (fonte) | 🏠 noi, oggi | buco? |
|---|---|---|---|---|
| **M1** | **filtro spread all'ingresso** | universale: `MaxSpreadSize` presente in **tutti** gli EA prop-ready della nostra biblioteca | ✅ **`InpMaxSpread` esiste in 86 EA su 104** | 🟡 **c'e' l'input, ma il DEFAULT e' 0 = SPENTO in 75 file su 86** (conteggio esatto, audit 05/09). Gli 11 accesi sono quasi tutti EA **di provenienza esterna** (ORB oro/DAX, Ichimoku oro: 30-50; `ABTG_EasyTrend` 300; `ABTG_BreakoutCorso` 3,0). 🔴 **Sulle sedie indici vive il filtro e' 0 su TUTTE**: `DAX_Apertura_EU` (+`_Ottimizzato`), `Dow_Apertura_US`, `Nasdaq_Apertura_US` (+`_Ottimizzato`), `MaxMinNotte` |
| **M2** | **valore del cap tarato PER SIMBOLO** | `RangeBreakoutDaytrader` (MQL5 Market) spedisce **30** (USDJPY, XAUUSD 2-digit), **300** (US30), **5000** (BTCUSD) — stesso EA, stesso vendor, tre valori | ❌ dove e' acceso, e' un numero tondo (50, 30, 20), non legato a una misura del simbolo | 🔴 **BUCO** |
| **M3** | **cap = P95/P99 MISURATO, non un numero "prudente"** | il nostro stesso `.set` di `TheImpossibleProp` lo dice: _"MaxSpread \| 25 → 5 \| In-session p99 spread = 5p. **Shipped 25 never triggered**"_ | ❌ nessun preset di casa lega `InpMaxSpread` alla misura del 03/09 | 🔴 **BUCO — ed e' il piu' facile da chiudere: la misura ce l'abbiamo gia'** |
| **M4** | **deviazione massima sull'ordine** | `SetDeviationInPoints` | ✅ presente in 87 EA — **ma 61 hardcoded a `30`** e solo 4 come input | 🟡 vedi M5: potrebbe essere **decorativo** |
| **M5** | **sapere in che MODALITA' DI ESECUZIONE si e'** | in **Market Execution la deviazione e' IGNORATA** [VERIFICATO §2.1] | ❌ **non lo sappiamo**: `ABTG_InfoBroker.mq5` legge contract size, tick value, tick size, spread — **NON legge `SYMBOL_TRADE_EXEMODE`** | 🔴 **BUCO GRAVE** — se BCM e' Market Execution, i nostri 61 `SetDeviationInPoints(30)` non fanno **niente** |
| **M6** | **`STOPS_LEVEL` / `FREEZE_LEVEL`** | distanza minima imposta dal broker per gli stop [VERIFICATO, doc MQL5] | ❌ non censiti da `InfoBroker` | 🔴 **BUCO** — con stop stretti e' la regola che li rifiuta o li sposta |
| **M7** | **entrare con LIMIT invece che a mercato** | rimedio n.1 secondo il moderatore MQL5 (§2.1) | ✅ **CE L'ABBIAMO GIA'**: `ABTG_Dow_Apertura_US.mq5:174` — `ABTG_RETEST = 2` _"rottura + ritorno sul livello con LIMIT (Emiliano: niente slippage)"_ | 🟢 **NESSUN BUCO** — meccanismo presente, da valutare l'estensione |
| **M8** | **pavimento di stop dimensionato su spread+slippage** | pratica diffusa | ✅ **CE L'ABBIAMO**: `InpMinStopPts = 500` sul Dow, e la lezione R109 lo ha reso obbligatorio | 🟢 **NESSUN BUCO** — ⚠️ ma 500 pt = 5,0 pti indice contro 21,5 di slippage misurato: **il valore va rivisto** |
| **M9** | **slippage stimato nel backtest** | raro | ✅ **CE L'ABBIAMO E CI FA ONORE**: `InpSlippagePts` peggiora l'entry nel tester (`ABTG_Dow_Apertura_US.mq5:312`, `ABTG_Apertura_Study.mq5:36`) | 🟡 **default = 0 = backtest ottimista** |
| **M10** | **misura della latenza** | `TERMINAL_PING_LAST`, `TERMINAL_RETRANSMISSION` [VERIFICATO] | ❌ **nessuno dei 104 EA e del Guardian li legge** | 🔴 **BUCO** |
| **M11** | **deviazione sulla CHIUSURA D'EMERGENZA** | — | ❌ `ABTG_Guardian.mq5` usa `CTrade` (riga 78) e **non chiama mai `SetDeviationInPoints`** (audit riga per riga, 05/09) | 🔴 **BUCO** — il Guardian chiude ai muri, cioe' **nel momento peggiore possibile per lo spread** |
| **M12** | **evitare le ore a spread largo** | Ryan L Johnson, forum MQL5 501937: _"a time filter to avoid typical high spread times"_ | 🟡 gli orari di sessione ci sono, ma **non sono stati scelti sullo spread** | 🟡 parziale — la misura del 03/09 li' e' inutilizzata (DAX notte 3,5-3,9) |

### 3.1 📐 I valori pronti — se M2/M3 si chiudono, questi sono i numeri

`[I]` conversione **MISURATA** in casa: **1 punto indice = 100 punti MT5**
(`ABTG_SpreadOrario.mq5:57`, valida sui tre indici). `InpMaxSpread` e' in
**punti MT5**.

| simbolo | ore di lavoro (server) | mediana | **P95 in sessione** | **`InpMaxSpread` proposto (pti MT5)** |
|---|---|---:|---:|---:|
| NASUSD | 14-20 | 1,6-1,8 | **2,7** | **270** |
| U30USD | 14-20 | 1,9-2,0 | **3,0** | **300** |
| D30EUR | 8-16 | 1,6-1,7 | **1,9** (ora 8: **2,7**) | **190** — 🕐 **270 se l'EA lavora all'ora 8** |

> 🥇 **La convergenza che vale come controprova esterna:** il valore che esce
> dalla NOSTRA misura per U30USD e' **300 punti MT5** — ed e' **esattamente**
> il `MaxSpreadSize=300` che `RangeBreakoutDaytrader` spedisce sul suo preset
> **US30** (4 file su 4: ExtraLow, Low, Medium, High risk).
> Due strade indipendenti, stesso numero. **[INFERITO]** sull'unita' (assumo
> che il vendor usi punti MT5 su un US30 a 2 decimali: 300 pt = 3,00 punti
> indice) — ma la coincidenza e' notevole e va detta.

⚠️ **Avvertenza sul filtro spread, che vale come "RISCHIO" per ogni proposta
che lo usa:** un cap troppo stretto **non riduce il costo, sopprime i trade**,
e per una sedia gia' a bassa frequenza puo' azzerare il campione. Per questo
il P95 (che lascia passare il 95% delle occasioni) e' la scelta giusta, **non**
la mediana.

---

## 4. 📨 LE DOMANDE ESATTE DA FARE A BCM MARKETS

> 🛑 **Perche' servono:** §0 dice che **non ho potuto leggere una sola pagina
> ufficiale**. Ogni riga di §1 e' un indizio, non un dato. Vale la **regola
> D3 di casa**: la risposta **per iscritto** o niente.
> Da mandare via ticket o all'account manager, in inglese, **numerate**, con
> richiesta esplicita di risposta scritta.

**D0 — l'identita' (da fare per PRIMA, decide tutto il resto)**
> _"My live/demo account 50504263 is on the server `BCMMarkets-Server` and the
> account holder is shown as `BCM Markets Ltd`. Can you confirm: (a) which
> website is the official one for my account — `bcm-markets.com` or
> `bcmmarkets.com`? (b) Is `BCM Markets Ltd` (Mauritius FSC licence
> GB233202163) the entity holding my account? (c) Is 'Black Ridge' a related
> brand or a different entity?"_

**D1 — i tipi di conto, per iscritto**
> _"Please send me the full, current list of live account types available to
> me (Standard, Pro, or any other, including any raw-spread / ECN account),
> with for each: minimum deposit, typical spread, commission, and whether MT5
> Expert Advisors are allowed."_

**D2 — la commissione: PER LATO o PER GIRO? (la domanda che vale di piu')**
> _"For the Pro (raw spread) account, is the $5 per lot commission charged
> **per side** (i.e. $10 per round turn) or **per round turn** ($5 total)?
> Please state it unambiguously."_

**D3 — gli INDICI, che e' dove sta il nostro costo (e dove non esiste un solo numero pubblico)**
> _"I trade the indices `D30EUR`, `U30USD` and `NASUSD`. For EACH of these
> three symbols, and for EACH account type, please provide: (a) the typical
> and the average spread **in index points** during the cash session; (b) the
> commission, if any, and in which unit; (c) whether the spread is fixed or
> floating; (d) `SYMBOL_TRADE_STOPS_LEVEL` and `SYMBOL_TRADE_FREEZE_LEVEL`.
> Note: none of this information is published on your public website."_

**D4 — la modalita' di esecuzione (risposta tecnica, non commerciale)**
> _"For the symbols above, what is the MT5 execution mode
> (`SYMBOL_TRADE_EXEMODE`): Instant, Request, Market or Exchange? I ask
> because in Market Execution the `deviation` parameter of a trade request is
> ignored, and my EAs currently set it."_

**D5 — spread orario: la nostra misura contro la loro**
> _"We measured, from your own historical tick data (252 million ticks,
> 26/09/2024 → 30/06/2026), that the `D30EUR` spread roughly **doubles** after
> 17:00 server time (median 1,6-1,7 index points in session vs 3,5-3,9 at
> night) and that `U30USD` shows P95 = 7,0 with a maximum of 101 index points
> at hour 23 server. (a) Is this the intended pricing schedule? (b) Is there a
> published spread schedule by session? (c) What is the exact widening window
> around the cash close?"_

**D6 — DEMO vs REALE (la domanda che protegge tutto il forward)**
> _"Do the demo servers/accounts (e.g. 50503392 and 50504263) receive
> **exactly the same** price feed, spread and execution model as live
> accounts, or is the demo feed synthetic/idealised? Specifically: (a) is the
> spread identical? (b) is slippage simulated on demo? (c) is the execution
> mode the same?"_
> 🔴 **Perche' e' la piu' importante di tutte per il progetto:**
> **[LETTO-VIA-SEARCH, 05/09/2026]** il consenso e' che _"lo slippage e'
> quasi sempre assente in tutti i conti demo e lo spread non e' mai
> esattamente lo stesso"_, e che _"su una demo il tuo stop loss a 1,0850 si
> riempira' quasi sempre a 1,0850"_. **Se vale anche per BCM, il forward su
> 50504263 sta misurando un mondo senza slippage** — e il nostro unico
> slippage misurato (21,5 punti, R109) viene da un **backtest a tick reali**,
> non dalla demo. **La domanda D6 dice se il forward e' ottimista.**

**D7 — volume e condizioni migliori**
> _"Do you operate an active-trader / volume-tier programme (rebates, tighter
> spreads or reduced commission above a monthly volume threshold)? If yes,
> what are the thresholds and the benefits? Can conditions be reviewed on a
> per-account basis?"_
> ⚠️ **[LETTO-VIA-SEARCH]** i programmi a scaglioni di volume esistono presso
> altri broker (rebate crescenti col volume mensile, fino a ~15% di riduzione
> dei costi presso alcuni). **Non ho trovato nulla del genere per BCM.**
> **[INFERITO]** con il nostro volume attuale (flotta demo, 0,65% di rischio)
> e' molto improbabile che si raggiunga una soglia: la domanda serve a
> **sapere se la scala esiste**, non ad aspettarsi uno sconto oggi.

**D8 — il server e la sede (chiude l'[INCERTO] di §2.2)**
> _"In which datacenter / city is the MT5 trade server `BCMMarkets-Server`
> hosted, and where are the Access Servers my terminal connects through? Do
> you recommend or support any particular VPS location for algorithmic
> trading?"_

---

## 5. 🧾 SCHEDE PRODOTTO — cosa dichiarano gli EA prop degli shop su spread/slippage

Materiale gia' in casa (`biblioteca/set/`, 79 file raccolti il 18-23/08),
riletto oggi con la lente spread/slippage. **Non si compra niente**: si legge
la meccanica.

```
NOME / VENDOR   Range Breakout Daytrader (MQL5 Market)
URL             mql5.com/.../311278 · .../312082 (US30) — set in biblioteca
MECC. DICHIARATI  cap di spread PER SIMBOLO
INPUT VISIBILI  MaxSpreadSize = 30 (USDJPY, XAUUSD 2-digit) · 300 (US30) ·
                5000 (BTCUSD) · RiskPercentage 4,8 (Low) - 15,0 · LotMode 0
COSA CI PORTIAMO A CASA  🥇 il PRINCIPIO: il cap di spread NON e' una
                costante dell'EA, e' una costante DEL SIMBOLO. E il valore
                US30 (300) coincide col nostro P95 misurato. → M2/M3
```

```
NOME / VENDOR   The Impossible Prop (mql5 blog 769728) — set TARATO DA NOI
URL             file in biblioteca/set/, 18/08/2026
INPUT VISIBILI  MaxSpread: default vendor 25 (EURUSD) / 30 (GBPUSD)
                → nostro valore tarato: 5, con la motivazione scritta nel file
NUMERI VENDOR   ignorati (non pesano)
COSA CI PORTIAMO A CASA  🥇 la frase che vale il dossier:
                "Shipped 25 never triggered" — il default del venditore era
                cosi' largo da non scattare MAI. Un filtro spread lasciato al
                default del vendor e' DECORATIVO. → M3
```

```
NOME / VENDOR   FTMO Smart Trader (mql5 blog 765121)
INPUT VISIBILI  Fix_Spread_pips = 6 · DAILY_DD_ = -500
MOTORE SOTTO    non dichiarato
COSA CI PORTIAMO A CASA  🟡 poco: usa uno spread FISSO ASSUNTO (6 pip) invece
                di leggere quello vero. E' l'anti-esempio: noi lo spread
                l'abbiamo MISURATO su 252 milioni di tick.
```

```
NOME / VENDOR   The Gold Reaper (propfirm preset)
INPUT VISIBILI  MaxSpread = 500.0
COSA CI PORTIAMO A CASA  ❌ NIENTE. 500 su oro e' un cap che non scatta mai:
                stesso difetto del default di Impossible Prop.
```

> 🎯 **La lezione trasversale delle quattro schede, ed e' l'unica che conta:
> il filtro spread ce l'hanno TUTTI, e quasi tutti lo spediscono a un valore
> che non scatta mai.** Il valore utile non e' quello del vendor: e' il **P95
> misurato sul TUO broker, nelle TUE ore**. Noi quel numero ce l'abbiamo dal
> 03/09 e non l'abbiamo ancora usato.

---

## 6. 📋 LE PROPOSTE — in ordine di resa/costo. Decide Claudio.

> 🛑 **Nessuna si applica da sola.** Vanno in lista; e comunque passano
> dall'imbuto come qualunque modifica (gli `_Ottimizzato` girano in
> parallelo, mai sostituiti).

### 🥇 P1 — MISURARE il ping del VPS (e scoprire dove sta il server BCM)
```
PROPOSTA   Claudio esegue i 4 passi del §2.3 sul VPS e riporta:
           ping barra di stato, elenco access server, ping -n 100,
           Test-NetConnection -Port 443, tracert. In piu': apre la
           procedura MQL5 VPS (prova gratuita 24h) SOLO per leggere
           quale punto di hosting propone e con che ping -> rivela la
           sede del server BCM senza chiedere niente a nessuno.
DOVE       VPS Windows, a mano. Nessun codice, nessun EA toccato.
FONTE      §2.2, §2.3, §2.4 (mql5.com/en/vps [VERIFICATO 05/09])
COSTO      ~20 minuti di Claudio. EUR 0.
RISCHIO    Nessuno sul conto. Unico accorgimento: NON completare la
           migrazione MQL5 VPS (sposterebbe l'ambiente di un terminale
           vivo) - si guarda la schermata e si annulla.
RESA       Chiude l'[INCERTO] di §2.2 e decide se il filone VPS e' morto
           o vivo. E' la proposta con il miglior rapporto resa/costo del
           dossier.
```

### 🥈 P2 — Censire cosa dice DAVVERO il broker sui simboli (M5, M6)
```
PROPOSTA   Aggiungere a ABTG_InfoBroker.mq5 la lettura di:
           SYMBOL_TRADE_EXEMODE (Instant/Request/Market/Exchange),
           SYMBOL_TRADE_STOPS_LEVEL, SYMBOL_TRADE_FREEZE_LEVEL,
           SYMBOL_SPREAD_FLOAT, SYMBOL_FILLING_MODE,
           piu' TERMINAL_PING_LAST (/1000 = ms) e TERMINAL_RETRANSMISSION.
DOVE       mql5/Scripts/ABTG_InfoBroker.mq5 (uno SCRIPT, non un EA:
           non tocca niente di vivo, si esegue e stampa).
FONTE      §2.1, §2.3 - doc MQL5 [VERIFICATO 05/09]; buchi M5, M6, M10.
COSTO      ~1 ora di sviluppo, 1 esecuzione. Nessun round di test.
RISCHIO    Praticamente nullo (script di sola lettura).
RESA       Dice se i nostri 61 SetDeviationInPoints(30) servono a
           qualcosa o sono decorativi. E' la premessa di P4.
```

### 🥉 P3 — Accendere il filtro spread coi valori MISURATI (M1, M2, M3)
```
PROPOSTA   Nei preset delle sedie sui tre indici, portare InpMaxSpread
           da 0 (spento) al P95 in sessione misurato il 03/09:
             NASUSD 270 · U30USD 300 · D30EUR 190 (270 se lavora all'ora 8)
           Valori in punti MT5 (1 pto indice = 100 pti MT5, MISURATO).
DOVE       Preset .set delle sedie, NON il codice: l'input esiste gia'
           in 86 EA su 104. Nessuna ricompilazione.
FONTE      SPREAD_FLOTTA_MISURA_2026-09-03 §2 + M2/M3 (§3), con la
           controprova esterna del preset US30 del vendor (300).
COSTO      ~1 ora per scrivere i preset. Va misurato PRIMA in backtest:
           1 corsa di confronto per sedia (con/senza filtro), per
           contare quanti trade il filtro sopprime.
RISCHIO    🔴 REALE e da misurare prima: un cap troppo stretto non
           riduce il costo, SOPPRIME i trade. Su una sedia a bassa
           frequenza puo' azzerare il campione e rompere il contratto di
           frequenza (criterio TAGLIANDO, 18/08). Per questo il P95 e
           non la mediana - e per questo si misura, non si applica.
           Secondo rischio: il P95 e' calcolato su 2024.09-2026.06; se
           BCM cambia il listino, il numero invecchia.
```

### P4 — Rivedere la deviazione, ma solo DOPO P2
```
PROPOSTA   Se P2 dice Instant/Request Execution: rendere la deviazione
           un input per simbolo invece di 30 hardcoded (30 pti MT5 =
           0,30 punti indice: e' un sesto dello spread mediano, quindi
           oggi RIFIUTEREBBE quasi ogni riempimento normale).
           Se P2 dice Market Execution: NON toccare niente e scriverlo
           agli atti - la deviazione e' ignorata, e ogni ora spesa li'
           e' sprecata.
DOVE       input nuovo nei singoli EA (non il Guardian).
FONTE      §2.1 [VERIFICATO], M4/M5.
COSTO      0 ore se Market Execution. ~3 ore + 1 round se Instant.
RISCHIO    Una deviazione troppo stretta in Instant Execution genera
           REQUOTE: l'ordine non entra e il segnale si perde. E' il
           modo tipico in cui si "risolve" lo slippage smettendo di
           fare trade.
DIPENDE DA P2. Non si esegue prima.
```

### P5 — Deviazione sulla chiusura d'emergenza del Guardian (M11)
```
PROPOSTA   ABTG_Guardian.mq5 usa CTrade (riga 78) e non chiama MAI
           SetDeviationInPoints prima di PositionClose (riga 319) /
           OrderDelete (riga 327). Aggiungere una deviazione ESPLICITA
           e LARGA (input, default alto), non stretta.
DOVE       ABTG_Guardian.mq5, magic 779001.
FONTE      audit del sorgente 05/09 (M11).
COSTO      ~30 minuti + il canale di autotest che il Guardian ha gia'
           (InpAutotest, riga 70).
RISCHIO    🔴 IL RISCHIO E' AL CONTRARIO DI QUELLO CHE SEMBRA. Il
           Guardian chiude ai muri (4,9% / 9,9%): cioe' esattamente
           quando il mercato corre e lo spread e' largo. Una deviazione
           STRETTA farebbe FALLIRE la chiusura d'emergenza - il
           risultato peggiore possibile per una challenge. Quindi:
           larga, o esplicitamente illimitata. Da confermare con P2:
           se e' Market Execution, la riga non serve e la proposta
           decade (ma va scritto perche').
```

### P6 — Il pavimento di stop contro lo slippage vero (M8)
```
PROPOSTA   Portare il tema in un round: InpMinStopPts = 500 sul Dow
           (5,0 punti indice) contro uno slippage misurato di 21,5.
           Il pavimento e' 4,3 volte PIU' PICCOLO dello slippage
           osservato su uno stop reale.
DOVE       proposta di CRITERIO per i round futuri sugli indici, non
           una modifica: il pavimento va dimensionato su
           spread P95 + slippage osservato, non su un numero tondo.
FONTE      R109_REFERTO §fatto collaterale 2 + SPREAD_FLOTTA §2.
COSTO      la decisione e' gratis; la ritaratura costa un round per
           famiglia.
RISCHIO    Alzare il pavimento riduce il numero di setup ammessi
           (InpSkipIfTight scarta i trade troppo stretti) -> stessa
           trappola di P3 sulla frequenza.
NOTA       ⚠️ Un solo evento di slippage non e' una distribuzione.
           Prima di ritarare servirebbe la DISTRIBUZIONE dello
           slippage, non l'aneddoto. Vedi P7.
```

### P7 — Misurare la distribuzione dello slippage (il buco piu' onesto)
```
PROPOSTA   Oggi abbiamo UN numero (21,5 punti, un evento, R109).
           Non e' una misura, e' un aneddoto. Serve: per ogni deal di
           chiusura su SL, lo scarto fra prezzo SL richiesto e prezzo
           eseguito, in punti indice, con mediana/P95/max, per simbolo
           e per ORA.
DOVE       lettura dei deal (stesso canale di R109_INDAGINE_DEAL) +
           campo aggiuntivo nell'export per-trade.
FONTE      §1.4 - lo slippage vale 11x lo spread: e' il numero grande,
           ed e' l'unico che non abbiamo.
COSTO      ~3 ore (parser) + i dati sono gia' negli zip dei round.
RISCHIO    Nessuno sul conto (analisi su dati passati).
RESA       🥇 Senza questo, P6 e' un'opinione e tutto il mandato
           "abbassare lo slippage" non ha un metro. CON questo, il
           progetto ha per lo slippage cio' che dal 03/09 ha per lo
           spread: una misura oraria invece di una convenzione.
           👉 Se Claudio ne sceglie UNA sola dopo P1, e' questa.
```

### P8 — Le 9 domande al broker (§4)
```
PROPOSTA   Mandare D0-D8 a BCM via ticket, con richiesta di risposta
           scritta (regola D3 di casa).
DOVE       fuori dal repo. La risposta torna in report/.
COSTO      ~30 minuti.
RISCHIO    Nessuno. ⚠️ D6 (demo = reale?) puo' dare una risposta
           SCOMODA: se la demo non simula lo slippage, tutto il forward
           su 50504263 e' ottimista su questa dimensione. E' meglio
           saperlo prima di comprare una challenge.
```

---

## 7. 🧭 COSA NON HO POTUTO VEDERE — l'elenco, senza sconti

1. **Nessuna pagina ufficiale BCM.** Tipi di conto, spread, commissioni,
   contract specs: tutto [LETTO-VIA-SEARCH], niente [VERIFICATO].
2. **Nessun numero pubblico sullo spread degli INDICI di BCM.** E' proprio
   dove ci fa male, ed e' un buco totale.
3. **Se `bcm-markets.com` e `bcmmarkets.com` siano la stessa societa'.**
   Non verificato. → D0.
4. **Dove sta fisicamente `BCMMarkets-Server`.** Nessuna fonte apribile.
   → P1 (misura) e D8 (domanda).
5. **Il ping del NOSTRO VPS.** Non misurabile da qui, per costruzione. Ho
   dato il metodo (§2.3), non il risultato.
6. **Se la demo BCM replichi il reale.** Nessuna fonte specifica su BCM; solo
   il consenso generale (demo senza slippage). → D6.
7. **Se BCM abbia scaglioni di volume.** Nessuna traccia. → D7.
8. **La modalita' di esecuzione dei nostri simboli.** Decide se meta' del
   §3 e' rilevante o decorativa. → P2, ed e' misurabile in casa.
9. **La distribuzione dello slippage.** Abbiamo un solo evento. → P7.

---

## 8. 📌 LA RIGA CHE RESTA

> **Lo spread su BCM in sessione (1,6-2,0 punti indice) e' gia' buono e non e'
> il nostro problema. Il nostro problema e' lo slippage — che vale ~11 volte
> lo spread — e il VPS NON lo risolve, perche' i nostri stop sono depositati
> al broker ed eseguiti dal broker.**
>
> Le tre cose vere da fare, in ordine: **misurare il ping** (20 minuti, chiude
> il filone 2 in un senso o nell'altro), **misurare la distribuzione dello
> slippage** (l'unico numero grande che non abbiamo), **accendere il filtro
> spread coi P95 che abbiamo gia' misurato il 03/09** — perche' oggi quel
> filtro esiste in 86 EA su 104, e' spento in 75, ed e' spento su **tutte** le
> sedie indici vive.
