# 🩺 SPAZZATA ANOMALIE — CONTO DEMO PICCOLO, 11/09/2026

Richiesta di Claudio: *"Hai controllato se ci sono anomalie sul conto demo piccolo?"*
**Finestra**: 25/08 → 10/09, **83 operazioni chiuse**. Fonte unica:
`data/statements/trades_auto.csv`.

---

## 🔴 ANOMALIA 1 — **25 posizioni su 83 hanno passato del tempo COPERTE da una posizione opposta**

Non è "due sedie sullo stesso simbolo in giornate diverse": è **sovrapposizione
vera nel tempo**, con esposizione netta ridotta o annullata mentre si paga lo
spread su tutte e due le gambe.

| | |
|---|---:|
| posizioni coinvolte | **25 su 83** (30%) |
| **loro netto** | 🔴 **−91,20 EUR** |
| netto di tutte le altre | 🟢 **+293,73 EUR** (n=58) |
| **netto della finestra** | **+202,53 EUR** |

📊 **Dove**: `U30USD` **22 posizioni su 25**. Il resto sull'oro.
🪑 **Sedie coinvolte**: `770511` (6) · `771531` (4) · `770531` (4) · `772341` (3)
· `770611` (3) · e altre cinque con una ciascuna. **Dieci sedie diverse sullo
stesso simbolo.**

> ### 🎯 **Il 30% delle posizioni produce il 100% della zavorra.** Le altre 58 fanno +293,73; queste 25 ne restituiscono 91,20.

### ⚠️ E la lettura onesta, prima di chiamarlo difetto
- ❌ **NON si può dire "senza queste avremmo fatto +293".** Sono le operazioni
  che sono avvenute: toglierle è un controfattuale, non una misura.
- ✅ **Si può dire** che il gruppo con la sovrapposizione ha un netto **negativo**
  mentre il gruppo senza ce l'ha **positivo**, e che la differenza fra i due
  gruppi è di **385 EUR** su 13 giornate.
- 🔴 **E si può dire che il meccanismo è reale**, perché è già documentato in
  casa: il conflitto sull'oro dell'08/09 è agli atti come *"una perdita certa,
  decisa alle 07:19, non un esito di mercato"* — esposizione netta **zero per
  12,5 ore** mentre si pagavano due spread.

## 🟢 NON-ANOMALIA 1 — il tasso di stop, che sembra brutto e non lo è

| esito | n | totale | medio |
|---|---:|---:|---:|
| take profit | 15 | +704,39 | **+46,96** |
| **stop loss** | **58** | −592,34 | −10,21 |
| chiusura dell'EA | 10 | +90,48 | +9,05 |

**58 stop contro 15 target** sembra un disastro. **Non lo è**: il netto è
**positivo**, e il profilo è quello giusto — **poche vincite grosse contro molte
perdite piccole** (rapporto 4,6:1 fra la vincita media e la perdita media).
✅ E le operazioni chiuse **in utile** sono **44 su 83 = 53%**: molte chiudono al
trailing, non al target. **Nessuna anomalia qui.**

## 🟡 DA GUARDARE 2 — cinque operazioni a profitto **esattamente zero**
Cinque chiusure con `profit = 0,00` esatto. Su un conto con commissione e
spread, uno zero pulito è **improbabile per caso**. 👉 Non ho la causa: è
`[NON MISURATO]`, e va guardato nel Giornale del terminale.

## 🟢 NON-ANOMALIA 2 — le due chiusure sotto il minuto
`EMA200` il 04/09 alle **21:30:54** e **21:30:59**: è la **chiusura d'orario**
programmata, non un'uscita impazzita. ✅

## 🟢 NON-ANOMALIA 3 — i magic con quattro etichette
`771531`, `770511`, `770531` mostrano quattro etichette ciascuno (L1/L2/S1/S2 o
1/3 e 2/3): sono **le gambe e le tranche dello stesso segnale**, non magic
duplicati. ✅ Ma è il motivo per cui il conteggio `n` va fatto sui `pid`
(classe 226).

---

## 📋 E LE ANOMALIE GIÀ TROVATE OGGI, per non ripeterle sparse

| # | cosa | stato |
|---|---|---|
| 🔴 | **Il pavimento del lotto fa rischiare 1,62% contro l'1,00% dichiarato** su `EMA200` | sorgente corretto, **default invariato**, serve firma per la politica |
| 🔴 | **42 sorgenti su 42 in campo diversi dal repo**, compilati 5-18 agosto. Il `Guardian` ha **414 righe contro 899** | 🔴 **aperto, ed è il più grave** |
| 🔴 | **La flotta gira al 58% della frequenza promessa** (34 op contro 58,6, `p = 0,00035`) | criterio del tagliando **scattato** |
| 🟠 | **`771203` PostNews ha il calendario scaduto** (due righe, ferme al 04/09) → zero operazioni possibili | da ricaricare |
| 🟠 | **`771201` ECB: il prossimo evento è il 29/10** — cioè **dopo** l'inizio della challenge | da sapere |
| 🔴 | **14 sedie su 39 non scrivono niente quando rifiutano un ingresso** | lì siamo ciechi |

---

## ⚠️ I LIMITI DI QUESTA SPAZZATA, dichiarati

- 📅 **L'11/09 non c'è**: l'esportazione gira alle 22:45, quindi oggi si vede
  stanotte.
- 🧾 Il file contiene **solo posizioni CHIUSE**: quelle ancora aperte (e i
  pendenti) non sono in questa analisi.
- 🔢 **Il file non ha la colonna del conto.** Quattro sedie (`770101`, `770202`,
  `770411`, `770611`) girano su **più terminali**: le loro righe qui potrebbero
  mescolare conti diversi. 👉 **È un buco vero**, e si chiude aggiungendo il
  numero di conto all'esportatore.
- ⏱️ La sovrapposizione è calcolata su **apertura e chiusura**: non vede i
  pendenti in attesa, che pure impegnano margine.
