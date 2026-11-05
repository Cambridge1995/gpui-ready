use gpui_kit::assets::Assets as ComponentAssets;
use gpui_kit::*;
use rust_embed::RustEmbed;
use std::borrow::Cow;

#[derive(RustEmbed)]
#[folder = "./icons"]
#[include = "*.svg"]
struct AppFiles;

pub(crate) struct AppAssets;

impl AssetSource for AppAssets {
    fn load(&self, path: &str) -> Result<Option<Cow<'static, [u8]>>> {
        if let Some(file) = AppFiles::get(path) {
            return Ok(Some(file.data));
        }
        ComponentAssets.load(path)
    }

    fn list(&self, path: &str) -> Result<Vec<SharedString>> {
        let mut paths = ComponentAssets.list(path)?;
        paths.extend(
            AppFiles::iter().filter_map(|file| file.starts_with(path).then(|| file.into())),
        );
        paths.sort();
        paths.dedup();
        Ok(paths)
    }
}
