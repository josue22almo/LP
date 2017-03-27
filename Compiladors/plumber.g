#header
<<
#include <string>
#include <iostream>
using namespace std;

// struct to store information about tokens
typedef struct {
  string kind;
  string text;
} Attrib;

// function to fill token information (predeclaration)
void zzcr_attr(Attrib *attr, int type, char *text);

// fields for AST nodes
#define AST_FIELDS string kind; string text;
#include "ast.h"

// macro to create a new AST node (and function predeclaration)
#define zzcr_ast(as,attr,ttype,textt) as=createASTnode(attr,ttype,textt)
AST* createASTnode(Attrib* attr, int ttype, char *textt);
>>

<<
#include <cmath>
#include <map>
#include <vector>
#include <list>
// function to fill token information
void zzcr_attr(Attrib *attr, int type, char *text) {
    attr->kind = text;
    attr->text = "";
}

// function to create a new AST node
AST* createASTnode(Attrib* attr, int type, char* text) {
  AST* as = new AST;
  as->kind = attr->kind; 
  as->text = attr->text;
  as->right = NULL; 
  as->down = NULL;
  return as;
}

/// create a new "list" AST node with one element
AST* createASTlist(AST *child) {
 AST *as=new AST;
 as->kind="list";
 as->right=NULL;
 as->down=child;
 return as;
}

/// get nth child of a tree. Count starts at 0.
/// if no such child, returns NULL
AST* child(AST *a,int n) {
 AST *c=a->down;
 for (int i=0; c!=NULL && i<n; i++) c=c->right;
 return c;
} 

int numChilds(AST *a) {
 AST *c=a->down;
 int i;
 for (i=0; c!=NULL; i++) c=c->right;
 return i;
}

/// print AST, recursively, with indentation
void ASTPrintIndent(AST *a,string s)
{
  if (a==NULL) return;

  cout<<a->kind;
  if (a->text!="") cout<<"("<<a->text<<")";
  cout<<endl;

  AST *i = a->down;
  while (i!=NULL && i->right!=NULL) {
    cout<<s+"  \\__";
    ASTPrintIndent(i,s+"  |"+string(i->kind.size()+i->text.size(),' '));
    i=i->right;
  }
  
  if (i!=NULL) {
      cout<<s+"  \\__";
      ASTPrintIndent(i,s+"   "+string(i->kind.size()+i->text.size(),' '));
      i=i->right;
  }
}

/// print AST 
void ASTPrint(AST *a)
{
  while (a!=NULL) {
    cout<<" ";
    ASTPrintIndent(a,"");
    a=a->right;
  }
}

struct Tube{
    string id;
    int length;
    int diameter;
    bool valid;
};

struct Connector{
    string id;
    int diameter;
    bool valid;
};

struct Tubevector{
    string id;
    list <Tube> tubes;
    int maxSize;
    bool valid;
};

struct Error{
    int line;
    string text;
};

typedef map<string, Tube> Tubes;
typedef map<string, Connector> Connectors;
typedef vector<Error> Errors;
typedef map<string,Tubevector> Tubevectors;

Tubes tubes;
Connectors connectors;
Errors errors;
Tubevectors tubevectors;

void printLengthDiameter(AST *c, AST *id, int size);
void printTubes();
void printConnectors();
void printTubevectors();
void printErrors();
void saveError (string msg, int line);
void errorNotDeclared(AST *c, int line);
void saveWhileError();
void invalidatedTubeConnector(AST *a);
void insertTube(Tube newTube);
void insertConnector(Connector newConnector);
void insertTubevector(Tubevector newTubevector);
void normalAssignation(AST *id, AST *value, int line);
void push(AST *a, AST *value, int line);
void popTube(AST *a);
void evaluateAST (AST *a, int line);

int evalWhile(AST *condition, AST *ops, int line);
int getSize (AST *a, int line);

bool isDigit (char c);
bool validTube (string id);
bool validConnector (string id);
bool validTubevector (string id);
bool empty(Tubevector tb);
bool empty (AST *a, int line);
bool full (Tubevector tb);
bool full (AST *a, int line);
bool evalCondition (AST *condition, int line);

Tube createTube (AST *aId, AST *aSize, int line);
Tube createTube(string s, int l, int d);
Tube merge (AST *id, AST *mg, int line);
Tube pop(AST *a, AST *value, int line);
Connector createConnector (AST *aId, AST *aSize, int line);
Tubevector createTubevector(AST *id, AST *value, int line);
pair<Tube,Tube> split(AST *a, int line);


void printLengthDiameter(AST *c, AST *id, int size){
    cout << "The " << c->kind << " of " << id->kind << " is " << size << "." << endl;    
}

void printTubes(){
    cout << "Execution is done" << endl;
    cout << "-------------------------" << endl << "-------------------------" << endl;
    cout << "At the end of the execution following variables are the available tubes."<< endl;
    for(map<string, Tube >::iterator it = tubes.begin(); it != tubes.end(); ++it){
        if (it->second.valid)
            cout << it->second.id << " " << it->second.length << " " << it->second.diameter << endl;
    }
    cout << "-------------------------" << endl << "-------------------------" << endl;
}

void printConnectors(){
    cout << "At the end of the execution following variables are the available connectors."<< endl;
    for(map<string, Connector >::iterator it = connectors.begin(); it != connectors.end(); ++it){
       if (it->second.valid)
            cout << it->second.id << " " << it->second.diameter << endl;
    }
    cout << "-------------------------" << endl << "-------------------------" << endl;
}

void printTubevectors(){
    cout << "At the end of the execution following variables are the available tube in the tubevectors."<< endl;
    for(map<string, Tubevector>::iterator it = tubevectors.begin(); it != tubevectors.end(); ++it){
        cout << "The tube vector " << it->second.id;
        bool first = true;
        list <Tube> l = it->second.tubes;
        int cont = 0;
        for (list<Tube>::iterator i = l.begin(); i != l.end(); ++i){
           if (first){
                first = false;
                cout << " has the folowing tubes:" << endl;
            }
            cout << it->second.id << ++cont << " " << (*i).length << " " << (*i).diameter << endl;
        }
        if (first) cout << " has no tubes." << endl;
    }
    cout << "-------------------------" << endl << "-------------------------" << endl;
}

void printErrors(){
    cout << "ERRORS FOUNDS: ";
    cout << (errors.size() == 0 ? "The program had correct exection" : "") << endl;
    for (int i = 0; i < errors.size(); ++i){
        if (errors[i].line != 0)
            cout << "Error in line " << errors[i].line << " ";
        cout << errors[i].text << endl;
    }
    cout << "-------------------------" << endl << "-------------------------" << endl;
}

void saveError (string msg, int line){
    Error e;
    e.line = line;
    e.text = msg;
    errors.push_back(e);
}

void errorNotDeclared(AST *c, int line, string k){
    saveError("Error in " + k + " " + c->kind + " has not declared in this scope.",line);
}

void saveWhileError(){
    saveError("WHILE loop didn't end its execution", 0);
}

void invalidatedTubeConnector(AST *a){
    if (tubes.find(a->kind) != tubes.end())
        tubes.find(a->kind)->second.valid = false;
    else if (connectors.find(a->kind) != connectors.end())
        connectors.find(a->kind)->second.valid = false;
}

void insertTube(Tube newTube){
    if (tubes.find(newTube.id) != tubes.end()){
        tubes.find(newTube.id)->second = newTube;
    }else
        tubes.insert(pair<string,Tube>(newTube.id,newTube));
}

void insertConnector(Connector newConnector){
    if (connectors.find(newConnector.id) != connectors.end()){
        connectors.find(newConnector.id)->second = newConnector;
    }else 
        connectors.insert(pair<string,Connector>(newConnector.id,newConnector));
}

void insertTubevector(Tubevector newTubevector){
    if (tubevectors.find(newTubevector.id) != tubevectors.end()){
        tubevectors.find(newTubevector.id)->second = newTubevector;
    }else 
        tubevectors.insert(pair<string,Tubevector>(newTubevector.id,newTubevector));
}

void normalAssignation(AST *id, AST *value, int line){
    if (tubes.find(value->kind) != tubes.end()){
        map<string, Tube >::iterator it  = tubes.find(value->kind);
        Tube newTube;
        if (it->second.valid){
            newTube.id = id->kind;
            newTube.length = it->second.length;
            newTube.diameter = it->second.diameter;
            newTube.valid = true;
            invalidatedTubeConnector(value);
            insertTube(newTube);
        }else saveError(it->second.id + " is invalid.", line);
    }else if (connectors.find(value->kind) != connectors.end()){
        map<string, Connector >::iterator it  = connectors.find(value->kind);
        if (it->second.valid){
            Connector newConnector;
            newConnector.id = id->kind;
            newConnector.diameter = it->second.diameter;
            newConnector.valid = true;
            invalidatedTubeConnector(value);
            insertConnector(newConnector);
        }else saveError(it->second.id + " is invalid.", line);
    }else{
        errorNotDeclared(value,line, "NORMAL ASSIGNATION");
    }
}



void push(AST *a, AST *value, int line){
    if (tubevectors.find(a->kind) != tubevectors.end()){
        if (!full(tubevectors.find(a->kind)->second)){ //push is possible 
            if (validTube(value->kind)){ 
                tubevectors.find(a->kind)->second.tubes.push_back(tubes.find(value->kind)->second);
                invalidatedTubeConnector(value);
            }
            else 
                errorNotDeclared(value,line,"PUSH");
        }else
            saveError("The tubevector " + a->kind + " is FULL.", line);
        
    }else 
        errorNotDeclared(a,line,"PUSH");
}

void popTube(AST *a){
    tubevectors.find(a->kind)->second.tubes.pop_front();
}

void evaluateAST (AST *a, int line){
    int nChild = 0;
    AST *currentChild;
    while (nChild < numChilds(a)){
        currentChild = child(a,nChild);
        int nChilds = numChilds(currentChild);
        if (nChilds == 3){//SPLIT
            AST *id1 = child(currentChild,0);
            AST *id2 = child(currentChild,1);
            AST *sp = child(currentChild,2); //kind = SPLIT
            pair<Tube,Tube> newTubes = split(sp->down,line);
            if (newTubes.first.valid){
                newTubes.first.id = id1->kind; newTubes.second.id = id2->kind;
                insertTube(newTubes.first); insertTube(newTubes.second);
            }
        }
        else if (nChilds == 2){ //TUBE , CONNECTOR , WHILE
            AST *id = child(currentChild,0); //es el ID
            AST *value = child(currentChild,1); //value
            if (currentChild->kind == "="){ //AN ASSIGNATION
                string kind = value->kind;
                if (kind == "TUBE"){
                    Tube newTube = createTube(id,value, line);           
                    if (newTube.valid) insertTube(newTube);
                }
                else if (kind == "CONNECTOR"){
                    Connector newConnector = createConnector(id,value,line);
                    if (newConnector.valid) insertConnector(newConnector);
                }else if (kind == "MERGE"){
                    Tube newTube = merge(id,value,line);
                    if (newTube.valid)  insertTube(newTube);
                }else if (kind == "TUBEVECTOR"){
                    Tubevector newTubevector = createTubevector(id,value,line);
                    if (newTubevector.valid) insertTubevector(newTubevector);
                }else {//normal assignation
                    normalAssignation(id,value,line);
                }                
            }else if (currentChild->kind == "PUSH"){
                push(id,value,line);
            }else if (currentChild->kind == "POP"){
                Tube newTube = pop(id,value,line);
                if (newTube.valid) insertTube(newTube);
            }else if (currentChild->kind == "WHILE"){
                line += evalWhile(id,value,line);
            }
        }else if (nChilds == 1){ //LENGTH OR DIAMETER
            AST *id = child(currentChild,0);
            int size = getSize(currentChild,line);
            if (size != -1) printLengthDiameter(currentChild,id,size);
        }
        ++nChild;
        ++line;
    }
}

int evalWhile(AST *condition, AST *ops, int line){
    int nErrors = errors.size();
    int errorsFinals = errors.size();
    while (evalCondition(condition,line) && nErrors == errorsFinals){
        evaluateAST(ops,line);
        errorsFinals = errors.size();
    }
    if (nErrors != errorsFinals) saveWhileError();
    return numChilds(ops);
}

int getSize (AST *a, int line){
    string id = a->kind;
    if (isDigit(id[0])) return atoi(id.c_str());
    else{ //tenemos el size de un ID (connector o tube)
        AST *c = child(a,0);
        if (id == "LENGTH"){ //buscamos el length del ID
            if (tubes.find(c->kind) != tubes.end()){ //es un tubo
                return tubes.find(c->kind)->second.length;
            }else if (connectors.find(c->kind) != connectors.end()){ 
                //error, un connector no tiene length, si no diameter
                saveError(c->kind + " is a CONNECTOR. CONNECTOR has no length", line);
                return -1;
            }else{
                errorNotDeclared(c,line,"LENGTH");
                return -1;
            }
        }else{ //DIAMETER
            if (tubes.find(c->kind) != tubes.end()){ //es un tubo
                return tubes.find(c->kind)->second.diameter;
            }else if (connectors.find(c->kind) != connectors.end()){ 
                //error, un tubo no tiene length, si no diameter
                return connectors.find(c->kind)->second.diameter;;
            }else{
                errorNotDeclared(c,line,"DIAMETER");
                return -1;
            }
        }
    }
}

bool isDigit (char c){
    return ( '0' <= c && c <= '9' );
}

bool validTube (string id){
    return tubes.find(id) != tubes.end() && tubes.find(id)->second.valid;
}

bool validConnector (string id){
    return connectors.find(id) != connectors.end() && connectors.find(id)->second.valid;
}

bool validTubevector (string id){
    return tubevectors.find(id) != tubevectors.end() && tubevectors.find(id)->second.valid;
}

bool empty(Tubevector tb){
     return tb.tubes.size() == 0;
}

bool empty (AST *a, int line){
    if (validTubevector(a->kind)) return tubevectors.find(a->kind)->second.tubes.size() == 0;
    return false;
}

bool full (Tubevector tb){
    return tb.tubes.size() == tb.maxSize;
}

bool full (AST *a, int line){
    if (validTubevector(a->kind)) return tubevectors.find(a->kind)->second.tubes.size() == tubevectors.find(a->kind)->second.maxSize;
    return false;
}

bool evalCondition (AST *condition, int line){
    if (condition->kind == "AND")
        return evalCondition(child(condition,0),line) && evalCondition(child(condition,1),line);
    else if (condition->kind == "OR")
        return evalCondition(child(condition,0),line) || evalCondition(child(condition,1),line);
    else if (condition->kind == "NOT")
        return !evalCondition(child(condition,0),line);
    else if (condition->kind == "FULL")
        return full(child(condition,0),line);
    else if (condition->kind == "EMPTY")
        return empty(child(condition,0),line);
    else if (condition->kind == ">") return getSize(child(condition,0),line) > getSize(child(condition,1),line);
    else if (condition->kind == "<") return getSize(child(condition,0),line) < getSize(child(condition,1),line);
    else if (condition->kind == "==") return getSize(child(condition,0),line) == getSize(child(condition,1),line);
}

Tube createTube (AST *aId, AST *aSize, int line){
    Tube tube;
    tube.id = aId->kind;
    tube.length = getSize(child(aSize,0),line);
    tube.diameter = getSize(child(aSize,1),line);
    tube.valid = (tube.length != -1 && tube.diameter != -1);
    return tube;
}

Tube createTube(string s, int l, int d){
    Tube tube;
    tube.id = s;
    tube.length = l;
    tube.diameter = d;
    tube.valid = true;
    return tube;
}

Tube merge (AST *id, AST *mg, int line){
    Tube newTube;
    newTube.valid = false;
    AST *t1 = child(mg,0);
    AST *con = child(mg,1);
    AST *t2 = child(mg,2);
    Tube tube1, tube2;
    Connector connector;
    tube1.valid = tube2.valid = connector.valid = false;
    //Getting the first TUBE
    if (t1->kind == "MERGE") tube1 = merge(NULL,t1,line); 
    else{
        if (validTube(t1->kind))
            tube1 = tubes.find(t1->kind)->second;
        else 
            errorNotDeclared(t1,line,"MERGE");
    }
    //Getting the connector
    if (validConnector(con->kind))
        connector = connectors.find(con->kind)->second;
    else 
        errorNotDeclared(con,line,"MERGE");  
    //Getting the second TUBE
    if (t2->kind == "MERGE") tube2 = merge(NULL,t2,line);
    else{
        if (validTube(t2->kind))
            tube2 = tubes.find(t2->kind)->second;
        else 
            errorNotDeclared(t2,line,"MERGE");
    }
    //Creating the new tube if possible
    if (tube1.valid == false|| tube2.valid == false|| connector.valid == false){
        if (!tube1.valid)
            saveError("MERGE error: " + t1->kind + " is invalid parameter.", line);
        if (!connector.valid)
            saveError("MERGE error: " + con->kind + " is invalid parameter.", line);
        if (!tube2.valid)
            saveError("MERGE error: " + t1->kind + " is invalid parameter.", line);
        newTube.valid = false;
    } else if (tube1.diameter != connector.diameter || tube1.diameter != tube2.diameter || connector.diameter != tube2.diameter){
        if (tube1.diameter != connector.diameter){
            saveError("MERGE error: Unmatch diameter between " + tube1.id + " and " + connector.id, line);
            newTube.valid = false;
        }
        if (tube1.diameter != tube2.diameter ){
            saveError("MERGE error: Unmatch diameter between " + tube1.id + " and " + tube2.id, line);
            newTube.valid = false;
        }
        if (tube2.diameter != connector.diameter ){
            saveError("MERGE error: Unmatch diameter between " + tube2.id + " and " + connector.id, line);
            newTube.valid = false;
        }
    } else {
        invalidatedTubeConnector(t1);
        invalidatedTubeConnector(con);
        invalidatedTubeConnector(t2);
        newTube = createTube((id != NULL ? id->kind : ""),tube1.length+tube2.length,tube1.diameter);
    }
    return newTube;
}


Tube pop(AST *a, AST *value, int line){
    Tube newTube;
    newTube.valid = false;
    if (validTubevector(a->kind)){
        Tubevector tubevector;
        tubevector = tubevectors.find(a->kind)->second;
        if (!empty(tubevector)){
            newTube = tubevector.tubes.front();
            newTube.id = value->kind;
            popTube(a);
        }else saveError("Tubevector " + a->kind + " is empty.", line);
        
    }else 
        errorNotDeclared(a,line,"POP");
    return newTube;
}

Connector createConnector (AST *aId, AST *aSize, int line){
    Connector connector;
    connector.id = aId->kind;
    connector.diameter = getSize(child(aSize,0),line);
    connector.valid = (connector.diameter != -1);
    return connector;
}

Tubevector createTubevector(AST *id, AST *value, int line){
    Tubevector newTubevector;
    newTubevector.id = id->kind;
    newTubevector.maxSize = getSize(child(value,0),line);
    newTubevector.valid = newTubevector.maxSize != -1;
    return newTubevector;
}

pair<Tube,Tube> split(AST *a, int line){
    pair<Tube,Tube> newTubes;
    newTubes.first.valid = newTubes.second.valid = false;
    if (tubes.find(a->kind) != tubes.end()){
        Tube tube = tubes.find(a->kind)->second;
        invalidatedTubeConnector(a);
        int newLength = tube.length/2;
        newTubes.first.length = newTubes.second.length = newLength;
        newTubes.first.diameter = newTubes.second.diameter = tube.diameter;
        newTubes.first.valid = newTubes.second.valid = true;
        if (tube.length % 2 != 0){
            ++newTubes.second.length;
        }
    }else errorNotDeclared(a,line,"SPLIT");
    return newTubes;
}

int main() {
  AST *root = NULL;
  ANTLR(plumber(&root), stdin);
  ASTPrint(root);
  evaluateAST(root,1);
  printTubes();
  printConnectors();
  printTubevectors();
  printErrors();
}
>>

#lexclass START
//...
#token NUM "[0-9]+"
#token PLUS "\+"
#token MINUS "\-"
#token PRODUCT "\*"
#token GREATER "\>"
#token SMALLER "\<"
#token EQUAL_EQUAL "\=="
#token ASSIG "\="
#token O_BRACKET "\("
#token C_BRACKET "\)"
#token COMA "\,"
#token TUBE "TUBE"
#token SPLIT "SPLIT"
#token CONNECTOR "CONNECTOR"
#token MERGE "MERGE"
#token LENGTH "LENGTH"
#token DIAMETER "DIAMETER"
#token TUBEVECTOR "TUBEVECTOR"
#token OF "OF"
#token PUSH "PUSH"
#token POP "POP"
#token WHILE "WHILE"
#token ENDWHILE "ENDWHILE"
#token NOT "NOT"
#token AND "AND"
#token OR "OR"
#token FULL "FULL"
#token EMPTY "EMPTY"
#token ID "[a-zA-z0-9]+"
#token SPACE "[\ \n]" << zzskip();>>

plumber: (ops)* <<#0=createASTlist(_sibling);>>;
//...
ops: assigment | length | diameter | loop | push | pop;
//assigment 
assigment: name ASSIG^ assigment_value;
name: ID | (O_BRACKET! ID COMA! ID C_BRACKET!);
//assigment_value
assigment_value: aritmetic | tube | split | connector | merge | tubevector;
//aritmetic
aritmetic: a_term ((PLUS^ | MINUS^) a_term)*;
a_term: ID (PRODUCT^ ID)*;
tube: TUBE^ size size;
split: SPLIT^ ID;
connector: CONNECTOR^ size;
merge: MERGE^ term term term;
tubevector: TUBEVECTOR^ OF! size;
term: ID | merge;
size: NUM | length | diameter;

//length and diameter
length: LENGTH^ O_BRACKET! ID C_BRACKET!;
diameter: DIAMETER^ O_BRACKET! ID C_BRACKET!;

//loop 
loop: WHILE^ O_BRACKET! exp C_BRACKET! plumber ENDWHILE!;
//boolean expression
exp: signed_term (OR^ exp | );
signed_term: ( | NOT^) b_term ( | AND^ signed_term);
b_term: argument | (O_BRACKET! exp C_BRACKET!);
argument: (size (GREATER^ | SMALLER^ | EQUAL_EQUAL^) size) | empty_full;
empty_full: (FULL^ | EMPTY^) O_BRACKET! ID C_BRACKET!;

//push and pop
push: PUSH^ ID ID;
pop: POP^ ID ID;