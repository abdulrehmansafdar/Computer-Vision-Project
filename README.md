# Wood Surface Defect Detection

Using YOLOv8n with Class-Aware Augmentation — Computer Vision Project

---

## Architecture (End-to-End Project Flow)

The complete pipeline consists of 8 stages, from raw data to production deployment:

```
 ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
 │ (1)      │    │ (2)      │    │ (3)      │    │ (4)      │    │ (5)      │    │ (6)      │
 │ Dataset  │───→│ Preproc │───→│ Data     │───→│ Augment  │───→│ YOLOv8n  │───→│ Model    │
 │ 4000 imgs│    │ 640x640 │    │ Split    │    │ +781 imgs│    │ Training │    │ best.pt  │
 │ Kaggle   │    │ YOLO fmt│    │ 80/10/10 │    │ Oversamp │    │ 20 epoch │    │ 6.2 MB   │
 └──────────┘    └──────────┘    └──────────┘    └──────────┘    └──────────┘    └──────────┘
                                     │                                                 │
                                     │                                                 │
                                     ▼                                                 ▼
                              ┌──────────────────┐                          ┌──────────────────┐
                              │ (7)              │                          │ (8)              │
                              │ Web Application  │◄─────────────────────────│ Detection Output │
                              │ FastAPI + Boot5  │    8 classes · scores    │ Bounding boxes   │
                              │ Upload / Webcam  │    · bounding boxes      │ Real-time inf.   │
                              └──────────────────┘                          └──────────────────┘
```

### Stage Details

| Stage | Component | Description |
|-------|-----------|-------------|
| 1 | **Dataset** | Large Scale Image Dataset of Wood Surface Defects (Kaggle) — 4,000 images, 9,211 annotations across 8 classes |
| 2 | **Preprocessing** | Images resized to 640×640px; labels converted to YOLO format (normalized x_center, y_center, width, height) |
| 3 | **Data Split** | 80/10/10 train/val/test split (3,200 / 400 / 400 images). Stratified to preserve class distribution. |
| 4 | **Augmentation** | Class-aware oversampling for minority classes (Quartzity, Marrow, Knot_missing). Safe transforms: H/V flip, ±10° rotation, ±15% brightness/contrast. +781 images created (total: 3,981). |
| 5 | **YOLOv8n Training** | Transfer learning from COCO pretrained weights. 20 epochs on Tesla T4 GPU. AdamW optimizer (lr=0.000833), batch size 16. Best model: mAP@50=0.639 |
| 6 | **Model Export** | Trained weights saved as `models/best.pt` (6.2 MB, 3.0M parameters, 8.2 GFLOPs) |
| 7 | **Web Application** | FastAPI backend + Bootstrap 5 frontend. Supports image upload, webcam inference, real-time detection with color-coded defects |
| 8 | **Detection Output** | Bounding boxes with confidence scores for all 8 wood defect classes. NMS + confidence filtering applied. |

### Model Architecture (YOLOv8n)

YOLOv8n is the nano variant of Ultralytics' YOLOv8 family:

- **Backbone**: CSPDarknet with C2f blocks (3 stages, channels 64→128→256) + SPPF layer
- **Neck**: FPN + PAN structure with upsampling and concatenation for multi-scale feature fusion
- **Head**: Decoupled detection head at 3 scales (P3, P4, P5) producing 8-class predictions
- **Total**: 130 layers, 3,012,408 parameters, 8.2 GFLOPs

## Performance Summary

- **Best mAP@50**: 0.639 (overall across 8 classes)
- **Precision**: 0.665 | **Recall**: 0.643
- **Best class**: Dead_Knot (0.852 mAP@50)
- **Worst class**: Quartzity (0.155 mAP@50 — limited samples)
- **Training time**: 0.684 hours on Tesla T4 GPU
