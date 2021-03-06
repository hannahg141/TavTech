#import SQLContext and row 
from pyspark import SQLContext,SparkConf, Row, SparkContext
sc=SparkContext()
sqlContext=SQLContext(sc)
 
#load the data set and split the records
lines =sc.textFile("hdfs:///user/idc_ex4/Crime_dataset")
parts = lines.map(lambda l: l.split(","))
 
# construct the Rows by by passing a list of key/value pairs as kwargs
Crimes = parts.map(lambda p:Row(Id =p[0],case_no=p[1],date=p[2],block=p[3],IUCR=p[4],Primary_type=p[5],description=p[6],Loc_des =p[7],arrest=p[8],domestic= p[9],beat=p[10],district=p[11],ward=p[12],community=p[13],fbicode=p[14],XCor=p[15],YCor=p[16],year=p[17],Updated_on=p[18],latitude=p[19],longi=p[20],loc=p[21]))
# Create the DataFrame and register it has Table
schema1=sqlContext.createDataFrame(Crimes)
schema1.registerTempTable("Crimes")
#run the query for getting the required result
result=sqlContext.sql("select fbicode,count(fbicode) as count from Crimes group by fbicode")
result.show()
