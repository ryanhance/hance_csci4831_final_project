# Ryan Hance
# 4-29-18
# CSCI 4831
# Final Project - Two-Out Performance %

use retrosheet;

# Find the number of times the batter scored the runner from 1B with 2 outs.
# Events 4-13 are not events controlled by batter (i.e. balk, wild pitch, SB, etc)
DROP TABLE IF EXISTS Score_Bat;
CREATE TABLE Score_Bat as
	select bat_id, count(*) as scoreBat from events e
		where (e.EVENT_CD < 4 or e.EVENT_CD > 13) and bat_DEST_ID = 4 and outs_ct = 2
		group by e.bat_id;

# Find the number of times the batter scored the runner from 1B with 2 outs.
# Events 4-13 are not events controlled by batter (i.e. balk, wild pitch, SB, etc)
DROP TABLE IF EXISTS Score_1B;
CREATE TABLE Score_1B as
	select bat_id, count(*) as score1b from events e
		where (e.EVENT_CD < 4 or e.EVENT_CD > 13) and run1_DEST_ID = 4 and outs_ct = 2
		group by e.bat_id;
    
# Find the number of times the batter scored the runner from 2B with 2 outs.
# Events 4-13 are not events controlled by batter (i.e. balk, wild pitch, SB, etc)
DROP TABLE IF EXISTS Score_2B;
CREATE TABLE Score_2B as
	select bat_id, count(*) as score2b from events e
		where (e.EVENT_CD < 4 or e.EVENT_CD > 13) and run2_DEST_ID = 4 and outs_ct = 2
		group by e.bat_id;
        
# Find the number of times the batter scored the runner from 3B with 2 outs.
# Events 4-13 are not events controlled by batter (i.e. balk, wild pitch, SB, etc)
DROP TABLE IF EXISTS Score_3B;
CREATE TABLE Score_3B as
	select bat_id, count(*) as score3b from events e
		where (e.EVENT_CD < 4 or e.EVENT_CD > 13) and run3_DEST_ID = 4 and outs_ct = 2
		group by e.bat_id;
        
# Find the number of times the batter did not score a runner but got a BB, IBB, HBP, or hit.
# Events 4-13 are not events controlled by batter (i.e. balk, wild pitch, SB, etc)
DROP TABLE IF EXISTS NoScore;
CREATE TABLE NoScore as
	select bat_id, count(*) as noScore from events e
		where ((e.EVENT_CD >= 14 and e.EVENT_CD <= 16) or e.EVENT_CD >= 20) 
        and (BASE2_RUN_ID != "" or BASE3_RUN_ID != "") and outs_ct = 2 and EVENT_RUNS_CT = 0
		group by e.bat_id;
        
# Find the number of times the batter had an opportunity to score runners in scoring position with two out.
# Events 4-13 are not events controlled by batter (i.e. balk, wild pitch, SB, etc)
DROP TABLE IF EXISTS Score_Opp;
CREATE TABLE Score_Opp as
	select bat_id, count(*) as scoreOpp from events e
		where (e.EVENT_CD < 4 or e.EVENT_CD > 13) and (BASE2_RUN_ID != "" or BASE3_RUN_ID != "") and outs_ct = 2
		group by e.bat_id;
        
# Find the number of times the batter got on base with two outs.
# Events 4-13 are not events controlled by batter (i.e. balk, wild pitch, SB, etc)
DROP TABLE IF EXISTS OnBase;
CREATE TABLE OnBase as
	select bat_id, count(*) as onBase from events e
		where ((e.EVENT_CD >= 14 and e.EVENT_CD <= 16) or e.EVENT_CD >= 20) and outs_ct = 2
		group by e.bat_id;
        
# Find the number of times the batter had a plate appearance with two outs.
# Events 4-13 are not events controlled by batter (i.e. balk, wild pitch, SB, etc)
DROP TABLE IF EXISTS PlateApp;
CREATE TABLE PlateApp as
	select bat_id, count(*) as plateApp from events e
		where (e.EVENT_CD <= 3 or (e.EVENT_CD >= 14 and e.EVENT_CD <= 16) or e.EVENT_CD >= 18) and outs_ct = 2
		group by e.bat_id;
        
# Join all the tables and calculate score
select s1.bat_id, i.first, i.last, sb.scoreBat as score_bat, s1.score1b as score_1b, s2.score2b as score_2b, 
	s3.score3b as score_3b, ns.noScore as no_score, opp.scoreOpp as score_opp, (1.5 * sb.scoreBat + 1.5  
    * s1.score1b + s2.score2b + s3.score3b + .5 * ns.noScore) / opp.scoreOpp as ATOR, ob.onBase / pa.plateApp as OBP,
    (1.5 * sb.scoreBat + 1.5 * s1.score1b + s2.score2b + s3.score3b + .5 * ns.noScore) / opp.scoreOpp 
    + ob.onBase / pa.plateApp as TOPP from Score_1B s1
inner join Score_2B s2 on s1.bat_id = s2.bat_id
inner join Score_3B s3 on s1.bat_id = s3.bat_id
inner join Score_Bat sb on s1.bat_id = sb.bat_id
inner join NoScore ns on s1.bat_id = ns.bat_id
inner join Score_Opp opp on s1.bat_id = opp.bat_id
inner join OnBase ob on s1.bat_id = ob.bat_id
inner join PlateApp pa on s1.bat_id = pa.bat_id
inner join id i on s1.bat_id = i.id
#where opp.scoreOpp >= 100
order by TOPP desc;