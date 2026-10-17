# Pacchetto Oro di Profalgo (Gold Reaper, Gold Trade Pro, Goldbot One, The Gold Phantom) -- backtest approfondito: attese scritte PRIMA di ogni numero (17/10/2026)

Contesto: Claudio sta valutando di spendere circa 1.100-1.500 EUR in un pacchetto di EA di terzi (Gold Bundle 1.249 USD: 4 EA oro, 10 licenze per EA, rimborso 30 giorni dichiarato). Questa e' la misura che decide SE si compra. Si usano le DEMO scaricate dal Market sul terminale del PC di backtest (solo tester). Prima misura gia' in corso il 17/10 09:17: Gold Reaper H1 e TIG M5, luglio-settembre 2026 (attese in `THE_GOLD_REAPER_ATTESE_2026-10-16.md` e `THE_IMPOSSIBLE_GOLD_ATTESE_2026-10-16.md`).

## Dichiarazioni del venditore da mettere alla prova [LETTO dagli screenshot della pagina del 17/10]
Gold Reaper su Myfxbook: +312% da gennaio 2025, +10,6% al mese (media), massimo prelievo 15,2%. Nessuna griglia/martingala/recupero, stop loss su ogni posizione, lotti fissi per strategia, "alcuni mesi a zero o negativi". Segnali MQL5 dello stesso autore: Gold Reaper impostazioni predefinite prelievo 46% (140 settimane), New V2 2 prelievo 17% (102 settimane).
Il tester BCM ha ticks reali XAUUSD **dal 10/07/2024** [LETTO nei giornali del tester: "ticks data begins from 2024.07.10"]: la finestra Jan 2025-ott 2026 del loro Myfxbook e' coperta.

## Finestre (decise ORA, prima di guardare)
- **W1 (in corso)**: luglio, agosto, settembre 2026 (tre tranche mensili).
- **W2 (dopo aver misurato i minuti per giorno simulato di W1)**: gennaio 2025 - settembre 2026, a tranche TRIMESTRALI, per ogni EA; se il tempo e' troppo, solo i trimestri completi a partire dal piu' recente, mai scelti guardando i risultati.
Un'unica finestra "fuori campione" e' W2 senza W1: i parametri NON si toccano fra le due.

## Ipotesi per OGNI EA del pacchetto, su W2 (default dell'EA; una seconda variante col set di Claudio solo DOPO aver letto la prima)
- **B1 (niente scala)**: lotti d'ingresso massimo/minimo <= 2 in ogni trimestre e nessuna posizione contemporanea oltre il numero di strategie dichiarate. *Smentita*: rapporto > 2 o crescita dei lotti dopo perdite.
- **B2 (drawdown dichiarato)**: DD massimo di equita' <= **15,2%** del deposito (5.000 EUR) sull'intera W2. *Smentita*: oltre 15,2% (previsione dichiarata: probabile con i default, perche' il segnale predefinito ha 46%).
- **B3 (rendimento)**: netto positivo in almeno **il 60% dei mesi** E somma di W2 positiva. *Smentita*: sotto il 60% o somma negativa. Non si decide con meno di 150 operazioni per EA.
- **B4 (win rate dichiarato)**: dentro il 60-80% (Gold Reaper dichiara 72%). *Smentita*: fuori banda su W2.
- **B5 (scorrelati)**: correlazione di Pearson dei risultati GIORNALIERI fra due EA qualsiasi del pacchetto (e con TIG) **<= 0,3**. *Smentita*: anche una sola coppia > 0,5.
- **B6 (portafoglio)**: i quattro EA sommati sulla stessa equita': DD massimo del portafoglio <= **1,5 volte** il DD del singolo EA peggiore. *Smentita*: oltre. (Somma dei risultati giornalieri: non simula l'interazione di margine.)
- **B7 (replica del loro Myfxbook, solo Gold Reaper)**: crescita composta su W2 dello stesso ordine di grandezza dichiarato (+312% in 21 mesi = circa 6,8% al mese). *Smentita*: meno della META del dichiarato (circa 3,4% al mese).
**Regola per Claudio, decisa ora**: il pacchetto si considera "candidato da comprare" SOLO se B2, B3 e B5 reggono per almeno **tre EA su quattro** E B6 regge; altrimenti "NON comprare". Un esito favorevole resta "candidato", mai "garantito": sono 21 mesi, un feed (BCM), nessun costo di slippage del reale misurato qui oltre ai 0,02 EUR per 0,01 lotti a lato del tester.
**Quando non si decide**: ogni ipotesi solo sui giri CONFORMI (ticks reali al 100%, finestra, deposito 5.000, leva 1:100, stesso `.ex5`/stessa SHA256 su tutti i trimestri). Se un EA nel tester demo non opera (zero operazioni) o non e' completo, e' una MISURA MANCANTE e il pacchetto non puo' essere deciso su di lui.
**Cose NON verificabili qui**: il filtro NFP del Gold Reaper nel tester usa offset GMT manuali (defaults 2/3) che non sono quelli di BCM (UTC+1): protezione sfasata [DERIVATO, 2/7]. Il calendario MQL5 non e' nel tester. I timeframe di Gold Trade Pro, Goldbot One, Gold Phantom e My AI Gold NON sono ancora noti [da Claudio, dalla pagina del Market].
