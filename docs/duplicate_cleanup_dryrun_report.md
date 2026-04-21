# Duplicate Cleanup Dry-Run Report

Stand: 2026-04-21 14:22:43

## Regel (noch keine Loeschung)
- Nur exakte Duplikate auf Person+Adresse:
  - normalisiert: arzt_name, strasse, hausnummer, zusatz
- KEEP-Regel je Gruppe:
  - bevorzugt Datensatz mit geo_name != PENDING_GEOCODE
  - danach kleinster import_batch (lexikografisch)
  - danach kleinste id

## Zahlen
- Gruppen mit Duplikaten: 22
- KEEP-Zeilen: 22
- DELETE-Kandidaten: 22

## Dateien
- Vollaudit (KEEP+DELETE): docs/duplicate_groups_audit_dryrun.csv
- Nur geplante Loeschungen: docs/duplicate_delete_candidates_dryrun.csv

## Top 20 Gruppen (nach Groesse)
- 2x | Marina Dodig Pernar | Thaliastra├ƒe 1 12 | keep=f0f510d1-cf95-4d99-9f62-91cde5b2b5ab
- 2x | Omar Ali Hussein Al-Azzawi | Nibelungengasse 1-3 62 | keep=91c92381-d472-4e04-93eb-adfe2033dc96
- 2x | Leyla Djafari | Ramperstorffergasse 68  | keep=543dac33-ddea-46b1-902c-2b96ad23ab7d
- 2x | Julia D┬┤Aron | D├Âblinger Hauptstra├ƒe 7 11 | keep=462fb674-4cf7-4e66-a073-aaf21c15c3c0
- 2x | Leali Heyman Levkowich | Wiedner Hauptstra├ƒe 61  | keep=1a1536fd-e308-4e07-898d-6cdc81eeced4
- 2x | Sabiha Merve Cicay | Ocwirkgasse 7 3/17 | keep=ed9be56f-2368-4066-951f-94b6f637e653
- 2x | Tannaz Azimzadeh Milani | Sensengasse 2A  | keep=91436250-d2a5-4d15-b25c-c857a4fab91a
- 2x | Tatiana Della Torre | Ramperstorffergasse 68  | keep=a1cb172d-04e9-4587-82ec-15f0b7cd8bf4
- 2x | Susanna Abd El Nour | Hadikgasse 268 17/13 | keep=fe02abc8-6e26-4ff4-90a4-f1159ad897ae
- 2x | Sami Serdar Beklen | Sedlitzkygasse 33-35 7 | keep=0090ecff-d67b-4949-a0b5-ddb5ea595df4
- 2x | Sarina Di Bora | Ramperstorffergasse 68  | keep=3578d475-7760-48d2-a3f1-0e87280ebe5a
- 2x | Andreas Djaber Ansari | Hafnersteig 5 2/DG/24 | keep=d3151b61-ad26-4698-a101-84d2a3f91e51
- 2x | Angelika Valentova BSc | Mei├ƒauergasse 2A 7/65 | keep=7a53f6f2-16b4-4432-b842-b37e35a4b110
- 2x | Amina Alam El Din | Breitenfurterstra├ƒe 360-368 1/R1 | keep=0bae3039-416f-49b5-9895-0cbe189127ec
- 2x | Ali Al Samarrae | Kuefsteingasse 15 4.6 | keep=2b725000-4312-4c1a-8a2a-fad2eb0f2bcc
- 2x | Amer Al Najar | Karl-Aschenbrenner-Gasse 3  | keep=1b70b07c-2757-42b4-aab9-4345a2312226
- 2x | Anna Katharina Kraus | Sobieskigasse 33 59 | keep=139e63f9-deec-4c66-975a-dc907683c7e0
- 2x | Gabriela Garcia de Fleischmann | Leopoldauer Platz 68  | keep=8aeb257a-e9e5-4524-95b2-4153571f8e06
- 2x | Georg Mailath-Pokorny | Anton-St├Ârck-Gasse 71  | keep=c83c9208-fb21-4979-b75d-a6dcbed68b01
- 2x | Ekaterina Fakhr Douz Douzani | Lavaterstra├ƒe 6 3/35 | keep=c446118d-5c76-4757-ab5a-e51a61613dc4
