using PackedStructs
using Documenter

DocMeta.setdocmeta!(PackedStructs, :DocTestSetup, :(using PackedStructs); recursive=true)

makedocs(;
    modules=[PackedStructs],
    authors="Robert Rudolph",
    repo="https://github.com/rryi/PackedStructs.jl/blob/{commit}{path}#{line}",
    sitename="PackedStructs.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://rryi.github.io/PackedStructs.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/rryi/PackedStructs.jl",
)
