import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch, Circle
from pathlib import Path

OUTPUT_DIR = Path(__file__).parent / ".." / "assets"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

C_NAVY = "#2c3e50"
C_BLUE = "#2980b9"
C_TEAL = "#1abc9c"
C_GRAY = "#95a5a6"

plt.rcParams.update(
    {
        "font.family": "sans-serif",
        "font.size": 10,
        "figure.dpi": 200,
        "savefig.dpi": 200,
        "figure.facecolor": "white",
    }
)


def draw_icon_circle(ax, x, y, number, color):
    c = Circle((x, y), 0.25, facecolor=color, edgecolor="white", linewidth=2)
    ax.add_patch(c)
    ax.text(
        x,
        y,
        str(number),
        ha="center",
        va="center",
        fontsize=11,
        fontweight="bold",
        color="white",
    )


def draw_box(ax, x, y, w, h, icon_num, label, color=C_BLUE, sub=None):
    box = FancyBboxPatch(
        (x - w / 2, y - h / 2),
        w,
        h,
        boxstyle="round,pad=0.12",
        facecolor=color,
        edgecolor="white",
        linewidth=2,
        alpha=0.9,
    )
    ax.add_patch(box)
    draw_icon_circle(ax, x, y + 0.25, icon_num, color)
    ax.text(
        x,
        y - 0.25,
        label,
        ha="center",
        va="center",
        fontsize=8,
        fontweight="bold",
        color="white",
    )
    if sub:
        ax.text(
            x,
            y - h / 2 - 0.15,
            sub,
            ha="center",
            va="top",
            fontsize=6.5,
            color=C_GRAY,
            fontstyle="italic",
        )


def draw_arrow(ax, x1, y1, x2, y2):
    ax.annotate(
        "",
        xy=(x2, y2),
        xytext=(x1, y1),
        arrowprops=dict(arrowstyle="->", color=C_GRAY, lw=2.5),
    )


def draw_project_flow():
    fig, ax = plt.subplots(figsize=(14, 5.5))
    ax.set_xlim(0, 14)
    ax.set_ylim(0, 5.5)
    ax.axis("off")

    ax.text(
        7,
        5.2,
        "WOOD DEFECT DETECTION \u2014 PROJECT FLOW",
        ha="center",
        va="center",
        fontsize=14,
        fontweight="bold",
        color=C_NAVY,
    )

    top_boxes = [
        (1.5, 3.2, 1, "Dataset\n4000 images", C_NAVY, "Kaggle\n8 classes"),
        (3.8, 3.2, 2, "Preprocessing\n640x640", C_NAVY, "Resize + YOLO\nformat labels"),
        (
            6.1,
            3.2,
            3,
            "Data Split\n80/10/10",
            C_NAVY,
            "Train: 3200\nVal: 400, Test: 400",
        ),
        (8.4, 3.2, 4, "Augmentation\n+781 images", C_TEAL, "Class-aware\noversampling"),
        (10.7, 3.2, 5, "YOLOv8n\nTraining", C_BLUE, "20 epochs\nTesla T4 GPU"),
        (12.8, 3.2, 6, "Model\nbest.pt", C_BLUE, "6.2 MB\n8 classes"),
    ]

    for x, y, num, label, color, sub in top_boxes:
        draw_box(ax, x, y, 1.5, 1.2, num, label, color, sub)

    draw_arrow(ax, 2.25, 3.2, 3.05, 3.2)
    draw_arrow(ax, 4.55, 3.2, 5.35, 3.2)
    draw_arrow(ax, 6.85, 3.2, 7.65, 3.2)
    draw_arrow(ax, 9.15, 3.2, 9.95, 3.2)
    draw_arrow(ax, 11.45, 3.2, 12.05, 3.2)

    bottom_boxes = [
        (
            4.5,
            1.0,
            7,
            "Web Application (FastAPI + Bootstrap 5)",
            C_BLUE,
            "Upload / Webcam / Real-time inference / Color-coded detections",
        ),
        (
            10.5,
            1.0,
            8,
            "Detection Output",
            C_TEAL,
            "8 wood defect classes \u00b7 Confidence scores \u00b7 Bounding boxes",
        ),
    ]

    for x, y, num, label, color, sub in bottom_boxes:
        draw_box(ax, x, y, 4.5, 1.0, num, label, color, sub)

    ax.annotate(
        "",
        xy=(3.8, 1.5),
        xytext=(3.8, 2.6),
        arrowprops=dict(arrowstyle="->", color=C_GRAY, lw=2.5),
    )
    ax.annotate(
        "",
        xy=(10.7, 1.5),
        xytext=(10.7, 2.6),
        arrowprops=dict(arrowstyle="->", color=C_GRAY, lw=2.5),
    )

    fig.tight_layout()
    fig.savefig(OUTPUT_DIR / "architecture_diagram.png")
    plt.close(fig)
    print("  [OK] architecture_diagram.png")


if __name__ == "__main__":
    draw_project_flow()
