# Forward demo di ABTG_Nasdaq_Apertura_US_Sicuro v1.03: lista dei file da caricare e passi (23/10/2026)

**Non controllata da agenti. Non provata su un terminale.** L'EA e stato compilato dal tester del PC di backtest (R282: motore = pin) ma mai attaccato a un grafico. Nessuna taglia: il rischio e quello del preset 770260 (1,0%), lo decidi tu.

## Cosa caricare (2 file)
| file | dove | pin / SHA256 |
|---|---|---|
| `mql5/Experts/ABTG_Nasdaq_Apertura_US_Sicuro.mq5` | `MQL5\Experts\` del terminale demo, poi compilare (F7, 0 errori) | commit `304dfa41`, SHA256 `735B0044...737D` (quello provato in R282) |
| `mql5/Presets/ABTG_Nasdaq_Apertura_US_Sicuro_770291_DEMO.set` | caricato dagli Input dell'EA (Carica) | questo commit |
`ABTG_PausaGuardian.mqh` deve gia stare in `MQL5\Include` (c'e per le altre sedie). Il set ha 101 righe e i nomi coincidono con gli input dell'EA (controllo fatto qui).

## Differenze dal preset della sedia 770260 (dichiarate nel file)
Magic **770291**; `InpSkipUSHolidays=true`; `InpAutoUSDST=true` (orari impostati 14:30 / flat 17:30 = ora legale USA, dal 02/11 l'EA li porta a 15:30 / 18:30); `InpMaxMinLotRiskX=0` (tetto spento: in R282 non serve). Tutto il resto identico a 770260, rischio compreso (1,0%).

## Dove metterlo (decisione tua)
- **Non sullo stesso conto dove gira l'EA originale sul NASUSD** (stesso segnale due volte = rischio doppio, successo con Apertura_Marco il 06/08/2026).
- Candidati dai documenti: demo 100k `50504263` (terminale `-V3`, ha il Guardian 779001) oppure il piccolo `50503392` sul VPS. Il manuale `50503635` no (ci operi tu a mano sul Nasdaq). **Non sul reale 10105439 e non su FTMO** (il fuso e un altro: serve un file diverso).
- Un solo EA su NASUSD in quel conto: controlla che non ci siano altre sedie Nasdaq attaccate.

## Passi
1. Copia l'`.mq5` in `MQL5\Experts`, compila con F7: deve dire 0 errori (se ne da uno, mandami la foto: e il punto che il tester non ha potuto escludere su questa macchina).
2. Apri un grafico **NASUSD M5**, attacca l'EA, Input -> Carica il `.set`, controlla a vista: `InpMagic=770291`, `InpAutoUSDST=true`, `InpSkipUSHolidays=true`, `InpRiskPercent=1.0`, `InpUsaGuardian=true`. Algo Trading acceso.
3. Nel giornale degli Esperti deve comparire la riga di avvio `[Nasdaq Apertura US] avviato su NASUSD...` con la config.

## Date da guardare
- **Lun 26/10**: prima seduta normale (apertura 14:30 server).
- **Lun 02/11**: prima seduta con ora solare USA: ordini attesi alle **15:30** server, flat alle 18:30 (se alle 14:30 piazza ordini, `InpAutoUSDST` non sta funzionando).
- **Gio 26/11** (Thanksgiving), **Ven 25/12**, **Ven 01/01**: nel giornale deve comparire "festivo USA (NYSE chiusa): oggi non opero." e nessun ordine.

## Cosa mi mandi dopo 2-3 settimane
Giornale degli Esperti del terminale e lo storico del conto (o `ABTG_Trades.csv` dell'exporter): lo leggo contro i criteri che scrivo prima. Il forward serve a vedere cio che il tester non prova: ordine rifiutato senza riprova, riavvii con posizione aperta, armo tardivo.
