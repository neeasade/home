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
        let stw = b.starts_with("*");
        let enw = b.ends_with("*");

        if stw && enw {
            ret = path.contains(i);
        } else if enw {
            ret = path.starts_with(i);
        } else if stw {
            ret = path.ends_with(i);
        } else {
            ret = path == b;
        }
    }

    ret
}

fn walk(path: &str, fp: &str, to_blacklist: bool, to_quote: bool) {
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

        if to_blacklist  &&
          is_in_blacklist(&p.get(fp.len()+1..).unwrap()) {
            continue;
        }

        if is_dir(&p) {
            walk(p, fp, to_blacklist, to_quote);
        } else {
            p = p.get(fp.len()+1..)
                 .unwrap();

            if to_quote && p.contains(" ") {
                println!("\"{}\"", p);
            } else {
                println!("{}", p);
            }
        }
    }
}

fn main() {
    let argv: Vec<String> = args().collect();
    let mut n = 1;
    let mut to_blacklist = true;
    let mut to_quote = false;
    let mut path = ".";

    if argv.len() > 1 {
        while n != argv.len() {
            match argv[n].as_str() {
                "-q" => { to_quote = true; }
                "-b" => { to_blacklist = false; }
                _    => { path = argv[n].as_str(); }
            }

            n += 1;
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
         to_blacklist,
         to_quote,
        );
}
