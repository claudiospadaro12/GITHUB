# GBA R2S, ARGENTO A M30 / H1 / H4 (R-XAG-1, Modello 1, T1): lettura dello zip (13/10/2026)

Fonte: `GBA_R2S_XAGH.zip` (SHA256 `a63bda42e3dee4c6df515af75049eced0724f737795169096b16e9fd4ec8d1c7`), riga `4d0064d4…` al pin `f6571dcc`, PC di backtest, 16:59-17:40 (41 minuti), rc 3.
Letto con D2 v4 (`1697135a…`, PASS) e con `leggi_gba_r0.py` (`9cd02d2a…`, G0). Archivio: `backtest_pipeline/risultati_archivio/GBA_R2S_XAGH_20261013/`. Nessun candidato archiviato; caselle 4 e 5 dell'argento **NON ANCORA MISURATE**.

## 1. Esiti per cella (albero H0-H3 di D2, il primo che vale decide)
| cella | stato passata | righe segnale | ingressi | C3G (mediana stop/spread, solo spread) | BUY / SELL | righe >= 40x | esito D2 |
|---|---|---:|---:|---:|---|---:|---|
| M30 | **KO: timeout 20 min, report assente** | 177 | 1 | 17,90x | 18,25 / 17,30 | 4 | **H0 (C): non si legge** |
| H1 | **KO: timeout 20 min, report assente** | 91 | 1 | 26,30x | 25,70 / 27,35 | 8 | **H0 (C): non si legge** |
| H4 | OK (33 s) | 26 | 10 | **52,20x** | 57,15 / 51,10 | 25 (17 a >= 50x) | **H3 (B): n insufficiente** (n 10 < 30), NON "escluso" |

- CE1H e CE7H verdi (ancora del 12/10 verde; 353.614 tick in tutte e tre le passate), CE9 e CE10 verdi per cella. CE6 rosso su M30 e H1 solo perche' manca l'n del report.
- Ordine di grandezza del C3G al crescere del TF (argento, solo spread, tranche diverse ma stesso trimestre per le celle di questa lettura): M1 2,40 · M15 11,95 · M30 17,90 · H1 26,30 · H4 52,20 [DERIVATO]. Cresce piu' della radice del tempo, come gia' osservato fra M1 e M15; **a H4 supera la frontiera 40x del solo spread**.
- Frequenza a H4: 10 ingressi in un trimestre = 0,15 al giorno [MISURATO, G0]. Con un solo trimestre non si dice nulla su una famiglia: serve il TF a campione piu' lungo, non una griglia.
- PF H4 0,00 e netto -26.773 EUR a **1,00 lotto di argento**: sono numeri di SCREENING a Modello 1 su 10 posizioni (deposito fittizio 1.000.000), mai merito, e non dicono nulla sull'edge. Non si leggono.

## 2. Due stalli su tre passate: fatto da scrivere
- Le passate M30 e H1 hanno finito il test in **meno di un secondo** (log del tester: 16:59:48 e 17:20:01, "Test passed in 0:00:00.914" e "0:00:00.513") ma il terminale non si e' chiuso: la riga l'ha chiuso dopo 20 minuti con `CloseMainWindow` e il report .htm non c'e' [MISURATO: log del tester in `GBA_R0_R2SXAGH.zip`].
- Prima di oggi: 2 stalli su circa 337 passate di questo PC. Qui **2 su 3** nello stesso lotto. [INFERITO] non e' il caso a tasso 0,6%: la probabilita' di >= 2 su 3 a quel tasso e' dell'ordine di 10^-4. Che cosa distingue M30/H1 da H4 non e' dimostrato: ipotesi non misurate = (a) le due passate stallate avevano 1 solo ingresso ciascuno, (b) l'EA lascia aperta una posizione a fine test (saldo finale identico 1.000.008,33 EUR nelle due, con 1 ingresso ciascuno: plausibilmente lo stesso trade). **Nessuna delle due e' stata messa ad asse.**
- Conseguenza pratica: M30 e H1 vanno **rifatte da sole**, una passata per volta, per avere il report. Il costo e' di circa 1 minuto a passata se non stallano. Il rilancio passa dal cancello (nuovo file prova per le sole celle M30 e H1, stessa tranche, stessa attesa scritta prima).

## 3. Un difetto del LETTORE (leggi_gba_r0.py), trovato leggendo: la riga di costo "con commissione" sull'argento usa la conversione dell'ORO
- Nella sezione (3) COSTO il lettore calcola `+0,04 USD/oz (3,90 EUR a giro)` e `+0,08 USD/oz`: `COMM_USD_OZ = (0.04, 0.08)` e' la conversione dell'oro (3,90 EUR a lotto ~ 4,5 USD su 100 once = 0,045 USD/oz). **Sull'argento il contratto e' piu' grande**: dalla perdita a SL scritta dall'EA a 1,00 lotto (mediana 10.472 EUR con ATR ~0,93 USD, stop 2,5 x ATR) si ricava un valore di ~4.500 EUR per 1 USD di prezzo, cioe' un contratto dell'ordine di **5.000 once** [DERIVATO; la scheda del broker NON e' stata letta]. A 5.000 once la commissione e' circa 0,0009 USD/oz, **quasi 45 volte meno**.
- Effetto: le righe "FRA (sotto la frontiera 40x: non puo' diventare sedia)" che il lettore stampa per H4 (29,6x e 19,8x) **non valgono per l'argento**. Con la commissione corretta il rapporto stop/(spread + commissione) a H4 sarebbe dell'ordine di 56-58x, cioe' sopra 40x. Resta il C3G di D2 (solo spread, 52,20x), che non e' toccato da questo difetto.
- Non e' ancora corretto ne' passato dal cancello: va messo in `leggi_gba_r0.py` come lettura per simbolo (contratto e commissione per simbolo, dichiarati), con contro-esempio sull'oro (che deve restare identico) e nuovo SHA. **Finche' non e' corretto, la riga (3) del lettore sull'argento non si cita.** Le letture precedenti dell'argento (R1A, XAG2) usano il C3G di D2 per le decisioni, non questa riga: da verificare una per una prima di dirlo.

## 4. Cosa significa per l'argento (onesto)
- **Per costo l'argento a H4 non e' escluso**: C3G 52,2x >= 40x solo spread, 17 righe su 26 a >= 50x. Non e' una promozione: n 10, un solo trimestre, nessun PF leggibile.
- **M30 e H1 non si leggono** (H0). Il C3G dei loro giornali (17,9x e 26,3x) e' descrittivo e sotto 40x: non e' un esito.
- Non c'e' nessun motivo, da questi numeri, per cambiare il verdetto sull'argento M1 e M15 (ESCLUSA (Modello 1) provvisoria a M1, n insufficiente a M15).

## 5. Cosa si misura adesso (una cosa per volta, un giro GBA alla volta)
1. **Rifare M30 e H1 una per una** (nuovo file prova per le sole due celle, stesso trimestre, attesa scritta prima; sul PC di backtest, dopo XAGT e stadio B). Se stallano ancora: lo stallo dipende dal TF alto e si cambia il driver (chiusura piu' robusta), non si legge nient'altro.
2. **H4 a campione piu' lungo** (almeno 2-3 anni di barre H4 per superare n >= 30): ipotesi, non ancora un file prova; prima lo STADIO A a tick reali dell'argento (XAGT) deve dire se il tick reale cambia il C3G.
3. **Correggere il lettore** sul costo dell'argento (§3) con il cancello.
