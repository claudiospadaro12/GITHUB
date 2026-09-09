# 🐻 PERCHE' NESSUN EA HA SHORTATO IL DAX DEL 09/09

**Domanda di Claudio** (screenshot GER40 H1: 25.656,8 · **−279,0 · −1,08%**).
Risposta misurata su `data/statements/trades_auto.csv` (122 operazioni D30EUR
con magic, escluse le 40 senza commento = manuali, regola del 07/09).

## 1️⃣ Non e' vero che non abbiamo short sul DAX: ne abbiamo fatti **34**
| | |
|---|---|
| LONG | **88 (72%)** |
| SHORT | **34 (28%)** |
Sei sedie hanno operato short: `770101` · `770103` · `770121` · `770311` ·
`770411 MAXMIN DAX SHORT` · `770501` · `771501`.

## 2️⃣ 🔴 MA L'ULTIMO SHORT SUL DAX E' DEL **31/08** — nove giorni fa
| sedia | ultimo LONG | ultimo SHORT |
|---|---|---|
| **770101 DAX Apertura EU** (la piu' attiva) | **08/09** | 🔴 **13/08** |
| **770411 MAXMIN DAX SHORT** | mai | 🔴 **31/08** |
| 770103 DAX Live5m | 07/08 | 06/08 |
| 770121 DAX Live5m v2 | 07/08 | 06/08 |
| 770311 Apertura Marco | 06/08 | 05/08 |

👉 **La sedia che lavora tutti i giorni sul DAX ha smesso di andare short il
13 agosto.** L'unica dedicata allo short (`MAXMIN DAX SHORT`) non opera dal
31/08 — **e quel giorno aveva chiuso +33,13 €.**

## 3️⃣ E nella configurazione misurata stamattina in R120: `InpAllowShort = 0`
Letto nel CSV del round: `InpAllowLong = 1`, **`InpAllowShort = 0`**.
**Lo studio della gestione di stamattina — quello che ha trovato PF 1,379 —
ha misurato SOLO IL LATO LONG.** Il lato short di quel motore, con quelle
strutture d'uscita, **non e' mai stato misurato.**

## 4️⃣ 🎯 LA RAGIONE STRUTTURALE, ed e' la risposta vera
**Tutti i nostri motori DAX sono motori di APERTURA**: lavorano sul range
**08:00-08:35 SERVER** (09:00-09:35 italiane) e poi si spengono. La discesa
dello screenshot e' di **meta' mattina**.
👉 **Non e' che non l'hanno vista: non stavano guardando.**
Non abbiamo **un solo motore DAX che operi dopo le 09:35 italiane.**

## 5️⃣ 🚨 E LA COSA SCOMODA, che questo episodio rende visibile
**72% long su 21 mesi di indici che contengono UN SOLO REGIME: un toro.**
E' gia' agli atti (`PERCHE_MUOIONO_2026-09-08.md` §3.3-bis: _"lato SOLO LONG:
e' un allarme, non una virtu'"_ · `R52_CENSIMENTO_LATI.md`: i lati long sono
**SCELTI, non strutturali**).
🔴 **In un orso, o in un crollo, tre quarti della flotta e' dalla parte
sbagliata — e non l'abbiamo mai misurato, perche' nei dati BCM l'orso non c'e'.**

---

## ⚠️ IL LIMITE DI QUESTA RISPOSTA, dichiarato
`trades_auto.csv` e' stato pubblicato **ieri sera**: l'ultima riga e'
**08/09 12:50**. **Cosa hanno fatto le sedie OGGI non e' in questi dati.**
Quindi: posso dire con certezza che **nella configurazione testata il motore
non puo' andare short** e che **nessun motore DAX opera dopo le 09:35
italiane**; **non** posso dire cosa hanno fatto stamattina. Serve la pagella
di stasera.

---

## ✅ LE DUE MOSSE, e costano poco
1. 🥇 **Rifare R120 sul lato SHORT** (`InpAllowShort=1`, `InpAllowLong=0`):
   48 celle, stesso costo di stamattina. **E' letteralmente la regola che
   Claudio ha firmato il 25/08**: _"Ogni analisi misura SEMPRE tutti e due i
   lati — anche se un lato e' gia' vivo in forward, si RITESTA."_
   Stamattina l'abbiamo violata senza accorgercene.
2. 🥈 **Capire perche' `MAXMIN DAX SHORT` (770411) e' ferma dal 31/08**:
   e' l'unica sedia short dedicata sul DAX, e l'ultimo trade era in utile.
   Sedia muta o motore raro? Si legge nella pagella, non si indovina.
