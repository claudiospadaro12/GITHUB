#!/usr/bin/env python3
# =====================================================================
#  sonda_spec_a2_post.py -- RICALCOLO A POSTERIORI (24/10/2026, DOPO aver visto i numeri) della soglia del pavimento del lotto.
#  PERCHE': il criterio A2 congelato (report/SONDA_SPECIFICHE_CRITERI_2026-10-24.md) aveva DUE errori, scoperti leggendo il CSV:
#   1) la frase era al contrario: lotto_calcolato = rischio / (stop * vpp); il pavimento MORDE quando lo stop e' SOPRA la soglia (lotto calcolato < minimo), non sotto;
#   2) per gli indici il server riporta tick_value NELLA VALUTA DEL SIMBOLO (USD, EUR, JPY), non in EUR (conto in EUR): serve convertire.
#  Conversioni ricavate dalle stesse specifiche (stesso CSV): 1 USD = tick_value(XAUUSD)/(tick_size*contract_size) EUR; 1 JPY = tick_value(EURJPY)/(tick_size*contract_size) EUR.
#  Unita': "punti indice" = 1,00 di prezzo (come nel resto dei report), NON i point di MT5 (0,01).
#  USO: python3 backtest_pipeline/sonda_spec_a2_post.py <ABTG_SONDA_SPEC.csv>
# =====================================================================
import csv, sys
SALDI = (5344.0, 5000.0); RISCHI = (1.0, 0.65, 0.5, 0.3, 0.25)
def main(p):
    b = open(p, 'rb').read(); t = b.decode('utf-16') if b[:2] in (b'\xff\xfe', b'\xfe\xff') else b.decode('utf-8-sig', 'replace')
    S = {r['simbolo']: r for r in csv.DictReader(t.splitlines(), delimiter=';')}
    fl = lambda s, k: float(S[s][k])
    usd = fl('XAUUSD', 'tick_value') / (fl('XAUUSD', 'tick_size') * fl('XAUUSD', 'contract_size'))
    jpy = fl('EURJPY', 'tick_value') / (fl('EURJPY', 'tick_size') * fl('EURJPY', 'contract_size'))
    print('1 USD = %.4f EUR (da XAUUSD); 1 JPY = %.6f EUR (da EURJPY)' % (usd, jpy))
    for s in ('U30USD', 'NASUSD', 'D30EUR', '225JPY'):
        cur = S[s]['valuta_profitto']; conv = {'USD': usd, 'JPY': jpy, 'EUR': 1.0}[cur]
        vpp_idx = fl(s, 'tick_value') / fl(s, 'tick_size') * conv   # EUR per 1,00 di prezzo per lotto
        vmin = fl(s, 'vol_min'); stp = fl(s, 'vol_step')
        sg = ' | '.join('S=%.0f ' % sa + ' '.join('R%.2f%%=%.0f' % (ri, sa * ri / 100 / (vmin * vpp_idx)) for ri in RISCHI) for sa in SALDI)
        print('%s (%s): vol_min %g step %g, %.5f EUR per punto indice per lotto (%.5f al lotto minimo) | il pavimento MORDE con stop SOPRA (punti indice): %s' % (s, cur, vmin, stp, vpp_idx, vmin * vpp_idx, sg))
main(sys.argv[1])
