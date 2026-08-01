FROM python:3.11-slim

WORKDIR /app

COPY server/ ./server/
COPY client/ ./client/

EXPOSE 9090

CMD ["python3", "server/eryu.py"]
