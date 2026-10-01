# Free Trial FTMO 160K (conto 1514806751) - analisi del giorno 1, dal report MT5 delle 16:45 server
Fonte: `data/statements/ReportHistory_trial_1514806751_2026-10-01.xlsx` (mandato da Claudio). Ore = server FTMO (IT+1). Non e' un backtest: nessun PF e' un criterio di merito (n=5).

## 1. Il giorno in numeri [MISURATO dal report]
- 5 posizioni chiuse + 1 aperta. Netto chiuso **-6.245,68** (lordo -6.152,23, commissioni -93,45). Bilancio 153.754,32; equity 153.977,04 (aperta GBPNZD A +222,72).
- Vinte 2/5, PF 0,20 (n=5, rumore), perdita massima -3.292,52, **drawdown di bilancio 4,27% (6.825,16)** al minimo delle 13:36 (bilancio 153.174,84).
- Per sedia: **DAX 770411 -3.292,52 | DAX Apertura EU RETEST SELL -3.110,48 | Bulge A (preset FT) NZDCHF -1.389,09 (con commissioni) | Bulge B +990,87 +561,79** (con commissioni). I due DAX valgono **-6.403,00**; tutto il Bulge chiuso fa **+163,57** netto e la GBPNZD A aperta +222,72.
- Stop 3 (due DAX + NZDCHF), TP 2 (le due B). **Allarme "3 stop in un giorno" dei criteri: SCATTATO.**

## 2. DUE istanze Bulge - chiuso [MISURATO]
- A = `BULGE_V520_FT_VIOLA_*` (preset trial): GBPNZD 2,83 lotti, NZDCHF 7,23 lotti, rischio **0,80%** (0,83% su NZDCHF).
- B = `BULGE_VIOLA_*` (commento di default): GBPNZD 4,49 lotti, AUDUSD 7,99 lotti (AUDUSD NON e' nei 15 cross del preset), rischio **1,00%** (0,998% e 0,995%).
- B non ha sparato alle 06:00 (quando A ha fatto GBPNZD e NZDCHF, entrambi nella sua lista se ha i 22): `[NON SI SA]` se B e' stato attaccato dopo le 06:00 o se i suoi filtri (ADX di default acceso) li scartavano. Da leggere: Input di B e Esperti.
- Il TP viene riscritto dopo il fill dall'EA (`ABTG_Bulge.mq5` r.1962, `PositionModify(..., newTP)`): GBPNZD B 2,35466 -> 2,35534, AUDUSD 0,69473 -> 0,69461, A 2,35297 -> 2,35344.

## 3. Rischio simultaneo alle 10:00-10:06 [CALCOLATO da SL e lotti; cambi EUR/NZD 0,4937 e EUR/CHF 1,0665 ricavati dai P/L]
Aperte insieme dalle 10:00:00 alle 10:06:32: DAX 770411 (3.199-3.237) + NZDCHF A (1.326) + GBPNZD A (1.277) + GBPNZD B (1.596) = **~7.400 = 4,62% del conto**.
- Prima dell'ingresso di B il rischio aperto era 3,63% (< cap C1 4,00%): **B e' passato**; con B la somma e' 4,62%. E' esattamente la proprieta' gia' scritta in CLAUDE.md: C1 e' una bandiera sul rischio gia' aperto, non somma il rischio dell'ingresso nuovo. Misurato in campo: **un ingresso da 1% ha portato il rischio aperto sopra il cap**, e con un ingresso da 2% (DAX) il tetto possibile sarebbe ~6%.
- Se tutti e quattro avessero preso lo stop insieme: -7.400 circa = 4,6% (sotto il 5% presunto FTMO, 8.000, regola trial NON misurata). Sono andati a stop due su quattro.

## 4. CORREZIONE a quanto detto in chat alle 11:00
Avevo scritto che i due short DAX valevano "quasi 4% di rischio correlato" e che il tetto per cluster non acceso "l'ha pagata il conto". **Falso**: i due DAX NON sono mai stati aperti insieme (770411 chiuso 10:06:32, 770105 aperto 11:13:13). Un tetto sul rischio APERTO (C1 o C2) non li avrebbe fermati. Il 4,0% e' perdita **sequenziale** nello stesso giorno sullo stesso indice. Cio' che avrebbe agito e' una regola diversa (tetto di perdita giornaliera per sottostante, o "dopo uno stop DAX niente secondo DAX"): **parametro di rischio = scelta di Claudio**, non proposta mia.

## 5. DAX [MISURATO]
- 770411 `MAXMIN DAX SHORT SELL`: sell stop 24.999,04 piazzato 09:59:00, fill 09:59:01 a 24.998,25 (**0,79 punti a favore**), SL 25.066,00 (67 punti), TP 24.731,20 (267 punti, 4:1). Lotto 47,78 = 2,00% del bilancio. Stop alle 10:06:32 a 25.067,16 (**slippage 1,16 punti = 55 EUR**).
- `DAX Apertura EU RETEST SELL` (770105 SHORT `[INFERITO dal commento SELL]`): sell limit 24.835,04 piazzato 11:11:50, fill 11:13:13 a 24.834,96, SL 25.092,04 (257 punti), TP 24.064,04 (771 punti, 3:1). Lotto 12,08 = 2,00% di 155.302. Stop 13:36:02 a 25.092,45 (slippage 0,41 punti = 5 EUR).
- Il primo DAX entra un minuto prima dell'apertura cash (10:00 server) con stop di 67 punti, dentro il rumore dell'apertura. Quanto spesso succede nel backtest del 770411 `[NON MISURATO]`.

## 6. Esecuzione e costi [MISURATO]
- Slippage di uscita: DAX 1,16 e 0,41 punti; NZDCHF SL 0,46869 -> 0,46865 (0,4 pip, ~31 EUR); TP: GBPNZD 0,4 pip, AUDUSD 0,1 pip. Entrate: tutte entro 0,8 punti. **Esecuzione ottima: i costi del giorno sono il rischio, non lo slippage.**
- **Commissioni**: forex 2,21 EUR/lotto/lato (GBPNZD 9,95 su 4,49; AUDUSD 17,69 su 7,99; NZDCHF 15,96 su 7,23 = 2,21); **indici 0**. Totale giorno 93,45.
- **Cancello costo sul Bulge**: NZDCHF A ha TP 2,9 pip contro SL 17,2: payoff 1:6, **break-even 86% di vittorie** (senza costi); TP lordo ~231 EUR contro 31,95 di commissioni = **14%**, piu' lo spread (`NON MISURATO`). AUDUSD B: TP 9,6 -> 8,4 pip contro SL 22 pip (break-even ~72%), commissioni 5,9% del lordo.

## 7. Guardian e margini [DEDOTTO, righe del Guardian NON ancora lette]
Pausa 3,5% (5.600), emergenza 4,5% (7.200), perdita totale 9,3%; reset giornaliero ore 1 server. Al minimo (13:36) il bilancio era a 4,27% di perdita (**375 EUR dall'emergenza**); ora equity 153.977 = -3,76% (**1.177 EUR dall'emergenza**, ~2.000 dal 5% presunto). **Pausa superata dalle 13:36**: nessun nuovo ingresso dalle 13:42 a oggi pomeriggio, coerente con la pausa ma `NON PROVATO` finche' non si leggono le righe del Guardian in Esperti.

## 8. Da leggere stasera (Claudio, terminale 1514806751 `C:\FTMO`)
1. Esperti: righe `GUARDIAN ...` (pausa/emergenza) e `[BULGE] Init OK` (una per istanza).
2. Input di A e B: InpMagic, InpComment, Risk_Percent, Max_Trades, Use_Blue, Use_ADX_Filter, Symbols_List.
3. Quando e' stato attaccato B.

## 9. Esperti del terminale 1514806751, foto delle 22:23 server (PC 21:23) [LETTO dallo screenshot]
- **Guardian vivo e in PAUSA**: `eq=154184.36 dayLoss=3.63% totDD=3.63% rischioAperto=0.00% stato=OK pausa=ON cap=off`, ogni 5 min dalle 20:00 (ora PC) almeno. `dayLoss` = (160.000 - 154.184,36)/160.000 = 3,635%: la base e' 160.000 (`InpStartBalance` corretto). Pausa 3,5% superata. `cap=off` = rischio aperto sotto il tetto (r.887-890 di `ABTG_Guardian.mq5`: capOn=false), NON "cap spento".
- **ORB Ottimizzato** (US30): `INGRESSO BLOCCATO -- PAUSA GIORNALIERA del Guardian (firma B1). La posizione eventualmente gia' aperta NON viene toccata.` -> il blocco e' provato per l'ORB; il Bulge nei log mostrati non ha ingressi in questa finestra. Spiega "adesso si apre un trade alla volta / niente di nuovo": e' la pausa, non un difetto.
- Equity = bilancio 154.184,36: la GBPNZD A e' chiusa (da 153.754 sono +430). Il reset giornaliero e' alle 01:00 server (= mezzanotte italiana; preset `InpDailyResetHour=1`): da allora `dayLoss` riparte da zero e le sedie riprendono. `[NON LETTO]` se alla ripartenza il Guardian conta sul giorno nuovo con base 160.000 o con il bilancio di fine giorno: da leggere domattina nelle prime righe.
- **Seconda istanza Bulge = DEFAULT, provato dal log**: `[BULGE] ADX FILTER | GBPJPY | BLU bloccato | ADX=33.81 >= soglia=30.00` (e AUDJPY, NZDJPY, EURUSD 65,24, EURGBP 53,06) alle 21:00 PC, sorgente `ABTG_Bulge (NZDCHF,H1)`. Il preset trial ha `Use_Blue=false` e ADX spento, e **non contiene GBPJPY ne' EURUSD**: quella istanza ha Blu acceso, ADX 30 acceso e la lista larga. Il grafico NZDCHF,H1 ha la scritta `ABTG_Bulge` in alto. Le altre schede aperte includono NZDUSD,H1 (primo cross del preset): `[INFERITO]` che li' ci sia A. Mancano gli Input.
- Il filtro ADX di B blocca solo il Blu (testo `BLU bloccato`): B poteva e puo' entrare sui Viola di tutti i 22 cross.

## 10. Input della seconda istanza Bulge, foto 21:24 PC (22:24 server) [LETTO]
Finestra `ABTG_Bulge 5.20 (NZDCHF,H1)`: **Use_Orange=false, Use_Blue=TRUE, Use_Purple=true**, filtro ATR true (0,5-1,8), **filtro ADX TRUE soglia 30 (solo Blu)**, news false, parziale/BE/trailing spenti, kill switch 4 SL totali / 3 consecutivi / -2,0% balance, **Risk_Mode rischio fisso, Risk_Percent 1,0, Total_Risk_Percent 2,0 (inerte), Max_Trades 3**, `InpMagic=772700`, `InpComment=BULGE`, **Basket 22 cross** (EURUSD,GBPUSD,AUDUSD,NZDUSD,USDCAD,USDCHF,USDJPY,EURGBP,EURNZD,GBPJPY,GBPAUD,GBPCAD,GBPNZD,AUDJPY,AUDCAD,AUDNZD,NZDJPY,NZDCAD,NZDCHF,CAD...), Guardian true.
- = **default dell'EA, con solo Risk_Percent 1,0 e Max_Trades 3 digitati a mano** (i numeri che Claudio aveva scelto). Chiamiamola **B**. Cap proprio B = 1,0 x 3 = 3,0%.
- **A** (preset, magic 772720, `BULGE_V520_FT`, Viola, 15 cross, Risk 0,8, Max_Trades 4 -> cap 3,2%) gira su un ALTRO grafico `[Input di A non ancora fotografati]`; la sua taglia in campo e' 0,8% (misurata dai lotti), cioe' il preset senza il ritocco a 1,0/3.
- Tetto di rischio aperto del solo Bulge con le due istanze: 3,2% + 3,0% = **6,2%** (oltre il cap C1 4,00%, che e' una bandiera e non somma l'ingresso nuovo), e A e B possono aprire la STESSA coppia in magic diversi (stesso sottostante, due posizioni).
- B ha Blu acceso: sul piccolo la versione vecchia (Blu+Viola, 22 cross) ha dato PF 0,86 su 159 posizioni (`report/BULGE_PICCOLO_PER_CROSS_2026-10-01.md`); i Viola di B oggi: GBPNZD +1.010,74 e AUDUSD +597,17 (n=2).
- Momento: **tutto piatto** (rischioAperto 0,00%) e Guardian in pausa fino all'01:00 server: staccare B ora non tocca nessuna posizione.
