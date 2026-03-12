$b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes('c:\temp\familycruise2026\v3\v1.png'))
$dataUri = 'data:image/png;base64,' + $b64

$html = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Lee Family Disney Cruise - T-Shirt Color Preview</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Segoe UI', Arial, sans-serif;
      background: linear-gradient(135deg, #e8f4f8 0%, #dce8f0 100%);
      padding: 40px 20px 60px;
      min-height: 100vh;
    }
    h1 { text-align: center; color: #1a2a4a; font-size: 2rem; margin-bottom: 8px; }
    .subtitle { text-align: center; color: #5a6a8a; font-size: 1rem; margin-bottom: 16px; }
    .hires-link {
      display: block;
      text-align: center;
      margin-bottom: 40px;
    }
    .hires-link a {
      display: inline-flex;
      align-items: center;
      gap: 7px;
      background: #1b2a4a;
      color: #fff;
      text-decoration: none;
      font-size: 0.9rem;
      font-weight: 600;
      padding: 9px 22px;
      border-radius: 30px;
      box-shadow: 0 3px 10px rgba(27,42,74,0.25);
      transition: background 0.15s, transform 0.15s, box-shadow 0.15s;
      letter-spacing: 0.3px;
    }
    .hires-link a:hover {
      background: #2563EB;
      transform: translateY(-2px);
      box-shadow: 0 6px 18px rgba(37,99,235,0.35);
    }
    .grid { display: flex; flex-wrap: wrap; gap: 36px; justify-content: center; max-width: 1300px; margin: 0 auto; }
    .shirt-card {
      display: flex; flex-direction: column; align-items: center; gap: 12px;
      background: rgba(255,255,255,0.55); border-radius: 16px; padding: 20px 16px 16px;
      box-shadow: 0 4px 16px rgba(0,0,0,0.08); transition: transform 0.2s, box-shadow 0.2s;
      cursor: pointer;
    }
    .shirt-card:hover { transform: translateY(-4px); box-shadow: 0 8px 28px rgba(0,0,0,0.18); }
    .shirt-card:hover .shirt-wrapper { filter: brightness(1.04); }
    .shirt-label { font-size: 0.9rem; font-weight: 700; color: #2a3a5a; text-align: center; }
    .shirt-wrapper { position: relative; width: 200px; height: 220px; transition: filter 0.2s; }
    .shirt-wrapper svg.shirt-shape { position: absolute; top: 0; left: 0; width: 100%; height: 100%; filter: drop-shadow(0 5px 14px rgba(0,0,0,0.22)); }
    .shirt-wrapper canvas.logo-canvas { position: absolute; top: 65px; left: 50%; transform: translateX(-50%); width: 112px; height: 112px; pointer-events: none; }

    /* ── Lightbox ── */
    #lightbox {
      display: none;
      position: fixed; inset: 0;
      background: rgba(10,20,40,0.75);
      backdrop-filter: blur(6px);
      z-index: 1000;
      align-items: center;
      justify-content: center;
      animation: lbFadeIn 0.2s ease;
    }
    #lightbox.open { display: flex; }
    @keyframes lbFadeIn { from { opacity: 0; } to { opacity: 1; } }

    #lb-inner {
      background: rgba(255,255,255,0.12);
      border: 1px solid rgba(255,255,255,0.25);
      border-radius: 24px;
      padding: 40px 48px 36px;
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 24px;
      animation: lbPop 0.25s cubic-bezier(0.34,1.56,0.64,1);
      max-width: 90vw;
    }
    @keyframes lbPop { from { transform: scale(0.7); opacity: 0; } to { transform: scale(1); opacity: 1; } }

    #lb-shirt-wrapper {
      position: relative;
      width: 380px;
      height: 420px;
      max-width: 80vw;
      max-height: 70vh;
    }
    #lb-shirt-wrapper svg { position: absolute; top: 0; left: 0; width: 100%; height: 100%; filter: drop-shadow(0 12px 32px rgba(0,0,0,0.45)); }
    #lb-canvas { position: absolute; top: 124px; left: 50%; transform: translateX(-50%); width: 213px; height: 213px; pointer-events: none; }

    #lb-label {
      font-size: 1.4rem;
      font-weight: 800;
      color: #fff;
      letter-spacing: 0.5px;
      text-shadow: 0 2px 8px rgba(0,0,0,0.4);
    }

    #lb-close {
      position: absolute;
      top: 18px; right: 22px;
      background: rgba(255,255,255,0.18);
      border: none;
      color: #fff;
      font-size: 1.6rem;
      line-height: 1;
      width: 40px; height: 40px;
      border-radius: 50%;
      cursor: pointer;
      display: flex; align-items: center; justify-content: center;
      transition: background 0.15s;
    }
    #lb-close:hover { background: rgba(255,255,255,0.35); }

    #lb-nav {
      display: flex;
      gap: 16px;
    }
    .lb-nav-btn {
      background: rgba(255,255,255,0.18);
      border: 1px solid rgba(255,255,255,0.3);
      color: #fff;
      font-size: 1.1rem;
      padding: 8px 22px;
      border-radius: 30px;
      cursor: pointer;
      transition: background 0.15s;
    }
    .lb-nav-btn:hover { background: rgba(255,255,255,0.35); }
  </style>
</head>
<body>
  <h1>&#128085; Lee Family Disney Cruise 2026</h1>
  <p class="subtitle">T-Shirt Color Preview &nbsp;&#8212;&nbsp; click any shirt to zoom</p>
  <div class="hires-link">
    <a href="../v1.png" target="_blank" rel="noopener">
      &#128247; View High-Resolution Logo
    </a>
  </div>
  <div class="grid" id="grid"></div>

  <!-- Lightbox -->
  <div id="lightbox">
    <button id="lb-close" title="Close (Esc)">&#x2715;</button>
    <div id="lb-inner">
      <div id="lb-shirt-wrapper">
        <svg id="lb-svg" viewBox="0 0 200 220" xmlns="http://www.w3.org/2000/svg"></svg>
        <canvas id="lb-canvas" width="426" height="426"></canvas>
      </div>
      <div id="lb-label"></div>
      <div id="lb-nav">
        <button class="lb-nav-btn" id="lb-prev">&#8592; Prev</button>
        <button class="lb-nav-btn" id="lb-next">Next &#8594;</button>
      </div>
    </div>
  </div>

  <script>
    const LOGO_SRC = '$dataUri';
    const shirts = [
      { label: 'White',          hex: '#FFFFFF', outline: true },
      { label: 'Light Gray',     hex: '#D4D4D4' },
      { label: 'Heather Gray',   hex: '#9E9E9E' },
      { label: 'Charcoal',       hex: '#4A4A4A' },
      { label: 'Black',          hex: '#1A1A1A' },
      { label: 'Navy Blue',      hex: '#1B2A4A' },
      { label: 'Royal Blue',     hex: '#2563EB' },
      { label: 'Sky Blue',       hex: '#7EC8E3' },
      { label: 'Teal',           hex: '#2ABFBF' },
      { label: 'Forest Green',   hex: '#2D6A4F' },
      { label: 'Mint Green',     hex: '#A8E6CF' },
      { label: 'Coral',          hex: '#F4845F' },
      { label: 'Hot Pink',       hex: '#E91E8C' },
      { label: 'Lavender',       hex: '#B39DDB' },
      { label: 'Sunny Yellow',   hex: '#FFD600' },
      { label: 'Orange',         hex: '#FF6D00' },
      { label: 'Red',            hex: '#D32F2F' },
      { label: 'Burgundy',       hex: '#7B1A2A' },
    ];

    function shirtSVGInner(hex, outline) {
      const sc = outline ? '#bbb' : 'rgba(0,0,0,0.18)';
      const sw = outline ? '1.5' : '1';
      const shade = 'rgba(0,0,0,0.15)';
      return '<path fill="' + hex + '" stroke="' + sc + '" stroke-width="' + sw + '" stroke-linejoin="round" d="M 72,8 C 80,12 90,16 100,16 C 110,16 120,12 128,8 L 168,28 L 185,70 L 158,78 L 158,210 Q 158,215 153,215 L 47,215 Q 42,215 42,210 L 42,78 L 15,70 L 32,28 Z"/>'
        + '<path fill="none" stroke="' + shade + '" stroke-width="2" stroke-linecap="round" d="M 72,8 Q 100,34 128,8"/>'
        + '<line x1="42" y1="78" x2="15" y2="70" stroke="' + shade + '" stroke-width="1.5"/>'
        + '<line x1="158" y1="78" x2="185" y2="70" stroke="' + shade + '" stroke-width="1.5"/>'
    }

    function shirtSVG(hex, outline) {
      return '<svg class="shirt-shape" viewBox="0 0 200 220" xmlns="http://www.w3.org/2000/svg">' + shirtSVGInner(hex, outline) + '</svg>';
    }

    // Load & process logo (remove white bg)
    const sourceImg = new Image();
    sourceImg.src = LOGO_SRC;
    let processedCanvas = null;

    sourceImg.onload = function() {
      const size = 300;
      const off = document.createElement('canvas');
      off.width = size; off.height = size;
      const ctx = off.getContext('2d');
      ctx.drawImage(sourceImg, 0, 0, size, size);
      const id = ctx.getImageData(0, 0, size, size);
      const d = id.data;
      for (let i = 0; i < d.length; i += 4) {
        if (d[i] > 230 && d[i+1] > 230 && d[i+2] > 230) d[i+3] = 0;
      }
      ctx.putImageData(id, 0, 0);
      processedCanvas = off;
      // Draw on all grid canvases
      document.querySelectorAll('canvas.logo-canvas').forEach(c => {
        c.getContext('2d').drawImage(processedCanvas, 0, 0, c.width, c.height);
      });
      // Draw on lightbox canvas if already open
      if (lbOpen) drawLbCanvas();
    };

    // Build grid
    const grid = document.getElementById('grid');
    shirts.forEach((shirt, idx) => {
      const card = document.createElement('div');
      card.className = 'shirt-card';
      card.dataset.idx = idx;
      const wrapper = document.createElement('div');
      wrapper.className = 'shirt-wrapper';
      wrapper.innerHTML = shirtSVG(shirt.hex, shirt.outline);
      const canvas = document.createElement('canvas');
      canvas.className = 'logo-canvas';
      canvas.width = 224; canvas.height = 224;
      wrapper.appendChild(canvas);
      const label = document.createElement('div');
      label.className = 'shirt-label';
      label.textContent = shirt.label;
      card.appendChild(wrapper);
      card.appendChild(label);
      card.addEventListener('click', () => openLightbox(idx));
      grid.appendChild(card);
    });

    // ── Lightbox logic ──
    const lightbox = document.getElementById('lightbox');
    const lbSvg    = document.getElementById('lb-svg');
    const lbCanvas = document.getElementById('lb-canvas');
    const lbLabel  = document.getElementById('lb-label');
    const lbClose  = document.getElementById('lb-close');
    const lbPrev   = document.getElementById('lb-prev');
    const lbNext   = document.getElementById('lb-next');
    let currentIdx = 0;
    let lbOpen = false;

    function drawLbCanvas() {
      if (!processedCanvas) return;
      const ctx = lbCanvas.getContext('2d');
      ctx.clearRect(0, 0, lbCanvas.width, lbCanvas.height);
      ctx.drawImage(processedCanvas, 0, 0, lbCanvas.width, lbCanvas.height);
    }

    function openLightbox(idx) {
      currentIdx = idx;
      renderLb();
      lightbox.classList.add('open');
      lbOpen = true;
      document.body.style.overflow = 'hidden';
    }

    function closeLightbox() {
      lightbox.classList.remove('open');
      lbOpen = false;
      document.body.style.overflow = '';
    }

    function renderLb() {
      const shirt = shirts[currentIdx];
      lbSvg.innerHTML = shirtSVGInner(shirt.hex, shirt.outline);
      lbLabel.textContent = shirt.label;
      drawLbCanvas();
    }

    lbClose.addEventListener('click', closeLightbox);
    lightbox.addEventListener('click', e => { if (e.target === lightbox) closeLightbox(); });
    document.addEventListener('keydown', e => {
      if (!lbOpen) return;
      if (e.key === 'Escape') closeLightbox();
      if (e.key === 'ArrowLeft')  { currentIdx = (currentIdx - 1 + shirts.length) % shirts.length; renderLb(); }
      if (e.key === 'ArrowRight') { currentIdx = (currentIdx + 1) % shirts.length; renderLb(); }
    });
    lbPrev.addEventListener('click', () => { currentIdx = (currentIdx - 1 + shirts.length) % shirts.length; renderLb(); });
    lbNext.addEventListener('click', () => { currentIdx = (currentIdx + 1) % shirts.length; renderLb(); });
  </script>
</body>
</html>
"@

[IO.File]::WriteAllText('c:\temp\familycruise2026\v3\outputs\tshirt-preview.html', $html, [Text.Encoding]::UTF8)
Write-Output "Done - file written"
