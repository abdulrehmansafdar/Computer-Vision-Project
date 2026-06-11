"""Video processing pipeline for wood surface defect detection."""

from __future__ import annotations

import io
import json
import time
from pathlib import Path
from typing import Optional

import cv2
import numpy as np
from PIL import Image, ImageDraw, ImageFont

MODEL_PATH = Path(__file__).resolve().parent.parent / "models" / "best.pt"

BOX_COLORS_BGR = [
    (229, 69, 96),
    (15, 52, 96),
    (0, 184, 148),
    (253, 203, 110),
    (108, 92, 231),
    (225, 112, 85),
    (9, 132, 227),
    (162, 155, 254),
    (255, 107, 107),
    (72, 219, 251),
    (29, 209, 161),
    (243, 114, 44),
    (95, 39, 215),
]


def _try_load_font(size: int = 16):
    for fp in [
        r"C:\Windows\Fonts\segoeuib.ttf",
        r"C:\Windows\Fonts\arialbd.ttf",
        r"C:\Windows\Fonts\arial.ttf",
        "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
        "/Library/Fonts/Arial Bold.ttf",
    ]:
        try:
            return ImageFont.truetype(fp, size)
        except Exception:
            continue
    return ImageFont.load_default()


def _draw_boxes_pil(img_rgb: np.ndarray, detections, font) -> np.ndarray:
    img = Image.fromarray(img_rgb)
    draw = ImageDraw.Draw(img)
    for det in detections:
        x1, y1, x2, y2 = det["bbox"]
        cls_id = det.get("class_id", 0) % len(BOX_COLORS_BGR)
        r, g, b = BOX_COLORS_BGR[cls_id]
        draw.rectangle([x1, y1, x2, y2], outline=(r, g, b), width=3)
        label = f"{det['class']} {det['confidence'] * 100:.0f}%"
        tw = draw.textlength(label, font=font)
        th = 18
        bg_y1 = max(0, y1 - th - 4)
        draw.rectangle([x1, bg_y1, x1 + tw + 8, bg_y1 + th], fill=(r, g, b))
        draw.text((x1 + 4, bg_y1 + 1), label, fill=(255, 255, 255), font=font)
    return np.array(img)


def load_yolo_model():
    from ultralytics import YOLO

    if not MODEL_PATH.exists():
        print(
            f"Model file not found at {MODEL_PATH}. Please ensure the model is available."
        )
        return None
    print(f"Loading YOLO model from {MODEL_PATH}...")
    return YOLO(str(MODEL_PATH))


def get_class_names() -> list[str]:
    try:
        from ultralytics import YOLO

        if MODEL_PATH.exists():
            model = YOLO(str(MODEL_PATH))
            names = model.names
            if isinstance(names, dict):
                return [names[i] for i in sorted(names.keys())]
            return list(names)
    except Exception:
        pass
    return []


def process_video(
    video_bytes: bytes,
    model,
    conf: float = 0.4,
    frame_stride: int = 1,
    max_frames: Optional[int] = None,
    progress_cb=None,
) -> dict:
    src_path = Path("data") / "uploads" / "_in.mp4"
    src_path.parent.mkdir(parents=True, exist_ok=True)
    src_path.write_bytes(video_bytes)

    cap = cv2.VideoCapture(str(src_path))
    if not cap.isOpened():
        return {"error": "Could not open video file"}

    fps = cap.get(cv2.CAP_PROP_FPS) or 25.0
    total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))

    if max_frames:
        total_frames = min(total_frames, max_frames)

    out_path = Path("data") / "uploads" / "_out.mp4"
    out_path.parent.mkdir(parents=True, exist_ok=True)
    fourcc = cv2.VideoWriter_fourcc(*"mp4v")
    writer = cv2.VideoWriter(str(out_path), fourcc, fps, (width, height))

    font = _try_load_font(18)
    timeline = []
    histogram: dict[str, int] = {}
    processed = 0
    t0 = time.time()

    try:
        idx = 0
        while True:
            ok, frame_bgr = cap.read()
            if not ok or (max_frames and processed >= max_frames):
                break

            if idx % frame_stride == 0:
                rgb = cv2.cvtColor(frame_bgr, cv2.COLOR_BGR2RGB)
                results = model(rgb, conf=conf, verbose=False)
                r = results[0]
                dets = []
                for box, score, cid in zip(
                    r.boxes.xyxy.cpu().numpy(),
                    r.boxes.conf.cpu().numpy(),
                    r.boxes.cls.cpu().numpy().astype(int),
                ):
                    name = r.names.get(int(cid), str(cid))
                    dets.append(
                        {
                            "bbox": [
                                float(box[0]),
                                float(box[1]),
                                float(box[2]),
                                float(box[3]),
                            ],
                            "confidence": float(score),
                            "class": name,
                            "class_id": int(cid),
                        }
                    )
                for d in dets:
                    histogram[d["class"]] = histogram.get(d["class"], 0) + 1

                rgb_annotated = _draw_boxes_pil(rgb, dets, font)
                annotated_bgr = cv2.cvtColor(rgb_annotated, cv2.COLOR_RGB2BGR)
                writer.write(annotated_bgr)

                timeline.append(
                    {
                        "frame": idx,
                        "time": round(idx / fps, 2),
                        "count": len(dets),
                        "classes": [d["class"] for d in dets],
                    }
                )
                processed += 1

                if progress_cb:
                    try:
                        progress_cb(processed, total_frames)
                    except Exception:
                        pass
            else:
                writer.write(frame_bgr)

            idx += 1
    finally:
        cap.release()
        writer.release()

    elapsed = time.time() - t0
    out_bytes = out_path.read_bytes()
    import base64

    out_b64 = base64.b64encode(out_bytes).decode()

    total_defects = sum(histogram.values())
    if total_defects == 0:
        severity = "None"
    elif total_defects < 10:
        severity = "Low"
    elif total_defects < 50:
        severity = "Medium"
    else:
        severity = "High"

    return {
        "video_b64": out_b64,
        "video_mime": "video/mp4",
        "fps": round(fps, 2),
        "total_frames": int(cap.get(cv2.CAP_PROP_FRAME_COUNT)),
        "processed_frames": processed,
        "width": width,
        "height": height,
        "elapsed_sec": round(elapsed, 2),
        "timeline": timeline,
        "histogram": histogram,
        "total_defects": total_defects,
        "severity": severity,
    }


def process_image(image_bytes: bytes, model, conf: float = 0.4) -> dict:
    from PIL import Image
    import base64

    img = Image.open(io.BytesIO(image_bytes)).convert("RGB")
    arr = np.array(img)
    results = model(arr, conf=conf, verbose=False)
    r = results[0]
    font = _try_load_font(16)
    dets = []
    for box, score, cid in zip(
        r.boxes.xyxy.cpu().numpy(),
        r.boxes.conf.cpu().numpy(),
        r.boxes.cls.cpu().numpy().astype(int),
    ):
        name = r.names.get(int(cid), str(cid))
        dets.append(
            {
                "bbox": [round(float(v), 1) for v in box],
                "confidence": round(float(score), 4),
                "class": name,
                "class_id": int(cid),
            }
        )
    annotated = _draw_boxes_pil(arr, dets, font)
    pil_out = Image.fromarray(annotated)
    buf = io.BytesIO()
    pil_out.save(buf, format="JPEG", quality=90)
    out_b64 = base64.b64encode(buf.getvalue()).decode()
    return {"detections": dets, "image_b64": out_b64}
