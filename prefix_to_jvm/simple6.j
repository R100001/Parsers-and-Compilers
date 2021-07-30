.class public simple6 
.super java/lang/Object

.method public <init>()V 
 aload_0 
 invokespecial java/lang/Object/<init>()V 
 return 
.end method 


.method public static main([Ljava/lang/String;)V
 .limit locals 20 
 .limit stack 20
sipush 3
i2f
ldc 3.9
f2d
invokestatic java/lang/Math/floor(D)D
d2f
fadd
fstore 1
fload 1
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(F)V
sipush 3
sipush 3
isub
istore 2
iload 2
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(I)V
return 
.end method

