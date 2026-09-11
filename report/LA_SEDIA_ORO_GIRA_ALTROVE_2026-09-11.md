# 🔴 LA SEDIA ORO `770402` GIRA SU UNA FINESTRA CHE NON È MAI STATA MISURATA

**Verificato da me alla fonte**, non dal riassunto dell'agente.
Nato dallo screenshot TradingView di Claudio di stasera.

---

## 🎯 IL FATTO, in due righe `[MISURATO]`

| | box, ora **server** | cutoff |
|---|---|---|
| 🤖 **preset VIVO** `sedie_piccolo/sedia_MAXMIN_ORO_770402.set` | **23:00 → 04:59** | **08:30** |
| 📊 **il CONTRATTO** — `ABTG_MaxMinNotte_XAUUSD_OOS_r17.csv`, magic **770402** | 🔴 **22:00 → 06:59** | 🔴 **09:30** |

**Il contratto, ricontato al centesimo dal CSV:**
`Profit **1.023,31** · PF **1,90814** · DD **5,3217%** · n **82**`

> ## 🔴 **Due ore di box in più e un'ora di cutoff in più. Non è una sfumatura: sono DUE STRATEGIE.**
> È la **stessa classe** del conflitto di DD della `770101` di stamattina: **i
> numeri promessi descrivono una configurazione diversa da quella che gira.**

## 📏 E quanto morde, **misurato senza lanciare niente**
Da `ABTG_Notte_Study_XAUUSD.csv`, **371 notti**, colonne `ora_massimo`/`ora_minimo`:
- su **212 notti su 371 = 57,1%** l'estremo cade nelle **ore 05 o 06 server**
  👉 su quelle notti **`end=4` ed `end=6` danno livelli DIVERSI**;
- il confondente `start=22 vs 23` pesa solo il **7,3%** — **un ottavo**.

📌 E c'è un **terzo** gruppo di numeri per la stessa sedia: il censimento
(r.302) cita **DD 19,72% @1%** da **R100/R103**, che girano su finestre ancora
diverse e **senza split**. 🔴 **Tre misure, tre finestre, nessuna che dichiari
la propria.**

---

# 🧪 E IL CONTRO-ESEMPIO HA SMONTATO L'IPOTESI PIÙ BELLA

L'idea era: *"le due ore di sessione europea contengono informazione"*.
L'agente l'ha messa contro la **legge dell'arcoseno** (gli estremi di un
cammino casuale si addensano ai bordi):

| | |
|---|---:|
| **MISURATO** — estremo in 05/06 su 239 notti | **62,8%** |
| **CONTRO-ESEMPIO** — cammino casuale, 200.000 simulazioni | **70,5%** |

> ## 🔴 **Il dato vero sta SOTTO quello che predice "non c'è niente lì".**
> L'archivio **non sostiene** che quelle due ore contengano informazione.
> Sopravvive **solo il fatto meccanico del 57%**: i livelli sono diversi.

🎯 **Questo è il metodo che funziona**: l'agente ha costruito l'alternativa e
**ha lasciato che gli smontasse la tesi**, invece di cercarne la conferma.

---

## 🛑 E IL CONFRONTO CHE VOLEVO **NON ESISTE** — ed è la cosa giusta da dire

Su **526 righe** di CSV, le coppie che differiscono **SOLO** per
`InpBoxEndHour` sono **ZERO**. Provato a tre livelli di tolleranza.

**Perché**: `end=6` esiste **solo sull'oro**; `end=4` su tutto il resto. Il
valore è **confuso** con simbolo + ora d'inizio + cutoff.
👉 *"`end=6` è meglio?"* → **NON MISURATO.** *"È dentro il rumore?"* →
**non lo so, e chi dicesse di saperlo starebbe inventando.**

📌 **E `InpBoxEndHour` non è mai stato un ASSE in tutto il repo**: in ogni file
prova è pinnato con flag `N`. **Zero occorrenze con `Y`.** È una **casella
libera, non una casella provata**.

---

## ✍️ COSA SERVE DA CLAUDIO — una decisione, non un comando

🔴 **La sedia oro `770402` gira sul conto piccolo con una geometria diversa da
quella che ha il contratto.** Le opzioni, col costo dichiarato:

| | cosa comporta |
|---|---|
| **A** — riallineare il preset al contratto (`22→6:59`, cutoff `9:30`) | la sedia torna a essere quella misurata, **ma cambia comportamento su ~57% delle notti** |
| **B** — rimisurare il contratto sulla geometria viva (`23→4:59`) | costo: un round, e **finché non torna il contratto resta `[NON VALIDO]`** |
| **C** — lasciare tutto e **dichiarare il contratto NON VALIDO** | zero costo, ma la corsia RISCHIO su quella sedia **non ha una soglia** |

⚖️ **Non tocco niente**: è un parametro di una sedia viva, e quelli sono tuoi.
📌 **La mia raccomandazione è la B**, perché A cambierebbe una sedia in campo
sulla base di un contratto che **non sappiamo se descrive la geometria
migliore** — sarebbe muoversi senza misura.

## 💰 E cosa costerebbe fare la cosa fatta bene
Asse vero `InpBoxEndHour = 2/3/4/5/6` (il vivo `4` **al centro**).
⚠️ **Tetto tecnico**: `end` deve stare prima di `InpPlaceHour` → **sull'oro il
massimo è 6**, `end=7` **non è lanciabile**.
Costo: **20 passate a round** → **~50 min - 2h30** *(stima dichiarata
dall'autore dello script, non cronometrata)*.
🔴 E il merito resterebbe **SOSPESO**: ~20 operazioni per cella, **sotto il
pavimento dei 150**.
