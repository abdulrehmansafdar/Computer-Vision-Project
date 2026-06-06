# Railway Track Surface Defect Detection

Computer vision project for detecting surface defects on railway tracks using image classification, object detection, and segmentation.

## Dataset

**Railway Track Surface Faults Dataset** — published in *Data in Brief* (2024).

- **Data**: 100 JPEG images with 7 defect classes (Grooves, Joints, Cracks, Flakings, Shellings, Spallings, Squats)
- **Structure**: 4 subdirectories in `data/raw/` (grouped by folder_id)
- **Source**: [Mendeley Data](https://data.mendeley.com/datasets/8hxtgyyxrw/2) — DOI: [10.17632/8hxtgyyxrw.2](https://doi.org/10.17632/8hxtgyyxrw.2)
- **License**: CC BY 4.0 (free to use, no API key required)
- **Augmentation**: Required to expand dataset for training

## Setup

### 1. Download Dataset

```powershell
.\scripts\download_data.ps1
```

No API key or login needed. Files save to `data/raw/folder_1..4/`.

### 2. Virtual Environment

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

### 3. Run Annotator

```powershell
python -m annotator.annotator
```

## Project Structure

```
├── data/              # Dataset (raw, processed, annotations)
├── src/               # Source code
│   ├── classification/
│   ├── detection/
│   ├── segmentation/
│   ├── utils/
│   └── evaluation/
├── annotator/         # Custom annotation tool
├── notebooks/         # Jupyter notebooks
├── models/            # Saved model weights (gitignored)
├── output/            # Predictions, logs, figures
├── reports/           # Research paper, figures
├── scripts/           # Utility scripts
└── memory_*.md        # Team working memory files
```

## Citation

```
Arain, A., Mehran, S., Shaikh, M. Z., Kumar, D., Hussain, T.,
Chowdhry, B. S. (2022). Railway Track Surface Faults Dataset.
Mendeley Data, V2. doi: 10.17632/8hxtgyyxrw.2
```
