# CACCIA MIRATA — meccanismi SHORT / regime ORSO per gli indici (DAX, Dow, Nasdaq)

_29/08/2026. Bersaglio: uno short a TF basso (M5/M15/H1), automatizzabile,
per prop, che viva nel DRIVE-DOWN (non nel fade/retest) e sia GATED da un
filtro di regime cosi' si accenda SOLO quando l'orso lo giustifica. Vincolo
critico dato dal committente: privilegiare candidati la cui FONTE li ha
testati in una finestra che INCLUDE orso/crollo (2008/2020/2022)._

---

## LA RIGA CHE CONTA

> Su **~40 candidati guardati** su 5 fonti (MQL5 Code Base, TradingView/GitHub
> Pine, MQL5 Articles, QuantConnect, SSRN/Quantpedia), **4 arrivano al sorgente
> letto davvero**, **1 lo metterei in prova subito** — ed e' un motore che
> **abbiamo gia'** (`ABTG_Nasdaq_Apertura_US`) configurato in un modo che **non
> abbiamo mai misurato**: BREAKDOWN short (drive-down following) GATED da EMA
> H4 ribassista, girato su **storico ESTERNO che contiene l'orso 2020 e 2022**.
>
> **La scoperta vera di questa caccia non e' un EA: e' un vincolo.** I tick BCM
> sugli indici **partono dal 26/09/2024** (misurato, `REFERTO_SONDA_STORICO_
> 17-08.md 3`, stato COMPLETO). Nessuno short indice puo' ricevere un VERDETTO
> a tick reali nell'orso: i dati orso, sul nostro broker, **non esistono**.
> Percio' il valore di questa caccia sta (a) nel MECCANISMO giusto (breakdown,
> non fade) confermato dalla letteratura testata in orso, e (b) nell'unica
> strada di MISURA che ci resta: OHLC su HistData `NASUSD_EXT`/`SPXUSD_EXT`
> (2019 laterale / 2020 crollo / 2021 toro / 2022 orso) come **SCREENING**.

---

## 0. CONTROLLO POSITIVO — fonte per fonte

| fonte | esito | prova |
|---|---|---|
| `mql5.com/en/code/mt5/experts` (elenco + page2) | PASSA | HTTP 200, titoli reali: "Session Opening Range Breakout EA", "AAPL cfd - ORB strategy", e su page2 quattro EA gia' nel nostro `SETACCIO_MANUALE.md` (73711, 68951, 74137, 71467) -> il canale restituisce cio' che so gia' esserci |
| GitHub (raw file + LICENSE) | PASSA | scaricati `liquidity-sweep-reversal-strategy.pine` + `LICENSE` (MIT), byte reali |
| MQL5 Articles (`/en/articles/21133`) | PASSA | pagina reale, codice `.mq5`+`.mqh` mostrato, licenza dichiarata |
| WebSearch (Quantpedia/SSRN/QuantConnect) | PASSA (indiretto) | ha restituito URL veri (SSRN 4729284, QuantConnect 18444) |
| **`papers.ssrn.com` (PDF paper)** | **NULLA** | non tentato direttamente (Cloudflare storico); i mirror PDF (wealth-lab, Concretum, substack) sono **egress-bloccati dal proxy**. Numeri short-side del paper **NON verificati sulla pagina** — dichiarato. |

---

## 1. IL PROMOSSO — Candidato A: BREAKDOWN short GATED (drive-down following)

```
NOME            Regime-gated Opening-Range BREAKDOWN short (drive-down following)
FONTE / URL     Tesi: Zarattini, Barbon, Aziz, "A Profitable Day Trading Strategy
                for the U.S. Equity Market", SSRN 4729284 (2024-02-16).
                Motore: NOSTRO (ABTG_Nasdaq_Apertura_US.mq5) -> porting ZERO.
                Dato: HistData NASUSD_EXT/SPXUSD_EXT 2019->2026 (gia' in casa).
AUTORE / DATA   Carlo Zarattini, Andrea Barbon, Andrew Aziz - 16/02/2024
POPOLARITA'     paper molto citato (Swiss Finance Institute WP 24-98) [VERIFICATO
                via search; abstract letto, PDF non raggiunto]
LICENZA         tesi accademica (idea, non codice); il MOTORE e' nostro. Nessun
                vincolo di licenza (a differenza di QuantConnect/MQL5-Article).
RIGHE / INPUT   motore gia' scritto e vivo; nessuna riga nuova da scrivere

TESI IN UNA RIGA
  "Lo short degli indici guadagna nel DRIVE-DOWN (rottura del minimo del range
   d'apertura che PROSEGUE), non nel rientro/fade; e paga solo quando il regime
   e' ribassista -- percio' va GATED, non lasciato simmetrico."

MECCANICA   ingresso: SELL STOP sotto il minimo del range d'apertura 15'
            (InpEntryMode=BREAKOUT=0). uscita: TP 1R parziale 50% + trailing,
            flat a fine giornata. stop: ATR-based (floor anti-stop-stretto).
GESTIONE    rischio % (0.65), SL VERO ATR, 1 trade/giorno, max pos 1. Il GATE:
            TrendBias() righe 1570-1571 -> short ammesso SOLO se EMA fast<slow
            su H4 (regime ribassista). E' il filtro che E' il motore, non un
            cerotto: senza orso il gate tiene l'EA FLAT (comportamento voluto).
BANDIERE ROSSE  nessuna. No martingala/griglia/recovery/DCA/hedging. SL vero.
                No repaint (CopyBuffer shift 1, non 0; iMA su barra chiusa).
COSTO DI PORTING  ZERO -- il motore e' nostro e gia' compilato/vivo in forward.

PUNTEGGIO (0-2)
  [2] semplicita' (motore noto, config fissa, 1 asse di banco)
  [2] il filtro E' il motore (il gate H4 decide se lo short esiste)
  [2] tesi di mercato scrivibile (drive-down, payoff ~6:1 misurato in anatomia)
  [2] riempie un BUCO (short in ORSO -- lato + regime che la flotta non copre)
  [1] testabile senza riscritture: SI come SCREENING OHLC su EXT; NO come
      verdetto tick (i dati orso BCM non esistono). -1 onesto.

VERDETTO   PROVA SUBITO (9/10) -- ma come SCREENING dichiarato, non promozione.
PERCHE'    E' l'unico modo che abbiamo per rispondere "lo short indice e' morto
           anche NELL'ORSO, o solo nel toro dove l'abbiamo sempre testato?".
           R98/R115 hanno bocciato lo short nel solo-toro: mai nell'orso.
```

**File prova**: `backtest_pipeline/prove/SHORTGATE_NAS_BREAKDOWN.txt` (criteri
congelati prima dei numeri; delta a una variabile vs `R115_NAS_01_short`).

### In ottica prop (riga d'obbligo)
Questo motore, SE mostrasse edge nell'orso, sarebbe **scorrelato per costruzione**
dalla flotta: e' l'unico che si accende quando gli indici crollano, cioe' quando
le sedie long (DAX/Dow apertura, tutte long-only) soffrono. E' esattamente il
tipo di scorrelazione che la ROTTA_PROP chiede ("aiuta solo se NON perdono
insieme"). ATTENZIONE: la sua peggior giornata non e' misurabile finche' non
esiste un dato orso a tick -- quindi in prop resta CANDIDATO DI SCREENING, non
accendibile, finche' non si scioglie il nodo-dati.

---

## 2. IN CODA — Candidato B: Liquidity Sweep Reversal (Pine, MIT)

```
NOME            Liquidity Sweep Reversal Strategy (Pine v5)
FONTE / URL     github.com/mitchell-917/tradingview-pinescript-lab
                /strategies/liquidity-sweep-reversal-strategy.pine
LICENZA         MIT (LICENSE verificato: "MIT License, (c) 2025 ... Contributors")
RIGHE / INPUT   ~9 input (2 lookback, pivot len, swing toggle, wick%, risk%,
                ATR mult, RR, ATR len)
TESI IN UNA RIGA
  "Quando il prezzo spazza i massimi recenti e richiude DENTRO il range
   (stop-hunt fallito), va short: la liquidita' e' stata presa, il rialzo era
   finto." (rawUpSweep = high>prevHigh and close<prevHigh -> Short)
MECCANICA   short su upSweep; SL = high + atr*mult (sopra lo sweep); TP = RR-based.
GESTIONE    rischio % (equity*riskPct), pyramiding=1, SL vero. No martingala/grid.
BANDIERE ROSSE  nessuna nel money management. MA: e' un REVERSAL/FADE (la famiglia
                che ha faticato nel toro, R108/R109) -- lo short qui scommette sul
                RITORNO, non sul drive. E il repo e' EDUCATIVO: nessun backtest
                reale, MAI testato su orso.
COSTO DI PORTING  Pine -> MQL5 = RISCRITTURA, ~4-6 ore.
VERDETTO   IN CODA (6/10). Meccanismo DIVERSO e pulito (sweep dei massimi, non
           fade del range), licenza libera. Ma fade-family + non testato +
           costo di porting. Si guarda DOPO A, e sulle STESSE finestre orso EXT.
PERCHE'    porta un secondo meccanismo short costitutivo (stop-hunt) che non
           abbiamo, ma senza prove non giustifica ancora la riscrittura.
```

---

## 3. GLI SCARTI — una riga di motivo a testa

| candidato | fonte | perche' SCARTO |
|---|---|---|
| **Hon Matrix** | MQL5 code/71645 | **griglia** con `LotMultiplier=1.1` (aumenta il lotto sull'ordine successivo) -> martingala/grid, 4 del setaccio. Fuori. |
| **Liquidity Sweep H4-M15** | MQL5 code/68951 | **gia' scarto 16/08** (F_SHORT): rischio monetario FISSO + RR 0.2 (100 vincite pagano 20 perdite = profilo DD che il cancello prop non regge); autore dichiara "proof-of-concept". |
| **Universal Breakout Study** | MQL5 code/73711 | **gia' nel SETACCIO_MANUALE** (38 input). Breakout = porta chiusa (~96 celle: R7-R13, R42, R45, R12). |
| **003 - Weekly Day Reversal / 002 Inside Bar / KSQ FVG Regime** | MQL5 code/74137, 73884, 71467 | **gia' setacciati** (D_LATERALE, E_CROLLO, F_SHORT, G_APERTURE). Non si ricontrollano. |
| **Single Candle Liquidity Trader Filtered** | MQL5 Article 21133 | ha uno short GATED da EMA50 (interessante), ma licenza **MetaQuotes "copia vietata"** = piu' restrittiva di CC-BY-NC -> **SQUALIFICANTE** per un derivato committato. |
| **ORB "Stocks in Play"** | QuantConnect 18444 / SSRN 4729284 | **cross-sectional**: seleziona 20 titoli via relative-volume ("stocks in play"). L'edge viene dalla SELEZIONE dell'universo, non dall'ORB nudo su un CFD singolo -> **non traducibile** as-is. Resta come TESI (candidato A). Codice Apache/C#. |
| **VIX-regime filter** (ES/NQ/RTY) | GitHub / substack EasyLanguage | richiede il **feed VIX** nel tester su un CFD indice singolo: **non disponibile**. Traducibile solo con un proxy di volatilita' INTERNA (ATR) -> a quel punto e' il gate del candidato A, non un candidato a se'. |
| **Z-Score Mean Reversion Pro / Reversal Trap Bands Pro** | TradingView | fade-family (mean-reversion short), e sono INDICATORI, non strategie con ingresso short pulito. Nessun test su orso. |
| **GOLD_ORB** | GitHub yulz008 | XAUUSD, non indici; fuori bersaglio. |

---

## 4. COSA NON HO POTUTO VEDERE (dichiarato, non sostituito con la memoria)

- **I numeri short-side e per-anno del paper Zarattini** (SSRN 4729284): PDF su
  SSRN (Cloudflare storico), e i mirror wealth-lab / Concretum / substack sono
  **egress-bloccati dal proxy**. So dall'abstract (via search) che testa
  2016-2023 long+short con direzione costitutiva; **NON ho letto** la
  scomposizione long/short ne' il comportamento 2018/2020/2022. Marcato INCERTO.
- **La prima data ESATTA di NASUSD_EXT**: la corsa EXT dichiara 2019->2026 e i
  regimi 2019/2020/2021/2022, ma la prima barra precisa va confermata con
  `scarica_storico.ps1 -Simboli "NASUSD_EXT" -SoloReferto`. Nel file prova
  @DAQUANDO=2020.01.01 e' scelto DENTRO i dati confermati, non inventato.
- **Il CANCELLO ZERO qualita'-feed sugli indici e' ancora CHIUSO** (diff media
  H1 0,061-0,101% contro <=0,05%): anche lo screening OHLC su EXT va letto con
  questa riserva. Non e' un verdetto, e non lo diventa senza tick BCM che non ci
  sono.

---

## 5. LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

**"Il breakdown short GATED da H4 ribassista ha un edge nelle finestre ORSO
(crollo 2020-02/04, orso 2022) che i 21 mesi solo-toro di BCM nascondono per
costruzione?"**

- Se **SI** (aspettativa/trade positiva netta nei sotto-periodi orso, DD
  sostenibile): apri un round vero, griglia stretta su buffer/EMA, poi il nodo
  vero diventa i DATI (serve un dato orso a tick per un verdetto -> sonda BCM /
  Dukascopy Dow, o si accetta lo screening come tetto dichiarato).
- Se **NO** (drag anche nell'orso, come nel toro): lo short in apertura indici
  e' **chiuso onestamente, orso incluso**, e si smette di ricacciarlo. Sarebbe
  la prima volta che lo boccia con un dato che CONTIENE l'orso -- oggi R98/R115
  lo bocciano solo nel toro, ed e' un no monco.

**Precedente da non ripetere (passato prima di entrare):** R115 (retest 0.517),
R108/R109 (fade morti), R98 (momentum short PF 0.37 "perde ovunque"). Candidato
A **non e' nessuno di questi**: e' BREAKOUT/continuation (non retest, non fade,
non momentum-di-chiusura), su una FINESTRA che quei tre non hanno mai visto.
