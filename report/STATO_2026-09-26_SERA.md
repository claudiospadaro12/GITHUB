# 🧭 STATO DELLA SERA — 26/09/2026 (per riprendere in una chat nuova)

_Claudio: "ENTRO DOMANI SERA DOBBIAMO AVERE + SEDIE. DOMANI SERA RIAPRE IL MERCATO. FAI TUTTO
TU IN BACKGROUND." Tutto cio' che segue e' su `lavoro`. Niente e' in campo di nuovo. Conto reale
10105439 non coinvolto. I round girano SOLO sul PC di backtest `DESKTOP-H4D7CAJ`._

## 1. Cosa aspetta CLAUDIO (in ordine)
1. 🔴 **Risposta 1 o 2 sulla sedia 770212 (Dow SHORT su FTMO 541452707 al 2%)**: pacchetto con PASS
   (`5e344047`), preset `mql5/Presets/FTMO/ABTG_Dow_Apertura_US_770212_SHORT_FTMO.set`, riga
   `righe/RIGA_PRESET_SHORT_DOW_FTMO.txt`, verbale `report/FIRME_2026-09-26.md`. La riga NON parte
   finche' non conferma con R54a davanti (short solo: OOS PF 0,840 n 73, DD ~17,5% al 2%).
   Strada 1 = prima R255; strada 2 = attaccare subito su grafico US30.cash M5 NUOVO.
2. **Riga R255** (consegnata, `righe/RIGA_R255_SHORT_DOW_INFASE.txt` @ `0fdb1a9c`, PASS): PC di
   backtest, MT5 chiuso, 35-50 min, zip `ROUND_R255_<data>.zip` da mandare.
3. **Riga A** (`righe/RIGA_ROUND_CORTI_A_R250_R258_R259.txt`, in scrittura -> cancello): R250 770201
   in fase + R258 Londra + R259 Nightly, ~1,5 h.
4. **Riga B** (`righe/RIGA_ROUND_CORTI_B_R260_R263.txt`, in scrittura -> cancello): R260 oro per lato +
   R261 DAX long + R262/R263 breakout 770201, ~1 h.
5. Zip vecchi ancora aperti: **R254** (TrailFix), **R252**, CSV scalper.

## 2. Round pronti (tutti PASS al cancello, nessuno girato)
| Round | Cosa | Commit PASS | Costo |
|---|---|---|---|
| R255 | Dow SHORT in fase, 24 file, magic 7931xx | `9f3df205` (riga `0fdb1a9c`) | 35-50 min |
| R258 | Londra ORB GBPUSD/EURUSD ore 7/8/9, 24 file, magic 7958xx | `0b1d2dcc` | 25-45 min |
| R259 | Nightly sei simboli mai misurati, magic 787261-66 | `d765860a` | ~29 min |
| R260 | ORO 770402 per lato (c ancora R103, a long, b short), magic 7953xx | `f0e6f66e` | 3-6 min |
| R261 | DAX LONG di 770411 (d riproduce short, c ancora R244b, a corr, b TF), 7954xx | `f0e6f66e` | 4-9 min |
| R262/R263 | 770201 breakout: asse fino a 320; DD MISURATO a 2%; asse rischio, 7663xx/7664xx | `82b846a4` | ~48 min |
| R250 | 770201 in fase (scritto 24/09, mai girato) | gia' PASS | ~ |
| R264/R265 | EMA200 H4 su 4 simboli + EURUSD short, 7965xx/7985xx | `98c0b703`, **al cancello** | 25-80 min |

## 3. I numeri che decidono, gia' misurati
- **770212 Dow short**: R54a IS PF 1,511 / OOS **0,840** (n 73). 770260 Nasdaq FTMO e' a DUE lati
  (AllowLong/Short true, filtro volumi ON): due short al 2% possono coincidere.
- **770201 breakout**: R245 altopiano 160-260 aperto; R247 DD chiuso 6,38/5,94% a 1%; R248 finestra
  vergine DD **8,38%** > p95 -> REVISIONE; estate PF 0,982 (199) / inverno 1,800 (152). A 2%: attesa
  0/24 celle sotto il muro; muro fra 1,25 e 1,50%. Bozza preset
  `mql5/Presets/FTMO/BOZZA_ABTG_Nasdaq_Apertura_US_770201_BREAKOUT_DOW_FTMO.set` (magic 770231,
  taglia 1,00 = firma).
- **ORO 770402**: R103 due lati PF 1,308 n 693 DD 5,32% a 0,5% -> 19,6-21,3% al 2%; R19b long solo 39
  posizioni PF 1,831. Preset FTMO gia' a due lati. EA NON su C:\FTMO.
- **DAX long MaxMin**: 0/33 celle distinte sopra PF 1; correlazione mai accesa sul long -> NON ANCORA
  MISURATO. `report/STATO_MAXMIN_DAX_LONG_E_ORO_2026-09-26.md` (PASS `8ba88483`).
- **Londra**: mai misurata (R45 era un altro EA). Costo: canale >= 61,2 pip GBPUSD per 40x con
  commissione. `caccia_strategie/ANALISI_PDF_LONDRA_2026-09-26.md`.
- **Nightly**: morta solo su EURUSD/GBPUSD/USDCHF (+EURCHF rischio); sei simboli a zero per filtri
  (nome JPY/AUD; QB pip-vs-punti). `report/NIGHTLY_SEI_SIMBOLI_2026-09-26.md`.
- **Cap C1 4,00% = due posizioni al 2%**: piu' sedie al 2% non aggiungono portata (firma di taglia).

## 4. In corsa (agenti)
Cancello R264/R265 · riga A · riga B · caccia settaggi web
(`caccia_strategie/CACCIA_PARAMETRI_SEI_FAMIGLIE_2026-09-26.md`) · caccia meccanismi web
(`caccia_strategie/CACCIA_MECCANISMI_SEI_FAMIGLIE_2026-09-26.md`).

## 5. Checklist: classi 833-843 aggiunte oggi (prossima libera: grep prima).
