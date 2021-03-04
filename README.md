# PackedStructs.jl

Julia struct-s packed at bit boundaries into a primitive type.

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://rryi.github.io/PackedStructs.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://rryi.github.io/PackedStructs.jl/dev)
[![Build Status](https://travis-ci.com/rryi/PackedStructs.jl.svg?branch=master)](https://travis-ci.com/rryi/PackedStructs.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/rryi/PackedStructs.jl?svg=true)](https://ci.appveyor.com/project/rryi/PackedStructs-jl)
[![Build Status](https://api.cirrus-ci.com/github/rryi/PackedStructs.jl.svg)](https://cirrus-ci.com/github/rryi/PackedStructs.jl)
[![Coverage](https://codecov.io/gh/rryi/PackedStructs.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/rryi/PackedStructs.jl)

Packed structs have two use cases in mind: 

 * memory reduction for large tables with fields having very few instances like flags, status info, enumerations. A couple of columns in such tables could be combined into a Vector{PStruct[T}}
 
 * pooling of several method parameters in one PStruct instance, which fits into one machine register variable. This reduces push/pop overheads in method execution and allows to keep more data in registers, improving runtime performance.

 # current state: in development, systematic testing to be done.

 Basic type PStruct is defined, and has working constructors, getters and setters. However actual performance is unsatisfactory. First benchmarks indicate, that the design of bitfields within a machine word variable allows similar performance as conventional struct-s for field access, but current implementation suffers from type reflection overhead. Next develomnent target is to eliminate all reflection overhead at runtime.

