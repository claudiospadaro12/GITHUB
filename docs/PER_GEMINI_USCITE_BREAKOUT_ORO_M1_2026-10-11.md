# PER GEMINI -- Breakout di canale su oro M1, uscite ad asse: due domande chiuse sui nostri numeri (pendenza del trailing; 27 tranche) -- 11/10/2026

Scritto da Claude per Gemini, secondo `docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md` (ricevuto insieme a questo file) e la BASE di conoscenza che ricevi in testa. Il pacchetto si legge da solo e contiene solo cio' che serve alle due domande della sez. 3; il resto sta nelle letture nel nostro repo.
**Perche' esiste**: regola di casa dell'11/10 (uno ZIP di misura letto genera un pacchetto con al massimo 3 domande falsificabili, una per chiamata). Qui ce ne sono due, entrambe su dati nostri. Niente numeri, impostazioni, conti o importi di terzi in questo documento.
Etichette nostre: **[MISURATO]** rifatto da noi su file del repo; **[DERIVATO]** conto su numeri misurati; **[INFERITO]** ragionamento nostro; **[NON MISURATO]** il numero non esiste.
Fonti: file del repo (branch `lavoro`) al commit di oggi. Alias: **lettura R2U** = lettura dell'11/10 della corsa «uscita ad asse»; **file prova** = il file del lotto, con attese, ipotesi alternativa e smentite scritte PRIMA dei numeri.
**Nota importante**: l'EA e' una **ricostruzione nostra** (da una descrizione a voce e da foto di un pannello di terzi): i numeri dicono cosa fa *quella ricostruzione* sul feed del nostro broker, non cosa fa l'EA di altri.

**Cosa chiediamo, e come rispondere (ruoli del protocollo)**: **Q2** al ruolo **B** (avvocato del diavolo), **Q3** al ruolo **C** (auditor, un conto solo). Una domanda per chiamata. Tabella `N | Affermazione | Etichetta (FATTO / CALCOLO / IPOTESI / NON LO SO) | Fonte (sezione del PACCHETTO, oppure "mia conoscenza di mercato, non verificata") | Verificabile da noi come | Costo`. Ogni affermazione senza fonte e' IPOTESI. "NON LO SO" e' una risposta valida e preferita a un numero inventato. (La numerazione Q2/Q3 resta quella dei nostri file; la Q1 di questo giro e' rimandata a un altro pacchetto.)

---

## 1. Il motore e le condizioni di misura
- **Motore** [descrizione = ipotesi di ricostruzione]: breakout di un canale di N barre M1 a favore di una EMA, ingresso a mercato alla chiusura oltre il canale (long e short). Uscita: stop iniziale e trailing a multipli di ATR, breakeven armato a un multiplo di ATR, uscita a tempo. Una posizione per volta.
- **Condizioni** [MISURATO]: oro, M1, tick reali, costi del feed del broker, lotto fisso. **Un solo periodo: gennaio-settembre 2026**, in tre tranche fisse: T1 luglio-settembre / T2 aprile-giugno / T3 gennaio-marzo.

## 2. I numeri  [MISURATO; lettura R2U]
PF netto di costi (PF_V) sulla somma delle 3 tranche; PF per tranche dal report del tester. Ogni cella cambia UNA leva d'uscita rispetto alla partenza (REPL).
| cella | cosa cambia | n | PF_V | PF T1 / T2 / T3 |
|---|---|---:|---:|---|
| REPL | valori di partenza | 933 | 0,855 | 0,83 / 0,77 / 0,89 |
| BEOFF | breakeven mai armato | 882 | 0,843 | 0,78 / 0,74 / 0,89 |
| BE05 | breakeven molto vicino | 1.074 | 0,778 | 0,63 / 0,71 / 0,82 |
| BE15 | breakeven piu' lontano | 898 | 0,846 | 0,81 / 0,74 / 0,89 |
| ATRFIX | ATR del trailing fisso al segnale | 926 | 0,886 | 0,72 / 0,81 / 0,94 |
| TOFF | uscita a tempo spenta | 932 | 0,849 | 0,83 / 0,77 / 0,88 |
| K15 | trailing piu' stretto | 1.131 | 0,848 | 0,89 / 0,91 / 0,83 |
| K35 | trailing piu' largo | 873 | 0,911 | 0,96 / 0,82 / 0,94 |
| KOFF | trailing spento | 859 | 0,900 | 0,98 / 0,67 / 0,97 |

- **Rumore** [MISURATO, bootstrap per giorno, 5.000 ricampionamenti]: la REPL fa PF_V 0,855 con intervallo 2,5-97,5% = **0,70-1,03**. Nessuna delle 9 celle supera 1,03.
- **27 tranche su 27 hanno PF < 1** (massimo 0,98, KOFF T1).
- **Distanza del trailing: il contrasto scritto PRIMA dei numeri** [MISURATO contro il file prova del lotto]: lungo l'asse 1,5 / 2,5 (partenza) / 3,5 / spento il PF_V e' 0,848 / 0,855 / 0,911 / 0,900. Contrasto fissato prima: pendenza = PF_V(spento) - PF_V(1,5) sulla somma. Ipotesi senza continuazione (il prezzo dopo l'ingresso non ha deriva): attesa **+0,035**, deviazione standard prudente 0,12 (somma in quadratura del rumore delle due celle). Ipotesi con continuazione: **+0,105** se la deriva porta il PF vero della partenza a circa 1,0, +0,24 con una deriva piu' forte. Soglia per «continuazione presente»: pendenza > +0,15, stesso segno nelle tranche dove entrambe le celle hanno almeno 150 operazioni, PF_V(spento) > 1,03. **Misurato: +0,052**; tranche giudicabili T2 e T3 (in T1 le due celle hanno 148 e 118 operazioni), pendenza -0,24 e +0,14: segno discorde. Esito scritto prima: nessuna pendenza oltre il rumore.
- **Pendenza appaiata per giorno** [MISURATO da noi sui deal dei report, con uno strumento di analisi non passato dal cancello che ridà esattamente n e PF_V del lettore; un secondo parser indipendente ha dato gli stessi numeri]: le due celle hanno ingressi negli stessi 168 giorni; correlazione dei netti giornalieri 0,63; bootstrap per giorno (5.000 ricampionamenti): **deviazione standard 0,094**, intervallo 2,5-97,5% da -0,12 a +0,24; ricampionando i giorni separatamente per le due celle: 0,146. Quindi +0,035 e +0,105 distano circa 0,75 deviazioni standard.

---

## 3. Le domande (una per chiamata). Per ognuna: dato, nostra attesa, contro-esempio

**Q2 (ruolo B) -- Dove sbaglia la nostra conclusione «sugli stessi dati la pendenza del trailing non separa rumore da continuazione debole»?**
Dato che la motiva: sez. 2: pendenza +0,052, attesa senza continuazione +0,035, con continuazione a PF vero circa 1,0 +0,105; deviazione standard della pendenza appaiata per giorno 0,094 [MISURATO] (0,146 non appaiata): le due ipotesi distano circa 0,75 deviazioni standard. La procedura di confronto era scritta PRIMA dei numeri in un nostro dossier interno sul rischio (in bozza, non passato dal nostro cancello): confronto fra celle appaiato per GIORNO con bootstrap della differenza; una cella e' «meglio della partenza» solo se lo scarto appaiato supera 2 deviazioni standard (2,7 per la famiglia di 12 contrasti), con PF_V > 1,03 e segno concorde in 2 tranche su 3; per la pendenza vale la soglia propria (+0,15, sez. 2). Lo stesso dossier stimava per la pendenza una deviazione standard prudente di 0,12 (somma in quadratura del rumore di ciascuna cella contro la partenza, 0,05-0,09 con un simulatore appaiato per operazione, quindi ottimista): la misura appaiata per giorno ha dato 0,094, sotto la stima prudente per la pendenza e poco sopra quella di una cella sola.
Domanda: costruisci il contro-esempio alla nostra conclusione. In quale situazione concreta il bootstrap per giorno SOVRASTIMA il rumore della pendenza (e quindi puo' nascondere una continuazione vera), e quale numero, nei dati descritti qui, lo mostrerebbe? Vincoli dei dati: (a) le operazioni NON sono le stesse fra le celle (una posizione per volta: l'uscita cambia quali segnali diventano ingressi, n da 859 a 1.131), quindi un confronto appaiato per operazione non esiste; (b) il giorno e' quello server dell'ingresso, e le celle girano sugli stessi 168 giorni: non sono prove indipendenti; (c) la soglia +0,15 non si cambia dopo i numeri: una procedura nuova vale solo per la prova in avanti.
Nostra attesa [INFERITO]: nessuna situazione plausibile porta la deviazione standard vicino a 0,035 (quella che metterebbe le due ipotesi a 2 deviazioni standard); si decide in avanti. Contro-esempio nostro: il vantaggio di trailing largo o spento potrebbe venire da QUALI segnali diventano ingressi (n 873 e 859 contro 933) e non da come si esce. La nostra soglia S9, scritta prima, chiama «selezione» una cella che alza il PF riducendo n A PARITA' di risultato medio per operazione (e lo scrive cosi' oltre il 40% di operazioni tolte): qui n scende del 6-8% e il netto medio per operazione migliora (da circa -58 a -36 e -41 unita' di conto per operazione) [DERIVATO da netto/n], quindi S9 alla lettera NON le classifica selezione e il contro-esempio resta un'ipotesi da misurare.

**Q3 (ruolo C) -- Quanto vale davvero «27 tranche su 27 sotto 1»?**
Dato che la motiva: il «27 su 27» e' la frase della nostra lettura che a prima vista sembra piu' forte di quanto sia.
Domanda (UN conto solo, come chiede la memoria condivisa: la deroga dei tre conti e' revocata): le 27 tranche della sez. 2 sono 9 celle x 3 periodi, e le 9 celle girano sugli STESSI giorni con in gran parte gli stessi segnali. Quante osservazioni indipendenti valgono, circa, e con quale probabilita' «27 tranche su 27 con PF < 1» si vedrebbe se il PF vero fosse 1,0? Scrivi formula, numeri e controllo di verso; rispondi NON LO SO dove manca un dato.
Nostra attesa [INFERITO], senza numero: le 27 tranche valgono fra 3 osservazioni (celle perfettamente legate dentro ogni periodo) e 27 (celle indipendenti), e il valore vero sta in mezzo; in piu' la probabilita' che una tranche stia sotto 1 con PF vero 1,0 non e' necessariamente 0,5 (il profitto sta nella coda destra: in una tranche corta il PF campionario sta sotto il vero piu' spesso che sopra). I due effetti spingono in versi opposti e non sappiamo dove cada la probabilita': e' la domanda. Quello che sappiamo senza questo conto: l'intervallo per giorno della REPL (0,70-1,03) contiene 1,0 (sez. 2). Contro-esempio nostro (la lettura sbagliata da cui ci difendiamo): trattare le 27 tranche come indipendenti e a 0,5 darebbe 0,5^27, circa 7 x 10^-9, una certezza che i dati non danno.

---

## 4. Limiti
1. **Un solo periodo** (gen-set 2026), **3 tranche**: fuori da questo periodo il merito non e' misurato nel tester.
2. Questo pacchetto non e' un verdetto sull'EA: e' una lettura delle uscite. Le altre misure (simboli gemelli, timeframe del segnale sulle 24 ore, uscite che richiedono codice, prova fuori da questo periodo) non sono in questo pacchetto.

## 5. Fonti nel repo (branch `lavoro`, commit di oggi)
Lettura R2U 11/10 -- file prova del lotto sulla distanza del trailing (sez. «LA PENDENZA») -- dossier interno sul rischio del 10/10 (bozza non passata dal cancello) -- strumento di analisi della pendenza appaiata. Memoria, BASE e protocollo: `docs/gemini/MEMORIA_CONDIVISA.md`, `docs/gemini/BASE_CONOSCENZA_PER_GEMINI_2026-10-04.md`, `docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md` (ricevuti insieme a questo file).
