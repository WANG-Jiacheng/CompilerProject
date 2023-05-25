; ModuleID = 'main'
source_filename = "main"

@.str = private constant [4 x i8] c"%d\0A\00"
@_Const_String_ = private constant [8 x i8] c"%c->%c\0A\00"
@_Const_String_.1 = private constant [8 x i8] c"%c->%c\0A\00"
@_Const_String_.2 = private constant [3 x i8] c"%d\00"

declare i32 @printf(i8*, ...)

declare i32 @scanf(i8*, ...)

define internal void @echo(i64 %toPrint) {
entry:
  %0 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i32 0, i32 0), i64 %toPrint)
  ret void
}

define i64 @main() {
entry:
  %n = alloca i64, align 8, addrspace(16)
  %0 = call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @_Const_String_.2, i32 0, i32 0), i64 addrspace(16)* %n)
  %n1 = load i64, i64 addrspace(16)* %n, align 4
  call void @move(i64 %n1, i8 65, i8 66, i8 67)
  ret i64 0
}

define internal void @move(i64 %n1, i8 %a2, i8 %b3, i8 %c4) {
entry:
  %n = alloca i64, align 8, addrspace(16)
  store i64 %n1, i64 addrspace(16)* %n, align 4
  %a = alloca i8, align 1, addrspace(16)
  store i8 %a2, i8 addrspace(16)* %a, align 1
  %b = alloca i8, align 1, addrspace(16)
  store i8 %b3, i8 addrspace(16)* %b, align 1
  %c = alloca i8, align 1, addrspace(16)
  store i8 %c4, i8 addrspace(16)* %c, align 1
  %n5 = load i64, i64 addrspace(16)* %n, align 4
  %icmptmp = icmp eq i64 %n5, 1
  %ifCond = icmp ne i1 %icmptmp, false
  br i1 %ifCond, label %if, label %else

if:                                               ; preds = %entry
  %a6 = load i8, i8 addrspace(16)* %a, align 1
  %c7 = load i8, i8 addrspace(16)* %c, align 1
  %0 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @_Const_String_, i32 0, i32 0), i8 %a6, i8 %c7)
  br label %afterifelse

else:                                             ; preds = %entry
  %n8 = load i64, i64 addrspace(16)* %n, align 4
  %n9 = load i64, i64 addrspace(16)* %n, align 4
  %1 = sub i64 %n9, 1
  %a10 = load i8, i8 addrspace(16)* %a, align 1
  %c11 = load i8, i8 addrspace(16)* %c, align 1
  %b12 = load i8, i8 addrspace(16)* %b, align 1
  call void @move(i64 %1, i8 %a10, i8 %c11, i8 %b12)
  %a13 = load i8, i8 addrspace(16)* %a, align 1
  %c14 = load i8, i8 addrspace(16)* %c, align 1
  %2 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @_Const_String_.1, i32 0, i32 0), i8 %a13, i8 %c14)
  %n15 = load i64, i64 addrspace(16)* %n, align 4
  %n16 = load i64, i64 addrspace(16)* %n, align 4
  %3 = sub i64 %n16, 1
  %b17 = load i8, i8 addrspace(16)* %b, align 1
  %a18 = load i8, i8 addrspace(16)* %a, align 1
  %c19 = load i8, i8 addrspace(16)* %c, align 1
  call void @move(i64 %3, i8 %b17, i8 %a18, i8 %c19)
  br label %afterifelse

afterifelse:                                      ; preds = %else, %if
  ret void
}
