# 🔎 QUANTI TRADER PROP VANNO A MANO E QUANTI CON EA — scheda del 19/08/2026

_Missione di ricerca lanciata da Claudio (curiosita' con metodo). Obiettivo:
DATI, non opinioni. Consegna breve._

> ⛔ Nessuna proposta operativa qui dentro. Nessun acquisto. Nessuna modifica.
> Questa e' una scheda di intelligence: dice cosa si sa, cosa NON si sa, e
> cosa cambia per noi.

---

## 0. 🔌 CONTROLLO POSITIVO — fatto il 19/08/2026

| canale | prova | esito |
|---|---|---|
| `WebSearch` | interrogato su un bersaglio noto (obiettivi FTMO) → ha restituito **daily 5% / totale 10%, reset 00:00 CE(S)T, formula su equity** = coincide con la scheda 2A del 18/08 | ✅ **canale valido (indiretto)** |
| `curl` diretto `ftmo.com`, `help.fundednext.com` | **403 al CONNECT** | 🔴 NULLA (identico al 18/08) |
| `www.mql5.com` | HTTP 200, pagina intera | ✅ aperta |
| `www.tradingview.com` (mirror Finance Magnates) | HTTP 200, articolo leggibile | ✅ **aperta — e' da qui che arriva l'unico dato [VERIFICATO]** |
| `quantvps.com`, `worldmetrics.org`, `atmosfunded.com`, `financemagnates.com`, `tradeinformer.com`, `fpfxtech.com`, `economywatch.com`, `reddit.com`, `livingfromtrading.com` | egress bloccato / 000 | 🔴 NULLA |

**Conseguenza sull'etichettatura**, come il 18/08:
**[VERIFICATO]** = pagina aperta da me · **[LETTO-VIA-SEARCH]** = letta dallo
strumento, non da me · **[STIMA]** / **[ANEDDOTO]** / **[MARKETING]** = quello
che dichiarano di essere.

---

## 1. 🥇 IL DATO PIU' GROSSO CHE ESISTE — e cosa NON contiene

**FPFX Technologies** (fornitore di tecnologia per prop firm) ha pubblicato
l'analisi piu' ampia in circolazione. Letta da me sul mirror TradingView
dell'articolo Finance Magnates, il **19/08/2026**:
`https://www.tradingview.com/news/financemagnates:3a251e333094b:0-exclusive-only-7-of-300-000-prop-trading-accounts-achieved-payouts/`

| voce | numero | etichetta |
|---|---:|---|
| conti analizzati | **300.000+** | [VERIFICATO 19/08] |
| trader distinti | **100.000** | [VERIFICATO 19/08] |
| prop firm coinvolte | **10** | [VERIFICATO 19/08] |
| passano la challenge | **14%** | [VERIFICATO 19/08] |
| dei finanziati, incassano | **45%** | [VERIFICATO 19/08] |
| **incassano sul totale** | **7%** | [VERIFICATO 19/08] |
| payout medio | **~4% della taglia del conto** | [VERIFICATO 19/08] |
| spesa media in challenge | **~$800**, **2,2 prop per trader** | [VERIFICATO 19/08] |
| uomini | **78%** | [VERIFICATO 19/08] |
| USA 20% · UK 10% · India 4% | | [VERIFICATO 19/08] |

### 🔴 E qui sta la risposta alla domanda di Claudio

**Quel report profila i trader per SESSO, ETA' e PAESE — e NON per
manuale-vs-algoritmico. La suddivisione non c'e'.** Verifica esplicita fatta
sul testo: nessuna frase su EA, bot o algoritmi come quota di conti.

Se il dataset piu' grande del settore (300k conti, 10 prop) non pubblica quel
taglio, **non lo pubblica nessuno**.

---

## 2. 🧾 COSA HO TROVATO AL POSTO DEL NUMERO — e perche' NON vale

| cifra che circola | fonte | perche' non risponde alla domanda |
|---|---|---|
| _"70% delle prop firm supporta l'automazione"_ | pagine aggregatrici 2026 [LETTO-VIA-SEARCH] | misura **quante PROP permettono** gli EA, **non quanti TRADER li usano**. E' la domanda del §3, non questa |
| _"oltre l'80% del trading e' algoritmico"_ / _"~70% del trading azionario USA e' eseguito da algoritmi"_ | blog di venditori di EA [MARKETING] | e' un dato di **mercati istituzionali azionari**. Trasferirlo al retail delle prop e' un salto logico senza appoggio. **Da non usare mai come argomento** |
| _"gli EA passano le challenge piu' spesso dei manuali"_ | blog di vendita EA [MARKETING] | **nessun dataset citato**. E' un argomento di vendita, non una misura |
| _"pass rate 5-10%"_ / _"10%"_ | aggregatori [STIMA] | riguarda il pass rate, non la composizione. Contraddice pure il 14% FPFX: segno che gli aggregatori copiano fra loro |
| poll/survey su Reddit o Forex Factory | — | **non trovati e non leggibili**: `reddit.com` e `forexfactory.com` sono bloccati da qui. Casella **VUOTA, dichiarata** |

---

## 3. 🧩 GLI INDIZI INDIRETTI — l'unica evidenza solida, ed e' misurabile

Non sappiamo QUANTI sono. Sappiamo che **le prop li trattano come categoria di
rischio di primo livello**: ci scrivono regole dedicate, **tariffe** dedicate e
**cap di allocazione per strategia**. Una cosa marginale non la si tariffa.

### 3A. Su 6 prop censite (18/08), **6 permettono gli EA**. Zero divieti totali.
Dal `CONFIG_PROP_2026-08-18.md` §2G: FTMO ✅ · FundedNext ✅ · The5ers ✅ ·
FundingPips ⚠️ (solo propri o risk manager di terze parti) · E8 ✅ (1 strategia
per utente) · Alpha Capital ✅. **Il divieto totale non esiste nel campione.**

### 3B. Le limitazioni NUOVE trovate oggi (19/08) — le piu' parlanti

| prop | regola | etichetta |
|---|---|---|
| **FundedNext** | EA ammessi su MT4/MT5 **ma con una TARIFFA D'USO EA aggiuntiva** da pagare alla prop | [LETTO-VIA-SEARCH 19/08, `help.fundednext.com/en/articles/8020763-is-ea-allowed-in-fundednext`] |
| **FundedNext** | **cap di allocazione $300.000 per ogni strategia di EA/bot** | [LETTO-VIA-SEARCH 19/08, stessa pagina] |
| **FundedNext** | ogni EA deve avere **strategia distinta**, niente trade identici fra conti; **obbligo di personalizzare i parametri** | [LETTO-VIA-SEARCH 19/08] |
| **FundedNext** | **niente EA su cTrader** | [LETTO-VIA-SEARCH 19/08] |
| **FundedNext** | esiste una **lista nera di EA per NOME** (citati da terzi: Forex Flex EA, X Pass Bot) | [ANEDDOTO — fonte terza, non la pagina ufficiale] |
| **FTMO** | niente algo su **cTrader e MatchTrader** (piattaforme "per il manuale") | [LETTO-VIA-SEARCH 19/08, fonte terza aggregatrice] |
| **FTMO** (gia' agli atti 18/08) | cap **$400.000 per trader O PER STRATEGIA** | [LETTO-VIA-SEARCH 18/08] |

> 🎯 **La lettura onesta di questa tabella.** Un cap di allocazione **per
> strategia** (300k FundedNext, 400k FTMO) e una **lista nera di EA per nome**
> hanno senso in un solo mondo: quello in cui **molti conti diversi eseguono lo
> STESSO codice**. E' la prova indiretta piu' forte che gli EA — e in
> particolare gli EA **commerciali di massa** — sono una quota rilevante del
> parco conti. **Non e' un numero, e' una forma.**

### 3C. L'indizio dal mercato degli EA
`mql5.com` aperto il 19/08 [VERIFICATO]: nelle descrizioni dei prodotti della
sezione Expert MT5 la parola "prop firm" e i claim tipo _"5% DD"_, _"FTMO
Results"_, _"Now prop firm..."_ compaiono nel testo di vendita di piu' prodotti
sulla **prima pagina di risultati**. ⚠️ **Il conteggio esatto NON e' stato
ottenuto**: il parametro `query=` non ha applicato il filtro (nessuna
paginazione oltre `page=1`, 70 prodotti generici). **Indizio qualitativo, non
numero.** Dichiarato come tale.

---

## 4. ⚖️ IL VERDETTO ONESTO

> **Le prop firm NON pubblicano questo numero.** Nessuna delle sei censite
> espone una statistica manuale-vs-EA, e il dataset piu' grande del settore
> (FPFX Tech, 300.000 conti / 100.000 trader / 10 prop) profila i clienti per
> sesso, eta' e paese ma **non per metodo di esecuzione**.
>
> **Nemmeno le "stime di settore" esistono davvero.** Le uniche percentuali in
> circolazione — _70% / 80% algoritmico_ — vengono da **mercati istituzionali
> azionari** o da **pagine di vendita di EA**, e non sono trasferibili al
> retail delle prop. Chi le cita come "quota di algo trader nelle prop" sta
> facendo un salto logico.
>
> **Quello che si puo' affermare con evidenza (indiretta ma solida):** gli EA
> sono abbastanza diffusi da costringere le prop a **regole dedicate, tariffe
> dedicate, liste nere per nome e cap di allocazione per strategia**. La
> direzione e' certa; **la percentuale, no. E chi te la da', se l'e' inventata.**

📌 **Range che si puo' onestamente dichiarare: NESSUNO.** Scrivere "X-Y%"
sarebbe esattamente il tipo di numero inventato che il protocollo di casa
vieta. La risposta corretta alla domanda di Claudio e': **il dato non e'
pubblico, e la sua assenza e' essa stessa un'informazione.**

---

## 5. 🎯 COSA SIGNIFICA PER NOI — una riga per cosa

**Sulla COMPETIZIONE.** Non si puo' pianificare ne' su "siamo rari" ne' su
"siamo la massa": il dato non c'e'. **Ma la competizione non e' il vincolo
giusto da guardare** — la prop non paga a graduatoria, paga chi rispetta i
muri. Il 7% che incassa (FPFX, [VERIFICATO]) e' il numero che conta, ed e'
**lo stesso per manuali e algoritmici** perche' nessuno ha misurato la
differenza. La tesi "gli EA passano di piu'" e' **marketing senza dataset**:
non entra nel nostro piano come argomento.

**Sulle REGOLE — qui c'e' un impatto vero.** Il rischio per noi **non e'** "gli
EA sono permessi?" (6 prop su 6: si'). E' cosa ci sta attaccato:
1. **Il cap per STRATEGIA** (FundedNext $300k · FTMO $400k) tocca direttamente
   il punto **E2 del `PIANO_PROP`** (stessa flotta su due conti = copy?) e la
   scelta di portare **un gemello per famiglia**. Con 44 sedie e magic
   dichiarati siamo dalla parte giusta, ma il conteggio va fatto **prima**.
2. **La TARIFFA D'USO EA di FundedNext** e' una **voce di costo mai messa a
   bilancio** in nessun nostro documento. Se FundedNext entra in F1, il prezzo
   della challenge **non e' il prezzo totale**.
3. **Il vantaggio strutturale del nostro assetto e' confermato**: EA
   **proprietari**, magic **dichiarati**, parametri **nostri** — le tre cose che
   le regole colpiscono (codice condiviso, trade identici fra utenti, preset di
   fabbrica) **per costruzione non ci riguardano**. E' la conferma di E6: la
   trasparenza e' la difesa.

### ➕ Due righe da aggiungere a `report/DOMANDE_SUPPORTO_PROP.md` (regola D3)
- **[FundedNext]** _"Qual e' l'importo esatto della EA usage fee, e su quali
  prodotti si applica?"_
- **[FTMO / FundedNext]** _"Un EA **proprietario e non distribuito**, girato
  su due conti miei, rientra nel cap per STRATEGIA ($400k / $300k) o solo nel
  cap per TRADER?"_

_(Sono proposte di aggiunta. L'invio delle domande resta **congelato** dalla
decisione di Claudio del 13/08 — punto E1/F4 del `PIANO_PROP`.)_

---

## 6. 🕳️ COSA NON HO POTUTO VEDERE — dichiarato

- **Reddit e Forex Factory: bloccati.** La casella "survey/poll di comunita'"
  e' **vuota per impossibilita' di accesso**, non per assenza di materiale.
- **Il sito FPFX Tech e Finance Magnates in originale: bloccati.** Il dato l'ho
  letto sul **mirror TradingView**, che e' fedele ma resta un mirror.
- **Nessuna pagina ufficiale di prop e' apribile da qui** (403): tutto il §3B e'
  [LETTO-VIA-SEARCH], **nessuna riga autorizza un acquisto**.
- **Conteggio EA "prop firm" su MQL5 Market: fallito** (filtro query non
  applicato). Rifattibile con un'interrogazione diversa, resa attesa bassa.
- **Non cercato per limite di tempo** (30 minuti): report annuali di singole
  prop, interviste video ai fondatori, dati di Fintokei/Purple Trading.
