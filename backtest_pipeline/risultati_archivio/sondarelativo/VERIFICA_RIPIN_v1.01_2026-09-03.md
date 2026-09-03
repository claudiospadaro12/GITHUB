# ✅ SONDA RELATIVO — verifica del ri-pin sulla v1.01 dell'EA (03/09/2026)

**Motivo:** `mql5/Experts/ABTG_SondaRelativo.mq5` e' passato a **v1.01**
(commit `2fd6a1e`: fix del gate C2 "Giorni Spaiati", nuova colonna
"Giorni Festa Metro", autotest 21->22 blocchi, `REL_NSTATS` 93->94, 96->97
colonne CSV). Il driver `backtest_pipeline/righe/RIGA_SONDARELATIVO.ps1`
(pin precedente, commit `ed46f2f`) aveva i gate ancora ancorati ai numeri
**VECCHI** della sonda: sarebbe partito e si sarebbe fermato subito al passo
2 ("IDENTITA' DEL SORGENTE AL PIN") con `#property version e' '1.01', attesa
'1.00'` — un giro a vuoto pieno (compilazione compresa) per un disallineamento
noto in anticipo.

## Cosa e' stato corretto (commit `526f76f6`, driver)

| dove | prima | dopo |
|---|---|---|
| riga 78-79 (commento header) | `"1.00"`, `21 blocchi`, `REL_NSTATS 93 (= 96 colonne)` | `"1.01"`, `22 blocchi`, `REL_NSTATS 94 (= 97 colonne)` |
| riga 158 | `$VERSIONE_ATTESA = "1.00"` | `"1.01"` |
| riga 159 | `$AUTOTEST_BLOCCHI_ATTESI = 21` | `22` |
| riga 160 | `$NSTATS_ATTESI = 93` (commento "96 colonne") | `94` (commento "97 colonne") |
| riga 706 | `"REL_NSTATS = ... (96 colonne)"` | `"... (97 colonne)"` |
| riga 1010 | `"colonne: ... (attese 96)"` | `"... (attese 97)"` — **quinta occorrenza non segnalata dallo sviluppatore**, trovata leggendo il file per intero (punto 1 della checklist) |
| riga 1088 | `"...96 colonne OPTFRAME."` | `"...97 colonne OPTFRAME."` |
| riga 1119 | `"...96 colonne + gli input..."` | `"...97 colonne + gli input..."` |
| riga 2 (marcatore) | `MARCATORE_RIGA_SONDARELATIVO_v2` | `_v3` (contenuto cambiato = versione alzata, classe 109-bis) |

Il check `if($src -notmatch '\[AUTOTEST\]\s+21\s')` (riga 702) e' rimasto
**invariato**: il blocco `[AUTOTEST] 21` (AggiornaEscursione_Calc) esiste
ancora nel sorgente v1.01 (l'autotest e' cumulativo, il nuovo BLOCCO 22 si
aggiunge), quindi il check resta valido senza modifiche.

## Controlli eseguiti a macchina (pwsh disponibile nell'ambiente)

1. **Parse reale** dei 5 blocchi PowerShell della pagina `_DA_MANDARE.md`
   (`[System.Management.Automation.Language.Parser]::ParseFile`): **tutti
   PASS**, zero errori.
2. **Zero caratteri non-ASCII** nel driver `.ps1` (`grep -P '[^\x00-\x7F]'`).
3. **Classe 79/79-bis** (collisione `$r`/`$R`, PowerShell case-insensitive):
   parser AST eseguito sul driver. Tre gruppi segnalati (`ha`, `mappa`, `r`)
   — tutti **giudicati manualmente e confermati INNOCUI**: `$R` (referto)
   nasce alla riga 993 e non esiste prima; ogni `foreach($r in ...)` prima
   di quel punto vive e muore in uno scope disgiunto nel tempo; dopo la
   riga 993 il ciclo sulle 49 celle usa `$rw` (fix gia' presente dal commit
   `ed46f2f`, classe 79-bis). `ha`/`mappa` sono variabili locali di funzioni
   diverse (`GateGemelli` vs `AnalizzaCsv`; `LeggiProva` vs lo script-level
   `$Mappa`), scope separati.
4. **I nuovi valori attesi combaciano col `.mq5` reale su disco**, letti
   con la STESSA logica del driver (regex `#property version`, conteggio
   `blocchi++;`, `#define REL_NSTATS`, conteggio `input `):
   `versione=1.01` (match), `blocchi=22` (match), `REL_NSTATS=94` (match),
   `input=22` (match), `0` chiamate di trading, `0` `#include`.
5. **Le 97 colonne della head del `.mq5`** (94 stats + Pass/Simbolo/Periodo,
   ultima `Giorni Festa Metro`) **coprono tutte le 73 colonne** che il
   driver pretende per nome (`$servono`), estratte ed eseguite a macchina.
   `fmt1+fmt2+fmt3` hanno **97 specificatori**, combaciano con la head.
6. **Guardia MT5/MetaEditor** (`Get-Process terminal64,metaeditor64`):
   presente nel driver (riga 651) e in tutti e 5 i blocchi della pagina.
7. **Cultura invariante**: `$INV`/`InvariantCulture` usata in modo
   pervasivo per `Parse`/`ToString` su valori numerici e date; nessun
   `[double]$stringa` sospetto trovato.
8. **Tetto ~100.000 barre**: `$TETTO_GIORNI = @{ "M5"=475; "M15"=1461 }`
   invariato, coerente con CLAUDE.md (25/08).
9. **Classi 108/110/116** (exit code a tre stati, timbro `data:` = ora di
   avvio, sentinella + foto prima/dopo): gia' presenti e corrette nel
   driver dal pin precedente; non toccate da questo giro, ri-verificate
   per lettura integrale.

## Ri-pin della pagina (commit `526f76f6`)

Pin precedente `ed46f2f...` -> nuovo `526f76f6bef2b82b3e28edc0fc1306a3eeee1be9`
(il commit che ha corretto il driver). Verificato via `raw` che al pin
driver + 4 prova + `.mq5` + `walkforward_generico.ps1` sono **identici a
HEAD** (hash confrontati uno per uno). Marcatore aggiornato in tutti i punti
d'uso (definizione + tabella + 5 `Select-String` dei blocchi). Nessun
residuo del pin vecchio nella pagina, nemmeno abbreviato (classe 103;
l'unico residuo di `ed46f2f...` nel repo e' nel referto archiviato
`REFERTO_SONDARELATIVO_D30_M15.txt` qui accanto, che e' un record storico
di una corsa gia' avvenuta e non va riscritto).

## Verdetto

**PASS.** Driver e pagina ri-pinnati e allineati alla v1.01 dell'EA;
un difetto in piu' (riga 1010, "96 colonne" non segnalata) trovato e
corretto leggendo il file per intero, non fidandosi solo dei numeri di
riga forniti.

**NON COPERTO:** compilazione reale con MetaEditor e corsa MT5 vera (fuori
dal perimetro eseguibile qui: PC di backtest Windows, non disponibile in
questo ambiente). Il collaudo qui sopra e' analisi statica + esecuzione
reale della logica di parsing/gate del driver contro il `.mq5` vero letto
da disco, non una corsa del tester.
