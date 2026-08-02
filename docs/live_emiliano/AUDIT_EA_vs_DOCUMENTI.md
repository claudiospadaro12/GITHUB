# 🔍 AUDIT — gli EA apertura contro i DOCUMENTI ABTG

_02/08/2026. Domanda di Claudio: «i nativi sono partiti dai documenti, quindi dovrebbero rispecchiare i file ABTG»._
_Fonti: PDF «La Magia delle Aperture Europee e Americane» (ABTG, 41 pp.) + `Piano_di_trading_Europeo.pptx` + `Piano_di_Trading_America.pptx` + `Piano_di_Trading_America_Strategia_Nasdaq.pptx`. Estratto operativo in `ANALISI_SLIDE_APERTURE.md`._

## Risposta in una riga
**Lo SCHELETRO sì, i FILTRI no.** Orari, livelli, gestione, money management e trailing rispecchiano i documenti quasi alla lettera. Ma ogni **condizione d'ingresso** che il piano dà come obbligatoria è `false` di default — e una (ATR) non era proprio scritta.

---

## Tabella di audit

| # | Regola nei documenti | Nel codice (prima del 02/08) | Esito |
|---|---|---|---|
| 1 | Apertura EU 09:00 IT / US 15:30 IT | `SESSION_HOUR` 8 / 14:30 server (fuso BCM −1) | ✅ |
| 2 | *"Sfruttiamo la volatilità nei primi 15 minuti"* | `RANGE_MIN = 15` | ✅ |
| 3 | Nasdaq: *"ordini nel time frame **H1**, SELL STOP sotto i minimi precedenti, BUY STOP sopra i massimi precedenti"* | `RANGE_MODE=2` + `LEVEL_TF=H1` (default del `Nasdaq_Apertura_US`) | ✅ |
| 4 | *"Porto lo stop sui massimi precedenti"* | `InpSLMode = SL_RANGE` | ✅ |
| 5 | *"Cancello l'ordine che non è stato eseguito"* | OCO | ✅ |
| 6 | *"TP in divenire **dimezzando** sui livelli · stop **in pari**"* | `TP1_R=1`, `TP1_ClosePct=50`, `BreakevenAtTP1=true` | ✅ |
| 7 | *"Scendo in **M1**, seguo con lo stop alla base della candela precedente"* | `TRAIL_MODE=1`, `TrailTF=M1` (US) | ✅ |
| 8 | *"Sugli indici **410 punti** = 4 punti indice"* | `InpTrailFixedPts = 410` (DAX) | ✅ |
| 9 | *"Rischia max il **2%** del capitale"* | `ABTG_DEF_RISK = 2.0` | ✅ |
| 10 | Gap fill: *"RR minimo **1:1.5**"* | `InpGapMinRR = 1.5` | ✅ |
| 11 | *"Prima di ogni dato a 3 tori tolgo tutto"* | `InpNewsFlatten = true` | ✅ |
| 12 | **"Entra solo se la rottura è supportata da aumento di VOLUMI"** | `InpUseVolumeFilter = **false**` | ❌ **spento** |
| 13 | **"...o da una volatilità coerente (ATR > media)"** | **filtro inesistente** | ❌ **mai scritto** |
| 14 | **"Entra subito dopo la CHIUSURA della candela di breakout, NON durante"** | `InpEntryMode = BREAKOUT` → ordine STOP riempito *durante* | ❌ **l'opposto** |
| 15 | Checklist: *"Nessuna notizia in uscita imminente"* | `InpUseNewsFilter = **false**` | ❌ spento |
| 16 | Pre-apertura: *"conferma di trend su TF superiori (D1, H4)"* | `InpUseEmaFilter=false`, `InpUseSupertrend=false` | ❌ spenti |
| 17 | *"Analizzati gli indici correlati (225JPY, SPX500)"* — per l'EU la catena è **225JPY → SPXUSD → D30EUR** | `InpUseCorrelation = **false**`; e il filtro accetta **un solo** simbolo | ❌ spento + parziale |
| 18 | DAX: livelli da **D1/W1/MN** (Larry Williams) o max/min **giorno precedente** — il Piano Europeo **non prescrive un ORB** | `DAX_Apertura_EU` fa un **ORB dei primi 15 min** | ❌ **strategia diversa** |
| 19 | Piano Europeo: *"Supertrend, quando cambiano **tutti e tre** (2.5/3.0/3.5), posso entrare"* | un solo Supertrend | ❌ mancante |
| 20 | Nasdaq: *"non entriamo subito a mercato, ma **divido la size**"* (parte sul livello, parte sulla media 14) | ingresso unico | ❌ mancante |
| 21 | SL: *"ATR, oppure **5-10 punti** sotto/sopra la linea di breakout"* | `InpMinStopPts = 0` (nessun floor) | ⚠️ da tarare |

**Punteggio: 11 regole rispettate su 21.** Le 10 mancanti sono **tutte** nel livello "conferma d'ingresso e contesto" — cioè esattamente ciò che distingue il metodo del corso da un breakout cieco.

---

## Cosa ho fatto (02/08)

**Nel codice** (`ABTG_Nasdaq_Apertura_US.mq5` + `ABTG_DAX_Apertura_EU.mq5`, entrambi opt-in, **default invariati**):
- ✅ #13 → `InpUseAtrFilter` + `InpAtrFilterBars` (20) + `InpAtrFilterMult` (1.0): entra solo se l'ATR dell'ultima barra ≥ la sua media. Montato sul breakout e sull'ingresso confermato.
- ✅ #19 → `InpUseSupertrend3`: i tre Supertrend 2.5/3.0/3.5 devono **concordare**, altrimenti nessun ordine.
- ✅ #14 → già coperto da `InpEntryMode=DELAYED` (implementato in mattinata: aspetta e poi entra a mercato dalla parte scelta).

**Negli script** (`conferma_apertura_us.ps1`, `conferma_apertura_dax.ps1`): nuovo switch **`-Doc`** che accende in blocco la configurazione dei documenti (#3 #12 #13 #15 #16 #17 #18 #19 + risk 2%).

**Restano non implementati:** #20 (size divisa in due ingressi) e la catena di correlazione a due simboli (#17). Sono modifiche più invasive: le faccio se il test dice che vale la pena.

---

## ⚠️ Perché NON ho cambiato i default dei nativi

Mettere i filtri a `true` nel codice significa che **alla prossima ricompilazione sul VPS il forward cambia comportamento**, con una configurazione **mai misurata**. Sarebbe contro il metodo del progetto (prima i numeri) e contro la regola "gli Ottimizzato girano accanto agli originali, non li sostituiscono".

Quindi: prima si misura la configurazione dei documenti a tick reali, poi — se regge — si cambiano i default e si ricompila. **Se il test conferma il piano, cambiare i default è il passo successivo e lo faccio subito.**

---

## ▶️ Il test

```powershell
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/claude/chat-ea-market-openings-zoba2j/backtest_pipeline/confronto_documenti.ps1" | iex
```
Gira 4 combinazioni a tick reali: US e DAX × (ordini **STOP** come le slide Nasdaq | ingresso **CONFERMATO** come il PDF).

### 🔴 Cosa guardare per primo: il NUMERO DI TRADE
Le fonti divergono su un punto (le slide Nasdaq dicono STOP, il PDF dice "dopo la chiusura") e il piano impila **cinque conferme** insieme. Con tutti i filtri accesi i trade possono crollare dai ~440 attuali a poche decine: sotto ~80 trade **il PF non è più un'informazione affidabile**, è rumore.

Se succede, si toglie **un filtro alla volta** in questo ordine (dal meno al più prescrittivo nelle fonti):
1. correlazione SPXUSD → 2. filtro news → 3. trend H4 / Supertrend×3 → 4. ATR → 5. volumi.
I volumi si tolgono per ultimi: sono la conferma che il PDF ripete più volte.
