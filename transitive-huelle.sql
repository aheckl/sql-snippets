-- Testen moeglich unter https://hyper-db.de/interface.html


-- Schritt 1: direkte Vorgaenger von "Der Wiener Kreis" ==> Ergebnis: Wissenschaftstheorie (VorlNr 5052)
select vorgaenger 
from voraussetzen, vorlesungen
where nachfolger = vorlnr and titel = 'Der Wiener Kreis'


-- Schritt 2: indireke Vorgaenger von "Der Wiener Kreis" ==> Ergebnis: Erkenntnistheorie (VorlNr 5043) und Bioethik(VorlNr 5041)
select v1.vorgaenger
from voraussetzen v1, voraussetzen v2, vorlesungen v
where v1.nachfolger=v2.vorgaenger and v2.nachfolger = v.vorlnr and v.titel = 'Der Wiener Kreis'


-- transitive Huelle: alle Vorgaenger von "Der Wiener Kreis", also beliebige Tiefe
-- ==> Ergebnis: Grundzuege, Ethik, Erkenntnistheorie, Wissenschaftstheorie
with recursive transVorl (vorg, nachf)
as ( select vorgaenger, nachfolger from voraussetzen
	union all
	select t.vorg, v.nachfolger
	from transVorl t, voraussetzen v
	where t.nachf = v.vorgaenger)

select titel from vorlesungen where vorlnr in
	(select vorg from transVorl where nachf in
		(select vorlnr from vorlesungen where titel = 'Der Wiener Kreis'))
