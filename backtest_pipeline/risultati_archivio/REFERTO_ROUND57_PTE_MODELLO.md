# 🔻 REFERTO R57 — LA PROMOZIONE DI PTE_GBPUSD **CADE**

_15/08/2026 sera. 2 celle × 4 finestre = **8 CSV su 8**, igiene gemelle
**8/8**. Stesso feed `_EXT`, stesse finestre, **parametri identici carattere
per carattere** a R56. **L'unica cosa cambiata: il modello del tester**
(1 = OHLC M1 → 2 = tick generati dentro la barra M1)._

---

## 1. 🚨 IL CONFRONTO, A UNA SOLA VARIABILE

### `PTE_GBPUSD`

| finestra | R56 — OHLC | R57 — tick generati | |
|---|---|---|---|
| **ORSO 2022** | **+1.245** PF **1,62** n18 | **−1.249** PF **0,75** n17 | 🔻 **cambia SEGNO** |
| **CROLLO 2020** | +70 PF 1,07 n11 | **+1.850** PF 2,85 n7 | 🔺 |
| TORO 2021 | +1.362 PF 1,45 n37 | **−16** PF 1,00 **n19** | 🔻 |
| LATERALE 2019 | +5.284 PF 1,84 n51 | +2.124 PF 1,27 **n33** | 🔻 |

### `PTE_USDJPY`

| finestra | R56 — OHLC | R57 — tick generati |
|---|---|---|
| ORSO | −1.888 PF 0,81 n46 | −2.848 PF **0,71** **n27** |
| CROLLO | +1.079 PF **2,08** n7 | **−2.193** PF **0,26** n5 🔻 |
| TORO | +203 PF 1,04 n36 | −1.329 PF 0,77 **n22** |
| LATERALE | +3.744 PF 1,90 n40 | +2.250 PF 1,45 **n29** |

---

## 2. ⛔ LA PROMOZIONE DI RANGO E' RITIRATA

Criterio **B** congelato: nelle finestre avverse **PF ≥ 0,90**.

> `PTE_GBPUSD` nell'**ORSO** fa **PF 0,75**. **Non passa.**

E il criterio **C** (promozione, PF ≥ 1,10 nell'orso) non e' nemmeno in
discussione: l'orso e' **in perdita**.

**Stamattina, in R56, avevo scritto:**
> _"PTE_GBPUSD e' l'unica cella del portafoglio che, senza toccare un
> parametro, sopravvive all'orso 2022 E al crollo Covid... ne abbiamo uno, ed
> e' misurato."_

**Era misurato male.** Quella frase valeva **solo sotto il modello OHLC**, e
il modello OHLC non e' un verdetto. **La promozione cade.**

Nel referto R57 di stamattina avevo anche scritto, prima di vedere i numeri,
cosa avrebbe significato un crollo dei PF:
> _"il risultato di R56 era un artefatto del modello, e lo sapremo **prima**
> di metterci sopra dei soldi."_

**E' successo esattamente quello. Il test ha fatto il suo lavoro.**

## 3. 🔍 Il meccanismo: **i trade si dimezzano**

Il segnale piu' forte non e' il profitto, e' il **conteggio**:

| cella / finestra | n R56 | n R57 | |
|---|---:|---:|---|
| PTE_GBPUSD TORO | 37 | **19** | −49% |
| PTE_GBPUSD LATERALE | 51 | **33** | −35% |
| PTE_USDJPY ORSO | 46 | **27** | −41% |
| PTE_USDJPY TORO | 36 | **22** | −39% |

**Fino alla meta' delle operazioni sparisce quando i tick vengono generati
dentro la barra.**

⚠️ **[INCERTO] il PERCHE'.** Con i tick dentro la barra cambiano due cose
insieme: gli stop possono essere toccati **prima** (chiusure diverse, quindi
posizioni che occupano il posto piu' a lungo) e i pendenti possono riempirsi
o non riempirsi a prezzi diversi. **Non ho i per-trade per separare le due
cause, e non le invento.** Serve un round per-trade se si vuole capire.

Quello che si puo' dire senza incertezza: **la cella non e' robusta al
modello di riempimento**, e questo basta per fermare la promozione.

## 4. 📏 La regola di progetto ha appena avuto la sua prova diretta

> **"L'OHLC e' solo screening, i verdetti solo a tick."**

E' una regola che il progetto applica da sempre. Fino a oggi era una
precauzione ragionevole; da oggi e' **misurata**: sulla stessa cella, sugli
stessi dati, con gli stessi parametri, **cambiare solo il modello di
riempimento ha ribaltato il segno della finestra ORSO**, da +1.245 a −1.249.

Non e' un ribaltamento IS→OOS come i trenta che abbiamo contato: e' un
**ribaltamento di MODELLO**, un asse nuovo. Va contato a parte, e va
ricordato ogni volta che qualcuno (io compreso) si entusiasma per un numero
OHLC.

## 5. ⚠️ Cosa questo referto NON dice

- ❌ **Non dice che PTE_GBPUSD e' una cattiva strategia.** Dice che il suo
  risultato **nell'orso** dipende dal modello di riempimento, quindi non e'
  ancora dimostrato.
- ❌ **Non dice che R57 e' la verita'.** I tick di R57 sono **GENERATI** dalle
  barre M1, non reali. Sono un modello piu' severo, non un fatto.
- ❌ **Non tocca niente in forward.** PTE resta in campo esattamente com'e':
  nessun parametro, nessun peso, nessun magic e' cambiato.

## 6. ▶️ Il passo che adesso conta davvero

**R58: tick REALI su BCM**, con la data d'inizio storico **misurata** e non
ipotizzata. E' l'unico dei tre test che porta un verdetto.

Resta vero il limite gia' dichiarato: **BCM non ha l'orso 2022 ne' il Covid**,
quindi R58 conferma il **riempimento**, non la **robustezza di regime**. Per
quella servono i dati lunghi — e per gli indici la strada e' aperta
(Dukascopy dal 2012, Pepperstone da misurare lunedi').
