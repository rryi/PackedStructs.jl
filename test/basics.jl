using PackedStructs


S1 = @NamedTuple{ f1::PUInt{1}, f2::Bool,i1::PUInt{6}, i2::PInt{8}, i3::Int8}
S2 = @NamedTuple{ v1::UInt8, v2::UInt8, v3::UInt16, v4::UInt32}


function testbasics()
    T0 = PStruct{S1}
    t0 = reinterpret(PStruct{S1},0x0000000000665544)  
end



NT = @NamedTuple{ f1::Bool, f2:: PUInt{1}, i1::PUInt{6}, i2::PInt{8}, i3::UInt8, i4::Int8, u16::UInt16, i16::Int16}
const PS = PStruct{NT}


struct S 
    f1::Bool
    f2:: UInt8
    i1::UInt8
    i2::Int8
    i3::UInt8
    i4::Int8
    u16::UInt16
    i16::Int16
end

psv = Vector{PS}(undef, 100)

sv =  Vector{S}(undef, 100)
for i in 1:length(psv)
    local ps
    ps = psv[i]
    sv[i] = S(ps.f1,ps.f2,ps.i1,ps.i2,ps.i3,ps.i4,ps.u16,ps.i16)
end


function bench(vec)
    sum = 0
    for ps in vec
        sum += ps.i1+ps.i2+ps.u16+ps.i16
    end
    sum
end



function benchV2(vec::Vector{PS}) where PS <: PStruct
    sum = 0
    for ps in vec
        sum += getpropertyV2(ps, :i1) +getpropertyV2(ps, :i2) +getpropertyV2(ps, :u16) +getpropertyV2(ps, :i16)
    end
    sum
end


# hand-coded for type PS using convert
function getpropertyV3(ps, ::Val{:i1})
    convert(PUInt{6},Val(2),Val(6),reinterpret(UInt64,ps))
end

function getpropertyV3(ps, ::Val{:i2})
    convert(PInt{8},Val(8),Val(8),reinterpret(UInt64,ps))
end

function getpropertyV3(ps, ::Val{:u16})
    convert(UInt16,Val(32),Val(16),reinterpret(UInt64,ps))
end

function getpropertyV3(ps, ::Val{:i16})
    convert(Int16,Val(48),Val(16),reinterpret(UInt64,ps))
end


function benchV3(vec::Vector{PS}) where PS <: PStruct
    sum = 0
    for ps in vec
        sum += getpropertyV3(ps, Val(:i1)) +getpropertyV3(ps, Val(:i2)) +getpropertyV3(ps, Val(:u16)) +getpropertyV3(ps, Val(:i16))
    end
    sum
end




# hand-coded for type PS what is done in the convert call
function getpropertyV4(ps, ::Val{:i1})
    reinterpret(UInt64,ps)>>2 & 0x3F
end

function getpropertyV4(ps, ::Val{:i2})
     ((reinterpret(UInt64,ps)>>8 & 0xFF)%Int64)<<(64-8)>>(64-8)
end

function getpropertyV4(ps, ::Val{:u16})
    reinterpret(UInt64,ps)>>32 & 0xFFFF
end

function getpropertyV4(ps, ::Val{:i16})
    Int16( ((reinterpret(UInt64,ps)>>48 & 0xFFFF)%Int64)<<(64-16)>>(64-16)  )
end

function benchV4(vec::Vector{PS}) where PS <: PStruct
    sum = 0
    for ps in vec
        sum += getpropertyV4(ps, Val(:i1)) + getpropertyV4(ps, Val(:i2)) +getpropertyV4(ps, Val(:u16)) +getpropertyV4(ps, Val(:i16))
    end
    sum
end









using BenchmarkTools

println("@btime bench($sv): some work on an ordinary struct, in a loop on a Vector to get stable timings")

@btime bench($sv)

println("@btime bench(psv): same work on PStruct having same fields as struct in preceding benchmark")
@btime bench($psv)

println("@btime benchV2(psv): same work, but using getpropertyV2 instead of getproperty for PStruct field access")
@btime benchV2($psv)

println("@btime benchV3(psv): same work, but handcoded getpropertyV3 using utilities  instead of getpropertyV2 for PStruct field access")
@btime benchV3($psv)

println("@btime benchV4(psv): same work, but handcoded getpropertyV4 with resulting SHIFT and AND operation")
@btime benchV4($psv)





# constructor tests

nv = (f1=false,f2=1,i1=1%UInt64,i2=2%Int64,i3=0x3,i4=4%Int8,u16=0x0123,i16=2345%Int16)

ps = PS(nv)

show(ps)
