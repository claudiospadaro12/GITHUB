# Prova a secco della rinomina ABTG -> CLAU12 (11/10/2026)

Ramo locale `prova-rinomina-clau12` (da `d840262c`, NON pushato, `lavoro` non toccato). Strumento: `backtest_pipeline/prova_a_secco_rinomina_clau12.py` (non passato dal cancello, solo analisi: non lanciare sul VPS).

## Perimetro scelto
SOLO il codice vivo (`.mq5 .mqh .ps1 .py .sh .set .ini .yml .pine .diff .patch` + `righe/*.txt`). **Gli archivi NON si toccano** (`risultati_archivio`, `coda/referti`, `risultati_prove`, `data`, `report`, `docs`): sono prove datate, riscriverle falsificherebbe la storia e cambierebbe gli SHA dei risultati. Nel repo `ABTG` compare in 6.335 file di testo UTF-8, 145 UTF-16, 44 ANSI, 3 zip: la gran parte e' archivio.

## Misurato
| Controllo | Esito |
|---|---|
| File live letti / contenuti cambiati / file rinominati | 1.515 / 1.068 / 308 (185 `.mq5`, 259 `.ps1`, 190 `.set/.ini`) |
| Collisioni di nome dopo la rinomina (nome in MAIUSCOLO) | **0** |
| `ABTG` residuo nel codice vivo | **0** |
| `#include` non risolti | **0** |
| File UTF-16 nel perimetro live (rischio di saltarli) | **0** (i 145 UTF-16 sono tutti archivio) |
| `py_compile` di tutti i `.py` | OK |
| Autotest `leggi_gba_r0.py` / `leggi_natcla_f1.py` | OK (118 controlli / 67, 0 falliti) |
| Autotest `leggi_gba_notti.py` | **FALLITO** (e' atteso: pinna lo SHA del lettore, che e' cambiato) |
| Righe di lancio con SHA256 dentro | **99 su 121 invalidate** (ogni PASS va ripreso) |

## Difetti trovati (e perche' "a sed" era la strada sbagliata)
1. 🔴 **Segnali fra EA e Guardian.** Le `GlobalVariable` (`ABTG_PAUSA_GIORNO`, `ABTG_GUARDIAN_BATTITO`, `ABTG_CAP_RISCHIO`) sono il filo che lega il Guardian a TUTTI gli EA di un terminale. Il codice dice che **devono restare IDENTICHE** (`ABTG_PausaGuardian.mqh` r.73). Con una flotta mista (Guardian rinominato, EA vecchi) il Guardian e' cieco o la pausa non arriva: **fail-open**. Soluzione proposta: **i nomi di protocollo interni NON si rinominano** (nome visibile CLAU12, `GlobalVariable` invariate), oppure tutto un terminale in un colpo.
2. 🔴 **File dato scritti a runtime** (`ABTG_StoricoScaricato.csv`, `ABTG_SimboliBroker.txt`, `ABTG_Trades_100k.csv`, `ABTG_SpreadLogger_orario.csv`...): la rinomina lascia **150 nomi (398 riferimenti) che puntano a file che non esistono**; sul VPS i file veri hanno ancora il nome vecchio. Stesso rimedio: i nomi di file dato non si toccano.
3. 🟠 Il passaggio al MAIUSCOLO rovina anche pezzi di nome nei file risultato (`..._IS_ott74a.csv`): la sostituzione va fatta solo sui nomi degli EA, non su ogni occorrenza.
4. 🟠 Lettori col pin sullo SHA di altri lettori (`leggi_gba_notti.py`) e il cancello `controlla_riga.py` vanno ripinnati.
5. 🟢 I magic non compaiono nei nomi: invariati.

## Proposta (da firmare)
Rinominare **solo cio' che si vede**: nome del file EA/include e `#property`/commento, in MAIUSCOLO; **lasciare invariati** `GlobalVariable`, file dato, prefissi di log e magic. Poi: nuovi PASS del cancello alle 99 righe, ripin dei lettori, e sul VPS **un terminale per volta, EA + Guardian insieme**, a mercati chiusi, con i tre controlli dopo (connesso, sedie attaccate, Algo Trading verde). Nessun terminale e' stato toccato.
