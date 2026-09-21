# 📏 MIN E MAX RANGE SUL NASDAQ — acceso a metà, e la metà mancante è misurata

**21/09/2026** · sedia **`770260`** `ABTG_Nasdaq_Apertura_US` — **in campo sulla
challenge FTMO `541452707`** · preset
`mql5/Presets/FTMO/ABTG_Nasdaq_Apertura_US_RETEST_770260_FTMO.set`

**Firma di Claudio**: *«accendi min e max range sul nasdaq»* → *«FAI LA 1 MA SI
POSSONO PROVARE LE ALTRE DUE ANCHE?»*

---

## 🔴 LA RIGA CHE CONTA

> **La «opzione 1» che gli avevo proposto — banda riscalata 4500/10800 punti MT5 —
> l'ho scritta nel preset e poi l'ho TOLTA, perché una misura l'ha rotta:
> avrebbe scartato l'87,6% dei giorni del 2026. La «opzione 2» (i numeri
> letterali della live, 1700/4100) ne scarta il 100,0%: sedia MUTA.**
>
> **Acceso il solo MIN, e non sul numero di Emiliano: su quello di casa.
> `InpMinRangePts=7200` È la frontiera firmata `stop >= 40 × spread`.
> Il MAX resta a 0 finché il round R196 non lo misura.**

🟢 **Nulla di sbagliato è arrivato a Claudio né al VPS**: il numero è stato rotto
*prima* della consegna. È la regola del contro-esempio (10/09) che funziona.

---

## 1. 📊 LA MISURA CHE HA ROTTO IL NUMERO

**Fonte**: `backtest_pipeline/risultati_archivio/ANATOMIA_APERTURE_20260826/ANATOMIA_APERTURE_PERGIORNO_NASUSD.csv`
— **3.899 aperture `OK`** di `NASUSD`, 2010→2026, ora di New York dichiarata nel
`CENSIMENTO_FONTE.txt` (apertura cash 09:30 NY = 14:30 server BCM).
Colonne `up30_pt` / `dn30_pt`, riportate a 35' col fattore **misurato** (§3).

### Mediana dell'ampiezza dei primi 30 minuti, anno per anno (punti indice)

| anno | n | mediana | | anno | n | mediana |
|---|---:|---:|---|---|---:|---:|
| 2010 | 33 | 10,2 | | 2019 | 258 | 32,8 |
| 2011 | 257 | 12,8 | | 2020 | 258 | 74,8 |
| 2012 | 251 | 11,5 | | 2021 | 256 | 79,1 |
| 2013 | 250 | 12,2 | | 2022 | 258 | 120,4 |
| 2014 | 248 | 16,2 | | 2023 | 158 | 80,2 |
| 2015 | 252 | 22,0 | | 2024 | 258 | 86,8 |
| 2016 | 254 | 19,2 | | 2025 | 255 | 116,6 |
| 2017 | 251 | 17,8 | | **2026** | **145** | 🔴 **176,6** |
| 2018 | 257 | 39,0 | | | | |

👉 **La mezz'ora d'apertura del 2026 è 15,4 volte più larga di quella del 2012**
(176,6 / 11,5 — un rapporto fra mediane, non una somma). Una banda tarata su una candela da 5 minuti del 2026 —
e per giunta letta su un'altra scala — non ha niente a che vedere con un range
da 35 minuti nostro.

### Quanti giorni scarta ciascuna proposta (ampiezza a 35 minuti)

| banda | 2026 | 2025+2026 | finestra di backtest (dal 2024.09.26) |
|---|---:|---:|---:|
| **OPZIONE 2 — letterale 17/41** (la live) | 🔴 **scarta 100,0%** | 🔴 99,8% | 🔴 99,6% |
| **OPZIONE 1 — riscalata 45/108** (la mia di ieri) | 🔴 **scarta 87,6%** | 🔴 71,2% | 🔴 67,9% |
| **quello che ho messo — solo MIN 72** | 🟢 **scarta 4,1%** | 8,5% | 10,3% |

---

## 2. 🧮 IL PAVIMENTO NON È DI EMILIANO: È DI CASA

`InpSLMode=0` (`ABTG_SL_RANGE`, `ABTG_Nasdaq_Apertura_US.mq5` r.184) ⇒
**lo stop di questa sedia È l'ampiezza del range.**

👉 Quindi il filtro MIN **non è una ricetta copiata**: è, alla lettera, la
frontiera di costo già firmata in casa **`stop >= 40 × spread`**.

- spread `NASUSD` ora **14** server, **mediana misurata su 250 milioni di tick**
  = **1,80** punti indice (`report/STOP_VS_SPREAD_FTMO_2026-09-20.md` §5.1);
- **40 × 1,80 = 72,0 punti indice = `7200` punti MT5** (`Point = 0,01`, verificato
  identico su BCM e FTMO, stesso referto §2);
- costo misurato: **4,1%** dei giorni 2026, **10,3%** della finestra di backtest —
  e sono **solo** giorni in cui lo stop sta *sotto* la frontiera, cioè giorni che
  oggi operiamo **già in perdita di costo per costruzione**.

| spread usato | pavimento | giorni 2026 scartati |
|---|---:|---:|
| FTMO, tick singolo 1,53 `[n=1]` | 6120 | 2,1% |
| **BCM ora 14, mediana `[n=250M tick]`** | **7200** | **4,1%** |
| BCM ora 14, P95 2,70 | 10800 | 12,4% |

**Scelto il numero solido**, non quello comodo: la mediana su 250 milioni di tick,
non il tick singolo FTMO.

---

## 3. 🛑 IL TETTO RESTA SPENTO, E IL MOTIVO È STRUTTURALE

La ragione della fonte per il tetto è testuale (r.61): *«perché lo stop è troppo
ampio … qua sono 40.000 euro di stop»*.

🔴 **Quella ragione NON vale per noi.** Emiliano opera a **contratti fissi**: stop
più largo = più soldi a rischio. Noi calcoliamo la taglia **dal rischio**
(`InpRiskPercent=2,00`): stop più largo ⇒ **lotto più piccolo** ⇒ **stesso rischio
in EUR**. Il problema che il tetto risolve per lui, da noi **non esiste**.

Resta in piedi **un solo** argomento, e finché non è misurato è un'ipotesi: con un
range largo anche il bersaglio è lontano *in punti assoluti*, e la chiusura di
sessione (19:30 server) può arrivare prima. **Lo misura R196.**

---

## 4. 🧪 I QUATTRO CONTRO-ESEMPI CHE HO COSTRUITO CONTRO ME STESSO

| | ipotesi che avrebbe rotto la misura | esito |
|---|---|---|
| **C1** | *se `up30_pt` non fosse «massimo − apertura», la differenza non sarebbe un'ampiezza* | 🟢 **0** `up30` negativi e **0** `dn30` positivi su 3.899 righe ⇒ è un'ampiezza |
| **C2** | *se le colonne fossero incoerenti, l'ampiezza 30' potrebbe stare sotto la 15'* | 🟢 **0 violazioni** su 3.899 |
| **C3** | *idem per 60' contro 30'* | 🟢 **0 violazioni** |
| **C4** | *il fattore √t che ho usato ieri è quello giusto?* | 🔴 **NO.** Misurato sui nostri dati: raddoppiando il tempo l'ampiezza fa **×1,2441** (15'→30') e **×1,2437** (30'→60'), non **×1,4142**. |

### 🔴 Il C4 è la confessione che conta
L'«opzione 1» di ieri era sbagliata **due volte**, non una:
1. **la base** (17/41) non è trasferibile da 5' a 35' — è l'errore grosso;
2. **l'esponente**: ho usato `0,5` (radice del tempo) dove il nostro mercato
   misura **0,3155**. Da solo valeva «appena» 2 punti su 72 — ma è esattamente
   il tipo di numero che si prende per buono perché *suona* giusto.

👉 **Un'ipotesi vestita da formula resta un'ipotesi.** Il file coi numeri veri era
nel repo da **26/08**, a una `grep` di distanza.

---

## 5. ✅ COSA È CAMBIATO, IN CONCRETO

| file | cambiamento |
|---|---|
| `mql5/Presets/FTMO/..._RETEST_770260_FTMO.set` | `InpMinRangePts` **0.0 → 7200.0** · `InpMaxRangePts` resta **0.0** · +41 righe di commento col perché, la fonte e come si spegne |
| `backtest_pipeline/prove/R196a_pavimento_ampiezza_NASDAQ_NASUSD.txt` | **nuovo** — asse unico `InpMinRangePts`, 2 celle |
| `backtest_pipeline/prove/R196b_tetto_ampiezza_NASDAQ_NASUSD.txt` | **nuovo** — asse unico `InpMaxRangePts`, 5 celle |

Tutti e due: **21 pin**, attesa dichiarata *prima* dei numeri, cella di controllo
obbligatoria, **PC di backtest**. 🟢 Strato 1 del cancello: **OK, 0 problemi.**

### 🔴 E il cancello ha trovato due difetti miei, prima della consegna

**① Due assi `Y` in un file solo.** `controlla_prova.py`: *«un file prova misura UNA
variabile alla volta»*. Spezzato in `R196a` + `R196b`.

**② IL PIÙ CARO — il round avrebbe misurato UN'ALTRA SEDIA.**
`walkforward_generico.ps1` **r.836-843** blinda ogni input al **default del
sorgente**, non al preset schierato; solo il file prova vince (r.845-857). Fra il
preset FTMO `770260` e i default ci sono **21 divergenze vere** — e **tre** sono
velenose perché il preset è scritto in **ora e simboli FTMO** mentre il backtest
gira su **dati BCM**:

| | preset FTMO | nel file prova | perché |
|---|---:|---:|---|
| `InpSessionHour` | 16 | **14** | FTMO = UTC+3, BCM = UTC+1 |
| `InpCloseHour` | 19 | **17** | stesso scarto di 2 ore |
| `InpCorrSymbol` | `US500.cash` | **`SPXUSD`** | stesso indice, altro nome |

👉 Senza questi tre, il round avrebbe aperto il range **alle 16:30 ora BCM** — cioè
**due ore dopo** l'apertura di New York — e cercato un simbolo che su BCM non
esiste. Sarebbe tornato un CSV pieno di numeri, tutti sbagliati.
🟢 **Convenzione di casa confermata**: 72 file prova in archivio hanno già
`InpSessionHour=14||14||0||14||N`.

🔴 **Il preset cambiato NON è ancora in campo**: perché morda va ricaricato sul
terminale **FTMO `541452707`** (`C:\FTMO`). È un'azione a mano dentro MT5, e non
tocca nessun altro terminale.

🟢 **Spia gratis**: quando il filtro morde, il giornale scrive
`candela NNNN pt < min`. **Quei numeri sono la misura vera, giorno per giorno**,
e arrivano da soli nella pagella serale.

---

## 6. 📌 CLASSI DI DIFETTO NUOVE (per `CHECKLIST_RIGA_DI_LANCIO.md`)

- **la banda di una fonte esterna si porta dietro la SCALA su cui è stata
  misurata** (durata della barra, epoca, strumento). Trasferirla senza misurare
  la nostra distribuzione è un interruttore di spegnimento travestito da filtro.
- **il fattore di riscalamento temporale si MISURA sui propri dati.** La radice
  del tempo è un'ipotesi: qui l'esponente vero è **0,3155**, non 0,5.
- **prima di derivare una distribuzione, si cerca il file che ce l'ha già.**
  Qui esisteva dal 26/08.
- 🔴 **un file prova per una sedia FTMO va scritto in ORA E SIMBOLI DEL BROKER SU
  CUI GIRA IL BACKTEST, non del broker su cui opera la sedia.** Il preset è la
  fonte dei valori, **non** delle unità: `InpSessionHour`, `InpCloseHour` e
  `InpCorrSymbol` vanno convertiti. È la prima sedia FTMO che manda un round.
- 🔴 **il driver blinda al default del SORGENTE, non al preset schierato**: ogni
  divergenza preset↔default va pinnata, o il round misura un'altra sedia. Qui
  erano **21**.
