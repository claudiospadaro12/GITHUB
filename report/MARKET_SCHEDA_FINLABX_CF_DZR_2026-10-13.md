# SCHEDA DI NATURA: i commenti «FinlabX», «CF» e «DZR» sull'oro del demo piccolo 50503392 (13/10/2026)

Fonte: `data/statements/ReportHistory_50503392_2026-10-13.xlsx` (Data 2026.10.13 22:26, SHA256 `2e4624c0…`; copia del file caricato da Claudio), letto con `natura_motore_da_storico.py` (SHA `302b5b74…`) e con un raggruppamento mio (`CID=<numero>` tolto dal commento) fatto in sola lettura su una copia. Commento = commento dell'**ordine di apertura**. Sono EA **scatola nera**: nessun sorgente, nessuna decompilazione. Etichette: **[LETTO nel conto]** · **[INFERITO]** · **[NON VISTO]** · **[NON MISURATO]**.
Nessun verdetto di merito, nessun «morto»: il verdetto massimo e' NON ANCORA MISURATO.

## 0. Che cosa c'e' nel conto (633 posizioni chiuse + 12 aperte, tutto il conto)
| famiglia (commento d'apertura) | n | lati | netto (EUR, comm. e swap inclusi) | provenienza |
|---|---:|---|---:|---|
| `FinlabX BUY/SELL [CID=n] [R]` | 229 | 132 buy / 97 sell | **+541,01** | **terzi/Market, prodotto NON IDENTIFICATO** |
| `CF B/S [F] [CID=n]` | 268 | 134 / 134 | -20,74 | stesso gruppo (stesso `CID`), NON IDENTIFICATO |
| `FinlabX BUY/SELL [CID=n] [F]` | 98 | 44 / 54 | -37,35 | stesso gruppo |
| `DZR B/S [F] [CID=n]` | 13 | 5 / 8 | +4,39 | stesso gruppo |
| `SSP scalp` + `SSPv4` | 5 + 1 | prevalenza buy | +7,64 | terzi: SafeScalperPro v4.00 [LETTO nel repo: CODA_09 r.34-35, non rimisurato] |
| `BULGE_*` (VN_BLU, AZZURRA_AZZURRA, VN_VIOLA, V520_BLU), `EMAN OTT L1` | 6 + 4 + 1 | forex | -32,12 | **NOSTRE** (per prefisso e per nome; `EMAN OTT L1` e' un commento EMA200/OTT: per prefisso [INFERITO]) |
| senza commento (ingresso prima della finestra) | 12 | misti | -20,09 | non attribuibili |
Totale conto +442,74 (PF 1,485, dichiarato = ricalcolato). **Il +442 viene tutto dal modulo `[R]` di «FinlabX» (+541): senza di esso il conto e' in perdita (-98).**
- `Basket_1234567_*` e `XAUUSD 5 Minute`, letti nel report del 12/10, **non compaiono** in questo file [NON VISTO perche']: assenti o senza ordini nella finestra.
- Orario: ore del report in ora SERVER (UTC+1 fisso); il report e' del 13/10 22:26.

## 1. Il gruppo `FinlabX` / `CF` / `DZR`: probabilmente UN SOLO sistema a tre moduli [INFERITO]
- Il numero `CID` e' **comune** ai tre nomi: ogni `CID` contiene ordini di `FinlabX [F]`, `DZR [F]`, `CF [F]` e `FinlabX [R]` (es. `CID` 842259: 28 posizioni, tutte e tre le sigle e il modulo `[R]`). Il `CID` cresce di circa 6 unita' all'ora (842167 alle 00:00 del 13/10 -> 842292 alle 20:52: 94 valori distinti in 21 ore): e' un identificativo di **ciclo/gruppo**, non un magic [INFERITO].
- Dalla stessa evidenza: `[F]` = ingressi di tipo «avanti» con TP fisso, `[R]` = ingressi di **recupero** [INFERITO dal comportamento sotto, non dichiarato dal venditore: **[NON VISTO]** il pannello input].
- **Il prodotto non e' identificato.** Due ricerche sul web (nome `FinlabX`; commenti con `CID`/`[R]`/`[F]`) non trovano una pagina del Market che corrisponda: serve il nome esatto dal Market o lo screenshot del pannello input da Claudio. Non si indovina il venditore.

## 2. Meccanismo, ingresso e uscita [LETTO nel conto]
**Moduli `[F]` (`CF`, `DZR`, `FinlabX [F]`):** lotto 0,01 fisso, **TP fisso +1,00 USD** dall'ingresso, durata mediana 1-3 minuti; **SL assente su 98/134 (CF B), 113/134 (CF S)** all'ingresso, e un SL compare dopo su una parte. Esempio (`CID` 842259, buy): ingressi 4177,15 -> 4179,6 -> 4181,27 -> 4182,95 -> 4184,3, ognuno chiuso a +1,00 in 0,4-6 minuti: **catena di micro-scalp a favore** che riparte dopo ogni TP. Frequenza alta, 268+98+13 posizioni in circa 22 ore.

**Modulo `[R]` (`FinlabX ... [R]`, 229 posizioni):** ordini **buy stop / sell stop**, **nessun TP (132/132 e 97/97), nessun SL all'ingresso (122/132 e 93/97)**, **lotti crescenti 0,01 -> 0,02 -> 0,03 -> 0,04 -> 0,05 -> 0,08 (buy) e fino a 0,17 (sell)**, ingressi **a prezzo peggiore** della posizione precedente. Esempio (`CID` 842259, buy): 4186,55 / 4185,9 / 4184,45 / 4184,35 / 4181,82 / 4177,13 / 4174,55 / 4173,63 / 4172,84 / 4172,11 / 4170,46 / 4169,83 / 4166,52, lotti 0,01 -> 0,08. **Escono tutte insieme** (basket): stesso orario di chiusura, stesso prezzo (es. 15:11:00 a 4172,6; 15:47:55 a 4171,5), con un **SL comune** messo dopo su tutta la serie (4187,24; 4191,24; 4188,53...).
- Tool: `[R]` BUY medie **72** (lotto crescente **41**, catena massima **11**), SELL medie **50** (lotto crescente **26**, catena **15**). Bandiere di casa: **SENZA SL INIZIALE, SENZA TP, POSSIBILE GRIGLIA/MEDIA, POSSIBILE MARTINGALA/lotti a scala**. Il recupero non aumenta ogni volta il lotto dopo una perdita (lotto su dopo perdita 3/35 e 7/25): e' una **scala di lotti sui livelli**, non un raddoppio per perdita. Il nome dell'etichetta («martingala») va letto con questo limite.
- **Rischio non cappato**: istanti con posizioni senza SL: 108 (buy) e 86 (sell). Max posizioni vive di un solo lato: 11 (buy) e 15 (sell); max lotti 0,45 (buy) e **1,01** (sell). Su XAUUSD in tutto il conto: **fino a 28 posizioni vive e 1,18 lotti insieme** (13/10 06:44) [MISURATO dalle ore di apertura/chiusura del file].
- Ordine di grandezza del rischio non cappato [DERIVATO]: il valore di 1,0 di prezzo per 1 lotto e' 89,36 EUR (stimato dai P/L); a 1,18 lotti ogni dollaro contro la serie vale ~105 EUR. Un cesto come `CID` 842259 ha attraversato circa 30 USD fra primo e ultimo ingresso: a 0,5-1,0 lotti il flottante possibile e' di centinaia di EUR, **non misurato** (il file non ha MAE/MFE).

## 3. Costo, tempo, campione
- Commissione A/R 4,00 EUR/lotto [LETTO nel conto]; **spread NON noto** (assente nel file): `stop >= 40 x spread` non si verifica; sui moduli `[F]` lo «stop» e' quasi assente. Su 0,01 lotto la commissione e' 0,04 EUR contro un TP lordo di circa 0,89 EUR: ~4,5%.
- **Campione**: i `CID` partono da 842167 (13/10 00:00) a 842292 (13/10 20:52): **circa 21 ore, UN solo giorno di mercato**. 633 posizioni in un giorno non sono 633 prove indipendenti: sono un regime. **Merito: NON MISURATO** (n < 150 e un solo regime); il PF 1,485 del conto e il +541 di `[R]` si leggono come descrizione, non come edge.
- **Concentrazione** (`[R]` buy): migliori 3 posizioni = 91,18 su netto 318,43. Le migliori 5 ceste per `CID` pesano 21-32 EUR ciascuna; la peggiore -9,7 [MISURATO nei 94 `CID`]: finora nessuna cesta ha avuto la perdita grande che una scala di lotti senza SL puo' avere.

## 4. Bandiere rosse per le prop
| bandiera | stato | nota |
|---|---|---|
| senza SL iniziale | **SI** (moduli `[F]` e `[R]`) | SL comune compare dopo, rischio fra ingresso e modifica non misurabile |
| griglia / media a prezzo peggiore | **SI** (`[R]`, catena 11-15) | proibita per la challenge di casa |
| scala di lotti crescenti | **SI** (0,01 -> 0,17) | non e' raddoppio per perdita, ma il rischio cresce coi livelli |
| recovery a cesto con uscita comune | **SI** | il modulo `[R]` e' esplicitamente recupero [INFERITO] |
| hedging nella stessa famiglia | 10 ingressi col lato opposto vivo in una famiglia `[F]`; il tool non separa le istanze | [NON VISTO] |
| scalping | **SI** (durata mediana 1-9 minuti) | costo reale non misurabile (spread) |
| dipendenza dall'orario | no (ingressi sulle 24 ore, 4-8% per ora) | -- |
**Come EA cosi' com'e', NON entra nell'imbuto prop** (griglia, no-SL, rischio non cappato): e' una constatazione sulle regole di casa, **non un verdetto sul merito** del motore.

## 5. Cosa ne facciamo per i nostri EA (ipotesi misurabili, non criteri)
1. **Uscita a cesto con SL comune** (tutte le posizioni dello stesso segnale chiudono insieme allo stesso SL spostato): e' un meccanismo di gestione che sui nostri motori a due gambe (EMA200: due ordini limite per segnale) si puo' mettere ad asse come uscita. Attesa e smentita da scrivere prima; un asse di uscita per volta.
2. **Micro-scalp a favore con TP fisso breve** (`[F]`): da misurare solo se lo spread dell'oro regge (`stop >= 40 x spread` sul TP breve e' il primo cancello: a +1,00 USD contro uno spread di ~0,2 [DERIVATO dall'ancora del tester sull'oro, mediana 0,21: NON lo spread del conto live, non misurato] il rapporto e' dell'ordine di 5x, **sotto la frontiera** (e il TP non e' lo stop: e' un'analogia di ordine di grandezza), quindi con ogni probabilita' non e' schierabile come sedia). Va scritto cosi', col numero accanto, prima di perdere tempo macchina.
3. Il `[R]` si **studia, non si replica**: griglia e recovery sono fuori dal perimetro prop.

## 6. Cosa manca per una lettura completa, e la via piu' corta
- **Nome esatto del prodotto sul Market / link** (poi pagina pubblica) **e screenshot degli input** (lotto base, passo della griglia, moltiplicatore, TP, SL di cesto): a Claudio costa 2 minuti.
- **Piu' giorni** (almeno 5-10 giornate, con un giorno di trend forte): senza una giornata contro la scala, la coda del rischio non e' misurata. Il ReportHistory ogni sera: al ritmo di ~600 posizioni al giorno n arriva a 30 per famiglia subito, ma il **regime** serve.
- **SL/TP finali e spread**: il report non ha lo spread; chiederlo al logger di spread del terminale 50503392 [NON MISURATO].
- **Difetto del tool trovato**: `natura_motore_da_storico.py` comprime solo contatori di 1-4 cifre; un identificativo `CID=842259` di 6 cifre **spezza ogni famiglia in centinaia di righe** e nasconde griglia/martingala (con il raggruppamento a mano escono). Va corretto (contatori >= 5 cifre dentro parentesi quadre o dopo `=`), con contro-esempio sulle famiglie nostre e nuovo SHA, passando dal cancello. **Non ancora fatto.**
