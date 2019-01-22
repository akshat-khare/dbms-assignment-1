\timing

--PREAMBLE--
create view cs1160315_paperidcount as select PaperId, count(PaperId) as co from paperByAuthors group by PaperId order by co desc, PaperId;
create view cs1160315_morethan20authors as select PaperId from cs1160315_paperidcount where co > 20;

create view cs1160315_allauthorid as select distinct AuthorId from PaperByAuthors;
create view cs1160315_soleauthorpaper as select PaperId from cs1160315_paperidcount where co=1;
create view cs1160315_authorwhohavesolepapers as select distinct AuthorId from cs1160315_soleauthorpaper, PaperByAuthors where cs1160315_soleauthorpaper.paperid = PaperByAuthors.paperid;
create view cs1160315_targetauthoridq4 as select * from cs1160315_allauthorid except select * from cs1160315_authorwhohavesolepapers;

create view cs1160315_authoridcount as select authorid, count(authorid) as co from paperbyauthors group by authorid order by co desc;
create view cs1160315_top20authorid as select * from cs1160315_authoridcount limit 20;

create view cs1160315_soleauthorpaperwithcount as select AuthorId, count(authorid) as co from cs1160315_soleauthorpaper, PaperByAuthors where cs1160315_soleauthorpaper.paperid = PaperByAuthors.paperid group by authorid order by co desc;
create view cs1160315_targetqueryq6 as select authorid from cs1160315_soleauthorpaperwithcount where co>50;

create view cs1160315_paperjvenue as select paper.paperid, paper.venueid, venue.type from paper, venue where paper.venueid = venue.venueid;
create view cs1160315_journalpapers as select paperid from cs1160315_paperjvenue where type='journals';
create view cs1160315_journalauthors as select distinct authorid from cs1160315_journalpapers ,paperbyauthors where cs1160315_journalpapers.paperid = paperbyauthors.paperid;
create view cs1160315_targetqueryq7 as select * from cs1160315_allauthorid except select * from cs1160315_journalauthors;


create view cs1160315_authorjpaperjvenue as select paperbyauthors.authorid, cs1160315_paperjvenue.paperid, cs1160315_paperjvenue.venueid, cs1160315_paperjvenue.type from paperbyauthors cross join cs1160315_paperjvenue where paperbyauthors.paperid = cs1160315_paperjvenue.paperid;
create view cs1160315_journalauthorid as select distinct authorid from cs1160315_authorjpaperjvenue where type='journals';
create view cs1160315_nonjournalauthorid as select distinct authorid from cs1160315_authorjpaperjvenue where type!='journals';
create view cs1160315_onlyjournalauthorid as select * from cs1160315_journalauthorid except select * from cs1160315_nonjournalauthorid;

create view cs1160315_authoridjpaperayear as select paperByAuthors.authorid, paper.paperid, paper.year from paperbyauthors cross join paper where paperbyauthors.paperid=paper.paperid;
create view cs1160315_authorpaperyearcount as select authorid, year, count(paperid) as co from cs1160315_authoridjpaperayear group by authorid, year;
create view cs1160315_targetqueryq9 as select distinct authorid from cs1160315_authorpaperyearcount where year=2012 and co>1 intersect select distinct authorid from cs1160315_authorpaperyearcount where year=2013 and co>2;

create view cs1160315_paperjvenueaname as select paper.paperid, paper.venueid, venue.type, venue.name from paper, venue where paper.venueid = venue.venueid;
create view cs1160315_authorjpaperjvenueaname as select paperbyauthors.authorid, cs1160315_paperjvenueaname.paperid, cs1160315_paperjvenueaname.venueid, cs1160315_paperjvenueaname.type, cs1160315_paperjvenueaname.name from paperbyauthors cross join cs1160315_paperjvenueaname where paperbyauthors.paperid = cs1160315_paperjvenueaname.paperid;
create view cs1160315_corrjournal as select * from cs1160315_authorjpaperjvenueaname where type='journals' and name='corr';
create view cs1160315_targetqueryq10 as select authorid, count(authorid) as co from cs1160315_corrjournal group by authorid order by co desc limit 20;

create view cs1160315_amcjournal as select * from cs1160315_authorjpaperjvenueaname where type='journals' and name='amc';
create view cs1160315_targetqueryq11interim as select authorid, count(authorid) as co from cs1160315_amcjournal group by authorid;
create view cs1160315_targetqueryq11 as select * from cs1160315_targetqueryq11interim where co>3;

create view cs1160315_ieicetjournal as select * from cs1160315_authorjpaperjvenueaname where type='journals' and name='ieicet';
create view cs1160315_ieicetcount as select authorid, count(authorid) as co from cs1160315_ieicetjournal group by authorid;
create view cs1160315_targetieicet as select authorid from cs1160315_ieicetcount where co>9;
create view cs1160315_tcsjournal as select * from cs1160315_authorjpaperjvenueaname where type='journals' and name='tcs';
create view cs1160315_targettcs as select distinct authorid from cs1160315_tcsjournal;
create view cs1160315_targetqueryq12 as select * from cs1160315_targetieicet except select * from cs1160315_targettcs;


create view cs1160315_queryopti as select paperid from paper where upper(title) like '%QUERY_%OPTIMIZATION%';
create view cs1160315_targetqueryq14 as select distinct authorid from paperbyauthors cross join cs1160315_queryopti where paperbyauthors.paperid=cs1160315_queryopti.paperid;

create view cs1160315_citationcount as select paper2id, count(paper2id) as co from citation group by paper2id;
create view cs1160315_beingcitedcount as select paper1id, count(paper1id) as co from citation group by paper1id;
create view cs1160315_leftoutercit as select paper2id, cs1160315_citationcount.co as co2, paper1id, cs1160315_beingcitedcount.co as co1 from cs1160315_citationcount left outer join cs1160315_beingcitedcount on cs1160315_citationcount.paper2id=cs1160315_beingcitedcount.paper1id;
create view cs1160315_targetqueryq17 as select paper2id from cs1160315_leftoutercit where (co2>co1+10) or (paper1id is null and co2 > 10);

create view cs1160315_noncited as select paperid from paper except select distinct paper2id as paperid from citation;


create view cs1160315_authcite as select paperbyauthors.authorid as author1, paper1id, paper2id from paperbyauthors cross join citation where paperbyauthors.paperid = citation.paper1id;
create view cs1160315_authciteauth as select author1, paper1id, paper2id, paperbyauthors.authorid as author2 from cs1160315_authcite cross join paperbyauthors where cs1160315_authcite.paper2id=paperbyauthors.paperid;
create view cs1160315_targetauthoridq19 as select distinct author1 as author from cs1160315_authciteauth where author1=author2;

create view cs1160315_paperjvenueanameayear as select paper.paperid, paper.year, paper.venueid, venue.name, venue.type from paper cross join venue where paper.venueid=venue.venueid;
create view cs1160315_authorjpaperjvenueanameayear as select paperbyauthors.authorid, paperbyauthors.paperid, cs1160315_paperjvenueanameayear.year, cs1160315_paperjvenueanameayear.venueid, cs1160315_paperjvenueanameayear.name, cs1160315_paperjvenueanameayear.type from paperbyauthors cross join cs1160315_paperjvenueanameayear where paperbyauthors.paperid=cs1160315_paperjvenueanameayear.paperid;
create view cs1160315_targetqueryq20 as select distinct authorid from cs1160315_authorjpaperjvenueanameayear where type='journals' and name='corr' and year>2008 and year < 2014 except select distinct authorid from cs1160315_authorjpaperjvenueanameayear where type='journals' and name='ieicet' and year=2009;

create view cs1160315_journalcountyear as select name, year, count(name) as co from cs1160315_paperjvenueanameayear where year>2008 and year < 2014 and type='journals' group by name, year;
create view cs1160315_y13_12 as select tab2013.name as name, tab2013.year as y2013, tab2013.co as co2013, tab2012.year as y2012, tab2012.co as co2012 from cs1160315_journalcountyear as tab2013, cs1160315_journalcountyear as tab2012 where tab2013.year=2013 and tab2012.year=2012 and tab2013.co>tab2012.co and tab2013.name=tab2012.name;
create view cs1160315_y12_11 as select tab2012.name as name, tab2012.year as y2012, tab2012.co as co2012, tab2011.year as y2011, tab2011.co as co2011 from cs1160315_journalcountyear as tab2012, cs1160315_journalcountyear as tab2011 where tab2012.year=2012 and tab2011.year=2011 and tab2012.co>tab2011.co and tab2012.name=tab2011.name;
create view cs1160315_y11_10 as select tab2011.name as name, tab2011.year as y2011, tab2011.co as co2011, tab2010.year as y2010, tab2010.co as co2010 from cs1160315_journalcountyear as tab2011, cs1160315_journalcountyear as tab2010 where tab2011.year=2011 and tab2010.year=2010 and tab2011.co>tab2010.co and tab2011.name=tab2010.name;
create view cs1160315_y10_09 as select tab2010.name as name, tab2010.year as y2010, tab2010.co as co2010, tab2009.year as y2009, tab2009.co as co2009 from cs1160315_journalcountyear as tab2010, cs1160315_journalcountyear as tab2009 where tab2010.year=2010 and tab2009.year=2009 and tab2010.co>tab2009.co and tab2010.name=tab2009.name;
create view cs1160315_y10_09addon as select distinct name from cs1160315_journalcountyear where year=2010 except select distinct name from cs1160315_journalcountyear where year=2009;
create view cs1160315_y10_09total as select distinct name from cs1160315_y10_09 union select distinct name from cs1160315_y10_09addon;
create view cs1160315_targetqueryq21 as select distinct name from cs1160315_y13_12 intersect select distinct name from cs1160315_y12_11 intersect select distinct name from cs1160315_y11_10 intersect select distinct name from cs1160315_y10_09total order by name; 

create view cs1160315_journalcountyearall as select name, year, count(name) as co from cs1160315_paperjvenueanameayear where type='journals' group by name, year;

create view cs1160315_authorjournal as select authorid, name , count(authorid) as co from cs1160315_authorjpaperjvenueaname where type='journals' group by authorid, name;
create view cs1160315_targetqueryq23 as select authorid, name from cs1160315_authorjournal where co=(select max(co) from cs1160315_authorjournal);

create view paperjvenueq24 as select paper.paperid, paper.year, venue.name from paper cross join venue where paper.venueid=venue.venueid and paper.year>2006 and paper.year<2010 and venue.type='journals';
create view journcite as select paperjvenueq24.paperid as paper1id, paperjvenueq24.year as paper1year, paperjvenueq24.name as paper1name, citation.paper2id as paper2id from paperjvenueq24, citation where paperjvenueq24.paperid=citation.paper1id;
create view journcitejourn as select journcite.paper1id, journcite.paper1year, journcite.paper1name, journcite.paper2id as paper2id, paperjvenueq24.year as paper2year, paperjvenueq24.name as paper2name from journcite, paperjvenueq24 where journcite.paper2id=paperjvenueq24.paperid;
create view cittable as select paper2name as citpapername, count(paper2name) as citco from journcitejourn where (paper2year=2007 or paper2year=2008) and paper1year=2009 group by paper2name;
create view pubtable as select name as pubpapername, count(name) as pubco from paperjvenueq24 where paperjvenueq24.year=2007 or paperjvenueq24.year=2008 group by name;
create view havetable as select pubtable.pubpapername as name, citco/pubco as co from pubtable, cittable where pubpapername=citpapername;
create view nottableinterim as select pubpapername as name from pubtable except select citpapername as name from cittable; 
create view notable as select name, 0 as co from nottableinterim;
create view targetqueryq24 as select * from havetable union select * from notable order by co desc, name;

create view papercitcount as select paper2id as paperid, count(paper2id) as co from citation group by paper2id;
create view authoridjcitcount as select authorid, paperbyauthors.paperid, co from paperbyauthors, papercitcount where paperbyauthors.paperid=papercitcount.paperid;
create view addedrow as select row_number() over (partition by authorid order by co desc), authorid, paperid, co from authoridjcitcount;
create view curbrow as select * from addedrow where row_number<=co order by authorid, co desc;
create view authoridhindex as select authorid, max(row_number) from curbrow group by authorid;
create view zeroauthors as select distinct authorid from author except select authorid from authoridhindex;
create view finauthoridhindex as select authorid, 0 as max from zeroauthors union select * from authoridhindex;


--just apply "order by title asc" at the end of the query--

--1--
select type, count(type) as co from venue group by type order by co desc, type;
--2--
select avg(co) from cs1160315_paperidcount;
--3--
select Title from cs1160315_morethan20authors, Paper where cs1160315_morethan20authors.Paperid = Paper.Paperid order by Title;
--4--
select name from cs1160315_targetauthoridq4 left outer join author on cs1160315_targetauthoridq4.authorid = author.authorid order by name;
--5--
select name from cs1160315_top20authorid left outer join author on cs1160315_top20authorid.authorid = author.authorid order by co desc, name;
--6--
select name from cs1160315_targetqueryq6 left outer join author on cs1160315_targetqueryq6.authorid = author.authorid order by name;
--before this check the left outer joins, they are wrong probably--
--7--
select name from author, cs1160315_targetqueryq7 where author.authorid = cs1160315_targetqueryq7.authorid order by name;
--8--
select name from cs1160315_onlyjournalauthorid cross join author where cs1160315_onlyjournalauthorid.authorid=author.authorid order by name;
--9--
select name from cs1160315_targetqueryq9 cross join author where cs1160315_targetqueryq9.authorid = author.authorid order by name;
--10--
select name from cs1160315_targetqueryq10, author where cs1160315_targetqueryq10.authorid= author.authorid order by name;
--11--
select name from cs1160315_targetqueryq11, author where cs1160315_targetqueryq11.authorid=author.authorid order by name;
--12--
select name from cs1160315_targetqueryq12, author where cs1160315_targetqueryq12.authorid=author.authorid order by name;
--13--
select year, count(year) as co from paper where year>2003 and year<2014 group by year order by year;
--14--
select count(authorid) from cs1160315_targetqueryq14;
--15--
select title from cs1160315_citationcount, paper where cs1160315_citationcount.paper2id=paper.paperid order by co desc, title;
--16--
select title from cs1160315_citationcount, paper where cs1160315_citationcount.paper2id=paper.paperid and co>10 order by title;
--17--
select title from cs1160315_targetqueryq17, paper where paper.paperid=cs1160315_targetqueryq17.paper2id order by title;
--18--
select title from paper, cs1160315_noncited where paper.paperid = cs1160315_noncited.paperid order by title;
--19--
select name from cs1160315_targetauthoridq19, author where cs1160315_targetauthoridq19.author=author.authorid order by name;
--20--
select name from cs1160315_targetqueryq20, author where cs1160315_targetqueryq20.authorid=author.authorid order by name;
--21--
select * from cs1160315_targetqueryq21;
--22--
select name, year from cs1160315_journalcountyearall where co=(select max(co) from cs1160315_journalcountyearall) order by year, name; 
--23--
select cs1160315_targetqueryq23.name, author.name from author, cs1160315_targetqueryq23 where author.authorid=cs1160315_targetqueryq23.authorid order by cs1160315_targetqueryq23.name, author.name;
--24--
select * from targetqueryq24;
--25--
select name, max as hindex from author, finauthoridhindex where author.authorid=finauthoridhindex.authorid order by hindex desc, name;

--CLEANUP--
drop view finauthoridhindex;
drop view zeroauthors;
drop view authoridhindex;
drop view curbrow;
drop view addedrow;
drop view authoridjcitcount;
drop view papercitcount;
drop view targetqueryq24;
drop view notable;
drop view nottableinterim;
drop view havetable;
drop view pubtable;
drop view cittable;
drop view journcitejourn;
drop view journcite;
drop view paperjvenueq24;
drop view cs1160315_authorjournal;
drop view cs1160315_targetqueryq23;
drop view cs1160315_journalcountyearall;
drop view cs1160315_targetqueryq21;
drop view cs1160315_y10_09total;
drop view cs1160315_y10_09addon;
drop view cs1160315_y10_09;
drop view cs1160315_y11_10;
drop view cs1160315_y12_11;
drop view cs1160315_y13_12;
drop view cs1160315_journalcountyear;
drop view cs1160315_targetqueryq20;
drop view cs1160315_authorjpaperjvenueanameayear;
drop view cs1160315_paperjvenueanameayear;
drop view cs1160315_targetauthoridq19;
drop view cs1160315_authciteauth;
drop view cs1160315_authcite;
drop view cs1160315_noncited;
drop view cs1160315_targetqueryq17;
drop view cs1160315_leftoutercit;
drop view cs1160315_beingcitedcount;
drop view cs1160315_citationcount;
drop view cs1160315_targetqueryq14;
drop view cs1160315_queryopti;
drop view cs1160315_targetqueryq12;
drop view cs1160315_targettcs;
drop view cs1160315_tcsjournal;
drop view cs1160315_targetieicet;
drop view cs1160315_ieicetcount;
drop view cs1160315_ieicetjournal;
drop view cs1160315_targetqueryq11;
drop view cs1160315_targetqueryq11interim;
drop view cs1160315_amcjournal;
drop view cs1160315_targetqueryq10;
drop view cs1160315_corrjournal;
drop view cs1160315_authorjpaperjvenueaname;
drop view cs1160315_paperjvenueaname;
drop view cs1160315_targetqueryq9;
drop view cs1160315_authorpaperyearcount;
drop view cs1160315_authoridjpaperayear;
drop view cs1160315_onlyjournalauthorid;
drop view cs1160315_nonjournalauthorid;
drop view cs1160315_journalauthorid;
drop view cs1160315_authorjpaperjvenue;
drop view cs1160315_targetqueryq7;
drop view cs1160315_journalauthors;
drop view cs1160315_journalpapers;
drop view cs1160315_paperjvenue;
drop view cs1160315_targetqueryq6;
drop view cs1160315_soleauthorpaperwithcount;
drop view cs1160315_top20authorid;
drop view cs1160315_authoridcount;
drop view cs1160315_targetauthoridq4;
drop view cs1160315_authorwhohavesolepapers;
drop view cs1160315_soleauthorpaper;
drop view cs1160315_allauthorid;
drop view cs1160315_morethan20authors;
drop view cs1160315_paperidcount;