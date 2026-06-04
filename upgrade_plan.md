# Card Coin 项目 Dart & Gradle 升级改造方案

> 生成日期：2026-04-07  
> 当前项目版本：v2.1.6 (build 241)

---

## 一、当前技术栈现状

| 维度 | 当前版本 | 最新稳定版 | 差距 |
|------|----------|-----------|------|
| **Flutter SDK** | 3.19.0 (user-branch) | 3.29.x | 落后 ~10 个大版本 |
| **Dart SDK** | 3.3.0 | 3.7.x | 落后 4 个大版本 |
| **Gradle** | 7.5 | 8.12+ | 落后 1 个大版本 |
| **Android Gradle Plugin (AGP)** | 7.4.2 | 8.7+ | 落后 1 个大版本 |
| **Kotlin** | 1.7.21 | 2.1.x | 落后 1 个大版本 |
| **compileSdkVersion** | 35 | 35 | ✅ 已是最新 |
| **targetSdkVersion** | 35 | 35 | ✅ 已是最新 |
| **minSdkVersion** | 24 | 24 | 可接受 |
| **iOS Deployment Target** | 15.0 | 15.0+ | ✅ 合理 |

### 关键矛盾

`pubspec.yaml` 中声明 `sdk: '>=2.19.2 <3.0.0'`，但实际使用 Dart 3.3.0 运行。这是一个**配置与实际环境不一致**的隐患，必须首先修正。

---

## 二、升级路径总览

建议分 **4 个阶段** 渐进升级，每阶段完成后做完整回归测试：

```
阶段1：基础修正与依赖清理（低风险）
    ↓
阶段2：Dart/Flutter SDK 升级（中风险）
    ↓
阶段3：Android Gradle 生态升级（中高风险）
    ↓
阶段4：iOS 生态与 Swift 升级（中风险）
```

---

## 三、阶段1：基础修正与依赖清理

**预估工期：2-3 天**  
**风险等级：低**

### 1.1 修正 pubspec.yaml SDK 约束

```yaml
# 修改前
environment:
  sdk: '>=2.19.2 <3.0.0'

# 修改后（匹配当前 Flutter 3.19.0 / Dart 3.3.0）
environment:
  sdk: '>=3.3.0 <4.0.0'
```

### 1.2 替换已废弃的 analysis_options

```yaml
# 修改前
include: package:flutter_lints/flutter.yaml

# 修改后
include: package:flutter_lints/flutter.yaml
# 最终目标（阶段2后）：
# include: package:lints/recommended.yaml
```

> `flutter_lints` 已被 `lints` 或 `flutter_lints` 3.x 替代。

### 1.3 锁定模糊版本依赖

| 依赖 | 当前 | 建议 |
|------|------|------|
| `logger: any` | 接受任意版本 | `logger: ^2.0.0` |
| `decimal:` (无版本) | 接受任意版本 | `decimal: ^2.3.0` |
| `bugly:crashreport:latest.release` (Android) | 动态版本 | 锁定为具体版本如 `4.1.9.3` |

### 1.4 移除 dependency_overrides

```yaml
# 当前
dependency_overrides:
  watcher: ^1.1.0

# 应调查为何需要 override，解决根因后移除
```

### 1.5 清理注释/无用代码

- `pubspec.yaml` 中大量注释掉的依赖需要彻底清理
- `main.dart` 中残留的 Bugly 注释代码
- `android/build.gradle` 中注释掉的 Maven 仓库配置

---

## 四、阶段2：Dart/Flutter SDK 升级

**预估工期：5-8 天**  
**风险等级：中**

### 2.1 升级路径

```
Flutter 3.19.0 (Dart 3.3.0)
    → Flutter 3.22.x (Dart 3.4.x)     # 中间过渡版
    → Flutter 3.27.x (Dart 3.6.x)     # 目标版本
```

> 不建议一步跳到 3.29.x，建议先到 3.27 LTS 稳定后再决定是否继续。

### 2.2 Dart 3.x 语法适配清单

| 变更项 | 影响范围 | 说明 |
|--------|----------|------|
| **Null Safety 健全模式** | 全项目 | 确保所有代码和依赖完全支持 sound null safety |
| **Sealed class** | `analysis_options.yaml` 中已注释实验特性 | Dart 3.0+ 已稳定,可启用 `sealed` 关键字 |
| **Records & Patterns** | 新代码可选用 | Dart 3.0+ 支持,旧代码无需改 |
| **Class modifiers** | bean/ 目录下数据类 | `interface`, `base`, `final`, `mixin` 修饰 |
| **Switch expressions** | 可选优化 | 简化现有 switch-case |

### 2.3 高风险依赖升级

#### fish_redux（状态管理框架）— **P0 最高优先级**

| 项目 | 详情 |
|------|------|
| 当前来源 | `git: https://gitee.com/yu_yong_yao/fish-redux.git` |
| 问题 | 上游已停止维护，个人 fork，不支持 Dart 3.x 新特性 |
| 影响面 | 全局状态管理、所有页面（pages/、card_base/pages/） |

**迁移方案（三选一）：**

| 方案 | 迁移成本 | 推荐度 | 说明 |
|------|----------|--------|------|
| A. fork 修复兼容 | 低（1-2天） | ⭐⭐ | 仅修复编译错误，不解决根本问题 |
| B. 迁移到 Riverpod | 高（15-20天） | ⭐⭐⭐⭐ | 社区活跃，类型安全，长期维护 |
| C. 迁移到 Bloc | 高（15-20天） | ⭐⭐⭐⭐⭐ | 企业级首选，文档完善，生态成熟 |

**建议：短期用方案 A 过渡，中长期规划迁移到 Bloc。**

#### 其他 Git 依赖

| 依赖 | 当前来源 | 升级方案 |
|------|----------|---------|
| `modal_bottom_sheet` | Gitee fork | 迁移到官方 pub.dev `modal_bottom_sheet: ^3.0.0` |
| `update_app` | Gitee fork | 评估是否改用 `upgrader` 或 `in_app_update` |
| `flutter_html: ^3.0.0-alpha.6` | Alpha 版本 | 升级到稳定版 `flutter_html: ^3.0.0` |

### 2.4 关键 Flutter 插件升级矩阵

| 插件 | 当前版本 | 目标版本 | 破坏性变更 |
|------|----------|----------|-----------|
| `dio` | ^5.0.0 | ^5.4.0 | 无，向后兼容 |
| `shared_preferences` | ^2.0.15 | ^2.3.0 | 无 |
| `webview_flutter` | ^3.0.4 | ^4.8.0 | ⚠️ API 变更较大，需改造 |
| `pigeon` | ^12.0.0 | ^22.0.0 | ⚠️ 生成代码格式变更，需重新生成 |
| `permission_handler` | ^10.0.0 | ^11.3.0 | 小幅 API 变更 |
| `image_picker` | ^0.8.5+3 | ^1.1.0 | ⚠️ API 重构 |
| `flutter_svg` | ^1.1.4 | ^2.0.0 | ⚠️ API 变更 |
| `device_info_plus` | ^9.0.0 | ^10.1.0 | 小幅变更 |
| `package_info_plus` | ^8.0.2 | ^8.1.0 | 无 |
| `flutter_secure_storage` | ^9.0.0 | ^9.2.0 | 无 |
| `intl` | ^0.18.0 | ^0.19.0 | 小幅变更 |
| `reown_walletkit` | 1.0.0 (锁定) | 需评估 | ⚠️ 区块链核心,谨慎升级 |
| `nfc_manager` | ^3.5.0 | ^3.5.0 | 已是最新 |
| `syncfusion_flutter_charts` | ^22.1.34 | ^27.x | ⚠️ 大版本跨度，需 License 确认 |

### 2.5 Pigeon 平台通道重新生成

当前使用 `pigeon: ^12.0.0`，升级后需重新生成所有平台通道代码：

```bash
# 升级后需执行
dart run pigeon \
    --input ./pigeons/message.dart \
    --dart_out lib/pigeons/messages.dart \
    --swift_out ios/Runner/Messages.swift \
    --java_out android/app/src/main/kotlin/com/cardcoin/card_coin/flutter/Messages.java \
    --java_package "com.cardcoin.card_coin.flutter"
```

> 注意：Pigeon 22.x 生成的代码与 12.x 不兼容，需同时更新 Android 和 iOS 的原生调用代码。

---

## 五、阶段3：Android Gradle 生态升级

**预估工期：3-5 天**  
**风险等级：中高**

### 3.1 Gradle 版本升级路径

```
Gradle 7.5 → Gradle 8.4 → Gradle 8.9+
AGP 7.4.2 → AGP 8.2 → AGP 8.7+
Kotlin 1.7.21 → Kotlin 1.9.x → Kotlin 2.0+
```

### 3.2 gradle-wrapper.properties 修改

```properties
# 修改前
distributionUrl=https\://services.gradle.org/distributions/gradle-7.5-all.zip

# 修改后（目标）
distributionUrl=https\://services.gradle.org/distributions/gradle-8.9-all.zip
```

### 3.3 dependencies.gradle 修改

```groovy
// 修改前
ext.versions = [
    kotlin      : '1.7.21',
    build_gradle: '7.4.2'
]

// 修改后
ext.versions = [
    kotlin      : '1.9.24',      // 或 2.0.x
    build_gradle: '8.7.3'        // AGP 8.7
]
```

### 3.4 根 build.gradle 变更

```groovy
// 修改前
buildscript {
    ext.kotlin_version = '1.7.21'
    dependencies {
        classpath "com.android.tools.build:gradle:$versions.build_gradle"
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$versions.kotlin"
        classpath "com.github.dcendents:android-maven-gradle-plugin:2.1"
        classpath 'com.squareup.wire:wire-gradle-plugin:4.4.3'
    }
}

// 修改后
buildscript {
    ext.kotlin_version = '1.9.24'
    dependencies {
        classpath "com.android.tools.build:gradle:$versions.build_gradle"
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$versions.kotlin"
        // android-maven-gradle-plugin 已废弃,移除
        classpath 'com.squareup.wire:wire-gradle-plugin:4.9.9'
    }
}
```

> ⚠️ `android-maven-gradle-plugin:2.1` 已废弃，如仅用于发布到 Maven，使用 `maven-publish` 内置插件替代。

### 3.5 app/build.gradle 关键变更

| 变更项 | 修改前 | 修改后 | 说明 |
|--------|--------|--------|------|
| `namespace` | 已声明 ✅ | 保持 | AGP 8.x 必须 |
| `compileSdkVersion` | 35 | `compileSdk 35` | 语法变更 |
| `minSdkVersion` | 24 | `minSdk 24` | 语法变更 |
| `targetSdkVersion` | 35 | `targetSdk 35` | 语法变更 |
| `lintOptions` | 已废弃 | `lint { }` | 已部分迁移 |
| `buildToolsVersion` | "34.0.0" | 移除（AGP 8.x 自动管理） | |
| `kotlin-android` 插件 | `apply plugin:` | `plugins { id 'org.jetbrains.kotlin.android' }` | 推荐但非必须 |

### 3.6 settings.gradle 迁移（可选但推荐）

AGP 8.x 推荐使用新式 `pluginManagement` 风格：

```groovy
// 新增到 settings.gradle 顶部
pluginManagement {
    def flutterSdkPath = {
        def properties = new Properties()
        file("local.properties").withInputStream { properties.load(it) }
        def flutterSdkPath = properties.getProperty("flutter.sdk")
        assert flutterSdkPath != null, "flutter.sdk not set in local.properties"
        return flutterSdkPath
    }()

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id "dev.flutter.flutter-plugin-loader" version "1.0.0"
    id "com.android.application" version "8.7.3" apply false
    id "org.jetbrains.kotlin.android" version "1.9.24" apply false
}

include ':app'
include ':blockchain'
project(':blockchain').projectDir = new File('../../blockchain-sdk-kotlin/blockchain')
include ':airchip3-sdk-android'
project(':airchip3-sdk-android').projectDir = new File('../../blockchain-sdk-kotlin/airchip3-sdk-android')
include ':airchip3-sdk-core'
project(':airchip3-sdk-core').projectDir = new File('../../blockchain-sdk-kotlin/airchip3-sdk-core')
```

> ⚠️ Flutter 3.22+ 要求使用声明式插件配置（`settings.gradle` 中使用 `plugins {}`）。如果升级到 Flutter 3.22+，这步是**必须**的。

### 3.7 gradle.properties 更新

```properties
# 移除（AGP 8.x 不再需要）
# android.enableJetifier=true   # 仅当所有依赖均已迁移 AndroidX 后移除

# 保留
android.useAndroidX=true
org.gradle.jvmargs=-Xmx4096M

# 新增（推荐）
org.gradle.caching=true
org.gradle.configuration-cache=true
kotlin.code.style=official
android.nonTransitiveRClass=true
```

> 关于 `enableJetifier`：需先验证所有 Android 依赖（blockchain、airchip3-sdk 等本地模块）均已完成 AndroidX 迁移，才可安全移除。

### 3.8 本地模块依赖风险

以下模块通过相对路径引用，升级时需同步处理：

| 模块 | 路径 | 风险 |
|------|------|------|
| `blockchain` | `../../blockchain-sdk-kotlin/blockchain` | 🔴 需确认兼容 AGP 8.x |
| `airchip3-sdk-android` | `../../blockchain-sdk-kotlin/airchip3-sdk-android` | 🔴 需确认兼容 AGP 8.x |
| `airchip3-sdk-core` | `../../blockchain-sdk-kotlin/airchip3-sdk-core` | 🔴 需确认兼容 AGP 8.x |

**这三个模块是升级 Gradle 的最大阻碍**，需要：
1. 检查各模块自身的 `build.gradle` 是否兼容 AGP 8.x
2. 检查 Kotlin 版本是否匹配
3. 如有必要，同步升级这三个模块

### 3.9 Android 原生依赖升级

| 依赖 | 当前版本 | 建议版本 | 说明 |
|------|----------|---------|------|
| `spongycastle` | 1.58.0.0 | **迁移到 BouncyCastle** 1.78+ | spongycastle 已废弃 |
| `bitcoinj-core` | 0.15.10 | 0.16.x 或 0.17 | 安全修复 |
| `protobuf-java` | 3.6.1 | 3.25.x+ | 存在已知 CVE |
| `grpc-protobuf/stub` | 1.17.1 | 1.64.x+ | 严重过时 |
| `retrofit2` | 2.8.1 | 2.11.0 | 稳定升级 |
| `moshi` | 1.13.0 | 1.15.x | 小幅升级 |
| `okhttp3 logging` | 4.9.3 | 4.12.0 | 安全修复 |
| `wire-gradle-plugin` | 4.4.3 | 4.9.x | 兼容 AGP 8.x |
| `kethereum` | 0.85.7 | 最新可用 | 检查 Jitpack 可用性 |
| `gson` | 2.8.6 | 2.11.0 | 安全修复 |
| `guava` | 30.0-android | 33.x-android | 安全修复 |
| `bugly:crashreport` | latest.release | 锁定具体版本 | 动态版本不安全 |

---

## 六、阶段4：iOS 生态升级

**预估工期：2-3 天**  
**风险等级：中**

### 6.1 Podfile 优化

#### 锁定未指定版本的 Pod

```ruby
# 修改前（版本未锁定）
pod 'BigInt'
pod 'SwiftyJSON'
pod 'Alamofire'
pod 'Moya'
pod 'Sodium'
pod 'SwiftCBOR'

# 修改后（锁定版本）
pod 'BigInt', '~> 5.2'
pod 'SwiftyJSON', '~> 5.0'
pod 'Alamofire', '~> 5.9'
pod 'Moya', '~> 15.0'
pod 'Sodium', '~> 0.9'
pod 'SwiftCBOR', '~> 0.4'
```

#### 本地路径依赖评估

| Pod | 当前引用 | 风险 | 建议 |
|-----|----------|------|------|
| `TangemSdk` | `path: ../../tangem-sdk-ios` | 🔴 本地路径 | 发布到私有 Pod repo 或固定 Git tag |
| `BitcoinCore.swift` | `path: ../../BitcoinCore.swift` | 🔴 本地路径 | 同上 |

#### Git 依赖固定

| Pod | 当前 tag | 问题 | 建议 |
|-----|----------|------|------|
| `BinanceChain` | `0.0.9` | tangem fork,版本过旧 | 评估是否仍需要,或升级 |
| `HDWalletKit` | `0.3.12` | tangem fork | 评估替代方案 |
| `web3swift` | `2.2.12` | tangem fork | 评估使用官方 web3swift 最新版 |
| `Solana.Swift` | `add-external-signer-7` | 非语义化版本 tag | ⚠️ 高风险,需固定到正式版本 |

### 6.2 iOS 构建设置更新

- 确认所有 Pod target 的 deployment target 与主工程一致（15.0）
- 移除 `NSAppTransportSecurity` 的 `NSAllowsArbitraryLoads`（安全风险）或仅白名单必要域名

---

## 七、升级检查清单

### 阶段1 完成标准
- [ ] `pubspec.yaml` SDK 约束修正为 `>=3.3.0 <4.0.0`
- [ ] 所有模糊版本依赖已锁定
- [ ] `dependency_overrides` 根因分析完成
- [ ] 代码中注释/废弃引用已清理
- [ ] `flutter pub get` 无警告
- [ ] 全量编译通过（Android & iOS）

### 阶段2 完成标准
- [ ] Flutter SDK 升级到目标版本
- [ ] fish_redux 兼容方案落地（fork 修复或迁移）
- [ ] 所有 Git fork 依赖替换为官方版本或私有仓库
- [ ] Pigeon 代码重新生成并验证
- [ ] `webview_flutter` 4.x API 适配完成
- [ ] `image_picker` 1.x API 适配完成
- [ ] 全量回归测试通过

### 阶段3 完成标准
- [ ] Gradle 升级到 8.9+
- [ ] AGP 升级到 8.7+
- [ ] Kotlin 升级到 1.9.x+
- [ ] settings.gradle 声明式插件配置迁移
- [ ] 本地模块（blockchain、airchip3-sdk）兼容性验证
- [ ] `spongycastle` 迁移到 `bouncycastle`
- [ ] `protobuf-java` 升级到 3.25+
- [ ] `enableJetifier` 安全移除评估
- [ ] Android 全版本构建通过（4 个 flavor）
- [ ] ProGuard/R8 规则验证

### 阶段4 完成标准
- [ ] 所有 Podfile 依赖版本锁定
- [ ] 本地 Pod 路径依赖迁移方案确定
- [ ] iOS 构建通过
- [ ] App Transport Security 安全策略配置

---

## 八、风险矩阵与应急方案

| 风险 | 概率 | 影响 | 应急方案 |
|------|------|------|---------|
| fish_redux 与新 Dart 不兼容 | 高 | 高 | 先 fork 最小化修复编译错误 |
| 本地 Android 模块不兼容 AGP 8.x | 高 | 高 | 保持 AGP 7.4 + Gradle 7.6 作为最低目标 |
| Pigeon 重新生成后平台通道不工作 | 中 | 高 | 保留旧版生成代码作为备份,逐步验证每个 API |
| kethereum JitPack 下载失败 | 中 | 中 | 预下载并放入本地 Maven repo |
| TangemSdk fork 不兼容 | 中 | 高 | 联系维护者或自行移植必要功能 |
| syncfusion_flutter_charts 跨大版本 | 中 | 中 | 停留在兼容版本,后续单独升级 |
| Google Play 商店策略要求 | 高 | 中 | targetSdk 已满足（35），关注 2026 年新要求 |

---

## 九、推荐执行节奏

| 阶段 | 时间窗口 | 前置条件 | 产出 |
|------|----------|---------|------|
| **阶段1** | 第1周 | 无 | 干净的依赖配置,可编译 |
| **阶段2** | 第2-3周 | 阶段1完成,fish_redux 方案确定 | Flutter/Dart 升级完成 |
| **阶段3** | 第4周 | 阶段2完成,本地模块评估完成 | Gradle 生态升级完成 |
| **阶段4** | 第5周 | 阶段2完成 | iOS 生态升级完成 |
| **回归测试** | 第6周 | 全部阶段完成 | 全功能验证 |

> 阶段 3 和阶段 4 可以并行开展。

---

## 十、长期建议

1. **引入 FVM (Flutter Version Management)**：统一团队 Flutter 版本，避免 `user-branch` 不可控风险
2. **建立私有 Pub/Maven/Pod 仓库**：将所有 fork 依赖发布到私有仓库，统一版本管理
3. **状态管理迁移规划**：中长期将 fish_redux 迁移到 Bloc 或 Riverpod，降低维护风险
4. **Pigeon → Federated Plugin**：考虑将平台通道代码迁移为标准 Flutter Federated Plugin 模式
