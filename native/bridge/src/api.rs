use std::thread;

pub fn add_three(before: i32) -> i32 {
    println!("{:?}", thread::current().id());
    return before + 3;
}
