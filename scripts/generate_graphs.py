import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker
import numpy as np
from pathlib import Path

OUTPUT_DIR = Path(__file__).parent / ".." / "assets"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

# Color scheme matching header: navy (#2c3e50), blue (#2980b9), teal (#1abc9c)
C_NAVY = "#2c3e50"
C_BLUE = "#2980b9"
C_TEAL = "#1abc9c"
C_GRAY = "#95a5a6"
C_WHITE = "#ffffff"

plt.rcParams.update(
    {
        "font.family": "sans-serif",
        "font.size": 11,
        "axes.titlesize": 13,
        "axes.labelsize": 11,
        "figure.dpi": 200,
        "savefig.dpi": 200,
        "savefig.bbox": "tight",
        "figure.facecolor": "white",
        "axes.facecolor": "white",
        "axes.edgecolor": C_NAVY,
        "axes.labelcolor": C_NAVY,
        "text.color": C_NAVY,
        "xtick.color": C_NAVY,
        "ytick.color": C_NAVY,
    }
)

CLASSES = [
    "Quartzity",
    "Live_Knot",
    "Marrow",
    "Resin",
    "Dead_Knot",
    "Knot_with_crack",
    "Knot_missing",
    "Crack",
]

COLORS = [C_NAVY, C_BLUE, C_TEAL, C_GRAY]


def graph_1_class_distribution():
    before = [116, 3242, 166, 541, 2372, 412, 97, 410]
    after = [445, 3969, 455, 682, 2854, 448, 420, 574]
    classes_short = [
        "Qtz",
        "Live_K",
        "Mar",
        "Res",
        "Dead_K",
        "Knot+Cr",
        "Knot_M",
        "Crack",
    ]

    x = np.arange(len(CLASSES))
    w = 0.35

    fig, ax = plt.subplots(figsize=(10, 5))
    ax.bar(
        x - w / 2,
        before,
        w,
        label="Before Augmentation",
        color=C_GRAY,
        edgecolor=C_WHITE,
        linewidth=0.5,
    )
    ax.bar(
        x + w / 2,
        after,
        w,
        label="After Augmentation",
        color=C_BLUE,
        edgecolor=C_WHITE,
        linewidth=0.5,
    )

    ax.set_xticks(x)
    ax.set_xticklabels(classes_short, rotation=25, ha="right", fontsize=9)
    ax.set_ylabel("Annotation Count", color=C_NAVY)
    ax.set_title(
        "Class Distribution — Before vs After Augmentation (Training Set)", color=C_NAVY
    )
    ax.legend(fontsize=9, loc="upper right")
    ax.set_axisbelow(True)
    ax.yaxis.grid(True, alpha=0.3, color=C_GRAY)
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)
    fig.tight_layout()
    fig.savefig(OUTPUT_DIR / "graph_1_class_distribution.png")
    plt.close(fig)
    print("  [OK] graph_1_class_distribution.png")


def graph_2_loss_curves():
    epochs = list(range(1, 21))
    box_loss = [
        1.980,
        1.816,
        1.793,
        1.758,
        1.726,
        1.705,
        1.691,
        1.665,
        1.654,
        1.629,
        1.617,
        1.602,
        1.591,
        1.567,
        1.546,
        1.523,
        1.517,
        1.484,
        1.466,
        1.450,
    ]
    cls_loss = [
        2.997,
        1.933,
        1.673,
        1.516,
        1.426,
        1.364,
        1.311,
        1.261,
        1.244,
        1.194,
        1.195,
        1.140,
        1.119,
        1.100,
        1.063,
        1.030,
        1.002,
        0.9723,
        0.940,
        0.9202,
    ]
    dfl_loss = [
        1.227,
        1.160,
        1.148,
        1.136,
        1.117,
        1.107,
        1.104,
        1.087,
        1.086,
        1.075,
        1.100,
        1.082,
        1.084,
        1.074,
        1.065,
        1.056,
        1.051,
        1.040,
        1.033,
        1.030,
    ]

    fig, ax = plt.subplots(figsize=(10, 5))
    ax.plot(
        epochs,
        box_loss,
        "o-",
        color=C_NAVY,
        linewidth=2,
        markersize=4,
        label="Box Loss",
    )
    ax.plot(
        epochs,
        cls_loss,
        "s-",
        color=C_BLUE,
        linewidth=2,
        markersize=4,
        label="Class Loss",
    )
    ax.plot(
        epochs,
        dfl_loss,
        "^-",
        color=C_TEAL,
        linewidth=2,
        markersize=4,
        label="DFL Loss",
    )

    ax.set_xlabel("Epoch", color=C_NAVY)
    ax.set_ylabel("Loss", color=C_NAVY)
    ax.set_title("Loss Curves (Training Set)", color=C_NAVY)
    ax.set_xticks(epochs)
    ax.legend(fontsize=9)
    ax.set_axisbelow(True)
    ax.yaxis.grid(True, alpha=0.3, color=C_GRAY)
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)
    fig.tight_layout()
    fig.savefig(OUTPUT_DIR / "graph_2_loss_curves.png")
    plt.close(fig)
    print("  [OK] graph_2_loss_curves.png")


if __name__ == "__main__":
    print("Generating graphs...")
    graph_1_class_distribution()
    graph_2_loss_curves()
    print("All graphs saved to assets/")
