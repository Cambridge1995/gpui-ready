# gpui-ready

一个用于快速创建 Rust + GPUI Kit Windows/macOS 桌面应用的当前工作模板，复刻自 maloo 的基础工程。

## 已包含

- Rust 2024 与 Cargo 依赖锁定。
- `gpui-kit 0.9.0` 单一框架依赖。
- 官方 `TitleBar` 自定义标题栏。
- 日夜主题与对应 SVG Logo 自动切换。
- 纯图标主题按钮及 Windows 标题栏事件隔离。
- 内嵌 SVG 资源和 Windows `.ico` 程序图标。
- `main.rs` 仅负责启动，界面与资源分别位于 `app.rs`、`assets.rs`。

模板不携带 `target` 构建产物，也不携带 maloo 的产品计划书或架构书。

## 一键创建项目

### CMD

在模板目录执行：

```bat
new-project.cmd MyApp
```

也可以双击 `new-project.cmd`，再输入项目名。

### PowerShell

```powershell
.\new-project.ps1 -Name MyApp
```

指定创建位置：

```powershell
.\new-project.ps1 -Name MyApp -Destination D:\Projects
```

只创建文件、不立即构建：

```powershell
.\new-project.ps1 -Name MyApp -NoBuild
```

脚本会复制模板、修改名称，并默认执行 `cargo fmt` 和 `cargo build`。它不会覆盖已有目录。

## 名称转换

| 输入 | Cargo 包名 | App 结构体 | 窗口标题 |
|---|---|---|---|
| `MyApp` | `my_app` | `MyApp` | `MyApp` |
| `asset-box` | `asset_box` | `AssetBoxApp` | `AssetBox` |
| `PhotoLibrary` | `photo_library` | `PhotoLibraryApp` | `PhotoLibrary` |

名称已经以 `App` 结尾时，结构体不会重复追加 `App`。

## 目录职责

```text
src/
├── main.rs    # 只声明模块并创建应用窗口
├── app.rs     # 应用结构体、界面、主题和交互
└── assets.rs  # 内嵌资源、AssetSource 和默认资源回退

icons/              # 日与夜 SVG、PNG、ICO
build.rs            # Windows 构建期间调用资源编译器
gpui_ready.rc     # 将 icons/logo-day.ico 嵌入模板程序
```

`main.rs` 不应承担界面、业务或资源加载逻辑。新功能优先按能力创建模块，不要持续向启动入口添加代码。

## 替换品牌资源

- 日间彩色 Logo：`icons/logo-day.svg`。
- 夜间彩色 Logo：`icons/logo-night.svg`。
- Windows 程序图标：`icons/logo-day.ico`。
- PNG 用于安装器、文档或其他系统资源。

替换图标后运行 `cargo build`。如果资源内容改变但构建未触发，可执行 `cargo clean` 后重新构建；日常修改不需要清理。

## 开发前检查

```bat
rustc --version
cargo --version
cmake --version
cargo build
cargo clippy -- -D warnings
cargo run
```

Windows 使用 MSVC Rust 工具链，并安装 Visual Studio 2022 的“使用 C++ 的桌面开发”工作负载及 Windows SDK。

面向 AI 助手的复刻规则和项目名修改清单位于 [AGENTS.md](AGENTS.md)。
