#include <iostream>
#include <vector>
#include <llvm/IR/Value.h>

class CodeGenContext;
class NStatement;
class NExpression;
class NVariableDeclaration;

typedef std::vector<NStatement*> StatementList;
typedef std::vector<NExpression*> ExpressionList;
typedef std::vector<NVariableDeclaration*> VariableList;

class Node {
public:
	virtual ~Node() {}
	virtual llvm::Value* codeGen(CodeGenContext& context) { return NULL; }
};

class NExpression : public Node {
};

class NStatement : public Node {
};

class NInteger : public NExpression {
public:
	long long value;
	NInteger(long long value) : value(value) { }
	virtual llvm::Value* codeGen(CodeGenContext& context);
};

class NDouble : public NExpression {
public:
	double value;
	NDouble(double value) : value(value) { }
	virtual llvm::Value* codeGen(CodeGenContext& context);
};

class NIdentifier : public NExpression {
public:
	std::string name;
	NIdentifier(const std::string& name) : name(name) { }
	virtual llvm::Value* codeGen(CodeGenContext& context);
};

class NMethodCall : public NExpression {
public:
	const NIdentifier& id;
	ExpressionList arguments;
	NMethodCall(const NIdentifier& id, ExpressionList& arguments) :
		id(id), arguments(arguments) { }
	NMethodCall(const NIdentifier& id) : id(id) { }
	virtual llvm::Value* codeGen(CodeGenContext& context);
};

class NBinaryOperator : public NExpression {
public:
	int op;
	NExpression& lhs;
	NExpression& rhs;
	NBinaryOperator(NExpression& lhs, int op, NExpression& rhs) :
		lhs(lhs), rhs(rhs), op(op) { }
	virtual llvm::Value* codeGen(CodeGenContext& context);
};

class NAssignment : public NExpression {
public:
	NIdentifier& lhs;
	NExpression& rhs;
	NAssignment(NIdentifier& lhs, NExpression& rhs) : 
		lhs(lhs), rhs(rhs) { }
	virtual llvm::Value* codeGen(CodeGenContext& context);
};

class NBlock : public NExpression {
public:
	StatementList statements;
	NBlock() { }
	virtual llvm::Value* codeGen(CodeGenContext& context);
};

class NExpressionStatement : public NStatement {
public:
	NExpression& expression;
	NExpressionStatement(NExpression& expression) : 
		expression(expression) { }
	virtual llvm::Value* codeGen(CodeGenContext& context);
};

class NReturnStatement : public NStatement {
public:
	NExpression& expression;
	NReturnStatement(NExpression& expression) : 
		expression(expression) { }
	virtual llvm::Value* codeGen(CodeGenContext& context);
};

class NVariableDeclaration : public NStatement {
public:
	const NIdentifier& type;
	NIdentifier& id;
	NExpression *assignmentExpr;
	int size = 0;
	NVariableDeclaration(const NIdentifier& type, NIdentifier& id) :
		type(type), id(id) { assignmentExpr = NULL; }
	NVariableDeclaration(const NIdentifier& type, NIdentifier& id, NExpression *assignmentExpr) :
		type(type), id(id), assignmentExpr(assignmentExpr) { }
	NVariableDeclaration(const NIdentifier& type, NIdentifier& id, int size) : 
		type(type), id(id), size(size) { assignmentExpr = NULL; }
	virtual llvm::Value* codeGen(CodeGenContext& context);
};

class NExternDeclaration : public NStatement {
public:
    const NIdentifier& type;
    const NIdentifier& id;
    VariableList arguments;
    NExternDeclaration(const NIdentifier& type, const NIdentifier& id,
            const VariableList& arguments) :
        type(type), id(id), arguments(arguments) {}
    virtual llvm::Value* codeGen(CodeGenContext& context);
};

class NFunctionDeclaration : public NStatement {
public:
	const NIdentifier& type;
	const NIdentifier& id;
	VariableList arguments;
	NBlock& block;
	NFunctionDeclaration(const NIdentifier& type, const NIdentifier& id, 
			const VariableList& arguments, NBlock& block) :
		type(type), id(id), arguments(arguments), block(block) { }
	virtual llvm::Value* codeGen(CodeGenContext& context);
};

class NIfStatement : public NStatement {
public:
    NExpression& condition;
    NBlock& ifBlock;
    NBlock* elseBlock; // 可选的else语句块，可以为NULL

    NIfStatement(NExpression& condition, NBlock& ifBlock, NBlock* elseBlock = nullptr)
        : condition(condition), ifBlock(ifBlock), elseBlock(elseBlock) { }

    virtual llvm::Value* codeGen(CodeGenContext& context);
};

class NChar : public NExpression {
public:
  NChar(std::string &value) : value(value) {}
  virtual llvm::Value *codeGen(CodeGenContext& context);
  std::string value;
};

class NString : public NExpression {
public:
  NString(std::string &value) : value(value) {}
  virtual llvm::Value *codeGen(CodeGenContext &context);
  std::string value;
};

class NWhileStatement : public NStatement {
public:
  NWhileStatement(NExpression &condition, NBlock &block)
    : condition(condition), block(block) {}
  virtual llvm::Value* codeGen(CodeGenContext &context);
public:
  NExpression &condition;
  NBlock &block;
};

class NGetAddr : public NExpression {
public:
	NGetAddr(NIdentifier& id) : id(id) {}
	virtual llvm::Value* codeGen(CodeGenContext& context);
	NIdentifier& id;
};

class NArrayElement : public NExpression {
public:
	NIdentifier& id;
	NExpression& index;
	NArrayElement(NIdentifier& id, NExpression& index) : 
		id(id), index(index) {}
	virtual llvm::Value* codeGen(CodeGenContext& context);
};

class NArrayElementAssign : public NExpression {
public: 
	NIdentifier& id;
	NExpression& index;
	NExpression& rhs;
	NArrayElementAssign(NIdentifier& id, NExpression& index, NExpression& rhs) : 
		id(id), index(index), rhs(rhs) {}
	virtual llvm::Value* codeGen(CodeGenContext& context);	
};