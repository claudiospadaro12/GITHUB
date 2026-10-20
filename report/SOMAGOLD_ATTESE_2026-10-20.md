# SomaGold (Andrii Soma, v3.6): prova a 80.000 EUR, previsioni scritte PRIMA dei numeri (20/10/2026)

**Non controllata da agenti.** Claudio ha installato la demo e mandato la pagina del Market (screenshot del manuale). Triage: `MARKET_TRIAGE_AGENTI_RISULTATI_2026-10-20.md` (classe A: signal di 22 settimane, 296 operazioni, PF 1,63, DD balance 17,6% / equity 14,3%, 23 perdite consecutive: dati riletti dal coordinatore sulla pagina del signal).
## Dalla pagina (dichiarazioni del venditore)
XAUUSD, 32 strategie breakout indipendenti (ognuna con proprio magic, timeframe D1/H12/H8/H4, parametri, news e lotto) su un solo grafico; il timeframe del grafico e' irrilevante (l'EA legge internamente i suoi). **Ottimizzato su 2018-2023 e 2020-2025, validato fuori campione 2007-2018**, uscite con SL, TP, break-even, trailing. Lotto: manuale fisso (`StartLots`) oppure automatico per scalino di saldo (`LotSizeStep`), `OnlyUp`, `UseEquity`. Orari della finestra settimanale (apertura lunedi'/chiusura venerdi') in ORA DEL BROKER; offset GMT manuali (`Broker_GMT_OFFSET_Winter/Summer`) o `AutoGMT` (richiede un URL: nel tester non funziona). Prop firm (off di default): `EnablePropFirmCompliance`, `PF_MaxDailyDrawdownPercent`, ecc. Saldo minimo 1.000 USD "per il rischio predefinito".
## Attenzione alla contaminazione dei dati
La finestra di test (01/01/2025-01/10/2026) **per il 2025 sta DENTRO il periodo ottimizzato dal venditore (2020-2025)**: i numeri del 2025 sono in parte in-sample. **Il fuori campione pulito e' solo il 2026 (gennaio-settembre, 9 mesi)**: S-H e tutte le letture di merito si fanno ANCHE sul solo 2026, e quella e' la cifra che conta. Non si ottimizza niente.
## Cosa si fa
Due corse continue 01/01/2025-01/10/2026, XAUUSD H1, 80.000, ticks reali, ExecutionMode 0, **input tutti default del venditore** (nessuno imposto): **T1** offset GMT di default; **T2** offset manuali 1/1 (BCM UTC+1 fisso). Valori di `Risk`, `StartLots`, `MaxLots` e finestra del venditore si leggono dal report (non so cosa sia il default).
## Previsioni dichiarate ORA
- **SG1**: la corsa e' valida (stato OK, nessuno stop-out, input registrati). Fiducia 80%.
- **SG2**: operazioni nei 21 mesi >= 150 (S-N) e PF fra 1,1 e 2,5. Fiducia 60%.
- **SG3**: **il 2026 da solo e' peggiore del 2025** (PF 2026 < PF 2025). Fiducia 60% (il 2025 e' in-sample).
- **SG4**: DD di equity (% degli 80.000 iniziali) <= 10% con i default. Fiducia 50%.
- **SG5**: lotto con i default scala col saldo (rapporto lotto max/min > 3): S-NOSCALA fallisce. Fiducia 55%.
- **SG6**: T1 e T2 differiscono (gli offset contano per finestra settimanale e news): operazioni entro +/-10%, netto che cambia di piu' del 5%. Fiducia 55%.
- **SG7**: durata sotto 30 minuti per corsa. Fiducia 65%.
- **SG8**: correlazione giornaliera dei realizzi con il Gold Reaper >= 0,3 (oro con oro). Fiducia 65%.
Soglie invariate (S-N, S-M, S-H, S-DD, S-NOSCALA, S-COSTO, S-CORR, S-PORT); DD sempre anche come % degli 80.000 iniziali; S-M e S-H anche sul solo 2026.
