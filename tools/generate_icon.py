import os
from PIL import Image, ImageDraw

OUTPUT_DIR = os.path.join(os.path.dirname(__file__), "..", "assets", "icon")

def generate_app_icon():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    img = Image.new("RGBA", (512, 512), (0, 180, 216, 255)) # Cyan/Blue background
    draw = ImageDraw.Draw(img)

    # Draw Yellow Outer Ring
    draw.ellipse((36, 36, 476, 476), outline=(255, 183, 3, 255), width=16)

    # Draw Simple Car Silhouette
    # Body
    draw.rounded_rectangle((100, 250, 412, 360), radius=30, fill=(255, 255, 255, 255))
    # Roof
    draw.rounded_rectangle((160, 180, 340, 260), radius=20, fill=(255, 255, 255, 255))
    # Wheels
    draw.ellipse((140, 320, 220, 400), fill=(43, 43, 43, 255))
    draw.ellipse((165, 345, 195, 375), fill=(214, 214, 214, 255))
    draw.ellipse((292, 320, 372, 400), fill=(43, 43, 43, 255))
    draw.ellipse((317, 345, 347, 375), fill=(214, 214, 214, 255))

    # Soap Bubbles
    draw.ellipse((120, 140, 170, 190), outline=(255, 255, 255, 220), width=6)
    draw.ellipse((330, 130, 390, 190), outline=(255, 255, 255, 220), width=6)
    draw.ellipse((220, 100, 290, 170), outline=(255, 255, 255, 220), width=6)

    filepath = os.path.join(OUTPUT_DIR, "app_icon.png")
    img.save(filepath, "PNG")
    print(f"Generated App Icon: {filepath}")

    # Splash Icon
    splash_path = os.path.join(OUTPUT_DIR, "splash.png")
    img.save(splash_path, "PNG")
    print(f"Generated Splash Icon: {splash_path}")

if __name__ == "__main__":
    generate_app_icon()
