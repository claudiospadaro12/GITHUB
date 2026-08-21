#!/usr/bin/env python3
"""
Converte il calendario Forex Factory (dataset spoluan/forex-factory-scraper, 2010-2023)
nel formato letto da ABTG_FiboH4_Multi.mq5 -> LoadNews():

    Data Ora;Impatto;Valuta;Titolo
    2012.01.06 13:30;High;USD;Non-Farm Employment Change

NOTE DI FUSO (misurate, non assunte):
- il dataset sorgente ha i timestamp in UTC+8 FISSO e segue correttamente la DST
  americana (NFP verificato su 2012/2015/2019/2023: 21:30 d'inverno, 20:30 d'estate).
- qui si sottraggono 8 ore -> il file prodotto e' in UTC ESATTO.
- la conversione UTC -> ora server BCM NON viene fatta qui: l'offset del broker
  (e se osserva la DST) va MISURATO sul terminale. Poi o si rigenera con --shift-min
  oppure si usa l'input InpNewsShiftMinutes dell'EA.
  ATTENZIONE: InpNewsShiftMinutes e' uno shift FISSO: se il server osserva la DST
  un solo valore sbaglia di un'ora per meta' anno -> meglio rigenerare il file.
"""
import argparse, csv, datetime as dt, glob, os, sys

SALTA_ORARI = {"All Day", "Tentative", "", "Day 1", "Day 2"}

def main():
    p = argparse.ArgumentParser()
    p.add_argument("--src", required=True, help="cartella coi forex_factory_calendar_YYYY.csv")
    p.add_argument("--out", required=True)
    p.add_argument("--impatti", default="High", help="lista separata da virgola, es. High,Medium")
    p.add_argument("--valute", default="USD,EUR,GBP,JPY")
    p.add_argument("--shift-min", type=int, default=0, help="minuti da aggiungere DOPO la conversione in UTC")
    a = p.parse_args()

    imp = {x.strip() for x in a.impatti.split(",") if x.strip()}
    val = {x.strip() for x in a.valute.split(",") if x.strip()}
    righe = []
    for f in sorted(glob.glob(os.path.join(a.src, "forex_factory_calendar_*.csv"))):
        with open(f, encoding="utf-8", errors="replace") as fh:
            for r in csv.DictReader(fh):
                if r.get("Time", "").strip() in SALTA_ORARI:
                    continue
                if r.get("Impact", "").strip() not in imp:
                    continue
                ccy = r.get("Currency", "").strip()
                if ccy not in val:
                    continue
                try:
                    t = dt.datetime.strptime(r["Combined DateTime"], "%Y-%m-%d %H:%M:%S")
                except (KeyError, ValueError):
                    continue
                t = t - dt.timedelta(hours=8) + dt.timedelta(minutes=a.shift_min)
                titolo = r.get("Event", "").replace(";", ",").strip()
                righe.append((t, r["Impact"].strip(), ccy, titolo))

    righe.sort(key=lambda x: x[0])
    with open(a.out, "w", encoding="ascii", errors="replace", newline="") as fh:
        fh.write("Data Ora;Impatto;Valuta;Titolo\n")
        for t, i, c, tt in righe:
            fh.write("%s;%s;%s;%s\n" % (t.strftime("%Y.%m.%d %H:%M"), i, c, tt))
    print("scritte %d righe in %s" % (len(righe), a.out))
    if righe:
        print("copertura: %s -> %s" % (righe[0][0], righe[-1][0]))

if __name__ == "__main__":
    sys.exit(main())
