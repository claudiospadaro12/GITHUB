# LA MISURA CHE COSTA DIECI MINUTI: il parziale taglia meta' posizione su chi stava ancora correndo

**22/09/2026** · sola lettura · nessun EA, preset o forward toccato
Fonte unica: `backtest_pipeline/risultati_archivio/studio_apertura/Studio_{D30EUR,U30USD,NASUSD}.csv`
(440 / 446 / 447 rotture vere, colonne `risultato_R`, `MFE_R`, `barre`)

> ## IN UNA RIGA
> **Le operazioni vincenti delle aperture durano 160-190 minuti; le perdenti 45-60.** E **di chi
> arriva a 1,0R, piu' della META' prosegue fino a 2,0R.** Il nostro parziale sta **proprio li'**.

---

## 1. LA DURATA -- e l'asimmetria e' enorme

| simbolo | vincenti (mediana) | perdenti (mediana) | rapporto |
|---|---:|---:|---:|
| `D30EUR` | **165 min** | 60 min | **2,8x** |
| `U30USD` | **160 min** | 45 min | **3,6x** |
| `NASUSD` | **190 min** | 45 min | **4,2x** |

**Le perdenti muoiono in fretta da sole.** Quindi qualunque meccanismo che accorci l'operazione
**colpisce quasi solo le vincenti**: le perdenti se ne sono gia' andate.

Conferma esterna, e arriva da un'altra strada: arXiv 2605.04004v3 (Mesfin) misura che l'edge
dell'ORB **matura in 60-75 minuti** -- ORB long bar+1 netto **-0,82 pt**, bar+15 netto **+2,82 pt**
su N=447 OOS. I nostri numeri dicono **la stessa cosa e di piu'**: da noi le vincenti ne chiedono
**tre ore**.

---

## 2. L'MFE -- dove sta il parziale rispetto a dove arriva il prezzo

**Verificato PRIMA di leggerlo: l'MFE NON e' censurato dal TP dello studio.** Massimi osservati
**3,86 / 6,27 / 11,61 R**, cioe' ben oltre il TP a 2R: il dato si vede anche a destra.

| quante operazioni arrivano almeno a | `D30EUR` | `U30USD` | `NASUSD` |
|---|---:|---:|---:|
| 0,25 R | 80,2% | 77,6% | 80,5% |
| **0,50 R** | 68,4% | 66,1% | **65,3%** |
| **1,00 R** | **51,6%** | **47,5%** | 43,8% |
| 1,50 R | 37,0% | 36,5% | 33,3% |
| 2,00 R | 28,6% | 26,7% | 22,6% |

MFE mediano: **1,01 / 0,93 / 0,90 R**.

### E IL NUMERO CHE DECIDE: LA PROSECUZIONE

| | `D30EUR` | `U30USD` | `NASUSD` |
|---|---:|---:|---:|
| di chi arriva a **0,5R**, quanti proseguono a **1,0R** | 75,4% | 71,9% | **67,1%** |
| di chi arriva a **1,0R**, quanti proseguono a **2,0R** | **55,5%** | **56,1%** | 51,5% |

> **Il parziale delle aperture sta a `InpTP1_R = 1,0`** (DAX, Dow) **e `0,5`** (Nasdaq).
> Quindi chiudiamo meta' posizione su operazioni che, **piu' della meta' delle volte, stavano
> ancora correndo**. Sul Nasdaq va peggio: si taglia a 0,5R, e **il 67% di quelle arriva a 1,0R**.

E il Nasdaq e' **la sedia col PF piu' basso della flotta (1,109)**. Non e' una dimostrazione di
causa -- e' una coincidenza che chiede un round.

---

## 3. PERCHE' QUESTO NON E' ANCORA UNA FIRMA

**RISERVA DICHIARATA, classe 551.** Lo studio gira a **range 15'** (noi 35'), **buffer 200** (noi
500 sul DAX), **TP 2,0R fisso** e a **BREAKOUT CIECO, non a RETEST**. Quindi:
- il **VERSO** si trasferisce: l'asimmetria di durata e la prosecuzione sono proprieta' del
  mercato all'apertura, non della nostra geometria;
- i **NUMERI no**. Il 55,5% non e' il nostro 55,5%.

**E la cosa che questo NON misura**: quanto vale il parziale come **riduttore di rischio**.
Chiudere meta' a 1,0R abbassa il DD, e infatti R46 misura **sia** il PF che sale (1,397 -> 1,491)
**sia** il DD che scende (7,23% -> 6,27%). **Questa pagina non dice che il parziale e' sbagliato:
dice dove sta rispetto alla corsa del prezzo.**

**La trappola verificata al sorgente, e vale piu' di tutto il resto**: in
`ABTG_DAX_Apertura_EU.mq5` il breakeven `InpBreakevenAtTP1` e' **annidato dentro il blocco del
parziale** (r.2359 apre, il BE sta dentro), e il breakeven indipendente (r.2404) richiede
`InpBEatR > 0`, che vale **0.0 in tutti e tre i preset FTMO delle aperture**. Spegnere il parziale
**spegne anche il breakeven, in silenzio**. Si misura la COPPIA.

---

## 4. COSA RESTA NON MISURATO, per nome
- La stessa distribuzione **sulla nostra geometria** (35', retest, buffer 500): servirebbe far
  girare `ABTG_Apertura_Study_EA` coi nostri parametri. **Non fatto.**
- **La durata delle NOSTRE operazioni**: i CSV dei round sono **aggregati per passata** e **non
  portano `open_time`/`close_time`**. La durata per operazione **non e' nei dati di casa** -- la
  frase "si legge dai CSV gia' in casa" e' **falsa come detta**, e l'ho verificata prima di usarla.
- Quanto il parziale valga **sul DD**: misurato solo da R46 su una cella.
- `770411`, `771531`, `770511`: questo studio copre **solo le tre aperture**.
