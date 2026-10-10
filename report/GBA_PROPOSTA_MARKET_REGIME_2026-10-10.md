# GBA (ABTG_GoldBreakoutATR v1.10, magic 775800, XAUUSD M1) - PROPOSTA MARKET REGIME: filtri di contesto operativo (10/10/2026)

Autore: agente MARKET REGIME (cercatore-parametri). **BOZZA, NON PASSATA DAL CANCELLO.** Solo carta e analisi di sola lettura su archivi gia' prodotti: nessun backtest eseguito, nessun EA/preset/conto/forward toccato, nessun file prova creato. **Non e' una consegna a Claudio finche' `controllo-preventivo` non l'ha letta.**
Etichette: **[MISURATO]** rifatto da me sui deal/giornali grezzi di R1A e R1B | **[DERIVATO]** conto su numeri misurati | **[INFERITO]** ragionamento | **[NON MISURATO]** buco | **[POST-HOC]** letto sugli stessi dati 2026 su cui nasce l'ipotesi: e' IPOTESI, non prova.
Fonti: `backtest_pipeline/risultati_archivio/GBA_R0_R1A_20261010/GBA_R0_R1A.zip` (3 report .htm + 3 giornali), `.../GBA_R0_R1B_20261010/GBA_R0_R1B.zip` (9 passate, 9 giornali), `report/GBA_R0_R1A_LETTURA_2026-10-10.md`, `report/GBA_R0_R1B_LETTURA_2026-10-10.md`, `report/GBA_R2_PIANO_2026-10-10.md`, `docs/live_emiliano/COLLEGHI_GBA_2026-10-10.md`, `backtest_pipeline/prove/GBA_R2_REGIME_2026-10-10.txt`, `report/OROLOGIO_BCM_2026-09-24.md`, sorgente `mql5/Experts/ABTG_GoldBreakoutATR.mq5` (SHA256 1381e3dc..., riverificato). Barre M1 HistData per il solo calcolo del trend a TF alto: `backtest_pipeline/proxy_gba_r2reg.py::carica()` (proxy, non feed BCM).

---

## 0. IN DIECI RIGHE

1. **Nessun filtro di contesto porta questo motore sopra 1,0 sui dati che abbiamo, e il perche' e' misurato, non opinato.** Il migliore sottoinsieme di fasce orarie della cella REPL e' PF_V 1,115 (n=410, asia+pausa+pomeriggio USA); **ma a etichette orarie permutate entro il giorno il "migliore di 63 sottoinsiemi" fa PF mediano 0,995 (p95 1,119): quel 1,115 e' rumore da selezione (P=0,055)**. Sulla cella grande C035 il migliore e' 0,913 (null mediano 0,876, P=0,093). [MISURATO, sez. 3.3]
2. **Un solo effetto orario regge anche a una lettura severa: la mattina europea 07-12 server e' debole.** PF_V 0,52 (REPL, n=132) / 0,55 / 0,61 / 0,61 (C010/C020/C035, n=886-1578); segno concorde in 3 tranche su 3; **debole in entrambe le stagioni sulla C035 (inverno 0,46, estate 0,61)**; intervallo 95% per giorno della C035 [0,50 - 0,72] (esclude 1 con ampio margine). Escluderla alza il PF di **+0,05 [+0,02; +0,08]** (C035) e +0,06 [0,00; +0,13] (REPL): da 0,817 a 0,868 e da 0,855 a 0,915 **in scoperta**; al netto della selezione "migliore di 6" il guadagno atteso fuori campione e' **~+0,03**. Resta **sotto 1**. [MISURATO/POST-HOC]
3. **Il blocco della pausa (22:00) e' igiene, non merito, ed e' il guadagno piu' sicuro**: 179 righe `retcode 10018` in R1A (415 in C035 T3) nascono da **4 (REPL) / 27 (C035) posizioni che attraversano la pausa**, tutte entrate nell'ora 21 tranne una; piu' 8 / 91 ordini rifiutati a ora 21-23. Con `InpHourEnd = 21` le posizioni attraversanti vanno a 0 (REPL) / <=1 (C035). Costo in merito: **PF -0,02** (REPL) perche' le 27 attraversanti valgono +20.809 EUR in C035: **un'estrazione, non un edge** (senza di loro l'ora 21 fa PF 0,81). [MISURATO]
4. **Giorno della settimana: nessun effetto.** Differenze massime PF 0,254 (REPL) e 0,138 (C035), **p = 0,90 e 0,74** con permutazione a blocchi di giorni dentro la tranche. Venerdi' pomeriggio (n=464, PF 0,84) e lunedi' mattina (n=814, PF 0,75) contro 0,817 di base: dentro il rumore. **Nessun input esiste nell'EA per i giorni**: non si apre codice per un effetto che non c'e'. [MISURATO]
5. **Spread massimo: inerte, confermato da una seconda parte.** R1B: PF_V 0,83/0,82/0,82. Per classi di spread d'ingresso (C035) PF 0,74-0,87 senza forma. Il filtro `InpSpreadMaxATR` e' di fatto un **pavimento di ATR** (spread ~0,21-0,27 quasi costante) e non ha morso sul PF. **Nessuna proposta.**
6. **Regime di volatilita': nessun filtro puro esiste come input e i dati non lo chiedono.** PF per ATR d'ingresso (C035): 0,68-0,79 sotto ATR 4, 0,86-0,91 fra 4 e 7, 0,98 sopra 7 (n=157, poi 0,86 su n=114): **non monotono** e quasi tutto in T3; terzili per tranche 0,83 / 0,72 / 0,86. Il pavimento di ATR 7 non e' validabile fuori T3 (nel 2024-25 l'ATR M1 e' 0,6-1,4). Una proposta di codice (percentile ATR) resta in coda per **misurabilita' tra regimi**, non per il PF.
7. **Regime di prezzo: l'allineamento al trend di TF alto da' un segnale debole e incoerente.** Operazioni concordi con l'EMA100 di H1/H4/D1: PF_V 0,886/0,885/0,888 contro 0,735/0,744/0,753 per le contrarie (C035); sulla REPL H1 1,007 contro 0,667, ma H4 0,833 e D1 0,804 (nessun vantaggio). **Esiste gia' come input (`InpTrendTF`)**, senza codice, ma SOSTITUISCE l'EMA di M1 invece di aggiungersi. [DERIVATO su proxy HistData]
8. **Fuori campione**: 2026 T1-T3 e' **scoperta** (contaminata da questo dossier); **T4-T9 del lotto R2REG** e' la validazione e **le ipotesi orarie si leggono "per fetta" dalle sue stesse passate: ZERO passate in piu'**; T0 (dal 01/10/2026) e' la prova in avanti. **Attenzione**: R2REG a oggi ha il cancello strato 2 in FAIL (commit 14e28ff4, c85ccf7c): se non passa, la validazione per fetta non parte.
9. **Costo**: MR0 0 passate; MR1 8; MR2 8 (condizionata a MR0); MR3 9 (+6 condizionate); MR4 codice + 18. Incondizionate+condizionate nel caso centro **25 passate ~21 minuti** sul PC di backtest, mai sul VPS. Prima va generalizzato il driver (il v4 accetta solo `InpSpreadMaxATR` come variabile di cella: `GBA_R0_PASSATE.ps1` r.319 e r.521), lavoro non macchina, gia' previsto in `GBA_R2_PIANO` sez. 3.5.
10. **Tensione da dichiarare**: `GBA_R2_PIANO` sez. 8 dice "il filtro orario e' un parametro d'ingresso di un motore a PF < 1,10: non si allarga finche' R2 non trova una cella". Questa proposta sta dentro il perimetro solo perche': MR1 e' igiene (rischio, non merito); MR0 non costa passate; MR2 e' UNA finestra fissata da una regola e parte solo se MR0 la conferma; MR3 e' un meccanismo (3 valori), non una griglia. **Se il cancello legge sez. 8 alla lettera, si fanno solo MR0 e MR1.**

---

## 1. LE 5 PROPOSTE PRIORITARIE (ordinate per beneficio / costo)

| # | Proposta | Input | Esiste? | Neutro (= oggi) | Valori | Passate | Minuti | Beneficio atteso | Priorita' |
|---|---|---|---|---|---|---:|---:|---|---|
| MR0 | Validazione "per fetta" delle ipotesi orarie su R2REG (T4-T9) e T0 | nessuno (lettura S6 gia' nel lettore) | si' | - | europa, rollover, pausa, asia | **0** | 0 | decide se MR2 vale 8 passate; dice se "pausa 12-14 > 1" e' stagione | **1** |
| MR1 | Blocco della pausa giornaliera | `InpHourEnd` (Start fisso 0) | si' | 24 | 22, 21 | 8 | ~7 | posizioni attraversanti 4->0 (REPL), 27->=1 (C035); righe 10018 179->=10; PF -0,02..0 | **2** |
| MR2 | Esclusione della mattina europea 07-12 | `InpHourEnd` con `InpHourStart` fisso a 12 | si' | End = 12 (inizio = fine = nessun filtro, per codice) | 12, 7 | 8 (cond.) | ~7 | PF +0,03 (netto selezione), n -14% | **3** |
| MR3 | Concordanza col trend di TF alto (regime di prezzo) | `InpTrendTF` | si' (sostituisce) | 0 = TF del segnale | H1, H4, D1 | 9 (+6 cond.) | ~8 (+5) | PF 0,85-1,05, n -40%; letto per regime e per lato | **4** |
| MR4 | Pavimento di ATR RELATIVO (percentile sulla storia recente) | nuovi `InpAtrPctMin`, `InpAtrPctBars` | **NO (codice)** | 0 = spento | 0, 50, 75 | 18 dopo il codice | ~15 | misurabilita' tra regimi (la REPL e' vuota nel calmo); PF ~0 | **5** |

**Non proposte (con il numero accanto)**: giorno della settimana (nessun effetto, p 0,74-0,90), filtro di spread (inerte), notte 00-07 a M1 (gia' letta: PF 0,87-0,94, n 142 sospesa / 2441 FRA per costo; la versione M5 e' R2N), USA apertura (riserva, sez. 4.7), "fade" in Europa (meccanismo, segnalazione sez. 4.9), pavimento di ATR 7 (non validabile), `InpAllowShort` (lo decide R2REG per regime, sez. 4.10), tetto di 1 operazione al giorno (gia' nel piano, sez. 4.8). Tabella completa in sez. 4.

---

## 2. COSA E' GIA' PROVATO (con le fonti) E COSA NO

**Provato (R1A, R1B; un regime: gen-set 2026, tick reali, Modello 4):**
- REPL (spread 0,05 ATR) PF_V 0,855 su n=933; C010/C020/C035 PF_V 0,830 / 0,819 / 0,817 su 3.918 / 6.949 / 7.420. Altopiano piatto sotto 1 (`GBA_R0_R1B_LETTURA`).
- Fasce S6 fissate a priori il 09/10: lette sotto in sez. 3.1; **solo europa e rollover superano la soglia corretta con segno concorde**; la notte 00-07 e' "non distinguibile da zero" e la pausa 12-14 e' positiva in 1 tranche su 3.
- Il motore e' a zero prima dei costi (-0,014 R +- 0,028; `GBA_R2_PIANO` sez. 1.5): **nessun filtro puo' creare un edge che non c'e'; puo' solo togliere la parte che perde piu' del costo.**
- `REGISTRO_TEST.md`: nessuna caduta riguarda il GBA (0 occorrenze, come in `GBA_R2_PIANO` sez. 8).

**Mai provato:** nessun asse di contesto era stato messo ad asse (ne' ora come input, ne' trend a TF alto, ne' ATR relativo). L'ora e' stata solo LETTA sui deal esistenti. Il filtro orario esiste nell'EA (`InpHourStart/End`, una sola finestra) e **non e' mai stato girato come input**.

**Cosa NON si puo' esprimere con gli input esistenti** (verificato sul sorgente, `GbaDecidi` e input a r.118-186): giorno della settimana; due finestre orarie (es. togliere europa E rollover insieme); minuti (la finestra e' a ore intere); ATR relativo (percentile/rapporto veloce-lento); trend di TF alto come condizione AGGIUNTIVA (`InpTrendTF` sostituisce l'EMA di M1); uscita forzata prima della pausa.

---

## 3. LE MISURE CHE HO FATTO (tutte POST-HOC: sono ipotesi, non prova)

Metodo: ho ricaricato i deal dei report .htm e le righe `[GBA] BUY/SELL` dei giornali con `leggi_gba_uscite.operazioni()` (stesso lettore del piano R2). **Controllo contro-esempio del mio caricatore**: riproduce esattamente n=128/248/557 (R1A) e 1.032/1.259/1.627, 2.383/2.268/2.298, 2.609/2.437/2.374 (R1B) e **tutti i PF per fascia pubblicati dal lettore** (es. C035 europa 0,608, rollover 0,526; REPL USA apertura 0,700). Gli script d'analisi stanno in una cartella di lavoro, **non in repo** (il mandato di commit era questo solo path): vanno archiviati o rifatti dalla sessione dopo il cancello (buco 9).

### 3.1 PF_V per fascia S6 (ora SERVER d'ingresso), per cella [MISURATO]

| fascia | REPL n / PF | C010 n / PF | C020 n / PF | C035 n / PF | C035 per tranche T1 / T2 / T3 |
|---|---|---|---|---|---|
| asia 00-07 | 142 / 0,94 | 922 / 0,92 | 2188 / 0,88 | 2441 / 0,87 | 0,74 / 0,93 / 0,93 |
| **europa 07-12** | 132 / **0,52** | 886 / **0,55** | 1555 / **0,61** | 1578 / **0,61** | 0,58 / 0,67 / 0,59 |
| pausa 12-14 | 89 / 2,03 | 451 / 1,15 | 739 / 1,05 | 750 / 1,05 | 0,83 / 0,91 / **1,40** |
| USA apertura 14-17 | 381 / **0,70** | 891 / 0,80 | 957 / 0,78 | 961 / 0,78 | 0,80 / 0,71 / 0,81 |
| USA pomeriggio 17-22 | 179 / 0,93 | 720 / 0,91 | 1363 / 0,91 | 1456 / 0,91 | 1,04 / 0,71 / 0,97 |
| rollover 22-24 | 10 / 0,80 | 48 / 0,62 | 147 / 0,50 | 234 / 0,53 | 0,68 / 0,52 / 0,26 |

Costo mediano `2,5 x ATR / (spread + 0,04)` per fascia: **REPL 48,6-50,7x in tutte (PASSA)**; C035 asia 17,3 | europa 19,6 | pausa 21,2 | USA apertura 34,2 | pomeriggio 18,7 | **rollover 11,9 (ESCLUSA PER COSTO, <13,3)**. La C035 e' quindi un **veicolo di misura** dell'effetto orario (n grande), **mai una sedia**.

### 3.2 Quanto vale togliere UNA fascia, e quanto ne darebbe il caso [MISURATO, permutazione]
Schema (seed 20261010, 2.000 giri): permuto le etichette orarie fra le operazioni **dello stesso giorno** (conserva l'effetto-giorno), calcolo per ogni giro il PF restante togliendo ciascuna delle 6 fasce e prendo il MIGLIORE: e' quanto "guadagna" chi sceglie la fascia da togliere guardando i dati.

| cella | PF base | togliendo la migliore (osservato) | null mediano del "migliore di 6" | null p95 | P(null >= osservato) |
|---|---|---|---|---|---|
| REPL | 0,855 | 0,957 (USA apertura; europa 0,915) | 0,922 | 1,012 | 0,231 |
| C010 | 0,830 | 0,900 (europa) | 0,861 | 0,889 | 0,021 |
| C020 | 0,819 | 0,871 (europa) | 0,840 | 0,864 | 0,022 |
| C035 | 0,817 | 0,868 (europa) | 0,839 | 0,861 | 0,024 |

Lettura: sulle celle grandi la fascia europa **esce dal caso** (P~0,02 gia' dopo la correzione "migliore di 6"), ma meta' del guadagno osservato (+0,02 su +0,05) lo darebbe comunque la scelta. **Sulla REPL (n=933) non si distingue dal caso (P=0,23)**: la REPL non ha la potenza per giudicare l'ora; per questo la C035 serve da veicolo. Intervallo 95% per giorno (2.000 ricampionamenti, seed 5): europa PF fascia C035 [0,50; 0,72], REPL [0,26; 0,96]; guadagno a escluderla C035 +0,051 [+0,024; +0,081], REPL +0,061 [-0,002; +0,125].

### 3.3 Il tetto di quello che l'ora puo' dare [MISURATO, permutazione]
Seed 3, 1.000 giri; fra tutti i 63 sottoinsiemi non vuoti di fasce che tengono >=40% delle operazioni, il PF del migliore:
- REPL: osservato **1,115** (asia+pausa+pomeriggio USA, n=410) | null mediano **0,995**, p95 1,119 | **P=0,055**.
- C035: osservato 0,913 (asia+pausa) | null mediano 0,876, p95 0,923 | P=0,093.
**Controesempio della conclusione "l'ora non puo' dare edge"**: se esistesse un sottoinsieme con edge vero, l'osservato starebbe ben sopra il p95 del null; sta a ridosso o sotto. **Cio' che non posso escludere** e' che una fascia (la pausa 12-14, PF 1,05-2,03) abbia un edge piccolo: ma e' positiva solo in T3 (inverno, vedi 3.6) e la sua n e' 89 (REPL) o stagionale.

### 3.4 Giorno della settimana [MISURATO]
PF_V per giorno (lun..ven): REPL 0,74 / 0,78 / 0,93 / 0,89 / 0,99 (n 163-208); C035 0,77 / 0,82 / 0,90 / 0,84 / 0,78 (n 1.429-1.518). Statistica max-min PF con permutazione **a blocchi di giorni dentro la tranche** (seed 11, 2.000 giri): REPL 0,254 **p=0,90**; C035 0,138 **p=0,74**. Per tranche i segni si invertono (mercoledi' C035: T1 1,10, T2 0,78, T3 0,87). Cella a priori "venerdi' pomeriggio" (14-22 server): C035 n=464 PF 0,84; REPL n=102 (sospesa). "Lunedi' mattina" (00-12): C035 n=814 PF 0,75; REPL n=82 (sospesa). **Controllo negativo del mio test**: lo stesso schema applicato alle ore trova l'effetto europa (P~0,02) e non trova nulla sui giorni: non e' un test che trova sempre.
**Correzione per confronti multipli**: 5 giorni -> soglia 0,01; 6 fasce -> 0,0083 (la regola S6 di casa); le 30 celle fascia x giorno -> 0,00167 con n>=150 per cella: **possibile solo sulla C035 (n medio ~250 a cella), non sulla REPL (n medio ~31)**.

### 3.5 Volatilita' e spread [MISURATO]
- PF_V per ATR d'ingresso, C035: [0-1) n=247 0,68 | [1-1,5) n=1.342 0,78 | [1,5-2) n=1.721 0,78 | [2-3) n=2.168 0,78 | [3-4) n=950 0,79 | [4-5) n=404 0,91 | [5-7) n=317 0,86 | [7-10) n=157 0,98 | >=10 n=114 0,86. R medio per operazione da -0,12 a 0,00. REPL (ATR>=~4,2 per costruzione): 0,70 / 0,71 / 0,89 / 1,05 (n=133) / 0,84. **ATR>=7 vale n=271 (C035, PF 0,919) e n=220 (REPL, PF 0,948), 86-88% in T3: non validabile fuori da un trimestre.**
- Terzili dell'ATR entro la tranche (C035): 0,834 (T1 0,71 / T2 0,77 / T3 1,00), 0,723, 0,858. **Non monotono.**
- Spread d'ingresso (C035): [0-0,15) 0,77 | [0,15-0,20) 0,78 | [0,20-0,25) 0,80 | [0,25-0,30) 0,87 | [0,30-0,40) 0,86 | >=0,40 (n=265) 0,74. Mediana 0,23, p99 0,56, massimo 4,57. **Nessuna forma: un tetto di spread assoluto non aggiunge nulla al filtro relativo.**

### 3.6 Orologio e stagione [MISURATO]
Il server BCM e' UTC+1 fisso (`OROLOGIO_BCM_2026-09-24`): d'inverno = ora italiana, d'estate = ora italiana - 1. Tutte e tre le tranche 2026 sono dopo il cambio d'orologio: **orologio uniforme**. Ma le **fasce a ore server fisse** contengono eventi diversi nelle due stagioni: apertura Londra 08:00 locale = 08:00 server d'estate / 09:00 d'inverno; dati USA 08:30 ET = **13:30** server d'estate (dentro la fascia "pausa") / **14:30** d'inverno (dentro "USA apertura"); apertura cash NY 09:30 ET = 14:30 / 15:30. **Nelle settimane di disallineamento (8-29 marzo, 25 ottobre-1 novembre) la differenza e' di un'ora per i soli eventi USA.** [DERIVATO dalle regole DST]
PF_V per stagione sulla C035 (inverno = 01/01-07/03, estate = 29/03-fine): asia 0,93 / 0,83 | **europa 0,46 / 0,61** | pausa **1,07 / 0,86** | USA apertura 0,70 / 0,75 | pomeriggio 0,91 / 0,84 | rollover - / 0,58. **L'europa e' debole in entrambe le stagioni; la pausa e' >1 solo d'inverno** (il "1,05-1,15" del lettore e' stagione/regime T3, coerente con "1 tranche su 3"). Anche REPL: pausa inverno 2,73 (n=19) / estate 1,26 (n=55).

### 3.7 Anatomia della pausa giornaliera [MISURATO sui giornali]
- Tutti gli errori `10018 (market closed)` sono in T3 (inverno): REPL 179 righe/7 giorni; C035 415 (dedup per secondo) su 34 giorni; **T1/T2 (estate): 2-7 righe, sempre alle 21:50-21:54**. Per tipo e ora d'invio (C035 T3): chiusura a tempo 174 (tutte a ora 22) | spostamento SL 31 (ora 21) + 119 (ora 22) | **ordini rifiutati 12 (ora 21) + 75 (ora 22) + 4 (ora 23)**. REPL T3: chiusura 102, SL 16+53, ordini 7+1.
- **Primo errore del giorno**: mediana 22:07, minimo 21:50:18; **ultimo errore del giorno**: mediana **22:50**, massimo 23:09. Quindi "pausa 22:00-22:40" e' **troppo corta** per il tester: a ore intere il blocco giusto e' tutta l'ora 22.
- **Anatomia dei dati (INFERITA, non letta dalle specifiche del simbolo)**: segnali per ora a ora 22 e 23: gen-feb ore 22 presenti (50, 36 segnali) e ora 23 **assente (0, 0)**; da aprile ora 22 assente (0) e ora 23 presente (66-113). Coerente con: trading BCM chiuso 22:00-23:00 server tutto l'anno + dati assenti 23:00-24:00 d'inverno (la pausa CME segue l'ora legale USA). Gli ordini a ora 22 d'inverno falliscono perche' il simbolo esiste ma il trading e' chiuso.
- **Chi attraversa la pausa**: REPL 4 posizioni (tutte entrate a ora 21, nette +3.158 EUR); C020 17; C035 27 (26 entrate a ora 21, 1 a ora 17; nette +20.809 EUR). **Le righe di errore sono i tentativi ripetuti di quelle poche posizioni** (la durata massima vale 153 minuti in REPL; in C035 3.222 minuti, cioe' un weekend: posizione entrata di venerdi' sera).
- **Contro-esempio al "l'ora 21 e' buona"**: PF ora 21 = 2,50 (REPL, n=19), 1,51 (C020, n=174), 1,38 (C035, n=230). **Senza le posizioni che attraversano**: REPL 1,83 (n=15), C020 0,89 (n=158), C035 0,81 (n=204). Il vantaggio dell'ora 21 e' tutto nelle attraversanti, cioe' in un sorteggio sul gap di riapertura: non lo conto.

### 3.8 Regime di prezzo [DERIVATO su proxy HistData; NON e' il feed BCM]
Ho calcolato l'EMA100 di H1, H4, D1 sulle chiusure M1 HistData dal 2022 (server UTC+1, ultimo bucket completo prima dell'ingresso, nessun look-ahead) e classificato ogni operazione come concorde o contraria col suo lato. **Controllo del mio strumento**: il lato dell'operazione coincide col segno (chiusura M1 - EMA100 M1 ricostruita) nel **95,1%** dei casi; il 5% di scarto e' la differenza HistData/BCM (0,011% di prezzo) piu' il seme dell'EMA: l'allineamento a TF alto e' una **stima**, non un fatto.

| cella | EMA100 | concordi n / PF_V | contrarie n / PF_V | concordi per tranche T1 / T2 / T3 |
|---|---|---|---|---|
| C035 | H1 | 4.136 / 0,886 | 3.284 / 0,735 | 0,78 / 0,81 / 1,01 |
| C035 | H4 | 3.971 / 0,885 | 3.449 / 0,744 | 0,82 / 0,85 / 0,95 |
| C035 | D1 | 3.834 / 0,888 | 3.586 / 0,753 | 0,73 / 0,85 / 1,03 |
| REPL | H1 | 554 / **1,007** | 379 / 0,667 | 0,96 / 0,79 / 1,10 |
| REPL | H4 | 526 / 0,833 | 407 / 0,881 | 0,67 / 0,81 / 0,87 |
| REPL | D1 | 483 / 0,804 | 450 / 0,901 | 0,67 / 0,73 / 0,86 |

Lettura: sulla C035 la direzione e' concorde nei tre TF (+0,07 circa) e **sempre sotto 1**; sulla REPL l'H1 sporge a 1,007 e H4/D1 vanno al contrario: **una cella che sporge e le vicine no = picco, non altopiano**. Lato (R1B): BUY 0,89-0,91, SELL 0,76; **nel trimestre di ribasso T2 (-16%) BUY e SELL fanno lo stesso (0,78-0,79 su C0xx)**: il motore non e' un seguitore di trend. Questo e' un contro-esempio alla tesi "evitiamo gli short nel toro e guadagniamo nel ribasso": nel ribasso gli short non guadagnano. Quella tesi puo' reggere solo in forma di concordanza (MR3), non di lato.

### 3.9 Sovrapposizione fra le due scoperte post-hoc del piano [MISURATO]
REPL: i primi trade del giorno (n=168, PF 1,293) sono quelli del piano sez. 1.7; la fascia 12-14 (PF 2,03, n=89). **Si sovrappongono solo in parte**: 30 trade sono in entrambi; i primi-del-giorno entro 12-14 hanno PF 2,49 (n=30) e gli altri trade 12-14 hanno PF 1,90 (n=59). Quindi non e' "la stessa scoperta contata due volte": sono due letture parzialmente indipendenti, **entrambe sostenute da T3 (PF primo-del-giorno T1 0,68 / T2 0,99 / T3 2,26) e sono entrambe POST-HOC**. Nessuna entra nelle proposte.

---

## 4. LE PROPOSTE, UNA PER UNA (attese scritte PRIMA di qualunque numero nuovo)

**Regole comuni congelate ora** (non si cambiano dopo i numeri):
- Una variabile per file prova; cella neutra = comportamento identico a oggi; ogni file ha la sua cella neutra come controllo tecnico (vale come cancello di determinismo: deve riprodurre i numeri di R1A sulla stessa tranche, per es. REPL T1 n=128, PF 0,83).
- **R-A (merito)**: un filtro "migliora" se, sulle stesse tranche e sulla stessa cella, **PF_V(filtrato) - PF_V(neutro) >= +0,05** sul totale **e** >= 0 in almeno 2 tranche su 3 (o 4 su 6 nel lotto di validazione); un filtro che toglie piu' del 40% delle operazioni e' **selezione, non miglioramento** (S9) e si scrive cosi'.
- **R-B**: **a un filtro non si assegna mai "regge"**; "regge" e' solo la regola S8 firmata (PF_V > 1,0 in OGNI regime con >=150 operazioni, long e short separati). Un filtro che porta il PF da 0,82 a 0,87 non e' un edge.
- **R-C (rischio, igiene)**: si legge a qualunque n (R59, Emendamento B).
- **R-D (frequenza)**: la REPL fa 4,8 operazioni/giorno; un filtro che la porta sotto 3,0/giorno e' contro l'obiettivo di frequenza della challenge e va dichiarato.
- Tick reali (Modello 4), XAUUSD M1, lotto fisso 1,00, deposito 1.000.000, tranche T1/T2/T3 di R1A (per la REPL e la C035), stessi pin e stesso EA SHA 1381e3dc. **Mai sul VPS.**

### 4.1 MR0 - Validazione "per fetta" (zero passate)
- **Idea**: l'effetto di un filtro orario sul sottoinsieme che resta e' (a meno dell'effetto di sequenza "una posizione per volta") il PF delle operazioni nelle ore che restano. Il lettore `leggi_gba_r0.py` stampa gia' la tabella S6 per fascia **a orologio uniforme** (esclude 27/10/2024-02/02/2025) sulle 12 passate di R2REG. Quindi le ipotesi si possono CONGELARE oggi e leggere senza una passata nuova.
- **Ipotesi congelate (data 10/10/2026, prima di R2REG)**:
  - H-EU: la fascia europa 07-12 e' debole sulla **C035** in T4-T9. **Attesa**: PF_V europa <= 0,85 in almeno **4 tranche su 6** (ciascuna con n >= 150: proxy C035 ~280-510 operazioni di europa a tranche), PF_V poolato europa 0,55-0,85, e **PF_V europa < PF_V del resto** in almeno 4 tranche su 6. **Smentita**: PF_V poolato europa >= 0,95, oppure europa < resto in <= 3 tranche su 6 -> MR2 non parte e H-EU e' "specifica del 2026".
  - H-ROLL: il rollover 22-24 e' debole. **Attesa**: PF_V <= 0,75 (n atteso C035 poolato ~300-400: la fascia e' assente d'inverno), costo mediano < 13,3x. **Smentita**: PF_V >= 1,0 con n >= 150. (Solo come conferma di MR1: MR1 non dipende dal PF.)
  - H-PAUSA: la fascia 12-14 NON e' positiva in modo stabile. **Attesa**: PF_V poolato 0,85-1,10, segno > 1 in <= 2 tranche su 6, **piu' alto d'inverno che d'estate** (3.6). **Smentita**: PF_V >= 1,10 con n >= 150 in >= 4 tranche su 6 (allora diventa un'ipotesi viva da misurare con una finestra).
  - H-ASIA: la notte 00-07 NON e' positiva a M1. **Attesa**: PF_V poolato 0,80-1,00 (C035). **Smentita**: >= 1,05 con n >= 150 in >= 4 tranche su 6.
- **Limite dichiarato (e pesante)**: sulla **REPL il 2024-25 e' quasi vuoto** (proxy n=216 su 6 tranche, `GBA_R2_REGIME` E1): le fasce REPL hanno n < 100 = SOSPESE. **La validazione dell'ora e' quindi SOLO sulla C035**, cioe' su breakout a bassa volatilita' (ATR M1 0,65-1,8) e a costo ESCLUSO (8-17x): prova che un **effetto orario esiste o no su quella popolazione**, non che valga sulla REPL. Va scritto cosi' nel verdetto.
- **Condizione**: R2REG deve passare il cancello (a oggi strato 2 FAIL, commit 14e28ff4 / c85ccf7c). Se non parte, MR0 e' "NON MISURATO" e MR2 resta in attesa.
- **Costo**: 0 passate. **T0**: C035 fa ~37 operazioni/giorno, europa ~21%: 150 operazioni di europa in ~19 giorni di mercato dal 01/10 (verso fine ottobre); REPL europa (14% di 4,8/giorno) ~220 giorni: **non misurabile in avanti**.

### 4.2 MR1 - Blocco della pausa giornaliera (igiene)
- **Input**: `InpHourEnd` (int 0-24), `InpHourStart` fisso a 0. **Tipo**: ora SERVER d'ingresso (esclusa). **Neutro**: 24 (= default compilato, R1A). **Valori**: **22** (niente ingressi da ora 22), **21** (niente ingressi da ora 21). Non si prova altro: due valori derivano da un fatto del broker (pausa 22:00-23:00), non da una griglia.
- **Meccanismo**: le posizioni aperte vicino alle 22 attraversano la chiusura, l'EA non riesce a muovere lo SL ne' a chiudere a tempo e riprova ogni minuto (3.7); gli ordini inviati a ora 21-23 vengono rifiutati. Fermare gli ingressi prima impedisce la causa. `InpHourEnd = 22` toglie gli ordini rifiutati a ora 22/23 ma **non** le attraversanti (nascono a ora 21: 26 su 27 in C035); `InpHourEnd = 21` toglie anche quelle.
- **Attesa (REPL, 3 tranche poolate, riferimento R1A n=933, PF_V 0,855)**:
  - End=22: n 915-930 (-1%), PF_V 0,83-0,87, posizioni attraversanti invariate (4), ordini rifiutati T3 da 8 a **0-2**.
  - End=21: n 895-910 (-3%), PF_V 0,81-0,86 (stima per sottoinsieme 0,836), **posizioni attraversanti 4 -> 0**, righe 10018 in T3 da 179 a **<= 10**.
  - C035 T3 (cella-potenza per gli errori): End=21: n -6%, attraversanti 27 -> **<= 1**, righe 10018 da 415 a **<= 60**, PF_V poolato 0,80-0,83 (T3 da sola 0,84-0,88).
- **Smentita**: con End=21 piu' di 1 posizione attraversante per cella, o righe 10018 che calano meno dell'80%, o |dPF_V| > 0,05 (allora l'ora 21 non e' neutra o la sequenza conta piu' del previsto).
- **Corsia**: rischio/igiene (R-C): **non si decide sul PF**. Si adotta End=21 se tutte e tre le condizioni sopra sono vere; End=22 solo come ripiego. **Il blocco a minuti (21:45) richiede codice** e non serve: a ore intere si ottiene il 96% dell'effetto. Se un domani servisse anche la chiusura forzata prima della pausa, e' codice nuovo (piano R2 sez. 2, "meccanismi che non esistono").
- **Costo**: REPL T1-T3 x {22, 21} = 6 passate; C035 T3 x {21} piu' una cella neutra di controllo REPL T1 = 2: **8 passate, ~7 min** (48 s REPL, 56 s C0xx). **Costo di frontiera**: invariata (49-51x REPL).
- **Validazione fuori campione**: l'effetto e' strutturale (chiusura del broker), non statistico: si controlla nei giornali di R2REG (T8-T7 d'inverno 2024-25, a costo zero) e nel giornale live del runner (sola lettura). Nessun PF da validare.
- **Orologio**: tutta la tabella e' in ora server; nelle tranche 2024 prima del cambio (T9, T8, T7 fino a una data fra il 26/12/2024 e il 02/02/2025) la pausa del forex era un'ora spostata e per l'ORO e' [NON MISURATO]; il blocco a ora 22/21 e' comunque un fatto del tester su quella tranche, da leggere tranche per tranche.

### 4.3 MR2 - Esclusione della mattina europea 07-12 (una finestra)
- **Input**: `InpHourEnd`, con `InpHourStart` fisso a **12** nel file. **Neutro**: `InpHourEnd = 12` (inizio = fine = **nessun filtro** per `GbaOraOk`, r.248-253: `if(hStart == hEnd) return true`). **Valori**: **12** (neutro), **7** (finestra a cavallo della mezzanotte: ore 12..23 e 0..6 ammesse, 07-11 escluse). Una sola cella non neutra, scelta dalla regola "fascia S6 con segno concorde 3/3 e sopra la soglia corretta in R1B" (europa e rollover soli); il rollover e' gia' in MR1.
- **Meccanismo**: **[INFERITO, non provato]** la mattina europea ha rotture di canale di 48 minuti che rientrano (dopo l'apertura di Londra e la liquidita' del fixing), quindi l'ingresso a favore della rottura perde piu' del costo. Il dato dice solo: PF 0,52-0,61 su 886-1578 operazioni, r medio -0,14 R (lordo del costo ~-0,10 R), concorde in 3/3 tranche e in entrambe le stagioni (3.6).
- **Attesa (scritta prima, REPL)**: n 780-820 (-14%, stima per sottoinsieme 801 +- effetto sequenza), PF_V **0,88-0,93** (stima per sottoinsieme 0,915, ridotta della selezione "migliore di 6": guadagno atteso ~+0,03 netto); frequenza 4,1/giorno. **C035**: n 5.600-6.100, PF_V 0,84-0,88 (sottoinsieme 0,868). Per la regola R-A servono **>= +0,05** sul totale: **atteso borderline** (+0,03...+0,06): e' un'attesa onesta che MR2 possa NON passare R-A anche se H-EU e' vera.
- **Smentita**: H-EU smentita in MR0 (sez. 4.1); oppure in R2REG-per-fetta europa >= resto; oppure nella cella REPL il PF_V (filtrato) < PF_V (neutro) in 2 tranche su 3.
- **Costo**: REPL T1-T3 x {7} = 3; C035 T1-T3 x {7} = 3; neutri di controllo (REPL T1, C035 T1) = 2: **8 passate, ~7 min, SOLO se MR0 conferma**. Costo di frontiera: REPL invariata (49,6x europa); C035 FRA.
- **Validazione fuori campione**: T4-T9 per fetta (MR0, 0 passate) e, se serve una passata vera, C035 con `InpHourEnd = 7` su T4-T9 (6 passate, ~6 min); T0 in avanti sulla C035 (150 operazioni di europa verso fine ottobre).
- **Orologio**: nelle tranche T9-T8-T7 la fascia 07-12 server prima del cambio d'orologio e' UTC 07-12 d'inverno, non 06-11: l'europa e' spostata di un'ora; la tabella a orologio uniforme del lettore (esclude 27/10/2024-02/02/2025) e' quella da usare. In avanti: dal 25/10/2026 il server (UTC+1) coincide con l'ora italiana e l'apertura di Londra scivola a 09:00 server: la finestra 07-12 la contiene comunque (08:00 estate, 09:00 inverno).

### 4.4 MR3 - Concordanza col trend di TF alto (regime di prezzo oggettivo)
- **Input**: `InpTrendTF` (ENUM_TIMEFRAMES, oggi "[APERTO]" nel sorgente). **Neutro**: 0 = `PERIOD_CURRENT` = TF del segnale (comportamento di oggi). **Valori**: **H1, H4, D1** (valori numerici MQL5 `PERIOD_H1 = 16385`, `PERIOD_H4 = 16388`, `PERIOD_D1 = 16408` **[da far verificare al cancello contro la documentazione prima di scrivere la prova]**), con `InpEmaPeriod = 100` fisso. Tre valori, ognuno con significato (circa 4 giorni, 17 giorni, 5 mesi): non una griglia.
- **Meccanismo**: il canale di 48 barre M1 dice "rottura"; l'EMA100 di un TF alto dice da che parte sta il mercato "grande"; si entra solo con la rottura a favore. **Letture dell'EA**: `GbaShiftChiusa()` prende la barra chiusa del TF dell'EMA all'istante `t0` (nessun look-ahead). **ATTENZIONE**: `InpTrendTF` **sostituisce** l'EMA100 di M1, non si somma. Siccome una rottura di 48 barre sta quasi sempre sopra la sua EMA100 di M1 (condizione quasi non vincolante) l'effetto e' **[INFERITO]** simile a un filtro aggiuntivo; **quanto l'EMA di M1 vincola oggi e' [NON MISURATO]** (il giornale stampa solo i segnali con rottura valida). Se si volesse la versione AGGIUNTIVA (EMA di M1 e EMA di TF alto insieme) servirebbe codice: `InpRegimeTF` / `InpRegimePeriod`, default spento.
- **Collisione con la regola del 19/08**: `InpTrendTF` e' un parametro d'ingresso. La si legge cosi': **tre valori fissati a priori su un meccanismo (non un asse fitto), da pagare con la validazione per regimi**; se il cancello la considera un allargamento, **e' la prima da tagliare**.
- **Attesa (scritta prima, REPL, 3 tranche poolate)**: n **450-700** (stima per sottoinsieme H1 554, H4 526, D1 483); PF_V in **0,78-1,05** per tutti e tre i valori, centro 0,88; nessuno sopra 1,03 con n >= 150 in 2 tranche. Lato: miglioramento concentrato negli SELL (contro-trend nel toro). **Ipotesi alternativa** (il regime di prezzo salva il motore): PF_V >= 1,15 con n >= 300 in 2 tranche su 3 e long e short entrambi > 1,0.
- **Smentita dell'ipotesi alternativa**: qualunque dei tre valori con PF_V <= 1,03 (S8) in tutte le tranche; se l'unico che sporge e' H1 (come nel sottoinsieme: 1,007) e H4/D1 no, e' un picco e si scrive "picco".
- **Costo**: REPL x 3 TF x 3 tranche = **9 passate (~8 min)**. Stadio 2 **condizionato** (solo se un valore REPL arriva a PF_V >= 0,95 con n >= 150): C035 per H1 e H4 su T1-T3 = 6 passate (~6 min). Stadio 3 (validazione T4-T9): solo C035, 6 passate per il valore sopravvissuto. Frontiera di costo invariata (lo stop e l'ATR restano di M1).
- **Validazione fuori campione e per regime**: i tre regimi si leggono con la regola del lotto R2REG (4 toro / 4 laterali / 1 ribasso su 9 trimestri): **ribasso = 1 trimestre (T2): "NON MISURATO" sotto 150 operazioni**, lato per lato (S8). La REPL e' vuota nel 2024-25, quindi i regimi 2024-25 si leggono solo sulla C035.

### 4.5 MR4 - Pavimento di ATR RELATIVO (richiede codice)
- **Perche' non e' un'ora zero**: la REPL e' un filtro di volatilita' ASSOLUTA (`spread/ATR <= 0,05` = ATR >= ~4,2 USD); nel 2024-25 (ATR M1 0,65-1,35) e' **vuota**, quindi il criterio per regimi (>=150 operazioni) non e' misurabile dove serve. Un filtro relativo (l'ATR attuale nell'ultima fascia della sua storia recente) darebbe un'attivita' paragonabile in ogni regime.
- **Input nuovi (NON esistono; richiede `mql5-ea-developer` e cancello su Opus)**: `InpAtrPctMin` (double 0-100, default **0 = spento**), `InpAtrPctBars` (int, finestra del percentile, default 7200 = 5 sedute M1, fissata a priori). Valori: **0, 50, 75**. Alternativa non proposta ora: rapporto ATR veloce/lento (richiede due ATR).
- **Attesa**: PF_V(percentile >= 50) - PF_V(tutto) in **[-0,03; +0,06]**; n 45-55% e 22-28% del neutro. **Dato di partenza (POST-HOC)**: i terzili dell'ATR entro la tranche (C035) sono 0,834 / 0,723 / 0,858 e non crescono. **Smentita** (il filtro serve): terzile alto PF_V >= 1,05 in 2 tranche su 3 e monotono. **Beneficio vero**: portare la cella a n >= 150 per regime fuori dal 2026.
- **Costo**: codice + gate + 3 valori x 6 tranche T4-T9 su C035 = 18 passate (~17 min) [solo dopo MR2/MR3 o su richiesta di Claudio]. **Priorita' 5.**

### 4.6 NON PROPOSTE (con il numero accanto)
| ipotesi | perche' non | numero |
|---|---|---|
| Giorno della settimana (`InpDayMask`, codice) | nessun effetto, e l'input non esiste | p = 0,90 (REPL) / 0,74 (C035); ven pom n=464 PF 0,84; lun mat n=814 PF 0,75 vs 0,817 |
| Filtro di spread (`InpSpreadMaxATR`, `InpSpreadMax` assoluto) | inerte | R1B 0,83/0,82/0,82; classi di spread 0,74-0,87 senza forma |
| Notte 00-07 a M1 (`InpHourEnd = 7`) | gia' letta nel lettore: non positiva | PF_V 0,94 (REPL n=142, sospesa), 0,87-0,92 (C0xx, n 922-2441); 17,3x C035 = FRA. M5 e' R2N |
| Sole ore buone (asia + pausa + pomeriggio) | selezione | 1,115 e' p = 0,055 contro il caso (3.3) |
| Pavimento ATR >= 7 (`InpSpreadMaxATR` 0,03 o 0,02) | non validabile fuori T3 | n=157+114, PF 0,98 / 0,86, 85% in T3; il 2024-25 e' vuoto per costruzione |
| Settimane/DST ancorate agli eventi (finestra che segue Londra/NY con l'ora legale) | richiede codice; l'europa e' gia' debole in entrambe le stagioni | pausa 1,07 inverno / 0,86 estate sulla C035 |

### 4.7 Riserva: USA apertura 14-17 (NON nei cinque)
La REPL ha PF_V 0,70 (n=381, 41% di tutte le operazioni, segno 3/3, p=0,009 contro soglia 0,0083 = **borderline**); sulle celle grandi 0,78-0,80 con p = 0,046 / 0,015 / 0,012 "non distinguibile da zero". Escluderla e' esprimibile come `InpHourStart = 17` fisso, `InpHourEnd` in {17 neutro, 14}. Sulla REPL darebbe 0,957 (il "migliore di 6" osservato) ma **P = 0,23 contro il caso** e toglierebbe il 41% delle operazioni (S9: selezione, frequenza sotto 3/giorno). **Si apre solo se MR0 dice che USA apertura e' < 1 in >= 4 tranche su 6.**

### 4.8 Cross-reference: il tetto di 1 operazione al giorno
Gia' nel piano R2 (sez. 1.7) come ipotesi di rischio post-hoc. Il mio contributo e' la misura di sovrapposizione con la pausa 12-14 (3.9): parziale, non identica. **Non e' un filtro di contesto**; resta dov'e'.

### 4.9 Segnalazione a Claudio (non e' un parametro): il "fade" in Europa
Se il lordo di costo dell'europa e' -0,10 R su 1.578 operazioni (r medio netto -0,136, SE 0,020, cluster per giorno 0,019: ~7 errori standard sotto zero netto, ~5 al lordo), allora **l'ingresso rovesciato** nella stessa fascia avrebbe un lordo simmetrico di **+0,10 R** meno ~0,04 R di costo: **+0,06 R per operazione, PF ~1,1** [DERIVATO grezzo; la simmetria NON e' garantita perche' lo stop-trailing-BE non e' simmetrico: e' il controesempio]. Sarebbe un **MECCANISMO nuovo sulla stessa inefficienza** (regola della seconda caccia del 19/08, non "parametri diversi"): ingresso opposto alla rottura nella fascia 07-12. Servirebbe codice (`InpInvertSignal`, `InpInvertHourStart/End`), la lista dei caduti (0 occorrenze GBA) e una misura a tick reali in R2REG per fetta. **Non lo metto nei cinque**: dipende da MR0, parte da un'ipotesi non verificata (perche' l'europa perde e' [INFERITO]) e ha il rischio di essere un artefatto della struttura di uscita. Lo scrivo perche' "non accontentarsi": se H-EU regge nel 2024-25 su 4 tranche su 6, e' la prima cosa da provare.

### 4.10 Lato (`InpAllowLong/Short`) e regime
BUY 0,89-0,91, SELL 0,76 su R1B (SELL peggiore in T1 e T3, **uguale in T2**: ribasso). Non lo propongo come filtro: la regola S8 legge long e short per regime e R2REG dara' 4 toro / 2 laterali: se SELL < BUY solo nei toro, la forma giusta e' la concordanza di MR3, non `AllowShort = false`.

---

## 5. TABELLA ORDINATA PER BENEFICIO/COSTO (tutte le ipotesi esaminate)

| rango | ID | ipotesi | passate | beneficio atteso (numero) | rischio di illudersi | verdetto |
|---:|---|---|---:|---|---|---|
| 1 | MR0 | validazione per fetta in R2REG | 0 | decide MR2 e conferma MR1/H-PAUSA/H-ASIA | popolazione C035, non REPL | PROPOSTA (dipende dal cancello R2REG) |
| 2 | MR1 | `InpHourEnd` 22/21 | 8 | attraversanti 4->0 / 27->=1; 10018 179->=10 | nessuno sul PF (corsia rischio) | PROPOSTA |
| 3 | MR2 | europa fuori (Start 12, End 7) | 8 (cond.) | PF +0,03 netto selezione, n -14% | guadagno sotto R-A (+0,05) | PROPOSTA CONDIZIONATA |
| 4 | MR3 | `InpTrendTF` H1/H4/D1 | 9 (+6) | PF 0,85-1,05, n -40% | picco H1 (1,007) con H4/D1 opposti | PROPOSTA (tagliabile) |
| 5 | MR4 | ATR percentile | codice + 18 | misurabilita' tra regimi, PF ~0 | costruire codice per niente | IN CODA |
| - | 4.7 | USA apertura fuori | 8 (cond.) | PF +0,10 REPL in scoperta, P=0,23 | selezione, -41% operazioni | RISERVA |
| - | 4.9 | fade in Europa | codice | +0,06 R/operazione [DERIVATO] | simmetria dell'uscita | SEGNALAZIONE |
| - | 4.6 | giorno / spread / asia / sole ore buone / ATR 7 | - | nessuno misurabile | - | NON PROPOSTE |

---

## 6. CONFRONTI MULTIPLI: QUANTE LETTURE HO FATTO (e quale soglia ne segue)
Dichiaro la famiglia perche' tutto qui e' POST-HOC su 2026: 6 fasce x 4 celle, 6 esclusioni, 63 sottoinsiemi, 5 giorni x 2 celle, 2 celle a priori (ven pom, lun mat) x 3, 9 classi di ATR x 3 celle, 3 TF x 2 celle x 2 lati (trend), 2 stagioni x 6 fasce, ~10 classi di spread. **Circa 150-200 letture**. Con una correzione di Bonferroni piena la soglia sarebbe ~0,0003: **solo l'europa della C035 la supera** (PF 0,61, intervallo per giorno [0,50; 0,72]; r medio -0,136 su n=1.578, SE 0,020 = circa 7 errori standard dal nulla); la REPL e il resto no. Soglie di casa: 6 fasce -> 0,0083; 5 giorni -> 0,01; 30 celle fascia x giorno -> 0,00167 (solo C035). **Il lavoro statistico vero e' pagato da MR0 (T4-T9) e T0, non da questo dossier.**

---

## 7. COSTO IN TEMPO MACCHINA (PC di backtest `DESKTOP-H4D7CAJ`, mai VPS)
Ancora: 43-53 s a passata (R1A), 56 s (R1B), Modello 4.
| lotto | passate | tempo | condizione |
|---|---:|---|---|
| MR0 | 0 | 0 | R2REG fatto |
| MR1 | 8 | ~7 min | driver generalizzato |
| MR2 | 8 | ~7 min | MR0 conferma H-EU |
| MR3 stadio 1 | 9 | ~8 min | - |
| MR3 stadio 2 (C035) | 6 | ~6 min | REPL >= 0,95 con n >= 150 |
| MR3 stadio 3 (T4-T9 C035) | 6 | ~6 min | stadio 2 passa |
| MR4 | 18 | ~17 min | codice + cancello |
| **Totale caso centro (MR0+MR1+MR2+MR3 stadio 1)** | **25** | **~22 min** | |
**Lavoro preliminare (non macchina)**: generalizzare `GBA_R0_PASSATE.ps1` (una chiave per file dichiarata: la v4 rifiuta qualunque cella che non sia `InpSpreadMaxATR`) e `leggi_gba_r0.py` (pin di file con `InpHourStart` diverso da 0 in MR2: la cella neutra End=12 deve essere accettata dal controllo "REPL = pin"). Ogni riga passa dai due strati del cancello. **Nessuna spesa.**

---

## 8. COSA NON HO VERIFICATO (buchi dichiarati)
1. **Nulla e' stato eseguito, compilato o provato nel tester.** Tutte le stime "per sottoinsieme" ignorano l'effetto di sequenza (una posizione per volta: togliere un'operazione puo' liberare il segnale successivo): errore atteso +-3% su n e +-0,03 su PF, non stimato.
2. **I miei script non sono in repo** (commit consentito a un solo path): vanno archiviati o rifatti. Dipendono da `leggi_gba_uscite.operazioni()` (gia' una bozza non passata dal cancello, `GBA_R2_PIANO` buco 8) e da `proxy_gba_r2reg.carica()`.
3. **Il test di permutazione orario mescola le etichette entro il giorno**: conserva l'effetto-giorno ma rompe la correlazione fra operazioni vicine nello stesso giorno, quindi il null e' un po' troppo stretto e i p-value un po' troppo piccoli (anti-conservativo). Per il giorno della settimana ho usato i blocchi di giorni, piu' fedele.
4. **Il trend di TF alto e' sul proxy HistData**, non sul feed BCM (concordanza del lato 95,1% con l'EMA M1 ricostruita). Quanto l'EMA di M1 vincoli oggi i segnali e' [NON MISURATO].
5. **I valori numerici dell'enum TF** (16385/16388/16408) sono dalla mia conoscenza di MQL5, non da una compilazione: lo verifica il cancello.
6. **L'anatomia della pausa (trading chiuso 22:00-23:00 server tutto l'anno, dati assenti 23:00-24:00 d'inverno) e' [INFERITA] dal tester 2026**: non l'ho letta dalle specifiche del simbolo BCM ne' dal live; il giornale del runner (sola lettura) la confermerebbe in un minuto. La durata della chiusura nel tester arriva a 22:50 (mediana) e 23:09 (massimo, 29/03, giorno del cambio d'ora UE).
7. **Dati 2024-25**: nessun PF del 2024-25 esiste (R2REG non e' girato). Tutte le attese di MR0/MR2 sul 2024-25 sono proiezioni; lo spread BCM del 2024-25 e' [NON MISURATO] (`GBA_R2_REGIME` B15) e l'orologio dell'ORO prima del 2025 pure (B16).
8. **R2REG ha il cancello strato 2 in FAIL** all'ultimo commit visibile (14e28ff4 / c85ccf7c); non so se e' stato riparato. MR0 e MR2 dipendono da questo.
9. **T0** (dal 01/10/2026): non ho verificato che il tester abbia i tick fino a oggi; i volumi di operazioni sono stime da R1A (4,8/giorno REPL, 37/giorno C035).
10. **Emiliano**: le ore notturne non sono dette (`EA_NOTTURNO_GBA_SPECIFICA` r.54); nel suo pannello c'e' un pulsante "SESSIONE ON" [NON CHIARO se e' un filtro di sessione]. Roberto/"Onam" [DICHIARATO DA TERZI]: nessun suo numero e' usato.
11. **Non ho misurato**: lato x fascia (BUY/SELL per ora), ora x trimestre oltre alle due stagioni, uscite per fascia (il motivo d'uscita per ora), il rapporto ATR veloce/lento (richiede due ATR: non c'e' nei log), l'interazione fra filtro orario e tetto giornaliero, la sensibilita' a latenza (ExecutionMode=0, ottimistico).
12. **Nessun secondo lettore indipendente**: prima di consegnare, il cancello deve rifare a mano almeno la tabella 3.1 (da un report), la permutazione 3.2 su una cella e il conto delle 27 attraversanti.

---

## 9. COSA SERVE DA CLAUDIO (nessuna spesa)
1. Il via a **generalizzare driver e lettore** (una chiave per file): senza, MR1/MR2/MR3 non partono. E' lavoro, non macchina; gia' chiesto nel piano R2.
2. **Se leggere sez. 8 del piano R2 alla lettera** (solo MR0+MR1) **o come qui** (MR2/MR3 condizionati). Decisione di metodo.
3. A Emiliano (se si puo'): **che ore intende per "di notte"** e cosa fa "SESSIONE ON" nel suo pannello. Un'ora vera vale piu' di tutte le finestre che possiamo provare.
4. Nessun cambio a conti, preset, taglie o forward: **questo dossier non ne propone nessuno**.
