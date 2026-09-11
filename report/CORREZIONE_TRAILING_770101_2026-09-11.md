# 🔧 CORREZIONE AL REFERTO DELLE 12:00 — e cambia la raccomandazione

**Riguarda:** `report/TRAILING_770101_2026-09-11.md` (mio, stamattina).
**Verificato da me, riga per riga, su `data/statements/trades_auto.csv`.**

---

## ❌ ERRORE 1 — ho scritto "in punti" un rapporto che era "in euro"

Avevo consegnato: *"il rapporto è **1 : 14,1** (in punti indice)"*.

| rapporto vincita/perdita mediana | valore | `[MISURATO]` |
|---|---|---|
| in **EURO** (7,43 / 104,60) | **1 : 14,08** | ✅ questo era il numero |
| in **PUNTI** (7,15 / 71,90) | **1 : 10,06** | 🔴 **questo è quello che avevo etichettato** |

👉 **Il numero era giusto, l'etichetta no.** E l'etichetta contava, perché nei
limiti dichiarati avevo scritto *"il rapporto regge comunque, è in punti"*:
**quella frase si appoggiava su un'etichetta sbagliata.**

## ❌ ERRORE 2 — il più grave: **ho misurato insieme DUE configurazioni**

La colonna `strategy` del CSV le separa, **e io non l'ho guardata**.

| configurazione | n | punti | EUR | vinc. mediana | perd. mediana | rapporto |
|---|---:|---:|---:|---:|---:|---:|
| 🔴 **ROTTURA** (`BUY`/`SELL` nudi) — 20/07 → 14/08 | 24 | **−482,1** | **−658,82** | +6,90 | −71,90 | **1 : 10,42** |
| ✅ **RETEST** (`RETEST BUY`) — 07/08 → 08/09 | 11 | **+176,3** | **+94,35** | **+14,75** | −23,40 | **1 : 1,59** |

> ### 🎯 Tutta la perdita sta nella configurazione VECCHIA. Quella VIVA è in attivo.
> La sedia viva è **RETEST** — `mql5/Presets/conto_reale/...770101_REALE.set`.

E il difetto che avevo descritto **si dissolve proprio lì**: sulla RETEST la
vincita mediana **raddoppia** (+14,75 contro +6,90) e la perdita mediana **si
divide per tre** (−23,40 contro −71,90).

---

## ⚠️ MA NON CANTIAMO VITTORIA — il campione RETEST è da n=1

🔴 Quel **1 : 1,59** poggia su **UNA SOLA operazione perdente**. Una perdita in
più da −70 punti e il rapporto si ribalta.

📏 Emendamento A (≥150 operazioni): con 11 op **non siamo neanche vicini**.
👉 Il verdetto corretto sulla RETEST è **`[NON ANCORA MISURATA]`**, in tutte e
due le direzioni: **non è "brutta", e non è nemmeno "bella".**

---

## 🔁 COSA CAMBIA NELLA RACCOMANDAZIONE

Stamattina avevo consigliato di **ridurre la taglia** della `770101` sul reale.

🔴 **Ritiro il consiglio**, e dico perché: era costruito su un netto negativo
che, misurato bene, **appartiene a una configurazione che non gira più da un
mese**. Ridurre la taglia avrebbe punito la sedia viva per i peccati di quella
morta — e avrebbe **rallentato l'unico campione che ci serve**.

✅ **Nuova raccomandazione: NIENTE cambio di taglia. La sedia RETEST resta com'è
e continua a raccogliere operazioni.** Quello che serve non è una manopola: è
un **n**.

⚖️ **E il criterio MERITO del 18/08 resta rispettato alla lettera**, non aggirato:
dice *"si spegne la SEDIA colpevole, la gemella positiva resta"*. Qui la
colpevole è la **ROTTURA**, ed **è già spenta dal 14/08**.

---

## ✅ CHE LA FRASE DI STAMATTINA CHE REGGE È QUESTA

*"Le manopole di uscita di questa famiglia non sono MAI state messe ad asse."*
👉 Vera prima, vera adesso. **Il round R128 serve ancora**, e serve di più: ora
deve misurare la **RETEST**, non una media di due sedie diverse.

---

## 🧪 IL CONTRO-ESEMPIO, prima di consegnare anche questa

| ipotesi che romperebbe la correzione | verifica | esito |
|---|---|---|
| *"RETEST e ROTTURA si sovrappongono nel tempo, quindi il taglio è arbitrario"* | 🔴 **VERO in parte**: si sovrappongono dal **07/08 al 14/08**. Ma il taglio **non è per data**: è per **etichetta scritta da MT5** nella colonna `strategy` | ✅ regge — è un fatto stampato, non una mia inferenza |
| *"la RETEST è in attivo solo perché ha girato in un mese buono"* | 🔴 **`[NON MISURATO]`** — nella finestra comune 07/08→14/08 la ROTTURA ha troppo poche operazioni per un confronto | 🔴 **non lo so, e non lo invento** |
| *"la differenza è il caso, con n=11"* | Con **1 sola perdita** nessun test ha potenza | ⚠️ **VERA**: per questo il verdetto è *non misurata*, non *promossa* |

📌 **La correzione è solida su cosa NON si può concludere; è debole — e lo
dichiaro — su cosa si può concludere in positivo.**
