# PTE (H4) sul periodo mai toccato 2025-01-01 -> 2026-11-19: criteri PRIMA dei numeri (20/11/2026)

**Perche':** nel test 2013-2024 (`PTE_WOL_FOREX_CRITERI_2026-11-20.md`) PTE e' stato perdente in 2013-2020 (PF 0,76) e positivo in 2021-2024 (PF 1,31): l'ipotesi, nata DOPO i numeri, e' che dal 2021 il regime di mercato favorisca la strategia. Il 2025-26 non e' mai stato usato: e' l'unico controllo pulito e si fa **una sola volta**.
**Prova:** `ABTG_PTE` H4 invariato (stesso sorgente e stessi default del test precedente, `InpVerbose=false`), 28 cross forex, 2025-01-01 -> 2026-11-19, BCM portabile, Modello 1. Stesso metodo di analisi: serie giornaliere dei 28 cross sommate, R = rendimento / 1%.
## Previsioni
- PF pooled > 1,2: **35%**; PF tra 0,95 e 1,2: **30%**; PF < 0,95: **35%**.
- Operazioni (giorni con uscite) pooled: 150-350: **70%**.
## Regole di esito (fissate ora)
- **Ipotesi CONFERMATA** solo se PF pooled > 1,2 **e** IC90 inferiore del R medio > 0 **e** almeno 15 cross su 28 con PF > 1.
- **NON CONFERMATA** se PF pooled <= 1,0. Tra 1,0 e 1,2 oppure IC90 che include 0: **INCONCLUSIVA** (non si dichiara conferma).
- Anche se confermata: PTE resta **non candidato** (IS 2013-2020 PF 0,76, 4 anni su 12 positivi); si aprirebbe una scheda nuova "PTE dal 2021" con criteri nuovi, **non** si usa il 2025-26 per scegliere altro. Il periodo e' esaurito dopo questa passata (resta un solo uso). Nessun consiglio di taglie.
