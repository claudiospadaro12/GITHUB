#!/usr/bin/env python3
"""Lezione registrata -> fotogrammi ogni N secondi + trascrizione (Whisper locale o SRT/VTT) -> parole collegate ai fotogrammi.
Uso: python lezione_pipeline.py <video> <cartella_out> [--ogni 15] [--modello medium] [--lingua it] [--srt file.srt|file.vtt] [--ritaglio W:H:X:Y] [--larghezza 960]
Richiede: ffmpeg nel PATH; Pillow; per la trascrizione automatica: pip install faster-whisper. Nessun upload: tutto in locale."""
import sys, os, re, json, subprocess, argparse, glob, zipfile, html
from PIL import Image, ImageDraw
ap = argparse.ArgumentParser(); ap.add_argument('video'); ap.add_argument('out')
ap.add_argument('--ogni', type=float, default=15); ap.add_argument('--modello', default='medium'); ap.add_argument('--lingua', default='it')
ap.add_argument('--srt'); ap.add_argument('--ritaglio'); ap.add_argument('--larghezza', type=int, default=960); ap.add_argument('--per-foglio', type=int, default=6)
a = ap.parse_args()
OUT = a.out; FR = os.path.join(OUT, 'frames'); FG = os.path.join(OUT, 'fogli'); os.makedirs(FR, exist_ok=True); os.makedirs(FG, exist_ok=True)
def tc(t): return '%02d:%02d:%02d' % (t // 3600, (t % 3600) // 60, t % 60)
# 1) fotogrammi
for f in glob.glob(os.path.join(FR, 'f_*.jpg')): os.remove(f)
vf = ('crop=%s,' % a.ritaglio if a.ritaglio else '') + 'fps=1/%g,scale=%d:-2' % (a.ogni, a.larghezza)
r = subprocess.run(['ffmpeg', '-v', 'error', '-y', '-i', a.video, '-vf', vf, '-q:v', '4', os.path.join(FR, 'f_%06d.jpg')])
if r.returncode: sys.exit('ffmpeg ha dato errore (percorso del video? ritaglio?)')
frames = sorted(glob.glob(os.path.join(FR, 'f_*.jpg'))); print('fotogrammi:', len(frames))
# 2) trascrizione
segs = []
def parse_t(s):
    s = s.strip().replace(',', '.'); p = s.split(':'); p = [float(x) for x in p]
    return p[0] * 3600 + p[1] * 60 + p[2] if len(p) == 3 else p[0] * 60 + p[1]
if a.srt:
    txt = open(a.srt, encoding='utf-8-sig', errors='replace').read().replace('\r', '')
    for blk in re.split(r'\n\s*\n', txt):
        m = re.search(r'(\d[\d:.,]*)\s*-->\s*(\d[\d:.,]*)', blk)
        if m:
            body = ' '.join(l for l in blk.split('\n')[blk.split('\n').index(next(x for x in blk.split('\n') if '-->' in x)) + 1:] if l.strip())
            segs.append(dict(start=parse_t(m.group(1)), end=parse_t(m.group(2)), text=re.sub(r'<[^>]+>', '', body).strip()))
else:
    try: from faster_whisper import WhisperModel
    except ImportError: sys.exit('Manca faster-whisper: pip install faster-whisper   (oppure passa --srt con la trascrizione di TurboScribe)')
    try: model = WhisperModel(a.modello, device='auto', compute_type='auto')
    except Exception: model = WhisperModel(a.modello, device='cpu', compute_type='int8')
    it, info = model.transcribe(a.video, language=a.lingua, vad_filter=True, beam_size=5)
    for s in it:
        segs.append(dict(start=s.start, end=s.end, text=s.text.strip())); print('\r%s' % tc(int(s.end)), end='', flush=True)
    print()
json.dump(segs, open(os.path.join(OUT, 'trascrizione.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=0)
with open(os.path.join(OUT, 'trascrizione.srt'), 'w', encoding='utf-8') as fh:
    for i, s in enumerate(segs, 1): fh.write('%d\n%s,000 --> %s,000\n%s\n\n' % (i, tc(int(s['start'])), tc(int(s['end'])), s['text']))
print('segmenti di trascrizione:', len(segs))
# 3) collegamento: ogni fotogramma k (istante t=(k-1)*ogni) prende le parole dei segmenti che INIZIANO in [t, t+ogni)
def nuovo(i, thumbs):
    th = Image.open(frames[i]).convert('L').resize((32, 18)); thumbs.append(th)
    if i == 0: return True
    p, c = list(thumbs[i - 1].tobytes()), list(th.tobytes()); d = sum(abs(x - y) for x, y in zip(p, c)) / len(c)
    return d > 3.0
rows = []; thumbs = []
for i, f in enumerate(frames):
    t = i * a.ogni; words = ' '.join(s['text'] for s in segs if t <= s['start'] < t + a.ogni)
    rows.append(dict(i=i, t=t, f=f, parole=words, cambia=nuovo(i, thumbs)))
with open(os.path.join(OUT, 'lezione.md'), 'w', encoding='utf-8') as fh:
    fh.write('# %s\nUn fotogramma ogni %g s. "stesso schermo" = lo schermo non e cambiato rispetto al fotogramma prima.\n\n' % (os.path.basename(a.video), a.ogni))
    for r_ in rows: fh.write('**[%s] frames/%s %s**\n%s\n\n' % (tc(int(r_['t'])), os.path.basename(r_['f']), '' if r_['cambia'] else '(stesso schermo)', r_['parole'] or '_(silenzio)_'))
with open(os.path.join(OUT, 'lezione.html'), 'w', encoding='utf-8') as fh:
    fh.write('<meta charset="utf-8"><style>body{font-family:sans-serif;max-width:1000px;margin:auto}.r{border-bottom:1px solid #ccc;padding:8px 0}img{max-width:100%%}</style><h2>%s</h2>' % html.escape(os.path.basename(a.video)))
    for r_ in rows: fh.write('<div class="r"><b>%s</b><br><img loading="lazy" src="frames/%s"><p>%s</p></div>' % (tc(int(r_['t'])), os.path.basename(r_['f']), html.escape(r_['parole'] or '(silenzio)')))
# 4) fogli di contatto (solo fotogrammi con schermo cambiato) per la chat
sel = [r_ for r_ in rows if r_['cambia']]; n = a.per_foglio; W = 640; H = 360
for k in range(0, len(sel), n):
    grp = sel[k:k + n]; sh = Image.new('RGB', (W * 2, (H + 22) * ((len(grp) + 1) // 2)), 'white'); d = ImageDraw.Draw(sh)
    for j, r_ in enumerate(grp):
        im = Image.open(r_['f']).convert('RGB'); im.thumbnail((W, H)); x = (j % 2) * W; y = (j // 2) * (H + 22)
        sh.paste(im, (x, y + 22)); d.text((x + 4, y + 4), tc(int(r_['t'])), fill='black')
    sh.save(os.path.join(FG, 'foglio_%03d.jpg' % (k // n + 1)), quality=70)
print('fogli di contatto:', len(glob.glob(os.path.join(FG, '*.jpg'))), '(fotogrammi con schermo cambiato:', len(sel), 'su', len(rows), ')')
# 5) zip per la chat: fogli + trascrizione + lezione.md (NON i fotogrammi interi), in parti da < 25 MB
base = os.path.join(OUT, 'PER_CHAT'); os.makedirs(base, exist_ok=True)
files = [os.path.join(OUT, x) for x in ('lezione.md', 'trascrizione.srt')] + sorted(glob.glob(os.path.join(FG, '*.jpg')))
parte, size, z = 1, 0, None
for f in files:
    if z is None or size + os.path.getsize(f) > 25 * 1024 * 1024:
        if z: z.close()
        z = zipfile.ZipFile(os.path.join(base, 'LEZIONE_PER_CHAT_parte%d.zip' % parte), 'w', zipfile.ZIP_DEFLATED); parte += 1; size = 0
    z.write(f, os.path.relpath(f, OUT)); size += os.path.getsize(f)
if z: z.close()
print('zip per la chat:', sorted(glob.glob(os.path.join(base, '*.zip'))))
