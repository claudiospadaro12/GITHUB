# Guardian v1.16: chiusura del venerdì prima del weekend (patch, 07/11/2026)

**Stato: scritta, NON compilata, NON provata.** Il sorgente del Guardian sta nel ramo `lavoro` (`mql5/Experts/ABTG_Guardian.mq5`, v1.15, commit 5cf7896d). Questa patch non è stata applicata a `lavoro`: la applica Claudio (o la applico io su sua richiesta). Controllo meccanico fatto: `patch` si applica pulita e il risultato coincide con il file modificato; il codice **non è stato compilato** (qui non c'è MetaEditor).

## Cosa fa
Decisione di Claudio (07/11): **tutto chiuso 3 ore prima della chiusura reale del mercato, con i pendenti cancellati**. Opzione nuova, **spenta di default** (`InpFriEnable=false` = nessuna azione, nessuna riga in più nel giornale).
- Il venerdì, da (chiusura del mercato − 3 ore) fino alla chiusura: chiude tutte le posizioni, cancella tutti i pendenti (di qualsiasi magic se `InpCloseAllMagics`), e ricaccia indietro ogni nuovo ordine ogni secondo (gli EA di Wim ripiazzano i pendenti ogni ora). Accende anche la pausa nuovi ingressi per gli EA ABTG; la pausa si azzera al giorno nuovo.
- La **chiusura del mercato si legge dal broker** (`SymbolInfoSessionTrade`, ultima sessione del venerdì), non è un'ora fissa: nello storico BCM l'ultima barra del venerdì è 21:54 o 20:54 server a seconda della stagione. Se non si legge, usa il fallback (`InpFriFallbackMin`, 21:00 server: prudente, chiude presto) e lo scrive nel giornale.
- Con `InpAction=1` (solo allarme) scrive nel giornale e non tocca niente.

## Parametri nuovi
| Input | Default | Cosa |
|---|---|---|
| `InpFriEnable` | false | accende la regola |
| `InpFriHoursBefore` | 3,0 | ore prima della chiusura reale |
| `InpFriSymbol` | "" | simbolo da cui leggere la sessione del venerdì ("" = simbolo del grafico; **mettere XAUUSD**) |
| `InpFriFallbackMin` | 1260 | minuti dalla mezzanotte server (21:00) se la sessione non si legge |

## Come provarla (in quest'ordine, mai prima sul reale)
1. Applicare la patch a una copia: `patch ABTG_Guardian.mq5 < ABTG_Guardian_v1_16_chiusura_venerdi.patch`. Compilare in MetaEditor: deve dare 0 errori.
2. `InpAutotest=true` su un conto demo: nel giornale devono comparire gli 8 casi `[AUTOTEST] ... CHIUSURA DEL VENERDI'` tutti superati (funzione pura, non tocca il conto).
3. Demo FTMO o BCM, di venerdì, `InpFriEnable=true`, `InpAction=1` (solo allarme): nel giornale devono comparire l'orario di chiusura letto dal broker per XAUUSD e l'inizio della finestra. Confrontarlo con la scheda Sessioni delle specifiche del simbolo.
4. Demo, `InpAction=0`, con 2-3 ordini di prova (un pendente e una posizione): alla finestra devono essere chiusi/cancellati, e un nuovo ordine piazzato a mano dopo l'inizio deve essere ricacciato entro un secondo.
5. Controllare il lunedì che gli EA riprendano (la pausa si azzera al giorno nuovo).
6. Solo dopo, decisione di Claudio su quali conti.

## Limiti dichiarati
- Il Guardian non è simulato nel tester: il costo vero della chiusura del venerdì (stima 2-4% del profitto sull'oro nei test) va misurato col parametro `FridayStopHour` degli EA o dal vivo.
- La regola serve solo sui conti Standard finanziati di FTMO (secondo il riassunto, da verificare per iscritto con FTMO); in Challenge e Verifica il weekend è permesso.
- Un EA che apre a mercato nello stesso secondo può passare: il guardiano controlla ogni secondo.
- Orari in ora SERVER: il server FTMO è Italia + 1, quello del BCM è GMT+1 fisso.
