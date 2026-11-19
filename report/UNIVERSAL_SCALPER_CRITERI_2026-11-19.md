# Universal Scalper Pro (Pine v5, indicatore, incrocio EMA 9/21 + ADX) — audit e criteri scritti PRIMA dei numeri (19/11/2026)
Sorgente incollato da Claudio nella chat (nessuna fonte esterna; l'autore del titolo dice "Update 26.11.2025"). Indicatore con tabella e alert, non una strategia: nessun backtest dentro.
## Audit (dal codice)
- **Regole:** LONG = EMA9 incrocia sopra EMA21 con ADX(14) > 12; SHORT al contrario. SL = 1,5 ATR(14), TP = 2,0 ATR(14) dal close della barra del segnale. Nessuna uscita per inversione, nessun filtro orario.
- **Repainting:** nessun `request.security`/lookahead. L'incrocio e l'etichetta sulla barra in formazione compaiono e possono sparire (a ogni tick); l'alert usa `alert.freq_once_per_bar_close` (corretto), gli alertcondition no. **Usare i segnali solo a barra chiusa.**
- **Difetti:** la tabella dichiara "Trend (15m)" ma usa il timeframe del grafico; il messaggio degli alert dice sempre "XAUUSD"; lo stato "TARGET HIT" controlla solo il target e mai lo stop (una posizione stoppata non risulta mai perdente) e puo' scattare gia' sulla barra del segnale; ADX > 12 e' una soglia bassissima (non filtra quasi nulla).
## Test
XAUUSD ed EURUSD **M15** da M1 FTMO 2014-11 / 2020-12 (riga 00:00 aggregata scartata). IS = primi 70% delle barre (fino a fine feb 2019), OOS = ultimo 30%. Costi all-in: oro 0,35 USD, EURUSD 1,0 pip. Ingresso all'apertura della barra successiva al segnale; SL 1,5 ATR e TP 2,0 ATR dai livelli del segnale; stop prima del target nella stessa barra; una posizione alla volta (segnali ignorati mentre si e' in posizione); uscita a tempo dopo 300 barre. R = distanza dello stop. Parametri di default dell'autore, **nessuna ottimizzazione**. Controllo di robustezza con timeframe H1 (stessi parametri).
**Porte (di Claudio, immutate):** IS PF >= 1,5, DD <= 15%, >= 100 operazioni; VALIDATO se OOS PF > 1,2, R > 0, >= 30 operazioni, su entrambi i mercati.
## Previsioni
- Nessun mercato/timeframe validato: **97%**.
- PF IS < 1,1 su oro M15 e su EURUSD M15: **85%** (costi su stop da 1,5 ATR M15 sono alti: ATR M15 oro circa 2-3 USD, EURUSD circa 5-8 pip).
- Win rate 40-45% (TP 2 ATR contro SL 1,5 ATR): **75%**.
## Limiti
6 anni, 2 mercati, nessun tick; il vero scopo dell'autore (scalping dal vivo con tabella) non e' misurabile; non si e' provato altro timeframe oltre M15/H1.

## ESTENSIONE chiesta da Claudio (tutti i simboli, tutti i TF, nuove uscite) — criteri scritti PRIMA dei nuovi numeri
**Risultato gia' visto (uscita dell'autore, SL 1,5 ATR / TP 2 ATR, default, nessuna ottimizzazione):** oro M15 PF 0,72, EURUSD M15 0,81, oro H1 0,85, EURUSD H1 0,91; in tutti i casi R medio < 0 e IS e OOS concordi: nessun mercato validato; previsioni 1-3 giuste (win rate 42-43%).
**Simboli e TF testabili qui:** XAUUSD, EURUSD (FTMO 2014-11 -> 2020-12), NASUSD, SPXUSD (storico esterno 2015-2024; costi 2,0 e 0,7 punti); TF **M5, M15, M30, H1, H4** (D1 produce troppo pochi segnali). **Gli altri simboli del Market Watch BCM non sono in questa sessione: servono un EA MQL5 (port non scritto) e il tester sul PC.**
**Cinque uscite, stesso ingresso (incrocio EMA 9/21 con ADX > 12 a barra chiusa, ingresso all'apertura successiva, una posizione alla volta):**
- **A** = autore: SL 1,5 ATR, TP 2,0 ATR.
- **B** = cambio di segnale: si esce e si inverte sull'incrocio opposto valido (EMA e ADX), nessuno stop; R convenzionale = 1,5 ATR.
- **B2** = come B con stop di protezione 1,5 ATR (R reale).
- **C** = Heikin-Ashi: uscita al cambio di colore della candela HA a chiusura barra (long esce alla prima candela HA rossa, short alla prima verde), nessuno stop; R convenzionale 1,5 ATR; uscita all'apertura della barra successiva.
- **C2** = come C con stop di protezione 1,5 ATR.
Costi all'uscita e all'ingresso come prima (un costo all-in per operazione), in R. IS = primo 70%, OOS = ultimo 30%.
**Porte (di Claudio, immutate):** IS PF >= 1,5, DD <= 15%, >= 100 operazioni; VALIDATO se OOS PF > 1,2, R medio > 0, >= 30 operazioni. **100 combinazioni (4 mercati x 5 TF x 5 uscite): per solo caso se ne attende qualcuna con PF IS > 1,2; conta solo l'OOS.**
## Previsioni
- Nessuna combinazione validata: **96%**.
- Almeno una combinazione con PF IS >= 1,2 e >= 100 operazioni: **45%** (confronti multipli); tenere l'OOS con PF > 1,2: **4%**.
- Le uscite B/C (senza stop) migliorano il PF rispetto ad A in almeno la meta' dei casi: **50%**; i TF alti (H1, H4) hanno PF migliore dei bassi (M5, M15) a parita' di uscita: **75%** (costo relativo minore).

## RISULTATI ESTESI (`backtest_runner/simulatore/universal_scalper_all.py`; XAUUSD/EURUSD FTMO 2014-2020, NASUSD/SPXUSD 2015-2024; 100 combinazioni)
- **0 combinazioni su 100 con PF IS >= 1,2 e >= 100 operazioni; nessuna VALIDATA.** R medio IS negativo in 96 combinazioni su 100 (mediana -0,13).
- **Per uscita (PF IS mediano):** A (SL 1,5/TP 2) 0,79; B (cambio di segnale) 0,86; B2 (cambio di segnale + stop) 0,85; C (cambio colore Heikin-Ashi) 0,70; C2 0,72 (PF OOS mediano: 0,82 / 0,95 / 0,97 / 0,84 / 0,84). **Il cambio di segnale e' la migliore, ma tutte sotto 1; il cambio colore HA e' la peggiore sui TF bassi** (oro M5: B 0,62 contro C 0,37; M15: 0,84 contro 0,56).
- **Per TF:** piu' il TF e' alto meno si perde (costo relativo minore): PF IS mediano M5 0,51 (massimo 0,72); M15 0,76 (0,88); M30 0,79 (0,93); H1 0,88 (1,00); H4 0,85 (1,20). Le ottime cifre OOS isolate (EURUSD H4 A 1,82; oro H4 C2 1,26) hanno IS < 1,2 e 40-100 operazioni: non convalidano.
- Previsioni: nessuna validata (96%) -> si'; almeno una IS >= 1,2 con >= 100 op. (45%) -> no; B/C migliorano A in almeno meta' dei casi (50%) -> **B si', C no**; TF alti meglio dei bassi (75%) -> si'.
**Verdetto: Universal Scalper Pro non ha vantaggio su oro, EURUSD, Nasdaq e S&P a nessun timeframe M5-H4, con nessuna delle tre logiche di uscita.** Non testati gli altri simboli del Market Watch BCM (dati non disponibili qui).
