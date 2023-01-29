use flutter_rust_bridge::handler::{DefaultHandler, ReportDartErrorHandler, ThreadPoolExecutor};
use lazy_static::lazy_static;
use std::thread;

pub fn add_three(before: i32) -> i32 {
    println!("{:?}", thread::current().id());
    return before + 3;
}

lazy_static! {
    pub static ref FLUTTER_RUST_BRIDGE_HANDLER: DefaultHandler = DefaultHandler::new(
        ThreadPoolExecutor::new(ReportDartErrorHandler {}),
        ReportDartErrorHandler {}
    );
}
