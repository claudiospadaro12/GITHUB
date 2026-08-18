# 📰 POST NEWS — SPECIFICA IMPLEMENTABILE RICOSTRUITA DAL CORSO

**Fonte:** 9 trascrizioni, lezioni **2-10** del master (capitolo 5, "la prima
strategia"), in
`backtest_pipeline/caccia_strategie/trascrizioni_corso_2026-08-18/modulo_postnews/`
— **~78.500 caratteri, letti per intero, riga per riga.**

**Referto narrativo (schede lezione per lezione, contraddizioni, aritmetica):**
`backtest_pipeline/caccia_strategie/ANALISI_CORSO_POSTNEWS_2026-08-18.md`
— qui NON si duplica: qui c'e' solo cio' che serve a scrivere il codice.

**Etichette:** `[T]` = testuale nella trascrizione (cito) · `[I]` = inferito
(dico da dove) · `[?]` = incerto · `[T-dubbio]` = trascritto ma il numero
potrebbe essere un errore di speech-to-text.

> 🔒 **Nessuna modifica al forward. Nessun EA toccato. Nessun round lanciato.**
> Questa e' una specifica, non un ordine di esecuzione. Decide Claudio.

---

## 0. 🎯 IL VERDETTO DI MECCANIZZABILITA'

> ## **77% SECCO — 20 decisioni su 26 sono dettate a voce con un numero.**
> ## **92% con 4 assunzioni dichiarate. E' il modulo PIU' meccanizzabile dei sei.**

E non e' un caso: **e' l'unico modulo che si autodefinisce meccanico** `[T]`
lez. 2: _"Il concetto di una strategia meccanica e' quello di **non dover mai
prendere una decisione** … la strategia meccanica ti dice precisamente quando
fare l'operazione, su quale tasso di cambio, se devi comprare o vendere e come
gestire l'operazione"_ — e lez. 5: _"questa cosa la faranno esattamente uguale
tutte le persone che applicheranno questa strategia … **faremo tutti la stessa
cosa perche' e' una strategia meccanica**"_.

| | Breakout | Mediazione | Fibo H4 | Media 200 | Point Break | **POST NEWS** |
|---|---:|---:|---:|---:|---:|---:|
| meccanizzabilita' secca | 55% | ~50% | 50% | 48% | non-strategia | **77%** 🥇 |

### 🟢 Le tre cose che questo modulo ha e gli altri cinque NO

1. **Il FUSO E' DICHIARATO.** Tutti gli orari sono **ora italiana**, detto
   esplicitamente e ripetuto 6 volte `[T]` (lez. 3: _"la cosa importante che
   devi verificare e' che qua ci sia **l'ora italiana**"_; lez. 9: _"la notizia
   era alle 19.30 **ora italiana**"_). Negli altri moduli il fuso era il buco
   n.1.
2. **L'ARITMETICA DEI DUE ESEMPI TORNA AL CENTESIMO** (§7): prezzi, SL, TP e
   perfino il **lotto** dei due casi pratici sono verificati esatti. Negli altri
   moduli i conti si rompevano.
3. **L'USCITA E' DETERMINATA**: TP 50 / SL 25 / scadenza dei pendenti, senza
   "a discrezione". Rompe il filo rosso degli altri cinque moduli — con
   un'eccezione sola (il trailing opzionale, D20).

### 🔴 E le tre che mancano
1. **Il backtest non e' verificabile** e per la parte piu' vecchia **non e'
   nemmeno producibile con lo strumento insegnato** (§8).
2. **Il rischio suggerito (3% per evento) e' 4,6x il nostro** e non passa il
   metro prop (§6).
3. **Nessun filtro spread/slippage**, sostituito da un'ASSERZIONE (§9.2).

---

## 1. LA TESI, COME LA DICHIARA IL CORSO

`[T]` lez. 4, ed e' l'unica giustificazione logica che viene data:

> _"Devi cominciare a capire che di notizie macroeconomiche fondamentalmente ne
> esistono di due tipi. Il rilascio di **un dato numerico** e situazioni in cui
> invece **una persona parla**."_

- Sul **dato numerico** (CPI, GDP, disoccupazione, tassi): _"nel secondo in cui
  esce quel dato il mercato reagisce in modo violentissimo … se anche imposti
  uno stop loss, **non puoi essere sicuro che quella sara' la tua perdita
  massima. Il tuo stop loss puo' essere saltato**"_ `[T]` → **queste notizie
  NON si tradano**.
- Sulla **conferenza stampa** (una persona che parla): _"c'e' una reazione del
  prezzo molto meno esplosiva, ma molto piu' **dosata nel tempo** … andando a
  cavalcare quei **trend a breve e medio periodo** che quasi sempre si formano
  in concomitanza con una persona che parla"_ `[T]` → **queste si**.

**La tesi in una riga, come la testerebbe un tester:** durante una conferenza
stampa di banca centrale il prezzo esce dal range dei primi 10-15 minuti e
prosegue nella direzione della rottura per almeno 50 pip prima di ritracciare
di 25.

⚖️ **Cosa NON e' dimostrato:** che la reazione a una conferenza stampa sia
diversa **in modo misurabile** da quella a un dato numerico. E' un'asserzione
qualitativa, ripetuta tre volte, mai quantificata. **E' esattamente cio' che un
nostro backtest puo' falsificare** (§10, test P2).

---

## 2. LE DUE NOTIZIE E I LORO PARAMETRI — la tabella madre

| | 🇪🇺 **ECB Press Conference** | 🇺🇸 **US FOMC Press Conference** |
|---|---|---|
| **strumento** | **EUR/JPY** `[T]` lez. 5 (_"la traderai **sempre** sul cross euro-yen, sempre"_) | **EUR/USD** `[T]` lez. 8 |
| **timeframe** | **M5** `[T]` (_"nella strategia post-news **per tutte le notizie** il time frame sara' sempre 5 minuti"_) | **M5** `[T]` |
| **orario notizia** | **14:45 ora italiana** `[T]` lez. 5 (era **14:30 fino a meta' 2022** `[T]`) | **20:30 IT** in ora legale / **19:30 IT** nelle finestre di disallineamento `[T]` lez. 8 — ⚠️ la regola generale che ne da' e' SBAGLIATA, vedi §4.2 |
| **frequenza dichiarata** | 8/anno, giovedi, ogni 6 settimane `[T]` | 8/anno `[I]` (mai detto: si ricava da _"16 operazioni all'anno"_ lez. 10) |
| **candele di riferimento** | le **DUE DOPO** quella della notizia (14:50 e 14:55) — **la candela della notizia si IGNORA** `[T]` | la candela **DELLA notizia** + la successiva (20:30 e 20:35) `[T]` |
| **istante d'azione** | **15:00 IT** = notizia **+15 min** `[T]` | **20:40 IT** = notizia **+10 min** `[T]` (_"qui anticipiamo di 5 minuti"_) |
| **livelli** | max e min **fra le due candele, ombre incluse** `[T]` (_"ovviamente considerando anche le ombre"_) | idem `[T]` |
| **ordine 1** | **BUY STOP a high + 3 pip** `[T]` | idem `[T]` |
| **ordine 2** | **SELL STOP a low − 2 pip** `[T]` (2 volte, lez. 5 e 6) | idem `[T]` lez. 8 |
| **TP / SL** | **50 / 25 pip** su ciascuno dei due `[T]` | **50 / 25** `[T]` |
| **OCO** | ❌ **NO, esplicito** `[T]` (§3.4) | ❌ **NO** `[T]` |
| **scadenza PENDENTI** | **18:15 IT** dello stesso giorno `[T]` (= notizia +3h30) | **notizia + 75 minuti** `[T]` (20:30→21:45 / 19:30→20:45) |
| **scadenza POSIZIONE** | ❌ **nessuna** `[T]` esplicito (§3.5) | ❌ **nessuna** `[T]` |
| **trailing** | **si, opzionale**: a +25 pip di profitto, SL da −25 a **−15** `[T]` | ❌ **niente** `[T]` (_"qua non devi fare niente"_) |
| **chiusura forzata** | venerdi **22:50 IT** se ancora aperta `[T]` | idem `[T]` |
| **rischio** | **3% per evento**, size calcolata su **50 pip** `[T]` (§6) | idem `[T]` |

### 2.1 🧭 Gli stessi orari in ORA SERVER BCM (regola di casa: server = IT − 1)

⚠️ **Conversione lecita perche' la fonte DICHIARA il fuso** (ora italiana). Per
tutti gli altri moduli questa conversione era vietata.

| evento | notizia | azione | scadenza pendenti |
|---|---|---|---|
| **ECB** | 14:45 IT → **13:45 BCM** | 15:00 IT → **14:00 BCM** | 18:15 IT → **17:15 BCM** |
| **FOMC** (20:30 IT) | → **19:30 BCM** | 20:40 IT → **19:40 BCM** | 21:45 IT → **20:45 BCM** |
| **FOMC** (19:30 IT, solo finestre di disallineamento) | → **18:30 BCM** | → **18:40 BCM** | → **19:45 BCM** |

🔴 **`[?]` Il "−1" e' verificato solo per QUESTO periodo dell'anno**
(`CLAUDE.md`: _"in questo periodo"_). Se BCM segue l'ora legale, il delta
Italia→server resta −1 tutto l'anno e le righe sopra valgono sempre; se non la
segue, d'inverno cambia. **Non e' misurato. Da verificare su un grafico di
gennaio prima di qualunque forward.** La soluzione robusta e' non usare orari
fissi: §5.

---
