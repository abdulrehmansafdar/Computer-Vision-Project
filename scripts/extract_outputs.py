import json, re, sys

nb = json.load(
    open(
        r"C:\Users\hp\Desktop\Ab\practice\Computer-Vision-Project\notebooks\wood_defect_yolov8_training.ipynb",
        encoding="utf-8",
    )
)

# Save outputs to a text file
with open(
    r"C:\Users\hp\Desktop\Ab\practice\Computer-Vision-Project\scripts\nb_output.txt",
    "w",
    encoding="utf-8",
) as f:
    for i, cell in enumerate(nb["cells"]):
        if cell["cell_type"] == "code" and cell.get("outputs"):
            f.write(f"\n=== Cell {i} ===\n")
            for o in cell["outputs"]:
                if o.get("output_type") == "stream":
                    text = "".join(o.get("text", []))
                    f.write(text + "\n")
                elif o.get("output_type") == "execute_result":
                    data = o.get("data", {})
                    if "text/plain" in data:
                        f.write("".join(data["text/plain"]) + "\n")
                elif o.get("output_type") == "display_data":
                    data = o.get("data", {})
                    if "text/plain" in data:
                        f.write("".join(data["text/plain"]) + "\n")

print("Done. Check scripts/nb_output.txt")
