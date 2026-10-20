# The ORB Master, giro V2 corretto (preset prop, 4 indici con DAX, 80K): lettura (20/10/2026)

**Non controllata da agenti.** Previsioni scritte prima: `ORB_MASTER_TEST_ATTESE_2026-10-20.md` (aggiornamento V2). Dati: `risultati_archivio/ORBM_V2_20261020/`. Calcoli miei (non lo strumento congelato). Confronto: `CONFRONTO_DATI_MEMORIZZATI_80K_2026-10-20.md`.

## Conformita'
Tre corse continue 01/01/2025-01/10/2026, EURUSD M15, 80.000, ticks reali 100% (49,4 milioni di tick), **stato OK in tutte e tre, input imposti e verificati (input_ok = si)**, nessuno stop-out, durata 26-32 minuti ciascuna. DAX incluso con `DAX_Symbol=D30EUR` (opera). Il preset resta quello prop del 23/08 con gli input che la v3.4 ha (`MaxRisk_Strategy=2`, `PropFirmMaxDailyDD=4.0`); i parametri del DAX sono i default del venditore.

## Numeri
| | T1 modo venditore (AutoGMT_Backtest si, 2/3) | T2 manuale 1/1 (BCM UTC+1) | T3 manuale 2/3 (offset sbagliato per BCM) |
|---|---|---|---|
| operazioni | 1.890 | 1.884 | 1.208 |
| netto | **-239,07** (-0,3%) | -69,18 (-0,1%) | -891,21 (-1,1%) |
| PF | **0,97** | 0,99 | 0,81 |
| DD equity (% degli 80.000) | 1.473 (1,8%) | 1.454 (1,8%) | 1.140 (1,4%) |
| mesi positivi | 10/21 (48%) | 10/21 (48%) | 8/21 |
| gen25-mag26 / giu26-set26 | +471 / -710 | +641 / -710 | -978 / +87 |
Per simbolo (T1): D30EUR 758 op., +170, PF 1,08; NASUSD 447, +47, PF 1,04; SPXUSD 345, -141, PF 0,93; U30USD 340, -316, PF 0,87. Lotti: D30EUR 0,1-0,2; NASUSD 0,1-0,2; U30USD 0,1; SPXUSD 0,5-1,0 (per simbolo rapporto massimo 2; non scalano col saldo). Posizioni contemporanee massime 9 (T1, T2). Taglia minuscola: i numeri in euro non dicono niente da soli, **il PF si**.
- **Correlazione giornaliera dei realizzi** (T1, T2): con Prop Firm +0,05 / +0,08, con Gold Reaper -0,03 / -0,01. Scorrelato dall'oro, ma la serie e' piatta: "scorrelato" senza rendimento non serve.
- **Sensibilita' all'orologio (S-ORA)**: T3 contro T2 sono la stessa strategia con l'ora spostata di 1 ora: operazioni -36%, netto da -69 a -891, **SPXUSD da PF 0,90 a 0,49**, il DAX entra 1-2 ore dopo (09-10 server invece di 07-09). Con BCM che passa a UTC+1 = ora italiana da 26/10 (DAX) e 02/11 (USA) e un EA configurato con l'offset del venditore, il rischio di operare a un orario sbagliato e' reale. [Qui il modo "venditore" T1 ha dato orari corretti anche con offset 2/3, per merito di AutoGMT_Backtest; sul conto vero AutoGMT legge l'orario da worldtimeserver.com: comportamento su BCM NON MISURATO.]

## Previsioni V2 (scritte prima)
V2-1 (input applicati): **confermata** (3/3). V2-2 (DAX >= 40 operazioni): **confermata** (676-758). V2-3 (indici USA entro +/-3% del V1): **confermata** (345/340/447 identiche). V2-4 (T1, T2, T3 non identiche): **confermata**. V2-5 (T3 entra circa un'ora piu' tardi): **confermata** (DAX 09-10 contro 07-09). V2-6 (PF di T1 fra 0,85 e 1,15, PF >= 1,3 improbabile): **confermata** (0,97).

## Cancelli (T1, la configurazione dichiarata)
S-N 1.890 ok; **S-M 48% < 60%: NON passa**; **S-H giu26-set26 -710 < 0: NON passa**; S-DD ok (1,8%); S-NOSCALA ok (per simbolo <= 2; 9 posizioni); S-COSTO: profitto medio per operazione negativo, **NON passa**; **PF 0,97 < 1: nessun vantaggio visibile**.
## Conclusione (regola scritta il 20/10: se il PF sta fra 0,85 e 1,15 si archivia come "nessun vantaggio visibile" senza provare altri preset per sceglierne uno)
**The ORB Master col preset prop non mostra un vantaggio: non si compra per questo**. Limiti dichiarati: preset del 23/08 (v3.4 ha parametri nuovi che non conosciamo), DAX con default, l'EA ha preset a rischio diverso (alto/medio/basso) dei quali non cambia il PF in modo prevedibile (il PF e' scale-invariante: se la logica non ha vantaggio, anche gli altri livelli di rischio non lo creano), nessun test a ticks diversi. Se il venditore pubblica set v3.4 aggiornati si puo' riprovare UNA volta, con previsioni scritte prima.
