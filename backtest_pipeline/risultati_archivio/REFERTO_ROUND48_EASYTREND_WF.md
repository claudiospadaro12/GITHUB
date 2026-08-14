# REFERTO ROUND 48 — Easy Trend al walk-forward: TRE PROMOSSI PIENI (14/08/2026)

**Domanda:** dopo il tick reale (4/4, tenute 85-104%), la strategia del
capitolo Easy Trend passa il cancello IS/OOS con i criteri congelati?

**Risposta: SI', su tre mercati su quattro. Il quarto e' una riserva per
campione sottile, non una bocciatura.**

Detector PINNATO alla CAL (PivotSource 0, PivotR 3), spread ACCESO (30 pt),
6 celle utili per finestra (TP 1,0/1,5 x tre combinazioni di lati; le due
celle con entrambi i lati spenti non operano per costruzione).

## I promossi (cella scelta sull'IS con n>=20, giudicata OOS)

| Simbolo | Cella | IS | OOS | PF | DD | n OOS |
|---|---|---|---|---|---|---|
| **GBPUSD** | TP 1,5 · L+S | +358 (PF 1,26) | **+1.008** | **1,49** | 4,58 | 41 |
| **AUDJPY** | TP 1,0 · L+S | +197 (PF 1,14) | **+894** | 1,37 | 4,29 | 54 |
| **CHFJPY** | TP 1,5 · L+S | +278 (PF 1,16) | **+765** | 1,25 | 6,27 | 53 |

**Famiglia: +2.667 OOS su 148 chiusure**, DD sempre sotto il 7%, PF fra
1,25 e 1,49. Tutti e tre passano ogni cancello: profitto > 0, PF >= 1,10,
DD < 10%, n >= 20, lato coerente fra le due finestre.

## EURGBP: riserva per campione sottile (nota di trasparenza)

Col criterio congelato **n >= 20 in campione**, l'unica cella ammissibile
di EURGBP e' TP 1,0 L+S (n=20, IS **-108**): fuori campione fa -635, quindi
**BOCCIATA**, e cosi' resta agli atti.

Ma va detto con onesta' cosa mostra il resto della tabella: la cella
**TP 1,5 SOLO SHORT** e' la migliore in campione (+552, PF 1,88) e la
migliore fuori campione (**+836, PF 1,87, DD 3,11, n=22**) — PF quasi
identico nelle due finestre, il contrario di un ribaltamento. Non passa
solo perche' in IS ha **14 trade invece di 20**. E' esattamente il caso
"cella buona con campione sottile": **riserva**, non bocciatura di merito.
Si riapre da sola quando la finestra si allunghera' (vedi
`report/ASPETTATIVE_REALISTICHE.md`), oppure resta fuori. Il criterio non
si piega a posteriori: era scritto prima, e prima si e' deciso che 14
trade non bastano.

## L'osservazione che conta: il criterio ha scelto L+S, non i mono-lato

Al tick reale i mono-lato dominavano (EURGBP short +2.502, GBPUSD long
+1.843). Al walk-forward le celle promosse sono **tutte L+S**, perche' i
mono-lato in IS non arrivano a 20 trade (la finestra in campione e' di
soli 8,5 mesi). **Il campione, non l'edge, ha scelto la configurazione.**
E' una limitazione della finestra corta, non una scoperta sui lati: da
dichiarare, non da nascondere. Nota utile per il futuro: se la finestra
si allunghera', questa famiglia va rimisurata coi mono-lato ammessi.

## Cosa NON si e' fatto (e perche')

Nessuna ri-ottimizzazione dopo aver visto l'OOS. Nessun ripescaggio della
cella short di EURGBP. Nessun cambio dei criteri. Il round vale proprio
perche' e' stato giudicato con le regole scritte prima.

## Prossimo cancello

**R49: per-trade a 100k** con magic VERGINI e sweep gemello
(772411/12 CHFJPY, 772413/14 GBPUSD, 772415/16 AUDJPY) -> poi portafoglio
contro le 27 serie. **Lo standard decide**: si entra solo se AGGIUNGE
profitto E NON alza le code MC. Il quinto EA del corso e' all'ultimo
cancello.

_Dati: `risultati_prove/ABTG_EasyTrend/r48/` (8 CSV). Prove coi criteri
congelati: `prove/R48a-d_ez_*.txt`. Tesi: `prove/EASY_TREND_TESI.md`._
