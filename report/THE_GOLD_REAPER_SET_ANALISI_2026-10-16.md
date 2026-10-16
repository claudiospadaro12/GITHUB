# The Gold Reaper MT5 (Profalgo) -- analisi del set «propfirm» portato da Claudio (16/10/2026)

Fonte: `data/set/THE_GOLD_REAPER_propfirm_set_2026-10-16.set` (88 righe). Commento `ST1_Comment=The Gold Reaper`, magic 8000. Le righe `,1= ,2= ,3= ,F=` sono i campi dell'ottimizzatore (start/step/stop/flag), il valore usato e' la riga senza suffisso.

## 1. Cosa dice il set [LETTO]
- `MaxSpread=500` (punti): su XAUUSD a 2 decimali sono 5,00 USD; lo spread normale BCM e' 0,21-0,29 USD (21-29 punti) con spike misurati a 1,5-2,9 USD: **quasi nessun filtro**.
- `FridayStopHour=25`: ora impossibile = **nessuno stop del venerdi'** (posizioni e pendenti tenute nel weekend).
- `StartLots=0.01`; `Risk=1234` (valore NON interpretabile: non puo' essere una percentuale; da leggere dalla scheda Parametri); `MaxAllowedDD=9` (%); `PropFirmMaxDailyDD=4` (%); `UseEquity=0`; `OnlyUp=0`; `CheckMargin=1`; `TradeFrequency=2` (enum, significato ignoto); `setSL_TP_After_Entry=0`; `Virtual_expiration=1`; `Randomization=0`.
- **Il set NON contiene i parametri delle strategie** (SL, TP, trailing, livelli, ST2..ST8): si ferma alle impostazioni generali e di lotto. Senza quelli non si puo' dire se ci sia stop loss iniziale ne' come e' fatto il meccanismo.

## 2. Cosa dicono le fonti esterne (DICHIARATO DA TERZI, non verificato da noi)
- Recensione indipendente sul blog MQL5 (Diego Arribas Lopez, DoItTrading, 14/10/2026, versione 4.6; dichiara di non essere affiliato ma ha link di affiliazione a un broker e vende un EA concorrente): **8 strategie** di breakout sull'oro con ordini pendenti oltre livelli (giornalieri, H4, H1); backtest a 0,01 lotti per strategia su conto di riferimento 4.000 USD, XAUUSD feb 2020-set 2026, OHLC 1 minuto, commissioni zero: profitto 9.578,50 USD, **DD storico peggiore 8,46% (circa 339 USD)**; con tick reali (nov 2025-apr 2026) win rate da 78,26% a 71,38% e DD in denaro da 219,57 a 243,74; stress test su 1.000 scenari: **664 su 1.000 superano il DD storico, P95 14,34%, P99 17,89%**; su conto da 600 USD a lotti fissi il P95 e' il 95,6% del conto. Segnale pubblico +309% dal 2024 con DD di saldo 16,89% (altro broker, versione piu' vecchia). Strategie 6 e 7 si sovrappongono nei giorni in perdita. Valutazione 4,45 su 5 con 115 voci (28/09). Non riporta PF ne' numero di operazioni; non parla di SL ne' di griglia/martingala.
- `MaxAllowedDD` e', secondo quella recensione, «un input di dimensionamento, non un tetto a cio' che puoi perdere»; il controllo del DD giornaliero «puo' chiudere posizioni e ordini pendenti» (documentato dal venditore, non letto da noi).
- Altre fonti trovate dalla ricerca (blog commerciali, non apribili da qui): prezzo 539-599 USD, affermazioni di «nessuna martingala/griglia», DD live 30-41% e PF live 1,08 [NON VERIFICATI, fonte promozionale].
- Attenzione: esistono prodotti con nome simile (Gold Reaper EA di altro autore, Gold Reaper X / X Pro a griglia/recovery): NON sono questo.

## 3. Aritmetica prop con i numeri dichiarati [DERIVATO]
- Rendimento backtest a 0,01 lotti: 9.578 USD in 6,6 anni = circa 1.451 USD/anno = circa 3,0% al mese su 4.000 con DD storico 8,5%.
- Per un obiettivo del 10% in un mese servirebbe circa 3,3 volte quel lotto: DD storico circa 28% e P95 circa 47%: **incompatibile con un DD totale del 10%**. Su 100k a 0,01 l'EA e' minuscolo (DD circa 0,3%, profitto circa 0,1% al mese). Il pareggio fra obiettivo e rischio dipende dai limiti di tempo della singola prop [NON VERIFICATO: regole correnti].
- Il limite interno `PropFirmMaxDailyDD=4` sta sotto il 5% giornaliero tipico, ma con `UseEquity=0` NON e' chiaro se misura l'equita' (flottante compreso) o il saldo; un limite sul solo saldo non vede le perdite flottanti [DA VERIFICARE nella documentazione dell'EA].

## 4. Che cosa manca per una misura di casa (e cosa costa)
1. Il set COMPLETO (tutti i parametri, strategie ST1-ST8) o la scheda Parametri dell'EA.
2. Il significato di `Risk=1234` e `TradeFrequency=2`.
3. Installare l'EA sul terminale del PC di backtest: se serve l'acquisto (circa 540-600 USD) **spendere soldi e' decisione di Claudio**; la versione demo del Market gira solo nel tester [NON VERIFICATO che includa tutte le funzioni].
4. Prova nel tester sui mesi gia' usati per l'Arena (luglio, agosto, settembre 2026, barre BCM) con attese e criterio scritti prima, piu' un mese fuori campione.
