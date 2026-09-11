# 👁️ GLI OCCHI ALLE SEDIE CIECHE — l'imbuto di mortalita' (11/09/2026)

> Nasce da `report/PERCHE_ENTRANO_POCO_2026-09-11.md` §5: **14 sedie su 39 non
> scrivono NIENTE quando rifiutano un ingresso**. Finche' e' cosi', ogni diagnosi
> sulla frequenza (il 58% di `FREQUENZA_CAMPO_2026-09-11.md`) resta un'ipotesi.

🛑 **NESSUN COMPORTAMENTO E' CAMBIATO.** Solo contatori e righe di log.
🛑 **Nessun terminale, nessun `.set`, nessun parametro vivo toccato.**

---

## 🚀 LE TRE RIGHE

1. 🪑 **14 sedie cieche su 14 hanno l'imbuto** (10 file `.mq5`), piu' una gemella
   presa per uniformita' di famiglia (`ABTG_SuperWave_DAX_H4_Ottimizzato`,
   magic 770512): **11 file in tutto**.
2. 🔒 **Il comportamento non cambia, ed e' MISURATO**: togliendo dal file nuovo
   tutto cio' che e' imbuto si **ricostruisce l'originale token per token**, su
   tutti e 11 i file (`backtest_pipeline/controlli/imbuto_ricostruisci_originale.py`).
3. 🔴 **NON ENTRA IN CAMPO DA SOLO.** Il binario che gira sul piccolo
   **50503392** e' del **28/07–16/08** (`IL_CAMPO_E_FERMO_A_AGOSTO_2026-09-11.md`):
   finche' Claudio non **RICOMPILA**, nel Giornale non comparira' **nemmeno una
   riga**. La ricompilazione e' un gesto suo, a mercato chiuso, dopo il PASS del
   cancello.

---

## 🪑 CHI HA GLI OCCHI, ADESSO

| file `.mq5` | sedie coperte | tag nel Giornale |
|---|---|---|
| `ABTG_PTE.mq5` | `771321` `771322` | `[PTE-IMBUTO]` |
| `ABTG_PTE_Ottimizzato.mq5` | `771332` | `[PTE-IMBUTO]` |
| `ABTG_SuperWave.mq5` | `770531` | `[SUPERWAVE-IMBUTO]` |
| `ABTG_SuperWave_DOW_H1_Ottimizzato.mq5` | `770511` | `[SUPERWAVE-IMBUTO]` |
| `ABTG_SuperWave_DAX_H4_Ottimizzato.mq5` | (770512, gemella) | `[SUPERWAVE-IMBUTO]` |
| `ABTG_SupertrendReversal.mq5` | `770924` | `[STREV-IMBUTO]` |
| `ABTG_SupertrendReversal_Ottimizzato.mq5` | `970901` `970912` `970913` | `[STREV-IMBUTO]` |
| `ABTG_EMA200.mq5` | `771531` ⬅️ **la piu' sotto il progetto (p=0,0046)** | `[EMA200-IMBUTO]` |
| `ABTG_EMA200_Ottimizzato.mq5` | `971501` | `[EMA200-IMBUTO]` |
| `ABTG_CostToCost.mq5` | `772361` `772362` | `[COST-IMBUTO]` |
| `ABTG_GapContinuation.mq5` | `774101` | `[GAPCONT-IMBUTO]` |

💡 **Su `CostToCost` e `GapContinuation` il funnel esisteva gia'**: era chiamato
**solo da `OnTester()`**, quindi in backtest parlava e in forward mai. Li' non e'
stato riscritto: e' stato **esteso** (stessa convenzione di casa, contatori
cumulativi intatti, `PrintFunnel()` e `OnTester()` **non toccati**).
🎁 E su `774101` c'e' un regalo: i contatori `cnt*` si incrementano **anche con
`InpPrintDailyDiagnostics=false`** (quel flag guarda solo i `Print`). Quindi la
sedia smette di essere cieca **senza toccare nessun parametro vivo**.

---

## 📖 COME SI LEGGE LA RIGA

```
[EMA200-IMBUTO] U30USD PERIOD_H1 giorno 2026.09.11 | CANDIDATE valutate 24
 | occupata (posizione/pendente) 19 | tetto giornaliero 0 | news 0 | spread 0
 | indicatori n/d 0 | fuori fascia ATR 3 | filtro ADR 0 | lato spento 0
 | bias EMA14 1 | ARMATE 1 | quadratura OK
```

- 🎛️ **`InpLogImbuto`** (default **true**) governa **solo il log**. I contatori
  girano comunque: spegnerlo non perde niente, riaccenderlo riparte da li'.
- ⏱️ **Cadenza: una riga al giorno**, non una per tick. Esce al **primo tick del
  giorno dopo** (e a `OnDeinit` per la giornata aperta). Le giornate senza
  candidate **non stampano nulla**: il Giornale non si intasa.
- 🧾 La data nella riga e' il **giorno SERVER** dei conteggi. Il timestamp del
  Giornale e' in **ora locale del PC** (regola di casa): la riga porta la sua
  data proprio per non confondere i due orologi.
- ➡️ **L'imbuto e' ORDINATO**: ogni candidata e' attribuita alla **PRIMA**
  condizione che la ferma. Uno zero su un filtro in fondo **non** vuol dire che
  quel filtro non morde mai: vuol dire che le candidate erano gia' morte prima.
  **Dichiarato dentro il codice**, non solo qui.

---

## 🧪 IL CONTRO-ESEMPIO: e se l'imbuto MENTISSE?

Un imbuto che non somma **e' peggio di nessun imbuto**, perche' sembra una
misura. Tre modi di mentire, e cosa e' stato fatto per ciascuno:

| la bugia possibile | la difesa | prova |
|---|---|---|
| 🕳️ **un `return` che scarta PRIMA di essere contato** | ogni riga della riga stampa una **QUADRATURA a runtime**: `somma dei rifiuti + ENTRATE == valutate`, calcolata dall'EA stesso | `imbuto_prova_che_mente.py`: la stessa cascata con **un ramo non contato** stampa `ROTTA: somma 19274 contro valutate 20000`, la versione sana stampa `OK`. ⚠️ E nella versione bugiarda quel filtro mostrerebbe **`lato spento 0`**: uno zero dall'aria innocente. **E' la quadratura a smascherarlo, non l'occhio** |
| 🧮 **una quadratura TAUTOLOGICA** (verifica una somma con la somma stessa) | trovata e corretta **in casa nostra**: su `CostToCost` il totale delle conferme era *definito* come la somma da verificare. Ora c'e' `cV_conferme`, contato **a monte** in `ValutaSegnale` | il confronto ora e' fra due quantita' **indipendenti** |
| ➕ **due condizioni vere insieme, una sola contata** | e' **vero per costruzione** (imbuto ordinato) ed e' **scritto** nell'intestazione di ogni blocco e qui sopra. Dove le cause **davvero** convivono (`GapContinuation`, bandierine per giornata) **NON si stampa nessuna quadratura**: sarebbe una somma finta | riga `NB: conteggi per GIORNO, piu' cause possono convivere: NON si sommano` |

🔓 **E una cosa che NON si chiude, dichiarata invece che nascosta**: su
`CostToCost` lo stadio **ARMATI → ESITI** non quadra dentro la giornata, perche'
un segnale armato la sera puo' entrare il giorno dopo (finestra di riprova) e il
Guardian puo' bloccarlo piu' volte lasciandolo armato. Quella riga si legge
**come elenco di cause, non come somma**, e lo dice da sola.

---

## ✅ QUALE CONTROLLO E' STATO FATTO, E QUALE NO (classe 230)

**Non c'e' MetaEditor in questa sessione: nessuno di questi controlli e' una
compilazione.** Ecco cosa prendono e cosa no.

| controllo | prende | NON prende |
|---|---|---|
| `imbuto_ricostruisci_originale.py` | che il codice **fuori** dall'imbuto sia identico all'originale, token per token (11/11 OK) | errori **dentro** il blocco imbuto |
| `imbuto_controlli_statici.py` | **CLASSE 227** (globali usate prima della dichiarazione), bilanciamento `{} () []`, funzioni duplicate, indici di `ArrayResize` contro gli indici usati, byte non ASCII, contatori dentro una condizione | ⛔ **che compili**: tipi, overload, `const`, nomi di funzioni di libreria |
| `imbuto_contro_esempio.py` | ogni `return` della catena d'ingresso senza contatore vicino (8 segnalati, **8 verificati a mano** e tutti legittimi: contatore piu' in alto nel blocco, o ramo dichiarato aperto) | rami raggiunti da `goto`/eccezioni (qui non ce ne sono) |
| specificatori di `StringFormat` | 🟢 **rischio azzerato alla radice**: la riga e' costruita con **concatenazione + `IntegerToString`**, zero specificatori nuovi. Il controllo verifica che dentro l'imbuto non ci sia nessun `StringFormat` | — |

⚠️ **Due byte non ASCII restano segnalati** in `ABTG_GapContinuation.mq5` e
`ABTG_PTE_Ottimizzato.mq5`: sono **emoji in commenti PREESISTENTI** (presenti
identici nel commit precedente), non miei. La regola ASCII dura vale per i
`.ps1` (parser ANSI); qui sono commenti in un `.mq5` che MetaEditor gia'
digerisce da settimane. **Segnalati, non toccati**: ripulirli sarebbe una
modifica che non c'entra con questo lavoro.

---

## 👉 COSA SERVE ADESSO (in ordine)

1. 🚦 **Il cancello**: `controlla_riga.py` + agente `controllo-preventivo` su
   questi 11 file. **Niente F7 prima del PASS.**
2. 🔨 **Ricompilare** (gesto di Claudio, a mercato chiuso, conto dichiarato:
   **piccolo 50503392**, cartella `C:\Program Files\BCM Markets MT5 Terminal`).
   ⚠️ Ricompilare porta in campo **anche** gli altri cambiamenti di repo di
   quei file (per SuperWave/SupRev c'e' dentro il **fix del doppio volume**
   dell'08/09): **e' un fatto di rischio, non di log**, e va deciso con quello
   sul tavolo.
3. 📊 **Dopo 3-5 giorni**: raccogliere le righe `*-IMBUTO` dal Giornale e
   rispondere finalmente alla domanda *"chi ha ucciso l'ingresso"* — a partire
   da `771531`, la sola sedia con lo scarto grande **e** significativo.
