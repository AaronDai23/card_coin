# Card Coin 代码依赖风险分析与改造方案

> 生成日期：2026-04-06

---

## 一、总体概述

Card Coin 项目跨 Flutter / iOS / Android 三端，依赖管理分别由 `pubspec.yaml`、`Podfile`、`build.gradle` 负责。本文档从以下维度对所有三方依赖进行风险评估：

| 风险维度 | 说明 |
|---------|------|
| **源码托管风险** | 依赖来源为 Git 仓库（gitee/github）、本地路径引用，存在仓库不可达、被删除、篡改风险 |
| **版本锁定风险** | 使用不精确版本约束（`any`、`^`、`latest.release`），可能导致构建不确定性 |
| **安全漏洞风险** | 依赖版本过旧，存在已知 CVE 漏洞 |
| **维护状态风险** | 三方库停止维护、不兼容新系统版本 |
| **供应链攻击风险** | 三方仓库被恶意注入代码 |
| **本地路径依赖风险** | 依赖本地文件路径，其他开发者/CI 无法构建 |

---

## 二、Flutter (pubspec.yaml) 依赖风险分析

### 2.1 高风险依赖

| 依赖 | 当前版本/来源 | 风险等级 | 风险说明 |
|------|-------------|---------|---------|
| `fish_redux` | git: gitee.com/yu_yong_yao | 🔴 高 | Gitee 个人仓库 fork，原库已停止维护多年；Git 依赖无版本锁定；仓库可能随时被删除 |
| `modal_bottom_sheet` | git: gitee.com/yu_yong_yao | 🔴 高 | 同上，Gitee 个人仓库 fork，无 tag 锁定 |
| `update_app` | git: gitee.com/yu_yong_yao | 🔴 高 | 同上，Gitee 个人仓库 fork，无 tag 锁定 |
| `logger` | `any` | 🔴 高 | 版本约束为 `any`，任何大版本升级都会自动拉入，可能引入 Breaking Change |
| `sdk: '>=2.19.2 <3.0.0'` | — | 🔴 高 | Dart SDK 锁定在 2.x，Flutter 3.x+ 已全面迁移 Dart 3，存在严重升级障碍 |

### 2.2 中风险依赖

| 依赖 | 当前版本 | 风险等级 | 风险说明 |
|------|---------|---------|---------|
| `webview_flutter` | ^3.0.4 | 🟡 中 | 当前已有 4.x 版本，3.x API 差异较大 |
| `flutter_html` | ^3.0.0-alpha.6 | 🟡 中 | 使用 alpha 预发布版本，API 不稳定 |
| `appsflyer_sdk` | 6.14.3 | 🟡 中 | 精确版本锁定过死，无法获取安全补丁 |
| `eth_sig_util` | ^0.0.9 | 🟡 中 | 版本号 0.x，可能不稳定 |
| `reown_walletkit` | 1.0.0 | 🟡 中 | 精确锁定版本，无法自动获取补丁更新 |
| `flutter_svg` | ^1.1.4 | 🟡 中 | 已有 2.x 版本，接口有变化 |
| `scan` | ^1.6.0 | 🟡 中 | 小众库，维护频率低 |
| `sealed_class_annotations` | 1.13.2 | 🟡 中 | 精确版本锁定 |
| `sealed_class_creators` | 1.13.2 | 🟡 中 | 精确版本锁定 |

### 2.3 低风险依赖（维护活跃的主流库）

| 依赖 | 备注 |
|------|------|
| `dio` ^5.0.0 | 主流 HTTP 库，维护活跃 |
| `shared_preferences` ^2.0.15 | Flutter 官方维护 |
| `url_launcher` ^6.1.14 | Flutter 官方维护 |
| `path_provider` ^2.1.2 | Flutter 官方维护 |
| `permission_handler` ^10.0.0 | 社区活跃维护 |
| `connectivity_plus` ^6.0.4 | Flutter Community 维护 |
| `flutter_secure_storage` ^9.0.0 | 社区活跃维护 |
| `intl` ^0.18.0 | Dart 官方维护 |
| 其他官方/活跃社区库 | 风险较低，常规关注即可 |

### 2.4 Flutter 改造方案

| 序号 | 改造项 | 具体措施 | 优先级 | 预估工时 |
|------|--------|---------|--------|---------|
| F1 | **Git 依赖仓库化** | 将 `fish_redux`、`modal_bottom_sheet`、`update_app` 从 Gitee 个人仓库迁移到团队私有 Git 仓库或私有 Pub 仓库，并锁定特定 commit/tag | P0 | 0.5天 |
| F2 | **消除 `any` 版本约束** | 将 `logger: any`、`build_runner: any` 改为精确版本范围（如 `^2.0.0`） | P0 | 0.5天 |
| F3 | **消除 dependency_overrides** | 排查 `watcher: ^1.1.0` 覆盖原因，升级冲突依赖方使之兼容，移除 override | P1 | 0.5天 |
| F4 | **替换 alpha 依赖** | 将 `flutter_html: ^3.0.0-alpha.6` 替换为稳定版或替换为其他稳定 HTML 渲染库（如 `flutter_widget_from_html`） | P1 | 0.1天 |

---

## 三、iOS (Podfile) 依赖风险分析

### 3.1 高风险依赖

| 依赖 | 当前来源 | 风险等级 | 风险说明 |
|------|---------|---------|---------|
| `BinanceChain` | git: github.com/tangem，tag: 0.0.9 | 🔴 高 | 依赖第三方 GitHub 仓库，tag 版本较旧，仓库可能被删除/重命名 |
| `HDWalletKit` | git: github.com/tangem，tag: 0.3.12 | 🔴 高 | 同上 |
| `web3swift` | git: github.com/tangem，tag: 2.2.12 | 🔴 高 | 同上，且为 tangem 组织 fork 版本 |
| `Solana.Swift` | git: github.com/tangem，tag: add-external-signer-7 | 🔴 高 | tag 名非语义化版本，表明是临时/开发版本；依赖外部 fork |

### 3.2 中风险依赖

| 依赖 | 当前版本 | 风险等级 | 风险说明 |
|------|---------|---------|---------|
| `TrustWalletCore` | ~> 4.4 | 🟡 中 | 较大型 C++ 库，编译耗时长，版本跨度大时可能有 Breaking Change |
| `Sodium` | 未锁定版本 | 🟡 中 | 加密库，版本未精确锁定 |
| `SwiftCBOR` | 未锁定版本 | 🟡 中 | 版本未精确锁定 |
| `BigInt` | 未锁定版本 | 🟡 中 | 版本未精确锁定 |
| `Alamofire` | 未锁定版本 | 🟡 中 | 主流库但版本未锁定，大版本升级可能不兼容 |
| `Moya` | 未锁定版本 | 🟡 中 | 同上 |
| `ScaleCodec` | 未锁定版本 | 🟡 中 | 小众库，维护状态待确认 |
| `stellar-ios-mac-sdk` | 未锁定版本 | 🟡 中 | 小众库，需关注维护状态 |

### 3.3 低风险依赖

| 依赖 | 备注 |
|------|------|
| `SwiftyJSON` | 社区成熟库 |
| `AnyCodable-FlightSchool` | 轻量工具库 |
| `SwiftProtobuf` ~> 1.26 | Google 官方维护，版本锁定合理 |

### 3.4 iOS 改造方案

| 序号 | 改造项 | 具体措施 | 优先级 | 预估工时 |
|------|--------|---------|--------|---------|
| I1 | **消除Tangem依赖** | 将 `TangemSdk`、`BitcoinCore.swift` 发布到私有 CocoaPods Spec 仓库或使用 Git + 语义化 tag 引用，确保 CI 可构建 | P0 | 0.2天 |
| I2 | **Git 依赖版本固化** | 将所有 Git 依赖（BinanceChain、HDWalletKit、web3swift、Solana.Swift）fork 到团队仓库，使用语义化 tag 版本 | P0 | 0.2天 |
| I3 | **Pod 版本精确锁定** | 为所有未指定版本的 Pod（BigInt、SwiftyJSON、Alamofire、Moya、Sodium 等）添加精确版本约束 | P1 | 0.1天 |
| I5 | **建立私有 CocoaPods Spec 仓库** | 搭建团队私有 Spec 仓库，将关键依赖（TangemSdk、BitcoinCore、blockchain SDK）发布到私有 Spec | P1 | 1天 |
| I6 | **Solana.Swift tag 规范化** | 将 `add-external-signer-7` 这类 tag 替换为语义化版本号（如 1.0.0-signer.7） | P1 | 0.2天 |

---

## 四、Android (build.gradle) 依赖风险分析

### 4.1 高风险依赖

| 依赖 | 当前版本/来源 | 风险等级 | 风险说明 |
|------|-------------|---------|---------|
| `project(':blockchain')` | 本地路径 `../../blockchain-sdk-kotlin/blockchain` | 🔴 高 | **本地路径依赖**，其他开发者/CI 无法构建；路径耦合 |
| `project(':airchip3-sdk-android')` | 本地路径 `../../blockchain-sdk-kotlin/airchip3-sdk-android` | 🔴 高 | 同上 |
| `project(':airchip3-sdk-core')` | 本地路径 `../../blockchain-sdk-kotlin/airchip3-sdk-core` | 🔴 高 | 同上 |
| `com.tencent.bugly:crashreport` | 4.1.9.3 | 🔴 高 | 使用动态版本，构建不确定，可能自动引入不兼容版本 |
| `com.github.dogecoin:libdohj` | v0.15 | 🟡 中 | JitPack 托管 GitHub 仓库依赖，仓库可能被删除 |
| `com.github.walleth.kethereum:*` | 0.85.7 | 🟡 中 | 多个 kethereum 模块均来自 JitPack/GitHub，仓库可控性低 |
| `com.github.komputing.khex:extensions` | 1.1.2 | 🟡 中 | 同上，JitPack 依赖 |

### 4.2 中风险依赖

| 依赖 | 当前版本 | 风险等级 | 风险说明 |
|------|---------|---------|---------|
| `org.bitcoinj:bitcoinj-core` | 0.15.10 | 🟡 中 | 版本较旧（已有 0.16+），可能存在已知安全漏洞 |
| `com.google.protobuf:protobuf-java` | 3.6.1 | 🟡 中 | 版本极旧（当前已 4.x），存在已知 CVE |
| `io.grpc:grpc-protobuf` | 1.17.1 | 🟡 中 | 版本极旧（当前已 1.60+），存在安全风险 |
| `io.grpc:grpc-stub` | 1.17.1 | 🟡 中 | 同上 |
| `com.google.code.gson:gson` | 2.8.6 | 🟡 中 | 存在已知 CVE（建议升级到 2.10+） |
| `com.madgag.spongycastle:*` | 1.58.0.0 | 🟡 中 | Spongycastle 已停止维护，建议迁移到 BouncyCastle |
| `com.squareup.moshi:moshi` | 1.13.0 | 🟡 中 | 有更新版本可用 |
| Kotlin | 1.7.21 | 🟡 中 | 已有 Kotlin 1.9+/2.0，旧版可能不兼容新 AGP |
| AGP (Android Gradle Plugin) | 7.4.2 | 🟡 中 | 已有 8.x，旧版不支持最新 Android SDK 特性 |
| `ru.gildor.coroutines:kotlin-coroutines-okhttp` | 1.0 | 🟡 中 | 小众库，维护频率低 |

### 4.3 低风险依赖

| 依赖 | 备注 |
|------|------|
| `com.squareup.retrofit2:retrofit` 2.8.1 | 主流网络库 |
| `com.squareup.okhttp3:logging-interceptor` 4.9.3 | 主流库 |
| `com.google.guava:guava` 30.0-android | Google 维护 |
| `com.squareup.wire:wire-gradle-plugin` 4.4.3 | Square 维护 |
| `androidx.multidex:multidex` 2.0.1 | AndroidX 官方 |


### 4.4 Android 改造方案

| 序号 | 改造项 | 具体措施 | 优先级 | 预估工时 |
|------|--------|---------|--------|---------|
| A1 | **消除本地路径依赖** | 将 blockchain、airchip3-sdk-android、airchip3-sdk-core 发布到私有 Maven 仓库（Nexus/Artifactory），通过 GAV 坐标引用 | P0 | 0.5天 |
| A2 | **消除动态版本** | 将 `com.tencent.bugly:crashreport:latest.release` 改为确定版本号（如 `4.1.9.3`） | P0 | 0.1天 |
| A4 | **替换已停维库** | 将 `spongycastle` 迁移到 `org.bouncycastle:bcprov-jdk15on`（需要调整加密相关代码） | P1 | 1天 |
| A5 | **JitPack 依赖镜像** | 将 kethereum、khex、libdohj 等 JitPack 依赖 fork 到团队仓库，发布到私有 Maven | P1 | 1天 |
| A6 | **开启代码混淆** | Release 构建开启 `minifyEnabled true`、`shrinkResources true`，编写完善的 ProGuard 规则 | P1 | 0.5天 |
| A9 | **搭建私有 Maven 仓库** | 如尚未有，搭建 Nexus 或 Artifactory 作为团队私有 Maven 仓库，统一管理内部和镜像依赖 | P1 | 0.5天 |
| A10 | **Gradle 版本目录 (Version Catalog)** | 引入 `gradle/libs.versions.toml` 统一管理依赖版本，替代分散在各 `build.gradle` 的版本定义 | P2 | 1天 |

---

## 五、跨端通用改造方案

| 序号 | 改造项 | 具体措施 | 优先级 | 预估工时 |
|------|--------|---------|--------|---------|
| C1 | **统一私有依赖仓库** | 搭建通用的私有包管理基础设施：Flutter 私有 Pub 仓库 + iOS 私有 CocoaPods Spec + Android 私有 Maven，统一管理内部 SDK | P0 | 1天 |
| C3 | **依赖更新自动化** | 引入 Dependabot/Renovate Bot 自动检测依赖更新，创建 MR/PR 进行审查 | P2 | 1天 |

---

## 六、改造优先级与工时汇总

### 6.1 按优先级分组

#### P0 — 紧急（阻塞构建/重大风险）

| 编号 | 改造项 | 端 | 预估工时 |
|------|--------|---|---------|
| F1 | Git 依赖仓库化 | Flutter | 0.5天 |
| F2 | 消除 `any` 版本约束 | Flutter | 0.5天 |
| I1 | 消除 Tangem 依赖 | iOS | 0.2天 |
| I2 | Git 依赖版本固化 | iOS | 0.2天 |
| I4 | Podfile.lock 版本控制 | iOS | 0.1天 |
| A1 | 消除 Android 本地路径依赖 | Android | 0.5天 |
| A2 | 消除动态版本 | Android | 0.1天 |
| C1 | 统一私有依赖仓库 | 通用 | 1天 |
| C2 | CI/CD 依赖锁定 | 通用 | 1天 |
| **小计** | | | **4.1天** |

#### P1 — 重要（安全/稳定性提升）

| 编号 | 改造项 | 端 | 预估工时 |
|------|--------|---|---------|
| F3 | 消除 dependency_overrides | Flutter | 0.5天 |
| F4 | 替换 alpha 依赖 | Flutter | 0.1天 |
| I3 | Pod 版本精确锁定 | iOS | 0.1天 |
| I5 | 私有 CocoaPods Spec 仓库 | iOS | 1天 |
| I6 | Solana.Swift tag 规范化 | iOS | 0.2天 |
| A4 | 替换已停维库 (spongycastle) | Android | 1天 |
| A5 | JitPack 依赖镜像 | Android | 1天 |
| A6 | 开启代码混淆 | Android | 0.5天 |
| A9 | 搭建私有 Maven 仓库 | Android | 0.5天 |
| **小计** | | | **4.9天** |

#### P2 — 改进（长期优化）

| 编号 | 改造项 | 端 | 预估工时 |
|------|--------|---|---------|
| A10 | Gradle 版本目录 (Version Catalog) | Android | 1天 |
| C3 | 依赖更新自动化 | 通用 | 1天 |
| **小计** | | | **2天** |

### 6.2 总体工时预估

| 优先级 | 工时范围 | 建议排期 |
|--------|---------|---------|
| P0 紧急 | **~4.1 人天** | 本周内 |
| P1 重要 | **~4.9 人天** | 第1-2周 |
| P2 改进 | **~2 人天** | 第2-3周 |
| **总计** | **~11 人天** | 约 2-3 周内完成 |

> 注：以上工时预估基于单人全职投入计算，实际排期需根据团队人力和并行度调整。

---

## 七、风险依赖速查表

### 所有本地路径依赖（构建阻塞风险）

| 端 | 依赖 | 路径 |
|----|------|------|
| iOS | TangemSdk | `../../tangem-sdk-ios` |
| iOS | BitcoinCore.swift | `../../BitcoinCore.swift` |
| Android | blockchain | `../../blockchain-sdk-kotlin/blockchain` |
| Android | airchip3-sdk-android | `../../blockchain-sdk-kotlin/airchip3-sdk-android` |
| Android | airchip3-sdk-core | `../../blockchain-sdk-kotlin/airchip3-sdk-core` |

### 所有 Git 仓库依赖（仓库不可达风险）

| 端 | 依赖 | 来源 |
|----|------|------|
| Flutter | fish_redux | gitee.com/yu_yong_yao |
| Flutter | modal_bottom_sheet | gitee.com/yu_yong_yao |
| Flutter | update_app | gitee.com/yu_yong_yao |
| iOS | BinanceChain | github.com/tangem tag:0.0.9 |
| iOS | HDWalletKit | github.com/tangem tag:0.3.12 |
| iOS | web3swift | github.com/tangem tag:2.2.12 |
| iOS | Solana.Swift | github.com/tangem tag:add-external-signer-7 |

### 所有动态/不确定版本

| 端 | 依赖 | 版本 |
|----|------|------|
| Flutter | logger | `any` |
| Flutter | build_runner | `any` |
| Android | bugly crashreport | `latest.release` |

---

## 八、建议执行路线图

```
第1阶段（本周）—— P0 紧急项
├── Git 依赖仓库化（fish_redux、modal_bottom_sheet、update_app）
├── 消除动态版本（any / latest.release）
├── 消除 Tangem 本地路径依赖
├── iOS/Android Git 依赖版本固化
├── 所有 lock 文件纳入 Git
└── 搭建私有依赖仓库基础设施

第2阶段（第1-2周）—— P1 重要项
├── 替换已停维库（spongycastle）
├── JitPack 依赖 fork 到团队仓库
├── 开启 Android 代码混淆
├── Pod 版本精确锁定 & Solana.Swift tag 规范化
├── 搭建私有 CocoaPods Spec / Maven 仓库
├── 消除 dependency_overrides
└── 替换 alpha 依赖（flutter_html）

第3阶段（第2-3周）—— P2 改进项
├── Gradle Version Catalog 引入
└── 依赖更新自动化（Dependabot/Renovate）
```

---