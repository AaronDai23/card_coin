#!/usr/bin/env python3
"""
完整的 icon 生成脚本
使用方式: python3 generate_all_icons.py <source_logo_image>
"""

from PIL import Image
import os
import sys

def ensure_dir(path):
    """创建目录"""
    os.makedirs(path, exist_ok=True)

def generate_android_icons(source_image_path):
    """生成 Android 各 dpi 等级的 launcher icon"""
    
    android_sizes = {
        'mdpi': 48,
        'hdpi': 72,
        'xhdpi': 96,
        'xxhdpi': 144,
        'xxxhdpi': 192,
    }
    
    img = Image.open(source_image_path).convert('RGBA')
    
    flavors = ['main', 'best_wish', 'card_coin_google', 'card_coin_pro']
    
    for flavor in flavors:
        if flavor == 'main':
            base_path = 'android/app/src/main/res'
        else:
            base_path = f'android/app/src/{flavor}/res'
        
        for dpi, size in android_sizes.items():
            mipmap_dir = os.path.join(base_path, f'mipmap-{dpi}')
            ensure_dir(mipmap_dir)
            
            resized = img.resize((size, size), Image.Resampling.LANCZOS)
            output_path = os.path.join(mipmap_dir, 'ic_launcher.png')
            resized.save(output_path, 'PNG')
            print(f'✓ {output_path} ({size}x{size})')

def generate_ios_icons(source_image_path):
    """生成 iOS AppIcon 的各种尺寸"""
    
    ios_sizes = [
        (20, '20'),
        (29, '29'),
        (40, '40'),
        (60, '60'),
        (76, '76'),
        (83.5, '835'),
        (120, '120'),
        (152, '152'),
        (167, '167'),
        (180, '180'),
        (1024, '1024'),
    ]
    
    img = Image.open(source_image_path).convert('RGBA')
    
    app_icon_dir = 'ios/Runner/Assets.xcassets/AppIcon.appiconset'
    ensure_dir(app_icon_dir)
    
    for size, name in ios_sizes:
        size_int = int(size)
        resized = img.resize((size_int, size_int), Image.Resampling.LANCZOS)
        
        filename = f'AppIcon-{name}.png'
        output_path = os.path.join(app_icon_dir, filename)
        
        resized.save(output_path, 'PNG')
        print(f'✓ {output_path} ({size_int}x{size_int})')

def main():
    if len(sys.argv) < 2:
        print("用法: python3 generate_all_icons.py <source_logo_image>")
        print("\n示例: python3 generate_all_icons.py assets/offer_vas_logo.png")
        sys.exit(1)
    
    source_image = sys.argv[1]
    
    if not os.path.exists(source_image):
        print(f"❌ 错误: 找不到图片文件: {source_image}")
        sys.exit(1)
    
    print(f"从以下文件生成 icon: {source_image}\n")
    
    try:
        img = Image.open(source_image)
        print(f"源图片大小: {img.size}, 色彩模式: {img.mode}\n")
        
        print("生成 Android icon...\n")
        generate_android_icons(source_image)
        
        print("\n生成 iOS icon...\n")
        generate_ios_icons(source_image)
        
        print("\n✅ Icon 生成完成！")
        
    except Exception as e:
        print(f"❌ 错误: {e}")
        sys.exit(1)

if __name__ == '__main__':
    main()
