from reportlab.lib.pagesizes import A4
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, KeepTogether
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib import colors
from reportlab.lib.units import mm
import sys
out = sys.argv[1] if len(sys.argv) > 1 else 'RIASSUNTO_TEST_PER_MASSIMO_2026-10-28.pdf'
ss = getSampleStyleSheet()
TT = ParagraphStyle('TT', parent=ss['Title'], fontSize=17, spaceAfter=4)
H1 = ParagraphStyle('H1', parent=ss['Heading1'], keepWithNext=1, fontSize=12.5, spaceBefore=10, spaceAfter=4, textColor=colors.HexColor('#1f3a64'))
B = ParagraphStyle('B', parent=ss['BodyText'], fontSize=9.2, leading=12.4, spaceAfter=3)
C = ParagraphStyle('C', parent=B, fontSize=8.1, leading=10.2, spaceAfter=0)
BX = ParagraphStyle('BX', parent=B, backColor=colors.HexColor('#fff6e0'), borderPadding=4, borderColor=colors.HexColor('#e0b050'), borderWidth=0.5, spaceBefore=4, spaceAfter=6)
def P(t, st=B): return Paragraph(t, st)
def T(rows, w):
    t = Table([[P(str(c), C) for c in r] for r in rows], colWidths=[x * mm for x in w], repeatRows=1)
    t.setStyle(TableStyle([('GRID', (0, 0), (-1, -1), 0.3, colors.grey), ('VALIGN', (0, 0), (-1, -1), 'TOP'), ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#e8eef7')), ('LEFTPADDING', (0, 0), (-1, -1), 3), ('RIGHTPADDING', (0, 0), (-1, -1), 3), ('TOPPADDING', (0, 0), (-1, -1), 2), ('BOTTOMPADDING', (0, 0), (-1, -1), 2)]))
    return t
def foot(c, d):
    c.saveState(); c.setFont('Helvetica', 7); c.setFillColor(colors.grey)
    c.drawString(15 * mm, 8 * mm, 'Riassunto dei test - EA oro per prop FTMO - aggiornato 29/10/2026 (equity 2018 e 2020)'); c.drawRightString(195 * mm, 8 * mm, 'pagina %d' % d.page); c.restoreState()

doc = SimpleDocTemplate(out, pagesize=A4, leftMargin=15 * mm, rightMargin=15 * mm, topMargin=14 * mm, bottomMargin=14 * mm, title='Riassunto dei test - EA oro per prop FTMO', author='Claudio Spadaro')
E = []
E.append(P('Riassunto dei test sugli EA oro per una prop FTMO', TT))
E.append(P('Preparato il 28/10/2026 e aggiornato il 29/10/2026 (test MaxAllowedDD del Reaper, equity del portafoglio 2018 e 2020) per Massimo e per il suo Claude. Tutti i numeri sono del Strategy Tester MetaTrader 5 (server BCM, conto virtuale da 80.000 EUR, XAUUSD salvo dove indicato), un EA alla volta; Modello 1 = barre da 1 minuto, Modello 4 = tick reali. Criteri e previsioni sono stati scritti prima dei numeri e sono nel repo (cartella report/). Nessuna slippage, filtro news non simulato, un solo percorso storico per anno. Questo documento non dà giudizi su acquisti, lotti o taglie.', B))

E.append(P('In breve', H1))
E.append(P('<b>Tre dei quattro EA del pacchetto di Wim superano il nostro criterio sui tre anni vecchi</b> (Gold Reaper, Goldbot One, The Gold Phantom con il set PROPFIRM); il Gold Trade Pro lo manca per il solo drawdown del 2020. <b>Il Reaper è l\'unico veloce</b>: gli altri sono molto più lenti. Sommati nello stesso conto, i risultati sono molto correlati (0,5-0,63): <b>Reaper + Goldbot One resta dentro i limiti FTMO in tutti e quattro gli anni testati</b>; con il Phantom il giorno peggiore sfiora o supera il 5% (2013 -5,79%, 2018 -4,84%); con quattro EA ci sono giorni oltre il 5% in 2013, 2018 e 2025 e nel 2013 la perdita dal deposito arriva al 13,7%. <b>Provando MaxAllowedDD 6, 9, 12 e 15 sul Reaper, il 9 resta il valore più alto sotto gli 8.000 EUR di DD in tutti e tre gli anni</b>; il 12 e il 15 sforano e non accorciano in proporzione i tempi. Sulla leva 1:9 che FTMO indica per i metalli sul conto Swing, il margine del Reaper supera già il conto: il tester non lo simula.', BX))

E.append(P('Il criterio usato (PROP-ANNI)', H1))
E.append(P('Corse a 80.000 EUR sul 2013 (ribasso), 2018 (laterale) e 2020 (rialzo) a Modello 1, più una calibrazione sul 2025. Si passa se: netto positivo in tutti e tre gli anni; drawdown di equity massimo 8.000 EUR; nessuno stop out; nessun giorno con perdita realizzata pari o superiore al 5%; calibrazione OK (rapporto Modello 1 / tick reali fra 0,5 e 2,0 e correlazione mensile almeno 0,5). Il tetto di 8.000 EUR è più stretto del 10% di FTMO. Gli anni 2013, 2018 e 2020 sono probabilmente dentro la finestra di ottimizzazione del venditore (non verificato).', B))

E.append(P('Esito per EA', H1))
E.append(T([['EA (set provato)', 'Risultato sui tre anni vecchi (2013 / 2018 / 2020)', 'DD equity max', 'Esito'],
['<b>Gold Reaper</b> (MaxAllowedDD 9, limite giornaliero 4%)', '+21.757 / +13.535 / +20.388 EUR', '5.621 (2013)', '<b>PROP-ANNI sì</b>; 21 mesi a tick reali +59.796 (PF 2,89, DD equity 3.854)'],
['<b>Goldbot One</b> (D1, step 6000)', '+10.196 / +2.356 / +9.658 EUR (+12,7% / +2,9% / +12,1%)', '2.853 (2018)', '<b>PROP-ANNI sì</b>; molto piatto, rende poco'],
['<b>The Gold Phantom</b> (PROPFIRM D9)', '+9.137 / +4.859 / +9.540 EUR (+11,4% / +6,1% / +11,9%)', '2.992 (2013)', '<b>PROP-ANNI sì</b>; 21 mesi +21.136 con DD 1.950; MEDIUM e HIGHRISK no'],
['<b>Gold Trade Pro</b> (PROPFIRM R1)', '+32.907 / +18.666 / +14.585 EUR', '<b>10.278 (2020)</b>', 'NON passa solo per il DD 2020; 21 mesi +38.029 con DD 5.588; set più alti no'],
['Daytrade Pro (PROPFIRM R27, 13 coppie, D1)', '+9.044 / +9.559 / +16.884 EUR', '5.282', 'Tre anni sì, ma il 2025 fa +0,9% (PF 1,04); la corsa a tick reali è in timeout: calibrazione non misurata'],
['Stability Pro (griglia forex)', '+52.400 / +16.137 / +28.740 EUR (default)', '16.457 (2013)', 'NON passa; DD equity 3-6,6 volte quello di saldo; i livelli di LotsizeStep non cambiano il lotto: non dimensionabile'],
['DAX Morning Scalp (5 set, 21 mesi)', 'DEFAULT -22.670 (-28,3%); gli altri set poche operazioni', '24.075 (DEFAULT)', 'Nessun set passa']], [45, 52, 25, 58]))
E.append(P('Calibrazione 2025 (Modello 1 contro tick reali): OK per Reaper, Goldbot One (rapporto 1,08), Gold Trade Pro (1,01-1,04), Phantom PROPFIRM (1,03) e Stability (1,15).', B))

E.append(P('Gold Reaper: cosa abbiamo misurato', H1))
for t in [
'<b>Equity da barre M1</b> (21 mesi e 2013): nei 21 mesi nessun giorno oltre il 3%, peggior giorno -2,32% (stima centrale) e -2,45% (pessimistica); nel 2013 un solo giorno a -4,57% (23/01/2013), sotto il 5% di FTMO.',
'<b>Limite giornaliero interno (4%) spento</b>: in 21 mesi, 2018 e 2020 le operazioni sono identiche (il limite non è mai intervenuto); nel 2013 interviene una volta (23/01/2013): netto +18.592 contro +21.757, DD equity 8.039 contro 5.621, giorno -5,4% realizzato e -7,25% sull\'equity. Senza limite il 2013 non passerebbe.',
'<b>MaxAllowedDD=0</b>: il lotto cade a 0,01 su tutte le 791 operazioni (stesse operazioni, +3.620 in 21 mesi). Non è un test di "protezioni spente a dimensione normale": MaxAllowedDD comanda anche il lotto.',
'<b>Margine sulle leve FTMO</b> (stima dai deal): massimo nei 21 mesi 2,0 lotti a 4.449 (19/08/2026), nozionale circa 890.000 USD; a leva 1:100 e 1:30 il margine tiene, a 1:9 (metalli, conto Swing) arriva a circa 99.000 USD contro 80.000 di conto. Nel 2013 con 9,43 lotti: circa 178.000 USD a 1:9.']:
    E.append(P('- ' + t, B))

E.append(P('Tempi per una challenge da 80.000 (+8.000 poi +4.000), da conto nuovo, giorni di calendario', H1))
E.append(T([['Set', '2013', '2018', '2020', '21 mesi'],
['Reaper (set prop)', '120 / 91', '236 / 176', '51 / 48', '112 / 92'],
['Gold Trade Pro PROPFIRM', '99 / 89', '176 / 100', '308 / 188', '201 / 133'],
['Phantom PROPFIRM', '189 / 113', '+8.000 non raggiunto / 227', '328 / 53', '244 / 120']], [50, 28, 42, 28, 32]))
E.append(P('Prima cifra: giorni per +8.000; seconda: giorni per +4.000 sullo stesso conto nuovo. Stima centrale per il Reaper da solo: circa 6-7 mesi per chiudere le due fasi; nell\'anno laterale 2018 circa 12.', B))

E.append(P('Reaper con MaxAllowedDD diversi (29/10/2026, 18 passate, limite giornaliero 4% acceso)', H1))
E.append(T([['MaxAllowedDD', 'DD equity 2013 / 2018 / 2020 / 2025 (EUR)', 'Netto 2013 / 2018 / 2020 (EUR)', 'Lotto medio (2013)', 'Esito sui tre anni'],
['6', '4.831 / 3.584 / 2.402 / 1.814', '+12.704 / +8.952 / +13.132', '0,28', 'passa (calibrazione a tick reali non misurata)'],
['<b>9</b> (set prop)', '5.621 / 5.504 / 3.839 / 3.077', '+21.757 / +13.535 / +20.388', '0,44', '<b>passa</b>'],
['12', '<b>8.728 / 8.438</b> / 5.496 / 4.559', '+32.047 / +12.481 / +28.152', '0,63', 'NON passa (2013 e 2018 di poco sopra 8.000)'],
['15', '<b>11.622 / 9.928</b> / 7.391 / 5.491', '+38.600 / +13.104 / +36.414', '0,81', 'NON passa (anche un giorno a -6,1% nel 2013)']], [24, 50, 44, 22, 40]))
E.append(P('Il lotto scala quasi in proporzione a MaxAllowedDD (x0,62 a 6, x1,4 a 12, x1,8 a 15 rispetto al 9), ma il netto si ferma: nel 2018 il 15 rende meno del 9 (+13.104 contro +13.535) e nel 2025 il 15 rende meno del 12. A tick reali sui 21 mesi: 9 +59.796 (DD 3.854), 12 +89.611 (DD 6.074), 15 +102.211 (DD 7.968, un giorno a -4,0%). Giorni da conto nuovo per +8.000 nel 2025: 139 (6), 110 (9), 105 (12), 133 (15): i lotti più grandi non accorciano in proporzione la challenge. Il controllo a 9 ha riprodotto i risultati del 26/10. Il 2018 a 15 è limitato anche dal margine del tester (484 ordini rifiutati): non si separa dal limite giornaliero.', B))
E.append(P('Più EA nello stesso conto: somma delle corse indipendenti', H1))
E.append(P('Il tester non esegue più EA insieme: abbiamo sommato le liste affari delle corse già fatte (ogni EA dimensiona sul proprio saldo da 80.000; limiti giornalieri interni, margine e interazioni non simulati). Equity ricostruita da barre M1 esportate per tutti e quattro gli anni (2013, 2018, 2020, 2025).', B))
rows=[['Anno', 'Combinazione', 'Netto', 'Perdita max dal deposito', 'Peggior giorno'],
['2013', 'Reaper', '+24.000 (+30%)', '4,4%', '-4,57%'],
['2013', 'Reaper + Goldbot', '+35.304', '5,7%', '-4,72%'],
['2013', '+ Phantom', '+45.627', '<b>8,4%</b>', '<b>-5,79%</b> (oltre il 5% FTMO)'],
['2013', 'tutti e 4 (+ Gold Trade Pro)', '+81.943', '<b>13,7%</b> (oltre il 10% FTMO)', '<b>-10,6%</b>'],
['2018', 'Reaper', '+13.524 (+17%)', '2,4%', '-2,86%'],
['2018', 'Reaper + Goldbot', '+15.880', '3,3%', '-3,79%'],
['2018', '+ Phantom', '+20.739', '4,5%', '<b>-4,84%</b> (pessimistica -4,99%)'],
['2018', 'tutti e 4', '+39.405 (+49%)', '6,7%', '<b>-8,17%</b>'],
['2020', 'Reaper', '+21.235 (+27%)', 'mai sotto il deposito', '-1,98%'],
['2020', 'Reaper + Goldbot', '+30.893', 'mai sotto il deposito', '-1,88%'],
['2020', '+ Phantom', '+40.991', 'mai sotto il deposito', '-2,37%'],
['2020', 'tutti e 4', '+56.407 (+71%)', '0,2%', '-3,77%'],
['2025', 'Reaper', '+27.460 (+34%)', '2,8%', '-2,32%'],
['2025', 'Reaper + Goldbot', '+35.303', '3,0%', '-2,57%'],
['2025', '+ Phantom', '+48.393', '3,0%', '-2,94%'],
['2025', 'tutti e 4', '+67.762', '6,0%', '<b>-6,32%</b>']]
E.append(T(rows, [15, 55, 35, 40, 35]))
E.append(P('Correlazione dei risultati giornalieri (21 mesi, set prop): Reaper/Gold Trade Pro 0,63; Reaper/Phantom 0,55; Gold Trade Pro/Phantom 0,50; Reaper/Goldbot One 0,49-0,53. <b>Reaper + Goldbot One</b> resta dentro i limiti FTMO in tutti e quattro gli anni; con il Phantom il giorno peggiore sfiora o supera il 5% nel 2013 e nel 2018; con tutti e quattro ci sono giorni oltre il 5% in 2013, 2018 e 2025 (il 2020 regge). Solo realizzato, i quattro insieme arrivano a +8.000 molto prima (2018: 134 giorni contro 236 del Reaper), ma il peggior giorno realizzato va a -6,3% nel 2018 e -10,0% nel 2013. Margine a leva 1:9 sull\'oro (derivato): supera gli 80.000 USD già col Reaper da solo nel 2013 e nel 2018.', B))

E.append(P('Cosa abbiamo imparato sulle regole FTMO (risposte scritte del supporto, 24-29/09/2026)', H1))
for t in [
'Hedging nello stesso conto: permesso. Posizioni <b>opposte tra conti diversi</b> (anche demo, altro broker, strumenti correlati, anche per errore): vietate, con possibile chiusura del conto e senza soglia di tolleranza.',
'Copiare la stessa strategia nello stesso verso su più conti propri è permesso, con il tetto di 400.000 USD per trader o per strategia. Con EA di terzi FTMO avverte del rischio che altri trader usino lo stesso EA: se conti anche gli altri utenti, da chiedere per iscritto.',
'Leva: Standard 1:100; Swing 1:30 (forex) e 1:9 (metalli). Orologio: dal 25/10/2026 il server BCM coincide con l\'ora italiana; l\'orologio del server FTMO dopo quella data NON è misurato.']:
    E.append(P('- ' + t, B))

E.append(P('In corso e da fare', H1))
E.append(T([['Cosa', 'Stato'],
['Stability Pro con un input che davvero comandi il lotto', 'Aperto: non sappiamo quale input comanda il lotto; mancano i set del venditore.'],
['Forward su demo di almeno 4 settimane e scelta Standard o Swing', 'Non iniziato; decisione di Claudio.'],
['Mail a FTMO su più conti con lo stesso EA e posizioni opposte tra conti', 'Da inviare per iscritto prima di qualsiasi uso su più conti.']], [80, 100]))

E.append(P('Limiti comuni a tutti i test', H1))
E.append(P('Un solo percorso storico per anno; 2013, 2018 e 2020 a Modello 1 e probabilmente già usati dal venditore per ottimizzare; nessuna slippage; filtro news e orologio AutoGMT non verificati su BCM; il tester ignora la leva (il margine con le leve FTMO non è simulato); la somma di corse indipendenti non è un portafoglio vero (si misura solo in forward). Dove un dato è derivato o stimato lo diciamo nel testo. Report, script e dati: repo claudiospadaro12/GITHUB, branch lavoro, cartelle report/ e backtest_pipeline/.', B))
doc.build(E, onFirstPage=foot, onLaterPages=foot)
print('ok', out)
