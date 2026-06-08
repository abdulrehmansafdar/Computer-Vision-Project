import os
import json
import uuid
import uvicorn
import jinja2
from pathlib import Path
from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.responses import HTMLResponse, FileResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from starlette.requests import Request
import cv2
import numpy as np
from PIL import Image
from ultralytics import YOLO

app = FastAPI(title="Railway Track Defect Detector")

BASE_DIR = Path(__file__).resolve().parent
UPLOAD_DIR = BASE_DIR / "uploads"
MODEL_DIR = BASE_DIR / "model"
STATIC_DIR = BASE_DIR / "static"
TEMPLATE_DIR = BASE_DIR / "templates"

UPLOAD_DIR.mkdir(exist_ok=True)
STATIC_DIR.mkdir(exist_ok=True)

app.mount("/static", StaticFiles(directory=str(STATIC_DIR)), name="static")
jinja_env = jinja2.Environment(
    loader=jinja2.FileSystemLoader(str(TEMPLATE_DIR)),
    autoescape=jinja2.select_autoescape(),
    cache_size=0
)
templates = Jinja2Templates(env=jinja_env)

# Load model
model_path = MODEL_DIR / "best.pt"
if not model_path.exists():
    raise RuntimeError(f"Model not found at {model_path}. Train the model first or place best.pt in webapp/model/")

model = YOLO(str(model_path))

# Load class names
class_names_path = MODEL_DIR / "class_names.json"
if class_names_path.exists():
    with open(class_names_path) as f:
        CLASS_NAMES = json.load(f)
else:
    CLASS_NAMES = model.names if hasattr(model, 'names') else {}


def draw_predictions(image: np.ndarray, results) -> np.ndarray:
    for result in results:
        for box in result.boxes:
            x1, y1, x2, y2 = map(int, box.xyxy[0].tolist())
            conf = float(box.conf[0])
            cls_id = int(box.cls[0])
            label = f"{CLASS_NAMES[cls_id] if cls_id < len(CLASS_NAMES) else cls_id} {conf:.2f}"

            cv2.rectangle(image, (x1, y1), (x2, y2), (0, 255, 0), 3)

            (tw, th), _ = cv2.getTextSize(label, cv2.FONT_HERSHEY_SIMPLEX, 0.6, 2)
            cv2.rectangle(image, (x1, y1 - th - 10), (x1 + tw + 10, y1), (0, 255, 0), -1)
            cv2.putText(image, label, (x1 + 5, y1 - 5), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 0, 0), 2)

    return image


@app.get("/", response_class=HTMLResponse)
async def index(request: Request):
    return templates.TemplateResponse(request, "index.html")


@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    if not file.content_type or not file.content_type.startswith("image/"):
        raise HTTPException(400, "Only image files are allowed")

    ext = Path(file.filename).suffix if file.filename else ".jpg"
    filename = f"{uuid.uuid4()}{ext}"
    filepath = UPLOAD_DIR / filename

    contents = await file.read()
    with open(filepath, "wb") as f:
        f.write(contents)

    img = cv2.imread(str(filepath))
    if img is None:
        raise HTTPException(400, "Could not read image file")

    results = model(img, conf=0.25, iou=0.45)

    detections = []
    for result in results:
        for box in result.boxes:
            x1, y1, x2, y2 = map(float, box.xyxy[0].tolist())
            conf = float(box.conf[0])
            cls_id = int(box.cls[0])
            detections.append({
                "class": CLASS_NAMES[cls_id] if cls_id < len(CLASS_NAMES) else str(cls_id),
                "class_id": cls_id,
                "confidence": round(conf, 3),
                "bbox": [x1, y1, x2, y2]
            })

    annotated = draw_predictions(img.copy(), results)
    output_path = UPLOAD_DIR / f"annotated_{filename}"
    cv2.imwrite(str(output_path), annotated)

    return {
        "filename": filename,
        "annotated_filename": f"annotated_{filename}",
        "detections": detections,
        "total_defects": len(detections)
    }


@app.get("/uploads/{filename}")
async def get_upload(filename: str):
    filepath = UPLOAD_DIR / filename
    if not filepath.exists():
        raise HTTPException(404, "File not found")
    return FileResponse(str(filepath), media_type="image/jpeg")


if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)
