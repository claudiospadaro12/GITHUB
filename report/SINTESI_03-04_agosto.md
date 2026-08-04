# 🧭 Sintesi dopo due giornate di pagella (03–04 agosto 2026)

_Due giorni sono pochi per giudicare un EA. Sono abbastanza per vedere **schemi** e per prendere **decisioni di flotta**, che non dipendono dalla statistica._

---

## 1. Il quadro, in una tabella

**16 trade in due giornate. Netto −160,38.**

| | trade | netto |
|---|---|---|
| I tre **`Live5m`** | 6 | **−327,25** |
| **Tutto il resto** | 10 | **+166,87** |

E dentro "tutto il resto", **tutte e sei le famiglie sono positive**:

| EA | trade | netto |
|---|---|---|
| `ORB` | 2 | **+59,71** |
| `Nasdaq Apertura US OTT` | 1 | +41,04 |
| `Nasdaq Apertura US` | 1 | +28,53 |
| `DAX Apertura EU` | 2 | +16,47 |
| `Apertura Marco` | 2 | +16,47 |
| `DAX Apertura EU OTT` | 2 | +4,65 |

Sei famiglie su sei col segno giusto è poco probabile per caso, anche con campioni minuscoli. **La flotta non è rotta: sono rotti tre EA su una decina.**

## 2. Il filo che lega tutto: stiamo aggiungendo troppo

Mettendo in fila ogni cosa misurata in questi giorni, esce un motivo ricorrente:

| Cosa abbiamo aggiunto | Esito |
|---|---|
| 6 filtri sul Nasdaq (ablazione) | **1 funziona**, 5 no |
| 3 filtri sul Dow | **1 funziona** (H4), gli altri fanno danno |
| Parziale + BE + trailing sul Dow (48 pass) | **tutto peggiora**: nudo 3 917, migliore gestito 2 575 |
| BE anticipato | **6 confronti su 8 in perdita**, fino a −38% |
| Più EA sullo stesso simbolo | si annullano (Nasdaq 04/08: +93,16 e −93,03) |
| Trailing a punti fissi | 3 trade chiusi sotto il minuto in due giorni |

**Su una quindicina di aggiunte testate, ne pagano due**: il filtro volumi sul Nasdaq e il filtro trend H4 sul Dow. Tutto il resto è complessità che costa.

> **Conclusione operativa: la flotta è sovra-ingegnerizzata.** Il lavoro che rende non è aggiungere pezzi, è toglierli.

## 3. E una seconda lezione, meno piacevole: la misura era rotta in quattro punti

In due giorni sono venuti fuori quattro difetti, **tutti silenziosi** — nessuno dava errore:

1. `pubblica_trades.ps1` pubblicava su un **branch morto**;
2. `scarica_ottimizzati.ps1` **scaricava** dallo stesso branch morto → il VPS ricompilava sorgenti vecchi per giorni;
3. `ABTG_TradeExporter` non era nella lista di deploy;
4. il **breakeven annidato dentro il parziale** → al lotto minimo non scattava mai (costo misurato: 112,78 € sull'oro).

Tre di questi facevano sì che **modifiche corrette non arrivassero mai in produzione**. Il quarto toglieva protezione a tutta la flotta.

> **Regola nuova: dopo ogni modifica, verificare che sia ATTIVA, non solo committata.** Il segnale che funziona per noi è l'intestazione del CSV: se cambia, il codice nuovo sta girando davvero.

## 4. La decisione che NON ha bisogno di altri dati

I tre `Live5m` prendono i livelli dalla **candela di 5 minuti prima dell'apertura**, con 7 punti di buffer. Su un R da 59 punti indice (DAX), il trigger sta a **0,12 R** dal centro di una candela di pre-mercato: **è dentro il rumore per costruzione**.

Lo si è visto tre volte, in tre modi diversi:
- 03/08 DAX: comprano 29 punti **sotto** il massimo notturno → stop in 80 s
- 04/08 DAX: vendono → stop in 61 s, poi il DAX chiude +0,59%
- 04/08 Nasdaq: vendono **133 punti sopra** il massimo notturno → stop in 20 s, mercato +1,80%

Non è una questione di direzione né di taratura: **non c'è un livello da rompere**. Correggerlo significa dargli il range dei 15 minuti dopo l'apertura — cioè renderli identici a `DAX Apertura EU`, che già esiste.

**Questa è una decisione di flotta, non un'ottimizzazione.** Due giorni bastano perché il difetto è meccanico, non statistico.

## 5. Cosa testare adesso, e cosa NO

### ✅ Vale la pena

| # | Test | Perché |
|---|---|---|
| 1 | **`InpTrailMode = 1` sul Dow** | è il buco della griglia: 48 pass col trailing a punti fissi, **zero** con quello a base candela — proprio il tipo che in forward ha fatto 13× i punti |
| 2 | **Walk-forward sul Dow** | tutto quello che sappiamo è **in-sample**. È il cancello che separa "buon backtest" da "sistema di cui fidarsi", e sulle aperture non l'abbiamo mai fatto |
| 3 | **`ABTG_ORB` con `InpUseCloseConfirm`** | Emiliano descrive un ingresso "quando la candela **apre** oltre il livello, non alla violazione". Il pezzo è già scritto e mai provato. E l'ORB è il primo della flotta per netto |

### ❌ Non vale la pena, adesso

- **Altri filtri d'ingresso.** Ne abbiamo provati nove fra Nasdaq e Dow: ne funzionano due, ciascuno su un mercato solo. La miniera è esaurita.
- **Altra ottimizzazione della gestione sul Dow.** 48 pass dicono che la risposta è "nessuna gestione". Insistere sarebbe cercare un numero che i dati dicono non esistere.
- **Aspettare più giorni di forward per decidere i parametri.** A 8 trade al giorno su dieci EA servono mesi per un campione utile. Il forward serve a trovare **cause** e a verificare che le modifiche siano attive — non a scegliere valori.

## 6. La risposta secca alle tre domande

> **Altri test forward?** No, non per decidere: il forward continua da solo e ci dà cause, non numeri.
> **Preset?** Sì, uno solo: il Dow, già pronto e in forward da domani.
> **Altra ottimizzazione?** Solo il punto 1 (trailing a base candela). Poi si passa al **walk-forward**, che è la cosa che ci manca davvero.

_Il rischio di questa fase non è ottimizzare poco: è ottimizzare ancora, su cose già misurate, invece di validare fuori campione quello che abbiamo._
