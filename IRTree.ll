; ModuleID = 'main'
source_filename = "main"

@.str = private constant [4 x i8] c"%d\0A\00"
@_Const_String_ = private constant [3 x i8] c"%s\00"
@_Const_String_.1 = private constant [4 x i8] c"%d\0A\00"

declare i32 @printf(i8*, ...)

declare i32 @scanf(i8*, ...)

define internal void @echo(i64 %toPrint) {
entry:
  %0 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i32 0, i32 0), i64 %toPrint)
  ret void
}

define i32 @main() {
entry:
  %s = alloca [100 x i8], align 1
  %arrayPtr = getelementptr inbounds [100 x i8], [100 x i8]* %s, i32 0, i32 0
  %0 = call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @_Const_String_, i32 0, i32 0), i8* %arrayPtr)
  %len = alloca i32, align 4
  store i32 0, i32* %len, align 4
  br label %cond

cond:                                             ; preds = %loop, %entry
  %len1 = load i32, i32* %len, align 4
  %__Placeholder_of_a_element_in_array__ = getelementptr inbounds [100 x i8], [100 x i8]* %s, i32 0, i32 %len1
  %__Placeholder_for_array_load__ = load i8, i8* %__Placeholder_of_a_element_in_array__, align 1
  %icmptmp = icmp ne i8 %__Placeholder_for_array_load__, 0
  %whileCond = icmp ne i1 %icmptmp, false
  br i1 %whileCond, label %loop, label %afterLoop

loop:                                             ; preds = %cond
  %len2 = load i32, i32* %len, align 4
  %len3 = load i32, i32* %len, align 4
  %1 = add i32 %len3, 1
  store i32 %1, i32* %len, align 4
  br label %cond

afterLoop:                                        ; preds = %cond
  %numsStack = alloca [100 x i32], align 4
  %signStack = alloca [100 x i8], align 1
  %nums_top = alloca i32, align 4
  %2 = sub i32 0, 1
  store i32 %2, i32* %nums_top, align 4
  %sign_top = alloca i32, align 4
  %3 = sub i32 0, 1
  store i32 %3, i32* %sign_top, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  %nums = alloca i32, align 4
  store i32 0, i32* %nums, align 4
  %tmp = alloca i32, align 4
  store i32 0, i32* %tmp, align 4
  %top = alloca i32, align 4
  store i32 0, i32* %top, align 4
  br label %cond4

cond4:                                            ; preds = %afterifelse, %afterLoop
  %i7 = load i32, i32* %i, align 4
  %len8 = load i32, i32* %len, align 4
  %icmptmp9 = icmp slt i32 %i7, %len8
  %whileCond10 = icmp ne i1 %icmptmp9, false
  br i1 %whileCond10, label %loop5, label %afterLoop6

loop5:                                            ; preds = %cond4
  %i11 = load i32, i32* %i, align 4
  %__Placeholder_of_a_element_in_array__12 = getelementptr inbounds [100 x i8], [100 x i8]* %s, i32 0, i32 %i11
  %__Placeholder_for_array_load__13 = load i8, i8* %__Placeholder_of_a_element_in_array__12, align 1
  %icmptmp14 = icmp eq i8 %__Placeholder_for_array_load__13, 43
  %i15 = load i32, i32* %i, align 4
  %__Placeholder_of_a_element_in_array__16 = getelementptr inbounds [100 x i8], [100 x i8]* %s, i32 0, i32 %i15
  %__Placeholder_for_array_load__17 = load i8, i8* %__Placeholder_of_a_element_in_array__16, align 1
  %icmptmp18 = icmp eq i8 %__Placeholder_for_array_load__17, 45
  %tmpOR = or i1 %icmptmp14, %icmptmp18
  %i19 = load i32, i32* %i, align 4
  %__Placeholder_of_a_element_in_array__20 = getelementptr inbounds [100 x i8], [100 x i8]* %s, i32 0, i32 %i19
  %__Placeholder_for_array_load__21 = load i8, i8* %__Placeholder_of_a_element_in_array__20, align 1
  %icmptmp22 = icmp eq i8 %__Placeholder_for_array_load__21, 42
  %tmpOR23 = or i1 %tmpOR, %icmptmp22
  %i24 = load i32, i32* %i, align 4
  %__Placeholder_of_a_element_in_array__25 = getelementptr inbounds [100 x i8], [100 x i8]* %s, i32 0, i32 %i24
  %__Placeholder_for_array_load__26 = load i8, i8* %__Placeholder_of_a_element_in_array__25, align 1
  %icmptmp27 = icmp eq i8 %__Placeholder_for_array_load__26, 47
  %tmpOR28 = or i1 %tmpOR23, %icmptmp27
  %ifCond = icmp ne i1 %tmpOR28, false
  br i1 %ifCond, label %if, label %else

afterLoop6:                                       ; preds = %cond4
  %ret = alloca i32, align 4
  %pos = alloca i32, align 4
  store i32 0, i32* %pos, align 4
  %k = alloca i32, align 4
  store i32 0, i32* %k, align 4
  br label %cond112

if:                                               ; preds = %loop5
  %sign_top29 = load i32, i32* %sign_top, align 4
  %sign_top30 = load i32, i32* %sign_top, align 4
  %4 = add i32 %sign_top30, 1
  store i32 %4, i32* %sign_top, align 4
  %sign_top31 = load i32, i32* %sign_top, align 4
  %__Placeholder_of_a_element_in_array__32 = getelementptr inbounds [100 x i8], [100 x i8]* %signStack, i32 0, i32 %sign_top31
  %i33 = load i32, i32* %i, align 4
  %__Placeholder_of_a_element_in_array__34 = getelementptr inbounds [100 x i8], [100 x i8]* %s, i32 0, i32 %i33
  %__Placeholder_for_array_load__35 = load i8, i8* %__Placeholder_of_a_element_in_array__34, align 1
  store i8 %__Placeholder_for_array_load__35, i8* %__Placeholder_of_a_element_in_array__32, align 1
  %i36 = load i32, i32* %i, align 4
  %i37 = load i32, i32* %i, align 4
  %5 = add i32 %i37, 1
  store i32 %5, i32* %i, align 4
  br label %afterifelse

else:                                             ; preds = %loop5
  store i32 0, i32* %nums, align 4
  store i32 0, i32* %tmp, align 4
  br label %cond38

afterifelse:                                      ; preds = %afterifelse70, %if
  br label %cond4

cond38:                                           ; preds = %loop39, %else
  %i41 = load i32, i32* %i, align 4
  %len42 = load i32, i32* %len, align 4
  %icmptmp43 = icmp slt i32 %i41, %len42
  %i44 = load i32, i32* %i, align 4
  %__Placeholder_of_a_element_in_array__45 = getelementptr inbounds [100 x i8], [100 x i8]* %s, i32 0, i32 %i44
  %__Placeholder_for_array_load__46 = load i8, i8* %__Placeholder_of_a_element_in_array__45, align 1
  %icmptmp47 = icmp sge i8 %__Placeholder_for_array_load__46, 48
  %tmpAnd = and i1 %icmptmp43, %icmptmp47
  %i48 = load i32, i32* %i, align 4
  %__Placeholder_of_a_element_in_array__49 = getelementptr inbounds [100 x i8], [100 x i8]* %s, i32 0, i32 %i48
  %__Placeholder_for_array_load__50 = load i8, i8* %__Placeholder_of_a_element_in_array__49, align 1
  %icmptmp51 = icmp sle i8 %__Placeholder_for_array_load__50, 57
  %tmpAnd52 = and i1 %tmpAnd, %icmptmp51
  %whileCond53 = icmp ne i1 %tmpAnd52, false
  br i1 %whileCond53, label %loop39, label %afterLoop40

loop39:                                           ; preds = %cond38
  %i54 = load i32, i32* %i, align 4
  %__Placeholder_of_a_element_in_array__55 = getelementptr inbounds [100 x i8], [100 x i8]* %s, i32 0, i32 %i54
  %__Placeholder_for_array_load__56 = load i8, i8* %__Placeholder_of_a_element_in_array__55, align 1
  %i57 = load i32, i32* %i, align 4
  %__Placeholder_of_a_element_in_array__58 = getelementptr inbounds [100 x i8], [100 x i8]* %s, i32 0, i32 %i57
  %__Placeholder_for_array_load__59 = load i8, i8* %__Placeholder_of_a_element_in_array__58, align 1
  %6 = sub i8 %__Placeholder_for_array_load__59, 48
  %tmptypecast = zext i8 %6 to i32
  store i32 %tmptypecast, i32* %tmp, align 4
  %nums60 = load i32, i32* %nums, align 4
  %nums61 = load i32, i32* %nums, align 4
  %7 = mul i32 %nums61, 10
  %tmp62 = load i32, i32* %tmp, align 4
  %nums63 = load i32, i32* %nums, align 4
  %nums64 = load i32, i32* %nums, align 4
  %8 = mul i32 %nums64, 10
  %tmp65 = load i32, i32* %tmp, align 4
  %9 = add i32 %8, %tmp65
  store i32 %9, i32* %nums, align 4
  %i66 = load i32, i32* %i, align 4
  %i67 = load i32, i32* %i, align 4
  %10 = add i32 %i67, 1
  store i32 %10, i32* %i, align 4
  br label %cond38

afterLoop40:                                      ; preds = %cond38
  %sign_top71 = load i32, i32* %sign_top, align 4
  %icmptmp72 = icmp sge i32 %sign_top71, 0
  %sign_top73 = load i32, i32* %sign_top, align 4
  %__Placeholder_of_a_element_in_array__74 = getelementptr inbounds [100 x i8], [100 x i8]* %signStack, i32 0, i32 %sign_top73
  %__Placeholder_for_array_load__75 = load i8, i8* %__Placeholder_of_a_element_in_array__74, align 1
  %icmptmp76 = icmp eq i8 %__Placeholder_for_array_load__75, 42
  %tmpAnd77 = and i1 %icmptmp72, %icmptmp76
  %sign_top78 = load i32, i32* %sign_top, align 4
  %__Placeholder_of_a_element_in_array__79 = getelementptr inbounds [100 x i8], [100 x i8]* %signStack, i32 0, i32 %sign_top78
  %__Placeholder_for_array_load__80 = load i8, i8* %__Placeholder_of_a_element_in_array__79, align 1
  %icmptmp81 = icmp eq i8 %__Placeholder_for_array_load__80, 47
  %tmpOR82 = or i1 %tmpAnd77, %icmptmp81
  %ifCond83 = icmp ne i1 %tmpOR82, false
  br i1 %ifCond83, label %if68, label %else69

if68:                                             ; preds = %afterLoop40
  %nums_top84 = load i32, i32* %nums_top, align 4
  %__Placeholder_of_a_element_in_array__85 = getelementptr inbounds [100 x i32], [100 x i32]* %numsStack, i32 0, i32 %nums_top84
  %__Placeholder_for_array_load__86 = load i32, i32* %__Placeholder_of_a_element_in_array__85, align 4
  store i32 %__Placeholder_for_array_load__86, i32* %top, align 4
  %nums_top87 = load i32, i32* %nums_top, align 4
  %nums_top88 = load i32, i32* %nums_top, align 4
  %11 = sub i32 %nums_top88, 1
  store i32 %11, i32* %nums_top, align 4
  %sign_top92 = load i32, i32* %sign_top, align 4
  %__Placeholder_of_a_element_in_array__93 = getelementptr inbounds [100 x i8], [100 x i8]* %signStack, i32 0, i32 %sign_top92
  %__Placeholder_for_array_load__94 = load i8, i8* %__Placeholder_of_a_element_in_array__93, align 1
  %icmptmp95 = icmp eq i8 %__Placeholder_for_array_load__94, 42
  %ifCond96 = icmp ne i1 %icmptmp95, false
  br i1 %ifCond96, label %if89, label %else90

else69:                                           ; preds = %afterLoop40
  br label %afterifelse70

afterifelse70:                                    ; preds = %else69, %afterifelse91
  %nums_top107 = load i32, i32* %nums_top, align 4
  %nums_top108 = load i32, i32* %nums_top, align 4
  %12 = add i32 %nums_top108, 1
  store i32 %12, i32* %nums_top, align 4
  %nums_top109 = load i32, i32* %nums_top, align 4
  %__Placeholder_of_a_element_in_array__110 = getelementptr inbounds [100 x i32], [100 x i32]* %numsStack, i32 0, i32 %nums_top109
  %nums111 = load i32, i32* %nums, align 4
  store i32 %nums111, i32* %__Placeholder_of_a_element_in_array__110, align 4
  br label %afterifelse

if89:                                             ; preds = %if68
  %top97 = load i32, i32* %top, align 4
  %nums98 = load i32, i32* %nums, align 4
  %top99 = load i32, i32* %top, align 4
  %nums100 = load i32, i32* %nums, align 4
  %13 = mul i32 %top99, %nums100
  store i32 %13, i32* %nums, align 4
  br label %afterifelse91

else90:                                           ; preds = %if68
  %top101 = load i32, i32* %top, align 4
  %nums102 = load i32, i32* %nums, align 4
  %top103 = load i32, i32* %top, align 4
  %nums104 = load i32, i32* %nums, align 4
  %14 = sdiv i32 %top103, %nums104
  store i32 %14, i32* %nums, align 4
  br label %afterifelse91

afterifelse91:                                    ; preds = %else90, %if89
  %sign_top105 = load i32, i32* %sign_top, align 4
  %sign_top106 = load i32, i32* %sign_top, align 4
  %15 = sub i32 %sign_top106, 1
  store i32 %15, i32* %sign_top, align 4
  br label %afterifelse70

cond112:                                          ; preds = %afterifelse126, %afterLoop6
  %k115 = load i32, i32* %k, align 4
  %sign_top116 = load i32, i32* %sign_top, align 4
  %icmptmp117 = icmp sle i32 %k115, %sign_top116
  %whileCond118 = icmp ne i1 %icmptmp117, false
  br i1 %whileCond118, label %loop113, label %afterLoop114

loop113:                                          ; preds = %cond112
  %pos119 = load i32, i32* %pos, align 4
  %__Placeholder_of_a_element_in_array__120 = getelementptr inbounds [100 x i32], [100 x i32]* %numsStack, i32 0, i32 %pos119
  %__Placeholder_for_array_load__121 = load i32, i32* %__Placeholder_of_a_element_in_array__120, align 4
  store i32 %__Placeholder_for_array_load__121, i32* %ret, align 4
  %pos122 = load i32, i32* %pos, align 4
  %pos123 = load i32, i32* %pos, align 4
  %16 = add i32 %pos123, 1
  store i32 %16, i32* %pos, align 4
  %k127 = load i32, i32* %k, align 4
  %__Placeholder_of_a_element_in_array__128 = getelementptr inbounds [100 x i8], [100 x i8]* %signStack, i32 0, i32 %k127
  %__Placeholder_for_array_load__129 = load i8, i8* %__Placeholder_of_a_element_in_array__128, align 1
  %icmptmp130 = icmp eq i8 %__Placeholder_for_array_load__129, 43
  %ifCond131 = icmp ne i1 %icmptmp130, false
  br i1 %ifCond131, label %if124, label %else125

afterLoop114:                                     ; preds = %cond112
  %pos154 = load i32, i32* %pos, align 4
  %__Placeholder_of_a_element_in_array__155 = getelementptr inbounds [100 x i32], [100 x i32]* %numsStack, i32 0, i32 %pos154
  %__Placeholder_for_array_load__156 = load i32, i32* %__Placeholder_of_a_element_in_array__155, align 4
  %17 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_Const_String_.1, i32 0, i32 0), i32 %__Placeholder_for_array_load__156)
  ret i32 0

if124:                                            ; preds = %loop113
  %pos132 = load i32, i32* %pos, align 4
  %__Placeholder_of_a_element_in_array__133 = getelementptr inbounds [100 x i32], [100 x i32]* %numsStack, i32 0, i32 %pos132
  %pos134 = load i32, i32* %pos, align 4
  %__Placeholder_of_a_element_in_array__135 = getelementptr inbounds [100 x i32], [100 x i32]* %numsStack, i32 0, i32 %pos134
  %__Placeholder_for_array_load__136 = load i32, i32* %__Placeholder_of_a_element_in_array__135, align 4
  %ret137 = load i32, i32* %ret, align 4
  %pos138 = load i32, i32* %pos, align 4
  %__Placeholder_of_a_element_in_array__139 = getelementptr inbounds [100 x i32], [100 x i32]* %numsStack, i32 0, i32 %pos138
  %__Placeholder_for_array_load__140 = load i32, i32* %__Placeholder_of_a_element_in_array__139, align 4
  %ret141 = load i32, i32* %ret, align 4
  %18 = add i32 %__Placeholder_for_array_load__140, %ret141
  store i32 %18, i32* %__Placeholder_of_a_element_in_array__133, align 4
  br label %afterifelse126

else125:                                          ; preds = %loop113
  %pos142 = load i32, i32* %pos, align 4
  %__Placeholder_of_a_element_in_array__143 = getelementptr inbounds [100 x i32], [100 x i32]* %numsStack, i32 0, i32 %pos142
  %ret144 = load i32, i32* %ret, align 4
  %pos145 = load i32, i32* %pos, align 4
  %__Placeholder_of_a_element_in_array__146 = getelementptr inbounds [100 x i32], [100 x i32]* %numsStack, i32 0, i32 %pos145
  %__Placeholder_for_array_load__147 = load i32, i32* %__Placeholder_of_a_element_in_array__146, align 4
  %ret148 = load i32, i32* %ret, align 4
  %pos149 = load i32, i32* %pos, align 4
  %__Placeholder_of_a_element_in_array__150 = getelementptr inbounds [100 x i32], [100 x i32]* %numsStack, i32 0, i32 %pos149
  %__Placeholder_for_array_load__151 = load i32, i32* %__Placeholder_of_a_element_in_array__150, align 4
  %19 = sub i32 %ret148, %__Placeholder_for_array_load__151
  store i32 %19, i32* %__Placeholder_of_a_element_in_array__143, align 4
  br label %afterifelse126

afterifelse126:                                   ; preds = %else125, %if124
  %k152 = load i32, i32* %k, align 4
  %k153 = load i32, i32* %k, align 4
  %20 = add i32 %k153, 1
  store i32 %20, i32* %k, align 4
  br label %cond112
}

define internal void @test() {
entry:
  ret void
}
