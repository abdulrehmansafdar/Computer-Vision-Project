import os
from collections import Counter

data_dir = "data/Bounding Boxes - YOLO Format - 1/Bounding Boxes - YOLO Format - 1"
class_names = {
    0: "Quartzity",
    1: "Live_Knot",
    2: "Marrow",
    3: "Resin",
    4: "Dead_Knot",
    5: "Knot+Cr",
    6: "Knot_Miss",
    7: "Crack",
}

results = []
empty = 0
for f in os.listdir(data_dir):
    if not f.endswith(".txt"):
        continue
    path = os.path.join(data_dir, f)
    classes = set()
    with open(path) as fh:
        for line in fh:
            line = line.strip()
            if line:
                cls = int(line.split()[0])
                classes.add(cls)
    if len(classes) == 0:
        empty += 1
    results.append((f.replace(".txt", ""), len(classes), sorted(classes)))

results.sort(key=lambda x: -x[1])

print("Top 15 images by distinct defect class count:")
print(f"{'#':>3} {'Image ID':<12}  {'Distinct':>8}  Classes")
print("-" * 55)
for i, (img, cnt, cls_list) in enumerate(results[:15]):
    cls_names = [class_names.get(c, str(c)) for c in cls_list]
    print(f"{i + 1:>3}  {img:<12}  {cnt:>8}  {cls_names}")

print()
print(f"Images with annotations: {len(results) - empty}")
print(f"Empty images (0 annotations): {empty}")
print(f"Max distinct classes in one image: {results[0][1]}")
print(
    f"Number of images with max distinct classes: {sum(1 for r in results if r[1] == results[0][1])}"
)
print()

# Show all images with max distinct classes
max_distinct = results[0][1]
print(f"All images with {max_distinct} distinct classes:")
for img, cnt, cls_list in results:
    if cnt == max_distinct:
        cls_names = [class_names.get(c, str(c)) for c in cls_list]
        print(f"  {img}: {cls_names}")
