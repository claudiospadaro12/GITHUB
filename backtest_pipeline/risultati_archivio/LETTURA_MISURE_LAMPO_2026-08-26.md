# 🔬 LETTURA DELLE MISURE LAMPO — il frigo dati, deciso coi numeri

_Corsa di Claudio 26/08 18:03-18:04 (1,2 min), pin `03268a2`, ESITO OK,
vol misurata 4/4, eventi 3/3, 0 problemi. Zip `MISURE_LAMPO_20260826_1803`.
Referto driver archiviato accanto. Le ipotesi di lettura erano PRE-SCRITTE
(par. 16.1 e criteri della riga): qui si applicano, non si inventano._

## 1) LA VOLATILITA' ORARIA — il metro relativo ora ha numeri MISURATI

| SIM | diff agli atti | vol 2025 (misurata) | rapporto | metro relativo 0,20xvol |
|---|---:|---:|---:|---|
| **NASUSD** | 0,0662% | 0,3324% | **0,199** | ✅ **sotto (per un pelo)** |
| SPXUSD | 0,0527% | 0,2602% | 0,203 | ❌ sopra (per un pelo) |
| 225JPY | 0,0871% | 0,3747% | 0,232 | ❌ sopra |
| EURUSD (controllo) | 0,0041% | vol TOT 0,1232% | 0,033 | ✅ largo (come tutti i forex promossi) |

La banda dei forex promossi era 0,03-0,23 (AUDJPY al bordo 0,23): il Nikkei
sta AL bordo, S&P un soffio sopra la proposta, **il Nasdaq sotto**.

## 2) L'ANATOMIA DEI TRE EVENTI — verdetto unanime: **EVENTI VERI** (ipotesi 2)

| Evento | Cosa mostrano le barre M1 | Verdetto |
|---|---|---|
| **A · 23/03/2026** | crollo/spike SIMULTANEO e reale nell'ora incriminata: NASUSD **3,43%**, 225JPY **5,28%**, SPXUSD **3,66%** (ordini di grandezza = gli attesi pre-scritti). Un buco di 13 min sul NASUSD DENTRO il botto (salto 775 pt) | **MOVIMENTO VERO** + micro-buco durante il panico |
| **B · 20/11/2025** | discesa reale ~2,0-2,6% su tutti e tre, barre complete, zero buchi | **MOVIMENTO VERO** (atteso 2,5%: centrato) |
| **C · 09/01/2026** | 225JPY **3,09%** nell'ora, **60 barre su 60**, zero buchi; NASUSD/SPXUSD tranquilli | **MOVIMENTO VERO del solo Nikkei** — NON e' sessione storta |

**La domanda pre-scritta dell'evento C aveva due esiti: "se C e' sano, il
sospetto torna tutto sul calendario". C E' SANO.** Quindi: le diff-max
giganti degli import sono **disallineamenti di UN'ORA durante botti veri**
(la firma del DST/shift), non spazzatura nei dati. Coerente con la misura
gia' agli atti (diff 4-5x peggio dentro le finestre DST). **La "malattia
sessioni" del grxeur NON si vede su questi tre feed.**

## 3) LE CONSEGUENZE — due porte si aprono

1. **Lo STUDIO ANATOMIA e' INTERPRETABILE**: la dipendenza dichiarata in
   testa ai suoi criteri ("aspetta l'esito misure lampo") si scioglie in
   positivo — i 16 anni di barre sono sani su tutte le sonde fatte.
2. **PROPOSTA DI FIRMA — "FRIGO: APERTURA PARZIALE"**: adottare il metro
   RELATIVO 0,20xvol (ora misurato, non stimato) per gli indici _EXT,
   con le condizioni compagne dell'analisi del 25/08 (eventi spiegati ✅,
   copertura >=80% ✅ (97%)):
   - **NASUSD_EXT: ESCE DAL FRIGO** — solo PROVA DI REGIME a parametri
     congelati (D-C resta), mai promozione di celle.
   - **SPXUSD_EXT e 225JPY_EXT: RESTANO IN FRIGO** (sopra il metro, anche
     relativo). Si riesaminano solo con una misura nuova.
   - Il cancello assoluto 0,05% resta INVARIATO per i forex.
   Caveat dichiarato: il metro relativo e' una soglia proposta il 25/08
   PRIMA di queste misure (non ritagliata sui numeri di oggi); il bordo
   sottile di NASUSD (0,199) e' scritto, non nascosto.
   ➡️ Si firma con "FIRMO FRIGO NASUSD" (o si respinge: il frigo resta).

## Nota P6 (dichiarata dal driver): EURUSD senza riga 2025 nel CSV — il suo
rapporto sul perimetro esatto resta n/d; il controllo regge sul TOT, dove il
nativo copre tutto. Nessun impatto sulle conclusioni.
