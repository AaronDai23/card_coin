#!/usr/bin/env python3
"""
生成OfferVas app的各种尺寸icon
使用方式: python3 generate_icons.py <source_logo_image>
"""

from PIL import Image
import os
import sys

def generate_android_icons(source_image_path):
    """生成Android各dpi等级的launcher icon"""
    
    # Android icon尺寸规范
    android_sizes = {
        'mdpi': 48,
        'hdpi': 72,
        'xhdpi': 96,
        'xxhdpi': 144,
        'xxxhdpi': 192,
    }
    
    # 打开源logo
    img = Image.open(source_image_path).convert('RGBA')
    
    # 生成的flavor列表
    flavors = ['main', 'best_wish', 'card_coin_google', 'card_coin_pro']
    
    for flavor in flavors:
        if flavor == 'main':
            base_path = 'android/app/src/main/res'
        else:
            base_path = f'android/app/src/{flavor}/res'
        
        for dpi, size in android_sizes.items():
            mipmap_dir = os.path.join(base_path, f'mipmap-{dpi}')
            os.makedirs(mipmap_dir, exist_ok=True)
            
            # 调整大小
            resized = img.resize((size, size), Image.Resampling.LANCZOS)
            
            # 保存
            output_path = os.path.join(mipmap_dir, 'ic_launcher.png')
            resized.save(output_path, 'PNG')
            print(f'Generated: {output_path} ({size}x{size})')

def generate_ios_icons(source_image_path):
    """生成iOS AppIcon的各种尺寸"""
    
    # iOS icon尺寸规范 (按大小排序)
    ios_sizes = [
        20, 29, 40, 60,  # iPhone Notification/Settings
        76, 83.5,         # iPad
        120, 152,         # iPhone
        167,              # iPad Pro
        180,              # iPhone 6+
        1024              # App Store
    ]
    
    img = Image.open(source_image_path).convert('RGBA')
    
    app_icon_dir = 'ios/Runner/Assets.xcassets/AppIcon.appiconset'
    os.makedirs(app_icon_dir, exist_ok=True)
    
    for size in ios_sizes:
        size_int = int(size)
        resized = img.resize((size_int, size_int), Image.Resampling.LANCZOS)
        
        # iOS icon命名规范
        filename = f'AppIcon-{size_int}.png'
        output_path = os.path.join(app_icon_dir, filename)
        
        resized.save(output_path, 'PNG')
        print(f'Generated: {output_path} ({size_int}x{size_int})')

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 generate_icons.py <source_logo_image>")
        print("\nExample: python3 generate_icons.py assets/offer_vas_logo.png")
        sys.exit(1)
    
    source_image = sys.argv[1]
    
    if not os.path.exists(source_image):
        print(f"Error: Image file not found: {source_image}")
        sys.exit(1)
    
    print(f"Generating icons from: {source_image}\n")
    
    print("Generating Android icons...")
    generate_android_icons(source_image)
    
    print("\nGenerating iOS icons...")
    generate_ios_icons(source_image)
    
    print("\n✓ Icon generation complete!")

if __name__ == '__main__':
    main()
