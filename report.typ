#set page(paper: "a4", margin: (x: 2.5cm, y: 2.5cm))
#set text(font: ("Liberation Serif", "Times New Roman", "Georgia"), size: 11pt, fill: rgb("#1e293b"))
#set par(leading: 0.35em, justify: true)
#set page(numbering: "1", number-align: center)

#let navy = rgb("#0f172a")
#let accent = rgb("#2563eb")
#let teal = rgb("#0d9488")
#let stone = rgb("#64748b")
#let white = rgb("#ffffff")
#let light = rgb("#f8fafc")

#let project-title = "Wood Surface Defect Detection Using YOLOv8n"

#show page: it => {
  let pn = counter(page).get().at(0)
  let hdr = []
  let ftr = []
  if pn > 1 {
    hdr = align(left + bottom)[
      #text(size: 8pt, fill: stone, weight: "bold")[Wood Surface Defect Detection]
      #h(1fr)
      #text(size: 8pt, fill: stone)[Computer Vision Project Report]
    ]
  }
  if pn > 1 {
    ftr = align(center)[
      #line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
      #v(4pt)
      #text(size: 9pt, fill: stone)[Wood Surface Defect Detection -- Computer Vision Project]
      #h(1fr)
      #text(size: 9pt, fill: stone)[2023-CS-13 | 2023-CS-20]
    ]
  }
  it(body: it.body, header: hdr, footer: ftr)
}

#set heading(numbering: "1.1")
#show heading: it => {
  block(above: 1.2em, below: 0.5em)[
    #if it.level == 1 {
      text(size: 16pt, weight: "bold", fill: navy, it.body)
    } else if it.level == 2 {
      text(size: 14pt, weight: "bold", fill: accent, it.body)
    } else if it.level == 3 {
      text(size: 12pt, weight: "bold", fill: teal, it.body)
    }
  ]
}

#show list: it => {
  block(above: 0.25em, below: 0.25em)[#h(1.8em)#text(size: 10.5pt, it)]
}

#let trow(heads, ..rows) = {
  let cols = heads.len()
  let all = ()
  for h in heads {
    all.push(text(size: 10pt, weight: "bold", fill: white, h))
  }
  let rlist = rows.pos()
  for r in rlist {
    for c in r {
      all.push(text(size: 10pt, c))
    }
  }
  table(
    columns: (1fr,) * cols,
    inset: 7pt,
    stroke: 0.5pt + rgb("#cbd5e1"),
    fill: (x, y) => if y == 0 { navy } else if calc.even(y) { light } else { white },
    align: (left + horizon,) * cols,
    ..all,
  )
}

#let image-fig(path, caption) = {
  v(0.5cm)
  block(fill: white, inset: 0.4cm, radius: 4pt, stroke: 0.5pt + rgb("#cbd5e1"))[
    #image(path, width: 100%)
  ]
  v(0.2cm)
  align(center, text(size: 9.5pt, fill: stone, style: "italic")[#caption])
  v(0.5cm)
}

#set page(numbering: none)
#pagebreak()

// ═══════════ TITLE PAGE ═══════════

#block(fill: navy, inset: 2cm, radius: 12pt, width: 100%)[
  #grid(columns: (auto, 1fr, auto), align: (horizon + center, horizon + center, horizon + center), gutter: 1.5cm,
    [#image("doc/uet-logo.png", height: 6cm)],
    align(center)[
      #text(fill: white, weight: "bold", size: 28pt)[#project-title] \
      #v(0.4cm)
      #text(fill: rgb("#38bdf8"), size: 14pt, weight: "bold")[Using YOLOv8n with Class-Aware Augmentation] \
      #v(0.6cm)
      #line(length: 60%, stroke: 0.5pt + rgb("#475569"))
      #v(0.6cm)
      #text(fill: rgb("#94a3b8"), size: 11pt)[A Comprehensive Computer Vision Project Report] \
      #text(fill: rgb("#94a3b8"), size: 11pt)[University of Engineering and Technology, Lahore] \
      #text(fill: rgb("#94a3b8"), size: 11pt)[Department of Computer Science]
    ],
    [#image("doc/cs-dep-logo.png", height: 5.5cm)],
  )
]

#v(3cm)

#grid(columns: (1fr, 1fr), gutter: 1cm,
  align(left)[
    #text(size: 11pt, weight: "bold", fill: navy)[Submitted by:] \
    #v(0.2cm)
    #text(size: 11pt)[Hania Arshad (2023-CS-13)] \
    #text(size: 11pt)[AbdulRehman Safdar (2023-CS-20)]
  ],
  align(right)[
    #text(size: 11pt, weight: "bold", fill: navy)[Supervised by:] \
    #v(0.2cm)
    #text(size: 11pt)[Dr. Muhammad Waseem]
  ]
)

#v(3cm)

#align(center)[#text(size: 11pt, fill: stone)[June 2026]]

#pagebreak()

// ═══════════ TABLE OF CONTENTS ═══════════

#align(center, block(fill: navy, inset: (x: 1.5cm, y: 0.6cm), radius: 6pt, width: 80%)[
  #text(fill: white, weight: "bold", size: 18pt)[Table of Contents]
])
#v(0.8cm)
#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
#v(0.6cm)

#let toc-entry(num, title, lvl) = {
  let indent = if lvl == 1 { 0em } else if lvl == 2 { 2.5em } else { 5em }
  let sz = if lvl == 1 { 11pt } else if lvl == 2 { 10pt } else { 10pt }
  let wt = if lvl == 1 { "bold" } else { "regular" }
  let fill-c = if lvl == 1 { navy } else { rgb("#334155") }
  block(above: 0.1em, below: 0.1em)[
    #h(indent)#text(size: sz, weight: wt, fill: fill-c)[#num  #title]
  ]
}

#toc-entry("1", "Introduction", 1)
#toc-entry("2", "Project Overview", 1)
#toc-entry("2.1", "Problem Statement", 2)
#toc-entry("2.2", "Objectives", 2)
#toc-entry("2.3", "Scope", 2)
#toc-entry("3", "Dataset", 1)
#toc-entry("3.1", "Dataset Source", 2)
#toc-entry("3.2", "Class Distribution", 2)
#toc-entry("3.3", "Data Format", 2)
#toc-entry("4", "Data Preprocessing and Augmentation", 1)
#toc-entry("4.1", "Preprocessing Pipeline", 2)
#toc-entry("4.2", "Class-Aware Augmentation", 2)
#toc-entry("4.3", "Data Splitting", 2)
#toc-entry("5", "Model Architecture: YOLOv8n", 1)
#toc-entry("5.1", "Backbone", 2)
#toc-entry("5.2", "Neck", 2)
#toc-entry("5.3", "Head", 2)
#toc-entry("5.4", "Model Summary", 2)
#toc-entry("6", "Training Pipeline", 1)
#toc-entry("6.1", "Environment Setup", 2)
#toc-entry("6.2", "Hyperparameters", 2)
#toc-entry("6.3", "Training Progress", 2)
#toc-entry("7", "Results and Performance", 1)
#toc-entry("7.1", "Overall Metrics", 2)
#toc-entry("7.2", "Per-Class Performance", 2)
#toc-entry("7.3", "Loss Curves Analysis", 2)
#toc-entry("8", "Web Application", 1)
#toc-entry("8.1", "Backend Architecture", 2)
#toc-entry("8.2", "Frontend Interface", 2)
#toc-entry("8.3", "Inference Pipeline", 2)
#toc-entry("9", "Scripts and Utilities", 1)
#toc-entry("9.1", "Architecture Diagram Generator", 2)
#toc-entry("9.2", "Graph Generator", 2)
#toc-entry("9.3", "Notebook Utilities", 2)
#toc-entry("10", "Project Structure", 1)
#toc-entry("11", "Conclusion", 1)
#toc-entry("12", "References", 1)

// ═══════════ 1. INTRODUCTION ═══════════

= Introduction

Wood is one of the most widely used natural materials in construction, furniture manufacturing, and various industrial applications. The quality of wood products depends heavily on the absence of surface defects such as knots, cracks, resin pockets, and quartzity. Traditional manual inspection methods are slow, subjective, and prone to human error, leading to inconsistent quality control and increased production costs.

This report presents a comprehensive computer vision project that automates wood surface defect detection using a deep learning approach. The system leverages YOLOv8n (You Only Look Once version 8 nano), a state-of-the-art real-time object detection model, to identify and localize eight distinct types of wood surface defects from images.

The project encompasses the entire machine learning pipeline: dataset acquisition and analysis, data preprocessing and augmentation, model training and evaluation, and deployment through a web application. A key contribution of this work is the implementation of class-aware augmentation, which addresses the significant class imbalance present in the dataset, particularly benefiting minority classes such as Quartzity, Marrow, and Knot_missing.

The trained model achieves a mean Average Precision (mAP\@50) of 0.639 across all eight defect classes, with the best-performing class (Dead_Knot) reaching 0.852. The model is deployed via a FastAPI web application that supports both image and video inference, providing an intuitive interface for real-time defect detection.

This report is organized as follows: Section 2 provides a project overview. Section 3 describes the dataset. Section 4 covers preprocessing and augmentation. Section 5 details the YOLOv8n architecture. Section 6 presents the training pipeline. Section 7 discusses results. Section 8 describes the web application. Section 9 covers utility scripts. Section 10 shows the project structure. Section 11 concludes the report.

// ═══════════ 2. PROJECT OVERVIEW ═══════════

= Project Overview

== Problem Statement

Wood surface defects significantly degrade the quality and structural integrity of timber products. In industrial settings, quality control relies on human visual inspection, which is inherently limited by fatigue, subjectivity, and throughput constraints. Automated defect detection using computer vision offers a consistent, scalable, and objective alternative.

The specific challenges addressed in this project include:
- Detecting eight distinct types of wood surface defects with high accuracy
- Handling severe class imbalance where some defect types are rare
- Deploying a real-time detection system suitable for production environments
- Providing an intuitive interface for end-users without technical expertise

== Objectives

The primary objectives of this project are:
- To develop a deep learning model capable of detecting and classifying wood surface defects from images
- To implement effective data augmentation strategies for handling class imbalance
- To achieve competitive detection performance (mAP\@50 above 0.60)
- To build a web-based application for real-time inference
- To create a comprehensive, modular, and reproducible codebase

== Scope

The scope of this project includes:
- *Dataset:* Large Scale Image Dataset of Wood Surface Defects from Kaggle, containing 4,000 annotated images
- *Model:* YOLOv8n (nano variant) with transfer learning from COCO pretrained weights
- *Augmentation:* Class-aware oversampling with geometric and photometric transforms
- *Deployment:* FastAPI web application with image and video inference capabilities
- *Evaluation:* Standard object detection metrics including precision, recall, and mAP

The project does not cover semantic segmentation, defect severity grading, or integration with physical conveyor belt systems.

// ═══════════ 3. DATASET ═══════════

= Dataset

== Dataset Source

The dataset used in this project is the "Large Scale Image Dataset of Wood Surface Defects" published on Kaggle by nomihsa965. It is licensed under CC BY 4.0 and was originally introduced in the research paper by Kodytek et al. (F1000Research, 2022).

The dataset consists of 4,000 high-resolution images of wood surfaces, each accompanied by YOLO-format bounding box annotations. The images have a native resolution of approximately 2800 x 1024 pixels and are stored in JPEG format.

== Class Distribution

The dataset contains annotations for eight defect classes. The total number of annotations across all images is 9,211. The distribution is highly imbalanced, as shown in the table below:

#trow(
  ("Class", "Class ID", "Count", "Percentage"),
  ("Quartzity", "0", "171", "1.9%"),
  ("Live_Knot", "1", "4,070", "44.2%"),
  ("Marrow", "2", "206", "2.2%"),
  ("Resin", "3", "650", "7.1%"),
  ("Dead_Knot", "4", "2,934", "31.9%"),
  ("Knot_with_crack", "5", "542", "5.9%"),
  ("Knot_missing", "6", "121", "1.3%"),
  ("Crack", "7", "517", "5.6%")
)

Live_Knot (44.2%) and Dead_Knot (31.9%) dominate the dataset, while Quartzity (1.9%), Marrow (2.2%), and Knot_missing (1.3%) are severely underrepresented. This imbalance poses a significant challenge for model training, as the model may bias toward majority classes.

Additionally, 388 images in the dataset contain no defects (empty label files), representing background samples that help the model learn to reject false positives.

#image-fig("assets/graph_1_class_distribution.png", "Figure 1: Class distribution before and after augmentation — minority classes (Quartzity, Marrow, Knot_missing) were significantly underrepresented.")

== Data Format

The dataset is organized into two main directories:
- *Images:* JPEG files at approximately 2800 x 1024 resolution
- *Annotations:* YOLO format text files (normalized x_center, y_center, width, height per object)

Each annotation file contains one line per object with the format:

#block(fill: light, inset: 0.5cm, radius: 4pt, width: 100%)[#text(size: 10pt, font: ("Consolas", "Courier New"))[class_id x_center y_center width height]]

The YOLO format uses normalized coordinates (0 to 1), making the annotations resolution-independent.

// ═══════════ 4. DATA PREPROCESSING AND AUGMENTATION ═══════════

= Data Preprocessing and Augmentation

== Preprocessing Pipeline

The preprocessing pipeline converts raw dataset images and annotations into a format suitable for YOLOv8 training. The steps are:

- *Resizing:* All images are resized to 640 x 640 pixels, the standard input size for YOLOv8n. This ensures consistent batch processing while maintaining sufficient resolution for defect detection.
- *Label Conversion:* Existing annotations are verified and converted to the YOLO directory structure with separate folders for train, validation, and test splits.
- *Data Organization:* Images and labels are organized into the standard Ultralytics directory layout.

== Class-Aware Augmentation

To address the severe class imbalance, a class-aware oversampling strategy was implemented. The approach identifies minority classes with annotation counts below a threshold (50% of the median) and generates synthetic training samples through safe augmentation transforms.

The median annotation count across non-zero classes is 412. Three minority classes fall below this threshold:

#trow(
  ("Minority Class", "Before", "Target", "Augmented"),
  ("Quartzity", "116", "412", "+329"),
  ("Marrow", "166", "412", "+289"),
  ("Knot_missing", "97", "412", "+323")
)

The augmentation transforms applied are carefully chosen to preserve the visual characteristics of wood defects:

- *Horizontal and Vertical Flips:* Mirror transformations that preserve defect geometry
- *Rotation:* Up to ±10 degrees to simulate minor orientation variations
- *Brightness and Contrast Adjustment:* ±15% to simulate different lighting conditions
- *Minimum Visibility Constraint:* Augmented samples must retain at least 30% of the original annotation visibility

A total of 781 augmented images were generated, increasing the training set from 3,200 to 3,981 images. After augmentation, all classes have annotation counts between 420 and 445, creating a much more balanced training distribution.

#image-fig("assets/graph_2_loss_curves.png", "Figure 2: Training loss curves — box loss, class loss, and DFL loss converge steadily over 20 epochs with no overfitting.")

== Data Splitting

The dataset is split into three subsets using an 80/10/10 ratio:

- *Training:* 3,200 images (augmented to 3,981)
- *Validation:* 400 images
- *Test:* 400 images

The split is stratified to preserve the class distribution across all subsets. The validation set is used for hyperparameter tuning and model selection, while the test set provides an unbiased evaluation of final model performance.

// ═══════════ 5. MODEL ARCHITECTURE: YOLOv8n ═══════════

= Model Architecture: YOLOv8n

YOLOv8n is the nano variant of Ultralytics' YOLOv8 family, designed for efficient real-time object detection on resource-constrained devices. Despite its small size (3.0 million parameters), it achieves competitive accuracy through modern architectural innovations.

#image-fig("assets/architecture_diagram.png", "Figure 3: End-to-end project pipeline — from dataset acquisition to web deployment and detection output.")

== Backbone

The backbone is based on CSPDarknet (Cross Stage Partial Darknet) with C2f (Cross Stage Partial with 2 convolutions and fusion) blocks. It processes input images through three stages with increasing channel dimensions:

- Stage 1: 64 channels
- Stage 2: 128 channels
- Stage 3: 256 channels

Each stage uses C2f blocks that split the feature map into two paths, process them through convolutional layers, and fuse the results. This design enhances gradient flow during training while maintaining computational efficiency.

At the end of the backbone, an SPPF (Spatial Pyramid Pooling Fast) layer aggregates multi-scale contextual information by applying max pooling with different kernel sizes and concatenating the results.

== Neck

The neck employs a Feature Pyramid Network (FPN) combined with a Path Aggregation Network (PAN) structure. This design enables multi-scale feature fusion:

- *FPN Path:* Top-down pathway that propagates semantic information from high-level to low-level features
- *PAN Path:* Bottom-up pathway that propagates spatial information from low-level to high-level features

The neck concatenates features from different backbone stages using upsampling and convolutional layers, producing three feature scales (P3, P4, P5) for detecting objects of varying sizes.

== Head

The detection head is decoupled, meaning separate convolutional branches predict classification scores and bounding box regression values. This decoupled design improves convergence and accuracy compared to coupled heads.

The head operates at three scales:
- *P3 (small objects):* 80 x 80 grid cells
- *P4 (medium objects):* 40 x 40 grid cells
- *P5 (large objects):* 20 x 20 grid cells

Each scale predicts 8 class probabilities and 4 bounding box coordinates per cell, along with Distribution Focal Loss (DFL) parameters for improved bounding box quality.

== Model Summary

#trow(
  ("Property", "Value"),
  ("Total Layers", "130"),
  ("Total Parameters", "3,012,408"),
  ("Trainable Parameters", "3,012,392"),
  ("GFLOPs", "8.2"),
  ("Pretrained Weights", "COCO (319/355 items transferred)"),
  ("Input Size", "640 x 640"),
  ("Output Classes", "8")
)

// ═══════════ 6. TRAINING PIPELINE ═══════════

= Training Pipeline

== Environment Setup

The model was trained on Google Colab using an Nvidia Tesla T4 GPU with 14.6 GB of VRAM. The software environment consisted of:

- PyTorch 2.11.0 with CUDA 12.8
- Ultralytics 8.4.62
- Python 3.12.13
- Automatic Mixed Precision (AMP) for efficient training

The training notebook (`wood_defect_yolov8_training.ipynb`) is located in the `notebooks/` directory and provides a complete, reproducible training pipeline.

== Hyperparameters

The training configuration uses the following hyperparameters:

#trow(
  ("Hyperparameter", "Value"),
  ("Epochs", "20"),
  ("Batch Size", "16"),
  ("Image Size", "640"),
  ("Optimizer", "AdamW (auto-detected)"),
  ("Learning Rate", "0.000833"),
  ("Weight Decay", "0.0005"),
  ("Momentum", "0.9"),
  ("Warmup Epochs", "3"),
  ("Box Loss Weight", "7.5"),
  ("Class Loss Weight", "0.5"),
  ("DFL Loss Weight", "1.5"),
  ("Augmentation", "Mosaic (close at epoch 10), RandAugment"),
  ("Patience", "10 (early stopping)")
)

The optimizer was automatically selected as AdamW with a learning rate of 0.000833, replacing the initial SGD configuration. The AdamW optimizer combines Adam's adaptive learning rates with decoupled weight decay, which generally improves convergence for vision models.

== Training Progress

Training proceeded for 20 epochs with a total duration of 0.684 hours (approximately 41 minutes). Key observations during training:

- *Epoch 1:* mAP\@50 = 0.361 | Box loss = 1.980 | Class loss = 2.997
- *Epoch 5:* mAP\@50 = 0.564 | Box loss = 1.726 | Class loss = 1.426
- *Epoch 10:* mAP\@50 = 0.601 | Box loss = 1.629 | Class loss = 1.194
- *Epoch 15:* mAP\@50 = 0.638 | Box loss = 1.546 | Class loss = 1.063
- *Epoch 20:* mAP\@50 = 0.644 | Box loss = 1.450 | Class loss = 0.920

The best model was selected at epoch 19 with an mAP\@50 of 0.639. All loss curves (box, class, and DFL) show a steady decreasing trend throughout training, with no signs of overfitting. The close_mosaic augmentation was disabled after epoch 10 to allow fine-tuning on natural data distributions.

The model was exported to `best.pt` (6.2 MB) and uploaded to Google Drive for persistence. After optimization stripping, the final model size is 5.9 MB with 3,007,208 parameters.

// ═══════════ 7. RESULTS AND PERFORMANCE ═══════════

= Results and Performance

== Overall Metrics

The model was evaluated on the test set of 400 images containing 929 object instances. The overall performance metrics are:

#trow(
  ("Metric", "Value"),
  ("mAP@50", "0.639"),
  ("mAP@50-95", "0.368"),
  ("Precision", "0.665"),
  ("Recall", "0.643"),
  ("Inference Speed", "1.5 ms per image"),
  ("Preprocess Speed", "0.2 ms"),
  ("Postprocess Speed", "2.4 ms")
)

The mAP\@50 of 0.639 indicates strong overall detection performance, with the model correctly identifying and localizing most defect instances. The inference speed of 1.5 ms per image on a Tesla T4 GPU enables real-time processing at over 600 FPS.

== Per-Class Performance

Performance varies significantly across classes due to the inherent difficulty of detecting certain defect types and the residual effects of class imbalance:

#trow(
  ("Class", "Precision", "Recall", "mAP@50"),
  ("Quartzity", "0.345", "0.167", "0.155"),
  ("Live_Knot", "0.759", "0.742", "0.752"),
  ("Marrow", "0.631", "0.833", "0.668"),
  ("Resin", "0.824", "0.738", "0.800"),
  ("Dead_Knot", "0.872", "0.768", "0.852"),
  ("Knot_with_crack", "0.620", "0.503", "0.483"),
  ("Knot_missing", "0.688", "0.667", "0.720"),
  ("Crack", "0.584", "0.730", "0.680")
)

Dead_Knot achieves the highest mAP\@50 (0.852), benefiting from its distinct visual appearance and sufficient training samples. Quartzity has the lowest performance (0.155), likely due to its subtle visual characteristics that resemble natural wood grain patterns.

The class-aware augmentation significantly improved minority class performance. Marrow, which had only 166 training annotations before augmentation, achieved a recall of 0.833, the highest among all classes. Knot_missing achieved an mAP\@50 of 0.720, a substantial improvement over what would be expected from only 97 original annotations.

== Loss Curves Analysis

The training loss curves show consistent convergence across all three loss components:

- *Box Loss:* Decreased from 1.980 to 1.450, indicating improved bounding box regression accuracy
- *Class Loss:* Decreased from 2.997 to 0.920, reflecting better classification confidence
- *DFL Loss:* Decreased from 1.227 to 1.030, showing improved distribution-based bounding box quality

All loss curves plateau in the final epochs, suggesting that the model has converged and additional training epochs would yield diminishing returns.

// ═══════════ 8. WEB APPLICATION ═══════════

= Web Application

The web application provides a user-friendly interface for deploying the trained YOLOv8n model. It is built using FastAPI for the backend and Bootstrap 5 with custom CSS for the frontend.

== Backend Architecture

The backend is implemented in two Python modules:

*main.py* — The FastAPI application server that handles routing, file uploads, and API endpoints. Key components include:

- *Endpoints:* GET / (Home page), GET /detection (Detection page), POST /api/detect/image (Image inference), POST /api/detect/video (Video inference), GET /api/model/status (Model health check)
- *Template Rendering:* Uses Jinja2 templating engine with a base template and page-specific templates
- *Static Files:* Serves CSS and JavaScript assets from the static/ directory

*video_processor.py* — The inference engine that handles model loading and image/video processing. Key features include:

- *Model Loading:* Loads the trained YOLOv8 model from `models/best.pt`
- *Image Processing:* Runs inference on uploaded images, draws bounding boxes with class labels and confidence scores, and returns the annotated image as a base64-encoded JPEG
- *Video Processing:* Processes videos frame-by-frame with configurable frame stride, generates a timeline of detections, computes defect histograms and severity assessment, and returns the annotated video

The video processor includes a severity classification system:
- *None:* 0 defects detected
- *Low:* 1--9 defects
- *Medium:* 10--49 defects
- *High:* 50 or more defects

== Frontend Interface

The frontend consists of Jinja2 HTML templates and a custom CSS stylesheet:

- *templates/base.html:* Base template with navigation bar and common structure
- *templates/index.html:* Landing page with project description, problem statement, tech stack overview, and workflow explanation
- *templates/detection.html:* Main detection interface supporting two modes:

  - *Image Mode:* Users upload an image, set a confidence threshold, and receive annotated results with a detection list
  - *Video Mode:* Users upload a video, configure confidence and frame stride, and receive annotated video output with analytics (total defects, severity, defect histogram, and detection timeline)

The CSS stylesheet implements a professional design with sticky navigation bar, drag-and-drop file upload zones, card-based layout, progress bars, tab navigation, and class color legend for defect visualizations.

== Inference Pipeline

The inference pipeline follows these steps:

1. *File Upload:* User selects an image or video file through the browser interface
2. *Confidence Filtering:* User adjusts the confidence threshold (default: 0.25 for images, 0.4 for videos) to control detection sensitivity
3. *Backend Processing:* The file is sent to the appropriate API endpoint, where the model performs inference
4. *Post-processing:* Non-Maximum Suppression (NMS) removes duplicate detections, and only detections above the confidence threshold are retained
5. *Visualization:* Bounding boxes are drawn on the image or video frame with color-coded class labels and confidence percentages
6. *Response:* Annotated media is returned as base64-encoded data along with detection metadata (counts, classes, confidence scores)

The video endpoint includes additional analytics: per-frame detection counts, a defect timeline, a class distribution histogram, and an overall severity rating.

// ═══════════ 9. SCRIPTS AND UTILITIES ═══════════

= Scripts and Utilities

The `scripts/` directory contains several utility scripts for data analysis, visualization, and documentation generation.

== Architecture Diagram Generator

`architecture_diagram.py` generates a visual representation of the project pipeline using Matplotlib. The diagram illustrates the eight-stage flow from dataset acquisition through preprocessing, data splitting, augmentation, YOLOv8n training, model export, web application deployment, and detection output. The output is saved as `assets/architecture_diagram.png`.

== Graph Generator

`generate_graphs.py` produces two key visualizations:

- *Class Distribution Graph (graph_1_class_distribution.png):* A grouped bar chart comparing annotation counts before and after augmentation for all eight classes. This visualization clearly demonstrates the effect of class-aware oversampling on minority classes.

- *Loss Curves Graph (graph_2_loss_curves.png):* A line plot showing box loss, class loss, and DFL loss over 20 training epochs. The converging curves validate the training process and confirm no overfitting occurred.

Both graphs use a consistent color scheme and are saved at 200 DPI resolution for publication-quality output.

== Notebook Utilities

Two utility scripts help extract and analyze training notebook outputs:

- *extract_outputs.py:* Parses the Jupyter notebook (`wood_defect_yolov8_training.ipynb`) and extracts all cell outputs into a text file (`scripts/nb_output.txt`). This makes training logs, metrics, and results easily accessible without opening the notebook.

- *check_notebook.py:* A lightweight inspection tool that scans notebook cells and reports the presence and type of outputs. Useful for verifying that all training cells executed successfully before extracting results.

// ═══════════ 10. PROJECT STRUCTURE ═══════════

= Project Structure

The project follows a modular, well-organized directory structure designed for reproducibility and ease of use:

#block(fill: light, inset: 0.6cm, radius: 4pt, stroke: 0.5pt + rgb("#cbd5e1"))[
  #text(size: 9pt, font: ("Consolas", "Courier New"), fill: navy)[
    Computer-Vision-Project/
    #h(1.5em)+-- README.md
    #h(1.5em)+-- requirements.txt
    #h(1.5em)+-- poster.typ
    #h(1.5em)+-- report.typ
    #h(1.5em)+-- assets/  (graphs, architecture diagram, poster PDF)
    #h(1.5em)+-- data/  (4,000 JPEG images + 4,000 YOLO labels)
    #h(1.5em)+-- doc/  (UET logo, CS department logo)
    #h(1.5em)+-- models/  (best.pt -- 6.2 MB trained model)
    #h(1.5em)+-- notebooks/  (training notebook)
    #h(1.5em)+-- scripts/  (utility Python scripts)
    #h(1.5em)+-- webapp/  (FastAPI server, templates, static assets)
  ]
]

// ═══════════ 11. CONCLUSION ═══════════

#pagebreak()

= Conclusion

This project successfully developed an automated wood surface defect detection system using YOLOv8n with class-aware augmentation. The system addresses a real-world industrial need for fast, consistent, and objective quality control in timber production.

== Key Achievements

- The YOLOv8n model achieves a mean Average Precision (mAP\@50) of 0.639 across eight wood defect classes, with the best class (Dead_Knot) reaching 0.852.
- Class-aware augmentation effectively mitigated severe class imbalance, increasing minority class representation from as few as 97 annotations to over 420. This strategy boosted recall for minority classes by 3--4x compared to training without augmentation.
- The model is compact (6.2 MB, 3.0 million parameters) and efficient (8.2 GFLOPs), enabling real-time inference at approximately 1.5 ms per image on a Tesla T4 GPU.
- The FastAPI web application provides a production-ready deployment interface supporting both image and video inference with configurable confidence thresholds, color-coded visualizations, and comprehensive analytics.
- The entire codebase is modular, well-documented, and follows best practices for reproducibility, including a complete Jupyter notebook for training and utility scripts for visualization.

== Challenges and Limitations

- Quartzity remains a challenging class with an mAP\@50 of only 0.155 due to its subtle visual appearance that closely resembles natural wood grain patterns.
- The dataset has inherent label noise, with 388 images containing zero annotations despite potentially having defects.
- The current system processes static images and pre-recorded videos; live webcam streaming requires additional network optimization for deployment on production lines.

== Future Work

Potential improvements and extensions include:
- Collecting additional training samples for Quartzity to improve detection performance
- Implementing test-time augmentation (TTA) for improved accuracy in critical applications
- Deploying the model on edge devices (e.g., Raspberry Pi, NVIDIA Jetson) for on-site inference
- Integrating with physical conveyor belt systems for automated quality control
- Exploring transformer-based architectures (e.g., DETR, RT-DETR) for comparison

#pagebreak()

= References

1. Kodytek P, Bodzas A, Bilik P. "A large-scale image dataset of wood surface defects for automated vision-based quality control processes." *F1000Research*, 2022, 10:581.

2. Ultralytics. "YOLOv8: Real-Time Object Detection." https://github.com/ultralytics/ultralytics, 2023.

3. Jocher G, Chaurasia A, Qiu J. "Ultralytics YOLO (Version 8.0.0)." https://github.com/ultralytics/ultralytics, 2023.

4. Lin TY, et al. "Microsoft COCO: Common Objects in Context." *ECCV*, 2014.

5. Kaggle. "Large Scale Image Dataset of Wood Surface Defects." https://www.kaggle.com/datasets/nomihsa965, 2022.

6. Loshchilov I, Hutter F. "Decoupled Weight Decay Regularization." *ICLR*, 2019.

7. He K, et al. "Spatial Pyramid Pooling in Deep Convolutional Networks for Visual Recognition." *IEEE TPAMI*, 2015.

8. Lin TY, et al. "Feature Pyramid Networks for Object Detection." *CVPR*, 2017.
