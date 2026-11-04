# Referto fase diagnostica — ORB Paolo (piano v1 sez. 8, passo 2), 04/11/2026
**Nessun P&L letto, nessun segnale V1 contato, nessun trade simulato.** Solo orari, buchi, spread e ampiezza media per minuto. Script in `diagnostica/` (`python3 -I`), risultati in `diag*_2026-11-04.txt`.

## Dati effettivamente disponibili (diverso dal piano)
Il piano v1 assumeva Nasdaq `_EXT` 2010–2026. In questa sessione ci sono **solo 3 blocchi**: 2015 (intero anno), 2020 (intero anno), 2025-01-01 → 2026-07-31. Mancano 2010–2014, 2016–2019, 2021–2024 e agosto-ottobre 2026. (I CSV 2010 della sonda sono vuoti: solo intestazione.)
sha256: NAS 2015 `40d60c63f87616a7a078fb4d951d6ac7b0389a04894c1176aae88325b0731c65`; NAS 2020 `05c4b733787d942af8b32dd46724fdee6859050f7e289295c9c18e60f58f0c8e`; NAS 2025-26 `be419460b13a6b32a47eb9797fd15a6ef2303d3c242040675a6c8be5c0e7236a`.

## Esiti dei controlli
| Controllo | Esito |
|---|---|
| Collaudo mappatura NY→server (5 casi) | passato **come regola di calcolo**, ma la regola **non descrive i dati** (vedi C1) |
| **C1** picco di volume | **NON ESEGUIBILE**: `tickvol` = 1 in tutte le barre di tutti i file. Sostituito (decisione diagnostica, dichiarata) con l'**ampiezza media (high−low) per minuto** all'orario atteso |
| **C1 (esito)** | **L'ipotesi "server GMT+1 fisso" (apertura 15:30 in inverno) è RIFIUTATA per questi file.** In inverno il picco è a **14:30** (rapporto apertura/media finestra ≈ 2,5–3,0 contro ≈ 1,5 a 15:30; argmax entro ±1 min 17–28% contro 0–2%). In estate 14:30 per tutte le ipotesi |
| Convenzione per blocco (giorni di scarto: USA legale, UE solare) | **2015**: apertura a 14:30 anche nello scarto (n=19; rapporto 2,56 contro 0,94 a 13:30) = NY+5h tutto l'anno. **2020 e 2025-26**: **13:30** nello scarto (n=17 e 35; rapporto 2,41 e 2,52 contro 1,30 e 1,34 a 14:30) = **ora di Londra** (UTC inverno UE, UTC+1 estate UE). Segno di conferma: l'ultima barra del venerdì è 20:14 negli scarti e 21:14 altrove |
| **C2** buchi | passato con convenzione per blocco: giorni feriali conformi (≥95% dei 385 minuti apertura→15:55 NY) **249 + 250 + 391 = 890**; esclusi 41, tutti festivi USA/mezze giornate/lutto 09/01/2025 o buchi puntuali (2020-11-30, 2026-03-12). Elenco in `diag7_C2_2026-11-04.txt` |
| **C3** spread | **spread = 0 in ogni barra** → nessuna informazione di costo; restano solo gli scenari in bps |

## Conseguenze
1. **La regola "BCM = GMT+1 fisso" (CLAUDE.md) vale per il feed live e per il DAX D30EUR, NON per lo storico `_EXT` Nasdaq/S&P.** Un backtest dell'apertura USA su questo storico con 15:30 in inverno parte 1 ora dopo l'apertura reale. Il live (15:30 server in inverno) non è toccato da questo risultato. Da verificare: i vecchi backtest delle aperture USA su `_EXT` e l'origine dello storico (`ABTG_ImportEsterno_NASUSD_EXT`); la convenzione cambia tra 2015 e 2020.
2. Il piano v1 va **emendato** (`congelati/EMENDAMENTO_1_piano_v1.md`): orario per blocco, C1 con ampiezza, dati disponibili, effetto sul verdetto.
3. **Potenza**: 890 giorni conformi al massimo = 890 trade massimi. Per l'albero v1 (semi-ampiezza IC ≤ 0,10 R, serve n ≳ 385) V1 deve dare un segnale in ≥ 43% delle sedute. È **molto probabile che l'esito sia INCONCLUSIVO (potenza)** con questi soli 3 blocchi: servono gli anni mancanti (o un criterio diverso, deciso prima di vedere i risultati).
4. Gli anni mancanti vanno passati alla stessa diagnostica **prima** di usarli: la convenzione oraria può cambiare da un blocco all'altro.

Stato controlli: C1 ESEGUITO (con misura sostitutiva, **esito: orari del piano non applicabili**), C2 ESEGUITO (890 giorni), C3 ESEGUITO (nessuno spread), C4/C5/C6 e collaudo albero NON_ESEGUITO.
