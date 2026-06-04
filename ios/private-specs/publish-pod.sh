#!/bin/bash
# ============================================================
# 发布新版本 Pod 到私有 Spec 仓库
# 用途：将 podspec 推送到私有 Spec 仓库
# 使用：./publish-pod.sh <podspec路径> [版本号]
# 示例：./publish-pod.sh ../../tangem-sdk-ios/TangemSdk.podspec 3.9.0
# ============================================================

set -e

SPEC_REPO_NAME="cardcoin-specs"
PODSPEC_PATH="$1"
VERSION_OVERRIDE="$2"

if [ -z "$PODSPEC_PATH" ]; then
    echo "用法: $0 <podspec路径> [版本号]"
    echo ""
    echo "示例:"
    echo "  $0 ../../tangem-sdk-ios/TangemSdk.podspec"
    echo "  $0 ../../tangem-sdk-ios/TangemSdk.podspec 3.9.0"
    exit 1
fi

if [ ! -f "$PODSPEC_PATH" ]; then
    echo "❌ 未找到 podspec: $PODSPEC_PATH"
    exit 1
fi

# 检查私有 Spec 仓库是否已注册
if ! pod repo list | grep -q "$SPEC_REPO_NAME"; then
    echo "❌ 私有 Spec 仓库未注册，请先运行 setup-private-specs.sh"
    exit 1
fi

echo ">> 推送 podspec 到 $SPEC_REPO_NAME ..."

# --allow-warnings: 忽略 podspec 中的警告
# --skip-import-validation: 跳过编译验证（加速发布）
pod repo push "$SPEC_REPO_NAME" "$PODSPEC_PATH" \
    --allow-warnings \
    --skip-import-validation \
    --skip-tests \
    --verbose

echo ""
echo "✅ 发布成功！"
echo "   团队成员执行 pod repo update $SPEC_REPO_NAME 即可获取最新版本"
