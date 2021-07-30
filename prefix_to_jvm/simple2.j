.class public simple2 
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
sipush 4
iadd
i2f
sipush 7
i2f
fmul
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(F)V
sipush 3
i2f
sipush 4
i2f
fadd
f2i
sipush 7
imul
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(I)V
ldc 3.0
f2i
ldc 4.0
f2i
iadd
ldc 7.0
f2i
imul
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(I)V
return 
.end method

