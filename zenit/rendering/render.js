// Uso: NODE_PATH=$(npm root -g) node render.js   (serve la cartella zenit/ e fotografa le scene con Chromium)
const http=require('http'),fs=require('fs'),path=require('path'),{chromium}=require('playwright');
const ROOT=path.resolve(__dirname,'..');
const T={'.html':'text/html','.js':'text/javascript','.png':'image/png','.svg':'image/svg+xml','.json':'application/json'};
const srv=http.createServer((q,r)=>{const f=path.join(ROOT,decodeURIComponent(q.url.split('?')[0]));fs.readFile(f,(e,b)=>{if(e){r.writeHead(404);r.end();return}r.writeHead(200,{'Content-Type':T[path.extname(f)]||'application/octet-stream'});r.end(b)})});
const JOBS=[['espositore.html?v=A&cam=3q&w=1100&h=1600','espositore-A-3q'],['espositore.html?v=A&cam=front&w=1100&h=1600','espositore-A-frontale'],['espositore.html?v=B&cam=3q','espositore-B-3q'],
            ['rulli.html?n=1,2,3','etichette-rulli-1'],['rulli.html?n=4,5','etichette-rulli-2'],['rulli.html?n=1&close=1&w=1000&h=800','etichetta-primo-piano-1'],['rulli.html?n=4&close=1&w=1000&h=800','etichetta-primo-piano-4'],['rulli.html?n=5&close=1&w=1000&h=800','etichetta-primo-piano-5']];
(async()=>{await new Promise(r=>srv.listen(0,r));const port=srv.address().port;
const br=await chromium.launch({args:['--use-gl=angle','--use-angle=swiftshader','--enable-unsafe-swiftshader','--ignore-gpu-blocklist']});
for(const [u,n] of JOBS){const pg=await br.newPage({viewport:{width:1800,height:1200}});pg.on('console',m=>{if(m.type()==='error')console.log(n,m.text())});pg.on('pageerror',e=>console.log(n,'ERR',e.message));
 await pg.goto(`http://localhost:${port}/rendering/${u}`);try{await pg.waitForFunction('window.__DONE__===true',{timeout:60000})}catch(e){console.log(n,'timeout');await pg.close();continue}
 await pg.locator('canvas').screenshot({path:path.join(__dirname,'output',n+'.png')});console.log('ok',n);await pg.close()}
await br.close();srv.close()})();
