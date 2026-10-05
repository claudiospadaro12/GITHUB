# MAIL PER EMILIANO (bozza di Claudio, 05/10/2026)

**A:** Emiliano
**Oggetto:** Un tuo parere sui miei expert: giudizio, classifica e consigli (dossier in PDF allegato)

---

Ciao Emiliano,

ti scrivo perche' mi serve il parere di chi il mercato lo vive ogni giorno. Sto costruendo una **flotta di expert (MQL5), possibilmente scorrelati fra loro**, con l'obiettivo di arrivare a expert profittevoli per le prop firm **oppure** per un conto personale. Ho fatto un sacco di controlli (walk-forward, costi, e dove ho lo storico mercati toro, orso, laterale su piu' anni) e ora voglio sapere da te se il lavoro sta in piedi.

Nel PDF allegato trovi tutto, senza abbellire: per ogni expert il motore, le poche manopole che contano, PF, numero di operazioni e drawdown (in-sample e out-of-sample), le prove per regime dove le ho, i risultati forward su demo dove li ho (pochissimi, campione sottile) e, soprattutto, i **punti deboli**. Ti chiedo di rispondermi, anche a voce o a punti:

1. **Giudizio.** Con questo PF e con questi controlli, ogni expert e' per te **accettabile, buono o ottimo** (oppure non adatto)?
2. **Classifica.** Una classifica dal migliore al peggiore.
3. **Cosa migliorare.** Su che cosa lavoreresti e su **quali parametri** (stop, TP, filtri, orari, gestione dell'uscita...).
4. **Metodologia.** Il modo in cui costruisco gli expert e' **corretto**, oppure dobbiamo valutare **altri scenari, altri contesti, altri parametri**? Il percorso e' quello giusto per ottenere expert piu' profittevoli, o mi sta sfuggendo qualcosa? Che ce lo dica per favore: preferisco una risposta dura a una cortese.
5. **Dati.** Gli anni e il tipo di dati che uso ti sembrano sufficienti? (vedi sotto)

**Una premessa onesta sugli anni, e una domanda.** Noi pensiamo che un expert, per essere attendibile, debba avere uno storico di **almeno circa 10 anni** ed aver attraversato **vari scenari di mercato** (bull, bear, laterale, crolli). **Sei d'accordo, o servono altri criteri (numero di operazioni, anni, regimi)?** Nelle prime pagine del PDF c'e' la tabella di quanti anni sono stati davvero misurati per ogni expert: per molti la risposta e' NO o PARZIALE, e' la ragione per cui ti chiedo il giudizio. In breve: sul forex abbiamo storico lungo (dati del broker dal 1999, ma a barre, non a tick) e sull'oro dal 2004; sul Nasdaq storico esterno dal 2010 usato solo per prove di regime su alcuni motori; sul **Dow e sugli altri indici la validazione a tick reali e' su circa 21 mesi** (il broker ha i dati indici da settembre 2024), quindi **un solo regime (rialzo)**. E' il nostro punto debole e voglio che tu lo sappia prima di giudicarli.

**Un'altra cosa che ti devo dire.** Da circa una settimana ci confrontiamo anche con Gemini, un altro modello AI: lo abbiamo istruito con una memoria condivisa e una base di conoscenza del progetto, per averlo pronto quando c'e' da confrontarsi con Claude. Il test che gli abbiamo fatto: 17/30 prima della base, 27/30 dopo (a libro aperto), 19/20 a libro chiuso, 5 su 5 su un calcolo ripetuto senza base (punteggi valutati da noi). Utile per generare ipotesi, ma sbaglia ancora (fatti inventati, un calcolo sbagliato): le sue risposte per noi sono **dati da verificare, mai criteri**. Per questo il tuo parere da persona vera conta cosi' tanto.

L'ultima pagina del PDF ha una tabella da compilare (giudizio e priorita' di lavoro per ogni expert): se ti e' comodo, usa quella.

Grazie davvero, anche per un parere breve.

Claudio
