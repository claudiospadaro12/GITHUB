# Arena regge sul reale con i costi del reale? -- cosa si sa e cosa NO (15/10/2026)

Domanda di Claudio: «se l'EA Arena regge sul reale con i costi del reale (slippage, spread ecc.)». Nessun tocco al conto reale 10105439: tutto da dati gia' in repo.

## Cosa c'e' GIA' nei numeri del tester [MISURATO]
- Ticks reali BCM (lo spread del feed c'e'), commissione 3,67-3,71 EUR/lotto a giro (demo 4,00), **zero slippage e zero latenza** (ExecutionMode=0). Il tester gia' mette 11.833 ingressi su 14.629 a prezzo peggiore (media 0,108 USD: salti fra tick, non slippage).
- Con questi costi: agosto PF 0,47 (stop out 05/08), settembre PF 0,92 (stop out 28/09), netto -3.063 e -2.505 EUR. **Il motore non regge nemmeno senza slippage.**

## Cosa aggiungerebbe il reale [DERIVATO, sensibilita' sul tester di settembre]
- k = 86,41 EUR per 1,0 USD di prezzo per lotto; lotti d'ingresso 204,96. Slippage SOLO in ingresso: **+0,05 USD = -886 EUR; +0,10 = -1.771; +0,20 = -3.542; +0,30 = -5.313** al mese. Settembre passerebbe da -2.505 a -4.276 con +0,10.
- Demo 13-15 ottobre (Arena 2.308 posizioni, 35,53 lotti, netto +2.075,25): +58,41 EUR per lotto, commissione 3,84/lotto, swap +0,17. **Slippage di pareggio: 0,68 USD per fill (solo ingresso) o 0,34 (ingresso e uscita)**. Margine largo, ma su tre giorni SENZA giorno di coda.

## Cosa NON e' misurato [NON MISURATO]
- Spread, commissione, **slippage dell'oro sul conto REALE** (lo `ABTG_SlippageLogger` del reale ha 12 deal, 0 righe oro; slippage misurati solo su indici).
- Freeze level / rifiuti sul reale (nel tester compaiono gia' `retcode=10029 frozen` e `modifica rifiutata`); recensioni del Market: «reale != demo», «alcuni ordini non vengono eseguiti» [DICHIARATO DA TERZI].
- Margine e leva reali sull'oro (tester: 10.000 USD a lotto, ~1:45 [DERIVATO]); regole del bonus BCM.
- Swap sui cesti lunghi (fino a 37,5 ore).

## Verdetto
Sui costi misurabili Arena NON regge (due mesi su due in perdita con stop out). I costi del reale possono solo peggiorare. I tre giorni positivi del demo non lo contraddicono: non contengono un giorno di coda. Nessuna promozione; l'Arena resta in osservazione sul demo.
