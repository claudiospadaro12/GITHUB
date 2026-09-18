# 📑 LE SLIDE DEL NASDAQ — **il metodo del corso non l'abbiamo MAI girato per intero**

**18/09/2026 sera** · richiesta di Claudio: *«VAI A RILEGGERTI LE SLIDE SUL NASDAQ»*
Fonte: `docs/live_emiliano/ANALISI_SLIDE_APERTURE.md` (estratto del 02/08 di
`Piano_di_Trading_America_Strategia_Nasdaq.pptx`, 15 slide, + il PDF ABTG da 41 pagine)
e `docs/piani_abtg/Piano_Trading__NASDAQ__ABTG.pdf`.

> # 🎯 **LE SLIDE DICONO DUE COSE INSIEME. NOI LE ABBIAMO MISURATE UNA ALLA VOLTA, MAI INSIEME.**

---

## ① COSA CHIEDONO LE SLIDE, e quanto siamo fedeli

🟢 **Sui LIVELLI siamo fedeli, e questo va detto per primo:**

| regola dalle slide | nel nostro EA |
|---|---|
| *«Si posizionano ordini nel time frame **H1**»* | ✅ `InpLevelTF = PERIOD_H1` |
| *«SELL STOP sotto i **minimi precedenti**, BUY STOP sopra i **massimi precedenti**»* | ✅ `InpRangeMode = 2` (candela precedente) |
| *«Porto lo stop sui massimi precedenti»* | ✅ `InpSLMode = ABTG_SL_RANGE` |
| *«Cancello l'ordine che non è stato eseguito»* | ✅ OCO |
| *«TP in divenire, **dimezzando** · stop **in pari**»* | ✅ parziale 50% a 1R + BE |
| *«Scendo in **M1**, seguo con lo stop alla base della candela precedente»* | ✅ `TRAIL_MODE = 1` |

🔴 **E su DUE cose no — e sono proprio le due che il corso ripete:**

**(a) L'INGRESSO.** Testuale dal PDF:
> *«**Entra subito dopo la CHIUSURA della candela di breakout, NON durante.**»*

Noi entriamo con **ordini STOP che si riempiono DURANTE la rottura**. È l'opposto letterale.

**(b) LA CONFERMA.** Testuale:
> *«Entra solo se la rottura è supportata da **aumento di volumi** o da una volatilità coerente
> (**ATR > media**). **Evita falsi segnali nelle prime candele**.»*

---

## ② 🔴 LA CROCE CHE NON ABBIAMO MAI GIRATO

Ho controllato riga per riga **quale ingresso** aveva ogni round e **quali filtri** erano accesi:

| | **filtri SPENTI** | **filtri ACCESI** |
|---|---|---|
| **ingresso BREAKOUT** (ordine STOP, il nostro) | `R84a`: OOS **PF 0,873** | `R84b…R84i`: **9 celle, 9 OOS negative** |
| **ingresso alla CHIUSURA** (il metodo delle slide) | `R83n2`: OOS **PF 0,979** 🥇 | 🔴 **MAI MISURATO** |

**Le prove, per riga:**
- `prove/R84a_base_NASUSD.txt` → `InpEntryMode=0` (**breakout**), volumi 0, ATR 0.
- `prove/R84i_completo_NASUSD.txt` → `InpEntryMode=0` (**breakout**), EMA 1 · correlazione 1 ·
  volumi 1 · ATR 1. 👉 **Tutte e nove le celle di R84 girano sull'ingresso BREAKOUT.**
- `prove/R83n2_conferma_NASUSD.txt` → `InpEntryMode=2` = `ABTG_ST_CLOSECONF` = *«MARKET alla
  CHIUSURA di una candela oltre il livello»* → **ma volumi 0, ATR 0, EMA 0, Supertrend 0,
  correlazione 0.**

> ## 🔴 **Quindi: abbiamo provato i FILTRI sull'ingresso SBAGLIATO, e l'ingresso GIUSTO senza FILTRI. Il metodo del corso, come sta scritto, sul Nasdaq NON È MAI STATO MISURATO.**

### 🥇 E il pezzo che si intravede
`R83n2` — l'ingresso delle slide, **nudo** — fa **OOS PF 0,979 su 313 operazioni, DD 6,18%**:
**il migliore dei tre stili** (breakout 0,873 · retest 0,624) e **quasi in pari**, con il
drawdown **più basso di tutto il duello**.
👉 È l'unico ingresso che sul Nasdaq non perde per davvero — **e gli manca esattamente la metà
che il corso considera obbligatoria.**

⚠️ **E la riserva, detta insieme al numero**: PF 0,979 è **sotto 1**. Non è un edge, è un
pareggio. I filtri devono **aggiungere**, non solo tagliare — e R84 ha misurato che sul breakout
i filtri **riducono la perdita senza creare edge**. Se facessero lo stesso qui, 0,979 resta 0,979.
**Questa è un'ipotesi da misurare, non una promessa.**

---

## ③ 🔴 E C'È UN TERZO PEZZO DELLE SLIDE CHE NON ESISTE NEL CODICE

> *«Non entriamo subito a mercato, ma **divido la size**»* — una parte sui massimi precedenti,
> una parte sulla **media 14**.

Nel `ABTG_Nasdaq_Apertura_US` **l'ingresso è unico**. La size frazionata **non è implementata**.
🟢 *Ma il meccanismo ce l'abbiamo già altrove*: `ABTG_SuperWave` lo fa (`InpFirstFraction=0.3333`,
1/3 a mercato + 2/3 in pendente) — quindi è codice da portare, non da inventare.

---

## ④ COSA DICE QUESTO SU «PERCHÉ A LORO FUNZIONA E A NOI NO»

**Non perché il metodo sia sbagliato, e non perché il nostro EA sia scritto male.**
Perché **il nostro EA implementa i LIVELLI del corso e non il suo INGRESSO**, e i filtri
obbligatori li abbiamo provati attaccati all'ingresso che il corso dice di non usare.

📌 **Coerente con quello che si legge nelle immagini di oggi**: là compaiono livelli che noi non
usiamo affatto (*max/min notturno · max giorno prec. · apertura giorno · max sett. prec.*).
Se il loro EA lavora **quei** livelli, allora la distanza è doppia — ingresso **e** livello.

---

## 🎯 COSA SI FA, in ordine di valore e di costo

1. 🥇 **La croce mancante**: ingresso a **CHIUSURA** + **volumi/ATR**, sul Nasdaq, alle stesse
   condizioni di R83/R84 (stessa finestra, stessi livelli, tick reali). **È un round solo**, e
   chiude un buco che ha ingannato tre verdetti.
2. 🥈 **`ABTG_MaxMinNotte` sul Nasdaq** — mai puntato lì (censimento: 24 file D30EUR, 8 XAUUSD,
   2 EURUSD, **0 NASUSD**), ed è il motore che usa i livelli notturni delle immagini.
3. 🥉 **La size frazionata** sull'EA delle aperture: codice già esistente in `SuperWave`.

🚫 **Niente di tutto questo riaccende `770201`**, che resta spenta e [SENZA CONTRATTO].
E 🔴 **nessuna di queste tre è una misura già fatta**: sono tre buchi, e li ho verificati
riga per riga prima di chiamarli tali — oggi ho già sbagliato due volte a dire «mai provato».

---
*Fonti: `docs/live_emiliano/ANALISI_SLIDE_APERTURE.md` (§«IL PUNTO CHE CAMBIA TUTTO» e §NASDAQ) ·
`docs/piani_abtg/Piano_Trading__NASDAQ__ABTG.pdf` · `prove/R83n2_conferma_NASUSD.txt`,
`prove/R84a_base_NASUSD.txt`, `prove/R84i_completo_NASUSD.txt` (righe `InpEntryMode` e `InpUse*`) ·
`r83_csv/ABTG_Apertura_3Ingressi_NASUSD_OOS_r83n2.csv` · `mql5/Experts/ABTG_SuperWave.mq5` r.71.*
