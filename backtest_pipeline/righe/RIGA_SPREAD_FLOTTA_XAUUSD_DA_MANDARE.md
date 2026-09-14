# 🥇 SPREAD ORARIO — XAUUSD @ BCM — DA MANDARE (prerequisito Part2, 14/09/2026)

**Che cos'è.** La STESSA misura già fatta per NASUSD/U30USD/D30EUR
(`RIGA_SPREAD_FLOTTA_DA_MANDARE.md`, 03/09), ORA ESTESA all'oro. **ZERO codice
nuovo**: `RIGA_SPREAD_FLOTTA.ps1` (motore `ABTG_SpreadOrario.mq5` v2) è già
**multi-simbolo generico** — `InpSimboli` è una lista separata da virgole, senza
nessun simbolo vietato — e il PIN già verificato `e1c81430c…` funziona così
com'è: **cambia solo l'argomento `-Simboli`.**

**Perché esiste.** `backtest_pipeline/prove/R148a_cycle_verso_NASUSD.txt`
(sezione "BUCHI DICHIARATI") e `report/ORO_1530_CANCELLO_COSTO_2026-09-10.md`
par. 8-9 dichiarano l'oro **RINVIATO**: il cancello del costo (stop ≥ 40× lo
spread mediano) su XAUUSD si può solo STIMARE con due letture isolate
(0,16 $ del 17/08, 0,22 $ del 27/08), **mai misurare ora per ora**. Questa riga
chiude UNA delle due sonde mancanti (l'altra è la profondità tick, vedi il
foglio gemello `RIGA_MISURA_TICK_XAUUSD_DA_MANDARE.md`).

**Non tocca il forward. Non promuove niente. Non ottimizza niente. Non committa.**

---

## 🛑🛑🛑 SI LANCIA **SOLO SUL PC DI BACKTEST — MAI SUL VPS** 🛑🛑🛑

> Identico al foglio NASUSD/U30USD/D30EUR: la riga **apre e chiude MT5 da sola**
> (`AllowLiveTrading=false`). Dalla riparazione del 12/09 il bersaglio è il
> **banco `C:\MT5_Backtest`** (demo **50504400**, zero EA attaccati) e la
> chiusura finale è **chirurgica** (muore solo il processo sotto quella
> cartella) — letto riga per riga in `RIGA_SPREAD_FLOTTA.ps1` F4/F6 il 14/09.
> **Con MT5 e MetaEditor CHIUSI prima di lanciare.**

---

## ⚠️ ORDINE CONSIGLIATO: DOPO la sonda tick, non prima

La finestra qui sotto (`-Da 2024.09.26 -A 2026.06.30`) è la **STESSA** usata per
i tre indici, presa come IPOTESI DI PARTENZA (non una misura): è la finestra in
cui BCM ha CONFERMATO i tick veri per NASUSD/U30USD/D30EUR, ma **per l'oro
questo non è ancora verificato**. Se `RIGA_MISURA_TICK_XAUUSD_DA_MANDARE.md`
(da lanciare PRIMA) trova che i tick veri di XAUUSD partono da un'altra data,
questa riga va rilanciata con `-Da`/`-A` corretti — altrimenti lo spread
mediano incluirebbe ore misurate su tick "plausibili ma falsi" generati dalle
barre, e il numero mentirebbe. **Se si lancia comunque questa PRIMA (es. per
guadagnare tempo mentre l'altra sonda gira), il referto va letto come
PROVVISORIO fino alla conferma della finestra.**

---

## ▶️ LA CORSA (blocco intero, un comando solo)

Riusa il **PIN GIÀ VERIFICATO** del 03/09 (`e1c81430c…`, driver v3 + motore v2):
**nessun nuovo commit serve per questa sonda**, perché il motore è già
multi-simbolo generico e non ha nessun simbolo vietato. Cambia **solo**
`-Simboli` rispetto al blocco NASUSD/U30USD/D30EUR.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia (questa riga apre MT5 da sola).' };
    $pin='e1c81430c8ba1b4f835cbeb7927f400d54501da1'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SPREAD_FLOTTA.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SPREAD_FLOTTA.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SPREAD_FLOTTA_v3' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Simboli 'XAUUSD'; $rc=$LASTEXITCODE;
    $r=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SPREAD_FLOTTA_*\RIGA_REFERTO_SPREAD_FLOTTA.txt') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($r.Count -eq 0){ throw 'NESSUN REFERTO DI RIGA DI ADESSO sul Desktop: la corsa non e'' arrivata alla raccolta -- copiami il rosso qui sopra.' };
    $z=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SPREAD_FLOTTA_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO, non il numero.' -ForegroundColor Yellow };
    if($ko){ Write-Host 'MISURA NON COMPLETA (2 = PARZIALE e RIPRENDIBILE, 1 = fermata prima): mandala lo stesso, il parziale non si butta.' -ForegroundColor Yellow };
    if($z.Count -gt 0){ Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan } else { Write-Host ('ZIP NON FATTO: mandami questa cartella -> ' + $r[0].DirectoryName) -ForegroundColor Yellow } }
```

> Un solo simbolo: molto più rapido delle corse a 3 (nessun picco di RAM da tre
> basi tick insieme). Ordine di grandezza atteso: minuti, non ore — ma la fase
> tick può restare ferma per un po', è NORMALE (stesso difetto pagato e già
> gestito dal driver v3).

---

## 📤 Cosa arriva sul Desktop

- Cartella `SPREAD_FLOTTA_<data>` con **`spread_orario_XAUUSD.csv`** (24 righe
  orarie + riga `TUTTO`; colonne: `ora_server, tick_totali, tick_ask_usabili,
  tick_solo_bid, media_idx, mediana_idx, p95_idx, max_idx, overflow_tick`) +
  `REFERTO_SPREAD_FLOTTA.txt` + `RIGA_REFERTO_SPREAD_FLOTTA.txt`.
- Zip `SPREAD_FLOTTA_<data>.zip` pronto da mandare.

## 🔎 COME SI LEGGE (specifico per l'oro, oltre alla lettura di casa)

1. 🚦 **BID/ASK, come sempre**: se `% SOLO-BID ≥ 5%` la corsa a `Spread=0` è
   OTTIMISTA — si impone `Spread = P95` misurato.
2. ⚠️ **`media_idx`/`mediana_idx`/`p95_idx` sono in "punti indice x 100 MT5
   points", MA per XAUUSD questa unità VALE IN DOLLARI**, non in "punti
   indice": `InpPuntiPerIndice=100.0` (default) converte correttamente perché
   XAUUSD ha lo stesso rapporto Digits/Point delle tre indici (1 $ = 100 punti
   MT5, confermato in `report/ORO_CONTRO_INDICI_COSTO_2026-09-10.md` r.56:
   "XAUUSD sta sulla stessa scala: 1 punto = 1,00 USD per lotto") — ma
   l'etichetta di colonna resta scritta "punti indice" per un simbolo che non
   è un indice. **Non è un bug numerico, è un'etichetta da leggere a mente
   corretta**: chi legge il CSV deve sapere che qui "punti indice" = "$".
3. 🕐 **Sessione**: a differenza dei tre indici (un solo orario di cassa a
   testa), l'oro NON ha un'unica sessione di cassa — è quotato H24. La
   tabella oraria completa è proprio il punto: **serve a rispondere alla
   domanda di Claudio su QUALE sessione conviene** (Asia/Londra/NY), non solo
   a confermare un orario già scelto. Vedi la MATRICE DEGLI ASSI in
   `R148g_cycle_minimo_locale_verso_NASUSD.txt`, riga "filtro orario oro".
4. 💰 **Cancello del costo**: una volta in mano lo spread mediano per ora,
   applicare la STESSA tabella di R148a (stop = InpKStop × ATR(TF), rapporto
   ≥ 40× di lavoro / ≥ 13,3× duro) ORA PER ORA, non solo sulla mediana
   giornaliera — è esattamente il numero che oggi manca e che sblocca il
   verdetto (non solo lo screening) su XAUUSD, su qualunque TF risulti valido.
