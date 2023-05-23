#include <stack>
#include <typeinfo>
#include <llvm/IR/Module.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/Type.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/LegacyPassManager.h>
#include "llvm/Pass.h"
#include <llvm/IR/Instructions.h>
#include <llvm/IR/CallingConv.h>
#include <llvm/IR/IRPrintingPasses.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/Bitstream/BitstreamReader.h>
#include <llvm/Bitstream/BitstreamWriter.h>
#include <llvm/Support/TargetSelect.h>
#include <llvm/ExecutionEngine/ExecutionEngine.h>
#include <llvm/ExecutionEngine/MCJIT.h>
#include <llvm/ExecutionEngine/GenericValue.h>
#include <llvm/Support/raw_ostream.h>

using namespace llvm;

class NBlock;

static LLVMContext MyContext;
static IRBuilder<> myBuilder(MyContext);

class CodeGenBlock {
public:
    BasicBlock *block;
    Value *returnValue;
    //std::map<std::string, Value*> locals;
};

class CodeGenFunc {
public:
    Function* currentFunc;
    std::map<std::string, Value*> FuncVars;
};

class CodeGenContext {
public: 
    std::stack<CodeGenBlock *> blocks;
    Function *mainFunction;
    std::stack<CodeGenFunc*> FuncStack;
    std::map<std::string, Value*> globals;

public:

    Module *module;
    CodeGenContext() { module = new Module("main", MyContext); }
    
    void generateCode(NBlock& root);
    GenericValue runCode();
    std::map<std::string, Value*>& locals() { return FuncStack.top()->FuncVars; }
    BasicBlock *currentBlock() { return blocks.top()->block; }
    void pushBlock(BasicBlock *block) { blocks.push(new CodeGenBlock()); blocks.top()->returnValue = NULL; blocks.top()->block = block; }
    void popBlock() { CodeGenBlock *top = blocks.top(); blocks.pop(); delete top; }
    void setCurrentReturnValue(Value *value) { blocks.top()->returnValue = value; }
    Value* getCurrentReturnValue() { return blocks.top()->returnValue; }
    void pushFunc(Function* func) { FuncStack.push(new CodeGenFunc()); FuncStack.top()->currentFunc = func;}
    void popFunc(){ FuncStack.pop(); }
    Function* getCurrentFunc() { return FuncStack.top()->currentFunc; }
};
