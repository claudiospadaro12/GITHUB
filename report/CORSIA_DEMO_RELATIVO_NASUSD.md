# 🪑 CORSIA DEMO — SEDIA `RELATIVO NASUSD` (magic **774690**)

_Scritta il **07/09/2026**, **PRIMA** che la sedia apra una sola posizione._
_Mandato: `report/MANDATO_2026-09-07_v2.md` (le decisioni che non toccano soldi
veri sono delegate). Regole della corsia: `report/CORSIA_DEMO_REGOLE.md`.
Candidato 🥇 G1 di `report/CORSIA_DEMO_CANDIDATI.md`._

> 🔴 **DA RIPETERE OGNI VOLTA, E QUI E' LA PRIMA RIGA:** la **gamba D30EUR di
> questo stesso motore e' BOCCIATA PER RISCHIO** — DD OOS **25,01%** e peggior
> giornata **−5,20%**, cioe' **due muri prop sfondati insieme**. In demo va
> **SOLO NASUSD**. Il preset non va caricato su D30EUR per nessun motivo.
> _(fonte: `backtest_pipeline/REGISTRO_TEST.md` §"R117 RELATIVO D30EUR — BOCCIATA PER RISCHIO")_

---

## 🪪 IDENTITA'

| campo | valore | fonte |
|---|---|---|
| EA | `mql5/Experts/ABTG_Relativo.mq5` (gia' scritto, gia' girato a tick reali) | R117 |
| Simbolo / TF | **NASUSD M5**, metro di lettura **U30USD** | `backtest_pipeline/prove/RELATIVO_R117_NAS.txt` |
| Sessione | **14:30 → 22:00 ORA SERVER BCM** (= 15:30 → 23:00 italiane) | idem |
| Cella | `N=40` · `sigma_in=1.35` · `sigma_out=0.05` · `AtrSL=2.75` · `MaxTradesPerDay=5` · `Lato=0` | idem |
| Rischio | **0,65%** — nessuna riscalatura (vedi sotto) | idem |
| **Magic** | **774690** — verificato VERGINE repo-wide il 07/09/2026 | `grep -rn "774690" . --exclude-dir=.git` → **0 occorrenze** |
| Preset | `mql5/Presets/ABTG_Relativo_NASUSD_DEMO.set` | — |
| **Conto** | **DEMO PICCOLO 50503392**, cartella `C:\Program Files\BCM Markets MT5 Terminal` | `report/CORSIA_DEMO_REGOLE.md` |
| Guardian | **ASSENTE** (l'EA non ha l'input; il conto e' senza Guardian per scelta di Claudio del 07/09) | idem |

### 💶 Il rischio 0,65% NON e' stato riscalato, ed e' un fatto
La cella R117 e' stata **misurata direttamente a `InpRiskPercent = 0.65`**, che e'
gia' il metro di casa firmato il 18/08 (cap C1 **3,25%** = 5 SL vivi da 0,65%).
👉 Quindi **DD 8,40%** e **peggior giornata −2,12%** valgono **tali e quali**,
senza nessuna scalatura inferita. _(a differenza del contratto GATEDSHORT 770250,
dove il DD promesso e' un numero scalato)_

### 🔓 Rischio aperto: **0,65% massimo**, letto nel codice
`gTicket` e' una **variabile singola**, non un vettore: l'EA tiene **UNA sola
posizione per volta**. `InpMaxTradesPerDay=5` e' il tetto delle operazioni **al
giorno**, non delle posizioni contemporanee.
- rischio aperto massimo: **0,65%** contro cap C1 **3,25%** → nessuno sfondamento;
- peggior giorno teorico: 5 × 0,65% = **3,25%**, dentro il muro giornaliero prop del 5%.

---

## 1️⃣ LA DOMANDA

> **Su NASUSD, la convergenza dello z-score del rapporto NASUSD/U30USD produce
> un'aspettativa positiva al netto dei costi VERI di esecuzione, su un campione
> che il backtest non puo' fabbricare (n ≥ 150 forward)?**

Il backtest, su questa gamba, **non e' un cancello severo: e' lo strumento
sbagliato**. A6 (n ≥ 150 in IS **e** OOS) **non e' raggiungibile per aritmetica**:
0,525 op/gg × **503 feriali disponibili** dal pavimento tick 2024.09.26 contro i
**567 necessari** — mancano 64 feriali. Lo split e' a somma zero: il massimo
ottenibile oggi e' **min(n_IS, n_OOS) ≈ 133**.
_(fonte: `backtest_pipeline/REGISTRO_TEST.md` §"A6 NON E' RAGGIUNGIBILE SU QUESTA GAMBA")_

---

## 2️⃣ IL TRAGUARDO — n = 150 operazioni

| | |
|---|---:|
| frequenza misurata (media pesata IS+OOS) | **0,525 op/giorno feriale** |
| feriali necessari per 150 operazioni | **286** (150 / 0,525 = 285,7) |
| partenza ipotizzata | **08/09/2026** |
| 🎯 **data stimata per n = 150** | **13/10/2027** |
| durata | **~13,1 mesi** · 400 giorni solari |

✅ **13,1 mesi sta sotto il tetto dei ~18 mesi: la sedia si accende.**

> ⚠️ **CORREZIONE DI UN NUMERO GIA' AGLI ATTI, dichiarata.**
> `report/CORSIA_DEMO_CANDIDATI.md` §6 scrive _"n=150 arriva in **11 mesi**
> (RELATIVO)"_. **Quel numero e' incoerente col suo stesso documento**, che alla
> riga sopra dice "~11 op/mese": 150 / 11,42 = **13,1 mesi**, non 11.
> Il conto giusto e': 0,525 op/feriale × **21,75 feriali/mese** = **11,42 op/mese**
> → **13,1 mesi**. Qui vale **13,1 mesi / 13-10-2027**, e il candidati.md va
> corretto quando lo si tocca la prossima volta.

📐 **Cosa contiene e cosa non contiene la stima:** i "feriali" sono giorni
lun-ven **di calendario**, festivi USA compresi. E' coerente con la misura
d'origine, che contava allo stesso modo (87 op su 183 feriali IS, 154 su 276
OOS): le chiusure di borsa sono gia' dentro il tasso 0,525. **Non e' modellato**
un cambio di regime che alzi o abbassi la frequenza.

### 📍 Le due tappe intermedie (per non guardare nel vuoto)
| data | feriali | n atteso |
|---|---:|---:|
| **02/11/2026** | 39 | ~20 operazioni |
| **08/03/2027** (tagliando) | 129 | ~68 operazioni |

---

## 3️⃣ IL DD PROMESSO — **8,40%** · e' il cancello di rischio vivo

**Fonte:** `backtest_pipeline/REGISTRO_TEST.md` §"R117 RELATIVO NASUSD",
confermata in `backtest_pipeline/righe/RIGA_RELATIVO_R117BIS.ps1` righe 9-14.

| metrica OOS (tick reali BCM, rischio 0,65%) | valore | cancello | esito |
|---|---:|---|---|
| aspettativa | **+0,063 R** | A1 ≥ 0,075 (muro 0,050) | 🟠 zona morta |
| profit factor | **1,189** | A2 ≥ 1,15 | ✅ passa |
| **drawdown equity** | **8,40%** | A4 ≤ 8,0 (muro 10,0) | 🟠 **zona morta** |
| peggior giornata | **−2,12%** | A5 ≥ −4,0 (muro −5,0) | ✅ passa |
| trade sotto 60 s | **0,00%** | A7 < 25% | ✅ collaudo passato |
| n | **IS 87 / OOS 154** | A6 ≥ 150 in ENTRAMBE | ❌ non passa |

### 🟠 LA FRASE CHE VA SCRITTA OGNI VOLTA CHE SI CITA QUESTA SEDIA
**Il DD 8,40% e' DENTRO il muro prop del 10% ma SOPRA la soglia 8,0% dei criteri
congelati di R117: e' in ZONA MORTA.** Il margine dal muro prop e' di **1,60
punti percentuali** — cioe' basta un forward **peggiore del backtest di meno di
un quinto** perche' il muro salti.

👉 **Cancello di rischio vivo (corsia RISCHIO firmata il 18/08):**
**se il DD forward supera 8,40% → REVISIONE IMMEDIATA.** Non "quando arriva al
10%": al numero promesso. Un DD e' un fatto accaduto e vale a qualunque n.

### 🟠 E LA SECONDA INCOERENZA, DETTA PRIMA CHE LA TROVI QUALCUN ALTRO
**A3 e' incoerente: l'IS e' in PERDITA (PF 0,754), l'OOS in utile (PF 1,189).**
I due campioni hanno taglia molto diversa (87 contro 154), quindi l'incoerenza
**puo' essere rumore** — ma **non e' dimostrato che lo sia**. E' esattamente una
delle cose che il forward serve a leggere.

---

## 4️⃣ IL TAGLIANDO — **08/03/2027** (6 mesi, data fissa)

Si guarda **comunque**, anche se n non e' arrivato (atteso ~68 operazioni). Si
leggono, in quest'ordine:
1. **DD reale** contro 8,40% promesso;
2. **frequenza reale** contro 0,525 op/gg promessi;
3. **il segno**, sapendo che a n≈68 il merito e' ancora **formalmente sospeso**;
4. **quanti giorni hanno colpito il tetto di 5 operazioni** (dice se il tetto sta
   mordendo il motore o se e' solo una rete).

---

## 🔌 COSA LA FA SPEGNERE PRIMA DEL TEMPO

| # | trigger | verifica | azione |
|---:|---|---|---|
| 1 | **DD > 8,40%** | equity del conto 50503392, magic 774690 | 🔴 **revisione immediata** (RISCHIO, 18/08) |
| 2 | **una giornata peggiore di −4,0%** | e' la soglia A5, ed e' la pausa che il Guardian **qui non fara'** | 🔴 revisione immediata |
| 3 | **una giornata peggiore di −5,0%** | muro prop giornaliero | ⛔ **spegnimento**, non revisione |
| 4 | **piu' di 5 operazioni in un giorno** | e' un BACO: il tetto e' aritmetica di rischio, non una preferenza | ⛔ spegnimento e indagine sul codice |
| 5 | **opera su un simbolo che non e' NASUSD**, o con magic ≠ 774690 | preset caricato male | ⛔ spegnimento immediato |
| 6 | **frequenza reale < 0,26 op/gg** (meta' del promesso) dopo 60 feriali (≈ 02/12/2026) | il traguardo n=150 andrebbe oltre 26 mesi = fuori dal tetto dei 18 | 🟠 revisione del traguardo |
| 7 | **zero operazioni per 15 feriali di fila** | quasi certamente il metro U30USD non arriva, non e' il mercato | 🟠 diagnosi tecnica prima di ogni giudizio |

### ❄️ Cosa **NON** la spegne, e va detto per non ucciderla per sbaglio
Il criterio **MERITO a 20 operazioni** firmato il 18/08 **NON si applica a questa
sedia**, e non e' una scappatoia: **e' la definizione stessa della corsia demo**.
Una sedia messa in demo per accumulare 150 operazioni, spenta a 20 perche' e' in
perdita, non risponderebbe mai alla domanda per cui e' stata accesa — e a n=20
il merito e' rumore, non misura (regola del 16/08: _il campione sottile sospende
il giudizio sul MERITO, mai sul RISCHIO_).
🔴 **Il RISCHIO invece morde per intero, a qualunque n**: sono i trigger 1-5 qui
sopra. **Questa e' l'unica riga della scheda che allenta qualcosa, ed e'
dichiarata in chiaro.**

---

## 🛑 LA CORSIA DEMO **NON E' UNA PORTA VERSO IL CONTO REALE**

Testuale da `report/CORSIA_DEMO_REGOLE.md`:
> _Una sedia che va bene in demo **non passa in campo in automatico**: torna in
> coda all'imbuto con il suo n finalmente pieno, e da li' si giudica col merito,
> come tutti. Il passaggio ai soldi veri resta una **firma specifica su un numero
> misurato**._

E il mandato v2 del 07/09 lo blinda: **il conto REALE 10105439, i parametri di
rischio e le spese restano firma di Claudio.** Questa sedia gira su **DEMO
50503392**, costa **zero euro**, e alla fine dei 13 mesi produce **un numero**,
non una promozione.

---

## ⚠️ COSA QUESTA SCHEDA NON COPRE (dichiarato prima, non dopo)

1. **Tracciabilita' incompleta dei numeri promessi.** I **CSV grezzi di R117 NON
   sono in `backtest_pipeline/risultati_archivio/`** (verificato il 07/09: la
   cartella `sondarelativo/` contiene solo i referti del **passo 0**). I numeri
   hanno **due citazioni indipendenti nel repo** (`REGISTRO_TEST.md` e
   `RIGA_RELATIVO_R117BIS.ps1`) ma **non un file di misura primario**. Non e' un
   motivo per non accendere una sedia demo; **lo sarebbe per una sedia reale.**
2. **L'OOS di R117 non e' un vero out-of-sample**, e lo dice il file prova stesso:
   la cella e' stata scelta guardando una misura che copre **l'intera finestra**,
   OOS compreso. _"L'unico vero out-of-sample sara' il forward demo."_ 👉 **e' questo.**
3. **UN SOLO REGIME.** Tutto il tick BCM sugli indici sta in **21 mesi di toro**
   (pavimento 2024.09.26). L'Emendamento della Finestra: regola **A soddisfatta**,
   regola **C NON soddisfatta**. **Da R117 non esce una sedia** — esce questa
   osservazione.
4. **L'esecuzione vera** — slippage, requote, rifiuti — **non e' misurata**: lo
   `ABTG_SlippageLogger` sul conto reale ha ancora **0 deal**. `InpSlippagePts=10`
   e' una **tolleranza di riempimento**, non un costo simulato.
5. **`InpMaxSpreadPts=0` = filtro spread SPENTO**, anche in forward. Scelta
   dichiarata (si copia la cella promossa, non se ne inventa un'altra). Spread
   NASUSD misurato 14-20 server: **1,6-1,8 punti indice, P95 2,7**
   _(`backtest_pipeline/risultati_archivio/SPREAD_FLOTTA_MISURA_2026-09-03.md`)_.
6. **Il tetto per cluster/valuta al 3,0%** e' firmato il 07/09 ma **NON collaudato**:
   non e' una protezione, e accendere questa sedia non lo attiva.
7. **Nessuna correlazione misurata** fra questa sedia e la flotta viva. Gira su un
   conto separato: il suo rischio aperto **non entra** nel conteggio del cap 3,25%
   della flotta principale finche' resta li'.

---

## ✅ VERDETTO — **SI ACCENDE**

Passa tutti e tre i cancelli della corsia demo:
- 🟢 **il RISCHIO ha un numero, e sta dentro i muri prop**: DD 8,40% < 10%,
  peggior giornata −2,12% < 5%, rischio aperto 0,65% < cap 3,25%;
- 🟢 **il traguardo e' raggiungibile**: 13,1 mesi, sotto il tetto dei 18;
- 🟢 **e' fermata SOLO da n<150**, che e' esattamente cio' che la corsia risolve —
  e la sua impossibilita' e' **aritmetica**, non sfortuna.

🟠 **Con due riserve scritte grande:** il **DD in zona morta (8,40% > soglia 8,0)**
e **A3 incoerente (IS in perdita)**. Nessuna delle due e' una bocciatura;
entrambe vanno rilette al tagliando dell'**08/03/2027**.

---

_Nessun EA, preset esistente, sedia o parametro di forward e' stato toccato.
Nessun backtest lanciato. Se un referto e questo documento divergono,
**comanda il referto**._
