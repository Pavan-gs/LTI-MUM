# Lakehouse

## Introduction

- Traditionally, organizations have been building modern **Data Warehouses** for their transactional and **structured** data analytics needs. And **data lakehouses** for big data (**semi/unstructured**) data analytics needs. These two systems ran in parallel, creating silos, data duplication, and increased total cost of ownership.
- Fabric with its unification of data store and standardization on **Delta Lake** format allows you to eliminate silos, remove data duplication, and drastically reduce total cost of ownership.
- With the flexibility offered by Fabric, you can implement either lakehouse or data warehouse architectures or combine them together to get the best of both with simple implementation.
- It uses the **medallion architecture** where the bronze layer has the raw data, the silver layer has the validated and deduplicated data, and the gold layer has highly refined data. You can take the same approach to implement a lakehouse for any organization from any industry.

## Exercise 1: Create Lake House

1. On the left navigation pane, click on Workspaces.
2. Select the Workspace where you want to create the Lakehouse.
3. Inside the selected Workspace, click !
4. Search for Lakehouse >  Click on Lakehouse
5. Enter a **Lakehouse name** .
6. Click **Create**.
7. Observe that with in Lakehouse, two child objects created those are Semantic Model and SQL Analytics Endpoint
8. A SQL analytics endpoint for SQL querying and a default Power BI semantic model for reporting.
- 
## Exercise 2: Upload file from local Machine

1. Open Lakehouse by clicking on it.
2. Create a subfolder with the name of **data**
3. Right click on data folder and upload the emp.csv file

## Exercise 3: Create table using csv file

1. Right click on emp.csv file > Load to Tables > New Table
2. Provide schema as **dbo** and table name as **emp** click on **Load**
3. Right click on emp table observe properties
4. Right click on emp table observe view files and research on **parquet** file format.
6. Read [about Delta table](https://learn.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-what-is-delta-lake)
7. Understand ACID with [handson ACID](https://github.com/rritec/Microsoft-Fabric/blob/main/M02_LakeHouse/01_Delta_table_ACID_operations.md)

## Exercise 4: Ingest data using New Dataflow Gen2

1. Open Lakehouse by clciking on it.
2. Click on **Get data** > Click on **New Dataflow Gen2**
4. On the new dataflow screen, select **Import from a Text/CSV file**
5. Provide the URL customer.csv
6. Click on next 
7. Click on Create
8. Change Query Name as dim_customer
9. Click on Publish
9. A spinning circle next to the dataflow's name indicates publishing is in progress in the item view. When publishing is complete, select the **...** and select **Properties**. **Rename** the dataflow to **Load Lakehouse Table** and select **Save**.
10. Select the **Refresh now** option next to the data flow name to refresh the dataflow. This option runs the data flow and moves data from the source file to lakehouse table. While it's in progress, you see a spinning circle under Refreshed column in the item view
11. Once the dataflow is refreshed, select your lakehouse in the navigation bar to view the **dim_customer** Delta table

## Exercise 5: Ingest data using New Pipeline(Not Required)(due to more volume(100gb) of data)

1. Open Lakehouse by clicking on it.
2. Click on **Get data** > Click on **New Data Pipeline**
3. Name it as **PipelineToIngestDataFromSourceToLakehouse** > Click on **Create**
4. Search for **Http** and select it.
5. In the Connect to data source window, enter the details from the table below and select **Next**

| Property	| Value |
| ---- | ---- |
| URL	| https://assetsprod.microsoft.com/en-us/wwi-sample-dataset.zip |
| Connection	| Create a new connection |
| Connection name	| wwisampledata |
| Data gateway	| None |
| Authentication kind	| Anonymous |

7. Enable the **Binary copy** and choose **ZipDeflate (.zip)** as the Compression type since the source is a .zip file. Keep the other fields at their default values and click **Next**.
8. In the Connect to data destination window, specify the Root folder as **Files** > folder path as **data** >> Click on **Next**
9. In connect to data distance window if binary available select else we will select take care after few mins
10. In **Review + Save** Window disable the start **data transfer Immediately** > Click on **OK**
11. Select **copy Data** activity > Click on **Distination** tab and make sure File Format as **Binary**
12. Click on **Run** > Click on **Save and Run** > It may take 15 mins or more
13. Once pipeline completed you will see below all folders and Files

## Exercise 6: Prepare and transform data in the lakehouse(Not Required)(due to more volume(100gb) of data)

1. Open Lakehouse by clicking on it.
2. Read about [V-Order and Optimization](https://learn.microsoft.com/en-us/fabric/data-engineering/delta-optimization-and-v-order?tabs=sparksql)
3. From the workspace, select Import > Notebook > From this computer.
5. Select all the notebooks that you downloaded in first step of this section.
6. From the list of existing notebooks, select the 01 - Create Delta Tables notebook and select Open.
7. In the open notebook in the lakehouse Explorer, you see the notebook is already linked to your opened lakehouse if not add your lakehouse.
8. run one by one script and observe new tables are created
9. open second notebook 02 - Data Transformation - Business Aggregates run all scripts to load the data
10. Verify one by one table and note down count od records in each table.


## Questions
1. you know navigation to get **SQL connection string** ???
2. Session job connection string vs Batch job connection string
3. 

## Answers
1. Click on **Settings** > SQL Analytics Endpoint
2. Click on **Settings** > Livy Endpoint 
    - Use Session Jobs if you need real-time interaction (e.g., testing, debugging, and exploratory analysis).
    - Use Batch Jobs for scheduled workloads like ETL pipelines, data transformations, or running full scripts.)
3. 


