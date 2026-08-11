# REFERTO — GLI 8 FUORI-LISTA (11/08/2026 sera): la partita si chiude

Regola di Claudio (pulizia del 10/08): **"o si misura o si spegne"**.
Stasera: 5 walk-forward a tick reali in 40 minuti di coda (11 celle TF
ciascuno, criteri congelati nei file del 07/08) + la misura R24 del
Nasdaq. Ora OGNI grafico ha numeri. La cella che conta e' quella su cui
il grafico GIRA davvero in forward.

## I verdetti, grafico per grafico

| Grafico (cella live) | La sua cella a tick reali | Verdetto proposto |
|---|---|---|
| **SupRev_DAX_H1** (H1) | IS **-240** / OOS +1.312 — IS ROSSO (pattern regime) | 🔴 **SPEGNERE** |
| **SupRev_DAX_H4** (H4) | IS +464 / OOS +320, PF 1,53, 60 tr — ma vicini H3/H6 rossi (picco isolato) | 🟡 TENERE in forward, osservato. Non candidato |
| **SupRev_DOW_H1** (H1) | IS **-103** / OOS +623 — IS ROSSO | 🔴 **SPEGNERE (SOLO DA FLAT: ha posizione aperta)** |
| **SupRev_DOW_H4** (H4) | **IS +993 / OOS +622, PF 2,32, 49 tr, DD 2,7% — il migliore del lotto** | 🟢 TENERE, osservato SPECIALE (vicini quasi-zero: picco non confermato, ma la cella e' forte in ENTRAMBE le finestre) |
| **STREV_Ott @ XAUUSD** (H4) | IS +463 / OOS +532, PF 2,25, 30 tr (campione al minimo, storico oro corto) | 🟢 TENERE, osservato |
| **Nasdaq_Apertura base** | R24: IS +70 (PF 1,07) / OOS +476 (PF 1,27) — esile ma positivo | 🟡 TENERE, osservato |
| **Nasdaq_Apertura_Ott** | mai misurato; variante del precedente | 🔴 **SPEGNERE il doppione** (la base misurata basta) |
| **DAX_Apertura_EU_Ott** | mai misurato; TERZA variante di una strategia che gia' gira in 2 config (100k validata + piccolo 2%) | 🔴 **SPEGNERE il doppione** |

Bilancio proposto: **4 spegnimenti** (2 celle H1 bocciate dai tick + 2
doppioni mai misurati) e **4 tenute** con referto (2 forti su H4, 2 esili
ma positivi). Nessuno promosso a candidato prop: le due celle H4 forti
hanno i vicini rossi/quasi-zero — coi criteri congelati sono picchi non
confermati, e i 17 ribaltamenti insegnano a non innamorarsi dei picchi.

## Le tre osservazioni che restano agli atti

1. **Il pattern H1-rosso/H4-verde e' identico su DAX e Dow**: sui SupRev
   l'H1 perde in campione e "vince" solo fuori (regime), l'H4 regge in
   entrambe. Coerente con la squadra: il Nikkei validato gira su H2/H4,
   il NAS H1 col suo criterio non passo'. La famiglia SupRev respira
   sui TF alti.
2. **SupRev_DOW_H4 e STREV oro H4 sono i sorvegliati di lusso**: se il
   forward dei prossimi mesi conferma (la pagella li conta gia'), un
   giro per-trade stile R16 e' giustificato DA DATI NUOVI, non da
   ripescaggio.
3. I due spegnimenti H1 liberano rischio senza perdere nulla di
   misurato: le loro celle vive erano rosse in campione.

## Esecuzione (dopo il via di Claudio)
Spegnere 4 grafici sul vecchio MT5: SupRev_DAX_H1, SupRev_DOW_H1 (SOLO
quando flat!), Nasdaq_Apertura_Ott, DAX_Apertura_EU_Ott. Basta chiudere
i 4 grafici + Salva profilo. Il SupRev_DOW_H1 ha la posizione STREV DOW
aperta (magic 970916): aspettare che chiuda da sola, poi spegnere.

_CSV in `risultati_prove/<EA>/` (11 celle x IS/OOS, ohlc+tick). Stato
coda in `report/STATO_CODA_FUORILISTA.md`._

---

## ✅ DECISIONE DI CLAUDIO (11/08 sera): "VAI CON LO SPEGNIMENTO"
Approvata la proposta integrale: spenti subito SupRev_DAX_H1_Ott,
Nasdaq_Apertura_US_Ott e DAX_Apertura_EU_Ott (chiusura manuale dei 3
grafici + salva profilo, verifica dai .chr); **SupRev_DOW_H1_Ott in
coda di spegnimento: SOLO quando la posizione aperta (970916) si
chiude da sola** — promemoria attivo alle pagelle. Restano in forward
con referto: SupRev_DAX_H4, SupRev_DOW_H4 (osservato speciale),
STREV oro H4, Nasdaq Apertura base.

## ✅ SPEGNIMENTO ESEGUITO (11/08 19:41, verificato dal Journal del riavvio)
20 EA caricati su 20 attesi: squadra (8) + TradeExporter + MAXMIN ORO +
vivaio R23 (5, con PERIOD_H2 giusto sui SuperWave) + 4 osservati +
SupRev_DOW_H1 (vivo fino al flat). I 3 bocciati NON sono partiti.
Guardie reload-safe OK ("oggi ho gia' operato: non riarmo").

⚠️ SCOPERTA DAL LOG (dossier per domani): il Nasdaq Apertura BASE vivo
gira con motore=BREAKOUT + rangemode=RANGE_PREVBAR + rischio 0,25% +
long/short — NON la config misurata in R24 (volumi 1,5 AND). Nota bene:
PREVBAR e' il RangeMode del vizio storico (cella cherry-picked che si
ribalto'). A 0,25% il rischio e' minimo, ma la regola vale: o si
allinea il grafico a una config misurata, o si misura la config accesa.
Decisione per domani, non stasera a mercati aperti.
