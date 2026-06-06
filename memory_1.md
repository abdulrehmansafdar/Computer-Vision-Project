# Memory File — Team Mate

## Project: Railway Track Surface Defect Detection

---

### Task Progress

| Module | Status | Assigned | Notes |
|--------|--------|----------|-------|
| **Dataset Setup** | ⬜ Pending | | Mendeley Data — 100 images, needs augmentation |
| **Annotator Tool** | ⬜ Pending | | |
| **Classification** | ⬜ Pending | | |
| **Object Detection** | ⬜ Pending | | |
| **Segmentation** | ⬜ Pending | | |
| **Evaluation** | ⬜ Pending | | |
| **Paper Writing** | ⬜ Pending | | |

---

### Weekly Checklist (Compressed)

#### Dataset — Mendeley Data (Data in Brief)
- [ ] Run `.\scripts\download_data.ps1` to download 100 images
- [ ] Defect classes: Grooves, Joints, Cracks, Flakings, Shellings, Spallings, Squats
- [ ] Explore dataset, check for corrupt images
- [ ] Data augmentation (flip, rotate, crop, brightness) to expand dataset
- [ ] Develop custom annotation tool → COCO JSON
- [ ] Annotate 20+ images with bounding boxes

#### Classification
- [ ] Build classification model (ResNet / EfficientNet)
- [ ] Train on annotated + augmented data
- [ ] Evaluate (accuracy, precision, recall, F1)

#### Object Detection
- [ ] Build detection model (Faster R-CNN / YOLO)
- [ ] Train and validate
- [ ] Run predictions on test set, compute mAP

#### Segmentation
- [ ] Build segmentation model (U-Net / DeepLabV3+)
- [ ] Train and evaluate (IoU, Dice)

#### Paper & Final Submission
- [ ] Write research paper
- [ ] Record video demo
- [ ] Prepare final submission package

---

### Notes / Ideas

- 

### Blockers / Issues

- 

### Commands Reference

```powershell
# Download dataset (no API key required)
.\scripts\download_data.ps1

# Activate environment
.\.venv\Scripts\Activate.ps1

# Run annotator
python -m annotator.annotator
```
