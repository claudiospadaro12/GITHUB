# 📉 LA FLOTTA GIRA AL 58% DELLA FREQUENZA PROMESSA — e non e' un blocco

**Nato da una domanda di Claudio (11/09):** *"Sono due giorni che aprono pochi
trade sul conto piccolo. E' tutto ok? O hai modificato e bloccato qualche sedia?"*

---

## 1. ✅ LE TRE VERIFICHE CHE RISPONDONO ALLA DOMANDA LETTERALE — tutte negative

| domanda | verifica | esito |
|---|---|---|
| Ho modificato qualcosa? | `git log` su **tutti** i `.set`, `.mq5` e preset dal 09/09 | 🟢 **vuoto: nessuna modifica** |
| Qualche sedia e' staccata? | `CODA_01` del runner, 11/09 03:30 | 🟢 **52 sedie nel profilo attivo**, 40 sul piccolo |
| Il Guardian sta bloccando? | `CODA_09`, ultima riga del giornale | 🟢 `dayLoss=0.00%` · `rischioAperto=0.00%` · **stato operativo** |

👉 **Nessun blocco, nessuna modifica, nessuna sedia staccata.**

## 2. ⚠️ MA LA RISPOSTA ONESTA ALLA DOMANDA VERA E' **NO, NON E' TUTTO OK**

Il ritmo non e' calato **negli ultimi due giorni**: e' **strutturalmente sotto il
promesso**, e nessuno lo aveva misurato.

**Finestra**: 13 giornate con operazioni, dal **25/08** al **10/09**.
**Metodo**: operazioni contate per **`pid` distinti** (posizioni), **non** per deal
— classe 226, un parziale al 50% raddoppierebbe il conto.

| sedia | atteso | osservato | rapporto | quanto e' strano |
|---|---:|---:|---:|---|
| `771531` EMA200 Dow | 20,2 | **11** | **55%** | 🔴 `p = 0,020` |
| `770101` DAX Apertura | 12,6 | 7 | 56% | 🟠 `p = 0,066` |
| `770511` SuperWave Dow | 6,5 | **8** | **123%** | 🟢 nella norma |
| `770202` Dow Apertura | 6,0 | **1** | **17%** | 🔴 `p = 0,018` |
| `770611` ORB Dow | 5,6 | 3 | 54% | 🟠 `p = 0,192` |
| `970913` SupRev Nasdaq | 4,4 | 2 | 45% | 🟠 `p = 0,183` |
| `770901` SupertrendRev | 2,3 | **0** | **0%** | 🟠 `p = 0,096` |
| `770411` MaxMin DAX | 1,0 | **2** | **197%** | 🟢 nella norma |

> ## 🔴 **TOTALE: attese 58,6 operazioni, osservate 34 = 58% del promesso.**
> Probabilita' di vedere 34 o meno **se il promesso fosse vero: p = 0,00035.**
> 👉 **Non e' sfortuna.** Sulla singola sedia il campione e' sottile e quasi tutte
> le righe sono compatibili con il caso; **e' l'aggregato che non lo e'**, ed e'
> l'aggregato che conta perche' il pavimento di frequenza si applica **per
> famiglia**, non per sedia (firma del 07/09).

## 3. 🚨 E QUESTO FA SCATTARE UN CRITERIO GIA' FIRMATO

`report/FIRME_2026-08-18.md`, corsia **TAGLIANDO**, testuale:

> *"Frequenza molto sotto il promesso → **revisione**."*

🔴 **Il criterio e' scattato, e nessuno se n'era accorto** — perche' finora la
frequenza si guardava **promessa contro pavimento**, mai **promessa contro
campo**. Questo referto e' la prima misura del secondo tipo.

## 4. 🧪 I CONTRO-ESEMPI, prima di trarne conclusioni

| ipotesi che demolirebbe la lettura | verifica | esito |
|---|---|---|
| *"il file dei trade e' fermo, come il 04/09"* | scritto **ogni sera alle 22:45** da 5 giorni di fila (`git log`); ultima riga **10/09 17:06** | ❌ **smentita**: il file e' vivo |
| *"la finestra include giorni non di borsa"* | contate solo le **giornate con almeno un'operazione** | ❌ smentita |
| *"il conto e' gonfiato dai parziali"* | contati i **`pid` distinti**, non i deal | ❌ smentita |
| *"le frequenze promesse sono vecchie"* | ✅ **VERA, ed e' il limite di questo referto**: vengono dai backtest, su finestre e periodi diversi da queste 13 giornate | ⚠️ **`[LIMITE DICHIARATO]`** — il confronto e' *promessa di backtest* contro *campo di 13 giorni*, non due misure omogenee |
| *"13 giornate sono poche"* | ✅ **VERA per la singola sedia** (quasi tutte le righe hanno `p > 0,05`) | ⚠️ **regge solo l'aggregato**, e va detto |

## 5. 🎯 PERCHE' QUESTO E' IL PROBLEMA CENTRALE, NON UN DETTAGLIO

Il pavimento e' **1,00 operazioni al giorno per famiglia**. Il campo dice **2,62
op/giorno** in tutto, su **otto** sedie candidate — cioe' **0,33 per sedia**.

👉 **A 0,33 op/giorno una sedia arriva a 150 operazioni in circa DUE ANNI.**
E la soglia dei 150 e' quella sotto cui il merito resta **sospeso**.

🔴 **Non e' un problema di oggi: e' il motivo per cui al 1° ottobre non avremo
una flotta provata**, ed e' la stessa conclusione a cui e' arrivato il piano v2
per un'altra strada.

---

📌 **Cosa NON so ancora**, e non lo mascherò: **l'11/09 non e' in questo file.**
L'esportazione gira la sera alle 22:45, quindi la giornata di oggi si vede
stanotte. Se oggi fosse davvero a zero, sarebbe **la terza giornata sottile di
fila** — ma finche' il dato non c'e', **questa resta una cosa non misurata**.
