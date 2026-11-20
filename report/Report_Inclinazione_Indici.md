# Report inclinazione bande (IN-BULGE / POST-BULGE), 20/11/2026

Metodo, criteri e risultati completi: `report/BANDSLOPE_CRITERI_2026-11-20.md`. Script: `backtest_runner/simulatore/BandSlope_Analyzer.py`.

## 1. Tabella comparativa
Nessuna combinazione (simbolo + TF + periodo BB + soglia di pendenza) tiene in OOS: **0 celle su 25 con R netto OOS > 0** scegliendo il filtro sul primo 70% dei dati. Senza filtro il R netto OOS e' negativo in 201/224 configurazioni. Per cella, il filtro scelto in-sample peggiora o resta negativo fuori campione (dettaglio nel file criteri). Combinazioni che "tolgono l'80% dei NO" tolgono anche circa tutti i SI (SI mantenuti 0-8%).

## 2. Settaggio ottimale
**Non esiste un settaggio universale che regga.** Il piu' alto in IS sul gruppo Nasdaq/S&P/Oro/EURUSD (periodo 20, dev 1,5, pendenza nel verso del trade >= 0,5 ATR su 6 barre, espansione >= 1,25 x media 50) ha R IS -0,35 e OOS -0,34. I segnali Bulge sono quasi sempre contro la pendenza della banda: ABS e AGAINST coincidono, WITH e' raro.

## 3. Codice del filtro (strumento visivo, non miglioramento dimostrato)
Pine v5, da incollare nell'indicatore `IN-BULGE + POST-BULGE [Claudio]` dopo il calcolo di `basis`, `atr`, `bbWidth`, `bbWidthMA`:
```pine
slopeN   = input.int(6,     "Pendenza: barre N",           group="Filtro inclinazione")
slopeMin = input.float(0.5, "Pendenza minima (ATR)", step=0.05, group="Filtro inclinazione")
expMin   = input.float(1.1, "Espansione minima x media", step=0.05, group="Filtro inclinazione")
slopeATR = (basis - basis[slopeN]) / atr
expansion = bbWidth / bbWidthMA
isBandInclined = math.abs(slopeATR) >= slopeMin and expansion >= expMin
longSignalF  = longSignal  and isBandInclined
shortSignalF = shortSignal and isBandInclined
```
MQL5 (funzione, `h` = handle ATR, `ma` = SMA, valori a barra chiusa i=1):
```mql5
bool IsBandInclined(double basis1, double basisN, double atr1, double width1, double widthMA1,
                    double slopeMin=0.5, double expMin=1.1)
  {
   if(atr1<=0 || widthMA1<=0) return(false);
   double slopeATR=(basis1-basisN)/atr1;      // basisN = SMA(N barre prima), N=6
   double expansion=width1/widthMA1;           // widthMA1 = media dell'ampiezza su 50 barre
   return(MathAbs(slopeATR)>=slopeMin && expansion>=expMin);
  }
```
