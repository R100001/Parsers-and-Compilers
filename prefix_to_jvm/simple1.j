.class public simple1 
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
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/println(I)V
return 
.end method

