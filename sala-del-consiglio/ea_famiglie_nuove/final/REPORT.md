# Report finale, Sala del Consiglio, 14 EA nuove, 26/11/2026 (verificato da A6)

**Stato:** A1-A5 hanno consegnato le 14 schede; **A6 ha ricontrollato 155 citazioni di codice (tutte e 14 le EA, 9-14 per EA) + 9 dichiarazioni su altri file: 162 CONFERMATE, 2 ERRATE, 0 NON TROVATE** (`agents/A6/VERIFICA.md`). Le due errate: LiquiditySweep cita r.152-155 (sono r.148-151, sostanza vera); CanaleLento cita il valore 0,44 dal file sbagliato (esiste in `SUPERTREND_CORRELAZIONE_CRITERI_2026-11-21.md`). Nessun backtest eseguito: tutto e' lettura del codice e piano di test. Probabilita' = stima a priori dei revisori di superare il criterio scritto prima.

| # | EA | Classe | Difetto principale | Primo test (criterio scritto prima) | Prob. |
|---|---|---|---|---|---|
| 1 | PunteLarry (oro H1) | **A** | spread/commissioni nel P/L; D1 tagliato a mezzanotte server (BCM non trasferibile su FTMO); gia' misurato: PF 1,43/1,66/1,28, tick 1,44, ~10-15 op/anno, p~0,06, EURUSD 0/3 | argento (XAGUSD) con i default: PF >= 1,20 in >= 2 finestre su 3, >= 8 op per finestra | 25% |
| 2 | FvgRetest | **A** | filtro spread spento (InpMaxSpread=0); sui `_EXT` spread 0 e tickvol 1; manca l'include Guardian | NASUSD_EXT M15 IS 2010-19, OOS 2020-23, costo fisso: IS PF >= 1,30, OOS >= 1,20, >= 150 trade | n.d. (ablazione 25%) |
| 3 | TurnaroundTuesday | **A solo su altri mercati; oro CHIUSO (A6)** | intestazione "server = IT - 1" vero solo in ora legale: ora per stagione; riga 00:00 oro FTMO; lotto riportato al minimo (r.682) | motore nudo con ora per stagione e costo fisso; placebo mercoledi'/giovedi'/venerdi' | prior basso. **Sul codice identico alla copia `_F1` del repo l'oro e' gia' misurato: PF 0,84 e 0,74 (NON REGGE, `FAMIGLIA1_ORO_CRITERI`)** |
| 4 | OutOfNoise | **A con protocollo** | sessione fissa DAX 08:00-16:30 / US 14:30-21:00 corretta solo in estate | baseline per stagione su dati nativi 2024-26 (periodo corto, nessun fuori campione) | 6% |
| 5 | LiquiditySweep | **A solo su altri mercati; oro CHIUSO (A6)** | BE a 1R acceso di default; nessun pavimento sullo stop (con buffer 0 il lotto puo' esplodere); riga 00:00 oro FTMO; "fade falso breakout" gia' chiuso. **Oro gia' misurato (codice = copia `_F1`): PF 0,79 e 0,71, NON REGGE** | oro BCM IS 2013-22, OOS 2004-12, HO 2023-24, BE spento | 6% |
| 6 | MeanRevert | **A** | nessuna uscita a tempo (swap, gap weekend), nessun tetto giornaliero | baseline su 28 cross + oro + 3 indici, IS/OOS/HO con costi | 4% |
| 7 | Gold_Ichimoku_TK_ATR_EA | **A (priorita' bassa)** | `PositionSelect(_Symbol)` (r.672) con altri EA sull'oro su conto hedging; nessuno stop minimo broker; swap long BCM; mai misurato; "VALIDATA" nell'intestazione senza riscontro | 2015-23 PF >= 1,20, >= 100 op; 2005-14 PF >= 1,0; hold-out chiuso | 22% (REGGE completo 5%) |
| 8 | CanaleLento | **A (bassa)** | pulito; Donchian 55/20 D1 long+short; long-only gia' 0/34; sull'oro = motore di GoldenZoe (rho attesa 0,5-0,8, INFERENZA) | misura Python economica di short e uscita a 20 | basso |
| 9 | CrossEma | **A (bassa)** | include `ABTG_PausaGuardian.mqh` assente (non compila dallo zip); filtro volume blocca tutto sui `_EXT`; filtro news spento in tester | cella nuda 6 mercati x H1/H4 in Python: una passa IS e OOS | 7% (2 mercati: 2%) |
| 10 | GoldBreakoutATR | **B** | gia' misurato: 2015-23 PF 0,94, DD 57%, t -1,5; 2005-14 PF 1,11, t +4,7; mancano 3 anni su 9 di dati (spread 0,05 ATR o buchi M1) | replica a tick 2024-07..2026-11, PF >= 1,20, >= 100 op | 15% |
| 11 | VwapRevert | **B** | nessun filtro sessione di default, VWAP ancorata a mezzanotte server, barre minime 0; orari estivi hardcoded; nome ingannevole (BuyStop, target 2R) | prima solo conteggio setup (>= 150 pooled, >= 30 per cella), poi PF | n.d. |
| 12 | AltaVelocita | **B** | Supertrend ricalcolato su 300 barre con direzione forzata (dipende dalla data d'inizio test); SL buffer fisso 10 punti; ordine rifiutato consuma il segnale (r.1141); tiene posizioni nel weekend; ~25 input, 8 condizioni in cascata | correzioni, poi baseline tick 2024-26 + M1 2013-26 su 4 simboli | basso |
| 13 | CRT_TurtleSoup | **B** | pavimento 500 punti non scalato (circa 50 pip sul forex, 5 USD sull'oro); nessun controllo R/R ne' minimo sul wick; flat 22:00 fisso; 7 operazioni sull'oro non provano nulla | NASUSD nativo M15 2024-26 + `_EXT` 2010-19 IS | 4% |
| 14 | ChaosLyapunov | **B** | gate sulla barra in formazione (r.385); manca la finestra di Theiler (probabile filtro di volatilita' travestito da "caos"); pavimento 500 punti fisso; flat a ora fissa | correggere, poi ablazione in Python | 4-5% |

## Sintesi
1. **Nessuna delle 14 e' un candidato.** Le probabilita' stimate dai revisori di passare il primo cancello vanno dal 4% al 25%.
2. **Due non erano "mai misurate"** (A1): GoldBreakoutATR e PunteLarry coincidono con le versioni `_F1` del repo; le misure del 18/11 valgono.
3. **I difetti sono quasi tutti di test e di impostazione**, non di logica: orario in ora server senza ora legale, `_EXT` con spread 0 e tickvol 1, riga 00:00 sui dati oro FTMO, include `ABTG_PausaGuardian.mqh` assente nei materiali (compilazione da verificare per FvgRetest, LiquiditySweep, CrossEma, VwapRevert, OutOfNoise).
4. **Mediazione/griglia:** A2 la esclude per MeanRevert, VwapRevert e OutOfNoise (una posizione per magic); per gli altri non e' stata dichiarata esplicitamente, tranne AltaVelocita (una alla volta).
5. **Per l'obiettivo "EA scorrelati per la prop":** gli oro (PunteLarry, Ichimoku, CanaleLento) sono probabilmente correlati con GoldenZoe; i candidati scorrelati stanno nei forex/indici (FvgRetest, MeanRevert, TurnaroundTuesday, OutOfNoise), ma sui `_EXT` i dati vanno prima verificati.

## Ordine di misura proposto (economico prima)
a) In Python, senza PC di prova: CanaleLento (short + uscita a 20), CrossEma (cella nuda), conteggio setup di VwapRevert, ablazione di ChaosLyapunov. b) Nel tester: FvgRetest e TurnaroundTuesday (con ora per stagione, costo fisso, riga 00:00 scartata), poi PunteLarry su argento e MeanRevert. c) Le classi B solo dopo le correzioni.

## Verifica indipendente (A6)
- **Incoerenza trovata:** TurnaroundTuesday e LiquiditySweep (classe A dei revisori) ignoravano misure gia' nel repo: i sorgenti sono identici alle copie `_F1`, e sull'oro sono NON REGGE. Anche `RIANALISI_EA_NOSTRI_2026-11-26.md` (riga A9) li dava come mai misurati: **errore mio, corretto qui**. Restano misurabili su altri mercati (indici, forex), non sull'oro.
- **Difetti nuovi:** ChaosLyapunov, gate 'non caos' fail-open (casi degeneri danno LLE 0.0, il gate blocca solo se LLE > soglia: passa): gravita' media, falsa i test. FvgRetest r.947 e CrossEma r.402: se il TP cade dentro lo stops level, l'EA lo toglie in silenzio e apre con il solo SL (minore).
- **Altre incoerenze minori:** OutOfNoise (A) e VwapRevert (B) hanno difetti dello stesso tipo senza criterio dichiarato; Ichimoku ha un difetto etichettato 'falsa i test' ma classe senza correzioni; l'include `ABTG_PausaGuardian.mqh` assente ha gravita' diverse tra le schede.
- **Affidabilita' revisori:** A1 alta (unico ad aver incrociato le misure del repo), A2 alta sul codice, A3 medio-alta, A4 alta sul codice ma lacuna sulle misure esistenti, A5 alta.

## Limiti dichiarati
Nessun backtest; le probabilita' sono stime a priori; sorgenti NON nel repo (pubblico).
