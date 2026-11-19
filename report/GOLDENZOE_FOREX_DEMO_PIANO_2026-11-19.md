# GoldenZoe forex - piano forward DEMO (19/11/2026, decide Claudio)

Solo conto DEMO BCM 50503392 (hedging). VPS e reale 10105439 NON toccati da Claude: il montaggio dei grafici lo fa Claudio.
EA: `GoldenZoe_H4.mq5` (SHA256 878CF3D3...), long-only, Donchian 55, stop 3 ATR, trailing 3 ATR, rischio come testato (InpRiskPercent=1.0, default; nessun consiglio su taglie). Il filtro posizioni usa simbolo+magic: un magic distinto per istanza comunque.

| Simbolo | TF | InpTF | InpMagic | Stato scan (OOS 2021-24) | Op./anno attese (OOS) |
|---|---|---|---|---|---|
| EURJPY | H2 | 16386 | 972311 | PF 1,33 (134 op.) passa; test mirato 40 passate in corso | ~34 |
| USDJPY | H6 | 16390 | 972312 | PF 1,95 (63 op.) passa; H8 non valutabile | ~16 |
| USDSEK | H8 | 16392 | 972313 | PF 1,37 (37 op.) passa; unico TF | ~9 |
| EURCHF | H6 | 16390 | 972314 | PF 1,03 (34) NON passa | ~8 (facoltativo, esito OOS no) |
| EURNOK | H6 | 16390 | 972315 | PF 0,75 (44) NON passa | ~11 (facoltativo, perdente in OOS) |

Impostazioni uguali per tutti: InpDonchianN=55, InpAtrPeriod=14, InpStopAtr=3.0, InpTrailAtr=3.0, InpAllowLong=true, InpAllowShort=false, InpComment=GOLDENZOE <simbolo> <TF>.

## Cose da sapere (scritte prima)
- Selezione da 222 prove: i 3 che passano sono in parte fortuna possibile. La demo e una prova fuori campione VERA, non una conferma.
- Frequenza bassa: USDSEK ~9 op./anno = ~2 anni per 20 operazioni. Nessun giudizio prima di 20 operazioni per istanza.
- Swap: BCM long EURJPY +1,56, USDJPY +5,10, USDSEK -15,43 punti/lotto/notte (triplo mercoledi): USDSEK paga carry negativo.
- JPY: possibile deriva dello yen debole (test SHORT in corso).

## Regole di valutazione (fissate ora)
1. Registrare per ogni operazione: data, simbolo, TF, esito in R e in EUR, swap pagato.
2. Controllo a >=20 operazioni per istanza (o 12 mesi per EURJPY): PF, % di R positive, DD.
3. Segnale di stop (si toglie dalla demo, nessuna modifica dei parametri): PF<1,0 con >=20 operazioni, oppure DD > 2 volte il DD del tester IS/OOS dello stesso simbolo.
4. Segnale di promozione a "da valutare per il reale": PF>1,2 con >=30 operazioni E test mirato EURJPY/JPY non dipendente da deriva E correlazione con gli EA di Wim misurata. La decisione resta di Claudio.
5. Nessun cambio di parametri durante la demo.
