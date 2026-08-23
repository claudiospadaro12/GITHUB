# 🕘⚡ I PIANI DI APERTURA SOTTO IL TORCHIO — fedeltà delle sedie vive, attriti prop, verdetto

_18/08/2026 sera. Fonte: i 4 file in `corso_documenti_2026-08-18/` (26+12+15
slide + 41 pagine, estratti per intero). Spec gemella:
`backtest_pipeline/prove/PIANI_APERTURA_SPEC.md`. Protocollo:
`report/PROMPT_DI_INTELLIGENZA_PRECISA.md` — etichette [SLIDE n]/[PAG n],
[INFERITO], [INCERTO]._

> 🎯 **LA RISPOSTA IN TRE RIGHE:** i piani sono meccanizzabili al **75%** con
> 12 assunzioni dichiarate (Nasdaq **93%**, America 76%, PDF 76%, Europeo
> **61%**). Le sedie vive sono fedeli **17/20 nel CODICE** ma **9/20 in
> CAMPO** — e le 11 divergenze di campo sono **tutte dichiarate o misurate**,
> nessuna clandestina. Per le prop: **eseguibili CON CONDIZIONI** (il filtro
> news dei piani va ACCESO, il 2% del piano va giù a 0,65%).

---

## 1. 🧬 FEDELTÀ DELLE SEDIE VIVE — regola per regola, come per EasyTrend

**Metodo:** spec chiusa PRIMA di riaprire i sorgenti. Sedie confrontate (dal
censimento `report/CONTRATTI_SEDIE.md`):

| sedia | magic | motore in campo | contratto |
|---|---|---|---|
| `ABTG_DAX_Apertura_EU` D30EUR | 770101 | ORB 35 min, buffer 500 | ✅ DD 6,25% (R16/R46) |
| `ABTG_Dow_Apertura_US` U30USD | 770202 | ORB 15 min, buffer 200 | ✅ DD 4,22% (R16/R54) |
| `ABTG_Nasdaq_Apertura_US` NASUSD | 770201 | candela H1 prec., stop | 🔴 **SENZA CONTRATTO** (mai promossa: PF 0,82 tick reali; 19/20 celle OOS negative) |
| `ABTG_DAX_Live5m` / `_v2` / `ABTG_Nasdaq_Live5m` | 770103/770121/770203 | candela 5 min PRE-apertura, buffer 700 | (A/B dalla live 17/07 — **non da questi 4 piani**) |

### 1.1 La tabella delle 20 regole

Colonna **CODICE** = la regola è implementabile/implementata nei sorgenti.
Colonna **CAMPO** = la sedia viva la rispetta con i default/preset attuali.

| # | regola del piano | fonte | CODICE | CAMPO | nota |
|---|---|---|---|---|---|
| 1 | apertura EU 09:00 IT / USA 15:30 IT | [AM SLIDE 2] | ✅ | ✅ | 8:00 / 14:30 server BCM: giusti |
| 2 | *"volatilità nei primi 15 minuti"* | [AM SLIDE 2] | ✅ | 🟠 | Dow 15' ✅ · **DAX 35'** (divergenza MISURATA 06/08: fuori campione 8/8 celle in utile con 35-45, 0/12 sotto — commento nel sorgente riga 79) |
| 3 | Nasdaq: BUY/SELL STOP sui max/min della candela H1 | [NAS SLIDE 10] | ✅ | ✅ | `RANGE_MODE=2` + `LEVEL_TF=H1` |
| 4 | stop sull'estremo opposto | [NAS SLIDE 11] | ✅ | ✅ | `SL_RANGE` (⚠️ il PDF dice il contrario — spec §7.5) |
| 5 | OCO: cancello il non eseguito | [NAS SLIDE 11] | ✅ | ✅ | |
| 6 | TP *"dimezzando"* | [NAS SLIDE 11] | ✅ | ✅ | parziale 50% |
| 7 | stop in pari dopo la parziale | [NAS SLIDE 11] | ✅ | ✅ | `InpBreakevenAtTP1` |
| 8 | trailing M1 base candela precedente | [AM SLIDE 11] | ✅ | ✅ | `TRAIL_MODE=1` |
| 9 | 1° obiettivo = numero tondo (surrogato %Custom dichiarato dal piano) | [NAS SLIDE 12, 15] | ✅ | 🟠 | `InpUseRoundLevels` attivo nel preset Nasdaq, non su DAX/Dow |
| 10 | trailing indici 410 punti | [EU SLIDE 20] | ✅ | 🟠 | `InpTrailFixedPts=410` esiste; in campo vince la base-candela (test 05/08, Dow) — divergenza MISURATA |
| 11 | rischio max 2% | [NAS SLIDE 14] | ✅ | 🔴 | in campo 1,0 / 0,65 / 0,25 — divergenza DICHIARATA (regola di casa: 2 stop da 2% = 4% = pausa Guardian; vedi §2) |
| 12 | news 3 tori: *"tolgo tutto"* | [AM SLIDE 2] | ✅ | 🔴 | `InpUseNewsFilter=false` in campo — il piano lo dà come ROUTINE, non opzione |
| 13 | volumi a conferma della rottura | [PAG 14, 17] | ✅ | 🔴 | implementato, spento |
| 14 | ATR ≥ media a conferma | [PAG 14] | ✅ | 🔴 | scritto il 02/08 (prima NON ESISTEVA), spento |
| 15 | ingresso DOPO la chiusura della candela di breakout | [PAG 17] | ✅ | 🔴 | motore `DELAYED` esiste; in campo `BREAKOUT` (stop DURANTE) — che però è FEDELE alla slide Nasdaq: contraddizione fra le fonti, il campo ha scelto la slide |
| 16 | trend confermato su D1/H4 (EMA/ST) | [PAG 29] | ✅ | 🔴 | filtri spenti |
| 17 | Supertrend ×3 concordi (2.5/3.0/3.5) | [EU SLIDE 23] | ✅ | 🔴 | `InpUseSupertrend3` scritto il 02/08, spento |
| 18 | correlazione 225JPY → SPXUSD → D30EUR | [EU SLIDE 2, 18] | 🟠 | 🔴 | il filtro accetta UN solo simbolo guida (catena a 2 mai scritta), e in campo è spento |
| 19 | size divisa: metà sul livello, metà su EMA14 | [AM SLIDE 10] | 🔴 | 🔴 | **mai implementata** (audit 02/08 punto #20, "bassa priorità") |
| 20 | DAX = impianto del piano Europeo (livelli Larry + ST×3 + pendenti sui livelli, NON ORB) | [EU SLIDE 9-25] | 🔴 | 🔴 | il 770101 fa un ORB che il piano Europeo non prescrive — strategia DIVERSA, documentata il 02/08 |

**CONTEGGIO: CODICE 17/20 (16 piene + 1 parziale, 2 assenti) · CAMPO 9/20
(8 piene + 3 parziali, 9 non rispettate).**

### 1.2 ⚖️ Divergenze VOLUTE vs NON VOLUTE — il punto che la missione chiedeva

**Volute e con referto (nessuna azione richiesta):**
- **#2 DAX 35 minuti** e buffer 500: misura del 06/08, scritta nel sorgente.
- **#10 trailing base-candela** invece di 410 fissi: test del 05/08 (Dow).
- **#11 rischio 1%/0,65%**: regola di casa dichiarata ovunque; il 2% del piano
  brucerebbe il cap giornaliero prop in 2 stop (§2).
- **#12-17 filtri spenti**: scelta di metodo DICHIARATA nell'audit 02/08
  (*"prima si misura la configurazione dei documenti a tick reali, poi si
  cambiano i default"*) — MA vedi il 🔴 qui sotto.
- **#20 DAX ORB**: divergenza d'impianto nota dal 02/08. L'ORB è
  *"un'altra strategia che noi abbiamo"* (live Emiliano) — quindi il 770101
  implementa una strategia LEGITTIMA della stessa scuola, ma NON il piano
  Europeo. Il suo contratto (R16) è sul SUO merito misurato, non sulla
  fedeltà al piano. Stato: dichiarato.

**🔴 La NON-CHIUSA (l'unica vera): il processo dei filtri è rimasto a metà.**
La promessa del 02/08 era: misurare la configurazione dei documenti (`-Doc`),
poi decidere. Agli atti (`CACCIA_MOTORE_APERTURE.md`): i run DAX `-Doc` sono
**DA RIFARE** (SL sbagliato, PF 142 fasullo), l'**ablazione dei filtri Nasdaq
non risulta mai girata**, e il risultato US col piano completo reggeva su
**72 trade** (sotto la soglia di affidabilità di casa, n≥150 per l'IS
dell'Emendamento). **Quindi oggi i filtri sono spenti non perché misurati
inutili, ma perché la misura non è mai stata finita.** Non è una divergenza
clandestina (è tutto scritto), ma è un DEBITO APERTO: finché l'ablazione non
gira, "il metodo del corso non funziona" resta NON DIMOSTRATO — quello che è
morto nei walk-forward è lo scheletro NUDO senza i filtri che il corso
prescrive come condizioni [PAG 29: *"se anche solo un punto è 'NO'… forse è
meglio aspettare"*].

**Non volute in senso stretto: NESSUNA trovata.** Ogni scarto fra piano e
campo ha un referto, un commento nel sorgente o una riga d'audit che lo
dichiara. La macchina della documentazione ha tenuto.

### 1.3 📌 E i Live5m? Fedeli a un ALTRO documento
I tre Live5m (candela 5' pre-apertura, buffer 700) NON vengono da questi 4
file: qui la candela pre-apertura non è mai nominata. Vengono dalla live del
17/07 — e COMBACIANO col piano ufficiale `Piano_Trading__NASDAQ__ABTG.pdf`
(analisi 03/08: canale pre-apertura 15:25-15:30, pendenti a +7/+10 punti).
**Su questi 4 piani i Live5m non vanno giudicati: sono figli di un'altra
fonte della stessa scuola.**

---

## 2. 🏦 ATTRITI PROP — i piani di apertura contro le regole censite

_Regole prop dalla raccolta `CONFIG_PROP_2026-08-18.md` (§2A-2G, fonti citate
lì). Le finestre news valgono per le news AD ALTO IMPATTO del calendario._

### 2.1 Prima la buona notizia: l'apertura NON è una "news"
I divieti prop censiti si agganciano al **calendario macro** (high impact),
non all'apertura dei mercati in sé. **Tradare le 09:00/15:30 è permesso su
tutte e sei le prop censite.** [VERIFICATO su CONFIG_PROP §2A-2F]

### 2.2 Ma le aperture VIVONO in mezzo alle news — la mappa degli scontri

| momento (IT) | cosa esce | chi è a mercato | attrito |
|---|---|---|---|
| 08:00 | dati tedeschi (Destatis) | nessuno (DAX apre 09:00) | ✅ 60' di margine |
| 09:30-10:00 | PMI / IFO Germania-EU | trade DAX vivo (flat 18:30 IT) | 🔴 **FundingPips: vietato TENERE ±10'** su news EUR alto impatto → hard breach; E8/FTMO/The5ers: vietato solo eseguire (±5/±2') → il TRAILING che chiude in finestra è un'esecuzione ⚠️ |
| 14:15 / 14:45 | BCE (giorni ECB) | trade DAX vivo | 🔴 idem |
| 14:30 | CPI / NFP / retail USA | nessuno all'apertura USA (15:30) | ✅ 60' di margine — MA il trade DAX è vivo → attrito su FundingPips per news USD? solo se il simbolo è "interessato" [INCERTO: D30EUR vs news USD — da chiedere al supporto, `report/DOMANDE_SUPPORTO_PROP.md`] |
| 15:45-16:00 | PMI USA / ISM / Michigan | trade Nasdaq/Dow vivo da 15-30' | 🔴 **la finestra più pericolosa**: parziale/trailing/BE che esegue fra 15:50 e 16:10 = violazione su FundingPips (±10' anche TENUTA) ed E8 (±5' esecuzione) |
| 20:00 | FOMC (8 volte/anno) | Nasdaq 770201 vivo (flat 22:45 IT); Dow/DAX già flat (18:30) | 🔴 tenuta e trailing in piena conferenza |

### 2.3 Il rischio per trade: il 2% del piano NON passa
- Piano: max 2% per operazione [NAS SLIDE 14] (e il PDF arriva a dire 1-3%
  [PAG 27]).
- Con TRE sedie di apertura nello stesso giorno a 2%: worst-day teorico 6% →
  **sopra il muro giornaliero di TUTTE le prop censite** (4-5%) e doppio
  della pausa Guardian (4,0).
- Alla taglia di casa (0,65%): 3 stop = 1,95%, dentro il cap firmato 3,25%.
  ✅ **la conversione è già fatta e firmata** (`report/FIRME_2026-08-18.md`).

### 2.4 Il paradosso più bello: il piano è GIÀ prop-compliant — ma noi lo
teniamo spento
La routine dei piani — *"prima di ogni rilascio di un dato a 3 tori, vado a
togliere tutto"* [AM SLIDE 2] — è PIÙ SEVERA delle regole FundingPips (±10')
ed E8 (±5'). **Se il filtro news implementato (`InpUseNewsFilter` +
`InpNewsFlatten`) fosse acceso con finestra ≥10 minuti, le sedie di apertura
sarebbero compliant BY DESIGN su tutte e sei le prop.** In campo è spento
(fedeltà #12). Due avvertenze tecniche già agli atti (CONFIG_PROP §1):
`CalendarValueHistory` non funziona nel tester → il filtro live non è
backtestabile (i nostri numeri restano "ottimisti sulle news" per
costruzione), e il CSV manuale va mantenuto.

### 2.5 Verdetto prop, per piano

| piano | su prop | perché |
|---|---|---|
| **Nasdaq / America (breakout apertura USA)** | 🟠 **ESEGUIBILE CON CONDIZIONI** | orario ok, intraday ok (flat prima delle 23:00 E8), niente weekend. CONDIZIONI: rischio ≤0,65%, filtro news ACCESO (≥10'), attenzione alle 16:00 IT. Su FTMO **Swing**: eseguibile pieno (zero restrizioni news) |
| **Gap Fill USA (PDF)** | 🟠 **ESEGUIBILE CON CONDIZIONI** | come sopra; RR e TP definiti aiutano il metro; in casa è già la famiglia GapFill (5 sedie con contratto) |
| **Europeo (DAX)** | 🔴 **LIMITATO** | non per gli orari (ok ovunque) ma perché il piano NON è meccanizzabile al livello d'ingresso (61%, zero SL/size): quello che si può portare in prop è il NOSTRO ORB 770101 (che è un'altra strategia) o un futuro EA livelli+ST×3 con assunzioni pesanti. Attrito tenuta su PMI/BCE per FundingPips |
| **Breakout notturno (PDF)** | 🔴 **VIETATO su E8 Signature** (chiusura forzata 23:00-00:15 server ammazza il box notturno — stessa riga che uccide MaxMinNotte/Nightly, CONFIG_PROP §2E); 🟠 altrove | |

### 2.6 E su conto reale MT5?
✅ **ESEGUIBILI senza vincoli normativi** (nessuna finestra news, nessun cap
imposto). I nodi sono nostri e già misurati:
1. **Slippage sugli ordini stop all'apertura** — misurato in walk-forward
   (fase C): è il costo che ha affossato il breakout a stop sul Nasdaq.
2. **Spread d'apertura** sui primi minuti.
3. **L'edge**: i verdetti di casa dicono che lo scheletro nudo regge solo su
   Dow (contratto R16 4,22%) e DAX nella configurazione misurata (R16/R46);
   il Nasdaq 770201 gira SENZA CONTRATTO con due verdetti negativi. Il piano
   COMPLETO (coi filtri) non è mai stato misurato fino in fondo (§1.2).

---

## 3. 🏁 VERDETTO FINALE E COSA FARNE

**1. Meccanizzabilità: 75%** (62/83 decisioni censite, con 12 assunzioni
dichiarate — spec §8). Ordine di meccanizzabilità: **Nasdaq 93% > America 76%
≈ PDF 76% > Europeo 61%**. Il gap fill del PDF è la singola strategia più
chiusa (89%).

**2. Fedeltà: 17/20 nel codice, 9/20 in campo.** Nessuna divergenza
clandestina: tutte dichiarate o misurate. Il debito vero non è di fedeltà ma
di MISURA: **l'ablazione dei filtri (il piano come lo prescrive il piano) non
è mai stata completata** — i run DAX `-Doc` da rifare, l'ablazione Nasdaq mai
girata, il run US buono fermo a 72 trade (sotto n=150 dell'Emendamento).

**3. Prop: eseguibili con condizioni** — rischio ≤0,65% (il 2% del piano
sfonda i muri giornalieri in 2-3 stop), filtro news da ACCENDERE (la routine
del piano stesso lo prescrive e ci renderebbe compliant by design), finestra
16:00 IT da governare, FTMO Swing come corsia larga. Breakout notturno morto
su E8 Signature. Conto reale: nessun vincolo, il nemico è lo slippage
d'apertura già misurato.

**4. I tre numeri marci trovati stasera** (mai segnalati prima, spec §6):
la chiusura che cambia da 14.800 a 15.000 nell'unico esempio completo del PDF
[PAG 25]; la formula di position sizing SENZA il valore-punto [PAG 28] (chi
la replica alla lettera quintuplica il rischio); la riga LSE della tabella
orari incoerente [PAG 9].

### 📋 La coda di test che questa analisi lascia (in ordine di valore)
1. **Ablazione filtri Nasdaq** (`ablazione_nasdaq.ps1`, già pronta): un
   filtro alla volta sui livelli H1 — chiude il debito del 02/08 e decide se
   "il metodo del corso" ha edge o no. Finché non gira, il verdetto sul
   metodo resta APERTO.
2. **Rifare i run DAX `-Doc`** con SL ATR corretto (già corretto nello
   script, mai rilanciato a referto).
3. **Size divisa 50/50** (livello + EMA14): unica regola dei pptx mai
   implementata (A4). Modifica di codice, da fare SOLO se 1-2 mostrano edge.
4. **Gap Fill Nasdaq/indici USA secondo il PDF** (gap-fill USA con RR 1,5):
   la famiglia GapFill di casa è su cambi + Dow/Nikkei; la variante
   sull'apertura USA del PDF (conferma M5) non è mai stata girata così.

_NON toccati: sorgenti EA e forward — la missione era di analisi. Compilato
il 18/08/2026 sera, commit a pezzi per l'onda 529._

---

## 🔁 AGGIORNAMENTO 23/08/2026 — seconda lettura degli stessi 4 file

Claudio ha ricaricato i 4 documenti: **MD5 identici** a quelli di
`corso_documenti_2026-08-18/`. La rilettura è in
**[`ANALISI_APERTURE_4DOC_2026-08-23.md`](ANALISI_APERTURE_4DOC_2026-08-23.md)**
— non duplico, linko. Cosa cambia per QUESTO dossier:

- 🖥️ **Le immagini delle slide non erano mai state aperte** (18/08 = testo-only).
  Aperte il 23/08: **9 misure nuove** dagli screenshot MT5 (tutti `.bcm`).
- 🔴 **L'assunzione A4 della spec è FALSA**: la size divisa del piano America è
  **10 + 20 lotti (1:2)**, non 50/50 — leggibile dalle etichette d'ordine
  [AM SLIDE 10]. Con stop unico è **mediazione**: rischio ≈2,5R venduto come 1R.
- ⏰ **Il fuso non è più assunto, è MISURATO**: server BCM = IT − 1, letto
  sull'orologio dei grafici del corso [PAG 34-35], su data invernale. Corollario:
  `SESSION_HOUR` 8 (DAX) e 14:30 (Dow) sono giusti **tutto l'anno**.
  🚩 E la tabella dei fusi [PAG 10] **contraddice gli screenshot dello stesso PDF**
  di un'ora piena.
- ⚖️ **§2.5 di questo dossier va letto con i verdetti arrivati dopo**: il piano
  **Nasdaq** (qui valutato "93% meccanizzabile, quasi un EA già scritto") prescrive
  il motore **bocciato a campione pieno da R97 (0/4) e R98 (0/6)**. Il capitolo
  NASUSD è chiuso: nessuna riapertura.
- ⭐ Invece **R88 dà ragione al corso** sullo stop all'estremo opposto
  [NAS SLIDE 11]: DD 9,76% → 3,84%, PF 1,674 → 1,84 sul Dow.
- ❗ **Il debito del §1.2 (ablazione dei filtri) resta APERTO** ed è ora una domanda
  per Claudio: rifarla su Dow/DAX o dichiararla estinta.
