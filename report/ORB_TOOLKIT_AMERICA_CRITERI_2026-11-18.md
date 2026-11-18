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
