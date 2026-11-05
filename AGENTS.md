# GPUI 模板项目指引

开始修改本项目前，先阅读 [README.md](README.md)，了解一键创建命令、目录职责和品牌资源。

## 创建新项目

优先使用 `new-project.ps1` 或 `new-project.cmd`，不要只替换标题而遗漏 Cargo 包名、应用结构体、构建脚本和 RC 文件名。

一键脚本负责处理：

1. `Cargo.toml` 中的 `package.name`。
2. `Cargo.lock` 中当前项目的包名。
3. `src/main.rs` 中的应用结构体引用、窗口标题和错误文本。
4. `src/app.rs` 中的 `MalooApp` 定义、实现及标题栏软件名。
5. `build.rs` 中的 RC 文件名。
6. 根目录 `gpui_ready.rc` 的文件名。
7. 新项目所在目录名称。

RC 文件中的图标路径保持为 `icons/logo-day.ico`，因为图标文件名与项目名无关。

## 修改规则

- `main.rs` 只作为启动入口；界面放入 `app.rs`，资源加载放入 `assets.rs`。
- 新功能按能力建立模块，不向启动入口堆积业务代码。
- 修改界面前加载 `gpui-kit` 与 `gpui-kit-design-guides` Skills。
- 以当前 GPUI Kit 源码和官方文档为准，不根据旧 GPUI 示例猜测 API。
- 不单独添加 GPUI、GPUI Base 或 GPUI Component 依赖，应用只依赖 `gpui-kit`。
- 替换品牌资源时同时检查日间、夜间和 Windows 图标。
- 修改模板后实际创建一个新项目并构建，不得只检查模板本身。
