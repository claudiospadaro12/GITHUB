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
