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
