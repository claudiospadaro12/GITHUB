# 🧭 DOVE SIAMO DAVVERO — 17/08/2026, risposta a una domanda diretta

_Claudio: **"stiamo facendo miglioramenti in vista delle prop o non sei
fiducioso?"**. Risposta onesta, coi numeri del conto vero._

---

## 1. 🔴 IL FATTO CHE VIENE PRIMA DI TUTTI

**Agosto, conto piccolo (~5.100 €): 90 operazioni, −617,49 €. Circa −11%.**

| | |
|---|---|
| magic che hanno operato ad agosto | **28** |
| in utile | **10** (+422,68) |
| in perdita | **18** (−1.040,17) |

> ### 🎯 **Su una prop vera, con questo drawdown, saremmo GIÀ FUORI dal muro del 10%.**
> Scalato a 0,65% farebbe **−7,2%**: dentro, ma con **metà mese ancora da fare**
> e nessun margine per una brutta settimana.

## 2. ✅ COSA È MIGLIORATO OGGI — e va detto per quello che è

Oggi abbiamo fatto **cinque round** (R76→R80), sbloccato **26 anni** di storico,
misurato **59 simboli**, trovato un difetto di unità di misura, messo **un
duello in campo** e scritto **tre correzioni** mie.

🔴 **Ma niente di tutto questo è un miglioramento del RENDIMENTO.**
Sono miglioramenti della **capacità di misurare**. Sono reali e servivano —
senza non avremmo scoperto che `PTE USDJPY` non ha edge, che il buffer era
tarato male su tutte le sedie, che il difetto "pip" è una famiglia intera.
**Ma il conto non li vede.**

**Confondere "abbiamo misurato meglio" con "stiamo andando meglio" sarebbe
esattamente l'errore che questo progetto passa il tempo a evitare.**

## 3. 🚨 E NEI DATI DI STASERA C'È UN DIFETTO STRUTTURALE CHE NON AVEVAMO MAI GUARDATO

**Abbiamo criteri d'ingresso durissimi e ZERO criteri di uscita.**

Quattordici round per decidere di **non** toccare un parametro. E intanto:

| magic | strategia | agosto | storico nel file |
|---|---|---:|---:|
| **770101** | DAX Apertura EU BUY | **−252,63** su 10 op (**7 vincenti**) | **−649,52** su 26 |
| 770203 | Nasdaq Live 5m BUY | −182,64 su 2 op | +206,63 |
| 770601 | ORB BUY | −86,40 su 7 op | +351,51 |
| 770311 | Apertura Marco BUY | −79,29 su 4 op | −179,51 |

> ### 🔴 **`770101` è a −649 su 26 operazioni nell'intero file. È ancora acceso.**
> **Vince 7 volte su 10 e perde 252 euro in un mese**: tante vincite piccole,
> poche perdite enormi. È un profilo che il nostro imbuto **non guarda mai**,
> perché l'imbuto giudica prima del deploy e poi si dimentica.

📌 **Le sedie entrano e non escono più.** Ventotto magic attivi su un conto da
5.100 €, a rischio 1% ciascuno: **51 € per operazione**. Il conto non è
dimensionato per ventotto EA, e nessuno ha il compito di spegnerne uno.

## 4. 🧭 LA RISPOSTA ALLA DOMANDA, IN CHIARO

**Sulla prop, oggi: NO, e la distanza non è piccola.**
Non abbiamo un motore che passerebbe una prop: quelli misurati bene o non
hanno edge (`PTE USDJPY`), o hanno la taratura sbagliata (`PTE GBPUSD`), o
hanno storico troppo corto per saperlo (tutti gli indici).

**Sul metodo: sì, ragionevolmente fiducioso — a una condizione.**
Il metodo funziona: oggi ha **bocciato** cose che avremmo tenuto per buone, e
ha **retto a tre correzioni** senza che nessuno le nascondesse. Un metodo che
scopre i propri errori è un metodo che funziona.

🔴 **La condizione è che smetta di guardare solo in avanti.** Finché misuriamo
solo i candidati e mai le sedie accese, il conto continuerà a fare quello che
sta facendo ad agosto **mentre noi guardiamo backtest di tredici anni**.

## 5. ➡️ COSA PROPONGO, IN ORDINE DI IMPORTANZA

**1. 🛑 Un CRITERIO DI USCITA, congelato come tutti gli altri.**
È il pezzo che manca al sistema, ed è il più importante. Una bozza da discutere
(numeri da decidere insieme, **prima** di guardare chi verrebbe colpito):
> _Una sedia si spegne se, su almeno 20 operazioni in forward, è in perdita
> **e** il suo drawdown ha superato quello misurato nel backtest della cella
> che l'ha promossa._

**2. 📉 Ridurre le sedie o il rischio sul conto piccolo.**
Ventotto magic a 1% su 5.100 € non è un portafoglio: è un modo per misurare
tutto insieme e non capire niente. **O meno sedie, o rischio più basso.**

**3. 🔍 Un round sulle sedie ACCESE, non sui candidati.**
Prendere i cinque magic peggiori di agosto e chiedersi, con lo stesso rigore
usato per la PTE: **hanno ancora una ragione di stare lì?**

**4. ⏸️ E solo dopo, tornare a cercare edge nuovi.**

---

## 6. 📌 UNA COSA CHE NON SO E VA MISURATA

Il dry-run FTMO da 100k è a **−826,86 dal via (−0,83%)**, il conto piccolo a
**−11% in agosto**. **Non so perché la differenza sia così grande** — meno
sedie? rischio diverso? partito dopo? **[NON MISURATO]**, e va capito: se il
100k è messo davvero così meglio, allora il problema è la configurazione del
conto piccolo e non i motori.
