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
    c.drawString(15 * mm, 8 * mm, 'Riassunto dei test - EA oro per prop FTMO - 28/10/2026'); c.drawRightString(195 * mm, 8 * mm, 'pagina %d' % d.page); c.restoreState()

doc = SimpleDocTemplate(out, pagesize=A4, leftMargin=15 * mm, rightMargin=15 * mm, topMargin=14 * mm, bottomMargin=14 * mm, title='Riassunto dei test - EA oro per prop FTMO', author='Claudio Spadaro')
E = []
E.append(P('Riassunto dei test sugli EA oro per una prop FTMO', TT))
E.append(P('Preparato il 28/10/2026 per Massimo e per il suo Claude. Tutti i numeri sono del Strategy Tester MetaTrader 5 (server BCM, conto virtuale da 80.000 EUR, XAUUSD salvo dove indicato), un EA alla volta; Modello 1 = barre da 1 minuto, Modello 4 = tick reali. Criteri e previsioni sono stati scritti prima dei numeri e sono nel repo (cartella report/). Nessuna slippage, filtro news non simulato, un solo percorso storico per anno. Questo documento non dà giudizi su acquisti, lotti o taglie.', B))

E.append(P('In breve', H1))
E.append(P('<b>Tre dei quattro EA del pacchetto di Wim superano il nostro criterio sui tre anni vecchi</b> (Gold Reaper, Goldbot One, The Gold Phantom con il set PROPFIRM); il Gold Trade Pro lo manca per il solo drawdown del 2020. <b>Il Reaper è l\'unico veloce</b>: gli altri sono molto più lenti. Sommati nello stesso conto, i risultati sono molto correlati (0,5-0,63) e già con tre EA nel 2013 si rompe il limite giornaliero del 5%; con quattro EA nel 2013 la perdita dal deposito arriva al 13,7%. Sulla leva 1:9 che FTMO indica per i metalli sul conto Swing, il margine del Reaper supera già il conto: il tester non lo simula.', BX))

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

E.append(P('Più EA nello stesso conto: somma delle corse indipendenti', H1))
E.append(P('Il tester non esegue più EA insieme: abbiamo sommato le liste affari delle corse già fatte (ogni EA dimensiona sul proprio saldo da 80.000; limiti giornalieri interni, margine e interazioni non simulati). Equity dalle barre M1 (esportate solo per 2013 e 2025).', B))
E.append(T([['Anno', 'Combinazione', 'Netto', 'Perdita max dal deposito', 'Peggior giorno'],
['2013', 'Reaper', '+24.000 (+30%)', '4,4%', '-4,57%'],
['2013', 'Reaper + Goldbot', '+35.304', '5,7%', '-4,72%'],
['2013', '+ Phantom', '+45.627', '<b>8,4%</b>', '<b>-5,79%</b> (oltre il 5% FTMO)'],
['2013', 'tutti e 4 (+ Gold Trade Pro)', '+81.943', '<b>13,7%</b> (oltre il 10% FTMO)', '<b>-10,6%</b>'],
['2025', 'Reaper', '+27.460 (+34%)', '2,8%', '-2,32%'],
['2025', 'Reaper + Goldbot', '+35.303', '3,0%', '-2,57%'],
['2025', '+ Phantom', '+48.393', '3,0%', '-2,94%'],
['2025', 'tutti e 4', '+67.762', '6,0%', '<b>-6,32%</b>']], [15, 55, 35, 40, 35]))
E.append(P('Correlazione dei risultati giornalieri (21 mesi, set prop): Reaper/Gold Trade Pro 0,63; Reaper/Phantom 0,55; Gold Trade Pro/Phantom 0,50; Reaper/Goldbot One 0,49-0,53. Per il 2018 e il 2020 l\'equity non è ancora ricostruibile (barre M1 non esportate): la riga di export è pronta. Solo realizzato, i quattro insieme arrivano a +8.000 molto prima (2018: 134 giorni contro 236 del Reaper), ma il peggior giorno realizzato va a -6,3% nel 2018 e -10,0% nel 2013.', B))

E.append(P('Cosa abbiamo imparato sulle regole FTMO (risposte scritte del supporto, 24-29/09/2026)', H1))
for t in [
'Hedging nello stesso conto: permesso. Posizioni <b>opposte tra conti diversi</b> (anche demo, altro broker, strumenti correlati, anche per errore): vietate, con possibile chiusura del conto e senza soglia di tolleranza.',
'Copiare la stessa strategia nello stesso verso su più conti propri è permesso, con il tetto di 400.000 USD per trader o per strategia. Con EA di terzi FTMO avverte del rischio che altri trader usino lo stesso EA: se conti anche gli altri utenti, da chiedere per iscritto.',
'Leva: Standard 1:100; Swing 1:30 (forex) e 1:9 (metalli). Orologio: dal 25/10/2026 il server BCM coincide con l\'ora italiana; l\'orologio del server FTMO dopo quella data NON è misurato.']:
    E.append(P('- ' + t, B))

E.append(P('In corso e da fare', H1))
E.append(T([['Cosa', 'Stato'],
['Reaper con MaxAllowedDD 6 / 9 / 12 / 15 (18 passate, 80.000, limite giornaliero acceso)', 'Lanciata il 28/10, in corso (7-8 ore stimate). Previsioni scritte prima: il lotto cresce quasi in proporzione; a 15 il criterio sui tre anni passa solo con probabilità 20%.'],
['Barre M1 del 2018 e 2020 per completare l\'equity del portafoglio', 'Riga pronta (circa 1-2 minuti di esecuzione), da lanciare sul PC di backtest.'],
['Stability Pro con un input che davvero comandi il lotto', 'Aperto: non sappiamo quale input comanda il lotto; mancano i set del venditore.'],
['Forward su demo di almeno 4 settimane e scelta Standard o Swing', 'Non iniziato; decisione di Claudio.'],
['Mail a FTMO su più conti con lo stesso EA e posizioni opposte tra conti', 'Da inviare per iscritto prima di qualsiasi uso su più conti.']], [80, 100]))

E.append(P('Limiti comuni a tutti i test', H1))
E.append(P('Un solo percorso storico per anno; 2013, 2018 e 2020 a Modello 1 e probabilmente già usati dal venditore per ottimizzare; nessuna slippage; filtro news e orologio AutoGMT non verificati su BCM; il tester ignora la leva (il margine con le leve FTMO non è simulato); la somma di corse indipendenti non è un portafoglio vero (si misura solo in forward). Dove un dato è derivato o stimato lo diciamo nel testo. Report, script e dati: repo claudiospadaro12/GITHUB, branch lavoro, cartelle report/ e backtest_pipeline/.', B))
doc.build(E, onFirstPage=foot, onLaterPages=foot)
print('ok', out)
