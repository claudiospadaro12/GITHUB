# 🧬 PROPOSTA DEI CLUSTER CORRELATI — da firmare (07/09/2026)

> ⚠️ **QUESTO DOCUMENTO NON DECIDE NIENTE.** Il verbale
> `report/FIRME_2026-09-07.md` dice, testualmente, che definire i cluster
> *"e' una scelta, va firmata a parte"*. Qui c'e' la **proposta**, con la
> motivazione riga per riga. Finche' Claudio non firma, la mappa qui sotto
> **non e' in nessun preset e non gira da nessuna parte**.

## Perche' esiste (misurato, non opinato)

Dal dossier `backtest_pipeline/caccia_strategie/CONFIG_PROP_FREQUENZA_2026-09-06.md`:
i due portafogli "prop firm ready" a larga base letti hanno drawdown **MISURATI
del 32,59%** (S2, 3-5 EA su 26 simboli) **e del 45,64%** (S1). La larghezza
senza controllo della correlazione **e' la trappola** — ed e' esattamente il
rischio che la firma gemella dello stesso giorno (pavimento di frequenza per
**FAMIGLIA** = piu' simboli) rende piu' probabile.

Il numero del campo (blog 769682 `[LETTO]`): **3,0% max su una singola valuta**,
**3,5% combinato** per coppie parzialmente correlate (EURUSD+GBPUSD), *"non
2%+2%=4%"*. E' il valore firmato il 07/09.

## Come funziona il meccanismo (per capire la proposta)

- Il tetto conta il **RISCHIO** (somma degli SL vivi in % di equity), **non le
  teste**: e' la differenza con P0 (tetto simbolo+lato, del 02/09).
- **Un simbolo puo' stare in PIU' cluster.** EURUSD e' in `USD` e in `EUR`:
  l'ingresso viene rifiutato se **anche uno solo** dei cluster a cui appartiene
  e' saturo. E' il "vince il piu' stringente" applicato ai cluster.
- Ogni cluster puo' dichiarare un **tetto proprio** (sintassi `NOME:3.5=...`);
  se non lo dichiara usa il tetto generale (**3,0%**).
- Accanto, e non al posto, resta il **cap complessivo C1 = 3,25%** (18/08).

## La mappa proposta

Costruita **sui simboli che la flotta usa davvero** (censimento dei preset in
`mql5/Presets/` + `FLOTTA_ATTIVA.md`): XAUUSD, XAGUSD, D30EUR, U30USD, NASUSD,
SPXUSD, 225JPY, 200AUD, EURUSD, GBPUSD, USDJPY, USDCHF, USDCAD, NZDUSD, AUDUSD,
AUDJPY, GBPJPY, EURJPY, CHFJPY.

| # | Cluster | Tetto | Membri | Perche' stanno insieme |
|---|---|---|---|---|
| 1 | `USD` | 3,0% | EURUSD, GBPUSD, USDJPY, USDCHF, USDCAD, NZDUSD, AUDUSD | valuta comune. E' **il** cluster del campo (3% per singola valuta): su un dato macro USD queste sette si muovono insieme, con segno diverso ma **stesso fattore** |
| 2 | `EUR` | 3,0% | EURUSD, EURJPY | valuta comune |
| 3 | `GBP` | 3,0% | GBPUSD, GBPJPY | valuta comune |
| 4 | `JPY` | 3,0% | USDJPY, EURJPY, GBPJPY, AUDJPY, CHFJPY | valuta comune. La flotta ha **4 sedie** su cross JPY: e' il cluster piu' popolato che abbiamo |
| 5 | `AUD` | 3,0% | AUDUSD, AUDJPY | valuta comune |
| 6 | `METALLI` | 3,0% | XAUUSD, XAGUSD | oro e argento sono lo stesso trade con beta diverso. In flotta l'oro ha **12 grafici**: e' la concentrazione piu' alta del conto |
| 7 | `AZ_US` | 3,0% | U30USD, SPXUSD, NASUSD | indici azionari USA. **Il cluster piu' stretto della lista**: i tre si muovono praticamente insieme intraday |
| 8 | `AZ_EU` | 3,0% | D30EUR | indici azionari europei (oggi solo il DAX; il cluster esiste per quando entrera' un UK100 o simili) |
| 9 | `AZ_APAC` | 3,0% | 225JPY, 200AUD | indici azionari asiatico-pacifico. Aperti quando USA/EU sono chiusi: correlazione **in ritardo**, non contemporanea |
| 10 | `AZIONARIO` | **3,5%** | D30EUR, U30USD, SPXUSD, NASUSD, 225JPY, 200AUD | 👉 **la risposta alla domanda su D30EUR e U30USD** (sotto) |

### 👉 D30EUR e U30USD stanno nello stesso cluster? La proposta dice: **NO al 3,0%, SI al 3,5%**

E' la domanda con conseguenze immediate sulle **due sedie del conto reale
10105439** (`770101` DAX Apertura EU su **D30EUR**, `770611` ORB Ottimizzato su
**U30USD**). La proposta:

- **NON** nello stesso cluster a 3,0%: DAX e Dow **non sono lo stesso trade**.
  Le sedie sono su sessioni diverse (08:00 server contro 14:30 server), e
  metterle in un cluster da 3,0% significherebbe che la seconda a partire trova
  la porta chiusa per colpa della prima — cioe' spegnere per regola una
  scorrelazione che oggi paghiamo apposta;
- **SI** nel super-cluster `AZIONARIO` a **3,5%**: perche' sono comunque due
  indici azionari, e nelle giornate di risk-off si muovono **insieme**. Il 3,5%
  e' esattamente il numero che il campo usa per le "parzialmente correlate"
  (*"non 2%+2%=4%"*).
- **ONESTA', come per C1 nel preset del reale:** con due sole sedie a 0,65%
  ciascuna il rischio aperto massimo possibile e' **~1,30%** — quindi oggi, sul
  conto reale, **nessuno dei due tetti morde mai**. Non e' un errore: e' margine
  firmato in anticipo, pronto per quando le sedie saranno di piu'. Va dichiarato
  che oggi e' inerte, **non spacciato per rete**.

### Le tre esclusioni deliberate (e perche')

1. **`225JPY` NON e' nel cluster `JPY`.** E' denominato in yen ma e' un indice
   azionario: il fattore che lo muove e' l'azionario, non lo yen. Metterlo in
   `JPY` farebbe chiudere la porta a un cross JPY per colpa del Nikkei.
   *(Caveat dichiarato: Nikkei e USDJPY hanno una correlazione vera, positiva e
   nota. La proposta la ignora per non gonfiare un cluster gia' popolato. Se
   Claudio preferisce l'altra scelta, e' una riga di mappa.)*
2. **`200AUD` NON e' nel cluster `AUD`**, per lo stesso motivo.
3. **`XAUUSD` NON e' nel cluster `USD`.** L'oro e' quotato in dollari e ha una
   componente inversa al dollaro, ma il suo fattore dominante e' il metallo.
   Sta in `METALLI`. *(Anche questa e' una scelta discutibile: se la si vuole
   nell'altro senso, si aggiunge XAUUSD ai membri di `USD`.)*

## La riga da incollare nell'input (se firmata)

Una riga sola, formato `NOME=SIMBOLI` separati da `;`, tetto per cluster
opzionale con `:`. **Non e' in nessun preset**: va incollata a mano in
`InpClusterMappa` insieme a `InpMaxClusterRiskPct=3.0`.

```
USD=EURUSD,GBPUSD,USDJPY,USDCHF,USDCAD,NZDUSD,AUDUSD;EUR=EURUSD,EURJPY;GBP=GBPUSD,GBPJPY;JPY=USDJPY,EURJPY,GBPJPY,AUDJPY,CHFJPY;AUD=AUDUSD,AUDJPY;METALLI=XAUUSD,XAGUSD;AZ_US=U30USD,SPXUSD,NASUSD;AZ_EU=D30EUR;AZ_APAC=225JPY,200AUD;AZIONARIO:3.5=D30EUR,U30USD,SPXUSD,NASUSD,225JPY,200AUD
```

⚠️ **La stessa riga va messa anche negli EA** che vogliono il tetto (argomento
`cluster_mappa` di `ABTG_GuardiaIngresso`). Se le due mappe divergono, il tetto
**non protegge** sui cluster che il Guardian non conosce: e' fail-open, come
tutto il resto del canale, e l'include lo **scrive nel giornale** una volta
(riga "ATTENZIONE cluster senza riscontro nel Guardian").
Se il broker usa suffissi (`XAUUSD.r`), si usa il jolly finale: `XAUUSD*`.

## Cosa serve per firmare

1. ✅ la mappa qui sopra (o la sua variante), cluster per cluster;
2. ✅ il tetto generale: **3,0%** (firmato il 07/09) e il **3,5%** del
   super-cluster `AZIONARIO` (nuovo, da firmare qui);
3. ⚠️ **prima in sola misura**: il dossier stesso avvisa che *"un valore troppo
   stretto spegne il grappolo DAX delle 08:15, che e' fatto APPOSTA di 3 sedie"*.
   Si tiene il tetto acceso sul Guardian (che misura e scrive) **senza passare
   la mappa agli EA** per una settimana: si legge quante volte sarebbe morso,
   poi si accende lato EA.

## Stato

🟠 **PROPOSTA — NON FIRMATA, NON IN CAMPO.** Il codice che la fa rispettare
esiste (Guardian v1.13 + include v1.60) ed e' **IMPLEMENTATO MA NON COLLAUDATO**:
attese in `backtest_pipeline/attese_cluster.txt`.
