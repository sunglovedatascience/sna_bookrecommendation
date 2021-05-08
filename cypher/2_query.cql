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
