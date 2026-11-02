# Gold Reaper: il video di René Balke (aprile 2024) contro i nostri test (02/11/2026)
Fonti: sottotitoli del video "Reviewing the mql5 Gold Reaper Expert Advisor" (canale Fx Bot Trading, 26/04/2024, 34 minuti, zip `video01` di Claudio); nostri report `OOS_2005_2012_TRE_EA_RISULTATI_2026-10-31`, `TICK_2025_TRE_EA_RISULTATI_2026-11-01`, `CONFRONTO_SEGNALE_WIM_REAPER_2026-10-31`, `REAPER_RANDOMIZATION_AUTO_RISULTATI_2026-10-31`. Non controllata da agenti. Il recensore non ha visto il codice: le sue sono osservazioni dal tester.

| Punto | Video (2024) | Nostri test (Reaper D9, set prop) | Lettura |
|---|---|---|---|
| Come lavora | Rottura di supporti/resistenze, molti ordini pendenti Buy/Sell Stop a livelli diversi, stop e target diversi per ordine, trailing, ATR su D1 e H1(28) | Stessi pendenti lontani dal prezzo; il FAQ di Wim: "la maggior parte scade senza essere eseguita" | **Coincide** |
| Backtest 10 anni a tick reali, conservativo | Curva quasi sempre in salita; DD massimo circa 50% (saldo) e 30% relativo di equity; "probabile ottimizzazione sullo storico" | Set D9 con limite totale a 9%: DD equity relativo **9,6%** in 2005-2012; anni 2013/2018/2020/2025 a 80.000 fissi: **+27/+17/+25/+38%** | Il video usa le impostazioni di default (limite 30%); il nostro set e piu prudente. Sono **rischi diversi, non numeri in conflitto** |
| "Ottimizzato sullo storico?" | Sospetto, non verificabile | **2005-2012, fuori dalla finestra su cui Wim ottimizza (2013-2023): 8 anni su 8 positivi**, circa +32% annuo composto, profitto 47% long / 53% short | **Risposta parziale a favore del Reaper**: sul periodo mai usato regge. Resta un solo percorso e spread/slippage dei primi anni non simulati |
| Solo long? | Si chiede se guadagna solo con l'oro in salita | **2025: 79% del netto da long** (anno di rialzo forte); 2005-2012: **47/53** | Nei rialzi dipende dai long; negli anni neutri guadagna anche short |
| Slippage | "Con ordini stop, la slippage reale sara peggiore" | Il tester non la simula: **NON MISURATO**. Tick reali contro candele: netto **-8,1%**, DD invariato (+0,9%), netto/DD **-8,9%** | Effetto tick piccolo; la slippage vera resta da misurare sul conto |
| Segnale live | 3 mesi, circa +30%, DD 4% | Segnale "New V2" dal 22/10/2024: media 6,9% al mese, 3 mesi negativi su 21, peggiore -6,7%, DD 16,9%. Il nostro Reaper D9 lo segue: **correlazione 0,91, stesso segno 21/21**, ma rende **circa la meta** (3,6% al mese, DD 8,7%) | Stesso motore con circa il doppio del rischio [INFERENZA] |
| Randomizzazione | "Serve perche le prop non vedano ordini identici" | Randomization 75-100: **peggiora** il rischio (DD 7,6-9,7k, peggior giorno fino a -8,8% a 80k); lasciata a 0 | Funzione utile contro la copia identica, ma ha un costo di rischio |
| Giudizio | Buon prodotto, non verificabile; aspettare 5-6 mesi | Dopo 2,5 anni: segnale ancora in utile, il nostro test segue il segnale | La condizione che chiedeva (storico piu lungo) e in parte soddisfatta |

## Cosa resta aperto
Slippage e commissioni reali; il 2026 oltre settembre; un regime di oro in calo prolungato (il periodo 2005-2012 e 2025 sono favorevoli); lo stesso set su un conto FTMO con vincoli prop (trial in corso).

## Cosa NON dice
Un solo recensore, aprile 2024, versione di allora (oggi 5.6); il confronto di rischio dipende dalle impostazioni; i nostri test sono su BCM, M1 o tick, senza slippage. Nessun giudizio su acquisti, lotti o taglie.
