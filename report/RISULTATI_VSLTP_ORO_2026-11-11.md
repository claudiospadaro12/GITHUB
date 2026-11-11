# Virtual SL/TP sull'oro: risultati (11/11/2026, sera) — 33 passate

**Natura: MISURA, parziale.** Arrivata solo la riga oro (`RIGA_LANCIA_VSLTP_ORO`, 33 passate: Goldbot Prop L0, Phantom Gradino 1 L1, Reaper Combo L3; Gold Trade Pro non ancora arrivato). Criteri e previsioni scritti prima: `CRITERI_VSLTP_2026-11-10.md`. Riferimento = passate D160 (virtual spento, ritardo 99). 160.000 EUR, Modello 1, 2013 / 2020 / 2025. Solo tester. Script `D160_dati/analisi_vsltp_oro.py`, sintesi `vsltp_oro_sintesi.json`.

## Validita
**Controllo aggiunto la sera dell'11/11 (input del report contro il riferimento D160, tutti gli input):** nelle 33 passate oro gli input sono identici al riferimento tranne i due imposti (`EnableVirtualSLTP`, `SetVSL_to_hardSL_sec_delay`): FridayStopHour 25, `EnableNFP_Filter=true` e ritardo 99 nei bracci V99 sono confermati in tutte (15 V99, 15 V0, 3 C0). **I risultati dell'oro quindi valgono.** (Le 9 passate Gold Trade Pro dello stesso test NON sono valide: vedi `RISULTATI_VSLTP_GTP_INVALIDO_2026-11-11.md`.)

**33/33 passate valide**: stato OK, qualita 99-100%, zero stop out e zero "no money", **input imposti confermati dal report in tutte** (V99: `EnableVirtualSLTP=true`; V0: true e ritardo 0; C0: false e ritardo 0). Riferimento: Reaper L3 2020 con una sola ripetizione (R1 KO nel D160).

## Scostamento dai criteri (dichiarato)
Il giornale del tester arrivato nello zip e un'estratto (testa e coda di ogni giornale): **il giorno piu pieno e i conteggi per tipo (`failed modify`, `Market closed`, `TrailStop error`, breakeven) NON sono misurabili**. Come proxy uso le **righe totali dei giornali di ogni passata** (campo `righe` del referto), confrontate con il riferimento: e una misura piu debole di quella scritta nei criteri. Le soglie (RIDUCE >= 50%, RIDUCE POCO 20-50%, NON RIDUCE < 20%) restano quelle dei criteri.

## Risultati per EA (somma dei 3 anni; Phantom e Reaper: media delle ripetizioni)
| EA | Braccio | Netto 3 anni vs rif. | Righe di giornale vs rif. (2013 / 2020 / 2025) | DD equity: massimo aumento | Peggior giorno: massimo peggioramento | Operazioni | Richieste | Costo |
|---|---|---|---|---|---|---|---|---|
| Goldbot L0 | V99 | 80.751 (+1,0%) | -4,6% (-2 / -4 / -8) | +0,08 pt | 20 EUR | -0,1% | NON RIDUCE | NEUTRO |
| Goldbot L0 | V0 | 82.713 (+3,5%) | **-21,9%** (-14 / -20 / -31) | +0,12 pt | 109 EUR (0,07 pt) | -0,4% | RIDUCE POCO | NEUTRO |
| Goldbot L0 | C0 (controllo) | 79.920 (0,0%) | -0,0% | 0 | 0 | 0 | NON CONTA | - |
| Phantom L1 | V99 | 87.944 (-0,9%) | -7,8% (-5 / -11 / -7) | +0,29 pt | 576 EUR (0,36 pt) | +0,1% | NON RIDUCE | NEUTRO |
| Phantom L1 | V0 | 92.659 (+4,5%) | **-26,4%** (-17 / -28 / -33) | +0,27 pt | 465 EUR (0,29 pt) | -1,2% | RIDUCE POCO | NEUTRO |
| Reaper L3 | V99 | 45.862 (+8,0%) | -0,9% (-1 / 0 / -1) | +0,14 pt | 123 EUR (0,08 pt) | +1,1% | NON RIDUCE | NEUTRO |
| Reaper L3 | V0 | 50.087 (+18,0%) | **-24,3%** (-14 / -37 / -22) | +0,18 pt | 402 EUR (0,25 pt) | +0,6% | RIDUCE POCO | NEUTRO (entro la banda: scarto fra le due ripetizioni V0 11,8%, banda 23,6%) |
Netto di riferimento 3 anni: Goldbot 79.920, Phantom 88.706, Reaper 42.459.

## Verdetti (regole dei criteri)
- **V99** (virtual acceso, ritardo 99): **VIRTUAL DA SCARTARE** per tutti e tre (NON RIDUCE: le righe calano del 1-8%).
- **V0** (virtual acceso, ritardo 0): **DA VALUTARE** per tutti e tre (RIDUCE POCO, 22-26% in meno; costo NEUTRO). Rispetto a V99 riduce di altri 17 punti (Goldbot), 19 (Phantom), 23 (Reaper): MIGLIORE secondo la soglia (>= 20 punti) solo per il Reaper; per gli altri due in mezzo.
- **C0**: a virtual spento il ritardo 0 **non cambia niente** (righe identiche, netto identico): **NON CONTA** (Goldbot; GTP da vedere).
- Il costo e **neutro** su tutti: il netto non cala, il DD sale al massimo di 0,3 punti, il peggior giorno peggiora al massimo di 0,36 punti del conto.

## Previsioni V1-V16 (valutate sull'oro; GTP in attesa)
V1 vera (33/33, input confermati) · V2 Goldbot RIDUCE >= 50%: **falsa** (-4,6% / -21,9%); netto +-10%: **vera** · V3 Phantom RIDUCE: **falsa** (il giorno del 02/06/2025 NON misurabile: giornale parziale) · V4 Reaper RIDUCE: **falsa** · V5 GTP: in attesa · V6 almeno un EA fuori banda: **falsa** (Reaper V0 +18% e dentro la banda 23,6%) · V7 peggior giorno oltre 0,5 punti: **falsa** (massimo 0,36) · V8 nessuno VIRTUAL CONVIENE (20%): **vera finora** (V0 e solo DA VALUTARE) · V9 righe invariate: **falsa** (V0 -22/-26%) · V10 operazioni oltre 10%: **falsa** (massimo 1,2%) · V11 ritardo 0 confermato: **vera** · V12 V0 MIGLIORE in >= 2 EA su 4: **falsa finora** (1 su 3 oro) · V13 Phantom 02/06/2025 sotto 700: **NON MISURABILE** · V14 C0 NON CONTA: **vera** (Goldbot) · V15 V0 peggior giorno oltre 0,5 punti: **falsa** (0,29 massimo) · V16 V0 riduce di piu: **vera** (3/3).

## Cosa si legge, e cosa NO
1. **Solo il ritardo 0 con il virtual acceso riduce le righe (22-26%), mai oltre il 50%**; il virtual con ritardo 99 non serve a ridurle. La riduzione e **modesta** e misurata con un proxy debole (righe totali del giornale del tester, non le richieste di FTMO).
2. **Il costo sul risultato e nullo nel tester**: il netto non cala, anzi sale (+3-18%, dentro il rumore per Phantom e Reaper). Questo NON dimostra un vantaggio.
3. **Non misurato, ma importante**: con ritardo 0 e virtual acceso lo stop reale potrebbe non essere mai impostato sul server (significato non verificato, solo un messaggio di Discord di seconda mano): se si ferma il terminale o il VPS la posizione resta senza protezione; nel tester non si vede. Prima di ogni uso su un conto va letto il manuale di Wim.
4. **Il tester non e il live**: il conteggio delle richieste di FTMO e un'altra misura. Dal campo la causa del picco di richieste era il ciclo del Guardian bloccato (`RICHIESTE_AL_SERVER_STIMA_DAI_TEST_2026-11-10.md`), non il trailing.
5. Gold Trade Pro (V99, V0, C0): in attesa dell'altra riga.

---
## AGGIORNAMENTO (11/11, 20:00): Gold Trade Pro Combo — 9 passate rifatte con TUTTI gli input imposti, e VERDETTO a 4 EA
**Validita**: 9/9 valide (stato OK, qualita 99-100%, zero stop out/no money). Controllo ripetuto sui **tutti** gli input del report contro il riferimento D160: **nessun input diverso** oltre ai due del test; V99 = virtual true e ritardo 99, V0 = true e 0, C0 = false e 0 (confermati). Sostituisce le 9 passate non valide (`RISULTATI_VSLTP_GTP_INVALIDO_2026-11-11.md`). Script `D160_dati/analisi_vsltp_gtp.py`.
| Braccio | Netto 3 anni vs rif. (61.235) | Righe di giornale vs rif. (2013 / 2020 / 2025) | DD: massimo aumento | Peggior giorno: massimo peggioramento | Operazioni | Richieste | Costo |
|---|---|---|---|---|---|---|---|
| V99 | 59.920 (-2,1%) | -5,1% (-2 / -3 / -9) | +0,38 pt | 272 EUR (0,17 pt) | -0,1% | NON RIDUCE | NEUTRO |
| V0 | 63.556 (+3,8%) | **-36,7%** (-26 / -34 / -48) | +0,65 pt | 572 EUR (0,36 pt) | -0,1% | RIDUCE POCO | NEUTRO |
| C0 | 61.235 (0,0%) | -0,0% | 0 | 0 | 0 | NON CONTA | - |
C0 coincide col riferimento al euro: la riproducibilita e confermata e il ritardo 0 a virtual spento non cambia niente.
Per anno V0: netto 29.325 / 12.420 / 21.812 contro 29.858 / 13.087 / 18.290 (2025 +19%, 2013 e 2020 -2% e -5%).

## VERDETTO FINALE sull'oro (4 EA, 3 anni, 160k)
| EA | V99 | V0 | V0 contro V99 |
|---|---|---|---|
| Goldbot Prop | NON RIDUCE (-4,6%): DA SCARTARE | RIDUCE POCO (-21,9%), NEUTRO: DA VALUTARE | in mezzo (17 punti) |
| Phantom Gradino 1 | NON RIDUCE (-7,8%): DA SCARTARE | RIDUCE POCO (-26,4%), NEUTRO: DA VALUTARE | in mezzo (19 punti) |
| Reaper Combo | NON RIDUCE (-0,9%): DA SCARTARE | RIDUCE POCO (-24,3%), NEUTRO: DA VALUTARE | **MIGLIORE** (23 punti) |
| Gold Trade Pro Combo | NON RIDUCE (-5,1%): DA SCARTARE | RIDUCE POCO (-36,7%), NEUTRO: DA VALUTARE | **MIGLIORE** (32 punti) |
Riduzione media delle righe con V0: **-27%** (da -22% a -37%); con V99: -4,6% (da -1% a -8%). Il costo e neutro: netto da -2% a +18% (dentro il rumore per Phantom e Reaper), DD al massimo +0,65 punti, peggior giorno al massimo +0,36 punti.
**Previsioni V1-V16 (finali sull'oro)**: V1 vera · V2 Goldbot RIDUCE >= 50% falsa, netto +-10% vera · V3 Phantom RIDUCE falsa (02/06/2025 non misurabile) · V4 Reaper RIDUCE falsa · V5 GTP RIDUCE >= 50% **falsa** (-36,7%) · V6 EA fuori banda falsa · V7 peggior giorno oltre 0,5 pt falsa (massimo 0,36) · V8 nessuno VIRTUAL CONVIENE: **vera** (V0 e DA VALUTARE) · V9 righe invariate falsa · V10 operazioni oltre 10% falsa · V11 vera · V12 V0 MIGLIORE su >= 2 EA su 4: **vera** (2/4: Reaper e GTP) · V13 non misurabile · V14 C0 NON CONTA vera (Goldbot e GTP) · V15 falsa · V16 vera (V0 riduce di piu in 4/4).
## Conclusione
Il Virtual SL/TP con ritardo 99 non riduce le righe. Con **ritardo 0** le righe del giornale del tester calano di circa un quarto (22-37%), mai della meta, a costo neutro: e **DA VALUTARE**, non "conviene". Non e una soluzione al problema delle richieste del Guardian, e il rischio di sicurezza (stop reale potenzialmente non sul server con ritardo 0) non e misurato e non e dimostrato dal tester: vedi limiti sopra.
