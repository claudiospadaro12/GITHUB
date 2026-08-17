# SCHEDA GRADINO 1 DEL CANCELLO — Range Breakout Day Trader (MT5)

Fonte: seconda caccia del 18/08/2026 (referto CONFIG_PROP_RACCOLTA_SET),
pagina Market mql5.com/en/market/product/114061, autore dichiarato Aroen
Mughal. Scheda scritta per chiudere M10 del PIANO_PROP: i dati del cancello
devono stare nel repo, non in chat.

## Gradino 1 - la scheda
- Prezzo: 179 USD una tantum. NOLEGGIO: 3 mesi 59 USD / 1 anno 109 USD.
- 12 attivazioni. v3.2, aggiornato 14/05/2026. ~501 download. 3 recensioni
  (prova sociale DEBOLE, dichiarata).
- Demo scaricabile: SI (testabile nello Strategy Tester prima di pagare).
- Meccanismo dichiarato: range breakout intraday, una posizione al giorno,
  SL sempre presente, trailing ATR, "no Grid/Hedge/Martingale recovery".
- Riscontro nei fatti: 32 preset pubblici letti (in biblioteca/set/):
  nessun parametro di moltiplicazione lotti. Filtro news via CSV del
  calendario (backtestabile - la scoperta che ha sbloccato D1).
- ATTENZIONE taglie: il profilo "ExtraLowRisk" del vendor rischia 2,4% per
  trade = 3,7 volte il nostro 0,65%. Qualunque test gira a taglia NOSTRA.

## Gradino 1-bis - due diligence sul venditore: DA FARE (aperta)
Recensioni Market -> Google del nome -> Forex Peace Army -> Forex Factory.
Nessuno dei quattro passi e' stato ancora eseguito su Aroen Mughal.

## Gradino 3 - criteri demo CONGELATI PRIMA dei numeri (18/08/2026)
Sul US30 e sull'oro, quattro finestre di regime di casa (ORSO 2022.01-10 /
CROLLO 2020.02-04 / TORO 2021 / LATERALE 2019), costi nostri, rischio
riportato a 0,65%:
- PASS se: PF > 1,2 con n >= 150 operazioni per finestra, DD di portafoglio
  < 9%, almeno 3 finestre su 4 positive.
- Qualunque esito: prima il NOLEGGIO 3 mesi (59 USD) in forward demo, mai
  l'acquisto diretto. I numeri/screenshot del vendor valgono zero.

## Stato
Gradino 1 fatto (questa scheda) · 1-bis DA FARE · 2 (setaccio) superato sui
32 preset · 3 in attesa di decisione di Claudio · 4-5 a seguire.
