(lang dune 3.10)

(name Tiger)

(generate_opam_files true)

(source
 (github IgorErin/Tiger))

(authors "Igor Erin")

(maintainers "Igor Erin")

(license MIT)

(package
 (name Tiger)
 (synopsis "Tiger compiler")
 (depends ocaml dune core angstrom ppx_deriving))