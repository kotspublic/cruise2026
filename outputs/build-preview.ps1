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
    .subtitle { text-align: center; color: #5a6a8a; font-size: 1rem; margin-bottom: 48px; }
    .grid { display: flex; flex-wrap: wrap; gap: 36px; justify-content: center; max-width: 1300px; margin: 0 auto; }
    .shirt-card {
      display: flex; flex-direction: column; align-items: center; gap: 12px;
      background: rgba(255,255,255,0.55); border-radius: 16px; padding: 20px 16px 16px;
      box-shadow: 0 4px 16px rgba(0,0,0,0.08); transition: transform 0.2s, box-shadow 0.2s;
    }
    .shirt-card:hover { transform: translateY(-4px); box-shadow: 0 8px 28px rgba(0,0,0,0.14); }
    .shirt-label { font-size: 0.9rem; font-weight: 700; color: #2a3a5a; text-align: center; }
    .shirt-wrapper { position: relative; width: 200px; height: 220px; }
    .shirt-wrapper svg.shirt-shape { position: absolute; top: 0; left: 0; width: 100%; height: 100%; filter: drop-shadow(0 5px 14px rgba(0,0,0,0.22)); }
    .shirt-wrapper canvas.logo-canvas { position: absolute; top: 65px; left: 50%; transform: translateX(-50%); width: 112px; height: 112px; pointer-events: none; }
  </style>
</head>
<body>
  <h1>&#128085; Lee Family Disney Cruise 2026</h1>
  <p class="subtitle">T-Shirt Color Preview</p>
  <div class="grid" id="grid"></div>
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
    function shirtSVG(hex, outline) {
      const sc = outline ? '#bbb' : 'rgba(0,0,0,0.18)';
      const sw = outline ? '1.5' : '1';
      const shade = 'rgba(0,0,0,0.15)';
      return '<svg class="shirt-shape" viewBox="0 0 200 220" xmlns="http://www.w3.org/2000/svg">'
        + '<path fill="' + hex + '" stroke="' + sc + '" stroke-width="' + sw + '" stroke-linejoin="round" d="M 72,8 C 80,12 90,16 100,16 C 110,16 120,12 128,8 L 168,28 L 185,70 L 158,78 L 158,210 Q 158,215 153,215 L 47,215 Q 42,215 42,210 L 42,78 L 15,70 L 32,28 Z"/>'
        + '<path fill="none" stroke="' + shade + '" stroke-width="2" stroke-linecap="round" d="M 72,8 Q 100,34 128,8"/>'
        + '<line x1="42" y1="78" x2="15" y2="70" stroke="' + shade + '" stroke-width="1.5"/>'
        + '<line x1="158" y1="78" x2="185" y2="70" stroke="' + shade + '" stroke-width="1.5"/>'
        + '</svg>';
    }
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
      document.querySelectorAll('canvas.logo-canvas').forEach(c => {
        c.getContext('2d').drawImage(processedCanvas, 0, 0, c.width, c.height);
      });
    };
    const grid = document.getElementById('grid');
    shirts.forEach(shirt => {
      const card = document.createElement('div');
      card.className = 'shirt-card';
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
      grid.appendChild(card);
    });
  </script>
</body>
</html>
"@

[IO.File]::WriteAllText('c:\temp\familycruise2026\v3\outputs\tshirt-preview.html', $html, [Text.Encoding]::UTF8)
Write-Output "Done - file written"
