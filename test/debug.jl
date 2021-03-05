using PackedStructs

S1 = @NamedTuple{ f1::PUInt{1}, f2::Bool,i1::PUInt{6}, i2::PInt{8}, i3::Int8}
S2 = @NamedTuple{ v1::UInt8, v2::UInt8, v3::UInt16, v4::UInt32}



NT = @NamedTuple{ f1::Bool, f2:: PUInt{1}, i1::PUInt{6}, i2::PInt{8}, i3::UInt8, i4::Int8, u16::UInt16, i16::Int16}
const PS = PStruct{NT}




# constructor tests

nv = (f1=false,f2=1,i1=1%UInt64,i2=2%Int64,i3=0x3,i4=4%Int8,u16=0x0123,i16=2345%Int16)

ps = PS(nv)

show(ps)

getpropertyV2(ps, :i1)
