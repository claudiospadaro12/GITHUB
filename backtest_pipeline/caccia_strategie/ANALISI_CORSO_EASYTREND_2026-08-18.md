# 🔬 ANALISI DEL MODULO EASY TREND — 7 trascrizioni, l'EA vivo, i 3 contratti

_18/08/2026 sera. Fonte: le 7 trascrizioni in
`trascrizioni_corso_2026-08-18/modulo_easytrend/` (lezioni 11-17).
Spec ricostruita: **`backtest_pipeline/prove/EASYTREND_CORSO_SPEC.md`** — qui
non si duplica, si linka.
Protocollo: `report/PROMPT_DI_INTELLIGENZA_PRECISA.md`.
Modello di processo: `ANALISI_CORSO_BREAKOUT_2026-08-18.md` (dove l'EA usci'
"fedele 18/20 con 2 divergenze")._

---

# 🥇 LA PAGINA CHE SI LEGGE PER PRIMA

## 1. Il verdetto in tre righe

> **Su 7 trascrizioni: 21 regole con valore, 6 meccanismi, 12 buchi.
> Meccanizzabilita' della checklist: 78% (93% con le ambiguita' risolte per
> argomento). L'EA in campo e' FEDELE 17/20.
> Il dato piu' solido non e' del corso: e' NOSTRO — il win rate implicito dei
> tre contratti e' 45,5-57,8%, contro il 70% dichiarato dal corso, e con RR 1:1
> il pareggio lordo sta al 50%.**

## 2. 🔴 Le tre cose che cambiano qualcosa

**(a) Il relatore non e' Manuela Negro. E' Leonardo Fasciano.**
`[T]` lez. 11: _"Sono Leonardo Fasciano, trader e coach in area trading in Alfio
Bardola Trading Group"_. Non e' pignoleria: **Breakout ed Easy Trend sono due
autori diversi dentro lo stesso Master**, e si contraddicono frontalmente su due
regole (ordini pendenti: vietati da lei, prescritti da lui; filtro orario:
escluso da lei, obbligatorio da lui — SPEC §11). **Non esiste un "default del
corso"** con cui riempire i buchi di un modulo usando l'altro. L'EA in campo
attribuisce gia' correttamente il capitolo a Fasciano (sorgente riga 4).

**(b) Nessuna delle tre sedie vive gira su un mercato del corso.**
Il corso dichiara **EURUSD** (il banco), **EURGBP**, **EURCAD**.
In campo abbiamo **CHFJPY, GBPUSD, AUDJPY**. **Intersezione: zero.**
Non e' un errore — e' il risultato di un imbuto che ha fatto il suo mestiere
(lo scan 48 ha bocciato EURUSD al nono posto, R48 ha bocciato EURGBP, EURCAD non
e' mai arrivato al tick). **Ma va scritto nei contratti**, perche' oggi non c'e':
`report/CONTRATTI_SEDIE.md` cita R48/R49 e non dice che i tre simboli **non sono
quelli della fonte**.

**(c) Il numero che decide la strategia e' uno solo, e ce l'abbiamo misurato.**
Con RR 1:1 e nessuna gestione, il PF dipende solo dal win rate:
`WR = PF / (PF + TP_R)`. Sui nostri tre contratti:

| sedia | TP_R | PF promesso | **win rate implicito** |
|---|---:|---:|---:|
| GBPUSD 772422 | 1,5 | 1,49 | **49,8%** |
| AUDJPY 772423 | 1,0 | 1,37 | **57,8%** |
| CHFJPY 772421 | 1,5 | 1,25 | **45,5%** |
| **corso, EURUSD** | **1,0** | — | **70% dichiarato** |

`[INFERITO]` — aritmetica esatta, valida perche' questo motore ha **due sole
uscite** (SL e TP: nessun BE, nessun trailing — SPEC §7, e il codice non li ha).

> 🔥 **E' qui che si spiega tutto il resto.** Con un win rate reale intorno al
> 50%, **la regola 1:1 del corso e' un pareggio lordo che perde di spread**. Due
> delle tre sedie girano infatti a **TP 1,5**, cioe' **non girano la regola del
> corso** — e non per capriccio: l'ha imposto la misura (scan 48: _"il TP 1,5
> batte il RR 1:1 della fonte quasi ovunque"_). **La divergenza piu' importante
> fra noi e il corso e' gia' in campo, e' motivata, ed e' l'unica sensata.**

## 3. 📊 TABELLA DEI VALORI CONVERGENTI

⚠️ **Avvertenza sulla convergenza:** le 7 trascrizioni sono **UN SOLO relatore,
un solo capitolo**. Ripetizione ≠ conferma indipendente. L'unica convergenza che
vale qualcosa e' quella fra **corso e nostra misura** (ultime due righe).

| parametro | valore | dove converge dentro il corso | peso |
|---|---|---|---|
| Timeframe H1 | H1 | lez. 13, 14, 16, 17 (4 lezioni) | 🟢 solidissimo |
| Fascia oraria | **8-18** | lez. 13 (dettata), 14 (riletta), 16 (applicata + invalidazione) | 🟢 solido |
| 3 candele precedenti | **3** | lez. 13 (long e short), 14 (riletta), 16 (applicata) | 🟢 solido |
| Ingresso = chiusura candela segnale | — | lez. 14, 15, 16 | 🟢 solido |
| Buffer di stop | **3 pip** | lez. 14 (long), 16 (short) | 🟢 solido |
| RR | **1:1** | lez. 14, 16 | 🟢 solido |
| Rischio | **2%** | lez. 15, 17 | 🟢 solido |
| Colore in tinta | linreg | lez. 13, 14, 16 (con contro-esempio esplicito) | 🟢 solido |
| Universo | EURUSD + EURGBP + EURCAD | lez. 13 (EURUSD), 17 (tutti e 3) | 🟡 detto una volta per i due secondari |
| Parametri indicatori | **NIENTE** | 0 lezioni su 7, **compresa quella dedicata al settaggio** | 🔴 **buco bloccante** |
| **Frequenza dei segnali** | corso: **~4,7/mese** (140 op / 30 mesi) · **noi: 4-5/mese** (CAL 14/08: 57/45/64 trade su 13 mesi) | corso lez. 17 **vs** nostra CAL | ✅ **CONVERGENZA VERA, fonti indipendenti** |
| **Win rate** | corso: **70%** · **noi: 45,5-57,8%** | corso lez. 17 **vs** contratti R48 | 🔴 **DIVERGE, ed e' il numero che conta** |

> 🎯 **La convergenza sulla frequenza e' il reperto piu' utile del referto.**
> Se i nostri parametri degli indicatori (inventati da noi, SPEC §3.2) fossero
> molto lontani da quelli veri, il numero di segnali sarebbe di un altro ordine
> di grandezza. **Sono nella stessa banda.** Non prova che i parametri siano
> giusti — prova che **non sono assurdi**, ed e' il massimo che si puo' dire
> senza il Pine.

## 4. ⚔️ CONTRADDIZIONI

| # | dove | contraddizione | verdetto |
|---|---|---|---|
| 1 | lez. 16, esempio short | stop misurato **16 pip**, size calcolata su **15 pip** → rischio reale **2,13%** invece del 2% | `[T]` entrambi, entrambe le aritmetiche chiudono → **e' un arrotondamento a occhio del relatore**, non un errore di trascrizione. Classe "39 vs 40 pip" del Breakout. Un EA usa il valore esatto. |
| 2 | lez. 17 | **+198% in 2,5 anni** vs **"75-80% all'anno"** | composto, +198% in 2,5 anni = **+54,8%/anno**. 198÷2,5 = 79,2% → il relatore **divide linearmente**. Il numero che l'ascoltatore si porta a casa **sovrastima del ~45%**. `[I]` aritmetica nostra |
| 3 | lez. 13 | la regola del colore viene enunciata **due volte**, la seconda al posto della regola delle 3 candele | lapsus verbale, risolto dalla stessa lezione (_"la quinta regola, ovvero verificare le tre candele precedenti"_) |
| 4 | lez. 14 vs 15 | ingresso `1,06697` poi `1,06698`; lez. 16 stop `1,06933` poi digitato `1,06931` | refusi da lettura a schermo, irrilevanti |
| 5 | **fra i moduli** | Breakout: _"e' bene **non** inserire degli ordini pendenti"_ · Easy Trend: buy/sell **limit** prescritto | 🔴 **autori diversi, grammatiche diverse.** Vedi SPEC §11 |
| 6 | **fra i moduli** | Breakout: nessun filtro orario, 24/5 · Easy Trend: 8-18 con regola di morte | 🔴 idem |
| 7 | **corso vs noi** | corso: WR 70%, DD 8% a rischio 2% (= ~4% a 1%) · noi: WR implicito 45-58%, DD promesso **4,29-6,27% a 1%** | il nostro DD e' **1,1-1,6x** quello del corso riscalato, su simboli diversi. Il corso resta piu' generoso di noi su ogni voce. |

---

# 🧬 LA VERIFICA DI FEDELTA' — `ABTG_EasyTrend.mq5` contro la spec

**Metodo:** spec chiusa (§1-§9) **prima** di aprire il sorgente, come per il
Breakout. Sorgente letto dopo: `mql5/Experts/ABTG_EasyTrend.mq5` (1.605 righe,
v1.00) + la configurazione realmente in campo, `backtest_pipeline/deploy_vivaio_ez.ps1`.

## 5. ✅ IL CONTEGGIO: **FEDELE 17/20**

| # | regola del corso | codice | esito |
|---|---|---|---|
| 1 | Timeframe **H1** | riga 166 `InpTF = PERIOD_H1`; in campo `InpTF=16385` | ✅ |
| 2 | **Universo: EURUSD / EURGBP / EURCAD** | in campo **CHFJPY, GBPUSD, AUDJPY** | 🔴 **DIVERGENZA 1** |
| 3 | Linear Regression Candles + plot (media) | `AggiornaLinReg` righe 574-646: regressione lineare su O/H/L/C + media (SMA/EMA) di `linC` | ✅ ricostruito |
| 4 | CCI Divergences | `RilevaPivot` righe 656-700 su buffer CCI | ✅ ricostruito |
| 5 | Divergenza bull = prezzo LL + CCI HL / bear = HH + LH | riga 721 `px<gLowP && cci>gLowC` · riga 754 `px>gHighP && cci<gHighC` | ✅ **letterale** |
| 6 | R1: divergenza presente | `gDivBull`/`gDivBear`, riga 799-800 | ✅ |
| 7 | R2: **prima** candela che taglia il plot, **o che apre gia' oltre** | righe 828-830: `prevOpposta` (la precedente stava dall'altra parte) + `taglia = (lc0>pl0 \|\| lo0>pl0)` | ✅ **rende entrambe le varianti** |
| 8 | R3: fascia **8-18** sulla candela del segnale | righe 839-840 `dt.hour<InpHourStart \|\| dt.hour>InpHourEnd`; in campo 8/18 | ✅ letterale (fuso: SPEC §2.2, misurato in R53) |
| 9 | **R6: taglio fuori orario ⇒ divergenza NULLA** | riga 843 `ConsumaDivergenza(dir)` dentro il ramo dell'orario | ✅ **la regola piu' facile da perdere, implementata** |
| 10 | R4: colore in tinta con la divergenza | righe 854-855 `col0!=colRichiesto` | ✅ |
| 11 | Il colore e' quello **LINREG**, non della candela giapponese | riga 597 `gHCol[idx] = (lc>lo ? +1 : ...)` — calcolato su open/close **linreg** | ✅ **il dettaglio piu' sottile del capitolo, giusto** |
| 12 | R5: 3 candele precedenti dal lato opposto del plot | righe 867-881, `InpPrevBars=3` | ✅ |
| 13 | Ingresso = **chiusura della candela del segnale** | riga 914 `double livello=iClose(_Symbol,InpTF,s)` | ✅ |
| 14 | Ancora dello stop = estremo fra **inizio divergenza** e candela del segnale **inclusa** | riga 725 `gDivBullStart=gLowT` (**primo** pivot) + `EstremoFigura` righe 950-977 (`sStart`→`sSig` incluso) | ✅ **equivalente al "BE sulla chiusura" del Breakout: dettaglio sottile, giusto** |
| 15 | Stop = **3 pip oltre** l'estremo | righe 918-919 `sl = estremo -/+ buf`, `InpSLBufferPts=30` points (= 3 pip sia su 5 decimali sia su JPY a 3) | ✅ |
| 16 | TP = **RR 1:1** | riga 193 `InpTP_R = 1.0` (default = fonte) | ✅ nel **codice** · ⚠️ **non in campo** (vedi §7) |
| 17 | Prezzo verso il TP ⇒ **limit** sul livello; verso lo SL ⇒ **mercato** | righe 1036-1042 `versoTp` → `usaLimit` | ✅ **letterale** |
| 18 | **Livelli scritti e ricopiati**: SL/TP/size restano ancorati alla candela del segnale anche entrando a mercato | riga 1057 `entry = usaLimit ? livello : pxOra` → righe 1071/1078/1089: **rischio, TP e lotto si ri-ancorano al prezzo reale** | 🟠 **DIVERGENZA 2 (parziale)** |
| 19 | **Nessuna gestione dopo l'ingresso** | righe 1142-1146: _"Nessun trailing, nessuna parziale, nessun time-stop"_ — e non c'e' | ✅ |
| 20 | Rischio **2%** per operazione | riga 206 `InpRiskPercent = 1.0`; in campo 1,0 | 🟠 **DIVERGENZA 3 (dichiarata)** |

**17 su 20.** Come per il Breakout: **non e' un EA "ispirato"**, segue anche le
regole controintuitive (il colore letto sulla linreg, l'ancora dello stop sul
**primo** pivot, la morte della divergenza per l'orario).

## 6. 🔴 LE TRE DIVERGENZE, una per una

### D1 — L'universo (la piu' pesante, ed e' una scelta consapevole)
**Corso:** EURUSD (banco), EURGBP, EURCAD.
**Campo:** CHFJPY 772421, GBPUSD 772422, AUDJPY 772423.
**Intersezione: zero.**
Storia agli atti (`prove/EASY_TREND_TESI.md`): lo scan 48 OHLC mette **EURUSD
nono** (+1.012, PF 1,34, **solo short**); EURGBP arriva fino al walk-forward e
viene **bocciata** (R48), e R53 la trova **rossa in tutte e 8 le celle**; EURCAD
non supera mai lo scan.

> ⚖️ **Non e' un difetto dell'EA: e' l'imbuto che ha fatto il suo mestiere.** Ma
> ha una conseguenza che va scritta: **stiamo misurando una strategia fuori dal
> suo universo dichiarato.** Qualunque risultato forward di queste tre sedie
> **non conferma e non smentisce il corso** — parla di un altro mercato.
> 📌 **Da aggiungere ai contratti** (§8).

### D2 — L'ancoraggio di TP e size al prezzo di riempimento
La procedura del corso e' inequivocabile: si scrivono **tre valori su carta**
(lez. 14) e si **ricopiano** in MT4 (lez. 15, 16), e la **size si calcola sui pip
letti sul grafico**, non sul fill.

Il codice, invece:
```
riga 1057:  double entry = usaLimit ? livello : pxOra;
riga 1071:  double riskDist = isLong ? (entry-sl) : (sl-entry);
riga 1078:  double tp = isLong ? (entry+InpTP_R*riskDist) : (entry-InpTP_R*riskDist);
riga 1089:  double lot=LotByRisk(riskDist);
```
- **Lo SL e' fedele** (`gSigSL`, calcolato una volta sull'estremo della figura,
  righe 918-925: non si muove). ✅
- **TP e lotto NO**: entrando a mercato a un prezzo migliore, il TP **si
  avvicina** e il lotto **cresce**, invece di restare i valori scritti.

**Quanto pesa:** solo sugli ingressi a mercato, e solo per lo scarto fra la
chiusura della candela e il primo tick utile — pochi punti su stop da 15-25 pip.
**Direzione dell'effetto:** il corso, tenendo i livelli fissi, **incassa** il
vantaggio dell'ingresso migliore (RR effettivo > 1 e rischio < 2%); l'EA lo
**restituisce** riportando tutto a 1:1 pieno sul prezzo reale.

> ⚠️ **Onesta' obbligatoria:** il corso **non enuncia mai** l'ancoraggio come
> regola (SPEC §6.1) — e' un'inferenza dalla procedura, forte ma non citata.
> Quindi questa e' una **divergenza da ambiguita'**, non da regola violata.
> Trattarla come input A/B e' l'unica lettura onesta.

### D3 — Il rischio 1% invece del 2%
Dichiarata nel sorgente stesso, righe 148-149: _"InpRiskPercent 1.0 = standard di
famiglia (il corso dice 2%: si spazzola dopo, non si parte col rischio alto)"_.
**Non e' infedelta' nascosta: e' una scelta scritta.** E ha ragione la scelta —
col 2% del corso, tre stop consecutivi (che il corso stesso dichiara essere
successi) fanno **6% in un giorno**, oltre il daily loss del 5% di una prop.

## 7. ⚠️ LA QUARTA: NON E' NEL CODICE, E' NEI PRESET — `TP_R = 1,5`

`backtest_pipeline/deploy_vivaio_ez.ps1`:
```
(@("InpTP_R=1.5") ... "InpMagic=772421","InpComment=EZ CHFJPY"
(@("InpTP_R=1.5") ... "InpMagic=772422","InpComment=EZ GBPUSD"
(@("InpTP_R=1.0") ... "InpMagic=772423","InpComment=EZ AUDJPY"
```
> **Due sedie su tre girano con un rapporto rischio-rendimento che il corso non
> insegna.** Il default del codice e' 1,0 (fedele); e' la **configurazione in
> campo** ad aver cambiato la regola.
>
> **Ed e' motivato da una misura**, non da un'opinione: lo scan 48 dice _"il TP
> 1,5 batte il RR 1:1 della fonte quasi ovunque: la regola [FONTE] 'rapporto 1 a
> 1' NON e' confermata dal nostro banco"_, e R48 ha promosso quelle celle col
> criterio congelato. **Va bene cosi' — ma va scritto nel contratto**, perche'
> oggi chi legge `CONTRATTI_SEDIE.md` vede "TP 1,5" e non sa che e' una
> deviazione dalla fonte.

## 8. 📜 INCROCIO COI CONTRATTI (`report/CONTRATTI_SEDIE.md`)

| voce | corso `[dich., NON verif.]` | contratto delle 3 sedie | esito |
|---|---|---|---|
| **Timeframe** | H1 | H1 (`InpTF=16385`) | ✅ **coerente** |
| **Simboli** | EURUSD / EURGBP / EURCAD | CHFJPY / GBPUSD / AUDJPY | 🔴 **zero intersezione** |
| **Rischio** | 2% | 1,0% | 🟠 dichiarato, prudenziale |
| **RR** | 1:1 | **1,5** / 1,5 / 1,0 | 🟠 2 sedie su 3 fuori dalla regola |
| **Fascia oraria** | 8-18 | 8-18 (fuso letterale) | ✅ coerente, e **misurato** in R53 |
| **Frequenza** | ~4,7 op/mese (140 op / 30 mesi) | **2,9 / 3,9 / 3,8** op/mese | ✅ **stessa banda** — la promessa e' leggermente piu' prudente della fonte |
| **Max DD** | 8% a rischio 2% → **~4% a 1%** | **4,58 / 4,29 / 6,27%** a 1% | 🟠 il nostro promesso e' **1,1-1,6x** quello del corso riscalato |
| **Win rate** | 70% | **49,8 / 57,8 / 45,5%** impliciti | 🔴 **la voce che diverge di piu'** |
| **Gestione** | nessuna | nessuna | ✅ coerente |
| **Stato** | — | in **OSSERVAZIONE**, porta 100k **chiusa** (R49) | — |

### 8.1 🎯 Le tre righe da aggiungere a `CONTRATTI_SEDIE.md`
1. **"Universo fuori fonte"**: i tre simboli **non sono** quelli del corso
   (EURUSD/EURGBP/EURCAD); EURGBP e' stata **bocciata** in R48 e R53.
2. **"TP 1,5 = deviazione misurata"** su CHFJPY e GBPUSD: il corso insegna 1:1,
   il nostro banco ha scelto 1,5 (scan 48). Non e' un refuso di configurazione.
3. **Il win rate implicito** (49,8 / 57,8 / 45,5%) accanto al PF promesso:
   con RR fisso e due sole uscite e' un dato **derivabile e verificabile in
   forward a occhio**, ed e' la sveglia piu' rapida che abbiamo su queste sedie.
   *(Verifica forward proposta, non azione: la C3 non si tocca.)*

### 8.2 Coerenza con i criteri di casa
- **C3 corsia RISCHIO:** i tre contratti hanno DD promesso (4,29-6,27% a 1%) →
  la corsia scatta. ✅ nessun buco.
- **Regola della finestra (emendamento 16/08):** l'IS di R48 e' **8,5 mesi** con
  n=20-30 per cella. **Sotto la soglia dei 150 trade.** Le tre sedie sono
  promosse su un IS che l'emendamento di agosto considera **campione sottile**:
  giudizio **sospeso sul MERITO**, valido sul **RISCHIO**. Da tenere presente
  prima di riaprire la porta del 100k.

---

# 🗂️ LE SCHEDE, LEZIONE PER LEZIONE

### FILE `11. TRADINGWIEW,PRESENTAZIONE PIATTAFORMA E STRATEGIA EASY TREND.txt`
- **RELATORE:** **Leonardo Fasciano**, Alfio Bardolla Trading Group `[T]`
- **OGGETTO:** presentazione. TradingView = **analisi**, MT4 = **esecuzione**
- **PARAMETRI:** nessuno
- **A SCHERMO NON DETTATO:** nulla (video parlato, senza grafici)
- **COSA NE COPIAMO:** l'attribuzione dell'autore, e la separazione
  analisi/esecuzione (che spiega perche' i livelli si scrivono "su carta")

### FILE `12. BREVE TUTORIAL DI TRADINGWIEW E SETTAGGIO STRATEGIA E INDICATORI...`
- **OGGETTO:** setup di TradingView e caricamento dei due indicatori
- **PARAMETRI CON VALORE:** ⚠️ **NESSUNO.** Nomi si': _"Linear Regression Candle
  ... di **UGUR-VU**"_, _"CCI Divergences di **TISTA**"_ `[T]`. Feed:
  **Pepperstone** `[T]`. Versione TradingView: **gratuita** `[T]`
- **MECCANISMI:** il **plot** = _"una media mobile calibrata e tarata
  sull'algoritmo delle candele"_ `[T]`; le candele linreg colorano la tendenza
- **A SCHERMO NON DETTATO:** 🔴 **i due pannelli impostazioni, aperti entrambi.**
  Il relatore dice _"l'unica modifica che ti consiglio di fare e' proprio sul
  colore"_ — **e' la lezione piu' cieca del capitolo, ed e' quella che avrebbe
  chiuso il buco bloccante**
- **COSA NE COPIAMO:** i nomi esatti dei due script (per cercarli su TradingView)

### FILE `13. PRESENTAZIONE DEGLI INDICATORI E LE REGOLE DELLA STRATEGIA...`
- **OGGETTO:** la definizione di divergenza + la checklist a 5 regole
- **PARAMETRI CON VALORE:** timeframe **H1** `[T]` · fascia **8-18** `[T]` ·
  **3** candele precedenti `[T]` · esempio: candela **1° maggio ore 11:00** `[T]`
- **MECCANISMI:** divergenza regolare definita per intero (prezzo HH + indicatore
  LH = bear; prezzo LL + indicatore HL = bull) `[T]`; "prima candela che taglia il
  plot **o che apre direttamente sopra**" `[T]`; colore in tinta; anti-lateralita'
- **BANDIERE ROSSE:** nessuna (no martingala, no griglia, no recovery, SL sempre)
- **A SCHERMO NON DETTATO:** la forma grafica del "taglio"; il file di testo con
  la checklist scritta; le soglie del CCI
- **COSA NE COPIAMO:** **le 5 regole. E' il cuore della spec.**

### FILE `14. ESEMPI OPERATIVI DELLA STRATEGIA EASY TRAND E CHECK LIST...`
- **OGGETTO:** ingresso, stop, target sull'esempio long
- **PARAMETRI CON VALORE:** ingresso = **chiusura della candela del segnale**
  `[T]` · stop = estremo fra **inizio divergenza** e candela del segnale, **−3
  pip** `[T]` · **RR 1:1** `[T]` · esempio: E `1,06697` / SL `1,06464` / TP
  `1,06933`, stop **23 pip** `[T]`
- **VERIFICA NOSTRA:** 1,06697−1,06464 = 0,00233 ✅ · TP a 23,6 pip → RR 1,01 ✅
- **A SCHERMO NON DETTATO:** il widget "posizione long"; il righello dei 3 pip
- **COSA NE COPIAMO:** i tre livelli come **test-case di regressione** per l'EA

### FILE `15. EASY TREND ESEMPIO COMPLETO CON MESSA A MERCATO...`
- **OGGETTO:** sizing e invio ordine
- **PARAMETRI CON VALORE:** rischio **2%** `[T]` · saldo **5.000 €** `[T]` ·
  valore pip EURUSD **9,28 €** `[T]` · stop **23 pip** → **0,46 lotti** `[T]`
- **VERIFICA NOSTRA:** 100 € / (23 × 9,28) = **0,468** ✅ **l'aritmetica chiude**
- **MECCANISMI:** prezzo verso il TP ⇒ **buy limit**; verso lo SL ⇒ **mercato** `[T]`
- **A SCHERMO NON DETTATO:** 🔴 **il foglio Excel del sizing** (formula mai
  dettata, solo i risultati); il sito del valore del pip; la finestra ordine MT4
- **COSA NE COPIAMO:** la regola dei due scenari d'ingresso e il sizing

### FILE `16. ESEMPIO RIBASSISTA STRATEGIA EASY TREND.txt`
- **OGGETTO:** esempio short completo + **la regola di invalidazione**
- **PARAMETRI CON VALORE:** candela segnale **13:00** `[T]` · estremo a **13 pip**
  → stop **16 pip** `[T]` · size calcolata su **15 pip** → **0,71 lotti** `[T]` ·
  E `1,06771` / SL `1,06933` / TP `1,06613` `[T]`
- **MECCANISMI:** 🔑 **il colore si legge sulla LINREG, non sulla candela
  giapponese** (con contro-esempio esplicito) `[T]` · 🔑 **taglio fuori orario ⇒
  divergenza NULLA**, si aspetta una divergenza nuova `[T]`
- **CONTRADDIZIONE:** stop 16 pip vs size su 15 pip → **rischio reale 2,13%**
- **COSA NE COPIAMO:** la regola d'invalidazione (e' **una regola in piu'**,
  facile da perdere) e la lettura del colore

### FILE `17. EASY TREND BACK TEST E MONEY MENAGEMENT.txt`
- **OGGETTO:** i numeri e l'universo
- **NUMERI `[dichiarati, NON verificati]`:** EURUSD gen 2022→oggi, **>140 op**,
  **+198%**, **DD 8%**, **WR 70%**, **max 3 stop consecutivi**, **75-80%/anno** ·
  EURGBP ~140 op, **+118%**, **DD 10%**, 3 consecutivi · EURCAD **+68%** `[dubbio]`
- **VERIFICA NOSTRA:** WR 70% + RR 1:1 + 140 op + 2% composto = **+205%** ≈ il
  +198% dichiarato → **i quattro numeri sono UNO**. Il "75-80%/anno" invece
  **non torna**: il composto da' **+54,8%/anno** (§4 riga 2)
- **A SCHERMO NON DETTATO:** 🔴 **l'intero report** su 3 cross: equity line,
  lista operazioni, date, broker
- **COSA NE COPIAMO:** l'universo (3 cross) e il claim da falsificare

---

# 🗑️ GLI SCARTI

**Nessuna trascrizione scartata.** Anche la lez. 11 (1,2 KB, puro annuncio) porta
il **nome del relatore**, che si e' rivelato un rilievo (§2a).
La lez. 12 e' la piu' povera di dati utili **proprio dove doveva essere la piu'
ricca**: si registra come **buco**, non come scarto.

---

# ❓ LE DOMANDE PER CLAUDIO (screenshot al minuto giusto)

| # | priorita' | cosa serve | dove |
|---|---|---|---|
| 1 | 🔴 | **Screenshot dei due pannelli impostazioni** di "Linear Regression Candles" (UGUR-VU) e "CCI Divergences" (TISTA) su TradingView | **lez. 12**, quando apre Impostazioni per cambiare il colore: i numeri sono nella stessa finestra |
| 2 | 🟠 | **Il fuso del grafico TradingView** (in basso a destra, sempre visibile) | lez. 13, 14 o 16, qualunque fotogramma del grafico |
| 3 | 🟡 | **Il report del backtest**: equity, N operazioni, date, broker | **lez. 17**, tutta |
| 4 | 🟡 | **La formula del foglio Excel** del sizing | lez. 15 |
| 5 | 🟡 | **EURCAD: 68% e' profitto o drawdown?** 10 secondi di riascolto | lez. 17, finale |
| 6 | 🟡 | **Esiste un PDF riepilogativo di questo capitolo?** Per il Breakout le slide hanno chiuso 6 ambiguita' su 10 | — |

---

# 🎯 COSA MERITA UN ROUND (proposte, non azioni)

| # | proposta | perche' | costo |
|---|---|---|---|
| **P1** | **Ancorare TP e lotto al livello del segnale** anche sugli ingressi a mercato (input A/B), come fa il corso | e' la **divergenza D2**, l'unica non voluta. Effetto atteso piccolo ma **sistematico** e sempre nello stesso verso | modifica di 3 righe + un round A/B |
| **P2** | **Misurare EURUSD, il banco dichiarato del corso**, sulla finestra del corso (gen 2022 →) | e' l'unico modo di falsificare il claim **sul suo terreno**. ⚠️ **Limite dichiarato in partenza:** su BCM lo storico tick parte dal 2024.09.26 → si potrebbe fare **solo in OHLC**, e per regola di casa l'OHLC vale per **frequenza e screening, mai per il verdetto**. Da valutare se ne vale la pena | medio, con verdetto debole per costruzione |
| **P3** | **Aggiungere le 3 righe ai contratti** (§8.1): universo fuori fonte, TP 1,5 = deviazione misurata, win rate implicito | e' documentazione, non misura: costo zero, e chiude un buco di leggibilita' | zero |
| **P4** | ❌ **NON** rifare il round sulla fascia oraria | R53 ha gia' speso 128 passate: _"la fascia non decide"_. Il bordo delle 18 (10 vs 11 candele, SPEC §4.5) **non giustifica** un round nuovo: si corregge la dicitura del referto, non il codice | — |

---

_Compilato il 18/08/2026. Spec ricostruita prima di aprire il codice. Ogni
divergenza porta la riga del sorgente che la prova. Nessun numero del corso e'
trattato come verificato._
