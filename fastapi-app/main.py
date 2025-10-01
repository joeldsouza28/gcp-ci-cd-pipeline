from fastapi import FastAPI
import socket

app = FastAPI()


@app.get("/")
def index():
    return f"Hello from dockerized fastapi {socket.gethostname()}"
