# 🔴 FORWARD 03/08/2026 — la prova che il collo di bottiglia è l'USCITA, non l'ingresso

_Quattro episodi reali sul demo BCM in una sola mattina. Non è un backtest: è successo davvero._

---

## 1. DAX — i "morti" hanno comprato senza livello

| Ticket | EA | Ingresso | Uscita | S/L | Durata | P&L |
|---|---|---|---|---|---|---|
| #2972556 | DAX Live 5m | 25 900,00 | 25 858,60 | **25 858,60** | 80 s | **−111,78** |
| #2972555 | DAX Live5m v2 | 25 901,00 | 25 858,60 | **25 858,60** | 79 s | **−55,12** |

Chiusi **esattamente sullo stop iniziale**. Nessun bug: lo stop ha fatto il suo mestiere.

🔑 **Massimo notturno = 25 929,1.** Hanno comprato **29 punti SOTTO il livello chiave**, cioè *dentro* il range notturno. Il mercato è sceso a prendere i minimi (il loro stop) e **poi** ha rotto 25 929 salendo oltre 26 000.

→ Direzione giusta, **livello sbagliato**. Sono i due EA già classificati "morti" (PF<1) e tenuti solo per osservazione: **terzo episodio a perdita** (29/07: −353 €; oggi: −167 €).

## 2. DAX — gli EA buoni entrano bene e vengono tagliati dal trailing

| Ticket | EA | Ingresso | Uscita | S/L | Durata | P&L |
|---|---|---|---|---|---|---|
| #2972841 | Apertura Marco | 25 932,50 | 25 944,80 | **25 944,80** | 39 s | +14,76 |
| #2972839 | DAX Apertura EU | 25 932,50 | 25 944,80 | **25 944,80** | 39 s | +14,76 |
| #2972840 | DAX Apertura EU OTT | 25 937,50 | 25 944,80 | **25 944,80** | 34 s | +3,65 |

L'S/L mostrato è **sopra il prezzo d'ingresso**: non è lo stop iniziale, è il **trailing** già spostato in profitto. Sono stati chiusi dal proprio trailing.

🔑 **Ingresso corretto**: 25 932,50 = **3 punti sopra la rottura del massimo notturno**. Esattamente dove il metodo dice di comprare — al contrario dei Live5m.

**Ma:** DAX da 25 932,50 a 26 015,9 = **+83 punti** (massimo di giornata ~26 037 = +105).
Su 2,9 lotti a 1 €/punto: **~241 € disponibili, 33,17 € presi. Il 14%.**

E il TP era a 26 210,60 → 278 punti: irraggiungibile. **Sbagliati entrambi gli estremi**: trailing troppo stretto per lasciar correre, TP troppo lontano per essere colpito.

## 3. Nasdaq — stesso schema, mercato diverso

| Ticket | EA | Ingresso | Uscita | Durata | P&L |
|---|---|---|---|---|---|
| #2978263 | Nasdaq Apertura US **SELL** | 28 259,10 | 28 222,53 | **3 min 14 s** | +28,53 |

Aperto alle **14:30:47 server = 15:30:47 Roma**, cioè all'apertura US. Direzione giusta: il Nasdaq ha chiuso a **−0,54%** rompendo al ribasso sia il **minimo notturno (28 414,9)** sia il **minimo del giorno precedente (28 436,0)**.

Movimento dopo le 15:30 ≈ **180 punti**. L'EA ne ha presi **36,6**. TP a 340 punti, mai avvicinato.

## 4. Nasdaq — l'ORB perde dove il gemello guadagna: A/B perfetto

**#2978260 — "ORB SELL"** · aperto 14:30:**45**, chiuso 14:35:37 (**4 min 52 s**)
28 265,60 → 28 320,70 · **S/L 28 320,70 = stop INIZIALE colpito** · T/P 28 106,80 · **−33,45**

Due EA, **stesso simbolo, stessa direzione, stesso secondo**:

| | **ORB SELL** | **Nasdaq Apertura US SELL** |
|---|---|---|
| Apertura | 14:30:**45** | 14:30:**47** |
| Ingresso | 28 265,60 (**migliore**: 6,5 pt più in alto) | 28 259,10 |
| Stop | 55 pt sopra, **mai spostato** | trailing portato in profitto |
| Uscita | stop iniziale | trailing |
| **Risultato** | **−33,45** | **+28,53** |

In 5 minuti il Nasdaq ha fatto **28 265 → ~28 220 → 28 320** (swing da 100 punti). L'Apertura US ha stretto il trailing sul minimo e ha incassato **+36 punti**; l'ORB era in profitto di ~45 punti nello stesso istante, **non ha mosso nulla**, e il rientro se l'è ripreso tutto più lo stop.

🔑 **Perché l'ORB non ha mosso lo stop:** è meccanico. Nell'`ABTG_ORB` il primo intervento (parziale + BE) scatta a **2R ≈ 110 punti**. Il movimento a favore è arrivato a ~45. **Non poteva scattare niente.**

## 5. Nasdaq — tre EA in conflitto sullo stesso simbolo

**#2978262 — "Nasdaq Apertura US OTT BUY"** · aperto 14:36:50 · **BUY** 28 372,00 · S/L 28 260,60 · T/P 28 706,20 · **−25,68** (ancora aperta)

| Ora | EA | Azione | Prezzo |
|---|---|---|---|
| 14:30:45 | ORB | **SELL** | 28 265,60 |
| 14:30:47 | Nasdaq Apertura US | **SELL** | 28 259,10 |
| 14:34:01 | Nasdaq Apertura US | esce col trailing | +28,53 |
| 14:35:37 | ORB | stoppato dal rimbalzo | −33,45 |
| **14:36:50** | **Nasdaq Apertura US OTT** | **BUY** | **28 372,00** |

L'Ottimizzato ha comprato **113 punti sopra** dove il gemello aveva venduto sei minuti prima, cioè **sul massimo del rimbalzo**. Il suo BUY STOP era più in alto ([INFERITO]: buffer/range diversi) e il rimbalzo l'ha attivato sull'estremo.

Non è un bug: nativo e Ottimizzato hanno **magic diversi e non si parlano**. Ognuno ha il suo `OneTradePerDay`, ma **a livello di famiglia non esiste coordinamento**. È il costo della regola "gli Ottimizzato girano in parallelo ai nativi" — finora teorico, oggi con un numero.

È lo stesso pattern diagnosticato il 29/07 (*"long stoppati poi short stoppati"*) e misurato dai backtest come **Nasdaq apertura PF 0,88**.

**Bilancio Nasdaq della sessione: +28,53 − 33,45 − 25,68 = −30,60.** Tre EA, stessa mezz'ora, direzioni opposte, netto negativo. Il conto è positivo (+74 €) grazie a **oro e CAC**, non al Nasdaq.

---

## 🔬 L'esperimento controllato che ne esce

Stesso giorno, stesso schema, **due gestioni diverse**:

| | **DAX** | **Nasdaq** |
|---|---|---|
| Trailing | `FIXED` **410 punti = 4,1 indice** | `PREVBAR` **base candela M1** |
| Durata in posizione | **39 secondi** | **3 min 14 s** |
| Movimento disponibile | ~83 punti | ~180 punti |
| Catturato | +12 punti | +36,6 punti |
| **Frazione del movimento** | **14%** | **20%** |

**Il Nasdaq ha tenuto 5 volte più a lungo, e usa il trailing meno stretto.** La variabile che cambia è una sola, e l'effetto è quello atteso.

> Il DAX quota con 2 decimali → **1 punto indice = 100 punti MT5**. Quindi `InpTrailFixedPts = 410` = **4,1 punti indice**, su un mercato la cui candela M5 all'apertura respira 20–40 punti. Non poteva sopravvivere.

Il valore 410 viene dal piano ABTG (*"sugli indici 410 punti = 4 punti indice"*) ed è a verbale nell'audit come regola **rispettata** ✅. Il piano lo dice, noi l'abbiamo implementato fedelmente — e all'apertura non regge 40 secondi.

**[INFERITO]** Due ipotesi, entrambe testabili: o è tarato per una fase più calma della giornata, o per un broker con scala di punti diversa (con 1 decimale, 410 punti = 41 punti indice, una distanza sensata).

## ✅ E l'indicatore 9/21 ha funzionato

Sul grafico Nasdaq il marker **DN** dell'`EMA 9/21 Cross + Volume Filter` compare **prima** della discesa e concorda con lo short dell'EA. Il segnale c'era ed era in tempo.

**Non abbiamo un problema di selezione: entriamo bene, confermiamo bene, e usciamo dopo tre minuti.**

---

## 🔀 Conseguenza sul piano di lavoro — ordine INVERTITO

Prima: ablazione → studio movimento → distanze.
**Adesso: studio movimento → distanze → ablazione/ORB.**

Le ore di backtest rendono di più partendo dalla gestione, perché quattro trade reali su due mercati dicono che l'ingresso già funziona e l'uscita no.

```powershell
# FASE A — misurare quanto "respira" il movimento (MAE/MFE/durata)
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/studio_apertura.ps1" | iex

# FASE B — poi, coi valori derivati dalla fase A
.\scan_gestione.ps1 -Robot ABTG_DAX_Apertura_EU    -Symbol D30EUR -SessionHour 8  -Fase distanze
.\scan_gestione.ps1 -Robot ABTG_Nasdaq_Apertura_US -Symbol NASUSD -SessionHour 14 -Fase distanze
```

## 🧾 Le tre lezioni di oggi, separate

| # | Lezione | Evidenza | Si risolve con |
|---|---|---|---|
| 1 | Trailing **troppo stretto** | DAX: +12 su +83 in 39 s | fase **distanze** |
| 2 | Prima gestione **troppo lontana** | ORB: +45 punti diventano −55 | fase **distanze** |
| 3 | **Troppa sovrapposizione** di EA | 3 EA sul Nasdaq, direzioni opposte, netto −30,60 | ⚠️ **decisione di flotta, non di parametri** |

I primi due sono un problema di taratura. Il terzo no: o si accetta che sul Nasdaq apertura girino tre EA che a volte si annullano, o se ne tiene **uno**. Considerato che il Nasdaq apertura nudo è a **PF 0,88** e l'ORB a **1,15 marginale**, tenerne tre attivi mentre non sappiamo ancora quale sia buono è difficile da giustificare.

## ⚠️ Azione consigliata sul VPS
Spegnere **`DAX_Live5m`** e **`DAX_Live5m_v2`**: erano già in lista, l'osservazione è costata **520 € in due episodi** e non produce informazione nuova — confermano solo ciò che il backtest dice da settimane.
_Decisione di Claudio (tenere tutto acceso fino alla quadra del mese): legittima, ma ora il prezzo dell'osservazione ha un numero._
