# 🔻 REFERTO R60 — `ABTG_MeanRevert` BOCCIATO: **12 celle su 12 in perdita**

_16/08/2026. Primo EA nato dal **setaccio manuale** (22 file letti nel
sorgente, 1 promosso). Screening OHLC, GBPUSD H1, **11 anni e mezzo**:
IS `2015.01.01 → 2019.08.07` · OOS `2019.08.08 → 2026.06.30`.
6 celle x 2 finestre = 12 pass, igiene 12/12._

**La domanda del round:** _un fade simmetrico dell'estremo copre il buco del
LATERALE e ci da' finalmente uno short?_

> ## ❌ **NO. E non ci va nemmeno vicino.**

---

## 1. I NUMERI — non c'e' una cella positiva, in nessuna finestra

### IN CAMPIONE (2015.01.01 → 2019.08.07)

| `InpLookback` | Profitto | PF | DD | n |
|---|---:|---:|---:|---:|
| 50 | **−19.581** | 0,946 | 25,1% | 774 |
| 100 | **−30.462** | 0,837 | **30,8%** | 408 |
| 150 | **−16.960** | 0,878 | 23,0% | 272 |
| 200 | **−11.539** | 0,886 | 17,1% | 199 |
| 250 | **−8.169** | 0,898 | 12,9% | 158 |
| 300 | **−7.053** | 0,882 | 13,2% | 120 |

### FUORI CAMPIONE (2019.08.08 → 2026.06.30)

| `InpLookback` | Profitto | PF | DD | n |
|---|---:|---:|---:|---:|
| 50 | **−25.628** | 0,950 | **37,0%** | 1.160 |
| 100 | **−3.939** | 0,986 | 19,6% | 550 |
| 150 | **−22.993** | 0,853 | 25,8% | 344 |
| 200 | **−19.517** | 0,852 | 24,1% | 285 |
| 250 | **−15.680** | 0,856 | 22,8% | 211 |
| 300 | **−16.771** | 0,823 | 21,2% | 185 |

> 🔴 **DODICI CELLE SU DODICI IN PERDITA.** Il PF piu' alto di tutto il lotto
> e' **0,986** — sotto 1,00 anche il migliore. Il drawdown arriva al **37%**,
> quando il muro di una prop e' al **10%**.

**Non e' una bocciatura al fotofinish: e' un motore che non ha edge.**

---

## 2. ✅ E LA MACCHINA FUNZIONA — quindi il verdetto e' sulla STRATEGIA

Due controlli, ed e' importante che siano puliti: senza, non sapremmo se
stiamo bocciando l'idea o un bug.

**A. L'EA opera, e opera come previsto.** Da 120 a 774 trade in campione, da
185 a 1.160 fuori. Il numero scende al crescere di `InpLookback`, esattamente
come deve: un estremo di 300 barre e' piu' raro di uno di 50.

**B. Trade/mese coerenti fra le due finestre — il rilevatore di storico corto e' PULITO:**

| `InpLookback` | trade/mese IS | trade/mese OOS | scarto |
|---|---:|---:|---:|
| 50 | 14,1 | 14,0 | −1% |
| 100 | 7,4 | 6,6 | −11% |
| 150 | 4,9 | 4,1 | −16% |
| 200 | 3,6 | 3,4 | −5% |
| 250 | 2,9 | 2,5 | −12% |
| 300 | 2,2 | 2,2 | +2% |

**Nessun buco di storico.** Il `@DAQUANDO 2015.01.01`, scelto cinque anni
dentro il misurato, era la scelta giusta: **i dati ci sono, la strategia no.**

**C. Le `.ini` sono quelle che volevo — e il problema di R58 NON si e' ripetuto:**
```
Symbol=GBPUSD   Period=H1   Model=1   FromDate=2015.01.01  ToDate=2019.08.07
InpLookback=200||50||50||300||Y     <- la MIA riga, l'unica con Y
InpTF=16385||16385||0||16385||N
InpRiskPercent=1.0||1.0||0||1.0||N
...tutti gli altri pinnati N
```
> 🛡️ **Il punto 5 della checklist ha funzionato al primo impiego.** Il giro a
> vuoto aveva annunciato `spazzolati: 1 · InpLookback 6 celle`, e MT5 ha
> ricevuto esattamente quello. In R58 questo controllo non c'era.

---

## 3. 📉 Spearman IS→OOS = **+0,086** — e stavolta non vuol dire niente

Quattordicesima misura della serie, **ma va letta per quello che e'**:

| `InpLookback` | rango IS | rango OOS |
|---|---:|---:|
| 300 | 1° | 3° |
| 250 | 2° | 2° |
| 200 | 3° | 4° |
| 150 | 4° | 5° |
| 50 | 5° | 6° |
| 100 | **6° (la peggiore)** | **1° (la migliore)** |

⚠️ **Su una famiglia dove TUTTE le celle perdono, la correlazione dei ranghi
non porta informazione**: sta ordinando gradi di perdita. La riporto per non
saltare un passo del metodo, **non** come argomento. La serie storica resta
**dodici negativi su tredici** sulle famiglie che avevano un edge da misurare.

---

## 4. ⛔ IL VERDETTO, coi criteri congelati PRIMA

Il file prova (`prove/ABTG_MeanRevert.txt`, scritto **prima** del codice)
diceva:

> _"**1. IL CRITERIO CHE CONTA:** POSITIVA nella finestra LATERALE 2019 [...]
> Se e' rossa anche li', **la tesi e' morta e si chiude la famiglia.** Non
> negoziabile, non si ammorbidisce dopo."_

**Non serve nemmeno arrivare alla prova di regime: e' rossa OVUNQUE**, su
11 anni e mezzo che contengono il laterale 2019, il crollo 2020 e l'orso 2022.

| criterio congelato | esito |
|---|---|
| 1. positiva nel laterale | ❌ **negativa in tutte e 12 le celle** |
| 3. PF ≥ 0,90 nelle avverse | ❌ 10 celle su 12 sotto 0,90 |
| 4. DD ≤ 20% · peggior giornata > −2,5% | ❌ DD fino al **37%** |
| 5. altopiano, non picco | ❌ **non c'e' nessun altopiano**: non c'e' una cella positiva su cui centrarsi |

> ### 🔻 **FAMIGLIA CHIUSA.** `ABTG_MeanRevert` non va in vivaio, non va in
> panchina, non si ri-ottimizza: **esce.**

### E la prova di regime NON si lancia

Sarebbe spendere una macchina su un cadavere. Il criterio 2 (simmetria
long/short misurata separatamente) **decade**: non c'e' niente da separare
quando il totale perde in ogni cella e in ogni finestra.

---

## 5. 🧭 COSA IMPARIAMO — e non e' poco

**A. La tesi del fade dell'estremo, su GBPUSD H1, e' falsificata.** Comprare
il minimo di N barre puntando al centro del range **perde a ogni N fra 50 e
300**, su 11 anni. Il limite dichiarato prima si e' avverato:

> _"R:R 1:1 con uno stop LARGO. Serve un win rate SOPRA IL 50% per stare in
> piedi."_

Con PF fra 0,82 e 0,99, **quel win rate non c'e'**.

**B. Il buco del LATERALE resta scoperto.** Era il motivo per cui questo EA
esisteva. Restano in coda `ABTG_BandFade` (Bollinger+RSI, altra meccanica) e
`ABTG_RangeBudget` (budget ADR, per il crollo).

**C. 🟢 E il dato di processo, che e' la notizia buona di questo round:**

| | |
|---|---|
| dal file grezzo al verdetto | **una giornata** |
| costo | 12 pass OHLC, **zero forward, zero euro** |
| errori nel percorso | **zero** — giro a vuoto passato, `.ini` corrette, igiene 12/12 |

**Il setaccio ha selezionato 1 file su 22, l'imbuto l'ha bocciato in un
pomeriggio.** E' esattamente il ritmo che serve: **si scarta in fretta e a
costo zero**, e l'unica cosa che si spende e' tempo di macchina.

---

## 6. ⚠️ QUELLO CHE QUESTO REFERTO **NON** DICE

- 🚫 **Non dice che la mean-reversion sia morta.** Dice che **questa**
  meccanica (estremo di N barre → centro del range, R:R 1:1) non funziona
  **su GBPUSD H1**. Altri simboli e altri timeframe non sono stati misurati —
  e non lo saranno: senza una cella positiva da nessuna parte, cercare il
  simbolo giusto sarebbe **pesca**, il vizio che l'imbuto esiste per impedire.
- 🚫 **Non e' un verdetto a tick reali** — e non serve che lo sia. Vale la
  prassi di FASE 0 (_"15 lavori su 42 senza edge nemmeno in OHLC"_): **l'OHLC
  non promuove mai, ma boccia**, e qui boccia 12 volte su 12 con PF sotto 1,00
  ovunque. I tick reali sono piu' severi, non piu' generosi.
- 🚫 **Non toglie valore al setaccio.** Il file era il migliore di 22 per
  ragioni che restano vere (2 input, simmetrico, SL vero, rischio in %).
  **Un buon candidato puo' perdere: e' per questo che si misura.**

> ### **Nessun parametro degli EA in forward e' stato toccato.**

---

### Materiale
- `backtest_pipeline/risultati_prove/meanrevert_r60/` (2 CSV + 3 `.ini`)
- EA: `mql5/Experts/ABTG_MeanRevert.mq5`
- prova con criteri congelati: `backtest_pipeline/prove/ABTG_MeanRevert.txt`
- origine: `backtest_pipeline/caccia_strategie/SETACCIO_MANUALE.md`
