"""RTSD Webapp — Railway Track Surface Defect Detection."""
import os, sys, io, base64, threading
from pathlib import Path

import uvicorn
from fastapi import FastAPI, Request, File, UploadFile, Form
from fastapi.responses import HTMLResponse, JSONResponse
from fastapi.staticfiles import StaticFiles
from jinja2 import Environment, FileSystemLoader

import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT))
sys.path.insert(0, str(Path(__file__).parent))

from video_processor import (
    load_yolo_model,
    get_class_names,
    process_image,
    process_video,
)

app = FastAPI(title="RTSD - Railway Track Defect Detection")
app.mount("/static", StaticFiles(directory=Path(__file__).parent / "static"), name="static")

TEMPLATE_DIR = Path(__file__).parent / "templates"
jinja_env = Environment(loader=FileSystemLoader(str(TEMPLATE_DIR)), autoescape=True)


def render(name, **context):
    return HTMLResponse(jinja_env.get_template(name).render(**context))


CLASSES = ["Cracks", "Flakings", "Grooves", "Joint", "Shellings", "Spallings", "Squats"]

MODELS = {}


def load_yolo():
    if "yolo" in MODELS:
        return MODELS["yolo"]
    m = load_yolo_model()
    if m is not None:
        MODELS["yolo"] = m
    return m


# ---- Pages ----

@app.get("/", response_class=HTMLResponse)
async def index(request: Request):
    classes = get_class_names() or CLASSES
    return render("index.html", request=request, active="home", classes=classes)


@app.get("/detection", response_class=HTMLResponse)
async def detection_page(request: Request):
    classes = get_class_names()
    return render("detection.html", request=request, active="detection", classes=classes)


# ---- Image detection API (YOLOv8) ----

@app.post("/api/detect/image")
async def detect_image(file: UploadFile = File(...), conf: float = 0.4):
    model = load_yolo()
    if model is None:
        return JSONResponse({"error": "YOLOv8 model not found. Train via train_faultseg_colab.ipynb and save to models/faultseg_yolov8n_seg.pt"}, status_code=400)
    data = await file.read()
    return process_image(data, model, conf=conf)


# ---- Video detection API (YOLOv8, frame-by-frame) ----

@app.post("/api/detect/video")
async def detect_video(file: UploadFile = File(...), conf: float = 0.4, stride: int = 1):
    model = load_yolo()
    if model is None:
        return JSONResponse({"error": "YOLOv8 model not found. Train via train_faultseg_colab.ipynb and save to models/faultseg_yolov8n_seg.pt"}, status_code=400)
    data = await file.read()
    if not data:
        return JSONResponse({"error": "Empty video file"}, status_code=400)
    result = process_video(data, model, conf=conf, frame_stride=max(1, int(stride)))
    if "error" in result:
        return JSONResponse(result, status_code=400)
    return result


# ---- Model status ----

@app.get("/api/model/status")
async def model_status():
    return {
        "yolo_detection": load_yolo() is not None,
        "yolo_classes": get_class_names(),
    }


if __name__ == "__main__":
    uvicorn.run("main:app", host="127.0.0.1", port=8000, reload=True)
