# 🎯 LE SEDIE PER LA PROP — selezione per **MAGIC**, non per commento

**18/09/2026** · richiesta di Claudio: *«SELEZIONIAMO SOLO LE SEDIE PER LA PROP»*

---

> # 🔴 CORREZIONE DEL 18/09 SERA — **LA SEDIA CHE AVEVO MESSO PRIMA È SPENTA DA UN MESE, E BOCCIATA**
>
> Trovato dal cancello sul referto delle taglie, **verificato da me alla fonte**.
>
> `report/CONTRATTI_SEDIE.md` **r.54**, testuale:
> > *«ABTG_Nasdaq_Apertura_US ⛔ **SPENTA dal 18/08 09:41** … Rischio **0,25** … DD promesso:
> > **NESSUNO** — mai promossa. Anzi: tick reali 31/07 **PF 0,82 · DD 17% · SCARTATO**;
> > walk-forward 05/08: **19/20 celle OOS negative**» · etichetta 🔴 **[SENZA CONTRATTO]***
>
> Confermato da `report/CENSIMENTO_CONTRATTI_v2.md` r.363 (*«FIRMA 5»*).
>
> ## 🔴 **Quindi il «7 vinte su 7» del mio 🥇 non è un record: è la coda di una sedia già misurata e già bocciata, che si ferma l'11/08 perché QUALCUNO L'HA SPENTA.**
>
> Dieci operazioni in tre settimane **non ribaltano un walk-forward 19/20 negativo**. Metterla
> prima in una rosa per la prop, citando solo le vittorie e tacendo PF 0,82 / DD 17%, è
> esattamente il *«numero bello su campione sottile»* che la regola di casa del 19/08 vieta —
> e l'ho fatto io. 🔴 **`770201` esce dalla rosa** finché una misura nuova non le ridà una ragione
> (porta di rientro, criterio del 18/08).
>
> ⚠️ **E il suo preset in repo porta `InpRiskPercent=2.0`** contro un contratto di **0,25**:
> otto volte. Da verificare sul terminale **50503392** (`BCM Markets MT5 Terminal`), in sola lettura.
>
> ### 🟢 Le altre tre correzioni della stessa passata
> - **`770402` MaxMin ORO**: il contratto **non è 1,0% — è 0,5%**, ridotto il 23/08 con firma
>   REVISIONE R100 (`CONTRATTI_SEDIE.md` r.95, che aggiunge *«prop: solo ≤ 0,5%»*). Il suo
>   realizzato **0,545% è IN CONTRATTO**: 🟢 nessuna anomalia.
> - **`770511` SuperWave**: il rischio realizzato è **0,332% su UN SOLO segnale**, non 0,13%
>   su quattro — vedi `report/PERCHE_SUPERWAVE_FA_013_2026-09-18.md`.
> - **`770101` DAX**: non è *«un solo simbolo»* (38 D30EUR + **1 NASUSD**), e il 29/07 ha aperto
>   **due posizioni da 1,60 nello stesso secondo** → quel segnale è costato **3,91% del saldo**,
>   non 2%. Il dimensionatore per-POSIZIONE funziona; **per SEGNALE no**.
>
> 📌 **Cosa resta in piedi della rosa**: `770101` in RETEST (+149,16 su 15, 14/1) e `770511`
> (+244,94, 4 segnali su 5) restano le due misure migliori del campo. 🔴 **Ma la rosa ora è
> di TRE sedie, non quattro, e nessuna delle tre ha una taglia firmata per la prop.**

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
| 🥇 | **`770201`** | `Nasdaq_Apertura_US` | NASUSD | **7 segnali** | **+98,49** | **7 vinte su 7** | 🟢 **zero perse**, un simbolo solo, **nessun segnale dominante** |
| 🥈 | **`770511`** | `SuperWave` DOW H1 | U30USD | **5 segnali** (10 gambe) | **+244,94** | **4 vinti su 5** | 🟠 netto piu' alto, **ma il 60% viene da UN segnale** — vedi sotto |
| 🥉 | **`770402`** | `MaxMinNotte` ORO | XAUUSD | 11 | **+43,29** | 6/5 | 🟢 **il campione più grande fra le positive pulite** |
| 4 | **`770101`** | `DAX_Apertura_EU` **in RETEST** | D30EUR | 21 | −19,08 | **18 vinte su 21** | 🟠 negativa **in totale**, ma è il **prima+dopo**: la sola parte RETEST fa **+149,16 su 15, 14/1** |

### ✅ `770511` — **CHIARITO il 18/09: la sedia è PULITA, il difetto era del mio ponte**

Era stata sospesa perché risultava con **due motori e due simboli** e `vinte+perse` non
tornava. 🔴 **Causa trovata: il mio ponte normalizzava il commento con `.upper()`, e due
sedie diverse scrivevano `STRev L 1/3` (770511, U30USD) e `STREV L 1/3` (770925, NASUSD).**
Maiuscolate diventano la stessa stringa → due posizioni di un'altra sedia finivano qui.

✅ **Ponte corretto** (chiave `(commento, SIMBOLO)` invece del solo commento). Il risultato
vero di `770511`:

| | |
|---|---|
| n | **10** |
| netto | **+244,94** |
| record | **6 vinte · 2 perse · 2 a ZERO** (il `vinte+perse<n` era questo: due uscite **a pareggio**, cioè il breakeven che funziona) |
| simbolo | **U30USD**, uno solo |
| commenti | **quattro, tutti `SUPERWAVE DOW H1`**: `L 1/3`, `L 2/3`, `S 1/3`, `S 2/3` |

> ## ⚠️ **PRIMA STESURA: «`770511` è la PRIMA della rosa, +244,94 su 10 posizioni». 🔴 SBAGLIATO, e l'ha visto Claudio.**

### 🔴 SECONDA CORREZIONE, stesso giorno: **le «10 posizioni» sono 5 SEGNALI**

Claudio ha chiesto *«e' il SuperWave DOW H1, L o S, 1/2 o 2/3? VERIFICA»*. Verificato nel
sorgente `ABTG_SuperWave_DOW_H1_Ottimizzato.mq5`:

| riga | cosa dice |
|---|---|
| **r.71** | `InpFirstFraction = 0.3333` → **1/3 a mercato** |
| **r.72** | `InpUsePending = true` → **il resto (2/3) su ordine pendente STOP** |
| **r.396-397** | la gamba a mercato firma `L 1/3` / `S 1/3` |
| **r.407-412** | la pendente firma `L 2/3` / `S 2/3`, con **TP proprio** (`tpP`) e la **stessa SL** |

> ## 🔴 **`1/3` e `2/3` NON sono due operazioni: sono le DUE GAMBE DI UN INGRESSO SOLO** (una a mercato, una su pendente stop nella direzione del trade).

E i dati lo confermano: **5 giorni, 2 gambe ciascuno, aperte a pochi secondi di distanza.**

| data | verso | gamba `1/3` | gamba `2/3` | **segnale** |
|---|---|---:|---:|---:|
| 17/08 | S | 0,00 | +9,64 | **+9,64** |
| 25/08 | L | 0,00 | +7,79 | **+7,79** |
| 31/08 | S | +44,32 | +103,46 | **+147,78** |
| 03/09 | L | −8,48 | −8,49 | **−16,97** |
| 07/09 | S | +44,23 | +52,47 | **+96,70** |

➡️ **`770511` ha n = 5 SEGNALI, non 10.** Il campione e' **la meta'** di quello che
avevo scritto — e lo stavo confrontando con `770201`, che ha **7 posizioni = 7 segnali
veri**. 🔴 **Non erano comparabili.**

🔴 **E un secondo numero che va detto: il 60% del profitto viene da UN SOLO segnale**
(il 31/08, +147,78 su +244,94). Senza quello: **+97,16 su 4 segnali**.

> ## 🎯 **VERDETTO ONESTO: `770511` resta POSITIVA (4 segnali vinti su 5), ma con n=5 e un segnale che fa il 60% del risultato NON è la prima della rosa. `770201` — 7 su 7, nessun segnale dominante — ha il profilo più solido.**

🟢 E le due uscite a **0,00** adesso si spiegano da sole: sono la **gamba `1/3` uscita
a pareggio**, cioè il breakeven che fa il suo lavoro.

📌 **Lezione di metodo, e vale oltre questa sedia**: su un motore a **ingresso
frazionato**, contare le POSIZIONI al posto dei SEGNALI **raddoppia il campione
dichiarato**. E' la classe 226 (deal contro posizioni) **con un gradino in piu'**:
qui anche le POSIZIONI sono troppe, perche' un segnale ne apre due.

🔥 **E dentro, la scomposizione è quella che avevamo già visto**: i due **SHORT** fanno
**+254,12** (`S 2/3` +165,57 · `S 1/3` +88,55), i due **LONG** fanno **−9,18**
(`L 2/3` −0,70 · `L 1/3` −8,48). 👉 **Il guadagno della sedia è tutto del lato corto.**

⚠️ **Campione: 10 posizioni, di cui 6 sul lato short.** Resta un **segnale**, non un
verdetto — e il lato va MISURATO, non dedotto.

📌 Difetto registrato come **classe 426** in `CHECKLIST_RIGA_DI_LANCIO.md`: *la
normalizzazione che appiattisce due identificatori distinti*. Il controllo che lo prende
costa una riga: **`vinte + perse + pareggi == n`**.

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
