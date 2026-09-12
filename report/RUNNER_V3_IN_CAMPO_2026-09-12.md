# 🟢 IL TAPPO E' SALTATO — runner v3 IN CAMPO, e il censimento del VPS

**12/09/2026, 08:45-08:46.** Claudio ha lanciato PASSO 2B e il censimento.
**Erano le due cose che bloccavano tutto**, e sono entrambe fatte.

## 1. ✅ RUNNER v3 INSTALLATO — verificato sull'ARTEFATTO, non sul log

Il log dell'installazione dice di se stesso che e' andato bene: **non basta**.
Verifica indipendente sui file dello zip:

| controllo | atteso | misurato |
|---|---|---|
| impronta del runner installato | `21AC6672…` | 🟢 **identica, cifra per cifra** |
| righe | 836 | 🟢 **836** |
| marcatore `MARCATORE_RUNNER_ABTG_v3` | presente | 🟢 **2 occorrenze** |
| `stderr` dell'installazione | vuoto | 🟢 **0 byte** |
| attivita' `\ABTG_Runner` | viva | 🟢 **Pronta, Abilitata** |
| prossima esecuzione | stanotte | 🟢 **13/09/2026 03:30:00** |
| comando | il runner installato | 🟢 `powershell -NoProfile -ExecutionPolicy Bypass -File C:\ABTG\runner_abtg.ps1` |
| host dell'attivita' | il VPS | 🟢 **VMI3047753** |

🔑 **E la copia vecchia e' al sicuro**: `runner_INSTALLATO_PRIMA.ps1`
(`74BD2884…`, 347 righe, marcatore v3 = 0) e' nello zip del 2A.

### 🟠 DUE COSE DA SAPERE, e la prima e' operativa
1. **`Modalita' accesso: Solo interattivo`.** L'attivita' parte **solo se la
   sessione di Administrator e' ancora collegata**. 👉 **Sul VPS si fa
   "Disconnetti", MAI "Esci/Log off".** 🟢 Non e' un allarme: ha funzionato
   **cinque notti di fila** (i referti `CODA_*` del 08, 09, 10, 11 e 12/09 sono
   tutti timbrati 03:30), quindi la sessione resta su. E' una cautela, non un
   difetto.
2. **`Ultimo esito: 267011`** con `Ultima esecuzione: 30/11/1999`. Non e' un
   errore: `267011` = `0x41303` = **"l'attivita' non e' ancora stata
   eseguita"**. L'attivita' e' stata **ricreata** adesso, quindi la storia e'
   azzerata. Lo scrivo perche' un codice a sei cifre spaventa a vuoto.

## 🌙 COSA GIRA STANOTTE ALLE 03:30

**15 righe in coda**: **11 di sola lettura** (`CODA_01`…`CODA_11`) + **4 di
round**, tutte al pin `8027068f`:

| etichetta | motore | cosa misura | passate |
|---|---|---|---:|
| `r132c` | `SupRev_DOW_H1_Ott` | pavimento dello stop — **e' un cancello di DETERMINISMO**: 5 celle su 8 sono gia' girate in R123D e **devono tornare identiche** | 16 |
| `r133b` | `ORB_Ottimizzato` | un filtro **scritto e mai eseguito** (52 gruppi su 52 morti) | 4 |
| `r133a` | `Nasdaq_Apertura_US` | `InpLevelTF` — **mai ad asse in 0 CSV su 2.083** | 14 |
| `r133c` | `MaxMinNotte` | `InpMinBoxPts` — 18/18 identici, scala fuori range di **10x** | 18 |

📋 Atteso domattina: **8 CSV**, 4 `REFERTO_ROUND_*`, 1 `REFERTO_RUNNER_*`.

## 2. 🔍 IL CENSIMENTO DEL VPS — due numeri di conto che NON AVEVAMO

Girato sul VPS (`VMI3047753`, QEMU, Windows Server 2022, sessione `RDP-Tcp#1`).
**Il verdetto viene dal NOME della macchina**, non dalla sessione ne' dalla
batteria — ed e' la correzione che il cancello mi aveva imposto.

**6 `terminal64.exe`**: i 4 BCM noti + **2 esterni**.

| cartella dati | terminale | **CONTO** | ultimo giornale | sedie |
|---|---|---|---|---:|
| `04C7A32B` | `C:\MT5_Backtest` | 50504400 | 09/09 20:18 | 0 |
| `215D85D7` | `BCM Markets MT5 Terminal` | 50503392 | 12/09 01:15 | **40** |
| `BCA8AD18` | `… -V3` | 50504263 | 12/09 01:15 | **13** |
| `E23E1504` | `C:\BCM_Reale` | 10105439 | — | 4 |
| 🆕 `73B7A242` | **Pepperstone** | **`62128200`** | **18/06** 19:22 | **0** |
| 🆕 `857385E4` | **Tickmill** | **`25336156`** | 30/07 14:11 | **2** |

🟢 **`CODA_03` diceva `CONTO: NON TROVATO` su tutti e due.** Adesso ci sono,
perche' il censimento guarda i **5 giornali piu' recenti** invece dei soli
"recenti": i terminali erano fermi da mesi, non muti.

### 🎯 E i tre fatti che chiudono la questione Pepperstone
1. **`62128200` e' ESATTAMENTE la demo del piano P2**
   (`COME_ALLUNGARE_STORICO_INDICI_2026-09-09.md`: *"la demo Pepperstone
   62128200, sondata il 15/08"*). Quindi **P2 vive sul VPS**, e il Pepperstone
   che Claudio ha disinstallato dal **PC desktop** non c'entrava: 🟢
   **disinstallarlo non ha rotto niente.**
2. **Ultimo giornale 18/06**, **2 soli file**, **0 sedie**: quattro numeri
   indipendenti che confermano il suo *"e' chiuso da tempo, non lo apro mai"*.
3. 🔴 Ma **l'azienda dice `PepperstoneUK-Live`**: il terminale punta a un
   server **Live**. Non tocchiamo niente.

### 🔴 E LA COSA PIU' GROSSA: **l'FTMO NON E' SUL VPS**
`ftmo` nel referto: **0 occorrenze**. Sei terminali, nessuno FTMO.
👉 Quindi **`FTMO Global Markets MT5 Terminal` (installato il 27/08) esiste
SOLO sul PC desktop** — la macchina che **non abbiamo ancora censito**.
⏳ **Serve la seconda corsa della stessa riga, sul PC desktop.** E' l'unica
strada per sapere cos'e', e l'11/09 e' emerso un conto da **109k** di cui non
conosciamo il broker.

### 🟢 Una conferma che vale: `BREAKOUT_EA_JPY_v3`
Sul Tickmill del VPS, letto dai `.chr`: **`BREAKOUT_EA_JPY_v3  USDJPY`** +
`Gold_Ichimoku_TK_ATR_EA  XAUUSD`. Il sorgente che **non esiste nel repo** e'
la', su un terminale **spento da luglio**, su un conto (`25336156`) che ora
conosciamo. **Non e' in pericolo, e non si disinstalla.**
