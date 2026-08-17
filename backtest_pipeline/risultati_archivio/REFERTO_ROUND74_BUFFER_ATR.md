# 🔧 R74 — **LA MANOPOLA ORA GIRA ANCHE SUL DOW.** E proprio lì scopre che la legge del drawdown **è solo del forex**.

_Chiude la serie R67→R74. Prima EA nuovo del progetto nato da un difetto
misurato invece che da un'idea._

**Banco:** `ABTG_PTE_Ottimizzato` (magic 771331) · H1 · `SLfromDoji` pinnato a 0 ·
pin della sedia viva (`TP1 0,5 / 50%`) · rischio 1%.
- **GBPUSD e USDJPY**: **tick reali (Modello 4)**, IS `2024.07.05→2025.04.21`, OOS `→2026.06.30`
- **U30USD**: **OHLC (Modello 1)** dal `2024.09.26` — **le stesse identiche condizioni di R69**, perché il confronto *"prima l'asse era morto / adesso?"* dev'essere alla pari

**Igiene: 8 CSV su 8, 14 celle su 14 ciascuno, cancelli verificati negli otto `.ini`.**

---

## 1. ✅ R74-A — L'IGIENE PASSA: **28 CELLE IDENTICHE AL CENTESIMO**

La copia con `InpSLbufferMode = 0` doveva **riprodurre R73, non scoprire niente**.

> ### 🏆 **28 celle su 28 (IS + OOS) identiche a R73 su Profit, PF, DD e Trades. Zero differenze.**

E la cella viva di GBPUSD fa di nuovo **+2.091 · PF 1,38 · DD 3,27% · n=49**:
**terza uscita dello stesso numero** dopo R58 e R73, con tre EA/round diversi.
**La copia è pulita: si può guardare R74-B.**

📌 **Regalo dentro il round**: nella griglia in ATR, la riga `bufATR = 0,00` è
**identica al centesimo** alla riga `buffer = 0 pip` di R73 su entrambi i cambi
(GBPUSD +1.392 DD 4,26 n47 · USDJPY +2.248 DD 5,08 n42). Deve esserlo — a
buffer zero le due formule coincidono — **ed è un secondo controllo gratis.**

## 2. 🎯 DOMANDA 1 (meccanica) — **SUL DOW L'ASSE GIRA. La diagnosi di R69 era giusta.**

| U30USD, stesse condizioni | R69 (buffer in **PIP**) | **R74 (buffer in ATR)** |
|---|---|---|
| trade OOS lungo l'asse | **46, 46, 46 … 46** (28 celle identiche) | **40 · 41 · 42** |
| profitto OOS, escursione | **39 €** (2.945 → 2.906) | **4.055 €** (+2.916 → −1.139) |
| PF OOS | 1,466 → 1,460 | **1,47 → 0,77** |

> ### 🏆 **Da 39 euro di escursione a 4.055. Il difetto era l'UNITÀ DI MISURA, ed è risolto.**
>
> `InpSLbufferPips` è in pip mentre l'ATR è in unità dello strumento: sul Dow
> 30 "pip" valevano **~0,03 ATR** e la manopola non girava. In ATR gira.
> **Il `[INFERITO]` di R69 §3 diventa MISURATO.**

## 3. 🔴 E LÌ, SUBITO, LA SCOPERTA SCOMODA: **sul Dow il drawdown NON scende col buffer**

**DD OOS lungo l'asse, i tre simboli:**

| `bufATR` | 0,00 | 0,25 | 0,50 | 0,75 | 1,00 | 1,25 | 1,50 |
|---:|---:|---:|---:|---:|---:|---:|---:|
| **GBPUSD** | 4,26 | 3,29 | 3,24 | 3,20 | 2,16 | 2,12 | **2,11** |
| **USDJPY** | 5,08 | 4,83 | 4,15 | 3,98 | 3,85 | 3,75 | **3,72** |
| **U30USD** | 2,96 | 2,94 | 2,93 | 2,93 | 2,94 | 2,93 | 2,47 |

- ✅ **GBPUSD e USDJPY: monotone. UNDICESIMA e DODICESIMA conferma**, e su USDJPY la curva **si ricalca su quella in pip di R73** (5,08→3,78 allora, 5,08→3,72 adesso): la riscrittura non ha rotto niente.
- 🔴 **U30USD: PIATTA.** Sei valori dentro **0,03 punti** su un asse che ormai muove il profitto di 4.000 euro. **Non è più un problema di unità: l'asse funziona, e il drawdown non risponde.**

> ## 🎯 **LE DODICI CONFERME ERANO TUTTE SUL FOREX. La prima misura su un INDICE con l'asse funzionante dice NO.**
>
> **"Il buffer governa il drawdown della PTE" va riscritto in: "il buffer
> governa il drawdown della PTE SUL FOREX".** Sul Dow governa il rendimento e
> lascia il drawdown dov'è.
>
> 📌 **E questo si poteva scoprire solo dopo aver aggiustato l'unità.** Il
> difetto di R69 non nascondeva una conferma: nascondeva un **controesempio**.

## 4. 📉 IL RENDIMENTO: **tre simboli, tre direzioni diverse**

**Profitto OOS (colonna TP 2,0):**

| `bufATR` | 0,00 | 0,25 | 0,50 | 0,75 | 1,00 | 1,25 | 1,50 |
|---:|---:|---:|---:|---:|---:|---:|---:|
| **GBPUSD** | 1.392 | 2.128 | 2.165 | 1.272 | 1.652 | **2.214** | 1.781 |
| **USDJPY** | **2.248** | 600 | 1.947 | 1.088 | 333 | −146 | −598 |
| **U30USD** | **2.381** | 1.944 | 779 | −56 | −682 | −1.139 | −460 |

**GBPUSD sale (con rumore), USDJPY e Dow scendono — il Dow fino a cambiare
segno.** Su USDJPY e U30USD **il buffer alto costa, e costa tanto**.

> **Regola B, quinta replica: il rischio si comporta in modo replicabile,
> il rendimento no. E stavolta non si contraddice solo fra finestre: si
> contraddice fra simboli, nello stesso round.**

🔴 **Quindi il risultato di R74 NON è "mettete il buffer alto".** È: **il
parametro adesso funziona ovunque**, e cosa gli si debba far valere **dipende
dallo strumento** — che è precisamente il motivo per cui un valore unico di
famiglia non poteva essere giusto.

## 5. ⏸️ SELEZIONE SOSPESA, e stavolta fa gola

n IS = **24-32** su tutti e tre, contro la soglia di **150**.

Nella griglia ci sono celle che chiamano: `GBPUSD bufATR 1,25` fa **+2.214 con
PF 1,97 e DD 2,12%** — profitto migliore *e* drawdown dimezzato contro la riga
zero. **Non si sceglie.** n=52 non è 150, e la regola non si piega perché il
numero è bello. Materiale per un round con campione vero.

📌 **[INCERTO] dichiarato**: su GBPUSD il DD fa un **gradino** fra 0,75 (3,20) e
1,00 (2,16), più di un punto in una casella. Non so perché e non lo invento.
Serve il per-trade per vedere quale serie di stop smette di essere presa.

## 6. 🚫 QUELLO CHE R74 NON DICE

- **Il Dow è OHLC, 21 mesi, un solo regime, n=28/41**: la domanda **meccanica**
  è risposta (l'asse gira — vale a qualunque n), quella sul **rendimento** no.
  Regola D dell'emendamento.
- **Due banchi diversi** (tick reali sui cambi, OHLC sul Dow): **non si
  confrontano fra loro**, ognuno col suo predecessore.
- **Niente 2020, niente 2022** su nessuno dei tre.
- 🔴 **Nessuna modifica in forward.** R73 ha ritirato la proposta; questa è una
  copia `_Ottimizzato` con magic proprio (771331) che **non sostituisce niente**.

---

## 7. 🚦 VERDETTO

> **1. ✅ La copia è pulita: 28 celle identiche a R73, e il numero di R58 esce per la terza volta.**
>
> **2. 🏆 Sul Dow la manopola ora gira: escursione da 39 € a 4.055 €. Il difetto di unità trovato in R69 era reale ed è risolto.**
>
> **3. 🔴 E proprio lì cade la generalizzazione: sul Dow il drawdown NON risponde al buffer. Le dodici conferme erano tutte forex, e vanno riscritte come tali.**
>
> **4. 📉 Il rendimento va in tre direzioni diverse su tre simboli: un valore unico di famiglia non può esistere. Quinta replica della regola B.**
>
> **5. ⏸️ Selezione sospesa (n 24-32 contro 150) — anche sulla cella che fa PF 1,97 con metà drawdown.**

## 8. ➡️ IL SEGUITO

1. 🔬 **Sonda dello storico su tutti i simboli** (~2 minuti, script già scritto):
   trasforma metà del `CENSIMENTO_REGOLA_FINESTRA.md` da **[STIMA]** a misura.
2. 📥 **Import Dukascopy indici dal 2012** — **sblocca 94 coppie su 155**, ed è
   l'unica strada per dare al Dow un campione da 150 trade.
3. 🔍 **Il gradino di GBPUSD** — per-trade, mezz'ora, chiude l'`[INCERTO]`.
4. 🪑 **La PTE in forward resta com'è.** Otto round su questo motore, una
   proposta fatta e ritirata su misura, e **zero parametri toccati**. È il
   funzionamento corretto dell'imbuto, non un fallimento.
