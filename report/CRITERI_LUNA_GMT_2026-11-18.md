# Luna AI (set Luna_4%DD): sensibilita all'orario +-1 ora — criteri e previsioni scritti PRIMA dei numeri (18/11/2026)
Natura: solo tester (BCM, Modello 1, deposito 4.000 EUR, EURUSD M5 come negli altri giri), nessun giudizio su lotti/taglie/acquisti. Origine: revisione Gemini (punto c) e limite "giro C, orari GMT non verificati" del cancello del 09/11.

## Misura
- Set `Luna_4%DD.set` invariato tranne `AutoGMT=false`, `GMT_Offset_Winter` = `GMT_Offset_Summer` = **0** (finestra operativa spostata di +1 ora sul server) e **2** (spostata di -1 ora). Riferimento gia misurato con offset **1** (stesse condizioni).
- Anni 2018, 2022, 2025 -> **6 passate** (2 offset x 3 anni).
- **Riferimenti (offset 1):** 2018 = 786 op, +568 EUR, PF 1,59, DD equity 323 EUR (6,74%); 2022 = 764 op, +975 EUR, PF 2,22, DD 209 EUR (4,9%); 2025 = 790 op, +1.130 EUR, PF 2,96, DD 89 EUR (2,1%).

## Come si legge (regole scritte ora)
- **Nota:** la finestra notturna e il disegno del sistema: spostarla di un'ora cambia i trade per costruzione. Il test dice quanto il risultato dipende dall'ora esatta, non se "l'EA e sbagliato".
- **DIPENDENZA FORTE dall'ora:** in almeno 2 anni su 3, per almeno un offset, netto < 85% del riferimento **o** DD equity > 115% del riferimento (la soglia 15% e quella proposta da Gemini).
- **FRAGILE (verdetto di Luna cambia):** netto <= 0 in almeno 2 anni su 3 per uno stesso offset.
- **ROBUSTO:** nessun anno degrada oltre 15% per nessun offset.
- Il risultato va riportato cosi com'e, senza soglie ritoccate. Resta valido il limite: un anno per passata, Modello 1.

## Previsioni (scritte ora)
- Almeno un offset degrada oltre il 15% in almeno un anno: **85%**.
- DIPENDENZA FORTE (definizione sopra): **60%**. FRAGILE: **25%**. ROBUSTO: **8%**.
- Netto > 0 in tutti e 6 le passate: **55%**.

## Risultato (18/11/2026; 6 passate su 6 OK, BCM, Modello 1, 4.000 EUR; dati in `LUNA_GMT_dati/RISULTATI_LUNA_GMT_2026-11-18.csv`; riferimenti = offset 1)
| Anno | Offset 0 (finestra +1 h): netto / PF / DD equity | Riferimento (offset 1) | Offset 2 (finestra -1 h): netto / PF / DD equity |
|---|---|---|---|
| 2018 | +686 (+21%) / 1,70 / 268 (5,6%) | +568 / 1,59 / 323 (6,7%) | +65 (-89%) / 1,05 / 380 (8,7%) |
| 2022 | +778 (-20%) / 1,59 / 290 (6,5%) | +975 / 2,22 / 209 (4,9%) | +414 (-58%) / 1,32 / 180 (4,5%) |
| 2025 | +192 (-83%) / 1,12 / 357 (8,7%) | +1.130 / 2,96 / 89 (2,1%) | +162 (-86%) / 1,19 / 269 (6,5%) |
**Verdetto (regole sopra, nessuna ritoccata): DIPENDENZA FORTE dall'orario** (offset 2: netto < 85% del riferimento in 3 anni su 3; offset 0: in 2 su 3). **Non FRAGILE** (netto > 0 in tutte e 6, PF 1,05-1,70) e **non ROBUSTO**. Previsioni: >=1 offset degrada oltre 15% (85%) -> si; DIPENDENZA FORTE (60%) -> si; FRAGILE (25%) -> no; ROBUSTO (8%) -> no; netto > 0 in tutte e 6 (55%) -> si.
Lettura: l'orario di riferimento (GMT_Offset 1 = server BCM GMT+1) e il migliore nel 2022 e nel 2025 (nel 2025 PF 2,96 contro 1,12-1,19); nel 2018 +1 h fa meglio (+21%). Luna resta in profitto ma **il suo vantaggio dipende dall'ora esatta**: un offset sbagliato sul conto (o AutoGMT del set, che nel tester non funziona) puo portare il PF da 2-3 a 1,1-1,3. Limite dichiarato per Luna: **verificare l'offset effettivo sul conto in uso**. Un anno per passata, Modello 1.
