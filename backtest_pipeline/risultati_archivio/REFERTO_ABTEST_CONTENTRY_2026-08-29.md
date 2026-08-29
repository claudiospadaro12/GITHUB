# MISURA A/B -- InpContEntryMode: vince il PRIMO TOCCO (mode 0)

_Corsa: 29/08/2026 13:36-13:53, pin `203a519de642e6c91b4f97feae5d573d35c0d106`,
driver `RIGA_ABTEST_CONTENTRY.ps1` (MARCATORE_RIGA_ABTEST_CONTENTRY_v1). Tick
reali (Model 4), deposito 100000, finestra 2020.01.01->2026.06.30, IS
2020.01.01->2022.08.06, OOS 2022.08.07->2026.06.30. Giro a vuoto pulito
(PROBLEMI 0, compilazione 0 errors 0 warnings) prima della corsa. Zip agli
atti: ABTEST_CONTENTRY_20260829_1336.zip._

## COSA MISURAVA
Il timing d'ingresso della CONTINUAZIONE dell'EA ABTG_BreakingBand (v1.05),
spazzando `InpContEntryMode`:
- 0 = PRIMO tocco della banda opposta (comportamento storico 1.03, le sedie vive)
- 1 = RETEST della banda opposta (protocollo scritto Leonardo p.4)
- 2 = IN-BULGE di Claudio (primo tocco opposta + filtro trend mediana + candela
  direzionale + range; scelto il 29/08 come definizione canonica dei suoi Pine
  v1/v3/v10). Nuovi input ai default: TrendSlopeFactor 0.08, TrendSlopeBars 5,
  ContEntryMaxRangeATR 2.0, ContRequireMidFirst false.

## LA TABELLA -- PF OOS (la colonna che decide)

| simbolo | PatternMode | mode 0 | mode 1 | mode 2 |
|---|---|---|---|---|
| GBPUSD | 2 ENTRAMBI | **1.904** (n81) | 1.232 (n41) | 1.495 (n45) |
| EURUSD | 0 SOLO CONTINUAZIONE | **2.944** (n43) | 1.243 (n11) | **0.948** (n8) |
| AUDUSD | 1 SOLO INVERSIONE | 2.106 (n42) | 2.106 (n42) | 2.106 (n42) |

DD OOS sempre basso (1.4-3.5%), mai vicino al muro: nessun rilievo di rischio.
Gemelli IDENTICI in ogni mode (banco sano).

## IL VERDETTO: mode 2 NON batte il primo tocco. Vince mode 0.

Criteri congelati PRIMA dei numeri: mode 2 vince solo se PF_OOS(2) > PF_OOS(0)
E > PF_OOS(1) su >=2 simboli su 3. **Batte mode 0 su ZERO simboli testabili.**

- **EURUSD e' il test decisivo** (SOLO CONTINUAZIONE -> InpContEntryMode tocca
  TUTTI i suoi trade): mode 0 fa PF 2.944 su 43 trade; mode 2 fa 0.948 su 8
  trade, cioe' PERDE. Il filtro trend+candela taglia il campione 43->8 e fra
  quegli 8 toglie i vincenti.
- **GBPUSD**: mode 0 (1.904) batte mode 2 (1.495). Stesso verso.
- **AUDUSD**: tris identico -- CONFERMA DI CORRETTEZZA: e' SOLO INVERSIONE, dove
  la continuazione non esiste, e InpContEntryMode non cambia un centesimo. Prova
  che il codice mode 2 tocca SOLO la continuazione, zero effetti collaterali.

## CONSEGUENZA OPERATIVA: non si cambia niente
- Le sedie vive girano gia' `InpContEntryMode=0`: l'A/B conferma che e' il
  migliore dei tre. Nessun ridispiegamento (G5). Come R91 (InpMinRR resto' 0):
  il default resta, mode 1 e mode 2 restano CODICE OPT-IN MISURATO, non adottato.
- NIENTE grid-search per salvare il mode 2 (Seconda Caccia: sarebbe inseguire
  rumore su campione sottile).

## RISERVE (non ribaltano il verso, ma vanno dette)
- Campione sottile (n_OOS < 150 ovunque): MERITO formalmente sospeso
  (Emendamento B). Ma la direzione e' coerente sui 2 simboli testabili.
- Profondita' tick BCM forex NON misurata in repo (solo U30USD agli atti): a
  Model 4 MT5 ripiega e puo' produrre numeri plausibili-e-falsi. Riserva
  dichiarata dal driver su ogni numero OOS. Non cambia il verso.

## LA LEZIONE
La selettivita' extra (aspetta trend + candela direzionale) che SEMBRA piu'
sicura, in backtest COSTA: il primo tocco raccoglie di piu'. La mano vede un
contesto che il backtest non ha -- quindi non e' "il metodo e' sbagliato", e'
"la versione meccanica a queste soglie non batte il primo tocco su questi due
simboli". Capitolo IN-BULGE chiuso ordinato: la definizione e' agli atti, la
misura pure.
