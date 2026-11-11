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
