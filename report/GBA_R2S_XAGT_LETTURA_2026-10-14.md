# GBA R2S, ARGENTO M1 A TICK REALI (XAGT) + ANCORA: lettura dello zip (14/10/2026)

Fonte: `GBA_R2S_XAGT.zip` (SHA256 `cad5e326e1ef3d89…`), riga `b9244703…` al pin `3537db93`, PC di backtest `DESKTOP-H4D7CAJ`, 07:59-08:01 (**2 minuti**), lotto argento `rc 3` (zero operazioni, atteso), ancora `rc 0`. Letto in UNA invocazione con D2 v4 (`1697135a…`, PASS): ancora del 12/10 + passata a Modello 1 del 13/10 + zip XAGT. Precondizioni fuori da D2: **A3** risponde come deve («la stessa misura e' caricata DUE volte»: ancora R2SXTANC contro R1A_01) e **G0** dell'argento dice KO solo per «ZERO operazioni» (l'unico KO ammesso). Archivio: `backtest_pipeline/risultati_archivio/GBA_R2S_XAGT_20261014/`. (Claudio ha mandato anche `GBA_R0_R2SXTANC.zip` da solo: SHA256 identico a quello dentro lo zip XAGT, nessun dato nuovo, non riletto per non violare l'A3.)

## 1. Esito (regola E3): CONFERMATO a tick reali
- **Casella 4 per XAGUSD M1: CHIUSA, «ESCLUSA PER COSTO (Modello 1 e tick reali)» col numero**: C3G a Modello 1 **2,40**, a tick reali **2,40**, contro la soglia S = **6,65x** dell'argento; righe >= 40x **0** su 6.611; ingressi **0** (6.611 segnali su 6.611 scartati dal filtro di spread, nessuno con stop/spread >= 50x).
- **I tick sono veri** (CE-T verde): qualita `100% ticksreali`, voce XAGUSD presente, **12.135.165 tick** contro i 353.614 generati a Modello 1.
- Per fascia (tick reali, C3G): asia 2,10 · europa 2,30 · pausa 2,70 · USA apertura **4,10** (la migliore) · USA pomeriggio 2,00 · rollover 1,40; BUY 2,45 / SELL 2,30. Spread mediano 0,05 USD.
- **L'ancora sull'oro regge a tick reali**: 128 operazioni / -6.577,48 / PF 0,83 / 25.648.545 tick / 88.416 barre / C3G 21,60: **identica a R1A_01 del 10/10** (CE1 verde). La passata a Modello 1 del 13/10 riletta oggi con lo stesso D2: identica alla lettura della v3 (regressione 0b verde).
- **Nessun PF si legge** (zero operazioni). La causa e' il costo, non il motore: a M1 l'ATR dell'argento e' dell'ordine di 0,03-0,05 USD contro uno spread di 0,05: per entrare servirebbe uno stop pari a 2,5 x ATR >= 20 x spread.

## 2. Cosa vale e cosa NON vale (certificato)
- **Vale**: l'argento **M1** e' escluso per costo con il numero (2,40x contro 6,65x, due misure diverse: Modello 1 e tick reali).
- **NON vale per l'argento in generale**: M15 «n insufficiente» (C3G 11,95, zero ingressi), **M30 e H1 non letti** (KO per stallo, C3G 17,9 e 26,3 solo come descrizione), **H4 passa il costo** (C3G 52,2x) con n 10 su un trimestre. Quindi **l'argento NON e' «morto»**: M1 e' chiuso per costo; **H4 e i TF alti restano da misurare** (rifare M30/H1 una per una; H4 con campione piu' lungo; correzione del lettore sul costo dell'argento col cancello).
- Casella 5 (TF cambiato): M1 -> M15 -> M30/H1/H4 sono stati cambiati: l'argento ha lo schema giusto per il ragionamento «piu' alto e' il TF, meglio sta il costo» (M1 2,40 · M15 11,95 · M30 17,9 · H1 26,3 · H4 52,2 [DERIVATO, solo spread]).
