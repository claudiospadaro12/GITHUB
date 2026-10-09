# SCHEDA BREVE: live di Emiliano del 09/10/2026 (venerdi', ciclo C, settimana 2)

Fonte unica: `docs/live_emiliano/LIVE_EMILIANO_2026-10-09.txt` (286 righe, nessun timestamp: `r.N` = numero di riga, `cat -n`). Letta per intero, riga per riga. Sapere completo e voci numerate (V62-V75, B18-B24, C22-C25, Q15-Q23) in `docs/SAPERE_LIVE_PER_EA.md` (§2.7, T13). **Tutto qui e' una dichiarazione di Emiliano o di Riccardo (BCM Tech): [DICHIARATO DA LORO], non verificato, non e' un criterio, non e' un parametro. Nessun EA, preset o parametro toccato.** Non navigato sul web.

## 0. Com'e' fatta la trascrizione (leggere prima di fidarsi delle righe)

| righe | contenuto | peso per noi |
|---|---|---|
| r.1-77 | logistica: da lunedi' (12/10) le live passano da Circle alla nuova area `coaching.alfiobardola.com`; Circle "cancellato a fine mese" (r.63) | zero |
| r.79-253 | **live operativa**: apertura con "+25k" e GBA (r.79-81), EURUSD short (r.83-89), DAX (r.91-253), EURUSD di nuovo (r.175-187), regola W/D (r.187-199), oro (r.225-227, poco) | il grosso del metodo |
| **r.255** | riga da **4.734 caratteri**: dentro c'e' un **loop dello speech-to-text** ("un altro piccettino" ripetuto **82 volte**, contate) e, **senza stacco, il cambio di relatore**: parla Riccardo (BCM Tech) con promozione, bonus, commissioni. **Sono andati persi i minuti fra "lo spazio per l'altro ingresso c'e'" (r.253-255) e l'inizio di Riccardo**: quello che Emiliano ha fatto/detto in quel tratto **non lo conosciamo** | l'"altro piccettino" NON e' un'operazione ripetuta 82 volte: e' rumore |
| r.257-277 | Riccardo: bonus 50% fino a 5.000 EUR + 30% fino a 20.000 EUR (valido fino a domenica **18 ottobre**), commissione **3,90 EUR per lotto**, indici senza commissione, live martedi' e giovedi' ~15:15-15:30 (gli "spread abbassati" su DAX e valute li dice **Emiliano**, r.269) | costi BCM: **utile** (V73) |
| r.279-287 | oro: Riccardo + Emiliano in trading range M15, poi **la descrizione dell'EA GBA letta dal manuale** (r.287) | **utile** (V62, V72) |

## 1. Cosa e' utile per i nostri EA (e a quale si collega)

| # | cosa | EA / sedia | stato |
|---|---|---|---|
| **1** | **GBA (EA notturno oro, breakout di canale M1/M3 + EMA100 + stop/trailing ATR + uscita a tempo 48 barre)**: dichiara "+25k", "in reale da una settimana", "non ha chiuso una notte ... una notte negativa". Piu' le **differenze fra la nostra specifica e la trascrizione** (sez. 3) | `ABTG_GoldBreakoutATR` (specifica `report/EA_NOTTURNO_GBA_SPECIFICA_2026-10-09.md`), famiglia oro `770402` (bozza) | tutto sentito dire; **commissione 3,90 EUR/lotto sull'oro non e' nel conto del costo della specifica** |
| **2** | **Costi BCM dichiarati**: commissione 3,90 EUR/lotto su forex e metalli, indici zero, Emiliano a BCM: "Avete abbassato gli spread perche' ve l'ho chiesto, confermo, avete abbassato gli spread sia su DAX che su le valute" (r.269: riduzione su richiesta del coach), nessun numero di spread detto | cancello di costo `stop >= 40 x spread` (DAX BCM 1,70 punti nei nostri file) | **da rimisurare sul nostro feed** prima di muovere qualsiasi soglia; non sappiamo se i nostri conti hanno le condizioni "ABTG" |
| **3** | **Retest del minimo notturno ROTTO con due sell limit** (~25.000 = value area low = minimi della notte), 2o ordine ~20 punti piu' su ("14 non ci puo' stare"), parziale a 20/40 punti + stop in pari, **secondo giro** sul POC | MaxMin DAX `770411` (oggi gioca la rottura), retest DAX `770101`/`770105`; specifica **P-1 del 07/10** (retest del livello notturno, costo-first) | un caso in piu' (n=1 mattina) alla stessa idea: **nessuna misura nuova** |
| **4** | **Media 200 daily come "spartiacque"**: "Mi apre sopra la media, vado long. Mi apre sotto la media, tento lo short ovviamente" (r.241) + "la media 200 c'e' una bella lotta" col supporto weekly (r.251) | **EMA200 Dow H1 `771531`** (legge la EMA200 del TF operativo, non la D1) | forma nuova di U3/V13: **EMA200 D1 come filtro di direzione per lato**; misura possibile a costo zero (split ex post sui per-trade) |
| **5** | **"Da dove arriva il prezzo"**: se il prezzo arriva da un obiettivo (supporto weekly + mediana Bollinger + media), pur con weekly e daily concordi, **taglia ridotta** o niente; si guardano "le ultime tre, quattro, cinque cannelli [candele, STT]" (r.239) e "massimo quattro giorni" (r.247) | nessun EA ha un filtro "arrivo da obiettivo"; piu' vicino: `InpUseAdrFilter`; filtro di direzione D1 (U1) | ipotesi con n atteso basso; non automatizzabile senza una soglia che lui non da |
| **6** | **Il target messo PRIMA del livello "per essere eseguiti"** ("lo metterei a 900 ... lo metterei a 917, ci giusto per essere eseguiti", r.121-123): la regola di fill (V07) applicata al TP | `InpTP*`, `InpRetestOffsetPts` | cifre `[TRASCRITTO dubbio]` |
| **7** | **Stop dettato dalla struttura, non dal budget**: "da 180 a 240 pero' lo stop tecnico va messo li'" (r.179); "lavoro sempre in funzione dello stop" (r.207) | coerente con `CalcLotByRisk` (taglia si adatta allo stop) | **opposto** al 28/09 (B08): contraddizione in V70 |

Non si collega a **nessun** EA nostro (e lo dico per non inventare ponti): **PTE/TMA** (mai nominato), **Bulge/"viola"** (nominata solo la **mediana delle bande di Bollinger** come supporto weekly, r.99, senza periodo ne' deviazione), **ORB** (mai nominato), **MaxMin** come regola esplicita (si parla di "minimi della notte" come livello di retest, non di box).

## 2. Il metodo manuale in breve (frasi esatte, tutte [DICHIARATO DA LORO])

1. **Direzione = weekly e daily, "su tutti i cross, su tutte le valute, su tutti gli indici e oro compreso"** (r.187). Se in contrasto: "il daily ci dice che e' long, il weekly ci dice che e' short, tendenzialmente l'euro dollaro lo lasci stare" (r.175). *Lui stesso poi opera EURUSD in quel contesto e lo chiama "una cazzata" (r.183-185).*
2. **Contesto**: "da dove arriva il prezzo?"; "devo andare a vedere le ultime cinque candele, tre candele" (r.197); weekly arrivato su un supporto che coincide con la mediana delle Bollinger e la media: "il rischio e' che qua rimbalzi" (r.99, r.169).
3. **Media 200 daily "spartiacque"** (r.241) e candela del giorno: "la candela che ha aperto sotto la media 200, quindi la pressione e' ribassista" (r.103).
4. **Ingresso direzionale = a retest, mai inseguendo**: "abbiamo i daily e i weekly che sono direzionali e quindi quando sono direzionali noi cerchiamo un ingresso direzionale" (r.93); retest del minimo della notte rotto con sell limit su value area low / tondo 25.000 / POC (r.111); i minimi della notte "sono stati violati e confermati" (r.111).
5. **Value area / POC / VWAP / Supertrend H1** per posizionare gli ordini: "il POC ... e' il prezzo dove vengono scambiati il maggior numero di contratti" (r.113); "VWAP che porta tutto verso il basso", "super trail ribassista" (r.109). **Nessuna soglia**.
6. **Due ordini, secondo a ~20 punti**: "Di solito 20 punti" (r.131); "14 non ci puo' stare" (r.111). **Secondo ordine non piu' grosso del primo**: "dovevo limitare le size, assolutamente ... basta un'operazione sbagliata che mi vado a infriciare il guadagno" (r.199).
7. **Parziale + stop in pari**: "oltre 40 punti ... addirittura 20, meta' posizione me la porto a casa ... stop in pari" (r.119); altra meta' "sul wrap [VWAP]" a 35 punti (r.233-235). Lo stop in pari e' stato preso (r.135) e il prezzo e' tornato: "secondo giro, secondo regalo" (r.151), "al limite ci facciamo piu' giri" (r.155).
8. **Taglia ridotta quando "non e' trasparente"**: "quando non e' trasparente o non si opera o si opera con size ridotte" (r.111); "ho ridotto le size a 3 e a 6. Ridicole" (r.127). Giornata "limpida" (8/10): W, D, H4, H1 tutti short + "volumi crescenti in pre-apertura" (r.145-147, r.189-191). Oggi: "volatilita' zero. Volumi bassi" (r.125).
9. **Stop con la media M15**: "la media in M15 ... la media mi va a determinare lo stop" (r.205-207); "non vado a piazzare gli ordini direttamente sulla media, perche' ... dovrebbe essere il nostro stop la media" (r.111); "preferisco quindi avere un minimo di stop ampio" (r.209). **Periodo della media NON detto.**
10. **Se non piace la situazione, guadagnare di meno (mio riassunto)**: "quando non mi piace la situazione e' meglio guadagnare di meno e portare a casa profitto. Anche poco" (r.215).
11. **Direzione batte precisione (mio riassunto)**: l'allievo entra a 24.950 "sbagliando l'ingresso ... ero in direzione e ho portato lo stesso profitto" (r.191-193). n=1.
12. Oro (Riccardo/Emiliano): "entrare senza conferma non entrerei" (r.285); conferma = rottura del trading range; "ingresso long alla rottura ... a ribasso non la vorrei fare ... perche' comunque il contesto e' long" (r.287); order block M15 e presa di liquidita' (r.283-285). **Nessuna soglia**.

**Scartato (non misurabile)**: psicologia ("la testa fa tutto", r.219), macro dei treasury (r.285), trendline weekly "massimi e minimi contrapposti" (r.247), Riccardo SIAT/IFTA (r.255).

## 3. GBA: differenze fra la specifica del 09/10 e la trascrizione

La specifica regge sull'essenziale (breakout di canale con filtro EMA, entrata a mercato, stop ATR, trailing, uscita a tempo 48 barre, M1 e a volte M3, un paio di operazioni a notte, solo di notte, in reale da una settimana, 5.000 EUR come esempio di tetto). Le differenze:

| # | punto | la specifica dice | la trascrizione dice | gravita' |
|---|---|---|---|---|
| D1 | **Cosa e' dettato a voce e cosa viene solo dalla foto** | tutti i valori in tabella | a voce: M1 ("entro a un minuto", r.287; "M1 e M3", r.81), **uscita a tempo 48 barre** ("cioe' si fa 48 barre", r.287), **EMA 100 "come filtro"**, **ATR periodo 14**, "spread massimo dell'ATR" (**senza valore**), stop multiplo ATR, trailing. **Solo dalla foto**: canale N = 48 (riga sfocata), kSL 2,5, kTrail 2,5, spread 0,05, breakeven 1,0/0,0, lotti 10,0 (o 0,10), slippage 30. L'unico "48" detto a voce e' **l'uscita a tempo**, non il canale | media: il canale N = 48 e' fonte unica (foto sfocata) |
| D2 | **Tetto di perdita giornaliera** | "in live ha detto di usarla" (tabella) | solo impersonale: "poi **stabilisci** la massima perdita giornaliera dove dici guarda se io perdo piu' di 5.000 euro ti perdo [= ti fermi, `TRASCRITTO dubbio`]" (r.287). **Non dice che lo usa lui** | da correggere: nel pannello e' a 0,0 (spento) |
| D3 | **Frequenza** | "1-2 operazioni a notte" | stessa frase (r.287 "ti fa un'operazione a giorno, due operazioni") **ma** r.285 "ti ha fatto un bel po' di operazioni" (relatore incerto: probabilmente Riccardo che guarda il conto) e "da 49 ... fino a 68 ... da 88 poi e' rientrato 88 a 202" (cifre `[TRASCRITTO dubbio]`, senza unita') | le due frasi non tornano: o la notte fra l'08 e il 09/10 e' stata piu' piena, o "un'operazione" e' il ciclo |
| D4 | **Versione** | `GoldBreakoutATR_v120 1.20` (foto) | "il gold breakout, eccolo qua, **2.0**" (nome del manuale, r.287) | `[INCERTO]` due versioni o STT; il manuale non e' quello del pannello |
| D5 | **Costo oro** | stop/spread >= 50 "per costruzione" (solo spread) | commissione **3,90 EUR per lotto** su forex e metalli "oro, argento" (r.259), "commissione generata da spread piu' commissione fissa" (r.273), spread oro "abbastanza buono" **senza numero** (r.275). Con lotto fisso 10 (se non e' 0,10) sono 39 EUR a giro per ordine `[DERIVATO, commissione per lotto: round-turn o per lato NON detto]` | **alta**: manca la commissione nel conto di costo |
| D6 | **Quanto vale il "+25k"** | non c'e' | r.79 "parto da un piu' 25k"; r.109 "un guadagno molto importante nella notte". **Nessuna unita'** (EUR? punti?), nessun denominatore. Nella stessa live Riccardo dice che "l'oro nella notte ... e' salito alle stelle" (r.263): la notte buona potrebbe essere **una sola notte direzionale** `[INFERITO]` da r.79+r.263, non dimostrato | media: n=1 notte non esclusa |
| D7 | **Accensione** | "la notte e' scelta da lui accendendo l'EA o col filtro orario" | conferma: "**Adesso l'ho disabilitato**" (r.81) e "lo sto provando solo di notte" (r.287). Non dice a che ora lo accende ne' lo spegne | bassa |
| D8 | **"Dopo aver fatto i test"** | non c'e' | "dopo aver fatto i test in reale da una settimana" (r.287): esiste un test precedente, **mai descritto** (periodo? tick? risultato?). Il 05/10 (r.17) faceva fare backtest a un "high frequency spreader" sull'oro che "non produce risultati buoni": cronologia da chiarire | media |
| D9 | **Direzione dell'EA vs la sua lettura** | EA bidirezionale | a voce racconta l'oro come "ingresso long alla rottura ... a ribasso non la vorrei fare" (r.287): la sua **lettura discrezionale** e' solo long col contesto W/D long, **l'EA del pannello compra e vende** con filtro EMA | da chiedere |
| D10 | **Altro assente** | -- | ha "tutti i manuali di EA" in una cartella (r.287): **altri EA oltre a GBA**; "non vi posso dare le A" [= le EA, STT] (conferma la specifica) | informativo |

## 4. Numeri dichiarati (tutti [DICHIARATO DA LORO], nessun campione)

+25k (r.79, unita' non detta) · GBA "in reale da una settimana", 1-2 operazioni a notte, tetto 5.000 EUR (esempio) · EURUSD: stop 100 EUR e 180 EUR, poi 180 -> 240 (r.87, r.179) · DAX: 3 e 6 contratti (r.127), "+30 / +40 punti" (r.117), parziale a 20/40 punti (r.119), secondo ordine a ~20 punti (r.131), target 900 / 917 `[TRASCRITTO dubbio]`, "cento punti al giorno" (r.161), 30 e 35 punti d'uscita (r.153, r.235), "0.8 e 0.8" di taglia su un trade dell'oro con stop in pari (r.281, strumento non detto) · BCM: commissione **3,90 EUR/lotto** (r.259, r.269, r.273), indici senza commissione (r.261), bonus 50%/5.000 EUR + 30%/20.000 EUR fino al 18/10 (r.257-261) · live di Riccardo martedi' e giovedi' "alla preapertura e apertura dei mercati americani ... le tre e un quarto o tre e mezza" (r.263; **fuso non dichiarato**: non converto) · oro: "25 dollari in un secondo" (r.285), "4112" `[TRASCRITTO dubbio]` (livello order block M15, r.283).

## 5. Bandiere rosse (dettaglio nel SAPERE §5)

- **Recupero / mediazione / griglia / hedging / martingala: 0 occorrenze di parola** (grep). **Trucchi anti-prop: 0** (le parole prop, FTMO, challenge, funded non compaiono).
- **Arancione**: "ci facciamo piu' giri" (re-entry sullo stesso livello dopo lo stop in pari, r.155) = B19; EURUSD operato contro la propria regola, "l'ho fatta a cazzo" (r.175-185) = B18; ordine che raddoppia (6 -> 12), da lui stesso detto "sbagliato" (r.197-199) = B20; **rigiro da short a long su spike news dell'oro**, "mi sono dovuto rigirare" (r.285; **relatore incerto**, Emiliano o Riccardo) = B21; "lascerei un altro piccettino" prima del loop (r.255): aggiunta (scale-in) = B22.
- **Ambra**: numeri senza campione (+25k, 7 notti, "Cento punti al giorno") = B23; promozione bonus broker legata al corso (r.257-261) = B24.
- **VIETATO PER NOI** (come da regole di casa): re-entry sullo stesso livello, raddoppio della taglia, rigiro reattivo, scale-in senza stop comune.

## 6. Cosa non ho capito / cosa chiedere (numeri Q nel SAPERE §7)

1. "**Pre-section**" (r.85, r.93, r.95, r.109, r.133, r.207): usata come zona di prezzo con una "fine", **mai definita**.
2. Il **"6 candidati da misurare"** e **"abbiamo anche l'algoritmo"** (r.111): STT, senza senso certo.
3. **Quale giornata** sono le size "3 e 6" contro "6 e 12" (r.127 contro r.197-203): oggi o ieri con Tommaso?
4. **La media 200 daily**: r.103 "la candela che ha aperto sotto la media 200" (cioe' prezzo sotto la 200) ma r.109 "il 25 e 100 e' molto sopra la media a 200 ... dovrebbe sfondare la 2200": le due frasi sono incompatibili se la media e' la stessa. Livelli (2200, 2500, 900, 917, 25 e 100) sono `[TRASCRITTO dubbio]`: lo spazio dei numeri del DAX a schermo **non e' stato dettato**.
5. **Da che ora** parte la "sessione notturna" per i minimi della notte ("non di Tokyo, ma dalla sessione notturna", r.113): confrontare col nostro box del `770411`.
6. **Periodo/TF della "media M15"** che fa da stop (r.205-209).
7. Gli **screenshot** dei livelli del DAX di oggi (M5/H1 di D30EUR su BCM con value area, POC, VWAP, medie) e il **pannello Input di GBA in alta risoluzione** (riga sfocata del canale e dei lotti).
8. Se i **nostri conti BCM** (50503392, 50504263, 10105439) hanno la commissione e lo spread "ABTG" descritti da Riccardo: **non si risponde dalla trascrizione**.
