#!/bin/bash
set -e
echo "Klassifiziere Arzt-Namen als Persisch/Arabisch …"

sudo -u postgres psql -d novumziv << 'ENDSQL'
-- Erst alle auf 'de' setzen
UPDATE adressen SET sprache = 'de';

-- Dann Persisch/Arabisch erkennen via Regex auf arzt_name
UPDATE adressen SET sprache = 'pa'
WHERE arzt_name ~* (
  -- Nachnamen-Präfixe
  '(^|\s)(Al[- ]|Abd[eu]?l?[- ]|Ab[ou][- ])'
  -- Nachnamen-Suffixe
  '|(zadeh|pour|khan|nejad|andan|inia|doust|mehr|yar)\s*$'
  '|(zadeh|pour|khan|nejad|andan|inia|doust|mehr|yar)[- ]'
  -- Typische Vornamen (Wortgrenze)
  '|\m(Mohammad|Mohamed|Mohammed|Muhammad|Ahmad|Ahmed|Ali|Hassan|Hasan|Hussein|Hossein|Husein|Hussain)'
  '|\m(Omar|Umar|Omer|Alireza|Reza|Neda|Tannaz|Azadeh|Siamak|Arghavan|Bahar|Nazanin)'
  '|\m(Ghazwan|Firas|Marwa|Shaza|Saeid|Behfar|Afarin|Faten|Sohyl|Abdullah|Abdallah)'
  '|\m(Amir|Hamid|Hamed|Hani|Hashem|Shiva|Parisa|Parviz|Pouya|Babak|Bahram|Farshid|Farhad|Farid)'
  '|\m(Javad|Jafar|Karim|Khalil|Leila|Layla|Maryam|Mehdi|Mehran|Mina|Mojtaba|Mostafa|Mustafa)'
  '|\m(Nader|Nasser|Navid|Nima|Omid|Payam|Saeed|Sajjad|Saman|Samir|Sepehr|Shahram|Shahab)'
  '|\m(Soheila|Soraya|Tahereh|Vahid|Yaser|Yasmin|Zahra|Zeinab|Zohreh)'
  -- Typische Nachnamen
  '|\m(Emami|Oveisi|Homayuni|Sanaei|Pishan|Basharat|Noroozkhan|Farrokhian|Alaghebandan|Dehghani)'
  '|\m(Akhondi|Aktaa|Albarazi|Albuni|Aldaher|Alhamwi|Alhujazy|Alsafar|Alshahel|Altemimy)'
  '|\m(Ibraheem|Ibrahim|Samarrae|Azzawi|Najar)'
);

\echo '=== Ergebnis ==='
SELECT sprache, count(*) AS anzahl FROM adressen GROUP BY sprache ORDER BY sprache;

\echo '=== Persisch/Arabisch Stichprobe (10) ==='
SELECT arzt_name, strasse, plz FROM adressen WHERE sprache='pa' ORDER BY arzt_name LIMIT 10;
ENDSQL

echo "Done."
