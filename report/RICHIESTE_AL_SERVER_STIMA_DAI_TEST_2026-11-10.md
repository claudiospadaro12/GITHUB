# Avviso FTMO di iperattivita (10/11/2026): cosa dicono i nostri giornali del tester sulle richieste al server

**Contesto.** Il 10/11/2026 l'assistenza FTMO ha scritto a Claudio (conto trial 1515150476) che l'account ha un "alto grado di iperattivita": soglia **2.000 scambi o richieste al server al giorno, comprese le modifiche SL/TP e gli annullamenti di ordine**; il numero di **righe del file di registro** del terminale corrisponde alle richieste; se gli avvisi non diminuiscono "nei giorni successivi" il conto viene disabilitato. E la risposta alla domanda 7 della nostra mail (cosa conta nelle 2.000 richieste): contano anche le **modifiche SL/TP**.

**Natura: STIMA dai giornali del tester (D160), NON misura dal campo.** Un giornale del tester e una proxy: sul terminale reale il conteggio puo essere diverso (le ripetizioni "Trying again!" in live dipendono dal timer dell'EA). La misura vera e il registro del terminale FTMO: riga `RIGA_CONTA_RICHIESTE_FTMO.txt`.

## Cosa si vede nei giornali (80k-equivalente, anno intero, un EA alla volta, righe per giorno)
| EA, livello, anno | Righe del giornale (anno) | Giorno piu pieno | Righe "Market closed" (anno) | Righe di modifica |
|---|---|---|---|---|
| Phantom L1, 2025 | 6.584 | **1.262** (02/06/2025) | 1.224 | 2.195 |
| Phantom L0, 2025 | 5.721 | 1.036 (02/06/2025) | 789 | 1.471 |
| Goldbot L0, 2025 | 4.577 | 402 (22/12/2025) | 227 | 379 |
| Reaper L3, 2025 | 4.793 | 496 (02/07/2025) | 353 | 358 |
| Goldbot L0, 2013 | 4.158 | 256 | 31 | 61 |
- **Tutte le 1.262 righe del giorno piu pieno del Phantom L1 cadono nella stessa ora (23:00-24:00 ora server BCM)**: 631 `failed modify ... [Market closed]`, 477 `TrailStop error: 'unknown error 4756' ... Trying again!` e 154 `error when setting breakeven ...`. Cioe il picco non viene dalle operazioni, ma dai **tentativi di modificare SL/TP (trailing e breakeven) durante la pausa giornaliera dell'oro**, quando il mercato e chiuso e il server rifiuta.
- **Somma di piu EA nello stesso giorno (stesso giorno di calendario, tester)**: 02/06/2025 Reaper L3 + Goldbot L0 + Phantom L1 = **1.588** righe; Phantom L1 + Gold Trade Pro = **1.724**; Phantom L1 da solo 1.262. Nessun giorno oltre 2.000 nel tester, ma il 2025 ha un giorno oltre il 1.600 con due EA soli. Nel 2013 il massimo e 867.
- **Il trial FTMO non e un EA singolo**: ha Reaper, Goldbot, Phantom e Gold Trade Pro insieme (e altri EA del conto, NON VERIFICATO quali), con piu posizioni aperte durante la pausa; il 09/11 dieci posizioni long sono rimaste aperte dalle 22:15 alle 02:32 (ora FTMO), cioe attraverso la pausa giornaliera.

## Ipotesi (NON VERIFICATA) sulla causa
Nelle ore di pausa dell'oro, gli EA con trailing SL e breakeven riprovano la modifica a ogni giro mentre il mercato e chiuso; con 10 posizioni aperte e piu EA le righe si sommano, e in live (timer, non barre) il numero puo essere molto piu alto di quello del tester. Il Guardian, in pausa BLOCKED dopo le 02:32, non puo fermare gli EA: le modifiche e i tentativi sono degli EA.

## Cosa serve per decidere
1. **Misura vera**: righe per giorno e per ora nei registri di `C:\FTMO\Logs` e `C:\FTMO\MQL5\Logs` (riga di sola lettura sul VPS, `RIGA_CONTA_RICHIESTE_FTMO.txt`).
2. **Dove si concentrano**: per ora e per tipo di riga (`Market closed`, `modify`).
3. **Poi** gli interventi: ridurre il trailing/breakeven negli input degli EA, evitare posizioni aperte attraverso la pausa, e il contatore del Guardian v1.17 (soglie di avviso 1.000 e di allarme 1.600) — nessuno di questi interventi e deciso: li sceglie Claudio dopo la misura.
4. **Regola per la challenge**: un conto che riceve un avviso del genere rischia la disabilitazione; **il conteggio delle richieste e una condizione da verificare PRIMA di comprare una challenge**.

## Limiti
Giornali del tester (sessione di Windows 'logs' dell'agente, righe con data) usati come proxy; una sola corsa per EA; BCM e il suo orario (pausa 23:00-24:00 ora server BCM = GMT+1 fisso) non coincidono con FTMO; nessun conteggio sul campo.
