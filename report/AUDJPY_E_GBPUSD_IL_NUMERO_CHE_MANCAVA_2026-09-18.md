# 📏 AUDJPY E GBPUSD: IL NUMERO C'ERA GIA' — E ANCHE IL VERDETTO

> # 🔴 CORREZIONE IN TESTA, 18/09 ore 08:5x — **IL TITOLO ORIGINALE DI QUESTO REFERTO ERA FALSO, E IL TITOLO ERA MIO**
>
> Diceva *«da cinque giorni»*, e sotto: *«letti oggi, 18/09. Cinque giorni.»*
> **Non è vero.** `report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` (commit `7aaa9526`,
> **13/09 ore 23:32 +0200**, cioè **25 minuti dopo** che i CSV erano stati committati)
> alle **righe 116-117** porta già gli stessi numeri e gli stessi verdetti:
> *«r139a → **FAIL S3 (rischio)**, DD > 14,0% su tutte le celle in entrambe le
> finestre»* e *«r139b → **FAIL S3 + S4**, segno opposto su 4 celle su 4 = REGIME,
> non edge»*. 👉 **È parola per parola la conclusione che questo referto presenta
> come nuova.** Verificato da me aprendo il file, dopo che l'audit dei 48 round me
> l'ha contestato.
>
> 🔴 **E l'ironia va scritta, perché è la lezione**: il referto apriva denunciando
> la **classe 411** (*«prima di ordinare una misura, si cerca se esiste già»*) e
> **commetteva la stessa classe nella stessa riga**. Ho cercato i CSV e il registro.
> **Non ho cercato i referti.**
>
> **Che cosa mancava DAVVERO, ed è un difetto vero lo stesso**: in `REGISTRO_TEST.md`
> non c'è nessuna riga di risultato per R139a/R139b — né per gli altri 46 round.
> **Il verdetto esisteva; l'INDICE no.** Chi cerca dove si cerca non lo trova.
>
> **Che cosa resta valido di questo referto, e non è poco:**
> 🟢 **è una RIPRODUZIONE INDIPENDENTE** — due letture a cinque giorni di distanza,
> partite da CSV e non l'una dall'altra, stessi numeri e stessi verdetti;
> 🟢 l'**aritmetica del regime** (§6), la **frequenza in posizioni** (§7) e il
> **§12 su EURUSD** sono **nuovi**: la lettura del 13/09 non nomina EURUSD **nemmeno
> una volta** (0 occorrenze, verificato) e non contiene il costo H4 di 41,7×.
> 🔴 È **falsa** solo la rivendicazione di primato, e con lei il §11 punto 1 e ogni
> «sono stati letti oggi».

---

**18/09/2026** · risposta a *«MISURA AUDJPY E GBPUSD»* · round `R139a` / `R139b`

---

## 🥇 LA RISPOSTA IN UNA RIGA

> ### 🔴 **Nessuno dei due è schierabile. AUDJPY è MORTO con certificato completo (muore su DUE cancelli indipendenti in ENTRAMBE le finestre). GBPUSD non muore ma non passa: `S4` — «REGIME, non edge», IS negativo 4/4 e OOS positivo 4/4. 🟢 E la notizia buona è dentro la brutta: l'OOS di GBPUSD è il profilo fuori campione più LUNGO e più LARGO che `EMA200` abbia mostrato sul forex — PF 1,127-1,139 su 705-721 POSIZIONI, DD 10,0-11,0% a rischio 1,0% (= 6,5-7,2% alla taglia di flotta), su 9,8 anni. ⚠️ NON il più ALTO: `EURUSD` H1 arriva a PF 1,224 con DD 9,05%, e il §12 dice perché quella è la notizia più importante di tutto il documento.**

E la cosa che brucia di più: **i quattro CSV sono nel repo dal 13/09 alle 23:05.**
⚠️ **E letti già il 13/09 alle 23:32** — vedi la correzione in testa: il verdetto
c'era, in `LETTURA_BACKLOG_NOTTE_2026-09-13.md` rr.116-117. In `REGISTRO_TEST.md`
però **non esiste nessuna riga di risultato** per R139a/R139b: l'ultima che li nomina è **r.2616-2622**, che
li dà come *file prova pronti, cancello deterministico passato*.
⚠️ **E il «NON ANCORA MISURATO» di r.2614 NON è loro**: è il verdetto su
`FiboH4` GBPUSD (**R139c**), un altro candidato, quattro righe sopra.
🔴 **Correzione alla prima stesura di questo stesso referto, che citava r.2614-2618
come se parlasse di R139a/b: la riga esisteva, la frase pure, il SOGGETTO no.**
👉 **Classe 411 di nuovo, e per la terza volta in due giorni: prima di ordinare
una misura, si cerca se esiste già.**

---

## 1. 🔎 DA DOVE VENGONO QUESTI NUMERI

| cosa | dove | stato |
|---|---|---|
| file prova | `backtest_pipeline/prove/R139a_EMA200_AUDJPY_H4_LS.txt` · `R139b_EMA200_GBPUSD_H4_LS.txt` | scritti **12/09**, criteri congelati PRIMA dei numeri |
| risultati | `backtest_pipeline/risultati_prove/dal_vps/ABTG_EMA200/ABTG_EMA200_{AUDJPY,GBPUSD}_{IS,OOS}_ohlc_r139{a,b}.csv` | arrivati **13/09 23:05** (commit `cb96a6b1`, `91bdfd60`) |
| conteggio posizioni | `coda/referti/CODA_12_pertrade_posizioni_20260917_033003.log` | **[MISURATO]** il 17/09 |
| banco | Modello **1** (OHLC M1) = **SCREENING**, deposito 10.000, rischio **1,0%**, FrazioneIS di fabbrica | dichiarato nel file prova |
| finestra | `@DAQUANDO 2010.01.01` → `@FINOA 2026.06.30` (**16,5 anni**) | ✅ **verificata**, vedi §2 |

**Pin verificato colonna per colonna** contro il file prova: `InpMagic` 771560/771561,
`InpTF` 16388 (H4), `InpAllowLong=1 InpAllowShort=1`, `InpOrder1Atr` 0,25,
`InpOrder2Atr` 0,50 (AUDJPY) / 0,40 (GBPUSD), `InpRiskPercent` 1, `InpSLatr` 1,
asse `InpTP_RR` sui quattro valori 1,5 / 2,0 / 2,5 / 3,0. **Tutto combacia.**

---

## 2. ✅ IL BUCO PIÙ GRANDE DI R139a SI CHIUDE DA SOLO

R139a dichiarava: *«PAVIMENTO STORICO DI AUDJPY: **[INFERITO]**. R102 ha MISURATO il
1999.01.04 su SEI simboli e AUDJPY NON E' FRA QUELLI... se il referto stampa una
prima operazione molto dopo il 2010, il numero di questo round è su una finestra
più corta di quella dichiarata e va riletto.»*

Il per-trade del 17/09 stampa le date vere:

| simbolo | prima chiusura OOS | ultima chiusura | deal | **posizioni** | rapporto |
|---|---|---|---|---|---|
| AUDJPY `771560` | **2016.08.10** 01:13:40 | 2026.06.22 15:09:40 | 1345 | **730** | 1,8425 |
| GBPUSD `771561` | **2016.08.24** 15:05:40 | 2026.06.17 07:00:40 | 1316 | **718** | 1,8329 |

L'OOS parte ad **agosto 2016**. Con FrazioneIS 0,40 su 16,5 anni l'IS è
**2010.01 → 2016.08 = 6,6 anni** — e 6,6 / 16,5 = **0,40 esatto**.

> ### 🔴 **E QUI IL CONTRO-ESEMPIO SMONTA LA PRIMA LETTURA: quella coincidenza NON PROVA NIENTE.**

MT5 ricava la data di forward **dal RANGE DICHIARATO** (`FromDate`/`ToDate` ×
frazione), **non dai dati che esistono**: uscirebbe **2016.08 identica** anche se le
barre di AUDJPY partissero dal 2013. L'osservazione ha la **stessa uscita** sotto
l'ipotesi buona e sotto quella cattiva — è la classe 178 applicata a una data
invece che a una banda.

👉 **L'unica evidenza vera è il TASSO**: IS 767 deal / 6,6 anni = **116/anno**
contro OOS 1322 / 9,9 anni = **133/anno**. Un IS troncato avrebbe un tasso **più
ALTO** (se i dati partissero dal 2013, i 767 deal starebbero in 3,6 anni utili =
**213/anno**). ➡️ **Quindi si esclude un buco GROSSO, non uno piccolo**: dati da
fine 2010 darebbero 132/anno, **indistinguibile** da 133.

🟠 **Conclusione onesta: il pavimento storico di AUDJPY resta [INFERITO].** Ciò
che questo round aggiunge, e che prima non c'era, è un **limite MISURATO: nessun
buco di dati superiore a ~10 mesi.**

⚠️ **Correzione a R139a/R139b, e va detta**: il rapporto deal/posizione usato nei
due file prova era **2,0117** (preso da un altro round). Quello **misurato qui** è
**1,8425 / 1,8329**. Le stime di posizioni di quei file erano quindi **pessimiste
dell'8,4% e dell'8,9%**.

⚠️ **Nota di cautela, e non è una formalità**: il per-trade viene **troncato a
ogni corsa**, quindi conserva **UNA passata sola**, identificabile dal conteggio:
**AUDJPY la cella `TP 3,0`** (1345 deal) e **GBPUSD la cella `TP 2,0`** (1316).
Applicare quel rapporto alle altre sei celle è **[INFERITO]** — 🔴 **e quindi la
colonna «posizioni» delle due tabelle del §3 NON è una misura**, sono le due
righe in grassetto a esserlo.

---

## 3. 📊 I NUMERI, TUTTI E SEDICI

### AUDJPY — `R139a` — L+S, O1 0,25 / O2 0,50

| `InpTP_RR` | finestra | **PF** | **DD %** | deal | pos. (÷1,84) | Profit |
|---|---|---|---|---|---|---|
| 1,5 | IS | 🔴 0,78043 | 🔴 16,9381 | 757 | ~411 | −1528,97 |
| 2,0 | IS | 🔴 0,80291 | 🔴 15,5668 | 762 | ~414 | −1384,64 |
| 2,5 | IS | 🔴 0,80272 | 🔴 15,6058 | 767 | ~416 | −1388,56 |
| 3,0 | IS | 🔴 0,80666 | 🔴 15,3506 | 768 | ~417 | −1362,92 |
| 1,5 | OOS | 🔴 1,00781 | 🔴 16,8873 | 1322 | ~718 | +89,17 |
| 2,0 | OOS | 🔴 0,97064 | 🔴 18,3414 | 1340 | ~727 | −332,44 |
| 2,5 | OOS | 🔴 0,94923 | 🔴 20,4354 | 1344 | ~729 | −574,15 |
| 3,0 | OOS | 🔴 0,95627 | 🔴 19,9977 | 1345 | **730** | −497,21 |

### GBPUSD — `R139b` — L+S, O1 0,25 / O2 0,40

| `InpTP_RR` | finestra | **PF** | **DD %** | deal | pos. (÷1,83) | Profit |
|---|---|---|---|---|---|---|
| 1,5 | IS | 🔴 0,80318 | 🔴 20,3244 | 856 | ~467 | −1684,18 |
| 2,0 | IS | 🔴 0,83412 | 🔴 18,3847 | 870 | ~475 | −1441,55 |
| 2,5 | IS | 🔴 0,83704 | 🔴 17,9773 | 874 | ~477 | −1415,07 |
| 3,0 | IS | 🔴 0,83825 | 🔴 17,7260 | 875 | ~477 | −1403,75 |
| 1,5 | OOS | 🟢 1,12701 | 🟢 10,3857 | 1292 | ~705 | +1397,66 |
| 2,0 | OOS | 🟢 1,13781 | 🟢 10,0524 | 1316 | **718** | +1522,35 |
| 2,5 | OOS | 🟢 1,13222 | 🟢 11,0476 | 1321 | ~721 | +1451,54 |
| 3,0 | OOS | 🟢 1,13869 | 🟢 10,8059 | 1321 | ~721 | +1525,62 |

---

## 4. 🚦 LE SOGLIE CONGELATE IL 12/09, APPLICATE ALLA LETTERA

| soglia | testo congelato | AUDJPY | GBPUSD |
|---|---|---|---|
| **S1** CAMPIONE | n ≥ 300 deal in **entrambe** le finestre | ✅ 757-1345 | ✅ 856-1321 |
| **S2** MERITO | PF ≥ 1,10 in **entrambe**, su ≥3 celle su 4 | ❌ **0/4 IS, 0/4 OOS** | ❌ **0/4 IS** (OOS 4/4 ✅) |
| **S3** RISCHIO | DD ≤ 14,0% a 1,0% in **entrambe** | ❌ **8 celle su 8 sopra** (15,35-20,44) | ❌ **IS 4/4 sopra** (17,73-20,32); OOS ✅ |
| **S4** SEGNI | segno opposto IS/OOS su **>1 cella** ⇒ «regime, non edge» | 🟠 **NON scatta: 1 cella su 4** (`TP 1,5`: IS −1528,97 → OOS +89,17). La soglia chiede **più di una** | 🔴 **SCATTA: 4 celle su 4** |
| **S5** MANOPOLA | celle identiche al centesimo ⇒ manopola inerte | ampiezza PF **IS 0,026 · OOS 0,059** | ampiezza PF **IS 0,035 · OOS 0,012** |
| **S6** DEFAULT (solo b) | se il migliore batte il default 2,0 di <0,05 ⇒ «il default va bene» | — | ✅ **1,13869 vs 1,13781 = 0,00088** |
| **S6a / S7b** BANCO | *«questo round non promuove niente: Modello 1 = OHLC M1 = SCREENING, un numero OHLC non è mai un verdetto»* | ✅ **niente viene promosso**, e la bocciatura regge — vedi sotto | ✅ idem |

### 🔬 IL CONTRO-ESEMPIO DEL BANCO — perché un OHLC può UCCIDERE senza poter PROMUOVERE

La soglia congelata dice che **un numero OHLC non promuove**. La domanda che va
fatta, e che la prima stesura di questo referto NON si era fatta, è: **può
bocciare?** Solo se l'errore di banco va nel verso che **non** salva l'imputato.

✅ **E ci va.** L'OHLC è **OTTIMISTA** (spread corrente invece di quello storico,
pendenti riempiti più facilmente), dichiarato in tutti e due i file prova. Su un
banco a costo vero il PF **scenderebbe** e il DD **salirebbe**: `S2` (PF massimo
0,807 IS e 1,008 OOS, contro 1,10) e `S3` (DD 15,35-20,44%, contro 14,0%)
**peggiorerebbero entrambe**.

👉 **Un banco ottimista che BOCCIA è un verdetto; un banco ottimista che PROMUOVE
non lo è.** È esattamente per questo che il §9.1 **uccide** e il §9.2 **non
promuove**. *(E il PF 1,623 / DD 2,90% a tick non è un'obiezione: sono 2,5 anni
**dentro** l'OOS, ed è il §6 a mostrare che il resto della finestra se li mangia.)*

### 🥇 **S1 È LA RIGA CHE VALE, ed è la prima volta.**
R139a/b esistevano per UNA ragione: *«il motivo per cui nessuno ha mai promosso
EMA200 H4 non è il PF, è il CAMPIONE»* — l'altopiano a tick faceva **~141
posizioni su una finestra sola**. Adesso ne fa **411-477 in IS e 705-730 in OOS**.
👉 **Il pavimento dei 150 per finestra è stato visto, in entrambe, per la prima
volta su questo motore. E con il campione pieno il motore dice di no.**
Non è un fallimento del round: è esattamente ciò che il round doveva stabilire.

---

## 5. 🧪 L'ATTESA ERA SCRITTA PRIMA. COM'È ANDATA

| | dichiarato il 12/09 | misurato | esito |
|---|---|---|---|
| AUDJPY n IS | 370-470 pos | **411-417** | ✅ dentro |
| AUDJPY n OOS | 550-700 pos | **718-730** | 🟠 appena sopra |
| AUDJPY PF IS | 1,10-1,70 | **0,78-0,81** | ❌ **sotto** |
| AUDJPY PF OOS | 1,05-1,60 | **0,95-1,01** | ❌ **sotto** |
| AUDJPY DD IS | 6-14% | **15,4-16,9%** | ❌ **sopra** |
| AUDJPY DD OOS | 5-12% | **16,9-20,4%** | ❌ **sopra** |
| GBPUSD n IS | 380-490 pos | **467-477** | ✅ dentro |
| GBPUSD n OOS | 580-740 pos | **705-721** | ✅ dentro |
| GBPUSD PF IS | 1,00-1,40 | **0,80-0,84** | ❌ sotto |
| GBPUSD PF OOS | 0,95-1,35 — *«l'esito più probabile è UN PF INTORNO A 1,1, cioè A CAVALLO del cancello»* | **1,127-1,139** | ✅ **dentro, e la previsione puntuale è CENTRATA** |
| GBPUSD DD IS | 10-20% | **17,7-20,3%** | ✅ dentro (bordo alto) |
| GBPUSD DD OOS | 8-18% | **10,0-11,0%** | ✅ dentro |

👉 Su GBPUSD **cinque attese su sei** sono cadute dentro la banda dichiarata
**prima** di vedere i numeri — n IS, n OOS, PF OOS, DD IS, DD OOS; **fuori solo il
PF IS**. E la previsione **puntuale** («un PF intorno a 1,1») è centrata: **sei su
sette** contando anche quella. **Un baco non azzecca insieme n, DD e PF fuori
campione.** È questo, e non l'eleganza della tabella, che rende la misura credibile.
*(La prima stesura scriveva «sette su otto»: non tornava con questa stessa tabella,
che di righe GBPUSD ne ha sei.)*

Su AUDJPY invece **n è dentro e PF/DD sono fuori dal lato brutto**: il campione è
quello giusto, il comportamento no.

---

## 6. 🔬 IL CONTRO-ESEMPIO: L'ARITMETICA DEL REGIME

La finestra a **TICK** (2024.01.01 → 2026.06.30) che diede *PF 1,623 / DD 2,90%* su
AUDJPY sta **DENTRO** l'OOS di questo round (2016.08 → 2026.06). Quindi la si può
**sottrarre** e vedere quanto valgono i 7,4 anni che restano.

**AUDJPY**, stessa cella (O1 0,25 / O2 0,50, L+S, rischio 1,0%):

| `TP_RR` | OOS 9,9 anni | − fetta a tick 2,5 anni | = **resto 2016.08→2024.01** |
|---|---|---|---|
| 1,5 | +89,17 | +1274,84 | 🔴 **−1185,67** |
| 2,0 | −332,44 | +1181,35 | 🔴 **−1513,79** |
| 3,0 | −497,21 | +1217,73 | 🔴 **−1714,94** |

**GBPUSD** (O1 0,25 / O2 0,40), `TP_RR` 3,0: +1525,62 − 846,64 = 🟢 **+678,98**.

### Le riserve, dichiarate prima di usare il numero

1. ⚠️ È una sottrazione fra **DUE BANCHI DIVERSI** (Modello 4 tick reali contro
   Modello 1 OHLC M1, spread diverso). È un'**approssimazione**, non un'identità.
   🔴 **E la fetta dura 30 mesi, non 24, e va detto perché il punto 3 ci si
   appoggia.** I due file prova lasciavano la scelta **[NON MISURATO]** (*«24 mesi
   se il tick vero parte dal pavimento 2024.07.05, 30 se la finestra dell'ini è
   stata piena»*); il repo la chiude: prima del pavimento tick **MT5 GENERA i tick
   dalle M1** (`report/DIAGNOSI_GBPUSD_LENTA_2026-09-02.md` r.17, fatto F4, dal
   Diario MT5), quindi la corsa copre **tutta** la finestra dichiarata.
   ⚠️ Con la lettura a 24 mesi il controllo di coerenza del punto 3 **si
   ROVESCIA** (AUDJPY 134/anno OHLC contro 143 a tick; GBPUSD 130 contro 149),
   cioè l'OHLC diventerebbe *meno* generoso del tick. Con 30 mesi regge.
   🟠 E resta che **6 dei 30 mesi della fetta «a tick» sono tick GENERATI**, non
   veri.
2. 🔴 **E la direzione dell'errore salva AUDJPY ma NON salva GBPUSD.**
   L'OHLC è **ottimista** rispetto al tick ⇒ la fetta 2024-2026 misurata in OHLC
   sarebbe **≥** +1181 ⇒ il resto è **≤** −1514. Su AUDJPY il numero è un
   **limite superiore**, quindi la conclusione negativa **si rafforza**. ✅
   Ma per lo stesso motivo **+678,98 è anch'esso un limite superiore**: basterebbe
   che la fetta OHLC valesse più di +1525 (cioè ≥1,80× il tick) perché il resto
   diventi negativo. **Quanto sia ottimista l'OHLC su questo motore è
   [NON MISURATO]** ⇒ 🟠 il «GBPUSD è coerente nelle due metà» resta
   **[PARZIALE — limite superiore]**, non un fatto.
3. ✅ **Controllo di coerenza che passa**: AUDJPY resto 1057 deal / 7,4 anni =
   **143 all'anno** contro **113** della fetta a tick; GBPUSD 1026 / 7,4 = **139**
   contro **118**. Stesso ordine, con l'OHLC più generoso del **26%** — **esattamente
   il verso atteso** (l'OHLC riempie i pendenti più facilmente). Se i due banchi
   divergessero per un baco, sarebbe questo rapporto a esplodere per primo. Non esplode.

👉 **Lettura**: su AUDJPY il *PF 1,623 con DD 2,9%* non descriveva un motore.
Descriveva **due anni e mezzo**. Su GBPUSD la stessa prova non riesce a incriminare
l'OOS — e questa è l'unica differenza vera fra i due simboli.

---

## 7. 🏃 LA FREQUENZA: LA DOMANDA DA CUI ERA PARTITO TUTTO

| simbolo | posizioni OOS | finestra | giorni feriali | **pos/giorno feriale** |
|---|---|---|---|---|
| AUDJPY | 730 | 2016.08.10 → 2026.06.22 | 2574 | **0,2836** |
| GBPUSD | 718 | 2016.08.24 → 2026.06.17 | 2561 | **0,2804** |

Il buco verso il pavimento era **0,069 pos/giorno**
(`EMA200_IL_PAVIMENTO_DI_FREQUENZA_2026-09-17.md` r.87). Ciascuno dei due ne porta
**quattro volte tanto**. Sommati alla sedia `771531` (0,931):
**0,931 + 0,284 + 0,280 = 1,495** — **il 50% SOPRA il pavimento**.
⚠️ La somma mescola **finestre diverse** (lo 0,931 di `771531` è su
2025.06→2026.06, questi due su 2016→2026): si dichiara, tanto il paragrafo qui
sotto la azzera comunque.

> ### 🔴 **E non serve a niente. Il pavimento si somma sui simboli SCHIERABILI (`FIRME_2026-09-07.md` r.13), e né AUDJPY né GBPUSD lo sono: `S2` e `S3` li fermano prima. Apporto reale al pavimento: 0,000.**

👉 Ieri avevo scritto: *«il collo di bottiglia non è la frequenza: sono PF, DD e
costo di quei due simboli»*. **Confermato, e adesso con i numeri sotto.** La
frequenza era abbondante. È il merito che manca.

---

## 8. 💰 IL COSTO

| simbolo | spread | fonte | frontiera `stop ≥ 40 × spread` |
|---|---|---|---|
| **GBPUSD** | mediana **0,3 pip**, P95 **1,0 pip** (84.968 campioni, **6 giornate**) | `data/spread_vivo/SPREAD_VIVO_2026-09-12_referto.txt` r.134+ | ✅ **non morde**: lo stop è 1,0 × ATR(14) H4 = decine di pip |
| **AUDJPY** | 🔴 **[NON CALCOLABILE]** | non è fra gli 8 simboli misurati | buco dichiarato da R139a, e ormai **accademico** |

⚠️ **Correzione a R139b**: quel file citava *«GBPUSD spread 0,2 [LETTURA UNICA]»*.
La misura vera su 6 giornate dice **0,3 pip mediana** — cioè **il 50% peggio** di
quanto scritto. Non cambia la conclusione (0,3 pip contro uno stop da decine di
pip resta irrilevante), **ma il numero giusto è 0,3 e da oggi si cita quello.**

Gli 8 simboli con spread misurato sono: `225JPY` · `D30EUR` · `EURUSD` · `GBPUSD` ·
`NASUSD` · `U30USD` · `USDJPY` · `XAUUSD`. **Elencati per nome, non per differenza**
(classe 180).

---

## 9. 🪦 I VERDETTI

### 9.1 🔴 `EMA200` H4 **AUDJPY** L+S 2010-2026 — **MORTO, CERTIFICATO COMPLETO**

Muore su **due cancelli indipendenti** e in **entrambe le finestre**: `S3` rischio
(8 celle su 8 con DD 15,35-20,44% contro il tetto di 14,0%) e `S2` merito
(PF massimo **0,807** in IS, **1,008** in OOS). Il certificato di morte, punto per punto:

| requisito | esito |
|---|---|
| 1. un **PF** misurato | ✅ 8 celle |
| 2. un **n** e un **DD** | ✅ 411-730 posizioni per finestra, DD 15,4-20,4% |
| 3. **gestione dell'uscita** ad asse | ✅ `InpTP_RR` su 4 valori (parametro d'uscita) |
| 4. **simboli gemelli** provati | ✅ GBPUSD lo stesso giorno + 7 simboli nell'archivio a tick |
| 5. **TF** cambiato | ✅ H1 e H4 entrambi in `risultati_archivio/EMA200/` |

### 9.2 🟠 `EMA200` H4 **GBPUSD** L+S 2010-2026 — **NON PROMOSSO: `S4`, «REGIME, NON EDGE»**

IS negativo 4/4, OOS positivo 4/4 ⇒ segno opposto su **4 celle**, e la soglia era
*«più di una»*. È lo schema già pagato su PTE H3 e sulla Sequenza. **Non si promuove.**

🟢 **Ma il rovescio va scritto, perché è il profilo fuori campione più LUNGO e
più LARGO che questo motore abbia prodotto sul forex:**

| | numero |
|---|---|
| PF OOS | **1,127 - 1,139** su 4 celle su 4 |
| campione OOS | **705-721 POSIZIONI** su 9,8 anni |
| DD OOS a 1,0% | **10,05 - 11,05%** |
| **DD OOS alla taglia di flotta 0,65%** | **≈ 6,5 - 7,2%** |
| costo | ✅ fuori discussione (0,3 pip contro stop da decine) |
| frequenza | 0,280 pos/giorno feriale |

> ### ⚠️ **E «PIÙ LUNGO E PIÙ LARGO» NON VUOL DIRE «PIÙ ALTO» — la prima stesura di questo referto scriveva «il migliore che questo motore abbia MAI mostrato», e un CSV nella STESSA cartella lo smentisce.**

`EMA200` **EURUSD H1** (round R29a, `risultati_prove/ABTG_EMA200/ABTG_EMA200_EURUSD_{IS,OOS}_r29a.csv`,
30 celle per finestra, L+S, rischio 1,0%) fa:

| | EURUSD H1 (R29a) | GBPUSD H4 (R139b) |
|---|---|---|
| PF OOS, migliore | 🟢 **1,22389** | 1,13869 |
| DD OOS, migliore | 🟢 **9,0535%** | 10,05% |
| celle OOS ≥ 1,10 | 🟢 **28 / 30** | 4 / 4 |
| celle OOS in utile | **30 / 30** | 4 / 4 |
| **coerenza dei segni** | 🟢 **stesso segno**: IS 29/30 in utile (PF fino a 1,222, DD 8,89%) | 🔴 **opposto**: IS 0/4 |
| durata OOS | ~21 mesi | 🟢 **9,8 anni** |
| posizioni OOS | ~353 | 🟢 **705-721** |

👉 **Su PF e DD vince EURUSD. Su durata e campione vince GBPUSD. Un primato
senza il criterio accanto non è né vero né falso: è invendibile** — e in un referto
che archivia candidati, orienta le decisioni. Da qui in avanti si scrive *«il più
lungo»* o *«il più largo»*, mai *«il migliore»*.

🚪 **Porta di rientro: APERTA**, e la chiave è al §10.

### 9.3 ✅ `InpTP_RR` su `EMA200` H4 forex — **MANOPOLA DEBOLISSIMA, MISURATA**

16 celle, ampiezza di PF **0,012-0,059 per finestra** (GBPUSD OOS 0,0117 · AUDJPY
IS 0,0262 · GBPUSD IS 0,0351 · AUDJPY OOS **0,0586**). Non è inerte — i numeri si
muovono, e sull'OOS di AUDJPY di quasi sei centesimi — ma **non ribalta nessun
cancello**: nessuna cella arriva a 1,10 in IS, e nessuna scende sotto 1,10
nell'OOS di GBPUSD. E su GBPUSD `S6` è rispettata: **il default 2,0 va bene**
(1,13781 contro 1,13869 del migliore — differenza **0,00088**, contro una soglia
di 0,05). *«Il default va bene» è un risultato, non un fallimento.*

---

## 10. 🗝️ COSA APRIREBBE LA PORTA DI GBPUSD — E COSA NO

- ❌ **NON un'altra griglia di parametri.** `S4` è scattata. La regola della seconda
  caccia (19/08) vieta esplicitamente di allargare sui parametri di un motore che
  ha fallito: *«su un motore senza edge una griglia più fitta trova solo picchi di
  rumore»*. E qui una griglia troverebbe di sicuro qualcosa nell'OOS — **perché
  l'OOS è positivo**. Sarebbe la cella verde per caso, servita su un piatto.
- ❌ **NON il lato singolo SCELTO SUL TICK 2024-2026.** A tick la cella migliore
  di GBPUSD è SHORT-only (PF 2,066) e quella di AUDJPY è LONG-only (PF 1,852):
  sono le celle **selezionate su quel campione**, quindi girarle su 16,5 anni
  **conferma** invece di falsificare — R139a lo aveva già argomentato e vale ancora.
  🟠 **Ma resta aperta un'altra cosa, e il registro la tratta come viva**
  (`REGISTRO_TEST.md` r.2374-2384): un lato singolo **fissato A PRIORI** e passato
  per la prima volta a uno split IS/OOS è *«una tesi nuova»*, ed è **la regola dei
  due lati firmata il 25/08**. Non è la strada più corta, **ma non è chiusa** — e
  questo referto non la chiude.
- ✅ **SÌ: la PROVA DI REGIME.** La domanda vera è **perché il segno cambia ad
  agosto 2016**. È un Emendamento C (*«sedici anni di fila DILUISCONO»*), non una
  griglia: si spezzano IS e OOS in finestre di regime **dichiarate per nome** e si
  guarda se il 2010-2016 è **un'epoca** (come lo yen di Abenomics in R69, 0/28 in
  IS e 25/28 in OOS) oppure se il motore è semplicemente rotto.
  💸 **E costa ZERO passate di tester**: il per-trade
  `abtg_trades_ABTG_EMA200_GBPUSD_771561.csv` ha già la data di **ogni** posizione.
  È sul VPS, in `Common\Files`.

> ### 🔴 👉 **È l'ennesima cosa che sblocca la riga `carica_risultati.ps1` ferma in attesa di Claudio. Quella riga adesso non vale solo «47 round arretrati»: vale anche la lettura per regime di GBPUSD, che è la strada più CORTA rimasta a questo simbolo** (non l'unica: sopra ce n'è una seconda, il lato fissato a priori).

---

## 11. 📌 COSA ENTRA NELLA MEMORIA

1. 🔴 **Classe 411 commessa DA QUESTO REFERTO, nella riga in cui la denunciava.**
   I numeri erano nel repo dal 13/09 **e anche il verdetto era già scritto**, in un
   **referto** che non ho cercato. Il costo vero non è «cinque giorni di misura
   persa»: è **una giornata di lavoro rifatta** — e, in cambio, una **riproduzione
   indipendente** che regge. 👉 **Quando si cerca «esiste già?» si cercano TRE posti:
   i CSV, il REGISTRO e i REFERTI.** Io ne ho cercati due.
2. Il rapporto **deal/posizione** di `EMA200` a H4 forex è **1,83-1,84** misurato,
   non 2,0117 come assunto nei file prova del 12/09.
3. Lo spread MISURATO di **GBPUSD è 0,3 pip** mediana su 6 giornate — da oggi si
   cita questo, non lo 0,2 di lettura unica del 17/08.
4. Il pavimento storico BCM di **AUDJPY** resta **[INFERITO]**: la data di stacco
   dell'OOS **non lo misura** (MT5 la calcola dal range dichiarato, non dai dati).
   Ciò che il round aggiunge è un limite **misurato**: 116 deal/anno in IS,
   incompatibile con un buco di dati superiore a **~10 mesi**.
5. 🔴 **Un primato si scrive con la GRANDEZZA accanto** («il più lungo», «il più
   largo»), mai «il migliore», e solo dopo aver **elencato per nome** l'insieme su
   cui è calcolato. Costo del censimento che mancava: un `glob` e 30 secondi.
6. 🔴 **Una citazione di riga si verifica su TRE cose**: la riga esiste, contiene
   la frase, **e il SOGGETTO della frase è quello di cui sto parlando**. In un
   registro a blocchi due candidati diversi distano quattro righe.

---

---

## 12. 🔥 LA COSA PIÙ IMPORTANTE DI TUTTO IL DOCUMENTO, E NON ERA NELLA DOMANDA

Il censimento che il §9.2 aveva saltato (classe 411, **commessa dentro il referto
che la denuncia**) ha tirato fuori un candidato che è più avanti di tutti e due i
simboli di stamattina.

### 🥇 `ABTG_EMA200` **EURUSD** — il costo lo boccia a **H1**, ma a **H4 PASSA. E a H4 non l'ha MAI misurato nessuno con uno split.**

| | numero | fonte |
|---|---|---|
| H1, PF OOS | 1,076 - **1,224** su 30 celle | `ABTG_EMA200_EURUSD_OOS_r29a.csv` |
| H1, DD OOS | 9,05 - 11,98% @1,0% | idem |
| H1, segni | 🟢 **stesso segno nelle due finestre** (IS 29/30 in utile) | `..._IS_r29a.csv` |
| 🔴 H1, **costo** | **20,8×** contro il pavimento di lavoro **40×** → **ESCLUSO PER COSTO** | `REGISTRO_TEST.md` r.2367-2384 |
| 🟢 **H4, costo** | **41,7×** → **PASSA** | idem |
| H4, scansione esistente | **85 celle**, PF **0,705-1,565**, DD **3,94-8,09%**, 31 celle L+S | `risultati_archivio/EMA200/H4_OHLC/scan_ABTG_EMA200_H4_EURUSD.csv` |
| 🔴 **H4, split IS/OOS** | **NON ESISTE** — cercato repo-wide, zero file | mio `glob`, 18/09 |

> ### 🔴 **Il DD di quella scansione H4 è 3,94-8,09%: la METÀ di quello di GBPUSD H4 (10-11%) e di EURUSD H1 (9-12%). E il cancello del costo, che a H1 lo uccideva, a H4 lo lascia passare con 41,7× contro 40×.**

⚠️ **Quei numeri H4 sono una scansione a finestra UNICA, non un verdetto**: è
esattamente la condizione da cui partivano AUDJPY e GBPUSD stamattina, e si è
visto com'è finita. **Non promuove niente.** Ma è la stessa forma del difetto che
il 09/09 ci è costato quattro candidati di classe A1: **un candidato fermo per un
numero MANCANTE, non per un numero BRUTTO.**

👉 **La via più corta al numero è un round gemello di R139b**: stesso disegno,
stesso banco OHLC M1, stessa finestra 2010→2026, simbolo EURUSD, TF **H4**, cella
al centro dell'altopiano L+S della scansione. **8 passate, ~0,6 minuti macchina.**
🔴 **Non è stato scritto né armato**: va prima passato dal cancello, e la coda di
stanotte è già chiusa.

---

*Misura eseguita il 18/09/2026 · fonti: `risultati_prove/dal_vps/ABTG_EMA200/`,
`coda/referti/CODA_12_pertrade_posizioni_20260917_033003.log`,
`risultati_archivio/EMA200/realtick_H4/`, `data/spread_vivo/SPREAD_VIVO_2026-09-12_referto.txt`,
`prove/R139a_*.txt`, `prove/R139b_*.txt`, `risultati_prove/ABTG_EMA200/*_r29a.csv`,
`risultati_archivio/EMA200/H4_OHLC/scan_ABTG_EMA200_H4_EURUSD.csv`,
`report/DIAGNOSI_GBPUSD_LENTA_2026-09-02.md`, `REGISTRO_TEST.md` r.2367-2384 e r.2610-2622*

*🚦 Passato dal cancello il 18/09: prima stesura **FAIL** con 8 difetti bloccanti
(3 numeri o citazioni falsi, 1 candidato più forte non censito, 2 soglie risolte in
silenzio) e 5 minori. **Tutti applicati prima della consegna.** La sostanza dei due
verdetti non è cambiata; è nato il §12.*
