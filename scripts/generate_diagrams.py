import os
import graphviz

OUTPUT_DIR = r'C:\Users\hp\Desktop\Ab\practice\Computer-Vision-Project\assets'
os.makedirs(OUTPUT_DIR, exist_ok=True)

# ─── WINDOWS FIX ───
# If you have installed Graphviz on your PC, paste the path to its 'bin' folder here.
# This prevents the "ExecutableNotFound" crash without needing to restart your system.
GRAPHVIZ_BIN_PATH = r'C:\Program Files\Graphviz\bin' 
if os.path.exists(GRAPHVIZ_BIN_PATH):
    os.environ["PATH"] += os.pathsep + GRAPHVIZ_BIN_PATH


def make_html_label(content):
    """Wrap content as HTML-like label for Graphviz."""
    return '<' + content + '>'


# ─── DATASET VIEW DIAGRAM ───
d = graphviz.Digraph(
    name='dataset_view',
    format='pdf',
    engine='dot',
)
d.attr(
    rankdir='LR',
    bgcolor='#ffffff',
    fontname='Segoe UI, Arial, sans-serif',
    fontsize='11',
    splines='ortho',
    nodesep='0.18',
    ranksep='0.9',
    size='16,10',
)

d.attr('node', shape='plaintext', fontname='Segoe UI, Arial, sans-serif')
d.attr('edge', color='#7f8c8d', penwidth='1.5')

# ── Main Dataset Node (Root) ──
root_label = r'''
<TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0" CELLPADDING="14" BGCOLOR="#1a1a2e" COLOR="#1a1a2e">
<TR><TD><FONT POINT-SIZE="16" COLOR="#ffffff"><B>Wood Surface Defects</B></FONT><BR/><FONT POINT-SIZE="9" COLOR="#94a3b8">Dataset Root</FONT></TD></TR>
</TABLE>'''
d.node('root', make_html_label(root_label.strip()))

# Sub-node with stats
root_stats = r'''
<TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0" CELLPADDING="10" COLOR="#2c3e50">
<TR>
    <TD BGCOLOR="#f8f9fa"><FONT POINT-SIZE="10" COLOR="#34495e"><B>Total Images</B></FONT></TD>
    <TD BGCOLOR="#f8f9fa"><FONT POINT-SIZE="10" COLOR="#34495e"><B>Classes</B></FONT></TD>
    <TD BGCOLOR="#f8f9fa"><FONT POINT-SIZE="10" COLOR="#34495e"><B>Annotations</B></FONT></TD>
</TR>
<TR>
    <TD BGCOLOR="#ffffff"><FONT POINT-SIZE="13" COLOR="#1a1a2e"><B>4,000</B></FONT></TD>
    <TD BGCOLOR="#ffffff"><FONT POINT-SIZE="13" COLOR="#1a1a2e"><B>8</B></FONT></TD>
    <TD BGCOLOR="#ffffff"><FONT POINT-SIZE="13" COLOR="#1a1a2e"><B>9,211</B></FONT></TD>
</TR>
</TABLE>'''
d.node('root_stats', make_html_label(root_stats.strip()))

# Connect root directly to stats
d.edge('root', 'root_stats', arrowhead='none', penwidth='2', color='#1a1a2e')

# Invisible single hub point to branch out cleanly
d.node('hub', '', shape='point', width='0.01', height='0.01')
d.edge('root_stats', 'hub', arrowhead='none', penwidth='2', color='#2c3e50')

# ── Class Card Definitions ──
classes = [
    ('Quartzity',        '#e8f0fe', '116',  '445',  '+329', 'Qtz', 'Mineral deposits\nin wood grain', True),
    ('Live_Knot',        '#fce4ec', '3242', '3969', '+727', 'LK',  'Living branch\nembedded in wood', False),
    ('Marrow',          '#e8f5e9', '166',  '455',  '+289', 'Mar', 'Soft central\ncore of wood', True),
    ('Resin',           '#fff3e0', '541',  '682',  '+141', 'Res', 'Resin pocket\nor gum spot', False),
    ('Dead_Knot',       '#f3e5f5', '2372', '2854', '+482', 'DK',  'Dead branch\nhole in wood', False),
    ('Knot_with_crack', '#f1f8e9', '412',  '448',  '+36',  'K+C', 'Knot with\nradial crack', False),
    ('Knot_missing',    '#fff8e1', '97',   '420',  '+323', 'K-M', 'Knot that has\nfallen out', True),
    ('Crack',           '#e0f2f1', '410',  '574',  '+164', 'Crk', 'Split or crack\nin wood', False),
]

for name, color, before, after, gain, short, desc, is_min in classes:
    cid = name.replace('_', '').replace('-', '')
    badge_color = '#e74c3c' if is_min else '#2ecc71'
    badge_text = 'MINORITY' if is_min else 'MAJORITY'

    card = f'''
<TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0" CELLPADDING="5" COLOR="#bdc3c7">
<TR><TD COLSPAN="2" BGCOLOR="{color}" HEIGHT="30"><FONT POINT-SIZE="13" COLOR="#2c3e50"><B>{short}</B></FONT></TD></TR>
<TR><TD COLSPAN="2" BGCOLOR="#ffffff"><FONT POINT-SIZE="11" COLOR="#1a1a2e"><B>{name}</B></FONT><BR/><FONT POINT-SIZE="8.5" COLOR="#7f8c8d">{desc}</FONT></TD></TR>
<TR>
    <TD BGCOLOR="#fafafa"><FONT POINT-SIZE="9" COLOR="#95a5a6">Before</FONT></TD>
    <TD BGCOLOR="#fafafa"><FONT POINT-SIZE="9" COLOR="#95a5a6">After</FONT></TD>
</TR>
<TR>
    <TD BGCOLOR="#ffffff"><FONT POINT-SIZE="12" COLOR="#34495e"><B>{before}</B></FONT></TD>
    <TD BGCOLOR="#ffffff"><FONT POINT-SIZE="12" COLOR="#c0392b"><B>{after}</B></FONT></TD>
</TR>
<TR><TD COLSPAN="2" BGCOLOR="#ffffff"><FONT POINT-SIZE="10" COLOR="#27ae60"><B>Gain: {gain}</B></FONT></TD></TR>
<TR><TD COLSPAN="2" BGCOLOR="{badge_color}"><FONT POINT-SIZE="8" COLOR="#ffffff"><B>{badge_text}</B></FONT></TD></TR>
</TABLE>'''
    
    d.node(cid, make_html_label(card.strip()))
    d.edge('hub', cid, arrowhead='normal', arrowsize='0.7', color='#7f8c8d')

# ── Structured Legend at Bottom ──
legend_info = r'''
<TABLE BORDER="0" CELLBORDER="0" CELLSPACING="0" CELLPADDING="8">
<TR><TD><FONT POINT-SIZE="10" COLOR="#555555"><I>Note: Minority classes (Quartzity, Marrow, Knot_missing) augmented via class-aware oversampling to match median (~412/class). Training set: 3,200 before to 3,981 after augmentation (+781 images).</I></FONT></TD></TR>
</TABLE>'''
d.node('legend', make_html_label(legend_info.strip()))

# Clean alignment of the footnote below the stack
d.edge('Crack', 'legend', style='invis', weight='5')

try:
    d.render(os.path.join(OUTPUT_DIR, 'dataset_view'), cleanup=True)
    print(f'[OK] dataset_view.pdf saved to {OUTPUT_DIR}')
except graphviz.backend.execute.ExecutableNotFound:
    print("\n[!] Execution Failed: 'dot' binary still not found.")
    print("If you haven't installed the system engine yet, run: winget install Graphviz")
    print("Then restart your PowerShell window and try again.")