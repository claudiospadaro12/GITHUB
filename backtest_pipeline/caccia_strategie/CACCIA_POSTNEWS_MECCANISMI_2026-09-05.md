# 🎯 SECONDA CACCIA POST-NEWS — meccanismi ALTERNATIVI sullo stesso evento

> **Caccia del 05/09/2026.** Applicazione della **Regola della seconda caccia**
> (`CLAUDE.md`) dopo che il motore `ABTG_PostNews` (due pendenti STOP sul range
> post-notizia) e' uscito **PF < 1 su quattro letture pulite**: blocco ISM 15:00
> su EURUSD (IS 0,76 · OOS 0,79) e blocco 13:30 su USDJPY (IS 0,66 · OOS 0,90).
>
> Mandato: cercare **MECCANISMI diversi** sulla stessa inefficienza (fade,
> liquidity sweep, gestione diversa, altro), **mai parametri diversi del motore
> morto**.
>
> 🔒 **Nessun EA scritto o toccato. Nessun `.set`. Nessun file prova. Nessun
> backtest lanciato. Nessuna sedia viva toccata.** Il mandato non chiede un
> round: consegno **solo il dossier** (piu' le sonde archiviate).
>
> Letti per intero prima di uscire: `REGISTRO_TEST.md` (1.153 righe) ·
> `CACCIA_NOTIZIE_TASSONOMIA_2026-09-03.md` · `CACCIA_CANDELA_NEWS_2026-09-03.md` ·
> `CACCIA_POSTNEWS_ALTRE_FAMIGLIE_2026-09-04.md` · `SETACCIO_MANUALE.md` ·
> `prove/POSTNEWS_ISM_00_conta.txt` · `prove/POSTNEWS_1330_00_conta.txt` ·
> `mql5/Experts/ABTG_PostNews.mq5`.

---

## 0. 🔴 LE SETTE RIGHE CHE CONTANO, SUBITO

1. 🧪 **Questa volta non ho letto opinioni: ho MISURATO.** Su
   **686 giornate-evento su EURUSD** e **683 su XAUUSD** (2010-2020, barre M1),
   ho fatto girare **7 varianti di meccanismo** sullo stesso evento, ognuna col
   suo **controllo a ingressi casuali** (regola di casa dal 03/09). §3-§5.
2. 🪦 **IL FADE E' MISURATO E NON FUNZIONA.** Era il suggerimento n.1 del
   mandato. Sul blocco ISM e' **PF 0,85 (t −1,26)** su EURUSD e **PF 0,73
   (t −2,41)** su oro; sul blocco 13:30 gira di segno e finisce **sotto il
   controllo casuale**. 👉 **Dove e' significativo, e' significativamente
   PERDENTE**; dove e' positivo, non batte il caso. §5.1
3. 🪦 **IL LIQUIDITY SWEEP E' MISURATO E NON FUNZIONA** (suggerimento n.2):
   ISM **PF 0,86**, 13:30 **PF 1,18 ma contro un controllo casuale a 1,06**, e
   tutto concentrato nel 2010-2012. In piu' quella geometria in casa e' **gia'
   morta due volte** (BreakinBox chiuso il 31/08, R95 0/30). §5.2
4. ⏱️ **L'UNICA VARIANTE CON t > 2 E' L'USCITA A TEMPO — E MUORE ALLA PROVA
   DELL'EPOCA.** Breakout + uscita a 30' sul blocco ISM: t 2,73, PF 1,57.
   Ma **il 84% del totale viene dal 2010-2011** (n=73: +574,7 pip); sul
   **2012-2020 (n=298) resta +0,36 pip per evento, t 0,61** — cioe' **sotto
   qualunque costo**. §5.3
5. 🔴 **RILIEVO SU CIO' CHE GIRA, e non e' un candidato: le due celle bocciate
   giravano con `InpUseOCO=false`, e in UNA GIORNATA SU QUATTRO scattano
   ENTRAMBE le gambe** (24,8% ISM · 23,5% 13:30). Senza OCO una giornata di
   whipsaw costa **2 stop** mentre una giornata di trend pulito paga **1,2R**.
   E' una **falla strutturale**, non un parametro da ottimizzare. §6
6. 🆕 **SCOPERTA NEI DATI DI CASA, mai notata in tre dossier notizie: i nostri
   CSV di calendario contengono FORECAST e ACTUAL.** 1.667 eventi USA ad alto
   impatto con entrambi i valori, **2021.01.05 → 2024.10.29**. E' l'unico
   meccanismo del mandato che **non ho potuto misurare** (i prezzi della fonte
   esterna finiscono nel 2020-05: **zero sovrapposizione**). §7
7. 🎯 **Conclusione onesta: NON promuovo nessun meccanismo per un round.**
   Il primo passo utile non e' un backtest, e' un **ATTREZZO**: esportare il
   calendario nativo MT5 con actual/forecast. §8-§9

---

## 1. 🎯 CONTROLLO POSITIVO — fonte per fonte

| fonte | bersaglio noto | esito |
|---|---|---|
| **arXiv API** (`export.arxiv.org`, **https**) | `cat:q-fin.TR` → 3 titoli veri | ✅ **PASSA** — ⚠️ solo in **https**: in **http** risponde **301 con 0 byte** (trappola nuova, da scrivere) |
| **raw.githubusercontent.com** (FutureSharks) | `EUR_USD/2015/…-3.csv` → **200, 1.650.996 byte, 30.472 barre M1** | ✅ **PASSA** — e' la fonte di ogni misura di questo dossier |
| **github.com/search** (UI) | `"economic calendar" trading bot` → **4 repo veri** con nome e stelle | ✅ **PASSA** (dopo un 429 e attesa) |
| **mql5.com** Code Base lista experts | 12 titoli veri | ✅ **PASSA** |
| **mql5.com** pagina singola (`/code/52977`) | autore, date, descrizione | ✅ **PASSA** |
| **arxiv.org/pdf** (2508.06788) | PDF scaricato, **808 righe di testo estratte** | ✅ **PASSA** |
| **api.github.com** | `search/repositories` | 🔴 **403 — "sessions are bound to their configured repositories"**. L'API **non e' usabile** da qui: si usa la UI. **Fatto nuovo, da scrivere.** |
| `nber.org` · `researchonline.lse.ac.uk` · `repository.bilkent.edu.tr` · `business.rutgers.edu` · `ecb.europa.eu` · `skidmore.edu` · `eprints.lse.ac.uk` · `ideas.repec.org` | paper | 🔴 **TUTTI BLOCCATI — FONTI NULLE** (8 domini, coerente coi 3 dossier precedenti) |
| **mql5.com/en/search#!keyword=...** | ricerca interna | 🔴 **NULLA**: la pagina e' guidata da JS, torna solo l'interfaccia |

📌 **Fonti dichiarate NULLE anche oggi**, per continuita': `forexfactory.com`,
`investing.com`, `ftmo.com`, `ssrn.com`, `sciencedirect.com`, `cambridge.org`.

---

## 2. 🧭 IL PERIMETRO — cosa NON riapro, e perche'

Prima di cercare, la lista dei caduti. **Niente di quanto segue e' stato
riproposto:**

| gia' chiuso | dove | perche' non lo riapro |
|---|---|---|
| **Spike & fade a 40 secondi** (Ederington-Lee 1995) | lapide 03/09 | sotto M5 e dentro la finestra vietata FTMO ±2 min |
| **Post-news drift dal minuto 30** (L1, arXiv 2605.04004) | registro r.871 | *"D127 permanently rejected — LOCKED"* |
| **Momentum candle continuation** | 03/09 | nessuna letteratura, nessuna implementazione |
| **Straddle OCO pre-rilascio** | coach Paolo 03/09 + 5 sorgenti esterni | **5 su 5 piazzano PRIMA del dato → FTMO-incompatibili al 100%** |
| **Pre-announcement drift D-1/D-2** | tassonomia 03/09 §3.A | long su indice overnight = doppione, IS da ~19 anni |
| **BreakinBox / falsa rottura** | chiuso 31/08 a tick | PF 1,007 DD 24,1% · e R95 **0/30** sulla stessa geometria |
| **Code Base come fonte di MOTORI** | caccia 31/08 | *"non aprire piu' il Code Base per cercare motori: aprirlo per gli ATTREZZI"* — ed e' esattamente cio' che ho fatto (§7.2) |
| **TradingView per il tema news** | 03/09 | Pine non ha calendario con timestamp al minuto: **fonte chiusa e motivata** |

---

## 3. 🔬 IL BANCO DI MISURA — e perche' e' credibile

**La macchina:** quattro sonde Python, archiviate in
`caccia_strategie/biblioteca/sonde_esterne/`:
`sonda_postnews.py` · `sonda_postnews_stabilita.py` · `sonda_postnews_epoche.py`
· `sonda_postnews_oro.py`.

**I dati:**
- **prezzi** — `github.com/FutureSharks/financial-data` (**GPL-3.0**), barre M1
  Oanda: **EUR_USD 3.719.294 barre** e **XAU_USD 3.594.016 barre**, entrambe
  **2010-01-03 → 2020-05-14** (125 e 128 file mensili scaricati oggi).
  🟢 **Timestamp in UTC** — verificato sull'apertura domenicale
  (`2015-03-01 22:01` = 17:00 New York in EST).
- **eventi** — `biblioteca/dati/CALENDARIO_FF_High_2010-2023_UTC.csv`,
  **anch'esso in UTC**. 👉 **Le due fonti hanno lo STESSO orologio: nessuna
  conversione di fuso, quindi nessun errore di fuso.** E' la ragione per cui
  questa misura e' piu' solida di quanto sarebbe stata su BCM.

**La replica del motore, riga per riga come le celle bocciate:**
range = max/min delle **due candele M5 chiuse** prima dell'ora d'azione
(= minuti **news+5 → news+15**, cioe' *si butta* la candela del rilascio);
**BUY STOP = max +3 pip**, **SELL STOP = min −2 pip**; **SL 25 / TP 30**;
finestra viva **news+15 → news+85** (ISM) e **news+15 → news+75** (13:30);
chiusura forzata a scadenza. **Una sola occasione al giorno** (come `gPlacedDay`).

**⚠️ I LIMITI, dichiarati e non aggirati:**
1. 🔴 **NON e' BCM.** Altro broker, altri spread, altri gap.
2. 🔴 **OHLC M1, non tick.** L'ambiguita' intrabarra e' risolta **sempre a
   sfavore** (se SL e TP cadono nella stessa barra → perdita).
3. 🔴 **ZERO costi, zero slippage, zero spread.** Tutti i numeri sotto sono
   **LORDI**. Su BCM ogni operazione va decurtata.
4. 🔴 **Finestra 2010-2020**, non 2010-2023/2024 delle celle bocciate.
5. ➡️ **Da qui escono MISURE DI OCCASIONI, mai verdetti** (regola di casa,
   `sonde_esterne/LEGGIMI.md`). **F6 non si ammorbidisce.**

**🟢 Il collaudo che rende leggibili i numeri:** il **controllo a ingressi
casuali** con la stessa geometria dà **PF 1,00 (t −0,03)** su EURUSD/ISM e
**PF 1,06 (t 0,38)** su EURUSD/13:30. **La sonda non e' sbilanciata.**

---

## 4. ⚖️ IL CONFRONTO CON LE CELLE BOCCIATE — una discrepanza che dichiaro

| | cella BCM (bocciata) | sonda esterna (oggi) |
|---|---|---|
| ISM 15:00 EURUSD, breakout OCO=off | **PF 0,76 / 0,79** | **PF 1,16**, +1,03 pip/evento |
| 13:30 EURUSD, breakout OCO=off | (la cella BCM era su **USDJPY**) | **PF 1,03**, +0,17 pip/evento |

🔴 **La sonda NON riproduce la bocciatura, e lo scrivo invece di nasconderlo.**
Le differenze possibili sono tre e **non le posso separare da qui**: broker
diverso, finestra diversa (2010-2020 contro 2010-2023), e **soprattutto i
costi** — la sonda e' lorda, la cella BCM no.

🎯 **Ma la lettura che conta e' la stessa in tutte e due:** un lordo di
**+1,03 pip per evento** su uno **stop da 25 pip** e' **0,041 R**. Il cancello
di casa (FIRMA 2, 31/08) chiede **E ≥ 0,075R NETTA**. 👉 **Il meccanismo non
arriva al cancello nemmeno prima di pagare lo spread.** Le due misure non si
contraddicono: **una dice "sotto zero", l'altra dice "sopra zero ma sotto il
costo"**. Nessuna delle due lo promuove.

📐 **E un rilievo di geometria che spiega molto:** il range post-notizia
mediano (2 candele M5) su EURUSD e' **13,2 pip** (decile 10 = 6,5 · decile 90 =
26,5). 👉 **Lo SL di 25 pip vale 1,89 volte il range che definisce il setup.**
Lo stop e' largo quasi il doppio del disegno su cui si entra.

---

## 5. 📊 LE MISURE — i tre meccanismi del mandato, uno per uno

> Tutti i numeri: **pip lordi per evento**, EURUSD, 2010-2020.
> `t` = t-statistica sulla media per evento. `anni+` = anni in utile su 11.

### 5.1 🪦 MECCANISMO A — **FADE** (si entra al CONTRARIO della rottura)

**Tesi:** *"il prezzo strappa oltre il range e poi rientra: si vende la rottura
al rialzo e si compra quella al ribasso."* Implementato come **specchio esatto**
del motore: stessi prezzi di scatto, verso invertito (ordini LIMIT invece di STOP).

| blocco | simbolo | media | t | PF | anni+ | controllo casuale |
|---|---|---:|---:|---:|---:|---:|
| ISM 15:00 | EURUSD | **−1,09** | **−1,26** | **0,85** | 5/11 | PF 1,00 |
| ISM 15:00 + uscita a tempo | EURUSD | **−1,26** | **−2,00** | **0,73** | 3/11 | — |
| ISM 15:00 | **XAUUSD** | **−$0,385** | **−2,41** | **0,73** | 3/11 | +$0,245 |
| 13:30 | EURUSD | +0,58 | 0,64 | 1,10 | 5/11 | PF 1,06 |
| 13:30 | **XAUUSD** | +$0,091 | 0,51 | 1,08 | 6/11 | +$0,114 |

🎯 **VERDETTO: SCARTO, ed e' una LAPIDE.**
- Dove il fade e' **statisticamente significativo, e' significativamente
  PERDENTE** (oro/ISM t −2,41; EURUSD/ISM+tempo t −2,00).
- Dove e' positivo (13:30), **non batte il controllo casuale** (1,10 contro
  1,06 su EURUSD; 1,08 contro **1,11** su oro — cioe' **peggio del caso**).
- **Il segno si ribalta fra i due blocchi e fra i due simboli.** Un meccanismo
  che cambia segno secondo l'evento e lo strumento **non e' un meccanismo:
  e' una moneta.**

⚠️ **E c'e' una ragione strutturale, non solo statistica:** il fade e'
l'immagine speculare del breakout **sugli stessi prezzi di scatto**. Su un
campione con costo zero i due sono quasi a somma nulla. **Non esiste un mondo
in cui il breakout perde e il suo specchio guadagna abbastanza da pagare due
volte lo spread.** 🔴 **Invertire una strategia perdente non e' un meccanismo
nuovo: e' la stessa scommessa girata, e la paga due volte.**

### 5.2 🪦 MECCANISMO B — **LIQUIDITY SWEEP / stop-hunt**

**Tesi:** *"il primo strappo oltre il range e' una spazzata di stop; si entra
nel verso opposto quando il prezzo RIENTRA nel range."* (armamento sul primo
sfondamento, ingresso al rientro, SL 25 / TP 30).

| blocco | media | t | PF | anni+ | per anno |
|---|---:|---:|---:|---:|---|
| ISM 15:00 | **−0,82** | −1,05 | **0,86** | **4/11** | 10:−139 11:−157 15:−267 |
| 13:30 | +0,86 | 1,05 | 1,18 | 7/11 | 10:+177 11:+76 12:+96 … 17:−72 18:−70 |

🎯 **VERDETTO: SCARTO.**
- Su ISM e' **negativo**. Su 13:30 e' positivo ma **contro un controllo casuale
  a PF 1,06**, e il totale e' **fatto dal 2010-2012**: dal 2013 in poi si spegne.
- 🔴 **E in casa quella geometria e' gia' morta DUE volte:** `ABTG_BreakinBox`
  chiuso a tick il 31/08 (PF 1,007, DD 24,1%, cancello DD ≤15%) e **R95 0/30**
  su EURJPY. Il registro e' esplicito: *"non si riapre cambiando simbolo"*.
  👉 Cambiare il **livello** (range della notizia invece del box notturno) **non
  cambia la geometria**: e' il terzo giro sullo stesso meccanismo.

### 5.3 ⏱️ MECCANISMO C — **GESTIONE: uscita a TEMPO invece del TP fisso**

**Tesi:** *"l'unica deriva post-notizia misurata sta nelle prime cinque barre
M5 (arXiv 2605.04004: minuti 0-25); tenere una posizione con TP 30 pip per
70-85 minuti la fa vivere quasi tutta FUORI da quella finestra."*
🟢 **Questa tesi ha un appoggio vero e gia' agli atti nel repo.**
Implementato: ingresso identico, **nessun TP**, chiusura a **news+45** (30
minuti dopo l'azione), SL 25 invariato.

| blocco | simbolo | media | t | PF | anni+ |
|---|---|---:|---:|---:|---:|
| **ISM 15:00** | EURUSD | **+1,84** | **+2,73** | **1,57** | **9/11** |
| 13:30 | EURUSD | −0,34 | −0,47 | 0,93 | 4/11 |
| ISM 15:00 | XAUUSD | +$0,437 | +3,16 | 1,72 | 7/11 |
| 13:30 | XAUUSD | −$0,152 | −1,41 | 0,79 | 2/11 |

🟢 **E' l'unica variante di tutta la caccia che supera t = 2.** Se mi fossi
fermato qui, avrei consegnato un candidato. **Non mi sono fermato qui.**

#### 🔴 LA PROVA DELL'EPOCA — ed e' quella che lo uccide

| epoca | n | media | t | PF | totale |
|---|---:|---:|---:|---:|---:|
| tutto (2010-2020) | 371 | +1,84 | 2,73 | 1,57 | **+681,4** |
| **2010-2011** | **73** | **+7,87** | **3,40** | **3,14** | **+574,7** |
| **2012-2020** | **298** | **+0,36** | **0,61** | **1,12** | **+106,7** |

🎯 **L'84% del profitto viene dal 20% del campione, e sono i due anni piu'
vecchi.** Sul **2012-2020** restano **+0,36 pip per evento lordi** = **0,014 R**
su uno stop da 25 pip. Il cancello di casa chiede **0,075R NETTI**: siamo a
**un quinto del cancello, prima di pagare un centesimo di spread.**

⚠️ **E sul blocco 13:30 la stessa gestione e' NEGATIVA su tutti e due i
simboli** (PF 0,93 e 0,79). 👉 Il segno non regge nemmeno fra due blocchi dello
stesso paese, misurati sullo stesso banco.

**VERDETTO: NON PROMOSSO.** 🟡 Resta un **lascito utile**: se un giorno il
motore verra' riacceso per altre ragioni, **la finestra viva giusta e' ~30
minuti, non 70-85** — ed e' l'unica cosa che le misure di oggi sostengono.

### 5.4 🥇 E il confronto fra SIMBOLI — la domanda che il 04/09 aveva lasciato aperta

Il dossier del 04/09 dichiarava: *"quale asset reagisce di piu' NON HA RISPOSTA
VERIFICATA"* (ABDV 2003 irraggiungibile, 3 domini bloccati). **Una risposta
parziale, misurata, oggi c'e' — ma e' scomoda:**

| | EURUSD | XAUUSD |
|---|---|---|
| breakout ISM, lordo/evento | +1,03 pip = **0,041 R** | +$0,449 = **0,100 R** |
| **controllo casuale, stesso banco** | −0,02 pip = **0,00 R** | **+$0,245 = 0,055 R** |
| **vantaggio VERO sul caso** | **+0,041 R** | **+0,046 R** |

🔴 **Sull'oro il controllo casuale guadagna da solo.** Non e' un edge del
meccanismo: e' la **deriva dell'oro** del 2010-2012, che un ingresso a caso
raccoglie quasi altrettanto bene. Depurato del caso, **oro ed EURUSD si
equivalgono, e sono entrambi sotto il cancello.**
👉 **Cambiare simbolo non salva la famiglia.** Ed e' esattamente il motivo per
cui la regola del controllo casuale e' stata scritta il 03/09.

---

## 6. 🔴 IL RILIEVO SULLE SEDIE VIVE — `InpUseOCO=false`, e una giornata su quattro

**Non e' un candidato, ed e' la cosa piu' urgente del dossier.**

Le due celle bocciate — e, per loro stessa dichiarazione, **le sedie NFP/ECB
che girano in forward** — hanno `InpUseOCO=false`:

> `prove/POSTNEWS_1330_00_conta.txt` r.207: *"niente OCO: il corso lo nega
> esplicitamente e **le sedie vive non lo usano**"*

**Quanto costa, misurato oggi:**

| blocco | eventi in cui scattano **ENTRAMBE** le gambe |
|---|---|
| ISM 15:00 | **92 su 371 = 24,8%** |
| 13:30 | **74 su 315 = 23,5%** |

🎯 **Una giornata su quattro riempie tutti e due i pendenti.** Il conto della
serva, con SL 25 / TP 30:

| giornata | con OCO | senza OCO |
|---|---|---|
| trend pulito | +30 pip (**+1,2R**) | +30 pip (**+1,2R**) |
| **whipsaw** | −25 pip (**−1,0R**) | **−50 pip (−2,0R)** |

➡️ **Senza OCO il caso peggiore raddoppia e il caso migliore no.** E' una
**asimmetria strutturale contro la strategia**, non una taratura.
Nella misura: accendere l'OCO sul blocco ISM porta la stessa cella da
**PF 1,16 a 1,26** (+0,55 pip/evento).

⚠️ **Onesta' sulla regola:** `InpUseOCO` **e' un input**, e la Regola della
seconda caccia vieta *"parametri diversi dello stesso motore morto"*.
**Lo dichiaro come tensione, non lo aggiro.** La mia lettura: non lo propongo
come **candidato di edge** (accendendolo il 2012-2020 resta comunque sotto il
cancello), lo segnalo come **rilievo di RISCHIO su cio' che gira** — ed e'
esattamente la corsia che il criterio di uscita delle sedie (18/08) tiene
aperta *"sempre, a qualunque n"*.
🔴 **Decisione di Claudio, non mia.**

---

## 7. 🆕 L'UNICO MECCANISMO CHE RESTA IN PIEDI — e non ho potuto misurarlo

### 7.1 📊 La scoperta: i nostri CSV hanno **FORECAST e ACTUAL**

Tre dossier notizie hanno descritto
`biblioteca/dati/CALENDARIO_news-*.csv` come *"tutti i paesi, impatto 0/1/2/3"*.
**Hanno due colonne in piu' che nessuno aveva letto.** Misurato oggi:

```
2021.01.08 15:30 ; United States ; 3 ; Nonfarm Payrolls (Dec) ;; 71K  ; -140K
2021.01.05 17:00 ; United States ; 3 ; ISM Manufacturing PMI  ;; 56.6 ; 60.7
                                                                 ^^^^   ^^^^
                                                              previsione  dato
```

✅ **Mappatura verificata contro verita' note:** NFP di dicembre 2020 = **−140K**
(vero); NFP di marzo 2023 = **236K** con consenso 239K (vero); ISM Manifatturiero
dicembre 2020 = **60,7** (vero). La colonna 5 (precedente) e' **vuota ovunque**.

| misura | valore |
|---|---|
| eventi USA ad **alto impatto** con forecast **e** actual | **1.667** |
| finestra coperta | **2021.01.05 → 2024.10.29** (⚠️ **NON** fino al 2025, malgrado il nome del file) |
| famiglie complete | Initial Claims **199** · CPI 92 · Core PCE 90 · NFP 46 · ISM Manu 46 · ISM Serv 46 · CB Conf 46 · Retail 46 · PPI 46 · GDP 45 |

**Aritmetica delle occasioni (giornate distinte, 3,8 anni):**

| blocco | giornate | /anno |
|---|---:|---:|
| 13:30 | 220 | 58,3 |
| 15:00 (ISM+CB) | 138 | 36,2 |
| Initial Claims | 199 | 52,4 |
| **15:00 + Claims** (si sovrappongono solo **18** volte) | **319** | **83,6** |
| **tutti e tre** | **452** | **118,5** |

🎯 **E' la prima volta che la famiglia notizie puo' vedere il pavimento di casa
(Emendamento A, ≥150 operazioni per finestra):** 452 giornate → **226 IS + 226
OOS**. 🔴 **Ma solo POOLANDO tre orari diversi** — e `InpActionHour` e' **una
costante dell'istanza** (`ABTG_PostNews.mq5` r.74-75). Preso da solo, nessun
blocco ce la fa. **Il pooling richiede che il motore legga l'ora dell'evento
dal CSV: e' una modifica al motore, gia' segnalata il 04/09 (§3.2, strada b).**

### 7.2 🧪 Il meccanismo — e perche' NON l'ho misurato

**Tesi in una riga:** *"la direzione non sta nel grafico, sta nel dato: si
prende UN SOLO lato, quello implicato dallo scarto fra actual e forecast, e
solo quando lo scarto e' grande."*
🟢 **E' l'unico meccanismo del mandato in cui il filtro E' il motore in senso
pieno** (niente sorpresa → niente trade **e** niente direzione), ed e' l'unico
che **elimina alla radice il doppio riempimento del 24%** (un ordine solo).

🔴 **NON MISURABILE DA QUI, e il motivo e' aritmetico:**
i prezzi della fonte esterna finiscono il **2020-05-14**; il calendario con
forecast/actual comincia il **2021-01-05**. **Zero giorni in comune.**
**Non ho un numero e non lo invento.**

⚠️ **E le due obiezioni che vanno scritte PRIMA di spendere un round:**
1. 🪦 **Tre misure indipendenti dicono che la sorpresa e' gia' nel prezzo molto
   prima del minuto 15.** Ederington-Lee 1995 (*"completed within 40 seconds"*,
   [INCERTO, da snippet]); **Takahashi 2025, letto oggi nel PDF**: *"Impulse
   responses indicate that shocks dissipate almost entirely within a second"*;
   Mesfin arXiv 2605.04004: la deriva e' *"just the news spike itself"*.
   👉 Entrare a **news+15** col segno della sorpresa **non e' cavalcare la
   reazione: e' scommettere sul residuo.**
2. ⚠️ **Il segno non e' stabile.** Ben Omrane & Savaser (2016, *JIFMIM* 45,
   96-114): *"sign switch effect"* — nei regimi di forte avversione al rischio
   la valuta si muove **al contrario** rispetto alla notizia di crescita, e le
   famiglie che cambiano segno sono proprio **consumi, casa, lavoro, credito**.
   [INCERTO: pagina Bilkent **bloccata**, ScienceDirect bloccato — da snippet]
   👉 **Una mappa fissa sorpresa→lato e' regime-dipendente.**

**VERDETTO: 🟡 IN CODA**, e **non come round**: come **prerequisito di dati** (§8).

### 7.3 🔧 L'ATTREZZO che lo sblocca — e vale anche per un difetto che abbiamo gia'

| | |
|---|---|
| **NOME** | `Economic Calendar CSV` |
| **FONTE** | https://www.mql5.com/en/code/52977 [VERIFICATO, pagina aperta] |
| **AUTORE / DATA** | **Stanislav Korotky (`marketeer`)** — pubblicato **22/10/2024**, aggiornato **22/11/2024** |
| **COSA FA** | script: esporta il calendario nativo MT5 in CSV, *"calendar records with most important fields"* |
| **PERCHE' CI SERVE** | e' **l'unica strada** per avere actual/forecast su una finestra piu' lunga del 2021-2024 e **fino a oggi** |
| **BONUS non richiesto** | fa **correzione di fuso/ora legale** sui timestamp storici — cioe' **proprio il difetto misurato il 04/09** (10 NFP su 174 alle 12:30 invece che 13:30, §3.2) |
| **LIMITI** | *"initial full calendar downloads may timeout"* (si rilancia); va girato **connessi**, non nel tester |

🔴 **NON e' un candidato da imbuto: e' uno script.** Non apre posizioni.
Va **letto nel sorgente prima di girarlo** — cosa che **non ho fatto**
(ho letto la pagina, non il codice: §10).
🟡 Alternativa vista, **non aperta**: `CalendarExport` (Code Base **76951**,
GianlucaGangemi, **04/09/2026** — di ieri).

---

## 8. 🏛️ IL CANCELLO PROP — una riga, e stavolta e' corta

Nessun candidato promosso ⇒ nessuna riga prop da compilare. **Ma due cose
restano vere e vanno dette:**

1. 🟢 **La famiglia "evento" resta l'unica del parco che non condivide il
   fattore di rischio con nessun'altra** (`CACCIA_CANDELA_NEWS` §6): le altre
   sedie sono guidate da un **orario** o da un **livello**. Il buco di
   portafoglio **e' reale e resta aperto** — quello che manca non e' il buco,
   e' un motore che lo riempia.
2. 🔴 **Il rilievo OCO (§6) e' un rilievo di rischio, non di merito**, e sul
   muro **giornaliero** FTMO (−5.000 su 100k) pesa: senza OCO una giornata
   whipsaw vale **2R invece di 1R**. A 0,65% per evento sono **1,30% in una
   giornata** invece di 0,65%. Non sfonda niente da solo — ma e' il doppio di
   quello che il contratto della sedia promette.

---

## 9. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

🔴 **La mia risposta onesta e': il primo passo NON e' un test.**

Su tre meccanismi chiesti dal mandato, **tre sono misurati e tre non passano**
(fade, sweep, uscita a tempo). Il quarto — la sorpresa — **non e' misurabile
con i dati che abbiamo**. Proporre un round su un meccanismo che non posso
nemmeno contare sarebbe esattamente la *"cella verde per caso"* che la Regola
della seconda caccia vieta.

**Quindi la domanda giusta e' una domanda di DATI:**

> 🎯 **"Il calendario nativo di MT5 ci dà actual e forecast su quanti anni, e
> su quali famiglie, se lo esportiamo con lo script 52977?"**

E' **una corsa di uno script sul PC di backtest**, zero rischio, zero ore di
sviluppo, e apre **tre porte in una**:
- **(a)** il meccanismo della sorpresa diventa misurabile (§7.2);
- **(b)** il calendario di casa si allunga oltre il **2023/2024** — oggi
  **ogni** misura news del repo poggia su un estratto che finisce li';
- **(c)** si chiude il difetto DST (10 NFP su 174 fuori posto, §7.3).

⚠️ **Se invece si volesse comunque un round subito**, l'unica cella difendibile
**non e' un meccanismo nuovo**: e' il **rilievo OCO** del §6 — ed e' una
decisione di Claudio, perche' tocca una sedia viva e sfiora la lettera della
Regola della seconda caccia.

🔴 **Non ho scritto nessun file prova.** Il mandato lo chiede solo *"se il
mandato di un round futuro lo chiede esplicitamente"*: non lo chiede.
E `@DAQUANDO` **non e' stato misurato** (non ho MT5): non lo invento.

---

## 10. 🚧 COSA NON HO POTUTO VEDERE

- 🔴 **Otto domini accademici bloccati** (§1). In particolare, e' la
  **quarta caccia di fila** che non riesce ad aprire la letteratura di
  microstruttura. Non letti, e li elenco per non fingere:
  - **Almeida-Goodhart-Payne**, *The Effects of Macroeconomic News on High
    Frequency Exchange Rate Behavior* (**JFQA 1998**) — 🎯 **e' il paper
    esattamente al NOSTRO orizzonte** (dati a **5 minuti**, effetti nei
    **15 minuti** dopo il rilascio). PDF su `researchonline.lse.ac.uk`:
    **bloccato**. **Se un giorno si riapre la famiglia, si parte da qui.**
  - **Kurov-Sancetta-Strasser-Wolfe**, *Price Drift before U.S. Macro News*
    (**JFQA, feb. 2019**) — pre-drift ~30 min, *"about 40% of the total price
    adjustment"*, **9 annunci su 20** [INCERTO, da snippet]. ECB e Skidmore
    bloccati.
  - **Ben Omrane & Savaser** (*JIFMIM* 45, 2016) — il *sign switch*. Bloccato.
  - **Andersen-Bollerslev-Diebold-Vega** (*AER* 2003) — **terza caccia che non
    riesce ad aprirlo.**
- 🟡 **Il sorgente dello script 52977 NON e' stato letto** (solo la pagina).
  Prima di girarlo, va letto: e' la regola di casa, e non l'ho applicata perche'
  non e' un candidato da imbuto. **Va fatto prima di eseguirlo.**
- 🔴 **USD_JPY non esiste sulla fonte esterna** (HTTP **404**, non 503: e'
  un'assenza vera). 👉 **Il blocco 13:30 e' stato misurato su EURUSD e oro, NON
  sul simbolo della cella bocciata (USDJPY).** Limite dichiarato.
- 🔴 **Nessuna misura post-2020-05** su questo banco: il regime 2021-2026 — cioe'
  quello in cui girano le sedie — **non e' coperto**.
- 🟡 **7 mesi mancanti** su 132 nello scarico EURUSD (125 file) e 4 su 132
  sull'oro: gli eventi in quei mesi sono semplicemente **saltati** (371/472 e
  315/422 eventi usati). Non c'e' selezione: manca il file, salta la data.

---

## 11. 🔗 FONTI (05/09/2026)

**Aperte davvero, fuori:**
- https://arxiv.org/pdf/2508.06788 — Takahashi, *Returns and Order Flow Imbalances*, arXiv v4 **08/10/2025**, S&P 500 E-mini — **PDF scaricato, 808 righe estratte e lette**
- https://export.arxiv.org/api/query — controllo positivo + 3 interrogazioni (**0 risultati veri** su `macroeconomic news AND reversal`, `announcement AND price jump`, `stop-loss AND exchange rate`)
- https://www.mql5.com/en/code/52977 — `Economic Calendar CSV`, Korotky, 22/10/2024
- https://www.mql5.com/en/articles/22196 — MetaQuotes, 08/05/2026: *"The economic calendar is a data source, not a trading signal generator"*
- https://www.mql5.com/en/code/mt5/experts — controllo positivo (12 titoli)
- https://github.com/search?q=%22economic+calendar%22+trading+bot — 4 repo, **tutti notificatori, nessun motore**
- https://raw.githubusercontent.com/FutureSharks/financial-data/… — **253 file mensili M1** scaricati (EUR_USD + XAU_USD)

**In casa (misurate oggi):**
- `biblioteca/dati/CALENDARIO_FF_High_2010-2023_UTC.csv` — eventi delle sonde
- `biblioteca/dati/CALENDARIO_news-2021-2024_*.csv` · `…2022-2025_*.csv` — **la scoperta forecast/actual (§7.1)**
- `mql5/Experts/ABTG_PostNews.mq5` (v1.10, 666 righe) · `prove/POSTNEWS_ISM_00_conta.txt` · `prove/POSTNEWS_1330_00_conta.txt`
- `REGISTRO_TEST.md` (1.153 righe) · i tre dossier notizie 03-04/09

**Sonde archiviate oggi** in `caccia_strategie/biblioteca/sonde_esterne/`:
`sonda_postnews.py` · `sonda_postnews_stabilita.py` · `sonda_postnews_epoche.py` · `sonda_postnews_oro.py`

**Fonti NULLE dichiarate:** `api.github.com` (403 scope) · `nber.org` ·
`researchonline.lse.ac.uk` · `eprints.lse.ac.uk` · `ideas.repec.org` ·
`repository.bilkent.edu.tr` · `business.rutgers.edu` · `ecb.europa.eu` ·
`skidmore.edu` · `sciencedirect.com` · `cambridge.org` · `ssrn.com` ·
`forexfactory.com` · `investing.com` · `ftmo.com` · `mql5.com/en/search` (JS)
