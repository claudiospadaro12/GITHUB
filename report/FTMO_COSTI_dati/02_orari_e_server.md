# 02 - Orari e server (tabella B)

## Orario del server MT4 / MT5

- Dalla FAQ "Quali sono le specifiche dell'account?" (https://ftmo.com/en/faq/what-are-the-account-specifications/): "MetaTrader 4, MetaTrader 5 = GMT+2 + Ora legale". Testo letto nel browser, in italiano.
- cTrader e TradingView: orario personalizzato dal trader. Non è un orario fisso.
- Cambio ora legale: la FAQ dice che il server è GMT+2 con ora legale applicata. Nelle comunicazioni FTMO del 2026 (snippet di ricerca, non aperte) compaiono anche indicazioni "GMT+3" durante l'ora legale europea. Esempio: dall'8/03/2026 il server è indicato GMT+3 / CET+2. Non è chiaro se la FAQ sia aggiornata a questa convenzione. STATO: AMBIGUO.
- Dato per l'11/11/2026: dopo la fine dell'ora legale europea di fine ottobre, il server dovrebbe tornare a GMT+2 (CET+1). Da verificare nel terminale (Ora server nella finestra Navigatore o nella barra di stato).

## Orari di trading (scheda Simboli, GMT+2)

| strumento | lun-ven | sab-dom | note | fonte | stato |
|---|---|---|---|---|---|
| XAUUSD (CFD metalli) | 01:05 - 23:50 | chiuso ("trading is closed") | Il gap 23:50-01:05 non è dichiarato come pausa; è solo la differenza fra le due colonne. Da verificare | https://ftmo.com/en/symbols/ | AMBIGUO |
| Coppie Forex (scheda Forex) | 00:05 - 23:55 | chiuso | valido per tutte le 28 coppie | https://ftmo.com/en/symbols/ | CHIARO per gli orari dichiarati |
| XAGUSD | 01:05 - 23:50 | chiuso | | https://ftmo.com/en/symbols/ | CHIARO |
| XCUUSD (rame) | 01:05 - 23:00 | chiuso | | https://ftmo.com/en/symbols/ | CHIARO |

Nota: la pagina dice che il conto alla rovescia per la chiusura del mercato "non tiene conto" di modifiche di orario, manutenzioni o aggiornamenti pubblicati nella pagina Trading Updates. Per questo gli orari della scheda vanno confrontati con gli aggiornamenti.

## Chiusura del weekend

- Forex e XAU: sabato e domenica risultano "trading is closed" nella scheda Simboli.
- Chiusura del venerdì (ora precisa): NON TROVATA. La scheda dà 23:55 per il Forex e 23:50 per l'oro, ma non dice il significato di questi orari rispetto alla chiusura del weekend.
- Apertura della domenica sera: NON TROVATA.

## Pausa giornaliera dell'oro

- La pausa non è dichiarata come tale. Lo stacco 23:50-01:05 è deducibile dalla tabella. STATO: AMBIGUO.

## Festività

- Gli aggiornamenti di trading (es. "President's Day" 16/02/2026, "Martin Luther King Jr. Day" 19/01/2026) cambiano gli orari. Sono riportati solo da snippet di ricerca, non da pagine aperte. Vedi 03.

## Pagine non lette
- Articoli "Holding trades over the weekend?" e "What's consuming all your profits?": NON LETTI.
