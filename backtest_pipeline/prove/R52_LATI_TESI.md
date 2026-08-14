# R52 — "e se avessimo tenuto anche l'altro lato?" — tesi prima dei numeri

_Domanda di Claudio, 14/08/2026 sera, con R50 ancora in corso: "se un EA e'
tarato solo su long, il test prevede che valuti se lo short dello stesso EA
sarebbe potuto entrare come candidato?" E subito dopo: "voglio essere sicuro,
altrimenti rifacciamo il lavoro daccapo"._

---

## 1. Risposta secca: NO, R50 non lo fa. E non deve farlo.

R50 misura **le celle promosse esattamente come sono**. Accendere il lato
opposto vuol dire cambiare un parametro, e i criteri congelati dicono:

> "Vietato cercare parametri nuovi sui dati vecchi: sarebbe overfitting su una
> finestra piu' lunga, cioe' lo stesso errore con piu' anni."

Se lo stesso round misurasse le celle **e** provasse varianti, non sapremmo
piu' quale delle due cose stiamo leggendo.

## 2. La buona notizia: sulle 8 celle di R50 il problema NON si pone

Sono andato a leggere i lati veri, cella per cella, invece di dedurli:

| cella | lati | perche' |
|---|---|---|
| BB_GBPUSD, BB_EURUSD | **entrambi** | `ABTG_BreakingBand` non ha nemmeno gli input `InpAllowLong/InpAllowShort`: opera nei due sensi per costruzione |
| GAP_GBPUSD, GAP_EURUSD | **entrambi** | idem per `ABTG_GapFill` |
| PTE_GBPUSD | entrambi | default `true` / `true` |
| SW_GBPUSD | entrambi | default `true` / `true` |
| EZ_GBPUSD | entrambi | scritto nella cella |
| LARRY_GBPUSD | **SOLO SHORT** | `InpAllowLong=0; InpAllowShort=1` |

**Sette celle su otto lavorano gia' in tutti e due i sensi.** Nell'orso 2022
possono guadagnare: se non lo fanno, e' un difetto del motore, non del
perimetro. Quindi la paura "abbiamo tarato solo il long e ora l'orso ci
boccia per forza" **su queste otto celle non ha fondamento**, e il lavoro non
va rifatto daccapo.

Questa verifica ha pero' fatto emergere un errore nei criteri, corretto e
dichiarato in coda a `PROVA_REGIME_CRITERI.md` (CORREZIONE n.2): il criterio
B parlava di celle "quasi tutte long-only" che in R50 non esistono. La
correzione rende il giudizio **piu' severo**, che e' l'unica direzione in cui
e' lecito muoversi a round iniziato.

## 3. Dove la domanda invece MORDE

**LARRY e' l'unica cella in cui il lato e' stato una SCELTA** (long spento a
mano). E le celle che oggi mancano — quelle sugli indici, che entreranno con
Pepperstone — sono anche quelle dove il lato e' stato scelto piu' spesso.

E c'e' un motivo strutturale per cui la domanda e' giusta: le celle sono state
tarate su **21 mesi con un regime solo, un mercato che saliva**. In quella
finestra il long vince perche' il campione e' amico del long. Il lato scelto
li' dentro **non e' una scoperta, e' un riflesso del campione**. Esattamente
il difetto che la prova di regime esiste per smascherare.

Quindi: domanda legittima, ma e' un ALTRO round.

## 4. IPOTESI (scritte prima di qualunque numero)

1. Per le celle in cui il lato e' stato scelto, il lato scartato **non e'
   inutile**: e' semplicemente stato misurato in una finestra che lo
   penalizzava.
2. Il candidato piu' probabile e' il **caso simmetrico di LARRY**: se lo short
   paga nell'orso, il long dovrebbe pagare nel toro 2021. Se non lo fa,
   l'asimmetria e' del motore e va detta.
3. Rischio dichiarato, il piu' serio di tutti: **scegliere il lato dopo aver
   visto quale regime ha pagato e' la definizione di senno di poi.** Nessun
   criterio lo elimina; si puo' solo impedire che diventi una promozione.

## 5. CRITERI (congelati il 14/08/2026, a R50 non ancora letto)

**REGOLA MADRE, non negoziabile.** I dati `_EXT` possono **PROPORRE** una
ipotesi, **mai** validarla. Nessuna cella entra in squadra per un risultato
ottenuto sul feed esterno. Chi passa qui diventa **candidato**, e la conferma
si fa dove si opera:

```
_EXT (R52)  ->  ipotesi
BCM nativo  ->  misura vera, walk-forward IS/OOS
portafoglio ->  standard "aggiunge profitto E abbassa le code"
vivaio      ->  15 trade di forward per famiglia
```

Saltare un gradino annulla il round.

**A. PERIMETRO.** Si prova SOLO dove il lato e' stato una scelta esplicita
(oggi: LARRY; domani le celle indici). Sulle celle gia' bidirezionali non c'e'
niente da provare.

**B. TRE VARIANTI, NON UNA GRIGLIA.** Per ogni cella: lato originale (gia'
misurato in R50), lato **speculare**, **entrambi i lati**. Tutto il resto
congelato. Tre lanci per finestra, non una spazzolata.

**C. SOGLIA DI CANDIDATURA.** La variante entra in lista solo se, nelle
finestre avverse, fa **PF >= 1,10** con DD dentro il criterio A di R50, **e**
la serie completa (tutte e quattro le finestre) non peggiora il DD della cella
originale. Aggiunge profitto ma alza il DD -> scartata, come per tutti.

**D. REGOLA DEI DUE BANCHI.** Serve la stessa direzione in ORSO e CROLLO. Un
solo periodo e' un aneddoto.

**E. ETICHETTA OBBLIGATORIA.** Una variante che vince **solo** nelle finestre
avverse non e' un motore migliore: e' un **motore di regime**. Va scritto
nella scheda e pesato di conseguenza. Non si spaccia per un miglioramento.

**F. QUANDO.** Dopo R50 e dopo Pepperstone, perche' il grosso del perimetro
sono gli indici. Non prima: senza indici sarebbe un round su una cella sola.

## 6. Cosa questo round NON potra' dire

- Non dira' che la squadra era sbagliata. Dira' se qualcosa era rimasto fuori
  per colpa della finestra invece che del merito.
- Non trasforma il senno di poi in metodo. Lo confina: propone qui, decide
  altrove.
- Non tocca nulla di vivo. Nessun EA cambia lato in forward per effetto di
  questo round.
