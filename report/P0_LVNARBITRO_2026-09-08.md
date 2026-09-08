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

---

# 🏁 LA CORSA A **DEPOSITO 100.000** — e il verdetto si scrive da solo

| finestra | Trades | Profit | PF | **DD %** | peggior giornata |
|---|---:|---:|---:|---:|---:|
| **IS** a 10k | 392 | −264,58 | 0,97856 | **18,0147** | −2,4661% |
| **IS** a **100k** | 392 | −3.374,90 | 0,97485 | 🔴 **19,3534** | −2,8046% |
| **OOS** a 10k | 618 | +1.022,05 | 1,05108 | **11,3303** | — |
| **OOS** a **100k** | 618 | **+11.310,73** | 1,05227 | 🔴 **11,7644** | −2,4542% |

## 🔴 IL DD NON È CROLLATO. È SALITO DI POCO.

Il criterio era **dichiarato prima della corsa**:
> *"se il DD **crolla** verso il 2-4% → era il pavimento del lotto, e il motore va
> in griglia; se **resta sopra il 10%** → è il **motore**, e si boccia per
> rischio senza altre discussioni."*

**18,01 → 19,35** e **11,33 → 11,76**. 👉 **BOCCIATO PER RISCHIO.**

## 🙋 E la mia ipotesi era SBAGLIATA — il che è la notizia più utile del round
Avevo scritto che il DD del 18% *"non è attribuibile"* perché il **pavimento del
lotto** poteva gonfiarlo. **Non era vero.** Il profitto scala **12,8×** (IS) e
**11,1×** (OOS) per un deposito **10×**: i lotti si sono scalati quasi
proporzionalmente, quindi a 10.000 il pavimento **non stava mordendo** su questo
simbolo con questo stop.

> ### 🎯 E questa risposta vale MOLTO oltre questo motore.
> La domanda aperta di stasera era: *"il pavimento del lotto sta falsando tutte
> le nostre misure a 10k?"* **Su U30USD M30, con stop 1,5×ATR: NO.**
> È una misura riusabile, ottenuta gratis da un round che serviva ad altro.
> ⚠️ **Non si estende** a D30EUR H4 (stop molto più larghi, il caso
> `SuperWave DAX H4`): lì la domanda resta aperta.

## 💀 IL MODO IN CUI MUORE, che è istruttivo
Sull'OOS il motore fa **+11.310,73 su 100k = +11,31%**: **supererebbe il target
del +10%**. Ma con **DD 11,76%** avrebbe **sfondato il muro totale del −10%
prima di arrivarci**.

> ### Guadagna, e muore per strada. È esattamente il profilo che una challenge
> non perdona — e che un backtest guardato solo dal profitto ti nasconde.

E il muro **giornaliero** non c'entra: **−2,80%** nel peggior giorno, contro un
limite del −5%. **Non è una giornata catastrofica: è un'erosione lunga.**

## ⚖️ E il merito confermava già tutto
PF **0,975 in IS** (in perdita) e **1,053 in OOS** (in guadagno), con n=392 e 618
— **sopra il pavimento dei 150, quindi giudicabile**. Due finestre opposte, ed
entrambi i PF a ridosso di 1. **Non era un edge nemmeno prima di guardare il DD.**

---

## 🏁 VERDETTO: **BOCCIATO PER RISCHIO** (e senza edge)
- ✅ **frequenza**: eccellente, 1.010 operazioni, campione su un simbolo solo;
- 🔴 **rischio**: DD **19,35% / 11,76%** contro un muro del 10%, a **due taglie
  di conto diverse**;
- 🔴 **merito**: PF a ridosso di 1 e **incoerente fra le finestre**.

📌 **Porta di rientro** (regola 18/08): rientra solo se un **meccanismo di
gestione** nuovo abbatte il DD — non un parametro diverso dello stesso motore
(regola della seconda caccia, 19/08). Il candidato naturale sarebbe un **tetto
di perdita giornaliera/settimanale interno**, ma è **codice nuovo**, non una
soglia da ritoccare.

💰 **Costo totale del verdetto: due round, ~15 minuti.** Restano in coda
`ABTG_ImpulsoApertura` (in standby) e i due candidati M30 non ancora portati.
