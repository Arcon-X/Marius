SELECT website, COUNT(*) AS cnt FROM adressen WHERE verifiziert = true GROUP BY website ORDER BY cnt DESC;
