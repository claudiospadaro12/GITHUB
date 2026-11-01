# Breaking Band sull'oro: criteri e previsioni scritti PRIMA dei numeri (01/11/2026)
Non controllata da agenti. Richiesta di Claudio: "ora fai le analisi" sulla Breaking Band. Fonti usate: testo di sintesi, Prompt (docx), Checklist Tabellare (docx, versione 15/02/2026 con regole su tocco banda e deviazione standard), Esempi Operativi (PDF, 10 esempi EURUSD H1). **Mancano la Guida Operativa 11, la Dichiarazione di Test e lo screenshot ufficiale**: le soglie numeriche sotto vengono dalla Checklist; dove la Checklist e qualitativa la traduzione e mia e dichiarata. Nessun parametro e ottimizzato: le soglie sono fissate qui, prima di guardare i risultati.

## Dati e metodo
Barre M1 BCM dell'oro con spread (2013, 2018, 2020, 2025-26; stessi dati del test Golden Cross). Gli esempi del PDF sono EURUSD H1: non ho dati EURUSD, quindi il test e **solo sull'oro**. Barre H1 (principale) e M15 (secondaria) costruite dalle M1. Indicatori: Bollinger(20, 2, chiusure) con mediana SMA20; deviazione standard(20) delle chiusure con SMA50 della deviazione standard (come il nuovo standard grafico); ATR(14). Segnali valutati alla chiusura della barra, ingresso all'apertura della barra dopo (M1) con spread pagato, stop prima del target nello stesso minuto, nessuno slippage. Codice: `backtest_pipeline/breaking_band_test.py`.

## Regole tradotte in numeri (tutte decise ora)
**Bulge su rialzo** (speculare al ribasso), impulso da `s` (minimo delle chiusure nelle ultime 20 barre) a `i`, tutti e 6 obbligatori:
1. bande molto aperte: ampiezza(i) >= 2,0 x ampiezza(s);
2. deviazione standard(i) > SMA50 della deviazione standard;
3. almeno una candela dell'impulso con range fra 1,5 e 3 ATR (ATR misurato in `s`);
4. movimento netto: (chiusura(i) - chiusura(s)) >= 2,5 ATR e >= 50% della somma dei movimenti chiusura-chiusura;
5. mediana lontana: chiusura(i) - SMA20(i) >= 1,5 ATR;
6. impulso <= 20 barre (per costruzione).
Il picco `p` e il massimo delle barre i..i+3; il pattern si valuta solo dopo `p`.

**Congestione prima di `s`** (finestra 20 barre; CS 4/5 oppure CDA tutti):
- CS: ampiezza(s) <= 0,8 x ampiezza(s-20); range medio ultime 20 <= range medio delle 20 precedenti; |chiusura(s) - chiusura(s-20)| <= 1,5 ATR; nessuna candela > 1,5 ATR; deviazione standard(s) < SMA50.
- CDA: deviazione standard in calo (almeno 7 passi su 10 negativi e valore(s) < valore(s-10)); deviazione standard < SMA50; ampiezza(s)/ampiezza(s-15) <= 0,85; nessuna candela > 1,5 ATR nelle ultime 15 barre; R^2 della retta sulle chiusure >= 0,5 (canale ordinato).

**Ritracciamento / rientro** (da p+1 al test, massimo 15 barre; richiesto >= 80% dei criteri):
range medio <= 0,7 x range medio dell'impulso; nessuna candela > 1,5 ATR; ombre <= 1,5 x corpo (almeno l'80% delle barre); nessun nuovo impulso; ampiezza delle bande che scende rispetto a `p`.

**CONTINUAZIONE** (long dopo bulge rialzista): test = prima barra con minimo <= banda inferiore, almeno 3 barre dopo `p`; candela del test <= 1,5 ATR; movimento diretto verso la banda opposta. **INVERSIONE** (short dopo bulge rialzista): prima si tocca la mediana (minimo <= SMA20), poi massimo >= banda superiore (retest); mai toccata la banda inferiore da `s` al retest; banda superiore piatta o in calo (differenza a 3 barre <= +0,1 ATR) e ampiezza non in espansione (<= 1,1 x ampiezza 3 barre prima).

**Invalidazioni assolute** (una sola basta): candela > 1,5 ATR nel ritracciamento/test (continuazione) o > 1,0 ATR nel rientro (inversione); banda inclinata contro il trade; banda che si gonfia al test; deviazione standard ancora sopra la SMA50 al test; tocco della banda opposta nell'inversione.

**Solidita:** pesi della Checklist (25 congestione, 25 bulge, 20 rientro, 15 bande, 10 test, 5 conferme); ogni sezione vale la frazione di criteri SI. Conferme misurabili: deviazione standard in calo, sotto SMA50, SMA50 del prezzo a favore; **"assenza di news" non e misurabile qui: contata come SI per tutti** (limite dichiarato).

**Gestione del trade (dalla sintesi):** ingresso al test, **stop 3 ATR(14)**, **target = mediana SMA20**, riaggiornata ogni 3 barre alla chiusura. Chiusura forzata dopo 150 barre (regola mia, non del metodo: si conta quante volte scatta).

## Varianti (4, decise ora)
Continuazione H1, Inversione H1 (principali), Continuazione M15, Inversione M15. Si riportano tutte. Riporto anche l'imbuto (quante volte ogni condizione e soddisfatta) e il risultato per fascia di solidita (70-84, 85-100).

## Criteri di accettazione (principali: H1, le due insieme e ciascuna)
Profit factor **dopo lo spread** >= 1,15; almeno 100 operazioni; netto positivo in almeno 3 periodi su 4. In piu: il win rate non e inferiore al 55% (fascia "Medio" della Checklist: 45-55%, "Buono" 55-65%, "Ottimo" 65-75%), e il win rate sale con la solidita (le fasce 85+ non peggiori delle 70-84).

## Previsioni (probabilita, scritte ora)
- **B1** almeno 100 operazioni H1 (continuazione + inversione insieme): **25%** (condizioni "tutti SI" molto selettive, come per la Golden Cross).
- **B2** win rate H1 >= 55%: **75%** (il target e la mediana, vicino; lo stop e 3 ATR, lontano).
- **B3** PF netto H1 >= 1,15: **20%**; fra 1,0 e 1,15: **30%**; sotto 1,0: **50%**. Motivo: win rate alto ma perdite molto piu grandi dei guadagni (rapporto rischio/rendimento sfavorevole) e spread.
- **B4** netto positivo in almeno 3 periodi su 4: **25%**.
- **B5** win rate piu alto nella fascia di solidita 85+ che nella 70-84: **35%** (il campione sara piccolo).
- **B6** inversione con PF migliore della continuazione: **45%**.
- **B7** M15 con PF piu basso di H1: **65%** (lo spread pesa di piu).
- **B8** la regola "chiusura forzata a 150 barre" scatta nel 5% o meno dei trade: **70%**.

## Cosa NON dice
4 periodi, solo oro, regole interpretate da me (soglie numeriche mie dove la Checklist e qualitativa), senza Guida Operativa 11; il giudizio visivo sul grafico ("candele piccole e ordinate", "bocca di coccodrillo") e piu ricco delle mie soglie. Un esito negativo non esclude la versione discrezionale; uno positivo non e un conto reale. Nessun giudizio su acquisti, lotti o taglie.
