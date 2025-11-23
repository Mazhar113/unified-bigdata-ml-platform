from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
def hello(): print('hello')
with DAG('placeholder', start_date=datetime(2025,1,1), schedule_interval='@daily', catchup=False) as dag:
    t = PythonOperator(task_id='hello', python_callable=hello)
