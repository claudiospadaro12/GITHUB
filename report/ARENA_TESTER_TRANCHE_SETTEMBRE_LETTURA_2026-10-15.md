# Arena nel nostro Strategy Tester -- SETTEMBRE (TRANCHE3), lettura del 15/10/2026 sera

Zip `ARENA_TESTER_TRANCHE.zip` del giro v4 (script `ARENA_TESTER_TRANCHE_LUNGA.ps1`, pin `24aa4bd3`, `-Tranche 3`, timeout 840 min, richiesta di veglia a Windows), PC di backtest DESKTOP-H4D7CAJ, partito 17:02, REFERTO 20:25. Archivio: `backtest_pipeline/risultati_archivio/ARENA_TESTER_TRANCHE_20261015_SETTEMBRE/` (uscita: `LETTURA_USCITA.txt`; lettura a due fonti con agosto: `LETTURA_USCITA_DUE_FONTI.txt`). Letto con `leggi_arena_tranche.py`; ipotesi H1-H4 della scheda scritte PRIMA dei numeri.

## 1. Provenienza e conformita'
- Marcatore v4 + pin v4 abbinati, data 15/10, `.ex5` UGUALE dopo la passata, **stessa SHA256 (`B261E252...`) del giro di agosto**: le tranche dei due giri si sommano.
- **TRANCHE3 CONFORME**: input tutti come dichiarato, deposito 5.000, leva 1:100, finestra 01/09-01/10, ticks reali 100%.
- **Durata 12.130 s = 202 minuti** per un mese pieno, senza sospensioni: la richiesta di veglia ha tenuto. La stima «4-5 ore» era piu' alta del vero (3,4 ore) [MISURATO].

## 2. Numeri (settembre 2026, lotto base 0,01, deposito 5.000 EUR)
- 14.629 operazioni, **netto -2.505,06 EUR, PF 0,92, DD equita' 7.551,59 EUR (75,17%)**.
- **STOP OUT il 28/09 alle 15:47 (49,84%)**: il conto del tester muore l'ultimo giorno di borsa del mese.
- 17 giorni di borsa positivi: **+11.464 EUR** in totale. 3 giorni con perdite enormi: **11/09 -3.474** (102 ingressi), **18/09 -4.686** (zero ingressi: chiusura di posizioni gia' aperte, alle 20:00 server di un venerdi'), **28/09 -5.809** (stop out). Somma dei 3: -13.969. Totale: 11.464 - 13.969 = -2.505 [torna col report].
- Cesti [R] (approssimati: 2.855 uscite ambigue su 14.629 = 19,5%): 2.587 cesti, profondita' massima **25**, peggior cesto **-5.837**. Per profondita': 1 liv. 1.437 cesti +1.649; 2: 564 +1.588; 3-4: 370 +2.715; 5-9: 163 +3.312; **>=10 liv.: 53 cesti, -11.991,56 EUR (439,6% del netto [R])**.
- Moduli [F]: CF 7.601 posizioni -92,97 (PF 0,98); FinlabX 1.470 posizioni +315,57 (PF 1,42). Gli scalp valgono +223 su tutto il mese.
- Il meccanismo e' lo stesso di agosto, a scala 13 volte piu' grande per numero di operazioni: profitti piccoli e frequenti (+11.464) contro poche code gigantesche (-13.969).

## 3. Le ipotesi, secondo le regole scritte prima (tranche conformi: agosto e settembre; luglio NON misurato)
- **H1 (stop out in almeno una tranche): REGGE** -- stop out il 05/08 (agosto) e il 28/09 (settembre).
- **H2 (somma dei cesti >=10 livelli NEGATIVA in ogni tranche conforme): REGGE su entrambe** (agosto -3.963,48 con 4 cesti; settembre -11.991,56 con 53 cesti). Netti per cesto approssimati.
- **H3 (cesti >=10 livelli in almeno due tranche su tre): REGGE** -- le due tranche conformi li hanno (4 e 53); luglio mancante non cambia l'esito (regola scritta prima: due conformi con cesti >=10 = regge).
- **H4 (le tranche senza cesti profondi guadagnano): NON SI DECIDE** -- nessuna tranche conforme senza cesti >=10.
- Per la TRANCHE3 compare due volte nella lettura (v2 senza report, v4 conforme): si usa la fonte 2 (v4), dichiarato; la fonte 1 e' NON CONFORME e non conta.

## 4. Cosa NON si puo' concludere (e cosa si')
- ❌ Il margine del tester (10.000 USD a lotto, ~1:45 [DERIVATO]) decide QUANDO muore il conto: lo stop out del 28/09 dice «a quel margine», non «il reale BCM ci andrebbe». Il margine reale dell'oro e' **[NON VISTO]**.
- ❌ Il meccanismo del -4.686 del 18/09 (zero ingressi, chiusura alle 20:00 di un venerdi') e' **[NON DIMOSTRATO]**: serve leggere le uscite di quel giorno nel report.
- ❌ Due mesi = due regimi, un feed (BCM), tester senza slippage ne' latenza (il reale e' peggiore secondo i terzi).
- ❌ Luglio non misurato (TRANCHE1).
- ✅ Il rischio di coda e' pero' misurato due volte nello stesso verso: **a lotto fisso 0,01 la perdita non dipende dal saldo**. Su un conto da 100k lo stesso 28/09 vale -5,8%, il 18/09 -4,7%, il 11/09 -3,5% [DERIVATO: sul conto grande il margine non avrebbe causato lo stop out e il cesto sarebbe rimasto aperto, non simulato]. Il limite giornaliero FTMO del nostro piano e' -5%.
- Nessuna promozione, nessuna archiviazione, nessuna taglia. L'EA resta sul demo in osservazione.
