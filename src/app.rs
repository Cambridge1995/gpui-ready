use gpui_kit::base::StyledExt;
use gpui_kit::component::{
    ActiveTheme, IconName, Sizable as _, Theme, ThemeMode, TitleBar,
    button::{Button, ButtonVariants as _},
};
use gpui_kit::*;

pub(crate) struct GpuiReadyApp;

impl GpuiReadyApp {
    fn toggle_theme(cx: &mut App) {
        let mode = match cx.theme().mode {
            ThemeMode::Dark => ThemeMode::Light,
            _ => ThemeMode::Dark,
        };
        Theme::change(mode, None, cx);
    }
}

impl Render for GpuiReadyApp {
    fn render(&mut self, _: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let is_dark = cx.theme().mode == ThemeMode::Dark;
        let logo = if is_dark {
            "logo-night.svg"
        } else {
            "logo-day.svg"
        };
        let toggle_tooltip = if is_dark {
            "切换到日间模式"
        } else {
            "切换到夜间模式"
        };
        let toggle_icon = if is_dark {
            IconName::Sun
        } else {
            IconName::Moon
        };

        div()
            .flex()
            .flex_col()
            .size_full()
            .bg(cx.theme().background)
            .text_color(cx.theme().foreground)
            .child(
                TitleBar::new()
                    .bg(cx.theme().sidebar)
                    .border_b_1()
                    .border_color(cx.theme().border)
                    .child(
                        div()
                            .flex()
                            .items_center()
                            .gap_2()
                            .child(img(logo).size(rems(1.25)))
                            .child(
                                div()
                                    .font_family("Segoe UI Variable Text")
                                    .font_medium()
                                    .text_sm()
                                    .child("GpuiReady"),
                            ),
                    )
                    .child(
                        div()
                            .on_mouse_down(MouseButton::Left, |_, _, cx| {
                                cx.stop_propagation();
                            })
                            .child(
                                Button::new("toggle-theme")
                                    .ghost()
                                    .small()
                                    .icon(toggle_icon)
                                    .accessibility_label(toggle_tooltip)
                                    .tooltip(toggle_tooltip)
                                    .on_click(|_, _, cx| Self::toggle_theme(cx)),
                            ),
                    ),
            )
            .child(
                div()
                    .flex()
                    .flex_1()
                    .flex_col()
                    .items_center()
                    .justify_center()
                    .gap_3()
                    .child("便携数字资产管理器")
                    .child(
                        div()
                            .text_sm()
                            .text_color(cx.theme().muted_foreground)
                            .child("图标与界面会随主题自动切换"),
                    ),
            )
    }
}
