# Bulge_S: ingresso del Blu al segnale S, su tutti i 22 cross — criteri e previsioni scritti PRIMA dei numeri (18/11/2026)
Richiesta di Claudio: "entrare al segnale" e "testiamolo con tutti i simboli". Solo tester (BCM portabile, Modello 1), nessun ordine, nessun giudizio su lotti/taglie. Origine dell'ipotesi: replica Python su EURUSD H1 2014-2020 (`BULGE_ANATOMIA_2026-11-18.md`: Blu entrando subito dopo S, senza conferma C: R +0,20 contro +0,03; 174 operazioni contro 148). **Esplorativa, guardata su quei dati**: per questo il test usa anni **fuori** da quella replica e tutti i cross.
## Cosa si prova
- **Copia di prova `ABTG_Bulge_S.mq5`** (l'originale non si tocca): unica differenza = input `Blu_Entry_Mode` (0 = identico all'originale: il Blu entra dopo la conferma C; 1 = il Blu entra all'apertura subito dopo la chiusura di S, senza C; stesse condizioni di S, stessi filtri ATR/ADX, SL 3 ATR, TP = mediana dell'ultima barra chiusa). Il Viola resta spento (`Use_Purple=false`) per isolare il Blu. Nel tester `InpUsaGuardian=false`, `InpVerbose=false`, `InpAutoTest=false`; tutto il resto = default (rischio 0,8%, deposito 10.000 EUR).
- **Varianti (2):** `BLUC` = Blu con conferma (Blu_Entry_Mode 0), `BLUS` = Blu al segnale S (Blu_Entry_Mode 1).
- **Simboli:** tutti i 22 cross del paniere di Bulge, UNO alla volta (`Symbols_List` = quel cross): EURUSD, GBPUSD, AUDUSD, NZDUSD, USDCAD, USDCHF, USDJPY, EURGBP, EURNZD, GBPJPY, GBPAUD, GBPCAD, GBPNZD, AUDJPY, AUDCAD, AUDNZD, NZDJPY, NZDCAD, NZDCHF, CADJPY, CADCHF, CHFJPY.
- **Anni:** 2022, 2023, 2024, 2025 (interi, H1), tutti fuori dalla replica (2014-11/2020-12). 2 x 22 x 4 = **176 passate**.
## Come si decide (regole scritte ora, nessuna ritoccata)
Si sommano i 22 cross e i 4 anni: PF aggregato (somma vincite lorde / somma perdite lorde dei report), operazioni, PF per anno, numero di cross con PF > 1.
- **MIGLIORA:** (a) PF(BLUS) >= PF(BLUC) + 0,15; (b) PF(BLUS) > 1,00; (c) PF(BLUS) > PF(BLUC) in almeno 3 anni su 4; (d) PF(BLUS) > 1,00 in almeno 12 cross su 22; (e) operazioni(BLUS) >= 80% di BLUC.
- **MIGLIORA MA RESTA SOTTO 1:** (a), (c), (e) vere ma PF(BLUS) <= 1,00 o meno di 12 cross > 1.
- **NON MIGLIORA:** tutto il resto. Nessuna scelta dei cross o degli anni a posteriori; nessuna variante aggiuntiva dentro questo round.
- **Riferimento onesto:** il Bulge completo (Blu+Viola) ha PF 0,77 nel tester su 6 cross (round Bulge_TS): se anche BLUC e sotto 1,00, il Blu da solo non regge nemmeno oggi.
## Previsioni
- BLUC PF aggregato < 1,00: **60%**. BLUS PF aggregato > BLUC: **70%**; BLUS >= BLUC + 0,15: **45%**; BLUS > 1,00: **30%**; BLUS > 1,00 in almeno 12 cross: **25%.
- Operazioni BLUS > BLUC: **85%** (nella replica +18%).
- Verdetto MIGLIORA: **20%**; MIGLIORA MA SOTTO 1: **28%**; NON MIGLIORA: **52%**.
## Limiti da dichiarare
Barre da 1 minuto (non tick), un percorso per anno, Guardian/kill switch/ADX/ATR come da default, Viola spento (non e il Bulge completo), spread e commissioni del tester; il costo reale dei cross esotici (GBPNZD, EURNZD) e piu alto; nessun fuori campione oltre ai 4 anni; i 22 cross sono correlati (non 22 prove indipendenti).

## Aggiunta del 18/11 (prima dei numeri): i cross piu volatili sono piu adatti?
Domanda di Claudio. Ipotesi H-vol, **secondaria, non cambia le regole di sopra**: nei 22 cross il PF di BLUS cresce con il rapporto ATR(14) H1 / spread medio (il costo pesa meno sullo stop a 3 ATR). Misura: correlazione di rango di Spearman fra PF(cross, 4 anni sommati) e ATR/spread per cross, con ATR e spread medi 2022-2025 del BCM (da misurare con uno script a parte: oggi non li abbiamo). **Confermata** se rho >= 0,40 per BLUS **e** per BLUC; **non confermata** altrimenti. Previsione: rho >= 0,40 per entrambi **35%**. Controllo secondario: rho fra PF e solo ATR in pip (volatilita pura): >= 0,40 **25%**. Dati gia visti (Bulge_TS, 6 cross, V0): GBPUSD 0,94, GBPJPY 0,84, AUDUSD 0,81, NZDJPY 0,76, NZDCAD 0,70, CADJPY 0,60: i cross JPY, i piu volatili, non sono migliori. Sul demo la classifica per cross ha rho 0,28 fra periodi: in gran parte rumore.

## Risultato (18/11/2026; 176 passate su 176 OK; `BULGE_S_dati/RISULTATI_BULGE_S.csv`; PF aggregato = somma vincite lorde / somma perdite lorde dei report; 22 cross x 2022-2025)
| Variante | Operazioni | Netto EUR | Netto/operazione | PF aggr. | PF per anno 2022/2023/2024/2025 | Cross con PF > 1 |
|---|---|---|---|---|---|---|
| BLUC (Blu con conferma) | 1.620 | -3.160 | -1,95 | **0,851** | 0,84 / 0,85 / 0,83 / 0,88 | 8 su 22 |
| **BLUS (Blu al segnale S)** | 3.465 | -4.412 | -1,27 | **0,926** | 0,92 / 0,86 / 0,90 / **1,03** | 7 su 22 |
**Verdetto con le regole scritte: NON MIGLIORA.** (a) PF(BLUS) >= PF(BLUC) + 0,15: **no** (+0,075; serviva >= 1,00); (b) PF(BLUS) > 1,00: **no** (0,926); (c) meglio di BLUC in 3 anni su 4: **si** (4 su 4, ma 2023 solo 0,86 contro 0,85); (d) PF > 1 in almeno 12 cross: **no** (7); (e) operazioni >= 80% di BLUC: si (214%). Previsioni: BLUC < 1,00 (60%) -> si; BLUS > BLUC (70%) -> si; BLUS >= BLUC + 0,15 (45%) -> no; BLUS > 1,00 (30%) -> no; BLUS > 1 in >= 12 cross (25%) -> no; operazioni BLUS > BLUC (85%) -> si; verdetto NON MIGLIORA (52%) -> si.
**Lettura onesta:** entrare al segnale S **migliora in modo costante ma piccolo** (+0,075 di PF, 4 anni su 4, perdita media per operazione da -1,95 a -1,27 EUR), raddoppia le operazioni, **ma resta sotto 1** e il solo anno sopra 1 e il 2025 (1,03). **La replica su EURUSD (R +0,20) non si e confermata nel tester**: su EURUSD 2022-25 BLUS 1,12 contro BLUC 1,28 (peggiore, 157 contro 69 operazioni). I cross migliori cambiano fra le due varianti (Spearman 0,54): AUDUSD, USDCAD, NZDJPY, GBPUSD sopra 1,2 con BLUS; EURGBP e USDCHF crollano (da 1,26/1,18 a 0,83/0,69): con 60-180 operazioni per cross e 4 anni e in gran parte rumore. Il Blu da solo (0,85-0,93) e meglio del Bulge completo (V0 0,77 su 6 cross): il Viola e il segnale peggiore.
**Cosa non e stato testato:** costi reali di commissione e slippage (il tester ha solo lo spread), l'ipotesi volatilita (serve `VOLSPREAD_BCM`, non ancora girato), i segnali "perfetti" di Leonardo.
