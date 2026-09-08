# 🔬 PASSO 0 di `ABTG_LVNArbitro` — **frequenza ECCELLENTE, e un problema di rischio da separare**

Girato sul VPS l'08/09/2026. `rc=0`, **RILIEVI: 0**, PID degli altri terminali
intatti. **`ESITO: ROUND GIRATO`** — e l'EA ha compilato per la prima volta.

---

## 📊 I NUMERI

| finestra | Trades | Profit | PF | **DD %** |
|---|---:|---:|---:|---:|
| **IS** | **392** | −264,58 | **0,97856** | **18,0147** |
| **OOS** | **618** | +1.022,05 | **1,05108** | **11,3303** |

E le colonne diagnostiche, che sono la parte utile:

| | |
|---|---:|
| **Peggior giornata** | **−2,4661%** |
| segnali di **rifiuto** (long+short) | **371** |
| segnali di **accettazione** | **2.822** |
| trade **long / short** | **188 / 204** |
| barre valutate | 4.485 |
| chiusure per flat di fine seduta | 114 |
| blocchi del Guardian | 0 *(atteso: nel tester non c'è)* |

---

## ✅ LE TRE ATTESE DICHIARATE PRIMA: **tutte e tre CENTRATE**

| attesa congelata | misurato | |
|---|---|---|
| **450-1.100 operazioni** in 21 mesi | **1.010** | ✅ |
| **1,0-2,5 op/giorno** di seduta | **1,57** | ✅ |
| ramo **rifiuto = 10-25%** dei segnali | **11,6%** | ✅ |
| **due lati** dello stesso ordine (max 70/30) | **48% / 52%** | ✅ |

> ### 🎯 E la notizia che la cella stessa dichiarava come "la migliore possibile":
> **IS 392 e OOS 618 sono ENTRAMBI sopra il pavimento dei 150** — e su **un solo
> simbolo**. È il **primo candidato della coda M30 che non ha bisogno di mettere
> in comune i tre indici per avere un campione.**

*(E dopo tre previsioni sbagliate stamattina sull'OpeningReversalB, questa volta
la stima era giusta. Va agli atti anche questo.)*

---

## 🔴 MA IL RISCHIO NON PASSA — e il criterio era congelato

> *"Se il DD sfonda, si BOCCIA subito: il rischio si legge a qualunque n
> (Emendamento B)."*

**DD 18,01% in IS e 11,33% in OOS.** Il muro totale di una challenge è **−10%**:
tutti e due lo sfondano. 🔴

### ⚠️ MA la misura è CONFUSA, e lo dice il nostro stesso driver
`walkforward_generico.ps1`, commento del parametro `-Deposito`:
> *"deposito del tester. **100000 = taglia prop: serve dove il lotto minimo
> schiaccia il rischio**"*

Questo round è girato a **`Deposito = 10.000`**. Su U30USD `VOLUME_MIN = 0,10` e
`CONTRACT_SIZE = 10` (misurati, `REFERTO_R114.txt` r.52-53): **1 € per punto
indice al lotto minimo**. Con rischio 0,65% su 10.000 = **65 € per trade**, e uno
stop di 1,5×ATR su Dow M30 vale ben più di 65 punti.
👉 **Il lotto va al minimo e il rischio vero sale sopra lo 0,65% dichiarato**: è
lo stesso meccanismo trovato stasera su `SuperWave DAX H4`.

> ### 🎯 Quindi il DD del 18% **non è attribuibile**: dentro ci sono DUE cose —
> il comportamento del motore **e** il pavimento del lotto. **Un numero che
> mescola due cose non è un numero.**

### 🟢 E c'è un indizio forte che il problema sia la taglia, non il motore
**Peggior giornata: −2,4661%**, con un muro giornaliero di **−5%**. Un motore che
sfonda il **totale** ma sta comodo nel **giornaliero** è il profilo tipico di
**tante piccole perdite in un conto troppo piccolo**, non di una giornata
catastrofica.

---

## 🧭 LA PROSSIMA MISURA, ed è UNA SOLA CORSA
**Stessa identica cella, `-Deposito 100000`.** Separa le due cose:
- se il DD **crolla** verso il 2-4% → era il **pavimento del lotto**, e il motore
  va in griglia;
- se il DD **resta sopra il 10%** → è il **motore**, e si boccia per rischio
  senza altre discussioni.

🔴 **Dichiarato PRIMA**: questa non è una seconda possibilità concessa a un
motore bocciato. È la **stessa misura fatta alla taglia giusta**, e il parametro
esiste nel driver **proprio per questo caso**, scritto lì dentro da prima di oggi.

## ⚖️ E il MERITO, che qui si può finalmente giudicare
Con n=392 e n=618 siamo **sopra il pavimento dei 150**: il merito è
**giudicabile**, e dice: **IS in perdita (PF 0,979) · OOS in guadagno (PF 1,051)**.
🔴 **Due finestre che si comportano in modo opposto**, ed entrambi i PF sono
**a ridosso di 1**. Anche se il DD si sistemasse alla taglia prop, **questo non è
un edge**: è una moneta con i costi sopra. Va detto adesso, non dopo.
