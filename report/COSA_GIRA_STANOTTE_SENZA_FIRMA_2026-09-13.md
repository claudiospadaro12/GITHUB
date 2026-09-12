# 🌙 COSA PUO' GIRARE STANOTTE **SENZA NESSUNA FIRMA**, e cosa no

**13/09/2026, sabato, mercati chiusi.** Claudio: *"Non posso autorizzare la riga
dei backtest. Ci pensate voi!!!! Io sono al wake up call."*

🟢 **Risposta: per macinare stanotte non serve la sua autorizzazione.** La
**corsia ROUND sul banco `50504400`** (`C:\MT5_Backtest`) e' **firmata
dall'11/09**, il runner **v3** e' in campo (verificato stamattina: impronta
`21AC6672…`, attivita' `\ABTG_Runner` **Pronta**, prossima esecuzione **03:30**)
e il collaudo dei cancelli ha fatto **50 su 50**. Mettere righe in coda **usa una
corsia gia' autorizzata: non allarga nessun perimetro.**

## 🔴 IL VINCOLO VERO, MISURATO — e non e' l'autorizzazione, e' la LISTA BIANCA

Ho aperto il `param()` di `backtest_pipeline/righe/RIGA_SOTTILE_ROUND.ps1`.
La corsia firmata accetta **sei parametri e basta**:

```
-Expert   -Prova   -Etichetta   -Modello   -Deposito   -SoloControllo
```

🔴 **Niente `-Spread`, niente `-DaQuando`, niente `-Fino`, niente
`-FrazioneIS`, niente `-Ritardo`.** Non e' una dimenticanza: e' la firma di
Claudio dell'11/09, ed e' **stretta di proposito**.

## 📋 QUINDI, PROVA PER PROVA (misurato aprendo ogni file)

| prova | passate | serve fuori dalla lista bianca | in coda? | chiude |
|---|---:|---|---|---|
| `COLLAUDO_EMADOW_02_pertrade_IS` | **2** | niente (`@DAQUANDO` **e** `@FINOA` dentro il file) | 🟢 **SI** | **req. 2** — `n` in POSIZIONI |
| `COLLAUDO_EMADOW_05_tf_U30USD` | **14** | niente (`@DAQUANDO` dentro) | 🟢 **SI** | **req. 5** — TF cambiato |
| `R136a` · `R136b` · `R136c` · `R136d` | **40** | niente | 🟢 **SI** | **req. 3** — gestione dell'USCITA |
| `00_manopola_maxspread` | 10 | **`-Spread`** | 🔴 no | riparazione candidata del C3 |
| `01_spread_scala_ini` + 🐤 canarino | 24 | **`-Spread` `-DaQuando` `-Fino` `-FrazioneIS`** | 🔴 no | prop-hardening sullo spread |
| `06_latenza` | 16 | **`-Ritardo`** | 🔴 no | prop-hardening sulla latenza |

### 🎯 IL NUMERO CHE CONTA
**56 passate ≈ 21 minuti** possono girare **stanotte, senza firma**, e insieme
chiudono i **TRE requisiti mancanti** del certificato di morte su `EMA200` Dow:

> **certificato da 3/5 → 5/5**, sulla sedia che il censimento del 09/09 ha
> trovato come **l'unica delle 41 vive** che passa i cancelli alla lettera, e
> che era **ferma sul demo**.

### ✍️ E COSA RESTA DI CLAUDIO, detto senza girarci intorno
Il **prop-hardening** (canarino + scala di spread + latenza, **50 passate**)
vuole parametri **fuori dalla corsia firmata**. Non si aggira: **serve una
firma nuova** che allarghi la lista bianca a `-Spread` e `-Ritardo` sul solo
banco `50504400`. 🔴 **Lo scrivo invece di trovare una scorciatoia**, perche' il
perimetro del runner e' l'unica cosa che ci separa da un incidente sul campo.

## 🔴 E LA DOMANDA BLOCCANTE CHE VALE PER TUTTE E SEI LE RIGHE

Il driver **compila l'EA dalla TESTA del branch `lavoro`, NON dal pin**
(cablato `$EABranch="lavoro"`; la riga sottile lo **dichiara** a r.54-60). E la
testa di `mql5/Experts/ABTG_EMA200.mq5` e' **`b45dd00` = "IN CORSO D'OPERA —
NON COMPILARE"**.

L'autore del pacchetto ha **letto il diff** col binario di R112: **+154/−16
righe, dichiarate tutte diagnostica** (l'imbuto dell'11/09). 🔴 **Ma "tutte
diagnostica" e' una TESI, e il cancello la sta verificando riga per riga.** Se
**una sola** riga tocca segnali, ingressi, stop, taglie o uscite, **nessuna
delle sei entra in coda.**

📌 **Non e' prudenza astratta: e' il caso identico a `r133a`, tolta ieri.** La
testa del Nasdaq era un WIP che cambiava il monitor d'ingresso — da
**rottura + LIMIT sul livello** a **chiusura oltre il livello + ingresso a
mercato** — esattamente per `InpEntryMode=0` che quel file prova usava. La
misura sarebbe stata **non attribuibile**: numero bello o brutto, non avremmo
saputo se era il TF dei livelli o l'ingresso nuovo.

🟢 **E se invece il diff e' davvero tutta diagnostica, il round vale DOPPIO**:
diventa anche il collaudo che quella patch e' **neutra sul trading** — perche'
ogni file contiene la cella viva e **deve ridare** IS 237 deal / PF 1,20110 /
DD 5,7325% e OOS 517 / 1,52365 / 7,8323%. Un cancello di determinismo gratis.

## 🚧 CIO' CHE NON PROMETTO, scritto prima dei numeri

**A 21 minuti (o a 40) ci sono NUMERI, non un verdetto di schieramento.**
Restano fuori dalla portata di **qualunque** backtest tre cose:
1. ✍️ le **tre firme** (unita' di conto, taglia d'ingresso, tetto per cluster);
2. 🌊 il **flottante** e il **massimo di posizioni contemporanee** —
   `[NON MISURABILE]` dai nostri CSV per-trade (c'e' solo `close_time`), ed e'
   **la grandezza che decide il muro giornaliero prop** su una sedia che lavora
   **a raffiche** (2-8 posizioni in un giorno, 37,5% dei giorni feriali);
3. 🚩 la **concentrazione su UN SIMBOLO SOLO**: `U30USD` **98/98** celle
   positive contro **6 su 330** sui quattro indici gemelli (`D30EUR` 0/80,
   `E50EUR` 0/83, `F40EUR` 0/81, `NASUSD` 2/83, `SPXUSD` 4/86). E **non e' il
   regime**: nella stessa finestra il DAX era anch'esso in toro e fa **0/80**.
   Con **un regime** e **un simbolo**, "proprieta' del Dow" e "sovradattamento
   a una serie di prezzi" **non sono distinguibili coi dati BCM disponibili**.

🎯 Quindi il traguardo onesto di stanotte e': **il certificato completo 5/5 e i
numeri sul tavolo**. Lo schieramento e' una firma, e la firma e' di Claudio.
