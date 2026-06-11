import json

nb = json.load(
    open(
        r"C:\Users\hp\Desktop\Ab\practice\Computer-Vision-Project\notebooks\wood_defect_yolov8_training.ipynb",
        encoding="utf-8",
    )
)
for i, cell in enumerate(nb["cells"]):
    if cell["cell_type"] == "code" and cell.get("outputs"):
        print(f"Cell {i}: {len(cell['outputs'])} outputs")
        for o in cell["outputs"]:
            if o.get("output_type") == "stream":
                text = "".join(o.get("text", []))[:300]
                print(f"  text: {text[:200]}")
            elif o.get("output_type") == "execute_result":
                data = o.get("data", {})
                if "text/plain" in data:
                    print(f"  result: {''.join(data['text/plain'])[:200]}")
