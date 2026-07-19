# ChipBase / OfferVas App Store 上架方案

> 目的：降低 iOS App Store Guideline **4.3 Spam** 拒审风险。  
> 本文将两个可选方案**完全分开说明**，应根据实际分发要求选择其中一个执行：
>
> - **方案一：双 App 公版上架**——ChipBase 与 OfferVas 都保留在公开 App Store
> - **方案二：单 App 分渠道**——公开 App Store 只保留一个对外 App，内部渠道单独处理
>
> 两个方案互不依赖；无需同时实施。

## 基础产品定位

| | ChipBase（内部） | OfferVas（对外） |
|---|---|---|
| 受众 | 公司**内部员工** | **外部公众**个人客群 |
| 账号开通 | 公司统一开通，**不开放公开注册** | 用户**自助注册** |
| 品牌叙事 | 员工专属、内部服务 | 个人开户、消费与增值服务 |
| 视觉建议 | 蓝色体系 | 橙色主题 |
| 核心差异信号 | 「员工登录 / 员工卡 / IT 支持」 | 「创建账户 / 自助获卡 / 在线客服 / 注销账户」 |

---

# 方案一：双 App 公版上架

## 1. 适用场景与上架顺序

> 适用场景：ChipBase 和 OfferVas 必须拥有独立图标、独立商店页面，并且都需要在公开 App Store 中可搜索下载。
> 该方案存在 4.3 风险，必须让审核员能验证两者面向不同用户、采用不同账号开通方式。

1. **先改造并更新 ChipBase**（未登录 + 首页文案 + 设置/About + 消息模板）  
2. 确认 ChipBase 新版本已在 App Store 生效  
3. **再提交 OfferVas**  
4. OfferVas Review Notes 附上「双 App 定位说明」（见文末模板）

> 不要在 ChipBase 仍是「普通登录注册 UI」时，同时提交高度同款的 OfferVas。

---

## 2. ChipBase 改造清单（内部员工版）

### 2.1 未登录页（需发版 · 优先级最高）

#### Banner / 大图轮播

| 屏 | 中文 | English |
|---|---|---|
| 第 1 屏标题 | ChipBase 员工专属服务 | ChipBase — For Employees Only |
| 第 1 屏副文案 | 仅限公司内部员工开通和使用 | This app is exclusively for internal staff |
| 第 2 屏标题 | 内部开通，安全使用 | Provisioned by Your Company |
| 第 2 屏副文案 | 账号由公司统一配置，登录后即可使用 | Accounts are issued internally. Sign in to get started |

要求：插画/场景与 OfferVas **不要共用同一套素材换色**。

#### 按钮与跳转

| 控件 | 文案（中） | 文案（英） | 跳转 |
|---|---|---|---|
| 主按钮 | 员工登录 | Employee Sign In | → 登录页 |
| 次入口 | 没有账号？联系内部支持开通 | No account? Contact internal support | → **说明页/弹窗**（禁止进公开注册） |

说明页/弹窗文案：

> ChipBase 仅供公司内部员工使用，账号由公司统一开通，暂不支持公众自行注册。如需开通，请联系内部 IT 支持或相关负责人。  
>  
> ChipBase is for internal employees only. Accounts are provisioned by the company. Public self-registration is not available. Please contact IT support.

#### 必须改动

- [ ] **隐藏或移除公开「注册」入口**
- [ ] 主按钮改为「员工登录」
- [ ] 次入口不进入注册表单

#### 登录页提示（可选但建议）

> ChipBase 仅供公司内部员工使用，需要有效的内部账号才能登录。  
> ChipBase is for internal employees only. A valid employee account is required to sign in.

---

### 2.2 首页（需发版 · 高优先级）

现状：顶部 Banner 轮播 + 中央「Click to scan card」扫卡区。

| 位置 | 现状 | 改成（中） | 改成（英） |
|---|---|---|---|
| Banner | Why use ChipBase? 等 | 带「员工 / employee」叙事的独立文案 | 见 2.1 Banner |
| 扫卡区主文案 | Click to scan card | 扫描员工卡 | Scan your employee card |
| 扫卡区副文案（建议新增） | 无 | 将公司发放的卡片靠近手机 | Hold your company-issued card near the phone |

#### 建议新增一块（对方 OfferVas 没有的模块）

- [ ] 增加「公司公告 / Notices」入口或小卡片（哪怕后台只发一条欢迎公告）  
- [ ] 或增加「联系 IT 支持」快捷入口  

> 目的：让两边首页截图从「完全同一骨架」变成「多一块不同模块」。

---

### 2.3 消息中心（后台即可 · 高优先级）

现状问题：消息内容为「Task Award / 任务奖励 / 会员等级提升 / Emoney Member」等**消费运营话术**，与「员工内部 App」叙事冲突；且中英印尼语混排。

| 动作 | 说明 |
|---|---|
| 改推送模板 | 改为中性/内部化：「余额变动」「卡片服务通知」「系统公告」 |
| 停发/改名 | 「会员等级」「任务奖励」类运营文案在 ChipBase 停发或改写 |
| 统一语言 | 按用户语言设置统一下发，避免同一列表多语言混杂 |
| 「Manager」按钮 | 建议改为「编辑 / Edit」，避免误解 |

- [ ] 消息模板内部化  
- [ ] 语言统一  
- [ ] Manager → Edit（如适用）

---

### 2.4 设置页（后台配置为主 · 部分需发版）

现状：顶栏 Settings、头像卡（ID）、动态菜单、底部 Delete Account / Logout。

| 项目 | 动作 | 方式 |
|---|---|---|
| 头像区 | 增加标签「员工账户 / Employee Account」（可选显示工号/部门） | 小发版 |
| Quick start guide | 改名为「内部使用指南 / Employee Guide」 | 后台文案 |
| 新增菜单 | 「联系 IT 支持 / Contact IT Support」 | 后台配置 |
| About | 写入定位声明（见下） | About 内容 |
| Delete Account / Logout | **保留** | 不动 |
| Health Check / Network Check | 保留（偏工具/内部风，有利于差异） | 不动 |

#### About 文案

中文：

> ChipBase 是面向公司内部员工提供的专属应用，用于卡片及相关服务的内部使用。账号由公司统一开通和管理，不面向公众开放注册。

English：

> ChipBase is an internal application exclusively provided for company employees for card-related services. Accounts are provisioned and managed by the company. Public registration is not available.

---

### 2.5 ChipBase 验收标准（给测试/产品）

审核员路径应看到：

1. 未登录：员工专属叙事 + **员工登录**，**无公开注册**  
2. 首页：扫**员工卡**，可选公司公告  
3. 消息：无会员/任务奖励类消费文案  
4. 设置/About：明确「员工专属、公司开通」

---

## 3. OfferVas 改造清单（外部客群版）

### 3.1 未登录页（需发版 · 优先级最高）

#### Banner / 大图轮播

| 屏 | 中文 | English |
|---|---|---|
| 第 1 屏标题 | 开启你的便捷卡片服务 | Your card & value-added services |
| 第 1 屏副文案 | 面向个人用户的一站式卡片与增值服务 | For individual consumers |
| 第 2 屏标题 | 轻松管理，安全使用 | Easy to manage, safe to use |
| 第 2 屏副文案 | 随时查看和管理你的个人服务 | View and manage your personal services anytime |

要求：

- [ ] **禁止**使用「员工 / 内部 / 企业开通」等 ChipBase 文案  
- [ ] Banner 素材与 ChipBase 不共用同一套换色图

#### 按钮与跳转

| 控件 | 文案（中） | 文案（英） | 跳转 |
|---|---|---|---|
| 主按钮 | 创建 OfferVas 账户 | Create OfferVas Account | → **公开注册** |
| 次入口 | 已有账户？登录 | Already have an account? Sign in | → 普通登录 |

---

### 3.2 首页（需发版 · 高优先级）

布局可与 ChipBase 类似（Banner + 扫卡），但文案与模块必须不同。

| 位置 | 建议（中） | 建议（英） |
|---|---|---|
| 扫卡区主文案 | 扫描你的卡片 | Scan your OfferVas card |
| 扫卡区副文案 | 靠近手机以查看余额与优惠 | Hold your card near the phone to view balance & offers |
| 主题色 | 橙色体系 | — |

#### 建议新增一块（ChipBase 没有的模块）

任选至少 1 项：

- [ ] 「如何获得卡片？ / Get a card」引导入口（外部用户常见需求）  
- [ ] 「优惠活动 / Offers」运营位  
- [ ] 「邀请好友」入口  

> 与 ChipBase「公司公告 / IT」形成对位差异。

可选：扫卡按钮形态微调（如圆形 / 底部宽按钮），进一步拉开截图相似度。

---

### 3.3 消息中心

- [ ] 可保留任务奖励、会员等级、营销类消息（符合公众产品）  
- [ ] 语言按用户设置统一  
- [ ] 标题建议「消息中心 / Message Center」；管理按钮用「编辑 / Edit」

---

### 3.4 设置页（后台配置 + 合规必改）

| 项目 | 动作 | 说明 |
|---|---|---|
| 账户区 | 个人资料（头像/昵称/手机） | 消费者向 |
| 实名认证 | 建议保留/展示（若业务有） | ChipBase 可不强调 |
| 支持区 | **在线客服**、帮助中心、意见反馈 | 不要用「IT 支持」 |
| 合规 | 用户协议、隐私政策放显眼位置 | 公众 App 必备 |
| **注销账户** | **必须保留且可用** | Apple 5.1.1(v) 强制；开放注册 App 无此入口会拒 |
| About | 写入对外定位声明（见下） | — |
| 顶栏颜色 | 橙色 | 与 ChipBase 蓝区分 |

#### About 文案

中文：

> OfferVas 是面向公众个人用户提供的卡片与增值服务应用。用户可以自行注册账户并使用相关服务。

English：

> OfferVas is a consumer-facing card and value-added services application for the general public. Users can create an account via public registration and use related services.

---

### 3.5 OfferVas 验收标准

审核员路径应看到：

1. 未登录：**创建账户** + 公开注册  
2. 首页：消费向文案 + 至少一块 ChipBase 没有的模块（获卡/优惠等）  
3. 设置：在线客服/帮助 + **可自助注销账户**  
4. About：明确公众产品定位  

---

## 4. 双 App 审核差异对照

| 环节 | ChipBase | OfferVas |
|---|---|---|
| 主 CTA | 员工登录 | 创建 OfferVas 账户 |
| 注册 | 关闭 / 仅内部开通说明 | 开放自助注册 |
| 首页扫卡文案 | 扫描员工卡 | 扫描你的卡片 |
| 首页额外模块 | 公司公告 / IT | 获卡引导 / 优惠 |
| 设置支持入口 | 联系 IT 支持 | 在线客服 / 帮助中心 |
| About | 员工专属、公司开通 | 公众产品、自助注册 |
| 消息内容 | 系统/服务通知 | 可含运营/会员/任务 |
| 主题色 | 蓝 | 橙 |

---

## 5. 工作量与工时估算

> 口径说明：按 **1 人日 = 8 人时**；含开发、联调、自测。不含 Apple 审核排队等待、设计出图反复修改、ABM/企业账号开通等外部依赖。  
> 角色：开发 / 设计 / 后台运营配置 / 测试。可并行时日历周期会短于人时之和。

### 5.1 ChipBase 明细工时

| 优先级 | 工作项 | 角色 | 人时 | 说明 |
|---|---|---|---:|---|
| P0 | 未登录：员工登录 + 收掉公开注册 + 说明弹窗 | 开发 | 8 | 改 CTA、路由、隐藏注册 |
| P0 | Banner 文案与独立素材 | 设计 | 8 | 2 张大图 + 中英文案 |
| P0 | Banner 接入 | 开发 | 2 | 替换资源/配置 |
| P0 | 首页扫卡文案改为员工卡 | 开发 | 2 | 文案与可选副文案 |
| P0 | About 定位声明 | 开发/内容 | 2 | 中英一段即可 |
| P0 | 消息模板去消费化、统一语言 | 后台运营 | 4 | 改推送模板，一般无需发版 |
| P1 | 设置：IT 支持项 + 内部指南改名 | 后台/开发 | 4 | 多为动态配置 |
| P1 | 头像区「员工账户」标签 | 开发 | 4 | 小 UI |
| P1 | 首页公司公告或 IT 入口模块 | 开发+设计 | 12 | 开发 8 + 设计 4 |
| P2 | Manager→Edit、扫卡形态微调等 | 开发/设计 | 6 | 可选 |
| — | 自测 + 回归（未登录→首页→设置→消息） | 测试 | 8 | |
| — | 打包提审、截图、版本说明 | 开发 | 4 | |

**ChipBase 小计**

| 范围 | 人时 | 约人日 |
|---|---:|---:|
| 仅 P0 | ~32 | ~4 |
| P0 + P1 | ~52 | ~6.5 |
| P0 + P1 + P2 | ~58 | ~7.5 |

日历周期（1 开发 + 设计可并行）：**约 5～8 个工作日**（不含审核排队）。

### 5.2 OfferVas 明细工时

| 优先级 | 工作项 | 角色 | 人时 | 说明 |
|---|---|---|---:|---|
| P0 | 未登录：创建账户 → 公开注册路径 | 开发 | 8 | 若注册页已有，主要是入口与文案 |
| P0 | Banner 独立素材与文案 | 设计 | 8 | 勿与 ChipBase 共用换色图 |
| P0 | Banner 接入 + 橙色主题确认 | 开发 | 4 | 主题若已具备则更少 |
| P0 | 首页扫卡消费者向文案 | 开发 | 2 | |
| P0 | About 定位声明 | 开发/内容 | 2 | |
| P0 | 注销账户可用（自测删号链路） | 开发+测试 | 8 | 若已有入口则约 4；没有则含接口联调 |
| P1 | 首页获卡引导或优惠模块 | 开发+设计 | 16 | 开发 12 + 设计 4 |
| P1 | 设置：客服/帮助/反馈文案与配置 | 后台/开发 | 4 | |
| P2 | 扫卡形态差异、独立图标风格 | 设计+开发 | 8 | 可选 |
| — | 自测 + 回归 | 测试 | 8 | |
| — | 提审材料：截图、Review Notes、元数据 | 开发/产品 | 4 | |

**OfferVas 小计**

| 范围 | 人时 | 约人日 |
|---|---:|---:|
| 仅 P0 | ~44 | ~5.5 |
| P0 + P1 | ~64 | ~8 |
| P0 + P1 + P2 | ~72 | ~9 |

日历周期：**约 6～10 个工作日**（不含审核排队；且须等 ChipBase 新版先上架）。

### 5.3 方案一合计（双 App）

| 范围 | ChipBase | OfferVas | 合计人时 | 约人日 | 建议日历周期 |
|---|---:|---:|---:|---:|---|
| 最小可提（两边仅 P0） | 32 | 44 | **76** | **~9.5** | **约 3～4 周**（含先后提审、一次审核缓冲） |
| 推荐（P0+P1） | 52 | 64 | **116** | **~14.5** | **约 4～5 周** |
| 完整（含 P2） | 58 | 72 | **130** | **~16** | **约 5～6 周** |

> 日历周期含：ChipBase 提审等待（通常若干天）→ 上架生效 → 再提 OfferVas。审核排队不计入人时，但计入日历。

### 5.4 优先级对照（便于排期）

**P0 · 必须做**

| App | 项 | 类型 | 人时约 |
|---|---|---|---:|
| ChipBase | 未登录：员工登录 + 收掉公开注册 | 发版 | 8 |
| ChipBase | 首页：扫卡文案改为员工卡 | 发版 | 2 |
| ChipBase | About 定位声明 | 发版/内容 | 2 |
| ChipBase | 消息模板去消费化 | 后台 | 4 |
| OfferVas | 未登录：创建账户 → 公开注册 | 发版 | 8 |
| OfferVas | 设置：注销账户可用 | 发版/配置 | 4～8 |
| OfferVas | About 定位声明 | 发版/内容 | 2 |
| 双方 | Banner 文案与素材不共用换色图 | 设计 | 16 |

**P1 · 强烈建议**

| App | 项 | 人时约 |
|---|---|---:|
| ChipBase | 设置增加「IT 支持」；Quick start → 内部使用指南 | 4 |
| ChipBase | 头像区「员工账户」标签 | 4 |
| OfferVas | 首页增加获卡引导或优惠模块 | 16 |
| OfferVas | 设置支持区改为客服/帮助/反馈 | 4 |
| 双方 | 首页多一块对方没有的模块 | 含在上表 P1 |

**P2 · 锦上添花（约 6～8 人时）**

- 扫卡区形态差异（方块 vs 圆钮/宽按钮）  
- 设置图标风格分两套  
- 消息中心「Manager」→「Edit」  

---

## 6. 实施顺序

### 阶段一：先更新 ChipBase

1. 未登录页改成员工专属入口并关闭公开注册  
2. 首页扫卡文案改成员工卡，更新独立 Banner  
3. About 与设置页加入员工定位、IT 支持  
4. 后台消息模板改成内部服务类内容  
5. 提审并确认新版本已在 App Store 生效  

### 阶段二：再提交 OfferVas

1. 完成公开注册流程及消费者向未登录页  
2. 首页增加获卡引导或优惠等独立模块  
3. 设置页配置客服、协议、隐私与可用的注销账户  
4. 确认橙色主题、独立 Banner 和 Release 截图  
5. 附 Review Notes 提审  

---

## 7. OfferVas Review Notes 英文模板

提审 OfferVas 时粘贴到 App Review Information → Notes：

```text
Product Positioning Clarification

ChipBase, our existing application, is exclusively intended for our
company's internal employees. ChipBase accounts are provisioned and
managed internally, and public self-registration is not available.
Its onboarding and sign-in screens clearly identify it as an
employee-only service (e.g. "Employee Sign In", "Scan your employee card").

OfferVas is a separate consumer-facing product intended for the
general public. Users can independently create an OfferVas account
through its public registration flow. OfferVas has its own branding,
consumer onboarding, support channels, and product positioning
(e.g. "Create OfferVas Account", consumer offers / get-a-card guidance).

Therefore, ChipBase and OfferVas serve different audiences and use
different account provisioning models:

- ChipBase: internal employees, company-provisioned accounts
- OfferVas: public consumers, open self-registration

OfferVas is not intended to be a duplicate or re-skinned version of
ChipBase.
```

---

## 8. 风险说明（务必知晓）

1. **只换橙色主题 + Banner 文案**：4.3 风险仍然很高。  
2. ChipBase 未登录仍是公开注册 UI 时提交 OfferVas：两边会被当成同款。  
3. ChipBase 消息中心仍推「会员等级 / 任务奖励」：与「员工内部」叙事冲突。  
4. OfferVas 开放注册但无可用「注销账户」：可能直接因 **5.1.1(v)** 被拒（与 4.3 无关）。  
5. 差异做完也不能 100% 保证过审，但比「换皮双包」通过概率高得多。  

---

## 9. 双 App 上架检查清单

### ChipBase

- [ ] 未登录主按钮 = 员工登录  
- [ ] 无公开注册入口  
- [ ] Banner 含员工专属叙事  
- [ ] 首页扫卡 = 扫描员工卡  
- [ ] （建议）公司公告或 IT 入口  
- [ ] 消息模板已内部化  
- [ ] 设置含 IT 支持 / 内部指南  
- [ ] About 含员工专属声明  
- [ ] 新版本已上架 App Store  

### OfferVas

- [ ] 未登录主按钮 = 创建账户 → 公开注册  
- [ ] Banner 为消费者叙事（无员工话术）  
- [ ] 首页扫卡文案差异化  
- [ ] （建议）获卡引导或优惠模块  
- [ ] 设置：客服/帮助 + 协议隐私  
- [ ] **注销账户可用**  
- [ ] About 含公众产品声明  
- [ ] Review Notes 已填写  
- [ ] 提审截图为 Release（无 DEBUG）  

---

# 方案二：单 App 分渠道

> 适用场景：公司不要求 ChipBase 与 OfferVas 同时作为两个公开 App 在 App Store 搜索下载。  
> 核心目标：公开 App Store 只保留一个对外产品，内部员工通过企业分发或同一 App 的员工入口使用服务，从根源降低双包 4.3 风险。

## 1. 方案说明

「单 App 分渠道」是指使用**同一套代码和业务内核**，通过分发方式、账号身份、构建参数或远程配置区分：

- 内部员工：ChipBase 品牌、蓝色主题、员工账号、公司统一开通
- 外部客群：OfferVas 品牌、橙色主题、公开注册、消费者服务

公开 App Store 原则上只保留 **OfferVas**（或一个统一品牌），不再提交第二个高度相似的公版包。

## 2. 方式一：公版只留 OfferVas + ChipBase 企业/自定义分发（最推荐）

| 项 | 做法 |
|---|---|
| OfferVas | 继续（或新建）公版 App Store 上架，面向外部客群，开放注册 |
| ChipBase | **不再作为第二个公版 App 提审**；改为企业分发 |
| iOS 内部安装方式 | **Apple Business Manager（ABM）Custom App**，或已有的 **Apple Developer Enterprise Program** 企业签（若公司已具备） |
| 用户获取 | 员工由 IT / HR 下发链接或 MDM 推送；外部用户在 App Store 搜 OfferVas |
| 4.3 | 公版商店只有一个相关产品，**几乎不触发双包 4.3** |

注意：

- Custom App 需公司开通 Apple Business Manager，并把 App 指定给组织。  
- Enterprise 分发有合规与证书管理成本，需法务/IT 确认是否已具备资格。  
- 若 ChipBase **已经在公版上架**：可规划「对外主推 OfferVas + ChipBase 逐步下架公版 / 转为 Custom App」，过渡期仍建议把 ChipBase 改成明显员工向，避免过渡期双包撞车。

## 3. 方式二：公版只留一个 App，应用内区分渠道（账号 / 邀请码 / 组织）

商店只上架 **一个** App（建议对外品牌 OfferVas，或统一新品牌名）。用户进入后按身份走不同体验：

| 渠道信号 | 内部员工 | 外部客群 |
|---|---|---|
| 入口 | 邀请码 / 员工登录 Tab / 深链 `?channel=employee` | 默认「创建账户」 |
| 主题 | 进内部模式后切蓝色 + ChipBase 文案 | 默认橙色 + OfferVas 文案 |
| 注册 | 不开放，仅邀请开通 | 开放自助注册 |
| 首页/设置 | 员工卡、IT 支持、公司公告 | 获卡引导、优惠、在线客服 |
| 配置来源 | 登录后账号类型 / 组织 ID 下发 | 默认消费者配置 |

优点：一次提审、无 4.3 双包问题、功能共用。  
缺点：商店只有一个品牌名；内部品牌 ChipBase 无法单独挂商店图标（可用应用内切换显示名/主题弥补）。

## 4. 方式三：构建时 Flavor / Scheme 分渠道（适合 Android 多渠道；iOS 慎用双 Bundle）

工程上常见（你们仓库已有类似 flavor 思路）：

| 平台 | 做法 |
|---|---|
| Android | `productFlavors`（如 `chipbase` / `offervas`）：不同 `applicationId`、应用名、主题色、默认文案，可分别上架应用商店 |
| iOS | 不同 `SCHEME` / `xcconfig` 注入 `CHANNEL`、主题、文案；**但若产出两个 Bundle ID 都上公版 App Store，仍会按“双 App 公版上架”审核，4.3 风险不变** |

因此：

- **Android**：双渠道包分发到不同商店/企业商店，相对灵活。  
- **iOS**：**不要**指望「两个 Flavor 打两个 Bundle 都上 App Store」来规避 4.3；iOS 上 Flavor 应服务于「打企业包 vs 打公版包」，而不是「公版挂俩」。

建议的构建矩阵：

| 构建产物 | Bundle / 包名 | 分发 | 默认渠道配置 |
|---|---|---|---|
| OfferVas Release | `com.xxx.offervas`（示例） | App Store 公版 | `channel=consumer`，开放注册，橙主题 |
| ChipBase Internal | `com.cardbase.app` 或企业 Bundle | ABM Custom / Enterprise / 内测 | `channel=employee`，关闭注册，蓝主题 |

同一仓库、同一套业务代码；差异收敛到：

- 编译期：`CHANNEL`、`APP_DISPLAY_NAME`、主题色、默认 Banner  
- 运行时：远程配置（设置菜单、消息模板、功能开关）  
- 账号体系：员工开通 vs 公开注册（后端按渠道校验）

## 5. 辅助手段：深链 / 下载渠道参数（辅助）

用于运营归因与默认皮肤，**不能单独解决双包 4.3**：

- 安装后首次启动读取 `channel`（剪贴板、Universal Link、安装来源）  
- 设置默认主题与文案  
- 仍建议公版只保留一个 App；渠道参数用于「同一 App 内」切换体验

## 6. 现有 ChipBase 公版的迁移建议

1. **短期**：先把 ChipBase 改成明显的「员工专属」产品，降低与后续 OfferVas 撞车概率。  
2. **中期**：OfferVas 公版上架稳定后，将 ChipBase 迁到 ABM Custom App / 企业分发。  
3. **长期**：公版商店仅保留 OfferVas（或统一品牌）；ChipBase 名称仅用于内部包显示名。

## 7. Flutter 工程落地要点

| 层级 | 建议 |
|---|---|
| 编译配置 | `--dart-define=CHANNEL=employee\|consumer` 或 flavor；注入主题色、App 名、默认 API 租户 |
| UI | 未登录主 CTA、扫卡文案、设置菜单由 `ChannelConfig` 驱动，避免复制两套页面 |
| 后台 | 设置项、Banner、消息模板按 `channel` / `orgId` 下发（你们已有动态配置，优先复用） |
| 账号 | 后端校验：employee 渠道拒绝公开注册；consumer 渠道允许注册并支持删号 |
| iOS 签名 | 公版用 App Store 证书；内部包用 Enterprise 或 Custom App 流程，**不要**再提第二个公版审核做换皮 |

## 8. 工时估算

> 口径同方案一：1 人日 = 8 人时；含开发/联调/自测。  
> **不含**：ABM 开通等待、企业账号审批、MDM 采购、Apple 审核排队。  
> 三种方式可只选一种落地；下表按「选定该方式后做到可上线」估算。

### 8.1 方式一：OfferVas 公版 + ChipBase 企业/Custom 分发

| 工作项 | 角色 | 人时 | 说明 |
|---|---|---:|---|
| IT/法务确认 ABM 或 Enterprise 资格与流程 | IT/产品 | 8～16 | 外部依赖大，按是否已有账号浮动 |
| OfferVas 公版包：消费者主题、开放注册、注销账户、About | 开发+设计 | 40～56 | 接近方案一 OfferVas 的 P0+部分 P1 |
| ChipBase 内部包：员工主题、关闭注册、CHANNEL=employee | 开发 | 16～24 | 复用同一工程改配置/少量 UI |
| iOS 签名与分发流水线（公版 vs 内部包） | 开发/运维 | 16～24 | Export、证书、CI 分支 |
| ABM Custom App 或企业分发配置、测试安装 | IT+开发 | 16～24 | 含试发、安装验证 |
| 若 ChipBase 仍在公版：过渡期员工向小改 + 后续下架/迁移 | 开发+产品 | 16～32 | 可选但常见 |
| 测试回归（两套安装路径） | 测试 | 16 | |
| OfferVas 提审材料 | 产品/开发 | 4 | |

| 范围 | 人时合计 | 约人日 | 建议日历周期 |
|---|---:|---:|---|
| 已有 ABM/Enterprise，最小可上线 | **约 116～160** | **约 14.5～20** | **约 3～5 周** |
| 从零开通 ABM + 含公版过渡下架 | **约 160～220** | **约 20～27.5** | **约 5～8 周**（含账号开通等待） |

### 8.2 方式二：商店只留一个 App，应用内区分渠道

| 工作项 | 角色 | 人时 | 说明 |
|---|---|---:|---|
| `ChannelConfig` / 账号类型驱动主题与文案 | 开发 | 24～32 | 未登录 CTA、扫卡、设置菜单 |
| 员工入口（邀请码 / 员工登录 Tab / 深链） | 开发 | 16～24 | |
| 后端：按账号/组织下发渠道配置；禁员工公开注册 | 后端 | 16～24 | |
| 消费者默认路径：注册、客服、注销账户 | 开发 | 16～24 | 若已有则取低值 |
| Banner/文案两套素材 | 设计 | 12～16 | |
| 联调 + 回归（两种身份） | 测试 | 16 | |
| 单次公版提审材料 | 产品/开发 | 4 | |

| 范围 | 人时合计 | 约人日 | 建议日历周期 |
|---|---:|---:|---|
| 配置与账号体系较成熟 | **约 104～140** | **约 13～17.5** | **约 3～4 周** |
| 从零做邀请码 + 后端渠道 | **约 140～180** | **约 17.5～22.5** | **约 4～6 周** |

### 8.3 方式三：构建 Flavor / Scheme（公版一份 + 内部一份）

> 注意：此处工时指「打出公版包 + 内部包」；**不是**两个都提公版商店。

| 工作项 | 角色 | 人时 | 说明 |
|---|---|---:|---|
| Flutter/Android flavor + iOS scheme/xcconfig + dart-define | 开发 | 24～40 | 视现有 flavor 成熟度 |
| 两套显示名、图标、主题默认值 | 开发+设计 | 16～24 | |
| CI：两套 archive / 签名产物 | 开发 | 16～24 | |
| 渠道默认文案与注册开关 | 开发 | 8～16 | |
| 内部包分发对接（同方式一后半段） | IT+开发 | 16～24 | |
| 测试两套包 | 测试 | 12～16 | |

| 范围 | 人时合计 | 约人日 | 建议日历周期 |
|---|---:|---:|---|
| 工程已有多 flavor 基础 | **约 92～128** | **约 11.5～16** | **约 3～4 周** |
| 从零搭 flavor + 分发 | **约 128～176** | **约 16～22** | **约 4～6 周** |

### 8.4 辅助手段（深链 / 渠道参数）

单独做归因用深链：**约 8～16 人时**。不能替代上面任一主方式。

### 8.5 方案二三种方式对照（便于选型）

| 方式 | 约人时 | 约人日 | 日历周期 | 4.3 风险 | 前提 |
|---|---:|---:|---|---|---|
| 方式一：公版 + 企业/Custom | 116～220 | 14.5～27.5 | 3～8 周 | 最低 | 需 IT 支持 ABM/Enterprise |
| 方式二：应用内渠道 | 104～180 | 13～22.5 | 3～6 周 | 低 | 商店只挂一个品牌 |
| 方式三：Flavor 双产物 | 92～176 | 11.5～22 | 3～6 周 | 低（仅一公版） | 内部包不提公版审核 |

> **选型建议**：有企业分发能力 → 优先方式一；没有、且可接受单商店品牌 → 方式二；工程已强依赖 flavor → 方式三并坚持内部包不走公版。

---

## 9. 单 App 分渠道检查清单

- [ ] 确认内部安装是否可用 ABM / MDM / Enterprise（IT 拍板）  
- [ ] 公版商店最终只保留一个对外 App（OfferVas）  
- [ ] 代码用 CHANNEL / 远程配置区分主题与文案，而不是维护两套无关工程  
- [ ] 员工渠道关闭公开注册；消费者渠道开放注册 + 注销账户  
- [ ] 若 ChipBase 仍短暂留在公版：先完成员工向改造，再提 OfferVas  
- [ ] Android 可多 flavor 分发；iOS 公版避免双 Bundle  

---

## 10. 推荐实施顺序

1. 由 IT 确认内部安装方式：ABM Custom App、MDM 或 Enterprise  
2. 确定公版品牌（建议 OfferVas），公开 App Store 最终只保留该 App  
3. 工程增加 `CHANNEL=employee|consumer` 与统一的 `ChannelConfig`  
4. 将主题、Banner、按钮文案、注册策略、设置菜单改为渠道配置驱动  
5. 后端按账号类型或组织 ID 下发渠道配置，并禁止员工渠道公开注册  
6. OfferVas 走正常 App Store 审核；ChipBase 内部包走选定的企业/自定义分发流程  
7. 若旧 ChipBase 暂时仍在公版，完成员工向过渡版本后再安排下架或迁移  

## 11. 风险与限制

1. ABM Custom App 需要 Apple Business Manager 组织与分发配置。  
2. Enterprise 分发仅适用于符合 Apple 企业计划资格的组织，不能用于对外公众分发。  
3. iOS 使用两个 Flavor 生成两个 Bundle ID 并都提交公开 App Store，仍然是双 App，不属于本方案。  
4. 应用内渠道切换必须由可信账号身份或后端配置决定，不能只依赖用户可修改的本地参数。  
5. OfferVas 开放注册时仍必须提供可用的应用内注销账户功能。  

---

*文档版本：2026-07-17 · 两个备选方案已分开说明，并含各自工时估算；基于 ChipBase 首页、消息中心和设置页现状整理。*
