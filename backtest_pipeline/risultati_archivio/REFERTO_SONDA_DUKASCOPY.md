# 🇨🇭 SONDA DUKASCOPY — 15/08/2026 ore 15:52

_Fonte: `sonda_dukascopy.zip` da `DESKTOP-H4D7CAJ`. Dati grezzi in
`backtest_pipeline/risultati_prove/dukascopy_sonda/`._

> ## ✅ CONTROLLO POSITIVO: **OK**
> `EURUSD` risponde in **tutti e nove** gli anni sondati, 2008 compreso.
> Quindi la connessione funziona e ogni `ASSENTE` di questa corsa
> **significa qualcosa**. Senza questa riga, il resto del referto non
> varrebbe niente.

---

## 1. 🎉 IL RISULTATO: gli indici arrivano al **2012**

Sonda: file dei tick grezzi (`.bi5`) all'ora **15 UTC**, dentro la seduta
americana in entrambe le stagioni e dentro quella tedesca. Cinque giorni
infrasettimanali di giugno per anno, vale il migliore.

| simbolo Dukascopy | che cos'e' | primo anno con dati |
|---|---|---|
| `USATECHIDXUSD` | **Nasdaq 100** | **2012** |
| `USA500IDXUSD` | **S&P 500** | **2012** |
| `DEUIDXEUR` | **DAX 40** | **2012** |
| `GBRIDXGBP` | FTSE 100 | **2012** |
| `FRAIDXEUR` | CAC 40 | **2012** |
| `EUSIDXEUR` | Euro Stoxx 50 | **2012** |
| `JPNIDXJPY` | **Nikkei 225** | **2015** (2012 risponde ma vuoto) |
| `EURUSD` | _controllo positivo_ | **2008 e oltre** |

**Cosa ci sta dentro, e che a BCM manca del tutto:**

| regime | anno | Dukascopy |
|---|---|---|
| crollo Covid | 2020 | ✅ |
| orso + inflazione | 2022 | ✅ |
| Volmageddon / Q4 storto | 2018 | ✅ |
| svalutazione yuan | 2015 | ✅ |

BCM sugli indici parte dal **26/09/2024**: 21 mesi e **un solo regime**.
Dukascopy ne offre **quattordici anni**. Sul DAX e sul Nasdaq — due dei
nostri tre cavalli — **la prova di regime e' sbloccata.**

## 2. 🔴 IL DOW NON RISPONDE

`USA30IDXUSD` **non ha risposto** su nessuno dei quattro giorni feriali
sondati di giugno 2025. Non e' un dettaglio: il Dow e' il simbolo dell'**ORB**
e dell'**Apertura US**, cioe' due sedie del portafoglio.

**[INFERITO, non ancora verificato]** che Dukascopy non lo offra affatto. Lo
schema di denominazione e' confermato da **sei** simboli che funzionano
(`<AREA>IDX<VALUTA>`), quindi il nome "giusto" per analogia sarebbe proprio
`USA30IDXUSD`. Ma prima di scrivere "non c'e'" si provano le altre grafie:
la sonda adesso testa anche `US30IDXUSD`, `USA30USD`, `DJIIDXUSD`,
`WS30IDXUSD`, piu' `USA2000IDXUSD` come **controllo di schema**.

## 3. 🐛 Difetto della sonda, trovato leggendo il suo stesso referto

`USA30IDXUSD` e `GERIDXEUR` **non compaiono da nessuna parte** nel CSV e nel
TXT. Non "compaiono come assenti": **non compaiono**. Erano stati chiesti e
avevano fallito la fase 1, ma nel file sembrava che non fossero mai stati
interrogati.

E' lo stesso identico errore del ricognitore MT5, in un altro vestito:
**un'assenza silenziosa si legge come una domanda mai fatta.** Corretto: la
fase 1 finisce nel referto con la sua colonna `Fase`.

Aggiunta anche una **fase 3 "stringo"**: fra l'ultimo anno senza dati e il
primo con dati si dimezza finche' non resta un anno solo, cosi' la prima data
e' **un numero e non un intervallo** (oggi sappiamo "fra 2010 e 2012", non
"2012").

## 4. ⚖️ Dukascopy e Pepperstone non sono alternative: sono COMPLEMENTARI

| | Pepperstone | Dukascopy |
|---|---|---|
| DAX | `GER40` ✅ | `DEUIDXEUR` ✅ **dal 2012** |
| Nasdaq | `NAS100` ✅ | `USATECHIDXUSD` ✅ **dal 2012** |
| S&P | `US500` ✅ | `USA500IDXUSD` ✅ **dal 2012** |
| Nikkei | `JPN225` ✅ | `JPNIDXJPY` ✅ dal 2015 |
| **Dow** | **`US30` ✅** | **non risponde** ❌ |
| prima data | **ignota** (da misurare) | **misurata** |
| come si prende | terminale MT5 | download web |

**Il Dow ce l'ha solo Pepperstone. Gli anni profondi li ha solo Dukascopy
(per ora).** Quindi le due misure che restano da fare servono **entrambe**.

## 5. 💰 Il costo vero della strada Dukascopy

I `.bi5` sono **compressi LZMA** con un layout binario, e **PowerShell 5.1
non sa decomprimere LZMA da solo**. Servirebbe un pezzo di software che non
abbiamo. Le vie possibili:

1. **Il tool web ufficiale "Historical Data Feed"** di Dukascopy esporta
   **CSV** direttamente dal browser. Zero codice: il nostro
   `ABTG_ImportaStoricoEsterno` legge gia' quel formato (`-Formato 1`,
   `YYYY.MM.DD HH:MM,O,H,L,C,V`). Limite: si scarica a pezzi, a mano.
2. **TickStory** — gia' citato in `docs/Portafoglio_Strategie.md` e nella
   guida Tickmill. Fa il lavoro sporco e sputa CSV o li inietta in MT5.
3. Un decompressore nostro (7-Zip da riga di comando, o Node). **Da valutare
   solo se le prime due non bastano**: e' l'unica delle tre che richiede
   codice nuovo, e il codice nuovo va poi verificato.

> ⚠️ **Vale comunque la regola congelata**: qualunque feed importato serve
> come **PROVA DI REGIME, non per tarare**. E spread e commissioni restano
> quelli del tester, non quelli storici — con R55 che ha misurato **1,5 punti
> indice** come soglia che sfonda il cancello del 10% sull'ORB.

## 6. ▶️ I due passi, tutti e due necessari

1. **Sonda Dukascopy, secondo giro**: le cinque grafie del Dow + la fase
   "stringo" per inchiodare il primo anno di DAX/Nasdaq/S&P.
2. **Prima data degli indici su Pepperstone** (download del solo D1): il Dow
   li' c'e', e resta l'unica fonte per `US30`.

**Nessun parametro degli EA in forward cambia per questi numeri.**


---
---

# 🎉 SECONDO GIRO — 15/08/2026 ore 16:25 — **IL DOW C'E'**

_Dati grezzi: `backtest_pipeline/risultati_prove/dukascopy_sonda/giro2/`_

## 7. La riga che cambia il quadro

```
USA30IDXUSD   Dow Jones 30   OK  (49445 byte)
https://datafeed.dukascopy.com/datafeed/USA30IDXUSD/2025/05/16/15h_ticks.bi5
```

**[VERIFICATO] `USA30IDXUSD` esiste**, con **49.445 byte** di tick veri per il
16 giugno 2025 alle 15 UTC.

**Il "non risponde" del primo giro era un falso negativo.** E non e' un caso
che non ce ne fossimo accorti: al primo giro quel simbolo **non finiva nel
referto**, quindi non si poteva nemmeno distinguere un 404 da un errore di
rete. La correzione fatta stamattina — far finire nel referto anche i falliti —
**ha pagato al primo utilizzo**: stavolta i quattordici fallimenti sono tutti
scritti, con il loro codice.

## 8. 🔴 Ma la corsa e' da buttare, e lo dice lo script

```
controllo positivo EURUSD: FALLITO - la corsa non vale
```

Subito dopo il primo successo, Dukascopy ha risposto **`503 Server non
disponibile`** a **tutto**: quattordici simboli su quindici, controllo positivo
compreso. La corsa e' durata **55 secondi** (16:24:39 → 16:25:34).

**Il 503 non e' un "non c'e'": e' un "adesso no".** Un 404 dice che il file non
esiste; un 503 dice che il server sta rifiutando. E' quasi certamente **rate
limiting**: il primo giro aveva fatto qualche centinaio di richieste, il
secondo ne ha aperte altrettante a raffica.

> 🎯 **La regola del controllo positivo ha fatto esattamente il suo mestiere.**
> Senza EURUSD in fondo alla lista, questo referto sarebbe stato letto come
> _"Dukascopy non ha piu' nessun indice"_ — un ribaltamento clamoroso e
> completamente falso.

## 9. 🐛 Due difetti miei, esposti da questa corsa

**1. Nessuna gestione dei codici temporanei.** Un 503 finiva a referto come un
errore secco, senza un solo tentativo in piu'. **Corretto**: su
`429 / 500 / 502 / 503 / 504` e sui guasti di rete si **ritenta con attesa
crescente — 2, 5, 15, 30 secondi** — e solo dopo si dichiara errore. Il 404
resta immediato, perche' quello e' una risposta vera.
Aggiunta anche una **pausa di 250 ms** fra le richieste (`-PausaMs`).

**2. Lo script ha continuato dopo il fallimento del controllo.** Ha stampato
l'avviso... e poi ha fatto tutta la fase 2 su USA30IDXUSD, nove anni di
richieste, tutte in errore. **Corretto**: il controllo positivo adesso e' la
**fase 0**, va per primo, e se fallisce **ci si ferma** (si forza solo con
`-ProsegiuComunque`, esplicito).

> Se il metro non funziona, non si misura niente. Sembra ovvio scritto qui;
> nel codice non lo era.

## 10. 📊 Dove siamo adesso

| indice | Dukascopy | prima data |
|---|---|---|
| DAX (`DEUIDXEUR`) | ✅ | **2012** |
| Nasdaq (`USATECHIDXUSD`) | ✅ | **2012** |
| S&P (`USA500IDXUSD`) | ✅ | **2012** |
| FTSE · CAC · Stoxx | ✅ | **2012** |
| Nikkei (`JPNIDXJPY`) | ✅ | **2015** |
| **Dow (`USA30IDXUSD`)** | ✅ **c'e'** | **da misurare** |

**Manca solo la prima data del Dow.** Se anche lui parte dal 2012, Dukascopy
copre **l'intero portafoglio indici** con Covid e orso 2022 dentro — e diventa
la strada principale, non la riserva.

**Nessun parametro degli EA in forward cambia per questi numeri.**


---
---

# 🏆 TERZO GIRO — 15/08/2026 ore 16:45 — **LA MISURA E' CHIUSA**

_Dati grezzi: `backtest_pipeline/risultati_prove/dukascopy_sonda/giro3/`_

## 11. ✅ Controllo positivo: `EURUSD OK, 24.043 byte`. La corsa vale.

## 12. 🎯 GLI OTTO INDICI, CON IL PRIMO ANNO INCHIODATO

| simbolo Dukascopy | che cos'e' | byte (giu 2025) | **primo anno** |
|---|---|---:|---|
| **`USA30IDXUSD`** | **Dow Jones 30** | 49.445 | **2012** |
| **`USATECHIDXUSD`** | **Nasdaq 100** | 95.995 | **2012** |
| **`USA500IDXUSD`** | **S&P 500** | 29.018 | **2012** |
| **`DEUIDXEUR`** | **DAX 40** | 17.875 | **2012** |
| `GBRIDXGBP` | FTSE 100 | 17.583 | **2012** |
| `FRAIDXEUR` | CAC 40 | 10.011 | **2012** |
| `EUSIDXEUR` | Euro Stoxx 50 | 1.814 | **2012** |
| **`JPNIDXJPY`** | **Nikkei 225** | 8.722 | **2013** |

**La fase "stringo" ha fatto il suo lavoro:** il 2011 e' stato sondato e non
risponde, il 2012 si'. Non e' piu' "fra 2010 e 2012": e' **2012**. Sul Nikkei
ha inchiodato **2013** (2012 negativo).

## 13. 🔎 E i nomi sono decisi, non intuiti

| tentativo | esito |
|---|---|
| `US30IDXUSD` · `USA30USD` · `WS30IDXUSD` | **ASSENTE** (404 veri) |
| `GERIDXEUR` | **ASSENTE** |

Quindi **`USA30IDXUSD` e' IL nome del Dow** e **`DEUIDXEUR` e' IL nome del
DAX**, non due candidati fra tanti. Il falso negativo del primo giro e'
spiegato e chiuso.

⚠️ **Due caselle restano non decise, e lo dico**: `DJIIDXUSD` ha dato
`ERRORE 0` (rete) e `USA2000IDXUSD` un `503`. Sono una grafia alternativa e
il controllo di schema: **non ci servono**, ma **non sono state misurate** e
non vanno contate come assenze.

## 14. 📅 CHE COSA ABBIAMO IN MANO ADESSO

**Otto indici × quattordici anni (2012→2026).** Contro i **21 mesi e un solo
regime** di BCM.

| regime | anno | coperto |
|---|---|---|
| **crollo Covid** | 2020 | ✅ |
| **orso + inflazione** | 2022 | ✅ |
| Volmageddon / Q4 storto | 2018 | ✅ |
| svalutazione yuan | 2015 | ✅ |
| taper tantrum / Cina | 2013-2016 | ✅ |
| **crisi 2008** | 2008 | ❌ **non c'e'**, e non ci sara' |

> 🎯 **La FASE 1 del piano di ri-test e' sbloccata sugli indici**, cioe' dove
> stanno le sedie grosse: Apertura EU, Apertura US, ORB, EMA200, SuperWave.

## 15. ▶️ L'unico ostacolo rimasto: portarli dentro

I `.bi5` sono **LZMA**, e PowerShell 5.1 non lo decomprime. Le tre vie, in
ordine di costo:

| via | codice nuovo | note |
|---|---|---|
| 🥇 **Tool web ufficiale** Dukascopy | **zero** | esporta CSV; `ABTG_ImportaStoricoEsterno` lo legge gia' (`-Formato 1`). Si scarica a pezzi, a mano |
| 🥈 **TickStory** | zero | gia' citato in due nostri documenti; fa il lavoro e sputa CSV |
| 🥉 decompressore nostro | **si'** | l'unica che aggiunge codice da verificare |

**Nel frattempo il forex non aspetta**: HistData e' gia' validato (EURUSD/
GBPUSD 2018-2024, copertura 99,6%, differenza 0,004%) e l'import degli altri
simboli si puo' lanciare subito.

**Nessun parametro degli EA in forward cambia per questi numeri.**
