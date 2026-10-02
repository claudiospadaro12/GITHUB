# 📰 LE TRE POSTNEWS — FOMC, ECB, US EMPLOYMENT: perche' erano mute e cosa serve perche' lavorino

**02/10/2026** · richiesta di Claudio: *"DEVI CORREGGERMI TUTTI GLI EA POST NEWS, SONO 3. VOGLIO CHE LAVORINO"* ("FOMC, ECB e US Employment").

---

## ⓪ IN SEI RIGHE

1. 🎯 **Le tre sedie sono tutte sul DEMO piccolo `50503392`** (profilo ORO): `771201` ECB EURJPY · `771202` FOMC EURUSD · `771203` NFP USDJPY. (Misurato: `CODA_08` del 02/10 03:30. Nessun'altra PostNews in campo.)
2. 🔴 **Il difetto non e' l'EA: e' il calendario.** Oggi alle 14:45 IT l'EA ha scritto `nessuna notizia nel CSV oggi: niente ordini.` — la sicurezza ha funzionato, ma il rubinetto era chiuso.
3. 🔴 **Sul VPS, in `Common\Files`**: `abtg_news.csv` ha **una riga** (ECB del 10/09, gia' passata) e `abtg_news_live_2026-09-04.csv` e' **vuoto** (neutralizzato il 07/09). Zero eventi futuri per tutte e tre.
4. 🟢 **Fix lato dati: un calendario DEDICATO** `abtg_postnews_calendario.csv` con i sei prossimi eventi, **date verificate su fonti pubbliche** (BLS, ECB, FOMC). Lo crea la riga di lancio, **non tocca `abtg_news.csv`**.
5. 🔴 **Ma c'e' un SECONDO difetto, piu' subdolo: l'orologio.** Le ore d'azione dei preset sono fisse in ora server BCM (UTC+1 fisso). D'inverno **ECB** (da 29/10), **NFP** (06/11) e **FOMC 09/12** cadrebbero **PRIMA** della notizia, non dopo. Va corretto a mano (tabella sotto).
6. ✋ **Serve il tuo F7 sui tre grafici** del `50503392`: la riga scrive il file, ma le sedie lo leggono solo dopo che cambi `InpNewsFile`.

---

## ① 📅 GLI EVENTI (date verificate)

| sedia | evento | giorno | orario reale | fonte |
|---|---|---|---|---|
| `771202` | FOMC | **mer 28/10/2026** · **mer 09/12/2026** | 14:00 ET | calendario FOMC 2026 (riunioni 27-28/10 e 8-9/12) |
| `771201` | ECB | **gio 29/10/2026** · **gio 17/12/2026** | 14:15 CET | calendario BCE 2026 (decisione al giorno 2) |
| `771203` | US Employment (NFP) | **ven 06/11/2026** · **ven 04/12/2026** | 08:30 ET | calendario BLS 2026 |

🔴 **Cosa NON e' nel calendario:** niente dopo il 17/12/2026 e niente 2027 (date non verificate: non le invento). **Il file va rinnovato a meta' dicembre.** Una data sbagliata in questo file e' pericolosa (l'EA arma sulla sola data), per questo sono solo sei e verificate.

🟡 **Fra oggi e il 28/10 nessuna delle tre ha eventi: le sedie non faranno niente, ed e' giusto.** "Lavorino" vuol dire pronte il 28/10, 29/10 e 06/11.

---

## ② 🕰️ L'OROLOGIO — il secondo difetto (misurato sui numeri, non opinione)

Il BCM e' **UTC+1 fisso** (OROLOGIO_BCM_2026-09-24). Le notizie seguono invece il loro fuso. Orario della notizia in ora server BCM:

| evento | estate (oggi) | inverno | ora d'azione nel preset | scarto estate | scarto inverno se NON si cambia |
|---|---|---|---|---:|---:|
| ECB `771201` | 13:15 (decisione 14:15 CEST) | **14:15** (14:15 CET) | 14:00 | +45 min dopo | 🔴 **−15 min (prima!)** |
| NFP `771203` | 13:30 (8:30 EDT) | **14:30** (8:30 EST) | 13:45 | +15 min dopo | 🔴 **−45 min (prima!)** |
| FOMC `771202` 28/10 | 19:00 (14:00 EDT) | 19:00 (USA ancora EDT fino al 01/11) | 19:40 | +40 min | 🟢 **+40 min: invariato** |
| FOMC `771202` 09/12 | 19:00 | **20:00** (14:00 EST) | 19:40 | +40 min | 🔴 **−20 min (prima!)** |

🔴 **Perche' "prima" e' grave:** la regola misura il range *dopo* la notizia. Con l'azione prima della notizia l'EA metterebbe gli ordini sul range di *prima*: **e' un'altra strategia, mai misurata.** Per questo l'orario si sposta di **+1 h** (azione **e** scadenza, cosi' la finestra resta quella del preset).

### Valori da mettere (con F7 → Input), sempre e solo sul terminale `50503392`

| grafico (profilo ORO) | `InpNewsFile` | `InpActionHour:Min` | `InpExpiryHour:Min` | quando |
|---|---|---|---|---|
| **USDJPY M5** — `771203` NFP | `abtg_postnews_calendario.csv` | **14 : 45** (era 13:45) | **17 : 59** (era 16:59) | **ora** (prossimo evento 06/11, inverno) |
| **EURJPY** — `771201` ECB | `abtg_postnews_calendario.csv` | **15 : 00** (era 14:00) | **18 : 15** (era 17:15) | **ora** (prossimo evento 29/10, inverno) |
| **EURUSD** — `771202` FOMC | `abtg_postnews_calendario.csv` | 19 : 40 *(invariato)* | 20 : 45 *(invariato)* | **ora solo il file**; |
| ↳ stessa | — | **20 : 40** | **21 : 45** | **dopo il 28/10, prima del 09/12** |

✅ Restano **uguali**: rischio `1.3`, magic, SL/TP, offset, OCO, `InpFridayClose*`, `InpNewsCommon=true`, `InpRestrictToNews=true`. **Non premere Resetta/Carica.**
⚠️ `771203` prima leggeva `abtg_news_live_2026-09-04.csv`: passa anche lui al file nuovo (uno solo da mantenere).

### Come verificare dopo il F7 (30 secondi)
In **Esperti**, per ognuno dei tre grafici, deve comparire:
`[PostNews][NEWS] letto da Common\Files | righe 6 | UTILI per questo preset 2 (... ) | dal 2026.xx.xx al 2026.xx.xx`
(`UTILI 2` e le due date del suo evento.) Se vedi `CALENDARIO CIECO` o `UTILI 0`, **mandami la foto**.

---

## ③ 🧮 COSA NON E' CAMBIATO (e va detto)

- 🔴 **Rischio e taglie**: **identici** (1,30% per evento; `771201`/`771202` con OCO ≈ 0,65%, `771203` senza OCO fino a 1,30%). Il piccolo **non ha Guardian**. Sono tre sedie su **demo**.
- 🔴 **Contratti: `[NON MISURATO]`** per tutte e tre (nessun PF/n/DD). Lavorare vuol dire **raccogliere osservazioni**, non dimostrare un edge: tre eventi in tre mesi sono tre numeri.
- 🟡 **Piu' in la:** dal 25/10 il clock BCM cambia anche per tutte le sedie a ora fissa (decisione di Claudio entro il 25/10, OROLOGIO_BCM_2026-09-24). Qui ho coperto solo le tre PostNews.

## ④ 🔧 BACKLOG (non fatto oggi)
- Il generatore giornaliero di `data/abtg_news.csv` produce **0 byte dal 26/07** (la riga delle 07:20 lo scarta, giustamente). Non alimenta queste tre.
- Per non dipendere piu' da F7 a mano: far leggere all'EA l'orario dalla riga del calendario (modifica EA = firma + ricompilazione). Da decidere.
- Rinnovo calendario a dicembre.
