"""Split railway_track_dataset into train/val/test (80/10/10)."""
import shutil
import random
from pathlib import Path

random.seed(42)

DATA = Path("data/raw/Dataset/railway_track_surface_defects")
TRAIN = DATA / "train"
VALID = DATA / "valid"

# Collect all images and their labels (source files still exist)
all_items = []
for img_path in sorted(TRAIN.glob("images/*.jpg")):
    lbl_path = TRAIN / "labels" / f"{img_path.stem}.txt"
    if lbl_path.exists():
        all_items.append((img_path, lbl_path))
for img_path in sorted(VALID.glob("images/*.jpg")):
    lbl_path = VALID / "labels" / f"{img_path.stem}.txt"
    if lbl_path.exists():
        all_items.append((img_path, lbl_path))

print(f"Total labeled images: {len(all_items)}")

random.shuffle(all_items)

n = len(all_items)
n_train = int(n * 0.8)
n_val = int(n * 0.1)

splits = {
    "train": all_items[:n_train],
    "valid": all_items[n_train:n_train + n_val],
    "test": all_items[n_train + n_val:],
}

for split_name, items in splits.items():
    print(f"{split_name}: {len(items)} images")

# Create new directories
for split_name in splits:
    (DATA / split_name / "images").mkdir(parents=True, exist_ok=True)
    (DATA / split_name / "labels").mkdir(parents=True, exist_ok=True)

# Copy files to new split directories (source still exists)
for split_name, items in splits.items():
    img_dir = DATA / split_name / "images"
    lbl_dir = DATA / split_name / "labels"
    for img_path, lbl_path in items:
        shutil.copy2(img_path, img_dir / img_path.name)
        shutil.copy2(lbl_path, lbl_dir / lbl_path.name)

# Now safe to remove old train/valid dirs
for old_dir in [TRAIN, VALID]:
    if old_dir.exists():
        shutil.rmtree(old_dir)

# Update data.yaml
import yaml

yaml_path = DATA / "data.yaml"
with open(yaml_path) as f:
    cfg = yaml.safe_load(f)

cfg["train"] = "../train/images"
cfg["val"] = "../valid/images"
cfg["test"] = "../test/images"

with open(yaml_path, "w") as f:
    yaml.dump(cfg, f, default_flow_style=False)

print("\nUpdated data.yaml with train/val/test paths")
print("Done!")
