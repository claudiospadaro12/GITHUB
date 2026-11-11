# 06 - DA LEGGERE A MANO NEL TERMINALE

Questi dati non sono pubblici sulle pagine lette, oppure richiedono login o la specifica del simbolo nel terminale MT5.

Percorso generale: Market Watch > clic destro sul simbolo > Specifiche (in MT5 può chiamarsi "Proprietà del simbolo" o "Specifications").

## Per XAUUSD ed EURUSD (e le altre coppie della lista)

| dato | dove trovarlo nel terminale | perché serve |
|---|---|---|
| Contract size | Specifiche > Contract size | confermare 100 (oro) e 100.000 (Forex) |
| Lotto minimo / massimo / passo | Specifiche > Volume min / Volume max / Volume step | richiesto in 01, non trovato sul sito |
| Spread medio o tipico | colonna Spread in Market Watch, osservata in più momenti | richiesto in 01; sito non lo dichiara |
| Swap long / short e unità | Specifiche > Swap long / Swap short / Swap type | confermare i valori del sito (points) |
| Triplo swap (giorno) | Specifiche > voce "Triple swap" o "Swap rollover 3 days" se presente | richiesto in 01, non trovato sul sito |
| Commissione | Storico conti o report dopo un trade di prova (solo in ambiente di prova). Non usare un conto reale per fare test | confermare se 5 USD/lotto è per lato o andata+ritorno |
| Ora server | barra di stato o Strumenti > Opzioni > Server | confermare GMT+2 o GMT+3 e il cambio ora legale |
| Orari di sessione | Specifiche > Trading sessions | confermare gli orari della scheda Simboli |

## Dati che richiedono login (non letti)

| dato | dove | nota |
|---|---|---|
| Leva effettiva del proprio conto | dashboard FTMO (login) | la FAQ dà leva massima; il conto reale può essere diverso |
| Limite giornaliero residuo e reset esatto | dashboard FTMO / Account Metrix (login) | serve per confermare CET/CEST |
| Limite massimo totale | dashboard FTMO (login) | non letto |
| Posizioni aperte, ordini, richieste | dashboard FTMO (login) | non letto |

## Operazioni da NON fare
- Non acquistare, non avviare prove, non inserire credenziali per leggere questi dati su siti terzi.
