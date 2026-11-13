#!/usr/bin/env python3
from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.units import mm
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle
OUT='/home/user/GITHUB/report/REAPER_TABELLA_DEFINITIVA_PER_MASSIMO_2026-11-13.pdf'
ss=getSampleStyleSheet()
B=ParagraphStyle('B',parent=ss['Normal'],fontName='Helvetica',fontSize=9.3,leading=12.6)
S=ParagraphStyle('S',parent=B,fontSize=8.2,leading=10.8,textColor=colors.HexColor('#444444'))
H1=ParagraphStyle('H1',parent=ss['Title'],fontName='Helvetica-Bold',fontSize=16.5,leading=20,alignment=0,spaceAfter=2)
H2=ParagraphStyle('H2',parent=B,fontName='Helvetica-Bold',fontSize=11.3,leading=14.5,spaceBefore=8,spaceAfter=3,textColor=colors.HexColor('#1f3a5f'))
BL=ParagraphStyle('BL',parent=B,leftIndent=10)
def P(t,st=B): return Paragraph(t,st)
def cell(t,fs=8.2): return Paragraph(str(t),ParagraphStyle('c',parent=B,fontSize=fs,leading=fs+2.4))
GREEN=colors.HexColor('#cfe8d2'); YEL=colors.HexColor('#fbefc4'); RED=colors.HexColor('#f4cccc')
rows=[ # combinazione, giorni, fall centrali/doppi, gg>=4,5%, verdetto
 ('Goldbot L0 + Phantom L0 + <b>Reaper L3</b>','205','0% / 0%','2','SI'),
 ('Goldbot L3 + Phantom L3 + <b>Reaper L3</b>','216','0% / 0%','0','SI'),
 ('Goldbot L3 + Phantom L0 + <b>Reaper L3</b>','223','0% / 0%','0','SI'),
 ('Goldbot L0 + <b>Reaper L3</b> (due EA)','271','0% / 0%','0','SI (lenta)'),
 ('P4: <b>Reaper L3</b> + Goldbot L0 + Daytrade Pro (3 anni)','145','0% / n.d.','n.d.','SI'),
 ('Goldbot L1 + Phantom L0 + <b>Reaper L3</b>','158','3,1% / 11,6%','5','CON LIMITI'),
 ('Goldbot L0 + Phantom L1 + <b>Reaper L3</b>','163','4,8% / 9,9%','4','CON LIMITI'),
 ('Goldbot L1 + <b>Reaper L3</b> (due EA)','190','2,7% / 3,1%','4','CON LIMITI'),
 ('<b>Reaper L0</b> da solo','151','0% / 15,4%','4','CON LIMITI'),
 ('Goldbot L1 + Phantom L1 + <b>Reaper L3</b>','133','7,9% / 15,8%','8','NO'),
 ('Goldbot L0 + Phantom L1 + <b>Reaper L0</b>','91','11,3% / 31,8%','7','NO'),
 ('Goldbot L0 + <b>Reaper L0</b> (due EA)','139','2,7% / 25,3%','7','NO'),
 ('Goldbot + Phantom + <b>Reaper L3</b> + Gold Trade Pro Combo','167-177','9,6% / 9,9-13,4%','4','NO'),
 ('<b>Reaper L1</b> da solo (15% maxrisk)','96','47% / 58%','13','NO'),
 ('<b>Reaper Medium (L2)</b> da solo','32','70% / 75%','82','NO'),
 ('<b>Reaper L3</b> da solo','554','0% / 0%','0','TROPPO LENTO'),
]
E=[]
E.append(P('Gold Reaper: si puo usare per una challenge? Tabella definitiva',H1))
E.append(P('Per Massimo - 13/11/2026 - STIME DA BACKTEST (tester BCM, 80.000 EUR, XAUUSD), non previsioni. Nessuna indicazione su lotti, taglie o acquisti.',S))
E.append(P('1. La risposta in breve',H2))
E.append(P('<b>Si, ma solo il Reaper Combo (L3) o Prop (L0) dentro un portafoglio con Goldbot e Phantom a livelli bassi.</b> Il Reaper non va mai alzato ai livelli L1 o Medium: nel tester fallisce la challenge 47-70% delle volte. Da solo e troppo lento (L3) oppure troppo rischioso (L0 con costi alti, L1, Medium).'))
E.append(P('2. Tabella (parte oro, 4 anni 2013/2018/2020/2025, costi FTMO ipotizzati)',H2))
data=[[cell('<b>Combinazione</b>'),cell('<b>Giorni per le 2 fasi</b>'),cell('<b>Fallimenti: costi centrali / doppi</b>'),cell('<b>Giorni con perdita >= 4,5%</b>'),cell('<b>Verdetto</b>')]]
for a,b,c,d,v in rows: data.append([cell(a),cell(b),cell(c),cell(d),cell('<b>%s</b>'%v)])
t=Table(data,colWidths=[84*mm,20*mm,34*mm,22*mm,22*mm],repeatRows=1)
st=[('GRID',(0,0),(-1,-1),0.4,colors.HexColor('#b8c2cc')),('BACKGROUND',(0,0),(-1,0),colors.HexColor('#dfe8f2')),('VALIGN',(0,0),(-1,-1),'MIDDLE'),('TOPPADDING',(0,0),(-1,-1),2.2),('BOTTOMPADDING',(0,0),(-1,-1),2.2)]
for i,r in enumerate(rows,1):
    col=GREEN if r[4].startswith('SI') else (YEL if r[4].startswith('CON') else RED)
    st.append(('BACKGROUND',(4,i),(4,i),col))
t.setStyle(TableStyle(st)); E.append(t)
E.append(P('<b>Come si legge il verdetto (regola fissata prima)</b>: SI = 0% di fallimenti sia con costi centrali sia con costi doppi; CON LIMITI = fino al 5% con costi centrali e fino al 20% con costi doppi; NO = oltre. Fallisce chi perde il 5% in un giorno o il 10% totale. Giorni di calendario, mediana di fase 1 (+10%) piu fase 2 (+5%), partendo da ogni giorno di gennaio-marzo. "Giorni con perdita >= 4,5%" = in tutto il periodo testato, equity ricostruita dalle barre da 1 minuto.',S))
E.append(P('3. I set da usare',H2))
E.append(P('<b>Reaper</b>: L3 <font face="Courier">Gold_reaper_propfirm_combo_3GOLD.set</font>; L0 <font face="Courier">Gold_reaper_propfirm.set</font>. <b>Goldbot</b>: L0 <font face="Courier">Goldbot_PropFirm_5_2.5.set</font>; L1 <font face="Courier">Goldbot_PropFirm_10_5.set</font>; L3 <font face="Courier">Goldbot_PropFirm_combo_3GOLD.set</font>. <b>Phantom</b>: L0 <font face="Courier">GoldPhantom_Propfirm_combo.set</font>; L1 <font face="Courier">GoldPhantom_Propfirm.set</font>; L3 <font face="Courier">GoldPhantom_Propfirm_combo_3GOLD.set</font>. Da verificare file per file che siano le versioni correnti di Wim.',S))
E.append(P('4. Due challenge insieme',H2))
E.append(tbl:=Table([[cell('<b>Coppia di challenge</b>'),cell('<b>Entrambe passano la fase 1</b>'),cell('<b>Almeno una fallisce (centrali / doppi)</b>'),cell('<b>Giorni fase 1, entrambe (mediana)</b>')],
 [cell('Reaper L3 (Goldbot L0 + Phantom L0 + Reaper L3) + A (Goldbot L1 + Phantom L0)'),cell('75%'),cell('0% / 0%'),cell('113')],
 [cell('A + A (stessa combinazione su due conti)'),cell('97%'),cell('0% / 0%'),cell('117')],
 [cell('A + B (B = Goldbot L1 + Phantom L1)'),cell('97%'),cell('2,7% / 3,1%'),cell('117')],
 [cell('Reaper L3 + Reaper L3 (due conti uguali)'),cell('75%'),cell('0% / 0%'),cell('110')],
 [cell('Goldbot L1 + Phantom L0 + Reaper L3 + A'),cell('97%'),cell('3,1% / 11,6%'),cell('117')]],colWidths=[84*mm,30*mm,34*mm,34*mm]))
tbl.setStyle(TableStyle([('GRID',(0,0),(-1,-1),0.4,colors.HexColor('#b8c2cc')),('BACKGROUND',(0,0),(-1,0),colors.HexColor('#dfe8f2')),('VALIGN',(0,0),(-1,-1),'MIDDLE'),('TOPPADDING',(0,0),(-1,-1),2.2),('BOTTOMPADDING',(0,0),(-1,-1),2.2)]))
E.append(P('Le due challenge girano sullo stesso oro: i risultati NON sono indipendenti. Quando una incontra un giorno brutto, di solito lo incontra anche l\'altra. Avere due conti non dimezza il rischio, riduce solo l\'effetto di una partenza sfortunata sul tempo. "Entrambe passano" al 75% significa che il 25% delle partenze non e ancora arrivato al +10% entro la finestra del test (9-12 mesi), non che fallisce.',S))
E.append(P('5. Regole d\'uso se si sceglie il Reaper',H2))
for x in ['<b>Mai alzare il livello</b> del Reaper (L1 e Medium: fallimenti 47-70%) e mai usarlo da solo a L0 o L1.',
 '<b>Guardian acceso</b> a 4,3% giornaliero e 9,5% totale su ogni conto: il Reaper L0 ha avuto giorni a -6,0% nel 2013 (sopra il limite FTMO del 5%).',
 '<b>Non cambiare</b> il filtro NFP ne gli altri input dei set.',
 'Sul trial il Reaper ha perso 2.705 EUR in una notte (10/11, strategia 4, con altri settaggi); su una demo ha guadagnato 3.299 EUR nello stesso evento. Non e una prova ne a favore ne contro il Combo, ma conferma che il giorno storto esiste.',
 'Lo stesso EA su due conti apre posizioni identiche negli stessi momenti: la regola FTMO sulle posizioni opposte fra conti e sulla stessa strategia su piu conti NON e ancora stata chiarita da FTMO.']:
    E.append(Paragraph(x,BL,bulletText='-'))
E.append(P('6. Cosa NON e verificato',H2))
for x in ['Tester, non conto reale: spread e slippage FTMO, margine sullo Swing (leva oro 1:15) e stop out non sono simulati. Costi extra ipotizzati: 36 EUR a lotto oro (centrali), il doppio (prudenti).',
 'Un percorso per anno, 4 anni; il Reaper ha un rumore proprio (Randomization 50): i dettagli per anno non sono affidabili.',
 'Il Reaper non e mai stato misurato live con questi set; le percentuali di fallimento non sono garanzie.']:
    E.append(Paragraph(x,BL,bulletText='-'))
E.append(P('Fonti: report/GOLD_BUNDLE_COMBINAZIONI_2026-11-13.md, REAPER_SOLO_2026-11-13.md, CONFRONTO_P1_P3_P4_CON_A_B_2026-11-13.md. Non controllato da altri.',S))
doc=SimpleDocTemplate(OUT,pagesize=A4,leftMargin=14*mm,rightMargin=14*mm,topMargin=12*mm,bottomMargin=12*mm,title='Gold Reaper - tabella definitiva',author='Claudio Spadaro')
doc.build(E); print(OUT)
