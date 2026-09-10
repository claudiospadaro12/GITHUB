# 🎯 POSTNEWS ECB — L'ESITO. **Il lotto era 2,3 volte il contratto, e adesso e' MISURATO**

**10/09/2026.** Prima operazione in assoluto della sedia `771201` (ECB EURJPY),
conto **DEMO piccolo 50503392**. Fonte: `ReportHistory50503392.xlsx` esportato
alle 19:00.

---

## 📋 IL TRADE, riga per riga (orari in ORA SERVER)

| | |
|---|---|
| **14:00:00** | piazzati BUY STOP 179,230 e SELL STOP 178,981, **0,58 lotti** ciascuno |
| **14:03:40** | 🔻 **SELL STOP RIEMPITO a 178,981** — e nello **stesso secondo** il BUY STOP e' **`canceled`** |
| **17:06:39** | 🛑 stop a **179,231**, esattamente il livello piazzato |
| durata | **3h 03m** — stoppata **9 minuti prima** della scadenza (17:15 server) |
| **profitto** | 🔴 **−80,90 EUR** · commissioni **−2,32** · **totale −83,22 EUR** |
| saldo | 5.426,40 → **5.344,34** |

---

# 🔴 IL VERDETTO SUL LOTTO: **confermato, al centesimo**

Stamattina, **PRIMA** che l'operazione chiudesse, avevo scritto i due numeri
possibili:
> *"~35 EUR se il contratto e' rispettato (0,65%), ~81 EUR se ho ragione io (1,49%)"*

## 🎯 **Uscito: −80,90 EUR = 1,4905% del conto.**

| | promesso nel contratto | **misurato** |
|---|---|---|
| rischio per evento | **0,65%** | 🔴 **1,49%** (1,53% col pedaggio) |
| in euro | ~35 EUR | 🔴 **80,90 EUR** (83,22 col pedaggio) |
| | | **2,3 volte tanto** |

### E l'aritmetica torna esatta, quindi non e' un'ipotesi
Dal trade vero: perdita per lotto su 25 pip = 80,90 / 0,58 = **139,5 EUR**, quindi
su 50 pip (il riferimento usato per la size) = **279,0 EUR/lotto**.
```
lot = risk / lossPerLot
0,58 = risk / 279,0   ->   risk = 161,8 EUR = 2,98% di 5.427,56
```
> 🔴 **La sedia ha dimensionato con il 3,0%, non con l'1,3% che il pannello F7
> mostrava.** Con l'1,3% il lotto sarebbe stato **0,25**.

---

# 🚨 E LA CAUSA E' UN DIFETTO DI FAMIGLIA, NON UN CASO

`mql5/Experts/ABTG_PostNews.mq5`, riga 113:
```mql5
input double InpRiskPercent = 3.0;  // rischio % (documento: 3%)
```

## 🔴 **Il DEFAULT COMPILATO e' 3,0 — cioe' 4,6 volte il metro di casa (0,65%).**

I file `.set` nel repo sono corretti (**1.30**). Il pannello mostrava **1.3** alle
12:59 server. Ma **il `.set` giusto non protegge**: basta un **`Resetta`** nella
finestra F7, una **ricompilazione**, o un profilo ricaricato, e il valore torna
**silenziosamente al default del sorgente**.
👉 Ed e' esattamente la lezione che il collega ha pagato **8.597 EUR** su conto
reale: *"la configurazione va verificata SUL TERMINALE, non sui file `.set`"*.

## 📊 IL CENSIMENTO DEI DEFAULT — fatto adesso su tutti gli EA
| default compilato | quanti | chi |
|---|---:|---|
| 🔴 **3.0** | 1 | **`ABTG_PostNews`** |
| 🟠 **2.0** | 4 | `SupertrendReversal_Ottimizzato`, `SupertrendReversal_Multi_Ottimizzato`, `PointBreak`, **`MaxMinNotte`** |
| 🟡 1.0 | ~25 | tutti gli altri |

🔴 **Nessun EA ha come default il metro di casa (0,65%).** Il migliore parte da
**1,0%**, cioe' gia' **1,5 volte**; il peggiore da **4,6 volte**.
⚠️ E `MaxMinNotte` (default **2.0**) e' **viva in forward** sull'oro.

---

# ✅ MA CI SONO TRE BUONE NOTIZIE, e sono misurate

## 1. 🔁 **L'OCO FUNZIONA** — e non lo sapevamo con un fatto in mano
```
14:03:40  SELL STOP  ->  filled
14:03:40  BUY  STOP  ->  canceled
```
**Stesso secondo.** La gamba opposta e' stata disarmata appena la prima si e'
riempita. 🎯 E' la domanda che il documento PS5 del collega mette al centro
(*"la cancellazione della gamba opposta e' una protezione, non una preferenza"*,
con **57% di inversione sul DAX**): su `ABTG_PostNews` **la protezione c'e' e ha
funzionato**.
🔴 **Ma NON dice niente su `ABTG_ORB`**, che e' un altro EA e ha il difetto
`PositionSelect` su conto hedging misurato il 03/09. Quello resta aperto.

## 2. 🎯 **Riempimento e uscita al prezzo ESATTO**
Ingresso a **178,981** = il livello piazzato. Uscita a **179,231** = lo stop
piazzato. **Slippage 0,000 su tutti e due.**
⚠️ **E qui la nota che salva il numero: e' un conto DEMO.** Sui server demo i
riempimenti al prezzo esatto sono la norma, anche dove il mercato vero
slitterebbe. 🔴 **Questo dato NON e' una misura di slippage reale** e non va
usato per tarare niente. Quello vero resta l'unico che abbiamo dal conto reale:
**+0,70 punti indice in ingresso su D30EUR, 0,00 sull'uscita in stop** (n=1).

## 3. 🔬 **La previsione scritta prima ha centrato il numero**
Predetto **~81 EUR / 1,49%**, uscito **80,90 EUR / 1,4905%**. Non e' bravura: e'
il metodo *"al centesimo"* del 09/09 (predetto −4,82 su CHFJPY, riportato −4,84).
👉 Vuol dire che **il modello del lotto lo abbiamo capito**, e quindi si puo'
correggere con una misura, non a tentativi.

---

# 🛑 COSA SCATTA ADESSO

## La clausola di RISCHIO del contratto, scritta stamattina prima di armare
> *"RISCHIO: se il DD forward supera lo 0,65% per evento promesso qui →
> **revisione IMMEDIATA**, a qualunque n."*

**Scattata.** 1,49% contro 0,65%. Il MERITO resta sospeso (n=1, valvola R59):
una perdita su un'operazione **non dice niente** sul motore. Il RISCHIO si'.

## 🎯 LE TRE COSE DA FARE, in ordine
| # | cosa | perche' | di chi e' |
|---|---|---|---|
| **1** | 🔧 **Portare il default compilato di `ABTG_PostNews` da 3.0 al metro di casa** | il `.set` giusto non protegge da un `Resetta`. Finche' il default e' 3.0, **ogni ricarica riarma il 4,6x in silenzio** | 🔴 **firma di Claudio**: e' la TAGLIA, e serve una ricompilazione |
| **2** | 🔍 **Verificare F7 ADESSO su EURJPY**: legge 1.3 o 3.0? | dice **quando** e' tornato a 3.0 — al `Resetta` o prima. Chiude la ricostruzione | 30 secondi |
| **3** | 📋 **Estendere il censimento ai default di TUTTI gli EA vivi** | 4 EA hanno default 2.0 e uno di questi (`MaxMinNotte`) e' **vivo sull'oro** | una corsa |

## 🏛️ E perche' conta per le PROP, che e' l'obiettivo
Una sedia che **promette 0,65% e rischia 1,49%** su una prop da 100k con muro
giornaliero al 5% non brucia subito: brucia **quando ne arrivano tre insieme**.
Il cap C1 (3,25% di rischio aperto) e' calcolato su **cinque** SL da 0,65%: con
sedie che rischiano il doppio, **cinque SL vivi fanno il 7,5%** e il muro
giornaliero se ne va.
🔴 **Questo e' il difetto piu' pericoloso trovato oggi**, e vale piu' di tutto il
resto della giornata — perche' non e' un errore di misura: e' un errore che
**paga soldi veri il giorno in cui il conto non e' un demo.**
