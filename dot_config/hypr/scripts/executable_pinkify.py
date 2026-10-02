import sys
import numpy as np
from PIL import Image

def to_hsv(a):
    r, g, b = a[...,0], a[...,1], a[...,2]
    mx, mn = a.max(-1), a.min(-1)
    d = mx - mn
    h = np.zeros_like(mx); v = mx
    s = np.where(mx > 0, d / np.maximum(mx, 1e-6), 0)
    m = d > 1e-6
    i = m & (mx == r); h[i] = (60*((g-b)[i]/d[i])) % 360
    i = m & (mx == g); h[i] = 60*((b-r)[i]/d[i]) + 120
    i = m & (mx == b); h[i] = 60*((r-g)[i]/d[i]) + 240
    return h, s, v

def to_rgb(h, s, v):
    c = v*s; hp = (h % 360)/60.0
    x = c*(1-np.abs(hp % 2 - 1)); z = np.zeros_like(c)
    conds = [(hp<1),(hp<2),(hp<3),(hp<4),(hp<5),(hp<=6)]
    r = np.select(conds, [c,x,z,z,x,c]); g = np.select(conds, [x,c,c,x,z,z])
    b = np.select(conds, [z,z,x,c,c,x])
    m = v - c
    return np.clip(np.stack([r+m, g+m, b+m], -1), 0, 1)

src, dst, sat_mul, rot = sys.argv[1], sys.argv[2], float(sys.argv[3]), float(sys.argv[4])
im = Image.open(src).convert("RGB")
a = np.asarray(im).astype(np.float32)/255.0
h, s, v = to_hsv(a)

# The blue/periwinkle sky is what drags the pink coverage down. Rotate just that
# band toward magenta; leave the already-pink clouds where they are so they keep
# their shape and don't all collapse to one hue.
blue = (h >= 185) & (h <= 290)
h = np.where(blue, (h + rot) % 360, h)

s = np.clip(s * sat_mul, 0, 1)
out = (to_rgb(h, s, v)*255).astype(np.uint8)
Image.fromarray(out).save(dst, quality=95)

# report resulting pinkness with the same metric as before
h2, s2, v2 = to_hsv(np.asarray(Image.fromarray(out).resize((200,200))).astype(np.float32)/255.0)
pink = (((h2>=285)&(h2<=360))|(h2<=12)) & (s2>0.12) & (v2>0.30)
print(f"{dst.split('/')[-1]:38} pink={pink.mean()*100:5.1f}%  sat={s2[pink].mean():.2f}")
