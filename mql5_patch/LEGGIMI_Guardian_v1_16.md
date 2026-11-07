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

---
# v1.17 (07/11/2026 sera): contatore delle richieste al server

**Stato: scritta, NON compilata, NON provata in MT5.** Controllo meccanico fatto: la catena v1.15 -> v1.16 -> v1.17 si applica pulita (`ABTG_Guardian_v1_16_chiusura_venerdi.patch` poi `ABTG_Guardian_v1_17_contatore_richieste.patch`) e il risultato coincide con la patch unica `ABTG_Guardian_v1_17_completa_da_v1_15.patch`; parentesi bilanciate; nessun altro `OnTradeTransaction` nel Guardian né nei suoi include (gli altri EA ne hanno uno proprio: sono programmi separati). Non applicata a `lavoro`.

## Perche
FTMO vieta gli EA "iperattivi" con piu di **2.000 richieste al server al giorno** (aprire, modificare o chiudere ordini/pendenti; `forbidden-trading-practices`, letta con l'estensione il 07/11). Non sappiamo quante richieste fanno i nostri EA (trailing, pendenti delle griglie): **NON MISURATO**.

## Cosa fa (spento di default: `InpReqEnable=false` = nessuna GlobalVariable, nessuna riga in piu)
- Conta gli eventi dell'intero conto con `OnTradeTransaction`, di QUALSIASI EA: nuovi ordini (aperture e chiusure a mercato, pendenti), modifiche SL/TP delle posizioni, modifiche e cancellazioni dei pendenti.
- Giorno = "giorno prop" (`InpDailyResetHour`, 1 per FTMO). Il totale persiste in `ABTG_GUARD_<conto>_REQ_V1` / `..._REQDAY_V1`; dopo un riavvio nello stesso giorno le categorie ripartono da zero ma il totale resta.
- Avviso a `InpReqWarn` (1000) e allarme a `InpReqAlarm` (1600): riga nel giornale + `Alert`, una volta per livello al giorno. `InpReqAction=1` all'allarme mette anche la pausa nuovi ingressi fino al reset (**solo per gli EA ABTG**: gli EA di terzi non la leggono; il Guardian non puo fermare le loro modifiche senza chiudere tutto).
- Pannello: una riga "Richieste oggi" con le 4 categorie; il log ogni 5 minuti una riga separata.
- Autotest (`InpAutotest=true`): 15 casi sulle funzioni pure `ReqClassifica` e `ReqLivello`.

## Limiti dichiarati
- **E una stima per eccesso**: un pendente che scatta conta anche come "cancellazione". NON VERIFICATO che coincida con il conteggio di FTMO (che cosa contano e da che ora e dal server non e scritto: domanda 10 del file `DOMANDE_FTMO...`).
- **NON VERIFICATO** che MT5 consegni al Guardian gli eventi generati da altri EA (dovrebbe: sono eventi di conto) e che una modifica di SL/TP arrivi come evento di posizione senza deal. **Verifica da fare il primo giorno**: confrontare il conteggio del pannello con le righe `modify` del Journal e con la storia ordini.
- Nel tester il Guardian non gira insieme agli altri EA nel nostro schema: la misura sul tester si fa dai Journal delle passate.

## Come provarlo (a tuo ok, su DEMO, mai sul reale)
1. Applicare la patch su una copia, compilare con F7 (errori: mandarmi il testo).
2. Demo con `InpAutotest=true`, `InpReqEnable=true`: leggere nel Journal i 15 casi `[AUTOTEST] ... CONTATORE RICHIESTE`.
3. Un giorno con i tre EA oro: confrontare "Richieste oggi" con il Journal.
