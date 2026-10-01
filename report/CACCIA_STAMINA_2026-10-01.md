# CACCIA STAMINA EXPERT ADVISOR — verifica indipendente (2026-10-01)

Richiesta di Claudio: verificare la pubblicita' Facebook di "Stamina Expert Advisor"
(Swiss Corp Srl, autotradingexpertadvisor.com). Non promuovere, non comprare, non
lasciare dati personali. Nessun dato personale lasciato, nessun file scaricato,
nessun acquisto.

## 0. COSA NON SONO RIUSCITO A RAGGIUNGERE (in testa, come da mandato)

Controllo positivo della regola di casa: **FALLITO sulle fonti primarie.** Nessuna pagina
e' stata aperta per intero. Tutte le WebFetch sono state respinte dal proxy di egress
(`EGRESS_BLOCKED`) o dallo strumento:

| fonte | esito |
|---|---|
| autotradingexpertadvisor.com (sito del venditore) | BLOCCATO (WebFetch) |
| amicobot.it (recensione Stamina) | BLOCCATO |
| milanofinanza.it (articolo 2020) | BLOCCATO |
| myfxbook.com (profili) | BLOCCATO |
| fxblue.com (track record) | non raggiunto: nessun URL FX Blue del venditore emerso dalle ricerche, e il dominio non e' stato fetchato |
| ufficiocamerale.it, reportaziende.it, visurissima.it, europages.it, worldplaces.me | BLOCCATI |
| trustpilot.com | BLOCCATO |
| web.archive.org | "unable to fetch" (strumento) |
| Registro Imprese / Camera di Commercio diretto, Consob (pagine ufficiali) | NON TENTATO come fetch diretto (domini ricorrenti bloccati; nessun risultato di ricerca li riguarda) |

**Conseguenza metodologica, da leggere prima dei numeri.** Tutto quello che segue
viene dagli **estratti sintetizzati dal motore di ricerca** (WebSearch), non dal testo
integrale delle pagine. Per la regola di casa non posso scrivere [VERIFICATO] (= letto
sulla pagina). Uso quindi:
- **[SNIPPET]** = riportato dal riassunto di ricerca che cita quella pagina; la pagina NON
  e' stata aperta da me;
- **[INFERITO]** = dedotto da me, con il calcolo;
- **[NON VERIFICATO]** = non trovato / non raggiungibile.
Alcuni riassunti sono rumorosi (uno ha prodotto "win rate 100%" dove altrove c'e' 91%):
dove un numero compare una volta sola lo dico.

## 1. LA RIGA CHE CONTA

Su ~10 pagine/entita' del venditore e di terzi viste solo come snippet, **zero arrivano al
sorgente** (l'EA e' solo MT4, nessun `.mq4` pubblico emerso): **non e' un candidato, non
e' nostra famiglia, e il track record dichiarato non regge il muro prop**. Nessun motore
da riprendere. Verdetto: **NON ANCORA MISURATO / non nostra famiglia** (mai "morto":
nessun PF/n/DD misurato da noi).

## 2. TRACK RECORD — numeri e quale e' quale

Nessun profilo Myfxbook/FX Blue del venditore e' stato raggiunto direttamente; non so
dire se e' conto reale o demo, ne' se il broker e' verificato [NON VERIFICATO]. Il sito
lo dichiara "conto reale" e "certificato da Myfxbook e FX Blue" [SNIPPET, dichiarazione
del venditore, non verificata]. Un solo profilo Myfxbook trovato col nome "Stamina"
(`RVDMarkets1`, "RTG Stamina Strategy") e' di un altro trader, **non collegato**
[SNIPPET, non aperto: non lo attribuisco].

| # | Gain | DD max | Win rate | Giorni | Fonte / chi lo dice | Stato |
|---|---|---|---|---|---|---|
| A | **+142,9%** | **27%** | n/d | **1698** | home autotradingexpertadvisor.com | [SNIPPET], dichiarazione del venditore, NON verificata |
| B | **+141,95%** | **53,76%** | **91%** | **1684** | scheda AmicoBot | [SNIPPET], terza parte (affiliata, vedi §3) |
| C | "+100%" / "win 27%" | n/d | "27%" | n/d | citata da Claudio | **[NON VERIFICATO]**: nessuna fonte trovata; l'unico "100%" apparso e' un artefatto di riassunto sul win rate |
| D | "vicino al 130%" | n/d | n/d | ~1000 (dal 05/02/2019) | pagina "Mille giorni di Stamina" | [SNIPPET], venditore |
| E | "134%" cumulato "uno dei conti piu' longevi" | n/d | ">85% operazioni in profitto" | ">7 anni" | pagina Stamina generale | [SNIPPET], venditore |
| F | +42% senza DD "trascurabile", >92% operazioni positive | "trascurabile" | >92% | n/d | pagina recensioni/Milano Finanza | [SNIPPET], venditore |
| G | +51% in 10 mesi; "15-45% in 3 mesi" a seconda del money management | n/d | n/d | n/d | pagina "+51% in 10 mesi" | [SNIPPET], venditore |

**Datazione dei numeri A e B** [INFERITO]: partenza dichiarata 05/02/2019 (pagina "Mille
giorni"). 1684 giorni = **~16/09/2023**; 1698 giorni = **~30/09/2023**. Quindi A e B sono
due istantanee **di fine settembre 2023** (a 14 giorni di distanza, +141,95% -> +142,9%),
non dello stato di oggi (1 ottobre 2026 = giorno 2795). La pubblicita' di oggi parla di
"7 anni" ma i numeri verificabili piu' recenti che ho trovato hanno **tre anni**.

**Differenza A contro B: stesso conto, DD diverso.** Gain quasi uguale (+142,9 contro
+141,95) ma DD 27% (venditore) contro 53,76% (AmicoBot). AmicoBot scrive (riassunto) che
"il drawdown mostrato su Myfxbook non era veritiero" e che nella scheda ha linkato il
track di **FX Blue** invece di quello Myfxbook. **Non e' chiaro da quale piattaforma
venga il 53,76% e quale il 27%** [INCERTO]. Posso solo dire che esistono due DD per lo
stesso conto e che nessuno dei due passa il muro prop.

**Rendimento implicito** [INFERITO]: 142,9% in ~4,65 anni = ~21% annuo composto.
Rendimento/DD: 142,9/27 = 5,3 (se vale 27%), 141,95/53,76 = 2,6 (se vale 53,76%).
Win rate 91% con DD 27-54% e' la firma classica griglia/averaging (v. §6 SETACCIO).

**Cifre in conflitto sul sito stesso** [INFERITO]: a ~1000 giorni "vicino al 130%"; a 1684
giorni +141,95% sul conto citato; a "7 anni" **134%** su un "conto longevo". Se e' lo
stesso conto, sarebbe **sceso** da +142% a +134% nei tre anni dopo; se sono conti diversi,
la pubblicita' sceglie quello che le conviene. Non distinguibile senza aprire i profili
[NON VERIFICATO].

## 3. DICHIARATO CONTRO VERIFICABILE; TESTO AMICOBOT

Testo esatto della recensione: **NON raggiunto** (amicobot.it bloccato). Cio' che ho dal
riassunto di ricerca, e che e' parafrasi non citazione:
- gain 141,95%, DD max 53,76% ("il piu' alto tra i bot di questa selezione"), win rate
  91%, 1684 giorni;
- "dopo un'attenta analisi del drawdown, e' stato verificato che il drawdown mostrato su
  myfxbook non era veritiero", per cui hanno linkato FX Blue;
- commento: un DD del 53% "richiede nervi saldi e un capitale che ci si puo' permettere
  di vedere temporaneamente dimezzato".
**Affiliazione:** AmicoBot dichiara "possibili link di affiliazione" con commissione senza
costi aggiuntivi [SNIPPET]: **recensione NON indipendente al 100%** (ma il suo 53,76% e'
sfavorevole al venditore, quindi e' un dato contro l'interesse affiliato, non una
promozione).

Discrepanze elencate (tutte [SNIPPET]/[INFERITO]):
1. DD 27% sul sito, 53,76% su AmicoBot.
2. Il sito dice "mai bruciato un conto" in 7 anni; il DD dello stesso conto citato
   arriva al 54% in un'altra lettura.
3. Dichiara certificazione "Myfxbook e FX Blue"; AmicoBot dice che il numero Myfxbook
   non e' attendibile.
4. Prezzo: 570 EUR (snippet Google di Claudio) contro Lifetime 799 EUR e 6 mesi 299 EUR
   (pagine prodotto del sito) [SNIPPET]: quale sia attuale e' [INCERTO].
5. Anno: "fondata nel 2019" (sito) contro costituzione societa' 02/01/2020 (§4).

## 4. LA SOCIETA'

[SNIPPET] da ufficiocamerale.it, reportaziende.it, europages, visurissima (nessuno aperto):

| campo | valore | stato |
|---|---|---|
| Denominazione | SWISS CORP S.R.L. (listata come "unipersonale" e "semplificata") | [SNIPPET] |
| P.IVA | 02329600569 | [SNIPPET] |
| Sede | Via Tirreno 39, 01016 Tarquinia (VT) | [SNIPPET] |
| REA | 170523 (Camera di Commercio Rieti-Viterbo) | [SNIPPET] |
| Costituzione | **02/01/2020** | [SNIPPET] |
| Attivita' | programmazione informatica (consulenza informatica) | [SNIPPET] |
| Capitale | 10.000 EUR (2026) | [SNIPPET] |
| Fatturato | 130.058 EUR (2024) | [SNIPPET] |
| Dipendenti | 1 (2026) | [SNIPPET] |
| PEC | swisscorp@pec.it | [SNIPPET] |
| Legame con Stamina | pagina "Contatti" del sito riporta Swiss Corp srl unipersonale, Via Tirreno 39 Tarquinia, P.IVA 02329600569 | [SNIPPET], non aperta |

Lettura:
- La societa' **esiste** nei registri aggregati (non ho fatto visura ufficiale, quindi
  [NON VERIFICATO] sul Registro Imprese primario). Sede in provincia di Viterbo, non
  "Svizzera" malgrado il nome.
- **Discrepanza data** [INFERITO]: EA "attivo dal 05/02/2019" e societa' "fondata nel
  2019", ma costituzione al **02/01/2020**: il track record parte ~11 mesi **prima** che
  esista l'entita' giuridica. Puo' essere il fondatore a titolo personale prima della
  srl: possibile, non dimostrato, e il track record non e' quindi "della societa'".
- Fatturato 130k e 1 dipendente: non e' per se' un difetto, ma e' incongruente con
  "azienda italiana con team di programmatori e analisti" [INFERITO, valutazione mia].
- Segnalazioni: **nessuna** trovata in Consob, Trustpilot, Forex Factory, MQL5, Reddit,
  forum italiani, Telegram su "Stamina Expert Advisor"/"Swiss Corp Srl" (le ricerche
  hanno restituito altri soggetti: SwissInv24, Swiss Capital Management ecc., che NON
  sono questo venditore). **Assenza di segnalazioni non e' prova di pulizia**: cercato
  solo via motore di ricerca, nessuna pagina primaria Consob/Trustpilot aperta
  [NON VERIFICATO].
- Recensioni indipendenti: **zero trovate** non-affiliate. Quelle "unanimemente positive"
  stanno sul sito del venditore e sulla sua pagina Facebook (da loro stessi definita
  "piu' affidabile delle altre piattaforme"): **non indipendenti**.

## 5. MILANO FINANZA 2020

URL (da risultati di ricerca): `milanofinanza.it/news/stamina-expert-advisor-l-eccellenza-italiana-del-trading-automatico-202009170940327582`.
Data **17/09/2020** [INFERITO dal codice nell'URL, `20200917`]. Pagina NON aperta.
- Dicitura "sponsorizzato/advertorial/comunicato": **[NON VERIFICATO]**, non ho potuto
  leggere il testo della pagina.
- Indizi, non prove: titolo promozionale ("l'eccellenza italiana"), taglio da comunicato,
  e il venditore lo cita sul proprio sito come "recensione di Milano Finanza". Un
  riassunto di ricerca lo ha definito "sponsored review", ma e' un'etichetta del
  riassunto, non una citazione della pagina. **Per Claudio:** aprire la pagina e cercare
  in testa/fondo etichette tipo "Contenuto sponsorizzato"/"Comunicato aziendale"/"Partner
  content". Nota: 2020 = prima delle istantanee 2023 e prima di 6 anni di storia: non
  puo' attestare la tenuta del track record.

## 6. MECCANISMO E COMPATIBILITA' PROP

Dichiarato dal venditore [SNIPPET]:
- "strategia **a griglia multistrategia**", i singoli sistemi derivano dal trend rilevato
  su piu' timeframe; ottimizzata con "algoritmo proprietario" su **10 anni** con parametri
  **per coppia** "aggiornati periodicamente" (parametri ricalibrati sul passato: e' il
  profilo di overfitting che il nostro imbuto esiste per non comprare);
- "doppio sistema di protezione esclusivo" che puo' ridurre/sospendere le operazioni in
  condizioni estreme;
- money management **scelto dall'utente** (lotti, rischio, perdita massima);
- **solo MT4**;
- uso di stop loss/take profit menzionato genericamente.

NON verificabile [NON VERIFICATO]: moltiplicatore dei lotti, passo della griglia, numero
massimo di posizioni, SL per singolo ordine o solo su basket, rischio per ciclo, uso di
recovery. **Nessun sorgente** (prodotto in licenza, MT4 compilato) [INFERITO, non ho visto
file ma nessuna fonte parla di sorgente]: il setaccio §4 non e' applicabile, e per le
regole di casa "non escludo un martingala che non posso leggere".

Compatibilita' prop: nessuna dichiarazione trovata di compatibilita' FTMO/prop
[NON VERIFICATO]. Fonti terze sull'argomento sono in conflitto (una dice che FTMO "vieta
la griglia", un'altra che non la vieta ma e' incompatibile coi limiti): **non la uso come
criterio**; il criterio e' aritmetico:
- muro prop DD totale 10%: il DD dichiarato 27% e' **2,7x** il muro, il 53,76% e'
  **5,4x** [INFERITO];
- muro giornaliero 5%: non misurabile (nessuna serie giornaliera); per una griglia con
  win rate 91% la perdita si concentra in poche sedute [INFERITO, tipologia].

Bandiere rosse di casa (§4 SETACCIO): **griglia/averaging** (dichiarata dal venditore
stesso), **niente sorgente**, **parametri ri-ottimizzati su 10 anni**, win rate 85-92%
con DD 27-54% (**firma di griglia**), **DD diverso a seconda della fonte**, **track
record non della societa'** (precede la costituzione).
Anche il marketing: ebook "Da 2.000 EUR a Mezzo Milione con il Trading Automatico"
[SNIPPET] (promessa non sostenibile), Facebook a pagamento, "Seconda Entrata Automatica".

## 7. SCHEDA DI CASA

```
NOME            Stamina Expert Advisor (anche "Stamina Scalping", "Platinum Advisor" dallo stesso sito)
FONTE / URL     autotradingexpertadvisor.com (non raggiunto), snippet di ricerca
AUTORE / DATA   Swiss Corp Srl, P.IVA 02329600569, costituita 02/01/2020 [SNIPPET]
LICENZA         commerciale, a pagamento, 299 (6 mesi) / 799 (lifetime) / "570" [INCERTO]
RIGHE / INPUT   n/d (nessun sorgente)
TESI IN UNA RIGA  non scrivibile con onesta': "una griglia multi-TF ottimizzata a 10 anni
                  chiude in profitto il 90% dei cicli": e' una proprieta' statistica
                  della griglia, non un meccanismo di mercato; il rischio sta nella coda.
MECCANICA       griglia multistrategia su trend multi-TF, MT4
GESTIONE RISCHIO scelta utente; SL reale o virtuale n/d; max posizioni n/d
BANDIERE ROSSE  griglia (dichiarata), niente sorgente, parametri per coppia ricalibrati
COSTO DI PORTING impossibile (nessun sorgente); MT4 -> MT5 non applicabile
PUNTEGGIO       semplicita' 0 · filtro=motore 0 · tesi 0 · buco portafoglio 0 · testabile 0
VERDETTO        SCARTO (< 5), NON ANCORA MISURATO / non nostra famiglia
PERCHE'         griglia senza sorgente, DD dichiarato 27-54% contro muro 10%.
IN OTTICA PROP  non schierabile: DD 2,7-5,4x il muro, nessuna serie giornaliera, e
                lo schema a gradini con ritorni dal picco e' proprio quello che il DD
                trailing punisce.
```

## 8. CONCLUSIONE PER NOI

- **Meccanismo da riprendere: nessuno.** Griglia multi-TF trend-following con
  "protezione" che sospende in condizioni estreme: nulla che non abbiamo gia' (il
  Guardian fa cio' che ci serve, con tetti firmati). Nessuna tesi di mercato nuova.
- **Numeri trovati**: +142,9%/DD 27%/1698 gg (venditore, ~30/09/2023), +141,95%/DD
  53,76%/win 91%/1684 gg (AmicoBot, ~16/09/2023). Nessuno verificato da me.
- **Archiviazione**: NON ANCORA MISURATO / non nostra famiglia, mai "morto". Cosa manca
  per un certificato di morte: PF, n, DD misurati da noi (impossibile: niente sorgente),
  gestione ad asse, simboli gemelli, TF. **Non c'e' nulla da misurare** perche' manca
  l'oggetto: il caso rientra in `CANCELLO_ACQUISTI_EA.md` solo se Claudio decidesse di
  proporre l'acquisto; io non lo propongo.
- **Per la tranquillita' di Claudio**: nessun segnale di truffa "classica" emerso (societa'
  esistente, partita IVA, sede reale, nessuna segnalazione trovata), ma l'assenza di
  segnalazioni e' limitata dalla rete. Il problema non e' la sparizione dei soldi: e'
  che il prodotto dichiarato (griglia con DD 27-54%) **non e' compatibile con le prop**
  e il marketing ("mezzo milione") promette troppo.

## 9. COSA FARE SE CLAUDIO VUOLE CHIUDERE I BUCHI (a mano, da un PC con rete aperta)

1. Aprire la pagina Milano Finanza e cercare la dicitura sponsorizzato/advertorial.
2. Aprire il profilo FX Blue / Myfxbook linkato dalla pagina "Risultati Live" e annotare:
   periodo, gain, DD massimo, DD relativo, lotti, n trade, demo o reale, broker.
3. Aprire visura camerale (Registro Imprese) per P.IVA 02329600569: data costituzione,
   amministratore, oggetto sociale.
4. Aprire la scheda AmicoBot e copiare il paragrafo esatto sulla discrepanza di DD.

Domanda a cui l'eventuale primo test deve rispondere: non ne esiste, perche' non c'e'
nulla da testare. Se mai si prendesse una licenza demo: **il DD del conto reale e la
massima serie perdente, a rischio fisso, su un anno di tick reali**.

## 10. FONTI (tutte come snippet di ricerca, nessuna pagina aperta)

- https://autotradingexpertadvisor.com/en/ (home, +142,9%/DD 27%/1698 gg)
- https://autotradingexpertadvisor.com/en/software-autotrading-robot-expert-advisor-trading-automatico/
- https://autotradingexpertadvisor.com/en/analizziamo-performance-stamina-expert-advisor/
- https://autotradingexpertadvisor.com/en/mille-giorni-stamina-expert-advisor/
- https://autotradingexpertadvisor.com/en/recensioni-stamina-expert-advisor/
- https://autotradingexpertadvisor.com/en/contatti-autotrading/
- https://autotradingexpertadvisor.com/en/disclaimer/
- https://autotradingexpertadvisor.com/en/stamina-51-10-mesi/
- https://autotradingexpertadvisor.com/en/money-management/
- https://amicobot.it/recensioni-bot/stamina-expert-advisor/
- https://www.milanofinanza.it/news/stamina-expert-advisor-l-eccellenza-italiana-del-trading-automatico-202009170940327582
- https://www.ufficiocamerale.it/3422/swiss-corp-societa-a-responsabilita-limitata-semplificata
- https://www.reportaziende.it/swiss_corp_societa_a_responsabilita_limitata_vt_02329600569
- https://www.europages.it/SWISS-CORP-SRL-UNIPERSONALE/00000005378981-692851001.html
- https://www.visurissima.it/aziende/SWISS-CORP-SOCIETA-A-RESPONSABILITA-LIMITATA-SEMPLIFICATA_02329600569.html
- https://it.trustpilot.com/review/amicobot.it (rating AmicoBot, non Stamina)
