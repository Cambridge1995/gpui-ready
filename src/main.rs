mod app;
mod assets;

use app::GpuiReadyApp;
use assets::AppAssets;
use gpui_kit::component::TitleBar;
use gpui_kit::*;

fn main() {
    application().with_assets(AppAssets).run(|cx| {
        init(cx);

        open_window(TitleBar::window_options(), cx, |window, cx| {
            window.set_window_title("GpuiReady");
            cx.new(|_| GpuiReadyApp)
        })
        .expect("无法创建 gpui_ready 窗口");
    });
}
