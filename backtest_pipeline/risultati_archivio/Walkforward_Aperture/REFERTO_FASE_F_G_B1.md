# FASE F + G (B1) — il candidato con la gestione ACCESA

06/08/2026 · `walkforward_aperture.ps1 -SoloGestione -Rifai` · **36 pass** a tick reali
Candidato: **RETEST · range 35 · buffer 500 · offset 200 · volumi OFF**
Portati ai valori accesi anche `InpMinStopPts` (0, non 500) e `InpSkipIfTight` (true, non false).

**La domanda di B1:** tutti i numeri delle fasi A–E sono a rischio 1% con TP 1,5R, senza parziale
e senza breakeven. L'EA sul VPS fa TP 3R, chiude il 50% al primo obiettivo e mette lo stop in
pari. Sono due sistemi diversi: **il verdetto regge sulla configurazione vera, o crolla?**

---

## Il controllo dichiarato prima del test: passato

Avevo scritto, prima di lanciare, che con `InpTP1_ClosePct = 0` il flag breakeven non puo' fare
niente (riga 1518: il blocco della parziale gira solo se la percentuale e' > 0, e il breakeven sta
dentro quel blocco), quindi **due coppie di righe dovevano venire identiche**.

| finestra | TP 1,5R parz 0: BE off / BE on | TP 3R parz 0: BE off / BE on |
|---|---|---|
| DAX IS | +469.97 / +469.97 ✅ | −35.79 / −35.79 ✅ |
| DAX OOS | +834.12 / +834.12 ✅ | +1492.38 / +1492.38 ✅ |
| NASDAQ IS | −630.79 / −630.79 ✅ | −378.19 / −378.19 ✅ |
| NASDAQ OOS | −137.89 / −137.89 ✅ | +125.86 / +125.86 ✅ |

Otto coppie su otto identiche come previsto, **e nessun'altra coppia identica**. Il codice fa
quello che si legge.

---

## FASE F — DAX (rischio 1%, per essere confrontabile con tutto il resto)

| gestione | IS | PF | n | **OOS** | **PF** | n | DD OOS |
|---|---:|---:|---:|---:|---:|---:|---:|
| TP 1,5R secco *(quella dei test A–E)* | +469.97 | 1.114 | 170 | +834.12 | 1.164 | 230 | 11.65% |
| TP 1,5R + parziale 50% | −23.42 | 0.994 | 255 | +667.50 | 1.138 | 359 | 10.39% |
| TP 1,5R + parziale + BE | −62.62 | 0.984 | 255 | +679.49 | 1.147 | 359 | 10.12% |
| TP 3R secco | −35.79 | 0.991 | 170 | **+1492.38** | **1.286** | 230 | 11.45% |
| TP 3R + parziale 50% | +17.14 | 1.004 | 224 | +1145.58 | 1.225 | 316 | 10.49% |
| **TP 3R + parziale + BE — LA CONFIGURAZIONE ACCESA** | −9.02 | 0.998 | 224 | **+1198.79** | **1.237** | 316 | **10.49%** |

### La risposta a B1: il verdetto non crolla. Migliora.

Fuori campione la gestione accesa fa **+1198.79 con PF 1.237 e DD 10.49%**, contro il +834.12
(PF 1.164, DD 11.65%) della gestione usata nei test. **Piu' profitto, PF piu' alto, drawdown piu'
basso.** E' l'opposto di quello che temevo quando ho aperto B1.

**Tutte e sei le gestioni sono positive fuori campione.** Il candidato non dipende da come lo si
gestisce: la geometria d'ingresso regge da sola, e la gestione la migliora.

### ⚠️ Tre cose da non farsi raccontare male

1. **In campione la gestione accesa e' la peggiore** (−9.02 contro +469.97). IS e OOS si
   contraddicono di nuovo, come su ogni asse che abbiamo misurato. Il campione **non ordina**.
2. **Il numero di trade e' gonfiato dalle parziali.** MT5 conta ogni chiusura: passando da secco a
   parziale i "trade" salgono da 230 a 316. Non sono 316 operazioni, sono **230 posizioni di cui 86
   (il 37%) hanno toccato 1R** e hanno prodotto una seconda chiusura. Con TP 1,5R la percentuale
   sale al 56%. *(Vale la voce B5: la soglia di significativita' va applicata alle posizioni.)*
3. **NON si sceglie "TP 3R secco" perche' e' la cella migliore fuori campione** (+1492.38). Sarebbe
   esattamente la trappola che ci siamo imposti di evitare. La configurazione accesa non l'abbiamo
   scelta noi: era gia' decisa dal piano, e qui l'abbiamo solo **misurata**. Quella misura e'
   pulita. Sceglierne un'altra guardando l'OOS non lo sarebbe.

### Controllo di coerenza con la FASE E

Stessa geometria, stessa gestione ("TP 1,5R secco"), cambia solo il floor di stop:

| | profitto | trade |
|---|---:|---:|
| FASE E (FULL) — `MinStopPts` 500, `SkipIfTight` off | +1364.89 | 401 |
| FASE F (IS+OOS) — `MinStopPts` 0, `SkipIfTight` on | +1304.09 | 400 |
| differenza = effetto del floor | **−60.80** | −1 |

Le due misure combaciano entro il 4%. Il floor di stop a 500 punti valeva ~61 € su 22 mesi:
trascurabile, ed e' un'altra delle sei divergenze dell'audit che si chiude.

---

## FASE F — NASDAQ (controllo, non fedelta')

| gestione | IS | OOS | somma |
|---|---:|---:|---:|
| TP 1,5R secco | −630.79 | −137.89 | −768.68 |
| TP 1,5R + parziale | −336.57 | +27.02 | −309.55 |
| TP 1,5R + parziale + BE | −275.96 | +19.61 | −256.35 |
| TP 3R secco | −378.19 | +125.86 | −252.33 |
| TP 3R + parziale | −193.55 | −20.79 | −214.34 |
| TP 3R + parziale + BE *(accesa)* | −261.87 | +107.19 | −154.68 |

La gestione accesa **migliora** il Nasdaq — da −768.68 a −154.68 — ma non lo salva: resta negativo
in ogni riga sommando le due finestre, e in campione e' negativo in tutte e sei. Nessun ribaltone.

*(Promemoria: qui il Nasdaq gira in `RangeMode=0` e chiude alle 17:30, mentre l'EA acceso usa la
candela H1 precedente e chiude alle 21:45. Questa non e' una misura di fedelta' sul Nasdaq: quella
e' C6.)*

---

## FASE G — quanto costa DAVVERO il 2%

Gestione accesa, periodo intero, deposito 10.000 €.

### DAX

| rischio | profitto | PF | DD | Sharpe |
|---|---:|---:|---:|---:|
| 1,0% | +1198.73 | 1.132 | **10.49%** | 4.57 |
| **2,0%** | **+2435.73** | 1.126 | **20.40%** | 4.33 |

**Profitto ×2.03, drawdown ×1.95.** Il raddoppio e' pulito: quasi lineare, con il DD che cresce
appena meno del profitto.

**Correggo una mia stima.** Ieri avevo scritto *"il DD 11,8% diventa circa il 24%"*. Il numero
vero e' **20,40%**, e la mia stima era sbagliata perche' partivo dall'11,83% della FASE E, che
aveva il floor di stop diverso. La regola del ×2 invece funziona: e' la base che avevo preso male.

Tradotto in resa, su un conto da 10.000 €:

| rischio | all'anno | DD | resa/DD |
|---|---:|---:|---:|
| 1% | +681,74 (**6,8%**) | 10,49% | 0,65 |
| 2% | +1385,25 (**13,9%**) | 20,40% | 0,68 |

**Il rapporto resa/drawdown non cambia col rischio** (0,65 contro 0,68): raddoppiare la size non
migliora la qualita' del sistema, ne raddoppia solo la scala. La scelta del 2% e' una scelta di
quanto dolore si accetta, non di quanto e' buono l'EA.

### NASDAQ

| rischio | profitto | PF | DD |
|---|---:|---:|---:|
| 1,0% | −146.02 | 0.982 | 13.11% |
| 2,0% | −385.08 | 0.977 | **24,50%** |

Negativo, e al 2% con quasi un quarto del conto di drawdown. **Da spegnere.**

---

## Dove siamo

| cancello | esito |
|---|---|
| 1 · fuori campione | ✅ 8/8 celle positive nella zona 35–45, su due motori diversi |
| 2 · robustezza di vicinato | ✅ breakout e retest, stesso segno in 18 celle su 20 |
| 3 · costo / realismo | ✅ il retest perde il 3,9% dei riempimenti e resta positivo |
| 4 · **gestione vera** | ✅ **la configurazione accesa fa PF 1.237 e DD 10,49% fuori campione** |
| 5 · forward | ❌ mai fatto — ed e' l'unico che resta |

**Il DAX ha passato quattro cancelli su cinque.** Non e' piu' "un numero che ho trovato": e' una
configurazione che regge fuori campione, con due motori diversi, sotto ipotesi pessimistiche sui
riempimenti, e con la gestione che gira davvero.

### Cosa NON dice questo test

- **Non dice che l'EA acceso oggi guadagna.** L'EA acceso ha `RangeMinutes=15` e `Buffer=200`
  (zona che fuori campione perde) e usa il **BREAKOUT**, non il retest. La configurazione promossa
  e' un'altra: bisogna cambiargliela.
- **Non copre le altre divergenze dell'audit** oltre a gestione e floor di stop.
- **Non e' un forward.** Tutti questi numeri vengono dallo stesso periodo, guardato tante volte.

### Il passo successivo, e va deciso da Claudio

Portare `ABTG_DAX_Apertura_EU` a: **`InpEntryMode=2` (retest) · `InpRangeMinutes=35` ·
`InpBufferPoints=500` · `InpRetestOffsetPts=200`**, lasciando la gestione com'e'.
Sono quattro parametri, e sono la differenza fra quello che gira e quello che e' stato validato.

Prima pero' vanno chiuse due cose che con questo test non c'entrano ma sono soldi:
**A1** (Marco fa lo stesso trade → 4% su un segnale solo) e **A4** (la guardia del trade
giornaliero non sopravvive al riavvio).
