# 🏆 STORICO INDICI — **SCARICATO. 11,6 MILIONI DI BARRE M1.**

**Corsa del 10/09/2026, 13:56 → 14:06 (VPS).** Pin `52a7a838`, driver **v2
chirurgico**, python **embeddable** via `-PathPython`. **ESITO: OK.**
Referto e log: `backtest_pipeline/risultati_archivio/STORICO_INDICI_20260910_1356/`

---

## 📊 COSA E' ARRIVATO

| simbolo | anni | **barre M1** | primo dato | ultimo dato |
|---|---|---:|---|---|
| **NASUSD** (Nasdaq 100) | **17 su 17** | **5.261.984** | 2010.11.14 18:01 | 2026.08.31 23:58 |
| **SPXUSD** (S&P 500) | **17 su 17** | **4.627.209** | 2010.11.14 18:00 | 2026.08.31 23:58 |
| **D30EUR** (DAX 40) | **9 su 9** | **1.718.805** | 2010.11.15 02:00 | 2018.12.28 16:13 |
| | | **11.607.998** | | |

🎯 **La D-H ha funzionato alla lettera.** Il referto lo dichiara da solo:
> *"F5: D30EUR gira su **2010-2018** invece di 2010-2026 (D-H D30EUR)."*

E la firma ha **stretto**, non allargato: nove anni puliti invece di diciassette
di cui quattro con dentro un altro strumento.

## ✅ E i prezzi sono quelli veri — controprova indipendente
| | dato nostro | realta' |
|---|---|---|
| DAX, ultima barra 28/12/2018 | **10.566,51** | il DAX chiuse il 2018 a **~10.559** ✅ |
| DAX, prima barra 15/11/2010 | **6.709,00** | novembre 2010: DAX ~**6.700-6.750** ✅ |
| Nasdaq 100, 14/11/2010 | **2.135,00** | novembre 2010: NDX ~**2.130** ✅ |
| S&P 500, 14/11/2010 | **1.195,50** | novembre 2010: SPX ~**1.199** ✅ |

👉 Non e' un file con dentro "qualcosa": **e' il DAX, il Nasdaq e l'S&P veri.**

## ⚡ E ha girato in **10 minuti**, non in 3 ore
Perche' gli zip erano **gia' in cache** dalle diagnosi di stanotte: lo strumento
non ha riscaricato niente e ha solo riconvertito. La stima di 2-3 ore era sul
caso peggiore (cache vuota) ed e' stata dichiarata prima: **meglio cosi', ma va
detto che il merito e' della cache, non della velocita'.**

## 🔧 Tutti i passi verdi
- **F4 python**: `C:\python313\python.exe` **(parametro esplicito -PathPython)** →
  il pacchetto embeddable **ha funzionato**, dopo che l'installer era stato
  vietato dalla policy;
- **F4 canarino di ritmo**: **VERDE**, 0,2 ore proiettate contro una soglia di 20;
- **F1**: **8 decisioni lette al pin, 0 da firmare** (D-A → D-H tutte `FIRMATO`);
- conversione **a tranche** dichiarata nel referto (RAM: ~690 byte per barra M1
  misurati; 5,6 M barre in un colpo solo sarebbero ~3,8 GB).

## 📌 Due precisazioni oneste sui numeri
1. **"17 anni" e' 2010.11 → 2026.08**: il 2010 e' **parziale** (HistData sugli
   indici parte a meta' novembre) e manca **settembre 2026**, il mese in corso.
2. **U30USD (Dow) e 225JPY (Nikkei) NON sono stati scaricati**, ed e' dichiarato:
   HistData **non ha il Dow** (Dukascopy si', dal 2012, ma costa **~12,7 giorni
   di crawl**), e il Nikkei non era in D-B per questo giro.
   🔴 E il Dow e' proprio **il simbolo del motore principale** dei nostri round
   sugli indici (`SupRev DOW`, `EMA200 Dow`, `ORB U30USD`).

---

# 🔴 MA I DATI **NON SONO ANCORA USABILI**, e il referto lo dice da solo

> *"IL CANCELLO ZERO SUGLI INDICI `_EXT` E' ANCORA CHIUSO. diff media H1 misurata
> **0,061-0,101%** contro il **<=0,05%** richiesto. Questi dati si PRODUCONO e si
> MISURANO; **NON sono autorizzati per i round**."*

Cioe': lo storico **c'e'**, ma il permesso di usarlo e' **un'altra firma**.

## 🚨 E LA SCOPERTA DI OGGI: **sul DAX quel cancello non e' nemmeno MISURABILE**

Il cancello ZERO si misura confrontando il dato esterno con il **nativo BCM**
sullo stesso periodo. Ma:

| | copertura |
|---|---|
| il nostro **D30EUR esterno** | 2010.11 → **2018.12** |
| il **D30EUR nativo BCM** | **2024.09.26** → oggi |

> ## 🕳️ **ZERO SOVRAPPOSIZIONE. Non c'e' un solo giorno in comune.**
> Sul DAX il cancello ZERO **non e' chiuso: e' inapplicabile**. E questo va detto,
> perche' e' molto diverso — un cancello chiuso si apre con una misura migliore,
> uno inapplicabile non si apre affatto finche' non cambia il dato.

### 🟢 LA VIA D'USCITA C'E', ed e' gia' misurata
La diagnosi del 10/09 (`DAX_13_ANNI_2026-09-10.md`) aveva classificato gli anni
del DAX in tre gruppi, **e la previsione aveva centrato tutti e tre**:

| stato | anni | perche' |
|---|---|---|
| 🟢 **SANO** | 2010-2018 | quelli che abbiamo scaricato oggi |
| 🟡 **RIPARABILE** | **2019 · 2024 · 2025 · 2026** | *"0 fuori banda, prezzi giusti — solo **un'altra convenzione oraria**"* |
| 🔴 **MARCIO** | 2020-2023 | contengono **un altro strumento** |

👉 **Riparare la convenzione oraria del 2024-2026 e' la mossa che sblocca tutto**:
darebbe la **sovrapposizione con BCM** (che parte dal 26/09/2024) e permetterebbe
di **misurare il cancello ZERO sul DAX per la prima volta**. Senza quello, i nove
anni restano un bell'archivio inutilizzabile.

---

# 🎯 COSA PROPONGO, in ordine

| # | cosa | perche' | costo |
|---|---|---|---|
| **1** | 🔧 **Riparare la convenzione oraria del DAX 2024-2026** e riscaricare quegli anni | e' **l'unico modo** di rendere misurabile il cancello ZERO sul DAX. Senza, i 9 anni non si possono usare | una corsa, dati gia' diagnosticati |
| **2** | 📏 **Misurare la diff D30EUR_EXT contro il nativo BCM** sulla sovrapposizione nuova | e' **il cancello**: sotto lo 0,05% si apre, sopra si sa di quanto e perche' | una corsa |
| **3** | 🏛️ **Import in MT5** (`RIGA 2`) sul terminale da backtest **50504400** | serve comunque per creare i simboli `_EXT`, **ma** il terminale oggi era **spento** e la riga **non ha ancora il PASS del cancello** | da preparare |
| **4** | 🐂 **Il Dow (U30USD)**: decidere se vale i ~12,7 giorni di crawl Dukascopy | e' il simbolo del nostro motore principale sugli indici. Senza storico lungo, quei round restano su 21 mesi | decisione di Claudio |

## ⚠️ E la cosa che NON cambia
Il D-C resta firmato: i simboli `_EXT` sono **PROVA DI REGIME a parametri
CONGELATI**. Anche quando il cancello si aprira', **li' non si tara niente e non
si promuove nessuna cella.**
