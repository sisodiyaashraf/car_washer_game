"""Generates an original starter art kit (SVG + PNG) for the car wash and repair game.
All shapes are drawn by this script, no third-party artwork is used."""
import os, math, random, re
import cairosvg

OUT = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'assets', 'images')
OL = '#1d2b3a'

COMMON = '''
<linearGradient id="glass" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#e3f6ff"/><stop offset="1" stop-color="#8fcbe8"/></linearGradient>
<linearGradient id="metal" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#f4f7f9"/><stop offset="1" stop-color="#9fb0bd"/></linearGradient>
<linearGradient id="gold" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#ffe680"/><stop offset="1" stop-color="#f2a900"/></linearGradient>
<linearGradient id="blueBtn" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#5cc3ff"/><stop offset="1" stop-color="#1e7fe0"/></linearGradient>
<linearGradient id="blueBg" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#6fd0ff"/><stop offset="1" stop-color="#2a7be0"/></linearGradient>
'''


def _alpha(svg):
    def f(m):
        a = int(m.group(3), 16) / 255
        return f'{m.group(1)}="#{m.group(2)}" {m.group(1)}-opacity="{a:.2f}"'
    return re.sub(r'(fill|stroke)="#([0-9a-fA-F]{6})([0-9a-fA-F]{2})"', f, svg)


def wrap(w, h, body, defs=''):
    return _alpha(f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {w} {h}" width="{w}" height="{h}">'
            f'<defs>{COMMON}{defs}</defs>{body}</svg>')


def save(rel, svg, png_w=None):
    p = os.path.join(OUT, rel)
    os.makedirs(os.path.dirname(p), exist_ok=True)
    with open(p + '.svg', 'w', encoding='utf-8') as f:
        f.write(svg)
    kw = {'output_width': png_w} if png_w else {}
    cairosvg.svg2png(bytestring=svg.encode('utf-8'), write_to=p + '.png', **kw)


def st(sw=5):
    return f'stroke="{OL}" stroke-width="{sw}" stroke-linejoin="round" stroke-linecap="round"'


# ---------------------------------------------------------------- rims / wheels
def rim(style, cx, cy, r):
    g = f'<circle cx="{cx}" cy="{cy}" r="{r}" fill="url(#metal)" stroke="{OL}" stroke-width="4"/>'
    if style == 'classic':
        g += f'<circle cx="{cx}" cy="{cy}" r="{r*0.38}" fill="#8796a3" stroke="{OL}" stroke-width="3"/>'
        for i in range(5):
            a = i * 2 * math.pi / 5 - math.pi / 2
            g += f'<circle cx="{cx+math.cos(a)*r*0.64:.1f}" cy="{cy+math.sin(a)*r*0.64:.1f}" r="{r*0.07:.1f}" fill="#4d5c68"/>'
    elif style == 'sport5':
        for i in range(5):
            a = i * 2 * math.pi / 5 - math.pi / 2
            g += (f'<line x1="{cx}" y1="{cy}" x2="{cx+math.cos(a)*r*0.85:.1f}" y2="{cy+math.sin(a)*r*0.85:.1f}" '
                  f'stroke="#566673" stroke-width="{r*0.2:.1f}" stroke-linecap="round"/>')
        g += f'<circle cx="{cx}" cy="{cy}" r="{r*0.22}" fill="#e8eef2" stroke="{OL}" stroke-width="3"/>'
    elif style == 'offroad':
        g += f'<circle cx="{cx}" cy="{cy}" r="{r*0.72}" fill="#3b4752" stroke="{OL}" stroke-width="3"/>'
        for i in range(12):
            a = i * 2 * math.pi / 12
            g += f'<circle cx="{cx+math.cos(a)*r*0.86:.1f}" cy="{cy+math.sin(a)*r*0.86:.1f}" r="{r*0.05:.1f}" fill="#2a343d"/>'
        for i in range(6):
            a = i * 2 * math.pi / 6
            g += (f'<line x1="{cx}" y1="{cy}" x2="{cx+math.cos(a)*r*0.7:.1f}" y2="{cy+math.sin(a)*r*0.7:.1f}" '
                  f'stroke="#b6c3cd" stroke-width="{r*0.09:.1f}"/>')
        g += f'<circle cx="{cx}" cy="{cy}" r="{r*0.2}" fill="#b6c3cd" stroke="{OL}" stroke-width="3"/>'
    elif style == 'star':
        pts = []
        for i in range(10):
            rr = r * 0.88 if i % 2 == 0 else r * 0.4
            a = i * math.pi / 5 - math.pi / 2
            pts.append(f'{cx+math.cos(a)*rr:.1f},{cy+math.sin(a)*rr:.1f}')
        g += f'<polygon points="{" ".join(pts)}" fill="#4d5c68" stroke="{OL}" stroke-width="3" stroke-linejoin="round"/>'
        g += f'<circle cx="{cx}" cy="{cy}" r="{r*0.16}" fill="#f4f7f9" stroke="{OL}" stroke-width="3"/>'
    return g


def wheel(cx, cy, r, style='classic', flat=False):
    if flat:
        t = f'<ellipse cx="{cx}" cy="{cy + r*0.14}" rx="{r*1.05}" ry="{r*0.8}" fill="#222c38" stroke="{OL}" stroke-width="5"/>'
        return t + rim(style, cx, cy + r * 0.16, r * 0.55)
    t = f'<circle cx="{cx}" cy="{cy}" r="{r}" fill="#222c38" stroke="{OL}" stroke-width="5"/>'
    return t + rim(style, cx, cy, r * 0.62)


# ---------------------------------------------------------------- vehicles
V = {
    'hatchback': dict(
        body='M60,215 L60,170 Q60,150 85,146 L170,138 L215,84 Q225,72 245,72 L370,72 Q392,72 405,88 L445,138 L510,146 Q545,152 548,180 L548,215 Z',
        windows=['M226,138 L252,88 L292,88 L292,138 Z', 'M306,88 L368,88 Q382,88 390,98 L418,138 L306,138 Z'],
        wheels=[(170, 222, 44), (440, 222, 44)], head=(522, 166), tail=(72, 172),
        doors=[(299, 140, 299, 205)], handles=[(330, 162)], top=72, bottom=215,
        dent=(360, 180), mud=[(120, 195), (300, 190), (480, 195), (260, 110), (200, 160)], flat=1, arch=True),
    'sports': dict(
        body='M50,205 L50,185 Q52,170 80,165 L200,150 Q250,100 320,92 L400,92 Q440,96 470,140 L520,152 Q555,160 556,190 L556,205 Z',
        windows=['M268,148 Q292,108 332,102 L395,102 Q420,106 440,142 Z'],
        wheels=[(165, 215, 42), (455, 215, 42)], head=(530, 178), tail=(62, 182),
        doors=[(335, 148, 335, 200)], handles=[(365, 160)], top=92, bottom=205,
        extra_after='<path d="M52,170 L36,148 L92,148 L90,164 Z" fill="{c}" stroke="#1d2b3a" stroke-width="5" stroke-linejoin="round"/>',
        dent=(300, 176), mud=[(120, 190), (300, 185), (490, 190), (340, 130)], flat=0, arch=True),
    'pickup': dict(
        body='M40,212 L40,138 L215,138 L215,118 L260,76 Q268,70 280,70 L380,70 Q395,70 405,84 L440,120 L520,128 Q552,134 556,165 L556,212 Z',
        windows=['M232,118 L268,84 L300,84 L300,120 Z', 'M312,84 L380,84 Q390,84 396,92 L420,120 L312,120 Z'],
        wheels=[(150, 222, 46), (450, 222, 46)], head=(532, 160), tail=(50, 160),
        doors=[(306, 122, 306, 205)], handles=[(338, 150)], top=70, bottom=212,
        extra_after='<rect x="52" y="146" width="152" height="12" rx="4" fill="#00000040"/>',
        dent=(120, 180), mud=[(100, 195), (300, 190), (490, 190), (180, 160)], flat=0, arch=True),
    'cruiser': dict(
        body='M45,212 L45,172 Q47,155 75,150 L190,142 L240,92 Q250,80 270,80 L390,80 Q410,80 422,92 L458,142 L515,150 Q548,156 552,180 L552,212 Z',
        windows=['M252,142 L274,96 L306,96 L306,142 Z', 'M318,96 L388,96 Q400,96 408,106 L436,142 L318,142 Z'],
        wheels=[(165, 222, 44), (440, 222, 44)], head=(526, 168), tail=(58, 172),
        doors=[(312, 144, 312, 205)], handles=[(345, 165)], top=80, bottom=212, band=186,
        extra_after=('<rect x="288" y="62" width="40" height="18" rx="6" fill="#2f7bff" stroke="#1d2b3a" stroke-width="4"/>'
                     '<rect x="328" y="62" width="40" height="18" rx="6" fill="#ff3b3b" stroke="#1d2b3a" stroke-width="4"/>'),
        dent=(370, 185), mud=[(110, 200), (300, 195), (480, 200), (270, 120)], flat=1, arch=True),
    'monster': dict(
        body='M120,150 L120,110 Q122,95 145,92 L230,88 L260,50 Q268,42 285,42 L380,42 Q395,42 405,55 L430,92 L470,96 Q505,102 508,128 L508,150 Z',
        windows=['M268,86 L290,56 L335,56 L335,86 Z', 'M347,56 L385,56 Q392,56 397,64 L414,86 L347,86 Z'],
        wheels=[(130, 215, 72), (470, 215, 72)], head=(492, 126), tail=(132, 118),
        doors=[(341, 90, 341, 140)], handles=[(368, 106)], top=42, bottom=150,
        extra_before='<rect x="130" y="200" width="340" height="16" fill="#5a6772" stroke="#1d2b3a" stroke-width="5"/>',
        wheels_first=True, dent=(210, 122), mud=[(170, 130), (300, 120), (450, 130)], flat=1, arch=False),
}


def vehicle_svg(name, color, damaged=False, style='classic'):
    v = V[name]
    cid = 'bodyclip'
    d = v['body']
    out = f'<clipPath id="{cid}"><path d="{d}"/></clipPath>'
    out += '<ellipse cx="300" cy="262" rx="250" ry="14" fill="#00000026"/>'
    wl = v['wheels']
    flat_i = v['flat'] if damaged else -1
    wsvg = ''.join(wheel(cx, cy, r, style, flat=(i == flat_i)) for i, (cx, cy, r) in enumerate(wl))
    out += v.get('extra_before', '')
    if v.get('wheels_first'):
        out += wsvg
    out += f'<path d="{d}" fill="{color}" {st(6)} fill-opacity="1"/>'
    # shading + highlight
    top, bot = v['top'], v['bottom']
    out += f'<g clip-path="url(#{cid})">'
    out += f'<rect x="0" y="{top}" width="600" height="{(bot-top)*0.28:.0f}" fill="#ffffff" opacity="0.22"/>'
    band = v.get('band')
    if band:
        out += f'<rect x="0" y="{band}" width="600" height="{bot-band+2}" fill="#1d2b3a"/>'
    else:
        out += f'<rect x="0" y="{bot-(bot-top)*0.22:.0f}" width="600" height="{(bot-top)*0.25:.0f}" fill="#000000" opacity="0.16"/>'
    if v.get('arch'):
        for cx, cy, r in wl:
            out += f'<circle cx="{cx}" cy="{cy}" r="{r+9}" fill="#1d2b3a"/>'
    out += '</g>'
    for w in v['windows']:
        out += f'<path d="{w}" fill="url(#glass)" {st(4)} fill-opacity="1"/>'
    for x1, y1, x2, y2 in v['doors']:
        out += f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="#00000055" stroke-width="3"/>'
    for hx, hy in v['handles']:
        out += f'<rect x="{hx-14}" y="{hy-3}" width="28" height="7" rx="3" fill="#ffffffcc" {st(2)}/>'
    ex = v.get('extra_after', '').replace('{c}', color)
    out += ex
    hx, hy = v['head']
    out += f'<circle cx="{hx}" cy="{hy}" r="13" fill="#fff6a8" {st(4)}/><circle cx="{hx-3}" cy="{hy-3}" r="4" fill="#fff"/>'
    tx, ty = v['tail']
    out += f'<rect x="{tx-8}" y="{ty-10}" width="16" height="20" rx="5" fill="#ff4d4d" {st(4)}/>'
    if not v.get('wheels_first'):
        out += wsvg
    if damaged:
        out += damage_overlay(v, cid)
    return wrap(600, 300, out)


def damage_overlay(v, cid):
    g = f'<g clip-path="url(#{cid})">'
    rnd = random.Random(7)
    for (x, y) in v['mud']:
        r = rnd.randint(22, 38)
        g += f'<ellipse cx="{x}" cy="{y}" rx="{r*1.3:.0f}" ry="{r*0.8:.0f}" fill="#6b4a2b" opacity="0.9"/>'
        for _ in range(4):
            g += (f'<circle cx="{x+rnd.randint(-r, r)}" cy="{y+rnd.randint(-r//2, r//2)}" '
                  f'r="{rnd.randint(4, 10)}" fill="#4a3220" opacity="0.9"/>')
    top, bot = v['top'], v['bottom']
    g += f'<rect x="0" y="{bot-34}" width="600" height="40" fill="#6b4a2b" opacity="0.7"/>'
    dx, dy = v['dent']
    g += f'<ellipse cx="{dx}" cy="{dy}" rx="30" ry="15" fill="#000" opacity="0.28"/>'
    g += f'<path d="M{dx-24},{dy-6} Q{dx},{dy-18} {dx+24},{dy-6}" stroke="#fff" stroke-width="3" fill="none" opacity="0.5"/>'
    for i in range(3):
        g += f'<line x1="{dx+40+i*12}" y1="{dy-30}" x2="{dx+62+i*12}" y2="{dy+4}" stroke="#00000055" stroke-width="3"/>'
    g += '</g>'
    hx, hy = v['head']
    g += f'<circle cx="{hx}" cy="{hy}" r="13" fill="#7b8791" {st(4)}/>'
    g += f'<path d="M{hx-9},{hy-6} L{hx+2},{hy} L{hx-4},{hy+4} L{hx+9},{hy+10}" stroke="{OL}" stroke-width="3" fill="none"/>'
    return g


def plane_svg(color='#e53935', damaged=False):
    o = '<ellipse cx="300" cy="278" rx="230" ry="12" fill="#00000026"/>'
    o += f'<path d="M110,170 Q120,140 200,135 L430,138 Q500,140 520,165 Q500,190 430,192 L200,195 Q125,198 110,170 Z" fill="{color}" {st(6)} fill-opacity="1"/>'
    o += f'<path d="M110,165 L66,112 L102,108 L142,150 Z" fill="{color}" {st(6)} fill-opacity="1"/>'
    o += f'<path d="M104,176 L60,190 L72,206 L140,186 Z" fill="#fff" {st(5)} fill-opacity="1"/>'
    o += '<rect x="190" y="150" width="240" height="14" fill="#fff" opacity="0.8"/>'
    o += f'<ellipse cx="335" cy="138" rx="42" ry="17" fill="url(#glass)" {st(4)} fill-opacity="1"/>'
    for x in (275, 420):
        o += f'<line x1="{x}" y1="82" x2="{x}" y2="206" stroke="{OL}" stroke-width="7"/>'
    o += f'<line x1="300" y1="136" x2="300" y2="82" stroke="{OL}" stroke-width="6"/>'
    o += f'<rect x="215" y="206" width="240" height="18" rx="9" fill="#fff" {st(5)} fill-opacity="1"/>'
    o += f'<rect x="215" y="58" width="260" height="24" rx="12" fill="#fff" {st(5)} fill-opacity="1"/>'
    o += f'<rect x="215" y="62" width="260" height="8" rx="4" fill="{color}" opacity="0.85"/>'
    for x, fl in ((310, damaged), (385, False)):
        o += f'<line x1="{x+10}" y1="192" x2="{x}" y2="250" stroke="{OL}" stroke-width="7"/>'
        o += wheel(x, 256, 22, 'classic', flat=fl)
    o += f'<circle cx="518" cy="165" r="17" fill="#cfd8de" {st(5)}/>'
    o += f'<rect x="524" y="108" width="14" height="114" rx="7" fill="#5a6772" {st(4)} fill-opacity="1"/>'
    if damaged:
        rnd = random.Random(3)
        o += '<clipPath id="pc"><path d="M110,170 Q120,140 200,135 L430,138 Q500,140 520,165 Q500,190 430,192 L200,195 Q125,198 110,170 Z"/></clipPath><g clip-path="url(#pc)">'
        for x, y in ((170, 170), (250, 175), (380, 172), (470, 165)):
            o += f'<ellipse cx="{x}" cy="{y}" rx="34" ry="20" fill="#6b4a2b" opacity="0.9"/>'
            o += f'<circle cx="{x+rnd.randint(-15,15)}" cy="{y+rnd.randint(-8,8)}" r="7" fill="#4a3220"/>'
        o += '<ellipse cx="300" cy="170" rx="30" ry="14" fill="#000" opacity="0.3"/></g>'
        o += f'<circle cx="518" cy="165" r="17" fill="#7b8791" {st(5)}/>'
        o += f'<path d="M506,158 L520,166 L512,172 L528,180" stroke="{OL}" stroke-width="3" fill="none"/>'
    return wrap(600, 300, o)


VEHICLE_COLORS = {'hatchback': '#F5B800', 'sports': '#E53935', 'pickup': '#43A047',
                  'cruiser': '#F2F4F7', 'monster': '#FF8F00'}
PAINT = {'red': '#E53935', 'orange': '#FB8C00', 'yellow': '#FDD835', 'green': '#43A047', 'blue': '#1E88E5', 'purple': '#8E24AA'}
RIM_FOR = {'hatchback': 'classic', 'sports': 'sport5', 'pickup': 'offroad', 'cruiser': 'classic', 'monster': 'offroad'}


def make_vehicles():
    for n, c in VEHICLE_COLORS.items():
        save(f'vehicles/vehicle_{n}_clean', vehicle_svg(n, c, False, RIM_FOR[n]), 900)
        save(f'vehicles/vehicle_{n}_damaged', vehicle_svg(n, c, True, RIM_FOR[n]), 900)
    save('vehicles/vehicle_biplane_clean', plane_svg(damaged=False), 900)
    save('vehicles/vehicle_biplane_damaged', plane_svg(damaged=True), 900)
    # recolored clean variants for the paint phase
    for cname, ccol in PAINT.items():
        for n in V:
            save(f'vehicles/paint/vehicle_{n}_clean_{cname}', vehicle_svg(n, ccol, False, RIM_FOR[n]), 900)
        save(f'vehicles/paint/vehicle_biplane_clean_{cname}', plane_svg(ccol, False), 900)


# ---------------------------------------------------------------- rims & decals
def make_rims():
    for s in ('classic', 'sport5', 'offroad', 'star'):
        save(f'rims/rim_{s}', wrap(200, 200, rim(s, 100, 100, 90)), 400)


def make_decals():
    C = {}
    C['stripes'] = ('<path d="M20,20 L120,20 L60,130 L-40,130 Z" fill="#fff" transform="translate(40,0)"/>'
                    '<path d="M150,20 L190,20 L130,130 L90,130 Z" fill="#1e7fe0" transform="translate(40,0)"/>'
                    '<path d="M200,20 L240,20 L180,130 L140,130 Z" fill="#fff" transform="translate(40,0)"/>')
    C['flames'] = ('<path d="M10,120 C40,110 50,80 40,50 C60,70 70,60 70,30 C90,60 110,60 110,90 C130,70 160,80 190,70 '
                   'C180,100 200,110 240,110 C200,130 120,140 10,120 Z" fill="#ff6a00" '
                   f'stroke="{OL}" stroke-width="4" stroke-linejoin="round"/>'
                   '<path d="M40,118 C60,105 70,85 70,70 C85,90 100,90 110,105 C140,95 170,100 200,112 C150,125 90,128 40,118 Z" fill="#ffd400"/>')
    C['number07'] = ('<circle cx="150" cy="75" r="62" fill="#fff" stroke="#1d2b3a" stroke-width="6"/>'
                     '<rect x="100" y="40" width="40" height="70" rx="18" fill="none" stroke="#1d2b3a" stroke-width="12"/>'
                     '<path d="M158,42 L206,42 L180,112" fill="none" stroke="#e53935" stroke-width="12" stroke-linejoin="round" stroke-linecap="round"/>')
    star = []
    for i in range(10):
        rr = 62 if i % 2 == 0 else 26
        a = i * math.pi / 5 - math.pi / 2
        star.append(f'{150+math.cos(a)*rr:.1f},{75+math.sin(a)*rr:.1f}')
    C['starburst'] = (f'<polygon points="{" ".join(star)}" fill="#ffd400" stroke="{OL}" stroke-width="5" stroke-linejoin="round"/>'
                      '<circle cx="55" cy="40" r="8" fill="#fff"/><circle cx="250" cy="110" r="10" fill="#fff"/><circle cx="240" cy="35" r="6" fill="#fff"/>')
    rnd = random.Random(11)
    camo = '<clipPath id="cc"><rect x="20" y="15" width="260" height="120" rx="22"/></clipPath><rect x="20" y="15" width="260" height="120" rx="22" fill="#6b7a3a"/><g clip-path="url(#cc)">'
    for col in ('#3f4d22', '#8a6a3c', '#2b3518', '#a3ad6a'):
        for _ in range(7):
            camo += f'<ellipse cx="{rnd.randint(20,280)}" cy="{rnd.randint(15,135)}" rx="{rnd.randint(18,42)}" ry="{rnd.randint(10,24)}" fill="{col}"/>'
    camo += f'</g><rect x="20" y="15" width="260" height="120" rx="22" fill="none" stroke="{OL}" stroke-width="4"/>'
    C['camo'] = camo
    chk = '<clipPath id="kc"><rect x="30" y="20" width="240" height="110" rx="10"/></clipPath><g clip-path="url(#kc)">'
    for r in range(5):
        for c in range(10):
            chk += f'<rect x="{30+c*24}" y="{20+r*22}" width="24" height="22" fill="{"#1d2b3a" if (r+c)%2==0 else "#fff"}"/>'
    chk += f'</g><rect x="30" y="20" width="240" height="110" rx="10" fill="none" stroke="{OL}" stroke-width="5"/>'
    C['checkered'] = chk
    for k, body in C.items():
        save(f'decals/decal_{k}', wrap(300, 150, body), 600)


# ---------------------------------------------------------------- tools
def icon(body):
    return wrap(256, 256, body)


def make_tools():
    T = {}
    T['sponge'] = (f'<rect x="38" y="96" width="180" height="96" rx="22" fill="#ffd93d" {st(6)} fill-opacity="1"/>'
                   f'<rect x="38" y="158" width="180" height="34" rx="16" fill="#4caf50" {st(6)} fill-opacity="1"/>'
                   '<ellipse cx="80" cy="124" rx="9" ry="6" fill="#d8a800"/><ellipse cx="140" cy="132" rx="11" ry="7" fill="#d8a800"/>'
                   '<ellipse cx="185" cy="118" rx="8" ry="6" fill="#d8a800"/>'
                   f'<circle cx="80" cy="64" r="20" fill="#fff" {st(4)} fill-opacity="0.9"/><circle cx="130" cy="48" r="14" fill="#fff" {st(4)} fill-opacity="0.9"/>'
                   f'<circle cx="176" cy="66" r="18" fill="#fff" {st(4)} fill-opacity="0.9"/>')
    T['spray_hose'] = (f'<path d="M20,210 Q40,150 90,160" stroke="#3a4a57" stroke-width="18" fill="none" stroke-linecap="round"/>'
                       f'<rect x="84" y="112" width="92" height="60" rx="16" fill="#1e88e5" {st(6)} fill-opacity="1"/>'
                       f'<path d="M176,128 L216,116 L216,168 L176,156 Z" fill="#9fb0bd" {st(6)} fill-opacity="1"/>'
                       f'<path d="M110,172 L128,214 L148,208 L134,170 Z" fill="#0d5eb0" {st(5)} fill-opacity="1"/>'
                       '<g stroke="#4fc3f7" stroke-width="7" stroke-linecap="round"><line x1="226" y1="126" x2="250" y2="110"/>'
                       '<line x1="228" y1="142" x2="254" y2="142"/><line x1="226" y1="158" x2="250" y2="174"/></g>')
    T['pressure_washer'] = (f'<rect x="60" y="86" width="116" height="54" rx="16" fill="#e53935" {st(6)} fill-opacity="1"/>'
                            f'<rect x="170" y="104" width="76" height="16" rx="8" fill="#cfd8de" {st(5)} fill-opacity="1"/>'
                            f'<path d="M80,138 L96,208 L132,208 L128,138 Z" fill="#37474f" {st(6)} fill-opacity="1"/>'
                            f'<path d="M134,140 L148,170 L160,164 L152,138 Z" fill="#ffd93d" {st(5)} fill-opacity="1"/>'
                            f'<path d="M60,112 Q20,112 24,160 Q28,214 90,230" stroke="#3a4a57" stroke-width="12" fill="none" stroke-linecap="round"/>'
                            '<g stroke="#4fc3f7" stroke-width="6" stroke-linecap="round"><line x1="248" y1="100" x2="254" y2="90"/><line x1="250" y1="112" x2="256" y2="112"/></g>')
    T['wheel_brush'] = (f'<g transform="rotate(-30 128 128)"><rect x="112" y="20" width="32" height="130" rx="14" fill="#c98a4b" {st(6)} fill-opacity="1"/>'
                        f'<rect x="78" y="148" width="100" height="40" rx="12" fill="#1e88e5" {st(6)} fill-opacity="1"/>'
                        + ''.join(f'<line x1="{86+i*14}" y1="188" x2="{86+i*14}" y2="226" stroke="#ffd93d" stroke-width="8" stroke-linecap="round"/>' for i in range(7))
                        + '</g>')
    T['hammer'] = (f'<g transform="translate(19,26) scale(0.85) rotate(-35 128 128)"><rect x="114" y="70" width="28" height="170" rx="12" fill="#c98a4b" {st(6)} fill-opacity="1"/>'
                   f'<rect x="64" y="40" width="120" height="48" rx="12" fill="#9fb0bd" {st(6)} fill-opacity="1"/>'
                   f'<path d="M184,52 Q222,50 232,34 Q226,72 184,78 Z" fill="#9fb0bd" {st(6)} fill-opacity="1"/></g>')
    T['air_pump'] = (f'<rect x="60" y="196" width="136" height="26" rx="10" fill="#37474f" {st(6)} fill-opacity="1"/>'
                     f'<rect x="108" y="84" width="40" height="116" rx="10" fill="#ef5350" {st(6)} fill-opacity="1"/>'
                     f'<rect x="84" y="62" width="88" height="20" rx="10" fill="#37474f" {st(6)} fill-opacity="1"/>'
                     f'<line x1="128" y1="62" x2="128" y2="84" stroke="{OL}" stroke-width="8"/>'
                     f'<circle cx="128" cy="130" r="26" fill="#fff" {st(5)} fill-opacity="1"/>'
                     f'<line x1="128" y1="130" x2="144" y2="116" stroke="#e53935" stroke-width="5" stroke-linecap="round"/>'
                     '<path d="M196,208 Q240,200 236,160" stroke="#3a4a57" stroke-width="10" fill="none" stroke-linecap="round"/>')
    rays = ''.join(f'<line x1="{128+math.cos(a)*84:.0f}" y1="{104+math.sin(a)*84:.0f}" x2="{128+math.cos(a)*104:.0f}" y2="{104+math.sin(a)*104:.0f}" stroke="#ffd93d" stroke-width="8" stroke-linecap="round"/>'
                   for a in [math.radians(x) for x in (-90, -40, -140, 0, 180, 40, 140)])
    T['bulb'] = (rays + f'<circle cx="128" cy="104" r="58" fill="#fff59d" {st(6)} fill-opacity="1"/>'
                 '<path d="M104,110 Q116,90 128,110 Q140,130 152,110" stroke="#f57c00" stroke-width="6" fill="none"/>'
                 f'<rect x="102" y="158" width="52" height="22" rx="6" fill="#9fb0bd" {st(5)} fill-opacity="1"/>'
                 f'<rect x="108" y="180" width="40" height="18" rx="6" fill="#78909c" {st(5)} fill-opacity="1"/>'
                 f'<rect x="116" y="198" width="24" height="12" rx="6" fill="#37474f" {st(4)} fill-opacity="1"/>')
    T['spare_tire'] = wheel(128, 128, 96, 'sport5')
    T['spark_plug'] = (f'<rect x="108" y="30" width="40" height="110" rx="14" fill="#f4f7f9" {st(6)} fill-opacity="1"/>'
                       f'<rect x="96" y="132" width="64" height="40" rx="6" fill="#9fb0bd" {st(6)} fill-opacity="1"/>'
                       f'<rect x="110" y="172" width="36" height="34" rx="4" fill="#78909c" {st(6)} fill-opacity="1"/>'
                       f'<path d="M128,206 L128,230 L146,230" stroke="{OL}" stroke-width="8" fill="none" stroke-linecap="round"/>'
                       f'<rect x="116" y="14" width="24" height="22" rx="6" fill="#37474f" {st(5)} fill-opacity="1"/>')
    T['battery'] = (f'<rect x="30" y="86" width="196" height="120" rx="14" fill="#37474f" {st(6)} fill-opacity="1"/>'
                    f'<rect x="56" y="62" width="34" height="26" rx="6" fill="#e53935" {st(5)} fill-opacity="1"/>'
                    f'<rect x="166" y="62" width="34" height="26" rx="6" fill="#1e88e5" {st(5)} fill-opacity="1"/>'
                    f'<path d="M136,100 L100,152 L124,152 L112,194 L158,136 L132,136 Z" fill="#ffd93d" {st(5)} fill-opacity="1"/>')
    for k, b in T.items():
        save(f'tools/tool_{k}', icon(b), 512)


# ---------------------------------------------------------------- UI
def gear(cx, cy, ro, ri, n=8):
    pts = []
    for i in range(n * 2):
        a0 = i * math.pi / n
        r1 = ro if i % 2 == 0 else ri
        for da in (-0.18, 0.18):
            a = a0 + da * (math.pi / n)
            pts.append(f'{cx+math.cos(a)*r1:.1f},{cy+math.sin(a)*r1:.1f}')
    return f'<polygon points="{" ".join(pts)}" fill="#cfd8de" {st(6)} fill-opacity="1"/><circle cx="{cx}" cy="{cy}" r="{ri*0.42}" fill="#37474f" {st(5)} fill-opacity="1"/>'


def make_ui():
    U = {}
    U['coin'] = (f'<circle cx="128" cy="128" r="104" fill="url(#gold)" {st(8)} fill-opacity="1"/>'
                 '<circle cx="128" cy="128" r="76" fill="none" stroke="#c98800" stroke-width="8"/>'
                 '<polygon points="128,70 144,110 186,114 154,142 164,184 128,162 92,184 102,142 70,114 112,110" fill="#fff3b0" stroke="#c98800" stroke-width="5" stroke-linejoin="round"/>')
    pts = ' '.join(f'{128+math.cos(i*math.pi/5-math.pi/2)*(104 if i%2==0 else 44):.1f},{128+math.sin(i*math.pi/5-math.pi/2)*(104 if i%2==0 else 44):.1f}' for i in range(10))
    U['star_filled'] = f'<polygon points="{pts}" fill="url(#gold)" {st(8)} fill-opacity="1"/>'
    U['star_empty'] = f'<polygon points="{pts}" fill="#d5dde3" {st(8)} fill-opacity="1"/>'
    U['gear'] = gear(128, 128, 104, 82)
    U['sound'] = (f'<path d="M40,98 L90,98 L146,52 L146,204 L90,158 L40,158 Z" fill="#cfd8de" {st(7)} fill-opacity="1"/>'
                  '<path d="M174,92 Q198,128 174,164" stroke="#1d2b3a" stroke-width="10" fill="none" stroke-linecap="round"/>'
                  '<path d="M198,66 Q244,128 198,190" stroke="#1d2b3a" stroke-width="10" fill="none" stroke-linecap="round"/>')
    U['play_ticket'] = (f'<rect x="20" y="60" width="216" height="136" rx="24" fill="#ff9800" {st(8)} fill-opacity="1"/>'
                        '<circle cx="20" cy="128" r="18" fill="#fff"/><circle cx="236" cy="128" r="18" fill="#fff"/>'
                        '<polygon points="110,92 110,164 172,128" fill="#fff" stroke="#1d2b3a" stroke-width="6" stroke-linejoin="round"/>')
    for k, b in U.items():
        save(f'ui/ui_{k}', icon(b), 256)
    def btn(name, g1, g2, shadow):
        d = f'<linearGradient id="g" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="{g1}"/><stop offset="1" stop-color="{g2}"/></linearGradient>'
        b = (f'<rect x="8" y="14" width="284" height="84" rx="26" fill="{shadow}"/>'
             f'<rect x="8" y="6" width="284" height="84" rx="26" fill="url(#g)" {st(6)} fill-opacity="1"/>'
             '<rect x="22" y="14" width="256" height="24" rx="12" fill="#fff" opacity="0.28"/>')
        save(f'ui/ui_button_{name}', wrap(300, 104, b, d), 600)
    btn('normal', '#5cc3ff', '#1e7fe0', '#0d4f9e')
    btn('pressed', '#3aa6e8', '#1768c0', '#0d4f9e')
    btn('disabled', '#d5dde3', '#aab6bf', '#8b98a2')
    save('ui/ui_progress_frame', wrap(400, 48, f'<rect x="4" y="4" width="392" height="40" rx="20" fill="#e8eef2" {st(5)} fill-opacity="1"/><rect x="10" y="10" width="140" height="28" rx="14" fill="#4cd964"/>'), 800)
    save('ui/ui_panel', wrap(400, 300, f'<rect x="12" y="20" width="376" height="270" rx="30" fill="#00000030"/><rect x="12" y="10" width="376" height="270" rx="30" fill="#fff" {st(7)} fill-opacity="1"/><rect x="12" y="10" width="376" height="62" rx="30" fill="#5cc3ff" {st(7)} fill-opacity="1"/>'), 800)


# ---------------------------------------------------------------- backgrounds
def make_backgrounds():
    W, H = 540, 1170
    rnd = random.Random(5)
    # wash bay
    b = '<rect width="540" height="1170" fill="#bfe6f5"/>'
    for r in range(0, 14):
        for c in range(0, 9):
            col = '#a9dbef' if (r + c) % 2 == 0 else '#b9e3f3'
            b += f'<rect x="{c*60}" y="{r*58}" width="60" height="58" fill="{col}" stroke="#8fc9e0" stroke-width="2"/>'
    b += f'<rect x="90" y="130" width="360" height="400" rx="14" fill="#7a8b99" {st(6)} fill-opacity="1"/>'
    for i in range(10):
        b += f'<line x1="96" y1="{150+i*38}" x2="444" y2="{150+i*38}" stroke="#5f707e" stroke-width="5"/>'
    b += f'<rect x="0" y="720" width="540" height="450" fill="#8e9aa5"/><rect x="0" y="716" width="540" height="12" fill="#6e7a85"/>'
    for (x, y, rx, ry) in ((120, 860, 90, 18), (380, 940, 110, 20), (240, 1050, 120, 22)):
        b += f'<ellipse cx="{x}" cy="{y}" rx="{rx}" ry="{ry}" fill="#9fd4ee" opacity="0.8"/>'
    b += f'<path d="M20,740 q-30,40 10,60 q40,20 60,-20" stroke="#2d6a4f" stroke-width="16" fill="none" stroke-linecap="round"/>'
    b += f'<rect x="440" y="650" width="70" height="80" rx="10" fill="#ffca28" {st(5)} fill-opacity="1"/>'
    for _ in range(14):
        b += f'<circle cx="{rnd.randint(30,510)}" cy="{rnd.randint(300,700)}" r="{rnd.randint(8,22)}" fill="#fff" opacity="0.5" stroke="#9fd4ee" stroke-width="2"/>'
    save('backgrounds/bg_wash_bay', wrap(W, H, b), 540)
    # repair garage
    b = '<linearGradient id="cw" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#cfc8bd"/><stop offset="1" stop-color="#a9a196"/></linearGradient>'
    b = '<rect width="540" height="1170" fill="url(#cw)"/>'
    b += f'<rect x="40" y="110" width="460" height="330" rx="12" fill="#8a7358" {st(6)} fill-opacity="1"/>'
    for i in range(9):
        for j in range(6):
            b += f'<circle cx="{60+i*52}" cy="{130+j*52}" r="3" fill="#5e4b37"/>'
    tools = [(100, 190, '#9fb0bd', 60, 12), (190, 200, '#e53935', 70, 14), (280, 180, '#ffd93d', 50, 20), (370, 195, '#1e88e5', 64, 12), (440, 210, '#4caf50', 56, 16)]
    for x, y, col, h, w in tools:
        b += f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="6" fill="{col}" {st(4)} fill-opacity="1"/>'
        b += f'<rect x="{x}" y="{y+h+30}" width="{w}" height="{h-10}" rx="6" fill="{col}" {st(4)} fill-opacity="1"/>'
    b += '<rect x="0" y="720" width="540" height="450" fill="#7d8790"/><rect x="0" y="716" width="540" height="12" fill="#5d666e"/>'
    for i in range(0, 540, 60):
        b += f'<polygon points="{i},1140 {i+30},1140 {i+60},1170 {i+30},1170" fill="#ffd93d"/>'
    for k in range(4):
        b += f'<circle cx="{460 + (k%2)*12}" cy="{690 - k*38}" r="42" fill="#222c38" {st(5)}/><circle cx="{460 + (k%2)*12}" cy="{690 - k*38}" r="16" fill="#555f68"/>'
    save('backgrounds/bg_repair_garage', wrap(W, H, b), 540)
    # paint booth
    b = '<rect width="540" height="1170" fill="#eef3f7"/>'
    b += '<rect x="0" y="0" width="540" height="120" fill="#cfd9e0"/>'
    for x in (90, 270, 450):
        b += f'<rect x="{x-50}" y="40" width="100" height="26" rx="13" fill="#fffbe0" {st(4)} fill-opacity="1"/>'
    cols = ['#e53935', '#fb8c00', '#fdd835', '#43a047', '#1e88e5', '#8e24aa', '#f06292', '#26c6da']
    for i, c in enumerate(cols):
        b += f'<rect x="{50+(i%4)*112}" y="{190+(i//4)*130}" width="96" height="106" rx="10" fill="{c}" {st(5)} fill-opacity="1"/>'
    b += '<rect x="0" y="720" width="540" height="450" fill="#dfe7ec"/><rect x="0" y="716" width="540" height="12" fill="#b8c4cc"/>'
    b += '<rect x="0" y="720" width="540" height="140" fill="#ffffff" opacity="0.35"/>'
    save('backgrounds/bg_paint_booth', wrap(W, H, b), 540)


# ---------------------------------------------------------------- icon + store art
def make_icon_and_store():
    car = vehicle_svg('hatchback', '#F5B800', False, 'sport5')
    inner = car[car.index('<defs>'):-6]
    body_only = inner[inner.index('</defs>') + 7:]
    def bubbles(seed, n, x0, x1, y0, y1):
        r = random.Random(seed)
        s = ''
        for _ in range(n):
            s += f'<circle cx="{r.randint(x0,x1)}" cy="{r.randint(y0,y1)}" r="{r.randint(8,26)}" fill="#fff" opacity="0.8" stroke="#ffffff" stroke-width="3"/>'
        return s
    icon_body = ('<rect width="512" height="512" fill="url(#blueBg)"/>'
                 f'<g transform="translate(16,100) scale(0.8)">{body_only}</g>'
                 + bubbles(2, 12, 40, 470, 60, 120) +
                 f'<g transform="translate(390,350) rotate(-35) scale(0.8)"><rect x="-10" y="0" width="24" height="120" rx="10" fill="#9fb0bd" {st(6)}/><circle cx="2" cy="0" r="26" fill="none" stroke="#9fb0bd" stroke-width="16"/></g>')
    save('icon/app_icon', wrap(512, 512, icon_body), 512)
    fg = (f'<g transform="translate(0,110) scale(0.85)">{body_only}</g>' + bubbles(2, 8, 60, 450, 70, 130))
    save('icon/app_icon_foreground', wrap(512, 512, f'<g transform="translate(97,60) scale(0.62)">{fg}</g>'), 512)
    feat = ('<linearGradient id="fb" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#6fd0ff"/><stop offset="1" stop-color="#2a7be0"/></linearGradient>'
            '<rect width="1024" height="500" fill="url(#fb)"/><rect y="400" width="1024" height="100" fill="#8e9aa5"/>'
            f'<g transform="translate(14,168) scale(0.8)">{vehicle_svg("sports", "#E53935", False, "sport5")[vehicle_svg("sports", "#E53935", False, "sport5").index("</defs>")+7:-6]}</g>'
            f'<g transform="translate(520,168) scale(0.8)">{vehicle_svg("pickup", "#43A047", True, "offroad")[vehicle_svg("pickup", "#43A047", True, "offroad").index("</defs>")+7:-6]}</g>'
            + bubbles(9, 24, 40, 480, 80, 330))
    save('store/feature_graphic', wrap(1024, 500, feat), 1024)


if __name__ == '__main__':
    make_vehicles()
    make_rims()
    make_decals()
    make_tools()
    make_ui()
    make_backgrounds()
    make_icon_and_store()
    print('done')
