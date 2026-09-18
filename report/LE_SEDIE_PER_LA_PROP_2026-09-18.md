# 🎯 LE SEDIE PER LA PROP — selezione per **MAGIC**, non per commento

**18/09/2026** · richiesta di Claudio: *«SELEZIONIAMO SOLO LE SEDIE PER LA PROP»*

---

## 🔴 PRIMA: DUE CORREZIONI ALLA ROSA DI UN'ORA FA

`report/ROSA_DAL_CAMPO_2026-09-18.md` ragionava per **COMMENTO**. Ho costruito il ponte
che mancava — `data/statements/trades_auto.csv` ha **magic E strategy insieme** — e due
letture cadono.

### ① `DAX Apertura EU RETEST` e `DAX Apertura EU` **sono LO STESSO MAGIC `770101`**

Non sono due varianti in gara: è **la stessa sedia prima e dopo un cambio di
configurazione**.

| commento | n | dal | al |
|---|---:|---|---|
| `DAX Apertura EU` (BREAKOUT) | 24 | 2026.07.20 | 2026.08.14 |
| `DAX Apertura EU RETEST` | 15 | **2026.08.07** | 2026.09.17 |

👉 Il cambio è del **7 agosto**, ed è **documentato nel sorgente**:
`ABTG_DAX_Apertura_EU.mq5` **r.261** — *«06/08: era BREAKOUT. Unico motore in utile fuori
campione con campione vero (+392,96 · PF 1,065 · 244 trade)»*.

> ## 🟢 **E la conclusione ne esce PIÙ FORTE, non più debole: non è «una variante batte l'altra», è «abbiamo cambiato una manopola il 7 agosto e la stessa sedia è passata da −168 a +149».** E il repo aveva già la misura fuori campione che lo prevedeva, su 244 trade.

### ② La «famiglia `EMA200` a −127,37» sono **TRE sedie su DUE simboli**

| magic | simbolo | n | netto |
|---|---|---:|---:|
| `771531` | U30USD | 21 | **−19,39** (10 vinte / 10 perse) |
| `971501` | XAUUSD (Ottimizzato) | 9 | −54,37 |
| `771501` | XAUUSD | 2 | −53,61 |

⚠️ Il **−27,37** aggregato resta vero **per FAMIGLIA**, ed è l'unità del criterio del
18/08. 👉 **Ma «spegnere la sedia colpevole» si fa per MAGIC**, e allora la colpevole
non è `771531` (che perde 19 euro in 21 operazioni, metà e metà): sono **le due
sull'ORO**, che insieme fanno **−107,98 su 11**.
*(Decisione già presa da Claudio: non si spegne niente, restano sul demo —
`report/DECISIONE_EMA200_RESTA_SUL_DEMO_2026-09-18.md`.)*

---

## 🥇 LA SELEZIONE — le sedie che propongo per la prop

**220 posizioni su 231 attribuite a un magic.** Criterio: netto positivo **+** record
**+** un solo simbolo **+** nessuna ambiguità di attribuzione.

| | magic | EA | simb | n | netto | **record** | perché |
|---|---|---|---|---:|---:|---|---|
| 🥇 | **`770201`** | `Nasdaq_Apertura_US` | NASUSD | 7 | **+98,49** | **7 vinte su 7** | 🟢 **zero perse**, un simbolo solo, attribuzione pulita |
| 🥈 | **`770402`** | `MaxMinNotte` ORO | XAUUSD | 11 | **+43,29** | 6/5 | 🟢 **il campione più grande fra le positive pulite** |
| 🥉 | **`770101`** | `DAX_Apertura_EU` **in RETEST** | D30EUR | 21 | −19,08 | **18 vinte su 21** | 🟠 negativa **in totale**, ma è il **prima+dopo**: la sola parte RETEST fa **+149,16 su 15, 14/1** |

### 🟠 E una che NON metto in classifica, e dico perché
**`770511`** risulta prima per netto (**+244,94**), 🔴 **ma la sua attribuzione è sporca**:
il ponte gli assegna commenti di **due motori diversi** (`SUPERWAVE DOW H1` e `STREV L 1/3`)
e **due simboli** (U30USD e NASUSD), e il conto vinte/perse non torna col totale (6+2 contro
n=12). 👉 **Finché non è chiarito, quel numero non si usa** — e sarebbe stato il primo
posto.

---

## ⚠️ COSA MANCA A QUESTE TRE PER ESSERE SCHIERABILI — e non è poco

🔴 **Nessuna delle tre è schierabile oggi.** Il campo dice *chi guadagna*; non dice
niente sui cancelli, che restano congelati:

| requisito | `770201` | `770402` | `770101` |
|---|---|---|---|
| **R5 costo** `stop >= 40 x spread` | ⚠️ **in due unità**, non applicabile finché non è firmato | ⚠️ idem | 🟠 **42,3× mediana ma 33,0× sulla geometria VIVA** |
| **DD dichiarato** | 🔴 **[NON MISURATO]** sul campo (il report MT5 non ha il magic, la curva per sedia non si ricostruisce) | 🔴 idem | 🟢 4,35% @0,65% misurato |
| **muro giornaliero** | 🔴 il Guardian, coi numeri di oggi, su un muro al 4% **arriva DOPO la prop** | 🔴 idem | 🔴 idem |
| **campione** | 7 | 11 | 21 (15 in RETEST) | 

> ## 🔴 **Il collo di bottiglia non è più «quali EA». Adesso è: (1) l'unità del cancello di costo, (2) la soglia del Guardian, (3) quale prop. Tutte e tre sono firme, non misure.**

---

## 🕳️ BUCHI DICHIARATI

- **11 posizioni su 231 non mappate a un magic** (6 senza commento + 5 `MAXMIN DAX`, che
  nel forward firma `MAXMIN DAX SHORT` e quindi non aggancia).
- **Il ponte commento→magic prende il PRIMO magic visto per ogni commento**: dove due
  sedie hanno usato lo stesso testo, l'attribuzione è **ambigua** — è il caso di `770511`.
- **`trades_auto.csv` copre 30/03→17/09**, il report copre 29/07→18/09: i due insiemi
  **non coincidono**, e il ponte è costruito sul primo per leggere il secondo.
- **Nessun DD per sedia**, quindi il requisito R2 resta aperto su due delle tre.
- **Un solo regime**, sette settimane, conto demo con taglie non comparabili al 100k.

---

*Selezione fatta il 18/09/2026. Nessuna sedia promossa in campo, nessun terminale toccato,
nessun parametro di rischio proposto: qui si sceglie chi CANDIDARE, non chi schierare.*
