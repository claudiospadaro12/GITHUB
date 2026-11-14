# Criteri e previsioni: coppia P3 + P4 contro coppia P1 + P4 (14/11/2026)

**Scritto PRIMA di qualsiasi nuovo numero.** Nessun risultato nuovo in questo file: le previsioni sono derivate dai numeri gia noti (`PROBABILITA_PASSARE_LE_TRE_2026-11-13.md`, `PROBABILITA_FALLIRE_STRESS_2026-11-14.md`, `CONFRONTO_M1_TICK_REALI_CRITERI_2026-11-14.md`, `P1_TEMPI_RICALCOLATI_2026-11-14.md`) con scalatura di primo ordine. Nessun giudizio su lotti, taglie o acquisti: l'analisi e mia, la decisione e di Claudio.

## Domanda
Con due challenge Swing da 80k, la coppia **P3 + P4** (nessun Phantom) e migliore della coppia **P1 + P4** (Phantom nel 2026 con PF 1,7 invece di 2,4-4,7)? "Migliore" = meno rischio di perdere una challenge senza allungare troppo i tempi.

## Cosa si misura (e cosa serve)
| # | Misura | Fonte | Stato |
|---|---|---|---|
| M1 | P3 oro (Goldbot combo_3GOLD + Gold Trade Pro Combo), 2025, tick reali (Modello 4), 80k | **riga nuova da preparare** (nomi esatti dei set: NON VERIFICATI da qui, da controllare nel pacchetto) | da fare |
| M2 | stessa finestra in Modello 1 | tester M1 (D160/griglia oro) | dati non piu in sessione: da ricaricare |
| M3 | P4 oro (Goldbot L0 + Reaper L3) e P1 oro tick 2025 a 160k | riga `RIGA_LANCIA_TICK160_ORO` gia lanciata | risultati non ancora ricevuti |
| M4 | correlazione delle equity giornaliere P3-P4 e P1-P4 | ricostruzione dai dati M1 | dati da ricaricare |
| M5 | fallimento a stress con DD e profitti rapportati ai valori tick misurati | motore `ORO_GRADINI_dati/stress_fail.py` | ripetibile con i dati |

## Previsioni (con intervallo, fissate ora)
1. **Rapporti tick/M1 per P3** (M1 contro M2): rapporto netto 0,83-0,92, rapporto DD 1,02-1,35, PF 0,90-0,94 (come le 4 coppie gia testate). Passa le soglie di Wim (PF >=0,7, DD <=1,5x, operazioni +-10%, win rate +-10 punti) con probabilita alta. Sorpresa possibile: i set Combo hanno DD3, quindi poche operazioni; con pochi trade il campione tick e rumoroso e il rapporto puo uscire dalla fascia.
2. **Tempi P3 con correzione tick (costi centrali, in sequenza):** mediana base 179 giorni -> circa **195-215**. Entro 6/7/9 mesi circa **33-43% / 47-62% / 79-86%**.
3. **Tempi P4 con correzione tick:** mediana 173 -> circa 188-208; entro 6/7/9 mesi circa 40-52% / 62-70% / 85-92%.
4. **Coppia P3+P4:** entrambe entro 7 mesi circa **40-52%**, entro 9 mesi circa **70-82%** (correlazione ipotizzata, non misurata).
5. **Coppia P1+P4 (gia calcolata):** entrambe entro 7 mesi 45-60%, entro 9 mesi 70-88%.
6. **Previsione chiave:** sui tempi le due coppie NON saranno distinguibili (le fasce si sovrappongono). Il vantaggio di P3+P4, se esiste, e solo sul rischio di fallimento.
7. **Fallimento a stress (parte oro, costi centrali):** P3 gia 0% / 11,7% a DD x1,15 / x1,35. Previsione dopo i rapporti misurati: P3 <=5%, P1 5-15%, P4 0-8%. Il rischio di P3 dovrebbe stare sotto quello di P1 ma non e zero.
8. **Correlazione:** P3 e P4 condividono Goldbot e DTP, quindi correlazione equity giornaliera prevista 0,5-0,8; P1+P4 anche in quella fascia. Se supera 0,8 le due challenge sono quasi una sola scommessa.

## Regole di lettura (fissate prima)
- **P3+P4 preferibile a P1+P4 solo se**: rapporto DD di P3 <= 1,20 **e** fallimento a stress di P3 <= meta di quello di P1 **e** entrambe entro 9 mesi >= 70%.
- **Parita** se il fallimento a stress e tra le due coppie differisce meno di 5 punti: contano allora i costi reali FTMO, non il tester.
- **Nessun cambio** basato su un solo anno tick (2025): e un percorso, non una distribuzione.
- Se M1 contro M2 non passa le soglie di Wim per P3, le previsioni 2-4 sono da scartare e restano valide solo le misure M1.
- Se i risultati contraddicono le previsioni lo dico, senza ritoccare le soglie dopo.

## Limiti dichiarati
Stime di primo ordine finche non si ricaricano i dati; un solo anno tick; P3 e P4 stesso oro; nessun spread/slippage FTMO; Guardian non simulato; Daytrade Pro senza flottante; correlazione ipotizzata; i numeri 33-43% ecc. sono interpolazioni rozze della distribuzione base.
