//add the speakers and companies 
LOAD CSV WITH HEADERS FROM "https://docs.google.com/a/neotechnology.com/spreadsheets/d/1nb5Dc5g5L1QTHJdbx0bZQHhQRySNHIPNG7n6LhG7dL8/export?format=csv&id=&gid=190943835" AS CSV MERGE (p:Speaker {type: 'Speaker', name: CSV.`Name (Required)`, title: coalesce(CSV.Position, ''), bio: coalesce(CSV.`Bio/Description`, '')}) MERGE (c:Company {type: 'Company', name: CSV.Company}) WITH CSV MATCH (p:Speaker {type: 'Speaker', name: CSV.`Name (Required)`, title: coalesce(CSV.Position, '')}), (c:Company {type: 'Company', name: CSV.Company}) MERGE (p)-[:WORKS_FOR]->(c);

//add the rooms
LOAD CSV WITH HEADERS FROM "https://docs.google.com/a/neotechnology.com/spreadsheets/d/1nb5Dc5g5L1QTHJdbx0bZQHhQRySNHIPNG7n6LhG7dL8/export?format=csv&id=&gid=45193838" AS CSV 
MERGE (r:Room {type: 'Room', name: coalesce(CSV.venue, '')})

//add the timeslots
LOAD CSV WITH HEADERS FROM "https://docs.google.com/a/neotechnology.com/spreadsheets/d/1nb5Dc5g5L1QTHJdbx0bZQHhQRySNHIPNG7n6LhG7dL8/export?format=csv&id=&gid=45193838" AS CSV 
MERGE (t1:TimeSlot {type: 'TimeSlot', time: toInt(CSV.starttime)}) MERGE (t2:TimeSlot {type: 'TimeSlot', time: toInt(CSV.endtime)}); 

//Connecting the timeslots 
MATCH (t:TimeSlot) WITH t ORDER BY t.time ASC WITH collect(t) AS times FOREACH (i in range(0,length(times)-2) | FOREACH (t1 in [times[i]] | FOREACH (t2 in [times[i+1]] | MERGE (t1)-[:FOLLOWED_BY]->(t2)))); 

//add the sessions and connect them up 
LOAD CSV WITH HEADERS FROM "https://docs.google.com/a/neotechnology.com/spreadsheets/d/1nb5Dc5g5L1QTHJdbx0bZQHhQRySNHIPNG7n6LhG7dL8/export?format=csv&id=&gid=45193838" AS CSV 
MATCH (t2:TimeSlot {type: 'TimeSlot', time: toInt(CSV.endtime)}), (t1:TimeSlot {type: 'TimeSlot', time: toInt(CSV.starttime)}), (r:Room {type: 'Room', name: CSV.venue})
MERGE (s:Session {type: 'Session', title: CSV.name}) SET s.abstract = CSV.description SET s.tags = CSV.event_type 
MERGE (s)-[:IN_ROOM]->(r)
MERGE (s)-[:STARTS_AT]->(t1)
MERGE (s)-[:ENDS_AT]->(t2)
WITH split(CSV.speakers, ",") AS speaker, s
UNWIND speaker AS n
MERGE (p:Speaker {type: 'Speaker', name:n})
MERGE (s)<-[:SPEAKS_IN]-(p)

