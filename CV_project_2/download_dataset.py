# Download Railway Defect Detection dataset from Roboflow
# Usage: python download_dataset.py

from roboflow import Roboflow

API_KEY = "oAHPVi0KEDHQXipmAaqd"
WORKSPACE = "model-train-np"
PROJECT = "railway-defect-detection-xomw5"
VERSION = 1

rf = Roboflow(api_key=API_KEY)
project = rf.workspace(WORKSPACE).project(PROJECT)
version = project.version(VERSION)

dataset = version.download("yolov8")

print(f"\nDataset downloaded to: {dataset.location}")
print(f"Classes ({len(project.classes)}): {project.classes}")
print("\nTo train, open training/railway_defect_trainer.ipynb in Google Colab")
