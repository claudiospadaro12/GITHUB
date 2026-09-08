# 🌳 "QUALE ALBERO VIENE COMPILATO?" — la domanda, e la risposta

Claudio: _"Cioè? Non ho capito la domanda"_. Colpa mia, era scritta male.

---

## ❓ LA DOMANDA, in italiano

Nel repo **lo stesso EA esiste due volte**, in due cartelle:

| dove | righe | versione | ha il Guardian? |
|---|---:|---|---|
| `mql5/Experts/ABTG_PostNews.mq5` | **666** | **1.10** | ✅ sì |
| `mql5/Experts/standalone/ABTG_PostNews.mq5` | **307** | **1.00** | ❌ no |

**Non sono due copie: sono due programmi diversi.** Quello in `standalone/`
non ha il Guardian, non legge il calendario da `Common\Files` e non fa
l'autotest all'avvio.

MT5 compila quello che sta in `<cartella dati>\MQL5\Experts`. 👉 **Se non
sappiamo quale dei due è stato copiato lì, non sappiamo quale codice sta
girando** — e ogni riga che leggiamo nel repo per spiegare un comportamento
potrebbe essere **la riga sbagliata**.

---

## ✅ LA RISPOSTA, per il PostNews: **l'albero PRINCIPALE**. Quattro prove, tutte dalla stessa schermata

Dalla finestra F7 che Claudio ha mandato l'08/09 alle 05:24:

| indizio nella schermata | cosa dimostra |
|---|---|
| titolo: `ABTG_PostNews **1.10**` | la versione **1.10** esiste **solo** nell'albero principale (lo standalone dichiara 1.00) |
| prima riga: *"Guardian: rispetta pausa giornaliera (B1) e cap rischio aperto"* | `InpUsaGuardian` **non esiste** nello standalone |
| `InpNewsCommon = true` | quel parametro **non esiste** nello standalone |
| ultima riga: *"in avvio verifica l'aritmetica sui casi della SPEC"* | l'AUTOTEST **non esiste** nello standalone |

> ### 🎯 Non serviva chiedere niente: la risposta era già nello screenshot.
> **Sul piccolo gira l'albero buono** — quello col Guardian.

---

## ⚠️ MA VALE PER **UN** EA, NON PER TUTTI

E la versione da sola non basta a deciderlo ovunque:

- su **8 EA** i due alberi dichiarano versioni diverse → basta leggere il
  titolo della finestra (`DAX_Apertura_EU` 1.01/1.00 · `FiboH4_Multi`
  1.20/1.00 · `GoldenCross` 2.00/1.00 · `MaxMinNotte` 1.11/1.00 ·
  `Nasdaq_Apertura_US` 1.02/1.00 · `ORB` 1.01/1.00 · `PTE` 1.01/1.00 ·
  `PostNews` 1.10/1.00);
- su **14 EA** dicono **entrambi 1.00** → lì la versione non discrimina, e
  l'indizio buono è il **Guardian**, che lo standalone non ha per costruzione.

## 🤖 Perciò la risposta non la chiedo: **la misuro stanotte**

Aggiunta alla coda del runner: **`CODA_06`**. Apre `MQL5\Experts` di **ogni**
terminale e per ogni sorgente stampa **versione + righe + Guardian sì/no**,
più la **data dell'`.ex5`** compilato accanto.

Trova anche due cose che nessuno ha mai guardato:
- 🔴 **`.ex5` senza il `.mq5` accanto**: EA che girano il cui sorgente **non è
  su quella macchina**;
- 🟠 **`.ex5` più vecchio del `.mq5`**: il sorgente è cambiato e **nessuno ha
  ricompilato** — cioè si legge un codice diverso da quello che gira.

**Cancelli G1 e G2 passati** in collaudo offline, con controprova: 24 divieti
estratti, un caso cattivo finto viene respinto.

---

## 🔗 PERCHÉ NON È UNA CURIOSITÀ
Il bug del lotto trovato oggi (`lotPend` calcolato prima del pavimento) sta in
**15 sorgenti**, di cui **2 in `standalone/`**. Decidere se correggerlo — e
soprattutto **dove** — richiede di sapere quale albero finisce sui terminali.
Correggere l'albero sbagliato sarebbe **lavoro che sembra fatto e non lo è**.
