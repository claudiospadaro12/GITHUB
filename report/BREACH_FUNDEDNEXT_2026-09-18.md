# 🚨 IL BREACH DEL 18/09 — **FundedNext Stellar Lite 100k, conto `12061434`**

**18/09/2026, ore 14:01 italiane.** Claudio riceve la mail di breach. Questo file è il
verbale del fatto e dei conti, scritto lo stesso giorno.
🔴 **Nessuna conclusione di questo file è una contestazione: è materiale per deciderla.**

---

## 1. 📄 COSA DICE LA MAIL, alla lettera

> *«Your **Stellar Lite 2-Step Challenge P1 | 100K Account 12061434** has exceeded the
> daily loss limit.»*
> **1. Daily Loss Limit: $4000** · **2. Total Loss on 18 September 2026, 02:59 PM (GMT+3):
> $4209.43** · **3. Equity When Account Breached: $99048.73**

---

## 2. 🧮 L'ARITMETICA — torna, e dice una cosa diversa da come sembra

| voce | valore |
|---|---:|
| equity al blocco | **99.048,73** |
| perdita dichiarata del giorno | **4.209,43** |
| **riferimento di inizio giornata** (ricavato: equity + perdita) | **103.258,16** |
| il conto partiva quindi a | **+3.258,16 = +3,26%** |
| limite dichiarato | **4.000,00 = 4,0%** dell'iniziale |
| **sforamento** | **209,43 — il 5,2% oltre il limite** |
| perdita TOTALE dal via | **951,27 = 0,95%** |
| margine che restava sul muro totale del 10% | **9.048,73** |

> ## 🟢 **Il conto non stava perdendo: era in guadagno del 3,26% a inizio giornata. È morto sulla regola GIORNALIERA, con il muro totale lontano nove punti.**

✅ **Coerenza interna della mail**: 99.048,73 + 4.209,43 = 103.258,16, e
103.258,16 − 100.000 = +3,26%. **I tre numeri che ci hanno mandato stanno insieme.**

---

## 3. 🔴 IL PUNTO CHE DECIDE TUTTO, E NON L'ABBIAMO MAI VERIFICATO

La mail dichiara il limite giornaliero a **$4.000 = 4%**.

| prodotto | limite giornaliero | fonte |
|---|---|---|
| **FundedNext Stellar 2-Step** | **5%** dell'iniziale, reset 00:00 server | `report/REGOLAMENTI_PROP_2026-09-08.md` § *MURO GIORNALIERO*, con link all'help ufficiale |
| 🔴 **Stellar LITE** (il conto vero) | **[MAI VERIFICATO]** | `report/ROSA_OTTOBRE_2026-09-18.md` **r.347** lo elencava, **stamattina**, fra le cose ancora da fare |

> ### 🔴 **A 5% NON ci sarebbe stato breach: 4.209,43 < 5.000,00. Tutto dipende da un numero che non abbiamo mai letto sul sito del prodotto giusto.**

⚠️ **È del tutto plausibile che il Lite abbia davvero il 4%** — è un prodotto più
economico e le regole più strette sono la contropartita normale. **Non stiamo dicendo che
hanno sbagliato: stiamo dicendo che noi non lo sappiamo**, ed è un buco nostro.

---

## 4. 🔎 LE TRE VERIFICHE, in ordine di valore

1. 📜 **La pagina delle regole dello Stellar Lite nell'area di Claudio**: il daily loss
   è **4% o 5%**? Se è 4%, il breach è corretto e non c'è appello. Se è 5%, c'è una mail
   da scrivere.
2. 🕐 **Che posizione era aperta alle 14:59 GMT+3** (= **13:59 italiane**, **12:59 UTC**)?
   Il limite si misura sull'**EQUITY**, quindi il **flottante** di una posizione ancora
   aperta conta quanto una perdita chiusa.
3. 🔴 **Lo sforamento è di 209,43 su 4.000: il 5,2%.** È un margine sottilissimo, e
   l'equity si marca al **bid/ask**: un **allargamento di spread** in quell'istante muove
   l'equity **senza che il prezzo si muova**. 👉 Se il breach è scattato su flottante e
   non su perdite realizzate, **è la circostanza più contestabile che esista** — e lo
   spread lo sappiamo misurare (`ABTG_SpreadLogger`, già in casa).

---

## 5. 🛡️ LA FLOTTA EA NON C'ENTRA — verificato

`grep` repo-wide del numero **`12061434`**: **zero occorrenze** prima di questo file.
👉 **Nessun documento del progetto ha mai nominato quel conto**, e nessun EA della flotta
risulta esservi stato attaccato. Coerente con `ROSA_OTTOBRE` r.341, dove il conto
FundedNext comprato il 15/09 era dato come **il conto MANUALE di Claudio**.

---

## 6. 🧭 COSA CI INSEGNA PER IL 1° OTTOBRE — ed è la parte che vale

> ## 💡 **La prop non misura il drawdown MEDIO. Misura la GIORNATA PEGGIORE. E un conto in guadagno del 3,26% può morire lo stesso, con il muro totale a nove punti di distanza.**

🔥 **È esattamente la misura che era già partita stamattina**, su richiesta del collega
(suo punto 4): la **distribuzione del drawdown per riordino**, con la **peggior giornata**
confrontata col muro. Sembrava un raffinamento di metodo. **Non lo era.**

🔴 **E un secondo difetto, che sapevamo dall'8 settembre e che non avevamo sistemato**:
il reset di FundedNext è alle **00:00 GMT+3 = 22:00 ora server BCM**, mentre il nostro
Guardian ha `InpDailyResetHour = 23`, tarato su **FTMO** (00:00 CET).
➡️ **Un'ora di disallineamento sul contatore giornaliero.** Era scritto in
`REGOLAMENTI_PROP_2026-09-08.md` r.214 con la tabella delle conversioni, e nessuno
l'aveva ancora portato in campo. 👉 **Su un conto FundedNext, un'ora di scarto significa
che il Guardian conta le perdite di una finestra diversa da quella che conta la prop.**

---

## 7. 🕳️ BUCHI DICHIARATI

- **Non abbiamo la cronologia operazioni del conto `12061434`**: non è in repo e non è
  un conto che leggiamo. Tutto il §4 punto 2 e 3 è **da fare**, non fatto.
- **Il regolamento Stellar Lite non è stato letto** in questo giro: non abbiamo accesso
  all'area di Claudio e le pagine dei prop rispondono **403** al nostro proxy
  (registrato in `REGOLAMENTI_PROP_2026-09-08.md` r.43).
- **Non sappiamo se le operazioni fossero manuali o automatiche**, né quali strumenti.
- ⚠️ **Il «riferimento di inizio giornata» di 103.258,16 è RICAVATO** dalla somma dei
  due numeri della mail, non letto da un estratto conto. Se la loro «Total Loss» fosse
  calcolata su una base diversa (per esempio il **saldo** invece dell'**equity**), quel
  numero cambia e va riletto.

---

*Verbale scritto il 18/09/2026. Nessuna contestazione inviata, nessuna decisione presa:
la scelta se e come rispondere al prop è di Claudio.*
