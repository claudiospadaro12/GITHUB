# Verifica della risposta di Gemini sull'EA oro del docente -- 10/10/2026

Fonte: `docs/gemini/RISPOSTA_GEMINI_ORO_DOCENTE_2026-10-10.md` (SHA256 d82d5b60...; modello gemini-3.1-flash-lite; pacchetto `docs/PER_GEMINI_ORO_DOCENTE_2026-10-10.md` @ 4365b470, PASS del cancello).
La risposta e' DATI: nessuna frase e' un criterio, nessuna proposta e' stata eseguita. Verifica fatta dalla sessione principale sul riassunto fedele del corrispondente; la lettura per il cancello (controllo-preventivo) segue.

## Cio' che NON ha risposto
Q1 (c'e' uno studio dietro i numeri del docente?), Q2, Q3 (studi pubblici con fonte e numero: nessuna fonte citata, ne' un esplicito "NON LO SO"), Q4, Q6 (meccanismi realmente nuovi) e Q7 non hanno risposta puntuale; Q5 ha solo i tre prodotti e non la parte in prosa. **Quindi: nessuno studio pubblico e' emerso da Gemini; questo NON prova che non esista.**

## Tabella punto per punto
| Punto | Cosa dice Gemini | Verifica | Cosa se ne fa |
|---|---|---|---|
| C1-C3 | (1/3)^7=0,000457; 0,5^7=0,0078; 0,9^7=0,478 | aritmetica corretta; coincide con i conti nostri | niente di nuovo (erano gia' i numeri di Q5 del cancello) |
| C "controllo di verso" | "la probabilita' diminuisce all'aumentare della probabilita' di insuccesso" | formulazione ambigua: P(7 notti su 7 positive)=p^7 cresce con p(successo): vera se "insuccesso" = 1-p | nessuna azione; da rileggere nel cancello |
| B1 | win rate 26 vs 47% spiegabile da chiusure manuali che tagliano le perdite | e' l'ipotesi (3) del pacchetto sez. 4; il 47% del netto manuale e' dichiarato dal docente | ipotesi nostra, non nuova; verifica = export trade del docente (non disponibile) |
| B2 | spread 2-3x inferiore => insiemi di segnali diversi | e' l'ipotesi (1) del pacchetto; il filtro di spread L1/L2/L3 non muove il PF (R1B: 0,83/0,82/0,82) | gia' misurato per il nostro feed; il feed del docente resta [NON MISURATO] |
| B3 | 0,000457 e' "illusione" perche' le notti non sono indipendenti | gia' dichiarato in Q5 (b)(c) | **adottabile come misura**: autocorrelazione fra le notti nel lettore R2NOTTE (non e' un criterio) |
| A1 | uscita a tempo dinamica sulla volatilita' (InpTimeExitBars), attesa PF>1,05 | quasi un parametro gia' in lista; il piano R2 ha l'uscita a tempo spenta; "l'uscita cambia la forma, non il merito" (dossier Risk manager) | non eseguita; non porta attesa in banda ne' "Firma Claudio SI/NO" come chiesto in Q6 |
| A2 | filtro di regime "range giornaliero" via InpMaxTradesPerDay | il tetto di operazioni al giorno e' gia' escluso dal pacchetto (post-hoc, 5 tetti guardati) | non eseguita |
| D1 | "la divergenza e' strutturale (feed/spread/manuale)" etichettata FATTO | il pacchetto sez. 4 dice che nessuna spiegazione e' una conclusione | **etichetta rifiutata: e' IPOTESI**, non FATTO |
| D2 | chiedere al docente l'export dei trade | utile; Claudio ha detto che il docente non risponderebbe subito | in lista, a costo zero, solo se Claudio vuole |
| D3 | PF con spread largo contro stretto: attesa invariato | gia' misurato in R1B (altopiano piatto sotto 1) | duplicato, non una misura nuova |
| E1 | test di deriva lorda prima di tutto; "motore morto a prescindere" se zero | gia' misurato (dossier Risk manager, in bozza: REPL -34 EUR z -0,89, L3 -9,0 z -1,23); "morto" contro il certificato dei 5 punti (mancano uscita, TF, simboli) | duplicato; **la parola "morto" non si accoglie** |
| E2 | ruolo mancante: analista di microstruttura (tick del docente contro i nostri) | richiede i tick del docente, che non abbiamo | nota, nessuna azione |
| E3 | la regola stop >= 40x spread su M1 oro potrebbe essere troppo severa; misurare un pavimento a 20x | **contraddice la frontiera di casa** (40x lavoro, 13,3x duro); allentare un criterio dopo i numeri e' vietato; nessuna fonte per "troppo severa" | **NON accolta**: nessuna firma; si puo' solo MISURARE il costo a 40x/20x come lettura descrittiva dei lotti gia' previsti, senza cambiare il criterio |
| tempo | "12 passate in 10 minuti" | torna con ~48-56 s a passata | nessuna azione |

## Esito
- Nessun criterio cambia. Nessuna firma toccata (lotto, rischio, conti, spese).
- **Cosa Gemini ha dato di utile**: (1) B3, la dipendenza fra le notti, da misurare sul lotto R2NOTTE; (2) E2/D2, la richiesta dei dati del docente come strada piu' diretta, se Claudio vuole chiederglieli; (3) conferma che i nostri conti di Q5 sono giusti.
- **Cosa non ha dato**: nessuno studio, nessuna fonte, nessun meccanismo nuovo con banda e alternativa. Un modello flash-lite ha ricopiato in gran parte le nostre ipotesi: passare al pro sarebbe una spesa (firma di Claudio) e non lo faccio.
