# 📐 FASE A — i numeri del movimento all'apertura (8 indici, tick reali)

_03/08/2026. `ABTG_Apertura_Study_EA`: simula il breakout cieco (buffer 200 pt, slippage 100 pt, **stop 1R, TP 2R**, nessun trailing, nessun filtro) e misura MAE/MFE/durata trade per trade._
_~440 trade per indice su ~625 giorni di borsa · ~3 500 trade totali · DAX/FTSE/IBEX/EuroStoxx/CAC dalle 08:00, Nasdaq/S&P/Dow dalle 14:30 (ora server)._

---

## 🔴 1. La cosa più importante, e non è quella che mi aspettavo

**Aspettativa del breakout cieco, in R per trade:**

| Indice | R/trade | | Indice | R/trade |
|---|---|---|---|---|
| **U30USD (Dow)** | **+0,074** ✅ | | E35EUR (IBEX) | −0,048 |
| D30EUR (DAX) | +0,026 | | E50EUR (EuroStoxx) | −0,048 |
| NASUSD | +0,001 | | F40EUR (CAC) | −0,056 |
| SPXUSD | −0,017 | | 100GBP (FTSE) | −0,138 |

Su otto indici, **sette sono a zero o sotto**. Il DAX a +0,026 R e il Nasdaq a +0,001 R non sono un margine: sono rumore. L'unico che si stacca è il **Dow, +0,074 R/trade**.

### ⚠️ Questo corregge quello che ho scritto il 03/08

Nel `FORWARD_03-08_PROVA_GESTIONE.md` ho concluso: *"Non abbiamo un problema di selezione: entriamo bene, confermiamo bene, e usciamo dopo tre minuti."*
**Su cinque trade era una lettura plausibile. Su 3 500 non regge.** Con una gestione pulita — stop a 1R, TP a 2R, nessun trailing che tagli niente — il breakout cieco all'apertura **non produce margine su quasi nessun indice**. Non entriamo bene: entriamo a caso, e il caso all'apertura vale zero.

Le due cose però convivono, e la distinzione conta:
- **la gestione stretta distrugge valore** (il 14% catturato del 03/08 è reale);
- **aggiustare la gestione porta da "negativo" a "zero", non da "zero" a "buono"**.
Il margine, se c'è, va cercato nella **selezione** — ed è coerente con l'ablazione, dove l'unico filtro che sposta il Nasdaq (0,90 → 1,15) è il volume.

## 🎯 2. Spostare il TP non salva niente

Ricalcolo esatto dell'aspettativa a TP variabile. È lecito perché **MFE è misurato dentro la vita del trade**: se un perdente ha MFE 1,5R, quel livello è stato toccato *prima* dello stop.

| Indice | oggi (TP 2R) | migliore TP possibile | dove |
|---|---|---|---|
| U30USD | +0,074 | **+0,103** | 1,5R |
| D30EUR | +0,026 | +0,055 | 1,25R |
| NASUSD | +0,001 | +0,009 | 1,75R |
| F40EUR | −0,056 | −0,008 | 1,0R |
| E35EUR | −0,048 | −0,012 | 1,25R |
| E50EUR | −0,048 | −0,029 | 0,75R |
| SPXUSD | −0,017 | −0,018 | 2,0R |
| 100GBP | −0,138 | −0,068 | 0,75R |

**Nessun TP porta un indice in territorio davvero positivo**, e il TP "migliore" cambia da simbolo a simbolo saltando avanti e indietro (DAX: 0,028 / 0,040 / 0,051 / **0,055** / 0,020 / 0,036 / 0,026 — non è una curva, è rumore). Se ci fosse una distanza giusta, si vedrebbe una gobba. Non c'è.

## 💡 3. "Ero a più e il mercato si è girato" — non è sfortuna, è la regola

Percentuale di trade **perdenti** che erano già in profitto prima di morire:

| Indice | ≥0,3R | ≥0,5R | ≥0,75R | ≥1,0R |
|---|---|---|---|---|
| **D30EUR** | **62%** | **48%** | 34% | **23%** |
| NASUSD | 62% | 42% | 28% | 14% |
| U30USD | 58% | 43% | 28% | 19% |
| F40EUR | 58% | 42% | 26% | 19% |
| E50EUR | 58% | 39% | 27% | 16% |
| 100GBP | 57% | 40% | 28% | 18% |
| SPXUSD | 53% | 36% | 23% | 15% |
| E35EUR | 51% | 31% | 18% | 14% |

**Sul DAX, quasi la metà dei trade perdenti ti ha prima mostrato mezzo R di profitto, e uno su quattro un R intero.** La domanda del 03/08 (*"aveva aperto bene, ero a più ed il mercato si è girato"*) ha una risposta strutturale: succede **nel 48% dei casi persi**.

Da qui viene l'unico argomento forte a favore del **breakeven**: portare in pari a 0,5R convertirebbe ~127 R di perdite in ~0 sul DAX. **Ma il costo non è misurabile con questi dati**, perché anche i vincenti respirano parecchio (MAE mediano 0,37R) e non so se quel respiro arriva prima o dopo il +0,5R. **È esattamente la domanda della FASE B**, che lo misura sui P&L veri.

## ⏱️ 4. Il 39 secondi del 03/08, spiegato

Durata mediana in barre M5:

| Indice | VINCENTI | PERDENTI |
|---|---|---|
| D30EUR | 27 barre = **135 min** | 11 barre = 55 min |
| NASUSD | 16 barre = **80 min** | 8 barre = 40 min |
| U30USD | 14 barre = 70 min | 9 barre = 45 min |
| F40EUR | 35 barre = 175 min | 15 barre = 75 min |
| 100GBP | 43 barre = 215 min | 14 barre = 70 min |

**Il vincente mediano sul DAX ha bisogno di 135 minuti. Il nostro EA ha chiuso in 39 secondi.** Non è un trailing "un po' stretto": è un ordine di grandezza sbagliato — opera su una scala temporale che non c'entra nulla col fenomeno.

Su **tutti e otto** gli indici il vincente dura **2–3 volte** il perdente. L'asimmetria è reale, ma sfruttarla col solo tempo rende poco: se il trade è vivo dopo 12 barre la probabilità di vittoria sul DAX sale da 32% a 40%, e poi si ferma. **Aspettare aiuta un po'; non decide.**

## ✅ 5. Lo stop a 1R è giusto — non stringerlo

MAE dei trade **vincenti** (quanto vanno contro prima di andare a favore), in R:

| Indice | p50 | p75 | **p90** | p95 |
|---|---|---|---|---|
| D30EUR | 0,37 | 0,63 | **0,80** | 0,86 |
| NASUSD | 0,27 | 0,58 | **0,79** | 0,91 |
| U30USD | 0,24 | 0,57 | **0,87** | 0,93 |
| F40EUR | 0,37 | 0,58 | **0,79** | 0,85 |

Un vincente su dieci va contro di **0,80R o più** prima di girarsi. Stringere lo stop a 0,8R per "rischiare meno" ne ucciderebbe il 10%. **Il dimensionamento attuale (ATR ×1,5) è confermato dai dati: si lascia com'è.**

## 🌍 6. Il filtro trend H4 divide il mondo in due

| Indice | cieco | con filtro H4 | Δ |
|---|---|---|---|
| **NASUSD** | +0,001 | **+0,055** | **+0,054** ✅ |
| **U30USD** | +0,074 | **+0,126** | **+0,052** ✅ |
| SPXUSD | −0,017 | −0,002 | +0,015 ✅ |
| 100GBP | −0,138 | −0,137 | ~0 |
| E50EUR | −0,048 | −0,068 | −0,020 ❌ |
| **D30EUR** | +0,026 | −0,017 | **−0,043** ❌ |
| F40EUR | −0,056 | −0,109 | −0,053 ❌ |
| E35EUR | −0,048 | −0,129 | −0,081 ❌ |

**Sui tre indici USA il trend H4 aiuta; sui quattro europei fa danno.** Non è un caso isolato: la separazione è netta e ordinata.

⚠️ **Contrasto da chiarire**: nell'ablazione il gradino "EMA H4" peggiorava il Nasdaq (0,99 → 0,81). Sono due cose diverse — lì era `InpUseEmaFilter` con EMA 1/50 su H4, sopra una base già guastata dall'OR; qui è il trend H4 dello studio su base pulita. **[INCERTO] finché non si testa lo stesso filtro nello stesso modo.** Non uso nessuno dei due come conclusione.

---

## 🧭 Cosa cambia nel piano

1. **Il Dow è il miglior mercato che abbiamo, e lo stiamo trascurando.** +0,074 R cieco, +0,126 col filtro H4, +0,103 con TP 1,5R. È il terzo riscontro indipendente: i tick reali col fix gestione davano **PF 1,30**, ed era l'unico sopravvissuto alla bocciatura della famiglia breakout. Abbiamo passato settimane su DAX e Nasdaq, che misurano zero.
2. **La FASE B va fatta lo stesso, ma con aspettative corrette.** Serve a smettere di distruggere valore (39 secondi → 135 minuti) e a decidere il BE col dato vero, non a creare margine dal nulla.
3. **Il margine sta nella selezione.** Ablazione + studio dicono la stessa cosa da due direzioni: il segnale grezzo vale zero, il filtro volumi è l'unico che lo sposta.
4. **Lo stop non si tocca.** L'unica cosa che questo studio promuove senza riserve.

### L'ipotesi concreta da testare, derivata dai numeri
**Dow (U30USD), filtro trend H4 acceso, TP 1,5R, stop 1R invariato, niente trailing nei primi 45 minuti.**
Ognuno dei quattro pezzi viene da una misura di questa pagina, non da un'idea.

```powershell
# FASE B — le distanze, sui P&L veri
.\scan_gestione.ps1 -Robot ABTG_DAX_Apertura_EU    -Symbol D30EUR -SessionHour 8  -Fase distanze
.\scan_gestione.ps1 -Robot ABTG_Nasdaq_Apertura_US -Symbol NASUSD -SessionHour 14 -Fase distanze
```

_CSV grezzi (dettaglio trade per trade + riepiloghi): `risultati_archivio/studio_apertura/`._
