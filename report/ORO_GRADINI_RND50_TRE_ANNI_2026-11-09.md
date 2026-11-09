# The Gold Reaper a 80.000 EUR su 2013 / 2020 / 2025, DUE volte per anno: cosa dice lo zip `ANNO_ORO_GRADINI_RND50`

**Natura: LETTURA di uno zip di misura.** Materiale: `ANNO_ORO_GRADINI_RND50_20261109_0551.zip` (24 MB, 114 file, 6 corse), arrivato il 09/11/2026. Script di raccolta `MARCATORE_ANNO80K_WIM_TESTER_v1` (pin `f5fcea83`), che **raccoglie e dichiara di non giudicare**. Il giudizio e' questo documento.

🔴 **SCREENING, NON VERDETTO.** Tutte e sei le corse sono a **Modello 1** (barre / tick generati, **NON tick reali**) e con **`ExecutionMode=0`**, cioe' **nessun ritardo di esecuzione e nessuno slippage di latenza**. I costi qui sono **ottimistici per costruzione**. Regola di casa: i verdetti solo a tick reali.

## 1. Che cosa e' stato misurato

**The Gold Reaper MT5.ex5** — EA di **terzi** dal MQL5 Market, scatola nera, nessun sorgente. SHA256 `AB636AF9...F7E4`, **ricontrollato dopo ogni passata e sempre UGUALE** (il raccoglitore lo verifica: se il binario cambia, le passate dopo non partono).

XAUUSD **H1**, deposito **80.000 EUR** a conto vuoto, leva 1:100 del tester, qualita' storico **99-100%**. Preset `Gold_reaper_propfirm` con `Risk=1234`, `StartLots=0.01`, `UseWeightedLots=true`, `MaxAllowedDD=9.00`, `PropFirmMaxDailyDD=4.00`, `OnlyUp=false`, `TradeFrequency=2`, **tutte e nove le strategie accese** (`RunStrat1..9=true`), `EnableNFP_Filter=true`, e **`Randomization=50`**.

**Sei corse = due ripetizioni (R1, R2) x tre anni (2013, 2020, 2025)**, ognuna a conto vuoto e indipendente. 🔴 **I loro numeri NON si sommano: si confrontano** (lo dichiara il raccoglitore, ed e' la classe 1487 — gluare tranche indipendenti in una curva continua e' il difetto che ho pagato in ottobre).

⚠️ **E questo zip NON e' il test dei criteri congelati del 26/10** (`report/TRE_ANNI_PROP_80K_3EA_CRITERI_2026-10-26.md`), che chiedono **2013 SHORT, 2018 LATERALE, 2020 LONG** con il 2025 come **calibrazione**. Qui il **2018 LATERALE manca** e il 2025 e' un terzo anno. 👉 **Percio' NON dichiaro `PROP-ANNI`**: quel criterio richiede tutti e tre gli anni previsti, e cambiarne l'insieme dopo i numeri e' il difetto che la regola del 16/08 vieta per nome.

## 2. I numeri, tutti e sei

| | anno | n | netto | PF | win% | vinc. media | perd. media | rapporto | serve | **scarto** |
|---|---|---|---|---|---|---|---|---|---|---|
| R1 | 2013 | 601 | +13.070,90 | 1,29 | 66,22% | 145,16 | 218,36 | 0,66:1 | 60,07% | **+6,15** |
| R2 | 2013 | 639 | +21.779,99 | 1,47 | 66,35% | 160,51 | 213,31 | 0,75:1 | 57,06% | **+9,29** |
| R1 | 2020 | 591 | +22.487,49 | 1,74 | 67,34% | 133,11 | 156,42 | 0,85:1 | 54,03% | **+13,31** |
| R2 | 2020 | 573 | +25.442,23 | 1,88 | 66,84% | 141,95 | 150,69 | 0,94:1 | 51,49% | **+15,35** |
| R1 | 2025 | 599 | +33.592,95 | 2,72 | 71,95% | 123,30 | 115,42 | 1,07:1 | 48,35% | **+23,60** |
| R2 | 2025 | 621 | +33.743,52 | 2,63 | 73,27% | 119,79 | 124,06 | 0,97:1 | 50,88% | **+22,39** |

_Convenzione dichiarata: `rapporto = vincita media / perdita media`, `serve = 1/(1+rapporto)`, `scarto = win% ottenuto − win% necessario` (la stessa delle pagelle di novembre)._

🟢 **Sei corse su sei in utile, e lo scarto e' POSITIVO in tutte e sei: da +6,15 a +23,60.** Per confronto, misurato sul nostro campo: famiglia **Bulge −4,84** su n=291, `MAXMIN ORO` **+15,0** su n=18, `DAX Apertura RETEST` **+36,6** su n=21. 👉 **Questo motore sta nella fascia alta di quello che abbiamo in casa, e con n≈600 per corsa invece di 20.**

🟢 **Frequenza: ~600 operazioni l'anno = circa 2,4 al giorno.** Il pavimento di casa e' **1,00 op/giorno per famiglia** (firmato il 07/09): lo supera di due volte e mezzo **da solo**. Dall'08/09 la frequenza e' il requisito principale, e qui non e' un problema.

## 3. 🔴 LA COSA PIU' IMPORTANTE NON E' IL PROFITTO: E' LO SCARTO FRA LE DUE RIPETIZIONI

Stesso EA, stesso preset, stesso anno, stesso deposito. **L'unica differenza e' `Randomization=50`.**

| anno | netto R1 | netto R2 | scarto | in % del minore |
|---|---|---|---|---|
| **2013** | +13.070,90 | +21.779,99 | 🔴 **+8.709,09** | 🔴 **+67%** |
| 2020 | +22.487,49 | +25.442,23 | +2.954,74 | +13% |
| 2025 | +33.592,95 | +33.743,52 | +150,57 | +0,4% |

🔴 **Nel 2013 due corse identiche danno 13.071 e 21.780.** E non cambia solo il profitto: cambiano il **DD** (7.767,18 contro 8.321,66) e la **striscia peggiore di perdite** (30 contro 36).

👉 **Conseguenza, e vale come criterio d'acquisto:** **una singola corsa di questo EA non e' una misura.** Qualunque numero mostrato dal venditore — e qualunque nostro, incluse le corse a 80K gia' in repo — e' **una estrazione**, non il valore. Per misurarlo servono N corse, e **N=2 non basta**: con due punti non si stima ne' una media ne' una dispersione.

🔴 **E il verso della variabilita' e' quello sbagliato: e' massima nell'anno piu' difficile.** Nel 2025 (anno facile) le due corse coincidono allo 0,4%; nel 2013 (l'anno in cui l'oro ha perso il 28%) divergono del 67%. **Cioe': proprio nell'anno in cui ci serve sapere cosa fa, l'EA risponde con un'incertezza del 67%.**

## 4. 🔴 IL MURO FTMO: cinque corse su sei non lo possono nemmeno toccare, una si'

Il muro statico FTMO e' **l'equita' che non scende sotto il 90% del saldo iniziale** = **72.000 EUR** su 80.000 (`docs/REGOLAMENTO_FTMO_2026-09-20.md` r.59; il Guardian misura `totalPct` sul saldo di partenza in **tutte e due** le modalita', `ABTG_Guardian.mq5` r.739-745).

🔴 **E qui il DD del report NON risponde alla domanda, per due ragioni diverse.** (a) La percentuale e' relativa al **PICCO** di equita', non al deposito (**classe 1488**): infatti R2/2013 ha **piu'** DD in euro di R1/2013 (8.321,66 contro 7.767,18) e **meno** in percentuale (7,56% contro 7,70%), perche' aveva guadagnato di piu' e il picco era piu' alto. (b) Il **drawdown massimale** e' un calo picco-fondo, **non** "l'equita' e' scesa sotto la linea di partenza": sono due cose diverse, e confonderle e' l'errore che ho fatto nella prima stesura di questa lettura.

Il conto che risponde davvero:

| | anno | DD max EUR | % del report | **pavimento certo** | fondo ricostruito | esito sul muro 72.000 |
|---|---|---|---|---|---|---|
| R1 | 2013 | 7.767,18 | 7,70% | 72.233 | 93.105 | 🟢 **non sfondabile** |
| **R2** | **2013** | **8.321,66** | 7,56% | 🔴 **71.678** | 101.753 | 🟠 **POSSIBILE, NON dimostrato** |
| R1 | 2020 | 4.855,08 | 4,75% | 75.145 | 97.357 | 🟢 non sfondabile |
| R2 | 2020 | 5.124,47 | 4,96% | 74.876 | 98.191 | 🟢 non sfondabile |
| R1 | 2025 | 4.675,85 | 5,58% | 75.324 | 79.121 | 🟢 non sfondabile |
| R2 | 2025 | 3.603,74 | 4,34% | 76.396 | 79.432 | 🟢 non sfondabile |

- **PAVIMENTO CERTO = 80.000 − DD massimale.** Nessun calo singolo puo' superare il drawdown massimale, quindi **l'equita' non puo' essere scesa sotto questo valore, qualunque sia la storia**. E' un limite inferiore **dimostrato**, non stimato.
- **PICCO ricostruito = DD_eur / DD_%** (la % e' relativa al picco), **FONDO = picco − DD**: dove stava l'equita' nel punto peggiore **di quel** calo.

🟢 **Quindi: in cinque corse su sei il muro FTMO non e' raggiungibile nemmeno in teoria.** 🟠 **In R2/2013 il pavimento cade sotto 72.000 di 321,66 euro**: lo sfondamento e' **POSSIBILE** e **NON dimostrato** — se il calo massimale e' quello avvenuto dal picco di 110.075, il muro non e' stato sfiorato, e il riepilogo non dice **quando** e' avvenuto. Per chiuderlo serve la **curva di equita'**, che in questo zip non c'e'.

📌 **E la cosa va detta anche al contrario, perche' riguarda NOI**: il criterio congelato del 26/10 dice *«DD equity assoluto ≤ 8.000 EUR»*, e con quel criterio **R2/2013 e' bocciata**. Ma FTMO, sulla stessa corsa, **molto probabilmente non avrebbe chiuso il conto**. 👉 **Il nostro criterio e' piu' severo del muro che vuole proteggere**, e su una corsa in utile li' la differenza e' grossa: e' una cosa da sapere **prima** di bocciare un candidato con quel numero.

## 5. 🔴 IL RISCHIO VERO NON E' IL DD MASSIMALE: SONO LE STRISCE E IL MARGINE

| | anno | Z-Score | perdite consecutive (peggiore) | **livello di margine** | Sharpe |
|---|---|---|---|---|---|
| R1 | 2013 | **−15,00** | **30 (−4.046,78)** | 🔴 **112,69%** | 2,72 |
| R2 | 2013 | **−15,50** | 🔴 **36 (−4.410,22)** | 🔴 **119,55%** | 4,37 |
| R1 | 2020 | −13,43 | 15 (−1.203,57) | 242,84% | 4,84 |
| R2 | 2020 | −12,78 | 12 (−1.029,75) | 246,18% | 5,52 |
| R1 | 2025 | −12,70 | 13 (−2.344,00) | 343,98% | 7,72 |
| R2 | 2025 | −13,00 | 8 (−1.386,25) | 336,65% | 8,10 |

🔴 **Z-Score da −12,70 a −15,50, tutti con significativita' sopra il 99%.** Uno Z negativo e grande vuol dire che vincite e perdite sono **raggruppate molto piu' di quanto farebbe il caso**: le strisce **sono una proprieta' del motore**, non sfortuna. E il dato lo conferma: **36 perdite di fila** nel 2013.

🔴 **E il numero che mi preoccupa piu' di tutti e' il LIVELLO DI MARGINE: 112,69% e 119,55% nel 2013**, contro 242-344% negli altri anni. Un livello di margine del 112,69% e' a **dodici punti** dalla chiamata di margine. 👉 **"Nessuno stop out in sei corse" e "margine al 112,69%" sono la STESSA corsa**: lo stop out non e' scattato, ma il 2013 e' stato corso **vicino al bordo**, con `CheckMargin=true` acceso. ⚠️ Che cosa sia esattamente il "livello di margine" stampato dal report (minimo raggiunto, o finale) e' **[NON VERIFICATO]**: lo riporto come lo stampa il report.

✅ **E il lato corto e' sempre il migliore, in tutti e tre gli anni**: short vincenti **73,87-75,88%** contro long **55,86-72,60%**, anche nel 2020 e nel 2025 che sono anni di oro **in salita**. 🟢 Non e' quindi un semplice adattamento alla direzione dell'anno: e' un vantaggio che resta col segno del mercato rovesciato. E' il risultato piu' incoraggiante dello zip dopo gli scarti.

## 6. 🔴 IL DIFETTO MECCANICO CHE HO TROVATO, E CHE CONOSCIAMO BENE: L'ORA

Il preset porta **`AutoGMT=true`** con ripiego **`Broker_GMT_OFFSET_Winter=2`** e **`Broker_GMT_OFFSET_Summer=3`**. E nei giornali di **tutte e sei** le corse compare, ripetuto:

`Error when reading GMT URL. Error code = 4014`

👉 Nel tester la lettura del GMT **non funziona** (niente rete), quindi l'EA **usa i due numeri fissi del preset**. E su BCM quei due numeri sono **sbagliati**: BCM e' **UTC+1 FISSO, senza ora legale** (misurato su ~24.400 deal, `report/OROLOGIO_BCM_2026-09-24.md`), quindi l'offset giusto e' **1 d'inverno e 1 d'estate**, non 2 e 3.

🔴 **Cioe': con questo preset su BCM l'EA sbaglierebbe l'ora di un'ora d'inverno e di DUE d'estate** — ed e' **esattamente la classe di difetto che la settimana scorsa ci e' costata la finestra delle tre sedie USA.** E non e' cosmetico: `EnableNFP_Filter=true` con `NFP_MinutesBefore=100` / `After=60` **colloca una finestra di 160 minuti intorno a un'ora**, e se l'ora e' spostata la finestra protegge il momento sbagliato.

⚠️ **Due riserve, e vanno lette insieme al difetto:** (a) in **live** `AutoGMT` potrebbe funzionare (basta che l'URL sia fra quelli permessi nel terminale), quindi **nel tester il ripiego e' certo, in campo e' [NON MISURATO]**; (b) i conteggi degli errori che si vedono nei referti sono presi su un **campione troncato alle prime 15 righe di giornale** citate dal raccoglitore: **non sono totali**, e non li uso come tali.

📌 Compaiono anche **`'unknown error 4753' when modifying stoploss`** (da 0 a 7 righe per corsa, **nello stesso campione troncato**): l'EA prova a spostare uno stop e il tester rifiuta. Con un trailing attivo (`UseHL_TrailingSL=true`) e' un rumore atteso del tester, **ma e' anche il punto dove un'uscita puo' non avvenire**: `[NON MISURATO]` quanto costi.

## 7. ✅ I CONTRO-ESEMPI, costruiti prima di consegnare

**A. _«Lo scarto positivo in tutti e sei gli anni dimostra che l'EA ha un edge.»_**
Provato a rompere: lo scarto nasce da **medie** di un Modello 1 **senza slippage e senza ritardo**. Con costi veri la perdita media sale e la vincita media scende, e il `serve` si alza. Il 2013 e' la riga piu' fragile: **rapporto 0,66:1 che chiede il 60,07%** con uno scarto di **+6,15**. Un peggioramento del 10% sul rapporto delle medie porta il `serve` oltre il **62%** e si mangia **un terzo** dello scarto 2013. 👉 **L'edge regge il contro-esempio nel 2020 e nel 2025; nel 2013 e' sottile, ed e' l'anno che conta per il rischio.** La prova che lo chiude e' una corsa **con costi** (la classifica dei costi di casa), non piu' Modello 1.

**B. _«Il 2025 e' il miglior anno, quindi l'EA e' migliorato.»_**
🔴 **Non e' un'inferenza che questi dati permettono.** La monotonia **2013 (+6,15) < 2020 (+13,31) < 2025 (+23,60)** e' **esattamente la forma attesa da un motore adattato ai dati recenti** — ed e' un EA messo in vendita nel 2026. Dai soli tre anni, *"migliorato"* e *"adattato al recente"* **non si distinguono**. E il 2025 e' l'anno con lo scarto fra ripetizioni **piu' piccolo** (0,4%), cioe' quello in cui la randomizzazione **non** sposta niente: un motore che nel suo anno migliore e' anche il meno sensibile al caso e' coerente con tutte e due le spiegazioni.

**C. _«Nessuno stop out in sei corse, quindi reggerebbe una prop.»_**
Falso come conclusione: lo stop out del tester scatta sul **margine**, e il livello di margine del 2013 e' **112,69%**. 👉 *"Nessuno stop out"* e *"a dodici punti dalla chiamata di margine"* sono **la stessa corsa**. E il muro FTMO non e' lo stop out del broker: e' il **−10% sull'equita'**, che in R2/2013 non si puo' escludere (§4).

**D. _«Il DD e' sotto il 10% in tutte le corse, quindi FTMO e' passata.»_**
🔴 Confonde due numeri. Le percentuali del report (4,34-7,70%) sono **relative al picco**, non al deposito: lette sul deposito diventano **4,50-10,40%**, e **R2/2013 passa il 10%**. Ma nessuna delle due e' la regola FTMO, che guarda **l'equita' contro il 90% del saldo iniziale** — e quella si decide col **pavimento** del §4, non col DD.

## 8. Che cosa questo zip NON dice

- 🔴 **Non e' un verdetto**: Modello 1, nessuno slippage, nessun ritardo. **Lo dice la regola di casa e lo ripeto qui.**
- 🔴 **Non autorizza nessuna spesa.** Il pacchetto da ~1.500 EUR resta una **decisione di Claudio** (spendere soldi e' una sua firma): questo documento misura, non consiglia un acquisto.
- 🔴 **Non e' `PROP-ANNI`**: manca il **2018 LATERALE** previsto dai criteri del 26/10, e il criterio non si riscrive dopo i numeri. Per dichiararlo serve quella corsa.
- 🔴 **Il criterio dei giorni** (nessun giorno con perdita realizzata ≥ 5% del saldo a inizio giorno, giorno FTMO a mezzanotte CE(S)T) **non l'ho misurato**: serve la lista delle operazioni giorno per giorno, e il lettore congelato (`leggi_giorni_dd_prop.py`) legge le corse dell'**archivio**, non questo zip. **[NON MISURATO]**, ed e' una delle quattro condizioni di `PROP-ANNI`.
- 🔴 **La curva di equita' non c'e'**, quindi il minimo vero dell'equita' resta ignoto e R2/2013 resta aperta.
- ⚠️ **Nessun input e' stato IMPOSTO dal `.ini`** (`input imposti: 0`): valgono quelli che il tester aveva salvato per questo EA su questo PC. Il report li stampa tutti, quindi **si sa quali sono** — ma **non** si sa che fossero scelti, e la riproducibilita' su un altro PC non e' garantita.
- ⚠️ **Due ripetizioni non sono una distribuzione.** Tutto quello che dico sulla variabilita' da randomizzazione e' **un'indicazione di ampiezza su n=2**, non una stima.

## 9. 👉 Che cosa farei adesso, in ordine, e che cosa serve una firma

1. 🔬 **Ripetere l'anno 2013 altre volte** (la randomizzazione e' il fattore dominante, e il 2013 e' dove morde). Con **R=6-8** estrazioni sullo stesso anno si misura **l'ampiezza** invece di indovinarla, e si risponde alla sola domanda che decide: **quante estrazioni su otto sfondano il pavimento di 72.000?** E' la via piu' corta al numero, e gira sul **PC di backtest**.
2. 📅 **Aggiungere il 2018 LATERALE**, che e' l'anno previsto dai criteri congelati e l'unico che manca per poter dire `PROP-ANNI`. (Nei nove EA letti in ottobre, l'anno peggiore era il laterale in **sette** casi: e' la riga che probabilmente morde.)
3. 💶 **Rifare la riga migliore con i COSTI**, perche' il contro-esempio A e' aperto proprio sul 2013.
4. 🕒 **Chiedere al venditore due cose precise**: (a) `AutoGMT` funziona in live su un broker **senza ora legale**, e con che URL; (b) a quale offset va messo `Broker_GMT_OFFSET_Winter`/`Summer` su un server **UTC+1 fisso**. 🔴 E questa domanda serve **anche** per i tre EA del pacchetto che Claudio sta valutando.
5. ✋ **Resta di Claudio**: la spesa, le taglie, il conto reale. E **se** questo EA andasse in campo, il preset va riletto riga per riga sull'orologio **prima** di attaccarlo — la settimana scorsa un'ora sbagliata ci e' costata tre sedie.
