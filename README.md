# Book Recommendation based on  Collaborative Filtering
  * บทความนี้แสดงขั้นตอนการใช้งานเพื่อแนะนำหนังสือที่ชอบให้กับผู้ใช้งาน โดยวิเคราะห์หาความชอบคล้ายกันระหว่างผู้ใช้งาน
  * อ่านบทความสั้นๆได้ที่ https://link.medium.com/w8FMZjI9dgb หรือรายละเอียดที่ ...
## Dataset
  * เป็นข้อมูลการให้ rating หนังสือจาก https://www.kaggle.com/sahilkirpekar/goodreads10k-dataset-cleaned โดยมีหนังสือจำนวน 10,000 เล่ม ที่ผู้ใช้งานจำนวน 53,434 คน ให้คะแนนจำนวน 981,756 ครั้ง (1–5 คะแนน)
  * บทความนี้ได้เลือกไฟล์ Books.csv เป็นข้อมูลรายละเอียดหนังสือ และไฟล์ Ratings.csv เป็นข้อมูลการให้คะแนนหนังสือโดยผู้ใช้งานเท่านั้น
  * นำ 2 ไฟล์ดังกล่าว ทำ concat ด้วย Python เพื่อให้มีความพร้อมต่อการใช้งาน Neo4j โดยสำรวจข้อมูลว่ามีค่า null หรือไม่ แล้วเลือก Feature ที่ใช้ สามารถดูวิธีการเตรียมข้อมูลได้ที่ https://colab.research.google.com/drive/1cotfMwfwgw77RPI8YcAcqld98j2rqBXt?usp=sharing
## Install โปรแกรม Neo4j
  * สามารถดูวิธีดาวน์โหลด Neo4j Desktop ที่ https://www.sqlshack.com/getting-started-with-the-neo4j-graph-database/
## ขั้นตอนการรันโปรแกรม Neo4j
  * เข้าไปดูขั้นตอนที่ https://docs.google.com/presentation/d/1O2iC8Yrw6EhsC_7ZPCrF8LXcuapDJlELdL5thNk6raU/edit?usp=sharing
  * หมายเหตุ คำสั่ง Cypher หลักๆ ดังนี้
  1. CREATE เพิ่ม node relationship property
  2. MATCH เรียกข้อมูลจาก node relationship property
  3. RETURN ส่งค่าผลลัพธ์กลับจากการเรียกข้อมูล
  4. WHERE ตั้งเงื่อนไขในการเรียกข้อมูล
  5. DELETE ลบ node relationship
  6. REMOVE ลบ property ของ node relationship
  7. ORDER By เรียงข้อมูลที่เรียกมา
  8. SET เพิ่มหรือปรับปรุงป้ายชื่อ node
