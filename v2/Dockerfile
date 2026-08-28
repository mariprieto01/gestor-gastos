FROM python:3.12-slim

WORKDIR /app

# Dependencias primero (aprovecha la cache de capas de Docker)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Código y frontend
COPY main.py .
COPY static/ ./static/

# La base sqlite se guarda acá dentro del contenedor
ENV DB_PATH=/app/data/gastos.db

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
