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
