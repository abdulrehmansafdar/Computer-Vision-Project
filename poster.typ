#set page(paper: "a0", margin: (x: 3cm, top: 3cm, bottom: 2.5cm))
#set text(font: ("Liberation Sans", "Arial"), size: 32pt, fill: rgb("#1e293b"))

#let navy = rgb("#0f172a")
#let accent = rgb("#2563eb")
#let teal = rgb("#0d9488")
#let stone = rgb("#64748b")
#let white = rgb("#ffffff")
#let light = rgb("#f8fafc")
#let border-gray = rgb("#cbd5e1")

#let section(title) = {
  v(1cm)
  block(fill: navy, inset: (x: 1.5cm, y: 0.8cm), radius: 8pt, width: 100%)[
    #text(fill: white, weight: "bold", size: 42pt, title)
  ]
  v(0.5cm)
}

#let pill(title, color: accent) = {
  block(fill: color, inset: (x: 0.8cm, y: 0.3cm), radius: 50pt)[
    #text(fill: white, weight: "bold", size: 28pt, title)
  ]
  v(0.3cm)
}

#let bul(t) = {
  block(above: 0.25cm, below: 0.25cm)[
    #grid(columns: (auto, 1fr), gutter: 0.5cm,
      text(fill: accent, weight: "bold", size: 28pt)[•],
      text(size: 26pt, t)
    )
  ]
}

// ═══════════ HEADER ═══════════
#block(fill: navy, inset: (x: 3cm, y: 1.5cm), radius: 16pt, width: 100%)[
  #grid(columns: (auto, 1fr, auto), align: (horizon + center, horizon + center, horizon + center), gutter: 2cm,
    [#image("doc/uet-logo.png", height: 8.5cm)],
    align(center)[
      #text(fill: white, weight: "bold", size: 72pt)[Wood Surface Defect Detection] \
      #v(0.3cm)
      #text(fill: rgb("#38bdf8"), size: 36pt, weight: "bold")[Using YOLOv8n with Class-Aware Augmentation] \
      #v(0.2cm)
      #text(fill: rgb("#94a3b8"), size: 28pt, weight: "medium")[Computer Vision Project — University of Engineering & Technology, Lahore]
    ],
    [#image("doc/cs-dep-logo.png", height: 7.5cm)],
  )
]
#v(0.1cm)

// ═══════════ ROW 1: PROBLEM ═══════════
#section("Problem Definition")
#block(fill: light, inset: 1.5cm, radius: 12pt, stroke: 1.5pt + border-gray, width: 100%)[
  #set par(leading: 1.4em)
  #text(size: 30pt, weight: "medium")[
    Wood surface defects — *quartzity, knots, cracks, resin pockets, and marrow* — significantly degrade timber product quality. Manual inspection is subjective, slow, and error-prone. This project delivers an automated, real-time detection system using a fine-tuned *YOLOv8n* deep learning model, enabling consistent quality control on production lines.
  ]
]
#v(0.1cm)

// ═══════════ ROW 2: AUGMENTATION + TECHNOLOGIES ═══════════
#grid(columns: (1fr, 1fr), gutter: 2cm,
  [
    #section("Augmentation Strategy")
    #pill("Class-Aware Oversampling", color: accent)
    #text(size: 26pt, weight: "medium")[Minority classes augmented to match median (~412/class):]
    #v(0.1cm)
    #grid(columns: (1fr, 1fr), gutter: 0.6cm,
      block(fill: light, inset: 0.5cm, radius: 6pt, stroke: 1pt + border-gray, width: 100%)[#text(size: 24pt)[#text(fill: accent)[✔] H-Flip / V-Flip]],
      block(fill: light, inset: 0.5cm, radius: 6pt, stroke: 1pt + border-gray, width: 100%)[#text(size: 24pt)[#text(fill: accent)[✔] ±10° Rotation]],
    )
    #v(0.1cm)
    #grid(columns: (1fr, 1fr), gutter: 0.6cm,
      block(fill: light, inset: 0.5cm, radius: 6pt, stroke: 1pt + border-gray, width: 100%)[#text(size: 24pt)[#text(fill: accent)[✔] ±15% Brightness/Contrast]],
      block(fill: light, inset: 0.5cm, radius: 6pt, stroke: 1pt + border-gray, width: 100%)[#text(size: 24pt)[#text(fill: accent)[✔] Min visibility 30%]],
    )
    #v(0.1cm)

  ],
  [
    #section("Technologies")
    #pill("FastAPI + Bootstrap 5", color: teal)
    #text(size: 26pt, weight: "medium")[Full-stack web application for real-time edge deployment:]
    #v(0.4cm)
    #bul[Upload images for single-shot detection]
    #bul[Live webcam inference pipeline]
    #bul[Color-coded class legend with confidence scores]
    #bul[NMS + confidence threshold filtering]
  ]
)
#v(0.1cm)

// ═══════════ ROW 3: GRAPHS ═══════════
#grid(columns: (1fr, 1fr), gutter: 2cm,
  [
    #section("Class Imbalance (Before Augmentation)")
    #block(fill: white, inset: 0.5cm, radius: 8pt, stroke: 1pt + border-gray)[
      #image("assets/graph_1_class_distribution.png", width: 100%)
    ]
    #v(0.3cm)
    #text(size: 22pt, fill: stone, style: "italic")[
      Quartzity (116), Marrow (166), Knot_missing (97) severely underrepresented → balanced to ~420-445 via augmentation.
    ]
  ],
  [
    #section("Training Progress — Loss Curves")
    #block(fill: white, inset: 0.5cm, radius: 8pt, stroke: 1pt + border-gray)[
      #image("assets/graph_2_loss_curves.png", width: 100%)
    ]
    #v(0.1cm)
    #text(size: 22pt, fill: stone, style: "italic")[
      Box, class, and DFL losses converge steadily over 20 epochs. Tesla T4 GPU (0.684 hrs). No overfitting observed.
    ]
  ]
)
#v(0.1cm)

// ═══════════ ROW 4: BOTTOM ═══════════
#grid(columns: (1.5fr, 1.4fr), gutter: 1.5cm,
  [
    #section("Architecture")

    #block(fill: white, inset: 0.4cm, radius: 8pt, stroke: 1pt + border-gray)[
      #image("doc/architecture.png", width: 100%)
    ]
  ],

  [
    #section("Conclusion")
    #v(0.2cm)
    #bul[YOLOv8n achieves *mAP\@50 of 0.639* across 8 defect classes]
    #bul[Class-aware augmentation boosted minority recall *3-4x*]
    #bul[FastAPI web app optimized for low-latency deployment]
    #bul[*Best*: Dead_Knot (0.852) \ *Worst*: Quartzity (0.155)]
    #v(0.6cm)
    #block(fill: light, inset: 0.8cm, radius: 10pt, stroke: 2pt + teal, width: 100%)[
      #text(size: 28pt, fill: teal, weight: "bold")[Key Metrics] \
      #v(0.2cm)
      #text(size: 24pt, fill: navy)[
        • *mAP\@50*: 0.639 \ • *Precision*: 0.665 \ • *Recall*: 0.643 \
        • *Training*: 0.684 hrs (Tesla T4) \ • *Epochs*: 20
      ]
    ]
  ]
)

#v(1.5cm)

// ═══════════ FOOTER ═══════════
#block(fill: navy, inset: (y: 1cm), radius: 12pt, width: 100%)[
  #align(center)[
    #text(fill: white, size: 28pt, weight: "bold", tracking: 2pt)[PRESENTED BY] \
    #v(0.2cm)
    #text(fill: rgb("#f1f5f9"), size: 30pt, weight: "medium")[
      Hania Arshad (2023-CS-13) #text(fill: teal)[•] AbdulRehman Safdar (2023-CS-20)
    ] \
    #v(0.15cm)
    #text(fill: rgb("#cbd5e1"), size: 24pt, style: "italic")[Supervised by Dr. Muhammad Waseem]
  ]
]
