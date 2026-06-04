#!/bin/bash
# ============================================================
# CardCoin 私有 CocoaPods Spec 仓库初始化脚本
# 用途：创建并初始化团队私有 Spec 仓库，发布内部 Pod
# 使用：chmod +x setup-private-specs.sh && ./setup-private-specs.sh
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SPEC_REPO_DIR="$SCRIPT_DIR/cardcoin-specs"
SPEC_REPO_NAME="cardcoin-specs"
GITHUB_REPO_URL="https://github.com/AaronDai23/cardcoin-specs.git"

echo "============================================"
echo " CardCoin 私有 CocoaPods Spec 仓库初始化"
echo "============================================"

# ── 1. 创建本地 Spec 仓库（Git） ──
echo ""
echo ">> 步骤 1: 创建本地 Spec 仓库..."

if [ -d "$SPEC_REPO_DIR/.git" ]; then
    echo "   Spec 仓库已存在：$SPEC_REPO_DIR"
else
    mkdir -p "$SPEC_REPO_DIR"
    cd "$SPEC_REPO_DIR"
    git init
    echo "# CardCoin Private CocoaPods Specs" > README.md
    echo "" >> README.md
    echo "团队私有的 CocoaPods Spec 仓库。" >> README.md
    echo "" >> README.md
    echo "## 使用方式" >> README.md
    echo "" >> README.md
    echo '在 Podfile 顶部添加：' >> README.md
    echo '```ruby' >> README.md
    echo "source '<远程 Git 仓库地址>'" >> README.md
    echo "source 'https://cdn.cocoapods.org/'" >> README.md
    echo '```' >> README.md
    git add .
    git commit -m "Initial commit: CardCoin private spec repo"
    echo "   ✅ 本地 Spec 仓库创建成功"
fi

# ── 2. 复制 TangemSdk podspec ──
echo ""
echo ">> 步骤 2: 收集 TangemSdk podspec..."

TANGEM_SDK_DIR="$PROJECT_ROOT/../tangem-sdk-ios"
if [ -f "$TANGEM_SDK_DIR/TangemSdk.podspec" ]; then
    TANGEM_VERSION=$(grep "s.version" "$TANGEM_SDK_DIR/TangemSdk.podspec" | head -1 | sed "s/.*'\(.*\)'.*/\1/")
    mkdir -p "$SPEC_REPO_DIR/TangemSdk/$TANGEM_VERSION"
    cp "$TANGEM_SDK_DIR/TangemSdk.podspec" "$SPEC_REPO_DIR/TangemSdk/$TANGEM_VERSION/"
    echo "   ✅ TangemSdk $TANGEM_VERSION → $SPEC_REPO_DIR/TangemSdk/$TANGEM_VERSION/"
else
    echo "   ⚠️  未找到 TangemSdk.podspec，跳过"
fi

# ── 3. 复制 BitcoinCore.swift podspec ──
echo ""
echo ">> 步骤 3: 收集 BitcoinCore.swift podspec..."

BITCOIN_CORE_DIR="$PROJECT_ROOT/../BitcoinCore.swift"
if [ -f "$BITCOIN_CORE_DIR/BitcoinCore.swift.podspec" ]; then
    BC_VERSION=$(grep "s.version" "$BITCOIN_CORE_DIR/BitcoinCore.swift.podspec" | head -1 | sed "s/.*'\(.*\)'.*/\1/")
    mkdir -p "$SPEC_REPO_DIR/BitcoinCore.swift/$BC_VERSION"
    cp "$BITCOIN_CORE_DIR/BitcoinCore.swift.podspec" "$SPEC_REPO_DIR/BitcoinCore.swift/$BC_VERSION/"
    echo "   ✅ BitcoinCore.swift $BC_VERSION → $SPEC_REPO_DIR/BitcoinCore.swift/$BC_VERSION/"
else
    echo "   ⚠️  未找到 BitcoinCore.swift.podspec，跳过"
fi

# ── 4. 为 Git 依赖创建镜像 podspec ──
echo ""
echo ">> 步骤 4: 创建 Git 依赖的镜像 podspec..."

# BinanceChain
mkdir -p "$SPEC_REPO_DIR/BinanceChain/0.0.9"
cat > "$SPEC_REPO_DIR/BinanceChain/0.0.9/BinanceChain.podspec.json" << 'SPECEOF'
{
  "name": "BinanceChain",
  "version": "0.0.9",
  "summary": "BinanceChain SDK (Tangem fork)",
  "homepage": "https://github.com/tangem/swiftbinancechain",
  "license": "MIT",
  "authors": "tangem",
  "source": {
    "git": "https://github.com/tangem/swiftbinancechain.git",
    "tag": "0.0.9"
  },
  "platforms": { "ios": "13.0" },
  "swift_versions": "5.0",
  "source_files": "BinanceChain/Sources/**/*.swift"
}
SPECEOF
echo "   ✅ BinanceChain 0.0.9"

# HDWalletKit
mkdir -p "$SPEC_REPO_DIR/HDWalletKit/0.3.12"
cat > "$SPEC_REPO_DIR/HDWalletKit/0.3.12/HDWalletKit.podspec.json" << 'SPECEOF'
{
  "name": "HDWalletKit",
  "version": "0.3.12",
  "summary": "HDWalletKit (Tangem fork)",
  "homepage": "https://github.com/tangem/hdwallet",
  "license": "MIT",
  "authors": "tangem",
  "source": {
    "git": "https://github.com/tangem/hdwallet.git",
    "tag": "0.3.12"
  },
  "platforms": { "ios": "13.0" },
  "swift_versions": "5.0",
  "source_files": "HDWalletKit/**/*.swift"
}
SPECEOF
echo "   ✅ HDWalletKit 0.3.12"

# web3swift
mkdir -p "$SPEC_REPO_DIR/web3swift/2.2.12"
cat > "$SPEC_REPO_DIR/web3swift/2.2.12/web3swift.podspec.json" << 'SPECEOF'
{
  "name": "web3swift",
  "version": "2.2.12",
  "summary": "web3swift (Tangem fork)",
  "homepage": "https://github.com/tangem/web3swift",
  "license": "MIT",
  "authors": "tangem",
  "source": {
    "git": "https://github.com/tangem/web3swift.git",
    "tag": "2.2.12"
  },
  "platforms": { "ios": "13.0" },
  "swift_versions": "5.0",
  "source_files": "Sources/web3swift/**/*.swift"
}
SPECEOF
echo "   ✅ web3swift 2.2.12"

# Solana.Swift (规范化版本号)
mkdir -p "$SPEC_REPO_DIR/Solana.Swift/1.0.0-signer.7"
cat > "$SPEC_REPO_DIR/Solana.Swift/1.0.0-signer.7/Solana.Swift.podspec.json" << 'SPECEOF'
{
  "name": "Solana.Swift",
  "version": "1.0.0-signer.7",
  "summary": "Solana.Swift (Tangem fork with external signer)",
  "homepage": "https://github.com/tangem/Solana.Swift",
  "license": "MIT",
  "authors": "tangem",
  "source": {
    "git": "https://github.com/tangem/Solana.Swift.git",
    "tag": "add-external-signer-7"
  },
  "platforms": { "ios": "13.0" },
  "swift_versions": "5.0",
  "source_files": "Sources/**/*.swift"
}
SPECEOF
echo "   ✅ Solana.Swift 1.0.0-signer.7"

# ── 5. Git commit ──
echo ""
echo ">> 步骤 5: 提交 Spec 仓库..."
cd "$SPEC_REPO_DIR"
git add .
git commit -m "Add TangemSdk, BitcoinCore.swift, BinanceChain, HDWalletKit, web3swift, Solana.Swift specs" || echo "   (无新变更)"

# ── 6. 注册到 CocoaPods ──
echo ""
echo ">> 步骤 6: 注册私有 Spec 仓库到本地 CocoaPods..."

# 先移除旧的（如果存在）
pod repo remove "$SPEC_REPO_NAME" 2>/dev/null || true

# 注册本地路径（开发用；生产环境替换为远程 Git URL）
pod repo add "$SPEC_REPO_NAME" "$GITHUB_REPO_URL"
echo "   ✅ 已注册：$SPEC_REPO_NAME → $GITHUB_REPO_URL"

echo ""
echo "============================================"
echo " 🎉 私有 CocoaPods Spec 仓库初始化完成！"
echo "============================================"
echo ""
echo "  本地 Spec 仓库: $SPEC_REPO_DIR"
echo "  CocoaPods 注册名: $SPEC_REPO_NAME"
echo ""
echo "  已收录的 Spec："
echo "    - TangemSdk"
echo "    - BitcoinCore.swift"
echo "    - BinanceChain 0.0.9"
echo "    - HDWalletKit 0.3.12"
echo "    - web3swift 2.2.12"
echo "    - Solana.Swift 1.0.0-signer.7"
echo ""
echo "  下一步操作："
echo "    1. 团队成员添加私有 Spec 仓库："
echo "       pod repo add $SPEC_REPO_NAME $GITHUB_REPO_URL"
echo ""
echo "    2. 修改 Podfile（参考 Podfile.private-specs）"
echo "============================================"
