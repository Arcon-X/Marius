import warnings
warnings.filterwarnings('ignore')
from duckduckgo_search import DDGS

tests = [
    'Dr. Georg Piehslinger Zahnarzt Bösendorferstraße 4 Wien',
    'Dr. Sabine Sobalik Zahnarzt Brünner Straße 34-38 Wien',
    'Dr. Pia Faber-Miklautz Zahnarzt Mariahilfer Straße 117 Wien',
    'Dr. Daniel Bank Zahnarzt Wiedner Hauptstraße 39 Wien',
    'Dr. Michaela Niebauer Zahnarzt Eisenstadtplatz 4 Wien',
]
for q in tests:
    print(f'Query: {q}')
    with DDGS() as ddgs:
        for r in ddgs.text(q, max_results=5):
            print(f'  {r.get("href","?")}')
    print()
