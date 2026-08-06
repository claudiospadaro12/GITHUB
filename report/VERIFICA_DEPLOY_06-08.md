# Verifica del deploy — 06/08/2026, sera

Fonte: log Esperti del VPS, `20260806.log`, filtro `CONFIG IN USO`, 10 righe.
Estratto con `backtest_pipeline/log_ea.ps1`.

La riga `CONFIG IN USO` la scrive ogni EA all'avvio: dice **cosa sta davvero girando**,
non cosa dovrebbe girare. È l'unico modo che abbiamo per sapere se un riattacco ha preso.

---

## Stato attuale — l'ULTIMA riga di ogni EA

| EA | ultimo avvio | motore | range | buffer | offset | rischio | TP | trail |
|---|---|---|---:|---:|---:|---:|---:|---|
| **DAX Apertura EU** | 19:25:33 | **RETEST** | **35** | **500** | **200** | 2,00% | 3,0R | PREVBAR M5 |
| Dow Apertura US | 19:17:55 | BREAKOUT | 15 | 200 | 0 | 1,00% | 1,5R | PREVBAR M5 |
| Nasdaq Apertura US | 19:17:56 | BREAKOUT | 15 | 300 | 0 | 2,00% | 3,0R | PREVBAR M1 |
| Nasdaq Apertura US OTT | 19:47:16 | BREAKOUT | 15 | 150 | 0 | 1,00% | 3,0R | PREVBAR M1 |
| DAX Live 5m | 19:37:07 | BREAKOUT | 15 | 700 | — | 2,00% | 3,0R | PREVBAR M1 |
| DAX Live5m v2 | 19:45:58 | BREAKOUT | 15 | 700 | — | 1,00% | 3,0R | PREVBAR M1 |
| Nasdaq Live 5m | 19:47:49 | BREAKOUT | 15 | 700 | — | 2,00% | 3,0R | PREVBAR M1 |
| **DAX Apertura EU Ottimizzato** | **nessuna riga** | — | — | — | — | — | — | — |

---

## ✅ Quello che ha funzionato

**I quattro parametri validati sono in produzione.** Alle 19:25:33 il `DAX Apertura EU`
riparte con `RETEST · range 35 · buffer 500 · offset 200`. Alle 19:17:55 lo stesso EA era
ancora `BREAKOUT · 15 · 200`: le due righe insieme sono la prova che il "Ripristina" ha preso
e che i parametri non sono tornati indietro.

Fuori campione quella configurazione fa **+1198,79 · PF 1,237 · DD 10,49%** all'1%
(referto B1). Da domani è forward vero.

**Quattro dei cinque EA corretti sono ripartiti** con la guardia A4 a bordo:
`Nasdaq Apertura US OTT`, `DAX Live 5m`, `DAX Live5m v2`, `Nasdaq Live 5m`.

---

## 🔴 Quello che manca

### `ABTG_DAX_Apertura_EU_Ottimizzato` non scrive nessuna riga

Su 10 avvii registrati non compare mai. Le spiegazioni possibili sono tre, e portano ad
azioni diverse:

1. **non è attaccato a nessun grafico** sul VPS → allora non è mai stato in forward, e va
   deciso se metterlo;
2. **è attaccato ma non è stato riavviato** → non ha il file nuovo, gira ancora il vecchio
   compilato senza guardia A4;
3. **è attaccato ma AutoTrading è spento su quel grafico** → non gira e non scrive.

Da distinguere guardando il VPS: se sul grafico c'è la faccina sorridente in alto a destra
è attaccato; se non c'è, è il caso 1.

⚠️ Nei casi 2 e 3 quell'EA **non ha la guardia A4**: al riavvio riarma i pendenti su una
giornata già operata. È lo stesso difetto che ha prodotto il doppio trade del 05/08.

---

## 🔎 Trovato guardando il log: `DAX Live 5m` e `DAX Live5m v2` sono lo stesso EA

Confronto dei default nel codice:

- **59 parametri in comune, 59 identici.** Nessuna differenza.
- v2 ne ha **7 in più**, e per default sono **tutti neutri o quasi**:

| parametro in più | default | effetto |
|---|---|---|
| `InpUseVolumeFilter` | `false` | **spento**: non salta nessun segnale |
| `InpSkipIfTight` | `false` | **non salta** il trade con lo stop stretto |
| `InpBEatR` | `0` | spento |
| `InpVolMult` / `InpVolAvgBars` | 1.5 / 20 | irrilevanti a filtro spento |
| `InpSlippagePts` | 100 | tolleranza di riempimento |
| `InpMinStopPts` | 200 | **l'unica differenza vera**: pavimento sullo stop → lo **allarga**, non salta il trade |

**Conseguenza:** v2 entra sullo **stesso segnale, nello stesso momento, nella stessa
direzione** di `DAX Live 5m`. Cambia la larghezza dello stop (e quindi il lotto e l'uscita),
non il fatto che il trade ci sia.

Nel log girano al **2,00% e all'1,00%** → **3% del conto su un segnale solo**, sullo stesso
simbolo. È esattamente A1, la stessa cosa di `Apertura Marco` che abbiamo appena spento.

⚠️ **Limite di questa lettura:** ho confrontato i **default nel codice**. Sul VPS i parametri
stanno sul grafico e possono essere diversi — il rischio 2% vs 1% lo è già. La verifica
definitiva è aprire le proprietà dei due EA sul grafico e confrontarle. Finché non è fatta,
questa è una diagnosi dal codice, non una misura.

---

## Esposizione teorica di caso peggiore, per simbolo

Sommando i rischi dichiarati nel log, se tutti gli EA di un simbolo andassero a stop lo
stesso giorno:

| simbolo | EA | somma dei rischi |
|---|---|---:|
| D30EUR | Apertura EU 2% + Live 5m 2% + Live5m v2 1% | **5%** |
| NASUSD | Apertura US 2% + OTT 1% + Live 5m 2% | **5%** |
| U30USD | Dow 1% | 1% |
| | **totale** | **11%** |

Non è una previsione: gli EA non perdono tutti insieme e non entrano tutti ogni giorno.
Ma è il tetto, ed è il numero che una prop guarda. **Con un limite giornaliero del 5%, un
solo simbolo che va male esaurisce la giornata.**

---

## Da fare

1. Capire perché `DAX Apertura EU Ottimizzato` non compare (i tre casi sopra).
2. Confrontare i parametri sul grafico di `DAX Live 5m` e `DAX Live5m v2`. Se sono
   davvero lo stesso EA, ne va spento uno — stessa logica di Marco.
3. Riportare l'esposizione per simbolo sotto controllo prima di parlare di prop.
