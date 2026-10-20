# Prova: l'EA "oro M15, PF 2,79" dei colleghi (versione 1.40) -- protocollo scritto PRIMA di vedere file o numeri (20/10/2026)

**Non controllata da agenti.** Dichiarazione dei colleghi (screenshot di un riassunto scritto da un agente, non un report del tester): oro M15, ticks reali, "set 2025 - ott 2026" (periodo ambiguo: da settembre 2025 o da gennaio 2025), 50.000 EUR, PF 2,79, netto +9.314,41 (+18,6%), 61 operazioni (34 vinte 55,7%, media +427 / -193), DD 1.375 (2,33%), Sharpe 7,71. Il numero di versione 1.40 suggerisce molte iterazioni sulla stessa storia (da chiedere).

## Cosa serve (da chiedere ai colleghi)
1. Sorgente `.mq5` della 1.40 (o `.ex5`) e il set; 2. report `.htm` completo del tester con periodo, deposito, spread e modello di tick; 3. quante versioni sono state provate e su quali date; 4. su quale broker/feed.

## Blocchi di dati sul nostro tester BCM (ticks reali dal 10/07/2024)
- **A (sviluppo, gia' visto dai colleghi, da dichiarare)**: la loro finestra.
- **B (fuori campione precedente)**: 2024.07.10 -> inizio finestra loro (se inizia nel 2025): MAI visto da loro; si usa UNA volta.
- **C (confronto)**: la loro stessa finestra sul nostro BCM, per vedere quanto cambia con broker/feed diversi.
## Soglie bloccate ORA (valgono su ognuna delle prove; nessun ritocco dopo i numeri)
- **S-N**: >= 150 operazioni sulla finestra piena (A+B). Con 61 su A l'EA e' "NON MISURATO" finche' non si allunga la storia.
- **S-M / S-H / S-DD / S-COSTO / costo doppio / latenza (1000 ms)**: come per gli altri EA (netto > 0, PF > 1,10 al costo doppio e a 1000 ms; >= 60% mesi positivi; perdita dal deposito <= 10%, DD <= 15,2%; media per operazione >= 3 volte lo spread).
- **Fuori campione (B)**: PF > 1,10 e netto > 0; una corsa sola. Se fallisce, il PF 2,79 e' in-sample e lo si scrive.
- Regola multi-versione: se i colleghi hanno provato N versioni sulla stessa finestra, il PF di A non conta come prova; vale solo B.
## Previsioni dichiarate ORA
- **E1**: l'EA ha meno di 150 operazioni sulla finestra A+B; fiducia alta (61 gia' sono tutte quelle di A).
- **E2**: il PF sul blocco B e' sotto il 60% del PF di A (cioe' < 1,7); fiducia media.
- **E3**: con costo doppio e latenza 1000 ms il PF resta > 1,10 su A (poche operazioni grosse: media +427 EUR su una perdita media di -193).
- **E4**: lotti molto piu' grandi della media dei nostri EA: media vinta +427 su 50.000 EUR implica lotti di ordine 0,3-1,0 sull'oro; da leggere dal report.
