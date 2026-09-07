# 🎯 "CE LA FAREMO?" — la risposta con i numeri, quelli buoni e quelli scomodi

Claudio, 07/09/2026 sera, testuale:
> _"La cosa che mi attanaglia di più è se davvero ce la faremo, e se davvero
> esiste gente che ha creato EA per le prop, e se un giorno arriveremo ad avere
> i nostri EA per le prop."_

---

## 1. ❓ ESISTE GENTE CHE CE LA FA CON GLI EA? **Sì. Ed è misurato, non sentito dire.**

Non è un'opinione perché **non veniamo dalle promesse dei venditori**. Il
portafoglio `Profalgo` (`signals/2204998`) che abbiamo letto il 06/09 ha le
**statistiche calcolate da MQL5**, non dichiarate dall'autore:

| | |
|---|---|
| EA in campo | 3-5 |
| simboli | **26** |
| operazioni settimanali | 37,8 - 61 |
| operazioni/giorno **per simbolo** | **0,29 - 0,47** |

👉 Gente che fa girare EA su conti veri, con numeri verificabili da terzi,
**esiste**. Non è un mito.

## 2. 🔴 MA LO STESSO DATO DICE ANCHE LA COSA SCOMODA

Gli **altri due** portafogli "prop firm ready" letti nella stessa caccia hanno
drawdown **MISURATI del 32,59% e del 45,64%**.

👉 Una challenge si perde a **10%**. Quindi molti di quelli che "ce la fanno"
lo fanno con profili di rischio che **una challenge la bruciano**. Il mestiere
non è "trovare un EA che guadagna": è **trovarne uno che guadagna dentro un
muro del 10%**. È molto più stretto, ed è il motivo per cui va lento.

## 3. 💶 E NOI DOVE SIAMO? **Non a zero. Con una data.**

Il dato più concreto che abbiamo, dal dry-run sul conto da 100k:

| | |
|---|---|
| saldo realizzato | **102.854,99 = +2,85%** |
| mancano al target di fase 1 | **7.145,01 € = 7,15 punti** |
| giornate operative | **16** (minimo richiesto: 4) |
| peggior giornata realizzata | **−0,648%** contro un muro del 5% |
| stima al ritmo grezzo | **≈1,8 mesi** |
| stima al ritmo normalizzato | **≈3,1 mesi** |

> ### 👉 Non è "impossibile". È **un numero con una data sopra.**

⚠️ **E i due asterischi, perché senza sarebbe una bugia:**
1. il margine sul muro giornaliero è calcolato **sul solo realizzato** — il
   flottante non è nel CSV, quindi **la peggior giornata vera è NON MISURATA**;
2. il demo **non simula lo slippage** (confermato da BCM): quel +2,85% è
   **ottimista per costruzione**, e non sappiamo ancora di quanto.

## 4. 🛡️ COSA HA PRODOTTO DAVVERO UN MESE — non "niente"

Sembra "39 round e zero EA". Ma quello che è stato costruito è **un filtro che
funziona**, e oggi si è visto tre volte in un giorno solo:

| | cosa ha fermato | cosa sarebbe successo senza |
|---|---|---|
| 🔴 | `LONDONFX`, il vincitore della caccia frequenza, con **n OOS 662** | in campo un motore con **DD 37,14%** = challenge bruciata |
| 🔴 | `GapCash Nasdaq`: il fenomeno c'è, ma **il segno si rovescia** sui tick BCM | un EA nuovo e settimane di forward su un'illusione |
| 🐤 | il **canarino** di R119: una chiave `.ini` inventata | un referto verde che diceva _"le sedie reggono 500 ms"_ — **una bugia con i numeri sotto** |

👉 **Quel filtro è l'asset.** Un EA lo si riscrive in un giorno; un metodo che
riconosce le illusioni costa un mese e vale la challenge.

## 5. ⚖️ LA RISPOSTA ONESTA ALLA DOMANDA

- **È possibile?** ✅ **Sì**, ed è dimostrato da conti veri con statistiche di terzi.
- **È certo che ce la faremo?** ❌ **No.** Nessuno può prometterlo, e chi lo
  promette sta vendendo qualcosa.
- **Siamo messi male?** ❌ **No.** Un conto a **+2,85%** con una strada
  misurata, 41 sedie censite, 4 candidati recuperabili, 4 trasformazioni
  proposte e un filtro che funziona.
- **Qual è il rischio vero?** Non che sia impossibile. È che i nostri numeri
  di forward siano **ottimisti** e non sappiamo di quanto. **Ed è misurabile
  senza fare niente**: basta che le due sedie del conto reale eseguano.

## 6. 🚀 E LA VELOCITÀ — dove ho sbagliato io

Claudio ha ragione su una cosa, e non è una concessione: **oggi il collo di
bottiglia sono stato io**, non lui. Il modo di lavorare è stato:
> una stringa → una schermata → la mia analisi → la stringa dopo

Quattro passaggi per ogni mossa, con lui fermo ad aspettare in mezzo a ognuno.

**Cambia da adesso: si lavora a CODA.** Preparo **N stringhe in ordine**,
ognuna che si autoverifica e dice da sola se è andata bene, e lui le incolla
una dopo l'altra **senza aspettarmi**. Io leggo i referti dopo, tutti insieme.

E sull'autonomia: **su tutto ciò che non tocca soldi veri non chiedo più
niente** — è il mandato del 07/09. Stasera ho chiesto un permesso per una
decisione su un conto **demo**: non serviva, ed è stato tempo perso.

Resta **una sola** cosa che continuo a passare da lui: il **conto reale
10105439** e i **parametri di rischio**. Non per prudenza: perché una firma è
una decisione su un numero misurato, e su quello i soldi sono suoi.

---

_Scritto la sera in cui Claudio ha detto "mi sto demoralizzando". I numeri di
questa pagina sono tutti tracciabili: `report/PIANO_PROP.md`,
`report/CENSIMENTO_CONTRATTI.md`, `caccia_strategie/CONFIG_PROP_FREQUENZA_2026-09-06.md`,
`risultati_archivio/r116_londonfx/`, `report/PERCHE_NON_ARRIVIAMO_2026-09-07.md`._
