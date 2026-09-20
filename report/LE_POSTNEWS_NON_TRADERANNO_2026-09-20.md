# 📰 LE TRE POSTNEWS NON TRADERANNO — **misurato, e cambia il conto delle sedie**

> Nato dal censimento dei contratti (`report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md`), che
> aveva marcato le tre PostNews **`[NON MISURATO]`** con `Trades = 0` nei CSV d'archivio.
> Sono andato a vedere **perche'**, e la ragione non e' che la misura manca: e' che **il
> calendario e' finito**.

---

## ⓪ 🎯 IN TRE RIGHE

1. 🪦 **`771203` NFP USDJPY non trada MAI**: il suo calendario ha **zero eventi futuri**.
2. 🟠 **`771202` FOMC e `771204` ECB non tradano almeno fino a FINE OTTOBRE**: nel file che
   ho misurato il primo evento utile e' il **28/10/2026** (FOMC) e il **29/10/2026** (ECB).
   🔴 **MA quella data NON E' STABILITA** — vedi §②: in repo ci sono **due** `abtg_news.csv`
   diversi, e quello che la catena di casa distribuisce ai terminali ha **zero eventi
   futuri**. Potrebbero essere mute **anche dopo** il 28/10.
3. 👉 **Quindi da lunedi' la flotta FTMO e' di SEI sedie, non nove.** Io stesso avevo
   scritto *«nove sedie che tradano»*: e' vero che sono schierate e capaci, **e' falso che
   tradino** nella finestra che ci interessa.

---

## ① 📏 LA MISURA — comandi e uscite, non riassunti

I tre preset che volano (`mql5/Presets/FTMO/ABTG_PostNews_*_FTMO.set`) hanno tutti
**`InpRestrictToNews=true`**: l'EA opera **solo** su un evento che trova nel file
calendario. Quindi il calendario **e' il rubinetto**.

| sedia | `InpNewsFile` | `InpNewsTitleMatch` | eventi futuri dal 20/09/2026 | primo evento utile |
|---|---|---|---:|---|
| `771202` FOMC EURUSD | `abtg_news.csv` | `FOMC` | **3** | 🟠 **28/10/2026 20:00** *(ma vedi §②b)* |
| `771203` NFP USDJPY | `abtg_news_postnews_2010_2025_UTC.csv` | `Unemployment Rate` | 🔴 **0** | 🪦 **nessuno** |
| `771204` ECB EURUSD | `abtg_news.csv` | `ECB` | **2** | 🟠 **29/10/2026 14:15** |

```
$ tail -1 mql5/Files/abtg_news_postnews_2010_2025_UTC.csv
2025.07.03 11:30;High;USD;Unemployment Rate          <-- l'ULTIMA riga e' di 14 mesi fa

$ awk -F';' '$1>"2026.09.20"' mql5/Files/abtg_news.csv
Data Ora;Impatto;Valuta;Titolo                        <-- intestazione
2026.10.28 20:00;High;USD;FOMC Statement / Federal Funds Rate
2026.12.09 20:00;High;USD;FOMC Statement / Federal Funds Rate
2027.01.27 20:00;High;USD;FOMC Statement / Federal Funds Rate
2026.10.29 14:15;High;EUR;ECB Main Refinancing Rate
2026.12.17 14:15;High;EUR;ECB Main Refinancing Rate
```

🟢 **E il modo in cui fallisce e' quello giusto: FAIL-CLOSED.** Un calendario finito non fa
sbagliare l'orario: fa **non aprire**. `771203` non e' una sedia pericolosa, e' una sedia
**muta**. Nessun rischio nuovo, nessuna taglia in gioco.

---

## ② 🧪 IL CONTRO-ESEMPIO — perche' «zero eventi futuri» non basta come prova

**L'altra spiegazione possibile era: «l'EA ha un calendario di riserva, o ne scarica uno».**
Controllato:
- in `mql5/Files/` ci sono **altri QUATTRO** calendari — li elenco per nome, che e' la
  regola: `abtg_news_2021_2025_UTC.csv` · `abtg_news_live_2026-09-04.csv` ·
  `abtg_news_ism1500_2010_2023_UTC.csv` · **`abtg_news_usd1330_2010_2023_UTC.csv`**
  *(quest'ultimo nella prima stesura l'avevo dimenticato: avevo scritto «altri tre»)*.
  🔴 **Tutti e quattro hanno ZERO eventi oltre oggi**, contati: nemmeno cambiando file
  `771203` troverebbe qualcosa;
- l'unico calendario vivo e' **`abtg_news.csv`**. ✏️ **E qui la prima stesura diceva una
  cosa falsa**: non contiene «solo FOMC e ECB». I titoli distinti sono **cinque**
  (`ADP Non-Farm Employment Change` · `CPI m/m` · `Non-Farm Payrolls` ·
  `ECB Main Refinancing Rate` · `FOMC Statement / Federal Funds Rate`). 🟢 **La conclusione
  regge lo stesso, e per due motivi**: nessuna riga contiene la stringa `Unemployment Rate`
  — che e' cio' che `InpNewsTitleMatch` della `771203` cerca — **e** le uniche righe NFP
  sono del 09/01, 06/02 e 06/03/2026, **tutte passate**.
👉 Il contro-esempio non regge: **non e' il file sbagliato, e' il dato che manca.**

🔴 **E QUELLO CHE NON HO VERIFICATO E' PIU' LARGO DI COME L'AVEVO SCRITTO — il cancello me
l'ha smontato, e le due cose le ho poi misurate io.**

**(a) Non e' solo la NFP a leggere dalla cartella COMUNE: sono tutte e tre.**
`InpNewsCommon` ha **default `true`** nel sorgente (`ABTG_PostNews.mq5` r.88) e `LoadNews`
(r.532) apre **prima `Common\Files`**, poi la sandbox del terminale. I preset `771202` e
`771204` **non scrivono quell'input** (28 righe contro 32 del binario), quindi resta `true`.
👉 **Il file che conta sta sul VPS, in `Common\Files`, e NON l'ho misurato.**

**(b) 🔴 E in repo ci sono DUE `abtg_news.csv`, e NON sono lo stesso file** (contato da me):

| percorso | righe | eventi dopo il 20/09/2026 |
|---|---:|---|
| `mql5/Files/abtg_news.csv` *(quello che ho misurato)* | 18 | **5** (3 FOMC + 2 ECB) |
| 🔴 **`data/abtg_news.csv`** | 16 | 🔴 **ZERO** |

E **`data/` e' quello che la catena di casa distribuisce**: `backtest_pipeline/aggiorna_news.ps1`
r.32 scarica `.../lavoro/**data**/abtg_news.csv` e lo scrive dentro `MQL5\Files` del terminale.
👉 **Quindi la riga «tornano vive il 28/10» vale SOLO se in `Common\Files` del VPS c'e' la
copia di `mql5/Files`. Se c'e' quella di `data/`, non tornano vive affatto.**
**[NON MISURATO]**, e si chiude con una riga di sola lettura sul VPS lunedi'.

---

## ③ 🧮 COSA CAMBIA, in concreto

| | prima | dopo |
|---|---|---|
| sedie che tradano da lunedi' | 9 | 🔴 **6** |
| tetto di richieste al server (`LE_2000_RICHIESTE_LA_MISURA_2026-09-20.md` §⑤, r.252 e r.256) | ~530/giorno | 🟢 **~515** (le PostNews valgono **0**, non ~15) |
| **Minimum Trading Days** FTMO (4 giornate) | 9 motori a contribuire | 🟢 **6 bastano largamente**: la sola famiglia Aperture fa 1,407 op/giorno |
| criterio di uscita del 18/08, corsia RISCHIO | 9 soglie | 🔴 **6 soglie**; per le tre PostNews **non puo' scattare**, e adesso si sa che **non serve** |

🟢 **Nessuna delle sei che contano e' toccata.** Il pacchetto di lunedi' non cambia.

---

## ④ 🖊️ COSA RESTA DA DECIDERE — ed e' di Claudio, non mio

1. **Rigenerare il calendario NFP** (`Unemployment Rate` 2026-2027) e ricaricarlo.
   ⚠️ **Tecnicamente e' un file di dati** — non tocca nessun EA e nessun parametro — **ma
   l'effetto NON e' neutro: accenderebbe su un conto challenge una sedia il cui contratto e'
   `[NON MISURATO]` su tutta la riga** (nessun PF, nessun `n`, nessun DD), che opera a
   **1,30% per evento** perche' `InpUseOCO=false` lascia sommare le due gambe.
   🔴 **E' una firma di RISCHIO travestita da manutenzione dati**, non una manutenzione.
   Costo tecnico: minuti.
2. **Oppure lasciarle mute fino al 28/10** e prendersi atto che la challenge si gioca su
   sei sedie. 🟢 **Non e' una perdita**: la corsia frequenza e' gia' coperta dalle Aperture,
   e le PostNews girano a `InpRiskPercent=1.30` riferito a `InpRiskRefSLpips=50` con stop
   reale a 25 pip, cioe' **0,65% per gamba**. ✏️ **E `InpUseOCO=false` vale per UNA sola**,
   non per tutte e tre (errore della prima stesura): ce l'ha **solo la NFP `771203`** ->
   **1,30% per evento**; su FOMC e ECB l'input non e' scritto nei `.set` (28 righe contro 32)
   quindi resta al **default `true`** -> **0,65% per evento**.
3. 🔴 **In ogni caso va corretto quello che diciamo**: finche' il calendario e' quello,
   **non si scrive «nove sedie»**. L'ho scritto io stanotte, ed e' un errore di misura come
   gli altri.

---

### ⏰ E una data che merita un avviso
🔴 Il **28/10/2026** cade **dentro la settimana in cui il delta orario FTMO-BCM e' dichiarato
INCERTO**: il DST europeo finisce il **25/10**, quello americano il **01/11**. Se FTMO
seguisse il calendario americano, fra il 25/10 e il 01/11 il fuso cambierebbe di un'ora — e i
preset PostNews hanno **l'ora d'azione cablata** (`InpActionHour`). Va misurato a terminale
acceso prima di quella data, non dedotto.

---

## 🧭 LA BUSSOLA
🟢 **Buona notizia, non cattiva**: una sedia che non trada perche' un file di dati e'
scaduto e' il tipo di problema che si scopre **prima** e costa un file, non una challenge.
🔴 **Il difetto di metodo, che e' mio**: ho contato le sedie **schierate** e le ho chiamate
sedie **che tradano**. Sono due insiemi diversi, e quello che conta e' il secondo.
