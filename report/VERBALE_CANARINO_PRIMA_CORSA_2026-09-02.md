# 🐤 VERBALE — PRIMA CORSA DEL CANARINO SUL 100K (02/09/2026, 08:56 locale / 07:56 server)

**Esito: VERDE PIENO.** Zip agli atti: `CANARINO_20260902.zip`
(referto `ABTG_Canarino_50504263_20260902_075638_srv.txt`, 116 righe).

## I fatti misurati (dal referto, non dal ricordo)
- **Conto giusto**: login 50504263, BCMMarkets-Server, EUR, hedging.
- **AUTOTEST 8/8 PASS** (nomi GV, confronto hardcoded/artefatto 0 differenze,
  nucleo pausa B1, nucleo cap C1 + fail-open, battito, decisione completa,
  frasi C5/C7 dell'include, aritmetica percentuali).
- **RIEPILOGO: nessun rilievo** — grezzo e ricalcolato coincidono su tutte e
  tre le bandiere; `ABTG_CanaleEsiste() = SI`.
- **Ora di reset DEDOTTA = 23** (giorno prop, firma 18/08): la chiave scritta
  dal Guardian (2026243) combacia con quella calcolata a reset 23, NON con
  quella a reset 0. Il giorno prop e' configurato come firmato.
- **GV del canale tutte vive e appena battute**: DAYKEY/DAYSTART/START/PEAK
  presenti; FAILED assente (= mai fallita); battito del Guardian fresco
  (07:56:37 srv, entro la tolleranza 120 s). PEAK=101154.61, DAYSTART=100635.69.
- **Pendenti sul conto in quel momento: 0** → rischio pendente non visto dal
  cap: 0,00% (fotografia; il buco B6 resta e si rimisura con sedie in campo).
- Riga [GUARDIAN] viva subito dopo la corsa: eq=100635.69, dayLoss=0.00%,
  totDD=-0.64%, stato=OK, pausa=off, cap=off.
- L'include `ABTG_PausaGuardian.mqh` era GIA' presente sul terminale 100k
  (il canarino ha compilato contro la copia di campo — meglio cosi').

## Cosa sblocca nel collaudo Fase 1
- Lo strumento P-C1 e' COLLAUDATO IN CAMPO: i criteri 5/7/8 ora hanno il loro
  metro deterministico. Prossime tappe: sessione cap/fail-open (45 min) e
  sessione pausa/gestione (40 min), MAI nello stesso giorno, come da
  `COLLAUDO_ENFORCEMENT_FASE1_2026-09-02.md`.
- Limite invariato e dichiarato: il canarino prova canale+include, non che i
  5 binari chiamino la guardia — quella prova resta la riga [GUARDIA] di un
  EA vero durante le sessioni.
