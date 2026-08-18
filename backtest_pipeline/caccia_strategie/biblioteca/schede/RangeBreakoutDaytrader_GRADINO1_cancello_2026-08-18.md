# SCHEDA GRADINO 1 DEL CANCELLO — Range Breakout Day Trader (MT5)

Fonte: seconda caccia del 18/08/2026 (referto CONFIG_PROP_RACCOLTA_SET),
pagina Market mql5.com/en/market/product/114061, autore dichiarato Aroen
Mughal. Scheda scritta per chiudere M10 del PIANO_PROP: i dati del cancello
devono stare nel repo, non in chat.

## Gradino 1 - la scheda
- Prezzo: 179 USD una tantum. NOLEGGIO: 3 mesi 59 USD / 1 anno 109 USD.
- 12 attivazioni. v3.2, aggiornato 14/05/2026. ~501 download. 3 recensioni
  (prova sociale DEBOLE, dichiarata).
- Demo scaricabile: SI (testabile nello Strategy Tester prima di pagare).
- Meccanismo dichiarato: range breakout intraday, una posizione al giorno,
  SL sempre presente, trailing ATR, "no Grid/Hedge/Martingale recovery".
- Riscontro nei fatti: 32 preset pubblici letti (in biblioteca/set/):
  nessun parametro di moltiplicazione lotti. Filtro news via CSV del
  calendario (backtestabile - la scoperta che ha sbloccato D1).
- ATTENZIONE taglie: il profilo "ExtraLowRisk" del vendor rischia 2,4% per
  trade = 3,7 volte il nostro 0,65%. Qualunque test gira a taglia NOSTRA.

## Gradino 1-bis - due diligence sul venditore: ESEGUITA il 18/08/2026
Sequenza del cancello: recensioni Market -> Google del nome -> Forex Peace
Army -> Forex Factory. Tutte e quattro tentate. **Esito: il VENDITORE e'
PULITO, il PRODOTTO no.** Il rischio non e' la persona: e' il track record.

### Controllo positivo per fonte
| fonte | esito | note |
|---|---|---|
| mql5.com (prodotto, profilo, commenti, segnali) | ✅ contenuti veri | dati coerenti con la scheda gradino 1 (179 USD, 12 attivazioni, v3.2 del 14/05/2026, 501 demo, 3 recensioni) |
| Google / WebSearch sul nome | ✅ risponde | ma restituisce quasi solo shop pirata |
| forexpeacearmy.com | ❌ **EGRESS_BLOCKED dal proxy** | lettura diretta IMPOSSIBILE. Fatta solo ricerca INDIRETTA |
| forexfactory.com | ❌ 403 noto | solo ricerca INDIRETTA |

### 1. Recensioni e commenti sul Market [VERIFICATO 18/08/2026]
`https://www.mql5.com/en/market/product/114061` — 3 recensioni, tutte 5/5:
- **Eddie** (01/07/2024): "The Author is very supportive... The EA is brilliant
  and doing exactly as described."
- **Summ Top** (07/09/2024): "Good EA! Using it in my portfolio of EA's."
- **gregor_h** (19/02/2025): loda la reattivita' dell'autore e **dichiara
  espressamente che e' troppo presto per giudicare la performance**.

Nessuna delle 3 recensioni contiene un numero. Sono recensioni sul
**SERVIZIO CLIENTI**, non sul rendimento. Prova sociale = DEBOLE confermata.

**I 64 commenti della discussione, letti tutti** (pagine 1-4 di
`.../114061/comments`): ~58 sono aggiornamenti del vendor che pubblica
`.set` e CSV del calendario, dal 06/04/2024 fino al **05/06/2026** (US30,
XAUUSD, BTCUSD, USDJPY). Le uniche lamentele in due anni e mezzo:
- Eddie (26/06/2024): "I purchased EA, but its not opened trades for the past
  3 days" + richiesta di rimborso -> risposta del vendor in **8 minuti**
  (filtro spread a 15 punti troppo stretto) -> il 01/07 Eddie chiude con una
  recensione positiva. Caso risolto, non insabbiato.
- `EA--TESTER--REALMONEY` (28/03/2025): problemi di `Time Offset` GMT/ora
  legale su IC Markets -> il vendor risponde sul DST nella pagina successiva.
- Thie Helmi (16/08/2024): "result very different with 2023" nel backtest
  2024 -> il vendor chiede se ha messo il `news.csv`.

**Zero accuse di truffa, zero rimborsi negati, zero conti bruciati.**

### 2. Profilo del venditore [VERIFICATO 18/08/2026]
`https://www.mql5.com/en/users/aroen` — Aroen Mughal, **Paesi Bassi**,
rating 949, "esperienza 2 anni", 4 prodotti, 183 demo scaricate, 35 amici,
**1 iscritto**. Prodotti: Range Breakout Day Trader MT5 (179 USD, 3 rec. 5/5)
· MT4 (179 USD, v2.5 ferma al 16/03/2025) · News Day Trader (179 USD, v1.7 del
02/07/2026, 3 rec. 5/5, 51 demo) · MT5 Economic Calendar CSV exporter
(GRATIS - e' l'utility che ci ha dato i CSV in `dati/`).
Manuale pubblico: `https://www.mql5.com/en/blogs/post/760349`.
Nessun sito proprio, nessun canale YouTube/Telegram trovato: **niente imbuto
di vendita fuori piattaforma** (elemento a favore).

### 3. 🔴 LA SCOPERTA CHE CONTA - i segnali LIVE del vendor [VERIFICATO 18/08/2026]
Il vendor pubblica il proprio track record verificato dal broker. E' MALE.

| segnale | URL | conto | eta' | trade | crescita | PF | DD equity | DD balance | iscritti |
|---|---|---|---|---|---|---|---|---|---|
| Range Breakout **Extra Low Risk** USDJPY | `mql5.com/en/signals/2305357` | **Darwinex-Live**, 1:200, dep. 1.000 EUR | 107 sett. | 248 | **−8,15%** | **0,94** | 2,38% | 27,26% | 0 |
| Range Breakout **Medium Risk** USDJPY | `mql5.com/en/signals/2331011` | RoboForex-ECN reale, 1:500, dep. **140,40 EUR** | 55 sett. | 137 | +10,88% (= **+15,27 EUR**) | **1,05** | 9,87% | **45,43%** | 0 |

Tre fatti che pesano piu' di qualunque recensione:
1. Il profilo **"Extra Low Risk" e' proprio quello che il vendor raccomanda
   per le prop firm** (manuale: "start with EXTRA LOW RISK settings"). In
   **due anni** e 248 operazioni su conto reale ha fatto **−8,15% con PF
   0,94**. Il preset da challenge, in live, PERDE.
2. Il "Medium Risk" positivo gira su un conto da **140 euro**: 15 euro di
   utile totale, Sharpe 0,05, e MQL5 segnala **"no trading activity for the
   last 19 days"**. Non e' una prova, e' un campione.
3. **Esisteva un terzo segnale, `mql5.com/en/signals/2219704` ("Low Risk"),
   indicizzato da Google: oggi risponde 404.** [VERIFICATO: 404 il
   18/08/2026] [INFERITO: rimosso; non sappiamo perche' ne' con quali numeri
   e' finito]. La frase di marketing **"85% di profitto in 39 settimane
   verificato su conti reali"** sopravvive solo sulle copie pirata della
   vecchia v2.2 — sulla pagina MQL5 di oggi **non c'e' piu'**.

**Confronto secco col nostro criterio di gradino 3** (congelato PRIMA:
PF > 1,2): il vendor stesso, in live, fa **0,94 e 1,05** su ~385 operazioni.

### 4. Forex Peace Army [NON VERIFICABILE - fonte bloccata]
`forexpeacearmy.com` -> **EGRESS_BLOCKED dal proxy di rete**. Nessuna lettura
diretta possibile. Ricerca INDIRETTA via motore ("Aroen Mughal"
forexpeacearmy / scam / complaint, e ricerca ristretta al dominio):
**nessun dossier, nessuna scheda, nessuna menzione del nome**. Va detto
com'e': **assenza di risultati in ricerca indiretta ≠ fedina pulita
verificata**. E' il buco dichiarato di questa due diligence.

### 5. Forex Factory [NON VERIFICABILE - 403 noto]
Solo ricerca indiretta: i thread che escono sono discussioni generiche su
strategie di range breakout, **nessuno su questo EA ne' su questo autore**.
Un utente non identificato viene citato come "l'EA non apre trade, opzioni
orarie complicate", con un altro che risponde che va con le impostazioni
giuste: e' **lo stesso identico episodio** gia' letto nei commenti MQL5.

### 6. Ecosistema pirata [VERIFICATO 18/08/2026 - solo titoli/URL, NON scaricato]
Il ricerca restituisce **almeno 10 shop** che distribuiscono "Range Breakout
Day Trader MT4 v2.2 cracked / free download" (eaforexstore, eafxstore,
forexeashop, onshoppie a 14,99 USD, shopeafx, cheaperforex, thetradelovers,
shopforexea, forexrobotea, fxproea, forexcracked). **Non e' una colpa del
vendor** — succede a ogni EA che vende. Conta per DUE motivi nostri:
(a) la pirateria resta fuori discussione per regola di casa: **non si scarica
nulla da li'**; (b) quei siti riciclano il marketing VECCHIO (l'"85% in 39
settimane", "5+ anni di esperienza" contro i "2 anni" del profilo): **se si
cerca questo EA su Google si legge una versione del prodotto che il vendor
oggi non promette piu'**. La pagina MQL5 attuale, verificata, e' sobria: dice
solo "LOW RISK ed EXTRA LOW RISK sono adatte alle challenge", **senza
nessuna percentuale, nessun risultato verificato, nessuna garanzia**.

### VERDETTO 1-bis: SUPERATO SUL VENDITORE, NON SUPERATO SUL PRODOTTO
- ✅ **Venditore**: nessuna bandiera rossa. Nome e paese esposti, assistenza
  rapida e documentata, aggiornamenti continui da 2 anni e mezzo (ultimo
  05/06/2026), un'utility gratuita utile, marketing attuale sobrio, **track
  record pubblicato anche quando e' negativo** (che e' onesta', non abilita').
  Non e' il caso "XT Prop Firms": li' c'era un dossier FPA guilty 79-0.
- 🔴 **Prodotto**: il track record live del preset raccomandato per le prop
  e' **PF 0,94 su 248 trade in 2 anni**. Il gradino 1-bis non boccia il
  vendor, ma consegna al gradino 3 un candidato che il suo stesso autore
  non e' riuscito a rendere profittevole in avanti.
- ⚠️ **Buco dichiarato**: FPA e Forex Factory NON letti direttamente
  (bloccati); solo ricerca indiretta, che non ha trovato niente.

### Raccomandazione sul noleggio da 59 USD (decide Claudio)
**Non noleggiare adesso.** Il noleggio serve al forward; qui il forward
del vendor esiste gia', e' pubblico e verificato dal broker, e dice PF 0,94.
Prima la **DEMO GRATUITA nello Strategy Tester** (che il cancello concede e
che non costa niente): se sulle quattro finestre di regime, a taglia nostra
0,65%, non tiene i criteri gia' congelati (PF > 1,2, n >= 150, DD < 9%,
3 finestre su 4), **i 59 USD non si spendono e la pratica si chiude qui**.
Il noleggio torna sul tavolo **solo** se la demo passa il gradino 3.
Nota per il test: la pagina raccomanda **USDJPY/GBPUSD/BTCUSD**, mentre i
nostri criteri sono su **US30 e oro** — i `.set` US30/XAUUSD esistono
(pubblicati dal vendor il 01 e 05/06/2026 e gia' in `biblioteca/set/`) ma
sono simboli **fuori dalla raccomandazione ufficiale**: va scritto nel referto.

## Gradino 3 - criteri demo CONGELATI PRIMA dei numeri (18/08/2026)
Sul US30 e sull'oro, quattro finestre di regime di casa (ORSO 2022.01-10 /
CROLLO 2020.02-04 / TORO 2021 / LATERALE 2019), costi nostri, rischio
riportato a 0,65%:
- PASS se: PF > 1,2 con n >= 150 operazioni per finestra, DD di portafoglio
  < 9%, almeno 3 finestre su 4 positive.
- Qualunque esito: prima il NOLEGGIO 3 mesi (59 USD) in forward demo, mai
  l'acquisto diretto. I numeri/screenshot del vendor valgono zero.

## Stato
Gradino 1 fatto (questa scheda) · **1-bis ESEGUITO 18/08/2026: vendor pulito,
prodotto con track record live negativo (PF 0,94)** · 2 (setaccio) superato
sui 32 preset · 3 = **demo gratuita nel tester PRIMA di qualunque noleggio**,
in attesa di decisione di Claudio · 4-5 a seguire.
