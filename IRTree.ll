; ModuleID = 'main'
source_filename = "main"

@.str = private constant [4 x i8] c"%d\0A\00"
@_Const_String_ = private constant [4 x i8] c"%d\0A\00"

declare i32 @printf(i8*, ...)

define internal void @echo(i64 %toPrint) {
entry:
  %0 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i32 0, i32 0), i64 %toPrint)
  ret void
}

define internal void @main() {
entry:
  %0 = call i64 @do_math(i64 11)
  call void @echo(i64 %0)
  %1 = call i64 @do_math(i64 12)
  call void @echo(i64 %1)
  call void @printi(i64 10)
  %2 = call i64 @do_math(i64 11)
  %3 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_Const_String_, i32 0, i32 0), i64 %2)
  ret void
}

declare void @printi(i64)

define internal i64 @do_math(i64 %a1) {
entry:
  %a = alloca i64, align 8, addrspace(4)
  store i64 %a1, i64 addrspace(4)* %a, align 4
  %x = alloca i64, align 8, addrspace(4)
  %a2 = load i64, i64 addrspace(4)* %a, align 4
  %a3 = load i64, i64 addrspace(4)* %a, align 4
  %0 = mul i64 %a3, 5
  store i64 %0, i64 addrspace(4)* %x, align 4
  br i1 true, label %if, label %else

if:                                               ; preds = %entry
  call void @echo(i64 3)
  br label %afterifelse

else:                                             ; preds = %entry
  br label %afterifelse

afterifelse:                                      ; preds = %else, %if
  ret i64 5
}