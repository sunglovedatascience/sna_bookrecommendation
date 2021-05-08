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
