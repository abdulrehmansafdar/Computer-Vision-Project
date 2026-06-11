#set page(
  paper: "a0", 
  margin: (x: 3cm, top: 3cm, bottom: 2.5cm)
)

#set text(
  font: ("Liberation Sans", "Arial"), 
  size: 26pt, 
  fill: rgb("#1e293b")
)

// ═══════════ COLOR PALETTE ═══════════
#let navy = rgb("#0f172a")     // Deep Slate Navy
#let accent = rgb("#2563eb")   // Primary Blue
#let teal = rgb("#0d9488")     // Emerald Teal
#let stone = rgb("#64748b")    // Cool Muted Gray
#let white = rgb("#ffffff")    // White
#let light = rgb("#f8fafc")    // Premium Soft Background
#let border-gray = rgb("#cbd5e1")

// ═══════════ REUSABLE COMPONENTS ═══════════
#let section(title) = {
  v(1cm)
  block(
    fill: navy, 
    inset: (x: 1.5cm, y: 0.8cm), 
    radius: 8pt, 
    width: 100%
  )[
    #text(fill: white, weight: "bold", size: 36pt, title)
  ]
  v(0.5cm)
}

#let pill(title, color: accent) = {
  block(
    fill: color, 
    inset: (x: 0.8cm, y: 0.3cm), 
    radius: 50pt,
    outset: 0pt
  )[
    #text(fill: white, weight: "bold", size: 22pt, title)
  ]
  v(0.3cm)
}

#let bul(t) = {
  block(above: 0.25cm, below: 0.25cm)[
    #grid(
      columns: (auto, 1fr), 
      gutter: 0.5cm,
      text(fill: accent, weight: "bold", size: 24pt)[•],
      text(size: 22pt, t)
    )
  ]
}

// ═══════════ HEADER ═══════════
#block(
  fill: navy, 
  inset: (x: 3cm, y: 1.5cm), 
  radius: 16pt,
  width: 100%
)[
  #grid(
    columns: (auto, 1fr, auto), 
    align: (horizon + center, horizon + center, horizon + center), // Fixed here
    gutter: 2cm,
    [#image("../doc/uet-logo.png", height: 4.5cm)],
    align(center)[
      #text(fill: white, weight: "bold", size: 68pt)[Wood Surface Defect Detection] \
      #v(0.3cm)
      #text(fill: rgb("#38bdf8"), size: 32pt, weight: "bold")[Using YOLOv8n with Class-Aware Augmentation] \
      #v(0.2cm)
      #text(fill: rgb("#94a3b8"), size: 22pt, weight: "medium")[Computer Vision Project — University of Engineering & Technology, Lahore]
    ],
    [#image("../doc/cs-dep-logo.png", height: 4.5cm)],
  )
]

#v(1cm)

// ═══════════ ROW 1: PROBLEM DEFINITION ═══════════
#section("Problem Definition")
#block(
  fill: light, 
  inset: 1.5cm, 
  radius: 12pt, 
  stroke: 1.5pt + border-gray,
  width: 100%
)[
  #set par(leading: 1.4em)
  #text(size: 26pt, weight: "medium")[
    Wood surface defects — *quartzity, knots, cracks, resin pockets, and marrow* — significantly degrade timber product quality. Manual inspection is subjective, slow, and error-prone. This project delivers an automated, real-time detection system using a fine-tuned *YOLOv8n* deep learning model, enabling consistent quality control on production lines.
  ]
]

#v(0.5cm)

// ═══════════ ROW 2: AUGMENTATION & TECHNOLOGIES ═══════════
#grid(
  columns: (1fr, 1fr), 
  gutter: 2cm,
  [
    #section("Augmentation Strategy")
    #pill("Class-Aware Oversampling", color: accent)
    #text(size: 22pt, weight: "medium")[Minority classes augmented to match median (~412/class):]
    #v(0.4cm)
    
    #grid(
      columns: (1fr, 1fr), 
      gutter: 0.6cm,
      block(fill: light, inset: 0.5cm, radius: 6pt, stroke: 1pt + border-gray, width: 100%)[#text(size: 20pt)[#text(fill: accent)[✔] H-Flip / V-Flip]],
      block(fill: light, inset: 0.5cm, radius: 6pt, stroke: 1pt + border-gray, width: 100%)[#text(size: 20pt)[#text(fill: accent)[✔] ±10° Rotation]],
    )
    #v(0.1cm)
    #grid(
      columns: (1fr, 1fr), 
      gutter: 0.6cm,
      block(fill: light, inset: 0.5cm, radius: 6pt, stroke: 1pt + border-gray, width: 100%)[#text(size: 20pt)[#text(fill: accent)[✔] ±15% Brightness/Contrast]],
      block(fill: light, inset: 0.5cm, radius: 6pt, stroke: 1pt + border-gray, width: 100%)[#text(size: 20pt)[#text(fill: accent)[✔] Min visibility 30%]],
    )
    
    #v(0.5cm)
    #block(fill: teal.lighten(90%), inset: 0.6cm, radius: 8pt, width: 100%)[
      #text(size: 24pt, fill: teal, weight: "bold")[+781 augmented images (total: 3,981)] \
      #v(0.1cm)
      #text(size: 18pt, fill: stone)[Minority: ~100-200 → ~420-445 annotations each]
    ]
  ],
  [
    #section("Technologies")
    #pill("FastAPI + Bootstrap 5", color: teal)
    #text(size: 22pt, weight: "medium")[Full-stack web application developed for real-time edge deployment:]
    #v(0.4cm)
    #bul[Upload images for single-shot lightning fast detection]
    #bul[Live high-frame webcam inference pipeline]
    #bul[Dynamic color-coded class bounding legends with confidence scores]
    #bul[Configurable NMS + confidence threshold filtering]
  ]
)

#v(0.5cm)

// ═══════════ ROW 3: GRAPHS ═══════════
#grid(
  columns: (1fr, 1fr), 
  gutter: 2cm,
  [
    #section("Class Imbalance (Before Augmentation)")
    #block(fill: white, inset: 0.5cm, radius: 8pt, stroke: 1pt + border-gray)[
      #image("../assets/graph_1_class_distribution.png", width: 100%)
    ]
    #v(0.3cm)
    #text(size: 18pt, fill: stone, style: "italic")[
      Quartzity (116), Marrow (166), Knot_missing (97) severely underrepresented → optimally balanced to ~420-445 annotations via augmentation strategy.
    ]
  ],
  [
    #section("Training Progress — Loss Curves")
    #block(fill: white, inset: 0.5cm, radius: 8pt, stroke: 1pt + border-gray)[
      #image("../assets/graph_2_loss_curves.png", width: 100%)
    ]
    #v(0.3cm)
    #text(size: 18pt, fill: stone, style: "italic")[
      Box, class, and DFL losses converge steadily over 20 epochs. Model evaluation done on Nvidia Tesla T4 GPU (0.684 hrs) showing no signs of overfitting.
    ]
  ]
)

#v(0.5cm)

// ═══════════ ROW 4: ARCHITECTURE, RESULTS & CONCLUSION ═══════════
#grid(
  columns: (1fr, 1.3fr, 1fr), 
  gutter: 1.5cm,
  [
    #section("Architecture")
    #pill("Project Flow (End-to-End)", color: accent)
    #v(0.2cm)
    #block(fill: white, inset: 0.4cm, radius: 8pt, stroke: 1pt + border-gray)[
      #image("../assets/architecture_diagram.png", width: 100%)
    ]
  ],
  [
    #section("Results")
    #grid(
      columns: (1fr, 1fr, 1fr), 
      gutter: 0.4cm,
      block(fill: accent.lighten(92%), inset: 0.4cm, radius: 8pt, stroke: 1.5pt + accent.lighten(50%), align(center)[
        #text(size: 32pt, weight: "bold", fill: accent)[0.639] \
        #text(size: 16pt, fill: stone, weight: "bold")[mAP\@50]
      ]),
      block(fill: accent.lighten(92%), inset: 0.4cm, radius: 8pt, stroke: 1.5pt + accent.lighten(50%), align(center)[
        #text(size: 32pt, weight: "bold", fill: accent)[0.665] \
        #text(size: 16pt, fill: stone, weight: "bold")[Precision]
      ]),
      block(fill: accent.lighten(92%), inset: 0.4cm, radius: 8pt, stroke: 1.5pt + accent.lighten(50%), align(center)[
        #text(size: 32pt, weight: "bold", fill: accent)[0.643] \
        #text(size: 16pt, fill: stone, weight: "bold")[Recall]
      ]),
    )
    #v(0.5cm)
    #table(
      columns: (1.4fr, 1fr, 1fr, 1fr),
      inset: 11pt,
      stroke: 0.5pt + border-gray,
      fill: (x, y) => if y == 0 { navy } else if calc.even(y) { light } else { white },
      align: (left + horizon, center + horizon, center + horizon, center + horizon),
      [#text(fill: white, weight: "bold", size: 18pt)[Class]],
      [#text(fill: white, weight: "bold", size: 18pt)[Precision]],
      [#text(fill: white, weight: "bold", size: 18pt)[Recall]],
      [#text(fill: white, weight: "bold", size: 18pt)[mAP\@50]],
      [Quartzity], [0.345], [0.167], [0.155],
      [Live_Knot], [0.759], [0.742], [0.752],
      [Marrow], [0.631], [0.833], [0.668],
      [Resin], [0.824], [0.738], [0.800],
      [Dead_Knot], [0.872], [0.768], [0.852],
      [Knot+Cr], [0.620], [0.503], [0.483],
      [Knot_Miss], [0.688], [0.667], [0.720],
      [Crack], [0.584], [0.730], [0.680],
    )
  ],
  [
    #section("Conclusion")
    #v(0.2cm)
    #bul[YOLOv8n achieves a robust *mAP\@50 of 0.639* across 8 structural classes.]
    #bul[Class-aware augmentation drastically boosted minority recall by *3-4x*.]
    #bul[FastAPI web app optimized for low-latency web production usage.]
    #bul[*Best Class*: Dead_Knot (0.852) \ *Worst Class*: Quartzity (0.155)]
    
    #v(0.6cm)
    #block(
      fill: light, 
      inset: 0.8cm, 
      radius: 10pt, 
      stroke: 2pt + teal,
      width: 100%
    )[
      #text(size: 24pt, fill: teal, weight: "bold")[Key Metrics Summary] \
      #v(0.2cm)
      #text(size: 19pt, fill: navy)[
        • *mAP\@50*: 0.639 | *Precision*: 0.665 \
        • *Recall*: 0.643 \
        • *Training Time*: 0.684 Hours on Tesla T4 \
        • *Epochs*: 20 Epochs total
      ]
    ]
  ]
)

#v(1.5cm)

// ═══════════ FOOTER ═══════════
#block(
  fill: navy, 
  inset: (y: 1cm), 
  radius: 12pt,
  width: 100%
)[
  #align(center)[
    #text(fill: white, size: 24pt, weight: "bold", tracking: 2pt)[PRESENTED BY] \
    #v(0.2cm)
    #text(fill: rgb("#f1f5f9"), size: 26pt, weight: "medium")[
      Hania Arshad (2023-CS-13) #text(fill: teal)[•] AbdulRehman Safdar (2023-CS-20)
    ] \
    #v(0.15cm)
    #text(fill: rgb("#cbd5e1"), size: 20pt, style: "italic")[Supervised by Dr. Muhammad Waseem]
  ]
]