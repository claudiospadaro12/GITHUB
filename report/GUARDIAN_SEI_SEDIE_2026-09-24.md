# 🛡️ IL GUARDIAN SULLE SEI SEDIE FTMO — censimento di SOLA LETTURA, sedia per sedia

**24/09/2026** · branch `lavoro` · conto **FTMO `541452707`** (80.000 EUR, 2-Step) · terminale **`C:\FTMO`**
🛑 **NIENTE È STATO TOCCATO.** Nessun EA ricompilato, nessun preset modificato, nessun terminale
aperto o chiuso, nessuna sedia staccata, nessuna riga mandata al VPS, nessun round lanciato.
Questo referto è **lettura di file già presenti nel repo**.
✋ Conto reale **10105439**: non compare in nessun comando. Taglie e parametri di rischio sono
firma di Claudio e **non vengono proposti qui**.

---

# 0️⃣ 🥇 LA RISPOSTA, IN CINQUE RIGHE

> ## 🟢 **SEI SEDIE SU SEI LEGGONO IL GUARDIAN. ZERO FAIL-OPEN. IL DIFETTO DEL 12/09 NON SI RIPETE.**
> ## 🟢 **E NON È UN'INFERENZA SUI SORGENTI: È MISURATO SUL BINARIO IN CAMPO.**

1. ✅ **A HEAD**: tutti e sei i sorgenti hanno `InpUsaGuardian` (default `true`) e chiamano
   `ABTG_GuardiaIngresso`. **42 invii d'ordine su 42** stanno **a valle** di una guardia, nella
   **stessa funzione**. Zero scoperti (§2, verificato a macchina oggi).
2. ✅ **IN CAMPO**: i `.chr` di `C:\FTMO` letti dal runner **stanotte alle 03:31:45** portano
   `InpUsaGuardian=true` su **tutte e sei** le sedie `CLAU12_*`. Un input che il binario non ha
   **non finisce nel `.chr`** — è esattamente il test che il 12/09 ha smascherato `EMA200`.
3. ✅ **E i binari ESISTONO e sono del giorno giusto**: `.ex5` datati **2026-09-20 16:58** per
   tutti e sette (sei sedie + Guardian). 🔴 Non agosto. Il precedente non si ripete (§3).
4. ✅ **Il Guardian gira**: `CLAU12_Guardian` magic `779001`, v1.12, con
   **pausa B1 a 3,50%**, **emergenza + FlattenAll a 4,50%**, **cap C1 a 4,00%**, ancora **80.000**,
   reset **ora 1 server** (§4). L'ultima riga di giornale è delle **03:30 di stanotte**.
5. 🔴 **E le tre crepe vere, che NON sono fail-open ma vanno scritte**: (a) il Guardian in campo è
   **v1.12** e **non ha l'input `InpDailyBaseline`**, quindi misura la giornata dall'**equità** e
   non dal **saldo** come fa FTMO — ed è **più permissivo della prop**, non meno (§4.3);
   (b) il preset `770511` **non contiene la riga `InpUsaGuardian`** e si regge sul default del
   sorgente (§5.1); (c) **nessuna delle sei passa `cluster_mappa`**, quindi il **C2 resta muto**
   — già noto e già dichiarato non urgente in `CLAUDE.md` (§5.3).

### 🎯 Che cosa vuol dire per il numero che conta
`report/IL_PIANO_DEGLI_OTTO_GIORNI_2026-09-23.md` **r.236-244** (aperto oggi) dà il Guardian a
**+13,7 punti** (70,3% → 84,0%) e gli attribuisce l'annullamento della modalità di morte
principale (muro giornaliero, **18,2%** dei casi → **0,0%**). Lo stesso file, **r.244**, lo
marcava `[NON VERIFICATO]`.
🟢 **La misura M1 si chiude QUI, dal repo, senza mandare niente al VPS**: il runner notturno
l'aveva già raccolta. **Siamo nel ramo 84,0%**, con i caveat del §6.

---

# 1️⃣ 📋 L'ELENCO VERO DELLE SEI SEDIE — e i due elenchi che NON coincidono

## 1.1 Le sei, per nome (tre fonti d'accordo)

| # | EA (repo) | EA in campo | magic | simbolo BCM → **FTMO** | TF |
|---|---|---|---|---|---|
| 1 | `ABTG_DAX_Apertura_EU` | `CLAU12_DAX_Apertura_EU` | **770101** | D30EUR → **GER40.cash** | M5 |
| 2 | `ABTG_Dow_Apertura_US` | `CLAU12_Dow_Apertura_US` | **770202** | U30USD → **US30.cash** | M5 |
| 3 | `ABTG_Nasdaq_Apertura_US` | `CLAU12_Nasdaq_Apertura_US` | **770260** | NASUSD → **US100.cash** | M5 |
| 4 | `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` | `CLAU12_MaxMinNotte_DAX_Short_Ottimizzato` | **770411** | D30EUR → **GER40.cash** | M15 |
| 5 | `ABTG_SuperWave_DOW_H1_Ottimizzato` | `CLAU12_SuperWave_DOW_H1_Ottimizzato` | **770511** | U30USD → **US30.cash** | H1 |
| 6 | `ABTG_EMA200` | `CLAU12_EMA200` | **771531** | U30USD → **US30.cash** | H1 |
| + | `ABTG_Guardian` | `CLAU12_Guardian` | **779001** | NZDJPY H1 *(non trada)* | — |

Fonti aperte **oggi**, e concordano tutte e tre:
`report/IL_DD_DELLE_SEI_SEDIE_2026-09-24.md` §2 · `report/IL_NUMERO_VERO_DELLE_SEDIE_2026-09-21.md` §6 ·
e **la fonte che conta**, `backtest_pipeline/coda/referti/CODA_08_preset_dai_chr_20260924_033003.log`,
blocchi `--- SEDIA:` sotto l'intestazione `=== C:\FTMO` (r.3047), **in ordine di grafico**:
`chart01` DAX **r.3054** · `chart02` Dow **r.3143** · `chart03` Nasdaq **r.3231** ·
`chart04` EMA200 **r.3336** · `chart05` SuperWave **r.3386** · `chart06` **Guardian r.3437** ·
`chart07` TradeExporter r.3460 · `chart08` MaxMin **r.3471**.

## 1.2 🟠 I DUE ELENCHI CHE NON COINCIDONO — e va detto, perché è un risultato

| dove | quante sedie | commento |
|---|---:|---|
| `mql5/Presets/FTMO/` (cartella in repo) | **12 file `.set`** | 6 della rosa + `770402` MaxMin ORO + 3 PostNews (`771202/771203/771204`) + `SpreadLogger` + `TradeExporter` |
| `C:\FTMO` in campo (`CODA_06` di stanotte, r.209-215) | **6 sedie + Guardian** | niente ORO, niente PostNews |

🟢 **Non è un buco: è una scelta dichiarata.** `backtest_pipeline/righe/SCHIERA_FTMO.ps1`
**r.221-222** scrive testualmente che `ABTG_MaxMinNotte.mq5` (la `770402`) **non viene copiata**
— «BERSAGLIO NON DECISO» — e che il suo preset **non va installato** perché *«un preset senza il
suo EA è una trappola»*. ✅ **In campo infatti non c'è.** Coerente.
🔴 **Ma la trappola esiste lo stesso nel REPO**: chi apre `mql5/Presets/FTMO/` oggi conta **12**
sedie e ne trova **6**. Nessun file di quella cartella dice quali sono le sei.

---

# 2️⃣ 🔬 IL SORGENTE A HEAD — riga per riga, **ricontata oggi** (classe 731)

🔴 **I numeri di riga qui sotto sono contati da me stamattina sui file a HEAD** (`grep -n`,
`grep -c ""`), **non copiati** da `PACCHETTO_SCHIERAMENTO_PROP_2026-09-21.md` né da nessun altro
referto. E infatti **NON coincidono** con quelli scritti là: HEAD si è mosso dopo il 20/09 (§3.2).

| # | EA a HEAD | righe (`grep -c ""`) | `InpUsaGuardian` | `ABTG_GuardiaIngresso` | blocca o logga? | `cluster_mappa` |
|---|---|---:|---|---|---|---|
| 1 | `ABTG_DAX_Apertura_EU.mq5` | **2885** | ✅ **r.144** | ✅ **7 volte**: r.1194 · 1283 · 1448 · 1558 · 1955 · 1996 · 2043 | 🟢 **BLOCCA** (11/11 ordini coperti) | ❌ no |
| 2 | `ABTG_Dow_Apertura_US.mq5` | **2205** | ✅ **r.113** | ✅ **7 volte**: r.893 · 982 · 1147 · 1257 · 1334 · 1367 · 1414 | 🟢 **BLOCCA** (11/11) | ❌ no |
| 3 | `ABTG_Nasdaq_Apertura_US.mq5` | **2644** | ✅ **r.92** | ✅ **8 volte**: r.992 · 1086 · 1254 · 1368 · 1482 · 1564 · 1598 · 1647 | 🟢 **BLOCCA** (12/12) | ❌ no |
| 4 | `ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5` | **619** | ✅ **r.42** | ✅ **1 volta**: r.245 | 🟢 **BLOCCA** (2/2) | ❌ no |
| 5 | `ABTG_SuperWave_DOW_H1_Ottimizzato.mq5` | **774** | ✅ **r.45** | ✅ **1 volta**: r.395 | 🟢 **BLOCCA** (4/4) | ❌ no |
| 6 | `ABTG_EMA200.mq5` | **690** | ✅ **r.42** | ✅ **1 volta**: r.381 | 🟢 **BLOCCA** (2/2) | ❌ no |

Tutti e sei fanno `#include <ABTG_PausaGuardian.mqh>` (DAX r.132 · Dow r.101 · Nasdaq r.80 ·
MaxMin r.30 · SuperWave r.33 · EMA200 r.30).

## 2.1 🧪 «BLOCCA DAVVERO O È UN LOG?» — il controllo, non l'opinione

Ho elencato **ogni** invio d'ordine d'apertura (`gTrade.Buy/Sell/BuyStop/SellStop/BuyLimit/SellLimit`)
e, per ognuno, ho chiesto: **esiste una guardia PRIMA, DENTRO LA STESSA FUNZIONE?**

| EA | ordini d'apertura | scoperti | distanza guardia→ordine |
|---|---:|---:|---|
| DAX Apertura | 11 | 🟢 **0** | 1-41 righe, in `TryPlaceBreakout` · `TryPlaceRangeFade` · `TryPlaceDelayed` · `MonitorOpenConfirm` · `MonitorRetest` · `TryPlaceGapFill` |
| Dow Apertura | 11 | 🟢 **0** | idem, stesse sei funzioni |
| Nasdaq Apertura | 12 | 🟢 **0** | idem + `MonitorBreakoutStrength` (r.1482 → ordine r.1484) |
| MaxMin DAX Short | 2 | 🟢 **0** | `TryPlace`, r.245 → 254/266 |
| SuperWave DOW | 4 | 🟢 **0** | `Enter`, r.395 → 396/397 (mercato) e 411/412 (pendenti 2/3) |
| EMA200 | 2 | 🟢 **0** | `PlaceLimit`, r.381 → 382/383 |
| **TOTALE** | **42** | 🟢 **0** | — |

🟢 **E la forma è quella che blocca, non quella che logga**: in tutti i casi la riga è
`if(!ABTG_GuardiaIngresso(...)) return;` / `return(false);` — il ritorno **precede** l'invio.
Due sedie incrementano pure un contatore d'imbuto (`cO_guardian++`: EMA200 r.381, SuperWave r.395),
così il rifiuto si conta.

## 2.2 🧪 IL CONTRO-ESEMPIO CHE HO COSTRUITO CONTRO ME STESSO

*«E se il mio riconoscitore di funzioni sbagliasse, appaiando un ordine a una guardia che sta in
un'ALTRA funzione? Uscirebbe "0 scoperti" anche su un EA bucato.»*
👉 Per questo **non mi sono fermato al conteggio**: ho stampato, per ogni ordine, la **terna
`ordine / guardia / inizio funzione`** e l'ho letta. In tutte e 42 le righe vale
`inizio funzione < guardia < ordine`, con distanze **1-43 righe** e il nome della funzione che
torna (`TryPlaceBreakout`, `Enter`, `PlaceLimit`…). Una guardia "rubata" a un'altra funzione
avrebbe prodotto una distanza di **centinaia** di righe e un nome incoerente. **Non succede.**
🔎 Ho anche riletto **a occhio** i tre casi a distanza minima (EMA200 r.381→382, SuperWave
r.395→396, MaxMin r.245→254): la guardia è l'ultima istruzione prima di `gTrade`.

## 2.3 🔒 E il meccanismo di fondo, letto nell'include (`mql5/Include/ABTG_PausaGuardian.mqh`, HEAD, **2461 righe**)

`ABTG_GuardiaIngresso` è dichiarata a **r.1587**. La catena di uscita, nell'ordine:
`r.1600 if(!attiva) return(true)` → S1 → P1 → P0 → C2 → **`r.1719 if(!ABTG_CanaleEsiste()) return(true)`**
→ `ABTG_MotivoStop_Calc` (B1/C1) → riga `INGRESSO BLOCCATO` r.1745 → **`r.1751 return(false)`**.

> ## 🔴 **IL FAIL-OPEN STRUTTURALE, ed è per disegno: `if(!ABTG_CanaleEsiste()) return(true)`.**
> Se sul conto **non c'è un Guardian che scrive le GlobalVariable**, tutte e sei passano.
> 👉 Ecco perché *«il Guardian gira?»* vale quanto *«l'EA lo legge?»*: **sono la stessa domanda**.
> ✅ E la risposta oggi è **sì a tutte e due** (§4).

⚠️ **Nessuna delle sei passa `pretendi_guardian`** (tutte chiamano con **due soli argomenti**):
quindi se il Guardian **smettesse di battere**, le sedie **continuerebbero a operare** invece di
fermarsi. È il default dichiarato nell'include (r.1588), **non un difetto nascosto** — ma è una
**scelta**, e su un conto prop andrebbe rifatta con una firma, non ereditata.

---

# 3️⃣ 🖥️ IL BINARIO IN CAMPO — **NOTO**, e per la prima volta non è un'inferenza

## 3.1 Da dove viene il numero
Tre referti di **sola lettura** che il runner notturno ha scritto **da solo** sul VPS e che sono
**già in repo** (nessuna riga nuova, nessuna CPU, nessun terminale toccato):

- `backtest_pipeline/coda/referti/CODA_06_quale_codice_gira_20260924_033003.log` — **lettura 2026-09-24 03:30:45**
- `backtest_pipeline/coda/referti/CODA_08_preset_dai_chr_20260924_033003.log` — **lettura 2026-09-24 03:31:45**
- `backtest_pipeline/coda/referti/CODA_09_giornale_operativo_20260924_033003.log`

Cartella dati riconosciuta **per nome**: `=== C:\FTMO` → hash **`46C9F8E9FF0C747B2B5E09BCC13D5237`**,
profilo attivo `Default`, **9 file `.chr`** (`CODA_08` r.3047-3052). 🟢 **È l'hash atteso**
dichiarato in `report/BINARI_IN_CAMPO_FTMO_2026-09-21.md` §②.5.

## 3.2 🔴 PRIMA DI TUTTO: **HEAD NON È QUELLO CHE VOLA**, e i numeri del §2 da soli non bastano

`SCHIERA_FTMO.ps1` **r.176-186** inchioda ogni file a un **commit suo** (non HEAD) e **rifiuta di
scrivere** se l'impronta non torna (r.562-563: *«Non e stato scritto niente sul terminale»*).

| file | **pin** | righe attese | righe a **HEAD** oggi | scarto |
|---|---|---:|---:|---|
| `ABTG_DAX_Apertura_EU.mq5` | `9fca63d9` | 2425 | **2885** | 🔴 **+460** |
| `ABTG_Dow_Apertura_US.mq5` | `9fca63d9` | 2205 | 2205 | 🟢 0 |
| `ABTG_Nasdaq_Apertura_US.mq5` | `9fca63d9` | 2624 | **2644** | 🟠 +20 |
| `ABTG_MaxMinNotte_DAX_Short_Ott.mq5` | `5fc0bc31` | 619 | 619 | 🟢 0 |
| `ABTG_SuperWave_DOW_H1_Ott.mq5` | `872dba82` | 645 | **774** | 🔴 **+129** |
| `ABTG_EMA200.mq5` | `26a18566` | 552 | **690** | 🔴 **+138** |
| `ABTG_Guardian.mq5` | `d884f7e1` (**v1.12**) | 498 | **899** (v1.14) | 🔴 **+401** |
| `ABTG_PausaGuardian.mqh` | `26a18566` (**v1.20**) | 398 | **2461** (v1.6x) | 🔴 **+2063** |

👉 **Quindi il §2 l'ho RIFATTO sui file al loro pin.** Estratti con `git show`, non da HEAD:

| EA @pin | righe | `InpUsaGuardian` | guardie | ordini | **scoperti** |
|---|---:|---|---|---:|---:|
| DAX `@9fca63d9` | 2425 | ✅ r.144 | 7: r.1056 · 1145 · 1310 · 1420 · 1503 · 1536 · 1583 | 11 | 🟢 **0** |
| Dow `@9fca63d9` | 2205 | ✅ r.113 | 7: r.893 · 982 · 1147 · 1257 · 1334 · 1367 · 1414 | 11 | 🟢 **0** |
| Nasdaq `@9fca63d9` | 2624 | ✅ r.92 | 8: r.992 · 1086 · 1254 · 1368 · 1482 · 1564 · 1598 · 1647 | 12 | 🟢 **0** |
| EMA200 `@26a18566` | 552 | ✅ r.42 | 1: r.243 | 2 | 🟢 **0** |
| SuperWave `@872dba82` | 645 | ✅ r.45 | 1: r.267 | 4 | 🟢 **0** |
| MaxMin `@5fc0bc31` | 619 | ✅ r.42 | 1: r.245 | 2 | 🟢 **0** |

🟢 **E l'include al pin (v1.20, 398 righe, blob `cc90fb73`) ha B1 e C1 e li fa BLOCCARE**:
`ABTG_GuardiaIngresso` a **r.282**, `if(!attiva) return(true)` **r.285**,
`if(!ABTG_CanaleEsiste()) return(true)` **r.286**, poi `ABTG_MotivoStop_Calc` e **`return(false)` r.318**.
Non ha P0/P1/S1/C2 — **e non servono**: le sei chiamano con due argomenti.

### 🧾 La prova d'identità: ho **rifatto io** le impronte del deploy
Ho riprodotto in Python la funzione `Scheletro()` di `SCHIERA_FTMO.ps1` (r.259-272: CRLF→LF,
via i byte non-ASCII, `TrimEnd`, SHA256) e l'ho applicata agli **8 file ai loro pin**:

> ## ✅ **8 impronte su 8 COMBACIANO** con quelle scritte nello script (r.176-186), righe comprese.
> Es. `ABTG_EMA200.mq5@26a18566` → 552 righe, `5CA99D90A5F34E9630083C91E16A5E7F2DA48FC77EF63B138C5C2C3485BE85F4` ✅ ·
> `ABTG_PausaGuardian.mqh@26a18566` → 398 righe, `D179846B407FDACC963825103F850E8F8BEE39B1DA3521A504EF74F8638AC8BC` ✅

👉 **I file che ho appena auditato sono, byte per byte, quelli che lo script avrebbe scritto su
`C:\FTMO` — e se non fossero stati quelli, lo script non avrebbe scritto niente.**

## 3.3 ✅ E LA CONFERMA DAL CAMPO — `CODA_06`, r.209-215

```
NOME                                          VER     RIGHE  GUARD  COMPILATO IL
CLAU12_DAX_Apertura_EU.mq5                    1.01     2426   SI    2026-09-20 16:58
CLAU12_Dow_Apertura_US.mq5                    1.01     2206   SI    2026-09-20 16:58
CLAU12_EMA200.mq5                             1.00      553   SI    2026-09-20 16:58
CLAU12_Guardian.mq5                           1.12      499   no    2026-09-20 16:58
CLAU12_MaxMinNotte_DAX_Short_Ottimizzato.mq5  1.10      620   SI    2026-09-20 16:58
CLAU12_Nasdaq_Apertura_US.mq5                 1.02     2625   SI    2026-09-20 16:58
CLAU12_SuperWave_DOW_H1_Ottimizzato.mq5       1.01      646   SI    2026-09-20 16:58
```

Tre cose, e sono tutte misurate:
1. 📏 **Le righe combaciano coi pin, una per una.** `CODA_06` conta **uno in più** di `wc -l`
   (classe 456, dichiarata nel suo stesso script r.114): 2426→**2425**, 2206→**2205**,
   553→**552**, 499→**498**, 620→**619**, 2625→**2624**, 646→**645**. 🟢 **7 su 7.**
2. 🛡️ **Colonna `GUARD` = `SI`** su tutte e sei. Il significato è nel sorgente dello strumento
   (`backtest_pipeline/righe/CODA_06_quale_codice_gira.ps1` **r.88-89**): `SI` se il `.mq5`
   contiene `GuardiaIngresso` **o** `InpUsaGuardian`. Il `no` su `CLAU12_Guardian` è corretto:
   **il Guardian non legge sé stesso**.
3. 📅 **`COMPILATO IL` = data dell'`.ex5` accanto** (stesso script r.90-94). **2026-09-20 16:58**
   per tutti e sette → **l'`.ex5` ESISTE e non è di agosto**.
   🔎 *E il controllo negativo che rende credibile la colonna*: nella stessa tabella i sette
   `ABTG_*.mq5` rimasti sul terminale (le copie pre-rinomina) stampano **`(nessun .ex5)`**. Lo
   strumento **sa** dire quando il binario manca. Qui non manca.

## 3.4 🥇 LA PROVA CHE CHIUDE IL CERCHIO — l'input list letta dal `.chr` del binario vivo

Un `.chr` conserva il blocco `<inputs>` **che MT5 scrive dall'`.ex5` attaccato**. Un binario
vecchio, senza `InpUsaGuardian`, **non può** farlo comparire — è esattamente così che il 12/09
`ABTG_EMA200` fu smascherato (42 input su 44).

Ho diffato, **nome per nome**, l'elenco degli input del `.chr` (`CODA_08` di stanotte) contro
l'elenco degli `input` del **sorgente al pin**:

| sedia in campo | input nel `.chr` | input nel sorgente @pin | solo sorgente | solo `.chr` | **`InpUsaGuardian` nel `.chr`** |
|---|---:|---:|---:|---:|---|
| `CLAU12_DAX_Apertura_EU` | **82** | 82 `@9fca63d9` | 0 | 0 | 🟢 **`true`** (r.3059) |
| `CLAU12_Dow_Apertura_US` | **81** | 81 `@9fca63d9` | 0 | 0 | 🟢 **`true`** (r.3148) |
| `CLAU12_Nasdaq_Apertura_US` | **98** | 98 `@9fca63d9` | 0 | 0 | 🟢 **`true`** (r.3236) |
| `CLAU12_EMA200` | **43** | 43 `@26a18566` | 0 | 0 | 🟢 **`true`** (r.3341) |
| `CLAU12_SuperWave_DOW_H1_Ott` | **44** | 44 `@872dba82` | 0 | 0 | 🟢 **`true`** (r.3391) |
| `CLAU12_MaxMinNotte_DAX_Short_Ott` | **52** | 52 `@5fc0bc31` | 0 | 0 | 🟢 **`true`** (r.3476) |
| `CLAU12_Guardian` | **16** | 16 `@d884f7e1` (**v1.12**) | 0 | 0 | — *(non lo ha, ed è giusto)* |

> ## 🟢 **7 SU 7, ZERO DIFFERENZE, SU 416 NOMI DI INPUT COMPLESSIVI.**
> Il binario che sta operando **espone esattamente** l'interfaccia del sorgente al pin.
> E i sei `.chr` sono datati **2026-09-20 18:29**: la foto del momento in cui le sedie sono state
> attaccate. **Da allora nessuno le ha staccate o riattaccate** (nessun `.chr` più recente).

🧪 **Il contro-esempio, perché la conclusione non sia più forte del dato**: *«un `.ex5` compilato
da un sorgente DIVERSO ma con gli STESSI input darebbe la stessa foto.»* **Vero.** Il `.chr`
certifica l'**interfaccia**, non il **corpo**. 👉 Quello che chiude il corpo è l'altra metà:
`.mq5` sul terminale con **le righe del pin** (§3.3.1) e `.ex5` **compilato dopo** (16:58) e
**prima** dell'attacco (18:29). Le tre misure sono indipendenti e puntano tutte allo stesso file.
🔴 Resta **non misurato** un solo anello: **dimensione in byte dell'`.ex5` e confronto data
`.ex5` vs data `.mq5`** (§7).

---

# 4️⃣ ⚖️ LA PAUSA B1 E IL CAP C1 — che cosa fanno DAVVERO, col numero

## 4.1 Il preset di casa (`mql5/Presets/ABTG_Guardian_FTMO_2Step.set`, letto oggi, 126 righe)

| chiave | valore | riga | che cosa fa |
|---|---:|---:|---|
| `InpStartBalance` | **80000** | r.74 | l'**ancora** di tutte le soglie |
| `InpDailyPausePct` | **3.5** | r.104 | 🛡️ **B1**: a −3,50% del giorno **blocca i NUOVI ingressi** (non chiude niente) |
| `InpDailyLossPct` | **4.5** | r.75 | 🚨 **emergenza giornaliera**: con `InpAction=0` → **`FlattenAll()`** e blocco per la giornata |
| `InpTotalDDPct` | **9.3** | r.76 | 🚨 DD totale, **`InpDDMode=0` = STATICO** dal saldo iniziale |
| `InpMaxOpenRiskPct` | **4.00** | r.124 | 🧱 **C1**: rischio aperto simultaneo massimo |
| `InpDailyResetHour` | **1** | r.96 | ora **server FTMO** = 00:00 CE(S)T |

**In euro, sull'ancora 80.000:** B1 **2.800 €** · emergenza **3.600 €** (muro FTMO 5% = 4.000 → cuscino **400 €**) ·
DD totale **7.440 €** (muro 10% = 8.000 → cuscino **560 €**).
> ## 🎯 **Il «4,5% tagliato» che il Monte Carlo modella è ESATTAMENTE `InpDailyLossPct=4.5` con `InpAction=0`.** La corrispondenza è 1:1.

## 4.2 ✅ E in campo è lo stesso — letto dal `.chr`, non dal preset

`CODA_08` r.3437-3458, `CLAU12_Guardian` su NZDJPY H1, magic **779001**:
```
InpStartBalance=80000     InpDailyLossPct=4.5      InpTotalDDPct=9.3     InpDDMode=0
InpDailyResetHour=1       InpDailyPausePct=3.5     InpMaxOpenRiskPct=4.00
InpRiskMode=0             InpWarnNoSL=true         InpAction=0           InpCloseAllMagics=true
```
🟢 **Tutte e 15 le chiavi del preset esistono nel sorgente al pin** (`ABTG_Guardian.mq5@d884f7e1`,
input a r.68-88): **nessuna chiave viene ignorata in silenzio**. È il controllo che il 12/09 era
fallito, e qui **passa**.

🟢 **E il Guardian sta scrivendo**, `CODA_09` r.98 e r.105:
```
24/09 03:30:04  CLAU12_Guardian (NZDJPY,H1)
[GUARDIAN] eq=78242.32  dayLoss=0.00%  totDD=2.20%  rischioAperto=0.00%  stato=OK  pausa=off  cap=off
```

### 🔬 Il meccanismo, verificato nel sorgente **al pin** (non a HEAD)
`ABTG_Guardian.mq5@d884f7e1`: `breachDaily` r.405 → `FlattenAll()` r.416 · rincaccio a ogni giro
r.425 · **B1** r.431-432 (`SetPausa` se `dailyPct>=InpDailyPausePct`) · r.435 (pausa anche a
lockdown scattato) · **C1** r.444-452 (timbra `ABTG_CAP_RISCHIO` finché il rischio è sopra) e
r.456-458 (lo azzera al rientro).
🟢 Il **filo** verso gli EA combacia: il Guardian scrive `ABTG_PAUSA_GIORNO_<conto>`,
`ABTG_PAUSA_FINO_…`, `ABTG_CAP_RISCHIO_…`, `ABTG_GUARDIAN_BATTITO_…` (r.277-281) e l'include
v1.20 legge **quegli stessi nomi** con lo stesso suffisso di conto (`ABTG_GVNome`, r.165-168).
**Protocollo compatibile, verificato riga per riga.**

## 4.3 🔴 LA CREPA VERA DEL §4: **il Guardian in campo misura la giornata dall'EQUITÀ, non dal SALDO**

Il binario vivo è **v1.12**. L'input `InpDailyBaseline` (0=equità · **1=SALDO, FTMO** · 2=max)
nasce in **v1.14** (`ABTG_Guardian.mq5` HEAD r.147) e **in campo NON ESISTE** — confermato dal
`.chr`: **16 input, non 19**.

Il commento del sorgente a HEAD (r.96-105) dice la direzione dell'errore, e non è a nostro favore:
> *«FTMO parte dal SALDO registrato alle 00:00 CE(S)T … Noi partiamo dall'EQUITÀ. Se al reset c'è
> una posizione aperta in perdita flottante … il nostro pavimento scende con lei mentre il loro
> resta fermo … siamo PIÙ PERMISSIVI della prop, cioè la challenge può essere già violata mentre
> il guardiano è ancora "in pausa morbida".»*

📏 **Quanto costa**: morde **solo** se una posizione è aperta **attraverso l'ora 1 server FTMO**.
Sedie esposte: `771531` EMA200 e `770511` SuperWave tengono overnight
*(fatto preso da `report/IL_NUMERO_VERO_DELLE_SEDIE_2026-09-21.md` §11 — **altro referto, marcato come tale**, non rimisurato oggi)*.
🔴 **E non si ripara con un preset**: l'input **non c'è nel binario**. Servirebbe un F7 del
Guardian a HEAD *più* la riga `InpDailyBaseline=1`. **È una decisione di Claudio** (§8).

---

# 5️⃣ 🟠 LE ALTRE CREPE — piccole, ma nessuna nascosta

## 5.1 Il preset `770511` **non contiene** `InpUsaGuardian`
`mql5/Presets/FTMO/ABTG_SuperWave_DOW_H1_770511_FTMO.set` — 106 righe, **zero occorrenze**.
Gli altri cinque ce l'hanno: `770101` r.211 · `770202` r.227 · `770260` r.114 · `770411` r.223 ·
`771531` r.108.
🟢 **Conseguenza pratica oggi: NESSUNA** — il default del sorgente è `true` (r.45) e il `.chr`
conferma `true` in campo (§3.4).
🔴 **Ma è una protezione appesa a un default**: il giorno in cui quel default cambiasse, cinque
sedie reggerebbero e una no, **in silenzio**.
📌 **E corregge un'affermazione in repo**: `report/BINARI_IN_CAMPO_FTMO_2026-09-21.md` §① scrive
*«Oggi tutti e sei i preset FTMO portano `InpUsaGuardian=true` (verificato)»*. **Sono cinque su sei.**

## 5.2 Due numeri stantii trovati strada facendo (non cambiano nessuna conclusione, ma vanno detti)
| dove | dice | misurato oggi |
|---|---|---|
| `report/LA_CHALLENGE_NON_STA_OPERANDO_2026-09-24.md` §1 | *«la soglia di pausa è **4,0%**»* | 🔴 **3,5%** (`.chr`, `CODA_08` **r.3447**; preset r.104). *(4,0 è il default di fabbrica e la firma del 18/08, superata dal cuscino del 20/09)* |
| `report/PACCHETTO_SCHIERAMENTO_PROP_2026-09-21.md` §④ passo 12 | *«il pannello … scrive `InpStartBalance=100000`, limite **4,9% / 9,9%**»* | 🔴 **80000**, **4,5% / 9,3%** |
| stesso file, §④ passo 7 | *«include v1.20 … **398 righe**»* | ✅ **giusto al pin** — ma l'include **a HEAD** ne fa **2461**: chi copiasse da HEAD vedrebbe fallire il controllo |

## 5.3 `cluster_mappa`: **zero su sei**
Nessuna delle sei passa `cluster_mappa` a `ABTG_GuardiaIngresso` (verificato a HEAD **e** ai pin).
🟢 Coerente con `CLAUDE.md`, che ha già misurato che **il C2 non serve adesso** (algebricamente
`rischio_cluster ≤ rischio_totale`, e il C1 a 4,00% morde prima). 🔴 Ma va ricordato che il
Guardian in campo (v1.12) **non ha nemmeno le manopole** `InpMaxClusterRiskPct` / `InpClusterMappa`:
non è «spento», è **assente**.

## 5.4 🟠 Nessuna sedia usa `pretendi_guardian` — **fail-open sul battito**
Già scritto al §2.3. Se il Guardian morisse (terminale riavviato, EA staccato), le sei
**continuerebbero a operare senza rete**, e nessuna riga nel giornale lo direbbe.
🔴 Sul conto **piccolo** questo fail-open è tollerabile. Su una **challenge pagata**, è una scelta
che merita una firma. **Non propongo di cambiarla adesso** (§8).

---

# 6️⃣ 🏁 IL VERDETTO, IN UNA FRASE

> # 🟢 **ZERO SEDIE SU SEI SONO FAIL-OPEN: tutte e sei leggono il Guardian, a HEAD e — cosa che conta di più — nel BINARIO CHE STA OPERANDO, e il Guardian è vivo, attaccato e con le soglie giuste (B1 3,5% · emergenza 4,5% · C1 4,00% · ancora 80.000).**

🎉 **La notizia grossa è questa, e va detta con la stessa forza con cui avremmo detto il contrario:
il disastro del 12/09 NON si è ripetuto.** Lo schieramento del 20/09 è stato fatto **bene**: pin
per file, impronta verificata **prima** di scrivere, F7 alle 16:58, attacco alle 18:29, e le
tracce che lo dimostrano erano già tutte in repo, raccolte da sole dal runner.
🟢 **`report/IL_PIANO_DEGLI_OTTO_GIORNI_2026-09-23.md` può togliere il `[NON VERIFICATO]` da M1**:
siamo nel ramo **84,0%**, non nel 70,3%.

🔴 **E le tre cose che non sono a posto, per non raccontarla meglio di com'è:**
**(1)** la baseline giornaliera è l'**equità** e non il **saldo** → **più permissivi di FTMO**
quando una posizione attraversa l'ora 1 (§4.3);
**(2)** nessuna sedia **pretende** il Guardian: se lui muore, loro vanno avanti (§5.4);
**(3)** il cap C1 in campo è **4,00%**, non il **3,25%** firmato il 18/08 — **già segnalato a
Claudio** in `report/RESOCONTO_2026-09-23.md` §1 e **ancora senza risposta**.

---

# 7️⃣ 🕳️ COSA MANCA PER CHIUDERLO — per nome, e con la misura esatta

| # | che cosa manca | perché il repo non basta | la misura, esatta |
|---|---|---|---|
| **A** | 🟠 **Dimensione in byte dell'`.ex5`** e **confronto data `.ex5` ↔ data `.mq5`** | `CODA_06` stampa la data dell'`.ex5` ma **non** i byte né la data del `.mq5` accanto: non può dire *«sorgente aggiornato e mai ricompilato»* | La riga **esiste già** e ha passato il doppio cancello: `report/BINARI_IN_CAMPO_FTMO_2026-09-21.md` §③ — stampa nome, **byte**, data dell'`.ex5` **e** del `.mq5`, col marcatore `SORGENTE PIU RECENTE DEL BINARIO`. 🖥️ **finestra PowerShell sul VPS `VMI3047753`**, sola lettura, **non tocca** `50503392` · `50504263` · **`10105439`** · `50504400` · `50503635` · Pepperstone · Tickmill. ⏱️ ~2 min |
| **B** | 🟠 **`ABTG_PausaGuardian.mqh` in `MQL5\Include`: quale versione è finita là?** | `CODA_06` legge **solo** `MQL5\Experts`. Che l'F7 sia riuscito prova che *un* include c'era, non **quale** | Stessa riga di **A** (§1-d: la riga legge già byte e data dell'include). 🟢 **Nota che sdrammatizza**: v1.20 (398) e HEAD (2461) hanno **la stessa identica** logica B1/C1 per chiamate a due argomenti → **il comportamento non cambia** in nessuno dei due casi |
| **C** | 🔴 **`AutoTrading` acceso?** | **Non è leggibile da nessun file.** È il fail-open che nessuna misura di repo può escludere | ✋ **Controllo a vista**, 🪟 terminale **FTMO `541452707` (`C:\FTMO`)**: pulsante **verde** e faccina 🙂 su ogni grafico. 🟢 *Indizio forte a favore*: il 22/09 sono stati piazzati ordini veri e il Guardian logga ancora stanotte |
| **D** | 🟠 **La `770402` (MaxMin ORO) è sospesa o cancellata?** | Il suo preset sta in `mql5/Presets/FTMO/` ma l'EA **non è in campo per scelta dichiarata** (`SCHIERA_FTMO.ps1` r.221) | Una **firma di Claudio**, non una misura: o entra col suo pin, o il preset esce dalla cartella FTMO |
| **E** | 🔴 **La baseline giornaliera (§4.3)** | L'input non esiste nel binario: non è un buco di misura, è un **pezzo mancante** | Serve **un F7 del Guardian a HEAD** + `InpDailyBaseline=1`. 🛑 **È una decisione di Claudio**, vedi §8 |

---

# 8️⃣ ✋ QUELLO CHE NON PROPONGO — e il costo, perché decida lui

🛑 **Non propongo nessuna ricompilazione e nessun riattacco**: la challenge **sta operando**, e
toccare un EA vivo è una decisione di Claudio. Metto solo i fatti e i prezzi.

| se Claudio volesse… | che cosa costa **davvero** | rischio di farlo **adesso** |
|---|---|---|
| **portare la baseline a SALDO** (§4.3) | 1 F7 di `ABTG_Guardian.mq5` a HEAD (899 righe, v1.14) sul MetaEditor del terminale **FTMO `541452707` (`C:\FTMO`)** + staccare/riattaccare **solo** il Guardian sul suo grafico `NZDJPY H1` + preset con `InpDailyBaseline=1` | 🟠 medio: alla riaccensione il Guardian **ricattura la baseline del giorno** e azzera `GV_CAP`. Va fatto **a mercato chiuso** e **con zero posizioni aperte**, mai in sessione |
| **far PRETENDERE il Guardian alle sedie** (§5.4) | tocca **i sei EA**: un argomento in più in 42 punti di chiamata → **6 F7** e **6 riattacchi** | 🔴 **alto**: sei sedie staccate e riattaccate a challenge viva. **Io non lo farei adesso.** Vale dopo il 1° ottobre |
| **riallineare il cap C1 a 3,25%** | solo preset, nessun F7 | 🔴 **è un parametro di RISCHIO: è tuo.** E riporterebbe la flotta a **una sola posizione per volta** a taglia 2,00% (il motivo per cui fu alzato: preset r.108-122) |
| **mettere `InpUsaGuardian=true` nel `.set` della `770511`** | una riga nel `.set` in repo | 🟢 **zero** sul campo (è già `true`): è igiene per il **prossimo** schieramento, non per questo |

---

# 9️⃣ 🧪 I CONTRO-ESEMPI CHE HO COSTRUITO CONTRO QUESTO REFERTO

| # | *«e se…»* | esito |
|---|---|---|
| ① | *«la guardia è in un'ALTRA funzione e il tuo conteggio non se ne accorge»* | 🟢 **respinto**: stampata la terna ordine/guardia/funzione per tutte e 42 le righe, distanze 1-43, nomi coerenti (§2.2) |
| ② | *«hai auditato HEAD, ma in campo vola un'altra cosa»* | 🟢 **accolto e riparato**: rifatto tutto ai **pin**, e i pin li ho verificati **riproducendo le impronte SHA256** dello script di deploy — 8 su 8 (§3.2) |
| ③ | *«il `.chr` combacerebbe anche con un binario diverso ma con gli stessi input»* | 🟠 **vero e dichiarato**: il `.chr` prova l'**interfaccia**, non il corpo. Il corpo lo tengono le righe del `.mq5` in campo (7/7) e la data dell'`.ex5` (§3.4) |
| ④ | *«`GUARD = SI` di `CODA_06` potrebbe voler dire un'altra cosa»* | 🟢 **respinto leggendo lo strumento**: `CODA_06_quale_codice_gira.ps1` **r.88-89**, `SI` ⇔ il file contiene `GuardiaIngresso` o `InpUsaGuardian` |
| ⑤ | *«`COMPILATO IL` esce sempre una data, anche senza `.ex5`»* | 🟢 **respinto col controllo negativo**: nella **stessa tabella** i sette `ABTG_*.mq5` orfani stampano `(nessun .ex5)`. Lo strumento sa dire di no |
| ⑥ | *«il preset scrive chiavi che il binario v1.12 non conosce, e MT5 le ignora in silenzio»* | 🟢 **respinto**: 15 chiavi del preset ↔ 16 input del sorgente al pin, **tutte presenti**; e il `.chr` ne conta **16**, non 19 (§4.2) |
| ⑦ | *«Guardian v1.12 e include v1.20 potrebbero parlare due lingue diverse»* | 🟢 **respinto**: stessi nomi di GlobalVariable, stesso suffisso di conto, verificati nei due file (§4.2) |

---

# 🔟 📚 TUTTO QUELLO CHE HO APERTO OGGI — per nome

**Sorgenti** (HEAD e ai pin, via `git show`): `mql5/Experts/ABTG_DAX_Apertura_EU.mq5` ·
`ABTG_Dow_Apertura_US.mq5` · `ABTG_Nasdaq_Apertura_US.mq5` ·
`ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5` · `ABTG_SuperWave_DOW_H1_Ottimizzato.mq5` ·
`ABTG_EMA200.mq5` · `ABTG_Guardian.mq5` · `mql5/Include/ABTG_PausaGuardian.mqh` (+ blob `cc90fb73`).
**Preset**: i 12 di `mql5/Presets/FTMO/` · `mql5/Presets/ABTG_Guardian_FTMO_2Step.set` ·
`ABTG_Guardian_50504263_779001_VIVO.set`.
**Strumenti**: `backtest_pipeline/righe/SCHIERA_FTMO.ps1` · `CODA_06_quale_codice_gira.ps1`.
**Misure di campo**: `backtest_pipeline/coda/referti/CODA_06_…_20260924_033003.log` ·
`CODA_08_preset_dai_chr_20260924_033003.log` · `CODA_09_giornale_operativo_20260924_033003.log`.
**Referti** (citati **come tali**, non rimisurati): `IL_PIANO_DEGLI_OTTO_GIORNI_2026-09-23.md` ·
`BINARI_IN_CAMPO_FTMO_2026-09-21.md` · `PACCHETTO_SCHIERAMENTO_PROP_2026-09-21.md` ·
`IL_DD_DELLE_SEI_SEDIE_2026-09-24.md` · `IL_NUMERO_VERO_DELLE_SEDIE_2026-09-21.md` ·
`RESOCONTO_2026-09-23.md` · `RINOMINA_CLAU12_2026-09-20.md` ·
`LA_CHALLENGE_NON_STA_OPERANDO_2026-09-24.md`.

---

*Censimento di sola lettura prodotto il 24/09/2026. Ogni numero di riga è stato **ricontato
oggi** sul file che lo contiene. Dove un numero viene da un altro referto, è scritto accanto.
Dove una misura non esiste, c'è scritto che cosa manca e come si prende — e non c'è un numero al
suo posto.*
