# R277: la regola di Emiliano (candela 5 minuti) sul Nasdaq, lettura (22/10/2026)

Fonte: `ROUND_R277_2026-10-22.zip` (4 file x 16 passate, tick reali, NASUSD M5, deposito 80.000, finestra 2024.09.26-2026.06.30, taglio 0,40, rischio 2%, pin d67cf21e). Archivio `risultati_archivio/R277_20261022`. Lettore congelato `r277_giudizio.py`; divisione per stagione `r277_stagioni.py` (esplorativa, scritta dopo). Non controllata da agenti. Tutte e 4 le gemelle identiche (G1 ok), motore = pin, catena completa, 8 per-trade su 8.

## Risultati (verdetto congelato)
| file | IS: n / PF / DD | OOS: n / PF / DD / profitto |
|---|---|---|
| a PRE, filtro 17-38 ACCESO | 129 / 0,97 / 13,75% | 214 / **1,31** / 17,36% / +22.567 |
| b PRE, filtro SPENTO | 277 / 0,78 / 38,74% | 438 / 0,93 / 34,01% / -10.653 |
| c POST, filtro ACCESO | 50 / 0,71 / 16,98% | 87 / 0,84 / 12,62% / -4.441 |
| d POST, filtro SPENTO | 285 / 0,89 / 32,98% | 432 / 0,80 / 34,31% / -25.600 |
- **Filtro PRE: UTILE** (IS dPF +0,19, OOS +0,38, DD e conteggio entro soglia). **Filtro POST: NON DIMOSTRATO** (troppo pochi affari, 18-20% di quelli senza filtro).
- **Nessun file batte la cella R274a** (PF OOS 1,21546 con DD <= 7,86%): R277a ha PF 1,31 ma **DD 17,36%**.
- Nota: in IS il file a (la regola di Emiliano con filtro) e a **PF 0,97**, cioe in perdita lieve.

## Contro le previsioni
R1 gemelle: CENTRATA. **R2 (PF dei SPENTI fra 0,85 e 1,20): FALLITA** (PRE spento IS 0,78; POST spento OOS 0,80). R3 rapporti: CENTRATA (PRE 0,47/0,49, POST 0,18/0,20). R4 filtro utile in PRE 25%: **avvenuta** (era la meno probabile); POST: non avvenuta come previsto. R5 nessun file batte R274a: CENTRATA.

## Divisione per stagione, solo gamba OOS (ESPLORATIVA)
Il test usa sempre le 14:30 del server (UTC+1 fisso): giusto d'estate USA, **un'ora PRIMA dell'apertura d'inverno** (3/11/2025 - 6/3/2026 nell'OOS).
| file | mesi allineati | mesi invernali (1 ora prima) |
|---|---|---|
| a PRE acceso | 95 posizioni, **+24.284, PF 1,48**, vincenti 73% | 32 posizioni, -1.718, PF 0,92 |
| b PRE spento | 184 posizioni, +10.181, PF 1,11 | 87 posizioni, -20.834, PF 0,66 |
| c POST acceso | 18 posizioni, -7.978, PF 0,43 | 36 posizioni, +3.537, PF 1,24 |
| d POST spento | 184 posizioni, -21.746, PF 0,76 | 87 posizioni, -3.854, PF 0,90 |
Letto con cautela: il PRE acceso nei mesi allineati (**PF 1,48**) batte lo stesso PRE spento (PF 1,11), ma **sono 95 posizioni in un anno**, una sola gamba OOS, soglie 17-38 prese da una frase di Emiliano; la divisione e stata fatta dopo. Nei mesi invernali il test misura la candela delle 8:25-8:30 di New York (prima dell'apertura): **non e la sua regola**.

## Lettura
- La **regola di Emiliano (PRE, candela 5 minuti, filtro 17-38) con l'orologio giusto sembra avere un'edge** nell'ultimo anno, ma con DD alto (17% a rischio 2%) e campione piccolo. **Non e dimostrata** e non batte la nostra R274a sul DD.
- Senza il filtro la stessa regola perde. Il filtro e la parte che conta.
- Non rimanda a nessuna decisione di taglia o acquisto.

## Prossimo passo possibile (non avviato)
Versione **invernale**: stessa regola con apertura 15:30 server (InpSessionHour=15) sulle sole finestre invernali (2024.11.04-2025.03.07 e 2025.11.03-2026.03.06), per misurare la regola dove oggi il test sbaglia ora. Poi la stessa cosa sul Dow.
