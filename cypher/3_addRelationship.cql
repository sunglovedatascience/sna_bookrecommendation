//สร้าง relationship คะแนนความคล้ายกันระหว่างผู้ใช้งานที่ได้จากการคำนวณ Cosine similarity
MATCH (u1:User)-[r1:RATED]->(b1:Book)<-[r2:RATED]-(u2:User)
WITH u1,
     u2,
     collect(r1.rating) AS u1Rating,
     collect(r2.rating) AS u2Rating,
     round(gds.alpha.similarity.cosine(collect(r1.rating),collect(r2.rating)),2) AS CosineSimilarity
MERGE (u1)-[s:SIMILARITY]-(u2)
SET   s.similarity = CosineSimilarity

//สร้างอีก relationship การแนะนำ เมื่อคะแนนความชอบคล้ายกันมากกว่า 0.5
MATCH (u1:User)-[r:RATED]->(b:Book)
MATCH (u1:User)-[s:SIMILARITY]-(u2:User)
WHERE s.similarity > 0.5
MERGE (b)-[:RECOMMEND]-(u2)
