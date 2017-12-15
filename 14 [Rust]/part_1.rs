
fn knot_hash(input: &str) -> String {
    let mut length_list = input.as_bytes().to_vec();
    length_list.append(&mut vec![17, 31, 73, 47, 23]);
    let mut current_pos = 0;
    let mut skip_size: i32 = 0;
    let mut index_offset: i32 = 0;
    let mut list: Vec<usize> = (0..256).collect();

    for _t in 0..64 {
        for length_ptr in &length_list {
            let length = *length_ptr as usize;
            let mut sublist = list.split_off(length);
            list.reverse();
            list.append(&mut sublist);
            let offset: i32 = (skip_size + length as i32) % (list.len() as i32);
            sublist = list.split_off(offset as usize);
            sublist.append(&mut list);
            list = sublist;
            skip_size += 1;
            index_offset = (index_offset + 256 - offset) % 256;
            current_pos = (current_pos + 1) % (list.len() as usize);
        }
    }

    let mut sublist = list.split_off((index_offset % 256) as usize);
    sublist.append(&mut list);
    list = sublist;

    let mut result = Vec::new();
    for _i in 0..16 {
        let tail = list.split_off(16);
        let xored = list.iter().fold(0, |acc, x| acc ^ x);
        result.push(format!("{:02x}", xored));
        list = tail;
    };
    
    return result.join("");
}

fn main() {
    print!("{}\n", knot_hash(""));
    print!("{}\n", knot_hash("AoC 2017"));
    print!("{}\n", knot_hash("1,2,3"));
}