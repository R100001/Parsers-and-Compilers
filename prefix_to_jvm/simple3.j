.class public simple3 
.super java/lang/Object

.method public <init>()V 
 aload_0 
 invokespecial java/lang/Object/<init>()V 
 return 
.end method 


.method public static main([Ljava/lang/String;)V
 .limit locals 20 
 .limit stack 20
ldc 1.0
fstore 1
fload 1
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(F)V
sipush 1
istore 2
iload 2
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(I)V
iload 2
sipush 1
iadd
i2f
fstore 1
fload 1
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(F)V
return 
.end method

