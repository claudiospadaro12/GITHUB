# Arena Nexus Grid a 5.000 EUR, senza guardiano, mese per mese: criteri e previsioni scritti PRIMA dei numeri (26/10/2026)
**Natura: CRITERI. Non controllata da agenti.** Richiesta di Claudio (26/10): "lo facciamo come tutti gli altri? Voglio vedere un EA gratuito come si comporta" (Arena Nexus Grid Smart XAU MT5, EA di terzi, scatola nera). Contesto dichiarato da Claudio: Arena ha messo in difficolta il conto demo e fatto perdere sul reale, con il flottante chiuso dal Guardian. **Acquisti, lotti e taglie sono decisioni di Claudio.**

## Perche non e "uguale a tutti gli altri" (differenze dichiarate)
- Gli altri nove EA sono stati provati in **una corsa continua di 21 mesi in H1**. Arena gira in **M1** ed e lentissima nel tester (EA in blocco di margine, migliaia di modifiche rifiutate): **circa 3-4 ore per un mese pieno** (misurato: settembre 2026 202 minuti, luglio 249; agosto 23 minuti perche il conto e morto il 05/08). Una corsa continua di 21 mesi costerebbe circa **70 ore**, e al primo stop out il conto del tester e finito e il resto non misura niente. Quindi: **un mese alla volta, ognuno a conto vuoto (5.000 EUR), indipendente**, come nelle tre tranche del 15-16/10. I mesi NON si sommano.
- Mesi gia misurati (14-16/10, stesso `.ex5` SHA B261E252..., stesso 5.000 EUR, M1, leva 1:100, 14 input imposti): luglio 2026 **+4.800** (DD equity 45,9%, nessuno stop out); agosto **-3.063** (stop out 05/08, DD 67,8%); settembre **-2.505** (stop out 28/09, DD 75,2%). Fonte: `ARENA_TESTER_TRANCHE_*_LETTURA_2026-10-1*.md`.
- Da misurare ora: **i 18 mesi mancanti, da giugno 2026 a ritroso fino a gennaio 2025** (ordine: giugno, maggio, ... gennaio 2026, poi dicembre 2025 ... gennaio 2025: se Claudio ferma la riga a meta restano mesi contigui e recenti). Ogni mese finito ha gia la sua cartella e il suo zip.

## Come si fa
Script `ARENA5K_MESE_TESTER.ps1` (copia di `DEEP5K_TESTER_TRANCHE.ps1` con `-Mese AAAA.MM` e `-Periodo M1`), XAUUSD, tick reali (Modello 4), **5.000 EUR**, leva 1:100 (quella che il tester usa: la leva del broker personale NON e verificata), timeout 840 minuti a mese. **Input imposti = quelli delle tre tranche del 15-16/10**: `InpS03FundedPrefix=true`, `InpEntryPhaseSpacingR33=true`, `InpMagicNumber=888`, `InpBaseLot=0.01`, `InpFridayGapProtection=false`, `InpShowDashboard=true`, `InpCounterFlowRail=true`, `InpCounterFlowTriggerPrice=0.2`, `InpCounterFlowLotMultiplier=1.0`, `InpCounterFlowMaxLivePositions=1`, `InpCounterFlowRearmDelayMilliseconds=0`, `InpDeadZoneReactionRail=true`, `InpDeadZoneReactionTriggerPrice=0.2`, `InpDeadZoneReactionRearmDelayMilliseconds=0` (valori del demo del 13/10, `MARKET_SCHEDA_FINLABX_CF_DZR_2026-10-13.md`); le due enumerazioni (`InpTradeMode`, `InpGoldPulseTheme`) restano al default come nelle tranche precedenti. **Nessun guardiano.** Lotto base 0,01 fisso (l'EA non scala il lotto base col saldo: a lotto fisso la perdita non dipende dal saldo, ma il margine si').

## Cosa si misura (per ogni mese, e nessun merito)
Netto e % di 5.000, PF, drawdown equity dal picco, **stop out** (righe del giornale e data), righe "no money", operazioni, peggior giorno, lotto massimo. In piu: la tabella dei 21 mesi (18 nuovi + 3 vecchi): mesi con stop out, mesi positivi, peggior mese.
Lettore: `backtest_pipeline/leggi_arena5k_mesi.py`, congelato prima degli zip, con `--autotest`. L'analisi dei cesti di recupero (profondita >= 10 livelli) non e nel lettore nuovo: per i mesi che interessano si usa il lettore dedicato `leggi_arena_tester.py` a parte, dichiarato.

## Previsioni dichiarate ORA
- P1: almeno 15 dei 18 mesi con corsa valida (stato OK, nessun timeout): 60%.
- P2: stop out in almeno 6 dei 18 mesi: 55%; sui 21 mesi totali la quota di mesi con stop out fra 25% e 60%: 55%.
- P3: almeno 9 dei 18 mesi con netto positivo: 45%.
- P4: almeno un mese con DD equity superiore al 60% senza stop out: 50%.
- P5: almeno 3 mesi di fila senza stop out: 40%.
- P6: nei mesi positivi la somma dei profitti e dominata da giorni piccoli e frequenti, e i mesi negativi da pochi giorni di coda (stessa forma di luglio-settembre): 70%.

## Cosa NON dice
Un mese non e un anno; il tester ha margine di circa 10.000 USD a lotto sull'oro (DERIVATO) e il margine reale BCM non e visto; niente slippage, latenza ne gap veri; il conto reale e il demo dove Arena ha sofferto sono dati reali che il tester non riproduce. Non decide se tenerla o spegnerla: lo decide Claudio.

## Aggiunta (26/10, 09:15): corsa troppo lenta, si passa al Modello 1 con calibrazione (scritta prima dei numeri)
Claudio (26/10): "troppo tempo ci vuole". I primi mesi a tick reali (giugno, maggio 2026: circa 35 minuti l'uno; aprile in corso da oltre 80 minuti) dicono che 15 mesi restanti costerebbero 10-40 ore. **Per i mesi che mancano si usa il Modello 1 (OHLC 1 minuto, il tester genera i tick), molto piu veloce, e lo si CALIBRA sui mesi che hanno entrambi i modelli.**
- **Calibrazione:** si rifanno col Modello 1 i mesi di aprile, maggio, giugno, luglio, agosto e settembre 2026 (di cui si ha il Modello 4: luglio, agosto, settembre del 15-16/10; giugno, maggio e, se finito, aprile del 26/10). **Calibrazione OK** se, sui mesi in comune (minimo 4): lo **stesso segno del netto** in almeno l'80% dei mesi **e** la **stessa presenza di stop out** in almeno l'80%. Altrimenti i mesi nuovi a Modello 1 sono NON ATTENDIBILI e lo scrivo; restano allora solo i mesi a tick reali.
- **Mesi nuovi a Modello 1:** gennaio-marzo 2026 e tutto il 2025 (15 mesi), stessa configurazione (5.000 EUR, M1, 14 input imposti, leva 1:100, nessun guardiano).
- **Cosa vuol dire:** Arena e una griglia con trigger a prezzo (0,2) e centinaia di operazioni al giorno: con soli quattro punti per barra il comportamento puo differire (INFERITO). La calibrazione serve a saperlo.
- Lettore: `leggi_arena5k_mesi.py` (con `--calibra <cartella Modello 4> <cartella Modello 1>`, congelato prima dei dati).
**Previsioni dichiarate ORA:** calibrazione OK 55%. Con calibrazione OK: stop out in almeno 3 dei 15 mesi nuovi 55%. Durata media del Modello 1: sotto 20 minuti a mese 65%.
