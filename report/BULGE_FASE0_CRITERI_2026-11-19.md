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
