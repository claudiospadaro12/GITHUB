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
