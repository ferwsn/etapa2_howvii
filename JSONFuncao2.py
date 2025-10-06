from flask import Flask, jsonify
import pyodbc

app = Flask(__name__)

# Configuração da conexão com o SQL Server
def get_db_connection():
    conn = pyodbc.connect(
        'DRIVER={ODBC Driver 17 for SQL Server};'
        'SERVER=192.168.100.38,1433;'
        'DATABASE=handsvii;'
        'UID=consulta_python;'
        'PWD=!Consulta1'
    )
    return conn

@app.route('/funcao2', methods=['GET'])
def get_funcao2():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM dbo.consulta_vlrmes('2023/11')")
    columns = [column[0] for column in cursor.description]
    results = [dict(zip(columns, row)) for row in cursor.fetchall()]
    conn.close()
    return jsonify(results)

if __name__ == '__main__':
    app.run(debug=True)