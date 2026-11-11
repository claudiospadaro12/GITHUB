# 05 - Calcolo della perdita giornaliera (tabella E)

## Definizione di equity (fonte ufficiale)

- Pagina: https://ftmo.com/en/trading-objectives (snippet di ricerca, NON aperta nel browser).
- Testo trovato: la regola fissa un limite "below which your account equity cannot drop", cioè sotto il quale l'equity non può scendere.
- Formula trovata: equity = "Balance + Open Positions P/L ± Swaps – Commissions". Quindi:
  - posizioni aperte: INCLUSE (profitti e perdite flottanti);
  - swap: INCLUSI (con segno);
  - commissioni: INCLUSE (sottratte).
  STATO: AMBIGUO per il solo fatto che lo snippet non è stato verificato sulla pagina aperta. Da confermare.

## Limite iniziale

- Primo giorno: "the account balance used for the limit calculation is the Initial Simulated Capital" (https://ftmo.oanda.com/?p=2707, mirror FTMO, snippet). Il limite iniziale è basato sul capitale simulato iniziale.
- Il limite "can increase and decrease" (può salire e scendere). Le variazioni dovute alle posizioni aperte "do not affect the Maximum Daily Loss Limit" (stessa fonte). Quindi il limite cambia da un giorno all'altro, non durante la giornata.

## Ora di azzeramento

- Dal mirror FTMO (https://ftmo.oanda.com/?p=3774, snippet): il limite è controllato sull'ora di Praga (CET), e "the daily drawdown resets at midnight CET".
- Nota: in altri avvisi compare "CET" e in altri siti di terze parti "CE(S)T". Quale delle due sia corretta NON è confermato dalle pagine FTMO lette. STATO: AMBIGUO (CET o CEST).
- Con l'ora legale europea (fine ottobre 2026 già passata), la differenza con il server MT5 cambia. Va ricalcolata nel terminale.

## Percentuale del limite giornaliero
- NON TROVATA nelle pagine FTMO lette. Le fonti di terze parti dicono 5%, ma non sono ufficiali. Non usato.

## Sintesi per un EA
- Il limite è "continuo": l'equity non può scendere sotto il limite in nessun momento della giornata (dalla formula della pagina).
- Perdite flottanti, swap e commissioni contano per l'equity.
- Il reset è a mezzanotte CET (non CEST, da confermare). Chi usa la giornata solare italiana deve fare attenzione all'ora di Praga.

## Dati da confermare
- Percentuale esatta del limite giornaliero (sito FTMO, pagina Trading Objectives o dashboard).
- Limite massimo totale (non letto).
- Conferma della formula con swap e commissioni (pagina aperta, non snippet).
