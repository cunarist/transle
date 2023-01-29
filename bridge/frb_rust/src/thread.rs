pub const WORKERS_COUNT: usize = 1;

#[cfg(not(wasm))]
mod io {
    use super::*;
    use lazy_static::lazy_static;
    use parking_lot::Mutex;
    use threadpool::ThreadPool;

    lazy_static! {
        pub static ref THREAD_POOL: Mutex<ThreadPool> = Mutex::new(ThreadPool::with_name(
            "frb_workerpool".into(),
            WORKERS_COUNT
        ));
    }
}

#[cfg(not(wasm))]
pub use io::THREAD_POOL;

#[cfg(wasm)]
mod web {
    use crate::{script_path, wasm_bindgen_src::pool::WorkerPool};

    use super::*;

    thread_local! {
        pub static WORKER_POOL: Option<WorkerPool> = WorkerPool::new(WORKERS_COUNT, script_path().unwrap())
                .map_err(|err| crate::console_error!("Failed to spawn worker: {:?}", err)).ok()
    }
}

#[cfg(wasm)]
pub use web::WORKER_POOL;
