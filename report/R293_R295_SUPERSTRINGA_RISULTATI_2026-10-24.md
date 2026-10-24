# R293-R295: superstringa notturna (23-24/10/2026)
**Natura: MISURA.** Pin `20243263`, PC di backtest DESKTOP-H4D7CAJ, tick reali, finestra B 2024.09.26-2026.06.30 (taglio 0,40), celle = sedie in campo sul piccolo senza Guardian. 13 file, 25 minuti. Motore = pin (SHA256) in tutti e 13 (RIEPILOGO). Gemelle G1 OK su tutti. Criteri e lettore (`r293_giudizio.py`) scritti prima dei numeri. Archivio: `backtest_pipeline/risultati_archivio/R293_20261024`.

## R293a: G0 di R292 CHIUSO
Originale `ABTG_MaxMinNotte`, motore = pin: IS 223,45 / PF 1,53877 / DD 2,1272 / 74 e OOS 622,22 / PF 1,94266 / DD 3,8721 / 79, **identici al centesimo** a R292a, R292b, R292c. La variante a flag spento e acceso e' l'originale; il "motore diverso" di R292a era un mio errore di trascrizione dello SHA.

## R294: EMA200_Ottimizzato 971501 su AUDCHF H4 (prima misura a tick)
| | IS | OOS |
|---|---|---|
| AUDCHF (R294a) | PF 0,91448 / 103 deal / netto -10,35 / DD 1,16% | PF 0,66270 / 136 deal / netto -68,56 / DD 1,81% |
| oro, stessa cella (R294b) | PF 0,79773 / 29 deal / -54,82 / DD 2,20% | PF 2,14601 / 56 deal / +581,61 / DD 8,03% |
- **AUDCHF: NEGATIVA** (PF < 1 in IS e OOS), con >= 100 deal in entrambe le gambe, quindi NON solo descrittivo (mia attesa "meno di 100 deal" sbagliata). Rischio 0,25%, deposito 5400. Un solo regime; lo storico tick AUDCHF del broker NON e' verificato.
- Oro: **DIVERSO** dal vecchio scan (IS 0,65795 / 39; OOS 1,49468 / 67) per il criterio scritto (PF entro 0,10, deal entro 20%). Come dichiarato prima non e' un G0: rischio 1% contro 0,25%, deposito storico non dichiarato, EA cambiato dopo il 19/09. Non se ne deduce altro.

## R295: deposito 5400 contro 100.000 (stessa cella, rischio di campo, H1)
| Cella | verdetto | dPF IS / OOS | trade 5400 = 100k (IS / OOS) |
|---|---|---|---|
| EasyTrend 772421 CHFJPY | REGGE (descrittivo) | +0,042 / -0,044 | 31=31 / 53=53 |
| EasyTrend 772422 GBPUSD | REGGE (descrittivo) | -0,002 / -0,009 | 26=26 / 41=41 |
| PTE 771322 GBPUSD | MISTO (descrittivo) | +1,314 / -0,041 | 20=20 / 49=49 |
| PTE 771332 GBPUSD | MISTO (descrittivo) | +0,533 / -0,038 | 20=20 / 51=51 |
| BreakingBand 772161 GBPUSD | REGGE (descrittivo) | +0,052 / +0,036 | 13=13 / 26=26 |
- Tutte e 5 le celle: **numero di trade identico** nei due depositi in entrambe le gambe (nessun ordine perso per lotto minimo, in questa finestra). Tutte descrittive (< 100 deal).
- I due MISTO sono un artefatto da leggere: la gamba IS di PTE ha PF 41,8 / 40,5 (771322) e 40,7 / 40,1 (771332) su 20 deal, cioe' quasi nessuna perdita, e il PF esplode con un denominatore minuscolo. Il rendimento sul deposito IS e' quasi uguale (2,33% contro 2,39%; 1,27% contro 1,32%). Il verdetto meccanico resta MISTO come scritto prima.
- L'OOS dei due PTE e' lievemente sotto a 5400 (rendimento 0,91% contro 1,04%; 0,50% contro 0,58%): descrittivo, nessuna soglia superata.
- Misura l'esecuzione sul tester, NON i lotti realizzati (il per-trade dei lotti non e' stato letto) e non il merito.

## Scoreboard delle attese dichiarate prima
M passa 92%: SI. G0 se M passa 90%: SI. AUDCHF < 100 deal 90%: NO (103/136). AUDCHF POSITIVA 35%: NO (NEGATIVA). Oro coerente 40%: NO. R295: REGGE 3 su 5, MISTO 2 su 5 (attesa per cella 55% / 15%); EasyTrend CHFJPY REGGE 40%: SI.

## Decisioni di Claudio (non mie)
971501 su AUDCHF (misura negativa a tick in questa finestra) o sull'oro o spenta; resto del giro 2 invariato (rischio vero a 0,01 lotti sull'oro, GBPUSD aggregato, Guardian sul piccolo). Nessuna taglia consigliata.
