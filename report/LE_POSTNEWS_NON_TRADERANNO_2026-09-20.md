# 📰 LE TRE POSTNEWS NON TRADERANNO — **misurato, e cambia il conto delle sedie**

> Nato dal censimento dei contratti (`report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md`), che
> aveva marcato le tre PostNews **`[NON MISURATO]`** con `Trades = 0` nei CSV d'archivio.
> Sono andato a vedere **perche'**, e la ragione non e' che la misura manca: e' che **il
> calendario e' finito**.

---

## ⓪ 🎯 IN TRE RIGHE

1. 🪦 **`771203` NFP USDJPY non trada MAI**: il suo calendario ha **zero eventi futuri**.
2. 🟠 **`771202` FOMC e `771204` ECB non tradano fino a FINE OTTOBRE**: il primo evento
   utile e' il **28/10/2026** (FOMC) e il **29/10/2026** (ECB).
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
| `771202` FOMC EURUSD | `abtg_news.csv` | `FOMC` | **3** | 🟠 **28/10/2026 20:00** |
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
- in repo ci sono **altri tre** calendari: `abtg_news_2021_2025_UTC.csv` (ultima riga
  **2025.12.19**), `abtg_news_live_2026-09-04.csv` (ultima riga **2026.09.04**),
  `abtg_news_ism1500_2010_2023_UTC.csv` (**2023.12.20**). 🔴 **Nessuno dei tre ha eventi
  oltre oggi**, quindi **nemmeno cambiando file** `771203` troverebbe qualcosa;
- l'unico calendario vivo e' **`abtg_news.csv`**, che pero' contiene **solo FOMC e ECB**:
  cercandoci `Unemployment Rate` non c'e' niente.
👉 Il contro-esempio non regge: **non e' il file sbagliato, e' il dato che manca.**

🟠 **E quello che NON ho verificato, dichiarato**: non so se `InpNewsCommon=true` faccia
leggere il file dalla cartella **comune** dei terminali invece che da `MQL5\Files` del
terminale FTMO. Se li' ci fosse una copia **diversa e piu' fresca**, il conto cambia.
**Si vede solo sul VPS**, ed e' una riga di sola lettura da fare lunedi'.

---

## ③ 🧮 COSA CAMBIA, in concreto

| | prima | dopo |
|---|---|---|
| sedie che tradano da lunedi' | 9 | 🔴 **6** |
| tetto di richieste al server (§⑤ del referto 2.000) | ~530/giorno | 🟢 **~515** (le PostNews valgono **0**, non ~15) |
| **Minimum Trading Days** FTMO (4 giornate) | 9 motori a contribuire | 🟢 **6 bastano largamente**: la sola famiglia Aperture fa 1,407 op/giorno |
| criterio di uscita del 18/08, corsia RISCHIO | 9 soglie | 🔴 **6 soglie**; per le tre PostNews **non puo' scattare**, e adesso si sa che **non serve** |

🟢 **Nessuna delle sei che contano e' toccata.** Il pacchetto di lunedi' non cambia.

---

## ④ 🖊️ COSA RESTA DA DECIDERE — ed e' di Claudio, non mio

1. **Rigenerare il calendario NFP** (`Unemployment Rate` 2026-2027) e ricaricarlo: e' un
   file di dati, **non tocca nessun EA e nessun parametro**. Costo: minuti.
2. **Oppure lasciarle mute fino al 28/10** e prendersi atto che la challenge si gioca su
   sei sedie. 🟢 **Non e' una perdita**: la corsia frequenza e' gia' coperta dalle Aperture,
   e le PostNews su FTMO girano a `InpRiskPercent=1.30` con `InpUseOCO=false`, cioe'
   **1,30% per evento** — tre eventi in meno sono anche tre esposizioni in meno.
3. 🔴 **In ogni caso va corretto quello che diciamo**: finche' il calendario e' quello,
   **non si scrive «nove sedie»**. L'ho scritto io stanotte, ed e' un errore di misura come
   gli altri.

---

## 🧭 LA BUSSOLA
🟢 **Buona notizia, non cattiva**: una sedia che non trada perche' un file di dati e'
scaduto e' il tipo di problema che si scopre **prima** e costa un file, non una challenge.
🔴 **Il difetto di metodo, che e' mio**: ho contato le sedie **schierate** e le ho chiamate
sedie **che tradano**. Sono due insiemi diversi, e quello che conta e' il secondo.
