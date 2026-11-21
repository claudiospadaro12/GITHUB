# Copertura FTMO per GoldenZoe su piu' mercati (passo 0, misurata 21/11/2026)
Fonte: `EXPORT_M1_FTMO_20261121_094337.zip` (21 simboli, finestra 09-16/11/2026, nomi tutti trovati, 0 errori) + specifiche `SWAPINFO_20261119/FTMO_PROVA_ABTG_SWAPINFO.csv`. **`primo_dato_server` = primo M1 disponibile sul server FTMO (D1 e H4 si costruiscono da li').** Spread = media di UNA settimana (indicativo, non stabile nel tempo), come % del prezzo medio della settimana. Orario = barre M1 tipiche (ora server FTMO = ora italiana + 1).
| Simbolo | Primo dato M1 | Anni | Spread medio (punti / % prezzo) | Orario tipico | Swap long (specifica) | Giudizio per il test |
|---|---|---|---|---|---|---|
| XAUUSD (gia' noto) | 2004-06 | 22 | - | 01:05-23:49 | - | testabile |
| XAGUSD | 2008-11 | 18 | 41,6 / 0,081% | 01:05-23:49 | -12,4 punti | testabile |
| BTCUSD | 2011-03 | 15 | 100 / 0,0014% | 00:05-23:54 (7 giorni) | -30 (interesse % annuo: **cifra da verificare**) | testabile |
| ETHUSD | 2016-05 | 10 | 60 / 0,030% | 7 giorni | -30 (idem, da verificare) | testabile |
| UKOIL.cash | 2016-04 | 10,6 | 71 / 0,074% | 03:05-23:49 | +50,8 punti | testabile |
| JP225.cash | 2017-12 | 8,9 | 1030 / 0,017% | 01:05-23:49 | -901 punti | testabile (Nikkei: il candidato) |
| US100.cash | 2017-12 | 8,9 | 174 / 0,0062% | 01:05-23:49 | -393 punti | testabile |
| US500.cash | 2017-12 | 8,9 | 60 / 0,0080% | 01:05-23:49 | -138 punti | testabile |
| GER40.cash | 2017-12 | 8,9 | 215 / 0,0081% | 01:05-23:49 | -507 punti | testabile |
| UK100.cash | 2017-12 | 8,9 | 230 / 0,021% | 01:05-23:49 | -267 punti | testabile |
| EU50.cash / FRA40.cash | 2017-12 | 8,9 | 133 / 0,021% ; 161 / 0,019% | 09:05-22:54 (sessione) | -121 ; -161 punti | testabili, orario corto |
| US2000.cash | 2018-01 | 8,8 | 96 / 0,034% | 01:05-23:49 | -52 punti | testabile |
| HK50.cash | 2018-12 | 7,9 | 714 / 0,030% | 03:20-20:59 | -469 punti | testabile, sessione corta |
| US30.cash | 2019-02 | 7,8 | 239 / 0,0046% | 01:05-23:49 | **+265 punti** (controllare) | testabile (Dow) |
| AUS200.cash | 2019-02 | 7,8 | 101 / 0,011% | 00:55-22:54 | -248 punti | testabile |
| USOIL.cash | 2020-12 | 5,9 | 78 / 0,089% | 01:05-23:49 | +12,5 punti | marginale (meno di 6 anni) |
| XPDUSD / XPTUSD | 2015-01 | 11,9 | **802 / 0,78% ; 650 / 0,42%** | 01:05-23:49 | -42 ; -47 punti | **esclusi: spread troppo alto per il trend** |
| XCUUSD (rame) | 2024-12 | 1,9 | 59 / 0,095% | 01:05-22:59 | -18,6 punti | non testabile (storico corto) |
| NATGAS.cash | 2024-10 | 2,1 | 60 / **1,94%** | 01:05-23:49 | -17 punti | non testabile (storico corto, spread alto) |
| DXY.cash | 2024-11 | 2,0 | 18 / 0,018% | 03:05-23:49 | -25,5 punti | non testabile (storico corto) |
## Cosa implica
- **Indici su FTMO: solo 8-9 anni (7,8 per Dow e Australia).** Il trend D1 produce ~3-6 operazioni all'anno per mercato: su 8-9 anni sono 25-50 operazioni totali, **troppo poche per il cancello IS n >= 30 + OOS + hold-out del piano** (IS ~6 anni = 20-30 operazioni). Per gli indici lo screening va fatto sul D1 lungo di Yahoo (1970-2026, con costi e swap modellati) e il tester FTMO serve solo a confermare i sopravvissuti (hold-out 2025-26).
- **Oro, argento, Bitcoin hanno storico lungo** su FTMO (18-22, 15 anni): li' il tester FTMO regge.
- **Costi:** indici 0,005-0,034% di spread a trade (trascurabile per un trend D1); metalli minori e gas fuori dal conto per spread. **Swap:** in punti per gli indici (conversione in % annuo da fare: la stima precedente FTMO indici era 5-10% annuo); **Bitcoin/Ethereum -30 con modo "interesse % annuo del prezzo": va verificato in demo/tester prima di usarlo** (cfr. la cifra mal letta sugli indici BCM).
- **Non misurato qui:** commissioni (CFD cash FTMO: da specifiche ufficiali o demo), orari festivi, spread in apertura/chiusura.
