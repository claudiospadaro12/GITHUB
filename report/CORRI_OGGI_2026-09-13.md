# 🏃 CORRI OGGI — il giacimento e' confermato, ma oggi se ne lavora meno di META'

**Sabato.** Claudio: *"Non andiamo alle 3.30, se puoi anticipare, fallo. Anche
ora."* Questo referto raccoglie il lavoro dell'agente che ha scavato nella
miniera dei file prova mai eseguiti. _(Lo scrivo io: quell'agente ha il divieto
di produrre referti `.md`, e il contenuto sarebbe andato perso.)_

## 🏺 1. I 53 SONO VERI — ricontati con TRE chiavi, non con una

Non ho ereditato il numero: e' stato **ricontato da zero** su tutti i **2.300
CSV** del repo, con tre chiavi indipendenti:

| chiave | domanda |
|---|---|
| **K1** nome | esiste un CSV che finisce per `_<etichetta>.csv`? |
| **K2** contenuto | il valore di `InpComment` compare dentro un CSV? |
| **K3** contenuto | 🆕 il valore di `InpMagic` compare dentro un CSV? |

🟢 **53 confermato**, e anche `268 celle / 536 passate` tornano al numero esatto.
Tutte e tre le chiavi danno **0** su tutti e 53.

⚠️ **Ma il 268 e' un LIMITE SUPERIORE, non una misura**: `controlla_prova.py`
conta gli assi in **aritmetica**, e su un asse `ENUM_TIMEFRAMES` sbaglia — su
`R128a` conta **26** dove le celle vere sono **7**.

🔵 E la terza chiave ha trovato una cosa che le altre non vedevano:
🟡 **`R135a` riusa il magic `784120` E il commento `SRDOW123C` di `R123c`**: i
suoi CSV sarebbero **indistinguibili per chiave interna**. _(`R135a` e' gia'
RITIRATO da ieri e non gira, ma il difetto va chiuso prima che qualcuno lo
riesumi.)_

## 🔴 2. PRIMA BRUTTA NOTIZIA: **12 dei 53 hanno l'EA su «NON COMPILARE»**

| EA | commit | round | lanciabile |
|---|---|---|---|
| `ABTG_SuperWave_DOW_H1_Ottimizzato` | **`b45dd00`** | r120b×4 · r120e×2 · **r126a** · r126b · r126c | ❌ |
| `ABTG_SuperWave` | **`b45dd00`** | r126d | ❌ |
| `ABTG_SupertrendReversal_Ottimizzato` | **`b45dd00`** | **r127b** | ❌ |
| `ABTG_CostToCost` | **`b45dd00`** | **r127c** | ❌ |

> 💔 **E fa male, perche' sono fuori proprio le gemme.** Il censimento dell'11/09
> elenca le **tre** manopole d'uscita mai mosse in tutto l'archivio:
> `InpSLBufferPips` (3 valori in 280 CSV) → **`r127a` ✅** ·
> `InpSLLookback` (5 in 290) → **`r127b` ❌** ·
> `InpMaxBarsHold` (100 in 128) → **`r127c` ❌**.
> E `r126a` — la sedia dichiarata **al 96% del pavimento di costo** — e' **❌**.
>
> 👉 **Una su quattro si puo' lanciare oggi. Le altre tre costano una
> COMPILAZIONE, non un round** — ed e' la cosa piu' economica che si possa fare.

## 🔴 3. SECONDA BRUTTA NOTIZIA, ED E' UNA **CLASSE NUOVA**

**Venti dei 53 passano il cancello e NON SONO LANCIABILI.** Misurato leggendo le
intestazioni una per una: venti file scrivono `-FrazioneIS 0.50 NON E' OPZIONALE`
(`r128b-e`, `r129a-c`, `r130a-e`, `r131a-h`). Ma:
- la riga sottile accetta **cinque** argomenti e **`-FrazioneIS` non c'e'**;
- il driver ha **`$FrazioneIS = 0.40`** come default.

➡️ Girarli darebbe un taglio **40/60** dove i criteri sono congelati su
**50/50**: finestre diverse da quelle su cui le soglie sono state firmate →
**misura NON attribuibile**.

> 🆕 **CLASSE NUOVA**: *passare `controlla_prova.py` ed essere LANCIABILE sono
> due cose diverse — il cancello non sa niente degli argomenti del driver.*

🧮 **E i conti chiudono esatti: 53 = 21 lanciabili + 12 WIP + 20 FrazioneIS.**

## 📏 4. IL METRO DEL TEMPO ERA GONFIO, e adesso c'e' quello giusto

Il nostro `22 s/passata` viene da `REFERTO_R112.txt`, dove le 16 passate erano
**otto avvii separati**: quasi tutto **avviamento del tester**, non celle. Un
metro piatto da li' **sovrastima**.

Il metro buono e' in `r88_csv/REFERTO_R88.txt` r.10-14 — stesso EA, stesso
simbolo, stesso TF, tick reali, tempi **round per round**:

| celle | passate | misurato |
|---:|---:|---|
| 4 | 8 | 1,1 / 1,2 / 1,3 min |
| 8 | 16 | 2,1 min |
| 48 | 96 | **8,0 min** |

**`T(min) = 0,6 + 0,077 x passate`, per round.**
🧪 Controprova su un terzo punto: 16 passate → 1,8 previsti contro 2,1 misurati
(−15%). 🧪 Contro-esempio vinto: applicata a R112 da' **6,0 min** contro i
4,7-6,0 misurati — **lo stesso metro spiega tutti e due i referti**.
🕳️ Buco dichiarato: lo **scarico dei tick** e' `[NON MISURATO]` e non sta in
nessun referto di casa. Per questo i quattro `r120c` (XAUUSD dal 2020) stanno
**ultimi**: se il tempo sfonda, sfonda in coda con 17 round gia' in cassaforte.

## 🥇 5. I 21 LANCIABILI — 77 celle, 154 passate, **~25 minuti** (banda 13-50)

| # | round | asse | chiude |
|---|---|---|---|
| 🥇 1 | **r127a** | `InpSLBufferPips` | **req. 3** — l'unico dei tre in cima al censimento lanciabile oggi |
| 2-5 | **r120a**×4 | `InpTrailOnST` × `InpExitOnFlip` | **req. 3** — due manopole con **ZERO occorrenze come asse in tutto il repo** |
| 6 | **r128a** | `InpTrailTF` M5→M30 | **req. 3** sulla sedia del **conto REALE** |
| 7-12 | **r125a-f** | costo / parziale / lato / ampiezza | frontiera del costo · 🖊️ criteri **firmati da Claudio il 10/09** |
| 13 | **r124a** | `InpFirstFraction` | terza manopola a **zero occorrenze** |
| 14-17 | **r120d**×4 | trail × flip | **req. 3** |
| 18-21 | **r120c**×4 | trail × flip | **req. 3** + 🧪 **l'unica finestra MULTI-REGIME** (XAUUSD 2020→2026: crollo '20, orso '22, toro '23-'25) = regola **C** dell'Emendamento |

🔴 **Buco dichiarato**: `R120a/c/d` **non hanno un blocco d'attesa formale**.
Un round senza attesa scritta prima dei numeri si legge come si vuole — se
girano, l'attesa va scritta **prima** di aprire i CSV.

## 🔴 6. E UN FILE PROVA CHE DICE IL FALSO

`R127a` r.12 e r.16 scrive **`-Modello 1`** e lo commenta **"= TICK REALI"**.
🔴 **Falso, verificato al sorgente**: `walkforward_generico.ps1` **r.172** →
*"4 = tick reali (verita'). 1 = OHLC M1: SOLO screening, mai verdetti"*. E' **la
classe di R132**, stavolta dentro un file prova. La differenza e' misurata:
stessa cella, **PF 1,68815 a tick** contro **1,85106 in OHLC**.
➡️ Lo script passa **`-Modello 4`** e lo dichiara; il commento va corretto al
prossimo giro di pin.

🟢 **E una correzione che ci ridà un'ancora**: `PIANO_CHALLENGE_OTTOBRE_v2.md`
r.97 diceva che per la `970913` *"l'unico file OOS in archivio e' `_ohlc`"*.
**Ne esistono tre**, e quello **senza suffisso e' a tick reali**. 🧪 Contro-esempio
vinto: se la convenzione fosse applicata male, il file senza suffisso porterebbe
il numero **ottimista**; porta quello **pessimista** (1,688 contro 1,851).
**L'ancora di `r127a` regge su dati a tick reali.**

## 🎯 IN UNA RIGA
**Il giacimento c'e' ed e' confermato a 53 — ma oggi se ne lavorano 21, e le tre
gemme che cercavamo sono ferme per una COMPILAZIONE, non per una misura.**
