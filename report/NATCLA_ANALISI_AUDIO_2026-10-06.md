# Ea Nat&Cla - Analisi fedele dei tre audio della collega (06/10/2026)

**STATO: BOZZA, NON passata dal cancello** (ne' `controlla_riga.py` strato 1 con esito PASS riportato qui sotto, ne' `controllo-preventivo` strato 2). Non va usata per scrivere codice finche' non e' passata.

**Fonti usate, e SOLO queste** (regola ferrea di Claudio):
- `data/natcla/PTT-20261006-WA0090.txt` (~3 min) - TurboScribe
- `data/natcla/PTT-20261006-WA0091.txt` (~18 s) - TurboScribe
- `data/natcla/PTT-20261006-WA0092.txt` (~1,5 min) - TurboScribe
- Confronto dei passaggi dubbi con la trascrizione locale `/tmp/trascr.json` (modello locale, piu' rozza: **lo dichiaro ogni volta che la uso**, con la sigla `[LOC]`; la sigla `[TS]` e' TurboScribe).
- Il PDF `ABTG-SUPERTREND_REVERSAL.pdf` **NON e' analizzato qui** (lo fa un altro agente). La collega lo cita in WA0090: *"ti mando adesso anche il file del super trend, ... Super trend reversal, quello che ci aveva dato Paolo, cosi' magari prendi qualche spunto anche da li'"*. Quindi il PDF e' **"spunto"** secondo le sue parole, non la regola: dove audio e PDF divergono, l'audio e' la voce della collega, ma la divergenza va chiesta a lei.
- Nessun web. Nessun altro file del repo come fonte. Del repo ho usato solo `CLAUDE.md` (regole di casa: cancello del costo, bandiere rosse, convenzioni) come mi e' stato chiesto.

Etichette: **[DICHIARATO]** (detto in modo esplicito, cito) / **[DEDOTTO]** (lo deduco da piu' passaggi, dico quali) / **[AMBIGUO]** (il testo ammette piu' letture, le elenco).
Il parlato e' un audio trascritto: niente di cio' che la collega ha visto a schermo e' noto. **Tutti i numeri sono "dichiarati dalla collega, NON verificati" e non hanno alcun valore di performance** (nell'audio non c'e' nessun numero di performance).

---

## 1. TESTO INTEGRALE PULITO

Convenzione: tra parentesi quadre le mie aggiunte minime di punteggiatura/articolo; ogni **correzione di parola** e' elencata nel §1.4. Non ho aggiunto ne' tolto contenuto operativo. Le frasi che nel parlato restano spezzate o autocorrette sono **lasciate spezzate** (la correzione dell'ADX e' un fatto del parlato, non un errore da ripulire).

### 1.1 `PTT-20261006-WA0090.txt` (~3 min)

> Aiuto, allora, provo. Cosa utilizzo? La media 200, il Supertrend, tutti i tre livelli: 2.5, 3, 3.5, la media 9 e la media 21. Poi ADX e Bande di Bollinger per vedere in che direzione e'. L'analisi la faccio in H1, H4, H12 e daily. Qualche volta anche in weekly, se vedo che c'e' il Supertrend vicino.
>
> Cosa guardo? Allora, io ti mando adesso anche il file del Supertrend, [del] Supertrend Reversal, quello che ci aveva dato Paolo, cosi' magari prendi qualche spunto anche da li'.
>
> Io guardo sul Supertrend 3.5 partendo da H1. Nel senso: deve rimbalzare. Toccare una volta il rimbalzo, al massimo due volte; di piu' no, perche' poi sfonda.
>
> L'ADX deve essere a meta', che sarebbe, mi sembra, 20, 25, non di piu' - anzi aspetta che controllo - perche' se no... no, a 20: deve essere a 20, non di piu', perche' se no rischia anche di sfondare.
>
> Invece sul primo Supertrend, che e' 2.5, entro solo per la prima volta, se va a violare per la prima volta e poi tornare. La stessa cosa anche sul secondo, che entra e poi ritorna. Invece sul terzo e' quello piu' sicuro: puo' essere anche due volte.
>
> Poi, se c'e' la confluenza di media 200, nel senso che e' li' sulla stessa altezza, e' ancora meglio: quindi entro con le size ancora piu' grosse, perche' il rimbalzo ci sara' di sicuro. Tutto qua, le size.
>
> Sul terzo Supertrend uso, in generale, non so, dieci volte tanto. Se vuoi mettere dentro anche questa cosa, che lui te la va a prendere anche, le size, va bene. Dimmi se va bene cosi' o se ti manca qualcos'altro.

### 1.2 `PTT-20261006-WA0091.txt` (~18 s)

> Ah si', take profit lo metto a praticamente 10 pip, e anche stop loss sopra: metto di solito leggermente sopra qualche resistenza, se c'e'.

### 1.3 `PTT-20261006-WA0092.txt` (~1,5 min)

> Allora, un'altra cosa importante e' che la EMA 200 non deve essere dritta, ma deve essere abbastanza inclinata. E questo ingresso possiamo farlo sia solo sulla EMA 200, dall'H1 o H4 in su, non sotto, sia sul Supertrend, sempre dall'H1 in su.
>
> E le size le metto, diciamo, 5/10 punti sotto: prima size un po' leggera, poi l'altra un po' piu' pesante, proprio sulla EMA o sul Supertrend, e un'altra leggermente sopra, di 5 punti, sempre di Supertrend o media 200.
>
> E ovviamente take profit lo metto a 10 punti dal Supertrend o EMA sotto. Con le size ovviamente non come quando fai andare in trend following, ma dura al massimo l'operazione, penso, un'oretta, neanche; a volte dura anche qualche secondo.

### 1.4 Cosa ho corretto e perche'

| Testo grezzo [TS] | Correzione | Perche' | Conferma `[LOC]` |
|---|---|---|---|
| `sides` / `i sides` / `le sides` (WA0090, 4 occorrenze) | `size` | Il contesto e' il dimensionamento ("size ancora piu' grosse", "le size sul terzo Supertrend"); suggerito anche dal committente | `[LOC]` scrive "size" in 3 punti su 4 ("con i size ancora piu' grossi", "le size") e "sides" solo in "anche le sides": **conferma la lettura size** |
| `size` / `gli size` (WA0092) | `le size` | Genere/numero del parlato; il significato non cambia | `[LOC]`: "l'eSize" / "il sezzo": rumore |
| `sconda` (WA0090) | `sfonda` | Il contesto e' "rimbalza ... di piu' no perche' poi sfonda" (rompe il livello). Entrambe le trascrizioni hanno "sconda" -> e' proprio quel che e' stato riconosciuto; la correzione e' semantica | `[LOC]` "sconda": stessa forma |
| `Le ADX` / `Le ad X` | `L'ADX` | Articolo + indicatore | `[LOC]` "Le ad X" |
| `super trend` | `Supertrend` | Nome dell'indicatore | - |
| `5 barra 10 punti sotto` (WA0092, [TS]) | `5/10 punti sotto` | "barra" = lo slash letto ad alta voce | `[LOC]` scrive "5/10 punti sotto" -> **la conferma e' diretta**. Resta la domanda se "5/10" sia un intervallo ("5-10") o "5 oppure 10": vedi ambiguita' |
| `Perche' se no, no a 20` | `perche' se no... no, a 20` | E' una autocorrezione a meta' frase; la virgola dopo "no" era punteggiatura | `[LOC]`: "ma a 20" |
| `Aiuto, allora, provo` | **lasciato `Aiuto`** | Non operativo (probabile intercalare o scherzo della collega). `[LOC]` ha "Alliuto". Non lo uso | `[LOC]`: "Alliuto" -> incerto, ininfluente |
| `dieci volte tanto` | **lasciato** | Solo `[TS]` ha "tanto"; `[LOC]` ha "in 10 volt" (troncato). Resta ambigua la *portata*, non la parola | vedi §3 |
| `che a lui lo va a prendere anche le sides` | `che lui te la va a prendere anche, le size` | `[TS]` ha "lui te la va a prendere", `[LOC]` "a lui lo va a prendere": **le due letture differiscono**; ho preso quella `[TS]` perche' e' piu' coerente con "Dimmi se va bene cosi'" (la collega parla a Claudio e "lui" = l'EA/l'automazione). **Questo passaggio e' [AMBIGUO]**, non lo considero un fatto | vedi riga R14 |
| `PAPEROFIT` ([LOC] WA0091) | non usata | e' l'errore del modello locale per "take profit"; `[TS]` ha "take profit" | - |

### 1.5 Il numero piu' delicato: l'ADX (confronto dichiarato)
- `[TS]`: *"L'ADX deve essere a meta' che sarebbe mi sembra **20 25** non di piu' anzi aspetta che controllo ... no a **20**, deve essere a **20** non di piu'"*.
- `[LOC]`: *"... a meta' che sarebbe mi sembra **25** non di piu', anzi aspetta ... ma a **20**, deve essere a **20** non di piu'"*.
- Le due letture **concordano sul valore finale: 20** (detto due volte, dopo la correzione); differiscono solo sulla prima stima ("20 25" contro "25"). Attenzione: **non sono due fonti indipendenti** (stesso audio, due riconoscitori): la concordanza esclude un errore del solo TurboScribe, **non** un errore di pronuncia/ricordo della collega. **[TRASCRITTO chiaro]** "20 non di piu'". Non e' un dato verificato.

---

## 2. TABELLA DELLE REGOLE

Legenda colonna ultima: **SI** = meccanizzabile cosi' com'e'; **PARZ.** = serve un parametro che l'audio non dice; **NO** = discrezionale/non definito. Le citazioni portano **file + frase** (il testo e' quello grezzo `[TS]`, salvo dove indicato). "(R)" = numero di riga.

| # | Regola | Valore | Citazione (file, frase) | Stato | Meccanizzabile |
|---|---|---|---|---|---|
| R1 | Media mobile lenta | periodo **200** | WA0090: *"La media 200"*; WA0092: *"la EMA 200"* | Periodo **[DICHIARATO]**. Tipo: **EMA** detto solo in WA0092; in WA0090 dice "media 200" -> **[DEDOTTO]** che sia la stessa. Prezzo applicato non detto | SI (tipo/prezzo da confermare) |
| R2 | Supertrend a **tre livelli** | **2.5 / 3 / 3.5** | WA0090: *"il super trend, tutti i tre livelli 2.5, 3, 3.5"* | Valori **[DICHIARATO]**. Che 2.5/3/3.5 siano il **moltiplicatore ATR** e non altro **[DEDOTTO]** (nome non detto). **Periodo ATR NON detto** | PARZ.: serve il periodo (e conferma moltiplicatore) |
| R3 | Ordine dei livelli | 1o = 2.5; 2o = 3; 3o = 3.5 | WA0090: *"sul primo super trend che e' 2.5"*; *"sul secondo"*; *"sul terzo e' quello piu' sicuro"* | "primo = 2.5" **[DICHIARATO]**; "secondo = 3" e "terzo = 3.5" **[DEDOTTO]** (ordine crescente + la frase sul "3.5 ... una volta, al massimo due" coincide con "il terzo ... anche due volte") | SI |
| R4 | Media 9 e media 21 | 9 e 21 | WA0090: *"la media 9 e la media 21"* | Elencate fra gli strumenti **[DICHIARATO]**; **nessuna regola d'uso** in nessun audio. Tipo (EMA/SMA) non detto | **NO** (nessuna regola da codificare) |
| R5 | ADX (ruolo generico) | strumento "per vedere in che direzione e'" | WA0090: *"Poi ADX E Bande di bollinger per vedere in che direzione e'"* | Elencato **[DICHIARATO]**; il ruolo di "direzione" **[AMBIGUO]** (ADX e Bollinger usati insieme "per la direzione"; **periodo ADX non detto**) | PARZ. (periodo mancante) |
| R6 | Bande di Bollinger | usate "per la direzione" | WA0090: stessa frase | **[AMBIGUO]**: nessun periodo, deviazione, ne' regola d'ingresso/filtro | **NO** |
| R7 | Timeframe di **analisi** | **H1, H4, H12, daily**; weekly "qualche volta" | WA0090: *"L'analisi la faccio in h1, h4, h12 e daily. Qualche volta anche in weekly se vedo che c'e' il super trend vicino"* | **[DICHIARATO]**. Il weekly e' condizionato a "Supertrend vicino": soglia di "vicino" **non detta** -> quella parte **[AMBIGUO]** | SI per H1/H4/H12/D; **NO** per il weekly condizionato |
| R8 | **Gate di timeframe d'ingresso** (Supertrend) | da **H1 in su** | WA0092: *"sia sul Supertrend, sempre dall'H1 in su"*; WA0090: *"io guardo sul super trend 3.5 partendo da h1"* | **[DICHIARATO]** (due volte, coerenti) | SI (min TF = H1) |
| R9 | **Gate di timeframe d'ingresso** (EMA 200 sola) | da **H1 o H4 in su**, "non sotto" | WA0092: *"sia solo sulla EMA 200, dall'H1 o H4 in su, non sotto"* | **[DICHIARATO]**; **[AMBIGUO]** se sia "H1 o H4" come TF *minimo* (H1 incluso: dedotto dal "sempre dall'H1" della frase successiva) o come due soli TF permessi | PARZ. |
| R10 | Che **TF opera davvero l'ingresso** | NON detto | -- | La collega dice dove "analizza"/dove si "entra" ma non dove si **piazzano gli ordini**; vedi R22 (durata di secondi) | **NO** |
| R11 | **ST 3.5 (terzo): rimbalzo** | tocco **1 volta**, al massimo **2**; di piu' no | WA0090: *"deve rimbalzare. Toccare una volta il rimbalzo, al massimo due volte, di piu' no perche' poi sconda"* | **[DICHIARATO]**. Cosa sia un "tocco" (high/low sfiora? chiusura sotto?) e **da quando si contano** (reset?) **NON detto** | PARZ.: serve definizione di tocco e di reset del contatore |
| R12 | **ADX massimo** | **ADX <= 20** ("non di piu'") | WA0090: *"deve essere a 20 non di piu' perche' se no rischia anche di sfondare"* | **[DICHIARATO]** (dopo autocorrezione da "20 25"/"25" - vedi §1.5 e §4). A quale/i livello/i vale (solo il 3.5, dove lo dice, o tutti e tre?) **[AMBIGUO]**; su quale TF e quale periodo **NON detto** | PARZ. (periodo ADX, TF di lettura, estensione ai livelli 2.5/3) |
| R13 | **ST 2.5 (primo)** | entra **solo la prima volta** che lo viola e poi torna | WA0090: *"sul primo super trend che e' 2.5 entro solo per la prima volta. Se va a violare per la prima volta e poi tornare"* | **[DICHIARATO]**. "violare" (rompere il livello) + "tornare" (rientrare) = un evento *di rottura e ritorno*, **diverso** dal "tocco e rimbalzo" del 3.5: la differenza non e' esplicitata -> **[AMBIGUO]**; da quando si conta "prima" non detto | PARZ. |
| R14 | **ST 3 (secondo)** | "la stessa cosa" del primo | WA0090: *"la stessa cosa anche sul secondo che entra e poi ritorna"* | **[DICHIARATO]** (per rinvio). Se "stessa cosa" include "solo la prima volta" (= R13) e' **[DEDOTTO]** | PARZ. |
| R15 | **ST 3.5 (terzo) come "il piu' sicuro"** | puo' avere anche 2 volte | WA0090: *"sul terzo e' quello piu' sicuro. Puo' essere anche due volte"* | **[DICHIARATO]** (coerente con R11). "piu' sicuro" e' un giudizio soggettivo, non una soglia | SI (come R11) |
| R16 | **Confluenza con EMA 200** | EMA 200 e Supertrend "sulla stessa altezza" = meglio, **size piu' grosse** | WA0090: *"se c'e' la confluenza di media 200 nel senso che e' li' sulla stessa altezza e' ancora meglio quindi entro con i sides ancora piu' grossi perche' il rimbalzo ci sara' di sicuro"* | **[DICHIARATO]**. **Quanto vicine** (tolleranza in punti/ATR) e **quanto piu' grosse** NON dette | PARZ.: tolleranza + moltiplicatore size |
| R17 | **Moltiplicatore size sul 3o ST** | "in generale, non so, dieci volte tanto" | WA0090: *"le size sul terzo supertrend uso in generale, non so, dieci volte tanto"* | **[AMBIGUO]** (3 letture, §3.1): 10x rispetto a cosa? E "non so" = la collega **non e' sicura** del numero. `[LOC]` ha "in 10 volt" (conferma "10", non "tanto") | **NO** finche' non risponde |
| R18 | **Gestione size = opzionale?** | "se vuoi mettere dentro anche questa cosa ... va bene" | WA0090: *"se vuoi mettere dentro anche questa cosa che lui te la va a prendere anche le sides va bene"* | **[AMBIGUO]**: la lettura piu' naturale e' che le **modulazioni di size (R16/R17) siano un extra opzionale** che l'EA "se vuole" include; `[LOC]` ha una frase diversa ("a lui lo va a prendere") | n/a (decisione di Claudio) |
| R19 | **EMA 200 inclinata** | "non dritta, abbastanza inclinata" | WA0092: *"la EMA 200 non deve essere dritta, ma deve essere abbastanza inclinata"* | **[DICHIARATO]** la condizione; **soglia di inclinazione NON detta**; **verso** (su per i long, giu' per gli short?) **NON detto** e **non dedotto da me** | PARZ.: serve metrica di pendenza e soglia |
| R20 | **Tipo di ingresso** | o **solo EMA 200**, oppure Supertrend | WA0092: *"questo ingresso possiamo fare sia solo sulla EMA 200 ... sia sul Supertrend"* | **[DICHIARATO]**. **[AMBIGUO]**: "solo" = "anche da sola, senza Supertrend" (lettura che adotto) oppure "solo e soltanto la EMA" | SI (due triggers separati) |
| R21 | **Tre ordini a scala** | (a) "5/10 punti sotto", **leggera**; (b) "proprio sulla EMA o sul Supertrend", **piu' pesante**; (c) "leggermente sopra, di 5 punti" | WA0092: *"gli size li metto diciamo 5 barra 10 punti sotto, prima size un po' leggera, poi l'altra un po' piu' pesante proprio sulla EMA o sul Supertrend e un'altra leggermente sopra di 5 punti sempre di Supertrend o media 200"* | Struttura a **3 ordini** **[DEDOTTO]** da "prima ... poi l'altra ... e un'altra"; i numeri 5/10 e 5 **[DICHIARATO]** ma l'**intervallo** "5/10" e' **[AMBIGUO]**; la **taglia dei tre** ("un po' leggera", "un po' piu' pesante") **non e' numerica**; la taglia del terzo non e' detta; "sotto"/"sopra" di cosa e in che direzione: **vedi §3.2** | **NO** (taglie e direzione non definite) |
| R22 | **Take profit** | **10 pip** (WA0091) / **10 punti dal Supertrend o EMA** (WA0092) | WA0091: *"take profit lo metto a praticamente 10 pip"*; WA0092: *"take profit lo metto a 10 punti dal Supertrend o EMA sotto"* | Valore "10" **[DICHIARATO]** in entrambi; **unita' diversa** (pip/punti, §3.3); "praticamente" = approssimato; **distanza misurata dalla linea (ST/EMA), non dal prezzo d'ingresso** **[DEDOTTO]** da "dal Supertrend o EMA" -> **[AMBIGUO]** vedi §3.4 | PARZ.: unita' e punto di misura |
| R23 | **Stop loss** | "leggermente sopra qualche resistenza, se c'e'" | WA0091: *"anche stop loss sopra, metto di solito leggermente sopra qualche resistenza se c'e'"* | Esiste uno stop **[DICHIARATO]**; **nessun valore numerico**, **"di solito"** e **"se c'e'"** = discrezionale; cosa succeda **senza resistenza** NON detto; "resistenza" non e' definita (swing high? Supertrend? altro?) | **NO** |
| R24 | **Durata** | "al massimo ... un'oretta, neanche; a volte qualche secondo" | WA0092: *"dura al massimo l'operazione penso un'oretta neanche a volte dura anche qualche secondo"* | **[DICHIARATO]** come **osservazione** ("penso"), **non** come regola di uscita temporale: nessuna chiusura a tempo detta | Come osservazione: no; come regola: **NO** (non e' una regola) |
| R25 | **"Non trend following"** | la tecnica non e' trend following | WA0092: *"con le size ovviamente non come quando fai andare in trend following ma dura ..."* | **[AMBIGUO]** (§3.5): la frase e' monca; non si capisce se riguarda **size** o **durata/gestione** | NO |
| R26 | **Direzione (long/short)** | NON dichiarata | WA0091 "stop loss sopra ... resistenza"; WA0092 "5/10 punti sotto" e "dal ST o EMA sotto" | **[AMBIGUO]**: **vedi §3.2**. Nell'audio non compare mai la parola "long/short/buy/sell/compra/vendi" | NO (finche' non risponde) |
| R27 | **Simbolo/i, sessioni, rischio per trade, max trade/posizioni, uscita se il ST cambia** | NON detti | -- | Assenti | **NO** |

---

## 3. LE AMBIGUITA', una per una

### 3.1 "Dieci volte tanto" (R17)
Testo: *"Tutto qua, le size. Sul terzo super trend uso in generale, non so, dieci volte tanto."*
Letture possibili (nessuna e' dichiarata):
1. **10 volte la size "base"** (quella usata sul primo/secondo livello, o quella standard) -> moltiplicatore di **x10**.
2. **10 volte "un po' di piu'"** di qualcosa di piccolo: usato come modo di dire ("molto di piu'").
3. **10 volte** riferito a un **numero di tocchi/operazioni** (lei prima parlava di "una volta, due volte"); resa meno probabile dal fatto che segue "le size" e il "tutto qua, le size", ma non esclusa.
La collega stessa dice **"non so"**: **non e' una regola, e' una stima ad alta voce**. `[LOC]` conferma "10" ma tronca la frase ("in 10 volt"): la parola "tanto" e' solo `[TS]`. **Nessun codice va scritto su questo numero.**

### 3.2 "Sotto" e "sopra": long, short o entrambi? (R21, R22, R23, R26)
I fatti, tutti citati:
- WA0092: *"le size le metto 5/10 punti **sotto**"*; *"un'altra leggermente **sopra** di 5 punti"*; *"take profit lo metto a 10 punti dal Supertrend o EMA **sotto**"*.
- WA0091: *"anche stop loss **sopra**, ... leggermente **sopra** qualche **resistenza**"*.
- In nessun audio compaiono "long", "short", "buy", "sell", "acquisto", "vendita".

Le letture, senza inventare:
- **Lettura A (lato long, prezzo che scende sulla linea)**: la linea (ST o EMA) e' **sotto** il prezzo (supporto). "Sotto" = livello inferiore alla linea. Ordine **di riempimento** (prezzo che scende): +5 sopra la linea per primo, poi sulla linea, poi 5/10 sotto: **non coincide con l'ordine in cui lei li elenca** ("prima leggera ... poi pesante ... un'altra sopra"). TP "10 punti dal ST/EMA" = verso l'alto. Ma lo **stop "sopra qualche resistenza"** **non e' uno stop da long** (uno stop da long sta sotto): la lettura A contraddice WA0091 (a meno che WA0091 parli di un'altra cosa/lato).
- **Lettura B (lato short, prezzo che sale sulla linea sopra di lui)**: la linea e' **sopra** il prezzo (resistenza). Ordine di riempimento (prezzo che sale): 5/10 sotto la linea per primo ("prima size leggera"), poi sulla linea ("l'altra piu' pesante"), poi 5 sopra ("un'altra"): **coincide con l'ordine in cui li elenca**. Stop "sopra qualche resistenza" **e' coerente**. TP "dal ST o EMA sotto" = verso il basso: **coerente**. Questa lettura B e' **[INFERITA]** da 4 indizi (ordine dell'elenco, stop sopra, TP sotto, "resistenza"), ma **non dichiarata**.
- **Lettura C (entrambe le direzioni, specchio)**: la collega descrive per esteso un solo lato e il resto e' simmetrico (nei suoi esempi di "rimbalzo" non si sa se il lato e' quello del supporto o della resistenza). Possibile ma **non scritta**.
- **Nota di coerenza** (misurata sul testo): sotto la lettura B, con "5/10 punti sotto" la linea e il **TP a 10 punti dalla linea** -> il primo ordine (a 10 sotto la linea) ha il **TP a distanza 0** dal prezzo di riempimento (e a 5 se la scala e' a 5). Quindi o il TP e' misurato **dal prezzo di ingresso** e non dalla linea, o "5/10" va letto come "5" (non 10). Un'ulteriore ragione per chiedere.

**Conclusione onesta:** il verso NON e' deducibile con certezza. Per costruire un EA bisogna che la collega dica "e' un acquisto/vendita sul supporto/sulla resistenza (o entrambi)".

### 3.3 "Pip" contro "punti" (R22)
- WA0091: *"praticamente **10 pip**"*; WA0092: *"**10 punti** dal Supertrend o EMA"*; ingresso *"**5/10 punti** sotto"*, *"**5 punti** sopra"*.
- Possibili: (i) sinonimi nel suo linguaggio (come si dice a voce); (ii) due strumenti diversi (pip = forex, punti = indici/oro); (iii) quantita' diverse. **Nessuna conferma.** Il simbolo non e' mai nominato. Il valore numerico in prezzo dipende totalmente da simbolo e dalle cifre del broker: **non lo converto, non lo deduco**.

### 3.4 Dove si misura il TP (R22)
*"take profit lo metto a 10 punti dal Supertrend o EMA"*: la letteralita' dice **distanza dalla linea**, non dal prezzo di riempimento. Con tre ordini a prezzi diversi (R21) e un TP **unico ancorato alla linea**, i tre ordini avrebbero **TP a distanze diverse dal proprio ingresso**; oppure c'e' un TP per ordine. NON detto.

### 3.5 "Non come quando fai andare in trend following" (R25)
Frase: *"con le size ovviamente non come quando fai andare in trend following, ma dura al massimo l'operazione..."*. Letture: (a) "con le size [gestite] non come in trend following (dove si lascia correre)" cioe' **la durata e' breve, qui si incassa piccolo**; (b) "le size non sono come nel trend following": **la size e' diversa** (piu' piccola? piu' grande?) - non detto. La struttura "non come ... **ma** dura al massimo ..." favorisce la (a) **[INFERITO, debole]**. Non usabile come regola.

### 3.6 Altre ambiguita' minori
- **"A meta'"** (ADX): *"deve essere a meta' che sarebbe mi sembra 20 25"*: "a meta'" della scala? Poi corretto in "deve essere a 20 non di piu'". Il **segno** della soglia ("non di piu'" = **<=20**) e' **[DEDOTTO]** da "non di piu' ... se no rischia di sfondare".
- **Weekly "se c'e' il super trend vicino"**: "vicino" a che cosa e quanto: non detto.
- **"Poi ADX e Bande di Bollinger per vedere in che direzione e'"**: la frase attribuisce una funzione "direzione" a due indicatori; nessuna regola.
- **"Violare" e "tornare"** (ST 2.5/3) contro **"toccare e rimbalzare"** (ST 3.5): possono essere lo stesso evento descritto con parole diverse, oppure due eventi (rottura con chiusura oltre vs sfioramento). **Non detto.**

---

## 4. CONTRADDIZIONI INTERNE (nei soli tre audio)

1. **ADX: da "20 25" a "20 non di piu'"** (WA0090). *"mi sembra 20 25 non di piu' anzi aspetta che controllo ... no a 20, deve essere a 20 non di piu'"*. **Corretta dalla stessa collega nel parlato**: e' la prima stima ("20 25") ad essere ritirata. **Valore finale: 20, [TRASCRITTO chiaro], detto due volte; ma la collega non era sicura finche' ha detto "aspetta che controllo"** e l'esito del "controllo" non e' nell'audio. `[LOC]` ha "25" nella prima stima.
2. **"pip" (WA0091) contro "punti" (WA0092)** per il TP e il resto (§3.3).
3. **Stop "sopra" (WA0091) contro ordini "sotto" (WA0092)**: possono essere due lati (un messaggio sul long, uno sullo short) o lo stesso lato letto in modo non coerente (§3.2). **Non risolvibile dal solo audio.**
4. **Time frame**: l'ingresso "dall'H1 in su" (WA0092) e "partendo da h1" (WA0090) con l'analisi su H1/H4/H12/daily; **ma la durata dichiarata e' "un'oretta neanche, a volte qualche secondo"** (WA0092). Un'operazione che chiude in pochi secondi/minuti su un livello letto in H1+ implica **esecuzione su TF molto basso o ordini limit gia' piazzati** - non detto (R10). Non e' una contraddizione logica, e' un buco che puo' diventarla.
5. **"Sfonda" come rischio**: *"toccare una volta ... al massimo due volte, di piu' no perche' poi sfonda"* e *"il rimbalzo ci sara' di sicuro"* nella stessa spiegazione: ammette che il livello puo' cedere e insieme dice "di sicuro". Sono due stati d'animo, non due regole - ma lo segnalo perche' e' la base del sizing (R16).
6. **Ordine dei livelli per sicurezza**: 2.5 "solo la prima volta", 3 "la stessa cosa", **3.5 "il piu' sicuro, anche due volte"**: coerente. Pero' il blocco "**ADX <= 20**" e' detto **dentro** il paragrafo del 3.5; **non e' detto** che valga anche per il 2.5/3 (R12).
7. **EMA 200 "non dritta, abbastanza inclinata"** (WA0092) vs **"confluenza con la media 200 sulla stessa altezza"** (WA0090): non si dice se la confluenza richiede anche l'inclinazione.
8. **Size "ancora piu' grosse" con confluenza** (WA0090) e **scala "prima leggera, poi piu' pesante"** (WA0092): sono **due meccanismi di size** diversi (uno fra setup, uno dentro lo stesso setup); non si capisce come si **combinano** (la scala e' moltiplicata dalla confluenza? dal 10x?).

---

## 5. BANDIERE ROSSE (regole di casa, CLAUDE.md)

Premessa: si registrano come **rischi da misurare prima di codificare**, non come giudizio di merito.

| # | Bandiera | Prova (citazione) | Gravita' |
|---|---|---|---|
| B1 | **Size crescenti sulla scala (grid/martingala-like)**: la prima e' leggera, la seconda "un po' piu' pesante", e un terzo ordine in piu'. Se i livelli sono "contro" il prezzo (fill successivo a prezzo peggiore), e' **media al ribasso/al rialzo con taglia crescente** | WA0092: *"prima size un po' leggera, poi l'altra un po' piu' pesante ... e un'altra leggermente sopra di 5 punti"* | **ALTA se la taglia cresce sui fill peggiori** (lettura B del §3.2 la rende piu' una **piramide a scala**; lettura A e' una **media**). La direzione del riempimento **non e' certa** -> bandiera da confermare |
| B2 | **"Dieci volte tanto"**: se e' x10 la size sul terzo Supertrend, e' una taglia **10 volte** quella base **per convinzione** | WA0090: *"le size sul terzo supertrend uso in generale, non so, dieci volte tanto"* | **ALTA se confermata** (rischio per singola operazione non limitato dall'audio); **ambigua e dubitata dalla stessa collega ("non so")** |
| B3 | **Sizing per convinzione soggettiva**: "ancora piu' grosse ... perche' il rimbalzo ci sara' di sicuro" | WA0090: *"entro con i sides ancora piu' grossi perche' il rimbalzo ci sara' di sicuro"* | MEDIA-ALTA: nessuna statistica citata; la "certezza" e' un'affermazione, **non misurata** |
| B4 | **Stop non definito**: nessun valore numerico; "di solito"; "se c'e'" una resistenza. **Cosa succede se non c'e' resistenza non e' detto**: il rischio e' un "nessuno stop" implicito in quel caso | WA0091: *"metto di solito leggermente sopra qualche resistenza se c'e'"* | **ALTA come specifica** (un EA senza stop numerico non e' schierabile); **NON e' "no-SL" dichiarato**: uno stop esiste, ma non e' parametrizzabile |
| B5 | **Rapporto TP/SL ignoto**: TP ~10 e SL "sopra la resistenza" di ampiezza ignota: puo' essere TP piccolo contro SL largo (**win rate alto richiesto**) | WA0091/92 | MEDIA: da misurare, non da dedurre |
| B6 | **Cancello del costo** (CLAUDE.md: `stop >= 40 x spread`): con **TP di 10 pip** e **stop di ampiezza ignota**, la condizione e' calcolabile solo dopo che si conoscono simbolo e stop. **Aritmetica pura**: se lo stop fosse circa 10 pip, lo spread massimo ammissibile sarebbe 10/40 = **0,25 pip**; se 20 pip, **0,5 pip**. Per scegliere i simboli bisogna misurare lo spread **per simbolo e fascia oraria**. Va in piu' contato che il TP "dal ST/EMA" e' relativo alla linea (§3.4): la distanza TP **dal riempimento** puo' essere **molto piu' piccola di 10** per i primi ordini della scala (§3.2) | WA0091: *"praticamente 10 pip"*; WA0092 *"10 punti dal Supertrend o EMA"* | **DA MISURARE**, non un giudizio. E' il vincolo che decide su quali simboli/TF ha senso testare |
| B7 | **Pochi secondi di durata**: operazioni che chiudono "in qualche secondo" sono molto sensibili a slippage/spread/latenza: l'audio non dice se i **limit** sono veri pending o market | WA0092: *"a volte dura anche qualche secondo"* | MEDIA: dipende dall'implementazione |
| B8 | **Rischio aggregato non limitato**: 3 ordini per setup x 3 livelli di Supertrend x piu' TF (H1/H4/H12/D/W) = possibile sovrapposizione di molte posizioni con uno stop non numerico: nessun tetto per cluster/valuta/numero di posizioni nell'audio (il cap rischio aperto 3,25% della casa e' un'altra cosa) | WA0090/92 (assenza) | MEDIA-ALTA: serve un tetto per rispettare i cap di casa |
| B9 | **Recovery / no-SL / martingala dichiarata**: **non dichiarati** | -- | Nessuna prova nell'audio: **non si afferma** che ci sia recovery o martingala "classica" (raddoppio dopo la perdita); c'e' solo la **scala di size dentro lo stesso setup** (B1) |
| B10 | **Trucchi anti-prop / copy / mascheramento**: **NESSUNO** nell'audio | -- | Niente da documentare come intelligence VIETATA |

---

## 6. COSA SI PUO' MECCANIZZARE OGGI (sintesi)

- **Gia' definito abbastanza**: EMA 200; Supertrend con tre moltiplicatori (periodo da dire); H1 come TF minimo; ADX <= 20 come filtro (periodo ADX da dire); "al massimo 2 tocchi" per il 3.5; "solo la prima volta" per il 2.5/3 (definizione di "volta" da dire); TP "10" (unita' da dire); l'esistenza di uno stop vicino a una resistenza.
- **Non meccanizzabile finche' non si risponde**: direzione; unita' pip/punti; stop numerico; taglie (ratio leggera/pesante, confluenza, x10); inclinazione EMA; simboli; orari; rischio per trade; uscita se il ST cambia; ruolo di media 9/21 e di Bollinger.

---

## 7. DOMANDE PER CLAUDIO / LA COLLEGA (non invento nulla)

**Strumento e indicatori**
1. Il **Supertrend 2.5/3/3.5**: sono i **moltiplicatori** dell'ATR? Con **quale periodo** dell'ATR (10? altro)? Lo stesso periodo sui tre livelli? (Il PDF potrebbe dirlo: verifica incrociata dell'altro agente.)
2. La **media 200** e' **EMA** (come in WA0092) o SMA (WA0090 dice "media")? Calcolata sul **close**?
3. **ADX: quale periodo?** Su **quale TF** si legge (lo stesso della linea toccata, o H1)? Il limite "**<= 20**" vale solo per il **Supertrend 3.5** o anche per il 2.5 e il 3? "Non di piu'" significa proprio **<= 20**? (E il suo "controllo" sul 25 che ha fatto?)
4. **Media 9 e media 21**: a cosa servono? C'e' una **regola** (incrocio, pendenza, filtro) o servono solo da lettura visiva?
5. **Bande di Bollinger**: periodo/deviazione? Che regola danno ("vedere in che direzione e'")?
6. **Weekly "se c'e' il Supertrend vicino"**: quanto "vicino" (in punti, in ATR, in %)?

**Setup e conteggi**
7. Cosa e' un **"tocco"** sul Supertrend: il prezzo (high/low) lo **sfiora**, lo **perfora** con l'ombra, o **chiude oltre**? E "violare e tornare" (2.5/3) e' la stessa cosa del "toccare e rimbalzare" (3.5)?
8. **Da quando si contano** "una volta / al massimo due" (reset dopo X barre? dopo un rimbalzo riuscito? dopo l'uscita del prezzo da una fascia?). E "la prima volta" e' la prima dopo cosa?
9. **EMA 200 "inclinata"**: quanto? (esempio: variazione di pendenza su N barre, in ATR?) E il **verso** deve essere concorde con l'operazione (su per il long, giu' per lo short)?
10. **Confluenza**: a che distanza massima la EMA 200 si considera "sulla stessa altezza" del Supertrend (punti/ATR)?

**Direzione**
11. Si opera **solo long** (rimbalzo su supporto), **solo short**, o **tutti e due**? "Sotto"/"sopra" sono riferiti a quale lato? Lo **stop "sopra una resistenza"** (WA0091) e gli **ordini "5/10 punti sotto"** (WA0092) descrivono **lo stesso lato** (probabile short, lettura B) o due lati?

**Ingresso e size**
12. Gli **ordini sono pending limit** piazzati in anticipo, o ingressi a mercato alla conferma? Il TF su cui si **piazzano** e' H1 o piu' basso?
13. **"5/10 punti"**: e' un intervallo (5-10) o "5 oppure 10"? Dalla linea (ST/EMA) o dal prezzo? Quali punti: **pip o punti**?
14. **Le tre size**: quanto "un po' leggera" e "un po' piu' pesante" (rapporto 1:2? 1:1,5?) e quanto la **terza** ("un'altra ... sopra di 5 punti")? Sono **tre posizioni indipendenti**, ciascuna col suo TP/SL, o un'unica posizione a scala?
15. **"Dieci volte tanto"**: 10 volte **cosa**? E' davvero **x10 sulla size** o e' un modo di dire? La collega scrive "non so": e' un numero che vuole davvero usare? **Se e' x10, con quale limite di rischio per operazione?** (e' una decisione di taglie, di Claudio)
16. **"Ancora piu' grosse"** con confluenza: quanto?
17. Cosa intende con *"con le size ovviamente non come quando fai andare in trend following"*: la **taglia** o la **durata/gestione**?

**Uscite**
18. **TP**: "10 pip" o "10 punti"? Misurati **dalla linea** (come detto in WA0092) o **dal prezzo di riempimento** di ciascun ordine? Lo stesso TP per tutti i tre ordini?
19. **SL**: valore numerico? Cosa fa **se non c'e' una resistenza**? Come si definisce la "resistenza" (swing, Supertrend, altro) e quanto e' "leggermente sopra" (punti)? C'e' uno **stop massimo**?
20. Si **esce** se il **Supertrend si rompe** (sfonda) o la EMA cambia? E' previsto un **tempo massimo** (la durata "un'oretta neanche" e' un'osservazione o una regola)?

**Contesto**
21. **Simboli e sessioni/orari**: su quali strumenti lo usa (forex? oro? indici?) e in quale fascia? (Il fuso, se citato, e' da dichiarare: BCM e' UTC+1.)
22. **Rischio per operazione, numero massimo di operazioni aperte/ordini pendenti** e come si **combina** con il tetto di rischio aperto di casa (3,25%)?
23. Che spunti vuole che si prendano dal **PDF Supertrend Reversal** ("prendi qualche spunto anche da li'"): e' la **base** (regole di ingresso del PDF) o solo un'**ispirazione**? In caso di conflitto fra PDF e audio, **vince l'audio**?
24. Gli **screenshot**: se la collega ha un grafico di esempio (un rimbalzo sul 3.5 con ADX 20 e le tre size disegnate), vale piu' di dieci parole: **chiederle uno screenshot**. Nell'audio non c'e' nulla a schermo che sia stato citato ("vedi qui"): **nessun pannello a schermo ignoto individuato dal parlato**; l'unico "file" citato e' il PDF.

---

## 8. COSA NON C'E' (per non riempirlo di memoria)

Nei tre audio **non compaiono**: simboli, orari/sessioni, valore numerico dello stop, rischio per operazione, periodo di ADX/ATR/Bollinger, uso di media 9/21/Bollinger, direzione esplicita, uscita se il ST si rompe, tetti di posizioni, statistiche di performance (win rate, PF, drawdown: **zero numeri di performance** da registrare). Nessuna di queste cose e' stata inventata in questo documento: sono tutte nelle domande del §7.

## 9. NOTE DI METODO E LIMITI DI QUESTA BOZZA

- **Letto per intero**: i tre `.txt` TurboScribe (WA0090: 1 paragrafo, WA0091: 1 frase, WA0092: 1 paragrafo) e `/tmp/trascr.json` (che esiste: 3 chiavi, WA0090/91/92). Confronto `[LOC]` dichiarato dove usato (§1.4, §1.5, R6-R17).
- **Il parlato trascritto sbaglia anche i numeri**: i numeri critici sono "20", "2.5/3/3.5", "5/10", "5", "10", "200", "9", "21", "dieci volte". Tutti **[TRASCRITTO chiaro]** tranne: "20 25" (autocorretta: finale 20, due riconoscitori d'accordo ma **stessa fonte audio**), "5/10" (`[TS]` "5 barra 10", `[LOC]` "5/10": **chiaro come numeri, dubbio sulla semantica**) e "dieci volte" (**ambiguo, non e' il numero a essere dubbio**, ma il significato).
- **Nessun contro-esempio costruito sul codice**: qui non c'e' codice. Il contro-esempio per le letture del §3.2 e' dichiarato (la lettura A contraddice WA0091; la lettura B contraddice, se "10 sotto", il TP a distanza 0): **non scelgo una lettura**, le tengo aperte e le giro alla collega.
- **Stato**: BOZZA, NON passata dal cancello. Non e' un'autorizzazione a scrivere codice.
