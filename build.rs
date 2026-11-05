#[cfg(windows)]
fn main() {
    embed_resource::compile("gpui_ready.rc", embed_resource::NONE)
        .manifest_optional()
        .expect("无法嵌入 Windows 应用图标");
}

#[cfg(not(windows))]
fn main() {}
