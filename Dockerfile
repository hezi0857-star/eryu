FROM python:3.11-slim

WORKDIR /app

RUN pip install --no-cache-dir librosa numpy matplotlib

COPY server/ ./server/
COPY client/ ./client/

EXPOSE 9090

CMD ["python3", "server/eryu.py"]
