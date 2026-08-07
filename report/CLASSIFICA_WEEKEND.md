# 🏆 CLASSIFICA DEL WEEKEND — chi va verso la prop, chi resta su MT5

_Compilata man mano che i risultati della coda arrivano sul repo. I **criteri sono
congelati qui sotto, PRIMA di qualsiasi numero** (07/08/2026, sera): da adesso non si
spostano più._

## I criteri, dichiarati prima

Un EA entra in **🥇 CANDIDATO PROP** solo se, **a tick reali** (l'OHLC non dà mai verdetti):

1. positivo in **tutte e due** le finestre (IS e OOS);
2. **Profit Factor ≥ 1,10** fuori campione;
3. le **celle vicine** positive — non un picco isolato (il Nasdaq ce l'ha già insegnato);
4. **drawdown da prop**: riferimento DD OOS < 10% all'1% di rischio.

**Preferenza di timeframe (regola di Claudio, dichiarata il 07/08 prima dei risultati):**
a parità di criteri passati si preferisce **H1**, perché i trade chiudono in giornata —
che per una prop con limite giornaliero è una qualità, non un dettaglio. **H4 è accettato**
se fa trade più profittevoli e più puliti (meno rumore), cioè se batte l'H1 **sia** su
profitto **sia** su PF fuori campione. Sotto H1 niente prop: troppo rumore, lo dice un mese
di forward sulle aperture.

Chi non passa i quattro criteri **non viene spento da un backtest**: resta su MT5 in
demo, al rischio che decide Claudio. Ma **non tocca una prop**.

Un EA resta **⏳ in coda** finché non ha i CSV a tick reali; **🔬 screening** se ha solo
l'OHLC; **❌ niente edge** se non ha nemmeno una cella positiva nelle due finestre OHLC
(stessa cella).

## ⚠️ Prima di leggere qualsiasi riga

Lo storico `2024.09.26` è **misurato solo sugli indici**. Su oro, argento, forex e Nikkei
è un'ipotesi: per ogni riga va controllato il rapporto **trade/mese IS contro OOS** — se
fa ~2, metà finestra IS non esisteva (successo il 05/08) e i numeri IS non valgono.

---

## 🥇 CANDIDATI PROP (tutti e 4 i criteri, a tick reali)

_(vuota — nessun risultato ancora)_

## 🖥️ RESTANO SU MT5 (misurati, non da prop)

_(vuota)_

## ❌ NIENTE EDGE NEMMENO IN SCREENING

_(vuota)_

## 🔬 / ⏳ IN LAVORAZIONE

Tutti i 42 lavori di `prove/CODA.csv`, finché i loro CSV non arrivano.
