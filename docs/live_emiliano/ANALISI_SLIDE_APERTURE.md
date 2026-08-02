# 📑 LE SLIDE DI EMILIANO / ABTG — cosa dicono davvero sulle APERTURE

_Caricate da Claudio il 02/08/2026. Fonti:_
- `Piano_di_trading_Europeo.pptx` (25 slide) — apertura EUROPEA, Forex Trading Diary / Emiliano Monza
- `Piano_di_Trading_America.pptx` (12 slide) — apertura AMERICANA
- `Piano_di_Trading_America_Strategia_Nasdaq.pptx` (15 slide) — **strategia Nasdaq**
- `ABTGApertura_Mercati_20240507.pdf` (41 pp.) — *«La Magia delle Aperture Europee e Americane»*, Alfio Bardolla Training Group, 07.05.2025

> ⚠️ I file NON sono nel repo (troppo pesanti / materiale del corso): questo documento ne è l'estratto operativo. Se servono i file originali, sono nelle chat di Claudio.

---

## 🔴 IL PUNTO CHE CAMBIA TUTTO

Il PDF dice, **testuale**:
> *"**Entra subito dopo la chiusura della candela di breakout, non durante.**"*

e nella checklist operativa d'apertura chiede:
> *"Candela di rottura **chiusa** oltre il livello tecnico?" · "Breakout confermato da **volumi** e price action?" · "**ATR** conferma volatilità adeguata?" · "**Ordine a mercato** (o pendente) già pianificato?"*

E sul breakout notturno:
> *"Entra solo se la rottura è supportata da **aumento di volumi** o da una volatilità coerente (**ATR > media**). **Evita falsi segnali nelle prime candele**."*

**Noi abbiamo testato per settimane l'opposto**: ordini STOP che si riempiono **durante** la rottura, senza conferma di chiusura, senza filtro volumi, senza filtro ATR. Il metodo del corso è un **ingresso confermato dopo la chiusura della candela** — cioè esattamente il motore `DELAYED` implementato il 02/08, non il `BREAKOUT` che abbiamo bocciato.

---

## 🇺🇸 NASDAQ (slide dedicate) — il nostro EA è FEDELE, i filtri no

| Regola dalle slide | Nel nostro EA |
|---|---|
| *"Si posizionano ordini nel time frame **H1**"* | ✅ `InpLevelTF = PERIOD_H1` |
| *"SELL STOP sotto i **minimi precedenti**, BUY STOP sopra i **massimi precedenti**"* | ✅ `ABTG_DEF_RANGE_MODE = 2` (candela precedente), è il default del `ABTG_Nasdaq_Apertura_US` |
| *"Porto lo stop sui massimi precedenti"* | ✅ `InpSLMode = ABTG_SL_RANGE` |
| *"Cancello l'ordine che non è stato eseguito"* | ✅ OCO |
| *"TP in divenire, **dimezzando** sui livelli importanti · stop **in pari**"* | ✅ parziale 50% a 1R + BE |
| *"Scendo in **M1**, seguo con lo stop alla **base della candela precedente**"* | ✅ `ABTG_DEF_TRAIL_MODE = 1` |
| Conferma volumi / ATR / correlazione SPX | ❌ **mai accesa in un backtest** |
| *"Non entriamo subito a mercato, ma **divido la size**"* (parte sui massimi, parte sulla **media 14**) | ❌ non implementato (ingresso unico) |
| Money management: **max 2%** di perdita | ⚠️ noi testiamo a 1% |

→ Sul **Nasdaq/Dow lo scheletro è giusto**. Quello che manca è il **livello dei filtri** e l'ingresso a size divisa.

## 🇪🇺 DAX (Piano Europeo) — qui abbiamo sbagliato strategia, non parametri

Le slide europee **non descrivono affatto un ORB breakout sul DAX**. Descrivono:
- **Correlazione a catena**: *"Il 225JPY influenza l'SPXUSD che influenza a sua volta il D30EUR"* → i due vanno guardati **entrambi** in apertura.
- **Livelli tracciati la domenica** con la tecnica di Larry Williams su D1/W1/MN (monthly azzurro, weekly arancione, daily verde) → ordini pendenti **sui livelli**, a favore di trend.
- **Supertrend ×3 (2.5 / 3.0 / 3.5)**: *"quando cambiano **tutti e tre**, posso entrare a mercato"*.
- **Medie 89 / 100 / 200 / 14 EMA**, Multipivot, **Bollinger M15** (ordine fuori banda, target la mediana).
- Trailing: *"sugli indici **410 punti** = 4 punti indice"* (è il default che già usiamo).
- *"Post apertura ore 10:00: se l'ultimo livello di Supertrend ha mantenuto la conformazione e la candela apre all'interno, il livello è forte."*
- Il D30EUR *"risente dei livelli tecnici"* (mentre lo U30USD *"può violarli leggermente ma li ritesta"*).

Nelle live Emiliano è esplicito: *"l'ORB è **un'altra strategia** che noi abbiamo"* — **separata** dal piano di apertura europeo.

→ **Il `ABTG_DAX_Apertura_EU` implementa un ORB che il piano DAX non prescrive.** Non stupisce che 3 motori su 3 falliscano: stiamo testando bene una strategia che sul DAX non è quella del corso.

## ⏰ Orari e contesto (dal PDF)
- **09:00** apertura EU: *"il primo vero banco di prova della giornata. Il DAX è liquido, reattivo e altamente volatile, ideale per strategie di breakout e pre-apertura."* Fascia ideale DAX: **09:00–11:00 CET**.
- **15:30** apertura US. *"Sfruttiamo la volatilità nei **primi 15 minuti**"* → conferma `InpRangeMinutes = 15`.
- **Checklist pre-apertura 08:30**: indici correlati (225JPY, SPX) analizzati · trend confermato su **D1 e H4** · confluenza con EMA/Supertrend/S-R · setup confermato **anche su H1 e M15**.
- Prima di ogni dato **a 3 tori**: si toglie tutto (posizioni e pendenti) → già implementato (`InpNewsFlatten`).

---

## 📋 COSA NE SEGUE — la lista dei test che mancano davvero

Nessuno di questi è mai stato girato:

1. **Ingresso confermato dopo la chiusura della candela** (PDF, testuale) → motore `DELAYED` con `InpDelayDirMode=0`. **Il test è già pronto** (`confronto_ritardata.ps1`).
2. **Filtro volumi + ATR sulla rottura** → `InpUseVolumeFilter=1` (già +50%, 20 barre). Il PDF lo dà come **condizione d'ingresso**, non come opzione.
3. **Filtro VWAP M15** → `InpUseVwapFilter=1`.
4. **Filtro trend D1/H4** (checklist pre-apertura) → `InpUseEmaFilter` / `InpUseSupertrend` sui TF alti.
5. **Correlazione SPX / 225JPY** → `InpUseCorrelation=1` (già nel codice, `InpCorrSymbol="SPXUSD"`); per il DAX il piano vuole **225JPY → SPX → DAX**.
6. **DAX: cambiare proprio strategia** — livelli D1/W1 + Supertrend ×3 concordi, non ORB. È un EA nuovo, non un parametro.
7. Size divisa in due ingressi (parte sul livello, parte sulla media 14) — modifica di codice, bassa priorità.

## ✅ Cosa il corso conferma di ciò che già facciamo
Parziale + stop in pari + trailing (è **letteralmente** la gestione del piano), flatten sulle news a 3 tori, trailing 410 punti sugli indici, TF operativo H1 con gestione M15/M1, livelli = massimi/minimi precedenti su H1 per il Nasdaq, ORB 15 minuti, max/min della notte come livelli.
