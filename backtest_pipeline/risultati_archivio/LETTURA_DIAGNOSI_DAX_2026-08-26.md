# 🩺 LETTURA — DIAGNOSI DEL DAX HISTDATA (grxeur)

_Corsa di Claudio 26/08 18:28-18:31 (2,6 min), pin `386346d`, modalità
OFFLINE (solo zip in cache, nessun import, nessun _EXT toccato — D-F
rispettata). ESITO driver: PARZIALE, 2 problemi dichiarati, 8 anni su 8
diagnosticati. Artefatti in `DIAGNOSI_DAX_20260826/`. La D-F era firmata
con VALORE=diagnosi_prima: questa corsa È l'azione autorizzata._

## 🎯 IL VERDETTO IN UNA RIGA

**Il file grxeur di HistData NON contiene il DAX dal giugno 2020 al
novembre 2023: contiene UN ALTRO INDICE.** Il resto (2019, 2024-2026) è
pulito quanto il Nasdaq promosso. Ma il buco di 3,5 anni in mezzo — più i
2010-2018 mai visti perché non in cache — chiude la porta HistData per lo
studio lungo sul DAX. **La strada per il DAX è la strada 2 della D-F:
Dukascopy DEUIDXEUR** (decisione a parte, ~25 ore di crawl).

## 🔍 LA PROVA — tre misure indipendenti che dicono la stessa cosa

Nel tratto 2020-06 → 2023-11, TUTTE E TRE insieme:

1. **La sessione cambia**: finestra 02:00-15:00 ora di New York (14 ore,
   DENSE — non buchi: un'altra convenzione), contro 00:00-23:00 di tutti
   gli altri anni. 42 mesi consecutivi, misurati mese per mese.
2. **I prezzi cambiano scala**: 2021 min-max 3.461-4.414, 2022 3.247-4.395
   — il DAX vero in quegli anni stava a 12.400-16.300. Fuori banda:
   2020 41,6% delle barre, 2021 31,5%, **2022 85,3%**.
3. **Le transizioni combaciano col calendario dei mesi**: 2020-01→05
   finestra piena e prezzi DAX (max 13.827), 2020-06 scatta la finestra
   corta e i prezzi bassi; 2023-12 torna tutto normale (min 2023 3.793,
   max 17.003 = anno di transizione con dentro tutti e due i regimi).

**[INFERITO, non misurato]**: quei min-max 2021-2022 (3.461-4.414 /
3.247-4.395) combaciano con l'**EuroStoxx 50** di quegli anni. Il feed
avrebbe scritto l'indice europeo SBAGLIATO dentro il file del DAX. È
un'etichetta plausibile per il colpevole — per il verdetto non serve:
qualunque cosa sia, **non è il DAX**, e questo È misurato.

## ⚖️ IL VERDETTO FORMALE, CORSIA PER CORSIA

| Corsia | Esito |
|---|---|
| 2020-06 → 2023-11 | **MARCIO CONFERMATO** — sporco diffuso (fino a 85% delle barre), non bonificabile per data o per scarto |
| Densità (tutti gli anni) | **SOSPESO** — la soglia 55 boccia anche il controllo positivo nsxusd (min 42,0): sotto-55 è come HistData scrive i minuti senza scambi, non una malattia del DAX. La guardia sul controllo positivo ha fatto esattamente il suo lavoro (checklist 85-bis) |
| Q1 (interi vs spike) | **SOSPESA** — elenco troncato a 40 giorni/anno, 350 giorni fuori elenco (il driver lo dichiara da solo: checklist 85). I TOTALI restano validi |
| 2019, 2024, 2025, 2026 | **Puliti sulle misure fatte**: 0 barre fuori banda, finestra modale, densità 45-48 = identica al Nasdaq promosso (42-48). Certificarli SANO richiederebbe il rilancio con `-SogliaDensita` ~41 (previsto dal driver) |
| 2010-2018 | **NON GUARDATI** (non in cache; il blocco 3 `-EstendiIndietro` esiste, solo su richiesta) |

## ➡️ COSA SIGNIFICA PER LE DECISIONI APERTE

1. **Lo studio anatomia resta a UN simbolo (Nasdaq)**: il DAX HistData
   non può darci lo storico lungo — al meglio 2019 + 2024-2026 con un
   buco di 4 anni in mezzo, e il 2024+ ce l'ha già il nativo BCM.
   **Il rilancio con la soglia di densità NON cambia questa risposta**:
   certificherebbe anni che non bastano comunque. Proposto: non farlo
   stasera; resta nel cassetto se mai servisse il sottoinsieme.
2. **La strada per il DAX lungo è Dukascopy DEUIDXEUR** (strada 2 D-F,
   già prevista): ~25 ore di crawl, da lanciare solo su decisione di
   Claudio, eventualmente sulle sole finestre di regime.
3. **La bocciatura D-F del grxeur diventa DEFINITIVA** (non più "in
   attesa di diagnosi"): proposta di registrarla in
   `STORICO_INDICI_CRITERI.md` come esito D-F, con questa lettura come
   verbale. Nessun import, nessun _EXT: non cambia nulla di operativo.

## 📌 Nota di metodo

I due "problemi" del referto (P8 densità sospesa, P8-Q1 troncamento) sono
le due classi scoperte IERI dal verificatore su questa stessa riga
(checklist 85 e 85-bis): stavolta il driver le ha **dichiarate da solo
invece di concludere sopra**. Il referto dice "MARCIO -- nessun anno sano"
nella riga di sintesi, ma la lettura corsia per corsia qui sopra è quella
che regge: metà del MARCIO è confermato (2020-2023), metà è sospeso
(densità) — e per la decisione che serviva stasera basta la metà confermata.
