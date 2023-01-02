use oidn;

pub fn multiply_two(original: i32) -> i32 {
    let _device = oidn::Device::new();
    return original * 2;
}
