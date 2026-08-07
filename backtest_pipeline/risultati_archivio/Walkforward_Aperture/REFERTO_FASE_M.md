# FASE M — il lato del mercato. 07/08/2026

48 pass. La fase era stata scritta per salvare il Nasdaq. **Il Nasdaq non si salva, e il
risultato è arrivato dal braccio che serviva da controllo.**

---

## ✅ Il controllo interno passa

La cella `AllowLong=0 + AllowShort=0` dà **0 trade in tutti e quattro i file**. I filtri di
direzione funzionano davvero: il resto della tabella si può leggere.

---

# 🟢 DAX — `SOLO LONG` passa tutti e tre i criteri, e di parecchio

profitto / PF / DD / trade

| lato | range | IS | OOS |
|---|---:|---:|---:|
| long+short ← **acceso oggi** | 35 | −9,02 · 0,997 | +1198,79 · 1,237 · 10,49% · 316 |
| **SOLO LONG** | 25 | +484,80 · 1,155 | +697,70 · 1,137 · 8,54% · 266 |
| **SOLO LONG** | **35** | **+394,97 · 1,131** | **+1800,19 · 1,423 · 6,72% · 256** |
| **SOLO LONG** | 45 | +5,27 · 1,001 | +491,20 · 1,118 · 7,94% · 236 |
| SOLO SHORT | 35 | −501,27 · 0,845 | +254,74 · 1,065 · 12,04% |

## I criteri, quelli scritti PRIMA di guardare

| | criterio | esito |
|---|---|---|
| 1 | positiva in **tutte e due** le finestre | ✅ e non solo la 35: **6 celle su 6** (3 range × 2 finestre) |
| 2 | **PF ≥ 1,10** fuori campione | ✅ **1,423** |
| 3 | **vicini positivi** | ✅ 25 e 45 positivi in **entrambe** le finestre |

**È un altopiano, non un picco.** Ed è la prima volta in tutta la ricerca che una cella passa
i tre criteri dichiarati in anticipo.

## Contro la configurazione accesa oggi

| | long+short (oggi) | SOLO LONG | differenza |
|---|---:|---:|---|
| profitto OOS | +1198,79 | **+1800,19** | **+50%** |
| Profit Factor | 1,237 | **1,423** | +15% |
| Equity DD | 10,49% | **6,72%** | **−36%** |
| resa / DD | 114 | **268** | **×2,35** |

## 🔑 E il meccanismo si vede nei conteggi — non è un aggiustamento di numeri

```
SOLO LONG    256 trade
SOLO SHORT   243 trade
long+short   316 trade      <-- NON 499
```

Con `OneTradePerDay` **la giornata ha un solo posto**. Su ~183 giornate in cui sarebbero
scattati tutti e due, **lo short si prende il posto del long**. Quindi permettere gli short
non aggiunge trade perdenti: **consuma il trade della giornata**, togliendolo a quello che
avrebbe fatto meglio.

Questo è un effetto **meccanico e verificabile nei numeri**, non una curva tirata sui dati.
È la ragione per cui questo risultato è più credibile di tutti quelli che l'hanno preceduto.

---

# 🔴 Nasdaq — bocciato dalla regola scritta prima

| lato | range | IS | OOS |
|---|---:|---:|---:|
| SOLO LONG | 25 | −235,51 | −399,00 |
| **SOLO LONG** | **35** | **−105,58** | **+342,32 · PF 1,129** |
| SOLO LONG | 45 | −87,73 | −314,31 |
| SOLO SHORT | 35 | **+404,12 · 1,165** | **−694,01 · 0,822** |
| SOLO SHORT | 45 | +308,34 · 1,111 | −622,66 · 0,831 |

La cella `SOLO LONG 35` è l'unica interessante fuori campione. **E fallisce due criteri su tre:**

- **criterio 1** — in campione fa **−105,58**. Non è positiva in entrambe le finestre. ❌
- **criterio 3** — i vicini fuori campione fanno **−399,00** e **−314,31**. È un **picco
  isolato in mezzo a due buche**. ❌

**Il confronto è servito su un piatto d'argento:** sul DAX `SOLO LONG` è positivo in 6 celle
su 6; sul Nasdaq è positivo in 1 su 6, e le due accanto sono negative. **È esattamente la
differenza fra un altopiano e il rumore**, vista fianco a fianco nella stessa corsa.

E `SOLO SHORT` sul Nasdaq è il **settimo** ribaltamento IS→OOS: migliore in campione
(+404,12 · PF 1,165), peggiore fuori (−694,01 · PF 0,822).

**Settima ipotesi, settima bocciatura. Come scritto prima del test: il Nasdaq d'apertura è
chiuso come ricerca.**

---

# ⚠️ Tre limiti da tenere, sul risultato del DAX

1. **La finestra OOS è stata riusata.** Ci abbiamo guardato in otto fasi. **Sta diventando
   una seconda finestra in campione**, ed è precisamente il meccanismo che stanotte abbiamo
   documentato due volte. Questo risultato **va confermato in forward, non con altri
   backtest sulla stessa finestra.**
2. **Long-only su un indice in un periodo di rialzo cattura anche la deriva del mercato.**
   Non sappiamo come si comporta in una fase di ribasso prolungato.
   ⚠️ Ma l'ipotesi "è solo deriva" è indebolita: sul DAX `SOLO SHORT` a range 45 fa
   **+715,98 con PF 1,212** fuori campione. Gli short non erano tutti perdenti — erano
   *nel posto sbagliato*.
3. Il candidato attuale ha **un solo giorno di forward**. Cambiarlo di nuovo subito
   significa non accumulare mai forward su nessuna configurazione.

## La conseguenza operativa, che risolve il punto 3

**Non toccare `ABTG_DAX_Apertura_EU`.** Resta a `long+short` e fa da braccio di controllo.

**Mettere `SOLO LONG` su `ABTG_DAX_Apertura_EU_Ottimizzato`**, che è già sullo stesso
grafico con un magic diverso e oggi gira una configurazione bocciata (BREAKOUT 15/600 e
`TRAIL_FIXED`). Così:

- si ottiene un **A/B in forward vero**, stesso simbolo, stesso momento, magic diversi;
- si sistema anche il trailing fisso di quell'EA (A10);
- **l'esposizione su D30EUR non aumenta**: resta all'1%.

È esattamente la regola di progetto — *gli `_Ottimizzato` girano in parallelo agli
originali, mai al posto loro.*
