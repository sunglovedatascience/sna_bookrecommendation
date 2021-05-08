//Import ไฟล์ CSV เข้าสู่ Neo4j
LOAD CSV WITH HEADERS FROM "file:///goodreadDataset.csv" as row
MERGE (u:User {userId:toInteger(row.userId)})
MERGE (b:Book {bookId:toInteger(row.bookId), bookTitle:row.bookTitle, author:row.author, publicationYear:row.publicationYear, imageUrl:row.imageUrl, isbn:row.isbn})
MERGE (u)-[r:RATED{rating:toInteger(row.rating)}]->(b)
RETURN u, b
LIMIT 2000

//แสดงแบบจำลองกราฟแสดงความสัมพันธ์แบบมีทิศทางจากโหนดผู้ใช้งานไปยังโหนดหนังสือ
call db.schema.visualization

//มีหนังสือเรื่องอะไรบ้างที่ user21713 และ user41074 อ่านเรื่องเดียวกัน
MATCH (p1:User {userId: 21713})-[r1:RATED]->(m:Book)<-[r2:RATED]-(p2:User {userId: 41074})
RETURN p1, m, p2

//user 2 คนนี้ ให้ rating หนังสือแต่ละเล่มเท่าไรบ้าง
MATCH (u1:User {userId: 21713})-[r1:RATED]->(b:Book)<-[r2:RATED]-(u2:User {userId: 41074})
RETURN b.bookTitle AS bookTitle, r1.rating AS u21713_Rating, r2.rating AS u41074_Rating
ORDER BY b.bookId ASC

//user 2 คนเดิม มีความชอบหนังสือคล้ายกันหรือไม่ ก็เลยต้องหาคะแนนความคล้ายด้วยวิธี Cosine similarity
MATCH (u1:User {userId: 21713})-[r1:RATED]->(b1:Book)<-[r2:RATED]-(u2:User {userId: 41074} )
RETURN u1.userId AS user21713,
       u2.userId AS user41074,
       collect(b1.bookTitle) as ratedBook,
       collect(r1.rating) AS user21713Rating,
       collect(r2.rating) AS user41074Rating,
       round(gds.alpha.similarity.cosine(collect(r1.rating), collect(r2.rating)),2) AS CosineSimilarity

//นอกจาก user41074 ที่ชอบหนังสือคล้ายกับ user21713 มีใครชอบหนังสือคล้ายกับเค้าบ้าง
MATCH (u2:User)
WITH u2
ORDER BY u2.userId
 
MATCH (u1:User {userId: 21713})-[r1:RATED]->(b1:Book)<-[r2:RATED]-(u2:User)
WITH u1,
      	u2,
    	collect(r1.rating) AS u1Rating,
     	collect(r2.rating) AS u2Rating,
  	round(gds.alpha.similarity.cosine(collect(r1.rating),collect(r2.rating)),2) AS CosineSimilarity
WHERE CosineSimilarity > 0.5
 
RETURN collect(u2.userId) AS similarUser,
       CosineSimilarity, COUNT(*) AS userNum
ORDER BY CosineSimilarity DESC
LIMIT 5

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

//ลบ relationship การแนะนำหนังสือที่เล่มเดียวกับหนังสือที่ผู้ใช้งานให้คะแนนแล้ว ก็เลยไม่ได้แนะนำหนังสือเล่มนั้นให้กับผู้ใช้งาน
MATCH (b)-[rec:RECOMMEND]-(u2)-[:RATED]->(b)
DELETE rec

//จากที่ได้ List users ที่ชอบหนังสือคล้ายกับ user21713 ด้วยคะแนนความคล้ายมากกว่า 0.5 สุ่มเลือก user1185 มาว่าคนนี้ กับ user21713 ให้ rating หนังสือเรื่องเดียวกันเรื่องอะไรบ้าง
MATCH (u1:User{userId:21713})-[r:RATED]->(b:Book)
MATCH (u1:User)-[s:SIMILARITY]-(u2:User{userId:1185})
WHERE s.similarity > 0.5
RETURN u1, u2, b
LIMIT 5

//อยากแนะนำหนังสือให้กับ user1185 อีก นอกจากแนะนำหนังสือ 2 เรื่องด้านบนไปแล้วนั้น สัก 10 เรื่องก็พอเนอะ
MATCH (u2:User{userId:1185})-[rec:RECOMMEND]-(b:Book)
RETURN b.bookTitle AS recommendBook, b.imageUrl AS imageUrl
ORDER BY recommendBook
LIMIT 10

//ในที่สุดได้ Complete Graph แสดงเครือข่ายการแนะนำหนังสือ
MATCH (u1:User)-[r:RATED]->(b:Book)
MATCH (u1:User)-[s:SIMILARITY]-(u2:User)
WHERE s.similarity > 0.5
RETURN u1, u2, b
LIMIT 30
