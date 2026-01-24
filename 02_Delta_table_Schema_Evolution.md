# Delta_table_Schema_Evolution
## Step 1: Create Initial Delta Table (employees)
``` python
from pyspark.sql.types import StructType, StructField, IntegerType, StringType, FloatType

# Define consistent schema
schema = StructType([
    StructField("id", IntegerType(), True),
    StructField("name", StringType(), True),
    StructField("salary", FloatType(), True)
])

data = [(1, "Alice", 5000.0), (2, "Bob", 6000.0)]
df = spark.createDataFrame(data, schema)

delta_table_path="Tables/dbo/employees"

# Overwrite table
df.write.format("delta") \
    .mode("overwrite") \
    .save(delta_table_path)

# Read table
df = spark.sql("SELECT * FROM lakehouse.dbo.employees LIMIT 1000")
display(df)

```
## Step 2: Try Schema Enforcement (This will fail)(Observe Error Msg)
``` 
from pyspark.sql.types import StructType, StructField, StringType, IntegerType

# Wrong type for salary (String) and extra column age
schema_wrong = StructType([
    StructField("id", IntegerType(), True),
    StructField("name", StringType(), True),    
    StructField("salary", FloatType(), True), 
    StructField("age", IntegerType(), True)   # Wrong Column
])

data_wrong = [(3, "Charlie", 8000.50, 30)]

df_invalid = spark.createDataFrame(data_wrong, schema_wrong)

# This will fail due to schema enforcement
df_invalid.write.format("delta") \
    .mode("append") \
    .save(delta_table_path)

```
## Step 3: Enable Schema Evolution
```
from pyspark.sql.types import StructType, StructField, IntegerType, StringType, FloatType

# Correct salary type and new age column
schema_new = StructType([
    StructField("id", IntegerType(), True),
    StructField("name", StringType(), True),
    StructField("salary", FloatType(), True),
    StructField("age", IntegerType(), True)
])

data_new = [(4, "David", 5500.0, 28)]
df_new = spark.createDataFrame(data_new, schema_new)

df_new.write.format("delta") \
    .option("mergeSchema", "true") \
    .mode("append") \
    .save(delta_table_path)

df = spark.sql("SELECT * FROM lakehouse.dbo.employees LIMIT 1000")
display(df)

## Step 4: Check Updated Schema

%%sql
desc lakehouse.dbo.employees

%%sql
select * from  lakehouse.dbo.employees


