# Project Context: Railway Track Surface Defect Detection

## Scope
- **Dataset**: [Railway Track Surface Faults Dataset](https://data.mendeley.com/datasets/8hxtgyyxrw/2) (Mendeley Data, from *Data in Brief* journal)
- **Journal**: [Data in Brief, Volume 52, February 2024, 110050](https://www.sciencedirect.com/science/article/pii/S2352340924000246)
- **DOI**: 10.1016/j.dib.2024.110050
- **Tasks**: Image Classification, Object Detection, Segmentation
- **Annotator**: Custom mini annotation tool → COCO JSON output
- **Paper**: Research paper as final submission

## Dataset Details
- **Defect Classes**: Grooves, Joints, Cracks, Flakings, Shellings, Spallings, Squats
- **Collection**: EKEN-H9R cameras mounted on railway inspection vehicle
- **License**: CC BY 4.0
- **Total images**: 5153 JPEGs (manually downloaded from Mendeley; API limited to 100)
- **Data augmentation**: Required to balance classes (severe class imbalance: 8–2829 samples)
- **Folder structure**: Files organized into 7 class subdirectories under `data/raw/`

## Tech Stack
- **Framework**: PyTorch
- **Detection**: YOLO / Faster R-CNN (via Detectron2 or MMDetection)
- **Segmentation**: U-Net / DeepLabV3+
- **Classification**: ResNet / EfficientNet / ViT
- **Annotation Format**: COCO JSON

## Folder Structure
```
├── data/
│   ├── raw/              # Original 5153 JPEGs in 7 class subdirectories
│   ├── processed/        # Augmented/preprocessed data
│   └── annotations/      # COCO JSON annotation files
├── src/               # Source code (classification, detection, segmentation, utils, evaluation)
├── annotator/         # Custom annotation tool
├── notebooks/         # Jupyter notebooks per module
├── models/            # Saved weights (gitignored)
├── output/            # Predictions, logs, figures
├── reports/           # Research paper, figures
├── scripts/           # Utility scripts (download_data.ps1)
```

## Key Commands
```powershell
# Dataset download (no API key needed)
.\scripts\download_data.ps1

# Environment setup
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt

# Annotator
python -m annotator.annotator
```

## Dataset Citation
```
Arain, Asfar; Mehran, Sanaullah; Shaikh, Muhammad Zakir;
Kumar, Dileep; Hussain, Tanweer; Chowdhry, Bhawani Shankar (2022),
"Railway Track Surface Faults Dataset", Mendeley Data, V2,
doi: 10.17632/8hxtgyyxrw.2
```

## Decisions Log
| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-06-06 | Dataset from Mendeley Data (Data in Brief) | Meets project scope requirement for Data in Brief / Scientific Data journals |
| 2026-06-06 | PyTorch as deep learning framework | Best CV ecosystem, fastest iteration, dominant in research |
| 2026-06-06 | COCO JSON annotations | Universal format, works with all modern detection/segmentation frameworks |
| 2026-06-06 | Invoke-WebRequest for dataset download | No API key needed, pure PowerShell, works for all team members |
| 2026-06-06 | 100 images + data augmentation | API limited to 100 files; augmentation compensates for small dataset |
| 2026-06-06 | Full dataset (5153 files) manually downloaded | Bypassed API 100-file limit; dataset organized by class folders |
