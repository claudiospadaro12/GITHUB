# 🧱 IL MURO DEL 10% NON È MAI STATO MISURATO — e cinque sedie sono segnate rosse per un confronto non dimostrato

**22/09/2026, notte** · branch `lavoro`
Nato da un errore mio, beccato dal cancello: il 21/09 ho scritto che *«il DAX sfonda il muro
FTMO del 10%»*. **Non era dimostrato.** Andando a capire perché, ho trovato che **lo stesso
confronto sta sotto la colonna rossa di `CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md`**, cioè sotto
il documento che ha fatto scattare una revisione.

> ## 🎯 IN UNA RIGA
> **Il numero che decide se una sedia sfonda il Max Loss FTMO non è nei nostri file, e non è mai
> stato misurato per nessuna delle sei sedie.** Quello che usiamo al suo posto — `Equity DD %`
> del tester — è un **limite superiore**, non la perdita. Quindi oggi **non possiamo dire né che
> sfondano né che sono al sicuro**.

---

## 1. 📐 PERCHÉ È UN LIMITE SUPERIORE, e non un'opinione

| | riferimento |
|---|---|
| **`Equity DD %`** del tester MT5 | **dal PICCO** di equity (peak-to-valley) |
| **Max Loss FTMO 2-Step** | **STATICO dal saldo iniziale** — *«equity must not drop below 90% of the initial account balance»* (`docs/REGOLAMENTO_FTMO_2026-08.md`) |

Con `I` saldo iniziale, `E_min` minimo di equity, `P` il picco al momento di `E_min`, e `P ≥ I`:

- perdita contro il muro = `1 − E_min/I`
- `Equity DD %` = `1 − E_min/P`

Poiché `P ≥ I` ⇒ `E_min/P ≤ E_min/I` ⇒ **`Equity DD % ≥ perdita statica`, SEMPRE.**

🔴 **È la classe 515**, in checklist dal 20/09. Ci sono ricascato il 21/09 — e il documento del
20/09 la contiene già al suo interno, nella sua colonna principale.

---

## 2. 📊 LA COLONNA ROSSA DEL 20/09, E COSA DICE DAVVERO

`report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` mette in colonna il **DD @2,00%** — cioè
`Equity DD %` **×2** — e lo confronta col muro del 10%:

| sedia | DD @2,00% dichiarato | segnato |
|---|---|---|
| `771531` EMA200 Dow | OOS **15,66%** · IS 11,47% | 🔴 |
| `770101` DAX Apertura | OOS **14,47%** · IS 10,87% | 🔴 |
| `770260` Nasdaq RETEST | OOS 7,35% · IS **11,91%** | 🔴 |
| `770202` Dow Apertura | OOS 8,79% · IS **11,34%** | 🔴 |
| `770511` SuperWave | 7,82 – 8,34% | 🟠 |
| `770411` MaxMin DAX Short | 3,84% | 🟢 |

E il documento dice, testualmente: *«Il DD della colonna «@2,00%» è quello che fa scattare la
revisione lunedì.»*

> 🔴 **Ma quei numeri sono `Equity DD %`, cioè LIMITI SUPERIORI.** Una sedia segnata «11,34%»
> può avere una perdita statica **molto minore** — o anche vicina, non lo sappiamo. **Il rosso
> non è dimostrato, e nemmeno il verde.**

⚠️ **E NON è una buona notizia travestita.** Non sto dicendo che le sedie sono a posto: sto
dicendo che **non lo sappiamo**, e che una revisione decisa su un numero non dimostrato può
sbagliare **in tutte e due le direzioni** — spegnere una sedia sana, o lasciarne accesa una che
sfonda.

---

## 3. 🟢 IL LIMITE SUPERIORE MIGLIORE CHE I CSV SANNO DARE

Non serve nessuna corsa nuova. Il drawdown **in valuta** si ricava dalle colonne che ci sono:
`DD_assoluto = Profit / Recovery Factor`. E poiché il caso peggiore è che il drawdown parta
esattamente dal saldo iniziale (`static = I − P + DDass ≤ DDass`, dato `P ≥ I`):

> **`perdita_statica ≤ DD_assoluto / deposito`**

| sedia · finestra | `Equity DD %` ×2 | **limite sup. a taglia vera** |
|---|---:|---:|
| `770202` Dow · IS | 11,35% | **≤ 11,52%** |
| `770202` Dow · OOS | 8,79% | **≤ 8,90%** |
| `770101` DAX · IS | 10,82% | **≤ 11,69%** |
| `770101` DAX · OOS | 14,50% | 🔴 **≤ 17,81%** |

🟠 **Attenzione al verso, ed è controintuitivo**: a denominatore fisso i numeri vengono **più
ALTI**, non più bassi. Non perché il rischio sia peggiore — perché `Equity DD %` divide per un
picco **maggiore** del deposito e quindi **attenua**. 👉 **Il limite superiore onesto è peggiore
di quello che leggevamo.** Ma resta **un limite**, non la perdita.

🔬 **E questo spiega anche un'altra cosa**: la cella `0.25` del DAX sembrava *«la sola sotto il
muro»* con 9,69%. A denominatore fisso vale **10,75%**. Quel *«sotto il muro»* era **un
artefatto del denominatore mobile** (classe 550).

---

## 4. ✅ IL SOLO CONFRONTO OMOGENEO CHE ABBIAMO, E PASSA

C'è una colonna che si confronta con una regola FTMO **senza nessuna acrobazia**:
`Peggior Giornata %` contro il **Max Daily Loss del 5%**. Giornata contro giornata.

| sedia | misurato a taglia banco | a taglia vera |
|---|---:|---:|
| `770202` Dow | −1,00% | **~2,0%** |
| `770101` DAX | −1,08% | **~2,2%** |

🟢 **Passa con margine.** ⚠️ Con due avvertenze da non perdere: **(i)** il tester divide per
l'equity d'inizio giornata, il MDL FTMO per il **capitale iniziale** — mobile contro fisso, la
515 in scala giornaliera (fattore ≤ **1,228** → il Dow arriva a **≤ 2,65%**); **(ii)** il 5% è
**DI CONTO** e su quel conto operano **sei** sedie: **una sola sta già a ~53% del budget
giornaliero.** La quota per sedia **non è un numero firmato**, ed è di Claudio.

---

## 5. 🎯 LA MISURA CHE CHIUDE TUTTO, E COSTA ZERO CORSE

> **La minima equity contro il saldo iniziale, per passata.**

Non è nei CSV di ottimizzazione. **Sta nel report HTML del tester**, che MT5 produce per ogni
passata sul PC di backtest. Serve leggerlo — non rigirare niente.

Con quel numero:
- ogni 🔴 e ogni 🟢 di `CONTRATTI_DELLE_SEDIE_FTMO` diventa **dimostrato**;
- si sa se la revisione del 21/09 era dovuta o no;
- e il criterio di uscita del 18/08 (*«DD forward > DD promesso → revisione immediata»*) acquista
  **un DD promesso che si può confrontare** con quello che il forward misura.

🔴 **Finché manca, ogni frase su «sfonda / non sfonda» è un'ipotesi** — la mia del 21/09
compresa, e la colonna rossa del 20/09 pure.

---

## 6. 📋 COSA PROPONGO, in ordine

1. 🔴 **Leggere la minima equity** dai report HTML delle passate già girate (Dow, DAX, Nasdaq).
   **Zero corse.** È il passo che sblocca tutti gli altri.
2. 🟠 **Riscrivere la colonna di `CONTRATTI_DELLE_SEDIE_FTMO`** distinguendo tre cose che oggi
   sono una: `Equity DD %` (quello che abbiamo), **limite superiore** `DDass/deposito` (quello
   che possiamo calcolare ora), **perdita statica** (quello che decide).
3. 🟢 **Tenere il confronto giornaliero**, che è l'unico omogeneo, e portarlo a Claudio con la
   domanda sulla quota per sedia — che è una **firma**, non una misura.

---

## 🕳️ COSA NON HO VERIFICATO

- **Se la revisione del 21/09 sia stata fatta**, e con che esito. Il documento la annuncia; non
  ho trovato il verbale.
- **Le altre quattro sedie**: il limite superiore l'ho calcolato solo per Dow e DAX, dove i CSV
  di R202A/R202B sono in repo con `Profit` e `Recovery Factor`. Per Nasdaq, EMA200, SuperWave e
  MaxMin serve aprire i rispettivi CSV d'archivio.
- **Il deposito delle misure d'origine**: `CONTRATTI_DELLE_SEDIE_FTMO` dichiara banchi diversi
  per sedia (100.000, 10.000). I miei limiti superiori usano **80.000**, il banco di R202A/R202B.
  🔴 **Un DD in valuta NON si confronta fra banchi diversi**: prima di mettere le sei sedie in
  una tabella sola, ogni numero va riportato al suo deposito.
