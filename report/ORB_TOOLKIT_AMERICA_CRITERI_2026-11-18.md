# ORB apertura americana (Toolkit ABTG 05, webinar 02/03/2026): criteri e previsioni scritti PRIMA dei numeri (18/11/2026)
Natura: simulatore Python su M1 NASUSD esterno (2015-2024, ora di New York), nessun ordine, nessun giudizio su lotti/taglie. Fonte delle regole: `002_ABTG_-_ToolKit_05_-_ORB_-_Apertura_America.pdf` (esempio sull'S&P 500; qui Nasdaq perche e il dato che abbiamo). Il test del 18/11 sui moduli lezioni (M3, range 15/30 minuti con conferma) non aveva il filtro EMA ne la regola esatta dello stop.

## Regola del Toolkit (come scritta)
- **Range:** 15:30-16:00 ora italiana (= 09:30-10:00 NY), **30 minuti, con ombre**. Nessuna operazione nella mezz'ora.
- **Filtro EMA 9/21 su M5:** long solo se EMA9 > EMA21 e prezzo sopra entrambe; short solo se EMA9 < EMA21 e prezzo sotto entrambe; altrimenti nessuna operazione. "Non operare MAI contro le medie."
- **Ingresso:** una candela M5 **CHIUDE** oltre il massimo (long) o il minimo (short) del range, con **corpo ampio** nella direzione; ingresso alla chiusura. Se il segnale e contro il filtro: ignorato.
- **Stop:** 5-10 punti oltre il lato OPPOSTO del range. Mai spostato. **Target:** R/R minimo 1:1,5, ideale 1:2, **oppure** uscita alla chiusura di una M5 dall'altra parte della EMA21.
- Rischio 1-2%; nessuna operazione con dati ad alto impatto.
## Scelte mie (il PDF non le dice; fissate ora, dichiarate come INTERPRETAZIONI)
Una operazione al giorno; ingresso possibile fino alle 11:30 NY (candele M5 che chiudono dalle 10:05 alle 11:30); ingresso al prezzo di apertura del minuto successivo alla chiusura; corpo ampio = corpo >= 50% del range della candela e candela nella direzione; uscita forzata alle 16:00 NY; SL e TP intrabarra su M1 (SL prima se nella stessa barra); **costo 2,0 punti per operazione**, risultati in punti netti; **non** inclusa l'esclusione per notizie (non ho un calendario storico: limite dichiarato). Giorni con R < 8 punti scartati.
## Griglia (24 set, contatore looks 24)
filtro EMA {acceso; spento} x corpo ampio {si; no} x buffer SL {5; 10 punti} x uscita {R/R 1,5; R/R 2; EMA21} .
## Porte (nessuna ritoccata)
- **Selezione 2015-2017:** netto > 0, PF netto >= 1,20, t >= 2,0, operazioni >= 100, >= 2 anni su 3 in profitto; max 3 candidati (t piu alto).
- **Validazione 2018-2020** (stesse porte). **Finalisti:** OOS 2021-22 e 2023-24 (PF >= 1,20, profitto > 0, >= 20 op), poi vicini e conferma su BCM. **2025-26 non si apre.** Domanda secondaria (descrittiva): il filtro EMA migliora il PF aggregato rispetto allo stesso set senza filtro?
## Previsioni (scritte ora)
- >= 1 set passa la selezione: **25%**; candidato passa la validazione: **8%**; finalista passa OOS: **3%**.
- Il filtro EMA acceso ha PF aggregato (su 12 coppie di set) piu alto di quello spento: **60%**.

## Risultato (18/11/2026; usato SOLO 2015-2017 per la selezione; output in `ORB_TOOLKIT_AMERICA_RISULTATI.txt`)
- **Selezione: 0 set su 24 passano.** Tutti in perdita netta, PF netto 0,74-0,83 (625-661 operazioni), **t tra -1,75 e -2,76**: la perdita e sistematica, non rumore. Il filtro EMA 9/21 quasi non filtra (625 contro 636 operazioni): i breakout con corpo ampio sono quasi sempre gia allineati alle medie. Filtro EMA acceso migliore dello spento in 8 coppie su 12 (previsione 60%: confermata, ma la differenza e piccola). Validazione e OOS non toccati. **Famiglia chiusa.** Previsioni: >= 1 set passa (25%) -> NO; candidato passa validazione (8%) -> NO.
- **Solo descrittivo, senza ripescare nulla** (regola del Toolkit alla lettera: filtro acceso, corpo ampio, buffer 10, R/R 2): 2015-17 PF 0,83 (lordo 1,01); 2018-20 PF 0,82 (lordo 0,88); **2021-24 PF 1,16 (t +1,66), ma quasi tutto nel 2022 (+4.545 su +5.576)**. Nessun vantaggio fino al 2020; il 2021-24 e dominato da un solo anno di tendenza: non e un candidato. Costo 2,0 punti inclusi; esclusione per notizie non applicata (limite).

## ESTENSIONE A TUTTI I SIMBOLI (richiesta di Claudio 18/11: "provalo con tutti i simboli") — criteri scritti prima dei numeri
- **Una sola regola fissa, nessuna scelta di parametri per simbolo** (non e una caccia al migliore): regola del Toolkit alla lettera = filtro EMA 9/21 acceso, corpo ampio (>= 50%), stop con buffer dal lato opposto, **due varianti di uscita pre-fissate: R/R 2 e uscita EMA21**. Buffer = 0,20% del prezzo (equivale ai 10 punti sul Nasdaq a ~5000) e R minimo = 0,16% del prezzo (come gli 8 punti): scalati sul prezzo per poter usare la stessa regola su simboli diversi.
- **Simboli disponibili ora:** Nasdaq (gia fatto: nessun vantaggio), **oro XAUUSD e EURUSD (FTMO, ora server = ora italiana + 1: range 16:30-17:00 server = 15:30-16:00 IT, ingressi fino alle 18:30 server, uscita forzata alle 23:00)**, 2015-2020 (2018-2020 e 2015-2017 separati). Costi: oro 0,66 USD/oncia a operazione; EURUSD 0,00010. **Non disponibili ancora: S&P 500 (l'esempio del Toolkit), DAX, Dow, altri forex.** Il 2025-26 non si apre.
- **Porte, per ogni simbolo e variante:** in ENTRAMBI i periodi (2015-17 e 2018-20): netto > 0, PF netto >= 1,20, t >= 2,0, operazioni >= 100, >= 2 anni su 3 in profitto. Contatore looks: 2 simboli x 2 varianti = 4.
- **Previsioni:** almeno un simbolo+variante supera le porte in entrambi i periodi: **8%**; l'oro e l'EURUSD hanno PF netto < 1 in entrambi i periodi: **75%**; quanto sopra e quanto troviamo sul Nasdaq indicano che l'ORB 30' non ha vantaggio generale: **80%**.
- **Limiti:** l'ORB del Toolkit e disegnato per indici; su oro e forex e un'estensione esplorativa. Orologio FTMO assunto come da CLAUDE.md (non diagnosticato sul picco di apertura).

### Risultato dell'estensione (18/11/2026; FTMO 2015-2017 e 2018-2020; `ORB_TOOLKIT_MULTI_RISULTATI.txt`)
| Simbolo, uscita | 2015-17: n / PF / t | 2018-20: n / PF / t | Esito |
|---|---|---|---|
| XAUUSD, R/R 2 | 579 / 0,60 / -4,63 | 632 / 0,77 / -2,26 | NO |
| XAUUSD, EMA21 | 579 / 0,48 / -6,09 | 632 / 0,66 / -3,37 | NO |
| EURUSD, R/R 2 | 673 / 0,77 / -2,62 | 695 / 0,95 / -0,43 | NO |
| EURUSD, EMA21 | 673 / 0,71 / -3,22 | 695 / 0,73 / -3,07 | NO |
**Nasdaq (gia fatto): 0/24, PF 0,74-0,83, t fino a -2,76.** In totale 3 simboli su 3 in perdita sistematica (t negativi fino a -6): **l'ORB a 30 minuti del Toolkit, con le regole scritte, non ha vantaggio su Nasdaq, oro ed EURUSD (2015-2020)**. Previsioni: almeno un simbolo passa (8%) -> NO; oro ed EURUSD PF < 1 in entrambi i periodi (75%) -> si (unica eccezione parziale EURUSD R/R 2 nel 2018-20: PF 0,95, t -0,43); ORB 30' senza vantaggio generale (80%) -> si. **Non si prova l'inversione (fade) come scoperta**: sarebbe una famiglia nuova con costi. Mancano S&P 500 (esempio del Toolkit), DAX, Dow e gli altri forex (dati da procurare).

### S&P 500 (arrivato 18/11; dati continui, orologio NY verificato: picco 09:30; `ORB_TOOLKIT_SPX_RISULTATI.txt`)
| Uscita | 2015-17: n / PF / t | 2018-20: n / PF / t | 2021-24: n / PF / t | Esito |
|---|---|---|---|---|
| R/R 2 | 620 / 0,65 / -4,17 | 667 / 0,89 / -1,14 | 817 / 1,00 / -0,03 | NO |
| EMA21 | 620 / 0,60 / -4,77 | 667 / 0,79 / -2,03 | 817 / 0,82 / -1,96 | NO |
**4 simboli su 4 (Nasdaq, S&P 500, oro, EURUSD) in perdita con la regola del Toolkit alla lettera: l'ORB a 30 minuti non ha vantaggio.** Costo 0,04% del prezzo, buffer 0,2%; esclusione notizie non applicata.
