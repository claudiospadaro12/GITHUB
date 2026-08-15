# 🛰️ RICOGNIZIONE PEPPERSTONE — 15/08/2026

_Fonte: `broker_esterno.zip` mandato da Claudio il 15/08/2026 alle 14:55.
Tre file: `ABTG_InfoBroker_pepperstone.csv` (2.835 byte),
`ABTG_InfoBroker_H1_pepperstone.csv` (32 byte), `20260815.log` (UTF-16)._

> ## ⚠️ LA COSA DA SAPERE PRIMA DI TUTTO
> **Il referto e' INCOMPLETO: 9 simboli esaminati su 1722.** Lo dice lo
> script stesso nell'ultima riga del log:
> `=== FINITO: 9 simboli esaminati su 1722 ===`
>
> Quindi da questo elenco **NON si puo' concludere niente** su quali indici
> Pepperstone abbia o non abbia. Nei 9 nomi non c'e' nessun indice, ma i 9
> nomi sono lo 0,5% del catalogo.

---

## 1. Chi ha tagliato la scansione: **noi**

Non e' stato il broker e non e' stato MT5. E' stata l'euristica del nostro
driver PowerShell.

| ora (locale PC) | evento |
|---|---|
| 14:53:43,067 | lo script parte su **EURUSD, H1** (primo candidato: il fallback dei nomi non e' servito) |
| 14:53:43,099 → 14:53:45,332 | 8 simboli esaminati in **2,2 secondi** |
| 14:53:45,332 → **14:54:54,841** | **69,5 secondi di silenzio** su `AUDCHF`, che risulta `NESSUN DATO` |
| 14:54:54,842 → 14:54:55,755 | sezioni `[SESSIONI]`, export H1, riga di chiusura |

**Durata totale della corsa: 72,7 secondi.**

`prepara_broker_esterno.ps1` sorvegliava la crescita del CSV e trattava
**60 secondi di silenzio come "ha finito"**. La pausa su AUDCHF ne e' durata
**69,5**: la soglia e' scattata a meta' scansione, il driver ha chiamato
`Chiudi-MT5-Pulito`, `IsStopped()` e' diventato vero dentro lo script MQL5 e
il ciclo `for(int i=0; i<tot && !IsStopped(); i++)` e' uscito con onore,
scrivendo per bene i 9 simboli che aveva.

> 💡 **La lezione**: il silenzio non e' un segnale di fine. Un simbolo senza
> dati costa fino a **70 secondi** da solo, e 1722 simboli a quel ritmo
> sarebbero **giorni**. La scansione completa non e' lenta: e' impraticabile.

### Cosa e' stato corretto (commit di oggi)

1. **Il segnale di fine adesso e' esplicito**: il driver aspetta la riga
   `=== FINITO` che lo script MQL5 stampa da solo. Il silenzio resta solo
   come rete di sicurezza, e la soglia sale da **60 s a 300 s**.
2. **Nuovo interruttore `-SoloMarketWatch`**: scandisce i **120** del Market
   Watch invece dei 1722 del broker.
3. **Il referto adesso si autodenuncia**: se i simboli elencati sono meno di
   quelli del broker, stampa in rosso `REFERTO INCOMPLETO: N su 1722` — il
   15/08 quel numero c'era gia' nel CSV e nessuno lo guardava.
4. Se il nome del grafico cambia (fallback), cambia anche `InpSimboloFuso`:
   prima il preset sarebbe rimasto puntato a un simbolo inesistente.

---

## 2. ✅ Quello che invece e' MISURATO e vale

### 2.1 Il terminale

| campo | valore |
|---|---|
| Broker | Pepperstone Limited |
| Server | **PepperstoneUK-Demo** |
| Conto | **62128200** — DEMO |
| Valuta | **EUR** |
| Simboli sul broker | **1722** (in Market Watch: **120**) |
| Mercato aperto | **NO** (sabato; ultimo tick 08:01:22 server) |

### 2.2 🕐 IL FUSO — questo e' il risultato buono

```
OraServer  : 2026.08.15 12:53:43
OraGMT     : 2026.08.15 12:53:43
OFFSET     : +00:00
OraLocalePC: 2026.08.15 14:53:43   (Italia, ora legale = UTC+2)
```

**[VERIFICATO] PepperstoneUK-Demo e' a UTC+0.** Non e' dedotto: e' la
differenza fra `TimeTradeServer()` e `TimeGMT()` letta sul terminale.

**[INFERITO] Pepperstone e' 1 ora INDIETRO rispetto a BCM, oggi.** Per la
regola di progetto BCM = ora italiana − 1 = **UTC+1** in questo periodo.
Quindi, **oggi**:

| evento | ora server BCM | ora server Pepperstone |
|---|---|---|
| apertura DAX | 08:00 | **07:00** |
| apertura USA | 14:30 | **13:30** |
| box notturno | 23:00–04:59 | **22:00–03:59** |

> 🚨 **Marcato [INFERITO] e non [VERIFICATO] per un motivo preciso**: in
> questa corsa il lato BCM **non e' stato misurato**. La regola "ora italiana
> − 1" e' scritta nel `CLAUDE.md` e non e' mai stata verificata d'inverno. Il
> ricognitore va lanciato **anche su BCM** (`-BrokerPattern "BCM"`), e finche'
> non lo si fa questi orari **non si mettono in nessun `.ini`**.

### 2.3 ⛔ Il fuso NEL PASSATO: non misurato

`ABTG_InfoBroker_H1_pepperstone.csv` contiene **la sola intestazione**:

```
Finestra,Simbolo,DataOra,Close
```

Zero barre. Le due finestre (gen 2025 solare, lug 2025 legale) sono state
chieste su **AUDUSD** — perche' `InpSimboloFuso` era vuoto e lo script ha
usato "il primo simbolo esaminato" — e AUDUSD in locale non aveva quei mesi.
Quindi **lo shift storico fra i due feed resta ignoto**, ed e' proprio il
numero che serve per validare un backtest su dati Pepperstone.

---

## 3. 🐛 Il verdetto DST era un FALSO ALLARME

Il log grida:

```
-> ATTENZIONE: L'ORA DI APERTURA CAMBIA DI +0 ORE FRA LE STAGIONI
   QUESTO SERVER NON SEGUE IL DST DEL MERCATO
```

**"CAMBIA DI +0 ORE" e' una frase che si contraddice da sola.** Andando a
vedere i numeri veri:

| stagione | apertura misurata su AUDUSD |
|---|---|
| ora solare (gen/nov) | **00:00** |
| ora legale (apr/lug) | **00:05** |

Sono **5 minuti**, non un'ora. Il codice confrontava i minuti (`mSol != mLeg`)
ma stampava le ore con la **divisione intera** (`(5-0)/60 = 0`). Cinque minuti
di scarto sono una prima barra M5 mancante, non un cambio di fuso.

E c'e' un secondo motivo per buttare via questo verdetto: e' stato misurato
su **AUDUSD**, cioe' un cambio. L'intestazione dello script lo dice da sola —
_"sui cambi, che girano 24h, la prima barra del giorno e' sempre 00:00 e non
dice niente"_. Il DST va misurato su un **indice**.

**Corretto oggi**: tolleranza di 30 minuti sotto la quale non si grida al
DST, e quando lo scarto e' vero si stampa in **ore E minuti**, mai troncato.

---

## 4. 📅 Le prime date: un numero pesante, ma da riverificare

La colonna `PrimaDataTF`/`PrimaDataD1` e' `SERIES_SERVER_FIRSTDATE`, cioe'
**quello che il broker dichiara di possedere** (non la cache locale).

| simbolo | prima data H1 dichiarata | barre D1 | stato |
|---|---|---:|---|
| EURUSD | **2023.01.02** | 939 | COMPLETO |
| GBPUSD | **2023.01.02** | 939 | COMPLETO |
| USDCHF | **2023.01.02** | 114 | COMPLETO |
| USDJPY | **2023.01.02** | 939 | COMPLETO |
| AUDUSD | 2026.01.02 | 161 | COMPLETO |
| USDCAD | 1993.04.28 | 13 | da scaricare (parziale) |
| AUDNZD | 1993.04.05 | 13 | da scaricare (parziale) |
| AUDCAD | 1993.04.27 | 13 | da scaricare (parziale) |
| AUDCHF | — | 0 | NESSUN DATO |

**Se 2023.01.02 fosse il vero limite, il piano cadrebbe**: alla prova di
regime servono il **2022** (orso) e il **2020** (crollo Covid), e Pepperstone
non li avrebbe.

**[INCERTO] — e non lo scrivo come verdetto, per un motivo tecnico.**
`MisuraSerie` aspetta la risposta del server solo **2 secondi**
(`ABTG_ATTESA_GIRI 8` × 250 ms). Che quel tempo non basti sempre lo dimostra
la stessa tabella: tre simboli rispondono **1993.04.xx**, una data
palesemente falsa. Un meccanismo che produce dimostrabilmente numeri sbagliati
non puo' essere la fonte di una decisione che chiude un filone. Il 2023 va
riverificato con un'attesa lunga, e **su un indice**, non sui cambi.

> ℹ️ Nessuna contraddizione col lavoro gia' fatto: il feed **2018-2024 di
> EURUSD/GBPUSD** in `import_esterno` viene da **HistData**, gratis, non da
> Pepperstone (`docs/BROKER_ESTERNO_MAPPA.md` §1).

---

## 5. 🎯 Cosa NON si puo' dire, dopo questa corsa

- ❌ "Pepperstone non ha gli indici" — ne abbiamo visti 9 su 1722.
- ❌ "Pepperstone parte dal 2023" — misura da 2 secondi, e la stessa tabella
  contiene tre date false.
- ❌ "Il server non segue il DST" — falso allarme da 5 minuti, per giunta su un cambio.
- ❌ Qualunque orario nuovo negli `.ini`: il lato BCM non e' stato misurato.

## 6. ▶️ Il passo dopo

**Ricognizione sui 120 del Market Watch** (`-SoloMarketWatch`), che e' dove
Pepperstone tiene i maggiori indici. Costa minuti, non giorni. Poi, con i
**nomi veri** in mano, si rifa' la misura del fuso su un **indice** e si
lancia lo stesso ricognitore **su BCM**, che e' il termine di paragone senza
il quale nessuna rimappatura di orari e' verificata.

**Nessun parametro degli EA in forward cambia per questi numeri.**
