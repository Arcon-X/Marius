-- Revert alle falschen Websites: nur echte Zahnarzt-Websites behalten
UPDATE adressen
SET website = NULL, verifiziert = false
WHERE verifiziert = true
  AND website NOT LIKE '%piehslinger.at%'
  AND website NOT LIKE '%zahnzentrum.wien%'
  AND website NOT LIKE '%zahnarzt-natasavukajlovic.at%'
  AND website NOT LIKE '%zahnundkiefer.at%'
  AND website NOT LIKE '%faber-miklautz.at%'
  AND website NOT LIKE '%zahnarzt-niebauer.at%'
  AND website NOT LIKE '%dentac.at%'
  AND website NOT LIKE '%dr-sobalik.at%';
