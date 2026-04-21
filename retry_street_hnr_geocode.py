import json
import re
import time
import urllib.parse
import urllib.request
from pathlib import Path

root = Path('d:/GIT/Marius')
failed_path = root / 'import_delta_2026_geocode_failed.json'
out_success = root / 'import_delta_2026_geocode_retry_street_hnr_success.json'
out_failed = root / 'import_delta_2026_geocode_retry_street_hnr_failed.json'
progress_path = root / 'import_delta_2026_geocode_retry_street_hnr_progress.json'

rows = json.loads(failed_path.read_text(encoding='utf-8'))
UA = 'NOVUM-ZIV-Import-2026/1.0 street+hnr-retry-q'

STREET_FIX = {
    'weimarar': 'weimarer',
    'rosinagsse': 'rosinagasse',
    'costenblegasse': 'costenoblegasse',
}


def clean_street(s: str) -> str:
    s = (s or '').strip()
    s = re.sub(r'(?i)\b(top|og|stiege|haus|rh|shop|med)\b\.?', ' ', s)
    s = re.sub(r'\s+', ' ', s).strip(' ,-/')
    low = s.lower()
    for wrong, right in STREET_FIX.items():
        low = re.sub(rf'\b{re.escape(wrong)}\b', right, low)
    return low


def simplify_hnr(h: str) -> str:
    h = (h or '').strip()
    h = re.split(r'[/-]', h, maxsplit=1)[0].strip()
    m = re.match(r'^(\d+[a-zA-Z]?)', h)
    return m.group(1) if m else h


def geocode_q(street: str, hnr: str):
    q = ', '.join(x for x in [f'{street} {hnr}'.strip(), 'Wien'] if x)
    params = {
        'format': 'json', 'limit': 1, 'countrycodes': 'at', 'addressdetails': 0,
        'q': q,
    }
    url = 'https://nominatim.openstreetmap.org/search?' + urllib.parse.urlencode(params)
    req = urllib.request.Request(url, headers={'User-Agent': UA})
    with urllib.request.urlopen(req, timeout=20) as resp:
        data = json.loads(resp.read().decode('utf-8'))
    if not data:
        return None
    first = data[0]
    return {
        'lat': float(first['lat']),
        'lon': float(first['lon']),
        'geo_name': (first.get('display_name') or '').split(',')[0].strip() or None,
    }

state = {'success': [], 'failed': [], 'done_keys': []}
if progress_path.exists():
    progress_path.unlink()

success = []
still_failed = []
done_keys = set()

for item in rows:
    p = item.get('parsed', {})
    key = f"{p.get('arzt_name','').strip().lower()}|{p.get('strasse','').strip().lower()}|{(p.get('hausnummer') or '').strip().lower()}"
    if key in done_keys:
        continue

    st = clean_street(p.get('strasse') or '')
    hn = simplify_hnr(p.get('hausnummer') or '')

    hit = None
    last_err = None
    for attempt in range(3):
        try:
            hit = geocode_q(st, hn)
            if hit:
                break
            last_err = 'not_found'
            break
        except Exception as e:
            last_err = str(e)
            if '429' in last_err and attempt < 2:
                time.sleep(4.0 * (attempt + 1))
                continue
            break

    if hit:
        success.append({'parsed': p, 'retry_street': st, 'retry_hausnummer': hn, 'lat': hit['lat'], 'lon': hit['lon'], 'geo_name': hit['geo_name']})
    else:
        still_failed.append({'parsed': p, 'retry_street': st, 'retry_hausnummer': hn, 'geocode_error': last_err})

    done_keys.add(key)
    if len(done_keys) % 10 == 0:
        progress_path.write_text(json.dumps({'success': success, 'failed': still_failed, 'done_keys': sorted(done_keys)}, ensure_ascii=False, indent=2), encoding='utf-8')

    if len(done_keys) <= 3 or len(done_keys) % 25 == 0:
        status = 'OK' if hit else 'FAIL'
        print(f'[{len(done_keys)}/{len(rows)}] {status}: {st} {hn}')
    time.sleep(1.1)

progress_path.write_text(json.dumps({'success': success, 'failed': still_failed, 'done_keys': sorted(done_keys)}, ensure_ascii=False, indent=2), encoding='utf-8')
out_success.write_text(json.dumps(success, ensure_ascii=False, indent=2), encoding='utf-8')
out_failed.write_text(json.dumps(still_failed, ensure_ascii=False, indent=2), encoding='utf-8')
print(f'success={len(success)} failed={len(still_failed)} done={len(done_keys)}')
print(f'out_success={out_success.name}')
print(f'out_failed={out_failed.name}')
