import os
from PIL import Image, ImageDraw

TOOLS_DIR = os.path.join(os.path.dirname(__file__), "..", "assets", "images", "tools")

def generate_wheel_brush_icon():
    os.makedirs(TOOLS_DIR, exist_ok=True)
    size = (512, 512)
    img = Image.new("RGBA", size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    stroke_width = 16
    dark_outline = (43, 58, 66, 255)  # Dark charcoal/navy outline
    handle_color = (212, 140, 69, 255)  # Brown handle
    block_color = (13, 148, 236, 255)  # Blue block
    bristle_color = (255, 214, 53, 255)  # Yellow bristles

    # Yellow Bristles (6 angled bristle bars extending from blue block)
    bristle_starts = [
        (250, 390), (275, 405), (300, 420), (325, 435), (350, 450), (375, 465)
    ]
    for start_x, start_y in bristle_starts:
        end_x = start_x - 35
        end_y = start_y + 45
        draw.line([(start_x, start_y), (end_x, end_y)], fill=dark_outline, width=22 + stroke_width)
        draw.line([(start_x, start_y), (end_x, end_y)], fill=bristle_color, width=22)

    # Handle
    draw.line([(170, 100), (290, 310)], fill=dark_outline, width=54 + stroke_width)
    draw.line([(170, 100), (290, 310)], fill=handle_color, width=54)

    # Blue Brush Block
    draw.rounded_rectangle((220, 270, 410, 370), radius=30, fill=dark_outline)
    draw.rounded_rectangle((230, 280, 400, 360), radius=22, fill=block_color)

    filepath = os.path.join(TOOLS_DIR, "tool_wheel_brush.png")
    img.save(filepath, "PNG")
    print(f"Updated Wheel Brush Icon: {filepath}")

if __name__ == "__main__":
    generate_wheel_brush_icon()
