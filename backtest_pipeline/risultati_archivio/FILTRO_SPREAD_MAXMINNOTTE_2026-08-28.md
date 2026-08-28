# 🛡️ FILTRO ANTI-SPREAD LARGO ACCESO SU MaxMinNotte — 28/08/2026

_Richiesta di Claudio dopo la live di Emiliano del 28/08 ("mai operare il DAX
di notte, spread fino a 8 punti"). Il meccanismo esisteva già nel codice,
correttamente collegato in tutte e 4 le varianti (`SpreadOK()` chiamata prima
di ogni ordine), ma era SPENTO (`InpMaxSpread=0`) — non un bug, una
configurazione mai attivata._

## ✅ Cosa è stato acceso (solo configurazione, zero codice nuovo)

| file | valore prima | valore dopo | simbolo |
|---|---:|---:|---|
| `mql5/Presets/sedie_piccolo/sedia_MAXMIN_ORO_770402.set` (🟢 **live**) | 0 | **150** | XAUUSD |
| `mql5/Presets/sedie_piccolo/recupero2/sedia_ABTG_MaxMinNotte_DAX_Short_Ottimizzato_770411.set` | 0 | **500** | D30EUR |
| `mql5/Presets/ABTG_MaxMinNotte_DAX.set` (preset generico) | 0 | **500** | D30EUR |
| `mql5/Presets/ABTG_MaxMinNotte_EURUSD.set` (preset generico) | 0 | **30** | EURUSD |

🔴 **Stato del file DAX non chiaro**: `sedia_ABTG_MaxMinNotte_DAX_Short_Ottimizzato_770411.set` sta nella cartella
`recupero2` (recupero/archivio), non nella cartella principale `sedie_piccolo`
dove sta l'oro — **non è certo che questa sedia sia oggi davvero live sul
VPS**. Verificalo tu prima di ridistribuire: se non è live, il fix è comunque
pronto per quando/se tornerà attiva.

## ⚠️ I NUMERI SONO STIME RAGIONATE, NON MISURE — e va detto chiaro

**Lo spread reale di BCM su D30EUR e su XAUUSD NON È MAI STATO MISURATO in
questo repo** (dichiarato in almeno 4 dossier diversi: `CACCIA_M5M15_FOREX_ORO`,
`CACCIA_SMC_OB_FVG`, `CACCIA_INTRADAY_INDICI`, `R109_INDAGINE_DEAL`). I valori
scelti oggi vengono da riferimenti indiretti già in casa o citati da fonti
esterne, non da una misura nostra:

- **XAUUSD → 150 punti (1,50 USD)**: fra la guardia stretta di un EA esterno
  letto in una caccia (65 punti = 0,65 USD) e il precedente già in uso in casa
  su `LARRY_ORO` (`InpMaxSpreadPts=300` = 3,00 USD). 150 sta a metà.
- **D30EUR → 500 punti MT5 (5 punti indice)**: fra il normale dichiarato
  (~2 punti indice = 200 pt MT5, `METRO_PROP` D4, mai misurato) e il caso
  cattivo citato da Emiliano ("fino a 8 punti" = 800 pt MT5 nella notte).
- **EURUSD → 30 punti**: coerente con un valore già in uso in casa
  (`ABTG_HARSI.set`, `InpMaxSpread=20`), con un margine leggermente più largo.

## 🎯 La cosa giusta da fare, e resta aperta

Esiste già uno strumento pronto e **mai usato da 3 cacce diverse**:
**`RealCost Spread P95 Logger MT5`** (MQL5 Code Base 74148, promosso il
23/08/2026). Misurerebbe media/p50/p95 dello spread reale su ogni simbolo.
**Proposta**: farlo girare su D30EUR e XAUUSD prima del prossimo giro di
tuning, per sostituire queste stime ragionate con numeri veri.

## ➡️ Come si distribuisce

Questo commit cambia solo i file nel repo. **Per farlo valere sul VPS** serve
copiare i `.set` aggiornati nella cartella `MQL5\Presets` del terminale live
(o rilanciare `scarica_ottimizzati.ps1` se i preset vengono scaricati da lì —
verificare la procedura di distribuzione in uso).
