# Copia di PROVA del Guardian v1.18 (10/11/2026) — comportamento nella pausa

`ABTG_Guardian_v118_PROVA.mq5` = v1.17 (`../copia_v1_17`) + patch P1. E una COPIA: `mql5/Experts/ABTG_Guardian.mq5` del ramo `lavoro` e la v1.17 non sono toccati. **NON compilata, NON provata in MT5** al momento della scrittura. Include richiesto: `ABTG_PausaGuardian.mqh` (INVARIATO). Criteri e previsioni: `report/CRITERI_GUARDIAN_PAUSA_2026-11-10.md`.

## Perche
Sul conto di prova FTMO 1515150476 (09-10/11) il Guardian bloccato chiamava `FlattenAll()` ogni secondo e cancellava ogni pendente di qualsiasi EA; gli EA di Wim non leggono la pausa e li rimettevano: ciclo piazza/cancella = migliaia di richieste al server. Su BCM lo stesso ciclo c'e (e solo meno visibile). Causa vista nei log e nelle schede Ordini; **NON ancora riprodotta** su un demo.

## Cosa cambia (solo la RIPETIZIONE nella pausa)
- Nuovo input `InpPauseMode`: **0 (default) = identico alla v1.17**. Con 0 il comportamento e il giornale non cambiano.
- Allo scatto (limite sfondato, o inizio della finestra del venerdi) si fa SEMPRE un `FlattenAll()` completo, come prima.
- **Le posizioni aperte si chiudono SEMPRE entro 1 secondo, in tutti i modi.** Se la chiusura e rifiutata (mercato chiuso ecc.) riprova al massimo ogni `InpPauseRetrySec` (30 s) invece di ogni secondo.
- Dopo lo scatto, per i pendenti:
  - modo 1: cancella solo quelli entro `InpPauseNearPct` (1%) dal prezzo; gli altri restano;
  - modo 2: non cancella nessun pendente;
  - modo 3: cancella tutti, al massimo ogni `InpPauseEverySec` (60 s).
- Tetto `InpPauseMaxDelDay` (300): cancellazioni di pendenti al giorno dal Guardian dopo lo scatto (modi 1-3). Le posizioni non hanno tetto.
- Log: nei modi 1-3 niente riga per ogni cancellazione; una riga di riepilogo ogni `InpPauseLogSec` (300 s) solo se ha agito, con le richieste fatte dal Guardian (riuscite + rifiutate).
- Stessa funzione per lo stato BLOCCATO/FALLITO e per la chiusura del venerdi (due "slot", cosi non si disturbano).
- Autotest: 14 casi nuovi (`AutotestPausa`, funzioni pure) con `InpAutotest=true`.

## Limiti dichiarati (NON VERIFICATI)
- Un pendente lasciato vivo (modi 1-3) che scatta diventa posizione e viene chiuso entro 1 s: la perdita extra e lo slittamento di quel secondo. Va MISURATA (criterio: < 0,3% extra, chiusura < 5 s).
- Gli EA possono continuare a modificare i propri pendenti o a ripiazzarli: il Guardian non li ferma, riduce solo le sue cancellazioni (previsione P6 dei criteri: 15%).
- Il contatore v1.17 (`OnTradeTransaction`) probabilmente non vede le richieste rifiutate: il riepilogo del Guardian le conta a parte.
- Effetto sul conteggio di FTMO: non provabile senza un conto FTMO.

## File
- `ABTG_Guardian_v118_DEMO_MODO0..3.set`: set per il DEMO BCM 50504894. `InpAction=0` (chiude davvero), `InpDailyLossPct=0.1` (soglia ABBASSATA per far scattare il blocco in pochi minuti), contatore acceso. UTF-16 come gli altri set.
- `ABTG_Guardian_v118_DEMO_AUTOTEST.set`: come il modo 0 ma con `InpAutotest=true`, `InpAction=1` (SOLO ALLARME, non chiude niente) e soglie normali (passo 1: all'avvio scrive i casi nel giornale).
- Riga di compilazione: `backtest_pipeline/righe/RIGA_COMPILA_GUARDIAN_V118.txt`.

## Piano di prova (solo demo, con l'ok di Claudio; mai reale, mai trial FTMO, mai VPS)
1. Compila, autotest. 2. Due ore con modo 0 (riferimento: deve riprodurre il ciclo). 3. Due ore ciascuno per i modi 1, 2, 3. Letture e soglie: criteri.

## Esito (10/11/2026)
- **Compilazione** (PC di backtest, MetaEditor): 0 errori, 0 avvisi, `.ex5` 114.086 byte (SHA256 `733E8BB15928400272DC5569A6408CD78FAF8E97C670480FBA28401DDF87CAF9`). Prevista come "al primo tentativo senza errori" al 60%: riuscita.
- **Autotest** (grafico NASUSD_EXT M15, demo BCM 50503392 del PC di backtest, set `DEMO_AUTOTEST`, solo allarme, 17:38-17:39): i **14 casi nuovi della pausa: 14 PASS** (atteso = ottenuto). Visibili e PASS anche i casi del contatore richieste da "POSITION con deal NON conta" a "soglie a 0 = spente". I casi piu vecchi (baseline, esposizione, venerdi) non erano nella foto: NON LETTI.
- **Cosa NON prova**: sono funzioni pure. Il comportamento vero di `PausaEnforce` (cancellazioni, chiusure, tetto, riprova dopo rifiuto) non e ancora stato visto su un conto con gli EA. Resta da fare la prova dei modi 0-3 su un demo con ciclo riproducibile.
- Nota: il conto del PC e minuscolo (equity circa 11 EUR), quindi il cap sul rischio aperto risulta attivo (111,97%): effetto del conto, non del codice.
