# Book Recommendation based on  Collaborative Filtering
Final Project รายวิชา DS535 Social Network Analysis ภาคการศึกษา 2/2563 หลักสูตรวิทยาศาสตรมหาบัณฑิต สาขาวิชาวิทยาการข้อมูล มศว

จัดทำโดย นางสาวปริยานุช ประเสริฐสิริกุล รหัสนิสิต 63199130345
<p align="center">
  <a href="https://github.com/othneildrew/Best-README-Template">
    <img src="https://user-images.githubusercontent.com/70100985/118521440-3ee97800-b765-11eb-9a62-1c6355176f89.png">
  </a>

บทความนี้เกี่ยวกับการหาคะแนนความชอบหนังสือคล้ายกันระหว่างผู้ใช้งาน สามารถบอกได้ว่าผู้ใช้งาน 2 คน ชอบคล้ายกันมากน้อยแค่ไหน โดยอ้างอิงจาก rating แต่ละเรื่องหนังสือ หากชอบคล้ายกันหรือคล้ายมาก จะแนะนำหนังสือที่ผู้ใช้งานคาดว่าน่าจะชอบให้กับคนนั้น สามารถอ่าน[บทความสั้นๆ](https://link.medium.com/w8FMZjI9dgb) หรืออ่านรายละเอียดใน[รายงานฉบับสมบูรณ์]( https://github.com/sunglovedatascience/sna_bookrecommendation/blob/177596a1b4509b360fb8fd7d15c816f5e4814a49/Paper_BookRecommendation.pdf)

## Dataset
  * เป็นข้อมูลการให้ rating หนังสือจาก https://www.kaggle.com/sahilkirpekar/goodreads10k-dataset-cleaned โดยมีหนังสือจำนวน 10,000 เล่ม ที่ผู้ใช้งานจำนวน 53,434 คน ให้คะแนนจำนวน 981,756 ครั้ง (1–5 คะแนน)
  * สำหรับบทความนี้ใช้ไฟล์ `Books.csv` เป็นข้อมูลรายละเอียดหนังสือ และไฟล์ `Ratings.csv` เป็นข้อมูลการให้คะแนนหนังสือโดยผู้ใช้งานเท่านั้น
  * นำ 2 ไฟล์ดังกล่าว ทำ concat ด้วย Python เพื่อให้มีความพร้อมต่อการใช้งาน Neo4j โดยสำรวจข้อมูลว่ามีค่า null หรือไม่ แล้วเลือก Feature ที่ใช้ สามารถดูวิธีการเตรียมข้อมูลได้ที่ https://colab.research.google.com/drive/1cotfMwfwgw77RPI8YcAcqld98j2rqBXt?usp=sharing
## Install โปรแกรม Neo4j
  * สามารถดูวิธีดาวน์โหลด Neo4j Desktop ตลอดจนถึงการสร้าง Graph Database ใน Project https://www.sqlshack.com/getting-started-with-the-neo4j-graph-database/
## ขั้นตอนการรันโปรแกรม Neo4j
  * เข้าชม[ภาพขั้นตอนการทำงาน](https://docs.google.com/presentation/d/1O2iC8Yrw6EhsC_7ZPCrF8LXcuapDJlELdL5thNk6raU/edit?usp=sharing)
  * หากต้องการทดลองใช้งาน Neo4j สามารถ copy [source code](https://github.com/sunglovedatascience/sna_bookrecommendation/tree/main/cypher) แต่ละไฟล์ `.cql` ตามลำดับ
  
  หมายเหตุ คำสั่ง Cypher หลักๆ ดังนี้
  1. CREATE เพิ่ม node relationship property
  2. MATCH เรียกข้อมูลจาก node relationship property
  3. RETURN ส่งค่าผลลัพธ์กลับจากการเรียกข้อมูล
  4. WHERE ตั้งเงื่อนไขในการเรียกข้อมูล
  5. DELETE ลบ node relationship
  6. REMOVE ลบ property ของ node relationship
  7. ORDER By เรียงข้อมูลที่เรียกมา
  8. SET เพิ่มหรือปรับปรุงป้ายชื่อ node
