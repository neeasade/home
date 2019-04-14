use std::io::{stdin, BufRead};
use std::process::exit;

fn isnum(string: &String) -> bool {
    let nch: Vec<_> = string.as_str()
                            .matches(char::is_numeric)
                            .collect();
    nch.len() != 0
}

fn main() {
    let stdin     = stdin();
    let geostring = stdin.lock()
                         .lines()
                         .next()
                         .unwrap()
                         .unwrap();

    let mut geostring = String::from(geostring);

    /* ignore = if present */
    if geostring.get(0..1).unwrap() == "=" {
        geostring = geostring.get(1..)
                             .unwrap()
                             .to_string();
    }

    /* check if there's numbers in the string */
    if !isnum(&geostring) {
        eprintln!("not a valid string!");
        exit(1);
    }

    let whxy: Vec<&str> = geostring.split("+")
                                   .collect();

    let wh: Vec<&str> = whxy.get(0)
                            .unwrap_or_else(|| {
                                eprintln!("invalid string");
                                exit(1);
                            })
                            .split("x")
                            .collect();

    println!(
             "{} {} {} {}",
             whxy.get(1).unwrap(),
             whxy.get(2).unwrap(),
             wh.get(0).unwrap(),
             wh.get(1).unwrap()
            );
}
