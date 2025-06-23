#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
    // setup_backtrace();
    // setup_log_to_console();
}

// fn setup_backtrace() {
//     #[cfg(not(target_family = "wasm"))]
//     if std::env::var("RUST_BACKTRACE").err() == Some(std::env::VarError::NotPresent) {
//         std::env::set_var("RUST_BACKTRACE", "1");
//     } else {
//         log::debug!("Skip setup RUST_BACKTRACE because there is already environment variable");
//     }

//     PanicBacktrace::setup();
// }

// fn setup_log_to_console() {
//     #[cfg(target_os = "android")]
//     let _ = android_logger::init_once(
//         android_logger::Config::default().with_max_level(log::LevelFilter::Info),
//     );

//     #[cfg(any(target_os = "ios", target_os = "macos"))]
//     let _ = oslog::OsLogger::new("frb_user")
//         .level_filter(log::LevelFilter::Info)
//         .init();

//     #[cfg(target_family = "wasm")]
//     let _ = crate::misc::web_utils::WebConsoleLogger::init();
// }
