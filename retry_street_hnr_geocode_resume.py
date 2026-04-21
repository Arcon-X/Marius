import json
import re
import time
import urllib.parse
import urllib.request
from pathlib import Path

root = Path('d:/GIT/Marius')
rows = json.loads((root / 'import_delta_2026_geocode_failed.json').read_text(encoding='utf-8'))
progress = root / 'import_delta_2026_geocode_retry_street_hnr_progress.json'
out_ok = root / 'import_delta_2026_geocode_retry_street_hnr_success.json'
out_fail = root / 'import_delta_2026_geocode_retry_street_hnr_failed.json'

UA = 'NOVUM-ZIV-Import-2026/1.0 street+hnr-retry-q'
fix = {
    'weimarar': 'weimarer',
    'rosinagsse': 'rosinagasse',
    'costenblegasse': 'costenoblegasse',
}

state = {'success': [], 'failed': [], 'done_keys': []}
if progress.exists():
    state = json.loads(progress.read_text(encoding='utf-8'))

success = state.get('success', [])
failed = state.get('failed', [])
done = set(state.get('done_keys', []))


def cstreet(s: str) -> str:
    s = (s or '').strip()
    s = re.sub(r'(?i)\b(top|og|stiege|haus|rh|shop|med)\b\.?', ' ', s)
    s = re.sub(r'\s+', ' ', s).strip(' ,-/').lower()
    for wrong, right in fix.items():
        s = re.sub(rf'\b{re.escape(wrong)}\b', right, s)
    return s


def shnr(h: str) -> str:
    h = (h or '').strip()
    h = re.split(r'[/-]', h, maxsplit=1)[0].strip()
    m = re.match(r'^(\d+[a-zA-Z]?)', h)
    return m.group(1) if m else h


def geo(st: str, hn: str):
    q = ', '.join(x for x in [f'{st} {hn}'.strip(), 'Wien'] if x)
    params = {
        'format': 'json',
        'limit': 1,
        'countrycodes': 'at',
        'addressdetails': 0,
        'q': q,
    }
    u = 'https://nominatim.openstreetmap.org/search?' + urllib.parse.urlencode(params)
    req = urllib.request.Request(u, headers={'User-Agent': UA})
    with urllib.request.urlopen(req, timeout=20) as resp:
        d = json.loads(resp.read().decode('utf-8'))
    if not d:
        return None
    first = d[0]
    return {
        'lat': float(first['lat']),
        'lon': float(first['lon']),
        'geo_name': (first.get('display_name') or '').split(',')[0].strip() or None,
    }

for item in rows:
    p = item.get('parsed', {})
    key = f"{(p.get('arzt_name') or '').strip().lower()}|{(p.get('strasse') or '').strip().lower()}|{(p.get('hausnummer') or '').strip().lower()}"
    if key in done:
        continue

    st = cstreet(p.get('strasse') or '')
    hn = shnr(p.get('hausnummer') or '')

    hit = None
    err = None
    for a in range(3):
        try:
            hit = geo(st, hn)
            if hit:
                break
            err = 'not_found'
            break
        except Exception as e:
            err = str(e)
            if '429' in err and a < 2:
                time.sleep(4.0 * (a + 1))
                continue
            break

    if hit:
        success.append({'parsed': p, 'retry_street': st, 'retry_hausnummer': hn, 'lat': hit['lat'], 'lon': hit['lon'], 'geo_name': hit['geo_name']})
    else:
        failed.append({'parsed': p, 'retry_street': st, 'retry_hausnummer': hn, 'geocode_error': err})

    done.add(key)
    if len(done) <= 3 or len(done) % 25 == 0:
        print(f"[{len(done)}/{len(rows)}] {'OK' if hit else 'FAIL'}: {st} {hn}")
    if len(done) % 10 == 0:
        progress.write_text(json.dumps({'success': success, 'failed': failed, 'done_keys': sorted(done)}, ensure_ascii=False, indent=2), encoding='utf-8')
    time.sleep(1.1)

progress.write_text(json.dumps({'success': success, 'failed': failed, 'done_keys': sorted(done)}, ensure_ascii=False, indent=2), encoding='utf-8')
out_ok.write_text(json.dumps(success, ensure_ascii=False, indent=2), encoding='utf-8')
out_fail.write_text(json.dumps(failed, ensure_ascii=False, indent=2), encoding='utf-8')
print('success=', len(success), 'failed=', len(failed), 'done=', len(done))
