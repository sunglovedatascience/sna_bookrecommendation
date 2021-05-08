// Import ไฟล์ CSV เข้าสู่ Neo4j
LOAD CSV WITH HEADERS FROM "file:///goodreadDataset.csv" as row
MERGE (u:User {userId:toInteger(row.userId)})
MERGE (b:Book {bookId:toInteger(row.bookId), bookTitle:row.bookTitle, author:row.author, publicationYear:row.publicationYear, imageUrl:row.imageUrl, isbn:row.isbn})
MERGE (u)-[r:RATED{rating:toInteger(row.rating)}]->(b)
RETURN u, b
LIMIT 2000

//
