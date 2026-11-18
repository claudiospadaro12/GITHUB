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
