# Bulge fase 0: il vantaggio dei report di aprile sopravvive al motore corretto? - criteri PRIMA dei numeri (19/11/2026)

**Domanda:** i due Excel di aprile (PF 1,60, +28% a rischio 1%, 5 cross, H1, 2022-2026) vengono da un vantaggio vero o dal difetto R92 (segnale letto sulla barra in formazione, rumore sui simboli non del grafico)?
**Prova:** `ABTG_Bulge_S` (motore corretto, input `Signal_Bar_Offset`), grafico GBPUSD H1, `Symbols_List`=GBPJPY,NZDJPY,AUDUSD,CADJPY,NZDCAD, **2022-01-01 -> 2026-03-30**, 10.000 USD, Modello 1 (barre da 1 minuto; l'Excel aveva 40% tick reali), BCM portabile, solo tester, Guardian spento. Tre passate:
- **A:** `Signal_Bar_Offset=0` (comportamento R92) con i parametri di aprile (ADX spento, kill switch spento, Max_Trades 10, rischio 1%, BLU+VIOLA, ARANCIO spento): serve a vedere se riproduciamo l'Excel.
- **B:** come A ma `Signal_Bar_Offset=1` (barre chiuse, motore corretto): il test vero.
- **C:** offset 1 con i valori standard di `ABTG_Bulge_S` (filtro ADX e kill switch accesi, Max_Trades 4), rischio 1%: il motore come e oggi.

## Previsioni (prima dei numeri)
- A riproduce l'Excel (PF >= 1,3 e 150-400 operazioni): **50%** (modello a barre da 1 minuto, versione del motore possibilmente diversa).
- B con PF >= 1,3 e >= 100 operazioni: **20%**; B con PF < 1,15 oppure < 100 operazioni: **65%**.
- C con PF >= 1,3: **15%**.
- In B e C le operazioni 2022-2023 restano poche (< 30): **60%** (le poche operazioni iniziali dell'Excel sono un fatto di dati/motore, da verificare).

## Regole di esito (invariate dopo i numeri)
1. **Riproduzione (A):** PF >= 1,3 e 150-400 operazioni = riprodotto. Altrimenti "NON riprodotto": la fase 0 e inconcludente sul difetto (modello, versione o parametri diversi) e si dice cosa differisce.
2. **Se A e riprodotto e B ha PF >= 1,3, >= 100 operazioni, nessun anno > 50% del profitto:** il vantaggio sopravvive -> **fase 1 (la sala) ammessa**.
3. **Se A e riprodotto e B ha PF < 1,15 oppure < 100 operazioni:** il vantaggio veniva dal difetto -> **chiuso**, nessuna fase 1 su questo motore.
4. **Zona intermedia** (B PF 1,15-1,30, o PF >= 1,3 con < 100 operazioni): nessuna fase 1; eventuale prova a tick reali prima di decidere.
5. Si riportano per ogni passata: operazioni, PF, rendimento, DD equity, rendimento per anno. Nessun consiglio su taglie. Il demo reale (699 operazioni, PF 0,76) resta il confronto fuori campione.

---
## RISULTATO (19/11/2026, zip BULGE_FASE0; dati in `BULGE_FASE0_dati/`) - cestino GBPJPY/NZDJPY/AUDUSD/CADJPY/NZDCAD, GBPUSD H1, 2022-01-01 -> 2026-03-30, 10.000 USD, Modello 1
| Passata | Operazioni | PF tester | Rend. | DD equity | Rendimento per anno |
|---|---|---|---|---|---|
| **A** offset 0 (R92), parametri di aprile | **21** | 2,37 | +4,28% | 1,64% | 2024 -0,58; 2025 +2,21; 2026 +2,60 (nessuna operazione nel 2022-2023) |
| **B** offset 1 (corretto), parametri di aprile | **3.215** | **0,83** | **-67,5%** | **71,4%** | 2022 -26,8; 2023 -11,7; 2024 -50,1; 2025 -16,9; 2026 -2,8 |
| **C** offset 1, valori standard di Bulge_S | **2.317** | **0,83** | **-54,1%** | **59,6%** | 2022 -22,6; 2023 -6,8; 2024 -30,4; 2025 -11,8; 2026 -3,4 |

1. **Regola 1: A NON riprodotto** (21 operazioni contro 268 dell'Excel; PF 2,37 ma il campione e minuscolo). Quindi la fase 0 e **inconcludente sull'ipotesi "l'Excel veniva dal difetto R92"**: non sappiamo da che motore/versione venisse l'Excel (non e ne il nostro offset 0 ne il corretto).
2. **B e C: nessun vantaggio.** PF 0,83 su 2.300-3.200 operazioni (campione enorme), **0 anni positivi su 5**, DD equity 60-71% a rischio 1%. Previsione B PF<1,15 (65%): confermata; C PF>=1,3 (15%): no. Previsione "poche operazioni nel 2022-23 in B e C" (60%): **sbagliata** per B e C (circa 250 giorni con uscite l'anno, tutti gli anni); le poche operazioni iniziali sono tipiche della passata A (offset 0): coerente con la nota R92 (con offset 0 mancano i segnali).
3. **Esito:** **fase 1 NON ammessa** (B < 1,15). Il motore corretto, sullo stesso cestino e periodo, perde in ogni anno e coincide col demo reale (PF 0,76 in EUR, 699 operazioni). Il PF 1,60 dei report di aprile non e riproducibile con nessuna variante del nostro motore e non si usa come base per un EA.
4. Caveat: Modello 1 (barre da 1 minuto, spread dal feed) con target di pochi pip puo penalizzare piu del tick reale; non cambia il segno (circa 3.000 operazioni, tutti gli anni negativi).

---
## FASE 0b (19/11/2026): il sorgente dell'EA degli Excel di aprile ESISTE - `BULGE_MASTER.mq5` v4.00 - criteri PRIMA dei numeri
Trovato nella storia git (commit `096e9373`, copiato invariato in `mql5/Experts/BULGE_MASTER.mq5`): consolida le 8 versioni del "BULGE MULTI SIGNAL", ha gli stessi nomi di input dell'Excel (`Magic_Number`, `EA_Comment`, `Symbols_List`, `Risk_Percent`, `Max_Trades`, `Use_Blue`...), legge i segnali BLU e VIOLA sulla **barra 0** (difetto R92) e dichiara nell'intestazione: "backtest precedente PF 2,82 / WR 87% / 85 trade / 40% qualita dati: forti sospetti di overfitting". **Non serve "sbobinare" l'Excel per ricostruire le regole: il codice c'e.** Basta rifare la prova con i parametri dell'Excel.
**Prova (3 passate, GBPUSD H1, `Symbols_List`=GBPJPY,NZDJPY,AUDUSD,CADJPY,NZDCAD, 2022-01-01 -> 2026-03-30, 10.000 USD):** **A** Master con i parametri di aprile (ADX, kill switch, news e parziale spenti, Max_Trades 10, rischio 1%, BLU+VIOLA) Modello 1; **B** Master con i valori standard (rischio 1%) Modello 1; **C** come A a **tick reali** (Modello 4, come l'Excel: 40% tick reali).
**Previsioni:** A riproduce l'Excel (150-400 operazioni e PF >= 1,3): **60%**; B: operazioni < 268 e PF tra 1,1 e 1,8: **45%**; C entro +-15% sulle operazioni e +-0,3 sul PF rispetto all'Excel (268, PF 1,60): **50%**.
**Regole:** (1) se A o C riproducono -> **l'Excel e il motore a barra 0 di BULGE_MASTER**; insieme alla fase 0 (motore corretto: PF 0,83, 2.300-3.200 operazioni, 0 anni su 5) la curva dell'Excel e un effetto della lettura della barra in formazione: **nessun EA da ricreare, fase 1 non ammessa, chiuso**. (2) Se non riproducono (A e C fuori dalle soglie): l'Excel viene da un'altra versione non recuperabile; la fase 0 resta valida per il motore corretto; **non si spende altro sul tentativo di ricostruirlo**. Nessun agente programmatore in questa fase.

---
## RISULTATO FASE 0b (19/11/2026, zip BULGE_MASTER_FASE0B; dati in `BULGE_FASE0B_dati/`)
| Passata | Operazioni | PF | Rend. | DD equity | Note |
|---|---|---|---|---|---|
| **A** Master, parametri di aprile, Modello 1 | **21** | 2,37 | +4,28% | 1,64% | nessuna operazione nel 2022-2023 (3 giorni con uscite nel 2024, 15 nel 2025, 2 nel 2026) |
| **B** Master, valori standard, Modello 1 | **19** | 3,50 | +5,23% | 1,34% | |
| **C** Master, parametri di aprile, **tick reali (Modello 4)** | **0** | - | - | - | **non eseguita**: storico "n/a", 0 barre e 0 tick nel terminale portabile (i tick reali di GBPUSD e degli altri 4 cross non sono disponibili li) |
1. **A di BULGE_MASTER e IDENTICA alla passata A della fase 0** (21 operazioni, PF 2,37, +4,28%, DD 1,64%): `BULGE_MASTER` e `ABTG_Bulge_S` con `Signal_Bar_Offset=0` sono lo stesso motore. Il difetto R92 e dimostrato dall'identita dei numeri.
2. **L'Excel (268 operazioni, PF 1,60, 40% tick reali) NON e riprodotto con barre da 1 minuto** (21 operazioni contro 268). **C non e eseguibile** sul terminale portabile (nessun tick reale). Quindi la riproduzione esatta e **inconcludente sul punto dei tick**; ma il fatto che lo stesso motore dia 21 operazioni con le barre e 268 nell'Excel indica che **il numero dei segnali dipende dal modello dei tick**: coerente con la nota R92 (la barra 0 dei simboli non del grafico "ha gia un corpo" a seconda del momento del tick).
3. **Esito:** nessuna fase 1 (regola della fase 0: il motore corretto perde, PF 0,83 su 2.300-3.200 operazioni; la curva dell'Excel non e una base solida: dipende dalla sequenza dei tick e dal difetto della barra in formazione). Previsioni: A riproduce (60%): **no**; B (45%): no; C (50%): non valutabile. Non si spende altro sul tentativo di ricostruirla (regola 2 della fase 0b; C e un'impossibilita tecnica, non un risultato).
4. Se un giorno servisse la prova a tick reali: va fatta sul terminale principale BCM dove sono scaricati i tick (con MT5 chiuso, sola lettura), non su quello portabile.
