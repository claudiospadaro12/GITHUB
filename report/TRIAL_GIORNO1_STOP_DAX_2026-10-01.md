# Trial 160K - 1 ottobre, ore 10: lettura dallo storico del telefono (screenshot di Claudio)

Fonte: due screenshot dell'app mobile MT5 (Storico > Affari, alle 09:45 e 09:46 ora italiana). Il conto non e' scritto nelle immagini:
si deduce dall'orologio (ultimo deal 10:43:33 contro telefono 09:45 = server IT+1, cioe' il terminale FTMO) e dai lotti (47,78 lotti = rischio da 160K).
Conto `[NON LETTO DALL'IMMAGINE]`: da confermare col report xlsx della sera (`lettura_trial.py`).

## Cosa e' successo (ora SERVER FTMO)
- 09:59:01 `MAXMIN DAX SHORT SELL` (GER40.cash, magic 770411 sul preset FTMO, `InpRiskPercent=2.00`) entra short 47,78 lotti a 24.998,25.
- 10:06:32 stop a 25.067,16 (SL scritto 25.066,00): **-3.292,52**.
- 10:43:33 NZDCHF (Bulge, 7,23 lotti, long da 0,47041) stop a 0,46865: **-1.357,14**.
- Aperte alle 10:00: GBPNZD short 2,83 lotti (06:00 a 2,35658) e 4,49 lotti (10:00 a 2,35994). Profitto aperto mostrato dal telefono: +334,59 alle 09:45, +207,41 alle 09:46 (se il numero in barra e' il flottante: `[NON VERIFICATO]`).

## Conti (calibrati sui P/L veri)
- DAX: 68,91 punti x 47,78 lotti = 3.292,52 -> **1 EUR a punto per lotto** (conto quadra). Stop teorico 67,75 punti = 3.237 EUR; **slippage di fill 1,16 punti = ~55 EUR (0,03% di 160K)**: primo dato di slippage reale del trial.
- Rischio DAX: 3.292,52 / 160.000 = 2,06% (design 2,00% + slippage). **Non e' un'anomalia di lotto: e' il rischio scelto nel preset.**
- Perdita chiusa del giorno: 4.649,66 = **2,91%** dell'iniziale.
  - al pausa Guardian 3,5% (5.600): restano ~950
  - all'emergenza Guardian 4,5% (7.200): restano ~2.550
  - al 5% presunto FTMO (8.000, regola trial NON misurata): restano ~3.350
- Se le due GBPNZD aperte prendessero lo stop pieno (~1% ciascuna dal preset, 3.200 stimati, NON misurati sui lotti): -7.850 = oltre l'emergenza 4,5% e a ~150 EUR dal 5% presunto. **E' lo scenario che fa lavorare il Guardian**; se interviene si legge nel Giornale/Esperti (righe pausa/emergenza).

## Allarmi dei criteri (`TRIAL_14_GIORNI_CRITERI_2026-10-01.md` par. 4)
- stop pieni oggi: 2 (DAX, NZDCHF). **Al terzo scatta la soglia "3 stop nello stesso giorno".**
- equity <= 148.000: non raggiunta (perdita chiusa 4.650 + flottante).
- Lotto/stop anomali: nessuno visto (47,78 lotti coerente col 2,00%).

## Lettura (e cosa NON dice)
- Un unico stop non giudica il motore: i criteri dei 14 giorni valutano meccanica e frequenza, non il merito. Il fatto che il prezzo sia poi sceso a 24.853 e' un controfattuale: il motore ha stop stretto contro target largo, e questi episodi stanno nella sua forma (vincite rare grosse / stop frequenti).
- Resta da misurare a fine giornata: i due stop di oggi rientrano nel rischio promesso (DD forward contro DD del backtest)? Serve il report xlsx completo.

## 10:50 - DUE istanze Bulge sul trial (screenshot Posizioni, GBPNZD short)
- Posizione 554388449: sell 2,83 lotti, 06:00, commento `BULGE_V520_FT_VIOLA_S` = il nostro preset del trial (`InpComment=BULGE_V520_FT`, magic 772720).
- Posizione 554501148: sell 4,49 lotti, 10:00, commento `BULGE_VIOLA_S` = `InpComment` **di default ("BULGE")** + `_VIOLA_S` (ABTG_Bulge.mq5 r.458, r.678).
  Il commento si costruisce da `InpComment` (input fisso per istanza): **due prefissi = due istanze diverse** di ABTG_Bulge sul terminale.
- Rischio ricostruito dagli SL e dai P/L aperti (EUR/NZD 0,4964, ricavato da -235,99 e +374,41 su 16,8 pip): 
  #A 91,4 pip x 2,83 lotti = 1.284 EUR = **0,80%**; #B 72,0 pip x 4,49 lotti = 1.605 EUR = **1,00%** (su 160K). Il rischio di #A e' quello del file preset, #B e' 1,0 (digitato a mano?).
- Ipotesi (NON distinte da qui): (1) Bulge attaccato una seconda volta con input di DEFAULT (Use_Blue=true, ADX acceso, 22 cross, Max_Trades 4, magic 772700) e solo il rischio ritoccato; (2) istanza ereditata da una copia di grafico. Serve la scheda Esperti `[BULGE] Init OK` (una riga per istanza) e Proprieta' > Input di ciascuna.
- Conseguenza se (1): ingressi Blu (storicamente perdenti sul piccolo), sovrapposizione sui 7 cross che il preset lascia ad altre sedie, tetto reale = 4 + 4 posizioni, non 3. Guardian: cap C1 4,00% solo bandiera.

## 14:00 - secondo screenshot dello storico (ora server FTMO)
- 11:13:13 GER40.cash **sell 12,08 lotti a 24.834,96**, stop a 25.092,04, chiuso 13:36:02 a 25.092,45: **-3.110,48** (257,49 punti x 12,08; = 2,00% del bilancio di quel momento ~155.4K: lotto coerente col rischio 2,00% dei preset DAX Apertura 770101/770105). Chair `[NON VISIBILE: commento dell'ingresso non espanso]`, candidato 770105 SHORT (InpSessionHour=10, InpRiskPercent=2.00).
- 12:00:00 AUDUSD buy 7,99 lotti a 0,69377, chiuso 13:42:13 a 0,69462: **+597,17**. AUDUSD **non e' nella lista dei 15 cross del preset trial** -> l'ingresso viene probabilmente dalla seconda istanza Bulge (22 cross di default) `[INFERITO: commento non espanso]`.
- 13:25:11 GBPNZD 4,49 lotti (la #B del commento `BULGE_VIOLA_S`) chiusa a TP 2,35534: **+1.010,74**, commissione -9,95.
- Stima del giorno dal bilancio 155.302,22 (09:50) + i deal visibili: bilancio ~153.790, equity ~153.780 (flottante -9,85): **perdita giornaliera ~6.220 = 3,89% di 160K**. Pausa Guardian 3,5% (5.600) superata; emergenza 4,5% (7.200) a ~980; 5% presunto FTMO (8.000, NON misurato) a ~1.780. Linea di perdita massima 144.000 a ~9.780.
- **Allarme dei criteri scattato**: 3 stop pieni nello stesso giorno (DAX 770411, NZDCHF, DAX 11:13). Par. 4: "si spegne Algo e si guarda prima di riaccendere".

## 14:52 - commento dell'AUDUSD letto (screenshot di Claudio)
- AUDUSD buy 7,99 lotti, 12:00:00 a 0,69377: commento **`BULGE_VIOLA_L`** (prefisso di default). Chiuso a TP 0,69461 (fill 0,69462): +597,17.
  **AUDUSD non e' nella `Symbols_List` del preset trial (15 cross)**: l'istanza B ha dunque una lista piu' larga (verosimilmente i 22 di default). Resta da leggere `InpMagic`, `Use_Blue`, `Max_Trades` di B.
- Istanza B oggi: GBPNZD +1.010,74 e AUDUSD +597,17, **due TP su due trade viola**; non si sa ancora se B ha preso anche trade Blu (lo stop NZDCHF 10:43 e' senza commento letto).
- **Commissioni FTMO (dato nuovo)**: 17,69 EUR per lato su 7,99 lotti = 2,21 EUR/lotto/lato (GBPNZD 9,95 su 4,49 lotti = 2,22): **~4,43 EUR/lotto a giro**. Sull'AUDUSD: 35,38 EUR di commissioni contro 597,17 di profitto lordo (5,9%).
