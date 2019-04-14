use std::{fs::{read_dir, canonicalize}, path::Path, env::args};

fn walk(path: &str, fp: &str) {
    /* helper closurers */
    let is_dir = |path: &str| {
        let p = Path::new(path);

        p.is_dir()
    };

    for p in read_dir(&path).unwrap() {
        let p = p.unwrap()
                 .path()
                 .into_os_string();

        let mut p = p.to_str()
                 .unwrap();

        if is_dir(&p) {
            walk(p, fp);
        } else {
            p = p.get(fp.len()+1..)
                 .unwrap();

            println!("{}", p);
        }
    }
}

fn main() {
    let a: Vec<String> = args().collect();
    let mut path = ".";
    if a.len() > 1 {
        path = a[1].as_str();
    }

    let p = canonicalize(&path)
                            .unwrap_or_else(|e| {
                                eprintln!("error: {}", e);
                                std::process::exit(1);
                            });

    walk(
         p.to_str().unwrap(),
         p.to_str().unwrap()
        );
}
