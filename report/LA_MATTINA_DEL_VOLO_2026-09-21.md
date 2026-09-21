# ☕ LA MATTINA DEL VOLO — lunedi' 21/09/2026

> Tutto quello che serve a Claudio stamattina, in ordine di decisione. Niente referti da
> leggere: i referti stanno sotto, qui ci sono solo le cose da **fare** o da **firmare**.
> Ogni numero e' stato riverificato alla fonte da me stanotte, non ripreso dai riassunti.

---

## ① ✅ NON C'E' NIENTE DA SISTEMARE PRIMA DELL'APERTURA

L'ultimo controllo che restava aperto — **«il binario che vola ha input che il preset non
scrive?»** — l'ho chiuso stanotte, contando gli input **al pin di ciascuna sedia**:

| sedia | input nel binario | scritti nel `.set` | esito |
|---|---:|---:|---|
| `770101` DAX | 82 | 82 | 🟢 completo |
| `770202` Dow | 81 | 81 | 🟢 completo |
| `770260` Nasdaq | 98 | 98 | 🟢 completo |
| `770411` MaxMin | 52 | 52 | 🟢 completo |
| `770511` SuperWave | **44** | **41** | 🟠 tre al default |
| `771531` EMA200 | 43 | **44** | 🟠 uno di troppo |

🟢 **E tutte e due le anomalie sono innocue, verificato:**
- i tre input di `770511` lasciati al default sono `InpPendingAtr=0` e `InpSLBufferAtr=0`
  (**inerti**, il sorgente li commenta *«0 = come prima»*) e **`InpUsaGuardian`, che ha
  default `true` nel binario** (r.45): 👉 **il cancello Guardian e' acceso anche su quella
  sedia**, come sulle altre cinque dove e' scritto nel `.set`;
- `InpLogImbuto` nel preset di `771531` **non esiste nel binario al pin**: MT5 lo **ignora**.

---

## ② 📨 LA RIGA DA LANCIARE — spread all'apertura

**Bersaglio: 🖥️ finestra PowerShell sul VPS.** Non apre nessun MT5, non tocca il piccolo
`50503392`, il 100k `50504263`, il banco `50504400`, Pepperstone, Tickmill — e **non puo'**
toccare il reale `10105439`.

📄 La riga sta in **`backtest_pipeline/righe/RIGA_SPREADLOGGER_FTMO_DA_MANDARE.md`**
(pin `582341cd…`, marcatore `…_v6`). **Ha il PASS di tutti e due gli strati del cancello.**

| giro | quando premere invio | quale riga guardare nel referto |
|---|---|---|
| apertura DAX | **~09:30 IT** | riga **`10`** (ora server FTMO) |
| apertura USA | **~16:00 IT** | riga **`16`** |

🔴 **Fuso FTMO = ora italiana PIU' 1** (misurato). **Non** vale la regola BCM, che e' meno 1.
🟠 Con una giornata sola il referto marchera' **SOTTILE** ogni riga: quello di oggi e' un
**ordine di grandezza**, non una statistica. La misura si chiude **venerdi' 25/09**.
🟢 Ma decide comunque una cosa: se il P95 all'apertura e' **il doppio** dei numeri a mercato
chiuso del prevolo (`GER40.cash` 143 · `US30.cash` 263 · `US100.cash` 153), `InpMinStopPts`
si rifa' **oggi** e non si aspetta venerdi'.

---

## ③ 🖊️ L'UNICA FIRMA PRONTA — costo zero tempo macchina

> **`770101` DAX: `InpTP1_ClosePct` 50,0 → 0,0** nel suo `.set`.
> Il breakeven a 1R **resta acceso**: non si toglie la rete, si smette solo di chiudere
> meta' posizione a 1R.

| | `50` (vola) | `0` | |
|---|---:|---:|---|
| PF fuori campione | 1,39709 | **1,49140** | 🟢 +6,8% |
| DD **in euro** fuori campione | 8.886 | **7.974** | 🟢 −10,3% |
| profitto fuori campione | 18.029 | **23.607** | 🟢 **+30,9%** |
| *(stessi versi anche in campione)* | | | 🟢 |

🔴 **Quello che devi sapere prima di firmare, e non e' poco:**
1. e' **UNA** misura letta in tre file, non tre conferme;
2. e' misurata a rischio **1%** sul simbolo **BCM `D30EUR`**, non al 2,00% su `GER40.cash`;
3. la manopola e' **fragile alla configurazione**: nello stesso CSV, altre righe con
   `ClosePct=0` fanno **PF 0,875 e DD 22,5%**. Va bene **nella nostra** configurazione
   (trailing acceso, che la sedia ha), non in assoluto;
4. 🛑 **e sul DOW la stessa manopola PERDE** (PF 1,27013 → 1,25809, DD 4,3941 → 5,4280).
   **Non si estende per simmetria a nessun'altra sedia.**

---

## ④ 🛡️ LE SOGLIE DI REVISIONE — la riga da tenere sotto mano

> **Revisione IMMEDIATA se il DD forward supera:**
> `770101` **14,47%** · `770202` **8,79%** · `770260` **7,35%** · `770411` **3,84%** ·
> `770511` **7,82%** · `771531` **15,66%**

⚠️ **Tre avvertenze che non si saltano:**
1. sono **discesa dal PICCO**; il muro FTMO 2-Step e' **statico dal saldo iniziale**
   (72.000 € su 80.000). Superarle = **revisione di casa**, non challenge finita;
2. sono il DD a 1,00% **×2**, e il metro lineare **SOVRASTIMA** (misurato: il DD e'
   **sub-lineare** nel rischio). 👉 **Sono TETTI: fanno scattare la revisione TARDI.** Se il
   forward ci si avvicina, si guarda **prima**;
3. `770260` e `770511` sono misurate su banco da **10.000 €** contro i nostri 80.000: quelle
   due soglie sono **limiti inferiori** — scattano presto, ed e' il verso giusto.

---

## ⑤ 📰 E UNA COSA DA SAPERE: **oggi volano SEI sedie, non nove**

Le tre PostNews (`771202` FOMC · `771203` NFP · `771204` ECB) **non apriranno**: hanno
`InpRestrictToNews=true` e il loro calendario e' scaduto. 🟢 Fallisce nel modo giusto —
**fail-closed**, provato sul codice: nessun ramo apre senza evento.
🔴 **E non si sa quando tornano vive**: in repo ci sono **due `abtg_news.csv` diversi**, e
quello che la nostra catena distribuisce ha **zero eventi futuri**. Si chiude con una riga di
sola lettura sul VPS, quando vuoi.
🔴 **Rigenerare il calendario NFP NON e' manutenzione**: accenderebbe una sedia col contratto
`[NON MISURATO]` a **1,30% per evento**. E' una firma di rischio.

---

## ⑥ 🔧 E UNA COSA CHE **NON** CONSIGLIO DI FARE OGGI

Le tre Aperture hanno il difetto della **classe 502** (una `PositionModify` rifiutata che si
ripete a ogni tick dentro la barra). 🟢 **Non lo tocchiamo prima del volo**: vale al massimo
**328 richieste locali** su una soglia di 2.000, e probabilmente **zero** perche' senza tempo
di rete al server non arrivano. Mettere sei righe mai compilate dentro tre EA il giorno della
partenza costa piu' di quanto rende.
✅ **Costo zero da fare stasera**: contare i `FALLITI` nella pagella. Se una giornata FTMO
supera i **328** del BCM, la riparazione si anticipa **su un dato**.

---

### 📚 I referti sotto, se servono
`LE_2000_RICHIESTE_LA_MISURA_2026-09-20.md` · `CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` ·
`LE_POSTNEWS_NON_TRADERANNO_2026-09-20.md` · `CELLE_MIGLIORI_GIA_MISURATE_2026-09-21.md` ·
`RIPARAZIONE_CLASSE_502_2026-09-20.md` · checklist classi **502-517**.
