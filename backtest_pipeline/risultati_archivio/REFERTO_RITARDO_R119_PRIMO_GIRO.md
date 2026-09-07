# 🐤 R119 — PRIMO GIRO: IL CANARINO HA SPARATO. LA CHIAVE ERA SBAGLIATA.

> ## 🔴 ESITO: **NON MISURATO** — e NON vuol dire "immune al ritardo".
> Il round si è fermato a **2 corse su 8**. `ExecutionMode` scritto come
> `Delay` non esiste in MT5: la riga veniva **ignorata in silenzio**.

- Corsa di Claudio sul PC di backtest, 07/09/2026 ore 16:13
- Contratto: `backtest_pipeline/prove/RITARDO_TESTER_R119.txt` (G0-G2, S1-S4)
- CSV grezzi + referto della macchina: `risultati_archivio/ritardo_r119_csv/`
- Riga v1 (difettosa): pin `7357f463`

---

## 1. 🧨 IL FATTO

Le due corse del canarino — stessa identica cella, `Delay=0` e `Delay=500` —
sono uscite **identiche byte per byte**, sia IS sia OOS:

```
diff IS_D0000.csv IS_D0500.csv    -> nessuna differenza
diff OOS_D0000.csv OOS_D0500.csv  -> nessuna differenza
```

Il cancello G0 ha detto `IGNORATA` e ha fermato la spesa. **Sei corse a tick
reali risparmiate.**

## 2. 🔍 PERCHÉ — ed è un errore mio, non di MT5

La chiave che avevo inventato si chiamava `Delay`. Nella finestra del tester
la tendina si chiama *"Delays"*, e il nome sembrava giusto. **La chiave vera
dell'`.ini` è `ExecutionMode`:**

| valore | significato |
|---|---|
| `0` | esecuzione normale, nessun ritardo |
| `-1` | ritardo **casuale** |
| `1` .. `600000` | ritardo in **millisecondi** |

⚠️ **MT5 ignora in silenzio le chiavi di `[Tester]` che non conosce.** Niente
errore, niente avviso, uscita 0, CSV prodotti, gemelli a posto, referto verde.
Un round che **sembra girato e non lo è**.

## 3. ✅ COSA HA FUNZIONATO — e vale la pena dirlo

Il canarino era scritto **nel contratto, prima dei numeri**, come **codice fra
le due corse** (classe 151, imparata sbagliando ieri in R118). Al primo giro
vero **è scattato**.

> 👉 Senza il canarino sarebbero girate tutte e otto le corse e il referto
> avrebbe detto *"le due sedie vive reggono fino a 500 ms di ritardo"*.
> Una **bugia con i numeri sotto** — la specie peggiore.

## 4. 🔧 UNA CORREZIONE CHE DEVO — quello che avevo scritto non era esatto

Avevo scritto che 39 round sono girati *"a esecuzione ottimale e nessuno lo
diceva"*, chiamandolo **stato nascosto**. È mezzo sbagliato:
`walkforward_generico.ps1` scrive **`ExecutionMode=0`** in tutti e due i suoi
blocchi `[Tester]` **dal 07/08/2026**.

**Non era nascosto: era dichiarato nell'`.ini`, e nessun referto l'ha mai
letto.** La sostanza non cambia (tutti i round sono a zero ritardo, e quello
resta un fatto da dichiarare in ogni referto futuro), ma il modo in cui l'ho
detto attribuiva al driver un difetto che non ha.

## 5. 📊 QUELLO CHE ABBIAMO MISURATO LO STESSO — 4 CSV già pagati

**Sedia viva ORB 770611, U30USD M5, preset del conto reale, `ExecutionMode=0`**

| finestra | trade | Profit | PF | Equity DD % | Exp. Payoff |
|---|---:|---:|---:|---:|---:|
| IS 2024.09.26 → 2025.06.09 | **71** | +569,12 | 1,231 | **5,65%** | 8,02 |
| OOS 2025.06.10 → 2026.06.30 | **119** | +2.484,17 | 1,675 | **6,54%** | 20,88 |

### 🟢 G1 — GEMELLI DI DETERMINISMO: **PASSATO**
Le due celle dell'asse magic (770611 e 770661) danno numeri **identici alla
cifra** in tutte e due le finestre. **Il banco è deterministico.**
👉 Non è poco: il round dell'orologio INDICI (stesso giorno) ha dovuto
dichiarare il determinismo come **limite non verificato**. Qui è verificato.

### 🟡 G2 — CAMPIONE: **MERITO SOSPESO**
71 e 119 operazioni: **tutte e due le finestre sotto le 150** della regola di
casa (16/08). Si legge il **rischio**, non il merito. I numeri qui sopra sono
**descrittivi**, non una promozione — e il PF 1,675 dell'OOS **non va citato
come merito**.

### 📌 Il DD promesso, agli atti
**5,65% IS / 6,54% OOS** a deposito 10.000 e rischio 0,65%. Serve al
**censimento dei contratti** (prerequisito del criterio di uscita firmato il
18/08): è il numero contro cui si misura il DD forward di questa sedia.

## 6. 🔜 COSA RESTA

- Il round va **rifatto con la chiave giusta**: `ExecutionMode`.
  Driver corretto e ri-collaudato, marcatore `..._v3_EXECMODE`.
  Il default (parametro non passato) resta `ExecutionMode=0`, **byte per byte
  come prima**: tutti i round già pinnati riproducono identici.
- L'ipotesi del contratto **non è toccata** e resta congelata: LIMIT contro
  STOP, 770101 degrada poco, 770611 molto.
- Il difetto è agli atti come **classe 156** in `CHECKLIST_RIGA_DI_LANCIO.md`.
