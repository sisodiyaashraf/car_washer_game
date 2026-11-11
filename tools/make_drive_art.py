import os
from PIL import Image, ImageDraw

BASE_DIR = os.path.join(os.path.dirname(__file__), "..", "assets", "images")

def generate_wheels():
    wheels_dir = os.path.join(BASE_DIR, "wheels")
    os.makedirs(wheels_dir, exist_ok=True)
    wheel_names = ["classic", "sport5", "offroad", "star", "monster", "plane"]

    for name in wheel_names:
        img = Image.new("RGBA", (128, 128), (0, 0, 0, 0))
        draw = ImageDraw.Draw(img)
        # Tire
        draw.ellipse((4, 4, 124, 124), fill=(43, 43, 43, 255), outline=(0, 0, 0, 255), width=3)
        # Rim
        draw.ellipse((28, 28, 100, 100), fill=(214, 214, 214, 255), outline=(100, 100, 100, 255), width=2)
        # Hub
        draw.ellipse((52, 52, 76, 76), fill=(100, 100, 100, 255))
        filepath = os.path.join(wheels_dir, f"wheel_{name}.png")
        img.save(filepath, "PNG")
        print(f"Generated wheel: {filepath}")

def generate_fx():
    fx_dir = os.path.join(BASE_DIR, "fx")
    props_dir = os.path.join(BASE_DIR, "props")
    os.makedirs(fx_dir, exist_ok=True)
    os.makedirs(props_dir, exist_ok=True)

    # Dust
    img_dust = Image.new("RGBA", (64, 64), (0, 0, 0, 0))
    d = ImageDraw.Draw(img_dust)
    d.ellipse((8, 8, 56, 56), fill=(210, 180, 140, 180))
    img_dust.save(os.path.join(fx_dir, "fx_dust.png"), "PNG")

    # Speedline
    img_speed = Image.new("RGBA", (128, 32), (0, 0, 0, 0))
    d = ImageDraw.Draw(img_speed)
    d.line((0, 16, 128, 16), fill=(255, 255, 255, 200), width=4)
    img_speed.save(os.path.join(fx_dir, "fx_speedline.png"), "PNG")

    # Headlight beam
    img_beam = Image.new("RGBA", (200, 100), (0, 0, 0, 0))
    d = ImageDraw.Draw(img_beam)
    d.polygon([(0, 50), (200, 0), (200, 100)], fill=(255, 255, 200, 120))
    img_beam.save(os.path.join(fx_dir, "fx_headlight_beam.png"), "PNG")

    # Honk
    img_honk = Image.new("RGBA", (80, 80), (0, 0, 0, 0))
    d = ImageDraw.Draw(img_honk)
    d.arc((10, 10, 70, 70), start=300, end=60, fill=(255, 215, 0, 255), width=6)
    img_honk.save(os.path.join(fx_dir, "fx_honk.png"), "PNG")

    # Garage Door Prop
    img_door = Image.new("RGBA", (200, 400), (0, 0, 0, 0))
    d = ImageDraw.Draw(img_door)
    for y in range(0, 400, 40):
        d.rectangle((0, y, 200, y + 36), fill=(180, 190, 200, 255), outline=(100, 110, 120, 255), width=2)
    img_door.save(os.path.join(props_dir, "prop_garage_door.png"), "PNG")

    print("Generated FX and Props PNG assets.")

if __name__ == "__main__":
    generate_wheels()
    generate_fx()
