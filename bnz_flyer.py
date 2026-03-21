#!/usr/bin/env python3
"""
BNZ Wien – Standespolitik Flyer Recreation
Recreates the flyer as a layered-friendly PNG for editing in GIMP.
Run:  python bnz_flyer.py
Output: bnz_flyer.png
"""

from PIL import Image, ImageDraw, ImageFont
import math, random

# ── font helpers ──────────────────────────────────────────────────────────────
def try_font(paths, size):
    for p in paths:
        try:
            return ImageFont.truetype(p, size)
        except OSError:
            pass
    return ImageFont.load_default()

def tw(draw, text, font):
    return draw.textbbox((0, 0), text, font=font)[2]

# ── drawing helpers ───────────────────────────────────────────────────────────
def rrect(draw, xy, r, fill=None):
    """Filled rounded rectangle."""
    x1, y1, x2, y2 = xy
    draw.rectangle([x1 + r, y1, x2 - r, y2], fill=fill)
    draw.rectangle([x1, y1 + r, x2, y2 - r], fill=fill)
    draw.ellipse([x1, y1, x1 + 2*r, y1 + 2*r], fill=fill)
    draw.ellipse([x2 - 2*r, y1, x2, y1 + 2*r], fill=fill)
    draw.ellipse([x1, y2 - 2*r, x1 + 2*r, y2], fill=fill)
    draw.ellipse([x2 - 2*r, y2 - 2*r, x2, y2], fill=fill)

def draw_checkmark(draw, cx, cy, size, color, line_w=3):
    """Draw a simple checkmark."""
    s = size
    pts = [(cx - s*0.4, cy), (cx - s*0.05, cy + s*0.4), (cx + s*0.45, cy - s*0.4)]
    draw.line([pts[0], pts[1]], fill=color, width=line_w)
    draw.line([pts[1], pts[2]], fill=color, width=line_w)

def draw_lines_icon(draw, cx, cy, size, color, line_w=3):
    """Draw three horizontal lines (hamburger/list icon)."""
    for i, dy in enumerate([-size*0.35, 0, size*0.35]):
        y = int(cy + dy)
        draw.line([(cx - size*0.4, y), (cx + size*0.4, y)], fill=color, width=line_w)

def draw_calendar_icon(draw, cx, cy, size, color, line_w=2):
    """Draw a simple calendar icon."""
    s = size
    draw.rectangle([cx - s*0.45, cy - s*0.4, cx + s*0.45, cy + s*0.45],
                   outline=color, width=line_w)
    draw.line([(cx - s*0.45, cy - s*0.1), (cx + s*0.45, cy - s*0.1)],
              fill=color, width=line_w)
    draw.line([(cx - s*0.15, cy - s*0.5), (cx - s*0.15, cy - s*0.25)],
              fill=color, width=line_w)
    draw.line([(cx + s*0.15, cy - s*0.5), (cx + s*0.15, cy - s*0.25)],
              fill=color, width=line_w)

# ── colours ───────────────────────────────────────────────────────────────────
BG         = (190, 186, 232)
NAVY       = (16,  26,  95)
YELLOW     = (255, 215,  0)
YELLOW_L   = (255, 235, 80)
WHITE      = (255, 255, 255)
NET_COL    = (172, 168, 218)
OVAL_COL   = (205, 202, 240)
RED_CAL    = (210,  35,  35)

# ── font paths ────────────────────────────────────────────────────────────────
ARIAL      = ["C:/Windows/Fonts/arial.ttf",
              "/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf"]
ARIAL_B    = ["C:/Windows/Fonts/arialbd.ttf",
              "/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf"]
ARIAL_I    = ["C:/Windows/Fonts/ariali.ttf",
              "/usr/share/fonts/truetype/liberation/LiberationSans-Italic.ttf"]
ARIAL_BI   = ["C:/Windows/Fonts/arialbi.ttf",
              "/usr/share/fonts/truetype/liberation/LiberationSans-BoldItalic.ttf"]

# ── main builder ──────────────────────────────────────────────────────────────
def build():
    W, H = 710, 950

    img  = Image.new("RGB", (W, H), BG)
    draw = ImageDraw.Draw(img)

    # ── 1. Network dot-and-line background ───────────────────────────────────
    random.seed(42)
    pts = [(random.randint(10, W - 10), random.randint(10, H - 10)) for _ in range(32)]
    for i, a in enumerate(pts):
        for j, b in enumerate(pts):
            if i < j and math.dist(a, b) < 185:
                draw.line([a, b], fill=NET_COL, width=1)
    for x, y in pts:
        r = 4
        draw.ellipse([x - r, y - r, x + r, y + r], fill=NET_COL)

    # ── 2. Central pale oval ─────────────────────────────────────────────────
    ox, oy = W // 2, 375
    draw.ellipse([ox - 238, oy - 200, ox + 238, oy + 200], fill=OVAL_COL)

    # ── 3. BNZ WIEN logo (top-left) ──────────────────────────────────────────
    lx, ly = 28, 26
    icon_r = 27
    icx = lx + icon_r
    icy = ly + icon_r + 6

    # outer ring + inner ring
    draw.ellipse([icx - icon_r,     icy - icon_r,
                  icx + icon_r,     icy + icon_r],     outline=NAVY, width=3)
    draw.ellipse([icx - icon_r + 5, icy - icon_r + 5,
                  icx + icon_r - 5, icy + icon_r - 5], outline=NAVY, width=2)
    # X strokes
    d = int(icon_r * 0.55)
    draw.line([icx - d, icy - d, icx + d, icy + d], fill=NAVY, width=3)
    draw.line([icx + d, icy - d, icx - d, icy + d], fill=NAVY, width=3)

    f_bnz  = try_font(ARIAL_B, 34)
    f_wien = try_font(ARIAL_B, 18)
    f_sub  = try_font(ARIAL,   12)

    tx = icx + icon_r + 10
    draw.text((tx,                             ly + 5),  "BNZ",  font=f_bnz,  fill=NAVY)
    draw.text((tx + tw(draw, "BNZ", f_bnz) + 6, ly + 13), "WIEN", font=f_wien, fill=NAVY)
    draw.text((tx, ly + 44), "Bündnis NOVUM\u2013ZIV",       font=f_sub,  fill=NAVY)

    # ── 4. Yellow speech bubble (top-right) ──────────────────────────────────
    bx, by = W - 218, 16
    bw, bh = 202, 84
    rrect(draw, [bx, by, bx + bw, by + bh], 14, fill=YELLOW)
    # tail pointing bottom-left
    draw.polygon([(bx + 22, by + bh), (bx + 8, by + bh + 18), (bx + 52, by + bh)],
                 fill=YELLOW)

    f_bb = try_font(ARIAL_B, 15)
    f_br = try_font(ARIAL,   14)
    draw.text((bx + 12, by +  8), "Kostenloses Webinar",   font=f_bb, fill=NAVY)
    draw.text((bx + 12, by + 30), "jeden letzten Montag",  font=f_br, fill=NAVY)
    draw.text((bx + 55, by + 52), "im Monat",              font=f_br, fill=NAVY)

    # ── 5. "reden wir über" heading ──────────────────────────────────────────
    f_tag = try_font(ARIAL_I, 46)
    tl = "reden wir über"
    draw.text(((W - tw(draw, tl, f_tag)) // 2, 122), tl, font=f_tag, fill=NAVY)

    # ── 6. STANDESPOLITIK dark banner ────────────────────────────────────────
    ban_y, ban_h = 180, 70
    draw.rectangle([18, ban_y, W - 18, ban_y + ban_h], fill=NAVY)
    f_ban = try_font(ARIAL_B, 43)
    bt = "STANDESPOLITIK"
    draw.text(((W - tw(draw, bt, f_ban)) // 2, ban_y + 11), bt, font=f_ban, fill=WHITE)

    # ── 7. Yellow badges ─────────────────────────────────────────────────────
    f_bdg = try_font(ARIAL_B, 17)

    def badge(y_pos, icon_fn, label):
        bx2, byw, bhh = 28, 308, 46
        rrect(draw, [bx2, y_pos, bx2 + byw, y_pos + bhh], 6, fill=YELLOW)
        # icon drawn in a small box
        icon_cx = bx2 + 22
        icon_cy = y_pos + bhh // 2
        icon_fn(draw, icon_cx, icon_cy, 20, NAVY, line_w=3)
        draw.text((bx2 + 42, y_pos + 14), label, font=f_bdg, fill=NAVY)

    badge(534, draw_checkmark,  "BVA Pilotprojekt")
    badge(588, draw_lines_icon, "Privatambulatorien")

    # ── 8. "Diskutieren" bullet ──────────────────────────────────────────────
    f_blt = try_font(ARIAL_B, 17)
    draw.text((28, 648), "\u2022  Diskutieren wir gemeinsam",   font=f_blt, fill=NAVY)
    draw.text((48, 672), "aktuelle Standesthemen!",             font=f_blt, fill=NAVY)

    # ── 9. Kostenlos label + small text ──────────────────────────────────────
    rrect(draw, [28, 708, 162, 736], 5, fill=YELLOW)
    f_kl = try_font(ARIAL_B, 16)
    draw.text((38, 715), "Kostenlos", font=f_kl, fill=NAVY)

    f_sm = try_font(ARIAL, 15)
    draw.text((28, 744), "\u2022  Offen für alle interessierten Kolleginnen",
              font=f_sm, fill=NAVY)
    draw.text((48, 764), "und Kollegen aus der Zahnmedizin", font=f_sm, fill=NAVY)

    # ── 10. Calendar widget (bottom-right) ────────────────────────────────────
    cax, cay = W - 200, 618
    caw, cah = 174, 155

    # drop shadow
    draw.rectangle([cax + 5, cay + 5, cax + caw + 5, cay + cah + 5],
                   fill=(155, 150, 205))
    # body
    rrect(draw, [cax, cay, cax + caw, cay + cah], 10, fill=WHITE)
    # red header
    draw.rectangle([cax, cay, cax + caw, cay + 42], fill=RED_CAL)
    # round top corners of red header properly
    draw.ellipse([cax, cay, cax + 20, cay + 20], fill=RED_CAL)
    draw.ellipse([cax + caw - 20, cay, cax + caw, cay + 20], fill=RED_CAL)
    draw.rectangle([cax + 10, cay, cax + caw - 10, cay + 10], fill=RED_CAL)
    # calendar rings
    for rx in [cax + 42, cax + 87, cax + 132]:
        rrect(draw, [rx - 6, cay - 10, rx + 6, cay + 10], 3, fill=(175, 28, 28))
        rrect(draw, [rx - 4, cay - 8,  rx + 4, cay + 5],  2, fill=WHITE)

    f_cs = try_font(ARIAL,   14)
    f_cm = try_font(ARIAL_B, 28)
    draw.text((cax + 12, cay + 48), "Jeden letzten", font=f_cs, fill=NAVY)
    draw.text((cax + 12, cay + 66), "Montag",        font=f_cm, fill=NAVY)
    draw.text((cax + 12, cay + 98), "im Monat",      font=f_cs, fill=NAVY)

    # red circle with minus (no-entry symbol at calendar bottom-right)
    ecx = cax + caw - 22
    ecy = cay + cah - 18
    er  = 16
    draw.ellipse([ecx - er, ecy - er, ecx + er, ecy + er], fill=RED_CAL)
    draw.rectangle([ecx - er + 5, ecy - 4, ecx + er - 5, ecy + 4], fill=WHITE)

    # ── 11. Bottom dark banner ────────────────────────────────────────────────
    bot_y = H - 74
    draw.rectangle([0, bot_y, W, H], fill=NAVY)

    # calendar icon
    draw_calendar_icon(draw, 34, bot_y + 37, 26, WHITE, line_w=2)

    f_bot = try_font(ARIAL_B, 22)
    bot_t = "Jeden letzten "
    f_bot2 = try_font(ARIAL_BI, 22)
    bot_tb = "Montag"
    f_bot3 = try_font(ARIAL_B, 22)
    bot_tc = " im Monat"

    # "Jeden letzten" normal, "Montag" bold-italic, "im Monat" normal
    x_cur = (W - tw(draw, "Jeden letzten Montag im Monat", f_bot)) // 2 + 18
    draw.text((x_cur, bot_y + 25), bot_t,  font=f_bot,  fill=WHITE)
    x_cur += tw(draw, bot_t, f_bot)
    draw.text((x_cur, bot_y + 25), bot_tb, font=f_bot2, fill=WHITE)
    x_cur += tw(draw, bot_tb, f_bot2)
    draw.text((x_cur, bot_y + 25), bot_tc, font=f_bot3, fill=WHITE)

    # ── save ─────────────────────────────────────────────────────────────────
    out = "bnz_flyer.png"
    img.save(out, optimize=True)
    print(f"Saved → {out}  ({W}×{H} px)")
    print("Open in GIMP: File > Open > bnz_flyer.png")

if __name__ == "__main__":
    build()
