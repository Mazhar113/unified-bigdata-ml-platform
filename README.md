# Unified Big Data & ML Platform  
**A scalable, production-ready platform for data ingestion, processing, real-time analytics, and end-to-end machine learning workflows.**

![GitHub repo size](https://img.shields.io/github/repo-size/Mazhar113/unified-bigdata-ml-platform)
![GitHub stars](https://img.shields.io/github/stars/Mazhar113/unified-bigdata-ml-platform?style=social)
![GitHub issues](https://img.shields.io/github/issues/Mazhar113/unified-bigdata-ml-platform)
![GitHub last commit](https://img.shields.io/github/last-commit/Mazhar113/unified-bigdata-ml-platform)
![Docker](https://img.shields.io/badge/Docker-ready-blue)
![Spark](https://img.shields.io/badge/Apache%20Spark-3.x-orange)
![Kafka](https://img.shields.io/badge/Apache%20Kafka-ready-black)
![Airflow](https://img.shields.io/badge/Apache%20Airflow-production-green)
![MLflow](https://img.shields.io/badge/MLflow-enabled-yellow)

---

## 📌 **Overview**

The **Unified Big Data & ML Platform** provides a complete, modular, production-ready architecture for:

- Batch & streaming data ingestion  
- Real-time analytics (Spark + Kafka)  
- Data lake storage on Delta Lake  
- ML model training, versioning, deployment  
- Automated pipelines & monitoring  
- Dashboard reporting + APIs for predictions  

It combines the best practices of big-data engineering, MLOps, and microservices into a single, scalable system.

---

## 🎯 **Core Capabilities**

### **🔹 1. Data Ingestion**
- Kafka-based real-time ingestion  
- Batch ingestion via Airflow  
- API ingestion service  
- Connectors for DBs, CSV, JSON, Parquet, Web APIs

### **🔹 2. Processing & ETL**
- PySpark ETL pipelines  
- Delta Lake bronze → silver → gold layers  
- Stream processing using Spark Structured Streaming

### **🔹 3. Machine Learning**
- Feature engineering & feature store  
- Model training with MLflow tracking  
- AutoML support  
- Batch prediction & real-time API inference

### **🔹 4. Orchestration**
- Airflow DAGs for nightly, hourly, and real-time pipelines  
- ML pipeline automation (train → evaluate → register → deploy)

### **🔹 5. API Layer**
- FastAPI microservices  
- Model inference endpoints  
- Data lookup APIs for dashboards

### **🔹 6. Monitoring**
- Grafana dashboards  
- Prometheus metrics  
- ML drift monitoring  
- Airflow pipeline health

---

## 🏗️ **High-Level Architecture**

```
                        +---------------------------+
                        |        Data Sources       |
                        |  Web Apps | DBs | APIs    |
                        +---------------------------+
                                      |
                                      v
                          +------------------+
                          |   Ingestion      |
                          | Kafka | API | ETL|
                          +------------------+
                                      |
                                      v
                      +-------------------------------+
                      |         Data Lake (DL)        |
                      | Bronze → Silver → Gold (Delta)|
                      +-------------------------------+
                                      |
                +---------------------+-----------------------+
                |                                             |
                v                                             v
      +-------------------+                         +-----------------------+
      |  Batch ETL (ETL)  |                         | Real-Time Processing  |
      |   Spark / Airflow |                         | Spark Streaming / ML  |
      +-------------------+                         +-----------------------+
                |                                             |
                +---------------------+------------------------+
                                      |
                                      v
                       +----------------------------+
                       |     ML Pipelines (MLflow)  |
                       | Training | Registry | Deploy|
                       +----------------------------+
                                      |
                                      v
                         +---------------------------+
                         |     API + Dashboards      |
                         | FastAPI | Grafana | Apps  |
                         +---------------------------+
```

---

## 🚀 **How to Run (Local Setup)**

### **1️⃣ Clone the Repository**
```bash
git clone https://github.com/Mazhar113/unified-bigdata-ml-platform
cd unified-bigdata-ml-platform
```

### **2️⃣ Start the Platform**
```bash
docker-compose up -d
```

### **3️⃣ Access Components**
| Component | URL |
|----------|-----|
| Airflow UI | http://localhost:8080 |
| MLflow UI | http://localhost:5000 |
| FastAPI | http://localhost:8000 |
| Grafana | http://localhost:3000 |

---

## 🧪 **Run Sample ML Training**
```bash
python ml/training/train_model.py
```

Outputs:  
- MLflow experiment  
- Registered model  
- Metrics + plots

---

## 📡 **Real-Time Streaming Demo**
Start Kafka + Spark Streaming:

```bash
bash ingestion/kafka/start_kafka.sh
python processing/spark_jobs/stream_processor.py
```

Generate test messages:

```bash
python ingestion/kafka/produce.py
```

---


