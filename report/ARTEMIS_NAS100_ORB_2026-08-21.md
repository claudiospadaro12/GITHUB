# 🔎 `Artemis-NAS100-ORB-Edge-M5-MT5-v1.30` — lettura del `.set`

_21/08/2026, notte. File ricevuto: **solo il `.set`** (parametri), **NESSUN
`.mq5`/`.ex5`**. E' un prodotto commerciale (nome "Artemis", pannello
"Graphite Command Deck" con tab dedicati): il codice non lo vediamo, quindi
tutto quello che segue viene **dai NOMI e dai VALORI dei 130+ parametri**, non
da una lettura di logica. Dove il nome non basta a capire il comportamento
esatto, lo dico._

⚠️ **NON e' lo stesso file del `DIEGO_Nasdaq_Bands_Indicator`** analizzato
poco fa (`INDICATORE_DIEGO_NASDAQ_2026-08-21.md`). Quello era un
**indicatore** (disegna livelli, non tradа). Questo e' un **EA completo**,
magic proprio (`26060701`), con gestione del rischio, filtri, recovery e
pannello grafico. **Chiedo conferma a Claudio se sono collegati** (stesso
autore/community?) o due cose scoperte separatamente — cambia come trattarli

---

## 0. ✅ PROVENIENZA VERIFICATA (21/08 notte, dopo la risposta di Claudio: *"L'HO TROVATO SULLO STORE DI MT5, SARA' DI UN UTENTE"*)

Cercato sullo Store MQL5: **e' un prodotto reale, in vendita**.

| | |
|---|---|
| Nome | **Artemis NAS100 Orb Edge EA** |
| Autore | **Nathan James Gilks** |
| Prezzo | **59 USD** |
| Recensioni | **5 stelle, ma su 1 SOLA recensione** — campione nullo |
| Pubblicato | 04/06/2026 · versione attuale **1.30** aggiornata **16/08/2026** (5 giorni fa) |
| Fonte | [mql5.com/it/market/product/179855](https://www.mql5.com/it/market/product/179855) (pagina MT4; il nostro `.set` e' esplicitamente "M5-MT5", stesso autore/prodotto in build MT5) |

**Due cose confermate DALL'AUTORE STESSO, che corroborano la lettura fatta a mano dal `.set`:**

1. *"No Martingale system explicitly used in default configuration. Recovery
   Ladder included as optional advanced module but **disabled** in release
   settings."* → **conferma esatta** di quanto scritto al punto 2: il modulo
   c'e', e' spento di default, l'autore stesso lo dichiara opzionale/avanzato.
2. *"Confirm New York opening time matches **your broker's** chart
   timezone."* → l'autore **stesso** avverte che l'ora va confermata per
   ogni broker. Non e' un difetto nascosto: e' un passo di setup dichiarato,
   che pero' **nessuno ha ancora eseguito su BCM** (vedi punto 3).

📌 **Il rating (5 stelle) non vale come misura**: una recensione sola non e'
un campione, e' aneddoto. Non cambia il giudizio.
nel round.

---

## 1. 🎯 COS'E': un ORB a doppia gamba (straddle OCO) sulla campana USA, con un motore di stato mercato sopra

Dalle sezioni si ricostruisce una macchina a strati:

1. **Market State Engine** (`__ENGINE_SECTION`): su M15, ATR(14) + MA veloce
   (20) / lenta (50), classifica la giornata come **trend** o **chop**
   (soglie `TrendATRThreshold 0.8` / `ChopATRThreshold 0.35`). E' un filtro di
   **regime**, cosa che i nostri EA in questa famiglia non hanno.
2. **ORB Pro** (`__ORB_PRO_SECTION`): range **15 minuti**, finestra di trading
   **60 minuti** dopo, buffer di rottura **12 punti**, stop **1.0×ATR**,
   TP **3.5R**. Filtri opzionali (EMA, pendenza EMA, conferma multi-timeframe,
   forza di chiusura, VWAP, momentum, "stanza" per il movimento) **TUTTI
   spenti di default** (`false`).
3. **OCO Straddle** (`__OCO_SECTION`): buffer d'ingresso **18 punti**,
   cancella il lato opposto al riempimento, **flip reversal** possibile
   (se un lato stoppa, puo' aprire dall'altro).
4. **Liquidity Sweep module** (`__SWEEP_SECTION`): un **secondo motore**,
   indipendente dall'ORB, su finestra 14-16 (ora del pannello, non ancora
   tradotta in server) — **SPENTO di default** (`InpUseLiquiditySweepContinuation=false`).
5. **Gestione** (`__MANAGEMENT_SECTION`): breakeven a 0,9R, **tre TP
   parziali** (1,2R/25% · 2,5R/35% · 4,0R/40%), chiusura finale a 5R,
   trailing ATR.

📌 **Rispetto al `DIEGO_Nasdaq_Bands` e al nostro `ABTG_ORB_Ottimizzato`**,
questo e' un ordine di grandezza piu' elaborato: non e' "ORB con altri
numeri", ha **uno strato di filtro di regime sopra l'ORB** e **un secondo
motore separato** (sweep). Non e' automaticamente "il nostro ORB con parametri
diversi" — la regola della seconda caccia lo classificherebbe come
**meccanismo potenzialmente diverso**, da verificare con la sua fonte
(sconosciuta) prima di scartarlo per somiglianza.

---

## 🔴 2. LA BANDIERA ROSSA: **C'E' UN MODULO DI RECOVERY/GRIGLIA — spento, ma c'e'**

```
__RECOVERY_SECTION====== ADVANCED F. RECOVERY LADDER / BASKETGUARD =====
InpUseArtemisRecoveryLadder=false
InpRecoveryMaxLayers=3
InpRecoverySpacingATR=0.85
InpRecoveryLotMultiplier=1.2
...
InpRecoveryHardStopPercent=3.0
```

**"Recovery Ladder"** con **layer multipli**, **spaziatura in ATR** e un
**moltiplicatore di lotto (1,2x per layer)** e' — per nome e per struttura —
un **martingala/griglia a scaglioni**, esattamente la categoria che
`METRO_PROP.md` §13 misura a parte (unita' PACCHETTO) e che il progetto
guarda con sospetto per le regole prop.

✅ **E' spento di default** (`false`), e questo e' il default che va
**rispettato, mai acceso senza una misura dedicata**. Ma la sua sola presenza
significa:
- se qualcuno (anche per sbaglio, un click nel pannello "Command Deck") lo
  accende, il profilo di rischio dell'EA cambia **radicalmente** — da un ORB
  a rischio fisso a un sistema che **aumenta l'esposizione dopo una perdita**;
- **`InpRecoveryHardStopPercent=3.0`** e' l'unico argine dichiarato, ed e' un
  cap sul singolo basket — **da confrontare col nostro cap C1 (3,25% di
  rischio aperto simultaneo)** prima di fidarsene, se mai si aprisse questa
  porta.

📌 **Per ora non e' un problema**: e' spento. **Ma va scritto nei criteri del
round come CANCELLO**: *"il round misura SOLO con `InpUseArtemisRecoveryLadder=false`.
Se un giorno si vuole misurare la ladder, e' un round A PARTE, con i suoi
criteri, non un'opzione dentro questo."*

---

## 3. ⏰ L'ORARIO — stessa classe di dubbio del file di Diego, ma qui e' PIU' esplicito

```
__TIME_SECTION====== 04. SESSION TIMES - MT4 CHART TIME =====
InpBrokerUTCOffsetHours=2
InpAutoDetectBrokerOffset=true
...
InpNYOpenStartHour=16
InpNYOpenStartMinute=30
```

Qui l'EA **dichiara la propria convenzione**: gira su **"MT4 CHART TIME"**
con un **offset UTC di broker = 2** dichiarato esplicitamente, e "apertura NY"
= **16:30** in quella convenzione. Con offset UTC+2 (l'ipotesi di broker
"europeo standard" gia' vista nel file di Diego), 16:30 di quel fuso
corrisponde a... **le 15:30 IT solo se quell'ora e' gia' locale europea** —
cioe' la stessa identificazione: **apertura NY alle 16:30 di un chart a
UTC+2** = **15:30 UTC+1 (IT in inverno)** o va verificato per l'estate.

✅ **A differenza del file di Diego, qui c'e' `InpAutoDetectBrokerOffset=true`**:
l'EA **dichiara di autorilevare** l'offset del broker, quindi — se quella
funzione lavora davvero — **il numero 2 scritto nel `.set` potrebbe essere
solo un valore di default/fallback, non quello che user davvero a runtime**.

📌 **Non si puo' verificare senza il codice.** Quello che si puo' fare senza
sorgente: **installarlo su BCM e leggere, come per Diego, quale candela M5
viene marcata come inizio range** (`InpDrawORBOnChart=true`,
`InpDrawORBFill=true` sono gia' accesi: il disegno sul grafico c'e' di
default). Confrontarla con l'apertura vera BCM (14:30 server = 15:30 IT).

---

## 4. 📋 ALTRI PUNTI DA SEGNALARE, IN BREVE

- **`InpRiskPercent=0.2`**: molto sotto il nostro 0,80-1,0% standard. Se
  questo e' il valore RACCOMANDATO dal venditore per NAS100, e' un dato da
  confrontare (magari il motore ha una varianza/DD nativi piu' alti e per
  questo consiglia rischio piu' basso — **da scoprire, non da assumere**).
- **`InpMaxSpreadPoints=900`**: e' un numero enorme o piccolo a seconda
  dell'unita' di "punto" per NAS100 su BCM — **da verificare col simbolo
  vero**, non prendere a scatola chiusa.
- **`InpUseReducedRiskHighVol=true` + `InpHighVolRiskMultiplier=0.5`**: c'e'
  gia' un adattamento del rischio alla volatilita' — coerente col
  Market State Engine del punto 1.
- **`InpCheckDuplicateMagic` / `InpBlockOnDuplicateMagic`**: l'EA si
  autoprotegge da doppie istanze con lo stesso magic — buona prassi,
  coincide con quello che noi verifichiamo a mano (`$MagicVietati`).
- **`InpWarnBrokerCalibration=true`**: l'EA stesso sa che la calibrazione sul
  broker e' un problema e avvisa — coerente col punto 3.
- **Nessun riferimento a filtro notizie**: a differenza dei nostri EA
  (`InpUseNewsFilter`), qui non c'e' — da verificare se manca davvero o se
  e' in una sezione non vista nel `.set` (i `.set` esportano solo gli input
  dichiarati `input`, quindi se non c'e' la riga, il parametro non esiste).

---

## 5. ➡️ COSA SERVE PRIMA DI METTERLO IN UN CRITERIO

1. **Il sorgente, o almeno la demo/trial**: senza, non si puo' sapere se
   `InpAutoDetectBrokerOffset` funziona davvero, ne' leggere la logica del
   Market State Engine o del flip reversal.
2. **La provenienza**: e' un prodotto a pagamento? Community? Lo stesso
   contesto della domanda gia' fatta per Diego — la risposta cambia quanto
   ci si puo' fidare dei numeri (0,2% rischio, 3,5R target, le soglie ATR).
3. **La verifica dell'ora su BCM**, come per Diego: installarlo su NAS100 M5
   e leggere dove disegna il range.
4. **Se e' collegato al file di Diego** (chiesto sopra): stesso autore?
   Diego e' un cliente di questo prodotto che ha condiviso solo
   l'indicatore delle bande?

**Fino ad allora**: questo file **non entra nei criteri del round Nasdaq**
come motore — resta agli atti come **secondo riferimento** su come altri
strutturano un ORB su NAS100, utile soprattutto per il confronto sui NUMERI
(stop in ATR anziche' fisso, TP multi-R con parziali, filtro di regime sopra
l'ORB) piu' che come codice da copiare.

## ⚫ E LA RECOVERY LADDER RESTA SPENTA. Punto. Se un giorno si vuole
misurarla, e' un round a parte con i suoi criteri — mai un interruttore
dentro il round dell'ORB.
