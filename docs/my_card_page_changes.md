# MyCard 首页相关改动记录

本文档记录在 `my_card_page`、`tab_wallet`、`card_bottom_action_bar` 等处的功能与布局调整，便于后续查阅与 Code Review。

---

## 1. 滚动与手势（`my_card_page/view.dart`）

### 1.1 DApp 列表

- **问题**：外层 `SingleChildScrollView` / `ListView` 与内层固定高度 `ListView` 嵌套，纵向滑动冲突。
- **处理**：`buildDappList` 中内层 `ListView.builder` 使用 `shrinkWrap: true` + `NeverScrollableScrollPhysics()`，去掉固定 `SizedBox(height: 300)`，与外层合并为同一滚动轴。

### 1.2 Syncfusion K 线（`_makeuplinechart`）

- **问题**：`ZoomPanBehavior` 在 `enablePinching: true` 且默认 `zoomMode == xy` 时，内部仍会注册纵向 Drag，拦截外层列表滚动。
- **处理**：`enablePanning: false`，并设置 `zoomMode: ZoomMode.x`；移除无实质作用的 `GestureDetector` 包裹。双指缩放仍可用，单指纵向滑动交给页面。

### 1.3 fl_chart 折线图

- **说明**：曾尝试关闭 `LineTouchData` 以释放纵向滑动；按产品要求**保留图表拖拽交互**，相关改动已恢复为与仓库一致的 `LineTouchData`（含 `touchCallback`）。

---

## 2. 扫卡后底部大块空白（`buildNewInActiveView`）

- **原因**：`Stack(fit: StackFit.expand)` 下 `SingleChildScrollView` 默认占满父级高度，内容（`Column`）较矮时，滚动视口下半部分表现为大块空白。
- **处理**：改为 `Align(alignment: Alignment.topCenter)` + `ListView(shrinkWrap: true, physics: AlwaysScrollableScrollPhysics())`，高度随内容，内容贴顶；去掉仅包一层子节点的多余 `Column`。

---

## 3. 底部操作栏（`card_bottom_action_bar.dart`）

- **问题**：`addButton` 已对子组件包一层 `Expanded(child: button)`，各 `_buildXxxButton` 内又 `return Expanded(child: ElevatedButton(...))`，形成 `Row → Expanded → Expanded → Button`，违反 `ParentDataWidget` 规则。
- **处理**：去掉各 builder 内层 `Expanded`，仅保留 `ElevatedButton` / `OutlinedButton`，由 `addButton` 统一 `Expanded`。

---

## 4. 投资摘要卡：未激活 / 已激活合并（`my_card_page/view.dart`）

### 4.1 问题

- `buildNewInActiveView` 在调用 `buildNewActiveView` 之后，又根据 `isShowInActiveCard` 再画一块卡片，与 `buildNewActiveView` 内 `isShowActiveCard` 区块重复（如 Plan、Card balance、Amount 出现两次）。
- 原 `isShowInActiveCard` 中 `&&` 与 `||` 未加括号，**已激活**卡片在开启余额等配置时仍可能满足「未激活」分支，加剧重复。

### 4.2 处理

- 删除 `buildNewInActiveView` 中整段 `if (isShowInActiveCard(...)) { ... }` 独立卡片。
- 新增：
  - `_investmentIsInactive(state)`：未激活 / 处理中 / 无投资信息。
  - `_shouldShowInvestmentSummaryCard(state, detailTitle1)`：是否展示**唯一**投资摘要卡（合并原两路展示条件）。
  - `_buildMergedInvestmentSummaryCard(...)`：单卡片 UI；第三列**未激活**为 Maximum periods，**已激活**为 Executed Count，互斥；周期行未激活带 Execute Time，已激活用 `intervalDescription`。
- `buildNewActiveView` 增加命名参数 `detailTitle1`、`investime`，由 `buildNewInActiveView` 传入，避免与父级周期计算不一致；内部删除重复的 `detailTitle1` / `investime` 计算及对 `investmentSelectInfo` 的同步块。
- 删除旧函数 `isShowInActiveCard`、`isShowActiveCard`。

### 4.3 调用方式

```dart
buildNewActiveView(state, dispatch, viewService,
    detailTitle1: detailTitle1, investime: investime);
```

---

## 涉及文件（主要）

| 文件 | 变更摘要 |
|------|----------|
| `lib/card_base/pages/main_page/tab_pages/tab_wallet_page/my_card_page/view.dart` | 滚动、K 线、空白、合并投资摘要卡与辅助函数 |
| `lib/card_base/pages/main_page/tab_pages/tab_wallet_page/view/card_bottom_action_bar.dart` | 去掉重复的 `Expanded` |

---

*文档随实现整理，若后续仍有修改，请在本文件追加小节并注明日期。*
