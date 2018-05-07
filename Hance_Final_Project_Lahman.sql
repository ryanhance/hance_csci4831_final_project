# Ryan Hance
# 5-6-18
# CSCI 4831
# Final Project continued

use lahman2016;

# Find the RBI and OBP of all players from 2010 to 2013.
# Sort by the top RBI players to compare with TOP%
select b.playerID, m.nameFirst, m.nameLast, sum(b.RBI) as RBI, (sum(b.H) + sum(b.BB) + sum(b.HBP)) 
	/ (sum(b.AB) + sum(b.BB) + sum(b.HBP)) as OBP, sum(b.AB) as AB_tot from batting b
join master m on m.playerID = b.playerID
where b.yearID >= 2010 and b.yearID <= 2013 #and AB_tot >= 1000
group by b.playerID
order by RBI desc;

# Find the RBI and OBP of all players from 2010 to 2013.
# Sort by the top OBP players to compare with TOP%
select b.playerID, m.nameFirst, m.nameLast, sum(b.RBI) as RBI, (sum(b.H) + sum(b.BB) + sum(b.HBP)) 
	/ (sum(b.AB) + sum(b.BB) + sum(b.HBP)) as OBP, sum(b.AB) as AB_tot from batting b
join master m on m.playerID = b.playerID
where b.yearID >= 2010 and b.yearID <= 2013 #and AB_tot >= 1000
group by b.playerID
order by OBP desc;