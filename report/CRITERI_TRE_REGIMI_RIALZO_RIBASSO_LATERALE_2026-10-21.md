# Criteri per la prova a tre regimi (rialzo / ribasso / laterale): BOZZA DA FIRMARE (21/10/2026)

**Non firmata, non controllata da agenti. Nessuna riga di lancio e' autorizzata da questo file.** Origine: Claudio, 21/10: "i backtest 2025-2026 sono un solo regime (oro in salita)? meglio 3 anni diversi, anche sfasati: long, short e laterale". Le soglie qui sotto sono PROPOSTE MIE: valgono solo dopo la firma di Claudio e vanno scritte PRIMA di guardare qualunque numero delle finestre.

## 0. Perche'
Oggi la finestra e' 21 mesi (indici dal 26/09/2024, oro dal 2025), un solo regime. Un EA che compra soltanto sembra bravo in un rialzo. La prova serve a dire: **regge o crolla fuori dal rialzo?** Non a dire quanto guadagna.

## 1. Scelta delle finestre (regola, non gusto)
- Tre finestre da 12 mesi, NON sovrapposte fra loro e NON sovrapposte al periodo 2025-26 gia' usato. Inizio a scelta in qualunque mese (sfasate dal calendario).
- Classificazione dal PREZZO del sottostante (stesso simbolo del test), calcolata PRIMA dei backtest: rendimento R = chiusura finale / chiusura iniziale - 1 e corsa C = (massimo - minimo) / chiusura iniziale.
  - **RIALZO**: R >= +15%. **RIBASSO**: R <= -15%. **LATERALE**: |R| <= 8% e C <= 25%.
  - Finestre fuori soglia (es. R +10%) non si usano. Soglie PROPOSTE [DA FIRMARE].
- Si sceglie la finestra piu' recente che soddisfa ogni classe, per non scegliere a mano. Ogni finestra deve avere dati completi: copertura dichiarata (barre/tick, buchi) prima del lancio. **Dati: NON MISURATO qui.** L'oro M1 su BCM/Dukascopy arriva fino a maggio 2020 [dai referti], i tick reali del broker partono molto dopo; fuori dai tick si usa OHLC 1 minuto (modello 1) e i costi sono meno affidabili.
- Una finestra deve cadere fuori dal periodo di ottimizzazione dichiarato dell'EA, se noto; altrimenti si scrive "periodo di ottimizzazione NON NOTO".

## 2. Parametri congelati
Stessi input, stesso lotto, stesso deposito (80.000 EUR) in tutte le finestre e in quella 2025-26. Nessun ritocco dopo aver visto una finestra: un ritocco vale solo per il round dopo.

## 3. Cosa si misura in ogni finestra
Operazioni; PF; DD di equity e di saldo, anche come % degli 80.000; mesi positivi; metà finestra positive; profitto di long e di short SEPARATI; confronto col solo comprare e tenere (R); rapporto lotti max/min.

## 4. Come si legge (soglie PROPOSTE)
- **Regge** in una finestra: PF >= 1,0, DD <= 10% dal deposito, n >= 60 operazioni (sotto: "non misurabile", mai "peggiora").
- **Segue il mercato**: utile nel RIALZO, PF < 1,0 nel RIBASSO e nel LATERALE, oppure oltre l'80% del profitto dai long nel rialzo e short in perdita nel ribasso.
- **Segnale forte**: PF >= 1,0 nel RIBASSO o nel LATERALE con n >= 60.
- Il PF non e' un merito se n < 150 per finestra: si scrive e non decide da solo; il DD si legge sempre.
- Un solo EA per volta; nessun EA promosso da questa prova da solo: serve anche S-CORR/S-PORT.

## 5. Limiti dichiarati prima
Tre finestre sono tre campioni: poche per un giudizio statistico. Le date di inizio sfasate riducono ma non eliminano la scelta. Costi e slippage nelle finestre OHLC sono approssimati. Il periodo di ottimizzazione dei prodotti Market e' spesso ignoto.

## 6. Da firmare (Claudio)
1. Soglie R +15% / -15% / |8%| e C 25%. 2. Ampiezza 12 mesi. 3. Soglie n >= 60 e PF >= 1,0. 4. Quali EA (proposta: Gold Reaper, Goldbot One a StartLots, Prop Firm Gold EA; per gli indici la sedia Nasdaq 770260). 5. Primo passo senza backtest: una sonda dei dati sul PC (copertura per anno dell'oro e del Nasdaq, R e C per finestra candidata).

## 7. Aggiornamento 21/10 sera (dopo la richiesta di Claudio: "prepara la riga per i tre regimi, poi facciamo la correlazione")
- **Le soglie restano quelle della bozza** (R +15% / -15% / |8%|, C 25%, 12 mesi, n >= 60, PF >= 1,0) finche' Claudio non le firma; qui sono usate come proposta.
- **Prima la misura dei prezzi, poi le finestre, poi la riga**: la classificazione dal prezzo non si fa a memoria. Passo 0 (Claudio, 2 minuti, zero rischio, nessuna riga): esportare dalla History Center di MT5 (F2) le barre D1 di XAUUSD dal 2004 in CSV. Le finestre candidate si calcolano da quel file e si scrivono QUI prima di qualunque backtest.
- **Cosa gira nella riga**: i tre EA gia' misurati sul 2025-26, ognuno con gli input GIA' fissati, sulle tre finestre in OHLC 1 minuto (modello 1, i tick reali del broker partono nel 2024): Goldbot One (Risk 9999, step 3000 e 6000), Gold Reaper (set del venditore verificato), Prop Firm Gold EA (configurazione a 80K del test del 19/10). Nove-dodici passate.
- **Correlazione per regime**: stessa regola S-CORR (<= 0,5 giornaliera, realizzi) calcolata DENTRO ogni finestra per le coppie Goldbot One-Gold Reaper, Goldbot One-Prop Firm, Gold Reaper-Prop Firm, piu' il DD combinato (S-PORT, <= 10% di 80.000). Nel 2025-26 la correlazione Goldbot One-Gold Reaper e' 0,52-0,54 (rialzo): la domanda e' se scende o sale fuori dal rialzo.
- **Rischi noti prima di lanciare**: un EA del Market puo' dipendere dal calendario MQL5 o da dati che il tester non ha negli anni vecchi [NON VERIFICATO]; il filtro notizie di Goldbot One nel tester usa offset 2/3 (AutoGMT non funziona) [effetto NON misurato].

## 8. FINESTRE PRE-REGISTRATE (21/10 sera) -- misurate dai prezzi D1 di Claudio, PRIMA di qualunque backtest
Dati: `data/prezzi/XAUUSD_D1_BCM_2004-06-11_2026-10-21.csv` (export di Claudio dal terminale BCM, Simboli > Barre): 6.851 barre D1 dal 11/06/2004 al 21/10/2026; **0 buchi oltre 5 giorni, 0 barre con OHLC incoerente**; 289-311 barre per anno intero. Script: `backtest_pipeline/regimi_oro.py` (256 finestre da 12 mesi con inizio il primo di ogni mese; R = chiusura finale / chiusura precedente - 1; C = (massimo - minimo) / chiusura iniziale). Regola applicata alla lettera: soglie della bozza, **la finestra piu' recente per classe che finisce prima del 2025, non sovrapposta alle altre**.
| classe | finestra | R | C | barre | chiusura iniziale -> finale |
|---|---|---|---|---|---|
| **RIALZO** | 01/01/2024 - 31/12/2024 | +27,2% | 39,1% | 301 | 2.063 -> 2.624 |
| **LATERALE** | 01/06/2022 - 31/05/2023 | +7,0% | 24,6% | 310 | 1.838 -> 1.966 |
| **RIBASSO** | 01/04/2013 - 31/03/2014 | -19,6% | 26,5% | 311 | 1.597 -> 1.284 |
Per riferimento, la finestra GIA' usata dai nostri test (01/01/2025 - 01/10/2026) vale **R +59,2% e C 113,7%** (2.624 -> 4.179): e' il rialzo piu' forte della serie, un regime estremo oltre che unico.
**Avvertenze di scelta (dichiarate prima dei numeri):** (1) il LATERALE e' sul bordo di entrambe le soglie (R +7,0% su 8; C 24,6% su 25); le alternative che passano sono 01/07/2021-30/06/2022 (R +2,1%, C 21,9%), 01/01/2022-31/12/2022 (R -0,3%, C 24,9%) e 01/04/2022-31/03/2023 (R +1,8%, C 20,4%); si tiene la regola, non si cambia dopo. (2) **Dopo il 2014 l'oro non ha avuto nessuna finestra a 12 mesi con R <= -15%** (il peggiore e' -14,6% da 01/08/2014): il RIBASSO e' vecchio di 12 anni, con prezzo 1.300-1.600 contro oltre 4.000 oggi e un'altra struttura di spread e volatilita' in punti; i numeri in euro non sono confrontabili 1:1 con il 2025-26. (3) Nel RIALZO 2024 una parte dei tick reali BCM esiste (da luglio 2024) ma il modello e' lo stesso per tutte le finestre: OHLC a 1 minuto.
**Congelato:** finestre, modello 1 (OHLC 1 minuto), deposito 80.000 EUR, leva 1:100, gli stessi input gia' misurati per ogni EA (vedi riga di lancio), nessun ritocco dopo i numeri.

## 9. FINESTRE DI CONTROLLO PER LO SPREAD (21/10 notte), scelte da regola PRIMA dei numeri
Motivo: lo spread mediano delle barre D1 di Claudio vale 0 punti nel 2022-23 (191 barre su 310 a zero), 5 nel 2024, 23 nel 2013-14, 16 nel 2025-26 (par. 8 e `REGIMI_ORO_TRE_EA_LETTURA_2026-10-21.md`). Se il tester usa lo spread storico delle barre [NON VERIFICATO], il LATERALE 2022-23 e il RIALZO 2024 sono stati girati con costi troppo bassi. Il tester MT5 non ha un'impostazione di spread fisso: si cambia finestra.
**Regola (meccanica, `backtest_pipeline/regimi_spread.py`, soglia 12 punti):** stessa classificazione del par. 1, in piu spread mediano D1 >= 12 punti; la finestra piu' recente per classe che finisce prima del 2025, non sovrapposta alle altre.
| classe | finestra | R | C | spread mediano / medio / barre a zero |
|---|---|---|---|---|
| RIALZO-S | 01/08/2019 - 31/07/2020 | +39,6% | 41,2% | 14 / 11,4 / 3 |
| LATERALE-S | 01/06/2018 - 31/05/2019 | +0,4% | 14,4% | 15 / 14,7 / 1 |
| RIBASSO | 2013-14 | gia' misurato (spread 23): non si rifa | | |
La finestra RIALZO-S contiene il crollo di marzo 2020 (volatilita' alta). Questo e' un controllo sul costo, non una sostituzione: le finestre del par. 8 restano; ogni conclusione sul laterale e sul rialzo si legge su ENTRAMBE le coppie di finestre. Non e' stato cambiato nessun criterio di lettura dopo i numeri.
