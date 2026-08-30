# CONTRATTO SEDIA — Gated Short NASUSD (magic 770250) — DEPLOY PICCOLO 30/08/2026

> Nuova sedia in forward DEMO, deploy PICCOLO/osservazione (Claudio 30/08).
> Senza questo contratto le regole di uscita (FIRME 18/08) non mordono.

## IDENTITA'
| campo | valore |
|---|---|
| EA | `ABTG_Nasdaq_Apertura_US` (2a istanza, parallela alla 770201 breakout) |
| Simbolo / TF | **NASUSD / M15** |
| Magic | **770250** (verificato VERGINE repo-wide il 30/08) |
| Preset | `mql5/presets/ABTG_GatedShort_NASUSD_770250_LIVE.set` |
| Motore | BREAKDOWN short GATED (EntryMode=0 drive-down, SOLO short, gate EMA 50x200 su H4 ribassista) |
| Taglia | **0.35%** (PICCOLA: ~meta' dello standard 0.65%) |
| Guardian | ON (`InpUsaGuardian=true`) |
| Fuso | 14:30 server BCM (apertura NASUSD), flat 20:45 server |
| **Conto deploy** | **conto PICCOLO ~5k (osservazione), NON i 100K FTMO** (Claudio 30/08) |
| Attivata il | 30/08/2026, preset caricato e verificato a schermo (5 valori firma OK) |

## VALORI PROMESSI (dal backtest, scalati alla taglia 0.35%)
_Fonte: `backtest_pipeline/risultati_archivio/REFERTO_SHORTGATE_2026-08-30.md`_

| metrica | @0.65% (misurato) | @0.35% (promesso, scala lineare col rischio) |
|---|---|---|
| **DD promesso** | 4.54% (tick BCM toro) | **~2.4%** |
| **Peggior giornata** | -0.72% | **~-0.4%** |
| **PF** | 1.097 tick (toro) / 1.84 OHLC (orso) | invariato (indipendente dalla taglia) |
| **Aspettativa/trade** | +18.8 @0.65% tick | ~+10 @0.35% |
| **Frequenza** | 104 trade / 21 mesi | **~5/mese, MENO in mercati calmi** (il gate spara di piu' nell'orso) |

## RISERVE DICHIARATE
- Il verdetto **nell'ORSO e' OHLC** (screening EXT: PF 1.84, edge 2022/2020), NON
  tick: i tick BCM partono dal 2024.09, nessun orso. Il tick conferma solo la
  SOPRAVVIVENZA AI COSTI nel toro (PF 1.097). Per il verdetto orso tick servirebbe
  Dukascopy. Percio' il deploy e' PICCOLO/osservazione, non a taglia piena.
- Campione tick n=104 < 150: merito formalmente sospeso, rischio no.

## REGOLE DI USCITA (FIRME 18/08, applicate a questa sedia)
- **RISCHIO (sempre)**: se il DD forward supera il **~2.4% promesso** -> revisione
  IMMEDIATA della sedia.
- **MERITO (a 20 operazioni)**: se a 20+ trade e' in perdita -> revisione; si
  spegne se colpevole.
- **TAGLIANDO (6 mesi)**: sotto 20 op e in perdita, o frequenza molto sotto ~5/mese
  -> revisione. Porta di rientro: una misura nuova (es. tick Dukascopy orso) che
  le ridia una ragione.

## CAP RISCHIO FLOTTA
Aggiunge **0.35%** di rischio aperto (un SL vivo). Cap di casa **3.25%** (C1):
ampiamente sotto, e la sedia ha raramente una posizione aperta (~5/mese, bassa
frequenza). Nessuno sfondamento.
**Nota conto**: gira sul conto PICCOLO ~5k, SEPARATO dal forward 50503392 e dal
100K FTMO. Il rischio aperto e i DD si misurano sul conto piccolo; NON entra nel
conteggio del cap 3.25% della flotta principale finche' resta su questo conto.

## PERCHE' QUESTA SEDIA (il ruolo nella flotta)
E' il primo mattone "TEMPESTA": scorrelato per costruzione dalla flotta long
(fira su regime H4 ribassista = quando le sedie long soffrono). Coppia con il
drive-following long (che vive nella calma). Deploy piccolo per osservarlo dal
vivo mentre si costruiscono gli altri candidati.
