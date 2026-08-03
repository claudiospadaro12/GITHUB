# FOREX TRADING DIARY
## Piano di trading — **APERTURE AUTOMATIZZATE (Nasdaq · Dow · DAX)**
### Dalla strategia manuale all'Expert Advisor: regole, misure, casi di rigetto
*Claudio Spadaro — 03/08/2026 · per Emiliano Monza*

---

## 1) PREMESSA

Questo piano è la **versione meccanica** delle strategie di apertura ABTG (*Strategia NASDAQ*, *Piano di Trading Europeo*). Lavoro a tempo pieno e non posso stare davanti ai grafici: ho tradotto le regole in **Expert Advisor** che operano da soli su conto demo BCM.

L'obiettivo non è "avere un robot", è **verificare quali regole del piano reggono quando vengono applicate senza discrezionalità**, su 2 anni e mezzo di dati a tick reali (spread e fill veri), 2024.01 → 2026.06.

> **Fuso:** server BCM = ora italiana − 1. DAX 09:00 IT = 08:00 server · Nasdaq 15:30 IT = 14:30 server.

---

## 2) RAZIONALE

Poggia sugli stessi tre pilastri del piano ABTG:

1. **Anticipare il momentum iniziale** — ordini pendenti già posizionati prima dell'apertura.
2. **Livelli chiave di prezzo** — massimi/minimi di riferimento pre-mercato.
3. **Gestione rigorosa del rischio** — stop controllato, parziale, stop in pari, trailing.

La differenza rispetto al piano manuale è una sola, ed è quella che studio: **l'EA non sa saltare la giornata.** Tu certi giorni non entri. Lui entra sempre, salvo che una regola glielo impedisca. Tutto questo documento serve a capire **quale regola** sostituisce quel tuo giudizio.

---

## 3) REGOLE DI INGRESSO

### a) Setup grafico
Operativo **M5**; livelli letti da H1 o dal giorno precedente; filtro di contesto su H4. Indicatori disponibili nel codice: EMA, Supertrend (anche a tripla 2,5/3,0/3,5), VWAP di sessione, ATR, volumi.

### b) Canale di riferimento
Nel piano: **MAX/MIN dei 15 minuti precedenti l'apertura** (es. 15:25–15:30 CET).
Nel mio EA finora: **max/min della candela H1 precedente** (come da slide *Strategia Nasdaq*).
> ⚠️ **Sono due cose diverse e ho testato solo la seconda.** Vedi §7, punto 1.

### c) Analisi degli ostacoli
Nel piano: verificare supporti/resistenze, medie 50/100/200, Supertrend, pivot **entro 10–15 punti dall'ingresso**.
Nel mio EA: **non implementata.** È la regola più difficile da meccanizzare — richiede di sapere *quali* livelli contano.

### d) Posizionamento ordini pendenti
Nel piano: **da +7 a +10 punti** sopra il massimo (buy) o sotto il minimo (sell).
Nel mio EA: buffer configurabile, **testato da 0,25 a 2 punti indice**.
> ⚠️ **Ho testato un buffer 3,5–40 volte più stretto di quello prescritto.** Vedi §7, punto 2.

### e) Stop loss
Nel piano: **5 punti** dal punto di ingresso. Break-even **obbligatorio a +30 punti** di profitto.
Nel mio EA: floor minimo di stop = 5 punti indice ✅. Stop in pari, però, **al primo obiettivo (1R)** — cioè molto prima dei +30 punti del piano.

### f) Take profit e incrementi
Nel piano: **RR minimo 1:2**, target progressivi sui livelli tecnici, parziale e stop in profit al 2° obiettivo, incrementi solo su rottura confermata di un ostacolo.
Nel mio EA: parziale 50% al 1° obiettivo, stop in pari, trailing sulla base della candela M1 (410 punti fissi sugli indici). **Incrementi di posizione: non implementati.**

---

## 4) GESTIONE DELLA POSIZIONE

| Regola del piano | Nell'EA |
|---|---|
| Cancello l'ordine non eseguito | OCO automatico ✅ |
| Porto lo stop sui massimi precedenti | ✅ |
| TP in divenire, dimezzo sui livelli | parziale 50% ✅ |
| Stop in pari | ✅ (ma a 1R, non a +30 punti) |
| Scendo di TF e seguo con lo stop | trailing su candela M1 ✅ |
| Gestione dinamica della residua su livelli successivi | ❌ non implementata |
| Uscita su segnali di esaurimento (divergenze, volumi in calo) | ❌ non implementata |

---

## 5) CASI DI RIGETTO DELLA STRATEGIA

Il piano MAX-MIN dice: **«NON SI ADOTTA se il mercato ha bassa volatilità (laterale) o bassi volumi.»**

**Questa è la regola più importante che ho misurato, ed è vera.** Sul Nasdaq, filtrando per volume (~625 giorni di borsa nel periodo):

| Filtro | Trade | % giorni | Profit Factor | Drawdown |
|---|---|---|---|---|
| **nessuno** | 481 | 77% | 0,91 | 35% |
| volume ≥ 1,2× media | 296 | 47% | 0,96 | 17,9% |
| volume ≥ 1,5× media | 152 | 24% | **1,15** | 9,6% |
| volume ≥ 1,8× media | 79 | 13% | **1,38** | 7,6% |

Più stringo sul volume, più sale il profit factor e più scende il drawdown, **in modo regolare**. Un filtro che non contiene informazione non produce una scala così ordinata: il volume all'apertura è informazione vera.

**La volatilità invece no.** Stesso motore, stesso periodo, filtrando per ATR:

| Filtro | Trade | Profit Factor |
|---|---|---|
| ATR ≥ 0,8× media | 469 | 0,93 |
| ATR ≥ 1,0× media | 332 | 0,93 |
| ATR ≥ 1,2× media | 116 | **0,76** |

**Zero configurazioni positive su 24**, e alla soglia alta *peggiora* buttando via l'81% dei giorni. Il piano dice «bassa volatilità **o** bassi volumi»: dai miei numeri **contano i volumi, non la volatilità**.

---

## 6) RISULTATI PER STRUMENTO (tick reali, profit factor mediano)

| Strumento | Motore | PF | Trade | Esito |
|---|---|---|---|---|
| **Dow** U30USD | rottura con ordini stop | **1,30** | 348 | 🟢 vivo anche senza filtri |
| **Nasdaq** NASUSD | rottura con ordini stop | 0,88 | 328 | ❌ senza filtri |
| **Nasdaq** + filtro volume 1,8× | | **1,38** | 79 | 🟡 pochi trade |
| **DAX** D30EUR | rottura | 0,77 | 440 | ❌ |
| **DAX** | ingresso sul retest | 0,79 | 436 | ❌ |
| **DAX** | fade degli estremi | 0,73 | 440 | ❌ (DD 23%) |
| Nasdaq/Dow | ingresso dopo la chiusura della candela | 0,66 | 116 | ❌ |

**Sul DAX ho provato tre motori opposti** — inseguire la rottura, aspettare il ritorno, fadare l'estremo — **e falliscono tutti e tre**, con ~440 operazioni ciascuno. Non è campione sottile.

---

## 7) NOTE IMPORTANTI — dove il mio lavoro diverge dal piano

**1. Il canale di riferimento.** Le slide dicono *"ordini nel time frame H1, sotto i minimi precedenti"*; il piano scritto dice *"MAX/MIN dei 15 minuti precedenti, 15:25–15:30"*. Ho automatizzato il primo. **Il canale pre-apertura non l'ho mai testato** — e il codice lo supporta già. È il prossimo test.

**2. Il buffer degli ordini.** Il piano dice **+7/+10 punti**. Io ho spazzolato da 0,25 a 2 punti. Con un buffer così stretto l'EA entra su **ogni falso break**: potrebbe spiegare da solo buona parte delle bocciature.

**3. Il volume: prima o durante?** Il filtro che funziona, nel mio EA, scatta alle 15:30 in punto e legge la candela M5 **appena chiusa** — cioè **15:25–15:30, prima dell'apertura**. Il piano parla di *"rottura supportata da aumento di volumi"*, cioè volume **sulla candela che rompe**. Funziona la prima versione; la seconda non l'ho testata.
**Nota che la finestra è la stessa del canale di riferimento del piano** (15:25–15:30): forse non è un caso, e la pre-apertura è dove sta davvero l'informazione.

**4. Lo stop in pari.** Il piano lo mette a **+30 punti**; il mio EA a 1R (≈5 punti). Sposto in pari **sei volte prima** — cioè taglio le gambe ai trade che avrebbero corso.

**5. Gli ostacoli tecnici.** La regola «non entrare se c'è un ostacolo entro 10–15 punti» non è implementata, e sospetto pesi molto: è il modo in cui il piano evita gli ingressi destinati a sbattere.

---

## 8) MONEY MANAGEMENT

- **Massimo 2% di rischio per operazione**, lotto calcolato sulla distanza dello stop.
- **Drawdown massimo accettato prima di fermarmi**: 10% sul conto (limite delle prop a cui punto, FTMO 2-Step: −5% giorno / −10% totale).
- **Rapporto rischio/rendimento minimo**: 1:2 come da piano (oggi l'EA lavora a 1R + trailing → da allineare).
- **Guardiano di portafoglio**: un EA separato sorveglia il conto intero e chiude tutto se si sfiora il limite giornaliero o il drawdown massimo.
- **Regola ferrea**: nessun EA passa in forward senza aver superato i **tick reali**. Il backtest OHLC mente — ho visto un profit factor 7,37 diventare 0,96 sul CAC.

---

## 9) DISCIPLINA E OBIETTIVI

**Obiettivo realizzabile:** non 50 EA buoni, ma **2-4 EA robusti e poco correlati**. Anche uno solo che passi una challenge prop sarebbe un successo.

**Tempo che mi do:** 2-3 mesi di forward su demo prima di qualsiasi giudizio. Le operazioni H4 sono poche al mese: prima non ci sono numeri veri.

**Tempo che dedico:** i backtest girano di notte sul PC fisso, gli EA in forward sul VPS. Io analizzo i risultati la sera e nel weekend.

**Errori che devo correggere** — quelli veri, di questa settimana:
- Ho testato per giorni il motore **senza i filtri del piano**, e concluso che non funzionava. Era il test a essere sbagliato.
- Ho implementato l'ATR come **condizione d'ingresso** (era una lettura mia) e i numeri l'hanno bocciato.
- Ho lasciato uno **stop mal posizionato** che ha invalidato due test interi del DAX: lotto schiacciato al minimo, profit factor 142 che era solo una divisione per quasi-zero.

**La disciplina che mi impongo:** guardare **prima il numero di operazioni, poi il profit factor**. Un PF alto su 70 trade in 2 anni e mezzo non è un edge, è selezione. Soglia che mi sono dato: sotto 150 trade il risultato è sospetto, sotto 80 non è un dato.

---

## 10) COSA TI CHIEDO, EMILIANO

1. **Il canale**: 15 minuti pre-apertura o candela H1 precedente? Nei tuoi materiali ci sono entrambi.
2. **Il volume**: quello che si accumula **prima** dell'apertura o quello **sulla rottura**?
3. **L'ATR**: lo usi come conferma per entrare, o solo per tarare lo stop? I miei numeri dicono che come conferma non funziona.
4. **Il DAX**: tre motori bocciati in versione meccanica, ma nelle live ti vedo lavorarlo bene. **La scelta della giornata ha una regola**, o è esperienza? Se c'è una regola la scrivo e la misuro; se è esperienza pura, l'apertura DAX è una strategia da uomo e smetto di insistere.
5. **Gli ostacoli tecnici entro 10–15 punti**: quali guardi davvero, in ordine di importanza? Se me li dai, provo a meccanizzarli.

---

*Tutti i numeri di questo documento vengono da backtest a tick reali archiviati e riproducibili. Dove ho sbagliato l'ho scritto, anche quando l'errore era mio. Preferisco un metodo che si corregge a uno che ha sempre ragione.*
