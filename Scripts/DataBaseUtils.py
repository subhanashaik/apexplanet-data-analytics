import sqlite3
import pandas as pd

def create_connection(database):
    return sqlite3.connect(database)

def load_csv_to_database(csv_file, database, table_name):
    conn = sqlite3.connect(database)

    df = pd.read_csv(csv_file)

    df.to_sql(
        table_name,
        conn,
        if_exists="replace",
        index=False
    )

    conn.close()

def run_query(database, query):
    conn = sqlite3.connect(database)

    result = pd.read_sql(query, conn)

    conn.close()

    return result