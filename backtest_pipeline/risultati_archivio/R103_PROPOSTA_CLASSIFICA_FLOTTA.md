# 🏆 R103 — LA CLASSIFICA DELLA FLOTTA (✅ FIRMATA)

**Firmata da Claudio il 24/08/2026, in chat: "FIRMO TUTTE E TRE, PARTIAMO"**
— tutte e tre le decisioni proposte, SENZA modifiche:
1. Finestra COMUNE **2020.01.01 -> 2026.06.30** (6,5 anni, col covid dentro).
2. Le **15 sedie indici** girano su 21 mesi (2024.09.26 -> 2026.06.30), tabella SEPARATA ed etichettata.
3. Classifica su **due colonne** (taglia viva + normalizzato 1%), ordinata sul normalizzato.

**Stato**: la macchina di preparazione (criteri di dettaglio, 40 file prova,
driver, righe di lancio) e' allo studio adesso. Nessuna passata parte finche'
il verificatore non ha dato PASS.

_Nasce da una correzione di rotta di Claudio, 24/08/2026:_
> **"IO VOLEVO LA CLASSIFICA DI TUTTI I NOSTRI EA. DI TUTTI QUELLI TRA CONTO
> PICCOLO E CONTO GRANDE. NON MI INTERESSA LA CLASSIFICA DAL 1999, MI INTERESSA
> UNA CLASSIFICA GIUSTA, + RECENTE, DI ALMENO 5 ANNI"**

**Ha ragione, e R102 non era questo.** R102 misurava 20 sedie forex/argento
sulla finestra **massima** per simbolo (fino al 1993/1971): serviva a rispondere
*"i numeri tengono anche sul lungo?"* — e ha risposto (Blocco 1: no, GBPUSD
capovolge di segno). Ma **non è la classifica della flotta**, e la finestra
massima non è quello che serve per decidere dove mettere i soldi domani.

---

## 1. LA FLOTTA VERA, CONTATA (censimento `.chr` del 23/08, entrambi i conti)

**40 sedie operative su 17 simboli** (esclusi `ABTG_Guardian` e
`ABTG_TradeExporter`, che non sono sedie di trading):

| gruppo | sedie | storico disponibile | 5+ anni? |
|---|---:|---|---|
| **FOREX** | **19** | dal 1999 reale (misurato R102) | ✅ SÌ |
| **METALLI** (XAUUSD, XAGUSD) | **6** | oro 2004, argento 2008 | ✅ SÌ |
| **INDICI** (U30USD, D30EUR, NASUSD, 225JPY) | **15** | **2024.09.26** | ❌ **NO: 21 mesi** |

### 🔴 Il muro, e non è una scelta nostra
`REFERTO_SONDA_STORICO_17-08.md`: su tutti gli indici e le energie il broker
BCM risponde **`2024.09.26` con verdetto `COMPLETO`** — cioè *"non manca sul
disco: il broker NON CE L'HA"*. **Per 15 sedie su 40 una classifica a 5 anni
NON È FISICAMENTE POSSIBILE**, e nessun round può cambiarlo: MT5 testa solo
sui dati del broker collegato. Quelle sedie hanno **21 mesi**, punto.

👉 Le 15 sedie indici NON si buttano fuori (Claudio ha detto *"tutti"*): vanno
in una **seconda tabella, dichiarata a 21 mesi**. Mettere 21 mesi e 6,5 anni
nella stessa classifica sarebbe la truffa peggiore del round.

## 2. LE TRE DECISIONI (le mie proposte sono marcate 👉)

### DECISIONE 1 — la finestra comune
| opzione | periodo | cosa contiene |
|---|---|---|
| 👉 **A** | **2020.01.01 → 2026.06.30 = 6,5 anni** | il **crollo covid** (feb-mar 2020), il toro 2021, l'orso 2022, i tre anni recenti |
| B | 2021.07.01 → 2026.06.30 = 5 anni esatti | post-covid, nessun crash vero dentro |

**Perché A**: soddisfa *"almeno 5 anni"* ed è l'unica finestra recente che
contiene **un crollo vero**. Per la corsia RISCHIO un crash misurato vale più
di due anni di calma: è gratis e sta lì.

### DECISIONE 2 — le 15 sedie indici
👉 **Girano comunque, sui loro 21 mesi (2024.09.26 → 2026.06.30), in una
tabella SEPARATA** con l'etichetta stampata su ogni riga: *"21 mesi, UN solo
regime, NON confrontabile con la tabella a 6,5 anni"*.
_(L'alternativa sarebbe escluderle: ma Claudio le vuole vedere, e vederle
etichettate è più onesto che non vederle.)_

### DECISIONE 3 — come si ordina la classifica (il punto che la rende GIUSTA)
Le sedie girano a taglie diverse (da 0,25% a 1,0%): confrontarle in euro
"come stanno" premia chi ha la taglia più grossa, non il motore migliore.
👉 **Due colonne accanto, e si ORDINA sulla seconda**:
1. **PROFITTO ALLA TAGLIA VIVA** = quello che avrebbe fatto davvero sul conto;
2. **PROFITTO NORMALIZZATO A 1%** = il confronto fra **motori**, tutti alla
   stessa taglia [APPROSSIMATO: riscalatura lineare, convenzione
   `CONTRATTI_SEDIE` punto 2].
Più le colonne che decidono davvero: **PF**, **DD massimo** (e il rapporto col
DD promesso dal contratto), **n operazioni**, **peggior giornata**.

## 3. COSA COSTA (ed è la buona notizia)

| | R102 (finestra massima) | **R103 (6,5 anni)** |
|---|---:|---:|
| anni-sedia da simulare | ~2.280 | **~260** |
| barre M1 da scaricare | 27+ anni × 12 simboli | **6,5 anni × 17 simboli** |
| stima durata | 6-16 ore + scarico | **[STIMA] 1-3 ore** |

Lo scarico è la parte che stanotte ha fatto male, e qui è **4 volte più
leggero**; e le barre dei simboli già fatti (GBPUSD, EURUSD, AUDUSD) **restano
a disco**. Si lancia comunque **a blocchi** (famiglia per famiglia), così ogni
pezzo torna col suo zip.

## 4. COSA QUESTO ROUND NON FARÀ (dichiarato prima)

- **Non promuove e non boccia per merito**: resta l'Emendamento regola B. La
  classifica è un'informazione per decidere, non un verdetto automatico.
- **Non ottimizza niente**: una cella per sedia, quella VIVA. Cercare celle
  migliori sulla finestra di classifica sarebbe pescare.
- **Nessun tick reale** (esistono solo dal 2024.07.05): modello OHLC M1 → il DD
  è un **limite inferiore**, il profitto una **stima generosa del lordo**
  (spread corrente, zero slippage). **Non è un guadagno.**
- **Niente DD di portafoglio**: 40 sedie insieme è un altro round (macchina
  R16/R34), e resta la priorità successiva della corsia rischio.
- R102 **non si butta**: i suoi numeri lunghi restano agli atti come misura di
  ROBUSTEZZA. I blocchi 2-6 vanno in coda dietro R103.

## 5. Firma

```
[ ] DECISIONE 1: finestra 2020.01.01 -> 2026.06.30 (6,5 anni, col covid)
[ ] DECISIONE 2: le 15 sedie indici in tabella separata a 21 mesi, etichettate
[ ] DECISIONE 3: due colonne (taglia viva + normalizzato 1%), si ordina sul normalizzato
```
Alla firma: criteri di dettaglio, 40 file prova, driver, righe dal
verificatore. Nessuna passata parte prima.


---

## 📌 CHIARIMENTO DI CLAUDIO (24/08/2026 mattina, prima di uscire)

> "Riprova tu, io sono via stamattina. Voglio avere una classifica aggiornata
> x ogni Ea e x ogni simbolo di ogni Ea se L'EA prevede più di 1 simbolo. Così
> stabiliamo i profitti di ognuno x fare una stima. Vedi tu se vuoi farlo anno
> x anno x ognuno o se vuoi fare la somma di tutti ma vorrei capire se
> esistono anni negativi x qualcuno. Bastano credo 5 anni o valuta tu."

**Tre cose, agli atti, e diventano requisito vincolante del round:**

1. **Unità di misura = SEDIA (EA + simbolo), non EA.** Coerente con quanto già
   scritto: le 40 righe della classifica restano una per (EA, simbolo, magic)
   — `ABTG_PunteLarry` ha 6 righe distinte (una per GBPUSD, EURAUD, GBPJPY,
   EURCAD, U30USD, XAUUSD), non una riga sola.
2. **LA SPINA DORSALE ANNO PER ANNO DIVENTA OBBLIGATORIA, per TUTTE e 40 le
   sedie** (non più "se costa poco, tienila" come nella bozza iniziale):
   Claudio vuole vedere **quali anni sono negativi, sedia per sedia**. Ogni
   riga della classifica porta quindi, oltre al totale sui 6,5 anni: la
   colonna **"anni negativi / anni totali"** e il dettaglio anno-per-anno nel
   referto esteso.
3. **La finestra 6,5 anni (2020-2026) resta quella firmata** — soddisfa il
   "bastano 5 anni" e aggiunge il covid come test di stress gratuito.

**Autorizzazione esplicita**: *"Riprova tu"* mentre è assente — si procede
in autonomia sulle decisioni tecniche già firmate, senza attendere ulteriori
firme per questo chiarimento (non cambia il perimetro né la finestra, solo
rende obbligatoria una colonna già prevista come opzionale).
