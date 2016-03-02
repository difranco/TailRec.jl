# TailRec

[![Build Status](https://travis-ci.org/TakekazuKATO/TailRec.jl.svg?branch=master)](https://travis-ci.org/TakekazuKATO/TailRec.jl)

# 説明

末尾再帰関数をループに書き換えて最適化します．内部では@label, @gotoマクロを使って単純に末尾再帰呼び出しを@gotoでループにします．

相互再帰呼び出しには対応していません．

# 使い方

```jl
using TailRec
@tailrec factorial(x,i)
if x == 1
i
else
factorial(x-1,i*x)
end
```

```jl
@tailrec factorial(x,i)=x==1?i:factorial(x-1,i*x)

factorial(BigInt(100),1)
93326215443944152681699238856266700490715968264381621468592963895217599993229915608941463976156518286253697920827223758251185210916864000000000000000000000000
```
