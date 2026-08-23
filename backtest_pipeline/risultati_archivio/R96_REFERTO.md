# R96 — REFERTO: il CrossEma d'apertura non ha edge. BOCCIATO su entrambi i simboli.

**Data verdetto: 23/08/2026 mattina. Corsa tick reali, pin `3783e15`, zip
`R96_APERTURA_USA_CORSA_20260823_0733`, ESITO tecnico OK, gemelli IDENTICI,
autotest 6/6. Criteri: `R96_CRITERI.md`.**

## I gate, prima dei numeri
- PASSO 0 verde: 1.104 ingressi della sonda, 448 sessioni, prima operazione
  2024.09.30 (limite 2024.12.31).
- **Checklist 52 (l'artefatto del seme) misurata**: 448 incroci su 1.323
  sono quelli garantiti della seconda barra; gli incroci in cui i periodi
  9/21 hanno DECISO qualcosa sono 875 (66%). Quindi il round ha misurato
  davvero l'incrocio, non solo il momentum della campanella: il verdetto
  sotto vale per il motore, non per un artefatto.
- Cancello della distinzione (par. 4.2): l'ancora NON e' cosmetica — i
  conteggi di cella A e B differiscono ben oltre il 10% (es. OOS Dow:
  n 661 contro 423). L'ancora fa qualcosa. Solo che quello che fa, perde.

## I numeri (n accanto a ogni numero, per simbolo, mai in pooling)

**U30USD (Dow):**
| cella | IS Profit | IS PF | n IS | OOS Profit | OOS PF | OOS DD | n OOS |
|---|---:|---:|---:|---:|---:|---:|---:|
| A (ancora) | −9.302 | 0,96 | 440 | **−28.908** | 0,92 | 35,5% | 661 |
| B (controllo, MAI promuovibile) | −23.816 | 0,83 | 273 | −12.027 | 0,95 | 24,7% | 423 |

**NASUSD:**
| cella | IS Profit | IS PF | n IS | OOS Profit | OOS PF | OOS DD | n OOS |
|---|---:|---:|---:|---:|---:|---:|---:|
| A (ancora) | −1.772 | 0,99 | 437 | −5.232 | 0,99 | 35,4% | 643 |
| B (controllo, MAI promuovibile) | +7.428 | 1,06 | 256 | +337 | 1,00 | 19,1% | 410 |

**VERDETTO: BOCCIATO.**
- La cella A (l'unica candidabile per costruzione) **perde su entrambi i
  simboli, in entrambe le finestre**, con drawdown del 29-35% e serie
  perdenti mostruose (peggior serie −11.963).
- La cella B su NASUSD e' l'unico segno verde del round (PF 1,06 IS,
  1,00 OOS = piatto) — ed e' **per firma non promuovibile, MAI, nemmeno
  se vince** (schema "filtro orario appiccicato", 0 successi su 5).
  Un PF 1,00 in OOS e' comunque rumore, non un rimpianto.

## La lettura
L'apertura USA come costruttore di segnale CrossEma non funziona: il
motore genera 2-3 incroci a sessione (frequenza in linea col previsto,
2,95) e li perde con costanza. Non e' un problema di campione (n fino a
661) ne' di artefatto (66% incroci veri). Su U30USD, dove un motore
d'apertura VALIDATO esiste gia' (ORB R88), questo round conferma per
contrasto che l'edge del Dow sta NELLA rottura del range, non negli
incroci di medie dentro la sessione.

## Il quadro delle 24 ore — quattro round, quattro NO puliti
R97 (ORB Nasdaq) 0/4 · R98 (Momentum Nasdaq) 0/6 · R95 (Sweep EURJPY)
0/30 · R96 (CrossEma apertura Dow+Nasdaq) 0/4. Tutti con campione pieno,
macchina perfetta, criteri firmati prima. La coda dei round firmati e'
ESAURITA: l'imbuto va rifornito con tesi nuove (seconda caccia su mercati
NON gia' chiusi: niente JPY, niente Nasdaq) — oppure si consolida quello
che gia' funziona (Dow, Guardian S1, censimento sedie mute).
