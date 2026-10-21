# Goldbot One, sonda 4: step intermedi di LotsizeStep, previsioni scritte PRIMA dei numeri (21/10/2026)

**Non controllata da agenti.** Origine: `GOLDBOT_D1_SONDA3_LETTURA_2026-10-21.md`. Mappa [PROBABILE]: `Risk=9999` = use LotsizeStep. Nella sonda 3 nessuna passata ha superato insieme S-DD (<=10% dal deposito e <=15,2% dal picco) e S-NOSCALA (rapporto lotti <=3, <=10 posizioni): step 2000 = DD 12.304 EUR (15,4% di 80K), rapporto 2,7; step 10000 = DD 1.599 (2,0%), rapporto 6,0 (lotti 0,01-0,06, arrotondamento al minimo). Qui si misura la zona in mezzo. **Non e' una scelta di taglia: e' una misura. Il livello da usare resta di Claudio.**
## Passate (XAUUSD D1, OHLC 1 minuto, 01/01/2025-01/10/2026, 80.000 EUR)
T1-T6: Risk=9999, MaxRiskPerStrategy 6.0, StartLots 0.01, LotPerBalance_step 3000 / 3500 / 4000 / 5000 / 6000 / 7500. Tutti e quattro gli input dei lotti imposti in ogni passata.
## Previsioni (interpolazione log-log fra step 2000 e 10000 della sonda 3: DD con esponente circa -1,27, netto circa -1,17) [DERIVATO]
| step | DD equity attesa EUR (% di 80K) | netto atteso EUR |
|---|---|---|
| 3000 | 7.400 (9,2%) | 25.000 |
| 3500 | 6.000 (7,6%) | 21.000 |
| 4000 | 5.100 (6,4%) | 18.000 |
| 5000 | 3.800 (4,8%) | 13.800 |
| 6000 | 3.000 (3,8%) | 11.000 |
| 7500 | 2.300 (2,9%) | 8.700 |
- **S1** tutti gli input imposti confermati dal report: 90%.
- **S2** il DD cala e il lotto mediano cala al crescere dello step, in modo monotono: 85%.
- **S3** DD equity entro +-40% dei valori in tabella in almeno 4 passate su 6: 60%.
- **S4** DD <= 10% degli 80.000 (8.000 EUR) per gli step da 3500 in su: 70%; a step 3000 (borderline 9,2%): 50%.
- **S5** rapporto lotti max/min <= 3 per step 3000-4000: 55%; sopra 3 da 5000 in su per l'arrotondamento al minimo: 60%.
- **S6** operazioni fra 440 e 470: 75%; ogni passata sotto 10 minuti: 80%.
## Cosa si fa dopo
Soglie invariate (S-DD, S-NOSCALA, S-N >=150, S-M >=60%). DD sempre in % di 80.000 e dal picco. Se uno step passa entrambi i cancelli resta da fare S-CORR/S-PORT con Prop Firm e Gold Reaper; nessuna taglia viene proposta. Limiti: oro in rialzo, un solo regime (vedi `CRITERI_TRE_REGIMI_RIALZO_RIBASSO_LATERALE_2026-10-21.md`).
