# PER GEMINI -- Breakout di canale su oro M1, uscite ad asse: due domande chiuse sui nostri numeri (uscita contro selezione; 27 tranche) -- 11/10/2026

Scritto da Claude per Gemini, secondo `docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md` (ricevuto insieme a questo file) e la BASE di conoscenza che ricevi in testa. Il pacchetto si legge da solo e contiene solo cio' che serve alle due domande della sez. 3.
**Perche' esiste**: regola di casa dell'11/10 (uno ZIP di misura letto genera un pacchetto con al massimo 3 domande falsificabili, una per chiamata). Niente numeri, impostazioni, conti o importi di terzi in questo documento.
Etichette nostre: **[MISURATO]** rifatto da noi su file del repo; **[DERIVATO]** conto su numeri misurati; **[INFERITO]** ragionamento nostro.
**Nota importante**: l'EA e' una **ricostruzione nostra** (da una descrizione a voce e da foto di un pannello di terzi): i numeri dicono cosa fa *quella ricostruzione* sul feed del nostro broker, non cosa fa l'EA di altri.

**Cosa chiediamo, e come rispondere (ruoli del protocollo)**: **Q2** al ruolo **B** (avvocato del diavolo), **Q3** al ruolo **C** (auditor, un conto solo). Una domanda per chiamata. Tabella `N | Affermazione | Etichetta (FATTO / CALCOLO / IPOTESI / NON LO SO) | Fonte (sezione del PACCHETTO, oppure "mia conoscenza di mercato, non verificata") | Verificabile da noi come | Costo`. Ogni affermazione senza fonte e' IPOTESI. "NON LO SO" e' una risposta valida e preferita a un numero inventato. (La numerazione Q2/Q3 resta quella dei nostri file; la Q1 di questo giro e' rimandata a un altro pacchetto.)

---

## 1. Il motore e le condizioni di misura
- **Motore** [descrizione = ipotesi di ricostruzione]: breakout di un canale di N barre M1 a favore di una EMA, ingresso a mercato alla chiusura oltre il canale (long e short). Uscita: stop iniziale e trailing a multipli di ATR, breakeven armato a un multiplo di ATR, uscita a tempo. **Una posizione per volta**: se l'uscita cambia la durata delle posizioni, cambiano anche i segnali che trovano il posto libero.
- **Condizioni** [MISURATO]: oro, M1, tick reali, costi del feed del broker, lotto fisso. Un solo periodo, gennaio-settembre 2026, in tre tranche fisse: T1 luglio-settembre / T2 aprile-giugno / T3 gennaio-marzo.

## 2. I numeri

### 2.1 Le 9 celle  [MISURATO; lettura dell'11/10 della corsa «uscita ad asse»]
PF netto di costi (PF_V) sulla somma delle 3 tranche; PF per tranche dal report del tester. Ogni cella cambia UNA leva d'uscita rispetto alla partenza (REPL).
| cella | cosa cambia | n | n T1 / T2 / T3 | PF_V | PF T1 / T2 / T3 |
|---|---|---:|---|---:|---|
| REPL | valori di partenza | 933 | 128 / 248 / 557 | 0,855 | 0,83 / 0,77 / 0,89 |
| BEOFF | breakeven mai armato | 882 | 121 / 239 / 522 | 0,843 | 0,78 / 0,74 / 0,89 |
| BE05 | breakeven molto vicino | 1.074 | 152 / 280 / 642 | 0,778 | 0,63 / 0,71 / 0,82 |
| BE15 | breakeven piu' lontano | 898 | 122 / 243 / 533 | 0,846 | 0,81 / 0,74 / 0,89 |
| ATRFIX | ATR del trailing fisso al segnale | 926 | 129 / 245 / 552 | 0,886 | 0,72 / 0,81 / 0,94 |
| TOFF | uscita a tempo spenta | 932 | 128 / 248 / 556 | 0,849 | 0,83 / 0,77 / 0,88 |
| K15 | trailing piu' stretto | 1.131 | 148 / 286 / 697 | 0,848 | 0,89 / 0,91 / 0,83 |
| K35 | trailing piu' largo | 873 | 119 / 236 / 518 | 0,911 | 0,96 / 0,82 / 0,94 |
| KOFF | trailing spento | 859 | 118 / 233 / 508 | 0,900 | 0,98 / 0,67 / 0,97 |

- **Rumore** [MISURATO, bootstrap per giorno, 5.000 ricampionamenti]: la REPL fa PF_V 0,855 con intervallo 2,5-97,5% = **0,70-1,03**. Nessuna delle 9 celle supera 1,03.
- **27 tranche su 27 hanno PF < 1** (massimo 0,98, KOFF T1).

### 2.2 La «pendenza» del trailing e cosa misura davvero
- **Contrasto scritto PRIMA dei numeri** [MISURATO contro il file prova del lotto]: pendenza = PF_V(trailing spento) - PF_V(trailing stretto) sulla somma; attesa senza continuazione del prezzo +0,035 (deviazione standard prudente 0,12), con continuazione +0,105 o +0,24. Soglia per «continuazione presente»: pendenza > +0,15, stesso segno in almeno 2 tranche dove entrambe le celle hanno almeno 150 operazioni (con meno di 2 tranche cosi', il segno per tranche non e' misurabile e si decide nella prova in avanti), PF_V(spento) > 1,03. **Misurato +0,052**; tranche giudicabili T2 e T3, pendenza -0,24 e +0,14 (segno discorde). Esito scritto prima: nessuna pendenza oltre il rumore.
- **Scomposizione per ingressi comuni** [MISURATO con uno strumento di analisi in bozza, non passato dal nostro cancello; rifatto da un secondo parser indipendente con gli stessi numeri]. Un ingresso e' identificato da (tranche, data-ora server del deal d'ingresso, lato). Fra trailing stretto (K15) e spento (KOFF):
  - **857 ingressi comuni**; 274 solo in K15; 2 solo in KOFF.
  - Sui comuni, con l'uscita di K15 PF_V **0,8957**, con l'uscita di KOFF **0,8774**: differenza **-0,018**; bootstrap per giorno appaiato (168 giorni, 5.000): deviazione standard **0,127**, intervallo 2,5-97,5% da -0,26 a +0,23, P(differenza <= 0) 0,57. Per tranche, comuni: T1 0,883 -> 0,976 (n 118), T2 0,879 -> 0,669 (233), T3 0,904 -> 0,937 (506).
  - I 274 ingressi solo in K15 hanno PF_V 0,745 (T1 / T2 / T3: 30 / 53 / 191). Dei 2 solo in KOFF, uno vale da solo +7.797,59 unita' di conto.
  - Netto [DERIVATO, somma esatta]: KOFF - K15 = +20.854 = uscita sui comuni -16.380 + solo-KOFF +7.790 - solo-K15 (-29.445).
  - **Lettura** [DERIVATO]: il +0,052 della pendenza viene dalla SELEZIONE (quali ingressi ciascuna cella prende), non dall'uscita: sugli stessi ingressi togliere il trailing cambia il PF di -0,018, dentro un rumore di 0,13.
- **Controlli dello strumento** [MISURATO]: n e PF_V di tutte le 9 celle identici al lettore; sui comuni prezzo d'ingresso, volume e stop iniziale identici in tutte le coppie; spostando la chiave di un minuto o invertendo il lato i comuni scendono a 0-3; la passata gemella della partenza da' identita' al secondo. Contro-esempio: con l'uscita a tempo spenta (TOFF, che quasi non e' una leva) i comuni sono 932 su 933 e la differenza sui comuni e' -0,009 (deviazione standard 0,004), tutta nelle 8 posizioni che nella REPL chiudono a tempo.
- **Limiti della scomposizione**: i comuni sono gli ingressi in cui **entrambe** le celle erano senza posizione, quindi NON un campione casuale (escludono i rientri ravvicinati che solo K15 prende); sui comuni l'uscita e' diversa in 730 posizioni su 857 (uguale in 127); poche operazioni pesano molto (il «solo KOFF» e' in pratica un'operazione); un solo periodo; il bootstrap per giorno ignora la dipendenza fra giorni vicini.

---

## 3. Le domande (una per chiamata). Per ognuna: dato, nostra attesa, contro-esempio

**Q2 (ruolo B) -- Dove sbaglia la nostra scomposizione per ingressi comuni?**
Dato che la motiva: sez. 2.2. Sugli 857 ingressi comuni l'uscita non cambia il PF oltre il rumore (K15 -> KOFF -0,018, deviazione standard 0,127), e la pendenza aggregata +0,052 si spiega con la selezione degli ingressi.
Domanda: costruisci il contro-esempio. Dove puo' sbagliare questa scomposizione (la chiave data-ora + lato; il fatto che i comuni sono gli ingressi in cui entrambe le celle erano senza posizione, e quindi non un campione casuale; il bootstrap per giorno), in modo da cambiare la conclusione «l'uscita, da sola, non sposta il PF», e quale numero, nei dati descritti qui, lo mostrerebbe?
Nostra attesa [INFERITO]: la conclusione regge per QUESTI ingressi; il limite vero e' che non dice cosa farebbe l'uscita di KOFF sui rientri ravvicinati che solo K15 prende (non osservabile da questi deal). Contro-esempio nostro: se la chiave abbinasse ingressi diversi, sui comuni prezzo d'ingresso, volume e stop iniziale differirebbero; misurato: zero differenze (sez. 2.2).

**Q3 (ruolo C) -- Quanto vale davvero «27 tranche su 27 sotto 1»?**
Dato che la motiva: il «27 su 27» e' la frase della nostra lettura che a prima vista sembra piu' forte di quanto sia.
Domanda (UN conto solo, come chiede la memoria condivisa: la deroga dei tre conti e' revocata): le 27 tranche della sez. 2.1 sono 9 celle x 3 periodi (n per tranche in tabella), e le 9 celle girano sugli STESSI giorni con in gran parte gli stessi segnali. Quante osservazioni indipendenti valgono, circa, e con quale probabilita' «27 tranche su 27 con PF < 1» si vedrebbe se il PF vero fosse 1,0? Scrivi formula, numeri e controllo di verso; rispondi NON LO SO dove manca un dato.
Nostra attesa [INFERITO], senza numero: le 27 tranche valgono fra 3 osservazioni (celle perfettamente legate dentro ogni periodo) e 27 (celle indipendenti). La probabilita' che una tranche stia sotto 1 con PF vero 1,0 puo' essere sopra 0,5 (il profitto sta nella coda destra: in una tranche corta il PF campionario sta sotto il vero piu' spesso che sopra). Le due cose alzano entrambe la probabilita' di «27 su 27» rispetto a 0,5^27; non abbiamo un numero: e' la domanda. Contro-esempio nostro (la lettura sbagliata da cui ci difendiamo): trattare le 27 tranche come indipendenti e a 0,5 darebbe 0,5^27, circa 7 x 10^-9, una certezza che i dati non danno.

---

## 4. Fonti nel repo (branch `lavoro`, commit di oggi)
Lettura dell'11/10 della corsa «uscita ad asse» -- file prova del lotto sulla distanza del trailing (sez. «LA PENDENZA») -- referto degli ingressi comuni dell'11/10 (bozza) e il suo strumento di analisi. Memoria, BASE e protocollo: `docs/gemini/MEMORIA_CONDIVISA.md`, `docs/gemini/BASE_CONOSCENZA_PER_GEMINI_2026-10-04.md`, `docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md` (ricevuti insieme a questo file).
