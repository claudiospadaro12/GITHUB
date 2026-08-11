# REFERTO — CODA FASCIA B (notte 10-11/08/2026)

**48 lavori, 6 motori x 8 simboli, eseguiti in autonomia dal PC di backtest
(23:35 → 05:00).** Stadio 1 OHLC = solo screening; stadio 2 tick reali
AUTOMATICO per chi aveva una cella >0 in entrambe le finestre (promozione
meccanica, nessuna scelta di celle). Criteri congelati il 07/08, PRIMA dei
numeri, identici per tutti: (1) positiva in ENTRAMBE le finestre a tick
reali, (2) PF OOS >= 1,10, (3) celle vicine positive (niente picchi
isolati), (4) DD OOS < 10% all'1% (PTE: peggior giornata > -2,5%).

Igiene verificata: tutti i 19 file tick sono freschi di stanotte
(23:49→04:48, date dentro lo zip); celle nei CSV = celle chieste (11 per
i TF-sweep, 16 per la PTE: la cache del tester non e' scattata); trade/mese
IS vs OOS bilanciati sulle celle candidate (il `daquando` ipotesi ha retto
sui simboli promossi). Il token non era sul PC: CSV importati a mano dallo
zip di Claudio, tutti in `risultati_prove/`.

## Il verdetto in una riga

**Quattro capitoli chiusi (Nightly, FiboH4, SupertrendInvert, WOL) e UNA
sorpresa vera: la PTE — bocciata a casa sua sull'oro — passa i criteri su
piu' mercati, col Dow H1 in testa. SuperWave piazza due celle degne su
Dow H2 e GBPUSD H2.**

## Bocciati con referto (capitoli chiusi)

| Motore | Screening | Tick reali | Lettura |
|---|---|---|---|
| **ABTG_Nightly** | 0/8 promossi | — | Nemmeno una cella OHLC positiva in entrambe le finestre su 8 mercati. Il decreto del 10/08 ("si deve guadagnare il posto") ha avuto risposta: NON se l'e' guadagnato. Capitolo chiuso, 9 bocciature totali contando EURUSD. |
| **ABTG_FiboH4_Multi** | 0/8 promossi | — | Zero promozioni su 8 coppie forex+oro H4. Mai piu' senza una tesi nuova. |
| **ABTG_SupertrendInvert** | 1/8 | non opera | Su USDJPY, unico promosso: 0 trade su 10 TF su 11; su M15 fa 2 trade in 14 mesi OOS. Un EA che non piazza ordini non e' un candidato, e' un grafico acceso a vuoto. |
| **ABTG_WOL** | 5/8 | nessuna cella rilevante | I profitti delle celle "verdi" sono spiccioli (es. DAX H3: +1,48 IS / +8,90 OOS; NAS H1: +5,22 OOS): rischio quasi nullo, resa da spread. L'unica cella grossa (SPX H8 +189,78 OOS, PF 8,28) ha IS +22 → non regge il criterio 1 in modo sostanziale. Nessun candidato. |

## La sorpresa: ABTG_PTE (6 promossi su 8, 4 mercati con celle PASS)

Il pattern e' lo stesso del MAXMIN ORO: motore bocciato sul simbolo di casa
(XAUUSD, FASE 0: 16 celle, 0 positive), vivo altrove. Lo sweep era
TF (H1..H4) x grilletto del breakeven `InpTP1_ATRmult` (0/0,5/1/1,5).

| Mercato | Celle PASS | La migliore (per campione) | Note |
|---|---|---|---|
| **U30USD (Dow)** | 7/16 | **H1/BE0: 43 trade OOS, PF 1,32, DD 2,7%, IS +319/OOS +203** | **Il candidato n°1 della notte: la riga H1 e' un ALTOPIANO** (BE 0/0,5/1 tutti PASS, 38-43 trade, PF 1,18-1,33), trade/mese identici IS vs OOS (~3). |
| **GBPUSD** | 2/16 | **H1/BE0: 51 trade OOS, PF 1,45, DD 3,0%, IS +688/OOS +310** | Riga H1 intera positiva in ENTRAMBE le finestre (anche BE 1/1,5, che pero' hanno PF 1,02-1,10). Campione piu' ricco della notte. |
| **USDJPY** | 12/16 | H1/BE0,5: 35 trade OOS, PF 1,29, DD 4,9% | Coerenza impressionante (12 celle su 16). La riga H4 fa PF 5,6-9,9 ma con 17 trade. IS spesso rosso su H1 → meno pulito di Dow/GBPUSD. |
| **D30EUR (DAX)** | 2/16 | H1/BE0: 33 trade OOS, PF 1,34, DD 3,6% | H1/BE0 e BE1,5 PASS ma la riga IS e' mista (BE0,5 e BE1 rossi IS). ⚠️ Le righe H3 (IS rosso, OOS +540/+1350) sono il pattern REGIME di R21: non contarle. |
| NASUSD | 2/16 | H2/BE0: 26 trade OOS, PF 1,37 | Cella piu' isolata (il resto della riga H2 non passa). Sorvegliato, non candidato. |
| 225JPY | 4/16 | H4/BE0,5: 10 trade OOS | H1 disastroso (-914 OOS), celle PASS piccole (9-15 trade). No. |

⚠️ Avvertenza trasversale PTE: le righe H3 mostrano quasi ovunque IS rosso
+ OOS spettacolare (DAX H3/BE1,5: IS -484 → OOS +1.352, PF 7,26). E' il
pattern "regime, non edge" gia' schedato in R21: quelle celle NON si toccano.

## SuperWave (7 promossi su 8, 2 celle degne)

| Mercato | Cella | Numeri | Riserva |
|---|---|---|---|
| **U30USD (Dow)** | **H2** | 61 trade OOS, PF 1,73, DD 5,5%, IS +765/OOS +514 | Vicini: H1 positivo (PF 1,06), H6 PASS — ma H3 rosso OOS (-564). Mezzo altopiano. Nota: la variante _Ottimizzato su DOW H1 e' GIA' in squadra sul piccolo — coerenza di famiglia. |
| **GBPUSD** | **H2** | 63 trade OOS, PF 2,09, DD 2,1%, IS +152/OOS +393 | OOS verde contiguo da H1 a H8, ma IS rosso su H1/H3/H4 → sapore di regime sui vicini. H6 e H8 PASS con 30/15 trade. |
| XAUUSD | H1 | 39 trade OOS, PF 1,22 | H3 PASS (14 trade) ma in mezzo H2 orrenda (OOS -782, DD 10,3%): buco nel mezzo = niente altopiano. Sorvegliato. |
| Altri | — | NASUSD H1 (PF 1,15, vicini rossi), SPX/225JPY/USDJPY celle da 2-5 trade | Niente. |

## Risposta alla domanda di Claudio ("altri 5 EA che passano?")

Non 5 EA: **un motore (PTE) su 3-4 mercati + SuperWave su 1-2**. In sedie
per la squadra e' comunque il raccolto piu' ricco da quando esiste
l'imbuto — e la fascia A aveva dato 0/4. La differenza con la fascia A:
qui i PASS hanno campioni veri (35-63 trade OOS) e righe intere positive,
non celle singole.

## Prossimi passi (ordine proposto, criteri gia' congelati)

1. **R23 — per-trade dei 5 candidati** (magic vergini, celle pinnate):
   PTE Dow H1/BE0 · PTE GBPUSD H1/BE0 · PTE USDJPY H1/BE0,5 ·
   SuperWave Dow H2 · SuperWave GBPUSD H2 → correlazione col portafoglio
   a 6 serie e DD combinato (dd_portafoglio.py).
2. Chi migliora il portafoglio → **VIVAIO** (demo piccolo, 30 trade
   forward), come l'oro. Decisione di Claudio.
3. PTE DAX H1 e PTE NASUSD H2 restano SORVEGLIATI (ripescabili solo con
   una tesi, non coi numeri di stanotte).

_CSV completi in `risultati_prove/<EA>/` (96 OHLC + 38 tick). Stato lavori
in `report/STATO_CODA_WEEKEND.md`._
