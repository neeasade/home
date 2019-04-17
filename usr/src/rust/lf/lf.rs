use std::{fs::{read_dir, canonicalize}, path::Path, env::args};

fn is_in_blacklist(path: &str) -> bool {
    let path = path.to_string();
    let mut ret = false;
    let blacklist: [&str; 8] = [
                                "*.git*", "*cache*", "*Cache*", "*wallpapers*",
                                "*lib*", "opt*", "*target*", "tmp*"
                               ];
    for b in blacklist.iter() {
        if ret { break; }

        let i = b.replacen("*", "", 2);
        let i = i.as_str();

        if b.starts_with("*") && b.ends_with("*") {
            ret = path.contains(i);
        } else if b.ends_with("*") {
            ret = path.starts_with(i);
        } else if b.starts_with("*") {
            ret = path.ends_with(i);
        }
    }

    ret
}

fn walk(path: &str, fp: &str, check_blacklist: bool) {
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

        if is_in_blacklist(&p.get(fp.len()+1..).unwrap())
            && check_blacklist {
            continue;
        }

        if is_dir(&p) {
            walk(p, fp, check_blacklist);
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
    let mut check_blacklist = true;

    if a.len() > 1 {
        path = a[1].as_str();
        if a.len() > 3 && a[2].as_str() == "-B" {
            check_blacklist = false;
        }
    }

    let p = canonicalize(&path)
                            .unwrap_or_else(|e| {
                                eprintln!("error: {}", e);
                                std::process::exit(1);
                            });

    walk(
         p.to_str().unwrap(),
         p.to_str().unwrap(),
         check_blacklist
        );
}
