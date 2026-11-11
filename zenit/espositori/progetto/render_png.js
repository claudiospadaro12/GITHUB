// Renderizza gli SVG in PNG con Playwright + Chrome di sistema (non installa nulla).
// Uso: NODE_PATH=$(npm root -g) node render_png.js
const { chromium } = require('playwright');
const fs = require('fs'), path = require('path');
(async () => {
  const browser = await chromium.launch({ executablePath: '/usr/bin/google-chrome', args: ['--no-sandbox'] });
  for (const f of fs.readdirSync(__dirname).filter(f => f.endsWith('.svg'))) {
    const svg = fs.readFileSync(path.join(__dirname, f), 'utf8');
    const m = svg.match(/width="(\d+)" height="(\d+)"/);
    const page = await browser.newPage({ viewport: { width: +m[1], height: +m[2] } });
    await page.goto('file://' + path.join(__dirname, f));
    await page.screenshot({ path: path.join(__dirname, f.replace('.svg', '.png')) });
    await page.close(); console.log('ok', f);
  }
  await browser.close();
})();
