# 🔦 LE DUE MISURE LAMPO DEL CANCELLO _EXT — foglio di lancio (26/08/2026)

**Macchina: PC DI BACKTEST (DESKTOP-H4D7CAJ). Non sul VPS.**
**Durata attesa: BLOCCO 1 ~1 minuto · BLOCCO 2 ~3-6 minuti.**
**MT5 può restare aperto** (qui non si scrive un byte in `MetaQuotes\Terminal`),
ma **se sta girando un backtest conviene aspettare**: la misura della
volatilità carica ~1,7 GB di RAM e il driver si ferma da solo se ne trova
meno di 2 GB liberi.

---

## 📌 IL PIN DI QUESTA RIGA

```
@@PIN@@
```

---

## 🎯 COSA MISURA, E PERCHÉ ADESSO

`ANALISI_CANCELLO_ZERO_EXT_2026-08-25.md` (§5b) dice che per decidere se il
cancello qualità degli indici `_EXT` va tenuto **assoluto** (0,05% fisso) o
riscritto **relativo** (0,20 × range orario) mancano **due misure mai
eseguite**. Sono queste, e stasera si fanno tutte e due in una corsa sola:

| # | misura | cosa produce | come si legge |
|---|---|---|---|
| 1 | `--vol-oraria` su `nsxusd,jpxjpy,spxusd` + `eurusd` | il **range H1 medio vero**, per anno e totale | sostituisce le bande **[INFERITO]** del §3 dell'analisi e ricalcola la colonna "rapporto diff/vol" |
| 2 | `--estrai` su **tre** eventi | le **barre M1 una per una** intorno alla diff massima, con i buchi | dice se l'evento è un **buco di feed**, un **movimento vero** o una **sessione storta** |

I tre eventi (l'ora nel referto d'import è **ora server**, il CSV HistData è
in **ora New York**: la conversione la fa il driver, evento per evento, e la
scrive nel referto):

| evento | ora SERVER | ora NY (quella del file) | perché |
|---|---|---|---|
| A | `2026.03.23 11:00` | `06:00` (+5) / `07:00` (+4) | diff max **simultanea sui tre indici** (72.856 / 1.964 / 18.615 pt) |
| B | `2025.11.20 16:00` | `11:00` (+5) | diff max di **NASUSD_EXT**: 60.221,8 pt, la stessa nei **due** import (18/08 e 25/08 a 17 anni) |
| C | `2026.01.09 14:00` | `09:00` (+5) | diff max di **225JPY_EXT** (1.526,5 pt) — e cade **fuori** dalle finestre DST, in un mese in cui **nessuno** dei due calendari è in ora legale |

🎯 **A cosa serve il terzo (è la domanda in più, e vale doppio).** A cade
**dentro** una finestra DST sfasata, C cade **fuori** e a gennaio. Se anche C è
malato, **il DST non è la causa** (o non è l'unica) e la pista giusta è quella
delle **sessioni del feed** — la stessa malattia che ha bocciato `GRXEUR`, cioè
la **decisione D-F sulla strada del DAX**. Se invece C è sano, il sospetto torna
tutto sul calendario.

> ⚠️ **Questa corsa NON firma niente.** Il cancello resta **0,05%** e i tre
> `_EXT` restano **in frigo** finché Claudio non firma un altro metro. Qui si
> producono solo i numeri per decidere.

---

## ▶️ BLOCCO 1 — GIRO A VUOTO (~1 minuto): **dove sono i dati?**

Non misura niente: scarica lo strumento al pin, fa l'autotest e **apre ogni
file** per dire, simbolo per simbolo, se stasera è misurabile o no. Incolla il
**blocco INTERO** (è un comando solo).

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_MISURE_LAMPO.ps1"; Remove-Item $p -Force -EA SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_MISURE_LAMPO.ps1" -OutFile $p -EA Stop; if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_MISURE_LAMPO_v1' -Quiet)){ throw 'SCRIPT VECCHIO O SBAGLIATO: non lancio niente' }; $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo; $rc=$LASTEXITCODE; if($rc -eq 2){ throw 'NON PARTITA (uscita 2): leggi il rosso qui sopra, rimedia e rilancia questo stesso blocco' }; $dsk=[Environment]::GetFolderPath('Desktop'); $c=@(Get-ChildItem (Join-Path $dsk 'MISURE_LAMPO_*\CENSIMENTO_FONTI.txt') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 }); if($c.Count -eq 0){ throw 'NESSUN CENSIMENTO DI ADESSO: la corsa non ha scritto niente' }; Write-Host ('CENSIMENTO: ' + $c[0].FullName) -ForegroundColor Cyan; if($rc -ne 0){ Write-Host 'QUALCHE FONTE NON E'' MISURABILE: mandami il CENSIMENTO_FONTI.txt qui sopra PRIMA del blocco 2.' -ForegroundColor Yellow } else { Write-Host 'TUTTE E QUATTRO LE FONTI CI SONO: lancia il BLOCCO 2.' -ForegroundColor Green } }
```

**Cosa deve uscire (la riga da guardare):**

```
[hh:mm:ss] NASUSD  MISURABILE   CSV Formato1 in C:\Users\Master\histdata_m1
[hh:mm:ss] 225JPY  MISURABILE   CSV Formato1 in C:\Users\Master\histdata_m1
[hh:mm:ss] SPXUSD  MISURABILE   CSV Formato1 in C:\Users\Master\histdata_m1
[hh:mm:ss] EURUSD  MISURABILE   N ZIP in C:\Users\Master\abtg_storico_esterno\zip
Simboli misurabili: 4 su 4
```

- Se esce **`NON MISURABILE STASERA`** su qualcuno: **è già una risposta**, non
  un guasto. Manda `CENSIMENTO_FONTI.txt` (il percorso te lo stampa in ciano) e
  si decide se quel simbolo si misura stasera o no.
- 🟡 **EURUSD è il caso delicato, ed è previsto:** in
  `abtg_storico_esterno` c'è un `EURUSD_M1.csv`, ma è nel **formato HistData
  grezzo** (`AAAAMMGG HHMMSS;o;h;l;c;v`) che `histdata_m1.py` **non sa
  leggere** — lo scarterebbe riga per riga e direbbe *"manca EURUSD_M1.csv"*
  mentre il file è lì. Il driver lo sa: prende gli **ZIP** nella sottocartella
  `zip\`. Se gli ZIP non ci sono, EURUSD esce **NON MISURABILE** e lo dice.

---

## ▶️ BLOCCO 2 — LA CORSA VERA (~3-6 minuti)

Da lanciare **dopo** aver guardato l'esito del blocco 1.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_MISURE_LAMPO.ps1"; Remove-Item $p -Force -EA SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_MISURE_LAMPO.ps1" -OutFile $p -EA Stop; if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_MISURE_LAMPO_v1' -Quiet)){ throw 'SCRIPT VECCHIO O SBAGLIATO: non lancio niente' }; $global:LASTEXITCODE=0; & $p -Pin $pin; $rc=$LASTEXITCODE; if($rc -eq 2){ throw 'NON PARTITA (uscita 2): leggi il rosso qui sopra, rimedia e rilancia questo stesso blocco' }; $dsk=[Environment]::GetFolderPath('Desktop'); $z=@(Get-ChildItem (Join-Path $dsk 'MISURE_LAMPO_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 }); if($z.Count -eq 0){ throw 'NESSUNO ZIP DI ADESSO: la corsa non e'' arrivata alla raccolta' }; if($rc -ne 0){ Write-Host 'ESITO PARZIALE: qualcosa non e'' stato misurato -- E'' GIA'' UNA RISPOSTA, lo zip va mandato LO STESSO.' -ForegroundColor Yellow }; Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan }
```

### 📨 Cosa mandare, e quale data guardare

Manda **il file che ti stampa l'ultima riga in ciano**:
`Desktop\MISURE_LAMPO_<data>_<ora>.zip`.

> 🗓️ **PRIMA DI MANDARLO, APRI `REFERTO_MISURE_LAMPO.txt` E GUARDA LA QUARTA
> RIGA:** dice `data: AAAA-MM-GG HH:MM:SS   <-- QUESTA DATA DEVE ESSERE DI
> ADESSO`. **Se quella data non è di adesso, stai mandando un referto vecchio**
> (è già successo due volte, il 17/08).

> ⚠️ Sul Desktop può esserci anche un vecchio `histdata_m1.zip`: **non è
> quello.** Il driver lo cancella da solo, e se non ci riesce te lo scrive in
> giallo.

**Dentro lo zip devono esserci** (l'elenco te lo stampa anche il driver, e lo
confronta lui con quello che ha davvero raccolto — se manca qualcosa lo dice
in rosso):

| file | cosa c'è dentro |
|---|---|
| `REFERTO_MISURE_LAMPO.txt` | la tabella dei rapporti diff/vol, le fonti, la lettura degli eventi, NOTE e PROBLEMI |
| `CENSIMENTO_FONTI.txt` | ogni file aperto, con dimensione, data, prima e ultima barra |
| `vol_nsxusd-jpxjpy-spxusd.txt` | la volatilità oraria dei tre indici, anno per anno |
| `vol_eurusd.txt` | la volatilità oraria del controllo positivo forex |
| `estrai_A_20260323_*.txt` | le barre M1 intorno all'evento del 23/03 |
| `estrai_B_20251120_*.txt` | le barre M1 intorno all'evento del 20/11 |
| `estrai_C_20260109_*.txt` | le barre M1 intorno all'evento del 09/01 |
| `log\*.log` | l'uscita cruda di ogni chiamata a python (autotest compreso) |

### 🔢 Le tre uscite possibili

| uscita | significa | cosa fare |
|---|---|---|
| **0** | tutto misurato | manda lo zip |
| **1** | qualcosa non misurato (fonte assente, finestra vuota, zip illeggibile) | **manda lo zip lo stesso**: "non misurabile" è già una risposta |
| **2** | non è partita (pin, python, strumento, autotest, RAM) | leggi il rosso, rimedia, rilancia lo stesso blocco |

**Rilanciare è sicuro**: la corsa è idempotente (provata cinque volte di fila,
stesso risultato) e non tocca nessun dato, li legge soltanto.

---

## 📖 COME SI LEGGERÀ IL RISULTATO (scritto PRIMA di vederlo)

**Misura 1 — la tabella dei rapporti.** Il driver la stampa già fatta:

```
SIM      diff atti  vol TOTALE   vol 2025     rap/TOT    rap/2025   metro 0,20 x vol
NASUSD   0.0662%    ...          ...          ...        ...        ...
```

- La colonna che decide per i **tre indici** è **`rap/2025`**: la diff agli atti
  è misurata **solo dove il nativo BCM esiste**, cioè dal 26/09/2024 in poi, e
  il 2025 è l'unico anno intero dentro quel periodo (è il perimetro, e va
  rispettato).
- Per **EURUSD** vale invece `rap/TOT`: lì il nativo copre tutto.
- Se i rapporti degli indici restano **sopra la banda dei forex promossi**
  (0,04-0,23), allora **anche il metro relativo li boccia** e il cancello
  assoluto resta: è la conclusione che l'analisi ha già dichiarato *prima* di
  misurare (§6 punto 3), e questa è la prova.
- `n/d` vuol dire **non misurato**. Mai uno zero.

**Misura 2 — l'anatomia degli eventi.** Tre esiti possibili, dichiarati prima:

1. **buco di feed** → compare un `BUCO nnn min` che copre l'ora, oppure la
   finestra è **vuota**. ⚠️ In questo caso lo strumento scrive *"NESSUNA BARRA:
   manca `<SIM>`_M1.csv"* — **è un messaggio sbagliato del tool**, il file c'è:
   il driver se ne accorge da solo e nel referto scrive la traduzione giusta
   (*"FINESTRA VUOTA → ipotesi 1 confermata"*);
2. **movimento vero** → le barre ci sono tutte e il range dell'ora è del 2-4%
   (l'ordine di grandezza atteso il driver te lo scrive nel referto, riga
   `atteso` di **ogni** evento: ~2,5% il 20/11 su NASUSD, ~3,1% il 23/03,
   ~3,2% il 09/01 su 225JPY — derivati dai referti d'import);
3. **sessione storta** → le barre ci sono ma sono molte meno delle **60
   attese** in quell'ora. ⬅️ **è l'ipotesi in testa per l'evento C**: lì si
   guarda il **conteggio** delle barre per ora, non solo il range.

**Quello che questa corsa NON può dire:** vede **un solo feed** (HistData). Se
le barre esterne sono sane il colpevole può essere il **nativo BCM**, e quello
si guarda solo sui grafici: H1 di `NASUSD`/`225JPY`/`SPXUSD` e dei tre `_EXT`,
barre **10:00-11:00-12:00 ora server** del giorno dell'evento (Ctrl+D). È il
punto 2 del §16.1 del referto HistData, e resta da fare a mano.

---

## 🔧 PER LA SESSIONE (non per Claudio) — assegnare il pin

La pagina esce con un **segnaposto** al posto del commit. Va sostituito nei
**punti d'uso**, mai su tutta la pagina (una `sed` larga riscriverebbe anche
questa spiegazione, e la ricetta morirebbe al secondo giro).

```bash
cd ~/GITHUB && git pull --rebase --autostash
SHA=$(git rev-parse HEAD)
F=backtest_pipeline/righe/RIGA_MISURE_LAMPO_DA_MANDARE.md
TOK='@@PIN'"@@"
sed -i "s|\$pin='$TOK'|\$pin='$SHA'|g; s|^$TOK\$|$SHA|" "$F"
grep -c "\$pin='$SHA'" "$F"    # DEVE dare 2
grep -c "$TOK" "$F"            # DEVE dare 0
```

**Ri-pinnatura** (quando il pin va rifatto: succede più spesso di quanto si
creda). Il pin vecchio si legge **dai punti d'uso** e si sostituisce **solo
lì**: le menzioni in prosa di un pin bruciato sono **storia** e non si toccano.

```bash
NUOVO=<lo sha nuovo, 40 caratteri>
F=backtest_pipeline/righe/RIGA_MISURE_LAMPO_DA_MANDARE.md
VECCHIO=$(grep -oE "\\\$pin='[0-9a-f]{40}'" "$F" | head -1 | grep -oE '[0-9a-f]{40}')
sed -i "s|\$pin='$VECCHIO'|\$pin='$NUOVO'|g; s|^$VECCHIO\$|$NUOVO|" "$F"
grep -c "\$pin='$NUOVO'" "$F"     # DEVE dare 2
grep -c "\$pin='$VECCHIO'" "$F"   # DEVE dare 0
```

⚠️ I due conteggi vanno **tutti e due**: un `sed` che non ha sostituito niente
supera a mani basse il solo "zero segnaposto rimasti".
