#include "node.h"
#include "codegen.h"
#include "parser.hpp"

using namespace std;

/* Compile the AST into a module */
void CodeGenContext::generateCode(NBlock& root)
{
	std::cout << "Generating code...\n";
	
	/* Create the top level interpreter function to call as entry */
	vector<Type*> argTypes;
	FunctionType *ftype = FunctionType::get(Type::getInt32Ty(MyContext), makeArrayRef(argTypes), false);
	mainFunction = Function::Create(ftype, GlobalValue::ExternalLinkage, "main", module);
	BasicBlock *bblock = BasicBlock::Create(MyContext, "entry", mainFunction, 0);
	
	/* Push a new variable/block context */
	pushFunc(mainFunction);
	pushBlock(bblock);
	root.codeGen(*this); /* emit bytecode for the toplevel block */
	ReturnInst::Create(MyContext, getCurrentReturnValue(), currentBlock());
	popFunc();
	popBlock();
	
	/* Print the bytecode in a human-readable format 
	   to see if our program compiled properly
	 */
	std::cout << "Code is generated.\n";
	// module->dump();

	legacy::PassManager pm;
	// TODO:
	std::error_code e;
	llvm::raw_fd_ostream output("IRTree.ll", e);
	pm.add(createPrintModulePass(output));
	pm.run(*module);
}

/* Executes the AST by running the main function */
GenericValue CodeGenContext::runCode() {
	std::cout << "Running code...\n";
	ExecutionEngine *ee = EngineBuilder( unique_ptr<Module>(module) ).create();
	ee->finalizeObject();
	vector<GenericValue> noargs;
	GenericValue v = ee->runFunction(mainFunction, noargs);
	std::cout << "Code was run.\n";
	return v;
}

/* Returns an LLVM type based on the identifier */
llvm::Type *typeOf(const NIdentifier& type) 
{
	if (type.name.compare("int") == 0) {
		return Type::getInt32Ty(MyContext);
	}
	else if (type.name.compare("double") == 0) {
		return Type::getDoubleTy(MyContext);
	}
	else if (type.name.compare("char") == 0) {
		return Type::getInt8Ty(MyContext);
	}
	return Type::getVoidTy(MyContext);
}

llvm::Type *typeOf(const NIdentifier& type, int size) {
	if(type.name.compare("int") == 0) {
		return llvm::ArrayType::get(llvm::Type::getInt32Ty(MyContext), size);
	}
	else if(type.name.compare("double") == 0) {
		return llvm::ArrayType::get(llvm::Type::getDoubleTy(MyContext), size);
	}
	else if(type.name.compare("char") == 0) {
		return llvm::ArrayType::get(llvm::Type::getInt8Ty(MyContext), size);
	}
	return Type::getVoidTy(MyContext);
}

llvm::Instruction::CastOps getCastInst(llvm::Type* src, llvm::Type* dst) {
    if (src == llvm::Type::getDoubleTy(MyContext) && dst == llvm::Type::getInt32Ty(MyContext)) { //llvm下float到int
        return llvm::Instruction::FPToSI;  
    }
    else if (src == llvm::Type::getInt32Ty(MyContext) && dst == llvm::Type::getDoubleTy(MyContext)) { //llvm下int到float
        return llvm::Instruction::SIToFP;
    }
    else if (src == llvm::Type::getInt8Ty(MyContext) && dst == llvm::Type::getDoubleTy(MyContext)) {
        return llvm::Instruction::UIToFP;
    }
    else if (src == llvm::Type::getInt8Ty(MyContext) && dst == llvm::Type::getInt32Ty(MyContext)) {
        return llvm::Instruction::ZExt;
    }
    else if (src == llvm::Type::getInt32Ty(MyContext) && dst == llvm::Type::getInt8Ty(MyContext)) {
        return llvm::Instruction::Trunc;
    }
    else {
        throw logic_error("[ERROR] Wrong typecast");
    }
}

llvm::Value* typeCast(llvm::Value* src, llvm::Type* dst) {
    llvm::Instruction::CastOps op = getCastInst(src->getType(), dst);
    return myBuilder.CreateCast(op, src, dst, "tmptypecast");
}





/* -- Code Generation -- */

Value* NInteger::codeGen(CodeGenContext& context)
{
	std::cout << "Creating integer: " << value << endl;
	return ConstantInt::get(Type::getInt32Ty(MyContext), value, true);
}

Value* NDouble::codeGen(CodeGenContext& context)
{
	std::cout << "Creating double: " << value << endl;
	return ConstantFP::get(Type::getDoubleTy(MyContext), value);
}

Value* NIdentifier::codeGen(CodeGenContext& context)
{
	std::cout << "Creating identifier reference: " << name << endl;
	if (context.locals().find(name) == context.locals().end()) {
		std::cerr << "undeclared variable " << name << endl;
		return NULL;
	}
	else {
		llvm::Type* idType = (context.locals().find(name)->second)->getType()->getPointerElementType();
		if(idType->isArrayTy()) {
			vector<llvm::Value*> indexList;
        	indexList.push_back(myBuilder.getInt32(0));
        	indexList.push_back(myBuilder.getInt32(0));
        	return myBuilder.CreateInBoundsGEP(context.locals().find(name)->second, indexList, "arrayPtr");
		}
		else {
			return new LoadInst(context.locals()[name]->getType()->getPointerElementType(),context.locals()[name], name, false, context.currentBlock());
		}
	}
}

Value* NMethodCall::codeGen(CodeGenContext& context)
{
	Function *function = context.module->getFunction(id.name.c_str());
	if (function == NULL) {
		std::cerr << "no such function " << id.name << endl;
	}
	std::vector<Value*> args;
	ExpressionList::const_iterator it;
	for (it = arguments.begin(); it != arguments.end(); it++) {
		args.push_back((**it).codeGen(context));
	}
	CallInst *call = CallInst::Create(function, makeArrayRef(args), "", context.currentBlock());
	std::cout << "Creating method call: " << id.name << endl;
	return call;
}

Value* NBinaryOperator::codeGen(CodeGenContext& context)
{

	std::cout << "Creating binary operation " << op << endl;
	Instruction::BinaryOps instr;
	llvm::Value* left = lhs.codeGen(context);
    llvm::Value* right = rhs.codeGen(context);
	switch (op) {
		case TPLUS: 	instr = Instruction::Add; goto math;
		case TMINUS: 	instr = Instruction::Sub; goto math;
		case TMUL: 		instr = Instruction::Mul; goto math;
		case TDIV: 		instr = Instruction::SDiv; goto math;
		case TMOD:		instr = Instruction::SRem; goto math;
				
		/* TODO comparison */
		case TCEQ:	return (left->getType() == llvm::Type::getDoubleTy(MyContext)) ? myBuilder.CreateFCmpOEQ(left, right, "fcmptmp") : myBuilder.CreateICmpEQ(left, right, "icmptmp");
		case TCNE: return (left->getType() == llvm::Type::getDoubleTy(MyContext)) ? myBuilder.CreateFCmpONE(left, right, "fcmptmp") : myBuilder.CreateICmpNE(left, right, "icmptmp");
		case TCLT: return (left->getType() == llvm::Type::getDoubleTy(MyContext)) ? myBuilder.CreateFCmpOLT(left, right, "fcmptmp") : myBuilder.CreateICmpSLT(left, right, "icmptmp");
		case TCLE: return (left->getType() == llvm::Type::getDoubleTy(MyContext)) ? myBuilder.CreateFCmpOLE(left, right, "fcmptmp") : myBuilder.CreateICmpSLE(left, right, "icmptmp");
		case TCGT: return (left->getType() == llvm::Type::getDoubleTy(MyContext)) ? myBuilder.CreateFCmpOGT(left, right, "fcmptmp") : myBuilder.CreateICmpSGT(left, right, "icmptmp");
		case TCGE: return (left->getType() == llvm::Type::getDoubleTy(MyContext)) ? myBuilder.CreateFCmpOGE(left, right, "fcmptmp") : myBuilder.CreateICmpSGE(left, right, "icmptmp");

		case TAND: return myBuilder.CreateAnd(left, right, "tmpAnd");
		case TOR: return myBuilder.CreateOr(left, right, "tmpOR");
	}

	return NULL;
math:
	return BinaryOperator::Create(instr, lhs.codeGen(context), 
		rhs.codeGen(context), "", context.currentBlock());
}

Value* NAssignment::codeGen(CodeGenContext& context)
{
	std::cout << "Creating assignment for " << lhs.name << endl;
	if (context.locals().find(lhs.name) == context.locals().end()) {
		std::cerr << "undeclared variable " << lhs.name << endl;
		return NULL;
	}
	llvm::Value* expr = rhs.codeGen(context);
	if (expr->getType() != context.locals().find(lhs.name)->second->getType()->getPointerElementType()){
		expr = typeCast(expr, context.locals().find(lhs.name)->second->getType()->getPointerElementType());
	}
	return new StoreInst(expr, context.locals()[lhs.name], false, context.currentBlock());
}

Value* NBlock::codeGen(CodeGenContext& context)
{
	StatementList::const_iterator it;
	Value *last = NULL;
	for (it = statements.begin(); it != statements.end(); it++) {
		std::cout << "Generating code for " << typeid(**it).name() << endl;
		last = (**it).codeGen(context);
	}
	std::cout << "Creating block" << endl;
	return last;
}

Value* NExpressionStatement::codeGen(CodeGenContext& context)
{
	std::cout << "Generating code for " << typeid(expression).name() << endl;
	return expression.codeGen(context);
}

Value* NReturnStatement::codeGen(CodeGenContext& context)
{
	std::cout << "Generating return code for " << typeid(expression).name() << endl;
	Value *returnValue = expression.codeGen(context);
	context.setCurrentReturnValue(returnValue);
	return returnValue;
}

Value* NVariableDeclaration::codeGen(CodeGenContext& context)
{
	std::cout << "Creating variable declaration " << type.name << " " << id.name << endl;
	if(size == 0) {
		AllocaInst *alloc = new AllocaInst(typeOf(type), context.currentBlock()->getParent()->getParent()->getDataLayout().getAllocaAddrSpace(), id.name.c_str(), context.currentBlock());
		context.locals()[id.name] = alloc;
		if (assignmentExpr != NULL) {
			NAssignment assn(id, *assignmentExpr);
			assn.codeGen(context);
		}
		return alloc;
	}
	else {
		AllocaInst *alloc = new AllocaInst(typeOf(type, size), context.currentBlock()->getParent()->getParent()->getDataLayout().getAllocaAddrSpace(), id.name.c_str(), context.currentBlock());
		context.locals()[id.name] = alloc;
		return alloc;
	}
}

Value* NExternDeclaration::codeGen(CodeGenContext& context)
{
    vector<Type*> argTypes;
    VariableList::const_iterator it;
    for (it = arguments.begin(); it != arguments.end(); it++) {
        argTypes.push_back(typeOf((**it).type));
    }
    FunctionType *ftype = FunctionType::get(typeOf(type), makeArrayRef(argTypes), false);
    Function *function = Function::Create(ftype, GlobalValue::ExternalLinkage, id.name.c_str(), context.module);
    return function;
}

Value* NFunctionDeclaration::codeGen(CodeGenContext& context)
{
	vector<Type*> argTypes;
	VariableList::const_iterator it;
	for (it = arguments.begin(); it != arguments.end(); it++) {
		argTypes.push_back(typeOf((**it).type));
	}
	FunctionType *ftype = FunctionType::get(typeOf(type), makeArrayRef(argTypes), false);
	Function *function = Function::Create(ftype, GlobalValue::InternalLinkage, id.name.c_str(), context.module);
	BasicBlock *bblock = BasicBlock::Create(MyContext, "entry", function, 0);

	myBuilder.SetInsertPoint(bblock);
	context.pushFunc(function);
	context.pushBlock(bblock);

	Function::arg_iterator argsValues = function->arg_begin();
    Value* argumentValue;

	for (it = arguments.begin(); it != arguments.end(); it++) {
		(**it).codeGen(context);
		
		argumentValue = &*argsValues++;
		argumentValue->setName((*it)->id.name.c_str());
		StoreInst *inst = new StoreInst(argumentValue, context.locals()[(*it)->id.name], false, bblock);
	}
	
	block.codeGen(context);
	ReturnInst::Create(MyContext, context.getCurrentReturnValue(), context.currentBlock());

	context.popBlock();
	context.popFunc();
	myBuilder.SetInsertPoint(context.currentBlock());
	std::cout << "Creating function: " << id.name << endl;
	return function;
}

llvm::Value* NIfStatement::codeGen(CodeGenContext& context) {
    llvm::Function *function = context.getCurrentFunc();
    
    llvm::BasicBlock *IfBB = llvm::BasicBlock::Create(MyContext, "if", function);
    llvm::BasicBlock *ElseBB = llvm::BasicBlock::Create(MyContext, "else", function);
    llvm::BasicBlock *ThenBB = llvm::BasicBlock::Create(MyContext, "afterifelse", function);

    llvm::Value *condValue = condition.codeGen(context), *thenValue = nullptr, *elseValue = nullptr;
    condValue = myBuilder.CreateICmpNE(condValue, llvm::ConstantInt::get(llvm::Type::getInt1Ty(MyContext), 0, true), "ifCond");
    auto branch = myBuilder.CreateCondBr(condValue, IfBB, ElseBB);

    myBuilder.SetInsertPoint(IfBB);
    // 将 if 的域放入栈顶
    context.pushBlock(IfBB);
    ifBlock.codeGen(context);
    context.popBlock();

    myBuilder.CreateBr(ThenBB);

    myBuilder.SetInsertPoint(ElseBB);
    // 将 else 的域放入栈顶
    context.pushBlock(ElseBB);
    elseBlock->codeGen(context);
    context.popBlock();

   
    myBuilder.CreateBr(ThenBB);

    myBuilder.SetInsertPoint(ThenBB);
	context.popBlock(); 
	context.pushBlock(ThenBB);
	cout << "Generating code for if-else"<<endl; 
    return branch;
}

llvm::Value* NChar::codeGen(CodeGenContext &context)
{
    cout << "CharNode : " << value <<endl;
    if (this->value.size() == 3)
        return myBuilder.getInt8(this->value.at(1));
    else {
        if (this->value.compare("'\\n'") == 0) {
            return myBuilder.getInt8('\n');
        } else if (this->value.compare("'\\\\'") == 0){
            return myBuilder.getInt8('\\');
        } else if (this->value.compare("'\\t'") == 0){
            return myBuilder.getInt8('\t');
        } else if (this->value.compare("'\\v'") == 0){
            return myBuilder.getInt8('\v');
        } else if (this->value.compare("'\\''") == 0){
            return myBuilder.getInt8('\'');
        } else if (this->value.compare("'\\\"'") == 0){
            return myBuilder.getInt8('\"');
        } else if (this->value.compare("'\\0'") == 0){
            return myBuilder.getInt8('\0');
        } else {
            throw logic_error("[ERROR] char not defined: " + this->value);
        }
    }
    return nullptr;
}

llvm::Value* NString::codeGen(CodeGenContext &context) {
    cout << "StringNode : " << value <<endl;
    string str = value.substr(1, value.length() - 2);
    string after = string(1, '\n');
    int pos = str.find("\\n");
    while(pos != string::npos) {
        str = str.replace(pos, 2, after);
        pos = str.find("\\n");
    }
	cout << "StringNode : " << str <<endl;
    llvm::Constant *strConst = llvm::ConstantDataArray::getString(MyContext, str);
    
    llvm::Value *globalVar = new llvm::GlobalVariable(*(context.module), strConst->getType(), true, llvm::GlobalValue::PrivateLinkage, strConst, "_Const_String_");
    vector<llvm::Value*> indexList;
    indexList.push_back(myBuilder.getInt32(0));
    indexList.push_back(myBuilder.getInt32(0));
    // var value
    llvm::Value * varPtr = myBuilder.CreateInBoundsGEP(globalVar, makeArrayRef(indexList), "tmpstring");
    return varPtr;
}

llvm::Value*  NWhileStatement::codeGen(CodeGenContext &context){
    cout << "Generating code for while "<<endl;

    llvm::Function *TheFunction = context.getCurrentFunc();

    llvm::BasicBlock *condBB = llvm::BasicBlock::Create(MyContext, "cond", TheFunction);
    llvm::BasicBlock *loopBB = llvm::BasicBlock::Create(MyContext, "loop", TheFunction);
    llvm::BasicBlock *afterBB = llvm::BasicBlock::Create(MyContext, "afterLoop", TheFunction);

    //GlobalAfterBB.push(afterBB);

    myBuilder.CreateBr(condBB);
    myBuilder.SetInsertPoint(condBB);
	context.pushBlock(condBB);
    llvm::Value *condValue = condition.codeGen(context);
    condValue = myBuilder.CreateICmpNE(condValue, llvm::ConstantInt::get(llvm::Type::getInt1Ty(MyContext), 0, true), "whileCond");
    auto branch = myBuilder.CreateCondBr(condValue, loopBB, afterBB);
    //condBB = myBuilder.GetInsertBlock();
	context.popBlock();

    myBuilder.SetInsertPoint(loopBB);

    // 将 while 的域放入栈顶
    context.pushBlock(loopBB);
    block.codeGen(context);
    myBuilder.CreateBr(condBB);

    // while 结束, 将 while 的域弹出栈顶
    context.popBlock();
    myBuilder.SetInsertPoint(afterBB);
	context.popBlock();
	context.pushBlock(afterBB);
    //GlobalAfterBB.pop();
    return branch;
}

llvm::Value* NGetAddr::codeGen(CodeGenContext& context) {
    cout << "getAddrNode : " << id.name << endl;

	if (context.locals().find(id.name) == context.locals().end()) {
		std::cerr << "undeclared variable " << id.name << endl;
		return nullptr;
	}
    else {
		return (context.locals().find(id.name)->second);
	}
}

llvm::Value* NArrayElement::codeGen(CodeGenContext& context) {
	cout << "Get Array: " << id.name << "[]" <<  endl;
	if(context.locals().find(id.name) == context.locals().end()) {
		cout << "undeclared variable" << id.name << "[]" << endl;
		return nullptr;
	}
	else {
		llvm::Value* arrayPtr = context.locals().find(id.name)->second;
		vector<llvm::Value*> indexList;
		indexList.push_back(myBuilder.getInt32(0));
		indexList.push_back(index.codeGen(context));
		llvm::Value* elePtr = myBuilder.CreateInBoundsGEP(arrayPtr, llvm::ArrayRef<llvm::Value*>(indexList), "__Placeholder_of_a_element_in_array__");
		return new LoadInst(elePtr->getType()->getPointerElementType(), elePtr, "__Placeholder_for_array_load__", false, context.currentBlock());
	}
}

llvm::Value* NArrayElementAssign::codeGen(CodeGenContext& context) {
	cout << "Assign an element of array " << id.name << "[]" << endl;
	if(context.locals().find(id.name) == context.locals().end()) {
		cout << "undeclared variable" << id.name << "[]" << endl;
		return nullptr;
	} 
	else {
		llvm::Value* arrayPtr = context.locals().find(id.name)->second;
		vector<llvm::Value*> indexList;
		indexList.push_back(myBuilder.getInt32(0));
		indexList.push_back(index.codeGen(context));
		llvm::Value* elePtr = myBuilder.CreateInBoundsGEP(arrayPtr, llvm::ArrayRef<llvm::Value*>(indexList), "__Placeholder_of_a_element_in_array__");
		llvm::Value* expr = rhs.codeGen(context);
		return new StoreInst(expr, elePtr, false, context.currentBlock());
	}
}
